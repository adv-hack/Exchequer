// Implementation of the "thLines" COM Object
unit oLines;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  Classes, ComCtrls, ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, SysUtils
  , TXRecs, oLine, CustomP, DLLInc;

type
  TTransLineType = Record
    IdNo : SmallInt;
    TLO  : TTradeEventTransLine;
    TLI  : ITradeEventTransLine;
  End;
  pTransLineType = ^TTransLineType;

  TTransLinesFunctionIndex = (fIdxDelete, fIdxAdd);

  TTradeEventTransLines = class(TAutoIntfObject, ITradeEventTransLines)
  private
    // Records changes to properties of this object
    FDataChanged : Boolean;
    FLines       : TList;

    NewTXLineRec : TTXLineRec;

    CurrentLineO : TTradeEventTransLine;
    CurrentLineI : ITradeEventTransLine;

    NewLineO : TTradeEventTransLine;
    NewLineI : ITradeEventTransLine;

    oEventData : TObject;

    Function GetDataChanged : Boolean;

  protected
    function Get_thLine(Index: Integer): ITradeEventTransLine; safecall;
    function Get_thCurrentLine: ITradeEventTransLine; safecall;
    function Get_thLineCount: Integer; safecall;

    procedure Add; safecall;
    procedure Delete(LineNo: Integer); safecall;

    Procedure KillLines;
    // Local Methods
    Procedure AuthoriseFunction(Const FunctionIdx : TTransLinesFunctionIndex; const FuncName : ShortString);
  public
    // properties of this object OR any sub-objects
    IdControl   : TBits;
    bGetCurrentLine : boolean;

    // DataChanged flag indicates whether Plug-Ins made any changes to
    Property DataChanged : Boolean Read GetDataChanged;

    Property Lines : TList Read FLines;

    Constructor Create;
    Destructor Destroy; override;

    Procedure Assign (EventData : TObject);

    Procedure AddAllLines;
  End; { TTradeEventTransLines }

implementation
uses
  CalcPric, oEvent, ComServ, TXHead;

Constructor TTradeEventTransLines.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEventTransaction);

  FLines := TList.Create;
  IdControl := TBits.Create;

  bGetCurrentLine := TRUE;

  CurrentLineO := TTradeEventTransLine.Create;
  CurrentLineI := CurrentLineO;

  NewLineO := TTradeEventTransLine.Create;
  NewLineI := NewLineO;

  FDataChanged := False;
End; { Create }

Destructor TTradeEventTransLines.Destroy;
Begin { Destroy }

  CurrentLineO := nil;
  CurrentLineI := nil;

  NewLineO := nil;
  NewLineI := nil;

  FreeAndNil(FLines);
  FreeAndNil(IdControl);

  Inherited;
End; { Destroy }

Procedure TTradeEventTransLines.Assign(EventData : TObject);
begin { Assign }
  // Reset Datachanged flag for new event
  FDataChanged := False;
  oEventData := EventData;

  // Set Lines
  AddAllLines;

  // Set Current / New Line
  CurrentLineO.Assign(oEventData, self, @TTradeEventData(oEventData).LCurrentTXLineRec, CURRENT_LINE);

  InitialiseTXLine(NewTXLineRec);
  NewLineO.Assign(oEventData, self, @NewTXLineRec, NEW_LINE);

end; { Assign }

// Returns True if the specified function/procedure can be called by the Plug-In during the current event
Procedure TTradeEventTransLines.AuthoriseFunction(Const FunctionIdx : TTransLinesFunctionIndex; const FuncName : ShortString);
var
  Authorised : Boolean;
begin {AuthoriseFunction}

  Authorised := FALSE;

  with TTradeEventData(oEventData) do begin
    case FunctionIdx of
      fIdxDelete, fIdxAdd : begin
        Authorised := HookIsBeforeTenderScreen or HookIsTXHeadCustom1 or HookIsTXHeadCustom2;
      end;
    end; { Case }


    if (not Authorised) then begin
      // Raise exception to notify the user that the Plug-In has been naughty
      raise ERightsError.Create (Format('Customisation Error in ITradeEventTransLines for Event %d.%d - '
      + 'The function %s is not authorised to be called at this time'
      , [FWindowId, FHandlerId, QuotedStr(FuncName)]));
    end;{if}
  end;{with}
end;{AuthoriseFunction}

Function TTradeEventTransLines.GetDataChanged : Boolean;
// Returns TRUE if any properties within the eventdata have been changed

  function AnyLinesChanged : boolean;
  var
    iPos : integer;
    TmpLine : pTransLineType;
  begin{AnyLinesChanged}
    Result := FALSE;
    iPos := 0;
    while (iPos < FLines.Count) Do Begin
      TmpLine := FLines.Items[iPos];
      if TmpLine.TLO.DataChanged then begin
        Result := TRUE;
        Break;
      end;{if}
      inc(iPos);
    end;{while}
  end;{AnyLinesChanged}

Begin { GetDataChanged }
  Result := FDataChanged or CurrentLineO.DataChanged or NewLineO.DataChanged or AnyLinesChanged;
End; { GetDataChanged }


Procedure TTradeEventTransLines.AddAllLines;
Var
  iPos : Integer;
  oLine : pTransLineType;
Begin { AddAllLines }

  KillLines;

  if Assigned(TTradeEventData(oEventData).LListView) then begin
    For iPos := 0 to TTradeEventData(oEventData).LListView.Items.Count - 1 do begin

      // Create and initialise a Transaction Line object
      New (oLine);
      With oLine^ Do Begin
        // Allocate unique Id number
        IdNo := IdControl.OpenBit;
        IdControl.Bits[IdNo] := True;

        // Create lines object
        TLO  := TTradeEventTransLine.Create;
        TLI  := oLine.TLO;
        TLO.Assign(oEventData, Self, @TTXLineInfo(TTradeEventData(oEventData).LListView.items[iPos].Data).TXLineRec, iPos);

      End; { With oLine }

      // Add into Lines List
      FLines.Add(oLine);

    end;{for}
  end;{if}

End;{AddAllLines}

// Empties the Transaction Line List
Procedure TTradeEventTransLines.KillLines;
Var
  TmpLine : pTransLineType;
Begin { KillLines }
  While (FLines.Count > 0) Do Begin
    // remove object references
    TmpLine := FLines.Items[0];
    TmpLine.TLO := Nil;
    TmpLine.TLI := Nil;
    Dispose(TmpLine);

    // Destroy List Entry
    FLines.Delete(0);
  End; { While (FLines.Count > 0) }

  // Shrink TBits to reset all flags back to false
  IdControl.Size := 1;
End; { KillLines }


function TTradeEventTransLines.Get_thLineCount: Integer;
begin
  If Assigned(FLines) Then
    Result := FLines.Count
  Else
    Result := 0;
end;

function TTradeEventTransLines.Get_thCurrentLine: ITradeEventTransLine;
begin
  if bGetCurrentLine then Result := CurrentLineI
  else Result := NewLineI;
end;

function TTradeEventTransLines.Get_thLine(Index: Integer): ITradeEventTransLine;
Var
  oLine : pTransLineType;
begin
  // Check its a valid line number
  If (Index >= 1) And (Index <= FLines.Count) Then Begin
    // Extract interface from list
    oLine := FLines.Items[Index - 1];
    Result := oLine.TLI;
  End { If (Index >= 1) And (Index <= FLines.Count) }
  Else
    Raise EValidation.Create('Invalid Transaction Line Number (' + IntToStr(Index) + ')');
end;

procedure TTradeEventTransLines.Add;
begin
  // Check this function can be called for this event
  AuthoriseFunction(fIdxAdd, 'Add');

  // Reset Current Line
  bGetCurrentLine := FALSE;
  InitialiseTXLine(NewTXLineRec);
  NewTXLineRec.bNonStock := TRUE;
  NewTXLineRec.TKTLRec.VATCode := 'S';
  PopulateOtherThingsAboutThisLine(TTradeEventData(oEventData).LTXRec, NewTXLineRec, (FLines.Count + 1) * 2);

  NewLineO.Assign(oEventData, Self, @NewTXLineRec, NEW_LINE);
end;

procedure TTradeEventTransLines.Delete(LineNo: Integer);
Var
  TmpLine : pTransLineType;
Begin { Delete}
  // Check this function can be called for this event
  AuthoriseFunction(fIdxDelete, 'Delete');

  // Check LineNo is valid
  If (LineNo >= 1) And (LineNo <= FLines.Count) Then Begin
    // remove object references
    TmpLine := FLines.Items[Pred(LineNo)];
    With TmpLine^ Do Begin
      TLO := Nil;
      TLI := Nil;
    End; { With TmpLine }
    Dispose(TmpLine);

    // Destroy List Entry
    FLines.Delete(Pred(LineNo));

    TTradeEventData(oEventData).LListView.Items.Delete(LineNo - 1);

  End { If (LineNo >= 1) And (LineNo <= (FLines.Count)) }
  Else
    Raise EValidation.Create ('ITradeEventTransLines.Delete - Invalid Transaction Line number specified (' + IntToStr(LineNo) + ')');
End; { Delete }

end.

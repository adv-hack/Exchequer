// Implementation of the "thPaymentLines" COM Object
unit OPLINES;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  TXRecs, Classes, ComCtrls, ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, SysUtils
  , EPOSProc, oPayLine, CustomP, DLLInc;

type

//  TPayLinesFunctionIndex = (fIdxDelete, fIdxAdd);

  TTradeEventPaymentLines = class(TAutoIntfObject, ITradeEventPaymentLines)
  private
    // Records changes to properties of this object
    FDataChanged : Boolean;

    FLines       : TList;
    FIdControl   : TBits;

//    CurrentLineO  : TTradeEventPaymentLine;
//    CurrentLineI  : ITradeEventPaymentLine;

    oEventData : TObject;

    Function GetDataChanged : Boolean;

  protected
    function Get_thLine(Index: Integer): ITradeEventPaymentLine; safecall;
//    function Get_thCurrentLine: ITradeEventPaymentLine; safecall;
    function Get_thLineCount: Integer; safecall;

//    procedure Add; safecall;
//    procedure Delete(LineNo: Integer); safecall;

    Procedure KillLines;
    // Local Methods
//    Procedure AuthoriseFunction (Const FunctionIdx : TPayLinesFunctionIndex; const FuncName : ShortString);
  public
    // DataChanged flag indicates whether Plug-Ins made any changes to
    // properties of this object OR any sub-objects
    Property DataChanged : Boolean Read GetDataChanged;
    Property Lines : TList Read FLines;

    Constructor Create;
    Destructor Destroy; override;

    Procedure Assign (EventData : TObject);

    Procedure AddAllLines;
  End; { TTradeEventPaymentLines }

implementation
uses
  EPOSCnst, oEvent, ComServ, TXHead;

type
  TPayLineType = Record
    IdNo : SmallInt;
    PLO  : TTradeEventPaymentLine;
    PLI  : ITradeEventPaymentLine;
  End;

  pPayLineType = ^TPayLineType;


Constructor TTradeEventPaymentLines.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEventTransaction);

  FLines := TList.Create;
  FIdControl := TBits.Create;

//  CurrentLineO := TTradeEventPaymentLine.Create;
//  CurrentLineI := CurrentLineO;

  FDataChanged := False;
End; { Create }

Destructor TTradeEventPaymentLines.Destroy;
Begin { Destroy }

//  CurrentLineO := nil;
//  CurrentLineI := nil;

  FreeAndNil(FLines);
  FreeAndNil(FIdControl);

  Inherited;
End; { Destroy }

Procedure TTradeEventPaymentLines.Assign (EventData : TObject);
var
  BlankTXLineRec : TTXLineRec;
begin { Assign }
  // Reset Datachanged flag for new event
  FDataChanged := False;
  oEventData := EventData;

  AddAllLines;

  // Reset Current Line
//  InitialiseTXLine(BlankTXLineRec);
//  CurrentLineO.Assign (oEventData, @BlankTXLineRec);

end; { Assign }

// Returns True if the specified function/procedure can be called by the Plug-In during the current event
(*
Procedure TTradeEventPaymentLines.AuthoriseFunction (Const FunctionIdx : TPayLinesFunctionIndex; const FuncName : ShortString);
var
  Authorised : Boolean;
begin {AuthoriseFunction}

  Authorised := FALSE;

  with TTradeEventData(oEventData) do begin
{    case FunctionIdx of
      fIdxDelete, fIdxAdd : begin
        Authorised := HookIsBeforeTenderScreen;
      end;
    end; { Case }


    if (not Authorised) then begin
      // Raise exception to notify the user that the Plug-In has been naughty
      raise ERightsError.Create (Format('Customisation Error in ITradeEventPaymentLines for Event %d.%d - '
      + 'The function %s is not authorised to be called at this time'
      , [FWindowId, FHandlerId, QuotedStr(FuncName)]));
    end;{if}
  end;{with}
end;{AuthoriseFunction}
*)

Procedure TTradeEventPaymentLines.AddAllLines;
Var
  iPos : Integer;
  oLine : pPayLineType;
Begin { AddAllLines }

  KillLines;

//    For iPos := 0 to TTradeEventData(oEventData).LListView.Items.Count - 1 do begin
  for iPos := Low(TTradeEventData(oEventData).LTKPayLines) to High(TTradeEventData(oEventData).LTKPayLines) do begin

    if TTradeEventData(oEventData).LTKPayLines[iPos].Desc <> '' then begin

      // Create and initialise a Transaction Line object
      New (oLine);
      With oLine^ Do Begin
        // Allocate unique Id number
        IdNo := FIdControl.OpenBit;
        FIdControl.Bits[IdNo] := True;

        // Create lines object
        PLO  := TTradeEventPaymentLine.Create;
        PLI  := oLine.PLO;
        PLO.Assign(oEventData, @TTradeEventData(oEventData).LTKPayLines[iPos]);

      End; { With oLine }

      // Add into Lines List
      FLines.Add(oLine);

    end;{if}

  end;{for}

End; { AddAllLines }

// Empties the Transaction Line List
Procedure TTradeEventPaymentLines.KillLines;
Var
  TmpLine : pPayLineType;
Begin { KillLines }
  While (FLines.Count > 0) Do Begin
    // remove object references
    TmpLine := FLines.Items[0];
    TmpLine.PLO := Nil;
    TmpLine.PLI := Nil;
    Dispose(TmpLine);

    // Destroy List Entry
    FLines.Delete(0);
  End; { While (FLines.Count > 0) }

  // Shrink TBits to reset all flags back to false
  FIdControl.Size := 1;
End; { KillLines }

// Returns TRUE if any properties within the eventdata have been changed
Function TTradeEventPaymentLines.GetDataChanged : Boolean;

  function AnyLinesChanged : boolean;
  var
    iPos : integer;
    TmpLine : pPayLineType;
  begin{AnyLinesChanged}
    Result := FALSE;
    iPos := 0;
    while (iPos < FLines.Count) Do Begin
      TmpLine := FLines.Items[iPos];
      if TmpLine.PLO.DataChanged then begin
        Result := TRUE;
        Break;
      end;{if}
      inc(iPos);
    end;{while}
  end;{AnyLinesChanged}

Begin { GetDataChanged }
  Result := FDataChanged or AnyLinesChanged;
End; { GetDataChanged }


function TTradeEventPaymentLines.Get_thLineCount: Integer;
begin
  If Assigned(FLines) Then
    Result := FLines.Count
  Else
    Result := 0;
end;

{function TTradeEventPaymentLines.Get_thCurrentLine: ITradeEventPaymentLine;
begin
  Result := CurrentLineI;
end;}

function TTradeEventPaymentLines.Get_thLine(Index: Integer): ITradeEventPaymentLine;
Var
  oLine : pPayLineType;
begin
  // Check its a valid line number
  If (Index >= 1) And (Index <= FLines.Count) Then Begin
    // Extract interface from list
    oLine := FLines.Items[Index - 1];
    Result := oLine.PLI;
  End { If (Index >= 1) And (Index <= FLines.Count) }
  Else
    Raise EValidation.Create('Invalid Payment Line Number (' + IntToStr(Index) + ')');
end;

(*
procedure TTradeEventPaymentLines.Add;
var
  BlankTXLineRec : TTXLineRec;
begin
  // Check this function can be called for this event
  AuthoriseFunction(fIdxAdd, 'Add');

  // Reset Current Line
{  bGetCurrentLine := FALSE;
  InitialiseTXLine(NewTXLineRec);
  NewTXLineRec.bNonStock := TRUE;
  NewTXLineRec.TKTLRec.VATCode := 'S';
  PopulateOtherThingsAboutThisLine(TTradeEventData(oEventData).LTXRec, NewTXLineRec, (FLines.Count + 1) * 2);

  NewLineO.Assign(oEventData, Self, @NewTXLineRec, NEW_LINE);}
end;

procedure TTradeEventPaymentLines.Delete(LineNo: Integer);
Var
  TmpLine : pPayLineType;
Begin { Delete}
  // Check this function can be called for this event
  AuthoriseFunction(fIdxDelete, 'Delete');

  // Check LineNo is valid
  If (LineNo >= 1) And (LineNo <= FLines.Count) Then Begin
    // remove object references
    TmpLine := FLines.Items[Pred(LineNo)];
    With TmpLine^ Do Begin
      PLO := Nil;
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
*)
end.

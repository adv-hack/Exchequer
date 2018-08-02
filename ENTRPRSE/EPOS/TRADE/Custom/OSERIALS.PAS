// Implementation of the "tlSerialNumbers" COM Object
unit oSerials;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  EPOSProc, Classes, ComCtrls, ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, SysUtils
  , TXRecs, CustomP, DLLInc, oSerial;

type

  TSerialsFunctionIndex = (fIdxUnknownfunction);

  TTradeEventSerialNumbers = class(TAutoIntfObject, ITradeEventSerialNumbers)
  private
    // Records changes to properties of this object
    FDataChanged : Boolean;

    FSerialUsed, FSerialAvailable : TList;
    FUsedIdControl, FAvailableIdControl   : TBits;

    lslAvailableSerials, lslUsedSerials : TStrings;

    lTXLineRec : pTXLineRec;
    oEventData, oLineData : TObject;

    Function GetDataChanged : Boolean;

  protected
    function Get_snUsed(Index: Integer): ITradeEventSerialNo; safecall;
    function Get_snAvailable(Index: Integer): ITradeEventSerialNo; safecall;
    function Get_snUsedCount: Integer; safecall;
    function Get_snAvailableCount: Integer; safecall;
    procedure Select(Index: Integer; Quantity: Integer); safecall;
    procedure Deselect(Index: Integer; Quantity: Integer); safecall;
    procedure Refresh; safecall;

    Procedure KillSerials(FSerials : TList);
    // Local Methods
    Procedure AuthoriseFunction (Const FunctionIdx : TSerialsFunctionIndex; const FuncName : ShortString);
  public
    // DataChanged flag indicates whether Plug-Ins made any changes to
    // properties of this object OR any sub-objects
    Property DataChanged : Boolean Read GetDataChanged;
    Property Used : TList Read FSerialUsed;
    Property Available : TList Read FSerialAvailable;

    Constructor Create;
    Destructor Destroy; override;

    Procedure Assign(EventData, LineData : TObject);

    Procedure FillLists;
  End; { TTradeEventSerialNumbers }

implementation
uses
  oEvent, ComServ, TXHead, MiscUtil, {NeilProc,} oLine, SerialPrc;

type
  TSerialNumberType = Record
    IdNo : SmallInt;
    SerialO  : TTradeEventSerialNo;
    SerialI  : ITradeEventSerialNo;
  End;
  pSerialNumberType = ^TSerialNumberType;


Constructor TTradeEventSerialNumbers.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEventTransaction);

  FSerialUsed := TList.Create;
  FSerialAvailable := TList.Create;

  FUsedIdControl := TBits.Create;
  FAvailableIdControl := TBits.Create;

  lslAvailableSerials := TStringList.Create;

  FDataChanged := False;
End; { Create }

Destructor TTradeEventSerialNumbers.Destroy;
Begin { Destroy }

  FreeAndNil(FSerialUsed);
  FreeAndNil(FSerialAvailable);

  FreeAndNil(FUsedIdControl);
  FreeAndNil(FAvailableIdControl);

  ClearList(lslAvailableSerials);
  lslAvailableSerials.Free;

  Inherited;
End; { Destroy }

Procedure TTradeEventSerialNumbers.Assign(EventData, LineData : TObject);
begin { Assign }
  // Reset Datachanged flag for new event
  FDataChanged := False;
  oEventData := EventData;
  oLineData := LineData;

  lTXLineRec := TTradeEventTransLine(oLineData).LTXLineRec;

  lslUsedSerials := lTXLineRec.SerialNumbers;

  FillLists;

end; { Assign }

// Returns True if the specified function/procedure can be called by the Plug-In during the current event
Procedure TTradeEventSerialNumbers.AuthoriseFunction (Const FunctionIdx : TSerialsFunctionIndex; const FuncName : ShortString);
begin

  //
  // This section needs to be coded once some functions are added in
  //
  Raise Exception.Create ('TTradeEventSerialNumbers.AuthoriseFunction Not Implemented - Please notify your technical support');

  { TODO -cDO : TTradeEventSerialNumbers.AuthoriseFunction Not Implemented }

end;


Procedure TTradeEventSerialNumbers.FillLists;
Var
  iPos : Integer;
  oSerial : pSerialNumberType;
  fmLineMode : TFormMode;
Begin { FillLists }

  // Fill Used List
  KillSerials(FSerialUsed);
  FUsedIdControl.Size := 1; // Shrink TBits to reset all flags back to false

  if Assigned(lslUsedSerials) then begin
    For iPos := 0 to lslUsedSerials.Count - 1 do begin

      // Create and initialise a Serial object
      New (oSerial);
      With oSerial^ Do Begin
        // Allocate unique Id number
        IdNo := FUsedIdControl.OpenBit;
        FUsedIdControl.Bits[IdNo] := True;

        // Create lines object
        SerialO := TTradeEventSerialNo.Create;
        SerialI := oSerial.SerialO;
        SerialO.Assign(oEventData, TSerialInfo(lslUsedSerials.Objects[iPos])
        , TSerialInfo(lslUsedSerials.Objects[iPos]).UsedInThisLine
        , TSerialInfo(lslUsedSerials.Objects[iPos]).UsedInThisLine
        + TSerialInfo(lslUsedSerials.Objects[iPos]).UsedElsewhere, TRUE);

      End; { With oSerial }

      // Add into Lines List
      FSerialUsed.Add(oSerial);

    end;{for}
  end;{if}


  // Fill Available List
  KillSerials(FSerialAvailable);
  FAvailableIdControl.Size := 1; // Shrink TBits to reset all flags back to false

  fmLineMode := fmAdd;  // should be set according to hook position ?

  ClearList(lslAvailableSerials);

  BuildSerialAvailableList(lTXLineRec.TKTLRec.StockCode, TTradeEventData(oEventData).LTXRec.bRefund, lslUsedSerials
  , TTradeEventData(oEventData).LListView, fmLineMode, lslAvailableSerials);

  if Assigned(lslAvailableSerials) then begin
    For iPos := 0 to lslAvailableSerials.Count - 1 do begin

      // Create and initialise a Transaction Line object
      New (oSerial);
      With oSerial^ Do Begin
        // Allocate unique Id number
        IdNo := FAvailableIdControl.OpenBit;
        FAvailableIdControl.Bits[IdNo] := True;

        // Create lines object
        SerialO := TTradeEventSerialNo.Create;
        SerialI := oSerial.SerialO;
        SerialO.Assign(oEventData, TSerialInfo(lslAvailableSerials.Objects[iPos]), 0
        , TSerialInfo(lslAvailableSerials.Objects[iPos]).UsedElsewhere, FALSE);

      End; { With oSerial }

      // Add into Lines List
      FSerialAvailable.Add(oSerial);

    end;{for}
  end;{if}

End; { FillLists }

// Empties the Transaction Line List
Procedure TTradeEventSerialNumbers.KillSerials(FSerials : TList);
Var
  TmpLine : pSerialNumberType;
Begin { KillLines }
  While (FSerials.Count > 0) Do Begin
    // remove object references
    TmpLine := FSerials.Items[0];
    TmpLine.SerialO := Nil;
    TmpLine.SerialI := Nil;
    Dispose(TmpLine);

    // Destroy List Entry
    FSerials.Delete(0);
  End; { While (FSerials.Count > 0) }

End; { KillLines }

function TTradeEventSerialNumbers.Get_snAvailableCount: Integer;
begin
  If Assigned(FSerialAvailable) Then
    Result := FSerialAvailable.Count
  Else
    Result := 0;
end;

function TTradeEventSerialNumbers.Get_snUsedCount: Integer;
begin
  If Assigned(FSerialUsed) Then
    Result := FSerialUsed.Count
  Else
    Result := 0;
end;

procedure TTradeEventSerialNumbers.Refresh;
begin
  FillLists;
end;

function TTradeEventSerialNumbers.Get_snAvailable(Index: Integer): ITradeEventSerialNo;
Var
  oAvailable : pSerialNumberType;
begin
  // Check its a valid line number
  If (Index >= 1) And (Index <= FSerialAvailable.Count) Then Begin
    // Extract interface from list
    oAvailable := FSerialAvailable.Items[Index - 1];
    Result := oAvailable.SerialI;
  End { If (Index >= 1) And (Index <= FSerials.Count) }
  Else
    Raise EValidation.Create('Invalid Available Serial Number Line Number (' + IntToStr(Index) + ')');
end;

function TTradeEventSerialNumbers.Get_snUsed(Index: Integer): ITradeEventSerialNo;
Var
  oUsed : pSerialNumberType;
begin
  // Check its a valid line number
  If (Index >= 1) And (Index <= FSerialUsed.Count) Then Begin
    // Extract interface from list
    oUsed := FSerialUsed.Items[Index - 1];
    Result := oUsed.SerialI;
  End { If (Index >= 1) And (Index <= FSerials.Count) }
  Else
    Raise EValidation.Create('Invalid Used Serial Number Line Number (' + IntToStr(Index) + ')');
end;

procedure TTradeEventSerialNumbers.Deselect(Index, Quantity: Integer);
begin
  Index := Index - 1;
  MoveSerialItem(FALSE, lslUsedSerials, lslAvailableSerials, Index, GetSerialPicked(lslUsedSerials)
  , Round(ABS(lTXLineRec.TKTLRec.Qty)), Quantity);
  FillLists;
  FDataChanged := TRUE;
end;

procedure TTradeEventSerialNumbers.Select(Index, Quantity: Integer);
begin
  Index := Index - 1;
  MoveSerialItem(TRUE, lslUsedSerials, lslAvailableSerials, Index, GetSerialPicked(lslUsedSerials)
  , Round(ABS(lTXLineRec.TKTLRec.Qty)), Quantity);
  FillLists;
  FDataChanged := TRUE;
end;

// Returns TRUE if any properties within the eventdata have been changed
Function TTradeEventSerialNumbers.GetDataChanged : Boolean;

  function AnySerialsChanged(FSerials : TList) : boolean;
  var
    iPos : integer;
    TmpSerial : pSerialNumberType;
  begin{AnyLinesDataChanged}
    Result := FALSE;
    iPos := 0;
    while (iPos < FSerials.Count) Do Begin
      TmpSerial := FSerials.Items[iPos];
      if TmpSerial.SerialO.DataChanged then begin
        Result := TRUE;
        Break;
      end;{if}
      inc(iPos);
    end;{while}
  end;{AnyLinesDataChanged}

Begin { GetDataChanged }
  Result := FDataChanged or AnySerialsChanged(FSerialUsed) or AnySerialsChanged(FSerialAvailable);
End; { GetDataChanged }

end.

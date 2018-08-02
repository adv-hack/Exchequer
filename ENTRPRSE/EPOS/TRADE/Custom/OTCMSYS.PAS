unit oTCMSys;

Interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, oTill, Classes, SysUtils
  , TillName, CentData, CustomP, EPOSCnst;

type
  TTradeTCMSetup = class(TAutoIntfObject, ITradeTCMSetup)
  private
    FTills       : TList;
    FIdControl   : TBits;

    oEventData : TObject;
    FDataChanged : Boolean;

//    Function GetDataChanged : Boolean;
//    FTillsO : TTradeTCMSetupTills;
//    FTillsI : ITradeTCMSetupTills;
  protected
    function Get_ssNoOfTills: Integer; safecall;
    function Get_ssTill(Index: Integer): ITradeTCMSetupTill; safecall;
    function Get_ssCurrentTillNo: Integer; safecall;
    function Get_ssLocalTradeDir: WideString; safecall;
    Procedure KillTills;
  public
    // DataChanged flag indicates whether Plug-Ins made any changes to
//    Property DataChanged : Boolean Read GetDataChanged;

    Property Tills : TList Read FTills;
    Constructor Create;
    Destructor Destroy; override;
    Procedure CreateTillObjects;
//    Procedure Assign(EventData : TObject);
  End; { TTradeTCMSetup }

implementation

uses
  Forms, ComServ;

type
  TTillType = Record
    IdNo : SmallInt;
    TillO  : TTradeTCMSetupTill;
    TillI  : ITradeTCMSetupTill;
  End;
  pTillType = ^TTillType;

{-------------------------------------------------------------------------------------------------}

Constructor TTradeTCMSetup.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeTCMSetup);

  FTills := TList.Create;
  FIdControl := TBits.Create;

  CreateTillObjects;

  FDataChanged := False;
//  FTillsO := TTradeTCMSetupTills.create;
//  FTillsI := FTillsO;

End; { Create }

Destructor TTradeTCMSetup.Destroy;
Begin { Destroy }
//  FTillsO := nil;
//  FTillsI := nil;
  FreeAndNil(FTills);
  FreeAndNil(FIdControl);

  Inherited;
End; { Destroy }
(*
Function TTradeTCMSetup.GetDataChanged : Boolean;
// Returns TRUE if any properties within the eventdata have been changed

  function AnyTillsChanged : boolean;
  var
    iPos : integer;
    TmpTill : pTillType;
  begin{AnyLinesChanged}
    Result := FALSE;
    iPos := 0;
    while (iPos < FTills.Count) Do Begin
      TmpTill := FTills.Items[iPos];
      if TmpTill.TillO.DataChanged then begin
        Result := TRUE;
        Break;
      end;{if}
      inc(iPos);
    end;{while}
  end;{AnyTillsChanged}

Begin { GetDataChanged }
  Result := FDataChanged or AnyTillsChanged;
End; { GetDataChanged }

Procedure TTradeTCMSetup.Assign(EventData : TObject);
begin { Assign }
  // Reset Datachanged flag for new event
  FDataChanged := False;
  oEventData := EventData;
end; { Assign }
*)
Procedure TTradeTCMSetup.CreateTillObjects;
Var
  iPos : Integer;
  oTill : pTillType;
  oTillInfo : TTillInfo;
  oCentTillInfo : TCentralTillInfo;
Begin { CreateTillObjects }

  KillTills;

//  oTillInfo := TTillInfo.Load(TRUE);
  oTillInfo := TTillInfo.Load(FALSE);

  For iPos := 0 to oTillInfo.Names.Count - 1 do begin
    oCentTillInfo := TCentralTillInfo.Load(iPos + 1);

    New (oTill);
    With oTill^ Do Begin
      // Allocate unique Id number
      IdNo := FIdControl.OpenBit;
      FIdControl.Bits[IdNo] := True;

      // Create Till objects
      TillO := TTradeTCMSetupTill.Create(oCentTillInfo.SetupRec, oTillInfo.Names[iPos], iPos + 1);
      TillI := oTill.TillO;
//      TillO.Assign(oEventData, oCentTillInfo.SetupRec);

    End; { With oTill }

   // Add into Tills List
    FTills.Add(oTill);

    oCentTillInfo.Unload;

  end;{For}

  oTillInfo.Unload;

end; { CreateTillObjects }

Procedure TTradeTCMSetup.KillTills;
Var
  TmpLine : pTillType;
Begin { KillTills }
  While (FTills.Count > 0) Do Begin
    // remove object references
    TmpLine := FTills.Items[0];
    TmpLine.TillO := Nil;
    TmpLine.TillI := Nil;
    Dispose(TmpLine);

    // Destroy List Entry
    FTills.Delete(0);
  End; { While (FTills.Count > 0) }

  // Shrink TBits to reset all flags back to false
  FIdControl.Size := 1;
End; { KillTills }

function TTradeTCMSetup.Get_ssNoOfTills: Integer;
begin
  If Assigned(FTills) Then
    Result := FTills.Count
  Else
    Result := 0;
end;

function TTradeTCMSetup.Get_ssTill(Index: Integer): ITradeTCMSetupTill; safecall;
Var
  oTill : pTillType;
begin
  // Check its a valid line number
  If (Index >= 1) And (Index <= FTills.Count) Then Begin
    // Extract interface from list
    oTill := FTills.Items[Index - 1];
    Result := oTill.TillI;
  End { If (Index >= 1) And (Index <= FTills.Count) }
  Else
    Raise EValidation.Create('Invalid Till Number (' + IntToStr(Index) + ')');
end;

function TTradeTCMSetup.Get_ssCurrentTillNo: Integer;
begin
  Result := iTillNo;
end;

function TTradeTCMSetup.Get_ssLocalTradeDir: WideString;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

end.

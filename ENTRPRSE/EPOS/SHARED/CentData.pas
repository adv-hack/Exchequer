unit CentData;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  Classes, EPOSCnst;

type
  TCentralTillInfo = Class
    public
      TillNo : integer;
      LastErrorNo : integer;
      SetupRec : TEposSetupRec;
      constructor Load(iLocTillNo : Integer);
      procedure GetTillInfo(iLocTillNo : Integer);
      function SaveTillInfo : boolean;
      destructor Unload;
    private
      iLockPos : integer;
  end;

implementation
uses
  GlobVar, BtrvU2, APIUtil, Dialogs, BTSupU1;


constructor TCentralTillInfo.Load(iLocTillNo : Integer);
var
  sKey : str255;
begin
  inherited create;
  FillChar(SetupRec, SizeOf(SetupRec),#0);
  if OpenEPOSBtrv(EPOSCentF) then GetTillInfo(iLocTillNo);
end;

procedure TCentralTillInfo.GetTillInfo(iLocTillNo : Integer);
var
  sKey : str255;
begin
  if iLocTillNo > 0 then begin

    TillNo := iLocTillNo;

    sKey := Char(iLocTillNo);

    {Get record}
    LastErrorNo := Find_Rec(B_GetGEq, F[EposCentF], EposCentF, RecPtr[EposCentF]^, 0, sKey);
    if EposCentRec.RecPFix <> Char(iLocTillNo) then LastErrorNo := 4;

    case LastErrorNo of
      0 : begin
        {Found OK}
        GetPos(F[EposCentF], EposCentF, iLockPos);
        SetupRec := EposCentRec.EposSetup;
      end;

      4,9 : ;

      84 : {record locked} ;

      else Report_BError(EposCentF,LastErrorNo);
    end;{case}
  end;{if}
end;

function TCentralTillInfo.SaveTillInfo: boolean;
var
  sKey : str255;
  iStatus : integer;
begin
  if TillNo > 0 then begin

    sKey := Char(TillNo);

    {Get (and lock) record}
    LastErrorNo := Find_Rec(B_GetGEq + B_MultNWLock, F[EposCentF], EposCentF, RecPtr[EposCentF]^, 0, sKey);
    if EposCentRec.RecPFix <> Char(TillNo) then LastErrorNo := 4;

    case LastErrorNo of
      0 : begin
        {Found OK}
        GetPos(F[EposCentF], EposCentF, iLockPos);

        // write new record
        EposCentRec.EposSetup := SetupRec;
        Result := Put_Rec(F[EposCentF], EposCentF, RecPtr[EposCentF]^, 0) = 0;

        // unlock
        UnLockMultiSing(F[EposCentF], EposCentF, iLockPos);

      end;

      4,9 : begin {not found, so add a new record}

        // write new record
        EposCentRec.RecPFix := Char(TillNo);
        EposCentRec.EposSetup := SetupRec;

        {Add Record}
        iStatus := Add_Rec(F[EposCentF],EposCentF,RecPtr[EposCentF]^,CurrKeyPath^[EposCentF]);
        Report_BError(EposCentF,iStatus);
        Result := iStatus = 0;
      end;

//      84 : {record locked} ;

      else Report_BError(EposCentF,LastErrorNo);
    end;{case}

  end;{if}

end;

destructor TCentralTillInfo.Unload;
begin
  inherited destroy;
end;

end.

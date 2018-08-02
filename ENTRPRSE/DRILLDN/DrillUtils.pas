unit DrillUtils;

interface

uses
  SysUtils, ExWrap1U, GlobVar;

type
  PExLocal = ^TdExLocal;

function FormatBFloat(FMask: Str255; Value: Double; SBlnk: Boolean): Str255;
function FormatCurFloat(Fmask: Str255; Value: Double; SBlnk: Boolean;
  Cr: Byte): Str255;
procedure Link2Inv(ExLocal: PExLocal);

implementation

uses
  VarConst,
  BtSupU1,
  BtKeys1U,
  BtrvU2;

//=============================================================================
// Utility Functions
//=============================================================================
function FormatBFloat(FMask: Str255; Value: Double; SBlnk: Boolean): Str255;
{ --- Copied from X:\Entrprse\R&D\SalTxl1U.pas and amended ----------------- }
begin
  if (Value <> 0.0) or (not SBlnk) then
    Result := FormatFloat(Fmask, Value)
  else
    Result := '';
end;

function FormatCurFloat(Fmask: Str255; Value: Double; SBlnk: Boolean;
  Cr: Byte): Str255;
{ --- Copied from X:\Entrprse\R&D\SalTxl1U.pas and amended ----------------- }
var
  GenStr: Str5;
begin
  GenStr := '';
  {$IFDEF MC_On}
    GenStr:=SSymb(Cr);
  {$ENDIF}
  if (Value<>0.0) or (not SBlnk) then
    Result := GenStr + FormatFloat(Fmask, Value)
  else
    Result := '';
end;

procedure Link2Inv(ExLocal: PExLocal);
{ --- Copied from X:\Entrprse\R&D\SLTI1U.pas and amended --------------------- }
const
  Fnum     =  InvF;
  KeyPath2 =  InvFolioK;
var
  TmpKPath,
  TmpStat:  Integer;
  TmpRecAddr:  LongInt;
  KeyS   :  Str255;
begin
  if (ExLocal^.LInv.FolioNum<>Id.FolioRef) then
  begin
    TmpKPath := GetPosKey;

    TmpStat := Presrv_BTPos(Fnum, TmpKPath, F[Fnum], TmpRecAddr, BOff, BOff);

    ResetRec(Fnum);

    KeyS := FullNomKey(Id.FolioRef);

    if (Id.FolioRef <> 0) then
      Status := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath2, KeyS);

    ExLocal^.AssignFromGlobal(Fnum);

    TmpStat := Presrv_BTPos(Fnum, TmpKPath, F[Fnum], TmpRecAddr, BOn, BOff);
  end;
end;

end.

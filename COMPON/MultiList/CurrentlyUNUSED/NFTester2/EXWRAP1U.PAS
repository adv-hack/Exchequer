unit ExWrap1U;

{ nfrewer440 09:07 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,GlobVar,VarConst,BtrvU2,BtSupU1;


type
  TdExLocalPtr = ^TdExLocal;

  TdExLocal = Object
    LItemRec, LastItemRec : ItemRecType;
    LGroupRec, LastGroupRec : GroupRecType;
    LCust, LastCust : CustRec;
    LInv, LastInv : InvRec;
    LSalesDet, LastSalesDet :  SalesDetRecType;
    LTillSales, LastTillSales : TillSalesRec;

    LRecPtr : array[1..MaxFiles] of RecCPtr;
    StartNo : Integer;
    EndNo : Integer;
    LastIns : Boolean;
    LastEdit : Boolean;
    InAddEdit : Boolean;
    LForcedAdd : Boolean;
    LViewOnly : Boolean;
    LastRecAddr : array[1..MaxFiles] of LongInt;
    constructor Create;
    destructor Destroy;
    procedure LResetRec(FNum : Integer);
    procedure LSetDataRecOfs(FileNum : Integer; Ofset : LongInt);
    procedure SetStart(IdxNo : Integer);
    procedure AssignFromGlobal(IdxNo : Integer);
    procedure AssignToGlobal(IdxNo : Integer);
    procedure LGetRecAddr(Fnum : Integer);
    function LGetMainRecPos(Fnum : SmallInt; KeyS : Str255) : Boolean;
    function LGetMainRecPosKey(Fnum, KPath : SmallInt; KeyS : Str255) : Boolean;
    function LGetDirectRec(Fnum, KeyPath : Integer) : Integer;
    function UnLockMLock(Fnum : Integer; LRAddr : LongInt) : Integer;
    function LPresrv_BTPos(Fnum      :  Integer;
                       var Keypath   :  Integer;
                       var LFV       :  FileVar;
                       var RecAddr   :  LongInt;
                           UsePos,
                           RetRec    :  Boolean)  :  Integer;
    function LGetMultiRec(Func      :  Integer;
                          LockType  :  Integer;
                      var Key2S     :  Str255;
                          KeyPth    :  Integer;
                          Fnum      :  Integer;
                          Wait      :  Boolean;
                      var Locked    :  Boolean) : Boolean;
 end;{TdEXLocal}

implementation
uses
   Dialogs, Forms, ETMiscU, ETStrU, BTKeys1U, BTSFrmU1;


{ ============== TdExLocal Methods ============== }
constructor TdExLocal.Create;

begin
  LastEdit := FALSE;
  InAddEdit := FALSE;
  LastIns := FALSE;
  LForcedAdd := FALSE;
  FillChar(LastRecAddr,Sizeof(LAstRecAddr),0);

  // Init LCust details
  LRecPtr[CustF] := @LCust;
  LResetRec(CustF);
  FillChar(LastCust,Sizeof(LastCust),0);

  // Init LInv details
  LRecPtr[InvF] := @LInv;
  LResetRec(InvF);
  FillChar(LastInv,Sizeof(LastInv),0);

  // Init LItemRec details
  LRecPtr[ItemF] := @LItemRec;
  LResetRec(ItemF);
  FillChar(LastItemRec,Sizeof(LastItemRec),0);

  // Init LGroupRec details
  LRecPtr[GroupF] := @LGroupRec;
  LResetRec(GroupF);
  FillChar(LastGroupRec,Sizeof(LastGroupRec),0);

  // Init LSalesDet details
  LRecPtr[SalesDetF] := @LSalesDet;
  LResetRec(SalesDetF);
  FillChar(LastSalesDet,Sizeof(LastSalesDet),0);

  // Init LSalesDet details
  LRecPtr[TillSalesF] := @LTillSales;
  LResetRec(TillSalesF);
  FillChar(LastTillSales,Sizeof(LastTillSales),0);
end;


destructor TdExLocal.Destroy;
begin
end;


{ ================ Procedure to Reset Current Record ============== }
procedure TdExLocal.LResetRec(FNum : Integer);
begin
  case Fnum of
    GroupF : FillChar(LGroupRec,FileRecLen[FNum],0);
    ItemF : FillChar(LItemRec,FileRecLen[FNum],0);
    CustF : FillChar(LCust,FileRecLen[FNum],0);
    InvF : FillChar(LInv,FileRecLen[FNum],0);
    SalesDetF : FillChar(LSalesDet,FileRecLen[FNum],0);
    TillSalesF : FillChar(LTillSales,FileRecLen[FNum],0);
  end;{case}
end;


{ ============ Low Level Proc to Set Data Record for 4-byte offset ========== }
procedure TdExLocal.LSetDataRecOfs(FileNum : Integer; Ofset : LongInt);
begin
  Move(Ofset,LRecPtr[FileNum]^,Sizeof(Ofset));
end;

procedure TdExLocal.SetStart(IdxNo  :  Integer);
begin
  if (IdxNo = 0) then
    begin
      StartNo := 1;
      EndNo := TotFiles;
    end
  else begin
    StartNo := IdxNo;
    EndNo := IdxNo;
  end;{if}
end;

procedure TdExLocal.AssignFromGlobal(IdxNo : Integer);
var
  iPos : Integer;
begin
  SetStart(IdxNo);
  for iPos := StartNo to EndNo do begin
    case iPos of
      GroupF : LGroupRec := GroupRec;
      ItemF : LItemRec := ItemRec;
      CustF : LCust := Cust;
      InvF : LInv := Inv;
      SalesDetF : LSalesDet := SalesDetRec;
      TillSalesF : LTillSales := TillSales;
    end;{case}
  end;{for}
end;


procedure TdExLocal.AssignToGlobal(IdxNo  :  Integer);
var
  iPos : Integer;
begin
  SetStart(IdxNo);
  for iPos := StartNo to EndNo do begin
    case iPos of
      GroupF : GroupRec := LGroupRec;
      ItemF : ItemRec := LItemRec;
      CustF : Cust := LCust;
      InvF : Inv := LInv;
      SalesDetF : SalesDetRec := LSalesDet;
      TillSalesF : TillSales := LTillSales;
    end;{case}
  end;{for}
end;

procedure TdExLocal.LGetRecAddr(Fnum :  Integer);
begin
  Status := GetPos(F[Fnum],Fnum,LastRecAddr[Fnum]);
end;


function tdExLocal.LGetMainRecPos(Fnum : SmallInt; KeyS : Str255) : Boolean;
begin
  Result := LGetMainRecPosKey(Fnum,0,KeyS);
end;


function tdExLocal.LGetMainRecPosKey(Fnum,KPath : SmallInt;KeyS : Str255) : Boolean;
var
  CStatus : SmallInt;
begin
  CStatus := Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KPath,KeyS);
  Result := (CStatus = 0);
  if (not Result) then LResetRec(Fnum);
end;


function TdExLocal.LGetDirectRec(Fnum, KeyPath : Integer) : Integer;
begin
  LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);
  Result := GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,0); {* Re-Establish Position *}
end;

function TdExLocal.UnLockMLock(Fnum : Integer; LRAddr : LongInt) : Integer;
var
  KeyS    :  Str255;
  DumRec  :  array[1..4000] of Char;
begin
  if (LRAddr = 0) then LGetRecAddr(Fnum)
  else LastRecAddr[Fnum] := LRAddr;

  {* Preserve Record *}
  Move(LRecPtr[Fnum]^,DumRec,FileRecLen[Fnum]);
  LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);
  Result:=Find_Rec(B_Unlock,F[Fnum],Fnum,LRecPtr[Fnum]^,-1,KeyS);

  {* Restore Record *}
  Move(DumRec,LRecPtr[Fnum]^,FileRecLen[Fnum]);
end; {Func..}


{ ======= General Routine to Atempt a Record Lock ========= }

function TdExLocal.LGetMultiRec(Func      :  Integer;
                                LockType  :  Integer;
                            var Key2S     :  Str255;
                                KeyPth    :  Integer;
                                Fnum      :  Integer;
                                Wait      :  Boolean;
                            var Locked    :  Boolean) : Boolean;
var
  Bcode,
  Fcode    :  Integer;
  MbRet    :  Word;
  TmpForm  :  TBTWaitLock;
begin
  Locked := BOff;
  BCode := Try_Lock(Func,B_SingNWLock + LockType,Key2S,Keypth,Fnum,LRecPtr[Fnum]);

  if (Bcode <> 0) then
    begin
      case Bcode of
        81 : Report_Berror(Fnum,BCode);  {* Lock table full *}
        84,85 : begin
          {$IFDEF Su_On}
            mbRet := MessageDlg('Network Violation! - Closing System',mtError,[mbOk],0);
            Halt;
          {$ELSE}
            if Wait then
              begin
                TmpForm := TBTWaitLock.Create(Application.Mainform);
                try
                  TMpForm.Init_Test(Func,Fnum,Keypth,LockType,Key2S,LRecPtr[Fnum],nil);
                  BCode := (TmpForm.ShowModal-mrOk);
                finally
                  TmpForm.Free;
                end;{try}
                Locked := (Bcode = 0);
              end
            else begin
              {* Establish if record found at all *}
              Fcode := Find_Rec(Func,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPth,Key2s);
              repeat
                mbRet := MessageDlg('Record in use by another station!', MtConfirmation,[mbRetry,mbCancel],0);
                BCode := Try_Lock(Func,B_SingNWLock + LockType,Key2S,Keypth,Fnum,LRecPtr[Fnum]);
              until (MbRet = IdCancel) or (Bcode = 0);
              Locked := (Bcode = 0);
              Bcode := Fcode;{* Set record found *}
            end;{if}
          {$ENDIF}
        end;

        22 : begin
          Locked := (VariFile[Fnum]);
          If (Locked) then Bcode := 0;
        end;
      end;{case}
    end
  else Locked := BOn;
  Addch := #0; {* Reset Lock Key *}
  LGetMultiRec := (Bcode = 0);
end;


function TdExLocal.LPresrv_BTPos(Fnum      :  Integer;
                             var Keypath   :  Integer;
                             var LFV       :  FileVar;
                             var RecAddr   :  LongInt;
                                 UsePos,
                                 RetRec    :  Boolean)  :  Integer;
var
  TmpStat    :  Integer;
  DumRec     :  array[1..4000] of Char;
begin
  if (UsePos) then
    begin
      if (RecAddr <> 0) and (Keypath >= 0) then
        begin
          FillChar(DumRec,Sizeof(DumRec),0);
          Move(RecAddr,DumRec,Sizeof(RecAddr));
          TmpStat := GetDirect(LFV,Fnum,DumRec,Keypath,0); {* Re-Establish Position *}
          if (TmpStat = 0) and (RetRec) then Move(DumRec,LRecPtr[Fnum]^,FileRecLen[Fnum]);
        end
      else TmpStat := 8;
    end
  else begin
    RecAddr := 0;
    TmpStat := GetPos(LFV,Fnum,RecAddr);
    if (Keypath = GetPosKey) then begin
      {* Calculate current key from pos blk *}
      if (TmpStat = 0) then Keypath := CurrKeyPath^[Fnum]
      else KeyPath := 0;
    end;{if}
  end;{if}
  LPresrv_BTPos := TmpStat;
end;

initialization

finalization

end.

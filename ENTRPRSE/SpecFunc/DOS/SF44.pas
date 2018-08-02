procedure SetDocGLCtrl(var TotalCount, LCount: LongInt; var RunOk: Boolean);
const
  Fnum     = InvF;
  Keypath  = InvRNoK;
  Fnum2    = CustF;
  Keypath2 = CustCodeK;
var
  KeyChk2: Str255;
  KeyChk : Str255;
  KeyS   : Str255;
  Loop   : Boolean;
  B_Func : Integer;
begin

  Loop := BOff;

  B_Func := B_GetNext;

  KeyChk := FullNomKey(0);

  KeyS := KeyChk + #1;

  Status := Find_Rec(B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);

  while (StatusOk) and (RunOk) and (CheckKey(KeyChk, KeyS, Length(KeyChk), BOn)) do
    with Inv do
    begin
  
      Loop_CheckKey(RunOk);
  
      if (InvDocHed in SalesSplit + PurchSplit - [SBT, PBT]) then
      begin
        KeyChk2 := FullCustCode(CustCode);

        // Locate the matching Customer/Supplier record.  
        If (Cust.CustCode <> CustCode) then
          Status := Find_Rec(B_GetEq, F[Fnum2], Fnum2, RecPtr[Fnum2]^, Keypath2, KeyChk2);
  
        if (Status = 0) then
        begin
          CtrlNom := Cust.DefCtrlNom;
  
          Status := Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);
  
          if (not StatusOk) then
          begin
            Write_FixLog(FNum,'Unable to write data to file, report error ' + Form_Int(Status, 0));
          end;
  
        end;
  
      end;
  
      Inc(LCount);

      Show_Bar(Round(DivWChk(LCount, TotalCount) * 100), PBarW);
  
      Status := Find_Rec(B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
  
    end; { with Inv do... }

end;

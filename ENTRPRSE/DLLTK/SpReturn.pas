unit SpReturn;

{$ALIGN 1}
interface

uses
  Classes;

{$I ExchCtk.inc}

function SP_CREATERETURN(P     : Pointer;
                          PSize : longint;
                          P2 : Pointer;
                          P2Size : longint) : SmallInt;
                          STDCALL  EXPORT;

function SP_ACTIONRETURN(P     : Pointer;
                         PSize : longint;
                         P2 : Pointer;
                         P2Size : longint) : SmallInt;
                          STDCALL  EXPORT;


implementation

uses
  RetSup1U,
  EtStrU,
  ExWrap1U,
  GlobVar,
  BtrvU2,
  BtKeys1U,
  VarConst,
  Dialogs,
  SysU1,
  Enterprise01_TLB,
  RetInpU,
{  SOPB2BWU,}
  BtSupU1,
  SysUtils;


function SP_ACTIONRETURN(P     : Pointer;
                         PSize : longint;
                          P2 : Pointer;
                          P2Size : longint) : SmallInt;
var
  ActionRec : ^TBatchReturnActionRec;
  WizRec    : tRetWizRec;
  ExLocal   :  TdExLocal;
  Keys : Str255;
  Res : Integer;
  TmpRes : Boolean;
begin
  if P <> nil then
  begin
    if PSize = SizeOf(TBatchReturnActionRec) then
    begin
      Result := 0;
      ExLocal.Create;
      Try
        ActionRec := P;
        Move(P2^, WizRec.rwDoc, P2Size);
        WizRec.rwWizMode := 1;
        WizRec.rwPAction := 60 + ActionRec.Action;
        WizRec.rwDocHed := WizRec.rwDoc.InvDocHed;
        WizRec.rwMatch := ActionRec.CreditOriginal;
        with WizRec do
        begin
          Case ActionRec.ReturnDocType of
            dtPIN  :  WizRec.rwPBased := 1;
            dtPDN  :  WizRec.rwPBased := 2;
            dtSIN  :  WizRec.rwSBased := 1;
            dtSDN  :  WizRec.rwSBased := 2;
            dtPOR  :  WizRec.rwSBased := 3;
            dtSOR  :  WizRec.rwSBased := 2;
          end;

          rwRepairInv:= ActionRec.ReturnedItems = 1;

          If (rwPAction In [60,61]) and (rwRepairInv) then {* We are issuing back so we need to use repair stock, not woff *}
            rwPAction:=rwPAction+5;

          If (rwPAction In [61,66]) then
            rwSAction:=Pred(rwPAction)
          else
            rwSAction:=rwPAction;

          rwRSCharge:= ActionRec.ApplyRestockingCharge;

          rwIgnoreSer:=((WizRec.rwRepairInv) and (WizRec.rwSAction In [64,65])) or
                        ((WizRec.rwPAction In [61,66]) and (WizRec.rwSBased =1));

          rwAppNewPrice:= ActionRec.ApplyCurrentPrice;

        end;
        WizRec.rwRunNo := SetNextWOPRunNo(WizRec.rwDocHed,BOn,0);
        Status := 0;
        TmpRes := Genereate_ActionDocFromRet(WizRec,ExLocal,ExLocal.LInv);

        If (TmpRes) or (WizRec.rwPAction=63) or ((WizRec.rwPAction In [60,61]) and (WizRec.rwDoc.InvNetVal=0.0)) then
        Begin


          With WizRec do
          Begin
            If (rwPAction In [61,66]) then
            Begin
              rwSAction:=rwPAction;
              If Genereate_ActionDocFromRet(WizRec,ExLocal,ExLocal.LInv) and (rwPAction<>64) then {Generate Delivery invoice}
              Begin

               If (WizRec.rwSBased=3) and (WizRec.rwDoc.InvDocHed In StkRetSalesSplit) then {Its an SOR with back2back, raise back2back wizard}
               begin
                 ActionRec.B2BSORRef := ExLocal.LInv.OurRef;
                 ActionRec.B2BSorLineCount := ExLocal.LInv.ILineCount;
               end;


              end;
            end;

          Inv:=WizRec.rwDoc;


            {.$IFDEF FRM}
              Begin
                {* We are returning to stock as part of write off or Repair *}
                If (rwPAction In [{62,}64]) {and (rwRepairInv)} and (WizRec.rwDoc.InvDocHed{rwDocHed} In StkRetSalesSplit) then
                  rwSAction:=101;

                Start_RETRun(WizRec.rwDoc.InvDocHed,rwSAction,BOn,WizRec,{Self.Owner}nil);
              end;
            {.$ENDIF}

          end; {With..}
        end; {If..}



        if not TmpRes then
          Result := Status;
      Finally
        ExLocal.Destroy;
      End;
    end
    else
      Result := 32766;
  end
  else
    Result := 32767;
end;

function SP_CREATERETURN(P     : Pointer;
                          PSize : longint;
                          P2 : Pointer;
                          P2Size : longint) : SmallInt;
Const
  Fnum     =  IDetailF;
  Keypath  =  IdFolioK;
var
  CreateRec : ^TBatchReturnCreateRec;
  WizRec    : tRetWizRec;
  ExLocal   :  TdExLocal;
  Keys : Str255;
  Res : Integer;
  ValidCheck, LineFound : Boolean;
  CCode : string;
  Curr : Integer;

begin
  Res := 0;
  if P <> nil then
  begin
    if PSize = SizeOf(TBatchReturnCreateRec) then
    begin
      Result := 0;
      ExLocal.Create;

      Try
        CreateRec := P;
        ValidCheck := True;
        if CreateRec.AddToExistingReturn then
        begin
          KeyS := UpperCase(CreateRec.ReturnOurRef);
          Case CreateRec.ParentOurRef[1] of
            'S' : ValidCheck := Copy(KeyS, 1, 3) = 'SRN';
            'P' : ValidCheck := Copy(KeyS, 1, 3) = 'PRN';
          end;

          if ValidCheck then
          begin
            ValidCheck := ValidCheck and CheckRecExsists(FullOurRefKey(KeyS), InvF, InvOurRefK);

            CCode := Inv.CustCode;
            Curr := Inv.Currency;

            CheckRecExsists(FullOurRefKey(CreateRec.ParentOurRef), InvF, InvOurRefK);

            ValidCheck := ValidCheck and (Trim(Inv.CustCode) = Trim(CCode)) and
                           (Inv.Currency = Curr);
          end;


        end;
        Move(P2^, WizRec.rwDoc, P2Size);
        if (WizRec.rwDoc.InvDocHed = WOR) then
        begin
          KeyS := FullCustCode(CreateRec.Supplier);
          ValidCheck := (Trim(Keys) <> '') and CheckRecExsists(KeyS, CustF, CustCodeK) and
                         (Cust.CustSupp = TradeCode[False]);
          if not ValidCheck then
            Res := 30003;
        end;

        if ValidCheck then
        begin
          if CreateRec.rcAbsLineNo > 0 then
          begin
            Wizrec.rwDocLine.AbsLineNo := CreateRec.rcAbsLineNo;
            WizRec.rwLineQty := CreateRec.Qty;
            WizRec.rwWizMode := 10;  //from line
            //Need to establish position on the line record before calling Genereate_RetFromDoc
            KeyS:=FullIdkey(WizRec.rwDoc.FolioNum,Wizrec.rwDocLine.AbsLineNo);
            Res := Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
            if (Res = 0) and (Id.FolioRef = WizRec.rwDoc.FolioNum) and
                             (Id.ABSLineNo = Wizrec.rwDocLine.AbsLineNo) then
            begin
              WizRec.rwDocLine := Id;
              if WizRec.rwDocLine.Qty > WizRec.rwLineQty then
                WizRec.rwIgnoreSer := True;
            end
            else
              Res := 30001;
          end
          else
            Res := 0;
        end;

        if (Res = 0) and (CreateRec.AddToExistingReturn) then
        begin
          if not ValidCheck then
            Res := 30002;
        end;



        if Res = 0 then
        begin
          WizRec.rwDate := CreateRec.CreateDate;
          WizRec.rwWarrantyPrice := CreateRec.UnderWarranty;
          WizRec.rwPr := CreateRec.Period;
          WizRec.rwYr := CreateRec.Year;
          WizRec.rwAppendMode := CreateRec.AddToExistingReturn;
          WizRec.rwRetRef := CreateRec.ReturnOurRef;
          WizRec.rwRetReason := CreateRec.Reason;
          WizRec.rwLoc := CreateRec.Location;
          WizRec.rwYourRef := CreateRec.YourRef;
          WizRec.rwSetEQty := CreateRec.SetReturnedQty;
          WizRec.rwSuppCode := CreateRec.Supplier;
          WizRec.rwB2BRepair := CreateRec.DirectCustomerRepair;

          Status := 0;
          If Genereate_RetFromDoc(WizRec,ExLocal,ExLocal.LInv) then
            CreateRec.ReturnOurRef := ExLocal.LInv.OurRef
          else
            Result := Status;
        end
        else
          Result := Res;
      Finally
        ExLocal.Destroy;
      End;



    end
    else
      Result := 32766;
  end
  else
    Result := 32767;

end;

end.

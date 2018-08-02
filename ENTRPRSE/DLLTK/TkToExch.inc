//PR 3/2/2006 - Moved here from DLLTH_UP.Pas
{* ----------------------------------------------------------------------------
   Convert from Toolkit record structure (TBatchTHRec)
   to Enterprise record structure (Inv) *}

(*
Function Locations
==================
GenSetError	dlltk\Bts1
ResetRec	R&D\BtSupU1
FullCustCode	R&D\BtKeys1U

SetTriRec	R&D\CurrncyU
DocTypeFCode	dlltk\Bts1

DocCodes array	SbsLib\Win\Excommomn\Varcomnu
WordBoolToBool	Dlltk\GlobVar
GetVATNo	R&D\BtSupU1
LJVar           R&D\ETStrU

Const Locations
===============
B_Insert        Btrvu2
*)

Function ExInvToInv(ExInvRec     :  TBatchTHRec;
                    AddMode      :  SmallInt;
                Var OrgInv       :  InvRec;
                Var EditNo       :  Byte;
                Var ExchInv      :  InvRec;
                    //Auto_Set_Period
                    AutoSetPr    :  Boolean;
                    //Overwrite_Trans_No
                    OverWORef    :  Boolean )  :  Integer;

{* OrgInv has been added for updating Account Balance if B_Update is used *}
Var
  i         :  integer;
  n         :  Byte;

  OInv      :  InvRec;

  FindRec,
  ValidCheck,
  ValidHed,
  EBusDocTypeOK
            : Boolean;
  KeyS1,
  KeyS      : Str255;

  UpdateOK  :  SmallInt;

  IntRefNo  :  Integer;

Begin

  Result:=0;
  ValidCheck:=BOff;
  ValidHed:=BOn;

  Fillchar(OrgInv,SizeOf(OrgInv),#0);

  With ExchInv do
  Begin
    {* If Insert Mode *}
    If (Abs(AddMode)=B_Insert) then
    Begin

      {* If the transaction has its own Reference No.,
         validate the reference number in the file. *}
      If (Not OverWORef) then
      begin
        KeyS:=LJVar(ExInvRec.OurRef,DocLen);
        Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyS);
        FindRec:=StatusOk;

        {* If the reference no. exists, return as an Error *}
        If (FindRec) then
          GenSetError(Not FindRec,5,Result,ValidHed)
        else
        begin
          {* If the Ref. No. does not exist, the first 3 characters must be
             the valid Transaction Type (SIN, SCR, etc..) *}
          KeyS:=Copy(ExInvRec.OurRef,1,3);
          if InEBusinessMode then
            for i := 1 to EBUSINESS_COUNTERS do
               FindRec := FindRec or (KeyS = EBUSINESS_DOCS[i])
          else
            FindRec:=( DocCodes[DocTypeFCode(EXInvRec.TransDocHed)] = KeyS );

          If (Not FindRec) then
            GenSetError(FindRec,3,Result,ValidHed);

          {* 07.04.2000 - last 6 digits must be numeric *}
          //PR 11/04/03 - Change to allow 4th digit to be alpha
          KeyS:=Copy(ExInvRec.OurRef,4,6);
         {$IFNDEF PREV561001}
           GenSetError(CheckDocNo(KeyS), 30120, Result, ValidHed);
         {$ELSE}
          IntRefNo:=StrToIntDef(Keys,0);
          GenSetError((IntRefNo>0),30120,Result,ValidHed);
         {$ENDIF}
        end; {if (FindRec) ..}

      end;  {if Not OverWORef then }

    end
    else  {if Abs(AddMode)=Edit..}
    Begin
      { Don't display msg if -ve as it's allowed }
      If (AddMode > 0) and (AddMode<>B_Update) Then
        GenSetError(FindRec,4,Result,ValidHed);

      OInv:=Inv;

      { 4.31-Edit }
      If (AddMode=B_Update) then
      begin
        {* Validate whether the tran. can be updated *}
        Result:=CanbeUpdated(ExInvRec,OrgInv,EditNo); {* OrgInv = Original INV record *}


      end; {if AddMode=B_Update..}

    end; {if Abs(AddMode)=Edit...}


    {* ---- Inv Conversion starts here ------- *}
    If (Result=0) then
    begin
      { HM 11/07/00: Fix for STORETH problem.
        StoreTH is only for internal usage, hence should not reset the record. }
      If (AddMode <> -B_Update) then Begin
        {$IFDEF COMTK}
        if ExInvRec.UpdateExMode = 0 then
        {$ENDIF}
//          ResetRec(InvF);
         FillChar(ExchInv, SizeOf(ExchInv), 0);


        {* If UPDATE mode, the following fields should not be changed *}
        If (AddMode=B_Update) then
        begin
          FolioNum:=OrgInv.FolioNum;
          NLineCount:=OrgInv.NLineCount;
          ILineCount:=OrgInv.ILineCount;
          AuthAmnt := OrgInv.AuthAmnt;
          CISTax := OrgInv.CISTax;
          CISDeclared := OrgInv.CISDeclared;
          CISManualTax := OrgInv.CISManualTax;
          CISDate := OrgInv.CISDate;
          CISEmpl := OrgInv.CISEmpl;
          CISGross := OrgInv.CISGross;
          CISHolder := OrgInv.CISHolder;
        end
        else
        begin
          {* If INSERT mode, set Notes line count and Total Transaction Line Count *}
          NLineCount:=1;
          ILineCount:=EXInvRec.LineCount;
        end; {if..}


      End; { If (AddMode <> -B_Update) }

      CustCode:=FullCustCode(EXInvRec.CustCode);        { Account Code }
      OurRef:=EXInvRec.OurRef;                          { Our Ref. No. SIN000001, etc..}
      Currency:=EXInvRec.Currency;                      { Header Currency Code }

      {* Acounting Year and Period are Byte fields, hence need to check not to get
         the Range Check error *}
      If (ExInvRec.AcYr>1900) then
        AcYr:=(ExInvRec.AcYr - 1900)
      else
        If (EXInvRec.AcYr In [0..255]) then
          AcYr:=EXInvRec.AcYr;

      If (EXInvRec.AcPr In [0..255]) then
        AcPr:=EXInvRec.AcPr;

      {* 13.10.98 - added to get the current periods if -1 is assigned.
         If Auto_Set_Period is OFF and both period fields are set to -1,
         then the current Enterprise Periods should be used in transaction.  *}
      If (Not AutoSetPr) and ((ExInvRec.AcPr=-1) or (ExInvRec.AcYr=-1)) then
      begin
        AcYr:=Syss.CYr;
        AcPr:=Syss.CPr;
      end; {if..}

      DueDate:=EXInvRec.DueDate;                { Due Date }
      TransDate:=EXInvRec.TransDate;            { Transaction Date }
      if Trim(EXInvRec.YourRef) <> '' then
        YourRef:=LJVar(EXInvRec.YourRef, DocYRef1Len)
      else
        FillChar(YourRef[0], Length(YourRef) + 1, 0); { Your Ref. } //PR 2/4/04 - pad out to correct len
      TransDesc:=LJVar(EXInvRec.LongYrRef, DocYRef2Len);            { Alternative Ref. }  //PR 2/4/04 - pad out to correct len

      {* From External to Ent. record *}
      CXRate[BOff]:=EXInvRec.CoRate;            { Transaction Exchange Rate }
      CXRate[BOn]:=EXInvRec.VATRate;            { VAT Exchange Rate }
      SetTriRec(Currency,UseORate,CurrTriR);    { for v4.31 }


      InvDocHed:=DocTypeFCode(EXInvRec.TransDocHed);  { Transaction Type SIN,SCR, etc..}


      {* 05.01.99 - Added for not to return Range Check Error
                    DocTypeFCode function in BTS1 has been modified as well. *}
      if InEBusinessMode then
      begin
        InvDocHed := EBusOurRefCodeToEnum(ExInvRec.TransDocHed, EBusDocTypeOK);
        if not EBusDocTypeOK then
          Result:=30217;    { SM - Used the new error code - JF ooOOOoo !!! }
      end
      else
        if (DocCodes[InvDocHed]<>ExInvRec.TransDocHed) then
          Result:=30215;


      {* VAT Analysis Values *}
      {* 11.01.2000 - changed to Total 21 *}
      if InvDocHed <> NMT then
      begin
        ManVAT:=WordBoolToBool(ExInvRec.ManVAT);             { Manual VAT Calculation allowed Yes/No }
      {$IFDEF EN551}
      end;
      {$ENDIF}
        InvVAT:=ExInvRec.InvVAT;                  { Header Total VAT Value }
        For n:=0 to 20 do  {* changed from 9 to 16 on 10.06.97 *}
          InvVATAnal[GetVATNo(THVATCode[n],#0)]:=ExInvRec.InvVATAnal[n];
      {$IFNDEF EN551}
      end;
      {$ENDIF}

       {InvVATAnal[VATType(n)]:=ExInvRec.InvVATAnal[n];}

      InvNetVal:=ExInvRec.InvNetVal;            { Header Net Value }
      DiscSetl:=ExInvRec.DiscSetl;              { Settlement Discount %}
      DiscSetAm:=ExInvRec.DiscSetAm;            { Settlement Discount Amount }
      DiscAmount:=ExInvRec.DiscAmount;          { Header Total Discount Amount }
      DiscDays:=ExInvRec.DiscDays;              { Settlement Discount Days }
      DiscTaken:=WordBoolToBool(ExInvRec.DiscTaken);       { Discount Taken Yes/No }
      TransNat:=ExInvRec.TransNat;              { VAT Nature of Transaction }
      TransMode:=ExInvRec.TransMode;            { VAT Mode of Transport }
      HoldFlg:=ExInvRec.HoldFlg;                { Hold Status }
      TotalWeight:=ExInvRec.TotalWeight;        { Header Total Weight }

      For n:=1 to 5 do
        DAddr[n]:=ExInvRec.DAddr[n];            { Delivery Address 5 Lines }

      TotalCost:=ExInvRec.TotalCost;            { Header Total Cost }
      PrintedDoc:=WordBoolToBool(ExInvRec.PrintedDoc);     { Printed Status }
      DelTerms:=ExInvRec.DelTerms;              { Delivery Terms }
      OpName:=ExInvRec.OpName;                  { Operator Name }
      DJobCode:=FullJobCode(ExInvRec.DJobCode); { Header Job Code }
      DJobAnal:=FullJACode(ExInvRec.DJobAnal);  { Header Job Analysis Code }

      {* 02.09.99 - If SOR/POR this needs to display on Ledger Screen *}
      If (InvDocHed In PSOPSet) then
//        TotOrdOS:=(ExInvRec.InvNetVal - ExInvRec.DiscAmount);
          TotOrdOS := 0;

      {* If TimeSheet transaction, Employee Code is assigned in BatchLink field *}
      If (InvDocHed In TSTSplit) then
      begin
        BatchLink:=FullCustCode(ExInvRec.EmpCode);
      end;

      DocUser1:=ExInvRec.DocUser1;              { User Defined Field 1 }
      DocUser2:=ExInvRec.DocUser2;              { User Defined Field 2 }
      NoLabels:=ExInvRec.thNoLabels;            { No. of Labels }
      CtrlNom:=ExInvRec.CtrlNom;                { Control Nominal Code }

      Tagged:=ExInvRec.Tagged;             { Tagged Status Yes/No }

      {*** Ver 4.31 ***}
      { To allow SOPKeepRate to be set needs to be POR/SOR and daily rate }
      if (Syss.TotalConv = 'C') or not (InvDocHed in OrderSet) then
        SOPKeepRate := false
      else
        SOPKeepRate := WordBoolToBool(ExInvRec.SOPKeepRate);

      DocUser3:=ExInvRec.DocUser3;              { User Defined Field 3 }
      DocUser4:=ExInvRec.DocUser4;              { User Defined Field 4 }
      SSDProcess:=UpCase(ExInvRec.SSDProcess);  { has validation }
      ExtSource:=ExInvRec.ExtSource;
      PostDate:=ExInvRec.PostDate;
      PORPickSOR:=WordBoolToBool(ExInvRec.PORPickSOR);
      BDiscount:=ExInvRec.BDiscount;
      PrePostFlg:=ExInvRec.PrePostFlg;

      TotalCost2 := ExInvRec.TotalCost2;
      NOMVatIO := ExInvRec.NOMVATIO;
      {$IFDEF COMTK}
      DeliverRef := ExInvRec.thDeliveryNoteRef;
      AutoInc := ExInvRec.AutoInc;
      AutoIncBy := ExInvRec.AutoIncBy;
      UntilDate := ExInvRec.AutoEndDate;
      UnPr := ExInvRec.AutoEndPr;
      UnYr := ExInvRec.AutoEndYr;
      AutoPost := ExInvRec.AutoPost;
      TotalInvoiced := ExInvRec.TotalInvoiced;
      BatchNom := ExInvRec.BatchNom;
      OnPickRun := WordBoolToBool(ExInvRec.thOnPickRun);
      if not (InvDocHed In TSTSplit) then
        BatchLink := ExInvRec.BatchLink;
      RemitNo := ExInvRec.RemitNo;
      NomAuto := WordBoolToBool(ExInvRec.NomAuto);
      thExportedFlag := WordBoolToBool(ExInvRec.thExported);

      Untagged := ExInvRec.NomAutoReverse;
      if (AddMode = B_Insert) or (ExInvRec.RunNo = -10) then
      begin
        RunNo := ExInvRec.RunNo;
        FolioNum := ExInvRec.FolioNum;
      end;

      if InvDocHed in JAPSplit then
      begin
      //  CISEmpl := LJVar(UpperCase(ExInvRec.CISEmpl), 6);
      //  CISHolder := ExInvRec.CISHolder;
        PDiscTaken := ExInvRec.thPostDiscTaken;
      end;

      {$ENDIF}
      TotalCost2 := ExInvRec.TotalCost2;
    {$IFDEF EN551}
      NOMVatIO := ExInvRec.NOMVatIO;
    {$ENDIF}
    end; {if Result=0..}
  end; {With..}

end; {Func..}

Function ExInvLineToId(ExIdRec     :  TBatchTLRec;
                       SMode       :  SmallInt;
                   var ExchID      :  IDetail;
                       //Multi_Currency
                       MCMode,
                       //Ex_Allow_QtyDel_Set
                       AllowQtyDel,
                       //Deduct_MultiLoc_Stock
                       UseMLoc     :  Boolean;
                       //Discount_Decimals
                       DiscountDec : Byte )  :  Integer;
  var
    ValidCheck : Boolean;

  //PR 27/08/03 Take doctype from line rather than header, as in some cases header may be undefined
  function GetDocHed : DocTypes;
  var
    DocCode : string;
  begin
    {$IFDEF COMTK}
    DocCode := ExIdRec.DocHed;
    {$ELSE}
    DocCode := '';
    {$ENDIF}
    if Trim(DocCode) = '' then
      DocCode := Copy(ExIdRec.TransRefNo, 1, 3);

    //Paul 5.60
    //Previously, an empty doctype was getting set to PRN. with the addition of apps & vals types
    //it's getting set to JPA which has bad effects on calculations. Restore to original setting.
    if Trim(DocCode) = '' then
      DocCode := 'PRN';

    Result := DocTypeFCode(DocCode);
  end;

Begin
//  ResetRec(IDetailF);
  FillChar(ExchId, SizeOf(ExchId), 0);

  With ExchId do
  Begin
    {* The following fields are updated from Header (Inv) record *}
    FolioRef:=Inv.FolioNum;             { Folio Reference No.}
    if SMode <> 0 then
      IDDocHed:=Inv.InvDocHed       { Transaction Type }
    else
      IDDocHed:=GetDocHed;          { Transaction Type }
    DocPRef:=Inv.OurRef;                { In v4.31 - Our Reference }
    PYr:=Inv.ACYr;                      { Accounting Year }
    PPr:=Inv.AcPr;                      { Accounting Period }

    //  Original...
{    If (ExIdRec.Payment) then
      Payment:=SetRPayment(IDDocHed)
    else
      Payment:=DocPayType[IdDocHed];}


    LineNo:=ExIdRec.LineNo;

    if LineNo > HighLineNo then
      HighLineNo := LineNo;
    {20.03.2000 - if GetTrans has been used and LineNo has not been changed,
    this is very important to prevent incorrect ABSLineNo }

    If (LineNo=RecieptCode) then
      LineNo:=TLLineNo;

    {* 16.03.2000 - This has to be before ReceiptCode assignment,
    otherwise, ABS Line No would not be correct. *}
    {$IFNDEF COMTK}
    ABSLineNo:=LineNo;
    {$ELSE}
    if IDDocHed in JAPSplit then
      ABSLineNo := ExIdRec.AbsLineNo
    else
      AbsLineNo := LineNo;
    {$ENDIF}

    //PR 25/06/03 Added specific setting for noms. After 551 release
    //check this area to see why original above was taken out.
    //BUGFIX - PR: 11/06/04 - moved this to above LineNo := RecieptCode line as needs to be set first.
    if IDDocHed = NMT then
      Payment := DocPayType[NMT]
    else
    {$IFDEF COMTK}
    if (IDDocHed in JAPSplit) then
    begin
     if (SMode = B_Update) then
       Payment := ExIdRec.PaymentCode
     else
     begin
       if LineNo > 0 then
         Payment := 'Y'
       else
         Payment := 'N';

     end;
    end
    else
    {$ENDIF}
    If WordBoolToBool(ExIdRec.Payment) then
      Payment:=DocPayType[SRC]
    else
      Payment:=DocPayType[SIN];


    If ((Payment=DocPayType[SRC]) or (IdDocHed In NomSplit+StkAdjSplit)) and not (IdDocHed in JAPSplit) then
      LineNo:=RecieptCode;


    NomCode:=ExIdRec.NomCode;

    {* Currency & EXRate *}
    Currency:=ExIdRec.Currency;
    CXRate[BOff]:=ExIdRec.CoRate;
    CXRate[BOn]:=ExIdRec.VATRate;
    SetTriRec(Currency,UseORate,CurrTriR);  { for v4.31 }

    If (SMode <> 0) and ((Not MCMode) or (Not (IdDocHed In RecieptSet+NomSplit+StkAdjSplit+TSTSplit))) then
    Begin
      Currency:=Inv.Currency;
      CXRate:=Inv.CXRate;
      CurrTriR:=Inv.CurrTriR; { for v4.31 }
    end; {if..}


    CCDep[BOn]:=LjVar(ExIdRec.CC,CCDpLen);      { Cost Centre }
    CCDep[BOff]:=LjVar(ExIdRec.Dep,CCDpLen);    { Department }

    {StockCode:=FullStockCode(Strip('B',[#1,#32],ExIdRec.StockCode));}

    { 07.07.2000 }
    //PR: 5/9/02 - Don't allow stockcode on NOM
    if not (IDDocHed in [NMT]) then
      StockCode:=FullStockCode(Strip('B',[#1,#32],ExIdRec.StockCode));

    {$IFDEF COMTK}
    //if PayRate on TSH didn't meet rules then set it to blank to cause a 30113 error.
    if (IDDocHed = TSH) and (ExIDRec.InvalidTSHRates) then
      FillChar(StockCode[0], Length(StockCode) + 1, 0);
    {$ENDIF}

    Qty:=ExIdRec.Qty;
//    if (IDDocHed in JAPSplit) or (ExIdRec.KitLink <> 0) then
      QtyMul:=ExIdRec.QtyMul;
{    else
      QtyMul := 0;}

    //PR: 25/05/02 Changed so that qtypick & qtypwoff could be set on add as well as update
//PR: 10/12/02 Bugfix - added SDN & PDN so that qtypick is saved for them, otherwise non-stock items don't get
//             invoiced
      If (IDDocHed In [SOR,POR,SDN,PDN] + StkRetSplit) then      { If SOR or POR }
      begin
        //PR: 5/9/02 changed so that can't pick lines on transaction on credit hold
        if Inv.HoldFlg and 7 <> 6 then
          QtyPick:=ExIdRec.QtyPick;               { Pick Qty }

        //PR: 17/11/03 - Set QtyPick to qty for delivery notes to avoid 30505 errors
        if (IDDocHed in [PDN, SDN]) and (Qty > 0) then
          QtyPick := Qty;

        QtyPWOff:=ExIdRec.QtyPWOff;             { WriteOff Qty }
      end; {If SOR,POR...}

      {$IFDEF COMTK}
      if IDDocHed in JAPSplit then
      begin
        QtyPWoff := ExIdRec.QtyPWOff;
        QtyPick := ExIdRec.QtyPick;
        AutoLineType := ExIdRec.AutoLineType;
      end;
      {$ENDIF}

    If (IDDocHed In WOPSplit) then
    begin
      if Inv.HoldFlg and 7 <> 6 then
        QtyPick:=ExIdRec.QtyPick;               { Pick Qty }
//      QtyPWOff:=ExIdRec.QtyPWOff;             { WriteOff Qty }
    end; {If SOR,POR...}

    If (QtyMul=0) then
      QtyMul:=1;
    If (Trim(StockCode) <> '') then
    begin

      ValidCheck:=(CheckRecExsists(StockCode,StockF,StkCodeK));

      if ValidCheck then
      begin
        ID.UsePack := Stock.CalcPack;
        ID.PrxPack := Stock.PricePack;


        ID.ShowCase := Stock.DPackQty;

      // HM 09/07/01: Mod for ADJ Pack Qty support
      // HM 10/07/01: Removed limitation to ADJ only after consultation with EL
      //              as same problem was hapening with any trans type using stock
      //If (Inv.InvDocHed = ADJ) Then
        ShowCase := Stock.DPackQty;

        If (Stock.DPackQty) then
        begin
        //PR 6/7/05 - QtyPack was always being set to buyunit which didn't work if buyunits & sellunits were different.
          if ID.IdDocHed in SalesSplit then
            ID.QtyPack := Stock.SellUnit
          else
            ID.QtyPack := Stock.BuyUnit;
        end;


        Qty := Case2Ea(ID, Stock, Qty);
        QtyPick := Case2Ea(ID, Stock, QtyPick);
        QtyPWoff := Case2Ea(ID, Stock, QtyPWoff);
        QtyDel := Case2Ea(ID, Stock, QtyDel);
        QtyWoff := Case2Ea(ID, Stock, QtyWoff);

        //PR 09/07/04 - Set SerialQty in the same way as Enterprise
{        if (SMode <> B_Update) and (Stock.StkValType = 'R') and not (Inv.InvDocHed in [SOR, POR]) then
          SerialQty := Qty * QtyMul;}
      end;
    end;



    //PR: 29/04/02 Added this as heinz use it - needs special ini file switch
    if AllowQtyDel or (SMode = B_Update) or (IdDocHed in JAPSplit) then
      QtyDel := ExIdRec.QtyDel;


    NetValue:=ExIdRec.NetValue;         { Unit Value }

    //PR 12/11/02 Round discount to 2 dec places to sort problem in trade counter
    //Discount:= Round_Up(ExIdRec.Discount, 2);         { Unit Discount Value }
    // HM 13/11/02: Modified Discount rounding as amounta and percentages need to be rounded differently
(*    If (ExIdRec.DiscountChr = '%') Then
      // Percentage Discount where 1.25% = 0.0125 therefore need to round to 4dp
      Discount:= Round_Up(ExIdRec.Discount, 4)         { Unit Discount Value }
    Else
      // Amount Discount where £1.25 = 1.25 so round to 2dp
      Discount:= Round_Up(ExIdRec.Discount, 2);         { Unit Discount Value } *)

    If (ExIdRec.DiscountChr = '%') Then
      // Percentage Discount where 1.25% = 0.0125 therefore need to round to 4dp
      Discount:= Round_Up(ExIdRec.Discount, DiscountDec + 2)         { Unit Discount Value }
    Else
      // Amount Discount where £1.25 = 1.25 so round to 2dp
      Discount:= Round_Up(ExIdRec.Discount, DiscountDec);         { Unit Discount Value }

    //PR 9/9/02 - Add vat inclusive value
    IncNetValue := ExIdRec.IncNetValue;

    {$IFDEF EN551}
    NOMIOFlg := ExIdRec.NomVatType;
    if (IDDocHed = NMT) and (NOMIOFlg <> 0) then
      VatNeededOnNom := True;
    {$ENDIF}

    //PR: 5/9/02 - Don't allow Vat on NOM + ADJ, WOR & Payment lines 30/10/02
    //PR 06/05/03 In v551 Vat is allowed on noms
    if not (IDDocHed in [{$IFNDEF EN551} NMT, {$ENDIF} ADJ, WOR]) and
           ((not WordBoolToBool(ExIdRec.Payment)) or (IDDocHed = NMT)) then
    begin
      VATCode:=ExIdRec.VATCode;           { Line VAT Code }
      {$IFDEF EN551}
(*      if (Inv.InvDocHed = NMT) and (ExIdRec.NomVatType = 1) {auto vat} then
      begin
        CalcVat(ID, 0.0);
        Inv.InvVat := Inv.InvVat + ID.VAT;
        Inv.InvVATAnal[GetVATNo(ID.VATCode,#0)]:= Inv.InvVATAnal[GetVATNo(ID.VATCode,#0)] + ID.Vat;
      end
      else *)
      {$ENDIF}
        VAT:=ExIdRec.VAT;                   { Line VAT Amount }
    end;

    if not (IDDocHed in JAPSplit) then
      DiscountChr:=ExIdRec.DiscountChr   { Discount Type }
    else
      DiscountChr := '%';
    CostPrice:=ExIdRec.CostPrice;       { Unit Cost Price }

    If (IDDocHed In SalesSplit+PurchSplit+JAPSplit) then  { Account Code }
      CustCode:=Inv.CustCode;

    {* Changed on 21.11.97 for TL Delivery Date *}
    If (Not EmptyKey(ExIdRec.LineDate,SizeOf(PDate))) and
       (Not (IDDocHed In [NMT,ADJ,SBT,PBT])) then
          PDate:=ExIdRec.LineDate
    else
      PDate:=Inv.TransDate;

    Item:=ExIdRec.Item;                 { Line Item No. }
    Desc:=ExIdRec.Desc;                 { Line Description }
    LWeight:=ExIdRec.LWeight;           { Line Weight }

    //PR: 5/9/02 - Don't allow location on NOM
    if not (IDDocHed in [NMT]) then
    begin
      MLocStk:=ExIdRec.MLocStk;           { Multi-location code }
      If (Not EmptyKey(MLocStk,LocKeyLen)) then  {Added on 29.08.2000 }
        MLocStk:=LJVar(MLocStk,LocKeyLen);
    end;

    DeductMLoc:=(UseMLoc);       { Deduct from Location Stock Y/N }

    // HM 13/08/01: Added FullxxxCode calls as was preventing posting from
    //              Job Daybook if Job Code is < 10 chars
    JobCode:=FullJobCode(ExIdRec.JobCode);   { Line Job Code }
    {$IFDEF COMTK}
    if (IDDocHed in JAPSplit) and (ExIDRec.InvalidJobCode) then
      FillChar(JobCode[0], Length(JobCode) + 1, 0);
    {$ENDIF}

    AnalCode:=FullJACode(ExIdRec.AnalCode);  { Line Job Analysis Code }

    If (Syss.AutoClearPay) then         { Auto Clear Payment }
      Reconcile:=ReconC
    else
      Reconcile:=ExIdRec.Reconcile;

    {$IFDEF COMTK}
     if (IDDocHed in JAPSplit) and (LineNo < 0) then
       Reconcile := Abs(LineNo) - 1;
    {$ENDIF}

    If (IdDocHed In TSTSplit) then      { If Tran= TSH (Time Sheet)}
    begin
      NomMode := TSTNomMode;            { TSTNomMode = 3 }
      Reconcile:=ExIdRec.TSHCCurr;      { Time Sheet Currency }

      JobCode:=FullJobCode(ExIdRec.JobCode);    { Line Job Code - importtant to use FullJobCode }
      AnalCode:=FullJobCode(ExIdRec.AnalCode);  { Line Job Analysis Code }
    end; {if..}

    If (IdDocHed In StkAdjSplit) then   { If Tran=ADJ (Stock Adjustment)}
    Begin
      PostedRun:=StkAdjRunNo;           { ADJ Run No }
      NomMode:=StkAdjNomMode;           { Nominal Mode }
    end;

    if IdDocHed in JapSplit then
      NomMode := TSTNomMode;

    If (ExIdRec.DocLTLink In [1..4]) or
       ((IDDocHed in JAPSplit) and (ExIdRec.DocLTLink In [1..18])) or
       (IDDocHed in StkRetSplit) then       { Document Link }
      DocLTLink:=ExIdRec.DocLTLink;

    if not (IDDocHed in JAPSplit) then
    begin
      LineType:=StkLinetype[IdDocHed];             { Line Type }
      SOPLink := ExIDRec.SOPLink;
    end
    else
    begin
      LineType := ' ';
      if Inv.TransMode > 0 then
        SOPLink := JAPParentFolio;  //to link jap transactions to parent terms
    end;

    KitLink:=ExIdRec.KitLink;                   { Kit Link if Stock is BOM }

    SOPLineNo:=ExIdRec.SOPLineNo;               { SOP Line No }

    { HM 22/12/98: This is needed otherwise the ADJ has no effect on stock levels }
    { will need to be intelligently set as in adjlineu based on the stock item    }
    {QtyPack := 1;} { Temporarily commented out }

    {*** Ver 4.31 ***}
    LineUser1:=ExIdRec.LineUser1;       { Line User 1 to 4}
    LineUser2:=ExIdRec.LineUser2;
    LineUser3:=ExIdRec.LineUser3;
    LineUser4:=ExIdRec.LineUser4;

    SSDUplift:=ExIdRec.SSDUplift;       { SSD Information }
    SSDCommod:=ExIdRec.SSDCommod;
    SSDSPUnit:=ExIdRec.SSDSPUnit;
    SSDCountry:=ExIdRec.SSDCountry;
    SSDUseLine:=WordBoolToBool(ExIdRec.SSDUseLine);
    If (PriceMulx=0) then
      PriceMulx:=1;                     { according to spec. }

    if IDDocHed in JAPSplit then
      PriceMulx := 0;

    VATIncFlg:=ExIdRec.VATIncFlg;       { VAT Include Flag }
    //5.52 27/08/03
    {$IFDEF EN552}
    BinQty := ExIdRec.BinQty;
    {$ENDIF}

    If (SMode=B_Update) then            { If UPDATE }
    begin
      ABSLineNo:=ExIdRec.ABSLineNo;     { Use Old ABS Line No }
      QtyMul := ExIdRec.QtyMul;
      AutoLineType := ExIdRec.AutoLineType;
      {FolioRef:=ExIdRec.FolioNum;}
(*      If (Inv.InvDocHed In [SOR,POR]) then      { If SOR or POR }
      begin
        QtyPick:=ExIdRec.QtyPick;               { Pick Qty }
        QtyPWOff:=ExIdRec.QtyPWOff;             { WriteOff Qty }
      end; {If SOR,POR...} *)

    end; {If SMode=B_Update ..}
    {*** -------------- ***}


    {$IFDEF COMTK}
    if ExIDRec.Year <> 0 then
      PYr := ExIDRec.Year;
    if ExIDRec.Period <> 0 then
      PPr := ExIDRec.Period;

    JAPDedType := ExIDRec.tlDeductType;
    OldSerQty := ExIDRec.tlOldSerialQty;
    LiveUplift := ExIDRec.tlLiveUplift;
    COSNomCode := ExIdRec.tlCOSNomCode;
    if IdDocHed in JAPSplit then
      ShowCase  := ExIdRec.tlUseCase;

    SerialRetQty := ExIdRec.SerialRetQty;
    BinRetQty := ExIdRec.BinRetQty;
    {$ENDIF}

    {$IFDEF EN550CIS}
    CostApport   := ExIdRec.CostApport;
    {$ENDIF}

  end; {With..}
  Result:=0;
end;



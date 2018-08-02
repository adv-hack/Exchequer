unit oIDetail;

{$I DEFOVR.INC}

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     CustTypU;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TInvLine = Class(TAbsInvLine10)
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..92] Of TPropertyAccess;
    FuncAccess : Array [1..3] Of TFunctionAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    MainInv          : TAbsInvoice7;
    DataRec, OrigRec : IDetail;
    RecAddr          : LongInt;

    { Variables used for internal validation }
    EditMode         : Byte;      { 0 = Normal Line - already exists in file }
                                  { 1 = Current Line - doesn't exist in file }
                                  { 2 = New Line - doesn't exist in file }
    FirstQty         : Boolean;   { used when calculating stock level adjustments (or something) }
    BadQty           : Boolean;   { Naughty, Naughty!! Stock level is -ve }
    LastQtyValue     : Double;


  Protected
    { Abstract Property Access methods from TAbsCustomer }
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function  GetFolioRef : LongInt; Override;
    Procedure SetFolioRef(Value : LongInt); Override;
    Function  GetLineNo : LongInt; Override;
    Procedure SetLineNo(Value : LongInt); Override;
    Function  GetPostedRun : LongInt; Override;
    Procedure SetPostedRun(Value : LongInt); Override;
    Function  GetNomCode : LongInt; Override;
    Procedure SetNomCode(Value : LongInt); Override;
    Function  GetNomMode : Byte; Override;
    Procedure SetNomMode(Value : Byte); Override;
    Function  GetCurrency : Byte; Override;
    Procedure SetCurrency(Value : Byte); Override;
    Function  GetPYr : Byte; Override;
    Function  GetPPr : Byte; Override;
    Function  GetCCDep1 : cuStr3; Override;
    Procedure SetCCDep1(Value : cuStr3); Override;
    Function  GetCCDep2 : cuStr3; Override;
    Procedure SetCCDep2(Value : cuStr3); Override;
    Function  GetStockCode : cuStr16; Override;
    Procedure SetStockCode(Value : cuStr16); Override;
    Function  GetABSLineNo : LongInt; Override;
    Procedure SetABSLineNo(Value : LongInt); Override;
    Function  GetLineType : Char; Override;
    Function  GetIdDocHed : cuDocTypes; Override;
    Function  GetQty : Real; Override;
    Procedure SetQty(Value : Real); Override;
    Function  GetQtyMul : Real; Override;
    Procedure SetQtyMul(Value : Real); Override;
    Function  GetNetValue : Real; Override;
    Procedure SetNetValue(Value : Real); Override;
    Function  GetDiscount : Real; Override;
    Procedure SetDiscount(Value : Real); Override;
    Function  GetVATCode : Char; Override;
    Procedure SetVATCode(Value : Char); Override;
    Function  GetVAT : Real; Override;
    Procedure SetVAT(Value : Real); Override;
    Function  GetPayment : Char; Override;
    Procedure SetPayment(Value : Char); Override;
    Function  GetPreviousBal : Real; Override;
    Procedure SetPreviousBal(Value : Real); Override;
    Function  GetReconcile : Byte; Override;
    Procedure SetReconcile(Value : Byte); Override;
    Function  GetDiscountChr : Char; Override;
    Procedure SetDiscountChr(Value : Char); Override;
    Function  GetQtyWOFF : Real; Override;
    Procedure SetQtyWOFF(Value : Real); Override;
    Function  GetQtyDel : Real; Override;
    Procedure SetQtyDel(Value : Real); Override;
    Function  GetCostPrice : Real; Override;
    Procedure SetCostPrice(Value : Real); Override;
    Function  GetCustCode : cuStr10; Override;
    Function  GetPDate : cuLongDate; Override;
    Procedure SetPDate(Value : cuLongDate); Override;
    Function  GetItem : cuStr3; Override;
    Procedure SetItem(Value : cuStr3); Override;
    Function  GetDesc : cuStr60; Override;
    Procedure SetDesc(Value : cuStr60); Override;
    Function  GetJobCode : cuStr10; Override;
    Procedure SetJobCode(Value : cuStr10); Override;
    Function  GetAnalCode : cuStr10; Override;
    Procedure SetAnalCode(Value : cuStr10); Override;
    Function  GetCXrate1 : Real; Override;
    Procedure SetCXrate1(Value : Real); Override;
    Function  GetCXrate2 : Real; Override;
    Procedure SetCXrate2(Value : Real); Override;
    Function  GetLWeight : Real; Override;
    Procedure SetLWeight(Value : Real); Override;
    Function  GetDeductQty : Real; Override;
    Procedure SetDeductQty(Value : Real); Override;
    Function  GetKitLink : LongInt; Override;
    Procedure SetKitLink(Value : LongInt); Override;
    Function  GetSOPLink : LongInt; Override;
    Procedure SetSOPLink(Value : LongInt); Override;
    Function  GetSOPLineNo : LongInt; Override;
    Procedure SetSOPLineNo(Value : LongInt); Override;
    Function  GetMLocStk : cuStr3; Override;
    Procedure SetMLocStk(Value : cuStr3); Override;
    Function  GetQtyPick : Real; Override;
    Procedure SetQtyPick(Value : Real); Override;
    Function  GetQtyPWOff : Real; Override;
    Procedure SetQtyPWOff(Value : Real); Override;
    Function  GetUsePack : Boolean; Override;
    Procedure SetUsePack(Value : Boolean); Override;
    Function  GetSerialQty : Real; Override;
    Procedure SetSerialQty(Value : Real); Override;
    Function  GetCOSNomCode : LongInt; Override;
    Procedure SetCOSNomCode(Value : LongInt); Override;
    Function  GetDocPRef : cuStr10; Override;
    Function  GetDocLTLink : cuLineTIndex; Override;
    Procedure SetDocLTLink(Value : cuLineTIndex); Override;
    Function  GetPrxPack : Boolean; Override;
    Procedure SetPrxPack(Value : Boolean); Override;
    Function  GetQtyPack : Double; Override;
    Procedure SetQtyPack(Value : Double); Override;
    Function  GetReconDate : cuLongDate; Override;
    Procedure SetReconDate(Value : cuLongDate); Override;

    Function  GetUserDef1 : cuStr30; Override;
    Procedure SetUserDef1(Value : cuStr30); Override;
    Function  GetUserDef2 : cuStr30; Override;
    Procedure SetUserDef2(Value : cuStr30); Override;
    Function  GetUserDef3 : cuStr30; Override;
    Procedure SetUserDef3(Value : cuStr30); Override;
    Function  GetUserDef4 : cuStr30; Override;
    Procedure SetUserDef4(Value : cuStr30); Override;

    Function  CheckValid : Boolean;
    Procedure CheckStkQty(LastQtyValue : Double);

    // v5.50 20/02/03 - TAbsInvLine2 descendant for new v5.50 Transaction Fields
    Function  GetLineSource : Byte; Override;
    Procedure SetLineSource(Value : Byte); Override;
    Function  GetCISRateCode : Char; Override;
    Procedure SetCISRateCode(Value : Char); Override;
    Function  GetCISRate : Double; Override;
    Procedure SetCISRate(Value : Double); Override;
    Function  GetCostApport : Double; Override;
    Procedure SetCostApport(Value : Double); Override;
    Function  GetVATInclValue : Double; Override;
    Procedure SetVATInclValue(Value : Double); Override;

    // v5.51 04/06/03 - TAbsInvLine3 descendant for new v5.51 Transaction Fields
    Function  GetNOMVATType : cuNOMLineVatType; Override;
    Procedure SetNOMVATType(Value : cuNOMLineVatType); Override;

    // v5.60 23/03/05 - TAbsInvLine4 descendant for new v5.60 Transaction Fields
    Function  GetCISAdjustments : Double; Override;
    Procedure SetCISAdjustments(Value : Double); Override;
    Function  GetAppsDeductType : Byte; Override;
    Procedure SetAppsDeductType(Value : Byte); Override;

    // TAbsInvLine5
    Function GetSerialReturnQty : Double; Override;
    Procedure SetSerialReturnQty (Value : Double); Override;
    Function GetBinReturnQty : Double; Override;
    Procedure SetBinReturnQty (Value : Double); Override;

    // v6.01 - 08/05/09 - Added TAbsInvLine6 for Advanced Discounts fields
    Function GetMultiBuyDiscount : Double; Override;
    Procedure SetMultiBuyDiscount (Value : Double); Override;
    Function GetMultiBuyDiscountFlag : Char; Override;
    Procedure SetMultiBuyDiscountFlag (Value : Char); Override;
    Function GetTransValueDiscount : Double; Override;
    Procedure SetTransValueDiscount (Value : Double); Override;
    Function GetTransValueDiscountFlag : Char; Override;
    Procedure SetTransValueDiscountFlag (Value : Char); Override;
    Function GetTransValueDiscountType : Byte; Override;
    Procedure SetTransValueDiscountType (Value : Byte); Override;

    // v6.2 - 20/08/09 - Added new fields for EC Services support
    Function GetECService : Boolean; Override;
    Procedure SetECService (Value : Boolean); Override;
    Function GetServiceStartDate : cuLongDate; Override;
    Procedure SetServiceStartDate (Value : cuLongDate); Override;
    Function GetServiceEndDate : cuLongDate; Override;
    Procedure SetServiceEndDate (Value : cuLongDate); Override;
    Function GetECSalesTaxReported : Double; Override;
    Procedure SetECSalesTaxReported (Value : Double); Override;
    Function GetPurchaseServiceTax : Double; Override;
    Procedure SetPurchaseServiceTax (Value : Double); Override;

    // v6.3 - 02/02/10 - Added new fields for Web Extensions support
    Function GetReference : cuStr20; Override;
    Procedure SetReference (Value : cuStr20); Override;
    Function GetReceiptNo : cuStr20; Override;
    Procedure SetReceiptNo (Value : cuStr20); Override;
    Function GetFromPostCode : cuStr15; Override;
    Procedure SetFromPostCode (Value : cuStr15); Override;
    Function GetToPostCode : cuStr15; Override;
    Procedure SetToPostCode (Value : cuStr15); Override;

    // v6.9 30/09/2011 ABSEXCH-11716/ABSEXCH-11721 - TAbsInvLine9
    Function GetUserDef5 : cuStr30; Override;
    Procedure SetUserDef5 (Value : cuStr30); Override;
    Function GetUserDef6 : cuStr30; Override;
    Procedure SetUserDef6 (Value : cuStr30); Override;
    Function GetUserDef7 : cuStr30; Override;
    Procedure SetUserDef7 (Value : cuStr30); Override;
    Function GetUserDef8 : cuStr30; Override;
    Procedure SetUserDef8 (Value : cuStr30); Override;
    Function GetUserDef9 : cuStr30; Override;
    Procedure SetUserDef9 (Value : cuStr30); Override;
    Function GetUserDef10 : cuStr30; Override;
    Procedure SetUserDef10 (Value : cuStr30); Override;

    // MH 20/01/2016 Exch2016-R1: Intrastat enhancements - TAbsInvLine10
    Function GetIntrastatOverride : Boolean; Override;
    Procedure SetIntrastatOverride (Value : Boolean); Override;
    Function GetIntrastatCommodityCode : cuStr10; Override;
    Procedure SetIntrastatCommodityCode (Value : cuStr10); Override;
    Function GetIntrastatStockUnits : Double; Override;
    Procedure SetIntrastatStockUnits (Value : Double); Override;
    Function GetIntrastatCountry : cuStr2; Override;
    Procedure SetIntrastatCountry (Value : cuStr2); Override;
    Function GetIntrastatNoTC : cuStr2; Override;
    Procedure SetIntrastatNoTC (Value : cuStr2); Override;
    Function GetIntrastatUplift : Double; Override;
    Procedure SetIntrastatUplift (Value : Double); Override;
  Public
    Constructor Create(      hEntSys           : TEnterpriseSystem;
                       Const WinId, HandlerId  : LongInt;
                       Const ParentInv         : TAbsInvoice;
                       Const InvLine           : IDetail;
                       Const Mode              : Byte;
                       Const IdRecAddr         : LongInt;
                       Const OrdPayLimitedEdit : Boolean);
    Procedure Replicate(Const ReplItem : SmallInt);

    Function entInvLTotal(UseDisc    :  Boolean;
                          SetlDisc   :  Double)  :  Double; Override;

    Procedure Delete; Override;
    Procedure Save;   Override;

    //PR 25/07/06
    function DirectPaymentLine : Boolean;
    function DirectInvoiceLine : Boolean;

    Function  LinkToStock : Boolean; Override;

    // Calculates the line discount for the line including any Transaction Total, Value Based or Multi-Buy Discounts
    Function entCalcLineDiscount(SettlementDiscount : Double; SettlementDiscountType : Char) : Double; Override;
  End; { TInvLine }


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses Math, CustWinU, ETMiscU, EtStrU, VARRec2U,ComnUnit, ComnU2, BtKeys1U, oInv,
     MiscU, SalTXL1U, InvListU, InvCt2su, ExWrap1U, BtrvU2, oStock,

     {$IFDEF STK}
       SalTxl2U,
     {$ENDIF}

     {$IFDEF PF_On}
       InvLst2U,
     {$ENDIF}

     PWarnU,
     PayF2U,
     SysU3,
     InvFSu3U,
     InvCTSuU,
     {$IFDEF STK}
       WorLineU,
     {$ENDIF}

     SysU2;


Const
  InvLineErrStr = 'Transaction Line ';

  // MH 06/08/2012 v7.0 ABSEXCH-12414: Extended to allow User Defined Fields to be written
  idxUserDef1  = 53;
  idxUserDef2  = 54;
  idxUserDef3  = 55;
  idxUserDef4  = 56;

  idxUserDef5  = 81;
  idxUserDef6  = 82;
  idxUserDef7  = 83;
  idxUserDef8  = 84;
  idxUserDef9  = 85;
  idxUserDef10 = 86;

  // MH 20/01/2016 Exch2016-R1: Intrastat enhancements - TAbsInvLine10
  idxIntrastatOverride = 87;
  idxIntrastatCommodityCode = 88;
  idxIntrastatStockUnits = 89;
  idxIntrastatCountry = 90;
  idxIntrastatNoTC = 91;
  idxtrastatUplift = 92;

//=========================================================================

Constructor TInvLine.Create(      hEntSys           : TEnterpriseSystem;
                            Const WinId, HandlerId  : LongInt;
                            Const ParentInv         : TAbsInvoice;
                            Const InvLine           : IDetail;
                            Const Mode              : Byte;
                            Const IdRecAddr         : LongInt;
                            Const OrdPayLimitedEdit : Boolean);
Const
  ReadOnlySet = [1..3,5,12..15,22..24,26,27,38..41,45,46,48,50..54,58,87];
Var
  I : SmallInt;
Begin
  Inherited Create;

  EntSys := hEntSys;
  MainInv := TABSInvoice7(ParentInv);
  RecAddr := IdRecAddr;

  EditMode := Mode;
  RecChanged := False;
  FirstQty := True;
  BadQty := False;

  If (EditMode In [0,1]) Then Begin
    { Normal Edit/Add }
    Case WinId of
      EnterpriseBase+1000,
      EnterpriseBase+2000,
      EnterpriseBase+2050,
      EnterpriseBase+3000,
      EnterpriseBase+3100,               { Stock Record - Stock Batch Entry }
      EnterpriseBase+4000,
      EnterpriseBase+5000,                { Job Record }
      EnterpriseBase+MiscBase+1  : RecAccess:=ReadOnly;
    Else
      RecAccess:=NotAvailable;
    End; { If }
  End { If }
  Else
    { Line added through customisation }
    RecAccess := ReadWrite;

  { Load fields from ExLocal }
  FillChar (DataRec, SizeOf (DataRec), #0);
  RecChanged := False;
  If (RecAccess <> NotAvailable) Then Begin
    DataRec := InvLine;
  End; { If }
  OrigRec := DataRec;

  { Adjust Security Access for field by Window and Event }
  If (RecAccess <> NotAvailable) Then
  Begin
    { Set Default Security options }
    For I := Low(PropAccess) To High(PropAccess) Do
      If (RecAccess = ReadOnly) Or (I In ReadOnlySet) Then
        PropAccess[I] := paReadOnly
      Else
        PropAccess[I] := paReadWrite;

    { Disable additional functions }
    For I := Low(FuncAccess) To High(FuncAccess) Do
      FuncAccess[I] := pfDisabled;

    { Modify default for specific cases }
    Case ((WinId * 1000) + HandlerId) Of
      102000001   { Transaction - Before Save }
           :   Begin
                 PropAccess[4]  := paReadWrite; {* Nominal Code *}
                 PropAccess[7]  := paReadWrite; {* Year *}
                 PropAccess[8]  := paReadWrite; {* Period *}
                 PropAccess[9]  := paReadWrite; {* CC *}
                 PropAccess[10] := paReadWrite; {* Dept *}
                 PropAccess[28] := paReadWrite; {* Cost Price*}
                 PropAccess[32] := paReadWrite; {* Description *}
                 PropAccess[49] := paReadWrite; {* LineType *}
                 PropAccess[53] := paReadWrite; {* UD1 *}
                 PropAccess[54] := paReadWrite; {* UD2 *}
                 PropAccess[55] := paReadWrite; {* UD3 *}
                 PropAccess[56] := paReadWrite; {* UD4 *}

                 //PR: 14/10/2011 New Udfs for v6.9
                 PropAccess[idxUserDef5] := paReadWrite; {* UD5 *}
                 PropAccess[idxUserDef6] := paReadWrite; {* UD6 *}
                 PropAccess[idxUserDef7] := paReadWrite; {* UD7 *}
                 PropAccess[idxUserDef8] := paReadWrite; {* UD8 *}
                 PropAccess[idxUserDef9] := paReadWrite; {* UD9 *}
                 PropAccess[idxUserDef10] := paReadWrite; {* UD10 *}

                 // HM 12/07/00: Changed as surely should be Line Position not ABS Line Number !
                 PropAccess[2] := paReadWrite; {* Line No *}
                 //PropAccess[12] := paReadWrite; {* Line No *}

                 // MH 23/09/2014 Order Payments: Added limited edit mode for order payment transactions
                 If (Not OrdPayLimitedEdit) Then
                 Begin
                   PropAccess[6]  := paReadWrite; {* currency *}
                   PropAccess[16] := paReadWrite; {* Quantity *}
                   PropAccess[17] := paReadWrite; {* Qty Mul *}
                   PropAccess[18] := paReadWrite; {* NetValue *}
                   PropAccess[19] := paReadWrite; {* Discount *}
                   PropAccess[20] := paReadWrite; {* VAT Code *}
                   PropAccess[21] := paReadWrite; {* VAT Amount *}
                   PropAccess[25] := paReadWrite; {* Discount Flg Chr *}
                   PropAccess[42] := paReadWrite; {* Location *}

                   {$IFDEF SOP}
                     // MH 15/06/2009: Added support for Advanecd Discounts
                     PropAccess[67] := paReadWrite;  // tlMultiBuyDiscount
                     PropAccess[68] := paReadWrite;  // tlMultiBuyDiscountFlag
                     If Syss.EnableTTDDiscounts Or Syss.EnableVBDDiscounts Then
                     Begin
                       PropAccess[69] := paReadWrite;  // tlTransValueDiscount
                       PropAccess[70] := paReadWrite;  // tlTransValueDiscountFlag
                       PropAccess[71] := paReadWrite;  // tlTransValueDiscountType
                     End; // If Syss.EnableTTDDiscounts Or Syss.EnableVBDDiscounts
                   {$ENDIF}

                   FuncAccess[1] := pfEnabled; { Delete }
                   FuncAccess[2] := pfEnabled; { Save }
                 End; // If (Not OrdPayLimitedEdit)

                 FuncAccess[3] := pfEnabled; { LinkToStock }
               End;

      102000031, 102000032, { Custom Buttons on Main Sales Transactions }
      102000041, 102000042  { Custom Buttons on Main Purchase Transactions }
             : Begin
                 PropAccess[28] := paReadWrite;  { Cost Price }

                 // MH 06/08/2012 v7.0 ABSEXCH-12414: Extended to allow User Defined Fields to be written to
                 PropAccess[idxUserDef1] := paReadWrite; {* UD1 *}
                 PropAccess[idxUserDef2] := paReadWrite; {* UD2 *}
                 PropAccess[idxUserDef3] := paReadWrite; {* UD3 *}
                 PropAccess[idxUserDef4] := paReadWrite; {* UD4 *}
                 PropAccess[idxUserDef5] := paReadWrite; {* UD5 *}
                 PropAccess[idxUserDef6] := paReadWrite; {* UD6 *}
                 PropAccess[idxUserDef7] := paReadWrite; {* UD7 *}
                 PropAccess[idxUserDef8] := paReadWrite; {* UD8 *}
                 PropAccess[idxUserDef9] := paReadWrite; {* UD9 *}
                 PropAccess[idxUserDef10] := paReadWrite; {* UD10 *}

                 FuncAccess[2]  := pfEnabled;    { Save }
                 FuncAccess[3]  := pfEnabled;    { LinkToStock }
               End;

      102000188  { Fired during b2b creation to allow unit price to be overwritten}
             : Begin
                 PropAccess[18] := paReadWrite; {* Net Value *}
                 PropAccess[19] := paReadWrite; {* Discount *}
                 PropAccess[25] := paReadWrite; {* Discount Chr*}
               End;

      102050100, 102050101  { Fired during batch receipts/ payments to allow the cheque number to be overwritten }
             : Begin
                 PropAccess[32] := paReadWrite; {* Description *}
               End;

      104000001,
      104000002   { Transaction - Before Qty Enter  }
           :   Begin
                 // MH 23/09/2014 Order Payments: Added limited edit mode for order payment transactions
                 If (Not OrdPayLimitedEdit) Then
                 Begin
                   PropAccess[16] := paReadWrite; {* Quantity *}
                   PropAccess[17] := paReadWrite; {* Qty Mul *}
                   PropAccess[18] := paReadWrite; {* Net Value *}
                 End; // If (Not OrdPayLimitedEdit)

                 PropAccess[53] := paReadWrite; {* UD1 *}
                 PropAccess[54] := paReadWrite; {* UD2 *}
                 PropAccess[55] := paReadWrite; {* UD3 *}
                 PropAccess[56] := paReadWrite; {* UD5 *}

                 //PR: 14/10/2011 New Udfs for v6.9
                 PropAccess[idxUserDef5] := paReadWrite; {* UD5 *}
                 PropAccess[idxUserDef6] := paReadWrite; {* UD6 *}
                 PropAccess[idxUserDef7] := paReadWrite; {* UD7 *}
                 PropAccess[idxUserDef8] := paReadWrite; {* UD8 *}
                 PropAccess[idxUserDef9] := paReadWrite; {* UD9 *}
                 PropAccess[idxUserDef10] := paReadWrite; {* UD10 *}


               End;

      104000003,   { Transaction - After Qty Enter  }
      104000090,
      104000091,
      104000092

           :   Begin
                 PropAccess[53] := paReadWrite; {* UD1 *}
                 PropAccess[54] := paReadWrite; {* UD2 *}
                 PropAccess[55] := paReadWrite; {* UD3 *}
                 PropAccess[56] := paReadWrite; {* UD5 *}

                 //PR: 14/10/2011 New Udfs for v6.9
                 PropAccess[idxUserDef5] := paReadWrite; {* UD5 *}
                 PropAccess[idxUserDef6] := paReadWrite; {* UD6 *}
                 PropAccess[idxUserDef7] := paReadWrite; {* UD7 *}
                 PropAccess[idxUserDef8] := paReadWrite; {* UD8 *}
                 PropAccess[idxUserDef9] := paReadWrite; {* UD9 *}
                 PropAccess[idxUserDef10] := paReadWrite; {* UD10 *}


               End;
      104000004   { Transaction - After Unit Price  }

           :   Begin
                 // MH 23/09/2014 Order Payments: Added limited edit mode for order payment transactions
                 If (Not OrdPayLimitedEdit) Then
                 Begin
                   PropAccess[18] := paReadWrite; {* NetValue *}
                   PropAccess[61] := paReadWrite; {* VAT Inc Value *}
                 End; // If (Not OrdPayLimitedEdit)
               End;

      104000005   { Transaction - After Discount  }
           :   Begin

               End;

      104000006   { Transaction - After VATCode  }
           :   Begin
                 // MH 23/09/2014 Order Payments: Added limited edit mode for order payment transactions
                 If (Not OrdPayLimitedEdit) Then
                 Begin
                   PropAccess[20] := paReadWrite; {* VAT Code *}
                 End; // If (Not OrdPayLimitedEdit)
               End;

      104000007   { Transaction - Before Tx Line closes }
           :   Begin

               End;

      104000008   { Transaction - As Tx Line Is displayed}
           :   Begin

               End;

      104000009,
      104000011,
      104000012   { 09 Transaction - Before unit price is entered }
                  { 11 As Stock code is exited }
                  { 12 As Qty is exited }
           :   Begin
                 // MH 23/09/2014 Order Payments: Added limited edit mode for order payment transactions
                 If (Not OrdPayLimitedEdit) Then
                 Begin
                   PropAccess[18] := paReadWrite; {* NetValue *}

                   PropAccess[19] := paReadWrite; {* Discount *}
                   PropAccess[25] := paReadWrite; {* Discflg *}

                   If (HandlerId=11) then
                     PropAccess[20] := paReadWrite; {* VAT Code *}

                   PropAccess[61] := paReadWrite; {* VAT Inv Value *}
                 End; // If (Not OrdPayLimitedEdit)

                 PropAccess[28] := paReadWrite; {* Costprice/Uplift *}

                 If (HandlerId=12) then
                 Begin
                   PropAccess[53] := paReadWrite; {* UD1 *}
                   PropAccess[54] := paReadWrite; {* UD2 *}
                   PropAccess[55] := paReadWrite; {* UD3 *}
                   PropAccess[56] := paReadWrite; {* UD5 *}

                   //PR: 14/10/2011 New Udfs for v6.9
                   PropAccess[idxUserDef5] := paReadWrite; {* UD5 *}
                   PropAccess[idxUserDef6] := paReadWrite; {* UD6 *}
                   PropAccess[idxUserDef7] := paReadWrite; {* UD7 *}
                   PropAccess[idxUserDef8] := paReadWrite; {* UD8 *}
                   PropAccess[idxUserDef9] := paReadWrite; {* UD9 *}
                   PropAccess[idxUserDef10] := paReadWrite; {* UD10 *}

                 end;

               End;

      104000010   { Transaction Line - Before Storing Line }
           :   Begin
                 // MH 23/09/2014 Order Payments: Added limited edit mode for order payment transactions
                 If (Not OrdPayLimitedEdit) Then
                 Begin
                   PropAccess[18] := paReadWrite; {* NetValue *}
                   PropAccess[19] := paReadWrite; {* Discount *}
                   PropAccess[25] := paReadWrite; {* Discflg *}
                 End; // If (Not OrdPayLimitedEdit)

                 PropAccess[33] := paReadWrite;  { Job Code }
                 PropAccess[34] := paReadWrite;  { Analysis Code }
                 PropAccess[37] := paReadWrite;  { Line unit weight }

                 PropAccess[53] := paReadWrite; {* UD1 *}
                 PropAccess[54] := paReadWrite; {* UD2 *}
                 PropAccess[55] := paReadWrite; {* UD3 *}
                 PropAccess[56] := paReadWrite; {* UD5 *}

                 //PR: 14/10/2011 New Udfs for v6.9
                 PropAccess[idxUserDef5] := paReadWrite; {* UD5 *}
                 PropAccess[idxUserDef6] := paReadWrite; {* UD6 *}
                 PropAccess[idxUserDef7] := paReadWrite; {* UD7 *}
                 PropAccess[idxUserDef8] := paReadWrite; {* UD8 *}
                 PropAccess[idxUserDef9] := paReadWrite; {* UD9 *}
                 PropAccess[idxUserDef10] := paReadWrite; {* UD10 *}
               End;

      104000013   { Transaction Line - On exit of Qty Picked, set Qty Written Off }
           :   Begin
                 PropAccess[44] := paReadWrite;  { Qty Written Off }
               End;

      104000014   { Transaction Line - On Store of line prompt for label print for product }
           :   Begin

               End;

      // MH 16/12/2014 ABSEXCH-15911: Split out 4000/15 (TL) and 4000/58 (Telesales)
      104000015
           :   Begin
                 // MH 23/09/2014 Order Payments: Added limited edit mode for order payment transactions
                 If (Not OrdPayLimitedEdit) Then
                 Begin
                   PropAccess[11] := paReadWrite; {* StockCode *}

                   If (HandlerId=15) then
                     PropAccess[16] := paReadWrite; {* Qty *}
                 End; // If (Not OrdPayLimitedEdit)
               End;
      104000058   { As stock code is exited }
           :   Begin
                 PropAccess[11] := paReadWrite; {* StockCode *}
               End;


      104000016   { As CC is exited }
           :   Begin
                 PropAccess[09] := paReadWrite; {* CC *}
               End;

      104000017   { As Dep code is exited }
           :   Begin
                 PropAccess[10] := paReadWrite; {* Dep *}
               End;


      104000025,
      104000087   { As qty is exited on TS}
           :   Begin
                 PropAccess[16] := paReadWrite; {*  TS Qty *}
               End;

      104000031   { UD1 Validation}
           :   Begin
                 PropAccess[53]:=paReadWrite;
               end;

      104000032   { UD2 Validation}
           :   Begin
                 PropAccess[54]:=paReadWrite;
               end;

      104000033   { UD3 Validation}
           :   Begin
                 PropAccess[55]:=paReadWrite;
               end;

      104000034   { UD4 Validation}
           :   Begin
                 PropAccess[56]:=paReadWrite;
               end;

      104000051,   { GL Code Substitution during ReValuation }
      105000080   { GL Code Substitution during job costing invoice wizard creation }
           :   Begin
                 PropAccess[4]  := paReadWrite; {* Nominal Code *}
               end;

      104000055   { Timesheet charge out rate exit}
           :   Begin
                 PropAccess[28] := paReadWrite; {* Cost Price *}
               end;
      104000056   { Qty pick exit}
           :   Begin
                 PropAccess[43] := paReadWrite; {* Qty Picked *}
               end;

      104000059   { Location Code }
           :   Begin
                 PropAccess[42] := paReadWrite; {* Line Location *}
               end;
      104000100   { CC/Dep override on Nom generated from ADJ hidden lines}
           :   Begin
                 PropAccess[09] := paReadWrite; {* CC *}
                 PropAccess[10] := paReadWrite; {* Dep *}
               end;

      105000100,
      105000101,
      105000103
        { XChange & UDF rate Substitution during job costing post timesheet routine}
           :   Begin
                 If (HandlerId=100) then
                 Begin
                   PropAccess[06]  := paReadWrite; {* Line Currency *}
                   PropAccess[36]  := paReadWrite; {* Daily Rate *}


                 end;
                 {PropAccess[35]  := paReadWrite; {* Company Rate *}

                 PropAccess[53]:=paReadWrite;    {* UD 1 *}
                 PropAccess[54]:=paReadWrite;    {* UD 2 *}
                 PropAccess[55]:=paReadWrite;    {* UD 3 *}
                 PropAccess[56]:=paReadWrite;    {* UD 4 *}

                 //PR: 14/10/2011 New Udfs for v6.9
                 PropAccess[idxUserDef5] := paReadWrite; {* UD5 *}
                 PropAccess[idxUserDef6] := paReadWrite; {* UD6 *}
                 PropAccess[idxUserDef7] := paReadWrite; {* UD7 *}
                 PropAccess[idxUserDef8] := paReadWrite; {* UD8 *}
                 PropAccess[idxUserDef9] := paReadWrite; {* UD9 *}
                 PropAccess[idxUserDef10] := paReadWrite; {* UD10 *}

               end;

      190001001   { Miscellaneous - VAT Code Calculation }
           :   Begin
                 PropAccess[18] := paReadWrite; {* Net Value  *}
                 PropAccess[20] := paReadWrite; {* VAT Code *}
                 PropAccess[21] := paReadWrite; {* VAT Amount *}
                 PropAccess[61] := paReadWrite; {* VAT Inc Amount *}
               end;

      //PR: 14/10/2011 New UDFs for v6.9
      104000211   { UD5 Validation}
           :   Begin
                 PropAccess[idxUserDef5]:=paReadWrite;
               end;

      104000212   { UD6 Validation}
           :   Begin
                 PropAccess[idxUserDef6]:=paReadWrite;
               end;

      104000213   { UD7 Validation}
           :   Begin
                 PropAccess[idxUserDef7]:=paReadWrite;
               end;

      104000214   { UD8 Validation}
           :   Begin
                 PropAccess[idxUserDef8]:=paReadWrite;
               end;

      104000215   { UD9 Validation}
           :   Begin
                 PropAccess[idxUserDef9]:=paReadWrite;
               end;

      104000216   { UD10 Validation}
           :   Begin
                 PropAccess[idxUserDef10]:=paReadWrite;
               end;

    End; { Case }

  End; { If }
End;

Function TInvLine.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

Function TInvLine.GetRecChanged : Boolean;
Begin
  Result := RecChanged;
End;

Function TInvLine.GetFolioRef : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.FolioRef
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'Folio');
  End; { Else }
End;

Procedure TInvLine.SetFolioRef(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[1] = paReadWrite) Then Begin
    If (DataRec.FolioRef <> Value) Then Begin
      DataRec.FolioRef := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'Folio');
End;

Function TInvLine.GetLineNo : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LineNo
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'LinePos');
  End; { Else }
End;

Procedure TInvLine.SetLineNo(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[2] = paReadWrite) Then Begin
    If (DataRec.LineNo <> Value) Then Begin
      DataRec.LineNo := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'LinePos');
End;

Function TInvLine.GetPostedRun : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PostedRun
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'RunNo');
  End; { Else }
End;

Procedure TInvLine.SetPostedRun(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[3] = paReadWrite) Then Begin
    If (DataRec.PostedRun <> Value) Then Begin
      DataRec.PostedRun := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'RunNo');
End;

Function TInvLine.GetNomCode : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.NomCode
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'GLCode');
  End; { Else }
End;

Procedure TInvLine.SetNomCode(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[4] = paReadWrite) Then Begin
    If (DataRec.NomCode <> Value) Then Begin
      If EntSys.ValidNomCode(Value, 1 + Ord((DataRec.Qty * DataRec.NetValue) > 0.0)) Then Begin
        DataRec.NomCode := Value;
        RecChanged := True;
      End { If }
      Else
        Entsys.CustomException (InvLineErrStr + 'GLCode');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'GLCode');
End;

Function TInvLine.GetNomMode : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.NomMode
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'ShowInGL');
  End; { Else }
End;

Procedure TInvLine.SetNomMode(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[5] = paReadWrite) Then Begin
    If (DataRec.NomMode <> Value) Then Begin
      If True Then Begin
        DataRec.NomMode := Value;
        RecChanged := True;
      End { If }
      Else
        Entsys.CustomException (InvLineErrStr + 'ShowInGL');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'ShowInGL');
End;

Function TInvLine.GetCurrency : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Currency
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'Currency');
  End; { Else }
End;

Procedure TInvLine.SetCurrency(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[6] = paReadWrite) Then Begin
    If (DataRec.Currency <> Value) Then Begin
      { Can only be set for ADJ & NOM's, otherwise set through Invoice Header }
      If EntSys.ValidCcy(Value) And
         (DataRec.IdDocHed In [ADJ, NMT]) And
         Check_GLCurr(TInvoice(MainInv).Invoice, DataRec, 0) Then Begin
        DataRec.Currency := Value;
        RecChanged := True;
      End { If }
      Else
        Entsys.CustomException (InvLineErrStr + 'Currency');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'Currency');
End;

Function TInvLine.GetPYr : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PYr
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'Year');
  End; { Else }
End;

Function TInvLine.GetPPr : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PPr
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'Period');
  End; { Else }
End;

Function TInvLine.GetCCDep1 : cuStr3;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CCDep[True]
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'CostCentre');
  End; { Else }
End;

Procedure TInvLine.SetCCDep1(Value : cuStr3);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[9] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), CCKeyLen);
    If (DataRec.CCDep[True] <> TmpStr) Then Begin
      { Can be blank if not using CC/Dept, else must be set }
      If ((Not Syss.UseCCDep) And (Trim(TmpStr) = '')) Or
         EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[True],TmpStr),PWrdF,PWK) Then Begin
        DataRec.CCDep[True] := TmpStr;
        RecChanged := True;
      End { If }
      Else
        Entsys.CustomException (InvLineErrStr + 'CostCentre');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'CostCentre');
End;

Function TInvLine.GetCCDep2 : cuStr3;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CCDep[False]
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'Department');
  End; { Else }
End;

Procedure TInvLine.SetCCDep2(Value : cuStr3);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[10] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), CCKeyLen);
    If (DataRec.CCDep[False] <> TmpStr) Then Begin
      { Can be blank if not using CC/Dept, else must be set }
      If ((Not Syss.UseCCDep) And (Trim(TmpStr) = '')) Or
         EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[False],TmpStr),PWrdF,PWK) Then Begin
        DataRec.CCDep[False] := TmpStr;
        RecChanged := True;
      End { If }
      Else
        Entsys.CustomException (InvLineErrStr + 'Department');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'Department');
End;

Function TInvLine.GetStockCode : cuStr16;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StockCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'StockCode');
  End; { Else }
End;

Procedure TInvLine.SetStockCode(Value : cuStr16);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[11] = paReadWrite) Then Begin
    TmpStr := FullStockCode(Value);
    If (DataRec.StockCode <> TmpStr) Then Begin
      {$IFDEF STK}
        If (Trim(TmpStr) = '') or (GetIDDocHed = cuTSH) Or EntSys.StockExists(TmpStr, [StkStkCode,StkDescCode,
                                                       StkDListCode,StkBillCode]) Then Begin
          DataRec.StockCode := TmpStr;
          RecChanged := True;
        End { If }
        Else
          Entsys.CustomException (InvLineErrStr + 'StockCode');
      {$ELSE}
        { Non-Stock version - use as a free format text field }
        DataRec.StockCode := TmpStr;
        RecChanged := True;
      {$ENDIF}
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'StockCode');
End;

Function TInvLine.GetABSLineNo : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ABSLineNo
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'LineNo');
  End; { Else }
End;

Procedure TInvLine.SetABSLineNo(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[12] = paReadWrite) Then Begin
    If (DataRec.ABSLineNo <> Value) Then Begin
      DataRec.ABSLineNo := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'LineNo');
End;

Function TInvLine.GetLineType : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LineType
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'LineClass');
  End; { Else }
End;

Function TInvLine.GetIdDocHed : cuDocTypes;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := cuDocTypes(DataRec.IdDocHed)
  Else Begin
    Result := cuDocTypes(0);
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'DocType');
  End; { Else }
End;

Function TInvLine.GetQty : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Qty
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'Qty');
  End; { Else }
End;

{ Checks that the Qty has not taken the stock level -ve (if setup that way) }
Procedure TInvLine.CheckStkQty(LastQtyValue : Double);
{$IFDEF STK}
Var
  FoundCode  : Str20;
  FLowStk    : Boolean;
Begin
  With DataRec Do Begin
    { Calculate the previous allocated qty }
    If (EditMode In [0,1]) Then
      LastQtyValue := OrigRec.Qty * OrigRec.QtyMul
    Else
      If FirstQty then Begin
        FirstQty:=False;
        LastQtyValue := 0;
      End; { Else }

    { Check to see if we need to recheck the levels }
    If ((LastQtyValue <> (Qty * QtyMul)) or (BadQty)) And
       (KitLink=0) And (Not EmptyKey(StockCode,StkKeyLen)) Then Begin
      { Check to see if we need to recheck the levels (again) }
      If (DocTypes(MainInv.thInvDocHed) In StkDedSet+StkAllSet) and (Syss.UseStock) Then Begin
        { Get Stock record }
        If (Stock.StockCode <> StockCode) Then
{*EX32}   GetStock(Application.MainForm,StockCode,Foundcode,-1);

        { check stock level }
        FLowStk:=Boff;
        Check_StockCtrl(StockCode,
                        (Qty*QtyMul)-LastQtyValue,
                        0,
                        FLowStk,
                        IdDocHed,
                        DataRec,
                        Application.MainForm.Handle);

        BadQty:=FLowStk;
      End; { If }
    End; { If }
  End; { With }
{$ELSE}
Begin
{$ENDIF}
End;

Procedure TInvLine.SetQty(Value : Real);
Var
  LQVal : Double;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[16] = paReadWrite) Then Begin
    If (DataRec.Qty <> Value) Then Begin
      LQVal := (DataRec.Qty * DataRec.QtyMul);

      DataRec.Qty := Value;
      RecChanged := True;

      { Check stock level }
      CheckStkQty(LQVal);
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'Qty');
End;

Function TInvLine.GetQtyMul : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.QtyMul
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'QtyMul');
  End; { Else }
End;

Procedure TInvLine.SetQtyMul(Value : Real);
Var
  LQVal : Double;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[17] = paReadWrite) Then Begin
    If (DataRec.QtyMul <> Value) Then Begin
      LQVal := (DataRec.Qty * DataRec.QtyMul);

      DataRec.QtyMul := Value;
      RecChanged := True;

      { Check stock level }
      CheckStkQty(LQVal);
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'QtyMul');
End;

Function TInvLine.GetNetValue : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.NetValue
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'NetValue');
  End; { Else }
End;

Procedure TInvLine.SetNetValue(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[18] = paReadWrite) Then Begin
    If (DataRec.NetValue <> Value) Then Begin
      // HM 21/03/03: Changed to allow Net Value to be set to zero
      //If (Value <> 0.0) Or ((DataRec.IdDocHed In [NMT, TSH]) And (Value = 0.0)) Then Begin
        DataRec.NetValue := Value;
        RecChanged := True;
      //End { If }
      //Else
      //  Entsys.CustomException (InvLineErrStr + 'NetValue');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'NetValue');
End;

Function TInvLine.GetDiscount : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Discount
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'Discount');
  End; { Else }
End;

Procedure TInvLine.SetDiscount(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[19] = paReadWrite) Then Begin
    If (DataRec.Discount <> Value) Then Begin
      DataRec.Discount := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'Discount');
End;

Function TInvLine.GetVATCode : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.VATCode
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'VATCode');
  End; { Else }
End;

Procedure TInvLine.SetVATCode(Value : Char);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[20] = paReadWrite) Then Begin
    If (DataRec.VATCode <> Value) Then Begin
      If (Value In VATSet) Then Begin
        DataRec.VATCode := Value;
        RecChanged := True;
      End { If }
      Else
        Entsys.CustomException (InvLineErrStr + 'VATCode');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'VATCode');
End;

Function TInvLine.GetVAT : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.VAT
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'VATAmount');
  End; { Else }
End;

Procedure TInvLine.SetVAT(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[21] = paReadWrite) Then Begin
    If (DataRec.VAT <> Value) Then Begin
      DataRec.VAT := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'VATAmount');
End;

Function TInvLine.GetPayment : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Payment
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'PayStatus');
  End; { Else }
End;

Procedure TInvLine.SetPayment(Value : Char);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[22] = paReadWrite) Then Begin
    If (DataRec.Payment <> Value) Then Begin
      DataRec.Payment := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'PayStatus');
End;

Function TInvLine.GetPreviousBal : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PreviousBal
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'PrevGLBal');
  End; { Else }
End;

Procedure TInvLine.SetPreviousBal(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[23] = paReadWrite) Then Begin
    If (DataRec.PreviousBal <> Value) Then Begin
      DataRec.PreviousBal := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'PrevGLBal');
End;

Function TInvLine.GetReconcile : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Reconcile
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'RecStatus');
  End; { Else }
End;

Procedure TInvLine.SetReconcile(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[24] = paReadWrite) Then Begin
    If (DataRec.Reconcile <> Value) Then Begin
      DataRec.Reconcile := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'RecStatus');
End;

Function TInvLine.GetDiscountChr : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DiscountChr
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'DiscFlag');
  End; { Else }
End;

Procedure TInvLine.SetDiscountChr(Value : Char);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[25] = paReadWrite) Then Begin
    If (DataRec.DiscountChr <> Value) Then Begin
      If (Value In StkBandSet+[#0,#32,PcntChr]) Then Begin
        DataRec.DiscountChr := Value;
        RecChanged := True;
      End { If }
      Else
        Entsys.CustomException (InvLineErrStr + 'DiscFlag');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'DiscFlag');
End;

Function TInvLine.GetQtyWOFF : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.QtyWOFF
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'QtyWOFF');
  End; { Else }
End;

Procedure TInvLine.SetQtyWOFF(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[26] = paReadWrite) Then Begin
    If (DataRec.QtyWOFF <> Value) Then Begin
      DataRec.QtyWOFF := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'QtyWOFF');
End;

Function TInvLine.GetQtyDel : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.QtyDel
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'QtyDel');
  End; { Else }
End;

Procedure TInvLine.SetQtyDel(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[27] = paReadWrite) Then Begin
    If (DataRec.QtyDel <> Value) Then Begin
      DataRec.QtyDel := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'QtyDel');
End;

Function TInvLine.GetCostPrice : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CostPrice
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'Cost');
  End; { Else }
End;

Procedure TInvLine.SetCostPrice(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[28] = paReadWrite) Then Begin
    If (DataRec.CostPrice <> Value) Then Begin
      DataRec.CostPrice := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'Cost');
End;

Function TInvLine.GetCustCode : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CustCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'AcCode');
  End; { Else }
End;

Function TInvLine.GetPDate : cuLongDate;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PDate
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'TransDate');
  End; { Else }
End;

Procedure TInvLine.SetPDate(Value : cuLongDate);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[30] = paReadWrite) Then Begin
    If (DataRec.PDate <> Value) Then Begin
      If EntSys.ValidDate(Value) Then Begin
        DataRec.PDate := Value;
        RecChanged := True;
      End { If }
      Else
        Entsys.CustomException (InvLineErrStr + 'TransDate');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'TransDate');
End;

Function TInvLine.GetItem : cuStr3;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Item
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'ItemNo');
  End; { Else }
End;

Procedure TInvLine.SetItem(Value : cuStr3);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[31] = paReadWrite) Then Begin
    If (DataRec.Item <> Value) Then Begin
      DataRec.Item := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'ItemNo');
End;

Function TInvLine.GetDesc : cuStr60;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Desc
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'Descr');
  End; { Else }
End;

Procedure TInvLine.SetDesc(Value : cuStr60);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[32] = paReadWrite) Then Begin
    If (DataRec.Desc <> Value) Then Begin
      DataRec.Desc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'Descr');
End;

Function TInvLine.GetJobCode : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JobCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'JobCode');
  End; { Else }
End;

Procedure TInvLine.SetJobCode(Value : cuStr10);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[33] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), JobKeyLen);
    If (DataRec.JobCode <> TmpStr) Then Begin
      If JBCostOn Then Begin
        { Job Costing is in use }
        If (Trim(TmpStr) = '') Or EntSys.CheckForRec(TmpStr,JobF,JobCodeK) Then Begin
          DataRec.JobCode := TmpStr;
          RecChanged := True;
        End { If }
        Else
          Entsys.CustomException (InvLineErrStr + 'JobCode');
      End { If }
      Else Begin
        { Not Job Costing - use as a free format text field }
        DataRec.JobCode := TmpStr;
        RecChanged := True;
      End; { Else }
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'JobCode');
End;

Function TInvLine.GetAnalCode : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.AnalCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'JobAnal');
  End; { Else }
End;

Procedure TInvLine.SetAnalCode(Value : cuStr10);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[34] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), AnalKeyLen);
    If (DataRec.AnalCode <> TmpStr) Then Begin
      If JBCostOn Then Begin
        { Job Costing is in use }
        If ((Trim(DataRec.JobCode) = '') And (Trim(TmpStr) = '')) Or
           EntSys.CheckForRec(FullJAKey(JARCode,JAACode,TmpStr),JMiscF,JMK) Then Begin
          DataRec.AnalCode := TmpStr;
          RecChanged := True;
        End { If }
        Else
          Entsys.CustomException (InvLineErrStr + 'JobAnal');
      End { If }
      Else Begin
        { Not Job Costing - use as a free format text field }
        DataRec.AnalCode := TmpStr;
        RecChanged := True;
      End; { Else }
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'JobAnal');
End;

Function TInvLine.GetCXrate1 : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CXrate[False]
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'CompanyRate');
  End; { Else }
End;

Procedure TInvLine.SetCXrate1(Value : Real);
Var
  Valid : Boolean;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[35] = paReadWrite) Then Begin
    If (DataRec.CXrate[False] <> Value) Then Begin
      Valid := True;

      If (Not (Syss.TotalConv<>XDayCode)) or (DataRec.IdDocHed In NomSplit) Then
        Valid := (Value <> 0.0);

      If Not (DataRec.IdDocHed In NomSplit) Then
        Value := 0.0;

      If Valid Then Begin
        DataRec.CXrate[False] := Value;
        RecChanged := True;
      End { If }
      Else
        Entsys.CustomException (InvLineErrStr + 'CompanyRate');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'CompanyRate');
End;

Function TInvLine.GetCXrate2 : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CXrate[True]
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'DailyRate');
  End; { Else }
End;

Procedure TInvLine.SetCXrate2(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[36] = paReadWrite) Then Begin
    If (DataRec.CXrate[True] <> Value) Then Begin
      If (Value <> 0.0) Then Begin
        DataRec.CXrate[True] := Value;
        RecChanged := True;
      End { If }
      Else
        Entsys.CustomException (InvLineErrStr + 'DailyRate');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'DailyRate');
End;

Function TInvLine.GetLWeight : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LWeight
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'UnitWeight');
  End; { Else }
End;

Procedure TInvLine.SetLWeight(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[37] = paReadWrite) Then Begin
    If (DataRec.LWeight <> Value) Then Begin
      DataRec.LWeight := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'UnitWeight');
End;

Function TInvLine.GetDeductQty : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DeductQty
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'StockDeductQty');
  End; { Else }
End;

Procedure TInvLine.SetDeductQty(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[38] = paReadWrite) Then Begin
    If (DataRec.DeductQty <> Value) Then Begin
      DataRec.DeductQty := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'StockDeductQty');
End;

Function TInvLine.GetKitLink : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.KitLink
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'BOMKitLink');
  End; { Else }
End;

Procedure TInvLine.SetKitLink(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[39] = paReadWrite) Then Begin
    If (DataRec.KitLink <> Value) Then Begin
      DataRec.KitLink := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'BOMKitLink');
End;

Function TInvLine.GetSOPLink : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SOPLink
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'OrderFolio');
  End; { Else }
End;

Procedure TInvLine.SetSOPLink(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[40] = paReadWrite) Then Begin
    If (DataRec.SOPLink <> Value) Then Begin
      If (Value = 0) Or EntSys.CheckForRec(FullNomKey(Value),InvF,InvFolioK) Then Begin
        DataRec.SOPLink := Value;
        RecChanged := True;
      End { If }
      Else
        Entsys.CustomException (InvLineErrStr + 'OrderFolio');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'OrderFolio');
End;

Function TInvLine.GetSOPLineNo : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SOPLineNo
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'OrderLineNo');
  End; { Else }
End;

Procedure TInvLine.SetSOPLineNo(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[41] = paReadWrite) Then Begin
    If (DataRec.SOPLineNo <> Value) Then Begin
      If (Value = 0) Or EntSys.CheckForRec(FullNomKey(DataRec.SOPLink)+FullNomKey(Value),IDetailF,IdFolioK) Then Begin
        DataRec.SOPLineNo := Value;
        RecChanged := True;
      End { If }
      Else
        Entsys.CustomException (InvLineErrStr + 'OrderLineNo');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'OrderLineNo');
End;

Function TInvLine.GetMLocStk : cuStr3;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.MLocStk
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'Location');
  End; { Else }
End;

Procedure TInvLine.SetMLocStk(Value : cuStr3);
Var
  TmpStr : ShortString;
  bOK : Boolean;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[42] = paReadWrite) Then
  Begin
    // MH 13/10/2010 v6.5: Modified to support Override Locations
    If Syss.EnableOverrideLocations And (DataRec.IdDocHed In PurchSplit) Then
      // Can only be changed if the Override Location is not set
      bOK := (Trim(MainInv.thOverrideLocation) = '')
    Else
      bOK := True;

    If bOK Then
    Begin
      TmpStr := LJVar(UpperCase(Value), MLocKeyLen);
      If (DataRec.MLocStk <> TmpStr) Then
      Begin
        { Can be blank if not using multi-location stock, else must be set and valid }
        If ((Not Syss.UseMLoc) And (Trim(TmpStr) = '')) Or
           EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[True],TmpStr),MLocF,MLK) Then
        Begin
          DataRec.MLocStk := TmpStr;
          RecChanged := True;
        End { If }
        Else
          Entsys.CustomException (InvLineErrStr + 'Location');
      End; { If }
    End // If bOK
    Else
      Raise Exception.Create ('The ' + InvLineErrStr + 'Location cannot be changed from the Override Location');
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'Location');
End;

Function TInvLine.GetQtyPick : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.QtyPick
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'QtyPicked');
  End; { Else }
End;

Procedure TInvLine.SetQtyPick(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[43] = paReadWrite) Then Begin
    If (DataRec.QtyPick <> Value) Then Begin
      //If (Value <= DataRec.Qty) Then Begin
        DataRec.QtyPick := Value;
        RecChanged := True;
      //End { If }
      //Else
      //  Entsys.CustomException (InvLineErrStr + 'QtyPicked');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'QtyPicked');
End;

Function TInvLine.GetQtyPWOff : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.QtyPWOff
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'QtyPickedWO');
  End; { Else }
End;

Procedure TInvLine.SetQtyPWOff(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[44] = paReadWrite) Then Begin
    If (DataRec.QtyPWOff <> Value) Then Begin
      If (Value <= DataRec.Qty) Then Begin
        DataRec.QtyPWOff := Value;
        RecChanged := True;
      End { If }
      Else
        Entsys.CustomException (InvLineErrStr + 'QtyPickedWO');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'QtyPickedWO');
End;

Function TInvLine.GetUsePack : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UsePack
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'UseQtyMul');
  End; { Else }
End;

Procedure TInvLine.SetUsePack(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[45] = paReadWrite) Then Begin
    If (DataRec.UsePack <> Value) Then Begin
      DataRec.UsePack := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'UseQtyMul');
End;

Function TInvLine.GetSerialQty : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SerialQty
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'NoSerialNos');
  End; { Else }
End;

Procedure TInvLine.SetSerialQty(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[46] = paReadWrite) Then Begin
    If (DataRec.SerialQty <> Value) Then Begin
      DataRec.SerialQty := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'NoSerialNos');
End;

Function TInvLine.GetCOSNomCode : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.COSNomCode
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'COSGL');
  End; { Else }
End;

Procedure TInvLine.SetCOSNomCode(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[47] = paReadWrite) Then Begin
    If (DataRec.COSNomCode <> Value) Then Begin
      If EntSys.ValidNomCode(Value, 1 + Ord (Syss.AutoValStk)) Then Begin
        DataRec.COSNomCode := Value;
        RecChanged := True;
      End { If }
      Else
        Entsys.CustomException (InvLineErrStr + 'COSGL');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'COSGL');
End;

Function TInvLine.GetDocPRef : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DocPRef
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'OurRef');
  End; { Else }
End;

Function TInvLine.GetDocLTLink : cuLineTIndex;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DocLTLink
  Else Begin
    Result := 1;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'LineType');
  End; { Else }
End;

Procedure TInvLine.SetDocLTLink(Value : cuLineTIndex);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[49] = paReadWrite) Then Begin
    If (DataRec.DocLTLink <> Value) Then Begin
      If (Value In [0..6]) Then Begin
        DataRec.DocLTLink := Value;
        RecChanged := True;
      End { If }
      Else
        Entsys.CustomException (InvLineErrStr + 'LineType');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'LineType');
End;

Function TInvLine.GetPrxPack : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PrxPack
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'PriceByPack');
  End; { Else }
End;

Procedure TInvLine.SetPrxPack(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[50] = paReadWrite) Then Begin
    If (DataRec.PrxPack <> Value) Then Begin
      DataRec.PrxPack := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'PriceByPack');
End;

Function TInvLine.GetQtyPack : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.QtyPack
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'QtyInPack');
  End; { Else }
End;

Procedure TInvLine.SetQtyPack(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[51] = paReadWrite) Then Begin
    If (DataRec.QtyPack <> Value) Then Begin
      DataRec.QtyPack := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'QtyInPack');
End;

Function TInvLine.GetReconDate : cuLongDate;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ReconDate
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'ClearDate');
  End; { Else }
End;

Procedure TInvLine.SetReconDate(Value : cuLongDate);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[52] = paReadWrite) Then Begin
    If (DataRec.ReconDate <> Value) Then Begin
      If EntSys.ValidDate(Value) Or (Value = NdxWeight) Then Begin
        DataRec.ReconDate := Value;
        RecChanged := True;
      End { If }
      Else
        Entsys.CustomException (InvLineErrStr + 'ClearDate');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'ClearDate');
End;

Procedure TInvLine.Replicate(Const ReplItem : SmallInt);
Begin
  Case ReplItem Of
    { Account Code }
    1 : DataRec.CustCode := MainInv.thAcCode;
    2 : DataRec.Currency := MainInv.thCurrency;
    3 : DataRec.PYr := MainInv.thYear;
    4 : DataRec.PPr := MainInv.thPeriod;
    5 : DataRec.IdDocHed := DocTypes(MainInv.thInvDocHed);
    6 : DataRec.DocPRef := MainInv.thOurRef;
  End; { Case }
End;


{* Calculte the line total, take into account pack sizes and line discount *}

Function TInvLine.entInvLTotal(UseDisc    :  Boolean;
                               SetlDisc   :  Double)  :  Double;
Var
  Rnum,
  WithDisc  :  Double;

  LineQty,
  CalcNetValue,
  PriceEach :  Double;

  UseDecs,
  UseQDecs  :  Byte;
Begin
  (* HM 30/08/00: Replaced calculation with updated v4.31 version
  Begin

    If (tlPricebyPack) and (tlQtyinPack<>0) and (tlQtyMul<>0) then
      PriceEach:=(DivWChk(tlQtyMul,tlQtyinPack)*tlNetValue)
    else
      PriceEach:=tlNetValue;

    If (tlDocType In [cuSIN..cuSDG]) then  {* No Dec places determines rounding effect on Purch/Sales *}
      UseDecs:=Syss.NoNetDec
    else
      UseDecs:=Syss.NoCosDec;

    Rnum:=Calc_PAmount(Round_Up(PriceEach,UseDecs),tlDiscount,tlDiscFlag);

    WithDisc:=Round_Up(Calc_IdQty(tlQty,tlQtyMul,tlUseQtyMul)*(Round_Up(PriceEach,UseDecs)-Rnum),2);

    WithDisc:=Round_Up(WithDisc-Calc_PAmount(WithDisc,SetlDisc,PcntChr),2);

    If (UseDisc) then
      Result:=WithDisc
    else
      Result:=Round_Up(Calc_IdQty(tlQty,tlQtyMul,tlUseQtyMul)*Round_Up(PriceEach,UseDecs),2);
  end;{With..}
  *)

  With DataRec do Begin
    If (DataRec.IdDocHed In SalesSplit) then  {* No Dec places determines rounding effect on Purch/Sales *}
      UseDecs:=Syss.NoNetDec
    else
      UseDecs:=Syss.NoCosDec;

    UseQDecs:=Syss.NoQtyDec;

    CalcNetValue:=0.0;

    LineQty:=Calc_IdQty(Qty,QtyMul,UsePack);

    {* Ability to affect unit price factor *}

    If (Round_Up(PriceMulX,UseDecs)<>0.0) then
      CalcNetValue:=(NetValue*PriceMulX)
    else
      CalcNetValue:=NetValue;


    If (PrxPack) and (QtyPack<>0) and (QtyMul<>0) then
    Begin
      If (ShowCase) then
      Begin
        PriceEach:=CalcNetValue;
        LineQty:=DivWChk(Qty,QtyPack);
        UseQDecs:=12;  {* If we are using split pack with cases, we cannot round up as it is a factor.. *}
      end
      else
        PriceEach:=(DivWChk(QtyMul,QtyPack)*CalcNetValue);
      {PriceEach:=(DivWChk(QtyMul,QtyPack)*NetValue);}
    end
    else
      PriceEach:=CalcNetValue;

    // MH 25/03/2009: Added support for 2 new discounts for Advanced Discounts
    //Rnum:=Calc_PAmount(Round_Up(PriceEach,UseDecs),Discount,DiscountChr);
    Rnum := Calc_PAmountAD (Round_Up(PriceEach, UseDecs),
                            Discount, DiscountChr,
                            Discount2, Discount2Chr,
                            Discount3, Discount3Chr);

    WithDisc:=Round_Up(Round_Up(LineQty,UseQDecs)*(Round_Up(PriceEach,UseDecs)-Rnum),2);

    WithDisc:=Round_Up(WithDisc-Calc_PAmount(WithDisc,SetlDisc,PcntChr),2);

    If (UseDisc) then
      Result:=WithDisc
    else
      Result:=Round_Up(Round_Up(LineQty,UseQDecs)*Round_Up(PriceEach,UseDecs),2);
  end;{With..}
end;

//-------------------------------------------------------------------------

// Calculates the line discount for the line including any Transaction Total, Value Based or Multi-Buy Discounts
Function TInvLine.entCalcLineDiscount(SettlementDiscount : Double; SettlementDiscountType : Char) : Double;
Begin // entCalcLineDiscount
  With DataRec Do
  Begin
    Result := Calc_PAmountAD (Round_Up(NetValue,IfThen(IdDocHed In SalesSplit, Syss.NoNetDec, Syss.NoCOSDec)),
                              Discount, DiscountChr,     // standard line discount
                              Discount2, Discount2Chr,   // multi-buy
                              Discount3, Discount3Chr);  // TTD/VBD
  End; // With DataRec
End; // entCalcLineDiscount

//-------------------------------------------------------------------------

{ Returns True if the line is valid }
Function TInvLine.CheckValid : Boolean;
Const
  ValidMsg : Array[1..13] Of Str50 = ('GL Code',
                                      'VAT Code',
                                      'Cost Centre',
                                      'Department',
                                      'Job Code',
                                      'Analysis Code',
                                      'Qty Delivered',
                                      'Line Value',
                                      'Stock Code',
                                      'Stock Levels',
                                      'Location',
                                      'G/L Code & Currency',
                                      'Committed Budget has been excceded');
                                      {Hook 14 deliberatly not set here as we cannot nest hooks within hooks}
Var
  BalNow    : Double;
  I         : Byte;
  DummyId   : IDetail;
  KeyS : Str255;
  EmpOrGlobal : Str10;
Begin
  Result := True;

  DummyId:=DataRec;

  With DummyId do {Force the old line value to be worthless for the committment accounting check}
  Begin
    Qty:=0.0;
    QtyMul:=0.0;
    NetValue:=0.0;
    CostPrice:=0.0;
    NomCode:=0;
  end;

  { Calculate Line Total as various checks only apply to lines with a value }
  BalNow:=InvLTotal(DataRec,BOff,0);

  With DataRec Do
    For I := Low(ValidMsg) To High(ValidMsg) Do Begin
      Case I Of
        1 : Begin { Nominal Code }
              If (BalNow <> 0.0) and (IDDocHed <> TSH) Then
                { Check Nominal Code is valid }
                Result := EntSys.ValidNomCode(NomCode, 1 + Ord((Qty * NetValue) > 0.0));
            End;

        2 : Begin { VAT Code }
              // MH 08/02/2011 v6.6 ABSEXCH-2136: Modified to exclude payment lines - which won't have a VAT Code
              If ((IdDocHed = SRI) And (Payment = 'Y')) Or ((IdDocHed = PPI) And (Payment = 'N')) Then
                Result := True
              Else
                If (BalNow <> 0.0) and (not (DataRec.IDDocHed in [NMT, TSH, ADJ, WOR, PPY, SRC])) Then
                  Result := (VATCode In VATSet);
            End;

       {$IFDEF PF_On}
       3 : Begin { Cost Centre }
              Result:=((Not Syss.UseCCDep) or (Not LComplete_CCDep(DataRec,BalNow)));

              If (Not Result) Then
                Result:=EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[True],CCDep[True]),
                                           PWrdF,PWK);
            End;

        4 : Begin { Department }
              Result:=((Not Syss.UseCCDep) or (Not LComplete_CCDep(DataRec,BalNow)));

              If (Not Result) Then
                Result:=EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[False],CCDep[False]),
                                           PWrdF,PWK);
            End;

        5 : Begin { Job Code }
              Result := (Not JBCostOn) or
                        (Not LComplete_JobAnl(DataRec,BalNow)) or
                        EmptyKey(JobCode,JobCodeLen);

              If (Not Result) then
                Result:=EntSys.CheckForRec(JobCode,JobF,JobCodeK);
            End;

        6 : Begin { Job Analysis }
              Result := (Not JBCostOn) or
                        (Not LComplete_JobAnl(DataRec,BalNow)) or
                        EmptyKey(JobCode,JobCodeLen);

              If (Not Result) then
                Result:=EntSys.CheckForRec(FullJAKey(JARCode,JAACode,AnalCode),JMiscF,JMK);
            End;
        {$ENDIF}

        {$IFDEF STK}
        (* Picking orders - not required yet
        7 : Begin { Over Delivery Warning }
              Result:=(Not (IdDocHed In OrderSet)) or
                      ((KitLink<>0) and (Not Is_FullStkCode(StockCode)));

              If (Not Result) then
                Result:=(Not Warn_OverDelv(DataRec,0,BOn,BOn));
            End;
        *)
        {$ENDIF}

        8 : Begin { Max Line Value }
              Result:=(BalNow<=MaxLineValue32);
            End;

        {$IFDEF STK}
        9 : Begin { Stock Code }
              // MH 08/02/2011 v6.6 ABSEXCH-2136: Modified to exclude SRI payment lines - which don't have a Stock Code
              //PR: 15/01/2009 Stock Code on Nominal Transfer line contains PayInRef, so don't validate (20070615122400}
              if (IDDocHed in [PPY, SRC, NMT]) Or ((IdDocHed = SRI) And (Payment = 'Y')) Or ((IdDocHed = PPI) And (Payment = 'N')) then
                Result := True
              else
              if IDDocHed in [TSH] then
              begin
                //Check employee rate first
                KeyS := JBRCode+JBPCode + Strip('R',[#0],FullJBCode(MainInv.thBatchLink,Currency,StockCode));
                Result :=  EntSys.LocalBtr^.LFind_Rec(B_GetEq, JCtrlF,JCK, KeyS) = 0;

                if not Result and (EntSys.LocalBtr^.LJobMisc.EmplRec.UseORate<>1) then
                begin
                  KeyS := JBRCode+JBECode + Strip('R',[#0],FullJBCode(FullNomKey(-1),Currency,StockCode));
                  Result :=  EntSys.LocalBtr^.LFind_Rec(B_GetEq, JCtrlF,JCK, KeyS) = 0;
                end;

              end
              else
              begin
                Result:=EmptyKey(StockCode,StkKeyLen) and not (IDDocHed in [ADJ, WOR]);

                If (Not Result) then
                  Result:=EntSys.StockExists(StockCode, [StkStkCode,
                                                         StkDescCode,
                                                         StkDListCode,
                                                         StkBillCode]);
              end;



            End;

        10: Begin { Low Stock Level }
              Result:=Not BadQty;
            End;
        {$ENDIF}

        {$IFDEF SOP}
        11: Begin { Location }
              If Syss.UseMLoc and LComplete_MLoc(DataRec) Then Begin
                { Check location valid }
                Result:=EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[True],MLocStk),MLocF,MLK)
              End; { If }
            End;
        {$ENDIF}

        12 :  Result:=Check_GLCurr(TInvoice(MainInv).Invoice,DataRec,0);

        {$IFDEF SOP}

          13 :  If (CommitAct) and (IdDocHed In OrderSet) then
                Begin
                  {$B-}

                  Result:=(PChkAllowed_In(268) and (DataRec.IdDocHed=SOR)) or (PChkAllowed_In(269) and (DataRec.IdDocHed=POR))
                          or (Not Check_OverCommited(DataRec,DummyId,BOff));

                  {$B+}

                end;

        {$ENDIF}



      End; { Case }

    { Quit now if its wrong }
    If (Not Result) Then Break;
  End; { For }

  If (Not Result) Then
    EntSys.CustomException (InvLineErrStr + ValidMsg[I]);
End;


function TInvLine.DirectPaymentLine : Boolean;
begin
  Result := (TInvoice(MainInv).Invoice.InvDocHed In [PPI, SRI]) and
             Is_PayInLine(DataRec.StockCode);
end;

//PR 25/07/06
function TInvLine.DirectInvoiceLine : Boolean;
begin
  Result := (TInvoice(MainInv).Invoice.InvDocHed In [PPI, SRI]) and
             not Is_PayInLine(DataRec.StockCode);
end;

{ Saves changes made to the line - only do-able for certain events }
Procedure TInvLine.Save;
Const
  FNum              = IDetailF;
  KeyPath : Integer = IDFolioK;
Var
  KeyS    : Str255;
  ExLocal : TdExLocal;
  Dnum,
  Dnum2    : Double;

  RestrictedEdit : Boolean;
  OKToContinue : Boolean;

  //PR 25/07/06: Moved functionality here as it is used by PPY/SRC and by payment lines on PPI/SRI
  procedure PaymentLineUpdateBalance;
  begin
    With EntSys.LocalBtr^ Do
    begin
     With LastId  do
       MiscU.UpdateRecBal(LInv,NomCode,(NetValue*DocNotCnst),0.0, CXRate,Currency,UseORate,1);

     With LId do
       MiscU.UpdateRecBal(LInv,NomCode,NetValue,0.0,CXRate,Currency,UseORate,1);


     With LId do
       If (IDDocHed In ChequeSet) and (Syss.AutoCQNo) then
         Put_NextChequeNo(Desc,BOn);
    end;
  end;

  procedure PaymentLineUpdateJobAct;
  begin
    With EntSys.LocalBtr^ Do
      If (JbCostOn) and ((DetLTotal(LId,BOn,BOff,0.0)<>0) or (DetLTotal(LastId,BOn,BOff,0.0)<>0) or
                        (LId.IdDocHed In StkADJSplit)) and (Not (LId.IdDocHed In PurchSet)) then
                          Update_JobAct(LId,LInv);
  end;

Begin
// HM 05/03/02: Prevent use of Delete Line for ADJ, NOM, TSH until code is
// (500CHK)     reviewed for accuracy
{If (TInvoice(MainInv).Invoice.InvDocHed In [ADJ, NMT, PPY, SRC, TSH, WOR]) Then
  Raise Exception.Create ('Save Method not available for this transaction type');}


  If (RecAccess <> NotAvailable) And
     (FuncAccess[2] = pfEnabled) And
     (EditMode In [0,2])  Then Begin
    If RecChanged Then Begin
      { Check the line has been set correctly }
      //PR: 23/11/2017 ABSEXCH-19451 Check if saving posted transaction.
      RestrictedEdit := TInvoice(MainInv).RestrictedEdit;
      //Don't call CheckValid if posted transaction
      if not RestrictedEdit then
        OKToContinue := CheckValid
      else
        OKToContinue := True;

      If OKToContinue Then Begin
        //PR 31/10/02 Set flag  to let Enterprise know that lines have changed
        //PR 25/07/06
//        if TInvoice(MainInv).Invoice.InvDocHed In [ADJ, NMT, PPY, SRC, TSH, WOR] then
        With EntSys.LocalBtr^ Do Begin
          LastId := OrigRec;
          LInv := TInvoice(MainInv).Invoice;
          EntSys.ResetDocTotals := True;

          //PR: 23/11/2017 ABSEXCH-19451 Don't adjust stock/recalc vat if posted edit
          if not RestrictedEdit then
          begin
          {$IFDEF STK}
            {$IFDEF SOP}
              { Get Stock Record }
              //PR 25/10/02
              //PR 25/07/06: add handling for direct transactions
              If not (TInvoice(MainInv).Invoice.InvDocHed In ([NMT, PPY, SRC, TSH] + DirectSet)) or
                      DirectInvoiceLine then
              begin
              //PR: 14/10/2010 Fix for ABSPLUG-198. Need to pad out stock code to full length.
//                KeyS := FullStockCode (DataRec.StockCode);
                DataRec.StockCode := FullStockCode (DataRec.StockCode);
                KeyS := DataRec.StockCode;
                LGetMainRec(StockF, KeyS);

                { Serial Numbers }
                Control_SNos(DataRec,
                             LInv,
                             LStock,
                             1,
                             Application.MainForm);

                //PR 25/10/02 Different for WOR lines
                If not (TInvoice(MainInv).Invoice.InvDocHed In [WOR]) then
                begin
                  Deduct_AdjStk(LastId,LInv,BOff);
                  Deduct_AdjStk(DataRec,LInv,BOn);
                end
                else
                begin
                  Deduct_WORStk(LastId,LInv,BOff);
                  Deduct_WORStk(LId,LInv,BOn);
                end;

              end;


            {$ENDIF}

              { Change Stock Levels }


          {$ENDIF}

          { Calc VAT }
          //PR: 25/10/02 Only for transactions with Vat
          //PR 25/07/06: add handling for direct transactions, where we want invoice lines only
            If not (TInvoice(MainInv).Invoice.InvDocHed In [ADJ, NMT, PPY, SRC, WOR, TSH] + DirectSet) or
                    DirectInvoiceLine then
            begin
              ExLocal.Create;
              Try
                ExLocal.LInv:=LInv;
                ExLocal.LId:=DataRec;

                CalcVATExLocal(ExLocal,BOff,Nil);

                DataRec := ExLocal.LId;
              Finally
                ExLocal.Destroy;
              end;
            end
            else
            begin
              DataRec.VATCode := ' ';
              DataRec.VAT := 0.0;
            end;
          end; //if not RestrictedEdit
          {
            CJS 24/01/2011 - ASBEXCH-9963 - Silently make sure that NOMMODE
            holds the correct value. If it is 2 (StkAdjNomMode), reset it
            to 0.
          }
          if (DataRec.IdDocHed <> ADJ) and (DataRec.NomMode = 2) then
            DataRec.NomMode := 0;

          If (EditMode = 0) And (RecAddr <> 0) Then Begin
            { Update Line Record }
            LastRecAddr[IDetailF] := RecAddr;
            LStatus := LGetDirectRec(IDetailF, IDFolioK);

            { Do paranoid check to see if we have the correct record }
            If (LId.FolioRef <> DataRec.FolioRef) Or (LId.ABSLineNo <> DataRec.ABSLineNo) Then
              LStatus := 4;

            If LStatusOk Then Begin
              { Update the little sucker }
              LId := DataRec;
              LStatus := LPut_Rec(IDetailF, IDFolioK);
            End; { If }
          End { If }
          Else Begin
            //Don't allow new line to be saved on posted edit
            if not RestrictedEdit then
            begin
              { Add new line record }
              Inc(LInv.ILineCount);

              LId := DataRec;
              LStatus := LAdd_Rec(IDetailF, 0);
            end;
          End; { Else }

          LReport_BError(IDetailF, LStatus);

          //PR: 23/11/2017 ABSEXCH-19451 Don't adjust stock, etc if posted edit
          If LStatusOK and not RestrictedEdit Then Begin
            { Save Position }
            LGetRecAddr(IDetailF);
            LStatus:=LPresrv_BTPos(FNum, KeyPath, LocalF^[Fnum],LastRecAddr[Fnum],BOff,BOff);

            { Update Record Balances }
            //PR 25/10/02 - Different types of trans call different UpdateRecBal funcs with different params
            Case TInvoice(MainInv).Invoice.InvDocHed of
              NMT  : begin //NOMs
                       With LastId  do
                         MiscU.UpdateRecBal(LInv,NomCode,(NetValue*DocNotCnst),0.0, CXRate,Currency,UseORate,4);

                       With LId do
                         MiscU.UpdateRecBal(LInv,NomCode,NetValue,0.0,CXRate,Currency,UseORate,4);

                     end;
              PPY,
              SRC  : begin
                       PaymentLineUpdateBalance;
                     end;
              TSH  : begin
                       UpdateRecBal(LastId,LInv,BOn,BOff,17);
                       UpdateRecBal(LId,LInv,BOff,BOn,17);
                     end;
              ADJ,
              WOR  : ; //do nothing
              else
              begin
              //PR 25/07/06: add handling for direct transactions
                if DirectPaymentLine then
                  PaymentLineUpdateBalance
                else
                begin
                  UpdateRecBal(LastId,LInv,BOn,BOff,0);
                  UpdateRecBal(LId,LInv,BOff,BOn,0);
                end;
              end;
            end; //Case

            //PR 25/10/02 Extra stuff for WOR line
            if TInvoice(MainInv).Invoice.InvDocHed in [WOR] then
            begin
              If (LId.LineNo<>1) then
{              with LID do
              Begin
                If (WORReqQty(LastId)<>WORReqQty(LId)) and (QtyWOff=0.0) and (SSDUplift=0.0) then
                  ProRataBOMQty(LId,LastRecAddr[Fnum]);
              end
              else}
              Begin
                {$IFDEF STK}
                  UpdateWORCost(LInv,LastId,1);

                  UpdateWORCost(LInv,LId,0);
                {$ENDIF}
              end;
            end;



            {$IFDEF PF_On}
            //PR 25/10/02 Updating JobAct depends upon trans type
            Case TInvoice(MainInv).Invoice.InvDocHed of
              NMT  : If (JbCostOn) and ((DetLTotal(LId,BOn,BOff,0.0)<>0) or (DetLTotal(LastId,BOn,BOff,0.0)<>0) or
                        (LId.IdDocHed In StkADJSplit))and (Not (LId.IdDocHed In PurchSet)) then
                           Update_JobAct(LId,LInv);

              ADJ  : If (JbCostOn) and (Not (LId.IdDocHed In PurchSet)) then
                       Update_JobAct(LId,LInv);

              PPY,
              SRC  : PaymentLineUpdateJobAct;

              TSH  : Update_JobAct(LId,LInv);
              WOR  : ; //do nothing
              else
              begin
              //PR 25/07/06: add handling for direct transactions
                if DirectPaymentLine then
                  PaymentLineUpdateJobAct
                else
                If (JbCostOn) and ((InvLLTotal(LId,BOn,0)<>0) or (InvLLTotal(LastId,BOn,0)<>0)) and (LId.KitLink=0) then
                  Update_JobAct(LId,LInv);

              end;
            end; //Case

              {.$IFNDEF JC}

                {* Check Over budget *}


                {$B-}
                With LId Do Begin
                  Dnum:=DetLTotal(LId,BOn,BOff,0.0)*LineCnst(Payment);

                  If (JBCostOn) and ((LastId.AnalCode<>AnalCode) or (LastId.StockCode<>StockCode))
                    and (Not EmptyKey(JobCode,JobCodeLen))

                    {EL: v5.5. Extend check for over budget to include uplift}
                       and (Not Get_BudgMUp(JobCode,AnalCode,StockCode,0,Dnum,Dnum2, 2+Ord(IdDocHed In PSOPSet))) then


                    Warn_AnalOverB(JobCode,AnalCode);
                end; {With..}
                {$B+}

              {.$ENDIF}

              {$IFDEF SOP}
              //PR 25/07/06: add handling for direct transactions
                If not (TInvoice(MainInv).Invoice.InvDocHed In [ADJ, NMT, PPY, SRC, TSH, WOR] + DirectSet) or
                        DirectInvoiceLine then
                begin
                  TInvoice(MainInv).Update_LiveCommit(LastId,-1);

                  TInvoice(MainInv).Update_LiveCommit(DataRec,1);
                end;

              {$ENDIF}

            {$ENDIF}

            { Restore Position }
            LStatus:=LPresrv_BTPos(FNum, KeyPath, LocalF^[Fnum],LastRecAddr[Fnum],BOn,BOff);

            { Update Invoice object with any changes }
            TInvoice(MainInv).Invoice := LInv;
          End; { If }
        End; { With }
      End; { If }
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, Trim(InvLineErrStr));
End;


{ loads the stock object with the stock for this line }
Function TInvLine.LinkToStock : Boolean;
Begin
  Result := False;

  {$IFDEF STK}
  If (RecAccess <> NotAvailable) And (FuncAccess[3] = pfEnabled) Then
    With EntSys Do
      Result := TStock(Stock).LinkToStock(tlStockCode);
  {$ENDIF}
End;


{ Deletes the current lines from the database restoring Stock levels, etc }
Procedure TInvLine.Delete;
Var
  KeyS    : Str255;

  {$IFDEF STK}
  { Function to Check for Line to be OS of parent }
  Function DelSOP_Link(IdR : IDetail) : Boolean;
  Const
    FNum              = IDetailF;
    KeyPath : Integer = IdLinkK;
  Var
    TmpStat, TmpKPath : Integer;
    TmpRecAddr        : LongInt;
    KeyS              : Str255;
  Begin
    Result:=True;

    If (IdR.SOPLink <> 0) Then
      With EntSys.LocalBtr^, IdR Do Begin
        { Save file position }
        LastId := LId;
        TmpKPath:=GetPosKey;
        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

        { See if record exists }
        KeyS := FullIdKey(SOPLink,SOPLineNo);
        LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

        Result:=(LStatus <> 0);
        If (Not Result) then
          Result:=(Round(LId.QtyDel+LId.QtyWOff)=0);

        { Restore file position }
        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);
        LId := LastId;
      End; { With }
  End;
  {$ENDIF}

  Function Ok2Del :  Boolean;
  Begin
    With EntSys, LocalBtr^, DataRec Do Begin
      //PR 24/3/03 Adjs have posted run of -30 before and after posting
      Result:= ((PostedRun = 0) or (IdDocHed = ADJ)) and (LineNo > 0);

      {$IFDEF STK}
        If Result Then
          Result := (Round(QtyDel + QtyWOff) = 0) and ((LineType = StkLineType[IdDocHed]) Or (IDDocHed in [NMT, TSH, PPY, SRC]));

        If Result Then
          Result:= DelSOP_Link(DataRec);
      {$ENDIF}
    End; { With }
  End;

Begin
// HM 05/03/02: Prevent use of Delete Line for ADJ, NOM, TSH until code is
// (500CHK)     reviewed for accuracy
{If (TInvoice(MainInv).Invoice.InvDocHed In [ADJ, NMT, PPY, SRC, TSH, WOR]) Then
  Raise Exception.Create ('Delete Method not available for this transaction type');}


  If (RecAccess <> NotAvailable) And (FuncAccess[1] = pfEnabled) and
    not TInvoice(MainInv).RestrictedEdit Then
    With EntSys.LocalBtr^ Do
      { Check the line can be deleted }
      If Ok2Del Then Begin
        { Load Detail Line }
        LastRecAddr[IDetailF] := RecAddr;
        LStatus := LGetDirectRec(IDetailF, IDFolioK);

        { Do paranoid check to see if we have the correct record }
        If (LId.FolioRef <> DataRec.FolioRef) Or (LId.ABSLineNo <> DataRec.ABSLineNo) Then
          LStatus := 4;

        If LStatusOk Then Begin
          { Load invoice for detail line }
          LInv := TInvoice(MainInv).Invoice;
          //PR 31/10/02 Set flag to let Enterprise know that lines have changed
          //PR 25/07/06
//          if LInv.InvDocHed In [ADJ, NMT, PPY, SRC, TSH, WOR] then
            EntSys.ResetDocTotals := True;
          With LId Do Begin
              //PR 25/10/02 - no stock for noms or payments
              //PR 25/07/06: add handling for direct transactions
              If not (TInvoice(MainInv).Invoice.InvDocHed In [NMT, PPY, SRC] + DirectSet) or
                      DirectInvoiceLine then
              begin
              {$IFDEF STK}
              { Recredit to stock levels }
              //PR - check for WOR before stock adjust
              if not (TInvoice(MainInv).invoice.InvDocHed in [WOR]) then
                Deduct_AdjStk(LId,LInv,BOff)
              else
              begin
                Deduct_WORStk(LId,LInv,BOff);

                UpdateWORCost(LInv,LId,1);

              end;

                {$IFDEF SOP}
                { Get Stock Record }
                KeyS := FullStockCode (DataRec.StockCode);
                LGetMainRec(StockF, KeyS);

                Control_SNos(LId,LInv,LStock,3,Application.MainForm);
                {$ENDIF}
              {$ENDIF}

              {$IFDEF PF_On}
                If (Not EmptyKey(JobCode,JobKeyLen)) then
                  Delete_JobAct(LId);
              {$ENDIF}
              end;
          End; { With }

          { Load it again - just in case - and Terminate with Extreme Prejudice }
          LastRecAddr[IDetailF] := RecAddr;
          LStatus := LGetDirectRec(IDetailF, IDFolioK);
          LStatus := LDelete_Rec(IDetailF, IDFolioK);

          { Remove from record balances }
          Case TInvoice(MainInv).Invoice.InvDocHed of
            NMT : begin
                    With LId do
                      MiscU.UpdateRecBal(LInv,NomCode,(NetValue*DocNotCnst),0.0,CXRate,Currency,UseORate,4);
                  end;

            TSH : begin
                    UpdateRecBal(LId,LInv,BOn,BOff,17);
                  end;

            PPY,
            SRC : begin
                    with LID do
                      MiscU.UpdateRecBal(LInv,NomCode,(NetValue*DocNotCnst),0.0, CXRate,LId.Currency,UseORate,1);
                  end;

            ADJ,
            WOR :  ; //Do nothing

            else
              //PR 25/07/06: add handling for direct transactions
            if DirectPaymentLine then
              with LID do
                MiscU.UpdateRecBal(LInv,NomCode,(NetValue*DocNotCnst),0.0, CXRate,LId.Currency,UseORate,1)
            else
              UpdateRecBal(LId,LInv,BOn,BOn,0);
          end; //Case

          {$IFDEF SOP} {* Remove from live Commitment balance..}
          //PR 25/10/02 Check for type before commit
          //PR 25/07/06: add handling for direct transactions
          If not (TInvoice(MainInv).Invoice.InvDocHed In [ADJ, NMT, PPY, SRC, TSH, WOR]+DirectSet) or
                 DirectInvoiceLine then
            TInvoice(MainInv).Update_LiveCommit(LId,-1);

          {$ENDIF}
        End; { If }

        LReport_BError(IDetailF, LStatus);

        If LStatusOK Then Begin
          { Put changes back into transaction }
          TInvoice(MainInv).Invoice := LInv;
          TInvoice(MainInv).SetRecChanged(True);
          { Tell lines object to delete object }
          TInvoiceLines(TInvoice(MainInv).thlines).DeleteLine(Self);
        End; { If }
      End; { If }
End;

Function TInvLine.GetUserDef1 : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LineUser1
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'UserDef1');
  End; { Else }
End;

Procedure TInvLine.SetUserDef1(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[53] = paReadWrite) Then Begin
    If (DataRec.LineUser1 <> Value) Then Begin
      DataRec.LineUser1 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'UserDef1');
End;

Function TInvLine.GetUserDef2 : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LineUser2
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'UserDef2');
  End; { Else }
End;

Procedure TInvLine.SetUserDef2(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[54] = paReadWrite) Then Begin
    If (DataRec.LineUser2 <> Value) Then Begin
      DataRec.LineUser2 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'UserDef2');
End;

Function TInvLine.GetUserDef3 : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LineUser3
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'UserDef3');
  End; { Else }
End;

Procedure TInvLine.SetUserDef3(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[55] = paReadWrite) Then Begin
    If (DataRec.LineUser3 <> Value) Then Begin
      DataRec.LineUser3 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'UserDef3');
End;

Function  TInvLine.GetUserDef4 : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LineUser4
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'UserDef4');
  End; { Else }
End;

Procedure TInvLine.SetUserDef4(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[56] = paReadWrite) Then Begin
    If (DataRec.LineUser4 <> Value) Then Begin
      DataRec.LineUser4 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'UserDef4');
End;

//-------------------------------------------------------------------------

Function TInvLine.GetLineSource : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.AutoLineType
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'LineSource');
  End; { Else }
End;

Procedure TInvLine.SetLineSource(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[57] = paReadWrite) Then Begin
    If (DataRec.AutoLineType <> Value) Then Begin
      DataRec.AutoLineType := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'LineSource');
End;

//-------------------------------------------------------------------------

Function TInvLine.GetCISRateCode : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISRateCode
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'CISRateCode');
  End; { Else }
End;

Procedure TInvLine.SetCISRateCode(Value : Char);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[58] = paReadWrite) Then Begin
    If (DataRec.CISRateCode <> Value) Then Begin
      DataRec.CISRateCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'CISRateCode');
End;

//-------------------------------------------------------------------------

Function TInvLine.GetCISRate : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISRate
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'CISRate');
  End; { Else }
End;

Procedure TInvLine.SetCISRate(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[59] = paReadWrite) Then Begin
    If (DataRec.CISRate <> Value) Then Begin
      DataRec.CISRate := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'CISRate');
End;

//-------------------------------------------------------------------------

Function TInvLine.GetCostApport : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CostApport
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'CostApport');
  End; { Else }
End;

Procedure TInvLine.SetCostApport(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[60] = paReadWrite) Then Begin
    If (DataRec.CostApport <> Value) Then Begin
      DataRec.CostApport := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'CostApport');
End;

//-------------------------------------------------------------------------

Function TInvLine.GetVATInclValue : Double;
Begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.IncNetValue
  Else
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'VATInclValue');
End;

Procedure TInvLine.SetVATInclValue(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[61] = paReadWrite) Then Begin
    If (DataRec.IncNetValue <> Value) Then Begin
      DataRec.IncNetValue := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'VATInclValue');
End;

//-------------------------------------------------------------------------

Function TInvLine.GetNOMVATType : cuNOMLineVatType;
Begin
  Result := nlvNA;
  If (RecAccess <> NotAvailable) Then
    Case DataRec.NOMIOFlg Of
      0 : Result := nlvNA;
      1 : Result := nlvAuto;
      2 : Result := nlvManual;
    Else
      Raise Exception.Create ('TInvLine.GetNOMVATType: Unhandled value ' + IntToStr(DataRec.NOMIOFlg));
    End { Case }

  Else
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'NOMVATType');
End;

Procedure TInvLine.SetNOMVATType(Value : cuNOMLineVatType);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[62] = paReadWrite) Then Begin
    Case Value Of
      nlvNA     : DataRec.NOMIOFlg := 0;
      nlvAuto   : DataRec.NOMIOFlg := 1;
      nlvManual : DataRec.NOMIOFlg := 2;
    Else
      Raise Exception.Create ('TInvLine.GetNOMVATType: Unhandled value ' + IntToStr(DataRec.NOMIOFlg));
    End; { Case }
    RecChanged := True;
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'NOMVATType');
End;

//-------------------------------------------------------------------------

Function TInvLine.GetCISAdjustments : Double;
Begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISAdjust
  Else
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'CISAdjustments');
End;

Procedure TInvLine.SetCISAdjustments(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[63] = paReadWrite) Then Begin
    If (DataRec.CISAdjust <> Value) Then Begin
      DataRec.CISAdjust := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'CISAdjustments');
End;

//-------------------------------------------------------------------------

Function TInvLine.GetAppsDeductType : Byte;
Begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JAPDedType
  Else
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'AppsDeductType');
End;

Procedure TInvLine.SetAppsDeductType(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[64] = paReadWrite) Then Begin
    If (DataRec.JAPDedType <> Value) Then Begin
      DataRec.JAPDedType := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'AppsDeductType');
End;

//------------------------------

Function TInvLine.GetSerialReturnQty : Double;
Begin // GetSerialReturnQty
  Result := 0;
  {$IFDEF RET}
  If RetMOn then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.SerialRetQty
    Else
      EntSys.DataAccessErrDlg(True, InvLineErrStr + 'tlSerialReturnQty');
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('tlSerialReturnQty');
End; // GetSerialReturnQty
Procedure TInvLine.SetSerialReturnQty (Value : Double);
Begin // SetSerialReturnQty
  {$IFDEF RET}
  If RetMOn Then
  Begin
    EntSys.NotImplException ('TAbsInvLine5.tlSerialReturnQty');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('tlSerialReturnQty');
End; // SetSerialReturnQty

//------------------------------

Function TInvLine.GetBinReturnQty : Double;
Begin // GetBinReturnQty
  Result := 0;
   {$IFDEF RET}
  If RetMOn then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.BinRetQty
    Else
      EntSys.DataAccessErrDlg(True, InvLineErrStr + 'tlBinReturnQty');
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('tlBinReturnQty');
End; // GetBinReturnQty
Procedure TInvLine.SetBinReturnQty (Value : Double);
Begin // SetBinReturnQty
 {$IFDEF RET}
  If RetMOn Then
  Begin
    EntSys.NotImplException ('TAbsInvLine5.tlBinReturnQty');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('tlBinReturnQty');
End; // SetBinReturnQty

//------------------------------

Function TInvLine.GetMultiBuyDiscount : Double;
Begin // GetMultiBuyDiscount
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Discount2
  Else
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'tlMultiBuyDiscount');
End; // GetMultiBuyDiscount

Procedure TInvLine.SetMultiBuyDiscount (Value : Double);
Begin // SetMultiBuyDiscount
  {$IFDEF SOP}
    If (RecAccess <> NotAvailable) Then
    Begin
      If (PropAccess[67] = paReadWrite) Then
      Begin
        If (DataRec.Discount2 <> Value) Then
        Begin
          DataRec.Discount2 := Value;
          RecChanged := True;
        End; { If }
      End; // If (PropAccess[67] = paReadWrite)
    End // If (RecAccess <> NotAvailable)
    Else
      EntSys.DataAccessErrDlg(False, InvLineErrStr + 'tlMultiBuyDiscount');
  {$ENDIF}
End; // SetMultiBuyDiscount

//------------------------------

Function TInvLine.GetMultiBuyDiscountFlag : Char;
Begin // GetMultiBuyDiscountFlag
  Result := #0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Discount2Chr
  Else
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'tlMultiBuyDiscountFlag');
End; // GetMultiBuyDiscountFlag

Procedure TInvLine.SetMultiBuyDiscountFlag (Value : Char);
Begin // SetMultiBuyDiscountFlag
  {$IFDEF SOP}
    If (RecAccess <> NotAvailable) Then
    Begin
      If (PropAccess[68] = paReadWrite) Then
      Begin
        If (Value In [#0, #32, PcntChr]) Then
        Begin
          If (DataRec.Discount2Chr <> Value) Then
          Begin
            DataRec.Discount2Chr := Value;
            RecChanged := True;
          End; { If }
        End // If (Value In [#0, #32, PcntChr])
        Else
          Entsys.CustomException (InvLineErrStr + 'tlMultiBuyDiscountFlag');
      End; // If (PropAccess[68] = paReadWrite)
    End { If }
    Else
      EntSys.DataAccessErrDlg(False, InvLineErrStr + 'tlMultiBuyDiscountFlag');
  {$ENDIF}
End; // SetMultiBuyDiscountFlag

//------------------------------

Function TInvLine.GetTransValueDiscount : Double;
Begin // GetTransValueDiscount
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Discount3
  Else
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'tlTransValueDiscount');
End; // GetTransValueDiscount

Procedure TInvLine.SetTransValueDiscount (Value : Double);
Begin // SetTransValueDiscount
  {$IFDEF SOP}
    If (RecAccess <> NotAvailable) Then
    Begin
      If (PropAccess[69] = paReadWrite) Then
      Begin
        If (DataRec.Discount3 <> Value) Then
        Begin
          DataRec.Discount3 := Value;
          RecChanged := True;
        End; { If }
      End; // If (PropAccess[69] = paReadWrite)
    End { If }
    Else
      EntSys.DataAccessErrDlg(False, InvLineErrStr + 'tlTransValueDiscount');
  {$ENDIF}
End; // SetTransValueDiscount

//------------------------------

Function TInvLine.GetTransValueDiscountFlag : Char;
Begin // GetTransValueDiscountFlag
  Result := #0;
   If (RecAccess <> NotAvailable) Then
    Result := DataRec.Discount3Chr
  Else
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'tlTransValueDiscountFlag');
End; // GetTransValueDiscountFlag

Procedure TInvLine.SetTransValueDiscountFlag (Value : Char);
Begin // SetTransValueDiscountFlag
  {$IFDEF SOP}
    If (RecAccess <> NotAvailable) Then
    Begin
      If (PropAccess[70] = paReadWrite) Then
      Begin
        If (Value In [#0, #32, PcntChr]) Then
        Begin
          If (DataRec.Discount3Chr <> Value) Then
          Begin
            DataRec.Discount3Chr := Value;
            RecChanged := True;
          End; { If }
        End // If (Value In [#0, #32, PcntChr])
        Else
          Entsys.CustomException (InvLineErrStr + 'tlTransValueDiscountFlag');
      End; // If (PropAccess[70] = paReadWrite)
    End { If }
    Else
      EntSys.DataAccessErrDlg(False, InvLineErrStr + 'tlTransValueDiscountFlag');
  {$ENDIF}
End; // SetTransValueDiscountFlag

//------------------------------

Function TInvLine.GetTransValueDiscountType : Byte;
Begin // GetTransValueDiscountType
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Discount3Type
  Else
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'tlTransValueDiscountType');
End; // GetTransValueDiscountType

Procedure TInvLine.SetTransValueDiscountType (Value : Byte);
Begin // SetTransValueDiscountType
  {$IFDEF SOP}
    If (RecAccess <> NotAvailable) Then
    Begin
      If (PropAccess[71] = paReadWrite) Then
      Begin
        If (Value In [0, 1, 2, 255]) Then
        Begin
          If (DataRec.Discount3Type <> Value) Then
          Begin
            DataRec.Discount3Type := Value;
            RecChanged := True;
          End; { If }
        End // If (Value In [#0, #32, PcntChr])
        Else
          Entsys.CustomException (InvLineErrStr + 'tlTransValueDiscountType');
      End; // If (PropAccess[71] = paReadWrite)
    End { If }
    Else
      EntSys.DataAccessErrDlg(False, InvLineErrStr + 'tlTransValueDiscountType');
  {$ENDIF}
End; // SetTransValueDiscountType

//------------------------------

Function TInvLine.GetECService : Boolean;
Begin // GetECService
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ECService
  Else
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'tlECService');
End; // GetECService

Procedure TInvLine.SetECService (Value : Boolean);
Begin // SetECService
  If (RecAccess <> NotAvailable) And (PropAccess[72] = paReadWrite) Then
  Begin
    If (DataRec.ECService <> Value) Then
    Begin
      DataRec.ECService := Value;
      RecChanged := True;

      If (Not DataRec.ECService) Then
      Begin
        DataRec.ServiceStartDate := '';
        DataRec.ServiceEndDate := '';
      End; // If (Not DataRec.ECService)
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'ECService');
End; // SetECService

//------------------------------

Function TInvLine.GetServiceStartDate : cuLongDate;
Begin // GetServiceStartDate
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ServiceStartDate
  Else
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'tlServiceStartDate');
End; // GetServiceStartDate

Procedure TInvLine.SetServiceStartDate (Value : cuLongDate);
Begin // SetECService
  If (RecAccess <> NotAvailable) And (PropAccess[73] = paReadWrite) Then
  Begin
    If (DataRec.ServiceStartDate <> Value) Then
    Begin
      // Check that the service is enabled
      If DataRec.ECService Then
      Begin
        DataRec.ServiceStartDate := Value;
        RecChanged := True;
      End // If DataRec.ECService
      Else
        Entsys.CustomException (InvLineErrStr + 'tlServiceStartDate');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'ServiceStartDate');
End; // SetECService

//------------------------------

Function TInvLine.GetServiceEndDate : cuLongDate;
Begin // GetServiceEndDate
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ServiceEndDate
  Else
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'tlServiceEndDate');
End; // GetServiceEndDate

Procedure TInvLine.SetServiceEndDate (Value : cuLongDate);
Begin // SetECService
  If (RecAccess <> NotAvailable) And (PropAccess[74] = paReadWrite) Then
  Begin
    If (DataRec.ServiceEndDate <> Value) Then
    Begin
      // Check that the service is enabled
      If DataRec.ECService Then
      Begin
        DataRec.ServiceEndDate := Value;
        RecChanged := True;
      End // If DataRec.ECService
      Else
        Entsys.CustomException (InvLineErrStr + 'tlServiceEndDate');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'tlServiceEndDate');
End; // SetECService

//------------------------------

Function TInvLine.GetECSalesTaxReported : Double;
Begin // GetECSalesTaxReported
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ECSalesTaxReported
  Else
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'tlECSalesTaxReported');
End; // GetECSalesTaxReported

Procedure TInvLine.SetECSalesTaxReported (Value : Double);
Begin // SetECService
// MH 20/08/2009: This field should only be modified by Exchequer
//
//  If (RecAccess <> NotAvailable) And (PropAccess[75] = paReadWrite) Then
//  Begin
//    If (DataRec.ECSalesTaxReported <> Value) Then
//    Begin
//      DataRec.ECSalesTaxReported := Value;
//      RecChanged := True;
//    End; { If }
//  End { If }
//  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'ECSalesTaxReported');
End; // SetECService

//------------------------------

Function TInvLine.GetPurchaseServiceTax : Double;
Begin // GetPurchaseServiceTax
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PurchaseServiceTax
  Else
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'tlPurchaseServiceTax');
End; // GetPurchaseServiceTax

Procedure TInvLine.SetPurchaseServiceTax (Value : Double);
Begin // SetECService
// MH 20/08/2009: This field should only be modified by Exchequer
//
//  If (RecAccess <> NotAvailable) And (PropAccess[76] = paReadWrite) Then
//  Begin
//    If (DataRec.PurchaseServiceTax <> Value) Then
//    Begin
//      DataRec.PurchaseServiceTax := Value;
//      RecChanged := True;
//    End; { If }
//  End { If }
//  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'PurchaseServiceTax');
End; // SetECService


//------------------------------

Function TInvLine.GetReference : cuStr20;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tlReference
  Else
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'tlReference');
End;

Procedure TInvLine.SetReference (Value : cuStr20);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[77] = paReadWrite) Then
  Begin
    If (DataRec.tlReference <> Value) Then
    Begin
      DataRec.tlReference := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'tlReference');
End;

//------------------------------

Function TInvLine.GetReceiptNo : cuStr20;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tlReceiptNo
  Else
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'tlReceiptNo');
End;

Procedure TInvLine.SetReceiptNo (Value : cuStr20);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[78] = paReadWrite) Then
  Begin
    If (DataRec.tlReceiptNo <> Value) Then
    Begin
      DataRec.tlReceiptNo := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'tlReceiptNo');
End;

//------------------------------

Function TInvLine.GetFromPostCode : cuStr15;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tlFromPostCode
  Else
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'tlFromPostCode');
End;

Procedure TInvLine.SetFromPostCode (Value : cuStr15);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[79] = paReadWrite) Then
  Begin
    If (DataRec.tlFromPostCode <> Value) Then
    Begin
      DataRec.tlFromPostCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'tlFromPostCode');
End;

//------------------------------

Function TInvLine.GetToPostCode : cuStr15;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tlToPostCode
  Else
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'tlToPostCode');
End;

Procedure TInvLine.SetToPostCode (Value : cuStr15);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[80] = paReadWrite) Then
  Begin
    If (DataRec.tlToPostCode <> Value) Then
    Begin
      DataRec.tlToPostCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'tlToPostCode');
End;

//------------------------------

Function TInvLine.GetUserDef5 : cuStr30;
Begin // GetUserDef5
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LineUser5
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'UserDef5');
  End; // Else
End; // GetUserDef5

Procedure TInvLine.SetUserDef5 (Value : cuStr30);
Begin // SetUserDef5
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef5] = paReadWrite) Then
  Begin
    If (DataRec.LineUser5 <> Value) Then
    Begin
      DataRec.LineUser5 := Value;
      RecChanged := True;
    End; // If (DataRec.LineUser5 <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef5] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'UserDef5');
End; // SetUserDef5

//------------------------------

Function TInvLine.GetUserDef6 : cuStr30;
Begin // GetUserDef6
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LineUser6
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'UserDef6');
  End; // Else
End; // GetUserDef6

Procedure TInvLine.SetUserDef6 (Value : cuStr30);
Begin // SetUserDef6
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef6] = paReadWrite) Then
  Begin
    If (DataRec.LineUser6 <> Value) Then
    Begin
      DataRec.LineUser6 := Value;
      RecChanged := True;
    End; // If (DataRec.LineUser6 <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef6] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'UserDef6');
End; // SetUserDef6

//------------------------------

Function TInvLine.GetUserDef7 : cuStr30;
Begin // GetUserDef7
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LineUser7
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'UserDef7');
  End; // Else
End; // GetUserDef7

Procedure TInvLine.SetUserDef7 (Value : cuStr30);
Begin // SetUserDef7
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef7] = paReadWrite) Then
  Begin
    If (DataRec.LineUser7 <> Value) Then
    Begin
      DataRec.LineUser7 := Value;
      RecChanged := True;
    End; // If (DataRec.LineUser7 <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef7] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'UserDef7');
End; // SetUserDef7

//------------------------------

Function TInvLine.GetUserDef8 : cuStr30;
Begin // GetUserDef8
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LineUser8
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'UserDef8');
  End; // Else
End; // GetUserDef8

Procedure TInvLine.SetUserDef8 (Value : cuStr30);
Begin // SetUserDef8
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef8] = paReadWrite) Then
  Begin
    If (DataRec.LineUser8 <> Value) Then
    Begin
      DataRec.LineUser8 := Value;
      RecChanged := True;
    End; // If (DataRec.LineUser8 <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef8] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'UserDef8');
End; // SetUserDef8

//------------------------------

Function TInvLine.GetUserDef9 : cuStr30;
Begin // GetUserDef9
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LineUser9
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'UserDef9');
  End; // Else
End; // GetUserDef9

Procedure TInvLine.SetUserDef9 (Value : cuStr30);
Begin // SetUserDef9
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef9] = paReadWrite) Then
  Begin
    If (DataRec.LineUser9 <> Value) Then
    Begin
      DataRec.LineUser9 := Value;
      RecChanged := True;
    End; // If (DataRec.LineUser9 <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef9] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'UserDef9');
End; // SetUserDef9

//------------------------------

Function TInvLine.GetUserDef10 : cuStr30;
Begin // GetUserDef10
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LineUser10
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'UserDef10');
  End; // Else
End; // GetUserDef10

Procedure TInvLine.SetUserDef10 (Value : cuStr30);
Begin // SetUserDef10
  If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef10] = paReadWrite) Then
  Begin
    If (DataRec.LineUser10 <> Value) Then
    Begin
      DataRec.LineUser10 := Value;
      RecChanged := True;
    End; // If (DataRec.LineUser10 <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[idxUserDef10] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'UserDef10');
End; // SetUserDef10

//-------------------------------------------------------------------------

// MH 20/01/2016 Exch2016-R1: Intrastat enhancements - TAbsInvLine10
Function TInvLine.GetIntrastatOverride : Boolean;
Begin // GetIntrastatOverride
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SSDUseLine
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'IntrastatOverride');
  End; // Else
End; // GetIntrastatOverride
Procedure TInvLine.SetIntrastatOverride (Value : Boolean);
Begin // SetIntrastatOverride
//  If (RecAccess <> NotAvailable) And (PropAccess[idxIntrastatOverride] = paReadWrite) Then
//  Begin
//    If (DataRec.SSDUseLine <> Value) Then
//    Begin
//      DataRec.SSDUseLine := Value;
//      RecChanged := True;
//    End; // If (DataRec.SSDUseLine <> Value)
//  End // If (RecAccess <> NotAvailable) And (PropAccess[idxIntrastatOverride] = paReadWrite)
//  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'IntrastatOverride');
End; // SetIntrastatOverride

//------------------------------

Function TInvLine.GetIntrastatCommodityCode : cuStr10;
Begin // GetIntrastatCommodityCode
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SSDCommod
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'IntrastatCommodityCode');
  End; // Else
End; // GetIntrastatCommodityCode
Procedure TInvLine.SetIntrastatCommodityCode (Value : cuStr10);
Begin // SetIntrastatCommodityCode
//
// TODO: Need to check whether the intrastat setttings are overridden on the line
//
//  If (RecAccess <> NotAvailable) And (PropAccess[idxIntrastatCommodityCode] = paReadWrite) Then
//  Begin
//    If (DataRec.SSDCommod <> Value) Then
//    Begin
//      DataRec.SSDCommod := Value;
//      RecChanged := True;
//    End; // If (DataRec.SSDCommod <> Value)
//  End // If (RecAccess <> NotAvailable) And (PropAccess[idxIntrastatCommodityCode] = paReadWrite)
//  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'IntrastatCommodityCode');
End; // SetIntrastatCommodityCode

//------------------------------

Function TInvLine.GetIntrastatStockUnits : Double;
Begin // GetIntrastatStockUnits
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SSDSPUnit
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'IntrastatStockUnits');
  End; // Else
End; // GetIntrastatStockUnits
Procedure TInvLine.SetIntrastatStockUnits (Value : Double);
Begin // SetIntrastatStockUnits
//
// TODO: Need to check whether the intrastat setttings are overridden on the line
//
//  If (RecAccess <> NotAvailable) And (PropAccess[idxIntrastatStockUnits] = paReadWrite) Then
//  Begin
//    If (DataRec.SSDSPUnit <> Value) Then
//    Begin
//      DataRec.SSDSPUnit := Value;
//      RecChanged := True;
//    End; // If (DataRec.SSDSPUnit <> Value)
//  End // If (RecAccess <> NotAvailable) And (PropAccess[idxIntrastatStockUnits] = paReadWrite)
//  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'IntrastatStockUnits');
End; // SetIntrastatStockUnits

//------------------------------

Function TInvLine.GetIntrastatCountry : cuStr2;
Begin // GetIntrastatCountry
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SSDCountry
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'IntrastatCountry');
  End; // Else
End; // GetIntrastatCountry
Procedure TInvLine.SetIntrastatCountry (Value : cuStr2);
Begin // SetIntrastatCountry
//
// TODO: Need to check whether the intrastat setttings are overridden on the line
//
//  If (RecAccess <> NotAvailable) And (PropAccess[idxIntrastatCountry] = paReadWrite) Then
//  Begin
//    If (DataRec.SSDCountry <> Value) Then
//    Begin
//      DataRec.SSDCountry := Value;
//      RecChanged := True;
//    End; // If (DataRec.SSDCountry <> Value)
//  End // If (RecAccess <> NotAvailable) And (PropAccess[idxIntrastatCountry] = paReadWrite)
//  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'IntrastatCountry');
End; // SetIntrastatCountry

//------------------------------

Function TInvLine.GetIntrastatNoTC : cuStr2;
Begin // GetIntrastatNoTC
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tlIntrastatNoTC
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'IntrastatNoTC');
  End; // Else
End; // GetIntrastatNoTC
Procedure TInvLine.SetIntrastatNoTC (Value : cuStr2);
Begin // SetIntrastatNoTC
//
// TODO: Need to check whether the intrastat setttings are overridden on the line
//
//  If (RecAccess <> NotAvailable) And (PropAccess[idxIntrastatNoTC] = paReadWrite) Then
//  Begin
//    If (DataRec.tlIntrastatNoTC <> Value) Then
//    Begin
//      DataRec.tlIntrastatNoTC := Value;
//      RecChanged := True;
//    End; // If (DataRec.tlIntrastatNoTC <> Value)
//  End // If (RecAccess <> NotAvailable) And (PropAccess[IdxIntrastatNoTC] = paReadWrite)
//  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'IntrastatNoTC');
End; // SetIntrastatNoTC

//------------------------------

Function TInvLine.GetIntrastatUplift : Double;
Begin // GetIntrastatUplift
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SSDUplift
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, InvLineErrStr + 'IntrastatUplift');
  End; // Else
End; // GetIntrastatUplift
Procedure TInvLine.SetIntrastatUplift (Value : Double);
Begin // SetIntrastatUplift
//
// TODO: Need to check whether the intrastat setttings are overridden on the line
//
// TODO: Ireland only allegedly
//
//  If (RecAccess <> NotAvailable) And (PropAccess[idxtrastatUplift] = paReadWrite) Then
//  Begin
//    If (DataRec.SSDUplift <> Value) Then
//    Begin
//      DataRec.SSDUplift := Value;
//      RecChanged := True;
//    End; // If (DataRec.SSDUplift <> Value)
//  End // If (RecAccess <> NotAvailable) And (PropAccess[idxtrastatUplift] = paReadWrite)
//  Else
    EntSys.DataAccessErrDlg(False, InvLineErrStr + 'IntrastatUplift');
End; // SetIntrastatUplift

//=========================================================================

End.

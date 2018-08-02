unit oStock;

{$I DEFOVR.INC}

interface

Uses Classes, Dialogs, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     oIDetail, ExWrap1U, CustTypU;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TStock = Class(TAbsStock5)
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..113] Of TPropertyAccess;
    FuncAccess : Array [1..1] Of TFunctionAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    DataRec, OrigRec    : ^StockRec;

    Function  GetNomCode(Const Idx : Byte; Const ErrStr : ShortString) : LongInt;
    Procedure SetNomCode(Const Idx, SecIdx : Byte;
                         Const Value       : LongInt;
                         Const ErrStr      : ShortString);
    Function  GetCCDep (Const CCFlag : Boolean;Const ErrStr : ShortString) : cuStr3;
    Procedure SetCCDep(Const SecIdx : Byte;Const CCFlag : Boolean;Const ErrStr : ShortString;Const Value : cuStr3);
    Function  GetROCCDep (Const CCFlag : Boolean;Const ErrStr : ShortString) : cuStr3;
    Procedure SetROCCDep(Const SecIdx : Byte;Const CCFlag : Boolean;Const ErrStr : ShortString;Const Value : cuStr3);
  Protected
    { Abstract Property Access methods from TAbsCustomer }
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function  GetStockCode : cuStr16; Override;
    Procedure SetStockCode(Value : cuStr16); Override;
    Function  GetDesc (Index : cuDescIndex) : cuStr35; Override;
    Procedure SetDesc(Index : cuDescIndex; Value : cuStr35); Override;
    Function  GetAltCode : cuStr20; Override;
    Procedure SetAltCode(Value : cuStr20); Override;
    Function  GetSuppTemp : cuStr6; Override;
    Procedure SetSuppTemp(Value : cuStr6); Override;
    Function  GetNomCodeS1 : LongInt; Override;
    Procedure SetNomCodeS1(Value : LongInt); Override;
    Function  GetNomCodeS2 : LongInt; Override;
    Procedure SetNomCodeS2(Value : LongInt); Override;
    Function  GetNomCodeS3 : LongInt; Override;
    Procedure SetNomCodeS3(Value : LongInt); Override;
    Function  GetNomCodeS4 : LongInt; Override;
    Procedure SetNomCodeS4(Value : LongInt); Override;
    Function  GetNomCodeS5 : LongInt; Override;
    Procedure SetNomCodeS5(Value : LongInt); Override;
    Function  GetROFlg : Boolean; Override;
    Procedure SetROFlg(Value : Boolean); Override;
    Function  GetMinFlg : Boolean; Override;
    Procedure SetMinFlg(Value : Boolean); Override;
    Function  GetStockFolio : LongInt; Override;
    Procedure SetStockFolio(Value : LongInt); Override;
    Function  GetStockCat : cuStr16; Override;
    Procedure SetStockCat(Value : cuStr16); Override;
    Function  GetStockType : Char; Override;
    Procedure SetStockType(Value : Char); Override;
    Function  GetUnitK : cuStr10; Override;
    Procedure SetUnitK(Value : cuStr10); Override;
    Function  GetUnitS : cuStr10; Override;
    Procedure SetUnitS(Value : cuStr10); Override;
    Function  GetUnitP : cuStr10; Override;
    Procedure SetUnitP(Value : cuStr10); Override;
    Function  GetPCurrency : cuCurrencyType; Override;
    Procedure SetPCurrency(Value : cuCurrencyType); Override;
    Function  GetCostPrice : Real; Override;
    Procedure SetCostPrice(Value : Real); Override;
    Function  GetSaleBandsCcy (Index : cuSalesBandIndex) : cuCurrencyType; Override;
    Procedure SetSaleBandsCcy(Index : cuSalesBandIndex; Value : cuCurrencyType); Override;
    Function  GetSaleBandsPrice (Index : cuSalesBandIndex) : Real; Override;
    Procedure SetSaleBandsPrice(Index : cuSalesBandIndex; Value : Real); Override;
    Function  GetSellUnit : Real; Override;
    Procedure SetSellUnit(Value : Real); Override;
    Function  GetBuyUnit : Real; Override;
    Procedure SetBuyUnit(Value : Real); Override;
    Function  GetVATCode : Char; Override;
    Procedure SetVATCode(Value : Char); Override;
    Function  GetCCDep1 : cuStr3; Override;
    Procedure SetCCDep1(Value : cuStr3); Override;
    Function  GetCCDep2 : cuStr3; Override;
    Procedure SetCCDep2(Value : cuStr3); Override;
    Function  GetQtyInStock : Real; Override;
    Procedure SetQtyInStock(Value : Real); Override;
    Function  GetQtyPosted : Real; Override;
    Procedure SetQtyPosted(Value : Real); Override;
    Function  GetQtyAllocated : Real; Override;
    Procedure SetQtyAllocated(Value : Real); Override;
    Function  GetQtyOnOrder : Real; Override;
    Procedure SetQtyOnOrder(Value : Real); Override;
    Function  GetQtyMin : Real; Override;
    Procedure SetQtyMin(Value : Real); Override;
    Function  GetQtyMax : Real; Override;
    Procedure SetQtyMax(Value : Real); Override;
    Function  GetROQty : Real; Override;
    Procedure SetROQty(Value : Real); Override;
    Function  GetShowasKit : Boolean; Override;
    Procedure SetShowasKit(Value : Boolean); Override;
    Function  GetCommodCode : cuStr10; Override;
    Procedure SetCommodCode(Value : cuStr10); Override;
    Function  GetSWeight : Real; Override;
    Procedure SetSWeight(Value : Real); Override;
    Function  GetPWeight : Real; Override;
    Procedure SetPWeight(Value : Real); Override;
    Function  GetUnitSupp : cuStr10; Override;
    Procedure SetUnitSupp(Value : cuStr10); Override;
    Function  GetSuppSUnit : Real; Override;
    Procedure SetSuppSUnit(Value : Real); Override;
    Function  GetBinLoc : cuStr10; Override;
    Procedure SetBinLoc(Value : cuStr10); Override;
    Function  GetStkFlg : Boolean; Override;
    Procedure SetStkFlg(Value : Boolean); Override;
    Function  GetCovPr : SmallInt; Override;
    Procedure SetCovPr(Value : SmallInt); Override;
    Function  GetCovPrUnit : Char; Override;
    Procedure SetCovPrUnit(Value : Char); Override;
    Function  GetCovMinPr : SmallInt; Override;
    Procedure SetCovMinPr(Value : SmallInt); Override;
    Function  GetCovMinUnit : Char; Override;
    Procedure SetCovMinUnit(Value : Char); Override;
    Function  GetSupplier : cuStr6; Override;
    Procedure SetSupplier(Value : cuStr6); Override;
    Function  GetQtyFreeze : Double; Override;
    Procedure SetQtyFreeze(Value : Double); Override;
    Function  GetCovSold : Double; Override;
    Procedure SetCovSold(Value : Double); Override;
    Function  GetUseCover : Boolean; Override;
    Procedure SetUseCover(Value : Boolean); Override;
    Function  GetCovMaxPr : SmallInt; Override;
    Procedure SetCovMaxPr(Value : SmallInt); Override;
    Function  GetCovMaxUnit : Char; Override;
    Procedure SetCovMaxUnit(Value : Char); Override;
    Function  GetROCurrency : cuCurrencyType; Override;
    Procedure SetROCurrency(Value : cuCurrencyType); Override;
    Function  GetROCPrice : Double; Override;
    Procedure SetROCPrice(Value : Double); Override;
    Function  GetRODate : cuLongDate; Override;
    Procedure SetRODate(Value : cuLongDate); Override;
    Function  GetQtyTake : Double; Override;
    Procedure SetQtyTake(Value : Double); Override;
    Function  GetStkValType : Char; Override;
    Procedure SetStkValType(Value : Char); Override;
    Function  GetQtyPicked : Double; Override;
    Procedure SetQtyPicked(Value : Double); Override;
    Function  GetLastUsed : cuLongDate; Override;
    Procedure SetLastUsed(Value : cuLongDate); Override;
    Function  GetCalcPack : Boolean; Override;
    Procedure SetCalcPack(Value : Boolean); Override;
    Function  GetJAnalCode : cuStr10; Override;
    Procedure SetJAnalCode(Value : cuStr10); Override;
    Function  GetStkUser1 : cuStr20; Override;
    Procedure SetStkUser1(Value : cuStr20); Override;
    Function  GetStkUser2 : cuStr20; Override;
    Procedure SetStkUser2(Value : cuStr20); Override;
    Function  GetBarCode : cuStr20; Override;
    Procedure SetBarCode(Value : cuStr20); Override;
    Function  GetROCCDep1 : cuStr3; Override;
    Procedure SetROCCDep1(Value : cuStr3); Override;
    Function  GetROCCDep2 : cuStr3; Override;
    Procedure SetROCCDep2(Value : cuStr3); Override;
    Function  GetDefMLoc : cuStr3; Override;
    Procedure SetDefMLoc(Value : cuStr3); Override;
    Function  GetPricePack : Boolean; Override;
    Procedure SetPricePack(Value : Boolean); Override;
    Function  GetDPackQty : Boolean; Override;
    Procedure SetDPackQty(Value : Boolean); Override;
    Function  GetKitPrice : Boolean; Override;
    Procedure SetKitPrice(Value : Boolean); Override;
    Function  GetKitOnPurch : Boolean; Override;
    Procedure SetKitOnPurch(Value : Boolean); Override;

    { v4.31 fields }
    Function  GetStkUser3 : cuStr30; Override;
    Procedure SetStkUser3(Value : cuStr30); Override;
    Function  GetStkUser4 : cuStr30; Override;
    Procedure SetStkUser4(Value : cuStr30); Override;
    Function  GetSerNoWAvg : Byte; Override;
    Procedure SetSerNoWAvg(Value : Byte); Override;
    Function  GetStkSizeCol : Byte; Override;
    //Procedure SetStkSizeCol(Value : Byte); Override;
    Function  GetSSDDUplift : Double; Override;
    Procedure SetSSDDUplift(Value : Double); Override;
    Function  GetSSDCountry : cuStr5; Override;
    Procedure SetSSDCountry(Value : cuStr5); Override;
    Function  GetTimeChange : cuStr6; Override;
    Function  GetSVATIncFlg : Char; Override;
    Procedure SetSVATIncFlg(Value : Char); Override;
    Function  GetSSDAUpLift : Double; Override;
    Procedure SetSSDAUpLift(Value : Double); Override;
    Function  GetLastOpo : cuStr10; Override;
    Procedure SetLastOpo(Value : cuStr10); Override;
    Function  GetImageFile : cuStr30; Override;
    Procedure SetImageFile(Value : cuStr30); Override;

    { v5.00 fields }
    function GetQtyAllocWOR: Double; Override;
    procedure SetQtyAllocWOR(const Value: Double); Override;
    function GetQtyIssuedWOR: Double; Override;
    procedure SetQtyIssuedWOR(const Value: Double); Override;
    function GetQtyPickedWOR: Double; Override;
    procedure SetQtyPickedWOR(const Value: Double); Override;
    function GetUseForEbus: Boolean; Override;
    procedure SetUseForEbus(const Value: Boolean); Override;
    function GetWebLiveCatalog: cuStr20; Override;
    procedure SetWebLiveCatalog(const Value: cuStr20); Override;
    function GetWebPrevCatalog: cuStr20; Override;
    procedure SetWebPrevCatalog(const Value: cuStr20); Override;
    function GetWOPAssemblyDays: LongInt; Override;
    procedure SetWOPAssemblyDays(const Value: LongInt); Override;
    function GetWOPAssemblyHours: LongInt; Override;
    procedure SetWOPAssemblyHours(const Value: LongInt); Override;
    function GetWOPAssemblyMins: LongInt; Override;
    procedure SetWOPAssemblyMins(const Value: LongInt); Override;
    function GetWOPAutoCalcTime: Boolean; Override;
    procedure SetWOPAutoCalcTime(const Value: Boolean); Override;
    function GetWOPIssuedWIPGL: LongInt; Override;
    procedure SetWOPIssuedWIPGL(const Value: LongInt); Override;
    function GetWOPMinEconBuild: Double; Override;
    procedure SetWOPMinEconBuild(const Value: Double); Override;
    function GetWOPROLeadTime: LongInt; Override;
    procedure SetWOPROLeadTime(const Value: LongInt); Override;

    // TAbsStock2
    Function GetUsesBins : Boolean;  Override;
    Procedure SetUsesBins (const Value: Boolean); Override;

    // TAbsStock3
    Function GetSalesWarrantyLength : Byte; Override;
    Procedure SetSalesWarrantyLength (Value : Byte); Override;
    Function GetSalesWarrantyUnits : TStockWarrantyUnits; Override;
    Procedure SetSalesWarrantyUnits (Value : TStockWarrantyUnits); Override;
    Function GetManufacturerWarrantyLength : Byte; Override;
    Procedure SetManufacturerWarrantyLength (Value : Byte); Override;
    Function GetManufacturerWarrantyUnits : TStockWarrantyUnits; Override;
    Procedure SetManufacturerWarrantyUnits (Value : TStockWarrantyUnits); Override;
    Function GetSalesReturnGL : LongInt; Override;
    Procedure SetSalesReturnGL (Value : LongInt); Override;
    Function GetPurchaseReturnGL : LongInt; Override;
    Procedure SetPurchaseReturnGL (Value : LongInt); Override;
    Function GetSalesReturnQty : Double; Override;
    Procedure SetSalesReturnQty (Value : Double); Override;
    Function GetPurchaseReturnQty : Double; Override;
    Procedure SetPurchaseReturnQty (Value : Double); Override;
    Function GetRestockCharge : Double; Override;
    Procedure SetRestockCharge (Value : Double); Override;
    Function GetRestockFlag : TStockRestockChargeType; Override;
    Procedure SetRestockFlag (Value : TStockRestockChargeType); Override;

    // v6.9 29/09/2011 ABSEXCH-11709 - TAbsStock4
    Function GetStkUser5 : cuStr30; Override;
    Procedure SetStkUser5 (Value : cuStr30); Override;
    Function GetStkUser6 : cuStr30; Override;
    Procedure SetStkUser6 (Value : cuStr30); Override;
    Function GetStkUser7 : cuStr30; Override;
    Procedure SetStkUser7 (Value : cuStr30); Override;
    Function GetStkUser8 : cuStr30; Override;
    Procedure SetStkUser8 (Value : cuStr30); Override;
    Function GetStkUser9 : cuStr30; Override;
    Procedure SetStkUser9 (Value : cuStr30); Override;
    Function GetStkUser10 : cuStr30; Override;
    Procedure SetStkUser10 (Value : cuStr30); Override;

    // MH 08/09/2014 v7.1 ABSEXCH-15052
    Function GetIsService : Boolean; Override;
    Procedure SetIsService (Value : Boolean); Override;
  Public
    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const Stock            : StockRec);

    Function    LinkToStock (Const TheCode : ShortString) : Boolean;
  End; { TInvoice }


implementation

Uses BtrvU2, CustWinU, EtStrU, BtSupU1, BtKeys1U, Comnu2,

     {$IFDEF STK}
       {$IFDEF WOP}
         WOPCT1U,
       {$ENDIF}
     {$ENDIF}

       VarRec2U;

Const
  StockErrStr = 'Stock ';

  IdxUser5  = 107;
  IdxUser6  = 108;
  IdxUser7  = 109;
  IdxUser8  = 110;
  IdxUser9  = 111;
  IdxUser10 = 112;

  idxIsService = 113;


Constructor TStock.Create (hEntSys : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;

  New (DataRec);
  FillChar (DataRec^, SizeOf (DataRec^), #0);
  New (OrigRec);
  FillChar (OrigRec^, SizeOf (OrigRec^), #0);

  RecAccess  := NotAvailable;
  RecChanged := False;
End;

Destructor TStock.Destroy;
Begin
  Dispose (DataRec);
  Dispose (OrigRec);

  Inherited Destroy;
End;

Procedure TStock.Assign (Const WinId, HandlerId : LongInt;
                         Const Stock            : StockRec);
Const
  ReadOnlySet = [10,12,14,27..30,42,49,59];
Var
  I : SmallInt;
Begin

  Case WinId of
    EnterpriseBase+2000,                { Transaction - Before Save }
    EnterpriseBase+2050,
    EnterpriseBase+3000,                { Stock Record - Stock Code Exit }
    EnterpriseBase+3100,               { Stock Record - Stock Batch Entry }
    EnterpriseBase+4000,                { Line Record Pre Qty Enter Exit }
    EnterpriseBase+5000,                { Job Record }
    EnterpriseBase+MiscBase+1           { VAT Calculation }
         :  RecAccess:=ReadOnly;

    else    RecAccess:=NotAvailable;

  End; { If }

  { Load fields from ExLocal }
  FillChar (DataRec^, SizeOf (DataRec^), #0);
  RecChanged := False;
  If (RecAccess <> NotAvailable) Then Begin
    DataRec^ := Stock;
    
  End; { If }
  OrigRec^ := DataRec^;

  { Adjust Security Access for field by Window and Event }
  If (RecAccess <> NotAvailable) Then Begin
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
                 FuncAccess[1] := pfEnabled; { LinkToStock }



               End;

      102000031, 102000032,   { Edit Sales Transaction - Custom buttons 1 & 2 }
      102000041, 102000042    { Edit Purch Transaction - Custom buttons 1 & 2 }
           :   Begin

                 FuncAccess[1]  := pfEnabled;    { LinkToStock }
               end;

      103000001   { Stock Record/ Stock Code Exit}
           :   Begin
                 PropAccess[1]:=paReadWrite;
               end;

      103000002   { Stock Record/ Exit}
           :   Begin
                 PropAccess[37]:=paReadWrite;   {* Sales Weight field Enabled *}
                 PropAccess[38]:=paReadWrite;   {* Purch Weight field Enabled *}

                 PropAccess[65]:=paReadWrite;   {* Bar Code field Enabled *}

                 PropAccess[63] := paReadWrite; {* UD1 *}
                 PropAccess[64] := paReadWrite; {* UD2 *}
                 PropAccess[72] := paReadWrite; {* UD3 *}
                 PropAccess[73] := paReadWrite; {* UD4 *}
                 //GS 08/11/2011 ABSEXCH-12107: Expanded for the new UDFs
                 PropAccess[idxUser5]:=paReadWrite;  {UD5}
                 PropAccess[idxUser6]:=paReadWrite;  {UD6}
                 PropAccess[idxUser7]:=paReadWrite;  {UD7}
                 PropAccess[idxUser8]:=paReadWrite;  {UD8}
                 PropAccess[idxUser9]:=paReadWrite;  {UD9}
                 PropAccess[idxUser10]:=paReadWrite;  {UD10}

               end;


      103000031   { UD1 Validation}
           :   Begin
                 PropAccess[63]:=paReadWrite;
               end;

      103000032   { UD2 Validation}
           :   Begin
                 PropAccess[64]:=paReadWrite;
               end;

      103000033   { UD3 Validation}
           :   Begin
                 PropAccess[72]:=paReadWrite;
               end;

      103000034   { UD4 Validation}
           :   Begin
                 PropAccess[73]:=paReadWrite;
               end;
     //GS 25/10/2011 ABSEXCH-11706: updated to support 10 UDEFs
     103000211   { UD5 Validation}
           :   Begin
                 PropAccess[IdxUser5]:=paReadWrite;
               end;

      103000212   { UD6 Validation}
           :   Begin
                 PropAccess[IdxUser6]:=paReadWrite;
               end;

      103000213   { UD7 Validation}
           :   Begin
                 PropAccess[IdxUser7]:=paReadWrite;
               end;

      103000214   { UD8 Validation}
           :   Begin
                 PropAccess[IdxUser8]:=paReadWrite;
               end;

      103000215   { UD9 Validation}
           :   Begin
                 PropAccess[IdxUser9]:=paReadWrite;
               end;

      103000216   { UD10 Validation}
           :   Begin
                 PropAccess[IdxUser10]:=paReadWrite;
               end;

      103000051,
      103000052   { Stock Re-order Qty}
           :   Begin
                 PropAccess[33]:=paReadWrite;


                 PropAccess[55]:=paReadWrite; {* Re-order Date *}
               end;



      190001001 {* VAT Calculation *}

           :   ;
    End; { Case }

  End; { If }
End;

Function TStock.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

Function TStock.GetRecChanged : Boolean;
Begin
  Result := RecChanged;
End;

Function TStock.GetStockCode : cuStr16;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StockCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'StockCode');
  End; { Else }
End;

Procedure TStock.SetStockCode(Value : cuStr16);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[1] = paReadWrite) Then Begin
    TmpStr := FullStockCode(Value);
    If (DataRec.StockCode <> TmpStr) Then Begin
      { Check its not blank, and its either the original value or it doesn't exist }
      If (Trim(TmpStr) <> '') And
         ((TmpStr = OrigRec^.StockCode) Or (Not EntSys.CheckForRec(TmpStr,StockF,StkCodeK))) Then Begin
        DataRec.StockCode := TmpStr;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'StockCode');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'StockCode');
End;

Function TStock.GetDesc (Index : cuDescIndex) : cuStr35;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Desc[Index]
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'Desc');
  End; { Else }
End;

Procedure TStock.SetDesc(Index : cuDescIndex; Value : cuStr35);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[2] = paReadWrite) Then Begin
    If (DataRec.Desc[Index] <> Value) Then Begin
      DataRec.Desc[Index] := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'Desc');
End;

Function TStock.GetAltCode : cuStr20;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.AltCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'AltCode');
  End; { Else }
End;

Procedure TStock.SetAltCode(Value : cuStr20);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[3] = paReadWrite) Then Begin
    If (DataRec.AltCode <> Value) Then Begin
      DataRec.AltCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'AltCode');
End;

Function TStock.GetSuppTemp : cuStr6;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SuppTemp
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'SuppTemp');
  End; { Else }
End;

Procedure TStock.SetSuppTemp(Value : cuStr6);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[4] = paReadWrite) Then Begin
    TmpStr := FullCustCode(Value);
    If (DataRec.SuppTemp <> TmpStr) Then Begin
      If (Trim(TmpStr) = '') Or EntSys.CustExists(TmpStr, [TradeCode[False]]) Then Begin
        DataRec.SuppTemp := TmpStr;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'SuppTemp');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'SuppTemp');
End;

Function TStock.GetNomCode(Const Idx : Byte; Const ErrStr : ShortString) : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.NomCodeS[Idx]
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, StockErrStr + ErrStr);
  End; { Else }
End;

Procedure TStock.SetNomCode(Const Idx, SecIdx : Byte;
                            Const Value       : LongInt;
                            Const ErrStr      : ShortString);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[SecIdx] = paReadWrite) Then Begin
    If (DataRec.NomCodeS[Idx] <> Value) Then Begin
      If EntSys.ValidNomCode(Value, 2) Then Begin
        DataRec.NomCodeS[Idx] := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + ErrStr);
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + ErrStr);
End;

Function TStock.GetNomCodeS1 : LongInt;
Begin
  Result := GetNomCode (1, 'SalesGL');
End;

Procedure TStock.SetNomCodeS1(Value : LongInt);
Begin
  SetNomCode (1, 5, Value, 'SalesGL');
End;

Function TStock.GetNomCodeS2 : LongInt;
Begin
  Result := GetNomCode (2, 'COSGL');
End;

Procedure TStock.SetNomCodeS2(Value : LongInt);
Begin
  SetNomCode (2, 6, Value, 'COSGL');
End;

Function TStock.GetNomCodeS3 : LongInt;
Begin
  Result := GetNomCode (3, 'P&LGL');
End;

Procedure TStock.SetNomCodeS3(Value : LongInt);
Begin
  SetNomCode (3, 7, Value, 'P&LGL');
End;

Function TStock.GetNomCodeS4 : LongInt;
Begin
  Result := GetNomCode (4, 'BalSheetGL');
End;

Procedure TStock.SetNomCodeS4(Value : LongInt);
Begin
  SetNomCode (4, 8, Value, 'BalSheetGL');
End;

Function TStock.GetNomCodeS5 : LongInt;
Begin
  Result := GetNomCode (5, 'WIPGL');
End;

Procedure TStock.SetNomCodeS5(Value : LongInt);
Begin
  SetNomCode (5, 9, Value, 'WIPGL');
End;

Function TStock.GetROFlg : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ROFlg
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'ReOrderFlag');
  End; { Else }
End;

Procedure TStock.SetROFlg(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[10] = paReadWrite) Then Begin
    If (DataRec.ROFlg <> Value) Then Begin
      DataRec.ROFlg := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'ReOrderFlag');
End;

Function TStock.GetMinFlg : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.MinFlg
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'MinFlg');
  End; { Else }
End;

Procedure TStock.SetMinFlg(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[11] = paReadWrite) Then Begin
    If (DataRec.MinFlg <> Value) Then Begin
      DataRec.MinFlg := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'MinFlg');
End;

Function TStock.GetStockFolio : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StockFolio
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'StockFolio');
  End; { Else }
End;

Procedure TStock.SetStockFolio(Value : LongInt);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[12] = paReadWrite) Then Begin
    If (DataRec.StockFolio <> Value) Then Begin
      TmpStr := FullNomKey (Value);
      If (Value = OrigRec^.StockFolio) Or (Not EntSys.CheckForRec(TmpStr,StockF,StkFolioK)) Then Begin
        DataRec.StockFolio := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'StockFolio');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'StockFolio');
End;

Function TStock.GetStockCat : cuStr16;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StockCat
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'StockCat');
  End; { Else }
End;

Procedure TStock.SetStockCat(Value : cuStr16);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[13] = paReadWrite) Then Begin
    TmpStr := FullStockCode(Value);
    If (DataRec.StockCat <> TmpStr) Then Begin
      If (TmpStr <> DataRec.StockCode) And ((Trim(TmpStr) = '') Or EntSys.CheckForRec(TmpStr,StockF,StkCodeK)) Then Begin
        DataRec.StockCat := TmpStr;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'StockCat');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'StockCat');
End;

Function TStock.GetStockType : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StockType
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'StockType');
  End; { Else }
End;

Procedure TStock.SetStockType(Value : Char);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[14] = paReadWrite) Then Begin
    If (DataRec.StockType <> Value) Then Begin
      If (Value In StkProdSet+[StkDescCode,StkGrpCode]) Then Begin
        DataRec.StockType := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'StockType');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'StockType');
End;

Function TStock.GetUnitK : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UnitK
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'UnitOfStock');
  End; { Else }
End;

Procedure TStock.SetUnitK(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[15] = paReadWrite) Then Begin
    If (DataRec.UnitK <> Value) Then Begin
      DataRec.UnitK := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'UnitOfStock');
End;

Function TStock.GetUnitS : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UnitS
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'UnitOfSale');
  End; { Else }
End;

Procedure TStock.SetUnitS(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[16] = paReadWrite) Then Begin
    If (DataRec.UnitS <> Value) Then Begin
      DataRec.UnitS := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'UnitOfSale');
End;

Function TStock.GetUnitP : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UnitP
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'UnitOfPurch');
  End; { Else }
End;

Procedure TStock.SetUnitP(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[17] = paReadWrite) Then Begin
    If (DataRec.UnitP <> Value) Then Begin
      DataRec.UnitP := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'UnitOfPurch');
End;

Function TStock.GetPCurrency : cuCurrencyType;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PCurrency
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'CostPriceCur');
  End; { Else }
End;

Procedure TStock.SetPCurrency(Value : cuCurrencyType);
Begin
  {$IFDEF MC_On}
    If (RecAccess <> NotAvailable) And (PropAccess[18] = paReadWrite) Then Begin
      If (DataRec.PCurrency <> Value) Then Begin
        If EntSys.ValidCcy(Value) Then Begin
          DataRec.PCurrency := Value;
          RecChanged := True;
        End { If }
        Else
          EntSys.CustomException (StockErrStr + 'CostPriceCur');
      End; { If }
    End { If }
    Else
      EntSys.DataAccessErrDlg(False, StockErrStr + 'CostPriceCur');
  {$ELSE}
    DataRec.PCurrency := 0;
  {$ENDIF}
End;

Function TStock.GetCostPrice : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CostPrice
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'CostPrice');
  End; { Else }
End;

Procedure TStock.SetCostPrice(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[19] = paReadWrite) Then Begin
    If (DataRec.CostPrice <> Value) Then Begin
      DataRec.CostPrice := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'CostPrice');
End;

Function TStock.GetSaleBandsCcy (Index : cuSalesBandIndex) : cuCurrencyType;
Begin
  {$IFDEF MC_On}
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.SaleBands[Ord(Index) - Ord('A') + 1].Currency
    Else Begin
      Result := 1;
      EntSys.DataAccessErrDlg(True, StockErrStr + 'SaleBandsCur');
    End; { Else }
  {$ELSE}
    Result := 0;
  {$ENDIF}
End;

Procedure TStock.SetSaleBandsCcy(Index : cuSalesBandIndex; Value : cuCurrencyType);
Begin
  {$IFDEF MC_On}
    If (RecAccess <> NotAvailable) And (PropAccess[20] = paReadWrite) Then Begin
      If (DataRec.SaleBands[Ord(Index) - Ord('A') + 1].Currency <> Value) Then Begin
        If EntSys.ValidCcy(Value) Then Begin
          DataRec.SaleBands[Ord(Index) - Ord('A') + 1].Currency := Value;
          RecChanged := True;
        End { If }
        Else
          EntSys.CustomException (StockErrStr + 'SaleBandsCur');
      End; { If }
    End { If }
    Else
      EntSys.DataAccessErrDlg(False, StockErrStr + 'SaleBandsCur');
  {$ELSE}
    DataRec.SaleBands[Ord(Index) - Ord('A') + 1].Currency := 0;
  {$ENDIF}
End;

Function TStock.GetSaleBandsPrice (Index : cuSalesBandIndex) : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SaleBands[Ord(Index) - Ord('A') + 1].SalesPrice
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'SaleBandsPrice');
  End; { Else }
End;

Procedure TStock.SetSaleBandsPrice(Index : cuSalesBandIndex; Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[21] = paReadWrite) Then Begin
    If (DataRec.SaleBands[Ord(Index) - Ord('A') + 1].SalesPrice <> Value) Then Begin
      DataRec.SaleBands[Ord(Index) - Ord('A') + 1].SalesPrice := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'SaleBandsPrice');
End;

Function TStock.GetSellUnit : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SellUnit
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'SalesUnits');
  End; { Else }
End;

Procedure TStock.SetSellUnit(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[22] = paReadWrite) Then Begin
    If (DataRec.SellUnit <> Value) Then Begin
      If (Value <> 0.0) Then Begin
        DataRec.SellUnit := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'SalesUnits');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'SalesUnits');
End;

Function TStock.GetBuyUnit : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.BuyUnit
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'PurchUnits');
  End; { Else }
End;

Procedure TStock.SetBuyUnit(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[23] = paReadWrite) Then Begin
    If (DataRec.BuyUnit <> Value) Then Begin
      If (Value <> 0.0) Then Begin
        DataRec.BuyUnit := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'PurchUnits');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'PurchUnits');
End;

Function TStock.GetVATCode : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.VATCode
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'VATCode');
  End; { Else }
End;

Procedure TStock.SetVATCode(Value : Char);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[24] = paReadWrite) Then Begin
    If (DataRec.VATCode <> Value) Then Begin
      If (Value In VATSet) Then Begin
        DataRec.VATCode := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'VATCode');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'VATCode');
End;

Function TStock.GetCCDep (Const CCFlag : Boolean;Const ErrStr : ShortString) : cuStr3;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CCDep[CCFlag]
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + ErrStr);
  End; { Else }
End;

Procedure TStock.SetCCDep(Const SecIdx : Byte;Const CCFlag : Boolean;Const ErrStr : ShortString;Const Value : cuStr3);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[SecIdx] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), CCKeyLen);
    If (DataRec.CCDep[CCFlag] <> TmpStr) Then Begin
      If (Trim(TmpStr) = '') Or EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[CCFlag],TmpStr),PWrdF,PWK) Then Begin
        DataRec.CCDep[CCFlag] := TmpStr;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + ErrStr);
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + ErrStr);
End;

Function TStock.GetCCDep1 : cuStr3;
Begin
  Result := GetCCDep(True, 'CostCentre');
End;

Procedure TStock.SetCCDep1(Value : cuStr3);
Begin
  SetCCDep(25, True, 'CostCentre', Value);
End;

Function TStock.GetCCDep2 : cuStr3;
Begin
  Result := GetCCDep(False, 'Department');
End;

Procedure TStock.SetCCDep2(Value : cuStr3);
Begin
  SetCCDep(25, False, 'Department', Value);
End;

Function TStock.GetQtyInStock : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.QtyInStock
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'QtyInStock');
  End; { Else }
End;

Procedure TStock.SetQtyInStock(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[27] = paReadWrite) Then Begin
    If (DataRec.QtyInStock <> Value) Then Begin
      DataRec.QtyInStock := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'QtyInStock');
End;

Function TStock.GetQtyPosted : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.QtyPosted
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'QtyPosted');
  End; { Else }
End;

Procedure TStock.SetQtyPosted(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[28] = paReadWrite) Then Begin
    If (DataRec.QtyPosted <> Value) Then Begin
      DataRec.QtyPosted := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'QtyPosted');
End;

Function TStock.GetQtyAllocated : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.QtyAllocated
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'QtyAllocated');
  End; { Else }
End;

Procedure TStock.SetQtyAllocated(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[29] = paReadWrite) Then Begin
    If (DataRec.QtyAllocated <> Value) Then Begin
      DataRec.QtyAllocated := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'QtyAllocated');
End;

Function TStock.GetQtyOnOrder : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.QtyOnOrder
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'QtyOnOrder');
  End; { Else }
End;

Procedure TStock.SetQtyOnOrder(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[30] = paReadWrite) Then Begin
    If (DataRec.QtyOnOrder <> Value) Then Begin
      DataRec.QtyOnOrder := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'QtyOnOrder');
End;

Function TStock.GetQtyMin : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.QtyMin
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'QtyMin');
  End; { Else }
End;

Procedure TStock.SetQtyMin(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[31] = paReadWrite) Then Begin
    If (DataRec.QtyMin <> Value) Then Begin
      DataRec.QtyMin := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'QtyMin');
End;

Function TStock.GetQtyMax : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.QtyMax
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'QtyMax');
  End; { Else }
End;

Procedure TStock.SetQtyMax(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[32] = paReadWrite) Then Begin
    If (DataRec.QtyMax <> Value) Then Begin
      DataRec.QtyMax := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'QtyMax');
End;

Function TStock.GetROQty : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ROQty
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'ReOrderQty');
  End; { Else }
End;

Procedure TStock.SetROQty(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[33] = paReadWrite) Then Begin
    If (DataRec.ROQty <> Value) Then Begin
      If (Value >= 0.0) Then Begin
        DataRec.ROQty := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'ReOrderQty');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'ReOrderQty');
End;

Function TStock.GetShowasKit : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ShowasKit
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'ShowAsKit');
  End; { Else }
End;

Procedure TStock.SetShowasKit(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[35] = paReadWrite) Then Begin
    If (DataRec.ShowasKit <> Value) Then Begin
      If (Not Value) Or (DataRec.StockType = StkBillCode) Then Begin
        DataRec.ShowasKit := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'ShowAsKit');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'ShowAsKit');
End;

Function TStock.GetCommodCode : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CommodCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'CommodCode');
  End; { Else }
End;

Procedure TStock.SetCommodCode(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[36] = paReadWrite) Then Begin
    If (DataRec.CommodCode <> Value) Then Begin
      DataRec.CommodCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'CommodCode');
End;

Function TStock.GetSWeight : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SWeight
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'SaleUnWeight');
  End; { Else }
End;

Procedure TStock.SetSWeight(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[37] = paReadWrite) Then Begin
    If (DataRec.SWeight <> Value) Then Begin
      DataRec.SWeight := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'SaleUnWeight');
End;

Function TStock.GetPWeight : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PWeight
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'PurchUnWeight');
  End; { Else }
End;

Procedure TStock.SetPWeight(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[38] = paReadWrite) Then Begin
    If (DataRec.PWeight <> Value) Then Begin
      DataRec.PWeight := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'PurchUnWeight');
End;

Function TStock.GetUnitSupp : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UnitSupp
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'SSDUnit');
  End; { Else }
End;

Procedure TStock.SetUnitSupp(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[39] = paReadWrite) Then Begin
    If (DataRec.UnitSupp <> Value) Then Begin
      DataRec.UnitSupp := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'SSDUnit');
End;

Function TStock.GetSuppSUnit : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SuppSUnit
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'SSDSalesUnit');
  End; { Else }
End;

Procedure TStock.SetSuppSUnit(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[40] = paReadWrite) Then Begin
    If (DataRec.SuppSUnit <> Value) Then Begin
      If (Value <> 0.0) Or (Not Syss.IntraStat) Then Begin
        DataRec.SuppSUnit := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'SSDSalesUnit');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'SSDSalesUnit');
End;

Function TStock.GetBinLoc : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.BinLoc
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'BinLocation');
  End; { Else }
End;

Procedure TStock.SetBinLoc(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[41] = paReadWrite) Then Begin
    If (DataRec.BinLoc <> Value) Then Begin
      DataRec.BinLoc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'BinLocation');
End;

Function TStock.GetStkFlg : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StkFlg
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'StkFlg');
  End; { Else }
End;

Procedure TStock.SetStkFlg(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[42] = paReadWrite) Then Begin
    If (DataRec.StkFlg <> Value) Then Begin
      DataRec.StkFlg := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'StkFlg');
End;

Function TStock.GetCovPr : SmallInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CovPr
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'CovPr');
  End; { Else }
End;

Procedure TStock.SetCovPr(Value : SmallInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[43] = paReadWrite) Then Begin
    If (DataRec.CovPr <> Value) Then Begin
      If (Value > 0) And DataRec.UseCover Then Begin
        DataRec.CovPr := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'CovPr');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'CovPr');
End;

Function TStock.GetCovPrUnit : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CovPrUnit
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'CovPrUnit');
  End; { Else }
End;

Procedure TStock.SetCovPrUnit(Value : Char);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[44] = paReadWrite) Then Begin
    If (Syss.PrInYr < 25) Then Begin
      RecChanged := RecChanged Or (DataRec.CovPrUnit <> 'M');
      DataRec.CovPrUnit := 'M';
    End { If }
    Else Begin
      RecChanged := RecChanged Or (DataRec.CovPrUnit <> 'W');
      DataRec.CovPrUnit := 'W';
    End { Else }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'CovPrUnit');
End;

Function TStock.GetCovMinPr : SmallInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CovMinPr
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'CovMinPr');
  End; { Else }
End;

Procedure TStock.SetCovMinPr(Value : SmallInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[45] = paReadWrite) Then Begin
    If (DataRec.CovMinPr <> Value) Then Begin
      DataRec.CovMinPr := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'CovMinPr');
End;

Function TStock.GetCovMinUnit : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CovMinUnit
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'CovMinUnit');
  End; { Else }
End;

Procedure TStock.SetCovMinUnit(Value : Char);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[46] = paReadWrite) Then Begin
    If (DataRec.CovMinUnit <> Value) Then Begin
      If (Value In ['D','W','M', #0]) And DataRec.UseCover Then Begin
        DataRec.CovMinUnit := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'CovMinUnit');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'CovMinUnit');
End;

Function TStock.GetSupplier : cuStr6;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Supplier
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'Supplier');
  End; { Else }
End;

Procedure TStock.SetSupplier(Value : cuStr6);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[47] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), CustKeyLen);
    If (DataRec.Supplier <> TmpStr) Then Begin
      If (Trim(TmpStr) = '') Or EntSys.CustExists(TmpStr, [TradeCode[False]]) Then Begin
        DataRec.Supplier := TmpStr;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'Supplier');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'Supplier');
End;

Function TStock.GetQtyFreeze : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.QtyFreeze
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'QtyFreeze');
  End; { Else }
End;

Procedure TStock.SetQtyFreeze(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[48] = paReadWrite) Then Begin
    If (DataRec.QtyFreeze <> Value) Then Begin
      DataRec.QtyFreeze := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'QtyFreeze');
End;

Function TStock.GetCovSold : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CovSold
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'CovSold');
  End; { Else }
End;

Procedure TStock.SetCovSold(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[49] = paReadWrite) Then Begin
    If (DataRec.CovSold <> Value) Then Begin
      DataRec.CovSold := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'CovSold');
End;

Function TStock.GetUseCover : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UseCover
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'UseCover');
  End; { Else }
End;

Procedure TStock.SetUseCover(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[50] = paReadWrite) Then Begin
    If (DataRec.UseCover <> Value) Then Begin
      DataRec.UseCover := Value;
      RecChanged := True;

      If (Not DataRec.UseCover) Then Begin
        DataRec.CovPr:=0;
        DataRec.CovPrUnit:=#0;
        DataRec.CovMinPr:=0;
        DataRec.CovMinUnit:=#0;
        DataRec.CovMaxPr:=0;
        DataRec.CovMaxUnit:=#0;
      End; { If }
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'UseCover');
End;

Function TStock.GetCovMaxPr : SmallInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CovMaxPr
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'CovMaxPr');
  End; { Else }
End;

Procedure TStock.SetCovMaxPr(Value : SmallInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[51] = paReadWrite) Then Begin
    If (DataRec.CovMaxPr <> Value) Then Begin
      DataRec.CovMaxPr := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'CovMaxPr');
End;

Function TStock.GetCovMaxUnit : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CovMaxUnit
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'CovMaxUnit');
  End; { Else }
End;

Procedure TStock.SetCovMaxUnit(Value : Char);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[52] = paReadWrite) Then Begin
    If (DataRec.CovMaxUnit <> Value) Then Begin
      If (Value In ['D','W','M', #0]) And DataRec.UseCover Then Begin
        DataRec.CovMaxUnit := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'CovMaxUnit');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'CovMaxUnit');
End;

Function TStock.GetROCurrency : cuCurrencyType;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ROCurrency
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'ReOrderCur');
  End; { Else }
End;

Procedure TStock.SetROCurrency(Value : cuCurrencyType);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[53] = paReadWrite) Then Begin
    If (DataRec.ROCurrency <> Value) Then Begin
      If EntSys.ValidCcy(Value) Then Begin
        DataRec.ROCurrency := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'ReOrderCur');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'ReOrderCur');
End;

Function TStock.GetROCPrice : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ROCPrice
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'ReOrderPrice');
  End; { Else }
End;

Procedure TStock.SetROCPrice(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[54] = paReadWrite) Then Begin
    If (DataRec.ROCPrice <> Value) Then Begin
      DataRec.ROCPrice := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'ReOrderPrice');
End;

Function TStock.GetRODate : cuLongDate;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RODate
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'ReOrderDate');
  End; { Else }
End;

Procedure TStock.SetRODate(Value : cuLongDate);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[55] = paReadWrite) Then Begin
    If (DataRec.RODate <> Value) Then Begin
      If (Trim(Value) = '') Or EntSys.ValidDate(Value) Then Begin
        DataRec.RODate := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'ReOrderDate');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'ReOrderDate');
End;

Function TStock.GetQtyTake : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.QtyTake
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'QtyTake');
  End; { Else }
End;

Procedure TStock.SetQtyTake(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[56] = paReadWrite) Then Begin
    If (DataRec.QtyTake <> Value) Then Begin
      DataRec.QtyTake := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'QtyTake');
End;

Function TStock.GetStkValType : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StkValType
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'StkValType');
  End; { Else }
End;

Procedure TStock.SetStkValType(Value : Char);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[57] = paReadWrite) Then Begin
    If (DataRec.StkValType <> Value) Then Begin
      If (Value In ['F','L','A','C','S','R']) Then Begin
        DataRec.StkValType := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'StkValType');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'StkValType');
End;

Function TStock.GetQtyPicked : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.QtyPicked
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'QtyPicked');
  End; { Else }
End;

Procedure TStock.SetQtyPicked(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[59] = paReadWrite) Then Begin
    If (DataRec.QtyPicked <> Value) Then Begin
      DataRec.QtyPicked := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'QtyPicked');
End;

Function TStock.GetLastUsed : cuLongDate;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LastUsed
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'LastUsed');
  End; { Else }
End;

Procedure TStock.SetLastUsed(Value : cuLongDate);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[60] = paReadWrite) Then Begin
    If (DataRec.LastUsed <> Value) Then Begin
      If EntSys.ValidDate(Value) Then Begin
        DataRec.LastUsed := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'LastUsed');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'LastUsed');
End;

Function TStock.GetCalcPack : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CalcPack
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'CalcPack');
  End; { Else }
End;

Procedure TStock.SetCalcPack(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[61] = paReadWrite) Then Begin
    If (DataRec.CalcPack <> Value) Then Begin
      DataRec.CalcPack := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'CalcPack');
End;

Function TStock.GetJAnalCode : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JAnalCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'JobAnal');
  End; { Else }
End;

Procedure TStock.SetJAnalCode(Value : cuStr10);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[62] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), AnalKeyLen);
    If (DataRec.JAnalCode <> Value) Then Begin
      If (Trim(TmpStr) = '') Or EntSys.CheckForRec(FullCCKey(JARCode,JAACode,TmpStr),JMiscF,JMK) Then Begin
        DataRec.JAnalCode := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'JobAnal');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'JobAnal');
End;

Function TStock.GetStkUser1 : cuStr20;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StkUser1
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'StkUser1');
  End; { Else }
End;

Procedure TStock.SetStkUser1(Value : cuStr20);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[63] = paReadWrite) Then Begin
    If (DataRec.StkUser1 <> Value) Then Begin
      DataRec.StkUser1 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'StkUser1');
End;

Function TStock.GetStkUser2 : cuStr20;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StkUser2
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'StkUser2');
  End; { Else }
End;

Procedure TStock.SetStkUser2(Value : cuStr20);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[64] = paReadWrite) Then Begin
    If (DataRec.StkUser2 <> Value) Then Begin
      DataRec.StkUser2 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'StkUser2');
End;

Function TStock.GetBarCode : cuStr20;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.BarCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'BarCode');
  End; { Else }
End;

Procedure TStock.SetBarCode(Value : cuStr20);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[65] = paReadWrite) Then Begin
    If (DataRec.BarCode <> Value) Then Begin
      DataRec.BarCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'BarCode');
End;

Function TStock.GetROCCDep (Const CCFlag : Boolean;Const ErrStr : ShortString) : cuStr3;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ROCCDep[CCFlag]
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + ErrStr);
  End; { Else }
End;

Procedure TStock.SetROCCDep(Const SecIdx : Byte;Const CCFlag : Boolean;Const ErrStr : ShortString;Const Value : cuStr3);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[SecIdx] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), CCKeyLen);
    If (DataRec.ROCCDep[CCFlag] <> TmpStr) Then Begin
      If (Trim(TmpStr) = '') Or EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[CCFlag],TmpStr),PWrdF,PWK) Then Begin
        DataRec.ROCCDep[CCFlag] := TmpStr;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + ErrStr);
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + ErrStr);
End;

Function TStock.GetROCCDep1 : cuStr3;
Begin
  Result := GetROCCDep(True, 'ROCostCentre');
End;

Procedure TStock.SetROCCDep1(Value : cuStr3);
Begin
  SetROCCDep(66, True, 'ROCostCentre', Value);
End;

Function TStock.GetROCCDep2 : cuStr3;
Begin
  Result := GetROCCDep(False, 'RODepartment');
End;

Procedure TStock.SetROCCDep2(Value : cuStr3);
Var
  TmpStr : ShortString;
Begin
  SetROCCDep(67, False, 'RODepartment', Value);
End;

Function TStock.GetDefMLoc : cuStr3;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DefMLoc
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'Location');
  End; { Else }
End;

Procedure TStock.SetDefMLoc(Value : cuStr3);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[68] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), MLocKeyLen);
    If (DataRec.DefMLoc <> TmpStr) Then Begin
      If (Trim(TmpStr) = '') Or EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[True],TmpStr),MLocF,MLK) Then Begin
        DataRec.DefMLoc := TmpStr;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'Location');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'Location');
End;

Function TStock.GetPricePack : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PricePack
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'PricePack');
  End; { Else }
End;

Procedure TStock.SetPricePack(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[69] = paReadWrite) Then Begin
    If (DataRec.PricePack <> Value) Then Begin
      DataRec.PricePack := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'PricePack');
End;

Function TStock.GetDPackQty : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DPackQty
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'DPackQty');
  End; { Else }
End;

Procedure TStock.SetDPackQty(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[70] = paReadWrite) Then Begin
    If (DataRec.DPackQty <> Value) Then Begin
      DataRec.DPackQty := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'DPackQty');
End;

Function TStock.GetKitPrice : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.KitPrice
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'KitPrice');
  End; { Else }
End;

Procedure TStock.SetKitPrice(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[71] = paReadWrite) Then Begin
    If (DataRec.KitPrice <> Value) Then Begin
      If (DataRec.StockType = StkBillCode) Then Begin
        DataRec.KitPrice := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'KitPrice');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'KitPrice');
End;

Function TStock.GetKitOnPurch : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.KitOnPurch
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'KitOnPurch');
  End; { Else }
End;

Procedure TStock.SetKitOnPurch(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[34] = paReadWrite) Then Begin
    If (DataRec.KitOnPurch <> Value) Then Begin
      DataRec.KitOnPurch := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'KitOnPurch');
End;


Function TStock.LinkToStock (Const TheCode : ShortString) : Boolean;
Const
  FNum              = StockF;
  KeyPath : Integer = StkCodeK;
Var
  TmpStat, TmpKPath : Integer;
  TmpRecAddr        : LongInt;
  KeyS              : Str255;
  CStatus           : SmallInt;
Begin
  Result := False;

  { Check we're allowed to reload with different stock records }
  If (FuncAccess[1] = pfEnabled) Then
    With EntSys, LocalBtr^ Do
      { Check its a stock item }
      If Is_FullStkCode(TheCode) Then Begin
        { Save current details }
        LastStock := LStock;
        TmpKPath := GetPosKey;
        TmpStat  := LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

        KeyS := FullStockCode (TheCode);
        LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);
        Result := (LStatus = 0);

        If Result Then Begin
          { Reload stock object with new record }
          Assign (WinId, HandlerId, LStock);
        End; { If }

        { Restore file position }
        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);
        LStock := LastStock;
      End; { If }
End;

Function TStock.GetStkUser3 : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StkUser3
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'StkUser3');
  End; { Else }
End;

Procedure TStock.SetStkUser3(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[72] = paReadWrite) Then Begin
    If (DataRec.StkUser3 <> Value) Then Begin
      DataRec.StkUser3 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'StkUser3');
End;

Function TStock.GetStkUser4 : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StkUser4
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'StkUser4');
  End; { Else }
End;

Procedure TStock.SetStkUser4(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[73] = paReadWrite) Then Begin
    If (DataRec.StkUser4 <> Value) Then Begin
      DataRec.StkUser4 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'StkUser4');
End;

Function TStock.GetSerNoWAvg : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SerNoWAvg
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'SerNoWAvg');
  End; { Else }
End;

Procedure TStock.SetSerNoWAvg(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[74] = paReadWrite) Then Begin
    If (DataRec.SerNoWAvg <> Value) Then Begin
      If (DataRec.StkValType = MSERNSub) And (Value In [0..1]) Then Begin
        DataRec.SerNoWAvg := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'SerNoWAvg');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'SerNoWAvg');
End;

Function TStock.GetStkSizeCol : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StkSizeCol
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'StkSizeCol');
  End; { Else }
End;

(*
Procedure TStock.SetStkSizeCol(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[75] = paReadWrite) Then Begin
    If (DataRec.StkSizeCol <> Value) Then Begin

     { Validation }

        DataRec.StkSizeCol := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'StkSizeCol');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'StkSizeCol');
End;
*)

Function TStock.GetSSDDUplift : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SSDDUplift
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'SSDDUplift');
  End; { Else }
End;

Procedure TStock.SetSSDDUplift(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[76] = paReadWrite) Then Begin
    If (DataRec.SSDDUplift <> Value) Then Begin
      If (Value >= 0.0) And (Value <= 100.0) Then Begin
        DataRec.SSDDUplift := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'SSDDUplift');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'SSDDUplift');
End;

Function TStock.GetSSDCountry : cuStr5;
Begin
  If (RecAccess <> NotAvailable) Then
  Begin
    // MH 18/01/2016 2016-R1 ABSEXCH-17099: Stock Country Code removed for UK Companies
    If (CurrentCountry <> UKCCode) Then
      Result := DataRec.SSDCountry
    Else
      Result := '';
  End // If (RecAccess <> NotAvailable)
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'SSDCountry');
  End; { Else }
End;

Procedure TStock.SetSSDCountry(Value : cuStr5);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[77] = paReadWrite) Then Begin
    If (DataRec.SSDCountry <> Value) Then
    Begin
      // MH 18/01/2016 2016-R1 ABSEXCH-17099: Stock Country Code removed for UK Companies
      If (CurrentCountry <> UKCCode) Then
        DataRec.SSDCountry := Value
      Else
        FillChar(DataRec.SSDCountry, SizeOf(DataRec.SSDCountry), #0);
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'SSDCountry');
End;

Function TStock.GetTimeChange : cuStr6;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.TimeChange
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'TimeChange');
  End; { Else }
End;

Function TStock.GetSVATIncFlg : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SVATIncFlg
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'SVATIncFlg');
  End; { Else }
End;

Procedure TStock.SetSVATIncFlg(Value : Char);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[79] = paReadWrite) Then Begin
    If (DataRec.SVATIncFlg <> Value) And (DataRec.VATCode = VATICode) Then Begin
      If (Value In VATSet-VATEqStd) Then Begin
        DataRec.SVATIncFlg := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'SVATIncFlg');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'SVATIncFlg');
End;


Function TStock.GetSSDAUpLift : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SSDAUpLift
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'SSDAUpLift');
  End; { Else }
End;

Procedure TStock.SetSSDAUpLift(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[80] = paReadWrite) Then Begin
    If (DataRec.SSDAUpLift <> Value) Then Begin
      If (Value >= 0.0) And (Value <= 100.0) Then Begin
        DataRec.SSDAUpLift := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (StockErrStr + 'SSDAUpLift');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'SSDAUpLift');
End;

Function TStock.GetLastOpo : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LastOpo
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'LastOpo');
  End; { Else }
End;

Procedure TStock.SetLastOpo(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[81] = paReadWrite) Then Begin
    If (DataRec.LastOpo <> Value) Then Begin
      DataRec.LastOpo := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'LastOpo');
End;

Function TStock.GetImageFile : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ImageFile
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'ImageFile');
  End; { Else }
End;

Procedure TStock.SetImageFile(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[82] = paReadWrite) Then Begin
    If (DataRec.ImageFile <> Value) Then Begin
      DataRec.ImageFile := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'ImageFile');
End;

//--------------------------------------------

function TStock.GetQtyAllocWOR: Double;
begin
  If (RecAccess <> NotAvailable) Then Begin
    {$IFDEF WOP}
    If WOPOn Then
      Result := DataRec.QtyAllocWOR
    Else
    {$ENDIF}
      Result := 0.0;
  End { If }
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'stQtyAllocWOR');
  End; { Else }
end;

procedure TStock.SetQtyAllocWOR(const Value: Double);
begin
  // Read-Only field
  EntSys.DataAccessErrDlg(False, StockErrStr + 'stQtyAllocWOR');
end;

//--------------------------------------------

function TStock.GetQtyIssuedWOR: Double;
begin
  If (RecAccess <> NotAvailable) Then Begin
    {$IFDEF WOP}
    If WOPOn Then
      Result := DataRec.QtyIssueWOR
    Else
    {$ENDIF}
      Result := 0.0;
  End { If }
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'stQtyIssuedWOR');
  End; { Else }
end;

procedure TStock.SetQtyIssuedWOR(const Value: Double);
begin
  // Read-Only field
  EntSys.DataAccessErrDlg(False, StockErrStr + 'stQtyIssuedWOR');
end;

//--------------------------------------------

function TStock.GetQtyPickedWOR: Double;
begin
  If (RecAccess <> NotAvailable) Then Begin
    {$IFDEF WOP}
    If WOPOn Then
      Result := DataRec.QtyPickWOR
    Else
    {$ENDIF}
      Result := 0.0;
  End { If }
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'stQtyPickedWOR');
  End; { Else }
end;

procedure TStock.SetQtyPickedWOR(const Value: Double);
begin
  // Read-Only field
  EntSys.DataAccessErrDlg(False, StockErrStr + 'stQtyPickedWOR');
end;

//--------------------------------------------

function TStock.GetUseForEbus: Boolean;
begin
  If (RecAccess <> NotAvailable) Then
    Result := (DataRec.WebInclude <> 0)
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'stUseForEbus');
  End; { Else }
end;

procedure TStock.SetUseForEbus(const Value: Boolean);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[83] = paReadWrite) Then Begin
    If Value Then DataRec.WebInclude := 1 Else DataRec.WebInclude := 0;
    RecChanged := True;
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'stUseForEbus');
end;

//--------------------------------------------

function TStock.GetWebLiveCatalog: cuStr20;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.WebLiveCat
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'stWebLiveCatalog');
  End; { Else }
end;

procedure TStock.SetWebLiveCatalog(const Value: cuStr20);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[84] = paReadWrite) Then Begin
    If (DataRec.WebLiveCat <> Value) Then Begin
      DataRec.WebLiveCat := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'stWebLiveCatalog');
end;

//--------------------------------------------

function TStock.GetWebPrevCatalog: cuStr20;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.WebPrevCat
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'stWebPrevCatalog');
  End; { Else }
end;

procedure TStock.SetWebPrevCatalog(const Value: cuStr20);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[85] = paReadWrite) Then Begin
    If (DataRec.WebPrevCat <> Value) Then Begin
      DataRec.WebPrevCat := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'stWebPrevCatalog');
end;

//--------------------------------------------

function TStock.GetWOPAssemblyDays: LongInt;
Var
  Days, Hours, Mins : Extended;
begin
  If (RecAccess <> NotAvailable) Then Begin
    {$IFDEF WOP}
    If WOPOn Then Begin
      Time2Mins(DataRec.ProdTime, Days, Hours, Mins, 0);
      Result := Round(Days);
    End { If WOPOn }
    Else
    {$ENDIF}
      Result := 0;
  End { If }
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'stWOPAssemblyDays');
  End; { Else }
end;

procedure TStock.SetWOPAssemblyDays(const Value: Integer);
Var
  Days, Hours, Mins : Extended;
begin
  {$IFDEF WOP}
  If WOPOn Then Begin
    If (RecAccess <> NotAvailable) And (PropAccess[87] = paReadWrite) Then Begin
      Time2Mins(DataRec.ProdTime, Days, Hours, Mins, 0);
      If (Days <> Value) Then Begin
        Days := Value;
        Time2Mins(DataRec.ProdTime, Days, Hours, Mins, 1);
        RecChanged := True;
      End; { If }
    End { If }
    Else
      EntSys.DataAccessErrDlg(False, StockErrStr + 'stWOPAssemblyDays');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('stWOPAssemblyDays');
end;

//--------------------------------------------

function TStock.GetWOPAssemblyHours: LongInt;
Var
  Days, Hours, Mins : Extended;
begin
  If (RecAccess <> NotAvailable) Then Begin
    {$IFDEF WOP}
    If WOPOn Then Begin
      Time2Mins(DataRec.ProdTime, Days, Hours, Mins, 0);
      Result := Round(Hours);
    End { If WOPOn }
    Else
    {$ENDIF}
      Result := 0;
  End { If }
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'stWOPAssemblyHours');
  End; { Else }
end;

procedure TStock.SetWOPAssemblyHours(const Value: Integer);
Var
  Days, Hours, Mins : Extended;
begin
  {$IFDEF WOP}
  If WOPOn Then Begin
    If (RecAccess <> NotAvailable) And (PropAccess[88] = paReadWrite) Then Begin
      Time2Mins(DataRec.ProdTime, Days, Hours, Mins, 0);
      If (Hours <> Value) Then Begin
        Hours := Value;
        Time2Mins(DataRec.ProdTime, Days, Hours, Mins, 1);
        RecChanged := True;
      End; { If }
    End { If }
    Else
      EntSys.DataAccessErrDlg(False, StockErrStr + 'stWOPAssemblyHours');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('stWOPAssemblyHours');
end;

//--------------------------------------------

function TStock.GetWOPAssemblyMins: LongInt;
Var
  Days, Hours, Mins : Extended;
begin
  If (RecAccess <> NotAvailable) Then Begin
    {$IFDEF WOP}
    If WOPOn Then Begin
      Time2Mins(DataRec.ProdTime, Days, Hours, Mins, 0);
      Result := Round(Mins);
    End { If WOPOn }
    Else
    {$ENDIF}
      Result := 0;
  End { If }
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'stWOPAssemblyMins');
  End; { Else }
end;

procedure TStock.SetWOPAssemblyMins(const Value: Integer);
Var
  Days, Hours, Mins : Extended;
begin
  {$IFDEF WOP}
  If WOPOn Then Begin
    If (RecAccess <> NotAvailable) And (PropAccess[89] = paReadWrite) Then Begin
      Time2Mins(DataRec.ProdTime, Days, Hours, Mins, 0);
      If (Mins <> Value) Then Begin
        Mins := Value;
        Time2Mins(DataRec.ProdTime, Days, Hours, Mins, 1);
        RecChanged := True;
      End; { If }
    End { If }
    Else
      EntSys.DataAccessErrDlg(False, StockErrStr + 'stWOPAssemblyMins');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('stWOPAssemblyMins');
end;

//--------------------------------------------

function TStock.GetWOPAutoCalcTime: Boolean;
begin
  If (RecAccess <> NotAvailable) Then Begin
    {$IFDEF WOP}
    If WOPOn Then
      Result := DataRec.CalcProdTime
    Else
    {$ENDIF}
      Result := False
  End { If }
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'stWOPAutoCalcTime');
  End; { Else }
end;

procedure TStock.SetWOPAutoCalcTime(const Value: Boolean);
begin
  {$IFDEF WOP}
  If WOPOn Then Begin
    If (RecAccess <> NotAvailable) And (PropAccess[90] = paReadWrite) Then Begin
      If (DataRec.CalcProdTime <> Value) Then Begin
        DataRec.CalcProdTime := Value;
        RecChanged := True;
      End; { If }
    End { If }
    Else
      EntSys.DataAccessErrDlg(False, StockErrStr + 'stWOPAutoCalcTime');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('stWOPAutoCalcTime');
end;

//--------------------------------------------

function TStock.GetWOPIssuedWIPGL: LongInt;
begin
  Result := 0;
  {$IFDEF WOP}
  If WOPOn then Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.WOPWIPGL
    Else Begin
      Result := 0;
      EntSys.DataAccessErrDlg(True, StockErrStr + 'stWOPIssuedWIPGL');
    End; { Else }
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('stWOPIssuedWIPGL');
end;

procedure TStock.SetWOPIssuedWIPGL(const Value: Integer);
begin
  {$IFDEF WOP}
  If WOPOn Then Begin
    If (RecAccess <> NotAvailable) And (PropAccess[92] = paReadWrite) Then Begin
      If (DataRec.WOPWIPGL <> Value) Then Begin
        // Validate the GL Code
        If EntSys.ValidNomCode(Value, 2) Then Begin
          DataRec.WOPWIPGL := Value;
          RecChanged := True;
        End { If }
        Else
          EntSys.CustomException (StockErrStr + 'Issued WIP GL');
      End; { If }
    End { If }
    Else
      EntSys.DataAccessErrDlg(False, StockErrStr + 'stWOPIssuedWIPGL');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('stWOPIssuedWIPGL');
end;

//--------------------------------------------

function TStock.GetWOPMinEconBuild: Double;
begin
  If (RecAccess <> NotAvailable) Then Begin
    {$IFDEF WOP}
    If WOPOn Then
      Result := DataRec.MinEccQty
    Else
    {$ENDIF}
      Result := 0.0
  End { If }
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'stWOPMinEconBuild');
  End; { Else }
end;

procedure TStock.SetWOPMinEconBuild(const Value: Double);
begin
  {$IFDEF WOP}
  If WOPOn Then Begin
    If (RecAccess <> NotAvailable) And (PropAccess[91] = paReadWrite) Then Begin
      If (DataRec.MinEccQty <> Value) Then Begin
        DataRec.MinEccQty := Value;
        RecChanged := True;
      End; { If }
    End { If }
    Else
      EntSys.DataAccessErrDlg(False, StockErrStr + 'stWOPMinEconBuild');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('stWOPMinEconBuild');
end;

//--------------------------------------------

function TStock.GetWOPROLeadTime: LongInt;
begin
  If (RecAccess <> NotAvailable) Then
    {$IFDEF WOP}
    IF WOPOn Then
      Result := DataRec.Leadtime
    Else
    {$ENDIF}
      Result := 0
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'stWOPROLeadTime');
  End; { Else }
end;

procedure TStock.SetWOPROLeadTime(const Value: Integer);
begin
  {$IFDEF WOP}
  If WOPOn Then Begin
    If (RecAccess <> NotAvailable) And (PropAccess[86] = paReadWrite) Then Begin
      If (DataRec.Leadtime <> Value) Then Begin
        DataRec.Leadtime := Value;
        RecChanged := True;
      End; { If }
    End { If }
    Else
      EntSys.DataAccessErrDlg(False, StockErrStr + 'stWOPROLeadTime');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('stWOPROLeadTime');
end;

//--------------------------------------------

function TStock.GetUsesBins: Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.MultiBinMode
  Else
    EntSys.DataAccessErrDlg(True, StockErrStr + 'stUsesBins');
end;

procedure TStock.SetUsesBins(const Value: Boolean);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[96] = paReadWrite) Then
  Begin
    If (DataRec.MultiBinMode <> Value) Then
    Begin
      DataRec.MultiBinMode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'stUsesBins');
end;

//--------------------------------------------

function TStock.GetSalesWarrantyLength: Byte;
begin
  Result := 0;
  {$IFDEF RET}
  If RetMOn then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.SWarranty
    Else
    Begin
      Result := 0;
      EntSys.DataAccessErrDlg(True, StockErrStr + 'stSalesWarrantyLength');
    End; { Else }
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('stSalesWarrantyLength');
end;
procedure TStock.SetSalesWarrantyLength(Value: Byte);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    EntSys.NotImplException ('TAbsStock3.stSalesWarrantyLength');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('stSalesWarrantyLength');
end;

//------------------------------

function TStock.GetSalesWarrantyUnits: TStockWarrantyUnits;
begin
  Result := wpDays;
  {$IFDEF RET}
  If RetMOn then
  Begin
    If (RecAccess <> NotAvailable) Then
      Case DataRec.SWarrantyType Of
        0 : Result := wpDays;
        1 : Result := wpWeeks;
        2 : Result := wpMonths;
        3 : Result := wpYears;
      Else
        Raise Exception.Create ('TStock.GetSalesWarrantyUnits: Unknown Warranty Units value (' + IntToStr(DataRec.SWarrantyType) + ')');
      End // Case DataRec.SWarrantyType
    Else
      EntSys.DataAccessErrDlg(True, StockErrStr + 'stSalesWarrantyUnits');
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('stSalesWarrantyUnits');
end;
procedure TStock.SetSalesWarrantyUnits(Value: TStockWarrantyUnits);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    EntSys.NotImplException ('TAbsStock3.stSalesWarrantyUnits');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('stSalesWarrantyUnits');
end;

//------------------------------

function TStock.GetManufacturerWarrantyLength: Byte;
begin
  Result := 0;
  {$IFDEF RET}
  If RetMOn then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.MWarranty
    Else
    Begin
      Result := 0;
      EntSys.DataAccessErrDlg(True, StockErrStr + 'stManufacturerWarrantyLength');
    End; { Else }
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('stManufacturerWarrantyLength');
end;
procedure TStock.SetManufacturerWarrantyLength(Value: Byte);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    EntSys.NotImplException ('TAbsStock3.stManufacturerWarrantyLength');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('stManufacturerWarrantyLength');
end;

//------------------------------

function TStock.GetManufacturerWarrantyUnits: TStockWarrantyUnits;
begin
  Result := wpDays;
  {$IFDEF RET}
  If RetMOn then
  Begin
    If (RecAccess <> NotAvailable) Then
      Case DataRec.MWarrantyType Of
        0 : Result := wpDays;
        1 : Result := wpWeeks;
        2 : Result := wpMonths;
        3 : Result := wpYears;
      Else
        Raise Exception.Create ('TStock.GetSalesWarrantyUnits: Unknown Warranty Units value (' + IntToStr(DataRec.SWarrantyType) + ')');
      End // Case DataRec.MWarrantyType
    Else
      EntSys.DataAccessErrDlg(True, StockErrStr + 'stManufacturerWarrantyUnits');
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('stManufacturerWarrantyUnits');
end;
procedure TStock.SetManufacturerWarrantyUnits(Value: TStockWarrantyUnits);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    EntSys.NotImplException ('TAbsStock3.stManufacturerWarrantyUnits');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('stManufacturerWarrantyUnits');
end;

//------------------------------

function TStock.GetSalesReturnGL: LongInt;
begin
  Result := 0;
  {$IFDEF RET}
  If RetMOn then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.ReturnGL
    Else
    Begin
      Result := 0;
      EntSys.DataAccessErrDlg(True, StockErrStr + 'stSalesReturnGL');
    End; { Else }
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('stSalesReturnGL');
end;
procedure TStock.SetSalesReturnGL(Value: Integer);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    EntSys.NotImplException ('TAbsStock3.stSalesReturnGL');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('stSalesReturnGL');
end;

//------------------------------

function TStock.GetPurchaseReturnGL: LongInt;
begin
  Result := 0;
  {$IFDEF RET}
  If RetMOn then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.PReturnGL
    Else
    Begin
      Result := 0;
      EntSys.DataAccessErrDlg(True, StockErrStr + 'stPurchaseReturnGL');
    End; { Else }
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('stPurchaseReturnGL');
end;
procedure TStock.SetPurchaseReturnGL(Value: Integer);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    EntSys.NotImplException ('TAbsStock3.stPurchaseReturnGL');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('stPurchaseReturnGL');
end;

//------------------------------

function TStock.GetSalesReturnQty: Double;
begin
  Result := 0;
  {$IFDEF RET}
  If RetMOn then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.QtyReturn
    Else
    Begin
      Result := 0;
      EntSys.DataAccessErrDlg(True, StockErrStr + 'stSalesReturnQty');
    End; { Else }
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('stSalesReturnQty');
end;
procedure TStock.SetSalesReturnQty(Value: Double);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    EntSys.NotImplException ('TAbsStock3.stSalesReturnQty');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('stSalesReturnQty');
end;

//------------------------------

function TStock.GetPurchaseReturnQty: Double;
begin
  Result := 0;
  {$IFDEF RET}
  If RetMOn then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.QtyPReturn
    Else
    Begin
      Result := 0;
      EntSys.DataAccessErrDlg(True, StockErrStr + 'stPurchaseReturnQty');
    End; { Else }
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('stPurchaseReturnQty');
end;
procedure TStock.SetPurchaseReturnQty(Value: Double);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    EntSys.NotImplException ('TAbsStock3.stPurchaseReturnQty');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('stPurchaseReturnQty');
end;

//------------------------------

function TStock.GetRestockCharge: Double;
begin
  Result := 0;
  {$IFDEF RET}
  If RetMOn then
  Begin
    If (RecAccess <> NotAvailable) Then
      Result := DataRec.ReStockPcnt
    Else
    Begin
      Result := 0;
      EntSys.DataAccessErrDlg(True, StockErrStr + 'stRestockCharge');
    End; { Else }
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('stRestockCharge');
end;
procedure TStock.SetRestockCharge(Value: Double);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    EntSys.NotImplException ('TAbsStock3.stRestockCharge');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('stRestockCharge');
end;

//------------------------------

Function TStock.GetRestockFlag : TStockRestockChargeType;
begin
  Result := rcValue;
  {$IFDEF RET}
  If RetMOn then
  Begin
    If (RecAccess <> NotAvailable) Then
    Begin
      If (DataRec.ReStockPChr = '%') Then
        Result := rcPercentage
      Else
        Result := rcValue;
    End // If (RecAccess <> NotAvailable)
    Else
      EntSys.DataAccessErrDlg(True, StockErrStr + 'stRestockFlag');
  End // If RetMOn
  Else
  {$ENDIF}
    EntSys.VersionException ('stRestockFlag');
end;
Procedure TStock.SetRestockFlag (Value : TStockRestockChargeType);
begin
  {$IFDEF RET}
  If RetMOn Then
  Begin
    EntSys.NotImplException ('TAbsStock3.stRestockFlag');
  End { If WOPOn }
  Else
  {$ENDIF}
    EntSys.VersionException ('stRestockFlag');
end;

//------------------------------

Function TStock.GetStkUser5 : cuStr30;
Begin // GetStkUser5
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StkUser5
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'StkUser5');
  End; { Else }
End; // GetStkUser5

Procedure TStock.SetStkUser5 (Value : cuStr30);
Begin // SetStkUser5
  If (RecAccess <> NotAvailable) And (PropAccess[idxUser5] = paReadWrite) Then
  Begin
    If (DataRec.StkUser5 <> Value) Then
    Begin
      DataRec.StkUser5 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'StkUser5');
End; // SetStkUser5

//------------------------------

Function TStock.GetStkUser6 : cuStr30;
Begin // GetStkUser6
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StkUser6
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'StkUser6');
  End; { Else }
End; // GetStkUser6

Procedure TStock.SetStkUser6 (Value : cuStr30);
Begin // SetStkUser6
  If (RecAccess <> NotAvailable) And (PropAccess[idxUser6] = paReadWrite) Then
  Begin
    If (DataRec.StkUser6 <> Value) Then
    Begin
      DataRec.StkUser6 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'StkUser6');
End; // SetStkUser6

//------------------------------

Function TStock.GetStkUser7 : cuStr30;
Begin // GetStkUser7
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StkUser7
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'StkUser7');
  End; { Else }
End; // GetStkUser7

Procedure TStock.SetStkUser7 (Value : cuStr30);
Begin // SetStkUser7
  If (RecAccess <> NotAvailable) And (PropAccess[idxUser7] = paReadWrite) Then
  Begin
    If (DataRec.StkUser7 <> Value) Then
    Begin
      DataRec.StkUser7 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'StkUser7');
End; // SetStkUser7

//------------------------------

Function TStock.GetStkUser8 : cuStr30;
Begin // GetStkUser8
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StkUser8
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'StkUser8');
  End; { Else }
End; // GetStkUser8

Procedure TStock.SetStkUser8 (Value : cuStr30);
Begin // SetStkUser8
  If (RecAccess <> NotAvailable) And (PropAccess[idxUser8] = paReadWrite) Then
  Begin
    If (DataRec.StkUser8 <> Value) Then
    Begin
      DataRec.StkUser8 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'StkUser8');
End; // SetStkUser8

//------------------------------

Function TStock.GetStkUser9 : cuStr30;
Begin // GetStkUser9
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StkUser9
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'StkUser9');
  End; { Else }
End; // GetStkUser9

Procedure TStock.SetStkUser9 (Value : cuStr30);
Begin // SetStkUser9
  If (RecAccess <> NotAvailable) And (PropAccess[idxUser9] = paReadWrite) Then
  Begin
    If (DataRec.StkUser9 <> Value) Then
    Begin
      DataRec.StkUser9 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'StkUser9');
End; // SetStkUser9

//------------------------------

Function TStock.GetStkUser10 : cuStr30;
Begin // GetStkUser10
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StkUser10
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, StockErrStr + 'StkUser10');
  End; { Else }
End; // GetStkUser10

Procedure TStock.SetStkUser10 (Value : cuStr30);
Begin // SetStkUser10
  If (RecAccess <> NotAvailable) And (PropAccess[idxUser10] = paReadWrite) Then
  Begin
    If (DataRec.StkUser10 <> Value) Then
    Begin
      DataRec.StkUser10 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'StkUser10');
End; // SetStkUser10

//------------------------------

Function TStock.GetIsService : Boolean;
Begin // GetIsService
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.stIsService
  Else
  Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, StockErrStr + 'IsService');
  End; { Else }
End; // GetIsService

Procedure TStock.SetIsService (Value : Boolean);
Begin // SetIsService
  If (RecAccess <> NotAvailable) And (PropAccess[idxIsService] = paReadWrite) Then
  Begin
    If (DataRec.stIsService <> Value) Then
    Begin
      // Validate that it is a description only stock item
      If (DataRec.StockType = StkDescCode) Then
      Begin
        DataRec.stIsService := Value;
        RecChanged := True;
      End // If (DataRec.StockType = StkDescCode)
      Else
        EntSys.CustomException (StockErrStr + 'IsService');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, StockErrStr + 'IsService');
End; // SetIsService

//------------------------------




End.

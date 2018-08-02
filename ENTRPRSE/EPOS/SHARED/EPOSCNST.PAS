Unit EposCnst;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


Interface

{$H-}

Uses
  UseDLLU, BtrvU2, GlobVar, VarConst, StrUtil, Graphics, GfxUtil, Classes;

  function OpenEPOSBtrv(iFileNo : byte) : boolean;
  Function GetEPOSRec(iFileNo : Byte; bLock : boolean; var iLockPos : integer) : smallint;

{$I EXDLLBT.INC}

Const
  {$I FILEPATH.INC}

  //GS 16/11/2011 ABSEXCH-12082: updated version number
  // CA 08/07/2013 ABSEXCH-14439: Updated Version Number
  // CJS 2013-10-22 - MRD2.5.12 - Trade Counter - Delivery Address Postcode
  // MH 26/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount support withdrawn from 01/04/2015
  //PR: 14/09/2017 v2017 R2 ABSEXCH-18858 Password complexity
  sTCMVersionNumber = '327';
  sTCMAdminVersionNumber = '327';

  // NF: 27/04/2007 Removed as file is not SQL compatible
//  EposSysF = 18;
//  EposCentF = 19;
  EposCentF = 18;

  EposNofKeys = 1;
  EposIndexK = 0;
  EposNofSegs = 2;

  atLogin = 1;
  atNewTx = 0;

  ValidColorSet = [cm64Bit, cm32Bit, cm24Bit, cm16Bit];

  CM_DisplayAbout    = $F1;

  TX_SINs = 0;
  TX_PICKED_SORs = 1;
  TX_UNPICKED_SORs = 2;

  DT_OVERRIDE_PRICE = '£';
  DT_PERCENTAGE = '%';
  DT_DISCOUNT_AMOUNT = #0;

Type
  TCompanyType = Record
    CompCode : string[6];
    CompName : string[45];
    CompPath : string[100];
    CompSpare : array [1..100] of char;
  end;

  TPayedBy = (pbCash, pbCard, pbCheque, pbAccount); {the order of these is significant}

  TCreditCardRec = record
    Desc : String20;
    GLCode : LongInt;
  end;

  TCreditCards = Array [0..19] of TCreditCardRec;

  TEposSetupRec = record
    EposIndex : String30;               // Index (for future expansion)
    AfterTender : Byte;                 // 0 - Add new Transaction / 1 - Return to Login
    DefaultAccountCode : String6;       // Default account code when adding a new TX
    TillCurrency : byte;                // Currency of the till
    MOPNomCodes : Array[low(TPayedBy)..high(TPayedBy)] of LongInt; // NomCodes for each MOP (Card Not used)
    ReceiptFormName : string8;          // Name of Receipt Form to use for Receipt printing.

    DefSSDDeliveryTerms : String5;      // Default Intrastat Delivery Terms;
    DefSSDModeOfTrans: Byte;            // Default Intrastat Mode of Transport;
    DefStockLocation : String3;       // Default Stock Location

    CashDrawerOpenOn : Array[low(TPayedBy)..high(TPayedBy)] of boolean; // defines whether to open the cash drawer for each MOP
    WriteOffNomCode : LongInt;          // Nom code to use for written-off amounts.

    InvoiceFormName : string8;          // Name of Receipt Form to use for Invoice printing.
    InvoicePrinter : string50;          // Name of Printer to use for Invoice printing.
    ReceiptPrinter : string50;          // Name of Printer to use for Receipt printing.

    CashDrawerKick : String50;          // List of Character Codes separated by a space - Used to send a Cash drawer Kick-out
    CashDrawerCOM : Byte;               // Com Port number to send the Kick-out down.

    CreditCards : TCreditCards; // Holds the descriptions and nominal codes of your credit cards

    RecPrintBin : LongInt;              // Receipt Printer Bin ID
    RecPrintPaper : LongInt;            // Receipt Printer Paper ID
    InvPrintBin : LongInt;              // Invoice Printer Bin ID
    InvPrintPaper : LongInt;            // Invoice Printer Paper ID

    DefNonStockNomCode : LongInt;       // Default Nominal Code used for Non-Stock Items
    CashCustType : String4;             // Match this to the "Cust Type" on the customer record to make a "Cash Only" customer.
    AutoAddLine : boolean;              // Whether to reopen the add line dialog after adding a line
    AllowModifyVATRate : boolean;       // Defines whether you can modify the VAT rate on each TX Line

    RoundChange : boolean;              // Whether to round the change given.
    RoundChangeTo : real;               // The amount of rounding that needs to be done.

    TillCompany : string6;

    OrderPrinter : string50;            // Name of Printer to use for Order printing.
    OrderFormName : string8;            // Name of Receipt Form to use for Order printing.
    OrderPrintPaper : LongInt;          // Order Printer Paper ID
    OrderPrintBin : LongInt;            // Order Printer Bin ID

    TransactionType : byte;             // 0 = Create SINs / 1 = Create Picked SORs / 2 = Create Unpicked SORs
    NegativeTXType : byte;              // 0 = Create SINs / 1 = Create SRFs and SCRs
    DiscountType : byte;                // 0 = As was TCM Discounts / 1 = Use and Modify Enterprise Discounts
    UseDefAccCode : byte;               // 0 = Do not use default account code / 1 = Do use default account code
    FilterSerialBinByLocation : Byte;      // 0 = Do not Filter Serial numbers By Location / 1 = Do Filter Serial numbers By Location
    TakeNonStockDefaultFrom : Byte;     // 0 = Use Default vales in System Setup / 1 = Take Defaults from a stock item
    NonStockItemCode : string16;        // stock item to take Defaults from for Non Stock Items
    NonStockVATCode : Char;

    CCDeptMode : Byte;                  // 0 = CC/Dept from Customer / 1 = CC/Dept from Enterprise Rules / 2 = CC/Dept from Defaults
    DefCostCentre : string3;            // Default Cost Centre (used if above is 3)
    DefDepartment : string3;            // Default Department (used if above is 3)

    NoDepositsOnCashCust : Boolean;     // Do not allow Cash customers to place deposits. They must pay the whole amount.
    CashDrawerBaudRate : Byte;          // Baud Rate to Send Kick out : 0 = 9600 / 1 = 19200 / 2 = 38400 / 3 = 57600 / 4 = 115200
    TransactionTagNo : Byte;          // Tag No to set on stored SORs

    AllowWriteOffs4CashCustomers : Boolean; // allows Cash customers to write off amounts on tender.
    KeepOriginalLayawayDate : Boolean;       // when TX is brought back from layaway, this defines whether to keep the layaway date or reset it to the current date

    TagNoFrom : Byte;                        // Where to get Tag No from / 0 = Default, 1 = Customer, 2 = Customer then Default

    CashbackOnOtherMOPs : Boolean;       // allows you to overpay on credit card and cheque, and puts a negative amount in the cash field for you
    GetDelAddrFromCustAddr : Boolean;       // allows you to overpay on credit card and cheque, and puts a negative amount in the cash field for you

    Spare  : Array [1..3199] Of Char;
    // NOTE: DO NOT USE LAST 100 BYTES OF THIS RECORD
  end;{TEposSetupRec}

  PEposSetupRec = ^TEposSetupRec;

  TTillNamesRec = Record
    Name : Array [1..99] of string30;
    Company : Array [1..99] of string6;
    // NOTE: DO NOT USE LAST 100 BYTES OF THIS RECORD
  end;{TTillNamesRec}

  TEposRec = record
    RecPFix  : Char;
    Case Byte Of
      1 : (EposSetup : TEposSetupRec);
      2 : (TillNames : TTillNamesRec);
      3 : (Misc    : Array [1..4000] Of Char);
  end;{TEposRec}

  TEpos_FileDef = Record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..EposNofSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  end;{TEpos_FileDef}

  TRunFrom = (rfSetup, rfTrade);
  TTenderMode = (tmAdd, tmEdit, tmView);
  TAllowedTo = (atRunTradeCounter, atWriteOff, atDoDiscounts, atTakeDeposits, atEnterNegQty
  , atEnterNegValue, atCopyTransactions, atFindTransactions, atLeaveSerialNosOutstanding
  , atAccessAdmin, atSetupSystem, atRunReports, atModifyVATRates, atSetPriceToZero
  , atFindNonTCMTXs, atSeeAllLayaways, atDeleteLayaways, atNegativeStock
  , atLeaveBinsOutstanding, atSellAtLessThanCost, atDiscountToExceedSale, atSeeGP);
var
//   EposSysRec : TEposRec; // NF: 27/04/2007 Removed as file is not SQL compatible
   EposCentRec : TEposRec;
   SetupRecord : TEposSetupRec;
   TillNamesRec : TTillNamesRec;
   EposFile : TEpos_FileDef;
   RunFrom : TRunFrom;
   sCurrCompPath : string;
   iTillNo : byte;
   TenderMode : TTenderMode;
   sVATText : string;
   aAllowedTo : Array [Low(TAllowedTo)..High(TAllowedTo)] of Boolean;
   sCurrencySym : String3;
   sCentralTradePath : String;
   sTillName : string;
   sUserName : string;
   bDrawBitmaps : boolean;
   bShowStock : boolean;
   sBackground : string8;
   bitFormBackground : TBitmap;
   SysColorMode : TColorMode;
   iCompanyID : integer;
   sCurrCompName : string;
   CurrCompanyRec : TCompanyType;
   bRunningFromCentral, bToolkitOpen : boolean;
   slCompanies : TStringList;
   EnhancedSecurity : smallint;
   iOrigTXType : byte;

Implementation
uses
  EPOSComn, SysUtils, Dialogs, Forms, APIUtil, BTSupU1, FileCtrl, Controls,
  {$IFDEF EXSQL}
  SQLUtils,
  {$ENDIF}
  EPOSProc;
// NF: 27/04/2007 Removed as file is not SQL compatible
(*
Procedure DefineEposSys;
Begin
  With EposFile do begin
    FileSpecLen[EposSysF] := Sizeof(EposFile);
    Fillchar(EposFile,FileSpecLen[EposSysF],0);
    RecLen := Sizeof(EposSysRec);
    PageSize := DefPageSize7;
    NumIndex := EposNofKeys;
    Variable := B_Variable + B_Compress + B_BTrunc; {* Used for max compression *}

    { Key Definitions }

    { Index 0: RecPFix + EposIndex}
    With KeyBuff [1] Do Begin
      KeyPos     := BtKeyPos(@EposSysRec.RecPFix, @EposSysRec);
      KeyLen     := sizeof(EposSysRec.RecPFix);
      KeyFlags   := DupModSeg;
    End; { With }
    With KeyBuff [2] Do Begin
      KeyPos     := BtKeyPos(@EposSysRec.EposSetup.EposIndex[1], @EposSysRec);
      KeyLen     := sizeof(EposSysRec.EposSetup.EposIndex) - 1;
      KeyFlags   := DupMod;
    End; { With }
    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}

  FileRecLen[EposSysF] := Sizeof(EposSysRec);
  Fillchar(EposSysRec,FileRecLen[EposSysF],0);
  RecPtr[EposSysF] := @EposSysRec;
  FileSpecOfs[EposSysF] := @EposFile;
  FileNames[EposSysF] := sBtrvFilename;
end; {..}
*)
Procedure DefineEposCent;
Begin
  With EposFile do begin
    FileSpecLen[EposCentF] := Sizeof(EposFile);
    Fillchar(EposFile,FileSpecLen[EposCentF],0);
    RecLen := Sizeof(EposCentRec);
    PageSize := DefPageSize7;
    NumIndex := EposNofKeys;
    Variable := B_Variable + B_Compress + B_BTrunc; {* Used for max compression *}

    { Key Definitions }

    { Index 0: RecPFix + EposIndex}
    With KeyBuff [1] Do Begin
      KeyPos     := BtKeyPos(@EposCentRec.RecPFix, @EposCentRec);
      KeyLen     := sizeof(EposCentRec.RecPFix);
      KeyFlags   := DupModSeg;
    End; { With }
    With KeyBuff [2] Do Begin
      KeyPos     := BtKeyPos(@EposCentRec.EposSetup.EposIndex[1], @EposCentRec);
      KeyLen     := sizeof(EposCentRec.EposSetup.EposIndex) - 1;
      KeyFlags   := DupMod;
    End; { With }
    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}

  FileRecLen[EposCentF] := Sizeof(EposCentRec);
  Fillchar(EposCentRec,FileRecLen[EposCentF],0);
  RecPtr[EposCentF] := @EposCentRec;
  FileSpecOfs[EposCentF] := @EposFile;
//  FileNames[EposCentF] := sBtrvFilename;
  FileNames[EposCentF] := ''; // NF: I don;t believe that this filename is ever used.
end; {..}

function OpenEPOSBtrv(iFileNo : byte) : boolean;
var
  sFileToOpen, sEXEDir, sTempSetDrive : string;
  iStatus : smallint;

  function OpenEPOSFile : boolean;
  begin
    case iFileNo of
       // NF: 27/04/2007 Removed as file is not SQL compatible
{      EPOSSysF : begin
        sFileToOpen := sEXEDir + sBtrvFilename;
        Result := FileExists(sFileToOpen);
        if Result then begin
          sTempSetDrive := SetDrive;
          SetDrive := sEXEDir;
          FileNames[iFileNo] := sBtrvFilename;
        end;{if}
//      end;

      EPOSCentF : begin
        sFileToOpen := sCentralTradePath + 'TILLNAME.DAT';
{$IFDEF EXSQL}
        Result := TableExists(sFileToOpen);
{$ELSE}
        Result := FileExists(sFileToOpen);
{$ENDIF}
        if Result then begin
          sTempSetDrive := SetDrive;
          SetDrive := sCentralTradePath;
          FileNames[iFileNo] := 'TILLNAME.DAT';
        end;{if}
      end;
    end;{case}

    if Result then begin
      Open_System(iFileNo, iFileNo);
      SetDrive := sTempSetDrive;
    end;{if}
  end;{OpenEPOSFile}

begin
//  DefineEPOSSys; // NF: 27/04/2007 Removed as file is not SQL compatible
  DefineEPOSCent;

  sEXEDir := ExtractFilePath(Application.ExeName);
  Result := OpenEPOSFile;

  if not Result then begin
    case iFileNo of
        // NF: 27/04/2007 Removed as file is not SQL compatible
(*      EPOSSysF : begin
        if (Application.Title = 'Epos Setup') or (Application.Title = 'Possetup') then
          begin
            {EPOS Setup Module}

            if MsgBox('The configuration file for this application does not exist in the following directory' +
            #13 + #13 + #9 + ExtractFilePath(Application.ExeName) + #13 + #13 + 'Do you wish to create a configuration file here ?'
            ,mtConfirmation,[mbYes,mbNo],mbYes,'Create Configuration File ?') = mrYes then
              begin

                {Create EPOS System Setup File}
                iStatus := Make_File(F[iFileNo],sEXEDir + FileNames[iFileNo],FileSpecOfs[iFileNo]^
                ,FileSpecLen[iFileNo]);
                Report_BError(iFileNo, iStatus);

                {Open File}
                if OpenEPOSFile then begin
                  {Blank Record}
                  FillChar(EPOSSysRec,SizeOf(EposSysRec),#0);

                  {Set Defaults}
                  EposSysRec.RecPFix := 'S';
                  with EposSysRec.EposSetup do begin
                    TillCurrency := 1;
                    DefSSDDeliveryTerms := 'EXW';
                    DefSSDModeOfTrans := 1;
                    CashDrawerOpenOn[pbCash] := TRUE;
                    CashDrawerKick := '27 112 0 5 50';
                    CashDrawerCOM := 1;
                  end;{with}

                  {Add Record}
                  iStatus := Add_Rec(F[iFileNo],iFileNo,RecPtr[iFileNo]^,CurrKeyPath^[iFileNo]);
                  Report_BError(iFileNo,iStatus);
                  Result := iStatus = 0;
                end;{if}
              end
            else begin
              Screen.Cursor := crDefault;
            end;{if}
          end
        else begin
          {Trade Counter Module}
          MyMsgBox('You must setup your system using the Trade Counter Configuration program before you can use the Trade Counter System'
          ,mtInformation,[mbOK],mbOK,'EPOS Setup');
          Result := FALSE;
        end;{if}
      end;
      *)
      EPOSCentF : begin
        if MsgBox('The central configuration file (' + sFileToOpen + ') does not exist.' +
        #13#13 + 'Do you wish to create a new blank configuration file ?'
        ,mtConfirmation,[mbYes,mbNo],mbYes,'Create Configuration File ?') = mrYes then
          begin
            {Create Central Setup File}
            iStatus := Make_File(F[iFileNo],sFileToOpen,FileSpecOfs[iFileNo]^,FileSpecLen[iFileNo]);
            Report_BError(iFileNo, iStatus);

            {Open File}
            if OpenEPOSFile then begin
              {Blank Record}
              FillChar(EposCentRec,SizeOf(EposCentRec),#0);

              {Set Record Type}
              EposCentRec.RecPFix := 'N';

              {Add Record}
              iStatus := Add_Rec(F[iFileNo],iFileNo,RecPtr[iFileNo]^,CurrKeyPath^[iFileNo]);
              Report_BError(iFileNo,iStatus);
              Result := iStatus = 0;
            end;{if}
          end
        else begin
          Screen.Cursor := crDefault;
        end;{if}
      end;

    end;{case}
  end;{if}
end;

Function GetEPOSRec(iFileNo : Byte; bLock : boolean; var iLockPos : integer) : smallint;
var
  sKey : str255;
begin

  sKey := 'S';

  if bLock then Result := Find_Rec(B_GetGEq + B_MultNWLock, F[iFileNo], iFileNo, RecPtr[iFileNo]^, 0, sKey)
  else Result := Find_Rec(B_GetGEq, F[iFileNo], iFileNo, RecPtr[iFileNo]^, 0, sKey);

  case Result of
    0 : begin
      {Found OK}
      GetPos(F[iFileNo], iFileNo, iLockPos);
    end;

    4, 9 : begin
      case iFileNo of
        EPOSCentF : Result := 0;

        // NF: 27/04/2007 Removed as file is not SQL compatible
(*        EPOSSysF : begin
          // System Setup Record Not Found
          MsgBox('The configuration file for this till does not contain a system setup record.' + #13 + #13
          ,mtInformation,[mbOK],mbOK,'Setup Not Found (4,9)');
        end;*)
      end;{case}
    end;

    84 : begin
      {Record Lock}
      MsgBox('The system configuration file is currently locked by another user.' + #13 + #13
      + 'You cannot alter the system setup at this time',mtInformation,[mbOK],mbOK,'Record Lock (84)');
    end;

    else Report_BError(iFileNo,Result);
  end;{case}
end;

initialization
{  showmessage('NewSpare : ' + IntToStr(4096 - SizeOf(SetupRecord)));}
  iCompanyID := -1;
  slCompanies := TStringList.Create;

{ShowMessage('TLayBinRec : ' + IntToStr(SizeOf(TLayBinRec)));
ShowMessage('TLayHeadRec : ' + IntToStr(SizeOf(TLayHeadRec)));
ShowMessage('TLayLineRec : ' + IntToStr(SizeOf(TLayLineRec)));
ShowMessage('TLaySerialRec : ' + IntToStr(SizeOf(TLaySerialRec)));}
//ShowMessage('TEposSetupRec : ' + IntToStr(SizeOf(TEposSetupRec)));
//ShowMessage('TTillNamesRec : ' + IntToStr(SizeOf(TTillNamesRec)));




finalization
  slCompanies.Free;




end.

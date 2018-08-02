unit oCust;

interface

Uses Classes, Dialogs, SysUtils, Windows, CustAbsU, CustTypU, GlobVar, VARRec2U,VarConst;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TCustomer = Class(TAbsCustomer10)
  Private
    IsCust     : Boolean;
    CustObjStr : ShortString;
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..94] Of TPropertyAccess;
    FuncAccess : Array [1..2] Of TFunctionAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    DataRec, OrigRec : CustRec;
  Protected
    { Abstract Property Access methods from TAbsCustomer }
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function  GetCustCode : cuStr6; Override;
    Procedure SetCustCode(Value : cuStr6); Override;
    Function  GetCompany : cuStr45; Override;
    Procedure SetCompany(Value : cuStr45); Override;
    Function  GetAreaCode : cuStr4; Override;
    Procedure SetAreaCode(Value : cuStr4); Override;
    Function  GetRepCode : cuStr4; Override;
    Procedure SetRepCode(Value : cuStr4); Override;
    Function  GetRemitCode : cuStr6; Override;
    Procedure SetRemitCode(Value : cuStr6); Override;
    Function  GetVATRegNo : cuStr30; Override;
    Procedure SetVATRegNo(Value : cuStr30); Override;
    Function  GetAddr (Index : cuAddrIndex) : cuStr30; Override;
    Procedure SetAddr(Index : cuAddrIndex; Value : cuStr30); Override;
    Function  GetDespAddr : Boolean; Override;
    Procedure SetDespAddr(Value : Boolean); Override;
    Function  GetDAddr (Index : cuAddrIndex) : cuStr30; Override;
    Procedure SetDAddr(Index : cuAddrIndex; Value : cuStr30); Override;
    Function  GetContact : cuStr25; Override;
    Procedure SetContact(Value : cuStr25); Override;
    Function  GetPhone : cuStr30; Override;
    Procedure SetPhone(Value : cuStr30); Override;
    Function  GetFax : cuStr30; Override;
    Procedure SetFax(Value : cuStr30); Override;
    Function  GetRefNo : cuStr10; Override;
    Procedure SetRefNo(Value : cuStr10); Override;
    Function  GetTradTerm : Boolean; Override;
    Procedure SetTradTerm(Value : Boolean); Override;
    Function  GetSTerms (Index : cuTermsIndex) : cuStr80; Override;
    Procedure SetSTerms(Index : cuTermsIndex; Value : cuStr80); Override;
    Function  GetCurrency : cuCurrencyType; Override;
    Procedure SetCurrency(Value : cuCurrencyType); Override;
    Function  GetVATCode : Char; Override;
    Procedure SetVATCode(Value : Char); Override;
    Function  GetPayTerms : SmallInt; Override;
    Procedure SetPayTerms(Value : SmallInt); Override;
    Function  GetCreditLimit : Real; Override;
    Procedure SetCreditLimit(Value : Real); Override;
    Function  GetDiscount : Real; Override;
    Procedure SetDiscount(Value : Real); Override;
    Function  GetCreditStatus : SmallInt; Override;
    Procedure SetCreditStatus(Value : SmallInt); Override;
    Function  GetCustCC : cuStr3; Override;
    Procedure SetCustCC(Value : cuStr3); Override;
    Function  GetCDiscCh : Char; Override;
    Procedure SetCDiscCh(Value : Char); Override;
    Function  GetBalance : Real; Override;
    Procedure SetBalance(Value : Real); Override;
    Function  GetCustDep : cuStr3; Override;
    Procedure SetCustDep(Value : cuStr3); Override;
    Function  GetEECMember : Boolean; Override;
    Procedure SetEECMember(Value : Boolean); Override;
    Function  GetIncStat : Boolean; Override;
    Procedure SetIncStat(Value : Boolean); Override;
    Function  GetDefNomCode : LongInt; Override;
    Procedure SetDefNomCode(Value : LongInt); Override;
    Function  GetDefMLocStk : cuStr3; Override;
    Procedure SetDefMLocStk(Value : cuStr3); Override;
    Function  GetAccStatus : cuAccStatusType; Override;
    Procedure SetAccStatus(Value : cuAccStatusType); Override;
    Function  GetPayType : Char; Override;
    Procedure SetPayType(Value : Char); Override;
    Function  GetBankSort : cuStr20; Override;
    Procedure SetBankSort(Value : cuStr20); Override;
    Function  GetBankAcc : cuStr15; Override;
    Procedure SetBankAcc(Value : cuStr15); Override;
    Function  GetBankRef : cuStr28; Override;
    Procedure SetBankRef(Value : cuStr28); Override;
    Function  GetPhone2 : cuStr30; Override;
    Procedure SetPhone2(Value : cuStr30); Override;
    Function  GetDefCOSNom : LongInt; Override;
    Procedure SetDefCOSNom(Value : LongInt); Override;
    Function  GetDefCtrlNom : LongInt; Override;
    Procedure SetDefCtrlNom(Value : LongInt); Override;
    Function  GetLastUsed : cuLongDate; Override;
    Procedure SetLastUsed(Value : cuLongDate); Override;
    Function  GetUserDef1 : cuStr30; Override;
    Procedure SetUserDef1(Value : cuStr30); Override;
    Function  GetUserDef2 : cuStr30; Override;
    Procedure SetUserDef2(Value : cuStr30); Override;
    Function  GetSOPInvCode : cuStr6; Override;
    Procedure SetSOPInvCode(Value : cuStr6); Override;
    Function  GetSOPAutoWOff : Boolean; Override;
    Procedure SetSOPAutoWOff(Value : Boolean); Override;
    Function  GetFDefPageNo : Byte; Override;
    Procedure SetFDefPageNo(Value : Byte); Override;
    Function  GetBOrdVal : Double; Override;
    Procedure SetBOrdVal(Value : Double); Override;
    Function  GetDirDeb : Byte; Override;
    Procedure SetDirDeb(Value : Byte); Override;

    Function  GetAltCode : cuStr20; Override;
    Procedure SetAltCode(Value : cuStr20); Override;
    Function  GetPostCode : cuStr20; Override;
    Procedure SetPostCode(Value : cuStr20); Override;
    Function  GetUserDef3 : cuStr30; Override;
    Procedure SetUserDef3(Value : cuStr30); Override;
    Function  GetUserDef4 : cuStr30; Override;
    Procedure SetUserDef4(Value : cuStr30); Override;
    Function  GetEmailAddr : cuStr100; Override;
    Procedure SetEmailAddr(Value : cuStr100); Override;
    Function  GetCCStart : cuLongDate; Override;
    Procedure SetCCStart(Value : cuLongDate); Override;
    Function  GetCCEnd : cuLongDate; Override;
    Procedure SetCCEnd(Value : cuLongDate); Override;
    Function  GetCCName : cuStr50; Override;
    Procedure SetCCName(Value : cuStr50); Override;
    Function  GetCCNumber : cuStr30; Override;
    Procedure SetCCNumber(Value : cuStr30); Override;
    Function  GetCCSwitch : cuStr4; Override;
    Procedure SetCCSwitch(Value : cuStr4); Override;

    // v5.00 Fields
    Function  GetDefTagNo : Byte; Override;
    Procedure SetDefTagNo(Value : Byte); Override;
    Function  GetDefSettleDisc : Double; Override;
    Procedure SetDefSettleDisc(Value : Double); Override;
    Function  GetDefSettleDays : SmallInt; Override;
    Procedure SetDefSettleDays(Value : SmallInt); Override;
    Function  GetDocDeliveryMode : Byte; Override;
    Procedure SetDocDeliveryMode(Value : Byte); Override;
    Function  GetEbusPword : cuStr20; Override;
    Procedure SetEbusPword(Value : cuStr20); Override;
    Function  GetUseForEbus : Byte; Override;
    Procedure SetUseForEbus(Value : Byte); Override;
    Function  GetWebLiveCatalog : cuStr20; Override;
    Procedure SetWebLiveCatalog(Value : cuStr20); Override;
    Function  GetWebPrevCatalog : cuStr20; Override;
    Procedure SetWebPrevCatalog(Value : cuStr20); Override;
    Function  GetInclusiveVATCode : Char; Override;
    Procedure SetInclusiveVATCode(Value : Char); Override;
    Function  GetLastOperator : cuStr10; Override;
    Procedure SetLastOperator(Value : cuStr10); Override;
    Function  GetSendHTML : Boolean; Override;
    Procedure SetSendHTML(Value : Boolean); Override;
    Function  GetSendReader : Boolean; Override;
    Procedure SetSendReader(Value : Boolean); Override;
    Function  GetZIPAttachments : Byte; Override;
    Procedure SetZIPAttachments(Value : Byte); Override;
    Function  GetSSDDeliveryTerms : cuStr5; Override;
    Procedure SetSSDDeliveryTerms(Value : cuStr5); Override;
    Function  GetSSDModeOfTransport : Byte; Override;
    Procedure SetSSDModeOfTransport(Value : Byte); Override;
    Function  GetTimeStamp : cuStr6; Override;
    Procedure SetTimeStamp(Value : cuStr6); Override;

    // v5.50 26/02/03
    Function  GetStateDeliveryMode : Byte; Override;
    Procedure SetStateDeliveryMode(Value : Byte); Override;
    Function  GetHeadOffice : Byte; Override;
    Procedure SetHeadOffice(Value : Byte); Override;

    // v6.9 ABSEXCH-11706 - TAbsCustomer3
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

    //v7.0.x ABSEXCH-14598 - TAbsCustomer4
    function GetBankAccountCode: cuStr35; Override;
    procedure SetBankAccountCode(const Value: cuStr35); Override;
    function GetMandateDate: cuStr8; Override;
    procedure SetMandateDate(const Value: cuStr8); Override;
    function GetMandateID: cuStr35; Override;
    procedure SetMandateID(const Value: cuStr35); Override;
    function GetBankSortCode: cuStr11; Override;
    procedure SetBankSortCode(const Value: cuStr11); Override;

    // MH 30/09/2013 MRD Branch for v7.0.7: Added new fields for Delivery Postcode
    Function GetDeliveryPostCode : cuStr20; Override;
    Procedure SetDeliveryPostCode (value : cuStr20); Override;

    // MH 30/09/2013 MRD Branch for v7.0.8: Added new fields for Consumer Ledger and Auto-Receipt
    Function GetSubType : Char; Override;
    Function GetLongACCode : custr30; Override;
    Procedure SetLongACCode(Value : custr30); Override;

    // TAbsCustomer7
    // MH 06/05/2015 v7.0.14: Added PPD field
    Function GetPPDMode : TCustomerPPDMode; Override;
    Procedure SetPPDMode(Value : TCustomerPPDMode); Override;

    // MH 22/09/2014 Order Payments - TAbsCustomer8
    Function GetAllowOrderPayments : Boolean; Override;
    Procedure SetAllowOrderPayments (Value : Boolean); Override;
    Function GetOrderPaymentsGLCode : LongInt; Override;
    Procedure SetOrderPaymentsGLCode (Value : LongInt); Override;
    // MH 26/11/2014 ABSEXCH-15836: Added Country Codes
    Function GetCountry : cuStr2; Override;
    Procedure SetCountry (Value : cuStr2); Override;
    Function GetDeliveryCountry : cuStr2; Override;
    Procedure SetDeliveryCountry (Value : cuStr2); Override;

    // MH 20/01/2016 Exch2016R1 ABSEXCH-17114: Customisation mods for Intrastat changes - TAbsCustomer9
    Function GetDefaultToQR : Boolean; Override;
    Procedure SetDefaultToQR (Value : Boolean); Override;

    //RB 21/11/2017 2018-R1 ABSEXCH-19390: GDPR (POST 19346) - 8.3.1.1.1 - DLL + COM Customisation Support
    Function GetAnonymisationStatus : TCustomerAnonymisationStatus; Override;
    Procedure SetAnonymisationStatus(aValue: TCustomerAnonymisationStatus); Override;
    Function GetAnonymisedDate : cuStr8; Override;
    Procedure SetAnonymisedDate(aValue: cuStr8); Override;
    Function GetAnonymisedTime : cuStr6; Override;
    Procedure SetAnonymisedTime(aValue: cuStr6); Override;
    
  Public
    Constructor Create (      hEntSys  : TEnterpriseSystem;
                        Const Customer : Boolean);
    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const CustSupp         : CustRec);

    Function LinkToCust (Const TheCode : ShortString) : Boolean;
    Function LinkToDrCrGL : Boolean; OverRide;
  End; { TCustomer }

implementation

Uses CustWinU, EtStrU, BtKeys1U, BtrvU2, oGLCode, Crypto,
     // MH 26/11/2014 ABSEXCH-15836: Added Country Codes
     CountryCodes, CountryCodeUtils,
     //PR: 26/07/2013 SEPA changes
     EncryptionUtils;

Const
  idxUDef5  = 74;
  idxUDef6  = 75;
  idxUDef7  = 76;
  idxUDef8  = 77;
  idxUDef9  = 79;
  idxUDef10 = 80;

  // MH 22/09/2014 Order Payments - TAbsCustomer7: Also added missing constants
  idxMandateID = 81;
  idxMandateDate = 82;
  idxDeliveryPostCode = 83;

  idxSubType = 84;
  idxLongACCode = 85;

  idxPPDMode = 86;

  idxAllowOrderPayments = 87;
  idxOrderPaymentsGLCode = 88;

  // MH 26/11/2014 ISO Country Codes
  idxCountry = 89;
  idxDeliveryCountry = 90;

  // MH 20/01/2016 Exch2016R1 ABSEXCH-17114: Customisation mods for Intrastat changes
  idxDefaultToQR = 91;

  //RB 21/11/2017 2018-R1 ABSEXCH-19390: GDPR (POST 19346) - 8.3.1.1.1 - DLL + COM Customisation Support
  idxAnonymisationStatus = 92;
  idxAnonymisedDate = 93;
  idxAnonymisedTime = 94;

//=========================================================================

Constructor TCustomer.Create (      hEntSys  : TEnterpriseSystem;
                              Const Customer : Boolean);
Begin
  Inherited Create;

  EntSys := hEntSys;

  IsCust := Customer;
  RecAccess  := NotAvailable;


  RecChanged := False;

  FillChar (DataRec, SizeOf (DataRec), #0);
  FillChar (OrigRec, SizeOf (OrigRec), #0);

  If IsCust Then CustObjStr := 'Customer ' Else CustObjStr := 'Supplier ';
End;

Procedure TCustomer.Assign (Const WinId, HandlerId : LongInt;
                            Const CustSupp         : CustRec);
Const
  ReadOnlySet = [21,24];
Var
  I : SmallInt;
Begin
  { Set Security Access to Record }

  Case WinId of
    EnterpriseBase+MiscBase+1,
    EnterpriseBase+1000,               { Account Edit Record }
    EnterpriseBase+2000,
    EnterpriseBase+2050,
    EnterpriseBase+3000,               { Stock Record - Stock Code Exit }
    EnterpriseBase+3100,               { Stock Record - Stock Batch Entry }
    EnterpriseBase+4000,                { Transaction Line b4 Qty }
    EnterpriseBase+5000                { Job Record }
         :  RecAccess:=ReadOnly;

    else    RecAccess:=NotAvailable;

  End; { If }

  { Load fields from ExLocal }
  FillChar (DataRec, SizeOf (DataRec), #0);

  RecChanged := False;
  
  If (RecAccess <> NotAvailable) Then Begin
    { Check ExLocal has a the correct record loaded }
    If (CustSupp.CustSupp = TradeCode[IsCust]) Then Begin
      DataRec := CustSupp;
      
    End { If }
    Else
    Begin
      If (WinId+HandlerId<>102003) and (WinId+HandlerId<>104051) then {* In this mode account code gets reset by Transaction each time *}
        RecAccess := NotAvailable;
    end;  
  End; { If }
  OrigRec := DataRec;

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
      101000001,
      101000005,
      101000036,
      101000046
         { Account Record/ Area Code Validation}
           :   Begin
                 PropAccess[3]:=paReadWrite;
               end;

      101000002   { Account Record Exit }
           :   Begin
                 PropAccess[39]:=paReadWrite;  {UD1}
                 PropAccess[40]:=paReadWrite;  {UD2}
                 PropAccess[48]:=paReadWrite;  {UD3}
                 PropAccess[49]:=paReadWrite;  {UD4}
                 //GS 08/11/2011 ABSEXCH-12107: Expanded for the new UDFs
                 PropAccess[idxUDef5]:=paReadWrite;  {UD5}
                 PropAccess[idxUDef6]:=paReadWrite;  {UD6}
                 PropAccess[idxUDef7]:=paReadWrite;  {UD7}
                 PropAccess[idxUDef8]:=paReadWrite;  {UD8}
                 PropAccess[idxUDef9]:=paReadWrite;  {UD9}
                 PropAccess[idxUDef10]:=paReadWrite;  {UD10}
                 PropAccess[03]:=paReadWrite;  {Area}
                 PropAccess[04]:=paReadWrite;  {Type}


                 FuncAccess[2]:=pfEnabled;     { Link To acDrCrGL }
               end;

      101000003   { After account store }
           :   Begin

               end;

      101000004   { After account Delete}
           :   Begin

               end;

      101000031,
      101000041   { UD1 Validation}
           :   Begin
                 PropAccess[39]:=paReadWrite;
               end;

      101000032,
      101000042   { UD2 Validation}
           :   Begin
                 PropAccess[40]:=paReadWrite;
               end;

      101000033,
      101000043   { UD3 Validation}
           :   Begin
                 PropAccess[48]:=paReadWrite;
               end;

      101000034,
      101000044   { UD4 Validation}
           :   Begin
                 PropAccess[49]:=paReadWrite;
               end;
      //GS 24/10/2011 ABSEXCH-11706: add permission modifiers for the customer / supplier UDEFs
      101000211,
      101000231
          :   Begin
                 PropAccess[idxUDef5]:=paReadWrite;
               end;
      101000212,
      101000232
          :   Begin
                 PropAccess[idxUDef6]:=paReadWrite;
               end;
      101000213,
      101000233
          :   Begin
                 PropAccess[idxUDef7]:=paReadWrite;
               end;
      101000214,
      101000234
          :   Begin
                 PropAccess[idxUDef8]:=paReadWrite;
               end;
      101000215,
      101000235
          :   Begin
                 PropAccess[idxUDef9]:=paReadWrite;
               end;
      101000216,
      101000236
          :   Begin
                 PropAccess[idxUDef10]:=paReadWrite;
               end;
      101000035,
      101000045   { Type Validation}
           :   Begin
                 PropAccess[04]:=paReadWrite;
               end;

      101000105,
      101000106   { Exit of Postcode }
           :   Begin
                 PropAccess[02]:=paReadWrite; {Company name}
                 PropAccess[07]:=paReadWrite; {Address array}
                 PropAccess[09]:=paReadWrite; {Del Address array}
                 PropAccess[11]:=paReadWrite; {Phone}
                 PropAccess[12]:=paReadWrite; {Fax}
                 PropAccess[35]:=paReadWrite; {Phone 2}
                 PropAccess[47]:=paReadWrite; {PostCode}
                 PropAccess[39]:=paReadWrite;  {UD1}
                 PropAccess[40]:=paReadWrite;  {UD2}
                 PropAccess[48]:=paReadWrite;  {UD3}
                 PropAccess[49]:=paReadWrite;  {UD4}
                 //GS 08/11/2011 Expanded for the new UDFs
                 PropAccess[idxUDef5]:=paReadWrite;  {UD5}
                 PropAccess[idxUDef6]:=paReadWrite;  {UD6}
                 PropAccess[idxUDef7]:=paReadWrite;  {UD7}
                 PropAccess[idxUDef8]:=paReadWrite;  {UD8}
                 PropAccess[idxUDef9]:=paReadWrite;  {UD9}
                 PropAccess[idxUDef10]:=paReadWrite;  {UD10}
                 PropAccess[50]:=paReadWrite;  {email}
                 PropAccess[03]:=paReadWrite;  {Area}
                 PropAccess[04]:=paReadWrite;  {Type}

                 // MH 30/09/2013 MRD Branch for v7.0.7: Added new fields for Delivery Postcode
                 PropAccess[83]:=paReadWrite;  // Del Address PostCode

                 // MH 26/11/2014 ISO Country Codes
                 PropAccess[idxCountry]:=paReadWrite;
                 PropAccess[idxDeliveryCountry]:=paReadWrite;
               end;

      101000100   { TS Account code exit via accode}
           :   Begin
                 //PropAccess[01]:=paReadWrite;  This disabled as account code for telesale now set by retstr
               end;

      101000107,
      101000108
         { Acount code}
           :   Begin
                 PropAccess[01]:=paReadWrite;
               end;

      101000109
         { Set Delivery Address}
           :   Begin
                 PropAccess[09]:=paReadWrite; {Del Address}

                 // MH 30/09/2013 MRD Branch for v7.0.7: Added new fields for Delivery Postcode
                 PropAccess[83]:=paReadWrite;  // Del Address PostCode

                 // MH 26/11/2014 ISO Country Codes
                 PropAccess[idxDeliveryCountry]:=paReadWrite;
               end;

      //RB 21/11/2017 2018-R1 ABSEXCH-19390: GDPR (POST 19346) - 8.3.1.1.1 - DLL + COM Customisation Support
      101000202
           :  Begin
                PropAccess[idxAnonymisationStatus] := paReadOnly;
              end;
              
      102000003   { Transaction - LinkToCust}
           :   Begin
                 FuncAccess[1] := pfEnabled; { Link To Cust }

               End;

      104000051   { Revalaution G/L Subs - LinkToDRCrGL}
           :   Begin
                 FuncAccess[2] := pfEnabled; { Link To Cr/DR Ctrl Account }
                 PropAccess[37]:=paReadWrite;

               End;
      190001001
           : ;

    End; { Case }
  End; { If }
End;

Function TCustomer.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

Function TCustomer.GetRecChanged : Boolean;
Begin
  Result := RecChanged;
End;

Function TCustomer.GetCustCode : cuStr6;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CustCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Code');
  End; { Else }
End;

Procedure TCustomer.SetCustCode(Value : cuStr6);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[1] = paReadWrite) Then Begin
    TmpStr := FullCustCode(Value);
    If (DataRec.CustCode <> TmpStr) Then Begin
      { Check its not blank, and its either the original value or it doesn't exist }
      If (Trim(TmpStr) <> '') And
         ((TmpStr = OrigRec.CustCode) Or (Not EntSys.CheckForRec(TmpStr,CustF,CustCodeK))) Then Begin
        DataRec.CustCode := TmpStr;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CustObjStr + 'Code');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Code');
End;

Function TCustomer.GetCompany : cuStr45;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Company
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Company');
  End; { Else }
End;

Procedure TCustomer.SetCompany(Value : cuStr45);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[2] = paReadWrite) Then Begin
    If (DataRec.Company <> Value) Then Begin
      DataRec.Company := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Company');
End;

Function TCustomer.GetAreaCode : cuStr4;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.AreaCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Area');
  End; { Else }
End;

Procedure TCustomer.SetAreaCode(Value : cuStr4);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[3] = paReadWrite) Then Begin
    If (DataRec.AreaCode <> Value) Then Begin
      DataRec.AreaCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Area');
End;

Function TCustomer.GetRepCode : cuStr4;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RepCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Account Type');
  End; { Else }
End;

Procedure TCustomer.SetRepCode(Value : cuStr4);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[4] = paReadWrite) Then Begin
    If (DataRec.RepCode <> Value) Then Begin
      DataRec.RepCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Account Type');
End;

Function TCustomer.GetRemitCode : cuStr6;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RemitCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'StatementTo');
  End; { Else }
End;

Procedure TCustomer.SetRemitCode(Value : cuStr6);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[5] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), CustKeyLen);
    If (DataRec.RemitCode <> TmpStr) Then Begin
      { Check its not set, or set to valid customer/supplier }
      If (TmpStr <> DataRec.CustCode) And
         ((Trim(TmpStr) = '') Or EntSys.CustExists(TmpStr, [DataRec.CustSupp])) Then Begin
        DataRec.RemitCode := TmpStr;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CustObjStr + 'StatementTo');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'StatementTo');
End;

Function TCustomer.GetVATRegNo : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.VATRegNo
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'VATRegNo');
  End; { Else }
End;

Procedure TCustomer.SetVATRegNo(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[6] = paReadWrite) Then Begin
    If (DataRec.VATRegNo <> Value) Then Begin
      DataRec.VATRegNo := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'VATRegNo');
End;

Function TCustomer.GetAddr (Index : cuAddrIndex) : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Addr[Index]
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Address');
  End; { Else }
End;

Procedure TCustomer.SetAddr(Index : cuAddrIndex; Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[7] = paReadWrite) Then Begin
    If (DataRec.Addr[Index] <> Value) Then Begin
      DataRec.Addr[Index] := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Address');
End;

Function TCustomer.GetDespAddr : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DespAddr
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'DelAddr');
  End; { Else }
End;

Procedure TCustomer.SetDespAddr(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[8] = paReadWrite) Then Begin
    If (DataRec.DespAddr <> Value) Then Begin
      DataRec.DespAddr := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'DelAddr');
End;

Function TCustomer.GetDAddr (Index : cuAddrIndex) : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DAddr[Index]
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'DelAddress');
  End; { Else }
End;

Procedure TCustomer.SetDAddr(Index : cuAddrIndex; Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[9] = paReadWrite) Then Begin
    If (DataRec.DAddr[Index] <> Value) Then Begin
      DataRec.DAddr[Index] := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'DelAddress');
End;

Function TCustomer.GetContact : cuStr25;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Contact
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Contact');
  End; { Else }
End;

Procedure TCustomer.SetContact(Value : cuStr25);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[10] = paReadWrite) Then Begin
    If (DataRec.Contact <> Value) Then Begin
      DataRec.Contact := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Contact');
End;

Function TCustomer.GetPhone : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Phone
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Phone');
  End; { Else }
End;

Procedure TCustomer.SetPhone(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[11] = paReadWrite) Then Begin
    If (DataRec.Phone <> Value) Then Begin
      DataRec.Phone := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Phone');
End;

Function TCustomer.GetFax : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Fax
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Fax');
  End; { Else }
End;

Procedure TCustomer.SetFax(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[12] = paReadWrite) Then Begin
    If (DataRec.Fax <> Value) Then Begin
      DataRec.Fax := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Fax');
End;

Function TCustomer.GetRefNo : cuStr10;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.RefNo
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'TheirAcc');
  End; { Else }
End;

Procedure TCustomer.SetRefNo(Value : cuStr10);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[13] = paReadWrite) Then Begin
    If (DataRec.RefNo <> Value) Then Begin
      DataRec.RefNo := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'TheirAcc');
End;

Function TCustomer.GetTradTerm : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.TradTerm
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'OwnTradTerm');
  End; { Else }
End;

Procedure TCustomer.SetTradTerm(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[14] = paReadWrite) Then Begin
    If (DataRec.TradTerm <> Value) Then Begin
      DataRec.TradTerm := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'OwnTradTerm');
End;

Function TCustomer.GetSTerms (Index : cuTermsIndex) : cuStr80;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.STerms[Index]
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'TradeTerms');
  End; { Else }
End;

Procedure TCustomer.SetSTerms(Index : cuTermsIndex; Value : cuStr80);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[15] = paReadWrite) Then Begin
    If (DataRec.STerms[Index] <> Value) Then Begin
      DataRec.STerms[Index] := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'TradeTerms');
End;

Function TCustomer.GetCurrency : cuCurrencyType;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Currency
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Currency');
  End; { Else }
End;

Procedure TCustomer.SetCurrency(Value : cuCurrencyType);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[16] = paReadWrite) Then Begin
    If (DataRec.Currency <> Value) Then Begin
      If EntSys.ValidCCy (Value) Then Begin
        DataRec.Currency := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CustObjStr + 'Currency');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Currency');
End;

Function TCustomer.GetVATCode : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.VATCode
  Else Begin
    Result := 'S';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'VATCode');
  End; { Else }
End;

Procedure TCustomer.SetVATCode(Value : Char);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[17] = paReadWrite) Then Begin
    If (DataRec.VATCode <> Value) Then Begin
      If (Value In VATSet) Then Begin
        DataRec.VATCode := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CustObjStr + 'VATCode');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'VATCode');
End;

Function TCustomer.GetPayTerms : SmallInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PayTerms
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'PayTerms');
  End; { Else }
End;

Procedure TCustomer.SetPayTerms(Value : SmallInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[18] = paReadWrite) Then Begin
    If (DataRec.PayTerms <> Value) Then Begin
      DataRec.PayTerms := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'PayTerms');
End;

Function TCustomer.GetCreditLimit : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CreditLimit
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'CreditLimit');
  End; { Else }
End;

Procedure TCustomer.SetCreditLimit(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[19] = paReadWrite) Then Begin
    If (DataRec.CreditLimit <> Value) Then Begin
      DataRec.CreditLimit := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'CreditLimit');
End;

Function TCustomer.GetDiscount : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Discount
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Discount');
  End; { Else }
End;

Procedure TCustomer.SetDiscount(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[20] = paReadWrite) Then Begin
    If (DataRec.Discount <> Value) Then Begin
      DataRec.Discount := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Discount');
End;

Function TCustomer.GetCreditStatus : SmallInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CreditStatus
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'CreditStatus');
  End; { Else }
End;

Procedure TCustomer.SetCreditStatus(Value : SmallInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[21] = paReadWrite) Then Begin
    If (DataRec.CreditStatus <> Value) Then Begin
      DataRec.CreditStatus := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'CreditStatus');
End;

Function TCustomer.GetCustCC : cuStr3;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CustCC
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'CostCentre');
  End; { Else }
End;

Procedure TCustomer.SetCustCC(Value : cuStr3);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[22] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), CCKeyLen);
    If (DataRec.CustCC <> TmpStr) Then Begin
      If (Trim(TmpStr) = '') Or EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[True],TmpStr),PWrdF,PWK) Then Begin
        DataRec.CustCC := TmpStr;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CustObjStr + 'CostCentre');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'CostCentre');
End;

Function TCustomer.GetCDiscCh : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CDiscCh
  Else Begin
    Result := 'A';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'DiscountBand');
  End; { Else }
End;

Procedure TCustomer.SetCDiscCh(Value : Char);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[23] = paReadWrite) Then Begin
    If (DataRec.CDiscCh <> Value) Then Begin
      If (Value In [#0, ' ', 'A'..'H', PcntChr]) Then Begin
        DataRec.CDiscCh := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CustObjStr + 'DiscountBand');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'DiscountBand');
End;

Function TCustomer.GetBalance : Real;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Balance
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Balance');
  End; { Else }
End;

Procedure TCustomer.SetBalance(Value : Real);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[24] = paReadWrite) Then Begin
    If (DataRec.Balance <> Value) Then Begin
      DataRec.Balance := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Balance');
End;

Function TCustomer.GetCustDep : cuStr3;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CustDep
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Department');
  End; { Else }
End;

Procedure TCustomer.SetCustDep(Value : cuStr3);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[25] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), CCKeyLen);
    If (DataRec.CustDep <> TmpStr) Then Begin
      If (Trim(TmpStr) = '') Or EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[False],TmpStr),PWrdF,PWK) Then Begin
        DataRec.CustDep := TmpStr;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CustObjStr + 'Department');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Department');
End;

Function TCustomer.GetEECMember : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.EECMember
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'ECMember');
  End; { Else }
End;

Procedure TCustomer.SetEECMember(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[26] = paReadWrite) Then Begin
    If (DataRec.EECMember <> Value) Then Begin
      DataRec.EECMember := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'ECMember');
End;

Function TCustomer.GetIncStat : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.IncStat
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Statement');
  End; { Else }
End;

Procedure TCustomer.SetIncStat(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[27] = paReadWrite) Then Begin
    If (DataRec.IncStat <> Value) Then Begin
      DataRec.IncStat := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Statement');
End;

Function TCustomer.GetDefNomCode : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DefNomCode
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'SalesGL');
  End; { Else }
End;

Procedure TCustomer.SetDefNomCode(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[28] = paReadWrite) Then Begin
    If (DataRec.DefNomCode <> Value) Then Begin
      If EntSys.ValidNomCode (Value, 1) Then Begin
        DataRec.DefNomCode := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CustObjStr + 'SalesGL');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'SalesGL');
End;

Function TCustomer.GetDefMLocStk : cuStr3;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DefMLocStk
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Location');
  End; { Else }
End;

Procedure TCustomer.SetDefMLocStk(Value : cuStr3);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[29] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), MLocKeyLen);
    If (DataRec.DefMLocStk <> TmpStr) Then Begin
      If (Trim(TmpStr) = '') Or EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[True],TmpStr),MLocF,MLK) Then Begin
        DataRec.DefMLocStk := TmpStr;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CustObjStr + 'Location');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Location');
End;

Function TCustomer.GetAccStatus : cuAccStatusType;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.AccStatus
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'AccStatus');
  End; { Else }
End;

Procedure TCustomer.SetAccStatus(Value : cuAccStatusType);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[30] = paReadWrite) Then Begin
    If (DataRec.AccStatus <> Value) Then Begin
      If (Value In [0..3]) Then Begin
        DataRec.AccStatus := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CustObjStr + 'AccStatus');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'AccStatus');
End;

Function TCustomer.GetPayType : Char;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PayType
  Else Begin
    Result := 'C';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'PayType');
  End; { Else }
End;

Procedure TCustomer.SetPayType(Value : Char);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[31] = paReadWrite) Then Begin
    If (DataRec.PayType <> Value) Then Begin
      If (Value In ['B','C']) Then Begin
        DataRec.PayType := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CustObjStr + 'PayType');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'PayType');
End;

Function TCustomer.GetBankSort : cuStr20;
Begin
  //PR: 09/09/2013 ABSEXCH-14598 Changed to use new SEPA code field
  If (RecAccess <> NotAvailable) Then
    Result := DecryptBankSortCode(DataRec.acBankSortCode)
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'BankSort');
  End; { Else }
End;

Procedure TCustomer.SetBankSort(Value : cuStr20);
Begin
  //PR: 09/09/2013 ABSEXCH-14598 Changed to use new SEPA code field
  If (RecAccess <> NotAvailable) And (PropAccess[32] = paReadWrite) Then Begin
    If (DataRec.acBankSortCode <> EncryptBankSortCode(Value)) Then Begin
      DataRec.acBankSortCode := EncryptBankSortCode(Value);
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'BankSort');
End;

Function TCustomer.GetBankAcc : cuStr15;
Begin
  //PR: 09/09/2013 ABSEXCH-14598 Changed to use new SEPA code field
  If (RecAccess <> NotAvailable) Then
    Result := DecryptBankAccountCode(DataRec.acBankAccountCode)
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'BankAcc');
  End; { Else }
End;

Procedure TCustomer.SetBankAcc(Value : cuStr15);
Begin
  //PR: 09/09/2013 ABSEXCH-14598 Changed to use new SEPA code field
  If (RecAccess <> NotAvailable) And (PropAccess[33] = paReadWrite) Then Begin
    If (DataRec.acBankAccountCode <> EncryptBankAccountCode(Value)) Then Begin
      DataRec.acBankAccountCode := EncryptBankAccountCode(Value);
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'BankAcc');
End;

Function TCustomer.GetBankRef : cuStr28;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.BankRef
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'BankRef');
  End; { Else }
End;

Procedure TCustomer.SetBankRef(Value : cuStr28);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[34] = paReadWrite) Then Begin
    If (DataRec.BankRef <> Value) Then Begin
      DataRec.BankRef := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'BankRef');
End;

Function TCustomer.GetPhone2 : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Phone2
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Phone2');
  End; { Else }
End;

Procedure TCustomer.SetPhone2(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[35] = paReadWrite) Then Begin
    If (DataRec.Phone2 <> Value) Then Begin
      DataRec.Phone2 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Phone2');
End;

Function TCustomer.GetDefCOSNom : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DefCOSNom
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'COSGL');
  End; { Else }
End;

Procedure TCustomer.SetDefCOSNom(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[36] = paReadWrite) Then Begin
    If (DataRec.DefCOSNom <> Value) Then Begin
      If EntSys.ValidNomCode(Value, 1) Then Begin
        DataRec.DefCOSNom := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CustObjStr + 'COSGL');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'COSGL');
End;

Function TCustomer.GetDefCtrlNom : LongInt;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DefCtrlNom
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'DrCrGL');
  End; { Else }
End;

Procedure TCustomer.SetDefCtrlNom(Value : LongInt);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[37] = paReadWrite) Then Begin
    If (DataRec.DefCtrlNom <> Value) Then Begin
      If EntSys.ValidNomCode(Value, 3) Then Begin
        DataRec.DefCtrlNom := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CustObjStr + 'DrCrGL');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'DrCrGL');
End;

Function TCustomer.GetLastUsed : cuLongDate;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LastUsed
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'LastUsed');
  End; { Else }
End;

Procedure TCustomer.SetLastUsed(Value : cuLongDate);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[38] = paReadWrite) Then Begin
    If (DataRec.LastUsed <> Value) Then Begin
      If EntSys.ValidDate (Value) Then Begin
        DataRec.LastUsed := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CustObjStr + 'LastUsed');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'LastUsed');
End;

Function TCustomer.GetUserDef1 : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef1
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'UserDef1');
  End; { Else }
End;

Procedure TCustomer.SetUserDef1(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[39] = paReadWrite) Then Begin
    If (DataRec.UserDef1 <> Value) Then Begin
      DataRec.UserDef1 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'UserDef1');
End;

Function TCustomer.GetUserDef2 : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef2
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'UserDef2');
  End; { Else }
End;

Procedure TCustomer.SetUserDef2(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[40] = paReadWrite) Then Begin
    If (DataRec.UserDef2 <> Value) Then Begin
      DataRec.UserDef2 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'UserDef2');
End;

Function TCustomer.GetSOPInvCode : cuStr6;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SOPInvCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'InvoiceTo');
  End; { Else }
End;

Procedure TCustomer.SetSOPInvCode(Value : cuStr6);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[41] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), CustKeyLen);
    If (DataRec.SOPInvCode <> TmpStr) Then Begin
      If (TmpStr <> DataRec.CustCode) And
         ((Trim(TmpStr) = '') Or EntSys.CustExists(TmpStr, [DataRec.CustSupp])) Then Begin
        DataRec.SOPInvCode := TmpStr;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CustObjStr + 'InvoiceTo');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'InvoiceTo');
End;

Function TCustomer.GetSOPAutoWOff : Boolean;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SOPAutoWOff
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'SOPAutoWOff');
  End; { Else }
End;

Procedure TCustomer.SetSOPAutoWOff(Value : Boolean);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[42] = paReadWrite) Then Begin
    If (DataRec.SOPAutoWOff <> Value) Then Begin
      DataRec.SOPAutoWOff := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'SOPAutoWOff');
End;

Function TCustomer.GetFDefPageNo : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.FDefPageNo
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'FormSet');
  End; { Else }
End;

Procedure TCustomer.SetFDefPageNo(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[43] = paReadWrite) Then Begin
    If (DataRec.FDefPageNo <> Value) Then Begin
      If (Value In [0..99]) Then Begin
        DataRec.FDefPageNo := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CustObjStr + 'FormSet');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'FormSet');
End;

Function TCustomer.GetBOrdVal : Double;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.BOrdVal
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'BookOrdVal');
  End; { Else }
End;

Procedure TCustomer.SetBOrdVal(Value : Double);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[44] = paReadWrite) Then Begin
    If (DataRec.BOrdVal <> Value) Then Begin
      DataRec.BOrdVal := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'BookOrdVal');
End;

Function TCustomer.GetDirDeb : Byte;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DirDeb
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'DirDebMode');
  End; { Else }
End;

Procedure TCustomer.SetDirDeb(Value : Byte);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[45] = paReadWrite) Then Begin
    If (DataRec.DirDeb <> Value) Then Begin
      If (Value In [0..4]) Then Begin
        DataRec.DirDeb := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CustObjStr + 'DirDebMode');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'DirDebMode');
End;


Function TCustomer.LinkToCust (Const TheCode : ShortString) : Boolean;
Const
  FNum              = CustF;
  KeyPath : Integer = CustCodeK;
Var
  TmpStat, TmpKPath : Integer;
  TmpRecAddr        : LongInt;
  KeyS              : Str255;
Begin
  Result := False;

  { Check we're allowed to reload with different Cust records }
  If (FuncAccess[1] = pfEnabled) Then
    With EntSys, LocalBtr^ Do
      { Check its non blank search }
      If (TheCode<>'') Then Begin
        { Save current details }
        LastCust := LCust;
        TmpKPath := GetPosKey;
        TmpStat  := LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

        KeyS := FullCustCode (TheCode);
        LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);
        Result := (LStatus = 0);

        If Result Then Begin
          { Reload Cust object with new record }
          Assign (WinId, HandlerId, LCust);
        End; { If }

        { Restore file position }
        TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);
        LCust := LastCust;
      End; { If }
End;


Function TCustomer.LinkToDrCrGL : Boolean;
Var
  ThisAccount  :  TABSCustomer;
Begin
  Result := False;

  If (RecAccess <> NotAvailable) And (FuncAccess[2] = pfEnabled) Then
    With EntSys Do Begin
      If (acDrCrGL <> 0) Then Begin
        Result := TGLCode(GLCode).LinkToNom(acDrCrGL);
      End; { If }
    End; { With }
End;

Function  TCustomer.GetAltCode : cuStr20;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CustCode2
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Alt Code');
  End; { Else }
End;

Procedure TCustomer.SetAltCode(Value : cuStr20);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[46] = paReadWrite) Then Begin
    If (DataRec.CustCode2 <> Value) Then Begin
      DataRec.CustCode2 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Alt Code');
End;

Function  TCustomer.GetPostCode : cuStr20;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PostCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Postcode');
  End; { Else }
End;

Procedure TCustomer.SetPostCode(Value : cuStr20);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[47] = paReadWrite) Then Begin
    If (DataRec.PostCode <> Value) Then Begin
      DataRec.PostCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Postcode');
End;

Function  TCustomer.GetUserDef3 : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef3
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'UserDef3');
  End; { Else }
End;

Procedure TCustomer.SetUserDef3(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[48] = paReadWrite) Then Begin
    If (DataRec.UserDef3 <> Value) Then Begin
      DataRec.UserDef3 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'UserDef3');
End;

Function  TCustomer.GetUserDef4 : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef4
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'UserDef4');
  End; { Else }
End;

Procedure TCustomer.SetUserDef4(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[49] = paReadWrite) Then Begin
    If (DataRec.UserDef4 <> Value) Then Begin
      DataRec.UserDef4 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'UserDef4');
End;

Function  TCustomer.GetEmailAddr : cuStr100;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.EmailAddr
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Email Addr');
  End; { Else }
End;

Procedure TCustomer.SetEmailAddr(Value : cuStr100);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[50] = paReadWrite) Then Begin
    If (DataRec.EmailAddr <> Value) Then Begin
      DataRec.EmailAddr := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Email Addr');
End;

Function  TCustomer.GetCCStart : cuLongDate;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CCDSDate
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Credit Card Start');
  End; { Else }
End;

Procedure TCustomer.SetCCStart(Value : cuLongDate);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[51] = paReadWrite) Then Begin
    If (DataRec.CCDSDate <> Value) Then Begin
      DataRec.CCDSDate := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Credit Card Start');
End;

Function  TCustomer.GetCCEnd : cuLongDate;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CCDEDate
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Credit Card End');
  End; { Else }
End;

Procedure TCustomer.SetCCEnd(Value : cuLongDate);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[52] = paReadWrite) Then Begin
    If (DataRec.CCDEDate <> Value) Then Begin
      DataRec.CCDEDate := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Credit Card End');
End;

Function  TCustomer.GetCCName : cuStr50;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CCDName
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Credit Card Name');
  End; { Else }
End;

Procedure TCustomer.SetCCName(Value : cuStr50);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[53] = paReadWrite) Then Begin
    If (DataRec.CCDName <> Value) Then Begin
      DataRec.CCDName := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Credit Card Name');
End;

Function  TCustomer.GetCCNumber : cuStr30;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CCDCardNo
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Credit Card Number');
  End; { Else }
End;

Procedure TCustomer.SetCCNumber(Value : cuStr30);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[54] = paReadWrite) Then Begin
    If (DataRec.CCDCardNo <> Value) Then Begin
      DataRec.CCDCardNo := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Credit Card Number');
End;

Function  TCustomer.GetCCSwitch : cuStr4;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CCDSARef
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Credit Card Switch Number');
  End; { Else }
End;

Procedure TCustomer.SetCCSwitch(Value : cuStr4);
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[55] = paReadWrite) Then Begin
    If (DataRec.CCDSARef <> Value) Then Begin
      DataRec.CCDSARef := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Credit Card Switch Number');
End;

(*
Function TCustomer.GetTestField : cuStr4;
Begin { GetTestField }
  Result := 'Te01';
End; { GetTestField }

Procedure TCustomer.SetTestField (Value : cuStr4);
Begin { SetTestField }
  {  }
End; { SetTestField }
*)

//------------------------------------------------

function TCustomer.GetDefTagNo: Byte;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DefTagNo
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Default Tag Number');
  End; { Else }
end;

procedure TCustomer.SetDefTagNo(Value: Byte);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[56] = paReadWrite) Then Begin
    If (Value <= 99) Then Begin
      If (DataRec.DefTagNo <> Value) Then Begin
        DataRec.DefTagNo := Value;
        RecChanged := True;
      End; { If }
    End { If (Value >= 0) }
    Else
      EntSys.CustomException (CustObjStr + 'Default Tag Number');
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Default Tag Number');
end;

//------------------------------------------------

function TCustomer.GetDefSettleDisc: Double;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DefSetDisc
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Default Settlement Discount');
  End; { Else }
end;

procedure TCustomer.SetDefSettleDisc(Value: Double);
begin
  (*
  If (RecAccess <> NotAvailable) And (PropAccess[57] = paReadWrite) Then Begin
    **** Validation Here ****
      If (DataRec.DefSetDisc <> Value) Then Begin
        DataRec.DefSetDisc := Value;
        RecChanged := True;
      End; { If }
    End { If (Value >= 0) }
    Else
      EntSys.CustomException (CustObjStr + 'Default Settlement Discount');
  End { If }
  Else
  *)
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Default Settlement Discount');
end;

//------------------------------------------------

function TCustomer.GetDefSettleDays: SmallInt;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.DefSetDDays
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Default Settlement Days');
  End; { Else }
end;

procedure TCustomer.SetDefSettleDays(Value: SmallInt);
begin
  (*
  If (RecAccess <> NotAvailable) And (PropAccess[58] = paReadWrite) Then Begin
    **** Validation Here ****
      If (DataRec.DefSetDDays <> Value) Then Begin
        DataRec.DefSetDDays := Value;
        RecChanged := True;
      End; { If }
    End { If (Value >= 0) }
    Else
      EntSys.CustomException (CustObjStr + 'Default Settlement Days');
  End { If }
  Else
  *)
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Default Settlement Days');
end;

//------------------------------------------------

function TCustomer.GetDocDeliveryMode: Byte;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.InvDMode
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Document Delivery Mode');
  End; { Else }
end;

procedure TCustomer.SetDocDeliveryMode(Value: Byte);
begin
  (*
  If (RecAccess <> NotAvailable) And (PropAccess[59] = paReadWrite) Then Begin
    **** Validation Here ****
      If (DataRec.InvDMode <> Value) Then Begin
        DataRec.InvDMode := Value;
        RecChanged := True;
      End; { If }
    End { If (Value >= 0) }
    Else
      EntSys.CustomException (CustObjStr + 'Document Delivery Mode');
  End { If }
  Else
  *)
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Document Delivery Mode');
end;

//------------------------------------------------

function TCustomer.GetEbusPword: cuStr20;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DecodeKey(23130, DataRec.ebusPwrd)
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'E-Business Password');
  End; { Else }
end;

procedure TCustomer.SetEbusPword(Value: cuStr20);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[60] = paReadWrite) Then Begin
    DataRec.ebusPwrd := EncodeKey(23130, Value);
    RecChanged := True;
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'E-Business Password');
end;

//------------------------------------------------

function TCustomer.GetUseForEbus: Byte;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.AllowWeb
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Use For E-Business');
  End; { Else }
end;

procedure TCustomer.SetUseForEbus(Value: Byte);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[61] = paReadWrite) Then Begin
    If (DataRec.AllowWeb <> Value) Then Begin
      DataRec.AllowWeb := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Use For E-Business');
end;

//------------------------------------------------

function TCustomer.GetWebLiveCatalog: cuStr20;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.WebLiveCat
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'WebLiveCatalog');
  End; { Else }
end;

procedure TCustomer.SetWebLiveCatalog(Value: cuStr20);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[62] = paReadWrite) Then Begin
    If (DataRec.WebLiveCat <> Value) Then Begin
      DataRec.WebLiveCat := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'WebLiveCatalog');
end;

//------------------------------------------------

function TCustomer.GetWebPrevCatalog: cuStr20;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.WebPrevCat
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'WebPrevCatalog');
  End; { Else }
end;

procedure TCustomer.SetWebPrevCatalog(Value: cuStr20);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[63] = paReadWrite) Then Begin
    If (DataRec.WebPrevCat <> Value) Then Begin
      DataRec.WebPrevCat := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'WebPrevCatalog');
end;

//------------------------------------------------

function TCustomer.GetInclusiveVATCode: Char;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CVATIncFlg
  Else Begin
    Result := ' ';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Inclusive VAT Code');
  End; { Else }
end;

procedure TCustomer.SetInclusiveVATCode(Value: Char);
begin
  (*
  If (RecAccess <> NotAvailable) And (PropAccess[64] = paReadWrite) Then Begin
    **** Validation Here ****
      If (DataRec.CVATIncFlg <> Value) Then Begin
        DataRec.CVATIncFlg := Value;
        RecChanged := True;
      End; { If }
    End { If (Value >= 0) }
    Else
      EntSys.CustomException (CustObjStr + 'Inclusive VAT Code');
  End { If }
  Else
  *)
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Inclusive VAT Code');
end;

//------------------------------------------------

function TCustomer.GetLastOperator: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LastOpo
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Last Operator');
  End; { Else }
end;

procedure TCustomer.SetLastOperator(Value: cuStr10);
begin
  (*
  If (RecAccess <> NotAvailable) And (PropAccess[65] = paReadWrite) Then Begin
    **** Validation Here ****
      If (DataRec.LastOpo <> Value) Then Begin
        DataRec.LastOpo := Value;
        RecChanged := True;
      End; { If }
    End { If (Value >= 0) }
    Else
      EntSys.CustomException (CustObjStr + 'Last Operator');
  End { If }
  Else
  *)
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Last Operator');
end;

//------------------------------------------------

function TCustomer.GetSendHTML: Boolean;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.EmlSndHTML
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Send HTML');
  End; { Else }
end;

procedure TCustomer.SetSendHTML(Value: Boolean);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[66] = paReadWrite) Then Begin
    If (DataRec.EmlSndHTML <> Value) Then Begin
      DataRec.EmlSndHTML := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Send HTML');
end;

//------------------------------------------------

function TCustomer.GetSendReader: Boolean;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.EmlSndRdr
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'Send Reader');
  End; { Else }
end;

procedure TCustomer.SetSendReader(Value: Boolean);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[67] = paReadWrite) Then Begin
    If (DataRec.EmlSndRdr <> Value) Then Begin
      DataRec.EmlSndRdr := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'Send Reader');
end;

//------------------------------------------------

function TCustomer.GetZIPAttachments: Byte;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.EmlZipAtc
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'ZIP Attachments');
  End; { Else }
end;

procedure TCustomer.SetZIPAttachments(Value: Byte);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[68] = paReadWrite) Then Begin
    If (DataRec.EmlZipAtc <> Value) Then Begin
      DataRec.EmlZipAtc := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'ZIP Attachments');
end;

//------------------------------------------------

function TCustomer.GetSSDDeliveryTerms: cuStr5;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SSDDelTerms
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'SSD Delivery Terms');
  End; { Else }
end;

procedure TCustomer.SetSSDDeliveryTerms(Value: cuStr5);
begin
  (*
  If (RecAccess <> NotAvailable) And (PropAccess[69] = paReadWrite) Then Begin
    **** Validation Here ****
      If (DataRec.SSDDelTerms <> Value) Then Begin
        DataRec.SSDDelTerms := Value;
        RecChanged := True;
      End; { If }
    End { If (Value >= 0) }
    Else
      EntSys.CustomException (CustObjStr + 'SSD Delivery Terms');
  End { If }
  Else
  *)
    EntSys.DataAccessErrDlg(False, CustObjStr + 'SSD Delivery Terms');
end;

//------------------------------------------------

function TCustomer.GetSSDModeOfTransport: Byte;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SSDModeTr
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'SSD Mode of Transport');
  End; { Else }
end;

procedure TCustomer.SetSSDModeOfTransport(Value: Byte);
begin
  (*
  If (RecAccess <> NotAvailable) And (PropAccess[70] = paReadWrite) Then Begin
    **** Validation Here ****
      If (DataRec.SSDModeTr <> Value) Then Begin
        DataRec.SSDModeTr := Value;
        RecChanged := True;
      End; { If }
    End { If (Value >= 0) }
    Else
      EntSys.CustomException (CustObjStr + 'SSD Mode of Transport');
  End { If }
  Else
  *)
    EntSys.DataAccessErrDlg(False, CustObjStr + 'SSD Mode of Transport');
end;

//------------------------------------------------

function TCustomer.GetTimeStamp: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.TimeChange
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'TimeStamp');
  End; { Else }
end;

procedure TCustomer.SetTimeStamp(Value: cuStr6);
begin
  (*  Presumably this will always be Read-Only - Write method added just in case
  If (RecAccess <> NotAvailable) And (PropAccess[71] = paReadWrite) Then Begin
    **** Validation Here ****
      If (DataRec.TimeChange <> Value) Then Begin
        DataRec.TimeChange := Value;
        RecChanged := True;
      End; { If }
    End { If (Value >= 0) }
    Else
      EntSys.CustomException (CustObjStr + 'TimeStamp');
  End { If }
  Else
  *)
    EntSys.DataAccessErrDlg(False, CustObjStr + 'TimeStamp');
end;

//------------------------------------------------

Function TCustomer.GetStateDeliveryMode : Byte;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StatDMode
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'TimeStamp');
  End; { Else }
end;

Procedure TCustomer.SetStateDeliveryMode(Value : Byte);
begin
  EntSys.NotImplException ('TAbsCustomer2.acStateDeliveryMode');
end;

//------------------------------

Function TCustomer.GetHeadOffice : Byte;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.SOPConsHO
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'HeadOffice');
  End; { Else }
end;

Procedure TCustomer.SetHeadOffice(Value : Byte);
begin
  EntSys.NotImplException ('TAbsCustomer2.acHeadOffice');
end;

//------------------------------

Function TCustomer.GetUserDef5 : cuStr30;
Begin // GetUserDef5
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef5
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'UserDef5');
  End; // Else
End; // GetUserDef5

Procedure TCustomer.SetUserDef5 (Value : cuStr30);
Begin // SetUserDef5
  If (RecAccess <> NotAvailable) And (PropAccess[idxUdef5] = paReadWrite) Then
  Begin
    If (DataRec.UserDef5 <> Value) Then Begin
      DataRec.UserDef5 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'UserDef5');
End; // SetUserDef5

//------------------------------

Function TCustomer.GetUserDef6 : cuStr30;
Begin // GetUserDef6
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef6
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'UserDef6');
  End; // Else
End; // GetUserDef6

Procedure TCustomer.SetUserDef6 (Value : cuStr30);
Begin // SetUserDef6
  If (RecAccess <> NotAvailable) And (PropAccess[idxUdef6] = paReadWrite) Then
  Begin
    If (DataRec.UserDef6 <> Value) Then
    Begin
      DataRec.UserDef6 := Value;
      RecChanged := True;
    End; // If (DataRec.UserDef6 <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[idxUdef6] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'UserDef6');
End; // SetUserDef6

//------------------------------

Function TCustomer.GetUserDef7 : cuStr30;
Begin // GetUserDef7
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef7
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'UserDef7');
  End; // Else
End; // GetUserDef7

Procedure TCustomer.SetUserDef7 (Value : cuStr30);
Begin // SetUserDef7
  If (RecAccess <> NotAvailable) And (PropAccess[idxUdef7] = paReadWrite) Then
  Begin
    If (DataRec.UserDef7 <> Value) Then
    Begin
      DataRec.UserDef7 := Value;
      RecChanged := True;
    End; // If (DataRec.UserDef7 <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[idxUdef7] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'UserDef7');
End; // SetUserDef7

//------------------------------

Function TCustomer.GetUserDef8 : cuStr30;
Begin // GetUserDef8
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef8
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'UserDef8');
  End; // Else
End; // GetUserDef8

Procedure TCustomer.SetUserDef8 (Value : cuStr30);
Begin // SetUserDef8
  If (RecAccess <> NotAvailable) And (PropAccess[idxUdef8] = paReadWrite) Then
  Begin
    If (DataRec.UserDef8 <> Value) Then
    Begin
      DataRec.UserDef8 := Value;
      RecChanged := True;
    End; // If (DataRec.UserDef8 <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[idxUdef8] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'UserDef8');
End; // SetUserDef8

//------------------------------

Function TCustomer.GetUserDef9 : cuStr30;
Begin // GetUserDef9
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef9
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'UserDef9');
  End; // Else
End; // GetUserDef9

Procedure TCustomer.SetUserDef9 (Value : cuStr30);
Begin // SetUserDef9
  If (RecAccess <> NotAvailable) And (PropAccess[idxUdef9] = paReadWrite) Then
  Begin
    If (DataRec.UserDef9 <> Value) Then
    Begin
      DataRec.UserDef9 := Value;
      RecChanged := True;
    End; // If (DataRec.UserDef9 <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[idxUdef9] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'UserDef9');
End; // SetUserDef9

//------------------------------

Function TCustomer.GetUserDef10 : cuStr30;
Begin // GetUserDef10
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UserDef10
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'UserDef10');
  End; // Else
End; // GetUserDef10

Procedure TCustomer.SetUserDef10 (Value : cuStr30);
Begin // SetUserDef10
  If (RecAccess <> NotAvailable) And (PropAccess[idxUdef10] = paReadWrite) Then
  Begin
    If (DataRec.UserDef10 <> Value) Then
    Begin
      DataRec.UserDef10 := Value;
      RecChanged := True;
    End; // If (DataRec.UserDef10 <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[idxUdef10] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'UserDef10');
End; // SetUserDef10

//------------------------------

function TCustomer.GetBankAccountCode: cuStr35;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DecryptBankAccountCode(DataRec.acBankAccountCode)
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'acBankAccountCode');
  End; { Else }
end;

function TCustomer.GetMandateDate: cuStr8;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.acMandateDate
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'acMandateDate');
  End; { Else }
end;

function TCustomer.GetMandateID: cuStr35;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DecryptBankMandateID(DataRec.acMandateID)
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'acMandateID');
  End; { Else }
end;

function TCustomer.GetBankSortCode: cuStr11;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DecryptBankSortCode(DataRec.acBankSortCode)
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'acBankSortCode');
  End; { Else }
end;

procedure TCustomer.SetBankSortCode(const Value: cuStr11);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[32] = paReadWrite) Then Begin
    If (DataRec.acBankSortCode <> Value) Then Begin
      DataRec.acBankSortCode := EncryptBankSortCode(Value);
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'acBankSortCode');
end;

procedure TCustomer.SetBankAccountCode(const Value: cuStr35);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[33] = paReadWrite) Then Begin
    If (DataRec.acBankAccountCode <> Value) Then Begin
      DataRec.acBankAccountCode := EncryptBankAccountCode(Value);
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'acBankAccountCode');
end;

procedure TCustomer.SetMandateID(const Value: cuStr35);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[81] = paReadWrite) Then Begin
    If (DataRec.acMandateID <> Value) Then Begin
      DataRec.acMandateID := EncryptBankMandateID(Value);
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'acMandateID');
end;

procedure TCustomer.SetMandateDate(const Value: cuStr8);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[82] = paReadWrite) Then Begin
    If (DataRec.acMandateDate <> Value) Then Begin
     DataRec.acMandateDate := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'acMandateDate');
end;

//-------------------------------------------------------------------------

// MH 30/09/2013 MRD Branch for v7.0.7: Added new fields for Delivery Postcode
Function TCustomer.GetDeliveryPostCode : cuStr20;
Begin // GetDeliveryPostCode
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.acDeliveryPostCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'acDeliveryPostCode');
  End; { Else }
End; // GetDeliveryPostCode

Procedure TCustomer.SetDeliveryPostCode (value : cuStr20);
Begin // SetDeliveryPostCode
  If (RecAccess <> NotAvailable) And (PropAccess[83] = paReadWrite) Then
  Begin
    If (DataRec.acDeliveryPostCode <> Value) Then
    Begin
      DataRec.acDeliveryPostCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'acDeliveryPostCode');
End; // SetDeliveryPostCode

//-------------------------------------------------------------------------

// MH 30/09/2013 MRD Branch for v7.0.8: Added new fields for Consumer Ledger and Auto-Receipt
Function TCustomer.GetSubType : Char;
Begin // GetSubType
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.acSubType
  Else Begin
    Result := #0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'acSubType');
  End; { Else }
End; // GetSubType

//------------------------------

Function TCustomer.GetLongACCode : custr30;
Begin // GetLongACCode
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.acLongACCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'acLongACCode');
  End; { Else }
End; // GetLongACCode

Procedure TCustomer.SetLongACCode(Value : custr30);
Begin // SetLongACCode
  (*
  If (RecAccess <> NotAvailable) And (PropAccess[85] = paReadWrite) Then
  Begin
    If (DataRec.acLongACCode <> Value) Then
    Begin
      DataRec.acLongACCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'acLongACCode');
  *)   EntSys.NotImplException ('TAbsCustomer6.acLongACCode');
End; // SetLongACCode

//-------------------------------------------------------------------------

Function TCustomer.GetPPDMode : TCustomerPPDMode;
Begin // GetPPDMode
  Result := CustABSU.pmPPDDisabled;
  If (RecAccess <> NotAvailable) Then
    Case DataRec.acPPDMode Of
      VarConst.pmPPDDisabled                         : Result := CustABSU.pmPPDDisabled;
      VarConst.pmPPDEnabledWithAutoJournalCreditNote : Result := CustABSU.pmPPDEnabledWithAutoJournalCreditNote;
      VarConst.pmPPDEnabledWithAutoCreditNote        : Result := CustABSU.pmPPDEnabledWithAutoCreditNote;
      VarConst.pmPPDEnabledWithManualCreditNote      : Result := CustABSU.pmPPDEnabledWithManualCreditNote;
    End // Case DataRec.acPPDMode
  Else
    EntSys.DataAccessErrDlg(True, CustObjStr + 'acPPDMode');
End; // GetPPDMode

Procedure TCustomer.SetPPDMode(Value : TCustomerPPDMode);
Var
  NewValue : TTraderPPDMode;
Begin // SetPPDMode
  NewValue := VarConst.pmPPDDisabled;
  If (RecAccess <> NotAvailable) And (PropAccess[idxPPDMode] = paReadWrite) Then
  Begin
    Case Value Of
      CustABSU.pmPPDDisabled                         : NewValue := VarConst.pmPPDDisabled;
      CustABSU.pmPPDEnabledWithAutoJournalCreditNote : NewValue := VarConst.pmPPDEnabledWithAutoJournalCreditNote;
      CustABSU.pmPPDEnabledWithAutoCreditNote        : NewValue := VarConst.pmPPDEnabledWithAutoCreditNote;
      CustABSU.pmPPDEnabledWithManualCreditNote      : NewValue := VarConst.pmPPDEnabledWithManualCreditNote;
    End; // Case Value

    If (DataRec.acPPDMode <> NewValue) Then
    Begin
      DataRec.acPPDMode := NewValue;
      RecChanged := True;
    End; // If (DataRec.acPPDMode <> NewValue)
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'acPPDMode');
End; // SetPPDMode

//-------------------------------------------------------------------------

// MH 22/09/2014 Order Payments - TAbsCustomer8
Function TCustomer.GetAllowOrderPayments : Boolean;
Begin // GetAllowOrderPayments
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.acAllowOrderPayments
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'acAllowOrderPayments');
  End; { Else }
End; // GetAllowOrderPayments

Procedure TCustomer.SetAllowOrderPayments (Value : Boolean);
Begin // SetAllowOrderPayments
  (*
  If (RecAccess <> NotAvailable) And (PropAccess[idxAllowOrderPayments] = paReadWrite) Then
  Begin
    If (DataRec.acAllowOrderPayments <> Value) Then
    Begin
      // Order Payments must be turned on and must be a Customer/Consumer
      If Syss.ssEnableOrderPayments And (DataRec.SubType In [CUSTOMER_TYPE, CONSUMER_TYPE]) Then
      Begin
        DataRec.acAllowOrderPayments := Value;
        RecChanged := True;
      End // If Syss.ssEnableOrderPayments And (DataRec.SubType In [CUSTOMER_TYPE, CONSUMER_TYPE])
      Else
        EntSys.CustomException (CustObjStr + 'Enable Order Payments');
    End; { If }
  End // If (RecAccess <> NotAvailable) And (PropAccess[idxAllowOrderPayments] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'acAllowOrderPayments');
  *)   EntSys.NotImplException ('TAbsCustomer7.acAllowOrderPayments');
End; // SetAllowOrderPayments

//------------------------------

Function TCustomer.GetOrderPaymentsGLCode : LongInt;
Begin // GetOrderPaymentsGLCode
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.acOrderPaymentsGLCode
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'acOrderPaymentsGLCode');
  End; { Else }
End; // GetOrderPaymentsGLCode

Procedure TCustomer.SetOrderPaymentsGLCode (Value : LongInt);
Begin // SetOrderPaymentsGLCode
  (*
  If (RecAccess <> NotAvailable) And (PropAccess[idxOrderPaymentsGLCode] = paReadWrite) Then
  Begin
    If (DataRec.acLongACCode <> Value) Then
    Begin
      If DataRec.acAllowOrderPayments Then
      Begin
        Validate the GL Code as per CustR3U
        If ? Then
        Begin
          DataRec.acLongACCode := Value;
          RecChanged := True;
        End // If ????
        Else
          EntSys.CustomException (CustObjStr + 'Order Payments GL Code');
      End // If DataRec.acAllowOrderPayments
      Else
        EntSys.CustomException (CustObjStr + 'Order Payments GL Code');
    End; { If }
  End // If (RecAccess <> NotAvailable) And (PropAccess[idxOrderPaymentsGLCode] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'acOrderPaymentsGLCode');
  *)   EntSys.NotImplException ('TAbsCustomer7.acOrderPaymentsGLCode');
End; // SetOrderPaymentsGLCode

//-------------------------------------------------------------------------

// MH 26/11/2014 ABSEXCH-15836: Added Country Codes
Function TCustomer.GetCountry : cuStr2;
Begin // GetCountry
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.acCountry
  Else Begin
    Result := '  ';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'acCountry');
  End; { Else }
End; // GetCountry
Procedure TCustomer.SetCountry (Value : cuStr2);
Begin // SetCountry
  If (RecAccess <> NotAvailable) And (PropAccess[idxCountry] = paReadWrite) Then
  Begin
    If (DataRec.acCountry <> Value) Then
    Begin
      // Must be a valid country code
      If ValidCountryCode (ifCountry2, Value) Then
      Begin
        DataRec.acCountry := Value;
        RecChanged := True;
      End // If ValidCountryCode (ifCountry2, Value)
      Else
        EntSys.CustomException (CustObjStr + 'acCountry');
    End; { If }
  End // If (RecAccess <> NotAvailable) And (PropAccess[idxCountry] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'acCountry');
End; // SetCountry

//------------------------------

Function TCustomer.GetDeliveryCountry : cuStr2;
Begin // GetDeliveryCountry
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.acDeliveryCountry
  Else Begin
    Result := '  ';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'acDeliveryCountry');
  End; { Else }
End; // GetDeliveryCountry
Procedure TCustomer.SetDeliveryCountry (Value : cuStr2);
Begin // SetDeliveryCountry
  If (RecAccess <> NotAvailable) And (PropAccess[idxDeliveryCountry] = paReadWrite) Then
  Begin
    If (DataRec.acCountry <> Value) Then
    Begin
      // Must be a valid country code if any other part of the delivery address is set
      // Can be blank if the Delivery Address is not set
      If ValidCountryCode (ifCountry2, Value)
         Or
         (
           (Trim(Value) = '')
           And
           (Trim(DataRec.DAddr[1]) = '') And (Trim(DataRec.DAddr[2]) = '') And
           (Trim(DataRec.DAddr[3]) = '') And (Trim(DataRec.DAddr[4]) = '') And
           (Trim(DataRec.DAddr[5]) = '') And (Trim(DataRec.acDeliveryPostCode) = '')
         ) Then
      Begin
        DataRec.acDeliveryCountry := Value;
        RecChanged := True;
      End // If ValidCountryCode (ifCountry2, Value)
      Else
        EntSys.CustomException (CustObjStr + 'acDeliveryCountry');
    End; { If }
  End // If (RecAccess <> NotAvailable) And (PropAccess[idxDeliveryCountry] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'acDeliveryCountry');
End; // SetDeliveryCountry

//-------------------------------------------------------------------------

// MH 20/01/2016 Exch2016R1 ABSEXCH-17114: Customisation mods for Intrastat changes
Function TCustomer.GetDefaultToQR : Boolean;
Begin // GetDefaultToQR
  // Only available for Customers
  If (RecAccess <> NotAvailable) And (DataRec.CustSupp = TradeCode[True]) Then
    Result := DataRec.acDefaultToQR
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'acDefaultToQR');
  End; { Else }
End; // GetDefaultToQR
Procedure TCustomer.SetDefaultToQR (Value : Boolean);
Begin // SetDefaultToQR
  // Only available for Customers
  If (RecAccess <> NotAvailable) And (PropAccess[idxDefaultToQR] = paReadWrite) And (DataRec.CustSupp = TradeCode[True]) Then
  Begin
    If (DataRec.acDefaultToQR <> Value) Then
    Begin
      DataRec.acDefaultToQR := Value;
      RecChanged := True;
    End; // If (DataRec.acDefaultToQR <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[idxDefaultToQR] = paReadWrite) And (DataRec.CustSupp = TradeCode[True])
  Else
    EntSys.DataAccessErrDlg(False, CustObjStr + 'acDefaultToQR');
End; // SetDefaultToQR

//-------------------------------------------------------------------------

function TCustomer.GetAnonymisationStatus: TCustomerAnonymisationStatus;
begin
  If (RecAccess <> NotAvailable) Then
  begin
    case DataRec.acAnonymisationStatus of
      VarConst.asNotRequested : Result := CustAbsU.asNotRequested;
      VarConst.asPending : Result      := CustAbsU.asPending;
      VarConst.asAnonymised : Result   := CustAbsU.asAnonymised;
    end;
  end
  Else Begin
    Result := CustABSU.asNotRequested;
    EntSys.DataAccessErrDlg(True, CustObjStr + 'acAnonymisationStatus');
  End; { Else }
end;

//-------------------------------------------------------------------------

function TCustomer.GetAnonymisedDate: cuStr8;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.acAnonymisedDate
  Else Begin
    Result := '  ';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'acAnonymisedDate');
  End; { Else }
end;

//-------------------------------------------------------------------------

function TCustomer.GetAnonymisedTime: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.acAnonymisedTime
  Else Begin
    Result := '  ';
    EntSys.DataAccessErrDlg(True, CustObjStr + 'acAnonymisedTime');
  End; { Else }
end;

//-------------------------------------------------------------------------

procedure TCustomer.SetAnonymisationStatus(
  aValue: TCustomerAnonymisationStatus);
begin
  //Currently read-only
  EntSys.DataAccessErrDlg(False, CustObjStr + 'acAnonymisationStatus');
end;

//-------------------------------------------------------------------------

procedure TCustomer.SetAnonymisedDate(aValue: cuStr8);
begin
  //Currently read-only
  EntSys.DataAccessErrDlg(False, CustObjStr + 'acAnonymisedDate');
end;

//-------------------------------------------------------------------------

procedure TCustomer.SetAnonymisedTime(aValue: cuStr6);
begin
  //Currently read-only
  EntSys.DataAccessErrDlg(False, CustObjStr + 'acAnonymisedTime');
end;

end.

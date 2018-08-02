unit DPView_CustSupp;

interface

Uses SysUtils, StdCtrls;

Procedure ProcessCustSupp(Const OutputMemo : TMemo; Const DataBlock : Pointer; Const DataBlockLen : Integer);

implementation

Uses VarConst, DpViewFuncs;

//=========================================================================

Procedure ProcessCustSupp(Const OutputMemo : TMemo; Const DataBlock : Pointer; Const DataBlockLen : Integer);
Begin // ProcessCustSupp
  If (DataBlockLen = SizeOf(Cust)) Then
  Begin
    Move (DataBlock^, Cust, SizeOf(Cust));

    OutputMemo.Lines.Add ('CustSupp');
    OutputMemo.Lines.Add ('--------');

    OutputString  (OutputMemo, 'CustCode', Cust.CustCode, SizeOf(Cust.CustCode) - 1);
    OutputChar    (OutputMemo, 'CustSupp', Cust.CustSupp);
    OutputString  (OutputMemo, 'Company',  Cust.Company, SizeOf(Cust.Company) - 1);
    OutputString  (OutputMemo, 'AreaCode', Cust.AreaCode, SizeOf(Cust.AreaCode) - 1);
    OutputString  (OutputMemo, 'RepCode',  Cust.RepCode, SizeOf(Cust.RepCode) - 1);
    OutputString  (OutputMemo, 'RemitCode',  Cust.RemitCode, SizeOf(Cust.RemitCode) - 1);
    OutputString  (OutputMemo, 'VATRegNo',  Cust.VATRegNo, SizeOf(Cust.VATRegNo) - 1);
    OutputString  (OutputMemo, 'Addr[1]',  Cust.Addr[1], SizeOf(Cust.Addr[1]) - 1);
    (*
    Addr       : AddrTyp;       { Addr1-4 (Don't forget to alter Imp/Export) }
    DespAddr   : Boolean;       { Seaparete Despatch Address }
    DAddr      : AddrTyp;       { Despatch Addr1-4 }
    Contact    : String[25];    { Contact Name }
    Phone      : string[30];    { Phone No. }
    Fax        : string[30];    { Phone No. }
    RefNo      : String[10];    { Our Code with them }
    TradTerm   : Boolean;       { Special Terms }
    STerms     : TradeTermType; { 2 Lines of Terms }
    Currency   : Byte;
    VATCode    : Char;
    PayTerms   : SmallInt;
    CreditLimit: Real;
    Discount   : Real;
    CreditStatus: SmallInt;
    CustCC     : String[3];
    CDiscCh    : Char;
    OrdConsMode: Byte;
    DefSetDDays: SmallInt;     { Default Settlement discount Number of Days }
    Spare5     : Array[1..2] of Byte;
    Balance    : Real;
    CustDep    : String[3];
    EECMember  : Boolean;       { VAT Inclusion for EEC }
    NLineCount : LongInt;       { Note Line Count       }
    IncStat    : Boolean;       { Include in Statement  }
    DefNomCode : LongInt;       { Default Nominal Code  }
    DefMLocStk : String[3];     { Default Multi Loc Stock }
    AccStatus  : Byte;          { On Hold, Closed, See notes }
    PayType    : Char;          { [B]acs,[C]ash }
    OldBankSort   : String[15];     { Bank Sort Code }
    OldBankAcc    : String[20];     { Bank Account No. }
    BankRef    : String[28];    { Bank additional ref, ie Build Soc.Acc }
    AvePay     : SmallInt;       { Average payment pattern }
    Phone2     : String[30];    { Second Phone No. }
    DefCOSNom  : LongInt;       { Override COS Nominal }
    DefCtrlNom : LongInt;       { Override Default Ctrl Nominal }
    LastUsed   : LongDate;      { Date last updated }
    UserDef1,
    UserDef2   : String[30];    { User Definable strings }
    SOPInvCode : String[10];    { Ent SOP Invoice Code }
    SOPAutoWOff: Boolean;       { Auto write off Sales Order }
    FDefPageNo : Byte;          { Use form def page for forms }
    BOrdVal    : Double;        { Heinz Book order value }
    DirDeb     : Byte;          { Current Direct Debit Mode }
    CCDSDate   : LongDate;      { Credit Card Start Date }
    CCDEDate   : LongDate;      { Credit Card End Date }
    CCDName    : String[50];    { Name on Credit Card }
    CCDCardNo  : String[30];    { Credit Card No. }
    CCDSARef   : String[4];     { Credit Card Switch Ref }
    DefSetDisc : Double;        { Default Settlement Discount }
    StatDMode: Byte;          { Statement/Remittance delivery mode.}
    Spare2   : String[50];
    EmlSndRdr: Boolean;       { On next email transmnision, send reader & reset }
    ebusPwrd : String[20];    { ebusiness module web password }
    PostCode : String[20];    { Seperate postcode  Add index }
    CustCode2: String[20];    { Alternative look up code, can be blank }
    AllowWeb : Byte;          { Allow upload to Web }
    EmlZipAtc: Byte;          { Default Zip attachement 0=no, 1= pkzip, 2= edz }
    UserDef3,
    UserDef4 : String[30];    { User Definable strings }
    WebLiveCat:    String[20];         {Web current catalogue entry}
    WebPrevCat:    String[20];         {Web previous catalogue entry}
    TimeChange:  String[6];    { Time stamp for record Change }
    VATRetRegC: String[5];     { Country of VAT registration }
    SSDDelTerms : String[5];   {     "     Delivery Terms }
    CVATIncFlg: Char;
    SSDModeTr: Byte;
    PrivateRec: Boolean;
    LastOpo: String[10];
    InvDMode : Byte;   {Invoice delivery mode}
    EmlSndHTML: Boolean;{When sending XML, send HTML}
    EmailAddr: String[100];    { Email address for Statment/ Remittance }
    SOPConsHO: Byte;           { If Head office, consolidate committed value }
    DefTagNo : Byte;           { Default Tag No for SOP/WOP }
    UserDef5  : String[30];
    UserDef6  : String[30];
    UserDef7  : String[30];
    UserDef8  : String[30];
    UserDef9  : String[30];
    UserDef10 : String[30];
    acBankSortCode: string[22];       // Sort code / BIC (encrypted)
    acBankAccountCode: string[54];    // Account Code / IBAN Code (encrypted)
    acMandateID: string[54];          // Direct Debit Mandate Id (encrypted)
    acMandateDate: LongDate;          // Direct Debit Mandate Date
    acDeliveryPostCode: string[20];
    acSubType : Char; //'C' - customer, 'S' - supplier, 'U' - consumer
    acLongACCode : string[30];
    acAutoReceiptGLCode: LongInt;
    acAllowAutoReceipts: Boolean;
    Spare     : Array[1..323] of Char;
    *)
  End // If (DataBlockLen = SizeOf(Cust))
  Else
    OutputMemo.Lines.Add ('*** Document - Cust Invalid Size - ' + IntToStr(SizeOf(Cust)) + ' expected, ' + IntToStr(DataBlockLen) + ' received');
End; // ProcessCustSupp

end.

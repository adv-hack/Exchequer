unit DragCust;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

procedure DoDragnetCustExport;

implementation

uses
  IOUtil, UseDLLU, SysUtils, {EBusUtil, }EBusVar, {EBusBtrv, GlobVar, BtrvU2,}
  Classes, CommsInt, DragUtil, StrUtil,FileUtil,
  Dialogs; // ShowMessage;

{$I EXCHDLL.INC}
{$I EXDLLBT.INC}

const
  CUST_REC_SIZE = SizeOf(TBatchCURec);
  BAL_REC_SIZE = SizeOf(THistoryBalRec);
  VAT_REC_SIZE = SizeOf(TBatchVATRec);

  CUSTACCT_NAME = 'CustAcct.txt';
  VATRATES_NAME = 'VATRates.txt';
  PUBLISH_NAME = 'Publish.txt';
  COMPANY_NAME = 'Company.txt';
  COUNTRY_NAME = 'Country.txt';

type
  PBatchCURec = ^TBatchCURec;
  PHistoryBalRec = ^THistoryBalRec;
  PBatchVATRec = ^TBatchVATRec;

  TDragNetCustomerExport = class
    private
      Publisher   : string[8];
      Password    : string[20];
      CompanyCode : char;
      ExportDir   : string;
      AdminEmail  : string[100];

      CustAcct : TFileExport;
      VATRates : TFileExport;

      procedure WriteCustAcctLine(CustRec : PBatchCURec; BalRec : PHistoryBalRec);
      procedure ProcessCustAcct;
{      procedure ProcessPublish;}
      procedure ProcessCompany;
      procedure ProcessCountry;
      procedure WriteVATRatesLine(VATRec : PBatchVATRec);
      procedure ProcessVAT;
      procedure AssignStandardExportFields;
      procedure CreateCustomerZipFile;
    public
      procedure ExportCustomerInfo;
   end;

//-----------------------------------------------------------------------

procedure TDragNetCustomerExport.WriteCustAcctLine(CustRec : PBatchCURec;
            BalRec : PHistoryBalRec);
var
  i, PostCodeLine : byte;
  PostCodeFound : boolean;
begin
  with CustAcct, CustRec^, BalRec^ do
  begin
    WriteString(Publisher,8);
    WriteString(CompanyCode,1);
    WriteString(CustCode,8);
    if Trim(ebusPwrd) = '' then
      WriteString('PASSWORD', 20)
    else
      WriteString(ebusPwrd, 20);
    WriteString(Company,30);
    PostCodeFound := false;
    for i := 1 to 5 do
      if ProbablyPostCode(Addr[i]) then
      begin
        PostCodeLine := i;
        PostCodeFound := true;
      end;
    if PostCodeFound then
    begin
      for i := 1 to PostCodeLine -1 do
        WriteString(Addr[i],30);
      for i := PostCodeLine to 4 do
        WriteBlank(30);
      WriteString(Trim(Addr[PostCodeLine]),8); // Post code
    end
    else
    begin
      for i := 1 to 4 do
        WriteString(Addr[i],30);
      WriteBlank(8);
    end;
    WriteString(Phone,20);
    WriteString(Fax,20);
    WriteNum(Value,12,2);  // Current balance
    WriteNum(CreditLimit,8,0);
    WriteString(BooleanAs01(AccStatus=2),1); // Whether on hold ?
    WriteString('GB',2);               // Country code - needs to match a country code
    WriteString(BooleanAs01(false),1); // Northern Ireland
    WriteString(VATCode,1);
    WriteString(Trim(VATRegNo),15);
    WriteBlank(4);              // Discount group
    WriteBlank(4);              // Price List
    WriteNum(Discount,6,2);     // Overall discount may be amount or percent ???
    WriteNum(DefSetDDays,4,0);  // 1st settlement discount days
    WriteNum(DefSetDisc,6,2);   // 1st settlement discount percentage
    WriteBlank(4);              // 2nd settlement discount days
    WriteBlank(6);              // 2nd settlement discount percentage
    WriteString(BooleanAs01(true),1); // Settlement discount includes delivery ?
    NewLine;
  end;
end; // WriteCustAcctLine

//-----------------------------------------------------------------------

procedure TDragNetCustomerExport.ProcessCustAcct;
var
  CustRec : PBatchCURec;
  BalRec : PHistoryBalRec;
  Status : integer;
  CustCode,
  AccCode : TCharArray255;
begin
  new(CustRec);
  new(BalRec);

  Status := Ex_GetAccount(CustRec, CUST_REC_SIZE, CustCode, 0, B_GetFirst, 1, false);
  while Status = 0 do
  begin
    Move(CustRec^.CustCode[1], AccCode, length(CustRec^.CustCode));
    Ex_GetAccountBalance(BalRec, BAL_REC_SIZE, AccCode, 0);
    WriteCustAcctLine(CustRec, BalRec);
    Status := Ex_GetAccount(CustRec, CUST_REC_SIZE, CustCode, 0, B_GetNext, 1, false);
  end;
  dispose(CustRec);
  dispose(BalRec);
end; // TDragNetCustomerExport.ProcessCustAcct

//-----------------------------------------------------------------------

{procedure TDragNetCustomerExport.ProcessPublish;
const
  ENTERPRISE = 'E';
begin
  with TFileExport.Create(ExportDir + PUBLISH_NAME) do
    try
      WriteString(Publisher,8);
      WriteString(Password,20);
      // DragNet cannot currently handle this system type flag
      // WriteString(ENTERPRISE,1);
      NewLine;
    finally
      Free;
    end;
end;}

//-----------------------------------------------------------------------

procedure TDragNetCustomerExport.ProcessCompany;
var
  OrdPrefix : string;
  OrdStart : longint;

  procedure ReadCompanyParams;
{  var
    Params : PEBusDragNetCompanyParams;}
  begin
{    new(Params);
    ReadNoLockEBusLevel1(Params, EBUS_DRAGNET, EBUS_COMPANY,
      EBusParams.CurCompCode);
    OrdPrefix := Params^.DNetOrderPrefix;
    OrdStart := Params^.DNetOrderNoStart;
    dispose(Params);}

    OrdPrefix := 'INT';
    OrdStart := 1000;
  end;

begin // TDragNetCustomerExport.ProcessCompany
  with TFileExport.Create(ExportDir + COMPANY_NAME) do
    try
      ReadCompanyParams;
      WriteString(Publisher,8);
      WriteString(CompanyCode,1);
      // Email address of internet admin - EBusiness setup ...
      WriteString(AdminEmail,50);
      WriteString(BooleanAs01(true),1); // 'Opera' or Internet order numbers

      WriteString(OrdPrefix,3); // Order no prefix 'INT' in Dragnet / Opera
      WriteNum(OrdStart,7,0); // Next order number

      WriteString(BooleanAs01(false),1);  // EC VAT ???
      WriteString('Y',1);  // Delivery VAT - hard code to 'Y' - Hazel 23/08/1999
      NewLine;
    finally
      Free;
    end;
end; // TDragNetCustomerExport.ProcessCompany

//-----------------------------------------------------------------------

procedure TDragNetCustomerExport.WriteVATRatesLine(VATRec : PBatchVATRec);
var
  TempVATDesc : string;
begin
  with VATRates, VATRec^ do
  begin
    WriteString(Publisher,8);
    WriteString(CompanyCode,1);
    WriteString('H',1);        // Country type ??? 'H' = home
    WriteString('S',1);        // Transaction type S = sales, P = purchases
    WriteString(VATCode,1);
    // Temp - descriptions not currently available from the toolkit
    case VATCode of
     'E' : TempVATDesc := 'Exempt';
     'S' : TempVATDesc := 'Standard';
     'Y' : TempVATDesc := 'Delivery';
     'Z' : TempVATDesc := 'Zero Rated';
    else
      TempVATDesc := '';
    end;
    WriteString(TempVATDesc,25);
    WriteNum(VatRate*100,6,2);    // VAT rate 1
    // This needs to be set to avoid errors on DragNet import -
    // current date apparently OK.
    WriteString(DateTimeAsDragNetDateTime(SysUtils.Date),19); // VAT rate 1 date
    WriteBlank(6);                // VAT rate 2
    WriteBlank(19);               // VAT rate 2 date
    NewLine;
  end;  // with
end; // TDragNetCustomerExport.WriteVATRatesLine(VATRec : PBatchVATRec);

//-----------------------------------------------------------------------

procedure TDragNetCustomerExport.ProcessVAT;
const
  TAX_CODES : shortstring = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
  i : byte;
  VATRec : PBatchVATRec;
  Status : integer;
begin
  new(VATRec);
  for i := 1 to length(TAX_CODES) do
  begin
    fillchar(VATRec^, VAT_REC_SIZE,0);
    VATRec^.VATCode := TAX_CODES[i];
    Status := Ex_GetVATRate(VATRec, VAT_REC_SIZE);
    if Status = 0 then
    begin
      WriteVATRatesLine(VATRec);
      // Apparently we need a VAT code 'Y' for delivery VAT
      // Link it to Standard rate VAT
      if VATRec^.VATCode = 'S' then
      begin
        VATRec^.VATCode := 'Y';
        WriteVATRatesLine(VATRec);
      end;
    end;
  end;
  dispose(VATRec);
end; // TDragNetCustomerExport.ProcessVAT

//-----------------------------------------------------------------------

procedure TDragNetCustomerExport.ProcessCountry;
{const
  FNum = EBsF;
var
  KeyS : Str255;
  Status : integer;}
begin
{  with TFileExport.Create(ExportDir + COUNTRY_NAME), EBusRec, EBusDragNetCountryParams do
    try
      KeyS := EBUS_DRAGNET + EBUS_COUNTRY;
      Status := Find_Rec(B_GetGEq, F[FNum], FNum, RecPtr[FNum]^, 1, KeyS);
      while (Status = 0) and (copy(KeyS,1,2) = EBUS_DRAGNET + EBUS_COUNTRY) do
      begin
        WriteString(Publisher,8);
        WriteString(CompanyCode,1);
        WriteString(EBusCode1,2);                    // Country code
        WriteString(DNetCountryNoCode,3);            // Numeric code
        WriteString(DNetCountryName,20);
        WriteString(BooleanAs01(DNetHomeCountry),1); // Home indicator
        WriteString(BooleanAs01(DNetECMember),1);    // EC member
        WriteString(BooleanAs01(true),1);            // VAT registered
        WriteString(BooleanAs01(true),1);            // Settlement discount applies to VAT
        WriteString(DNetTaxAbbrev,3);                // VAT description e.g. VAT, TAX, etc
        NewLine;
        Status := Find_Rec(B_GetNext, F[FNum], FNum, RecPtr[FNum]^, 1, KeyS);
      end;
    finally
      Free;
    end;}

  with TFileExport.Create(ExportDir + COUNTRY_NAME) do
    try
      WriteString(Publisher,8);
      WriteString(CompanyCode,1);
      WriteString('GB',2);                    // Country code
      WriteString('044',3);            // Numeric code
      WriteString('Great Britain',20);
      WriteString(BooleanAs01(TRUE),1); // Home indicator
      WriteString(BooleanAs01(TRUE),1);    // EC member
      WriteString(BooleanAs01(true),1);            // VAT registered
      WriteString(BooleanAs01(true),1);            // Settlement discount applies to VAT
      WriteString('VAT',3);                // VAT description e.g. VAT, TAX, etc
      NewLine;
    finally
      Free;
    end;
end; // TDragNetCustomerExport.ProcessCountry

//-----------------------------------------------------------------------

procedure TDragNetCustomerExport.AssignStandardExportFields;
{var
  Params : PEBusDragNetParams;}
begin
{  new(Params);
  ReadEBusinessParams(Params, EBUS_DRAGNET, false);
  with Params^ do
  begin
    Publisher := DNetPublisherCode;
    Password := DNetPublisherPassword;
    ExportDir := AddBackSlash(DNetExportDirectory);
    AdminEmail := DNetAdminEmailAddress;
  end;
  GetDragNetCompCode(EBusParams.CurCompCode, CompanyCode);
  dispose(Params);}

{  with TEBusBtrieveFile.Create(TRUE) do begin
    OpenFile;
    CompanyCode := sCompanyCode;
    ExportCode := sExportCode;
    if (FindRecord = 0) then Result := FileSettings;
    CloseFile;
    Free;
  end;{with}

{************************************ READ IN FROM BTRIEVE FILES *************************************}
  Publisher := 'XCHEQUER';
  Password := 'PASSWORD';
  ExportDir := 'C:\DRAGNET\';
  AdminEmail := 'nfrewer@exchequer.com';
  CompanyCode := 'A';
{************************************ READ IN FROM BTRIEVE FILES *************************************}

end; // TDragNetStockExport.AssignStandardExportFields

//-----------------------------------------------------------------------

procedure TDragNetCustomerExport.ExportCustomerInfo;
var
  ExportName : string;
begin
  try
    AssignStandardExportFields;
    CustAcct := TFileExport.Create(ExportDir + CUSTACCT_NAME);
    VATRates := TFileExport.Create(ExportDir + VATRATES_NAME);

    (* Hazel 19/08/1999 - this file not required
    ExportName := 'Publisher';
    ProcessPublish; *)
    ExportName := 'Company';
    ProcessCompany;
    ExportName := 'Country';
    ProcessCountry;
    ExportName := 'VAT';
    ProcessVAT;
    ExportName := 'Customer account';
    ProcessCustAcct;

    CustAcct.Free;
    VATRates.Free;

    if not WriteDragNetIDFile(ExportDir, Publisher, Password, CompanyCode, '',
      AdminEmail, dntCustomer) then ; // raise error

  except
    on E:EInOutError do
      MessageDlg('The Dr@gNet export has failed at the ' + ExportName + ' stage ' +
        'with error code ' + IntToStr(E.ErrorCode), mtError, [mbOK], 0);
  end;
end; // TDragNetCustomerExport.ExportCustomerInfo

//-----------------------------------------------------------------------

procedure TDragNetCustomerExport.CreateCustomerZipFile;
var
  ZipFileList : TStringList;
{  Result : smallint;}
begin
  with TEntZip.Create do
  try
    ZipFileList := TStringList.Create;
    with ZipFileList do
    begin
      Add(ExportDir + CUSTACCT_NAME);
      Add(ExportDir + VATRATES_NAME);
      Add(ExportDir + PUBLISH_NAME);  
      Add(ExportDir + COMPANY_NAME);
      Add(ExportDir + COUNTRY_NAME);
      Add(ExportDir + 'ID.TXT');
    end;
    Files.Assign(ZipFileList);
    // Again hard coded catalogue in at this point
    ZipName := ExportDir + 'COMP_' + CompanyCode + '.ZIP';
    OverwriteExisting := true;
    StripDrive := true;
    StripPath := true;
    { Return values ...  0=OK, 1=no files to compress, 2=failed to delete existing .ZIP file }
    {                    3=DLL Not Found, }
    {Result := }Save;
    DeleteFiles(ZipFileList);
    ZipFileList.Free;
  finally
    Free;
  end;
end; // TDragNetStockExport.CreateCustomerZipFile

//-----------------------------------------------------------------------

procedure DoDragnetCustExport;
var
  Status : integer;
begin
{ if EBusParams.ACompanyActive(true) then
    with TDragNetCustomerExport.Create do
      try
        ExportCustomerInfo;
        CreateCustomerZipFile;
      finally
        Free;
      end;}

  Status := Ex_InitDLL;
  if Status <> 0 then
    ShowMessage('Ex_InitDLL = ' + IntToStr(Status))
  else
    with TDragNetCustomerExport.Create do
      try
        ExportCustomerInfo;
        CreateCustomerZipFile;
      finally
        Free;
        Ex_CloseDLL;
      end;

end;

end.




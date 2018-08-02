unit oPIIScanner;

interface

uses
  PIIScannerIntf, PIIFieldNumbers, Forms, VarConst;

function GetPIIScanner(const AOwner : TForm;
                       const EmpRec : EmplType) : IPIIScanner; overload;

function GetPIIScanner(const AOwner : TForm;
                       const AccountRec : CustRec) : IPIIScanner; overload;


var
  CompanyCodeForPIIScanner : string;

implementation

uses
  SysUtils, Classes, AdvMemo, Contnrs, GlobVar, CustomFieldsIntf,
   oPIIDataAccess, VarRec2U, BtKeys1U, EtStrU, ContactsManager, oContactsFile,
   oEbusTrans, SQLUtils, Windows, Messages, GmXML, VarJCstU, XMLFuncs, BtrvU2,
   ConsumerUtils, JobSup1U, FileUtil, CountryCodes, CountryCodeUtils,
   EncryptionUtils, Crypto, EtDateU;

const
  ContactsF  = -1;
  EbusTransF  = -2;
  EbusNotesF = -3;

type
  TPIIInfoItemType = (ptRecord, ptValue);

  TPIIScanner = Class;
  TPIIInfoList = Class;
  TPIIInfoChildList = Class;

  TPIIInfoItem = Class(TInterfacedObject, IPIIInfoItem)
  private
    function GetDisplayText: string;
    function GetIndex: Integer;
    function GetParent: Integer;
    function GetRecordAddress: integer;
    function GetTable: integer;
    function GetItemType : TItemType;
    function GetText : string;
    procedure SetDisplayText(const Value: string);
    procedure SetIndex(const Value: Integer);
    procedure SetParent(const Value: Integer);
    procedure SetRecordAddress(const Value: integer);
    procedure SetTable(const Value: integer);
    procedure LoadChildren;
  protected
    FOwner : TPIIScanner;
    FDisplayText : string;
    FTable : Integer;
    FRecordAddress : Integer;
    FFieldNo : TPIIFieldNo;
    FChildren : TPIIInfoChildList;
    FChildrenI : IPIIInfoList;
    FIndex : Integer;
    FParent : Integer;
    FItemType : TItemType;
    FXMLDesc : string;

    function HasChildren : Boolean;
    function GetChildren : IPIIInfoList;
    function GetFieldType : TPIIFieldNo;
    procedure InitType; virtual;
    function GetXMLDescription : string;
  public
    constructor Create(const AOwner    : TPIIScanner;
                       const AFieldNo  : TPIIFieldNo;
                       const AParent   : Integer;
                       const AnIndex   : Integer;
                       const ATable    : Integer;
                       const AnAddress : longint;
                       const AText     : string;
                       const XMLDesc   : string = '');
    destructor Destroy; override;
    property DisplayText : string read GetDisplayText write SetDisplayText;
    property Table : integer read GetTable write SetTable;
    property RecordAddress : integer read GetRecordAddress write SetRecordAddress;
    property Parent : Integer read GetParent write SetParent;
    property Index : Integer read GetIndex write SetIndex;

  end;

  TPIIInfoHeader = Class(TPIIInfoItem, IPIIInfoHeader)
  private
    FKeyString : string;
  protected
    procedure InitType; override;
    function GetKeyString : string; //Key for loading notes for owner
  public
    property KeyString : string read GetKeyString write FKeyString;
  end;

  TPIIAddressItem = Class(TPIIInfoItem, IPIIAddressItem)
  public
    Address : TPIIInfoAddress;
    function GetAddress: TPIIInfoAddress;
    procedure SetAddress(const Value: TPIIInfoAddress);
  end;

  TPIIInfoList = Class(TInterfacedObject, IPIIInfoList)
  private
    FList : TInterfaceList;
  protected
    function GetCount : Integer;
    function GetItem(Index : Integer) : IPIIInfoItem;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const AnItem : IPIIInfoItem) : integer;
    procedure Delete(Index : Integer);
    property Count : Integer read GetCount;
  end;

  TPIIInfoChildList = Class(TInterfacedObject, IPIIInfoList)
  private
    FList : TIntList;
    FOwner : TPIIScanner;
  protected
    function GetCount : Integer;
    function GetItem(Index : Integer) : IPIIInfoItem;
  public
    constructor Create(const AOwner : TPIIScanner);
    destructor Destroy; override;
    procedure Add(const AnInt : Integer);
    property Count : Integer read GetCount;
  end;


  TPIIScanner = Class(TInterfacedObject, IPIIScanner)
  private
    FAccountRec : CustRec;
    FEmployeeRec : EmplType;
    FScanType : TPIIScanType;
    FList : TPIIInfoList;
    FListI : IPIIInfoList;
    FDataAccess : IPIIDataAccess;
    CurrentParent : Integer;
    FOwner : TForm;
    FScanComplete : Boolean;
    FContactsManager : TContactsManager; //For account role contacts
    FContactsFile : TContactsFile; //For Contacts Plug-in contacts
    FEbusTrans : TEbusTransFile; //for eBusiness transactions
    FXMLIncludeNotes : Boolean;
    FXml : TGmXml;
    function GetPIIList : IPIIInfoList;
    function GetPIITree : IPIIInfoItem;
    function GetDataAccess : IPIIDataAccess;
    procedure ReadAccountFields(const AccountRec  : CustRec; RecAddress : integer);
    procedure ReadTransactionFields(const AnInv  : InvRec; RecAddress : integer);
    procedure ReadLineFields(const ADetail : IDetail; RecAddress : integer);
    procedure ReadEmployeeFields(const EmployeeRec  : EmplType; RecAddress : integer);
    procedure ReadContactFields(const ContactRec  : TContactRecType; RecAddress : Integer);
    procedure LoadPluginContacts(const ACode  : string);
    procedure LoadEmployees(const ACode  : string);
    procedure LoadJobs(const ACode  : string);
    procedure ReadJobFields(AJobRec : JobRecType; RecAddress : Integer);

    procedure LoadCISVouchers(const EmpCode : string);
    procedure ReadCISVoucherFields(Voucher : JobCISType; RecAddress : Integer);

    procedure LoadNotes(const OwnerType : TPIIOwnerType;
                              KeyString : Str255);
    procedure LoadLetters(const OwnerType : TPIIOwnerType;
                                KeyString : Str255);
    procedure LoadLinks(const OwnerType : TPIIOwnerType;
                              KeyString : Str255);
    procedure LoadTransactions(const OwnerType : TPIIOwnerType;
                                     KeyString : Str255;
                               const IndexNo   : Integer;
                               const HeaderText : string);
    procedure LoadTransactionLines(const OwnerType : TPIIOwnerType;
                                         KeyString : Str255);

    procedure LoadAccountContacts;
    procedure ReadAccountContactFields(WhichContact : Integer);

    procedure LoadEbusTransactions(KeyString : Str255);
    procedure ReadEbusTransactionFields(const AnInv  : InvRec; RecAddress : integer);



    function LineUDFCat(const DocType : DocTypes) : Integer;
    procedure WriteToXML(const FileName : string; IncludeNotes : Boolean);
    function ScanComplete : Boolean;

    procedure XMLWriteAccount(const Item : IPIIInfoItem; const ANode: TGmXmlNode);
    procedure XMLWriteEmployee(const Item : IPIIInfoItem; const ANode : TGmXmlNode);
    procedure XMLWriteNotes(const Item : IPIIInfoHeader; const ANode : TGmXmlNode);
    procedure XMLWriteAddress(const Item : IPIIAddressItem; const ANode : TGmXmlNode);
    procedure XMLWritePaymentDetails(const Item : IPIIAddressItem; const ANode : TGmXmlNode);
    procedure XMLWriteUDF(const Item : IPIIInfoItem; const ANode : TGmXmlNode);
    procedure XMLWrite(const ItemList : IPIIInfoList; const ANode : TGmXmlNode);

  public
    constructor Create(const AOwner : TForm;
                       const AType  : TPIIScanType);
    destructor Destroy; override;
    function Execute : Integer;

    property PIITree : IPIIInfoItem read GetPIITree;
    property PIIList : IPIIInfoList read GetPIIList;
  end;

  TPIIAccountScanner = Class(TPIIScanner)
  public
    constructor Create(const AOwner : TForm;
                       const ARec   : CustRec);
  end;

  TPIIEmployeeScanner = Class(TPIIScanner)
  public
    constructor Create(const AOwner : TForm;
                       const ARec   : EmplType);
  end;


function GetPIIScanner(const AOwner : TForm;
                       const EmpRec : EmplType) : IPIIScanner;
begin
  Result := TPIIEmployeeScanner.Create(AOwner, EmpRec);
end;

function GetPIIScanner(const AOwner : TForm;
                       const AccountRec : CustRec) : IPIIScanner;
begin
  Result := TPIIAccountScanner.Create(AOwner, AccountRec);
end;


//PR: 25/01/2018 Change to include postcode and country
function FormatAddress(const AnAddr : AddrTyp;
                       const PostCode : string;
                       const Country  : string) : string;
var
  i : Integer;
begin
  Result := '';
  for i := 1 to 5 do
    if Trim(AnAddr[i]) <> '' then
      Result := Result + Trim(AnAddr[i]) + ', ';

  if Trim(PostCode) <> '' then
    Result := Result + Trim(PostCode) + ', ';

  if Trim(Country) <> '' then
    Result := Result + Country;

  //Remove any trailing comma
  i := Length(Result);
  if (i > 1) then
    if (Result[i-1] = ',') then
      Delete(Result, i-1, 2);
end;


{ TPIIInfoItem }

constructor TPIIInfoItem.Create(const AOwner     : TPIIScanner;
                                const AFieldNo   : TPIIFieldNo;
                                const AParent    : Integer;
                                const AnIndex    : Integer;
                                const ATable     : Integer;
                                const AnAddress  : longint;
                                const AText      : string;
                                const XMLDesc   : string = '');

begin
  inherited Create;
  FFieldNo := AFieldNo;
  FChildren := nil;
  FOwner := AOwner;
  FParent := AParent;
  FIndex := AnIndex;
  FTable := ATable;
  FRecordAddress := AnAddress;
  FDisplayText := AText;
  FXMLDesc := XMLDesc;
  InitType;
end;

destructor TPIIInfoItem.Destroy;
begin
  if Assigned(FChildren) then
    FreeAndNil(FChildren);
  inherited;
end;

function TPIIInfoItem.GetChildren: IPIIInfoList;
begin
  if not Assigned(FChildren) then
    LoadChildren;
  Result := FChildren as IPIIInfoList;
end;

function TPIIInfoItem.GetDisplayText: string;
begin
  Result := FieldText(FFieldNo) + FDisplayText;
end;

function TPIIInfoItem.GetFieldType: TPIIFieldNo;
begin
  Result := FFieldNo;
end;

function TPIIInfoItem.GetIndex: Integer;
begin
  Result := FIndex;
end;

function TPIIInfoItem.GetItemType: TItemType;
begin
  Result := FItemType;
end;

function TPIIInfoItem.GetParent: Integer;
begin
  REsult := FParent;
end;

function TPIIInfoItem.GetRecordAddress: integer;
begin
  Result := FRecordAddress;
end;

function TPIIInfoItem.GetTable: integer;
begin
  Result := FTable;
end;

function TPIIInfoItem.GetText: string;
begin
  Result := FDisplayText;
end;

function TPIIInfoItem.GetXMLDescription: string;
begin
  Result := FXMLDesc;
end;

function TPIIInfoItem.HasChildren: Boolean;
begin
  if not Assigned(FChildren) then
    LoadChildren;
  Result := FChildren.Count > 0;
end;

procedure TPIIInfoItem.InitType;
begin
  FItemType := itItem;
end;

procedure TPIIInfoItem.LoadChildren;
var
  i : integer;
begin
  FChildren := TPIIInfoChildList.Create(FOwner);
  FChildrenI := FChildren;
  with FOwner.PIIList do
  begin
    for i := 0 to Count - 1 do
    begin
      if Items[i].Parent = FIndex then
        FChildren.Add(Items[i].Index);
    end; // for i := 0 to Count - 1 do
  end; // with FOwner.PIIList do
end;

procedure TPIIInfoItem.SetDisplayText(const Value: string);
begin
  FDisplayText := Value;
end;

procedure TPIIInfoItem.SetIndex(const Value: Integer);
begin
  FIndex := Value;
end;

procedure TPIIInfoItem.SetParent(const Value: Integer);
begin
  FParent := Value;
end;

procedure TPIIInfoItem.SetRecordAddress(const Value: integer);
begin
  FRecordAddress := Value;
end;

procedure TPIIInfoItem.SetTable(const Value: integer);
begin
  FTable := Value;
end;

//==============================================================================

{ TPIIInfoList }

function TPIIInfoList.Add(const AnItem : IPIIInfoItem) : integer;
begin
  Result := FList.Add(AnItem);
end;

constructor TPIIInfoList.Create;
begin
  inherited;
  FList := TInterfaceList.Create;
//  FList.OwnsObjects := False;
end;

procedure TPIIInfoList.Delete(Index: Integer);
begin
  if (Index >= 0) and (Index < FList.Count) then
    FList.Delete(Index)
  else
    raise ERangeError.Create('Index out of range (' + IntToStr(Index) + ')');
end;

destructor TPIIInfoList.Destroy;
begin
{  FList.Clear;
  FreeAndNil(FList);}
  inherited;
end;

function TPIIInfoList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TPIIInfoList.GetItem(Index: Integer): IPIIInfoItem;
begin
  if (Index >= 0) and (Index < FList.Count) then
    Result := FList[Index] as IPIIInfoItem
  else
    raise ERangeError.Create('Index out of range (' + IntToStr(Index) + ')');
end;

//==============================================================================


{ TPIIScanner }

constructor TPIIScanner.Create(const AOwner: TForm; const AType: TPIIScanType);
begin
  inherited Create;
  FScanComplete := False;
  FList := TPIIInfoList.Create;
  FListI := FList;
  FOwner := AOwner;
  FScanType := AType;
  FDataAccess := oPIIDataAccess.GetDataAccess;
  FContactsFile := TContactsFile.Create;
end;

destructor TPIIScanner.Destroy;
begin
  FListI := nil;
  FList := nil;

  if Assigned(FContactsManager) then
    FreeAndNil(FContactsManager);
  FreeAndNil(FContactsFile);

  inherited;
end;

function TPIIScanner.Execute: Integer;
var
  RecAddress : Integer;
begin
  Result := 0;
  CurrentParent := -1;
  if FScanType = pstEmployee then
  begin
    if FDataAccess.FindEmployee(FEmployeeRec.EmpCode, RecAddress) then
      ReadEmployeeFields(FEmployeeRec, RecAddress);
  end
  else
  if FScanType = pstTrader then
  begin
    if FDataAccess.FindAccount(FAccountRec.CustCode, RecAddress) then
      ReadAccountFields(FAccountRec, RecAddress);
  end;
  FScanComplete := True;
end;

function TPIIScanner.GetPIIList: IPIIInfoList;
begin
  Result := FListI;
end;

function TPIIScanner.GetPIITree: IPIIInfoItem;
begin
  Result := FList.GetItem(0);
end;

//function for getting line udf field cat from doc type.
//Header cat will be Line cat - 1
function TPIIScanner.LineUDFCat(const DocType: DocTypes): Integer;
begin
  Case DocType of
    SIN,
    SCR,
    SJI,
    SJC,
    SRI,
    SRF : Result := cfSINLine;
    SRC : Result := cfSRCLine;
    SOR : Result := cfSORLine;
    SQU : Result := cfSQULine;
    SRN : Result := cfSRNLine;

    PIN,
    PCR,
    PJI,
    PJC,
    PPI,
    PRF : Result := cfPINLIne;
    PPY : Result := cfPRCLine;
    POR : Result := cfPORLine;
    PQU : Result := cfPQULine;
    PRN : Result := cfPRNLine;

    TSH : Result := cfTSHLine;

    JCT : Result := cfJCTLine;
    JST : Result := cfJSTLine;
    JPT : Result := cfJPTLine;
    JPA : Result := cfJPALine;
    JSA : Result := cfJSALine;

    WOR : Result := cfWORLine;
  end; //case
end;

procedure TPIIScanner.LoadAccountContacts;
var
  Header : TPIIInfoHeader;
  ContactCount : Integer;
  i : integer;
  SaveParent : Integer;

begin
  FContactsManager := NewContactsManager;
  if Assigned(FContactsManager) then
  begin
    FContactsManager.SetCustomerRecord(FAccountRec.CustCode);
    ContactCount := FContactsManager.GetNumContacts;
    if ContactCount > 0 then
    begin
      Header := TPIIInfoHeader.Create(Self, PIIAccountContacts, CurrentParent, FList.Count,
                                     0, 0, 'Roles');
      FList.Add(Header);
      SaveParent := CurrentParent;
      CurrentParent := Header.Index;
      for i := 0 to ContactCount - 1 do
        ReadAccountContactFields(i);

      CurrentParent := SaveParent;
    end;

  end;
end;

procedure TPIIScanner.LoadLetters(const OwnerType: TPIIOwnerType;
  KeyString : Str255);
var
  RecAddress : longint;
  LMisc : MiscRec;
  iCount : Integer;
  Header : TPIIInfoHeader;
  SaveParent : Integer;
  LKeyString : Str255;

  procedure AddField;
  var
    LetterText : string;
  begin
    LMisc := MiscRec(FDataAccess.DataPointer^);
    LetterText := Trim(LMisc.btLetterRec.LtrDescr);
    if LetterText = '' then
      LetterText := Trim(LMisc.btLetterRec.LtrPath)
    else
      LetterText := Trim(LMisc.btLetterRec.LtrPath) + ', ' + LetterText;
    if (LetterText <> '') and
       (LMisc.btLetterRec.Version = DocWord95) then
    begin
      FList.Add(TPIIInfoItem.Create(Self, piiLetter, CurrentParent, FList.Count,
                                     PWrdF, RecAddress, LetterText));
      inc(iCount);
    end;
  end;

begin
  LKeyString := KeyString;
  if FDataAccess.FindFirst(dtLetter, OwnerType, LKeyString, RecAddress) then
  begin
    iCount := 0;
    Header := TPIIInfoHeader.Create(Self, piiLetterHeader, CurrentParent, FList.Count,
                                  PWrdF, RecAddress, '');
    Header.KeyString := KeyString;
    FList.Add(Header);
    SaveParent := CurrentParent;
    CurrentParent := FList.Count - 1;

    AddField;
    while FDataAccess.FindNext(dtLetter, OwnerType, LKeyString, RecAddress) do
    begin
      Application.ProcessMessages;
      AddField;
    end;

    //PR: 09/02/2018 ABSEXCH-19728 Check for consumer links with sub-type 'U'
    if OwnerType = otCustomer then
    begin
      LKeyString := KeyString;
      if FDataAccess.FindFirst(dtLetter, otConsumer, LKeyString, RecAddress) then
      begin
        AddField;
        while FDataAccess.FindNext(dtLetter, otConsumer, LKeyString, RecAddress) do
        begin
          Application.ProcessMessages;
          AddField;
        end;
      end;
    end;


    if iCount = 0 then //No letters found - remove header
      FList.Delete(FList.Count - 1)
    else //Update header display text with count
      Header.DisplayText := 'Letters (' + IntToStr(iCount) + ')';

    CurrentParent := SaveParent;
  end
  else
  if OwnerType = otCustomer then
    LoadLetters(otConsumer, KeyString);

end;

procedure TPIIScanner.LoadLinks(const OwnerType: TPIIOwnerType;
  KeyString : Str255);
var
  RecAddress : longint;
  LMisc : MiscRec;
  LinkText : string;
  iCount : Integer;
  Header : TPIIInfoHeader;
  SaveParent : Integer;
  LKeyString : Str255;

  procedure AddField;
  begin
    LMisc := MiscRec(FDataAccess.DataPointer^);
    LinkText := Trim(LMisc.btLinkRec.LtrDescr);

    if LinkText = '' then
      LinkText :=  Trim(LMisc.btLinkRec.LtrPath)
    else
      LinkText := Trim(LMisc.btLinkRec.LtrPath) + ', ' + LinkText;

    if (LinkText <> '') and
       (LMisc.btLinkRec.Version <> DocWord95) then
    begin
      FList.Add(TPIIInfoItem.Create(Self, piiLink, CurrentParent, FList.Count,
                                     PWrdF, RecAddress, LinkText));
      inc(iCount);
    end;
  end;


begin
  LKeyString := KeyString;
  if FDataAccess.FindFirst(dtLink, OwnerType, LKeyString, RecAddress) then
  begin
    iCount := 0;
    Header := TPIIInfoHeader.Create(Self, piiLinkHeader, CurrentParent, FList.Count,
                                  PWrdF, RecAddress, '');
    Header.KeyString := KeyString;
    FList.Add(Header);
    SaveParent := CurrentParent;
    CurrentParent := FList.Count - 1;

    AddField;
    while FDataAccess.FindNext(dtLink, OwnerType, LKeyString, RecAddress) do
    begin
      Application.ProcessMessages;
      AddField;
    end;


    //PR: 09/02/2018 ABSEXCH-19728 Check for consumer links with sub-type 'U'
    if OwnerType = otCustomer then
    begin
      LKeyString := KeyString;
      if FDataAccess.FindFirst(dtLink, otConsumer, LKeyString, RecAddress) then
      begin
        AddField;
        while FDataAccess.FindNext(dtLink, otConsumer, LKeyString, RecAddress) do
        begin
          Application.ProcessMessages;
          AddField;
        end;
      end;
    end;

    if iCount = 0 then //No links found - remove header
      FList.Delete(FList.Count - 1)
    else //Update header display text with count
      Header.DisplayText := 'Links (' + IntToStr(iCount) + ')';

    CurrentParent := SaveParent;
  end
  else
  if OwnerType = otCustomer then
    LoadLinks(otConsumer, KeyString);
end;

procedure TPIIScanner.LoadNotes(const OwnerType : TPIIOwnerType; KeyString : Str255);
var
  RecAddress : longint;
  LPword : PassWordRec;
  Header : TPIIInfoHeader;
  DatedCount, GeneralCount : Integer;
  LKeyString : string;

  procedure UpdateCount;
  begin
    if FDataAccess.ExLocal.LPassWord.NotesRec.NType = '1' then
      inc(GeneralCount)
    else if FDataAccess.ExLocal.LPassWord.NotesRec.NType = '2' then
      inc(DatedCount);
  end;

begin
  DatedCount := 0;
  GeneralCount := 0;
  if FDataAccess.FindFirst(dtNote, OwnerType, KeyString, RecAddress) then
  begin
    LKeyString := KeyString;
    UpdateCount;
    while FDataAccess.FindNext(dtNote, OwnerType, KeyString, RecAddress) do
    begin
      Application.ProcessMessages;
      UpdateCount;
    end;

    if DatedCount + GeneralCount > 0 then
    begin
      Header := TPIIInfoHeader.Create(Self, piiNote, CurrentParent, FList.Count,
                                      PWrdF, RecAddress, Format('Notes (%d General, %d Dated)',
                                      [GeneralCount, DatedCount]));
      Header.KeyString := LKeyString;
      FList.Add(Header);
    end;
  end;
end;

procedure TPIIScanner.LoadTransactionLines(const OwnerType: TPIIOwnerType;
  KeyString : Str255);
var
  RecAddress : integer;
  SaveParent : Integer;
  Header : TPIIInfoHeader;
  ThisIndex : Integer;
begin
  if FDataAccess.FindFirst(dtLine, OwnerType, KeyString, RecAddress, 0) and
     (FDataAccess.ExLocal.LId.FolioRef = FDataAccess.ExLocal.LInv.FolioNum) then
  begin
    Header := TPIIInfoHeader.Create(Self, PIITransactionLines, CurrentParent, FList.Count,
                                     IDetailF, 0, 'Lines');
    Header.KeyString := KeyString;
    ThisIndex := FList.Add(Header);
    SaveParent := CurrentParent;
    CurrentParent := FList.Count - 1;

    ReadLineFields(FDataAccess.ExLocal.LID, RecAddress);
    while FDataAccess.FindNext(dtLine, OwnerType, KeyString, RecAddress, 0) and
     (FDataAccess.ExLocal.LId.FolioRef = FDataAccess.ExLocal.LInv.FolioNum) do
     begin
       Application.ProcessMessages;
       ReadLineFields(FDataAccess.ExLocal.LID, RecAddress);
     end;
    CurrentParent := SaveParent;

    if ThisIndex = FList.Count - 1 then
      FList.Delete(ThisIndex);

  end;
end;

procedure TPIIScanner.LoadTransactions(const OwnerType: TPIIOwnerType;
  KeyString : Str255; const IndexNo   : Integer;
                               const HeaderText : string);
var
  RecAddress : integer;
  SaveParent : Integer;
  Header : TPIIInfoHeader;
begin
  if FDataAccess.FindFirst(dtTransaction, OwnerType, KeyString, RecAddress, IndexNo) then
  begin
    //Add header
    Header := TPIIInfoHeader.Create(Self, PIITransactions, CurrentParent, FList.Count,
                                     InvF, 0, HeaderText);
    Header.KeyString := KeyString;
    FList.Add(Header);
    SaveParent := CurrentParent;
    CurrentParent := FList.Count - 1;
    ReadTransactionFields(FDataAccess.ExLocal.LInv, RecAddress);
    while FDataAccess.FindNext(dtTransaction, OwnerType, KeyString, RecAddress, IndexNo) do
    begin
      Application.ProcessMessages;
      ReadTransactionFields(FDataAccess.ExLocal.LInv, RecAddress);
    end;

    CurrentParent := SaveParent;

    //If no children with PII date, remove header
    if Header.Index = FList.Count - 1 then
      FList.Delete(Header.Index);
  end;
end;

procedure TPIIScanner.ReadAccountContactFields(WhichContact : Integer);
var
  Header : TPIIInfoHeader;
  SaveParent : Integer;
  oContact : TAccountContact;
  AnAddress : TPIIAddressItem;
  Address : string;

  procedure AddField(FieldNo : TPIIFieldNo; const AText : string);
  begin
    if Trim(AText) <> '' then
      FList.Add(TPIIInfoItem.Create(Self, FieldNo, CurrentParent, FList.Count,
                                     0, -1, Trim(AText)));
  end;

begin
  oContact := FContactsManager.GetContact(WhichContact);
  Header := TPIIInfoHeader.Create(Self, PIIAccountContact, CurrentParent, FList.Count,
                                     0, WhichContact,
                                     Trim(oContact.contactDetails.acoContactName));
  FList.Add(Header);
  SaveParent := CurrentParent;
  CurrentParent := Header.Index;

  AddField(PIIAccountContactName, Trim(oContact.contactDetails.acoContactName));
  AddField(PIIAcContactJobTitle, oContact.contactDetails.acoContactJobTitle);
  AddField(PIIAcContactPhone, oContact.contactDetails.acoContactPhoneNumber);
  AddField(PIIAcContactFax, oContact.contactDetails.acoContactFaxNumber);
  AddField(PIIAcContactEmail, oContact.contactDetails.acoContactEmailAddress);

  if oContact.contactDetails.acoContactHasOwnAddress then
  begin
    Address := FormatAddress(oContact.contactDetails.acoContactAddress,
                             oContact.contactDetails.acoContactPostCode,
                             oContact.contactDetails.acoContactCountry);
    if Trim(Address) <> '' then
    begin
      AnAddress := TPIIAddressItem.Create(Self, PIIDeliveryAddress, CurrentParent, FList.Count,
                                         0, 0, Trim(Address),
                                         'Role');
      AnAddress.Address.Address := oContact.contactDetails.acoContactAddress;
      if Trim(oContact.contactDetails.acoContactPostCode) <> '' then
        AnAddress.Address.PostCode := oContact.contactDetails.acoContactPostCode;
      AnAddress.Address.Country := oContact.contactDetails.acoContactCountry;
      FList.Add(AnAddress);
    end;
  end;

  CurrentParent := SaveParent;
end;

procedure TPIIScanner.ReadAccountFields(const AccountRec  : CustRec; RecAddress : integer);
var
  cfCategory : Integer;
  IsCustomer : Boolean;
  AccountType : TPIIOwnerType;
  Header : TPIIInfoHeader;
  AnAddress : TPIIAddressItem;
  Address, TempS : string;


  procedure AddField(FieldNo : TPIIFieldNo; const AText : string; XMLText : string = '');
  begin
    if (Trim(AText) <> '') then
      FList.Add(TPIIInfoItem.Create(Self, FieldNo, CurrentParent, FList.Count,
                                     CustF, RecAddress, Trim(AText), XMLText));
  end;

begin
  IsCustomer := AccountRec.CustSupp = 'C';
  Header := TPIIInfoHeader.Create(Self, PIIAccount, CurrentParent, FList.Count,
                                       CustF, RecAddress,
                                       TraderTypeNameFromSubType(AccountRec.acSubType) +
                                       ': ' + AccountRec.CustCode + ' - ' +
                                       Trim(AccountRec.Company),
                                       TraderTypeNameFromSubType(AccountRec.acSubType));
  Header.KeyString := AccountRec.CustCode;
  FList.Add(Header);
  inc(CurrentParent);

  Address := FormatAddress(AccountRec.Addr, AccountRec.PostCode, AccountRec.acCountry);
  if Trim(Address) <> '' then
  begin

    AnAddress := TPIIAddressItem.Create(Self, PIIAddress, CurrentParent, FList.Count,
                                       CustF, RecAddress, Trim(Address),
                                       TraderTypeNameFromSubType(AccountRec.acSubType));
    AnAddress.Address.Address := AccountRec.Addr;
    if Trim(AccountRec.PostCode) <> '' then
      AnAddress.Address.PostCode := AccountRec.PostCode;
    AnAddress.Address.Country := AccountRec.AcCountry;
    FList.Add(AnAddress);
  end;

  Address := FormatAddress(AccountRec.DAddr, AccountRec.acDeliveryPostCode,
                             AccountRec.acDeliveryCountry);
  if Trim(Address) <> '' then
  begin

    AnAddress := TPIIAddressItem.Create(Self, PIIDeliveryAddress, CurrentParent, FList.Count,
                                       CustF, RecAddress, Trim(Address),
                                       TraderTypeNameFromSubType(AccountRec.acSubType) +
                                       '-DeliveryAddress');
    AnAddress.Address.Address := AccountRec.DAddr;
    if Trim(AccountRec.acDeliveryPostCode) <> '' then
      AnAddress.Address.PostCode := AccountRec.acDeliveryPostCode;
    AnAddress.Address.Country := AccountRec.AcDeliveryCountry;

    FList.Add(AnAddress);
  end;

  AddField(PIIPhone1, AccountRec.Phone);
  AddField(PIIPhone2, AccountRec.Phone2);
  AddField(PIIFax, AccountRec.Fax);
  AddField(PIIEmail, AccountRec.EmailAddr);
  AddField(PIIAcContact, AccountRec.Contact);

  AddField(PIIBankAC, DecryptBankAccountCode(AccountRec.acBankAccountCode));
  AddField(PIIBankSort, DecryptBankSortCode(AccountRec.acBankSortCode));
  AddField(PIIBankRef, AccountRec.BankRef);
  AddField(PIIBankMandate, DecryptBankMandateId(AccountRec.acMandateID));
  if IsCustomer and ValidDate(AccountRec.acMandateDate)then
    AddField(PIIBankMandateDate, AccountRec.acMandateDate);
  AddField(PIITheirAccount, AccountRec.RefNo);
  AddField(PIIVATRegNo, AccountRec.VATRegNo);

  ChangeCryptoKey (23130);
  AddField(PIIWebPassword, WebEncode(Decode(AccountRec.ebusPwrd)));

  if IsCustomer then
  begin
    cfCategory := cfCustomer;
    AccountType := otCustomer;
  end
  else
  begin
    AccountType := otSupplier;
    cfCategory := cfSupplier;
  end;

  if CustomFields[cfCategory, 1].cfContainsPIIData then
    AddField(PIIUDF1, AccountRec.UserDef1,
      CustomFields[cfCategory, 1].cfCaption);
  if CustomFields[cfCategory, 2].cfContainsPIIData then
    AddField(PIIUDF2, AccountRec.UserDef2,
      CustomFields[cfCategory, 2].cfCaption);
  if CustomFields[cfCategory, 3].cfContainsPIIData then
    AddField(PIIUDF3, AccountRec.UserDef3,
      CustomFields[cfCategory, 3].cfCaption);
  if CustomFields[cfCategory, 4].cfContainsPIIData then
    AddField(PIIUDF4, AccountRec.UserDef4,
      CustomFields[cfCategory, 4].cfCaption);
  if CustomFields[cfCategory, 5].cfContainsPIIData then
    AddField(PIIUDF5, AccountRec.UserDef5,
      CustomFields[cfCategory, 5].cfCaption);
  if CustomFields[cfCategory, 6].cfContainsPIIData then
    AddField(PIIUDF6, AccountRec.UserDef6,
      CustomFields[cfCategory, 6].cfCaption);
  if CustomFields[cfCategory, 7].cfContainsPIIData then
    AddField(PIIUDF7, AccountRec.UserDef7,
      CustomFields[cfCategory, 7].cfCaption);
  if CustomFields[cfCategory, 8].cfContainsPIIData then
    AddField(PIIUDF8, AccountRec.UserDef8,
      CustomFields[cfCategory, 8].cfCaption);
  if CustomFields[cfCategory, 9].cfContainsPIIData then
    AddField(PIIUDF9, AccountRec.UserDef9,
      CustomFields[cfCategory, 9].cfCaption);
  if CustomFields[cfCategory, 10].cfContainsPIIData then
    AddField(PIIUDF10, AccountRec.UserDef10,
      CustomFields[cfCategory, 10].cfCaption);
  if CustomFields[cfCategory, 11].cfContainsPIIData then
    AddField(PIIUDF11, AccountRec.CCDCardNo,
      CustomFields[cfCategory, 11].cfCaption);
  if CustomFields[cfCategory, 12].cfContainsPIIData then
    if ValidDate(AccountRec.CCDSDate) then
      AddField(PIIUDF12, POutDate(AccountRec.CCDSDate),
       CustomFields[cfCategory, 12].cfCaption);
  if CustomFields[cfCategory, 13].cfContainsPIIData then
    if ValidDate(AccountRec.CCDEDate) then
      AddField(PIIUDF13, POutDate(AccountRec.CCDEDate),
       CustomFields[cfCategory, 13].cfCaption);
  if CustomFields[cfCategory, 14].cfContainsPIIData then
    AddField(PIIUDF14, AccountRec.CCDName,
     CustomFields[cfCategory, 14].cfCaption);
  if CustomFields[cfCategory, 15].cfContainsPIIData then
    AddField(PIIUDF15, AccountRec.CCDSARef,
     CustomFields[cfCategory, 15].cfCaption);

  LoadAccountContacts;

  //Check for contacts plugin
  if TableExists(GetEnterpriseDirectory + 'Contact.dat') then
    LoadPluginContacts(FAccountRec.CustCode);

  LoadNotes(AccountType, FullCustCode(FAccountRec.CustCode));
  LoadLinks(AccountType, FullCustCode(FAccountRec.CustCode));
  LoadLetters(AccountType, FullCustCode(FAccountRec.CustCode));

  if JBCostOn then
  begin
    if IsCustomer then
      LoadJobs(FAccountRec.CustCode)
    else
      LoadEmployees(FAccountRec.CustCode);
  end;

  //Transactions
  LoadTransactions(AccountType, FullCustCode(FAccountRec.CustCode), InvCustK, 'Transactions');

  if TableExists(SetDrive + EBUS_TRANS_FILE) then
    LoadEbusTransactions(FAccountRec.CustCode);

end;

procedure TPIIScanner.ReadContactFields(const ContactRec  : TContactRecType; RecAddress : Integer);
var
  SaveParent : Integer;
  AnAddress : TPIIAddressItem;
  Address : string;
  LAdd : AddrTyp;

  procedure AddField(FieldNo : TPIIFieldNo; const AText : string);
  begin
    if Trim(AText) <> '' then
      FList.Add(TPIIInfoItem.Create(Self, FieldNo, CurrentParent, FList.Count,
                                     ContactsF, RecAddress, Trim(AText)));
  end;

begin
  FList.Add(TPIIInfoHeader.Create(Self, PIIPlugInContact, CurrentParent, FList.Count,
                                       ContactsF, RecAddress, Trim(ContactRec.coFirstName) +
                                       ' ' + Trim(ContactRec.coSurname)));
  SaveParent := CurrentParent;
  CurrentParent := FList.Count - 1;

  AddField(PIIPlugInContactName, Trim(ContactRec.coTitle) + ' ' + Trim(ContactRec.coFirstName) +
                                       ' ' + Trim(ContactRec.coSurname));

  AddField(PIIPlugInContactSalutation, ContactRec.coSalutation);
  AddField(PIIPlugInContactJob, ContactRec.coPosition);
  AddField(PIIPlugInContactPhone, ContactRec.coContactNo);
  AddField(PIIPlugInContactFax, ContactRec.coFaxNumber);
  AddField(PIIPlugInContactEmail, ContactRec.coEmailAddr);


  LAdd[1] := Trim(ContactRec.coAddress1);
  LAdd[2] := Trim(ContactRec.coAddress2);
  LAdd[3] := Trim(ContactRec.coAddress3);
  LAdd[4] := Trim(ContactRec.coAddress4);
  LAdd[5] := '';

  Address := FormatAddress(LAdd, ContactRec.coPostCode, '');
  if Trim(Address) <> '' then
  begin

    AnAddress := TPIIAddressItem.Create(Self, PIIAddress, CurrentParent, FList.Count,
                                       ContactsF, RecAddress, Trim(Address),
                                       'Contact');
    AnAddress.Address.Address := LAdd;
    if Trim(ContactRec.coPostCode) <> '' then
      AnAddress.Address.PostCode :=Trim(ContactRec.coPostCode);
    FList.Add(AnAddress);
  end;

  CurrentParent := SaveParent;
end;

procedure TPIIScanner.ReadEmployeeFields(const EmployeeRec  : EmplType; RecAddress : integer);
var
  SaveParent : Integer;
  AnAddress : TPIIAddressItem;
  Address : string;

  procedure AddField(FieldNo : TPIIFieldNo; const AText : string; XMLDesc : string = '');
  begin
    if Trim(AText) <> '' then
      FList.Add(TPIIInfoItem.Create(Self, FieldNo, CurrentParent, FList.Count,
                                     JMiscF, RecAddress, Trim(AText), XMLDesc));
  end;


begin
  //Load PII fields from Employee record
  FList.Add(TPIIInfoHeader.Create(Self, PIIEmployee, CurrentParent, FList.Count,
                                       JMiscF, RecAddress, dbFormatName(EmployeeRec.EmpCode,
                                        EmployeeRec.EmpName)));
  SaveParent := CurrentParent;
  CurrentParent := FList.Count - 1;

  AddField(PIIEmployeeName, Trim(EmployeeRec.EmpName));
  Address := FormatAddress(EmployeeRec.Addr, '', '');
  if Trim(Address) <> '' then
  begin

    AnAddress := TPIIAddressItem.Create(Self, PIIAddress, CurrentParent, FList.Count,
                                       JMiscF, RecAddress, Trim(Address), 'Employee');
    AnAddress.Address.Address := EmployeeRec.Addr;
    FList.Add(AnAddress);
  end;

  AddField(PIIPhone1, EmployeeRec.Phone);
  AddField(PIIPhone2, EmployeeRec.Phone2);
  AddField(PIIFax, EmployeeRec.Fax);
  AddField(PIIEmail, EmployeeRec.emEmailAddr);
  AddField(PIIEmpSupplier, EmployeeRec.Supplier);
  AddField(PIIEmpPayrollNo, EmployeeRec.PayNo);
  AddField(PIIEmpNINumber, EmployeeRec.ENINo);
  AddField(PIIEmpUTR, EmployeeRec.UTRCode);
  AddField(PIIEmpCRN, EmployeeRec.CertNo);
  AddField(PIIVerifyNo, EmployeeRec.VerifyNo);

  //Only load UDFs if they have PII info
  if CustomFields[cfEmployee, 1].cfContainsPIIData then
    AddField(PIIUDF1, EmployeeRec.UserDef1, CustomFields[cfEmployee, 1].cfCaption);
  if CustomFields[cfEmployee, 2].cfContainsPIIData then
    AddField(PIIUDF2, EmployeeRec.UserDef2, CustomFields[cfEmployee, 2].cfCaption);
  if CustomFields[cfEmployee, 3].cfContainsPIIData then
    AddField(PIIUDF3, EmployeeRec.UserDef3, CustomFields[cfEmployee, 3].cfCaption);
  if CustomFields[cfEmployee, 4].cfContainsPIIData then
    AddField(PIIUDF4, EmployeeRec.UserDef4, CustomFields[cfEmployee, 4].cfCaption);

  Application.ProcessMessages;

  LoadNotes(otEmployee, FullNCode(EmployeeRec.EmpCode));
  LoadLetters(otEmployee, FullNCode(EmployeeRec.EmpCode));
  LoadLinks(otEmployee, FullNCode(EmployeeRec.EmpCode));

  //Timesheets
  LoadTransactions(otEmployee, FullNCode(EmployeeRec.EmpCode), InvBatchK, 'Timesheets');
  //Terms
  LoadTransactions(otEmployee, #5 + FullEmpCode(EmployeeRec.EmpCode), InvBatchK, 'Terms');
  //Applications
  LoadTransactions(otEmployee, #6 + FullEmpCode(EmployeeRec.EmpCode), InvBatchK, 'Applications');

  LoadCISVouchers(EmployeeRec.EmpCode);
  CurrentParent := SaveParent;
end;

procedure TPIIScanner.ReadLineFields(const ADetail: IDetail; RecAddress : integer);
var
  cfCategory : Integer;
  SaveParent : Integer;
  Header : TPIIInfoHeader;
  ThisIndex : Integer;

  procedure AddField(FieldNo : TPIIFieldNo; const AText : string; XMLText : string = '');
  begin
    if Trim(AText) <> '' then
      FList.Add(TPIIInfoItem.Create(Self, FieldNo, CurrentParent, FList.Count,
                                     IDetailF, RecAddress, Trim(AText), XMLText));
  end;


begin

  Header := TPIIInfoHeader.Create(Self, PIITransactionLine, CurrentParent, FList.Count,
                                     IDetailF, RecAddress, 'Line ' + IntToStr(ADetail.LineNo),
                                      IntToStr(ADetail.LineNo));
  ThisIndex := FList.Add(Header);

  //Save current parent
  SaveParent := CurrentParent;

  //set current parent to this transaction
  CurrentParent := FList.Count - 1;

  cfCategory := DocTypeToCFCategory(ADetail.IdDocHed, True);
  //Only load UDFs if they have PII info
  if CustomFields[cfCategory, 1].cfContainsPIIData then
    AddField(PIIUDF1, ADetail.LineUser1,
      CustomFields[cfCategory, 1].cfCaption);
  if CustomFields[cfCategory, 2].cfContainsPIIData then
    AddField(PIIUDF2, ADetail.LineUser2,
      CustomFields[cfCategory, 2].cfCaption);
  if CustomFields[cfCategory, 3].cfContainsPIIData then
    AddField(PIIUDF3, ADetail.LineUser3,
      CustomFields[cfCategory, 3].cfCaption);
  if CustomFields[cfCategory, 4].cfContainsPIIData then
    AddField(PIIUDF4, ADetail.LineUser4,
      CustomFields[cfCategory, 4].cfCaption);
  if CustomFields[cfCategory, 5].cfContainsPIIData then
    AddField(PIIUDF5, ADetail.LineUser5,
      CustomFields[cfCategory, 5].cfCaption);
  if CustomFields[cfCategory, 6].cfContainsPIIData then
    AddField(PIIUDF6, ADetail.LineUser6,
      CustomFields[cfCategory, 6].cfCaption);
  if CustomFields[cfCategory, 7].cfContainsPIIData then
    AddField(PIIUDF7, ADetail.LineUser7,
      CustomFields[cfCategory, 7].cfCaption);
  if CustomFields[cfCategory, 8].cfContainsPIIData then
    AddField(PIIUDF8, ADetail.LineUser8,
      CustomFields[cfCategory, 8].cfCaption);
  if CustomFields[cfCategory, 9].cfContainsPIIData then
    AddField(PIIUDF9, ADetail.LineUser9,
      CustomFields[cfCategory, 9].cfCaption);
  if CustomFields[cfCategory, 10].cfContainsPIIData then
    AddField(PIIUDF10, ADetail.LineUser10,
      CustomFields[cfCategory, 10].cfCaption);

  if ThisIndex = FList.Count - 1 then
    FList.Delete(ThisIndex);

  CurrentParent := SaveParent;
end;

procedure TPIIScanner.LoadPluginContacts(const ACode: string);
var
  Header : TPIIInfoHeader;
  SaveParent : Integer;
  Res : Integer;
  KeyS, KeyChk : Str255;
  RecAddress : Longint;
begin
  //Add header
  Header := TPIIInfoHeader.Create(Self, PIIPluginContacts, CurrentParent, FList.Count,
                                     IDetailF, 0, 'Contacts Plug-in');
  Header.KeyString := ACode;
  FList.Add(Header);

  SaveParent := CurrentParent;
  CurrentParent := Header.Index;

  //Find records
  KeyS := FullCustCode(CompanyCodeForPIIScanner) + FullCustCode(ACode);
  KeyChk := KeyS;
  with FContactsFile do
  begin
    Res := GetGreaterThanOrEqual(KeyS);

    while (Res = 0) and (ContactRec.coCompany = CompanyCodeForPIIScanner) and
                        (Trim(ContactRec.coAccount) = Trim(ACode)) do
    begin
      GetPosition(RecAddress);
      ReadContactFields(ContactRec, RecAddress);

      Res := GetNext;
    end;
  end;

  CurrentParent := SaveParent;

  //If no children remove header
  if Header.Index = FList.Count - 1 then
    FList.Delete(Header.Index);
end;

procedure TPIIScanner.ReadTransactionFields(const AnInv  : InvRec; RecAddress : integer);
var
  cfCategory : Integer;
  PreviousParent : Integer;
  Header : TPIIInfoHeader;
  ThisIndex : Integer;
  AnAddress : TPIIAddressItem;
  Address : string;

  procedure AddField(FieldNo : TPIIFieldNo; const AText : string; XMLText : string = '');
  begin
    if Trim(AText) <> '' then
      FList.Add(TPIIInfoItem.Create(Self, FieldNo, CurrentParent, FList.Count,
                                     InvF, RecAddress, Trim(AText), XMLText));
  end;


begin
  if AnInv.InvDocHed in [WOR] then
    EXIT;
  Header := TPIIInfoHeader.Create(Self, PIITransaction, CurrentParent, FList.Count,
                                     InvF, RecAddress, AnInv.OurRef, DocNames[AnInv.InvDocHed]);
  Header.KeyString := AnInv.OurRef;
  ThisIndex := FList.Add(Header);

  //Save current parent
  PreviousParent := CurrentParent;

  //set current parent to this transaction
  CurrentParent := FList.Count - 1;

  AddField(PIITransactionReference, AnInv.OurRef);

  if not (AnInv.InvDocHed in [SRC, PPY]) then
    Address := FormatAddress(AnInv.DAddr, AnInv.thDeliveryPostCode, AnInv.thDeliveryCountry)
  else
    Address := FormatAddress(AnInv.DAddr, '', '');

  if Trim(Address) <> '' then
  begin
    if not (AnInv.InvDocHed in [SRC, PPY]) then
    begin
      AnAddress := TPIIAddressItem.Create(Self, PIIDeliveryAddress, CurrentParent, FList.Count,
                                         InvF, RecAddress, Trim(Address),
                                         'Transaction-DeliveryAddress');
      AnAddress.Address.Address := AnInv.DAddr;
      AnAddress.Address.Country := AnInv.thDeliveryCountry;
      AnAddress.Address.PostCode := AnInv.thDeliveryPostCode;
    end
    else
    begin
      AnAddress := TPIIAddressItem.Create(Self, PIIPayDetails, CurrentParent, FList.Count,
                                         InvF, RecAddress, Trim(Address),
                                         'PaymentDetails');
      AnAddress.Address.Address := AnInv.DAddr;
      AnAddress.Address.Country := '';
      AnAddress.Address.PostCode := '';
    end;
    FList.Add(AnAddress);
  end;

  //Header category is line category - 1
  cfCategory := DocTypeToCFCategory(AnInv.InvDocHed);
  //Only load UDFs if they have PII info
  if CustomFields[cfCategory, 1].cfContainsPIIData then
    AddField(PIIUDF1, AnInv.DocUser1,
       CustomFields[cfCategory, 1].cfCaption);
  if CustomFields[cfCategory, 2].cfContainsPIIData then
    AddField(PIIUDF2, AnInv.DocUser2,
      CustomFields[cfCategory, 2].cfCaption);
  if CustomFields[cfCategory, 3].cfContainsPIIData then
    AddField(PIIUDF3, AnInv.DocUser3,
      CustomFields[cfCategory, 3].cfCaption);
  if CustomFields[cfCategory, 4].cfContainsPIIData then
    AddField(PIIUDF4, AnInv.DocUser4,
      CustomFields[cfCategory, 4].cfCaption);
  if CustomFields[cfCategory, 5].cfContainsPIIData then
    AddField(PIIUDF5, AnInv.DocUser5,
      CustomFields[cfCategory, 5].cfCaption);
  if CustomFields[cfCategory, 6].cfContainsPIIData then
    AddField(PIIUDF6, AnInv.DocUser6,
      CustomFields[cfCategory, 6].cfCaption);
  if CustomFields[cfCategory, 7].cfContainsPIIData then
    AddField(PIIUDF7, AnInv.DocUser7,
      CustomFields[cfCategory, 7].cfCaption);
  if CustomFields[cfCategory, 8].cfContainsPIIData then
    AddField(PIIUDF8, AnInv.DocUser8,
      CustomFields[cfCategory, 8].cfCaption);
  if CustomFields[cfCategory, 9].cfContainsPIIData then
    AddField(PIIUDF9, AnInv.DocUser9,
      CustomFields[cfCategory, 9].cfCaption);
  if CustomFields[cfCategory, 10].cfContainsPIIData then
    AddField(PIIUDF10, AnInv.DocUser10,
      CustomFields[cfCategory, 10].cfCaption);
  if CustomFields[cfCategory, 11].cfContainsPIIData then
    AddField(PIIUDF11, AnInv.thUserField11,
      CustomFields[cfCategory, 11].cfCaption);
  if CustomFields[cfCategory, 12].cfContainsPIIData then
    AddField(PIIUDF12, AnInv.thUserField12,
      CustomFields[cfCategory, 12].cfCaption);

  LoadTransactionLines(otTransaction, FullNomKey(AnInv.FolioNum));
  LoadNotes(otTransaction, FullNomKey(AnInv.FolioNum));
  LoadLetters(otTransaction, FullNomKey(AnInv.FolioNum));
  LoadLinks(otTransaction, FullNomKey(AnInv.FolioNum));

  //Restore current parent
  CurrentParent := PreviousParent;

  //Check if we've found any PII fields for this transaction; if not remove it
  //from tree. Note that we've added the OurRef, so take account of that
  if ThisIndex = FList.Count - 2 then
  begin
    FList.Delete(FList.Count -1);
    FList.Delete(FList.Count -1);
  end;

end;

//==============================================================================

procedure TPIIScanner.WriteToXML(const FileName: string; IncludeNotes : Boolean);
var
  RootNode : TGmXmlNode;
begin
  FXMLIncludeNotes := IncludeNotes;
  FXml := TGmXml.Create(nil);
  Try
    FXml.Encoding := 'UTF-8';
    RootNode := FXml.Nodes.AddOpenTag('GDPRAccessReport');
    if FScanType = pstTrader then
      XMLWriteAccount(GetPIITree, RootNode)
    else
      XMLWriteEmployee(GetPIITree, RootNode);

    Fxml.Nodes.AddCloseTag;
    FXml.SaveToFile(Filename);
  Finally
    FreeAndNil(FXml);
  End;
end;

procedure TPIIScanner.LoadEmployees(const ACode: string);
var
  Header : TPIIInfoHeader;
  RecAddress : Integer;
  KeyString : Str255;
  SaveParent : Integer;
begin
  KeyString := FullCustcode(ACode);
  if FDataAccess.FindFirst(dtEmployee, otSupplier, KeyString, RecAddress, JMTrdK) then
  begin
    Header := TPIIInfoHeader.Create(Self, PIIEmployees, CurrentParent, FList.Count,
                                  JMiscF, RecAddress, 'Employees');
    Header.KeyString := KeyString;
    FList.Add(Header);
    SaveParent := CurrentParent;
    CurrentParent := Header.Index;
    ReadEmployeeFields(FDataAccess.ExLocal.LJobMisc.EmplRec, RecAddress);

    while FDataAccess.FindNext(dtEmployee, otSupplier, KeyString, RecAddress, JMTrdK) do
      ReadEmployeeFields(FDataAccess.ExLocal.LJobMisc.EmplRec, RecAddress);

    CurrentParent := SaveParent;
  end;
end;

procedure TPIIScanner.LoadJobs(const ACode: string);
var
  Header : TPIIInfoHeader;
  RecAddress : Integer;
  KeyString : Str255;
  SaveParent : Integer;
begin
  KeyString := FullCustcode(ACode);
  if FDataAccess.FindFirst(dtJob, otCustomer, KeyString, RecAddress, 7) then
  begin
    Header := TPIIInfoHeader.Create(Self, piiJobs, CurrentParent, FList.Count,
                                  JobF, RecAddress, 'Jobs');
    Header.KeyString := KeyString;
    FList.Add(Header);
    SaveParent := CurrentParent;
    CurrentParent := Header.Index;
    ReadJobFields(FDataAccess.ExLocal.LJobRec^, RecAddress);

    while FDataAccess.FindNext(dtJob, otCustomer, KeyString, RecAddress, 7) do
      ReadJobFields(FDataAccess.ExLocal.LJobRec^, RecAddress);

    CurrentParent := SaveParent;
  end;
end;

procedure TPIIScanner.ReadJobFields(AJobRec: JobRecType; RecAddress : Integer);
var
  PreviousParent : Integer;
  Header : TPIIInfoHeader;

  procedure AddField(FieldNo : TPIIFieldNo; const AText : string; XMLText : string = '');
  begin
    if Trim(AText) <> '' then
      FList.Add(TPIIInfoItem.Create(Self, FieldNo, CurrentParent, FList.Count,
                                     JobF, RecAddress, Trim(AText), XMLText));
  end;
begin
  Header := TPIIInfoHeader.Create(Self, PIIJob, CurrentParent, FList.Count,
                                     JobF, RecAddress, Trim(AJobRec.JobCode), Trim(AJobRec.JobCode));
  Header.KeyString := AJobRec.JobCode;
  FList.Add(Header);

  //Save current parent
  PreviousParent := CurrentParent;
  //set current parent to this transaction
  CurrentParent := FList.Count - 1;

  AddField(PIIJobDescription, AJobRec.JobDesc);
  AddField(PIIJobContact, AJobRec.Contact);
  AddField(PIIJobManager, AJobRec.JobMan);

  if CustomFields[cfJob, 1].cfContainsPIIData then
    AddField(PIIUDF1, AJobRec.UserDef1,
      CustomFields[cfJob, 1].cfCaption);
  if CustomFields[cfJob, 2].cfContainsPIIData then
    AddField(PIIUDF2, AJobRec.UserDef2,
      CustomFields[cfJob, 2].cfCaption);
  if CustomFields[cfJob, 3].cfContainsPIIData then
    AddField(PIIUDF3, AJobRec.UserDef3,
      CustomFields[cfJob, 3].cfCaption);
  if CustomFields[cfJob, 4].cfContainsPIIData then
    AddField(PIIUDF4, AJobRec.UserDef4,
      CustomFields[cfJob, 4].cfCaption);
  if CustomFields[cfJob, 5].cfContainsPIIData then
    AddField(PIIUDF5, AJobRec.UserDef5,
      CustomFields[cfJob, 5].cfCaption);
  if CustomFields[cfJob, 6].cfContainsPIIData then
    AddField(PIIUDF6, AJobRec.UserDef6,
      CustomFields[cfJob, 6].cfCaption);
  if CustomFields[cfJob, 7].cfContainsPIIData then
    AddField(PIIUDF7, AJobRec.UserDef7,
      CustomFields[cfJob, 7].cfCaption);
  if CustomFields[cfJob, 8].cfContainsPIIData then
    AddField(PIIUDF8, AJobRec.UserDef8,
      CustomFields[cfJob, 8].cfCaption);
  if CustomFields[cfJob, 9].cfContainsPIIData then
    AddField(PIIUDF9, AJobRec.UserDef9,
      CustomFields[cfJob, 9].cfCaption);
  if CustomFields[cfJob, 10].cfContainsPIIData then
    AddField(PIIUDF10, AJobRec.UserDef10,
      CustomFields[cfJob, 10].cfCaption);


  LoadNotes(otJob, FullNomKey(AJobRec.JobFolio));
  LoadLetters(otJob, FullNomKey(AJobRec.JobFolio));
  LoadLinks(otJob, FullNomKey(AJobRec.JobFolio));

  CurrentParent := PreviousParent;
end;

procedure TPIIScanner.LoadEbusTransactions(KeyString: Str255);
var
  RecAddress : integer;
  SaveParent : Integer;
  Header : TPIIInfoHeader;
  Res : Integer;
begin
  FEbusTrans := TEbusTransFile.Create(SetDrive);
  Res := FEbusTrans.OpenFile;
  if Res = 0 then
  with FEbusTrans do
  begin
    Index := InvCustK;
    Res := GetGreaterThanOrEqual(KeyString);
    if Res = 0 then
    begin
      //Add header
      Header := TPIIInfoHeader.Create(Self, PIIEbusTransactions, CurrentParent, FList.Count,
                                       EbusTransF, 0, 'e-Business Transactions');
      Header.KeyString := KeyString;
      FList.Add(Header);
      SaveParent := CurrentParent;
      CurrentParent := FList.Count - 1;
      while (Res = 0) and (TransRec.CustCode = KeyString) do
      begin
        GetPosition(RecAddress);
        ReadEBusTransactionFields(TransRec, RecAddress);

        Res := GetNext;
      end;

      CurrentParent := SaveParent;

      //If no children with PII date, remove header
      if Header.Index = FList.Count - 1 then
        FList.Delete(Header.Index);
    end;
  end;
end;

procedure TPIIScanner.ReadEbusTransactionFields(const AnInv: InvRec;
  RecAddress: integer);
var
  PreviousParent : Integer;
  Header : TPIIInfoHeader;
  AnAddress : TPIIAddressItem;
  Address : string;
  ThisIndex : Integer;

  procedure AddField(FieldNo : TPIIFieldNo; const AText : string; XMLText : string = '');
  begin
    if Trim(AText) <> '' then
      FList.Add(TPIIInfoItem.Create(Self, FieldNo, CurrentParent, FList.Count,
                                     EbusTransF, RecAddress, Trim(AText)));
  end;
begin

  Header := TPIIInfoHeader.Create(Self, PIIEbusTransaction, CurrentParent, FList.Count,
                                     EbusTransF, RecAddress, AnInv.OurRef, DocNames[AnInv.InvDocHed]);
  Header.KeyString := AnInv.OurRef;
  ThisIndex := FList.Add(Header);

  //Save current parent
  PreviousParent := CurrentParent;

  //set current parent to this transaction
  CurrentParent := FList.Count - 1;

  AddField(PIITransactionReference, AnInv.OurRef);

  Address := FormatAddress(AnInv.DAddr, '', AnInv.thDeliveryCountry);
  if Trim(Address) <> '' then
  begin

    AnAddress := TPIIAddressItem.Create(Self, PIIDeliveryAddress, CurrentParent, FList.Count,
                                       EbusTransF, RecAddress, Trim(Address),
                                       'Transaction-DeliveryAddress');
    AnAddress.Address.Address := AnInv.DAddr;
    AnAddress.Address.Country := AnInv.thDeliveryCountry;
    FList.Add(AnAddress);
  end;

  //Check if we've found any PII fields for this transaction; if not remove it
  //from tree. Note that we've added the OurRef, so take account of that
  if ThisIndex = FList.Count - 2 then
  begin
    FList.Delete(FList.Count -1);
    FList.Delete(FList.Count -1);
  end;

end;

procedure TPIIScanner.LoadCISVouchers(const EmpCode: string);
var
  SaveParent : Integer;
  RecAddress : integer;
  KeyString : Str255;
  Header : TPIIInfoHeader;
begin

  KeyString := EmpCode;
  if FDataAccess.FindFirst(dtCISVoucher, otEmployee, KeyString, RecAddress, 0) then
  begin

    Header := TPIIInfoHeader.Create(Self, PIIEmpCISVouchers, CurrentParent, FList.Count,
                                     JDetlF, 0, 'CIS Vouchers');
    Header.KeyString := KeyString;
    FList.Add(Header);
    SaveParent := CurrentParent;
    CurrentParent := FList.Count - 1;

    ReadCISVoucherFields(FDataAccess.ExLocal.LJobDetl.JobCISV, RecAddress);

    while FDataAccess.FindNext(dtCISVoucher, otEmployee, KeyString, RecAddress, 0) do
      ReadCISVoucherFields(FDataAccess.ExLocal.LJobDetl.JobCISV, RecAddress);


    CurrentParent := SaveParent;
  end;
end;

function TPIIScanner.ScanComplete: Boolean;
begin
  Result := FScanComplete;
end;


procedure TPIIScanner.XMLWriteAccount(const Item: IPIIInfoItem;
  const ANode: TGmXmlNode);
begin
  ANode.Attributes.AddAttribute('EntityType',
                                 TraderTypeNameFromSubType(FAccountRec.acSubType));
  ANode.Attributes.AddAttribute('EntityDescripton',
                                  WebEncode(dbFormatName(FAccountRec.CustCode,
                                  FAccountRec.Company)));
  XMLWrite(Item.Children, ANode);

  ANode.Children.AddCloseTag;
end;

procedure TPIIScanner.XMLWriteAddress(const Item : IPIIAddressItem;
  const ANode: TGmXmlNode);
var
  ThisNode, LineNode : TGmXmlNode;
  i : Integer;
  Address : TPIIInfoAddress;

  function FormatCountry(const CCode : string) : string;
  begin
    Result := CountryCodeName(ifCountry2, CCode) + ' (' + CCode + ')';
  end;
begin
  ThisNode := ANode.Children.AddOpenTag('Address');
  ThisNode.Attributes.AddAttribute('Type', Item.XMLDescription);

  Address := Item.Address;
  for i := 1 to 5 do
  begin
    if Trim(Address.Address[i]) <> '' then
    begin
      LineNode := ThisNode.Children.AddLeaf('AddressLine');
      LineNode.AsString := WebEncode(Address.Address[i]);
      LineNode.Attributes.AddAttribute('Description', CustomFields[cfAddressLabels, i].cfCaption);
    end;
  end;
  if Trim(Address.PostCode) <> '' then
  begin
    LineNode := ThisNode.Children.AddLeaf('PostCode');
    LineNode.AsString := Address.PostCode;
  end;
  if Trim(Address.Country) <> '' then
  begin
    LineNode := ThisNode.Children.AddLeaf('Country');
    LineNode.AsString := FormatCountry(Address.Country);
  end;

  ANode.Children.AddCloseTag;
end;

procedure TPIIScanner.XMLWriteEmployee(const Item: IPIIInfoItem;
  const ANode: TGmXmlNode);
begin
  if FScanType = pstEmployee then
  begin
    ANode.Attributes.AddAttribute('EntityType', 'Employee');
    ANode.Attributes.AddAttribute('EntityDescripton',
                                  dbFormatName(FEmployeeRec.EmpCode,
                                  WebEncode(FEmployeeRec.EmpName)));
  end;
  XMLWrite(Item.Children, ANode);

  ANode.Children.AddCloseTag;
end;

procedure TPIIScanner.XMLWriteNotes(const Item: IPIIInfoHeader;
  const ANode: TGmXmlNode);
var
  KeyS : Str255;
  Res : Boolean;
  HeaderNode : TGmXmlNode;
  NoteNode : TGmXmlNode;
  OwnerType : TPIIOwnerType;
  RecAddress : Integer;

begin
  if FXMLIncludeNotes then
  begin
    KeyS := Copy(Item.KeyString, 3, Length(Item.KeyString));
    OwnerType := GetNoteOwnerType(Item.KeyString[2]);
    Res := FDataAccess.FindFirst(dtNote, OwnerType, KeyS, RecAddress);
    if Res then
    begin
      HeaderNode := ANode.Children.AddOpenTag('Notes');
      while Res do
      with FDataAccess.ExLocal.LPassWord.NotesRec do
      begin
        if NType <> '3' then
        begin
          NoteNode := HeaderNode.Children.AddOpenTag('Note');
          if NType = '1' then
            NoteNode.Attributes.AddAttribute('Type', 'General')
          else
          begin
            NoteNode.Attributes.AddAttribute('Type', 'Dated');
            NoteNode.Children.AddLeaf('Date').AsString := Copy(NoteDate, 1, 4)+ '-' +
                                     Copy(NoteDate, 5, 2) + '-' + Copy(NoteDate, 7, 2);
          end;
          NoteNode.Children.AddLeaf('Text').AsString := WebEncode(NoteLine);
          HeaderNode.Children.AddCloseTag;
        end; //not audit note

        Res := FDataAccess.FindNext(dtNote, OwnerType, KeyS, RecAddress);
      end;
      ANode.Children.AddCloseTag;
    end;
  end;
end;


procedure TPIIScanner.XMLWrite(const ItemList: IPIIInfoList;
  const ANode: TGmXmlNode);
var
  ThisNode : TGmXmlNode;
  i : integer;
  ThisItem : IPIIInfoItem;
  UDFNode : TGmXmlNode;
begin
  UDFNode := nil;
  for i := 0 to ItemList.Count - 1 do
  begin
    ThisItem := ItemList[i];
    //Special handling needed
    Case ThisItem.FieldType of
      PIINote : XMLWriteNotes(ThisItem as IPIIInfoHeader, ANode);
      PIIUDF1..PIIUDF15
              : begin
                  if not Assigned(UDFNode) then
                  begin
                    UDFNode := ANode.Children.AddLeaf('UserDefinedFields');
                  end;
                  XMLWriteUDF(ThisItem, UDFNode);
                end;
      PIIAddress,
      PIIDeliveryAddress
              : XMLWriteAddress(ThisItem as IPIIAddressItem, ANode);
      PIIPayDetails
              : XMLWritePaymentDetails(ThisItem as IPIIAddressItem, ANode);
      else
      if (ThisItem.ItemType = itItem) and XMLInclude(ThisItem.FieldType) then
      begin
        ThisNode := ANode.Children.AddLeaf(XMLText(ThisItem.FieldType));
        ThisNode.AsString := WebEncode(ThisItem.Text);
        if ThisItem.XMLDescription <> '' then
          ThisNode.Attributes.AddAttribute(XMLAttributeType(ThisItem.FieldType), ThisItem.XMLDescription);
      end
      else
      begin //Header
        if ThisItem.HasChildren then
        begin
          ThisNode := ANode.Children.AddOpenTag(XMLText(ThisItem.FieldType));
          if ThisItem.XMLDescription <> '' then
            ThisNode.Attributes.AddAttribute(XMLAttributeType(ThisItem.FieldType), ThisItem.XMLDescription);
          XMLWrite(ThisItem.Children, ThisNode);
          ANode.Children.AddCloseTag;
        end;
      end;
    End; //Case
  end;
end;

procedure TPIIScanner.XMLWriteUDF(const Item: IPIIInfoItem;
  const ANode: TGmXmlNode);
var
  ThisNode : TGmXmlNode;
begin
  ThisNode := ANode.Children.AddLeaf('UserDefinedField');
  ThisNode.AsString := WebEncode(Item.Text);
  if Item.XMLDescription <> '' then
    ThisNode.Attributes.AddAttribute('Description', Item.XMLDescription);
end;

procedure TPIIScanner.ReadCISVoucherFields(Voucher: JobCISType; RecAddress : Integer);
var
  SaveParent : Integer;
  AnAddress : TPIIAddressItem;
  Address : string;

  procedure AddField(FieldNo : TPIIFieldNo; const AText : string; XMLDesc : string = '');
  begin
    if Trim(AText) <> '' then
      FList.Add(TPIIInfoItem.Create(Self, FieldNo, CurrentParent, FList.Count,
                                     JMiscF, RecAddress, Trim(AText), XMLDesc));
  end;


begin
  FList.Add(TPIIInfoHeader.Create(Self, PIIEmpCISVoucher, CurrentParent, FList.Count,
                                       JDetlF, RecAddress, 'CIS Voucher', Voucher.CISCertNo));
  SaveParent := CurrentParent;
  CurrentParent := FList.Count - 1;

  AddField(PIICISVoucherNo, Voucher.CISCertNo);

  Address := FormatAddress(Voucher.CISAddr, '', '');
  if Trim(Address) <> '' then
  begin

    AnAddress := TPIIAddressItem.Create(Self, PIIAddress, CurrentParent, FList.Count,
                                       JDetlF, RecAddress, Trim(Address), 'Voucher');
    AnAddress.Address.Address := Voucher.CISAddr;
    FList.Add(AnAddress);
  end;

  //Depending upone CIS340, CISVNINo contains either NINO or UTR.
  if CIS340 then
    AddField(PIIEmpUTR, Voucher.CISVNINo)
  else
    AddField(PIIEmpNINumber, Voucher.CISVNINo);

  AddField(PIIEmpCRN, Voucher.CISVCert);

  CurrentParent := SaveParent;
end;

function TPIIScanner.GetDataAccess: IPIIDataAccess;
begin
  Result := FDataAccess;
end;

procedure TPIIScanner.XMLWritePaymentDetails(const Item: IPIIAddressItem;
  const ANode: TGmXmlNode);
var
  ThisNode, LineNode : TGmXmlNode;
  i : Integer;
  Address : TPIIInfoAddress;
begin
  ThisNode := ANode.Children.AddOpenTag('PaymentDetails');
  Address := Item.Address;
  for i := 1 to 5 do
  begin
    if Trim(Address.Address[i]) <> '' then
    begin
      LineNode := ThisNode.Children.AddLeaf('Line');
      LineNode.AsString := WebEncode(Address.Address[i]);
      LineNode.Attributes.AddAttribute('Number', IntToStr(i));
    end;
  end;

  ANode.Children.AddCloseTag;
end;

{ TPIIInfoChildList }

procedure TPIIInfoChildList.Add(const AnInt: Integer);
begin
  FList.Add(AnInt);
end;

constructor TPIIInfoChildList.Create(const AOwner : TPIIScanner);
begin
  inherited Create;
  FList := TIntList.Create;
  FOwner := AOwner;
end;

destructor TPIIInfoChildList.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

function TPIIInfoChildList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TPIIInfoChildList.GetItem(Index: Integer): IPIIInfoItem;
begin
  if (Index >= 0) and (Index < FList.Count) then
    Result := FOwner.PIIList[FList[Index]]
  else
    raise ERangeError.Create('Index out of range (' + IntToStr(Index) + ')');
end;

//==============================================================================

{ TPIIAccountScanner }

constructor TPIIAccountScanner.Create(const AOwner: TForm;
  const ARec: CustRec);
begin
  inherited Create(AOwner, pstTrader);
  FAccountRec := ARec;
  FContactsFile.OpenFile;
end;

//==============================================================================

{ TPIIEmployeeScanner }

constructor TPIIEmployeeScanner.Create(const AOwner: TForm;
  const ARec: EmplType);
begin
  inherited Create(AOwner, pstEmployee);
  FEmployeeRec := ARec;
end;

{ TPIIInfoHeader }

function TPIIInfoHeader.GetKeyString: string;
begin
  Result := FKeyString;
end;

procedure TPIIInfoHeader.InitType;
begin
  FItemType := itHeader;
end;

{ TPIIAddressItem }

function TPIIAddressItem.GetAddress : TPIIInfoAddress;
begin
  Result := Address;
end;

procedure TPIIAddressItem.SetAddress(const Value: TPIIInfoAddress);
begin
  Address := Value;
end;

end.

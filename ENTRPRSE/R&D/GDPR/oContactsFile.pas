unit oContactsFile;

interface

uses
  oBtrieveFile;

type
  // Note: This structure has been copied from w:\plugins\Contacts\DLLHOOK\Varconst.pas
  TContactRecType = Record
    coCompany    : String[6];     // Enterprise Company Code
    coAccount    : String[10];    // Enterprise Parent Account Code

    coCode       : String[20];    // Unique Contact Code
    coTitle      : String[10];    // Title - 'Mr', 'Mrs', 'Miss', 'Ms',etc…
    coFirstName  : String[30];    // Christian Name - 'Mark', 'Kevin', etc…
    coSurname    : String[30];
    coPosition   : String[30];    // Job Title
    coSalutation : String[20];    // Method Of Address - 'Jon', 'Mr Frewer'
    coContactNo  : String[30];    // Telephone Number
    coDate       : String[8];     // Added Date in YYYYMMDD format
    coFaxNumber  : String[30];    // Fax Number
    coEmailAddr  : String[100];   // Email Address
    coAddress1   : String[35];    // Delivery Address #1
    coAddress2   : String[35];    // Delivery Address #2
    coAddress3   : String[35];    // Delivery Address #3
    coAddress4   : String[35];    // Delivery Address #4
    coPostCode   : String[10];    // PostCode

    coSpare      : Array [1..512] Of Char;
  End; { ContactRecType }

  TContactsFile = Class(TBaseBtrieveFile)
  Private
    FContactRec : TContactRecType;
  Protected
    Function GetRecordPointer : Pointer;
  Public
    Property RecordPointer : Pointer Read GetRecordPointer;
    Property ContactRec : TContactRecType Read FContactRec;

    Constructor Create;
  End; // TDocumentFile



implementation

uses
  FileUtil;

{ TContactsFile }

constructor TContactsFile.Create;
begin
  Inherited Create;

  FDataRecLen := SizeOf(FContactRec);
  FDataRec := @FContactRec;

  FilePath := GetEnterpriseDirectory + 'Contact.dat';
  FBypassOpenCompany := True;

end;

function TContactsFile.GetRecordPointer: Pointer;
begin
  Result := FDataRec;
end;

end.

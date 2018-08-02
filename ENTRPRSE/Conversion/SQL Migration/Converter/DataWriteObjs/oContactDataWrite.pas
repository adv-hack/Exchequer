Unit oContactDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TContactDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    coCompanyParam, coAccountParam, coCodeParam, coTitleParam, coFirstNameParam, 
    coSurnameParam, coPositionParam, coSalutationParam, coContactNoParam, 
    coDateParam, coFaxNumberParam, coEmailAddrParam, coAddress1Param, coAddress2Param, 
    coAddress3Param, coAddress4Param, coPostCodeParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TContactDataWrite

Implementation

Uses Graphics, Variants, SQLConvertUtils;

//=========================================================================

Constructor TContactDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TContactDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TContactDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO Common.Contact (' +
                                                     'coCompany, ' +
                                                     'coAccount, ' +
                                                     'coCode, ' +
                                                     'coTitle, ' +
                                                     'coFirstName, ' +
                                                     'coSurname, ' +
                                                     'coPosition, ' +
                                                     'coSalutation, ' +
                                                     'coContactNo, ' +
                                                     'coDate, ' +
                                                     'coFaxNumber, ' +
                                                     'coEmailAddr, ' +
                                                     'coAddress1, ' +
                                                     'coAddress2, ' +
                                                     'coAddress3, ' +
                                                     'coAddress4, ' +
                                                     'coPostCode' +
                                                   ') ' +
                        'VALUES (' +
                                 ':coCompany, ' +
                                 ':coAccount, ' +
                                 ':coCode, ' +
                                 ':coTitle, ' +
                                 ':coFirstName, ' +
                                 ':coSurname, ' +
                                 ':coPosition, ' +
                                 ':coSalutation, ' +
                                 ':coContactNo, ' +
                                 ':coDate, ' +
                                 ':coFaxNumber, ' +
                                 ':coEmailAddr, ' +
                                 ':coAddress1, ' +
                                 ':coAddress2, ' +
                                 ':coAddress3, ' +
                                 ':coAddress4, ' +
                                 ':coPostCode' +
                                 ')';
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    coCompanyParam := FindParam('coCompany');
    coAccountParam := FindParam('coAccount');
    coCodeParam := FindParam('coCode');
    coTitleParam := FindParam('coTitle');
    coFirstNameParam := FindParam('coFirstName');
    coSurnameParam := FindParam('coSurname');
    coPositionParam := FindParam('coPosition');
    coSalutationParam := FindParam('coSalutation');
    coContactNoParam := FindParam('coContactNo');
    coDateParam := FindParam('coDate');
    coFaxNumberParam := FindParam('coFaxNumber');
    coEmailAddrParam := FindParam('coEmailAddr');
    coAddress1Param := FindParam('coAddress1');
    coAddress2Param := FindParam('coAddress2');
    coAddress3Param := FindParam('coAddress3');
    coAddress4Param := FindParam('coAddress4');
    coPostCodeParam := FindParam('coPostCode');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TContactDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Type
  // Note: This structure has been copied from svn://bmtdev1/generic/Contacts/trunk/DLLHOOK/Varconst.pas
  // as it isn't possible for the SQL Data Migration to reference that code directly.
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

Var
  DataRec : ^TContactRecType;
  sTemp : ShortString;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    coCompanyParam.Value := coCompany;               // SQL=varchar, Delphi=String[6]
    coAccountParam.Value := coAccount;               // SQL=varchar, Delphi=String[10]
    coCodeParam.Value := coCode;                     // SQL=varchar, Delphi=String[20]
    coTitleParam.Value := coTitle;                   // SQL=varchar, Delphi=String[10]
    coFirstNameParam.Value := coFirstName;           // SQL=varchar, Delphi=String[30]
    coSurnameParam.Value := coSurname;               // SQL=varchar, Delphi=String[30]
    coPositionParam.Value := coPosition;             // SQL=varchar, Delphi=String[30]
    coSalutationParam.Value := coSalutation;         // SQL=varchar, Delphi=String[20]
    coContactNoParam.Value := coContactNo;           // SQL=varchar, Delphi=String[30]
    coDateParam.Value := coDate;                     // SQL=varchar, Delphi=String[8]
    coFaxNumberParam.Value := coFaxNumber;           // SQL=varchar, Delphi=String[30]
    coEmailAddrParam.Value := coEmailAddr;           // SQL=varchar, Delphi=String[100]
    coAddress1Param.Value := coAddress1;             // SQL=varchar, Delphi=String[35]
    coAddress2Param.Value := coAddress2;             // SQL=varchar, Delphi=String[35]
    coAddress3Param.Value := coAddress3;             // SQL=varchar, Delphi=String[35]
    coAddress4Param.Value := coAddress4;             // SQL=varchar, Delphi=String[35]
    coPostCodeParam.Value := coPostCode;             // SQL=varchar, Delphi=String[10]
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.


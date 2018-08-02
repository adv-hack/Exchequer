Unit oPaAuthDataWrite;
{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TPaAuthDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;

    CompanyParam, auNameParam, auMaxAuthAmountParam, auEndAmountcharParam, 
    auEMailParam, auAuthCodeParam, auAuthSQUParam, auAuthPQUParam, auAuthPORParam, 
    auAuthPINParam, ActiveParam, auApprovalOnlyParam, auCompressAttachmentsParam, 
    auDefaultAuthParam, auAlternateParam, auAltAfterParam, auAltHoursParam, 
    auDisplayEmailParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TPaAuthDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, BtrvU2, AuthVar;

//=========================================================================

Constructor TPaAuthDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TPaAuthDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TPaAuthDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  FADOQuery.SQL.Text := 'INSERT INTO common.PaAuth (' +
                                             'Company, ' + 
                                             'auName, ' + 
                                             'auMaxAuthAmount, ' + 
                                             'auEndAmountchar, ' + 
                                             'auEMail, ' + 
                                             'auAuthCode, ' + 
                                             'auAuthSQU, ' + 
                                             'auAuthPQU, ' + 
                                             'auAuthPOR, ' + 
                                             'auAuthPIN, ' + 
                                             'Active, ' + 
                                             'auApprovalOnly, ' + 
                                             'auCompressAttachments, ' + 
                                             'auDefaultAuth, ' + 
                                             'auAlternate, ' + 
                                             'auAltAfter, ' + 
                                             'auAltHours, ' + 
                                             'auDisplayEmail' + 
                                             ') ' + 
              'VALUES (' + 
                       ':Company, ' + 
                       ':auName, ' + 
                       ':auMaxAuthAmount, ' + 
                       ':auEndAmountchar, ' + 
                       ':auEMail, ' + 
                       ':auAuthCode, ' + 
                       ':auAuthSQU, ' + 
                       ':auAuthPQU, ' + 
                       ':auAuthPOR, ' + 
                       ':auAuthPIN, ' + 
                       ':Active, ' + 
                       ':auApprovalOnly, ' + 
                       ':auCompressAttachments, ' + 
                       ':auDefaultAuth, ' + 
                       ':auAlternate, ' + 
                       ':auAltAfter, ' + 
                       ':auAltHours, ' + 
                       ':auDisplayEmail' + 
                       ')';


  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    CompanyParam := FindParam('Company');
    auNameParam := FindParam('auName');
    auMaxAuthAmountParam := FindParam('auMaxAuthAmount');
    auEndAmountcharParam := FindParam('auEndAmountchar');
    auEMailParam := FindParam('auEMail');
    auAuthCodeParam := FindParam('auAuthCode');
    auAuthSQUParam := FindParam('auAuthSQU');
    auAuthPQUParam := FindParam('auAuthPQU');
    auAuthPORParam := FindParam('auAuthPOR');
    auAuthPINParam := FindParam('auAuthPIN');
    ActiveParam := FindParam('Active');
    auApprovalOnlyParam := FindParam('auApprovalOnly');
    auCompressAttachmentsParam := FindParam('auCompressAttachments');
    auDefaultAuthParam := FindParam('auDefaultAuth');
    auAlternateParam := FindParam('auAlternate');
    auAltAfterParam := FindParam('auAltAfter');
    auAltHoursParam := FindParam('auAltHours');
    auDisplayEmailParam := FindParam('auDisplayEmail');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TPaAuthDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);

Var
  DataRec : ^TpaAuthorizerRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values

  //As the FaxDetails record is the only variant which corresponds with the SQL key fields, we'll
  //use it for all variants.
  With DataRec^ Do
  Begin
    CompanyParam.Value := Company;                                                         // SQL=varchar, Delphi=String[6]
    auNameParam.Value := auName;                                                           // SQL=varchar, Delphi=String[60]
    auMaxAuthAmountParam.Value := auMaxAuthAmount;                                         // SQL=bigint, Delphi=Int64
    auEndAmountcharParam.Value := Ord(auEndAmountchar);                                    // SQL=int, Delphi=Char
    auEMailParam.Value := auEMail;                                                         // SQL=varchar, Delphi=String[100]
    auAuthCodeParam.Value := CreateVariantArray (@auAuthCode, SizeOf(auAuthCode));// SQL=varbinary, Delphi=String[10]
    auAuthSQUParam.Value := auAuthSQU;                                                     // SQL=bit, Delphi=Boolean
    auAuthPQUParam.Value := auAuthPQU;                                                     // SQL=bit, Delphi=Boolean
    auAuthPORParam.Value := auAuthPOR;                                                     // SQL=bit, Delphi=Boolean
    auAuthPINParam.Value := auAuthPIN;                                                     // SQL=bit, Delphi=Boolean
    ActiveParam.Value := Active;                                                           // SQL=bit, Delphi=Boolean
    auApprovalOnlyParam.Value := auApprovalOnly;                                           // SQL=bit, Delphi=Boolean
    auCompressAttachmentsParam.Value := auCompressAttachments;                             // SQL=bit, Delphi=Boolean
    auDefaultAuthParam.Value := auDefaultAuth;                                             // SQL=varchar, Delphi=string[60]
    auAlternateParam.Value := auAlternate;                                                 // SQL=varchar, Delphi=string[30]
    auAltAfterParam.Value := auAltAfter;                                                   // SQL=int, Delphi=SmallInt
    auAltHoursParam.Value := auAltHours;                                                   // SQL=bit, Delphi=Boolean
    auDisplayEmailParam.Value := auDisplayEmail;                                           // SQL=varchar, Delphi=string[100]
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.


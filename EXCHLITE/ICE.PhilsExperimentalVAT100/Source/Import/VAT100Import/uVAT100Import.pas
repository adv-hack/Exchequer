{-----------------------------------------------------------------------------
 Unit Name: uVAT100Import
 Author:    Phil Rogers
 Purpose:   Handles the import of messages received from the GGW. (I think!)
 History:   Based on V Moura's CIS code.
-----------------------------------------------------------------------------}
Unit uVAT100Import;

Interface

Uses
  Classes, uBaseClass,
  {exchequer components}
  Enterprise01_TLB, strutil,
  {ice}
  uadodsr,

  gmxml
  ;

Type
  TVAT100Import = Class(_Base)
  Private
    fDataPath: String;
    fXml: WideString;
    fToolKit: IToolkit;
    fDb: TADODSR;
    fDSRDBServer: String;
    fCompExCode: String;
    Function Init: Boolean;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Function UpdateRecords: Longint;
  Published
    Property XML: WideString Read fXml Write fXml;
    Property DataPath: String Read fDataPath Write fDataPath;
    Property DSRDBServer: String Read fDSRDBServer Write fDSRDBServer;
    Property CompExCode: String Read fCompExCode Write fCompExCode;
  End;

Implementation

Uses
  SysUtils, cisxcnst,
  CTKUTIL,
  {dsr common files}
  uConsts, uCommon;


//------------------------------------------------------------------------------
//  Procedure   : UpdateRecords
//  Author      : Phil Rogers
//  Description : Extracts the data from the response and puts it in the database (?) 
//------------------------------------------------------------------------------
Function TVAT100Import.UpdateRecords: Longint;
Var
  lGxml: TGmXML;
//  lNode, lSub: TGmXmlNode;
//  lCont: Integer;
Begin
  Result := S_OK;

  // Load exchequer comtoolkit
  If Init Then
  Begin
    lGxml := TGmXML.Create(Nil);

    Try
      // Load the XML
      If _FileSize(fXml) > 0 Then
        lGxml.LoadFromFile(fXml)
      Else
        lGxml.Text := fXml;

      // Check the xml that is being passed through
      If Trim(lGxml.Text) <> '' Then
      Begin
        ; // Nothing to do.  We can probably dump this module.
      End
      Else
      Begin
        Result := cINVALIDXML;
        DoLogMessage('TSubContractorImport.UpdateRecords', Result, 'Empty XML');
      End;
    Finally
      lGxml.Free;
    End; {try}
  End
  Else
  Begin
    Result := cOBJECTNOTAVAILABLE;
    DoLogMessage('TSubContractorImport.UpdateRecords', Result, 'Toolkit Error');
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TVAT100Import.Create;
Begin
  Inherited Create;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TVAT100Import.Destroy;
Begin
  If Assigned(fToolKit) Then
  Begin
    Try
      fToolKit.CloseToolkit;
    Finally
      fToolKit := Nil;
    End;
  End; {If Assigned(fToolKit) Then}

  If Assigned(fDb) Then
    FreeAndNil(fDb);
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: Init
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TVAT100Import.Init: Boolean;
Var
  lRes: Integer;
Begin
  Result := False;

  Try
    fDb := TADODSR.Create(fDSRDBServer);
  Except
    On e: Exception Do
      DoLogMessage('TSubContractorExport.Init', cDBERROR,
        'Error connecting to the Database. Error: ' + e.message);
  End;

  {check the database connection}
  If Assigned(fDb) And fDb.Connected Then
  Begin
    Self.ConnectionString := fDb.ConnectionString;

    Try
      fToolKit := CreateToolkitWithBackdoor;
    Except
      On E: exception Do
        DoLogMessage('TSubContractorExport.Init', cERROR,
          'Error creating the Toolkit. Error: ' + e.Message);
    End; {try}

    If Assigned(fToolKit) Then
    Begin
      If _DirExists(fDataPath) Then
      Begin
        lRes := -1;
        fToolKit.Configuration.DataDirectory := fDataPath;

        Try
          lRes := fToolKit.OpenToolkit;
        Except
          On E: Exception Do
            DoLogMessage('TSubContractorExport.Init', cError,
              'Error opening the toolkit. Error: ' + e.Message);
        End; {try}

        Result := lRes = 0;
      End
      Else
        DoLogMessage('TSubContractorExport.Init', cError, 'Invalid Company Path ' +
          fDataPath);
    End; {If Assigned(fToolKit) Then}
  End
  Else
    DoLogMessage('TSubContractorExport.Init', cERROR,
      'The database is not connected...');
End;


End.


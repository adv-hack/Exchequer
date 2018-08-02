{-----------------------------------------------------------------------------
 Unit Name: uCISExportSubcontractor
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uSubcontractorExport;

Interface


Uses Classes, uBaseClass,
  CISWrite,
    {exchequer components}
  Enterprise01_TLB,
  {ice}
  uadodsr
  ;

const
{$I X:\Entrprse\R&D\VerModu.Pas}

Type
  TSubContractorExport = Class(_Base)
  Private
    fDataPath, fXmlPath: String;
    fXml: WideString;
    fToolKit: IToolkit;
    fDb: TADODSR;
    fDSRDBServer: String;
    fCompExCode: String;
    Function Init: Boolean;
    Function CheckEmployeeRecordTagged: Boolean;
    Function FormatXMLtoDSR(pXml, pXMLPath, pDataPath: WideString): Longint;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Function BuildRecords: Longint;
    Function RecordExists: Boolean;
  Published
    Property XML: WideString Read fXml Write fXml;
    Property DataPath: String Read fDataPath Write fDataPath;
    Property XMLPath: String Read fXMLPath Write fXmlPath;
    Property DSRDBServer: String Read fDSRDBServer Write fDSRDBServer;
    Property CompExCode: String Read fCompExCode Write fCompExCode;
  End;

Implementation

Uses
  SysUtils, windows, uXmlBaseClass, MSXML2_TLB, GMXML,
  CTKUTIL, DateUtils, CISXCnst,
  {dsr common files}
  uConsts, uCommon, uInterfaces


  ;

{ TSubContractorExport }

{-----------------------------------------------------------------------------
  Procedure: BuildRecords
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSubContractorExport.BuildRecords: Longint;

  Procedure CheckCISParameters(pCIS: TCISXMLVerification);
  Begin
    If pCIS <> Nil Then
      With pCIS Do
      Begin
      {just check main parameters from sending the xml}
        If ContractorUTR = '' Then
          DoLogMessage('TSubContractorExport.BuildRecords', cINVALIDPARAM,
            'Invalid Contractor UTR.', True, True);

        If ContractorAORef = '' Then
          DoLogMessage('TSubContractorExport.BuildRecords', cINVALIDPARAM,
            'Invalid A/C Office Ref.', True, True);

        If SenderID = '' Then
          DoLogMessage('TSubContractorExport.BuildRecords', cINVALIDPARAM,
            'Invalid Sender ID.', True, True);

        If SenderAuthentication = '' Then
          DoLogMessage('TSubContractorExport.BuildRecords', cINVALIDPARAM,
            'Invalid Sender Authentication.', True, True);

        If TaxOfficNumber = '' Then
          DoLogMessage('TSubContractorExport.BuildRecords', cINVALIDPARAM,
            'Invalid Tax Office number.', True, True);

        If TaxOfficeReference = '' Then
          DoLogMessage('TSubContractorExport.BuildRecords', cINVALIDPARAM,
            'Invalid Tax Office Reference.', True, True);
      End;
  End;

  Function GetSupplierName(Const pCode: String): String;
  Begin
    Result := '';
    If fToolKit <> Nil Then
      If fToolKit.Supplier <> Nil Then
        With fToolKit.Supplier Do
          If GetEqual(BuildCodeIndex(pCode)) = 0 Then
            Result := Trim(fToolKit.Supplier.acCompany);
  End; {function GetSupplierName(const pCode: String): String;}

  Function GetSupplierType(Const pCode: String): String;
  Begin
    Result := '';
    If fToolKit <> Nil Then
      If fToolKit.Supplier <> Nil Then
        With fToolKit.Supplier Do
          If GetEqual(BuildCodeIndex(pCode)) = 0 Then
            Result := copy(Uppercase(Trim(fToolKit.Supplier.acArea)), 1, 1);
  End; {function GetSupplierType(const pCode: String): String;}

  Function GetSupplierUTR(Const pCode: String): String;
  Begin
    Result := '';
    If fToolKit <> Nil Then
      If fToolKit.Supplier <> Nil Then
        With fToolKit.Supplier Do
          If GetEqual(BuildCodeIndex(pCode)) = 0 Then
            Result := Trim(fToolKit.Supplier.acCCNumber);
    If Length(Result) > 10 Then
      Result := '';
  End; {function GetSupplierName(const pCode: String): String;}

Var
  lCISVer: TCISXMLVerification; // xml writer object

  lDir: String;
  lRes: Integer;
  lEmployee: IEmployee5; // com tk employee object
  lSystem: ISystemSetupCIS3;

  lSupName, lSupType, lSupUTR: String;
  lName, lFirstName, lSecondName, lSurName: String;
Begin
  Result := S_OK;
  lCISVer := Nil;

  _CallDebugLog('Init Toolkit');
  If Init Then
  Begin
    _CallDebugLog('Employee tagged');
    If CheckEmployeeRecordTagged Then
    Begin
      _CallDebugLog('there are employees tagged');
      {load the cis subcontractor dir}
      lDir := IncludeTrailingPathDelimiter(_GetApplicationPath + cCISSUBDIR);
      ForceDirectories(lDir);

      Try
        _CallDebugLog('CIS Verification');
    {create the cis verification object}
        lCISVer := TCISXMLVerification.Create;

        If lCISVer <> Nil Then
      {populate xml records}
          With lCISVer Do
          Begin
            Try
              {filling the CIS xml header}

//              If Trim(fToolKit.Enterprise.enEnterpriseVersion) = '' Then
//                ProductVersion := Trim(fToolKit.Version)
//              Else
//               ProductVersion := Trim(fToolKit.Enterprise.enEnterpriseVersion);

              ProductVersion := CurrVersion;

              _CallDebugLog('Loading toolkit system ');

              lSystem := Nil;

              Try
                lSystem := (fToolKit.SystemSetup As isystemsetup2).ssCISSetup As
                  ISystemSetupCIS3;
              Except
                On e: exception Do
                Begin
                  Result := cOBJECTNOTAVAILABLE;
                  fXml := '';
                  DoLogMessage('TSubContractorExport.BuildRecords', Result,
                    'Error Loading CIS System Object. Error: ' + e.Message, True,
                    True);
                End; {begin}
              End;

              _CallDebugLog('after loading toolkit system');

              {check system object}
              If lSystem <> Nil Then
              Begin
                _CallDebugLog('CIS system setup returned');

                Try                         
                  ContractorUTR := Trim(lSystem.cisUTR);
                  ContractorAORef := Trim(lSystem.cisACOfficeRef);
                  SenderID := Trim(lSystem.cisSenderID);
                  SenderAuthentication := Trim(lSystem.cisSenderAuthentication);
                  TaxOfficNumber := Trim(lSystem.cisTaxOfficeNo);
                  TaxOfficeReference := Trim(lSystem.cisTaxOfficeRef);
                Except
                  On e: exception Do
                  Begin
                    Result := cOBJECTNOTAVAILABLE;
                    fXml := '';
                    DoLogMessage('TSubContractorExport.BuildRecords', Result,
                      'Error loading Toolkit parameters. Error: ' + e.Message, True,
                      True);
                  End;
                End; {try}

                {set submitter type... }
                Try
                  Case (lSystem As ISystemSetupCIS4).cisSubmitterType Of
//                    cstNA: IRSender := '';
                    cstIndividual: IRSender := cIRSenderIndividual;
                    cstCompany: IRSender := cIRSenderCompany;
                    cstAgent: IRSender := cIRSenderAgent;
                    cstBureau: IRSender := cIRSenderBureau;
                    cstPartnership: IRSender := cIRSenderPartnership;
                    cstTrust: IRSender := cIRSenderTrust;
                    cstEmployer: IRSender := '';
                    cstGovernment: IRSender := cIRSenderGovernment;
                    cstActingInCapacity: IRSender := '';
                    cstOther: IRSender := cIRSenderOther;
                  End;
                Except
                  On e: exception Do
                  Begin
                    Result := cOBJECTNOTAVAILABLE;
                    fXml := '';
                    DoLogMessage('TSubContractorExport.BuildRecords', Result,
                      'Error loading Toolkit System parameters. Error: ' + e.Message, True,
                      True);
                  End;
                End;

                _CallDebugLog('after loading parameters');

                {log the parameters that are invalid}
                CheckCISParameters(lCISVer);

                //VendorID := EXCHEQUER_VENDOR_ID;
//                TestMessage := (lSystem as ISystemSetupCIS4).cisTestMode;
                TestMessage := fDb.GetSystemValue(cUSECISTESTPARAM) = '1';

                Year := YearOf(Now);
                Month := MonthOf(Now);

                EmploymentStatus := False;
                SubContractorVerification := True;

                lRes := -1;
            {get first record}
                Try
                  lRes := fToolKit.JobCosting.Employee.GetFirst;
                Except
                  On e: exception Do
                  Begin
                    Result := cERROR;
                    fXml := '';
                    DoLogMessage('TSubContractorExport.BuildRecords', Result,
                      'Error Loading SubContractor First Record. Error: ' +
                      e.Message, True, True);
                  End; {begin}
                End; {try}

                {loop through the emplyee records...}
                While lRes = 0 Do
                Begin
                  //_LogMSG('adding subcontractor ' + lEmployee.emUTRCode);
                  lEmployee := Nil;

                  Try
                    lEmployee := fToolKit.JobCosting.Employee As IEmployee5;
                  Except
                    On e: exception Do
                    Begin
                      Result := cOBJECTNOTAVAILABLE;
                      fXml := '';
                      DoLogMessage('TSubContractorExport.BuildRecords', Result,
                        'Error Typecasting SubContractor. Error: ' + e.Message,
                        True, True);
                      Break;
                    End; {begin}
                  End; {try}

                  {check employee record}
                  If lEmployee <> Nil Then
                  Begin
                {check if type is subcontract and the record is tagged}
                    If (lEmployee.emType = emTypeSubContract) And
                      (Ord(lEmployee.emTagged) <> 0) Then
                    Begin
                      lSupName := '';
                      lSupType := '';
                      lSupUTR := '';
                      {see doc cis-qsbvr.pdf for more details about these fields and their validation}
                      With SubContractors.Add Do
                      Begin
                        lSupName := GetSupplierName(lEmployee.emSupplier);
                        //lSupType := GetSupplierType(lEmployee.emSupplier);

                        lSupUTR := GetSupplierUTR(lEmployee.emSupplier);

                        Case lEmployee.emContractorType Of
                          ctSoleTrader: BusinessType := sctSoleTrader;
                          ctPartnership, ctNA: BusinessType := sctPartnership;
                          ctTrust: BusinessType := sctTrust;
                          ctCompany: BusinessType := sctCompany;
                        End;

                        If Trim(lEmployee.emVerificationNo) = '' Then
                          Action := scaVerify
                        Else
                          Action := scaMatch;

                        lName := Trim(lEmployee.emName);

                        {if business type is sole trader or partnership, only print first name and surname
                        otherwise, print trader name}
                        If BusinessType In [sctSoleTrader, sctPartnership] Then
                        Begin
                          If lName <> '' Then
                          Begin
                            lFirstName := _strToken(lName, ' ');

                            If (lFirstName <> '') And (lName <> '') Then
                              lSecondName := _strToken(lName, ' ');

                            If (lName = '') {and (Length(lSecondname) > 1)} Then
                            Begin
                              lSurName := lSecondName;
                              lSecondName := '';
                            End
                            Else
                            begin
                              {if Length(lSecondname) = 1 then
                                lSurName := lSecondName + lName
                              else}
                                lSurName := lName;
                            end;
                          End; {if lName <> '' then}

                          If (lFirstName <> '') And ((lSecondName <> '') Or (lSurName
                            <> '')) Then
                          Begin
                            Forename1 := _ApplyXmlCharacters(Trim(lFirstName));
                            If (lSecondName <> '') and (Length(lSecondName) > 1) Then
                              Forename2 := _ApplyXmlCharacters(Trim(lSecondName));
                            Surname := _ApplyXmlCharacters(Trim(lSurName));
                          End; {if (lFirstName <> '') and ((lSecondName <> '') or (lSurName <> '')) then}
                        End
                        Else
                        Begin
                          TradingName := _ApplyXmlCharacters(lSupName);

                          If TradingName = '' Then
                            TradingName := _ApplyXmlCharacters(lEmployee.emName);
                        End;

                        {-------------- rules from CIS ------------}

                        If BusinessType = sctPartnership Then
                        Begin
                          PartnershipName := _ApplyXmlCharacters(lSupName);
                          if Trim(lSupUTR) <> '' then
                            PartnershipUTR := lSupUTR;
                        End; {if lSupUTR <> '' then}

                        {works ref is optional, but help us to locate the employee record}
                        If Trim(lEmployee.emCode) <> '' Then
                          WorksRef := lEmployee.emCode
                        Else
                          WorksRef := lEmployee.emUTRCode;

                        //If (Action = scaMatch) And (BusinessType <> sctPartnership)
                          If BusinessType <> sctPartnership Then
                            UTR := lEmployee.emUTRCode;

                        If (Action = scaMatch) And (BusinessType = sctPartnership)
                          And ((Trim(lEmployee.emCertificateNumber) = '') Or
                          (Trim(PartnershipUTR) = '')) Then
                          NINO := lEmployee.emNISerialNo;

                        If (Action = scaMatch) And (BusinessType = sctPartnership)
                          And ((Trim(lEmployee.emNISerialNo) = '') Or
                          (Trim(PartnershipUTR) = '')) Then
                          CRN := lEmployee.emCertificateNumber;

                        If (BusinessType = sctCompany) And
                          (Trim(lEmployee.emCertificateNumber) <> '') Then
                          CRN := lEmployee.emCertificateNumber;

                        If (BusinessType = sctSoleTrader) And
                          (Trim(lEmployee.emNISerialNo) <> '') Then
                          NINO := lEmployee.emNISerialNo;
                      End; {With SubContractors.Add Do}
                    End; {If (fToolKit.JobCosting.Employee.emType = emTypeSubContract) And (fToolKit.JobCosting.Employee.emCode <> '') Then}
                  End; {if lEmployee <> nil then}

                  //lRes := lEmployee.GetNext;
                  Try
                    lRes := fToolKit.JobCosting.Employee.GetNext;
                  Except
                    On e: exception Do
                    Begin
                      Result := cError;
                      fXml := '';
                      DoLogMessage('TSubContractorExport.BuildRecords', Result,
                        'Error Loading SubContractor Next Record. Error: ' +
                        e.Message, True, True);
                      Break;
                    End; {begin}
                  End; {try}
                End; {while lRes = 0 do}

                If lEmployee <> Nil Then
                  lEmployee := Nil;

                {xml name :- dir + guid name + xml ext}
                fXml := IncludeTrailingPathDelimiter(lDir) + _CreateGuidStr +
                  cXMLEXT;

                _CallDebugLog('Dir ' + lDir);
                _CallDebugLog('XML file' + fXml);

                lCISVer.Encoding := cMSXMLUTF8;

                _CallDebugLog('writing xml to file');
                {save the file that will be passed to dsr}
                lCISVer.WriteXMLToFile(fXml);

                _CallDebugLog('format xml to dsr');

                _CallDebugLog('XML Path ' + XMLPath);

                Result := FormatXMLtoDSR(fXml, XMLPath, lDir);

                _CallDebugLog('after format xml to dsr');
              End
              Else
              Begin
                Result := cOBJECTNOTAVAILABLE;
                fXml := '';
                DoLogMessage('TSubContractorExport.BuildRecords', Result,
                  'Exchequer CIS System paramater not available.', True, True);
              End;
            Except
              On E: Exception Do
              Begin
                Result := cXMLRECORDERROR;
                fXml := '';
                DoLogMessage('TSubContractorExport.BuildRecords', Result,
                  'Error creating Subcontractor XML. Error: ' + e.Message, True,
                  True);
              End; {e:begin}
            End; {try}
          End; {With lCISVer Do}
      Except
        On e: exception Do
        Begin
          Result := cError;
          fXml := '';
          DoLogMessage('TSubContractorExport.BuildRecords', Result,
            'Error creating Subcontractor XML. Error: ' + e.Message, True, True);
        End;
      End; {try..finally}

      If lCISVer <> Nil Then
        lCISVer.Free;
    End
    Else
    Begin
      Result := cDBNORECORDFOUND;
      DoLogMessage('TSubContractorExport.BuildRecords', Result,
        'No employee record has been tagged.', True, True);
    End;
  End
  Else
  Begin
    Result := cOBJECTNOTAVAILABLE;
    DoLogMessage('TSubContractorExport.BuildRecords', Result, 'Toolkit Error', True,
      True);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: CheckEmployeeRecordTaged
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSubContractorExport.CheckEmployeeRecordTagged: Boolean;
Var
  lRes: Integer;
  lEmployee: IEmployee5;
Begin
  Result := False;
  If Assigned(fToolKit) Then
  Begin
    //lRes := lEmployee.GetFirst;
    lRes := fToolKit.JobCosting.Employee.GetFirst;

    {check for any tagged record to be sent/verified}
    While lRes = 0 Do
    Begin
      lEmployee := Nil;

      Try
        lEmployee := fToolKit.JobCosting.Employee As IEmployee5;
      Except
      End;

      If lEmployee <> Nil Then
        If (lEmployee.emType = emTypeSubContract) And
          (Ord(lEmployee.emTagged) <> 0) Then
        Begin
          Result := True;
          Break;
        End; {}

      lRes := fToolKit.JobCosting.Employee.GetNext;
    End; {while lRes = 0 do}
  End; {If Assigned(fToolKit) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TSubContractorExport.Create;
Begin
  Inherited Create;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TSubContractorExport.Destroy;
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
Function TSubContractorExport.Init: Boolean;
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
      _CallDebugLog('company path is ' + fDataPath);

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

{-----------------------------------------------------------------------------
  Procedure: FormatXMLtoDSR
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSubContractorExport.FormatXMLtoDSR(pXml, pXMLPath, pDataPath: WideString):
  Longint;
Var
  lDoc, lCis: TXMLDoc;
  lNode: IXMLDOMNode;
  lNewFile: String;
  lXml: WideString;
Begin
  Result := S_OK;
  lDoc := TXMLDoc.Create;

  _CallDebugLog('Format xml function -> loading xml file...');

  If _FileSize(pXml) > 0 Then
    lDoc.Load(pXml)
  Else
    lDoc.LoadXml(pXml);

{default dsr xml format}
  _CallDebugLog('Format xml function -> loading dsr xml file... Path: ' + pXMLPath +
    ' File: ' + cCISXMLSUBFILE);

  lCIS := TXMLDoc.Create;
  lCIS.LoadXml(IncludeTrailingPathDelimiter(pXMLPath) + cCISXMLSUBFILE);

  If lCIS.Doc.xml <> '' Then
  Begin
    lNode := _GetNodeByName(lCis.Doc, cCISXMLNODESUB);

  {check if the cis node exists}
    If lNode <> Nil Then
    Begin
      If Trim(lDoc.Doc.xml) <> '' Then
      Begin
        {set the whole xml into the cmdata}
        lXML := StringReplace(lDoc.Doc.xml, Chr(9), '', [rfReplaceAll]);
        lXML := StringReplace(lXML, #13, '', [rfReplaceAll]);
        lXML := StringReplace(lXML, #10, '', [rfReplaceAll]);
        lXml := lCIS.ApplyEncondeEx(lXML, cMSXMLUTF8);

        _SetNodeValueByName(lNode, cCISXMLNODESUB, lXML);
  //      _SetNodeValueByName(lNode, cCISXMLNODESUB, lDoc.Doc.xml);

        lNewFile := IncludeTrailingPathDelimiter(pDataPath) + _CreateGuidStr +
          cXMLEXT;

        _CallDebugLog(' new cis file name' + lNewFile);

        ForceDirectories(ExtractFilePath(lNewFile));

      {save the file...}
        _CallDebugLog(' applying encoding...');
        lXml := lCIS.ApplyEncondeEx(lCIS.Doc.xml, cMSXMLUTF8);
        //lCIS.Save(lNewFile);
        lXML := StringReplace(lXml, Chr(9), '', [rfReplaceAll]);
        lXML := StringReplace(lXML, #13, '', [rfReplaceAll]);
        lXML := StringReplace(lXML, #10, '', [rfReplaceAll]);

        _CallDebugLog(' saving new cis file... ');
        _CreateXmlFile(lNewFile, lXMl);

      {check fif the file exists}
        If _FileSize(lNewFile) > 0 Then
        Begin
        {delete the old file}
          If _FileSize(pXml) > 0 Then
            _DelFile(pXml);

          _CallDebugLog(' the new cis file is ' + lNewFile);
        {this will be the file used by the dsr sender thread}
          fXml := lNewFile;

          Result := S_OK;
        End {If _FileSize(lNewFile) > 0 Then}
        Else
        Begin
          _DelFile(lNewFile);
          fXml := '';
          Result := cFILEANDXMLERROR;
        End;
      End
      Else
      Begin
        fXml := '';
        Result := cINVALIDXML;
        If _FileSize(pXml) > 0 Then
          _DelFile(pXml);
      End; {else begin}
    End;
  End
  Else
    DoLogMessage('TSubContractorExport.BuildRecords', cINVALIDXML,
      'Invalid CIS XML Parameter.');

  If lDoc <> Nil Then
    lDoc.Free;

  If lCis <> Nil Then
    lCis.Free;
End;

{-----------------------------------------------------------------------------
  Procedure: RecordExists
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSubContractorExport.RecordExists: Boolean;
Begin
  Result := FileExists(fXml) And (_FileSize(fXml) > 0);
End;

End.


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
  Enterprise01_TLB;

Type
  TSubContractorExport = Class(_Base)
  Private
    fDataPath, fXmlPath: String;
    fXml: WideString;
    fToolKit: IToolkit;
    Function Init: Boolean;
    Function CheckEmployeeRecordTagged: Boolean;
  Public
    Constructor Create(Const pDataPath, pXmlPath: String);
    Destructor Destroy; Override;
    Procedure BuildRecords;
    Function RecordExists: Boolean;
  Published
    Property XML: WideString Read fXml Write fXml;
  End;

Implementation

Uses
  SysUtils,
  CTKUTIL, DateUtils,
  {dsr common files}
  uConsts, uCommon;

{ TSubContractorExport }

{-----------------------------------------------------------------------------
  Procedure: BuildRecords
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TSubContractorExport.BuildRecords;
Var
  lCIS: TCISXMLVerification;
  lDir: String;
  lRes: Integer;
Begin
  If Init Then
  Begin
    If CheckEmployeeRecordTagged Then
    Begin
      {load the cis subcontractor dir}
      lDir := IncludeTrailingPathDelimiter(_GetApplicationPath + cCISSUBDIR);
      ForceDirectories(lDir);

      {create the cis verification object}
      lCIS := TCISXMLVerification.Create;

      {populate xml records}
      With lCIS Do
      Begin
        Try
          //message type for identifying this is a subcontractors verification
          //FDocument.Nodes.AddLeaf(MESSAGE_CLASS).AsString := MESSAGE_CLASS_RETURN;
          // IR_CIS_URL must be changed <IRenvelope xmlns="http://www.govtalk.gov.uk/taxation/CISrequest">
          // or new option added

          ProductVersion := fToolKit.Enterprise.enEnterpriseVersion;
          SenderID := '';
          SenderAuthentication := '';
          TaxOfficNumber := '';
          TaxOfficeReference := '';
          VendorID := '';
          ContractorUTR := '';
          ContractorAORef := '';
          Year := YearOf(Now);
          Month := MonthOf(Now);

          EmploymentStatus := False;
          SubContractorVerification := True;

          {get first record}
          lRes := fToolKit.JobCosting.Employee.GetFirst;

          While lRes = 0 Do
          Begin
{
 <Subcontractor>
                 <Action>verify</Action>
                 <Type>partnership</Type>
                 <TradingName>Foundations</TradingName>
                 <WorksRef>WR3000</WorksRef>
                 <UTR>1234567890</UTR>
                 <CRN>AB123456</CRN>
                 <NINO>PR456789B</NINO>
                 <Partnership>
                              <Name>Mark & Sons</Name>
                              <UTR>0123456789</UTR>
                 </Partnership>
                 <Address>
                          <Line>21 High Street</Line>
                          <Line>Wellington</Line>
                          <Line>Telford</Line>
                          <Line>Shropshire</Line>
                          <PostCode>BD18</PostCode>
                          <Country>UK</Country>
                 </Address>
                 <Telephone>01952123456</Telephone>
 </Subcontractor>

}
            {check if type is subcontract and the record is tagged}
            If (fToolKit.JobCosting.Employee.emType = emTypeSubContract) And
              (fToolKit.JobCosting.Employee.emCode <> '') Then
            Begin
              With fToolKit.JobCosting.Employee, SubContractors.Add Do
              Begin
                Action := scaVerify;
                BusinessType := sctPartnership;
                TradingName := ''; // TODO: TradingName
                //WorksRef := ''; // TODO: WorksRef
                UTR := ''; // TODO: UTR
                NINO := ''; // TODO:Nino
                PartnershipName := '';
                PartnershipUTR := '';
                
              End; {With SubContractors.Add Do}
            End; {If (fToolKit.JobCosting.Employee.emType = emTypeSubContract) And (fToolKit.JobCosting.Employee.emCode <> '') Then}

            lRes := fToolKit.JobCosting.Employee.GetNext;
          End; {while lRes = 0 do}

      {xml name :- dir + guid name + xml ext}
          fXml := lDir + _CreateGuidStr + cXMLEXT;

      {save the file that will be passed to dsr}
          lCIS.WriteXMLToFile(fXml);
        Except
          On E: Exception Do
            DoLogMessage('TSubContractorExport.BuildRecords', cXMLRECORDERROR,
              'Error creating Subcontractor XML. Error: ' + e.Message);
        End; {try}
      End; {With lCIS Do}

      lCis.Free;
    End
    Else
      DoLogMessage('TSubContractorExport.BuildRecords', cDBNORECORDFOUND,
        'No employee record has been tagged.');
  End
  Else
    DoLogMessage('TSubContractorExport.BuildRecords', cOBJECTNOTAVAILABLE,
      'Toolkit Error');
End;

{-----------------------------------------------------------------------------
  Procedure: CheckEmployeeRecordTaged
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSubContractorExport.CheckEmployeeRecordTagged: Boolean;
Var
  lRes: Integer;
Begin
  Result := False;
  lRes := fToolKit.JobCosting.Employee.GetFirst;

  {check for any tagged record to be sent/verified}
  While lRes = 0 Do
  Begin
    If (fToolKit.JobCosting.Employee.emType = emTypeSubContract) And
      (fToolKit.JobCosting.Employee.emCode <> '') Then
    Begin
      Result := True;
      Break;
    End; {}

    lRes := fToolKit.JobCosting.Employee.GetNext;
  End; {while lRes = 0 do}
End;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TSubContractorExport.Create(Const pDataPath, pXmlPath: String);
Begin
  Inherited Create;
  fDataPath := pDataPath;
  fXmlPath := pXmlPath;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TSubContractorExport.Destroy;
Begin
  If Assigned(fToolKit) Then
    fToolKit := Nil;
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
      End;

      Result := lRes = 0;
    End
    Else
      DoLogMessage('TSubContractorExport.Init', cError, 'Invalid Company Path ' +
        fDataPath);
  End; {If Assigned(fToolKit) Then}
End;

{-----------------------------------------------------------------------------
  Procedure: RecordExists
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSubContractorExport.RecordExists: Boolean;
Begin
End;

End.


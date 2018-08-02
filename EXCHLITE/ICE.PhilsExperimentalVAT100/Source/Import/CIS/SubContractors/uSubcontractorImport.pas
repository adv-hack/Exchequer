{-----------------------------------------------------------------------------
 Unit Name: uSubcontractorImport
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uSubcontractorImport;

Interface

Uses Classes, uBaseClass,
    {exchequer components}
  Enterprise01_TLB, strutil,
  {ice}
  uadodsr,

  gmxml

  ;

Const
  CIS_SUBCONTRACTOR_TAXTREATMENT = 'TaxTreatment';
  CIS_SUBCONTRACTOR_WORKSREF = 'WorksRef';

Type
  TSubContractorImport = Class(_Base)
  Private
    fDataPath: String;
    fXml: WideString;
    fToolKit: IToolkit;
    fDb: TADODSR;
    fDSRDBServer: String;
    fCompExCode: String;
    Function Init: Boolean;
    Function UpdateEmployeeRec(pSub: TGmXmlNode): Longint;
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

{ TSubContractorExport }

{-----------------------------------------------------------------------------
  Procedure: BuildRecords
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSubContractorImport.UpdateRecords: Longint;
Var
  lGxml: TGmXML;
  lNode, lSub: TGmXmlNode;
  lCont: Integer;
Begin
  Result := S_OK;

  {load exchequer comtoolkit}
  If Init Then
  Begin
    lGxml := TGmXML.Create(Nil);

    Try
      If _FileSize(fXml) > 0 Then
        lGxml.LoadFromFile(fXml)
      Else
        lGxml.Text := fXml;

      {check the xml that is begig passed through}
      If Trim(lGxml.Text) <> '' Then
      Begin
        {load the resposedata node where the subcontractor can be found}
        lNode := lGxml.Nodes.NodeByName[cCISXMLSUBRESPONSEDATA];
        If lNode <> Nil Then
        Begin
          lNode := lNode.Children.NodeByName[cCISXMLSUBRESPONSE];

          If lNode <> Nil Then
          Begin
            {lopp through the nodes loading the values}
            For lCont := 0 To lNode.Children.Count - 1 Do
              If Lowercase(Trim(lNode.Children[lCont].Name)) =
                Lowercase(Trim(CIS_SUBCONTRACTOR)) Then
              Begin
                lSub := lNode.Children[lCont];
                If lSub <> Nil Then
                  UpdateEmployeeRec(lSub);
              End; {if Lowercase(Trim(lNode.Children[lCont].Name)) = Lowercase(Trim(CIS_SUBCONTRACTOR)) then}
          End
          Else
          Begin
            Result := cNODATATOBEIMPORTED;
            DoLogMessage('TSubContractorImport.UpdateRecords', Result,
              'XML Response node not found.');
          End;
        End
        Else
        Begin
          Result := cNODATATOBEIMPORTED;
          DoLogMessage('TSubContractorImport.UpdateRecords', Result,
            'XML Response Data node not found.');
        End;
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
Constructor TSubContractorImport.Create;
Begin
  Inherited Create;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TSubContractorImport.Destroy;
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
Function TSubContractorImport.Init: Boolean;
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

{-----------------------------------------------------------------------------
  Procedure: UpdateEmployeeRec
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TSubContractorImport.UpdateEmployeeRec(pSub: TGmXmlNode): Longint;

  {search employee record by works ref code}
  Function GetEmployeeByCode(Const pCode: String): IEmployee5;
  Begin
    Result := Nil;
    With fToolKit.JobCosting Do
      If Employee.GetEqual(Employee.BuildCodeIndex(pCode)) = 0 Then
        Result := Employee As IEmployee5;
  End; {function GetEmployee(const pCode: String): IEmployee5;}

  {get employee record by its UTR code}
  Function GetEmployeeByUTR(Const pUTR: String): IEmployee5;
  Var
    lRes: Integer;
  Begin
    Result := Nil;
    With fToolKit.JobCosting Do
    Begin
      lRes := Employee.GetFirst;

      While lRes = 0 Do
      Begin
        If Lowercase(Trim((Employee As IEmployee5).emUTRCode)) =
          Lowercase(Trim(pUTR)) Then
        Begin
          Result := Employee As IEmployee5;
          Break;
        End; {if Lowercase(Trim((Employee as IEmployee5).emUTRCode)) = Lowercase(Trim(pUTR)) then}

        lRes := Employee.GetNext;
      End; {while lRes = 0 do}
    End; {with fToolKit.JobCosting do}
  End; {function GetEmployeeByUTR(const pUTR: String): IEmployee5;}

  {get the representative exchequer tax number}
  Function GetTaxRateNo(Const pTax: String): Integer;
  Var
    lCont: Integer;
  Begin
    Result := 0;

    For lCont := Low(cCISTAXRATE) To High(cCISTAXRATE) Do
      If lowercase(Trim(cCISTAXRATE[lCont].Name)) = lowercase(Trim(pTax)) Then
      Begin
        Result := cCISTAXRATE[lCont].TaxNo;
        Break;
      End; {If lowercase(Trim(cCISTAXRATE[lCont].Name)) = lowercase(Trim(pTax)) Then}
  End; {function GetTaxRateNo(const pTax: String): Integer;}

  {get the representative exchequer tax number}
  Function GetTaxName(Const pTaxCode: Integer): String;
  Var
    lCont: Integer;
  Begin
    Result := inttostr(pTaxCode);

    For lCont := Low(cCISTAXRATE) To High(cCISTAXRATE) Do
      If cCISTAXRATE[lCont].TaxNo = pTaxCode Then
      Begin
        Result := cCISTAXRATE[lCont].Name;
        Break;
      End; {If cCISTAXRATE[lCont].TaxNo = pTaxCode Then}
  End; {Function GetTaxName(Const pTaxCode: Integer): String;}

Var
  lEmp, lUpd: IEmployee5;
  lSearch, lVerNo, lTaxTreat: String;
  lRes, lTaxBefore, lLineNo: Integer;
  lTaxUpdated: Boolean;
  lNote: INotes;
Begin
  If pSub <> Nil Then
    With pSub Do
      If Children.Count > 0 Then
      Begin
        {loading the search key to match exchequer record employee}
        Try
          If Children.NodeByName[CIS_SUBCONTRACTOR_WORKSREF] <> Nil Then
            lSearch :=
              Trim(Children.NodeByName[CIS_SUBCONTRACTOR_WORKSREF].AsString);
        Except
        End;

        {if worksref is empty, the utr must be used instead}
        If lSearch = '' Then
        Try
          If Children.NodeByName[CIS_SUBCONTRACTOR_UTR] <> Nil Then
            lSearch := Trim(Children.NodeByName[CIS_SUBCONTRACTOR_UTR].AsString);
        Except
        End;

        {load the verification number}
        Try
          If Children.NodeByName[CIS_SUBCONTRACTOR_VERIFICATION_NO] <> Nil Then
            lVerNo :=
              Trim(Children.NodeByName[CIS_SUBCONTRACTOR_VERIFICATION_NO].AsString);
        Except
        End;

        {load the tax treatment}
        Try
          If Children.NodeByName[CIS_SUBCONTRACTOR_TAXTREATMENT] <> Nil Then
            lTaxTreat :=
              Trim(Children.NodeByName[CIS_SUBCONTRACTOR_TAXTREATMENT].AsString);
        Except
        End;

        {if all main values have been found}
        If (lSearch <> '') And (lVerNo <> '') And (lTaxTreat <> '') Then
        Begin
          lEmp := Nil;
          {search for worksref code}
          Try
            lEmp := GetEmployeeByCode(lSearch);
          Except
          End;

          {search for utr code}
          If lEmp = Nil Then
          Try
            lEmp := GetEmployeeByUTR(lSearch);
          Except
          End;

          {check employee record returned}
          If lEmp <> Nil Then
          Begin
            lUpd := Nil;

            {get employee updated record}
            Try
              lUpd := (lEmp As IEmployee2).Update As IEmployee5;
            Except
            End;

            {double check the updated object}
            If lUpd <> Nil Then
            Begin
              lTaxUpdated := False;
              lTaxBefore := lUpd.emCertificateType;

              Try
                {set tax treatment number}
                If lUpd.emCertificateType <> GetTaxRateNo(lTaxTreat) Then
                Begin
                  lUpd.emCertificateType := GetTaxRateNo(lTaxTreat);
                  lTaxUpdated := True;
                End; {if lUpd.emCertificateType <> GetTaxRateNo(lTaxTreat) then}

                {set verification number returned}
                lUpd.emVerificationNo := lVerNo;
                lUpd.emTagged := False;

                lRes := 0;

                Try
                  lRes := (lUpd As IEmployee2).Save;
                Except
                End;

                If lRes <> 0 Then
                Begin
                  Result := cEXCHERROR;
                  try
                    (lUpd As IEmployee2).Cancel;
                  except
                  end;
                    
                  DoLogMessage('TSubContractorImport.UpdateEmployeeRec', Result,
                    'Error updating Employee record. Error: ' + inttostr(lRes) +
                      ' - '
                    + fToolKit.LastErrorString + '. Employee: ' + Trim(lEmp.emCode)
                      +
                    ' ' + Trim(lEmp.emName), True, True);
                End
                Else
                Begin
                  Result := S_OK;
                  DoLogMessage('TSubContractorImport.UpdateEmployeeRec', 0,
                    'Employee record successfully updated! Employee: ' +
                    Trim(lEmp.emCode) + ' ' + Trim(lEmp.emName), True, True);

                  {add dated note against the employee record}
                  lLineNo := lEmp.emNotes.GetLast;
                  With lEmp.emNotes.Add Do
                  Begin
                    ntLineNo := lLineNo + 1;
                    ntType := ntTypeDated;
                    ntDate := DateToStr8(Now);
                    If lTaxUpdated Then
                      ntText := 'Previous Tax Treatment ' + GetTaxName(lTaxBefore) +
                        ' replaced by ' + lTaxTreat + ' by online verification (' +
                        lVerNo + ')'
                    Else
                      ntText := 'Tax treatment verified by online verification (' +
                        lVerNo + ')';

                    lRes := Save;
                    If lRes <> 0 Then
                      lEmp.emNotes.Cancel;
                  End; {with lEmp.emNotes.Add do}
                End;
              Finally
                lUpd := Nil;
              End;
            End {if lUpd <> nil then}
            Else
            Begin
              Result := cEXCHERROR;
              DoLogMessage('TSubContractorImport.UpdateEmployeeRec', Result,
                'Error getting Update Object. Employee: ' + lEmp.emCode + ' ' +
                Trim(lEmp.emName), True, True);
            End;
          End {if lEmp <> nil then}
          Else
          Begin
            Result := cDBNORECORDFOUND;
            DoLogMessage('TSubContractorImport.UpdateEmployeeRec', Result,
              'Employee record not found. Search value: ' + lSearch, True, True);
          End;
        End {if (lSearch <> '') and (lVerNo <> '') and (lTaxTreat <> '') then}
        Else
        Begin
          Result := cINVALIDXMLNODE;
          DoLogMessage('TSubContractorImport.UpdateEmployeeRec', Result,
            'Could not load parameters from CIS XML.');
        End;
      End; {If pSub <> Nil Then}
End;

End.


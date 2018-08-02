unit CompInfo;

interface

Uses Classes, SysUtils, VarConst;

Const
  CompanyInfoName = 'Company.Info';

Function ReadCompInfo (Const CompanyPath : ShortString; Var CompanyRec : CompanyDetRec) : Boolean;
Procedure WriteCompInfo (Const CompanyRec : CompanyDetRec);

implementation

Uses Crypto, GmXML;

//=========================================================================

// <CompanyDetails>
//   <Code>ZZZZ01</Code>
//   <Name>Mad Cow Burgers Ltd</Name>
// </CompanyDetails>

//=========================================================================

Procedure WriteCompInfo (Const CompanyRec : CompanyDetRec);
Var
  sXML : ANSIString;
Begin // WriteCompInfo
  // Create XML
  sXML := '<CompanyDetails Version="1.0">' +
            '<Code>' + Trim(CompanyRec.CompCode) + '</Code>' +
            '<Name>' + Trim(CompanyRec.CompName) + '</Name>' +
          '</CompanyDetails>';

  // Encrypt the XML for security
  EncodeDataKey (666, @sXML[1], Length(sXML));

  // Create the Company.Info temporary file
  With TFileStream.Create(IncludeTrailingPathDelimiter(Trim(CompanyRec.CompPath)) + 'Company.Info', fmCreate) Do
  Begin
    Try
      Position := 1;
      Write (sXML[1], Length(sXML));
    Finally
      Free;
    End;
  End; // With TFileStream.Create(Result)
End; // WriteCompInfo

//-------------------------------------------------------------------------

Function ReadCompInfo (Const CompanyPath : ShortString; Var CompanyRec : CompanyDetRec) : Boolean;
Var
  oXML : TGmXML;
  oCompanyDetailsNode, oNode : TGmXMLNode;
  sXML : ANSIString;
Begin // ReadCompInfo
  Result := FileExists(CompanyPath + CompanyInfoName);

  FillChar(CompanyRec, SizeOf(CompanyRec), #0);

  If Result then
  Begin
    With TFileStream.Create(CompanyPath + CompanyInfoName, fmOpenRead Or fmShareDenyNone) Do
    Begin
      Try
        Position := 1;
        sXML := StringOfChar(#0, Size);
        Read (sXML[1], Length(sXML));

        DecodeDataKey (666, @sXML[1], Length(sXML));

        // Crack the XML and update the licencing object
        oXML := TGmXML.Create(NIL);
        Try
          oXML.Text := sXML;

          // IAO Version
          oCompanyDetailsNode := oXML.Nodes.NodeByName['CompanyDetails'];
          If Assigned(oCompanyDetailsNode) Then
          Begin
            oNode := oCompanyDetailsNode.Children.NodeByName['Code'];
            If Assigned(oNode) Then
              CompanyRec.CompCode := oNode.AsString;

            oNode := oCompanyDetailsNode.Children.NodeByName['Name'];
            If Assigned(oNode) Then
              CompanyRec.CompName := oNode.AsString;
          End; // If Assigned(oCompanyDetailsNode)
        Finally
          oXML.Free;
        End; // Try..Finally
      Finally
        Free;
      End;
    End; // With TFileStream.Create(CompanyPath + CompanyInfoName, fmOpenRead Or fmShareDenyNone)
  End; // If Result
End; // ReadCompInfo

//-------------------------------------------------------------------------

end.

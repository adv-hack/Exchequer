Unit oScanCompanies;

Interface

Uses Classes, Forms, StrUtils, SysUtils, Windows, StdCtrls;

Type
  TDocumentNumberReport = Class(TStringList)
  Private
    // Don't show warnings for certain non-transactional types which will go beyond
    // 3.2 mullion without issues as they are not used in OurRefs.
    Function DisplayWarningForType (Const CountType : String) : Boolean;
  Public
    Procedure ScanCompanies (Const lblProgress : TLabel);
  End; // TDocumentNumberReport

Implementation

Uses Enterprise01_TLB, oExchqNumFile, XMLFuncs, History, ExchequerRelease;

//=========================================================================

// Don't show warnings for certain non-transactional types which will go beyond
// 3.2 mullion without issues as they are not used in OurRefs.
Function TDocumentNumberReport.DisplayWarningForType (Const CountType : String) : Boolean;
Begin // DisplayWarningForType
  Result := (CountType <> 'ACQ') And    // Automatic Cheque Number
            (CountType <> 'AFL') And    // -ve Folio Number used by Orders, etc...
            (CountType <> 'FOL') And    // Folio Number
            (CountType <> 'JBF') And    // Job Folio
            (CountType <> 'QBF') And    // Qty Break Folio
            (CountType <> 'RUN') And    // Posting Run Number
            (CountType <> 'SKF');       // Stock Folio
End; // DisplayWarningForType

//-------------------------------------------------------------------------

Procedure TDocumentNumberReport.ScanCompanies (Const lblProgress : TLabel);
Var
  oToolkit : IToolkit;
  oCompany : ICompanyDetail;
  oExchqNumFile : TExchqNumBtrieveFile;
  sXML : String;
  I, Res : Integer;
Begin // ScanCompanies
  // Add the header of the XML file
  Add ('<?xml version="1.0" encoding="ISO-8859-1" ?>');
  Add ('<ExchequerDocumentNumbers ExportTime="' + FormatDateTime('hh:nn dd/mm/yyyy', Now) + '" Version="' + ExchequerModuleVersion (emDocNos, ExchDocNosBuildNo) + '" >');

  // Use a COM Toolkit instance to run through the Companies - don't need to open the toolkit
  // to access the Company information
  oToolkit := CoToolkit.Create;
  Try
    For I := 1 To oToolkit.Company.cmCount Do
    Begin
      oCompany := oToolkit.Company.cmCompany[I];

      // Update the progress label
      lblProgress.Caption := Trim(oCompany.coCode) + ' - ' + Trim(oCompany.coName);
      lblProgress.RePaint;

      // Add the company header into the XML
      Add ('  <CompanyDetail Code="' + WebEncode(Trim(oCompany.coCode)) + '" Name="' + WebEncode(Trim(oCompany.coName)) + '" Path="' + WebEncode(Trim(oCompany.coPath)) + '" >');

      // Open the ExchqNum.Dat file directly as using the Toolkit we need to embed the
      // codes of the document types, meaning that it wouldn't report any new ones added
      oExchqNumFile := TExchqNumBtrieveFile.Create;
      Try
        Res := oExchqNumFile.OpenFile (IncludeTrailingPathDelimiter(Trim(oCompany.coPath)) + 'ExchqNum.Dat');
        If (Res = 0) Then
        Begin
          // Run through all the document numbers writing them out to the XML
          Res := oExchqNumFile.GetFirst;
          While (Res = 0) Do
          Begin
            // Suppress any unmodified entries
            If (oExchqNumFile.NextNumber < -1) Or (oExchqNumFile.NextNumber > 1) Then
            Begin
              sXML := '    <DocumentNumber Type="' + oExchqNumFile.Code + '" Next="' + IntToStr(oExchqNumFile.NextNumber) + '"';

              // Check to see if a warning should be shown against this entry
              If (ABS(oExchqNumFile.NextNumber) >= 2500000) And DisplayWarningForType(oExchqNumFile.Code) Then
                sXML := sXML + ' Warning="Approaching maximum value"';

              Add (sXML + ' />');
            End; // If (oExchqNumFile.NextNumber < -1) Or (oExchqNumFile.NextNumber > 1)

            Res := oExchqNumFile.GetNext;
          End; // While (Res = 0)

          oExchqNumFile.CloseFile;
        End // If (Res = 0)
        Else
          Add ('    <Error Code="' + IntToStr(Res) + '" Desc="Error opening ExchqNum.Dat" />');
      Finally
        oExchqNumFile.Free;
      End; // Try..Finally

      // Finish off the company detail section
      Add ('  </CompanyDetail>');
      oCompany := NIL;
    End; // For I
  Finally
    oToolkit := NIL;
  End; // Try..Finally

  // Finish off the XML
  Add ('</ExchequerDocumentNumbers>');
End; // ScanCompanies

//=========================================================================

End.

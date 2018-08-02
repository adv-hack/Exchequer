unit CompanyReport;

interface

Uses RPFiler, RPFPrint;

Type
  tsFontTypeList = (ftHdr, ftNormal, ftBNormal, ftSubTitle);
  tsTabTypeList = (ftCompanyPaths, ftReportingUser);

  //------------------------------

  TCompanyReport = Class(TObject)
  Private
    FReport : TReportFiler;
    FReportPrinter : TFilePrinter;

    Procedure DoFont (Const FontType : tsFontTypeList);
    Procedure DoTabs (Const TabType : tsTabTypeList);

    procedure ReportFiler1BeforePrint(Sender: TObject);
    procedure ReportFiler1Print(Sender: TObject);
    procedure ReportFiler1NewPage(Sender: TObject);
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Print;
  End; // TCompanyReport

implementation

Uses Classes, Graphics, SysUtils, Types, Windows, RpDevice, RpDefine, oConvertOptions;

//=========================================================================

Constructor TCompanyReport.Create;
Begin // Create
  Inherited Create;

  FReport := TReportFiler.Create(NIL);
  With FReport Do
  Begin
    LineHeightMethod := lhmFont;
    Title := 'Post Conversion Company Details';
    StreamMode := smTempFile;
    Units := unMM;

    OnBeforePrint := ReportFiler1BeforePrint;
    OnNewPage := ReportFiler1NewPage;
    OnPrint := ReportFiler1Print;
  End; // With FReport

  FReportPrinter := TFilePrinter.Create(NIL);
  With FReportPrinter Do
  Begin
    PrintTitle := FReport.Title;
    StreamMode := smTempFile;
  End; // With FReportPrinter
End; // Create

Destructor TCompanyReport.Destroy;
Begin // Destroy
  FreeAndNIL(FReport);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TCompanyReport.Print;
Begin // Print
  If RpDev.PrinterSetUpDialog Then
  Begin
    //FReport.FileName := 'C:\Report.EDF';
    FReport.Execute;
    FReportPrinter.Filename := FReport.Filename;
    FReportPrinter.Execute;
  End; // If RpDev.PrinterSetUpDialog
End; // Print

//=========================================================================

procedure TCompanyReport.ReportFiler1BeforePrint(Sender: TObject);
begin
  FReport.Orientation := RpDev.Orientation;

  FReport.MarginLeft   := 2 * FReport.LeftWaste;
  FReport.MarginRight  := 2 * FReport.RightWaste;
  FReport.MarginTop    := 2 * FReport.TopWaste;
  FReport.MarginBottom := 2 * FReport.BottomWaste;
end;

//-------------------------------------------------------------------------

procedure TCompanyReport.ReportFiler1NewPage(Sender: TObject);
begin
  With FReport Do
  Begin
    Home;

    DoFont (ftNormal);
    PrintRight(ConCat('Printed :',DateToStr(Now),' - ',TimeToStr(Now)),PageWidth-MarginRight);
    CRLF;

    DoFont (ftHdr);
    PrintLeft('Post Conversion Company Details', MarginLeft);
    DoFont (ftNormal);
    PrintRight (Concat('Page ', IntToStr(CurrentPage),' of ',Macro(midTotalPages)), PageWidth - MarginRight);
    CRLF;
    CRLF;

    // Draw line across report
    SetPen(clBlack,psSolid,-2,pmCopy);
    MoveTo(MarginLeft,YD2U(CursorYPos)-4.3);
    LineTo((PageWidth-1-MarginRight),YD2U(CursorYPos)-4.3);
    MoveTo(1,YD2U(CursorYPos));
  End; // With FReport
end;

//------------------------------

procedure TCompanyReport.ReportFiler1Print(Sender: TObject);
Var
  iCompany, J : LongInt;
begin
  With FReport Do
  Begin
    For iCompany := 0 To (ConversionOptions.coCompanyCount - 1) Do
    Begin
      // check for space
      If (FReport.LinesLeft < 8) Then FReport.NewPage;

      With ConversionOptions.coCompanies[iCompany] Do
      Begin
        DoTabs(ftCompanyPaths);
        DoFont(ftSubTitle);
        PrintLn (#9 + Trim(ccCompanyCode) + ' - ' + Trim(ccCompanyName));

        DoFont(ftNormal);
        PrintLn (#9 + 'Pervasive Installation:' + #9 + Trim(ccCompanyPath));
        PrintLn (#9 + 'SQL Installation:' + #9 + ccSQLCompanyPath);

        DoTabs(ftReportingUser);
        PrintLn (#9 + 'Reporting User ID:' + #9 + Trim(ccReportingUserId) + #9'Password:' + #9 + Trim(ccReportingUserPwd));
        CRLF;
        CRLF;
      End; // With ConversionOptions.coCompanies[iCompany]
    End; // For iCompany
  End; // With FReport
end;

//-------------------------------------------------------------------------

Procedure TCompanyReport.DoTabs (Const TabType : tsTabTypeList);
Begin // DoTabs
  With FReport Do
  Begin
    ClearTabs;

    Case TabType Of
      ftCompanyPaths   : Begin
                           SetTab (MarginLeft , pjLeft, 40,   4, 0, 0);
                           SetTab (NA,          pjLeft, 200,  4, 0, 0);
                         End;
      ftReportingUser  : Begin
                           SetTab (MarginLeft , pjLeft, 40,  4, 0, 0);
                           SetTab (NA,          pjLeft, 40,  4, 0, 0);
                           SetTab (NA,          pjLeft, 22,  4, 0, 0);
                           SetTab (NA,          pjLeft, 60,  4, 0, 0);
                         End;
    End; // Case TabType
  End; // With FReport
End; // DoTabs

//-------------------------------------------------------------------------

Procedure TCompanyReport.DoFont (Const FontType : tsFontTypeList);
Begin // DoFont
  With FReport Do
  Begin
    FontName := 'Arial';
    FontColor := clBlack;
    Bold := False;
    Italic := False;
    UnderLine := False;

    SetPen (clBlack, psSolid, -1, pmCopy);
    SetBrush (clWhite, bsClear, Nil);

    Case FontType Of
      ftHdr       : Begin
                      FontSize := 10;
                      Bold := True;
                    End;
      ftNormal    : Begin
                      FontSize := 8;
                    End;
      ftBNormal   : Begin
                      FontSize := 8;
                      Bold := True;
                    End;
      ftSubTitle  : Begin
                      FontSize := 9;
                      Bold := True;
                    End;
    End; // Case FontType
  End; // With FReport
End; // DoFont

//=========================================================================

end.

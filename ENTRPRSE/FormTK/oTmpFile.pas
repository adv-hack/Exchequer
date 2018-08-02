unit oTmpFile;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     EnterpriseForms_TLB, RpDevice, IniFiles, Registry;

type
  TEFPrintTempFile = class(TAutoIntfObject, IEFPrintTempFile)
  private
    // Success status from PrintToTempFile call
    FStatus                 : Integer;

    // Destination flag - Printer/Email/Fax/...
    FDestType               : TEFTempFileDestination;

    // Print Job Information
    FPrnSetupInfo           : TSBSPrintSetupInfo;
    FTKPrintData            : TFormToolkitData;

    // Page numbers for partial print job printing
    FStartPage, FFinishPage : Integer;
  protected
    // IEFPrintTempFile
    function Get_pfType: TEFTempFileDestination; safecall;
    function Get_pfFileName: WideString; safecall;
    function Get_pfPages: Integer; safecall;
    function Get_pfStartPage: Integer; safecall;
    procedure Set_pfStartPage(Value: Integer); safecall;
    function Get_pfFinishPage: Integer; safecall;
    procedure Set_pfFinishPage(Value: Integer); safecall;
    function Get_pfCopies: Integer; safecall;
    procedure Set_pfCopies(Value: Integer); safecall;
    function Get_pfStatus: Integer; safecall;
    function DisplayPreviewWindow(PreviewType: TEFPreviewType): Integer; safecall;
    function SendToDestination: Integer; safecall;
    function SaveAsFile(const FilePath: WideString; FileType: TEFSaveAsType): Integer; safecall;

    // Local methods
    Procedure Bang;
    function  DisplayEDFPreview : Integer;
    function  DisplayNonModalPreview : Integer;
    function  SendToPrinter: Integer;
    function  SendToEmail: Integer;
    function  SendToFax: Integer;
  public
    Constructor Create (Const Destination    : TEFTempFileDestination;
                        Const PrintSetupInfo : TSBSPrintSetupInfo;
                        Const TKPrintData    : TFormToolkitData;
                        Const Status         : Integer);
    Destructor Destroy; override;
  End; { TEFPrintTempFile }

implementation

uses ComServ,
     ShellAPI,     // Shell Interface e.g. ShellExecute
     TEditVal,     // Exchequer Components & Global Vars
     RPDefine,     // RAVE Constants
     RPFPrint,     // Rave TFilePrinter component
     RPRender,     // RAVE Rendering Components
     RPRender_PDF, // RAVE PDF Rendering Components
     GlobType,     // Form Designer Global Variables/Types
     VarConst,     // Exchequer Global Constants/Types/Variables
     PrntForm,     // Form Designer Form Printing Routines
     FaxIntO,      // Interface Object for FaxBtrv.Dll
     DelTemp,      // Delete List for temporary files
     MiscFunc,     // Miscellaneous Functions / Types / Constants for the Form TK
     CommsInt,     // Interface objects to EntComms.Dll for Email/Fax/PK-ZIP
     PreviewF,     // Print Preview form
     // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
     MadExcept,
     LogUtil;

//-----------------------------------------------------------------------------

Constructor TEFPrintTempFile.Create (Const Destination    : TEFTempFileDestination;
                                     Const PrintSetupInfo : TSBSPrintSetupInfo;
                                     Const TKPrintData    : TFormToolkitData;
                                     Const Status         : Integer);
Begin { Create }
  OutputDebug('TEFPrintTempFile.Create Start');
  Inherited Create (ComServer.TypeLib, IEFPrintTempFile);

  FStatus := Status;
  FDestType     := Destination;
  FPrnSetupInfo := PrintSetupInfo;
  FTKPrintData  := TKPrintData;

  // Local properties
  FStartPage  := 0;
  FFinishPage := 0;
  OutputDebug('TEFPrintTempFile.Create End');
End; { Create }

//---------------------------------------

Destructor TEFPrintTempFile.Destroy;
Begin { Destroy }
  // Add into list to be deleted on shutdown
  AddToDeleteList(FTKPrintData.ftdTempFile);

  Inherited Destroy;
End; { Destroy }

//-----------------------------------------------------------------------------

Procedure TEFPrintTempFile.Bang;
Begin { Bang }
  If (FStatus <> 0) Then
    Raise Exception.Create ('Function not available due to Error ' + IntToStr(FStatus) + ' during PrintToTempFile');
End; { Bang }

//-----------------------------------------------------------------------------

function TEFPrintTempFile.Get_pfType: TEFTempFileDestination;
begin
  Bang;
  Result := FDestType;
end;

//---------------------------------------

function TEFPrintTempFile.Get_pfFileName: WideString;
begin
  Bang;
  Result := FTKPrintData.ftdTempFile;
end;

//---------------------------------------

function TEFPrintTempFile.Get_pfPages: Integer;
begin
  Bang;
  Result := FTKPrintData.ftdPages;
end;

//---------------------------------------

function TEFPrintTempFile.Get_pfStartPage: Integer;
begin
  Bang;
  Result := FStartPage;
end;

procedure TEFPrintTempFile.Set_pfStartPage(Value: Integer);
begin
  Bang;
  If (Value >= 0) And (Value <= FTKPrintData.ftdPages) Then
    FStartPage := Value
  Else
    Raise Exception.Create ('The specified StartPage is invalid');
end;

//---------------------------------------

function TEFPrintTempFile.Get_pfFinishPage: Integer;
begin
  Bang;
  Result := FFinishPage;
end;

procedure TEFPrintTempFile.Set_pfFinishPage(Value: Integer);
begin
  Bang;
  If (Value >= 0) And (Value <= FTKPrintData.ftdPages) Then
    FFinishPage := Value
  Else
    Raise Exception.Create ('The specified FinishPage is invalid');
end;

//---------------------------------------

function TEFPrintTempFile.Get_pfCopies: Integer;
begin
  Bang;
  Result := FPrnSetupInfo.NoCopies;
end;

procedure TEFPrintTempFile.Set_pfCopies(Value: Integer);
begin
  Bang;
  If (Value > 0) And (Value <= 32000) Then
    FPrnSetupInfo.NoCopies := Value
  Else
    Raise Exception.Create ('The Number of Copies must be in the range 1 to 32,000');
end;

//---------------------------------------

function TEFPrintTempFile.Get_pfStatus: Integer;
begin
  Result := FStatus;
end;

//-----------------------------------------------------------------------------

function TEFPrintTempFile.DisplayPreviewWindow (PreviewType: TEFPreviewType) : Integer;
begin
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    LastErDesc := '';

    Case PreviewType Of
      ptNonModal   : Result := DisplayNonModalPreview;
      ptEDFReader  : Result := DisplayEDFPreview;
    Else
      Raise Exception.Create ('IEFPrintTempFile.DisplayPreviewWindow: Unhandled PreviewType (' + IntToStr(Ord(PreviewType)) + ')');
    End; { Case PreviewType }
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
end;

//---------------------------------------

// Use the Exchequer EDF Reader to display the temporary file - return the EDF Reader HInstance
function TEFPrintTempFile.DisplayEDFPreview : Integer;
Var
  ExecPath, EDFFile, DefDir : ANSIString;
begin
  ExecPath := ExtractFilePath(Application.ExeName) + 'EDFREADR.EXE';
  EDFFile := FTKPrintData.ftdTempFile;
  DefDir := ExtractFilePath(Application.ExeName);
  Result := ShellExecute (0, 'open', PCHAR(ExecPath), PCHAR(EDFFile), PCHAR(DefDir), SW_ShowNormal);
end;

//---------------------------------------

function TEFPrintTempFile.DisplayNonModalPreview : Integer;
begin
  // Create an instance of the Preview Form
  With TfrmFTKPreview.Create(Application) Do Begin
    // Setup the Print Preview details
    iTmpFile := Self;
    PreviewFile := FTKPrintData.ftdTempFile;

    // Display the form causing the the preview to start from the OnActivate event
    Show;

    // Return the form handle to the calling app
    Result := Handle;
  End; { With TfrmFTKPreview.Create(Application) }
end;

//-----------------------------------------------------------------------------

function TEFPrintTempFile.SendToDestination: Integer;
begin
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    LastErDesc := '';

    Case FDestType Of
      tfdPrinter : Result := SendToPrinter;
      tfdEmail   : Result := SendToEmail;
      tfdFax     : Result := SendToFax;
    Else
      Raise Exception.Create ('Unknown Destination Type (' + IntToStr(Ord(FDestType)) + ') in IEFPrintTempFile.SendToDestination - Contact your Technical Support');
    End; { Case FDestType }
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;

end;

//---------------------------------------

function TEFPrintTempFile.SendToPrinter: Integer;
Var
  I : SmallInt;
Begin { SendToPrinter }
  OutputDebug('TEFPrintTempFile.SendToPrinter Start');
  Result := 0;

  Try
    With TFilePrinter.Create(Application.MainForm) Do
    Try
      StreamMode := smFile;
      FileName := FTKPrintData.ftdTempFile;
      PrintTitle := FPrnSetupInfo.feJobTitle;

      If (FStartPage = 0) Or (FFinishPage = 0) Or (FFinishPage < FStartPage) Then Begin
        // Print entire document
        For I := 1 To FPrnSetupInfo.NoCopies Do
          Execute;
      End { If (FStartPage = 0) And (FFinishPage = 0)  }
      Else Begin
        // Print subrange of document
        For I := 1 To FPrnSetupInfo.NoCopies Do
          ExecuteCustom (FStartPage, FFinishPage, 1);
      End; { Else }
    Finally
      Free;
    End;
    OutputDebug('TEFPrintTempFile.SendToPrinter End');
  Except
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;

End; { SendToPrinter }

//---------------------------------------

function TEFPrintTempFile.SendToEmail: Integer;
Var
  FilePrinter1 : TFilePrinter;
Begin { SendToEmail }
  OutputDebug('TEFPrintTempFile.SendToEmail Start');
  Result := 0;
  Try
    FilePrinter1 := TFilePrinter.Create(Application.MainForm);
    With FilePrinter1 Do
    Try
      StreamMode := smFile;
      FileName := FTKPrintData.ftdTempFile;
      PrintTitle := FPrnSetupInfo.feJobTitle;

      OutputDebug('TEFPrintTempFile.SendToEmail Call SendEmailFile2');
      SendEmailFile2 (FPrnSetupInfo, FilePrinter1, FilePrinter1.Filename, False);
    Finally
      Free;
    End;
    OutputDebug('TEFPrintTempFile.SendToEmail End');
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;

End; { SendToEmail }

//---------------------------------------

function TEFPrintTempFile.SendToFax: Integer;
Var
  FilePrinter1 : TFilePrinter;
Begin { SendToFax }
  Result := 0;
  OutputDebug('TEFPrintTempFile.SendToFax Start Fax Method=' + IntToStr(FPrnSetupInfo.feFaxMethod));
  Try
    Case FPrnSetupInfo.feFaxMethod Of
      0,          // Exchequer E-Comms
      2  : Begin  // Third-Party
              // Setup behind the scenes info for the Print Job
              With TEntFaxInt.Create Do
                Try
                  fxDocName := 'Exchequer Fax';

                  fxRecipName := FPrnSetupInfo.feFaxTo;
                  fxRecipNumber := FPrnSetupInfo.feFaxToNo;

                  fxSenderName := FPrnSetupInfo.feFaxFrom;
                  fxSenderEmail := FPrnSetupInfo.feEmailFromAd;

                  fxUserDesc := FTKPrintData.ftdFaxDesc;

                  InitFromPrnInfo (FPrnSetupInfo);

                  fxFaxDir:=SyssEDI2^.EDI2Value.FaxDLLPath;

                  Result := 1000 + StoreDetails;  {Sent via main program}

                  If (Result = 1000) Then Begin
                    { AOK - pull back print job title }
                    FPrnSetupInfo.feJobtitle := fxDocName;
                    Result := 0;
                  End { If (Result = 1000) }
                  Else
                    LastErDesc := 'Error ' + IntToStr(Result - 1000) + ' storing the Fax Details';
                Finally
                  Free;
                End;

             If (Result = 0) Then Begin
               // Print the Fax Job
               FilePrinter1 := TFilePrinter.Create(Application.MainForm);
               With FilePrinter1 Do
                 Try
                   StreamMode := smFile;
                   FileName := FTKPrintData.ftdTempFile;
                   PrintTitle := FPrnSetupInfo.feJobTitle;

                   SendEntFax (FPrnSetupInfo, FilePrinter1, FTKPrintData.ftdTempFile, (FPrnSetupInfo.feFaxMethod = 0));
                 Finally
                  Free;
                 End;
             End; { If (Result = 1000) }
           End;

      1  : Begin  // MAPI
             SendMAPIFax (FPrnSetupInfo, FTKPrintData.ftdTempFile);
           End;
    End; { Case FPrnSetupInfo.feFaxMethod }
    OutputDebug('TEFPrintTempFile.SendToFax End');
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
End; { SendToFax }

//-----------------------------------------------------------------------------

// The following Error codes are returned:-
//
// 1000    Unexpected exception see LastErrorDesc
// 1001    Error copying file to destination
// 1002    Exchequer Data Set not Configured to support PDF files
// 1003    Internal PDF not available for print jobs of this type
// 1004    Incorrect file extension
// 1005    Paperless Module not licenced
//
// 2000+   Error in PK-ZP routines whilst creating an .EDZ file
//
function TEFPrintTempFile.SaveAsFile(const FilePath: WideString; FileType: TEFSaveAsType): Integer;

  //------------------------------

  Function CheckFileExt (const FilePath, OKExt : ShortString) : Boolean;
  Begin { CheckFileExt }
    Result := (UpperCase(ExtractFileExt (FilePath)) = UpperCase(OKExt));
  End; { CheckFileExt }

  //------------------------------

  Function CopyAFile (Const FromPath, ToPath : ANSIString) : Boolean;
  Begin { CopyAFile }
    // Ensure the destination directory exists
    Result := ForceDirectories(ExtractFilePath(ToPath));

    If Result Then
      // Copy the file
      Result := CopyFile (PCHAR(FromPath), PCHAR(ToPath), False);
  End; { CopyAFile }

  //------------------------------

  Function SaveAsAdobePDF : Integer;
  Var
    IniName : ShortString;
    SysDir  : PChar;
    I       : Integer;
  Begin { SaveAsAdobePDF }
    Result := 0;
    OutputDebug('SaveAsAdobePDF Start');
    Try
      // Get path of Win\SYS directory to look for Adobe PDF Writer .INI files
      SysDir := StrAlloc(255);
      GetSystemDirectory(SysDir, 255);
      IniName := IncludeTrailingPathDelimiter(SysDir);

      If ISWINNT Or ISWINNT4 Or ISWINNT5 Then Begin
        // Windows NT - Any Version
        If FileExists(IniName + 'SPOOL\DRIVERS\W32X86\2\__PDF.INI') Then
          IniName := IniName + 'SPOOL\DRIVERS\W32X86\2\__PDF.INI'
        Else
          If FileExists(IniName + 'SPOOL\DRIVERS\W32X86\__PDF.INI') Then
            IniName := IniName + 'SPOOL\DRIVERS\W32X86\__PDF.INI'
          Else
            IniName := IniName + '__PDF.INI';
      End { If }
      Else
        // Windows 9x
        IniName := IniName + 'PDFWRITR.INI';

      // If found setup the PDF Writer .INI file
      If (IniName <> '') And FileExists(IniName) Then
        With TIniFile.Create(IniName) Do
          Try
            WriteString ('Acrobat PDFWriter', 'PDFFileName', FilePath);
            WriteInteger ('Acrobat PDFWriter', 'bDocInfo', 0);
            WriteInteger ('Acrobat PDFWriter', 'FileNameSet', 1);
            WriteString ('Acrobat PDFWriter', 'szTitle', 'Exchequer Email');
            WriteString ('Acrobat PDFWriter', 'szAuthor', 'Exchequer');
          Finally
            Free;
          End;

      // Checks for and sets the Adove PDF Writer registry entries
      With TRegistry.Create Do
        Try
          Access := KEY_READ or KEY_WRITE;
          RootKey := HKEY_CURRENT_USER;

          If OpenKey('Software\Adobe\Acrobat PDFWriter', False) Then Begin
            WriteString('szAuthor', 'Exchequer');
            WriteString('szTitle', 'Exchequer Email');
            WriteString('PDFFileName', FilePath);
            WriteString('FileNameSet', '1');
            WriteString('bDocInfo', '0');
          End; { If }
          CloseKey;
        Finally
          Free;
        End;

      // Print the intermediate file to the PDF Writer printer driver }
      With TFilePrinter.Create(Application.MainForm) Do
        Try
          StreamMode   := smFile;
          FileName     := FTKPrintData.ftdTempFile;
          PrintTitle   := FPrnSetupInfo.feJobTitle;

          // Find ADOBE Driver
          For I := 0 To Pred(RpDev.Printers.Count) Do
            If (UpperCase(Trim(SyssEDI2^.EDI2Value.EmailPrnN)) = UpperCase(Trim(RpDev.Printers[I]))) Then Begin
              PrinterIndex := I;
              Break;
            End; { If }

          // Create the PDF file
          Execute;
        Finally
          Free;
        End;
        OutputDebug('SaveAsAdobePDF End');
    Except
      // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
      // Log the exception to file and re-raise it so the exception is passed back to the calling app
      AutoSaveBugReport(CreateBugReport(etNormal));
      Raise;
    End;
  End; { SaveAsAdobePDF }

  //------------------------------

  Function SaveAsRAVEPDF : Integer;
  Var
    RenderPDF  : TRPRenderPDF;
    NDRStream  : TMemoryStream;
    RenderUtil : TRenderingUtils;
  Begin { SaveAsRAVEPDF }
    Result := 0;
    OutputDebug('SaveAsRAVEPDF Start');
    Try
      // Create objects required to convert the EDF to PDF
      RenderPDF := TRPRenderPDF.Create(Application.MainForm);
      NDRStream := TMemoryStream.Create;
      If WantPDFCompression Then RenderUtil := TRenderingUtils.Create;
      Try
        If WantPDFCompression Then Begin
          RenderPDF.UseCompression := True;
          RenderPDF.OnCompress := RenderUtil.CompressPDF;
        End; { If WantPDFCompression }
        RenderPDF.InitFileStream (FilePath);

        NDRStream.LoadFromFile (FTKPrintData.ftdTempFile);
        With TRPConverter.Create (NDRStream, RenderPDF) Do
          Try
            Generate;
          Finally
            Free;
          End;
      Finally
        RenderPDF.Free;
        NDRStream.Free;
        If WantPDFCompression Then FreeAndNIL(RenderUtil);
      End;
      OutputDebug('SaveAsRAVEPDF End');
    Except
      On E:Exception Do Begin
        Result := 1004;
        LastErDesc := E.Message;
      End; { On }
    End;
  End; { SaveAsRAVEPDF }

  //------------------------------

Begin { SaveAsFile }
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  OutputDebug('TEFPrintTempFile.SaveAsFile Start');

  Try
    Result := 0;
    LastErDesc := '';

    // Check licencing limitations for paperless module
    If eCommsModule Then
      Case FileType Of
        saEDF  : Begin
                   // .SWP file is already in .EFD format - just need to copy to specified directory

                   // Check Extension of destination filename is correct
                   If Not CheckFileExt (FilePath, '.EDF') Then Begin
                     // Error - Incorrect file extension
                     Result := 1004;
                     LastErDesc := 'To save an EDF file the file extension must be .EDF';
                   End; { If Not CheckFileExt (FilePath, '.EDF') }

                   If (Result = 0) Then Begin
                     // Copy the file
                     If Not CopyAFile (FTKPrintData.ftdTempFile, FilePath) Then Begin
                       // Error copying file to destination
                       Result := 1001;
                       LastErDesc := 'Unknown error copying the EDF File to the destination filename';
                     End; { If Not CopyAFile (FTKPrintData.ftdTempFile, FilePath) }
                   End; { If (Result = 0) }
                 End;
        saEDZ  : Begin
                   // .SWP file is already in .EFD format - need to rename and PK-ZIP

                   // Check Extension of destination filename is correct
                   If Not CheckFileExt (FilePath, '.EDZ') Then Begin
                     // Error - Incorrect file extension
                     Result := 1004;
                     LastErDesc := 'To save an EDZ file the file extension must be .EDZ';
                   End; { If Not CheckFileExt (FilePath, '.EDZ') }

                   If (Result = 0) Then
                     // Need to create a temporary EDF File to go into the .EDZ file otherwise the EDF reader doesn't work
                     If CopyAFile (FTKPrintData.ftdTempFile, ChangeFileExt(FTKPrintData.ftdTempFile, '.EDF')) Then
                       Try
                         With TEntZip.Create Do
                           Try
                             DOSPaths := True;
                             StripPath := True;
                             Files.Add (ChangeFileExt(FTKPrintData.ftdTempFile, '.EDF'));
                             ZipName := FilePath;

                             Result := Save + 2000;
                             Case Result Of
                               2000  : Result := 0;
                               2001  : LastErDesc := 'ZIPError: No Files were found to compress';
                               2002  : LastErDesc := 'ZIPError: Failed to delete existing .ZIP file';
                               2003  : LastErDesc := 'ZIPError: Could not load EntComm2.Dll';
                             Else
                               LastErDesc := 'ZIPError  ' + IntToStr(Result - 2000) + ' in TEntZip.Save';
                             End; { Case Result }
                           Finally
                             Free;
                           End;
                       Finally
                         SysUtils.DeleteFile (ChangeFileExt(FTKPrintData.ftdTempFile, '.EDF'));
                       End
                     Else Begin
                       // Error copying file to destination
                       Result := 1001;
                       LastErDesc := 'Unknown error copying the EDF File for compression';
                     End; { Else }
                 End;

        saPDF  : Begin
                   // Check Extension of destination filename is correct
                   If Not CheckFileExt (FilePath, '.PDF') Then Begin
                     // Error - Incorrect file extension
                     Result := 1004;
                     LastErDesc := 'To save an PDF file the file extension must be .PDF';
                   End; { If Not CheckFileExt (FilePath, '.PDF') }

                   If (Result = 0) Then Begin
                     If (SyssEDI2^.EDI2Value.emAttchMode = 1) Then
                       // Uses Adobe Acrobat
                       Result := SaveAsAdobePDF
                     Else
                       If (SyssEDI2^.EDI2Value.emAttchMode = 2) Then Begin
                         // Uses Internal PDF - Check PrintJob was created using the PDF compatible commands
                         If (FPrnSetupInfo.fePrintMethod In [2, 4]) And (FPrnSetupInfo.feEmailAtType In [2, 3]) Then
                           Result := SaveAsRAVEPDF
                         Else Begin
                           // Internal PDF not available for print jobs of this type
                           Result := 1003;
                           LastErDesc := 'Internal PDF not available for print jobs of this type';
                         End; { Else }
                       End { If (SyssEDI2^.EDI2Value.emAttchMode = 2) }
                       Else Begin
                         // Exchequer Data Set not Configured to support PDF files
                         Result := 1002;
                         LastErDesc := 'The Paperless Module in this Exchequer Data Set is not Configured to support PDF files';
                       End; { Else }
                   End; { If (Result = 0) }
                 End;
      Else
        Raise EUnknownValue.Create (Format('Unknown FileType (%d) in IPrintTempFile.SaveAsFile', [Ord(FileType)]));
      End { Case FileType }
    Else Begin
      // Paperless Module not licenced
      Result := 1005;
      LastErDesc := 'SaveAsFile requires the Exchequer Paperless Module to be licenced and configured';
    End; { Else }
    OutputDebug('TEFPrintTempFile.SaveAsFile End');
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
End; { SaveAsFile }

//-----------------------------------------------------------------------------

end.

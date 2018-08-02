unit RWPrintR;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses Classes, Controls, Dialogs, FileCtrl, Forms, IniFiles, SysUtils, Windows,
     RpDevice, RpFiler, RPFPrint, TEditVal, Registry, RpMemo, RPRender,
     RPRender_PDF, RPRender_HTML, VRWReportIF;


type
  EEmailErr = class (Exception);

  TRenderingUtils = class (TObject)
  public
    procedure CompressPDF(InStream, OutStream: TStream; var CompressMethod: string);
  end; { TRenderingUtils }

procedure PrintFileTo(const PrnInfo           : TSBSPrintSetupInfo;
                      var PrnFile : ShortString;
                      const WinTitle : ShortString;
                      const ExternalReport : Boolean = FALSE;
                      const WndParent : TApplication = nil);

procedure SendEmailFile2(      PrnInfo     : TSBSPrintSetupInfo;
                         const FilePrinter : TFilePrinter;
                         const FName       : ShortString;
                         const DelFile     : Boolean);

procedure ConvertEDFToInternalPDF(const EDFPath, PDFPath : ShortString; const AutoOpen : Boolean);

procedure ConvertEDFToAdobePDF(const EDFPath : ShortString; var PDFPath : String; const PrnInfo : TSBSPrintSetupInfo);

procedure ConvertEDFToXLS(const EDFPath, XLSPath : ShortString;
                          const AutoOpen : Boolean);

procedure ConvertEDFToHTML(const EDFPath, HTMLPath : ShortString;
                           const AutoOpen : Boolean);
                          
procedure SendEntFax (const PrnInfo     : TSBSPrintSetupInfo;
                      const FilePrinter : TFilePrinter;
                      const FName       : ShortString;
                      const EntFaxing   : Boolean);


procedure SendMAPIFax (const PrnInfo : TSBSPrintSetupInfo;
                       const FName   : ShortString);


var
  NumPrevWins : LongInt;

implementation

uses GlobVar, VarConst, BtrvU2, BtSupU1, PrntPrev,
     CommsInt, ApiUtil, ZLIB, FileUtil, WinSpool,
     DateUtils, ShellAPI,
     dbfint, PrintFrm,
     RepEngIF, GlobalTypes; // my own

var
  WantPDFCompression : Boolean = True;
  CopyApplication : TApplication;

procedure DoLog(const s : string);
begin
{$IFDEF SENT}
  LogIt(spReportConveyor, s);
{$ENDIF}
end;

// Get CSV file name 
function GetCDFRepName(var LastPath : ShortString) : Boolean;
var
  SaveDialog1 : TSaveDialog;
  CurrPath    : string;
begin
  // Save current directory - as dialog screws it up 
  CurrPath := GetCurrentDir;

  SaveDialog1 := TSaveDialog.Create(Application.MainForm);
  try
    with SaveDialog1 do
    begin
      DefaultExt := 'CSV';
      FileName := LastPath;
      Options := [ofOverwritePrompt, ofPathMustExist];
      Title := 'Save CSV File As';
    end; 

    Result := SaveDialog1.Execute;

    if Result then
    begin
      LastPath := SaveDialog1.FileName;
    end; 
  finally
    SaveDialog1.Free;
  end;

  // restore current directory - as dialog can screw it up 
  SetCurrentDir (CurrPath);
end;

procedure PreviewPrintFile (const PrintFile : ShortString;
                            const PrinterNo : SmallInt;
                            const NoCopies  : SmallInt);
var
//  PrevCur           : TCursor;
  Form_PrintPreview : TForm_PrintPreview;
begin
  // Preview 
  Form_PrintPreview := TForm_PrintPreview.Create(Application.MainForm);
  try
    Form_PrintPreview.FilePreview1.FileName := PrintFile;
    Form_PrintPreview.FilePreview1.PrinterIndex := PrinterNo;
    Form_PrintPreview.FilePrinter1.FileName := PrintFile;
    Form_PrintPreview.FilePrinter1.PrinterIndex := PrinterNo;
    Form_PrintPreview.SetMode (1);

    Form_PrintPreview.Position  := Forms.poDefault;
    Form_PrintPreview.FormStyle := fsMDIChild;
    Form_PrintPreview.DoMenu;
  except
    {on EStreamError do
      MessageDlg ('Stream Error:' + CRLF + CRLF +
                  'An error has occured creating the print file for the form, ''' +
                  PrintFile + ''', form aborted.', mtError, [mbOk], 0);}
  end;

end;

procedure PrintFile (const PrintFile : ShortString;
                     const PrinterNo : SmallInt;
                     const NoCopies  : SmallInt);
var
  FilePrinter1 : TFilePrinter;
  I            : SmallInt;
begin
  FilePrinter1 := TFilePrinter.Create(Application.MainForm);
  try
    FilePrinter1.FileName := PrintFile;
    FilePrinter1.PrinterIndex := PrinterNo;

    for I := 1 to NoCopies do
      FilePrinter1.Execute;
  finally
    FilePrinter1.Free;

  end;
end;

procedure PrintFileTo(const PrnInfo           : TSBSPrintSetupInfo;
                      var PrnFile : ShortString;
                      const WinTitle : ShortString;
                      const ExternalReport : Boolean = FALSE;
                      const WndParent : TApplication = nil);
var
  Form_PrintPreview : TForm_PrintPreview;
  TmpInfo           : TSBSPrintSetupInfo;
  FilePrinter1      : TFilePrinter;
  I                 : SmallInt;
  PDFPrnInfo : TSBSPrintSetupInfo;
  PDFFile: string;

begin
  // Save printer settings
  TmpInfo := RpDev.SBSSetupInfo;

  if ((not PrnInfo.Preview) or (ExternalReport)) then
  begin
    if ExternalReport then
    begin
      case TReportFileFormat(PrnInfo.fePrintMethod) of
        INTERNAL_PDF_FILE :
          begin
            PDFFile := ChangeFileExt(PrnFile, '.pdf');
            ConvertEDFToInternalPDF(PrnFile, PDFFile, FALSE);
            PrnFile := PDFFile;
          end;
        ADOBE_PDF_FILE :
          begin
            PDFPrnInfo := PrnInfo;
            with PDFPrnInfo do
            begin
              // Set printer to Adobe PDF Writer
              DevIdx := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.EmailPrnN);
              FormNo := 0;
              FormName := '';
              BinNo := 0;
              BinName := '';
            end;
            // PrnFile - EDF path and filename
            PDFFile := ChangeFileExt(PrnFile, '.pdf');
            ConvertEDFToAdobePDF(PrnFile, PDFFile, PDFPrnInfo);
            PrnFile := PDFFile;
//            PrnFile := PDFPrnInfo.feXMLFileDir;
          end;
        XLS_FILE : ConvertEDFToXLS(PrnFile, PrnInfo.feXMLFileDir, FALSE);
        HTML_FILE : ConvertEDFToHTML(PrnFile, PrnInfo.feXMLFileDir, FALSE);
      end;
    end
    else
    begin
      // Printing, not Previewing
      try
        FilePrinter1 := TFilePrinter.Create(Application.MainForm);
        try
          // copy in correct printer settings
          RpDev.SetPrnSetup(PrnInfo);

          case PrnInfo.fePrintMethod Of
            0 : begin // Printer
                  // Print directly to printer - do not pass GO, do not collect £200
                  FilePrinter1.FileName := PrnFile;
                  FilePrinter1.PrinterIndex := PrnInfo.DevIdx;

                  for I := 1 to PrnInfo.NoCopies do
                    FilePrinter1.Execute;
                end;
            1 : begin // Fax
                  case PrnInfo.feFaxMethod of
                    // via Enterprise
                    0 : SendEntFax (PrnInfo, FilePrinter1, PrnFile, True);
                    // via MAPI
                    1 : SendMAPIFax (PrnInfo, PrnFile);
                    // Third-Party Fax Software
                    2 : SendEntFax (PrnInfo, FilePrinter1, PrnFile, False);
                    else
                      MessageDlg('Unknown Fax Method ('+IntToStr(PrnInfo.feFaxMethod)+') - Fax not sent',mtError,[mbOk],0);
                  end; // case PrnInfo.feFaxMethod of...
                end;
            2 : begin // Email                          // FName
                  SendEmailFile2(PrnInfo, FilePrinter1, PrnFile, True);
                end;
            3 : begin // XML not Supported
                end;
            4 : begin // DBF
                  // dialog box has similar options as HTML and Excel tabs.
                  // See ReportToDBF() in ReportGen.Pas
                end;
            5 : begin // Excel
                  ConvertEDFToXLS(PrnFile, PrnInfo.feXMLFileDir, PrnInfo.feMiscOptions[Integer(XLS_AUTO_OPEN)]);
                end;
            6 : begin // CSV
                  // dialog box has similar options as HTML and Excel tabs.
                  // See ReportToCSV() in ReportGen.Pas
                end;
            7 : begin // HTML
                  ConvertEDFToHTML(PrnFile, PrnInfo.feXMLFileDir, PrnInfo.feMiscOptions[Integer(HTML_AUTO_OPEN)]);
                end;
          else
            MessageDlg ('Unknown output type (' + IntToStr(PrnInfo.fePrintMethod) + ').', mtError, [mbOk], 0);
          end;
        finally
          FilePrinter1.Free;
        end;
      except
        on Ex:Exception do
          MessageDlg ('The following error occured attempting to print:' + #13#13 +
                      '''' + Ex.Message + '''.', mtError, [mbOk], 0);
      end;

    end; // if ExternalReport then...else...
  end
  else
  begin
    if (not ExternalReport) then
      SendMessage(Application.MainForm.Handle, WM_PreviewOpen, 0, 0);

    // Print to preview window
{
    if (assigned(WndParent)) and (not assigned(CopyApplication)) then
    begin
      CopyApplication := Application;
      Application := WndParent;
    end;
}
    try
//      Form_PrintPreview := TForm_PrintPreview.Create(Application.MainForm);
      Form_PrintPreview := TForm_PrintPreview.Create(Application);

      try
        Form_PrintPreview.SetPrintInfo(PrnInfo);

        Form_PrintPreview.FilePreview1.FileName := PrnFile;
        Form_PrintPreview.FilePreview1.PrinterIndex := PrnInfo.DevIdx;
        Form_PrintPreview.FilePrinter1.FileName := PrnFile;
        Form_PrintPreview.FilePrinter1.PrinterIndex := PrnInfo.DevIdx;
        Form_PrintPreview.SetMode(1);

//        if (assigned(WndParent)) then
//        begin
          // Ok, this is kinda dodgy but it does differenciate WndParent from other calling apps like Sentimail.
          if (Pos('ENTER1.EXE', UpperCase(Application.ExeName)) = 0) then
            Form_PrintPreview.Show
          else
          begin
            Form_PrintPreview.Position  := Forms.poDefault;
            Form_PrintPreview.FormStyle := fsMDIChild;
          end;
//        end
//        else
//          Form_PrintPreview.Show;

      except
        on E:Exception do
          MessageDlg ('An Error occurred attempting to preview the report.'#13#13 +
                      QuotedStr(E.Message), mtError, [mbOk], 0);
      end;
    finally
//      if (assigned(WndParent)) then
//        Application := CopyApplication;
    end;
  end; { else }

  { Restore printer settings }
  RpDev.SetPrnSetup(TmpInfo);

end;

{---------------------------------------------------------------------------}

procedure SendEmailFile2 (      PrnInfo     : TSBSPrintSetupInfo;
                          const FilePrinter : TFilePrinter;
                          const FName       : ShortString;
                          const DelFile     : Boolean);
var
  IniF             : TIniFile;
  PDFName, IniName : ShortString;
  EmailO  : TEntEmail;
  Res     : SmallInt;
  SysDir  : PChar;
  OrigPDFFile, OrigFile, ZipFile, PDFFile : ShortString;
  RenderPDF : TRPRenderPDF;
  NDRStream : TMemoryStream;
  RenderHTML : TRPRenderHTML;
  RenderUtil : TRenderingUtils;
  eMsg : string;
  ExitTime   : TDateTime;
  TimeOut    : Boolean;

  function DelFileName(const s : string) : string;
  begin
    Result := Copy(s, 1, Pos(':', s) - 1);
  end;

  function DelErrMsg(const s : string) : string;
  begin
    Result := Copy(s, Pos(':', s) + 1, Length(s));
  end;


  procedure SplitRecipients (RecipStr  : AnsiString;
                             RecipAddr : TStringList);
  var
    ColPos           : Integer;
    RecName, RecAddr : ShortString;
  begin { SplitRecipients }
    { Clear out any existing crap }
    RecipAddr.Clear;

    RecipStr := Trim(RecipStr);
    if (RecipStr <> '') then
    begin
      while (RecipStr <> '') do
      begin
        { look for end of name }
        ColPos := Pos (';', RecipStr);
        if (ColPos > 0) then
        begin
          { Extract name from recipients string }
          RecName := Copy (RecipStr, 1, Pred(ColPos));
          Delete (RecipStr, 1, ColPos);

          { look for end of address }
          ColPos := Pos (';', RecipStr);
          if (ColPos > 0) then
          begin
            { Extract Address from recipients string }
            RecAddr := Copy (RecipStr, 1, Pred(ColPos));
            Delete (RecipStr, 1, ColPos);

            RecipAddr.Add (RecAddr);
          end { if }
          else
            { Address not found - end loop }
            Break;
        end { if }
        else
          { Name not found - end loop }
          Break;
      end; { while }
    end; { if }
  end; { SplitRecipients }

  procedure SplitAttachments (AttachStr  : AnsiString;
                              AttachList : TStringList);
  var
    ColPos           : Integer;
    AttPath, RecAddr : ShortString;
  begin { SplitAttachments }
    { Clear out any existing crap }
    AttachList.Clear;

    AttachStr := Trim(AttachStr);
    while (AttachStr <> '') do
    begin
      { look for end of attachment }
      ColPos := Pos (';', AttachStr);
      if (ColPos > 0) then
      begin
        { Extract name from recipients string }
        AttPath := Copy (AttachStr, 1, Pred(ColPos));
        if FileExists (AttPath) then
          AttachList.Add (AttPath);

        { Remove Crud }
        Delete (AttachStr, 1, ColPos);
        AttachStr := Trim(AttachStr);
      end { if (ColPos > 0) }
      else
      begin
        if FileExists (AttachStr) then
          AttachList.Add (AttachStr);
        Break;
      end; { else }
    end; { while }
  end; { SplitAttachments }

  { Adds all files in the specified directory as attachment }
  procedure AddAttachments(      AttachList : TStringList;
                           const DirPath : ShortString);
  var
    NetFInfo : TSearchRec;
    SrchRes  : Integer;
  begin { AddAttachments }
    { Check Directory exists }
    if DirectoryExists (DirPath) then
    begin
      { check 1+ files exist on network with matching name (including wildcards) }
      SrchRes := FindFirst(DirPath + '\*.*', faAnyFile, NetFInfo);
      while (SrchRes = 0) do
      begin
        if ((NetFInfo.Attr and faDirectory) <> faDirectory) then
        begin
          { not a subdirectory - Check to see if a local file exists }
          AttachList.Add (DirPath + NetFInfo.Name);
        end { if }
        else
        begin
          { Subdirectory }
          if (NetFInfo.Name <> '.') and (NetFInfo.Name <> '..') then
          begin
            { Valid Directory - need to call function recursivly to copy subdirectories }
            AddAttachments(AttachList, DirPath + NetFInfo.Name + '\');
          end; { if }
        end; { else }

        SrchRes := FindNext(NetFInfo);
      end; { while }
    end; { if }
  end; { AddAttachments }

  { Zips the specified file to a self-extracting ZIP file and deletes the original }
  function ZipMeBaby(const PDFname : ShortString; const ZipType : Byte) : ShortString;
  var
    ZipO : TEntZip;
    Res  : LongInt;
  begin { ZipMeBaby }
    Result := PDFName;
    DoLog('SendEmailFile2 Start ZipMe: Result = ' + QuotedStr(Result));

    ZipO := TEntZip.Create;
    try
      with ZipO do
      begin
        DOSPaths := True;
        StripPath := True;
        Files.Add (PDFName);
        if (ZipType = 2) then
          ZipName := ChangeFileExt(PDFName, '.EDZ')
        else
          ZipName := ChangeFileExt(PDFName, '.ZIP');

        Res := Save;

        if (Res = 0) then
        begin
          Result := ZipName;
          ZIPFile := Result;
        end { if }
        else
          { Error }
          MessageDlg ('The following error occurred during compression:' + #13#13 +
                      '''' + ZipErr(Res) + '''.', mtError, [mbOk], 0);
      end; { with ZipO }
    finally
      ZipO.Destroy;
    end;
    DoLog('SendEmailFile2 end ZipMe: Result = ' + QuotedStr(Result));
  end; { ZipMeBaby }

  { Copies the !REP0.EDF style file locally and changes the name to something friendlier }
  procedure RenameOutFile (var PDFName : ShortString; const NewName : ShortString);
  var
    TmpPath, FileFr,
    DestExt, DestPath : AnsiString;
    Res1              : LongInt;
    I                 : SmallInt;
  begin { RenameOutFile }
    DoLog('SendEmailFile2 Start RenameOutFile: PDFName = ' + QuotedStr(PDFName));
    if FileExists (PDFName) then
    begin
      // Get path of windows temporary directory
      TmpPath := StringOfChar (' ', 255);
      Res1 := GetTempPath(Length(TmpPath), PChar(TmpPath));
      SetLength (TmpPath, Res1);
      TmpPath := IncludeTrailingBackslash(TmpPath);

      // Check to see if 'friendly name' available in temp directroy
      DestExt := ExtractFileExt (PDFName);
      DestPath := TmpPath + NewName + DestExt;
      if FileExists(DestPath) then
      begin
        // Generate unique 'friendly name' in destination directory
        for I := 1 to 99 do
        begin
          DestPath := TmpPath + NewName + IntToStr(I) + DestExt;

          if (not FileExists(DestPath)) then
            // AOK - file doesn't exist
            Break;
        end;
      end; // if FileExists(DestPath) 

      // Check a unique name was found
      if not FileExists(DestPath) then
      begin
        // Copy file across
        FileFr := PDFName;
        if CopyFile (PCHAR(FileFr), PCHAR(DestPath), True) then
          // Copy succeeded - switch attachment to new file
          PDFName := DestPath;
      end; { if not FileExists(DestPath) }
    end; { if FileExists (PDFName) }
    DoLog('SendEmailFile2 end RenameOutFile: PDFName = ' + QuotedStr(PDFName));
  end; { RenameOutFile }

  procedure MakePDFFileNameInTempDir (var PDFName : ShortString);
  var
    TmpPath, FileFr,
    DestExt, DestPath : AnsiString;
    Res1              : LongInt;
    I                 : SmallInt;
  begin 
    // Get path of windows temporary directory
    TmpPath := StringOfChar (' ', 255);
    Res1 := GetTempPath(Length(TmpPath), PChar(TmpPath));
    SetLength (TmpPath, Res1);
    TmpPath := IncludeTrailingBackslash(TmpPath);

    PDFName := TmpPath + ExtractFileName(PDFName);
  end;

  // Checks for and sets the Adove PDF Writer registry entries
  procedure Check4RegEntries;
  begin
    with TRegistry.Create do
      try
        Access := KEY_READ or KEY_WRITE;

        RootKey := HKEY_CURRENT_USER;

        if OpenKey('Software\Adobe\Acrobat PDFWriter', False) then
        begin
          WriteString('szAuthor', 'Exchequer');
          WriteString('szTitle', 'Exchequer Email');
          WriteString('PDFFileName', PDFName);
          WriteString('FileNameSet', '1');
          WriteString('bDocInfo', '0');
          {$IFDEF SENT}
          WriteString('bExecViewer', '0');
          {$ENDIF}
        end;

        CloseKey;
      finally
        Free;
      end;
  end; 

  // Returns True if for Adobe Acrobat 6.0 is detected
  function GotAdobeCrapobat6 : Boolean;
  begin // GotAdobeCrapobat6
    with TRegistry.Create do
      try
        Access  := KEY_READ;
        RootKey := HKEY_CURRENT_USER;

        //PR: 15/02/2011 Added checks for Adobe 9 & 10 - copied from FormDes2\PrntForm.pas
        Result := KeyExists ('Software\Adobe\Adobe Acrobat\6.0') Or
                  KeyExists ('Software\Adobe\Adobe Acrobat\9.0') Or
                  KeyExists ('Software\Adobe\Adobe Acrobat\10.0');
      finally
        Free;
      end;
  end; // GotAdobeCrapobat6

  //------------------------------

  // Enumerate the printers to get the Port which contains the output filename
  function GetAdobeCrapobat6PDFDir (PrnName : ShortString) : ShortString;
  var
    PrinterInfoArray  : Pointer;
    PrinterInfo5      : PPrinterInfo5;
    Needed            : DWORD;
    Returned          : DWORD;
    I                 : SmallInt;
  begin // GetAdobeCrapobat6PDFDir
    Result := '';
    PrnName := UpperCase(Trim(PrnName));

    // Find out how much memory required for the array of printer structures
    EnumPrinters(PRINTER_ENUM_LOCAL, nil, 5, nil, 0, Needed, Returned);

    // Allocate the memory for the array of printer structures
    GetMem(PrinterInfoArray,Needed);
    try
      // Get the array of printer structures
      if EnumPrinters(PRINTER_ENUM_LOCAL, nil, 5, PrinterInfoArray, Needed, Needed, Returned) then
      begin
        // Returned indicates the number of records returns by EnumPrinters
        if (Returned > 0) then
          for I := 0 to (Returned - 1) do
          begin
            // Calculate the position of the current printer info element within the memory block
            PrinterInfo5 := Pointer(LongInt(PrinterInfoArray) + (I * SizeOf(TPrinterInfo5)));

            if (Pos(UpperCase(Trim(PrinterInfo5^.pPrinterName)), PrnName) = 1) then
            begin
              // Got matching name - extract path from Port and finish loop
              Result := ExtractFilePath(PrinterInfo5^.pPortName);
              Break;
            end; // if (PrnName = UpperCase(Trim(PrinterInfo5^.pPrinterName))
          end; // for I
      end; // if EnumPrinters(...
    finally
      FreeMem(PrinterInfoArray,Needed);
    end;
  end; // GetAdobeCrapobat6PDFDir

  //------------------------------

  // Returns a unique path+filename within the specified dir
  function UniqueFilePath (const FileDir : ShortString) : ShortString;
  var
    FVar : SmallInt;
  begin 
    FVar := 0;

    repeat
      Result := FileDir + '!PDF' + IntToStr(FVar) + '.PDF';
      Inc (FVar);
    until (not FileExists (Result)) or (FVar > 9999);

    if (FVar > 9999) then
      raise Exception.Create('Cannot Find Unique Filename');
  end; 

  //------------------------------

  function WaitForAdobe : Boolean;
  begin
    Result := False;
    ExitTime := IncSecond(Now, 30 + (FilePrinter.Pages div 2));
    TimeOut := False;
    repeat
      // Wait for 1/2 second to allow Distiller time to do its thang
      Delay(500, True);

      // Exit the loop if we have passed the timeout
      Timeout := (Now > ExitTime);

    until FileExists(PDFName) or TimeOut;

    if FileExists(PDFName) then
    begin
      // NOTE: Occaisonally get errors from ecSendEmail saying it can't open the file, the theory
      // is that Distiller is still writing the file at that point, so loop around until we
      // can get exclusive access to the file or we timeout (5 secs + 1/5th sec per page
      ExitTime := IncSecond(Now, 5 + (FilePrinter.Pages div 5));
      TimeOut := False;
      repeat
        try
          with TFileStream.Create(PDFName, fmOpenRead or fmShareExclusive) do
          begin
            try
              // Opened successfully - exit loop and send email
              Result := True;  // Naughty! using Timeout to store success status!
            finally
              Free;
            end;
          end; // with TFileStream.Create(..
        except
          on E:Exception do
            // Wait for 1/2 second to allow Distiller time to do its thang
            Delay(500, True);
        end;
      until Result or (Now > ExitTime);
    end; // if FileExists(PDFName)
  end;

begin // SendEmailFile2 
  DoLog('Start SendEmailFile2 - FName = ' + QuotedStr(FName));
  OrigFile := FName;
  ZipFile  := '';
  PDFFile  := '';
  OrigPDFFile := '';

  { Get path of Win\SYS directory }
  SysDir := StrAlloc(255);
  GetSystemDirectory(SysDir, 255);
  IniName := SysDir;
  if (Length(IniName) > 0) then
    if (IniName[Length(IniName)] <> '\') then
      IniName := IniName + '\';

  case PrnInfo.feEmailAtType Of
    // ADOBE Acrobat
    1 : if (not GotAdobeCrapobat6) then
        begin
          { Adobe Acrobat - print intermediate file to PDF Writer }
          if ISWINNT or ISWINNT4 or ISWINNT5 then
          begin
            { Windows NT - Any Version }
            if FileExists(IniName + 'SPOOL\DRIVERS\W32X86\2\__PDF.INI') then
              IniName := IniName + 'SPOOL\DRIVERS\W32X86\2\__PDF.INI'
            else
              if FileExists(IniName + 'SPOOL\DRIVERS\W32X86\__PDF.INI') then
                IniName := IniName + 'SPOOL\DRIVERS\W32X86\__PDF.INI'
              else
                IniName := IniName + '__PDF.INI';
          end { if }
          else
          begin
            { Windows 9x }
            IniName := IniName + 'PDFWRITR.INI';
          end; { else }

          // HM 02/05/01: Moved from within the try..finally below
          // HM 26/06/00: Modified as not creating file in SWAP directory
          //PDFName := ExtractFilePath(Application.ExeName) + ChangeFileExt(ExtractFileName(FName), '.PDF');
          PDFName := ChangeFileExt(FName, '.PDF');

          if (IniName <> '') and FileExists(IniName) then
          begin
            { Setup the PDF Writer .INI file }
            IniF := TIniFile.Create(IniName);
            try
              IniF.WriteString ('Acrobat PDFWriter', 'PDFFileName', PDFName);
              IniF.WriteInteger ('Acrobat PDFWriter', 'bDocInfo', 0);
              IniF.WriteInteger ('Acrobat PDFWriter', 'FileNameSet', 1);
              IniF.WriteString ('Acrobat PDFWriter', 'szTitle', 'Exchequer Email');
              IniF.WriteString ('Acrobat PDFWriter', 'szAuthor', 'Exchequer');
            finally
              IniF.Destroy;
            end;
          end; { if (IniName <> '') and FileExists(IniName) }

          Check4RegEntries;

          // Print the intermediate file to the PDF Writer printer driver
          FilePrinter.FileName := FName;
          FilePrinter.PrinterIndex := PrnInfo.DevIdx;
          {$IFDEF SENT}
          LogIt(spReportConveyor, 'FilePrinter.execute', True);
          {$ENDIF}
          FilePrinter.Execute;

          {$IFDEF SENT}
          if not WaitForAdobe then
            raise Exception.Create('Timed out waiting for Adobe PDF File'#10#10 +
                                   QuotedStr(PDFName));
          LogIt(spReportConveyor, 'After FilePrinter.execute', True);
          {$ENDIF}

          PDFFile := PDFName;

        end // if (not GotAdobeCrapobat6)
        else
        begin
          // Adobe ACrobat 6.0
          // Determine the output directory for the Job
          PDFName := GetAdobeCrapobat6PDFDir(RpDev.Printers[PrnInfo.DevIdx]);

          // Determine a unique filename within that dir for the job
          PDFName := UniqueFilePath (PDFName);

          // Print the intermediate file to the Adobe PDF printer driver - should
          // create the file in the Port directory (see GetAdobeCrapobat6PDFDir)
          // with the unique name put into the PrintTitle property
          FilePrinter.FileName := FName;
          FilePrinter.PrinterIndex := PrnInfo.DevIdx;
          FilePrinter.PrintTitle := ChangeFileExt(ExtractFileName(PDFName), '');
          FilePrinter.Execute;

          // Now wait for Adobe Distiller to get its arse in gear and create the file -
          // this could take a while for big reports so retry automatically for 30
          // seconds + 1/2 sec per page
          {$IFDEF SENT}
          ExitTime := IncSecond(Now, 300 + (FilePrinter.Pages div 2));
          {$ELSE}
          //PR: 15/02/2011 Change to avoid showing message if running from Sentimail
          if PrnInfo.feMiscOptions[Integer(GEN_NO_MESSAGES)] then
            ExitTime := IncSecond(Now, 300 + (FilePrinter.Pages div 2))
          else
            ExitTime := IncSecond(Now, 30 + (FilePrinter.Pages div 2));
          {$ENDIF}
          TimeOut := False;
          repeat
            // Wait for 1/2 second to allow Distiller time to do its thang
            Delay(500, True);

            // Exit the loop if we have passed the timeout
            Timeout := (Now > ExitTime);
            if TimeOut and not PrnInfo.feMiscOptions[Integer(GEN_NO_MESSAGES)] then
            begin
            {$IFNDEF SENT}
              if (MessageDlg('The Adobe PDF File has not yet been created, this could be caused by the print job ' +
                             'being very big, or because the system is incorrectly configured.' + #13#13 +
                             'do you want to wait for another 30 seconds?', mtConfirmation, [mbYes,mbNo], 0) = mrYes) then
              begin
                TimeOut := False;
                ExitTime := IncSecond(Now, 30); // Retry automatically for another 30 seconds
              end; // if (MessageDlg(...) = mrYes)
            {$ELSE}
              raise Exception.Create('Adobe PDF file ' + QuotedStr(PDFName) + ' was not created.');
            {$ENDIF}
            end; // if TimeOut
          until FileExists(PDFName) or TimeOut;

          if FileExists(PDFName) then
          begin
            // NOTE: Occaisonally get errors from ecSendEmail saying it can't open the file, the theory
            // is that Distiller is still writing the file at that point, so loop around until we
            // can get exclusive access to the file or we timeout (5 secs + 1/5th sec per page
            ExitTime := IncSecond(Now, 5 + (FilePrinter.Pages div 5));
            TimeOut := False;
            repeat
              try
                with TFileStream.Create(PDFName, fmOpenRead or fmShareExclusive) do
                begin
                  try
                    // Opened successfully - exit loop and send email
                    TimeOut := True;  // Naughty! using Timeout to store success status!
                  finally
                    Free;
                  end;
                end; // with TFileStream.Create(..
              except
                on E:Exception do
                  // Wait for 1/2 second to allow Distiller time to do its thang
                  Delay(500, True);
              end;
            until TimeOut or (Now > ExitTime);
          end; // if FileExists(PDFName)

          PDFFile := PDFName;
        end; // else

    // RAVE PDF
    2 : begin
          PDFName := ChangeFileExt(FName, '.PDF');

          RenderPDF := TRPRenderPDF.Create(Application.MainForm);
          NDRStream := TMemoryStream.Create;
          if WantPDFCompression then RenderUtil := TRenderingUtils.Create;
          try
            if WantPDFCompression then
            begin
              RenderPDF.UseCompression := True;
              RenderPDF.OnCompress := RenderUtil.CompressPDF;
            end; { if WantPDFCompression }
            RenderPDF.InitFileStream (PDFName);

            NDRStream.LoadFromFile (FName);
            with TRPConverter.Create (NDRStream, RenderPDF) do
              try
                Generate;
              finally
                Free;
              end;
          finally
            RenderPDF.Free;
            NDRStream.Free;
            if WantPDFCompression then FreeAndNIL(RenderUtil);
          end;

          PDFFile := PDFName;
          DoLog('SendEmailFile2 Int PDF: PDFName = ' + QuotedStr(PDFName));
        end; // RAVE PDF

    // RAVE HTML
    3 : begin
          PDFName := ChangeFileExt(FName, '.HTM');

          RenderHTML := TRPRenderHTML.Create(Application.MainForm);
          NDRStream := TMemoryStream.Create;
          try
            RenderHTML.InitFileStream (PDFName);

            NDRStream.LoadFromFile (FName);
            with TRPConverter.Create (NDRStream, RenderHTML) do
              try
                Generate;
              finally
                Free;
              end;
          finally
            RenderHTML.Free;
            NDRStream.Free;
          end;

          PDFFile := PDFName;
        end; // RAVE HTML
  else
    begin
      // 0 = Internal EDF Format
      PDFname := FName;
      DoLog('SendEmailFile2 EDF: PDFName = ' + QuotedStr(PDFName));
    end;
  end; { case PrnInfo.feEmailAtType }

  // HM 26/06/00: Added checks for file existance
  if FileExists (PDFName) then
  begin
    { Optionally ZIP the .PDF file }
    if (PrnInfo.feEmailZIP <> 0) then
    begin
      { do it later! }
      PDFname := ZipMeBaby(PDFname, PrnInfo.feEmailZIP);
    end; { if }

    { Ensure original file gets deleted at end }
    OrigPDFFile := PDFName;

    { Rename outgoing file to friendlier filename than !REP0.xxx }
    RenameOutFile (PDFName, 'Report');
{$IFNDEF SENT}
  end; { if FileExists (PDFName) }
{$ELSE}
  end
  else
    raise Exception.Create('Unable to find attachment file: ' + QuotedStr(PDFName));
{$ENDIF}

  if FileExists (PDFName) then
  begin
    { Send .PDF as an email attachment }
    EmailO := TEntEmail.Create;
    try
      try
        with EmailO do
        begin
          { Setup email connection info }
          UseMAPI := PrnInfo.feEmailMAPI;
          SMTPServer := SyssEDI2^.EDI2Value.EmSMTP;

          // HM 08/06/00: Fixed as sender name and address around the wrong way
          { Set From details }
          SenderName := PrnInfo.feEmailFrom;
          Sender := PrnInfo.feEmailFromAd;

          { Set to Details }
          SplitRecipients (PrnInfo.feEmailTo, Recipients);
          SplitRecipients (PrnInfo.feEmailCC, CC);
          SplitRecipients (PrnInfo.feEmailBCC, BCC);

          Priority := PrnInfo.feEmailPriority;

          Subject := PrnInfo.feEmailSubj;
          Message := PCHAR(PrnInfo.feEmailMsg);

          { Attach fax job }
          SplitAttachments (PrnInfo.feEmailAttach, Attachments);
          Attachments.Add (PDFname);
          {$IFDEF SENT}
          SuppressMessages := True;
          {$ENDIF}

          { Attach Adobe Acrobat Reader }
          if PrnInfo.feEmailReader then
          begin
            { Check directory exists }
            if DirectoryExists (ExtractFilePath(Application.ExeName) + 'READER\') then
            begin
              AddAttachments(Attachments, ExtractFilePath(Application.ExeName) + 'READER\');
            end; { if }
          end; { if }

          { Send Fax }
          Res := EmailO.Send;

          if (Res > 0) then
          begin
            { raise exception to report error }
            raise EEmailErr.Create(EmailErr(Res));
          end; { if }
        end; { with EmailO }
      except
{$IFNDEF SENT}
        on Ex:Exception do
          MessageDlg ('The following error occurred sending an email:' + #13#13 +
                      Ex.Message, mtError, [mbOk], 0);
{$ELSE}
        raise;
{$ENDIF}
      end;
    finally
      EmailO.Destroy;
    end;
  end { if }
  else
  begin
    { Attachment missing }
    eMsg := 'The email attachment is missing';
   {$IFNDEF SENT}
    eMsg := eMsg + '    , please check that the Paperless Module is correctly ' +
                'configured in System Setup. This problem is usually caused by the wrong printer being ' +
                'assigned as the Attachment Printer.';

    MessageDlg (eMsg, mtError, [mbOk], 0);
   {$ELSE}
    eMsg := eMsg + '-' + 'File required: ' + QuotedStr(PDFName);
    raise Exception.Create (eMsg);
   {$ENDIF}
  end; { else }
  try
  { Delete files }
    if DelFile then DeletePrintFile (OrigFile);
    if (ZIPFile <> '') then DeletePrintFile (ZIPFile);
    if (PDFFile <> '') then DeletePrintFile (PDFFile);
    if (OrigPDFFile <> '') then DeletePrintFile (OrigPDFFile);
    if (PDFName <> '') then DeletePrintFile (PDFName);
  except
    {$IFDEF SENT}
     on E : EDeleteFile do
     begin
       Logit(spReportConveyor, 'Error deleting file ' + E.Message, True);
     end;
    {$ENDIF}
  end;

  StrDispose(SysDir);
end; // SendEmailFile2 

procedure ConvertEDFToXLS (const EDFPath, XLSPath : ShortString; const AutoOpen : Boolean);
var
  _enRender             : THandle;
  _enrConvertEDFToExcel : function (const EDFPath : ShortString; const XLSPath : ShortString) : Longint; StdCall;
  FuncRes               : LongInt;
  XLSFile               : ANSIString;
begin // ConvertEDFToXLS
  // Check for enRender.Dll utility library
  if FileExists (ExtractFilePath(Application.ExeName) + 'ENRENDER.DLL') then
  begin
    // dynamically load DLL and use enrConvertEDFToExcel function to convert the EDF format file
    _enRender := LoadLibrary('ENRENDER.DLL');

    // Check return value for success
    if (_enRender > HInstance_Error) then
    begin
      // try to get a handle to the enrConvertEDFToExcel function
      _enrConvertEDFToExcel := GetProcAddress(_enRender, 'enrConvertEDFToExcel');

      // Check return value for success
      if Assigned(_enrConvertEDFToExcel) then
      begin
        // Call enrConvertEDFToExcel to convert the EDF File to an XLS worksheet
        FuncRes := _enrConvertEDFToExcel(EdfPath, XLSPath);

        if (FuncRes = 0) and FileExists(XLSPath) then
        begin
          // Check to see if user wants to automatically open the XLS file
          if AutoOpen then
          begin
            XLSFile := XLSPath;
            // Normally the parent window handle is Application.MainForm.Handle, but for some reason
            // MainForm is nil at this point. However the use of 0 (zero) works just fine :-)
            ShellExecute(0,                                 // Parent Window
                         'open',                            // Operation
                         PChar(XLSFile),                    // FileName
                         '',                                // Params
                         PChar(ExtractFilePath(XLSPath)),   // Default Dir
                         SW_SHOWNORMAL);                    // Show
          end; // if AutoOpen
        end // if (FuncRes = 0)
        else
          MessageDlg ('Error ' + IntToStr(FuncRes) + ' printing to XLS - Please notify your Technical Support', mtError, [mbOk], 0);
      end // if Assigned(_enrConvertEDFToExcel)
      else
        // Error getting function handle
        MessageDlg ('Error ' + IntToStr(GetLastError) + ' accessing function handles in enRender.DLL - Please notify your Technical Support', mtError, [mbOk], 0);

      // Unload enRender.DLL
      FreeLibrary(_enRender);
    end // if (_enRender > HInstance_Error)
    else
      // Error loading enRender.DLL
      MessageDlg ('Error ' + IntToStr(GetLastError) + ' loading enRender.DLL - Please notify your Technical Support', mtError, [mbOk], 0);
  end // if FileExists (...
  else
    // enRender.Dll missing
    MessageDlg ('Error loading enRender.DLL - Please notify your Technical Support', mtError, [mbOk], 0);
end; // ConvertEDFToXLS


//-------------------------------------------------------------------------

procedure ConvertEDFToHTML (const EDFPath, HTMLPath : ShortString; const AutoOpen : Boolean);
var
  _enRender             : THandle;
  _enrConvertEDFToHTML  : function (const EDFPath : ShortString; const HTMLPath : ShortString) : Longint; StdCall;
  FuncRes               : LongInt;
  HTMLFile              : ANSIString;
begin // ConvertEDFToHTML
//  ShowMessage('COnvertEDFToHTML');
  // Check for enRender.Dll utility library
  if FileExists (ExtractFilePath(Application.ExeName) + 'ENRENDER.DLL') then
  begin
//    ShowMessage('EDFPath ('+trim(EDFPath)+')');

    // dynamically load DLL and use enrConvertEDFToExcel function to convert the EDF format file
    _enRender := LoadLibrary('ENRENDER.DLL');

    // Check return value for success
    if (_enRender > HInstance_Error) then
    begin
//      ShowMessage('Loaded alright!');

      // try to get a handle to the enrConvertEDFToHTML function
      _enrConvertEDFToHTML := GetProcAddress(_enRender, 'enrConvertEDFToHTML');

      // Check return value for success
      if Assigned(_enrConvertEDFToHTML) then
      begin
        // Call enrConvertEDFToHTML to convert the EDF File to HTML/CSS files
        FuncRes := _enrConvertEDFToHTML(EdfPath, HTMLPath);

//        ShowMessage('FuncRec ('+IntToStr(FuncRes)+')');

        if (FuncRes = 0) and FileExists(HTMLPath) then
        begin
//          ShowMessage('(FuncRes = 0) and FileExists(HTMLPath)');
          // Check to see if user wants to automatically open the HTML file
          if AutoOpen then
          begin
            HTMLFile := HTMLPath;
            // Normally the parent window handle is Application.MainForm.Handle, but for some reason
            // MainForm is nil at this point. However the use of 0 (zero) works just fine :-)
            ShellExecute(0,                                 // Parent Window
                         'open',                            // Operation
                         PChar(HTMLFile),                   // FileName
                         '',                                // Params
                         PChar(ExtractFilePath(HTMLFile)),  // Default Dir
                         SW_SHOWNORMAL);                    // Show
          end; // if AutoOpen
        end // if (FuncRes = 0)
        else
          MessageDlg ('Error ' + IntToStr(FuncRes) + ' printing to HTML - Please notify your Technical Support', mtError, [mbOk], 0);
      end // if Assigned(_enrConvertEDFToExcel)
      else
        // Error getting function handle
        MessageDlg ('Error ' + IntToStr(GetLastError) + ' accessing function handles in enRender.DLL - Please notify your Technical Support', mtError, [mbOk], 0);

      // Unload enRender.DLL
      FreeLibrary(_enRender);
    end // if (_enRender > HInstance_Error)
    else
      // Error loading enRender.DLL
      MessageDlg ('Error ' + IntToStr(GetLastError) + ' loading enRender.DLL - Please notify your Technical Support', mtError, [mbOk], 0);
  end // if FileExists (...
  else
    // enRender.Dll missing
    MessageDlg ('Error loading enRender.DLL - Please notify your Technical Support', mtError, [mbOk], 0);
end; // ConvertEDFToHTML

{---------------------------------------------------------------------------}

procedure ConvertEDFToInternalPDF(const EDFPath, PDFPath : ShortString; const AutoOpen : Boolean);
var
  RenderPDF : TRPRenderPDF;
  NDRStream : TMemoryStream;
  RenderUtil : TRenderingUtils;
begin
  RenderPDF := TRPRenderPDF.Create(Application.MainForm);
  NDRStream := TMemoryStream.Create;

  if WantPDFCompression then
    RenderUtil := TRenderingUtils.Create;

  try
    if WantPDFCompression then
    begin
      RenderPDF.UseCompression := True;
      RenderPDF.OnCompress := RenderUtil.CompressPDF;
    end; //  if WantPDFCompression

    RenderPDF.InitFileStream(PDFPath);

    NDRStream.LoadFromFile(EDFPath);

    with TRPConverter.Create(NDRStream, RenderPDF) do
      try
        Generate;
      finally
        Free;
      end;
      
  finally
    RenderPDF.Free;
    NDRStream.Free;
    if WantPDFCompression then
      FreeAndNIL(RenderUtil);
  end;
end;

procedure ConvertEDFToAdobePDF(const EDFPath : ShortString; var PDFPath : String; const PrnInfo : TSBSPrintSetupInfo);
var
  IniName : ShortString;
  SysDir  : PChar;
  IniF    : TIniFile;
  FilePrinter : TFilePrinter;
  ExitTime   : TDateTime;
  TimeOut    : Boolean;
  PDFPrintPath : ShortString;

  // Returns True if for Adobe Acrobat 6.0 is detected
  function GotAdobeAcrobat6 : Boolean;
  begin
    with TRegistry.Create do
      try
        Access  := KEY_READ;
        RootKey := HKEY_CURRENT_USER;

        //PR: 15/02/2011 Added checks for Adobe 9 & 10 - copied from FormDes2\PrntForm.pas
        Result := KeyExists ('Software\Adobe\Adobe Acrobat\6.0') Or
                  KeyExists ('Software\Adobe\Adobe Acrobat\9.0') Or
                  KeyExists ('Software\Adobe\Adobe Acrobat\10.0');
      finally
        Free;
      end;
  end;

  // Enumerate the printers to get the Port which contains the output filename
  function GetAdobeAcrobat6PDFDir(PrnName : ShortString) : ShortString;
  var
    PrinterInfoArray  : Pointer;
    PrinterInfo5      : PPrinterInfo5;
    Needed            : DWORD;
    Returned          : DWORD;
    I                 : SmallInt;
  begin 
    Result := '';
    PrnName := UpperCase(Trim(PrnName));

    // Find out how much memory required for the array of printer structures
    EnumPrinters(PRINTER_ENUM_LOCAL, nil, 5, nil, 0, Needed, Returned);

    // Allocate the memory for the array of printer structures
    GetMem(PrinterInfoArray,Needed);
    try
      // Get the array of printer structures
      if EnumPrinters(PRINTER_ENUM_LOCAL, nil, 5, PrinterInfoArray, Needed, Needed, Returned) then
      begin
        // Returned indicates the number of records returns by EnumPrinters
        if (Returned > 0) then
          for I := 0 to (Returned - 1) do
          begin
            // Calculate the position of the current printer info element within the memory block
            PrinterInfo5 := Pointer(LongInt(PrinterInfoArray) + (I * SizeOf(TPrinterInfo5)));

            if (Pos(UpperCase(Trim(PrinterInfo5^.pPrinterName)), PrnName) = 1) then
            begin
              // Got matching name - extract path from Port and finish loop
              Result := ExtractFilePath(PrinterInfo5^.pPortName);
              Break;
            end; // if (PrnName = UpperCase(Trim(PrinterInfo5^.pPrinterName))
          end; // for I
      end; // if EnumPrinters(...
    finally
      FreeMem(PrinterInfoArray,Needed);
    end;
  end;
  
  // Checks for and sets the Adobe PDF Writer registry entries
  procedure Check4RegEntries;
  begin
    with TRegistry.Create do
      try
        Access := KEY_READ or KEY_WRITE;

        RootKey := HKEY_CURRENT_USER;

        if OpenKey('Software\Adobe\Acrobat PDFWriter', False) then
        begin
          WriteString('szAuthor', 'Exchequer');
          WriteString('szTitle', 'Exchequer Email');
          WriteString('PDFFileName', PDFPath);
          WriteString('FileNameSet', '1');
          WriteString('bDocInfo', '0');
        end;

        CloseKey;
      finally
        Free;
      end;
  end;

  // Returns a unique path+filename within the specified dir
  function UniqueFilePath(const FileDir : ShortString) : ShortString;
  var
    FVar : SmallInt;
  begin
    FVar := 0;

    repeat
      Result := FileDir + '!PDF' + IntToStr(FVar) + '.PDF';
      Inc (FVar);
    until (not FileExists (Result)) or (FVar > 9999);

    if (FVar > 9999) then
      raise Exception.Create('Cannot Find Unique Filename');
  end;

begin // ConvertEDFToAdobePDF
  SysDir := StrAlloc(255);
  GetSystemDirectory(SysDir, 255);
  IniName := SysDir;
  if (Length(IniName) > 0) then
    if (IniName[Length(IniName)] <> '\') then
      IniName := IniName + '\';

  if (not GotAdobeAcrobat6) then
  begin
    // Adobe Acrobat - print intermediate file to PDF Writer
    if ISWINNT or ISWINNT4 or ISWINNT5 then
    begin
      // Windows NT - Any Version
      if FileExists(IniName + 'SPOOL\DRIVERS\W32X86\2\__PDF.INI') then
        IniName := IniName + 'SPOOL\DRIVERS\W32X86\2\__PDF.INI'
      else
        if FileExists(IniName + 'SPOOL\DRIVERS\W32X86\__PDF.INI') then
          IniName := IniName + 'SPOOL\DRIVERS\W32X86\__PDF.INI'
        else
          IniName := IniName + '__PDF.INI';
    end
    else
    begin
      // Windows 9x
      IniName := IniName + 'PDFWRITR.INI';
    end; 

    if (IniName <> '') And FileExists(IniName) then
    begin
      // Setup the PDF Writer .INI file 
      IniF := TIniFile.Create(IniName);
      try
        IniF.WriteString('Acrobat PDFWriter', 'PDFFileName', PDFPath);
        IniF.WriteInteger('Acrobat PDFWriter', 'bDocInfo', 0);
        IniF.WriteInteger('Acrobat PDFWriter', 'FileNameSet', 1);
        IniF.WriteString('Acrobat PDFWriter', 'szTitle', 'Exchequer Email');
        IniF.WriteString('Acrobat PDFWriter', 'szAuthor', 'Exchequer');
      finally
        IniF.Destroy;
      end;
    end; { if (IniName <> '') And FileExists(IniName) }

    Check4RegEntries;

    // Print the intermediate file to the PDF Writer printer driver 
    FilePrinter := TFilePrinter.Create(Application.MainForm);
    FilePrinter.FileName := EDFPath;
    FilePrinter.PrinterIndex := PrnInfo.DevIdx;
    FilePrinter.Execute;
    FilePrinter.Free;

  end // if (not GotAdobeAcrobat6) then...
  else
  begin
    // Adobe Acrobat 6.0
    // Determine the output directory for the Job
    PDFPrintPath := GetAdobeAcrobat6PDFDir(RpDev.Printers[PrnInfo.DevIdx]);

    // Determine a unique filename within that dir for the job
    PDFPrintPath := UniqueFilePath(PDFPrintPath);

    // Print the intermediate file to the Adobe PDF printer driver - should
    // create the file in the Port directory 
    // with the unique name put into the PrintTitle property
    FilePrinter := TFilePrinter.Create(Application.MainForm);
    FilePrinter.FileName := EDFPath;
    FilePrinter.PrinterIndex := PrnInfo.DevIdx;
    FilePrinter.PrintTitle := ChangeFileExt(ExtractFileName(PDFPrintPath), '');
    FilePrinter.Execute;

    // Now wait for Adobe Distiller to get its arse in gear and create the file -
    // this could take a while for big reports so retry automatically for 30
    // seconds + 1/2 sec per page


    //PR: 15/02/2011 Change to avoid showing message if running from Sentimail
    if PrnInfo.feMiscOptions[Integer(GEN_NO_MESSAGES)] then
      ExitTime := IncSecond(Now, 300 + (FilePrinter.Pages div 2))
    else
      ExitTime := IncSecond(Now, 30 + (FilePrinter.Pages div 2));

    TimeOut := False;
    repeat
      // Wait for 1/2 second to allow Distiller time to do its thang
      Delay(500, True);

      // Exit the loop if we have passed the timeout
      Timeout := (Now > ExitTime);
      if TimeOut and not PrnInfo.feMiscOptions[Integer(GEN_NO_MESSAGES)] then  //PR: 15/02/2011
      begin
        if (MessageDlg('The Adobe PDF File has not yet been created, this could be caused by the print job ' +
                       'being very big, or because the system is incorrectly configured.' + #13#13 +
                       'do you want to wait for another 30 seconds?', mtConfirmation, [mbYes,mbNo], 0) = mrYes) then
        begin
          TimeOut := False;
          ExitTime := IncSecond(Now, 30); // Retry automatically for another 30 seconds
        end; // if (MessageDlg(...) = mrYes)
      end; // if TimeOut
//    until FileExists(EDFPath) or TimeOut;
    until FileExists(PDFPrintPath) or TimeOut;  //PR: 15/02/2011 Change to check pdf file rather than temp file

    if FileExists(PDFPrintPath) then
    begin
      // NOTE: Occaisonally get errors from ecSendEmail saying it can't open the file, the theory
      // is that Distiller is still writing the file at that point, so loop around until we
      // can get exclusive access to the file or we timeout (5 secs + 1/5th sec per page
      ExitTime := IncSecond(Now, 5 + (FilePrinter.Pages div 5));
      TimeOut := False;
      repeat
        try
          with TFileStream.Create(PDFPrintPath, fmOpenRead or fmShareExclusive) do
          begin
            try
              // Opened successfully - exit loop and send email
              TimeOut := True;  // Naughty! using Timeout to store success status!
            finally
              Free;
            end;
          end; // with TFileStream.Create() do...
        except
          on E:Exception do
            // Wait for 1/2 second to allow Distiller time to do its thang
            Delay(500, True);
        end;
      until TimeOut or (Now > ExitTime);
    end; // if FileExists(PDFPrintPath)

    PDFPath := PDFPrintPath;

    FilePrinter.Free;
  end;
end;

{---------------------------------------------------------------------------}

procedure SendEntFax (const PrnInfo     : TSBSPrintSetupInfo;
                      const FilePrinter : TFilePrinter;
                      const FName       : ShortString;
                      const EntFaxing   : Boolean);

  { Calculates the current time in seconds }
  function xoCurrentTime : Double;
  var
    wHour, wMin, wSec, wMSec  : Word;
    lHour, lMin, lSec, lMSec : LongInt;
  begin
    Result := 0;

    try
      { Get current time }
      DecodeTime(Now, wHour, wMin, wSec, wMSec);

      { Copy fields into longs to force compiler to work in LongInt mode  }
      { otherwise you can get Range Check Errors as it works in Word mode }
      lHour := wHour;
      lMin  := wMin;
      lSec  := wSec;
      lMSec := wMSec;

      { Calculate number of seconds since midbnight }
      Result := (lSec + (60 * (lMin + (lHour * 60)))) + (lMSec * 0.001);
    except
      on Ex: Exception do
        MessageDlg ('The following exception occurred in xoCurrentTime: ' +
                    #13#10#13#10 + '"' + Ex.Message + '"', mtError, [mbOk], 0);
    end;
  end;

  function JobComplete : Boolean;
  begin { JobComplete }
    // HM 28/02/02: Modified for Relative Path support
    //with TInifile.Create (IncludeTrailingBackslash(SyssEDI2^.EDI2Value.FaxDLLPath) + 'WIN2KFAX.INI') do
    with TInifile.Create (CalcEnterpriseFaxingDirectory (SyssEDI2^.EDI2Value.FaxDLLPath) + 'WIN2KFAX.INI') do
      try
        Result := not SectionExists (Uppercase(WinGetUserName + ':' + WinGetComputerName));
      finally
        Free;
      end;
  end; { JobComplete }

  procedure WaitForCompletion;
  var
    stTime, fiTime, fiTime2, cuTime : Double;
  begin { WaitForCompletion }
    try
      { Get start time - this is used to detect the time wrapping around at midnight }
      stTime := xoCurrentTime;

      { Calculate timeout }
      fiTime := stTime + 30;

      repeat
        fiTime2 := xoCurrentTime + 1;
        repeat
          { Let other apps do something between .INI file checks }
          Application.ProcessMessages;

          { Get time again }
          cuTime := xoCurrentTime;
        until (cuTime < stTime) or (cuTime > fiTime2);

        { Exit loop if time has wrapped around or wait period has expired }
      until (cuTime < stTime) or (cuTime > fiTime) or JobComplete;
    except
      on Ex: Exception do
        MessageDlg ('The following exception occurred in WaitForCompletion: ' +
                    #13#10#13#10 + '"' + Ex.Message + '"', mtError, [mbOk], 0);
    end;
  end; { WaitForCompletion }


begin { SendEntFax }
  try
    // HM 22/03/01: Updated for changes by Neil in GetWindowsVersion
    if EntFaxing and (GetWindowsVersion in [wv2000, wv2000TerminalServer, wvXP, wvXPTerminalServer]) then
    begin
      // HM 09/01/01: Write Document Name details to INI file if faxing via Enterprise
      //              under Windows 2000.
      // HM 28/02/02: Modified for Relative Path support
      //with TInifile.Create (IncludeTrailingBackslash(SyssEDI2^.EDI2Value.FaxDLLPath) + 'WIN2KFAX.INI') do
      with TInifile.Create (CalcEnterpriseFaxingDirectory (SyssEDI2^.EDI2Value.FaxDLLPath) + 'WIN2KFAX.INI') do
        try
          WriteString (Uppercase(WinGetUserName + ':' + WinGetComputerName),
                       'UniqueKey',
                       PrnInfo.feJobtitle);
          UpdateFile;
        finally
          Free;
        end;
    end; { if EntFaxing and (GetWindowsVersion = wv2000) }

    { Print the intermediate file to the Async Pro Fax driver }
    FilePrinter.FileName := FName;
    FilePrinter.PrinterIndex := PrnInfo.DevIdx;

    // HM 01/03/02: Added setting of Title as Faxed Enterprise Reports weren't having the title
    // set correctly so that the Fax Client couldn't find the details and always asked for them.
    FilePrinter.PrintTitle := PrnInfo.feJobtitle;

    FilePrinter.Execute;

    // HM 22/03/01: Updated for changes by Neil in GetWindowsVersion
    if EntFaxing and (GetWindowsVersion in [wv2000, wv2000TerminalServer, wvXP, wvXPTerminalServer]) then
      WaitForCompletion;
  except
    on Ex:Exception do
    {$IFNDEF SENT}
        MessageDlg ('The following error occurred sending a fax to ''' + Trim(PrnInfo.feFaxTo) +
                    ''' on ''' + Trim(PrnInfo.feFaxToNo) + ''':' + #13#13 +
                    Ex.Message, mtError, [mbOk], 0);
    {$ELSE}
      raise;
    {$ENDIF}
  end;
end; { SendEntFax }

{---------------------------------------------------------------------------}

procedure SendMAPIFax (const PrnInfo : TSBSPrintSetupInfo;
                       const FName   : ShortString);
var
  EmailO : TEntEmail;
  Res    : SmallInt;
begin { SendMAPIFax }
  EmailO := TEntEmail.Create;
  try
    try
      with EmailO do
      begin
        UseMAPI := True;

        { Set From details }
        Sender := PrnInfo.feFaxFrom;
        SenderName := PrnInfo.feFaxFromNo;

        { Set to Details }
        Recipients.Add ('[FAX:' + Trim(PrnInfo.feFaxToNo) + ']');

        { Attach fax job }
        Attachments.Add (Fname);

        { Send Fax }
        Res := EmailO.Send;

        if (Res > 0) then
        begin
          { raise exception to report error }
          raise EEmailErr.Create(EmailErr(Res));
        end; { if }
      end; { with EmailO }
    except
      on Ex:Exception do
    {$IFNDEF SENT}
        MessageDlg ('The following error occurred sending a fax to ''' + Trim(PrnInfo.feFaxTo) +
                    ''' on ''' + Trim(PrnInfo.feFaxToNo) + ''':' + #13#13 +
                    Ex.Message, mtError, [mbOk], 0);
    {$ELSE}
      raise
    {$ENDIF}
    end;
  finally
    EmailO.Destroy;
  end;
end; { SendMAPIFax }

//----------------------------------------------------------------------------

procedure TRenderingUtils.CompressPDF(InStream, OutStream: TStream; var CompressMethod: string);
begin
  with TCompressionStream.Create (clMax, OutStream) do
    try
      CopyFrom (InStream, InStream.Size);
    finally
      Free;
    end;
end;

//----------------------------------------------------------------------------


initialization

  NumPrevWins:=0;

  // HM 08/02/02: Added backdoor to disable Internal PDF Compression if required
  WantPDFCompression := not FileExists (ExtractFilePath(Application.ExeName) + 'SMALLPDF.NO');

  CopyApplication := nil;

finalization

  if (assigned(CopyApplication)) then
  begin
    Application := CopyApplication;
    CopyApplication := nil;
  end;


end.

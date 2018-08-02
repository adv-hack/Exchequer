unit RWPrintR;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Controls, Dialogs, FileCtrl, Forms, IniFiles, SysUtils, Windows,
     RpDevice, RpFiler, RPFPrint, TEditVal, Registry, RpMemo, RPRender,
     RPRender_PDF, RPRender_HTML;


Type
  EEmailErr = Class (Exception);

  TRenderingUtils = Class (TObject)
  Public
    procedure CompressPDF(InStream, OutStream: TStream; var CompressMethod: String);
  End; { TRenderingUtils }

Procedure PrintRWReport (Const RepName : ShortString);
Procedure AddRepToQueue (Const RepName : ShortString);

Procedure PrintFileTo (Const PrnInfo           : TSBSPrintSetupInfo;
                       Const PrnFile, WinTitle : ShortString);

Procedure SendEmailFile2 (      PrnInfo     : TSBSPrintSetupInfo;
                          Const FilePrinter : TFilePrinter;
                          Const FName       : ShortString;
                          Const DelFile     : Boolean);

(*Procedure SendEntFax (Const PrnInfo     : TSBSPrintSetupInfo;
                      Const FilePrinter : TFilePrinter;
                      Const FName       : ShortString); *)

Procedure SendEntFax (Const PrnInfo     : TSBSPrintSetupInfo;
                      Const FilePrinter : TFilePrinter;
                      Const FName       : ShortString;
                      Const EntFaxing   : Boolean);


Procedure SendMAPIFax (Const PrnInfo : TSBSPrintSetupInfo;
                       Const FName   : ShortString);


Var
  NumPrevWins : LongInt;

implementation

Uses GlobVar, VarConst, BtrvU2, BtSupU1, RpCommon, RwOpenF, RepObjNU,
     ReportO, PrntPrev, RpInput, RwFuncs, ExThrd2U, CommsInt, ApiUtil,
     ZLIB, FileUtil, {$IFDEF SENT} RepObjCU, DebugLog, ElVar, {$ENDIF}DbfInt, WinSpool,
     DateUtils;

Var
  WantPDFCompression : Boolean = True;

{ === Check Input lines exsist === }
Function Inp_LinesExist(RepName  :  Str10)  :  Boolean;

Var
  KeyS  :  Str255;

Begin

  KeyS:=FullRepKey(ReportGenCode,RepLineTyp,RepName);

  Inp_LinesExist:=CheckExsists(KeyS,RepGenF,RGK);

end;

procedure DoLog(const s : string);
begin
{$IFDEF SENT}
  LogIt(spReportConveyor, s);
{$ENDIF}
end;

{ Get CSV file name }
Function GetCDFRepName(Var LastPath : ShortString) : Boolean;
Var
  SaveDialog1 : TSaveDialog;
  CurrPath    : String;
Begin
  { Save current directory - as dialog screws it up }
  CurrPath := GetCurrentDir;

  SaveDialog1 := TSaveDialog.Create(Application.MainForm);
  Try
    With SaveDialog1 Do Begin
      DefaultExt := 'CSV';
      FileName := LastPath;
      Options := [ofOverwritePrompt, ofPathMustExist];
      Title := 'Save CSV File As';
    End; { With }

    Result := SaveDialog1.Execute;

    If Result Then Begin
      { filename & path selected }
      LastPath := SaveDialog1.FileName;
    End; { If }
  Finally
    SaveDialog1.Free;
  End;

  { restore current directory - as dialog can screw it up }
  SetCurrentDir (CurrPath);
End;

Procedure PreviewPrintFile (Const PrintFile : ShortString;
                            Const PrinterNo : SmallInt;
                            Const NoCopies  : SmallInt);
Var
  PrevCur           : TCursor;
  Form_PrintPreview : TForm_PrintPreview;
begin
  {CursorToHourglass (PrevCur);}

  { Preview }
  Form_PrintPreview := TForm_PrintPreview.Create(Application.MainForm);
  Try
    Form_PrintPreview.FilePreview1.FileName := PrintFile;
    Form_PrintPreview.FilePreview1.PrinterIndex := PrinterNo;
    Form_PrintPreview.FilePrinter1.FileName := PrintFile;
    Form_PrintPreview.FilePrinter1.PrinterIndex := PrinterNo;
    Form_PrintPreview.SetMode (1);

    Form_PrintPreview.Position  := Forms.poDefault;
    Form_PrintPreview.FormStyle := fsMDIChild;
    Form_PrintPreview.DoMenu;
    {Form_PrintPreview.StartPreview;}
  Except
    {On EStreamError Do
      MessageDlg ('Stream Error:' + CRLF + CRLF +
                  'An error has occured creating the print file for the form, ''' +
                  PrintFile + ''', form aborted.', mtError, [mbOk], 0);}
  End;

  {RestoreCursor (PrevCur);}
End;

Procedure PrintFile (Const PrintFile : ShortString;
                     Const PrinterNo : SmallInt;
                     Const NoCopies  : SmallInt);
Var
  FilePrinter1 : TFilePrinter;
  I            : SmallInt;
begin
  FilePrinter1 := TFilePrinter.Create(Application.MainForm);
  Try
    FilePrinter1.FileName := PrintFile;
    FilePrinter1.PrinterIndex := PrinterNo;

    For I := 1 To NoCopies Do
      FilePrinter1.Execute;
  Finally
    FilePrinter1.Free;

  End;
End;

{ Prints a Report Writer Report }
Procedure PrintRWReport (Const RepName : ShortString);
Var
  RepInputs : TRepInputs;
  FoundCode : String;
Begin { PrintRWReport }
  { Get report }
  If GetReport (RepName, FoundCode) Then Begin
    If (RepGenRecs^.ReportHed.DefFont.fSize > 0) Then Begin
{$IFDEF DBF}
      if (RepGenRecs^.ReportHed.RepDest = 3) and not Assigned(oDBF) then
      begin
        Try
          CreateDBFComObject;
        Except
          MessageDlg('A required component (Dbfwrite.dll) is not registered correctly on this workstation.'#10#10 +
                     'Please close down your Enterprise system and run WorkStation Setup'#10 +
                     'which can be found in the Wstation sub-folder of your Enterprise directory.' +
                     #10#10 + 'If you are unsure of how to run Workstation Setup, ' +
                     'please contact'#10'your Technical Support.',
                     mtError, [mbOK], 0);
          Exit;
        End;
      end;
{$ENDIF}

      { Check for input lines }
      If Inp_LinesExist(RepName) Then Begin
        { Need to allow user to set report input values }
        SetRepInputs (RepName);
        RepInputs := TRepInputs.Create(Application.MainForm);
        RepInputs.ShowLink;
      End { If }
      Else
        { No input values reqired - print it }
        AddRepToQueue (RepName);
    End { If }
    Else
      MessageDlg ('This report cannot be printed until it has been converted.', mtWarning, [mbOk], 0);
  End; { If }
End;  { PrintRWReport }


{ Initialises and Adds a report to the thread queue }
Procedure AddRepToQueue (Const RepName : ShortString);
Var
  EntTest   :  RepRunCtrlPtr;
  FoundCode : String;
  {$IFDEF SENT}
    xInfo : TExtraRepInfoRec;
  {$ENDIF}
Begin
  {$IFDEF THREDZ}
    If GetReport (RepName, FoundCode) Then Begin
      {GroupRepRec^ := RepGenRecs^;   { cannot set grouprec until processing starts }

      { Update all system records }
      Init_AllSys;

      If (Create_BackThread) then Begin
        New (EntTest,Create(Application.MainForm, RepGenRecs^ {$IFDEF SENT}, xInfo {$ENDIF}));

        try
          With EntTest^ do Begin
            ReportMode:=1;

            If (Start) and (Create_BackThread) then
            Begin
              With BackThread do
                AddTask(EntTest,RepCtrlRec^.RepDesc);
            end
            else
            Begin
              Set_BackThreadFlip(BOff);
              Dispose(EntTest,Destroy);
            end;
          end; {with..}

        except
          Dispose(EntTest,Destroy);

        end; {try..}
      end; {If process got ok..}
    End; { If got report }
  {$ELSE}
    { Get report }
    If GetReport (RepName, FoundCode) Then Begin
      Screen.Cursor := crHourGlass;

      {GroupRepRec^ := RepGenRecs^;   { cannot set grouprec until processing starts }

      New (EntTest, Create(Application.MainForm, RepGenRecs^));
      Try
        EntTest^.ReportMode:=1;

        If EntTest^.Start Then Begin
          EntTest^.Process;

          EntTest^.Finish;

          If (EntTest^.RepCtrlRec^.RepDest <> 2) Then Begin
            { Display File }
            If Not EntTest^.RDevRec.Preview Then
              PrintFile (EntTest^.RepFiler1.FileName, EntTest^.RDevRec.DevIdx, EntTest^.RDevRec.NoCopies)
            Else Begin
              Screen.Cursor := crDefault;
              PreviewPrintFile (EntTest^.RepFiler1.FileName, EntTest^.RDevRec.DevIdx, EntTest^.RDevRec.NoCopies)
            End; { Else }
          End; { If }
        End; { If }
      Finally
        Dispose (EntTest, Destroy);
        Screen.Cursor := crDefault;
      End;
    End; { If }
  {$ENDIF}
End;


Procedure PrintFileTo (Const PrnInfo           : TSBSPrintSetupInfo;
                       Const PrnFile, WinTitle : ShortString);
Var
  Form_PrintPreview : TForm_PrintPreview;
  TmpInfo           : TSBSPrintSetupInfo;
  FilePrinter1      : TFilePrinter;
  I                 : SmallInt;
  TempForm          : TForm;
begin
  { Save printer settings }
  TmpInfo := RpDev.SBSSetupInfo;

  If (Not PrnInfo.Preview) Then Begin
    { Printing, NOT Previewing }
    Try
      FilePrinter1 := TFilePrinter.Create(Application.MainForm);
      Try
        { copy in correct printer settings }
        RpDev.SetPrnSetup(PrnInfo);

        Case PrnInfo.fePrintMethod Of
          { Printer }
          0 : Begin
                { Print directly to printer - do not pass GO, do not collect £200 }
                FilePrinter1.FileName := PrnFile;
                FilePrinter1.PrinterIndex := PrnInfo.DevIdx;

                For I := 1 To PrnInfo.NoCopies Do
                  FilePrinter1.Execute;
              End;

          { Fax }
          1 : Begin
                Case PrnInfo.feFaxMethod Of
                  { via Enterprise }
                  0 : SendEntFax (PrnInfo, FilePrinter1, PrnFile, True);
                  { via MAPI }
                  1 : SendMAPIFax (PrnInfo, PrnFile);
                  { Third-Party Fax Software }
                  2 : SendEntFax (PrnInfo, FilePrinter1, PrnFile, False);
                Else
                  MessageDlg ('Unknown Fax Method (' + IntToStr(PrnInfo.feFaxMethod) + ') - Fax not sent',
                              mtError, [mbOk], 0);
                End; { Case }
              End;

          { Email }
          2 : Begin
                SendEmailFile2 (PrnInfo, FilePrinter1, PrnFile, True);
              End;
        Else
          MessageDlg ('Unknown output type (' + IntToStr(PrnInfo.fePrintMethod) + ').', mtError, [mbOk], 0);
        End; { Case }
      Finally
        FilePrinter1.Free;
      End;
    Except
      On Ex:Exception Do
        MessageDlg ('The following error occured attempting to print:' + #13#13 +
                    '''' + Ex.Message + '''.', mtError, [mbOk], 0);
    End;

//    DeletePrintFile (PrnFile);
  End { If }
  Else Begin
    { Print to preview window }
    If Assigned(Application.MainForm) And
       Assigned(Application.MainForm.ActiveMDIChild) And
       (Syss.AMMPreview[BOff]) Then
      TempForm := Application.MainForm.ActiveMDIChild
    Else
      TempForm := Nil;

    Form_PrintPreview := TForm_PrintPreview.Create(Application.MainForm);
    Try
      Form_PrintPreview.SetPrintInfo(PrnInfo);

      Form_PrintPreview.FilePreview1.FileName := PrnFile;
      Form_PrintPreview.FilePreview1.PrinterIndex := PrnInfo.DevIdx;
      Form_PrintPreview.FilePrinter1.FileName := PrnFile;
      Form_PrintPreview.FilePrinter1.PrinterIndex := PrnInfo.DevIdx;
      Form_PrintPreview.SetMode (1);

      {Form_PrintPreview.Position  := Forms.poDefault;
      Form_PrintPreview.FormStyle := fsMDIChild;}
      Form_PrintPreview.FormActivate(Application.MainForm);

      {Form_PrintPreview.DoMenu;}
    Except
      On E:Exception Do
        MessageDlg ('An Error occurred attempting to preview the report.'#13#13 +
                    QuotedStr(E.Message), mtError, [mbOk], 0);
    End;

    If Assigned (TempForm) And TempForm.CanFocus Then Begin
      TempForm.BringToFront;
      TempForm.SetFocus;
    End; { If }
  End; { Else }

  { Restore printer settings }
  RpDev.SetPrnSetup(TmpInfo);
End;

{---------------------------------------------------------------------------}

Procedure SendEmailFile2 (      PrnInfo     : TSBSPrintSetupInfo;
                          Const FilePrinter : TFilePrinter;
                          Const FName       : ShortString;
                          Const DelFile     : Boolean);
Var
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


  Procedure SplitRecipients (RecipStr  : AnsiString;
                             RecipAddr : TStringList);
  Var
    ColPos           : Integer;
    RecName, RecAddr : ShortString;
  Begin { SplitRecipients }
    { Clear out any existing crap }
    RecipAddr.Clear;

    RecipStr := Trim(RecipStr);
    If (RecipStr <> '') Then Begin
      While (RecipStr <> '') Do Begin
        { look for end of name }
        ColPos := Pos (';', RecipStr);
        If (ColPos > 0) Then Begin
          { Extract name from recipients string }
          RecName := Copy (RecipStr, 1, Pred(ColPos));
          Delete (RecipStr, 1, ColPos);

          { look for end of address }
          ColPos := Pos (';', RecipStr);
          If (ColPos > 0) Then Begin
            { Extract Address from recipients string }
            RecAddr := Copy (RecipStr, 1, Pred(ColPos));
            Delete (RecipStr, 1, ColPos);

            RecipAddr.Add (RecAddr);
          End { If }
          Else
            { Address not found - end loop }
            Break;
        End { If }
        Else
          { Name not found - end loop }
          Break;
      End; { While }
    End; { If }
  End; { SplitRecipients }

  Procedure SplitAttachments (AttachStr  : AnsiString;
                              AttachList : TStringList);
  Var
    ColPos           : Integer;
    AttPath, RecAddr : ShortString;
  Begin { SplitAttachments }
    { Clear out any existing crap }
    AttachList.Clear;

    AttachStr := Trim(AttachStr);
    While (AttachStr <> '') Do Begin
      { look for end of attachment }
      ColPos := Pos (';', AttachStr);
      If (ColPos > 0) Then Begin
        { Extract name from recipients string }
        AttPath := Copy (AttachStr, 1, Pred(ColPos));
        If FileExists (AttPath) Then
          AttachList.Add (AttPath);

        { Remove Crud }
        Delete (AttachStr, 1, ColPos);
        AttachStr := Trim(AttachStr);
      End { If (ColPos > 0) }
      Else Begin
        If FileExists (AttachStr) Then
          AttachList.Add (AttachStr);
        Break;
      End; { Else }
    End; { While }
  End; { SplitAttachments }

  { Adds all files in the specified directory as attachment }
  Procedure AddAttachments(      AttachList : TStringList;
                           Const DirPath : ShortString);
  Var
    NetFInfo : TSearchRec;
    SrchRes  : Integer;
  Begin { AddAttachments }
    { Check Directory exists }
    If DirectoryExists (DirPath) Then Begin
      { check 1+ files exist on network with matching name (including wildcards) }
      SrchRes := FindFirst(DirPath + '\*.*', faAnyFile, NetFInfo);
      While (SrchRes = 0) Do Begin
        If ((NetFInfo.Attr And faDirectory) <> faDirectory) Then Begin
          { Not a subdirectory - Check to see if a local file exists }
          AttachList.Add (DirPath + NetFInfo.Name);
        End { If }
        Else Begin
          { Subdirectory }
          If (NetFInfo.Name <> '.') And (NetFInfo.Name <> '..') Then Begin
            { Valid Directory - need to call function recursivly to copy subdirectories }
            AddAttachments(AttachList, DirPath + NetFInfo.Name + '\');
          End; { If }
        End; { Else }

        SrchRes := FindNext(NetFInfo);
      End; { While }
    End; { If }
  End; { AddAttachments }

  { Zips the specified file to a self-extracting ZIP file and deletes the original }
  Function ZipMeBaby(Const PDFname : ShortString; Const ZipType : Byte) : ShortString;
  Var
    ZipO : TEntZip;
    Res  : LongInt;
  Begin { ZipMeBaby }
    Result := PDFName;
    DoLog('SendEmailFile2 Start ZipMe: Result = ' + QuotedStr(Result));

    ZipO := TEntZip.Create;
    Try
      With ZipO Do Begin
        DOSPaths := True;
        StripPath := True;
        Files.Add (PDFName);
        If (ZipType = 2) Then
          ZipName := ChangeFileExt(PDFName, '.EDZ')
        Else
          ZipName := ChangeFileExt(PDFName, '.ZIP');

        Res := Save;

        If (Res = 0) Then Begin
          Result := ZipName;
          ZIPFile := Result;
        End { If }
        Else
          { Error }
          MessageDlg ('The following error occurred during compression:' + #13#13 +
                      '''' + ZipErr(Res) + '''.', mtError, [mbOk], 0);
      End; { With ZipO }
    Finally
      ZipO.Destroy;
    End;
    DoLog('SendEmailFile2 End ZipMe: Result = ' + QuotedStr(Result));
  End; { ZipMeBaby }

  { Copies the !REP0.EDF style file locally and changes the name to something friendlier }
  Procedure RenameOutFile (Var PDFName : ShortString; Const NewName : ShortString);
  Var
    TmpPath, FileFr,
    DestExt, DestPath : AnsiString;
    Res1              : LongInt;
    I                 : SmallInt;
  Begin { RenameOutFile }
    DoLog('SendEmailFile2 Start RenameOutFile: PDFName = ' + QuotedStr(PDFName));
    If FileExists (PDFName) Then Begin
      // Get path of windows temporary directory
      TmpPath := StringOfChar (' ', 255);
      Res1 := GetTempPath(Length(TmpPath), PChar(TmpPath));
      SetLength (TmpPath, Res1);
      TmpPath := IncludeTrailingBackslash(TmpPath);

      // Check to see if 'friendly name' available in temp directroy
      DestExt := ExtractFileExt (PDFName);
      DestPath := TmpPath + NewName + DestExt;
      If FileExists(DestPath) Then Begin
        // Generate unique 'friendly name' in destination directory
        For I := 1 To 99 Do Begin
          DestPath := TmpPath + NewName + IntToStr(I) + DestExt;

          If (Not FileExists(DestPath)) Then
            // AOK - file doesn't exist
            Break;
        End; { For I }
      End; { If FileExists(DestPath) }

      // Check a unique name was found
      If Not FileExists(DestPath) Then Begin
        // Copy file across
        FileFr := PDFName;
        If CopyFile (PCHAR(FileFr), PCHAR(DestPath), True) Then
          // Copy succeeded - switch attachment to new file
          PDFName := DestPath;
      End; { If Not FileExists(DestPath) }
    End; { If FileExists (PDFName) }
    DoLog('SendEmailFile2 End RenameOutFile: PDFName = ' + QuotedStr(PDFName));
  End; { RenameOutFile }

  Procedure MakePDFFileNameInTempDir (Var PDFName : ShortString);
  Var
    TmpPath, FileFr,
    DestExt, DestPath : AnsiString;
    Res1              : LongInt;
    I                 : SmallInt;
  Begin { RenameOutFile }
      // Get path of windows temporary directory
    TmpPath := StringOfChar (' ', 255);
    Res1 := GetTempPath(Length(TmpPath), PChar(TmpPath));
    SetLength (TmpPath, Res1);
    TmpPath := IncludeTrailingBackslash(TmpPath);

    PDFName := TmpPath + ExtractFileName(PDFName);
  end;

  // Checks for and sets the Adove PDF Writer registry entries
  Procedure Check4RegEntries;
  Begin { Check4RegEntries }
    With TRegistry.Create Do
      Try
        Access := KEY_READ or KEY_WRITE;

        RootKey := HKEY_CURRENT_USER;

        If OpenKey('Software\Adobe\Acrobat PDFWriter', False) Then Begin
          WriteString('szAuthor', 'Exchequer Enterprise');
          WriteString('szTitle', 'Exchequer Enterprise Email');
          WriteString('PDFFileName', PDFName);
          WriteString('FileNameSet', '1');
          WriteString('bDocInfo', '0');
          {$IFDEF SENT}
          WriteString('bExecViewer', '0');
          {$ENDIF}
        End; { If }

        CloseKey;
      Finally
        Free;
      End;
  End; { Check4RegEntries }

  // Returns True if for Adobe Acrobat 6.0 is detected
  Function GotAdobeCrapobat6 : Boolean;
  Begin // GotAdobeCrapobat6
    With TRegistry.Create Do
      Try
        Access  := KEY_READ;
        RootKey := HKEY_CURRENT_USER;

        Result := KeyExists ('Software\Adobe\Adobe Acrobat\6.0');
      Finally
        Free;
      End;

//ShowMessage ('GotAdobeCrapobat6: ' + IntToStr(Ord(Result)));
  End; // GotAdobeCrapobat6

  //------------------------------

  // Enumerate the printers to get the Port which contains the output filename
  Function GetAdobeCrapobat6PDFDir (PrnName : ShortString) : ShortString;
  Var
    PrinterInfoArray  : Pointer;
    PrinterInfo5      : PPrinterInfo5;
    Needed            : DWORD;
    Returned          : DWORD;
    I                 : SmallInt;
  Begin // GetAdobeCrapobat6PDFDir
    Result := '';
    PrnName := UpperCase(Trim(PrnName));

    // Find out how much memory required for the array of printer structures
    EnumPrinters(PRINTER_ENUM_LOCAL, NIL, 5, NIL, 0, Needed, Returned);

    // Allocate the memory for the array of printer structures
    GetMem(PrinterInfoArray,Needed);
    Try
      // Get the array of printer structures
      If EnumPrinters(PRINTER_ENUM_LOCAL, NIL, 5, PrinterInfoArray, Needed, Needed, Returned) Then
      Begin
        // Returned indicates the number of records returns by EnumPrinters
        If (Returned > 0) Then
          For I := 0 To (Returned - 1) Do
          Begin
            // Calculate the position of the current printer info element within the memory block
            PrinterInfo5 := Pointer(LongInt(PrinterInfoArray) + (I * SizeOf(TPrinterInfo5)));

//ShowMessage ('SearchName: ' + PrnName + #13 +
//             'PrinterName: ' + PrinterInfo5^.pPrinterName + #13 +
//             'PortName: ' + PrinterInfo5^.pPortName);

            If (Pos(UpperCase(Trim(PrinterInfo5^.pPrinterName)), PrnName) = 1) Then
            Begin
              // Got matching name - extract path from Port and finish loop
              Result := ExtractFilePath(PrinterInfo5^.pPortName);
              Break;
            End; // If (PrnName = UpperCase(Trim(PrinterInfo5^.pPrinterName))
          End; // For I
      End; // If EnumPrinters(...
    Finally
      FreeMem(PrinterInfoArray,Needed);
    End;
  End; // GetAdobeCrapobat6PDFDir

  //------------------------------

  // Returns a unique path+filename within the specified dir
  Function UniqueFilePath (Const FileDir : ShortString) : ShortString;
  Var
    FVar : SmallInt;
  Begin // UniqueFilePath
    FVar := 0;

    Repeat
      Result := FileDir + '!PDF' + IntToStr(FVar) + '.PDF';
      Inc (FVar);
    Until (Not FileExists (Result)) Or (FVar > 9999);

    If (FVar > 9999) Then
      Raise Exception.Create('Cannot Find Unique Filename');
  End; // UniqueFilePath

  //------------------------------

  function WaitForAdobe : Boolean;
  begin
    Result := False;
    ExitTime := IncSecond(Now, 30 + (FilePrinter.Pages Div 2));
    TimeOut := False;
    Repeat
      // Wait for 1/2 second to allow Distiller time to do its thang
      Delay(500, True);

      // Exit the loop if we have passed the timeout
      Timeout := (Now > ExitTime);

    Until FileExists(PDFName) Or TimeOut;

    If FileExists(PDFName) Then
    Begin
      // NOTE: Occaisonally get errors from ecSendEmail saying it can't open the file, the theory
      // is that Distiller is still writing the file at that point, so loop around until we
      // can get exclusive access to the file or we timeout (5 secs + 1/5th sec per page
      ExitTime := IncSecond(Now, 5 + (FilePrinter.Pages Div 5));
      TimeOut := False;
      Repeat
        Try
          With TFileStream.Create(PDFName, fmOpenRead Or fmShareExclusive) Do
          Begin
            Try
              // Opened successfully - exit loop and send email
              Result := True;  // Naughty! using Timeout to store success status!
            Finally
              Free;
            End;
          End; // With TFileStream.Create(..
        Except
          On E:Exception Do
            // Wait for 1/2 second to allow Distiller time to do its thang
            Delay(500, True);
        End;
      Until Result Or (Now > ExitTime);
    End; // If FileExists(PDFName)


  end;


Begin { SendEmailFile2 }
  DoLog('Start SendEmailFile2 - FName = ' + QuotedStr(FName));
  OrigFile := FName;
  ZipFile  := '';
  PDFFile  := '';
  OrigPDFFile := '';

  { Get path of Win\SYS directory }
  SysDir := StrAlloc(255);
  GetSystemDirectory(SysDir, 255);
  IniName := SysDir;
  If (Length(IniName) > 0) Then
    If (IniName[Length(IniName)] <> '\') Then
      IniName := IniName + '\';

  Case PrnInfo.feEmailAtType Of
    // ADOBE Acrobat
    1 : If (Not GotAdobeCrapobat6) Then
        Begin
          { Adobe Acrobat - print intermediate file to PDF Writer }
          If ISWINNT Or ISWINNT4 Or ISWINNT5 Then Begin
            { Windows NT - Any Version }
            If FileExists(IniName + 'SPOOL\DRIVERS\W32X86\2\__PDF.INI') Then
              IniName := IniName + 'SPOOL\DRIVERS\W32X86\2\__PDF.INI'
            Else
              If FileExists(IniName + 'SPOOL\DRIVERS\W32X86\__PDF.INI') Then
                IniName := IniName + 'SPOOL\DRIVERS\W32X86\__PDF.INI'
              Else
                IniName := IniName + '__PDF.INI';
          End { If }
          Else Begin
            { Windows 9x }
            IniName := IniName + 'PDFWRITR.INI';
          End; { Else }

          // HM 02/05/01: Moved from within the Try..Finally below
          // HM 26/06/00: Modified as not creating file in SWAP directory
          //PDFName := ExtractFilePath(Application.ExeName) + ChangeFileExt(ExtractFileName(FName), '.PDF');
          PDFName := ChangeFileExt(FName, '.PDF');
          {$IFDEF SENT}
//          MakePDFFileNameInTempDir(PDFName);
          {$ENDIF}

          If (IniName <> '') And FileExists(IniName) Then Begin
            { Setup the PDF Writer .INI file }
            IniF := TIniFile.Create(IniName);
            Try
              IniF.WriteString ('Acrobat PDFWriter', 'PDFFileName', PDFName);
              IniF.WriteInteger ('Acrobat PDFWriter', 'bDocInfo', 0);
              IniF.WriteInteger ('Acrobat PDFWriter', 'FileNameSet', 1);
              IniF.WriteString ('Acrobat PDFWriter', 'szTitle', 'Exchequer Enterprise Email');
              IniF.WriteString ('Acrobat PDFWriter', 'szAuthor', 'Exchequer Enterprise');
            Finally
              IniF.Destroy;
            End;
          End; { If (IniName <> '') And FileExists(IniName) }

          Check4RegEntries;

          { Print the intermediate file to the PDF Writer printer driver }


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

        End // If (Not GotAdobeCrapobat6)
        Else Begin
          // Adobe ACrobat 6.0
//ShowMessage ('Acrobat 6.0' + #13 +
//             'Current Printer: ' + RpDev.Printers[RpDev.DeviceIndex] + #13 +
//             'Print Job Title: ' + PrnInfo.feJobtitle + #13 +
//             'Internal Filename: ' + FName);

          // Determine the output directory for the Job
          PDFName := GetAdobeCrapobat6PDFDir(RpDev.Printers[PrnInfo.DevIdx]);
//          PDFName := GetAdobeCrapobat6PDFDir(RpDev.Printers[RpDev.DeviceIndex]);

          // Determine a unique filename within that dir for the job
          PDFName := UniqueFilePath (PDFName);

//ShowMessage ('Temp PDF Filename: ' + PDFName + #13 + ChangeFileExt(ExtractFileName(PDFName), ''));

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
          ExitTime := IncSecond(Now, 300 + (FilePrinter.Pages Div 2));
          {$ELSE}
          ExitTime := IncSecond(Now, 30 + (FilePrinter.Pages Div 2));
          {$ENDIF}
          TimeOut := False;
          Repeat
            // Wait for 1/2 second to allow Distiller time to do its thang
            Delay(500, True);

            // Exit the loop if we have passed the timeout
            Timeout := (Now > ExitTime);
            If TimeOut Then
            Begin
            {$IFNDEF SENT}
              If (MessageDlg('The Adobe PDF File has not yet been created, this could be caused by the print job ' +
                             'being very big, or because the system is incorrectly configured.' + #13#13 +
                             'Do you want to wait for another 30 seconds?', mtConfirmation, [mbYes,mbNo], 0) = mrYes) Then
              Begin
                TimeOut := False;
                ExitTime := IncSecond(Now, 30); // Retry automatically for another 30 seconds
              End; // If (MessageDlg(...) = mrYes)
            {$ELSE}
              raise Exception.Create('Adobe PDF file ' + QuotedStr(PDFName) + ' was not created.');
            {$ENDIF}
            End; // If TimeOut
          Until FileExists(PDFName) Or TimeOut;

          If FileExists(PDFName) Then
          Begin
            // NOTE: Occaisonally get errors from ecSendEmail saying it can't open the file, the theory
            // is that Distiller is still writing the file at that point, so loop around until we
            // can get exclusive access to the file or we timeout (5 secs + 1/5th sec per page
            ExitTime := IncSecond(Now, 5 + (FilePrinter.Pages Div 5));
            TimeOut := False;
            Repeat
              Try
                With TFileStream.Create(PDFName, fmOpenRead Or fmShareExclusive) Do
                Begin
                  Try
                    // Opened successfully - exit loop and send email
                    TimeOut := True;  // Naughty! using Timeout to store success status!
                  Finally
                    Free;
                  End;
                End; // With TFileStream.Create(..
              Except
                On E:Exception Do
                  // Wait for 1/2 second to allow Distiller time to do its thang
                  Delay(500, True);
              End;
            Until TimeOut Or (Now > ExitTime);
          End; // If FileExists(PDFName)

          PDFFile := PDFName;
        End; // Else

    // RAVE PDF
    2 : Begin
          PDFName := ChangeFileExt(FName, '.PDF');

          RenderPDF := TRPRenderPDF.Create(Application.MainForm);
          NDRStream := TMemoryStream.Create;
          If WantPDFCompression Then RenderUtil := TRenderingUtils.Create;
          Try
            If WantPDFCompression Then Begin
              RenderPDF.UseCompression := True;
              RenderPDF.OnCompress := RenderUtil.CompressPDF;
            End; { If WantPDFCompression }
            RenderPDF.InitFileStream (PDFName);

            NDRStream.LoadFromFile (FName);
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

          PDFFile := PDFName;
          DoLog('SendEmailFile2 Int PDF: PDFName = ' + QuotedStr(PDFName));
        End; // RAVE PDF

    // RAVE HTML
    3 : Begin
          PDFName := ChangeFileExt(FName, '.HTM');

          RenderHTML := TRPRenderHTML.Create(Application.MainForm);
          NDRStream := TMemoryStream.Create;
          Try
            RenderHTML.InitFileStream (PDFName);

            NDRStream.LoadFromFile (FName);
            With TRPConverter.Create (NDRStream, RenderHTML) Do
              Try
                Generate;
              Finally
                Free;
              End;
          Finally
            RenderHTML.Free;
            NDRStream.Free;
          End;

          PDFFile := PDFName;
        End; // RAVE HTML
  Else
    begin
      // 0 = Internal EDF Format
      PDFname := FName;
      DoLog('SendEmailFile2 EDF: PDFName = ' + QuotedStr(PDFName));
    end;
  End; { Case PrnInfo.feEmailAtType }

  // HM 26/06/00: Added checks for file existance
  If FileExists (PDFName) Then Begin
    { Optionally ZIP the .PDF file }
    If (PrnInfo.feEmailZIP <> 0) Then Begin
      { Do it later! }
      PDFname := ZipMeBaby(PDFname, PrnInfo.feEmailZIP);
    End; { If }

    { Ensure original file gets deleted at end }
    OrigPDFFile := PDFName;

    { Rename outgoing file to friendlier filename than !REP0.xxx }
    RenameOutFile (PDFName, 'Report');
{$IFNDEF SENT}
  End; { If FileExists (PDFName) }
{$ELSE}
  end
  else
    raise Exception.Create('Unable to find attachment file: ' + QuotedStr(PDFName));
{$ENDIF}

  If FileExists (PDFName) Then Begin
    { Send .PDF as an email attachment }
    EmailO := TEntEmail.Create;
    Try
      Try
        With EmailO Do Begin
          { Setup email connection info }
          UseMAPI := PrnInfo.feEmailMAPI;
          SMTPServer := SyssEDI2^.EDI2Value.EmSMTP;

          // HM 08/06/00: Fixed as sender name and address around the wrong way
          { Set From details }
          SenderName := PrnInfo.feEmailFrom;
          Sender := PrnInfo.feEmailFromAd;

          { Set To Details }
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
          If PrnInfo.feEmailReader Then Begin
            { Check directory exists }
            If DirectoryExists (ExtractFilePath(Application.ExeName) + 'READER\') Then Begin
              AddAttachments(Attachments, ExtractFilePath(Application.ExeName) + 'READER\');
            End; { If }
          End; { If }

          { Send Fax }
          Res := EmailO.Send;

          If (Res > 0) Then Begin
            { Raise exception to report error }
            Raise EEmailErr.Create(EmailErr(Res));
          End; { If }
        End; { With EmailO }
      Except
{$IFNDEF SENT}
        On Ex:Exception Do
          MessageDlg ('The following error occurred sending an email:' + #13#13 +
                      Ex.Message, mtError, [mbOk], 0);
{$ELSE}
        raise;
{$ENDIF}
      End;
    Finally
      EmailO.Destroy;
    End;
  End { If }
  Else Begin
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
  End; { Else }
  Try
  { Delete files }
    If DelFile Then DeletePrintFile (OrigFile);
    If (ZIPFile <> '') Then DeletePrintFile (ZIPFile);
    If (PDFFile <> '') Then DeletePrintFile (PDFFile);
    If (OrigPDFFile <> '') Then DeletePrintFile (OrigPDFFile);
    If (PDFName <> '') Then DeletePrintFile (PDFName);
  Except
    {$IFDEF SENT}
     on E : EDeleteFile do
     begin
       Logit(spReportConveyor, 'Error deleting file ' + E.Message, True);
     end;
    {$ENDIF}
  End;

  StrDispose(SysDir);
End; { SendEmailFile2 }

{---------------------------------------------------------------------------}

(*procedure SendEntFax (Const PrnInfo     : TSBSPrintSetupInfo;
                      Const FilePrinter : TFilePrinter;
                      Const FName       : ShortString);
Begin { SendEntFax }
  Try
    { Print the intermediate file to the Async Pro Fax driver }
    FilePrinter.FileName := FName;
    FilePrinter.PrinterIndex := PrnInfo.DevIdx;
    FilePrinter.PrintTitle := PrnInfo.feJobtitle;
    FilePrinter.Execute;
  Except
    On Ex:Exception Do
        MessageDlg ('The following error occurred sending a fax to ''' + Trim(PrnInfo.feFaxTo) +
                    ''' on ''' + Trim(PrnInfo.feFaxToNo) + ''':' + #13#13 +
                    Ex.Message, mtError, [mbOk], 0);
  End;
End; { SendEntFax }
*)
Procedure SendEntFax (Const PrnInfo     : TSBSPrintSetupInfo;
                      Const FilePrinter : TFilePrinter;
                      Const FName       : ShortString;
                      Const EntFaxing   : Boolean);

  { Calculates the current time in seconds }
  Function xoCurrentTime : Double;
  Var
    wHour, wMin, wSec, wMSec  : Word;
    lHour, lMin, lSec, lMSec : LongInt;
  begin
    Result := 0;

    Try
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
    Except
      On Ex: Exception Do
        MessageDlg ('The following exception occurred in xoCurrentTime: ' +
                    #13#10#13#10 + '"' + Ex.Message + '"', mtError, [mbOk], 0);
    End;
  End;

  Function JobComplete : Boolean;
  Begin { JobComplete }
    // HM 28/02/02: Modified for Relative Path support
    //With TInifile.Create (IncludeTrailingBackslash(SyssEDI2^.EDI2Value.FaxDLLPath) + 'WIN2KFAX.INI') Do
    With TInifile.Create (CalcEnterpriseFaxingDirectory (SyssEDI2^.EDI2Value.FaxDLLPath) + 'WIN2KFAX.INI') Do
      Try
        Result := NOT SectionExists (Uppercase(WinGetUserName + ':' + WinGetComputerName));
      Finally
        Free;
      End;
  End; { JobComplete }

  Procedure WaitForCompletion;
  Var
    stTime, fiTime, fiTime2, cuTime : Double;
  Begin { WaitForCompletion }
    Try
      { Get start time - this is used to detect the time wrapping around at midnight }
      stTime := xoCurrentTime;

      { Calculate timeout }
      fiTime := stTime + 30;

      Repeat
        fiTime2 := xoCurrentTime + 1;
        Repeat
          { Let other apps do something between .INI file checks }
          Application.ProcessMessages;

          { Get time again }
          cuTime := xoCurrentTime;
        Until (cuTime < stTime) Or (cuTime > fiTime2);

        { Exit loop if time has wrapped around or wait period has expired }
      Until (cuTime < stTime) Or (cuTime > fiTime) Or JobComplete;
    Except
      On Ex: Exception Do
        MessageDlg ('The following exception occurred in WaitForCompletion: ' +
                    #13#10#13#10 + '"' + Ex.Message + '"', mtError, [mbOk], 0);
    End;
  End; { WaitForCompletion }


Begin { SendEntFax }
  Try
    // HM 22/03/01: Updated for changes by Neil in GetWindowsVersion
    If EntFaxing And (GetWindowsVersion In [wv2000, wv2000TerminalServer, wvXP, wvXPTerminalServer]) Then Begin
      // HM 09/01/01: Write Document Name details to INI file if faxing via Enterprise
      //              under Windows 2000.
      // HM 28/02/02: Modified for Relative Path support
      //With TInifile.Create (IncludeTrailingBackslash(SyssEDI2^.EDI2Value.FaxDLLPath) + 'WIN2KFAX.INI') Do
      With TInifile.Create (CalcEnterpriseFaxingDirectory (SyssEDI2^.EDI2Value.FaxDLLPath) + 'WIN2KFAX.INI') Do
        Try
          WriteString (Uppercase(WinGetUserName + ':' + WinGetComputerName),
                       'UniqueKey',
                       PrnInfo.feJobtitle);

          {WriteString ('Debug',
                       FormatDateTime('HHNNSSZZZ', Now),
                       Uppercase(WinGetUserName + ':' + WinGetComputerName) + ':' + PrnInfo.feJobtitle);}

          UpdateFile;
        Finally
          Free;
        End;
    End; { If EntFaxing And (GetWindowsVersion = wv2000) }

    { Print the intermediate file to the Async Pro Fax driver }
    FilePrinter.FileName := FName;
    FilePrinter.PrinterIndex := PrnInfo.DevIdx;

    // HM 01/03/02: Added setting of Title as Faxed Enterprise Reports weren't having the title
    // set correctly so that the Fax Client couldn't find the details and always asked for them.
    FilePrinter.PrintTitle := PrnInfo.feJobtitle;

//ShowMessage ('Printing EntFax File: ' + PrnInfo.feJobtitle + #13 + 'InClass: ' + FilePrinter.PrintTitle);
    FilePrinter.Execute;
//ShowMessage ('After Printing EntFax File: ' + FilePrinter.PrintTitle);

    // HM 22/03/01: Updated for changes by Neil in GetWindowsVersion
    If EntFaxing And (GetWindowsVersion In [wv2000, wv2000TerminalServer, wvXP, wvXPTerminalServer]) Then
      WaitForCompletion;
  Except
    On Ex:Exception Do
    {$IFNDEF SENT}
        MessageDlg ('The following error occurred sending a fax to ''' + Trim(PrnInfo.feFaxTo) +
                    ''' on ''' + Trim(PrnInfo.feFaxToNo) + ''':' + #13#13 +
                    Ex.Message, mtError, [mbOk], 0);
    {$ELSE}
      raise;
    {$ENDIF}
  End;
End; { SendEntFax }

{---------------------------------------------------------------------------}

Procedure SendMAPIFax (Const PrnInfo : TSBSPrintSetupInfo;
                       Const FName   : ShortString);
Var
  EmailO : TEntEmail;
  Res    : SmallInt;
Begin { SendMAPIFax }
  EmailO := TEntEmail.Create;
  Try
    Try
      With EmailO Do Begin
        UseMAPI := True;

        { Set From details }
        Sender := PrnInfo.feFaxFrom;
        SenderName := PrnInfo.feFaxFromNo;

        { Set To Details }
        Recipients.Add ('[FAX:' + Trim(PrnInfo.feFaxToNo) + ']');

        { Attach fax job }
        Attachments.Add (Fname);

        { Send Fax }
        Res := EmailO.Send;

        If (Res > 0) Then Begin
          { Raise exception to report error }
          Raise EEmailErr.Create(EmailErr(Res));
        End; { If }
      End; { With EmailO }
    Except
      On Ex:Exception Do
    {$IFNDEF SENT}
        MessageDlg ('The following error occurred sending a fax to ''' + Trim(PrnInfo.feFaxTo) +
                    ''' on ''' + Trim(PrnInfo.feFaxToNo) + ''':' + #13#13 +
                    Ex.Message, mtError, [mbOk], 0);
    {$ELSE}
      raise
    {$ENDIF}
    End;
  Finally
    EmailO.Destroy;
  End;
End; { SendMAPIFax }

//----------------------------------------------------------------------------

procedure TRenderingUtils.CompressPDF(InStream, OutStream: TStream; var CompressMethod: String);
begin
  With TCompressionStream.Create (clMax, OutStream) Do
    Try
      CopyFrom (InStream, InStream.Size);
    Finally
      Free;
    End;
end;

//----------------------------------------------------------------------------


Initialization

  NumPrevWins:=0;

  // HM 08/02/02: Added backdoor to disable Internal PDF Compression if required
  WantPDFCompression := Not FileExists (ExtractFilePath(Application.ExeName) + 'SMALLPDF.NO');

Finalization

end.

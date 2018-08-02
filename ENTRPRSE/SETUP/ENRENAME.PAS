unit EnRename;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, ExtCtrls, FileCtrl, StdCtrls, SetupU, ComCtrls, IniFiles;

type
  TfrmRenameError = class(TSetupTemplate)
    btnRecheck: TButton;
    Label1: TLabel;
    reResults: TRichEdit;
    procedure btnRecheckClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
  private
    { Private declarations }
    Function TestComponent (Const ComponentPath : ShortString) : Boolean;
    Function  ValidOk(VCode : Char) : Boolean; Override;
  public
    { Public declarations }
    ErrCount   : SmallInt;    // number of errors during last test
    W_MainDir  : String;      // Path to main company directory

    procedure DoRenameTest;
  end;

var
  frmRenameError: TfrmRenameError;


{ Renames various .EXE's etc... to check for people running the system }
function SCD_EntRenameCheck (var DLLParams: ParamRec): LongBool; StdCall; export;


implementation

{$R *.DFM}

Uses CompUtil;

{ Renames various .EXE's etc... to check for people running the system }
function SCD_EntRenameCheck (var DLLParams: ParamRec): LongBool;
Var
  DlgPN, WiseStr   : String;
  RenameErr        : Boolean;


(*****
  //--------------------------------------------------

  { Calculates the current time in seconds }
  Function CurrentTime : Double;
  Var
    wHour, wMin, wSec, wMSec  : Word;
    lHour, lMin, lSec, lMSec : LongInt;
  begin
    Result := 0;

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
  End;

  //--------------------------------------------------

  { Returns the Time in seconds since Windows was started }
  { NOTE: Wraps to 0 after approx 49.7 days (as if any    }
  { windows system has run that long without crashing!!!) }
  Procedure WaitForSecs (Const Secs : Double);
  Var
    stTime, fiTime, cuTime : Double;
  Begin
    Try
      { Get start time - this is used to detect the time wrapping around at midnight }
      stTime := CurrentTime;

      { Calculate end time }
      fiTime := stTime + Secs;

      Repeat
        { Let other apps do something }
        Application.ProcessMessages;

        { Get time again }
        cuTime := CurrentTime;

        { Exit loop if time has wrapped around or wait period has expired }
      Until (cuTime < stTime) Or (cuTime > fiTime);
    Except
      On Ex: Exception Do
        MessageDlg ('The following exception occurred in WaitForSecs: ' +
                    #13#10#13#10 + '"' + Ex.Message + '"', mtError, [mbOk], 0);
    End;
  End;

  //--------------------------------------------------

  // Renames a File and checks it was deleted
  Function RenameAndCheckFile (Const FilePath, OrigFile, RenFile : String) : Boolean;
  Var
    Res : Integer;
  Begin { RenameAndCheckFile }
    Result := True;

    If DirectoryExists (FilePath) And FileExists (FilePath + OrigFile) Then Begin
      { Delete any pre-existing rename file }
      If FileExists (FilePath + RenFile) Then Begin
        { Remove any potential read-only attributes }
        Res := FileSetAttr (FilePath + RenFile, 0);
        If (Res <> 0) Then
          ShowMessage ('Error removing Read-Only Attributes ' + FilePath + RenFile + ': ' + IntToStr(Res));

        { Delete file }
        Result := DeleteFile(FilePath + RenFile);

        If Result Then Begin
          { Wait for file deletion to finish }
          WaitForSecs (1);
        End; { If Result }
      End; { If FileExists (FilePath + RenFile) }

      If Result Then Begin
        { Remove any potential read-only attributes }
        Res := FileSetAttr (FilePath + OrigFile, 0);
        If (Res <> 0) Then
          ShowMessage ('Error removing Read-Only Attributes ' + FilePath + OrigFile + ': ' + IntToStr(Res));

        { Rename the target file }
        Result := RenameFile(FilePath + OrigFile, FilePath + RenFile);

        If Result Then Begin
          { Wait for file rename to finish }
          WaitForSecs (1);

          { check file not there - who's paraniod }
          Result := Not FileExists(FilePath + OrigFile);
          If (Not Result) Then Begin
            { Rename failed - original file still exists }
            MessageDlg ('Error renaming ' + OrigFile + ' in ' + FilePath + '. Please manually ' +
                        'rename it to ' + RenFile + ' and retry the conversion.', mtError, [mbOk], 0);
          End; { If (Not Result) }
        End { If Result }
        Else Begin
          { Rename failed }
          MessageDlg ('Error renaming ' + OrigFile + ' in ' + FilePath + '. Please manually ' +
                      'rename it to ' + RenFile + ' and retry the conversion.', mtError, [mbOk], 0);
        End; { Else }
      End { If Result }
      Else Begin
        { Cannot delete old rename file }
        MessageDlg ('Error deleting  ' + RenFile + ' in ' + FilePath + '. Please manually ' +
                    'delete it and retry the conversion.', mtError, [mbOk], 0);
      End; { Else }
    End; { If FileExists (FilePath) }
  End; { RenameAndCheckFile }

  //--------------------------------------------------
*****)


Begin { SCD_EntRenameCheck }
  { Get path of help file }
  GetVariable(DLLParams, 'INST', WiseStr);
  FixPath(WiseStr);
  Application.HelpFile := WiseStr + 'SETUP.HLP';

  { Read Previous/Next instructions from Setup Script }
  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);

  With TfrmRenameError.Create (Application) Do
    Try
      { Main Directory }
      GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
      FixPath(W_MainDir);

      // Perform the component checks
      DoRenameTest;

      If (ErrCount > 0) Then Begin
        // Components in use
        ShowModal;

        Case ExitCode Of
          'B' : Begin { Back }
                  SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3))
                End;
          'N' : Begin { Next }
                  SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));
                End;
          'X' : Begin { Exit Installation }
                  SetVariable(DLLParams,'DIALOG','999')
                End;
        End; { Case ExitCode }
      End { If (ErrCount > 0) }
      Else
        // Only called when moving forward - Move to next dialog in wizard
        SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));
    Finally
      Free;
    End;

  // WISE ignoring function result
  Result := False;
End; { SCD_EntRenameCheck }

//----------------------------------------------------------------------------

// Tests to see if a component is in use, TRUE = In Use, False = AOK
Function TfrmRenameError.TestComponent (Const ComponentPath : ShortString) : Boolean;
Var
  //RenPath      : ShortString;
  //I            : SmallInt;
  fhandle: Integer;
begin { TestComponent }
  Result := False;

(***** MH 07/11/06: Modified as it didn't seem to work anymore - possibly Win9x only
  If FileExists (ComponentPath) Then Begin
    // Generate an alternate name that isn't currently in use
    For I := 1 To 999 Do Begin
      RenPath := ChangeFileExt (ComponentPath, Format('.%3.3d', [I]));

      If (Not FileExists(RenPath)) Then
        Break;
    End; { For I }

    // Remove any potential read-only attributes }
    FileSetAttr (ComponentPath, 0);

    // Rename to temporary name
    Result := Not RenameFile(ComponentPath, RenPath);

    If (Not Result) Then
      // rename back to correct name
      RenameFile(RenPath, ComponentPath);
*****)

  If FileExists (ComponentPath) Then
  Begin
    Try
      // Try to open the file with Read-Write permissions exclusively - if 0 returned then
      // no-one else is using it
      fhandle := FileOpen( ComponentPath, fmOpenReadWrite or fmShareExclusive );
      If (fhandle >= 0) Then
      Begin
        // Not in use
        FileClose( fhandle );
        Result := False;
      End
      Else
        // In use
        Result := True;
    Except
      Result := True;
    End; // Try
  End; { If FileExists (ComponentPath)  }

  // Increment the Error Counter if the component couldn't be renamed
  If Result Then Inc (ErrCount);
End; { TestComponent }

//------------------------------------

procedure TfrmRenameError.DoRenameTest;
Var
  FaxUsers : TStringList;
  iPos     : SmallInt;

  Procedure AddTitle (Const Title, Prog : ShortString; Const IsTrayIcon : Boolean = False);
  Var
    CurrPos : LongInt;
  Begin { AddTitle }
    With reResults Do Begin
      CurrPos := Length(Lines.Text);

      If Not IsTrayIcon Then
        Lines.Add (Title + '   (' + Prog + ')')
      Else
        Lines.Add (Title + '   (' + Prog + ')   (Tray-Icon)');

      SelStart := CurrPos;
      SelLength := Length(Title);
      With SelAttributes Do Begin
        Color := clBlack;
        Style := [fsBold, fsUnderLine];
      End; { With }

      SelStart := CurrPos + Length(Title) + 3;
      SelLength := Length(Prog) + 2;
      With SelAttributes Do Begin
        Color := clBlack;
        Style := [];
      End; { With }

      If IsTrayIcon Then Begin
        SelStart := SelStart + SelLength + 3;
        SelLength := 11;
        With SelAttributes Do Begin
          Color := clBlue;
          Style := [];
        End; { With }
      End; { If IsTrayIcon }
    End; { With reResults }
  End; { AddTitle }

  Procedure AddNormal (Const S : ShortString);
  Var
    CurrPos : LongInt;
  Begin { AddNormal }
    With reResults Do Begin
      CurrPos := Length(Lines.Text);

      Lines.Add (S);

      SelStart := CurrPos;
      SelLength := Length(S);
      With SelAttributes Do Begin
        Color := clBlack;
        Style := [];
      End; { With }
    End; { With reResults }
  End; { AddNormal }

begin { DoRenameTest }
  // Rest the error count and clear the results
  ErrCount := 0;
  reResults.Clear;

  If TestComponent (W_MainDir + 'Entrprse.Exe') Then Begin
    // Add Entry into richedit control
    AddTitle  ('Exchequer Splash Screen', 'Entrprse.Exe');
    AddNormal ('Someone is running the Exchequer Multi-Company Manager.');
    AddNormal ('');
  End; { If ... Entrprse.Exe }

  If TestComponent (W_MainDir + 'EntComp.Dll') Then Begin
    // Add Entry into richedit control
    AddTitle  ('Multi-Company Manager', 'EntComp.Dll');
    AddNormal ('Someone is running the Exchequer Multi-Company Manager, or possibly a '#13#10 +
               'Toolkit Application that uses EntComp.DLL to access the Multi-Company '#13#10 +
               'Manager.');
    AddNormal ('');
  End; { If ... EntComp.Dll }

  If TestComponent (W_MainDir + 'Enter1.Exe') Then Begin
    // Add Entry into richedit control
    AddTitle  ('Exchequer Accounts', 'Enter1.Exe');
    AddNormal ('Someone is running Exchequer.');
    AddNormal ('');
  End; { If ... Enter1.Exe }

  If TestComponent (W_MainDir + 'Excheqr.Exe') Then Begin
    // Add Entry into richedit control
    AddTitle  ('Exchequer for DOS', 'Excheqr.Exe');
    AddNormal ('Someone is running Exchequer for DOS.');
    AddNormal ('');
  End; { If ... Excheqr.Exe }

  If TestComponent (W_MainDir + 'W32MKDE.EXE') Then Begin
    // Add Entry into richedit control
    AddTitle  ('Microkernel Database Engine', 'W32MKDE.EXE');
    AddNormal ('Someone is running the Btrieve Microkernel Database Engine.');
    AddNormal ('');
  End; { If ... Enter1.Exe }

  If TestComponent (W_MainDir + 'SBSForm.Dll') Then Begin
    // Add Entry into richedit control
    AddTitle  ('Form Printing Library', 'SbsForm.Dll');
    AddNormal ('Someone is running either Exchequer, the Exchequer Form '#13#10 +
               'Designer or a Toolkit Application that uses SBSForm.DLL to print '#13#10 +
               'Exchequer Forms.');
    AddNormal ('');
  End; { If ... SBSForm.Dll }

  If TestComponent (W_MainDir + 'EnterOLE.Exe') Then Begin
    // Add Entry into richedit control
    AddTitle  ('OLE Server', 'EnterOLE.Exe');
    AddNormal ('Someone is using the Exchequer OLE Server, probably via the Excel or'#13#10 +
               'Crystal Reports Add-In''s.');
    AddNormal ('');
  End; { If ... EnterOLE.Exe }

  If TestComponent (W_MainDir + 'EnRepWrt.Exe') Then Begin
    // Add Entry into richedit control
    AddTitle  ('Exchequer Report Writer', 'EnRepWrt.Exe');
    AddNormal ('Someone is running the Exchequer Report Writer.');
    AddNormal ('');
  End; { If ... EnRepWrt.Exe }

  If TestComponent (W_MainDir + 'EntRW.Exe') Then Begin
    // Add Entry into richedit control
    AddTitle  ('Visual Report Writer', 'EntRW.Exe');
    AddNormal ('Someone is running the Visual Report Writer.');
    AddNormal ('');
  End; { If TestComponent (W_MainDir + 'EntRW.Exe') }

  If TestComponent (W_MainDir + 'EntToolk.Dll') Then Begin
    // Add Entry into richedit control
    AddTitle  ('Exchequer COM Toolkit', 'EntToolk.Dll');
    AddNormal ('An Application or Plug-In is using the Exchequer COM Toolkit.');
    AddNormal ('');
  End; { If ... EntToolk.Dll }

  If TestComponent (W_MainDir + 'EntToolk.Exe') Then Begin
    // Add Entry into richedit control
    AddTitle  ('Exchequer COM Toolkit', 'EntToolk.Exe');
    AddNormal ('An Application or Plug-In is using the Exchequer COM Toolkit.');
    AddNormal ('');
  End; { If ... EntToolk.Exe }

  // Exchequer Faxing
  If TestComponent (W_MainDir + 'FAXSRV\FaxClnt.Exe') Then Begin
    // Add Entry into richedit control
    AddTitle  ('Exchequer Fax Client', 'FaxSrv\FaxClnt.Exe', True);
    AddNormal ('A workstation is still running the Exchequer Faxing client, the following'#13#10 +
               'users are listed as currently running it:-');
    AddNormal ('');

    // Read the Fax Client Users .INI file and report the active users
    FaxUsers := TStringList.Create;
    Try
      With TIniFile.Create(W_MainDir + 'FAXSRV\CLNTUSER.INI') Do
        Try
          ReadSectionValues('Logged In', FaxUsers);

          If (FaxUsers.Count > 0) Then Begin
            // Report Users
            FaxUsers.Sorted := TRUE;
            for iPos := 0 to FaxUsers.Count - 1 do
              AddNormal ('    ' + UpperCase(FaxUsers.Values[FaxUsers.Names[iPos]]) + ' on ' + UpperCase(FaxUsers.Names[iPos]));
          End { If (slUsers.Count > 0) }
          Else
            AddNormal ('  No Users Listed');
        Finally
          Free;
        End;{try}
    Finally
      FreeAndNIL(FaxUsers);
    End;
    AddNormal ('');
  End; { If ... FaxSrv\FaxClnt.Exe }
  If TestComponent (W_MainDir + 'FAXSRV\FaxSend.Exe') Then Begin
    // Add Entry into richedit control
    AddTitle  ('Exchequer Fax Server', 'FaxSrv\FaxSend.Exe');
    AddNormal ('The Exchequer Faxing Server is still running.');
    AddNormal ('');
  End; { If ... FaxSrv\FaxSend.Exe }

  // Sentimail
  If TestComponent (W_MainDir + 'Sentinel.Exe') Then Begin
    // Add Entry into richedit control
    AddTitle  ('Exchequer Sentimail Monitor', '(Sentinel.Exe)', True);
    AddNormal ('The Exchequer Sentimail Monitor is still running.');
    AddNormal ('');
  End; { If ... EntComp.Dll }
  If TestComponent (W_MainDir + 'SentServ.Exe') Then Begin
    // Add Entry into richedit control
    AddTitle  ('Exchequer Sentimail Monitor', '(Sentinel.Exe)', True);
    AddNormal ('The Exchequer Sentimail Monitor is still in use.');
    AddNormal ('');
  End; { If ... EntComp.Dll }

  // E-Business Module
  If TestComponent (W_MainDir + 'EbusImp.Exe') Then Begin
    // Add Entry into richedit control
    AddTitle  ('E-Business Import Module', 'EbusImp.Exe', True);
    AddNormal ('The Exchequer E-Business Import Module is still running.  ');
    AddNormal ('');
  End; { If ... EbusImp.Exe }
  If TestComponent (W_MainDir + 'EbusExp.Exe') Then Begin
    // Add Entry into richedit control
    AddTitle  ('E-Business Export Module', 'EbusExp.Exe', True);
    AddNormal ('The Exchequer E-Business Export Module is still running.');
    AddNormal ('');
  End; { If ... EbusImp.Exe }
  If TestComponent (W_MainDir + 'EbusAdmn.Exe') Then Begin
    // Add Entry into richedit control
    AddTitle  ('E-Business Administration Module', 'EbusAdmn.Exe');
    AddNormal ('The Exchequer E-Business Administration Module is still running.');
    AddNormal ('');
  End; { If ... EbusImp.Exe }

  // Import Modules
  If TestComponent (W_MainDir + 'Import\ExImport.Exe') Then Begin
    // Add Entry into richedit control
    AddTitle  ('DOS Import Module', 'Import\ExImport.Exe');
    AddNormal ('The DOS Import Module is still running.');
    AddNormal ('');
  End; { If ... EbusImp.Exe }
  If TestComponent (W_MainDir + 'Import\ExWImp.Exe') Then Begin
    // Add Entry into richedit control
    AddTitle  ('Windows Import Module', 'Import\ExWImp.Exe');
    AddNormal ('The Windows Import Module is still running.');
    AddNormal ('');
  End; { If ... EbusImp.Exe }
  If TestComponent (W_MainDir + 'Import\CSVExch.Exe') Then Begin
    // Add Entry into richedit control
    AddTitle  ('CSV Import Module', 'Import\CSVExch.Exe');
    AddNormal ('The CSV Import Module is still running.');
    AddNormal ('');
  End; { If ... EbusImp.Exe }

  // Scheduler Service
  If TestComponent (W_MainDir + 'SchedSrv.exe') Then
  Begin
    // Add Entry into richedit control
    AddTitle  ('Scheduler Service', 'SchedSrv.exe');
    AddNormal ('The Scheduler Service is still in use.');
    AddNormal ('');
  End; { If ... Dashboard.exe }

  // Client-Sync Dashboard
  If TestComponent (W_MainDir + 'Dashboard.exe') Then
  Begin
    // Add Entry into richedit control
    AddTitle  ('Dashboard', 'Dashboard.exe');
    AddNormal ('The Dashboard is still running.');
    AddNormal ('');
  End; { If ... Dashboard.exe }
  If TestComponent (W_MainDir + 'WrapperDSRServer.exe') Then
  Begin
    // Add Entry into richedit control
    AddTitle  ('Exchequer Data Synchronisation Service', 'WrapperDSRServer.exe');
    AddNormal ('The Exchequer Data Synchronisation Service is still in use.');
    AddNormal ('');
  End; { If ... Dashboard.exe }
end; { DoRenameTest }

//------------------------------------

procedure TfrmRenameError.btnRecheckClick(Sender: TObject);
begin
  inherited;

  DoRenameTest;
end;

//------------------------------------

procedure TfrmRenameError.NextBtnClick(Sender: TObject);
begin
  inherited;

end;

//------------------------------------

function TfrmRenameError.ValidOk(VCode: Char): Boolean;
begin
  Result := True;

  If (VCode = 'N') Then Begin
    // Next button clicked - confirm if anything remaining in the list

    // Update the list
    DoRenameTest;

    // Ask user to confirm if there are any outstanding components
    If (ErrCount > 0) Then
      Result := (MessageDlg('There are ' + IntToStr(ErrCount) + ' components still in use.'#13#13 +
                            'Continuing whilst they are still being used will prevent them being upgraded correctly.'#13#13 +
                            'Are you sure you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);

  End; { If (VCode = 'N') }
end;

end.

Unit uGetCompanyDetail;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SETUPBAS, StdCtrls, Mask, TEditVal, ExtCtrls, SetupU, Math, sqlutils;

Type
  TfrmGetCompDetail = Class(TSetupTemplate)
    cpName: Text8Pt;
    Label1: TLabel;
    cpCode: Text8Pt;
    Procedure FormCreate(Sender: TObject);
    Procedure cpNameChange(Sender: TObject);
    Procedure cpNameExit(Sender: TObject);
    Procedure cpCodeKeyPress(Sender: TObject; Var Key: Char);
  Private
    NameChanged: Boolean;
//    Function CheckCodeOk : Boolean;
    Function ValidCode : Boolean;
    Function ValidOk(VCode: Char): Boolean; Override;
    Function CompanyExists(Const CompCode : String) : Boolean;
    Procedure CalculateCompCode (CompName: ShortString);
    Function ProcessCompName (CompName : ShortString) : ShortString;
  Public
    { Public declarations }
    OrigCode: String[6];
    CompanyMainPath: String;
    DatabaseType: String;
    InstallType: String;
  End;

Function SCD_EntGetCompanyDetail(Var DLLParams: ParamRec): LongBool; StdCall; export;

Var
  frmGetCompDetail: TfrmGetCompDetail;

Implementation

{$R *.dfm}

Const
  ValidChars = ['A'..'Z', '0'..'9'];

//=========================================================================

Function SCD_EntGetCompanyDetail(Var DLLParams: ParamRec): LongBool;
Var
  Params: ANSIString;
  DlgPN,
    ChkState,
    CompNameCD,
    CompCode,
    CompName,
    AddComp,
    lDemoComp,
    lDbType,
    lMainDir: String;
  lPos: integer;
Begin {SCD_EntGetCompanyDetail}
//ShowMessage ('SCD_EntGetCompanyDetail.Start');
  Result := True;  // Return value ignored

  Params := DLLParams.szParam;
  If (Copy(Params, 1, 7) = 'KJ3G839') And (Length(Params) = 7) Then
  Begin
    // Get path of help file
    GetVariable(DLLParams, 'INST', DlgPN);
    Application.HelpFile := IncludeTrailingPathDelimiter(DlgPN) + 'SETUP.HLP';

    GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);
    GetVariable(DLLParams, 'D_COMPNAME', CompNameCD);
    GetVariable(DLLParams, 'V_GETCOMPCODE', CompCode);
    GetVariable(DLLParams, 'V_GETCOMPNAME', CompName);
    GetVariable(DLLParams, 'V_INSTTYPE', AddComp);
    GetVariable(DLLParams, 'V_DEMODATA', lDemoComp);
    GetVariable(DLLParams, 'V_MAINDIR', lMainDir);
    GetVariable(DLLParams, 'L_DBTYPE', lDbType);

    frmGetCompDetail := TfrmGetCompDetail.Create(Application);
    Try
      With frmGetCompDetail Do
      Begin
        CompanyMainPath := IncludeTrailingPathDelimiter(lMainDir);
        DatabaseType := lDbType;   // '0'-Pervasive / '1'-SQL
        InstallType := AddComp;    // 'A' - Install / 'B' - Upgrade / 'C' - Add Company

        // Use existing company code and name if set
        If (Trim(CompCode) <> '') And (Trim(CompName) <> '') Then
        Begin
          cpCode.Text := Trim(CompCode);
          cpName.Text := Trim(CompName);
        End // If (Trim(CompCode) <> '') And (Trim(CompName) <> '')
        Else
        Begin
          // Not set
          If (Trim(Uppercase(lDemoComp)) = 'Y') Then
          Begin
            // Demo Data
            cpName.Text := 'Demonstration Company';
            CalculateCompCode('ZZZZ');
          End // If (Trim(Uppercase(lDemoComp)) = 'Y')
          Else
          Begin
            // Blank Data - default to Company Name in CD Licence
            If (Trim(CompNameCD) <> '') Then
            Begin
              lPos := Pos('-', CompNameCD);
              cpName.Text := Trim(copy(Trim(CompNameCD), 1, lpos - 1));
              CalculateCompCode('ZZZZ');
            End; // If (Trim(CompNameCD) <> '')
          End; // Else
        End; // Else

        ShowModal;

        Case ExitCode Of
          'B': Begin { Back }
                 SetVariable(DLLParams, 'DIALOG', Copy(DlgPN, 1, 3));
               End;
          'N': Begin { Next }
                 SetVariable(DLLParams, 'DIALOG', Copy(DlgPN, 4, 3));

                 SetVariable(DLLParams, 'V_GETCOMPCODE', Trim(cpCode.Text));
                 SetVariable(DLLParams, 'V_GETCOMPNAME', Trim(cpName.Text));
               End;
          'X': Begin { Exit Installation }
                 SetVariable(DLLParams, 'DIALOG', '999')
               End;
        End; // Case ExitCode
      End; // With frmGetCompDetail
    Finally
      frmGetCompDetail.Free;
    End; // Try..Finally
  End; // If (Copy(Params, 1, 7) = 'KJ3G839') And (Length(Params) = 7)
End; {SCD_EntGetCompanyDetail}

//-------------------------------------------------------------------------

Procedure TfrmGetCompDetail.FormCreate(Sender: TObject);
Begin
  Inherited;
  NameChanged := False;
End;

//-------------------------------------------------------------------------

Procedure TfrmGetCompDetail.cpNameChange(Sender: TObject);
Begin
  If Visible Then
    NameChanged := True;
End;

//------------------------------

Procedure TfrmGetCompDetail.cpNameExit(Sender: TObject);
Begin
  If (Trim(cpName.Text) <> '') And (NameChanged Or (Not ValidCode)) Then
    CalculateCompCode (cpName.Text);
End;

//------------------------------

Procedure TfrmGetCompDetail.cpCodeKeyPress(Sender: TObject; Var Key: Char);
Begin
  Inherited;

  If (key In ['a'..'z']) Then
    key := char(ord(Key) - 32);

  // Only allow 'A'..'Z' and '0'..'9' plus backspace
  If Not (key In ValidChars + [#8]) Then
    Key := #0;
End;

//-------------------------------------------------------------------------

// Duplicated in X:\Entrprse\Conversion\v600 SQL Converter\Converter\oConvertOptions.Pas
// Check the company code to see if it is a) set and b) only contains supported characters
Function TfrmGetCompDetail.ValidCode : Boolean;
Var
  sCode : ShortString;
  I: SmallInt;
Begin
  sCode := UpperCase(Trim(cpCode.Text));
  Result := (sCode <> '') And (Not (sCode[1] In ['0'..'9']));
  If Result Then
  Begin
    For I := 1 To Length(cpCode.Text) Do
    Begin
      If Not (cpCode.Text[I] In ValidChars) Then
      Begin
        Result := False;
        Break;
      End; { If }
    End; { For }
  End; { If }
End;

//------------------------------

Function TfrmGetCompDetail.ProcessCompName (CompName : ShortString) : ShortString;
Var
  I : SmallInt;
Begin // ProcessCompName
  Result := '';
  CompName := UpperCase(Trim(CompName));
  For I := 1 To Length(CompName) Do
  Begin
    If (CompName[I] In ValidChars) Then
      // 1st char cannot be a number
      If (Result <> '') Or (Not (CompName[I] In ['0'..'9'])) Then
        Result := Result + CompName[I];
  End; // For I
End; // ProcessCompName

//------------------------------

Procedure TfrmGetCompDetail.CalculateCompCode (CompName: ShortString);
Var
  sBaseCode, sCompCode : String[6];
  iLoop, iMax, iId : LongInt;
  GotUnique : Boolean;
Begin // CalculateCompCode
  CompName := ProcessCompName(CompName);

  GotUnique := False;
  For iLoop := 4 Downto 1 Do
  Begin
    // Check we got enough chars
    If (Length(CompName) >= iLoop) Then
    Begin
      sBaseCode := Copy(CompName, 1, iLoop);
      iMax := Trunc(Power(10, 6 - iLoop)) - 1;

      For iId := 1 To iMax Do
      Begin
        sCompCode := sBaseCode + Format('%*.*d', [6 - iLoop, 6 - iLoop, iId]);
        If (InstallType = 'C') Then
        Begin
          // Add Company - must check with database
          GotUnique := Not CompanyExists(sCompCode);
        End // If (InstallType = 'C')
        Else
          // Install - no existing companies so it will be AOK
          GotUnique := True;

        If GotUnique Then Break;
      End; // For iId
    End; // If (Length(sCompCode) >= iLoop)

    If GotUnique Then Break;
  End; // For iLoopend; {Func..}

  If GotUnique Then
  Begin
    cpCode.Text := sCompCode;
    NameChanged := False;
  End; // If GotUnique
End; // CalculateCompCode

//-------------------------------------------------------------------------

Function TfrmGetCompDetail.ValidOk(VCode: Char): Boolean;
Begin
  If (VCode = 'N') Then
  Begin
    Result := False;

    If (Trim(cpCode.Text) <> '') Then
    Begin
      // Code is set - check it is unique
      If ValidCode Then
      Begin
        Result := (Trim(cpName.Text) <> '');
        If Result Then
        Begin
          If (InstallType = 'C') Then
          Begin
            // Add Company - check code against Company.Dat for uniqueness
            Result := Not CompanyExists(Trim(cpCode.Text));

            If (Not Result) Then
              MessageDlg('A Company with this Company Code already exists', mtWarning, [mbOk], 0);
          End; // If (InstallType = 'C')
        End // If Result
        Else
        Begin
          MessageDlg('The Company Name cannot be left blank', mtWarning, [mbOk], 0);
          If cpName.CanFocus Then cpName.SetFocus;
        End; // Else
      End // If ValidCode
      Else
      Begin
        MessageDlg('The Company Code must be set and can only contain characters from A-Z and 0-9 and must not start with a number', mtWarning, [mbOk], 0);
        If cpCode.CanFocus Then cpCode.SetFocus;
      End; // Else
    End { If }
    Else
    Begin
      MessageDlg('The Company Code cannot be left blank', mtWarning, [mbOk], 0);
      If cpCode.CanFocus Then cpCode.SetFocus;
    End; // Else
  End { If }
  Else
    Result := True;
End;

//-------------------------------------------------------------------------

Function TfrmGetCompDetail.CompanyExists(Const CompCode : String) : Boolean;
Var
  LibPath   : ANSIString;
  hSetupSQL : THandle;
  _SQLHLPR_CompanyExists : Function (Const ExchequerPath, CompCode : ShortString) : WordBool; StdCall;

  { Updates the PATH statement for the current process to include the Enterprise directory }
  function SetEnterprisePath(const Path:String) : LongBool;
  var
    CurrentPath : String;
    EntDir      : String;
    NewPath     : ANSIString;
  Begin { SetEnterprisePath }
    // Get current PATH for the process
    CurrentPath := SysUtils.GetEnvironmentVariable('PATH');

    // Check to see if it is already present in the path
    If (Pos(UpperCase(Path), UpperCase(CurrentPath)) = 0) Then Begin
      // Build the new path with the Enterprise directory at the start
      NewPath := Path + ';' + CurrentPath;

      // Update the environment settings for the current process
      SetEnvironmentVariable('PATH', PChar(NewPath));
    End; { If (Pos(UpperCase(EntDir), CurrentPath) = 0) }
  End; { SetEnterprisePath }

Begin
  Result := False;

  If (InstallType = 'C') Then
  Begin
    // Load SetupSQL.DLL dynamically to check whether the company code already exists in Company.Dat
    LibPath := CompanyMainPath + 'SetupSQL.Dll';
    hSetupSQL := LoadLibrary(PCHAR(LibPath));
    If (hSetupSQL = 0) Then
    Begin
      // Failed - try adding the directory into the PATH
      SetEnterprisePath(ExtractFilePath(LibPath));
      hSetupSQL := LoadLibrary(PCHAR(LibPath));
    End; // If (hSetupSQL = 0)

    If (hSetupSQL > HInstance_Error) Then
    Begin
      Try
        _SQLHLPR_CompanyExists := GetProcAddress(hSetupSQL, 'SQLHLPR_CompanyExists');

        If Assigned(_SQLHLPR_CompanyExists) Then
          Result := _SQLHLPR_CompanyExists(CompanyMainPath, CompCode);
      Finally
        FreeLibrary(hSetupSQL);
      End; // Try..Finally
    End; // If (hSetupSQL > HInstance_Error)
  End; // If (InstallType = 'C')
End;

//=========================================================================

End.


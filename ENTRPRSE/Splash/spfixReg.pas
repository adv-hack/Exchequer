unit spfixReg;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Setupbas, ShellApi, Registry, ExtCtrls, StdCtrls, BorBtns, IniFiles;

type
  WSCheckRecType = Record
    OLEOK        : Boolean;
    GraphOK      : Boolean;
    BtrieveOK    : Boolean;
    SecurityOK   : Boolean;
    ComTKOK      : Boolean;
  End; { WSCheckRecType }

  TfrmWSConfig = class(TSetupTemplate)
    ScrollBox1: TScrollBox;
    panOLE: TPanel;
    panBtrieve: TPanel;
    panGraph: TPanel;
    Label1: TLabel;
    panSecurity: TPanel;
    panCOMTK: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TitleLblDblClick(Sender: TObject);
  private
    { Private declarations }
    Function  ValidOk(VCode : Char) : Boolean; OverRide;
  public
    { Public declarations }
    Procedure NilMsg (Const Msg : ShortString; Const Refresh : Boolean);
  end;



Function WSChecks (Var WSCheckInfo : WSCheckRecType; Const IsWG : Boolean) : Boolean;
Function DisplayWSSetup (Var WSCheckInfo : WSCheckRecType) : Boolean;


implementation

{$R *.DFM}

Uses DiskUtil, PathUtil, LicRec, EntLic,
{$IFDEF EXSQL}
     EntLicence,
{$ENDIF}
     VAOUtil;

//-------------------------------------------------------------------------

{ Look at registry to determine if a workstation setup has been run }
Function WSChecks (Var WSCheckInfo : WSCheckRecType; Const IsWG : Boolean) : Boolean;
Var
  RegO                     : TRegistry;
  ClsId, CurrDir           : ShortString;
  Msg4, Msg5,
  LogDir, Msg1, Msg2, Msg3 : ShortString;
  VerString                : String;
  UCount, BtMode           : SmallInt;
  ClServer, BitchMode      : Boolean;
  EntLicR                  : EntLicenceRecType;

  //------------------------------

  Function CheckDWord (Const Key : String;Const MinVal : Integer;Const Exact : Boolean) : Boolean;
  Var
    DWord  : Integer;
  Begin
    DWord := RegO.ReadInteger(Key);
    Result := (Exact And (Dword = MinVal)) Or         { Matches exactly }
              ((Not Exact) And (DWord >= MinVal));    { >= minval }
  End;

  //------------------------------

  Function CheckString (Const Key, Value : String) : Boolean;
  Var
    Str : String;
  Begin
    Str := RegO.ReadString(Key);
    Result := (Str = Value);
  End;

  //------------------------------

  Function BuildMsg (Const BoolVal : Boolean; Const Msg, InvMsg : ShortString) : ShortString;
  Begin { BuildMsg }
    If BoolVal Then
      { OK }
      Result := Msg + 'OK'
    Else
      Result := Msg + InvMsg;
  End; { BuildMsg }

  //------------------------------

  // Check that a particular server is registered to the current directory
  Function ChkCOMServer(Const ServerName : ShortString; Const AllowAnyDir : Boolean = False) : Boolean;
  Var
    ClsId, CurrDir, SvrPath : ShortString;
    OK                      : Boolean;
  Begin { ChkCOMServer }
    Result := False;

    With TRegistry.Create Do
      Try
        Access := KEY_READ;
        RootKey := HKEY_CLASSES_ROOT;

        // Check for servers Class Id entry - e.g. EnterpriseForms.PrintingToolkit\ClsId
        If KeyExists(ServerName + '\Clsid') Then
          // Key exists - Open key and get the CLSID (aka OLE/COM Server GUID)
          If OpenKey(ServerName + '\Clsid', False) Then
            // ClsId is stored in the Default entry - accessed using ''
            If KeyExists('') Then Begin
              { CLSID stored in default entry }
              ClsId := ReadString ('');
              CloseKey;

              // Got CLSID - find entry in CLSID Section and get the registered .EXE/.DLL path & name
              If KeyExists ('Clsid\'+ClsId+'\InprocServer32') Then
                SvrPath := 'Clsid\'+ClsId+'\InprocServer32'
              Else
                If KeyExists ('Clsid\'+ClsId+'\LocalServer32') Then
                  SvrPath := 'Clsid\'+ClsId+'\LocalServer32'
                Else
                  SvrPath := '';

              If (SvrPath <> '') Then
                // Got Server path - read .EXE/.DLL details and check it exists }
                If OpenKey(SvrPath, False) Then Begin
                  ClsId := ReadString ('');

                  If FileExists (ClsId) Then Begin
                    { Got File - Check its in current directory }
                    ClsId   := UpperCase(Trim(PathToShort(ExtractFilePath(ClsId))));
                    CurrDir := UpperCase(Trim(PathToShort(ExtractFilePath(Application.ExeName))));

                    Result := (ClsId = CurrDir) Or AllowAnyDir;
                  End; { If FileExists (ClsId) }
                End; { If OpenKey(SvrPath, False) }
            End; { If KeyExists('') }

        CloseKey;
      Finally
        Free;
      End;
  End; { ChkCOMServer }

  //------------------------------

Begin { WSChecks }
  BitchMode := FindCmdLineSwitch('BITCH', ['/', '-'], True);

  // HM 18/07/02: Consolidated COM Object checks through a central function and added
  //              checks on the Form Printing Toolkit
  With WSCheckInfo Do Begin
    OLEOK      := ChkCOMServer('Enterprise.OLEServer', (VAOInfo.vaoMode = smVAO));
    GraphOK    := ChkCOMServer('VCFI.VCFiCtrl.1', True);
    BtrieveOK  := True;
    SecurityOK := ChkCOMServer('EnterpriseSecurity.ThirdParty', (VAOInfo.vaoMode = smVAO));
    ComTKOK    := ChkCOMServer('Enterprise01.Toolkit', (VAOInfo.vaoMode = smVAO));
    If ComTKOK Then
      ComTKOK    := ChkCOMServer('Enterprise04.Toolkit', (VAOInfo.vaoMode = smVAO));
    If ComTKOK Then
      ComTKOK  := ChkCOMServer('EnterpriseForms.PrintingToolkit', (VAOInfo.vaoMode = smVAO));
  End; { With WSCheckInfo }

{$IFDEF EXSQL}
  if not EnterpriseLicence.IsSQL then
  begin
{$ENDIF}
    RegO := TRegistry.Create;
    Try
      // Check BtrieveMode is set correctly
      RegO.Access := KEY_READ;    // HM 23/12/03: This was missing - possibly causing rights problems
      RegO.RootKey := HKEY_LOCAL_MACHINE;
      If RegO.OpenKey('SOFTWARE\Exchequer\Enterprise', False) Then
      Begin
        Try
          If RegO.ValueExists('BtrieveMode') Then
          Begin
            BtMode := RegO.ReadInteger('BtrieveMode');

            WSCheckInfo.BtrieveOK := (IsWG And (BtMode = 2)) Or
                                     ((Not IsWG) And ((BtMode = 0) Or (BtMode = 1)));

            If (Not WSCheckInfo.BtrieveOK) Then
            Begin
              If BitchMode Then ShowMessage ('HKLM\SOFTWARE\Exchequer\Enterprise\BtrieveMode Mismatch');
              WSCheckInfo.BtrieveOK := RegO.ValueExists('SodOff');
            End; // If (Not WSCheckInfo.BtrieveOK)
          End // If RegO.ValueExists('BtrieveMode')
          Else
          Begin
            { Btrieve not setup properly }
            WSCheckInfo.BtrieveOK := False;
            If BitchMode Then ShowMessage ('HKLM\SOFTWARE\Exchequer\Enterprise\BtrieveMode Missing');
          End; // Else
        Finally
          RegO.CloseKey;
        End; // Try..Finally
      End // If RegO.OpenKey('SOFTWARE\Exchequer\Enterprise', False)
      Else
      Begin
        { Btrieve not setup properly }
        WSCheckInfo.BtrieveOK := False;
        If BitchMode Then ShowMessage ('HKLM\SOFTWARE\Exchequer\Enterprise\ Missing');
      End; // Else
    Finally
      RegO.Destroy;
    End;
{$IFDEF EXSQL}
  end;
{$ENDIF}

  Result := WSCheckInfo.OLEOK And WSCheckInfo.GraphOK And WSCheckInfo.BtrieveOK And WSCheckInfo.SecurityOK And WSCheckInfo.ComTKOK;

  If (Not Result) Then Begin
    { Write Log Entry reporting problems }
    LogDir := ExtractFilePath(ExtractFilePath(Application.ExeName));
    If Not (Copy(LogDir, Length(LogDir), 1)[1] = '\') Then
      LogDir := LogDir + '\';
    LogDir := LogDir + 'LOGS\';

    Msg1 := BuildMsg (WSCheckInfo.OLEOK,     'OLE Server:       ', 'Not Registered or Invalid Registration');
    Msg2 := BuildMsg (WSCheckInfo.GraphOK,   'Graph OCX:        ', 'Not Registered or Invalid Registration');
    Msg3 := BuildMsg (WSCheckInfo.BtrieveOK, 'Btrieve Database: ', 'Not Installed or Invalid Configuration');
    Msg4 := BuildMsg (WSCheckInfo.SecurityOK,'Security Server:  ', 'Not Installed or Invalid Registration');
    Msg5 := BuildMsg (WSCheckInfo.ComTKOK,   'COM Toolkit:      ', 'Not Installed or Invalid Registration');

    DoLogMsg (LogDir,
              'Workstation Configuration Checks',
              Msg1, Msg2, Msg3, Msg4, Msg5);
  End; { If }
End; { WSChecks }


Function DisplayWSSetup (Var WSCheckInfo : WSCheckRecType) : Boolean;
var
  frmWSConfig : TfrmWSConfig;
  NextTopL    : LongInt;

  Procedure SetupPanel (Const ThePanel :  TControl; Var NextTop : LongInt);
  Begin { SetupPanel }
    If ThePanel.Visible Then Begin
      With ThePanel Do Begin
        Top := NextTop;
        Inc (NextTop, Height);

        Left := 0;
        Width := 258;
      End; { With }
    End; { If }
  End; { SetupPanel }

Begin { DisplayWSSetup }
  frmWSConfig := TfrmWSConfig.Create(Application.MainForm);
  Try
    With frmWSConfig Do Begin
      NextTopL := panBtrieve.Top;

      panBtrieve.Visible := Not WSCheckInfo.BtrieveOK;
      SetupPanel (panBtrieve, NextTopL);

      panGraph.Visible := Not WSCheckInfo.GraphOK;
      SetupPanel (panGraph, NextTopL);

      panOLE.Visible := Not WSCheckInfo.OLEOK;
      SetupPanel (panOLE, NextTopL);

      panSecurity.Visible := Not WSCheckInfo.SecurityOK;
      SetupPanel (panSecurity, NextTopL);

      panCOMTK.Visible := Not WSCheckInfo.COMTKOK;
      SetupPanel (panCOMTK, NextTopL);

      ShowModal;

      Result := (frmWSConfig.ExitCode = '?');
    End; { With frmWSConfig }
  Finally
    frmWSConfig.Free;
  End;
End; { DisplayWSSetup }


{============================================================================}


procedure TfrmWSConfig.FormCreate(Sender: TObject);
Var
  TmpCapt : ShortString;
begin
  TmpCapt := Caption;

  inherited;

  Caption := TmpCapt;

  { Init ExitCode to non-valid value otherwise clicking }
  { the close button on the form bypasses the checking  }
  ExitCode := '*';

  // Configure Scroll-Box Scroll Bar - doesn't work if you set them at Design-Time!
  With ScrollBox1.VertScrollBar Do Begin
    Position := 0;
    Tracking := True;
  End; { With ScrollBox1.VertScrollBar }
end;

Function TfrmWSConfig.ValidOk(VCode : Char) : Boolean;
Var
  ParStr                      : ShortString;
  cmdFile, cmdPath, cmdParams : PChar;
  Flags                       : SmallInt;
  Res                         : LongInt;
Begin { ValidOk }
  If (VCode = 'B') Then Begin
    { Build command line to run EntReg to fix items }
    ParStr := '';

    If panBtrieve.Visible Then Begin
      { Initialise Btrieve settings }
      ParStr := ParStr + '/BTR ';
    End; { If }

    If panGraph.Visible Then Begin
      ParStr := ParStr + '/GRAPH ';
    End; { If }

    If panOLE.Visible Then Begin
      ParStr := ParStr + '/OLE ';
    End; { If }

    If panSecurity.Visible Then Begin
      ParStr := ParStr + '/SEC ';
    End; { If }

    If panCOMTK.Visible Then
      ParStr := ParStr + '/COMTK ';

    If (ParStr <> '') Then Begin
      cmdFile   := StrAlloc(255);
      cmdPath   := StrAlloc(255);
      cmdParams := StrAlloc(255);

      StrPCopy (cmdParams, '/AUTO ' + ParStr);
      StrPCopy (cmdFile,   ExtractFilePath(Application.ExeName) + 'ENTREG.EXE');
      StrPCopy (cmdPath,   ExtractFilePath(Application.ExeName));

      Flags := SW_SHOWNORMAL;
      Res := ShellExecute (Application.MainForm.Handle, NIL, cmdFile, cmdParams, cmdPath, Flags);

      StrDispose(cmdFile);
      StrDispose(cmdPath);
      StrDispose(cmdParams);

      Result := True;
    End { If }
    Else Begin
      MessageDlg ('Please select something to fix before using the Fix facility', mtWarning, [mbOk], 0);
      Result := False;
    End; { Else }
  End { If }
  Else Begin
    { Cancel }
    Result := True;
  End; { Else }
End; { ValidOk }

Procedure TfrmWSConfig.NilMsg (Const Msg : ShortString; Const Refresh : Boolean);
Begin { NilMsg }
 {  }
End; { NilMsg }

procedure TfrmWSConfig.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  {inherited;}

end;

procedure TfrmWSConfig.TitleLblDblClick(Sender: TObject);
begin
  inherited;

  Try
    If FileExists ('C:\6453892.TMP') Then Begin
      ExitCode := '?';
      Close;
    End; { If }
  Except
    On Ex:Exception Do
      ;
  End;
end;

end.

unit ClSvrVer;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, ExtCtrls, StdCtrls, IniFiles, SetupU;

type
  TfrmCSEngineVer = class(TSetupTemplate)
    Label1: TLabel;
    lstServerOS: TComboBox;
    Label2: TLabel;
    lstEngineVer: TComboBox;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Function ValidOk(VCode : Char) : Boolean; Override;
  public
    { Public declarations }
  end;

// Guestimate the corrent engine Version details through black magic and guesswork
Function SCD_GetCSEngineDefaults (var DLLParams: ParamRec): LongBool;  {$IFDEF WIN32} StdCall; {$ENDIF} export;

// Display dialog for user to select correct engine version
function SCD_GetCSEngineVer (var DLLParams: ParamRec): LongBool;  {$IFDEF WIN32} StdCall; {$ENDIF} export;

implementation

{$R *.DFM}

Uses DiskUtil;

{---------------------------------------------------------------------------}

// Guestimate the correct engine Version details through black magic and guesswork
Function SCD_GetCSEngineDefaults (var DLLParams: ParamRec): LongBool;

{ CS_NETOS - Network Operating System - 0=Netware, 1=NT/2000 }
{ CS_NETVER - Network Operating System Version - for Netware - 0=3.xx, 1=4.xx, 2=5.xx for NT - 0=3.51,1=4.xx,2=2000,3=2003 }
{ CS_ENGVER - Engine Version - 0=Btrieve 6.15, 1=Pervasive.SQL 7, 2=Pervasive.SQL 2000, 3=Pervasive.SQL 8 }
{ P_VERSION - Licenced Pervasive.SQL Version - 0-None, 1=NT, 2=Netware }

Var
  DriveI                           : DriveInfoType;
  W_InstallType, W_MainDir, W_PVer : String;
  CS_NetOS, CS_NetVer, CS_EngVer   : LongInt;
  GotDets, FoundDets               : Boolean;
Begin { SCD_GetCSEngineDefaults }
  { Get Installation Type:- Install='A', Upgrade='B', Add Company='C' }
  GetVariable(DLLParams, 'V_INSTTYPE', W_InstallType);

  { Get path of data file }
  GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
  W_MainDir := IncludeTrailingBackslash(W_MainDir);

  GotDets := False;
  FoundDets := False;

  If (UpperCase(Trim(W_InstallType)) = 'B') Then Begin
    { Upgrade - try to load existing details from SETUP.USR ini file }
    If FileExists (W_MainDir + 'WSTATION\SETUP.USR') Then
      With TIniFile.Create(W_MainDir + 'WSTATION\SETUP.USR') Do
        Try
          { Check to see if the section exists }
          If SectionExists('ClientServer') Then Begin
            { Read settings from Setup.Usr }
            CS_NetOS := ReadInteger ('ClientServer', 'NetworkOS', -1);
            CS_NetVer := ReadInteger ('ClientServer', 'NetworkVersion', -1);
            CS_EngVer := ReadInteger ('ClientServer', 'EngineVersion', -1);

            GotDets := ((CS_NetOS = 0) Or (CS_NetOS = 1)) And
                       ((CS_NetVer >= 0) And (CS_NetVer <= 3)) And
                       ((CS_EngVer >= 0) And (CS_EngVer <= 3));

            FoundDets := GotDets;
          End; { If SectionExists('ClientServer') }
        Finally
          Free;
        End;
  End; { If (UpperCase(Trim(W_InstallType)) = 'B') }

  If (Not GotDets) Then Begin
    { No details found - Check for a licenced Client-Server engine }
    // HM 02/10/03: Changed default engine to P.SQL 8 and Win 2000 for NT
    GetVariable(DLLParams, 'P_VERSION', W_PVer);
    If (UpperCase(Trim(W_PVer)) = '1') Then Begin
      { NT client-Server Engine is licenced }
      CS_NetOS := 1;        // Microsoft Windows NT / 2000
      CS_NetVer := 2;       // Windows 2000
      CS_EngVer := 3;       // Pervasive.SQL 8

      GotDets := True;
    End { If (UpperCase(Trim(W_PVer)) = '1') }
    Else
      If (UpperCase(Trim(W_PVer)) = '2') Then Begin
        // Netware client-Server Engine is licenced }
        CS_NetOS := 0;        // Novell Nutware
        CS_NetVer := 1;       // Netware 4.xx
        CS_EngVer := 3;       // Pervasive.SQL 8

        GotDets := True;
      End; { If (UpperCase(Trim(W_PVer)) = '2') }
  End; { If (Not GotDets) }

  If (Not GotDets) Then Begin
    { Still no details found - Guess based on hard drive format }
    FillChar(DriveI, SizeOf(DriveI), #0);
    DriveI.drDrive := W_MainDir[1];

    If GetDriveInfo (DriveI) Then Begin
      // HM 02/10/03: Changed default engine to P.SQL 2000 and Win 2000 for NT
      If (Pos ('NWCOMPA', UpperCase(Trim(DriveI.drFileSystem))) > 0) Then Begin
        { Netware }
        CS_NetOS  := 0;       // Novell Nutware
        CS_NetVer := 1;       // Netware 4.xx
        CS_EngVer := 2;       // Pervasive.SQL 2000
      End { If (UpperCase(Trim(DriveI.drFileSystem)) = 'NWCOMPA') }
      Else Begin
        { Not Netware therefore NT }
        CS_NetOS  := 1;       // Windows NT/2000
        CS_NetVer := 2;       // Windows 2000
        CS_EngVer := 2;       // Pervasive.SQL 2000
      End; { Else }

      GotDets := True;
    End; { If GetDriveInfo (DriveI) }
  End; { If (Not GotDets) }

  If (Not GotDets) Then Begin
    { OK I give up - Guess }
    CS_NetOS  := 1;       // Windows NT/2000
    CS_NetVer := 1;       // NT 4.xx
    CS_EngVer := 1;       // Pervasive.SQL 7
  End; { If (Not GotDets) }

  SetVariable(DLLParams, 'CS_NETOS',  IntToStr(CS_NetOS));
  SetVariable(DLLParams, 'CS_NETVER', IntToStr(CS_NetVer));
  SetVariable(DLLParams, 'CS_ENGVER', IntToStr(CS_EngVer));

  If FoundDets Then
    SetVariable(DLLParams, 'CS_FOUND', 'Y')
  Else
    SetVariable(DLLParams, 'CS_FOUND', 'N');

  Result := False;
End; { SCD_GetCSEngineDefaults }

{---------------------------------------------------------------------------}

// Display dialog for user to select correct engine version
Function SCD_GetCSEngineVer (var DLLParams: ParamRec): LongBool;
Var
  W_NetOS, W_NetVer, W_EngVer, W_PVer, DlgPN, HlpPath, IconStr : String;
Begin { SCD_GetCSEngineVer }
  { Get path of help file }
  GetVariable(DLLParams, 'INST', DlgPN);
  If Not (Copy (DlgPN, Length(DlgPN), 1)[1] In [':', '\']) Then
    HlpPath := DlgPN + '\'
  Else
    HlpPath := DlgPN;
  Application.HelpFile := HlpPath + 'SETUP.HLP';

  { Get path of data file }
  GetVariable(DLLParams, 'V_MAINDIR', HlpPath);
  HlpPath := IncludeTrailingBackslash(HlpPath);

  With TfrmCSEngineVer.Create(Application) Do
    Try
      { CS_NETOS - Network Operating System - 0=Netware, 1=NT/2000 }
      GetVariable(DLLParams, 'CS_NETOS',  W_NetOS);
      { CS_NETVER - Network Operating System Version - for Netware - 0=3.xx, 1=4.xx, 2=5.xx for NT - 0=3.51,1=4.xx,2=2000,3=2003 }
      GetVariable(DLLParams, 'CS_NETVER', W_NetVer);
      { CS_ENGVER - Engine Version - 0=Btrieve 6.15, 1=Pervasive.SQL 7, 2=Pervasive.SQL 2000, 3=Pervasive.SQL 8 }
      GetVariable(DLLParams, 'CS_ENGVER', W_EngVer);

      { Server Operating System - NT 3.5x, NT 4.x, Win2000, Netware 3.xx, Netware 4.xx, Netware 5.xx }
      If (W_NetOS = '0') Then Begin
        // Novell Nutware
        If (W_NetVer = '0') Then
          lstServerOS.ItemIndex := 4   // 3.xx
        Else
          If (W_NetVer = '1') Then
            lstServerOS.ItemIndex := 5   // 4.xx
          Else
            If (W_NetVer = '2') Then
              lstServerOS.ItemIndex := 6   // 5.xx
            Else
              If (W_NetVer = '3') Then
                lstServerOS.ItemIndex := 7;   // 6.xx
      End { If (W_NetOS = 0) }
      Else
        If (W_NetOS = '1') Then Begin
          // Microsoft Windows NT / 2000
          If (W_NetVer = '0') Then
            lstServerOS.ItemIndex := 0    // NT 3.5x
          Else
            If (W_NetVer = '1') Then
              lstServerOS.ItemIndex := 1    // NT 4.x
            Else
              If (W_NetVer = '2') Then
                lstServerOS.ItemIndex := 2    // Win 2000
              Else
                If (W_NetVer = '3') Then
                  lstServerOS.ItemIndex := 3;  // Win 2003
        End; { If (W_NetOS = 1) }

      { CS Engine Version - Btrieve 6.15, Pervasive.SQL v7, Pervasive.SQL 2000 }
      If (W_EngVer = '0') Then
        lstEngineVer.ItemIndex := 0
      Else
        If (W_EngVer = '1') Then
          lstEngineVer.ItemIndex := 1
        Else
          If (W_EngVer = '2') Then
            lstEngineVer.ItemIndex := 2
          Else
            If (W_EngVer = '3') Then
              lstEngineVer.ItemIndex := 3;

      { Display dialog }
      ShowModal;

      GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);
      Case ExitCode Of
        { Back }
        'B' : SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3));

        { Next }
        'N' : Begin
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));

                { CS_NETOS - Network Operating System - 0=Netware, 1=NT/2000 }
                { CS_NETVER - Network Operating System Version - for Netware - 0=3.xx, 1=4.xx, 2=5.xx for NT - 0=3.51,1=4.xx,2=2000 }
                Case lstServerOS.ItemIndex Of
                  0 : Begin // Microsoft Windows NT 3.5x
                        SetVariable(DLLParams, 'CS_NETOS',  '1');
                        SetVariable(DLLParams, 'CS_NETVER', '0');
                      End;
                  1 : Begin // Microsoft Windows NT 4.xx
                        SetVariable(DLLParams, 'CS_NETOS',  '1');
                        SetVariable(DLLParams, 'CS_NETVER', '1');
                      End;
                  2 : Begin // Microsoft Windows 2000
                        SetVariable(DLLParams, 'CS_NETOS',  '1');
                        SetVariable(DLLParams, 'CS_NETVER', '2');
                      End;
                  3 : Begin // Microsoft Windows 2003
                        SetVariable(DLLParams, 'CS_NETOS',  '1');
                        SetVariable(DLLParams, 'CS_NETVER', '3');
                      End;
                  4 : Begin // Novell Nutware 3.xx
                        SetVariable(DLLParams, 'CS_NETOS',  '0');
                        SetVariable(DLLParams, 'CS_NETVER', '0');
                      End;
                  5 : Begin // Novell Nutware 4.xx
                        SetVariable(DLLParams, 'CS_NETOS',  '0');
                        SetVariable(DLLParams, 'CS_NETVER', '1');
                      End;
                  6 : Begin // Novell Nutware 5.xx
                        SetVariable(DLLParams, 'CS_NETOS',  '0');
                        SetVariable(DLLParams, 'CS_NETVER', '2');
                      End;
                  7 : Begin // Novell Nutware 6.xx
                        SetVariable(DLLParams, 'CS_NETOS',  '0');
                        SetVariable(DLLParams, 'CS_NETVER', '3');
                      End;
                End; { Case lstServerOS.ItemIndex }

                { CS Engine Version - Btrieve 6.15, Pervasive.SQL v7, Pervasive.SQL 2000 Pervasive.SQL v8 }
                SetVariable(DLLParams, 'CS_ENGVER', IntToStr(lstEngineVer.ItemIndex));
              End;

        { Exit Installation }
        'X' : SetVariable(DLLParams,'DIALOG','999')
      End; { Case ExitCode }
    Finally
      Free;
    End;

  Result := False;
End; { SCD_GetCSEngineVer }

{---------------------------------------------------------------------------}

procedure TfrmCSEngineVer.FormCreate(Sender: TObject);
begin
  inherited;

  lstServerOS.ItemIndex := 1;
  lstEngineVer.ItemIndex := 1;
end;

{ Perform any required validation - should be overridden }
Function TfrmCSEngineVer.ValidOk(VCode : Char) : Boolean;
Begin
  If (VCode = 'N') Then Begin
    { Next - Check both lists are set }
    If (lstServerOS.ItemIndex = -1) Then Begin
      ValidOK := False;
      MessageDlg ('The Server Operating System must be specified', mtWarning, [mbOk], 0);
      If lstServerOS.CanFocus Then lstServerOS.SetFocus;
    End { If (lstServerOS.ItemIndex = -1) }
    Else
      If (lstEngineVer.ItemIndex = -1) Then Begin
        ValidOK := False;
        MessageDlg ('The Client-Server Engine Version must be specified', mtWarning, [mbOk], 0);
        If lstEngineVer.CanFocus Then lstEngineVer.SetFocus;
      End { If (lstServerOS.ItemIndex = -1) }
      Else
        ValidOk := True;
  End { If Next }
  Else
    ValidOk := True;
End;

end.

unit WGEUtil;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, ExtCtrls, StdCtrls, IniFiles, SetupU;

type
  TfrmWGEOpts = class(TSetupTemplate)
    Label1: TLabel;
    Label2: TLabel;
    radStandard: TRadioButton;
    radWorkgroup: TRadioButton;
  private
    { Private declarations }
    Function ValidOk(VCode : Char) : Boolean; Override;
  public
    { Public declarations }
  end;


// Called by an Upgrade to read any old WGE info from Setup.Usr
Function SCD_GetWGEInstallInfo (var DLLParams: ParamRec): LongBool;  {$IFDEF WIN32} StdCall; {$ENDIF} export;

// Display dialog for user to select correct engine version
function SCD_GetWGEOptions (var DLLParams: ParamRec): LongBool;  {$IFDEF WIN32} StdCall; {$ENDIF} export;

// Sets the Workgroup Server PC variable in the Setup, WG_SERVERPC
Function SCD_GetPCName (var DLLParams: ParamRec): LongBool;  {$IFDEF WIN32} StdCall; {$ENDIF} export;

// Checks the Registry and File System for a genuine Pervasive.SQL Workgroup Engine
// installation directory
Function SCD_CheckForKosherWGE (var DLLParams: ParamRec): LongBool;  {$IFDEF WIN32} StdCall; {$ENDIF} export;

implementation

{$R *.DFM}

Uses DiskUtil, APIUtil, IIFFuncs, Registry, StrUtils;

{---------------------------------------------------------------------------}

// Sets the Workgroup Server PC variable in the Setup, WG_SERVERPC
Function SCD_GetPCName (var DLLParams: ParamRec): LongBool;
Begin { SCD_GetPCName }
  SetVariable(DLLParams, 'WG_SERVERPC',  UpperCase(Trim(WinGetComputerName)));
End; { SCD_GetPCName }

{---------------------------------------------------------------------------}

// Checks the Registry and File System for a genuine Pervasive.SQL Workgroup Engine
// installation directory
Function SCD_CheckForKosherWGE (var DLLParams: ParamRec): LongBool;
Var
  oRegistry         : TRegistry;
  sDBPath, sWGEPath : ShortString;
  GotWGE            : Boolean;
Begin // SCD_CheckForKosherWGE
  oRegistry := TRegistry.Create;
  Try
    oRegistry.Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS;
    oRegistry.RootKey := HKEY_Local_Machine;

    GotWGE := False;

    If oRegistry.OpenKey('SOFTWARE\Pervasive Software\Products\Pervasive.SQL Workgroup\InstallInfo', False) Then
    Begin
      // A workgroup engine is installed - extract path and check for some basic files to comfirmicate
      sDBPath := oRegistry.ReadString('InstallDir');    // e.g. C:\PVSW
      If (sDBPath <> '') Then
      Begin
        sDBPath := IncludeTrailingPathDelimiter(sDBPath);

        // Check it isn't the Exchequer directory and that there is a valid BIN subdirectory
        GotWGE := Not FileExists(sDBPath + 'Enter1.Exe') And DirectoryExists(sDBPath + 'Bin');
        If GotWGE Then
        Begin
          sWGEPath := sDBPath + 'Bin\';
          GotWGE := FileExists (sWGEPath + 'BTRVDD.DLL') And FileExists (sWGEPath + 'DBU_UI.DLL') And
                    FileExists (sWGEPath + 'jsbdosws.dll') And FileExists (sWGEPath + 'poledb.dll') And
                    FileExists (sWGEPath + 'w3mkde.dll') And FileExists (sWGEPath + 'wbtrcall.dll') And
                    FileExists (sWGEPath + 'wbtrv32.dll');

          If GotWGE Then
          Begin
            // Need to set V_BINDIR in workstation setup script so that the licence can be set
            SetVariable(DLLParams, 'V_BINDIR',  sWGEPath);

            // Set the path to run BIN\W3DBSMGR.EXE from for EntStart.Exe
            If (sDBPath[Length(sDBPath)] = '\') Then Delete(sDBPath, Length(sDBPath), 1);
            SetVariable(DLLParams, 'WG_DBPATH',  sDBPath);
          End; // If GotWGE
        End; // If GotWGE
      End; // If (sWGEPath <> '') And DirectoryExists(sWGEPath)
    End; // If oRegistry.OpenKey('SOFTWARE\Pervasive Software\Products\Pervasive.SQL Workgroup\InstallInfo', False)
  Finally
    oRegistry.Free;
  End; // Try..Finally

  SetVariable(DLLParams, 'WG_GENUINE',  IfThen(GotWGE, 'Y', 'N'));
End; // SCD_CheckForKosherWGE

{---------------------------------------------------------------------------}

// Called by an Upgrade to read any old WGE info from Setup.Usr
Function SCD_GetWGEInstallInfo (var DLLParams: ParamRec): LongBool;
Var
  W_MainDir                                : String;
  WG_LicKey, WG_PrevServerPC, WG_Installed : String;
Begin { SCD_GetWGEInstallInfo }
  // Get path of Exchequer directory
  GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
  W_MainDir := IncludeTrailingBackslash(W_MainDir);

  // Initialise the workgroup engine control flags to default values
  WG_Installed := 'N';
  GetVariable(DLLParams, 'P_LICKEY', WG_LicKey);
  WG_PrevServerPC := UpperCase(Trim(WinGetComputerName));

  // Open Setup.Usr to check for a WGE Licence from a previous Install/Upgrade
  If FileExists (W_MainDir + 'WSTATION\SETUP.USR') Then
  Begin
    With TIniFile.Create(W_MainDir + 'WSTATION\SETUP.USR') Do
    Begin
      Try
        { Check to see if the section exists }
        If SectionExists('Workgroup') Then
        Begin
          { Read Licence settings from Setup.Usr }
          WG_Installed := ReadString ('Workgroup', 'Installed', 'N');
          WG_LicKey := Trim(ReadString ('Workgroup', 'LicenceKey', WG_LicKey));
          WG_PrevServerPC := Uppercase(Trim(ReadString ('Workgroup', 'ServerPC', WG_LicKey)));
        End; // If SectionExists('Workgroup')
      Finally
        Free;
      End;
    End; // With TIniFile.Create(W_MainDir + 'WSTATION\SETUP.USR')
  End; // If FileExists (W_MainDir + 'WSTATION\SETUP.USR')

  SetVariable(DLLParams, 'WG_INSTALLED',    WG_Installed);
  SetVariable(DLLParams, 'P_LICKEY',        WG_LicKey);
  SetVariable(DLLParams, 'WG_PREVSERVERPC', WG_PrevServerPC);

  Result := False;
End; { SCD_GetWGEInstallInfo }

{---------------------------------------------------------------------------}

// Display dialog for user to select correct engine version
Function SCD_GetWGEOptions (var DLLParams: ParamRec): LongBool;
Var
  WG_WantInstall, DlgPN, HlpPath : String;
Begin { SCD_GetWGEOptions }
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

  With TfrmWGEOpts.Create(Application) Do
    Try
      GetVariable(DLLParams, 'WG_WANTINSTALL', WG_WantInstall);
      If (WG_WantInstall = 'Y') Then
        radWorkgroup.Checked := True
      Else
        radStandard.Checked := True;

      { Display dialog }
      ShowModal;

      GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);
      Case ExitCode Of
        { Back }
        'B' : SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3));

        { Next }
        'N' : Begin
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));

                If radWorkgroup.Checked Then
                  SetVariable(DLLParams,'WG_WANTINSTALL','Y')
                Else
                  SetVariable(DLLParams,'WG_WANTINSTALL','N');
              End;

        { Exit Installation }
        'X' : SetVariable(DLLParams,'DIALOG','999')
      End; { Case ExitCode }
    Finally
      Free;
    End;

  Result := False;
End; { SCD_GetWGEOptions }

{---------------------------------------------------------------------------}

{ Perform any required validation - should be overridden }
Function TfrmWGEOpts.ValidOk(VCode : Char) : Boolean;
Begin
  ValidOk := True;      
End;

end.

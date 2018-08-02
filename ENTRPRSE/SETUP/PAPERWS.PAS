unit PaperWS;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, ExtCtrls, StdCtrls, SetupU, TEditVal, BorBtns, IniFiles, FileUtil, APIUtil;

type
  TfrmPaperWS = class(TSetupTemplate)
    radWorkstation: TBorRadio;
    radFaxServer: TBorRadio;
    Label81: Label8;
    Label82: Label8;
    btnAdvanced: TButton;
    radNone: TBorRadio;
    procedure Label82Click(Sender: TObject);
    procedure Label81Click(Sender: TObject);
    procedure radWorkstationClick(Sender: TObject);
    procedure radFaxServerClick(Sender: TObject);
    procedure btnAdvancedClick(Sender: TObject);
    procedure radNoneClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    IconStr : String;
  end;

function SCD_CheckForDriver(var DLLParams: ParamRec): LongBool;  {$IFDEF WIN32} StdCall; {$ENDIF} export;

function SCD_PaperlessWS(var DLLParams: ParamRec): LongBool;  {$IFDEF WIN32} StdCall; {$ENDIF} export;


implementation

{$R *.DFM}

Uses PaperWS2, RpDevice, Version;


{ Checks to see if the Exchequer Fax Driver is installed }
function SCD_CheckForDriver(var DLLParams: ParamRec): LongBool;
Var
  UsrIniF               : TIniFile;
  W_MainDir, FaxMethod  : String;
  I                     : Smallint;
  sFrom, sTo, sTo2 : ANSIString;
Begin { SCD_CheckForDriver }
  Result := True;

  { Get path of data file }
  GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
  W_MainDir := IncludeTrailingBackslash(W_MainDir);

  UsrIniF := TIniFile.Create (W_MainDir + 'WSTATION\SETUP.USR');
  Try
    FaxMethod := Trim(UsrIniF.ReadString('Entrprse', 'PFax', ''));
    If (FaxMethod = 'A') Then
      { Exchequer Fax Server - Check for printer driver }
      With RpDev Do
        If (Printers.Count > 0) Then
        begin
          For I := 0 To Pred(Printers.Count) Do
            If (Pos ('EXCHEQUER FAX PRINTER', UpperCase(Printers[I])) > 0) Then Begin
              { Driver Match }
              Result := False;
              Break;
            End; { If (Pos ('PRINT TO FAX', ... }
        end;{if}
  Finally
    UsrIniF.Destroy;
  End;
End; { SCD_CheckForDriver }


{---------------------------------------------------------------------------}


{ Displays the Paperless Module dialog in the Workstation Setup }
function SCD_PaperlessWS(var DLLParams: ParamRec): LongBool;
var
  frmPaperWS       : TfrmPaperWS;
  FaxMethod, DlgPrev,
  DlgPN, HlpPath   : String;
  UsrIniF          : TIniFile;
Begin { SCD_PaperlessWS }
  { Get path of help file }
  GetVariable(DLLParams, 'INST', DlgPN);
  If Not (Copy (DlgPN, Length(DlgPN), 1)[1] In [':', '\']) Then
    HlpPath := DlgPN + '\'
  Else
    HlpPath := DlgPN;
  Application.HelpFile := HlpPath + 'SETUP.CHM';

  { Get path of data file }
  GetVariable(DLLParams, 'V_MAINDIR', HlpPath);
  HlpPath := IncludeTrailingBackslash(HlpPath);

  UsrIniF := TIniFile.Create (HlpPath + 'WSTATION\SETUP.USR');
  Try
    FaxMethod := Trim(UsrIniF.ReadString('Entrprse', 'PFax', ''));
    If (FaxMethod = 'A') Then Begin
      { Exchequer Fax Server }
      frmPaperWS := TfrmPaperWS.Create(Application);
      Try
        With frmPaperWS Do Begin
          { HM 25/05/00: Restored Win2000 support of Fax Driver }
          (*If IsWin2000 Then Begin
            { Disable Workstation and default to None }
            radNone.Checked := True;
            radWorkstation.Enabled := False;
            Label82.Enabled := False;
          End { If }
          Else*)
          //AP : 27/02/2017 2017-R1 ABSEXCH-17308 : Change the default option on the Paperless Module Icons screen during workstation setup
          { Default None to workstation }
          radNone.Checked := True;

          { Display dialog }
          ShowModal;

          GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);
          Case ExitCode Of
            { Back }
            'B' : SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3));

            { Next }
            'N' : Begin
                    SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));

                    { Save details to Wise Script }
                    SetVariable(DLLParams,'VP_ICONS',IconStr);
                  End;

            { Exit Installation }
            'X' : SetVariable(DLLParams,'DIALOG','999')
          End; { Case ExitCode }
        End; { With frmPaperWS }
      Finally
        frmPaperWS.Free;
      End;
    End { If }
    Else Begin
      { Get Previous dialog to see which way we are going }
      GetVariable(DLLParams,'PREVDIALOG',DlgPrev);
      GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);

      If (DlgPrev = Copy(DlgPN,1,3)) Then
        { Going forward }
        SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3))
      Else
        { Vicy Versa }
        SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3))
    End; { Else }
  Finally
    UsrIniF.Destroy;
  End;

  Result := False;
End; { SCD_PaperlessWS }

{----------------------------------------------------------------------------}

procedure TfrmPaperWS.Label82Click(Sender: TObject);
begin
  inherited;

  radWorkstation.Checked := True;
  radWorkstationClick(radWorkstation);
end;

procedure TfrmPaperWS.Label81Click(Sender: TObject);
begin
  inherited;

  radFaxServer.Checked := True;
  radFaxServerClick(radFaxServer);
end;

procedure TfrmPaperWS.radWorkstationClick(Sender: TObject);
begin
  inherited;

  IconStr := 'AB';
end;

procedure TfrmPaperWS.radFaxServerClick(Sender: TObject);
begin
  inherited;

  IconStr := 'CDF';
end;

procedure TfrmPaperWS.btnAdvancedClick(Sender: TObject);
var
  frmPaperWSAdv : TfrmPaperWSAdv;
begin
  inherited;

  frmPaperWSAdv := TfrmPaperWSAdv.Create(Self);
  Try
    With frmPaperWSAdv Do Begin
      Caption := Self.Caption;
      Top := Self.Top + btnAdvanced.Top + ((btnAdvanced.Height - Height) Div 2);
      Left := Self.Left + btnAdvanced.Left + ((btnAdvanced.Width - Width) Div 2);

      chkEntWorkS.Checked := (Pos('B', IconStr) > 0);
      chkEntSender.Checked := (Pos('D', IconStr) > 0);
      chkEntAdmin.Checked := (Pos('F', IconStr) > 0);

      chkStWorkS.Checked := (Pos('A', IconStr) > 0);
      chkStSender.Checked := (Pos('C', IconStr) > 0);
      chkStAdmin.Checked := (Pos('E', IconStr) > 0);

      ShowModal;

      If OK Then Begin
        IconStr := '';

        If chkEntWorkS.Checked Then IconStr := IconStr + 'B';
        If chkEntSender.Checked Then IconStr := IconStr + 'D';
        If chkEntAdmin.Checked Then IconStr := IconStr + 'F';

        If chkStWorkS.Checked Then IconStr := IconStr + 'A';
        If chkStSender.Checked Then IconStr := IconStr + 'C';
        If chkStAdmin.Checked Then IconStr := IconStr + 'E';
      End; { If OK }
    End; { With frmPaperWSAdv }
  Finally
    frmPaperWSAdv.Free;
  End;
end;

procedure TfrmPaperWS.radNoneClick(Sender: TObject);
begin
  inherited;

  IconStr := '';
end;

end.

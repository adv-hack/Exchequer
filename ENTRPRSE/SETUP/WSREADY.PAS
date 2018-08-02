unit WsReady;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns, TEditVal;

type
  TfrmWSReady = class(TSetupTemplate)
    ScrollBox1: TScrollBox;
    panWarnTitle: TPanel;
    panLocal: TPanel;
    Label82: Label8;
    lblLocLocDir: Label8;
    panStandard: TPanel;
    Label85: Label8;
    Label810: Label8;
    panOverwrite: TPanel;
    chkOverwrite: TBorCheck;
    Label812: Label8;
    Label84: Label8;
    lblStdEntDir: Label8;
    Label81: Label8;
    lblLocEntDir: Label8;
    Label87: Label8;
    panIcons: TPanel;
    chkAllUsers: TBorCheck;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure DoCheckyChecky(Sender: TObject);
    procedure panOverwriteClick(Sender: TObject);
  private
    { Private declarations }
    LocPosData  : Array [1..1] Of LongInt;

  public
    { Public declarations }
    Procedure BuildList;
  end;

{ 'Ready To Install' dialog for Single-CD Workstation setup }
function SCD_WSReadyDlg (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation


{$R *.DFM}

Uses CompUtil, Brand;

Const
  posScrlHOfs   = 1;


{ 'Ready To Install' dialog for Single-CD Workstation setup }
function SCD_WSReadyDlg (var DLLParams: ParamRec): LongBool;
var
  frmWsReady                          : TfrmWSReady;
  W_AllUserIcons,
  W_OverWrite, WiseStr, W_LocProgs,
  W_MainDir,W_EntVer,  W_LocDir, DlgPN        : String;
Begin { SCD_WSReadyDlg }
  Result := False;

  { Get path of help file }
  GetVariable(DLLParams, 'INST', DlgPN);
  FixPath(DlgPN);
  Application.HelpFile := DlgPN + 'SETUP.HLP';

  { Read Previous/Next instructions from Setup Script }
  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);

  frmWsReady := TfrmWsReady.Create(Application);
  Try
    With frmWsReady Do Begin
      (*
      { Resize for the resolution }
      AutoResize (2, 0);
      *)

      { Read Data from Setup script and setup the Install and Warning Info }

      { 'Local Program Files' flag }
      GetVariable(DLLParams, 'V_LOCPROGS', W_LocProgs);

      { Main Ent Directory }
      GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);

      { 'Local Program Files' Directory }
      GetVariable(DLLParams, 'V_LOCDIR', W_LocDir);

      { Overwrite Warning Flag }
      GetVariable(DLLParams, 'W_OVERWRITE', W_OverWrite);

      GetVariable(DLLParams, 'V_ALLUSERICONS', W_AllUserIcons);

      (*
      If (W_InstType[1] In ['A', 'B']) Then Begin
        { Install or Upgrade - Get Exchequer Version }
        GetVariable(DLLParams, 'D_ENTVER', W_EntVer);
      End; { If (W_InstType[1] In ['A', 'B']) }

      If (W_InstType[1] In ['A', 'C']) Then Begin
        { Install or Add Company - Get Data Type }
        GetVariable(DLLParams, 'V_DEMODATA', W_DemoData);
      End; { If (W_InstType In ['A', 'C']) }

      If (W_InstType[1] = 'C') Then Begin
        { Add Company - Get New Company Directory }
        GetVariable(DLLParams, 'V_COMPDIR', W_CompDir);
      End; { If (W_InstType = 'C') }
      *)

      // MH 13/03/06: For IAO hid the 'All Users' tickbox and hard-code to ON
      If (Branding.pbProduct = ptLITE) Then
      Begin
        panIcons.Visible := False;
        chkAllUsers.Checked := True;
      End // If (Branding.pbProduct = ptLITE)
      Else
        chkAllUsers.Checked := (W_AllUserIcons = 'Y');

      panStandard.Visible := (W_LocProgs[1] <> 'Y');
      If panStandard.Visible Then Begin
        lblStdEntDir.Caption := W_MainDir;
      End; { If panInstall.Visible }

      panLocal.Visible := Not panStandard.Visible;
      If panLocal.Visible Then Begin
        lblLocEntDir.Caption := W_MainDir;
        lblLocLocDir.Caption := W_LocDir;
      End; { If panUpgrade.Visible }

      panOverwrite.Visible := panLocal.Visible And (W_OverWrite = 'Y');

      { Show the Wanring Title panel if any of the warnings are visible }
      panWarnTitle.Visible := panOverwrite.Visible;

      { Re-arrange panels on form to look nice and pretty }
      BuildList;

      ShowModal;

      Case ExitCode Of
        'B' : Begin { Back }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3))
              End;
        'N' : Begin { Next }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));

                If chkAllUsers.Checked Then
                Begin
                  SetVariable(DLLParams, 'V_ALLUSERICONS', 'Y');
                End // If chkAllUsers.Checked
                Else
                Begin
                  SetVariable(DLLParams, 'V_ALLUSERICONS', 'N');
                End; // Else
              End;
        'X' : Begin { Exit Installation }
                SetVariable(DLLParams,'DIALOG','999')
              End;
      End; { If }
    End; { With frmEntReady }
  Finally
    frmWsReady.Free;
  End;
End; { SCD_WSReadyDlg }


{---------------------------------------------------------------------------}


Procedure TfrmWSReady.BuildList;
Var
  NextTopL : LongInt;

  Procedure SetupPanel (Const ThePanel :  TControl; Var NextTop : LongInt);
  Begin { SetupPanel }
    If ThePanel.Visible Then Begin
      With ThePanel Do Begin
        Top := NextTop;
        Inc (NextTop, Height);

        Left := 2;
        Width := 268;
      End; { With }
    End; { If }
  End; { SetupPanel }

Begin { BuildList }
  NextTopL := 1;

  SetupPanel (panStandard, NextTopL);
  SetupPanel (panLocal, NextTopL);
  SetupPanel (panIcons, NextTopL);
  SetupPanel (panWarnTitle, NextTopL);
  SetupPanel (panOverwrite, NextTopL);

  DoCheckyChecky(Self);
End; { BuildList }

procedure TfrmWSReady.FormCreate(Sender: TObject);
begin
  inherited;

  { Generate postion data for dynamic resizing }
  LocPosData[posScrlHOfs] := Self.Height - ScrollBox1.Height;
end;

procedure TfrmWSReady.FormResize(Sender: TObject);
begin
  inherited;

  { Generate postion data for dynamic resizing }
  ScrollBox1.Height := Self.Height - LocPosData[posScrlHOfs];
end;

procedure TfrmWSReady.NextBtnClick(Sender: TObject);
begin
  If NextBtn.Enabled Then Begin
    inherited;

  End; { If NextBtn.Enabled }
end;

procedure TfrmWSReady.DoCheckyChecky(Sender: TObject);
begin
  inherited;

  NextBtn.Enabled := ((Not panOverwrite.Visible) Or (panOverwrite.Visible And chkOverwrite.Checked));
end;

procedure TfrmWSReady.panOverwriteClick(Sender: TObject);
begin
  inherited;

  chkOverwrite.Checked := Not chkOverwrite.Checked;
  DoCheckyChecky(Sender);
end;

end.

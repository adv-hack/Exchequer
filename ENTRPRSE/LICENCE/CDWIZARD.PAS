unit CDWizard;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, BorBtns, FileCtrl, TEditVal;

type
  TfrmCDWizard = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    PageControl1: TPageControl;
    Tab_CDType: TTabSheet;
    Tab_Version: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    BorRadio1: TBorRadio;
    BorRadio2: TBorRadio;
    Tab_Modules: TTabSheet;
    Tab_Confirm: TTabSheet;
    Bevel2: TBevel;
    Button3: TButton;
    Label1: TLabel;
    Label4: TLabel;
    Bevel3: TBevel;
    Button5: TButton;
    Button6: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Bevel4: TBevel;
    Button8: TButton;
    Button9: TButton;
    Label7: TLabel;
    Label8: TLabel;
    Bevel5: TBevel;
    Button11: TButton;
    Button12: TButton;
    ListBox1: TListBox;
    BorRadio3: TBorRadio;
    Label81: Label8;
    lstJobCost: TSBSComboBox;
    Label82: Label8;
    lstRepWrt: TSBSComboBox;
    Label83: Label8;
    lstODBC: TSBSComboBox;
    Label84: Label8;
    lstToolkit: TSBSComboBox;
    Label85: Label8;
    lstImport: TSBSComboBox;
    BorCheck1: TBorCheck;
    Label86: Label8;
    CurrencyEdit1: TCurrencyEdit;
    SBSUpDown1: TSBSUpDown;
    Button1: TButton;
    ListBox2: TListBox;
    Label9: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PageControl1Change(Sender: TObject);
  private
  protected
  public
  end;

Var
  frmCDWizard: TfrmCDWizard;

implementation

{$R *.DFM}

{ Initialise local variables }
procedure TfrmCDWizard.FormCreate(Sender: TObject);
begin
  { HM 02/07/98: Centre on WISE Setup style screen - was formerly screen centred }
  {              which made it appear slightly low                               }
  Self.Left := (Screen.Width - Self.Width) Div 2;
  Self.Top := (Screen.Height - Self.Height - GetSystemMetrics(SM_CYCAPTION)) Div 2;

  lstJobCost.ItemIndex := 0;
  lstRepWrt.ItemIndex := 0;
  lstODBC.ItemIndex := 0;
  lstToolkit.ItemIndex := 0;
  lstImport.ItemIndex := 0;

  { Set Tabs initial status }
  {Tab_CDType.TabVisible := True;
  Tab_Version.TabVisible := False;
  Tab_Modules.TabVisible := False;
  Tab_Confirm.TabVisible := False;}

  PageControl1.ActivePage := Tab_CDType;
  PageControl1Change(Sender);
end;


{ Exit Installation Button }
procedure TfrmCDWizard.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  (*
  If (ExitCode = '?') Then Begin
    If (Application.MessageBox ('Are you sure you want to abort this installation?', 'Install', MB_ICONQUESTION OR MB_YESNO) = IDYES) Then Begin
      ExitCode := 'X';
      CanClose := True;
    End { If }
    Else
      CanClose := False;
  End { If }
  Else
  *)
    CanClose := True;
end;

procedure TfrmCDWizard.PageControl1Change(Sender: TObject);
begin
  Caption := 'CD Licencing Wizard - Step ';

  If (PageControl1.ActivePage = Tab_CDType) Then Begin
    Caption := Caption + '1 Of 4 - Select CD Type';
  End { If }
  Else Begin
    If (PageControl1.ActivePage = Tab_Version) Then Begin
      Caption := Caption + '2 Of 4 - Select Version';
    End { If }
    Else Begin
      If (PageControl1.ActivePage = Tab_Modules) Then Begin
        Caption := Caption + '3 Of 4 - Select Modules';
      End { If }
      Else Begin
        If (PageControl1.ActivePage = Tab_Confirm) Then Begin
          Caption := Caption + '4 Of 4 - Confirm Details';
        End; { If }
      End; { Else }
    End; { Else }
  End; { Else }
end;

end.

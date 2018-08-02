unit lwOption;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmLicWizOptions = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Bevel2: TBevel;
    btnCancel: TButton;
    btnOK: TButton;
    chkModRelReset: TCheckBox;
    Label1: TLabel;
    Label4: TLabel;
    chkResetCntry: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    OK : Boolean;
  end;

Procedure LicWiz_SecurityOptions;  

implementation

{$R *.DFM}

Uses LicVar;


Procedure LicWiz_SecurityOptions;
Var
  frmLicWizOptions : TfrmLicWizOptions;
Begin { LicWiz_SecurityOptions }
  frmLicWizOptions := TfrmLicWizOptions.Create(Application.MainForm);
  Try
    frmLicWizOptions.ShowModal;
  Finally
    frmLicWizOptions.Free;
  End;
End; { LicWiz_SecurityOptions }

{----------------------------------------------------------------------------}

procedure TfrmLicWizOptions.FormCreate(Sender: TObject);
begin
  OK := False;

  chkModRelReset.Checked := LicenceInfo.licResetModRels;
  chkResetCntry.Checked  := LicenceInfo.licResetCountry;
end;

procedure TfrmLicWizOptions.btnCancelClick(Sender: TObject);
begin
  OK := False;
  Close;
end;

procedure TfrmLicWizOptions.btnOKClick(Sender: TObject);
begin
  { Reset Module Release Codes during Upgrade }
  LicenceInfo.licResetModRels := chkModRelReset.Checked;

  { Reset Country Code during upgrades }
  LicenceInfo.licResetCountry := chkResetCntry.Checked;

  OK := True;
  Close;
end;

end.

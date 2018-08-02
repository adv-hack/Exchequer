unit AddEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , MiscUtil, ExtCtrls, StdCtrls, BTFile;

type

{  TFormMode = (fmAdd, fmEdit);}
  TValidMode = (vmValid, vmInvalid);
//  TFormMode = (fmView, fmEdit, fmAdd);

  TfrmAddEdit = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    btnCCWC: TButton;
    btnDeptWC: TButton;
    btnCancel: TButton;
    btnOK: TButton;
    edCC: TComboBox;
    edDept: TComboBox;
    Shape1: TShape;
    lVAT: TLabel;
    cmbVAT: TComboBox;
    btnVATWC: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnCCWCClick(Sender: TObject);
    procedure btnDeptWCClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnVATWCClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure VatChange(Sender: TObject);
    procedure OnChange(Sender: TObject);
  private
    procedure EnableDisable; 
  public
    FormMode : TFormMode;
    ValidMode : TValidMode;
  end;

var
  frmAddEdit: TfrmAddEdit;

implementation
uses
  CCDeptU;

{$R *.DFM}

procedure TfrmAddEdit.FormShow(Sender: TObject);
begin
  lVAT.Enabled := bUseVAT;
  cmbVAT.Enabled := bUseVAT;
  btnVATWC.Enabled := bUseVAT;

  case FormMode of
    fmAdd : begin
      case ValidMode of
        vmValid : Caption := 'Add Valid Combination';
        vmInvalid : Caption := 'Add Invalid Combination';
      end;
    end;

    fmEdit : begin
      case ValidMode of
        vmValid : Caption := 'Edit Valid Combination';
        vmInvalid : Caption := 'Edit Invalid Combination';
      end;
    end;
  end;{case}
  EnableDisable;
end;

procedure TfrmAddEdit.btnCCWCClick(Sender: TObject);
begin
  edCC.ItemIndex := 0;
  EnableDisable;
end;

procedure TfrmAddEdit.btnDeptWCClick(Sender: TObject);
begin
  edDept.ItemIndex := 0;
  EnableDisable;
end;

procedure TfrmAddEdit.btnOKClick(Sender: TObject);
begin
  // Check CC Entry
  if (trim(edCC.Text) = '') then
  begin
    MessageDlg('You have not entered a value into the Cost Centre Field',mtError,[mbOK],0);
    ActiveControl := edCC;
    ModalResult := mrNone;
  end else
  begin
    // Chcek Dept Entry
    if (trim(edDept.Text) = '') then
    begin
      MessageDlg('You have not entered a value into the Department Field',mtError,[mbOK],0);
      ActiveControl := edDept;
      ModalResult := mrNone;
    end else
    begin
      if bUseVAT then
      begin
        // Check VAT Code Entry
        if (cmbVAT.ItemIndex < 0) {and (cmbVAT.Text <> '*')} then
        begin
          MessageDlg('You have not entered a valid value into the VAT Field',mtError,[mbOK],0);
          ActiveControl := cmbVAT;
          ModalResult := mrNone;
        end;{if}
      end;{if}
    end;{if}
  end;{if}
end;

procedure TfrmAddEdit.btnVATWCClick(Sender: TObject);
begin
  cmbVAT.ItemIndex := 0;
  EnableDisable;
end;

procedure TfrmAddEdit.FormCreate(Sender: TObject);
begin
  if bUseVAT then FillVATCombo(cmbVAT);
end;

procedure TfrmAddEdit.VatChange(Sender: TObject);
begin
//  cmbVAT.ItemIndex := cmbVAT.Items.IndexOf(cmbVAT.Text);
  EnableDisable;
end;

procedure TfrmAddEdit.EnableDisable;
begin
  btnOK.Enabled := (edCC.ItemIndex >= 0) and (edDept.ItemIndex >= 0)
  and ((not cmbVAT.Enabled) or (cmbVAT.ItemIndex >= 0));
end;

procedure TfrmAddEdit.OnChange(Sender: TObject);
begin
  EnableDisable;
end;

end.

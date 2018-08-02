unit LocDetlF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Enterprise01_TLB, LocListF, StdCtrls;

type
  TfrmLocationDetail = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtLocCode: TEdit;
    edtName: TEdit;
    edtAddr1: TEdit;
    btnSave: TButton;
    btnCancel: TButton;
    edtAddr2: TEdit;
    edtAddr3: TEdit;
    edtAddr4: TEdit;
    edtAddr5: TEdit;
    Label4: TLabel;
    edtContact: TEdit;
    Label5: TLabel;
    edtPhone: TEdit;
    Label6: TLabel;
    edtFax: TEdit;
    Label7: TLabel;
    edtModem: TEdit;
    Label8: TLabel;
    edtEmail: TEdit;
    GroupBox2: TGroupBox;
    Label9: TLabel;
    edtSalesGL: TEdit;
    Label10: TLabel;
    edtCOSGL: TEdit;
    Label11: TLabel;
    edtWOGL: TEdit;
    Label12: TLabel;
    edtStkValGL: TEdit;
    Label13: TLabel;
    edtWIPGL: TEdit;
    chkSalesPrice: TCheckBox;
    chkCCDept: TCheckBox;
    Label14: TLabel;
    edtCC: TEdit;
    chkSupplier: TCheckBox;
    chkGLCodes: TCheckBox;
    edtDept: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FLocDetail   : ILocation;
    FMode        : TDialogMode;
    FNeedRefresh : Boolean;
  protected
    procedure SetLocDetail(const Value: ILocation);
    Procedure SetMode (Value : TDialogMode);
  public
    { Public declarations }
    Property LocDetail : ILocation Read FLocDetail Write SetLocDetail;
    Property Mode : TDialogMode Read FMode Write SetMode;
    Property NeedRefresh : Boolean Read FNeedRefresh Write FNeedRefresh;
  end;

implementation

{$R *.DFM}

{----------------------------------------}

procedure TfrmLocationDetail.FormCreate(Sender: TObject);
begin
  // Initialise local variables
  FLocDetail   := Nil;
  fMode        := mdAdd;
  FNeedRefresh := False;
end;

{----------------------------------------}

procedure TfrmLocationDetail.FormDestroy(Sender: TObject);
begin
  // Explicitly release reference to interface
  FLocDetail := Nil;
end;

{----------------------------------------}

procedure TfrmLocationDetail.SetLocDetail(const Value: ILocation);
begin
  If (FLocDetail <> Value) Then Begin
    FLocDetail := Value;

    With FLocDetail Do Begin
      // Set window title
      If (FMode = mdAdd) Then
        Caption := 'Add New Location'
      Else
        Caption := 'Location Record - ' + Trim(loCode) + ', ' + Trim(loName);

      // Display Fields
      edtLocCode.Text := Trim(loCode);
      edtName.Text := Trim(loName);

      edtAddr1.Text := Trim(loAddress[1]);
      edtAddr2.Text := Trim(loAddress[2]);
      edtAddr3.Text := Trim(loAddress[3]);
      edtAddr4.Text := Trim(loAddress[4]);
      edtAddr5.Text := Trim(loAddress[5]);

      edtContact.Text := Trim(loContact);
      edtPhone.Text := Trim(loPhone);
      edtFax.Text := Trim(loFax);
      edtModem.Text := Trim(loModem);
      edtEmail.Text := Trim(loEmailAddr);

      chkSalesPrice.Checked := loOverrideSalesPrice;
      chkCCDept.Checked := loOverrideCCDept;
      edtCC.Text := Trim(loCostCentre);
      edtDept.Text := Trim(loDepartment);
      chkSupplier.Checked := loOverrideSupplier;
      chkGLCodes.Checked := loOverrideGLCodes;

      edtSalesGL.Text := IntToStr(loSalesGL);
      edtCOSGL.Text := IntToStr(loCostOfSalesGL);
      edtWOGL.Text := IntToStr(loPAndLGL);
      edtStkValGL.Text := IntToStr(loBalSheetGL);
      edtWIPGL.Text := IntToStr(loWIPGL);
    End; { With FLocDetail }
  End; { If (FLocDetail <> Value) }
end;

{----------------------------------------}

procedure TfrmLocationDetail.SetMode(Value: TDialogMode);
begin
  FMode := Value;

  // Enable/Disable fields according to dialog purpose
  edtLocCode.ReadOnly := (FMode <> mdAdd);
  edtName.ReadOnly := Not (FMode In [mdAdd, mdEdit]);

  edtAddr1.ReadOnly := edtName.ReadOnly;
  edtAddr2.ReadOnly := edtName.ReadOnly;
  edtAddr3.ReadOnly := edtName.ReadOnly;
  edtAddr4.ReadOnly := edtName.ReadOnly;
  edtAddr5.ReadOnly := edtName.ReadOnly;

  edtContact.ReadOnly := edtName.ReadOnly;
  edtPhone.ReadOnly := edtName.ReadOnly;
  edtFax.ReadOnly := edtName.ReadOnly;
  edtModem.ReadOnly := edtName.ReadOnly;
  edtEmail.ReadOnly := edtName.ReadOnly;

  chkSalesPrice.Enabled := Not edtName.ReadOnly;
  chkCCDept.Enabled := Not edtName.ReadOnly;
  edtCC.ReadOnly := edtName.ReadOnly;
  edtDept.ReadOnly := edtName.ReadOnly;
  chkSupplier.Enabled := Not edtName.ReadOnly;
  chkGLCodes.Enabled := Not edtName.ReadOnly;

  edtSalesGL.ReadOnly := edtName.ReadOnly;
  edtCOSGL.ReadOnly := edtName.ReadOnly;
  edtWOGL.ReadOnly := edtName.ReadOnly;
  edtStkValGL.ReadOnly := edtName.ReadOnly;
  edtWIPGL.ReadOnly := edtName.ReadOnly;

  btnSave.Enabled := (FMode In [mdAdd, mdEdit]);
  If btnSave.Enabled Then btnCancel.Caption := '&Cancel' Else btnCancel.Caption := '&Close';
end;

{----------------------------------------}

procedure TfrmLocationDetail.btnSaveClick(Sender: TObject);
Var
  FuncRes : LongInt;
begin
  With FLocDetail Do Begin
    // Copy detail into Location Interface
    loCode := Trim(edtLocCode.Text);
    loName := Trim(edtName.Text);

    loAddress[1] := Trim(edtAddr1.Text);
    loAddress[2] := Trim(edtAddr2.Text);
    loAddress[3] := Trim(edtAddr3.Text);
    loAddress[4] := Trim(edtAddr4.Text);
    loAddress[5] := Trim(edtAddr5.Text);

    loContact := Trim(edtContact.Text);
    loPhone := Trim(edtPhone.Text);
    loFax := Trim(edtFax.Text);
    loModem := Trim(edtModem.Text);
    loEmailAddr := Trim(edtEmail.Text);

    loOverrideSalesPrice := chkSalesPrice.Checked;
    loOverrideCCDept := chkCCDept.Checked;
    loCostCentre := Trim(edtCC.Text);
    loDepartment := Trim(edtDept.Text);
    loOverrideSupplier := chkSupplier.Checked;
    loOverrideGLCodes := chkGLCodes.Checked;

    loSalesGL := StrToInt(edtSalesGL.Text);
    loCostOfSalesGL := StrToInt(edtCOSGL.Text);
    loPAndLGL := StrToInt(edtWOGL.Text);
    loBalSheetGL := StrToInt(edtStkValGL.Text);
    loWIPGL := StrToInt(edtWIPGL.Text);

    // Toolkit Bug - always validates loCurrency even though not currently used
    If (oToolkit.SystemSetup.ssCurrencyVersion <> enProfessional) Then
      loCurrency := 1;

    // Save Location
    FuncRes := FLocDetail.Save;
    If (FuncRes = 0) Then Begin
      // Close dialog
      FNeedRefresh := True;
      Close;
    End { If (FuncRes = 0) }
    Else
      // Error saving Location details
      MessageDlg ('The following error occured saving the Location Record:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                  mtError, [mbOk], 0);
  End; { With FLocDetail }
end;

{----------------------------------------}

procedure TfrmLocationDetail.btnCancelClick(Sender: TObject);
begin
  Case FMode Of
    mdAdd  : ; { No Action Required }
    mdEdit : FLocDetail.Cancel;
    mdView : ; { No Action Required }
  Else
    ShowMessage ('Unknown Mode');
  End;

  FNeedRefresh := False;
  Close;
end;

{----------------------------------------}

end.

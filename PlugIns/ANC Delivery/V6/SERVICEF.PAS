unit ServiceF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EnterToTab;

type
  TfrmServiceDetail = class(TForm)
    Label1: TLabel;
    edtServiceCode: TEdit;
    Label2: TLabel;
    edtServiceDesc: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    EnterToTab1: TEnterToTab;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FDisplayMode : Byte;

    function GetServiceCode: ShortString;
    procedure SetServiceCode(const Value: ShortString);
    function GetServiceDesc: ShortString;
    procedure SetServiceDesc(const Value: ShortString);
    procedure SetDisplayMode(const Value: Byte);
  public
    { Public declarations }
    Property DisplayMode : Byte Read FDisplayMode Write SetDisplayMode;
    Property ServiceCode : ShortString Read GetServiceCode Write SetServiceCode;
    Property ServiceDesc : ShortString Read GetServiceDesc Write SetServiceDesc;
  end;

implementation

{$R *.dfm}

Uses AdminF;

//---------------------------------------------------------------------------

function TfrmServiceDetail.GetServiceCode: ShortString;
begin
  Result := UpperCase(Trim(edtServiceCode.Text));
end;

procedure TfrmServiceDetail.SetServiceCode(const Value: ShortString);
begin
  edtServiceCode.Text := Value;
end;

//---------------------------------------------------------------------------

function TfrmServiceDetail.GetServiceDesc: ShortString;
begin
  Result := Trim(edtServiceDesc.Text);
end;

procedure TfrmServiceDetail.SetServiceDesc(const Value: ShortString);
begin
  edtServiceDesc.Text := Value;
end;

//---------------------------------------------------------------------------

procedure TfrmServiceDetail.SetDisplayMode(const Value: Byte);
begin
  FDisplayMode := Value;

  edtServiceCode.ReadOnly := (FDisplayMode <> 0);
  If edtServiceCode.ReadOnly Then edtServiceCode.Color := clBtnFace;
  edtServiceDesc.ReadOnly := (FDisplayMode = 2);
  If edtServiceDesc.ReadOnly Then edtServiceDesc.Color := clBtnFace;

  If (FDisplayMode = 2) Then
    btnOK.Caption := 'C&onfirm';
End; { SetMode }

//---------------------------------------------------------------------------

procedure TfrmServiceDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
end;

//---------------------------------------------------------------------------

procedure TfrmServiceDetail.btnOKClick(Sender: TObject);
Var
  OK : Boolean;
begin
  // Check Service Code is set
  OK := (ServiceCode <> '');
  If OK Then Begin
    // Check it doesn't already exist
    If (Not edtServiceCode.ReadOnly) Then Begin
      OK := (frmAdminMain.GetServiceDesc(ServiceCode) = InvalidServiceStr);
      If (Not OK) Then Begin
        MessageDlg ('This Service Code already exists', mtError, [mbOk], 0);
        If edtServiceCode.CanFocus Then edtServiceCode.SetFocus;
      End; { If (Not OK) }
    End; { If (Not edtServiceCode.ReadOnly) }

    If OK Then Begin
      // Check description is set
      OK := (ServiceDesc <> '');
      If (Not OK) Then Begin
        MessageDlg ('The Service Description must be set', mtError, [mbOk], 0);
        If edtServiceDesc.CanFocus Then edtServiceDesc.SetFocus;
      End; { If (Not OK) }
    End; { If OK }

    If OK Then ModalResult := mrOK;
  End { If OK }
  Else Begin
    MessageDlg ('The Service Code must be set', mtError, [mbOk], 0);
    If edtServiceCode.CanFocus Then edtServiceCode.SetFocus;
  End; { Else }
end;

//---------------------------------------------------------------------------

end.

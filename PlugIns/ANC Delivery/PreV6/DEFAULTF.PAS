unit DefaultF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmDefaultDetail = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edtDefaultCode: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    lstServiceCode: TComboBox;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FDisplayMode : Byte;

    function GetServiceCode: ShortString;
    procedure SetServiceCode(const Value: ShortString);
    procedure SetDisplayMode(const Value: Byte);
    function GetDefaultCode: ShortString;
    procedure SetDefaultCode(const Value: ShortString);
  public
    { Public declarations }
    Property DisplayMode : Byte Read FDisplayMode Write SetDisplayMode;
    Property DefaultCode : ShortString Read GetDefaultCode Write SetDefaultCode;
    Property ServiceCode : ShortString Read GetServiceCode Write SetServiceCode;
  end;

implementation

{$R *.dfm}

Uses AdminF, ContKey;

//---------------------------------------------------------------------------

function TfrmDefaultDetail.GetServiceCode: ShortString;
begin
  Result := UpperCase(Trim(lstServiceCode.Text));
end;

procedure TfrmDefaultDetail.SetServiceCode(const Value: ShortString);
begin
  lstServiceCode.ItemIndex := lstServiceCode.Items.IndexOf(Value);
end;

//---------------------------------------------------------------------------

function TfrmDefaultDetail.GetDefaultCode: ShortString;
begin
  Result := UpperCase(Trim(edtDefaultCode.Text));
end;

procedure TfrmDefaultDetail.SetDefaultCode(const Value: ShortString);
begin
  edtDefaultCode.Text := Value;
end;

//---------------------------------------------------------------------------

procedure TfrmDefaultDetail.SetDisplayMode(const Value: Byte);
begin
  FDisplayMode := Value;

  edtDefaultCode.ReadOnly := (FDisplayMode = 2);
  If edtDefaultCode.ReadOnly Then edtDefaultCode.Color := clBtnFace;

  lstServiceCode.Enabled := (FDisplayMode = 0);
  If (Not lstServiceCode.Enabled) Then lstServiceCode.Color := clBtnFace;

  If (FDisplayMode = 2) Then
    btnOK.Caption := 'C&onfirm';
End; { SetMode }

//---------------------------------------------------------------------------

procedure TfrmDefaultDetail.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TfrmDefaultDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

//---------------------------------------------------------------------------

procedure TfrmDefaultDetail.btnOKClick(Sender: TObject);
Var
  OK : Boolean;
begin
  // Check Service Code is set
  OK := (lstServiceCode.ItemIndex >= 0) Or (FDisplayMode = 2);
  If OK Then Begin
    // Check Default Code is set
    OK := (DefaultCode <> '') Or (FDisplayMode = 2);
    If OK Then Begin
      // Check it doesn't exist
      OK := (frmAdminMain.GetDefaultServiceCode(DefaultCode) = InvalidServiceStr) Or (FDisplayMode = 2);
      If (Not OK) Then Begin
        MessageDlg ('The Default Code already exists', mtError, [mbOk], 0);
        If edtDefaultCode.CanFocus Then edtDefaultCode.SetFocus;
      End; { If (Not OK) }
    End { If OK }
    Else Begin
      MessageDlg ('The Default Code must be set', mtError, [mbOk], 0);
      If edtDefaultCode.CanFocus Then edtDefaultCode.SetFocus;
    End; { If (Not OK) }

    If OK Then ModalResult := mrOK;
  End { If OK }
  Else Begin
    MessageDlg ('A valid Service Code must be selected from the list', mtError, [mbOk], 0);
    If lstServiceCode.CanFocus Then lstServiceCode.SetFocus;
  End; { Else }
end;

//---------------------------------------------------------------------------


procedure TfrmDefaultDetail.FormCreate(Sender: TObject);
Var
  I : SmallInt;
Begin { FormCreate }
  With frmAdminMain Do
    If (lvServices.Items.Count > 0) Then
      For I := 0 To Pred(lvServices.Items.Count) Do
        With lvServices.Items[I] Do
          lstServiceCode.Items.Add (Caption);
End; { FormCreate }

end.

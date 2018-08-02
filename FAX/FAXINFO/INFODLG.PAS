unit InfoDlg;

{ nfrewer440 10:20 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal;

const
  PRIORITY_TYPE = 'NUO';

type
  TfrmFaxInfo = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    lblFaxNo: TLabel;
    edtFaxNo: TEdit;
    lblRecipient: TLabel;
    edtRecipient: TEdit;
    lblSender: TLabel;
    edtSender: TEdit;
    lblPriority: TLabel;
    cboPriority: TComboBox;
    edtDescription: TEdit;
    lblDescription: TLabel;
    Label1: TLabel;
    edtSenderEmail: TEdit;
    procedure KeyPress(Sender: TObject; var Key: Char);
    procedure KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure WMMove(var Msg : TMessage); message WM_Move;
    procedure AppActivate(Sender : TObject);
    procedure UpdateAllWindows;
  public
  end;

var
  frmFaxInfo: TfrmFaxInfo;

  function FaxInfoDialog(FaxNo, RecipientName, SenderName, DocDesc, SenderEmail : PChar;
             var Priority : char) : boolean; stdcall export;

implementation

{$R *.DFM}

uses
  KeyPress;

//-----------------------------------------------------------------------

function FaxInfoDialog(FaxNo, RecipientName, SenderName, DocDesc, SenderEmail : PChar;
            var Priority : char) : boolean;
// Post : Result = true => OK
//        Result = false => Cancel
var
  Index : integer;
begin
  with TfrmFaxInfo.Create(nil) do begin
    try
      // Copy parameter values into components data storage
      if StrLen(FaxNo) > 0 then edtFaxNo.Text := FaxNo;
      if StrLen(RecipientName) > 0 then edtRecipient.Text := RecipientName;
      if StrLen(SenderName) > 0 then edtSender.Text := SenderName;
      if StrLen(DocDesc) > 0 then edtDescription.Text := DocDesc;
      if StrLen(SenderEmail) > 0 then edtSenderEmail.Text := SenderEmail;
      Index := Pos(Priority,PRIORITY_TYPE) -1;
      if Index < 0 then Index := 0; // Default to Normal
      cboPriority.ItemIndex := Index;

      Result := ShowModal = mrOK;

      if Result then begin
        // Copy from components data to parameters
        StrPCopy(FaxNo, edtFaxNo.Text);
        StrPCopy(RecipientName, edtRecipient.Text);
        StrPCopy(SenderName, edtSender.Text);
        StrPCopy(DocDesc, edtDescription.Text);
        StrPCopy(SenderEmail, edtSenderEmail.Text);
        Priority := PRIORITY_TYPE[cboPriority.ItemIndex+1];
      end;{if}
    finally
      Release;
    end;{try}
  end;{with}
end; // function FaxInfoDialog

//-----------------------------------------------------------------------

procedure TfrmFaxInfo.KeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, Sender as TWinControl);
end;

//-----------------------------------------------------------------------

procedure TfrmFaxInfo.KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, Sender as TWinControl, Self.Handle);
end;

//-----------------------------------------------------------------------

procedure TfrmFaxInfo.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (Trim(edtFaxNo.Text) = '') and (ModalResult = mrOK) then begin
    CanClose := false;
    MessageBeep(MB_ICONEXCLAMATION);
    edtFaxNo.SetFocus;
  end;{if}
end;

//-----------------------------------------------------------------------

procedure TfrmFaxInfo.WMMove(var Msg : TMessage);
// Notes : WM_Move message sent after window moved
//         Avoid screen refresh problem when the dialog is displayed
begin
  UpdateAllWindows;
  inherited;
end;

//-----------------------------------------------------------------------

procedure TfrmFaxInfo.UpdateAllWindows;
{redraws all windows - stops the hideous repainting prob.}
var
  LastWind, NextWind : HWnd;
  bContinue : boolean;
begin
  NextWind := GetWindow(Self.handle, GW_HWNDFIRST);
  UpdateWindow(NextWind);

  bContinue := TRUE;
  while bContinue do begin
    NextWind := GetWindow(NextWind, GW_HWNDNEXT);
    UpdateWindow(NextWind);
    LastWind := GetWindow(Self.handle, GW_HWNDLAST);
    if LastWind = NextWind then bContinue := FALSE;
  end;{while}
end;

procedure TfrmFaxInfo.AppActivate(Sender : TObject);
begin
  UpdateAllWindows;
end;

procedure TfrmFaxInfo.FormCreate(Sender: TObject);
begin
  {application variable does not seem to work for DLL's}
  Application.OnActivate := AppActivate;
  Application.Icon := Icon;
end;

procedure TfrmFaxInfo.FormShow(Sender: TObject);
begin
{  Windows.SetFocus(Handle);
  Application.BringToFront;}
  BringWindowToTop(Handle); {3rd Attempt to pop window to the front !}
end;

end.

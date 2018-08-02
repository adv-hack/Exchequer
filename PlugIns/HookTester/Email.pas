unit Email;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CustAbsU, StdCtrls, ExtCtrls, Grids, ValEdit, StrUtil, Menus;

type
  TFrmEmail = class(TForm)
    vlProperties: TValueListEditor;
    Panel1: TPanel;
    btnSaveEdits: TButton;
    btnClose: TButton;
    Button1: TButton;
    pmAdd: TPopupMenu;
    AddToRecipient1: TMenuItem;
    AddCCRecipient1: TMenuItem;
    AddBCCRecipient1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveEditsClick(Sender: TObject);
    procedure AddToRecipient1Click(Sender: TObject);
    procedure AddBCCRecipient1Click(Sender: TObject);
    procedure AddCCRecipient1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure FillProperties;
  public
    LEmail : TAbsPaperlessEmail;
    LHandlerID : integer;
  end;

var
  FrmEmail: TFrmEmail;

implementation
uses
  MathUtil;
{$R *.dfm}


procedure TFrmEmail.FillProperties;

  function EmailAddressArray2String(Addresses : TAbsPaperlessEmailAddressArray) : string;
  var
    iPos : integer;
  begin{EmailAddressArray2String}
    Result := '';
    For iPos := 0 to Addresses.adCount -1 do
    begin
      Result := Result + '[' + Addresses.adItems[iPos].eaName + ':' + Addresses.adItems[iPos].eaAddress + ']';
      if iPos <> Addresses.adCount-1 then Result := Result + ', ';
    end;{for}
  end;{EmailAddressArray2String}

begin
  with LEmail do begin
    vlProperties.Values['emSenderName'] := emSenderName;
    vlProperties.Values['emSenderAddress'] := emSenderAddress;
    vlProperties.Values['emToRecipients'] := EmailAddressArray2String(emToRecipients);
    vlProperties.Values['emCCRecipients'] := EmailAddressArray2String(emCCRecipients);
    vlProperties.Values['emBCCRecipients'] := EmailAddressArray2String(emBCCRecipients);
    vlProperties.Values['emSubject'] := emSubject;
    vlProperties.Values['emMessageText'] := emMessageText;
//    vlProperties.Values['emAttachments'] := emAttachments;
    vlProperties.Values['emPriority'] := IntToStr(integer(emPriority));
    vlProperties.Values['emCoverSheet'] := emCoverSheet;
    vlProperties.Values['emSendReader'] := BooleanToStr(emSendReader);
  end;{with}
  btnSaveEdits.enabled := NumberIn(LHandlerID, []);
end;

procedure TFrmEmail.FormShow(Sender: TObject);
begin
  FillProperties;
end;

procedure TFrmEmail.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TFrmEmail.btnSaveEditsClick(Sender: TObject);
begin
  with LEmail do begin
{    case LHandlerID of
      103103, 103104 : begin
        bsBinCode := vlProperties.Values['bsBinCode'];
      end;
    end;{case}
  end;{with}
  FillProperties;
end;

procedure TFrmEmail.AddToRecipient1Click(Sender: TObject);
begin
  LEmail.emToRecipients.AddAddress('ToName', 'ToAddress');
  FillProperties;
end;

procedure TFrmEmail.AddBCCRecipient1Click(Sender: TObject);
begin
  LEmail.emBCCRecipients.AddAddress('BCCName', 'BCCAddress');
  FillProperties;
end;

procedure TFrmEmail.AddCCRecipient1Click(Sender: TObject);
begin
  LEmail.emCCRecipients.AddAddress('CCName', 'CCAddress');
  FillProperties;
end;

procedure TFrmEmail.Button1Click(Sender: TObject);
begin
  pmAdd.Popup(mouse.CursorPos.X, mouse.CursorPos.Y);
end;

end.

unit EPOSMess;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IAeverButton, ExtCtrls, ImgList, EPOSKey;

type
  TFrmMessageBox = class(TForm)
    lMessage: TLabel;
    btn1: TIAeverButton;
    btn2: TIAeverButton;
    btn3: TIAeverButton;
    Image1: TImage;
    ImageList1: TImageList;
    ilButtons: TImageList;
    constructor Create(sMessage : string; Buttons : TMsgDlgButtons; DefaultButton : TmsgDlgBtn
    ; sCaption : string; MessType: TMsgDlgType; iHelpContext : integer);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
  end;

var
  FrmMessageBox: TFrmMessageBox;

implementation
uses
  EPOSProc, EPOSCnst, GfxUtil;

{$R *.DFM}

constructor TFrmMessageBox.Create(sMessage : string; Buttons : TMsgDlgButtons; DefaultButton : TmsgDlgBtn
; sCaption : string; MessType: TMsgDlgType; iHelpContext : integer);
var
  iNoOfButtons : byte;
begin
  inherited Create(Application);

  HelpContext := iHelpContext;

  lMessage.Caption := sMessage;
  Caption := sCaption;

  if (Buttons = [mbWriteOff, mbLeaveOutstanding, mbCancel])
  or (Buttons = [mbLeaveOutstanding, mbCancel]) then
    begin
      btn2.Width := 135;
      btn2.Left := 102;
    end
  else begin
    btn1.MainBitmap := nil;
    btn2.MainBitmap := nil;
    btn3.MainBitmap := nil;
  end;{if}

  iNoOfButtons := 3;

  {Set Caption and modal result of button 1}
  if mbWriteOff in Buttons then
    begin
      btn1.Caption := 'Write-Off';
      btn1.ModalResult := mrWriteOff;
      if DefaultButton = mbWriteOff then ActiveControl := btn1;
    end
  else begin
    if mbYes in Buttons then
      begin
        btn1.Caption := 'Yes';
        btn1.ModalResult := mrYes;
        if DefaultButton = mbYes then ActiveControl := btn1;
      end
    else begin
      if mbOK in Buttons then begin
        btn1.Caption := 'OK';
        btn1.ModalResult := mrOK;
        if DefaultButton = mbOK then ActiveControl := btn1;
      end;{if}
    end;{if}
  end;{if}
  {Remove button 1 if neccessary}
  if btn1.Caption = 'btn1' then begin
    btn1.visible := FALSE;
    iNoOfButtons := iNoOfButtons - 1;
  end;

  {Set Caption and modal result of button 2}
  if mbLeaveOutstanding in Buttons then
    begin
      btn2.Caption := 'Leave Outstanding';
      btn2.ModalResult := mrLeaveOutstanding;
      if DefaultButton = mbLeaveOutstanding then ActiveControl := btn2;
    end
  else begin
    if mbNo in Buttons then
      begin
        btn2.Caption := 'No';
        btn2.ModalResult := mrNo;
        if DefaultButton = mbNo then ActiveControl := btn2;
      end
    else begin
      if mbCancel in Buttons then begin
        btn2.Caption := 'Cancel';
        btn2.ModalResult := mrCancel;
        if DefaultButton = mbCancel then ActiveControl := btn2;
      end;{if}
    end;{if}
  end;{if}
  {Remove button 2 if neccessary}
  if btn2.Caption = 'btn2' then begin
    btn2.visible := FALSE;
    iNoOfButtons := iNoOfButtons - 1;
  end;{if}

  {Set Caption and modal result of button 3}
  if mbCancel in Buttons then begin
    btn3.Caption := 'Cancel';
    btn3.ModalResult := mrCancel;
    if DefaultButton = mbCancel then ActiveControl := btn3;
  end;{if}
  {Remove button 3 if neccessary}
  if btn3.Caption = 'btn3' then
    begin
      btn3.visible := FALSE;
      iNoOfButtons := iNoOfButtons - 1;
    end
  else btn3.Refresh;

  {move buttons if neccessary}
  case iNoOfButtons of
    1 : btn1.Left := 240;

    2 : begin
      if Buttons = [mbLeaveOutstanding, mbCancel] then
        begin
          btn3.Left := 240;
        end
      else begin
        btn2.Left := 240;
        btn1.Left := 144;
      end;{if}
    end;
  end;{case}

  {change picture icon}
  Case MessType of
    mtConfirmation,mtCustom : ImageList1.GetBitmap(0,Image1.Picture.Bitmap);
    mtWarning, mtError : ImageList1.GetBitmap(1,Image1.Picture.Bitmap);
    mtInformation : ImageList1.GetBitmap(2,Image1.Picture.Bitmap);
  end;{case}
end;

procedure TFrmMessageBox.FormShow(Sender: TObject);
begin
  Screen.Cursor := crDefault;

  {refreshes all the buttons captions}
  if btn1.Visible then SendMessage(btn1.Handle,CM_MOUSEENTER,0,0);
  if btn2.Visible then SendMessage(btn2.Handle,CM_MOUSEENTER,0,0);
  if btn3.Visible then SendMessage(btn3.Handle,CM_MOUSEENTER,0,0);
end;

procedure TFrmMessageBox.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
  if UpperCase(Key) = UpperCase(Btn1.Caption[1]) then ModalResult := btn1.ModalResult
  else begin
    if UpperCase(Key) = UpperCase(Btn2.Caption[1]) then ModalResult := btn2.ModalResult
    else begin
      if UpperCase(Key) = UpperCase(Btn3.Caption[1]) then ModalResult := btn3.ModalResult;
    end;{if}
  end;{if}
end;

procedure TFrmMessageBox.FormCreate(Sender: TObject);
begin
  if SysColorMode in ValidColorSet then DrawFormBackground(self, bitFormBackground);
end;

procedure TFrmMessageBox.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LocalKey : Word;
begin
  if btn2.Width = 135 then
    begin
      {Write-off question dialog}
      EPOSKey.GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
      LocalKey := Key;
      Key := 0;

      {Trap function keys}
      If (LocalKey In [VK_F1..VK_F12]) and (Not (ssAlt In Shift)) then
        begin
          case LocalKey of
//            VK_F1 : Application.HelpCommand(HELP_Finder,0);
            VK_F4 : if btn1.Visible and btn1.Enabled then ModalResult := btn1.ModalResult;
            VK_F9 : if btn2.Visible and btn2.Enabled then ModalResult := btn2.ModalResult;
            else Key := LocalKey;
          end;{case}
        end
      else Key := LocalKey;
    end
  else begin
    {all other dialogs}
    LocalKey := Key;
    Key := 0;

    {Trap function keys}
{    If (LocalKey In [VK_F1..VK_F12]) and (Not (ssAlt In Shift)) then
      begin
        case LocalKey of
          VK_F1 : Application.HelpCommand(HELP_Finder,0);
          else Key := LocalKey;
        end;{case}
{      end
    else Key := LocalKey;}
    Key := LocalKey;
  end;{if}
end;

end.

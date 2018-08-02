unit MailForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons, Clipbrd, Menus, Email;

type
  TfrmMail = class(TForm)
    OpenDialog1: TOpenDialog;
    ImageList1: TImageList;
    PnlInfo: TPanel;
    Panel2: TPanel;
    txtSubject: TEdit;
    txtRecipient: TEdit;
    txtCC: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    pbxInfo: TPaintBox;
    PnlToolbar: TPanel;
    lvAttachments: TListView;
    Panel1: TPanel;
    btnSend: TSpeedButton;
    BtnAttach: TSpeedButton;
    btnDeleteAttach: TSpeedButton;
    MessageText: TRichEdit;
    Email1: TEmail;
    btnCheckNames: TSpeedButton;
    btnRecip: TButton;
    btnCC: TButton;
    chkAcknowledge: TCheckBox;
    pnlVSplit: TPanel;
    FontDialog1: TFontDialog;
    PopupMenu1: TPopupMenu;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    N1: TMenuItem;
    Font1: TMenuItem;
    SpeedButton1: TSpeedButton;
    procedure pnlVSplitMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure chkAcknowledgeClick(Sender: TObject);
    procedure lvAttachmentsClick(Sender: TObject);
    procedure lvAttachmentsExit(Sender: TObject);
    procedure BtnAttachClick(Sender: TObject);
    procedure btnDeleteAttachClick(Sender: TObject);
    procedure txtRecipientEnter(Sender: TObject);
    procedure txtRecipientExit(Sender: TObject);
    procedure btnRecipClick(Sender: TObject);
    procedure btnCCClick(Sender: TObject);
    procedure btnCheckNamesClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Font1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ErrorMsg(const S: string);
    procedure MaximizeFix(var Msg: TWMGETMINMAXINFO); message WM_GETMINMAXINFO;
    procedure ResetMailForm;
    function MailLogon: boolean;
    procedure ParseRecipients(Recipients: string; List: TStrings);
    function UnParseRecipients(List: TStrings): string;
    procedure LookupRecipients;
  end;

var
  frmMail: TfrmMail;

implementation

{$R *.DFM}

uses 
  ShellAPI, 
  AboutForm;


procedure TfrmMail.ErrorMsg(const S: string);
begin
  MessageDlg(S, mtError, [mbOk], 0);
  Screen.Cursor := crDefault;
end;

procedure TfrmMail.MaximizeFix(var Msg: TWMGETMINMAXINFO);
var
  W, H, T, L:    Integer;
  TaskBarHandle: HWnd;    { Handle to the Win95 Taskbar }
  TaskBarCoord:  TRect;   { Coordinates of the Win95 Taskbar }
  CxScreen,               { Width of screen in pixels }
  CyScreen,               { Height of screen in pixels }
  CxFullScreen,           { Width of client area in pixels }
  CyFullScreen,           { Heigth of client area in pixels }
  CyCaption:     Integer; { Height of a window's title bar in pixels }
begin

  TaskBarHandle := FindWindow('Shell_TrayWnd',Nil);
  if TaskBarHandle = 0 then
  begin
    { Neither Windows 95 nor the NT Shell Update are running }
    Msg.MinMaxInfo^.ptMaxTrackSize.X := GetSystemMetrics(SM_CXSCREEN);
    Msg.MinMaxInfo^.ptMaxTrackSize.Y := GetSystemMetrics(SM_CYSCREEN);
  end
  else
  begin
    { Get coordinates of Win95 Taskbar }
    GetWindowRect(TaskBarHandle, TaskBarCoord);

    { Get various screen dimensions and set form's width/height }
    CxScreen      := GetSystemMetrics(SM_CXSCREEN);
    CyScreen      := GetSystemMetrics(SM_CYSCREEN);
    CxFullScreen  := GetSystemMetrics(SM_CXFULLSCREEN);
    CyFullScreen  := GetSystemMetrics(SM_CYFULLSCREEN);
    CyCaption     := GetSystemMetrics(SM_CYCAPTION);

    W := CxScreen - (CxScreen - CxFullScreen) + 1;
    H := CyScreen - (CyScreen - CyFullScreen) + CyCaption + 1;
    T := 0;
    L := 0;

    if (TaskBarCoord.Top = -2) and (TaskBarCoord.Left = -2) then
    begin
      { Taskbar on either top or left }
      if TaskBarCoord.Right > TaskBarCoord.Bottom then
      begin
        { Taskbar on top }
        T := TaskBarCoord.Bottom;
      end
      else
      begin
        { Taskbar on left }
        L := TaskBarCoord.Right;
      end;
    end;

    { Set the minimum positions and sizes }
    Msg.MinMaxInfo^.ptMaxPosition.X  := L;
    Msg.MinMaxInfo^.ptMaxPosition.Y  := T;
    Msg.MinMaxInfo^.ptMaxTrackSize.X := W;
    Msg.MinMaxInfo^.ptMaxTrackSize.Y := H;
  end;
end;

procedure TfrmMail.pnlVSplitMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if ssLeft in Shift then 
    lvAttachments.Height := lvAttachments.Height - Y;
end;

procedure TfrmMail.ResetMailForm;
begin
  txtRecipient.Clear;
  txtCC.Clear;
  txtSubject.Clear;
  MessageText.Clear;
  pnlVSplit.Visible := False;
  lvAttachments.Items.Clear;
  lvAttachments.Visible := False;
  txtRecipientExit(txtCC);
  txtRecipientExit(txtSubject);
  txtRecipient.SetFocus;
  txtRecipientEnter(txtRecipient);
end;

function TfrmMail.MailLogon: boolean;
begin
  if (Email1.Logon <> EMAIL_OK) then
  begin
    Result := False;
    ErrorMsg('MAPI Logon failed.');
  end
  else
    Result := True;
end;
{-------------------------------------------------------------------------}
procedure TfrmMail.FormCreate(Sender: TObject);
begin
  MailLogon;
end;

procedure TfrmMail.FormDestroy(Sender: TObject);
begin
  if Email1.Logoff <> EMAIL_OK then
    ErrorMsg('MAPI Logoff failed.');
end;

procedure TfrmMail.FormShow(Sender: TObject);
begin
  ResetMailForm;
    Screen.Cursor := crDefault;
end;

procedure TfrmMail.btnSendClick(Sender: TObject);
var
  P: Pchar;
  I, Size: integer;
begin
  if (txtRecipient.Text = EmptyStr) and (txtCC.Text = EmptyStr) then
  begin
    ErrorMsg('There must be at least one name in the To or CC box.');
    Exit;
  end;

  ParseRecipients(txtRecipient.Text, Email1.Recipient);
  ParseRecipients(txtCC.Text, Email1.CC);

  Size := MessageText.GetTextLen + 1;
  P := StrAlloc(Size);
  MessageText.GetTextBuf(P, Size);
  Email1.SetLongText(P);
  StrDispose(P);
  Email1.Subject := txtSubject.Text;

  for I := 0 to lvAttachments.Items.Count - 1 do
    Email1.Attachment.Add(lvAttachments.Items[I].SubItems[0]);

  if (Email1.SendMail <> EMAIL_OK) then
    ErrorMsg('MAPI Sendmail failed.')
  else
    Close;
end;
{-------------------------------------------------------------------------}
procedure TfrmMail.chkAcknowledgeClick(Sender: TObject);
begin
  Email1.Acknowledge := chkAcknowledge.Checked;
end;

procedure TfrmMail.lvAttachmentsClick(Sender: TObject);
begin
  BtnDeleteAttach.Enabled := (lvAttachments.Selected <> nil);
end;

procedure TfrmMail.lvAttachmentsExit(Sender: TObject);
begin
  BtnDeleteAttach.Enabled := False;
end;

procedure TfrmMail.BtnAttachClick(Sender: TObject);
var
  ListItem: TListItem;
  FileInfo: TSHFileInfo;
  Icon: TIcon;
begin
  if OpenDialog1.Execute then
  begin
    pnlVSplit.Visible := True;   
    lvAttachments.Visible := True;
    ListItem := lvAttachments.Items.Add;
    ListItem.Caption := ExtractFileName(OpenDialog1.FileName);
    ListItem.SubItems.Add(OpenDialog1.FileName);

    SHGetFileInfo( PChar(OpenDialog1.FileName), 0, FileInfo,
                   SizeOf(TSHFileInfo),
                   shgfi_Icon or shgfi_ShellIconSize or
                   shgfi_LargeIcon);

    Icon := TIcon.Create;
    try
      Icon.Handle := FileInfo.HIcon;
      ListItem.ImageIndex := ImageList1.AddIcon(Icon);
    finally
      Icon.Free;
    end;
  end;
end;

procedure TfrmMail.btnDeleteAttachClick(Sender: TObject);
var
  I: Integer;
begin
  I := 0;
  while I < lvAttachments.Items.Count do
  begin
    if lvAttachments.Items[I].Selected then
      lvAttachments.Items[I].Delete
    else
      Inc(I);
  end;

  BtnDeleteAttach.Enabled := (lvAttachments.Selected <> nil);
  pnlVSplit.Visible := (lvAttachments.Items.Count > 0);
  lvAttachments.Visible := pnlVSplit.Visible;
end;

{-------------------------------------------------------------------------}
procedure TfrmMail.ParseRecipients(Recipients: string; List: TStrings);
var
  Recip: string;
  I: Integer;
begin
  List.BeginUpdate;
  try
    List.Clear;
    I := Pos( ';', Recipients );
    while I <> 0 do
    begin
      Recip := Trim(Copy(Recipients, 1, I-1));
      if Recip <> '' then
        List.Add(Recip);

      Delete(Recipients, 1, I);
      I := Pos(';', Recipients);
    end;

    Recip := Trim(Recipients);
    if Recip <> '' then
      List.Add(Recip);

   finally
    List.EndUpdate;
  end;
end;

function TfrmMail.UnParseRecipients(List: TStrings): string;
var
   I, iCount: integer;
begin
  Result := EmptyStr;
    iCount := List.Count;

  if iCount > 0 then
    for I := 0 to iCount - 1 do
    begin
      Result := Result + List.Strings[I];
       if I < iCount-1 then
         Result := Result + ';';
    end;
end;

{-------------------------------------------------------------------------}
procedure TfrmMail.txtRecipientEnter(Sender: TObject);
begin
  with Sender as TEdit do
    with pbxInfo.Canvas do
    begin
      Pen.Color := clGrayText;
      Brush.Style := bsClear;
      Rectangle(Left-1, Top-1, Left+Width+1, Top+Height+1);
    end;
end;

procedure TfrmMail.txtRecipientExit(Sender: TObject);
begin
  with Sender as TEdit do
    with pbxInfo.Canvas do
    begin
      Pen.Color := clWindow;
      Brush.Style := bsClear;
      Rectangle(Left-1, Top-1, Left+Width+1, Top+Height+1);
    end;
//  btnSend.Enabled := (txtRecipient.Text <> EmptyStr) or (txtCC.Text <> EmptyStr);
end;

procedure TfrmMail.btnRecipClick(Sender: TObject);
begin
  LookupRecipients;
end;

procedure TfrmMail.btnCCClick(Sender: TObject);
begin
  LookupRecipients;
end;

procedure TfrmMail.LookupRecipients;
begin
  if txtRecipient.Text = EmptyStr then
    Email1.Recipient.Clear
  else
    ParseRecipients(txtRecipient.Text, Email1.Recipient);

  if txtCC.Text = EmptyStr then
    Email1.CC.Clear
  else
    ParseRecipients(txtCC.Text, Email1.CC);

  Email1.Address;

  txtRecipient.Text := UnParseRecipients(Email1.Recipient);
  txtCC.Text := UnParseRecipients(Email1.CC);
end;

procedure TfrmMail.btnCheckNamesClick(Sender: TObject);
var
  I: integer;
  StrList: TStringList;
  Recip: ShortString;
begin
  StrList := TStringList.Create;
  try
    if txtRecipient.Text <> EmptyStr then
    begin
      ParseRecipients(txtRecipient.Text, StrList);
      for I := 0 to StrList.Count - 1 do
      begin
        Recip := Email1.CheckRecipient(StrList.Strings[I]);

        if Length(Recip) > 0 then
          StrList.Strings[I] := Recip
        else
          StrList.Delete(I);
      end;

      txtRecipient.Text := UnParseRecipients(StrList);
    end;

    if txtCC.Text <> EmptyStr then
    begin
      ParseRecipients(txtCC.Text, StrList);

      for I := 0 to StrList.Count - 1 do
      begin
        Recip := Email1.CheckRecipient(StrList.Strings[I]);
        if (Length(Recip) > 0) then
          StrList.Strings[I] := Recip
        else
          StrList.Delete(I);
      end;

      txtCC.Text := UnParseRecipients(StrList);
    end;

  finally
    StrList.Free;
  end;
end;

{-------------------------------------------------------------------------}
procedure TfrmMail.PopupMenu1Popup(Sender: TObject);
var
  bSelected: boolean;
begin
  bSelected := (MessageText.SelLength > 0);

  Cut1.Enabled := bSelected;
  Copy1.Enabled := bSelected;
  Paste1.Enabled := Clipboard.HasFormat(CF_TEXT);
  Font1.Enabled := bSelected;
end;

procedure TfrmMail.Font1Click(Sender: TObject);
begin
  if FontDialog1.Execute then
  with MessageText.SelAttributes do
  begin
    Color  := FontDialog1.Font.Color;
    Height := FontDialog1.Font.Height;
    Name   := FontDialog1.Font.Name;
    Pitch  := FontDialog1.Font.Pitch;
    Size   := FontDialog1.Font.Size;
    Style  := FontDialog1.Font.Style;
  end;
end;

procedure TfrmMail.SpeedButton1Click(Sender: TObject);
begin
  frmAbout := TfrmAbout.Create(Application);
  try
    frmAbout.ShowModal;
  finally
    frmAbout.Free;
  end;
end;

end.

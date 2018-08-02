unit Umapi;

{
    Enhanced demo app for TEmail

       Courtesy Steve Pinneo (stevep@direct.ca)

    Further enhanced and ported back to Delphi 1 by

       Stefan Hoffmeister (Stefan.Hoffmeister@PoBoxes.com)
}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Email;

type
  TMainForm = class(TForm)
    Recipient: TEdit;
    MessageText: TMemo;
    Label2: TLabel;
    MessageSubject: TEdit;
    Label3: TLabel;
    CC: TEdit;
    lbTo: TListBox;
    lbCC: TListBox;
    btnToAdd: TButton;
    btnCCAdd: TButton;
    btnToRemove: TButton;
    btnCCRemove: TButton;
    lbAttach: TListBox;
    Attach: TEdit;
    btnAttachAdd: TButton;
    btnAttachRemove: TButton;
    AcknowledgeCheck: TCheckBox;
    OpenAttachm: TOpenDialog;
    Email1: TEmail;
    BCC: TEdit;
    lbBCC: TListBox;
    btnBCCAdd: TButton;
    btnBCCRemove: TButton;
    ToButton: TButton;
    CCButton: TButton;
    BCCButton: TButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    AttachButton: TButton;
    SendMailButton: TButton;
    ReadMailButton: TButton;
    Panel1: TPanel;
    SaveDialog1: TSaveDialog;
    ReturnAttachm: TCheckBox;
    bNewMail: TButton;
    procedure SendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RecipientExit(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure AttachExit(Sender: TObject);
    procedure AcknowledgeCheckClick(Sender: TObject);
    procedure ReadMailClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SomeAddressButtonClick(Sender: TObject);
    procedure AttachButtonClick(Sender: TObject);
    procedure lbDeleteDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ReturnAttachmClick(Sender: TObject);
    procedure lbAttachDblClick(Sender: TObject);
    procedure bNewMailClick(Sender: TObject);
  private
    { Private declarations }
    { form instance variables }
    Messages : TStringlist;
    MsgIndex : Integer;
    nUnread  : Integer;
    Abort    : Boolean;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

{ Initialize private instance variables and logon to the mail system. }
procedure TMainForm.FormCreate(Sender: TObject);
begin
  (*  Icon := Application.Icon;  *)
  Application.Title := 'TEmail demonstration';

  Messages := TStringlist.Create;
  Messages.Sorted := false;

  nUnread  := -1;
  MsgIndex := 0;
  Abort    := False;

{$IFDEF TESTCOMPON}
  Email1 := TEmail.Create(Self);
{$ENDIF TESTCOMPON}

  if Email1.Logon <> EMAIL_OK then
    MessageDlg('MAPI Logon failed', mtError, [mbOk], 0);

  Caption := Caption + ' [demo of TEmail ' + Email1.Version + ']';
end;

{ Cleanup. }
procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Messages.Free;
  Messages := nil;

  if Email1.Logoff <> EMAIL_OK then
    MessageDlg('MAPI Logoff failed', mtError, [mbOk], 0);
end;

{ Send mail. }
procedure TMainForm.SendClick(Sender: TObject);
var
  PlongText: PChar;
  TextSize: integer;
begin
  if lbTo.Items.Count > 0 then
    Email1.Recipient.Assign(lbTo.Items);

  if lbCC.Items.Count > 0 then
    Email1.CC.Assign(lbCC.Items);

  if lbBCC.Items.Count > 0 then
    Email1.BCC.Assign(lbBCC.Items);

  if lbAttach.Items.Count > 0 then
    Email1.Attachment.Assign(lbAttach.Items);

  TextSize := MessageText.GetTextLen + 1;
  PlongText := StrAlloc(TextSize);
  try
    MessageText.GetTextBuf(PlongText, TextSize);
    Email1.SetLongText(PlongText);
  finally
    StrDispose(PlongText);
  end;

  Email1.Subject := MessageSubject.Text;

  if Email1.SendMail <> EMAIL_OK then
  begin
    MessageDlg('MAPI Sendmail failed', mtError, [mbAbort], 0);
    Close;
  end
  else
  begin
    Recipient.Clear;
    CC.Clear;
    BCC.Clear;
    Attach.Clear;

    AcknowledgeCheck.State := cbUnchecked;

    MessageSubject.Clear;
    MessageText.Clear;

    lbTo.Clear;
    lbCC.Clear;
    lbAttach.Clear;
    lbBCC.Clear;

    { Clear internal state of TEmail for safety }
    Email1.Clear;
  end;
end;

{ Add recipient to listbox on exit. }
procedure TMainForm.RecipientExit(Sender: TObject);
var
  Recip: SString;
begin
  with Sender as TEdit do
  begin
    if Length(Text) > 0 then
    begin
      Recip := Email1.CheckRecipient(Text);
      Text := '';

      if Length(Recip) > 0 then
      begin
        if Sender = Recipient then
          lbTo.Items.Add(Recip)
        else
          if Sender = CC then
            lbCC.Items.Add(Recip)
          else
            if Sender = BCC then
              lbBCC.Items.Add(Recip);
      end;

      SetFocus;
    end;
  end;
end;

{ Remove recipient from lbTo button. }
procedure TMainForm.btnRemoveClick(Sender: TObject);
var
  AListbox: TListbox;
begin
  AListbox := nil;

  if Sender = btnToRemove then
    AListbox := lbTo
  else
  if Sender = btnCCRemove then
    AListbox := lbCC
  else
  if Sender = btnBCCRemove then
    AListbox := lbBCC
  else
  if Sender = btnAttachRemove then
    AListbox := lbAttach;

  if AListbox <> nil then
  with AListbox do
  begin
    if (ItemIndex <> -1) then
    begin
      Items.Delete(ItemIndex);
    end
    else
    begin
{$IFDEF WIN32}
      MessageBeep($FFFFFFFF);
{$ELSE}
      MessageBeep($FFFF);
{$ENDIF WIN32}
      ItemIndex := 0;
      SetFocus;
    end;
  end;
end;


{ Add button has been clicked }
procedure TMainForm.btnAddClick(Sender: TObject);
var
  AnEdit: TEdit;
begin
  AnEdit := nil;

  if Sender = btnToAdd then
    AnEdit := Recipient
  else
  if Sender = btnCCAdd then
    AnEdit := CC
  else
  if Sender = btnBCCAdd then
    AnEdit := BCC;

  if AnEdit <> nil then
  begin
    RecipientExit(AnEdit);
    AnEdit.SetFocus;
  end;
end;

{ Move attachment to lbAttach on exit. }
procedure TMainForm.AttachExit(Sender: TObject);
var
  Attachment : SString;
begin
  with Attach do
  begin
    if Length(Text) > 0 then
    begin
      Attachment := Email1.CheckAttachment(ExpandFilename(Text));

      if Length(Attachment) > 0 then
        lbAttach.Items.Add(Attachment)
      else
      begin
        with OpenAttachm do
        begin
          Filename := Text;
          if Execute then
            lbAttach.Items.Add(Filename);
        end;
      end;

      Text := '';

      SetFocus;
    end;
  end;
end;


{ Receipt requested checkbox. }
procedure TMainForm.AcknowledgeCheckClick(Sender: TObject);
begin
  Email1.Acknowledge := AcknowledgeCheck.Checked;
end;


{ Read next email message button. }
procedure TMainForm.ReadMailClick(Sender: TObject);
begin

  { count number of unread messages }
  if nUnread = -1 then
  begin
    Panel1.Caption := 'Counting unread messages, please wait...';

    Screen.Cursor := crHourGlass;
    try
      Update;
      nUnread := Email1.CountUnread;
    finally
      Screen.Cursor := crDefault;
    end;

    Panel1.Caption := '';
  end;

  { retrieve all message Id's }
  if Messages.Count = 0 then
  begin
    Email1.MessageId := '';

    Screen.Cursor := crHourGlass;
    try
      Application.ProcessMessages;

      Email1.GetNextMessageId;
      while (not Abort) and (Length(Email1.MessageId) <> 0) do
      begin
        Application.ProcessMessages;  { needed for ESC bail-out key to work }
        Messages.Add(Email1.MessageId);

        Panel1.Caption := Format('Retrieving all messages, please wait... (%d)', [Messages.Count]);
        Update;

        Email1.GetNextMessageID;
      end;
      MsgIndex := 0;

    finally
      Screen.Cursor := crDefault;
    end;

    Panel1.Caption := '';
    if Abort then
      exit;

    MessageDlg( Format( 'There are %d messages of which %d are unread.', 
                        [Messages.Count, nUnread]),
                mtInformation, [mbOK], 0);
  end;

  with Email1 do
  begin
    if MsgIndex < Messages.Count then    { if still messages left : }
    begin
      MessageId := Messages.Strings[MsgIndex]; { this is the message to fetch }
      Inc(MsgIndex);
    end
    else
    begin
      MsgIndex := 0;                           { else clear all message stuff  }
      Messages.Clear;                          { so that we can read them again}
      nUnread := -1;                           { and inform the user           }
      MessageDlg('No more messages.', mtInformation, [mbOk], 0);
    end;

    HeaderOnly := False;    { retrieve entire message }
    LeaveUnread := True;    { do not mark the messages read }
    NoAttachments := not ReturnAttachm.Checked;  { if False : you have to delete the temp files !! }
    ReadMail;               { fetch the message }


    lbTo.Clear;         { store recipients in lbTo }
    lbTo.Items.Assign(Recipient);

    lbCC.Clear;         { store CCs in lbCC }
    lbCC.Items.Assign(CC);

    lbBCC.Clear;         { and BCCs in lbBCC  }
    lbBCC.Items.Assign(BCC);

    lbAttach.Clear;         { store attachments in lbAttach if NoAttachments False }
    lbAttach.Items.Assign(Attachment);

    if (NoAttachments = False) and (lbAttach.Items.Count > 0) then
      lbAttach.ShowHint := True
    else
      lbAttach.ShowHint := False;

    MessageText.Clear;

    if Email1.Text = '' then   { set subject and text fields }
      MessageText.SetTextBuf(GetLongText)
    else
      MessageText.Text := Email1.Text;

    MessageSubject.Text := Email1.Subject;

    { show originator in the panel }
    Panel1.Caption := Format('From: %s (%s)', [Originator, DateRecvd]);
    if Unread then
      with Panel1 do
        Caption := Caption + ' *unread*';
  end;
end;

{ Escape closes the form. }
procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
var
  OldCursor: TCursor;
begin
  if Key = #$1B then
  begin
    OldCursor := Screen.Cursor;
    Screen.Cursor := crDefault;
    try
      if MessageDlg( 'Are you sure that you want to close and leave this form?',
                     mtConfirmation,
                     [mbYes, mbNo], 0) = mrYes then
      begin
        Abort := True;
        Close;
      end;
    finally
      Screen.Cursor := OldCursor;
    end;
  end;
end;

{ Present an address dialog box. }
procedure TMainForm.SomeAddressButtonClick(Sender: TObject);
begin
  Email1.Recipient.Assign(lbTo.Items);
  Email1.CC.Assign(lbCC.Items);
  Email1.BCC.Assign(lbBCC.Items);

  Email1.Address;

  lbTo.Clear;         { store recipients in lbTo }
  lbTo.Items.Assign(Email1.Recipient);

  lbCC.Clear;         { store CCs in lbCC }
  lbCC.Items.Assign(Email1.CC);

  lbBCC.Clear;         { and BCCs in lbBCC  }
  lbBCC.Items.Assign(Email1.BCC);
end;

{ Open attachment dialog. }
procedure TMainForm.AttachButtonClick(Sender: TObject);
begin
  with OpenAttachm do
    if Execute then
      lbAttach.Items.Add(Filename);
end;

procedure TMainForm.lbDeleteDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  iIndex: integer;
begin
  if (Key = VK_DELETE) and (Sender is TListbox) then
    with TListbox(Sender) do
    begin
      iIndex := ItemIndex;
      if iIndex <> -1 then
      begin
        Items.Delete(iIndex);
        if Items.Count > 0 then
          ItemIndex := iIndex;
      end
      else
      begin
{$IFDEF WIN32}
        MessageBeep($FFFFFFFF);
{$ELSE}
        MessageBeep($FFFF);
{$ENDIF WIN32}
        ItemIndex := 0;
        SetFocus;
      end;
    end;
end;

procedure TMainForm.ReturnAttachmClick(Sender: TObject);
begin
  { if False : you have to delete the temp files !! }
  Email1.NoAttachments := not ReturnAttachm.Checked;
end;

procedure TMainForm.lbAttachDblClick(Sender: TObject);
var
  Index : integer;
begin
  Index := lbAttach.ItemIndex;
  if Index < 0 then
    exit;

  SaveDialog1.Filename := ExtractFileName(lbAttach.Items[Index]);

  if SaveDialog1.Execute then 
  begin
    Email1.CopyAttachment(index, SaveDialog1.Filename, True);
  end;
end;

procedure TMainForm.bNewMailClick(Sender: TObject);
var
  OldCursor: TCursor;
begin
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    Panel1.Caption := 'Downloading new messages - please wait...';
    Update;
    Email1.DownLoad;
  finally
    Panel1.Caption := '';
    Screen.Cursor := OldCursor;
  end;
end;

end.


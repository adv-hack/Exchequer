unit TestF;

{ prutherford440 10:08 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSh_Email: TTabSheet;
    TabSh_ZIP: TTabSheet;
    Button1: TButton;
    btnSend: TButton;
    lstZip: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    edtZIPName: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Button3: TButton;
    btnAddToZip: TButton;
    btnDeleteZip: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Label5: TLabel;
    chkDOSPaths: TCheckBox;
    chkOverWrite: TCheckBox;
    chkRemoveDots: TCheckBox;
    chkStripDrive: TCheckBox;
    chkRecurse: TCheckBox;
    chkStripPath: TCheckBox;
    Label6: TLabel;
    Label11: TLabel;
    edtSubject: TEdit;
    Label12: TLabel;
    edtMessage: TEdit;
    Label13: TLabel;
    lstAttachments: TListBox;
    btnAddAttach: TButton;
    btnDelAttach: TButton;
    Label14: TLabel;
    OpenDialog2: TOpenDialog;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    Label8: TLabel;
    lstTo: TListBox;
    btnAddRecip: TButton;
    btnDelRecip: TButton;
    Label9: TLabel;
    lstCC: TListBox;
    btnAddCC: TButton;
    btnDelCC: TButton;
    Label10: TLabel;
    lstBCC: TListBox;
    btnAddBCC: TButton;
    btnDelBCC: TButton;
    PageControl3: TPageControl;
    TabSh_MAPI: TTabSheet;
    TabSh_Components: TTabSheet;
    TabSh_Sender: TTabSheet;
    Label7: TLabel;
    edtSender: TEdit;
    Label15: TLabel;
    edtName: TEdit;
    Label16: TLabel;
    edtSMTPServer: TEdit;
    Label17: TLabel;
    lstPriority: TComboBox;
    TabSh_Headers: TTabSheet;
    Label18: TLabel;
    lstHeader: TListBox;
    btnAddHeader: TButton;
    btnDelHeader: TButton;
    chkUseMapi: TCheckBox;
    TabSheet1: TTabSheet;
    Label19: TLabel;
    btnTestMAPI: TButton;
    TabSheet2: TTabSheet;
    Label20: TLabel;
    edUnzipFile: TEdit;
    Button2: TButton;
    edFileMask: TEdit;
    Label21: TLabel;
    edUnzipDir: TEdit;
    Label22: TLabel;
    btnUnzip: TButton;
    btnListFiles: TButton;
    lbZipFiles: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnAddToZipClick(Sender: TObject);
    procedure btnDeleteZipClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDelRecipClick(Sender: TObject);
    procedure btnAddRecipClick(Sender: TObject);
    procedure btnDelCCClick(Sender: TObject);
    procedure btnDelBCCClick(Sender: TObject);
    procedure btnDelAttachClick(Sender: TObject);
    procedure lstToDblClick(Sender: TObject);
    procedure btnAddCCClick(Sender: TObject);
    procedure lstCCDblClick(Sender: TObject);
    procedure btnAddBCCClick(Sender: TObject);
    procedure lstBCCDblClick(Sender: TObject);
    procedure lstAttachmentsDblClick(Sender: TObject);
    procedure btnAddAttachClick(Sender: TObject);
    procedure btnDelHeaderClick(Sender: TObject);
    procedure btnAddHeaderClick(Sender: TObject);
    procedure lstHeaderDblClick(Sender: TObject);
    procedure btnTestMAPIClick(Sender: TObject);
    procedure btnUnzipClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnListFilesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses CommsInt;

procedure TForm1.FormCreate(Sender: TObject);
begin
  edtZIPName.Text := ChangeFileExt(Application.ExeName, '.ZIP');
  OpenDialog1.InitialDir := ExtractFilePath(Application.ExeName);
  lstPriority.ItemIndex := 1;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  With SaveDialog1 Do Begin
    If (Trim(edtZIPName.Text) <> '') Then Begin
      FileName := edtZIPName.Text;
    End { If }
    Else Begin
      { Defaults }
      InitialDir := ExtractFilePAth(Application.ExeName);
    End; { Else }
  End; { With }

  If SaveDialog1.Execute Then Begin
    edtZIPName.Text := SaveDialog1.FileName;
  End; { If }
end;

procedure TForm1.btnAddToZipClick(Sender: TObject);
begin
  If OpenDialog1.Execute Then Begin
    lstZip.Items.Add (OpenDialog1.FileName);
    lstZip.ItemIndex := Pred(lstZip.Items.Count);
  End; { If }
end;

procedure TForm1.btnDeleteZipClick(Sender: TObject);
begin
  If (lstZip.ItemIndex > -1) Then Begin
    lstZip.Items.Delete(lstZip.ItemIndex);
  End; { If }
end;

procedure TForm1.Button1Click(Sender: TObject);
Var
  ZipO : TEntZip;
  Res  : SmallInt;
Begin
  ZipO := TEntZip.Create;
  Try
    With ZipO Do Begin
      DOSPaths          := chkDOSPaths.Checked;
      OverwriteExisting := chkOverWrite.Checked;
      Recurse           := chkRecurse.Checked;
      RemoveDots        := chkRemoveDots.Checked;
      StripDrive        := chkStripDrive.Checked;
      StripPath         := chkStripPath.Checked;
      ZipName           := edtZIPName.Text;

      Files.Assign(lstZip.Items);

      Res := Save;
    End; { With }
  Finally
    ZipO.Destroy;
  End;

  ShowMessage ('ecBuildZip = ' + IntToStr(Res));
end;

procedure TForm1.btnSendClick(Sender: TObject);
Var
  EmailO : TEntEmail;
  Res    : SmallInt;
Begin
  EmailO := TEntEmail.Create;
  Try
    With EmailO Do Begin
      Attachments.Assign (lstAttachments.Items);
      BCC.Assign (lstBCC.Items);
      CC.Assign (lstCC.Items);
      Headers.Assign (lstHeader.Items);
      StrPCopy (Message, edtMessage.Text);
      Priority := lstPriority.ItemIndex;
      Recipients.Assign (lstTo.Items);
      Sender := edtSender.Text;
      SenderName := edtName.Text;
      SMTPServer := edtSMTPServer.Text;
      Subject := edtSubject.Text;
      UseMAPI := chkUseMapi.Checked;

      Res := Send;
    End; { With }
  Finally
    EmailO.Destroy;
  End;

  ShowMessage ('ecSendEmail = ' + IntToStr(Res));
end;

procedure TForm1.btnDelRecipClick(Sender: TObject);
begin
  If (lstTo.ItemIndex > -1) Then Begin
    lstTo.Items.Delete(lstTo.ItemIndex);
  End; { If }
end;

procedure TForm1.btnAddRecipClick(Sender: TObject);
Var
  EAddr : AnsiString;
begin
  If InputQuery('Add Recipient', 'Please enter the new Recipients Email Address:-', EAddr) Then Begin
    lstTo.Items.Add (EAddr);
  End; { If }
end;

procedure TForm1.btnDelCCClick(Sender: TObject);
begin
  If (lstCC.ItemIndex > -1) Then Begin
    lstCC.Items.Delete(lstCC.ItemIndex);
  End; { If }
end;

procedure TForm1.btnDelBCCClick(Sender: TObject);
begin
  If (lstBCC.ItemIndex > -1) Then Begin
    lstBCC.Items.Delete(lstBCC.ItemIndex);
  End; { If }
end;

procedure TForm1.btnDelAttachClick(Sender: TObject);
begin
  If (lstAttachments.ItemIndex > -1) Then Begin
    lstAttachments.Items.Delete(lstAttachments.ItemIndex);
  End; { If }
end;

procedure TForm1.lstToDblClick(Sender: TObject);
Var
  EAddr : AnsiString;
begin
  If (lstTo.ItemIndex > -1) Then Begin
    EAddr := lstTo.Items[lstTo.ItemIndex];

    If InputQuery('Edit Recipient', 'Please enter the correct Recipients Email Address:-', EAddr) Then Begin
      lstTo.Items[lstTo.ItemIndex] := EAddr;
    End; { If }
  End; { If }
end;

procedure TForm1.btnAddCCClick(Sender: TObject);
Var
  EAddr : AnsiString;
begin
  If InputQuery('Add CC', 'Please enter the new CC Address:-', EAddr) Then Begin
    lstCC.Items.Add (EAddr);
  End; { If }
end;

procedure TForm1.lstCCDblClick(Sender: TObject);
Var
  EAddr : AnsiString;
begin
  If (lstCC.ItemIndex > -1) Then Begin
    EAddr := lstCC.Items[lstCC.ItemIndex];

    If InputQuery('Edit CC', 'Please enter the correct CC Address:-', EAddr) Then Begin
      lstCC.Items[lstCC.ItemIndex] := EAddr;
    End; { If }
  End; { If }
end;

procedure TForm1.btnAddBCCClick(Sender: TObject);
Var
  EAddr : AnsiString;
begin
  If InputQuery('Add Blank CC', 'Please enter the new Blank CC Address:-', EAddr) Then Begin
    lstBCC.Items.Add (EAddr);
  End; { If }
end;

procedure TForm1.lstBCCDblClick(Sender: TObject);
Var
  EAddr : AnsiString;
begin
  If (lstBCC.ItemIndex > -1) Then Begin
    EAddr := lstBCC.Items[lstBCC.ItemIndex];

    If InputQuery('Edit Blank CC', 'Please enter the correct Blank CC Address:-', EAddr) Then Begin
      lstBCC.Items[lstBCC.ItemIndex] := EAddr;
    End; { If }
  End; { If }
end;

procedure TForm1.btnAddAttachClick(Sender: TObject);
begin
  If OpenDialog1.Execute Then Begin
    lstAttachments.Items.Add (OpenDialog1.FileName);
    lstAttachments.ItemIndex := Pred(lstAttachments.Items.Count);
  End; { If }
end;

procedure TForm1.lstAttachmentsDblClick(Sender: TObject);
Var
  Attach : AnsiString;
begin
  If (lstAttachments.ItemIndex > -1) Then Begin
    Attach := lstAttachments.Items[lstAttachments.ItemIndex];

    With OpenDialog1 Do Begin
      FileName := Attach;

      If Execute Then Begin
        lstAttachments.Items[lstAttachments.ItemIndex] := FileName;
      End; { If }
    End; { With }
  End; { If }
end;

procedure TForm1.btnDelHeaderClick(Sender: TObject);
begin
  If (lstHeader.ItemIndex > -1) Then Begin
    lstHeader.Items.Delete(lstHeader.ItemIndex);
  End; { If }
end;

procedure TForm1.btnAddHeaderClick(Sender: TObject);
Var
  Hdr : AnsiString;
begin
  If InputQuery('Add Email Header', 'Please enter the new Email Header:-', Hdr) Then Begin
    lstHeader.Items.Add (Hdr);
  End; { If }
end;

procedure TForm1.lstHeaderDblClick(Sender: TObject);
Var
  Hdr : AnsiString;
begin
  If (lstHeader.ItemIndex > -1) Then Begin
    Hdr := lstHeader.Items[lstHeader.ItemIndex];

    If InputQuery('Edit Email Header', 'Please enter the correct Email Header:-', Hdr) Then Begin
      lstHeader.Items[lstHeader.ItemIndex] := Hdr;
    End; { If }
  End; { If }
end;

procedure TForm1.btnTestMAPIClick(Sender: TObject);
begin
  If MAPIAvailable Then
    ShowMessage ('MAPI is online and raring to go')
  Else
    ShowMessage ('MAPI is not installed or is shagged');
end;

procedure TForm1.btnUnzipClick(Sender: TObject);
var
  oUnzipper : TUnzipper;
begin
  oUnzipper := TUnzipper.Create(edUnzipFile.Text);
  oUnzipper.ExtractFiles(edFileMask.Text,edUnzipDir.Text);
  oUnzipper.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  OpenDialog1.Execute;
  edUnzipFile.Text := OpenDialog1.Filename;
end;

procedure TForm1.btnListFilesClick(Sender: TObject);
var
  oUnzipper : TUnzipper;
begin
  oUnzipper := TUnzipper.Create(edUnzipFile.Text);
  lbZipFiles.Items.Assign(oUnzipper.Files);
  oUnzipper.Free;
end;

end.

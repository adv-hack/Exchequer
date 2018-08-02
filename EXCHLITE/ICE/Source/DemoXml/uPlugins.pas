Unit uPlugins;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, comobj, dateutils,
  uConsts, uCommon,
  ComCtrls
  ;

Type
  TfrmPluginsFunctions = Class(TForm)
    btnExportCustomer: TButton;
    btnReiceveCustomers: TButton;
    btnImport: TButton;
    edtGuid: TEdit;
    Label1: TLabel;
    RichEdit1: TRichEdit;
    Button1: TButton;
    Button2: TButton;
    edtGuid2: TEdit;
    Button3: TButton;
    btnDelete: TButton;
    Procedure FormCreate(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure btnExportCustomerClick(Sender: TObject);
    Procedure btnReiceveCustomersClick(Sender: TObject);
    Procedure btnImportClick(Sender: TObject);
    Procedure Button1Click(Sender: TObject);
    Procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  Private
  Public

  End;

Var
  frmPluginsFunctions: TfrmPluginsFunctions;

Implementation

{$R *.dfm}

Procedure TfrmPluginsFunctions.FormCreate(Sender: TObject);
Begin
  //fCaller := CoDSRCOMCaller.Create;

  fCaller := CreateOleObject('COMCaller.DSRCOMCaller') as IDSRCOMCaller;
End;

Procedure TfrmPluginsFunctions.FormClose(Sender: TObject;
  Var Action: TCloseAction);
Begin
  fCaller := Nil;
End;

Procedure TfrmPluginsFunctions.btnExportCustomerClick(Sender: TObject);
Var
  lResult: LONGWORD;
Begin
  fCaller.BExport(1, _CreateGuid, 'test', 'vmoura@icemail.com',
    'dsrmail@icemail.com', 'test', cCustTable, IncDay(date, -60), Date, lResult);
  If lResult <> 0 Then
    ShowMessage(_TranslateErrorCode(lResult));
End;

Procedure TfrmPluginsFunctions.btnReiceveCustomersClick(Sender: TObject);
Const
  cFileName =
    'C:\Projects\Ice\temp\{2FD90D89-4673-4208-B27F-EB913E8575DC}\2.xml';
Var
  lMemo: TMemorystream;
  lResult: LONGWORD;
  lXml: String;
  lGuid: Tguid;
Begin
{  lGuid := _CreateGuid;
  edtGuid.Text := GUIDToString(lGuid);

  lMemo := TMemorystream.Create;
  lMemo.LoadFromFile(cFilename);
  lMemo.Position := 0;
  SetLength(lXml, lMemo.size);
  lMemo.Read(lXml[1], lMemo.Size);
  FreeAndNil(lMemo);

  fCaller.BReceive(lGuid, 'test', 'vmoura@icemail.com', 'dsrmail@icemail.com',
    'test', 0, 1, 1, lXML, lResult);

  If lResult <> 0 Then
    ShowMessage(_TranslateErrorCode(lResult));
}    
End;

Procedure TfrmPluginsFunctions.btnImportClick(Sender: TObject);
Var
  lResult: LONGWORD;
Begin
  fCaller.BImport(1, StringToGUID(edtGuid.Text), cCustTable, lResult);
  If lResult <> 0 Then
    ShowMessage(_TranslateErrorCode(lResult));
End;

Procedure TfrmPluginsFunctions.Button1Click(Sender: TObject);
Var
  lHeader: TMsgHeader;
Begin
  FillChar(lHeader, sizeof(tmsgheader), 0);
  lHeader.Guid := _CreateGuid;
  lHeader.Number := 1;
  lHeader.Count := 10;
  edtGuid.Text := GUIDToString(lHeader.Guid);

  _WriteHeadertoFile(lHeader, extractfilepath(application.ExeName) + '5.xml')
End;

Procedure TfrmPluginsFunctions.Button2Click(Sender: TObject);
Var
  lHeader: TMsgHeader;
Begin
  FillChar(lHeader, sizeof(tmsgheader), 0);
  _GetHeaderFromFile(lHeader, extractfilepath(application.ExeName) + '5.xml');
  edtGuid2.Text := GUIDToString(lHeader.Guid);
End;

procedure TfrmPluginsFunctions.Button3Click(Sender: TObject);
var
  irmark, guids: widestring;
  pResult: longword;
begin
//  fCaller.GGW_GetPending(1, ord('|'), irmark, guids, pResult);

  showmessage(irmark);
  showmessage(guids);
end;

procedure TfrmPluginsFunctions.btnDeleteClick(Sender: TObject);
Var
  lResult: LONGWORD;
Begin
  fCaller.DeleteOutboxMessage(1, StringToGUID('{334279D1-0659-42F0-B75F-006C69DB2D87}'), lResult);
  If lResult <> 0 Then
    ShowMessage(_TranslateErrorCode(lResult));
end;

End.


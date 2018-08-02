(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit msattpe;

{$I msdef.inc}

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  msAttAdd,
{$IFDEF VER140}
  DesignIntf,
  DesignWindows,
  DesignEditors,
{$ELSE}
  DsgnIntf,
{$ENDIF}
  msMsgCls;

type
  TAttListEditDlg = class(TForm)
    Bevel1: TBevel;
    ListBox1: TListBox;
    EditButton: TButton;
    AddButton: TButton;
    DeleteButton: TButton;
    OKButton: TButton;
    CancelButton: TButton;
    HelpButton: TButton;
    UpButton: TButton;
    DownButton: TButton;
    procedure AddButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure UpButtonClick(Sender: TObject);
    procedure DownButtonClick(Sender: TObject);
  private
    { Private declarations }
    FAttList : TmsAttList;
    procedure SetAttList(Value : TmsAttList);
    procedure FillListBox;
  public
    { Public declarations }
    property AttList : TmsAttList read FAttList write SetAttList;
  end;

  TmsAttListProperty = class(TClassProperty)
    procedure Edit; override;
    function GetAttributes : TPropertyAttributes; override;
  end;

var
  AttListEditDlg: TAttListEditDlg;

implementation

{$R *.DFM}

{TmsAddressListProperty}
function TmsAttListProperty.GetAttributes : TPropertyAttributes;
begin
  Result:=[paDialog,paReadOnly];
end;

procedure TmsAttListProperty.Edit;
var
  AttListEditDlg : TAttListEditDlg;
begin
  AttListEditDlg:=TAttListEditDlg.Create(Application);
  try
    AttListEditDlg.AttList:=TmsAttList(GetOrdValue);
    if AttListEditDlg.ShowModal=mrOk then
      SetOrdValue(LongInt(AttListEditDlg.AttList));
  finally
    AttListEditDlg.Free;
  end;
end;

procedure TAttListEditDlg.FormCreate(Sender: TObject);
begin
  FAttList:=TmsAttList.Create;
end;

procedure TAttListEditDlg.FormDestroy(Sender: TObject);
begin
  FAttList.Free;
end;

procedure TAttListEditDlg.SetAttList(Value : TmsAttList);
begin
  FAttList.Assign(Value);
  FillListBox;
end;

procedure TAttListEditDlg.FillListBox;
var
  i : Integer;
begin
  ListBox1.Items.Clear;
  for i:=0 to FAttList.Count-1 do
    ListBox1.Items.Add(FAttList[i].FileName);
  if ListBox1.Items.Count=0 then
  begin
    EditButton.Enabled:=false;
    DeleteButton.Enabled:=false;
  end
  else
  begin
    EditButton.Enabled:=true;
    DeleteButton.Enabled:=true;
    ListBox1.ItemIndex:=0;
  end;
end;

procedure TAttListEditDlg.AddButtonClick(Sender: TObject);
var
  AttItem : TmsAttItem;
begin
  with TAttEditDlg.Create(Self) do
  try
    if ShowModal=mrOk then
    begin
      AttItem:=TmsAttItem.Create;
      AttItem.FileName:=FileNameEdit.Text;
      AttItem.ContentType:=ContentTypeEdit.Text;
      AttItem.ContentTransferEncoding:=TmsEncoding(EncodingBox.ItemIndex);
      FAttList.Add(AttItem);
      FillListBox;
    end;
  finally
    free;
  end;
end;

procedure TAttListEditDlg.DeleteButtonClick(Sender: TObject);
var
  CurItem : Integer;
begin
  CurItem:=ListBox1.ItemIndex;
  FAttList.Delete(CurItem);
  FillListBox;
  if ListBox1.Items.Count>0 then
    ListBox1.ItemIndex:=CurItem;
end;

procedure TAttListEditDlg.EditButtonClick(Sender: TObject);
var
  AttItem : TmsAttItem;
begin
  with TAttEditDlg.Create(Self) do
  begin
    AttItem:=FAttList[ListBox1.ItemIndex];
    FileNameEdit.Text:=AttItem.FileName;
    ContentTypeEdit.Text:=AttItem.ContentType;
    EncodingBox.ItemIndex:=Ord(AttItem.ContentTransferEncoding);
    if ShowModal=mrOk then
    begin
      AttItem.FileName:=FileNameEdit.Text;
      AttItem.ContentType:=ContentTypeEdit.Text;
      AttItem.ContentTransferEncoding:=TmsEncoding(EncodingBox.ItemIndex);
      FAttList[ListBox1.ItemIndex]:=AttItem;
      FillListBox;
    end;
  end;
end;

procedure TAttListEditDlg.UpButtonClick(Sender: TObject);
var
  CurItem : Integer;
begin
  CurItem:=ListBox1.ItemIndex;
  if CurItem>0 then
  begin
    FAttList.Exchange(CurItem,CurItem-1);
    ListBox1.Items.Exchange(CurItem,CurItem-1);
    ListBox1.ItemIndex:=CurItem-1;
  end
  else
    MessageBeep(MB_ICONHAND);
end;

procedure TAttListEditDlg.DownButtonClick(Sender: TObject);
var
  CurItem : Integer;
begin
  CurItem:=ListBox1.ItemIndex;
  if CurItem<ListBox1.Items.Count-1 then
  begin
    FAttList.Exchange(CurItem,CurItem+1);
    ListBox1.Items.Exchange(CurItem,CurItem+1);
    ListBox1.ItemIndex:=CurItem+1;
  end
  else
    MessageBeep(MB_ICONHAND);
end;

end.


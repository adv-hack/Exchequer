unit vr1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AuthObjs, StdCtrls;

type
  TfrmVrTest = class(TForm)
    cbRequest: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbRequestDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    ReqList : TStringList;
    PaObject : TPaObject;
    FCurrentIdxNo : longInt;
    FCurrentEar : string;
    procedure LoadRecords(ACount : integer);
    procedure AddRequest(s : string);
  public
    { Public declarations }
  end;

var
  frmVrTest: TfrmVrTest;

implementation

{$R *.dfm}
uses
  AuthVar;

procedure TfrmVrTest.Button1Click(Sender: TObject);
var
  Res : SmallInt;
begin
  with PaObject do
  begin
    cbRequest.Clear;
    Request.Company := 'ZZZZ01';
    Res := Request.GetFirst;

    while Res = 0 do
    begin
      cbRequest.Items.Add(Request.Ear);

      Res := Request.GetNext;
    end;

    cbRequest.ItemIndex := 0;
  end;
end;

procedure TfrmVrTest.FormCreate(Sender: TObject);
var
  i : integer;
begin
  PaObject := TPaObject.Create;
  PaObject.CompanyCode := 'ZZZZ01';
  PaObject.OpenFiles;
  FCurrentIdxNo := 0;
  FCurrentEar := '';

{  for i := 0 to 9 do
    cbRequest.Items.Add(' ');}
  ReqList := TStringList.Create;
//  LoadRecords(10);
//  cbRequest.ItemIndex := 1;
end;

procedure TfrmVrTest.FormDestroy(Sender: TObject);
begin
  PaObject.Free;
end;

procedure TfrmVrTest.LoadRecords(ACount : integer);
var
  Res : SmallInt;

  i, j : integer;
begin
  with PaObject do
  begin
    ReqList.Clear;
    Request.Company := 'ZZZZ01';
    Res := Request.GetFirst;

    while (Res = 0) and (ReqList.Count < ACount) do
    begin
      ReqList.Add(Request.Ear);

      Res := Request.GetNext;
    end;

  end;
end;

procedure TfrmVrTest.cbRequestDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  if Index = 0 then
    cbRequest.ItemIndex := 1
{  else
  if Index = 9 then
    cbRequest.ItemIndex := 8}
  else
  begin
    cbRequest.Canvas.FillRect(Rect);
    cbRequest.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, ReqList[Index + 1]);
  end;
end;

procedure TfrmVrTest.AddRequest(s : string);
var

  REs : Smallint;
begin
  with PaObject do
  begin
    with Request do
    begin
     Clear;
     Index := 0;
     Company := 'ZZZZ02';
     EAR := MakeRequestString('ZZZZ02', s);
     UserID := 'MISS';
     OurRef := s;
     DocType := DocTypeFromOurRef(s);
     TotalValue := 2000;
     TimeStamp := Now;
     ApprovedBy := '';
     Authoriser := 'TEST';
     Status := esSentForAuth;
     Res := Add;
    end;
  end;
end;

procedure TfrmVrTest.Button2Click(Sender: TObject);
var
  i : integer;
  s : string;
  s2 : string;
begin
  for i := 1 to 1000 do
  begin
    s2 := IntToStr(i);
    s2 := StringOfChar('0', 5 - Length(s2)) + s2;
    s := 'PIN6' + s2;

    Label1.Caption := s;
    Label1.Repaint;
    AddRequest(s);
    Application.ProcessMessages;
  end;
end;

end.

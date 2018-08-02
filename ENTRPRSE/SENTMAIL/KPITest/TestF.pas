unit TestF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComObj, Sentimail_TLB, StdCtrls, Enterprise01_TLB, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    memSentinel: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cbCompanies: TComboBox;
    edtUser: TEdit;
    edtSentinel: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    edtInstance: TEdit;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    oTriggered : ITriggeredEvent;
    oToolkit : IToolkit;
    procedure LoadCompanies;
    procedure GetSentinel(BtrOp : Integer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  CtkUtil;

{$I EXDLLBT.INC}

procedure TForm1.FormCreate(Sender: TObject);
begin
  oToolkit := CreateToolkitWithBackDoor;
  oTriggered := CreateOLEObject('Sentimail.TriggeredEvent') as ITriggeredEvent;
  LoadCompanies;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  oTriggered := nil;
  oToolkit := nil;
end;

procedure TForm1.LoadCompanies;
var
  i : integer;
begin
  for i := 1 to oToolkit.Company.cmCount do
    cbCompanies.Items.Add(oToolkit.Company.cmCompany[i].coCode);
  cbCompanies.ItemIndex := 0;
end;

procedure TForm1.GetSentinel(BtrOp: Integer);
var
  Res, i, Instance, c : Integer;
begin
  memSentinel.Clear;
  oTriggered.teDataPath := CompanyPathFromCode(oToolkit, cbCompanies.Items[cbCompanies.ItemIndex]);

  Case BtrOp of
    B_GetFirst : Res := oTriggered.GetFirst(edtUser.Text);
    B_GetEq    : begin
                   Val(edtInstance.Text, Instance, c);
                   if c <> 0 then
                     Instance := 0;
                   Res := oTriggered.GetEqual(edtUser.Text, edtSentinel.Text, Instance);
                 end;
    B_GetNext  : Res := oTriggered.GetNext;
  end;

  if Res = 0 then
  begin
    memSentinel.Lines.Add('Sentinel: ' + Trim(oTriggered.teSentinel));
    memSentinel.Lines.Add('Instance: ' + IntToStr(oTriggered.teInstance));
    memSentinel.Lines.Add('------------------');
    memSentinel.Lines.Add(' ');

    for i := 1 to oTriggered.teSMSNumberCount do
      memSentinel.Lines.Add('SMS No: ' + oTriggered.teSMSNumber[i]);
    if oTriggered.teSMSNumberCount > 0 then
      memSentinel.Lines.Add(' ');

    for i := 1 to oTriggered.teEmailAddressCount  do
      memSentinel.Lines.Add('Email Address: ' + oTriggered.teEmailAddress[i]);
    if oTriggered.teEmailAddressCount > 0 then
      memSentinel.Lines.Add(' ');

    if oTriggered.teEmailSubject <> '' then
    begin
      memSentinel.Lines.Add('Subject: ' + oTriggered.teEmailSubject);
      memSentinel.Lines.Add(' ');
    end;

    for i := 1 to oTriggered.teLineCount do
      memSentinel.Lines.Add(oTriggered.teLine[i]);

  end
  else
    ShowMessage('Result: ' + IntToStr(Res));
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if Trim(edtSentinel.Text) = '' then
    GetSentinel(B_GetFirst)
  else
    GetSentinel(B_GetEq);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  GetSentinel(B_GetNext);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  oTriggered.Delete;
end;

end.

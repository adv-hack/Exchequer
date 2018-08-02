unit TestF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Enterprise01_TLB, CTKUtil, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    lbRequests: TListBox;
    Panel2: TPanel;
    cbCompanies: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    edtAuth: TEdit;
    Label3: TLabel;
    edtCode: TEdit;
    Button2: TButton;
    btnReject: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    oToolkit : IToolkit;
    procedure LoadCompanies;
    procedure LoadRequests;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  KpiInt;

{ TForm1 }

procedure TForm1.LoadCompanies;
var
  i : integer;
begin
  for i := 1 to oToolkit.Company.cmCount do
    cbCompanies.Items.Add(oToolkit.Company.cmCompany[i].coCode);
  cbCompanies.ItemIndex := 0;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  oToolkit := CreateToolkitWithBackDoor;
  LoadCompanies;
end;

procedure TForm1.LoadRequests;
var
  TheList : IRequestList;
  Res, i : SmallInt;
  Request : IRequest;
begin
  Try
    lbRequests.Items.Clear;
    TheList := GetRequests(cbCompanies.Items[cbCompanies.ItemIndex],
                       edtAuth.Text, edtCode.Text, 30);

    if Assigned(TheList) then
    begin
      for i := 0 to TheList.rlCount - 1 do
        with TheList.rlItems[i] do
          lbRequests.Items.Add(Format('%s %s %8.2f', [rqOurRef, rqDate, rqValue]));
    end
    else
      ShowMessage('Error during GetRequests');
  Finally
    TheList := nil;
  End;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  LoadRequests;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Res : SmallInt;
  OurRef : ShortString;
  Reject : WordBool;
  RejectReason : ShortString;
begin
  if lbRequests.ItemIndex >= 0 then
  begin
    Reject := Sender = btnReject;
    if Reject then
      RejectReason := 'Some reason or other.'
    else
      RejectReason := '';
    OurRef := Trim(Copy(lbRequests.Items[lbRequests.itemIndex], 1, 10));
    Res := AuthoriseRequest(cbCompanies.Items[cbCompanies.ItemIndex],
                           edtAuth.Text, edtCode.Text, OurRef, Reject, RejectReason);
    if Res = 0 then
    begin
      if Reject then
        ShowMessage('Request rejected')
      else
        ShowMessage('Request authorised');
    end
    else
      ShowMessage('Error ' + IntToStr(Res));
  end;
end;

end.

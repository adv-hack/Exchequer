(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit msaddred;

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
  MsMsgCls;

type
  TMailAddressDlg = class(TForm)
    Bevel1: TBevel;
    OKButton: TButton;
    CancelButton: TButton;
    AddressEdit: TEdit;
    NameEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure OKButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FMailAddress : TMsMailAddress;
    procedure SetMailAddress(Value : TMsMailAddress);
  public
    { Public declarations }
    property MailAddress : TMsMailAddress read FMailAddress write SetMailAddress;
  end;

var
  MailAddressDlg: TMailAddressDlg;

implementation

{$R *.DFM}

procedure TMailAddressDlg.SetMailAddress(Value : TmsMailAddress);
begin
  FMailAddress.Assign(Value);
  NameEdit.Text:=FMailAddress.Name;
  AddressEdit.Text:=FMailAddress.Address;
end;

procedure TMailAddressDlg.OKButtonClick(Sender: TObject);
begin
  FMailAddress.Name:=NameEdit.Text;
  FMailAddress.Address:=AddressEdit.Text;
end;

procedure TMailAddressDlg.FormCreate(Sender: TObject);
begin
  FMailAddress:=TmsMailAddress.Create;
end;

procedure TMailAddressDlg.FormDestroy(Sender: TObject);
begin
  FMailAddress.Destroy;
end;

end.

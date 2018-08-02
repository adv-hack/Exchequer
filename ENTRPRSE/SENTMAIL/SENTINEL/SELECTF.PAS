unit selectf;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmSelectSent = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    lbAvailable: TListBox;
    lbInclude: TListBox;
    btnIncToAvail: TButton;
    btnAvailToInc: TButton;
    btnIncToAvailAll: TButton;
    btnAvailToIncAll: TButton;
    Label1: TLabel;
    lblInclude: TLabel;
    lblFile: TLabel;
    procedure btnIncToAvailClick(Sender: TObject);
    procedure btnAvailToIncClick(Sender: TObject);
    procedure btnIncToAvailAllClick(Sender: TObject);
    procedure btnAvailToIncAllClick(Sender: TObject);
    procedure lbAvailableDblClick(Sender: TObject);
    procedure lbIncludeDblClick(Sender: TObject);
  private
    { Private declarations }
    procedure MoveItems(lbFrom, lbTo : TListBox);
    procedure MoveAll(lbFrom, lbTo : TListBox);
    procedure SetButtons;
  public
    { Public declarations }
  end;

var
  frmSelectSent: TfrmSelectSent;

implementation

{$R *.DFM}

procedure TfrmSelectSent.MoveItems(lbFrom, lbTo : TListBox);
var
  i : integer;
begin
  for i := 0 to lbFrom.Items.Count - 1 do
    if lbFrom.Selected[i] then
      lbTo.Items.AddObject(lbFrom.Items[i], lbFrom.Items.Objects[i]);

  for i := lbFrom.Items.Count - 1 downto 0 do
    if lbFrom.Selected[i] then
      lbFrom.Items.Delete(i);

  SetButtons;
end;

procedure TfrmSelectSent.MoveAll(lbFrom, lbTo : TListBox);
begin
  lbTo.Items.AddStrings(lbFrom.Items);
  lbFrom.Items.Clear;
  SetButtons;
end;

procedure TfrmSelectSent.btnIncToAvailClick(Sender: TObject);
begin
  MoveItems(lbInclude, lbAvailable);
end;

procedure TfrmSelectSent.btnAvailToIncClick(Sender: TObject);
begin
  MoveItems(lbAvailable, lbInclude);
end;

procedure TfrmSelectSent.btnIncToAvailAllClick(Sender: TObject);
begin
  MoveAll(lbInclude, lbAvailable);
end;

procedure TfrmSelectSent.btnAvailToIncAllClick(Sender: TObject);
begin
  MoveAll(lbAvailable, lbInclude);
end;

procedure TfrmSelectSent.SetButtons;
begin
  btnIncToAvail.Enabled := lbInclude.Items.Count > 0;
  btnIncToAvailAll.Enabled := lbInclude.Items.Count > 0;
  btnAvailToInc.Enabled := lbAvailable.Items.Count > 0;
  btnAvailToIncAll.Enabled := lbAvailable.Items.Count > 0;
end;

procedure TfrmSelectSent.lbAvailableDblClick(Sender: TObject);
begin
  btnAvailToIncClick(Self);
end;

procedure TfrmSelectSent.lbIncludeDblClick(Sender: TObject);
begin
  btnIncToAvailClick(Self);
end;

end.

unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uMultiList;

type
  TfrmMultiList = class(TForm)
    mlList: TMultiList;
    btnAddItems: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure btnAddItemsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMultiList: TfrmMultiList;

implementation

{$R *.dfm}

procedure TfrmMultiList.btnAddItemsClick(Sender: TObject);
var
  iPos : integer;
begin
  For iPos := 0 to 10 do
  begin
    mlList.DesignColumns[0].items.Add(Chr(75 - iPos) + IntToStr(iPos));
    mlList.DesignColumns[1].items.Add(Chr(76 - iPos) + IntToStr(iPos));
    mlList.DesignColumns[2].items.Add(Chr(77 - iPos) + IntToStr(iPos));
    mlList.DesignColumns[3].items.Add(Chr(78 - iPos) + IntToStr(iPos));
    mlList.DesignColumns[4].items.Add(Chr(79 - iPos) + IntToStr(iPos));
  end;{for}
end;

procedure TfrmMultiList.Button1Click(Sender: TObject);
begin
  mlList.SortColumn(0, TRUE);
end;

procedure TfrmMultiList.Button2Click(Sender: TObject);
begin
  mlList.SortColumn(1, TRUE);
end;

procedure TfrmMultiList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := cafree;
end;

procedure TfrmMultiList.Button3Click(Sender: TObject);
begin
  Close;
end;

end.

unit TestFrmU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TTestFrm = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TestFrm: TTestFrm;

implementation

{$R *.dfm}

uses BtrvU2, GlobVar, BtrvSQLU;

procedure TTestFrm.Button1Click(Sender: TObject);
var
  Ver     :  Integer;
  Rev     :  Integer;
  Typ     :  Char;
  DumBlock:  FileVar;
begin
  Initialise('C:\EXCHTEST\');
  FillChar(DumBlock,Sizeof(DumBlock),0);
  if GetBtrvVer(DumBlock,Ver,Rev,Typ,1) then
  begin
    if not ((Ver = 9) and (Rev = 5)) then
    begin
      ShowMessage(
          'Wrong Btrieve version returned. Expected 9.5, got ' +
          IntToStr(Ver) + '.' + IntToStr(Rev)
      );
    end;
  end
  else
    ShowMessage('Failed');
end;

end.

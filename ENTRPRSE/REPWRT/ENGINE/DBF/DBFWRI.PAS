unit DBFWRI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Halcn6db, DB;

type
  TfrmDbfWrite = class(TForm)
    HalcyonDataSet1: THalcyonDataSet;
    CreateHalcyonDataSet1: TCreateHalcyonDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDbfWrite: TfrmDbfWrite;

implementation

{$R *.dfm}

end.

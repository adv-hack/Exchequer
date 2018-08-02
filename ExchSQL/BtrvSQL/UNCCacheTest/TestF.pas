unit TestF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Uses UNCCache;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo1.Lines.Add ('DEMO01 Tests');
  Memo1.Lines.Add ('V:\Exch2015R1UNC.SQL\Companies\DEMO01=' + UNCCompanyCache.CompanyCodeFromPath('V:\Exch2015R1UNC.SQL\Companies\DEMO01'));
  Memo1.Lines.Add ('\\L17190\c\Exchequer\Exch2015R1UNC.SQL\Companies\DEMO01=' + UNCCompanyCache.CompanyCodeFromPath('\\L17190\c\Exchequer\Exch2015R1UNC.SQL\Companies\DEMO01'));

  Memo1.Lines.Add ('');
  Memo1.Lines.Add ('NEWB01 Tests');
  Memo1.Lines.Add ('V:\Exch2015R1UNC.SQL\Companies\NEWB01=' + UNCCompanyCache.CompanyCodeFromPath('V:\Exch2015R1UNC.SQL\Companies\NEWB01'));
  Memo1.Lines.Add ('V:\Exch2015R1UNC.SQL\Companies\NEWB01\=' + UNCCompanyCache.CompanyCodeFromPath('V:\Exch2015R1UNC.SQL\Companies\NEWB01'));
  Memo1.Lines.Add ('\\L17190\c\Exchequer\Exch2015R1UNC.SQL\Companies\NEWB01=' + UNCCompanyCache.CompanyCodeFromPath('\\L17190\c\Exchequer\Exch2015R1UNC.SQL\Companies\NEWB01'));
  Memo1.Lines.Add ('\\L17190\c\Exchequer\Exch2015R1UNC.SQL\Companies\NEWB01\=' + UNCCompanyCache.CompanyCodeFromPath('\\L17190\c\Exchequer\Exch2015R1UNC.SQL\Companies\NEWB01'));

  Memo1.Lines.Add ('');
  Memo1.Lines.Add ('ROOT01 Tests');
  Memo1.Lines.Add ('V:\Exch2015R1UNC.SQL=' + UNCCompanyCache.CompanyCodeFromPath('V:\Exch2015R1UNC.SQL'));
  Memo1.Lines.Add ('\\L17190\c\Exchequer\Exch2015R1UNC.SQL=' + UNCCompanyCache.CompanyCodeFromPath('\\L17190\c\Exchequer\Exch2015R1UNC.SQL'));

  Memo1.Lines.Add ('');
  Memo1.Lines.Add ('#FAIL Tests');
  Memo1.Lines.Add ('W:\Exch2015R1UNC.SQL=' + UNCCompanyCache.CompanyCodeFromPath('W:\Exch2015R1UNC.SQL'));
  Memo1.Lines.Add ('\\L17190\c\Exchequer\Exch2015R1UNC.SQ=' + UNCCompanyCache.CompanyCodeFromPath('\\L17190\c\Exchequer\Exch2015R1UNC.SQ'));
end;

end.

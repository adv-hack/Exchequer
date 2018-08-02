unit uCISSubDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CISExSubcontractor_TLB, dsrexport_tlb, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses comobj;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  lSub: IExportBox;
begin

  lSub := CreateComObject(CLASS_CISSubcontractorExport) As IExportBox;
  lSub.DoExport('ZZZZ01', 'C:\EXCHEQR\Company01', 'C:\PROJECTS\ice\bin\xmldir', 'P002957', '', '', '', 0);

  lSub := nil;
end;

end.

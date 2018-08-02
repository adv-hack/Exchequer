unit uCISIncomingDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CISIncoming_TLB, dsrIncoming_tlb;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
  private
    fIncoming: ICISReceiving;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses DSRExport_TLB, activex, comobj;



{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  (fIncoming as IDSRIncomingSystem).CheckNow;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  fIncoming:= CoCISReceiving.Create;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fIncoming := nil;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  lExport: IExportBox;
  lXml: Widestring;
begin
  lExport := CreateComObject(stringtoguid( '{5F48D0D8-7636-4E3A-8FB0-7BEB09DDC054}')) As IExportBox;
  lExport.DoExport('', 'C:\IAOFFICE\CISXML', 'c:\projects\ice\bin\xmldir', '', '', '', '', 0);
  lXml := lExport.XmlList[0];

end;

end.

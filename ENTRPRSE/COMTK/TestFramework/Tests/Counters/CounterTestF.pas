unit CounterTestF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Enterprise04_TLB, StdCtrls, ExtCtrls;


type
  TfrmCounterMain = class(TForm)
    btnGo: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    lblProgress: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
  private
    { Private declarations }
    oToolkit : IToolkit;
    FCodeList : TStringList;
    FResultList : TStringList;
    procedure DoProgress(const s : string);
    procedure SaveResultList;
  public
    { Public declarations }
  end;

var
  frmCounterMain: TfrmCounterMain;

implementation

{$R *.dfm}
uses
  AcCounter, CounterClasses, CtkUtil04;

procedure TfrmCounterMain.FormCreate(Sender: TObject);
begin
  oToolkit := CreateToolkitWithBackdoor;
  oToolkit.OpenToolkit;
  FResultList := TStringList.Create;
end;

procedure TfrmCounterMain.FormDestroy(Sender: TObject);
begin
  FResultList.Free;
  oToolkit.CloseToolkit;
  oToolkit := nil;
end;


procedure TfrmCounterMain.btnGoClick(Sender: TObject);
begin
  Label1.Caption := 'Please wait...';

  //Customers and Suppliers

  SaveResultList;
  ShowMessage('Done');
end;

procedure TfrmCounterMain.DoProgress(const s: string);
//Update the progress label
begin
  lblProgress.Caption := s;
  lblProgress.Refresh;
  Application.ProcessMessages;
end;

procedure TfrmCounterMain.SaveResultList;
begin
  FResultList.SaveToFile('c:\object_tests.csv');
end;

end.

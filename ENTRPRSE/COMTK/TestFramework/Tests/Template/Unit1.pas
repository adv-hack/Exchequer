unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Enterprise01_TLB, StdCtrls;

type
  TForm1 = class(TForm)
    lblProgress: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    oToolkit : IToolkit;
    FDataPath : string;
    FTestName : string;
    FMessageHandle : THandle;
    FPosition : Integer;
    FirstTime : Boolean;
    function ReadParams : Boolean;
    function RunTest : Integer;
    procedure DoProgress(const s : string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  CtkUtil;


procedure TForm1.FormCreate(Sender: TObject);
begin
  FirstTime := True;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  oToolkit := nil;
end;

function TForm1.ReadParams: Boolean;
begin
  Result := ParamCount = 4;
  if Result then
  begin
    FTestName := ParamStr(1);
    FDataPath := ParamStr(2);
    FMessageHandle := THandle(StrToInt(ParamStr(3)));
    FPosition := StrToInt(ParamStr(4));
  end;
end;

function TForm1.RunTest: Integer;
begin

end;

procedure TForm1.FormActivate(Sender: TObject);
var
  Res : Integer;
begin
  if FirstTime then
  begin
    FirstTime := False;
    oToolkit := CreateToolkitWithBackDoor;
    if ReadParams then
    begin
      oToolkit.Configuration.DataDirectory := FDataPath;
      Res := oToolkit.OpenToolkit;
      if Res = 0 then
      begin
        RunTest;
      end
      else
        ShowMessage('Error ' + IntToStr(Res) + ' opening the toolkit');

    end
    else
      ShowMessage('Invaild number of parameters');
  end;
end;

procedure TForm1.DoProgress(const s: string);
begin
  lblProgress.Caption := s;
  lblProgress.Refresh;
  Application.ProcessMessages;
end;

end.
 
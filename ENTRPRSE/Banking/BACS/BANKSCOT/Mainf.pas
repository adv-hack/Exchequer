unit Mainf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, csvp, StdCtrls, TCustom, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    btnStart: TSBSButton;
    btnClose: TSBSButton;
    lblPleaseWait: TLabel;
    lblProgress: TLabel;
    OpenDialog1: TOpenDialog;
    fpCSV: TCsvFileParser;
    procedure btnStartClick(Sender: TObject);
    procedure fpCSVReadLine(LineNo: Integer; AList: TStrings);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    FList : TStringList;
    procedure AmendFile(const s : string);
    procedure ShowProgress(const s : string);
    procedure SetNegative(var s : string);
    function DoubleQuote(const s : string) : string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const
  iAmount = 1;
  iType = 4;

  sDebit = 'D';

procedure TForm1.AmendFile(const s: string);
begin
  Screen.Cursor := crHourGlass;
  btnStart.Enabled := False;
  btnClose.Enabled := False;
  lblPleaseWait.Visible := True;
  FList := TStringList.Create;
  Try
    fpCSV.FileName := s;
    fpCSV.Execute;
    FList.SaveToFile(s);
  Finally
    FList.Free;
  End;
  lblPleaseWait.Visible := False;
  ShowProgress('');
  Screen.Cursor := crDefault;
  btnStart.Enabled := True;
  btnClose.Enabled := True;
  ShowMessage('Process complete');
end;

procedure TForm1.btnStartClick(Sender: TObject);
begin
  OpenDialog1.InitialDir := ExtractFilePath(ParamStr(0));
  if OpenDialog1.Execute then
    AmendFile(OpenDialog1.FileName);
end;

procedure TForm1.ShowProgress(const s: string);
begin
  lblProgress.Caption := s;
  lblProgress.Refresh;
  Application.ProcessMessages;
end;

procedure TForm1.fpCSVReadLine(LineNo: Integer; AList: TStrings);
var
  sAmount : string;
  i : integer;
begin
  sAmount := AList[iAmount];
  if AList[iType] = sDebit then
    SetNegative(sAmount);
  sAmount := DoubleQuote(sAmount);
  for i := 0 to Pred(AList.Count) do
    AList[i] := DoubleQuote(AList[i]);

  FList.Add(Format('%s,%s,%s,%s,%s,%s,%s,%s', [AList[0], sAmount,
                                               AList[2], AList[3],
                                               AList[4], AList[5],
                                               AList[6], AList[7]]));
  ShowProgress(FList[Pred(FList.Count)]);
end;

procedure TForm1.SetNegative(var s: string);
var
  i : Integer;
begin
  i := 1;
  while (i < Length(s)) and (s[i] = ' ') do inc(i);
  if i > 1 then
    s[i-1] := '-'
  else
    s := '-' + s;
end;


function TForm1.DoubleQuote(const s: string): string;
begin
  Result := '"' + s + '"';
end;

procedure TForm1.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.

unit ImpProgf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Enterprise04_TLB, ImpObj;

type
  TfrmImportStatement = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FirstTime, FirstProg : Boolean;
    FBankAccount : IBankAccount;
    FMapFilename, FFilename : string;
    FToolkit : IToolkit;
    procedure Init;
    procedure DoProgress(Sender : TObject; CurrentRec, TotalRec : longint);
  public
    { Public declarations }
    procedure ShowProgress;
    property BankAccount : IBankAccount read FBankAccount write FBankAccount;
    property Filename : string read FFilename write FFilename;
    property MapFilename : string read FMapFilename write FMapFilename;
    property Toolkit : IToolkit read FToolkit write FToolkit;
  end;

var
  frmImportStatement: TfrmImportStatement;

implementation

{$R *.dfm}

procedure TfrmImportStatement.FormShow(Sender: TObject);
begin
  if FirstTime then
  begin
    FirstTime := False;
  end;
end;

procedure TfrmImportStatement.FormCreate(Sender: TObject);
begin
  Init;
end;

procedure TfrmImportStatement.DoProgress(Sender: TObject; CurrentRec,
  TotalRec: Integer);
begin
  if FirstProg then
  begin
    FirstProg := False;
    ProgressBar1.Max := TotalRec;
    ProgressBar1.Step := 10;
  end;
  Label1.Caption := Format('Importing Statement. Line %d of %d', [CurrentRec, TotalRec]);
{  ProgressBar1.Step := 100 div TotalRec;
  ProgressBar1.StepIt;}
  if (CurrentRec mod 10) = 0 then
  begin
    ProgressBar1.StepIt;
    Label1.Refresh;
    ProgressBar1.Refresh;
    Application.ProcessMessages;
  end;
end;

procedure TfrmImportStatement.ShowProgress;
begin
  with TStatementImporter.Create do
  Try
    BankAccount := FBankAccount;
    Toolkit := FToolkit;
    Filename := FFilename;
    MapFilename := FMapFilename;
    OnProgress := DoProgress;
    Init;
    Execute;
  Finally
    Free;
    Close;
  End;

end;

procedure TfrmImportStatement.Init;
begin
  FirstTime := True;
  FirstProg := True;
end;

Initialization
  frmImportStatement := nil;

end.

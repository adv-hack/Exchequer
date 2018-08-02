unit CompleteF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseF, EnterToTab, StdCtrls, ExtCtrls;

type
  TfrmConversionComplete = class(TfrmCommonBase)
    btnClose: TButton;
    ScrollBox1: TScrollBox;
    panHeader: TPanel;
    Label1: TLabel;
    panExchDllIni: TPanel;
    Label4: TLabel;
    panPostConversion: TPanel;
    Label2: TLabel;
    lblPostConversionChecks: TLabel;
    lblExchDll: TLabel;
    panCompanyDetails: TPanel;
    Label6: TLabel;
    lblCompanyReport: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure lblExchDllClick(Sender: TObject);
    procedure lblCompanyReportClick(Sender: TObject);
    procedure lblPostConversionChecksClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

Uses oConvertOptions, CompanyReport, APIUtil;

//=========================================================================

procedure TfrmConversionComplete.FormCreate(Sender: TObject);
Var
  NextTopL : LongInt;

  Procedure SetupPanel (Const ThePanel :  TControl; Var NextTop : LongInt);
  Begin { SetupPanel }
    If ThePanel.Visible Then
      With ThePanel Do
      Begin
        Top := NextTop;
        Inc (NextTop, Height);

        Left := 0;
        Width := 419;
      End; { With }
  End; { SetupPanel }

begin
  inherited;

  Caption := Application.Title;

  panHeader.Visible := True;
  panExchDllIni.Visible := ConversionOptions.coWarnings[cowExchDll];
  panCompanyDetails.Visible := True;

  NextTopL := 0;
  SetupPanel (panHeader, NextTopL);
  SetupPanel (panExchDllIni, NextTopL);
  SetupPanel (panPostConversion, NextTopL);
  SetupPanel (panCompanyDetails, NextTopL);
end;

//-------------------------------------------------------------------------

procedure TfrmConversionComplete.lblPostConversionChecksClick(Sender: TObject);
begin
  Application.HelpContext(lblPostConversionChecks.HelpContext);
end;

//-------------------------------------------------------------------------

procedure TfrmConversionComplete.lblExchDllClick(Sender: TObject);
begin
  RunFile (ConversionOptions.coSQLDirectory + 'ExchDll.Ini');
end;

//-------------------------------------------------------------------------

procedure TfrmConversionComplete.lblCompanyReportClick(Sender: TObject);
var
  oCompanyReport : TCompanyReport;
begin
  oCompanyReport := TCompanyReport.Create;
  Try
    oCompanyReport.Print;
  Finally
    oCompanyReport.Free;
  End; // Try..Finally
end;

//=========================================================================


end.

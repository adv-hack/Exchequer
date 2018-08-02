unit ReadyToConvertF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseF, StdCtrls, EnterToTab, ExtCtrls;

type
  TfrmReadyToConvert = class(TfrmCommonBase)
    btnContinue: TButton;
    btnClose: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblExchequerPervasiveDirectory: TLabel;
    lblExchequerSQLDirectory: TLabel;
    Label4: TLabel;
    lblExchequerPervasiveCompanies: TLabel;
    Label5: TLabel;
    lblExchequerSQLServer: TLabel;
    Label7: TLabel;
    lblExchequerSQLDatabase: TLabel;
    Label8: TLabel;
    scrlWarnings: TScrollBox;
    panNoUsers: TPanel;
    lblNoUsers: TLabel;
    chkNoUsers: TCheckBox;
    panBackupTaken: TPanel;
    lblBackupTaken: TLabel;
    chkBackupTaken: TCheckBox;
    panOverwriteDatabase: TPanel;
    lblOverwriteDatabase: TLabel;
    chkOverwriteDatabase: TCheckBox;
    panPreConversionChecks: TPanel;
    lblPreConversionChecks: TLabel;
    chkPreConversionChecks: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnContinueClick(Sender: TObject);
    procedure DoCheckyChecky(Sender: TObject);
    procedure lblOverwriteDatabaseClick(Sender: TObject);
    procedure lblBackupTakenClick(Sender: TObject);
    procedure lblNoUsersClick(Sender: TObject);
    procedure lblPreConversionChecksClick(Sender: TObject);
  private
    { Private declarations }
    Procedure BuildList;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

Uses oConvertOptions;

//=========================================================================

procedure TfrmReadyToConvert.FormCreate(Sender: TObject);
begin
  inherited;

  Caption := Application.Title;

  lblExchequerPervasiveDirectory.Caption := ConversionOptions.coPervasiveDirectory;
  lblExchequerPervasiveCompanies.Caption := IntToStr(ConversionOptions.coCompanyCount);

  lblExchequerSQLDirectory.Caption := ConversionOptions.coSQLDirectory;
  lblExchequerSQLServer.Caption := ConversionOptions.coDataSource;
  lblExchequerSQLDatabase.Caption := ConversionOptions.coDatabaseName;

  ModifyCaptions ('%DatabaseName%', ConversionOptions.coDatabaseName, [chkOverwriteDatabase, lblOverwriteDatabase]);
  ModifyCaptions ('%SQLSERVER%', ConversionOptions.coDataSource, [lblOverwriteDatabase]);

  // Configure Scroll-Box Scroll Bar - doesn't work if you set them at Design-Time!
  scrlWarnings.VertScrollBar.Position := 0;
  scrlWarnings.VertScrollBar.Tracking := True;

  // Decide which panels to show and re-arrange panels on form to look nice and pretty
  panPreConversionChecks.Visible := True;
  panNoUsers.Visible := True;
  panBackupTaken.Visible := True;
  panOverwriteDatabase.Visible := True;

  BuildList;
end;

//-------------------------------------------------------------------------

Procedure TfrmReadyToConvert.BuildList;
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
        Width := 490;
      End; { With }
  End; { SetupPanel }

Begin { BuildList }
  NextTopL := 0;

  SetupPanel (panPreConversionChecks, NextTopL);
  SetupPanel (panNoUsers, NextTopL);
  SetupPanel (panBackupTaken, NextTopL);
  SetupPanel (panOverwriteDatabase, NextTopL);

  DoCheckyChecky(Self);
End; { BuildList }

//-------------------------------------------------------------------------

procedure TfrmReadyToConvert.DoCheckyChecky(Sender: TObject);
begin
  btnContinue.Enabled := chkPreConversionChecks.Checked And
                         chkNoUsers.Checked And
                         chkBackupTaken.Checked and
                         chkOverwriteDatabase.Checked;
end;

//------------------------------

procedure TfrmReadyToConvert.lblNoUsersClick(Sender: TObject);
begin
  chkNoUsers.Checked := True;
  DoCheckyChecky(Sender);
end;

//------------------------------

procedure TfrmReadyToConvert.lblOverwriteDatabaseClick(Sender: TObject);
begin
  chkOverwriteDatabase.Checked := True;
  DoCheckyChecky(Sender);
end;

//------------------------------

procedure TfrmReadyToConvert.lblBackupTakenClick(Sender: TObject);
begin
  chkBackupTaken.Checked := True;
  DoCheckyChecky(Sender);
end;

//------------------------------

procedure TfrmReadyToConvert.lblPreConversionChecksClick(Sender: TObject);
begin
  chkPreConversionChecks.Checked := True;
  DoCheckyChecky(Sender);
end;

//-------------------------------------------------------------------------

procedure TfrmReadyToConvert.btnContinueClick(Sender: TObject);
begin
  If btnContinue.Enabled Then
  Begin
    ModalResult := mrOK;
  End; // If btnContinue.Enabled
end;

//=========================================================================



end.

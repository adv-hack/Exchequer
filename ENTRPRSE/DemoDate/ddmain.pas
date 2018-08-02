unit ddmain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls, ddObjs, ddLog;

type
  TfrmMain = class(TForm)
    pnlProgress: TPanel;
    Label3: TLabel;
    Panel2: TPanel;
    Label1: TLabel;
    edtDataPath: TEdit;
    SpeedButton1: TSpeedButton;
    UpDown1: TUpDown;
    edtYears: TEdit;
    Label2: TLabel;
    btnUpdate: TButton;
    btnClose: TButton;
    lblProgress: TLabel;
    Button1: TButton;
    edtTest: TEdit;
    Button2: TButton;
    chkCancel: TCheckBox;
    Button3: TButton;
    Button4: TButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtDataPathExit(Sender: TObject);
  private
    { Private declarations }
    OriginalHeight : Integer;
    FLogFile : TLogFile;
    procedure ShowProgress(const FName : string; RecNo, TotalRecs : longint; var Abort : Boolean);
    procedure RunUpdater(Updater : TDataFileUpdater);
    function IsValidCompanyData(const DataPath : string) : Boolean;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  BrwseDir, VarConst, ApiUtil, SQLUtils;

{$R *.dfm}

const
  AppVersion = 'v6.01.001';

procedure TfrmMain.RunUpdater(Updater: TDataFileUpdater);
begin
  with Updater do
  Try
    OnProgress := ShowProgress;
    DataPath := IncludeTrailingBackslash(edtDataPath.Text);
    IncrementYears := StrToInt(edtYears.Text);
    LogFile := FLogFile;
    Execute;
  Finally
    Free;
  End;
end;

procedure TfrmMain.ShowProgress(const FName : string; RecNo, TotalRecs: Integer;
  var Abort: Boolean);
begin
  lblProgress.Caption := Format('%s  : %d of %d', [FName, RecNo, TotalRecs]);
  lblProgress.Refresh;
  Abort := chkCancel.Checked;
  Application.ProcessMessages;
end;

procedure TfrmMain.SpeedButton1Click(Sender: TObject);
var
  Found : Boolean;
begin
  with TBrowseDirDialog.Create do
  Try
    Found := False;
    Directory := edtDataPath.Text;
    while not Found do
    begin
      if Execute then
      begin
        if IsValidCompanyData(Directory) then
        begin
          edtDataPath.Text := Directory;
          Found := True;
          btnUpdate.Enabled := True;
        end;
      end
      else
        Found := True;
    end;
  Finally
    Free;
  End;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := Application.Title + ' ' + AppVersion;
  edtDataPath.Text := ExtractFilePath(Application.ExeName);
  FLogFile := TLogFile.Create(edtDataPath.Text + Application.Title + '.log');
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.btnUpdateClick(Sender: TObject);
var
  s : string;
  msgRes : Integer;
begin
  MsgRes :=  msgbox('Is everyone logged out of this installation of Enterprise?',
              mtConfirmation, [mbYes, mbNo, mbCancel], mbYes, Application.Title);
  if MsgRes = IDYes then
  begin
    Screen.Cursor := crHourGlass;
    btnClose.Enabled := False;
    ClientHeight := OriginalHeight;
    Application.ProcessMessages;

    RunUpdater(TCustUpdater.Create);
    RunUpdater(TInvUpdater.Create);
    RunUpdater(TIDetailUpdater.Create);
    RunUpdater(TStockUpdater.Create);
    RunUpdater(THistoryUpdater.Create);
    RunUpdater(TJobUpdater.Create);
    RunUpdater(TPwrdUpdater.Create);
    RunUpdater(TMiscUpdater.Create);
    RunUpdater(TJobMiscUpdater.Create);
    RunUpdater(TJobDetlUpdater.Create);
    RunUpdater(TMLocUpdater.Create);
    RunUpdater(TSysUpdater.Create);
    RunUpdater(TMultiBuyUpdater.Create);

    s := 'Update Complete.';
    if FLogFile.HasEntries then
      s := s + ' There were some errors. Details in log file. (' + Trim(FLogFile.Filename) + ')';
    OriginalHeight := ClientHeight;
    ClientHeight := pnlProgress.Top - 1;
    Screen.Cursor := crDefault;
    btnClose.Enabled := True;
    Application.ProcessMessages;
    ShowMessage(s);
  end
  else
  if MsgRes = IDNo then
    msgbox('Please ensure that all users are logged'#10 +
                  'out before running the process.', mtInformation, [mbOK], mbOK, Application.Title);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(FLogFile) then
    FLogFile.Free;
end;

function TfrmMain.IsValidCompanyData(const DataPath: string): Boolean;
var
  Res : Integer;
begin
  Result := FileExists(DataPath + '\Cust\CustSupp.Dat');
  if not Result then
    MsgBox('Folder ' + DataPath + ' is not a valid Exchequer company data set.', mtError, [mbOK], mbOK, Application.Title);
end;

procedure TfrmMain.edtDataPathExit(Sender: TObject);
begin
  btnUpdate.Enabled := IsValidCompanyData(edtDataPath.text);
end;

end.

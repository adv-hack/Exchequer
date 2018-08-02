unit Configuration;

{ nfrewer440 16:25 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  StdCtrls, Buttons, Forms, ExtCtrls, Controls, Menus, ComCtrls, Classes , Windows,
  Messages, SysUtils,  Graphics,   Dialogs,iniFiles,usedllu, ImgList;

type
  TFrmConfiguration = class(TForm)
    pcConfig: TPageControl;
    tsDirectories: TTabSheet;
    Bevel1: TBevel;
    tsFilenames: TTabSheet;
    EdtClassic: TEdit;
    EdtEarnie: TEdit;
    EdtJobCard: TEdit;
    EdtBonus: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EdtLogfile: TEdit;
    BtnOk: TBitBtn;
    BtnCancel: TBitBtn;
    EdtEnterprise: TEdit;
    EdtDefaultExportDir: TEdit;
    SpeedButton2: TSpeedButton;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    EdtLogFiledir: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure Close1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure ChkBoxUseDefaultDirClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure pcConfigDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
  private
    fDefaultDir : String;
    fUseDefaultFileDir : Boolean;
    fLogFileDir : String;
    ini : TiniFile;
  protected
    Function GetDefaultDir : String;
    Function GetUseDefaultFileDir : Boolean;
    function GetLogFileDir : String;
    Function GetEnterpriseDir : String;

    Procedure SetDefaultDir(value : string);
    Procedure SetUseDefaultFileDir(Value : Boolean);
    Procedure SetLogFileDir(Value : String);
    Procedure SetEnterpriseDir(Value : String);
    function SelectDirectory : String;

    Function GetLogName : String;
    Procedure SetLogName(Value : String);
    Function GetEarnieName : String;
    Procedure SetEarnieName(Value : String);
    Function GetClassicName : String;
    Procedure SetClassicName(Value : String);
    Function GetJobCardName : String;
    Procedure SetJobCardName(Value : String);
    Function GetBonusName : String;
    Procedure SetBonusName(Value : String);


  published
    property DefaultDir  : String read GetDefaultDir write SetDefaultDir;
    property UseDefaultFileDir : Boolean read GetUseDefaultFileDir write SetUseDefaultFileDir;
    property LogFileDir : String read GetLogFileDir write SetLogFileDir;
    Property EnterpriseDir : String read GetEnterpriseDir Write SetEnterpriseDir;

    Property LogName : String read GetLogName write SetLogName;
    Property EarnieName : String read GetEarnieName write SetEarnieName;
    Property ClassicName : String read GetClassicName write SetClassicName;
    Property JobCardName : String read GetJobCardName write SetJobCardName;
    Property BonusName : String read GetBonusName write SetBonusName;
  public


  end;

Const
  iniName = 'earnie.ini';
  ExchDllName = 'ExchDll.ini';

var
  FrmConfiguration: TFrmConfiguration;

implementation

uses
  Directory;

{$R *.DFM}

procedure TFrmConfiguration.Close1Click(Sender: TObject);
begin
  Close;
end;

Function TfrmConfiguration.GetDefaultDir : String;
begin
  result := fDefaultDir;
end;

Function TfrmConfiguration.GetUseDefaultFileDir : Boolean;
begin
  result := fUseDefaultFileDir;
end;

function Tfrmconfiguration.GetLogFileDir : String;
begin
  result := fLogFileDir;
end;

Function Tfrmconfiguration.GetEnterpriseDir : String;
begin
  result := edtEnterprise.text;
end;

function TfrmConfiguration.GetLogName : String;
begin
  result := EdtLogFile.text;
end;

Procedure TfrmConfiguration.SetLogName(Value : String);
begin
  EdtLogFile.text := value;
end;

function TfrmConfiguration.GetEarnieName : String;
begin
  Result := edtEarnie.text;
end;

Procedure TfrmConfiguration.SetEarnieName(Value : String);
begin
  edtearnie.text := Value;
end;

function TfrmConfiguration. GetClassicName : String;
begin
  result := EdtClassic.Text;
end;

Procedure TfrmConfiguration.SetClassicName(Value : String);
begin
  edtClassic.text := value; 
end;


function TfrmConfiguration.GetJobCardName : String;
begin
  result := edtJobCard.text;
end;

Procedure TfrmConfiguration.SetJobCardName(Value : String);
begin
  edtJobCard.text := value;
end;

function TfrmConfiguration.GetBonusName : String;
begin
  result := EdtBonus.text;
end;

Procedure TfrmConfiguration.SetBonusName(Value : String);
begin
  EdtBonus.Text := value;
end;

Procedure TfrmConfiguration.SetEnterpriseDir(Value : String);
begin
  EdtEnterprise.Text :=  value;
end;

Procedure TfrmConfiguration.SetDefaultDir(Value : String);
begin
  EdtDefaultExportDir.text := value;
  fDefaultDir := value;
end;

Procedure TfrmConfiguration.SetUseDefaultFileDir(Value : boolean);
begin
//  ChkBoxUseDefaultDir.checked := value;
  fUseDefaultFileDir := value;
end;

Procedure Tfrmconfiguration.SetLogFileDir(Value : String);
begin
  fLogFileDir := Value;
  EdtLogFileDir.Text := Value;
end;

function TfrmConfiguration.SelectDirectory : String;
var
  FrmDirectory : TFrmDirectory;
begin
  result := '';
  FrmDirectory := TFrmDirectory.create(nil);
  try
    if FrmDirectory.Showmodal = mrOK then
    begin
      result := Trim(frmDirectory.directory);
      if result[length(result)] <> '\' then
        result := result + '\';
      frmDirectory.free;
    end;
  except

  end;
end;

procedure TFrmConfiguration.SpeedButton1Click(Sender: TObject);
begin
  LogFileDir := SelectDirectory;
end;

procedure TFrmConfiguration.SpeedButton2Click(Sender: TObject);
begin
  DefaultDir := SelectDirectory;
end;

procedure TFrmConfiguration.BtnOkClick(Sender: TObject);
var
  appDir : String;

begin
  AppDir := ExtractFIlePath(Application.ExeName);

  ini.WriteString('folders','logfile',logFileDir);
  ini.WriteString('folders','DefaultDir',DefaultDir);
  ini.WriteBool('folders','UseDefaultDir',UseDefaultFileDir);
//ini.WriteString('','Exchequer_Path',EnterpriseDir);
  ini.WriteString('folders','logFileName',LogName);
  ini.WriteString('folders','BonusName',BonusName);
  ini.WriteString('folders','ClassicName',classicName);
  ini.WriteString('folders','earnieName',EarnieName);
  ini.WriteString('folders','JobCardName',JobCardName);

  modalresult := mrOk;
end;

procedure TFrmConfiguration.ChkBoxUseDefaultDirClick(Sender: TObject);
begin
  UseDefaultFileDir := (sender as TCheckBox).checked
end;

procedure TFrmConfiguration.BtnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TFrmConfiguration.FormCreate(Sender: TObject);
var
  appDir : String;
  ExPath : Pchar;
  status : Integer;
begin
  pcConfig.ActivePageIndex := 0;
  try
    AppDir := ExtractFIlePath(Application.ExeName);
    ini := TiniFile.Create(AppDir + iniName);
    logfileDir := ini.ReadString('folders','logfile','');
    defaultDir := ini.ReadString('folders','DefaultDir','');
    UseDefaultFileDir := ini.ReadBool('folders','UseDefaultDir',false);

    LogName := ini.ReadString('folders','logFileName',LogName);
    BonusName := ini.ReadString('folders','BonusName',BonusName);
    ClassicName := ini.ReadString('folders','ClassicName',classicName);
    EarnieName := ini.ReadString('folders','earnieName',EarnieName);
    JobCardName := ini.ReadString('folders','JobCardName',JobCardName);
    try
      ExPath := StrAlloc(255);

      fillchar(Expath^,sizeof(ExPAth),#0);
      status := EX_GETDATAPATH(exPAth);
      if status = 0 then
      begin
        enterpriseDir := string(ExPath);
      end;
    finally
      StrDispose(ExPath);
    end;
  except

  end;

end;

procedure TFrmConfiguration.SpeedButton3Click(Sender: TObject);
begin
  EnterpriseDir := SelectDirectory;
end;

procedure TFrmConfiguration.pcConfigDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
const
  cLogFile = 'Directory ';
  cEnt =     'Exchequer ';
  cFilenames = 'Filenames';
var
  gap : integer;

begin
  inherited;
  gap := TPageControl(Control).Images.width+10;
  With Control.Canvas do
  begin
    Font.Size := 8;
    if TabIndex = 0 then
    begin
      Font.Color := clBlue;
      TextRect(Rect,rect.Left+gap + (gap div 2),rect.Top+3,cLogFile);
      TPAgeControl(Control).Images.Draw(Control.Canvas,Rect.Left+(gap div 2),Rect.Top+3, 0);
    end
    else
    if TabIndex = 1 then
    begin
      Font.Color := clGreen;
      TextRect(Rect,rect.Left+gap + (gap div 2),rect.Top+3,cEnt);
      TPAgeControl(Control).Images.Draw(Control.Canvas,Rect.Left+(gap div 2),Rect.Top+3, 1);
    end
    else
    begin
      Font.Color := clRed;
      TextRect(Rect,rect.Left+gap + (gap div 2),rect.Top+3,cFileNames);
      TPAgeControl(Control).Images.Draw(Control.Canvas,Rect.Left+(gap div 2),Rect.Top+3, 5);
    end

  end;
end;


end.

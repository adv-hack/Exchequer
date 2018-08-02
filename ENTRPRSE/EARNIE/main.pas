unit main;

{ nfrewer440 16:25 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,db, DBTables,contnrs, Spin,usedllu, Buttons, ExtCtrls, expEarn,
  ComCtrls, Menus, BorBtns, ExtDlgs, ImgList{,TKUtil}, MemMap, Crypto, StrUtil;

type

  TFrmMain = class(TForm)
    SaveDialog1: TSaveDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    OpenExportFile1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    Bevel1: TBevel;
    Logfile1: TMenuItem;
    Options1: TMenuItem;
    Configuration1: TMenuItem;
    Help1: TMenuItem;
    ViewLastExport1: TMenuItem;
    OpenDialog1: TOpenDialog;
    BtnPrev: TBitBtn;
    BtnNext: TBitBtn;
    nbPages: TNotebook;
    Label2: TLabel;
    Label4: TLabel;
    lblFromTrans: TLabel;
    EdFrmTrans: TEdit;
    EdToTrans: TEdit;
    lblToTrans: TLabel;
    Label3: TLabel;
    EdWkMnthNo: TSpinEdit;
    Label1: TLabel;
    RadioButton2: TRadioButton;
    RadioButton1: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton3: TRadioButton;
    btnCancel: TButton;
    chkwkMnthNo: TCheckBox;
    cbThirdParty: TCheckBox;
    MenuImages: TImageList;
    About1: TMenuItem;
    Bevel2: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure chkwkMnthNoClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Configuration1Click(Sender: TObject);
    procedure Logfile1Click(Sender: TObject);
    procedure BtnLogFilesClick(Sender: TObject);
    procedure BtnConfigClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure BtnLogFileClick(Sender: TObject);
    procedure ViewLastExport1Click(Sender: TObject);
    procedure OpenExportFile1Click(Sender: TObject);
    procedure BtnNextClick(Sender: TObject);
    procedure BtnPrevClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    fExportType : TExportType;
    expDir : String;
    LogDir : String;
    UseDefDir : Boolean;
    fLastExport : String;
{    fDatName  : String;}
    procedure RunExport;
  protected
    function  GetNextLogFileName(Var lname : String) : Boolean;
    Function  GetNextExpName(var fname : String) : Boolean;
    Procedure SetExportType(ExType : TexportType);
    function  GetDatName : String;
  public
    { Public declarations }
    property ExportType : TExportType read fExportType Write SetExportType default earnie;
    property LastExport : String read fLastExport write fLastExport;
    property DatName    : String read GetDatName;

  end;

var
  FrmMain: TFrmMain;

implementation

uses Configuration, LogFiles, Status, LogFileViewer, ExchequerRelease;

{$R *.DFM}
function TfrmMain.GetDatName : String;
begin
  result := '';
  with frmConfiguration do
  case ExportType of
    Classic   : result := ClassicName;
    bonus     : result := BonusName;
    Earnie    : result := EarnieName;
    JobCard   : result := JobCardName;
  end;
end;

Procedure TfrmMain.SetExportType(ExType : TexportType);
begin
  fExportType := exType;

end;


function TfrmMain.GetNextLogFileName(Var lName : String) : Boolean;
var
  Ext : String;
  cnt     : integer;

begin
  try
{    result := false;}
    with FrmConfiguration do
      lName := LogFileDir + LogName;
    Cnt := 0;
    Ext := '.LOG';{ExtractFileEXT(lName);}
    lName := Copy(lName,0,pos(EXT,lName)-1);
    repeat
      inc(Cnt);
    until Not(fileexists(lName+inttostr(Cnt)+ext));
    lName := lName + inttostr(Cnt)+ Ext;
    Result := true;
  except
    result := false;
  end;
end;

Function TfrmMain.GetNextExpName(Var Fname : String) : Boolean;
var
  Ext : String;
  cnt     : integer;

begin
  try
{    result := false;}
    fName := FrmConfiguration.DefaultDir + DatName;
{    Cnt := 0;
    Ext := ExtractFileEXT(DatName);
    fName := Copy(fName,0,pos(EXT,fName)-1);
    repeat
      inc(Cnt);
    until Not(fileexists(fName+inttostr(Cnt)+ext));
    fName := fName + inttostr(Cnt)+ Ext;}
    Result := true;
  except
    result := false;
  end;
end;

procedure TFrmMain.RunExport;
var
  lName,fName : String;
  frmDoExport : TfrmDoExport;
begin
  try
    if (GetNextExpName(fname)) and (GetNextLogFileName(lName)) then
    begin

      cursor := crHourGlass;
{      Animate1.visible := true;
      Animate1.Active := true;}

{      LblExport.visible := true;}

//      BtnExport.enabled := false;
//      BtnCancel.enabled := true;

      try
        frmDoExport := TfrmDoExport.create(application);
        frmDoExport.Show;
        frmDoExport.Refresh;
        frmDoExport.ExportToEarnie(edFrmTrans.text,EdToTrans.text, EdWkMnthNo.value,ExportType
        , not cbThirdParty.Checked, fName, lName);
        frmDoExport.Hide;
      finally
        frmDoExport.Release;
      end;{try}

{      Animate1.Active := false;}
  //    Animate1.visible := False;

{      LblExport.visible := false;}

      if not abortexport then
      begin
        MessageDlg('Exporting process complete.',mtinformation,[mbok],0);
        LastExport := fname;
      end;
      end
      else
      begin
        MessageDlg('Could Not Create Export/LogFiles !',mtinformation,[mbok],0);
        LastExport := '';
      end;
  finally
//    BtnExport.enabled := true;
//    BtnCancel.enabled := false;
    AbortExport := false;
    cursor := crDefault;
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
const
  Code = #206 + #139 + #164 + #167 + #188 + #175 + #42 + #114 + #59 + #172 + #149;
  TransactionKey = 0;
var
  Res : integer;
  tranRec  : TBatchTHRec;
  TranLinesRec  : TBatchLinesRec;
  pPath : PChar;
  pCode : array[0..255] of char;
begin
  nbPages.PageIndex := 0;

  if GlobalEntMap.Defined then
    begin
      pPath := StrAlloc(255);
      StrPCopy(pPath, GlobalEntMap.CompanyDataPath);
      Res := Ex_InitDllPath(pPath, GlobalEntMap.CurrencyVersion in [ccyEuro, ccyGlobal]);
      StrDispose(pPath);
    end
  else Res := 0;

  if Res = 0 then
    begin

      {DLL BackDoor}
      ChangeCryptoKey(606010);
      StrPCopy(pCode, Decode(CODE));
      Ex_SetReleaseCode(pCode);
      Res := Ex_InitDll;

      if res = 0 then
        begin
          if GetTransRecord(B_GetGeq,false,tranRec,tranLinesRec,'TSH',TransactionKey) then
          begin
             edFrmTrans.text := TranRec.ourref;
             if GetTransRecord(B_GetLesseq,false,tranRec,tranLinesRec,'TSI',TransactionKey) then
               edToTrans.text := TranRec.OurRef;
          end;
          exportType := Earnie;
        end
      else begin
        MessageDlg(format('Ex_InitDll, error Code %d - see help for details',[res]),mterror,[mbOK],0);
    //    BtnExport.Enabled := false;
      end;
    end
  else MessageDlg(format('Ex_InitDllPath, error Code %d - see help for details',[res]),mterror,[mbOK],0);
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  Ex_CloseDll;
end;

function getstringlist : TStringList;
begin
  result := nil;
end;

procedure TFrmMain.RadioButton2Click(Sender: TObject);
begin
  if (Sender as TRadioButton).checked then exportType := classic;
end;

procedure TFrmMain.RadioButton3Click(Sender: TObject);
begin
  if (Sender as TRadioButton).checked then exportType := Bonus;
end;

procedure TFrmMain.RadioButton5Click(Sender: TObject);
begin
  if (Sender as TRadioButton).checked then exportType := JobCard;
end;

procedure TFrmMain.RadioButton1Click(Sender: TObject);
begin
  if (Sender as TRadioButton).checked then exportType := Earnie;
end;

procedure TFrmMain.RadioButton4Click(Sender: TObject);
begin
  if (Sender as TRadioButton).checked then exportType := TimeSheet;
end;

procedure TFrmMain.chkwkMnthNoClick(Sender: TObject);
begin
  EdWkMnthNo.Enabled := (sender as TCheckBox).checked;
  if not EdWkMnthNo.Enabled then
    EdWkMnthNo.Value := 0;  //set to 0
end;

procedure TFrmMain.FormResize(Sender: TObject);
begin
{  height := 302;}
end;

procedure TFrmMain.Configuration1Click(Sender: TObject);
begin
  FrmConfiguration := TFrmConfiguration.create(Self);
  if FrmConfiguration.ShowModal = mrOk then
  begin
    LogDir := frmCOnfiguration.LogFileDir;
    expDir := FrmConfiguration.DefaultDir;
    UseDefDir := FrmConfiguration.UseDefaultFileDir;
  end;
end;

procedure TFrmMain.Logfile1Click(Sender: TObject);
begin
  frmLogFiles := TfrmLogfiles.create(self,frmConfiguration.LogFileDir);
  FrmLogFiles.ShowModal;
end;

procedure TFrmMain.BtnLogFilesClick(Sender: TObject);
begin
  LogFile1Click(Sender);
end;

procedure TFrmMain.BtnConfigClick(Sender: TObject);
begin
  Configuration1CLick(Sender);
end;

procedure TFrmMain.BtnCloseClick(Sender: TObject);
begin
  abortExport := true;
  close;
end;

procedure TFrmMain.Close1Click(Sender: TObject);
begin
  abortExport := true;
  Close;
end;

procedure TFrmMain.BtnLogFileClick(Sender: TObject);
begin
  LogFile1Click(Sender);
end;

procedure TFrmMain.ViewLastExport1Click(Sender: TObject);
begin
  frmLogFileViewer := TfrmLogfileViewer.create(self,LastExport);
  frmLogFileViewer.Caption := format('Export File %s',[LastExport]);
  FrmLogFileViewer.ShowModal;
end;

procedure TFrmMain.OpenExportFile1Click(Sender: TObject);
begin
  With OpenDialog1 do
  begin
    if execute then
    begin
      frmLogFileViewer := TfrmLogfileViewer.create(self,filename);
      frmLogFileViewer.Caption := format('Export File %s',[Filename]);
      FrmLogFileViewer.ShowModal;
    end;
  end;
end;

procedure TFrmMain.BtnNextClick(Sender: TObject);
begin
  with nbPages do begin
    if BtnNext.Caption = 'Run &Export' then
      begin
        RunExport;
        nbPages.PageIndex := 0;
      end
    else begin
      PageIndex := PageIndex + 1;
      BtnPrev.enabled := Pageindex > 0;
    end;{if}

    if PageIndex = 2 then BtnNext.Caption := 'Run &Export'
    else BtnNext.Caption := '&Next  >>';
  end;{with}
end;

procedure TFrmMain.BtnPrevClick(Sender: TObject);
begin
  with nbPages do begin
    PageIndex := PageIndex - 1;
    if Pageindex = 0 then
      (sender as TBitBtn).enabled := false;
{    BtnNext.enabled := ActivePage.Pageindex < 2;}

    if PageIndex = 2 then BtnNext.Caption := 'Run &Export'
    else BtnNext.Caption := '&Next  >>';
  end;{with}
end;

procedure TFrmMain.btnCancelClick(Sender: TObject);
begin
  abortExport := true;
  Close;
end;

procedure TFrmMain.About1Click(Sender: TObject);
const
  BuildNo = '017';
begin
  { CJS - 2013-07-08 - ABSEXCH-14438 - update branding and copyright }
  MessageDlg('Exchequer Timesheet Export' + #13#13 + 'Version: ' + ExchequerModuleVersion(emEarnie, BuildNo)
  + #13#13 + GetCopyrightMessage + #13 + 'All rights reserved.', mtInformation,[mbOK],0);
end;

end.

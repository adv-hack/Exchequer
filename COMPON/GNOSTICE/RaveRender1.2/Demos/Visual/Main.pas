unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RPBase, RPSystem, RPDefine, StdCtrls, RPRave, RVCsBars, ExtCtrls, ShellAPI,
  gtRPRender_Excel, gtRPRender_Text, gtRPRender_WMF, gtRPRender_EMF,
  gtRPRender_BMP, gtRPRender_GIF, gtRPRender_Graphic, gtRPRender_JPEG,
  gtRPRender_RTF, gtRPRender_HTML, RPRender, gtRPRender_Main,
  gtRPRender_Document, gtRPRender_PDF;

type
  TForm1 = class(TForm)
    ReportSystem1: TReportSystem;
    ReportLB: TListBox;
    DescMemo: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    RaveProject: TRaveProject;
    Button2: TButton;
    Panel1: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Image1: TImage;
    gtRPRenderPDF1: TgtRPRenderPDF;
    gtRPRenderHTML1: TgtRPRenderHTML;
    gtRPRenderRTF1: TgtRPRenderRTF;
    gtRPRenderJPEG1: TgtRPRenderJPEG;
    gtRPRenderGIF1: TgtRPRenderGIF;
    gtRPRenderBMP1: TgtRPRenderBMP;
    gtRPRenderEMF1: TgtRPRenderEMF;
    gtRPRenderWMF1: TgtRPRenderWMF;
    gtRPRenderText1: TgtRPRenderText;
    gtRPRenderExcel1: TgtRPRenderExcel;
    chkShowSetupDialog: TCheckBox;
    chkShowProgress: TCheckBox;
    Panel2: TPanel;
    Image2: TImage;
    procedure FormCreate(Sender: TObject);
    procedure ReportLBClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
		procedure Button2Click(Sender: TObject);
		procedure RaveProjectCreate(Sender: TObject);
		procedure Label10Click(Sender: TObject);
		procedure chkShowSetupDialogClick(Sender: TObject);
		procedure chkShowProgressClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ShowNotice: boolean = true;

implementation

uses EMailData;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
	AFileName: string;
begin
	RaveProject.Open;
	RaveProject.GetReportList(ReportLB.Items,true);
	AFileName := ExtractFilePath(ParamStr(0)) + 'Gnostice.bmp';
	if not FileExists(AFileName) then
	with Image1 do
	begin
		Canvas.Font.Color := $00E5E5E5;
		Canvas.Font.Name := 'Impact';
		Canvas.Font.Size := 36;
		Canvas.TextOut(5, 5, 'Gnostice');
		Image1.Picture.SaveToFile(AFileName);
	end;
	gtRPRenderPDF1.BackgroundImage.LoadFromFile(AFileName);
	gtRPRenderHTML1.BackgroundImage.LoadFromFile(AFileName);
	gtRPRenderRTF1.BackgroundImage.LoadFromFile(AFileName);
	gtRPRenderBMP1.BackgroundImage.LoadFromFile(AFileName);
	gtRPRenderJPEG1.BackgroundImage.LoadFromFile(AFileName);
	gtRPRenderGIF1.BackgroundImage.LoadFromFile(AFileName);
	gtRPRenderEMF1.BackgroundImage.LoadFromFile(AFileName);
	gtRPRenderWMF1.BackgroundImage.LoadFromFile(AFileName);
end;

procedure TForm1.ReportLBClick(Sender: TObject);
begin
	RaveProject.SelectReport(ReportLB.Items[ReportLB.ItemIndex],true);
	RaveProject.ReportDescToMemo(DescMemo);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  RaveProject.Close;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  RaveProject.Execute;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  ReportLB.ItemIndex := 0;
	ReportLBClick(nil);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  RaveProject.Design;
  RaveProject.GetReportList(ReportLB.Items,true);
end;

procedure TForm1.RaveProjectCreate(Sender: TObject);
begin
	RVCsBars.RaveRegister;
end;

procedure TForm1.Label10Click(Sender: TObject);
begin
	ShellExecute( 0, nil, 'http://www.pragnaan.com', nil, nil, SW_MAXIMIZE);
end;

procedure TForm1.chkShowSetupDialogClick(Sender: TObject);
begin
	gtRPRenderPDF1.ShowSetupDialog := TCheckBox(Sender).Checked;
	gtRPRenderHTML1.ShowSetupDialog := TCheckBox(Sender).Checked;
	gtRPRenderRTF1.ShowSetupDialog := TCheckBox(Sender).Checked;
	gtRPRenderExcel1.ShowSetupDialog := TCheckBox(Sender).Checked;
	gtRPRenderText1.ShowSetupDialog := TCheckBox(Sender).Checked;
	gtRPRenderBMP1.ShowSetupDialog := TCheckBox(Sender).Checked;
	gtRPRenderJPEG1.ShowSetupDialog := TCheckBox(Sender).Checked;
	gtRPRenderGIF1.ShowSetupDialog := TCheckBox(Sender).Checked;
	gtRPRenderEMF1.ShowSetupDialog := TCheckBox(Sender).Checked;
	gtRPRenderWMF1.ShowSetupDialog := TCheckBox(Sender).Checked;
end;

procedure TForm1.chkShowProgressClick(Sender: TObject);
begin
	gtRPRenderPDF1.ShowProgress := TCheckBox(Sender).Checked;
	gtRPRenderHTML1.ShowProgress := TCheckBox(Sender).Checked;
	gtRPRenderRTF1.ShowProgress := TCheckBox(Sender).Checked;
	gtRPRenderExcel1.ShowProgress := TCheckBox(Sender).Checked;
	gtRPRenderText1.ShowProgress := TCheckBox(Sender).Checked;
	gtRPRenderBMP1.ShowProgress := TCheckBox(Sender).Checked;
	gtRPRenderJPEG1.ShowProgress := TCheckBox(Sender).Checked;
	gtRPRenderGIF1.ShowProgress := TCheckBox(Sender).Checked;
	gtRPRenderEMF1.ShowProgress := TCheckBox(Sender).Checked;
	gtRPRenderWMF1.ShowProgress := TCheckBox(Sender).Checked;
end;



end.
 

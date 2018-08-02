unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RPDefine, RPBase, RPSystem, StdCtrls, Db, DBTables, RPShell, RPTable,
  RPDBTabl, RPMemo, RPDBUtil, ExtCtrls, ShellAPI,
  gtRPRender_Text, gtRPRender_WMF, gtRPRender_EMF, gtRPRender_BMP,
  gtRPRender_GIF, gtRPRender_Graphic, gtRPRender_JPEG, gtRPRender_RTF,
  gtRPRender_HTML, RPRender, gtRPRender_Main, gtRPRender_Document,
  gtRPRender_PDF, gtRPRender_Excel;

type
  TfrmMain = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    lbReports: TListBox;
    memoDescription: TMemo;
    btnPrint: TButton;
    ReportSystem: TReportSystem;
    DBTablePrinter1: TDBTablePrinter;
    DBTablePrinter1SYMBOL: TDBTableColumn;
    DBTablePrinter1CO_NAME: TDBTableColumn;
    DBTablePrinter1EXCHANGE: TDBTableColumn;
    DBTablePrinter1CUR_PRICE: TDBTableColumn;
    DBTablePrinter1RATING: TDBTableColumn;
    DBTablePrinter1BodyHeader: TTableSection;
    DetailShell1: TDetailShell;
    ReportSystem1: TReportSystem;
    DBTablePrinter2: TDBTablePrinter;
    DBTablePrinter1CustNo: TDBTableColumn;
    DBTablePrinter1Company: TDBTableColumn;
    DBTablePrinter1Phone: TDBTableColumn;
    DBTablePrinter1Contact: TDBTableColumn;
    DBTablePrinter1ReportHeader: TTableSection;
    TableSection1: TTableSection;
    DBTablePrinter3: TDBTablePrinter;
    DBTablePrinter2SaleDate: TDBTableColumn;
    DBTablePrinter2ShipDate: TDBTableColumn;
    DBTablePrinter2ItemsTotal: TDBTableColumn;
    DBTablePrinter2BodyHeader: TTableSection;
    DetailShell2: TDetailShell;
    TablePrinter1: TTablePrinter;
    TablePrinter1Name: TTableColumn;
    TablePrinter1Phone: TTableColumn;
    TablePrinter1Height: TTableColumn;
    TablePrinter1Notes: TTableColumn;
    TablePrinter1ReportHeader: TTableSection;
    TablePrinter1BodyHeader: TTableSection;
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
    procedure btnPrintClick(Sender: TObject);
    procedure ReportSystemPrint(Sender: TObject);
    procedure ReportSystemBeforePrint(Sender: TObject);
    procedure ReportSystemNewColumn(Sender: TObject);
    procedure ReportSystemPrintFooter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBTablePrinter1RATINGRowSetup(TableColumn: TTableColumn);
    procedure ReportSystem1Print(Sender: TObject);
    procedure DBTablePrinter3InitMaster(TablePrinter: TTablePrinter;
      var Valid: Boolean);
    procedure DetailShell2BodyBefore(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell);
    procedure DetailShell2RowAfter(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);
    procedure DetailShell2RowPrint(ReportPrinter: TBaseReport;
      ReportShell: TDetailShell; var Valid: Boolean);
    procedure TablePrinter1GetNextRow(TablePrinter: TTablePrinter;
      var Valid: Boolean);
    procedure TablePrinter1InitTable(TablePrinter: TTablePrinter;
      var Valid: Boolean);
    procedure TablePrinter1NameRowSetup(TableColumn: TTableColumn);
    procedure TablePrinter1PhoneRowSetup(TableColumn: TTableColumn);
    procedure TablePrinter1HeightRowSetup(TableColumn: TTableColumn);
    procedure TablePrinter1NotesRowSetup(TableColumn: TTableColumn);
		function ReportSystemPrintPage(Sender: TObject;
			var PageNum: Integer): Boolean;
		procedure lbReportsClick(Sender: TObject);
		procedure Label10Click(Sender: TObject);
		procedure chkShowSetupDialogClick(Sender: TObject);
		procedure chkShowProgressClick(Sender: TObject);
		procedure gtRPRenderEMail(Render: TRPRender;
			EMailInfo: TgtRPEMailInfo; var Continue: Boolean);
  private
    procedure Columns1(Sender: TObject);
    procedure Columns2(Sender: TObject);
    procedure DrawBox(Sender: TObject);
    procedure DrawBigBox(X1, Y1: double; Text: string; Report: TBaseReport);
    procedure DrawSmallBox(X1, Y1: double; Text: string; Report: TBaseReport);
    procedure Invoice(Sender: TObject);
    procedure DrawShadowBox(XPosition, YPosition, Width, Shadow: double;
      Report: TBaseReport);
    function RPFish(Sender: TObject; var PageNum: Integer): Boolean;
    procedure SimpleDemo(Sender: TObject);
    procedure OutputProc1(Report: TBaseReport);
    procedure OutputProc2(Report: TBaseReport);
    procedure OutputProc3(Report: TBaseReport);
    procedure OutputProc4(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  Index: word;

const
	ReportNames: array[0..11] of string = (
		'Colored Text Lines', 'Text Columns', 'Text Columns as Tables', 'Database Table',
    'Boxes with Text', 'Master-Detail Report', 'Invoice', 'BioLife from DBDEMOS', 'Envelopes', 'Simple Table', 'Chart', 'Database Reports');

  Names: array[1..5] of string[20] = ('Fred Flintstone','George Jetson',
   'Bugs Bunny','Mickey Mouse','Donald Duck');
  PhoneNums: array[1..5] of string[20] = ('1-800-CAVEMAN','1-800-SPROCKET',
   '1-800-CARROTS','1-800-CHEESES','1-800-FEATHERS');
  Heights: array[1..5] of double = (6.75,5.88,4.45,3.12,4.29);
  Notes: array[1..5] of string =
   ('Mr. Flintstone is a very important customer, eats a lot!',
    'Outstanding P.O. #545456388 dated 4/3/2076 for $123,655,878.99 (4 - pillow cases)',
    'He is very wrascally, always ship produce C.O.D.',
    'Credit is good as per cosignee Mr. Disney',
    'Cannot understand over the phone, always request fax backup of orders');

implementation

uses MainDataMod, ChartTest, Adhocprn, EMailData;

{$R *.DFM}

procedure TfrmMain.FormCreate(Sender: TObject);
var
	I: Integer;
	AFileName: string;
begin
	for I := Low(ReportNames) to High(ReportNames) do
		lbReports.Items.Add(ReportNames[I]);
	lbReports.ItemIndex := 0;
	lbReportsClick(Sender);
	AFileName := ExtractFilePath(ParamStr(0)) + 'Gnostice.bmp';
	if not FileExists(AFileName) then
	with Image1 do
	begin
		Canvas.Font.Color := $00E5E5E5;
		Canvas.Font.Name := 'Impact';
		Canvas.Font.Size := 36;
		Canvas.TextOut( 5, 5, 'Gnostice');
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

{------------------------------------------------------------------------------}

procedure TfrmMain.btnPrintClick(Sender: TObject);
begin
	ReportSystem.OnPrint := ReportSystemPrint;
	case lbReports.ItemIndex of
		0, 1, 2, 4, 6, 9:
			ReportSystem.Execute;
		3:
			DBTablePrinter1.Execute(nil);
		5:
			DBTablePrinter2.Execute(nil);
		7:
		begin
			ReportSystem.OnPrint := nil;
			ReportSystem.Execute;
		end;
		8:
			DetailShell2.Execute(nil);
		10:
			with TfrmTChartTest.Create(Self) do
			try
				ShowModal;
			finally
				Free;
			end;
		11:
			with TfrmAdhocprn.Create(Self) do
			try
				ShowModal;
			finally
				Free;
			end;
	 end;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.ReportSystemPrint(Sender: TObject);
begin
	case lbReports.ItemIndex of
		0:	// Simple Demo
			SimpleDemo(Sender);
		1: // Columns1
			Columns1(Sender);
		2: // Columns2
			Columns2(Sender);
		4: // DrawBox
			DrawBox(Sender);
		6: // Invoice
			Invoice(Sender);
		9: // TablePrint
			TablePrinter1.Execute(Sender as TBaseReport);
	 end;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.ReportSystem1Print(Sender: TObject);
begin
//
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.ReportSystemBeforePrint(Sender: TObject);
begin
	with Sender as TBaseReport do
		SetPaperSize(DMPAPER_LETTER, 0, 0);
	case lbReports.ItemIndex of
		1, 2: // Columns1, Columns2
			dmMain.tblMaster.First;
		7:
			dmMain.tblBiolife.First;
		8:
			with Sender as TBaseReport do
				SetPaperSize(DMPAPER_ENV_10, 0, 0);
	end;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.ReportSystemNewColumn(Sender: TObject);
begin
	case lbReports.ItemIndex of
		1, 2:	// columns1, columns2
		begin
			with Sender as TBaseReport do
			begin
				SetFont('Times New Roman', 14);
				Bold := True;
				UnderLine := True;
				AdjustLine;
				Println('COMPANY NAME');
				SetFont('Arial',12);
				AdjustLine;
			end;
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.ReportSystemPrintFooter(Sender: TObject);
begin
	case lbReports.ItemIndex of
		1, 2:	// columns1, columns2
		begin
			with  Sender as TBaseReport do
			begin
				MarginBottom := 0.5;
				PrintFooter('Page ' + Macro(midCurrentPage)
					+ ' of ' + Macro(midTotalPages), pjCenter);
				MarginBottom := 0.75;
			end; {with}
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.OutputProc1(Report: TBaseReport);
begin
	with Report do begin
		SetFont('Arial', 16);
		FontColor := clBlack;
		AdjustLine;
		Println('This is the output from procedure OutputProc1 !');
	end;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.OutputProc2(Report: TBaseReport);
begin
	with Report do begin
		SetFont('Helvetica', 16);
		FontColor := clGreen;
		AdjustLine;
		Println('This is the output from procedure OutputProc2 !');
	end;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.OutputProc3(Report: TBaseReport);
begin
	with Report do begin
		SetFont('Times New Roman', 16);
		FontColor := clBlue;
		AdjustLine;
		Println('This is the output from procedure OutputProc3 !');
	end;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.OutputProc4(Sender: TObject);
begin
	with Sender as TBaseReport do begin
		SetFont('Courier New', 16);
		FontColor := clRed;
		AdjustLine;
		Println('This is the output from procedure OutputProc4 !');
	end;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.SimpleDemo(Sender: TObject);
begin
	with Sender as TBaseReport do
		Home;
	OutputProc1(Sender as TBaseReport);
	OutputProc2(Sender as TBaseReport);
	OutputProc3(Sender as TBaseReport);
	OutputProc4(Sender);
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.Columns1(Sender: TObject);
begin
	with (Sender as TBaseReport), dmMain.tblMaster do
	begin
		SetFont('Times New Roman', 20);
		Bold := True;
		Underline := True;
		Home;
    PrintCenter('CUSTOMER LISTING', PageWidth / 2.0);
    SectionTop := 1.0;
    MarginBottom := 0.75;
    Home;
    while not dmMain.tblMaster.Eof do
    begin
      SetColumns(2,0.5);
      {OnNewColumn will be called after each call to SetColumns and on each
       new column after that}
      while (ColumnLinesLeft > 0) and (not dmMain.tblMaster.EOF) do
      begin
        If FieldByName('CO_NAME').AsString <> '' then
          Println(FieldByName('CO_NAME').AsString);
        dmMain.tblMaster.Next;
      end;
      If not dmMain.tblMaster.EOF then
        NewPage;
    end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.Columns2(Sender: TObject);
begin
  with (Sender as TBaseReport), dmMain.tblMaster do
  begin
    SetFont('Times New Roman', 20);
    Bold := True;
    Underline := True;
    Home;
    PrintCenter('CUSTOMER LISTING', PageWidth / 2.0);
    SectionTop := 1.0;
    MarginBottom := 0.75;
    Home;
    while not dmMain.tblMaster.EOF do
    begin
      SetColumns(2,0.5);
      {OnNewColumn will be called after each call to SetColumns and on each
       new column after that}

      ClearTabs;
      SetTab(MarginLeft,pjLeft,ColumnWidth / 2.0,2,BOXLINEALL,0);
      SetTab(NA,pjRight,ColumnWidth / 2.0,2,BOXLINEALL,0);

      while (ColumnLinesLeft > 0) and (not dmMain.tblMaster.EOF) do
      begin
        If FieldByName('CO_NAME').AsString <> '' then
        begin
          PrintTab(FieldByName('CO_NAME').AsString);
          PrintTab(FieldByName('CUR_PRICE').AsString);
          CRLF;
        end;
        dmMain.tblMaster.Next;
      end;
			If not dmMain.tblMaster.Eof then
        NewPage;
    end;

  end; { with }
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.DBTablePrinter1RATINGRowSetup(TableColumn: TTableColumn);
begin
  with TableColumn.MemoBuf do
  begin
    If Text = 'A' then
    begin
      TableColumn.ShadeColor := clGreen;
      Text := 'HIGH';
    end
    else if Text = 'B' then
    begin
      TableColumn.ShadeColor := clBlue;
      Text := 'MED';
    end
    else if Text = 'C' then
    begin
      TableColumn.ShadeColor := clRed;
      Text := 'LOW';
    end;
  end;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.DrawBox(Sender: TObject);

const
  SmallBoxText: array[1..7] of string[2] = ('NO','UN','BA','AV','AA','EX','OS');
  BigBoxText: array[1..7] of string[30] = ('Special Case', 'Performance',
   'Additional Duties', 'Administrative Duties', 'Handling Officers',
   'TRAINING PERSONNEL', 'HANDLING ENLISTED PERSONNEL');
var
  StartX: double;
  StartY: double;
  I1: integer;
  I2: integer;
  X1: double;
  Y1: double;

begin
  with Sender as TBaseReport do
  begin
     StartX := 1.0;
     StartY := 1.0;
    for I2 := 1 to 7 do
    begin
      SetFont('Arial',7);
      DrawBigBox(StartX,StartY,BigBoxText[I2], Sender as TBaseReport);
      SetFont('Arial',5);
      X1 := StartX + 1.0 / 14.0;
      Y1 := StartY + 0.25;
      for I1 := 1 to 7 do
      begin
        DrawSmallBox(X1,Y1,SmallBoxText[I1], Sender as TBaseReport);
        X1 := X1 + 2.0 / 7.0;
      end; { for }
      StartY := StartY + 0.5;
    end;
  end;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.DrawSmallBox(X1: double; Y1: double; Text: string;
	Report: TBaseReport);
begin
  with Report do
  begin
    SetPen(clBlack,psSolid,-1,pmCopy);
    Rectangle(X1,Y1,X1 + 0.125,Y1 + 0.125);
    LineMiddle := Y1 + 0.125 / 2.0;
    PrintCenter(Text,(X1 + 0.125 / 2.0));
  end;
end;


{------------------------------------------------------------------------------}

procedure TfrmMain.DrawBigBox(X1: double; Y1: double; Text: string;
	Report: TBaseReport);
begin
  with Report do
  begin
    SetPen(clBlack,psSolid,1,pmCopy);
    Rectangle(X1,Y1,X1 + 2.0,Y1 + 0.5);
    LineTop := Y1;
    PrintLeft(Text,X1 + 0.05);
  end;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.DBTablePrinter3InitMaster(TablePrinter: TTablePrinter;
  var Valid: Boolean);
begin
  dmMain.qryOrders.Active := false;
  dmMain.qryOrders.Params[0].AsFloat := dmMain.qryCustomer.FieldByName('CustNo').AsFloat;
  dmMain.qryOrders.Active := true;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.Invoice(Sender: TObject);
var
  NumRecords, i, Num : integer;
  Memobuf : TMemobuf;
  S1 : String;
begin
  with Sender as TBaseReport do
  begin
    SetFont('Arial Black', 14);
    Italic := True;
    Home;
    Print('ABC Company');
    PrintRight('JOB INVOICE', 7.6);
    NewLine;
    SetFont('Arial Black', 9);
    Italic := True;
    SaveFont(5);
    AdjustLine;
    Print('123 Street, Suite ABC');

    SetFont('Courier New', 10);
    PrintRight('No: 003735', 7.6);
    NewLine;

    RestoreFont(5);
    AdjustLine;
    Println('AnyCity, U.S.A.');
    LineHeight := 0.3;
    SetTab(0.75,pjLeft,3.5,0,BOXLINEBOTTOM,0);
    YPos := 1.6;
    Println(#9'TO:');
    Println(#9);
    Println(#9);


    MoveTo(4.6,1.0);
    LineTo(7.6,1.0);
    MoveTo(4.6,1.3);
    LineTo(7.6,1.3);
    MoveTo(4.6,1.6);
    LineTo(7.6,1.6);
    MoveTo(6.1,1.0);
    LineTo(6.1,1.6);

    LineHeightMethod := lhmFont;
    SetFont('Arial',5);
    SaveFont(6);
    PrintXY(4.7,1.08,'CUSTOMER ORDER NUMBER');
    PrintXY(6.2,1.08,'DATE OF ORDER');
    PrintXY(4.7,1.38,'PHONE');
    PrintXY(6.2,1.38,'FAX');

    MoveTo(0.5,2.4);
    LineTo(4.5,2.4);
    LineTo(4.5,2.75);
    LineTo(0.5,2.75);
    PrintXY(0.6,2.50, 'TERMS:');


    RestoreFont(5);
    DrawShadowBox(4.6,1.7,0.18,0.022,Sender as TBaseReport);
    PrintXY(4.82,1.83,'DAY WORK');
    DrawShadowBox(5.75,1.7,0.18,0.022,Sender as TBaseReport);
    PrintXY(5.97,1.83,'CONTRACT');
    DrawShadowBox(6.90,1.7,0.18,0.022,Sender as TBaseReport);
    PrintXY(7.12,1.83,'EXTRA');


    RestoreFont(6);
    MoveTo(4.6,2.0);
    LineTo(7.6,2.0);
    MoveTo(4.6,2.3);
    LineTo(7.6,2.3);
    MoveTo(4.6,2.6);
    LineTo(7.6,2.6);
    MoveTo(4.6,2.9);
    LineTo(7.6,2.9);
    MoveTo(6.1,2.6);
    LineTo(6.1,2.9);
    PrintXY(4.7,2.08,'JOB NAME / NUMBER');
    PrintXY(4.7,2.38,'JOB LOCATION');
    PrintXY(4.7,2.68,'ORDER TAKEN BY');
    PrintXY(6.2,2.68,'STARTING DATE');

    YPos := 3.0;
    SetFont('Arial',8);
    FontColor := clWhite;
    Italic := True;
    SaveFont(1);

    AdjustLine;
    ClearTabs;
    SetTab(0.5,pjCenter,0.35,2,BOXLINEALL,100);
    SetTab(NA,pjCenter,2.2,2,BOXLINEALL,100);
    SetTab(NA,pjCenter,0.7,2,BOXLINEALL,100);
    SetTab(NA,pjCenter,0.75,2,BOXLINEALL,100);
    SaveTabs(1);

    Print(#9'QTY.');
    Print(#9'MATERIAL');
    Print(#9'PRICE');
    Print(#9'AMOUNT');

    ClearTabs;
    SetTab(4.6,pjCenter,3.0,2,BOXLINEALL,100);
    SaveTabs(2);

    Print(#9'DESCRIPTION OF WORK');
    LineHeight := 0.235;
    ResetLineHeight;
    SavePos(1);

    NewLine;
    Italic := false;
    FontColor := clBlack;
    SetFont('Arial',10);
    SaveFont(2);
    AdjustLine;

    ClearTabs;
    SetTab(0.5,pjCenter,0.35,2,BOXLINETOPBOTTOM,0);
    SetTab(NA,pjLeft,2.2,2,BOXLINEALL,0);
    SetTab(NA,pjRight,0.4,2,BOXLINEALL,0);
    SetTab(NA,pjLeft,0.3,2,BOXLINEALL,0);
    SetTab(NA,pjRight,0.5,2,BOXLINEALL,0);
    SetTab(NA,pjLeft,0.25,2,BOXLINEALL,0);
    SaveTabs(3);

    ClearTabs;
    SetTab(4.6,pjCenter,3.0,2,BOXLINELEFT,0);
    SaveTabs(4);

    RestoreTabs(3);
    NumRecords := 24;
    Num := 1;
    dmMain.tblParts.Open;
    dmMain.tblParts.First;

    LineHeight := 0.235;
    for i := 1 to NumRecords - 1 do
    begin
      Print(#9+IntToStr(Num));
      PrintTab(dmMain.tblParts.FieldByName('Description').AsString);
      Println(#9+'000'+#9+'00'+#9+'999'+#9+'99');
      dmMain.tblParts.Next;
      Num := Num + 1;
    end;
    Print(#9+IntToStr(Num));
    PrintTab(dmMain.tblParts.FieldByName('Description').AsString);
    Print(#9+'000'+#9+'00'+#9+'999'+#9+'99');
    SavePos(3);
    dmMain.tblParts.Close;

    SetFont('Arial', 5);
    PrintXY(0.6,8.77,'DATE COMPLETED');

    RestorePos(3);
    RestoreFont(2);
    ResetLineHeight;
    NewLine;

    ClearTabs;
    SetTab(0.5,pjLeft,1.9,2,BOXLINETOPBOTTOM,0);
    SetTab(NA,pjCenter,1.35,2,BOXLINEALL,100);
    SetTab(NA,pjRight,0.5,2,BOXLINEALL,0);
    SetTab(NA,pjLeft,0.25,2,BOXLINEALL,0);

    Print(#9);
    RestoreFont(1);
    Print(#9'TOTAL MATERIALS');
    RestoreFont(2);
    Println(#9 + '999'#9 + '99');
    LineHeightMethod := lhmFont;

    NewLine;
    SetFont('Arial',5);
    Print('SIGNATURE');
    MoveTo(XPos + 0.05,YPos + 0.05);
    LineTo(4.25, YPos + 0.05);
    PrintXY(0.5, YPos + 0.3, 'WORK ORDERED BY');
    MoveTo(XPos + 0.05,YPos + 0.05);
    LineTo(4.25, YPos + 0.05);

    RestorePos(1);
    LineHeight := 0.235;
    NewLine;
    RestoreFont(2);
    AdjustLine;
    RestoreTabs(4);
    SavePos(4);

    LineHeight := 0.235;
    for i := 1 to 7 do
    begin
      Print(#9);
      if i < 7 then
      begin
        FinishTabBox(1);
        NewLine;
      end;
    end;
    FinishTabBox(1);
    SavePos(5);

    RestorePos(4);
    S1 := 'This is where the description of the work performed will be inserted. This info'
			+ ' could be from a database or a string variable';
    Memobuf := TMemobuf.Create;
    with Memobuf do
    begin
      PrintStart := TabStart(1);
      PrintEnd := TabEnd(1);
      Text := S1;
    end;
    PrintMemo(Memobuf,0,false);
    Memobuf.Free;
    LineHeightMethod := lhmFont;

    RestorePos(5);
    ClearTabs;
    SetTab(4.6,pjCenter,2.2,2,BOXLINEALL,100);
    SetTab(NA,pjCenter,0.8,2,BOXLINEALL,100);
    SaveTabs(5);

    RestoreFont(1);
    ResetLineHeight;
    NewLine;
    Print(#9'OTHER CHARGES');
    Print(#9'AMOUNT');

    ClearTabs;
    SetTab(4.6,pjCenter,2.2,2,BOXLINEALL,0);
    SetTab(NA,pjCenter,0.5,2,BOXLINEALL,0);
    SetTab(NA,pjCenter,0.3,2,BOXLINEBOTTOM,0);
    SaveTabs(6);

    LineHeight := 0.235;
    NewLine;
    RestoreFont(2);
    AdjustLine;
    for i := 1 to 6 do
      Println(#9#9#9);
    LineHeightMethod := lhmFont;

    SetFont('Arial', 6);
    Italic := True;
    FontColor := clWhite;
    SaveFont(3);

    ClearTabs;
    SetTab(4.6,pjCenter,1.6,2,BOXLINEALL,100);
    SetTab(NA,pjCenter,0.3,2,BOXLINEALL,100);
    SetTab(NA,pjCenter,0.3,2,BOXLINEALL,100);
    SetTab(NA,pjCenter,0.8,2,BOXLINEALL,100);
    SaveTabs(7);

    RestoreFont(1);
    AdjustLine;
    Print(#9'LABOR');

    RestoreFont(3);
    Print(#9'HRS.'#9'RATE');

    RestoreFont(1);
    Print(#9'AMOUNT');

    ClearTabs;
    SetTab(4.6,pjCenter,1.6,2,BOXLINEALL,0);
    SetTab(NA,pjCenter,0.3,2,BOXLINEALL,0);
    SetTab(NA,pjCenter,0.3,2,BOXLINEALL,0);
    SetTab(NA,pjRight,0.5,2,BOXLINEALL,0);
    SetTab(NA,pjLeft,0.3,2,BOXLINEBOTTOM,0);
    SaveTabs(8);

    LineHeight := 0.235;
    NewLine;
    RestoreFont(2);
    AdjustLine;
    for i := 1 to 8 do
      Println(#9#9+'8'+#9+'6'+#9+'99'+#9+'99');

    ClearTabs;
    SetTab(4.6,pjRight,2.2,15,BOXLINEALL,0);
    SetTab(NA,pjRight,0.5,2,BOXLINEALL,0);
    SetTab(NA,pjLeft,0.3,2,BOXLINEBOTTOM,0);
    SaveTabs(9);

    SetFont('Arial',10);
    Italic := True;
    AdjustLine;
    Println(#9'TOTAL LABOR'#9+'999'#9+'11');
    Println(#9'TOTAL MATERIALS'#9+'333'+#9+'65');
    Println(#9'TOTAL OTHER'#9+'000'+#9+'00');
    Print(#9'TAX'#9+'111'+#9+'22');
    LineHeightMethod := lhmFont;

    ClearTabs;
    SetTab(4.6,pjRight,2.2,15,BOXLINEALL,100);
    SetTab(NA,pjCenter,0.8,2,BOXLINEALL,100);
    SaveTabs(10);

    RestoreFont(1);
    LineHeight := 0.30;
    NewLine;

    SavePos(2);
    Print(#9);
    FontBottom := (LineTop + LineBottom + FontHeight) / 2.0;
    PrintRight('TOTAL',TabEnd(1));
    RestorePos(2);
    SetFont('Arial', 14);
    Italic := True;
    FontColor := clWhite;
    Print(#9);
    FontBottom := (LineTop + LineBottom + FontHeight) / 2.0;
    PrintRight('9999.99',TabEnd(2));
  end;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.DrawShadowBox(XPosition: double; YPosition: double;
	Width: double; Shadow: double; Report: TBaseReport);
var
  TempX, TempY : double;
begin
  with Report do
  begin
    If Shadow > 0 then
    begin
      TempX := XPosition + Shadow;
      TempY := YPosition + Shadow;
      SetBrush(clBlack, bsSolid, nil);
      Rectangle(TempX, TempY, TempX + Width, TempY + Width);
    end;
    SetBrush(clwhite, bsSolid, nil);
    Rectangle(XPosition, YPosition, XPosition + Width, YPosition + Width);
    end;
end;

{------------------------------------------------------------------------------}

function TfrmMain.RPFish(Sender: TObject; var PageNum: Integer): Boolean;
var
  Memobuf : TDBMemobuf;
  Bitmap : TBitmap;
  Lines : Integer;
begin
  with Sender as TBaseReport do
  begin
    SectionTop := 1.25;
    SectionBottom := 10.0;
    SetFont('Times New Roman',12);
    Home;

    ClearTabs;
    SetTab(0.5,pjLeft,1.5,5,BOXLINELEFTRIGHT,0);
    SetTab(NA,pjLeft,1.5,5,BOXLINELEFTRIGHT,0);
    SetTab(NA,pjLeft,4.5,5,BOXLINELEFTRIGHT,0);
    Bold := true;
    TabJustify := tjCenter;
    FinishTabBox(1);
    PrintTab('Name');
    PrintTab('Picture');
    PrintTab('Description');
    NewLine;
    FinishTabBox(1);
    Bold := false;
    TabJustify := tjNone;

    Memobuf := TDBMemobuf.Create;
    try
      Memobuf.PrintStart := TabStart(3);
      Memobuf.PrintEnd := TabEnd(3);
      repeat
        Memobuf.Field := dmMain.tblBiolifeNotes;

      { Make sure we've got enough room for the bitmap and memo to print }
        Lines := MemoLines(Memobuf);
        if Lines < 8 then
          Lines := 8;
        if Lines > LinesLeft then { Won't fit on current page, goto next }
          Break;

      { Print the common name column }
        PrintTab(dmMain.tblBiolifeCommon_Name.AsString);

      { Draw the bitmap }
        PrintTab('');
        Bitmap := TBitmap.Create;
        try
          GraphicFieldToBitmap(dmMain.tblBiolifeGraphic, Bitmap);
          PrintBitmapRect(XPos,YPos,XPos + TabWidth(0),
           YPos + TabWidth(0),Bitmap);
        finally
          Bitmap.Free;
        end;
      { Print the description }
        PrintMemo(Memobuf,Lines,true);
      { Draw line at bottom of row }
        FinishTabBox(1);
        dmMain.tblBiolife.Next;
      until dmMain.tblBiolife.EOF;
    finally
      Memobuf.Free;
    end;
  end;
  Result := not dmMain.tblBiolife.EOF;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.DetailShell2BodyBefore(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell);
begin
  dmMain.tblCustomer.First;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.DetailShell2RowAfter(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
  dmMain.tblCustomer.Next;
  Valid := not dmMain.tblCustomer.EOF;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.DetailShell2RowPrint(ReportPrinter: TBaseReport;
  ReportShell: TDetailShell; var Valid: Boolean);
begin
  with ReportPrinter, dmMain.tblCustomer do
  begin
    SetFont('Arial',10);
    Home;
    Println('ABC Incorporated');
    Println('123 N. Anywhere St #554');
    Println('Somewhere, US 12345');

    SectionLeft := 4.0;
    SectionTop := 1.5;
    SetFont('Arial',14);
    Home;

    Println(FieldByName('COMPANY').AsString);
    Println(FieldByName('CONTACT').AsString);

    if FieldByName('ADDR1').AsString <> '' then
      Println(FieldByName('ADDR1').AsString);

    if FieldByName('ADDR2').AsString <> '' then
      Println(FieldByName('ADDR2').AsString);

    Print(FieldByName('CITY').AsString);
    if FieldByName('STATE').AsString <> '' then
      Print(', ' + FieldByName('STATE').AsString);
    if FieldByName('ZIP').AsString <> '' then
      Print('  ' + FieldByName('ZIP').AsString);
    NewLine;

    if FieldByName('COUNTRY').AsString <> 'US' then
      Println(UpperCase(FieldByName('COUNTRY').AsString));
  end;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.TablePrinter1GetNextRow(TablePrinter: TTablePrinter;
  var Valid: Boolean);
begin
  Inc(Index);
  Valid := Index <= 5;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.TablePrinter1InitTable(TablePrinter: TTablePrinter;
  var Valid: Boolean);
begin
  Index := 1;
  Valid := true;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.TablePrinter1NameRowSetup(TableColumn: TTableColumn);
begin
  TableColumn.MemoBuf.Text := Names[Index];
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.TablePrinter1PhoneRowSetup(TableColumn: TTableColumn);
begin
  TableColumn.MemoBuf.Text := PhoneNums[Index];
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.TablePrinter1HeightRowSetup(TableColumn: TTableColumn);
begin
  TableColumn.MemoBuf.Text := FloatToStr(Heights[Index]);
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.TablePrinter1NotesRowSetup(TableColumn: TTableColumn);
begin
	TableColumn.MemoBuf.Text := Notes[Index];
end;

{------------------------------------------------------------------------------}

function TfrmMain.ReportSystemPrintPage(Sender: TObject;
	var PageNum: Integer): Boolean;
begin
	Result := False;
	case lbReports.ItemIndex of
		7:
			Result := RPFish(Sender, PageNum);
	end;
end;

procedure TfrmMain.lbReportsClick(Sender: TObject);
const
	Descriptions: array[0..11] of string = (
		'The Report contains 4 lines of text. The Report demonstrates how you can have printing code outside the OnPrint event for TReportSystem.',
		'The Report contains two columns of text. The title is underlined. Report has 2 pages.',
		'The Report contains two tables placed vertically. Each table has two columns with text and numbers. Report has 2 pages.',
		'The Report contains one table with 5 columns. Some cells in the table are colored. Report has 2 pages.',
		'The Report contains text within rectangles. Smaller Rectangles are enclosed within bigger rectangles. Report has a single page.',
		'Master-Detail Report. The Report has Complex tables. Title cells are colored. Report has 6 pages.',
		'The Report is a sample Invoice. It contains text, lines and boxes. Some text is in italics. Report has a single page.',
		'Report is the familiar BioLife.db from DBDEMOS. Report demonstrates text, tables and graphics. Report has 10 pages.',
		'The Report contains addresses to print on envelopes. Report has 55 pages.',
		'The Report contains a simple table. Report is generated using TTablePrinter. Report has a single page.',
		'The Report contains a chart. Report is generated using TChart component.',
		'Starts a general Database application. By selecting the Alias Name, Table Name and Fields, the application gets information from the corresponding DB and creates a Report. Please note that graphics are not handled properly.');
begin
	memoDescription.Text := Descriptions[lbReports.ItemIndex];
end;

procedure TfrmMain.Label10Click(Sender: TObject);
begin
	ShellExecute( 0, nil, 'http://www.gnostice.com', nil, nil, SW_MAXIMIZE);
end;

procedure TfrmMain.chkShowSetupDialogClick(Sender: TObject);
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

procedure TfrmMain.chkShowProgressClick(Sender: TObject);
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

procedure TfrmMain.gtRPRenderEMail(Render: TRPRender;
	EMailInfo: TgtRPEMailInfo; var Continue: Boolean);
begin
	frmEMailData := TfrmEMailData.Create(Self);
	with frmEMailData do
		try
			ShowModal;
			EMailInfo.Host := edHost.Text;
			EMailInfo.UserID := edUserID.Text;
			EMailInfo.Password := edPassword.Text;
			EMailInfo.Body.Add(memoBody.Text);
			EMailInfo.FromAddress := edFrom.Text;
			EMailInfo.Subject := edSubject.Text;
			EMailInfo.RecipientList.Add(edTo.Text);
			EMailInfo.CCList.Add(edCC.Text);
			EMailInfo.BCCList.Add(edBCC.Text);
		finally
			Free;
		end;
end;

end.
  
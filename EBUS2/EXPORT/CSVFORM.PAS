unit CSVForm;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, ComCtrls, CSVUtils, Grids, BorBtns, NeilProc, StrUtil;

type
  TfrmCSVExport = class(TForm)
    dlgFileOpen: TOpenDialog;
    btnLoad: TButton;
    btnClose: TButton;
    btnExport: TButton;
    btnFileName: TButton;
    lblSelectionName: TLabel;
    dlgExportFile: TSaveDialog;
    grpCSVOptions: TGroupBox;
    cbxHeaderRow: TSBSComboBox;
    cbxFieldSep: TSBSComboBox;
    cbxFieldDelim: TSBSComboBox;
    edtFieldDelim: Text8Pt;
    edtFieldSep: Text8Pt;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    grpExportOptions: TGroupBox;
    grdExportInfo: TStringGrid;
    Label4: TLabel;
    cbxExportMode: TSBSComboBox;
    chkIgnoreWebInclude: TBorCheck;
    Label5: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    procedure btnExportClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SetUserDefinedFields(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnFileNameClick(Sender: TObject);
  private
    fCSVType : TCSVType;
    fCSVFileName,
    fMapFileName : string;
    fExportLastRun : TDateTime;
    procedure InitialiseStringGrid;
    procedure DisplayLastExported;
  protected
    function GetHeaderRow : TCSVHeader;
    function GetExportMode : TRecExportMode;
    function GetSeparator(Display : boolean = true) : string;
    function GetDelimiter(Display : boolean = true) : string;
  public
  end;

var
  frmCSVExport: TfrmCSVExport;

implementation

{$R *.DFM}

uses
  ExprtCSV, ETDateU, IniFiles;

// Combo box entries

// Field delimiter
// 0 = None
// 1 = Single quote
// 2 = Double quote
// 3 = Other

// Field separator
// 0 = Comma
// 1 = Semi colon
// 2 = Tab
// 3 = Other

// Include header row
// 0 = None
// 1 = Field codes
// 2 = Field descriptions

// Record update
// 0 = all records
// 1 = updated since last export

const
  DEF_CLIENT_HEIGHT = 276;
  DEF_CLIENT_WIDTH = 408;

//-----------------------------------------------------------------------

procedure TfrmCSVExport.btnExportClick(Sender: TObject);
var
  ExportCSV : TExportCSV;
begin
{  if fCSVFileName = '' then
  begin
    MessageDlg('You must select an export CSV file name', mtError, [mbOK], 0);
    exit;
  end;}

  case fCSVType of
    csvStockHeader : ExportCSV := TExportStockCSV.Create;
    csvAccount : ExportCSV := TExportAccountCSV.Create;
    csvStockGroup : ExportCSV := TExportStockGroupCSV.Create;
    csvTXHeader : ExportCSV := TExportTXCSV.Create;
  else
    ExportCSV := nil;
  end;

  if Assigned(ExportCSV) then
    with ExportCSV do
    try
      MapFileName := fMapFileName;
      CSVHedFileName := 'Header.CSV';
      CSVLineFileName := 'Lines.CSV';
      ExportLastRun := fExportLastRun;
      Delimiter := GetDelimiter(false)[1];
      Separator := GetSeparator(false)[1];
      HeaderRow := GetHeaderRow;
      IgnoreWebIncludeFlag := chkIgnoreWebInclude.Checked;
      ExportMode := GetExportMode;
      OSTXFilter[1] := checkbox1.checked;
      OSTXFilter[2] := checkbox2.checked;
      OSTXFilter[3] := checkbox3.checked;
      OSTXFilter[4] := checkbox4.checked;

      if ProcessExport then
      begin
        MessageDlg(Format('%s CSV export to %s completed.', [CSV_DESC[fCSVType], fCSVFileName]),
          mtInformation, [mbOK], 0);
        DisplayLastExported;
      end;
    finally
      Free;
    end
  else
    MessageDlg('The CSV mapping file is invalid', mtError, [mbOK], 0);
end;

//-----------------------------------------------------------------------

procedure TfrmCSVExport.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-----------------------------------------------------------------------

procedure TfrmCSVExport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

//-----------------------------------------------------------------------

procedure TfrmCSVExport.InitialiseStringGrid;
begin
  with grdExportInfo do
  begin
    ColWidths[0] := 90;
    ColWidths[1] := Width - ColWidths[0];
    Cells[0,0] := 'Map file name:';
    Cells[0,1] := 'Last exported:';
    Cells[0,2] := 'Export file name:';
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmCSVExport.DisplayLastExported;
{var
  ExpDate,
  ExpTime : string;}
begin
(*  with TIniFile.Create(fMapFileName) do
    try
      ExpDate := ReadString(EBusParams.CurCompCode, LAST_EXPORT_DATE, '');
      ExpTime := ReadString(EBusParams.CurCompCode, LAST_EXPORT_TIME, '');

      fExportLastRun := ToDateTime(ExpDate, ExpTime);
      if ExpDate <> '' then
        grdExportInfo.Cells[1,1] := Format('%s - %s', [POutDate(ExpDate), DisplayTime(ExpTime)])
      else
        grdExportInfo.Cells[1,1] := 'never';
    finally
      Free;
    end;*)
end;

//-----------------------------------------------------------------------

procedure TfrmCSVExport.FormCreate(Sender: TObject);
begin
  ClientHeight := DEF_CLIENT_HEIGHT;
  ClientWidth := DEF_CLIENT_WIDTH;
  cbxFieldDelim.ItemIndex := 2;
  cbxFieldSep.ItemIndex := 0;
  cbxHeaderRow.ItemIndex := 0;
  cbxExportMode.ItemIndex := 0;
  InitialiseStringGrid;
  SetUserDefinedFields(self);
end;

//-----------------------------------------------------------------------

function TfrmCSVExport.GetHeaderRow : TCSVHeader;
begin
  case cbxHeaderRow.ItemIndex of
    1: Result := hdrFields;
    2: Result := hdrDescs;
  else
    Result := hdrNone;
  end;
end;

//-----------------------------------------------------------------------

function TfrmCSVExport.GetExportMode : TRecExportMode;
begin
  if cbxExportMode.ItemIndex = 1 then
    Result := expUpdate
  else
    Result := expAll
end;

//-----------------------------------------------------------------------

function TfrmCSVExport.GetDelimiter(Display : boolean = true) : string;
begin
  case cbxFieldDelim.ItemIndex of
    1: Result := '''';
    2: Result := '"';
  else
    if Display then
      Result := ''
    else
      if Trim(edtFieldDelim.Text) <> '' then
        Result := edtFieldDelim.Text[1]
      else
        Result := #0;
  end;
end;

//-----------------------------------------------------------------------

function TfrmCSVExport.GetSeparator(Display : boolean = true) : string;
begin
  case cbxFieldSep.ItemIndex of
    0: Result := ',';
    1: Result := ';';
    2: if Display then
         Result := '\t'
       else
         Result := TAB;
  else
    if Display then
      Result := ''
    else
      if Trim(edtFieldSep.Text) <> '' then
        Result := edtFieldSep.Text[1]
      else
        Result := #0;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmCSVExport.SetUserDefinedFields(Sender: TObject);
begin
  edtFieldDelim.Text := GetDelimiter;
  edtFieldDelim.ReadOnly := edtFieldDelim.Text <> #0;

  edtFieldSep.Text := GetSeparator;
  edtFieldSep.ReadOnly := edtFieldSep.Text <> #0;
end;

//-----------------------------------------------------------------------

procedure TfrmCSVExport.btnLoadClick(Sender: TObject);
begin
  if dlgFileOpen.Execute then
  begin
    fMapFileName := dlgFileOpen.FileName;
    grdExportInfo.Cells[1,0] := fMapFileName;
    DisplayLastExported;
    fCSVType := GetMapFileRec(fMapFileName).ExportType;
    Caption := Format('%s CSV Export', [CSV_DESC[fCSVType]]);
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmCSVExport.btnFileNameClick(Sender: TObject);
begin
  if dlgExportFile.Execute then
  begin
    fCSVFileName := dlgExportFile.FileName;
    grdExportInfo.Cells[1,2] := fCSVFileName;
  end;
end;

end.


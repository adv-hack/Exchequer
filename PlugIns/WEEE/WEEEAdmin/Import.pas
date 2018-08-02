unit Import;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EnterToTab;

type
  TfrmImport = class(TForm)
    memInfo: TMemo;
    btnRunImport: TButton;
    Label1: TLabel;
    edFilename: TEdit;
    btnBrowse: TButton;
    OpenDialog1: TOpenDialog;
    btnCancel: TButton;
    Label2: TLabel;
    lCompany: TLabel;
    btnSave: TButton;
    SaveDialog: TSaveDialog;
    EnterToTab1: TEnterToTab;
    procedure btnRunImportClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmImport: TfrmImport;

implementation
uses
  Math, StrUtil, Enterprise01_TLB, BTFiles, BTUtil, BTConst, WEEEProc;

{$R *.dfm}

procedure TfrmImport.btnRunImportClick(Sender: TObject);
var
  iRecordsAdded, iLineNo : integer;

  procedure AddMemoLine(sLine : string);
  begin{AddMemoLine}
    memInfo.Lines.Add('Line ' + IntToStr(iLineNo) +  ' : ' + sLine);
  end;{AddMemoLine}

  procedure AddRecord(TheProductRec : TWEEEProdRec);
  var
    BTRec : TBTRec;
    oUpdateStock : IStock;

    procedure UpdateStockUDF;
    var
      iStatus : integer;
    begin{UpdateStockUDF}
      GetSysSetupRec;
      Case SystemSetupRec.StockFlagUDF of
        1 : oUpdateStock.stUserField1 := 'YES';
        2 : oUpdateStock.stUserField2 := 'YES';
        3 : oUpdateStock.stUserField3 := 'YES';
        4 : oUpdateStock.stUserField4 := 'YES';
      end;{case}
      iStatus := oUpdateStock.Save;
      if iStatus <> 0 then AddMemoLine('Error Updating Stock UDF : ' + IntToStr(iStatus));
      oUpdateStock := nil;
    end;{UpdateStockUDF}

  begin{AddRecord}
    with TheProductRec do begin

      // Validate Stock Code
      BTRec.Status := oToolkit.Stock.GetEqual(oToolkit.Stock.BuildCodeIndex(wpStockCode));
      if BTRec.Status = 0 then
      begin
        // Update Stock UDF ?
        oUpdateStock := oToolkit.Stock.Update;
        if oUpdateStock = nil then
        begin
          AddMemoLine('Error Updating Stock UDF : Could not get an update object');
          exit;
        end else
        begin
          UpdateStockUDF;
        end;{if}
      end else
      begin
        AddMemoLine('Error Adding Product, Invalid Stock Code : ' + wpStockCode);
        exit;
      end;{if}

      // Validate / set Charge Type
      case wpChargeType of
        CT_SET_VALUE : wpValue := TheProductRec.wpSetValue;

        CT_CALC_VALUE : wpValue := SimpleRoundTo(TheProductRec.wpValuePerKilo
        * TheProductRec.wpValuePerKilo, - oToolkit.SystemSetup.ssSalesDecimals);

        else begin
          AddMemoLine('Error Adding Product, Invalid Charge Type : ' + IntToStr(wpChargeType));
          exit;
        end;
      end;{case}

      // Validate Report Cat
      if wpReportCatFolio = -1 then
      begin
        AddMemoLine('Error Adding Product, Invalid Report Category');
        exit;
      end;{if}

      // Validate Report Sub-Cat
      if wpReportSubCatFolio = -1 then
      begin
        AddMemoLine('Error Adding Product, Invalid Report Sub-Category');
        exit;
      end;{if}
    end;{with}

    BTRec.Status := BTAddRecord(btFileVar[WEEEProdF], TheProductRec
    , btBufferSize[WEEEProdF], 0);
    if BTRec.Status <> 0 then
    begin
      if BTRec.Status = 5 then AddMemoLine('Product Info Already Exists : ' + TheProductRec.wpStockCode)
      else AddMemoLine('Error Adding Product : ' + IntToStr(BTRec.Status));
    end else
    begin
//          UpdateStockUDF;
      AddMemoLine('Product Info Imported for ' + TheProductRec.wpStockCode);
      inc(iRecordsAdded);
    end;{if}
  end;{AddRecord}

  function StrToProductRec(sString : string) : TWEEEProdRec;

    procedure AddField(iFieldNo : integer; sField : string);

      function GetReportCatFolioFromCode(sCode : string) : integer;
      var
        LReportCat : TWEEEReportCatRec;
        BTRec : TBTRec;
      begin{GetReportCatFolioFromCode}
        Result := -1;
        BTRec.KeyS := PadString(psRight, sCode, ' ', 10);
        BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEReportCatF], LReportCat
        , btBufferSize[WEEEReportCatF], wrcIdxCode, BTRec.KeyS);
        if BTRec.Status = 0 then Result := LReportCat.wrcFolioNo
        else AddMemoLine('Could not find Report Category with code : ' + sCode);
      end;{GetReportCatFolioFromCode}

      function GetReportSubCatFolioFromCode(iReportCat : integer; sCode : string) : integer;
      var
        LReportSubCat : TWEEEReportSubCatRec;
        BTRec : TBTRec;
      begin{GetReportSubCatFolioFromCode}
        Result := -1;
        BTRec.KeyS := BTFullNomKey(iReportCat) + PadString(psRight, sCode, ' ', 10);
        BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[WEEEReportSubCatF], LReportSubCat
        , btBufferSize[WEEEReportSubCatF], wscIdxCatCode, BTRec.KeyS);
        if BTRec.Status = 0 then Result := LReportSubCat.wscFolioNo
        else AddMemoLine('Could not find Report Sub Category from : ' + IntToStr(iReportCat)
        + '/' + sCode);
      end;{GetReportSubCatFolioFromCode}

    begin{AddField}
      with Result do begin
        case iFieldNo of
          1 : wpStockCode := PadString(psRight, sField, ' ', 16);
          2 : wpSetValue := StrToFloatDef(sField, 0);
          3 : wpValuePerKilo := StrToFloatDef(sField, 0);
          4 : wpNoOfKilos := StrToFloatDef(sField, 0);
//          5 : wpValue := StrToFloatDef(sField, 0);
          5 : wpChargeType := StrToIntDef(sField, 0); //  CT_SET_VALUE = 0, CT_CALC_VALUE = 1
          6 : wpReportCatFolio := GetReportCatFolioFromCode(sField);
          7 : wpReportSubCatFolio := GetReportSubCatFolioFromCode(wpReportCatFolio, sField);
//          7 : wpExtraChargeStockCode := sField;
        end;{case}
      end;{with}
    end;{AddField}

  var
    QuoteMode, iFieldNo, iPos : integer;
    sField : string;
  const
    QM_OutsideQuotes = 0;
    QM_InsideQuotes = 1;

  begin{StrToProductRec}
    FillChar(Result, SizeOf(Result), #0);

    // initialise
    iFieldNo := 1;
    sField := '';
    QuoteMode := QM_OutsideQuotes;

    // go through each character in the string
    for iPos := 1 to Length(sString) do
    begin

      // change quote mode
      if sString[iPos] = '"' then
      begin
        if QuoteMode = QM_OutsideQuotes then QuoteMode := QM_InsideQuotes
        else begin
          if (iPos = Length(sString)) or (sString[iPos + 1] = ',')
          then QuoteMode := QM_OutsideQuotes
          else sField := sField + sString[iPos] // add quote to string as it is not the end of string quote
        end;
      end
      else begin
        // next field
        if (sString[iPos] = ',') and (QuoteMode = QM_OutsideQuotes) then
        begin
          AddField(iFieldNo, sField);
          sField := '';
          inc(iFieldNo);
        end
        else begin
          sField := sField + sString[iPos]
        end;
      end;{if}

    end;{for}

    // add last field
    AddField(iFieldNo, sField);
  end;{StrToProductRec}

var
  slProducts : TStringList;
//  AProductRec : TWEEEProdRec;
//  iStatus, iPos : integer;

begin
  iRecordsAdded := 0;
  memInfo.Lines.Clear;

  if not FileExists(edFileName.Text) then
  begin
    memInfo.Lines.Add('File does not exist : ' + edFileName.Text);
    exit;
  end;{if}

  slProducts := TStringList.Create;
  slProducts.LoadFromFile(edFileName.Text);

  For iLineNo := 1 to slProducts.Count do
  begin
    AddRecord(StrToProductRec(slProducts[iLineNo -1]));
  end;{for}

  slProducts.Free;

  memInfo.Lines.Add('');
  memInfo.Lines.Add('Import Process Completed, ' + IntToStr(iRecordsAdded) + ' Records Added.');
  memInfo.Lines.Add('');
end;

procedure TfrmImport.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmImport.btnBrowseClick(Sender: TObject);
begin
  with OpenDialog1 do
  begin
    Filename := edFilename.Text;
    if execute
    then edFilename.Text := Filename;
  end;{with}
end;

procedure TfrmImport.FormCreate(Sender: TObject);
begin
  lCompany.Caption := CompanyRec.Code + ' - ' + CompanyRec.Name;
end;

procedure TfrmImport.btnSaveClick(Sender: TObject);
begin
 SaveDialog.FileName := 'Import.txt';
 if SaveDialog.Execute then memInfo.Lines.SaveToFile(SaveDialog.filename);
end;

end.

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
    EnterToTab2: TEnterToTab;
    procedure btnRunImportClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
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
  CCDeptU, StrUtil, Enterprise01_TLB, BTFile, BTUtil, BTConst;

{$R *.dfm}

procedure TfrmImport.btnRunImportClick(Sender: TObject);
var
  iRecordsAdded, iLineNo : integer;

  procedure AddMemoLine(sLine : string);
  begin{AddMemoLine}
    memInfo.Lines.Add('Line ' + IntToStr(iLineNo) +  ' : ' + sLine);
  end;{AddMemoLine}

  procedure AddRecord(CCDeptRec : TCCDeptRec);
  var
    BTRec : TBTRec;
    oUpdateStock : IStock;
    LCCDeptRec : TCCDeptRec;
//    bDuplicate : boolean;
  begin{AddRecord}

    // Does The Cost Centre Exist ?
    BTRec.Status := oToolkit.CostCentre.GetEqual(oToolkit.CostCentre.BuildCodeIndex(Trim(CCDeptRec.cdCostCentre)));
    if (CCDeptRec.cdCostCentre = CCDEPT_WILDCARD) or (BTRec.Status = 0) then
    begin
      // Does The Department Exist ?
      BTRec.Status := oToolkit.Department.GetEqual(oToolkit.Department.BuildCodeIndex(Trim(CCDeptRec.cdDepartment)));
      if (CCDeptRec.cdDepartment = CCDEPT_WILDCARD) or (BTRec.Status = 0) then
      begin
        // Is the GL Code Valid ?
        BTRec.Status := oToolkit.GeneralLedger.GetEqual(oToolkit.GeneralLedger.BuildCodeIndex(CCDeptRec.cdGLCode));
        if (CCDeptRec.cdGLCode = iGL_WILDCARD) or (CCDeptRec.cdGLCode = iNO_GL)
        or (BTRec.Status = 0) then
        begin
          // Is the VAT Code Valid ?
          if ((CCDeptRec.cdVATCode = #0) and (not bUseVAT)) or ValidVatCode(CCDeptRec.cdVATCode) then
          begin
            // Is the Type Valid ?
            if CCDeptRec.cdType in [CD_VALID, CD_INVALID] then
            begin
              // Is this a duplicate Record ?
//              bDuplicate := FALSE;
              BTRec.KeyS := CCDeptRec.cdType + BTFullNomKey(CCDeptRec.cdGLCode)
              + CCDeptRec.cdCostCentre + CCDeptRec.cdDepartment + CCDeptRec.cdVATCode;
              BTRec.Status := BTFindRecord(BT_GetEqual, aFileVar[CCDeptF], LCCDeptRec, aBufferSize[CCDeptF]
              , idxGetCombinations, BTRec.KeyS);
(*
              While BTRec.Status = 0 do
              begin
                if (CCDeptRec.cdType = LCCDeptRec.cdType)
                and (CCDeptRec.cdGLCode = LCCDeptRec.cdGLCode)
                and (CCDeptRec.cdCostCentre = CCDeptRec.cdCostCentre)
                and (CCDeptRec.cdDepartment = LCCDeptRec.cdDepartment)
                and (CCDeptRec.cdVATCode = LCCDeptRec.cdVATCode) then
                begin
                  // Duplicate
                  AddMemoLine('Error Adding Record : Duplicate');
                  bDuplicate := TRUE;
                  break;
                end;{if}

                BTRec.Status := BTFindRecord(BT_GetNext, aFileVar[CCDeptF], LCCDeptRec, aBufferSize[CCDeptF]
                , idxGetCombinations, BTRec.KeyS);
              end;{while}*)

              if BTRec.Status = 0 then
              begin
                // Duplicate
                AddMemoLine('Error Adding Record : Duplicate');
              end else
              begin
                // Save New Record
                BTRec.Status := BTAddRecord(aFileVar[CCDeptF], CCDeptRec, aBufferSize[CCDeptF], 0);
                if BTRec.Status <> 0 then
                begin
                  // Save Error
                  if BTRec.Status = 5 then AddMemoLine('Record Already Exists')
                  else AddMemoLine('Error Adding Record : BTAddRecord returned status ' + IntToStr(BTRec.Status));
                end else
                begin
                  // Saved OK
                  AddMemoLine('Record Imported');
                  inc(iRecordsAdded);
                end;{if}
              end;{if}
            end else
            begin
              // Type not found
              AddMemoLine('Error Adding Record : Valid/Invalid type is invalid.');
            end;{if}
          end else
          begin
            // Invalid VAT Code
            AddMemoLine('Error Adding Record : VAT Code '+ QuotedStr(Trim(CCDeptRec.cdVATCode))
            + ' is invalid.');
          end;{if}
        end else
        begin
          // Exchequer GL Code not found
          AddMemoLine('Error Adding Record : GLCode '+ QuotedStr(IntToStr(CCDeptRec.cdGLCode))
          + ' could not be found.');
        end;{if}
      end else
      begin
        // Exchequer Department not found
        AddMemoLine('Error Adding Record : Department '+ QuotedStr(Trim(CCDeptRec.cdDepartment))
        + ' could not be found.');
      end;{if}
    end else
    begin
      // Exchequer Cost Centre not found
      AddMemoLine('Error Adding Record : Cost Centre '+ QuotedStr(Trim(CCDeptRec.cdCostCentre))
      + ' could not be found.');
    end;{if}
  end;{AddRecord}

  function StrToCCDeptRec(sString : string) : TCCDeptRec;

    procedure AddField(iFieldNo : integer; sField : string);
    begin{AddField}
      with Result do begin
        case iFieldNo of
          1 : cdCostCentre := UpperCase(PadString(psRight, sField, ' ', 3));
          2 : cdDepartment := UpperCase(PadString(psRight, sField, ' ', 3));

          3 : begin
            if bUseGLs then cdGLCode := StrToIntDef(sField,0)
            else cdGLCode := iNO_GL;
          end;

          4 : begin
            if bUseVAT then
            begin
              if (sField = '') or (sField = ' ') or (sField = '0') or (length(sField) <> 1) then cdVATCode := #0
              else cdVATCode := sField[1];
            end else
            begin
              cdVATCode := #0;
            end;{if}
          end;
          5 : if (length(sField) = 1) then cdType := uppercase(sField)[1];
        end;{case}
      end;{with}
    end;{AddField}

  var
    QuoteMode, iFieldNo, iPos : integer;
    sField : string;
  const
    QM_OutsideQuotes = 0;
    QM_InsideQuotes = 1;

  begin{StrToCCDeptRec}
    FillChar(Result, SizeOf(Result), #0);
    Result.cdDummyChar := IDX_DUMMY_CHAR;

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
  end;{StrToCCDeptRec}

var
  slRecords : TStringList;
  ACCDeptRec : TCCDeptRec;
  iStatus, iPos : integer;

begin
  iRecordsAdded := 0;
  memInfo.Lines.Clear;

  if not FileExists(edFileName.Text) then
  begin
    memInfo.Lines.Add('File does not exist : ' + edFileName.Text);
    exit;
  end;{if}

  slRecords := TStringList.Create;
  slRecords.LoadFromFile(edFileName.Text);

  For iLineNo := 1 to slRecords.Count do
  begin
    AddRecord(StrToCCDeptRec(slRecords[iLineNo -1]));
  end;{for}

  slRecords.Free;

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

procedure TfrmImport.btnSaveClick(Sender: TObject);
begin
 SaveDialog.FileName := 'Import.txt';
 if SaveDialog.Execute then memInfo.Lines.SaveToFile(SaveDialog.filename);
end;

end.

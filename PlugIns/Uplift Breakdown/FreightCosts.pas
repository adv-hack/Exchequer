unit FreightCosts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , CustAbsU, Dialogs, StdCtrls, ComCtrls, P2UpliftPROC, TEditVal, ExtCtrls
  , Enterprise01_TLB;

type
  TfrmFreightCosts = class(TForm)
    pcTabs: TPageControl;
    tsExclusions: TTabSheet;
    btnApply: TButton;
    btnCancel: TButton;
    tsFreight: TTabSheet;
    Label1: TLabel;
    cmbCurrency: TComboBox;
    Panel1: TPanel;
    Shape1: TShape;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lCommission: TLabel;
    lImportDuty: TLabel;
    lFreight: TLabel;
    Label13: TLabel;
    lTotalUplift: TLabel;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Label15: TLabel;
    Label16: TLabel;
    edCommission: TCurrencyEdit;
    edImportDuty: TCurrencyEdit;
    edFreight: TCurrencyEdit;
    edTicketing: TCurrencyEdit;
    edProcessing: TCurrencyEdit;
    Panel2: TPanel;
    Shape8: TShape;
    Panel5: TPanel;
    Shape9: TShape;
    Label17: TLabel;
    lTotReceived: TLabel;
    cbLineTypes: TCheckBox;
    cbNonStock: TCheckBox;
    cbBOMKits: TCheckBox;
    Label10: TLabel;
    lTotReceivedValue: TLabel;
    Shape10: TShape;
    lApportUplift: TLabel;
    label21: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure ChangeValues(Sender: TObject);
    procedure IncludeClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure cmbCurrencyChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    iCurrentCcy, iNoOfQtyDecs, iNoOfValueDecs : byte;
    function IsBOMKit(sStockCode : string) : boolean;
  public
    iDefaultCcy : integer;
    rTotalUplift, rTotReceivedValue, rTotReceived : real;
    oEventData : TAbsEnterpriseSystem;
//    oEventData.Transaction : TAbsInvoice;
    procedure GetTotalReceivedTotals(var rTotReceived : real; var rTotValue : real);
  end;

var
  frmFreightCosts: TfrmFreightCosts;

implementation
uses
  APIUtil, MiscUtil, StrUtil;

{$R *.dfm}

procedure TfrmFreightCosts.FormShow(Sender: TObject);
begin
  iNoOfValueDecs := oToolkit.SystemSetup.ssCostDecimals;
  iNoOfQtyDecs := oToolkit.SystemSetup.ssQtyDecimals;

  edCommission.displayformat := '##0.00';
  edImportDuty.displayformat := edCommission.displayformat;
  edFreight.displayformat := edCommission.displayformat;

  edTicketing.displayformat := '#########0.' +  StringOfChar('0', iNoOfValueDecs);
  edProcessing.displayformat := edTicketing.displayformat;

  pcTabs.ActivePageIndex := 0;
  FillCurrencyCombo(cmbCurrency, iDefaultCcy);
  cmbCurrencyChange(cmbCurrency);
  lTotReceived.Caption := MoneyToStr(rTotReceived, iNoOfQtyDecs);
  lTotReceivedValue.Caption := MoneyToStr(rTotReceivedValue, iNoOfValueDecs);
end;

procedure TfrmFreightCosts.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmFreightCosts.ChangeValues(Sender: TObject);
begin
  lCommission.Caption := MoneyToStr((StrToFloatDef(edCommission.Text,0) / 100) * rTotReceivedValue, iNoOfValueDecs);
  lImportDuty.Caption := MoneyToStr((StrToFloatDef(edImportDuty.Text,0) / 100) * rTotReceivedValue, iNoOfValueDecs);
  lFreight.Caption := MoneyToStr((StrToFloatDef(edFreight.Text,0) / 100) * rTotReceivedValue, iNoOfValueDecs);

  rTotalUplift := StrToFloatDef(lCommission.Caption,0) + StrToFloatDef(lImportDuty.Caption,0)
  + StrToFloatDef(lFreight.Caption,0) + StrToFloatDef(edTicketing.Text,0)
  + StrToFloatDef(edProcessing.Text,0);

  lTotalUplift.Caption := MoneyToStr(rTotalUplift, iNoOfValueDecs);
  if rTotReceived > 0 then lApportUplift.Caption := MoneyToStr(rTotalUplift / rTotReceived, iNoOfValueDecs)
  else lApportUplift.Caption := MoneyToStr(0, iNoOfValueDecs);

  btnApply.Enabled := StrToFloatDef(lApportUplift.Caption, 0) > 0;
end;

procedure TfrmFreightCosts.GetTotalReceivedTotals(var rTotReceived : real; var rTotValue : real);
var
  iPos : integer;
begin{GetTotalReceivedValue}
  rTotReceived := 0;
  rTotValue := 0;
  For iPos := 1 to oEventData.Transaction.thLines.thLineCount do
  begin
    if (not cbLineTypes.Checked and (oEventData.Transaction.thLines.thLine[iPos].tlLineType in [0..4]))
    or (not cbNonStock.Checked and (Trim(oEventData.Transaction.thLines.thLine[iPos].tlStockCode) = ''))
    or (not cbBOMKits.Checked and IsBOMKit(oEventData.Transaction.thLines.thLine[iPos].tlStockCode))
    or ((oEventData.Transaction.thLines.thLine[iPos].tlBOMKitLink <> 0)
    and (oEventData.Transaction.thLines.thLine[iPos].tlStockCode <> '')) then // BOM components
    begin
      // Exclude Line
    end else
    begin
      // Include Line
      rTotReceived := rTotReceived + oEventData.Transaction.thLines.thLine[iPos].tlQtyPicked;
      rTotValue := rTotValue + (oEventData.Transaction.thLines.thLine[iPos].tlQtyPicked
      * oEventData.Transaction.thLines.thLine[iPos].tlNetValue);
    end;{if}
  end;{for}

  if oEventData.Transaction.thCurrency <> iCurrentCcy then
  begin
    // Convert To Selected Currency
    rTotValue := oToolkit.Functions.entConvertAmount(rTotValue
    ,oEventData.Transaction.thCurrency, iCurrentCcy, oToolkit.SystemSetup.ssCurrencyRateType);
  end;{if}
end;{GetTotalReceivedValue}


procedure TfrmFreightCosts.IncludeClick(Sender: TObject);
begin
  GetTotalReceivedTotals(rTotReceived, rTotReceivedValue);
  lTotReceived.Caption := MoneyToStr(rTotReceived, iNoOfQtyDecs);
  lTotReceivedValue.Caption := MoneyToStr(rTotReceivedValue, iNoOfValueDecs);
  ChangeValues(nil);
end;

procedure TfrmFreightCosts.btnApplyClick(Sender: TObject);
//var
//  rTotalUplifted : real;

  procedure UpdateUplift;
  // Update Uplift Field on all appropriate transaction lines
  var
    iStatus, iLine : integer;
    rTotalUpliftinTXCcy, rLineUplift : real;
//    oTransUpdate : ITransaction;
  begin
    // initialise
//    rLineUplift := StrToFloatDef(lApportUplift.Caption, 0);
//    rTotalUplifted := 0;

    // Get Transaction
    oToolkit.Transaction.Index := thIdxOurRef;
    iStatus := oToolkit.Transaction.GetEqual(oToolkit.Transaction.BuildOurRefIndex(oEventData.Transaction.thOurRef));
    if iStatus = 0 then
    begin

      rTotalUpliftinTXCcy := ConvertCurrency(StrToFloatDef(lCommission.Caption, 0), iCurrentCcy
      , oToolkit.Transaction.thCurrency)
      + ConvertCurrency(StrToFloatDef(lImportDuty.Caption, 0), iCurrentCcy
      , oToolkit.Transaction.thCurrency)
      + ConvertCurrency(StrToFloatDef(lFreight.Caption, 0), iCurrentCcy
      , oToolkit.Transaction.thCurrency)
      + ConvertCurrency(StrToFloatDef(edTicketing.Text, 0), iCurrentCcy
      , oToolkit.Transaction.thCurrency)
      + ConvertCurrency(StrToFloatDef(edProcessing.Text, 0), iCurrentCcy
      , oToolkit.Transaction.thCurrency);

      if rTotReceived > 0 then rLineUplift := StrToFloatDef(MoneyToStr(rTotalUpliftinTXCcy
      / rTotReceived, iNoOfValueDecs), 0)
      else rLineUplift := 0;

      if rLineUplift = 0 then
      begin
        // no uplift - do nothing
      end else
      begin

        with oToolkit.Transaction do
        begin

          // Convert to TX Currency
{          if iCurrentCcy <> oToolkit.Transaction.thCurrency then
          begin
            rLineUplift := oToolkit.Functions.entConvertAmount(rLineUplift
            ,iCurrentCcy, oToolkit.Transaction.thCurrency
            , oToolkit.SystemSetup.ssCurrencyRateType);
          end;{if}

          // Go through all TX lines
          For iLine := 1 to thLines.thLineCount do
          begin
            if (not cbLineTypes.Checked and (thLines.thLine[iLine].tlLineType in [0..4]))
            or (not cbNonStock.Checked and (Trim(thLines.thLine[iLine].tlStockCode) = ''))
            or (not cbBOMKits.Checked and IsBOMKit(Trim(thLines.thLine[iLine].tlStockCode)))
            or ((thLines.thLine[iLine].tlBOMKitLink <> 0)
            and (thLines.thLine[iLine].tlStockCode <> '')) then // BOM components
            begin
              // Exclude Line
            end else
            begin
              // Update Line Uplift
              iStatus := (thLines.thLine[iLine] as ITransactionLine2).UpdateUplift(rLineUplift);
              if iStatus <> 0 then
              begin
                MsgBox('UpdateUplift failed with the error code : ' + IntToStr(iStatus)
                , mtError, [mbOK], mbOK, 'UpdateUplift Error');
              end;
  //            thLines.thLine[iLine].tlCost := rLineUplift;
//              rTotalUplifted := rTotalUplifted + (rLineUplift * thLines.thLine[iLine].tlQtyPicked);
            end;{if}
          end;{for}
  //        oTransUpdate.Save(TRUE);
        end;{with}
      end;{if}
    end else
    begin
      MsgBox('oToolkit.Transaction.GetEqual (' + oEventData.Transaction.thOurRef
      + ') failed with the error code : ' + IntToStr(iStatus), mtError, [mbOK]
      , mbOK, 'UpdateUplift Error');
    end;{if}
  end;{UpdateUplift}

  procedure AddNotes;

    Function GetNoteText(iNoteNo : integer) : string;
    var
      rValue : real;
    begin{GetNoteText}
      Result := '';
      case iNoteNo of
        1 : rValue := ConvertCurrency(StrToFloatDef(lCommission.Caption, 0), iCurrentCcy
        , oToolkit.Transaction.thCurrency);
        2 : rValue := ConvertCurrency(StrToFloatDef(lImportDuty.Caption, 0), iCurrentCcy
        , oToolkit.Transaction.thCurrency);
        3 : rValue := ConvertCurrency(StrToFloatDef(lFreight.Caption, 0), iCurrentCcy
        , oToolkit.Transaction.thCurrency);
        4 : rValue := ConvertCurrency(StrToFloatDef(edTicketing.Text, 0), iCurrentCcy
        , oToolkit.Transaction.thCurrency);
        5 : rValue := ConvertCurrency(StrToFloatDef(edProcessing.Text, 0), iCurrentCcy
        , oToolkit.Transaction.thCurrency);
      end;{Case}
      Result := aNotes[iNoteNo] + MoneyToStr(rValue, iNoOfValueDecs);
    end;{GetNoteText}

    procedure AddNote(iNewLineNo : integer);
    var
      iLine, iStatus : integer;
    begin {AddNote}
      oToolkit.Transaction.thNotes.ntType := ntTypeGeneral;
      with oToolkit.Transaction.thNotes.add do begin
    //        ntType := ntTypeGeneral;
    //        ntDate := DateToStr8(Date);
        ntOperator := oEventData.UserName;
        ntLineNo := iNewLineNo;
        ntText := GetNoteText(iNewLineNo);
        iStatus := Save;
        if iStatus <> 0
        then ShowMessage('Could not Add note.'#13#13'Error No : ' + IntToStr(iStatus));
      end;{with}
    end;{AddNote}

    procedure EditNote(iNewLineNo : integer);
    var
      iLine, iStatus : integer;
      oUpdateNote : INotes;
    begin {EditNote}
      oUpdateNote := oToolkit.Transaction.thNotes.Update;
      if oUpdateNote = nil then
      begin
        ShowMessage('Could not Update note.'#13#13
        + 'oToolkit.Transaction.thNotes.Update Returned nil');
      end else
      begin
        with oUpdateNote do begin
          ntOperator := oEventData.UserName;
          ntLineNo := iNewLineNo;
          ntText := GetNoteText(iNewLineNo);
          iStatus := Save;
          if iStatus <> 0
          then ShowMessage('Could not Update note.'#13#13'Error No : ' + IntToStr(iStatus));
        end;{with}
      end;
    end;{EditNote}

  var
    iPos : integer;
  begin{AddNotes}
    // Delete any existing notes in lines 1..5
    oToolkit.Transaction.thNotes.ntType := ntTypeGeneral;
    For iPos := 1 to 5 do
    begin
      if oToolkit.Transaction.thNotes.GetEqual(oToolkit.Transaction.thNotes.BuildIndex(iPos)) = 0
      then EditNote(iPos)
      else AddNote(iPos);
    end;{for}
  end;{AddNotes}

begin
  Screen.cursor := crHourglass;
  try
    UpdateUplift;
    AddNotes;
  finally
    Screen.cursor := crDefault;
  end;
  ModalResult := mrOK;
end;

function TfrmFreightCosts.IsBOMKit(sStockCode : string) : boolean;
var
  iStatus : integer;
begin{IsBOMKit}
  Result := FALSE;
  oToolkit.Stock.Index := stIdxCode;
  iStatus := oToolkit.Stock.GetEqual(oToolkit.Stock.BuildCodeIndex(Trim(sStockCode)));
  if iStatus = 0 then Result := oToolkit.Stock.stType = stTypeBillOfMaterials;
end;{IsBOMKit}

procedure TfrmFreightCosts.cmbCurrencyChange(Sender: TObject);
begin
  iCurrentCcy := TCurrencyInfo(cmbCurrency.Items.Objects[cmbCurrency.ItemIndex]).CurrencyNo;
  IncludeClick(nil);
end;

procedure TfrmFreightCosts.FormDestroy(Sender: TObject);
begin
  ClearList(cmbCurrency.Items);
end;

end.

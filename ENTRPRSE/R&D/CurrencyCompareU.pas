unit CurrencyCompareU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Grids, DBGrids, DB, ADODB, oSystemSetup, VarRec2U;

type
  TfrmCurrUpdateConfirm = class(TForm)
    pnlClient: TPanel;
    CancelBtn: TButton;
    dbgrdCurrUpdateComp: TDBGrid;
    Notelbl: TLabel;
    tblCurrencyImport: TADODataSet;
    ds1: TDataSource;
    tblCurrencyImportNo: TIntegerField;
    tblCurrencyImportDescription: TStringField;
    tblCurrencyImportScreen: TStringField;
    tblCurrencyImportPrinter: TStringField;
    tblCurrencyImportOldDailyRate: TFloatField;
    tblCurrencyImportNewDailyRate: TFloatField;
    tblCurrencyImportOldCompanyRate: TFloatField;
    tblCurrencyImportNewCompanyRate: TFloatField;
    tblCurrencyImportDailyRateChange: TFloatField;
    tblCurrencyImportCompanyRateChange: TFloatField;
    ImportRatesBtn: TButton;
    btnReval: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tblCurrencyImportCalcFields(DataSet: TDataSet);
    procedure dbgrdCurrUpdateCompColumnMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure ImportRatesBtnClick(Sender: TObject);
    procedure dbgrdCurrUpdateCompDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure btnRevalClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

    //AP : 25/05/2017:2017-R12 ABSEXCH-18576 Revalue Button - Revaluation via Currency Rate Comparison screen
    FPrevCurrencies: CurrRec;
    FPrevGhostCurrencies: GCurRec;
    FIsRevalue: Boolean;
    function LoadDataSet(AStringList: TStringList): Boolean;
    
    //SS:26/05/2017:2017-R12:ABSEXCH-18574:Currency Rate comparison screen to highlight if that tolerance has been exceeded.
    function IsCurrChangeExceed(aField : TField): Boolean;

  public
    constructor Create(AOwner: TComponent; AStringList: TStringList); overload;
	//VA 11/05/2018 2018-R1.1 ABSEXCH-20488:Utilities > Currency Setup > Currency Update Confirmation Window Changes
    constructor Create(AOwner: TComponent; AStringList: TStringList; aIsRevalue : Boolean); overload;

     //PL:30/05/2017:2017-R12: ABSEXCH-18748 Update the History of Changes table for the Currency in the Currency set-up
     //ABSEXCH-18576 Revalue Button - Revaluation via Currency Rate Comparison screen
    procedure UpdateRates(const aCurrNo : Integer; const Mode: Boolean);
    //VA 11/05/2018 2018-R1.1 ABSEXCH-20488:Utilities > Currency Setup > Currency Update Confirmation Window Changes	
    property IsRevalue : Boolean read FIsRevalue write FIsRevalue;

  end;


implementation

uses
  CurrencyListF, PWarnU,  Btsupu1, BTSupU2, VarConst;
{$R *.dfm}

constructor TfrmCurrUpdateConfirm.Create(AOwner: TComponent; AStringList: TStringList);
var
  Result: Boolean;
begin
  inherited Create(AOwner);
  //store the history records when we start the revaluation.
  Result:=LoadDataSet(AStringList);
end;

//VA 11/05/2018 2018-R1.1 ABSEXCH-20488:Utilities > Currency Setup > Currency Update Confirmation Window Changes	
constructor TfrmCurrUpdateConfirm.Create(AOwner: TComponent; AStringList: TStringList; aIsRevalue : Boolean); 
var
  Result: Boolean;
begin
  inherited Create(AOwner);
  FIsRevalue := aIsRevalue;
  //store the history records when we start the revaluation.
  Result:=LoadDataSet(AStringList);
end;

//PL 19-05-2017: ABSEXCH-18561 Load data to ADODataset from stringlist
function TfrmCurrUpdateConfirm.LoadDataSet(AStringList: TStringList): Boolean;
var
  i,
  lCount: Integer;
  lStringList: TStringList;
begin
    lCount:= AStringList.Count;
    lStringList:= TStringList.Create;
    try
      tblCurrencyImport.CreateDataSet;
      tblCurrencyImport.DisableControls;
      try

        for i:=0 to lCount-1 do
        begin
          lStringList.DelimitedText := AStringList[i];


          with tblCurrencyImport do
          begin
            Append();
            tblCurrencyImportNo.Value            := StrToInt(lStringList[0]);
            tblCurrencyImportDescription.Value   := lStringList[1];
            tblCurrencyImportScreen.Value        := lStringList[2];
            tblCurrencyImportPrinter.Value       := lStringList[3];
            tblCurrencyImportOldDailyRate.Value  := StrToFloat(lStringList[4]);
            tblCurrencyImportNewDailyRate.Value  := StrToFloat(lStringList[5]);
            tblCurrencyImportOldCompanyRate.Value:= StrToFloat(lStringList[6]);
            tblCurrencyImportNewCompanyRate.Value:= StrToFloat(lStringList[7]);
            Post();

            //VA 11/05/2018 2018-R1.1 ABSEXCH-20488:Utilities > Currency Setup > Currency Update Confirmation Window Changes	
            if (not FIsRevalue) and (tblCurrencyImportCompanyRateChange.Value <>0) and ChkAllowed_In(82) then
            begin
              btnReval.Enabled := True;
            end;

          end;
        end;
      finally
        tblCurrencyImport.EnableControls;
      end;
    finally
      lStringList.Free;
    end;
end;

//AP 18-05-2017: ABSEXCH-18710 - UI- Currency Update Confirmation Screen
procedure TfrmCurrUpdateConfirm.FormCreate(Sender: TObject);
begin
  //AP:06/06/2017:2017-R12:ABSEXCH-17121 : Comparison Screen window should be same size of Currency Set up
  ClientHeight := 440;
  ClientWidth := 873;

  //AP:06/06/2017:2017-R12:ABSEXCH-17121 Currency Setup - UX
  Notelbl.Top := 423;

  //AP:06/06/2017:2017-R12:ABSEXCH-17121 Currency Setup - UX
  ImportRatesBtn.Left := dbgrdCurrUpdateComp.Width + 10;
  //AP 22/02/2018 ABSEXCH-19765:Remove ‘Revalue G/L’ from the Currency Update Confirmation window
  //RevalueBtn.Left := dbgrdCurrUpdateComp.Width + 10;
  CancelBtn.Left:= dbgrdCurrUpdateComp.Width + 10;


  ShowScrollBar(dbgrdCurrUpdateComp.Handle,SB_VERT,True);
  EnableScrollBar(dbgrdCurrUpdateComp.Handle,SB_VERT,ESB_ENABLE_BOTH);

  //AP : 25/05/2017:2017-R12 ABSEXCH-18576 Revalue Button - Revaluation via Currency Rate Comparison screen
  FPrevCurrencies := SyssCurr^;
  FPrevGhostCurrencies := SyssGCuR^;


  dbgrdCurrUpdateComp.SelectedRows.Clear;
end;


//AP 18-05-2017: ABSEXCH-18710 - UI- Currency Update Confirmation Screen
procedure TfrmCurrUpdateConfirm.FormResize(Sender: TObject);
begin
  dbgrdCurrUpdateComp.Height := ClientHeight - 27;
  dbgrdCurrUpdateComp.Width := ClientWidth - 115;

  //AP:06/06/2017:2017-R12:ABSEXCH-17121 Currency Setup - UX
  ImportRatesBtn.Left := dbgrdCurrUpdateComp.Width + 10;
  //AP 22/02/2018 ABSEXCH-19765:Remove ‘Revalue G/L’ from the Currency Update Confirmation window
  //RevalueBtn.Left := dbgrdCurrUpdateComp.Width + 10;
  CancelBtn.Left:= dbgrdCurrUpdateComp.Width + 10;
end;

procedure TfrmCurrUpdateConfirm.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCurrUpdateConfirm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

//PL 19-05-2017: ABSEXCH-18561 change in currancy rate will be calculated
procedure TfrmCurrUpdateConfirm.tblCurrencyImportCalcFields(
  DataSet: TDataSet);
var
  lDailyRate,lCompRate : Double;
begin
  lDailyRate := tblCurrencyImportNewDailyRate.Value - tblCurrencyImportOldDailyRate.Value;
  lCompRate := tblCurrencyImportNewCompanyRate.Value - tblCurrencyImportOldCompanyRate.Value;

  //AP:06/06/2017:2017-R12:ABSEXCH-17121 Currency Setup - UX
  if lDailyRate <> 0 then
    tblCurrencyImportDailyRateChange.Value := lDailyRate;

  if lCompRate <> 0  then
  tblCurrencyImportCompanyRateChange.Value := lCompRate;

end;

procedure TfrmCurrUpdateConfirm.dbgrdCurrUpdateCompColumnMoved(
  Sender: TObject; FromIndex, ToIndex: Integer);
begin
   TDbGrid(Sender).Columns[ToIndex].Index := FromIndex;
end;

procedure TfrmCurrUpdateConfirm.UpdateRates(const aCurrNo : Integer; const Mode: Boolean);
var
  lIndex : Integer;
begin
  if (SyssCurr.Currencies[aCurrNo].Desc = tblCurrencyImportDescription.Value)  then
  begin
    SyssCurr.Currencies[aCurrNo].CRates[True] := tblCurrencyImportNewDailyRate.Value;

    //SS:06/04/2018:2018-R1:ABSEXCH-20350:Currency Import returning error.
    lIndex := TfrmCurrencyList(owner).mlCurrencies.Columns[0].Items.IndexOf(InttoStr(aCurrNo));
    TfrmCurrencyList(owner).mlCurrencies.DesignColumns[4].Items[lIndex] := Format('%8.6f', [tblCurrencyImportNewDailyRate.Value]);

    //VA 11/05/2018 2018-R1.1 ABSEXCH-20488:Utilities > Currency Setup > Currency Update Confirmation Window Changes	  
    if not Mode then
       TfrmCurrencyList(Owner).ImportAddCurrencyHistory(aCurrNo)
    else
       TfrmCurrencyList(Owner).CurrenciesChanged[aCurrNo] := True;


    if Mode then
    begin
      SyssCurr.Currencies[aCurrNo].CRates[False] := tblCurrencyImportNewCompanyRate.Value;
      TfrmCurrencyList(owner).mlCurrencies.DesignColumns[5].Items[lIndex] := Format('%8.6f', [tblCurrencyImportNewCompanyRate.Value]);
    end;
  end;

end;

//PL:30/05/2017:2017-R12: ABSEXCH-18748 Update the History of Changes table for the Currency in the Currency set-up
 procedure TfrmCurrUpdateConfirm.ImportRatesBtnClick(Sender: TObject);
var
  lCurrNo : Integer;
  lCurrDesc : string;
  lNewDailyRate : Double;
  lChangeFound : Boolean;
begin
  if (Owner  is TfrmCurrencyList) then
  begin
    tblCurrencyImport.DisableControls;
    lChangeFound:= False;
    try

      tblCurrencyImport.First;

      while not tblCurrencyImport.eof do
      begin
        //AP 22/02/2018 ABSEXCH-19764:From Revalue Currency Rates window - Change button ‘Import Daily Rates’ to ‘Import Rates’
        if (tblCurrencyImportDailyRateChange.Value <> 0) or (tblCurrencyImportCompanyRateChange.Value <> 0) then
        begin
		  //VA 11/05/2018 2018-R1.1 ABSEXCH-20488:Utilities > Currency Setup > Currency Update Confirmation Window Changes	
          UpdateRates(tblCurrencyImportNo.Value, IsRevalue);
          lChangeFound:= True;
        end;

        tblCurrencyImport.Next;

      end;
      //VA 11/05/2018 2018-R1.1 ABSEXCH-20488:Utilities > Currency Setup > Currency Update Confirmation Window Changes	
      if lChangeFound and (not IsRevalue) then
      begin
        PutMultiSysCur(False);
        PutMultiSysGCur(False);
      end;

      if TfrmCurrencyList(Owner).ImportCurrenciesLocked then
        TfrmCurrencyList(Owner).ImportCurrUnlock();
    finally
      tblCurrencyImport.EnableControls;
    end;

  end;
  Close;

end;

//SS:26/05/2017:2017-R12:ABSEXCH-18574:Currency Rate comparison screen to highlight if that tolerance has been exceeded.
// Check weather currency change is exceed the range of the Currency Import Tolerance or not.
function TfrmCurrUpdateConfirm.IsCurrChangeExceed(aField : TField):Boolean;
var
  lChangeInPer : Double;
  lCurrImportTol : Double;
begin
  Result := False;
  lCurrImportTol := SystemSetup(True).CurrencySetup.ssCurrImportTol;

  if lCurrImportTol = 0 then Exit;

  if aField = tblCurrencyImportDailyRateChange then
  begin
    if tblCurrencyImportOldDailyRate.Value <> 0 then
    begin
      lChangeInPer := ((tblCurrencyImportDailyRateChange.Value * 100)/tblCurrencyImportOldDailyRate.Value);
      Result := Abs(lChangeInPer) > Abs(lCurrImportTol);
    end;
  end
  else if aField = tblCurrencyImportCompanyRateChange then
  begin
    if tblCurrencyImportOldCompanyRate.Value <> 0 then
    begin
      lChangeInPer := ((tblCurrencyImportCompanyRateChange.Value * 100)/tblCurrencyImportOldCompanyRate.Value);
      Result := Abs(lChangeInPer) > Abs(lCurrImportTol);
    end;
  end;     
end;


//SS:26/05/2017:2017-R12:ABSEXCH-18574:Currency Rate comparison screen to highlight if that tolerance has been exceeded.
procedure TfrmCurrUpdateConfirm.dbgrdCurrUpdateCompDrawColumnCell(
  Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  //PL:30/05/2017:2017-R12:ABSEXCH-17121 Currency Setup - UX
  //AP:06/06/2017:2017-R12:ABSEXCH-17121 Roll back the blue highlighter on comparison screen.
  //dbgrdCurrUpdateComp.Canvas.Brush.Color := clWhite;
  
  dbgrdCurrUpdateComp.Canvas.Font.Color := clNavy;

  //AP : 13/06/2017 : ABSEXCH-17121 : White colored fonts of the Highlighted row
  if (dbgrdCurrUpdateComp.Focused) and (gdSelected in  State) then
    dbgrdCurrUpdateComp.Canvas.Font.Color := clWhite;


    //dbgrdCurrUpdateComp.Canvas.Font.Color := clNavy;

  if (Column.Field = tblCurrencyImportDailyRateChange) or (Column.Field = tblCurrencyImportCompanyRateChange) then
  begin
    if IsCurrChangeExceed(Column.Field) then
      dbgrdCurrUpdateComp.Canvas.Brush.Color := clYellow;

    if  gdSelected in  State  then
      dbgrdCurrUpdateComp.Canvas.Font.Color := clNavy;

  end;
    
  dbgrdCurrUpdateComp.DefaultDrawColumnCell(Rect,DataCol,Column,State);

end ;

//VA 11/05/2018 2018-R1.1 ABSEXCH-20488:Utilities > Currency Setup > Currency Update Confirmation Window Changes	
procedure TfrmCurrUpdateConfirm.btnRevalClick(Sender: TObject);
var
  lCurrNo : Integer;
  lChangeFound,
  OkToRev : Boolean;
begin
  lChangeFound := False;
  
  OkToRev := TfrmCurrencyList(owner).OKToRevalue;
  if OkToRev then
  begin
    if (Owner  is TfrmCurrencyList) then
    begin
      tblCurrencyImport.DisableControls;
      try
        tblCurrencyImport.First;
        while not tblCurrencyImport.eof do
        begin
          if (tblCurrencyImportDailyRateChange.Value <> 0) or (tblCurrencyImportCompanyRateChange.Value <> 0) then
          begin
            lCurrNo := tblCurrencyImportNo.Value;
            TfrmCurrencyList(Owner).CurrenciesChanged[lCurrNo] := True;
            UpdateRates(lCurrNo,True);
            lChangeFound := True;
          end;

          tblCurrencyImport.Next;

        end;

      finally
        tblCurrencyImport.EnableControls;
      end;

      if lChangeFound then
      begin
        TfrmCurrencyList(Owner).ExecCurrReval(FPrevCurrencies, FPrevGhostCurrencies);
        TfrmCurrencyList(Owner).mlCurrencies.Refresh;

      end;
    end;
  end
  else
    exit;
end;

{AP 18-05-2017: ABSEXCH-18710 - UI- Currency Update Confirmation Screen
LoginDialogExProc dialog gets initializ in initialization block of DBLogDlg.pas
 a databse login propmt}
//VA 11/05/2018 2018-R1.1 ABSEXCH-20488:Utilities > Currency Setup > Currency Update Confirmation Window Changes	
procedure TfrmCurrUpdateConfirm.FormShow(Sender: TObject);
begin
  if not IsRevalue then
   ImportRatesBtn.Caption := 'Import Daily Rates';
end;

initialization
  LoginDialogExProc := nil;

end.

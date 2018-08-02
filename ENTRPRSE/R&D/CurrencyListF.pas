unit CurrencyListF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, TCustom, ExtCtrls, uMultiList,
   VarConst, Varrec2U,   EntWindowSettings, CurrencyDetailsF,
  AuditIntf,  // CA 15/02/2013 v7.0.2 : ABSEXCH-14003 : New Audit for this screen has been done
   CurrencyCompareU; //PL 19-05-2017: ABSEXCH-18561 CurrencyCompareU.pas added

type
  //Enumeration to be passed into new constructor to allow caller to specify what the form is being used for.
  TCurrencyListMode = (clmNormal, clmRevalue);

  TExportOrder = (eoByDate, eoByCurrencyNo);

  TfrmCurrencyList = class(TForm)
    mlCurrencies: TMultiList;
    btnAdd: TSBSButton;
    btnEdit: TSBSButton;
    btnView: TSBSButton;
    btnClose: TSBSButton;
    PopupMenu1: TPopupMenu;
    Properties1: TMenuItem;
    N1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    btnCancel: TSBSButton;
    btnExport: TSBSButton;
    btnExportRates: TSBSButton;
    btnImportRates: TSBSButton;
    mnuExport: TPopupMenu;
    OrderbyDate1: TMenuItem;
    OrderbyCurrency1: TMenuItem;
    SaveDialog1: TSaveDialog;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    View1: TMenuItem;
    ExportHistory1: TMenuItem;
    N2: TMenuItem;
    OrderByDate2: TMenuItem;
    OrderByCurrencyNo1: TMenuItem;
    ExportRates1: TMenuItem;
    ImportRates1: TMenuItem;
    N3: TMenuItem;
    bvlSeparator: TBevel;
    OpenDialog1: TOpenDialog;
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure mlCurrenciesRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnExportClick(Sender: TObject);
    procedure OrderbyDate1Click(Sender: TObject);
    procedure OrderbyCurrency1Click(Sender: TObject);
    procedure mlCurrenciesChangeSelection(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mlCurrenciesResize(Sender: TObject);
    procedure btnExportRatesClick(Sender: TObject);
    procedure btnImportRatesClick(Sender: TObject);
  private
    { Private declarations }

    FIsRevalue : Boolean;
    TotalCurrencies : Integer;

    PrevCurrencies :  CurrRec;
    PrevGhostCurrencies
                   :  GCurRec;

    FSettings :IWindowSettings;

    CurrenciesLocked : Boolean;

    FCurrenciesChanged : TBits;

    // CA 15/02/2013 v7.0.2 ABSEXCH-14003: Added the two CIS Setup Audit Trail files
    CurrencySetupAudit    : IBaseAudit;

    procedure AddCurrency(Index: Integer);
    procedure ShowDetails(DetailsMode : TDetailsMode);

    procedure StoreCurrency(const DetailsForm : TfrmCurrencyDetails);
    procedure UnlockCurrencies;

    procedure AddCurrencyHistory(Index : Integer);
    function CheckCanRevalue : Boolean;
    procedure SetAddButton;
    function CurrencyUsed(Index : Integer) : Boolean;
    procedure ExportHistory(OrderBy : TExportOrder);
    //PR: 16/08/2012 ABSEXCH-13278 Function to add history records when we start a revaluation
    procedure AddHistoryRecsForRevaluedCurrencies;

    //PR: 31/10/2012 ABSEXCH-13627 Added menu items to duplicate button functions. This function sets Menu Item enabled from corresponding buttons.
    procedure SetMenuItems;

  protected
    //PR: 15/11/2012 ABSEXCH-13730 Need to override CreateParams to set the FormStyle correctly before the window is created.
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    //New constructor to allow caller to specify what the form is being used for - editing currencies or revaluing.
    constructor CreateWithMode(AOwner : TComponent; AMode : TCurrencyListMode);
    procedure ExportToCsv(aFilename: string);
    function LoadCurrencies : Boolean;
    function OKToRevalue : Boolean;
    //VA:21/02/2018:2018-R1:ABSEXCH-19792: Export History: I/O error 32 message to be changed and Application crashes when closing the error pop up
    function IsFileInUse(aName: string) : boolean;
    //AP : 25/05/2017:2017-R12 ABSEXCH-18576 Revalue Button - Revaluation via Currency Rate Comparison screen
    procedure ExecCurrReval(aPrevCurrencies: CurrRec; aPrevGhostCurrencies: GCurRec);

    //PL:30/05/2017:2017-R12: ABSEXCH-18601 Import Daily Rates Button - Currency for Daily rates to update on clicking the button
  	procedure ImportCurrUnlock();

    //PL:31/05/2017:2017-R12: ABSEXCH-18748 Update the History of Changes table for the Currency in the Currency set-up
    procedure ImportAddCurrencyHistory(Index : Integer);

    //AP : 25/05/2017:2017-R12 ABSEXCH-18576 Revalue Button - Revaluation via Currency Rate Comparison screen
    property CurrenciesChanged : TBits read FCurrenciesChanged;

    //PL:30/05/2017:2017-R12: ABSEXCH-18601 Import Daily Rates Button - Currency for Daily rates to update on clicking the button
    property ImportCurrenciesLocked : Boolean read CurrenciesLocked;
  end;



implementation

uses
  BtSupU1, BtSupU2, GlobVar, IIFFuncs, ApiUtil, CurrencyHistoryClass, PostingU, Excep2U, GenWarnU,
  CurrncyU, EtDateU, RevalueU, BtrvU2, oProcessLock;

{$R *.dfm}


procedure TfrmCurrencyList.btnCloseClick(Sender: TObject);
begin
  //Calling Close sets ModalResult to mrCancel
  if not FIsRevalue then
  Begin
    Close;
  End;
end;

procedure TfrmCurrencyList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;

  //Send message to EParentU to nil the ChangeCurr variable
  SendMessage((Owner as TForm).Handle, WM_FormCloseMsg, 51, 0);

  //Properties stuff
  if Assigned(FSettings) then
  begin
    FSettings.WindowToSettings(Self);
    FSettings.ParentToSettings(mlCurrencies, mlCurrencies);
    FSettings.SaveSettings(SaveCoordinates1.Checked);
    FSettings := nil;
  end;

  //Run revaluation
  if FIsRevalue and (ModalResult = mrOK) then
  begin

     // CA 15/02/2013 v7.0.2 ABSEXCH-14003: Setting up the After CurrencySetupAudit
    if Assigned(CurrencySetupAudit) Then
    Begin
      CurrencySetupAudit.AfterData := SyssCurr;
      CurrencySetupAudit.WriteAuditEntry;
      CurrencySetupAudit := NIL;
    End;

    //ABSEXCH-13278 If we're revaluing and don't cancel then store and unlock the currencies + add history recs.
    if AddRevalue2Thread(Application.MainForm, PrevCurrencies, PrevGhostCurrencies) then
    begin
      PutMultiSysCur(True);
      PutMultiSysGCur(True);
      CurrenciesLocked := False;
      AddHistoryRecsForRevaluedCurrencies;
    end
    else
      ModalResult := mrCancel;

  end;

  //Unlock the currency records
  if CurrenciesLocked then
    UnlockCurrencies;
end;

procedure TfrmCurrencyList.ImportAddCurrencyHistory(Index : Integer);
begin
  AddCurrencyHistory(Index);
end;

//PL:30/05/2017:2017-R12: ABSEXCH-18601 Import Daily Rates Button - Currency for Daily rates to update on clicking the button
procedure TfrmCurrencyList.ImportCurrUnlock();
begin
   //Unlock the currency records
  if CurrenciesLocked then
    UnlockCurrencies;
end;


//AP : 25/05/2017:2017-R12 ABSEXCH-18576 Revalue Button - Revaluation via Currency Rate Comparison screen
procedure TfrmCurrencyList.ExecCurrReval(aPrevCurrencies: CurrRec; aPrevGhostCurrencies: GCurRec );
begin
  if Assigned(CurrencySetupAudit) Then
    Begin
      CurrencySetupAudit.AfterData := SyssCurr;
      CurrencySetupAudit.WriteAuditEntry;
      CurrencySetupAudit := NIL;
    End;

  //ABSEXCH-13278 If we're revaluing and don't cancel then store and unlock the currencies + add history recs.
  if AddRevalue2Thread(Application.MainForm, aPrevCurrencies, aPrevGhostCurrencies) then
  begin
    PutMultiSysCur(True);
    PutMultiSysGCur(True);
    CurrenciesLocked := False;
    AddHistoryRecsForRevaluedCurrencies;
  end;

  //Unlock the currency records
  if CurrenciesLocked then
    UnlockCurrencies;
end;

function TfrmCurrencyList.LoadCurrencies : Boolean;
var
  TmpLock : Boolean;
  TmpLockG : Boolean;
  CurrNo : Integer;
begin
  //Set total number of currencies
  if EuroVers then
    TotalCurrencies := 2
  else
    TotalCurrencies := CurrencyType;

  //Try to Lock records
  TmpLock := True;
  TmpLockG := True;

  if GetMultiSysCur(False, TmpLock) and GetMultiSysGCur(False, TmpLockG) and TmpLock and TmpLockG then
    CurrenciesLocked := True;

  if not CurrenciesLocked then
  begin
    //Load records without locking and set to view only mode.
    TmpLock := False;
    GetMultiSysCur(False, TmpLock);
    GetMultiSysGCur(False, TmpLockG);
    btnAdd.Enabled := False;
    btnEdit.Enabled := False;
  end;

  //Read through currencies and add used currencies to list
  for CurrNo := 0 to TotalCurrencies do
    if CurrencyUsed(CurrNo) then
       AddCurrency(CurrNo);

  //Don't allow adding new currencies if we've reached the maximum
  SetAddButton;

  //PR: 31/10/2012 ABSEXCH-13627
  SetMenuItems;

  mlCurrencies.Selected := 0;

  if not CurrenciesLocked then
  begin
    if FIsRevalue then //Can't run revalue - just close
    begin
      msgBox('The currency table has been locked by another user. Revaluation cannot proceed.', mtInformation, [mbOK], mbOk, 'Revaluation');
      PostMessage(Self.Handle, WM_CLOSE, 0, 0);
    end
    else
      msgBox('The currency table has been locked by another user. Currency records can only be viewed.', mtInformation, [mbOK], mbOk, 'Currency list');
  end;

  // CA 15/02/2013 v7.0.2 ABSEXCH-14003: Setting up the before CurrencySetupAudit to see if fields have changed
  if  CurrenciesLocked Then
  Begin
    CurrencySetupAudit := NewAuditInterface(atCurrencySetup);
    CurrencySetupAudit.BeforeData := SyssCurr;
  End;

  //If we're revaluing then take a copy of the existing currency rates
  if FIsRevalue and CurrenciesLocked then
  begin
    PrevCurrencies := SyssCurr^;
    PrevGhostCurrencies :=SyssGCuR^;
  end;

  Result := CurrenciesLocked; //Result is only used by revaluation
end;

procedure TfrmCurrencyList.AddCurrency(Index: Integer);
begin
  //Add currency details into the multilist
  with mlCurrencies do
  begin
   DesignColumns[0].Items.Add(IntToStr(Index));

   DesignColumns[1].Items.Add(TxLatePound(SyssCurr.Currencies[Index].Desc, True));
   DesignColumns[2].Items.Add(TxLatePound(SyssCurr.Currencies[Index].SSymb, True));
   DesignColumns[3].Items.Add(TxLatePound(SyssCurr.Currencies[Index].PSymb, True));
   DesignColumns[4].Items.Add(Format('%8.6f', [SyssCurr.Currencies[Index].CRates[True]]));
   DesignColumns[5].Items.Add(Format('%8.6f', [SyssCurr.Currencies[Index].CRates[False]]));

   DesignColumns[6].Items.Add(IIF(SyssGCur^.GhostRates.TriInvert[Index], 'Yes', ''));
   DesignColumns[7].Items.Add(IIF(SyssGCur^.GhostRates.TriFloat[Index], 'Yes', ''));
   DesignColumns[8].Items.Add(IntToStr(SyssGCur^.GhostRates.TriEuro[Index]));
   DesignColumns[9].Items.Add(Format('%8.6f', [SyssGCur^.GhostRates.TriRates[Index]]));
  end;
end;

procedure TfrmCurrencyList.FormCreate(Sender: TObject);
begin
//PR: 07/11/2012 ABSEXCH-13664 Change way in which form is created to avoid flicker.
  if not FIsRevalue then
  begin
//    FormStyle := fsMDIChild;
  end
  else
  begin
    //PR: 15/11/2012 ABSEXCH-13730 FormStyle now set in CreateParams.
//    FormStyle := fsNormal;
    //PR: 16/08/2012 ABSECH-13273
    Caption := 'Revalue Currency Rates.';
    btnClose.Caption := '&Revalue';
    btnClose.Cancel := False;
    btnClose.ModalResult := mrOK;
    btnCancel.Visible := True;

    btnAdd.Enabled := False;



  end;

  
  //PR: 16/08/2012 ABSEXCH-13278 TBits to keep a record of which currencies have been changed, so we can
  //store the history records when we start the revaluation.
  FCurrenciesChanged := TBits.Create;
  FCurrenciesChanged.Size := CurrencyType;

  // CA 15/02/2013 v7.0.2 ABSEXCH-14003: Initialising CurrencySetupAudit
  CurrencySetupAudit    := NIL;

  //Default size
  ClientWidth := 857;
  if not EuroVers then
    ClientHeight := 488
  else
    ClientHeight := 176;

  //Properties stuff
  FSettings := GetWindowSettings(Self.Name);
  if Assigned(FSettings) then
    FSettings.LoadSettings;

  if Assigned(FSettings) and not FSettings.UseDefaults then
  begin
    FSettings.SettingsToWindow(Self);
    FSettings.SettingsToParent(mlCurrencies);
  end;

  FormResize(Self);

  //Initialise
  CurrenciesLocked := False;

  //SS:11/05/2017 2017-R2:ABSEXCH-18686:Currncy Export: 'Export Button' , the default path should be the company folder where the logged in company is installed.
  SaveDialog1.InitialDir := SetDrive;
   //PL 19-05-2017: ABSEXCH-18561 the default path should be the company folder where the logged in company
  OpenDialog1.InitialDir := SetDrive;
end;

procedure TfrmCurrencyList.FormResize(Sender: TObject);
begin
  mlCurrencies.Height := ClientHeight - 16;
  mlCurrencies.Width := ClientWidth - 104;
end;

procedure TfrmCurrencyList.Properties1Click(Sender: TObject);
begin
  if Assigned(FSettings) then
    FSettings.Edit(mlCurrencies, mlCurrencies);
end;

procedure TfrmCurrencyList.ShowDetails(DetailsMode: TDetailsMode);
var
  DetailsF : TfrmCurrencyDetails;
  Idx : Integer;
  i : integer;
  OkToShow : Boolean;
  LockOK   : Boolean;
  TmpLock  : Boolean;
  TmpLockG : Boolean;

  ThisCurr : Integer;
  HighCurr : Integer;

  CurrencyRemovedFromList : Boolean;

  //Returns the first unused currency number
  function GetNextCurrencyNo : Integer;
  begin
    Result := 2;
    while (Result <= TotalCurrencies ) and CurrencyUsed(Result) do
      inc(Result);
  end;

begin
  CurrencyRemovedFromList := False;

  Idx := mlCurrencies.Selected;
  if (DetailsMode = dmAdd) or (Idx > 0) then
  begin
    DetailsF := TfrmCurrencyDetails.Create(Application);
    Try
      if DetailsMode = dmAdd then
      begin
        //Add - Don't populate any fields except the curr no.
        DetailsF.ceCurrNo.Value := GetNextCurrencyNo;
        DetailsF.Caption := 'Add Currency';
      end
      else
      begin
        //Set caption
        if DetailsMode = dmEdit then
          DetailsF.Caption := 'Edit Currency - ' + mlCurrencies.DesignColumns[1].Items[Idx]
        else
          DetailsF.Caption := 'View Currency - ' + mlCurrencies.DesignColumns[1].Items[Idx];

        //Populate fields
        DetailsF.ceCurrNo.Value := StrToInt(mlCurrencies.DesignColumns[0].Items[Idx]);
        DetailsF.edtDesc.Text := mlCurrencies.DesignColumns[1].Items[Idx];
        DetailsF.edtScreen.Text := mlCurrencies.DesignColumns[2].Items[Idx];
        DetailsF.edtPrinter.Text := mlCurrencies.DesignColumns[3].Items[Idx];
        DetailsF.ceDailyRate.Value := StrToFloat(mlCurrencies.DesignColumns[4].Items[Idx]);
        DetailsF.ceCoRate.Value := StrToFloat(mlCurrencies.DesignColumns[5].Items[Idx]);
        DetailsF.chkInvert.Checked := mlCurrencies.DesignColumns[6].Items[Idx] = 'Yes';
        DetailsF.chkFloat.Checked := mlCurrencies.DesignColumns[7].Items[Idx] = 'Yes';
        DetailsF.ceTriang.Value := StrToInt(mlCurrencies.DesignColumns[8].Items[Idx]);
        DetailsF.ceGhostRate.Value := StrToFloat(mlCurrencies.DesignColumns[9].Items[Idx]);
      end;

      if DetailsMode <> dmAdd then
      begin //Set up multilist on details form
        DetailsF.dsHistory.Filename := SetDrive + 'CurrencyHistory.dat';
        DetailsF.dsHistory.SearchKey := Char(Trunc(DetailsF.ceCurrNo.Value)) + #0;
        DetailsF.mlHistory.Active := True;
      end;

      //If we're adding check that we haven't exceeded currency limit - Add button should have been disabled already
      //so it shouldn't happen, but extra check can't hurt.
      if (DetailsMode <> dmAdd) or (DetailsF.ceCurrNo.Value <= TotalCurrencies) then
      begin

        DetailsF.IsRevalue := FIsRevalue;
        DetailsF.DetailsMode := DetailsMode;
        DetailsF.ShowModal;

        //OK pressed - store details and add currency history record
        if (DetailsF.ModalResult = mrOK) and (Trim(DetailsF.edtDesc.Text) <> '') then
        begin
           ThisCurr := Trunc(DetailsF.ceCurrNo.Value);
           if DetailsMode = dmAdd then
           begin
             //Check whether we can just append this currency to the list.
             HighCurr := StrToInt(mlCurrencies.DesignColumns[0].Items[mlCurrencies.ItemsCount - 1]);

             if ThisCurr < HighCurr then
             begin //This new currency shouldn't be at the end of the list.
               for i := 0 to 9 do
                 mlCurrencies.DesignColumns[i].Items.Insert(ThisCurr, '');
               Idx := ThisCurr;
             end
             else
             begin
               //Ok to add to end of list. //Add a new row to the list and increment idx to point at it
               for i := 0 to 9 do
                 mlCurrencies.DesignColumns[i].Items.Add('');
               Idx := mlCurrencies.ItemsCount - 1;
             end;
           end
           else
           begin
             //PR: 31/07/2012 ABSEXCH-13236 Logic was wrong - was removing edited currencies from list (not deleting them)
             if (Trim(DetailsF.edtDesc.Text) = '') then //remove from list
             begin
               for i := 0 to 9 do
                 mlCurrencies.DesignColumns[i].Items.Delete(ThisCurr);
               CurrencyRemovedFromList := True;
             end;
           end;

           //Populate row
           if not CurrencyRemovedFromList then
           begin
             mlCurrencies.DesignColumns[0].Items[Idx] := IntToStr(Trunc(DetailsF.ceCurrNo.Value));
             mlCurrencies.DesignColumns[1].Items[Idx] := DetailsF.edtDesc.Text;
             mlCurrencies.DesignColumns[2].Items[Idx] := DetailsF.edtScreen.Text;
             mlCurrencies.DesignColumns[3].Items[Idx] := DetailsF.edtPrinter.Text;
             mlCurrencies.DesignColumns[4].Items[Idx] := Format('%8.6f', [DetailsF.ceDailyRate.Value]);
             mlCurrencies.DesignColumns[5].Items[Idx] := Format('%8.6f', [DetailsF.ceCoRate.Value]);
             mlCurrencies.DesignColumns[6].Items[Idx] := IIF(DetailsF.chkInvert.Checked, 'Yes', '');
             mlCurrencies.DesignColumns[7].Items[Idx] := IIF(DetailsF.chkFloat.Checked, 'Yes', '');
             mlCurrencies.DesignColumns[8].Items[Idx] := IntToStr(Trunc(DetailsF.ceTriang.Value));
             mlCurrencies.DesignColumns[9].Items[Idx] := Format('%8.6f', [DetailsF.ceGhostRate.Value]);

             //PR: 31/01/2013 ABSEXCH-13967 If we're updating Currency 1 then we need to update Currency 0 (Consolidated) as well
             //Start loop at 2 so we don't update currency no or description
             if Idx = 1 then
               for i := 2 to 9 do
                 mlCurrencies.DesignColumns[i].Items[0] := mlCurrencies.DesignColumns[i].Items[1];
           end;

           //Update list straight away to avoid delays in GUI
           mlCurrencies.Refresh;
           Application.ProcessMessages;

           //Store currency and add currency history rec

           StoreCurrency(DetailsF);

           //PR: 16/08/2012 ABSEXCH-13278 If we're doing a revaluation then just record that this
           //currency has changed, otherwise add the history record now.
           if not FIsRevalue then
             AddCurrencyHistory(ThisCurr)
           else
             FCurrenciesChanged[ThisCurr] := True;

           //if we've reached the maximum, disable Add button
           SetAddButton;

        end;
      end
      else
      begin //All currencies have been used
        msgBox('The maximum number of currencies has been reached', mtInformation, [mbOk], mbOK, 'Add currency');
      end;
    Finally
      DetailsF.Free;
    End;
  end;
end;

procedure TfrmCurrencyList.btnViewClick(Sender: TObject);
begin
  ShowDetails(dmView);
end;

procedure TfrmCurrencyList.btnAddClick(Sender: TObject);
begin
  ShowDetails(dmAdd);
end;

procedure TfrmCurrencyList.btnEditClick(Sender: TObject);
begin
  ShowDetails(dmEdit);
end;

procedure TfrmCurrencyList.StoreCurrency(const DetailsForm : TfrmCurrencyDetails);
var
  Idx : Integer;

  //PR: 31/01/2013 ABSEXCH-13967 Separate populating record into procecure
  procedure PopulateRecord(const Index : Integer);
  begin
    //Put data back into currency array - don't update description
    if Index <> 0 then
      SyssCurr.Currencies[Index].Desc := DetailsForm.edtDesc.Text;
    SyssCurr.Currencies[Index].SSymb := DetailsForm.edtScreen.Text;
    SyssCurr.Currencies[Index].PSymb := DetailsForm.edtPrinter.Text;
    SyssCurr.Currencies[Index].CRates[True]  := DetailsForm.ceDailyRate.Value;
    SyssCurr.Currencies[Index].CRates[False] := DetailsForm.ceCoRate.Value;

    SyssGCur^.GhostRates.TriInvert[Index] := DetailsForm.chkInvert.Checked;
    SyssGCur^.GhostRates.TriFloat[Index] := DetailsForm.chkFloat.Checked;
    SyssGCur^.GhostRates.TriEuro[Index] := Trunc(DetailsForm.ceTriang.Value);
    SyssGCur^.GhostRates.TriRates[Index] := DetailsForm.ceGhostRate.Value;
  end;

begin
  Idx := Trunc(DetailsForm.ceCurrNo.Value);

  PopulateRecord(Idx);

  //PR: 31/01/2013 ABSEXCH-13967 If we're storing Currency 1 then we need to write it to Currency 0 as well
  if Idx = 1 then
    PopulateRecord(0);

  //PR: 16/08/2012 ABSEXCH-13278 If revaluing, don't store until form closes so we can revert if user cancels.
  if not FIsRevalue then
  begin
     // CJS 18/02/2013 v7.0.2 ABSEXCH-14003: Setting up the After CurrencySetupAudit.
     // If not revaluing, update the audit trail immediately (when revaluing,
     // the audit trail is only written when the audit is actually run, as it
     // is possible to cancel the audit, reverting all the currency changes).
    if Assigned(CurrencySetupAudit) Then
    Begin
      CurrencySetupAudit.AfterData := SyssCurr;
      CurrencySetupAudit.WriteAuditEntry;
      // Re-read the 'before' data so that it is up-to-date if the user edits
      // another currency, or re-edits this currency.
      CurrencySetupAudit.BeforeData := SyssCurr;
    End;

    PutMultiSysCur(False);
    PutMultiSysGCur(False);


    BTSupU2.Init_STDCurrList;
  end;
end;

procedure TfrmCurrencyList.UnlockCurrencies;
var
  CurrSort : SysRecTypes;
begin
  for CurrSort := CurR to Cur3 do
    UnlockMultiSing(F[SysF],SysF,SysAddr[CurrSort]);

  for CurrSort := GCUR to GCU3 do
    UnlockMultiSing(F[SysF],SysF,SysAddr[CurrSort]);

end;

//Adds the currency history rec for a new or edited currency
procedure TfrmCurrencyList.AddCurrencyHistory(Index : Integer);
var
  CurrencyHistoryObj : TCurrencyHistory;
  Res : Integer;
begin
  CurrencyHistoryObj := TCurrencyHistory.Create;
  Try
    CurrencyHistoryObj.SetDataRec(SyssCurr.Currencies, SyssGCur^.GhostRates, Index);
    Res := CurrencyHistoryObj.Save;
  Finally
    CurrencyHistoryObj.Free;
  End;
end;

//Function mostly copied from existing currency form - check that we can revalue.
function TfrmCurrencyList.OKToRevalue: Boolean;
var
  mbRet : Integer;
begin

  mbRet:=MessageDlg('Please confirm you wish to revalue the General Ledger.',mtConfirmation,[mbYes,mbNo],0);


  If (mbRet=mrYes) then {Check for any issues before going in}
  Begin
    If (Not CheckCanRevalue) then
      mbRet:=mrNo;

  end;

  If (mbRet=mrYes) then //Ensure that all other users are logged out
  begin
    mbRet := CustomDlg(Application.MainForm, 'Currency Revaluation','IMPORTANT',
                   'It is essential that you do not run a Currency '#13 +
                   'Revaluation with any other users logged in to Exchequer.'#13#13 +
                   'Have all other users logged out of Exchequer?',
                   mtConfirmation,
                   [mbYes, mbNo]);
  end;


  Result := mbRet = mrOK; //CustomDlg Yes button returns mrOK.
end;

//Copied from existing currency form
function TfrmCurrencyList.CheckCanRevalue: Boolean;
Var
  HasUnPd,
  HasCur1 :  Boolean;

  FutYr   :  Byte;
  FutORef :  Str20;



Begin
  HasUnPd:=BOff; HasCur1:=BOff; FutYr:=0; FutORef:='';


  Result:=CheckValidNCC(CommitAct);

  If (Not Result) then
  Begin
    AddErrorLog('Revaluation. One or more of the General Ledger Control Codes is not valid, or missing.','',4);

    CustomDlg(Application.MainForm,'WARNING!','Invalid G/L Control Codes',
                   'One or more of the General Ledger Control Codes is not valid, or missing.'+#13+
                   'Revaluation cannot continue until this problem has been rectified.'+#13+#13+
                   'Correct the Control Codes via Utilities/System Setup/Control Codes, then try again.',
                   mtError,
                   [mbOk]);


  end
  else
  Begin
    Result:=Not HasUnpAlloc(HasUnPd,HasCur1,FutORef);

    If (Not Result) then
    Begin
      AddErrorLog('Revaluation. One or more of the unposted transactions is allocated, or unposted NOM''s detected.','',4);

      If (FutORef[1]<>DocCodes[NMT][1]) then
        CustomDlg(Application.MainForm,'WARNING!','Allocated Transactions Detected',
                       'One or more of the unposted transactions is allocated. ('+FutORef+')'+#13+
                       'Revaluation cannot continue until this problem has been rectified.'+#13+#13+
                       'All unposted tranasactions must be unallocated during a revaluation.',
                       mtError,
                       [mbOk])
      else
        CustomDlg(Application.MainForm,'WARNING!','Unposted NOM Transactions Detected',
                       'One or more unposted foreign currency NOM transactions have been found. ('+FutORef+')'+#13+
                       'Revaluation cannot continue until this problem has been rectified.'+#13+#13+
                       'All NOM''s must be posted before a revaluation.',
                       mtError,
                       [mbOk]);


    end
    else
    Begin
      {$B-}

      Result:=(UseCoDayRate) or Not HasFutureTrans(FutYr,FutOref);
      {$B+}

      If (Not Result) then
      Begin
        AddErrorLog('Revaluation. Transactions exist after the current period in '+IntToStr(ConvTxYrVal(FutYr,BOff))+'. ('+FutORef+')'+#13+
                    'Set the current period to '+IntToStr(ConvTxYrVal(FutYr,BOff)),'',4);

        CustomDlg(Application.MainForm,'WARNING!','Future Period Transactions Detected',
                       'Transactions exist after the current period in '+IntToStr(ConvTxYrVal(FutYr,BOff))+'. ('+FutORef+')'+#13+
                       'Set the current period to '+IntToStr(ConvTxYrVal(FutYr,BOff))+'.'+#13+
                       'Revaluation cannot continue until this problem has been rectified.'+#13+#13+
                       'All posted tranasactions must be revalued.',
                       mtError,
                       [mbOk]);


      end
    end;
  end;
end;

constructor TfrmCurrencyList.CreateWithMode(AOwner : TComponent; AMode : TCurrencyListMode);
begin
  FIsRevalue := AMode = clmRevalue;
  inherited Create(AOwner);
end;

procedure TfrmCurrencyList.mlCurrenciesRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnViewClick(btnView);
end;

procedure TfrmCurrencyList.SetAddButton;
begin
  //if we've reached maximum currencies then disble add button.
  if mlCurrencies.ItemsCount > TotalCurrencies then
  begin
    btnAdd.Enabled := False;
    Add1.Enabled := False;
    if EuroVers then
    begin
      btnAdd.Visible := False;
      Add1.Visible := False;
    end;
  end;

end;

function TfrmCurrencyList.CurrencyUsed(Index: Integer): Boolean;
begin
  //EL only validates a currency if description and Screen Symbol are both non-blank, therefore take
  //that as criterion of a currency being used.
  //PR: 31/10/2012 ABSEXCH-13625 Limit used to being description non-blank
  Result := (Trim(SyssCurr.Currencies[Index].Desc) <> '');// and (Trim(SyssCurr.Currencies[Index].SSymb) <> '');
end;

procedure TfrmCurrencyList.btnExportClick(Sender: TObject);
var
  ListPoint : TPoint;
begin
  ListPoint.X:=1;
  ListPoint.Y:=1;

  ListPoint:=btnExport.ClientToScreen(ListPoint);

  mnuExport.Popup(ListPoint.X, ListPoint.Y);
end;

procedure TfrmCurrencyList.OrderbyDate1Click(Sender: TObject);
begin
  ExportHistory(eoByDate);
end;                                                                                                                     
procedure TfrmCurrencyList.OrderbyCurrency1Click(Sender: TObject);
begin
  ExportHistory(eoByCurrencyNo);
end;

procedure TfrmCurrencyList.ExportHistory(OrderBy: TExportOrder);
begin

  if SaveDialog1.Execute then
  begin
    //VA:21/02/2018:2018-R1:ABSEXCH-19792: Export History: I/O error 32 message to be changed and Application crashes when closing the error pop up
    if not IsFileInUse(SaveDialog1.FileName) then
    begin
      with TCurrencyHistory.Create do
      Try
        Index := Ord(OrderBy);
        ExportCurrencyHistory(SaveDialog1.Filename);
      Finally
        Free;
      End;
    end
    else
      MessageDlg('Could not save '+ SaveDialog1.FileName +' because the file is already in use', mtError, [mbOK], 0);
  end;

end;

procedure TfrmCurrencyList.mlCurrenciesChangeSelection(Sender: TObject);
begin
  if FIsRevalue then
    btnEdit.Enabled := mlCurrencies.Selected > 1
  else
    btnEdit.Enabled := mlCurrencies.Selected > 0;

  //PR: 16/08/2012 ABSEXCH-13279
  btnView.Enabled := btnEdit.Enabled;

  //PR: 31/10/2012 ABSEXCH-13627
  SetMenuItems;
end;

procedure TfrmCurrencyList.FormDestroy(Sender: TObject);
begin
  if FIsRevalue then
  begin
    FCurrenciesChanged.Free;
    //PR: 24/05/2017 ABSEXCH-18683 v2017 R1 Release process lock
    if ModalResult <> mrOK then
      SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plRevaluation), 0);
  end
  else
    //PR: 24/05/2017 ABSEXCH-18683 v2017 R1 Release process lock
    SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plCurrency), 0);

end;
//PR: 16/08/2012 ABSEXCH-13278 Function to add history records when we start a revaluation
procedure TfrmCurrencyList.AddHistoryRecsForRevaluedCurrencies;
var
  i : integer;
begin
  for i := 2 to FCurrenciesChanged.Size - 1 do
    if FCurrenciesChanged[i] then
      AddCurrencyHistory(i);
end;

procedure TfrmCurrencyList.SetMenuItems;
begin
  Add1.Enabled := btnAdd.Enabled;
  Edit1.Enabled := btnEdit.Enabled;
  View1.Enabled := btnView.Enabled;
  ExportHistory1.Enabled := btnExport.Enabled;
end;

procedure TfrmCurrencyList.mlCurrenciesResize(Sender: TObject);
var
  StartPos : integer;
begin
//PR: 07/11/2012 ABSEXCH-13664 With change in which form is created, button anchors no longer work properly, so set the horizontal
//positions manually.
  if not (csLoading in ComponentState) then
  begin
    StartPos := mlCurrencies.Left + mlCurrencies.Width + 10;
    btnClose.Left := StartPos;
    btnCancel.Left := StartPos;
    btnAdd.Left := StartPos;
    btnEdit.Left := StartPos;
    btnView.Left := StartPos;
    btnExport.Left := StartPos;

    //SS:27/05/2017 2017-R2:ABSEXCH-18592:UI - Add Export Rates and Import Rate button.
    btnExportRates.Left := StartPos;
    btnImportRates.Left := StartPos;
    bvlSeparator.Left := StartPos; 
  end;
end;


//PR: 15/11/2012 ABSEXCH-13730 Need to override CreateParams to set the FormStyle correctly before the window is created.
procedure TfrmCurrencyList.CreateParams(var Params: TCreateParams);
begin
  if FIsRevalue then
  begin
    FormStyle := fsNormal;
    Visible := False;
  end
  else
  begin
    FormStyle := fsMDIChild;
    Visible := True;
  end;
  inherited CreateParams(Params);
end;

//SS:27/04/2017 2017-R2:ABSEXCH-18493:Export Currency Rates in CSV from Currency Table in Exchequer
// Export currency list into .csv file
procedure TfrmCurrencyList.ExportToCsv(aFilename : string);
var
  lCurrList: TStringList;
  CurrNo: Integer;


  // Add currency into String.
  Function  AddCurrencyToList(Index: Integer): String ;
  var
    lStr: String;
  begin
    lStr := '';

    //Load index values for 'No' column
    lStr := IntToStr(Index);

    {PL 12/05/2017 2017-R2: ABSEXCH-18493:encapsulated the description within
    double-quotes so user won't face any error or exception if description
    contains the ','}
    lStr := lStr + ','+ '"'+TxLatePound(SyssCurr.Currencies[Index].Desc,true)+'"';
    lStr := lStr + ','+Format('%8.6f', [SyssCurr.Currencies[Index].CRates[True]]);
    lStr := lStr + ','+Format('%8.6f', [SyssCurr.Currencies[Index].CRates[False]]);

    Result := lStr;
  end;


begin
  //SS:11/05/2017 2017-R2:ABSEXCH-18678:Exception to be handled when Export rate button clicked when file allready in use.
  if not IsFileInUse(aFilename) then
  begin
    lCurrList := TStringList.Create;
    try
      //Add header's details
      lCurrList.Add('No, Description,Daily Rate, Company Rate');

      // Add currency in the Tstringlist object.
      for CurrNo := 2 to TotalCurrencies do
      begin
        if CurrencyUsed(CurrNo) then
          lCurrList.Add(AddCurrencyToList(CurrNo));
      end;

      lCurrList.SaveToFile(aFilename);
      OpenDialog1.Filename := aFilename;

    finally
      lCurrList.Free;
    end;
  end else
  begin
    MessageDlg('Could not save '+ aFilename+' because the file is already in use', mtError, [mbOK], 0);
  end;

end;

//SS:27/04/2017 2017-R2:ABSEXCH-18493:Export Currency Rates in CSV from Currency Table in Exchequer
procedure TfrmCurrencyList.btnExportRatesClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    ExportToCsv(SaveDialog1.Filename);
end;

procedure TfrmCurrencyList.btnImportRatesClick(Sender: TObject);
var
  frmCurrUpdateConfirm: TfrmCurrUpdateConfirm;
  lCurrListExisting : TStringList;
  lCurrListNew,lList : TStringList;
  lTmpList,
  lTempList,
  lErrorList : TStringList; 
  CurrNo: Integer;
  lFileName,
  lCurrencyRec,
  lString : string;
  lModalResult : TModalResult;
  lResult : Boolean;
  lActiveIndex : Integer;

  //AP-21-06-2017 2017-R2:ABSEXCH-18757:Error Message for Invalid File Format
  function ValidateImport(aStringList: TStringList) : Boolean;
  const
    BlankMsg : string = 'The following rows are blank in the ''CSV Currency import file'', rows ';
    InvalidFormatMsg : string = 'Invalid File Format.'+#13#13+'Please refer to the Help File for further details.';
  var
    i, j, lCurrNo,
    lBlnkPos, lPreStr : Integer;
    lBlnkFound1, lBlnkFound2 : Integer;
    lBlank,
    lNewCurr : string;
    lTmpLst1,UsedCurrList : TStringList;
    lDup, lFound,
    lZeroExist, lOneExist  : Boolean;
    lActiveCurr : Integer;
    lNo : Integer;
    lFloat : Double;
  begin
    i := 0;
    lNo := 0;
    lFloat := 0;
    lBlank := '';
    lNewCurr := '';
    lBlnkPos := 0;
    lBlnkFound1 := 0;
    lBlnkFound2 := 0;
    lDup := False;
    lFound := False;
    lZeroExist := False;
    lOneExist := False;
    lTmpLst1 := TStringList.Create;
    UsedCurrList := TStringList.Create;

    try

      lBlnkPos := Pos(',,',aStringList[0]);

      if (lBlnkPos > 0) then
      begin
        lResult := False;
        //AP-23-06-2017 2017-R2:ABSEXCH-18822:Invalid File format. Please refer Help File for the format
        MessageDlg(InvalidFormatMsg,mtError,[mbOK,mbHelp],40200);
        Exit;
      end
      else
      begin
        if strscan(PChar(Trim(aStringList[0])), '''') <> nil then
        begin
          //If file is not edited it'll have double quotes encapsulation in desc field
          //to handle that we've used delimitedtex coz ExtractStrings gives wrong desc.
          lTempList.DelimitedText:= Trim(aStringList[0]);
        end
        else
        begin
          ExtractStrings([','], [#0], PChar(Trim(aStringList[0])), lTempList);
        end;

        if (lTempList.Count = 4) and (UpperCase(Trim(lTempList[0])) = 'NO') and (UpperCase(Trim(lTempList[1]))='DESCRIPTION') and
             (UpperCase(Trim(lTempList[2]))='DAILY RATE') and (UpperCase(Trim(lTempList[3]))='COMPANY RATE') then
          lResult := True
        else
        begin
          lResult := False;
          //AP-23-06-2017 2017-R2:ABSEXCH-18822:Invalid File format. Please refer Help File for the format
          MessageDlg(InvalidFormatMsg,mtError,[mbOK,mbHelp],40200);
          Exit;
        end;
      end;

      lTempList.Clear;
      
      if lResult then
      begin
        UsedCurrList.Clear;
        for lCurrNo := 0 to TotalCurrencies do
        begin
		      //SS:06/04/2018:2018-R1:ABSEXCH-20350:Currency Import returning error.
          if CurrencyUsed(lCurrNo) then
          begin
            if not (lCurrNo in [0,1]) then
              UsedCurrList.Add(IntToStr(lCurrNo));
          end;
        end;

        i := 0;
        
        while (i < aStringList.Count-1) do
        begin
          Inc(i);

          lTempList.Clear;

          if strscan(PChar(Trim(aStringList[i])), '"') <> nil then
          begin
            //If file is not edited it'll have double quotes encapsulation in desc field
            //to handle that we've used delimitedtex coz ExtractStrings gives wrong desc.
            lTempList.DelimitedText:= Trim(aStringList[i]);
          end
          else
          begin
            ExtractStrings([','], [], PChar(Trim(aStringList[i])), lTempList);
          end;  

          if (lTempList.Text <> '') then
          begin
            //SS:06/04/2018:2018-R1:ABSEXCH-20350:Currency Import returning error.
            if UsedCurrList.IndexOf(lTempList[0]) <> -1 then
              UsedCurrList.Delete(UsedCurrList.IndexOf(lTempList[0]));
          end;
        end;

        if UsedCurrList.Count > 0 then
        begin
          lResult := False;
          for i := 0 to UsedCurrList.Count-1  do
          begin
            if (lNewCurr = '') then
              lNewCurr := UsedCurrList[i]
            else
              lNewCurr := lNewCurr + ', ' + UsedCurrList[i];
          end;
          lErrorList.Add('New Currency '+lNewCurr+' found in Currency Setup, please export the file.');
          Exit;
        end;

        i := 0;
        while (i < aStringList.Count-1) do
        begin
          Inc(i);
          lTempList.Clear;
          lDup := False;

          if strscan(PChar(Trim(aStringList[i])), '"') <> nil then
          begin
            //If file is not edited it'll have double quotes encapsulation in desc field
            //to handle that we've used delimitedtex coz ExtractStrings gives wrong desc.
            lTempList.DelimitedText:= Trim(aStringList[i]);
          end
          else
          begin
            ExtractStrings([','], [], PChar(Trim(aStringList[i])), lTempList);
          end;

          if lTempList.Text <> '' then
          begin
            if not TryStrToInt(lTempList[0],lNo) then
            begin
              lErrorList.Add('Currency No contains invalid value for row '+ IntToStr(i+1)+ #13);
            end;

            if (lTempList.Count = 3) then
            begin
              if  (not TryStrToFloat(lTempList[2],lFloat)) then
              begin
                lErrorList.Add('Currency Daily Rate contains invalid value for row '+ IntToStr(i+1)+ #13);
              end;
            end;

            if (lTempList.Count=4) then
            begin
              if (not TryStrToFloat(lTempList[3],lFloat)) then
              begin
                lErrorList.Add('Currency Company Rate contains invalid value for row '+ IntToStr(i+1)+ #13);
              end;
            end;

            if lErrorList.Count > 0 then
            begin
              lResult := False;
              Exit;
            end;

            if (StrToInt(lTempList[0]) in [0,1]) then
            begin

              if (StrToInt(lTempList[0]) = 0) and (not lZeroExist) then
              begin
                lZeroExist := True;
                lErrorList.Add('Cannot import Currency 0 into Exchequer.'+#13);
              end;

              if (StrToInt(lTempList[0]) = 1) and (not lOneExist) then
              begin
                lOneExist := True;
                lErrorList.Add('Cannot import Currency 1 into Exchequer.'+#13);
              end;

              lResult := False;
              aStringList.Delete(i);
              Dec(i);
            end;

            j := i+1;

            while (j < aStringList.Count) do
            begin
              lTmpLst1.Clear;
              if strscan(PChar(Trim(aStringList[j])), '"') <> nil then
              begin
                //If file is not edited it'll have double quotes encapsulation in desc field
                //to handle that we've used delimitedtex coz ExtractStrings gives wrong desc.
                lTmpLst1.DelimitedText:= Trim(aStringList[j]);
              end
              else
              begin
                ExtractStrings([','], [], PChar(Trim(aStringList[j])), lTmpLst1);
              end;
              
              if (lTmpLst1.text <> '') then
              begin
                if (not(StrToInt(lTempList[0]) in [0,1])) and (lTmpLst1[0] = lTempList[0]) then
                begin
                  if (CurrencyUsed(StrToInt(lTempList[0]))) then
                  begin
                    lResult := False;
                    lDup := True;
                  end;
                  aStringList.Delete(j);
                  Dec(j);
                end;
              end;
              Inc(j);
            end;
            if lDup then
              lErrorList.Add('Details for Currency ' + lTempList[0] + ' are specified more than once in the ''CSV Currency import file''.' + #13);
          end;
        end;

        lPreStr := 1;
        lCurrNo := 1;

        while (lCurrNo < TotalCurrencies-1) do
        begin
          Inc(lCurrNo);
          lBlnkFound2 := 0;

          if (aStringList.Count >= lCurrNo) then
          begin

            lTempList.Clear;

            if strscan(PChar(trim(aStringList[lCurrNo-1])), '"') <> nil then
            begin
              //If file is not edited it'll have double quotes encapsulation in desc field
              //to handle that we've used delimitedtex coz ExtractStrings gives wrong desc.
              lTempList.DelimitedText:= trim(aStringList[lCurrNo-1]);
            end
            else
            begin
              ExtractStrings([','], [], PChar(trim(aStringList[lCurrNo-1])), lTempList);
            end;

            if (lTempList.Text = '') then
              Inc(lBlnkFound1);

            for i := 1 to lCurrListExisting.Count-1 do
            begin
              lFound := False;
              lTmpLst1.Clear;
              if strscan(PChar(trim(lCurrListExisting[i])), '"') <> nil then
              begin
                //If file is not edited it'll have double quotes encapsulation in desc field
                //to handle that we've used delimitedtex coz ExtractStrings gives wrong desc.
                lTmpLst1.DelimitedText:= trim(lCurrListExisting[i]);
              end
              else
              begin
                ExtractStrings([','], [], PChar(trim(lCurrListExisting[i])), lTmpLst1);
              end;

              if (lTmpLst1.Text = '') and (lBlnkFound2 < lBlnkFound1) then
              Inc(lBlnkFound2);

              if (Trim(lTempList.Text) = '') and (lBlnkFound1 = lBlnkFound2) then
              begin
                lResult := False;

                if (lBlank = '') then
                begin
                  lBlank := IntToStr(i+1);
                end
                else
                  lBlank := lBlank +', '+ IntToStr(i+1);

                aStringList.Delete(lCurrNo-1);
                Dec(lCurrNo);
                lFound := True;
              end;

              if (Trim(lTempList.Text) = Trim(lTmpLst1.Text)) then
              begin

                if (lTempList.Count = 4) then
                begin
                  if (CurrencyUsed(StrToInt(lTempList[0]))) then
                  begin
				  	//SS:06/04/2018:2018-R1:ABSEXCH-20350:Currency Import returning error.
                    lActiveCurr := StrToInt(lTempList[0]);
                    {if ((StrToInt(lTempList[0]) <> lPreStr+1) and (StrToInt(lTempList[0]) <> lCurrNo) ) or
                      ((StrToInt(lTempList[0]) <> lCurrNo) and (lTempList[1] = SyssCurr.Currencies[lCurrNo].Desc)) or
                      ((StrToInt(lTempList[0]) = lCurrNo) and (lTempList[1] <> SyssCurr.Currencies[StrToInt(lTempList[0])].Desc)) then}

                    if (Trim(lTempList[1]) <> Trim(SyssCurr.Currencies[lActiveCurr].Desc)) then
                    begin
                      lResult := False;
                      lErrorList.Add('Currency details from Currency Setup do not match the existing details for row '+ IntToStr(i+1) +'.'+#13);
                    end;

                    lPreStr := StrToInt(lTempList[0]);
                  end
                  else
                  begin
                    lResult := False;
                    lErrorList.Add('New Currency '+lTempList[0]+', '+lTempList[1]+' on row '+ IntToStr(i+1) +' cannot be added from ''CSV Currency import file'', please add from Currency Setup.'+#13);
                  end;

                  if (trim(lTempList[2])<>'') then
                  begin
                    if (StrToFloat(lTempList[2]) = 0) then
                    begin
                      lResult := False;
                      lErrorList.Add('Daily Rate cannot be 0 on row '+ IntToStr(i+1) +' for Currency '+ lTempList[0]+', '+lTempList[1]+'.'+#13);
                    end
                    else
                    if (StrToFloat(lTempList[2]) < 0) then
                    begin
                      lResult := False;
                      lErrorList.Add('Daily Rate cannot be negative on row '+ IntToStr(i+1) +' for Currency '+ lTempList[0]+', '+lTempList[1]+'.'+#13);
                    end;
                  end;
                  if (trim(lTempList[3])<>'') then
                  begin
                    if (StrToFloat(lTempList[3]) = 0) then
                    begin
                      lResult := False;
                      lErrorList.Add('Company Rate cannot be 0 on row '+ IntToStr(i+1) +' for Currency '+ lTempList[0]+', '+lTempList[1]+'.'+#13);
                    end
                    else
                    if (StrToFloat(lTempList[3]) < 0) then
                    begin
                      lResult := False;
                      lErrorList.Add('Company Rate cannot be negative on row '+ IntToStr(i+1) +' for Currency '+ lTempList[0]+', '+lTempList[1]+'.'+#13);
                    end;
                  end;
                  lFound := True;
                end
                else
                begin
                  if (lTempList.Text <> '') then
                  begin
                    lResult := False;
                    lErrorList.Add('Currency Details from Currency Setup do not match existing details for row '+ IntToStr(i+1) +'.'+#13);
                    lPreStr := StrToInt(lTempList[0]);
                  end;
                end;
              end;
              if lFound then
                Break;
            end;
          end
          else
            exit;
        end;
      end;

    finally
      if (lBlank <> '') then
        lErrorList.Add(BlankMsg + lBlank + '.'+#13);
      Result := lResult;
      lTmpLst1.Free;
      UsedCurrList.Free;
    end;
  end;

  //combine old and new rate of currency into String.
  Function  AddCurrencyToList(Index: Integer; aString: String): String ;
  var
    lStr: String;
    lStringList: TStringList;
  begin
    lStringList:= TStringList.Create;
    if strscan(PChar(Trim(aString)), '"') <> nil then
    begin
      //If file is not edited it'll have double quotes encapsulation in desc field
      //to handle that we've used delimitedtex coz ExtractStrings gives wrong desc.
      lStringList.DelimitedText:= Trim(aString);
    end
    else
    begin
      ExtractStrings([','], [], PChar(Trim(aString)), lStringList);
    end;

    lStr := '';

    try
      //based on currency no and description it'll form the string else it'll null
      lStr := IntToStr(Index);

      lStr := lStr + ','+ '"'+TxLatePound(SyssCurr.Currencies[Index].Desc,true)+'"';
      lStr := lStr + ','+TxLatePound(SyssCurr.Currencies[Index].SSymb, True);
      lStr := lStr + ','+TxLatePound(SyssCurr.Currencies[Index].PSymb, True);
      lStr := lStr + ','+Format('%8.6f', [SyssCurr.Currencies[Index].CRates[True]]);
      lStr := lStr + ','+lStringList[2];
      lStr := lStr + ','+Format('%8.6f', [SyssCurr.Currencies[Index].CRates[False]]);
      lStr := lStr + ','+lStringList[3];

      Result := lStr;

    finally
      lStringList.Free;
    end;
  end;

begin
  lCurrListExisting := TStringList.Create;
  lCurrListNew := TStringList.Create;
  lTmpList := TStringList.Create;
  lTempList := TStringList.Create;
  lErrorList := TStringList.Create;
  lList := TStringList.Create;

  lResult := True;

  try
    //Import values from CSV file
    if OpenDialog1.Execute then
    begin
      lFileName:= OpenDialog1.Filename;
      try
        lCurrListExisting.LoadFromFile(lFileName);
      except
        on E : Exception do
        begin
          lResult := False;
          lErrorList.Add('Cannot open file '+lFileName+' as file is already opened.');
        end;
      end;
    end;

    if lResult and (lFileName = EmptyStr) then Exit;

    if lResult and (lCurrListExisting.Count < 2) then
    begin
      lResult := False;
      lErrorList.Add('No Records found, please check ''CSV Currency Import file''.');
    end;

    if lResult then
    begin
      lTmpList.Text := lCurrListExisting.Text;
      lResult := ValidateImport(lTmpList);
    end;

    if lResult then
    begin
      // Add currency in the Tstringlist object.
      lActiveIndex := 0;

      //SS:06/04/2018:2018-R1:ABSEXCH-20350:Currency Import returning error.
      for CurrNo := 1 to lCurrListExisting.Count-1 do
      begin
        lList.Clear;
        if strscan(PChar(Trim(lCurrListExisting[CurrNo])), '"') <> nil then
        begin
            //If file is not edited it'll have double quotes encapsulation in desc field
            //to handle that we've used delimitedtex coz ExtractStrings gives wrong desc.
            lList.DelimitedText:= Trim(lCurrListExisting[CurrNo]);
        end
        else
        begin
          ExtractStrings([','], [], PChar(Trim(lCurrListExisting[CurrNo])), lList);
        end;
        
        lActiveIndex := StrToInt(lList[0]);
        if CurrencyUsed(lActiveIndex) then
        begin
          lString := AddCurrencyToList(lActiveIndex,lCurrListExisting[CurrNo]);
          lCurrListNew.Add(lString);
        end;
      end;            
    end;



    if lErrorList.Count > 0 then
    begin
      MessageDlg(lErrorList.Text, mtError, [mbOK], 0);
      Exit;
    end;

    if (lCurrListNew.Count > 0) then
    begin
      //Passing the updated List to Comparison form
	  //VA 11/05/2018 2018-R1.1 ABSEXCH-20488:Utilities > Currency Setup > Currency Update Confirmation Window Changes	
      frmCurrUpdateConfirm:= TfrmCurrUpdateConfirm.create(self,lCurrListNew,FIsRevalue);
      lModalResult := frmCurrUpdateConfirm.ShowModal;
    end;

  finally
    lCurrListExisting.Free;
    lCurrListNew.Free;
    lTmpList.Free;
    lTempList.Free;
    lErrorList.Free;
    lList.Free;
  end;
end;

//VA:21/02/2018:2018-R1:ABSEXCH-19792: Export History: I/O error 32 message to be changed and Application crashes when closing the error pop up
function TfrmCurrencyList.IsFileInUse(aName: string): boolean;
var
    HFileRes: HFILE;
  begin
    Result := False;
    if not FileExists(aName) then  Exit;

    HFileRes := CreateFile(PChar(aName),GENERIC_READ or GENERIC_WRITE,0 ,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);

    Result := (HFileRes = INVALID_HANDLE_VALUE);

    if not(Result) then
    begin
      CloseHandle(HFileRes);
    end;
  end;

end.

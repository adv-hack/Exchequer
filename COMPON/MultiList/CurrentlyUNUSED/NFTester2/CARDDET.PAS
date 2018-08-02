unit carddet;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, APIUtil,
  StdCtrls, BTSupU1, TEditVal, Mask, ExtCtrls, ComCtrls, StrUtil,NeilProc,
  SBSPanel, BorBtns, ExWrap1U, VarConst, ETStrU, AdPacket, OoMisc, AdPort, Comms
  , MPComms, BTList, SBSComp, GlobVar, ETDateU, CardProc, BTKeys1U, BTrvU2
  ,TXDetail, Menus, DatRange, BillSplt, TCustom;

type
  TLedgerList  =  class(TMULCtrl)
    private
      Incentive, Debits, Credits, Balance : real;
    public
      function SetCheckKey : Str255; override;
      function SetFilter : Str255; override;
      function OutLine(Col : Byte) : Str255; override;
  end;

  TFrmCardDetails = class(TForm)
    pcMain: TPageControl;
    tabDetails: TTabSheet;
    tabLedger: TTabSheet;
    tabNotes: TTabSheet;
    tabLinks: TTabSheet;
    sbDetails: TScrollBox;
    Label2: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    edName: Text8Pt;
    edMemCode: Text8Pt;
    cmbTitle: TSBSComboBox;
    cmbCategory: TSBSComboBox;
    Label6: TLabel;
    lStatusTit: TLabel;
    Label8: TLabel;
    edAddress1: Text8Pt;
    edAddress2: Text8Pt;
    edAddress3: Text8Pt;
    edAddress4: Text8Pt;
    SBSPanel1: TSBSPanel;
    Label9: TLabel;
    edSpent: TCurrencyEdit;
    Label10: TLabel;
    edPaidIn: TCurrencyEdit;
    lBalance: TLabel;
    edBalance: TCurrencyEdit;
    edHomeTel: Text8Pt;
    Label11: TLabel;
    Label12: TLabel;
    edWorkTel: Text8Pt;
    Label13: TLabel;
    edLastUsed: TEditDate;
    sbLedger: TScrollBox;
    panLDescription: TSBSPanel;
    panLDate: TSBSPanel;
    panLTitle: TSBSPanel;
    panLDescTit: TSBSPanel;
    panLDateTit: TSBSPanel;
    panLCreditsTit: TSBSPanel;
    panLDebitsTit: TSBSPanel;
    panLIncentiveTit: TSBSPanel;
    panLCredits: TSBSPanel;
    panLDebits: TSBSPanel;
    panLIncentive: TSBSPanel;
    panLScrollBar: TSBSPanel;
    panLButtons: TSBSPanel;
    sbLButtons: TScrollBox;
    btnShowDetails: TSBSButton;
    btnLClose: TSBSButton;
    panLBalanceTit: TSBSPanel;
    panLBalance: TSBSPanel;
    panDButtons: TSBSPanel;
    btnDOK: TSBSButton;
    sbDButtons: TScrollBox;
    btnDAdd: TSBSButton;
    btnDEdit: TSBSButton;
    btnDCancel: TSBSButton;
    btnDClose: TSBSButton;
    sbNotes: TScrollBox;
    panNDate: TSBSPanel;
    panNTitle: TSBSPanel;
    panNDateTit: TSBSPanel;
    panNUserTit: TSBSPanel;
    panNNotesTit: TSBSPanel;
    panNUser: TSBSPanel;
    panNNotes: TSBSPanel;
    panNScrollBar: TSBSPanel;
    panNButtons: TSBSPanel;
    sbNButtons: TScrollBox;
    SBSButton1: TSBSButton;
    btnNClose: TSBSButton;
    sbLinks: TScrollBox;
    panKType: TSBSPanel;
    panKDate: TSBSPanel;
    panKTitle: TSBSPanel;
    panKTypeTit: TSBSPanel;
    panKDateTit: TSBSPanel;
    panKTimeTit: TSBSPanel;
    panKUserTit: TSBSPanel;
    panKDescTit: TSBSPanel;
    panKTime: TSBSPanel;
    panKUser: TSBSPanel;
    panKDesc: TSBSPanel;
    panKScrollBar: TSBSPanel;
    panKButtons: TSBSPanel;
    sbKButtons: TScrollBox;
    SBSButton4: TSBSButton;
    btnKClose: TSBSButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    lStatus: TLabel;
    btnHold: TSBSButton;
    btnReProgram: TSBSButton;
    pmHold: TPopupMenu;
    Suspend1: TMenuItem;
    OverCreditLimit1: TMenuItem;
    MembershipExpired1: TMenuItem;
    btnCheckCard: TSBSButton;
    lTrackNo: TLabel;
    edTrackNo: TCurrencyEdit;
    btnAdd: TSBSButton;
    btnEdit: TSBSButton;
    btnDelete: TSBSButton;
    edNumber: TCurrencyEdit;
    edInitials: Text8Pt;
    btnLStatement: TSBSButton;
    btnBillSplit: TSBSButton;
    btnDStatement: TSBSButton;
    btnChangeNo: TSBSButton;
    cbCredit: TBorCheck;
    lIssue: TLabel;
    edIssueNo: TCurrencyEdit;
    btnNewIssueNo: TSBSButton;
    btnDeleteLine: TSBSButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnDCloseClick(Sender: TObject);
    procedure btnDCancelClick(Sender: TObject);
    procedure btnDAddClick(Sender: TObject);
    procedure btnDEditClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnDOKClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure panLDescTitMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure panLDescTitMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure panLDescTitMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnShowDetailsClick(Sender: TObject);
    procedure btnHoldClick(Sender: TObject);
    procedure HoldCard(Sender: TObject);
    procedure btnReProgramClick(Sender: TObject);
    procedure btnCheckCardClick(Sender: TObject);
    procedure Label2DblClick(Sender: TObject);
    procedure lTrackNoClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure edNumberExit(Sender: TObject);
    procedure edNameExit(Sender: TObject);
    procedure edInitialsExit(Sender: TObject);
    procedure btnDStatementClick(Sender: TObject);
    procedure btnChangeNoClick(Sender: TObject);
    procedure btnBillSplitClick(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
    procedure edIssueNoExit(Sender: TObject);
    procedure btnNewIssueNoClick(Sender: TObject);
    procedure btnDeleteLineClick(Sender: TObject);
  private
    FormStuff : TFormStuff;
    FormMode : TFormMode;
    FrmTXDetails : TFrmTXDetails;
    bFormClosing : boolean;
    rLastBalance : real;
    procedure WMGetMinMaxInfo(var message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure RefreshLedger;
    procedure WMCustGetRec(var message : TMessage); message WM_CustGetRec;
    function SaveCardDetails : boolean;
    Procedure Form2Cust;
    procedure WMFormCloseMsg(var message : TMessage); message WM_FormCloseMsg;
    procedure Cust2Form;
    procedure WMMPComms(var Message : TMessage); message WM_MPComms;
    procedure SetHoldCaption;
  public
    ExLocal : TdExLocal;
    function SetFormMode(fmSetTo : TFormMode) : boolean;
    procedure UpdateDetails(bAssign : boolean);
  end;

implementation

uses Cardlist, FindDlg, messscrn, MainF;

{$R *.DFM}

{TLedgerList}

function TLedgerList.SetCheckKey : Str255;
begin
  SetCheckKey := Inv.CustCode; {must match the Key that you pass into startlist}
end;

function TLedgerList.SetFilter  :  Str255;
begin
  Result := '';{must set this to '' for no filtering}
end;

function TLedgerList.OutLine(Col : Byte) : Str255;
begin
  Result := '';
  with Inv do begin
    if (Source = isEodTot) then
      begin
        if Col = 0 then Result := 'EOD Totals';            {Description}
      end
    else begin
      if Col = 0 then CalcInvoiceCredits(Inv, Debits, Incentive, Credits, Balance);
      case Col of
        0  : Result := GetTransDesc(Inv, Debits);          {Description}
        1  : Result := POutDate(TransDate);                {Date}
        2  : Result := MoneyToStr(Debits);          {Debits}
        3  : Result := MoneyToStr(Incentive);       {Incentive}
        4  : Result := MoneyToStr(Credits);           {Credits}
        5  : Result := MoneyToStr(Balance);               {Balance}
      end;{case}
    end;{if}
  end;{with}
end;


{TFrmCardDetails}

procedure TFrmCardDetails.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  iMResult : byte;
begin
  if not bFormClosing then begin
    bFormClosing := TRUE;
    if FrmTXDetails <> nil then FrmTXDetails.Close;
    Application.ProcessMessages; {so it doesn't crash hideously !}
{    with FormStuff do begin
      StoreFormProperties(Self, OpMode, bStoreCoord, bSetDefaults, bLastCoord
      , apanTitle, aMULCtrlO, acPrimeKeys);
    end;{with}
    if FormMode <> fmView then begin
      iMResult := MsgBox('You are currently editing a record.' + #13 + #13
      + 'Do you wish to save the changes that you have made to this record ?',mtConfirmation, [mbYes,mbNo],mbYes,'Card Details');
      case iMResult of
        mrYes : btnDOKClick(Self);
        mrNo : btnDCancelClick(Self);
      end;{case}
    end;{if}
    SendMessage(TForm(Owner).Handle,WM_FormCloseMsg,1,0);
    Action := caFree;
  end;{if}
end;

procedure TFrmCardDetails.FormCreate(Sender: TObject);
begin
  btnDelete.Enabled := LoginMode in [lmDebug, lmUser];
  btnDeleteLine.Visible := LoginMode in [lmDebug];

  ednumber.displayformat := '#####0'; {cos this gets reset @ run-time - nice}
  edIssueNo.displayformat := '#0'; {cos this gets reset @ run-time - nice}

  if Syss.UseIssueNumbers then edNumber.MaxLength := 4
  else edNumber.MaxLength := 5;

  lIssue.Visible := Syss.UseIssueNumbers;
  edIssueNo.Visible := Syss.UseIssueNumbers;
  btnNewIssueNo.visible := Syss.UseIssueNumbers;


  bFormClosing := FALSE;
  ExLocal.Create; {create local record instance for independent data manipulation}
  FormStuff := TFormStuff.Create(2);

  {set default size}
  ClientHeight := 370;
  ClientWidth := 611;

  {Setup List Properties}
  with FormStuff do begin
    bFillList := FALSE;
    SetLength(aColumns[0],6);
    SetLength(aColumns[1],6);
    aColumns[1,0].ColPanel := panLDescription;
    aColumns[1,0].HeadPanel := panLDescTit;
    aColumns[1,1].ColPanel := panLDate;
    aColumns[1,1].HeadPanel := panLDateTit;
    aColumns[1,2].ColPanel := panLDebits;
    aColumns[1,2].HeadPanel := panLDebitsTit;
    aColumns[1,2].DecPlaces := 2;
    aColumns[1,3].ColPanel := panLIncentive;
    aColumns[1,3].HeadPanel := panLIncentiveTit;
    aColumns[1,3].DecPlaces := 2;
    aColumns[1,4].ColPanel := panLCredits;
    aColumns[1,4].HeadPanel := panLCreditsTit;
    aColumns[1,4].DecPlaces := 2;
    aColumns[1,5].ColPanel := panLBalance;
    aColumns[1,5].HeadPanel := panLBalanceTit;
    aColumns[1,5].DecPlaces := 2;

{    SetLength(aColumns[2],3);
    aColumns[2,0].ColPanel := panNDate;
    aColumns[2,0].HeadPanel := panNDateTit;
    aColumns[2,1].ColPanel := panNNotes;
    aColumns[2,1].HeadPanel := panNNotesTit;
    aColumns[2,2].ColPanel := panNUser;
    aColumns[2,2].HeadPanel := panNUserTit;

    SetLength(aColumns[3],5);
    aColumns[3,0].ColPanel := panKType;
    aColumns[3,0].HeadPanel := panKTypeTit;
    aColumns[3,1].ColPanel := panKDate;
    aColumns[3,1].HeadPanel := panKDateTit;
    aColumns[3,2].ColPanel := panKDesc;
    aColumns[3,2].HeadPanel := panKDescTit;
    aColumns[3,3].ColPanel := panKUser;
    aColumns[3,3].HeadPanel := panKUserTit;
    aColumns[3,4].ColPanel := panKTime;
    aColumns[3,4].HeadPanel := panKTimeTit;}

    aFileNos[0] := 0;
    aFileNos[1] := InvF;
{    aFileNos[2] := 0;
    aFileNos[3] := 0;}

    asbMain[0] := sbDetails;
    asbMain[1] := sbLedger;
{    asbMain[2] := sbNotes;
    asbMain[3] := sbLinks;}

    acPrimeKeys[0] := ' ';
    acPrimeKeys[1] := 'C';
{    acPrimeKeys[2] := 'E';
    acPrimeKeys[3] := 'G';}

    apanTitle[0] := nil;
    apanTitle[1] := panLTitle;
{    apanTitle[2] := panNTitle;
    apanTitle[3] := panKTitle;}

    asbButtons[0] := sbDButtons;
    asbButtons[1] := sbLButtons;
{    asbButtons[2] := sbNButtons;
    asbButtons[3] := sbKButtons;}

    apanButtons[0] := panDButtons;
    apanButtons[1] := panLButtons;
{    apanButtons[2] := panNButtons;
    apanButtons[3] := panKButtons;}

    aMULCtrlO[0] := nil;
    aMULCtrlO[1] := TLedgerList.Create(Self);{creates control object}
{    aMULCtrlO[2] := nil;
    aMULCtrlO[3] := nil;}

    apanScrollBar[0] := nil;
    apanScrollBar[1] := panLScrollBar;
{    apanScrollBar[2] := panNScrollBar;
    apanScrollBar[3] := panKScrollBar;}

    aCaseSensSearch[0] := TRUE;
    aCaseSensSearch[1] := TRUE;

    aiKeys[0] := 0;
    aiKeys[1] := InvCustK;
{    aiKeys[2] := 0;
    aiKeys[3] := 0;}

    asStartKeys[0] := '';
    asStartKeys[1] := '';
{    asFindKeys[2] := '';
    asFindKeys[3] := '';}

    ReadFormProperties(Self, FormStuff);
    aMULCtrlO[1].ReColorBar(panLScrollBar.Font,$00004000);
{    aMULCtrlO[2].ReColorBar(panLScrollBar.Font,clMaroon);
    aMULCtrlO[3].ReColorBar(panLScrollBar.Font,clNavy);}
    FormResize(Self);
  end;{with}
end;

function TFrmCardDetails.SetFormMode(fmSetTo: TFormMode) : boolean;
var
  iComp : integer;
begin
  edTrackNo.Visible := FALSE;

  Result := TRUE;
  if (not bgCommsWorking) and (fmSetTo <> fmView) then begin
    Result := FALSE;
    fmSetTo := fmView;
  end;{if}

  case fmSetTo of
    fmAdd : if (not CheckABSFree) then fmSetTo := fmView;

    fmEdit : begin
      if LockRecord(CustF, CustCodeK, ExLocal, TRUE) then Cust2Form
      else fmSetTo := fmView;
    end;
  end;{case}

  ExLocal.InAddEdit := fmSetTo <> fmView; {set edit mode of local record}
  FormMode := fmSetTo;

  {enable / disable components dependant on FormMode}
  For iComp := 0 to (ComponentCount - 1) do begin
    if (Components[iComp] is TSBSComboBox) and (TSBSComboBox(Components[iComp]).Tag > 0)
    then TSBSComboBox(Components[iComp]).ReadOnly := Ord(fmSetTo) < 1
    else begin
      if (Components[iComp] is Text8pt) and (Text8pt(Components[iComp]).Tag > 0)
      then Text8pt(Components[iComp]).ReadOnly := Ord(fmSetTo) < 1
      else begin
        if (Components[iComp] is TCurrencyEdit) and (TCurrencyEdit(Components[iComp]).Tag > 0)
        then TCurrencyEdit(Components[iComp]).ReadOnly := Ord(fmSetTo) < 1
        else begin
          if (Components[iComp] is TEditDate) and (TEditDate(Components[iComp]).Tag > 0)
          then TEditDate(Components[iComp]).ReadOnly := Ord(fmSetTo) < 1
          else begin
            if (Components[iComp] is TBorCheck) and (TBorCheck(Components[iComp]).Tag > 0)
            then TBorCheck(Components[iComp]).Enabled := Ord(fmSetTo) > 0
            else begin
              if (Components[iComp] is TTabSheet) and (TTabSheet(Components[iComp]).Name <> 'tabDetails')
              then TTabSheet(Components[iComp]).TabVisible := (fmSetTo = fmView) and (TTabSheet(Components[iComp]).Tag <> -1)
              else begin
                if (Components[iComp] is TSBSButton)
                then TSBSButton(Components[iComp]).Enabled := (Ord(fmSetTo) > 0) and (TSBSButton(Components[iComp]).Tag = 1)
                or (Ord(fmSetTo) = 0) and (TSBSButton(Components[iComp]).Tag = 0);
              end;{if}
            end;{if}
          end;{if}
        end;{if}
      end;{if}
    end;{if}
  end;{for}
  edNumber.ReadOnly := fmSetTo <> fmAdd;
  edIssueNo.ReadOnly := fmSetTo <> fmAdd;

  {set active control dependant on FormMode}
  case fmSetTo of
    fmView : begin
      case pcMain.ActivePage.PageIndex of
        0 : ActiveControl := btnDClose;
        1 : ActiveControl := btnLClose;
        2 : ActiveControl := btnNClose;
        3 : ActiveControl := btnKClose;
      end;{case}
    end;

    fmEdit : ActiveControl := edMemCode;

    fmAdd  : begin
      ActiveControl := edNumber;
      For iComp := 0 to (ComponentCount - 1) do begin
        if ((Components[iComp] is TSBSComboBox)
        or (Components[iComp] is Text8pt)
        or (Components[iComp] is TCurrencyEdit)
        or (Components[iComp] is TEditDate))
        then TEdit(Components[iComp]).Text := '';
      end;{for}
      lStatusTit.Font.Color := clBlack;
      lStatus.Font.Color := clBlack;
      lStatus.Caption := '';
      cbCredit.Checked := Syss.DefCredit; {sets default unlimited credit}
      cmbTitle.Text := 'Mr.';
    end;
  end;{case}

  if btnDelete.Enabled then btnDelete.Enabled := ((LoginMode = lmUser) and bgCommsWorking) or (LoginMode = lmDebug);
  if btnDAdd.Enabled then btnDAdd.Enabled := bgCommsWorking and (not Syss.Club2000);
  if btnDEdit.Enabled then btnDEdit.Enabled := bgCommsWorking;
  if btnChangeNo.Enabled then btnChangeNo.Enabled := bgCommsWorking and (not Syss.Club2000);
  if btnHold.Enabled then btnHold.Enabled := bgCommsWorking;
  if btnHold.Enabled then btnHold.Enabled := bgCommsWorking;
  if btnReProgram.Enabled then btnReProgram.Enabled := bgCommsWorking;
  if btnCheckCard.Enabled then btnCheckCard.Enabled := bgCommsWorking;
  if btnAdd.Enabled then btnAdd.Enabled := bgCommsWorking and (LoginMode <> lmOperator);
  if btnEdit.Enabled then btnEdit.Enabled := bgCommsWorking and (LoginMode <> lmOperator) and (ExLocal.Linv.RunNo = 0);
  if btnBillSplit.Enabled then btnBillSplit.Enabled := bgCommsWorking;
end;

procedure TFrmCardDetails.btnDCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmCardDetails.btnDCancelClick(Sender: TObject);
begin
  if (FormMode = fmEdit) then LockRecord(CustF, CustCodeK, ExLocal, FALSE);
  SetFormMode(fmView);
  if not (Sender is TForm) then UpdateDetails(TRUE{FALSE});
end;

procedure TFrmCardDetails.btnDAddClick(Sender: TObject);
begin
  if not SetFormMode(fmAdd) then TillCommsError;
end;

procedure TFrmCardDetails.btnDEditClick(Sender: TObject);
begin
  if not SetFormMode(fmEdit) then TillCommsError;
end;

procedure TFrmCardDetails.UpdateDetails(bAssign : boolean);
begin
  with ExLocal, LCust do begin
    if bAssign then begin
      AssignFromGlobal(CustF); {makes a local copy of the global variable}
      LGetRecAddr(CustF);
    end;{if}

    Cust2Form;
    RefreshLedger;

    {Get Best Balance From Tills}
    if (Cust.TillNo <= 0) or (Cust.TillNo > Syss.MaxGuest) then
      begin
        if (Cust.TillNo = 0) and (Cust.Hold = 2) then
          begin
            {this is OK, just use the ledger balance}
            edBalance.Text := MoneyToStr(Cust.CurrBalance);
          end
        else begin
          MsgBox('This card has an illegal track number allocated to it (' + IntToStr(Cust.TillNo) + ')'
          + #13#13 + 'The balance for this card cannot be retreived.'
          ,mtError,[mbOK],mbOK,'Illegal Track No : ' + IntToStr(Cust.TillNo));
        end;{if}
      end
    else begin
      if bgCommsWorking then FrmComms.GetScreenBalance(Cust.TillNo, FALSE);
    end;{if}
  end;{with}
  SetHoldCaption;
end;

procedure TFrmCardDetails.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;
  FormStuff.Free;
end;

procedure TFrmCardDetails.btnDOKClick(Sender: TObject);
begin
  if (SaveCardDetails) and (not (Sender is TForm)) then SetFormMode(fmView);
  SendMessage((Owner as TForm).Handle,WM_CustGetRec,200,0);
end;

procedure TFrmCardDetails.FormResize(Sender: TObject);
begin
  DoFormResize(Self, FormStuff);
end;

procedure TFrmCardDetails.panLDescTitMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {depresses the column header}
  if (Sender is TSBSPanel) and (not TSBSPanel(Sender).ReadytoDrag) and (Button = MBLeft)
  then FormStuff.aMULCtrlO[TSBSPanel(Sender).Tag].VisiList.PrimeMove(Sender); {begin column drag/drop}
end;

procedure TFrmCardDetails.panLDescTitMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  {visually moves column header to show the change about to be made (drag/drop}
  if (Sender is TSBSPanel) then FormStuff.aMULCtrlO[TSBSPanel(Sender).Tag].VisiList.MoveLabel(X,Y);
end;

procedure TFrmCardDetails.panLDescTitMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender is TSBSPanel) then DoMoveAlignCols(TSBSPanel(Sender), FormStuff, TSBSPanel(Sender).Tag);
end;

procedure TFrmCardDetails.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 400;
    ptMinTrackSize.Y := 308;
  end;{with}
  Message.Result := 0;
  inherited;
end;

procedure TFrmCardDetails.RefreshLedger;
var
  KeyStart    :  Str255;
  iStatus, iLastAddress : integer;
begin
  with FormStuff.aMULCtrlO[1], ExLocal, LCust do begin
    KeyStart := Copy(CustCode,1,6);
    if KeyStart <> '' then StartList(InvF,InvCustK,KeyStart,'','',Length(KeyStart), TRUE);

    KeyStart := KeyStart + NDXWEIGHT;
    iStatus := Find_Rec(B_GetLessEq,F[InvF],InvF,RecPtr[InvF]^,InvCustK,KeyStart);

    if (iStatus = 0) and LineOk(SetCheckKey) then
      begin
        GetPos(F[InvF],InvF,iLastAddress);
        PageKeys[0] := iLastAddress;
        PageUpDn(0,FALSE);
        Update_Select(ItemCount,False);
      end
    else begin
      InitPage;
      Update_Select(0,False);
    end;{if}
  end;{with}
  SendMessage(Self.Handle,WM_FormCloseMsg,1001,0); {added to fix list with only one line problem}
end;

procedure TFrmCardDetails.WMCustGetRec(var Message : TMessage);
{Receive message that a List Action has occured}
begin
  with Message do begin
    case WParam of
      {List Double Click}
      0 : btnShowDetailsClick(Self);

      {List Click}
      1 : PostMessage(Self.Handle,WM_FormCloseMsg,1001,0); {* This was placed here to stop the mouse up event from being corrupted *}

      {List Right Click}
      2 :;

      {Update List Item}
      200 : begin
        FormStuff.aMULCtrlO[1].AddNewRow(FormStuff.aMULCtrlO[1].MUListBoxes[1].Row,FALSE);
        SendMessage((Owner as TForm).Handle,WM_CustGetRec,200,0);
      end;
    end;{case}
  end;{with}
  inherited;
end;

function TFrmCardDetails.SaveCardDetails : boolean;
var
  bLock, bContinue : Boolean;
begin
  Form2Cust;
  with ExLocal, LCust do begin
    if (FormMode = fmAdd) and (LastCust.CustCode <> CustCode)
    then bContinue := (not Check4DupliGen(CustCode,CustF,CustCodeK,'Card Number')) {check for duplicate codes}
    else bContinue := TRUE;

    if bContinue then begin
      if (edName.Text = '') or (edName.Text = ' ') then
        begin
          MessageDlg('Invalid Card Name',mtWarning,[mbOk],0);
          bContinue := FALSE;
        end
      else begin
        if (not EmptyKey(CustCode,CardKeyLen)) then
          begin
            {save record}
            if (FormMode = fmEdit) then
              begin
                {$IFDEF CS}
                  If ((Live) or (SBSIn)) then {* Update CS*}
                  Begin
                    ChangeFlag:=3;
                    If (Not Syss.UpWrite) and (Cust.CSRecNo<>0) then
                    Begin
                      GlobLocked:=TRUE;
                      GetMultiSys(TRUE,GlobLocked);
                      Syss.UpWrite:=TRUE;
                      PutMultiSys;
                    end;
                  end;
                {$ENDIF}

                SaveRecord(CustF, ExLocal);

                if Cust.AllowCredit and (not LCust.AllowCredit) and (rLastBalance > 0)
                then DoHoldCard(ExLocal, 1, TRUE);

                if not Cust.AllowCredit and (LCust.AllowCredit) and (rLastBalance > 0)
                then DoHoldCard(ExLocal, 0, TRUE);
              end
            else begin
              {Add Card}

              {initialise values}
              CustSupp := 'C';
              CSpent := 0;
              CPaid := 0;

              {Write to database}
              bLock := TRUE;
              GetMultiSys(TRUE,bLock);
              TillNo := Get_NextTillNo(TRUE);
              AddRecord(CustF, ExLocal);
              PutMultiSys(TRUE);

              {zero balance on till}
              FrmComms.SetBalance(ALLTILLS, 0, TillNo, FALSE);
            end;{if}
            if (FormMode = fmEdit) then LockRecord(CustF, CustCodeK, ExLocal, FALSE);
            Cust2Till(LCust);
          end
        else MessageDlg('Invalid Card Number',mtWarning,[mbOk],0);
      end;{if}
    end;{if}
  end;{with}
  Result := bContinue;
end;

procedure TFrmCardDetails.Form2Cust;
{Copies the values on the screen into the local record instance}
begin
  with ExLocal, LCust do begin
    if FormMode = fmAdd then begin
      LResetRec(CustF);
      CustCode := PadString(psRight, edNumber.Text, ' ', CardKeyLen);
      if Syss.UseIssueNumbers then IssueNumber := StrToIntDef(edIssueNo.Text, FIRST_ISSUE_NUMBER);
    end;{if}

    {just in case you need to change the track no}
    if edTrackNo.Visible then TillNo := Round(edTrackNo.Value);


    Company := PadString(psRight, edName.Text, ' ', SizeOf(Company) - 1);
    Title := cmbTitle.Text;
    Addr[1] := edAddress1.Text;
    Addr[2] := edAddress2.Text;
    Addr[3] := edAddress3.Text;
    Addr[4] := edAddress4.Text;
    ClubNo := PadString(psRight, edMemCode.Text, ' ', CardClubNoLen);
    FirstName := edInitials.Text;
    CSpent := edSpent.Value;
    CPaid := edPaidIn.Value;
    Phone := edHomeTel.Text;
    Fax := edWorkTel.Text;
    AllowCredit := cbCredit.Checked;
    ClubCat := cmbCategory.Text;
  end;{with}
end;

procedure TFrmCardDetails.btnShowDetailsClick(Sender: TObject);
var
  bLValidLine : boolean;
  NewMode : TFormMode;
begin
  bLValidLine := FormStuff.aMulCtrlO[1].ValidLine;

  {find what the newmode is going to be}
  if (Sender is TSBSButton) and (TSBSButton(Sender).Name = 'btnAdd') then NewMode := fmAdd;
  if (Sender is TSBSButton) and (TSBSButton(Sender).Name = 'btnEdit') then NewMode := fmEdit;
  if ((Sender is TSBSButton) and (TSBSButton(Sender).Name = 'btnShowDetails'))
  or ((Sender is TForm) and (TForm(Sender).Name = 'FrmCardDetails')) then NewMode := fmView;

  if (NewMode <> fmView) and (not bgCommsWorking) then
    begin
      TillCommsError;
      Exit;
    end
  else begin
    if (bLValidLine and (NewMode <> fmAdd)) or (NewMode = fmAdd) then begin
      if FrmTXDetails = nil then FrmTXDetails := TFrmTXDetails.Create(self);
      with FrmTXDetails do begin
        if (FormMode = fmAdd) or (FormMode = fmEdit) then Show
        else begin
          bValidLine := bLValidLine;
          UpdateDetails(ExLocal, NewMode);
          Show;
        end;{if}
      end;{with}
    end;{if}
  end;{if}
end;

procedure TFrmCardDetails.WMFormCloseMsg(var Message : TMessage);
{receive a message that a child window has closed}
var
  bLValidLine : boolean;
begin
  with Message do begin
    case WParam of
      1 : FrmTXDetails := nil;  {Transaction Details Form Close}

      {List Click (deferred from WMCustGetRec for mousey reasons)}
      1001 : begin
        FormStuff.aMulCtrlO[1].ValidLine;
        bLValidLine := FormStuff.aMulCtrlO[1].ValidLine;
        if bLValidLine then begin
          with ExLocal do begin
            AssignFromGlobal(InvF); {makes a local copy of the global variable}
            LGetRecAddr(InvF);
          end;{with}
        end;{if}

        if (FrmTXDetails <> nil) then begin
          with FrmTXDetails do begin
            bValidLine := bLValidLine;
            if FormMode = fmView then UpdateDetails(ExLocal, fmView);
          end;{with}
        end;{if}
        btnEdit.Enabled := bgCommsWorking and (LoginMode <> lmOperator) and (ExLocal.Linv.RunNo = 0);
      end;
    end;{case}
  end;{with}
  inherited;
end;

procedure TFrmCardDetails.Cust2Form;
var
  sTrimCode : string;
begin
  with ExLocal, LCust do begin
    {fills controls from local record instance}
    sTrimCode := TrimString(psRight, CustCode, ' ');
    if sTrimCode = '' then sTrimCode := '0';
    edNumber.Value := StrToInt(sTrimCode);
    if Syss.UseIssueNumbers then edIssueNo.Value := IssueNumber;
    edName.Text := Strip('R',[#0,#32], Company);
    cmbTitle.Text := Title;
    edAddress1.Text := Addr[1];
    edAddress2.Text := Addr[2];
    edAddress3.Text := Addr[3];
    edAddress4.Text := Addr[4];
    edMemCode.Text := TrimString(psRight, ClubNo, ' ');
    edInitials.Text := RemoveAllChars(FirstName,' ');
    edSpent.Value := CSpent;
    edPaidIn.Value := CPaid;
    edLastUsed.DateValue := OrdDate;
    edHomeTel.Text := Phone;
    edWorkTel.Text := Fax;
    cbCredit.Checked := AllowCredit;

    rLastBalance := StrToFloatDef(edBalance.Text,0);
    edBalance.Text := '---.--';

    cmbCategory.Text := ClubCat;
    lTrackNo.Caption := 'Track No : ' + IntToStr(ExLocal.LCust.TillNo);

    lStatusTit.Font.Color := clRed;
    lStatus.Font.Color := clRed;
    case Hold of
      1 : lStatus.Caption := sOverLimit;
      2 : lStatus.Caption := sExpired;
      5 : lStatus.Caption := sSuspended;
    else
      lStatus.Caption := 'Normal';
      lStatusTit.Font.Color := clBlack;
      lStatus.Font.Color := clBlack;
    end;{Case}
  end;{with}
  Caption := 'Card Details - ' + edName.Text;
end;

procedure TFrmCardDetails.btnHoldClick(Sender: TObject);
begin
  if bgCommsWorking then
    begin
      if (Sender is TSBSButton) and (TSBSButton(Sender).Caption = '&Hold')
      then pmHold.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y)
      else HoldCard(Sender);
    end
  else TillCommsError;
end;

procedure TFrmCardDetails.HoldCard(Sender: TObject);
begin
  if (TComponent(Sender).Tag = 0) or (MsgBox('Are you sure you want to put this card on hold ?'
  ,mtConfirmation,[mbYes,mbNo],mbNo,RemoveAllChars(TMenuItem(Sender).Caption,'&')) = mrYes) then begin
    screen.cursor := crHourglass;
    DoHoldCard(ExLocal, TComponent(Sender).Tag, TRUE);
    SendMessage(TForm(Owner).Handle,WM_CustGetRec,1,0); {refresh screen}
    screen.cursor := crDefault;
  end;{if}
end;

procedure TFrmCardDetails.WMMPComms(var Message : TMessage);
{receives a message from the MPComms Object - with the balance in it}
begin
  with Message do begin
    if wParam = -1 then edBalance.Text := '---.--'
    else edBalance.Text := PenceToStr(lParam);
    if lParam > 0 then
      begin
        lBalance.Font.Color := clRed;
        EdBalance.Font.Color := clRed;
      end
    else begin
      lBalance.Font.Color := clBlack;
      EdBalance.Font.Color := clBlack;
    end;{if}
  end;{with}
end;

procedure TFrmCardDetails.btnReProgramClick(Sender: TObject);
var
  iNewBalance : integer;
begin
  if bgCommsWorking then
    begin
      iNewBalance := PenceIt(ExLocal.LCust.CurrBalance);
      if MsgBox('This will reset the balance of this card back to £ ' + PenceToStr(iNewBalance)
      + ' on all tills.' + CHR(13) + CHR(13) + 'Are you sure you want to do this ?'
      ,mtConfirmation,[mbYes,mbNo], mbNo, 'Re-Program Card') = mrYes then begin

        {updates the name in the till}
        Cust2Till(Cust, ALLTILLS);

        {update balance on till}
        FrmComms.SetBalance(ALLTILLS, iNewBalance, Cust.TillNo, FALSE);
        SendMessage(TForm(Owner).Handle,WM_CustGetRec,1,0); {refresh screen}
        TechSuppLog('reprogram card ' + Cust.CustCode);
      end;{if}
    end
  else TillCommsError;
end;

procedure TFrmCardDetails.btnCheckCardClick(Sender: TObject);
{Scans a Customer Rec & Re-calculates the balance}
var
  iStatus : smallint;
  KeyS : Str255;
  bLock : boolean;
begin
  if bgCommsWorking then
    begin
      if (MsgBox('Are you sure that you want to check this card ?',mtConfirmation,[mbYes,mbNo],mbNo,'Check Card') = mrYes)
      and LockRecord(CustF, CustCodeK, ExLocal, TRUE) then begin
        with ExLocal, LInv, LCust do begin
          CurrBalance := 0;
          CPaid := 0;
          CSpent := 0;

          KeyS := CustCode;
          iStatus := Find_Rec(B_GetGEq,F[InvF],InvF,LRecPtr[InvF]^,InvCustK,KeyS);
          while (iStatus = 0) and (Copy(KeyS,1,6) = CustCode) do begin
            CalcCustBals(LCust, LInv);

            ChangeFlag := 3;
            KeyS := CustCode;
            iStatus := Find_Rec(B_GetNext,F[InvF],InvF,LRecPtr[InvF]^,InvCustK,KeyS);
          end;{while}
          CPaid := CPaid;
          CSpent := CSpent;
          CurrBalance := CurrBalance;
          iStatus := Put_Rec(F[CustF],CustF,LRecPtr[CustF]^,CustCodeK); {save cust record}
        end;{with}
        LockRecord(CustF, CustCodeK, ExLocal, FALSE); {unlock cust record}
        Report_BError(CustF, iStatus);

        {set the Club2000 export flag}
        bLock := TRUE;
        GetMultiSys(TRUE, bLock);
        Syss.UpWrite := TRUE;
        PutMultiSys(TRUE);

        SendMessage(TForm(Owner).Handle,WM_CustGetRec,1,0); {refresh screen}
        TechSuppLog('check account ' + Cust.CustCode);
      end;{if}
    end
  else TillCommsError;
end;

procedure TFrmCardDetails.Label2DblClick(Sender: TObject);
begin
  lTrackNo.Visible := (not lTrackNo.Visible) and (LoginMode = lmDebug);
end;

procedure TFrmCardDetails.lTrackNoClick(Sender: TObject);
begin
  if FormMode = fmEdit then begin
    edTrackNo.Visible := TRUE;
    edTrackNo.Text := IntToStr(ExLocal.LCust.TillNo);
  end;{if}
end;

procedure TFrmCardDetails.SetHoldCaption;
begin
  if ExLocal.LCust.Hold = 0 then btnHold.Caption := '&Hold'
  else btnHold.Caption := 'Cancel &Hold';
end;

procedure TFrmCardDetails.btnDeleteClick(Sender: TObject);
var
  CustR : CustRec;
  iStatus : smallint;
  FrmMessageScreen : TFrmMessageScreen;
begin
  if bgCommsWorking or (LoginMode = lmDebug) then
    begin
      if (msgBox('Are you sure you want to delete this card ?',mtConfirmation
      ,[mbYes,mbNo],mbNo,'Delete Card') = mrYes) and LockRecord(CustF, CustCodeK
      , ExLocal, TRUE) then begin
        screen.cursor := crHourglass;
        if (LoginMode = lmDebug) or (FrmComms.GetBestBalance(-1, ExLocal.LCust.TillNo, TRUE) = 0) then
          begin
            try
              FrmMessageScreen := TFrmMessageScreen.Create(Self);
              with FrmMessageScreen do begin
                lMessage.Caption := 'Deleting Card';
                Show;
                Refresh;
              end;{with}

              {delete Inv and SalesDet Records}
              DeleteLinks(Cust.CustCode,InvF,CardKeyLen,InvCustK);

              {delete Card Record}
              iStatus := Delete_Rec(F[CustF],CustF,CustCodeK);
              Report_Berror(CustF, iStatus);
              if (iStatus = 0) then begin
                { HM 15/12/98: Added to remove card details from till }
                if bgCommsWorking then begin
                  FillChar (CustR, SizeOf(CustR), #0);
                  with CustR do begin
                    TillNo := ExLocal.LCust.TillNo;
                    Hold   := 1;
                  end;{with}
                  Cust2Till(CustR);
                  SendMessage(Self.Handle,WM_CustGetRec,200,0);
                end;{if}
              end;{if}
              FrmMessageScreen.Hide;
            finally
              FrmMessageScreen.Release;
            end;{try}
          end
        else MsgBox('You cannot delete this card, as the balance is not zero',mtInformation,[mbOK]
        ,mbOK,'Delete Card');
        screen.cursor := crDefault;
      end;{if}
    end
  else TillCommsError;
end;

procedure TFrmCardDetails.edNumberExit(Sender: TObject);
var
  sCode : string;
begin
  if (activecontrol.name <> 'btnDClose') and (activecontrol.name <> 'btnDCancel') then begin
    with ExLocal, LCust do begin
      sCode := PadString(psRight,edNumber.Text,' ',CardKeyLen);
      if (FormMode = fmAdd) and Check4DupliGen(sCode,CustF,CustCodeK
      ,'Card Number') then begin {check for duplicate codes}
        ActiveControl := edNumber;
      end;
    end;{with}
  end;{if}
end;

procedure TFrmCardDetails.edNameExit(Sender: TObject);
begin
  if (activecontrol.name <> 'btnDCancel') and (activecontrol.name <> 'btnDClose')
  and ((edName.Text = '') or (edName.Text = ' ')) then begin
    MessageDlg('Invalid Card Name',mtWarning,[mbOk],0);
    ActiveControl := edName;
  end;{if}
end;

procedure TFrmCardDetails.edInitialsExit(Sender: TObject);
begin
  edInitials.Text := RemoveAllChars(edInitials.Text,' ');
end;

procedure TFrmCardDetails.btnDStatementClick(Sender: TObject);
var
  FrmDateRange : TFrmDateRange;
  cMode : char;
begin
  cMode := TSBSButton(Sender).Name[4];
  case cMode of
    'D' : begin
      {Details Tab}
      FrmDateRange := TFrmDateRange.Create(fmStatementDetail);
      FrmDateRange.sStartDate := DateToStr8(Now - 30);
      FrmDateRange.sEndDate := DateToStr8(Now);
    end;

    'L' : begin
      {Ledger Tab}
      FrmDateRange := TFrmDateRange.Create(fmStatementLedger);
      with FrmDateRange do begin
        if FormStuff.aMulCtrlO[1].ValidLine then
          begin
            sStartDate := Inv.TransDate;
            sEndDate := Inv.TransDate;
          end
        else begin
          sStartDate := DateToStr8(Now - 30);
          sEndDate := DateToStr8(Now);
        end;{if}
      end;{with}
    end;
  end;{case}
  FrmDateRange.ShowModal;
end;

procedure TFrmCardDetails.btnChangeNoClick(Sender: TObject);
var
  sNewCode : string;
  KeyS : str255;
  iStatus : smallint;
  FrmMessageScreen : TFrmMessageScreen;
begin
  with FrmFindDlg do begin
    try
      {Show Find Form}
      FrmFindDlg := TFrmFindDlg.Create(Self);
      FindMode := fmChangeNumber;
      if ShowModal = mrOK then begin
        screen.cursor := crHourglass;
        sNewCode := PadString(psRight, edValue.Text, ' ', CardKeyLen);

        {check for duplicate}
        KeyS := sNewCode;
        iStatus := Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyS);

        if iStatus = 0 then MsgBox('A Card already exists with that number' + CHR(13)
        + 'You cannot change the card number to this.',mtError,[mbOK],mbOK,'Renumber Card')
        else begin
          if (iStatus = 4) then
            begin
              try
                FrmMessageScreen := TFrmMessageScreen.Create(Self);
                with FrmMessageScreen do begin
                  lMessage.Caption := 'Changing Card Number';
                  Show;
                  Refresh;
                end;{with}

                {remove Card from till}
                ExLocal.LCust.Hold := 1;
                Cust2Till(ExLocal.LCust);

                {Change all invs and salesdets}
                ChangeLinks(Cust.CustCode, sNewCode, InvF, CardKeyLen, InvCustK);

                // Renumber cards held in the Function Booking database
                RenumberFunctions(Cust.CustCode, sNewCode);

                {update cust record}
                ExLocal.LCust.Hold := 0;
                ExLocal.LCust.CustCode := sNewCode;
                SaveRecord(custF, ExLocal);

                {Add Card back to till}
                Cust2Till(ExLocal.LCust);

                {update detail screen}
                edNumber.Text := sNewCode;

                {update main form}
                SendMessage((Owner as TForm).Handle,WM_CustGetRec,200,0);

                FrmMessageScreen.Hide;
              finally
                FrmMessageScreen.Release;
              end;{try}
            end
          else Report_BError(CustF, iStatus);
        end;{if}
        screen.cursor := crDefault;
      end;{if}
    finally
      FrmFindDlg.Release;
    end;{try}
  end;{with}
end;

procedure TFrmCardDetails.btnBillSplitClick(Sender: TObject);
var
  Incentive, Debits, Credits, Balance : real;
  bValidLine : boolean;
begin
  bValidLine := FormStuff.aMulCtrlO[1].ValidLine;
  CalcInvoiceCredits(Inv, Debits, Incentive, Credits, Balance);
  if bValidLine and (GetTransDesc(Inv, Debits) = 'Spend') then begin
    try
      FrmMain.FrmBillSplit := TFrmBillSplit.create(self);
      if FrmMain.FrmBillSplit.ShowModal = mrOK then FormStuff.aMULCtrlO[1].AddNewRow
      (FormStuff.aMULCtrlO[1].MUListBoxes[1].Row,FALSE);
    finally
      FrmMain.FrmBillSplit.Release;
    end;{try}
  end;{if}
end;

procedure TFrmCardDetails.pcMainChange(Sender: TObject);
begin
  case pcMain.ActivePageIndex of
    0 : HelpContext := 6;
    1 : HelpContext := 11;
  end;{case}
end;

procedure TFrmCardDetails.edIssueNoExit(Sender: TObject);
begin
  if (activecontrol.name <> 'btnDClose') and (activecontrol.name <> 'btnDCancel') then begin
    with ExLocal, LCust do begin
      if StrToIntDef(edIssueNo.Text, 0) < 1 then ActiveControl := edIssueNo;
    end;{with}
  end;{if}
end;

procedure TFrmCardDetails.btnNewIssueNoClick(Sender: TObject);
var
  iNewIssueNo : Byte;
  KeyS : str255;
  iStatus : smallint;
  FrmMessageScreen : TFrmMessageScreen;
begin
  with FrmFindDlg do begin
    try
      {Show Find Form}
      FrmFindDlg := TFrmFindDlg.Create(Self);
      FindMode := fmChangeIssueNumber;
      if ShowModal = mrOK then begin
        screen.cursor := crHourglass;
        iNewIssueNo := StrToInt(edValue.Text);

        {remove Card from till}
//        ExLocal.LCust.Hold := 1;
//        Cust2Till(ExLocal.LCust);

        {update cust record}
//        ExLocal.LCust.Hold := 0;
        ExLocal.LCust.IssueNumber := iNewIssueNo;
        SaveRecord(custF, ExLocal);

        {Add Card back to till}
        if ExLocal.LCust.Hold = 0 then Cust2Till(ExLocal.LCust);

        {update detail screen}
        edIssueNo.Value := iNewIssueNo;

        {update main form}
        SendMessage((Owner as TForm).Handle,WM_CustGetRec,200,0);

        screen.cursor := crDefault;
      end;{if}
    finally
      FrmFindDlg.Release;
    end;{try}
  end;{with}
end;

procedure TFrmCardDetails.btnDeleteLineClick(Sender: TObject);
var
  ExLocal : TdExlocal;
  iStatus, iFolioNo : integer;
  KeyS : Str255;
begin

  if (FormStuff.aMulCtrlO[1].ValidLine) and (msgBox('Deleting a line in the ledger should not be done under normal operation.' + #13#13
  + 'Are you absolutely sure you want to delete this line from the ledger ?',mtWarning
  ,[mbYes,mbNo],mbNo,'Delete Line') = mrYes) then begin

    iFolioNo := Inv.FolioNum;
    ExLocal.Create;

    with ExLocal do begin

      // Get record
      Blank(KeyS,SizeOf(KeyS));
      KeyS := FullNomKey(iFolioNo);
      iStatus := Find_Rec (B_GetGEq, F[InvF],InvF,LRecPtr[InvF]^,InvFolioK,KeyS);
      ExLocal.LGetRecAddr(InvF);

      //ExLocal.AssignFromGlobal(InvF);
      if (iStatus = 0) and (LInv.FolioNum = iFolioNo) {which it bloody well should}
      and LockRecord(InvF, InvFolioK, ExLocal, TRUE) then begin

        TechSuppLog('Delete Line done for Card ' + LCust.CustCode);

        // delete invoice record
        Delete_Rec(F[InvF], InvF, InvCustK);

        // get 1st TXLine for the deleted TX
        Blank(KeyS,SizeOf(KeyS));
        KeyS := FullNomKey(iFolioNo);
        iStatus := Find_Rec(B_GetGEq, F[SalesDetF],SalesDetF,LRecPtr[SalesDetF]^,sdFolioK,KeyS);
        ExLocal.LGetRecAddr(SalesDetF);
        while (iStatus = 0) and (ExLocal.LSalesDet.sdFolioNum = iFolioNo) do begin

          Delete_Rec(F[SalesDetF], SalesDetF, sdFolioK);

          KeyS := FullNomKey(iFolioNo);
          iStatus := Find_Rec(B_GetGEq, F[SalesDetF],SalesDetF,LRecPtr[SalesDetF]^,sdFolioK,KeyS);
          ExLocal.LGetRecAddr(SalesDetF);
        end;{while}

      end;{if}
    end;{with}
  end;{if}
end;

end.


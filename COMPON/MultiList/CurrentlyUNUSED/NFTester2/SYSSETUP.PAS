unit syssetup;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, CompUtil, StdCtrls
  , TEditVal, ComCtrls, BorBtns, Mask, ExtCtrls, BTSupU1, ChngPass, APIUtil,VarConst, CardProc
  , NeilProc, MPComms, Browse, FileCtrl, TillName, DLLProc, StrUtil, TCustom, EntSetup;

type
  TFrmSystemSetup = class(TForm)
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    pcOptions: TPageControl;
    tsGeneral: TTabSheet;
    tsTills: TTabSheet;
    tsEnterprise: TTabSheet;
    tsClub: TTabSheet;
    Bevel1: TBevel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edMultiplexor1: Text8Pt;
    edMultiplexor2: Text8Pt;
    edNoOfTills: TCurrencyEdit;
    SBSUpDown3: TSBSUpDown;
    Bevel3: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edOpPass: Text8Pt;
    edMasterPass: Text8Pt;
    Bevel4: TBevel;
    lVATMode: TLabel;
    cmbVatMode: TSBSComboBox;
    Bevel6: TBevel;
    lEntDir: TLabel;
    edEntDir: Text8Pt;
    Label6: TLabel;
    lFirstTrackNo: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edNextTrack: TCurrencyEdit;
    Bevel5: TBevel;
    lCustAcc: TLabel;
    lVAT: TLabel;
    edCustAccount: Text8Pt;
    btnTillNames: TButton;
    btnEntBrowse: TButton;
    Label19: TLabel;
    Bevel8: TBevel;
    edClubDir: Text8Pt;
    btnClubBrowse: TButton;
    Bevel9: TBevel;
    Bevel10: TBevel;
    Label20: TLabel;
    edCSImportNo: TCurrencyEdit;
    Label21: TLabel;
    edCSExportNo: TCurrencyEdit;
    Label22: TLabel;
    Label23: TLabel;
    TabSheet1: TTabSheet;
    Bevel11: TBevel;
    Bevel12: TBevel;
    Label25: TLabel;
    Label26: TLabel;
    edDefaultDiscount: TCurrencyEdit;
    Label27: TLabel;
    Bevel13: TBevel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    edTopupDeptNo: TCurrencyEdit;
    Label31: TLabel;
    edTopupDeptDesc: Text8Pt;
    Bevel14: TBevel;
    Label32: TLabel;
    Label15: TLabel;
    Bevel7: TBevel;
    Label16: TLabel;
    edAEODStartTime: TMaskEdit;
    lLastTrack: TLabel;
    btnChangeOpPass: TButton;
    btnChangeMasPass: TButton;
    lCustName: TLabel;
    Bevel15: TBevel;
    Bevel16: TBevel;
    cbLiveExch: TCheckBox;
    cbEODPLUDownload: TCheckBox;
    cbOpAEOD: TCheckBox;
    cbRunOpenTableRep: TCheckBox;
    cbGetTillSales: TCheckBox;
    cbDiscByItem: TCheckBox;
    cbReceiptDefDisc: TCheckBox;
    cbODDiscount: TCheckBox;
    cbULCredit: TCheckBox;
    cbPrintGroupSales: TCheckBox;
    cbHideEODErrorLog: TCheckBox;
    cbCalcDiscountOnGS: TCheckBox;
    cbHideExpMem: TCheckBox;
    cb4mbEproms: TCheckBox;
    cb4mbDiscounts: TCheckBox;
    cbClub2000: TCheckBox;
    cbImpLowercase: TCheckBox;
    cbToolkit: TCheckBox;
    btnAdditional: TButton;
    cbCheckMUX: TCheckBox;
    cbUseIssueNumbers: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnEntBrowseClick(Sender: TObject);
    procedure btnClubBrowseClick(Sender: TObject);
    procedure btnTillNamesClick(Sender: TObject);
    procedure btnChangeOpPassClick(Sender: TObject);
    procedure edCustAccountExit(Sender: TObject);
    procedure cmbVatModeChange(Sender: TObject);
    procedure edNoOfTillsExit(Sender: TObject);
    procedure SBSUpDown3Click(Sender: TObject; Button: TUDBtnType);
    procedure pcOptionsChange(Sender: TObject);
    procedure cbLiveExchClick(Sender: TObject);
    procedure cb4mbEpromsClick(Sender: TObject);
    procedure DiscountCheck(Sender: TObject);
    procedure btnAdditionalClick(Sender: TObject);
  private
    frmEnterpriseSetup : TfrmEnterpriseSetup;
    procedure GreyOut;
    function GetCustDesc : boolean;
  public
    { Public declarations }
  end;

{var
  FrmSystemSetup: TFrmSystemSetup;}

implementation

uses Comms, MainF;

{$R *.DFM}

procedure TFrmSystemSetup.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmEnterpriseSetup.Release;
  SendMessage(TForm(Owner).Handle,WM_FormCloseMsg,3,0);
  Action := caFree;
end;

procedure TFrmSystemSetup.FormShow(Sender: TObject);
var
  iTillMaxGuests, iComp : integer;
  bLock : boolean;
  MaxRec : TMaximumsRec;
begin
  edTopupDeptNo.displayformat := '#########0';
  edDefaultDiscount.displayformat := '#0.00';
  edNextTrack.displayformat := '#########0';
  edCSImportNo.displayformat := '#########0';
  edCSExportNo.displayformat := '#########0';

  frmEnterpriseSetup := TfrmEnterpriseSetup.create(application);

  pcOptions.ActivePage := tsGeneral;

  bLock := TRUE;
  GetMultiSys(TRUE,bLock);

  setlength(agBalances,Syss.NoTills + 1);

  with Syss do begin
    {general Tab}
    edOpPass.Text := OpPassW;
    edMasterPass.Text := Password;
    edTopupDeptNo.Text := IntToStr(TopupDept);
    edTopupDeptDesc.Text := TopupDesc;
    edAEODStartTime.Text := copy(EODTime,1,2) + {':' +} copy(EODTime,4,2);
    cbEODPLUDownload.Checked := EODDLoadPLU;
    cbGetTillSales.Checked := EODTillReps;
    cbOpAEOD.Checked := OpoDoAutoEOD;
    cbRunOpenTableRep.Checked := EODShowTableRep;

    {Discounts / Reports Tab}
    cbDiscByItem.Checked := UseSplDisc;
    cbReceiptDefDisc.Checked := UseMarkup;
    cbODDiscount.Checked := ODDisc;
    edDefaultDiscount.Text := MoneyToStr(Markup);
    cbULCredit.Checked := DefCredit;

    cbPrintGroupSales.Checked := PrnGrSales;
    cbHideEODErrorLog.Checked := HideEodLog;
    cbCalcDiscountOnGS.Checked := GrSalCalcDisc;
    cbHideExpMem.Checked := HideExpired;

    {Tills Tab}
    edNoOfTills.Value := NoTills;
    edMultiplexor1.Text := MplxChar;
    edMultiplexor2.Text := Mux2Char;
    cbCheckMUX.Checked := not AssumeMUXSwitchesOK;
    cb4mbEproms.Checked := FourMbEproms;
    cb4mbDiscounts.Checked := FourMbDiscs;
    cbUseIssueNumbers.Checked := UseIssueNumbers;

{    if cb4mbEproms.Checked then cbGetTillSales.Enabled := TRUE
    else begin
      cbGetTillSales.Enabled := FALSE;
      cbGetTillSales.Font.Color := clGrayText;
    end;{if}


    If FourMbEproms Then lFirstTrackNo.Caption := IntToStr(MP2StartTrack4Mb)
    else lFirstTrackNo.Caption := IntToStr(MP2StartTrack);
    edNextTrack.Text := IntToStr(NGuest);

    if bgCommsWorking then
      begin
        MaxRec := FrmComms.GetMaxGuests(1, TRUE);
        iTillMaxGuests := StrToInt(MaxRec.Guests);
        lLastTrack.Caption := IntToStr(iTillMaxGuests);

        {update local maxguest counter}
        if iTillMaxGuests <> MaxGuest then begin
          MaxGuest := iTillMaxGuests;
          PutMultiSys(FALSE);
        end;{if}
      end
    else lLastTrack.Caption := '???';

    {Enterprise Tab}
    cbLiveExch.Checked := LinkToExch;
    edEntDir.Text := ExPath;
    cmbVatMode.ItemIndex := Ord(VatMode);
    edCustAccount.Text := AdvAccCode;
    cbLiveExchClick(Self);

    with frmEnterpriseSetup do begin
      edCardNom.Text := IntToStr(CNoms[NOM_CARD]);
      edCashNom.Text := IntToStr(CNoms[NOM_CASH]);
      edCorrectionNom.Text := IntToStr(CNoms[NOM_CORRECTION]);
      edForfeitNom.Text := IntToStr(CNoms[NOM_FORFEIT]);
      edDiscountNom.Text := IntToStr(CNoms[NOM_DISCOUNT]);
      edTillDepositNom.Text := IntToStr(CNoms[NOM_TILL_DEPOSIT]);
      edSalesNom.Text := IntToStr(CNoms[NOM_SALES]);

      edCostCentre.Text := DefaultCC;
      edDepartment.Text := DefaultDept;
    end;{with}

    {Club Tab}
    edClubDir.Text := MergePath;
    cbClub2000.Checked := Club2000;
    cbImpLowercase.Checked := ImpLowerCase;
    cbToolkit.Checked := UsingCardToolkit;
    edCSImportNo.Text := IntToStr(LastEventIn);
    edCSExportNo.Text := IntToStr(LastEventOut);
  end;{with}

  {sets the 'Position' of all the spin edit controls}
  For iComp := 0 to ComponentCount - 1 do begin
    if Components[iComp] is TSBSUpDown
    then TSBSUpDown(Components[iComp]).Position := Round(TCurrencyEdit(TSBSUpDown(Components[iComp]).Associate).Value);
  end;{for}

  if not (LoginMode  in [lmDebug, lmUser]) then GreyOut;

  if VatModeType(cmbVatMode.ItemIndex) = vmAdv then GetCustDesc;
  cmbVatModeChange(self);
end;

procedure TFrmSystemSetup.btnOKClick(Sender: TObject);
var
  iPrevNoOfTills : byte;
begin
  if (VatModeType(cmbVatMode.ItemIndex) in [vmNorm, vmDisc])
  or ((VatModeType(cmbVatMode.ItemIndex) = vmAdv) and GetCustDesc) then begin
    Screen.Cursor := crHourglass;
    ModalResult := mrOK;
    with Syss do begin
      {General Tab}
      TopupDept := StrToInt(edTopupDeptNo.Text);
      TopupDesc := edTopupDeptDesc.Text;

      EODTime := copy(edAEODStartTime.Text,1,2) + '.' + copy(edAEODStartTime.Text,3,2);
      EODDLoadPLU := cbEODPLUDownload.Checked;
      EODTillReps := cbGetTillSales.Checked;

      if OpoDoAutoEOD <> cbOpAEOD.Checked then TechSuppLog('Operator Auto-EOD Rights changed from '
      + BoolStr(OpoDoAutoEOD) + ' to '+ BoolStr(cbOpAEOD.Checked));
      OpoDoAutoEOD := cbOpAEOD.Checked;
      EODShowTableRep := cbRunOpenTableRep.Checked;


      {Discounts / Reports Tab}

      if (UseSplDisc <> cbDiscByItem.Checked) then TechSuppLog('Split Discount Flag changed from '
      + BoolStr(UseSplDisc) + ' to '+ BoolStr(cbDiscByItem.Checked));
      UseSplDisc := cbDiscByItem.Checked;

      UseMarkup := cbReceiptDefDisc.Checked;
      ODDisc := cbODDiscount.Checked;
      Markup := StrToFloat(edDefaultDiscount.Text);
      DefCredit := cbULCredit.Checked;

      PrnGrSales := cbPrintGroupSales.Checked;
      HideEodLog := cbHideEODErrorLog.Checked;
      GrSalCalcDisc := cbCalcDiscountOnGS.Checked;
      HideExpired := cbHideExpMem.Checked;


      {Tills Tab}
      iPrevNoOfTills := NoTills;

      if NoTills <> StrToInt(TrimString(psRight,edNoOfTills.Text,' ')) then TechSuppLog('No Of Tills changed from '
      + IntToStr(NoTills) + ' to ' + edNoOfTills.Text);

      NoTills := StrToInt(TrimString(psRight,edNoOfTills.Text,' '));
      setlength(agBalances,NoTills + 1);

      if Length(edMultiplexor1.Text) > 0 then begin
        if MplxChar <> edMultiplexor1.Text[1] then TechSuppLog('Mux1 changed from '
        + MplxChar + ' to '+ edMultiplexor1.Text);
        MplxChar := edMultiplexor1.Text[1];
      end;{if}

      if Length(edMultiplexor2.Text) > 0 then begin
        if Mux2Char <> edMultiplexor2.Text[1] then TechSuppLog('Mux2 changed from '
        + Mux2Char + ' to '+ edMultiplexor2.Text);
        Mux2Char := edMultiplexor2.Text[1];
      end;{if}

      AssumeMUXSwitchesOK := not cbCheckMUX.Checked;
      if (FourMbEproms <> cb4mbEproms.Checked) then TechSuppLog('4Mb Eproms changed from '
      + BoolStr(FourMbEproms) + ' to '+ BoolStr(cb4mbEproms.Checked));
      FourMbEproms := cb4mbEproms.Checked;
      FourMbDiscs := cb4mbDiscounts.Checked;
      UseIssueNumbers := cbUseIssueNumbers.Checked;

      if (NGuest <> StrToInt(edNextTrack.Text)) then TechSuppLog('Next Abs Track changed from '
      + IntToStr(NGuest) + ' to ' + edNextTrack.Text);

      NGuest := StrToInt(edNextTrack.Text);


      {Enterprise Tab}

      if LinkToExch <> cbLiveExch.Checked then begin
        if cbLiveExch.Checked then TechSuppLog('Exchequer Link Switched On')
        else TechSuppLog('Exchequer Link Switched Off');
      end;{if}
      LinkToExch := cbLiveExch.Checked;

      if ExPath <> edEntDir.Text then TechSuppLog('Exchequer Path changed from ' + ExPath
      + ' to ' + edEntDir.Text);
      ExPath := edEntDir.Text;

      if VatMode <> VatModeType(cmbVatMode.ItemIndex) then TechSuppLog('VAT Mode changed from '
      + IntToStr(Ord(VatMode)) + ' to '+ IntToStr(cmbVatMode.ItemIndex));
      VatMode := VatModeType(cmbVatMode.ItemIndex);

      AdvAccCode := edCustAccount.Text;

      with frmEnterpriseSetup do begin
        CNoms[NOM_CARD] := StrToIntDef(edCardNom.Text,0);
        CNoms[NOM_CASH] := StrToIntDef(edCashNom.Text,0);
        CNoms[NOM_CORRECTION] := StrToIntDef(edCorrectionNom.Text,0);
        CNoms[NOM_FORFEIT] := StrToIntDef(edForfeitNom.Text,0);
        CNoms[NOM_DISCOUNT] := StrToIntDef(edDiscountNom.Text,0);
        CNoms[NOM_TILL_DEPOSIT] := StrToIntDef(edTillDepositNom.Text,0);
        CNoms[NOM_SALES] := StrToIntDef(edSalesNom.Text,0);

        DefaultCC := edCostCentre.Text;
        DefaultDept := edDepartment.Text;
      end;{with}

      {Club Tab}
      MergePath := edClubDir.Text;
      Club2000 := cbClub2000.Checked;
      ImpLowerCase := cbImpLowercase.Checked;
      UsingCardToolkit := cbToolkit.Checked;
      LastEventIn := StrToInt(edCSImportNo.Text);
      LastEventOut := StrToInt(edCSExportNo.Text);

      UseMemBill := TRUE; {we ALWAYS want memory billing on in the windows card system}

    end;{with}
    PutMultiSys(TRUE);

    with FrmComms, Syss do begin
      MPComms.Enabled := FALSE;
      MPComms.SetProperties(igBaudRate, igCommsTimeout, igComPortNo, igDefaultRetries, NoTills
      , bgVerifySends, sEXEDir + sgLogFile, mplxChar, mux2Char, FourMbEproms, WincardVersion, sEXEDir
      , bgDetailedCommsLog, igMuxPause, bgLogBigErrors, AssumeMUXSwitchesOK);
      MPComms.Enabled := Live;
      if iPrevNoOfTills <> NoTills then FrmMain.CheckComms(TRUE, Self)
    end;{with}
    Screen.Cursor := crDefault;
  end;{if}
end;

procedure TFrmSystemSetup.btnCancelClick(Sender: TObject);
begin
  PutMultiSys(TRUE);
end;

procedure TFrmSystemSetup.btnEntBrowseClick(Sender: TObject);
var
  FrmDirBrowse : TFrmDirBrowse;
begin
  try
    FrmDirBrowse := TFrmDirBrowse.Create(Self);
    with FrmDirBrowse do begin
      if DirectoryExists(edEntDir.Text) then lbDirectory.Directory := edEntDir.Text;
      if ShowModal = mrOK then edEntDir.Text := PathToShort(lbDirectory.Directory) + '\';
    end;{with}
  finally
    FrmDirBrowse.Release;
  end;
end;

procedure TFrmSystemSetup.btnClubBrowseClick(Sender: TObject);
var
  FrmDirBrowse : TFrmDirBrowse;
begin
  try
    FrmDirBrowse := TFrmDirBrowse.Create(Self);
    with FrmDirBrowse do begin
      if DirectoryExists(edClubDir.Text) then lbDirectory.Directory := edClubDir.Text;
      if ShowModal = mrOK then edClubDir.Text := PathToShort(lbDirectory.Directory) + '\';
    end;{with}
  finally
    FrmDirBrowse.Release;
  end;
end;

procedure TFrmSystemSetup.btnTillNamesClick(Sender: TObject);
var
  FrmTillNames : TFrmTillNames;
begin
{  Syss.NoTills := StrToInt(TrimString(psRight,edNoOfTills.Text,' '));}
  try
    FrmTillNames := TFrmTillNames.create(self);
    FrmTillNames.Showmodal;
  finally
    FrmTillNames.Release;
  end;{try}
end;

procedure TFrmSystemSetup.btnChangeOpPassClick(Sender: TObject);
var
  FrmChangePassword : TFrmChangePassword;
begin
  try
    FrmChangePassword := TFrmChangePassword.Create(Self);
    with FrmChangePassword do begin
      PassFormMode := TPassFormMode(TWinControl(Sender).Tag);
      if ShowModal = mrOK then begin
        case PassFormMode of
          fmOperatorPass : edOpPass.Text := edConfirmPass.Text;
          fmMasterPass : edMasterPass.Text := edConfirmPass.Text;
        end;{case}
      end;{if}
    end;{with}
  finally
    FrmChangePassword.Release;
  end;{try}
end;

procedure TFrmSystemSetup.GreyOut;
var
  iComp : integer;
begin
  For iComp := 0 to (ComponentCount - 1) do begin
    if (Components[iComp] is Text8pt) and (Text8pt(Components[iComp]).Tag > 0)
    then Text8pt(Components[iComp]).Enabled := FALSE
    else begin
      if (Components[iComp] is TCurrencyEdit) and (TCurrencyEdit(Components[iComp]).Tag > 0)
      then TCurrencyEdit(Components[iComp]).Enabled := FALSE
      else begin
        if (Components[iComp] is TLabel) and (TLabel(Components[iComp]).Tag > 0)
        then TLabel(Components[iComp]).Enabled := FALSE
        else begin
          if (Components[iComp] is TCheckBox) and (TCheckBox(Components[iComp]).Tag > 0)
          then begin
            TCheckBox(Components[iComp]).Enabled := FALSE;
            TCheckBox(Components[iComp]).Font.Color := clGrayText;
          end;
        end;
      end;{if}
    end;{if}
  end;{for}
end;

procedure TFrmSystemSetup.edCustAccountExit(Sender: TObject);
begin
  if ActiveControl <> btnCancel then GetCustDesc;
end;

function TFrmSystemSetup.GetCustDesc : boolean;
var
  sCustName : string;
begin
  sCustName := oDLL.GetCustAccount(edCustAccount.Text);
  if sCustName = '##NOTFOUND##' then
    begin
      Result := FALSE;
      lCustName.Caption := '';
      MsgBox('The customer account code could not be found',mtError, [mbOK], mbOK, 'Customer Account');
    end
  else begin
    Result := TRUE;
    lCustName.Caption := sCustName;
  end;{if}
end;

procedure TFrmSystemSetup.cmbVatModeChange(Sender: TObject);
begin
  edCustAccount.Enabled := (VatModeType(cmbVatMode.ItemIndex) = vmAdv) and cbLiveExch.Checked;
  lCustAcc.Enabled := (VatModeType(cmbVatMode.ItemIndex) = vmAdv) and cbLiveExch.Checked;
  lCustName.Enabled := (VatModeType(cmbVatMode.ItemIndex) = vmAdv) and cbLiveExch.Checked;
end;

procedure TFrmSystemSetup.edNoOfTillsExit(Sender: TObject);
begin
  btnTillNames.Enabled := Syss.NoTills = StrToInt(TrimString(psRight,edNoOfTills.Text,' '));
end;

procedure TFrmSystemSetup.SBSUpDown3Click(Sender: TObject;
  Button: TUDBtnType);
begin
  edNoOfTillsExit(Self);
end;

procedure TFrmSystemSetup.pcOptionsChange(Sender: TObject);
begin
  HelpContext := 41 + pcOptions.ActivePageIndex;
end;

procedure TFrmSystemSetup.cbLiveExchClick(Sender: TObject);
begin
  edEntDir.Enabled := cbLiveExch.Checked;
  btnEntBrowse.Enabled := cbLiveExch.Checked;
  cmbVatMode.Enabled := cbLiveExch.Checked;
  edCustAccount.Enabled := (VatModeType(cmbVatMode.ItemIndex) = vmAdv) and cbLiveExch.Checked;
  lCustAcc.Enabled := (VatModeType(cmbVatMode.ItemIndex) = vmAdv) and cbLiveExch.Checked;
  lVATMode.Enabled := cbLiveExch.Checked;
  btnAdditional.Enabled := cbLiveExch.Checked;
  lCustName.Enabled := (VatModeType(cmbVatMode.ItemIndex) = vmAdv) and cbLiveExch.Checked;
  lEntDir.Enabled := cbLiveExch.Checked;
  lVAT.Enabled := cbLiveExch.Checked;
end;

procedure TFrmSystemSetup.cb4mbEpromsClick(Sender: TObject);
begin
  If cb4mbEproms.Checked Then lFirstTrackNo.Caption := IntToStr(MP2StartTrack4Mb)
  else lFirstTrackNo.Caption := IntToStr(MP2StartTrack);

  if StrToInt(edNextTrack.Text) < StrToInt(lFirstTrackNo.Caption)
  then edNextTrack.Text := lFirstTrackNo.Caption;
end;

procedure TFrmSystemSetup.DiscountCheck(Sender: TObject);
begin
  if cb4mbDiscounts.Checked and cbDiscByItem.Checked then begin
    if (MsgBox('You have turned on both 4MB Discounts AND Discounts by Item.'
    + #13#13 + 'Are you sure you want to do this ?' ,mtWarning,[mbYes,mbNo],mbNo,'Discounts Warning') = mrNo)
    then TCheckBox(Sender).Checked := FALSE;
  end;{if}
end;

procedure TFrmSystemSetup.btnAdditionalClick(Sender: TObject);
begin
  frmEnterpriseSetup.ShowModal;
end;

end.


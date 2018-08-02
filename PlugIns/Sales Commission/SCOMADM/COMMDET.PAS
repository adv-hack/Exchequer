unit CommDet;

{ nfrewer440 16:57 09/07/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, StdCtrls, ExtCtrls, ComCtrls, TEditVal, VarConst, Enterprise01_TLB
  , StrUtil, TKPickList, SComProc, Globvar, APIUtil, BtrvU2, MiscUtil, MathUtil
  , BTUtil, Menus, uSettings, Key;

type
  TFrmCommissionDetails = class(TForm)
    lProductGroup: TLabel;
    edProductGroup: TEdit;
    lQtyFrom: TLabel;
    lQtyTo: TLabel;
    lCurrency: TLabel;
    Bevel1: TBevel;
    lStartDate: TLabel;
    lEndDate: TLabel;
    btnCancel: TButton;
    btnOK: TButton;
    Label3: TLabel;
    lCustCode: TLabel;
    edCustCode: TEdit;
    cmbBasedOn: TComboBox;
    btnFindCustomer: TButton;
    btnFindProductGroup: TButton;
    edStartDate: TDateTimePicker;
    edEndDate: TDateTimePicker;
    cmbCurrency: TComboBox;
    edQtyFrom: TCurrencyEdit;
    edQtyTo: TCurrencyEdit;
    lCustName: TLabel;
    lProductGroupName: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    rbMargin: TRadioButton;
    rbValue: TRadioButton;
    edCommission: TCurrencyEdit;
    cmbCommissionType: TComboBox;
    Bevel2: TBevel;
    cbQuantityBased: TCheckBox;
    cbByDate: TCheckBox;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Label4: TLabel;
    Bevel5: TBevel;
    cbCurrencyBased: TCheckBox;
    Bevel6: TBevel;
    Label1: TLabel;
    Bevel8: TBevel;
    Bevel7: TBevel;
    shCustCodeLeft: TShape;
    shProdLeft: TShape;
    shProdBottom: TShape;
    shCustCodeBottom: TShape;
    pmMain: TPopupMenu;
    Properties1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    procedure btnCancelClick(Sender: TObject);
    procedure cmbBasedOnChange(Sender: TObject);
    procedure edCustCodeChange(Sender: TObject);
    procedure edCustCodeExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edProductGroupChange(Sender: TObject);
    procedure btnFindCustomerClick(Sender: TObject);
    procedure btnFindProductGroupClick(Sender: TObject);
    procedure edProductGroupExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbByDateClick(Sender: TObject);
    procedure cbQuantityBasedClick(Sender: TObject);
    procedure cbCurrencyBasedClick(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    bRestore : boolean;
    procedure EnableDisable;
    procedure Comm2Form;
    procedure Form2Comm;
    procedure LoadAllSettings;
    procedure SaveAllSettings;
  public
    sSCFolioFNK : string;
    iRecPos : longint;
    FormMode : TFormMode;
    CommissionDetails : TCommissionRec;
  end;

var
  FrmCommissionDetails: TFrmCommissionDetails;

implementation

{$R *.dfm}

procedure TFrmCommissionDetails.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmCommissionDetails.cmbBasedOnChange(Sender: TObject);
var
  CommissionType : TCommissionType;
begin
  EnableDisable;

  CommissionType := TCommissionType(cmbBasedOn.ItemIndex);
  shCustCodeLeft.Visible := CommissionType in [ctCustomerProduct, ctCustomerPGroup, ctCustomer];
  shCustCodeBottom.Visible := shCustCodeLeft.Visible;
  shProdLeft.Visible := CommissionType in [ctCustomerProduct, ctCustomerPGroup, ctProduct, ctPGroup];
  shProdBottom.Visible := shProdLeft.Visible;

  edProductGroupChange(edProductGroup);
end;

procedure TFrmCommissionDetails.EnableDisable;
var
  CommissionType : TCommissionType;
begin
  CommissionType := TCommissionType(cmbBasedOn.ItemIndex);

  case CommissionType of
    ctCustomerProduct, ctProduct : lProductGroup.Caption := 'Product';
    ctCustomerPGroup, ctPGroup : lProductGroup.Caption := 'Product Group';
  end;

  lCustCode.Enabled := CommissionType in [ctCustomer, ctCustomerProduct, ctCustomerPGroup];
  edCustCode.Enabled := lCustCode.Enabled;
  btnFindCustomer.Enabled := lCustCode.Enabled;
  lCustName.Enabled := lCustCode.Enabled;

  lProductGroup.Enabled := CommissionType in [ctPGroup, ctProduct, ctCustomerProduct, ctCustomerPGroup];
  edProductGroup.Enabled := lProductGroup.Enabled;
  btnFindProductGroup.Enabled := lProductGroup.Enabled;
  lProductGroupName.Enabled := lProductGroup.Enabled;
end;

procedure TFrmCommissionDetails.edCustCodeChange(Sender: TObject);
begin
  with oToolkit.Customer do begin
    Index := acIdxCode;
    if GetEqual(BuildCodeIndex(edCustCode.text)) = 0
    then lCustName.Caption := acCompany
    else lCustName.Caption := '';
    EnableDisable;
  end;{with}
end;

procedure TFrmCommissionDetails.edCustCodeExit(Sender: TObject);
begin
  edCustCode.text := UpperCase(edCustCode.text);
end;

procedure TFrmCommissionDetails.FormShow(Sender: TObject);
begin
  bRestore := FALSE;
  Comm2Form;
  cmbBasedOnChange(cmbBasedOn);
end;

procedure TFrmCommissionDetails.Comm2Form;
begin
  with CommissionDetails do begin
    cmbBasedOn.ItemIndex := cmBy;
    edCustCode.Text := cmCustCode;
    edCustCodeChange(edCustCode);

    case TCommissionType(cmBy) of
      ctCustomerProduct, ctProduct : edProductGroup.Text := cmProductCode;
      ctCustomerPGroup, ctPGroup : edProductGroup.Text := cmPGroupCode;
    end;{case}
    edProductGroupChange(edProductGroup);

    cbQuantityBased.checked := cmByQty;
    edQtyFrom.Value := cmQtyFrom;
    edQtyTo.Value := cmQtyTo;

    cbCurrencyBased.checked := cmByCurrency;
    cmbCurrency.ItemIndex := cmCurrency - 1;
    if cmbCurrency.ItemIndex = -1 then cmbCurrency.ItemIndex := 0;

    cbByDate.checked := cmByDate;
    edStartDate.Date := Str8ToDate(cmStartDate);
    edEndDate.Date := Str8ToDate(cmEndDate);

    case cmCommissionBasis of
      0 : rbValue.Checked := TRUE;
      1 : rbMargin.Checked := TRUE;
    end;{case}
    edCommission.Text := FloatToStrF(cmCommission, ffFixed, 15, oToolkit.SystemSetup.ssSalesDecimals);
    cmbCommissionType.ItemIndex := cmCommissionType;
  end;{with}
end;

procedure TFrmCommissionDetails.Form2Comm;
begin
  with CommissionDetails do begin
    cmBy := cmbBasedOn.ItemIndex;
    cmCustCode := PadString(psRight,Trim(edCustCode.Text),' ',SizeOf(cmCustCode) -1);

    case TCommissionType(cmBy) of
      ctCustomerProduct, ctProduct : begin
        cmProductCode := PadString(psRight,Trim(edProductGroup.Text),' ',SizeOf(cmProductCode) -1);
        cmPGroupCode := StringOfChar(' ',SizeOf(cmPGroupCode) -1);
      end;

      ctCustomerPGroup, ctPGroup : begin
        cmProductCode := StringOfChar(' ',SizeOf(cmProductCode) -1);
        cmPGroupCode := PadString(psRight,Trim(edProductGroup.Text),' ',SizeOf(cmPGroupCode) -1);
      end;

      ctCustomer : begin
        cmProductCode := StringOfChar(' ',SizeOf(cmProductCode) -1);
        cmPGroupCode := StringOfChar(' ',SizeOf(cmPGroupCode) -1);
      end;

    end;{case}

    cmByQty := cbQuantityBased.Checked;
    cmQtyFrom := StrToFloatDef(edQtyFrom.Text, 0);
    cmQtyTo := StrToFloatDef(edQtyTo.Text, 0);

    cmByCurrency := cbCurrencyBased.checked;
    cmCurrency := cmbCurrency.ItemIndex + 1;

    cmByDate := cbByDate.Checked;
    cmStartDate := DateToStr8(edStartDate.Date);
    cmEndDate := DateToStr8(edEndDate.Date);

    cmCommission := StrToFloatDef(edCommission.Text, 0);
    cmCommissionType := cmbCommissionType.ItemIndex;

    if rbValue.Checked then cmCommissionBasis := 0;
    if rbMargin.Checked then cmCommissionBasis := 1;

    cmDummyChar := IDX_DUMMY_CHAR;
  end;{with}
end;

procedure TFrmCommissionDetails.edProductGroupChange(Sender: TObject);
begin
  lProductGroupName.Caption := '';
  with oToolkit.Stock do begin
    Index := stIdxCode;
    if GetEqual(BuildCodeIndex(edProductGroup.text)) = 0
    then begin
      if ((TCommissionType(cmbBasedOn.ItemIndex) in [ctCustomerProduct, ctProduct])
      and (stType in [stTypeProduct, stTypeDescription, stTypeBillOfMaterials]))
      or ((TCommissionType(cmbBasedOn.ItemIndex) in [ctCustomerPGroup, ctPGroup])
      and (stType = stTypeGroup))
      then lProductGroupName.Caption := stDesc[1];
    end
  end;{with}
  EnableDisable;
end;

procedure TFrmCommissionDetails.btnFindCustomerClick(Sender: TObject);
var
  oCust : IAccount;
begin
  with TfrmTKPickList.CreateWith(self, oToolkit) do begin
    plType := plCustomer;
    sFind := edCustCode.Text;
    iSearchCol := 0;
    mlList.Columns[1].IndexNo := 1;
    if showmodal = mrOK then begin
      oCust := ctkDataSet.GetRecord as IAccount;
      edCustCode.Text := oCust.acCode;
    end;{if}
    release;
  end;{with}
end;

procedure TFrmCommissionDetails.btnFindProductGroupClick(Sender: TObject);
var
  oStock : IStock;
begin
  with TfrmTKPickList.CreateWith(self, oToolkit) do begin
    case TCommissionType(cmbBasedOn.ItemIndex) of
      ctCustomerProduct, ctProduct : plType := plProduct;
      ctCustomerPGroup, ctPGroup : plType := plProductGroup;
    end;{case}
    sFind := edProductGroup.Text;
    iSearchCol := 0;
    mlList.DesignColumns[1].IndexNo := 3;
    if showmodal = mrOK then begin
      oStock := ctkDataSet.GetRecord as IStock;
      edProductGroup.Text := oStock.stCode;
    end;{if}
    release;
  end;{with}
end;

procedure TFrmCommissionDetails.edProductGroupExit(Sender: TObject);
begin
  edProductGroup.text := UpperCase(edProductGroup.text);
end;

procedure TFrmCommissionDetails.FormCreate(Sender: TObject);
begin
  LoadAllSettings;
  edCommission.displayformat := '######0.' + StringOfChar('#', oToolkit.SystemSetup.ssSalesDecimals);
  edQtyFrom.displayformat := '####0.' + StringOfChar('#', oToolkit.SystemSetup.ssQtyDecimals);
  edQtyTo.displayformat := edQtyFrom.displayformat;
  FillCurrencyCombo(cmbCurrency);
end;

procedure TFrmCommissionDetails.btnOKClick(Sender: TObject);
var
  KeyS : Str255;
//  LCommissionRec : TCommissionRec;
  iStatus : integer;

  function ValidateRecord : boolean;
  var
    sError : string;
    CommissionType : TCommissionType;

    function ValidateCustomer : string;
    begin{ValidateCustomer}
      Result := '';
      if (CommissionType in [ctCustomerProduct, ctCustomerPGroup, ctCustomer])
      and (lCustName.caption = '') then begin
        Result := 'Customer';
        edCustCode.Text := '';
        ActiveControl := edCustCode;
      end;{if}
    end;{ValidateCustomer}

    function ValidateProductGroup : string;
    begin{ValidateCustomer}
      Result := '';
      if (CommissionType in [ctCustomerProduct, ctProduct, ctCustomerPGroup, ctPGroup])
      and (lProductGroupName.caption = '') then begin
        Case CommissionType of
          ctCustomerProduct, ctProduct : Result := 'Product';
          ctCustomerPGroup, ctPGroup : Result := 'Product Group';
        end;{case}
        edProductGroup.Text := '';
        ActiveControl := edProductGroup;
      end;{if}
    end;{ValidateCustomer}

  begin{ValidateRecord}

    CommissionType := TCommissionType(cmbBasedOn.ItemIndex);

    sError := ValidateCustomer;

    if sError = '' then begin
      sError := ValidateProductGroup;
      if sError = '' then begin

        // Validate Quantity
        if cbQuantityBased.checked
        and (((StrToFloatDef(edQtyTo.Text, 0) - StrToFloatDef(edQtyFrom.Text, 0)) < 0)
        or ((StrToFloatDef(edQtyTo.Text, 0) = 0) and (StrToFloatDef(edQtyFrom.Text, 0) = 0))) then
        begin
          sError := 'Quantity From';
          ActiveControl := edQtyFrom;
        end else
        begin
          // Validate Currency
          if cbCurrencyBased.checked and (cmbCurrency.ItemIndex = -1) then
          begin
            sError := 'Currency';
            ActiveControl := cmbCurrency;
          end else
          begin
            // Validate Date Range
            if cbByDate.checked
            and (edEndDate.Date - edStartDate.Date < 0) then
            begin
              sError := 'Start Date';
              ActiveControl := edStartDate;
            end else
            begin
              if ZeroFloat(StrToFloat(edCommission.Text)) then
              begin
                sError := 'Commission';
                ActiveControl := edCommission;
              end;
            end;
          end;{if}
        end;{if}
      end;{if}
    end;{if}

    if sError <> '' then begin
      MsgBox('You have entered an invalid value in the following field : '
      + #13#13 + sError, mtError,[mbOK],mbOK,'Validation Error');
    end;{if}

    Result := sError = '';
  end;{ValidateRecord}

  function RecordClashes : boolean;
  var
    MatchKeyS, KeyS : str255;
    CommissionRec : TCommissionRec;
    iStatus : integer;

    function RecordMatches : boolean;
    begin{RecordMatches}
      Result := MatchKeyS = BTFullNomKey(CommissionRec.cmSalesCodeFolioNo)
      + BTFullNomKey(CommissionRec.cmBy) + CommissionRec.cmCustCode
      + CommissionRec.cmProductCode + CommissionRec.cmPGroupCode
    end;{RecordMatches}

    function TheseRecordsClash(Comm1, Comm2 : TCommissionRec) : boolean;
    begin{TheseRecordsClash}
      if (FormMode = fmEdit) and (Comm1.cmFolioNo = Comm2.cmFolioNo)
      then Result := FALSE
      else begin
        if ((Comm2.cmByCurrency) and (Comm1.cmByCurrency)
        and (Comm1.cmCurrency = Comm2.cmCurrency))
        or ((not Comm2.cmByCurrency) and (not Comm1.cmByCurrency)) then begin
        {or (not Comm1.cmByCurrency) or (not Comm2.cmByCurrency)}
          // currency part overlaps
          if not Comm1.cmByQty then begin
            Comm1.cmQtyFrom := 1;
            Comm1.cmQtyTo := 999999999999999999;
          end;
          if not Comm2.cmByQty then begin
            Comm2.cmQtyFrom := 1;
            Comm2.cmQtyTo := 999999999999999999;
          end;

          if ((Comm1.cmQtyFrom <= Comm2.cmQtyTo) and (Comm1.cmQtyFrom >= Comm2.cmQtyFrom))
          or ((Comm1.cmQtyTo <= Comm2.cmQtyTo) and (Comm1.cmQtyTo >= Comm2.cmQtyFrom))
          or ((Comm2.cmQtyFrom <= Comm1.cmQtyTo) and (Comm2.cmQtyFrom >= Comm1.cmQtyFrom))
          or ((Comm2.cmQtyTo <= Comm1.cmQtyTo) and (Comm2.cmQtyTo >= Comm1.cmQtyFrom))
          then begin
            // Qty part overlaps
            if not Comm1.cmByDate then begin
              Comm1.cmStartDate := '19800101';
              Comm1.cmEndDate := '30000101';
            end;
            if not Comm2.cmByDate then begin
              Comm2.cmStartDate := '19800101';
              Comm2.cmEndDate := '30000101';
            end;

            if ((Comm1.cmStartDate <= Comm2.cmEndDate) and (Comm1.cmStartDate >= Comm2.cmStartDate))
            or ((Comm1.cmEndDate <= Comm2.cmEndDate) and (Comm1.cmEndDate >= Comm2.cmStartDate))
            or ((Comm2.cmStartDate <= Comm1.cmEndDate) and (Comm2.cmStartDate >= Comm1.cmStartDate))
            or ((Comm2.cmEndDate <= Comm1.cmEndDate) and (Comm2.cmEndDate >= Comm1.cmStartDate))
            then Result := TRUE; // date part also overlaps
          end;{if}
        end;{if}
      end;
    end;{TheseRecordsClash}

  begin{RecordClashes}
    Result := FALSE;

    MatchKeyS := sSCFolioFNK + BTFullNomKey(CommissionDetails.cmBy) + CommissionDetails.cmCustCode
    + CommissionDetails.cmProductCode + CommissionDetails.cmPGroupCode;
    KeyS := MatchKeyS;
    iStatus := Find_Rec(B_GetEq, F[CommissionF], CommissionF, CommissionRec, cmSalesCodeIdx, KeyS);

    while (iStatus = 0) and RecordMatches and (Result = FALSE) do begin
      if TheseRecordsClash(CommissionDetails, CommissionRec) then Result := TRUE;
      iStatus := Find_Rec(B_GetNext, F[CommissionF], CommissionF, CommissionRec, cmSalesCodeIdx, KeyS);
    end;

    if Result = TRUE then MsgBox('This commission record clashes with another existing commission record and cannot be saved.'
    ,mtInformation,[mbOK],mbOK,'Overlapping Records');
  end;{RecordClashes}

begin{btnOKClick}
  if ValidateRecord then begin

    Case FormMode of
      fmAdd : begin
//        FillChar(CommissionDetails,SizeOf(CommissionDetails),#0);
        Form2Comm;
        CommissionDetails.cmFolioNo := GetNextFolio(CommissionF);
        if not RecordClashes then begin
          iStatus := Add_Rec(F[CommissionF], CommissionF, CommissionDetails, cmSalesCodeIdx);
  //        if iStatus = 5 then MsgBox('You already have a Commission Record with the same values'
  //        , mtInformation, [mbOK], mbOK, 'Duplicate Commission Record')
  //        else ShowBTError(iStatus, 'Add_Rec', FileNames[CommissionF]);
          ShowBTError(iStatus, 'Add_Rec', FileNames[CommissionF]);
        end;{if}
      end;

      fmEdit : begin

        // Get Commision Record
        move(iRecPos,CommissionDetails,sizeof(iRecPos));
        iStatus := GetDirect(F[CommissionF], CommissionF, CommissionDetails, cmSalesCodeIdx, 0);
        if iStatus = 0 then begin
          Form2Comm;
          if not RecordClashes then begin
            move(iRecPos,CommissionDetails,sizeof(iRecPos));
            iStatus := GetDirect(F[CommissionF], CommissionF, CommissionDetails, cmSalesCodeIdx, 0);
            if iStatus = 0 then begin
              Form2Comm;
              iStatus := Put_Rec(F[CommissionF], CommissionF, CommissionDetails, cmSalesCodeIdx);
              ShowBTError(iStatus, 'Put_Rec', FileNames[CommissionF]);
            end;{if}
          end;{if}
        end;{if}

//        LCommissionRec := TCommissionRec(bdsCommissions.GetRecord^);

        // get record with the new code
(*        KeyS := PadString(psRight,edCommission.Text,' ',10);
        iStatus := Find_Rec(B_GetEq, F[CommissionF], CommissionF, CommissionRec, cmSalesCodeIdx, KeyS);
        if (iStatus = 0) and (CommissionRec.scFolioNo <> LCommissionRec.scFolioNo) then
          begin
            MsgBox('You already have a Sales Code with the given code'
            , mtInformation, [mbOK], mbOK, 'Duplicate Sales Code');
            iStatus := 5;
          end
        else begin
          // get original record
          KeyS := mlCommissions.FullNomKey(LCommissionRec.scFolioNo) + IDX_DUMMY_CHAR;
          iStatus := Find_Rec(B_GetEq, F[CommissionF], CommissionF, CommissionRec, cmSalesCodeIdx, KeyS);
          if iStatus = 0 then
            begin
              // store update to record
              Screen2Commission(CommissionRec);
              iStatus := Put_Rec(F[CommissionF], CommissionF, CommissionRec, cmSalesCodeIdx);
              ShowBTError(iStatus, 'Put_Rec', FileNames[CommissionF]);
            end
          else ShowBTError(iStatus, 'Find_Rec', FileNames[CommissionF]);
        end;*)
      end;

    end;{case}

    if iStatus = 0 then ModalResult := mrOK;

//      mlCommissions.SortColumn(0, TRUE);
//      mlCommissions.SearchColumn(0, TRUE, Trim(CommissionRec.scCommission));
//    end;{if}
  end;{if}
end;

procedure TFrmCommissionDetails.cbByDateClick(Sender: TObject);
begin
  lStartDate.Enabled := cbByDate.Checked;
  edStartDate.Enabled := lStartDate.Enabled;
  lEndDate.Enabled := lStartDate.Enabled;
  edEndDate.Enabled := lStartDate.Enabled;
end;

procedure TFrmCommissionDetails.cbQuantityBasedClick(Sender: TObject);
begin
  lQtyFrom.Enabled := cbQuantityBased.Checked;
  edQtyFrom.Enabled := lQtyFrom.Enabled;
  lQtyTo.Enabled := lQtyFrom.Enabled;
  edQtyTo.Enabled := lQtyFrom.Enabled;
end;

procedure TFrmCommissionDetails.cbCurrencyBasedClick(Sender: TObject);
begin
  lCurrency.Enabled := cbCurrencyBased.Checked;
  cmbCurrency.Enabled := lCurrency.Enabled;
end;

procedure TFrmCommissionDetails.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(nil, Self.Name, cmbBasedOn) of
    mrOK : oSettings.ColorFieldsFrom(cmbBasedOn, Self);
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TFrmCommissionDetails.LoadAllSettings;
begin
  oSettings.LoadForm(Self);
  oSettings.LoadParentToControl(Self.Name, Self.Name, cmbBasedOn);
  oSettings.ColorFieldsFrom(cmbBasedOn, Self);
end;

procedure TFrmCommissionDetails.SaveAllSettings;
begin
  oSettings.SaveParentFromControl(cmbBasedOn, Self.Name);
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
end;

procedure TFrmCommissionDetails.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
end;

procedure TFrmCommissionDetails.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TFrmCommissionDetails.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

end.

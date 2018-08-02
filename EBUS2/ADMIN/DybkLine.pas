unit Dybkline;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ComCtrls, ExtCtrls, SBSPanel, Buttons, BorBtns,
  eBusCnst, EntUtil, BTSupU1, GlobVar,VarConst, AdmUtl2;

type
  TfrmTransactionLine = class(TForm)
    PageControl1: TPageControl;
    tabMain: TTabSheet;
    pnlLeft: TSBSPanel;
    Id3SCodeLab: Label8;
    edtStockCode: Text8Pt;
    sbxStockDesc: TScrollBox;
    edtDesc1: Text8Pt;
    edtDesc2: Text8Pt;
    edtDesc3: Text8Pt;
    edtDesc4: Text8Pt;
    edtDesc5: Text8Pt;
    edtPackQty: TCurrencyEdit;
    edtQty: TCurrencyEdit;
    edtUnitPrice: TCurrencyEdit;
    edtTotal: TCurrencyEdit;
    edtLocCode: Text8Pt;
    edtDesc6: Text8Pt;
    edtDiscount: Text8Pt;
    lblLocation: Label8;
    pnlMiddle: TSBSPanel;
    Id3PQLab: Label8;
    Id3QtyLab: Label8;
    Id3UPLab: Label8;
    Id3DiscLab: Label8;
    Id3LTotLab: Label8;
    pnlRight: TSBSPanel;
    edtDelDate: TEditDate;
    cbxLineType: TSBSComboBox;
    edtCost: TCurrencyEdit;
    Id3CostLab: Label8;
    Label83: Label8;
    DelDateLab: Label8;
    edtNomCodeDesc: Text8Pt;
    edtNomCode: Text8Pt;
    Label85: Label8;
    cbxVAT: TSBSComboBox;
    lblVATCCDep: Label8;
    edtCCCode: Text8Pt;
    edtDepCode: Text8Pt;
    edtJobAnalysis: Text8Pt;
    edtJobCode: Text8Pt;
    lblJobCode: Label8;
    lblJobAnalysis: Label8;
    btnOK: TButton;
    btnCancel: TButton;
    edtMultiBuy: Text8Pt;
    edtTransDiscount: Text8Pt;
    Label81: Label8;
    Label82: Label8;
    Label87: Label8;
    pgIntrastat: TTabSheet;
    lblIntrastatInstructions: TLabel;
    lblCommodityCode: TLabel;
    chkOverrideIntrastat: TCheckBox;
    edtCommodityCode: TMaskEdit;
    edtStockUnits: TCurrencyEdit;
    lblStockUnits: TLabel;
    lblLineUnitWeight: TLabel;
    edtLineUnitWeight: TCurrencyEdit;
    lblGoodsToCountry: TLabel;
    chkCountry: TRadioButton;
    chkQRCode: TRadioButton;
    cbIntrastatCountry: TSBSComboBox;
    cbNoTc: TSBSComboBox;
    lblNoTc: TLabel;
    lblSSDUplift: TLabel;
    edtSSDUplift: TCurrencyEdit;
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtLocCodeExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtCCCodeExit(Sender: TObject);
    procedure edtDepCodeExit(Sender: TObject);
    procedure edtNomCodeExit(Sender: TObject);
    procedure edtJobCodeExit(Sender: TObject);
    procedure edtJobAnalysisExit(Sender: TObject);
    procedure edtStockCodeExit(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure sbxStockDescExit(Sender: TObject);
    procedure edtDiscountExit(Sender: TObject);
    procedure btnShowIntrastatClick(Sender: TObject);
    procedure edtDesc1Exit(Sender: TObject);
    procedure edtPackQtyExit(Sender: TObject);
    procedure edtUnitPriceExit(Sender: TObject);
    procedure edtQtyExit(Sender: TObject);
    procedure cbxVATExit(Sender: TObject);
    procedure edtCostExit(Sender: TObject);
    procedure edtDelDateExit(Sender: TObject);
    procedure cbxLineTypeExit(Sender: TObject);
    procedure edtDescLineEnter(Sender: TObject);
    procedure edtDescLineExit(Sender: TObject);
    procedure edtDiscountEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chkOverrideIntrastatClick(Sender: TObject);
    procedure EnableIntrastatFields(Enable : Boolean);
    procedure chkCountryClick(Sender: TObject);
    procedure chkQRCodeClick(Sender: TObject);
  private
    ExLocal   : ^TExLocalEBus;
    fEditMode : TFormActivate;

    LineDesc     :  TLineDesc;

    fDoingClose,
    fLineChanged : boolean;
    OriginalDescLineCount : integer; // Total number of original description lines
    CurDescLine,
    CurDiscLine : string;
    // Main transaction line i.e. with all the quantity & price details,
    // updated continuously with editing of the screen
    FirstLine : IDetail;
    function  IsNarrativeOnly : boolean;
    Function Link2Stock(SCode    :  str20)  :  Boolean;

    Procedure Form2Desc;
    Procedure OutDesc;
    procedure PosRecord(Fnum,KeyPath  :  Integer);

    procedure CloseForm;

    function  NewDescLineCount : integer;
    function  ValidateValues : boolean;
    procedure UpdateLineTotal(UseDefaults : boolean);
    procedure DeleteExistingLines;
    procedure RenumberOriginalLines;
    procedure UpdateLineValues;
    procedure AddNewLines;
    procedure UpdateTransactionHeader;
    procedure SetDiscountDisplay(const WhichEdit : TExt8pt; Discount : double; DiscChar : char);
    procedure ReadTransactionLine;
    procedure InitialiseDatabase;
    procedure InitialiseFirstLine;
    procedure InitialiseScreen;
    procedure PopulateScreen;
    procedure EnableEditing;
    procedure StoreId(Fnum,KeyPath  :  Integer);
    procedure SetMasks;

    //PR: 01/02/2016 ABSEXCH-17116 v2016 R1
    procedure PopulateIntrastatLists;
    function CheckCust : CustRec;  //Gets CustRec for current customer
    function CheckStock : StockRec; //Gets StockRec for current stock code

    //PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Intrastat defaults
    procedure IntrastatToLine;

    //PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Copy intrastat fields from line to form
    procedure LineIntrastatToForm;

    //PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Copy fields from form to line if override checked
    procedure FormIntrastatToLine;
  public
    HeaderRec : ^InvRec;
    procedure InitialiseForm(EditMode : TFormActivate);
  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{$R *.DFM}

uses
  AdmnUtil, EBusUtil, StrUtil, UseDLLU, UseTKit,
  eBusVar, BtrvU2,BTKeys1U, ETStrU,IntStatL, SysU2,ComnU2, XMLUtil, MathUtil, MiscU,
  DybkTrns, BTSupU2, InvFSU3U, EntLkup,

  IntrastatXML,
  CountryCodes,
  CountryCodeUtils;

//-----------------------------------------------------------------------
Procedure UpdateRecBal(IdR      :  IDetail;
                   Var LInv     :  InvRec;
                       Deduct,
                       Disp     :  Boolean;
                       Mode     :  Byte);


Var
  LineTotal,
  WithDiscVal,
  DiscLineTotal,
  LineCost       :  Real;

  DecCnst        :  Integer;


Begin

  LineTotal:=0;
  LineCost:=0;

  DiscLineTotal:=0;
  WithDiscVal:=0;

  If (Deduct) then
    DecCnst:=-1
  else
    DecCnst:=1;


  With LInv do
    Case Mode of

      0..9  :  Begin

                 WithDiscVal:=InvNetVal-DiscAmount;

                 LineTotal:=(Ex_RoundUp(GetLineTotal(IdR,BOff,0),2)*DecCnst);

                 InvNetVal:=InvNetVal+LineTotal;

                 DiscLineTotal:=(Ex_RoundUp(GetLineTotal(IdR,BOn,0),2)*DecCnst);

                 WithDiscVal:=WithDiscVal+DiscLineTotal;

                 InvVAT:=InvVAT+(IdR.VAT*DecCnst);

                 DiscAmount:=Ex_RoundUp(InvNetVal-WithDiscVal,2);   {* v1.35 *}

                 DiscSetAm:=Ex_RoundUp(Calc_PAmount((InvNetVal-DiscAmount),DiscSetl,PcntChr),2);

                 With IdR do
                   LineCost:=InvLCost(IdR)*DecCnst;

                 TotalCost:=TotalCost+LineCost;


               end;

    end; {Case..}

  {If (Disp) then EX32. display new rquired..
    OutInvReq(Mode);}
end;


procedure TfrmTransactionLine.PopulateScreen;
// Notes : Assigns
var
  VATIndex : integer;
begin
  with FirstLine do
  begin
    edtStockCode.Text := Trim(StockCode);
    edtDesc1.Text := Desc;
    edtLocCode.Text := MLocStk;
    edtPackQty.Value := QtyMul;
    edtQty.Value := Qty;
    edtUnitPrice.Value := NetValue;
    SetDiscountDisplay(edtDiscount, Discount, DiscountChr);
    SetDiscountDisplay(edtMultiBuy, Discount2, Discount2Chr);
    SetDiscountDisplay(edtTransDiscount, Discount3, Discount3Chr);
    edtTotal.Value := GetLineTotal(FirstLine, true, {HeaderRec^.DiscSetl}0);
    edtJobCode.Text := JobCode;
    edtJobAnalysis.Text := AnalCode;
    edtCCCode.Text := CCDep[true];   // CC
    edtDepCode.Text := CCDep[false]; // Dept
    edtNomCode.Text := IntToStr(NomCode);
    edtNomCodeDesc.Text := GetNomDescription(StrToInt(edtNomCode.Text));
    VATIndex := ord(VATCodeToVATType(VATCode));
    if (VATIndex >= 0) and (VATIndex < cbxVAT.Items.Count) then
      cbxVAT.ItemIndex := VATIndex;
    if ExLocal^.LStock.PricePack and ExLocal^.LStock.DPackQty then
      edtCost.Value := CostPrice * ExLocal^.LStock.BuyUnit
    else
      edtCost.Value := CostPrice;

    cbxLineType.ItemIndex := DocLTLink;
    edtDelDate.Text := LongDateToDateField(PDate);
  end;

  if Syss.Intrastat and (CheckCust.EECMember) then
  begin
    lblSSDUplift.Visible := (CurrentCountry = IECCode);
    edtSSDUplift.Visible := (CurrentCountry = IECCode);

    PopulateIntrastatLists;
    if ExLocal.LId.IdDocHed in SalesSplit then
      lblGoodsToCountry.Caption := 'Goods to Country'
    else
      lblGoodsToCountry.Caption := 'Goods from Country';

    //Default values from Stock & Account
    IntrastatToLine;
    LineIntrastatToForm;
  end
  else
  begin
    //Hide intrstat tab
    pgIntrastat.Visible := False;
    pgIntrastat.TabVisible := False;
  end;

end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.InitialiseScreen;
var
  i : integer;
  JCEnabled : boolean;
begin
  // Whether to show cost centres, departments and locations at bottom of form
  edtCCCode.Visible := CurCompSettings.CCDepEnabled;
  edtDepCode.Visible := CurCompSettings.CCDepEnabled;
  if not CurCompSettings.CCDepEnabled then
    lblVATCCDep.Caption := 'VAT';
  edtLocCode.Visible := CurCompSettings.MultiLocEnabled;
  lblLocation.Visible := CurCompSettings.MultiLocEnabled;

  // Whether to show job costing labels and edit boxes
  JCEnabled := JobCostingEnabled; // Read licence file once
  lblJobCode.Visible := JCEnabled;
  lblJobAnalysis.Visible := JCEnabled;
  edtJobCode.Visible := JCEnabled;
  edtJobAnalysis.Visible := JCEnabled;

  sbxStockDesc.VertScrollBar.Position := 0;

  // Populate Line types
  for i := 0 to 4 do
  begin
    cbxLineType.ItemsL.Add(CurCompSettings.LineTypeDesc[i]);
    cbxLineType.Items.Add(CurCompSettings.LineTypeDesc[i]);
  end;
  // Populate VAT types
  AssignVATItems(cbxVAT.ItemsL, true);
  AssignVATItems(cbxVAT.Items, false);

  // Other initial values
  edtPackQty.Value := 0;
  edtQty.Value := 1;
  edtUnitPrice.Value := 0;
  edtTotal.Value := 0;
  edtCost.Value := 0;
  cbxLineType.ItemIndex := 0;
  cbxVAT.ItemIndex := 0;


    { ========= Assign Desc fields ======== }

  try
    With LineDesc.DescFields do
    Begin
      AddVisiRec(edtDesc2,BOff);
      AddVisiRec(edtDesc3,BOff);
      AddVisiRec(edtDesc4,BOff);
      AddVisiRec(edtDesc5,BOff);
      AddVisiRec(edtDesc6,BOff);
    end; {With..}
  except

    LineDesc.DescFields.Free;
    LineDesc.DescFields:=nil;

  end;{try..}


end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.EnableEditing;
begin
  edtStockCode.ReadOnly := false;
  edtLocCode.ReadOnly := false;
  edtDesc1.ReadOnly := false;
  edtDesc2.ReadOnly := false;
  edtDesc3.ReadOnly := false;
  edtDesc4.ReadOnly := false;
  edtDesc5.ReadOnly := false;
  edtDesc6.ReadOnly := false;
  edtPackQty.ReadOnly := false;
  edtQty.ReadOnly := false;
  edtUnitPrice.ReadOnly := false;
  edtDiscount.ReadOnly := false;
  edtTransDiscount.ReadOnly := false;
  edtMultiBuy.ReadOnly := false;
  edtJobCode.ReadOnly := false;
  edtJobAnalysis.ReadOnly := false;
  cbxVAT.ReadOnly := false;
  edtCCCode.ReadOnly := false;
  edtDepCode.ReadOnly := false;
  edtNomCode.ReadOnly := false;
  edtCost.ReadOnly := false;
  cbxLineType.ReadOnly := false;
  edtDelDate.ReadOnly := false;
//  btnShowIntraStat.Enabled := true;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.PosRecord(Fnum,KeyPath  :  Integer);

Begin

  With ExLocal^ do
  Begin
    LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

    LStatus:=LGetDirect(Fnum,KeyPAth,0); {* Re-Establish Position *}

    LReport_BError(Fnum,LStatus);

    LastEdit:=BOn;

    LastID:=LId;

  end;

  OutDesc;
end;



//-----------------------------------------------------------------------

procedure TfrmTransactionLine.InitialiseForm(EditMode : TFormActivate);
begin
  fEditMode := EditMode;
  fLineChanged := false;

  InitialiseScreen;
  InitialiseDatabase;
  case fEditMode of
    actShow   : begin
                  ReadTransactionLine;
                  PosRecord(IDetailF,IdFolioK);
                  PopulateScreen;
                  btnOK.Enabled := false;
                end;
    actEdit   : begin

                  ReadTransactionLine;
                  PosRecord(IDetailF,IdFolioK);
                  PopulateScreen;
                  EnableEditing;
                end;
    actAdd    : begin
                  InitialiseFirstLine;
                  EnableEditing;
                end;
    actInsert : begin
                  InitialiseFirstLine;
                  EnableEditing;
                end;
  end;
end; // TfrmTransactionLine.DisplayForm

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTransactionLine.FormCreate(Sender: TObject);
begin
  fDoingClose:=BOff;

  LineDesc:=TLineDesc.Create;

  try
    With LineDesc do
    Begin
      Fnum:=IDetailF;
      Keypath:=IdFolioK;
    end;
  except

    LineDesc.Free;
    LineDesc:=nil;

  end;
  SetMasks;

end;


//-----------------------------------------------------------------------

procedure TfrmTransactionLine.CloseForm;
var
  LParam : longint;
begin
  If (Not fDoingClose) and  (Not Application.Terminated) then
  Begin
    fDoingClose:=Bon;

    ExLocal^.CloseSelFiles([IDetailF,StockF]);
    dispose(ExLocal, destroy);
    // OK and Cancel buttons have ModalResults assigned, which are irrelevant in the context
    // of an MDI child, but useful to determine which button was pressed.
    if (ModalResult = mrOK) and fLineChanged then
      LParam := FORM_TRANS_LINE_OK
    else
      LParam := FORM_TRANS_LINE_CANCEL;


    If (Assigned(LineDesc)) then
    Begin
      LineDesc.Destroy;
      LineDesc:=nil;
    end;

    SendMessage((Owner as TForm).Handle, WM_CustGetRec, EBUS_FORM_CLOSE, LParam);
  end;
end;


//-----------------------------------------------------------------------

procedure TfrmTransactionLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;

  CloseForm;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.FormDestroy(Sender: TObject);
begin
 //  CloseForm(BOn);  We can't call this here as a close by the parent form causes a GPF.
end;

//-----------------------------------------------------------------------

function TfrmTransactionLine.IsNarrativeOnly: boolean;
begin
  Result := ZeroFloat(FirstLine.NetValue);
end;

//-----------------------------------------------------------------------

Function TfrmTransactionLine.Link2Stock(SCode    :  str20)  :  Boolean;


Begin

  With ExLocal^ do
    If (LStock.StockCode<>Scode) then
      Result:=LGetMainRec(StockF,SCode)
    else
      Result:=True;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.edtStockCodeExit(Sender: TObject);
var
  StockCode : string20;

  procedure UpdateOnStockChange;
  var
    StockRec : TBatchSKRec;
    // StockPrice : TBatchStkPriceRec;
  begin
    if GetStockDetailsFromCode(StockCode, StockRec) = 0 then
      with StockRec do
      begin
        FirstLine.StockCode := StockCode;
        FirstLine.Desc := Desc[1];
        edtDesc2.Text := Desc[2];
        edtDesc3.Text := Desc[3];
        edtDesc4.Text := Desc[4];
        edtDesc5.Text := Desc[5];
        edtDesc6.Text := Desc[6];
        FirstLine.MLocStk := StLocation;
        FirstLine.CCDep[true] := CC;
        FirstLine.CCDep[false] := Dep;
        FirstLine.Qty := 1;
        FirstLine.QtyMul := 1;
        UpdateLineTotal(true);
        if IsPurchaseTransaction(HeaderRec^.OurRef) then
          FirstLine.NomCode := NomCodes[2] // Cost of sales
        else
          FirstLine.NomCode := NomCodes[1]; // Sales nominal
        // Intrastat defaults...
        FirstLine.SSDCommod := CommodCode;
        FirstLine.SSDSPUnit := SuppSUnit;
        if IsPurchaseTransaction(HeaderRec^.OurRef) then
          FirstLine.LWeight := PWeight
        else
          FirstLine.LWeight := SWeight;
        FirstLine.SSDCountry := SSDCountry;
        FirstLine.SSDUplift := SSDDUplift;

        PopulateScreen;
      end;
  end;

begin // TfrmTransactionLine.edtStockCodeExit
  if (ActiveControl <> btnCancel) and (fEditMode <> actShow) then
  begin
    if (Trim (edtStockCode.Text) <> Trim(FirstLine.StockCode)) and (Trim (edtStockCode.Text) <> '') then
    begin
      fLineChanged := true;
      FirstLine.StockCode := edtStockCode.Text;
    end;
    if (edtStockCode.Text <> '') and fLineChanged then
    begin
      fLineChanged := true;
      StockCode := edtStockCode.Text;

      if DoGetStock(self, CurCompSettings.CompanyPath, StockCode, StockCode,
        [stkProduct, stkBOM], vmCheckValue, true) then
      begin
        if FirstLine.StockCode <> StockCode then
          UpdateOnStockChange;
      end
      else
        if DoGetStock(self, CurCompSettings.CompanyPath, StockCode, StockCode,
          [stkProduct, stkBOM], vmShowList, true) then
        begin
          edtStockCode.Text := StockCode;
          UpdateOnStockChange;
        end
        else
          edtStockCode.SetFocus;
    end;
  end;
end; // TfrmTransactionLine.edtStockCodeExit

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.edtLocCodeExit(Sender: TObject);
var
  LocationCode : string10;
  AltMod       : Boolean;
  Foundcode    : AnsiString;

  procedure AssignLocation(const Value : string);
  begin
    edtLocCode.Text := Value;
    FirstLine.MLocStk := StringOfChar(' ', 3); // Blank fully for index purposes
    FirstLine.MLocStk := Value;
    fLineChanged := true;
  end;

begin
  If (Sender is Text8Pt) then
  With Text8pt(Sender) do
  Begin
    AltMod:=Modified;
    Foundcode:=Trim(Text);

    if (ActiveControl <> btnCancel) and (fEditMode <> actShow) and
      ((AltMod) or (FoundCode='')) then
    Begin
      flineChanged:=True;

      if Trim(FirstLine.StockCode) = '' then
        AssignLocation('') // No stock code so location not meaningful
      else
      begin // Stock code entered
        Text := Trim(Text);
        LocationCode := Text;
        if DoGetMLoc(self, CurCompSettings.CompanyPath, LocationCode, LocationCode,
          vmShowList, true) then
          AssignLocation(LocationCode)
        else
          SetFocus;
      end;
    end; {If..}
  end; {With..}
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.edtDesc1Exit(Sender: TObject);
begin
  if (FirstLine.Desc <> Trim(edtDesc1.Text)) then
  begin
    fLineChanged := true;
    FirstLine.Desc := Trim(edtDesc1.Text);
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.edtPackQtyExit(Sender: TObject);
begin
  if not ZeroFloat(abs(FirstLine.QtyMul - edtPackQty.Value)) then
  begin
    fLineChanged := true;
    FirstLine.QtyMul := edtPackQty.Value;
    UpdateLineTotal(false);
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.edtQtyExit(Sender: TObject);
begin
  if not ZeroFloat(abs(FirstLine.Qty - edtQty.Value)) then
  begin
    fLineChanged := true;
    FirstLine.Qty := edtQty.Value;
    UpdateLineTotal(false);
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.edtUnitPriceExit(Sender: TObject);
begin
  if not ZeroFloat(abs(FirstLine.NetValue - edtUnitPrice.Value)) then
  begin
    fLineChanged := true;
    FirstLine.NetValue := edtUnitPrice.Value;
    UpdateLineTotal(false);
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.edtDiscountEnter(Sender: TObject);
begin
  if Sender is TExt8pt then
    with Sender as TExt8pt do
     CurDiscLine := Text;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.edtDiscountExit(Sender: TObject);
var
  Disc : Real48;
  DiscChr : Char;
begin
  if Sender is TExt8pt then
    with Sender as TExt8pt do
    begin
      if CurDiscLine <> Text then
      begin
        fLineChanged := true;
        with FirstLine do
        begin
          //PR: 27/05/2009 Changed to deal with Advanced Discounts
          ProcessInputPAmount(Disc, DiscChr, Text);
          SetDiscountDisplay(Sender as TExt8pt, Disc, DiscChr);
          if Sender = edtDiscount then
          begin
            Discount := Disc;
            DiscountChr := DiscChr;
          end
          else
          if Sender = edtMultiBuy then
          begin
            Discount2 := Disc;
            Discount2Chr := DiscChr;
          end
          else
          begin
            Discount3 := Disc;
            Discount3Chr := DiscChr;
          end;

        end;
        UpdateLineTotal(false);
      end;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.edtCCCodeExit(Sender: TObject);
var
  CCCode    : string20;
  AltMod,
  IsCC      : Boolean;
  Foundcode : AnsiString;
  TempF : FileVar;
begin
  IsCC:=(Sender=edtCCCode);

  If (Sender is Text8Pt) then
  With Text8pt(Sender) do
  Begin
    AltMod:=Modified;
    Foundcode:=Trim(Text);

    if (ActiveControl <> btnCancel) and (fEditMode <> actShow) and
      ((AltMod) or (FoundCode='')) then
    begin
      fLineChanged := true;
      if not IsNarrativeOnly then
      begin
        CCCode := Text;
        {PR 14/01/03 -
        CC and Department are stored in PrwdF in company directory, notes in
        PwrdF in ebus directory. So when we do getccdep it opens and closes PwrdF in
        co directory, overwriting PwrdF in F Array. Need to store and replace file var
        for PwrdF in ebus dir.}

        TempF := F[PwrdF];
        if DoGetCCDep(self, CurCompSettings.CompanyPath, CCCode, CCCode, IsCC,
             vmShowList, true) then
        Begin
          Text:= CCCode;
          FirstLine.CCDep[IsCC] := CCCode;
        end
        else
          SetFocus;
        F[PwrdF] := TempF;
      end;
    end;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.edtDepCodeExit(Sender: TObject);
begin
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.edtNomCodeExit(Sender: TObject);
var
  Validate : boolean;
  NomCode : string20;
  NomNum : longint;
begin
  Validate := (ActiveControl <> btnCancel) and (fEditMode <> actShow);
  try
    NomNum := StrToInt(Trim(edtNomCode.Text));
  except
    NomNum := 0;
    Validate := true;
  end;
  Validate := Validate and ((NomNum <> FirstLine.NomCode) or (FirstLine.NomCode = 0)); 

  if Validate then
  begin
    edtNomCode.Text := Trim(edtNomCode.Text);
    NomCode := edtNomCode.Text;
    fLineChanged := true;

    if DoGetNom(self, CurCompSettings.CompanyPath, NomCode, NomNum,
      [nomProfitAndLoss, nomBalanceSheet], vmShowList, true) then
    begin
      edtNomCode.Text := IntToStr(NomNum);
      FirstLine.NomCode := NomNum;
      edtNomCodeDesc.Text := GetNomDescription(StrToInt(edtNomCode.Text));
    end
    else
      edtNomCode.SetFocus;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.edtJobCodeExit(Sender: TObject);
var
  JobCode    : string20;
  AltMod     : Boolean;


begin
  AltMod:=edtJobCode.Modified;

  if (ActiveControl <> btnCancel) and (fEditMode <> actShow) then
  begin

    JobCode := edtJobCode.Text;
    if Trim(JobCode) <> '' then
    begin
//      if DoGetJobCode(self, CurCompSettings.CompanyPath, JobCode, JobCode, vmCheckValue, true) then
      if DoGetJobCode(self, CurCompSettings.CompanyPath, JobCode, JobCode, vmShowList, true) then
      Begin
        edtJobCode.Text := JobCode;
        if (edtJobCode.Text <> FirstLine.JobCode) then
        begin
          fLineChanged := true;
          FirstLine.JobCode := edtJobCode.Text;
        end;
      end
      else
        edtJobCode.SetFocus;
    end;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.edtJobAnalysisExit(Sender: TObject);
var
  JobAnalysis : string20;
begin
  if (ActiveControl <> btnCancel) and (fEditMode <> actShow) then
  begin
    if (edtJobAnalysis.Text <> FirstLine.AnalCode) then
    begin
      fLineChanged := true;
      FirstLine.AnalCode := edtJobAnalysis.Text;
    end;

    JobAnalysis := edtJobAnalysis.Text;
    if Trim(FirstLine.JobCode) <> '' then
    begin
      if DoGetJobAnalysis(self, CurCompSettings.CompanyPath, JobAnalysis, JobAnalysis,
        [jaRevenue], vmShowList, true) then
      begin
        edtJobAnalysis.Text := JobAnalysis;
        FirstLine.AnalCode := edtJobAnalysis.Text;
      end
      else
        edtJobAnalysis.SetFocus;
    end;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.DeleteExistingLines;
var
  LineCount,
  i : integer;
  KeyS : str255;
begin
  with ExLocal^ do
  begin
    KeyS := FullRunNoKey(Id.FolioRef, Id.LineNo);
    Status := LFind_Rec(B_GetEq, IDetailF, 0, KeyS);
    LineCount := 0;
    while (Status = 0) and (LineCount < OriginalDescLineCount) do
    begin
      LDelete_Rec(IDetailF, 0);
      Status := LFind_Rec(B_GetNext, IDetailF, 0, KeyS);
      inc(LineCount);
    end;
  end;
end;

//-----------------------------------------------------------------------


Procedure TfrmTransactionLine.OutDesc;

Var
  n  :  Integer;
  StockRec : TBatchSKRec;


Begin
  With ExLocal^,FirstLine,LineDesc do
  Begin

    Link2Stock(StockCode);

    If (Is_FullStkCode(StockCode)) then
      LDKitLink:=LStock.StockFolio
    else
      LDKitLink:=FolioRef;

    LDFolio:=FolioRef;

    Editing:=BOn;

    GetMultiLines(LastRecAddr[Fnum],BOn);

    SetDescFields;

  end;

end;


Procedure TfrmTransactionLine.Form2Desc;

Var
  n,
  noLines  :  Integer;

  FoundOk  :  Boolean;


Begin

  With LineDesc.DescFields do
  Begin

    noLines:=Pred(Count);

    FoundOk:=BOn;

    While (noLines>=0) and (FoundOk) do
    Begin
      FoundOk:=EmptyKey(IdDescfRec(noLines).Text,DocDesLen);

      If (FoundOk) then
        Dec(noLines);

    end;

    For n:=0 to Pred(Count) do
    Begin
      If (n<=noLines) then
      Begin
        If (n>Pred(LineDesc.Count)) then
          LineDesc.AddVisiRec(IdDescfRec(n).Text,0)
        else
          LineDesc.IdRec(n)^.fLine:=IdDescfRec(n).Text;
      end
      else
        If (n<=Pred(LineDesc.Count)) then
          LineDesc.Delete(Pred(LineDesc.Count));
    end;

  end; {With..}

  With ExLocal^,FirstLine,LineDesc do
  Begin
    {* Delete any old lines first *}

    LDFolio:=FolioRef;

    Link2Stock(StockCode);

    If (Not LastEdit) then {* Get folio here for non stock lines *}
    Begin


      If (Is_FullStkCode(StockCode)) then
        LDKitLink:=LStock.StockFolio
      else
        LDKitLink:=FolioRef;
    end;

    If (LastEdit) or ((HasDesc) and (noLines>-1)) then {* Delete what was there first *}
    Begin
      If (Is_FullStkCode(StockCode)) then
        LDKitLink:=LStock.StockFolio;

      GetMultiLines(LastRecAddr[Fnum],BOff);
    end;




    StoreMultiLines(FirstLine,HeaderRec^);

  end; {With..}
end;


procedure TfrmTransactionLine.RenumberOriginalLines;
// Notes : Renumbers lines after the one being handled
var
  LineCounter : integer;
  KeyS : Str255;

  function MoreLines : boolean;
  begin
    if fEditMode = actInsert then
      Result := ExLocal^.Lid.LineNo >= Id.LineNo
    else
      Result := ExLocal^.Lid.LineNo > Id.LineNo
  end;

begin
  LineCounter := HeaderRec^.ILineCount + NewDescLineCount - OriginalDescLineCount;
  with ExLocal^ do
  begin
    KeyS := FullRunNoKey(Id.FolioRef, MAXLONGINT);
    Status := LFind_Rec(B_GetLess, IDetailF, 0, KeyS);
    while (Status = 0) and (Id.FolioRef = LId.FolioRef) and MoreLines do
    begin
      Lid.LineNo := LineCounter;
      Lid.AbsLineNo := LineCounter;
      LPut_Rec(IDetailF, 0);
      dec(LineCounter);
      Status := LFind_Rec(B_GetPrev, IDetailF, 0, KeyS);
    end;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.UpdateLineValues;
// Notes : Update values in FirstLine which need to be saved, but which aren't displayed
begin
 FirstLine.VAT := CalcLineVAT(FirstLine, HeaderRec^.DiscSetl);
  // Also, line currency, line exchange rates ...
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.AddNewLines;
var
  i : integer;
  DescLine : string;
  LineCount : integer;
  StockFolio : longint;
  StockRec : TBatchSKRec;
begin
  with ExLocal^ do
  begin
    // Add the main transaction line
    UpdateLineValues;
    Lid := FirstLine;
    LAdd_Rec(IDetailF, 0);
    // Add any additional description lines
    GetStockDetailsFromCode(Trim(FirstLine.StockCode), StockRec);
    LineCount := FirstLine.LineNo;
    for i := 2 to 6 do
    begin
      case i of
        2: DescLine := edtDesc2.Text;
        3: DescLine := edtDesc3.Text;
        4: DescLine := edtDesc4.Text;
        5: DescLine := edtDesc5.Text;
        6: DescLine := edtDesc6.Text;
      end;
      if Trim(DescLine) <> '' then
      begin
        inc(LineCount);
        FillChar(Lid, SizeOf(Lid), 0);
        Lid.FolioRef := FirstLine.FolioRef;
        Lid.AbsLineNo := LineCount;
        Lid.LineNo := LineCount;
        Lid.Desc := DescLine;
        Lid.IDDocHed := FirstLine.IDDocHed;
        if Trim(FirstLine.StockCode) <> '' then
          Lid.KitLink := StockRec.StockFolio
        else
          Lid.KitLink := FirstLine.FolioRef;
        LAdd_Rec(IDetailF, 0);
      end;
    end;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.UpdateTransactionHeader;
// Update the line count on the transaction header
var
  KeyS : str255;
  Status : integer;
  ExLocal : ^TExLocalEBus;
begin
  // Going to force a save anyway so just re-set the line count
  HeaderRec^.ILineCount := HeaderRec^.ILineCount + NewDescLineCount - OriginalDescLineCount;

(*  new(ExLocal, Create(CLIENT_ID_LOCAL));
  with ExLocal^ do
  begin
    OpenOneFile(InvF, CurCompSettings.CompanyPath, EBUS_DOCNAME);
    KeyS := HeaderRec^.OurRef;
    if ExLocal^.LFind_Rec(B_GetEq, InvF, 2, KeyS) = 0 then
    begin
      LInv.ILineCount := HeaderRec^.ILineCount + NewDescLineCount - OriginalDescLineCount;
      // Need to update the value in the global transaction header record
      HeaderRec^.ILineCount := LInv.ILineCount;
      LPut_Rec(InvF, 2);
    end;
    CloseSelFiles([InvF]);
  end;
  dispose(ExLocal, destroy); *)
end;


//-----------------------------------------------------------------------

procedure TfrmTransactionLine.StoreId(Fnum,KeyPath  :  Integer);

Var
  TmpId
       :  Idetail;

begin
  Form2Desc;

  // Re calculate VAT amount
  UpdateLineValues;

  With EXlocal^ do
  Begin
    LId:=FirstLine;

    If (Assigned(LineDesc)) then
    Begin
      If LineDesc.LdKitLink<>0 then
        LId.sdbFolio:=LineDesc.LdKitLink;

    end;

    If (fEditMode=actEdit) then
    Begin
      If (Not LViewOnly) then
      Begin

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpId:=LId;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          LStatus:=LGetDirect(Fnum,KeyPAth,0); {* Re-Establish Position *}

          LId:=TmpId;

        end;


        LStatus:=LPut_Rec(Fnum,KeyPAth);

      end; {Don't store if view only}
    end
    else
    Begin {* Add new record *}

      If (fEditMode=actInsert) then
      Begin
        TmpId:=LId;

        MoveEmUp(FullNomKey(LId.FolioRef),
               FullIdKey(LId.FolioRef,LastAddrD),
               FullIdKey(LId.FolioRef,LId.LineNo),
               1,
               Fnum,KeyPath);

        LId:=TmpId;
      end;

      Inc(HeaderRec^.ILineCount);


      LStatus:=LAdd_Rec(Fnum,KeyPAth);

      LGetRecAddr(IDetailF);  {* Refresh record address *}

    end;

    LReport_BError(Fnum,LStatus);

    With LastId do
      {InvFSU3U.}UpdateRecBal(LastId,HeaderRec^,BOn,BOff,0);

    With LId do
      {InvFSU3U.}UpdateRecBal(LId,HeaderRec^,BOff,BOn,0);

    //We need to reestablish the global file position here for the list to update its position correctly.

    If (LStatusOk) then
    Begin
      SetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

      Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

      Report_BError(Fnum,Status);
    end;

    SendMessage((Owner as TForm).Handle, WM_CustGetRec, 200, Ord(fEditmode=actEdit));

  end;{With..}

end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.btnOKClick(Sender: TObject);
begin
  //PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Save if we overrode Intrastat
  //PR: 08/02/2016 ABSEXCH-17126 v2016 R1 change check
  if not fLineChanged and not chkOverrideIntrastat.Checked then
    Close
  else
    if ValidateValues then
    begin
      If (fEditMode In [actAdd,actInsert,actEdit]) then
      begin
        FormIntrastatToLine;
        StoreId(IDetailF,IdFolioK);
      end;

      Close;
    end;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.sbxStockDescExit(Sender: TObject);
begin
  // Return the description to the top
  sbxStockDesc.VertScrollBar.Position := 0;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.InitialiseDatabase;
begin
  new(ExLocal, Create(CLIENT_ID_LINE));
  ExLocal^.OpenOneFile(IDetailF, CurCompSettings.CompanyPath, EBUS_DETAILNAME);

  ExLocal^.Open_System(StockF,StockF);

  FillChar(FirstLine, SizeOf(FirstLine), 0);
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.InitialiseFirstLine;
begin
  if fEditMode = actInsert then
    FirstLine.LineNo := Id.LineNo
  else
    FirstLine.LineNo := HeaderRec^.ILineCount +1;

    FirstLine.AbsLineNo := FirstLine.LineNo;
    FirstLine.IDDocHed := HeaderRec^.InvDocHed;
    FirstLine.FolioRef := HeaderRec^.FolioNum;
    FirstLine.VATCode := 'S';
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.ReadTransactionLine;
var
  KeyS : str255;
  Status : integer;
begin
  OriginalDescLineCount := 0;
  with ExLocal^ do
  begin
    KeyS := FullRunNoKey(Id.FolioRef, Id.LineNo);
    Status := LFind_Rec(B_GetEq, IDetailF, 0, KeyS);
    // All transaction lines for the same transaction will share the same
    // Folio ref so need to determine whether moved on to the next transaction line ...
    If (Status = 0) and (Id.FolioRef = LId.FolioRef) then
    begin
      edtDesc1.Text := Lid.Desc;
      LGetRecAddr(IDetailF);  {* Refresh record address *}
      FirstLine := LId;
    end;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.SetDiscountDisplay(const WhichEdit : TExt8pt; Discount : double; DiscChar : char);
begin
  if DiscChar in StkBandSet then
    WhichEdit.Text := DiscChar
  else
    if DiscChar = '%' then
      WhichEdit.Text := FloatToStrF(Ex_RoundUp((Discount * 100), 2), ffFixed, 18, 2) + '%'
    else
      WhichEdit.Text := ToFixedDP(Discount, 2);
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.btnShowIntrastatClick(Sender: TObject);
begin
end; // TfrmTransactionLine.btnShowIntrastatClick

//-----------------------------------------------------------------------

function TfrmTransactionLine.NewDescLineCount: integer;
// Post : Returns the total number of description lines on screen
begin
  Result := 0;
  if Trim(edtDesc1.Text) <> '' then
    inc(Result);
  if Trim(edtDesc2.Text) <> '' then
    inc(Result);
  if Trim(edtDesc3.Text) <> '' then
    inc(Result);
  if Trim(edtDesc4.Text) <> '' then
    inc(Result);
  if Trim(edtDesc5.Text) <> '' then
    inc(Result);
  if Trim(edtDesc6.Text) <> '' then
    inc(Result);
end;

//-----------------------------------------------------------------------

function TfrmTransactionLine.ValidateValues : boolean;
var
  TmpSSD, ErrSSDCode : Integer;

  procedure ValidationWarning(CodeType : string);
  begin
    MessageDlg(Format('The %s Code is not Valid', [CodeType]), mtWarning, [mbOK], 0);
  end;

begin
  Result := true;

  if CurCompSettings.CCDepEnabled and not IsNarrativeOnly then
  begin
    // Check cost centre
    Result := CCDepExists(FirstLine.CCDep[true], true);
    if not Result then
      ShowMessage('The Cost Centre / Department Code is not valid');
    // Check department
    if Result then
    begin
      Result := CCDepExists(FirstLine.CCDep[false], false);
      if not Result then
        ShowMessage('The Cost Centre / Department Code is not valid');
    end;
  end;

  if Result and CurCompSettings.MultiLocEnabled and (Trim(FirstLine.StockCode) <> '') then
  begin   // Check location
    Result := LocationExists(FirstLine.MLocStk);
    if not Result then
      ShowMessage('The Location Code is not valid');
  end;

  if Result and not IsNarrativeOnly then
  begin // Check GL code
    Result := NominalCodeExists(FirstLine.NomCode);
    if not Result then
      ShowMessage('The General Ledger Code is not valid');
  end;

  //PR: 08/02/2016 v2016 R1 ABSEXCH-17265 Validate commodity code
  If (chkOverrideIntrastat.Checked) and (Trim(edtCommodityCode.Text) <> '') then
  begin
    Val(edtCommodityCode.Text, TmpSSD, ErrSSDCode);
    Result := (ErrSSDCode=0) and (Length(edtCommodityCode.Text) = 8);
    if not Result then
      ShowMessage('The Commodity Code must be blank or 8 digits');
  end; {if..}

end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.UpdateLineTotal(UseDefaults : boolean);
var
  UnitPrice : double;
  PriceRec : TBatchStkPriceRec;
  Status : integer;
begin
  if (FirstLine.StockCode <> '')  and UseDefaults then
  begin // Use Toolkit to calculate price
    FillChar(PriceRec, SizeOf(PriceRec), 0);
    with PriceRec do
    begin
      StockCode := FirstLine.StockCode;
      CustCode := HeaderRec^.CustCode;
      Currency := HeaderRec^.Currency;
      Qty := FirstLine.Qty;
      Status := Ex_CalcStockPrice(@PriceRec, SizeOf(PriceRec));
      if Status = 0 then
      begin
        FirstLine.Discount := DiscVal;
        FirstLine.DiscountChr := DiscChar;
        SetDiscountDisplay(edtDiscount, FirstLine.Discount, FirstLine.DiscountChr);
        FirstLine.NetValue := Price;
        edtUnitPrice.Value := FirstLine.NetValue;
      end;
    end;
  end;

//  edtTotal.Value := InvLTotal(FirstLine, true, 0.00);
  edtTotal.Value := GetLineTotal(FirstLine, true, 0.00);
(*
  // Cash discount is per item, not total
  if FirstLine.DiscountChr = '%' then
    UnitPrice := FirstLine.NetValue * (1 - (FirstLine.Discount / 100))
  else
    UnitPrice := FirstLine.NetValue - FirstLine.Discount;
  edtTotal.Value := Ex_RoundUp(UnitPrice * FirstLine.Qty, 2); *)
end; // TfrmTransactionLine.UpdateLineTotal

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.cbxVATExit(Sender: TObject);
begin
  if FirstLine.VATCode <> cbxVAT.Items[cbxVAT.ItemIndex][1] then
  begin
    FirstLine.VATCode := cbxVAT.Items[cbxVAT.ItemIndex][1];
    fLineChanged := true;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.edtCostExit(Sender: TObject);
begin
  if not ZeroFloat(abs(FirstLine.CostPrice - edtCost.Value)) then
  begin
    fLineChanged := true;
    FirstLine.CostPrice := edtCost.Value;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.edtDelDateExit(Sender: TObject);
begin
  if FirstLine.PDate <> edtDelDate.Text then
  begin
    fLineChanged := true;
    FirstLine.PDate := edtDelDate.Text;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.cbxLineTypeExit(Sender: TObject);
begin
  if FirstLine.DocLTLink <> cbxLineType.ItemIndex then
  begin
    fLineChanged := true;
    FirstLine.DocLTLink := cbxLineType.ItemIndex;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.edtDescLineEnter(Sender: TObject);
begin
  if Sender is TExt8pt then
    CurDescLine := (Sender as TExt8pt).Text;
end;

//-----------------------------------------------------------------------

procedure TfrmTransactionLine.edtDescLineExit(Sender: TObject);
begin
  if Sender is TExt8pt then
    if CurDescLine <> (Sender as TExt8pt).Text then
      fLineChanged := true;
end;

procedure TfrmTransactionLine.SetMasks;
const
  Hashes = '###,###,##';
var
  sQtyDecs, sPriceDecs, sCostDecs : String;
begin
  sQtyDecs := '0.' + StringOfChar('0', CurCompSettings.QuantityDP);
  sPriceDecs := '0.' + StringOfChar('0', CurCompSettings.PriceDP);
  sCostDecs := '0.' + StringOfChar('0', CurCompSettings.CostDP);

  edtQty.DisplayFormat := Hashes + sQtyDecs + ';' + Hashes + sQtyDecs + '-';
  edtPackQty.DisplayFormat := Hashes + sQtyDecs + ';' + Hashes + sQtyDecs + '-';
  edtUnitPrice.DisplayFormat := Hashes + sPriceDecs + ';' + Hashes + sPriceDecs + '-';
  edtCost.DisplayFormat := Hashes + sCostDecs + ';' + Hashes + sCostDecs + '-';

end;



procedure TfrmTransactionLine.chkOverrideIntrastatClick(Sender: TObject);
begin
  if (Trim(edtStockCode.Text) <> '') then
  begin
    EnableIntrastatFields(chkOverrideIntrastat.Checked);
  end;
end;

//PR: 01/02/2016 ABSEXCH-17116 v2016 R1
procedure TfrmTransactionLine.PopulateIntrastatLists;
var
  i: Integer;
  Line: string;
begin
  cbNoTc.Items.Clear;
  for i := 0 to IntrastatSettings.NatureOfTransactionCodesCount - 1 do
  begin
    Line := IntrastatSettings.NatureOfTransactionCodes[i].Code + ' - ' +
            IntrastatSettings.NatureOfTransactionCodes[i].Description;
    cbNoTc.Items.Add(Line);
    cbNoTc.ItemsL.Add(Line);
  end;
  LoadCountryCodes(cbIntrastatCountry);
  // LoadCountryCodes only loads the codes into the main Items list, but we
  // need the Code + Description, so we will copy these from the ItemsL list.
  cbIntrastatCountry.Items.Assign(cbIntrastatCountry.ItemsL);
end;

procedure TfrmTransactionLine.EnableIntrastatFields(Enable: Boolean);
begin
  lblCommodityCode.Enabled   := Enable;
  edtCommodityCode.Enabled   := Enable;
  lblStockUnits.Enabled      := Enable;
  edtStockUnits.Enabled      := Enable;
  lblLineUnitWeight.Enabled  := Enable;
  edtLineUnitWeight.Enabled  := Enable;
  lblGoodsToCountry.Enabled  := Enable;
  chkCountry.Enabled         := Enable;
  chkQRCode.Enabled          := Enable;
  cbIntrastatCountry.Enabled := Enable;
  lblNoTc.Enabled            := Enable;
  cbNoTc.Enabled             := Enable;
  lblSSDUplift.Enabled       := Enable;
  edtSSDUplift.Enabled       := Enable;
  if not chkCountry.Checked then
    cbIntrastatCountry.Enabled := False;
end;

//PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Gets CustRec for current customer
function TfrmTransactionLine.CheckCust: CustRec;
var
  TraderType : TTraderType;
  ACCode : string20;
begin
  if HeaderRec.CustCode <> Cust.CustCode then
  begin
    if IsPurchaseTransaction(HeaderRec^.OurRef) then
      TraderType := trdSupplier
    else
      TraderType := trdCustomer;

    ACCode := HeaderRec^.CustCode;

    DoGetCust(self, CurCompSettings.CompanyPath, ACCode, ACCode, TraderType,
                   vmCheckValue, true)
  end;

  Result := Cust;
end;

//PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Gets StockRec for current stock code
function TfrmTransactionLine.CheckStock: StockRec;
var
  StockCode : String20;
begin
  if Trim(edtStockCode.Text) <> Trim(Stock.StockCode) then
  begin
    StockCode := LJVar(edtStockCode.Text, 16);
    DoGetStock(self, CurCompSettings.CompanyPath, StockCode, StockCode,
        [stkProduct, stkBOM], vmCheckValue, true)

  end;
  Result := Stock;
end;

//PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Intrastat defaults
procedure TfrmTransactionLine.IntrastatToLine;
begin
  //Populate Line with values from stock & account records

  if not FirstLine.SSDUseLine then  //Check for already populated
  begin
    FirstLine.SSDCommod := CheckStock.CommodCode;
    FirstLine.SSDSPUnit := Stock.SuppSUnit;
    if IsPurchaseTransaction(HeaderRec^.OurRef) then
      FirstLine.LWeight := Stock.PWeight
    else
      FirstLine.LWeight := Stock.SWeight;
    FirstLine.SSDCountry := Stock.SSDCountry;
    FirstLine.SSDUplift := Stock.SSDDUplift;

    if Cust.acDefaultToQR and not (ExLocal.LInv.InvDocHed in PurchSplit) then
       FirstLine.SSDCountry := 'QR'
    else
    if (Trim(Cust.acCountry) <> '') then
    begin
      if (Cust.CustSupp = 'S') or (Trim(HeaderRec.thDeliveryCountry) = '') then
        FirstLine.SSDCountry := Cust.acCountry
      else
        FirstLine.SSDCountry := HeaderRec.thDeliveryCountry;
    end;

    if HeaderRec.TransNat > 0 then
      FirstLine.tlIntrastatNoTC := IntToStr(HeaderRec.TransNat)
    else
    begin
      if CurrentCountry = IECCode then
        FirstLine.tlIntrastatNoTC := '1'
      else
        FirstLine.tlIntrastatNoTC := '10';
    end;
  end;
end;

//PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Copy intrastat fields from line to form
procedure TfrmTransactionLine.LineIntrastatToForm;
begin
  chkOverrideIntrastat.Checked := FirstLine.SSDUseLine;
  edtCommodityCode.Text := FirstLine.SSDCommod;
  edtStockUnits.Value := FirstLine.SSDSPUnit;
  edtLineUnitWeight.Value := FirstLine.LWeight;
  if (FirstLine.SSDCountry = 'QR') then
  begin
    chkQRCode.Checked := True;
    cbIntrastatCountry.ItemIndex := -1;
  end
  else
  begin
    chkCountry.Checked := True;
    cbIntrastatCountry.ItemIndex := ISO3166CountryCodes.IndexOf(ifCountry2, FirstLine.SSDCountry);
  end;
  if (FirstLine.tlIntrastatNoTc <> '') then
    cbNoTc.ItemIndex := FindCloseMatch(FirstLine.tlIntrastatNoTc, cbNoTc.Items)
  else
    IntrastatSettings.IndexOf(stNatureOfTransaction, ifCode, Format('%2d', [HeaderRec.TransNat]));

  if CurrentCountry = IECCode then
    edtSSDUplift.Value := FirstLine.SSDUplift;

  //PR: 04/02/2016 v2016 R1 ABSEXCH-17249 Call click event to enable/disable intrastat fields
  chkOverrideIntrastatClick(chkOverrideIntrastat);
end;

//PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Copy fields from form to line if override checked
procedure TfrmTransactionLine.FormIntrastatToLine;
begin
  FirstLine.SSDUseLine:= chkOverrideIntrastat.Checked;
  if FirstLine.SSDUseLine then
  begin
    FirstLine.SSDCommod := edtCommodityCode.Text;
    FirstLine.SSDSPUnit := edtStockUnits.Value;
    FirstLine.LWeight   := edtLineUnitWeight.Value;

    if (chkQRCode.Checked) then
      FirstLine.SSDCountry := 'QR'
    else if cbIntrastatCountry.ItemIndex > -1 then
      FirstLine.SSDCountry := ISO3166CountryCodes.ccCountryDetails[cbIntrastatCountry.ItemIndex].cdCountryCode2
    else
      FirstLine.SSDCountry := '';

    if cbNoTc.ItemIndex > -1 then
      FirstLine.tlIntrastatNoTc := Copy(cbNoTc.Text, 1, 2)
    else
      FirstLine.tlIntrastatNoTc := '';

    if CurrentCountry = IECCode then
      FirstLine.SSDUplift := edtSSDUplift.Value;
  end;
end;

procedure TfrmTransactionLine.chkCountryClick(Sender: TObject);
begin
  cbIntrastatCountry.Enabled := True;
end;

procedure TfrmTransactionLine.chkQRCodeClick(Sender: TObject);
begin
  cbIntrastatCountry.Enabled := False;
end;

end.


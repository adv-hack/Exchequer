unit TransactionLineForm;

{$ALIGN 1}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, BorBtns, TEditVal, StdCtrls, SBSPanel, Mask, ExtCtrls, Math,
  ComCtrls,
  Enterprise01_TLB,
  ExchTypes,
  CustomFieldFuncs;

type
  TTransactionLineFrm = class(TForm)
    PageControl1: TPageControl;
    DE3Page: TTabSheet;
    btnClose: TButton;
    Id3Panel: TSBSPanel;
    pnlValues: TPanel;
    Id3PQLab: Label8;
    Id3QtyLab: Label8;
    Id3UPLab: Label8;
    Id3DiscLab: Label8;
    Id3LTotLab: Label8;
    lblOtherDiscounts: Label8;
    lblMBDiscount: Label8;
    lblTransDiscount: Label8;
    Label81: Label8;
    Label82: Label8;
    VATCCLab3: Label8;
    Label85: Label8;
    Id3CostLab: Label8;
    Label83: Label8;
    DelDateLab: Label8;
    Label84: Label8;
    Label86: Label8;
    Bevel1: TBevel;
    Id5JCodeF: Text8Pt;
    Id5JAnalF: Text8Pt;
    Id3DepF: Text8Pt;
    Id3CCF: Text8Pt;
    Id3VATF: TSBSComboBox;
    Id3NomF: Text8Pt;
    Id3LTF: TSBSComboBox;
    UseISCB: TBorCheck;
    IntBtn: TBitBtn;
    GLDescF: Text8Pt;
    edtMultiBuy: Text8Pt;
    edtTransDiscount: Text8Pt;
    Id3DiscF: Text8Pt;
    Id3DelF: TEditDate;
    Id3CostF: TCurrencyEdit;
    Id3LTotF: TCurrencyEdit;
    Id3PQtyF: TCurrencyEdit;
    Id3QtyF: TCurrencyEdit;
    Id3UPriceF: TCurrencyEdit;
    pnlService: TPanel;
    lblServiceTo: TLabel;
    chkService: TBorCheck;
    dtServiceStart: TEditDate;
    dtServiceEnd: TEditDate;
    Id3SBox: TScrollBox;
    Id3Desc1F: Text8Pt;
    Id3Desc2F: Text8Pt;
    Id3Desc3F: Text8Pt;
    Id3Desc4F: Text8Pt;
    Id3Desc5F: Text8Pt;
    Id3Desc6F: Text8Pt;
    Id3Panel3: TSBSPanel;
    UDF1L: Label8;
    UDF3L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    pnlWebExtensions: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label87: Label8;
    edtReference: Text8Pt;
    edtFromPostCode: Text8Pt;
    edtReceiptNo: Text8Pt;
    edtToPostCode: Text8Pt;
    LUD1F: Text8Pt;
    LUD2F: Text8Pt;
    LUD3F: Text8Pt;
    LUD4F: Text8Pt;
    Notebook1: TNotebook;
    Id3SCodeF: Text8Pt;
    Id3LocF: Text8Pt;
    id3LocLab: Label8;
    Id3SCodeLab: Label8;
    Id1ItemLab: Label8;
    Id1QtyLab: Label8;
    Id1ItemF: Text8Pt;
    Id1QtyF: TCurrencyEdit;
    LUD5F: Text8Pt;
    LUD6F: Text8Pt;
    LUD7F: Text8Pt;
    LUD9F: Text8Pt;
    LUD8F: Text8Pt;
    LUD10F: Text8Pt;
    UDF6L: Label8;
    UDF8L: Label8;
    UDF10L: Label8;
    UDF5L: Label8;
    UDF7L: Label8;
    UDF9L: Label8;
    Bevel2: TBevel;
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    oTransaction: ITransaction;
    oLine: ITransactionLine8;
    LDescLines: Array[2..6] Of String[60];
    oNominal: IGeneralLedger;
    oStock: IStock;

    FDataPath:    WideString;
    FToolkit:     IToolkit2;
    FToolkitOpen: Boolean;
    FUserName:    WideString;

    procedure ConfigureDialog;
    procedure OutId;
    procedure SetUDFields(UDDocHed  :  TDocTypes);
    procedure WMWindowPosChanged(var Msg : TMessage); message WM_WindowPosChanged;
  public
    { Public declarations }
    procedure DisplayId(Update: Boolean = False);
    property Toolkit: IToolkit2 read FToolkit write FToolkit;
  end;

implementation

{$R *.dfm}

Uses ETStrU,
     EntLicence,
     CTKUtil,
     TransactionForm;

const
  I_SPACER = 4; //vertical pixels between panels
  I_ROOM_FOR_BUTTONS = 42; //Allow room for buttons if no panels visible
  I_TABHEIGHT = 26; //Height of tabs on page control

// =============================================================================

// IMPORTANT NOTE: This message handler is required to ensure the form stays
// on top, as it has a habit of losing its Stay-On-Top'ness at runtime.
procedure TTransactionLineFrm.WMWindowPosChanged(var Msg : TMessage);
var
  TopWindow : TWinControl;
begin
  // Do standard message processing
  inherited;

  // HM 22/10/03: Added Visible check as it hangs under win 98 otherwise
  if self.Visible then
  begin
    // Check to see if the TopMost window is a Drill-Down window
    TopWindow := FindControl(PWindowPos(Msg.LParam).hwndInsertAfter);
    if not Assigned(TopWindow) then
      // Restore TopMost back to window
      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE);
  end; // If Self.Visible
end;

// -----------------------------------------------------------------------------

// Was formerly in the FormCreate but oTransaction and oLine are not populated at that point making
// it difficult to configure the DocType specific fields
procedure TTransactionLineFrm.ConfigureDialog;
var
  JBCostOn: Boolean;
  Show_CMG: Boolean;

  //------------------------------

  function PanelHeight(const oControl : TControl) : Integer;
  //Returns height of panel according to its visibiltiy
  begin
    if oControl.Visible then
      Result := oControl.Height + I_SPACER
    else
      Result := 0;
  end;

  //------------------------------

  procedure SetPanelTops;
  //Sets Multi Buys, UDFs and Web Extensions panels in the correct position according to which ones are visible
  begin
    //Vertical positioning from top is Multi Buys, UDFs, Web Extensions. As Multi Buys is top, we only need to adjust
    //the positions of the lower two according to the visibility of the panel(s) above them.

    //User Defined Fields
    if Id3Panel3.Visible then
    begin
      //GS?
    end;

    //Web Extensions
    if pnlWebExtensions.Visible then
    begin
      if Id3Panel3.Visible then //Put below UDFs
        pnlWebExtensions.Top := Id3Panel3.Top + Id3Panel3.Height + I_SPACER
      else
      begin
        pnlWebExtensions.Top := Id3Panel3.Top;
      end;
    end;
  end;

  //------------------------------

  procedure SetFormHeight;
  //PR: 08/02/2010 Changed this function to simplify it whilst adding Web Extensions fields
  var
    iTotalPanelHeight : Integer;
  begin
    SetPanelTops; //Set positions of MBDs, UDFs & Web Extensions

    //Find height of visible panels
    iTotalPanelHeight := PanelHeight(Id3Panel3) + //UD Fields
                         PanelHeight(pnlWebExtensions);

    if iTotalPanelHeight > 0 then
      PageControl1.Height := Id3Panel.Top +
                             Id3Panel.Height +
                             I_SPACER +
                             iTotalPanelHeight +
                             I_TABHEIGHT
    else
      //No panels visible, but need to allow room to show buttons
      PageControl1.Height := Id3Panel.Top +
                             Id3Panel.Height +
                             I_ROOM_FOR_BUTTONS +
                             I_TABHEIGHT;

    ClientHeight := PageControl1.Height + (PageControl1.Top * 2);
  end;

  //------------------------------

  procedure Set_DefaultVAT(ThisSet: TStrings; ShowInc, ShowFull: Boolean);
  var
    n: Byte;
    VATEntry: ISystemSetupVAT;
  begin

    for n := Low(VATCodeList) to High(VATCodeList) do
    begin
      VATEntry := FToolkit.SystemSetup.ssVATRates[VATCodeList[n]];
      ThisSet.Add(VATEntry.svCode + ' - ' + VATEntry.svDesc);
    end;

    if (ShowInc) then
    begin
      ThisSet.Add('I - Inclusive');
      ThisSet.Add('M - Manual');
    end;

    ThisSet.Add('A - Aqustn');
    ThisSet.Add('D - Disptch');

    if (not ShowFull) then
    begin
      for n := 0 to Pred(ThisSet.Count) do
        ThisSet[n] := Copy(ThisSet[n], 1, 1);
    end;
  end;

  //------------------------------

begin
  JBCostOn := (FToolkit.SystemSetup.ssReleaseCodes.rcJobCosting = 2);
  Show_CMG := False;

  // Setup dialog for the Exchequer version
  If (EnterpriseLicence.elModuleVersion = mvBase) Then
  Begin
    // Non-Stock
    NoteBook1.ActivePage := 'NonStock';

    Id1QtyF.DecPlaces := FToolkit.SystemSetup.ssQtyDecimals;
    Id3QtyF.Visible := False;
    Id3LocF.Visible := False;
  End // If (EnterpriseLicence.elModuleVersion = mvBase)
  Else
  Begin
    // Stock/SPOP
    NoteBook1.ActivePage := 'Stock';
    Id3LocF.Visible := FToolkit.SystemSetup.ssUseLocations;
  End; // Else

  // EC Services
  pnlService.Visible := (FToolkit.SystemSetup as ISystemSetup7).ssECServicesEnabled;
  pnlService.Enabled := False;

  // Location
  Id3LocLab.Visible := Id3LocF.Visible;
  If Id3LocF.Visible Then
  Begin
    If (Not FToolkit.SystemSetup.ssInputPackQtyOnLine) then
    Begin
      Id3LocLab.Left:=Id3PQLab.Left;
      Id3LocLab.Top:=Id3PQLab.Top;
      Id3LocLab.Parent:=Id3PQLab.Parent;
      Id3LocLab.Width:=Id3PQLab.Width;

      Id3LocF.Left:=Id3PQtyF.Left;
      Id3LocF.Top:=Id3PQtyF.Top;
      Id3LocF.Parent := Id3PQtyF.Parent;
      Id3LocF.TabOrder:=Id3PQtyF.TabOrder;

      Id3SCodeF.Width:=170;
      Id3SCodeF.PosArrows;
    end
  end; // If Id3LocF.Visible

  // Quantities
  Id3PQtyF.Visible := FToolkit.SystemSetup.ssInputPackQtyOnLine And (EnterpriseLicence.elModuleVersion <> mvBase);
  Id3PQtyF.DecPlaces := FToolkit.SystemSetup.ssQtyDecimals;
  Id3PQLab.Visible := Id3PQtyF.Visible;

  Id3QtyLab.Visible := Id3QtyF.Visible;
  Id3QtyF.DecPlaces:=FToolkit.SystemSetup.ssQtyDecimals;

  // Unit Price
  Id3UPriceF.DecPlaces := IfThen (oTransaction.thDocType In PurchSplit,
                                  FToolkit.SystemSetup.ssCostDecimals,
                                  FToolkit.SystemSetup.ssSalesDecimals);

  // Advanced Discounts
  edtMultiBuy.Visible := (EnterpriseLicence.elModuleVersion = mvSPOP);
  lblOtherDiscounts.Visible := edtMultiBuy.Visible;
  lblMBDiscount.Visible := edtMultiBuy.Visible;
  lblTransDiscount.Visible := edtMultiBuy.Visible;
  edtTransDiscount.Visible := edtMultiBuy.Visible;

  // Job Code / Analysis Code
  Id5JCodeF.Visible := (JBCostOn) And (EnterpriseLicence.elModuleVersion <> mvBase);
  Id5JAnalF.Visible := Id5JCodeF.Visible;
  Label81.Visible := Id5JCodeF.Visible;
  Label82.Visible := Id5JCodeF.Visible;

  // Load VAT Codes
  Set_DefaultVAT(Id3VATF.Items,True,False);
  Set_DefaultVAT(Id3VATF.ItemsL,True,True);

  // CC/Dept
  Id3CCF.Visible := FToolkit.SystemSetup.ssUseCCDept;
  Id3DepF.Visible := Id3CCF.Visible;
  If (Not Id3CCF.Visible) then
    VATCCLab3.Caption := FToolkit.SystemSetup.ssTaxWord // VAT only
  else
    VATCCLab3.Caption := FToolkit.SystemSetup.ssTaxWord + VATCCLab3.Caption;  // VAT + CC/Dept

  // Cost Price / Uplift
  Show_CMG := ((oTransaction.thDocType In SalesSplit) and
               (FToolkit.Functions.entCheckSecurity(FUserName, 143) = 0));

  { Hide cost if margin pwrd off }
  Id3CostF.Visible := Show_CMG or (oTransaction.thDocType In PurchSplit);
  Id3CostLab.Visible:=Id3CostF.Visible;
  If Id3CostF.Visible Then
  Begin
    Id3CostF.DecPlaces := FToolkit.SystemSetup.ssCostDecimals;
    If (oTransaction.thDocType In PurchSplit) then
    Begin
      Id3CostLab.Caption   := 'Uplift';
      Id3CostF.HelpContext := 740;
    End
    Else
      Id3CostLab.Caption := 'Cost';
  End;

  // Load Line Types

  Id3LTF.Items.Add('Normal');
  Id3LTF.Items.Add(FToolkit.SystemSetup.ssUserFields.ufLineType1);
  Id3LTF.Items.Add(FToolkit.SystemSetup.ssUserFields.ufLineType2);
  Id3LTF.Items.Add(FToolkit.SystemSetup.ssUserFields.ufLineType3);
  Id3LTF.Items.Add(FToolkit.SystemSetup.ssUserFields.ufLineType4);

  Id3LTF.ItemsL.Add('Normal');
  Id3LTF.ItemsL.Add(FToolkit.SystemSetup.ssUserFields.ufLineType1);
  Id3LTF.ItemsL.Add(FToolkit.SystemSetup.ssUserFields.ufLineType2);
  Id3LTF.ItemsL.Add(FToolkit.SystemSetup.ssUserFields.ufLineType3);
  Id3LTF.ItemsL.Add(FToolkit.SystemSetup.ssUserFields.ufLineType4);

  // Intrastat
  if not FToolkit.SystemSetup.ssUseIntrastat then
  begin
    Label84.Visible := False;
    Label86.Visible := False;
    UseISCb.Visible := False;
    IntBtn.Visible  := False;
  end;

  // Delivery/Line Date
  if (not (oTransaction.thDocType in PSOPSet)) then
    DelDateLab.Caption := 'Line Date';

  //------------------------------

  // Setup User-Defined fields and container
  SetUDFields(oTransaction.thDocType);

  //------------------------------

  // Web Extensions
  // Not readily accessible from the Toolkit
  pnlWebExtensions.Visible := False; // WebExtensionsOn and (oTransaction.thDocType = dtPIN);
  if pnlWebExtensions.Visible then
  begin
    if Id3Panel3.Visible then //Put below UDFs
      pnlWebExtensions.Top := Id3Panel3.Top + Id3Panel3.Height + I_SPACER
    else
      // Put in place of IDF's
      pnlWebExtensions.Top := Id3Panel3.Top;
  end;

  //------------------------------

  SetFormHeight;

  // Set default horizontal position
  With TForm(Owner) do
    Self.Left:=Left+2;

end;

// -----------------------------------------------------------------------------

procedure TTransactionLineFrm.DisplayId(Update: Boolean);
var
  lStatus : SmallInt;
  KeyS    : ShortString;
begin { DisplayId }
  if (FToolkit = nil) then
    Exit;
  oTransaction := FToolkit.Transaction;
  oLine := FToolkit.TransactionDetails as ITransactionLine8;
  oStock := oLine.tlStockCodeI;
  oNominal := FToolkit.GeneralLedger;

  if not Update then
    // Setup the dialog
    ConfigureDialog;

  // Get nominal record
  KeyS := oNominal.BuildCodeIndex(oLine.tlGLCode);
  LStatus := oNominal.GetGreaterThanOrEqual(KeyS);

  // Set Descriptive Caption
  Caption := CTKUtil.CompanyCodeFromPath(FToolkit, FToolkit.Configuration.DataDirectory) + ', ' +
             oTransaction.thOurRef + ' Transaction Line';

  // Display Fields
  OutId;

  if not Update then
    // Show the form
    Show;
end;

// -----------------------------------------------------------------------------

procedure TTransactionLineFrm.OutId;
begin { OutId }
  Id1ItemF.Text := oLine.tlItemNo;
  Id1QtyF.Value := oLine.tlQty;

  Id3CCF.Text  := oLine.tlCostCentre;
  Id3DepF.Text := oLine.tlDepartment;

  if (ExtractChar(oLine.tlVATCode, ' ') in VATSet) then
    Id3VATF.ItemIndex := Id3VATF.Items.IndexOf(ExtractChar(oLine.tlVATCode, ' '));

  If (oLine.tlStockCodeI <> nil) and
     (oLine.tlStockCodeI.stShowQtyAsPacks) and
     (oLine.tlStockCodeI.stShowQtyAsPacks) then
    Id3CostF.Value := oLine.tlCost * oLine.tlStockCodeI.stSalesUnits
  else
    Id3CostF.Value := oLine.tlCost;

  Id3NomF.Text := Form_BInt(oLine.tlGLCode, 0);

  GLDescF.Text := oNominal.glName;

  Id3LocF.Text := oLine.tlLocation;

  Id3DelF.DateValue := oLine.tlLineDate; // PDate;

  Id3SCodeF.Text := Trim(oLine.tlStockCode);
  Id3Desc1F.Text := oLine.tlDescr;

  Id3PQtyF.Value   := oLine.tlQtyMul;
  Id3QtyF.Value    := CaseQty(FToolkit, oLine.tlQty);
  Id3UPriceF.Value := oLine.tlNetValue;
  Id3DiscF.Text    := PPR_PamountStr(oLine.tlDiscount, ExtractChar(oLine.tlDiscFlag, ' '));

  Id3LTotF.Value   := oLine.entLineTotal(FToolkit.SystemSetup.ssShowInvoiceDisc, oLine.tlDiscount);
  Id3LTF.ItemIndex := oLine.tlBOMKitLink; // DocLTLink;

  if FToolkit.Enterprise.enModuleVersion = enModSPOP then
  begin
    UseISCB.Checked := oLine.tlSSDUseLineValues; // SSDUseLine;
    IntBtn.Enabled  := oLine.tlSSDUseLineValues; // SSDUseLine;
  end;

  Id5JCodeF.Text := Trim(oLine.tlJobCode);
  Id5JAnalF.Text := Trim(oLine.tlAnalysisCode);

  LUD1F.Text  := oLine.tlUserField1;
  LUD2F.Text  := oLine.tlUserField2;
  LUD3F.Text  := oLine.tlUserField3;
  LUD4F.Text  := oLine.tlUserField4;
  LUD5F.Text  := oLine.tlUserField5;
  LUD6F.Text  := oLine.tlUserField6;
  LUD7F.Text  := oLine.tlUserField7;
  LUD8F.Text  := oLine.tlUserField8;
  LUD9F.Text  := oLine.tlUserField9;
  LUD10F.Text := oLine.tlUserField10;

  // Advanced Discounts
  if FToolkit.Enterprise.enModuleVersion = enModSPOP then
  begin
    edtMultiBuy.Text      := PPR_PamountStr(oLine.tlMultiBuyDiscount, ExtractChar(oLine.tlMultibuyDiscountFlag, ' '));
    edtTransDiscount.Text := PPR_PamountStr(oLine.tlTransValueDiscount, ExtractChar(oLine.tlTransValueDiscountFlag, ' '));
  End;

  // EC Services
  pnlService.Visible := (FToolkit.SystemSetup as ISystemSetup7).ssECServicesEnabled;
  pnlService.Enabled := False;
  if pnlService.Visible then
  begin
    chkService.Checked := oLine.tlECService;
    if chkService.Checked then
    begin
      dtServiceStart.DateValue := oLine.tlECServiceStartDate;
      dtServiceEnd.DateValue := oLine.tlECServiceEndDate;
    end;

    // MH 02/11/2010 v6.4 ABSEXCH2976: Added code to present disabled look
    dtServiceStart.Enabled := chkService.Checked;
    dtServiceEnd.Enabled := chkService.Checked;

    dtServiceStart.Color := IfThen(dtServiceStart.Enabled, Id3UPriceF.Color, clBtnFace);
    dtServiceStart.Font.Color := IfThen(dtServiceStart.Enabled, Id3UPriceF.Font.Color, clBtnShadow);
    dtServiceStart.Visible := False; dtServiceStart.Visible := True;

    lblServiceTo.Font.Color := Id3SCodeLab.Font.Color;

    dtServiceEnd.Font.Color := dtServiceStart.Font.Color;
    dtServiceEnd.Color := dtServiceStart.Color;
    dtServiceEnd.Visible := False; dtServiceEnd.Visible := True;
  End; // if pnlService.Visible

  // Web Extensions Fields
  edtReference.Text := oLine.tlReference;
  edtReceiptNo.Text := oLine.tlReceiptNo;
  edtFromPostcode.Text := oLine.tlFromPostCode;
  edtToPostCode.Text := oLine.tlToPostCode;
End; { OutId }

//-------------------------------------------------------------------------

procedure TTransactionLineFrm.SetUDFields (UDDocHed : TDocTypes);
Var
  PNo,n         : Byte;
  UDAry, HDAry  : Array[1..4] of Byte;
Begin { SetUDFields }
  PNo:=1;

  Case UDDocHed of
    dtSOR,dtSDN  :  Begin
                  For n:=1 to 4 do
                    UDAry[n]:=14+n;

                  HDAry:=UDAry;
                end;
    dtPOR,dtPDN  :  Begin
                  For n:=1 to 4 do
                    UDAry[n]:=38+n;

                  HDAry:=UDAry;
                end;
    dtSQU      :  Begin
                  PNo:=2;

                  For n:=1 to 4 do
                    UDAry[n]:=28+n;

                  HDAry:=UDAry;
                end;
    dtPQU      :  Begin
                  PNo:=2;

                  For n:=1 to 4 do
                    UDAry[n]:=36+n;

                  HDAry:=UDAry;
                end;

    else        Begin
                  If (UDDocHed In SalesSplit) then
                  Begin
                    PNo:=0;
                    UDAry[1]:=17;
                    UDAry[2]:=18;
                    UDAry[3]:=19;
                    UDAry[4]:=20;

                    HDAry[1]:=8;
                    HDAry[2]:=9;
                    HDAry[3]:=10;
                    HDAry[4]:=11;

                  end
                  else
                  Begin
                    For n:=1 to 4 do
                      UDAry[n]:=22+n;

                    HDAry:=UDAry;
                  end;

                end;
  end; {Case..}

  //GS 17/11/2011 ABSEXCH-12037: modifed UDF settings code to use the new "CustomFieldsIntF" unit

  EnableUDFs(FToolkit,
             [UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
             [lud1F, lud2F, lud3F, lud4F, lud5F, lud6F, lud7F, lud8F, lud9F, lud10F], UDDocHed, True);


End; { SetUDFields }

//-------------------------------------------------------------------------

procedure TTransactionLineFrm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-------------------------------------------------------------------------

procedure TTransactionLineFrm.FormDestroy(Sender: TObject);
begin
  FToolkit := nil;
end;

//-------------------------------------------------------------------------

end.

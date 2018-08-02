unit SOPLineF;

{$ALIGN 1}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, BorBtns, TEditVal, StdCtrls, SBSPanel, Mask, ExtCtrls, Math,
  ComCtrls,
  GlobVar,       // Exchequer global const/type/var
  VarConst,      // Exchequer global const/type/var
  BTRVU2,
  BTSupU1;       // Custom Messages and Misc Btrieve Routines

type
  TfrmSOPLine = class(TForm)
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
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    LInv       : InvRec;
    LId        : IDetail;
    LDescLines : Array[2..6] Of String[60];
    LNom       : NominalRec;
    LStock     : StockRec;

    procedure ConfigureDialog;
    Procedure OutId;
    procedure SetFieldProperties(Panel : TSBSPanel; Field : Text8Pt) ;
    procedure SetUDFields(UDDocHed  :  DocTypes);
    procedure WMWindowPosChanged(var Msg : TMessage); Message WM_WindowPosChanged;
  public
    { Public declarations }
    procedure DisplayId (Const TheInv : InvRec; Const TheId : IDetail);
  end;

implementation

{$R *.dfm}

Uses ETStrU,
     EntLicence,     // Global Exchequer Licence object
     EntData,        // Global Exchequer Data object
     MiscU,          // Transaction Total Functions
     SysU2,
     CmpCtrlU,       // Misc Routines for loading/saving Colours & Positions
     ColCtrlU,       // Form Color/Font Properties Window
     InvFSu3U,       // Misc utility functions
     TranSOPF,       // Drill-Down SOP transaction form
     BTSupU2,        // Misc Exchequer Routines
     BTKeys1U,       // Exchequer Search Key utilities
     CustomFieldsIntF;

const
  I_SPACER = 4; //vertical pixels between panels
  I_ROOM_FOR_BUTTONS = 42; //Allow room for buttons if no panels visible
  I_TABHEIGHT = 26; //Height of tabs on page control

//=========================================================================

procedure TfrmSOPLine.FormCreate(Sender: TObject);
Begin // FormCreate
  // MH 22/06/2010: All stuff moved into ConfigureDialog as TL details not available at FormCreate time
End; // FormCreate

//------------------------------

procedure TfrmSOPLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;

  SendMessage ((Owner As TForm).Handle, WM_CustGetRec, 100, 1);
end;

//-------------------------------------------------------------------------

// IMPORTANT NOTE: This message handler is required to ensure the form stays
// on top, as it has a habit of losing its Stay-On-Top'ness at runtime.
procedure TfrmSOPLine.WMWindowPosChanged(var Msg : TMessage);
Var
  TopWindow : TWinControl;
Begin
  // Do standard message processing
  Inherited;

  // HM 22/10/03: Added Visible check as it hangs under win 98 otherwise
  If Self.Visible Then
  Begin
    // Check to see if the TopMost window is a Drill-Down window
    TopWindow := FindControl(PWindowPos(Msg.LParam).hwndInsertAfter);
    If Not Assigned(TopWindow) Then
      // Restore TopMost back to window
      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE);
  End; // If Self.Visible
End;

//-------------------------------------------------------------------------

// Was formerly in the FormCreate but LInv and LId are not populated at that point making
// it difficult to configure the DocType specific fields
procedure TfrmSOPLine.ConfigureDialog;

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

begin
  // Setup dialog for the Exchequer version
  If (EnterpriseLicence.elModuleVersion = mvBase) Then
  Begin
    // Non-Stock
    NoteBook1.ActivePage := 'NonStock';

    Id1QtyF.DecPlaces := Syss.NoQtyDec;
    Id3QtyF.Visible := False;
    Id3LocF.Visible := False;
  End // If (EnterpriseLicence.elModuleVersion = mvBase)
  Else
  Begin
    // Stock/SPOP
    NoteBook1.ActivePage := 'Stock';
    Id3LocF.Visible := Syss.UseMLoc;
  End; // Else

  // EC Services
  pnlService.Visible := SyssVat.VatRates.EnableECServices;
  pnlService.Enabled := False;

  // Location
  Id3LocLab.Visible := Id3LocF.Visible;
  If Id3LocF.Visible Then
  Begin

//working here - sort out this mess:-

    If (Not Syss.InpPack) then
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
  End; // If Id3LocF.Visible

  // Quantities
  Id3PQtyF.Visible := Syss.InpPack And (EnterpriseLicence.elModuleVersion <> mvBase);
  Id3PQtyF.DecPlaces := Syss.NoQtyDec;
  Id3PQLab.Visible := Id3PQtyF.Visible;

  Id3QtyLab.Visible := Id3QtyF.Visible;
  Id3QtyF.DecPlaces:=Syss.NoQtyDec;

  // Unit Price
  Id3UPriceF.DecPlaces := IfThen (LID.IdDocHed In PurchSplit, Syss.NoCosDec, Syss.NoNetDec);

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
  Set_DefaultVAT(Id3VATF.Items,BOn,BOff);
  Set_DefaultVAT(Id3VATF.ItemsL,BOn,BOn);

  // CC/Dept
  Id3CCF.Visible := Syss.UseCCDep;
  Id3DepF.Visible := Id3CCF.Visible;
  If (Not Id3CCF.Visible) then
    VATCCLab3.Caption := CCVATName^   // VAT only
  else
    VATCCLab3.Caption := CCVATName^+VATCCLab3.Caption;  // VAT + CC/Dept

  // Cost Price / Uplift
  Id3CostF.Visible := Show_CMG(LID.IdDocHed) or (LID.IdDocHed In PurchSplit);  {* Hide cost if margin pwrd off *}
  Id3CostLab.Visible:=Id3CostF.Visible;
  If Id3CostF.Visible Then
  Begin
    Id3CostF.DecPlaces:=Syss.NoCosDec;
    If (LID.IdDocHed In PurchSplit) then
    Begin
      Id3CostLab.Caption:='Uplift';
      Id3CostF.HelpContext:=740;
    End // If (LID.IdDocHed In PurchSplit)
    Else
      Id3CostLab.Caption:='Cost';
  End; // If Id3CostF.Visible

  // Load Line Types
  Set_DefaultDocT(Id3LTF.Items,BOff,BOff);
  Set_DefaultDocT(Id3LTF.ItemsL,BOff,BOff);

  // Intrastat
  If (Not Syss.IntraStat) then
  Begin
    Label84.Visible:=BOff;
    Label86.Visible:=BOff;
    UseISCb.Visible:=BOff;
    IntBtn.Visible:=BOff;
  end;

  // Delivery/Line Date
  If (Not (LID.IdDocHed In PSOPSet)) then
    DelDateLab.Caption:='Line Date';

  //------------------------------

  // Setup User-Defined fields and container
  SetUDFields(LID.IdDocHed);

  //Id3Panel3.Visible := LUD1F.Visible Or LUD2F.Visible Or LUD3F.Visible Or LUD4F.Visible;

  (*
  //Reduce height of UDF panel if either top 2 or bottom 2 udfs are both hidden.
  If ((Not LUD2F.Visible) and (Not LUD4F.Visible)) or
     ((Not LUD1F.Visible) and (Not LUD3F.Visible)) then
      Id3Panel3.Height:=Id3Panel3.Height-(LUD1F.Height+10);

  //Reduce Width of UDF panel if either left 2 or right 2 udfs are both hidden
  If ((Not LUD3F.Visible) and (Not LUD4F.Visible)) or ((Not LUD2F.Visible) and (Not LUD4F.Visible) {and (JBCostOn)}) or (Not Id3Panel.Visible) then
  Begin
    If (Id3Panel3.Visible) then
    Begin
      If ((Not LUD3F.Visible) and (Not LUD4F.Visible)) or
         ((Not LUD1F.Visible) and (Not LUD2F.Visible)) then
             Id3Panel3.Width:=Id3Panel3.Width-205;
    end;
  *)

  //------------------------------

  // Web Extensions
  pnlWebExtensions.Visible := WebExtensionsOn and (LInv.InvDocHed = PIN);
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

  // Copy colors in from Parent window
  If (Owner is TfrmSOPTrans) then
    With TfrmSOPTrans(Owner) do
      Self.SetFieldProperties(I1FPanel,I1AccF);
end;

//------------------------------

procedure TfrmSOPLine.DisplayId (Const TheInv : InvRec; Const TheId : IDetail);
Var
  lStatus : SmallInt;
  KeyS    : Str255;
Begin { DisplayId }
  LInv := TheInv;
  LID := TheId;

  // Setup the dialog
  ConfigureDialog;

  // Get any additional description lines
  FillChar (LDescLines, SizeOf (LDescLines), #0);

  // Get Stock record where applicable
  If (Trim(LID.StockCode) <> '') Then Begin
    KeyS := FullStockCode(LID.StockCode);
    LStatus := Find_Rec (B_GetEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, KeyS);
  End { If (Trim(LID.StockCode) <> '') }
  Else
    lStatus := -1;

  If (LStatus = 0) Then
    LStock := Stock
  Else
    FillChar(LStock, SizeOf(LStock), #0);

  // Get nominal record
  KeyS := FullNomKey(LID.NomCode);
  LStatus := Find_Rec (B_GetEq, F[NomF], NomF, RecPtr[NomF]^, NomCodeK, KeyS);
  If (LStatus = 0) Then
    LNom := Nom
  Else
    FillChar(LNom, SizeOf(LNom), #0);

  // Set Descriptive Caption
  Caption := EnterpriseData.edCompanyCode + ', ' + LInv.OurRef + ' Transaction Line';

  // Display Fields
  OutId;

  // Show the form
  Show;
End; { DisplayId }

//-------------------------------------------------------------------------

Procedure TfrmSOPLine.OutId;
Begin { OutId }
  With LId Do
  Begin
    Id1ItemF.Text:=Item;
    Id1QtyF.Value:=Qty;

    Id3CCF.Text:=CCDep[BOn];
    Id3DepF.Text:=CCDep[BOff];

    If (VATCode In VATSet) then
      Id3VATF.ItemIndex:=GetVATIndex(VATCode);

    If (ShowCase) and (PrxPack) then
      Id3CostF.Value:=CostPrice*QtyPack
    else
      Id3CostF.Value:=CostPrice;

    Id3NomF.Text:=Form_BInt(NomCode,0);

    GLDescF.Text := LNom.Desc;

    Id3LocF.Text:=MLocStk;

    Id3DelF.DateValue:=PDate;

    Id3SCodeF.Text:=Trim(StockCode);
    Id3Desc1F.Text:=Desc;

    Id3PQtyF.Value := QtyMul;
    Id3QtyF.Value := Ea2Case(LId,LStock,Id1QtyF.Value);
    Id3UPriceF.Value := NetValue;
    Id3DiscF.Text := PPR_PamountStr(Discount,DiscountChr);
    Id3LTotF.Value := InvLTotal(LId,Syss.ShowInvDisc,(LInv.DiscSetl*Ord(LInv.DiscTaken)));

    Id3LTF.ItemIndex:=DocLTLink;

    If (EnterpriseLicence.elModuleVersion = mvSPOP) Then Begin
      // $IFDEF SOP
      UseISCB.Checked:=SSDUseLine;
      IntBtn.Enabled:=SSDUseLine;
    End; { If (EnterpriseLicence.elModuleVersion = mvSPOP) }

    Id5JCodeF.Text:=Trim(JobCode);
    Id5JAnalF.Text:=Trim(AnalCode);

    LUD1F.Text:=LineUser1;
    LUD2F.Text:=LineUser2;
    LUD3F.Text:=LineUser3;
    LUD4F.Text:=LineUser4;
    //GS 17/11/2011 ABSEXCH-12037: put stored UDF values onto the form cotnrols
    LUD5F.Text:=LineUser5;
    LUD6F.Text:=LineUser6;
    LUD7F.Text:=LineUser7;
    LUD8F.Text:=LineUser8;
    LUD9F.Text:=LineUser9;
    LUD10F.Text:=LineUser10;

    // Advanced Discounts
    If (EnterpriseLicence.elModuleVersion = mvSPOP) Then
    Begin
      edtMultiBuy.Text:=PPR_PamountStr(Discount2,Discount2Chr);
      edtTransDiscount.Text:=PPR_PamountStr(Discount3,Discount3Chr);
    End; // If (EnterpriseLicence.elModuleVersion = mvSPOP)

    // EC Services
    pnlService.Visible := SyssVat.VatRates.EnableECServices;
    pnlService.Enabled := False;
    if pnlService.Visible then
    begin
      chkService.Checked := ECService;
      if chkService.Checked then
      begin
        dtServiceStart.DateValue := ServiceStartDate;
        dtServiceEnd.DateValue := ServiceEndDate;
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
    edtReference.Text := tlReference;
    edtReceiptNo.Text := tlReceiptNo;
    edtFromPostcode.Text := tlFromPostCode;
    edtToPostCode.Text := tlToPostCode;
  End; { With LId }
End; { OutId }

//-------------------------------------------------------------------------

procedure TfrmSOPLine.SetUDFields (UDDocHed : DocTypes);
Var
  PNo,n         : Byte;
  UDAry, HDAry  : Array[1..4] of Byte;
Begin { SetUDFields }
  PNo:=1;

  Case UDDocHed of
    SOR,SDN  :  Begin
                  For n:=1 to 4 do
                    UDAry[n]:=14+n;

                  HDAry:=UDAry;
                end;
    POR,PDN  :  Begin
                  For n:=1 to 4 do
                    UDAry[n]:=38+n;

                  HDAry:=UDAry;
                end;
    SQU      :  Begin
                  PNo:=2;

                  For n:=1 to 4 do
                    UDAry[n]:=28+n;

                  HDAry:=UDAry;
                end;
    PQU      :  Begin
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

  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
             [lud1F, lud2F, lud3F, lud4F, lud5F, lud6F, lud7F, lud8F, lud9F, lud10F], DocTypeToCFCategory(UDDocHed, True), True);


End; { SetUDFields }

//-------------------------------------------------------------------------

procedure TfrmSOPLine.SetFieldProperties(Panel  :  TSBSPanel;
                                         Field  :  Text8Pt) ;
Var
  n  : Integer;
Begin
  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TComboBox)
     or (Components[n] is TCurrencyEdit) then
    With TGlobControl(Components[n]) do
      If (Tag>0) then
      Begin
        Font.Assign(Field.Font);
        Color:=Field.Color;
      end;

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do
      Begin
        CheckColor:=Field.Color;
        Color:=Panel.Color;
      end;
  end; {Loop..}
end;

//-------------------------------------------------------------------------

procedure TfrmSOPLine.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.

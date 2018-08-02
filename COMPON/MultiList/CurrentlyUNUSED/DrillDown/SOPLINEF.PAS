unit SOPLineF;

{$ALIGN 1}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, BorBtns, TEditVal, StdCtrls, SBSPanel, Mask, ExtCtrls,
  ComCtrls,
  GlobVar,       // Exchequer global const/type/var
  VarConst,      // Enterprise global const/type/var
  BTRVU2,
  BTSupU1;       // Custom Messages and Misc Btrieve Routines

type
  TfrmSOPLine = class(TForm)
    PageControl1: TPageControl;
    DE3Page: TTabSheet;
    Id3Panel3: TSBSPanel;
    UDF1L: Label8;
    UDF3L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    LineExtF1: TSBSExtendedForm;
    Label85: Label8;
    VATCCLab3: Label8;
    DelDateLab: Label8;
    Label83: Label8;
    Id3CostLab: Label8;
    Label84: Label8;
    Label86: Label8;
    Label81: Label8;
    Label82: Label8;
    Id3VATF: TSBSComboBox;
    Id3DepF: Text8Pt;
    Id3DelF: TEditDate;
    Id3LTF: TSBSComboBox;
    Id3CostF: TCurrencyEdit;
    UseISCB: TBorCheck;
    IntBtn: TBitBtn;
    Id5JCodeF: Text8Pt;
    Id5JAnalF: Text8Pt;
    GLDescF: Text8Pt;
    Id3CCF: Text8Pt;
    Id3NomF: Text8Pt;
    LUD1F: Text8Pt;
    LUD3F: Text8Pt;
    LUD4F: Text8Pt;
    LUD2F: Text8Pt;
    btnClose: TButton;
    Notebook1: TNotebook;
    Id1Panel: TSBSPanel;
    Id1ItemLab: Label8;
    Id1UPLab: Label8;
    Id1DiscLab: Label8;
    Id1LTotLab: Label8;
    Id1QtyLab: Label8;
    Id1ItemF: Text8Pt;
    Id1QtyF: TCurrencyEdit;
    Id1SBox: TScrollBox;
    Id1Desc1F: Text8Pt;
    Id1Desc2F: Text8Pt;
    Id1Desc3F: Text8Pt;
    Id1Desc4F: Text8Pt;
    Id1Desc5F: Text8Pt;
    Id1Desc6F: Text8Pt;
    Id1UPriceF: TCurrencyEdit;
    Id1DiscF: Text8Pt;
    Id1LTotF: TCurrencyEdit;
    Id3Panel: TSBSPanel;
    Id3SCodeLab: Label8;
    id3LocLab: Label8;
    Id3SCodeF: Text8Pt;
    Id3LocF: Text8Pt;
    Id3SBox: TScrollBox;
    Id3Desc1F: Text8Pt;
    Id3Desc2F: Text8Pt;
    Id3Desc3F: Text8Pt;
    Id3Desc4F: Text8Pt;
    Id3Desc5F: Text8Pt;
    Id3Desc6F: Text8Pt;
    Id3Panel2: TSBSPanel;
    Id3PQLab: Label8;
    Id3QtyLab: Label8;
    Id3UPLab: Label8;
    Id3DiscLab: Label8;
    Id3LTotLab: Label8;
    Id3PQtyF: TCurrencyEdit;
    Id3QtyF: TCurrencyEdit;
    Id3UPriceF: TCurrencyEdit;
    Id3DiscF: Text8Pt;
    Id3LTotF: TCurrencyEdit;
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

Uses EntLicence,     // Global Enterprise Licence object
     EntData,        // Global Enterprise Data object
     MiscU,          // Transaction Total Functions
     SysU2,
     CmpCtrlU,       // Misc Routines for loading/saving Colours & Positions
     ColCtrlU,       // Form Color/Font Properties Window
     InvFSu3U,       // Misc utility functions
     TranSOPF,       // Drill-Down SOP transaction form
     BTSupU2,        // Misc Enterprise Routines
     BTKeys1U;       // Enterprise Search Key utilities

//=========================================================================

procedure TfrmSOPLine.FormCreate(Sender: TObject);
Var
  HideCC : Boolean;
  UseDec : SmallInt;
begin
  // Setup dialog for the Enterprise version
  If (EnterpriseLicence.elModuleVersion = mvBase) Then
    // Non-Stock
    NoteBook1.ActivePage := 'NonStock'
  Else
    // Stock/SPOP
    NoteBook1.ActivePage := 'Stock';

  Set_DefaultVAT(Id3VATF.Items,BOn,BOff);
  Set_DefaultVAT(Id3VATF.ItemsL,BOn,BOn);

  Set_DefaultDocT(Id3LTF.Items,BOff,BOff);
  Set_DefaultDocT(Id3LTF.ItemsL,BOff,BOff);

  HideCC:=Not Syss.UseCCDep;

  Id3CCF.Visible:=Not HideCC;
  Id3DepF.Visible:=Not HideCC;

  If (HideCC) then {* Re-word labels *}
    VATCCLab3.Caption:=CCVATName^
  else
    VATCCLab3.Caption:=CCVATName^+VATCCLab3.Caption;

  Id1QtyF.DecPlaces:=Syss.NoQtyDec;
  Id3QtyF.DecPlaces:=Syss.NoQtyDec;
  Id3PQtyF.DecPlaces:=Syss.NoQtyDec;

  If (JBCostOn) then
  Begin
    Id5JCodeF.MaxLength:=JobKeyLen;
    Id5JAnalF.MaxLength:=AnalKeyLen;
  end
  else
  Begin
    Id5JCodeF.Visible:=BOff;
    Id5JAnalF.Visible:=BOff;
    Label81.Visible:=BOff;
    Label82.Visible:=BOff;
    LineExtF1.FocusFirst:=Id3VATF;

    {* Move up Ext fields here perhaps?*}
  end;

  If (Not Syss.IntraStat) then
  Begin
    Label84.Visible:=BOff;
    Label86.Visible:=BOff;
    UseISCb.Visible:=BOff;
    IntBtn.Visible:=BOff;
  end;

  // Setup User-Defined fields and container
  SetUDFields(LID.IdDocHed);
  Id3Panel3.Visible:=(LUD1F.Visible) or (LUD2F.Visible) or (LUD3F.Visible) or (LUD4F.Visible);
  If (Not LUD2F.Visible) and (Not LUD4F.Visible) then
  Begin
    // Botton 2 udef fields hidden - shrink container up
    If (Not JBCostOn) then
    Begin
      Self.ClientHeight:=Self.ClientHeight-(LUD1F.Height+10);
      Id3Panel3.Height:=Id3Panel3.Height-(LUD1F.Height+10);

      btnClose.Top:=LUD1F.Top;
    end;
  end;

  If ((Not LUD3F.Visible) and (Not LUD4F.Visible)) or ((Not LUD2F.Visible) and (Not LUD4F.Visible) and (JBCostOn)) or (Not Id3Panel3.Visible) then
  Begin
    If (Id3Panel3.Visible) then
    Begin
      If ((Not LUD3F.Visible) and (Not LUD4F.Visible)) then
        Id3Panel3.Width:=Id3Panel3.Width-205;

      If ((Not LUD2F.Visible) and (Not LUD4F.Visible) and (JBCostOn)) then
      Begin
        Id3Panel3.Height:=Id3Panel3.Height-30;

        btnClose.Top:=LUD2F.Top+10;
      end;
    end;

    btnClose.Left:=Round((Width/2)-(btnClose.Width+2));
  end;

  If (Not Id3Panel3.Visible) then
  Begin
    LineExtF1.TabNext:=btnClose;
  end
  else
    If (Not LUD1F.Visible) then
    Begin
      If (LUD2F.Visible) then
        LineExtF1.TabNext:=LUD2F
      else
        If (Not LUD2F.Visible) and (LUD3F.Visible) then
          LineExtF1.TabNext:=LUD3F
        else
          If (Not LUD3F.Visible) and (LUD4F.Visible) then
            LineExtF1.TabNext:=LUD4F;
    end;


  Id3CCF.MaxLength:=CustVATLen;
  Id3DepF.MaxLength:=CustVATLen;


  If (LID.IdDocHed In PurchSplit) then
  Begin
    Id3CostLab.Caption:='Uplift';
    UseDec:=Syss.NoCosDec;
    Id3CostF.HelpContext:=740;
  end
  else
  Begin
    Id3CostLab.Caption:='Cost';
    UseDec:=Syss.NoNetDec;
  end;

  Id1UPriceF.DecPlaces:=UseDec;
  Id3UPriceF.DecPlaces:=UseDec;
  Id3CostF.DecPlaces:=Syss.NoCosDec;

  {* Hide cost if margin pwrd off *}
  Id3CostF.Visible:=Show_CMG(LID.IdDocHed) or (LID.IdDocHed In PurchSplit);

  Id3CostLab.Visible:=Id3CostF.Visible;

  Id3PQtyF.Visible:=Syss.InpPack;
  Id3PQLab.Visible:=Syss.InpPack;

  If (Syss.UseMLoc) then
  Begin
    If (Not Syss.InpPack) then
    Begin
      Id3LocLab.Left:=Id3PQLab.Left;
      Id3LocLab.Top:=Id3PQLab.Top;
      Id3LocLab.Parent:=Id3PQLab.Parent;
      Id3LocLab.Width:=Id3PQLab.Width;

      Id3LocF.Left:=Id3PQtyF.Left;
      Id3LocF.Top:=Id3PQtyF.Top;
      Id3LocF.TabOrder:=Id3PQtyF.TabOrder;

      Id3SCodeF.Width:=170;
      Id3SCodeF.PosArrows;

    end
  end;

  If (Not (LID.IdDocHed In PSOPSet)) then
    DelDateLab.Caption:='Line Date';

  If (EnterpriseLicence.elModuleVersion <> mvSPOP) Then
    // $IFNDEF SOP}
    Id3LocLab.Visible:=BOff;

  // Set default horizontal position
  With TForm(Owner) do
    Self.Left:=Left+2;

  // Copy colors in from Parent window
  If (Owner is TfrmSOPTrans) then
    With TfrmSOPTrans(Owner) do
      Self.SetFieldProperties(I1FPanel,I1AccF);
end;

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

  // Restore TopMost back to window
  //SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE)

  // Check to see if the TopMost window is a Drill-Down window
  TopWindow := FindControl(PWindowPos(Msg.LParam).hwndInsertAfter);
  If Not Assigned(TopWindow) Then
    // Restore TopMost back to window
    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE);
End;

//-------------------------------------------------------------------------

procedure TfrmSOPLine.DisplayId (Const TheInv : InvRec; Const TheId : IDetail);
Var
  lStatus : SmallInt;
  KeyS    : Str255;
Begin { DisplayId }
  LInv := TheInv;
  LID := TheId;

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
    Id1Desc1F.Text:=Desc;
    Id1UPriceF.Value:=NetValue;

    Id1DiscF.Text:=PPR_PamountStr(Discount,DiscountChr);

    Id1LTotF.Value:=InvLTotal(LId,Syss.ShowInvDisc,(LInv.DiscSetl*Ord(LInv.DiscTaken)));
    Id3CCF.Text:=CCDep[BOn];
    Id3DepF.Text:=CCDep[BOff];

    //Id3NomF.Text:=Form_BInt(NomCode,0);

    If (VATCode In VATSet) then
      Id3VATF.ItemIndex:=GetVATIndex(VATCode);

    If (ShowCase) and (PrxPack) then
      Id3CostF.Value:=CostPrice*QtyPack
    else
      Id3CostF.Value:=CostPrice;

    GLDescF.Text := LNom.Desc;

    Id3LocF.Text:=MLocStk;

    Id3DelF.DateValue:=PDate;

    Id3SCodeF.Text:=Trim(StockCode);
    Id3Desc1F.Text:=Desc;

    Id3PQtyF.Value:=QtyMul;
    Id3QtyF.Value:=Ea2Case(LId,LStock,Id1QtyF.Value);
    Id3UPriceF.Value:=Id1UPriceF.Value;
    Id3DiscF.Text:=Id1DiscF.Text;
    Id3LTotF.Value:=Id1LTotF.Value;

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

  UDF1L.Caption:=Get_CustmFieldCaption(PNo,UDAry[1]);
  UDF1L.Visible:=Not Get_CustmFieldHide(PNo,HDAry[1]);

  LUD1F.Visible:=UDF1L.Visible;

  UDF2L.Caption:=Get_CustmFieldCaption(PNo,UDAry[2]);
  UDF2L.Visible:=Not Get_CustmFieldHide(PNo,HDAry[2]);

  LUD2F.Visible:=UDF2L.Visible;


  UDF3L.Caption:=Get_CustmFieldCaption(PNo,UDAry[3]);
  UDF3L.Visible:=Not Get_CustmFieldHide(PNo,HDAry[3]);;

  LUD3F.Visible:=UDF3L.Visible;


  UDF4L.Caption:=Get_CustmFieldCaption(PNo,UDAry[4]);
  UDF4L.Visible:=Not Get_CustmFieldHide(PNo,HDAry[4]);

  LUD4F.Visible:=UDF4L.Visible;
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

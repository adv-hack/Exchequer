unit frmAdjLineU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,
  VarConst,
  ExWrap1U,
  BTSupU1,
  BorBtns;


type
  TfrmAdjLine = class(TForm)
    A1SCodef: Text8Pt;
    A1PQF: TCurrencyEdit;
    A1QIF: TCurrencyEdit;
    A1LOF: Text8Pt;
    A1GLF: Text8Pt;
    A1UCF: TCurrencyEdit;
    A1QOF: TCurrencyEdit;
    Label81: Label8;
    Id3QtyLab: Label8;
    PQLab: Label8;
    LocLab: Label8;
    Label84: Label8;
    GLLab: Label8;
    Id3SCodeLab: Label8;
    CloseBtn: TButton;
    A1BUF: TBorCheck;
    Label86: Label8;
    UDF1L: Label8;
    UDF6L: Label8;
    THUD1F: Text8Pt;
    THUD6F: Text8Pt;
    UDF2L: Label8;
    UDF7L: Label8;
    THUD2F: Text8Pt;
    THUD7F: Text8Pt;
    UDF3L: Label8;
    UDF8L: Label8;
    THUD3F: Text8Pt;
    THUD8F: Text8Pt;
    Label85: Label8;
    A1SDF: Text8Pt;
    CCLab: Label8;
    A1CCF: Text8Pt;
    DepLab: Label8;
    A1DpF: Text8Pt;
    JCLab: Label8;
    A1JCF: Text8Pt;
    JALab: Label8;
    A1JAF: Text8Pt;
    UDF5L: Label8;
    THUD5F: Text8Pt;
    UDF10L: Label8;
    THUD10F: Text8Pt;
    UDF4L: Label8;
    UDF9L: Label8;
    THUD4F: Text8Pt;
    THUD9F: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CloseBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure WMCustGetRec (var Msg: TMessage); message WM_CustGetRec;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FOrigWidth: Integer;
    JustCreated  :  Boolean;
    SKeypath     :  Integer;
    LastQtyValue :  Double;
    procedure Set_JCFields(ShowThem: Boolean);
    procedure FormDesign;
    procedure SetFieldFocus;
    procedure OutId;
  public
    { Public declarations }
    ExLocal    :  TdExLocal;
    procedure ShowLink(InvR: InvRec; VOMode: Boolean);
    procedure SetFieldProperties(Panel: TSBSPanel; Field: Text8Pt) ;
    function NTRight(Amount: Real): TCurrencyEdit;
    function NTOther(TCE: TObject): TCurrencyEdit;
  end;

implementation

uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BtKeys1U,
  VARRec2U,

  BTSupU2,
  CurrncyU,
  SBSComp2,
  ComnUnit,
  ComnU2,

  frmStkAdjU,
  CmpCtrlU,
  InvListU,
  SysU2,
  CustomFieldsIntF;

{$R *.DFM}

procedure TfrmAdjLine.ShowLink(InvR: InvRec; VOMode: Boolean);
begin
  ExLocal.AssignFromGlobal(IdetailF);
  ExLocal.LGetRecAddr(IdetailF);
  ExLocal.LInv := InvR;

  with ExLocal, Id, LInv do
  begin
    Caption := Pr_OurRef(LInv) + ' Transaction Line';
    LViewOnly := VOMode;
  end;

  OutId;
  JustCreated:=BOff;
end;

{ ========== Build runtime view ======== }
Procedure TfrmAdjLine.Set_JCFields(ShowThem  :  Boolean);
Begin
  A1JCF.Visible := ShowThem;
  A1JAF.Visible := A1JCF.Visible;
  JCLab.Visible := A1JCF.Visible;
  JALab.Visible := A1JCF.Visible;
end;

procedure TfrmAdjLine.FormDesign;
Var
  HideCC:  Boolean;
  VisibleFieldCount: Integer;
begin

  LocLab.Visible:=BOff;
  A1LoF.Visible:=BOff;

  HideCC := not Syss.UseCCDep;

  A1CCF.Visible := not HideCC;
  A1DpF.Visible := not HideCC;

  CCLab.Visible :=A1CCF.Visible;
  DepLab.Visible:=A1CCF.Visible;

  A1PQF.Visible := Syss.InpPack;
  PQLab.Visible := Syss.InpPack;

  Set_JCFields(JBCostOn);

  if (not Syss.AutoValStk) then
  begin
    GLLab.Visible:=BOff;
    A1GLF.Visible:=BOff;
  end;

  A1PQF.DecPlaces:=Syss.NoQtyDec;
  A1QIF.DecPlaces:=Syss.NoQtyDec;
  A1QOF.DecPlaces:=Syss.NoQtyDec;
  A1UCF.DecPlaces:=Syss.NoCosDec;

  //GS 17/11/2011 ABSEXCH-12037: modifed UDF settings code to use the new "CustomFieldsIntF" unit
  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F], cfADJLine, True);

  VisibleFieldCount := NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]);

  //adjust position of controls to compensate for hidden rows of UDFs
  ResizeUDFParentContainer(VisibleFieldCount, 5, self);
  ResizeUDFParentContainer(VisibleFieldCount, 5, CloseBtn);

  //made additional position adjustments if there are under 5 UDFs visible; resolves issues with slack width space
  if VisibleFieldCount < 5 then
  begin
    Self.width := self.width - 130;
    CloseBtn.left := CloseBtn.left - 130;
  end;
end;

procedure TfrmAdjLine.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  JustCreated := BOn;

  SKeypath := 0;

  LastQtyValue := 0;

  ClientHeight := 160;
  ClientWidth := 729;

  with TForm(Owner) do
  begin
    self.Left := Left + 2;
    self.Top  := Top - (self.Height + 2);
    if (self.Top < 2) then
      self.Top := Top + Height + 2;
  end;

  If (Owner is TfrmStkAdj) then
    With TfrmStkAdj(Owner) do
      Self.SetFieldProperties(A1FPanel,A1YRefF);

  FormDesign;

end;

procedure TfrmAdjLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SendMessage ((Owner As TForm).Handle, WM_CustGetRec, 100, 1);
end;

procedure TfrmAdjLine.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;
end;

procedure TfrmAdjLine.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TfrmAdjLine.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

procedure TfrmAdjLine.WMCustGetRec(var Msg: TMessage);
begin
  with Msg do
  begin
    case WParam of
      0, 169: begin
                if (WParam = 169) then
                begin
                  OutId;
                  WParam := 0;
                end;
              end;
    end;
  end;
  inherited;
end;

Procedure TfrmAdjLine.SetFieldFocus;
begin
  A1SCodeF.SetFocus;
end; {Proc..}

procedure TfrmAdjLine.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

{ ============== Display Id Record ============ }

Procedure TfrmAdjLine.OutId;
var
  FoundOk   :  Boolean;
  FoundCode :  Str20;
Begin
  With ExLocal, Id do
  Begin
    A1SCodeF.Text:=StockCode;
    A1SCodeF.OrigValue:=StockCode;

    A1PQF.Value:=QtyMul;

    A1UCF.Value:=CostPrice;
    A1GLF.Text:=Form_Int(NomCode,0);

    A1CCF.Text:=CCDep[BOn];
    A1DpF.Text:=CCDep[BOff];



    A1JCF.Text:=Strip('R',[#32],JobCode);
    A1JAF.Text:=Strip('R',[#32],AnalCode);

    FoundOk:=GetStock(Self,A1SCodeF.Text,FoundCode,-1);

    If (FoundOk) then
      AssignFromGlobal(StockF);

    A1SDF.Text:=Stock.Desc[1];

    A1QOF.Value:=0;
    A1QIF.Value:=0;

    NTRight(Qty).Value:=Ea2Case(LId,LStock,ABS(Qty));

    A1LoF.Text:=MLocStk;

    A1BuF.Enabled:=((LStock.StockType=StkBillCode) and (Not LStock.ShowasKit));

    A1BuF.Checked:=(KitLink=1);

    If (Not EmptyKey(LInv.DelTerms,MLocKeyLen)) {v5.00 location transfers only work in one direction and (Not ExLocal.LastEdit)} then
    Begin
      A1QIF.Visible:=BOff;
      Id3QtyLab.Visible:=BOff;
      A1BUF.Visible:=BOff;
      Label86.Visible:=BOff;
    end
    else
    Begin
      A1QIF.Visible:=BOn;
      Id3QtyLab.Visible:=BOn;
      A1BUF.Visible:=BOn;
      Label86.Visible:=BOn;
    end;

    If (InAddEdit) and (JBCostOn) then
    Begin
      Set_JCFields((Not A1BuF.Checked));
    end;

    THUd1F.Text:=LineUser1;
    THUd2F.Text:=LineUser2;
    THUd3F.Text:=LineUser3;
    THUd4F.Text:=LineUser4;
    //GS 17/11/2011 ABSEXCH-12037: put customisation values into text boxes
    THUd5F.Text:=LineUser5;
    THUd6F.Text:=LineUser6;
    THUd7F.Text:=LineUser7;
    THUd8F.Text:=LineUser8;
    THUd9F.Text:=LineUser9;
    THUd10F.Text:=LineUser10;

  end;


end;


procedure TfrmAdjLine.SetFieldProperties(Panel  :  TSBSPanel;
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
        {CheckColor:=Field.Color;}
        Color:=Panel.Color;
      end;

  end; {Loop..}


end;


{ ================= Function Return if input should be a debit / Credit ========= }
function TfrmAdjLine.NTRight(Amount:  Real): TCurrencyEdit;
begin
  if (Amount < 0) then
    Result := A1QOF
  else
    Result := A1QIF;
end;


{ ================= Function Return if input should be a debit / Credit ========= }
function TfrmAdjLine.NTOther(TCE: TObject): TCurrencyEdit;
begin
  if (TCE = A1QIF) then
    Result := A1QOF
  else
    Result := A1QIF;
end;

procedure TfrmAdjLine.FormActivate(Sender: TObject);
begin
  If (JustCreated) then
    SetFieldFocus;
  {$IFDEF SOP}
     OpoLineHandle:=Self.Handle;
  {$ENDIF}
end;

end.

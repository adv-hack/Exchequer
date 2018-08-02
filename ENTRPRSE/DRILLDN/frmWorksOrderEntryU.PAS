unit frmWorksOrderEntryU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,
  VarConst,
  ExWrap1U,
  BTSupU1;

type
  TfrmWorksOrderEntry = class(TForm)
    A1SCodef: Text8Pt;
    A1PQF: TCurrencyEdit;
    A1QIF: TCurrencyEdit;
    A1LOF: Text8Pt;
    A1QOF: TCurrencyEdit;
    Label81: Label8;
    Id3QtyLab: Label8;
    PQLab: Label8;
    LocLab: Label8;
    Id3SCodeLab: Label8;
    Candb1Btn: TButton;
    Label85: Label8;
    A1SDF: Text8Pt;
    A1UOF: TCurrencyEdit;
    Label82: Label8;
    A1IssF: TCurrencyEdit;
    Label83: Label8;
    Label84: Label8;
    A1UCF: TCurrencyEdit;
    A1GLF: Text8Pt;
    GLLab: Label8;
    CCLab: Label8;
    A1CCF: Text8Pt;
    DepLab: Label8;
    A1DpF: Text8Pt;
    UDF1L: Label8;
    UDF2L: Label8;
    UDF3L: Label8;
    UDF4L: Label8;
    UDF5L: Label8;
    UDF6L: Label8;
    UDF7L: Label8;
    UDF8L: Label8;
    UDF9L: Label8;
    UDF10L: Label8;
    THUD1F: Text8Pt;
    THUD2F: Text8Pt;
    THUD3F: Text8Pt;
    THUD4F: Text8Pt;
    THUD5F: Text8Pt;
    THUD6F: Text8Pt;
    THUD7F: Text8Pt;
    THUD8F: Text8Pt;
    THUD9F: Text8Pt;
    THUD10F: Text8Pt;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Candb1BtnClick(Sender: TObject);
    procedure WMWindowPosChanged(var Msg : TMessage); Message WM_WindowPosChanged;
  private
    { Private declarations }
    BeenInLocSplit,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;

    LastQtyValue :  Double;

    LocalBOMId   :  Idetail;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure FormDesign;

    procedure SetFieldFocus;

    Procedure OutId;

    {$IFDEF SOP}
      Procedure MLoc_GenLocSplit(Fnum,
                                 Keypath:  Integer);
    {$ENDIF}


  public
    { Public declarations }


    ExLocal    :  TdExLocal;

    procedure ShowLink(InvR: InvRec);

    Function CompStillEdit  :  boolean;

    Procedure ProRataBOMQty(BomId  :  Idetail;
                            LAddr  :  LongInt);

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit,
                        InsMode    :  Boolean);

    procedure SetFieldProperties(Panel  :  TSBSPanel;
                                 Field  :  Text8Pt) ;

    Function NTRight(Amount  :  Real)  :  TCurrencyEdit;


    Function NTOther(TCE  :  TObject)  :  TCurrencyEdit;

  end;

implementation

uses
  ETStrU,
  BtrvU2,
  BTSupU2,
  ComnU2,
  CmpCtrlU,
  SysU2,
  InvListU,
  PWarnU,
  frmWorksOrderU,
  CustomFieldsIntf;

{$R *.DFM}

procedure TfrmWorksOrderEntry.ShowLink(InvR: InvRec);
begin
  ExLocal.AssignFromGlobal(IdetailF);
  ExLocal.LGetRecAddr(IdetailF);
  ExLocal.LInv := InvR;

  with ExLocal, LId, LInv do
  begin
    Caption := Pr_OurRef(LInv) + ' Transaction Line';

    if (Is_StdWOP) then
    begin
      A1IssF.Visible  := BOff;
      Label83.Visible := BOff;
    end;

    if (LineNo = 1)  then
    begin
      if (LastEdit) then
      begin
        Label81.Caption := '  Total Qty Built';
        Label83.Caption := 'Build Qty';

        PQLab.Visible := BOff;
        A1PQF.Visible := BOff;

        Label82.Left := PQLab.Left;
        A1UOF.Left   := A1PQF.Left;

        A1IssF.Visible  := BOn;
        Label83.Visible := BOn;
      end;
    end;


    if (LastEdit) then
    begin
      with A1QIF do
      begin
        TabStop:=BOff;
        ReadOnly:=BOn;
        Color:=clBtnFace;
      end;

      if (QtyDel <> 0.0) then { Stop edit of Location and stock code as soon as its issued }
      begin
        with A1LOF do
        begin
          TabStop  := BOff;
          ReadOnly := BOn;
          Color    := clBtnFace;
        end;
        with A1SCodeF do
        begin
          TabStop  := BOff;
          ReadOnly := BOn;
          Color    := clBtnFace;
        end;
      end;
    end;
  end;

  OutId;

  JustCreated:=BOff;

  If (ExLocal.LastEdit) then
    SetFieldFocus;

end;

procedure TfrmWorksOrderEntry.FormDesign;
var
  HideCC: Boolean;
begin
  HideCC := not Syss.UseCCDep;

  A1CCF.Visible := not HideCC;
  A1DpF.Visible := not HideCC;

  CCLab.Visible  := A1CCF.Visible;
  DepLab.Visible := A1CCF.Visible;

  A1PQF.DecPlaces  := Syss.NoQtyDec;
  A1QIF.DecPlaces  := Syss.NoQtyDec;
  A1QOF.DecPlaces  := Syss.NoQtyDec;
  A1UCF.DecPlaces  := Syss.NoCosDec;
  A1UOF.DecPlaces  := Syss.NoCosDec;
  A1IssF.DecPlaces := Syss.NoCosDec;

  A1UCF.Visible   := PChkAllowed_In(143);
  Label84.Visible := A1UCF.Visible;

  // CJS 2011-11-17: ABSEXCH-12037 - OLE Drill-Down UDFields
  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F],             cfWORLine);

  {
  UDF1L.Caption := Get_CustmFieldCaption(2,13);
  UDF1L.Visible := not Get_CustmFieldHide(2,13);

  THUD1F.Visible := UDF1L.Visible;

  UDF2L.Caption := Get_CustmFieldCaption(2,14);
  UDF2L.Visible := not Get_CustmFieldHide(2,14);

  THUD2F.Visible := UDF2L.Visible;

  UDF3L.Caption := Get_CustmFieldCaption(2,15);
  UDF3L.Visible := not Get_CustmFieldHide(2,15);

  THUD3F.Visible := UDF3L.Visible;


  UDF4L.Caption := Get_CustmFieldCaption(2,16);
  UDF4L.Visible := not Get_CustmFieldHide(2,16);

  THUD4F.Visible := UDF4L.Visible;
  }
end;

procedure TfrmWorksOrderEntry.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  JustCreated := BOn;

  SKeypath := 0;

  LastQtyValue := 0;

  Blank(LocalBOMId, sizeof(LocalBOMId));

  // CJS 2011-11-17: ABSEXCH-12037 - OLE Drill-Down UDFields
  // Amended height and width to accommodate new fields.
  ClientHeight := 198;
  ClientWidth  := 618;

  with TForm(Owner) do
    self.Left := Left + 2;

  if (Owner is TfrmWorksOrder) then
    with TfrmWorksOrder(Owner) do
      self.SetFieldProperties(A1FPanel, A1YRefF);

  BeenInLocSplit := BOff;

  FormDesign;
end;




procedure TfrmWorksOrderEntry.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  GenCanClose(self, Sender, CanClose, BOn);

  if (CanClose) then
    Send_UpdateList(BOff, 100);
end;

procedure TfrmWorksOrderEntry.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfrmWorksOrderEntry.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;
end;



procedure TfrmWorksOrderEntry.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TfrmWorksOrderEntry.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

procedure TfrmWorksOrderEntry.Send_UpdateList(Edit: Boolean; Mode: Integer);
begin
  SendMEssage((Owner as TForm).Handle, WM_CustGetRec, Mode + 100, Ord(Edit));
end; {Proc..}



Procedure TfrmWorksOrderEntry.SetFieldFocus;

Begin
  If (Not ExLocal.LastEdit) or (Not A1IssF.Visible) then
  Begin
    If (A1SCodeF.CanFocus) and (Not A1SCodeF.ReadOnly) then
      A1SCodeF.SetFocus;
  end
  else
    If (A1IssF.CanFocus) then
      A1IssF.SetFocus;

end; {Proc..}


Function TfrmWorksOrderEntry.CompStillEdit  :  boolean;

Var
  Loop  :  Integer;

Begin
  Result:=BOff;

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is Text8Pt) then
    Begin
      Result:=Text8Pt(Components[Loop]).StillEdit;
    end
      else
        If (Components[Loop] is TCurrencyEdit) then
        Begin
          Result:=TCurrencyEdit(Components[Loop]).StillEdit;
        end;

    If (Result) then
      Break;
  end;

end;

procedure TfrmWorksOrderEntry.Candb1BtnClick(Sender: TObject);
begin
  Close;
end;

{ ============== Display Id Record ============ }

Procedure TfrmWorksOrderEntry.OutId;

Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

Begin
  With ExLocal,LId do
  Begin
    A1SCodeF.Text:=StockCode;
    A1SCodeF.OrigValue:=StockCode;

    A1PQF.Value:=QtyMul;

    A1UCF.Value:=CostPrice;
    A1GLF.Text:=Form_Int(NomCode,0);

    A1CCF.Text:=CCDep[BOn];
    A1DpF.Text:=CCDep[BOff];



    FoundOk:=GetStock(Self,A1SCodeF.Text,FoundCode,-1);

    If (FoundOk) then
      AssignFromGlobal(StockF);

    If (LineNo=1) then
      A1SDF.Text:=Desc
    else
      A1SDF.Text:=Stock.Desc[1];

    A1QIF.Value:=Qty;

    If (LineNo<>1) then
      A1QOF.Value:=QtyDel
    else
      A1QOF.Value:=QtyWOff;

    A1UOF.Value:=QtyPWOff;

    {If (QtyPick=0.0) and (LastEdit) then
    Begin
      If (LineNo=1) then
        QtyPick:=BuildQty_OS(LId)
      else
        QtyPick:=Qty_OS(LId);
    end;}

    A1IssF.Value:=QtyPick;

    A1LoF.Text:=MLocStk;

    THUd1F.Text:=LineUser1;
    THUd2F.Text:=LineUser2;
    THUd3F.Text:=LineUser3;
    THUd4F.Text:=LineUser4;

    // CJS 2011-11-17: ABSEXCH-12037 - OLE Drill-Down UDFields
    THUd5F.Text:=LineUser5;
    THUd6F.Text:=LineUser6;
    THUd7F.Text:=LineUser7;
    THUd8F.Text:=LineUser8;
    THUd9F.Text:=LineUser9;
    THUd10F.Text:=LineUser10;

    JustCreated:=BOff;
  end;

  
end;



(*  Add is used to add Notes *)

procedure TfrmWorksOrderEntry.ProcessId(Fnum,
                            Keypath     :  Integer;
                            Edit,
                            InsMode     :  Boolean);
Begin
end; {Proc..}





Procedure TfrmWorksOrderEntry.ProRataBOMQty(BomId  :  Idetail;
                                 LAddr  :  LongInt);
Begin
end;





{$IFDEF SOP}
{ ==== Proc to Generate Automatic ==== }

  Procedure TfrmWorksOrderEntry.MLoc_GenLocSplit(Fnum,
                                      Keypath:  Integer);

  Begin
  end;
{$ENDIF}


procedure TfrmWorksOrderEntry.SetFieldProperties(Panel  :  TSBSPanel;
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
  end; {Loop..}
end;

Function TfrmWorksOrderEntry.NTRight(Amount  :  Real)  :  TCurrencyEdit;
Begin
  If (Amount<0) then
    NTRight:=A1QOF
  else
    NTRight:=A1QIF;
end;

Function TfrmWorksOrderEntry.NTOther(TCE  :  TObject)  :  TCurrencyEdit;
Begin
  If (TCE=A1QIF) then
    Result:=A1QOF
  else
    Result:=A1QIF;
end;

procedure TfrmWorksOrderEntry.FormActivate(Sender: TObject);
begin
  If (JustCreated) then
    SetFieldFocus;

  {$IFDEF SOP}
     OpoLineHandle:=Self.Handle;
  {$ENDIF}

end;

procedure TfrmWorksOrderEntry.WMWindowPosChanged(var Msg: TMessage);
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
  end; { if self.Visible... }
end;

end.

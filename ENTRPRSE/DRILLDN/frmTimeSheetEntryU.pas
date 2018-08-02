unit frmTimeSheetEntryU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, SBSPanel,
  GlobVar,VarConst,ExWrap1U, ExtCtrls;

type
  TfrmTimeSheetEntry = class(TForm)
    JCode: Text8Pt;
    Label81: Label8;
    JDesc: Text8Pt;
    Label84: Label8;
    NTCCF: Text8Pt;
    NTDepF: Text8Pt;
    btnClose: TButton;
    Chrge: TCurrencyEdit;
    RtCode: Text8Pt;
    Label82: Label8;
    RtDesc: Text8Pt;
    Label85: Label8;
    Label86: Label8;
    Anal: Text8Pt;
    Hrs: TCurrencyEdit;
    Label87: Label8;
    Label83: Label8;
    RtHr: TCurrencyEdit;
    Label88: Label8;
    TCost: TCurrencyEdit;
    Label89: Label8;
    TotChrge: TCurrencyEdit;
    CoCr: TSBSComboBox;
    ChCr: TSBSComboBox;
    Label811: Label8;
    CCLab: Label8;
    Bevel1: TBevel;
    Bevel2: TBevel;
    NarF: Text8Pt;
    Bevel3: TBevel;
    UDF1L: Label8;
    THUD1F: Text8Pt;
    UDF2L: Label8;
    THUD2F: Text8Pt;
    THUD4F: Text8Pt;
    UDF4L: Label8;
    THUD3F: Text8Pt;
    UDF3L: Label8;
    UDF6L: Label8;
    UDF8L: Label8;
    UDF10L: Label8;
    UDF5L: Label8;
    UDF7L: Label8;
    UDF9L: Label8;
    THUD5F: Text8Pt;
    THUD7F: Text8Pt;
    THUD9F: Text8Pt;
    THUD6F: Text8Pt;
    THUD8F: Text8Pt;
    THUD10F: Text8Pt;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure WMWindowPosChanged(var Msg : TMessage); Message WM_WindowPosChanged;
  private
    InPassing,
    JustCreated: Boolean;
    SKeypath: Integer;
    TSEmplRec: JobMiscRec;

    procedure CheckAnalCode(ACode: Str10);
    function FindJPRLevel(JCode: Str10; var UseJCode: Str10): Boolean;
    procedure FormDesign;
    procedure OutId;
    procedure SetChargeFieldDisplay;
  public
    ExLocal: TdExLocal;
    procedure SetFieldProperties(Panel: TSBSPanel; Field: Text8Pt) ;
    procedure ShowLink(InvR: InvRec; JMisc: JobMiscRec);
  end;

implementation

uses
  ETStrU,
  BtrvU2,
  VarJCstU,
  BtKeys1U,
  BTSupU1,
  BTSupU2,
  ComnU2,
  CmpCtrlU,
  MiscU,
  frmTimeSheetU,
  JobSup1U,
  InvListU,
  CustomFieldsIntf
;

{$R *.DFM}

// ----------------------------------------------------------------------------

procedure TfrmTimeSheetEntry.btnCloseClick(Sender: TObject);
begin
  Close;
end;

// ----------------------------------------------------------------------------

procedure TfrmTimeSheetEntry.CheckAnalCode(ACode: Str10);
var
  FoundCode: Str20;
begin
  with ExLocal, LJobMisc^.JobAnalRec do
  begin
    if (JAnalCode <> ACode) then
    begin
      FoundCode := ACode;

      if (GetJobMisc(self.Owner, FoundCode, FoundCode, 2, -1)) then
        AssignFromGlobal(JMiscF);
    end; { if (JAnalCode <> ACode)... }

    if (JAType = 4) then
    begin
      Label87.Caption := 'Hours/Narrative';
      Label88.Caption := 'Cost/Hour';
    end
    else
    begin
      Label87.Caption := 'Qty/Narrative';
      Label88.Caption := 'Unit Cost';
    end; { if (JAType = 4)... }
  end; { with ExLocal... }
end;

// ----------------------------------------------------------------------------

function TfrmTimeSheetEntry.FindJPRLevel(JCode: Str10; var UseJCode: Str10):  Boolean;
const
  Fnum     =  JCtrlF;
  Keypath  =  JCK;
  Fnum2    =  JobF;
  Keypath2 =  JobCatK;
var
  TmpKPath   : Integer;
  TmpRecAddr : LongInt;
  KeyChk,
  KeyS       : Str255;
  TmpJRec    : JobRecType;
begin
  Result := BOff;

  KeyS     := '';
  KeyChk   := '';
  UseJCode := JCode;

  with ExLocal do
  begin
    TmpJRec  := LJobRec^;
    TmpKPath := GetPosKey;

    LPresrv_BTPos(Fnum2, TmpKPath, F[Fnum2], TmpRecAddr, BOff, BOff);

    if (LGetMainRecPos(JobF, JCode)) then
    begin
      KeyChk := JBRCode + JBSubAry[3] + FullEmpKey(JCode);
      KeyS   := KeyChk;
      Status := Find_Rec(B_GetGEq, F[Fnum], Fnum, LRecPtr[Fnum]^, Keypath, KeyS);
      Result := (StatusOk and (CheckKey(KeyChk, KeyS, Length(KeyChk), BOff)));
      if (Result) then
        UseJCode := JCode
      else
        if (not EmptyKey(LJobRec^.JobCat, JobKeyLen)) and
           (LJobRec^.JobCat <> JCode) then
          Result := FindJPRLevel(LJobRec^.JobCat, UseJCode);
    end; { if (LGetMainRecPos(JobF, JCode))... }

    LPresrv_BTPos(Fnum2, TmpKPath, F[Fnum2], TmpRecAddr, BOn, BOn);

    LJobRec^ := TmpJRec;
  end; {With..}
end; {Func..}

// ----------------------------------------------------------------------------

procedure TfrmTimeSheetEntry.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SendMessage((Owner As TForm).Handle, WM_CustGetRec, 100, 1);
  Action := caFree;
end;

// ----------------------------------------------------------------------------

procedure TfrmTimeSheetEntry.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  InPassing   := BOff;
  JustCreated := BOn;
  SKeypath    := 0;

//  ClientHeight := 306;
//  ClientWidth  := 446;

  with TForm(Owner) do
    self.Left := Left + 2;

  if (Owner is TfrmTimeSheet) then
    with TfrmTimeSheet(Owner) do
      self.SetFieldProperties(N1DPanel, N1YRefF);

  FormDesign;
end;

// ----------------------------------------------------------------------------

procedure TfrmTimeSheetEntry.FormDesign;
var
  HideCC  :  Boolean;

  //GS 26/10/2011 ABSEXCH-11706: a copy of pauls user fields function
  //PR: 11/11/2011 Amended to use centralised function EnableUdfs in CustomFieldsIntf.pas ABSEXCH-12129
  // MH 17/10/2011 ABSEXCH-12037: cOPIED IN FROM JobTsi1u.pAS
  procedure SetUDFields;
  var
    VisibleFields: Integer;
    UDFPositionOffset: Integer;
  begin
    //Call ArrangeUDFs to close up gaps caused by disabled fields.
    EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
               [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F],
               cfTSHLine);

    VisibleFields := NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]);

    //adjust the height of the UDEF container and associated controls
    //to remove any blank space caused by hidden UDEF fields
    if VisibleFields < 9 then
    begin
      //- get number of visible fields (10 - VisibleFields)
      //- divide result by 2 to get number of hidden rows (10 - VisibleFields) / 2)
      //- subtract field height from the dialog for each row that is hidden - (25 * ((10 - VisibleFields) / 2))
      UDFPositionOffset := (23 * ((10 - VisibleFields) div 2));

      self.height := self.height - UDFPositionOffset;
      Bevel3.Top := Bevel3.Top - UDFPositionOffset;
      btnClose.Top := btnClose.top - UDFPositionOffset;
      //Candb1Btn.Top := Candb1Btn.Top - UDFPositionOffset;

      //if all UDEFs are hidden, then hide the UDEF field seperator (bevel line) also
      if VisibleFields = 0 then
      begin
        Bevel3.Visible := False;
      end;
    end;
  end;

begin
  {* Set Version Specific Info *}

  {$IFNDEF MC_On}
     ChCr.Visible := BOff;
     CoCr.Visible := BOff;
  {$ELSE}
     Set_DefaultCurr(CoCr.Items,BOff,BOff);
     Set_DefaultCurr(CoCr.ItemsL,BOff,BOn);
     Set_DefaultCurr(ChCr.Items,BOff,BOff);
     Set_DefaultCurr(ChCr.ItemsL,BOff,BOn);
  {$ENDIF}

  HideCC := not Syss.UseCCDep;

  NTCCF.Visible  := not HideCC;
  NTDepF.Visible := not HideCC;
  CCLab.Visible  := NTCCF.Visible;


  // MH 17/10/2011 ABSEXCH-12037: Added additional user defined fields
  SetUDFields;
  (*
  UDF1L.Caption := Get_CustmFieldCaption(2, 21);
  UDF1L.Visible := not Get_CustmFieldHide(2, 21);

  THUD1F.Visible := UDF1L.Visible;

  UDF2L.Caption := Get_CustmFieldCaption(2, 22);
  UDF2L.Visible := not Get_CustmFieldHide(2, 22);

  THUD2F.Visible := UDF2L.Visible;

  UDF3L.Caption := Get_CustmFieldCaption(2, 23);
  UDF3L.Visible := not Get_CustmFieldHide(2, 23);

  THUD3F.Visible := UDF3L.Visible;

  UDF4L.Caption := Get_CustmFieldCaption(2, 24);
  UDF4L.Visible := not Get_CustmFieldHide(2, 24);

  THUD4F.Visible := UDF4L.Visible;
  *)

  Hrs.DecPlaces   := Syss.NoQtyDec;
  Chrge.DecPlaces := Syss.NoNetDec;
  RtHr.DecPlaces  := Syss.NoCosDec;

  SetChargeFieldDisplay;

end;

// ----------------------------------------------------------------------------

procedure TfrmTimeSheetEntry.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;
end;

// ----------------------------------------------------------------------------

procedure TfrmTimeSheetEntry.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

// ----------------------------------------------------------------------------

procedure TfrmTimeSheetEntry.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

// ----------------------------------------------------------------------------

procedure TfrmTimeSheetEntry.OutId;
begin
  with ExLocal, LId do
  begin
    JCode.Text := Trim(JobCode);

    if (LJobRec^.JobCode <> JobCode) then
      LGetMainRecPos(JobF, JobCode);

    JDesc.Text  := LJobRec^.JobDesc;
    RtCode.Text := Trim(StockCode);
    RtDesc.Text := Get_StdPrDesc(StockCode, JCtrlF, JCK, 0);
    Anal.Text   := Trim(AnalCode);

    CheckAnalCode(AnalCode);

    NTCCF.Text  := CCDep[BOn];
    NTDepF.Text := CCDep[BOff];
    NarF.Text   := Desc;
    Hrs.Value   := Qty;

    {$IFDEF MC_On}
    if (Currency > 0) then
      ChCr.ItemIndex := Pred(Currency);

    if (Reconcile > 0) then
      CoCr.ItemIndex := Pred(Reconcile);
    {$ENDIF}

    Chrge.Value    := CostPrice;
    TotChrge.Value := InvLCost(LId);
    RtHr.Value     := NetValue;
    TCost.Value    := DetLTotal(LId, BOn, BOff, 0.0);

    THUd1F.Text := LineUser1;
    THUd2F.Text := LineUser2;
    THUd3F.Text := LineUser3;
    THUd4F.Text := LineUser4;

    // MH 17/10/2011 ABSEXCH-12037: Added additional user defined fields
    THUd5F.Text := LineUser5;
    THUd6F.Text := LineUser6;
    THUd7F.Text := LineUser7;
    THUd8F.Text := LineUser8;
    THUd9F.Text := LineUser9;
    THUd10F.Text := LineUser10;
  end;
end;

// ----------------------------------------------------------------------------

procedure TfrmTimeSheetEntry.SetChargeFieldDisplay;
begin
  with RtHr do
  begin
    Color      := TCost.Color;
    Font.Color := TCost.Font.Color;
  end;
  with ChCr do
  begin
    Color      := TCost.Color;
    Font.Color := TCost.Font.Color;
  end;
end;

// ----------------------------------------------------------------------------

procedure TfrmTimeSheetEntry.SetFieldProperties(Panel: TSBSPanel; Field: Text8Pt) ;
var
  n: Integer;
begin
  for n := 0 to Pred(ComponentCount) do
  begin
    if (Components[n] is TMaskEdit) or (Components[n] is TComboBox) or
       (Components[n] is TCurrencyEdit) then
    with TGlobControl(Components[n]) do
      if (Tag > 0) then
      begin
        Font.Assign(Field.Font);
        Color:=Field.Color;
      end;
  end; { for n := 0 to Pred(ComponentCount) do... }
end;

// ----------------------------------------------------------------------------

procedure TfrmTimeSheetEntry.ShowLink(InvR: InvRec; JMisc: JobMiscRec);
begin
  ExLocal.AssignFromGlobal(IdetailF);
  ExLocal.LGetRecAddr(IdetailF);

  ExLocal.LInv      := InvR;
  ExLocal.LJobMisc^ := JMisc;
  TSEmplRec         := JMisc;

  Caption := Pr_OurRef(ExLocal.LInv)+' Transaction Line';

  OutId;

  JustCreated:=BOff;

end;

procedure TfrmTimeSheetEntry.WMWindowPosChanged(var Msg: TMessage);
var
  TopWindow : TWinControl;
Begin
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

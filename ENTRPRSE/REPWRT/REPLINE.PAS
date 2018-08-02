unit Repline;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,VarConst,SBSComp,SBSComp2,BTSupU1,ExWrap1U,Menus,
  TEditVal, BorBtns, RwOpenF, bkgroup, Mask, Buttons;

type
  TFrmRepLine = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    RlType: TSBSComboBox;
    TabSheet3: TTabSheet;
    SBSGroup4: TSBSGroup;
    FontLbl1: TLabel;
    FontLbl2: TLabel;
    ColorBtn: TButton;
    OkRPBtn: TButton;
    CanCP1Btn: TButton;
    Label87: Label8;
    RlDesc: Text8Pt;
    Label81: Label8;
    RlField: Text8Pt;
    FCDesc: Label8;
    Label88: Label8;
    Label810: Label8;
    CcyLbl: Label8;
    RlCcy: TSBSComboBox;
    Label811: Label8;
    RlDrCr: TBorCheck;
    SBSBackGroup2: TSBSBackGroup;
    RlCalc: TMemo;
    SBSBackGroup3: TSBSBackGroup;
    SBSBackGroup4: TSBSBackGroup;
    Label83: Label8;
    Label85: Label8;
    RlPrnSel: Text8Pt;
    RlRecSel: Text8Pt;
    SBSBackGroup5: TSBSBackGroup;
    RlPrn: TBorCheck;
    Label812: Label8;
    RlSort: Text8Pt;
    RlSumo: TBorCheck;
    RlSelSum: TBorCheck;
    Label813: Label8;
    RlSTot: TBorCheck;
    RlRecBrk: TBorCheck;
    RlMask: Text8Pt;
    RlBrk: TSBSComboBox;
    Label86: Label8;
    RlRef: TCurrencyEdit;
    RlFLen: TCurrencyEdit;
    RlDecs: TCurrencyEdit;
    RlPer: Text8Pt;
    RlYear: Text8Pt;
    Label89: Label8;
    RlItal: TBorCheck;
    RlBold: TBorCheck;
    RlUnder: TBorCheck;
    ColorDialog1: TColorDialog;
    Image1: TImage;
    Label814: Label8;
    RlCLen: TCurrencyEdit;
    SBSPanel1: TSBSPanel;
    Label82: Label8;
    Label84: Label8;
    RlLink: TCurrencyEdit;
    LinkLbl: Label8;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure OkRPBtnClick(Sender: TObject);
    procedure ColorBtnClick(Sender: TObject);
    procedure RlTypeClick(Sender: TObject);
    procedure RlSTotClick(Sender: TObject);
    procedure RlRefExit(Sender: TObject);
    procedure RlFieldExit(Sender: TObject);
    procedure RlPerKeyPress(Sender: TObject; var Key: Char);
    procedure RlPerExit(Sender: TObject);
    procedure RlYearExit(Sender: TObject);
    procedure RlSortKeyPress(Sender: TObject; var Key: Char);
    procedure RlSortExit(Sender: TObject);
    procedure RlCLenExit(Sender: TObject);
    procedure RlBoldClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure RlFLenExit(Sender: TObject);
    procedure RlRecSelKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PageControl1Change(Sender: TObject);
    procedure RlLinkExit(Sender: TObject);
    procedure RlLinkKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure F2Popup(Sender: TObject);
  private
    { Private declarations }
    StoreCoord,
    LastCoord,
    StopPageChange,
    SetDefault,
    GotCoord,
    CanDelete    :  Boolean;

    RKeypath     : Integer;

    DispMode     : SmallInt;

    TmpFCode     : ShortString;

    IsPeriod     : Boolean;

    LocInpType   : Byte;

    Procedure BuildDesign;

    Procedure Send_UpdateList(WPar, LPar :  Integer);

    Function Current_Page : Integer;
    Procedure OutReport;
    Procedure SetCaption;

    procedure ProcessReport(Fnum, KeyPath : Integer;
                            Edit          : Boolean);
    procedure SetRepStore(EnabFlag, ButnFlg  :  Boolean);
    procedure SetCompRO(      TC      : TComponent;
                        Const TG      : Integer;
                        Const EnabFlg : Boolean);

    Function CheckCompleted (Edit  :  Boolean)  : Boolean;
    Function CheckNeedStore  :  Boolean;
    Function ConfirmQuit  :  Boolean;

    Procedure Form2Report;

    procedure StoreReport(Fnum, KeyPAth : Integer;
                          Edit          : Boolean);

    procedure SetFieldFocus;

    Procedure ProcessFieldCode (Const FieldCode : ShortString);

    Procedure Msg(Const MsgNo : Byte);

    function vRlRef : Boolean;
    Function vRlField(ShowM : Boolean) : Boolean;
    Function vRlInpLink(ShowM : Boolean) : Boolean;
    Function vRlPer : Boolean;
    Function vRlYear : Boolean;
    Function vRlFLen : Boolean;
    Function vRlCLen : Boolean;
    Function vRlSort : Boolean;

    procedure UpdateRepWidth (ChangeBy : Integer);
    Function RecalcColWidth (Const DLen : SmallInt) : SmallInt;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;
  public
    { Public declarations }

    ExLocal : TdExLocal;

    procedure SetFieldProperties;

    procedure FormDesign;

    procedure ShowLink;

    Procedure ChangePage(NewPage  :  Integer);

    Procedure EditLine (Const Edit : Boolean);
    Procedure DeleteRep;
  end;


Procedure SetRepLineDets(Control : TControl; RepRec : RepGenPtr; Mode : SmallInt);
Function GetDDField (Const ShortCode : ShortString; Var DataRec : DataDictRec) : Boolean;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  BtrvU2,
  BTSupU2,
  CmpCtrlU,

  RwListU,

  {VarRPosU,}
  VarFPosU,
  RpCommon,
  RepLsp3U,
  RwFuncs;


{$R *.DFM}

Const
  HeadPage = 0;
  MiscPage = 1;
  FontPage = 2;
  CalcStr = 'Calculation';

Var
  RepLineCtrl : TControl;    { Used for getting the colors from the parent list }
  ReportRec   : RepGenPtr;
  TmpMode     : SmallInt;


Function GetDDField (Const ShortCode : ShortString; Var DataRec : DataDictRec) : Boolean;
Const
  FNum    = DictF;
  KeyPath = DIK;
Var
  KeyS                : Str255;
  TmpStat, TmpRecAddr : LongInt;
  KP                  : Integer;
begin
  { Save Position }
  //PR 08/12/04 - KP was uninitialised and causing crash when layout was printed.
  KP := GetPosKey;
  TmpStat:=Presrv_BTPos(Fnum, KP, F[Fnum], TmpRecAddr, BOff, BOff);

  { Build index for variable record }
  KeyS := 'DV' + ShortCode;

  { Get Record (Cross Fingers) }
  Status := Find_Rec (B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
  If (Status = 0) Then
    DataRec := DictRec^
  Else
    FillChar (DataRec, SizeOf (DataRec), #0);

  Result := (Status = 0);

  { Restore Position }
  TmpStat:=Presrv_BTPos(Fnum, KP, F[Fnum], TmpRecAddr, BOn, BOff);
End;

{ Sets the local handle to the passed control }
Procedure SetRepLineDets(Control : TControl; RepRec : RepGenPtr; Mode : SmallInt);
Begin
  RepLineCtrl := Control;
  ReportRec := RepRec;
  TmpMode := Mode;
End;

Procedure TFrmRepLine.Msg(Const MsgNo : Byte);
Const
  BlankStr = ' cannot be left blank';
  NumStr   = 'number of ';
  OffStr   = ' for the offset';
  SpecStr  = 'must be specified';
  TheStr   = 'The ';
  ValidStr = 'A valid ';
Var
  MsgStr : ShortString;
Begin
  Case MsgNo Of
    1  : MsgStr := ValidStr + NumStr + 'years ' + SpecStr + OffStr;
    2  : MsgStr := ValidStr + 'year ' + SpecStr;
    3  : MsgStr := ValidStr + 'Sort Order ' + SpecStr;
    4  : MsgStr := ValidStr + NumStr + 'periods ' + SpecStr + OffStr;
    5  : MsgStr := ValidStr + 'period number ' + SpecStr;
    6  : MsgStr := TheStr + 'Field Code' + BlankStr;
    7  : MsgStr := ValidStr + 'Field Code ' + SpecStr;
    8  : MsgStr := ValidStr + 'Field Length ' + SpecStr;
    9  : MsgStr := ValidStr + 'Field Width ' + SpecStr;
    11 : MsgStr := TheStr + 'Field Type ' + SpecStr;
    16 : MsgStr := TheStr + 'Currency ' + SpecStr;
    18 : MsgStr := TheStr + 'Calculation' + BlankStr;
    19 : MsgStr := ValidStr + 'Input Link Field ' + SpecStr;
  End; { Case }

  MessageDlg(MsgStr + '!', mtWarning, [mbOk], 0);
End;

{ == Procedure to Send Message to Get Record == }
Procedure TFrmRepLine.Send_UpdateList(WPar, LPar :  Integer);
Var
  Message1 :  TMessage;
  MessResult :  LongInt;
Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do Begin
    MSg:=WM_CustGetRec;
    WParam := 100 + WPar;
    LParam := LPar;
  end;

  With Message1 do
    MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);
end; {Proc..}

Procedure TFrmRepLine.SetCaption;
Begin
  With ExLocal Do
    Caption := 'Report Details';
End;

procedure TFrmRepLine.ShowLink;
begin
  ExLocal.AssignFromGlobal(RepGenF);
  ExLocal.LGetRecAddr(RepGenF);

  CanDelete:=Ok2DelRep (ExLocal.LRepGen^.ReportHed.RepName);

  SetCaption;

  OutReport;

  ExLocal.LastRepGen^:=ExLocal.LRepGen^;
end;


procedure TFrmRepLine.FormDesign;
begin
  Try
    If Assigned(RepLineCtrl) Then
      With (RepLineCtrl As TPanel) Do Begin
        RlRef.Font.Assign (Font);
        RlRef.Color :=  Color;
        SetFieldProperties;
      End; { With }
  Except
    On Exception Do ;
  End;

  { Adjust for multi-currency }
  RlCcy.Visible := ExMultiCcy;
  CcyLbl.Visible := RlCcy.Visible;

  If RlCcy.Visible Then Begin
    { Load Currency List }
    Set_DefaultCurr(RlCcy.Items,Bon,BOff);
    Set_DefaultCurr(RlCcy.ItemsL,BOn,BOn);
  End; { If }
end;

Procedure TFrmRepLine.BuildDesign;
Begin
  { Adjust depending on mode }
  TabSheet1.TabVisible := BOn;
  TabSheet2.TabVisible := BOn;
End;

procedure TFrmRepLine.FormCreate(Sender: TObject);
Var
  n  :  Integer;
begin
  ExLocal.Create;

  DispMode := TmpMode;

  LastCoord:=BOff;
  GotCoord := False;
  StopPageChange:=BOff;

  ClientHeight := 348;
  ClientWidth  := 440;

  MDI_SetFormCoord(TForm(Self));

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;
  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  RlType.ItemsL.Assign(RlType.Items);

  RlBrk.Items.Clear;
  For n := 1 To High (BreakTypL^) Do
    RlBrk.Items.Add (BreakTypL^[n]);

  FormDesign;

  PageControl1.ActivePage := TabSheet1;
end;


procedure TFrmRepLine.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;
end;


procedure TFrmRepLine.FormCloseQuery(Sender: TObject;
                                          var CanClose: Boolean);
Var
  n  : Integer;

begin
  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  Send_UpdateList(0, 0);
end;

procedure TFrmRepLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

{ Sets the colours into all the controls on the Header Tab }
procedure TFrmRepLine.SetFieldProperties;
Var
  n  : Integer;
Begin
  For n:=0 to Pred(ComponentCount) do Begin
    If (Components[n] is TMaskEdit) or
       (Components[n] is TMemo) or
       (Components[n] is TComboBox) or
       (Components[n] is TCurrencyEdit) and
       (Components[n] <> RlRef) Then
    With TGlobControl(Components[n]) do
      If (Tag>0) then Begin
        Font.Assign(RlRef.Font);
        Color:=RlRef.Color;
      End; { If }

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do Begin
        CheckColor:=RlRef.Color;
        Color:=Self.Color;
      end;
  End; { For }
End;


{ Called whenever the Tab Page is changed }
{ Returns the index of the current Tab Page }
Function TFrmRepLine.Current_Page : Integer;
Begin
  Result:=pcLivePage(PageControl1);
end;


{ Called by RepTree to set the Tab Page }
Procedure TFrmRepLine.ChangePage(NewPage  :  Integer);
Begin
  If (Current_Page <> NewPage) then
    With PageControl1 do
      If (Pages[NewPage].TabVisible) then Begin
        ActivePage:=Pages[NewPage];
        PageControl1Change(Self);
      End; { If }
end;

{ Displays the report details }
Procedure TFrmRepLine.OutReport;
Var
  I, J : Integer;
Begin
  With ExLocal, LRepGen^, ReportDet Do Begin
    { Hide tabs where necessary }
    TabSheet1.TabVisible := True;
    TabSheet2.TabVisible := True;

    { MAIN Tab Fields }
    { Field Type }
    Case VarType Of
      'H' : RlType.ItemIndex := 1;
      'R' : RlType.ItemIndex := 0;
    End; { Case }

    { Report Ref }
    RlRef.Value := RepVarNo;
    RlRef.Modified := False;

    { Description }
    RlDesc.Text := Strip ('R', [#0,#32],RepLDesc);

    { Field Code }
    TmpFCode := VarRef;
    LocInpType := InputType;
    RlField.Text := Strip ('B', [#0,#32],VarRef);
    ProcessFieldCode (VarRef);

    { Input Link }
    RlLink.Value := InputLink;

    { Period }
    RlPer.Text  := RepLPr[BOff];
    If (Trim(RepLPr[BOn]) <> '') Then Begin
      Val(RepLPr[BOn], I, J);
      If (J = 0) Then Begin
        If (I > 0) And (Trim(RepLPr[BOn])[1] <> '+') Then
          RlYear.Text := FullYear(I)
        Else
          RlYear.Text := Trim(RepLPr[BOn]);
      End; { If }
    End; { If }

    { Currency }
    If ExMultiCcy Then
      RlCcy.ItemIndex:=RepLCr;

    { Field Length }
    RlCLen.Value := VarLen;
    RlFLen.Value := MMWidth;

    { Decimal Places }
    RlDecs.Value := NoDecs;

    { Debit/Credit }
    RlDrCr.Checked := CDrCr;

    { Calculation }
    If CalcField Then
      RlCalc.Text := Strip ('R', [#0,#32],VarSubSplit)
    Else
      RlCalc.Text := '';

    { FIELD SETUP Tab Fields }
    { Sort Order }
    RlSort.Text := SortOrd;

    { Format Mask }
    RlMask.Text := Format;

    { Break On Change }
    RlBrk.ItemIndex := Pred(Break);

    { Print Field }
    RlPrn.Checked := PrintVar;

    { Sub-Total }
    RlSTot.Checked := SubTot;
    RlSTotClick (Self);
      
    { Recalc On Break }
    RlRecBrk.Checked := RecalcBTot;

    { Summary Only }
    RlSumo.Checked := Summary;

    { Select On Summary }
    RlSelSum.Checked := ApplyPSumm;

    { Record Selection }
    RlRecSel.Text := Strip ('R', [#0,#32],RecSelect);

    { Print Selection }
    RlPrnSel.Text := Strip ('R', [#0,#32],PrintSelect);

    { FONT Tab Fields }
    { Font }
    CopyFont (FontLbl1.Font, ReportRec.ReportHed.DefFont, False); { copy font to labels }
    FontLbl1.Font.Style := TFontStyles(WinFont.fStyle);
    FontLbl1.Font.Color := TColor(WinFont.fColor);
    FontLbl2.Font.Assign (FontLbl1.Font);
    RlBold.Checked := (fsBold In TFontStyles(WinFont.fStyle));
    RlItal.Checked := (fsItalic In TFontStyles(WinFont.fStyle));
    RlUnder.Checked := (fsUnderline In TFontStyles(WinFont.fStyle));
  End; { With }
End;

Procedure TFrmRepLine.ProcessFieldCode (Const FieldCode : ShortString);
Var
  DataRec : DataDictRec;
Begin
  RlCalc.Enabled := (Trim(FieldCode) = '+');

  IsPeriod   := False;
  LocInpType := 0;

  If (Trim(FieldCode) <> '+') Then
    If GetDDField (FieldCode, DataRec) Then
      With DataRec.DataVarRec Do Begin
        FCDesc.Caption := VarDesc;

        IsPeriod := PrSel;

        LocInpType := InputType;

        RlPer.Enabled := (DispMode <> 3) And PrSel;
        RlYear.Enabled := RlPer.Enabled;
        RlCcy.Enabled := RlPer.Enabled And ExMultiCcy;

        RlCLen.Value := VarLen;

        Case VarDecType of
          1 : RlDecs.Value := Syss.NoCosDec;
          2 : RlDecs.Value := Syss.NoNetDec;
          3 : RlDecs.Value := Syss.NoQtyDec;
        Else
          RlDecs.Value := VarNoDec;
        End; {Case..}

        RlDecs.Enabled := (VarType In [2, 3]); { Real/Double}

        RlDrCr.Enabled :=  (VarType In [2, 3]); { Real/Double}

        If (Trim(FieldCode) <> Trim(TmpFCode)) And (Not RlMask.Modified) Then Begin
          If (VarType In [2, 3, 6, 7, 8]) Then
            { number }
            RlMask.Text := 'R'
          Else
            RlMask.Text := 'L';
        End; { If }

        If (Trim(RlDesc.Text) = '') Then
          RlDesc.Text := Strip('R', [#0,#32], RepDesc);

        { Do Guestimate! for length }
        If (Trim(FieldCode) <> Trim(TmpFCode)) Or (RlFLen.Value < 1) Then Begin
          RlFLen.Value := RecalcColWidth(Round(RlCLen.Value));
        End; { If }

        { Check for input type }
        If (LocInpType > 0) Then Begin
          RlLink.Enabled := (DispMode <> 3);

          LinkLbl.Caption := 'Link To ' + RepInpTypesL^[LocInpType];
        End { If }
        Else Begin
          LinkLbl.Caption := 'Input Link';
          RlLink.Enabled := False;
        End; { Else }

        TmpFCode := FieldCode;
      End { With }
    Else Begin
      { Cannot load record }
      FCDesc.Caption := '';
      RlPer.Enabled := False;
      RlYear.Enabled := False;
      RlCcy.Enabled := False;
      RlDrCr.Enabled := False;
      RlLink.Enabled := False;
    End { Else }
  Else Begin
    { Calculation }
    FCDesc.Caption := CalcStr;

    If (Trim(FieldCode) <> Trim(TmpFCode)) Or (RlCLen.Value < 1) Or (RlFLen.Value < 1) Then Begin
      RlCLen.Value := 13;
      RlDecs.Value := 2;
      RlFLen.Value := RecalcColWidth(Round(RlCLen.Value));

      RlPer.Enabled := False;
      RlYear.Enabled := False;
      RlCcy.Enabled := False;
      RlDecs.Enabled := True;
      RlDrCr.Enabled := True;
      RlLink.Enabled := False;

      If (Trim(RlMask.Text) = '') Then
        RlMask.Text := 'R';
    End; { If }

    TmpFCode := FieldCode;
  End; { Else }
End;

{  Adds / Edits a report }
Procedure TFrmRepLine.EditLine (Const Edit : Boolean);
Begin
  With ExLocal Do Begin
    LastEdit:=Edit;

    If (Not Edit) then
      ChangePage(0);

    ProcessReport(RepGenF,RGK,LastEdit);
  end;
End;


{ Deletes an existing report }
Procedure TFrmRepLine.DeleteRep;
Const
  Fnum  =  RepGenF;
Var
  MbRet         :  Word;
  KeyS          :  Str255;
  Keypath, Widf :  Integer;
Begin
  { need to display record here }
  SetRepStore(BOff,BOff);
  OutReport;
  With ExLocal.LRepGen^.ReportDet Do
    Caption:='Report Field ' + VarType + RepPadNo;

  MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Report Field',
                     mtConfirmation,[mbYes,mbNo],0);


  If (MbRet=MrYes) then
    With ExLocal do Begin
      Keypath:=CurrKeyPath^[Fnum];

      LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

      Report_BError(Fnum,Status);

      Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,Keypath,Fnum,BOn,GlobLocked);

      If (Ok) and (GlobLocked) then Begin
        Widf := LRepGen^.ReportDet.VarLen + 1;
        Status:=Delete_Rec(F[Fnum],Fnum,CurrKeyPath^[Fnum]);

        Report_BError(Fnum,Status);

        If (StatusOk) then Begin
          { Remove column width from report width }
          If (LRepGen.ReportDet.VarType = 'R') Then UpdateRepWidth (-Widf);

          { Update Tree }
          Send_UpdateList(202, 0);

          Close;
        end;
      End; { If }
    End { If }
  Else
    PostMessage (Self.Handle, WM_CLOSE, 0, 0);
End;

procedure TFrmRepLine.ProcessReport(Fnum, KeyPath : Integer;
                                   Edit          : Boolean);
Var
  KeyS     :  Str255;
  n        :  Integer;
  TmpType  :  Char;
Begin
  Addch:=ResetKey;

  KeyS:='';

  RKeypath:=Keypath;

  Elded:=Edit;

  If Edit Or (DispMode = 4) Then Begin
    With ExLocal Do Begin
      LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

      Report_BError(Fnum,Status);

      Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked);
    End; { With }

    If (Not Ok) or (Not GlobLocked) then
      AddCh:=#27;
  End; { If }

  If (Not Edit) Or (DispMode = 4) Then
    BuildDesign;

  If (Addch<>#27) Then
    With ExLocal, LRepGen^ Do Begin
      If (Not Edit) Then Begin
        If (DispMode = 4) Then Begin
          { Inserting - copy type and ref number }
          TmpType := ReportDet.VarType;
          n := ReportDet.RepVarNo;
        End; { If }

        { Adding a report }
        Caption:='Add Report Field';
        LResetRec(Fnum);

        { Set default values here }
        RecPFix := ReportGenCode;
        SubType := RepRepCode;
        With ReportDet Do Begin
          { Set Default values here }
          RepName := ReportRec^.ReportHed.RepName;
          If (DispMode = 4) Then Begin
            VarType := TmpType;
            ReportDet.RepVarNo := n;
          End { If }
          Else Begin
            VarType := 'R';
            RepVarNo := ReportRec^.ReportHed.RLineCount;
          End; { Else }
          Break := 1;
          PrintVar := True;

          WinFont.fStyle := ReportRec^.ReportHed.DefFont.fStyle;
          WinFont.fColor := ReportRec^.ReportHed.DefFont.fColor;
        End; { With }

        CanDelete:=BOn;
      End { If }
      Else
        With ReportDet Do
          Caption:='Report Field ' + VarType + RepPadNo;

      SetRepStore(BOn,BOff);

      OutReport;

      LastRepGen^:=LRepGen^;
      LastDict^:=LDict^;

      SetFieldFocus;
    End; { With }
End;

procedure TFrmRepLine.SetFieldFocus;
Begin
  Case Current_Page Of
    HeadPage : If RlField.CanFocus Then
                 RlField.SetFocus;

    MiscPage : If RlSort.CanFocus Then
                 RlSort.SetFocus;

    FontPage : If ColorBtn.CanFocus Then
                 ColorBtn.SetFocus;
  End; { Case }
End;

procedure TFrmRepLine.SetRepStore(EnabFlag, ButnFlg  :  Boolean);
Var
  Loop  :  Integer;
Begin
  OkRPBtn.Enabled:=EnabFlag;
  CanCP1Btn.Enabled:=EnabFlag;

  ExLocal.InAddEdit:=EnabFlag;

  For Loop:=0 to ComponentCount-1 do Begin
    SetCompRO(Components[Loop],1,EnabFlag);
  end;

  With ExLocal do
    RlRef.ReadOnly:=(DispMode = 4) Or (Not Enabled) Or (Not InAddEdit);
(*
    RlRef.ReadOnly:=(DispMode = 4) Or
                    ((Not Enabled) or (Not CanDelete) and ((Not InAddEdit) or (LastEdit))) ;
*)
end;

procedure TFrmRepLine.SetCompRO(      TC      : TComponent;
                               Const TG      : Integer;
                               Const EnabFlg : Boolean);
Begin
  If (TC is TMaskEdit) then
    With (TC as TMaskEdit) do Begin
      If ((Tag Mod 1000)=TG) then
        ReadOnly:= Not EnabFlg;
    End { With }
  Else
    If (TC is TCurrencyEdit ) then
      With (TC as TCurrencyEdit) do Begin
        If ((Tag Mod 1000)=TG) then
          ReadOnly:= Not EnabFlg;
      End { With }
    Else
      If (TC is TBorCheck) then
        With (TC as TBorCheck) do Begin
          If (Tag=TG) then
            Enabled:=EnabFlg;
        End { With }
      Else
        If (TC is TBorRadio) then
          With (TC as TBorRadio) do Begin
            If (Tag=TG) then
              Enabled:=EnabFlg;
          End { With }
        Else
          If (TC is TSBSComboBox) then
            With (TC as TSBSComboBox) do Begin
              If (Tag=TG) then
                ReadOnly:=Not EnabFlg;
            End { With }
          Else
            If (TC is TButton) then
              With (TC as TButton) do Begin
                If (Tag=TG) then
                  Enabled:=EnabFlg;
              End; { With }
end;

Function TFrmRepLine.ConfirmQuit  :  Boolean;
Var
  MbRet  :  Word;
  TmpBo  :  Boolean;
Begin
  TmpBo:=BOff;

  If ExLocal.InAddEdit and CheckNeedStore then Begin
    If (Current_Page>1) then {* Force view of main page *}
      ChangePage(0);

    mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end
  else
    mbRet:=mrNo;

  Case MbRet of
    mrYes  :  Begin
                StoreReport(RepGenF,RKeypath,ExLocal.LastEdit);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) then
                  Status:=UnLockMLock(RepGenF,0);

                If (InAddEdit) then
                  SetRepStore(BOff,LastEdit);

                TmpBo:=BOn;
              end;

    mrCancel
           :  Begin
                TmpBo:=BOff;
                SetfieldFocus;
              end;
  end; {Case..}

  Result := TmpBo;
end; {Func..}

Function TFrmRepLine.CheckNeedStore  :  Boolean;
Var
  Loop  :  Integer;
Begin
  Result:=BOff;
  Loop:=0;

  While (Loop<=Pred(ComponentCount)) and (Not Result) do Begin
    If (Components[Loop] is TMaskEdit) then
      With (Components[Loop] as TMaskEdit) do Begin
        Result:=(((Tag Mod 1000)=1) and (Modified));

        If (Result) then
          Modified:=BOff;
      End { With }
    Else
      If (Components[Loop] is TCurrencyEdit) then
        With (Components[Loop] as TCurrencyEdit) do Begin
          Result:=(((Tag Mod 1000)=1) and (FloatModified));

          If (Result) then
            FloatModified:=BOff;
        End { With }
      Else
        If (Components[Loop] is TBorCheck) then
          With (Components[Loop] as TBorCheck) do Begin
            Result:=((Tag=1) and (Modified));

            If (Result) then
              Modified:=BOff;
          End { With }
        Else
          If (Components[Loop] is TSBSComboBox) then
            With (Components[Loop] as TSBSComboBox) do Begin
              Result:=((Tag=1) and (Modified));

              If (Result) then
                Modified:=BOff;
            End; { With }

    Inc(Loop);
  end; {While..}
end;

procedure TFrmRepLine.StoreReport(Fnum, KeyPAth : Integer;
                                 Edit          : Boolean);
Var
  COk        : Boolean;
  TmpRep     : RepGenRec;
  ChkCode,
  LastLCode,
  OneLCode,
  KeyS       : Str255;
  MbRet      : Word;
  Moved      : Boolean;


  (*
  Procedure Renumber;
  Var
    TmpRep     : ^RepGenRec;
    KeyS       : Str255;
    TmpFn      : FileVar;
    TmpStat    : Integer;
    TmpRecAddr : LongInt;
  Begin
    With ExLocal, LRepGen^, ReportDet Do Begin
      { look for record matching current record }
      KeyS := Strip('R',[#0,#32],FullRepKey_RGK(ReportGenCode, RepRepCode, ReportKey));
      Status := Find_Rec (B_GetEq, F[Fnum], Fnum, LRecPtr[Fnum]^, RGK, KeyS);

      If StatusOk Then Begin
        Inc(RepVarNo);
        RepPadNo := SetPadNo(Form_Int(RepVarNo, 0), RlRef.MaxLength);
        ReportKey := RepName + VarType + RepPadNo;

        { Save copy of this record }
        New (TmpRep);
        TmpRep^ := ExLocal.LRepGen^;

        { save position - note cannot use exlocal functions because of recursion }
        TmpFn:=F[FNum];
        TmpStat:=Presrv_BTPos(Fnum,KeyPath,TmpFn,TmpRecAddr,BOff,BOff);

        { check for duplicate of this record }
        Renumber;

        { restore position }
        TmpStat:=Presrv_BTPos(Fnum,KeyPath,TmpFn,TmpRecAddr,BOn,BOff);
        Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

        { restore the record }
        ExLocal.LRepGen^ := TmpRep^;
        Dispose (TmpRep);

        { update record }
        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
      End; { If }
    End; { With }
  End;
  *)

  { Update the rep line count on the main report record }
  Procedure UpdRepCount (NewCount : SmallInt);
  Var
    KeyS   : Str255;
    Locked : Boolean;
    VT     : Char;
  Begin
    With ExLocal Do Begin
      { update record held on detail window }
      VT := LRepGen^.ReportDet.VarType;
      Case VT Of
        'R' : ReportRec^.ReportHed.RLineCount := NewCount;
        'H' : ReportRec^.ReportHed.HLineCount := NewCount;
      End; { Case }

      { Save position }
      LGetRecAddr(FNum);

      { update record in file }
      KeyS := FullRepKey_NDX (ReportGenCode, RepGroupCode, ReportRec^.ReportHed.RepName);
      Status := Find_Rec (B_GetEq, F[RepGenF], RepGenF, LRecPtr[RepGenF]^, RGNdxK, KeyS);
      If StatusOk Then Begin
        Ok:=LGetMultiRec(B_GetDirect, B_MultLock, KeyS, KeyPath, Fnum, BOn, Locked);

        If Ok Then Begin
          { Store Position of locked record }
          LGetRecAddr(FNum);

          Case VT Of
            'R' : LRepGen^.ReportHed.RLineCount := NewCount;
            'H' : LRepGen^.ReportHed.HLineCount := NewCount;
          End; { Case }

          { update record }
          Status:=Put_Rec(F[RepGenF], RepGenF, LRecPtr[RepGenF]^, RGNdxK);

          { unlock multiple-lock lock }
          ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);
        End; { If }
      End; { If }

      { restore position }
      Status := LGetDirectRec(FNum, KeyPath);
    End; { If }
  End;

Begin
  KeyS:='';

  Form2Report;

  With ExLocal, LRepGen^, ReportDet do Begin
    If ((Not Edit) Or (LastRepGen.ReportDet.RepVarNo <> RepVarNo)) And (DispMode <> 4) Then Begin
      { Check line with this ID doesn't already exist }
      COK := Not CheckExsists(Strip('R', [#0,#32],FullRepKey_RGK(RecPFix, SubType, ReportKey)),RepGenF,RGK);

      If (Not COK) Then
        MessageDlg('That Report Field already exists!', mtWarning, [mbOk], 0);
    End { If }
    else
      COk:=BOn;

    If (COk) then
      COk:=CheckCompleted(Edit);

    {If (COk) then
    Begin
      COk:=(Not EmptyKey(ReportHed.RepName,RpName.MaxLength));

      If (Not COk) then
        mbRet:=MessageDlg('Report Name not valid!',mtError,[mbOk],0);
    end;}

    If COk Then Begin
      If Edit Then Begin
        {* Re-establish position prior to storing *}
        If (LastRecAddr[Fnum]<>0) Then Begin
          TmpRep:=LRepGen^;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LRepGen^:=TmpRep;
        End; { If }

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        { need to do here while still positioned on the correct record }
        If (StatusOk) Then Send_UpdateList(102, Ord(Moved));

        If (LRepGen.ReportDet.VarType = 'R') Then UpdateRepWidth (LRepGen.ReportDet.VarLen - LastRepGen.ReportDet.VarLen);
      End
      Else Begin
        If (DispMode = 4) Then Begin
          { renumber any existing fields - take copy of local record }
          TmpRep := ExLocal.LRepGen^;

          ChkCode:=PartCCKey(RecPFix,SubType)+PartRepLineKey(VarType,RepName);

          LastLCode:=Strip('B',[#0],ChkCode+'999999');

          OneLCode:=Strip('B',[#0],ChkCode+ReportDet.RepPadNo);

          {Renumber;}

          { Renumbers all lines from this line onwards - to make a gap }
          MoveEmUp(ChkCode, LastLCode, OneLCode, RepVarNo, 1, RepGenF, RGK);

          { restore local record }
          ExLocal.LRepGen^ := TmpRep;
        End; { If }

        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
        CanDelete:=BOn;

        { need to do here while still positioned on the correct record }
        If (StatusOk) Then Send_UpdateList(102, Ord(Moved));

        If (LRepGen.ReportDet.VarType = 'R') Then UpdateRepWidth (LRepGen.ReportDet.VarLen + 1);
      End; { Else }

      SetCaption;

      Report_BError(Fnum,Status);

      LGetRecAddr(Fnum);  {* Refresh record address *}

      {If (StatusOk) then
        Send_UpdateList(102, Ord(Moved));}

      If (Edit) Then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      { update counter on report record }
      If (Not Edit) Then Begin
        If (DispMode <> 4) Then
          UpdRepCount (LRepGen^.ReportDet.RepVarNo + 1)
        Else
          { update record held on detail window }
          Case LRepGen^.ReportDet.VarType Of
            'R' : UpdRepCount (Succ(ReportRec^.ReportHed.RLineCount));
            'H' : UpdRepCount (Succ(ReportRec^.ReportHed.HLineCount));
          End; { Case }
      End; { If }

      SetRepStore(BOff,Edit);

      Cursor:=CrDefault;

      LastValueObj.UpdateAllLastValues(Self);

      { Close window }
      Close;
    End
    Else Begin
      SetFieldFocus;
    End; { Else }
 end; {If..}

end;

{ copies input info into report record }
Procedure TFrmRepLine.Form2Report;
Begin
  With ExLocal.LRepGen^, ReportDet Do Begin
    { Field Type }
    Case RlType.ItemIndex Of
      0 : VarType := 'R';
      1 : VarType := 'H';
    End; { Case }

    { Report Ref }
    RepVarNo := Round(RlRef.Value);
    RepPadNo := SetPadNo(Form_Int(RepVarNo, 0), RlRef.MaxLength);

    { Description }
    RepLDesc := Strip ('R', [#0,#32],RlDesc.Text);

    { Field Code }
    VarRef := LJVar(RlField.Text, RlField.MaxLength);
    CalcField := (VarRef[1] = '+');

    { Input Link }
    InputType := LocInpType;
    InputLink := Trunc(RlLink.Value);

    { Period }
    RepLPr[BOff] := RlPer.Text;
    RepLPr[BOn]  := Copy (RlYear.Text, Length(RlYear.Text) - 1, 2);
    PrSel := (Not CalcField) And IsPeriod;

    { Currency }
    If ExMultiCcy Then
      RepLCr := RlCcy.ItemIndex;

    { Field Length }
    VarLen := Round(RlCLen.Value);
    MMWidth := Round(RlFLen.Value);

    { Decimal Places }
    NoDecs := Round(RlDecs.Value);

    { Debit/Credit }
    CDrCr := RlDrCr.Checked;

    { Calculation }
    VarSubSplit := Strip ('R', [#0,#32],RlCalc.Text);

    { FIELD SETUP Tab Fields }
    { Sort Order }
    SortOrd := RlSort.Text;

    { Format Mask }
    Format := RlMask.Text;

    { Break On Change }
    Break := Succ(RlBrk.ItemIndex);

    { Print Field }
    PrintVar := RlPrn.Checked;

    { Sub-Total }
    SubTot := RlSTot.Checked;

    { Recalc On Break }
    RecalcBTot := RlRecBrk.Checked;

    { Summary Only }
    Summary := RlSumo.Checked;

    { Select On Summary }
    ApplyPSumm := RlSelSum.Checked;

    { Record Selection }
    RecSelect := Strip ('R', [#0,#32], RlRecSel.Text);

    { Print Selection }
    PrintSelect := Strip ('R', [#0,#32], RlPrnSel.Text);

    { FONT Tab Fields }
    { Font }
    With WinFont Do Begin
      fStyle := Byte (FontLbl1.Font.Style);
      fColor := FontLbl1.Font.Color;
    End; { With }

    { Key field }
    ReportKey := RepName + VarType + RepPadNo;
  End; { With }
End;


Function TFrmRepLine.CheckCompleted (Edit  :  Boolean)  : Boolean;
Var
  Test      : Byte;
  n, mbRet  : Word;
  FoundCode : Str20;
  FoundLong : LongInt;
Begin
  Test:=1;

  Result:=BOn;

  While (Test<=11) And (Result) Do
    With ExLocal, LRepGen^, ReportHed Do Begin
      Case Test of
        { Report Type }
        1  :  Result := (RlType.ItemIndex <> -1);

        { Report Ref }
        2  :  Result := vRlRef;

        { Field Code }
        3  :  Result := vRlField(BOn);

        { Period }
        4  :  If RlPer.Enabled Then
                Result := vRlPer
              Else
                Result := BOn;

        { Year }
        5  :  If RlYear.Enabled Then
                Result := vRlYear
              Else
                Result := BOn;

        { Currency }
        6  :  {If ExMultiCcy And RlCcy.Visible And RlCcy.Enabled Then
                Result := (RlCcy.ItemIndex <> -1)
              Else} { no selection = currency 0 }
                Result := BOn;

        { Field Length }
        7  :  Result := vRlFLen;

        { Calculation }
        8  :  If (RlField.Text = '+') Then
                Result := (Trim(RlCalc.Text) <> '')
              Else
                Result := BOn;

        { Sort Order }
        9  :  Result := vRlSort;

        { Column width }
        10 :  Result := vRlCLen;

        11 :  Result := vRlInpLink(BOn);
      End; { Case }

      If Result then
        Inc(Test);
    End; { With }

  If (Not Result) And (Test In [1,6,8]) then
    Msg (Test + 10);
End; { CheckCompleted }

procedure TFrmRepLine.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TFrmRepLine.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TFrmRepLine.OkRPBtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
    With (Sender as TButton) do Begin
      If (ModalResult=mrOk) then
        { OK }
        StoreReport(RepGenF,RGK,ExLocal.LastEdit)
      Else
        { Cancel }
        If (ModalResult=mrCancel) Then Begin
          If (Not ExLocal.LastEdit) Or ConfirmQuit then Begin {* Force close..}
            { Adding or Deleting }
            Close;
            Exit;
          End; { If }
        End; { If }
    End; { With }
End;

procedure TFrmRepLine.ColorBtnClick(Sender: TObject);
begin
  Try
    ColorDialog1.Color := FontLbl1.Font.Color;

    If ColorDialog1.Execute Then Begin
      FontLbl1.Font.Color := ColorDialog1.Color;
      FontLbl2.Font.Assign(FontLbl1.Font);
    End; { If }
  Except
    On Exception Do ;
  End;
end;

procedure TFrmRepLine.RlTypeClick(Sender: TObject);
begin
  If (DispMode = 1) And (Not RlRef.FloatModified) Then Begin
    Case RlType.ItemIndex Of
      0 : RlRef.Value := ReportRec^.ReportHed.RLineCount;
      1 : RlRef.Value := ReportRec^.ReportHed.HLineCount;
    End; { Case }
  End; { If }
end;

procedure TFrmRepLine.RlSTotClick(Sender: TObject);
begin
  RlRecBrk.Enabled := RlSTot.Checked And (DispMode In [1, 2]);
end;

function TFrmRepLine.vRlRef : Boolean;
Var
  COk   :  Boolean;
  CCode :  Str30;
begin
  Result := False;

  With RlRef, ExLocal, LRepGen^, ReportDet do Begin
    If (Trim(Text) <> '') Then Begin
      If (DispMode <> 4) Then Begin
        { Only need to check unique if not inserting }
        CCode:=Strip('R',[#0,#32],FullRepKey_RGK(RecPFix, SubType, FullRepCode(RepName)+VarType+Text));

        { Check to see if code is unique }
        COK := (Not CheckExsists(CCode,RepGenF,RGK));

        If (Not COk) then
          { Its not a valid report code - stay on this page until its ok }
          MessageDlg('A Report Field already exists with that Id!', mtWarning, [mbOk], 0)
        Else
          Result := True;
      End { If }
      Else
        { Inserting a field }
        Result := True;
    End { If }
    Else
      { Code is blank }
      Msg (8);
  End; { With }
end;

procedure TFrmRepLine.RlRefExit(Sender: TObject);
begin
  If (Sender is TMaskEdit) And (Screen.ActiveControl <> CanCP1Btn) then
    vRlRef;
end;

Function TFrmRepLine.vRlField(ShowM : Boolean) : Boolean;
Var
  COk   :  Boolean;
  CCode :  Str30;
  WantS, FindS : Str20;
  DataRec : DataDictRec;
begin
  Result := False;

  With RlField, ExLocal, LRepGen^, ReportDet do Begin
    RlCalc.Enabled := (Trim(Text) = '+');

    { Check its not a calculation }
    If (Trim(Text) <> '+') Then Begin
      { Not a calculation }
      CCode:=Strip('R',[#0,#32],FullRepKey_RGK(RecPFix, SubType, FullRepCode(RepName)+VarType+Text));

      WantS := FullDictCode(Text);
      FindS := '';

      { Check dictionary entry exists }
      COk := GetDict(Self, WantS, FindS, -1, ExVersionNo, ReportRec^.ReportHed.DriveFile);
      If (Not COk) Then COk := GetDict(Self, WantS, FindS, 0, ExVersionNo, ReportRec^.ReportHed.DriveFile);

      If COk Then Begin
        Text := FindS;
        ProcessFieldCode (FindS);
        Result := True;
      End { If }
      Else Begin
        Text := '';
        If ShowM Then Msg (7);
        FCDesc.Caption:='';
      End; { Else }
    End { If }
    Else Begin
      { Calculation }
      Result := True;
      FCDesc.Caption:=CalcStr;
      ProcessFieldCode (RlField.Text);
    End; { Else }
  End; { With }
end;

procedure TFrmRepLine.RlFieldExit(Sender: TObject);
begin
  If (Sender is TMaskEdit) And (Screen.ActiveControl <> CanCP1Btn) then
    If Not vRlField(BOff) And RlField.CanFocus Then
      RlField.SetFocus;
end;

procedure TFrmRepLine.RlPerKeyPress(Sender: TObject; var Key: Char);
Var
  Period : Boolean;
begin
  Period := (Sender = rlPer);

  Key := UpCase (Key);

  If Not (Key In [#8, '0'..'9', '+', '-']) Then
    If Not (Period And (Key In ['C', 'Y', 'T', 'D'])) Then
      Key := #0;
end;

Function TFrmRepLine.vRlPer : Boolean;
Var
  TmpStr       : String;
  I, ErrorCode : Integer;
begin
  Result := False;

  With RlPer, ExLocal, LRepGen^, ReportDet do Begin
    { Check its not blank - Current period }
    If (Trim(Text) <> '') Then Begin
      { Check for Year-To-Date and Current-Year-To-Date }
      If (Trim(Text) <> 'YTD') And (Trim(Text) <> 'CTD') Then Begin
        If (Text[1] In ['+', '-']) Then Begin
          { Period offset }
          If (Length(Text) > 1) Then Begin
            { take copy of number - check its all numbers }
            TmpStr := Copy (Text, 2, Length(Text) - 1);

            { check value in range 1 to syss.number of periods }
            Val (TmpStr, I, ErrorCode);
            If (ErrorCode > 0) Then
              Msg (4)
            Else
              Result := True;
          End { If }
          Else
            Msg (4);
        End { If }
        Else Begin
          { must be period number }
          { check value in range 1 to syss.number of periods }
          Val (Text, I, ErrorCode);
          If (ErrorCode > 0) Or ((ErrorCode = 0) And ((I < 1) Or (I > Syss.PrinYr))) Then
            Msg (5)
          Else
            Result := True;
        End; { Else }
      End { If }
      Else
        Result := True;
    End { If }
    Else
      Result := True;
  End; { With }
end;

procedure TFrmRepLine.RlPerExit(Sender: TObject);
begin
  If (Sender is TMaskEdit) And (Screen.ActiveControl <> CanCP1Btn) then
    vRlPer;
end;

Function TFrmRepLine.vRlYear : Boolean;
Var
  TmpStr       : String;
  I, ErrorCode : Integer;
begin
  Result := False;

  With RlYear, ExLocal, LRepGen^, ReportDet do Begin
    { Check its not blank - Current period }
    If (Trim(Text) <> '') Then Begin
      If (Text[1] In ['+', '-']) Then Begin
        { Period offset }
        If (Length(Text) > 1) Then Begin
          { take copy of number - check its all numbers }
          TmpStr := Copy (Text, 2, Length(Text) - 1);

          { check value in range 1 to syss.number of periods }
          Val (TmpStr, I, ErrorCode);
          If (ErrorCode > 0) Or ((ErrorCode = 0) And ((I < 1) Or (I > 99))) Then
            Msg (1)
          Else
            Result := True;
        End { If }
        Else
          Msg(1);
      End { If }
      Else Begin
        { must be period number }
        { check value in range 1 to syss.number of periods }
        Val (Text, I, ErrorCode);

        If (ErrorCode = 0) Then Begin
          If (I In [0..50]) Then I := I + 2000;
          If (I In [51..150]) Then I := I + 1900;

          If (I >= 1950) And (I <=2150) Then Begin
            Text := Form_Int (I, 0);
            Result := True;
          End { If }
          Else
            Msg (2);
        End { If }
        Else
          Msg(2);
      End; { Else }
    End { If }
    Else
      Result := True;
  End; { With }
end;

procedure TFrmRepLine.RlYearExit(Sender: TObject);
begin
  If (Sender is TMaskEdit) And (Screen.ActiveControl <> CanCP1Btn) then
    vRlYear;
end;

procedure TFrmRepLine.RlSortKeyPress(Sender: TObject; var Key: Char);
begin
  Key := UpCase(Key);

  If Not (Key In [#8, '1'..'9', 'A', 'D']) Then Begin
    {ShowMessage (IntToStr(Ord(Key)));}
    Key := #0;
  End; { If }
end;

Function TFrmRepLine.vRlSort : Boolean;
begin
  Result := False;

  With RlSort Do
    { Check its not blank - Current period }
    If (Trim(Text) <> '') Then Begin
      If (Length(Text) = 2) Then Begin
        If Not ((Text[1] In ['1'..'9']) And (Text[2] In ['A', 'D'])) Then
          Msg (3)
        Else
          Result := True;
      End { If }
      Else
        { Invalid sort command }
        Msg (3);
    End { If }
    Else
      Result := True;
end;

procedure TFrmRepLine.RlSortExit(Sender: TObject);
begin
  If (Sender is TMaskEdit) And (Screen.ActiveControl <> CanCP1Btn) then
    vRlSort;
end;

Function TFrmRepLine.vRlFLen : Boolean;
Var
  I, ErrorCode : Integer;
Begin
  Result := False;

  With RlCLen Do Begin
    I := Round (Value);
    If (I < 1) Or (I > 215) Then
      Msg (8)
    Else
      Result := True;
  End; { With }
End;

Function TFrmRepLine.vRlCLen : Boolean;
Var
  I, ErrorCode : Integer;
Begin
  Result := False;

  With RlFLen Do Begin
    I := Round (Value);
    If (I < 1) Or (I > 215) Then
      Msg (9)
    Else
      Result := True;
  End; { With }
End;

procedure TFrmRepLine.RlCLenExit(Sender: TObject);
begin
  If (Sender is TMaskEdit) And (Screen.ActiveControl <> CanCP1Btn) then
    vRlCLen;
end;

procedure TFrmRepLine.UpdateRepWidth (ChangeBy : Integer);
Const
  FNum    = RepGenF;
  KeyPath : Integer = RGNdxK;
Var
  KeyS       : Str255;
  TmpFn      : FileVar;
  TmpStat    : Integer;
  TmpRecAddr : LongInt;
  Locked     : Boolean;
  TmpRep     : ^RepGenRec;
Begin
  With ExLocal Do Begin
    { update record held on detail window }
    ReportRec^.ReportHed.MaxWidth := ReportRec^.ReportHed.MaxWidth + ChangeBy;

    { Save position }
    New (TmpRep);
    TmpRep^ := ExLocal.LRepGen^;
    LGetRecAddr(FNum);

    { update record in file }
    KeyS := FullRepKey_NDX (ReportGenCode, RepGroupCode, ReportRec^.ReportHed.RepName);
    Status := Find_Rec (B_GetEq, F[FNum], FNum, LRecPtr[FNum]^, KeyPath, KeyS);
    If StatusOk Then Begin
      Ok:=LGetMultiRec(B_GetDirect, B_MultLock, KeyS, KeyPath, Fnum, BOn, Locked);

      If Ok Then Begin
        { Store Position of locked record }
        LGetRecAddr(FNum);

        { Update report width }
        LRepGen^.ReportHed.MaxWidth := LRepGen^.ReportHed.MaxWidth + ChangeBy;
        If (LRepGen^.ReportHed.MaxWidth < 0) Then LRepGen^.ReportHed.MaxWidth := 0;

        { update record }
        Status:=Put_Rec(F[Fnum], Fnum, LRecPtr[Fnum]^, KeyPath);

        { Unlock Multiple-Lock lock }
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

        { update main window }
        Send_UpdateList(9, 0);
      End; { If }
    End; { If }

    { restore position }
    Status := LGetDirectRec(FNum, KeyPath);
    ExLocal.LRepGen^ := TmpRep^;
    Dispose (TmpRep);
  End; { If }
End;

procedure TFrmRepLine.RlBoldClick(Sender: TObject);
begin
  If (Sender = RlBold) Then
    If RlBold.Checked Then
      FontLbl1.Font.Style := FontLbl1.Font.Style + [fsBold]
    Else
      FontLbl1.Font.Style := FontLbl1.Font.Style - [fsBold]
  Else
    If (Sender = RlItal) Then
      If RlItal.Checked Then
        FontLbl1.Font.Style := FontLbl1.Font.Style + [fsItalic]
      Else
        FontLbl1.Font.Style := FontLbl1.Font.Style - [fsItalic]
    Else
      If (Sender = RlUnder) Then
        If RlUnder.Checked Then
          FontLbl1.Font.Style := FontLbl1.Font.Style + [fsUnderline]
        Else
          FontLbl1.Font.Style := FontLbl1.Font.Style - [fsUnderline];

  FontLbl2.Font.Assign(FontLbl1.Font);
end;

procedure TFrmRepLine.FormPaint(Sender: TObject);
begin
  With Image1, Canvas do Begin
    { Draw Page }
    Pen.Color := clBlack;
    Brush.Color := clSilver;
    Rectangle (0, 0, Width, Height);

    { Draw printable area }
    Pen.Color := clWhite;
    Brush.Color := clWhite;
    Brush.Bitmap := NIL;
    Rectangle (1, 1, Width - 1, Height - 1);
  End; { With }
end;

Function TFrmRepLine.RecalcColWidth(Const DLen : SmallInt) : SmallInt;
Var
  TheRect : TRect;
  SizeStr : PChar;
begin
  If (DLen > 0) Then Begin
    { Get size of font }
    SizeStr := StrAlloc (DLen + 1);
    TheRect := Rect (1, 1, 2, 2);
    If (DLen <= 4) Then
      StrPCopy(SizeStr, ConstStr ('W', DLen))
    Else
      StrPCopy(SizeStr, ConstStr ('S', DLen));
    DrawText (FontLbl1.Canvas.Handle, SizeStr, Length(SizeStr), TheRect, (DT_CALCRECT Or DT_SINGLELINE));
    StrDispose (SizeStr);

    { Set control size }
    Result := Round((TheRect.Right - TheRect.Left) / 3);

    If (Result < 3) Then Result := 3;
  End; { If }
end;

procedure TFrmRepLine.RlFLenExit(Sender: TObject);
begin
  If (Sender is TMaskEdit) And (Screen.ActiveControl <> CanCP1Btn) then
    vRlFLen;
end;

Procedure TFrmRepLine.WMCustGetRec(Var Message  :  TMessage);
Begin
  With Message Do
    Case WParam of
      { Sent to change tab page when Ctrl-Page Up/Down is pressed }
      175    : With PageControl1 do
                 ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);
    End; { Case }

  Inherited;
end;

procedure TFrmRepLine.RlRecSelKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var
  TheText   : ShortString;
  FoundCode : Str20;
  oSelStart : SmallInt;
begin
  If (Key = VK_F2) Then Begin
    With ExLocal.LRepGen^.ReportDet Do
      FoundCode := RepName + VarType;

    If GetRepField(Self, FoundCode, FoundCode, RepRepCode, 0) Then Begin
      { Selected a field }

      If Sender Is Text8Pt Then
        With Sender As Text8Pt Do Begin
          TheText := Text;
          oSelStart := SelStart;

          If (Length (SelText) = 0) Then
            { Insert FoundCode at SelStart }
            Insert (FoundCode, TheText, SelStart + 1)
          Else Begin
            { Overwrite selected text }
            Delete (TheText, SelStart + 1, SelLength);
            Insert (FoundCode, TheText, SelStart + 1)
          End; { If }

          Text := TheText;
          SelStart := oSelStart + Length(FoundCode);
        End { With }
      Else
        With Sender As TMemo Do Begin
          TheText := Text;
          oSelStart := SelStart;

          If (Length (SelText) = 0) Then
            { Insert FoundCode at SelStart }
            Insert (FoundCode, TheText, SelStart + 1)
          Else Begin
            { Overwrite selected text }
            Delete (TheText, SelStart + 1, SelLength);
            Insert (FoundCode, TheText, SelStart + 1)
          End; { If }

          Text := TheText;
          SelStart := oSelStart + Length(FoundCode);
        End; { With }
    End; { If }
  End; { If }
end;

procedure TFrmRepLine.PageControl1Change(Sender: TObject);
Var
  TI : Integer;
begin
  SBSPanel1.Parent := PageControl1.ActivePage;
  TI := RlType.ItemIndex;
  RlType.Parent := PageControl1.ActivePage;
  RlType.ItemIndex := TI;
  RlRef.Parent := PageControl1.ActivePage;

  If PageControl1.ActivePage = TabSheet1 Then Begin
    { Main }
    RlType.TabOrder := RlField.TabOrder;
    RlRef.TabOrder := RlField.TabOrder;

    RlType.HelpContext := 15020;
    RlRef.HelpContext := 15021;
  End { If }
  Else Begin
    RlType.HelpContext := 15998;
    RlRef.HelpContext := 15998;
  End; { Else }
  If PageControl1.ActivePage = TabSheet2 Then Begin
    { Field Setup }
    RlType.TabOrder := RlSort.TabOrder;
    RlRef.TabOrder := RlSort.TabOrder;
  End; { If }
  If PageControl1.ActivePage = TabSheet3 Then Begin
    { Font }
    RlType.TabOrder := RlBold.TabOrder;
    RlRef.TabOrder := RlBold.TabOrder;
  End; { If }
end;

procedure TFrmRepLine.RlLinkExit(Sender: TObject);
begin
  If (Sender is TCurrencyEdit) And (Screen.ActiveControl <> CanCP1Btn) then
    If Not vRlInpLink(BOff) And RlLink.CanFocus Then
      RlLink.SetFocus;
end;

{ Validates the Input Link field }
Function TFrmRepLine.vRlInpLink(ShowM : Boolean) : Boolean;
Var
  COk   :  Boolean;
  CCode :  Str30;
  WantS, FindS : Str20;
  DataRec : DataDictRec;

  Function InputLinkOk(InputLink, InputType:Integer) : Boolean;
  Const
    FNum = RepGenF;
    KeyPath : Integer = RGK;
  Var
    OrigRep : RepGenPtr;
    KeyS    : Str255;
    TmpFn   : FileVar;
    TmpStat    : Integer;
    TmpRecAddr : LongInt;
  Begin
    With ExLocal Do Begin
      { Take copy of report record }
      New (OrigRep);
      OrigRep^ := LRepGen^;

      { Save Position }
      TmpFn:=F[FNum];
      TmpStat:=Presrv_BTPos(Fnum,KeyPath,TmpFn,TmpRecAddr,BOff,BOff);

      KeyS := PartCCKey(ReportGenCode,RepLineTyp) +
              FullRepNamKey (OrigRep^.ReportDet.RepName) +
              RepInpCode +
              SetPadNo(Form_Int(InputLink,0),6);

      Status:=Find_Rec(B_GetEq, F[FNum], FNum, RecPtr[FNum]^, KeyPath, KeyS);

      InputLinkOk := StatusOk And (RepGenRecs^.ReportDet.RepLiType = InputType);

      { Restore Position }
      TmpStat:=Presrv_BTPos(Fnum,KeyPath,TmpFn,TmpRecAddr,BOn,BOff);
      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}


      { Restore report record }
      RepGenRecs^ := OrigRep^;
      Dispose (OrigRep);
    End; { With }
  End;


begin
  { Is AOK if not enabled or if no Input Link is required }
  Result := (Not RlLink.Enabled) Or (LocInpType = 0);

  If (Not Result) Then Begin
    { Check value of RlLink field }
    Result := InputLinkOk(Trunc(RlLink.Value), LocInpType);

    If (Not Result) And ShowM Then
      Msg (19);
  End; { If }
end;


procedure TFrmRepLine.RlLinkKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var
  TheText   : ShortString;
  FoundCode : Str20;
  oSelStart : SmallInt;
begin
  If (Key = VK_F2) Then Begin
    With ExLocal.LRepGen^.ReportDet Do
      FoundCode := RepName + 'I';

    If GetRepField(Self, FoundCode, FoundCode, RepLineTyp, 0) Then Begin
      { Selected a field - returned as I1 }
      RlLink.Text := Copy (FoundCode, 2, Pred(Length(FoundCode)));
    End; { If }
  End; { If }
end;

procedure TFrmRepLine.F2Popup(Sender: TObject);
Var
  KPress : Word;
begin
  If Screen.ActiveControl Is TMemo Then
    With Screen.ActiveControl As TMemo Do Begin
      If Assigned(OnKeyDown) Then Begin
        KPress := VK_F2;
        OnKeyDown(Screen.ActiveControl, KPress, []);
      End; { If }
    End { With }
  Else
    If Screen.ActiveControl Is Text8Pt Then
      With Screen.ActiveControl As Text8Pt Do Begin
        If Assigned(OnKeyDown) Then Begin
          KPress := VK_F2;
          OnKeyDown(Screen.ActiveControl, KPress, []);
        End; { If }
      End { With }
end;

end.

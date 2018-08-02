unit RepInp;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,VarConst,SBSComp,SBSComp2,BTSupU1,ExWrap1U,Menus,
  TEditVal, BorBtns, RwOpenF, bkgroup, Mask;

type
  TFrmInpLine = class(TForm)
    OkRPBtn: TButton;
    CanCP1Btn: TButton;
    SBSBackGroup2: TSBSBackGroup;
    SBSBackGroup1: TSBSBackGroup;
    Label84: Label8;
    Label87: Label8;
    LblInp: Label8;
    RiDesc: Text8Pt;
    RiRef: TCurrencyEdit;
    CcyLbl: Label8;
    RiType: TSBSComboBox;
    EditDate1: TEditDate;
    EditDate2: TEditDate;
    EditPeriod1: TEditPeriod;
    EditPeriod2: TEditPeriod;
    CurrencyEdit1: TCurrencyEdit;
    CurrencyEdit2: TCurrencyEdit;
    ext8Pt1: Text8Pt;
    ext8Pt2: Text8Pt;
    Label86: Label8;
    RiCcy1: TSBSComboBox;
    RiCcy2: TSBSComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure OkRPBtnClick(Sender: TObject);
    procedure RlRefExit(Sender: TObject);
    procedure RiTypeClick(Sender: TObject);
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

    { Temporary handles onto controls being used for input }
    Inp1, Inp2 : TWinControl;

    Procedure BuildDesign;

    Procedure Send_UpdateList(WPar, LPar :  Integer);

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

    Procedure Msg(Const MsgNo : Byte);

    function vRlRef : Boolean;

    Function TrueInpType : SmallInt;

    procedure OKExit(Sender: TObject);
    procedure CustSuppExit(Sender: TObject);
    procedure StockExit(Sender: TObject);
    procedure CCDepExit(Sender: TObject);
    procedure NomExit(Sender: TObject);
    procedure LocExit(Sender: TObject);
    procedure JobExit(Sender: TObject);
  public
    { Public declarations }

    ExLocal : TdExLocal;         

    procedure SetFieldProperties;

    procedure FormDesign;

    procedure ShowLink;

    Procedure EditLine (Const Edit : Boolean);
    Procedure DeleteRep;
  end;


Procedure SetInpLineDets(Control : TControl; RepRec : RepGenPtr; Mode : SmallInt);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  BtrvU2,
  BTSupU2,
  CmpCtrlU,

  InvListU,
  RwListU,

  {VarRPosU,}
  VarFPosU,
  RpCommon,
  RepLsp3U,
  RwFuncs;


{$R *.DFM}


Var
  RepLineCtrl : TControl;    { Used for getting the colors from the parent list }
  ReportRec   : RepGenPtr;
  TmpMode     : SmallInt;


{ Sets the local handle to the passed control }
Procedure SetInpLineDets(Control : TControl; RepRec : RepGenPtr; Mode : SmallInt);
Begin
  RepLineCtrl := Control;
  ReportRec := RepRec;
  TmpMode := Mode;
End;

Procedure TFrmInpLine.Msg(Const MsgNo : Byte);
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
  End; { Case }

  MessageDlg(MsgStr + '!', mtWarning, [mbOk], 0);
End;

{ == Procedure to Send Message to Get Record == }
Procedure TFrmInpLine.Send_UpdateList(WPar, LPar :  Integer);
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

Procedure TFrmInpLine.SetCaption;
Begin
  With ExLocal Do
    Caption := 'Report Details';
End;

procedure TFrmInpLine.ShowLink;
begin
  ExLocal.AssignFromGlobal(RepGenF);
  ExLocal.LGetRecAddr(RepGenF);

  CanDelete:=Ok2DelRep (ExLocal.LRepGen^.ReportHed.RepName);

  SetCaption;

  OutReport;

  ExLocal.LastRepGen^:=ExLocal.LRepGen^;
end;


procedure TFrmInpLine.FormDesign;
begin
  Try
    If Assigned(RepLineCtrl) Then
      With (RepLineCtrl As TPanel) Do Begin
        RiRef.Font.Assign (Font);
        RiRef.Color :=  Color;
        SetFieldProperties;
      End; { With }
  Except
    On Exception Do ;
  End;

  If ExMultiCcy Then Begin
    { Load Currency List }
    Set_DefaultCurr(RiCcy1.Items,BOn,BOff);
    Set_DefaultCurr(RiCcy1.ItemsL,BOn,BOn);
    RiCcy1.ItemIndex := 0;

    Set_DefaultCurr(RiCcy2.Items,BOn,BOff);
    Set_DefaultCurr(RiCcy2.ItemsL,BOn,BOn);
    RiCcy2.ItemIndex := 0;
  End; { If }
end;

Procedure TFrmInpLine.BuildDesign;
Begin
  { Adjust depending on mode }
End;

procedure TFrmInpLine.FormCreate(Sender: TObject);
Var
  WantF : Boolean;
  n     : Integer;
begin
  ExLocal.Create;

  DispMode := TmpMode;

  LastCoord:=BOff;
  GotCoord := False;
  StopPageChange:=BOff;

  ClientHeight := 174;
  ClientWidth  := 437;

  MDI_SetFormCoord(TForm(Self));

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;
  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  RiType.Items.Clear;
  For N := Low(RepInpTypesL^) To High(RepInpTypesL^) Do Begin
    Case N Of
      5     : WantF := (ExVersionNo >= 7);                         { Currency }
      10    : WantF := (ExVersionNo In [2, 4..6, 8..11]);          { Stock Code }
      11,                                                          { Cost Centre Code }
      12    : WantF := (ExVersionNo >= 3);                         { Department Code }
      13    : WantF := (ExVersionNo In [5, 6, 9, 11]);             { Location Code }
      14    : WantF := False;                                      { Serial No. }
      15    : WantF := False;                                      { Batch No. }
      16    : WantF := False;                                      { Fixed Asset No. }
      17    : WantF := (ExVersionNo In [6, 11]);                   { Job Code }
    Else
      WantF := True;
    End; { Case }

    If WantF Then
      RiType.Items.Add (RepInpTypesL^[N]);
  End; { If }

  (*For N := 1 To 12 Do Begin
    If (N <> 5) Or ((N = 5) And ExMultiCcy) Then
      RiType.Items.Add (RepInpTypesL^[N]);*)

  FormDesign;
end;


procedure TFrmInpLine.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;
end;


procedure TFrmInpLine.FormCloseQuery(Sender: TObject;
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

  Send_UpdateList(0, 1);
end;

procedure TFrmInpLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

{ Sets the colours into all the controls on the Header Tab }
procedure TFrmInpLine.SetFieldProperties;
Var
  n  : Integer;
Begin
  For n:=0 to Pred(ComponentCount) do Begin
    If (Components[n] is TMaskEdit) or
       (Components[n] is TComboBox) or
       (Components[n] is TCurrencyEdit) and
       (Components[n] <> RiRef) Then
    With TGlobControl(Components[n]) do
      If (Tag>0) then Begin
        Font.Assign(RiRef.Font);
        Color:=RiRef.Color;
      End; { If }

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do Begin
        CheckColor:=RiRef.Color;
        Color:=Self.Color;
      end;
  End; { For }
End;

{ Displays the report details }
Procedure TFrmInpLine.OutReport;
Var
  I, J : SmallInt;
Begin
  With ExLocal, LRepGen^, ReportDet Do Begin
    { Report Ref }
    RiRef.Value := RepVarNo;
    RiRef.Modified := False;

    { Description }
    RiDesc.Text := Strip ('R', [#0,#32],RepLDesc);

    { Type }
    If (RepLIType In [Low(RepInpTypesL^)..High(RepInpTypesL^)]) And (RiType.Items.Count > 0) Then
      For I := 0 To (RiType.Items.Count - 1) Do
        If (RiType.Items.Strings[I] = RepInpTypesL^[RepLIType]) Then Begin
          RiType.ItemIndex := I;
          RiTypeClick(Self);
        End; { If }

    { Values }
    Try
      Case TrueInpType Of
        1  : Begin { Date }
               EditDate1.DateValue:=DRange[1];
               EditDate2.DateValue:=DRange[2];
             End;
        2  : Begin { Period }
               EditPeriod1.EPeriod       := PrRange[1,1];
               EditPeriod1.EYear         := PrRange[1,2];
               EditPeriod1.PeriodsInYear := Syss.PrinYr;

               EditPeriod2.EPeriod       := PrRange[2,1];
               EditPeriod2.EYear         := PrRange[2,2];
               EditPeriod2.PeriodsInYear := Syss.PrinYr;
             End;
        3  : Begin { Value }
               CurrencyEdit1.Value := VRange[1];
               CurrencyEdit2.Value := VRange[2];
             End;
        5  : Begin { Currency }
               If (CrRange[1] > 0) Then
                 RiCcy1.ItemIndex := CrRange[1]
               Else
                 RiCcy1.ItemIndex := 0;
               If (CrRange[2] > 0) Then
                 RiCcy2.ItemIndex := CrRange[2]
               Else
                 RiCcy2.ItemIndex := 0;
             End;
        4,         { ASCII }
        6,         { Document No. }
        7,         { Customer Code }
        8,         { Supplier Code }
        9,         { Nominal Code }
        10,        { Stock Code }
        11,        { Cost Centre Code }
        12,        { Department Code }
        13,        { Location Code }
        17,        { Job Code }
        18 : Begin { Bin Code }
               Ext8Pt1.Text := Copy (ASCStr[1], 1, Ext8Pt1.MaxLength);
               Ext8Pt2.Text := Copy (ASCStr[2], 1, Ext8Pt2.MaxLength);
             End;
      End; { Case }
    Except
      { Just in case it bombs out }
      On Exception Do ;
    End;
  End; { With }
End;

{  Adds / Edits a report }
Procedure TFrmInpLine.EditLine (Const Edit : Boolean);
Begin
  With ExLocal Do Begin
    LastEdit:=Edit;

    ProcessReport(RepGenF,RGK,LastEdit);
  end;
End;


{ Deletes an existing report }
Procedure TFrmInpLine.DeleteRep;
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
          { Update Tree }
          Send_UpdateList(204, 0);

          Close;
        end;
      End; { If }
    End { With }
  Else
    PostMessage (Self.Handle, WM_CLOSE, 0, 0);
End;

procedure TFrmInpLine.ProcessReport(Fnum, KeyPath : Integer;
                                   Edit          : Boolean);
Var
  KeyS     :  Str255;
  n        :  Integer;
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
        If (DispMode = 4) Then n := ReportDet.RepVarNo;

        { Adding a report }
        Caption:='Add Report Record';
        LResetRec(Fnum);

        { Set default values here }
        RecPFix := ReportGenCode;
        SubType := RepLineTyp;
        With ReportDet Do Begin
          { Set Default values here }
          RepName := ReportRec^.ReportHed.RepName;
          VarType := RepInpCode;
          If (DispMode = 4) Then
            ReportDet.RepVarNo := n
          Else Begin
            RepVarNo := ReportRec^.ReportHed.ILineCount;
          End;
          Break := 1;
          PrintVar := True;
          RepLIType := 1;
        End; { With }

        CanDelete:=BOn;
      End; { If }

      SetRepStore(BOn,BOff);

      OutReport;

      LastRepGen^:=LRepGen^;
      LastDict^:=LDict^;

      SetFieldFocus;
    End; { With }
End;

procedure TFrmInpLine.SetFieldFocus;
Begin
  If (DispMode <> 7) Then Begin
    If RiRef.CanFocus Then
      RiRef.SetFocus;
  End { If }
  Else
    If Assigned (Inp1) Then
      If Inp1.CanFocus Then
        Inp1.SetFocus;
End;

procedure TFrmInpLine.SetRepStore(EnabFlag, ButnFlg  :  Boolean);
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
    RiRef.ReadOnly:=(DispMode In [4, 7]) Or (Not Enabled) Or (Not InAddEdit);

  If (DispMode = 7) Then Begin
    RiDesc.ReadOnly := True;
    RiType.ReadOnly := True;
  End; { If }
end;

procedure TFrmInpLine.SetCompRO(      TC      : TComponent;
                               Const TG      : Integer;
                               Const EnabFlg : Boolean);
Begin
  If (TC is TMaskEdit) then
    With (TC as TMaskEdit) do Begin
      If (Tag=TG) then
        ReadOnly:= Not EnabFlg;
    End { With }
  Else
    If (TC is TCurrencyEdit ) then
      With (TC as TCurrencyEdit) do Begin
        If (Tag=TG) then
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

Function TFrmInpLine.ConfirmQuit  :  Boolean;
Var
  MbRet  :  Word;
  TmpBo  :  Boolean;
Begin
  TmpBo:=BOff;

  If ExLocal.InAddEdit and CheckNeedStore then Begin
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

Function TFrmInpLine.CheckNeedStore  :  Boolean;
Var
  Loop  :  Integer;
Begin
  Result:=BOff;
  Loop:=0;

  While (Loop<=Pred(ComponentCount)) and (Not Result) do Begin
    If (Components[Loop] is TMaskEdit) then
      With (Components[Loop] as TMaskEdit) do Begin
        Result:=((Tag=1) and (Modified));

        If (Result) then
          Modified:=BOff;
      End { With }
    Else
      If (Components[Loop] is TCurrencyEdit) then
        With (Components[Loop] as TCurrencyEdit) do Begin
          Result:=((Tag=1) and (FloatModified));

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

procedure TFrmInpLine.StoreReport(Fnum, KeyPAth : Integer;
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
      KeyS := Strip('R',[#0,#32],FullRepKey_RGK(ReportGenCode, RepLineTyp, ReportKey));
      Status := Find_Rec (B_GetEq, F[Fnum], Fnum, LRecPtr[Fnum]^, RGK, KeyS);

      If StatusOk Then Begin
        Inc(RepVarNo);
        RepPadNo := SetPadNo(Form_Int(RepVarNo, 0), RiRef.MaxLength);
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
  Begin
    With ExLocal Do Begin
      { update record held on detail window }
      ReportRec^.ReportHed.ILineCount := NewCount;

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

          LRepGen^.ReportHed.ILineCount := NewCount;

          { update record }
          Status:=Put_Rec(F[RepGenF], RepGenF, LRecPtr[RepGenF]^, RGNdxK);

          { unlock multiple-lock lock }
          ExLocal.UnLockMLock(RepGenF,LastRecAddr[RepGenF]);
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

        { renumber any references to input fields which may be knackered }
        RepGen_RenumbAll(RepGenRecs^,RepVarNo,RepGenF, RGK,VarType,BOff);
      End; { Else }

      SetCaption;

      Report_BError(Fnum,Status);

      LGetRecAddr(Fnum);  {* Refresh record address *}

      If (StatusOk) then
        Send_UpdateList(104, Ord(Moved));

      If (Edit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      { update counter on report record }
      If (Not Edit) Then Begin
        If (DispMode <> 4) Then
          UpdRepCount (LRepGen^.ReportDet.RepVarNo + 1)
        Else
          UpdRepCount (Succ(ReportRec^.ReportHed.ILineCount));
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
Procedure TFrmInpLine.Form2Report;
Begin
  With ExLocal.LRepGen^, ReportDet Do Begin
    { Report Ref }
    RepVarNo := Round(RiRef.Value);
    RepPadNo := SetPadNo(Form_Int(RepVarNo, 0), RiRef.MaxLength);

    { Description }
    RepLDesc := Strip ('R', [#0,#32],RiDesc.Text);

    { Field Type }
    RepLIType := TrueInpType;

    If Assigned (Inp1) And Assigned (Inp2) Then
      Case RepLIType Of
        1  : Begin { Date }
               DRange[1] := EditDate1.DateValue;
               DRange[2] := EditDate2.DateValue;
             End;
        2  : Begin { Period }
               PrRange[1,1] := EditPeriod1.EPeriod;
               PrRange[1,2] := EditPeriod1.EYear;
               PrRange[2,1] := EditPeriod2.EPeriod;
               PrRange[2,2] := EditPeriod2.EYear;
             End;
        3  : Begin { Value }
               VRange[1] := CurrencyEdit1.Value;
               VRange[2] := CurrencyEdit2.Value;
             End;
        5  : Begin { Currency }
               If (RiCcy1.ItemIndex >= 0) Then
                 CrRange[1] := RiCcy1.ItemIndex
               Else
                 CrRange[1] := 0;
               If (RiCcy2.ItemIndex >= 0) Then
                 CrRange[2] := RiCcy2.ItemIndex
               Else
                 CrRange[2] := 0;
             End;
        4,         { ASCII }
        6,         { Document No. }
        7,         { Customer Code }
        8,         { Supplier Code }
        9,         { Nominal Code }
        10,        { Stock Code }
        11,        { Cost Centre Code }
        12,        { Department Code }
        13,        { Location Code }
        17,        { Job Code }
        18 : Begin {Bin Code}
               ASCStr[1] := Copy (Ext8Pt1.Text, 1, Ext8Pt1.MaxLength);
               ASCStr[2] := Copy (Ext8Pt2.Text, 1, Ext8Pt1.MaxLength);
             End;
      Else
        FillChar (VarSubSplit, SizeOf (VarSubSplit), #0);
      End { Case }
    Else
      FillChar (VarSubSplit, SizeOf (VarSubSplit), #0);

    { Key field }
    ReportKey := RepName + VarType + RepPadNo;
  End; { With }
End;


Function TFrmInpLine.CheckCompleted (Edit  :  Boolean)  : Boolean;
Var
  Test      : Byte;
  n, mbRet  : Word;
  FoundCode : Str20;
  FoundLong : LongInt;
Begin
  Test:=1;

  Result:=BOn;

  While (Test<=2) And (Result) Do
    With ExLocal, LRepGen^, ReportHed Do Begin
      Case Test of
        { Report Ref }
        1  :  Result := vRlRef;

        { Description }
        2  :  Result := True;

        { Report Type }
        {3  :  Result := (RlType.ItemIndex <> -1);}
      End; { Case }

      If Result then
        Inc(Test);
    End; { With }

  If (Not Result) And (Test In [1,6,8]) then
    Msg (Test + 10);
End; { CheckCompleted }

procedure TFrmInpLine.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TFrmInpLine.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TFrmInpLine.OkRPBtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
    With (Sender as TButton) do Begin
      If (TrueInpType In [1..3]) Then
        OkRPBtn.SetFocus;

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


function TFrmInpLine.vRlRef : Boolean;
Var
  COk   :  Boolean;
  CCode :  Str30;
begin
  Result := False;

  With RiRef, ExLocal, LRepGen^, ReportDet do Begin
    If (Trim(Text) <> '') Then Begin
      If (DispMode <> 4) Then Begin
        { Only need to check unique if not inserting }
        CCode:=Strip('R',[#0,#32],FullRepKey_RGK(RecPFix, SubType, FullRepCode(RepName)+VarType+Text));

        { Check to see if code is unique }
        COK := (Not CheckExsists(CCode,RepGenF,RGK));

        If (Not COk) then
          { Its not a valid report code - stay on this page until its ok }
          MessageDlg('An Input Field already exists with that Id!', mtWarning, [mbOk], 0)
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

procedure TFrmInpLine.RlRefExit(Sender: TObject);
begin
  If (Sender is TMaskEdit) And (Screen.ActiveControl <> CanCP1Btn) then
    vRlRef;
end;

Function TFrmInpLine.TrueInpType : SmallInt;
Var
  I : SmallInt;
Begin
  Result := -1;

  For I := 1 To High(RepInpTypesL^) Do
    If (RiType.Text = RepInpTypesL^[I]) Then Begin
      Result := I;
      Break;
    End; { If }
End;

procedure TFrmInpLine.RiTypeClick(Sender: TObject);
begin
  LblInp.Caption := RiType.Text;

  { Hide the input controls }
  If Assigned (Inp1) And Assigned(Inp2) Then Begin
    Inp1.Enabled := False;
    Inp1.Visible := False;
    Inp2.Enabled := False;
    Inp2.Visible := False;
  End; { If }

  Inp1 := Nil;
  Inp2 := Nil;

  Case TrueInpType Of
    1  : Begin { Date }
           Inp1 := EditDate1;
           Inp2 := EditDate2;
         End;
    2  : Begin { Period }
           Inp1 := EditPeriod1;
           Inp2 := EditPeriod2;
         End;
    3  : Begin { Value }
           Inp1 := CurrencyEdit1;
           Inp2 := CurrencyEdit2;
         End;
    4  : Begin { ASCII }
           Inp1 := Ext8Pt1;
           Inp2 := Ext8Pt2;

           { Set Length for ASCII String }
           Ext8Pt1.CharCase := ecNormal;
           Ext8Pt1.Width := 148;
           Ext8Pt1.MaxLength := 20;
           Ext8Pt1.OnExit := OKExit;
         End;
    5  : Begin { Currency }
           Inp1 := RiCcy1;
           Inp2 := RiCcy2;
         End;
    6  : Begin { Document No. }
           Inp1 := Ext8Pt1;
           Inp2 := Ext8Pt2;

           { Set Length for Document number String }
           Ext8Pt1.CharCase := ecUpperCase;
           Ext8Pt1.Width := 75;
           Ext8Pt1.MaxLength := 9;
           Ext8Pt1.OnExit := OKExit;
         End;
    7,         { Customer Code }
    8  : Begin { Supplier Code }
           Inp1 := Ext8Pt1;
           Inp2 := Ext8Pt2;

           Ext8Pt1.CharCase := ecUpperCase;
           Ext8Pt1.Width := 60;
           Ext8Pt1.MaxLength := 6;
           Ext8Pt1.OnExit := CustSuppExit;
         End;
    9  : Begin { Nominal Code }
           Inp1 := Ext8Pt1;
           Inp2 := Ext8Pt2;

           Ext8Pt1.CharCase := ecUpperCase;
           Ext8Pt1.Width := 80;
           Ext8Pt1.MaxLength := 9;
           Ext8Pt1.OnExit := NomExit;
         End;
    10 : Begin { Stock Code }
           Inp1 := Ext8Pt1;
           Inp2 := Ext8Pt2;

           Ext8Pt1.CharCase := ecUpperCase;
           Ext8Pt1.Width := 150;
           Ext8Pt1.MaxLength := 16;
           Ext8Pt1.OnExit := StockExit;
         End;
    11,        { Cost Centre Code }
    12 : Begin { Department Code }
           Inp1 := Ext8Pt1;
           Inp2 := Ext8Pt2;

           Ext8Pt1.CharCase := ecUpperCase;
           Ext8Pt1.Width := 40;
           Ext8Pt1.MaxLength := 3;
           Ext8Pt1.OnExit := CCDepExit;
         End;
    13 : Begin { Location Code }
           Inp1 := Ext8Pt1;
           Inp2 := Ext8Pt2;

           Ext8Pt1.CharCase := ecUpperCase;
           Ext8Pt1.Width := 40;
           Ext8Pt1.MaxLength := 3;
           Ext8Pt1.OnExit := LocExit;
         End;
    17 : Begin { Job Code }
           Inp1 := Ext8Pt1;
           Inp2 := Ext8Pt2;

           Ext8Pt1.CharCase := ecUpperCase;
           Ext8Pt1.Width := 80;
           Ext8Pt1.MaxLength := 10;
           Ext8Pt1.OnExit := JobExit;
         End;
    18 : Begin { Bin Code }
           Inp1 := Ext8Pt1;
           Inp2 := Ext8Pt2;

           Ext8Pt1.CharCase := ecUpperCase;
           Ext8Pt1.Width := 80;
           Ext8Pt1.MaxLength := 10;
           //Ext8Pt1.OnExit := JobExit;
           Ext8Pt1.OnExit := OKExit;
         End;
  End; { Case }

  If (Inp2 = Ext8Pt2) Then Begin
    Ext8Pt2.CharCase  := Ext8Pt1.CharCase;
    Ext8Pt2.Width     := Ext8Pt1.Width;
    Ext8Pt2.MaxLength := Ext8Pt1.MaxLength;
    Ext8Pt2.OnExit    := Ext8Pt1.OnExit;
  End; { If }

  If Assigned (Inp1) And Assigned(Inp2) Then Begin
    Inp1.Top := 109;
    Inp2.Top := Inp1.Top;

    Inp1.Left := RiType.Left;
    Label86.Left := Inp1.Left + Inp1.Width + 5;
    Inp2.Left := Label86.Left + 9;

    { Add into Tab Order }
    Inp1.TabOrder := RiType.TabOrder + 1;
    Inp2.TabOrder := Inp1.TabOrder + 1;
    OkRPBtn.TabOrder := Inp2.TabOrder + 1;
    CanCP1Btn.TabOrder := OkRPBtn.TabOrder + 1;

    Inp1.Enabled := True;
    Inp1.Visible := True;
    Inp2.Enabled := True;
    Inp2.Visible := True;
  End; { If }
end;

procedure TFrmInpLine.OKExit(Sender: TObject);
Begin
  { No validation required - but need to overwrite any existing handler }
End;

procedure TFrmInpLine.CustSuppExit(Sender: TObject);
Var
  FoundCode  : Str20;
  FoundOk    : Boolean;
begin
  With Sender As Text8Pt Do
    If (Trim(Text) <> '') Then Begin
      FoundCode := Copy (Text, 1, MaxLength);

      FoundOk:=GetCust(Self.Owner,FoundCode,FoundCode,(TrueInpType = 7), 0);

      If (Not FoundOk) Then Begin
        If CanFocus Then SetFocus
      End { If }
      Else
        Text := FoundCode;
    End; { If }
End;

procedure TFrmInpLine.StockExit(Sender: TObject);
Var
  FoundCode  : Str20;
  FoundOk    : Boolean;
begin
  With Sender As Text8Pt Do
    If (Trim(Text) <> '') And (Screen.ActiveControl <> CanCP1Btn) Then Begin
      FoundCode := Copy (Text, 1, MaxLength);

      FoundOk:=GetStock(Application.MainForm,FoundCode,FoundCode,99);

      If (Not FoundOk) Then Begin
        If CanFocus Then SetFocus
      End { If }
      Else
        Text := FoundCode;
    End; { If }
End;

procedure TFrmInpLine.CCDepExit(Sender: TObject);
Var
  FoundCode     : Str20;
  IsCC, FoundOk : Boolean;
begin
  With Sender As Text8Pt Do
    If (Trim(Text) <> '') Then Begin
      IsCC := (TrueInpType = 11);

      FoundCode := Copy (Text, 1, MaxLength);

      FoundOk:=GetCCDep(Self.Owner,FoundCode,FoundCode,IsCC,0);

      If (Not FoundOk) Then Begin
        If CanFocus Then SetFocus
      End { If }
      Else
        Text := FoundCode;
    End; { If }
end;

procedure TFrmInpLine.NomExit(Sender: TObject);
Var
  FoundCode : Str20;
  FoundNom  : LongInt;
  FoundOk   : Boolean;
begin
  With Sender As Text8Pt Do
    If (Trim(Text) <> '') Then Begin
      FoundCode := Copy (Text, 1, MaxLength);

      FoundOk:=GetNom(Self.Owner,FoundCode,FoundNom,99);

      If (Not FoundOk) Then Begin
        If CanFocus Then SetFocus
      End { If }
      Else
        Text := IntToStr(FoundNom);
    End; { If }
end;

procedure TFrmInpLine.LocExit(Sender: TObject);
Var
  FoundCode : Str10;
  FoundOk   : Boolean;
begin
  With Sender As Text8Pt Do
    If (Trim(Text) <> '') Then Begin
      FoundCode := Copy (Text, 1, MaxLength);

      FoundOk:=GetMLoc(Self.Owner,FoundCode,FoundCode,'',0);

      If (Not FoundOk) Then Begin
        If CanFocus Then SetFocus
      End { If }
      Else
        Text := FoundCode;
    End; { If }
end;

procedure TFrmInpLine.JobExit(Sender: TObject);
Var
  FoundCode : Str20;
  FoundOk   : Boolean;
begin
  With Sender As Text8Pt Do
    If (Trim(Text) <> '') Then Begin
      FoundCode := Copy (Text, 1, MaxLength);

      FoundOk:=GetJob(Self.Owner,FoundCode,FoundCode,0);

      If (Not FoundOk) Then Begin
        If CanFocus Then SetFocus
      End { If }
      Else
        Text := FoundCode;
    End; { If }
end;



end.

unit Repnom;

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
  TFrmNomLine = class(TForm)
    OkRPBtn: TButton;
    CanCP1Btn: TButton;
    SBSBackGroup1: TSBSBackGroup;
    Label84: Label8;
    Label87: Label8;
    Label81: Label8;
    FCDesc: Label8;
    SBSBackGroup3: TSBSBackGroup;
    RnDesc: Text8Pt;
    RnNom: Text8Pt;
    RnCalc: TMemo;
    RnRef: TCurrencyEdit;
    SBSBackGroup5: TSBSBackGroup;
    Label86: Label8;
    RnBrk: TSBSComboBox;
    RnPrn: TBorCheck;
    RnSTot: TBorCheck;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure OkRPBtnClick(Sender: TObject);
    procedure RlRefExit(Sender: TObject);
    procedure RnNomExit(Sender: TObject);
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

    OFCode       : ShortString;

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

    Procedure ProcessFieldCode (Const FieldCode : ShortString);

    Procedure Msg(Const MsgNo : Byte);

    function vRlRef : Boolean;
    Function vRlField : Boolean;
  public
    { Public declarations }

    ExLocal : TdExLocal;

    procedure SetFieldProperties;

    procedure FormDesign;

    procedure ShowLink;

    Procedure EditLine (Const Edit : Boolean);
    Procedure DeleteRep;
  end;


Procedure SetNomLineDets(Control : TControl; RepRec : RepGenPtr; Mode : SmallInt);


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

Const
  HeadPage = 0;
  MiscPage = 1;
  CalcStr = 'Calculation';

Var
  RepLineCtrl : TControl;    { Used for getting the colors from the parent list }
  ReportRec   : RepGenPtr;
  TmpMode     : SmallInt;



{ Sets the local handle to the passed control }
Procedure SetNomLineDets(Control : TControl; RepRec : RepGenPtr; Mode : SmallInt);
Begin
  RepLineCtrl := Control;
  ReportRec := RepRec;
  TmpMode := Mode;
End;


Procedure TFrmNomLine.Msg(Const MsgNo : Byte);
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
    6  : MsgStr := TheStr + 'Nominal Code' + BlankStr;
    7  : MsgStr := ValidStr + 'Nominal Code ' + SpecStr;
    8  : MsgStr := TheStr + 'Nominal Reference' + SpecStr;
    13 : MsgStr := TheStr + 'Calculation' + BlankStr;
  Else
    MsgStr := IntToStr(MsgNo);
  End; { Case }

  MessageDlg(MsgStr + '!', mtWarning, [mbOk], 0);
End;

{ == Procedure to Send Message to Get Record == }
Procedure TFrmNomLine.Send_UpdateList(WPar, LPar :  Integer);
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

Procedure TFrmNomLine.SetCaption;
Begin
  With ExLocal Do
    Caption := 'Report Details';
End;

procedure TFrmNomLine.ShowLink;
begin
  ExLocal.AssignFromGlobal(RepGenF);
  ExLocal.LGetRecAddr(RepGenF);

  CanDelete:=Ok2DelRep (ExLocal.LRepGen^.ReportHed.RepName);

  SetCaption;

  OutReport;

  ExLocal.LastRepGen^:=ExLocal.LRepGen^;
end;


procedure TFrmNomLine.FormDesign;
begin
  Try
    If Assigned(RepLineCtrl) Then
      With (RepLineCtrl As TPanel) Do Begin
        RnRef.Font.Assign (Font);
        RnRef.Color :=  Color;
        SetFieldProperties;
      End; { With }
  Except
    On Exception Do ;
  End;
end;

Procedure TFrmNomLine.BuildDesign;
Begin
  { Adjust depending on mode }
End;

procedure TFrmNomLine.FormCreate(Sender: TObject);
Var
  n  :  Integer;
begin
  ExLocal.Create;

  DispMode := TmpMode;

  LastCoord:=BOff;
  GotCoord := False;
  StopPageChange:=BOff;

  ClientHeight := 259;
  ClientWidth  := 438;

  MDI_SetFormCoord(TForm(Self));

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;
  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  RnBrk.Items.Clear;
  For n := 1 To High (BreakTypL^) Do
    RnBrk.Items.Add (BreakTypL^[n]);

  FormDesign;
end;


procedure TFrmNomLine.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;
end;


procedure TFrmNomLine.FormCloseQuery(Sender: TObject;
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

  Send_UpdateList(0, 3);
end;

procedure TFrmNomLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

{ Sets the colours into all the controls on the Header Tab }
procedure TFrmNomLine.SetFieldProperties;
Var
  n  : Integer;
Begin
  For n:=0 to Pred(ComponentCount) do Begin
    If (Components[n] is TMaskEdit) or
       (Components[n] is TMemo) or
       (Components[n] is TComboBox) or
       (Components[n] is TCurrencyEdit) and
       (Components[n] <> RnRef) Then
    With TGlobControl(Components[n]) do
      If (Tag>0) then Begin
        Font.Assign(RnRef.Font);
        Color:=RnRef.Color;
      End; { If }

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do Begin
        CheckColor:=RnRef.Color;
        Color:=Self.Color;
      end;
  End; { For }
End;


{ Displays the report details }
Procedure TFrmNomLine.OutReport;
Var
  I, J : SmallInt;
Begin
  With ExLocal, LRepGen^, ReportNom Do Begin
    { MAIN Tab Fields }
    { Report Ref }
    RnRef.Value := RepVarNo;
    RnRef.Modified := False;

    { Nominal Code }
    OFCode := NomRef;
    RnNom.Text := Strip ('B', [#0,#32],NomRef);
    ProcessFieldCode (NomRef);

    { Description }
    RnDesc.Text := Strip ('R', [#0,#32],RepLDesc);

    { Calculation }
    If CalcField Then
      RnCalc.Text := Strip ('R', [#0,#32],VarSubSplit)
    Else
      RnCalc.Text := '';

    { Break On Change }
    RnBrk.ItemIndex := Pred(Break);

    { Print Field }
    RnPrn.Checked := PrintVar;

    { Sub-Total }
    RnSTot.Checked := SubTot;
  End; { With }
End;

Procedure TFrmNomLine.ProcessFieldCode (Const FieldCode : ShortString);
Var
  DataRec : DataDictRec;
  RetCode : LongInt;
Begin
  If (FieldCode <> '+') Then
    If GetNom (Self, FieldCode, RetCode, -1) Then Begin
      FCDesc.Caption := Nom.Desc;
      If ((Trim(RnDesc.Text) = '') And (Not RnDesc.Modified)) Or (OFCode <> FieldCode) Then
        RnDesc.Text := Nom.Desc;

      OFCode := FieldCode;
    End { If }
    Else Begin
      { Cannot load record }
      FCDesc.Caption := '';
    End { Else }
  Else
    FCDesc.Caption := CalcStr;

  RnCalc.Enabled := (Trim(FieldCode) = '+');
End;

{  Adds / Edits a report }
Procedure TFrmNomLine.EditLine (Const Edit : Boolean);
Begin
  With ExLocal Do Begin
    LastEdit:=Edit;

    ProcessReport(RepGenF,RGK,LastEdit);
  end;
End;


{ Deletes an existing report }
Procedure TFrmNomLine.DeleteRep;
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

  MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Nominal Line',
                     mtConfirmation,[mbYes,mbNo],0);


  If (MbRet=MrYes) then
    With ExLocal do Begin
      Keypath:=CurrKeyPath^[Fnum];

      LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

      Report_BError(Fnum,Status);

      Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,Keypath,Fnum,BOn,GlobLocked);

      If (Ok) and (GlobLocked) then Begin
        Status:=Delete_Rec(F[Fnum],Fnum,CurrKeyPath^[Fnum]);

        Report_BError(Fnum,Status);

        If (StatusOk) then Begin
          { Update Tree }
          Send_UpdateList(203, 0);

          Close;
        end;
      End; { If }
    End { If }
  Else
    PostMessage (Self.Handle, WM_CLOSE, 0, 0);
End;

procedure TFrmNomLine.ProcessReport(Fnum, KeyPath : Integer;
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
        If (DispMode = 4) Then n := ReportNom.RepVarNo;

        { Adding a report }
        Caption:='Add Report Record';
        LResetRec(Fnum);

        { Set default values here }
        RecPFix := ReportGenCode;
        SubType := RepNomCode;
        With ReportNom Do Begin
          { Set Default values here }
          RepName := ReportRec^.ReportHed.RepName;
          VarType := 'N';
          If (DispMode = 4) Then
            RepVarNo := n
          Else Begin
            RepVarNo := ReportRec^.ReportHed.MLineCount;
          End;
          Break := 1;
          PrintVar := True;
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

procedure TFrmNomLine.SetFieldFocus;
Begin
  {  }
End;

procedure TFrmNomLine.SetRepStore(EnabFlag, ButnFlg  :  Boolean);
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
    RnRef.ReadOnly:=(DispMode = 4) Or (Not Enabled) Or (Not InAddEdit);
end;

procedure TFrmNomLine.SetCompRO(      TC      : TComponent;
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

Function TFrmNomLine.ConfirmQuit  :  Boolean;
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

Function TFrmNomLine.CheckNeedStore  :  Boolean;
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

procedure TFrmNomLine.StoreReport(Fnum, KeyPAth : Integer;
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
    With ExLocal, LRepGen^, ReportNom Do Begin
      { look for record matching current record }
      KeyS := Strip('R',[#0,#32],FullRepKey_RGK(ReportGenCode, RepNomCode, ReportKey));
      Status := Find_Rec (B_GetEq, F[Fnum], Fnum, LRecPtr[Fnum]^, RGK, KeyS);

      If StatusOk Then Begin
        Inc(RepVarNo);
        RepPadNo := SetPadNo(Form_Int(RepVarNo, 0), RnRef.MaxLength);
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
      ReportRec^.ReportHed.MLineCount := NewCount;

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

          LRepGen^.ReportHed.MLineCount := NewCount;

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

  With ExLocal, LRepGen^, ReportNom do Begin
    If ((Not Edit) Or (LastRepGen.ReportNom.RepVarNo <> RepVarNo)) And (DispMode <> 4) Then Begin
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

          OneLCode:=Strip('B',[#0],ChkCode+ReportNom.RepPadNo);

          {Renumber;}

          { Renumbers all lines from this line onwards - to make a gap }
          MoveEmUp(ChkCode, LastLCode, OneLCode, RepVarNo, 1, RepGenF, RGK);

          { restore local record }
          ExLocal.LRepGen^ := TmpRep;
        End; { If }

        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
        CanDelete:=BOn;
      End; { Else }

      SetCaption;

      Report_BError(Fnum,Status);

      LGetRecAddr(Fnum);  {* Refresh record address *}

      If (StatusOk) then
        Send_UpdateList(103, Ord(Moved));

      If (Edit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      { update counter on report record }
      If (Not Edit) Then Begin
        If (DispMode <> 4) Then
          UpdRepCount (LRepGen^.ReportNom.RepVarNo + 1)
        Else
          UpdRepCount (Succ(ReportRec^.ReportHed.MLineCount));
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
Procedure TFrmNomLine.Form2Report;
Begin
  With ExLocal.LRepGen^, ReportNom Do Begin
    { Report Ref }
    RepVarNo := Round(RnRef.Value);
    RepPadNo := SetPadNo(Form_Int(RepVarNo, 0), RnRef.MaxLength);

    { Description }
    RepLDesc := Strip ('R', [#0,#32],RnDesc.Text);

    { Field Code }
    NomRef := LJVar(RnNom.Text, RnNom.MaxLength);
    CalcField := (NomRef[1] = '+');

    { Calculation }
    VarSubSplit := UpperCase(Strip ('R', [#0,#32],RnCalc.Text));

    { Break On Change }
    Break := Succ(RnBrk.ItemIndex);

    { Print Field }
    PrintVar := RnPrn.Checked;

    { Sub-Total }
    SubTot := RnSTot.Checked;

    { Key field }
    ReportKey := RepName + VarType + RepPadNo;
  End; { With }
End;


Function TFrmNomLine.CheckCompleted (Edit  :  Boolean)  : Boolean;
Var
  Test      : Byte;
  n, mbRet  : Word;
  FoundCode : Str20;
  FoundLong : LongInt;
Begin
  Test:=1;

  Result:=BOn;

  While (Test<=3) And (Result) Do
    With ExLocal, LRepGen^, ReportHed Do Begin
      Case Test of
        { Report Ref }
        1  :  Result := vRlRef;

        { Field Code }
        2  :  Result := vRlField;

        { Calculation }
        3  :  (*If (RnNom.Text = '+') Then    { HM 15/10/97: Allow blank formulae ala Exch RW }
                Result := (Trim(RnCalc.Text) <> '')
              Else*)
                Result := BOn;
      End; { Case }

      If Result then
        Inc(Test);
    End; { With }

  If (Not Result) And (Not (Test In [1..2])) then
    Msg (Test + 10);
End; { CheckCompleted }

procedure TFrmNomLine.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TFrmNomLine.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TFrmNomLine.OkRPBtnClick(Sender: TObject);
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

function TFrmNomLine.vRlRef : Boolean;
Var
  COk   :  Boolean;
  CCode :  Str30;
begin
  Result := False;

  With RnRef, ExLocal, LRepGen^, ReportNom do Begin
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

procedure TFrmNomLine.RlRefExit(Sender: TObject);
begin
  If (Sender is TMaskEdit) And (Screen.ActiveControl <> CanCP1Btn) then
    vRlRef;
end;

Function TFrmNomLine.vRlField : Boolean;
Var
  COk   :  Boolean;
  CCode :  Str30;
  RetCode : LongInt;
begin
  Result := False;

  With RnNom, ExLocal, LRepGen^, ReportNom do Begin
    { Check its not a calculation }
    If (Trim(Text) <> '+') Then Begin
      RnCalc.Enabled := False;

      If (Trim(Text) <> '') Then Begin
        { Not a calculation }
        If GetNom (Self, Text, RetCode, 99) Then Begin
          Text := IntToStr(RetCode);
          ProcessFieldCode (Text);
          Result := True;
        End { If }
        Else Begin
          Text := '';
          Msg (7);
          FCDesc.Caption:='';
        End; { Else }
      End { If }
      Else Begin
        Msg (6);
        FCDesc.Caption:='';
      End; { Else }
    End { If }
    Else Begin
      { Calculation }
      Result := True;
      FCDesc.Caption:=CalcStr;
      RnCalc.Enabled := True;
    End; { Else }
  End; { With }
end;

procedure TFrmNomLine.RnNomExit(Sender: TObject);
begin
  If (Sender is TMaskEdit) And (Screen.ActiveControl <> CanCP1Btn) then
    vRlField;
end;


end.

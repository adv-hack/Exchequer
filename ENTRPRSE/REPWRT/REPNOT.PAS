unit RepNot;

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
  TFrmNotLine = class(TForm)
    OkRPBtn: TButton;
    CanCP1Btn: TButton;
    SBSBackGroup1: TSBSBackGroup;
    RnNote: Text8Pt;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure OkRPBtnClick(Sender: TObject);
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
  public
    { Public declarations }

    ExLocal : TdExLocal;

    procedure SetFieldProperties;

    procedure FormDesign;

    procedure ShowLink;

    Procedure EditLine (Const Edit : Boolean);
    Procedure DeleteRep;
  end;


Procedure SetNotLineDets(Control : TControl; RepRec : RepGenPtr; Mode : SmallInt);


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
  RwFuncs;


{$R *.DFM}

Var
  RepLineCtrl : TControl;    { Used for getting the colors from the parent list }
  ReportRec   : RepGenPtr;
  TmpMode     : SmallInt;


{ Sets the local handle to the passed control }
Procedure SetNotLineDets(Control : TControl; RepRec : RepGenPtr; Mode : SmallInt);
Begin
  RepLineCtrl := Control;
  ReportRec := RepRec;
  TmpMode := Mode;
End;

{ == Procedure to Send Message to Get Record == }
Procedure TFrmNotLine.Send_UpdateList(WPar, LPar :  Integer);
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

Procedure TFrmNotLine.SetCaption;
Begin
  With ExLocal Do
    Caption := 'Report Note';
End;

procedure TFrmNotLine.ShowLink;
begin
  ExLocal.AssignFromGlobal(RepGenF);
  ExLocal.LGetRecAddr(RepGenF);

  CanDelete:=Ok2DelRep (ExLocal.LRepGen^.ReportHed.RepName);

  SetCaption;

  OutReport;

  ExLocal.LastRepGen^:=ExLocal.LRepGen^;
end;


procedure TFrmNotLine.FormDesign;
begin
  Try
    If Assigned(RepLineCtrl) Then
      With (RepLineCtrl As TPanel) Do Begin
        RnNote.Font.Assign (Font);
        RnNote.Color :=  Color;
        SetFieldProperties;
      End; { With }
  Except
    On Exception Do ;
  End;
end;

Procedure TFrmNotLine.BuildDesign;
Begin
  { Adjust depending on mode }
End;

procedure TFrmNotLine.FormCreate(Sender: TObject);
Var
  n  :  Integer;
begin
  ExLocal.Create;

  DispMode := TmpMode;

  LastCoord:=BOff;
  GotCoord := False;
  StopPageChange:=BOff;

  ClientHeight := 66;
  ClientWidth  := 434;

  MDI_SetFormCoord(TForm(Self));

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;
  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  FormDesign;
end;


procedure TFrmNotLine.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;
end;


procedure TFrmNotLine.FormCloseQuery(Sender: TObject;
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

  Send_UpdateList(0, 2);
end;

procedure TFrmNotLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

{ Sets the colours into all the controls on the Header Tab }
procedure TFrmNotLine.SetFieldProperties;
Var
  n  : Integer;
Begin
  For n:=0 to Pred(ComponentCount) do Begin
    If (Components[n] is TMaskEdit) or
       (Components[n] is TComboBox) or
       (Components[n] is TCurrencyEdit) and
       (Components[n] <> RnNote) Then
    With TGlobControl(Components[n]) do
      If (Tag>0) then Begin
        Font.Assign(RnNote.Font);
        Color:=RnNote.Color;
      End; { If }

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do Begin
        CheckColor:=RnNote.Color;
        Color:=Self.Color;
      end;
  End; { For }
End;

{ Displays the report details }
Procedure TFrmNotLine.OutReport;
Begin
  With ExLocal, LRepGen^, RNotesRec Do Begin
    { Note }
    RnNote.Text := Strip ('R', [#0,#32],NoteLine);
  End; { With }
End;

{  Adds / Edits a report }
Procedure TFrmNotLine.EditLine (Const Edit : Boolean);
Begin
  With ExLocal Do Begin
    LastEdit:=Edit;

    ProcessReport(RepGenF,RGK,LastEdit);
  end;
End;


{ Deletes an existing report }
Procedure TFrmNotLine.DeleteRep;
Const
  Fnum  =  RepGenF;
Var
  MbRet    :  Word;
  KeyS     :  Str255;
  Keypath  :  Integer;
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
        Status:=Delete_Rec(F[Fnum],Fnum,CurrKeyPath^[Fnum]);

        Report_BError(Fnum,Status);

        If (StatusOk) then Begin
          { Update Tree }
          Send_UpdateList(205, 0);

          Close;
        end;
      End; { If }
    End { With }
  Else
    PostMessage (Self.Handle, WM_CLOSE, 0, 0);
End;

procedure TFrmNotLine.ProcessReport(Fnum, KeyPath : Integer;
                                   Edit          : Boolean);
Var
  KeyS     :  Str255;
  n        :  Integer;

  { Returns next valid line number }
  Function NextLineNo(NLine : LongInt) : LongInt;
  Var
    KeyS  : Str255;
    COk   : Boolean;
  Begin
    Result := NLine - 1;

    With ExLocal, LRepGen^, RNotesRec Do
      Repeat
        Inc (Result);

        KeyS := RecPFix + SubType + NoteFolio + NType + SetPadNo(Form_Int(Result, 0), 4);

        { Check line with this ID doesn't already exist }
        COK := Not CheckExsists(Strip('R', [#0,#32],KeyS), RepGenF, RGK);
      Until COK Or (Result > 9999);
  End;

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
        If (DispMode = 4) Then n := RNotesRec.LineNo;

        { Adding a report }
        Caption:='Add Report Note';
        LResetRec(Fnum);

        { Set default values here }
        RecPFix := RepNoteType;
        SubType := RepNoteCode;
        With RNotesRec Do Begin
          { Set Default values here }
          NoteFolio := ReportRec^.ReportHed.RepName;
          NType     := '1';
          If (DispMode = 4) Then
            LineNo := n
          Else Begin
            LineNo := NextLineNo(ReportRec^.ReportHed.NLineCount);
          End;
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

procedure TFrmNotLine.SetFieldFocus;
Begin
  If RnNote.CanFocus Then RnNote.SetFocus;
End;

procedure TFrmNotLine.SetRepStore(EnabFlag, ButnFlg  :  Boolean);
Var
  Loop  :  Integer;
Begin
  OkRPBtn.Enabled:=EnabFlag;
  CanCP1Btn.Enabled:=EnabFlag;

  ExLocal.InAddEdit:=EnabFlag;

  For Loop:=0 to ComponentCount-1 do Begin
    SetCompRO(Components[Loop],1,EnabFlag);
  end;

  {With ExLocal do
    RnNote.ReadOnly:=(DispMode = 4) Or (Not Enabled) Or (Not InAddEdit);}
end;

procedure TFrmNotLine.SetCompRO(      TC      : TComponent;
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

Function TFrmNotLine.ConfirmQuit  :  Boolean;
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

Function TFrmNotLine.CheckNeedStore  :  Boolean;
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

procedure TFrmNotLine.StoreReport(Fnum, KeyPAth : Integer;
                                 Edit          : Boolean);
Var
  COk    : Boolean;
  TmpRep : RepGenRec;
  KeyS   : Str255;
  MbRet  : Word;
  Moved  : Boolean;

  Procedure Renumber;
  Var
    TmpRep     : ^RepGenRec;
    KeyS       : Str255;
    TmpFn      : FileVar;
    TmpStat    : Integer;
    TmpRecAddr : LongInt;
  Begin
    With ExLocal, LRepGen^, RNotesRec Do Begin
      { look for record matching current record }
      KeyS := Strip('R',[#0,#32],FullRepKey_RGK(RepNoteType, RepNoteCode, NoteNo));
      Status := Find_Rec (B_GetEq, F[Fnum], Fnum, LRecPtr[Fnum]^, RGK, KeyS);

      If StatusOk Then Begin
        Inc(LineNo);
        NoteNo := NoteFolio + NType + SetPadNo(Form_Int(LineNo, 0), 4);

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

  { Update the rep line count on the main report record }
  Procedure UpdRepCount (NewCount : SmallInt);
  Var
    KeyS   : Str255;
    Locked : Boolean;
  Begin
    With ExLocal Do Begin
      { update record held on detail window }
      ReportRec^.ReportHed.NLineCount := NewCount;

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

          LRepGen^.ReportHed.NLineCount := NewCount;

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

  With ExLocal, LRepGen^, RNotesRec do Begin
    If ((Not Edit) Or (LastRepGen.RNotesRec.LineNo <> LineNo)) And (DispMode <> 4) Then Begin
      { Check line with this ID doesn't already exist }
      COK := Not CheckExsists(Strip('R', [#0,#32],FullRepKey_RGK(RecPFix, SubType, NoteNo)),RepGenF,RGK);

      If (Not COK) Then
        MessageDlg('That Report Field already exists!', mtWarning, [mbOk], 0);
    End { If }
    else
      COk:=BOn;

    If (COk) then
      COk:=CheckCompleted(Edit);

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

          Renumber;

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
        Send_UpdateList(105, Ord(Moved));

      If (Edit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      { update counter on report record }
      If (Not Edit) Then UpdRepCount (LRepGen^.RNotesRec.LineNo + 1);

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
Procedure TFrmNotLine.Form2Report;
Begin
  With ExLocal.LRepGen^, RNotesRec Do Begin
    { Note }
    NoteLine := Copy (RnNote.Text, 1, RnNote.MaxLength);

    { Key field }
    NoteNo := NoteFolio + NType + SetPadNo(Form_Int(LineNo, 0), 4);
  End; { With }
End;


Function TFrmNotLine.CheckCompleted (Edit  :  Boolean)  : Boolean;
Var
  Test      : Byte;
  n, mbRet  : Word;
  FoundCode : Str20;
  FoundLong : LongInt;
Begin
  Test:=1;

  Result:=BOn;
End; { CheckCompleted }

procedure TFrmNotLine.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TFrmNotLine.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TFrmNotLine.OkRPBtnClick(Sender: TObject);
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

end.

unit DocNumRU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, bkgroup, SBSPanel,
  GlobVar,VarConst,ExWrap1U,BTSupU1,CmpCtrlU,SupListU;


type
  TDocNumRec = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    Label82: Label8;
    SBSBackGroup1: TSBSBackGroup;
    NNumF: TCurrencyEdit;
    Label81: Label8;
    SCodeF: Text8Pt;
    SCDescF: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure NNumFEnter(Sender: TObject);
    procedure NNumFExit(Sender: TObject);
  private
    IdStored,
    StopPageChange,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;

    LastCount    :  IncrementRec;



    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildDesign;

    procedure FormDesign;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    Procedure OutId;

    procedure Form2Id;

    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

  public
    { Public declarations }

    ExLocal    :  TdExLocal;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSPanel) ;


    procedure EditLine(Edit       :  Boolean;
                       MMode      :  Byte);


  end;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  BorBtns,
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BtKeys1U,

  BTSupU2,
  ComnUnit,
  ComnU2,

  SBSComp2,
  ColCtrlU,

  SysU1,
  DocNumLU,
  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  {PayLineU,}
  DocSupU1,
  Saltxl1U;




{$R *.DFM}



{ ========== Build runtime view ======== }

procedure TDocNumRec.BuildDesign;


begin


end;


procedure TDocNumRec.FormDesign;


begin


  BuildDesign;

end;


procedure TDocNumRec.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  Height:=179;
  Width:=290;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TDocNoList) then
    With TDocNoList(Owner) do
    Begin
      Self.SetFieldProperties(PYNPanel);
    end;

  FormDesign;

end;




procedure TDocNumRec.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,102);

end;

procedure TDocNumRec.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TDocNumRec.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TDocNumRec.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TDocNumRec.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


{ == Procedure to Send Message to Get Record == }

Procedure TDocNumRec.Send_UpdateList(Edit   :  Boolean;
                                  Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_CustGetRec;
    WParam:=Mode+100;
    LParam:=Ord(Edit);
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}



Function TDocNumRec.CheckNeedStore  :  Boolean;

Var
  Loop  :  Integer;

Begin
  Result:=BOff;
  Loop:=0;

  While (Loop<=Pred(ComponentCount)) and (Not Result) do
  Begin
    If (Components[Loop] is TMaskEdit) then
    With (Components[Loop] as TMaskEdit) do
    Begin
      Result:=((Tag=1) and (Modified));

      If (Result) then
        Modified:=BOff;
    end
    else
      If (Components[Loop] is TCurrencyEdit) then
      With (Components[Loop] as TCurrencyEdit) do
      Begin
        Result:=((Tag=1) and (FloatModified));

        If (Result) then
          FloatModified:=BOff;
      end
      else
        If (Components[Loop] is TBorCheck) then
        With (Components[Loop] as TBorCheck) do
        Begin
          Result:=((Tag=1) and (Modified));

          If (Result) then
            Modified:=BOff;
        end
        else
          If (Components[Loop] is TSBSComboBox) then
          With (Components[Loop] as TSBSComboBox) do
          Begin
            Result:=((Tag=1) and (Modified));

            If (Result) then
              Modified:=BOff;
          end;

    Inc(Loop);
  end; {While..}
end;


Procedure TDocNumRec.SetFieldFocus;

Begin
  NNumF.SetFocus;

end; {Proc..}




Function TDocNumRec.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin

  TmpBo:=BOff;

  If (ExLocal.InAddEdit) and (CheckNeedStore) and (Not ExLocal.LViewOnly) and (Not IdStored) then
  Begin

    mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes  :  Begin
                StoreId(IncF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(IncF,LastRecAddr[IncF]);

                TmpBo:=BOn;
              end;

    mrCancel
           :  Begin
                TmpBo:=BOff;
                SetfieldFocus;
              end;
  end; {Case..}


  ConfirmQuit:=TmpBo;
end; {Func..}




{ ============== Display Id Record ============ }

Procedure TDocNumRec.OutId;

Const
  Fnum     =  StockF;
  Keypath  =  StkFolioK;

Var
  NextNo    :  LongInt;
  DocHed    :  DocTypes;

  GenStr    :  Str255;


Begin
  With ExLocal,LCount do
  Begin

    SCodeF.Text:=CountTyp;

    DocHed:=DocTypeFCode(CountTyp);

    If (Not CheckKey(CountTyp,DocCodes[DocHed],Length(CountTyp),BOff)) then
      GenStr:=ExternMsg
    else
      GenStr:=DocNames[DocHed];

    If (DocHed In SalesSplit+PurchSplit+PSOPSet+NOMSplit+[TSH,ADJ,WOR]+JapSplit) and (Not SBSIn) then
      NNumF.MaxLength:=7
    else
      NNumF.MaxLength:=9;

    SCDescF.Text:=GenStr;

    Move(NextCount[1],NextNo,Sizeof(NextNo));

    NNumF.Value:=NextNo;

  end;

end;


procedure TDocNumRec.Form2Id;

Begin

  With EXLocal,LCount do
  Begin
    NextCount:=FullNomKey(Trunc(NNumF.Value));
  end; {with..}

end; {Proc..}





(*  Add is used to add Notes *)

procedure TDocNumRec.ProcessId(Fnum,
                            Keypath     :  Integer;
                            Edit        :  Boolean);

Var
  KeyS  :  Str255;


Begin

  Addch:=ResetKey;

  KeyS:='';

  ExLocal.InAddEdit:=BOn;

  ExLocal.LastEdit:=Edit;

  SKeypath:=Keypath;

  If (Edit) then
  Begin
    OutId;

    With ExLocal do
    Begin
      LGetRecAddr(Fnum);

      If (Not LViewOnly) then
        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked)
      else
        Ok:=BOn;

    end;

    If (Not Ok) or (Not GlobLocked) then
      AddCh:=Esc;
  end;


  If (Addch<>Esc) then
  With ExLocal,LCount do
  begin

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

    end;

    LastCount:=LCount;

    OutId;

  end {If Abort..}
  else
    Close;

end; {Proc..}




Function TDocNumRec.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  2;
  Fnum         =  StockF;
  Keypath      =  StkFolioK;


Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  KeyS     :  Str255;

  Test     :  Byte;

  LNum     :  LongInt;

  FoundCode:  Str20;

  Loop,
  ShowMsg  :  Boolean;

  mbRet    :  Word;

  DocHed   :  DocTypes;


Begin
  New(PossMsg);
  ShowMsg := False;


  LNum:=0;
  
  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='The Next Count cannot be zero!';
  PossMsg^[2]:='The Next Count must be greater then zero!';


  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LCount do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    DocHed:=DocTypeFCode(CountTyp);

    Case Test of

      1  :  Begin

              Result:=(NextCount<>FullNomKey(0));

            end;

      2  :  Begin
              Move(NextCount[1],LNum,Sizeof(Lnum));

              Result:=(LNum>0);
            end;

    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}



procedure TDocNumRec.StoreId(Fnum,
                          Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpPWrd
       :  IncrementRec;

  KeyS :  Str255;

  mbRet:  Word;




Begin
  KeyS:='';

  Form2Id;


  With ExLocal,LCount do
  Begin
    COk:=CheckCompleted(LastEdit,BOff);



    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      If (LastEdit) then
      Begin

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpPWrd:=LCount;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LCount:=TmpPWrd;

        end;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end
      else
      Begin

        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end;

      Report_BError(Fnum,Status);


      Cursor:=CrDefault;

      InAddEdit:=BOff;

      If (LastEdit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      IdStored:=BOn;

      Send_UpdateList(LastEdit,16);

      LastValueObj.UpdateAllLastValues(Self);


      Close;
    end
    else
      SetFieldFocus;

  end; {With..}


end;


procedure TDocNumRec.SetFieldProperties(Field  :  TSBSPanel) ;

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


procedure TDocNumRec.EditLine(Edit       :  Boolean;
                             MMode      :  Byte);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    ProcessId(IncF,IncK,LastEdit);
  end;
end;


procedure TDocNumRec.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
      // MH 05/01/2011 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
      //                                   fields which processes the text and updates the value
      If (ActiveControl <> OkCP1Btn) Then
        // Move focus to OK button to force any OnExit validation to occur
        OkCP1Btn.SetFocus;

      // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
      If (ActiveControl = OkCP1Btn) Then
        StoreId(IncF,SKeypath);
    end
    else
      If (ModalResult=mrCancel) then
      Begin

        Begin
          Close;
          Exit;
        end;
      end;
  end; {With..}

end;


procedure TDocNumRec.NNumFEnter(Sender: TObject);
begin
  If (JustCreated) then
  Begin
    JustCreated:=BOff;
    PostMessage(Handle,wm_NextDlgCtl,1,0);
    PostMessage(Handle,wm_NextDlgCtl,0,0);
  end;

end;

procedure TDocNumRec.NNumFExit(Sender: TObject);
begin
  If (NNumF.MaxLength=7) and (NNumF.Value>3229977) then
    NNumF.Value:=3229977;
end;

end.

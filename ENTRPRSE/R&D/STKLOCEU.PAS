unit StkLocEU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, TEditVal, SBSPanel, bkgroup, Mask, GlobVar, ExWrap1U;


type
  TCompAdj = class(TForm)
    StkDesc: Text8Pt;
    SBSBackGroup1: TSBSBackGroup;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    FreeStk: TCurrencyEdit;
    OnOrd: TCurrencyEdit;
    OrdQty: TCurrencyEdit;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    Bevel1: TBevel;
    BinLocn: Text8Pt;
    StkDescLab: Label8;
    Label87: Label8;
    Label89: Label8;
    StkCodeF: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BinLocnExit(Sender: TObject);
  private
    { Private declarations }
    IdStored,
    StopPageChange,
    FirstEdit,
    JustCreated  :  Boolean;

    LastQty      :  Double;
    SKeypath     :  Integer;

    StkLocFilt   :  Str10;


    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildDesign;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure FormDesign;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    Procedure OutId;

    procedure Form2Id;

    procedure SetCaption;

    procedure SetFieldProperties(Field  :  TSBSPanel) ;

    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);


    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

  public
    { Public declarations }

    ExLocal    :  TdExLocal;


    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);


    procedure EditLine(Edit,
                       VO         :  Boolean;
                       Keypath    :  Integer);

  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  BorBtns,
  VarConst,
  ETStrU,
  ETDateU,
  ETMiscU,
  VARRec2U,
  BtrvU2,
  BtKeys1U,
  BTSupU1,
  BTSupU2,
  SBSComp2,
  CurrncyU,
  ComnUnit,
  ComnU2,


  ColCtrlU,

  CmpCtrlU,
  SysU2,

  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  BomCmpU,

  InvLst3U,

  DiscU3U,
  Saltxl1U;




{$R *.DFM}






{ ========== Build runtime view ======== }

procedure TCompAdj.BuildDesign;


begin


end;


procedure TCompAdj.FormDesign;


begin

  FreeStk.DecPlaces:=Syss.NoQtyDec;
  OrdQty.DecPlaces:=Syss.NoQtyDec;
  OnOrd.DecPlaces:=Syss.NoQtyDec;

  BuildDesign;

end;



procedure TCompAdj.SetCaption;

Begin
  Caption:='Component Adjustment. ';

  With ExLocal.LInv do
    Caption:=Caption+OurRef;
end;



procedure TCompAdj.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  JustCreated:=BOn;
  FirstEdit:=BOn;

  SKeypath:=0;

  ClientHeight:=152;
  ClientWidth:=427;

  With TForm(Owner) do
    Self.Left:=Left+2;


  If (Owner is TCmpSerCtrl) then
  With TCmpSerCtrl(Owner) do
  Begin
    Self.SetFieldProperties(A1CPanel);

  end;


  FormDesign;

end;


procedure TCompAdj.SetFieldProperties(Field  :  TSBSPanel) ;

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


procedure TCompAdj.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,117);

end;


procedure TCompAdj.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TCompAdj.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TCompAdj.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TCompAdj.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TCompAdj.Send_UpdateList(Edit   :  Boolean;
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



Function TCompAdj.CheckNeedStore  :  Boolean;

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


Procedure TCompAdj.SetFieldFocus;

Begin
  If (BinLocn.CanFocus) then
    BinLocn.SetFocus;
end; {Proc..}




Function TCompAdj.ConfirmQuit  :  Boolean;

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
                StoreId(IDetailF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(IDetailF,LastRecAddr[IDetailF]);

                Send_UpdateList(BOff,20);

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

Procedure TCompAdj.OutId;


Var
  TBo,
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  KeyS      :  Str255;


Begin
  With ExLocal,LId do
  Begin
    If (Stock.StockCode<>StockCode) then
      Global_GetMainRec(StockF,StockCode);

    FreeStk.Value:=QtyMul;

    If (Qty<0) then
      OnOrd.Value:=ABS(Qty)
    else
      OrdQty.Value:=ABS(Qty);

    StkDesc.Text:=Stock.Desc[1];
    StkCodeF.Text:=StockCode;
    BinLocn.Text:=MLocStk;

  end;

end;


procedure TCompAdj.Form2Id;

Begin

  With EXLocal.LId do
  Begin
    MLocStk:=UpCaseStr(BinLocn.Text);
  end; {with..}

end; {Proc..}





procedure TCompAdj.SetIdStore(EnabFlag,
                               VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  ExLocal.InAddEdit:=Not VOMode;

  OkCP1Btn.Enabled:=Not VOMode;

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is Text8Pt) then
    Begin
      If (Text8Pt(Components[Loop]).Tag=1) then
        Text8Pt(Components[Loop]).ReadOnly:= VOMode;
    end
      else
        If (Components[Loop] is TEditDate) then
        Begin
          If (TEditDate(Components[Loop]).Tag=1) then
            TEditDate(Components[Loop]).ReadOnly:= VOMode;
        end
        else
          If (Components[Loop] is TEditPeriod) then
          Begin
            If (TEditPeriod(Components[Loop]).Tag=1) then
              TEditPeriod(Components[Loop]).ReadOnly:= VOMode;
          end
          else
            If (Components[Loop] is TCurrencyEdit) then
            Begin
              If (TCurrencyEdit(Components[Loop]).Tag=1) then
                TCurrencyEdit(Components[Loop]).ReadOnly:= VOMode;
            end
            else
              If (Components[Loop] is TBorCheck) then
              Begin
                If (TBorCheck(Components[Loop]).Tag=1) then
                  TBorCheck(Components[Loop]).Enabled:= Not VOMode;
              end
              else
                If (Components[Loop] is TSBSComboBox) then
                Begin
                  If (TSBSComboBox(Components[Loop]).Tag=1) then
                    TSBSComboBox(Components[Loop]).ReadOnly:= VOMode;
              end;
  end; {Loop..}

end;



(*  Add is used to add Notes *)

procedure TCompAdj.ProcessId(Fnum,
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
  begin


    OutId;

  end; {If Abort..}

  SetIdStore(BOn,ExLocal.LViewOnly);

  SetFieldFocus;

  {FieldNextFix(Self.Handle,ActiveControl,Nil);}

end; {Proc..}



Function TCompAdj.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  1;


Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  KeyS     :  Str255;

  n,
  Test     :  Byte;

  FoundLong:  LongInt;

  FoundCode:  Str20;

  Loop,
  ShowMsg  :  Boolean;

  mbRet    :  Word;


Begin
  New(PossMsg);
  ShowMsg := False;

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='That Location Code is not valid.';


  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LId do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin

              Result:=Not EmptyKey(MLocStk,MLocKeyLen);

              If (Result) then
                Result:=Global_GetMainRec(MLocF,Quick_MLKey(MLocStk));

            end;


    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}




procedure TCompAdj.StoreId(Fnum,
                            Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpId
       :  Idetail;

  KeyS :  Str255;




Begin
  KeyS:='';

  Form2Id;


  With ExLocal,LId do
  Begin


    COk:=CheckCompleted(BOn,BOff);


    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      If (LastEdit) then
      Begin

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpId:=LId;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LId:=TmpId;

        end;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end;

      Report_BError(Fnum,Status);


      Cursor:=CrDefault;

      InAddEdit:=BOff;

      If (LastEdit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      IdStored:=BOn;

      SetIdStore(BOff,BOff);

      Send_UpdateList(LastEdit,2);

      LastValueObj.UpdateAllLastValues(Self);

      Close;
    end
    else
      SetFieldFocus;

  end; {With..}


end;




procedure TCompAdj.EditLine(Edit,
                            VO         :  Boolean;
                            Keypath    :  Integer);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    LViewOnly:=VO;

    SetCaption;

    ProcessId(IdetailF,KeyPath,LastEdit);
  end;
end;



procedure TCompAdj.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
      StoreId(IdetailF,SKeypath);
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




procedure TCompAdj.BinLocnExit(Sender: TObject);
Var
  FoundCode  :  Str10;

  FoundOk,
  AltMod     :  Boolean;

begin
  {$IFDEF SOP}
    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) or (FoundCode='')) and (ExLocal.InAddEdit) and (Syss.UseMLoc) and (ActiveControl<>CanCP1Btn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetMLoc(Self.Owner,FoundCode,FoundCode,'',0));

        If (FoundOk) then
        Begin

          StillEdit:=BOff;

          Text:=FoundCode;

          {* Weird bug when calling up a list caused the Enter/Exit methods
               of the next field not to be called. This fix sets the focus to the next field, and then
               sends a false move to previous control message ... *}

          {FieldNextFix(Self.Handle,ActiveControl,Sender);}

        end
        else
        Begin
          SetFocus;
        end; {If not found..}
      end;
    end; {with..}
  {$ENDIF}
end;


Initialization


end.

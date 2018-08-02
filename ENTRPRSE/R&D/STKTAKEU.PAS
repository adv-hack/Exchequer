unit StkTakeU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, TEditVal, SBSPanel, bkgroup, Mask, GlobVar, ExWrap1U;


type
  TStkTake = class(TForm)
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
    procedure OrdQtyExit(Sender: TObject);
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
                       Keypath    :  Integer;
                       SFilt      :  Str10);

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

  StkLstU,

  InvLst3U,

  DiscU3U,
  Saltxl1U;




{$R *.DFM}






{ ========== Build runtime view ======== }

procedure TStkTake.BuildDesign;


begin


end;


procedure TStkTake.FormDesign;

Var
  HideCC  :  Boolean;
  UseDec  :  Byte;

begin

  FreeStk.DecPlaces:=Syss.NoQtyDec;
  OrdQty.DecPlaces:=Syss.NoQtyDec;
  OnOrd.DecPlaces:=Syss.NoQtyDec;

  BuildDesign;

end;



procedure TStkTake.SetCaption;

Begin
  Caption:='Stock Take. ';

  {$IFDEF SOP}
    If (Not EmptyKey(StkLocFilt,LocKeyLen)) then
      Caption:=Caption+'- Locn : '+StkLocFilt+'. ';

  {$ENDIF}

  With ExLocal.LStock do
    Caption:=Caption+dbFormatName(StockCode,Desc[1]);
end;



procedure TStkTake.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  JustCreated:=BOn;
  FirstEdit:=BOn;

  SKeypath:=0;

  ClientHeight:=152;
  ClientWidth:=427;

  With TForm(Owner) do
    Self.Left:=Left+2;


  If (Owner is TStkList) then
  With TStkList(Owner) do
  Begin
    Self.SetFieldProperties(STBPanel);

  end;


  FormDesign;

end;


procedure TStkTake.SetFieldProperties(Field  :  TSBSPanel) ;

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


procedure TStkTake.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,117);

end;


procedure TStkTake.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TStkTake.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TStkTake.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TStkTake.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TStkTake.Send_UpdateList(Edit   :  Boolean;
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



Function TStkTake.CheckNeedStore  :  Boolean;

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


Procedure TStkTake.SetFieldFocus;

Begin
  If (OrdQty.CanFocus) then
    OrdQty.SetFocus;
end; {Proc..}




Function TStkTake.ConfirmQuit  :  Boolean;

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
                StoreId(StockF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(StockF,LastRecAddr[StockF]);

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

Procedure TStkTake.OutId;


Var
  TBo,
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  KeyS      :  Str255;


Begin
  With ExLocal,LStock do
  Begin

    Stock_LocTkSubst(LStock,StkLocFilt);

    FreeStk.Value:=CaseQty(LStock,QtyFreeze);

    OrdQty.Value:=CaseQty(LStock,QtyTake);

    If (StkFlg) then
      OnOrd.Value:=CaseQty(LStock,QtyTake-QtyFreeze)
    else
      OnOrd.Value:=0;


    StkDesc.Text:=Desc[1];
    StkCodeF.Text:=StockCode;
    BinLocn.Text:=BinLoc;


  end;

end;


procedure TStkTake.Form2Id;

Var
  TmpId  :  IDetail;

Begin

  With EXLocal,LStock do
  Begin
    SetE2CId(TmpId,LStock);

    QtyTake:=Case2Ea(TmpId,LStock,OrdQty.Value);
  end; {with..}

end; {Proc..}





procedure TStkTake.SetIdStore(EnabFlag,
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

procedure TStkTake.ProcessId(Fnum,
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

  FieldNextFix(Self.Handle,ActiveControl,Nil);

end; {Proc..}







procedure TStkTake.StoreId(Fnum,
                            Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpStk
       :  StockRec;

  KeyS :  Str255;




Begin
  KeyS:='';

  Form2Id;


  With ExLocal,LStock do
  Begin


    COk:=BOn;


    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      STKFlg:=(QtyFreeze<>QtyTake);

      If (LastEdit) then
      Begin

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpStk:=LStock;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LStock:=TmpStk;

        end;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end;

      Report_BError(Fnum,Status);


      Cursor:=CrDefault;

      InAddEdit:=BOff;

      If (LastEdit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      If (StatusOk) and (Not EmptyKey(StkLocFilt,LocKeyLen)) then
        Update_LocROTake(LStock,StkLocFilt,1);

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




procedure TStkTake.EditLine(Edit,
                             VO         :  Boolean;
                             Keypath    :  Integer;
                             SFilt      :  Str10);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    LViewOnly:=VO;

    AssignFromGlobal(StockF);

    StkLocFilt:=SFilt;

    SetCaption;

    ProcessId(StockF,KeyPath,LastEdit);
  end;
end;



procedure TStkTake.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) and (FormStyle<>fsNormal) then
    Begin
      // Move focus to OK button to force OnExit validation/formatting to kick in
      If OkCP1Btn.CanFocus Then
        OkCP1Btn.SetFocus;
      // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
      If (ActiveControl = OkCP1Btn) Then
      begin
        StoreId(StockF,SKeypath);
      end;
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







procedure TStkTake.OrdQtyExit(Sender: TObject);
begin
  With ExLocal,LStock do
  Begin
    Form2Id;
    OnOrd.Value:=CaseQty(LStock,QtyTake-QtyFreeze);
    OrdQty.Value:=CaseQty(LStock,QtyTake);
  end;
end;

Initialization


end.

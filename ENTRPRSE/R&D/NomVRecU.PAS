unit NomVRecU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel, BorBtns, BarGU,
  GlobVar,VarConst,ExWrap1U,CmpCtrlU,SBSOutL,BTSupU1, bkgroup;


type
  TNomVRec = class(TForm)
    NIPF: TBorCheck;
    NIDF: Text8Pt;
    NITF: TSBSComboBox;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    NIFF: Text8Pt;
    SBSPanel1: TSBSBackGroup;
    Label81: Label8;
    Label84: Label8;
    NIACF: Text8Pt;
    Label85: Label8;
    NIFJCF: TBorCheck;
    SBSBackGroup1: TSBSBackGroup;
    Label86: Label8;
    NIVNF: TCurrencyEdit;
    Label87: Label8;
    Label88: Label8;
    NICF: Text8Pt;
    Label89: Label8;
    A1CCF: Text8Pt;
    CCLab: Label8;
    A1DpF: Text8Pt;
    DepLab: Label8;
    Label810: Label8;
    Label811: Label8;
    NIVDF: Text8Pt;
    NIICF: TBorCheck;
    NIVCF: Text8Pt;
    NIIUF: TSBSComboBox;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure NICFExit(Sender: TObject);
    procedure NITFEnter(Sender: TObject);
    procedure NIFFEnter(Sender: TObject);
    procedure NIFFExit(Sender: TObject);
    procedure NICFEnter(Sender: TObject);
    procedure NIFJCFClick(Sender: TObject);
    procedure NIVNFExit(Sender: TObject);
    procedure NIVCFExit(Sender: TObject);
    procedure A1CCFExit(Sender: TObject);
    procedure NIICFClick(Sender: TObject);
    procedure NIIUFChange(Sender: TObject);
  private
    CanDelete,
    IdStored,
    StopPageChange,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;
    NITLastValue:  LongInt;

    Progress     :  TBarP;


    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildDesign;

    procedure FormDesign;

    Procedure SetCaption;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    Function NType2List(QT  :  Char)  :  Integer;

    Function List2NType(QT  :  Integer)  :  Char;

    Procedure HideFieldsxType;

    Procedure OutId;

    procedure Form2Id;

    Function NomGood_Type(OTyp  :  Char;
                          Change:  Boolean)  :  Boolean;

    Procedure Change_Details(Renumb  :  Boolean);


    Procedure StartChange;


    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

  public
    { Public declarations }

    Level_View,
    Level_Code :  LongInt;

    ParentCtrl :  ViewCtrlType;

    ExLocal    :  TdExLocal;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSOutLineB) ;

    procedure EditLine(RNomView   :  NomViewRec;
                       Edit       :  Boolean);


    procedure DeleteNomLine(Fnum,
                            KeyPath  :  Integer);

  end;


  Procedure BuildView_Ndx(ExLocal      :  TdExLocal);


Procedure Copy_StdNom(Var ExLocal      :  TdExLocal;
                          ViewNo,
                          CatCode,Level,
                          ViewCatCode,
                          PrimeCode    :  LongInt;
                          MViewCtrl    :  ViewCtrlType);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BtKeys1U,
  BTSupU2,
  SBSComp2,
  CurrncyU,
  ComnUnit,
  ComnU2,


  ColCtrlU,

  SysU2,
  MiscU,
  PWarnU,
  NomView1,

  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}
  PayF2U,
  ExThrd2U,
  {PayLineU,}

  ThemeFix,

  Saltxl1U;




{$R *.DFM}


Const
  NVTAry  :  Array[0..1] of Char = ('8','9');


{ == Proc to build all the Views indexes == }

Procedure BuildView_Ndx(ExLocal      :  TdExLocal);

Begin
  With ExLocal,LNomView^.NomViewLine do
  Begin
    NVCode1:=FullNVCode(#0,#0,NomViewNo,ViewCode,BOff);
    NVCode2:=FullNVIdx(#0,#0,NomViewNo,ViewIdx,BOff);
    NVCode3:=FullNVCatIdx(#0,#0,NomViewNo,ViewIdx,ViewCat,BOff);
    NVCode4:=FullNVCode(#0,#0,NomViewNo,AltCode,BOff);
  end;
end;

{ == Function to Get next View No. == }

Function Get_NextViewIdx(Var ExLocal      :  TdExLocal;
                             Fnum2,KPath  :  Integer;
                             Level_View   :  LongInt) :  LongInt;

Var
  TmpRecAddr,
  TmpKPath :  LongInt;

  TmpStat  :  Integer;

  KeySChk,
  KeySC    :  Str255;

  TmpNV    :  NomViewRec;

Begin
  Result:=10;

  With ExLocal do
  Begin
    TmpNV:=LNomView^;

    TmpKPath:=KPath;

    TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOff,BOff);

    KeySChk:=PrimeNVCode(NVRCode,NVVSCode,Level_View,BOn);

    KeySC:=KeySChk+Dec2Hex(65535);

    Status:=Find_Rec(B_GetLessEq,F[Fnum2],Fnum2,LRecPtr[Fnum2]^,NVViewIdxK,KeySC);

    If (StatusOk) and (CheckKey(KeySChk,KeySC,Length(KeySChk),BOff))  then
      Result:=LNomView^.NomViewLine.ViewIdx+10;

    TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],TmpRecAddr,BOn,BOff);

    LNomView^:=TmpNV;
  end;


end;


{ == Proc to copy standard G/L into View structure == }

Procedure Copy_StdNom(Var ExLocal      :  TdExLocal;
                          ViewNo,
                          CatCode,Level,
                          ViewCatCode,
                          PrimeCode    :  LongInt;
                          MViewCtrl    :  ViewCtrlType);

Const
  Fnum     = NomF;
  Keypath  = NomCatK;
  Fnum2    = NomViewF;
  Keypath2 = NVCodeK;

Var
  KeyS,
  KeyChk   :   Str255;

  TmpRecAddr,
  TmpKPath :  LongInt;

  TmpStat  :  Integer;


Begin
  If (Level=0) and (PrimeCode<>0) then
    KeyChk:=FullIdKey(CatCode,PrimeCode)
  else
    KeyChk:=FullNomKey(CatCode);

  KeyS:=KeyChk;

  TmpKPath:=KeyPath;


  With ExLocal do
  Begin

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With LNom do
    Begin

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      Application.ProcessMessages;

      With LNomView^,NomViewLine do
      Begin
        LResetRec(Fnum2);

        RecPFix:=NVRCode;
        SubType:=NVVSCode;

        If (NomType=NomHedCode) then
          ViewType:=ViewHedCode
        else
          ViewType:=ViewBalCode;

        LinkType:=NomType;

        ViewCode:=LJVar(Form_Int(NomCode,0),VNomKeyLen);
        AltCode:=LJVar(LNom.AltCode,VNomKeyLen);

        ViewCat:=ViewCatCode;
        NomViewNo:=ViewNo;

        Desc:=LNom.Desc;
        LinkGL:=NomCode;
        AutoDesc:=BOn;
        
        ViewIdx:=Get_NextViewIdx(ExLocal,Fnum2,KeyPath2,ViewNo);
        ABSViewIdx:=ViewIdx;

        LinkCCDep:=MViewCtrl.LinkCCDep;
        IncBudget:=MViewCtrl.IncBudget;
        IncCommit:=MViewCtrl.IncCommit;
        IncUnposted:=MViewCtrl.IncUnPosted;


        BuildView_Ndx(ExLocal);

        Status:=Add_Rec(F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPAth2);

        Report_BError(Fnum2,Status);

        If (NomType=NomHedCode) then {Recurse down through the levels}
          Copy_StdNom(ExLocal,ViewNo,NomCode,Succ(Level),ViewIdx,0,MViewCtrl);

      end;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);

    end;

  end; {With..}



end;




{ ========== Build runtime view ======== }

procedure TNomVRec.BuildDesign;


begin


end;


procedure TNomVRec.FormDesign;

Var
  HideCC  :  Boolean;
  UseDec  :  Byte;

begin
  NIDF.MaxLength:=NomDesLen;

  NITF.ItemIndex:=0;

  NIVNF.DisplayFormat:='';

  If (Not Syss.UseCCDep) then
  Begin
    CCLab.Visible:=BOff;
    DepLab.Visible:=BOff;
    A1CCF.Visible:=BOff;
    A1DpF.Visible:=BOff;

  end;

  {$IFNDEF SOP}
    NIICF.Visible:=BOff;

  {$ENDIF}

  BuildDesign;

end;



Procedure TNomVRec.SetCaption;

Begin
  With ExLocal,LNomView^.NomViewLine do
  Begin
    Caption:='General Ledger View Account - '+dbFormatName(ViewCode,Desc)+'. ';
  end;
end;


procedure TNomVRec.FormCreate(Sender: TObject);
begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  ClientHeight:=272;
  ClientWidth:=372;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TNViews) then
    With TNViews(Owner) do
      Self.SetFieldProperties(NLOLine);

  FormDesign;

  Blank(ParentCtrl,Sizeof(ParentCtrl));
  
  CanDelete:=BOn;

end;




procedure TNomVRec.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,100);

end;

procedure TNomVRec.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TNomVRec.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TNomVRec.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TNomVRec.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


{ == Procedure to Send Message to Get Record == }

Procedure TNomVRec.WMCustGetRec(Var Message  :  TMessage);



Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      38  :  Change_Details(BOn);

    end; {Case..}

  end;
  Inherited;
end;


{ == Procedure to Send Message to Get Record == }

Procedure TNomVRec.Send_UpdateList(Edit   :  Boolean;
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



Function TNomVRec.CheckNeedStore  :  Boolean;

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


Procedure TNomVRec.SetFieldFocus;

Begin
  If (CanDelete) and (NICF.CanFocus) then
  Begin
    NICF.SetFocus
  end
  else
  Begin
    If (NIDF.CanFocus) then
      NIDF.SetFocus;
  end;

end; {Proc..}




Function TNomVRec.ConfirmQuit  :  Boolean;

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
                StoreId(NomViewF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(NomViewF,LastRecAddr[NomViewF]);


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


Function TNomVRec.NType2List(QT  :  Char)  :  Integer;

Var
  n        :  Byte;
  FoundOk  :  Boolean;


Begin
  FoundOk:=BOff;

  For n:=0 to High(NVTAry) do
  Begin
    FoundOk:=(QT=NVTAry[n]);
    If (FoundOk) then
      Break;
  end;

  If (FoundOk) then
    Result:=n
  else
    Result:=0;

end;


Function TNomVRec.List2NType(QT  :  Integer)  :  Char;

Begin
  If (QT In [Low(NVTAry)..High(NVTAry)]) then
    Result:=NVTAry[QT]
  else
    Result:=NVTAry[0];
end;

Procedure TNomVRec.HideFieldsxType;
Var
  ShowField  :  Boolean;
Begin
  ShowField:=(List2NType(NITF.ItemIndex) =NVTAry[0]);

  {NIVNF.Enabled:=ShowField or (Not ExLocal.LastEdit);
  {NIVCF.Enabled:=ShowField;}
  NIVDF.Enabled:=ShowField;

  NIFJCF.Enabled:=(Trim(NIVCF.Text)<>'');

  A1CCF.Enabled:=ShowField;
  A1DpF.Enabled:=ShowField;
  NIPF.Enabled:=ShowField;
  NIIUF.Enabled:=ShowField;

  {$IFDEF SOP}
    NIICF.Visible:=ShowField and CommitAct;

    NIICF.Enabled:=(NIIUF.ITemIndex=0);

    NIIUF.Enabled:=Not NIICF.Checked;
  {$ELSE}
    NIICF.Visible:=BOff;
  {$ENDIF}

  NIPf.Visible:=ShowField;
  {NICF.Enabled:=ShowField;}
  NIIUF.Visible:=ShowField;

  If (NIFJCF.Checked) then
  Begin
    NIDf.Text:=NIVDF.Text;

    With NIDF do
    Begin
      color:=NIVDF.Color;

      Font.Color:=NIVDF.Font.Color;

      TabStop:=BOff;
      ReadOnly:=BOn;
      Tag:=0;
    end;

    {* b5471.032. EL: Sent to prevent miscoloring bug under XP when the color is grayed out. *}
    PostMessage(NIDF.Handle, WM_MOUSEMOVE, 0, 0);

  end
  else
  With NIDF do
  Begin
    color:=NIVCF.Color;
    Font.Color:=NIVCF.Font.Color;

    TabStop:=BOn;
    ReadOnly:=BOff;
    Tag:=1;

  end;

end;



{ ============== Display Id Record ============ }

Procedure TNomVRec.OutId;


Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  FoundLong :  Integer;

  KeyS      :  Str255;


Begin
  With ExLocal,LNomView^.NomViewLine do
  Begin

    NICF.Text:=Trim(ViewCode);
    NIACF.Text:=Trim(AltCode);

    NIVNF.Value:=ViewIdx;
    NIVCF.Text:=Form_BInt(LinkGL,0);
    NIFJCF.Checked:=AutoDesc;
    A1CCF.Text:=LinkCCDep[BOn];
    A1DpF.Text:=LinkCCDep[BOff];
    NIPf.Checked:=IncBudget;
    NIIUF.ItemIndex:=IncUnposted;
    NIDF.Text:=Trim(Desc);
    NIICF.Checked:=IncCommit;

    NITF.ItemIndex:=Ntype2List(ViewType);
    NIFF.Text:=Form_BInt(CarryF,0);

    If (LinkGL<>0) then
    Begin
      If GetNom(Self,Form_Int(LinkGL,0), FoundLong,-1) then
        NIVDf.Text:=Nom.Desc
      else
        NIVDF.Text:='G/L Link not found!';

     If (AutoDesc) then
       NIDF.Text:=Nom.Desc;
    end;

    HideFieldsxType;

  end;

end;


procedure TNomVRec.Form2Id;

Begin

  With EXLocal.LNomView^.NomViewLine do
  Begin
    ViewCode:=LJVar(NICF.Text,VNomKeyLen);
    AltCode:=LJVar(NIACF.Text,VNomKeyLen);

    ViewIdx:=Trunc(NIVNF.Value);

    LinkGL:=IntStr(Trim(NIVCF.Text));


    AutoDesc:=NIFJCF.Checked;
    LinkCCDep[BOn]:=A1CCF.Text;
    LinkCCDep[BOff]:=A1DpF.Text;

    IncBudget:=NIPf.Checked;
    IncUnposted:=NIIUF.ItemIndex;
    Desc:=NIDF.Text;
    
    IncCommit:=NIICF.Checked;

    ViewType:=List2NType(NITF.ItemIndex);
    NIFF.Text:=Form_BInt(CarryF,0);

    CarryF:=IntStr(NIFF.Text);

  end; {with..}

end; {Proc..}



procedure TNomVRec.SetIdStore(EnabFlag,
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

  NIFJCF.Enabled:=(Trim(NIVCF.Text)<>'');

end;



(*  Add is used to add Notes *)

procedure TNomVRec.ProcessId(Fnum,
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

    SetCaption;

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
  With ExLocal,LNomView^,NomViewLine do
  begin

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      RecPFix:=NVRCode;
      SubType:=NVVSCode;
      ViewType:=ViewHedCode;
      {AutoDesc:=BOn;}

      ViewCat:=Level_Code;
      NomViewNo:=Level_View;

      ViewIdx:=Get_NextViewIdx(ExLocal,Fnum,KeyPath,Level_View);
      ABSViewIdx:=ViewIdx;

      LinkCCDep:=ParentCtrl.LinkCCDep;
      IncBudget:=ParentCtrl.IncBudget;
      IncCommit:=ParentCtrl.IncCommit;
      IncUnposted:=ParentCtrl.IncUnposted;

      CanDelete:=BOn;

      NIFJCFClick(Nil);

    end
    else
      CanDelete:=BOn;

    LastNomView^:=LNomView^;

    OutId;

    SetIdStore(BOn,ExLocal.LViewOnly);


    SetFieldFocus;

  end; {If Abort..}

end; {Proc..}




Function TNomVRec.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  3;
  Fnum         =  NomViewF;
  Keypath      =  NVCodeK;


Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  KeyS     :  Str255;

  Test     :  Byte;

  FoundCode:  Str20;

  Loop,
  ShowMsg  :  Boolean;

  mbRet    :  Word;


Begin
  New(PossMsg);


  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='That View Code already exists.';
  PossMsg^[2]:='That View Code is not valid.';
  PossMsg^[3]:='That View Account Type is not valid.';

  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LNomView^,NomViewLine do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              If (Not Edit) then
                Result:=Not (CheckExsists(Strip('R',[#0],FullNVCode(RecPFix,SubType,NomViewNo,ViewCode,BOn)),Fnum,Keypath))
              else
                Result:=BOn;
            end;

      2  :  Result:=(Trim(ViewCode)<>'') and (ViewIdx<>0);

      {3  :  If (LastNom.NomType<>NomType) then
              Result:=NomGood_Type(NomType,CanDelete) and NomGood_Type2(NomType,CAT);}  


    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}




{ ======= Function to Determine if a nominal code type change is acceptable ===== }

Function TNomVRec.NomGood_Type(OTyp  :  Char;
                              Change:  Boolean)  :  Boolean;


Begin

  NomGood_Type:=((Change) or (Not (OTyp In [NomHedCode,CarryFlg])));

end;




Procedure TNomVRec.Change_Details(Renumb  :  Boolean);

Const
  Fnum   =  NomViewF;
  Keypath=  NVCatK;

Var
  RecAddr,
  TmpRecAddr,
  PurgeCount,
  TmpKPath :  LongInt;

  B_Func,
  TmpStat  :  Integer;

  KeyS,
  KeyChk  :  Str255;

  VCtrl   :  NomViewType;

  TmpNomView
          :  NomViewRec;



Begin
  With ExLocal do
  Begin
    VCtrl:=LNomView^.NomViewLine;  B_Func:=B_GetNext;

    If (Renumb) then
      KeyChk:=FullNVIdx(NVRCode,NVVSCode,LastNomView^.NomViewLine.NomViewNo,LastNomView^.NomViewLine.ViewIdx,BOn)
    else
      KeyChk:=PrimeNVCode(NVRCode,NVVSCode,VCtrl.NomViewNo,BOn);

    KeyS:=KeyChk;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    Try
    Begin
      TmpNomView:=LNomView^;

      PurgeCount:=0;
      Progress.CanCP1Btn.Visible:=BOn;

      Progress.Gauge1.MaxValue:=Used_Recs(F[Fnum],Fnum);

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);



      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Progress.KeyR<>mrAbort) do
      With LNomView^,NomViewLine do
      Begin
        Application.ProcessMessages;

        Inc(PurgeCount);

        Progress.Gauge1.Progress:=PurgeCount;

        If (Renumb) and (ViewCat<>VCtrl.ViewIdx) then
        Begin
          ViewCat:=VCtrl.ViewIdx;
          BuildView_Ndx(ExLocal);
        end
        else
          B_Func:=B_GetNext;


        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        Report_BError(Fnum,Status);

        If (StatusOk) and (Renumb) then
        Begin
          B_Func:=B_GetGEq;
        end
        else
          B_Func:=B_GetNext;

        Status:=Find_Rec(B_Func,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);


      end;

      Progress.Gauge1.Progress:=Used_Recs(F[Fnum],Fnum);

    end;
    finally
      Progress.ShutDown;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

      ExLocal.LNomView^:=TmpNomView;
    end; {Try..}

  end;
end;

Procedure TNomVRec.StartChange;

begin
  Progress:=TBarP.Create(Self);

  try

    Progress.Caption:='Recoding Branches';

    Set_BackThreadMVisible(BOn);


    Progress.ShowModal;

  finally

    Progress.Free;

    Set_BackThreadMVisible(BOff);

  end;
end;




procedure TNomVRec.StoreId(Fnum,
                          Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpNomView
       :  NomViewRec;

  KeyS :  Str255;

  NewNType
       :  Char;




Begin
  KeyS:='';    NewNType:=#0;

  Form2Id;


  With ExLocal,LNomView^,NomViewLine do
  Begin
    If (LastEdit) and (LastNomView^.NomViewLine.ViewCode<>ViewCode) then
    Begin
      COk:=(Not Check4DupliGen(FullNVCode(RecPFix,SubType,NomViewNo,ViewCode,BOn),Fnum,Keypath,'View'));
    end
    else
      COk:=BOn;

    If (COk) then
    Begin
      If (LastEdit) and (LastNomView^.NomViewLine.ViewIdx<>ViewIdx) then
      Begin
        COk:=(Not Check4DupliGen(FullNVIdx(RecPFix,SubType,NomViewNo,ViewIdx,BOn),Fnum,NVViewIdxk,'View Order'));
      end
      else
        COk:=BOn;

    end;

    If (COk) then
      COk:=CheckCompleted(LastEdit,BOff);


    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      BuildView_Ndx(ExLocal);

      If (LastEdit) then
      Begin

        {If (LastNom.NomType<>NomType) then {*EN571 We need to implement implication of type change, not sure there will be any other than header
        Begin
          NewNType:=NomType;
          NomType:=LastNom.NomType;

          GLTypeChange(LNom,NewNType,TForm(Self.Owner));
        end;}

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpNomView:=LNomView^;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LNomView^:=TmpNomView;

        end;


        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end
      else
      Begin

        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end;

      Report_BError(Fnum,Status);

      If (StatusOk) then
      Begin
        SetCaption;

        If (LastEdit) then
        Begin
          If ((LastNomView^.NomViewLine.ViewType<>ViewType) and (LastNomView^.NomViewLine.ViewType=NVTAry[1])) then
            Send_UpdateList(BOn,203)
          else
            If ((LastNomView^.NomViewLine.ViewIdx<>ViewIdx)) then
              StartChange;
        end
      end;

      Cursor:=CrDefault;

      InAddEdit:=BOff;

      If (LastEdit) then
      Begin
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      end;

      IdStored:=BOn;

      Send_UpdateList(LastEdit and (LastNomView^.NomViewLine.ViewIdx=ViewIdx),0);

      SetIdStore(BOff,BOff);

      LastValueObj.UpdateAllLastValues(Self);

      Close;
    end
    else
      SetFieldFocus;

  end; {With..}


end;


procedure TNomVRec.SetFieldProperties(Field  :  TSBSOutLineB) ;

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


procedure TNomVRec.EditLine(RNomView   :  NomViewRec;
                            Edit       :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    LNomView^:=RNomView;

    ProcessId(NomViewF,NVCodeK,LastEdit);
  end;
end;


procedure TNomVRec.DeleteNOMLine(Fnum,
                                KeyPath  :  Integer);

Var
  MbRet  :  Word;
  GotRec :  Integer;
  KeyS   :  Str255;

Begin
  With ExLocal do
  Begin
    AssignFromGlobal(Fnum);
    LGetRecAddr(Fnum);
    OutId;
    OKCP1Btn.Enabled:=BOff;
    CanCP1Btn.Enabled:=BOff;

    MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this record',
                       mtConfirmation,[mbYes,mbNo],0);

    If (MbRet=MrYes) then
    Begin
      Status:=LGetDirectRec(Fnum,KeyPath);

      If (StatusOk) then
      Begin

        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,GlobLocked);

        If (Ok) and (GlobLocked) then
        Begin

          Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

          Report_BError(Fnum,Status);
        end;

        If (StatusOk) then
        With ExLocal.LNomView^.NomViewLine do
        Begin
          KeyS:=ViewType+PostNVIdx(NomViewNo,ABSViewIdx);
          DeleteLinks(KeyS,NHistF,Length(KeyS),NHK,BOff);

          Send_UpdateList(BOff,200);


        end;
      end; {If line is valid for deletion..}
    end
    else
      Report_BError(Fnum,Status);
  end; {With..}

  Close;
end; {PRoc..}


procedure TNomVRec.CanCP1BtnClick(Sender: TObject);
Begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
      // MH 22/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
      //                                   fields which processes the text and updates the value
      If (ActiveControl <> OkCP1Btn) Then
        // Move focus to OK button to force any OnExit validation to occur
        OkCP1Btn.SetFocus;

      // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
      If (ActiveControl = OkCP1Btn) Then
        StoreId(NomViewF,SKeypath);
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
end; {Proc..}


procedure TNomVRec.NICFEnter(Sender: TObject);
begin
  With NICF do
    ReadOnly:=(ReadOnly or (Not CanDelete));
end;


procedure TNomVRec.NICFExit(Sender: TObject);
Var
  COk   :  Boolean;
  CCode :  Str100;


begin

  If (Sender is Text8pt) then
  With (Sender as TExt8pt),ExLocal,LNomView^ do
  Begin

    If ((Not LastEdit) or (Trim(LastNomView^.NomViewLine.ViewCode)<>Text)) and (InAddEdit) and (Not ReadOnly) and (ActiveControl<>CanCP1Btn) then
    Begin
      CCode:=FullNVCode(RecPFix,SubType,NomViewLine.NomViewNo,Text,BOn);


      COk:=(Not Check4DupliGen(CCode,NomViewF,NVCodeK,'General Ledger View Code ('+Text+')'));

      If (Not COk) then
      Begin

        SetFocus;

      end
      else
        If (Not LastEdit) and (NIACF.Text='') then
          NIACF.Text:=Text;

    end;
  end;
end;

procedure TNomVRec.NIVNFExit(Sender: TObject);
Var
  COk   :  Boolean;
  CCode :  Str50;


begin

  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit),ExLocal,LNomView^ do
  Begin

    If ((Not LastEdit) or (LastNomView^.NomViewLine.ViewIdx<>Value)) and (InAddEdit) and (Not ReadOnly) and (ActiveControl<>CanCP1Btn) then
    Begin
      CCode:=FullNVIdx(RecPFix,SubType,NomViewLine.NomViewNo,Trunc(Value),BOn);


      COk:=(Not Check4DupliGen(CCode,NomViewF,NVViewIdxK,'General Ledger View Order ('+Form_Int(Trunc(Value),0)+')'));

      If (Not COk) then
      Begin

        SetFocus;

      end

    end;
  end;
end;

procedure TNomVRec.NITFEnter(Sender: TObject);
begin
  With NITF do
  Begin
    If (Not ChkAllowed_In(198)) then
      ReadOnly:=(ReadOnly or (Not CanDelete));

    NITLastValue:=ItemIndex;
  end;
end;

procedure TNomVRec.NIFFEnter(Sender: TObject);
begin
  With NIFF do
  Begin
    ReadOnly:=(ReadOnly or (List2NType(NITF.ItemIndex)<>CarryFlg));
  end;
end;

procedure TNomVRec.NIFFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  FoundLong  :  LongInt;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) and (ExLocal.InAddEdit) and (Not ReadOnly) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self.Owner,FoundCode,FoundLong,1));

      If (FoundOk) then
      Begin

        Text:=Form_Int(FoundLong,0);


      end
      else
      Begin
        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;


{Proc..}


procedure TNomVRec.NIFJCFClick(Sender: TObject);
begin
  HideFieldsxType;
end;


procedure TNomVRec.NIVCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  FoundLong  :  LongInt;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>CanCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self,FoundCode,FoundLong,99));


      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=Form_Int(FoundLong,0);

        NIVDF.Text:=Nom.Desc;

        If (NIFJCF.Checked) then
          NIDF.Text:=Nom.Desc;

        With ExLocal.LNomView^.NomViewLine do
          LinkType:=Nom.NomType;

        If (Not ExLocal.LastEdit) then
          NIFJCF.Checked:=BOn;

        If (Not ExLocal.LastEdit) then
        Begin
          NITf.ItemIndex:=0;
          HideFieldsxType;
        end
        else
          NIFJCF.Enabled:=(Trim(NIVCF.Text)<>'');

      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;

procedure TNomVRec.A1CCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  IsCC       :  Boolean;


begin
  Inherited;

  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      FoundCode:=Name;

      IsCC:=Match_Glob(Sizeof(FoundCode),'CC',FoundCode,FoundOk);

      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If (AltMod) and (ActiveControl<>CanCP1Btn) and
          (Syss.UseCCDep)  and (FoundCode<>'') and (Not Has_CCWildChar(FoundCode)) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetCCDep(Self,FoundCode,FoundCode,IsCC,0));


        If (FoundOk) then
        Begin

          StillEdit:=BOff;

          Text:=FoundCode;

        end
        else
        Begin

          SetFocus;
        end; {If not found..}
      end;

    end; {with..}
  {$ENDIF}
end;

procedure TNomVRec.NIICFClick(Sender: TObject);
begin
  If (NIICF.Checked) then
  Begin

    NIIUF.ITemIndex:=0;
  end
  else
  Begin


  end;

  NIIUF.Enabled:=Not NIICF.Checked;
end;

procedure TNomVRec.NIIUFChange(Sender: TObject);
begin
  NIICF.Enabled:=(NIIUF.ITemIndex=0);

  If (Not NIICF.Enabled) then
    NIICF.Checked:=BOff;
end;

end.




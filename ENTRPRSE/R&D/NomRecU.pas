unit NomRecU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel, BorBtns,
  GlobVar,VarConst,ExWrap1U,CmpCtrlU,SBSOutL, bkgroup;


type
  TNomRec = class(TForm)
    NIPF: TBorCheck;
    NIDF: Text8Pt;
    NITF: TSBSComboBox;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    NIRF: TBorCheck;
    NIFF: Text8Pt;
    NICF: TCurrencyEdit;
    SBSPanel1: TSBSBackGroup;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    Label84: Label8;
    NIACF: Text8Pt;
    Label85: Label8;
    CurrF: TSBSComboBox;
    Label86: Label8;
    NIFJCF: TBorCheck;
    cbHideGL1: TBorCheck;
    NICLF: TSBSComboBox;
    Label87: Label8;

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
    procedure NITFExit(Sender: TObject);
    procedure NIFFEnter(Sender: TObject);
    procedure NIFFExit(Sender: TObject);
    procedure NICFEnter(Sender: TObject);
    procedure CurrFEnter(Sender: TObject);
  private
    CanDelete,
    IdStored,
    StopPageChange,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;

    RVLevel,
    NITLastValue:  LongInt;


    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildDesign;

    procedure FormDesign;

    Procedure SetCaption;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;


    Procedure HideFieldsxType;

    
    Procedure OutId;

    procedure Form2Id;

    Function NomGood_Type(OTyp  :  Char;
                          Change:  Boolean)  :  Boolean;

    Function In_PandL(GLCat  :  LongInt)  :  Boolean;

    Function NomGood_Type2(OTyp  :  Char;
                           GLCat :  LongInt)  :  Boolean;

    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

    Function CanReVal  :  Boolean;

    procedure SetHelpContextIDs; // NF: 22/06/06

  public
    { Public declarations }

    Level_Code :  LongInt;

    ExLocal    :  TdExLocal;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSOutLineB) ;


    procedure EditLine(RNom       :  NominalRec;
                       Edit       :  Boolean);

    procedure DeleteNomLine(Fnum,
                            KeyPath  :  Integer);

  end;


  Function NType2List(QT  :  Char)  :  Integer;
  Function List2NType(QT  :  Integer)  :  Char;


  {$IFDEF LTE}
    Function CheckParentRV(GLCat  :  LongInt;
                           Mode   :  Byte;
                       Var Level  :  LongInt)  :  Boolean;

  {$ENDIF}

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
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

  SysU2,
  MiscU,
  PWarnU,
  Nominl1U,

  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}
  PayF2U,

  {PayLineU,}

  ThemeFix,

  Saltxl1U;




{$R *.DFM}


Const
  NTAry  :  Array[0..4] of Char = ('B','A','C','H','F');



  Function NType2List(QT  :  Char)  :  Integer;
  Var
      n        :  Byte;
      FoundOk  :  Boolean;


    Begin
      FoundOk:=BOff;

      For n:=0 to High(NTAry) do
      Begin
        FoundOk:=(QT=NTAry[n]);
        If (FoundOk) then
          Break;
      end;

      If (FoundOk) then
        Result:=n
      else
        Result:=0;

    end;


    Function List2NType(QT  :  Integer)  :  Char;

    Begin
      If (QT In [Low(NTAry)..High(NTAry)]) then
        Result:=NTAry[QT]
      else
        Result:=NTAry[0];
    end;


{$IFDEF LTE}

  { ==== Procedure to check if nom's immediate parent is set to revalue  ==== }

  Function CheckParentRV(GLCat  :  LongInt;
                         Mode   :  Byte;
                     Var Level  :  LongInt)  :  Boolean;

  Const
    Fnum     =  NomF;
    Keypath  =  NomCodeK;

  Var
    KeyS,
    KeyChk   :  Str255;


    IsDRCr,
    FoundOk  :  Boolean;

    TmpKPath,
    TmpStat
             : Integer;

    TmpRecAddr
             :  LongInt;

    TmpNom   :  NominalRec;

  Begin
    FoundOk:=BOff;

    TmpNom:=Nom;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(NomF,TmpKPath,F[NomF],TmpRecAddr,BOff,BOff);

    IsDrCr:=((Nom.NomCode=Syss.NomCtrlCodes[Debtors]) or (Nom.NomCode=Syss.NomCtrlCodes[Creditors])) and (Mode=0);

    FoundOK:=(GLCat=0) and (Mode=0) and (Nom.ReValue) and (Not IsDrCr) ;

    If (Not FoundOk) and (GLCat<>0) and (Not IsDrCr) then
    Begin
      KeyChk:=FullNomKey(GLCat);

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      Case Mode of
        1  :  Begin
                If (StatusOk) and (Nom.Cat<>0) and (Level<3) then
                Begin
                  Level:=Succ(Level);

                  FoundOk:=CheckParentRV(Nom.Cat,Mode,Level);

                end
                else
                  FoundOk:=(StatusOk) and (Nom.Cat=0) and (Level<3);


              end;

        else  FoundOk:=(StatusOk) and (Nom.ReValue);
      end; {Case..}
    end;


    TmpStat:=Presrv_BTPos(NomF,TmpKPath,F[NomF],TmpRecAddr,BOn,BOff);

    Nom:=TmpNom;


    Result:=FoundOk;

  end;
{$ENDIF}




{ ========== Build runtime view ======== }

procedure TNomRec.BuildDesign;


begin


end;


procedure TNomRec.FormDesign;

Var
  HideCC  :  Boolean;
  UseDec  :  Byte;

begin
  NIDF.MaxLength:=NomDesLen;

  {$IFNDEF MC_On}
     NIRF.Visible:=BOff;
     CurrF.Visible:=BOff;
     Label86.Visible:=BOff;

     Label87.Left:=Label84.Left-25;
     Label84.Left:=Label86.Left;
     NICLF.Left:=NIFF.Left-25;
     NIFF.Left:=CurrF.Left;

  {$ELSE}
     Set_DefaultCurr(CurrF.Items,BOn,BOn);
     Set_DefaultCurr(CurrF.ItemsL,BOn,BOn);

     {$IFDEF LTE}
       {CurrF.Visible:=BOff;
       Label86.Visible:=BOff;
       Label87.Left:=Label84.Left-25;
       Label84.Left:=Label86.Left;
       NICLF.Left:=NIFF.Left-25;
       NIFF.Left:=CurrF.Left;}
     {$ENDIF}

  {$ENDIF}

  If (Not Syss.UseGLClass) then
  Begin
    NICLF.Visible:=BOff;
    Label87.Visible:=BOff;
  end
  else
    Set_DefaultNomClass(NICLF.Items,BOff);

  {$IFNDEF JC}
    NIFJCF.Visible:=BOff;

  {$ELSE}

    NIFJCF.Visible:=JBCostOn;

  {$ENDIF}

  Set_DefaultNomT(NITF.Items,BOff);
  Set_DefaultNomT(NITF.ItemsL,BOn);


  NICF.DisplayFormat:='';

  BuildDesign;

end;



Procedure TNomRec.SetCaption;

Begin
  With ExLocal,LNom do
  Begin
    Caption:='General Ledger Account - '+dbFormatName(Form_Int(NomCode,0),Desc)+'. ';
  end;
end;


procedure TNomRec.FormCreate(Sender: TObject);
begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  ClientHeight:=187;
  ClientWidth:=372;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TNomView) then
    With TNomView(Owner) do
      Self.SetFieldProperties(NLOLine);

  FormDesign;

  CanDelete:=BOn;

  SetHelpContextIDs; // NF: 22/06/06 Fix for incorrect Context IDs
end;




procedure TNomRec.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,100);

end;

procedure TNomRec.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TNomRec.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TNomRec.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TNomRec.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TNomRec.Send_UpdateList(Edit   :  Boolean;
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



Function TNomRec.CheckNeedStore  :  Boolean;

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


Procedure TNomRec.SetFieldFocus;

Begin
  If (CanDelete) then
    NICF.SetFocus
  else
    NIDF.SetFocus;

end; {Proc..}




Function TNomRec.ConfirmQuit  :  Boolean;

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
                StoreId(NomF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(NomF,LastRecAddr[NomF]);


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


Procedure TNomRec.HideFieldsxType;
Var
  ShowField  :  Boolean;
Begin
  ShowField:=(List2NType(NITF.ItemIndex) In ProfitBFSet+BankSet);

  {$IFDEF MC_On}
    {$IFDEF LTE}

      NIRF.Visible:=(ShowField or (List2NType(NITF.ItemIndex)=NomHedCode)) and (Not In_PandL(IntStr(NICF.Text)));
    {$ELSE}
      NIRF.Visible:=ShowField;
    {$ENDIF}
    {CurrF.Visible:=ShowField;
    Label86.Visible:=ShowField;}
  {$ENDIF}


  {$IFDEF JC}
    NIFJCF.Visible:=ShowField and JBCostOn;
  {$ENDIF}

  // MH 21/12/2010 v6.6 ABSEXCH-10548: Added check on whether GL Classes are actually turned on!
  NICLF.Visible:=ShowField And Syss.UseGLClass;
  Label87.Visible:=NICLF.Visible;

end;



{ ============== Display Id Record ============ }

Procedure TNomRec.OutId;


Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  KeyS      :  Str255;


Begin
  With ExLocal,LNom do
  Begin

    NICF.Value:=NomCode;
    NICF.FloatModified:=BOff;

    NIDF.Text:=Desc;
    NITF.ItemIndex:=Ntype2List(NomType);
    NIPF.Checked:=NomPage;

    NIFF.Text:=Form_BInt(CarryF,0);



    NIACF.Text:=Trim(AltCode);

    {$IFDEF MC_On}
      CurrF.ItemIndex:=DefCurr;

      CurrFEnter(Nil);

      {$IFDEF LTE}
        RVLevel:=0;

        If (Nom.NomType<>NomHedCode) and (Nom.Cat<>0) then
          NIRF.Checked:=CheckParentRV(Cat,0,RVLevel)
        else
      {$ENDIF}
        NIRF.Checked:=ReValue;


    {$ENDIF}

    cbHideGL1.Checked:=(HideAC=1);

    If (Syss.UseGLClass) then
      NICLF.ItemIndex:=TxLate_NOMClass(NomClass,BOn);

    {$IFDEF JC}
       NIFJCF.Checked:=ForceJC;

    {$ENDIF}

    HideFieldsxType;

  end;

end;


procedure TNomRec.Form2Id;

Begin

  With EXLocal.LNom do
  Begin
    NomCode:=Trunc(NICF.Value);
    Desc:=NIDF.Text;
    NomType:=List2NType(NITF.ItemIndex);
    NomPage:=NIPF.Checked;
    CarryF:=IntStr(NIFF.Text);
    ReValue:=NIRF.Checked;

    AltCode:=LJVar(UpCaseStr(NIACF.Text),NomAltCLen);

    {$IFDEF MC_On}
      DefCurr:=CurrF.ItemIndex;
    {$ENDIF}

    HideAC:=Ord(cbHideGL1.Checked);

    If (Syss.UseGLClass) then
      NomClass:=TxLate_NOMClass(NICLF.ItemIndex,BOff);

    {$IFDEF JC}
       ForceJC:=NIFJCF.Checked;

    {$ENDIF}

    // MH 03/09/07: Set new UNIQUE index
    NomCodeStr := LJVar(IntToStr(NomCode), SizeOf(NomCodeStr) - 1);
  end; {with..}

end; {Proc..}



procedure TNomRec.SetIdStore(EnabFlag,
                             VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  ExLocal.InAddEdit:=Not VOMode;

  OkCP1Btn.Enabled:=Not VOMode and (ICEDFM=0) ;

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

procedure TNomRec.ProcessId(Fnum,
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
  With ExLocal,LNom do
  begin

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      {$IFDEF LTE}
        NomType:=BankNHCode;

      {$ELSE}
        NomType:=NomHedCode;

      {$ENDIF}
      
      Cat:=Level_Code;

      CanDelete:=BOn;

      {$IFDEF MC_On}
        {$IFDEF LTE}
          RVLevel:=0;
          
          If (Cat<>0) then
            ReValue:=CheckParentRV(Cat,0,RVLevel)
        {$ENDIF}
      {$ENDIF}
    end
    else
      CanDelete:=Ok2DelNom(0,LNom);

    LastNom:=LNom;

    OutId;

    SetIdStore(BOn,ExLocal.LViewOnly);

    CanReVal;
    
    SetFieldFocus;
    
  end; {If Abort..}

end; {Proc..}




Function TNomRec.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  4;
  Fnum         =  NomF;
  Keypath      =  NomCodeK;


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

  PossMsg^[1]:='That General Ledger Code already exists.';
  PossMsg^[2]:='That General Ledger Code is not valid.';
  PossMsg^[3]:='That General Ledger Account Type is not valid.';
  PossMsg^[4]:='System Setup Changes are not allowed whilst in ICE Drip Feed mode.';

  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LNom do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              If (Not Edit) then
                Result:=Not (CheckExsists(Strip('R',[#0],FullNomKey(NomCode)),Fnum,Keypath))
              else
                Result:=BOn;
            end;

      2  :  Result:=(NomCode>0);

      3  :  If (LastNom.NomType<>NomType) then
              Result:=NomGood_Type(NomType,CanDelete) and NomGood_Type2(NomType,CAT);

      4  :  Begin
              Result:=(ICEDFM=0); 
            end;


    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}




{ ======= Function to Determine if a nominal code type change is acceptable ===== }

Function TNomRec.NomGood_Type(OTyp  :  Char;
                              Change:  Boolean)  :  Boolean;


Begin

  NomGood_Type:=((Change) or (Not (OTyp In [NomHedCode,CarryFlg])));

end;





procedure TNomRec.StoreId(Fnum,
                          Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpNom
       :  NominalRec;

  KeyS :  Str255;

  NewNType
       :  Char;




Begin
  KeyS:='';    NewNType:=#0;

  Form2Id;


  With ExLocal,LNom do
  Begin
    If (LastEdit) and (LastNom.NomCode<>NomCode) then
    Begin
      COk:=(Not Check4DupliGen(FullNomKey(NomCode),Fnum,Keypath,'General Ledger'));
    end
    else
      COk:=BOn;


    If (COk) then
      COk:=CheckCompleted(LastEdit,BOff);


    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      If (LastEdit) then
      Begin

        If (LastNom.NomType<>NomType) then
        Begin
          NewNType:=NomType;
          NomType:=LastNom.NomType;

          GLTypeChange(LNom,NewNType,TForm(Self.Owner));
        end;

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpNom:=LNom;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LNom:=TmpNom;

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
      end;

      Cursor:=CrDefault;

      InAddEdit:=BOff;

      If (LastEdit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      IdStored:=BOn;

      Send_UpdateList(LastEdit,0);

      SetIdStore(BOff,BOff);

      LastValueObj.UpdateAllLastValues(Self);

      Close;
    end
    else
      SetFieldFocus;

  end; {With..}


end;


procedure TNomRec.SetFieldProperties(Field  :  TSBSOutLineB) ;

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


procedure TNomRec.EditLine(RNom       :  NominalRec;
                           Edit       :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    LNom:=RNom;

    ProcessId(NomF,NomCodeK,LastEdit);
  end;
end;


procedure TNomRec.DeleteNOMLine(Fnum,
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
        Begin

          Send_UpdateList(BOff,200);


        end;
      end {If line is valid for deletion..}
      else
        Report_BError(Fnum,Status);
    end;
  end; {With..}

  Close;
end; {PRoc..}


procedure TNomRec.CanCP1BtnClick(Sender: TObject);
Begin
  If (Sender is TButton) then
    With (Sender as TButton) do
    Begin
      If (ModalResult=mrOk) then
      Begin
        // MH 21/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
        //                                   fields which processes the text and updates the value
        If (ActiveControl <> OkCP1Btn) Then
          // Move focus to OK button to force any OnExit validation to occur
          OkCP1Btn.SetFocus;

        // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
        If (ActiveControl = OkCP1Btn) Then
          StoreId(NomF,SKeypath);
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

Function TNomRec.CanReVal  :  Boolean;

Begin
  Form2Id;

  With Syss,ExLocal,LNom do
  {$IFDEF MC_On}

    Result:=
    {$IFNDEF LTE}
      ((NomType In YTDSET) and ((NomCode<>NomCtrlCodes[Debtors]) and (NomCode<>NomCtrlCodes[Creditors])))
    {$ELSE}
      {$B-}
      ((NomType=NomHedCode) and (NomCode<>NomCtrlCodes[PLStart]) and (Not In_PandL(NomCode)) and ((NomCode<>NomCtrlCodes[Debtors]) and (NomCode<>NomCtrlCodes[Creditors])))
      {$B+}
    {$ENDIF}  ;

    NIRF.Enabled:=Result;
  {$ELSE}
    Result:=BOff;

  {$ENDIF}

end;

procedure TNomRec.NICFEnter(Sender: TObject);
begin
  With NICF do
    ReadOnly:=(ReadOnly or (Not CanDelete));
end;


procedure TNomRec.NICFExit(Sender: TObject);
Var
  COk   :  Boolean;
  CCode :  Str20;


begin

  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit),ExLocal do
  Begin
    
    If ((Not LastEdit) or (LastNom.NomCode<>Value)) and (InAddEdit) and (Not ReadOnly) and (ActiveControl<>CanCP1Btn) then
    Begin
      COk:=(Value<=MaxInt);

      If (Not COk) then
        ShowMessage('A General Ledger Code cannot not exceed the value '+Form_Int(MaxInt,0));
      {else
        If (Value>9E6) then
          ShowMessage('A General Ledger Code larger than 999999 will not be displayed correctly.');}


      If (COk) then
      Begin
        CCode:=FullNomKey(Trunc(Value));


        COk:=(Not Check4DupliGen(CCode,NomF,NomCodeK,'General Ledger Code ('+Form_Int(Trunc(Value),0)+')'));
      end;
      
      If (Not COk) then
      Begin

        SetFocus;

      end
      else
        If (Not LastEdit) and (NIACF.Text='') then
          NIACF.Text:=Form_Real(Value,0,0);

    end;
  end;
end;


procedure TNomRec.NITFEnter(Sender: TObject);
begin
  With NITF do
  Begin
    If (Not ChkAllowed_In(198)) then
      ReadOnly:=(ReadOnly or (Not CanDelete));

    NITLastValue:=ItemIndex;
  end;
end;

procedure TNomRec.CurrFEnter(Sender: TObject);
begin
  If (ExLocal.InAddEdit) then
  With CurrF do
  Begin
    Enabled:=((List2NType(NITF.ItemIndex) In ProfitBFSet+BankSet));
    {TabStop:=Enabled;}
  end;
end;


  { ==== Procedure to check if nom is being added into tha P&L section ==== }

  Function TNomRec.In_PandL(GLCat  :  LongInt)  :  Boolean;

  Const
    Fnum     =  NomF;
    Keypath  =  NomCodeK;

  Var
    KeyS,
    KeyChk   :  Str255;


    FoundOk  :  Boolean;

    TmpKPath,
    TmpStat
             : Integer;

    TmpRecAddr,
    PALStart
             :  LongInt;

    TmpNom   :  NominalRec;

  Begin
    FoundOk:=BOff;

    TmpNom:=Nom;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(NomF,TmpKPath,F[NomF],TmpRecAddr,BOff,BOff);

    PALStart:=Syss.NomCtrlCodes[PLStart];

    FoundOK:=(GLCat=PALStart);

    If (Not FoundOk) then
    Begin
      KeyChk:=FullNomKey(GLCat);

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (Not FoundOk) do
      With Nom do
      Begin
        FoundOk:=(Cat=PALStart);


        If (Not FoundOk) then
        Begin

          KeyChk:=FullNomKey(Cat);

          KeyS:=KeyChk;

          Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        end;
      end; {While..}

    end;


    TmpStat:=Presrv_BTPos(NomF,TmpKPath,F[NomF],TmpRecAddr,BOn,BOff);

    Nom:=TmpNom;


    In_PandL:=FoundOk;

  end;



Function TNomRec.NomGood_Type2(OTyp  :  Char;
                               GLCat :  LongInt)  :  Boolean;


Begin

  {$B-}

  Result:=((OTyp In [NomHedCode,CarryFlg]))
                 or (SBSIN)

                 or ((OTyp<>PLNHCode) and (Not In_PandL(GLCat)))
                 or ((OTyp=PLNHCode) and (In_PandL(GLCat)));

  {$IFDEF LTE}
    RVLevel:=0;

    If (Result) and (OTyp In [NomHedCode]) then
      Result:=CheckParentRV(GLCat,1,RVLevel);
  {$ENDIF}

  {$B+}

end;


procedure TNomRec.NITFExit(Sender: TObject);

Var
  FoundOk  :  Boolean;

begin
  With NITF do
  If (ActiveControl<>CanCP1Btn) and (Not ReadOnly) and (ItemIndex<>NITLastValue) then
  Begin
    FoundOk:=((NomGood_Type(List2NType(ItemIndex),CanDelete)) and (NomGood_Type(List2NType(NITLAstValue),CanDelete)));

    If (FoundOk) then
    Begin
      FoundOk:=NomGood_Type2(List2NType(ItemIndex),ExLocal.LNom.CAT);
    end;

    If (Not FoundOk) then
    Begin
      ShowMessage('That account type is not valid.');
      SetFocus;
    end
      else
      Begin
        {$IFDEF MC_On}

          RVLevel:=0;

          CurrFEnter(Sender);

          If (Not ExLocal.LastEdit) {$IFNDEF LTE} and (CanReVal) {$ENDIF} then
          Begin
            NIRF.Checked:={$IFNDEF LTE}  BOn {$ELSE} CheckParentRV(ExLocal.LNom.Cat,0,RVLevel) {$ENDIF};

            {$IFDEF LTE}
              CanReVal;
            {$ENDIF}
          end;
        {$ENDIF}

        HideFieldsxType;

      end;

    NITLastValue := ItemIndex;
  end;
end;

procedure TNomRec.NIFFEnter(Sender: TObject);
begin
  With NIFF do
  Begin
    ReadOnly:=(ReadOnly or (List2NType(NITF.ItemIndex)<>CarryFlg));
  end;
end;

procedure TNomRec.NIFFExit(Sender: TObject);
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

procedure TNomRec.SetHelpContextIDs;
// NF: 22/06/06
begin
  // Fix incorrect IDs
  NICLF.HelpContext := 1896;
end;



{Proc..}


end.

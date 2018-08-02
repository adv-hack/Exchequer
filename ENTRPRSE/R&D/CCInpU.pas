unit CCInpU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel,

  GlobVar,VarConst,ExWrap1U,BTSupU1,CmpCtrlU,SBSOutL,BarGU, bkgroup,
  BorBtns;


type
  TCCDepRec = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    SCodeF: Text8Pt;
    DescF: Text8Pt;
    SBSBackGroup1: TSBSBackGroup;
    Label81: Label8;
    Label83: Label8;
    cbHideGL1: TBorCheck;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure SCodeFExit(Sender: TObject);
  private
    IdStored,
    StopPageChange,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;

    NewCode,
    OldCode      :  Str3;

    Progress     :  TBarP;


    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildDesign;

    procedure FormDesign;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    Procedure OutId;

    procedure Form2Id;

    Procedure Change_CCDepComboHist(OCode,NCode  :  Str10;
                                    IsCC         :  Boolean);

    Procedure Change_CCDepHist(OCode,NCode  :  Str10;
                               IsCC         :  Boolean);

    Procedure Change_CCCode(OCode,NCode  :  Str3;
                            IsCC         :  Boolean);

    Procedure StartChange(OCode,NCode  :  Str3;
                          IsCC         :  Boolean);

    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

  public
    { Public declarations }

    ExLocal    :  TdExLocal;
    CCDepMode  :  Boolean;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSPanel) ;


    procedure EditLine(Edit       :  Boolean);

    procedure DeleteBOMLine(Fnum,
                            KeyPath  :  Integer);

  end;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BtKeys1U,
  VarRec2U,
  BTSupU2,
  SBSComp2,
  CurrncyU,
  ComnUnit,
  ComnU2,


  ColCtrlU,

  SysU2,

  CCListU,
  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}
  PayF2U,

  {PayLineU,}

  {$IFDEF NP}
    NoteSupU,
  {$ENDIF}

  {$IFDEF STK}
    {$IFDEF PF_On}
      CuStkA2U,
    {$ENDIF}
  {$ENDIF}

  GenericWarnF,  // delete warning
  ExThrd2U,
  DocSupU1,
  Saltxl1U;
  



{$R *.DFM}




Type

  ResetCCDep   =  ^Id5ExtSObj;

  Id5ExtSObj   =  Object(ExtSObj)

                    Constructor  Init;

                    Destructor   Done;


                    Procedure SetIdObj1(Var  SetSearchRec  :  SearchPtr;
                                             Fnum          :  Integer;
					     CCDep	   :  Str3;
					     IsCC	   :  Boolean);

                    Function  GetSearchRec2(Fnum,
                                            Keypath   :  Integer;
                                        Var KeyS      :  Str255;
					    CCDep     :  Str3;
					    IsCC      :  Boolean)  :  Integer;

               end; {Object..}




  { --------------------------------------- }

  { Id5ExtSObj Methods }

  { --------------------------------------- }


  Constructor Id5ExtSObj.Init;

  Begin

    ExtSobj.Init;

  end;



  Destructor  Id5ExtSObj.Done;
  Begin

    ExtSObj.Done;

  end;


  Procedure Id5ExtSObj.SetIdObj1(Var  SetSearchRec  :  SearchPtr;
				      Fnum          :  Integer;
				      CCDep         :  Str3;
				      IsCC          :  Boolean);


  Begin
    With SetSearchRec^.Filter.Filter5 do
    Begin
      ExtSObj.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SetSearchRec^.Filter.Filter5));


      With ExtendHead do
      Begin
        NumTerms:=1;
      end;

      With Term1 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Id.CCDep[BOff]);

        If (IsCC) then
          FieldOffset:=GECC
        else
          FieldOffSet:=GEDep;

        CompareCode:=1; {* Compare= *}
        LogicExpres:=0;

        Compare1:=CCDep;

      end;

    end; {With..}

  end;


  Function  Id5ExtSObj.GetSearchRec2(Fnum,
                                     Keypath   :  Integer;
                                 Var KeyS      :  Str255;
    				     CCDep     :  Str3;
				     IsCC      :  Boolean)  :  Integer;



  Begin
    SetIdObj1(SearchRec,Fnum,CCDep,IsCC);

    
    GetSearchRec2:=ExtSObj.GetSearchRec(B_GetNextEx,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}

  { --------------------------------------- }



{ ========== Build runtime view ======== }

procedure TCCDepRec.BuildDesign;


begin


end;


procedure TCCDepRec.FormDesign;

Var
  HideCC  :  Boolean;
  UseDec  :  Byte;

begin

  DescF.MaxLength:=CCDescLen;
  SCodeF.MaxLength:=CCKeyLen;

  BuildDesign;

end;




procedure TCCDepRec.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  ClientHeight:=114;
  ClientWidth:=303;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TCCDepList) then
    With TCCDepList(Owner) do
      Self.SetFieldProperties(CCPanel);

  cbHideGL1.Visible:=BOn;

  DescF.ReadOnly:=(ICEDFM<>0);
  DescF.TabStop:=Not DescF.ReadOnly;

  If (DescF.ReadOnly) then
  With DescF do
  Begin
    Color:=clBtnFace;
    Font.Color:=clBlack;

  end;

  FormDesign;

end;




procedure TCCDepRec.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,102);

end;

procedure TCCDepRec.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TCCDepRec.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TCCDepRec.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TCCDepRec.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Procedure TCCDepRec.WMCustGetRec(Var Message  :  TMessage);



Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      38  :  Change_CCCode(OldCode,NewCode,CCDepMode);

    end; {Case..}

  end;
  Inherited;
end;



{ == Procedure to Send Message to Get Record == }

Procedure TCCDepRec.Send_UpdateList(Edit   :  Boolean;
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



Function TCCDepRec.CheckNeedStore  :  Boolean;

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


Procedure TCCDepRec.SetFieldFocus;

Begin
  SCodeF.SetFocus;

end; {Proc..}




Function TCCDepRec.ConfirmQuit  :  Boolean;

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
                StoreId(PwrdF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(PwrdF,LastRecAddr[PWrdF]);

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

Procedure TCCDepRec.OutId;

Const
  Fnum     =  StockF;
  Keypath  =  StkFolioK;

Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  KeyS      :  Str255;


Begin
  With ExLocal,LPassWord.CostCtrRec do
  Begin

    SCodeF.Text:=Strip('R',[#32],PCostC);

    DescF.Text:=CCDesc;

    cbHideGL1.Checked:=(HideAC=1);

  end;

end;


procedure TCCDepRec.Form2Id;

Begin

  With EXLocal,LPassWord.CostCtrRec do
  Begin
    // MH 03/11/2010 v6.5 ABSEXCH-3002: Convert to uppercase
    PCostC:=LJVar(Uppercase(SCodeF.Text),CCKeyLen);
    CCDesc:=DescF.Text;

    HideAC:=Ord(cbHideGL1.Checked);
  end; {with..}

end; {Proc..}





(*  Add is used to add Notes *)

procedure TCCDepRec.ProcessId(Fnum,
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

    If (ICEDFM<>0) then
      SCodeF.ReadOnly:=BOn;
  end;


  If (Addch<>Esc) then
  With ExLocal,LPassWord,CostCtrRec do
  begin

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      RecPfix:=CostCCode;
      Subtype:=CSubCode[CCDepMode];
      NLineCount:=1;

    end;

    LastPassWord:=LPassWord;

    OutId;

  end {If Abort..}
  else
    Close;

end; {Proc..}




Function TCCDepRec.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  1;
  Fnum         =  StockF;
  Keypath      =  StkFolioK;


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
  ShowMsg := False;

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='That Code is not valid.';


  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LPassWord,CostCtrRec do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin

              Result:=Not EmptyKeyS(PCostC,CCKeyLen,BOff);

              If Result Then
              Begin
                // MH 03/11/2010 v6.5 ABSEXCH-3002: Extended to validate code as a valid cc/dept - novel or what!!!
                If (Not LastEdit) Or ((Not LastEdit) And (LastPassword.CostCtrRec.PCostC <> PCostC)) Then
                Begin
                  // Adding - must not already exist
                  // Editing - Must not exist if user has changed the code from original
                  FoundCode := PCostC;
                  Result := Not GetCCDep(Self, PCostC, FoundCode, (SubType=CSubCode[BOn]), -1)
                End; // If (Not LastEdit) Or ((Not LastEdit) And (LastMLoc^.MLocLoc.loCode <> loCode))
              End; // If Result

            end;

    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}


Procedure TCCDepRec.Change_CCDepComboHist(OCode,NCode  :  Str10;
                                          IsCC         :  Boolean);

  Const
    Fnum     =  NHistF;
    Keypath  =  NHK;


  Var
    KeyS,KeyChk  :  Str255;

    Locked,
    LOk,
    Loop,
    XCDepMode     :  Boolean;

    LAddr        :  LongInt;

    NType        :  Char;
    B_Func       :  Integer;
    BCCDep       :  CCDepType;


  Begin
    With Nom do
    Begin
      XCDepMode:=IsCC;

      Repeat

        Loop:=BOff;

        Repeat
          If (Loop) then
            NType:=NomType
          else
            NType:=Calc_AltStkHCode(NomType);

          If (XCDepMode=IsCC) then
            KeyChk:=NType+CalcCCKeyHistOn(NomCode,PostCCKey(IsCC,OCode))
          else
            KeyChk:=NType+CSubCode[XCDepMode]+FullNomKey(NomCode);

          KeyS:=KeyChk;

          Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

          While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
          With NHist do
          Begin
            Application.ProcessMessages;

            B_Func:=B_GetNext;

            If (XCDepMode=IsCC) or (Copy(Code,10,ccKeyLen)=OCode) then
            Begin
              LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

              If (LOk) and (Locked) then
              Begin
                Blank(BCCDep,Sizeof(BCCDep));

                BCCDep[XCDepMode]:=Copy(Code,6,ccKeyLen);
                BCCDep[Not XCDepMode]:=Copy(Code,10,ccKeyLen);

                BCCDep[IsCC]:=NCode;

                Code:=FullNHCode(CalcCCKeyHistOn(NomCode,PostCCKey(XCDepMode,CalcCCDepKey(XCDepMode,BCCDep))));

                Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

                Report_BError(Fnum,Status);

                Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

                B_Func:=B_GetGEq;
              end; {If Locked..}
            end;
            Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

          end; {While..}

          Loop:=Not Loop;

        Until (Not Loop);

        XCDepMode:=Not XCDepMode;

      Until (XCDepMode=IsCC);
    end; {With.}
  end; {Proc..}


  Procedure TCCDepRec.Change_CCDepHist(OCode,NCode  :  Str10;
                                     IsCC         :  Boolean);

  Const
    Fnum     =  NHistF;
    Keypath  =  NHK;


  Var
    KeyS,KeyChk  :  Str255;

    Locked,
    LOk,
    Loop         :  Boolean;

    LAddr        :  LongInt;

    NType        :  Char;
    B_Func       :  Integer;


  Begin
    With Nom do
    Begin
      Loop:=BOff;

      Repeat
        If (Loop) then
          NType:=NomType
        else
          NType:=Calc_AltStkHCode(NomType);

        KeyChk:=NType+FullNHCode(CalcCCKeyHistOn(NomCode,PostCCKey(IsCC,OCode)));
        KeyS:=KeyChk;

        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

        While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
        With NHist do
        Begin
          Application.ProcessMessages;

          B_Func:=B_GetNext;

          LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

          If (LOk) and (Locked) then
          Begin
            Code:=FullNHCode(CalcCCKeyHistOn(NomCode,PostCCKey(IsCC,NCode)));

            Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

            Report_BError(Fnum,Status);

            Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

            B_Func:=B_GetGEq;
          end; {If Locked..}

          Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

        end; {While..}

        Loop:=Not Loop;

      Until (Not Loop);
    end; {With.}

    {* Find any combo;s and change them to }

    If (Syss.PostCCDCombo) then
      Change_CCDepComboHist(OCode,NCode,IsCC);


  end; {Proc..}


{ ============ Procedure to Change the Code =========== }


Procedure TCCDepRec.Change_CCCode(OCode,NCode  :  Str3;
                                  IsCC         :  Boolean);

Const
  Fnum     =  IDetailF;
  Keypath  =  IdFolioK;

  Fnum2    =  CustF;
  Keypath2 =  CustCodeK;

  Fnum3    =  StockF;
  Keypath3 =  StkCodeK;

  Fnum4    =  NomF;
  Keypath4 =  NomCodeK;

  Fnum5    =  MLocF;
  Keypath5 =  MLK;

  Fnum6    =  JobF;             // SSK 21/04/2017 2017-R2 ABSEXCH-17250: access Job record
  Keypath6 =  JobCodeK;

  Fnum7    =  JMiscF;           // SSK 09/05/2017 2017-R2 ABSEXCH-17250: access Employee record
  Keypath7 =  JMK;

Var
  KeyChk,
  KeyS       :  Str255;

  ChangeCCDep:  ResetCCDep;

  PurgeCount,
  LAddr      :  LongInt;

  LOk,
  GLocked    :  Boolean;

Begin
  Progress.CanCP1Btn.Visible:=BOff;
  Progress.Update;

  New(ChangeCCDep,Init);

  Blank(KeyS,Sizeof(KeyS));

  Status:=Find_Rec(B_GetFirst,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  Progress.Gauge1.MaxValue := (Used_Recs(F[Fnum], Fnum) +
                               Used_Recs(F[Fnum2], Fnum2) +
                               Used_Recs(F[Fnum3], Fnum3) +
                               Used_Recs(F[Fnum6], Fnum6) +    // SSK 21/04/2017 2017-R2 ABSEXCH-17250: Used_Recs called to adjust the progress bar for Job Record
                               Used_Recs(F[Fnum7], Fnum7));    // SSK 09/05/2017 2017-R2 ABSEXCH-17250: Used_Recs called to adjust the progress bar for Employee record

  If (Syss.PostCCNom) and (Syss.UseCCDep) then
    Progress.Gauge1.MaxValue:=Progress.Gauge1.MaxValue+Used_Recs(F[Fnum4],Fnum4);

  {$IFDEF SOP}
    If (Syss.UseMLoc) then
      Progress.Gauge1.MaxValue:=Progress.Gauge1.MaxValue+Used_Recs(F[Fnum5],Fnum5);

  {$ENDIF}


  GLocked:=BOff;
  PurgeCount:=0;

  While (StatusOk) do
  With Id do
  Begin

    Application.ProcessMessages;

    If (CCDep[IsCC]=OCode) then
    Begin

      LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,GLocked,LAddr);

      If (LOk) and (GLocked) then
      Begin

        CCDep[IsCC]:=NCode;


        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

        Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

      end;
    end;

    Inc(PurgeCount);

    Progress.Gauge1.Progress:=PurgeCount;


    Status:=ChangeCCDep^.GetSearchRec2(Fnum,Keypath,KeyS,OCode,IsCC);

  end; {While..}


  PurgeCount:=Used_Recs(F[Fnum],Fnum); {* Bring count in line !! *}


  {* Change any customers / suppliers with new codes *}

  Blank(KeyS,Sizeof(KeyS));

  Status:=Find_Rec(B_GetFirst,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyS);

  While (StatusOk) do
  With Cust do
  Begin
    Application.ProcessMessages;

    If ((CustDep=OCode) and (Not IsCC)) or ((CustCC=OCode) and (IsCC)) then
    Begin

      LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,GLocked,LAddr);

      If (LOk) and (GLocked) then
      Begin

        If (IsCC) then
          CustCC:=NCode
        else
          CustDep:=NCode;


        Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

        Status:=UnLockMultiSing(F[Fnum2],Fnum2,LAddr);

      end;
    end;


    {$IFDEF STK}
      {$IFDEF PF_On}
        If (AnalCuStk) then {* Rename Stk anal histories *}
          cuStk_RenCCDep(CustCode,OCode,NCode,IsCC,0);
      {$ENDIF}
    {$ENDIF}

    Inc(PurgeCount);

    Progress.Gauge1.Progress:=PurgeCount;

    Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyS);


  end; {While..}


  {* Change any Notes *}

  {$IFDEF NP}

    ChangeNoteFolio(NoteDpCode[IsCC],OCode,NCode);

  {$ENDIF}

  {* Change any Stock Records to newcodes *}

  Blank(KeyS,Sizeof(KeyS));

  Status:=Find_Rec(B_GetFirst,F[Fnum3],Fnum3,RecPtr[Fnum3]^,Keypath3,KeyS);

  While (StatusOk) do
  With Stock do
  Begin
    Application.ProcessMessages;

    If (CCDep[IsCC]=OCode) or (ROCCDep[IsCC]=OCode) then
    Begin

      LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath3,Fnum3,BOn,GLocked,LAddr);

      If (LOk) and (GLocked) then
      Begin

        If (CCDep[IsCC]=OCode) then
          CCDep[IsCC]:=NCode;

        If (ROCCDep[IsCC]=OCode) then
          ROCCDep[IsCC]:=NCode;

        Status:=Put_Rec(F[Fnum3],Fnum3,RecPtr[Fnum3]^,KeyPath3);

        Status:=UnLockMultiSing(F[Fnum3],Fnum3,LAddr);

      end;
    end;

    Inc(PurgeCount);

    Progress.Gauge1.Progress:=PurgeCount;

    Status:=Find_Rec(B_GetNext,F[Fnum3],Fnum3,RecPtr[Fnum3]^,Keypath3,KeyS);

  end; {While..}

  {* Change any Nominal CC posting with new codes *}

  If (Syss.PostCCNom) and (Syss.UseCCDep) then
  Begin
    Blank(KeyS,Sizeof(KeyS));

    Status:=Find_Rec(B_GetFirst,F[Fnum4],Fnum4,RecPtr[Fnum4]^,Keypath4,KeyS);

    While (StatusOk) do
    With Nom do
    Begin
      Application.ProcessMessages;

      Change_CCDepHist(OCode,NCode,IsCC);

      Inc(PurgeCount);

      Progress.Gauge1.Progress:=PurgeCount;

      Status:=Find_Rec(B_GetNext,F[Fnum4],Fnum4,RecPtr[Fnum4]^,Keypath4,KeyS);


    end; {While..}
  end;


  {$IFDEF SOP}
    {* Change any Loc Records to newcodes *}


    Blank(KeyS,Sizeof(KeyS));

    KeyChk:=CostCCode;
    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum5],Fnum5,RecPtr[Fnum5]^,Keypath5,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff))  do
    With MLocCtrl^ do
    Begin
      If (SubType=CSubCode[BOff]) then
      With MStkLoc do
      Begin
        If (lsCCDep[IsCC]=OCode) or (lsROCCDep[IsCC]=OCode) then
        Begin
          LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath5,Fnum5,BOn,GLocked,LAddr);

          If (LOk) and (GLocked) then
          Begin

            If (lsCCDep[IsCC]=OCode) then
              lsCCDep[IsCC]:=NCode;

            If (lsROCCDep[IsCC]=OCode) then
              lsROCCDep[IsCC]:=NCode;


            Status:=Put_Rec(F[Fnum5],Fnum5,RecPtr[Fnum5]^,KeyPath5);

            Status:=UnLockMultiSing(F[Fnum5],Fnum5,LAddr);

          end;
        end;

      end
      else
        If (SubType=CSubCode[BOn]) then
        With MLocLoc do
        Begin

          If (loCCDep[IsCC]=OCode) then
          Begin
            LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath5,Fnum5,BOn,GLocked,LAddr);

            If (LOk) and (GLocked) then
            Begin

              loCCDep[IsCC]:=NCode;


              Status:=Put_Rec(F[Fnum5],Fnum5,RecPtr[Fnum5]^,KeyPath5);

              Status:=UnLockMultiSing(F[Fnum5],Fnum5,LAddr);

            end;
          end;
        end;


      Inc(PurgeCount);

      Progress.Gauge1.Progress:=PurgeCount;

      Status:=Find_Rec(B_GetNext,F[Fnum5],Fnum5,RecPtr[Fnum5]^,Keypath5,KeyS);

    end; {While..}

  {$ENDIF}

  {* Change any JobRecord with new codes *}           // SSK 21/04/2017 2017-R2 ABSEXCH-17250: change CC or Dept to new one for matching Job Records

  Blank(KeyS, Sizeof(KeyS));

  Status := Find_Rec(B_GetFirst, F[Fnum6], Fnum6, RecPtr[Fnum6]^, Keypath6, KeyS);

  while (StatusOk) do
  begin
    Application.ProcessMessages;

    with JobRec^ do
    begin
      if CCDep[IsCC] = OCode then
      begin
        LOk := GetMultiRecAddr(B_GetDirect, B_MultLock, KeyS, Keypath6, Fnum6, BOn, GLocked, LAddr);
        if LOk and GLocked then
        begin
          if CCDep[IsCC] = OCode then
            CCDep[IsCC] := NCode;

          Status := Put_Rec(F[Fnum6], Fnum6, RecPtr[Fnum6]^, KeyPath6);
          Status := UnLockMultiSing(F[Fnum6], Fnum6, LAddr);
        end;
      end;

      Inc(PurgeCount);

      Progress.Gauge1.Progress := PurgeCount;

      Status := Find_Rec(B_GetNext, F[Fnum6], Fnum6, RecPtr[Fnum6]^, Keypath6, KeyS);
    end; {With}
  end; {While..}

  {* Change any EmplRec with new codes *}           // SSK 09/05/2017 2017-R2 ABSEXCH-17250: change CC or Dept to new one for matching Job Records

  Blank(KeyS, Sizeof(KeyS));

  KeyChk := PartCCKey(JARCode,JASubAry[3]);
  KeyS := KeyChk;

  Status := Find_Rec(B_GetGEq, F[Fnum7], Fnum7, RecPtr[Fnum7]^, Keypath7, KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
  begin
    Application.ProcessMessages;

    with JobMisc^.EmplRec do
    begin
      begin
        if CCDep[IsCC] = OCode then
        begin
          LOk := GetMultiRecAddr(B_GetDirect, B_MultLock, KeyS, Keypath7, Fnum7, BOn, GLocked, LAddr);
          if LOk and GLocked then
          begin
            if CCDep[IsCC] = OCode then
              CCDep[IsCC] := NCode;

            Status := Put_Rec(F[Fnum7], Fnum7, RecPtr[Fnum7]^, KeyPath7);
            Status := UnLockMultiSing(F[Fnum7], Fnum7, LAddr);
          end;
        end;
      end;
      Inc(PurgeCount);

      Progress.Gauge1.Progress := PurgeCount;

      Status := Find_Rec(B_GetNext, F[Fnum7], Fnum7, RecPtr[Fnum7]^, Keypath7, KeyS);
    end; {With}
  end; {While..}

  Dispose(ChangeCCDep, Done);
  Status := 0;
  Progress.ShutDown;

end; {Proc..}


Procedure TCCDepRec.StartChange(OCode,NCode  :  Str3;
                                IsCC         :  Boolean);

begin
  Progress:=TBarP.Create(Self);

  try

    Progress.Caption:='Changing from '+Strip('B',[#32],OCode)+' to '+Strip('B',[#32],NCode);

    OldCode:=OCode;
    NewCode:=NCode;

    Set_BackThreadMVisible(BOn);


    Progress.ShowModal;

  finally

    Progress.Free;

    Set_BackThreadMVisible(BOff);

  end;
end;


procedure TCCDepRec.StoreId(Fnum,
                          Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpPWrd
       :  PassWordRec;

  KeyS :  Str255;

  mbRet:  Word;




Begin
  KeyS:='';

  Form2Id;


  With ExLocal,LPassWord,CostCtrRec do
  Begin
    If (LastEdit) and (LastPassword.CostCtrRec.PCostC<>PCostC) then
    Begin
      COk:=(Not Check4DupliGen(FullCCKey(RecPfix,SubType,CostCtrRec.PCostC),Fnum,Keypath,'Code'));

      If (COk) then
      Begin
        mbRet:=MessageDlg('All existing data will be updated with the new code.'+#13+#13+' Continue?',mtConfirmation,[mbYes,mbNo],0);
        COk:=mbRet=(mrYes);

        If (Not COk) then
          SCodeF.Text:=LastPassWord.CostCtrRec.PCostC;
      end;
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

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpPWrd:=LPassWord;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LPassWord:=TmpPWrd;

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

      If (StatusOk) and (LastEdit) then
      Begin
        If (LastPassword.CostCtrRec.PCostC<>PCostC) then
          StartChange(LastPassWord.CostCtrRec.PCostC,PCostC,CCDepMode);
      end;

      Close;
    end
    else
      SetFieldFocus;

  end; {With..}


end;


procedure TCCDepRec.SetFieldProperties(Field  :  TSBSPanel) ;

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


procedure TCCDepRec.EditLine(Edit       :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    ProcessId(PWrdF,PWK,LastEdit);
  end;
end;


procedure TCCDepRec.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
      StoreId(PWrdF,SKeypath);
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


procedure TCCDepRec.DeleteBOMLine(Fnum,
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

   // PS - 01-12-2015 - ABSEXCH-3046 - CC/Dept record can be deleted where transactions exist and have posted balances.
   //                   FIX : Deleted confirm message display and shown warning messange and checked for system passpord
    if ( AuthoriseCCListChange(SCodeF.Text , DescF.Text)) then
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

          {$IFDEF NP}

            Delete_Notes(NoteDpCode[CCDepMode],FullNCode(LPassWord.CostCtrRec.PCostC));
          {$ENDIF}

          Send_UpdateList(BOff,17);


        end;
      end; {If line is valid for deletion..}
    end
    else
      Report_BError(Fnum,Status);
  end; {With..}

  Close;
end; {PRoc..}

procedure TCCDepRec.SCodeFExit(Sender: TObject);
Var
  COk   :  Boolean;
  CCode :  Str20;

begin

  If (Sender is TMaskEdit) And (ActiveControl <> CanCP1Btn) then
    With (Sender as TMaskEdit),ExLocal,LPassWord do
    Begin
      Text:=UpcaseStr(Text);

      CCode:=LJVar(Text,CCKeyLen);

      If ((Not LastEdit) or (LastPassWord.CostCtrRec.PCostC<>CCode)) and (InAddEdit) then
      Begin
        COk:=(Not Check4DupliGen(FullCCKey(RecPFix,SubType,CCode),PWrdF,PWK,'Code ('+Strip('B',[#32],CCode)+')'));

        If (Not COk) then
        Begin

          SetFocus;
        end;
      end;
    end;
end;

end.

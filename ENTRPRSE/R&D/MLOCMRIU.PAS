unit MLocMRIU;

{$I DEFOVR.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, bkgroup, BorBtns, TEditVal, SBSPanel,Mask,
  GlobVar,VarConst,ExWrap1U,BTSupU1,CmpCtrlU,BarGU;

type
  TMLocMRec = class(TForm)
    SCodeF: Text8Pt;
    Ad1F: Text8Pt;
    Ad2F: Text8Pt;
    Ad3F: Text8Pt;
    Ad4F: Text8Pt;
    Ad5F: Text8Pt;
    ConF: Text8Pt;
    TelF: Text8Pt;
    FaxF: Text8Pt;
    ModF: Text8Pt;
    EmailF: Text8Pt;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    Label84: Label8;
    Label85: Label8;
    Label86: Label8;
    Label87: Label8;
    OPF: TBorCheck;
    OCF: TBorCheck;
    OSF: TBorCheck;
    DefCC: Text8Pt;
    DefDep: Text8Pt;
    DescF: Text8Pt;
    Label88: Label8;
    Label89: Label8;
    SBSBackGroup1: TSBSBackGroup;
    OGF: TBorCheck;
    SalGL: Text8Pt;
    COSGL: Text8Pt;
    WOGL: Text8Pt;
    SVGL: Text8Pt;
    WIPGL: Text8Pt;
    Label810: Label8;
    Label811: Label8;
    Label813: Label8;
    Label812: Label8;
    Label814: Label8;
    SBSBackGroup2: TSBSBackGroup;
    OKCP1Btn: TButton;
    CanCP1Btn: TButton;
    OCPF: TBorCheck;
    ORPF: TBorCheck;
    Label815: Label8;
    WOPGL: Text8Pt;
    Label816: Label8;
    PRetGL: Text8Pt;
    RetGL: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure OCFClick(Sender: TObject);
    procedure DefCCExit(Sender: TObject);
    procedure SalGLExit(Sender: TObject);
    procedure SCodeFExit(Sender: TObject);
    procedure CanCP1BtnClick(Sender: TObject);
  private
    IdStored,
    StopPageChange,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;

    NewCode,
    OldCode      :  Str10;

    Progress     :  TBarP;

    TAddr        :  Array[1..5] of Text8Pt;
    GLList       :  Array[1..8] of Text8Pt;

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


    Procedure Change_StkLocHist(OCode,NCode  :  Str10);

    Procedure Change_CCCode(OCode,NCode  :  Str10);

    Procedure SetROFields;

    Procedure StartChange(OCode,NCode  :  Str10);

    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

    Procedure Update_StkLocNom(OCode :  Str10);

    Procedure Update_StkLocCCDep(OCode :  Str10);

  public
    { Public declarations }

    ExLocal    :  TdExLocal;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSPanel) ;


    procedure EditLine(Edit       :  Boolean);

    procedure DeleteBOMLine(Fnum,
                            KeyPath  :  Integer);

  end;

Procedure Change_StkLocFIFO(OCode,NCode  :  Str10;
                            UnSoldOnly   :  Boolean);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BtKeys1U,
  VARRec2U,
  BTSupU2,
  SBSComp2,
  CurrncyU,
  ComnUnit,
  ComnU2,
  SysU2,

  ColCtrlU,

  {SysU2,}
  {$IFDEF SOP}
    MLoc0U,
  {$ENDIF}
    
  InvListU,

  {PayF2U,

  {PayLineU,}

  {$IFDEF NP}
    NoteSupU,
  {$ENDIF}

  CuStkA2U,

  ExThrd2U,
  DocSupU1;

  {Saltxl1U;}




{$R *.DFM}




Type

  ResetCCDep   =  ^Id5ExtSObj;

  Id5ExtSObj   =  Object(ExtSObj)

                    Constructor  Init;

                    Destructor   Done;


                    Procedure SetIdObj1(Var  SetSearchRec  :  SearchPtr;
                                             Fnum          :  Integer;
					     CCDep	   :  Str3);

                    Function  GetSearchRec2(Fnum,
                                            Keypath   :  Integer;
                                        Var KeyS      :  Str255;
					    CCDep     :  Str3)  :  Integer;

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
				      CCDep         :  Str3);


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

        FieldLen:=Sizeof(Id.MLocStk);

        FieldOffSet:=GEIDML;

        CompareCode:=1; {* Compare= *}
        LogicExpres:=0;

        Compare1:=CCDep;

      end;

    end; {With..}

  end;


  Function  Id5ExtSObj.GetSearchRec2(Fnum,
                                            Keypath   :  Integer;
                                        Var KeyS      :  Str255;
					    CCDep     :  Str3)  :  Integer;



  Begin
    SetIdObj1(SearchRec,Fnum,CCDep);

    GetSearchRec2:=ExtSObj.GetSearchRec(B_GetNextEx,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}

  { --------------------------------------- }




{ ============= Procedure to Change History Fifo and Ser ========= }

Procedure Change_StkLocFIFO(OCode,NCode  :  Str10;
                            UnSoldOnly   :  Boolean);

Const
  Fnum     =  MiscF;
  Keypath  =  MIK;


Var
  KeyS,KeyChk  :  Str255;

  LOk,
  Locked,
  Loop         :  Boolean;

  LAddr        :  LongInt;

  NType        :  Char;
  B_Func       :  Integer;


Begin
  With Stock do
  Begin
    Loop:=UnSoldOnly;

    Repeat
      If (Loop) then
        NType:=MSernSub
      else
        NType:=MFIFOSub;

      KeyChk:=FullQDKey(MFIFOCode,NType,FullNomKey(StockFolio));

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
      With MiscRecs^ do
      Begin

        Application.ProcessMessages;

        If (((Not Loop) and (FIFORec.FIFOMLoc=OCode))
             or ((Loop) and ((SerialRec.InMLoc=OCode) or (SerialRec.OutMLoc=OCode)))) then
        Begin
          LOk:=GetMultiRecAddr(B_GetDirect,B_SingLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

          If (LOk) and (Locked) then
          Begin
            If (Loop) then
            With SerialRec do
            Begin
              If (InMLoc=OCode) then
                InMLoc:=NCode;

              If (OutMLoc=OCode) and ((Not UnSoldOnly) or (Sold)) then
                OutMLoc:=NCode;
            end
            else
              FIFORec.FIFOMLoc:=NCode;

            Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

            If (StatusOk) then
              Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

            Report_BError(Fnum,Status);


          end; {If Locked..}
        end; {IF needs changing}

        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      end; {While..}

      Loop:=Not Loop;

    Until (Not Loop);
  end; {With.}
end; {Proc..}



{ ========== Build runtime view ======== }

procedure TMLocMRec.BuildDesign;


begin
  If (Not Syss.UseMLoc) then
  Begin
    With OPF do
    Begin
      Tag:=0;
      Enabled:=BOff;
      TabStop:=BOff;
    end;

    With OCPF do
    Begin
      Tag:=0;
      Enabled:=BOff;
      TabStop:=BOff;
    end;

    With ORPF do
    Begin
      Tag:=0;
      Enabled:=BOff;
      TabStop:=BOff;
    end;

    With OCF do
    Begin
      Tag:=0;
      Enabled:=BOff;
      TabStop:=BOff;
    end;

    With OSF do
    Begin
      Tag:=0;
      Enabled:=BOff;
      TabStop:=BOff;
    end;

    With OGF do
    Begin
      Tag:=0;
      Enabled:=BOff;
      TabStop:=BOff;
    end;
  end;

  {$IFDEF WOP}
    WOPGL.Visible:=WOPOn;


  {$ELSE}

    WOPGL.Visible:=BOff;

  {$ENDIF}

  Label815.Visible:=WOPGL.Visible;

  {$IFDEF RET}
    RETGL.Visible:=RETMOn;
    PRETGL.Visible:=RETMOn;


  {$ELSE}

    RETGL.Visible:=BOff;
    PRETGL.Visible:=BOff;

  {$ENDIF}

  Label816.Visible:=RETGL.Visible;

end;


procedure TMLocMRec.FormDesign;

Var
  HideCC  :  Boolean;
  UseDec  :  Byte;

begin

  DescF.MaxLength:=MLDescKeyLen;
  SCodeF.MaxLength:=MLocKeyLen;

  BuildDesign;

end;




procedure TMLocMRec.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  ClientHeight:=412;
  ClientWidth:=510;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TLocnList) then
    With TLocnList(Owner) do
      Self.SetFieldProperties(loPanel);

  TAddr[1]:=Ad1F;
  TAddr[2]:=Ad2F;
  TAddr[3]:=Ad3F;
  TAddr[4]:=Ad4F;
  TAddr[5]:=Ad5F;

  GLList[1]:=SalGL;
  GLList[2]:=COSGL;
  GLList[3]:=WOGL;
  GLList[4]:=SVGL;
  GLList[5]:=WIPGL;
  GLList[6]:=WOPGL;
  GLList[7]:=RETGL;
  GLList[8]:=PRETGL;



  FormDesign;

end;




procedure TMLocMRec.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,102);

end;

procedure TMLocMRec.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TMLocMRec.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TMLocMRec.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TMLocMRec.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Procedure TMLocMRec.WMCustGetRec(Var Message  :  TMessage);



Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      38  :  Change_CCCode(OldCode,NewCode);

    end; {Case..}

  end;
  Inherited;
end;



{ == Procedure to Send Message to Get Record == }

Procedure TMLocMRec.Send_UpdateList(Edit   :  Boolean;
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



Function TMLocMRec.CheckNeedStore  :  Boolean;

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


Procedure TMLocMRec.SetFieldFocus;

Begin
  SCodeF.SetFocus;

end; {Proc..}



Procedure TMLocMRec.SetROFields;

Var
  n  :  Byte;
Begin
  DefCC.ReadOnly:=(Not OCF.Checked) or (Not Syss.UseMLoc);
  DefDep.ReadOnly:=DefCC.ReadOnly;

  DefCC.TabStop:=Not DefCC.ReadOnly;
  DefDep.TabStop:=Not DefCC.ReadOnly;

  For n:=Low(GLList) to High(GLList) do
  Begin
    GLList[n].ReadOnly:=(Not OGF.Checked) or (Not Syss.UseMLoc);
    GLList[n].TabStop:=Not GLList[n].ReadOnly;
  end;

end; {Proc..}



Function TMLocMRec.ConfirmQuit  :  Boolean;

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
                StoreId(MLocF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(MLocF,LastRecAddr[MLocF]);

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

Procedure TMLocMRec.OutId;

Const
  Fnum     =  StockF;
  Keypath  =  StkFolioK;

Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  n         :  Byte;

  KeyS      :  Str255;


Begin
  With ExLocal,LMLocCtrl^,MLocLoc do
  Begin

    SCodeF.Text:=Trim(loCode);

    DescF.Text:=Trim(loName);

    For n:=Low(TAddr) to High(TAddr) do
    Begin
      TAddr[n].Text:=loAddr[n];
      GLList[n].Text:=Form_BInt(loNominal[n],0);
    end;

    WOPGL.Text:=Form_BInt(loWOPWIPGL,0);

    RETGL.Text:=Form_BInt(loReturnGL,0);
    PRETGL.Text:=Form_BInt(loPReturnGL,0);

    ConF.Text:=loContact;
    TelF.Text:=loTel;
    FaxF.Text:=loFax;
    ModF.Text:=loModem;
    EmailF.Text:=loemail;
    OPF.Checked:=loUsePrice;
    OCPF.Checked:=loUseCPrice;
    ORPF.Checked:=loUseRPrice;
    OCF.Checked:=loUseCCDep;
    DefCC.Text:=loCCDep[BOn];
    DefDep.Text:=loCCDep[BOff];
    OSF.Checked:=loUseSupp;
    OGF.Checked:=loUseNom;

  end;

  SetROFields;

end;


procedure TMLocMRec.Form2Id;

Var
  n :  Byte;

Begin

  With EXLocal,LMLocCtrl^,MLocLoc do
  Begin
    loCode:=LJVar(SCodeF.Text,MLocKeyLen);
    loName:=DescF.Text;

    For n:=Low(TAddr) to High(TAddr) do
    Begin
      loAddr[n]:=TAddr[n].Text;
      loNominal[n]:=IntStr(GLList[n].Text);
    end;

    loWOPWIPGL:=IntStr(WOPGL.Text);

    loReturnGL:=IntStr(RETGL.Text);
    loPReturnGL:=IntStr(PRETGL.Text);

    loContact:=ConF.Text;
    loTel:=TelF.Text;
    loFax:=FaxF.Text;
    loModem:=ModF.Text;
    loemail:=emailF.Text;

    loUsePrice:=OPF.Checked;
    loUseCPrice:=OCPF.Checked;
    loUseRPrice:=ORPF.Checked;
    loUseCCDep:=OCF.Checked;
    loUseSupp:=OSF.Checked;
    loUseNom:=OGF.Checked;

    loCCDep[BOn]:=DefCC.Text;
    loCCDep[BOff]:=DefDep.Text;


  end; {with..}

end; {Proc..}





(*  Add is used to add Notes *)

procedure TMLocMRec.ProcessId(Fnum,
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
  With ExLocal,LMLocCtrl^,MLocLoc do
  begin

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      RecPfix:=CostCCode;
      Subtype:=CSubCode[BOn];

      LoNLineCount:=1;

    end;

    LastMLoc^:=LMLocCtrl^;

    OutId;

  end {If Abort..}
  else
    Close;

end; {Proc..}




Function TMLocMRec.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  4;


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
  PossMsg^[2]:='One of the General Ledger Control Codes is not valid.';
  PossMsg^[3]:='The WOP Work in progress G/L Code is not valid.';
  PossMsg^[4]:='The Stock Return G/L Code is not valid.';




  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LMLocCtrl^.MLocLoc do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin

              Result:=Not EmptyKey(LoCode,MLocKeyLen);

              If Result Then
              Begin
                // MH 03/11/2010 v6.5 ABSEXCH-3002: Extended to validate location code as a valid location - novel or what!!!
                If (Not LastEdit) Or ((Not LastEdit) And (LastMLoc^.MLocLoc.loCode <> loCode)) Then
                Begin
                  // Adding - must not already exist
                  // Editing - Must not exist if user has changed the code from original
                  Result := Not Global_GetMainRec(MLocF, Quick_MLKey(LoCode))
                End; // If (Not LastEdit) Or ((Not LastEdit) And (LastMLoc^.MLocLoc.loCode <> loCode))
              End; // If Result
            end;

      2  :  If (loUseNom) then
            Begin
              For n:=1 to NofSNoms do
              Begin
                Result:=GetNom(Self,Form_Int(loNominal[n],0),FoundLong,-1);

                If (Not Result) then
                  Break;
              end;
            end
            else
              Result:=BOn;

      3   :  Begin
               Result:=Not WOPOn or (Not loUseNom);

               If (Not Result) then
               Begin

                 Result:=GetNom(Self,Form_Int(loWOPWIPGL,0),FoundLong,-1);
               end;

             end;

      4   :  Begin
               Result:=Not RETMOn or (Not loUseNom);

               If (Not Result) then
               Begin

                 Result:=GetNom(Self,Form_Int(loReturnGL,0),FoundLong,-1) and GetNom(Self,Form_Int(loPReturnGL,0),FoundLong,-1);
               end;

             end;

    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}





{ ============= Procedure to Change History Fifo and Ser ========= }

Procedure TMLocMRec.Change_StkLocHist(OCode,NCode  :  Str10);

Const
  Fnum     =  NHistF;
  Keypath  =  NHK;


Var
  KeyS,KeyChk  :  Str255;

  LOk,
  Locked,
  Loop         :  Boolean;

  LAddr        :  LongInt;

  NType        :  Char;
  B_Func       :  Integer;


Begin
  With Stock do
  Begin
    Loop:=BOff;

    Repeat
      If (Loop) then
        NType:=StockType
      else
        NType:=Calc_AltStkHCode(StockType);

      KeyChk:=NType+CalcKeyHist(StockFolio,OCode);
      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
      With NHist do
      Begin
        Application.ProcessMessages;

        B_Func:=B_GetNext;

        LOk:=GetMultiRecAddr(B_GetDirect,B_SingLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

        If (LOk) and (Locked) then
        Begin
          Code:=FullNHCode(CalcKeyHist(StockFolio,NCode));

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          If (StatusOk) then
            Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

          Report_BError(Fnum,Status);

          B_Func:=B_GetGEq;
        end; {If Locked..}

        Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      end; {While..}

      Loop:=Not Loop;

    Until (Not Loop);
  end; {With.}
end; {Proc..}



{ ============= Procedure to Change History Fifo and Ser ========= }

Procedure TMLocMRec.Update_StkLocNom(OCode :  Str10);

Const
  Fnum4     =  MLocF;
  Keypath4  =  MLSecK;


Var
  KeyS,KeyChk  :  Str255;

  LOk,
  Locked       :  Boolean;

  LAddr        :  LongInt;

  NewNoms      :  DefMLNomType;
  WOPWIPGL,
  ReturnGL,
  PReturnGL    :  LongInt;

  MsgForm      :  TForm;

  mbRet        :  TModalResult;



Begin

  LOk:=Global_GetMainRec(Fnum4,Quick_MLKey(OCode));

  {GetMLoc(OCode,KeyS,-1);}
  Set_BackThreadMVisible(BOn);

  MsgForm:=CreateMessageDialog('Please Wait... Updating Stock Location Records',mtInformation,[]);
  MsgForm.Show;
  MsgForm.Update;

  If (LOk) then
  Begin
    NewNoms:=MLocCtrl^.MLocLoc.loNominal;
    WOPWIPGL:=MLocCtrl^.MLocLoc.loWOPWIPGL;

    ReturnGL:=MLocCtrl^.MLocLoc.loReturnGL;
    PReturnGL:=MLocCtrl^.MLocLoc.loPReturnGL;

    KeyChk:=PartCCKey(CostCCode,CSubCode[BOff])+OCode;
    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum4],Fnum4,RecPtr[Fnum4]^,Keypath4,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
    With MLocCtrl^,MStkLoc do
    Begin
      LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath4,Fnum4,BOn,Locked,LAddr);

      If (LOk) and (Locked) then
      Begin
        lsDefNom:=NewNoms;
        lsWOPWIPGL:=WOPWIPGL;

        lsReturnGL:=ReturnGL;
        lsPReturnGL:=PReturnGL;

        Status:=Put_Rec(F[Fnum4],Fnum4,RecPtr[Fnum4]^,KeyPath4);

        If (StatusOk) then
          Status:=UnLockMultiSing(F[Fnum4],Fnum4,LAddr);
      end;

      Status:=Find_Rec(B_GetNext,F[Fnum4],Fnum4,RecPtr[Fnum4]^,Keypath4,KeyS);

    end; {While..}

  end; {If Fouind Ok..}

  MsgForm.Free;

  Set_BackThreadMVisible(BOff);

end; {Proc..}



{ ============= Procedure to Change History Fifo and Ser ========= }

Procedure TMLocMRec.Update_StkLocCCDep(OCode :  Str10);

Const
  Fnum4     =  MLocF;
  Keypath4  =  MLSecK;


Var
  KeyS,KeyChk  :  Str255;

  LOk,
  Locked       :  Boolean;

  LAddr        :  LongInt;

  NewCCDep     :  CCDepType;

  MsgForm      :  TForm;

  mbRet        :  TModalResult;



Begin

  LOk:=Global_GetMainRec(Fnum4,Quick_MLKey(OCode));

  {GetMLoc(OCode,KeyS,-1);}
  Set_BackThreadMVisible(BOn);

  MsgForm:=CreateMessageDialog('Please Wait... Updating Stock Location Records',mtInformation,[]);
  MsgForm.Show;
  MsgForm.Update;

  If (LOk) then
  Begin
    NewCCDep:=MLocCtrl^.MLocLoc.loCCDep;

    KeyChk:=PartCCKey(CostCCode,CSubCode[BOff])+OCode;
    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum4],Fnum4,RecPtr[Fnum4]^,Keypath4,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
    With MLocCtrl^,MStkLoc do
    Begin
      LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath4,Fnum4,BOn,Locked,LAddr);

      If (LOk) and (Locked) then
      Begin
        lsCCDep:=NewCCDep;

        Status:=Put_Rec(F[Fnum4],Fnum4,RecPtr[Fnum4]^,KeyPath4);

        If (StatusOk) then
          Status:=UnLockMultiSing(F[Fnum4],Fnum4,LAddr);
      end;

      Status:=Find_Rec(B_GetNext,F[Fnum4],Fnum4,RecPtr[Fnum4]^,Keypath4,KeyS);

    end; {While..}

  end; {If Fouind Ok..}

  MsgForm.Free;

  Set_BackThreadMVisible(BOff);

end; {Proc..}

{ ============ Procedure to Change the Code =========== }


Procedure TMLocMRec.Change_CCCode(OCode,NCode  :  Str10);

Const
  Fnum     =  IDetailF;
  Keypath  =  IdFolioK;

  Fnum2    =  CustF;
  Keypath2 =  CustCodeK;

  Fnum3    =  StockF;
  Keypath3 =  StkCodeK;

  Fnum4    =  MLocF;
  Keypath4 =  MLSecK;

  Fnum5    =  InvF;
  Keypath5 =  InvOurRefK;

Var
  KeyChk,
  KeyS       :  Str255;
  PurgeCount,
  LAddr      :  LongInt;

  ChangeCCDep:  ResetCCDep;

  LOk,
  GLocked     :  Boolean;

  lStatus : SmallInt;
Begin
  Progress.CanCP1Btn.Visible:=BOff;
  Progress.Update;


  New(ChangeCCDep,Init);

  Blank(KeyS,Sizeof(KeyS));

  Status:=Find_Rec(B_GetFirst,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


  Progress.Gauge1.MaxValue:=(Used_Recs(F[Fnum],Fnum)+Used_Recs(F[Fnum2],Fnum2)+Used_Recs(F[Fnum3],Fnum3)
               +Used_Recs(F[Fnum4],Fnum4)+Used_Recs(F[Fnum5],Fnum5));

  PurgeCount:=0;

  GLocked:=BOff;

  While (StatusOk) do
  With Id do
  Begin
    Application.ProcessMessages;

    If (MLocStk=OCode) then
    Begin

      LOk:=GetMultiRecAddr(B_GetDirect,B_SingLock,KeyS,KeyPath,Fnum,BOn,GLocked,LAddr);

      If (LOk) and (GLocked) then
      Begin

        MLocStk:=NCode;

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

        Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

      end;
    end;

    Inc(PurgeCount);

    Progress.Gauge1.Progress:=PurgeCount;

    Status:=ChangeCCDep^.GetSearchRec2(Fnum,Keypath,KeyS,OCode);

  end; {While..}
  Dispose(ChangeCCDep,Done);


  PurgeCount:=Used_Recs(F[Fnum],Fnum); {* Bring count in line !! *}


  {* Change any customers / suppliers with new codes *}

  Blank(KeyS,Sizeof(KeyS));

  Status:=Find_Rec(B_GetFirst,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyS);

  While (StatusOk) do
  With Cust do
  Begin
    Application.ProcessMessages;

    If (DefMLocStk=OCode) then
    Begin

      LOk:=GetMultiRecAddr(B_GetDirect,B_SingLock,KeyS,KeyPath2,Fnum2,BOn,GLocked,LAddr);

      If (LOk) and (GLocked) then
      Begin

        DefMLocStk:=NCode;


        Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

        Status:=UnLockMultiSing(F[Fnum2],Fnum2,LAddr);
      end;
    end;

    If (AnalCuStk) then {* Rename Stk anal histories *}
      cuStk_RenCCDep(CustCode,OCode,NCode,BOff,1);

    Inc(PurgeCount);

    Progress.Gauge1.Progress:=PurgeCount;

    Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyS);


  end; {While..}

 {* Change any Stock Records to newcodes *}

  Blank(KeyS,Sizeof(KeyS));

  Status:=Find_Rec(B_GetFirst,F[Fnum3],Fnum3,RecPtr[Fnum3]^,Keypath3,KeyS);

  While (StatusOk) do
  With Stock do
  Begin
    Application.ProcessMessages;

    If (DefMLoc=OCode) then
    Begin

      LOk:=GetMultiRecAddr(B_GetDirect,B_SingLock,KeyS,KeyPath3,Fnum3,BOn,GLocked,LAddr);

      If (LOk) and (GLocked) then
      Begin

        DefMLoc:=NCode;

        Status:=Put_Rec(F[Fnum3],Fnum3,RecPtr[Fnum3]^,KeyPath3);

        Status:=UnLockMultiSing(F[Fnum3],Fnum3,LAddr);
      end;
    end;

    Change_StkLocHist(OCode,NCode);

    Change_StkLocFIFO(OCode,NCode,BOff);


    Inc(PurgeCount);

    Progress.Gauge1.Progress:=PurgeCount;

    Status:=Find_Rec(B_GetNext,F[Fnum3],Fnum3,RecPtr[Fnum3]^,Keypath3,KeyS);

  end; {While..}


  {* Change any Notes *}

  {$IFDEF NP}

    ChangeNoteFolio(NoteLCode,OCode,NCode);

  {$ENDIF}

  {* Change any Stock Location Records to newcodes *}

  KeyChk:=PartCCKey(CostCCode,CSubCode[BOff])+OCode;
  KeyS:=KeyChk;

  Status:=Find_Rec(B_GetGEq,F[Fnum4],Fnum4,RecPtr[Fnum4]^,Keypath4,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
  With MLocCtrl^,MStkLoc do
  Begin
    Application.ProcessMessages;

    LOk:=GetMultiRecAddr(B_GetDirect,B_SingLock,KeyS,KeyPath4,Fnum4,BOn,GLocked,LAddr);

    If (LOk) and (GLocked) then
    Begin
      lsLocCode:=NCode;
      lsCode1:=Full_MLocSKey(lsLocCode,lsStkCode);
      lsCode2:=Full_MLocLKey(lsLocCode,lsStkCode);

      Status:=Put_Rec(F[Fnum4],Fnum4,RecPtr[Fnum4]^,KeyPath4);

      Status:=UnLockMultiSing(F[Fnum4],Fnum4,LAddr);
    end;

    Inc(PurgeCount);

    Progress.Gauge1.Progress:=PurgeCount;

    Status:=Find_Rec(B_GetGEq,F[Fnum4],Fnum4,RecPtr[Fnum4]^,Keypath4,KeyS);

  end; {While..}

  {* Change any WOR Records to newcodes *}

  KeyChk:=DocCodes[WOR];
  KeyS:=KeyChk;

  Status:=Find_Rec(B_GetGEq,F[Fnum5],Fnum5,RecPtr[Fnum5]^,Keypath5,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
  With Inv do
  Begin
    Application.ProcessMessages;

    If (DelTerms=OCode) then
    Begin

      LOk:=GetMultiRecAddr(B_GetDirect,B_SingLock,KeyS,KeyPath5,Fnum5,BOn,GLocked,LAddr);

      If (LOk) and (GLocked) then
      Begin
        DelTerms:=NCode;

        Status:=Put_Rec(F[Fnum5],Fnum5,RecPtr[Fnum5]^,KeyPath5);

        Status:=UnLockMultiSing(F[Fnum5],Fnum5,LAddr);
      end;
    end;

    Inc(PurgeCount);

    Progress.Gauge1.Progress:=PurgeCount;

    Status:=Find_Rec(B_GetNext,F[Fnum5],Fnum5,RecPtr[Fnum5]^,Keypath5,KeyS);

  end; {While..}

  //-------------------------------------------------------------------------

  // Update Override Locations on  Purchase Transactions
  If Syss.EnableOverrideLocations Then
  Begin
    // Run though Purchase Transactions
    KeyS := DocCodes[PIN][1];
    KeyChk := KeyS;

    lStatus:=Find_Rec(B_GetGEq,F[Fnum5],Fnum5,RecPtr[Fnum5]^,Keypath5,KeyS);
    While (lStatus = 0) And CheckKey(KeyChk, KeyS, Length(KeyChk), BOff) Do
    Begin
      Application.ProcessMessages;

      If (Inv.thOverrideLocation = OCode) Then
      Begin
        LOk := GetMultiRecAddr(B_GetDirect,B_SingLock,KeyS,KeyPath5,Fnum5,BOn,GLocked,LAddr);
        If (LOk) and (GLocked) then
        Begin
          Inv.thOverrideLocation := NCode;

          lStatus:=Put_Rec(F[Fnum5],Fnum5,RecPtr[Fnum5]^,KeyPath5);
          lStatus:=UnLockMultiSing(F[Fnum5],Fnum5,LAddr);
        End; // If (LOk) and (GLocked)
      End; // If (Inv.thOverrideLocation = OCode)

      Inc(PurgeCount);
      Progress.Gauge1.Progress:=PurgeCount;

      lStatus:=Find_Rec(B_GetNext,F[Fnum5],Fnum5,RecPtr[Fnum5]^,Keypath5,KeyS);
    End; // While (lStatus = 0) And CheckKey(KeyChk, KeyS, Length(KeyChk), BOff)
  End; // If Syss.EnableOverrideLocations

  //-------------------------------------------------------------------------

  Status:=0;

  Progress.ShutDown;

end; {Proc..}




Procedure TMLocMRec.StartChange(OCode,NCode  :  Str10);

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


procedure TMLocMRec.StoreId(Fnum,
                          Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpMLoc
       :  MLocRec;

  KeyS :  Str255;

  mbRet:  Word;




Begin
  KeyS:='';

  Form2Id;


  With ExLocal,LMLocCtrl^,MLocLoc do
  Begin
    If (LastEdit) and (LastMLoc^.MLocLoc.loCode<>loCode) then
    Begin
      COk:=(Not Check4DupliGen(FullCCKey(RecPfix,SubType,loCode),Fnum,Keypath,'Location Code'));

      If (COk) then
      Begin
        mbRet:=MessageDlg('All existing data will be updated with the new Location code.'+#13+#13+' Continue?',mtConfirmation,[mbYes,mbNo],0);
        COk:=mbRet=(mrYes);

        If (Not COk) then
          SCodeF.Text:=LastMLoc^.MLocLoc.loCode;
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

          TmpMLoc:=LMLocCtrl^;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LMLocCtrl^:=TmpMLoc;

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
        If (LastMLoc^.MLocLoc.loCode<>loCode) then
          StartChange(LastMLoc.MLocLoc.loCode,loCode);

        If (LastMLoc^.MLocLoc.loUseNom<>loUseNom) and (loUseNom) and (LastEdit) then
          Update_StkLocNom(loCode);

        If ((LastMLoc^.MLocLoc.loCCDep[BOff]<>loCCDep[BOff]) or
            (LastMLoc^.MLocLoc.loCCDep[BOn]<>loCCDep[BOn])) and (LastEdit) then
          Update_StkLocCCDep(loCode);
      end;

      Close;
    end
    else
      SetFieldFocus;

  end; {With..}


end;


procedure TMLocMRec.SetFieldProperties(Field  :  TSBSPanel) ;

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


procedure TMLocMRec.EditLine(Edit       :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    ProcessId(MLocF,MLK,LastEdit);
  end;
end;


procedure TMLocMRec.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
      StoreId(MLocF,SKeypath);
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


procedure TMLocMRec.DeleteBOMLine(Fnum,
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
          
          {$IFDEF NP}
            Delete_Notes(NoteLCode,FullNCode(LMLocCtrl^.MLocLoc.loCode));
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



procedure TMLocMRec.OCFClick(Sender: TObject);
begin
  SetROFields;
end;

procedure TMLocMRec.DefCCExit(Sender: TObject);
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
          (Syss.UseCCDep)  and (FoundCode<>'') and (Not Has_CCWildChar(FoundCode)) and (OCF.Checked) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetCCDep(Self,FoundCode,FoundCode,IsCC,2));


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





procedure TMLocMRec.SalGLExit(Sender: TObject);
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

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) and (ExLocal.InAddEdit) and (OGF.Checked) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self.Owner,FoundCode,FoundLong,2));

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin

        AssignFromGlobal(NomF);

      end;


      If (FoundOk) then
      Begin

        StopPageChange:=BOff;

        Text:=Form_Int(FoundLong,0);


      end
      else
      Begin
        StopPageChange:=BOn;

        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;


procedure TMLocMRec.SCodeFExit(Sender: TObject);
Var
  COk   :  Boolean;
  CCode :  Str20;


begin

  If (Sender is TMaskEdit) And (ActiveControl <> CanCP1Btn) then
    With (Sender as TMaskEdit),ExLocal,LMLocCtrl^ do
    Begin
      Text:=UpcaseStr(Text);

      CCode:=LJVar(Text,MLocKeyLen);

      If ((Not LastEdit) or (LastMLoc^.MLocLoc.loCode<>CCode)) and (InAddEdit) then
      Begin
        COk:=(Not Check4DupliGen(FullCCKey(RecPFix,SubType,CCode),MLocF,MLK,'Location Code ('+Strip('B',[#32],CCode)+')'));

        If (Not COk) then
        Begin

          SetFocus;
        end;
      end;
    end;
end;


Initialization
end.

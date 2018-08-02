unit CuStkT1U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mask, TEditVal, bkgroup, BTSupU1,
  SalTxl1U, GlobVar,VarConst,ExWrap1U, SBSPanel;

type
  TCuStkT1 = class(TForm)
    CSLastP: TCurrencyEdit;
    CSRepQ: TCurrencyEdit;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    CSStkCode: Text8Pt;
    CSAcc: Text8Pt;
    CSComp: Text8Pt;
    CSDisp: TCurrencyEdit;
    CSLastD: TEditDate;
    SBSPanel1: TSBSPanel;
    Label85: Label8;
    Label84: Label8;
    Label82: Label8;
    Label81: Label8;
    Id3SCodeLab: Label8;
    Label83: Label8;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure CSStkCodeExit(Sender: TObject);
    procedure CSCompDblClick(Sender: TObject);

  private
    IdStored,
    StopPageChange,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    Procedure OutId;

    procedure Form2Id;

    procedure SetCaption;

    Procedure CKMoveEmUp(KeyChk,
                         KeyS,
                         KeyLimit:  Str255;
                         IncBy   :  LongInt;
                         Fnum,
                         KeyPath :  Integer);


    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

  public
    { Public declarations }

    ExLocal    :  TdExLocal;
    StkMode    :  Byte;

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
  BorBtns,
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BtKeys1U,
  VarRec2U,
  BTSupU2,
  SBSComp2,
  CmpCtrlU,
  CurrncyU,
  ComnUnit,
  ComnU2,
  SysU2,

  ColCtrlU,

  {SysU2,}
  {MLoc0U,}
  InvListU,

  {InvLst3U,}

  CuStkA4U,
  CuStkA2U,
  CuStkA3U,
  CuStkL1U;

  {PayF2U,

  {PayLineU,}

  {DocSupU1;}

  {Saltxl1U;}




{$R *.DFM}







procedure TCuStkT1.SetCaption;

Begin
  With ExLocal, LStock, LCust, LMLocCtrl^.CuStkRec do
  Begin
    Caption:=dbFormatName(StockCode,Desc[1])+'.Stock Analysis Record for : '+dbFormatName(CustCode,Company);

  end;


end;


procedure TCuStkT1.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  ClientHeight:=178;
  ClientWidth:=401;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TTeleSFrm) then
    With TTeleSFrm(Owner) do
      Self.SetFieldProperties(D1RefPanel);


end;




procedure TCuStkT1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,103);

end;

procedure TCuStkT1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TCuStkT1.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TCuStkT1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TCuStkT1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Procedure TCuStkT1.WMCustGetRec(Var Message  :  TMessage);



Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      38  :  ;

    end; {Case..}

  end;
  Inherited;
end;



{ == Procedure to Send Message to Get Record == }

Procedure TCuStkT1.Send_UpdateList(Edit   :  Boolean;
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



Function TCuStkT1.CheckNeedStore  :  Boolean;

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


Procedure TCuStkT1.SetFieldFocus;

Begin
  CSStkCode.SetFocus;

end; {Proc..}





Function TCuStkT1.ConfirmQuit  :  Boolean;

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

Procedure TCuStkT1.OutId;

Const
  Fnum     =  StockF;
  Keypath  =  StkFolioK;

Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  n         :  Byte;

  KeyS      :  Str255;


Begin
  SetCaption;

  With ExLocal,LMLocCtrl^,CuStkRec do
  Begin
    csStkCode.Text:=CsStockCode;
    csAcc.Text:=csCustCode;
    csComp.Text:=LCust.Company;
    csDisp.Value:=csLineNo;
    csRepQ.Value:=csSOQty;
    csLastD.DateValue:=csLastDate;
    csLastP.Value:=csLastPrice;


    csStkCode.ReadOnly := LastEdit;
  end;
end;


procedure TCuStkT1.Form2Id;


Begin

  With EXLocal,LMLocCtrl^,CuStkRec do
  Begin
    csStockCode:=csStkCode.Text;
    csLineNo:=Round(csDisp.Value);
    csSOQty:=csRepQ.Value;

    If (csStockCode=LStock.StockCode) then
      csStkFolio:=LStock.StockFolio;
  end; {with..}

end; {Proc..}





(*  Add is used to add Notes *)

procedure TCuStkT1.ProcessId(Fnum,
                            Keypath     :  Integer;
                            Edit        :  Boolean);

Var
  KeyS     :  Str255;
  UseNext  :  LongInt;


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
  With ExLocal,LMLocCtrl^,CuStkRec do
  begin

    UseNext:=Get_LastLineNo(LCust.CustCode);

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      RecPfix:=MatchTCode;
      Subtype:=MatchSCode;


      csLineNo:=UseNext;
      csCustCode:=LCust.CustCode;

      csCode1:=Full_CuStkLKey(csCustCode,csLineNo);

      If (StkMode=2) then
      Begin
        csStockCode:=LStock.StockCode;
        csStkFolio:=LStock.StockFolio;
      end;
    end;

    LastMLoc^:=LMLocCtrl^;

    OutId;

  end {If Abort..}
  else
    Close;

end; {Proc..}



Function TCuStkT1.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  2;

Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  Test     :  Byte;

  n,
  mbRet    :  Word;

  FoundCode:  Str20;

  FoundLong:  LongInt;


Begin
  New(PossMsg);

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='That stock code is not valid.';
  PossMsg^[2]:='That stock/account code combination is not valid.';

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LMLocCtrl^,cuStkRec do
  Begin
    Case Test of

      1  :
               Result:=(Not EmptyKey(csStockCode,StkKeyLen)) and LGetMainRecPos(StockF,csStockCode);

      2  :     If (Not LastEdit) or (LastMLoc^.CuStkRec.csStockCode<>csStockCode) then
                  Result:=Not CheckExsists(PartCCKey(RecPFix,SubType)+Full_CuStkKey(csCustCode,csStockCode),MLocF,MLSecK)
               else
                  Result:=BOn;


    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (Not MainChk) then
    mbRet:=MessageDlg(PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}



Procedure TCuStkT1.CKMoveEmUp(KeyChk,
                              KeyS,
                              KeyLimit:  Str255;
                              IncBy   :  LongInt;
                              Fnum,
                              KeyPath :  Integer);


Var
  FoundOk,
  Locked    :  Boolean;

  TmpKPath,
  TmpStat   :  Integer;

  LAddr,
  TmpRecAddr
            :  LongInt;





Begin

  FoundOk:=BOff; Locked:=BOff;

  TmpKPath:=GetPosKey;

  With ExLocal do
  Begin
    LAddr:=LastRecAddr[Fnum];

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);


    Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);


    While (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (StatusOk) and (KeyS>=KeyLimit) do
    Begin
      Application.ProcessMessages;

      FoundOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

      With LMLocCtrl^.CuStkRec do
      If (FoundOk) and (Locked) and (csLineNo>0) then
      Begin
        LGetRecAddr(Fnum);

        csLineNo:=csLineNo+IncBy;

        csCode1:=Full_CuStkLKey(csCustCode,csLineNo);

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

        Status:=UnLockMLock(Fnum,LastRecAddr[Fnum]);
      end;

      Status:=Find_Rec(B_GetPrev,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyS);
    end; {While..}

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

    LastRecAddr[Fnum]:=LAddr;

  end; {With..}

end; {Loop..}



procedure TCuStkT1.StoreId(Fnum,
                          Keypath  :  Integer);

Var
  COk  :  Boolean;

  OrigPass,
  OldPass,
  TmpMLoc
       :  MLocRec;

  ChkCode,
  OneLCode,
  LastLCode,
  KeyN,OldCode:  Str255;

  KeyS :  Str255;

  mbRet:  Word;




Begin
  KeyS:='';

  Form2Id;


  With ExLocal,LMLocCtrl^,cuStkRec do
  Begin
    COk:=CheckCompleted(LastEdit,BOff);



    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      csCode1:=Full_CuStkLKey(csCustCode,csLineNo);
      csCode2:=Full_CuStkKey(csCustCode,csStockCode);
      csCode3:=Full_CuStkKey2(csCustCode,csStockCode);

      If (LastMLoc^.CuStkRec.csLineNo<>csLineNo) then
      Begin
        OrigPass:=LMLocCtrl^;

        ChkCode:=PartCCKey(RecPFix,SubType)+csCustCode;

        LastLCode:=Strip('B',[#0],PartCCKey(RecPFix,SubType)+Full_CuStkLKey(csCustCode,65535));

        OneLCode:=Strip('B',[#0],PartCCKey(RecPFix,SubType)+Full_CuStkLKey(csCustCode,csLineNo));

        CKMoveEmUp(ChkCode,
                   LastLCode,
                   OneLCode,
                   1,
                   MLocF,MLK);

        LMLocCtrl^:=OrigPass;

      end;


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

      Close;
    end
    else
      SetFieldFocus;

  end; {With..}


end;


procedure TCuStkT1.SetFieldProperties(Field  :  TSBSPanel) ;

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


procedure TCuStkT1.EditLine(Edit       :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    ProcessId(MLocF,MLK,LastEdit);
  end;
end;


procedure TCuStkT1.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
    With (Sender as TButton) do
    Begin
      If (ModalResult=mrOk) then
      Begin
        // MH 20/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
        //                                   fields which processes the text and updates the value
        If (ActiveControl <> OkCP1Btn) Then
          // Move focus to OK button to force any OnExit validation to occur
          OkCP1Btn.SetFocus;

        // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
        If (ActiveControl = OkCP1Btn) Then
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


procedure TCuStkT1.DeleteBOMLine(Fnum,
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
        With LMLocCtrl^,cuStkRec do
        Begin

          cu_DeleteCStkHistory(csCustCode,csStkFolio,BOff);

          Send_UpdateList(BOff,17);


        end;
      end; {If line is valid for deletion..}
    end
    else
      Report_BError(Fnum,Status);
  end; {With..}

  Close;
end; {PRoc..}





procedure TCuStkT1.CSStkCodeExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt),ExLocal,LMLocCtrl^,CuStkRec do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetStock(Self.Owner,FoundCode,FoundCode,3));


      If ((Not LastEdit) or (LastMLoc^.cuStkRec.csStockCode<>FoundCode)) and (InAddEdit) and (FoundOk) then
      Begin
        FoundOk:=(Not Check4DupliGen(PartCCKey(MatchTCode,MatchSCode)+Full_CuStkKey(csCustCode,FoundCode),MLocF,MLSecK,'Stock/Account combination'));
      end;

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin

        AssignFromGlobal(StockF);


        StillEdit:=BOff;



        Text:=FoundCode;

      end
      else
      Begin
        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;

procedure TCuStkT1.CSCompDblClick(Sender: TObject);
begin
  CSACC.DblClick;
end;

Initialization

end.

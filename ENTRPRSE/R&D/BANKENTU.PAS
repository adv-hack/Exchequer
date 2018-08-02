unit BankEntU;

// CJS 21/03/2011 ABSEXCH-11089 - Restricted Payment and Receipt fields to
//                                nine digits

// CJS 14/04/2011 ABSEXCH-11089 - Restricted Payment and Receipt fields to
//                                twelve digits

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, SBSPanel, TEditVal, bkgroup, GlobVar,VarConst,ExWrap1U,CmpCtrlU,
  BorBtns;


type
  TReconEnt = class(TForm)
    SBSPanel1: TSBSBackGroup;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    NCrF: TCurrencyEdit;
    NDrF: TCurrencyEdit;
    NIDF: Text8Pt;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    I2TransDateF: TEditDate;
    Label84: Label8;
    MatchDateF: TBorCheck;
    Label85: Label8;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure NDrFExit(Sender: TObject);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure NIDFExit(Sender: TObject);
  private
    { Private declarations }
    IdStored,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;


    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    Function NTOther(TCE  :  TObject)  :  TCurrencyEdit;

    Function NTRight(Amount  :  Real)  :  TCurrencyEdit;

    Procedure OutId;

    procedure Form2Id;

    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);


    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

  public
    { Public declarations }

    CtrlNom    :  LongInt;
    CtrlCr     :  Byte;

    BankMCtrl  :  PassWordRec;

    ExLocal    :  TdExLocal;


    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSPanel) ;


    procedure EditLine(BPW        :  PassWordRec;
                       BNomC      :  LongInt;
                       BCr        :  Byte;
                       Edit,
                       VO         :  Boolean);

    procedure DeleteBOMLine(Fnum,
                            KeyPath  :  Integer;
                            BPW      :  PassWordRec;
                            CNom     :  LongInt;
                            CCr      :  Byte);

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
  BTSupU1,
  BTSupU2,
  SBSComp2,
  CurrncyU,
  ComnUnit,
  ComnU2,
  ColCtrlU,

  BankRCSU,
  BankRCU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  ExThrd2U,
  SysU2;



{$R *.DFM}





procedure TReconEnt.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  ClientHeight:=117;
  ClientWidth:=522;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TBankARec) then
    With TBankARec(Owner) do
    Begin
      Self.SetFieldProperties(D1RefPanel);
    end;


end;




procedure TReconEnt.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,104);

end;

procedure TReconEnt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TReconEnt.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TReconEnt.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TReconEnt.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TReconEnt.Send_UpdateList(Edit   :  Boolean;
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



Function TReconEnt.CheckNeedStore  :  Boolean;

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


Procedure TReconEnt.SetFieldFocus;

Begin
  If (NIDF.CanFocus) then
    NIDF.SetFocus;
end; {Proc..}




Function TReconEnt.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin

  TmpBo:=BOff;

  If (ExLocal.InAddEdit) and (CheckNeedStore) and (Not ExLocal.LViewOnly) and (Not IdStored) then
  Begin

    Set_BackThreadMVisible(BOn);

    mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);

    Set_BackThreadMVisible(BOff);

  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes  :  Begin
                StoreId(MiscF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(MiscF,LastRecAddr[MiscF]);

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



{ ================= Function Return if input should be a debit / Credit ========= }

Function TReconEnt.NTRight(Amount  :  Real)  :  TCurrencyEdit;

Begin
  If (Amount<0) then
    NTRight:=NCrF
  else
    NTRight:=NDrF;
end;


{ ================= Function Return if input should be a debit / Credit ========= }

Function TReconEnt.NTOther(TCE  :  TObject)  :  TCurrencyEdit;

Begin
  If (TCE=NDrF) then
    Result:=NCrF
  else
    Result:=NDrF;
end;



procedure TReconEnt.NDrFExit(Sender: TObject);
begin
  With TCurrencyEdit(Sender) do
  Begin
    If (Round_up(Value,2)<>0.0) then
      NTOther(Sender).Value:=0.0;

  end;
end;



{ ============== Display Id Record ============ }

Procedure TReconEnt.OutId;


Begin
  With ExLocal,LMiscRecs^.BankMRec do
  Begin
    NIDF.Text:=BankRef;
    NTRight(BankValue).Value:=ABS(BankValue);
    I2TransDateF.DateValue:=EntryDate;
    MatchDateF.Checked:=MatchDate;
  end;

end;


procedure TReconEnt.Form2Id;

Begin

  With EXLocal.LMiscRecs^.BankMRec do
  Begin
    BankRef:=Strip('R',[#32,#0],NIDF.Text);
    BankValue:=NDrF.Value+(NCrF.Value*DocNotCnst);
    EntryDate:=I2TransDateF.DateValue;
    MatchDate:=MatchDateF.Checked;

  end; {with..}

end; {Proc..}





procedure TReconEnt.SetIdStore(EnabFlag,
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

procedure TReconEnt.ProcessId(Fnum,
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
  With ExLocal,LMiscRecs^ do
  begin

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      RecMfix:=MBankHed;
      SubType:=MBankSub;


      With BankMRec do
      Begin

        BankNom:=CtrlNom;
        BankCr:=CtrlCr;

        EntryOpo:=EntryRec^.Login;

        EntryDate:=Today;

        BankMatch:=PartBankMKey(BankNom,BankCr);

        
      end; {With.}



    end;

    LastMisc^:=LMiscRecs^;

    OutId;


  end; {If Abort..}

  SetIdStore(BOn,ExLocal.LViewOnly);

end; {Proc..}






procedure TReconEnt.StoreId(Fnum,
                            Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpMisc
       :  MiscRec;

  KeyS :  Str255;




Begin
  KeyS:='';

  Form2Id;


  With ExLocal,LMiscRecs^,BankMRec do
  Begin

    COk:=BOn;


    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      If (LastMisc^.BankMRec.BankRef<>BankRef) or (LastMisc^.BankMRec.BankValue<>BankValue) then
      Begin
        EntryStat:=0;
        MatchDoc:='';
        UsePayIn:=BOff;
      end;

      BankMCtrl.BankCRec.AllMatchOk:=BOff;

      BankM_CtrlPut(PwrdF,PWK,CtrlNom,CtrlCr,BankMCtrl,nil);

      If (LastEdit) then
      Begin
        BankM_CtrlCalc(PWrdF,PWK,CtrlNom,CtrlCr,LastMisc^.BankMRec.BankValue,BOn,BOff,BOff,BankMCtrl,nil);

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpMisc:=LMiscRecs^;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LMiscRecs^:=TmpMisc;

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
        BankMCtrl.BankCRec.ManChange:=BOn;

        BankM_CtrlCalc(PWrdF,PWK,CtrlNom,CtrlCr,LMiscRecs^.BankMRec.BankValue,BOff,BOn,BOff,BankMCtrl,nil);

      end;

      Cursor:=CrDefault;

      InAddEdit:=BOff;

      If (LastEdit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      IdStored:=BOn;

      SetIdStore(BOff,BOff);

      Send_UpdateList(LastEdit,18);

      LastValueObj.UpdateAllLastValues(Self);

      Close;
    end
    else
      SetFieldFocus;

  end; {With..}


end;


procedure TReconEnt.SetFieldProperties(Field  :  TSBSPanel) ;

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


procedure TReconEnt.EditLine(BPW        :  PassWordRec;
                             BNomC      :  LongInt;
                             BCr        :  Byte;
                             Edit,
                             VO         :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    BankMCtrl:=BPW;
    CtrlNom:=BNomC;
    CtrlCr:=BCr;

    LViewOnly:=VO;

    AssignFromGlobal(MiscF);

    ProcessId(MiscF,MIK,LastEdit);
  end;
end;



procedure TReconEnt.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
      if (OkCP1Btn.CanFocus) then
        OkCP1Btn.SetFocus;
      if (ActiveControl = OkCP1Btn) then
        StoreId(MiscF,SKeypath);
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


procedure TReconEnt.DeleteBOMLine(Fnum,
                                  KeyPath  :  Integer;
                                  BPW      :  PassWordRec;
                                  CNom     :  LongInt;
                                  CCr      :  Byte);

Var
  LOk    :  Boolean;
  MbRet  :  Word;
  GotRec :  Integer;
  KeyS   :  Str255;

Begin
  With ExLocal do
  Begin
    BankMCtrl:=BPW;
    CtrlNom:=CNom;
    CtrlCr:=CCr;

    AssignFromGlobal(Fnum);
    LGetRecAddr(Fnum);
    OutId;
    OKCP1Btn.Enabled:=BOff;
    CanCP1Btn.Enabled:=BOff;

    Set_BackThreadMVisible(BOn);

    MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Line',
                       mtConfirmation,[mbYes,mbNo],0);

    Set_BackThreadMVisible(BOff);

    If (MbRet=MrYes) then
    Begin
      Status:=LGetDirectRec(Fnum,KeyPath);

      If (StatusOk) then
      Begin

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOff,GlobLocked);

        If (LOk) and (GlobLocked) then
        Begin

          Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

          Report_BError(Fnum,Status);

          BankMCtrl.BankCRec.ManChange:=BOn;

          BankM_CtrlCalc(PWrdF,PWK,CtrlNom,CtrlCr,LMiscRecs.BankMRec.BankValue,BOn,BOn,BOff,BankMCtrl,nil);

        end;

        If (StatusOk) then
          Send_UpdateList(BOff,19);


      end; {If line is valid for deletion..}
    end
    else
      Report_BError(Fnum,Status);
  end; {With..}

  Close;
end; {PRoc..}


procedure TReconEnt.NIDFExit(Sender: TObject);
begin
  If (ActiveControl=NDrF) then
    FieldNextFix(Self.Handle,ActiveControl,Sender);
end;

Initialization


end.

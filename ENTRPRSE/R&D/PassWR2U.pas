unit PassWR2U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, bkgroup, SBSPanel,
  GlobVar,VarConst,VarRec2U,ExWrap1U,BTSupU1,CmpCtrlU,SupListU, DateUtils;

type

  TPWMList  =  Class(TGenList)

  Public
    CUser  :  Str10;
    
    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function CheckRowEmph :  Byte; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

  end;


  TPLMList  =  Class(TPWMList)

  Public
    OverW       :  Boolean;
    EntryRec2   :  EntryRecType;

    Function Ok2Del :  Boolean; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

  end;


type
  TPassWRec2 = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    SCodeF: Text8Pt;
    Label81: Label8;
    Label82: Label8;
    DescF: Text8Pt;
    SBSBackGroup1: TSBSBackGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure DescFEnter(Sender: TObject);
    procedure DescFExit(Sender: TObject);
  private
    CopyMode,
    SysMMode,
    ChangeMMode,
    IdStored,
    StopPageChange,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;

    Sel_User     :  Str10;

    TmpEntry     :  EntryRecType;


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

  // MH 04/11/2010 v6.5 ABSEXCH-9521: Rewrote Change My Password process as it was shockingly shoddy
  //Procedure Change_PassWord(Owner  :  TWinControl);  Moved to ChangePwordF.Pas

  Function Get_PWDefaults(PLogin  :  Str10)  :  tPassDefType;

  Procedure Store_PWDefaults(PLogin    :  Str10;
                             NewPFile  :  tPassDefType);

  //GS 01/06/2011 ABSEXCH-11376: added routines for incrementing / updating the password expiry date
  Procedure SetPasswordExpDate(var ADefaultsRec: tPassDefType);
  Function  IncPasswordExpDate(Const AIncValue: Integer; Const ACurrentExpiryDate: String): String;

  Function Process_Profile(PLogIn  :  Str10)  :  Boolean;


  Function GetProfileAccount(IsCust  :  Boolean)  :  Str10;


  // CJS 2013-09-11 - ABSEXCH-13192 - add Job Costing to user profile rules
  function GetProfileCCDepEx(CustCC, CustDept: Str5;
                             StockCCDept,
                             InputCCDept,
                             JobCCDept: CCDepType;
                             ProtectInput: Byte): CCDepType;

  // CJS 2013-09-11 - ABSEXCH-13192 - add Job Costing to user profile rules
  function GetCustProfileCCDepEx(CustCC, CustDept: Str5;
                                 InputCCDept,
                                 JobCCDept: CCDepType;
                                 ProtectInput: Byte): CCDepType;

  Function GetProfileCCDep(CustCC,CustDep  :  Str5;
                           StkCCDep,
                           InpCCDep        :  CCDepType;
                           ProtectInp      :  Byte)  :  CCDepType;

  Function GetCustProfileCCDep(CustCC,CustDep  :  Str5;
                               InpCCDep        :  CCDepType;
                               ProtectInp      :  Byte)  :  CCDepType;

  Function GetProfileMLoc(CustLoc,
                          StkLoc,
                          InpLoc          :  Str5;
                          ProtectInp      :  Byte)  :  Str5;

  Function GetCustProfileMLoc(CustLoc,InpLoc :  Str5;
                              ProtectInp     :  Byte)  :  Str5;

  Function GetProfileBank(IsCust  :  Boolean)  :  Longint;

  Function GetProfilePrinter(FormMode  :  Boolean)  :  Str255;


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
  SBSComp2,
  CurrncyU,
  ComnUnit,
  ComnU2,


  ColCtrlU,

  {SysU2,}

  PassWL2U,

  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}
  CryptO,
  InpPWU,
  {PayLineU,}
  DocSupU1,
  SysU1,
  Saltxl1U,
  StrUtils;




{$R *.DFM}


{$I PWTIU.PAS}


{ ========== Build runtime view ======== }

procedure TPassWRec2.BuildDesign;


begin


end;


procedure TPassWRec2.FormDesign;


begin


  BuildDesign;

end;


procedure TPassWRec2.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  JustCreated:=BOn;

  Sel_User:='';

  SKeypath:=0;

  Height:=179;
  Width:=290;
  ChangeMMode:=BOff;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TPWordList2) then
      With TPWordList2(Owner) do
      Begin
        Self.SetFieldProperties(UNPanel);
      end;

  TmpEntry:=EntryRec^;

  FormDesign;

  ChangeCryptoKey (23130);
end;




procedure TPassWRec2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
  Begin
    Send_UpdateList(BOff,102);

  end;

end;

procedure TPassWRec2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;

  EntryRec^:=TmpEntry;

end;

procedure TPassWRec2.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TPassWRec2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TPassWRec2.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


{ == Procedure to Send Message to Get Record == }

Procedure TPassWRec2.Send_UpdateList(Edit   :  Boolean;
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



Function TPassWRec2.CheckNeedStore  :  Boolean;

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


Procedure TPassWRec2.SetFieldFocus;

Begin
  SCodeF.SetFocus;

end; {Proc..}




Function TPassWRec2.ConfirmQuit  :  Boolean;

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

Procedure TPassWRec2.OutId;

Const
  Fnum     =  StockF;
  Keypath  =  StkFolioK;

Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  KeyS      :  Str255;


Begin
  With ExLocal,LPassWord.PassEntryRec do
  Begin

    SCodeF.Text:=Strip('R',[#32],Login);

    ChangeCryptoKey (23130);

    DescF.Text:=Decode(PWord);
  end;

end;


procedure TPassWRec2.Form2Id;

Begin

  With EXLocal,LPassWord.PassEntryRec do
  Begin
    Login:=LJVar(SCodeF.Text,LoginKeyLen);

    ChangeCryptoKey (23130);
    PWord:=EnCode(DescF.Text);
  end; {with..}

end; {Proc..}





(*  Add is used to add Notes *)

procedure TPassWRec2.ProcessId(Fnum,
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
  With ExLocal,LPassWord,PassEntryRec do
  begin

    If (Not Edit) then
    Begin
      Sel_User:=Login;

      If (Not CopyMode) then
      Begin
        LResetRec(Fnum);
        FillChar(EntryRec^.Access,Sizeof(EntryRec^.Access),0);
      end;

      If (SysMMode) then
      Begin
        FillChar(LPassword.PassEntryRec.Access,Sizeof(LPassword.PassEntryRec.Access),1);
        FillChar(EntryRec^.Access,Sizeof(EntryRec^.Access),1);
      end;

      Blank(EntryRec^.Login,sizeof(EntryRec^.Login));

      RecPfix:=PassUCode;

    end;

    LastPassWord:=LPassWord;

    OutId;

  end {If Abort..}
  else
    Close;

end; {Proc..}






Function TPassWRec2.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  2;


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
  ShowMsg := True;

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='That User Name is not valid.';
  PossMsg^[2]:='You must choose a different password.';


  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LPassWord.PassEntryRec do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin

              Result:=Not EmptyKey(Login,LoginKeyLen);

            end;
      2  :  Begin

              Result:=(Not ChangeMMode) or (LastPassword.PassEntryRec.PWord<>PWord);

            end;

    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}



procedure TPassWRec2.StoreId(Fnum,
                          Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpPWrd
       :  PassWordRec;

  KeyS :  Str255;

  mbRet:  Word;

  UProfile
       :  tPassDefType;




Begin
  KeyS:='';

  Form2Id;


  With ExLocal,LPassWord,PassEntryRec do
  Begin
    If (LastEdit) and (LastPassword.PassEntryRec.Login<>Login) then
    Begin
      COk:=(Not Check4DupliGen(FullPWordKey(RecPfix,SubType,PassEntryRec.Login),Fnum,Keypath,'User Name'));


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


      If (StatusOk) then {* Atempt to synchronise the profile *}
      Begin
        UProfile:=Get_PWDefaults(Login);

        If (UProfile.Loaded) and (UProfile.PWExpMode=1) then
        With UProfile do
        Begin
          PWExpDate:=CalcDueDate(Today,PWExpDays);

          Store_PWDefaults(Login,UProfile);

        end;

        TmpEntry.PWord:=ExLocal.LPassWord.PassEntryRec.PWord;
      end;


      Cursor:=CrDefault;

      InAddEdit:=BOff;

      If (LastEdit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);


      IdStored:=BOn;


      Close;
    end
    else
      SetFieldFocus;

  end; {With..}


end;


procedure TPassWRec2.SetFieldProperties(Field  :  TSBSPanel) ;

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


procedure TPassWRec2.EditLine(Edit       :  Boolean;
                             MMode      :  Byte);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    CopyMode:=(MMode=5);
    SysMMode:=(MMode=4);
    ChangeMMode:=(MMode=6);

    ProcessId(PWrdF,PWK,LastEdit);
  end;
end;


procedure TPassWRec2.CanCP1BtnClick(Sender: TObject);
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




procedure TPassWRec2.DescFEnter(Sender: TObject);
begin
  {DescF.PassWordChar:=#0;}
  DescF.Text:=Trim(DescF.Text);
end;

procedure TPassWRec2.DescFExit(Sender: TObject);
begin
  If (Not DescF.ReadOnly) and (ActiveControl<> CanCP1Btn) then
  Begin
    If (Not VerifyPassword(Encode(Trim(DescF.Text)),Self)) then
    Begin
      DescF.Text:='';
      DescF.SetFocus;
    end;

    {DescF.PassWordChar:='x';}
  end;
end;

{== Procedure to Control users own admin of password ==}


Procedure Change_PassWord(Owner  :  TWinControl);


Var
  InpOk :  Boolean;
  PCoded,
  Scode :  String;

  KeyS  :  Str255;

Begin
  KeyS:=FullPWordKey(PassUCode,Chr(0),EntryRec^.Login);

  If (Syss.UsePasswords) then
  Begin
    Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,PWK,KeyS);

    If (StatusOk)  then
    Begin
      Scode:='';

      InpOk:=VerifyPassword(EntryRec^.PWord,Owner);


      If (InpOk) then
      With  TPassWRec2.Create(Owner) do
      try
        With ExLocal do
        Begin
          AssignFromGlobal(PwrdF);

          WindowState:=wsNormal;

          EditLine(BOn,6);

          ShowModal;
        end;
      finally
        Free;

      end; {Try..}
    end; {If PWrds switched on}
  end;

end; {Proc..}


{ == Get Profile record == }

Function Get_PWDefaults(PLogin  :  Str10)  :  tPassDefType;

Const
  Fnum     =  MLocF;
  Keypath  =  MLK;

Var
  Mbret  :  Word;

  KeyS,
  KeyChk :  Str255;

  B_Func :  Integer;

  LOk,
  LLocked
         :  Boolean;

Begin
  Blank(Result,Sizeof(Result));

  KeyChk:=FullPWordKey(PassUCode,'D',PLogin);

  KeyS:=KeyChk;

  Begin
    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (StatusOk) then
    Begin
      Result:=MLocCtrl^.PassDefRec;
      {$IFDEF LTE}
        Result.PWExpMode:=0;
      {$ENDIF}
    end;

    Result.Loaded:=StatusOk;

  end; {With..}
end;


Procedure Store_PWDefaults(PLogin    :  Str10;
                           NewPFile  :  tPassDefType);

Const
  Fnum     =  MLocF;
  Keypath  =  MLK;

Var
  Mbret  :  SmallInt;

  KeyS,
  KeyChk :  Str255;

  B_Func :  Integer;

  GetPWDef
         :  tPassDefType;


  NewRec,
  OldRec,
  LOk,
  LLocked
         :  Boolean;

Begin

  OldRec:=Get_PWDefaults(PLogin).Loaded;


  If (OldRec) then
  With MLocCtrl^ do
  Begin
    PassDefRec:=NewPFile;

    Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);

    Report_BError(Fnum,Status);


  end; {With..}
end;


{ == Process profile and check for expiry == }

Function Process_Profile(PLogIn  :  Str10)  :  Boolean;

Const
  Fnum     =  MLocF;
  Keypath  =  MLK;

Var
  Ok2Store,
  Expired  :  Boolean;
  DayGap   :  LongInt;
  plural   :  Str5;


Begin
  Result:=BOn; Ok2Store:=BOff; Expired:=BOff; DayGap:=0;

  UserProfile^:=Get_PWDefaults(PLogin);

  GetLocalPr(1); {Synchronise local with global}

  If (UserProfile^.Loaded) then
  With UserProfile^ do
  Begin
    If (PWExpMode>0) then
    Begin
      If (PWExpMode=1) then
      Begin
        DayGap:=NoDays(Today,PWExpDate);

        Expired:=(DayGap<=0);


        If (Not Expired) and (DayGap<=10) then
          ShowMessage('WARNING!'+#13+'Your Password will expire in '+Form_Int(DayGap,0)+' days time, on '+PoutDate(PWExpDate)+'.'#13+
                             'Please renew your Password via the Utilities menu.')
        else
        If (Expired) then
        Begin
          PWExpMode:=2;

          Ok2Store:=BOn;
        end;

      end;

      If (PWExpMode=2) then
        ShowMessage('WARNING!'+#13+'Your Password has expired.'+#13+
                           'Please contact your system administrator to renew it.');

      If (Ok2Store) then
        Store_PWDefaults(PLogin,UserProfile^);

      Result:=(PWExpMode<>2);
    end; {If PW expires}
  end;
end;


{ == Functions to override defaults with Profile == }

Function GetProfileAccount(IsCust  :  Boolean)  :  Str10;

Begin
  Result:='';

  Case IsCust of
    BOff  :  With UserProfile^ do
               If (Not EmptyKey(DirSupp,CustKeyLen)) then
                 Result:=DirSupp
               else
                 Result:=Syss.DirectSupp;
    BOn   :  With UserProfile^ do
               If (Not EmptyKey(DirCust,CustKeyLen)) then
                 Result:=DirCust
               else
                 Result:=Syss.DirectCust;
  end; {Case..}


end;


// CJS 2013-09-11 - ABSEXCH-13192 - add Job Costing to user profile rules
function GetProfileCCDepEx(CustCC, CustDept: Str5;
                           StockCCDept,
                           InputCCDept,
                           JobCCDept: CCDepType;
                           ProtectInput: Byte): CCDepType;
begin
  // Default to the Input CC/Dept -- this is usually the CC/Dept from the record
  // that is being edited, or the CC/Dept from the source record, where new
  // records are being generated based on existing records.
  Result := InputCCDept;

  with UserProfile^ do
  begin
    case CCDepRule of
      1:
        begin { Account, Stock, Opo, JobCosting }
          // Default to the supplied Account Cost Centre and Department, unless
          // the Protect Input flag is set, in which case only default if the
          // matching Input CC/Dept array element is empty.
          if (ProtectInput = 1) then
          begin
            If (EmptyKeyS(Result[BOn], CCKeyLen, BOff)) then
              Result[BOn] := CustCC;

            If (EmptyKeyS(Result[BOff], CCKeyLen, BOff)) then
              Result[BOff] := CustDept;
          end
          else
          begin
            Result[BOn]  := CustCC;
            Result[BOff] := CustDept;
          end;

          // If we weren't given an Input CC/Dept and the Account CC/Dept was
          // empty, use the CC/Dept from the Stock record
          if (EmptyKeyS(Result[BOn], CCKeyLen, BOff)) then
            Result[BOn] := StockCCDept[BOn];

          if (EmptyKeyS(Result[BOff], CCKeyLen, BOff)) then
            Result[BOff] := StockCCDept[BOff];

          // If we still don't have a CC/Dept, use the CC/Dept from the user
          // profile
          if (EmptyKeyS(Result[BOn], CCKeyLen, BOff)) then
            Result[BOn] := CCDep[BOn];

          if (EmptyKeyS(Result[BOff], CCKeyLen, BOff)) then
            Result[BOff] := CCDep[BOff];

        end;

      2:
        begin {Opo, Account, Stock, JobCosting }
          // Default to the Cost Centre and Department from the User Profile,
          // unless the Protect Input flag is set, in which case only default
          // if the matching Input CC/Dept array element is empty.
          if (ProtectInput = 1) then
          begin
            if (EmptyKeyS(Result[BOn], CCKeyLen, BOff)) then
              Result[BOn] := CCDep[BOn];

            If (EmptyKeyS(Result[BOff], CCKeyLen, BOff)) then
              Result[BOff] := CCDep[BOff];
          end
          else
          begin
            Result := CCDep;
          end;

          // If we weren't given an Input CC/Dept and the User Profile CC/Dept
          // was empty, use the Account CC/Dept
          if (EmptyKeyS(Result[BOn], CCKeyLen, BOff)) then
            Result[BOn] := CustCC;

          if (EmptyKeyS(Result[BOff], CCKeyLen, BOff)) then
            Result[BOff] := CustDept;

          // If we still don't have a CC/Dept, use the CC/Dept from the Stock
          // record
          if (EmptyKeyS(Result[BOn], CCKeyLen, BOff)) then
            Result[BOn] := StockCCDept[BOn];

          if (EmptyKeyS(Result[BOff], CCKeyLen, BOff)) then
            Result[BOff] := StockCCDept[BOff];
        end;

      3:
        begin {Opo, Stock, Account, JobCosting }
          // Default to the Cost Centre and Department from the user profile,
          // unless the Protect Input flag is set, in which case only default
          // if the matching Input CC/Dept array element is empty.
          if (ProtectInput = 1) then
          begin
            if (EmptyKeyS(Result[BOn], CCKeyLen, BOff)) then
              Result[BOn] := CCDep[BOn];

            if (EmptyKeyS(Result[BOff], CCKeyLen, BOff)) then
              Result[BOff] := CCDep[BOff];
          end
          else
          begin
            Result := CCDep;
          end;

          // If we weren't given an Input CC/Dept and the User Profile CC/Dept
          // was empty, use the Stock CC/Dept
          if (EmptyKeyS(Result[BOn], CCKeyLen, BOff)) then
            Result[BOn] := StockCCDept[BOn];

          if (EmptyKeyS(Result[BOff], CCKeyLen, BOff)) then
            Result[BOff] := StockCCDept[BOff];

          // If we still don't have a CC/Dept, use the CC/Dept from the Account
          // record
          if (EmptyKeyS(Result[BOn], CCKeyLen, BOff)) then
            Result[BOn] := CustCC;

          if (EmptyKeyS(Result[BOff], CCKeyLen, BOff)) then
            Result[BOff] := CustDept;
        end;

      else
        begin {Stock, Account, Opo, JobCosting}
          // Default to the Cost Centre and Department from the Stock record,
          // unless the Protect Input flag is set, in which case only default
          // if the matching Input CC/Dept array element is empty.
          if (ProtectInput = 1) then
          begin
            if (EmptyKeyS(Result[BOn], CCKeyLen, BOff)) then
              Result[BOn] := StockCCDept[BOn];

            if (EmptyKeyS(Result[BOff], CCKeyLen, BOff)) then
              Result[BOff] := StockCCDept[BOff];
          end
          else
          begin
            Result:=StockCCDept;
          end;

          // If we weren't given an Input CC/Dept and the Stock CC/Dept was
          // empty, use the supplied Account CC/Dept
          if (EmptyKeyS(Result[BOn], CCKeyLen, BOff)) then
            Result[BOn] := CustCC;

          if (EmptyKeyS(Result[BOff], CCKeyLen, BOff)) then
            Result[BOff] := CustDept;

          // If we still don't have a CC/Dept, use the CC/Dept from the User
          // Profile record
          if (EmptyKeyS(Result[BOn], CCKeyLen, BOff)) then
            Result[BOn] := CCDep[BOn];

          if (EmptyKeyS(Result[BOff], CCKeyLen, BOff)) then
            Result[BOff] := CCDep[BOff];
        end;
    end; {Case..}
  end; {With..}

  // If Job Costing is active...
  If JBCostOn then
  begin
    // ...and we reach here without a CC/Dept, use the CC/Dept from the Job
    // Costing record (the Job Costing option is always taken last in all of
    // the User Profile rules).
    if (EmptyKeyS(Result[BOn], CCKeyLen, BOff)) then
      Result[BOn] := JobCCDept[BOn];

    if (EmptyKeyS(Result[BOff], CCKeyLen, BOff)) then
      Result[BOff] := JobCCDept[BOff];
  end;
end;

// CJS 2013-09-11 - ABSEXCH-13192 - add Job Costing to user profile rules
function GetCustProfileCCDepEx(CustCC, CustDept: Str5;
                               InputCCDept,
                               JobCCDept: CCDepType;
                               ProtectInput: Byte): CCDepType;
// This is a convenience function for calling GetProfileCCDepEx() where no
// Stock CC/Dept is required -- it simply passes an empty Stock CC/Dept
// array.
var
  StockCCDept:  CCDepType;
Begin
  Blank(StockCCDept, Sizeof(StockCCDept));
  Result := GetProfileCCDepEx(CustCC, CustDept, StockCCDept, InputCCDept, JobCCDept, ProtectInput);
end;

// CJS 2013-09-11 - ABSEXCH-13192 - add Job Costing to user profile rules
Function GetProfileCCDep(CustCC,CustDep  :  Str5;
                         StkCCDep,
                         InpCCDep        :  CCDepType;
                         ProtectInp      :  Byte)  :  CCDepType;
// This is an amended version of the original GetProfileCCDep() function,
// which calls the new GetProfileCCDepEx() function passing a blank Job CC/Dept
// array. It should only be used where Job Costing is not relevant.
var
  JobCCDept: CCDepType;
Begin
  Blank(JobCCDept, SizeOf(JobCCDept));
  Result := GetProfileCCDepEx(CustCC, CustDep, StkCCDep, InpCCDep, JobCCDept, ProtectInp);
end;

// CJS 2013-09-11 - ABSEXCH-13192 - add Job Costing to user profile rules
Function GetCustProfileCCDep(CustCC,CustDep  :  Str5;
                             InpCCDep        :  CCDepType;
                             ProtectInp      :  Byte)  :  CCDepType;
// This is an amended version of the original GetCustProfileCCDep() function,
// which calls the new GetCustProfileCCDepEx() function passing a blank Job
// CC/Dept array. It should only be used where Job Costing is not relevant.
var
  JobCCDept: CCDepType;
Begin
  Blank(JobCCDept, SizeOf(JobCCDept));
  Result := GetCustProfileCCDepEx(CustCC, CustDep, InpCCDep, JobCCDept, ProtectInp);
end;



Function GetProfileMLoc(CustLoc,
                        StkLoc,
                        InpLoc          :  Str5;
                        ProtectInp      :  Byte)  :  Str5;

Begin
  Result:=InpLoc;

  With UserProfile^ do
  Begin
    Case LocRule of
      1 :  Begin {Stock, Account, Opo}
              If (ProtectInp=1) then
              Begin
                If (EmptyKey(Result,MLocKeyLen)) then
                  Result:=StkLoc;

              end
              else
              Begin
                Result:=StkLoc;
              end;


              If (EmptyKey(Result,MLocKeyLen)) then
                Result:=CustLoc;

              If (EmptyKey(Result,MLocKeyLen)) then
                Result:=Loc;
            end;
      
      2  :  Begin {Opo, Account, Stock }
              If (ProtectInp=1) then
              Begin
                If (EmptyKey(Result,MLocKeyLen)) then
                  Result:=Loc;
              end
              else
              Begin
                Result:=Loc;
              end;

              If (EmptyKey(Result,MLocKeyLen)) then
                Result:=CustLoc;

              If (EmptyKey(Result,MLocKeyLen)) then
                Result:=StkLoc;

            end;

      3  :  Begin {Opo, Stock, Account }
              If (ProtectInp=1) then
              Begin
                If (EmptyKey(Result,MLocKeyLen)) then
                  Result:=Loc;
              end
              else
              Begin
                Result:=Loc;
              end;


              If (EmptyKey(Result,MLocKeyLen)) then
                Result:=StkLoc;

              If (EmptyKey(Result,MLocKeyLen)) then
                Result:=CustLoc;

            end;

      else  Begin {Account, Stock, Opo}
              If (ProtectInp=1) then
              Begin
                If (EmptyKey(Result,MLocKeyLen)) then
                  Result:=CustLoc;
              end
              else
              Begin
                Result:=CustLoc;
              end;

              If (EmptyKey(Result,MLocKeyLen)) then
                Result:=StkLoc;

              If (EmptyKey(Result,MLocKeyLen)) then
                Result:=Loc;
            end;

    end; {Case..}


  end; {With..}
end;


Function GetCustProfileMLoc(CustLoc,InpLoc :  Str5;
                            ProtectInp     :  Byte)  :  Str5;
Var
  StkLoc  :  Str5;

Begin
  Blank(StkLoc,Sizeof(StkLoc));

  Result:=GetProfileMLoc(CustLoc,StkLoc,InpLoc,ProtectInp);
end;


Function GetProfileBank(IsCust  :  Boolean)  :  Longint;

Begin
  Result:=0;

  Case IsCust of
    BOff  :  With UserProfile^ do
               If (PurchBank<>0) then
                 Result:=PurchBank
               else
                 Result:=Syss.DefBankNom;
    BOn   :  With UserProfile^ do
               If (SalesBank<>0) then
                 Result:=SalesBank
               else
                 Result:=Syss.DefSRCBankNom;
  end; {Case..}


end;


Function GetProfilePrinter(FormMode  :  Boolean)  :  Str255;

Begin
  Result:='';

  {$B-}
  With UserProfile^ do
  Case FormMode of
    BOn  :  Begin
              If (Not Loaded) or (FormPrn='') or (ExtractWords(2,1,FormPrn)='Enterprise') then
                Result:=SyssVAT.VATRates.FormsPrnN
              else
                Result:=FormPrn;
            end;
    else    Begin
              If (Not Loaded) or (ReportPrn='')  or (ExtractWords(2,1,ReportPrn)='Enterprise') then
                Result:=SyssVAT.VATRates.ReportPrnN
              else
                Result:=ReportPrn;
            end;
  end; {Case..}
  {$B+}
end;

//GS 01/06/2011 ABSEXCH-11376: added a routine for incrementing the password expiry date in
//a users 'Defaults Record', increments the stored expiry date by the 'password expires every x days' value
Procedure SetPasswordExpDate(var ADefaultsRec: tPassDefType);
var
  IncValue: Integer;
  PWExpiryDate: TDateTime;
  NewExpiryDateString: String;
begin
  //if the users 'password mode' is set to 'expire after 'x' number of days'..
  if ADefaultsRec.PWExpMode = 1 then
  begin
    //get todays date
    PWExpiryDate := SysUtils.Date;
    //Increment the date by the 'password expiry interval' value
    PWExpiryDate := IncDay(PWExpiryDate, ADefaultsRec.PWExPDays);
    //format the new date; the record requres the date to be in the string format: YYYYMMDD
    NewExpiryDateString := FormatDateTime('YYYYMMDD', PWExpiryDate);

    //compare our new date to the origional date, is it higher?
    //if so, overwrite the origional date
    if AnsiCompareStr(NewExpiryDateString, ADefaultsRec.PWExpDate) > 0 then
    begin
      ADefaultsRec.PWExpDate := NewExpiryDateString;
    end;
  end;
end;

//GS 01/06/2011 ABSEXCH-11376: added a routine for incrementing the password expiry date;
//this overloaded version is aimed at providing incremented dates
//in a format thats suitable for TEditDate controls (pass the YYYYMMDD value from the objects DateValue property!)
Function  IncPasswordExpDate(Const AIncValue: Integer; Const ACurrentExpiryDate: String): String;
var
  PWExpiryDate: TDateTime;
  NewExpiryDateString: String;
begin
  //get todays date
  PWExpiryDate := SysUtils.Date;
  //increment the TDateTime by the given number of days
  PWExpiryDate := IncDay(PWExpiryDate, AIncValue);
  //format the new date as a string type, with the format YYYYMMDD
  NewExpiryDateString := FormatDateTime('YYYYMMDD', PWExpiryDate);

  //compare our new date to the origional date, is it higher?
  //if so, return the new date
  if AnsiCompareStr(NewExpiryDateString, ACurrentExpiryDate) > 0 then
    Result := NewExpiryDateString
  else
    Result := ACurrentExpiryDate;
end;

end.

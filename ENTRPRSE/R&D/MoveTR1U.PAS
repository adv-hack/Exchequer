unit MoveTR1U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, bkgroup, SBSPanel,
  GlobVar,VarConst,ExWrap1U,BTSupU1,CmpCtrlU,SupListU;


type
  TMoveLineType = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    SBSBackGroup1: TSBSBackGroup;
    Label81: Label8;
    SCDescF: Text8Pt;
    NNumF: Text8Pt;
    Label82: Label8;
    ToF: Text8Pt;
    MDescF: Text8Pt;
    NITF: TSBSComboBox;
    Label83: Label8;
    Label84: Label8;
    Label85: Label8;
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
    procedure SCDescFExit(Sender: TObject);
  private
    IdStored,
    StopPageChange,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;

    LastCount    :  IncrementRec;



    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildDesign;


    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    Procedure OutId;

    procedure Form2Id;

    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

    procedure Get_GL(Sender: TObject);

    {$IFDEF STK}
      procedure Get_Stock(Sender: TObject);
    {$ENDIF}  

    procedure SetHelpContextIDs; // NF: 22/06/06

  public
    { Public declarations }

    RListMode  :  Byte;

    ExLocal    :  TdExLocal;

    procedure FormDesign;

    Procedure Self_NomGroup(CatCode,
                            NewCat    :  LongInt;
                        Var FoundOk   :  Boolean;
                            Fnum,
                            Keypath   :  Integer);

    Function In_PandL(GLCat  :  LongInt)  :  Boolean;

    Function NomGood_Type2(OTyp  :  Char;
                           GLCat :  LongInt)  :  Boolean;


    Function NomGood_Type(OTyp  :  Char;
                          Change:  Boolean)  :  Boolean;

    {$IFDEF STK}
      Procedure Self_StkGroup(CatCode,
                              NewCat    :  Str20;
                          Var FoundOk   :  Boolean;
                              Fnum,
                              Keypath   :  Integer);
    {$ENDIF}

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSPanel) ;


    procedure EditLine(Edit       :  Boolean;
                       MMode      :  Byte);

    procedure DeleteBOMLine(Fnum,
                            KeyPath  :  Integer);

  end;


  Function MNSubCode(Opt  :  Byte)  :  Char;


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
  GenWarnU,
  SysU1,
  MoveTL1U,
  InvListU,
  NomRecU,
  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  ThemeFix,

  {PayLineU,}
  Saltxl1U;




{$R *.DFM}


Function MNSubCode(Opt  :  Byte)  :  Char;

Begin
  If (Opt=2) then
    Result:=MoveStkSCode
  else
    Result:=MoveNomSCode;

end;


{ ========== Build runtime view ======== }

procedure TMoveLineType.BuildDesign;


begin
  If (RListMode=2) then
  Begin
    Label81.Caption:='Stock Code';
    Label84.Caption:='New Code';
    Label82.Caption:='Move From';
    Label85.Caption:='Move To';

    Label83.Visible:=BOff;
    NITF.Visible:=BOff;

    With SCDescF do
    Begin
      color:=clWhite;
      Font.Color:=clNavy;
      Tag:=1;
      ReadOnly:=BOff;
      TabStop:=True;

    end;

    With MDescF do
    Begin
      color:=clWhite;
      Font.Color:=clNavy;
      Tag:=1;
      ReadOnly:=BOff;
      TabStop:=True;

    end;

    With ToF do
    Begin
      color:=clBtnFace;
      Font.Color:=clBlack;
      Tag:=0;
      ReadOnly:=BOn;
      TabStop:=BOff;

    end;


  end;

end;


procedure TMoveLineType.FormDesign;


begin


  BuildDesign;

end;


procedure TMoveLineType.FormCreate(Sender: TObject);
begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  ClientHeight:=191;
  ClientWidth:=297;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TMoveLTList) then
    With TMoveLTList(Owner) do
    Begin
      Self.SetFieldProperties(PYNPanel);
    end;

  Set_DefaultNomT(NITF.Items,BOn);

  With NITF.ITems do
    Delete(Pred(Count));


  {FormDesign;}

  {SetFieldFocus;}

  SetHelpContextIDs; // NF: 22/06/06 Fix for incorrect Context IDs

end;




procedure TMoveLineType.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,102);

end;

procedure TMoveLineType.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TMoveLineType.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TMoveLineType.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TMoveLineType.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


{ == Procedure to Send Message to Get Record == }

Procedure TMoveLineType.Send_UpdateList(Edit   :  Boolean;
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



Function TMoveLineType.CheckNeedStore  :  Boolean;

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


Procedure TMoveLineType.SetFieldFocus;

Begin
  If (NNumF.CanFocus) then
    NNumF.SetFocus;

end; {Proc..}




Function TMoveLineType.ConfirmQuit  :  Boolean;

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
                StoreId(PWrdF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(PWrdF,LastRecAddr[MiscF]);

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

Procedure TMoveLineType.OutId;


Var
  FoundLong :  LongInt;
  DocHed    :  DocTypes;

  GenStr    :  Str255;


Begin
  With ExLocal,LPassword do
  Begin
    Case RListMode of
      1  :  With MoveNomRec do
            Begin
              NNumF.Text:=Form_BInt(MoveCode,0);
              ToF.Text:=Form_BInt(MoveTo,0);
              NITF.ItemIndex:=Ntype2List(MoveType);

              If (MoveCode<>0) then
              Begin
                If GetNom(Self,Form_Int(MoveCode,0), FoundLong,-1) then
                Begin
                  SCDescF.Text:=Nom.Desc;
                  AssignFromGlobal(NomF);
                end
                else
                  SCDescF.Text:='G/L Code not found!';
              end;

              If (MoveTo<>0) then
              Begin
                If GetNom(Self,Form_Int(MoveTo,0), FoundLong,-1) then
                  MDescF.Text:=Nom.Desc
                else
                  MDescF.Text:='G/L Code not found!';
              end;
            end;

      2  :  With MoveStkRec do
            Begin
              NNumF.Text:=MoveCode;
              SCDescF.Text:=NewStkCode;
              ToF.Text:=MFromCode;
              MDescF.Text:=MToCode;
            end;

    end; {Case..}

  end;

end;


procedure TMoveLineType.Form2Id;

  
Begin

  With EXLocal,LPassword do
  Begin
    Case RListMode of
      1  :  With MoveNomRec do
            Begin
              MoveCode:=IntStr(NNumF.Text);
              MoveTo:=IntStr(ToF.Text);
              MoveType:=List2NType(NITF.ItemIndex);

              

            end;

      2  :  With MoveStkRec do
            Begin
              MoveCode:=NNumF.Text;
              NewStkCode:=SCDescF.Text;

              MFromCode:=ToF.Text;

              MToCode:=MDescF.Text;
            end;

    end; {Case..}

  end; {with..}

end; {Proc..}





(*  Add is used to add Notes *)

procedure TMoveLineType.ProcessId(Fnum,
                                  Keypath     :  Integer;
                                  Edit        :  Boolean);

Var
  KeyS   :  Str255;
  NCount :  LongInt;

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
  With ExLocal, LPassword do
  begin

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      RecPfix:=MoveNomTCode;

      SubType:=MNSubCode(RListMode);

      Case RListMode of
        1  :  With MoveNomRec do
              Begin

              end;
        2  :  With MoveStkRec do
              Begin


              end;

      end; {Case..}


    end;


    OutId;

  end {If Abort..}
  else
    Close;

end; {Proc..}



{ ===== Procedure to Scan Tree and Check for Move to header within header ===== }

Procedure TMoveLineType.Self_NomGroup(CatCode,
                                      NewCat    :  LongInt;
                                  Var FoundOk   :  Boolean;
                                      Fnum,
                                      Keypath   :  Integer);



Var
  KeyChk,
  KeyS     :  Str255;

  RecAddr  :  LongInt;

  LNom     :  NominalRec;



Begin

  LNom:=Nom;

  FoundOk:=((CatCode<>NewCat) and (FoundOk));

  If (FoundOk) then
  Begin
    KeyS:=FullNomKey(CatCode);

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (FoundOk) do
    With Nom do
    Begin

      FoundOk:=(NomCode<>NewCat);

      If (FoundOk) and (Cat<>0) then
      Begin

        KeyS:=FullNomKey(Cat);

        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end
      else
        If (Cat=0) then
          Status:=9;


    end; {While..}
  end;

  Nom:=LNom;

end; {Proc..}


{ ==== Procedure to check if nom is being added into tha P&L section ==== }

  Function TMoveLineType.In_PandL(GLCat  :  LongInt)  :  Boolean;

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



  Function TMoveLineType.NomGood_Type2(OTyp  :  Char;
                                       GLCat :  LongInt)  :  Boolean;


Begin

  {$B-}

  NomGood_Type2:=((OTyp In [NomHedCode,CarryFlg]))
                 or (SBSIN)

                     or ((OTyp<>PLNHCode) and (Not In_PandL(GLCat)))
                     or ((OTyp=PLNHCode) and (In_PandL(GLCat)));


  {$B+}

end;


{ ======= Function to Determine if a nominal code type change is acceptable ===== }

Function TMoveLineType.NomGood_Type(OTyp  :  Char;
                                    Change:  Boolean)  :  Boolean;


Begin

  NomGood_Type:=((Change) or (Not (OTyp In [NomHedCode,CarryFlg])));

end;



{$IFDEF STK}


  { ===== Procedure to Scan Tree and Check for Move to header within header ===== }

  Procedure TMoveLineType.Self_StkGroup(CatCode,
                                        NewCat    :  Str20;
                                    Var FoundOk   :  Boolean;
                                        Fnum,
                                        Keypath   :  Integer);



  Var
    KeyS     :  Str255;

    LStk     :  StockRec;



  Begin

    LStk:=Stock;

    FoundOk:=((CatCode<>NewCat) and (FoundOk));
    {SS 24/05/2016 2016-R2 	
    ABSEXCH-2439:Moving a Folder.Customer managed to enter a move of a folder to
                 itself, using the Move List. Within stock this should NOT be possible.
    - Moving Folder and Moving Stock should not be same.}
    FoundOk:=(LStk.StockCode<>NewCat)  and (FoundOk);

    If (FoundOk) then
    Begin
      KeyS:=FullStockCode(CatCode);

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (FoundOk) do
      With Stock do
      Begin

        FoundOk:=(StockCode<>NewCat);

        If (FoundOk) and (Not EmptyKey(StockCat,StkKeyLen)) then
        Begin

          KeyS:=FullStockCode(StockCat);

          Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        end
        else
          If (EmptyKey(StockCat,StkKeyLen)) then
            Status:=9;


      end; {While..}
    end;
                 
    Stock:=LStk;

  end; {Proc..}

{$ENDIF}


Function TMoveLineType.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  4;


Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  KeyS     :  Str255;

  Test     :  Byte;

  LNum     :  LongInt;

  FoundCode:  Str20;

  CanChange,
  Loop,
  ShowMsg  :  Boolean;

  mbRet    :  Word;

  DocHed   :  DocTypes;


Begin
  New(PossMsg);


  LNum:=0;

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='A G/L code cannot be moved inside itself!';
  PossMsg^[2]:='That G/L type is not valid!';
  PossMsg^[3]:='A Stock code cannot be moved inside itself!';
  PossMsg^[4]:='That Stock Code is not valid!';



  Loop:=BOff;

  Test:=1;

  Result:=BOn;

  CanChange:=BOff;

  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LPassword do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  With MoveNomRec do
            Begin

              Result:=(RListMode=2);

              {$B-}

              If (Not Result) then
                Result:=(MoveTo=MoveFrom);

              If (Not Result) then
              {$B+}
              Begin
                If (MoveTo<>0) then
                  Result:=Global_GetMainRec(NomF,FullNomKey(MoveTo))
                else
                Begin
                  Blank(Nom,Sizeof(Nom));
                  Result:=BOn;
                end;

                If (Result) then
                  Self_NomGroup(Nom.Cat,MoveCode,Result,NomF,NomCodeK);
              end;

            end;

      2  :  With MoveNomRec do
            Begin

              Result:=(RListMode=2);

              If (Not Result) then
              Begin
                Result:=(LNom.NomType=MoveType);

                If (Not Result) then
                Begin
                  CanChange:=Ok2DelNom(0,LNom);

                  Result:=NomGood_Type(MoveType,CanChange);

                  If (Result) then {* Check it is valid within the heading it is in *}
                    Result:=NomGood_Type2(MoveType,LNom.CAT);
                end;


              end;

            end;
     {$IFDEF STK}
      3  :  With MoveStkRec do
            Begin

              Result:=(RListMode=1);

              If (Not Result) then
              Begin
                {$B-}

                 If (Not Result) then
                   Result:=(MToCode=MFromCode);

                 If (Not Result) then
                 {$B+}
                 Begin
                   If (MToCode<>'') then
                     Result:=Global_GetMainRec(StockF,FullStockCode(MToCode))
                   else
                   Begin
                     Blank(Stock,Sizeof(Stock));
                     Result:=BOn;
                   end;

                   If (Result) then
                     Self_StkGroup(Stock.StockCat,MoveCode,Result,StockF,StkCodeK);
                 end;

              end;

            end;
      4  :  With MoveStkRec do
            Begin

              Result:=(RListMode=1);

              If (Not Result) then
              Begin
                Result:=(EmptyKey(Trim(NewStkCode),StkKeyLen) or (Not CheckExsists(NewStkCode,StockF,StkCodeK)));
              end;

            end;

      {$ENDIF}
    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}



procedure TMoveLineType.StoreId(Fnum,
                          Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpPWrd
       :  PasswordRec;

  KeyS :  Str255;

  mbRet:  Word;




Begin
  KeyS:='';

  Form2Id;


  With ExLocal,LPassword do
  Begin
    COk:=CheckCompleted(LastEdit,BOff);



    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      Case RListMode of
        1  :  With MoveNomRec do
              Begin
                MNomCode:=SetPadNo(Form_Int(MoveCode,0),10);
              end;
        2  :  With MoveStkRec do
              Begin
                MStkCode:=MoveCode;
              end;

      end; {Case..}

      If (LastEdit) then
      Begin

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpPWrd:=LPassword;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LPassword:=TmpPWrd;

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


procedure TMoveLineType.SetFieldProperties(Field  :  TSBSPanel) ;

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


procedure TMoveLineType.EditLine(Edit       :  Boolean;
                             MMode      :  Byte);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    ProcessId(PWrdF,PWK,LastEdit);
  end;
end;


procedure TMoveLineType.CanCP1BtnClick(Sender: TObject);
begin
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


procedure TMoveLineType.NNumFEnter(Sender: TObject);
begin
  If (JustCreated) then
  Begin
    JustCreated:=BOff;
    {PostMessage(Handle,wm_NextDlgCtl,1,0);
    PostMessage(Handle,wm_NextDlgCtl,0,0);}
  end;

end;


procedure TMoveLineType.DeleteBOMLine(Fnum,
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

          Send_UpdateList(BOff,17);


        end;
      end; {If line is valid for deletion..}
    end;
  end; {With..}

  Close;
end; {PRoc..}





procedure TMoveLineType.Get_GL(Sender: TObject);

Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  FoundLong  :  LongInt;


begin
  FoundLong:=0;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) and (ExLocal.InAddEdit) and (Not ReadOnly) then
    Begin

      StillEdit:=BOn;

      If ((FoundCode<>'') or (Sender<>ToF)) then
        FoundOk:=(GetNom(Self.Owner,FoundCode,FoundLong,(1*Ord(Sender=ToF)+(99*Ord(Sender=NNumF)))))
      else
      Begin
        Blank(Nom,Sizeof(Nom));
        FoundOk:=BOn;
      end;


      If (FoundOk) and (Sender=ToF) then
      Begin
        Form2Id;

        With ExLocal.LPassword.MoveNomRec do
          FoundOk:=(MoveFrom=MoveTo);

        If (Not FoundOk) then
        Begin
          FoundOk:=BOn;

          Self_NomGroup(Nom.Cat,ExLocal.LPassword.MoveNomRec.MoveCode,FoundOk,NomF,NomCodeK);

          If (Not FoundOk) then
          Begin
            CustomDlg(Application.MainForm,'Invalid G/L Move','Invalid G/L Move',
                                   'A G/L Code cannot be moved inside itself!',
                                   mtWarning,
                                   [mbOK]);

          end;
        end;
      end;



      If (FoundOk) then
      Begin

        Text:=Form_Int(FoundLong,0);


        If (Sender=NNumF) then
        Begin
          ToF.Text:=Form_BInt(Nom.Cat,0);
          ExLocal.LPassword.MoveNomRec.MoveFrom:=Nom.Cat;
          NITF.ItemIndex:=Ntype2List(Nom.NomType);

          Form2Id;
          OutId;
        end
        else
          MDescF.Text:=Nom.Desc;


      end
      else
      Begin
        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;


{$IFDEF STK}
  procedure TMoveLineType.Get_Stock(Sender: TObject);


  Var
    FoundCode  :  Str20;

    FoundOk,
    AltMod     :  Boolean;


  begin

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) or ((FoundCode='') and (Sender=NNumF))) and (ActiveControl<>CanCP1Btn) then
      Begin

        StillEdit:=BOn;


        If ((FoundCode<>'') or (Sender<>MDescF)) then
          FoundOk:=(GetStock(Self.Owner,FoundCode,FoundCode,(1*Ord(Sender=MDescF)+(99*Ord(Sender=NNumF)))))
        else
        Begin
          Blank(Stock,Sizeof(Stock));
          FoundOk:=BOn;
        end;


        If (FoundOk) then
        Begin
          If (Sender=MDescF) then
          Begin
            Form2Id;

            With ExLocal.LPassword.MoveStkRec do
              FoundOk:=(MFromCode=MToCode);

            If (Not FoundOk) then
            Begin
              FoundOk:=BOn;

              Self_StkGroup(Stock.StockCat,ExLocal.LPassword.MoveStkRec.MoveCode,FoundOk,StockF,StkCodeK);

              If (Not FoundOk) then
              Begin
                CustomDlg(Application.MainForm,'Invalid Stock Move','Invalid Stock Move',
                                       'A Stock Code cannot be moved inside itself!',
                                       mtWarning,
                                       [mbOK]);

              end;
            end;

          end;

        end;

        If (FoundOk) then
        Begin

          StillEdit:=BOff;

          Text:=FoundCode;

          If (Sender=NNumF) then
          Begin
            ToF.Text:=Trim(Stock.StockCat);
            MDescF.Text:=ToF.Text;

            ExLocal.LPassword.MoveStkRec.MFromCode:=Stock.StockCat;

            Form2Id;
            OutId;
          end;
        end
        else
        Begin

          SetFocus;
        end; {If not found..}
      end;


    end; {with..}
  end;
{$ENDIF}


procedure TMoveLineType.NNumFExit(Sender: TObject);
begin
  Case RListMode of
    1  :  Get_GL(Sender);
   {$IFDEF STK}
    2  :  Get_Stock(Sender);
   {$ENDIF} 
  end; {Case..}
end;

procedure TMoveLineType.SCDescFExit(Sender: TObject);

Var
  FoundOk    :  Boolean;
  FoundCode  :  Str20;

begin
  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>CanCP1Btn) then
    Begin
      //HV 19/05/2016 2016-R2 ABSEXCH-15963 - Stock move list does not let store stock name as shorter name of itself.
      FoundCode := UpCaseStr(FullStockCode(FoundCode));
      FoundOk:=not CheckExsists(FoundCode,StockF,StkCodeK,B_GetEq);

      If (Not FoundOk) then
      Begin
        CustomDlg(Application.MainForm,'Duplicate Stock Code','Invalid Stock Code',
                                     'That Stock Code already exists!',
                                     mtWarning,
                                     [mbOK]);

        SetFocus;
      end
      else
        Text:=FoundCode;
    end;
  end;
end;

procedure TMoveLineType.SetHelpContextIDs;
// NF: 22/06/06
begin
  // Fix incorrect IDs
  HelpContext := 1888;
  NNumF.HelpContext := 1889;
  SCDescF.HelpContext := 1890;
  ToF.HelpContext := 1891;
  MDescF.HelpContext := 1892;
  NITF.HelpContext := 1893;
end;


end.

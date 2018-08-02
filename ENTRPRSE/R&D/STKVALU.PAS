unit StkValU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel,

  GlobVar,VarConst,ExWrap1U,CmpCtrlU;


type
  TStkValEdit = class(TForm)
    SBSPanel1: TSBSPanel;
    VDF: TEditDate;
    VOF: Text8Pt;
    VAcF: Text8Pt;
    VQF: TCurrencyEdit;
    VQIF: TCurrencyEdit;
    VCurrF: TSBSComboBox;
    VUCF: TCurrencyEdit;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    Label84: Label8;
    Label85: Label8;
    CurrLab: Label8;
    Label87: Label8;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    LocLab: Label8;
    SVLocnF: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure VAcFExit(Sender: TObject);
    procedure SVLocnFExit(Sender: TObject);
  private
    IdStored,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;


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

    Function IsADJ  :  Boolean;

    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);


    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

    procedure SetHelpContextIDs; // NF: 22/06/06

  public
    { Public declarations }

    StockR     :  StockRec;

    ExLocal    :  TdExLocal;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;


    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSPanel) ;


    procedure EditLine(RStock     :  StockRec;
                       Edit,
                       VO         :  Boolean);

    procedure DeleteBOMLine(Fnum,
                            KeyPath  :  Integer;
                            RStock   :  StockRec);

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
  BTSupU1,
  BTSupU2,
  SBSComp2,
  VARRec2U,
  CurrncyU,
  ComnUnit,
  ComnU2,


  ColCtrlU,

  SysU2,

  StockU,
  PWarnU,
  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}
  PayF2U,

  {PayLineU,}

  Saltxl1U;




{$R *.DFM}



{ ========== Build runtime view ======== }

procedure TStkValEdit.BuildDesign;


begin


end;


procedure TStkValEdit.FormDesign;

Var
  HideCC  :  Boolean;
  UseDec  :  Byte;

begin

  VUCF.DecPlaces:=Syss.NoCosDec;
  VQF.DecPlaces:=Syss.NoQtyDec;
  VQIF.DecPlaces:=Syss.NoQtyDec;

  {$IFDEF MC_On}
    Set_DefaultCurr(VCurrF.Items,BOff,BOff);
    Set_DefaultCurr(VCurrF.ItemsL,BOff,BOn);
  {$ELSE}
    VCurrF.Visible:=BOff;
    CurrLab.Visible:=BOff;
  {$ENDIF}

  {$IFNDEF SOP}
    HideCC:=BOn;
  {$ELSE}
    HideCC:=Not Syss.UseMLoc;
  {$ENDIF}

  LocLab.Visible:=Not HideCC;
  SVLocnF.Visible:=Not HideCC;

  VOF.MaxLength:=DocKeyLen;

  BuildDesign;

end;




procedure TStkValEdit.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  ClientHeight:=154;
  ClientWidth:=359;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TStockRec) then
    With TStockRec(Owner) do
    Begin
      Self.SetFieldProperties(VOPanel);
    end;

  FormDesign;

  SetHelpContextIDs; // NF: 22/06/06 Fix for incorrect Context IDs
end;




procedure TStkValEdit.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,104);

end;

procedure TStkValEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TStkValEdit.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TStkValEdit.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TStkValEdit.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TStkValEdit.Send_UpdateList(Edit   :  Boolean;
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



Function TStkValEdit.CheckNeedStore  :  Boolean;

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


Procedure TStkValEdit.SetFieldFocus;

Begin
  If (VDF.CanFocus) then
    VDF.SetFocus;
end; {Proc..}




Function TStkValEdit.ConfirmQuit  :  Boolean;

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




{ ============== Display Id Record ============ }

Procedure TStkValEdit.OutId;

Const
  Fnum     =  StockF;
  Keypath  =  StkFolioK;

Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  KeyS      :  Str255;


Begin
  With ExLocal,LMiscRecs^.FIFORec do
  Begin
    VDF.DateValue:=FIFODate;
    VOF.Text:=DocRef;
    VAcF.Text:=FIFOCust;
    VQF.Value:=FIFOQty;
    VQIF.Value:=QtyLeft;

    {$IFDEF MC_On}
       If (FIFOCurr>0) then
         VCurrF.ItemIndex:=Pred(FIFOCurr);
    {$ENDIF}

    If (PChkAllowed_In(143)) then
      VUCF.Value:=FIFOCost;

    {$IFDEF SOP}
      SVLocnF.Text:=FIFOMLoc;

    {$ENDIF}

  end;

end;


procedure TStkValEdit.Form2Id;

Begin

  With EXLocal,LMiscRecs^.FIFORec do
  Begin
    FIFODate:=VDF.DateValue;
    DocRef:=VOF.Text;
    FIFOCust:=VAcF.Text;
    FIFOQty:=VQF.Value;
    QtyLeft:=VQIF.Value;


    {$IFDEF MC_On}
      If (VCurrF.ItemIndex>=0) then
        FIFOCurr:=Succ(VCurrF.ItemIndex);

      If (LastMisc^.FIFORec.FIFOCurr<>FIFOCurr) then
      Begin
        FIFOCRates:=SyssCurr^.Currencies[FIFOCurr].CRates;
        SetTriRec(FIFOCurr,FUseORate,FIFOTriR);
      end;
    {$ENDIF}

    If (PChkAllowed_In(143)) then
      FIFOCost:=VUCF.Value;

    {$IFDEF SOP}

      FIFOMLoc:=SVLocnF.Text;

    {$ENDIF}

  end; {with..}

end; {Proc..}





procedure TStkValEdit.SetIdStore(EnabFlag,
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


procedure TStkValEdit.SetCaption;


Begin
  With ExLocal,LMiscRecs^,FIFORec do
  Begin
    Caption:='Stock Value Entry for: '+DocRef;
  end;
end;

(*  Add is used to add Notes *)

procedure TStkValEdit.ProcessId(Fnum,
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

      SetCaption;

    end;

    If (Not Ok) or (Not GlobLocked) then
      AddCh:=Esc;
  end;


  If (Addch<>Esc) then
  With ExLocal,LMiscRecs^,FIFORec do
  begin

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      RecMfix:=MFIFOCode;
      SubType:=MFIFOSub;

      StkFolio:=StockR.StockFolio;

      FIFOCurr:=1;

      FIFODate:=Today;




    end;

    LastMisc^:=LMiscRecs^;

    OutId;

  end; {If Abort..}

  SetIdStore(BOn,ExLocal.LViewOnly);

end; {Proc..}


Function TStkValEdit.IsADJ  :  Boolean;

Begin
  With ExLocal, LMiscRecs^,FIFORec do
  Begin
    Result:=(Copy(DocRef,1,3)=DocCodes[ADJ]);
  end;
end;

Function TStkValEdit.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  2;
  Fnum         =  MiscF;
  Keypath      =  MIK;


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

  PossMsg^[1]:='That Account Code is not valid.';
  PossMsg^[2]:='Currency not Valid.';


  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal, LMiscRecs^,FIFORec do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              Result:=((GetCust(Self,FIFOCust,FoundCode,BOff,-1))
                      and (Not EmptyKey(FIFOCust,CustKeyLen))) or (IsADJ);
            end;

      {$IFDEF MC_On}

        2  :  Result:=(FIFOCurr In [Succ(CurStart)..CurrencyType]);
      {$ENDIF}

    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}




procedure TStkValEdit.StoreId(Fnum,
                            Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpMisc
       :  MiscRec;

  KeyS :  Str255;




Begin
  KeyS:='';

  Form2Id;


  With ExLocal,LMiscRecs^,FIFORec do
  Begin

    COk:=CheckCompleted(LastEdit,BOff);


    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      FIFOCode:=MakeFIKey(StkFolio,FIFODate);

      DocFolioK:=MakeFIDocKey(DocRef,StkFolio,DocABSNo);

      If (LastEdit) then
      Begin

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

        SetCaption;
      end;

      Report_BError(Fnum,Status);


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


procedure TStkValEdit.SetFieldProperties(Field  :  TSBSPanel) ;

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


procedure TStkValEdit.EditLine(RStock     :  StockRec;
                             Edit,
                             VO         :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    LViewOnly:=VO;

    StockR:=RStock;

    AssignFromGlobal(MiscF);

    ProcessId(MiscF,MIK,LastEdit);
  end;
end;



procedure TStkValEdit.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
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


procedure TStkValEdit.DeleteBOMLine(Fnum,
                                KeyPath  :  Integer;
                                RStock   :  StockRec);

Var
  MbRet  :  Word;
  GotRec :  Integer;
  KeyS   :  Str255;

Begin
  With ExLocal do
  Begin
    StockR:=RStock;
    AssignFromGlobal(Fnum);
    LGetRecAddr(Fnum);
    OutId;
    OKCP1Btn.Enabled:=BOff;
    CanCP1Btn.Enabled:=BOff;

    MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Line',
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
          Send_UpdateList(BOff,19);


      end; {If line is valid for deletion..}
    end
    else
      Report_BError(Fnum,Status);
  end; {With..}

  Close;
end; {PRoc..}







procedure TStkValEdit.VAcFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  BalNow     :  Double;

begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn)  and (Not IsADJ) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetCust(Self.Owner,FoundCode,FoundCode,BOff,99));

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin

        AssignFromGlobal(CustF);


      end;


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
end;



procedure TStkValEdit.SVLocnFExit(Sender: TObject);
Var
  FoundCode  :  Str10;

  FoundOk,
  AltMod     :  Boolean;

  BalNow     :  Double;

begin
  {$IFDEF SOP}
  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn)  then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetMLoc(Self.Owner,FoundCode,FoundCode,'',0));

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin

        AssignFromGlobal(MLocF);


      end;


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

procedure TStkValEdit.SetHelpContextIDs;
// NF: 22/06/06
begin
  // Fix incorrect IDs
  HelpContext := 1871;
  VDF.HelpContext := 1872;
  VOF.HelpContext := 1873;
  VAcF.HelpContext := 1874;
  SVLocnF.HelpContext := 1875;
  VQF.HelpContext := 1876;
  VQIF.HelpContext := 1877;
  VCurrF.HelpContext := 1878;
  VUCF.HelpContext := 1879;
end;





Initialization


end.

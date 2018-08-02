unit ObjCISMU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, SBSOutl,  ExWrap1U, Menus,
  GlobVar,VarConst,BTSupU1,Tranl1U,


  SalTxl1U, TEditVal, ExtCtrls, SBSPanel;


type
  TObjCFrm = class(TForm)
    ODOLine: TSBSOutlineB;
    ClsI1Btn: TButton;
    PopupMenu1: TPopupMenu;
    Expand1: TMenuItem;
    MIETL: TMenuItem;
    MIEAL: TMenuItem;
    MIColl: TMenuItem;
    MICTL: TMenuItem;
    EntireGeneralLedger2: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N3: TMenuItem;
    UnAl1Btn: TButton;
    Print1Btn: TButton;
    ShowMatch1: TMenuItem;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure ClsI1BtnClick(Sender: TObject);
    procedure Expand1Click(Sender: TObject);
    procedure ODOLineExpand(Sender: TObject; Index: Longint);
    procedure FormDestroy(Sender: TObject);
    procedure Print1BtnClick(Sender: TObject);
    procedure UnAl1BtnClick(Sender: TObject);
    procedure ShowMatch1Click(Sender: TObject);
  private
    { Private declarations }
    StoreCoord,
    LastCoord,
    SetDefault,
    StillInNeedData,
    ClsViaBtn,
    GotCoord,
    WithMatchOn  :   Boolean;

    InitSize     :   TPoint;

    LODDMode     :   Byte;

    StateTit     :   Str30;

    ExLocal      :  TdExLocal;

    DispTrans    :  TFInvDisplay;

    MatchVoucher :  JobDetlRec;


    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    Procedure CreateParams(Var Params  :  TCreateParams); Override;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure SetFormProperties(SetList  :  Boolean);

    procedure DestroyNodes;

    Function BuildOLevel(Idx  :  Integer;
                         NTit :  Str80)  :  Integer;


    Procedure Build_Links(Idx  :  Integer;
                          BKey :  Str255);

    procedure BuildPayMatch(Idx   :  Integer);

    procedure BuildOMatch(Idx   :  Integer);

    procedure BuildOSCIS(Idx   :  Integer);

    procedure Display_Trans(Mode  :  Byte);


    Procedure ObjDrillLink(Idx  :  Integer);

  public
    { Public declarations }
    procedure BuildObjectDrill;

  end;


{ == Set obj mode == }

Procedure SetOCMMode(CM  :  Byte);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  VARRec2U,
  CurrncyU,
  Mask,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}
  IntMU,
  ComnUnit,
  CmpCtrlU,
  ColCtrlU,
  BtrvU2,

  OutLine,

  ComnU2,
  BtKeys1U,
  BtSupU2,
  SysU2,

  {LedgSupU,}
  GenWarnU,
  PWarnU,

  {$IFDEF LTR}
    Letters,
    LettrDlg,
  {$ENDIF}

  {$IFDEF RP}
    RepAlcU,
  {$ENDIF}

  JobSup1U,

  AllocS1U,
  JChkUseU,
  CISSup1U,
  InvListU;


{$R *.DFM}




Var
  WarnUnalloc  :  Boolean;
  OCMMode      :  Byte;



Procedure SetOCMMode(CM  :  Byte);
Begin
  OCMMode:=CM;

end;

procedure TObjCFrm.Find_FormCoord;


Var
  ThisForm:  TForm;

  VisibleRect
          :  TRect;

  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOn));

  ThisForm:=Self;

  With GlobComp^ do
  Begin

    GetValues:=BOn;

    PrimeKey:='C';

    If (GetbtControlCsm(ThisForm)) then
    Begin
      {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
      StoreCoord:=BOff;
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);

    end;

    If GetbtControlCsm(ODOLine) then
    Begin
      ODOLine.BarColor:=HLite;
      ODOLine.BarTextColor:=HTLite;
    end;


  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);


end;


procedure TObjCFrm.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='C';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    HLite:=ODOLine.BarColor;
    HTLite:=ODOLine.BarTextColor;

    StorebtControlCsm(ODOLine);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;


procedure TObjCFrm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=Not StillInNeedData;

  GenCanClose(Self,Sender,CanClose,BOn);

  If (CanClose) then
  Begin
  {* Inform parent closing *}

    Store_FormCoord(Not SetDefault);



    Send_UpdateList(179);

  end;

end;

procedure TObjCFrm.DestroyNodes;

Var
  n       : Integer;
  ONomRec :  ^ODDType;

Begin
  With ODOLine do {* Tidy up attached objects *}
  Begin
    For n:=1 to ItemCount do
    Begin
      ONomRec:=Items[n].Data;
      If (ONomRec<>nil) then
        Dispose(ONomRec);
    end;
  end; {With..}
end;




procedure TObjCFrm.FormClose(Sender: TObject; var Action: TCloseAction);


begin

  DestroyNodes;

  ExLocal.Destroy;

  Action:=caFree;

end;


Procedure TObjCFrm.CreateParams(Var Params  :  TCreateParams);
Begin
  Inherited CreateParams(Params);

  {Params.WndParent:=Application.Handle;}
end;

procedure TObjCFrm.FormCreate(Sender: TObject);

Begin
  LODDMode:=0;

  ExLocal.Create;

  WithMatchOn:=BOff;

  GotCoord:=BOff;

  DispTrans:=nil;

  If (OCMMode=2) then
  Begin
    FormStyle:=fsStayOnTop;
  end;

  ClientHeight:=289;
  ClientWidth:=258;

  InitSize.X:=ClientWidth; InitSize.Y:=ClientHeight;

  Find_FormCoord;

  StillInNeedData:=BOff;

  ClsViaBtn:=BOff;

  GotCoord:=BOn;

  If (CIS340) then
    StateTit:='Statement'
  else
   StateTit:=GetIntMsg(4);


  Caption:=CCCISName^+' '+StateTit+' Matched transactions';

  ShowMatch1.Visible:=BOn;

  BuildObjectDrill;

  FormReSize(Self);
end;


procedure TObjCFrm.FormDestroy(Sender: TObject);
begin
  {}
end;

procedure TObjCFrm.FormResize(Sender: TObject);
begin
  If (GotCoord) then
  Begin
    ODOLine.Width:=ClientWidth-1;
    ODOLine.Height:=ClientHeight-32;

    Print1Btn.Left:=Round((ClientWidth/2)-(Print1Btn.Width/2));
    ClsI1Btn.Top:=ClientHeight-30;

    If (OCMMode<>2) then
      ClsI1Btn.Left:=ClientWidth-86
    else
      ClsI1Btn.Left:=Print1Btn.Left;

    UnAl1Btn.Top:=ClsI1Btn.Top;
    Print1Btn.Top:=ClsI1Btn.Top;
    

  end;


end;

procedure TObjCFrm.PropFlgClick(Sender: TObject);
begin
  SetFormProperties(BOff);
end;

procedure TObjCFrm.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
end;

procedure TObjCFrm.PopupMenu1Popup(Sender: TObject);
begin
  StoreCoordFlg.Checked:=StoreCoord;
  ShowMatch1.Checked:=WithMatchOn;
end;


Procedure TObjCFrm.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

Begin

  With Message.MinMaxInfo^ do
  Begin

    ptMinTrackSize.X:=InitSize.X;
    ptMinTrackSize.Y:=InitSize.Y;

    {ptMaxSize.X:=530;
    ptMaxSize.Y:=368;
    ptMaxPosition.X:=1;
    ptMaxPosition.Y:=1;}

  end;

  Message.Result:=0;

  Inherited;

end;

Procedure TObjCFrm.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of

      0 :  ;


    end; {Case..}

  end;
  Inherited;
end;

Procedure TObjCFrm.WMCustGetRec(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of


      168  :  ODOLine.Items[LParam].FullExpand;

      169  : With ODOLine do
               Items[SelectedItem].Expand;

      200
           :  DispTrans:=nil;



    end; {Case..}

  end;
  Inherited;
end;


{ == Procedure to Send Message to Get Record == }

Procedure TObjCFrm.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_FormCloseMsg;
    WParam:=Mode;
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


procedure TObjCFrm.SetFormProperties(SetList  :  Boolean);


Var
  TmpPanel    :  Array[1..3] of TPanel;

  n           :  Byte;

  ResetDefaults,
  BeenChange  :  Boolean;
  ColourCtrl  :  TCtrlColor;

Begin
  ResetDefaults:=BOff;

  For n:=1 to 3 do
  Begin
    TmpPanel[n]:=TPanel.Create(Self);
  end;


  try

    With ODOLine do
    Begin
      TmpPanel[1].Font:=Font;
      TmpPanel[1].Color:=Color;

      TmpPanel[2].Font:=Font;
      TmpPanel[2].Color:=Color;


      TmpPanel[3].Color:=BarColor;
      TmpPanel[3].Font.Assign(TmpPanel[1].Font);
      TmpPanel[3].Font.Color:=BarTextColor;
    end;



    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,Self.Caption+' Properties',BeenChange,ResetDefaults);


        If (BeenChange) and (not ResetDefaults) then
        Begin

          With ODOLine do
          Begin
            Font.Assign(TmpPanel[1].Font);
            Color:=TmpPanel[1].Color;

            {NLDPanel.Font.Assign(TmpPanel[2].Font);
            NLDPanel.Color:=TmpPanel[2].Color;}


            BarColor:=TmpPanel[3].Color;
            BarTextColor:=TmpPanel[3].Font.Color;

            {NLCrPanel.Font.Assign(TmpPanel[2].Font);
            NLCrPanel.Color:=TmpPanel[2].Color;

            NLDrPanel.Font.Assign(TmpPanel[2].Font);
            NLDrPanel.Color:=TmpPanel[2].Color;}
          end;

        end;

      end;

    finally

      ColourCtrl.Free;

    end;

  Finally

    For n:=1 to 3 do
      TmpPanel[n].Free;

  end;

  If (ResetDefaults) then
  Begin
    SetDefault:=BOn;
    Close;
  end;

end;


procedure TObjCFrm.ClsI1BtnClick(Sender: TObject);
begin
  ClsViaBtn:=BOn;
  Close;
end;

procedure TObjCFrm.ODOLineExpand(Sender: TObject; Index: Longint);
begin
  With ODOLine do
    If (Not Items[Index].HasItems) then
    Begin
      ObjDrillLink(Index);
    end;
end;



{ ===== Build Node Lines ===== }

Function TObjCFrm.BuildOLevel(Idx  :  Integer;
                              NTit :  Str80)  :  Integer;

Var
  ODDRec    :  ^ODDType;

Begin
  With ODOLine do
  Begin
    New(ODDRec);

    FillChar(ODDRec^,Sizeof(ODDRec^),0);

    Result:=AddChildObject(Idx,NTit,ODDRec);

  end; {With..}

end;


Procedure TObjCFrm.Build_Links(Idx  :  Integer;
                               BKey :  Str255);

Const
  Fnum2     =  MiscF;
  Keypath2  =  MIK;


Var
  KeyS2,
  KeyChk2  :  Str255;

  n        :  Integer;

  ODDRec    :  ^ODDType;

  TmpStr   :  Str255;


Begin
  TmpStr:='';

  StillInNeedData:=BOn;

  ClsI1Btn.Enabled:=BOff;


  With ODOLine,ExLocal do
  Begin

    KeyChk2:=BKey;

    KeyS2:=KeyChk2;

    Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,KeyS2);

    While (StatusOk) and (CheckKey(KeyChk2,KeyS2,Length(KeyChk2),BOn)) do
    With ExLocal.LMiscRecs^ do
    Begin


      Application.ProcessMessages;


      TmpStr:='';

      New(ODDRec);

      FillChar(ODDRec^,Sizeof(ODDRec^),0);

      With ODDRec^ do
      Begin
        NFnum:=MiscF;

        NKey:=FullQDKey(RecMfix,SubType,btLinkRec.CustomKey);
        NKeyPath:=MIK;
        NMiscMode:=1;

      end;

      {$IFDEF LTR}

        If (btLinkRec.Version=DocWord95) then
        With btLetterRec do
          TmpStr:=DocTypeName(Version)+' : '+LtrDescr
        else
        With btLinkRec do
          TmpStr:=DocTypeName(Version)+' : '+LtrDescr;

      {$ELSE}
        TmpStr:='LTRS Off!';

      {$ENDIF}

      n:=AddChildObject(Idx,TmpStr,ODDRec);

      Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,KeyS2);
    end;

  end; {With..}

  StillInNeedData:=BOff;
  ClsI1Btn.Enabled:=BOn;

end;



procedure TObjCFrm.BuildPayMatch(Idx   :  Integer);

Const
  Fnum  =  PWrdF;

Var
  n,nIdx,ACnst,
  TmpStat,
  TmpKPath,
  Keypath
            :  Integer;

  TmpRecAddr
            :  LongInt;

  ODDRec    :  ^ODDType;

  KeyS,KeyChk
            :  Str255;
  NeedHed,
  GotJAP,
  GotWOR,
  Ok2Add    :  Boolean;

  Rnum      :  Real;
  OLine     :  Str255;


Begin
  With ODOLine,ExLocal,LInv do
  Begin
    TmpKPAth:=HelpNDXK;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    NeedHed:=BOn;  GotWOR:=BOff; Ok2Add:=BOn; nIdx:=Idx; GotJap:=BOff;

    If ((RemitNo<>'') or (OrdMatch) or (InvDocHed In [ADJ,TSH])) then
      Keypath:=PWK
    else
      Keypath:=HelpNDXK;

    KeyChk:=FullMatchKey(MatchTCode,MatchSCode,OurRef);
    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


    While (StatusOK) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
    With Password.MatchPayRec do
    Begin
      If (NeedHed) then
      Begin
        nIdx:=BuildOLevel(Idx,'Matching Information');

        NeedHed:=BOff;
      end;

      New(ODDRec);

      FillChar(ODDRec^,Sizeof(ODDRec^),0);

      Ok2Add:=BOn;

      With ODDRec^ do
      Begin
        NFnum:=InvF;
        NKeypath:=InvOurRefK;
        NMiscMode:=2;

        Case Keypath of
          PWK       :  Begin
                         NKey:=PayRef;
                         ACnst:=-1;
                       end;
          HelpNdxK  :  Begin
                         NKey:=DocCode;
                         ACnst:=1;
                       end;
        end; {Case..}

        Rnum:=OwnCVal*ACnst;
        OLine:=FormatCurFloat(GenRealMask,Rnum,BOff,MCurrency);



        If (Ok2Add) then
          n:=AddChildObject(nIdx,' '+NKey+'. '+OLine,ODDRec);

      end; {With..}


      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}
        
    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

  end; {With..}

end;



procedure TObjCFrm.BuildOMatch(Idx   :  Integer);

Const
  Fnum  =  PWrdF;

Var
  n,nIdx,ACnst,
  TmpStat,
  TmpKPath,
  Keypath
            :  Integer;

  TmpRecAddr
            :  LongInt;

  ODDRec    :  ^ODDType;

  KeyS,KeyChk
            :  Str255;
  NeedHed,
  GotLink,
  Ok2Add    :  Boolean;

  Rnum      :  Real;

  CrDr      :  DrCrType;

  OLine     :  Str255;


Begin
  StillInNeedData:=BOn;

  ClsI1Btn.Enabled:=BOff;

  With ODOLine,ExLocal,LJobDetl^.JobCISV do
  Begin

    NeedHed:=BOn;  GotLink:=BOff; Ok2Add:=BOn;

    Keypath:=HelpNDXK;

    TmpKPAth:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    KeyChk:=FullMatchKey(MatchTCode,MatchCCode,CISFolio);
    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


    While (StatusOK) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
    With Password.MatchPayRec do
    Begin

      New(ODDRec);

      FillChar(ODDRec^,Sizeof(ODDRec^),0);

      Ok2Add:=BOn;

      With ODDRec^ do
      Begin
        NFnum:=InvF;
        NKeypath:=InvOurRefK;

        Status:=GetPos(F[Fnum],Fnum,NRecAddr); {Store record address so we can delete individually during unallocation}

        Case Keypath of
          HelpNdxK  :  Begin
                         NKey:=DocCode;
                         ACnst:=1;
                       end;
        end; {Case..}


        NOurRef:=NKey;

        GotLink:= (CheckRecExsists(NOurRef,InvF,InvOurRefK));


        {$B-}
        If (GetDocType(Copy(Nkey,1,3)) In PurchSplit) then
        {$B+}
        Begin
          If (GotLink) then
            NValue:=SettledVal;

          Rnum:=NValue;

          OLine:=FormatCurFloat(GenRealMask,Rnum,BOff,Syss.VatCurr);

          {$IFDEF MC_On}
            If (GotLink) then
            Begin
              AssignFromGlobal(InvF);

              If (Inv.Currency<>Syss.VatCurr) and ((Syss.VATCurr<>0) or (Inv.Currency>1)) then
                OLine:=OLine+' / '+FormatCurFloat(GenRealMask,OwnCVal,BOff,Inv.Currency);


            end;

          {$ENDIF}


          n:=AddChildObject(Idx,' '+NKey+'. '+OLine,ODDRec);

          If (WithMatchOn) then
            BuildPayMatch(n);

        end
        else
          Dispose(ODDRec);



      end; {With..}


      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

    {$IFDEF LTR}

      If (AdbHasData(6,CISFolio)) then
      Begin
        New(ODDRec);

        FillChar(ODDRec^,Sizeof(ODDRec^),0);

        With ODDRec^ do
        Begin
          NFnum:=MiscF;
          NNeedData:=BOn;
          NKey:=FullQDKey(LetterTCode,LetterCISCode,CISFolio);
          NMiscMode:=1;
        end;

        n:=AddChildObject(Idx,'Links to additional information',ODDRec);

      end;
    {$ENDIF}


  end; {With..}

  StillInNeedData:=BOff;
  ClsI1Btn.Enabled:=BOn;

end;


procedure TObjCFrm.BuildOSCIS(Idx   :  Integer);

Const
  Fnum    =  InvF;
  Keypath =  InvCISK;

Var
  n,nIdx,ACnst,
  TmpStat,
  TmpKPath
            :  Integer;

  TmpRecAddr
            :  LongInt;

  ODDRec    :  ^ODDType;

  KeyS,KeyChk
            :  Str255;
  NeedHed,
  GotLink,
  Ok2Add    :  Boolean;

  VWorth,
  BWorth,
  MGross    :  Double;

  Rnum      :  Real;

  CrDr      :  DrCrType;

  OLine     :  Str255;

  TmpJD     :  JobDetlRec;
  EInv      :  InvRec;


Begin
  StillInNeedData:=BOn;

  ClsI1Btn.Enabled:=BOff;

  With ODOLine,ExLocal,LJobDetl^.JobCISV do
  Begin

    NeedHed:=BOn;  GotLink:=BOff; Ok2Add:=BOn;

    TmpKPAth:=GetPosKey;

    Blank(TmpJD,Sizeof(TmpJD)); VWorth:=0.0; BWorth:=0.0; MGross:=0.0;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    KeyChk:=Copy(CISVCode2,1,LDateKeyLen);

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);


    While (StatusOK) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
    With LInv do
    Begin
      If (CISEmpl=Copy(CISVCode1,1,EmplKeyLen)) and (CISDeclared<>CurrSettled) then
      Begin

        New(ODDRec);

        FillChar(ODDRec^,Sizeof(ODDRec^),0);

        Ok2Add:=BOn;

        With ODDRec^ do
        Begin
          NFnum:=InvF;
          NKeypath:=InvOurRefK;
          NKey:=OurRef;
          ACnst:=1;

          NOurRef:=NKey;

          EInv:=LInv;

          Update_CISVoucher(TmpJD,EInv,VWorth,MGross,BWorth,0);

          {$B-}
          If (GetDocType(Copy(Nkey,1,3)) In PurchSplit) then
          {$B+}
          Begin
            OLine:=FormatCurFloat(GenRealMask,BWorth*DocCnst[LInv.InvDocHed],BOff,Currency);


            n:=AddChildObject(Idx,' '+NKey+'. '+OLine,ODDRec);

            If (WithMatchOn) then
              BuildPayMatch(n);

          end
          else
            Dispose(ODDRec);



        end; {With..}
      end; {If matched this employee}

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

  end; {With..}

  StillInNeedData:=BOff;
  ClsI1Btn.Enabled:=BOn;

end;

procedure TObjCFrm.BuildObjectDrill;

Var
  n,Tmpn    :  Integer;
  ODDRec    :  ^ODDType;

  GenStr    :  Str255;

Begin
  With ODOLine,ExLocal,LJobDetl^.JobCISV do
  Begin
    AssignFromGlobal(JDetlF);

    MatchVoucher:=JobDetl^;

    If (OCMMode=1) then
    Begin
      Caption:='Allocate to '+StateTit;

      UnAl1Btn.Caption:='&Allocate';
    end
    else
      Caption:=StateTit+' Match';

    If (OCMMode=2) then {We are being called from Objectdrill}
    Begin
      UnAl1Btn.Visible:=BOff;
      Print1Btn.Visible:=BOff;
    end
    else
      UnAl1Btn.Visible:=(Copy(CISVCode2,1,LDateKeyLen)=SyssCIS^.CISRates.CurrPeriod);

    Caption:=Caption+' - '+MatchVoucher.JobCISV.CISCertNo;

    DestroyNodes;
    Clear;

    Begin
      New(ODDRec);

      FillChar(ODDRec^,Sizeof(ODDRec^),0);

      With ODDRec^ do
      Begin

        n:=AddChildObject(0,StateTit+' No. '+CISCertNo,ODDRec);

      end;

      Case OCMMode of
        1  :  BuildOSCIS(n);
        else  BuildOMatch(n);
      end; {Case..}

    end;



    FullExpand;

    If (ItemCount>1) then
      SelectedItem:=2;
  end; {With..}

end;


procedure TObjCFrm.Expand1Click(Sender: TObject);
begin
  If (Sender is TMenuItem) then
  With ODOLine do
  Begin
    Case TMenuItem(Sender).Tag of
      1  :  Items[SelectedItem].Expand;
      2  :  Items[SelectedItem].FullExpand;
      3  :  FullExpand;
      4  :  Items[SelectedItem].Collapse;
      5  :  FullCollapse;
    end; {case..}
  end;

end;


{ ======= Link to Trans display ======== }

procedure TObjCFrm.Display_Trans(Mode  :  Byte);

Begin

  ExLocal.LastInv:=ExLocal.LInv;

  ExLocal.AssignFromGlobal(InvF);

  If (DispTrans=nil) then
    DispTrans:=TFInvDisplay.Create(Self);

    try

      With ExLocal,DispTrans do
      Begin
        LastDocHed:=LInv.InvDocHed;

        Display_Trans(Mode,0,BOff,BOn);

      end; {with..}

    except

      DispTrans.Free;

    end;

  ExLocal.LInv:=ExLocal.LastInv;
end;



Procedure TObjCFrm.ObjDrillLink(Idx  :  Integer);

Var
  ODDRec  :  ^ODDType;

Begin
  ODDRec:=ODOLine.Items[Idx].Data;

  With ODDRec^ do
  Begin
    If (NNeedData) then
    Begin
      NNeedData:=BOff;

      Case NFnum of
        MiscF  :  Case NMiscMode of
                     1  :  Build_Links(Idx,ODDRec^.NKey);

                  end; {Case..}
      end;

    end
    else
    If (NFNum<>0) then
    Begin

      Status:=Find_Rec(B_GetEq,F[NFnum],NFnum,RecPtr[NFnum]^,NKeyPath,NKey);

      If (StatusOk) then
      Begin
        Case NFnum of
          InvF  :  With Inv do
                     If (Allowed_In(InvDocHed In (SalesSplit-OrderSet),03)) or
                        (Allowed_In(InvDocHed In (PurchSplit-OrderSet),12)) then
                           Display_Trans(99+(-97*Ord(LODDMode In[1,2])));

          MiscF  :  Case NMiscMode of


                     {$IFDEF LTR}
                       1  :  ExecLink(MiscRecs^);
                     {$ELSE}
                       1  :  ;
                     {$ENDIF}
                    end; {Case..}

        end;

      end; {If foundok..}
    end;
  end; {With..}


end; {PRoc..}



procedure TObjCFrm.Print1BtnClick(Sender: TObject);
Var
  IRepParam  :  MLocRec;
begin
  Blank(IRepParam,Sizeof(IRepParam));

  With IRepParam.AllocCRec,ExLocal,LJobDetl^.JobCISV do
  Begin
    arcCode1:=CISCertNo;
    arcAnalCode:=CISFolio;
    arcCustCode:=Copy(CISVSDate,1,CustKeyLen);

    {$IFDEF RP}
      AddAllocRep2Thread(15,IRepParam,ODOLine,Self);
    {$ENDIF}

  end;

end;

procedure TObjCFrm.UnAl1BtnClick(Sender: TObject);

Const
  Fnum    =  JDetlF;
  Keypath =  JDStkK;
  Fnum2   =  InvF;
  Keypath2=  InvOurRefK;
  Fnum3   =  PWrdF;
  Keypath3=  HelpNdxK;

Var
  LOK,LLocked,
  RecDel
          :  Boolean;

  mbret   :  Word;

  KeyS    :  Str255;

  VWorth,
  MGross,
  CWorth  :  Double;

  Idx     :  Integer;
  ODDRec  :  ^ODDType;


begin
  VWorth:=0.0; CWorth:=0.0;  RecDel:=BOff;  MGross:=0.0;

  With ODOLine do
  Begin

    If (SelectedItem>0) then {Ignore root}
    With ExLocal do
    Begin
      Idx:=SelectedItem;

      ODDRec:=ODOLine.Items[Idx].Data;

      With ODDRec^ do
      If (NFNum=InvF) and (NMiscMode =0) then
      Begin
        If (Not WarnUnalloc) and (OCMMode=0) then
          mbRet:=CustomDlg(Self,'Unallocate from '+StateTit,'Unallocate transaction from '+StateTit,
                           'Unallocating this transaction will remove it from this '+StateTit+', but place it on the next '+
                           StateTit+' run.'+#13+
                           'Please confirm you wish to unallocate the transaction as shown.',
                           mtwarning,
                           [mbOK,mbCancel])
        else
          mbRet:=mrOk;

        If (mbRet=mrOk) then
        Begin
          WarnUnalloc:=(OCMMode=0);

          If (OCMMode=0) then
          Begin
            LSetDataRecOfs(Fnum3,NRecAddr);

            Status:=GetDirect(F[Fnum3],Fnum3,LRecPtr[Fnum3]^,KeyPath3,0);
          end
          else
            Status:=0;

          If (StatusOk) then {We have secured the match record}
          Begin
            LOk:=BOn; LLocked:=BOn;

            If (OCMMode=0) then
              LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth3,Fnum3,BOff,LLocked);

            If (LOk) and (LLocked) then
            Begin
              If (OCMMode=0) then
                LGetRecAddr(Fnum3);

              KeyS:=NOurRef;
              LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KeyPAth2,Fnum2,BOff,LLocked);

              If (LOk) and (LLocked) then
              Begin
                LGetRecAddr(Fnum2);

                KeyS:=CISCertKey(LJobDetl^.JobCISV.CISCertNo);

                LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KeyPAth,Fnum,BOff,LLocked);

                If (LOk) and (LLocked) then
                With LInv, LJobDetl^.JobCISV do
                Begin
                  LGetRecAddr(Fnum);

                  If (OCMMode=0) then
                    VWorth:=LPassword.MatchPayRec.RecOwnCVal*DocCnst[InvDocHed]*DocNotCnst;

                  Update_CISVoucher(LJobDetl^,LInv,VWorth,MGross,CWorth,1*Ord(OCMMode=0));

                  Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

                  Report_BError(Fnum,Status);

                  Status:=Put_Rec(F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPAth2);

                  Report_BError(Fnum2,Status);

                  If (OCMMode=0) then
                  Begin
                    Status:=Delete_Rec(F[Fnum3],Fnum3,Keypath3);
                    RecDel:=StatusOk;
                    Report_BError(Fnum3,Status);
                  end
                  else
                  Begin
                    RecDel:=BOn;
                    Match_Voucher(LInv,FullOurRefKey(LJobDetl^.JobCISV.CISFolio),CWorth,VWorth,MGross,8);
                  end;

                  Status:=UnLockMLock(Fnum,LastRecAddr[Fnum]);

                  PostMessage(TForm(Self.Owner).Handle,WM_CustGetRec,301,1);

                  PostMessage(TForm(Self.Owner).Handle,WM_CustGetRec,302,0);

                  If (RecDel) then
                  Begin
                    Dispose(ODDRec);
                    Delete(Idx);
                  end;
                end;

                Status:=UnLockMLock(Fnum2,LastRecAddr[Fnum2]);

              end;

              If (Not RecDel) then
                Status:=UnLockMLock(Fnum3,LastRecAddr[Fnum3]);

            end;
          end;
        end; {If confirmed}
      end; {With..}

    end;
  end;
end;

procedure TObjCFrm.ShowMatch1Click(Sender: TObject);
begin
  WithMatchOn:=Not WithMatchOn;

  BuildObjectDrill;
end;

Initialization

  WarnUnalloc:=BOff;
  OCMMode:=0;


end.


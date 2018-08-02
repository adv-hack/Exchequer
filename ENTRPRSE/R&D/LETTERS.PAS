unit letters;

{$I DEFOVR.Inc}

//PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Turn off platform warnings
{$WARN UNIT_PLATFORM OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, ComCtrls, ComObj,
  GlobVar,VarConst,SBSComp,SBSComp2,BTSupU1,ExWrap1U,SupListU, Menus,
  MSWord95, Buttons, fileCtrl;

type


  TMAMList  =  Class(TGenList)
    Function SetCheckKey  :  Str255; Override;
    Function SetFilter  :  Str255; Override;
    Function Ok2Del :  Boolean; Override;
    Function OutLine(Col  :  Byte)  :  Str255; Override;
  end;


type
  TLettersList = class(TForm)
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    MPanel: TSBSPanel;
    MSBox: TScrollBox;
    MHedPanel: TSBSPanel;
    MORefLab: TSBSPanel;
    MYRefLab: TSBSPanel;
    MDateLab: TSBSPanel;
    MAmtLab: TSBSPanel;
    MORefPanel: TSBSPanel;
    MYRefPanel: TSBSPanel;
    MDatePanel: TSBSPanel;
    MAmtPanel: TSBSPanel;
    MListBtnPanel: TSBSPanel;
    LClsBtn: TButton;
    LVwBtn: TButton;
    LAddBtn: TButton;
    LDelBtn: TButton;
    LDescBtn: TButton;
    LLinkBtn: TButton;
    OpenDialog1: TOpenDialog;
    MOTypePanel: TSBSPanel;
    MOTypeLab: TSBSPanel;
    Btn_AddUrl: TButton;
    procedure MORefPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MORefLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MORefLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure LClsBtnClick(Sender: TObject);
    procedure LVwBtnClick(Sender: TObject);
    procedure LAddBtnClick(Sender: TObject);
    procedure LDelBtnClick(Sender: TObject);
    procedure LDescBtnClick(Sender: TObject);
    procedure LLinkBtnClick(Sender: TObject);
    procedure Btn_AddUrlClick(Sender: TObject);
  private
    { Private declarations }
    LtrMode       : Byte;
    LtrCustCode   : String;
    {LtrIsCust     : Boolean;}
    LtrTypeChar   : Char;
    CaptionStr   : ShortString;
    LtrFName     : ShortString;

    { Data records for adding letters }
    CustR        : CustRecPtr;
    StockR       : StockRecPtr;
    InvR         : InvRecPtr;
    JobR         : JobRecPtr;
    EmpR         : JobMiscPtr;

    BeenIn,
    JustCreated,
    StoreCoord,
    LastCoord,
    SetDefault,
    GotCoord,
    fNeedCUpdate,
    CanDelete    :  Boolean;


    OldMACtrl    :  TNHCtrlRec;

    PagePoint    :  Array[0..4] of TPoint;

    StartSize    :  TPoint;

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Function SetExtType(Ext  :  Str10)  :  btLettErDocType;

    Procedure Process_DraggedFiles(FLH  :  THandle);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMDropFiles(Var Message  :  TMessage); Message WM_DropFiles;

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    procedure SetHelpContextIDs; // NF: 16/05/06

  public
    { Public declarations }


    ExLocal      :  TdExLocal;

    ListOfSet    :  Integer;

    MACtrl       :  TNHCtrlRec;

    MULCtrlO     :  TMAMList;


    procedure FormDesign;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    procedure SetCaption;

    procedure ShowLink(ShowLines  :  Boolean);
    procedure SetFormProperties;

    procedure LoadLettersFor (Const LetterCode : ShortString;
                              Const WinCapt    : ShortString;
                              Const FName      : ShortString;
                              Const TypeChar   : Char;
                              Const CustPtr    : CustRecPtr;
                              Const StockPtr   : StockRecPtr;
                              Const InvPtr     : InvRecPtr;
                              Const JobPtr     : JobRecPtr;
                              Const EmpPtr     : JobMiscPtr);
  end;

{var
  LettersList  : TLettersList;}

{Procedure MaintainLetters (      TheParent  : TComponent;
                           Const LetterCode : String);}

Procedure DeleteLetters (Const LtrSubType : Char;
                         Const LtrKeyStr  : String);

function DeleteLettersLinks(Const LtrSubType : Char;
                            Const LtrKeyStr  : String;
                            const aDeleteLinks: Boolean; {True: Delete Links, False: Delete Letters}
                            aDeleteFile: Boolean = False): Integer;

procedure ExecLink(Const MiscR : MiscRec);


Function CodeToFName (Const InpCode : ShortString) : ShortString;

Function AdbType(Mode  :  Byte)  :  Char;

Function AdbHasData(Mode  :  Byte;
                    KeyChk:  Str255)  :  Boolean;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  //COMObj, //OLEAuto,
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  BTSupU2,
  BTSupU3,
  BTKeys1U,
  CmpCtrlU,
  ColCtrlU,

  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  LettrDlg,
  ShellAPI,

  SysU1,
  SysU2,
  {IntMU,
  MiscU,
  PayF2U,
  Warn1U,}
  SalTxl1U;

{$R *.DFM}


{ Reformats a code so that it can be used as a letter filename }
Function CodeToFName (Const InpCode : ShortString) : ShortString;
Const
  OKCharSet = ['A'..'Z', '0'..'9', '_', '-'];
Var
  WorkCode1, WorkCode2 : ShortString;
  I                    : SmallInt;
Begin
  Result := '';

  WorkCode1 := UpperCase(Trim(InpCode));

  If (Length(WorkCode1) > 0) Then Begin
    WorkCode2 := '';
    For I := 1 To Length(WorkCode1) Do
      If (WorkCode1[I] In OKCharSet) Then
        WorkCode2 := WorkCode2 + WorkCode1[I];

    { Check Length - Take last 8 if too long }
    If (Length(WorkCode2) > 8) Then
      Delete(WorkCode2, 1, Length(WorkCode2) - 8);

    Result := WorkCode2;
  End; { If }
End;


{ Delete all the letters for the specified cust/supp }
Procedure DeleteLetters (Const LtrSubType : Char;
                         Const LtrKeyStr  : String);
Const
  FNum    = MiscF;
  KeyPath = MIK;
Var
  OKey, KeyS      : AnyStr;
  DocPath         : String;
  Locked, SkipDel : Boolean;
  LAddr           : LongInt;
  KLen            : Integer;
begin
  { Build key for items to delete }
  KeyS := LetterTCode + LtrSubType + LtrKeyStr;
  OKey := KeyS;
  KLen := Length(KeyS);

  { Get first, if any }
  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (Status=0) and (CheckKey(OKey,KeyS,KLen,BOn)) Do Begin
    { lock }
    Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

    If (Ok) and (Locked) Then Begin
      SkipDel := False;
      If (MiscRecs^.btLetterRec.Version = DocWord95) Then Begin
        { Letter }
        DocPath := FullDocPath + MiscRecs^.btLetterRec.LtrPath
      End { If }
      Else Begin
        { Link - ask if they want to delete }
        DocPath := MiscRecs^.btLinkRec.LtrPath;
        SkipDel := (MessageDlg ('Do you want to delete the link file ''' + DocPath + '''', mtConfirmation, [mbYes, mbNo], 0) <> mrYes);
      End; { Else }

      If (Not SkipDel) Then Begin
        If Not DeleteFile(PCHAR(DocPath)) Then Begin
          { Delete of doc failed }
          MessageDlg ('Error: Could not delete ' + Trim(DocPath), mtInformation, [mbOk], 0);
        End; { If }
      End; { If }

      { Delete record }
      Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);
    End; { If }

    { Get next }
    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);
  end;
end;
//------------------------------------------------------------------------------
//Delete Letters & Links for Trader, Job, Transaction
function DeleteLettersLinks (Const LtrSubType : Char;
                             Const LtrKeyStr  : String;
                             const aDeleteLinks: Boolean; {True: Delete Links, False: Delete Letters}
                             aDeleteFile: Boolean = False): Integer;
Const
  FNum    = MiscF;
  KeyPath = MIK;
Var
  OKey, KeyS      : AnyStr;
  Locked          : Boolean;
  LAddr           : LongInt;
  KLen            : Integer;
  lDocPath        : String;
begin
  { Build key for items to delete }
  KeyS := LetterTCode + LtrSubType + LtrKeyStr;
  OKey := KeyS;
  KLen := Length(KeyS);

  { Get first, if any }
  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  while (Status=0) and (CheckKey(OKey,KeyS,KLen,BOn)) Do Begin
    { lock }
    Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

    if (Ok) and (Locked) then
    begin
      if (Not aDeleteLinks) and (MiscRecs^.btLetterRec.Version = DocWord95) then
      begin
        //delete Letter
        lDocPath := FullDocPath + MiscRecs^.btLetterRec.LtrPath;
        Status := Delete_Rec(F[Fnum],Fnum,KeyPath);
        if aDeleteFile then
          DeleteFile(PCHAR(lDocPath));

      end { If }
      else if ((aDeleteLinks) and (MiscRecs^.btLetterRec.Version <> DocWord95)) then
      begin
        //delete Link
        lDocPath := MiscRecs^.btLinkRec.LtrPath;
        Status := Delete_Rec(F[Fnum],Fnum,KeyPath);
        if aDeleteFile then
          DeleteFile(PCHAR(lDocPath));
      end; { Else }
    end; { If }   
    { Get next }
    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);
  end;
  Result := Status;
end;

procedure ExecLink(Const MiscR : MiscRec);
Var
  Res          : Byte;
  CDir, FName, link  : String;
  Hnd          : THandle;
  pProg, pDir, pParams : Array [0..255] Of Char;
begin
  With MiscR Do Begin
    { Save current directory }
    CDir:='';
    GetDir(0,CDir);

    Case btLetterRec.Version Of
      DocWord95 : With btLetterRec Do Begin
                    Res := ViewWordLetter (LtrPath);

                    If (Res <> 0) Then
                      DispLetterError (Res);
                  End;

      lnkDoc,        { Document }
      lnkFax,        { Fax }
      lnkImage,      { Bitmap, GIF, etc }
      lnkPres,       { Presentation }
      lnkProgram,    { Program }
      lnkSound,      { Sound file }
      lnkVideo,      { Video Clip }
      lnkOther,      { Unknown }
      lnkSpreadSh   { Spreadsheet }

                : With btLinkRec Do Begin
                    // HM 08/10/01: Specifically set Base Directory before expanding the path,
                    // otherwise it fails if hook, etc... has changed the current dir
                    If DirectoryExists (SetDrive) Then SetCurrentDir (SetDrive);

                    // HM 23/05/00: Added support for relative pathnames
                    //StrPCopy (pProg, LtrPath);
                    FName := ExpandFileName(LtrPath);
                    StrPCopy (pProg, FName);

                    StrPCopy (pDir, ExtractFilePath(LtrPath));
                    {StrCopy (pParams, '');}

                    If FileExists(FName) Then Begin
                      Hnd := ShellExecute (HWnd_DeskTop,
                                           'open',
                                           pProg,
                                           '',
                                           pDir,
                                           SW_SHOW);

                      If (Hnd <= 32) Then
                        MessageDlg ('An Error(' + IntToStr(Hnd) + ') occured trying to view the item', mtError, [mbOk], 0);
                    End { If FileExists(FName) }
                    Else
                      MessageDlg ('The file ''' + FName + ''' does not exist',
                                  mtError, [mbOk], 0);
                  End;
      lnkInternet:
                  begin
                   link := MiscR.BTLinkRec.LtrPath;

                   ShellExecute(Application.Handle,'open',
                                PChar(link),nil, nil,0);
                  end
    End; { Case }

    { Restore Original directory }
    ChDir(CDir);
  End; { With }
end;



{ Temporary Function to create and display the modal letters list }
(*Procedure MaintainLetters (      TheParent  : TComponent;
                           Const LetterCode : String);
Var
  PrevCursor : TCursor;
  InitState  : TNHCtrlRec;
begin
  { Save cursor and change to hourglass }
  PrevCursor := Screen.Cursor;
  Screen.Cursor := crHourglass;

  LettersList := TLettersList.Create(TheParent);
  Try
    LettersList.LoadLettersFor (LetterCode, True);

    Screen.Cursor := crDefault;
    LettersList.ShowModal;
    Screen.Cursor := crHourglass;
  Finally
    LettersList.Free;
  End;

  { Restore Original Cursor }
  Screen.Cursor := PrevCursor;
end;*)

{ ======= Function to Return Additonal Info db type ======== }
{ 0 - Cust }
{ 1 - Supp }
{ 2 - Trans }
{ 3 - Stock }
{ 4 - Job }
{ 5 - Employee}
{ 6 - CIS Voucher}
Function AdbType(Mode  :  Byte)  :  Char;

Begin
  Case Mode of
    0..1  :   Result := TradeCode[Mode=1];
    2     :   Result := LetterDocCode;
    3     :   Result := LetterStkCode;
    4     :   Result := LetterJobCode;
    5     :   Result := LetterEmplCode;
    6     :   Result := LetterCISCode;
    else      Result := LetterStkCode;
  end; {case..}
end;


Function AdbHasData(Mode  :  Byte;
                    KeyChk:  Str255)  :  Boolean;

Begin
  Result:=CheckExsists(PartCCKey(LetterTCode,AdbType(Mode))+KeyChk,MiscF,MIK);
end;



{$I LetterU2.PAS}





Procedure  TLettersList.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TLettersList.Find_FormCoord;
Var
  ThisForm:  TForm;
  VisibleRect:  TRect;
  GlobComp:  TGlobCompRec;
Begin
  New(GlobComp,Create(BOn));

  ThisForm:=Self;

  With GlobComp^ do Begin
    GetValues:=BOn;

    PrimeKey:='M';

    If (GetbtControlCsm(ThisForm)) then
    Begin
      {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
      StoreCoord:=BOff;
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);
    end;

    GetbtControlCsm(MPanel);
    GetbtControlCsm(MSBox);
    GetbtControlCsm(MListBtnPanel);
    GetbtControlCsm(LClsBtn);

    MULCtrlO.Find_ListCoord(GlobComp);
  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);

  {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;

end;


procedure TLettersList.Store_FormCoord(UpMode  :  Boolean);
Var
  GlobComp:  TGlobCompRec;
Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do Begin
    GetValues:=UpMode;

    PrimeKey:='M';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(MPanel);

    StorebtControlCsm(MSBox);

    StorebtControlCsm(MListBtnPanel);

    StorebtControlCsm(LClsBtn);

    MULCtrlO.Store_ListCoord(GlobComp);
  end; {With GlobComp..}

  GlobComp.Destroy;
end;

procedure TLettersList.FormSetOfSet;
Begin
  PagePoint[0].X:=ClientWidth - MPanel.Width;
  PagePoint[0].Y:=ClientHeight - MPanel.Height;

  PagePoint[1].X:=MPanel.Width-(MSBox.Width);
  PagePoint[1].Y:=MPanel.Height-(MSBox.Height);

  PagePoint[2].X:=ClientWidth-LClsBtn.Left;

  PagePoint[3].Y:=MSBox.ClientHeight-(MORefPanel.Height);

  PagePoint[4].X:=MPanel.Width-(MListBtnPanel.Left);
  PagePoint[4].Y:=MPanel.Height-(MListBtnPanel.Height);

  GotCoord:=BOn;
end;


Procedure TLettersList.WMCustGetRec(Var Message  :  TMessage);
Begin
  With Message do
  Begin

    Case WParam of
      0,169
         :  Begin
              If (WParam=169) then
                MULCtrlO.GetSelRec(BOff);

              LVwBtnClick(nil);
            end;
      {1  :  Begin
              If (BeenIn) and (MULCtrlO.Link2Inv) then
              Begin
                Send_UpdateList(65);
              end;
            end;}
      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      25  :  NeedCUpdate:=BOn;
    end; {Case..}
  end;

  Inherited;
end;



Procedure TLettersList.Process_DraggedFiles(FLH  :  THandle);


Var
  LinkType    : btLetterDocType;
  n,
  TotFiles,
  GetFile,
  GetFileSze  :  Integer;
  P           :  PChar;

  Ext         :  Str10;


Begin
  TOTFiles:=DragQueryFile(FLH,$FFFFFFFF,Nil,0);

  For n:=0 to TOTFiles do
  Begin
    GetFileSze:=DragQueryFile(FLH,n,nil,0);

    If (GetFileSze>0) then
    Begin
      Inc(GetFileSze);
      GetMem(P,GetFileSze);
      GetFile:=DragQueryFile(FLH,n,P,GetFileSze);

      { Generate LinkType from Extension }
      Ext := UpperCase(Copy(ExtractFileExt(P),2,3));

      LinkType:=SetExtType(Ext);

      DescrDialog (LtrCustCode, LtrTypeChar, P, LinkType);

      With MULCtrlO Do
        AddNewRow(MUListBoxes[0].Row, Boff);

      FreeMem(P,GetFileSze);
    end;

  end;
  { Update for add }
  
end;


Procedure TLettersList.WMDropFiles(Var Message  :  TMessage);

Var
  FLH  :  THandle;

Begin
  With Message do
  Begin

    FLH:=WParam;

    Process_DraggedFiles(FLH);

    DragFinish(FLH);

    Result:=0;
  end;
end;


{ == Procedure to Send Message to Get Record == }
Procedure TLettersList.Send_UpdateList(Mode   :  Integer);
Var
  Message1 :  TMessage;
  MessResult :  LongInt;
Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do Begin
    MSg:=WM_CustGetRec;
{*EX32}
   //AP 09/03/2016 ABSEXCH-15431: Access violation  after opening a suppiler link and closing the related link screen.
    If (LtrTypeChar = TradeCode[True]) Then
      WParam := 400
    Else If (LtrTypeChar = TradeCode[False]) Then
      WParam := 402
    else
      WParam := 401;

    LParam := 0;
  end;

  With Message1 do
    MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);
end; {Proc..}


procedure TLettersList.SetCaption;
Begin
  Caption := 'Links For ' + Trim(CaptionStr);
end;


procedure TLettersList.ShowLink(ShowLines : Boolean);
begin
  ExLocal.AssignFromGlobal(MiscF);
  ExLocal.LGetRecAddr(MiscF);

  LtrCustCode := Trim(MiscRecs^.btLetterRec.AccCode);
  SetCaption;

  ReFreshList(ShowLines,Not JustCreated);

  JustCreated:=BOff;
end;


procedure TLettersList.FormDesign;
begin
  {  }
end;


procedure TLettersList.RefreshList(ShowLines,
                                       IgMsg      :  Boolean);
Var
  KeyStart    :  Str255;
  LKeypath,
  LKeyLen     :  Integer;
Begin
  LKeyPath := 0;
  If (LtrCustCode <> '') Then Begin
    KeyStart := LetterTCode + LtrTypeChar + LtrCustCode;
    LKeyLen  := Length(KeyStart);

    With MULCtrlO do Begin
      DisplayMode:=0;

      IgnoreMsg:=IgMsg;

      Case DisplayMode of
        0  : LKeypath := MIK;
      end; {Case..}

      StartList(MiscF,LKeypath,KeyStart,'','',LKeyLen,(Not ShowLines));

      IgnoreMsg:=BOff;
    End; { With }
  End; { If }
end;


procedure TLettersList.FormBuildList(ShowLines  :  Boolean);
Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;
Begin
  MULCtrlO:=TMAMList.Create(Self);
  StartPanel := nil;
  Try
    With MULCtrlO do Begin
      Try
        With VisiList do Begin
          AddVisiRec(MOTypePanel,MOTypeLab);
          AddVisiRec(MORefPanel,MORefLab);
          AddVisiRec(MYRefPanel,MYRefLab);
          AddVisiRec(MDatePanel,MDateLab);
          AddVisiRec(MAMTPanel,MAMTLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {HidePanels(0);}

          LabHedPanel:=MHedPanel;

          ListOfSet:=10;

          SetHedPanel(ListOfSet);
        end;
      except
        VisiList.Free;
      end;

      Find_FormCoord;

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=4;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOff;

      WM_ListGetRec:=WM_CustGetRec;

      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
        With ColAppear^[n] Do
          AltDefault:=BOn;

      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;

      Set_Buttons(MListBtnPanel);

      ReFreshList(ShowLines,BOff);
    end {With}
  Except
    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;

  FormSetOfSet;

  FormReSize(Self);
end;


procedure TLettersList.FormCreate(Sender: TObject);
Var
  n  :  Integer;
begin
  ExLocal.Create;

  LastCoord:=BOff;

  NeedCUpdate:=BOff;

  JustCreated:=BOn;

  ClientHeight := 256;
  ClientWidth  := 490;

  BeenIn:=BOff;

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;
  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  FormDesign;

  FormBuildList(BOff);

  LtrCustCode := '';
  LtrTypeChar := TradeCode[Bon];

  DragAcceptFiles(Self.Handle,TRUE);

  SetHelpContextIDs; // NF: 16/05/06 Fix for incorrect Context IDs
end;


procedure TLettersList.FormDestroy(Sender: TObject);
Var
  n  :  Byte;
begin
  If Assigned (CustR) Then Dispose(CustR);
  If Assigned (StockR) Then Dispose(StockR);
  If Assigned (InvR) Then Dispose(InvR);
  If Assigned (JobR) Then Dispose(JobR);
  If Assigned (EmpR) Then Dispose(EmpR);

  ExLocal.Destroy;
end;


procedure TLettersList.FormCloseQuery(Sender: TObject;
                                          var CanClose: Boolean);
Var
  n  : Integer;

begin
  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  If (NeedCUpdate) then
      Store_FormCoord(Not SetDefault);

  Send_UpdateList(44);
end;

procedure TLettersList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TLettersList.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;
begin
  If (GotCoord) then
  Begin
    If (Assigned(MULCtrlO)) then
      MULCtrlO.LinkOtherDisp:=BOff;

    MPanel.Width:=ClientWidth-PagePoint[0].X;
    MPanel.Height:=ClientHeight-PagePoint[0].Y;

    MSBox.Width:=MPanel.Width-PagePoint[1].X;
    MSBox.Height:=MPanel.Height-PagePoint[1].Y;

    MListBtnPanel.Left:=MPanel.Width-PagePoint[4].X;
    MListBtnPanel.Height:=MPanel.Height-PagePoint[4].Y;

    { Reposition buttons }
    LClsBtn.Left  := ClientWidth - PagePoint[2].X;
    LVwBtn.Left   := LClsBtn.Left;
    LAddBtn.Left  := LClsBtn.Left;
    LLinkBtn.Left := LClsBtn.Left;
    LDelBtn.Left  := LClsBtn.Left;
    LDescBtn.Left := LClsBtn.Left;
    Btn_AddUrl.Left := LClsBtn.Left;
    
    If (MULCtrlO<>nil) then
    Begin
      LockWindowUpDate(Handle);

      With MULCtrlO,VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=MSBox.ClientHeight-PagePoint[3].Y;

        RefreshAllCols;
      end;

      LockWindowUpDate(0);

      MULCtrlO.ReFresh_Buttons;

      MULCtrlO.LinkOtherDisp:=BOn;

    end;{Loop..}

    
    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end; {If time to update}
end;

procedure TLettersList.MORefPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  BarPos     :  Integer;
  PanRSized  :  Boolean;
begin
  If (Sender is TSBSPanel) then
    With (Sender as TSBSPanel) do Begin
      PanRSized:=ReSized;

      BarPos:=MSBox.HorzScrollBar.Position;

      If (PanRsized) then
        MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

      MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

      NeedCUpdate:=(MULCtrlO.VisiList.MovingLab or PanRSized);
    end;
end;


procedure TLettersList.MORefLabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;
begin
  If (Sender is TSBSPanel) then
    With (Sender as TSBSPanel) do Begin
      If (Not ReadytoDrag) and (Button=MBLeft) then Begin
        If (MULCtrlO<>nil) then
          MULCtrlO.VisiList.PrimeMove(Sender);

        NeedCUpdate:=BOn;
      end
      else
        If (Button=mbRight) then Begin
          ListPoint:=ClientToScreen(Point(X,Y));

          ShowRightMeny(ListPoint.X,ListPoint.Y,0);
        end;
    end;
end;


procedure TLettersList.MORefLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
    With (Sender as TSBSPanel) do Begin
      If (MULCtrlO<>nil) then
      Begin
        MULCtrlO.VisiList.MoveLabel(X,Y);
        NeedCUpdate:=MULCtrlO.VisiList.MovingLab;
      end;
    end;
end;



procedure TLettersList.SetFormProperties;
Var
  TmpPanel    :  Array[1..3] of TPanel;
  n           :  Byte;
  ResetDefaults,
  BeenChange  :  Boolean;
  ColourCtrl  :  TCtrlColor;
Begin
  ResetDefaults:=BOff;

  For n:=1 to 3 do Begin
    TmpPanel[n]:=TPanel.Create(Self);
  end;

  try
    With MULCtrlO.VisiList do Begin
      VisiRec:=List[0];

      TmpPanel[1].Font:=(VisiRec^.PanelObj as TSBSPanel).Font;
      TmpPanel[1].Color:=(VisiRec^.PanelObj as TSBSPanel).Color;

      TmpPanel[2].Font:=(VisiRec^.LabelObj as TSBSPanel).Font;
      TmpPanel[2].Color:=(VisiRec^.LabelObj as TSBSPanel).Color;


      TmpPanel[3].Color:=MULCtrlO.ColAppear^[0].HBKColor;
    end;

    TmpPanel[3].Font.Assign(TmpPanel[1].Font);

    TmpPanel[3].Font.Color:=MULCtrlO.ColAppear^[0].HTextColor;


    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,'Match Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then Begin
          For n:=1 to 3 do
            With TmpPanel[n] do
              Case n of
                1,2  :  MULCtrlO.ReColorCol(Font,Color,(n=2));

                3    :  MULCtrlO.ReColorBar(Font,Color);
              end; {Case..}

          MULCtrlO.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
        end;
      end;
    finally
      ColourCtrl.Free;
    end;
  Finally
    For n:=1 to 3 do
      TmpPanel[n].Free;
  end;

  If (ResetDefaults) then Begin
    SetDefault:=BOn;
    Close;
  end;
end;

procedure TLettersList.ShowRightMeny(X,Y,Mode  :  Integer);
Begin
  With PopUpMenu1 do Begin
    PopUp(X,Y);
  end;
end;

procedure TLettersList.PopupMenu1Popup(Sender: TObject);
{Var
  n  :  Integer;}
begin
  StoreCoordFlg.Checked:=StoreCoord;
end;

procedure TLettersList.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TLettersList.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord := Not StoreCoord;
  NeedCUpdate:=BOn;
end;

procedure TLettersList.LClsBtnClick(Sender: TObject);
begin
  Close;
end;

{ view letter }
procedure TLettersList.LVwBtnClick(Sender: TObject);
begin
  If MULCtrlO.ValidLine Then Begin
    MULCtrlO.GetSelRec(BOff);

    ExecLink (MiscRecs^);
  End; { If }
end;

procedure TLettersList.LDelBtnClick(Sender: TObject);
Const
  FNum    = MiscF;
  KeyPath = MIK;
Var
  KeyS            : Str255;
  Locked, SkipDel : Boolean;
  DocPath         : String;
begin
  If MulCtrlO.ValidLine Then
    If (MessageDlg ('Are you sure you want to delete this link?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then Begin
      { delete letter }
      MULCtrlO.GetSelRec(BOff);

      With MiscRecs^, btLetterRec Do
        KeyS := RecMfix + SubType + CustomKey;
      Status := Find_Rec (B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
      If (Status = 0) Then Begin
        Ok:=GetMultiRec(B_GetDirect, B_MultLock, KeyS, KeyPath, Fnum, BOn, Locked);
        Status := Delete_Rec(F[Fnum],Fnum,KeyPath);

          If (Status = 0) Then Begin
          { Delete actual document }
          SkipDel := False;
          If (MiscRecs^.btLetterRec.Version = DocWord95) Then
            DocPath := FullDocPath + MiscRecs^.btLetterRec.LtrPath
          else
          begin
           DocPath := MiscRecs^.btLinkRec.LtrPath;

           if (MiscRecs^.btLetterRec.Version = lnkInternet) then
           begin
             if (FileExists(DocPath)) then
               SkipDel := false
             else
               SkipDel := true;
           end;
          end;

          if (MiscRecs^.btLetterRec.Version <> DocWord95) and (SkipDel = false)
          then
          begin
            DocPath := MiscRecs^.btLinkRec.LtrPath;
            SkipDel := (MessageDlg ('Do you want to delete the link file ''' + DocPath + '''', mtConfirmation, [mbYes, mbNo], 0) <> mrYes);
          End; { Else }

          If (Not SkipDel) Then
            If Not DeleteFile(PCHAR(DocPath)) Then
              { Delete of doc failed }
              MessageDlg ('Error: Could not delete ' + Trim(DocPath), mtInformation, [mbOk], 0);
        End; { If }

        Report_Berror (Fnum, Status);
      End; { If }

      With MUlCtrlO Do Begin
        PageUpDn(0, BOn);

        If (PageKeys^[0] = 0) Then
          InitPage;
      End; { With }
    End; { If }
end;

{ edit description information }
procedure TLettersList.LDescBtnClick(Sender: TObject);
begin
  If MULCtrlO.ValidLine Then Begin
    MULCtrlO.GetSelRec(BOff);

    ViewLetterDescr (MiscRecs^);

    With MULCtrlO Do
      AddNewRow(MUListBoxes[0].Row, Bon);
  End; { If }
end;

procedure TLettersList.LAddBtnClick(Sender: TObject);
Var
  Version : btLetterDocType;
  Res     : Byte;

  CDir    : String;

begin
  {$IFNDEF WCA} { Windows Card System }
  If (CaptionStr <> '') Then
  Begin
    Version := DocWord95;

    GetDir(0,CDir);

    Case Version Of
      DocWord95 : Begin
                    Res := AddWordLetter (LtrCustCode, LtrFName, LtrTypeChar,
                    CustR, StockR, InvR, JobR, EmpR);

                    If (Res <> 0) Then
                      DispLetterError (Res);
                  End;

    End; { Case }

    ChDir(CDir);


    { Update for add }
    With MULCtrlO Do
      AddNewRow(MUListBoxes[0].Row, Boff);
  End; { If }
  {$ENDIF}
end;

procedure TLettersList.LoadLettersFor (Const LetterCode : ShortString;
                                       Const WinCapt    : ShortString;
                                       Const FName      : ShortString;
                                       Const TypeChar   : Char;
                                       Const CustPtr    : CustRecPtr;
                                       Const StockPtr   : StockRecPtr;
                                       Const InvPtr     : InvRecPtr;
                                       Const JobPtr     : JobRecPtr;
                                       Const EmpPtr     : JobMiscPtr);
begin
  ExLocal.AssignFromGlobal(MiscF);
  ExLocal.LGetRecAddr(MiscF);

  LtrCustCode := LetterCode;
  LtrTypeChar := TypeChar;
  LtrFName := FName;

  { Have we got a customer record }
  If Assigned (CustPtr) Then Begin
    If Not Assigned (CustR) Then New(CustR);
    CustR^ := CustPtr^;
  End { If }
  Else Begin
    If Assigned (CustR) Then Dispose(CustR);
    CustR := Nil;
  End; { If }

  { Check to see if a stock item has been passed in }
  If Assigned (StockPtr) Then Begin
    If Not Assigned (StockR) Then New(StockR);
    StockR^ := StockPtr^;
  End { If }
  Else Begin
    If Assigned (StockR) Then Dispose(StockR);
    StockR := Nil;
  End; { If }

  { Check to see if an invoice has been passed in }
  If Assigned (InvPtr) Then Begin
    If Not Assigned (InvR) Then New(InvR);
    InvR^ := InvPtr^;
  End { If }
  Else Begin
    If Assigned (InvR) Then Dispose(InvR);
    InvR := Nil;
  End; { If }

  { Check to see if a job has been passed in }
  If Assigned (JobPtr) Then Begin
    If Not Assigned (JobR) Then New(JobR);
    JobR^ := JobPtr^;
  End { If }
  Else Begin
    If Assigned (JobR) Then Dispose(JobR);
    JobR := Nil;
  End; { If }

  { Check to see if an Employee/ CIS Rec has been passed in }
  If Assigned (EmpPtr) Then Begin
    If Not Assigned (EmpR) Then New(EmpR);
    EmpR^ := EmpPtr^;
  End { If }
  Else Begin
    If Assigned (EmpR) Then Dispose(EmpR);
    EmpR := Nil;
  End; { If }

  CaptionStr := WinCapt;
  SetCaption;

  ReFreshList(True, BOff);
end;


Function TLettersList.SetExtType(Ext  :  Str10)  :  btLettErDocType;
Begin
  // MH 08/04/2013 v7.0.3 ABSEXCH-14064: Added support for DocX files
  If (Ext = 'DOC') Or (Ext = 'DOCX') Or (Ext = 'DOT') Or (Ext = 'TXT') Or
     (Ext = 'PDF') Or (Ext = 'WS') Then
      Result := lnkDoc
    Else
      If (Ext = 'BMP') Or (Ext = 'GIF') Or (Ext = 'JPG') Or
         (Ext = 'PCX') Or (Ext = 'TXT') Or (Ext = 'TIF') Or
         (Ext = 'CDR') Or (Ext = 'DRW') Or (Ext = 'PCD') Or
         (Ext = 'PIC') Or (Ext = 'WPG') Then
        Result := lnkImage
      Else
        If (Ext = 'WAV') Or (Ext = 'MID') Or (Ext = 'RMI') Or
           (Ext = 'AU') Or (Ext = 'SND') Or (Ext = 'RA') Then
          Result := lnkSound
        Else
          If (Ext = 'EXE') Or (Ext = 'BAT') Or (Ext = 'COM') Then
            Result := lnkProgram
          Else
            If (Ext = 'XLS') Then
              Result := lnkSpreadSh
            Else
              If (Ext = 'AVI') Or (Ext = 'MPG') Or (Ext = 'MOV') Or
                 (Ext = 'QT') Or (Ext = 'SCM') Or (Ext = 'RM') Then
                Result := lnkVideo
              Else
                If (Ext = 'HTM') Or (Ext = 'URL') Then
                  Result := lnkInternet
                Else
                  Result := lnkOther;
end;


procedure TLettersList.LLinkBtnClick(Sender: TObject);
Var
  LinkType     : btLetterDocType;
  Ext          : String[3];
  Temp1, Temp2 : PChar;
  PLen         : SmallInt;
  FPath        : ShortString;
  CDir         : String;
begin
  With OpenDialog1 Do Begin
    InitialDir := SetDrive + 'DOCMASTR';
  End; { With }

  // HM 23/05/00: Added save/restore of directory
  GetDir(0,CDir);

  If OpenDialog1.Execute Then Begin
    // HM 23/05/00: Added save/restore of directory
    ChDir(CDir);

    { Convert to Short path name }
    FPath := OpenDialog1.FileName;
    Temp1 := StrAlloc (255);
    Temp2 := StrAlloc (255);

    StrPCopy (Temp1, Trim(FPath));
    PLen := GetShortPathName (Temp1, Temp2, StrBufSize (Temp2));
    If (PLen > 0) Then
      // HM 23/05/00: Added relative path
      FPath := ExtractRelativePath (SetDrive, Trim(StrPas(Temp2)));

    StrDispose (Temp1);
    StrDispose (Temp2);

    { Generate LinkType from Extension }
    Ext := UpperCase(Copy(ExtractFileExt(FPath),2,3));

    LinkType:=SetExtType(Ext);

    DescrDialog (LtrCustCode, LtrTypeChar, FPath, LinkType);

    { Update for add }
    With MULCtrlO Do
      AddNewRow(MUListBoxes[0].Row, Boff);

  End { If }
  Else
    // HM 23/05/00: Added save/restore of directory
    ChDir(CDir);
end;

// NF: 16/05/06 Fix for incorrect Context IDs
procedure TLettersList.SetHelpContextIDs;
begin
{  MOTypePanel.HelpContext := 1787; // Type Column
  MORefPanel.HelpContext := 1788; // Date Column
  MYRefPanel.HelpContext := 1789; // Description Column
  MDatePanel.HelpContext := 1790; // User Column
  MAmtPanel.HelpContext := 1791; // Time Column}

  LClsBtn.HelpContext := 1792;
  LAddBtn.HelpContext := 1793;
  LLinkBtn.HelpContext := 1794;
  LVwBtn.HelpContext := 1795;
  LDelBtn.HelpContext := 1796;
  LDescBtn.HelpContext := 1797;
end;



procedure TLettersList.Btn_AddUrlClick(Sender: TObject);
var
 LinkType : btLetterDocType;
begin
    LinkType := SetExtType('URL');
    DescrDialog (LtrCustCode, LtrTypeChar, '', LinkType);

    With MULCtrlO Do
      AddNewRow(MUListBoxes[0].Row, Boff);
end;

Initialization

end.

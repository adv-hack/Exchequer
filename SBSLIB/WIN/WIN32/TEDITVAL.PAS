unit TEditVal;

interface
{$WARN UNIT_DEPRECATED OFF}

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Dialogs,Forms,StdCtrls, Mask,EtStrU,EtDateU,ETMiscU,Grids,OutLine,
  SBSPanel, AccelLbl, ExtCtrls, ComCtrls, BkGroup,Buttons, Menus;

const
  GDPRDefaultColor = 35281; //RGB(237, 139, 0);

type
  TEditValue= class(TMaskEdit)
  private
    { Private declarations }
    FFloatVal   :  Double;
    FFormatMask :  String;
    FNDecimals  :  Integer;
    FBeenEnter,
    FFloatMod,
    ValidOk     :  Boolean;

    Procedure SetFloatVal(FVal  :  Double);

    Procedure SetFormatMask(FVal  :  String);

    Procedure SetNDecimals(FVal  :  Integer);

    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit);   message CM_EXIT;

  protected
    { Protected declarations }

    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyPress(var Key: Char); override;


  public
    { Public declarations }
    constructor Create(AOwner:TComponent); Override;

    Procedure ValidateEdit; override;

    Property  FloatModified  :  Boolean  read FFloatMod  write FFloatMod;
    Property  BeenEntered    :  Boolean  read FBeenEnter write FBeenEnter;

  published
    { Published declarations }

    property FloatValue  : Double read FFloatVal write SetFloatVal;
    property FormatMask  : String read FFormatMask write SetFormatMask;
    property NDecimals   : Integer read FNDecimals write SetNDecimals;

  end;

{ ==============================================================================}

{ ====== Alternative currency edit component ======= }

  TCurrencyEdit = class(TMemo)
  private
    DefFormat,
    DispFormat,
    fCurr     : string;
    FieldValue: Extended;

    fInEdit,
    fBlockNegative,
    ValidOk,
    HBeenForced,
    FFloatMod,
    fShowCurr,
    fBOnZero  : Boolean;
    FNDecimals: Integer;
    FTextId   : LongInt;

    procedure SetFormat(A: string);

    procedure FormatDec(NDec  : Integer);
    procedure SetNDecimals(A  :  Integer);
    procedure SetFieldValue(A: Extended);
    procedure SetfCurr(A: String);


    procedure CMEnter(var Message: TCMEnter);           message CM_ENTER;
    procedure CMExit(var Message: TCMExit);             message CM_EXIT;
    procedure CNCommand(var Message: TWMCommand);       message CN_COMMAND;
    procedure CNKeyDown(var Message: TWMKeyUp); message CN_KeyDown;

    procedure WMSetFocus(var Message: TMessage); message WM_SetFocus;

    Procedure ValidateEdit(T2Chk  :  String);


  protected
    procedure KeyPress(var Key: Char); override;
    procedure CreateParams(var Params: TCreateParams); override;
    Procedure Loaded; override;

  public
    F9Value,
    LastValue : Extended;

    constructor Create(AOwner: TComponent); override;

    Property  FloatModified  :  Boolean  read FFloatMod  write FFloatMod;

    property StillEdit  : Boolean  read fInEdit write fInEdit;

    procedure WiggleHeight;

    procedure FormatText;
    procedure UnFormatText;

  published
    property Alignment default taRightJustify;
    property AutoSize default True;
    property BlockNegative :  Boolean read fBlockNegative write fBlockNegative;
    property BlankOnZero  :  Boolean read fBOnZero write fBOnZero;
    property BorderStyle;

    property Color;
    property Ctl3D;
    property CurrencySymb  :  string read fCurr write SetfCurr;
    property DisplayFormat: string read DispFormat write SetFormat;
    property DecPlaces     : Integer read FNDecimals write SetNDecimals default 2;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property ShowCurrency  :  Boolean read fShowCurr write fShowCurr;
    property TabOrder;
    Property TextId : LongInt Read FTextId Write FTextId;
    property Value: Extended read FieldValue write SetFieldValue;
    property Visible;
    property WantTabs;
    property WantReturns;


    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;


{ ==============================================================================}


{ ============= TDate validation ============ }

  TPlacement = (cpAbove,cpBelow,cpLeft,cpRight,cpOnTop,cpOffsets,cpAuto);

  TEditDate= class(TMaskEdit)
  private
    { Private declarations }
    FOffsetX : Integer;
    FOffsetY : Integer;
    FPlacement : TPlacement;

    FStoreDate,
    FOrigValue  :  String;

    FAllowBlank,
    FDateMod,
    ValidOk     :  Boolean;
    FGDPREnabled: Boolean;

    Procedure SetDateVal(FVal  :  String); Virtual;
    Procedure SetOrigVal(FVal  :  String);

    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit);   message CM_EXIT;

    procedure WMSetFocus(var Message: TMessage); message WM_SetFocus;

    procedure CNKeyDown(var Message: TWMKeyUp); message CN_KeyDown;

    procedure DblClick; override;

    procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
  protected
    { Protected declarations }

    procedure KeyPress(var Key: Char); override;

  public
    { Public declarations }


    constructor Create(AOwner:TComponent); Override;

    Procedure ValidateEdit; override;
    
    //HV 17/11/2017 2018-R1: Highlighting PII Fields flag for GDPR
    procedure Loaded; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;

    property DateValue  : String read FStoreDate write SetDateVal;
    property OrigValue  : String read FOrigValue write SetOrigVal;
    property DateModified : Boolean read FDateMod write FDateMod;


  published
    { Published declarations }

    property OffsetX: Integer read FOffsetX write FOffsetX default 0;
    property OffsetY: Integer read FOffsetY write FOffsetY default 0;
    property Placement: TPlacement read FPlacement write FPlacement default cpOnTop;
    //HV 17/11/2017 2018-R1: ABSEXCH-19405 GDPR (POST 19286) - 5.3.1 - Trader Record (see A2.3.1 Account Record for list of PII fields)
    property GDPREnabled: Boolean  read FGDPREnabled write FGDPREnabled default False;
    property AllowBlank  : Boolean read FAllowBlank write FAllowBlank default False;

  end;

  { ==============================================================================}

{ ============= TPeriod validation ============ }

  TDate2PrEvent  =  function (Sender  :  TObject;
                        Const IDate   :  String;
                        Const Date2Pr :  Boolean)  :  String of Object;

  TPr2DispEvent  =  function (Sender  :  TObject;
                        Const EPr     :  Byte)     :  String of Object;


  TEditPeriod= class(TEditDate)
  private

    fPr,
    fPrInYear  :  Byte;

    fYr        :  Integer;

    fInExitProc,
    fHideDUpdate
               :  Boolean;

    fViewMask,
    fTempMask  :  String;

    FOnConvDate
               :  TDate2PrEvent;

    FOnPrDisp
               :  TPr2DispEvent;

    Procedure SetDateVal(FVal  :  String); Override;

    Procedure SetPeriod(FVal  :  Byte);
    Procedure SetYear(FVal  :  Integer);

    Procedure SetViewMask(FVal  :  String);

    Procedure AdjPeriod(Var AMnth,AYr  :  Word;
                            Id         :  Boolean);

    procedure CMExit(var Message: TCMExit);   message CM_EXIT;

    procedure CMEnter(var Message: TCMEnter);   message CM_Enter;

    procedure WMSetFocus(var Message: TMessage); message WM_SetFocus;

    procedure DblClick; override;


  protected
    { Protected declarations }

    procedure KeyPress(var Key: Char); override;


  public
    { Public declarations }


    constructor Create(AOwner:TComponent); Override;

    Procedure ValidateEdit; Override;

    Procedure InitPeriod(Var   fPr,fYr  :  Byte;
                         Const SetPr,
                               ViewPr   :  Boolean);

    Function RefreshValues  :  Boolean;

    procedure ShowPeriod;

  published
    { Published declarations }

    property EPeriod  : Byte read fPr write SetPeriod;
    property EYear  : Integer read fYr write SetYear;

    property PeriodsInYear : Byte read fPrInYear write fPrInYear default 12;

    property ViewMask  : String read fVieWMask write SetViewMask;

    Property OnConvDate  :  TDate2PrEvent read FOnConvDate write FOnConvDate;

    Property OnShowPeriod  :  TPr2DispEvent read FOnPrDisp write FOnPrDisp;


  end;

  { ==============================================================================}


  {== Custom Tezt8Pt ==}


  TSBSHookEvent = procedure(Sender: TObject) of object;


  Text8Pt = class(TMaskEdit)


  private
    { Private declarations }

    fLastValue  :  String;

    fLinkCust,
    fLinkStock,
    fLinkJob,
    fViaSBtn,
    fHiLite,
    fAltMod,
    fInEdit     :  Boolean;

    {FButton     : TSpeedButton;}
    FButton     : TUpDown;

    FBtnWindow  : TWinControl;

    FOnSBSHook  : TSBSHookEvent;

    FTextId : LongInt;
    FGDPREnabled: Boolean;

    //PR: 13/11/2017 ABSEXCH-19451
    FAllowPostedEdit : Boolean;

    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit);   message CM_EXIT;

    Procedure SendLinkMsg;

    procedure WMSetFocus(var Message: TMessage); message WM_SetFocus;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;

    procedure CNKeyDown(var Message: TWMKeyUp); message CN_KeyDown;

    procedure WMPostHook(var Message: TMessage); message WM_User+$40;

    // CJS 2015-10-21 - ABSEXCH-15598 - paste into edit fields includes tabs
    procedure WMPaste(var Message: TWMPaste); message WM_PASTE;

    procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;

    procedure SetEditRect;
  protected
    { Protected declarations }

    Procedure SetOrigVal(FVal  :  String);

    Procedure SetLinkCust(FBo  :  Boolean);
    Procedure SetLinkStock(FBo  :  Boolean);
    Procedure SetLinkJob(FBo  :  Boolean);
    Procedure SetHiLite(FBo  :  Boolean);

    procedure CreateParams(var Params: TCreateParams); override;

    procedure CreateWnd; override;

    procedure ClickSpeed(Sender: TObject; Button: TUDBtnType);

    //procedure SetCursor(Pos: Integer);


  public
   constructor Create(AOwner:TComponent); Override;
    { Public declarations }

    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;

    property OrigValue  : String read fLastValue write SetOrigVal;

    property StillEdit  : Boolean  read fInEdit write fInEdit;

    property AltMod  : Boolean  read fAltMod write fAltMod;

    procedure Loaded; override;

    procedure DblClick; override;

    Procedure CheckHiLite;

    procedure PosArrows;

    Procedure ExecuteHookMsg;

  published
    { Published declarations }

    Property TextId : LongInt Read FTextId Write FTextId;

    Property ViaSBtn: Boolean Read FviaSBtn Write FviaSBtn;

    //HV 09/11/2017 2018-R1: Highlighting PII Fields flag for GDPR
    property GDPREnabled: Boolean  read FGDPREnabled write FGDPREnabled default False;

    //PR: 13/11/2017 ABSEXCH-19451
    property AllowPostedEdit : Boolean read FAllowPostedEdit write FAllowPostedEdit default False;


    Procedure ForceEnd;
    property Link_to_Cust: Boolean  read fLinkCust write SetLinkCust default False;
    property Link_to_Stock: Boolean  read fLinkStock write SetLinkStock default False;
    property Link_to_Job: Boolean  read fLinkJob write SetLinkJob default False;
    property ShowHilight : Boolean  read fHiLite write SetHiLite default False;
    property OnEntHookEvent  :  TSBSHookEvent  read fOnSBSHook write fOnSBSHook;

  end;

  { ==============================================================================}

 type
  TOnSetFocusBackEvent = procedure(Sender: TObject; var bSetFocus: boolean) of object;

  TExMaskEdit = Class(Text8pt)
  private
    fOnMaskError : TNotifyEvent;
    fOnSetFocusBack : TOnSetFocusBackEvent;
  protected
    procedure ValidateError; override;
  public
    procedure ValidateEdit; override;
  published
    property OnMaskError: TNotifyEvent read fOnMaskError write fOnMaskError;//NF:
    property OnSetFocusBack: TOnSetFocusBackEvent read fOnSetFocusBack write fOnSetFocusBack;
  end;



  { ==============================================================================}

  Label8 = class(TLabel)
  private
    FTextId : LongInt;
  protected
    { Private declarations }
    FHitTest   : TPoint;

    FWChange   : Boolean;

    CurrWidth  : LongInt;

    ReadytoDrag
               : Boolean;

    Function CheckReSize  :  Boolean;

    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;

    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;


  public
    constructor Create(AOwner:TComponent); Override;
    { Public declarations }
     Property Resized  :  Boolean Read CheckReSize Write FWChange;


  published
    { Published declarations }
    Property TextId : LongInt Read FTextId Write FTextId;
  end;

{ ==============================================================================}

TSBSComboBox = class(TComboBox)

  private

    FItemsL,
    FItemsT    : TStringList;

    fAllowChangeInExit,
    fKeyTyped,
    fReadOnly  :  Boolean;
    fModified  :  Boolean;

    fLastValue :  String;

    fValidate,
    fInDropDown,
    fExtendList,
    fItemSwap,

    fInEdit    :  Boolean;

    fDelayCount,
    fMaxListWidth,
    fNormWidth :  Integer;
    FGDPREnabled: Boolean;



    Function Set_AutoIndex  :  Integer;

    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit);   message CM_EXIT;

    Procedure SetAllowChangeInExit(FVal  :  Boolean);

    Procedure SetModified(FVal  :  Boolean);

    procedure SetReadOnly(Value: Boolean);

    Procedure SetOrigVal(FVal  :  String);

    Procedure SetMaxListWidth(FVal  :  Integer);

    Procedure SetItemSwap(FVal  :  Boolean);

    Procedure SetExtList(FVal  :  Boolean);

    Procedure SetInDropDown(FVal  :  Boolean);

    Procedure SetValidate(FVal  :  Boolean);

    procedure SetItemsL(Value: TStringList);
    procedure SetItemsT(Value: TStringList);

    procedure CNCommand2(var Message: TWMCommand); message CN_COMMAND;

    procedure CNKeyDown(var Message: TWMKeyUp); message CN_KeyDown;

    procedure KeyPress(var Key: Char); override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    procedure WMLButtonDown2(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;

    procedure WMLButtonDblClk2(var Message: TWMLButtonDown); message WM_LBUTTONDblClk;

    procedure WMResetWidth(var Message: TMessage); message WM_User+1;

    Function DelayDrop(var Message: TWMCommand)  :  Boolean;

  public
    OldIndex  :  Integer;

    constructor Create(AOwner:TComponent); Override;
    destructor Destroy; Override;
    { Public declarations }
    procedure Loaded; override;

    property OrigValue  : String read fLastValue write SetOrigVal;

    property StillEdit  : Boolean  read fInEdit write fInEdit;

    property Modified: Boolean read fModified write SetModified default false;

    property ItemSwap: Boolean read fItemSwap write SetItemSwap default false;

    property InDropDown : Boolean read fInDropDown write SetInDropDown default false;

    property ItemsL: TStringList read FItemsL write SetItemsL;
    property ItemsT: TStringList read FItemsT write SetItemsT;


  published

    property AllowChangeInExit : Boolean read fAllowChangeInExit write SetAllowChangeInExit default False;

    property ExtendedList : Boolean read fExtendList  write SetExtList default false;

    property MaxListWidth  : Integer read fMaxListWidth write SetMaxListWidth;

    property ReadOnly: Boolean read FReadOnly write SetReadOnly default False;

    property Validate: Boolean read fValidate write SetValidate default False;
    //HV 09/11/2017 2018-R1: Highlighting PII Fields flag for GDPR
    property GDPREnabled: Boolean  read FGDPREnabled write FGDPREnabled default False;
  end;


{ ==============================================================================}

TSBSOutLine = class(TOutLine)
  private
    { Private declarations }
    FNoValCol,
    FSetCol       :  Byte;

    FColValue     :  Double;

    FCalcIdx      :  LongInt;

    FOnNeedValue  :  TNotifyEvent;

  protected
    { Protected declarations }

    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); OVERRIDE;

    Function GetVisibleIndex(ARow  :  LongInt)  :  LongInt;

    Procedure CalcVisibleIndex(Const ARow,
                                     AParent
                                            :  LongInt;
                               Var   RowCount,
                                     IdxCount,
                                     HighCount
                                            :  LongInt;
                               Var   FoundOk
                                            :  Boolean;
                               Const Depth  :  LongInt);

  public
    Property  SetCol    :  Byte read FSetCol write FSetCol;
    Property  ColValue  :  Double read FColValue write FColValue;

    Property  CalcIdx   :  LongInt read FCalcIdx write FCalcIdx;

  published
    { Published declarations }
    Property  ShowValCol  :  Byte read FNoValCol write FNoValCol;

    Property OnNeedValue  :  TNotifyEvent read FOnNeedValue write FOnNeedValue;
  end;


{ ==============================================================================}



TSBSPopupMenu = class(TPopUpMenu)
  private
  public
    CurrentPos  :  TPoint;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Popup(X, Y: Integer); Override;

  published

  end;

{ ==============================================================================}
TSBSUpDown = class(TUpDown)
  Private
    procedure CNCommand(var Message: TWMCommand);       message CN_COMMAND;
    procedure CNNotify(var Message: TWMNotify);         message CN_NOTIFY;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
  Published
end;

{ ==============================================================================}


Function FormatDecStrSD(NDec       : Integer;
                        DispFormat : String;
                        UseRegDec  : Boolean)  :  String;

{Function FormatDecStr(NDec       : Integer;
                      DispFormat : String)  :  String;}

procedure Register;

Const
  WM_CallViaComp  =  WM_User + $3; {* Mode: 1= Link to Cust, 2=Link to Stock *}


Var
  ISWINNT,
  ISAnyWINNT,
  ISWINNT4,
  ISWINNT5,
  IsWINXPTheme,
  IsWINXP  :  Boolean;
  IsGDPROn: Boolean;
  GDPRColor: Longint;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  SBSDCal,
  SBSOutL,
  SBSPrint,
  BorBtns,

  {$IFDEF PKG_On}
    DesignEditors,
    DesignIntf,
  {$ENDIF}

  CheckBoxEx,

  Animate,
  Clipbrd;


Const

  NumISet  = ['0'..'9','-','.','%'];

  CtrlISet = [#1..#31];


Function FormatDecStrSD(NDec       : Integer;
                        DispFormat : String;
                        UseRegDec  : Boolean)  :  String;

Var
  n       :  Byte;

  TmpStr  :  String;

  FDP,
  EDP     :  Array[1..2] of Integer;
  DecSep  :  Char;

begin
  If (UseRegDec) then
    DecSep:=DecimalSeparator
  else
    DecSep:='.';

  TmpStr:=DispFormat;

  For n:=1 to 2 do  {* Get pos of 2 dec places *}
  Begin
    FDP[n]:=Pos(DecSep,TmpStr);

    If (FDP[n]<>0) then
      TmpStr[FDP[n]]:=#32;
  end;

  EDP[1]:=Pos(';',TmpStr)-1;
  EDP[2]:=Pos('-',TmpStr);

  TmpStr:=Copy(DispFormat,1,FDP[1])+ConstStr('0',NDec)+
          Copy(DispFormat,EDP[1],(FDP[2]-EDP[1])+1)+ConstStr('0',NDec)+
          Copy(DispFormat,EDP[2],(Length(DispFormat)-EDP[2])+1);

  If (NDec=0) then {* remove dec places completely *}
    For n:=1 to 2 do
    Begin
      FDP[n]:=Pos(DecSep,TmpStr);

      If (FDP[n]<>0) then
        Delete(TmpStr,FDP[n],1);

    end; {Loop..}

  Result:=TmpStr;

end;


Function FormatDecStr(NDec       : Integer;
                      DispFormat : String)  :  String;

begin

  Result:=FormatDecStrSD(NDec,DispFormat,False);

end;


Procedure OverrideCaret(WHandle  :  HWnd;
                        Height   :  Integer);

Var
  n  :  Byte;

Begin
  n:=0;

  DestroyCaret;

  If IsWinNT then
    n:=2;

  If CreateCaret(WHandle,0,5,Height-(4+n)) then
    ShowCaret(WHandle);
end;



constructor TEditValue.Create(AOwner:TComponent);
begin
  Inherited Create(AOwner);
  FormatMask:='###,###,##0.00 ;###,###,##0.00-';
  NDecimals:=2;
  ValidOk:=False;
  FloatModified:=False;
  BeenEntered:=False;
  Font.Name:='Arial';
  Font.Size:=8;
end;

procedure TEditValue.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  {Params.Style := Params.Style or ES_MULTILINE or ES_RIGHT;}
end;

Procedure TEditValue.ValidateEdit;

Var
  p   :  Integer;
  mbRet
      :  Word;

  TF  :  Double;

Begin
  Val(EditText,TF,P);

  ValidOk:=(P=0);

  If (Not ValidOk) and not (csDesigning in ComponentState) then
  Begin
    mbRet:=MessageDlg(EditText+' is not a valid value.',mtError,[mbok],0);
    EditText:=Text;
    if CanFocus then
      SetFocus;
    SelectAll;
  end;

end;



Procedure TEditValue.SetFloatVal(FVal  :  Double);

Begin
  FFloatVal:=FVal;


  Text:=FormatFloat(FormatMask,FFloatVal);
end;

Procedure TEditValue.SetFormatMask(FVal  :  String);
Begin

  FFormatMask:=FVal;

end;

Procedure TEditValue.SetNDecimals(FVal  :  Integer);
Begin

  FNDecimals:=FVal;
end;

procedure TEditValue.KeyPress(var Key: Char);
begin

  If (Not (Key In NumISet+CtrlISet)) then
  Begin

    MessageBeep(0);
    Key:=#0;

  end;

  If (Key<>#0) then
    inherited KeyPress(Key);

end;

procedure TEditValue.CMExit(var Message: TCMExit);
Var
  TmpStr   :  String[50];

  ChkFloat :  Double;

begin

  If (BeenEntered) then
  Begin
    ValidateEdit;

    If (ValidOk) then
    Begin
      TmpStr:=Text;

      ChkFloat:=StrToFloat(TmpStr);

      FloatModified:=(FloatValue<>ChkFloat);

      FloatValue:=ChkFloat;

      BeenEntered:=False;

      inherited;
    end;
  end;
end;


procedure TEditValue.CMEnter(var Message: TCMEnter);

Var
  TmpStr  :  String[50];

begin

  TmpStr:='';

  BeenEntered:=True;

  Str(FloatValue:0:NDecimals,TmpStr);

  Text:=TmpStr;

  SelectAll;

  inherited;

end;

{ ==============================================================================}


{ ================== TCurrency Edit methods ============== }

constructor TCurrencyEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  If (csDesigning in ComponentState) then
  Begin
    AutoSize := False;

    Font.Name:='ARIAL';
    Font.Size:=8;

    FieldValue := 0.0;
    f9Value:=0.0;
    AutoSelect := False;
    WantReturns := False;
    WantTabs:=False;

    FloatModified:=False;

    StillEdit:=False;

  end;

  HBeenForced:=False;

  WordWrap := False;

  Alignment := taRightJustify;

  Width := 80;

  Height := 25;

  fBlockNegative:=False;

  FNDecimals:=2;

  FieldValue := 0.0000000001; {* Force a change of value at run time *}

  {DefFormat :='###'+ThousandSeparator+'###'+ThousandSeparator+'##0'+DecimalSeparator+'00 ;###'+
               ThousandSeparator+'###'+ThousandSeparator+'##0'+DecimalSeparator+'00-';}

  DefFormat:='###,###,##0.00 ;###,###,##0.00-';

  DispFormat:=DefFormat;

  FormatText;

  FTextId := 0;
end;

procedure TCurrencyEdit.SetFormat(A: String);
begin
  if DispFormat <> A then
    begin
      DispFormat:= A;
      FormatText;
    end;
end;



procedure TCurrencyEdit.FormatDec(NDec  : Integer);

Begin

  DispFormat:=FormatDecStr(NDec,DispFormat);

end;

procedure TCurrencyEdit.SetNDecimals(A: Integer);
begin
  if FNDecimals<> A then
    begin
      DispFormat:=DefFormat;

      FormatDec(A);
      FNDecimals:= A;
      FormatText;
    end;
end;

procedure TCurrencyEdit.SetFieldValue(A: Extended);
begin
  if FieldValue <> A then
    begin
      FieldValue := A;

      {If Not (csLoading In ComponentState) then}
        FormatText;
    end;
end;


procedure TCurrencyEdit.SetfCurr(A: String);
begin
  if fCurr <> A then
    begin
      fCurr := A;

      {$IFDEF EN551}
        FormatText;

      {$ENDIF}

    end;
end;

Procedure TCurrencyEdit.ValidateEdit(T2Chk  :  String);

Var
  p   :  Integer;
  mbRet
      :  Word;

  TF  :  Extended;

Begin
  {Val(T2Chk,TF,P);

  ValidOk:=(P=0);}

  ValidOk:=True;

  Try
    TF:=StrToFloat(T2Chk);

  except
    On EConvertError do ValidOk:=False;
  end;

end;

procedure TCurrencyEdit.UnFormatText;
var
  TmpText : String;
  Tmp     : Byte;
  IsNeg   : Boolean;
begin
  IsNeg := (Pos('-',Text) > 0) or (Pos('(',Text) > 0);
  TmpText := '';
  For Tmp := 1 to Length(Text) do

    if Text[Tmp] in ['0'..'9',DecimalSeparator] then
      TmpText := TmpText + Text[Tmp];
  try
    If TmpText='' Then TmpText := '0'+DecimalSeparator+'00';

    If (TmpText[Length(TmpText)]=DecimalSeparator) then
      TmpText:=TmpText+'00';

    ValidateEdit(TmpText);

    If (ValidOk) and ((Not IsNeg) or (Not BlockNegative)) then
    Begin
      FieldValue := StrToFloat(TmpText);
      if IsNeg then FieldValue := -FieldValue;
    end
    else
    Begin
      FieldValue:=0;
      MessageBeep(mb_IconAsterisk);
    end;

  except
    MessageBeep(mb_IconAsterisk);
  end;
end;

procedure TCurrencyEdit.FormatText;
Var
  TmpS  :  String;

begin
  If (Not BlankOnZero) or (FieldValue<>0) then
  Begin
    TmpS := FormatFloat(DispFormat,FieldValue);

    If (ShowCurrency) then
      Text:=CurrencySymb+TmpS
    else
      Text:=TmpS;
  end
  else
    Text:='';
end;

procedure TCurrencyEdit.CMEnter(var Message: TCMEnter);
begin
  If (IsWinNT) and (Height<=21) then
  Begin
    HBeenForced:=True;
    Height:=22;
  end;

  LastValue:=Value;
  FloatModified:=False;

  SelectAll;
  inherited;
end;


procedure TCurrencyEdit.CMExit(var Message: TCMExit);
Var
  mbRet  :  Word;

begin

  UnformatText;

  If (ValidOk) then
  Begin
    FormatText;

    FloatModified:=(LastValue<>Value);
  end
  else
  Begin
    If (not (csDesigning in ComponentState)) then
    Begin
      mbRet:=MessageDlg(Text+' is not a valid value.',mtError,[mbok],0);
      if CanFocus then
        SetFocus;
      SelectAll;
    end;
  end;

  Inherited;

  If (IsWinNT) and (HBeenForced) then
  Begin
    Height:=21;
    HBeenForced:=False;
  end;

end;

procedure TCurrencyEdit.CNCommand(var Message: TWMCommand);

Begin

  Inherited;

end;


{Duplicated in Text8Pt}

procedure TCurrencyEdit.CNKeyDown(var Message: TWMKeyUp);
begin
  if not (csDesigning in ComponentState) then
    with Message do
    If (Parent is TSBSExtendedForm) then
    With TSBSExtendedForm(Parent) do
    If (Assigned(FocusFirst)) and (Assigned(FocusLast)) then
    Begin

      ForceFocus:=(CharCode In [VK_TAB,VK_DOWN,VK_UP,VK_RETURN,VK_F9]) and ((Self=FocusFirst) or (Self=FocusLast));

      If (Assigned(FocusLast)) and (ForceFocus) then
        ExitDirec:=(Self=FocusLast)
      else
        ExitDirec:=False;
    end;

  Inherited;
end;



procedure TCurrencyEdit.WMSetFocus(var Message: TMessage);

Begin
  Inherited;

  OverrideCaret(Self.Handle,ClientHeight);

end;

procedure TCurrencyEdit.KeyPress(var Key: Char);
Var
  TL  :  Integer;

begin
  if (Not (Key in ['0'..'9',DecimalSeparator,ThousandSeparator,'-',#8]))
    or ((Key='-') and (Pos('-',Text)<>0))
    {or ((Key=DecimalSeparator) and (Pos(DecimalSeparator,Text)<>0))}
    or ((Key=DecimalSeparator) and (DecPlaces=0)) Then
      Key := #0;

  If (Key=DecimalSeparator) and (Pos(DecimalSeparator,Text)<>0) and (Not ReadOnly) then {* Blank out any figures right of point *}
  Begin
    If (Pos(DecimalSeparator,Text)>SelStart) then
    Begin
      Text:=Copy(Text,1,SelStart)+Key;
      SelStart:=Length(Text);
    end;

    Key:=#0;
  end;

  inherited KeyPress(Key);
end;

procedure TCurrencyEdit.CreateParams(var Params: TCreateParams);

begin
  inherited CreateParams(Params);
  case Alignment of
    taLeftJustify  : Params.Style := Params.Style or ES_LEFT and Not ES_MULTILINE;
    taRightJustify : Params.Style := Params.Style or ES_RIGHT and Not ES_MULTILINE;
    taCenter       : Params.Style := Params.Style or ES_CENTER and Not ES_MULTILINE;
  end;
end;



procedure TCurrencyEdit.Loaded;

                                   
Begin
  Inherited Loaded;

  {If (IsWINNT) and (not (csDesigning in ComponentState)) then
  Begin
    If (Height<=21) then
      Height:=22;
  end;}

  WiggleHeight;
end;


procedure TCurrencyEdit.WiggleHeight;

Var
  THeight  :  Integer;

Begin
  If (IsWinNT) and (Height<=21) then
  Begin
    THeight:=Height;
    Height:=THeight+1;
    Height:=THeight;
  end;
end;

{ ==============================================================================}


{ ================== Date validation methods ============== }

constructor TEditDate.Create(AOwner:TComponent);
begin

  Inherited Create(AOwner);

  If (Not (csDesigning in ComponentState)) then
    DateValue:=Today;

  EditMask:='00'+DateSeparator+'00'+DateSeparator+'0000;0;';
  MaxLength:=10;

  Font.Name:='Arial';
  Font.Size:=8;
  ValidOk:=False;
  DateModified:=False;
  AutoSelect:=False;
end;



Procedure TEditDate.ValidateEdit;

Var
  p   :  Integer;
  mbRet
      :  Word;


Begin

  ValidOk:=((AllowBlank and (EmptyKey(Text,8) or (Text=PBareOutDate(''))))
            or (ValidDate(Date2Store(Text))));

  If (Not ValidOk) then
  Begin
    mbRet:=MessageDlg(EditText+' is not a valid date.',mtError,[mbok],0);
    DateValue:=OrigValue;
    if CanFocus then
    begin
      SetFocus;
      SetCursor(0);
    end;
  end;

end;



Procedure TEditDate.SetDateVal(FVal  :  String);

Begin
  FStoreDate:=FVal;


  Text:=PBareOutDate(FVal);
end;

Procedure TEditDate.SetOrigVal(FVal  :  String);

Begin
  If (FOrigValue<>FVal) then
    FOrigValue:=FVal;
end;

procedure TEditDate.CNKeyDown(var Message: TWMKeyUp);
begin
  if not (csDesigning in ComponentState) then
    with Message do
    If (Parent is TSBSExtendedForm) then
    With TSBSExtendedForm(Parent) do
    If (Assigned(FocusFirst)) and (Assigned(FocusLast)) then
    Begin

      ForceFocus:=(CharCode In [VK_TAB,VK_DOWN,VK_UP,VK_RETURN,VK_F9]) and ((Self=FocusFirst) or (Self=FocusLast));

      If (Assigned(FocusLast)) and (ForceFocus) then
        ExitDirec:=(Self=FocusLast)
      else
        ExitDirec:=False;
    end;

  Inherited;
end;


procedure TEditDate.KeyPress(var Key: Char);

Var
  TmpDte    :  TDateTime;
  dw,mw,yw  :  Word;

begin

  If (Key In ['+','-']) and (Not ReadOnly) and (Enabled) then
  Begin

    ValidateEdit;

    If (ValidOk) then
    Begin
      DateStr(Date2Store(Text),dw,mw,yw);

      TmpDte:=EncodeDate(yw,mw,dw);

      TmpDte:=TmpDte+(Ord(Key='+'))-(Ord(Key='-'));

      DecodeDate(TmpDte,yw,mw,dw);

      DateValue:=StrDate(yw,mw,dw);

      Modified:=True;
    end;

    Key:=#0;
  end;

  inherited KeyPress(Key);

end;

procedure TEditDate.DblClick;

var
  Pt       : TPoint;
  Shift    : Byte;
  CalForm  :  TCalForm;

begin
  inherited DblClick;

  If (Not ReadOnly) and (Enabled) then
  Begin

    try
      If (ValidDate(DateValue)) then
        InitialDate := StrToDate(POutDate(DateValue))
      else
        InitialDate:=0;
    except
      InitialDate := 0;
    end;

    CalForm:=TCalForm.Create(Owner);

    Try

      With CalForm.CalGrid do
      Begin
        Color:=Self.Color;
        Font.Color:=Self.Font.Color;
      end;


      case FPlacement of
                  {Move according to the offsets}

      cpOffsets : Pt := ClientToScreen(Point(OffsetX,OffsetY));
                  {Move up the height of the calendar}
      cpAbove   : Pt := ClientToScreen(Point(0,-CalForm.Height));
                  {Move down the height of the DateEdit control}
      cpBelow   : Pt := ClientToScreen(Point(0,Height));
                  {Move left the width of the calendar}
      cpLeft    : Pt := ClientToScreen(Point(-CalForm.Width,0));
                  {Move Right the width of the DateEdit control}
      cpRight   : Pt := ClientToScreen(Point(Width,0));
                  {Center on top of the DateEdit control}

      cpOnTop   : Pt := ClientToScreen(Point(-(CalForm.Width-Width) div 2,
                                             -(CalForm.Height-Height) div 2));
      cpAuto    : Pt := ClientToScreen(Point(0,Height));
    end;
    {If Ctl3D is on, shift it by an additional pixel up and to the left}
    if Ctl3D and (FPlacement <> cpOffsets) then Shift := 1 else Shift := 0;
    {Place the popup}

      CalForm.Left := Pt.X-Shift;
      CalForm.Top := Pt.Y-Shift;
      {Make sure the popup appears on the screen fully}
      if CalForm.Left < 0 then CalForm.Left := 0;

      if CalForm.Top < 0 then CalForm.Top := 0;
      if CalForm.Left + CalForm.Width > Screen.Width then
        CalForm.Left := Screen.Width - CalForm.Width;
      if CalForm.Top + CalForm.Height > Screen.Height then
        CalForm.Top := Screen.Height - CalForm.Height;

      {Show the popup - if exit is normal, assign date value to field}
      if (CalForm.ShowModal = mrOK) and (Not ReadOnly) then
        With CalForm.CalGrid do
          DateValue:= StrDate(Year,Month,Day);

      {Destroy the popup and release its memory}

      Modified:=CalForm.GridModified;
    finally

      CalForm.Release;

    end; {except..}

    {Select all the text on exit}
    SelectAll;
  end;
end;

procedure TEditDate.CMEnter(var Message: TCMEnter);
Begin

  OrigValue:=DateValue;

  inherited;
end;

procedure TEditDate.CMExit(var Message: TCMExit);
Var
  TmpStr  :  String[50];

begin

  ValidateEdit;

  If (ValidOk) then
  Begin
    TmpStr:=Text;

    DateValue:=Date2Store(TmpStr);

    DateModified:=(DateValue<>OrigValue);

    inherited;
  end;
end;


procedure TEditDate.WMSetFocus(var Message: TMessage);

Begin
  Inherited;

  OverrideCaret(Self.Handle,ClientHeight);

end;

{ ==============================================================================}


{ ================== Period validation methods ============== }

constructor TEditPeriod.Create(AOwner:TComponent);
begin

  Inherited Create(AOwner);

  EditMask:='00'+DateSeparator+'0000;0;';

  ViewMask:='00'+DateSeparator+'0000;0;';

  fTempMask:=EditMask;

  fInExitProc:=False;

  MaxLength:=7;

  Font.Name:='Arial';
  Font.Size:=8;
  ValidOk:=False;
  DateModified:=False;
  AutoSelect:=False;

  PeriodsInYear:=GlobPeriodsInYr;

  If (csDesigning in ComponentState) then
  Begin
    fHideDUpdate:=True;

    EPeriod:=1;

    fHideDUpdate:=False;

    EYear:=96;
  end;
end;


Procedure TEditPeriod.ValidateEdit;

Var
  p   :  Integer;
  mbRet
      :  Word;


Begin

  ValidOk:=((AllowBlank and (EmptyKey(Text,8) or (Text=PBareOutPeriod(''))))
            or (ValidPeriod(Period2Store(Text),PeriodsInYear)));

  If (Not ValidOk) then
  Begin
    mbRet:=MessageDlg(EditText+' is not a valid period.',mtError,[mbok],0);
    DateValue:=OrigValue;
    if CanFocus then
    begin
      SetFocus;
      SetCursor(0);
    end;
  end;

end;



Procedure TEditPeriod.SetDateVal(FVal  :  String);

Begin
  FStoreDate:=FVal;

  If (Not fHideDUpdate) then
    Text:=PBareOutPeriod(FVal);
end;


Procedure TEditPeriod.SetPeriod(FVal  :  Byte);

Begin

  If (FVal<>fPr) then
  Begin
    fPr:=FVal;

    If (Not fHideDUpdate) then
      DateValue:=StrPeriod(TXlateYrVal(EYear,False),fPr);

  end;


end;


Procedure TEditPeriod.SetYear(FVal  :  Integer);

Begin

  fYr:=FVal;

  If (Not fHideDUpdate) then
    DateValue:=StrPeriod(TXlateYrVal(fYr,False),EPeriod);

end;

Procedure TEditPeriod.InitPeriod(Var   fPr,fYr  :  Byte;
                                 Const SetPr,
                                       ViewPr   :  Boolean);

Begin
  If (SetPr) then
  Begin
    fHideDUpdate:=True;

    EPeriod:=fPr;

    fHideDUpdate:=False;

    EYear:=fYr;

    If (ViewPr) then
      ShowPeriod;
  end
  else
  Begin
    fPr:=EPeriod;
    fYr:=EYear;
  end;

end;

Procedure TEditPeriod.SetViewMask(FVal  :  String);

Begin
  If (FVal<>fViewMask) then
    fViewMask:=FVal;
end;

{ ========= Function to Inc/Dec Period ======== }

Procedure TEditPeriod.AdjPeriod(Var AMnth,AYr  :  Word;
                                    Id         :  Boolean);

Var
  Cnst  :  Integer;


Begin
  If (ID) then
    Cnst:=1
  else
    Cnst:=-1;

  Amnth:=Amnth+Cnst;

  If (AMnth>PeriodsInYear) or (AMnth<1) then
  Begin
    AMnth:=(Amnth-(PeriodsInYear*Cnst));

    AYr:=AdjYr(AYr,ID);

    If (Amnth>PeriodsInYear) or (Amnth<1) then
    Begin
      Amnth:=(Amnth-(1*Cnst));

      AdjPeriod(Amnth,Ayr,Id);
    end;
  end;
end;


procedure TEditPeriod.KeyPress(var Key: Char);

Var
  mw,yw  :  Word;

begin

  If (Key In ['+','-']) and (Not ReadOnly) and (Enabled) then
  Begin

    ValidateEdit;

    If (ValidOk) then
    Begin
      PeriodStr(Period2Store(Text),mw,yw);

      AdjPeriod(Mw,Yw,(Key='+'));

      DateValue:=StrPeriod(yw,mw);
    end;

    Key:=#0;
  end;

  inherited KeyPress(Key);

end;

procedure TEditPeriod.DblClick;

Var
  PsuedoDate  :  String[10];

begin

  fHideDUpdate:=True;

  PsuedoDate:=DateValue;

  DateValue:=Period2Store(Text);

  If (ValidPeriod(DateValue,PeriodsInYear)) then
  Begin
    If (Assigned(OnConvDate)) then
      DateValue:=OnConvDate(Self,DateValue,False)
    else
      DateValue:=DateValue+'01';
  end;

  inherited DblClick;

  if (ValidDate(DateValue)) then
  Begin
    fHideDUpdate:=False;

    If (Assigned(OnConvDate)) then
      DateValue:=OnConvDate(Self,DateValue,True)
    else
      DateValue:=Copy(DateValue,1,6);
  end
  else
    DateValue:=PsuedoDate;

  fHideDUpdate:=False;

  SelectAll;
end;

procedure TEditPeriod.CMEnter(var Message: TCMEnter);
Begin
  EditMask:=fTempMask;
  Text:=PBareOutPeriod(DateValue);
  OrigValue:=DateValue;
end;

Function TEditPeriod.RefreshValues  :  Boolean;

Var
  TmpStr  :  String[50];

Begin
  ValidateEdit;

  If (ValidOk) then
  Begin
    TmpStr:=Text;

    DateValue:=Period2Store(TmpStr);

    DateModified:=(DateValue<>OrigValue);

    fHideDUpdate:=True;

    EPeriod:=Part_Period('M',DateValue);
    EYear:=TxlateYrVal(Part_Period('Y',DateValue),True);

    fHideDUpdate:=False;

  end;

  Result:=ValidOk;
end;

procedure TEditPeriod.CMExit(var Message: TCMExit);
Var
  TmpStr  :  String[50];

begin

  Try
  {* Do not call inherited, as it seems to reset all the values each time *}
    fInExitProc:=True;

    If Assigned(OnExit) then
    Begin
      RefreshValues;
      OnExit(Self);
    end;

    {ValidateEdit;

    If (ValidOk) then
    Begin
      TmpStr:=Text;

      DateValue:=Period2Store(TmpStr);

      DateModified:=(DateValue<>OrigValue);

      fHideDUpdate:=True;

      EPeriod:=Part_Period('M',DateValue);
      EYear:=TxlateYrVal(Part_Period('Y',DateValue),True);

      fHideDUpdate:=False;

      ShowPeriod;

    end;} {V5.70, modded to allow hook to receive latest values}

    fInExitProc:=False;
    
    If (RefreshValues) then
      ShowPeriod;
  except
    fInExitProc:=False;
  end; {try..}
end;

procedure TEditPeriod.WMSetFocus(var Message: TMessage);

Begin
  Inherited;

  OverrideCaret(Self.Handle,ClientHeight);

end;

procedure TEditPeriod.ShowPeriod;
Var
  TmpPr  :  String[5];

Begin
  If Assigned(OnShowPeriod) and (Not fInExitProc) then
  Begin
    TmpPr:=OnShowPeriod(Self,EPeriod);

    {fTempMask:=EditMask;}

    If (Length(TmpPr)>2) then
    Begin
      EditMask:=ViewMask;
      Text:=TmpPr+Form_Int(TxLateYrVal(EYear,False),0);
    end;


  end;
end;



{ ==============================================================================}

{ == Text8Pt Methods == }

constructor Text8Pt.Create(AOwner:TComponent);
begin
  Inherited Create(AOwner);
  Font.Name:='Arial';
  Font.Size:=8;
  ControlStyle:=ControlStyle- [csOpaque];
  StillEdit:=False;
  OrigValue:='';
  FTextId := 0;
  ShowHiLight:=False;

  fAltMod:=False;
  FViaSBtn:=False;

  FOnSBSHook:=nil;
  
  FBtnWindow:=nil;
  FButton:=nil;

  //PR: 13/11/2017 ABSEXCH-19451
  FAllowPostedEdit := False;


end;

procedure Text8pt.PosArrows;

Begin
  If (ShowHiLight) and (Assigned(FBtnWindow)) then
  Begin

    FBtnWindow.SetBounds(Width-12, 1, 10, Height-4);

  end;
end;

procedure Text8pt.Loaded;
var
  lSp: TShape;
Begin
  Inherited;

  //HV 09/11/2017 2018-R1: Highlighting PII Fields flag for GDPR
  if IsGDPROn and FGDPREnabled and Self.Visible then
  begin
    Self.Width := Self.Width - 8;
    lSp := TShape.Create(Self);
    lSp.Parent := Self.Parent;
    lSp.Name := 'Shape' + Self.Name;
    lSp.Left := Self.Left + Self.Width + 1;
    lSp.Height := Self.Height - 1;
    lSp.Top := Self.Top + 1;
    lSp.Width := 7;
    lSp.Visible := True;
    lSp.Shape := stRectangle;
    if GDPRColor <> 0 then
      lSp.Brush.Color := GDPRColor
    else
      lSp.Brush.Color := GDPRDefaultColor;
    lSp.Brush.Style := bsSolid;
    lSp.Pen.Style := psClear;
  end;

  If (Not ShowHiLight) then
    CheckHiLite;

  If (ShowHiLight) then
  Begin
    FBtnWindow := TWinControl.Create(Self);
    FBtnWindow.Visible := ShowHiLight;
    FBtnWindow.Parent := Self;
    PosArrows;
    FButton := TUpDown.Create(Self);
    FButton.Visible := ShowHiLight;
    FButton.Parent := FBtnWindow;
    {FButton.Caption:='..';
    FButton.Font.Color:=clBlack;}
    FButton.ArrowKeys:=False;
    FButton.Min:=-1000;
    FButton.Max:=1000;
    FButton.ShowHint:=True;
    FButton.OnClick := ClickSpeed;
    FButton.SetBounds(0, 0, FBtnWindow.Width, FBtnWindow.Height);

    Hint:='Double click to drill down|Double clicking or using the down button will drill down to the record for this field. The up button will search for the nearest match.';
  end
  else
    If (Hint='Double click to drill down|Double clicking will drill down to the main record linked for this field.') then
      Hint:='';

  ShowHint:=True;  

end;


procedure Text8pt.CMExit(var Message: TCMExit);

begin

  inherited;

  fAltMod:=(Text<>OrigValue);

  ViaSBtn:=False;
end;


procedure Text8pt.CMEnter(var Message: TCMEnter);


begin

  If (Not StillEdit) then
  Begin
    OrigValue:=Text;
    fAltMod:=False;
  end;

  inherited;

end;

procedure Text8pt.SetEditRect;
var
  Loc: TRect;
begin
  Loc.Bottom := ClientHeight + 1;  {+1 is workaround for windows paint bug}

  If (ShowHiLight) and (Assigned(FButton)) then
    Loc.Right := ClientWidth - FButton.Width - 2
  else
    Loc.Right:=ClientWidth;

  Loc.Top := 0;
  Loc.Left := 0;
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));
end;



{procedure Text8pt.SetCursor(Pos: Integer);
const
  ArrowKey: array[Boolean] of Word = (VK_LEFT, VK_RIGHT);
var
  SelStart, SelStop: Integer;
  KeyState: TKeyboardState;
  NewKeyState: TKeyboardState;
  I: Integer;
begin
  if (Pos >= 1) and (ByteType(EditText, Pos) = mbLeadByte) then Dec(Pos);
  SelStart := Pos;
  if (IsMasked) then
  begin
    if SelStart < 0 then
      SelStart := 0;
    SelStop  := SelStart + 1;
    if (Length(EditText) > SelStop) and (EditText[SelStop] in LeadBytes) then
      Inc(SelStop);
    if SelStart >= FMaxChars then
    begin
      SelStart := FMaxChars;
      SelStop  := SelStart;
    end;

    SetSel(SelStop, SelStop);
    
    if SelStart <> SelStop then
    begin
      GetKeyboardState(KeyState);

      {for I := Low(NewKeyState) to High(NewKeyState) do
        NewKeyState[I] := 0;}

      {NewKeyState:=KeyState;

      NewKeyState [VK_SHIFT] := $81;
      NewKeyState [ArrowKey[UseRightToLeftAlignment]] := $81;
      SetKeyboardState(NewKeyState);
      FSettingCursor := True;
      try
        SendMessage(Handle, WM_KEYDOWN, ArrowKey[UseRightToLeftAlignment], 1);
        SendMessage(Handle, WM_KEYUP, ArrowKey[UseRightToLeftAlignment], 1);
      finally
        FSettingCursor := False;
      end;
      SetKeyboardState(KeyState);
    end;
    FCaretPos := SelStart;
  end
  else
  begin
    if SelStart < 0 then
      SelStart := 0;
    if SelStart >= Length(EditText) then
      SelStart := Length(EditText);
    SetSel(SelStart, SelStart);
  end;
end;}


procedure Text8pt.CreateParams(var Params: TCreateParams);

begin
  inherited CreateParams(Params);

  If (ShowHiLight) and (Assigned(FButton)) then
    Params.Style := Params.Style or ES_MULTILINE;
end;

procedure Text8pt.CreateWnd;
begin
  inherited CreateWnd;

  If (Assigned(FButton)) then
    SetEditRect;
end;

{* This message needed, as as soon as Multi Line is set, the control acts like a memo and grabs all the keys *}
procedure Text8pt.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  if ShowHiLight then
    Message.Result := Message.Result and not DLGC_WANTALLKEYS;
end;



procedure Text8pt.WMSetFocus(var Message: TMessage);

Begin
  Inherited;

  OverrideCaret(Self.Handle,ClientHeight);

  If (ShowHiLight) then  {* As a multi line control, by default, the contents are not auto selected *}
    SelectAll;

end;

{* This would need to be added to all the other controls which are liekyl to reside on the extended form *}
{Duplicated in TCurrency Edit}

procedure Text8pt.CNKeyDown(var Message: TWMKeyUp);
begin
    if not (csDesigning in ComponentState) then
    with Message do
    If (Parent is TSBSExtendedForm) then
    With TSBSExtendedForm(Parent) do
    If (Assigned(FocusFirst)) and (Assigned(FocusLast)) then
    Begin

      ForceFocus:=(CharCode In [VK_TAB,VK_DOWN,VK_UP,VK_RETURN,VK_F9]) and ((Self=FocusFirst) or (Self=FocusLast));

      If (Assigned(FocusLast)) and (ForceFocus) then
        ExitDirec:=(Self=FocusLast)
      else
        ExitDirec:=False;
    end;

  Inherited;
end;


procedure Text8pt.WMPostHook(var Message: TMessage);
begin
  If Assigned(OnEntHookEvent) then
    OnEntHookEvent(Self);
end;

Procedure Text8pt.ExecuteHookMsg;

Begin
  PostMessage(Self.Handle,WM_User+$40,0,0);

end;


Procedure Text8pt.SetOrigVal(FVal  :  String);

Begin
  If (FLastValue<>FVal) then
    FLastValue:=FVal;
end;

Procedure Text8Pt.ForceEnd;

Begin
  SetCursor(Length(Text));
end;

Procedure Text8pt.SetLinkCust(FBo  :  Boolean);

Begin
  If (fLinkCust<>FBo) then
  Begin
    fLinkCust:=FBo;

    If (fLinkStock) then
      fLinkStock:=Not fLinkCust;

    If (fLinkJob) then
      fLinkJob:=Not fLinkCust;

    CheckHiLite;
  end;
end;

Procedure Text8pt.SetLinkStock(FBo  :  Boolean);

Begin
  If (fLinkStock<>FBo) then
  Begin
    fLinkStock:=FBo;

    If (fLinkCust) then
      fLinkCust:=Not fLinkStock;

    If (fLinkJob) then
      fLinkJob:=Not fLinkCust;

    CheckHiLite;
  end;
end;

Procedure Text8pt.SetLinkJob(FBo  :  Boolean);

Begin
  If (fLinkJob<>FBo) then
  Begin
    fLinkJob:=FBo;

    If (fLinkCust) then
      fLinkCust:=Not fLinkJob;

    If (fLinkStock) then
      fLinkStock:=Not fLinkJob;

    CheckHiLite;
  end;
end;


Procedure Text8pt.SetHiLite(FBo  :  Boolean);

Begin
  If (fHiLite<>FBo) then
  Begin
    fHiLite:=FBo;

  end;
end;

Procedure Text8pt.CheckHiLite;

Begin
  SetHiLite(Link_to_Cust or Link_to_Stock or Link_to_Job);

end;

Procedure Text8pt.SendLinkMsg;

Type
  S20  =  String[20];

Var
  CCode  :  ^S20;

Begin
  New(CCode);

  CCode^:=Text;

  SendMessage(Application.MainForm.Handle,WM_CallViaComp,1+(1*Ord(Link_to_Stock))+(2*Ord(Link_to_Job)),LongInt(@CCode^));

end;


procedure Text8pt.DblClick;

Begin
  If (Link_to_Cust) or (Link_to_Stock) or (Link_to_Job) and (Text<>'') then
    SendLinkMsg;

  Inherited DblClick;

  ViaSBtn:=False;
end;

{procedure Text8Pt.ClickSpeed(Sender: TObject);

Begin

  DblClick;
end;}

procedure Text8Pt.ClickSpeed(Sender: TObject; Button: TUDBtnType);

Begin
  If (Sender is TUpDown) then
    With TUpDown(Sender) do
    Begin
      If ((Button=btPrev) and (Text<>'')) or (ReadOnly) or (Not Enabled) then
      Begin
        ViaSBtn:=True;
        DblClick;
      end
      else
        If (Assigned(Self.OnExit)) and (Not ReadOnly) and (Enabled) then
        Begin
          Modified:=(Text<>fLastValue);

          {Self.OnExit(Self);}

          If (Modified) then
          Begin
            ViaSBtn:=True;
            PostMEssage(Self.Handle,CM_Exit,0,0);

          end;
        end;

    end;
end;

// CJS 2015-10-21 - ABSEXCH-15598 - paste into edit fields includes tabs
procedure Text8pt.WMPaste(var Message: TWMPaste);
Var
  SaveClipboard, ModifiedText : String;
  I : Integer;
Begin // WMPaste
  // Save original clipboard text so we don't change it permanently
  SaveClipboard := Clipboard.AsText;

  // Check for any TAB characters
  I := Pos(#9, SaveClipboard);
  If (I > 0) Then
  Begin
    // Temporarily replace the Clipboard text with a modified version with no tabs
    Clipboard.AsText := StringReplace(SaveClipboard, #9, ' ', [rfReplaceAll]);

    Inherited;

    // Restore original unmodified clipboard text
    Clipboard.AsText := SaveClipboard;
  End // If (I > 0)
  Else
    // No tabs - just call the default behaviour
    Inherited;
End; // WMPaste

{ ==============================================================================}

{ == ExMaskEdit Methods == }

procedure TExMaskEdit.ValidateError;
begin
  if Assigned(OnMaskError) then OnMaskError(Self);
end;

procedure TExMaskEdit.ValidateEdit;
var
  Str: string;
  Pos: Integer;
  bSetFocus : boolean;
begin
  Str := EditText;
  if IsMasked and Modified then
  begin
    if not Validate(Str, Pos) then
    begin
      if not (csDesigning in ComponentState) then
      begin
        bSetFocus := TRUE;
        if Assigned(fOnSetFocusBack) then
          OnSetFocusBack(Self, bSetFocus);
        if bSetFocus then
        begin
//          Include(FMaskState, msReEnter);
          SetFocus;
        end;
      end;
      SetCursor(Pos);
      ValidateError;
    end;
  end;
end;




{ ==============================================================================}




{ ================== Label8 methods ============== }

constructor Label8.Create(AOwner:TComponent);
begin
  Inherited Create(AOwner);
  Font.Name:='Arial';
  Font.Size:=8;
  FTextId := 0;
end;

Function Label8.CheckReSize  :  Boolean;

Begin
  Result:=FWChange;

  FWChange:=False;
end;

procedure Label8.WMNCHitTest(var Msg: TWMNCHitTest);
begin
  inherited;
  FHitTest := SmallPointToPoint(Msg.Pos);
end;

procedure Label8.WMSetCursor(var Msg: TWMSetCursor);
var
  Cur: HCURSOR;
  I: Integer;
  X: Integer;
begin
  Cur := 0;

  ReadytoDrag:=False;

  FHitTest := ScreenToClient(FHitTest);

  with Msg do
  Begin
    if HitTest = HTCLIENT then
    Begin
      If (FHitTest.X>=(Width-5)) and (FHitTest.X<=Width) and (FHitTest.Y>=0) and (FHitTest.Y<=Height) then
      begin
        Cur := LoadCursor(0, IDC_SIZEWE);
        ReadytoDrag:=TRUE;
      end;
    end;
  end;

  If (Cur<>0) then
    SetCursor(Cur)
  else
    Inherited;
end;


procedure Label8.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if (Button = mbLeft) and (ReadytoDrag) then
  Begin
    BringToFront;
    SetCapture(Canvas.Handle);
  end;

  CurrWidth:=Width;
end;


procedure Label8.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if (ReadytoDrag) then
  begin

    ReleaseCapture;
    ReadytoDrag:=FALSE;
  end;

  Resized:=(Width<>CurrWidth);

  inherited MouseUp(Button, Shift, X, Y);
end;

procedure Label8.MouseMove(Shift: TShiftState; X, Y: Integer);

begin
  inherited MouseMove(Shift, X, Y);

  if (GetCapture = Canvas.Handle) and (ReadytoDrag) then
  begin
    Width:=X+3;

    Refresh;
  end;
end;

{ ==============================================================================}


{ == TSBSComboBox Methods == }

constructor TSBSComboBox.Create(AOwner:TComponent);
begin
  Inherited Create(AOwner);
  Font.Name:='Arial';
  Font.Size:=8;
  ControlStyle:=ControlStyle- [csOpaque];
  StillEdit:=False;
  OrigValue:='';
  FItemsL := TStringList.Create;
  FItemsT := TStringList.Create;
  fDelayCount:=0;

  fNormWidth:=Width;
  fValidate:=False;
  OldIndex:=0;
end;



destructor TSBSComboBox.Destroy;
begin
  FItemsL.Free;
  FItemsT.Free;
  inherited Destroy;
end;


Function TSBSComboBox.Set_AutoIndex  :  Integer;

Var

  n        :  Integer;

  FoundOk  :  Boolean;

  LText    :  ShortString;



Begin
  If (ItemIndex>=0) then
    Result:=ItemIndex
  else
    Result:=0;

  FoundOk:=False;

  LText:=UpperCase(TrimRight(Text));

  With Items do
    For n:=0 to Pred(Count) do
    Begin
      FoundOk:=(CompareText(LText,UpperCase(Copy(Strings[n],1,Length(LText))))=0);

      If (Not FoundOk) and (ExtendedList) then
        FoundOk:=(CompareText(LText,UpperCase(Copy(ItemsL.Strings[n],1,Length(LText))))=0);


      If (FoundOk) then
        Break;

    end; {with..}

  If (FoundOk) then
    Result:=n;
end;


procedure TSBSComboBox.CMExit(var Message: TCMExit);

Var
  LastII  :  Integer;
begin

  If (Not Modified) then
    Modified:=(OrigValue<>Text);

  If (Validate) and (Style=csDropDown) and (fKeyTyped) then
    ItemIndex:=Set_AutoIndex;

  LastII:=ItemIndex;
  inherited;

  If (LastII<>ItemIndex) and (Not AllowChangeInExit) then
    ItemIndex:=LastII;
end;


procedure TSBSComboBox.CMEnter(var Message: TCMEnter);


begin
  fKeyTyped:=False;

  If (Not StillEdit) then
    OrigValue:=Text;

  inherited;

end;

Procedure TSBSComboBox.SetOrigVal(FVal  :  String);

Begin
  If (FLastValue<>FVal) then
    FLastValue:=FVal;
end;


Procedure TSBSComboBox.SetMaxListWidth(FVal  :  Integer);

Begin
  If (fMaxListWidth<>FVal) then
    fMaxListwidth:=FVal;
end;

Procedure TSBSComboBox.SetModified(FVal  :  Boolean);

Begin
  If (Fmodified<>FVal) then
    Fmodified:=FVal;
end;

Procedure TSBSComboBox.SetItemSwap(FVal  :  Boolean);

Begin
  If (fItemSwap<>FVal) then
    fItemSwap:=FVal;
end;

Procedure TSBSComboBox.SetAllowChangeInExit(FVal  :  Boolean);

Begin
  If (fAllowChangeInExit<>FVal) then
    fAllowChangeInExit:=FVal;
end;

Procedure TSBSComboBox.SetExtList(FVal  :  Boolean);

Begin
  If (fExtendList<>FVal) then
    fExtendList:=FVal;
end;

Procedure TSBSComboBox.SetInDropDown(FVal  :  Boolean);

Begin
  If (fInDropDown<>FVal) then
    fInDropDown:=FVal;
end;

Procedure TSBSComboBox.SetValidate(FVal  :  Boolean);

Begin
  If (fValidate<>FVal) then
    fValidate:=FVal;
end;

procedure TSBSComboBox.SetReadOnly(Value: Boolean);
begin
  if FReadOnly <> Value then
  begin
    FReadOnly := Value;
    if HandleAllocated then
      SendMessage(Handle, EM_SETREADONLY, Ord(Value), 0);
  end;
end;

procedure TSBSComboBox.SetItemsL(Value: TStringList);
Var
  n  :  Byte;
begin
  ItemsL.Assign(Value);


  For n:=0 to Pred(ItemsL.Count) do
    If (Canvas.TextWidth(ItemsL[n])>MaxListWidth) then
      MaxListWidth:=Canvas.TextWidth(ItemsL[n]);
end;


procedure TSBSComboBox.SetItemsT(Value: TStringList);
begin
  ItemsT.Assign(Value);
end;

procedure TSBSComboBox.KeyPress(var Key: Char);
begin

  If (ReadOnly) then
    Key:=#0
  else
  Begin
    fKeyTyped:=((Key In [#32..#255]) or fKeyTyped);

    inherited KeyPress(Key);
  end;

end;


{* This would need to be added to all the other controls which are liekyl to reside on the extended form *}
{Duplicated in TCurrency Edit}

procedure TSBSComboBox.CNKeyDown(var Message: TWMKeyUp);
begin
  if not (csDesigning in ComponentState) then
    with Message do
    If (Parent is TSBSExtendedForm) then
    With TSBSExtendedForm(Parent) do
    If (Assigned(FocusFirst)) and (Assigned(FocusLast)) then
    Begin

      ForceFocus:=(CharCode In [VK_TAB,VK_DOWN,VK_UP,VK_RETURN,VK_F9]) and ((Self=FocusFirst) or (Self=FocusLast));

      If (Assigned(FocusLast)) and (ForceFocus) then
        ExitDirec:=(Self=FocusLast)
      else
        ExitDirec:=False;
    end;

  Inherited;
end;


procedure TSBSComboBox.KeyDown(var Key: Word; Shift: TShiftState);
Begin
  If (ReadOnly) then
    Key:=0
  else
    inherited KeyDown(Key,Shift);

end;

procedure TSBSComboBox.WMResetWidth(var Message: TMessage);

Begin
  Width:=fNormWidth;
end;




{** Routine to intercept a request to show the combo box and delay it untill the extended box is displayed **}

Function TSBSComboBox.DelayDrop(var Message: TWMCommand)  :  Boolean;

Begin
  Result:=False;

  {$B-}

  If (Message.NotifyCode=CBN_DropDown) and (Parent is TSBSExtendedForm) then

  {$B+}
    With TSBSExtendedForm(Parent) do
    Begin
      If (NewSetting) or (Not ReadyForCombo) then
      Begin
        Inc(fDelayCount);

        If (fDelayCount<4) then
        Begin
          Result:=True;

          DropCBHandle:=Self.Handle;

        end
        else
          fDelayCount:=0;
      end
      else
        fDelayCount:=0;


    end;

end;

procedure TSBSComboBox.CNCommand2(var Message: TWMCommand);

Var
  OldItemIndex  :  Integer;

begin
  If (Not DelayDrop(Message)) then
  Begin
    case Message.NotifyCode of
      CBN_DBLCLK:
        If (ReadOnly) then
        Begin
          FillChar(Message,Sizeof(Message),0);
          Exit;
        end;

      CBN_EDITUPDATE,
      CBN_EDITCHANGE:
      Begin

      end;

      CBN_DROPDOWN:
        If (Not ReadOnly) then
        begin
          fNormWidth:=Width;

          InDropDown:=True;

          If (ExtendedList) then
          Begin
            If (MaxListWidth<>0) then
              Width:=MaxListWidth;

            OldItemIndex:=ItemIndex;
            ItemsT.Assign(Items);
            Items.Assign(ItemsL);
            ItemIndex:=OldItemIndex;

            ItemSwap:=True;
          end;

        end
        else
        Begin
          FillChar(Message,Sizeof(Message),0);
          Exit;
        end;

      CBN_SELCHANGE:
        begin

        end;
      CBN_SETFOCUS:
        begin

        end;
      CBN_KILLFOCUS:
        begin

        end;
      CBN_SELENDOK,
      CBN_CLOSEUP,
      CBN_SELENDCANCEL:
      Begin

        If (Not ReadOnly) and (fNormWidth<>0) and (ExtendedList) and (ItemSwap) and (Not ISWINNT) then
          Width:=fNormWidth;


        InDropDown:=False;

        If (ItemSwap) then
        Begin
          OldItemIndex:=ItemIndex;

          Items.Assign(ItemsT);

          ItemIndex:=OldItemIndex;

          If (Not ReadOnly) and (fNormWidth<>0) and (ExtendedList) and (ISWINNT) then
            PostMessage(Self.Handle,WM_User+1,0,0);

          ItemSwap:=False;
        end;


      end;

    end;

    Inherited;
  end;
end;

procedure TSBSComboBox.WMLButtonDown2(var Message: TWMLButtonDown);
Begin
  If (Not ReadOnly) then
    Inherited;
end;

procedure TSBSComboBox.WMLButtonDblClk2(var Message: TWMLButtonDown);
Begin
  If (Not ReadOnly) then
    Inherited;
end;



{ ==============================================================================}


{ == TSBSOutLine Methods == }


Procedure TSBSOutline.CalcVisibleIndex(Const ARow,
                                             AParent
                                                   :  LongInt;
                                       Var   RowCount,
                                             IdxCount,
                                             HighCount
                                                   :  LongInt;
                                       Var   FoundOk
                                                   :  Boolean;
                                       Const Depth :  LongInt);
Var
  NewIdx  :  LongInt;


Begin
  NewIdx:=0;

  While (Not FoundOk) and (RowCount<=ARow) and (IdxCount>0) do
  Begin
    FoundOk:=(ARow=RowCount);

    If (Not FoundOk) then
    Begin
      If (Items[IdxCount].Expanded) then
      Begin
        NewIdx:=Items[IdxCount].GetFirstChild;

        If (NewIdx>0) then
        Begin
          Inc(RowCount);

          CalcVisibleIndex(ARow,IdxCount,RowCount,NewIdx,HighCount,FoundOk,Depth+1);

          If (FoundOk) then
            IdxCount:=NewIdx
          else
            If (Depth=0) then
              IdxCount:=HighCount;
        end;
      end; {If expanded..}

      If (Not FoundOk) then
      Begin
        If (Depth>0) then
          IdxCount:=Items[AParent].GetNextChild(IdxCount)
        else
        Begin
          Repeat
            If (IdxCount<ItemCount) then
              Inc(IdxCount)
            else
              IdxCount:=-1;

          Until (IdxCount<1) or (Items[IdxCount].Level=Cardinal(Depth+1));

        end;

        If (IdxCount>HighCount) then {Keep largest tracked so we don't need to keep repeating}
          HighCount:=IdxCount;

        If (IdxCount>0) then
          Inc(RowCount);
      end;
    end; {If no match found..}
  end; {While..}
end; {Proc..}

Function TSBSOutline.GetVisibleIndex(ARow  :  LongInt)  :  LongInt;

Var
  RowCount,
  IdxCount,
  HighCount :  LongInt;

  FoundOk   :  Boolean;


Begin
  Result:=-1;
  FoundOk:=False;

  IdxCount:=1;
  RowCount:=0;
  HighCount:=0;

  CalcVisibleIndex(ARow,IdxCount,RowCount,IdxCount,HighCount,FoundOk,0);

  If (FoundOk) then
    Result:=IdxCount;
end;


procedure TSBSOutline.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);

Var
  Tx         :  String;
  N          :  Byte;
  Node: TOutlineNode;
  Expanded: Boolean;
  HasChildren: Boolean;
  IndentLevel: Word;
  Bitmap1, Bitmap2: TBitmap;
  TextLength: Integer;
  Delta: Integer;
  InitialLeft: Integer;




procedure DrawTheValue(Const ValCol  :  Byte;
                       Const Value   :  Double);

Const
  LargeValMask  =  '999999999999.99';

VAR
    R,MR      : TRect;
    S         : String;

    NomVal    : Double;



begin
  NomVal:=Value;
  With Canvas do
  Begin
    TextLength := TextWidth(Tx) + 1;
    SetTextAlign(Handle, TA_RIGHT); {Windows API function}

    S := Form_Real(NomVal,0,2);

    MR:=ARect;
    MR.Left:=MR.Right-((TextWidth(LargeValMask)+10)*ValCol);

    MR.Right:=MR.Right-((TextWidth(LargeValMask)+10)*Pred(ValCol));

    R := MR;

    R.Right := R.Right - TextWidth('.'+ConstStr('0',2)) - 4;

    IF Pos('.', S) > 0 THEN
      S := Copy(S, 1, Pos('.', S)-1);

    TextRect(R, R.Right, R.Top, S); {note R.Right, not R.Left}

    S := Form_Real(NomVal,0,2);


    IF Pos('.', S) > 0 THEN
      S := Copy(S, Pos('.', S), 255)
    ELSE S := '.';

    SetTextAlign(Handle, TA_LEFT);
    R.Left := R.Right;
    R.Right := MR.Right;
    TextRect(R, R.Left, R.Top, S);
  end; {With..}
end;


Begin

  Inherited DrawCell(ACol,ARow,ARect,AState);

  If (ItemCount>0) then {* Show balances *}
  Begin
    CalcIdx:=GetVisibleIndex(ARow);

    
    If (ShowValCol>0) and (CalcIdx>0) then
    Begin

      Tx:=Items[CalcIdx].Text;

      For n:=1 to ShowValCol do
      Begin
        SetCol:=n;
        ColValue:=0.00;

        If Assigned(OnNeedValue) then
          OnNeedValue(Self);

        If (ColValue<>0) then
          DrawTheValue(N,ColValue);

      end;
    end;

  end;

end;



constructor TSBSPopupMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  WindowHandle:=TWinControl(AOWner).Handle;
  With CurrentPos do
  Begin
    X:=0; Y:=0;
  end;
end;

destructor TSBSPopupMenu.Destroy;
begin
  inherited Destroy;
end;


Procedure TSBSPopupMenu.PopUp(X,Y  :  Integer);
Begin
  CurrentPos.X:=X;
  CurrentPos.Y:=Y;

  Inherited PopUp(X,Y);
end;

procedure TSBSUpDown.CNCommand(var Message: TWMCommand);

Begin


  Inherited;

end;

procedure TSBSUpDown.CNNotify(var Message: TWMNotify);
begin
  with Message.NMHdr^ do
  begin
    {case code of
      UDN_DELTAPOS: LongBool(Message.Result) := not CanChange;
    end;}
  end;


  Inherited;
end;


procedure TSBSUpDown.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
  Begin
    If (CharCode In [Ord('+'),Ord('-')]) and CanFocus then
    begin
      Position:=Position+Ord(Chr(CharCode)='+')-Ord(Chr(CharCode)='-');

      If (Assigned(Associate)) then
      Begin
        If (Associate is TCurrencyEdit) then
        Begin
          If (Assigned(TCurrencyEdit(Associate).OnChange)) then
            TCurrencyEdit(Associate).OnChange(Self);
        end;
      end;
    end
    else
      inherited;
  end; {With..}
end;





procedure Register;
begin

  SBSOutL.Register;
  SBSPrint.Register;
  BorBtns.Register;
  CheckBoxEx.Register;

  RegisterComponents('SBS', [Text8Pt,
                             TExMaskEdit,
                             TEditValue,
                             TCurrencyEdit,
                             TEditDate,
                             TEditPeriod,
                             Label8,
                             TSBSComboBox,
                             TSBSUpDown,
                             TSBSOutLine,
                             TSBSPanel,
                             TSBSGroup,
                             TSBSAccelLabel,
                             TSBSBackGroup,
                             TSBSCBox,
                             TSBSPopUpMenu,
                             TSBSExtendedForm,
                             TAnimated]);

  {$IFDEF PKG_On}
    RegisterComponentEditor(TSBSExtendedForm, TSBSExtFormEditor);
  {$ENDIF}
end;

procedure TSBSComboBox.Loaded;
var
  lSp: TShape;
begin
  inherited;
  
  //HV 09/11/2017 2018-R1: Highlighting PII Fields flag for GDPR
  if IsGDPROn and FGDPREnabled and Self.Visible then
  begin
    Self.Width := Self.Width - 8;
    lSp := TShape.Create(Self);
    lSp.Parent := Self.Parent;
    lSp.Name := 'Shape' + Self.Name;
    lSp.Left := Self.Left + Self.Width + 1;
    lSp.Height := Self.Height - 1;
    lSp.Top := Self.Top + 1;
    lSp.Width := 7;
    lSp.Visible := True;
    lSp.Shape := stRectangle;
    if GDPRColor <> 0 then
      lSp.Brush.Color := GDPRColor
    else
      lSp.Brush.Color := GDPRDefaultColor; 
    lSp.Brush.Style := bsSolid;
    lSp.Pen.Style := psClear;
  end;
end;

//HV 17/11/2017 2018-R1: Highlighting PII Fields flag for GDPR
procedure TEditDate.Loaded;
var
  lSp: TShape;
begin
  inherited;
  //HV 17/11/2017 2018-R1: Highlighting PII Fields flag for GDPR
  if IsGDPROn and FGDPREnabled and Self.Visible then
  begin
    Self.Width := Self.Width - 8;
    lSp := TShape.Create(Self);
    lSp.Parent := Self.Parent;
    lSp.Name := 'Shape' + Self.Name;
    lSp.Left := Self.Left + Self.Width + 1;
    lSp.Height := Self.Height - 1;
    lSp.Top := Self.Top + 1;
    lSp.Width := 7;
    lSp.Visible := True;
    lSp.Shape := stRectangle;
    if GDPRColor <> 0 then
      lSp.Brush.Color := GDPRColor
    else
      lSp.Brush.Color := GDPRDefaultColor;
    lSp.Brush.Style := bsSolid;
    lSp.Pen.Style := psClear;
  end;
end;

procedure Text8Pt.CMVisibleChanged(var Message: TMessage);
var
  lShapeCtrl: TComponent;
begin
  Inherited;
  if Self.GDPREnabled then
  begin
    lShapeCtrl := FindComponent('Shape'+Self.Name);
    if Assigned(lShapeCtrl) then
      TWinControl(lShapeCtrl).Visible := Self.Visible;
  end;
end;

procedure TEditDate.CMVisibleChanged(var Message: TMessage);
var
  lShapeCtrl: TComponent;
begin
  Inherited;
  if IsGDPROn and FGDPREnabled then
  begin
    lShapeCtrl := FindComponent('Shape'+Self.Name);
    if Assigned(lShapeCtrl) then
      TWinControl(lShapeCtrl).Visible := Self.Visible;
  end; 
end;

procedure Text8Pt.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  lShapeCtrl: TComponent;
begin
  inherited;
  if IsGDPROn and FGDPREnabled and Self.Visible then
  begin
    lShapeCtrl := FindComponent('Shape'+Self.Name);
    if Assigned(lShapeCtrl) then
      TWinControl(lShapeCtrl).Top := Self.Top + 1;
  end;
end;

procedure TEditDate.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  lShapeCtrl: TComponent;
begin
  inherited;
  if IsGDPROn and FGDPREnabled and Self.Visible then
  begin
    lShapeCtrl := FindComponent('Shape'+Self.Name);
    if Assigned(lShapeCtrl) then
      TWinControl(lShapeCtrl).Top := Self.Top + 1;
  end;
end;

Initialization

  ISWINNT:=False;
  ISAnyWINNT:=False;
  ISWINNT4:=False;
  ISWINNT5:=False;
  IsWinXP:=False;
  IsWINXPTheme:=False;
  IsGDPROn:=False;
  GDPRColor:=0;

end.

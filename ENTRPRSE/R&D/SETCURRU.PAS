unit SetCurrU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, BorBtns, ExtCtrls,
  GlobVar,VarConst,VarRec2U,BTSupU1, SBSPanel, ComCtrls;


type
  TSetCurrRec = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Panel1: TPanel;
    Label82: Label8;
    Label83: Label8;
    Label84: Label8;
    Label85: Label8;
    Label86: Label8;
    Label826: Label8;
    Label829: Label8;
    Label842: Label8;
    Label843: Label8;
    Label844: Label8;
    SBSPanel1: TSBSPanel;
    CanCP1Btn: TButton;
    OkCP1Btn: TButton;
    ScrollBox1: TScrollBox;
    Label0: Label8;
    Label1: Label8;
    Label3: Label8;
    Label2: Label8;
    Label4: Label8;
    Label5: Label8;
    Label6: Label8;
    Label7: Label8;
    Label12: Label8;
    Label13: Label8;
    Label14: Label8;
    Label15: Label8;
    Label11: Label8;
    Label10: Label8;
    Label9: Label8;
    Label8: Label8;
    Label27: Label8;
    Label26: Label8;
    Label25: Label8;
    Label24: Label8;
    Label23: Label8;
    Label22: Label8;
    Label21: Label8;
    Label20: Label8;
    Label19: Label8;
    Label18: Label8;
    Label17: Label8;
    Label16: Label8;
    Label28: Label8;
    Label29: Label8;
    CDesc0: Text8Pt;
    CSS0: Text8Pt;
    PS0: Text8Pt;
    DR0: TCurrencyEdit;
    CR0: TCurrencyEdit;
    CDesc1: Text8Pt;
    CSS1: Text8Pt;
    PS1: Text8Pt;
    DR1: TCurrencyEdit;
    CR1: TCurrencyEdit;
    CDesc3: Text8Pt;
    CSS3: Text8Pt;
    Ps3: Text8Pt;
    DR3: TCurrencyEdit;
    CR3: TCurrencyEdit;
    CDesc2: Text8Pt;
    CSS2: Text8Pt;
    PS2: Text8Pt;
    DR2: TCurrencyEdit;
    CR2: TCurrencyEdit;
    CDesc7: Text8Pt;
    CSS7: Text8Pt;
    PS7: Text8Pt;
    DR7: TCurrencyEdit;
    CR7: TCurrencyEdit;
    CDesc6: Text8Pt;
    CSS6: Text8Pt;
    PS6: Text8Pt;
    DR6: TCurrencyEdit;
    CR6: TCurrencyEdit;
    CDesc4: Text8Pt;
    CDesc5: Text8Pt;
    CSS5: Text8Pt;
    CSS4: Text8Pt;
    Ps4: Text8Pt;
    PS5: Text8Pt;
    DR5: TCurrencyEdit;
    DR4: TCurrencyEdit;
    CR4: TCurrencyEdit;
    CR5: TCurrencyEdit;
    CDesc15: Text8Pt;
    PS15: Text8Pt;
    DR15: TCurrencyEdit;
    CR15: TCurrencyEdit;
    CDesc14: Text8Pt;
    CSS14: Text8Pt;
    PS14: Text8Pt;
    DR14: TCurrencyEdit;
    CR14: TCurrencyEdit;
    CDesc12: Text8Pt;
    CDesc13: Text8Pt;
    CSS13: Text8Pt;
    CSS12: Text8Pt;
    PS12: Text8Pt;
    PS13: Text8Pt;
    DR13: TCurrencyEdit;
    DR12: TCurrencyEdit;
    CR12: TCurrencyEdit;
    CR13: TCurrencyEdit;
    CDesc11: Text8Pt;
    CDesc10: Text8Pt;
    CDesc9: Text8Pt;
    CDesc8: Text8Pt;
    CSS8: Text8Pt;
    CSS10: Text8Pt;
    CSS11: Text8Pt;
    PS11: Text8Pt;
    PS10: Text8Pt;
    PS9: Text8Pt;
    PS8: Text8Pt;
    DR8: TCurrencyEdit;
    DR9: TCurrencyEdit;
    DR10: TCurrencyEdit;
    DR11: TCurrencyEdit;
    CR11: TCurrencyEdit;
    CR10: TCurrencyEdit;
    CR9: TCurrencyEdit;
    CR8: TCurrencyEdit;
    CDesc27: Text8Pt;
    CDesc26: Text8Pt;
    CDesc25: Text8Pt;
    CDesc24: Text8Pt;
    CSS24: Text8Pt;
    CSS25: Text8Pt;
    CSS26: Text8Pt;
    CSS27: Text8Pt;
    PS27: Text8Pt;
    PS26: Text8Pt;
    PS25: Text8Pt;
    PS24: Text8Pt;
    DR24: TCurrencyEdit;
    DR25: TCurrencyEdit;
    DR26: TCurrencyEdit;
    DR27: TCurrencyEdit;
    CR27: TCurrencyEdit;
    CR26: TCurrencyEdit;
    CR25: TCurrencyEdit;
    CR24: TCurrencyEdit;
    CDesc23: Text8Pt;
    CDesc22: Text8Pt;
    CDesc21: Text8Pt;
    CDesc20: Text8Pt;
    CDesc19: Text8Pt;
    CDesc18: Text8Pt;
    CDesc17: Text8Pt;
    CDesc16: Text8Pt;
    CSS16: Text8Pt;
    CSS17: Text8Pt;
    CSS18: Text8Pt;
    CSS19: Text8Pt;
    CSS20: Text8Pt;
    CSS21: Text8Pt;
    CSS22: Text8Pt;
    CSS23: Text8Pt;
    PS23: Text8Pt;
    PS22: Text8Pt;
    PS21: Text8Pt;
    PS20: Text8Pt;
    PS18: Text8Pt;
    PS17: Text8Pt;
    PS16: Text8Pt;
    DR16: TCurrencyEdit;
    DR17: TCurrencyEdit;
    DR18: TCurrencyEdit;
    DR19: TCurrencyEdit;
    DR20: TCurrencyEdit;
    DR21: TCurrencyEdit;
    DR22: TCurrencyEdit;
    DR23: TCurrencyEdit;
    CR23: TCurrencyEdit;
    CR22: TCurrencyEdit;
    CR21: TCurrencyEdit;
    CR20: TCurrencyEdit;
    CR19: TCurrencyEdit;
    CR18: TCurrencyEdit;
    CR17: TCurrencyEdit;
    CR16: TCurrencyEdit;
    PS19: Text8Pt;
    CDesc28: Text8Pt;
    CSS28: Text8Pt;
    PS28: Text8Pt;
    DR28: TCurrencyEdit;
    CR28: TCurrencyEdit;
    CR29: TCurrencyEdit;
    DR29: TCurrencyEdit;
    PS29: Text8Pt;
    CSS29: Text8Pt;
    CDesc29: Text8Pt;
    TriI0: TBorCheck;
    TriC0: TCurrencyEdit;
    TriC1: TCurrencyEdit;
    TriI1: TBorCheck;
    TriR1: TCurrencyEdit;
    TriI2: TBorCheck;
    TriC2: TCurrencyEdit;
    TriR2: TCurrencyEdit;
    TriR3: TCurrencyEdit;
    TriC3: TCurrencyEdit;
    TriI3: TBorCheck;
    TriI4: TBorCheck;
    TriC4: TCurrencyEdit;
    TriR4: TCurrencyEdit;
    TriR5: TCurrencyEdit;
    TriC5: TCurrencyEdit;
    TriI5: TBorCheck;
    TriI6: TBorCheck;
    TriC6: TCurrencyEdit;
    TriR6: TCurrencyEdit;
    TriI7: TBorCheck;
    TriC7: TCurrencyEdit;
    TriR7: TCurrencyEdit;
    TriI8: TBorCheck;
    TriC8: TCurrencyEdit;
    TriR8: TCurrencyEdit;
    TriR9: TCurrencyEdit;
    TriR10: TCurrencyEdit;
    TriR11: TCurrencyEdit;
    TriR12: TCurrencyEdit;
    TriR13: TCurrencyEdit;
    TriR14: TCurrencyEdit;
    TriR15: TCurrencyEdit;
    TriC15: TCurrencyEdit;
    TriC14: TCurrencyEdit;
    TriC13: TCurrencyEdit;
    TriC12: TCurrencyEdit;
    TriC11: TCurrencyEdit;
    TriC10: TCurrencyEdit;
    TriC9: TCurrencyEdit;
    TriI9: TBorCheck;
    TriI10: TBorCheck;
    TriI11: TBorCheck;
    TriI12: TBorCheck;
    TriI13: TBorCheck;
    TriI14: TBorCheck;
    TriI15: TBorCheck;
    TriI16: TBorCheck;
    TriC16: TCurrencyEdit;
    TriR16: TCurrencyEdit;
    TriI17: TBorCheck;
    TriC17: TCurrencyEdit;
    TriR17: TCurrencyEdit;
    TriI18: TBorCheck;
    TriC18: TCurrencyEdit;
    TriR18: TCurrencyEdit;
    TriI19: TBorCheck;
    TriC19: TCurrencyEdit;
    TriR19: TCurrencyEdit;
    TriI20: TBorCheck;
    TriC20: TCurrencyEdit;
    TriR20: TCurrencyEdit;
    TriI21: TBorCheck;
    TriC21: TCurrencyEdit;
    TriR21: TCurrencyEdit;
    TriI22: TBorCheck;
    TriC22: TCurrencyEdit;
    TriR22: TCurrencyEdit;
    TriI23: TBorCheck;
    TriC23: TCurrencyEdit;
    TriR23: TCurrencyEdit;
    TriI24: TBorCheck;
    TriC24: TCurrencyEdit;
    TriR24: TCurrencyEdit;
    TriI25: TBorCheck;
    TriC25: TCurrencyEdit;
    TriR25: TCurrencyEdit;
    TriI26: TBorCheck;
    TriC26: TCurrencyEdit;
    TriR26: TCurrencyEdit;
    TriI27: TBorCheck;
    TriC27: TCurrencyEdit;
    TriR27: TCurrencyEdit;
    TriI28: TBorCheck;
    TriC28: TCurrencyEdit;
    TriR28: TCurrencyEdit;
    TriC29: TCurrencyEdit;
    TriR29: TCurrencyEdit;
    TriI29: TBorCheck;
    TriR0: TCurrencyEdit;
    TriF0: TBorCheck;
    TriF2: TBorCheck;
    TriF1: TBorCheck;
    TriF3: TBorCheck;
    TriF4: TBorCheck;
    TriF5: TBorCheck;
    TriF6: TBorCheck;
    TriF7: TBorCheck;
    TriF8: TBorCheck;
    TriF9: TBorCheck;
    TriF10: TBorCheck;
    TriF11: TBorCheck;
    TriF12: TBorCheck;
    TriF13: TBorCheck;
    TriF14: TBorCheck;
    TriF15: TBorCheck;
    TriF16: TBorCheck;
    TriF17: TBorCheck;
    TriF18: TBorCheck;
    TriF19: TBorCheck;
    TriF20: TBorCheck;
    TriF21: TBorCheck;
    TriF22: TBorCheck;
    TriF23: TBorCheck;
    TriF24: TBorCheck;
    TriF25: TBorCheck;
    TriF26: TBorCheck;
    TriF27: TBorCheck;
    TriF28: TBorCheck;
    TriF29: TBorCheck;
    CSS9: Text8Pt;
    CSS15: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CDesc0Enter(Sender: TObject);
    procedure CR0Enter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CDesc1Exit(Sender: TObject);
    procedure DR0Enter(Sender: TObject);
    procedure TriC0Enter(Sender: TObject);
    procedure TriR0Enter(Sender: TObject);
    procedure TriI0Click(Sender: TObject);
    procedure TriC0Exit(Sender: TObject);
    procedure DR2Exit(Sender: TObject);
    procedure CR2Exit(Sender: TObject);
    procedure TriR0Exit(Sender: TObject);
    procedure TriF0Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure CSS4Enter(Sender: TObject);
  private
    { Private declarations }

    BeenViaButton,
    BeenStored,
    Running,
    ReValueMode,
    InOutEq,
    StopPageChange,
    SetUpOk
             :  Boolean;

    ThisCPage:  Byte;

    RSyssCurr:  CurrRec;

    SBPagePos:  Array[0..2] of Integer;

    {$IFDEF LTE}
      StartNewLine,
    {$ENDIF}
    NewLine  :  Array[0..CurrencyType] of Boolean;

    DescAry  :  Array[0..Currency1Page] of Text8Pt;
    SSymbAry :  Array[0..Currency1Page] of Text8Pt;
    PSymbAry :  Array[0..Currency1Page] of Text8Pt;

    DRateAry :  Array[0..Currency1Page] of TCurrencyEdit;
    CRateAry :  Array[0..Currency1Page] of TCurrencyEdit;
    LabelAry :  Array[0..Currency1Page] of Label8;
    TriCurAry:  Array[0..Currency1Page] of TCurrencyEdit;
    TriRateAry
             :  Array[0..Currency1Page] of TCurrencyEdit;
    TriInvAry:  Array[0..Currency1Page] of TBorCheck;
    TriFltAry:  Array[0..Currency1Page] of TBorCheck;


    LastTriSys
             :  ^GCurRec;


    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;


    Function ThisLine(Const Sender  :  TObject;
                      Const TMode   :  Byte)  :  Integer;

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure SetSyssStore(EnabFlag,
                           VOMode  :  Boolean);


    procedure SetTri(LNo  :  Integer);

    procedure StoreSyss;

    Function CheckCompleted  :  Boolean;

    procedure Warn_Change(SecStr  :  ShortString);

    procedure SetSyssRevalue;

    Function CheckCanRevalue  :  Boolean;

    procedure ShutDown;
    procedure PrimeVisiAray;
    function Current_Page: Integer;
    procedure ChangePage(NewPage: Integer);

    {$IFDEF LTE}
      procedure FormDesign;
    {$ENDIF}  

    procedure OutEq(UpdateLab: Boolean);
    function GetAryIndex(PIdx: Integer): Integer;

  public
    { Public declarations }
    procedure ProcessSyss;

    procedure RevalueSyss;

  end;

  Procedure SetReValueMode(State  :  Boolean);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETDateU,
  EtStrU,
  ETMiscU,
  ComnUnit,
  ComnU2,
  BtrvU2,
  BTSupU2,
  CmpCtrlU,
  GenWarnU,
  CurrncyU,
  PostingU,
  Excep2U,
  ReValueU;


{$R *.DFM}

Var
  URevalueMode  :  Boolean;



Procedure SetReValueMode(State  :  Boolean);

Begin
  If (State<>URevalueMode) then
    URevalueMode:=State;
end;



Procedure TSetCurrRec.WMFormCloseMsg(Var Message  :  TMessage);

Begin
  With Message do
  Begin

    Case WParam of

      8  :  ShutDown;

      9  :  OKCP1BtnClick(CanCP1Btn);

    end; {Case..}

  end; {With..}
end;


procedure TSetCurrRec.PrimeVisiAray;

Var
  n  :  Integer;

begin
  FillChar(DescAry,Sizeof(DescAry),0);
  FillChar(SSymbAry,Sizeof(SSymbAry),0);
  FillChar(PSymbAry,Sizeof(PSymbAry),0);
  FillChar(DRateAry,Sizeof(DRateAry),0);
  FillChar(CRateAry,Sizeof(CRateAry),0);
  FillChar(NewLine,Sizeof(NewLine),0);

  FillChar(LabelAry,Sizeof(LabelAry),0);
  FillChar(TriCurAry,Sizeof(TriCurAry),0);
  FillChar(TriRateAry,Sizeof(TriRateAry),0);
  FillChar(TriInvAry,Sizeof(TriInvAry),0);
  FillChar(TriFltAry,Sizeof(TriFltAry),0);


  DescAry[0]:=CDesc0; SSymbAry[0]:=CSS0; PSymbAry[0]:=PS0; DRateAry[0]:=DR0; CRateAry[0]:=CR0; LabelAry[0]:=Label0; TriCurAry[0]:=TriC0; TriRateAry[0]:=TriR0; TriInvAry[0]:=TriI0; TriFltAry[0]:=TriF0;
  DescAry[1]:=CDesc1; SSymbAry[1]:=CSS1; PSymbAry[1]:=PS1; DRateAry[1]:=DR1; CRateAry[1]:=CR1; LabelAry[1]:=Label1; TriCurAry[1]:=TriC1; TriRateAry[1]:=TriR1; TriInvAry[1]:=TriI1; TriFltAry[1]:=TriF1;
  DescAry[2]:=CDesc2; SSymbAry[2]:=CSS2; PSymbAry[2]:=PS2; DRateAry[2]:=DR2; CRateAry[2]:=CR2; LabelAry[2]:=Label2; TriCurAry[2]:=TriC2; TriRateAry[2]:=TriR2; TriInvAry[2]:=TriI2; TriFltAry[2]:=TriF2;
  DescAry[3]:=CDesc3; SSymbAry[3]:=CSS3; PSymbAry[3]:=PS3; DRateAry[3]:=DR3; CRateAry[3]:=CR3; LabelAry[3]:=Label3; TriCurAry[3]:=TriC3; TriRateAry[3]:=TriR3; TriInvAry[3]:=TriI3; TriFltAry[3]:=TriF3;
  DescAry[4]:=CDesc4; SSymbAry[4]:=CSS4; PSymbAry[4]:=PS4; DRateAry[4]:=DR4; CRateAry[4]:=CR4; LabelAry[4]:=Label4; TriCurAry[4]:=TriC4; TriRateAry[4]:=TriR4; TriInvAry[4]:=TriI4; TriFltAry[4]:=TriF4;
  DescAry[5]:=CDesc5; SSymbAry[5]:=CSS5; PSymbAry[5]:=PS5; DRateAry[5]:=DR5; CRateAry[5]:=CR5; LabelAry[5]:=Label5; TriCurAry[5]:=TriC5; TriRateAry[5]:=TriR5; TriInvAry[5]:=TriI5; TriFltAry[5]:=TriF5;
  DescAry[6]:=CDesc6; SSymbAry[6]:=CSS6; PSymbAry[6]:=PS6; DRateAry[6]:=DR6; CRateAry[6]:=CR6; LabelAry[6]:=Label6; TriCurAry[6]:=TriC6; TriRateAry[6]:=TriR6; TriInvAry[6]:=TriI6; TriFltAry[6]:=TriF6;
  DescAry[7]:=CDesc7; SSymbAry[7]:=CSS7; PSymbAry[7]:=PS7; DRateAry[7]:=DR7; CRateAry[7]:=CR7; LabelAry[7]:=Label7; TriCurAry[7]:=TriC7; TriRateAry[7]:=TriR7; TriInvAry[7]:=TriI7; TriFltAry[7]:=TriF7;
  DescAry[8]:=CDesc8; SSymbAry[8]:=CSS8; PSymbAry[8]:=PS8; DRateAry[8]:=DR8; CRateAry[8]:=CR8; LabelAry[8]:=Label8; TriCurAry[8]:=TriC8; TriRateAry[8]:=TriR8; TriInvAry[8]:=TriI8; TriFltAry[8]:=TriF8;
  DescAry[9]:=CDesc9; SSymbAry[9]:=CSS9; PSymbAry[9]:=PS9; DRateAry[9]:=DR9; CRateAry[9]:=CR9; LabelAry[9]:=Label9; TriCurAry[9]:=TriC9; TriRateAry[9]:=TriR9; TriInvAry[9]:=TriI9; TriFltAry[9]:=TriF9;
  DescAry[10]:=CDesc10; SSymbAry[10]:=CSS10; PSymbAry[10]:=PS10; DRateAry[10]:=DR10; CRateAry[10]:=CR10; LabelAry[10]:=Label10; TriCurAry[10]:=TriC10; TriRateAry[10]:=TriR10; TriInvAry[10]:=TriI10; TriFltAry[10]:=TriF10;
  DescAry[11]:=CDesc11; SSymbAry[11]:=CSS11; PSymbAry[11]:=PS11; DRateAry[11]:=DR11; CRateAry[11]:=CR11; LabelAry[11]:=Label11; TriCurAry[11]:=TriC11; TriRateAry[11]:=TriR11; TriInvAry[11]:=TriI11; TriFltAry[11]:=TriF11;
  DescAry[12]:=CDesc12; SSymbAry[12]:=CSS12; PSymbAry[12]:=PS12; DRateAry[12]:=DR12; CRateAry[12]:=CR12; LabelAry[12]:=Label12; TriCurAry[12]:=TriC12; TriRateAry[12]:=TriR12; TriInvAry[12]:=TriI12; TriFltAry[12]:=TriF12;
  DescAry[13]:=CDesc13; SSymbAry[13]:=CSS13; PSymbAry[13]:=PS13; DRateAry[13]:=DR13; CRateAry[13]:=CR13; LabelAry[13]:=Label13; TriCurAry[13]:=TriC13; TriRateAry[13]:=TriR13; TriInvAry[13]:=TriI13; TriFltAry[13]:=TriF13;
  DescAry[14]:=CDesc14; SSymbAry[14]:=CSS14; PSymbAry[14]:=PS14; DRateAry[14]:=DR14; CRateAry[14]:=CR14; LabelAry[14]:=Label14; TriCurAry[14]:=TriC14; TriRateAry[14]:=TriR14; TriInvAry[14]:=TriI14; TriFltAry[14]:=TriF14;
  DescAry[15]:=CDesc15; SSymbAry[15]:=CSS15; PSymbAry[15]:=PS15; DRateAry[15]:=DR15; CRateAry[15]:=CR15; LabelAry[15]:=Label15; TriCurAry[15]:=TriC15; TriRateAry[15]:=TriR15; TriInvAry[15]:=TriI15; TriFltAry[15]:=TriF15;
  DescAry[16]:=CDesc16; SSymbAry[16]:=CSS16; PSymbAry[16]:=PS16; DRateAry[16]:=DR16; CRateAry[16]:=CR16; LabelAry[16]:=Label16; TriCurAry[16]:=TriC16; TriRateAry[16]:=TriR16; TriInvAry[16]:=TriI16; TriFltAry[16]:=TriF16;
  DescAry[17]:=CDesc17; SSymbAry[17]:=CSS17; PSymbAry[17]:=PS17; DRateAry[17]:=DR17; CRateAry[17]:=CR17; LabelAry[17]:=Label17; TriCurAry[17]:=TriC17; TriRateAry[17]:=TriR17; TriInvAry[17]:=TriI17; TriFltAry[17]:=TriF17;
  DescAry[18]:=CDesc18; SSymbAry[18]:=CSS18; PSymbAry[18]:=PS18; DRateAry[18]:=DR18; CRateAry[18]:=CR18; LabelAry[18]:=Label18; TriCurAry[18]:=TriC18; TriRateAry[18]:=TriR18; TriInvAry[18]:=TriI18; TriFltAry[18]:=TriF18;
  DescAry[19]:=CDesc19; SSymbAry[19]:=CSS19; PSymbAry[19]:=PS19; DRateAry[19]:=DR19; CRateAry[19]:=CR19; LabelAry[19]:=Label19; TriCurAry[19]:=TriC19; TriRateAry[19]:=TriR19; TriInvAry[19]:=TriI19; TriFltAry[19]:=TriF19;
  DescAry[20]:=CDesc20; SSymbAry[20]:=CSS20; PSymbAry[20]:=PS20; DRateAry[20]:=DR20; CRateAry[20]:=CR20; LabelAry[20]:=Label20; TriCurAry[20]:=TriC20; TriRateAry[20]:=TriR20; TriInvAry[20]:=TriI20; TriFltAry[20]:=TriF20;
  DescAry[21]:=CDesc21; SSymbAry[21]:=CSS21; PSymbAry[21]:=PS21; DRateAry[21]:=DR21; CRateAry[21]:=CR21; LabelAry[21]:=Label21; TriCurAry[21]:=TriC21; TriRateAry[21]:=TriR21; TriInvAry[21]:=TriI21; TriFltAry[21]:=TriF21;
  DescAry[22]:=CDesc22; SSymbAry[22]:=CSS22; PSymbAry[22]:=PS22; DRateAry[22]:=DR22; CRateAry[22]:=CR22; LabelAry[22]:=Label22; TriCurAry[22]:=TriC22; TriRateAry[22]:=TriR22; TriInvAry[22]:=TriI22; TriFltAry[22]:=TriF22;
  DescAry[23]:=CDesc23; SSymbAry[23]:=CSS23; PSymbAry[23]:=PS23; DRateAry[23]:=DR23; CRateAry[23]:=CR23; LabelAry[23]:=Label23; TriCurAry[23]:=TriC23; TriRateAry[23]:=TriR23; TriInvAry[23]:=TriI23; TriFltAry[23]:=TriF23;
  DescAry[24]:=CDesc24; SSymbAry[24]:=CSS24; PSymbAry[24]:=PS24; DRateAry[24]:=DR24; CRateAry[24]:=CR24; LabelAry[24]:=Label24; TriCurAry[24]:=TriC24; TriRateAry[24]:=TriR24; TriInvAry[24]:=TriI24; TriFltAry[24]:=TriF24;
  DescAry[25]:=CDesc25; SSymbAry[25]:=CSS25; PSymbAry[25]:=PS25; DRateAry[25]:=DR25; CRateAry[25]:=CR25; LabelAry[25]:=Label25; TriCurAry[25]:=TriC25; TriRateAry[25]:=TriR25; TriInvAry[25]:=TriI25; TriFltAry[25]:=TriF25;
  DescAry[26]:=CDesc26; SSymbAry[26]:=CSS26; PSymbAry[26]:=PS26; DRateAry[26]:=DR26; CRateAry[26]:=CR26; LabelAry[26]:=Label26; TriCurAry[26]:=TriC26; TriRateAry[26]:=TriR26; TriInvAry[26]:=TriI26; TriFltAry[26]:=TriF26;
  DescAry[27]:=CDesc27; SSymbAry[27]:=CSS27; PSymbAry[27]:=PS27; DRateAry[27]:=DR27; CRateAry[27]:=CR27; LabelAry[27]:=Label27; TriCurAry[27]:=TriC27; TriRateAry[27]:=TriR27; TriInvAry[27]:=TriI27; TriFltAry[27]:=TriF27;
  DescAry[28]:=CDesc28; SSymbAry[28]:=CSS28; PSymbAry[28]:=PS28; DRateAry[28]:=DR28; CRateAry[28]:=CR28; LabelAry[28]:=Label28; TriCurAry[28]:=TriC28; TriRateAry[28]:=TriR28; TriInvAry[28]:=TriI28; TriFltAry[28]:=TriF28;
  DescAry[29]:=CDesc29; SSymbAry[29]:=CSS29; PSymbAry[29]:=PS29; DRateAry[29]:=DR29; CRateAry[29]:=CR29; LabelAry[29]:=Label29; TriCurAry[29]:=TriC29; TriRateAry[29]:=TriR29; TriInvAry[29]:=TriI29; TriFltAry[29]:=TriF29;

  {$IFDEF LTE}
    For n:=0 to CurrencyType do
    With SyssCurr^.Currencies[n] do
    Begin
      StartNewLine[n]:=(Desc='') and (SSymb='') and (PSymb='') and (CRates[BOn]=0.0);
    end;  

    For n:=0 to Pred(Currency1Page) do
      DRateAry[n].BlockNegative:=BOn;

  {$ENDIF}

end;


{$IFDEF LTE}

  procedure TSetCurrRec.FormDesign;

  Const
    ShrinkX  =  290;

  Begin
    Tabsheet2.TabVisible:=BOff;
    Tabsheet3.TabVisible:=BOff;

    Label86.Visible:=BOff;
    Label842.Visible:=BOff;
    Label844.Visible:=BOff;
    Label843.Visible:=BOff;
    Label829.Visible:=BOff;

    ScrollBox1.Width:=ScrollBox1.Width-ShrinkX;
    Panel1.Width:=Panel1.Width-ShrinkX;
    Self.ClientWidth:=Self.ClientWidth-ShrinkX;

    OkCP1Btn.Left:=OKCp1Btn.Left-Trunc(ShrinkX/2);
    CanCP1Btn.Left:=CanCp1Btn.Left-Trunc(ShrinkX/2);

  end;

{$ENDIF}

procedure TSetCurrRec.OutEq(UpdateLab  :  Boolean);

Const
  LPageNos :  Array[0..CurrencyPages-1] of Integer = (0,30,60);

Var
  n  :  Integer;

begin
  If (Not InOutEq) then
  Begin
    InOutEq:=BOn;


    With SyssCurr^, SyssGCuR^.GhostRates do
    Begin
      For n:=0 to Currency1Page do
      {$B-}
        If (GetAryIndex(n)<=CurrencyType) and (Assigned(DescAry[n])) then
      {$B+}
        With Currencies[GetAryIndex(n)] do
        Begin
          DescAry[n].Text:=Desc;
          SSymbAry[n].Text:=TxlatePound(SSymb,BOn);
          PSymbAry[n].Text:=TxlatePound(PSymb,BOn);
          DRateAry[n].Value:=CRates[BOn];
          CRateAry[n].Value:=CRates[BOff];
          TriCurAry[n].Value:=TriEuro[GetAryIndex(n)];
          TriRateAry[n].Value:=TriRates[GetAryIndex(n)];
          TriInvAry[n].Checked:=TriInvert[GetAryIndex(n)];

          TriInvAry[n].Enabled:=((TriEuro[GetAryIndex(n)]=0) and (CRates[BOn]=0) and (CRates[BOff]=0) and (DescAry[n].Text=''))
                                 or ((ReValueMode) and ((Not (n In [0,1])) or (ThisCPage>0)));

          TriFltAry[n].Checked:=TriFloat[GetAryIndex(n)];

          TriFltAry[n].Enabled:=TriInvAry[n].Enabled;


          If ((EuroVers) and (n>2)) {$IFDEF LTE} or (n>=Currency1Page) {$ENDIF} then
          Begin
            DescAry[n].Visible:=BOff;
            SSymbAry[n].Visible:=BOff;
            PSymbAry[n].Visible:=BOff;
            DRateAry[n].Visible:=BOff;
            CRateAry[n].Visible:=BOff;
            LabelAry[n].Visible:=BOff;
            TriCurAry[n].Visible:=BOff;
            TriRateAry[n].Visible:=BOff;
            TriInvAry[n].Visible:=BOff;
            TriFltAry[n].Visible:=BOff;
          end
          else
          Begin
            {$IFDEF LTE}
              CRateAry[n].Visible:=BOff;
              LabelAry[n].Visible:=(n<Currency1Page);
              TriCurAry[n].Visible:=BOff;
              TriRateAry[n].Visible:=BOff;
              TriInvAry[n].Visible:=BOff;
              TriFltAry[n].Visible:=BOff;
            {$ENDIF}
          end; {Loop..}
        end; {With..}

    end; {With..}

    If (UpdateLab) then
    Begin
      For n:=Low(LabelAry) to High(LabelAry) do
        LabelAry[n].Caption:=IntToStr(n+LPageNos[ThisCPage]);
    end;

    InOutEq:=BOff;

  end;
end;




procedure TSetCurrRec.FormCreate(Sender: TObject);


Begin
  InOutEq:=BOff;

  InCurr:=BOn;

  Running:=BOff;

  SetUpOk:=BOff;

  New(LastTriSys);

  Blank(LastTriSys^,Sizeof(LastTriSys^));

  BeenStored:=BOff;

  BeenViaButton:=BOff;

  ReValueMode:=URevalueMode;;

  URevalueMode:=BOff;

  InMainThread:=ReValueMode;

  ClientHeight:=401;

  If (EuroVers) then
  Begin
    ScrollBox1.Height:=ScrollBox1.Height-175;
    ScrollBox1.Align:=alNone;
    ScrollBox1.Top:=45;

    TabSheet2.TabVisible:=BOff;
    TabSheet3.TabVisible:=BOff;
    TabSheet1.Caption:='Euro';
    ClientHeight:=ClientHeight-175;
  end;

  ClientWidth:=641;

  MDI_SetFormCoord(TForm(Self));

  GlobLocked:=BOff;

  GetMultiSysCur(BOff,GlobLocked);

  GlobLocked:=BOff;

  GetMultiSysGCur(BOff,GlobLocked);
  LastTriSys^:=SyssGCuR^;

  ThisCPage:=0;
  StopPageChange:=BOff;


  PrimeVisiAray;

  {$IFDEF LTE}
    FormDesign;
  {$ENDIF}

  OutEq(BOn);

  If (Not RevalueMode) then
  Begin
    FormStyle:=fsMDIChild;
    SetUpOk:=BOn;
  end
  else
  Begin
    Caption:='Revalue Currency Rates.';
    OKCp1Btn.Caption:='&Revalue';
  end;


end;


{ == Procedure to Send Message to Get Record == }

Procedure TSetCurrRec.Send_UpdateList(Mode   :  Integer);

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
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


procedure TSetCurrRec.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  If (BeenViaButton) then
    Send_UpdateList(51)
  else
  Begin
    CanClose:=BOff;

    PostMessage(Self.Handle,WM_FormCloseMSg,9,0);
  end;
end;

procedure TSetCurrRec.FormClose(Sender: TObject; var Action: TCloseAction);

Var
  LStatus  :  Integer;

begin
  Action:=caFree;

  InCurr:=BOff;

  Dispose(LastTriSys);

  If (Not BeenStored) then
  Begin
    LStatus:=UnlockMultiSing(F[SysF],SysF,SysAddr[CurR]);
  end;
end;



Function TSetCurrRec.Current_Page  :  Integer;
Begin

  Result:=pcLivePage(PageControl1);

end;


{ ======== Function to Return line no currently on ========= }


Function TSetCurrRec.ThisLine(Const Sender  :  TObject;
                              Const TMode   :  Byte)  :  Integer;

Var
  n  :  Integer;

  FoundOk
     :  Boolean;

Begin
  FoundOk:=BOff;

  For n:=0 to Currency1Page do
  Begin
    Case TMode of
      0  :  FoundOk:=(Sender=DescAry[n]);
      1  :  FoundOk:=(Sender=CRateAry[n]);
      2  :  FoundOk:=(Sender=TriInvAry[n]);
      3  :  FoundOk:=(Sender=TriCurAry[n]);
      4  :  FoundOk:=(Sender=TriRateAry[n]);
      5  :  FoundOk:=(Sender=DRateAry[n]);
      6  :  FoundOk:=(Sender=TriFltAry[n]);

    end;

    If (FoundOk) then
      Break;

  end;

  If (FoundOk) then
    Result:=n
  else
    Result:=-1;

end;



procedure TSetCurrRec.SetSyssStore(EnabFlag,
                                   VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  OkCP1Btn.Enabled:=Not VOMode and (ICEDFM=0) ;

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



procedure TSetCurrRec.ProcessSyss;


Begin
  GlobLocked:=BOn;

  If (GetMultiSysCur(BOff,GlobLocked)) and (GlobLocked) then
    SetSyssStore(BOn,BOff);
end;



Function TSetCurrRec.CheckCanRevalue  :  Boolean;

Var
  HasUnPd,
  HasCur1 :  Boolean;

  FutYr   :  Byte;
  FutORef :  Str20;



Begin
  HasUnPd:=BOff; HasCur1:=BOff; FutYr:=0; FutORef:='';


  Result:=CheckValidNCC(CommitAct);

  If (Not Result) then
  Begin
    AddErrorLog('Revaluation. One or more of the General Ledger Control Codes is not valid, or missing.','',4);

    CustomDlg(Application.MainForm,'WARNING!','Invalid G/L Control Codes',
                   'One or more of the General Ledger Control Codes is not valid, or missing.'+#13+
                   'Revaluation cannot continue until this problem has been rectified.'+#13+#13+
                   'Correct the Control Codes via Utilities/System Setup/Control Codes, then try again.',
                   mtError,
                   [mbOk]);


  end
  else
  Begin
    Result:=Not HasUnpAlloc(HasUnPd,HasCur1,FutORef);

    If (Not Result) then
    Begin
      AddErrorLog('Revaluation. One or more of the unposted transactions is allocated, or unposted NOM''s detected.','',4);

      If (FutORef[1]<>DocCodes[NMT][1]) then
        CustomDlg(Application.MainForm,'WARNING!','Allocated Transactions Detected',
                       'One or more of the unposted transactions is allocated. ('+FutORef+')'+#13+
                       'Revaluation cannot continue until this problem has been rectified.'+#13+#13+
                       'All unposted tranasactions must be unallocated during a revaluation.',
                       mtError,
                       [mbOk])
      else
        CustomDlg(Application.MainForm,'WARNING!','Unposted NOM Transactions Detected',
                       'One or more unposted foreign currency NOM transactions have been found. ('+FutORef+')'+#13+
                       'Revaluation cannot continue until this problem has been rectified.'+#13+#13+
                       'All NOM''s must be posted before a revaluation.',
                       mtError,
                       [mbOk]);


    end
    else
    Begin
      {$B-}

      Result:=(UseCoDayRate) or Not HasFutureTrans(FutYr,FutOref);
      {$B+}

      If (Not Result) then
      Begin
        AddErrorLog('Revaluation. Transactions exist after the current period in '+IntToStr(ConvTxYrVal(FutYr,BOff))+'. ('+FutORef+')'+#13+
                    'Set the current period to '+IntToStr(ConvTxYrVal(FutYr,BOff)),'',4);

        CustomDlg(Application.MainForm,'WARNING!','Future Period Transactions Detected',
                       'Transactions exist after the current period in '+IntToStr(ConvTxYrVal(FutYr,BOff))+'. ('+FutORef+')'+#13+
                       'Set the current period to '+IntToStr(ConvTxYrVal(FutYr,BOff))+'.'+#13+
                       'Revaluation cannot continue until this problem has been rectified.'+#13+#13+
                       'All posted tranasactions must be revalued.',
                       mtError,
                       [mbOk]);


      end
    end;
  end;
end;



procedure TSetCurrRec.SetSyssRevalue;

Var
  n      :  Integer;

  mbRet  :  Word;

Begin

  mbRet:=MessageDlg('Please confirm you wish to revalue the General Ledger.',mtConfirmation,[mbYes,mbNo],0);


  If (mbRet=mrYes) then {Check for any issues before going in}
  Begin
    If (Not CheckCanRevalue) then
      mbRet:=mrNo;

  end;

  If (mbRet=mrYes) then
  Begin



    For n:=0 to Currency1Page do
      If (Assigned(DescAry[n])) then
      Begin
        DescAry[n].TabStop:=BOff;
        SSymbAry[n].TabStop:=BOff;
        PSymbAry[n].TabStop:=BOff;
        DRateAry[n].ReadOnly:=BOff;
        CRateAry[n].ReadOnly:=BOff;
      end;

    If (DRateAry[2].CanFocus) then
      DRateAry[2].SetFocus;

    RSyssCurr:=SyssCurr^;

    OkCP1Btn.Enabled:=BOn;


  end
  else {Shut down}
    OKCp1BtnClick(CanCP1Btn);

end;

procedure TSetCurrRec.RevalueSyss;


Begin
  GlobLocked:=BOn;

  If (GetMultiSysCur(BOff,GlobLocked)) and (GlobLocked) then
    SetSyssRevalue;
end;


{ == Function to return aray index from page Index == }

Function TSetCurrRec.GetAryIndex(PIdx  :  Integer)  :  Integer;

Const
  PageNos  :  Array[0..CurrencyPages-1] of Integer = (0,30,60);

Begin
  Result:=PIdx+PageNos[ThisCPage];
end;


procedure TSetCurrRec.StoreSyss;


Var
  n  :  Integer;

Begin
  With SyssCurr^, SyssGCuR^.GhostRates do
  Begin
    For n:=0 to Currency1Page do
      If (Assigned(DescAry[n])) then
      With Currencies[GetAryIndex(n)] do
      Begin
        Desc:=DescAry[n].Text;

        SSymb:=TxlatePound(SSymbAry[n].Text,BOff);
        PSymb:=TxlatePound(PSymbAry[n].Text,BOff);

        CRates[BOn]:=DRateAry[n].Value;
        CRates[BOff]:=CRateAry[n].Value;

        TriEuro[GetAryIndex(n)]:=Round(TriCurAry[n].Value);
        TriRates[GetAryIndex(n)]:=TriRateAry[n].Value;
        TriInvert[GetAryIndex(n)]:=TriInvAry[n].Checked;
        TriFloat[GetAryIndex(n)]:=TriFltAry[n].Checked;

      end; {Loop..}
  end; {With..}
end;


{ ========== Function to check all currencies are correct ======== }

Function TSetCurrRec.CheckCompleted  :  Boolean;

Var
  n       :  Byte;


Begin
  Result:=BOff;

  StoreSyss;

  With SyssCurr^,SyssGCuR^.GhostRates do
  Begin
    For n:=0 to CurrencyType do
    With Currencies[n] do
    Begin
      If (Desc<>'') and (SSymb<>'') then
      Begin
        Result:=((CRates[BOff]=0.0) and (Not UseCoDayRate)) or (CRates[BOn]=0.0);

        If (Not Result) and ((TriEuro[n]<>0) or (TriFloat[n])) then
          Result:=(TriRates[n]=0.0);

        If (Result) then
          Break;
      end;

    end;

    If (Result) then
    With Currencies[n] do
      CustomDlg(Application.MainForm,'WARNING!','Incorrect Currency Rate',
                             'At least one of the exchange rates for currency '+Desc+' ('+SSymb+') is zero.'+#13+#13+
                             'A zero exchange rate is not valid for a genuine currency.'+#13+
                             'Please correct before attempting to update the currency table.',
                             mtInformation,
                             [mbOk]);

  end;

  Result:=Not Result;
end;



procedure TSetCurrRec.OkCP1BtnClick(Sender: TObject);

Var
  AbortStore  :  Boolean;

begin
  AbortStore:=BOff;

  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) or (Sender=OKCp1Btn) then
    Begin
      // MH 04/01/2011 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
      //                                   fields which processes the text and updates the value
      If (ActiveControl <> OkCP1Btn) Then
        // Move focus to OK button to force any OnExit validation to occur
        OkCP1Btn.SetFocus;

      // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
      If (ActiveControl = OkCP1Btn) And CheckCompleted then
        StoreSyss
      else
      Begin
        ModalResult:=mrNone;
        AbortStore:=BOn;
      end;
    end
    else
      If (OKCp1Btn.Enabled) then
      Begin
        GlobLocked:=BOn;

        GetMultiSysCur(BOff,GlobLocked); {* Restore values *}

        GlobLocked:=BOn;

        GetMultiSysGCur(BOff,GlobLocked); {* Restore values *}
      end;

    If (Not AbortStore) then
    Begin
      BeenViaButton:=BOn;

      If (OkCP1Btn.Enabled) then
      Begin
        PutMultiSysCur(BOn);

        PutMultiSysGCur(BOn);

        BeenStored:=BOn;

        BTSupU2.Init_STDCurrList;

      end;


      If (Not RevalueMode) then
        Close
      else
      Begin
        InMainThread:=BOff;

        If (ModalResult=mrCancel) then
          ShutDown
        else
          If (Not AddRevalue2Thread(Application.MainForm,RSyssCurr,LastTriSys^)) then
            Self.ModalResult:=mrCancel;
      end;
    end;
  end; {With..}
end;



procedure TSetCurrRec.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TSetCurrRec.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


procedure TSetCurrRec.Warn_Change(SecStr  :  ShortString);


  Begin
    CustomDlg(Application.MainForm,'Please Note!',SecStr+' changed',
                               'Changing the '+SecStr+' will have '+
                               'serious implications on your financial data, unless the '+
                               'correct procedure is followed.'+#13+
                               'Please consult the online help, or your supplier before proceeding.',
                               mtInformation,
                               [mbOk]);



  end;

procedure TSetCurrRec.CDesc0Enter(Sender: TObject);
Var
  LNo  :  Integer;
begin
  LNo:=ThisLine(Sender,0);

  If (LNo>=0) then
  Begin
    NewLine[GetAryIndex(LNo)]:=((SSymbAry[LNo].Text='') and (DescAry[LNo].Text='') and (PSymbAry[LNo].Text='') and (DRateAry[LNo].Value=0));
  end;

  {$IFDEF LTE}
    If (LNo>=0) then
    With TCurrencyEdit(Sender) do
    Begin
      ReadOnly:=((Not StartNewLine[LNo]) and (Not SBSIn));
    end;

  {$ENDIF}
end;

procedure TSetCurrRec.CSS4Enter(Sender: TObject);
Var
  LNo  :  Integer;
begin
  {$IFDEF LTE}

    LNo:=ThisLine(Sender,0);


    If (LNo>=0) then
    With TCurrencyEdit(Sender) do
    Begin
      ReadOnly:=((Not StartNewLine[LNo]) and (Not SBSIn));
    end;

  {$ENDIF}
end;


procedure TSetCurrRec.CR0Enter(Sender: TObject);
Var
  LNo  :  Integer;
begin
  LNo:=ThisLine(Sender,1);

  If (LNo>=0) then
  With TCurrencyEdit(Sender) do
  Begin
    ReadOnly:=(((Not NewLine[GetAryIndex(LNo)]) and (Not RevalueMode)) or (Not OKCP1Btn.Enabled) or (TriCurAry[LNo].Value<>0)
                or ((LNo In [0,1]) and (ThisCPage=0)));
  end;
end;


procedure TSetCurrRec.SetTri(LNo  :  Integer);

Var
  n            :  Byte;
  SetOutEq     :  Boolean;

Begin
  SetOutEq:=BOff;

  If (Not InOutEq) and ((LNo<>0) or (ThisCPage>0)) then
  Begin
    StoreSyss;

    With SyssCurr^,SyssGCuR^.GhostRates do
    Begin
      For n:=0 to CurrencyType do
      With Currencies[n] do
      Begin
        If (TriEuro[n]=LNo) and (Not TriFloat[n]) and (TriEuro[n]<>0) then
        Begin
          SetOutEq:=BOn;

          CRates[BOn]:=Currencies[LNo].CRates[BOn];
          CRates[BOff]:=Currencies[LNo].CRates[BOff];
          TriInvert[n]:=TriInvert[LNo];
        end;
      end;
    end; {With..}

    If (SetOutEq) then
      OutEq(BOff);
  end;
end;

procedure TSetCurrRec.DR0Enter(Sender: TObject);
Var
  LNo  :  Integer;
begin
  LNo:=ThisLine(Sender,5);

  If (LNo>=0) then
  With TCurrencyEdit(Sender) do
  Begin
    ReadOnly:=(TriCurAry[LNo].Value<>0) or ((LNo In [0,1]) and (ThisCPage=0))  ;
  end;
end;


procedure TSetCurrRec.TriC0Enter(Sender: TObject);
Var
  LNo  :  Integer;
begin
  LNo:=ThisLine(Sender,3);

  If (LNo>=0) then
  With TCurrencyEdit(Sender) do
  Begin
    ReadOnly:=(((Not RevalueMode) and (Not NewLine[GetAryIndex(LNo)])) or ((LNo In [0,1]) and (ThisCPage=0)));
  end;
end;


procedure TSetCurrRec.TriC0Exit(Sender: TObject);
Var
  LNo  :  Integer;
begin
  If (Not InOutEq) then
  Begin
    StoreSyss;

    LNo:=ThisLine(Sender,3);

    If (LNo>=0) then
    With TCurrencyEdit(Sender) do
    Begin
      TriInvAry[LNo].Enabled:=(Value=0);

      If (Value<>0) and (Round(Value) In [0..CurrencyType]) then
      Begin
        If (Not TriFltAry[LNo].Checked) then
        With SyssCurr^,SyssGCuR^.GhostRates do
        Begin
          DRateAry[LNo].Value:=Currencies[Round(Value)].CRates[BOn];
          CRateAry[LNo].Value:=Currencies[Round(Value)].CRates[BOff];
          TriInvAry[LNo].Checked:=TriInvert[Round(Value)];
        end;
      end
      else
        Value:=0.0;

      If (SetUpOk) and (Not NewLine[GetAryIndex(LNo)]) and (Value<>LastTriSys^.GhostRates.TriEuro[GetAryIndex(LNo)]) then
        Warn_Change('Triangulation currency');
    end;
  end;
end;

procedure TSetCurrRec.TriR0Enter(Sender: TObject);
Var
  LNo  :  Integer;
begin
  LNo:=ThisLine(Sender,4);

  If (LNo>=0) then
  With TCurrencyEdit(Sender) do
  Begin
    ReadOnly:=(((Not RevalueMode) and (Not NewLine[GetAryIndex(LNo)])) or ((TriCurAry[LNo].Value=0) and (Not TriFltAry[LNo].Checked))
                or ((LNo In [0,1]) and (ThisCPage=0)));
  end;
end;


procedure TSetCurrRec.TriR0Exit(Sender: TObject);
Var
  LNo  :  Integer;
begin
  LNo:=ThisLine(Sender,4);

  If (LNo>=0) then
  With TCurrencyEdit(Sender) do
  Begin
    If (SetUpOk) and (Not NewLine[GetAryIndex(LNo)]) and (((Round_Up(Value,6)<>Round_Up(LastTriSys^.GhostRates.TriRates[GetAryIndex(LNo)],6)) or (Value=0))
           and ((TriCurAry[LNo].Value<>0) or (TriFltAry[LNo].Checked))) and (Not ReadOnly) then
      Warn_Change('Triangulation rate');
  end;
end;



procedure TSetCurrRec.TriI0Click(Sender: TObject);
Var
  LNo  :  Integer;
begin
  LNo:=ThisLine(Sender,2);

  If (LNo>=0) then
  With TBorCheck(Sender) do
  Begin
    SetTri(LNo);
  end;
end;


procedure TSetCurrRec.TriF0Click(Sender: TObject);
Var
  LNo  :  Integer;
begin
  LNo:=ThisLine(Sender,6);

  If (LNo>=0) then
  With TBorCheck(Sender) do
  Begin
    If (SetUpOk) and (Not NewLine[GetAryIndex(LNo)]) and (Checked<>LastTriSys^.GhostRates.TriFloat[GetAryIndex(LNo)]) then
      Warn_Change('Floating currency setting');
  end;
end;




procedure TSetCurrRec.DR2Exit(Sender: TObject);
Var
  LNo  :  Integer;
begin
  LNo:=ThisLine(Sender,5);

  {$IFDEF LTE} {* Set company rate same as daily rate *}
    CRateAry[LNo].Value:=DRateAry[LNo].Value;

  {$ENDIF}

  If (LNo>=0) then
  With TCurrencyEdit(Sender) do
  Begin
    SetTri(LNo);
  end;
end;


procedure TSetCurrRec.CR2Exit(Sender: TObject);
Var
  LNo  :  Integer;
begin
  LNo:=ThisLine(Sender,1);

  If (LNo>=0) then
  With TCurrencyEdit(Sender) do
  Begin
    SetTri(LNo);
  end;
end;


procedure TSetCurrRec.FormActivate(Sender: TObject);
begin
  If (RevalueMode) and (Not Running) then
  Begin
    Running:=BOn;
    RevalueSyss;
  end;
end;


procedure TSetCurrRec.ShutDown;

Begin
  PostMessage(Self.Handle,WM_Close,0,0);
end;



procedure TSetCurrRec.CDesc1Exit(Sender: TObject);
begin
  If (ThisCPage=0) then
  Begin
    DescAry[0].Text:='Consolidatd';
    PSymbAry[0].Text:=PSymbAry[1].Text;
    SSymbAry[0].Text:=SSymbAry[1].Text;
    DRateAry[0].Text:=DRateAry[1].Text;
    CRateAry[0].Text:=CRateAry[1].Text;
  end;
end;



procedure TSetCurrRec.PageControl1Change(Sender: TObject);
Var
  NewIndex  :  Integer;


begin
  If (Sender is TPageControl) then
    With Sender as TPageControl do
    Begin

      StopPageChange:=BOn;

      NewIndex:=pcLivePage(Sender);

      ScrollBox1.VertScrollBar.Position:=SBPagePos[NewIndex];

      ScrollBox1.Parent:=ActivePage;

      ThisCPage:=NewIndex;

      DescAry[0].ReadOnly:=(ThisCPage=0) and (OkCP1Btn.Enabled);
      SSymbAry[0].ReadOnly:=(ThisCPage=0) and (OkCP1Btn.Enabled);
      PSymbAry[0].ReadOnly:=(ThisCPage=0) and (OkCP1Btn.Enabled);


      OutEq(BOn);

      StopPageChange:=BOff;

      LockWindowUpDate(0);
    end; {With..}
end;




procedure TSetCurrRec.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);

Var
  NewIndex  :  Integer;
  
begin
  Try
    If (Not StopPageChange) then
      StoreSyss;

    AllowChange:=(Not StopPageChange) and (Not InOutEq);

  Except

    AllowChange:=BOff;
  end; {Try..}

  If (AllowChange) then
  Begin
    NewIndex:=pcLivePage(Sender);

    SBPagePos[NewIndex]:=ScrollBox1.VertScrollBar.Position;

    Release_PageHandle(Sender);
    LockWindowUpDate(Handle);
  end;
end;

Procedure TSetCurrRec.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}


procedure TSetCurrRec.WMCustGetRec(var Message: TMessage);
Var
  mbRet  :  Word;

Begin


  With Message do
  Begin
    Case WParam of

     175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);

    end; {Case..}
  end;
  Inherited;
end;





Initialization

  URevalueMode:=BOff;

end.

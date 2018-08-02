unit TestEdit;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{* Sample Test Program using Exchequer Enterprise DLL Functions *}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs,

  {$IFNDEF DLLU}
    UseDLLU,            {* Main program to call DLL Functions *}
  {$ELSE}
    InitDLLU,DLL01U,
    DLLTH_UP,
    DLLMiscU,
    {DLLTH01U,}
    DLLSK01U,
    DLLErrU,UPLIFT,
    DLLSrBOM,
    DLLJobU,
    {$IFDEF WIN32} DLLPFRM1, {$ENDIF}
  {$ENDIF}

  {$IFDEF WIN32}
    ComCtrls,
  {$ENDIF}

    StdCtrls, ExtCtrls, TabNotBk, Buttons, Grids;

{$I ExchDll.Inc}        {* Record Structure File *}
{$I ExDLLBt.Inc}        {* BTrieve Command Constant File *}

type
  TForm1 = class(TForm)
    {* Screen Design declaration *}
    TabbedNotebook1: TTabbedNotebook;
    List_TransLines: TListBox;
    Lab_TotalCost: TLabel;
    GroupBox1: TGroupBox;
    Label26: TLabel;
    Cu_Code: TEdit;
    Label27: TLabel;
    Cu_Comp: TEdit;
    GroupBox2: TGroupBox;
    Label28: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Cu_Addr1: TEdit;
    Cu_Addr2: TEdit;
    Cu_Addr3: TEdit;
    Cu_Addr4: TEdit;
    Cu_Addr5: TEdit;
    Cu_Cont: TEdit;
    Label32: TLabel;
    Cu_Phone: TEdit;
    Cu_Fax: TEdit;
    GroupBox3: TGroupBox;
    Button23: TButton;
    Button24: TButton;
    Button25: TButton;
    Button26: TButton;
    Button27: TButton;
    Panel4: TPanel;
    GroupBox4: TGroupBox;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    GroupBox5: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    GroupBox6: TGroupBox;
    Cu_Add: TButton;
    Cu_Close: TButton;
    GroupBox11: TGroupBox;
    Label7: TLabel;
    ST_Code: TEdit;
    Label8: TLabel;
    ST_Descr1: TEdit;
    ST_Descr2: TEdit;
    Label23: TLabel;
    ST_Alt: TEdit;
    GroupBox12: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    GL_PL: TEdit;
    GL_Sales: TEdit;
    GL_COS: TEdit;
    GL_BalSh: TEdit;
    GL_Wip: TEdit;
    GroupBox13: TGroupBox;
    Label14: TLabel;
    ST_Cost: TEdit;
    GroupBox14: TGroupBox;
    ST_Add: TButton;
    ST_Close: TButton;
    Label21: TLabel;
    St_Supp: TEdit;
    Label22: TLabel;
    ST_Sales: TEdit;
    GroupBox15: TGroupBox;
    Label15: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Tr_OurRef: TEdit;
    Tr_TransDate: TEdit;
    Tr_DueDate: TEdit;
    Label24: TLabel;
    Label25: TLabel;
    Label29: TLabel;
    Tr_Period: TEdit;
    Tr_YourRef: TEdit;
    Tr_AltRef: TEdit;
    Label16: TLabel;
    Tr_Code: TEdit;
    Label20: TLabel;
    St_Group: TEdit;
    Label33: TLabel;
    Label34: TLabel;
    ST_Type: TEdit;
    GroupBox16: TGroupBox;
    Label35: TLabel;
    Ver_Test: TLabel;
    Ver_Dll: TLabel;
    Label41: TLabel;
    First: TButton;
    Previous: TButton;
    Find: TButton;
    Next: TButton;
    Last: TButton;
    Nom_Add: TButton;
    Nom_Edit: TButton;
    GroupBox20: TGroupBox;
    GroupBox21: TGroupBox;
    GroupBox22: TGroupBox;
    Label54: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    B_Find: TButton;
    ListBOMLines: TListBox;
    Label61: TLabel;
    B_StockCode: TEdit;
    B_Cancel: TButton;
    B_Toggle: TButton;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    GroupBox23: TGroupBox;
    GroupBox24: TGroupBox;
    S_Box: TListBox;
    S_Label2: TLabel;
    S_Field1: TEdit;
    S_Field2: TEdit;
    S_ByTran: TRadioButton;
    S_BySerail: TRadioButton;
    S_Label1: TLabel;
    S_Find: TButton;
    S_Cancel: TButton;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label71: TLabel;
    Label73: TLabel;
    Label70: TLabel;
    Label72: TLabel;
    Label74: TLabel;
    GL_Code: TEdit;
    GL_Desc: TEdit;
    GL_NomType: TEdit;
    GL_Cat: TEdit;
    GL_CarryF: TEdit;
    Label78: TLabel;
    Lab_TLines: TLabel;
    J_JobCode: TEdit;
    J_JobDesc: TEdit;
    GroupBox25: TGroupBox;
    J_First: TButton;
    J_Previous: TButton;
    J_Find: TButton;
    J_Next: TButton;
    J_Last: TButton;
    J_Contact: TEdit;
    J_JobMan: TEdit;
    J_JobAltCode: TEdit;
    J_JobCat: TEdit;
    J_CustCode: TEdit;
    J_JobType: TEdit;
    J_JobStat: TEdit;
    J_ChargeType: TEdit;
    J_QuotePrice: TEdit;
    J_CurrPrice: TEdit;
    J_SORRef: TEdit;
    J_Completed: TEdit;
    J_StartDate: TEdit;
    J_EndDate: TEdit;
    J_RevEDate: TEdit;
    GroupBox27: TGroupBox;
    J_Add: TButton;
    J_Edit: TButton;
    J_JobAnal: TEdit;
    J_VATCode: TEdit;
    GroupBox26: TGroupBox;
    Label79: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    Label88: TLabel;
    Label89: TLabel;
    Label90: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    Label94: TLabel;
    Label95: TLabel;
    Label96: TLabel;
    Label97: TLabel;
    TSH_Add: TButton;
    MStkCode: TEdit;
    MLocCode: TEdit;
    MQtyInStock: TEdit;
    MQtyOnOrder: TEdit;
    MQtyAlloc: TEdit;
    MQtyPicked: TEdit;
    GroupBox28: TGroupBox;
    ML_Find: TButton;
    ML_Add: TButton;
    ML_Edit: TButton;
    MQtyMin: TEdit;
    MQtyMax: TEdit;
    MQtyFreeze: TEdit;
    MRoQty: TEdit;
    MCC: TEdit;
    MDep: TEdit;
    MRoCC: TEdit;
    MRoDep: TEdit;
    MCostPrice: TEdit;
    MSalePrice: TEdit;
    MSupplier: TEdit;
    MTempSupp: TEdit;
    MDefNom1: TEdit;
    MDefNom2: TEdit;
    MDefNom3: TEdit;
    MDefNom4: TEdit;
    MDefNom5: TEdit;
    GroupBox29: TGroupBox;
    Label100: TLabel;
    Label101: TLabel;
    Label102: TLabel;
    Label103: TLabel;
    Button11: TButton;
    MloCode: TEdit;
    MloName: TEdit;
    GroupBox33: TGroupBox;
    lo_First: TButton;
    lo_Previous: TButton;
    lo_Find: TButton;
    lo_Next: TButton;
    lo_Last: TButton;
    GroupBox34: TGroupBox;
    lo_Add: TButton;
    lo_Edit: TButton;
    MloContact: TEdit;
    MloAddr1: TEdit;
    MloAddr2: TEdit;
    MloAddr3: TEdit;
    MloAddr4: TEdit;
    MloAddr5: TEdit;
    MloTel: TEdit;
    MloFax: TEdit;
    GroupBox35: TGroupBox;
    Label126: TLabel;
    Label127: TLabel;
    Label128: TLabel;
    Label129: TLabel;
    Label130: TLabel;
    Label131: TLabel;
    MloNominal1: TEdit;
    MloNominal2: TEdit;
    MloNominal3: TEdit;
    MloNominal4: TEdit;
    MloNominal5: TEdit;
    Label132: TLabel;
    Label134: TLabel;
    Label136: TLabel;
    Label137: TLabel;
    Label133: TLabel;
    Label135: TLabel;
    Label138: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    Label108: TLabel;
    Label109: TLabel;
    Label139: TLabel;
    Label140: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label110: TLabel;
    Label111: TLabel;
    Label112: TLabel;
    Label113: TLabel;
    Label114: TLabel;
    Label115: TLabel;
    Label116: TLabel;
    Label117: TLabel;
    Label118: TLabel;
    Label119: TLabel;
    CustButton: TRadioButton;
    SuppButton: TRadioButton;
    GroupBox7: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Cu_Balance: TEdit;
    Cu_OutStd: TEdit;
    GroupBox8: TGroupBox;
    GetCCDep: TButton;
    CheckBox1: TCheckBox;
    B_StkPrice: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    ListBox1: TListBox;
    Button6: TButton;
    Button12: TButton;
    Button13: TButton;
    GroupBox9: TGroupBox;
    Label3: TLabel;
    radNomCode: TRadioButton;
    radDescription: TRadioButton;
    Button14: TButton;
    Button16: TButton;
    Button28: TButton;
    ST_ReOrder: TEdit;
    Label4: TLabel;
    B_StkDisc: TButton;
    B_GetCCDept: TButton;
    B_GetNote: TButton;
    B_GetDisc: TButton;
    B_AutoBank: TButton;
    B_Match: TButton;
    B_RoundTest: TButton;
    B_GetCurr: TButton;
    B_CanUpdate: TButton;
    GroupBox18: TGroupBox;
    stk1: TEdit;
    Stk2: TEdit;
    Stk3: TEdit;
    Stk4: TEdit;
    Stk5: TEdit;
    Qty1: TEdit;
    Qty2: TEdit;
    Qty3: TEdit;
    Qty4: TEdit;
    Qty5: TEdit;
    Net1: TEdit;
    Net2: TEdit;
    Net3: TEdit;
    Net4: TEdit;
    Net5: TEdit;
    TransUpdate: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label42: TLabel;
    PQty1: TEdit;
    PQty2: TEdit;
    PQty3: TEdit;
    PQty4: TEdit;
    PQty5: TEdit;
    WQty1: TEdit;
    WQty2: TEdit;
    WQty3: TEdit;
    WQty4: TEdit;
    WQty5: TEdit;
    Label43: TLabel;
    Label44: TLabel;
    SOPLink1: TEdit;
    SOPLink2: TEdit;
    SOPLink3: TEdit;
    SOPLink4: TEdit;
    SOPLink5: TEdit;
    Label45: TLabel;
    DQty1: TEdit;
    DQty2: TEdit;
    DQty3: TEdit;
    DQty4: TEdit;
    DQty5: TEdit;
    Label46: TLabel;
    DOff1: TEdit;
    DOff2: TEdit;
    DOff3: TEdit;
    DOff5: TEdit;
    DOff4: TEdit;
    Line1: TEdit;
    Line2: TEdit;
    Line3: TEdit;
    Line4: TEdit;
    Line5: TEdit;
    ABS1: TEdit;
    ABS2: TEdit;
    ABS3: TEdit;
    ABS4: TEdit;
    ABS5: TEdit;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    EditNo1: TEdit;
    EditNo2: TEdit;
    EditNo3: TEdit;
    EditNo4: TEdit;
    EditNo5: TEdit;
    Label50: TLabel;
    B_NewTran: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Button15: TButton;
    committedValue: TEdit;
    Label19: TLabel;
    B_THTotal: TButton;
    B_GetNextTrans: TButton;
    B_StoreNote: TButton;
    B_EBus: TButton;
    B_UpDue: TButton;
    ByStockCode: TEdit;

    {*** PROCEDURES & FUNCTIONS DECLARATION PART ***}

    {* ===== Form General Procedurs ===== *}
    procedure FormCreate(Sender: TObject);                 {* when Form is destroyed *}
    procedure TabbedNotebook1Change(Sender: TObject;        {* when TAB Page is changed *}
                                    NewTab: Integer;
                                var AllowChange: Boolean);

    {* ===== For Customer / Supplier Page ===== *}
    Function  GetAccBal(ACCode     : String;     {* To get Customer's Accounts Balance *}
                        Pr,Yr      : String;
                        SearchMode : Byte) : Double;
    procedure CustSuppClick(Sender: TObject);    {* To choose Customer or Supplier *}
    procedure CustBtrieve(Sender: TObject);      {* To retrieve data according to user's choice button *}
    procedure Cu_AddClick(Sender: TObject);      {* When ADD or SAVE button is chosen *}
    procedure Cu_CloseClick(Sender: TObject);    {* When EDIT or CANCEL button is chosen *}

    {* ===== For Stock Page ===== *}
    procedure StockBtrieve(Sender: TObject);     {* To retrieve data according to user's choice button *}
    procedure ST_AddClick(Sender: TObject);      {* When ADD or SAVE button is chosen *}
    procedure ST_CloseClick(Sender: TObject);    {* When EDIT or CANCEL button is chosen *}

    {* ===== For Transaction Page ===== *}
    procedure TransBtrieve(Sender: TObject);     {* To retrieve data according to user's choice button *}
    procedure But_AddTransClick(Sender: TObject);{* When ADD or SAVE button is chosen *}
    procedure TSH_AddClick(Sender: TObject);     {* To add Job Costing Time Sheet *}

    {* ===== For Nominal Page ===== *}
    procedure NomBTrieve(Sender: TObject);       {* To retrieve data according to user's choice button *}
    procedure Nom_AddClick(Sender: TObject);     {* When ADD or SAVE button is chosen *}
    procedure Nom_EditClick(Sender: TObject);    {* When EDIT or CANCEL button is chosen *}

    {* ===== For BOM Page ===== *}
    procedure BOMBTrieve(Sender: TObject);       {* To retrieve data according to user's choice button *}
    procedure B_CancelClick(Sender: TObject);    {* When CANCEL button is chosen *}
    procedure B_ToggleClick(Sender: TObject);    {* When "Where Used" & "Components" Toggle is changed *}

    {* ===== For Serial Page ===== *}
    procedure S_ByTranClick(Sender: TObject);    {* When "By Transaction" is chosen *}
    procedure S_BySerailClick(Sender: TObject);  {* When "By Serial No" is chosen *}
    procedure SRBTrieve(Sender: TObject);        {* To retrieve data according to user's choice button *}
    procedure S_CancelClick(Sender: TObject);    {* When CANCEL button is chosen *}

    {* ===== For Job Page ===== *}
    procedure BTrieveJob(Sender: TObject);       {* To retrieve data according to user's choice button *}
    procedure Job_Add(Sender: TObject);          {* When ADD or SAVE button is chosen *}
    procedure Job_Edit(Sender: TObject);         {* When EDIT or CANCEL button is chosen *}

    {* ===== For Test Mode Toggle ===== *}
    procedure CheckBox1Click(Sender: TObject);   {* When Test Mode Toggle is changed *}

    {* ===== For Multi Location Stock Page ===== *}
    procedure FindMLocStk(Sender: TObject);      {* To retrieve data according to user's choice button *}
    procedure AddMLocStk(Sender: TObject);       {* When ADD or SAVE button is chosen *}
    procedure EditMLocStk(Sender: TObject);      {* When EDIT or CANCEL button is chosen *}

    {* ===== For Location Master Page ===== *}
    procedure BTrieveLoc(Sender: TObject);       {* To retrieve data according to user's choice button *}
    procedure AddLoc(Sender: TObject);           {* When ADD or SAVE button is chosen *}
    procedure EditLoc(Sender: TObject);

    {* ===== For Discount Matrix  ===== *}

    procedure B_GetDiscClick(Sender: TObject);
    procedure B_StkDiscClick(Sender: TObject);

   {* ================================= *}

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure B_StkPriceClick(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Label16Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure B_SizeClick(Sender: TObject);
    procedure radNomCodeClick(Sender: TObject);

    procedure GetAltStk(Sender: TObject);
    procedure StoreAltCodes(Sender: TObject);

    procedure Button28Click(Sender: TObject);

    procedure B_GetCCDeptClick(Sender: TObject);
    procedure B_GetNoteClick(Sender: TObject);
    procedure B_AutoBankClick(Sender: TObject);
    procedure B_MatchClick(Sender: TObject);
    procedure B_RoundTestClick(Sender: TObject);
    procedure B_GetCurrClick(Sender: TObject);
    procedure TransUpdateClick(Sender: TObject);
    procedure B_CanUpdateClick(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure B_THTotalClick(Sender: TObject);
    procedure B_GetNextTransClick(Sender: TObject);
    procedure B_StoreNoteClick(Sender: TObject);
    procedure B_UpDueClick(Sender: TObject);
  

  private
    { Private declarations }

    {* ===== Declaration of Memory Buffer Address for .. ===== *}
    MyAcc          :  ^TBatchCURec;              {* Customer & Supplier *}
    AccBal         :  ^THistoryBalRec;           {* Account Balance *}
    MyStk          :  ^TBatchSKRec;              {* Stock *}
    MyInv          :  ^TBatchTHRec;              {* Transaction Header *}
    MyId           :  ^TBatchTLRec;              {* Transaction Line *}
    MyInvLines     :  ^TBatchLinesRec;           {* Transaction Lines *}
    MyGLAcc        :  ^TBatchNomRec;             {* General Ledger (Nominal) *}
    MyBOMLines     :  ^TBatchBOMLinesRec;        {* BOM Lines *}
    MySRLines      :  ^TBatchSRLinesRec;         {* Serial Nos Lines *}
    MyJob          :  ^TBatchJHRec;              {* Job *}
    MyMLocStk      :  ^TBatchSLRec;              {* Multi Location Stock *}
    MyMLocation    :  ^TBatchMLocRec;            {* Multi Location Stock *}
    MyMatch        :  ^TBatchMatchRec;
    MyNote         :  ^TBatchNotesRec;
    MyCCDep        :  ^TBatchCCDEpRec;
    MyPrice        :  ^TBatchStkPriceRec;
    MyVAT          :  ^TBatchVATRec;

    CurrKPath      :  Integer;                   {* For Index Key *}
    TmpKey         :  String;                    {* For Temporary Key *}

    TpS            :  TBatchSerialRec;

    {* For General Flags *}
    TransMode,
    StockMode      :  Boolean;

    FCust,
    FStock,FTrans,
    FEdit, FNom,
    FBOM,FSRNo,
    FJob,
    FMlocStk,
    FLoc           : Boolean;

    SrNoChk        : Boolean;

    CSStatus       : Boolean;                    {* Customer / Supplier Page *}

    {$IFNDEF DLLU}
      LockStat  :  WordBool;
    {$ELSE}
      LockStat  :  SmallInt;
    {$ENDIF}

    {
    TotalPage,
    CurrPage        : Integer;
    }

    
    {* ===== Convert Data From Screen Fields to Memory Buffer Fields ===== *}
    Procedure Form2Cust;              {* Customer/Supplier *}
    Function  Form2Stock : Boolean;   {* Stock *}
    Procedure Nom_Data;               {* Nominal *}
    Procedure Job_Data;               {* Job *}
    Function  Form2StockLoc : Boolean;{* Multi Location Stock *}
    Function  Form2Location : Boolean;{* Location Master *}

    {* ===== Convert Data From Memory Buffer Fields To Screen Fields ===== *}
    Procedure DispCust;               {* Customer/Supplier *}
    Procedure DispStock;              {* Stock *}
    Procedure DispTrans;              {* Transaction *}
    Procedure DispNom;                {* Nominal *}
    Procedure DispBOM;                {* BOM Lines *}
    Procedure DispSR;                 {* Serial Lines *}
    Procedure DispJob;                {* Job *}
    Procedure DispMLocStk;            {* Multi Location Stock *}
    Procedure DispLocation;           {* Location Master *}

    Procedure DispInUpdateBox;
    Procedure AssignIntoRecords;

    {* Discount Matrix *}

    {$IFDEF WIN32}

      procedure GetCustDiscount(TCustCode  :  ShortString);
      procedure DisplayDiscInfo(TDiscRec  :  TBatchDiscRec);
      Procedure FindCustQtyDisc(TmpCustCode :  ShortString);
      procedure GetStkDisc(TStkCode  :  ShortString);

    {$ENDIF}

    {
    Procedure PopCombo(Pctrl  :  TObject;
                   PushOn :  Boolean);

    Procedure Release_PageHandle(PCtrl  :  TObject);
    }

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

{*** ====================================================================== ***}

implementation

{$R *.DFM}
{$I Version.Inc}                      {* To display Version *}



{*** ====================================================================== ***}
{
Procedure TForm1.PopCombo(Pctrl  :  TObject;
                          PushOn :  Boolean);
Var
  n  :  Integer;
Begin
  If (PCtrl is TWInControl) then
    With TWinControl(PCtrl) do
    Begin
      For n:=0 to Pred(ControlCount) do
          If (Controls[n] is TWinControl) then
            If (TWinControl(Controls[n]).ControlCount>0) then
              PopCombo(Controls[n],PushOn);
    end;
end;
}
{ ====== Procedure to release window handles between page changes ==== }
{
Procedure TForm1.Release_PageHandle(PCtrl  :  TObject);
Var
  n         :  Integer;
  aPage     :  TWinControl;
Begin
  If (PCtrl is TTabbedNoteBook)  then
  Begin
      PopCombo(TabbedNoteBook1,True);
      aPage:=TWinControl(TabbedNoteBook1.PageIndex);
      LockWindowUpdate(TabbedNoteBook1.Handle);
      THintWindow(aPage).ReleaseHandle;
      For n:=0 to TotalPage do
        TWinControl(n).HandleNeeded;
      LockWindowUpdate(0);
      PopCombo(TabbedNoteBook1,False);
  end;
end;
}
{* ===== When Form is created ========== *}

procedure TForm1.FormCreate(Sender: TObject);

Var
  P,PL   :  Pointer;
  ExPath,
  PC     :  PChar;
  B_Stat :  Integer;

  TStr   :  String[255];

begin
  {* display Version  *}
  Caption := Caption + ' (' + BitVer + ')';

  {* allocate memory buffer for ..  *}
  GetMem(MyAcc,      SizeOf (MyAcc^));       {* Customer/Supplier *}
  GetMem(AccBal,     SizeOf (MyAcc^));       {* Account Balance *}
  GetMem(MyInv,      SizeOf (MyInv^));       {* Transaction Header *}
  GetMem(MyStk,      SizeOf (MyStk^));       {* Stock *}
  GetMem(MyId,       SizeOf (MyId^));        {* A Transaction Line *}
  GetMem(MyInvLines, SizeOf (MyInvLines^));  {* 200 Transaction Lines *}
  GetMem(MyGLAcc,    SizeOf (MyGLAcc^));     {* General Ledger Account *}
  GetMem(MyBOMLines, SizeOf (MyBOMLines^));  {* 500 Bill of Material Lines *}
  GetMem(MySRLines,  SizeOf (MySRLines^));   {* 500 Serial Number Lines *}
  GetMem(MyJob,      SizeOf (MyJob^));       {* Job *}
  GetMem(MyMLocStk,  SizeOf (MyMLocStk^));   {* Multi Location Stock *}
  GetMem(MyMLocation,SizeOf (MyMLocation^)); {* Location Master *}
  GetMem(MyMatch,    SizeOf (MyMatch^));
  GetMem(MyNote,     SizeOf(MyNote^));
  GetMem(MyCCDep,    SizeOf(MyCCDep^));
  GetMem(MyPrice,    SizeOf(MyPrice^));
  GetMem(MyVAT,      SizeOf(MyVAT^));

  {* Fill Blank into above allocated memory buffers *}
  FillChar(MyAcc^,      SizeOf (MyAcc^),      #0);
  FillChar(AccBal^,     SizeOf (MyAcc^),      #0);
  FillChar(MyInv^,      SizeOf (MyInv^),      #0);
  FillChar(MyStk^,      SizeOf (MyStk^),      #0);
  FillChar(MyId^,       SizeOf (MyId^),       #0);
  FillChar(MyInvLines^, SizeOf (MyInvLines^), #0);
  FillChar(MyGLAcc^,    SizeOf (MyGLAcc^),    #0);
  FillChar(MyBOMLines^, SizeOf (MyBOMLines^), #0);
  FillChar(MySRLines^,  SizeOf (MySRLines^),  #0);
  FillChar(MyJob^,      SizeOf (MyJob^),      #0);
  FillChar(MyMlocStk^,  SizeOf (MyMlocStk^),  #0);
  FillChar(MyMlocation^, SizeOf (MyMlocation^),#0);
  FillChar(MyMatch^,     SizeOf (MyMatch^),    #0);
  FillChar(MyNote^,      SizeOf (MyNote^),     #0);
  FillChar(MyCCDep^,     SizeOf (MyCCDep^),    #0);
  FillChar(MyPrice^,     SizeOf (MyPrice^),    #0);
  FillChar(MyVAT^,       SizeOf (MyVAT^),      #0);

  {* initialize DLL using DLL's Ex_InitDLL function *}

  PC:=StrAlloc(255);

  B_Stat:=Ex_InitDLL;

  StrDispose(PC);

  {* if DLL returns Error *}
  If (B_Stat <> 0) Then
  begin
    TStr:=Ex_ErrorDescription(1,B_Stat);
    ShowMessage ('Ex_InitDLL Status : '+IntToStr(B_Stat)+
                 #13#10+#13#10+TStr);
  end;

  {* display Version Information *}
  Ver_Test.Caption := Ver;
  Ver_Dll.Caption  := Ex_Version;

  {* ----------------------------------------------------------*}

  {* display Record Sizes declared in ExchDLL.INC file *}
  With ListBox1 do
  begin
    Clear;
    Style := lbOwnerDrawFixed;
    ItemHeight:=21;
    Items.Add(' TBatchCURec          '+IntToStr(SizeOf(TBatchCuRec)));
    Items.Add(' TBatchTHRec          '+IntToStr(SizeOf(TBatchTHRec)));
    Items.Add(' TBatchTLRec          '+IntToStr(SizeOf(TBatchTLRec)));
    Items.Add(' TBatchLinesRec       '+IntToStr(SizeOf(TBatchLinesRec)));
    Items.Add(' TSaleBandsRec        '+IntToStr(SizeOf(TSaleBandsRec)));
    Items.Add(' TSaleBandAry         '+IntToStr(SizeOf(TSaleBandAry)));
    Items.Add(' TBatchSKRec          '+IntToStr(SizeOf(TBatchSKRec)));
    Items.Add(' THistoryBalRec       '+IntToStr(SizeOf(THistoryBalRec)));
    Items.Add(' TBatchNomRec         '+IntToStr(SizeOf(TBatchNomRec)));
    Items.Add(' TBatchBOMLinesRec    '+IntToStr(SizeOf(TBatchBOMLinesRec)));
    Items.Add(' TBatchSRLinesRec     '+IntToStr(SizeOf(TBatchSRLinesRec)));
    Items.Add(' TBatchJHRec          '+IntToStr(SizeOf(TBatchJHRec)));
    Items.Add(' TBatchSLRec          '+IntToStr(SizeOf(TBatchSLRec)));
    Items.Add(' TBatchMLocRec        '+IntToStr(SizeOf(TBatchMLocRec)));
    Items.Add(' TBatchMatchRec       '+IntToStr(SizeOf(TBatchMatchRec)));
    Items.Add(' TBatchNotesRec       '+IntToStr(SizeOf(TBatchNotesRec)));
    Items.Add(' TBatchCCDepRec       '+IntToStr(SizeOf(TBatchCCDepRec)));
    Items.Add(' TBatchStkPriceRec    '+IntToStr(SizeOf(TBatchStkPriceRec)));
    Items.Add(' TBatchVATRec         '+IntToStr(SizeOf(TBatchVATRec)));
    Items.Add(' TBatchAutoBankRec    '+IntToStr(SizeOf(TBatchAutoBankRec)));
    Items.Add(' TBatchSerialRec      '+IntToStr(SizeOf(TBatchSerialRec)));
    Items.Add(' TBatchBOMImportRec   '+IntToStr(SizeOf(TBatchBOMImportRec)));
    Items.Add(' TBatchCurrRec        '+IntToStr(SizeOf(TBatchCurrRec)));
    Items.Add(' TBatchSysRec         '+IntToStr(SizeOf(TBatchSysRec)));
    Items.Add(' TBatchEmplRec        '+IntToStr(SizeOf(TBatchEmplRec)));
    Items.Add(' TBatchJobAnalRec     '+IntToStr(SizeOf(TBatchJobAnalRec)));
    Items.Add(' TBatchJobRateRec     '+IntToStr(SizeOf(TBatchJobRateRec)));
    Items.Add(' TBatchDiscRec        '+IntToStr(SizeOf(TBatchDiscRec)));
    Items.Add(' TBatchSKAltRec       '+IntToStr(SizeOf(TBatchSKAltRec)));
    Items.Add(' TLArrayInfoType      '+IntToStr(SizeOf(TLArrayInfoType)));
    Items.Add(' TBatchConvTCurr      '+IntToStr(SizeOf(TBatchConvTCurr)));
    Items.Add(' TSysECommsRec        '+IntToStr(SizeOf(TSysECommsRec)));
    Items.Add(' TDefaultFormRecType  '+IntToStr(SizeOf(TDefaultFormRecType)));
    Items.Add(' TEmailPrintInfoType  '+IntToStr(SizeOf(TEmailPrintInfoType)));
    Items.Add(' TVATCodeDefaultType  '+IntToStr(SizeOf(TVATCodeDefaultType)));

  end; {with..}


  {* initialise control flags for displaying .. *}
  FCust   := True;       {* Customer/Supplier *}
  FStock  := True;       {* Stock *}
  FTrans  := True;       {* Transaction *}
  FNom    := True;       {* General Ledger (Nominal) *}
  FBOM    := True;       {* Bill of Material *}
  FSRNo   := True;       {* Serial Numbers *}
  FJob    := True;       {* Job *}
  FMlocStk:= True;       {* Multi Location Stock *}
  FLoc    := True;       {* Location Master *}

  CSStatus:= True;       {* Customer/Supplier Status *}

  {* To display Versions Page first *}
  TmpKey := TabbedNoteBook1.ActivePage;
  TabbedNoteBook1.ActivePage := 'Versions';
  If (TmpKey = TabbedNoteBook1.ActivePage) Then
    TabbedNotebook1Change(Self, 0, FCust);

end;

{*** ====================================================================== ***}

{*** ====================================================================== ***}

{* ===== When Page is Changed ========== *}

procedure TForm1.TabbedNotebook1Change(Sender: TObject; NewTab: Integer;
                                   var AllowChange: Boolean);
var
  i  : integer;
begin
  {* Customer/Supplier Page *}
  If (NewTab = 1) then
  begin
    Panel4.Caption:='';
    If (CustButton.CanFocus) then
      CustButton.SetFocus;
    If FCust then
    begin
      FCust := False;
      CustBtrieve(Button23);       {* get first Customer/Supplier record *}
    end;
    DispCust;                      {* display Customer/Supplier's information *}
  end;

  {* Stock Page *}
  If (NewTab = 2) then
  begin
    Panel4.Caption:='';
    If FStock then
    begin
      FStock := False;
      StockBtrieve(Button17);      {* get first Stock record *}
    end;
    DispStock;                     {* display Stock's information *}
  end;

  {* Transaction Page *}
  If (NewTab = 3) then
  begin
    Panel4.Caption:='';
    If FTrans then
    begin
      FTrans := False;
      Tr_OurRef.Text := 'SIN';     {* to get Sales Invoice record first *}
      TransBtrieve(Button3);       {* get first Sales Invoice record *}
    end;
    DispTrans;                     {* display Transaction's information *}
  end;

  {* Nominal Page *}
  If (NewTab = 4) then
  begin
    Panel4.Caption:='';
    If FNom then
    begin
      FNom := False;
      NomBtrieve(First);           {* get first Nominal record *}
    end;
    DispNom;                       {* display Nominal's information *}
  end;

  {* Bill of Material Page *}
  If (NewTab = 5) then
  begin
    Panel4.Caption:='';
    If FBOM then
    begin
      FBOM := False;
      If B_StockCode.CanFocus then {* wait at Stock Code field for *}
         B_StockCode.SetFocus;     {* user to enter required Stock Code *}
    end;

  end;

  {* Serial Numbers Page *}
  If (NewTab = 6) then
  begin
    Panel4.Caption:='';
    If FSRNo then
    begin
      FSRNo := False;
      If S_ByTran.CanFocus then    {* default by Transaction Number *}
         S_ByTran.SetFocus;
    end;
  end;

  {* Job Page *}
  If (NewTab = 7) then
  begin
    Panel4.Caption:='';
    If FJob then
    begin
      FJob := False;
      BtrieveJob(J_First);         {* get first Job record *}
    end;
    DispJob;                       {* display Job's information *}
  end;

  {* Multi Location Stock Page *}
  If (NewTab = 8) then
  begin
    Panel4.Caption:='';
    If FMLocStk then
    begin
      FMLocStk := False;
      If MstkCode.CanFocus then    {* place cursor in Stock Code field *}
         MstkCode.SetFocus;
    end;
  end;

  {* Location Page *}
  If (NewTab = 9) then
  begin
    Panel4.Caption:='';
    If FLoc then
    begin
      FLoc := False;
      BtrieveLoc(Lo_First);       {* get first Location record *}
    end;
    DispLocation;                       {* display Location's information *}
  end;

  {Release_Pagehandle(Sender);}

end;



(***************************************************************)
(* Customer /Supplier Routines                                 *)
(***************************************************************)

{* ========== To choose Customer or Supplier ========== *}

procedure TForm1.CustSuppClick(Sender: TObject);
begin
  If (Sender=CustButton) then
    CSStatus:=True             {* If Customer Button is chosen *}
  else
    CSStatus:=False;           {* for Supplier *}

  If (Not FCust) then
    FCust:=True;

  CustBtrieve(Button23);       {* get first Customer/Supplier record *}

end;

{* ===== To get Customer Account Balance ========== *}

Function TForm1.GetAccBal(ACCode     :  String;
                          Pr,Yr      :  String;
                          SearchMode :  Byte)  :  Double;
const
  YN : Array[False..True] of String[3] = ('No','Yes');

Var
  P           :  Pointer;
  PC          :  PChar;

  BStat       :  Integer;
  OutStat     :  WordBool;

Begin
  With AccBal^ do
  Begin

    {* initialize AccBal as blank  *}
    FillChar(AccBal^,Sizeof(AccBal^),0);

    {* assign Accounting Period, Year and Currency  *}
    Period:=Pr;
    Year:=Yr;

    Currency:=0;

    {* allocate memory buffer for string 255  *}
    PC := StrAlloc(255);
    {* assign Account Code into PC as Key field  *}
    StrPCopy(PC,AcCode);

    {* assign memory address  *}
    P:=AccBal;

    {* use DLL function to get Account Balance  *}
    BStat:=Ex_GetAccountBalance(P,Sizeof(AccBal^),PC,SearchMode);

    {* if DLL function returns Error  *}
    If (BStat<>0) then
      Panel4.Caption:='Bal Status : '+IntToStr(BStat)
    else
      CommittedValue.Text:=floatToStr(CommitVal);

    {* use DLL function to get Outstanding Status of an Account  *}
    {$IFNDEF DLLU}
      OutStat:=Ex_HasOutStanding(PC);
    {$ELSE}
      OutStat:=(Ex_HasOutStanding(PC)<>0);
    {$ENDIF}

    {* display on screen as Yes or No  *}
    Cu_OutStd.Text:=YN[OutStat];

    {* assign Account Balance Value into Function Result  *}
    Result:=AccBal^.Value;

    {* dispose allocated buffer string 255  *}
    StrDispose (PC);

  end; {With..}

end; {Func..}


{* ===== Convert Customer's Information from Memory Fields into Screen Fields ========== *}
Procedure TForm1.DispCust;
var
  TBal  :  Double;
  Mode  :  Byte;


Begin

  With MyAcc^ Do Begin
    Cu_Code.Text  := CustCode;      {* Customer/Supplier Code *}
    Cu_Comp.Text  := Company;       {* Company *}
    Cu_Cont.Text  := Contact;       {* Contact Name *}
    Cu_Addr1.Text := Addr[1];       {* Address Line 1 *}
    Cu_Addr2.Text := Addr[2];       {* Address Line 2 *}
    Cu_Addr3.Text := Addr[3];       {* Address Line 3 *}
    Cu_Addr4.Text := Addr[4];       {* Address Line 4 *}
    Cu_Addr5.Text := Addr[5];       {* Address Line 5 *}
    Cu_Phone.Text := Phone;         {* Telephone number *}
    Cu_Fax.Text   := Fax;           {* Fax number *}

    {* Account Balance *}
    If (CSStatus) then
    begin

      Mode:=7; { budget }
      TBal:=GetACCBal(CustCode,'03','100',Mode);

      If Mode=7 then
        ShowMessage('Budget Amount = '+FloattoStrF(TBal,FFFixed,20,2));
      { HM 10/05/99: Was getting an Invalid Floating Point Operation as customer balance too big }
      Try
        Cu_Balance.Text := ''; { FloatToStr((Trunc(Round(TBal*100))/100));}

      Except
        On E:Exception Do
          ShowMessage (E.Message);
      End;
    end;
  End; { With }
End;

{* ===== Convert Customer's Information from Screen Fields into Memory Fields ========== *}

procedure TForm1.Form2Cust;
Const
  CSCode  :  Array[False..True] of Char = ('S','C');
Begin
  {* Fill Blank in Customer/Supplier memory buffer *}
  FillChar (MyAcc^, SizeOf (MyAcc^), #0);
  With MyAcc^ Do Begin
    CustCode := Cu_Code.Text;       {* Customer /Supplier Code *}
    CustSupp := CSCode[CSStatus];   {* to define the record as Customer record type *}
    Company  := Cu_Comp.Text;       {* Company *}
    Contact  := Cu_Cont.Text;       {* Contact Name *}
    Addr[1]  := Cu_Addr1.Text;      {* Address Line 1 *}
    Addr[2]  := Cu_Addr2.Text;      {* Address Line 2 *}
    Addr[3]  := Cu_Addr3.Text;      {* Address Line 3 *}
    Addr[4]  := Cu_Addr4.Text;      {* Address Line 4 *}
    Addr[5]  := Cu_Addr5.Text;      {* Address Line 5 *}
    Phone    := Cu_Phone.Text;      {* Telephone number *}
    Fax      := Cu_Fax.Text;        {* Fax number *}
    PayType  := 'C';                {* Payment Type C=Cash *}
    VATCode  := 'S';                {* VAT Code S=Standard *}
    Currency := 1;                  {* Currency 1=Sterling *}
    DefNomCode:=510100;
    DefCtrlNom:=210300;
  End; { With }
end;


{* ===== Find Customer/Supplier according to user's choice button ========== *}

procedure TForm1.CustBtrieve(Sender: TObject);
Const
  CSCode  :  Array[False..True] of Integer = (2,1);  {* Customer=1  Supplier=2 *}
Var
  ExStat  :  Integer;
  PC      :  PChar;
  P,PL    :  Pointer;

begin

  GroupBox7.Visible:=CSStatus;  {* To show Customer Balance *}

  {* assign Customer/Supplier Code into memory buffer *}
  With MyAcc^ Do
    CustCode:=Cu_Code.Text;

  {* allocate buffer for PC as String 255 *}
  PC := StrAlloc (255);
  {* assign Customer/Supplier Code into PC as Key field *}
  StrPCopy(PC, MyAcc^.CustCode);
  {* assign Index Key as Customer/Supplier Code Key *}
  CurrKPath:=0;
  {* assign memory address *}
  P:=MyAcc;

  {* First Button *}
  If (Sender = Button23) Then ExStat:=Ex_GetAccount(P,SizeOf(MyAcc^),PC,CurrKPath,B_GetFirst,CSCode[CSStatus],LockStat);
  {* Previous Button *}
  If (Sender = Button24) Then ExStat:=Ex_GetAccount(P,SizeOf(MyAcc^),PC,CurrKPath,B_GetPrev,CSCode[CSStatus],LockStat);
  {* Find Button *}
  If (Sender = Button25) Then ExStat:=Ex_GetAccount(P,SizeOf(MyAcc^),PC,CurrKPath,B_GetGEq,CSCode[CSStatus],LockStat);
  {* Next Button *}
  If (Sender = Button26) Then ExStat:=Ex_GetAccount(P,SizeOf(MyAcc^),PC,CurrKPath,B_GetNext,CSCode[CSStatus],LockStat);
  {* Last Button *}
  If (Sender = Button27) Then ExStat:=Ex_GetAccount(P,SizeOf(MyAcc^),PC,CurrKPath,B_GetLast,CSCode[CSStatus],LockStat);

  {* display Customer/Supplier's information *}
  DispCust;

  {* dispose allocated buffer for PC *}
  StrDispose (PC);

end;


{* ===== Customer/Supplier Page Add or Save Button is chosen ========== *}

procedure TForm1.Cu_AddClick(Sender: TObject);
Const
  CSCode  :  Array[False..True] of String[10] = ('Supplier','Customer');
Var
  ExStat, I : Integer;
  P         : Pointer;
begin
  {* if Add Button is chosen *}
  If (Cu_Add.Caption = '&Add') then
  begin
    {* change Add & Edit Buttons as Save & Cancel *}
    Cu_Add.Caption := '&Save';
    Cu_Close.Caption := '&Cancel';
    {* not Edit Status *}
    FEdit := False;
    {* assign current Customer/Supplier Code into Temporary field *}
    TmpKey := Cu_Code.Text;
    {* fill Blank for Customer/Supplier memory buffer *}
    FillChar (MyAcc^, SizeOf (MyAcc^), #0);
    {* display Customer/Supplier's information as blank *}
    DispCust;
    {* wait at Customer/Supplier Code *}
    If Cu_Code.CanFocus then
      Cu_Code.SetFocus;

  end { If 'Add' ..}
  else
  {* Save Button is chosen *}
  begin
    {* convert Customer/Supplier Information from Screen Fields into Memory Buffer Fields *}
    Form2Cust;
    {* assign memory address *}
    P:=MyAcc;

    {* by using DLL function, update or add Customer/Supplier's information *}
    If FEdit then
      {* if Edit Button is chosen and Save *}
      ExStat:=Ex_StoreAccount (P, SizeOf (MyAcc^), 0, B_Update)
    else
      {* if Add Button is chosen and Save *}
      ExStat:=Ex_StoreAccount (P, SizeOf (MyAcc^), 0, B_Insert);

    {* DLL return code *}
    Case ExStat Of
      0     : Begin {* record is successfully saved *}
                {* change Save & Cancel Buttons as Add & Edit Buttons *}
                Cu_Add.Caption := '&Add';
                Cu_Close.Caption := '&Edit';
              End;
      5     : Begin { Btrieve Error 5: Duplicate Code }
                If CU_Code.CanFocus Then Cu_Code.SetFocus;
                ShowMessage (CSCode[CSStatus]+' with this code already exists');
              End;
    Else
      ShowMessage ('Error: ' + IntToStr(ExStat));
    End; { Case.. }

  end; {* else of (Cu_Add.Caption = '&Add') *}

  {* if Add & Edit Buttons are displayed, change Enable Status as True for .. *}
  Button23.Enabled := (Cu_Add.Caption = '&Add');   {* First *}
  Button24.Enabled := (Cu_Add.Caption = '&Add');   {* Previous *}
  Button25.Enabled := (Cu_Add.Caption = '&Add');   {* Find *}
  Button26.Enabled := (Cu_Add.Caption = '&Add');   {* Next *}
  Button27.Enabled := (Cu_Add.Caption = '&Add');   {* Last *}
end;

{* ===== Customer/Supplier Page Edit or Cancel Button is chosen ========== *}

procedure TForm1.Cu_CloseClick(Sender: TObject);
begin
  {* Cancel Button is chosen *}
  If (Cu_Close.Caption = '&Cancel') then
  begin
    {* fill blank into customer/Supplier memory buffer *}
    FillChar (MyAcc^, SizeOf (MyAcc^), #0);
    {* assign back tmp. customer/Supplier code *}
    Cu_Code.Text := TmpKey;
    {* find customer/Supplier record by assigned code and display *}
    CustBtrieve(Button25);

    {* change Save & Cancel Buttons as Add & Edit *}
    Cu_Add.Caption := '&Add';
    Cu_Close.Caption := '&Edit';
  End { If }
  Else
  {* Edit Button is chosen *}
  Begin
    {* change Add & Edit Buttons as Save & Cancel *}
    Cu_Add.Caption := '&Save';
    Cu_Close.Caption := '&Cancel';

    {* Edit Status is True *}
    FEdit := True;
    {* assign customer/Supplier code into Temp. field *}
    TmpKey := Cu_Code.Text;
    {* wait at Customer/Supplier Code field to be edited *}
    If Cu_Code.CanFocus Then Cu_Code.SetFocus;

  End; { Else }

  {* if Add & Edit Buttons are displayed , change Enable Status as True for .. *}
  Button23.Enabled := (Cu_Add.Caption = '&Add');  {* First *}
  Button24.Enabled := (Cu_Add.Caption = '&Add');  {* Previous *}
  Button25.Enabled := (Cu_Add.Caption = '&Add');  {* Find *}
  Button26.Enabled := (Cu_Add.Caption = '&Add');  {* Next *}
  Button27.Enabled := (Cu_Add.Caption = '&Add');  {* Last *}

end;



(***************************************************************)
(* Stock Routines                                              *)
(***************************************************************)

{* ===== From Memory Buffer to Screen Fields ========== *}

Procedure TForm1.DispStock;
Var
  I : Integer;
Begin
  With MyStk^ Do Begin
    ST_Code.Text   := StockCode;      {* Stock Code *}
    ST_Descr1.Text := Desc[1];        {* Stock Description Line 1 *}
    ST_Descr2.Text := Desc[2];        {* Stock Description Line 2 *}
    ST_Alt.Text    := AltCode;        {* Alternative Stock Code *}
    St_Group.Text  := StockCat;       {* Stock Group Code *}
    St_Type.Text   := StockType;      {* Stock Type *}
    ST_Cost.Text   := Format ('%10.2f', [CostPrice]);               {* Cost Price *}
    ST_Sales.Text  := Format ('%10.2f', [SaleBands[1].SalesPrice]); {* Sales Price *}
    ST_ReOrder.Text:= Format ('%10.2f', [ROCPrice]);               {* ReOrder Price *}
    ST_Supp.Text   := Supplier;       {* Supplier *}

    {* Nominal Code for .. *}
    GL_Sales.Text := IntToStr(NomCodes[1]);       {* Sales *}
    GL_COS.Text   := IntToStr(NomCodes[2]);       {* Cost of Sales *}
    GL_PL.Text    := IntToStr(NomCodes[3]);       {* Profit & Loss *}
    GL_BalSh.Text := IntToStr(NomCodes[4]);       {* Balance Sheet *}
    GL_Wip.Text   := IntToStr(NomCodes[5]);       {* Work in Progress *}
  End; { With }
End;


{* ===== From Screen Fields to Memory Buffer Fields ========== *}

Function TForm1.Form2Stock : Boolean;
Var
  Code, I : Integer;
Begin
  Result := True;

  {* if not Edit Status, fill blank in Stock memory buffer *}
  If (Not FEdit) Then
    FillChar(MyStk^, SizeOf (MyStk^), #0);

  With MyStk^ Do Begin
    StockCode := ST_Code.Text + '                ';    {* Stock Code *}
    Desc[1]   := ST_Descr1.Text;                       {* Stock Description Line 1 *}
    Desc[2]   := ST_Descr2.Text;                       {* Stock Description Line 2 *}
    AltCode   := ST_Alt.Text;                          {* Stock Alternative Code *}
    StockCat  := St_Group.Text + '                ';   {* Stock Group Code *}
    StockType := St_Type.Text[1];                      {* Stock Type *}
    Supplier  := ST_Supp.Text;                         {* Supplier *}

    Val (ST_Cost.Text, CostPrice, Code);               {* Cost Price *}
    If (Code > 0) Then Begin
      Result := False;
      If ST_Cost.CanFocus Then ST_Cost.SetFocus;
    End;

    SaleBands[1].Currency := 1;                         {* Sales Currency *}
    Val (ST_Sales.Text, SaleBands[1].SalesPrice, Code); {* Sales Price *}
    If (Code > 0) Then Begin
      Result := False;
      If ST_Sales.CanFocus Then ST_Sales.SetFocus;
    End;

    Val (ST_ReOrder.Text, ROCPrice, Code);               {* ReOrder Price *}
    If (Code > 0) Then Begin
      Result := False;
      If ST_ReOrder.CanFocus Then ST_ReOrder.SetFocus;
    End;

    {* Nominal Codes for .. *}
    Try
      NomCodes[1] := StrToInt(GL_Sales.Text);           {* Sales *}
    Except
      Result := False;
      If GL_Sales.CanFocus Then GL_Sales.SetFocus;
    End;
    Try
      NomCodes[2] := StrToInt(GL_COS.Text);             {* Cost of Sales *}
    Except
      Result := False;
      If GL_COS.CanFocus Then GL_COS.SetFocus;
    End;
    Try
      NomCodes[3] := StrToInt(GL_PL.Text);              {* Profit & Loss *}
    Except
      Result := False;
      If GL_PL.CanFocus Then GL_PL.SetFocus;
    End;
    Try
      NomCodes[4] := StrToInt(GL_BalSh.Text);           {* Balance Sheet *}
    Except
      Result := False;
      If GL_BalSh.CanFocus Then GL_BalSh.SetFocus;
    End;
    Try
      NomCodes[5] := StrToInt(GL_Wip.Text);             {* Work In Progress *}
    Except
      Result := False;
      If GL_Wip.CanFocus Then GL_Wip.SetFocus;
    End;

    {* Sales Price Currencies *}
    For I := Low (SaleBands) To High (SaleBands) Do SaleBands[I].Currency := 1;

    VATCode      := 'S';     {* VAT Code S=Standard *}
    PCurrency    := 1;       {* Cost Price Currency *}
    ROCurrency   := 1;       {* Purchase Order Currency *}
    StkValType   := 'C';     {* Last Cost Price *}
    SellUnit     := 1;       {* Selling Unit *}
    BuyUnit      := 1;       {* Buying Unit *}
  End; { With }
End;

{* ===== Find Stock Record according to user's choice button ========== *}

procedure TForm1.StockBtrieve(Sender: TObject);
Var
  ExStat  :  Integer;
  PC      :  PChar;
  P       :  Pointer;
begin
  {* assign Stock Code into memory buffer *}
  With MyStk^ Do
    StockCode := St_Code.Text;

  {* allocate memory buffer for PC as String 255 *}
  PC := StrAlloc (255);
  {* assign Stock Code into PC *}
  StrPCopy(PC, MyStk^.StockCode);
  {* assign Index Key as Stock Code Key *}
  CurrKPath:=0;

  {* assign memory address *}
  P:=MyStk;

  {* First Button *}
  If (Sender = Button17) Then ExStat:=Ex_GetStock(P,SizeOf(MyStk^),PC,CurrKPath,B_GetFirst,LockStat);
  {* Previous Button *}
  If (Sender = Button18) Then ExStat:=Ex_GetStock(P,SizeOf(MyStk^),PC,CurrKPath,B_GetPrev,LockStat);
  {* Find Button *}
  If (Sender = Button19) Then ExStat:=Ex_GetStock(P,SizeOf(MyStk^),PC,CurrKPath,B_GetGEq,LockStat);
  {* Next Button *}
  If (Sender = Button20) Then ExStat:=Ex_GetStock(P,SizeOf(MyStk^),PC,CurrKPath,B_GetNext,LockStat);
  {* Last Button *}
  If (Sender = Button21) Then ExStat:=Ex_GetStock(P,SizeOf(MyStk^),PC,CurrKPath,B_GetLast,LockStat);

  If (ExStat<>0) then
    ShowMessage('Exstat = '+IntToStr(ExStat));
  {* convert data to display *}
  DispStock;

  {* dispose allocated buffer of PC *}
  StrDispose (PC);
end;


{* ===== Stock Page Add or Save Button is chosen ========== *}

procedure TForm1.ST_AddClick(Sender: TObject);
Var
  ExStat, I : Integer;
  P         : Pointer;
begin

  {* Add Button is chosen *}
  If (ST_Add.Caption = '&Add') Then Begin
    {* change Add & Edit as Save & Cancel *}
    ST_Add.Caption := '&Save';
    ST_Close.Caption := '&Cancel';
    {* Edit Status is False *}
    FEdit := False;
    {* assign Stock Code into Tmp. field *}
    TmpKey := St_Code.Text;
    {* fill blank in Stock memory buffer *}
    FillChar (MyStk^, SizeOf (MyStk^), #0);
    {* convert stock data from memory to screen fields *}
    DispStock;
    {* default Stock Group *}
    St_Group.Text := 'CABLES';
    {* default Stock Type P=Product *}
    St_Type.Text := 'P';
    {* wait at Stock Code *}
    If ST_Code.CanFocus Then ST_Code.SetFocus;
  End { If }
  Else
  {* Save Button is chosen *}
  Begin
    {* convert stock data from screen fields to memory *}
    If (Form2Stock) then
    Begin
      {* assign stock memory address *}
      
      P:=MyStk;

      {* use DLL function to save Stock Record *}
      If FEdit Then
        {* if Save from Edit *}
        ExStat:=Ex_StoreStock (P, SizeOf (MyStk^), 0, B_Update)
      Else
      begin
        {* if Save from Add *}

        ExStat:=Ex_StoreStock (P, SizeOf (MyStk^), 0, B_Insert);
      end;

      Case ExStat Of
        0     : Begin {* stock record is saved successfully *}
                  {* change Save & Cancel Buttons as Add & Edit *}
                  St_Add.Caption := '&Add';
                  St_Close.Caption := '&Edit';
                End;
        {
        30272 : Begin
                  If ST_Code.CanFocus Then ST_Code.SetFocus;
                  ShowMessage ('Invalid Stock Code');
                End;
        30275 : Begin
                  If ST_Supp.CanFocus Then ST_Supp.SetFocus;
                  ShowMessage ('Invalid Supplier Code');
                End;
        30280 : Begin
                  If GL_Sales.CanFocus Then GL_Sales.SetFocus;
                  ShowMessage ('Invalid General Ledger Code');
                End;
        }

      Else
        {ShowMessage ('Ex_StoreStock Error : ' + IntToStr(ExStat));}
        ShowMessage(Ex_GetLastErrorDesc);
      End; { Case }


    End { If }
    Else
      ShowMessage ('Validation Error');
  End; { Else }

  {* change Enable Status for .. *}
  St_Group.Enabled := (St_Add.Caption = '&Save');  {* Stock Group *}
  Button17.Enabled := (St_Add.Caption = '&Add');   {* First *}
  Button18.Enabled := (St_Add.Caption = '&Add');   {* Previous *}
  Button19.Enabled := (St_Add.Caption = '&Add');   {* Find *}
  Button20.Enabled := (St_Add.Caption = '&Add');   {* Next *}
  Button21.Enabled := (St_Add.Caption = '&Add');   {* Last *}
end;


{* ===== Stock Page Edit or Cancel Button is chosen ========== *}

procedure TForm1.ST_CloseClick(Sender: TObject);
begin
  {* Cancel Button is chosen *}
  If (St_Close.Caption = '&Cancel') Then
  Begin
    {* fill blank in Stock memory buffer *}
    FillChar (MyStk^, SizeOf (MyStk^), #0);
    {* assign back Tmp.Stock code into Screen Field *}
    St_Code.Text := TmpKey;
    {* Find stock record with assigned stock code *}
    StockBtrieve(Button19);
    {* change Save & Cancel Buttons as Add & Edit *}
    St_Add.Caption := '&Add';
    St_Close.Caption := '&Edit';
  End { If }
  Else
  {* Edit Button is chosen *}
  Begin
    {* change Add & Edit Buttons as Save & Cancel *}
    St_Add.Caption := '&Save';
    St_Close.Caption := '&Cancel';
    {* Edit Status is True now *}
    FEdit := True;
    {* assign Stock code into Tmp field *}
    TmpKey := St_Code.Text;
    {* change enable status for stock group *}
    St_Group.Enabled := False;
    {* wait at Stock Code field *}
    If St_Code.CanFocus then St_Code.SetFocus;
  End; { Else }

  {* change enable status for .. *}
  St_Group.Enabled := (St_Add.Caption = '&Save') And (Not FEdit); {* Stock Group *}
  Button17.Enabled := (St_Add.Caption = '&Add');     {* First *}
  Button18.Enabled := (St_Add.Caption = '&Add');     {* Previous *}
  Button19.Enabled := (St_Add.Caption = '&Add');     {* Find *}
  Button20.Enabled := (St_Add.Caption = '&Add');     {* Next *}
  Button21.Enabled := (St_Add.Caption = '&Add');     {* Last *}
end;

(***************************************************************)
(* Transaction Routines                                        *)
(***************************************************************)


Procedure TForm1.DispInUpdateBox;
Begin

  If (MyInv^.OurRef='') then
  begin
    If (Tr_OurRef.Text='') then
      Tr_OurRef.Text := 'SIN';     {* to get Sales Invoice record first *}
    TransBtrieve(Button3);       {* get first Sales Invoice record *}
  end;

  {* Assign Data *}

  Stk1.Text:=MyInvLines^[1].StockCode;
  Stk2.Text:=MyInvLines^[2].StockCode;
  Stk3.Text:=MyInvLines^[3].StockCode;
  Stk4.Text:=MyInvLines^[4].StockCode;
  Stk5.Text:=MyInvLines^[5].StockCode;

  Qty1.Text:=FloatToStrF(MyInvLines^[1].Qty,ffFixed,15,2);
  Qty2.Text:=FloatToStrF(MyInvLines^[2].Qty,ffFixed,15,2);
  Qty3.Text:=FloatToStrF(MyInvLines^[3].Qty,ffFixed,15,2);
  Qty4.Text:=FloatToStrF(MyInvLines^[4].Qty,ffFixed,15,2);
  Qty5.Text:=FloatToStrF(MyInvLines^[5].Qty,ffFixed,15,2);

  Net1.Text:=FloatToStrF(MyInvLines^[1].NetValue,ffFixed,15,2);
  Net2.Text:=FloatToStrF(MyInvLines^[2].NetValue,ffFixed,15,2);
  Net3.Text:=FloatToStrF(MyInvLines^[3].NetValue,ffFixed,15,2);
  Net4.Text:=FloatToStrF(MyInvLines^[4].NetValue,ffFixed,15,2);
  Net5.Text:=FloatToStrF(MyInvLines^[5].NetValue,ffFixed,15,2);

  PQty1.Text:=FloatToStrF(MyInvLines^[1].QtyPick,ffFixed,15,2);
  PQty2.Text:=FloatToStrF(MyInvLines^[2].QtyPick,ffFixed,15,2);
  PQty3.Text:=FloatToStrF(MyInvLines^[3].QtyPick,ffFixed,15,2);
  PQty4.Text:=FloatToStrF(MyInvLines^[4].QtyPick,ffFixed,15,2);
  PQty5.Text:=FloatToStrF(MyInvLines^[5].QtyPick,ffFixed,15,2);

  WQty1.Text:=FloatToStrF(MyInvLines^[1].QtyPWOff,ffFixed,15,2);
  WQty2.Text:=FloatToStrF(MyInvLines^[2].QtyPWOff,ffFixed,15,2);
  WQty3.Text:=FloatToStrF(MyInvLines^[3].QtyPWOff,ffFixed,15,2);
  WQty4.Text:=FloatToStrF(MyInvLines^[4].QtyPWOff,ffFixed,15,2);
  WQty5.Text:=FloatToStrF(MyInvLines^[5].QtyPWOff,ffFixed,15,2);

  DQty1.Text:=FloatToStrF(MyInvLines^[1].QtyDel,ffFixed,15,2);
  DQty2.Text:=FloatToStrF(MyInvLines^[2].QtyDel,ffFixed,15,2);
  DQty3.Text:=FloatToStrF(MyInvLines^[3].QtyDel,ffFixed,15,2);
  DQty4.Text:=FloatToStrF(MyInvLines^[4].QtyDel,ffFixed,15,2);
  DQty5.Text:=FloatToStrF(MyInvLines^[5].QtyDel,ffFixed,15,2);

  DOff1.Text:=FloatToStrF(MyInvLines^[1].QtyWOff,ffFixed,15,2);
  DOff2.Text:=FloatToStrF(MyInvLines^[2].QtyWOff,ffFixed,15,2);
  DOff3.Text:=FloatToStrF(MyInvLines^[3].QtyWOff,ffFixed,15,2);
  DOff4.Text:=FloatToStrF(MyInvLines^[4].QtyWOff,ffFixed,15,2);
  DOff5.Text:=FloatToStrF(MyInvLines^[5].QtyWOff,ffFixed,15,2);

  Line1.Text:=IntToStr(MyInvLines^[1].LineNo);
  Line2.Text:=IntToStr(MyInvLines^[2].LineNo);
  Line3.Text:=IntToStr(MyInvLines^[3].LineNo);
  Line4.Text:=IntToStr(MyInvLines^[4].LineNo);
  Line5.Text:=IntToStr(MyInvLines^[5].LineNo);

  ABS1.Text:=IntToStr(MyInvLines^[1].ABSLineNo);
  ABS2.Text:=IntToStr(MyInvLines^[2].ABSLineNo);
  ABS3.Text:=IntToStr(MyInvLines^[3].ABSLineNo);
  ABS4.Text:=IntToStr(MyInvLines^[4].ABSLineNo);
  ABS5.Text:=IntToStr(MyInvLines^[5].ABSLineNo);

  SOPLink1.Text:=IntToStr(MyInvLines^[1].SOPLink)+'/'+IntToStr(MyInvLines^[1].SOPLineNo);
  SOPLink2.Text:=IntToStr(MyInvLines^[2].SOPLink)+'/'+IntToStr(MyInvLines^[2].SOPLineNo);
  SOPLink3.Text:=IntToStr(MyInvLines^[3].SOPLink)+'/'+IntToStr(MyInvLines^[3].SOPLineNo);
  SOPLink4.Text:=IntToStr(MyInvLines^[4].SOPLink)+'/'+IntToStr(MyInvLines^[4].SOPLineNo);
  SOPLink5.Text:=IntToStr(MyInvLines^[5].SOPLink)+'/'+IntToStr(MyInvLines^[5].SOPLineNo);

end; {proc..}


{* ===== Convert Stock Data from Memory Buffer Fields to Screen Fields ========== *}

Procedure TForm1.DispTrans;
Var
  LineStr, Tmp : String[100];
  I            : Integer;

  {* if using Ptr position *}
  (* TmpIdRec     : TBatchTLRec;
  RecSeg,RecOfs,
  RecPos       : LongInt; *)

Begin
  With MyInv^ do Begin
    If True Or (TabbedNoteBook1.ActivePage = 'Transaction') Then Begin
      {* Transaction Header Fields *}
      Tr_Code.Text          := CustCode;   {* Customer Code *}
      Tr_OurRef.Text        := OurRef;     {* Exchequer Ref. No *}
      Tr_TransDate.Text     := TransDate + ' (' + IntToStr(AcYr) + '/' + IntToStr(AcPr) + ')';  {* Transaction Date *}
      Tr_DueDate.Text       := DueDate;    {* Due Date *}
      Tr_Period.Text        := IntToStr(AcPr) + '/' + IntToStr(AcYr);  {* Accounts Period & Year *}
      Tr_YourRef.Text       := YourRef;    {* Your Reference *}
      Tr_AltRef.Text        := LongYrRef;  {* Long Your Reference *}
      Lab_TotalCost.Caption := Format ('%10.2f', [InvNetVal]);         {* Total Cost/Net Value *}

      {* Transaction Detail lines fields *}

      {* clear details box *}
      List_TransLines.Clear;
      If (LineCount > 0) Then
      begin
        For I := 1 To LineCount Do       {* up to no. of transaction lines *}
        begin
          With MyInvLines^[I] Do Begin

          {* ======= if using Ptr position calculation ========= *}

          {FillChar(TmpIdRec,SizeOf(TmpIdRec),#0); }
          {$IFDEF WIN32}
            {
            RecPos:=LongInt(PL)+( Pred(I)*SizeOf(TmpIdRec));
            Move(Pointer(RecPos)^,TmpIdRec,SizeOf(TmpIdRec));
           }
          {$ELSE}
          {
            RecSeg:=Seg(PL^);
            RecOfs:=Ofs(PL^);
            RecOfs:=RecOfs + ( Pred(I)*SizeOf(TmpIdRec) );
            Move(Ptr(RecSeg,RecOfs)^,TmpIdRec,SizeOf(TmpIdRec) );
           }
          {$ENDIF}
          {With TmpIdRec do Begin}

          {* ================================================== *}

            {* fill blank in details box for current line *}
            FillChar (LineStr, SizeOf(LineStr), #32);
            LineStr[0] := #100;

            {* Move ... *}
            If (Length (StockCode) > 0) then    {* Stock Code *}
              Move (StockCode[1], LineStr[1], Length (StockCode));
            If (Qty > 0) Then Begin             {* Quantity *}
              Tmp := Format ('%4.2f', [Qty]);
              Move (Tmp[1], LineStr[18], Length (Tmp));
            End; { If }
            If (Length(Desc) > 35) Then         {* Description *}
              Move (Desc[1], LineStr[26], 35)
            Else
              Move (Desc[1], LineStr[26], Length (Desc));
            If (NetValue <> 0) Then Begin        {* Unit Price *}
              Tmp := Format ('%10.2f', [NetValue]);
              Move (Tmp[1], LineStr[65], Length (Tmp));
            End; { If }
            List_TransLines.Items.Add(LineStr);
          End; { With }

        End; {For ..}

      End; {If LineCount>0..}
    End; { If True or..}
  End; { With }
End;


{* ===== Add Transaction Record ========== *}
{* This routine is just for one Sales Invoice transaction *}

procedure TForm1.But_AddTransClick(Sender: TObject);
Var
  ExStat  :  Integer;
  PC      :  PChar;
  P,PL    :  Pointer;
begin
  {* assign Transaction Document Type as SIN *}
  MyInv^.TransDocHed := 'NOM';

  {* allocate memory buffer for PC as String 255 *}
  PC := StrAlloc (255);
  {* assign Trans. Document Type into PC *}
  StrPCopy(PC,MyInv^.TransDocHed);

  {* assign Trans.Header and Lines Memory Address *}
  P:=MyInv;
  PL:=MyInvLines;

  {* get Next Trans. Number using DLL function *}
  {ExStat:=Ex_GetNextTransNo(PC,PC,True);}

  ExStat:=0;

  If (EXStat=0) then Begin
    {* fill blank in Trans.Header buffer *}
    FillChar (MyInv^, SizeOf (MyInv^), #0);
    {* assign data into memory buffer *}
    With MyInv^ Do Begin
      OurRef      := 'ADJ'; {StrPas(PC);      {* Exchequer Reference No *}
      CustCode    := '';        {* Customer Code *}
      TransDate   := '20010214';   {* Transaction Date *}
      DueDate     := '20010214';   {* Due Date *}
      Currency    := 1;            {* Currency 1=Sterling *}
      AcYr        := 101;          {* Accounting Year *}
      AcPr        := 1;           {* Accounting Period *}
      CoRate      := 1;            {* Company Exchange Rate *}
      VATRate     := 1;            {* VAT Rate *}
      YourRef     := 'ADJ';        {* Your Reference *}
      LongYrRef   := 'ADJ-JOB';    {* Long Your Reference *}
      LineCount   := 1;            {* No. of Trans. Lines *}
      TransDocHed := 'ADJ';        {* Document Type *}
      InvNetVal   := 0.00;         {* Total Net Value *}
      InvVatAnal[0]:=0.00;
      InvVat      := 0.00;            {* Total VAT Value *}
      TotalCost   := 0.0;          {* Total Cost *}
      {TotOrdOS    := InvNetVal;
      TransNat    := 10;
      TransMode   := 1;
      }

    End; { With }

    {* assign data for Line 1 of Transaction Lines *}
    With MyInvLines^[1] Do Begin
      TransRefNo  := MyInv^.OurRef;       {* Exchequer Reference Number *}
      LineNo      := 1;                   {* Transaction Line Number *}
      NomCode     := 2202;               {* Nominal Code *}
      Currency    := MyInv^.Currency;     {* Currency *}
      CoRate      := 1;                 {* Company Exchange Rate *}
      VATRate     := 1;                 {* VAT Rate *}
      StockCode   := 'TEST1';             {* Stock Code *}
      Desc        := 'import using dll';
      Qty         := -1.0;                 {* Quantity *}
      QtyMul      := 1.0;                 {* Quantity Multiplication Factor *}
      NetValue    := 0.00;                {* Unit Price *}
      Discount    := 0.0;                 {* Discount Amount *}
      VATCode     := #0;                 {* VAT Code S=Standard *}
      VAT         := 0.00;                   {* VAT Amount *}
      CostPrice   := 0.0;                 {* Cost Price *}
      CustCode    := MyInv^.CustCode;     {* Customer Code *}
      LineDate    := MyInv^.TransDate;          {* Transaction Date *}
      Payment     := True;
      KitLink     := 0;
      MLocStk     := 'AAA';
      CC          := 'AAA';
      Dep         := 'AAA';
      JobCode     := 'JOB1';
      AnalCode    := 'D-MATERIAL';
    End; { With }

    With MyInvLines^[2] Do Begin
      TransRefNo  := MyInv^.OurRef;       {* Exchequer Reference Number *}
      LineNo      := 2;                   {* Transaction Line Number *}
      NomCode     := 20011;               {* Nominal Code *}
      Currency    := MyInv^.Currency;     {* Currency *}
      CoRate      := 1;                 {* Company Exchange Rate *}
      VATRate     := 1;                 {* VAT Rate *}
      StockCode   := 'PayRefVAT';             {* Stock Code *}
      Desc        := '';
      Qty         := 1.0;                 {* Quantity *}
      QtyMul      := 1.0;                 {* Quantity Multiplication Factor *}
      NetValue    := 1169.46;                {* Unit Price *}
      Discount    := 0.0;                 {* Discount Amount *}
      VATCode     := 'Z';                 {* VAT Code S=Standard *}
      VAT         := 0;                   {* VAT Amount *}
      CostPrice   := 0.0;                 {* Cost Price *}
      CustCode    := MyInv^.CustCode;     {* Customer Code *}
      LineDate    := MyInv^.TransDate;          {* Transaction Date *}
      Payment     := True;
      KitLink     := 0;
      MLocStk     := '';
      CC          := 'AAA';
      Dep         := 'AAA';

    End; { With }


(*
    {* assign data for Line 2 of Transaction Lines *}
    With MyInvLines^[2] Do Begin
      TransRefNo  := MyInv^.OurRef;       {* Exchequer Reference Number *}
      LineNo      := 2;                   {* Transaction Line Number *}
      NomCode     := 10010;               {* Nominal Code *}
      Currency    := MyInv^.Currency;     {* Currency *}
      CoRate      := 1.0;                 {* Company Exchange Rate *}
      VATRate     := 0.175;               {* VAT Rate *}
      StockCode   := 'PROD 1B         ';  {* Stock Code *}
      Qty         := 4.0;                 {* Quantity *}
      QtyMul      := 1.0;                 {* Quantity Multiplication Factor *}
      NetValue    := 15.00;               {* Unit Price *}
      Discount    := 0.0;                 {* Discount Amount *}
      VATCode     := 'S';                 {* VAT Code S=Standard *}
      VAT         := 0.0;                 {* VAT Amount *}
      CostPrice   := 13.00;               {* Cost Price *}
      CustCode    := MyInv^.CustCode;     {* Customer Code *}
      LineDate    := MyInv^.TransDate;    {* Transaction Date *}
      Desc        := 'Inverse Flange Sprocket';     {* Line Description *}
    End; { With }
*)
    {* calculate Total Net Value *}

    With MyInv^ Do
      InvNetVal := (MyInvLines^[1].Qty * MyInvLines^[1].NetValue);
                   {+(MyInvLines^[2].Qty * MyInvLines^[2].NetValue);}

    {* Store Transaction using DLL function *}
    If (Sender=B_EBus) then
      ExStat:=Ex_StoreEBusTrans(P,PL,SizeOf(MyInv^),SizeOf(MyInvLines^),0,B_Insert)
    else
      ExStat:=Ex_StoreTrans(P,PL,SizeOf(MyInv^),SizeOf(MyInvLines^),0,B_Insert);

  end;

  {* display DLL result *}
  ShowMessage ('Result: ' + IntToStr(ExStat)+#13#10+
               Ex_GetLastErrorDesc);
  {* dispose allocated PC buffer *}
  StrDispose (PC);
End;


{* ===== Find Transaction Record according to user's choice button ========== *}

procedure TForm1.TransBtrieve(Sender: TObject);
Var
  ExStat  :  Integer;
  TRef,TFrm,
  PC,PC1  :  PChar;
  PLine,
  P,PL    :  Pointer;

  TRecAddr,
  Key1,
  TLines  :  LongInt;

  GenStr  :  String[255];

begin
  {* assign Exchequer Reference number *}
  With MyInv^ Do
    OurRef:=Tr_OurRef.Text;

  {* allocater buffer for PC as String 255 *}
  PC := StrAlloc (255);
  PC1:= StrAlloc (255);

  {* assign Ref.No into PC *}
  StrPCopy(PC, MyInv^.OurRef);

  {* assign Index Key as Transaction Number *}
  CurrKPath:=0;

  {* assign Transaction Header & Lines Memory Address *}
  P:=MyInv;
  PL:=MyInvLines;


  {* Use DLL Function to retrieve when user press ..*}
  {* First Button *}
  If (Sender = Button1) Then ExStat:=Ex_GetTrans(P,PL,SizeOf(MyInv^),SizeOf(MyInvLines^),PC,CurrKPath,B_GetFirst,LockStat);
  {* Previous Button *}
  If (Sender = Button2) Then ExStat:=Ex_GetTrans(P,PL,SizeOf(MyInv^),SizeOf(MyInvLines^),PC,CurrKPath,B_GetPrev,LockStat);
  {* Find Button *}
  If (Sender = Button3) Then ExStat:=Ex_GetTrans(P,PL,SizeOf(MyInv^),SizeOf(MyInvLines^),PC,CurrKPath,B_GetGEq,LockStat);
  {* Next Button *}
  If (Sender = Button4) Then ExStat:=Ex_GetTrans(P,PL,SizeOf(MyInv^),SizeOf(MyInvLines^),PC,CurrKPath,B_GetNext,LockStat);
  {* Last Button *}
  If (Sender = Button5) Then ExStat:=Ex_GetTrans(P,PL,SizeOf(MyInv^),SizeOf(MyInvLines^),PC,CurrKPath,B_GetLast,LockStat);


(*
  {* Testing for Ex_GetTransHed Function .. *}
  If (Sender = Button1) Then ExStat:=Ex_GetTransHed(P,SizeOf(MyInv^),PC,CurrKPath,B_GetFirst,False);
  If (Sender = Button2) Then ExStat:=Ex_GetTransHed(P,SizeOf(MyInv^),PC,CurrKPath,B_GetPrev,False);
  If (Sender = Button3) Then ExStat:=Ex_GetTransHed(P,SizeOf(MyInv^),PC,CurrKPath,B_GetGEq,False);
  If (Sender = Button4) Then ExStat:=Ex_GetTransHed(P,SizeOf(MyInv^),PC,CurrKPath,B_GetNext,False);
  If (Sender = Button5) Then ExStat:=Ex_GetTransHed(P,SizeOf(MyInv^),PC,CurrKPath,B_GetLast,False);

*)

(* Testing for Ex_GetTransLine ....
  PLine:=MyId;
  Key1:=MyInv^.FolioNum;

  Ex_VB_ConvertFolio(Key1,VBStr);  { Conversion of Folio Key from LongInt to String }
  GenStr:=VBStr;
  StrPCopy(PC, GenStr);

  If (Sender = Button1) Then ExStat:=Ex_GetTransLine(PLine,SizeOf(MyId^),PC,CurrKPath,B_GetFirst,False);
  If (Sender = Button2) Then ExStat:=Ex_GetTransLine(PLine,SizeOf(MyId^),PC,CurrKPath,B_GetPrev,False);
  If (Sender = Button3) Then ExStat:=Ex_GetTransLine(PLine,SizeOf(MyId^),PC,CurrKPath,B_GetGEq,False);
  If (Sender = Button4) Then ExStat:=Ex_GetTransLine(PLine,SizeOf(MyId^),PC,CurrKPath,B_GetNext,False);
  If (Sender = Button5) Then ExStat:=Ex_GetTransLine(PLine,SizeOf(MyId^),PC,CurrKPath,B_GetLast,False);

  MyInv^.LineCount:=1;
  MyInvLines^[1]:=MyId^;
*)

(*
  {Testing for Ex_GetTLLine .....}
  With MyInvLines^[1] do
  begin
    PLine:=MyId;
    ExStat:=Ex_GetTLLine(MyInv.FolioNum,LineNo,PLine,SizeOf(MyId^));
    With MyId^ do
      ShowMessage(TransRefNo+' '+CustCode+'   '+StockCode);
  end;
*)

  {* convert data from memory buffer to screen fields *}
  DispTrans;

  DispInUpdateBox;

  {* to display Total Number of Transaction Lines *}
  TLines:=0;
  StrPCopy(PC1, MyInv^.OurRef);

  {* use DLL function with Ex.Ref.No *}
  TLines:=Ex_GetTotalTransLines(PC1);
  TLines:=MyInv^.LineCount;
  If (TLines<>0) then
  begin
    Label78.Visible:=True;
    Lab_TLines.Caption:=IntToStr(TLines);
  end
  else
    Lab_TLines.Caption:='';

(*
  {* Test for Serial No *}
  If (ExStat=0) then
  begin
    SrNoChk:=True;
    S_Field1.Text:=MyInv^.OurRef;
    S_Field2.Text:='1';
    SRBTrieve(S_Find);
  end;
 *)

  {* dispose allocated PC buffer *}
  StrDispose (PC);
  StrDispose (PC1);

end;


(***************************************************************)
(* Nominal Display Routine                                     *)
(***************************************************************)

{* ===== Convert Nominal Data from Memory Buffer to Screen Fields ========== *}

Procedure TForm1.DispNom;
Begin
  With MyGLAcc^ Do Begin
    GL_Code.Text  := IntToStr(NomCode);     {* Nominal Code *}
    GL_Desc.Text  := Desc;                  {* Description *}
    GL_NomType.Text := NomType;             {* Nominal Type *}
    GL_Cat.Text     := IntToStr(Cat);       {* Nominal Group Code *}
    GL_CarryF.Text  := IntToStr(CarryF);    {* Carry Forward *}
  End; { With }
End;

{* ===== Convert Nominal Data from Screen Fields to Memory Buffer ========== *}

procedure TForm1.NomBtrieve(Sender: TObject);
Var
  ExStat  :  Integer;
  PC      :  PChar;
  P,PL    :  Pointer;

begin
  {* allocate memory buffer for PC as String 255 *}
  PC := StrAlloc(255);

  {* assign Index Key as Nominal Code Key *}
  If radNomCode.Checked Then
  begin
    CurrKPath:=0;  { Nominal Code }
    {* assign Nominal code into PC *}
    StrPCopy(PC,GL_Code.Text);

  end
  Else
  begin
    CurrKPath:=1; { Description }
    {* assign Nominal Description into PC *}
    StrPCopy(PC,GL_Desc.Text);
  end;

  {* assig Nominal memory buffer address *}
  P:=MyGLAcc;
  {* First Button *}
  If (Sender = First   ) Then ExStat:=Ex_GetGLAccount(P,SizeOf(MyGLAcc^),PC,CurrKPath,B_GetFirst,LockStat);
  {* Previous Button *}
  If (Sender = Previous) Then ExStat:=Ex_GetGLAccount(P,SizeOf(MyGLAcc^),PC,CurrKPath,B_GetPrev,LockStat);
  {* Find Button *}
  If (Sender = Find    ) Then ExStat:=Ex_GetGLAccount(P,SizeOf(MyGLAcc^),PC,CurrKPath,B_GetGEq,LockStat);
  {* Next Button *}
  If (Sender = Next    ) Then ExStat:=Ex_GetGLAccount(P,SizeOf(MyGLAcc^),PC,CurrKPath,B_GetNext,LockStat);
  {* Last Button *}
  If (Sender = Last    ) Then ExStat:=Ex_GetGLAccount(P,SizeOf(MyGLAcc^),PC,CurrKPath,B_GetLast,LockStat);

  {* If no error returns, convert data to display *}
  If ExStat=0 then
    DispNom
  else
    ShowMessage('Ex_GetGLAccount Error : '+IntToStr(ExStat));
  {* dispose allocated PC buffer *}
  StrDispose (PC);
end;


{* ===== Convert Nominal Data from Screen Fields to Memory Buffer Fields ========== *}

Procedure TForm1.Nom_Data;
Const
  EmptyStr : String = '';
Begin
  {* fill blank in Nominal memory buffer *}
  FillChar (MyGLAcc^, SizeOf (MyGLAcc^), #0);
  {* convert data *}
  With MyGLAcc^ Do
  Begin
    NomCode := StrToInt(GL_Code.Text);   {* Nominal code *}
    Desc    := GL_Desc.Text;             {* Description *}
    Cat     := StrToInt(GL_Cat.Text);    {* Group Code *}
    CarryF  := StrToInt(GL_CarryF.Text); {* Carry Forward *}
    If (GL_NomType.Text<>EmptyStr) then
      NomType := GL_NomType.Text[1];     {* Nominal Type *}

  End; { With }
end;

{* ===== Add or Save Button is Chosen from Nominal Page ========== *}

procedure TForm1.Nom_AddClick(Sender: TObject);
Var
  ExStat, I : Integer;
  P         : Pointer;
begin
  {* If Add button is chosen *}
  If (Nom_Add.Caption = '&Add') Then
  Begin
    {* change Add & Edit buttons as Save & Cancel *}
    Nom_Add.Caption := '&Save';
    Nom_Edit.Caption := '&Cancel';
    {* Not Edit Status Mode *}
    FEdit := False;
    {* assign Nominal Code into Temp.Field *}
    TmpKey := GL_Code.Text;
    {* fill blank in Nominal memory buffer *}
    FillChar (MyGLAcc^, SizeOf (MyGLAcc^), #0);
    {* convert data to display *}
    DispNom;

    If GL_Code.CanFocus Then GL_Code.SetFocus;

  End
  Else
  {* Save Button is chosen *}
  Begin
    {* Convert from screen fields to memory fields of Nominal data *}
    Nom_Data;
    {* assign Nominal memory buffer address *}
    P:=MyGLAcc;

    If FEdit Then
      {* if Save from Edit Mode, update record *}
      ExStat:=Ex_StoreGLAccount (P, SizeOf (MyGLAcc^), 0, B_Update)
    Else
      {* if Save from Add Mode, add new record *}
      ExStat:=Ex_StoreGLAccount (P, SizeOf (MyGLAcc^), 0, B_Insert);

    Case ExStat Of
      0     : Begin {* record is successfully saved *}
                {* change Save & Cancel buttons as Add & Edit *}
                Nom_Add.Caption := '&Add';
                Nom_Edit.Caption := '&Edit';
              End;
      5     : Begin { Btrieve Error 5: Duplicates }
                If GL_Code.CanFocus Then GL_Code.SetFocus;
                ShowMessage ('Nominal code already exists !');
              End;
    Else
      ShowMessage ('Error: ' + IntToStr(ExStat));
    End; { Case }
  End; { Else }

  {* change Enable Status for .. *}
  First.Enabled    := (Nom_Add.Caption = '&Add');  {* First *}
  Previous.Enabled := (Nom_Add.Caption = '&Add');  {* Previous *}
  Find.Enabled     := (Nom_Add.Caption = '&Add');  {* Find *}
  Next.Enabled     := (Nom_Add.Caption = '&Add');  {* Next *}
  Last.Enabled     := (Nom_Add.Caption = '&Add');  {* Last *}

end;

{* ===== Edit or Cancel Button is chosen from Nominal Page ========== *}

procedure TForm1.Nom_EditClick(Sender: TObject);
begin
  {* Cancel button is chosen *}
  If (Nom_Edit.Caption = '&Cancel') Then Begin
    {* fill blank in Nominal memory buffer *}
    FillChar (MyGLAcc^, SizeOf (MyGLAcc^), #0);
    {* assign back Nominal Code from Temp. field *}
    GL_Code.Text := TmpKey;
    {* Find record with assigned Code *}
    NomBtrieve(Find);
    {* change Save & Cancel buttons as Add & Edit *}
    Nom_Add.Caption := '&Add';
    Nom_Edit.Caption := '&Edit';
  End { If }
  Else
  {* Edit Button is chosen *}
  Begin
    {* change Add & Edit Button as Save & Cancel *}
    Nom_Add.Caption := '&Save';
    Nom_Edit.Caption := '&Cancel';

    {* Edit Status is True *}
    FEdit := True;
    TmpKey := GL_Code.Text;
    If GL_Code.CanFocus Then GL_Code.SetFocus;
  End; { Else }

  {* change Enable Status for .. *}
  First.Enabled    := (Cu_Add.Caption = '&Add');      {* First Button *}
  Previous.Enabled := (Cu_Add.Caption = '&Add');      {* Previous Button *}
  Find.Enabled     := (Cu_Add.Caption = '&Add');      {* Find Button *}
  Next.Enabled     := (Cu_Add.Caption = '&Add');      {* Next Button *}
  Last.Enabled     := (Cu_Add.Caption = '&Add');      {* Last Button *}
end;

(***************************************************************)
(* Display BOM Lines Routines                                  *)
(***************************************************************)

{* ===== Display BOM Lines Data ========== *}
Procedure TForm1.DispBOM;
Const
  MaxLines = 500;
Var
  LineStr, Tmp : String[100];
  I            : Integer;
Begin
  If True Or (TabbedNoteBook1.ActivePage = 'BOM') Then
  Begin
    {* clear BOM Lines box & move data to be displayed *}
    ListBOMLines.Clear;
    For I := 1 To MaxLines Do
    With MyBOMLines^[I] Do Begin
      FillChar (LineStr, SizeOf(LineStr), #32);
      LineStr[0] := #100;

      {* StockCode *}
      If (Length (StockCode) > 0) Then
        Move (StockCode[1], LineStr[11], 16);

      {* QtyUsed *}
      If (QtyUsed > 0) Then Begin
        Tmp := Format ('%10.2f', [QtyUsed]);
        Move (Tmp[1], LineStr[28], 10);
      End;

      {* QtyCost *}
      If (QtyCost > 0) Then Begin
        Tmp := Format ('%10.2f', [QtyCost]);
        Move (Tmp[1], LineStr[40], 12);
      End;

      ListBOMLines.Items.Add(LineStr);

    End; { With }
  end; {If True..}
End;

{* ===== To retrieve BOM data ========== *}
procedure TForm1.BOMBTrieve(Sender: TObject);
Const
  ToggleKey : Array[0..1] of SmallInt =(0,1);
  ToggleMsg : Array[0..1] of String[10] = ('Where Used','Components');

Var
  ExStat  :  Integer;
  PC      :  PChar;
  P       :  Pointer;
  SMode   :  SmallInt;

begin

  {* allocate memory buffer for PC as String 255 *}
  PC := StrAlloc (255);
  {* assign user's required Stock Code into PC *}
  StrPCopy(PC, B_StockCode.Text);

  {* define Search Mode as "Where Used" or "Components" option *}
  If (B_Toggle.Caption=ToggleMsg[0]) then
    SMode:=ToggleKey[0]  {* Where Used *}
  else
    SMode:=ToggleKey[1]; {* Components *}

  {* assign BOM Lines memory buffer address *}
  P:=MyBOMLines;

  {* if Find button is chosen, retrieve data using DLL function *}
  If (Sender = B_Find) Then
  begin
     ExStat:=Ex_GetStockBOM(P,SizeOf(MyBOMLines^),PC,SMode);

     If (ExStat=0) then
       DispBOM     {* if no error returns, display details *}
     else
       ShowMessage('Ex_GetStockBOM Error : '+IntToStr(ExStat));

  end;
  {* dispose allocated PC buffer *}
  StrDispose (PC);
end;


{* ===== BOM Cancel Button is chosen ========== *}
procedure TForm1.B_CancelClick(Sender: TObject);
Const
  ToggleMsg : Array[0..1] of String[10] = ('Where Used','Components');
begin
  {* clear currenct information & wait at Stock Field *}
  B_StockCode.Text:='';
  B_Toggle.Caption:=ToggleMsg[0];
  ListBOMLines.Clear;
  B_StockCode.SetFocus;
end;

{* ===== user's option to choose "Where Used" or "Components" ========== *}
procedure TForm1.B_ToggleClick(Sender: TObject);
{Toggle for SearchMode -> Where Used=0  Components=1 }

Const
  ToggleMsg : Array[0..1] of String[10] = ('Where Used','Components');
begin
  If B_Toggle.Caption=ToggleMsg[0] then
     B_Toggle.Caption:=ToggleMsg[1]
  else
     B_Toggle.Caption:=ToggleMsg[0];
end;


(***************************************************************)
(* Display Serial Lines Routines                               *)
(***************************************************************)

{* If user's option is " By Transaction" .. *}
procedure TForm1.S_ByTranClick(Sender: TObject);
begin
  {* display Transaction No & Line No and wait at Trans. No field *}
  SRNoChk:=True;
  S_Box.Clear;
  S_Label1.Caption:='Transaction No';
  S_Label2.Caption:='Line No ';
  S_Field1.Text:='';
  S_Field2.Text:='0';
  S_Field1.SetFocus;
end;

{* If user's option is " By Serial No" ..*}
procedure TForm1.S_BySerailClick(Sender: TObject);
begin
  {* display Serial No & Batch No and wait at Serial No field *}
  SRNoChk:=False;
  S_Box.Clear;
  S_Label1.Caption:='Serial Number ';
  S_Label2.Caption:='Batch No';
  S_Field1.Text:='';
  S_Field2.Text:='';
  S_Field1.SetFocus;
end;

{* Serial No Page - Cancel Button is chosen.. *}
procedure TForm1.S_CancelClick(Sender: TObject);
begin
  {* clear current information *}
  SRNoChk:=True;
  S_Box.Clear;
  S_Label1.Caption:='Transaction No';
  S_Label2.Caption:='Line No ';
  S_Field1.Text:='';
  S_Field2.Text:='0';
  S_ByTran.SetFocus;
  S_Field1.SetFocus;
end;

{* ===== To display BOM details line ========== *}
Procedure TForm1.DispSR;
Const
  MaxLines = 500;
Var
  LineStr, Tmp : String[100];
  I            : Integer;
Begin
  If True Or (TabbedNoteBook1.ActivePage = 'Serial No') Then
  Begin
    {* clear detail line box  & move data into box *}
    S_Box.Clear;
    For I := 1 To MaxLines Do
    With MySRLines^[I] Do Begin
      FillChar (LineStr, SizeOf(LineStr), #32);
      LineStr[0] := #100;

      {* SerialNo *}
      If (Length (SerialNo) > 0) Then
        Move (SerialNo[1], LineStr[1], 20);

      {* BatchNo *}
      If (Length (BatchNo) > 0) Then Begin
        {* Display Used or Available Qty *}
        If (Sold) then
        begin
          Tmp:='Used';
          Move (Tmp[1], LineStr[1], 4);
          Tmp := Format ('%6.2f', [QtyUsed]);
          Move (Tmp[1], LineStr[5], 6);
        end
        else
        begin
          Tmp:='Aval';
          Move (Tmp[1], LineStr[1], 4);
          Tmp := Format ('%6.2f', [BuyQty-QtyUsed]);
          Move (Tmp[1], LineStr[5], 6);
        end;

        {* and Quantity Bought *}
        Tmp:='/';
        Move (Tmp[1], LineStr[11], 1);
        Tmp := Format ('%6.2f', [BuyQty]);
        Move (Tmp[1], LineStr[12], 6);

        Move (BatchNo[1], LineStr[21], 10);

      end;

      {* Qty Sold Date *}
      If (Length (DateOut) > 0) Then
        Move (DateOut[1], LineStr[32], 8);

      {* In MultiLocation *}
      If (Length(InMLoc)>0) then
        Move(InMLoc[1],LineStr[44],3);

      {* Out MultiLocation *}
        If (Length(OutMLoc)>0) then
        Move(OutMLoc[1],LineStr[48],3);

      {* Currency & Cost Price *}
      If (SerCost > 0) Then Begin
        {FillChar(Tmp,SizeOf(Tmp),#0);}
        Tmp := IntToStr(CurCost);
        Move (Tmp[1], LineStr[53], SizeOf(CurCost));

        Tmp := Format ('%8.2f', [SerCost]);
        Move (Tmp[1], LineStr[56], 8);
      End;

      {* Currency & Selling Price *}
      If (SerSell > 0) Then Begin
        Tmp := IntToStr(CurSell);
        Move (Tmp[1], LineStr[67], SizeOf(CurSell));

        Tmp := Format ('%8.2f', [SerSell]);
        Move (Tmp[1], LineStr[70], 8);
      End;

      S_Box.Items.Add(LineStr);

    End; { With }
  end; {If True..}
End;

{* ===== Find Serial Nos according to User's Option ========== *}
procedure TForm1.SRBTrieve(Sender: TObject);
Const
  EmptyStr: string = '';
Var
  ExStat  :  Integer;
  PC      :  PChar;
  P       :  Pointer;
  SKey,
  SMode   :  SmallInt;

begin

  {* allocate memory buffer for PC as String 255 *}
  PC := StrAlloc (255);
  {* assign Search Key into PC (by Tran. or By Serial No *}
  StrPCopy(PC, S_Field1.Text);

  {* If by Transaction No option, *}
  If (SRNoChk) then
  begin
    {* For SearchMode and SearchKey  *}
    SMode:=0;
    SKey:=StrToInt(S_Field2.Text);
  end
  else
  begin
    SMode:=1;
    SKey:=0;
    {If Serial No. is Empty, SearchKey PC = By Batch No}
    If (S_Field1.Text=EmptyStr) then
      StrPCopy(PC, S_Field2.Text);
  end;

  {* assign Serial Numbers Memory buffer Address *}
  P:=MySRLines;

  {* Use DLL function to retrieve data *}
  If (Sender = S_Find) Then
  begin

     ExStat:=Ex_GetLineSerialNos(P,SizeOf(MySRLines^),PC,SKey,SMode);
     If (ExStat=0) then
       {* if no error returns *}
       DispSR
     else

       ShowMessage('Ex_GetLineSerialNos Error : '+IntToStr(ExStat));

  end;
  {* dispose allocated PC *}
  StrDispose (PC);
end;


(***************************************************************)
(* Display Job Routines                                        *)
(***************************************************************)

{* ===== Convert Job information from Memory fields to Screen fields ========== *}
Procedure TForm1.DispJob;
const
  CondYN  : Array[False..True] of Char = ('N','Y');

begin
  With MyJob^ do
  begin
    J_JobCode.Text:=JobCode;           {* Job Code *}
    J_JobDesc.Text:=JobDesc;           {* Description *}
    J_CustCode.Text:=CustCode;         {* Customer Code *}
    J_JobCat.Text:=JobCat;             {* Category *}
    J_JobAltCode.Text:=JobAltCode;     {* Alternative Code *}
    J_SORRef.Text:=SORRef;             {* SOR Reference No *}
    J_JobAnal.Text:=JobAnal;           {* Analysis Code *}
    J_Contact.Text:=Contact;           {* Contact Name *}
    J_JobMan.Text:=JobMan;             {* Manager Name *}
    J_StartDate.Text:=StartDate;       {* Job Start Date *}
    J_EndDate.Text:=EndDate;           {* End Date *}
    J_RevEDate.Text:=RevEDate;         {* Revised Date *}

    J_QuotePrice.Text:=FloatToStrF(QuotePrice,ffFixed,15,2);   {* Quote Price *}

    J_CurrPrice.Text:=IntToStr(CurrPrice);  {* Currency *}
    J_Completed.Text:=CondYN[Completed];    {* Complete Status Yes/No *}
    J_VATCode.Text:=VATCode;                {* VAT Code *}
    J_ChargeType.Text:=ChargeType;          {* Charge Type (T/F/C/N) *}
    J_JobStat.Text:=JobStat;                {* Job Status (Q/A/S/C/L) *}
    J_JobType.Text:=JobType;                {* Job Type (K/J) *}

  end;
end;

{* ===== Find Job Record according to user's choice button ========== *}

procedure TForm1.BTrieveJob(Sender: TObject);
Var
  ExStat  :  Integer;
  PC      :  PChar;
  P,PL    :  Pointer;

begin
  {* assign Job code into memory buffer field *}
  With MyJob^ Do
    JobCode:=J_JobCode.Text;

  {* allocate memory buffer for PC as String 255 *}
  PC := StrAlloc (255);
  {* assign Job Code into PC *}
  StrPCopy(PC, MyJob^.JobCode);
  {* assign Index Key as Job Code Key *}
  CurrKPath:=0;
  {* assign Job memory buffer address *}
  P:=MyJob;
  {* Use DLL's Ex_GetJob Function for .. *}
  {* First Button *}
  If (Sender = J_First )   Then ExStat:=Ex_GetJob(P,SizeOf(MyJob^),PC,CurrKPath,B_GetFirst,LockStat);
  {* Previous Button *}
  If (Sender = J_Previous) Then ExStat:=Ex_GetJob(P,SizeOf(MyJob^),PC,CurrKPath,B_GetPrev,LockStat);
  {* Find Button *}
  If (Sender = J_Find  )   Then ExStat:=Ex_GetJob(P,SizeOf(MyJob^),PC,CurrKPath,B_GetGEq,LockStat);
  {* Next Button *}
  If (Sender = J_Next  )   Then ExStat:=Ex_GetJob(P,SizeOf(MyJob^),PC,CurrKPath,B_GetNext,LockStat);
  {* Last Button *}
  If (Sender = J_Last  )   Then ExStat:=Ex_GetJob(P,SizeOf(MyJob^),PC,CurrKPath,B_GetLast,LockStat);

  {* convert Job data to display *}
  DispJob;



  {* dispose allocated PC *}
  StrDispose (PC);
end;

{* ===== Convert Job Data from Screen Fields to Memory Buffer Fields ========== *}

procedure TForm1.Job_Data;
begin
  FillChar(MyJob^,SizeOf(MyJob^),#0);
  With MyJob^ do
  begin
    JobCode:=J_JobCode.Text;         {* Job Code *}
    JobDesc:=J_JobDesc.Text;         {* Description *}
    CustCode:=J_CustCode.Text;       {* Customer Code *}
    JobCat:=J_JobCat.Text;           {* Job Category *}
    JobAltCode:=J_JobAltCode.Text;   {* Alternative code *}
    SORRef:=J_SORRef.Text;           {* SOR Reference No *}
    JobAnal:=J_JobAnal.Text;         {* Job Analysis Code *}
    Contact:=J_Contact.Text;         {* Contact Name *}
    JobMan:=J_JobMan.Text;           {* Job Manager *}
    StartDate:=J_StartDate.Text;     {* Job Start Date *}
    EndDate:=J_EndDate.Text;         {* End Date *}
    RevEDate:=J_RevEDate.Text;       {* Revised Date *}
    VATCode:=J_VATCode.Text[1];      {* VAT Code *}
    QuotePrice:=StrToFloat(J_QuotePrice.Text);  {* Quote Price *}
    CurrPrice:=StrToInt(J_CurrPrice.Text);      {* Currency *}
    If (J_Completed.Text<>'') then
      Completed:=(J_Completed.Text[1]='Y');     {* Completed Status *}
    If (J_ChargeType.Text<>'') then
      ChargeType:=J_ChargeType.Text[1];         {* Charge Type (T/F/C/N) *}
    If (J_JobStat.Text<>'') then
      JobStat:=J_JobStat.Text[1];               {* Job Status (Q/A/S/C/L) *}
    If (J_JobType.Text<>'') then
      JobType:=J_JobType.Text[1];               {* Job Type (K/J) *}
  end;
end; {proc..}


{* ===== Job Page - Add or Save Button is chosen ========== *}
procedure TForm1.Job_Add(Sender: TObject);
Var
  ExStat, I : Integer;
  P         : Pointer;
begin
  {* Add Button is chosen *}
  If (J_Add.Caption = '&Add') Then
  Begin
    {* change Add & Edit Buttons as Save & Cancel *}
    J_Add.Caption := '&Save';
    J_Edit.Caption := '&Cancel';

    {* Edit Status is False *}
    FEdit := False;
    {* assign Job code into Tmp. field *}
    TmpKey := J_JobCode.Text;
    {* fill blank in Job memory buffer *}
    FillChar (MyJob^, SizeOf (MyJob^), #0);
    {* convert Job data to display *}
    DispJob;
    {* wait at Job Code field *}
    If J_JobCode.CanFocus Then J_JobCode.SetFocus;

  End
  Else
  {* Save Button is chosen *}
  Begin
    {* convert Job data from screen fields to memory buffer fields *}
    Job_Data;
    {* assign Job buffer address *}
    P:=MyJob;

    If FEdit Then
      {* if Save from Edit Mode *}
      ExStat:=Ex_StoreJob(P, SizeOf(MyJob^), 0, B_Update)
    Else
      {* if Save from Add Mode *}
      ExStat:=Ex_StoreJob(P, SizeOf(MyJob^), 0, B_Insert);

    Case ExStat Of
      0     : Begin {* record is successfully saved *}
                {* change Save & Cancel Buttons as Add & Edit *}
                J_Add.Caption := '&Add';
                J_Edit.Caption := '&Edit';
              End;
      5     : Begin { Btrieve Error 5: Duplicates }
                If J_JobCode.CanFocus Then J_JobCode.SetFocus;
                ShowMessage ('Job code already exists !');
              End;
    Else
      ShowMessage ('Ex_StoreJob Error: ' + IntToStr(ExStat));
    End; { Case }
  End; { Else }

  {* change Enable Status for First, Previous, Find, Next & Last Buttons *}
  J_First.Enabled    := (J_Add.Caption = '&Add');
  J_Previous.Enabled := (J_Add.Caption = '&Add');
  J_Find.Enabled     := (J_Add.Caption = '&Add');
  J_Next.Enabled     := (J_Add.Caption = '&Add');
  J_Last.Enabled     := (J_Add.Caption = '&Add');

end;

{* ===== Job Page - Edit or Cancel Button is chosen ========== *}
procedure TForm1.Job_Edit(Sender: TObject);
begin
  {* if Cancel Button is chosen *}
  If (J_Edit.Caption = '&Cancel') Then Begin
    {* fill blank in Job memory buffer *}
    FillChar (MyJob^, SizeOf (MyJob^), #0);
    {* assign back Job Code from Temp. Key *}
    J_JobCode.Text := TmpKey;
    {* Find Job record with assigned Job Code *}
    BtrieveJob(J_Find);
    {* change Save & Cancel Buttons as Add & Edit *}
    J_Add.Caption := '&Add';
    J_Edit.Caption := '&Edit';
  End
  Else
  {* Edit Button is chosen *}
  Begin
    {* change Add & Edit Buttons as Save & Cancel *}
    J_Add.Caption := '&Save';
    J_Edit.Caption := '&Cancel';
    {* Edit Status is true *}
    FEdit := True;
    {* assign Job Code into Tmp. field *}
    TmpKey := J_JobCode.Text;
    If J_JobCode.CanFocus Then J_JobCode.SetFocus;
  End;

  {* change Enable Status for First, Previous, Find, Next & Last Buttons *}
  J_First.Enabled    := (J_Add.Caption = '&Add');
  J_Previous.Enabled := (J_Add.Caption = '&Add');
  J_Find.Enabled     := (J_Add.Caption = '&Add');
  J_Next.Enabled     := (J_Add.Caption = '&Add');
  J_Last.Enabled     := (J_Add.Caption = '&Add');
end;


(***************************************************************)
(* To Add Job Costing Time Sheet Transaction Data              *)
(***************************************************************)

procedure TForm1.TSH_AddClick(Sender: TObject);

Var
  ExStat  :  Integer;
  PC      :  PChar;
  P,PL    :  Pointer;
begin
  {* fill blank for TH & TL memory buffer *}
  FillChar(MyInv^,SizeOf(MyInv^),#0);
  FillChar(MyInvLines^,SizeOf(MyInvLines^),#0);
  {* assign Document Type as "TSH" *}
  MyInv^.TransDocHed := 'TSH';
  {* allocate memory buffer for PC as String 255 *}
  PC := StrAlloc (255);
  {* assign Document Type into PC *}
  StrPCopy(PC,MyInv^.TransDocHed);
  {* assign TH & TL memory buffer address *}
  P:=MyInv;
  PL:=MyInvLines;

  ExStat:=0;

  {*** ExStat:=Ex_GetNextTransNo(PC,PC,True); ***}
  {* It is not necessary to use Ex_GetNextTransNo function if *}
  {* "Overwrite_Trans_No" switch is "ON" in ExchDll.INI file *}

  If (EXStat=0) then Begin
    {* fill blank in TH buffer and assign data *}
    FillChar (MyInv^, SizeOf (MyInv^), #0);
    With MyInv^ Do Begin
      OurRef      := '';               {* Exchequer Reference No *}
      CustCode    := '100056';         {* Customer Code *}
      TransDate   := '19970219';       {* Transaction Date *}
      Currency    := 1;                {* Currency 1=Sterling *}
      AcYr        := 97;               {* Accounting Year *}
      AcPr        := 2;                {*     "      Period *}
      CoRate      := 1.0;              {* Company Exchange Rate *}
      VATRate     := 0.175;            {* VAT Rate *}
      YourRef     := 'Test TSH';       {* Your Reference *}
      LongYrRef   := 'Long TSH Ref.';  {* Long Your Reference *}
      LineCount   := 2;                {* Total No. of Transaction Lines *}
      TransDocHed := 'TSH';            {* Document Type *}
      InvNetVal   := 30.00;            {* Total Net Value *}
      InvVat      := 0.0;              {* Total VAT Value *}
      TotalCost   := 1.57;             {* Total Cost *}
      DJobCode    := 'PLOT1BC1';       {* Job Code *}
      DJobAnal    := 'ELECLAB';        {* Analysis Code *}
      EmpCode     := 'ARMA01';         {* Employee Code *}
      DiscDays    := 12;               {* Week/Month Number *}

    End; { With }

    {* for Transaction Line No. 1 *}
    With MyInvLines^[1] Do Begin
      TransRefNo  := MyInv^.YourRef;              {* Your Reference No. *}
      LineNo      := 1;                           {* Transaction Line No *}
      NomCode     := 510110;                      {* Nominal Code *}
      Currency    := MyInv^.Currency;             {* Line Currency *}
      CoRate      := 1.0;                         {* Company Rate *}
      VATRate     := 0.175;                       {* VAT Rate *}
      Qty         := 2.0;                         {* No. of Hours *}
      QtyMul      := 1.0;                         {* Quantity Multiplication Factor *}
      NetValue    := 20.00;                       {* Rate *}
      Discount    := 0.0;                         {* Discount *}
      VATCode     := 'S';                         {* VAT Code S=Standard *}
      VAT         := 0.0;                         {* Line VAT Amount *}
      CostPrice   := MyInv^.TotalCost;            {* Cost Price *}
      CustCode    := MyInv^.CustCode;             {* Customer Code *}
      LineDate    := MyInv^.TransDate;            {* Transaction Date *}
      Desc        := 'Test Desc. for TSH';        {* Line Description *}
      JobCode     := MyInv^.DJobCode;             {* Job Code *}
      AnalCode    := MyInv^.DJobAnal;             {* Analysis Code *}
      StockCode   := 'ELECSTAND';                 {* Pay Rate Code *}
      TSHCCurr    := 1;                           {* Charge Currency Code *}

    End; { With }

    {* for Transaction Line No. 2 *}
    With MyInvLines^[2] Do Begin
      TransRefNo  := MyInv^.OurRef;
      LineNo      := 2;
      NomCode     := 510110;
      Currency    := MyInv^.Currency;
      CoRate      := 1.0;
      VATRate     := 0.175;
      Qty         := 3.0;
      QtyMul      := 1.0;
      NetValue    := 30.00;
      Discount    := 0.0;
      VATCode     := 'S';
      VAT         := 0.0;
      CostPrice   := MyInv^.TotalCost;
      CustCode    := MyInv^.CustCode;
      LineDate    := MyInv^.TransDate;
      Desc        := 'Test Desc. for TSH';
      JobCode     := 'GK';
      AnalCode    := 'BRICKLAB';
      StockCode   := 'BRICKOVER';
      TSHCCurr    := 1;

    End; { With }

    {* calculate Total Net Value *}
    With MyInv^ Do
      InvNetVal := ((MyInvLines^[1].Qty * MyInvLines^[1].NetValue)+
                    (MyInvLines^[2].Qty * MyInvLines^[2].NetValue)) ;

    {* Use DLL function to store records *}
    ExStat:=Ex_StoreTrans(P,PL,SizeOf(MyInv^),SizeOf(MyInvLines^),0,0);

  end;

  {* display result of store operation *}
  ShowMessage ('Ex_StoreTrans Result: ' + IntToStr(ExStat));

  {* dispose allocated PC *}
  StrDispose (PC);

end;


(***************************************************************)
(* Test Mode Toggle                                            *)
(***************************************************************)

procedure TForm1.CheckBox1Click(Sender: TObject);
Var
  TestMode  :  SmallInt;
begin

  {$IFNDEF DLLU}
    Ex_TestMode(CheckBox1.Checked);
  {$ELSE}
    If (CheckBox1.Checked) then
      TestMode:=1
    else
      TestMode:=0;
    Ex_TestMode(TestMode);
  {$ENDIF}
end;

(***************************************************************)
(* Multi Location Stock                                        *)
(***************************************************************)

{* ===== From Memory Buffer to Screen Fields ========== *}

Procedure TForm1.DispMLocStk;
Var
  I : Integer;
Begin
  With MyMLocStk^ Do Begin
    MStkCode.Text     := lsStkCode;                       {* Stock Code *}
    MLocCode.Text     := lsLocCode;                       {* Location Code *}
    MSupplier.Text    := lsSupplier;                      {* Main Supplier *}
    MTempSupp.Text    := lsTempSupp;                      {* Temp. Supplier *}
    MQtyInStock.Text  := Format('%10.2f',[lsQtyInStock]); {* Qty In Stock *}
    MQtyOnOrder.Text  := Format('%10.2f',[lsQtyOnOrder]); {* Qty On Order *}
    MQtyAlloc.Text    := Format('%10.2f',[lsQtyAlloc]);   {* Allocated Qty *}
    MQtyPicked.Text   := Format('%10.2f',[lsQtyPicked]);  {* Picked Qty *}
    MQtyMin.Text      := Format('%10.2f',[lsQtyMin]);     {* Min. Qty *}
    MQtyMax.Text      := Format('%10.2f',[lsQtyMax]);     {* Max. Qty *}
    MQtyFreeze.Text   := Format('%10.2f',[lsQtyFreeze]);  {* Freeze Qty *}
    MRoQty.Text       := Format('%10.2f',[lsRoQty]);      {* Re-Order Qty *}
    MCC.Text          := lsCC;                            {* Cost Centre *}
    MDep.Text         := lsDep;                           {* Department *}
    MRoCC.Text        := lsRoCC;                          {* Re-Order Cost Centre *}
    MRoDep.Text       := lsRoDep;                         {* Re-Oder Department *}
    MCostPrice.Text   := Format('%10.2f',[lsCostPrice]);  {* Cost Price *}
    MSalePrice.Text   := Format ('%10.2f', [lsSaleBands[1].SalesPrice]); {* Sales Price *}

    {* Nominal Code for .. *}
    MDefNom1.Text     := IntToStr(lsDefNom[1]);       {* Sales *}
    MDefNom2.Text     := IntToStr(lsDefNom[2]);       {* Cost of Sales *}
    MDefNom3.Text     := IntToStr(lsDefNom[3]);       {* Profit & Loss *}
    MDefNom4.Text     := IntToStr(lsDefNom[4]);       {* Balance Sheet *}
    MDefNom5.Text     := IntToStr(lsDefNom[5]);       {* Work in Progress *}
  End; { With }
End;



{* ========== Find by Stock Code & Location Code ========== *}

procedure TForm1.FindMLocStk(Sender: TObject);
Var
  ExStat  :  Integer;
  PCStk,
  PCLoc   :  PChar;
  P       :  Pointer;
begin

  With MyMLocStk^ do
  begin
    lsStkCode:=MStkCode.Text;
    lsLocCode:=MLocCode.Text;
  end;

  {* allocate memory buffer for PC Stock & Location as String 255 *}
  PCStk := StrAlloc (255);
  PCLoc := StrAlloc (255);

  {* assign Stock Code & Location Code into PC *}
  StrPCopy(PCStk, MyMLocStk^.lsStkCode);
  StrPCopy(PCLoc, MyMLocStk^.lsLocCode);

  {* assign memory address *}
  P:=MyMLocStk;

  {* Find by using DLL function  *}
  If (Sender = ML_Find) Then
    ExStat:=Ex_GetStockLoc(P,SizeOf(MyMLocStk^),PCStk,PCLoc,LockStat);

  {* convert data to display *}
  DispMLocStk;

  {* dispose allocated buffer of PC *}
  StrDispose(PCStk);
  StrDispose(PCLoc);

end;

{* ===== Convert from Screen to Memory ===== *}

Function TForm1.Form2StockLoc : Boolean;
Var
  Code, I : Integer;
Begin
  Result := True;

  {* if not Edit Status, fill blank in Stock memory buffer *}
  If (Not FEdit) Then
    FillChar(MyMLocStk^, SizeOf (MyMLocStk^), #0);

  With MyMLocStk^ Do Begin
    lsStkCode      := MStkCode.Text;              {* Stock Code *}
    lsLocCode      := MLocCode.Text;              {* Location Code *}
    lsQtyMin       := StrToFloat(MQtyMin.Text);   {* Min. Qty *}
    lsQtyMax       := StrToFloat(MQtyMax.Text);   {* Max. Qty *}
    lsRoQty        := StrToFloat(MRoQty.Text);    {* Re-Order Qty *}
    lsCC           := MCC.Text;                   {* Cost Centre *}
    lsDep          := MDep.Text;                  {* Department *}
    lsRoCC         := MRoCC.Text;                 {* Re-Order Cost Centre *}
    lsRoDep        := MRoDep.Text;                {* Re-Order Department *}
    lsPCurrency    := 1;                          {* Cost Price Currency *}
    lsROCurrency   := 1;                          {* Re-Order Currency *}
    lsSUpplier     := MSupplier.Text;             {* Main Supplier *}
    lsTempSupp     := MTempSupp.Text;             {* Temp. Supplier *}
    lsCostPrice    := StrToFloat(MCostPrice.Text);{* Cost Price *}

    lsSaleBands[1].Currency := 1;                 {* Sales Currency *}
    lsSaleBands[1].SalesPrice := StrToFloat(MSalePrice.Text); {* Sales Price *}

    {* Nominal Codes for .. *}
    Try
      lsDefNom[1] := StrToInt(MDefNom1.Text);           {* Sales *}
    Except
      Result := False;
      If MDefNom1.CanFocus Then MDefNom1.SetFocus;
    End;
    Try
      lsDefNom[2] := StrToInt(MDefNom2.Text);           {* Cost of Sales *}
    Except
      Result := False;
      If MDefNom2.CanFocus Then MDefNom2.SetFocus;
    End;
    Try
      lsDefNom[3] := StrToInt(MDefNom3.Text);           {* Profit & Loss *}
    Except
      Result := False;
      If MDefNom3.CanFocus Then MDefNom3.SetFocus;
    End;
    Try
      lsDefNom[4] := StrToInt(MDefNom4.Text);           {* Balance Sheet *}
    Except
      Result := False;
      If MDefNom4.CanFocus Then MDefNom4.SetFocus;
    End;
    Try
      lsDefNom[5] := StrToInt(MDefNom5.Text);           {* Work In Progress *}
    Except
      Result := False;
      If MDefNom5.CanFocus Then MDefNom5.SetFocus;
    End;


    {* Sales Price Currencies *}
    For I := Low (lsSaleBands) To High (lsSaleBands) Do lsSaleBands[I].Currency := 1;

  End; { With }
End;


{* ===== Add/Edit Multi Location Stock ===== *}

procedure TForm1.AddMLocStk(Sender: TObject);
Var
  ExStat, I : Integer;
  P         : Pointer;
begin

  {* Add Button is chosen *}
  If (ML_Add.Caption = '&Add') Then Begin
    {* change Add & Edit as Save & Cancel *}
    ML_Add.Caption := '&Save';
    ML_Edit.Caption := '&Cancel';
    {* Edit Status is False *}
    FEdit := False;

    {* fill blank in Stock memory buffer *}
    FillChar (MyMLocStk^, SizeOf (MyMLocStk^), #0);
    {* convert stock data from memory to screen fields *}
    DispMLocStk;

    If MStkCode.CanFocus Then MStkCode.SetFocus;
  End { If }
  Else
  {* Save Button is chosen *}
  Begin
    {* convert stock data from screen fields to memory *}
    If (Form2StockLoc) then
    Begin
      {* assign stock memory address *}
      P:=MyMLocStk;

      {* use DLL function to save Record *}
      If FEdit Then
        {* if Save from Edit *}
        ExStat:=Ex_StoreStockLoc (P, SizeOf (MyMLocStk^), B_Update)
      Else
        {* if Save from Add *}
        ExStat:=Ex_StoreStockLoc (P, SizeOf (MyMLocStk^), B_Insert);

      If (ExStat=0) then
      Begin {* Record is saved successfully *}
        {* change Save & Cancel Buttons as Add & Edit *}
        ML_Add.Caption := '&Add';
        ML_Edit.Caption := '&Edit';
      End
      Else
        ShowMessage ('Ex_StoreStockMLoc Error Code : ' + IntToStr(ExStat));

    End { If }
    Else
      ShowMessage ('Validation Error');
  End; { Else }

  {* change Enable Status for Find Button *}
  ML_Find.Enabled := (ML_Add.Caption = '&Add');

end;

{* ===== Edit Multi Location Stock ===== *}

procedure TForm1.EditMLocStk(Sender: TObject);
begin
  {* Cancel Button is chosen *}
  If (ML_Edit.Caption = '&Cancel') Then
  Begin
    {* fill blank in memory buffer *}
    FillChar (MyMLocStk^, SizeOf (MyMLocStk^), #0);
    {* assign back Tmp.Stock code into Screen Field *}
    MStkCode.Text := TmpKey;
    {* Find stock record with assigned stock code *}
    FindMLocStk(ML_Find);
    {* change Save & Cancel Buttons as Add & Edit *}
    ML_Add.Caption := '&Add';
    ML_Edit.Caption := '&Edit';
  End { If }
  Else
  {* Edit Button is chosen *}
  Begin
    {* change Add & Edit Buttons as Save & Cancel *}
    ML_Add.Caption := '&Save';
    ML_Edit.Caption := '&Cancel';
    {* Edit Status is True now *}
    FEdit := True;
    {* assign Stock code into Tmp field *}
    TmpKey := MStkCode.Text;
    {* wait at Stock Code field *}
    If MStkCode.CanFocus then MStkCode.SetFocus;
  End; { Else }

  {* change enable status for Find Button *}
  ML_Find.Enabled := (ML_Add.Caption = '&Add');

end;

(***************************************************************)
(* Location Master                                             *)
(***************************************************************)


{* ===== From Memory Buffer to Screen Fields ========== *}

Procedure TForm1.DispLocation;
Var
  I : Integer;
Begin
  With MyMLocation^ Do Begin
    MloCode.Text      := loCode;                       {* Location Code *}
    MloName.Text      := loName;                       {* Location Name *}
    MloAddr1.Text     := loAddr[1];                    {* Address Line 1 to 5 *}
    MloAddr2.Text     := loAddr[2];
    MloAddr3.Text     := loAddr[3];
    MloAddr4.Text     := loAddr[4];
    MloAddr5.Text     := loAddr[5];
    MloTel.Text       := loTel;                        {* Telephone *}
    MloFax.Text       := loFax;                        {* Fax *}
    MloContact.Text   := loContact;                    {* Contact *}

    {* General Ledger Codes *}
    MloNominal1.Text  := IntToStr(loNominal[1]);       {* Sales *}
    MloNominal2.Text  := IntToStr(loNominal[2]);       {* Cost of Sales *}
    MloNominal3.Text  := IntToStr(loNominal[3]);       {* Profit & Loss *}
    MloNominal4.Text  := IntToStr(loNominal[4]);       {* Balance Sheet *}
    MloNominal5.Text  := IntToStr(loNominal[5]);       {* Work In Progress *}

  End; { With }
End;


{* ===== Find Location according to user's choice button ========== *}

procedure TForm1.BTrieveLoc(Sender: TObject);
Var
  ExStat  :  Integer;
  PCLoc   :  PChar;
  P       :  Pointer;
  SearchPath : SmallInt;

begin

  SearchPath:=0;

  With MyMLocation^ do
    loCode:=MloCode.Text;

  {* allocate memory buffer for PC Location as String 255 *}
  PCLoc := StrAlloc (255);

  {* assign Location Code into PC *}
  StrPCopy(PCLoc, MyMLocation^.loCode);

  {* assign memory address *}
  P:=MyMLocation;

  {* Find by using DLL function  *}
  If (Sender = lo_First) Then
    ExStat:=Ex_GetLocation(P,SizeOf(MyMLocation^),PCLoc,SearchPath,B_GetFirst,LockStat);
  If (Sender = lo_Previous) Then
    ExStat:=Ex_GetLocation(P,SizeOf(MyMLocation^),PCLoc,SearchPath,B_GetPrev,LockStat);
  If (Sender = lo_Find) Then
    ExStat:=Ex_GetLocation(P,SizeOf(MyMLocation^),PCLoc,SearchPath,B_GetEq,LockStat);
  If (Sender = lo_Next) Then
    ExStat:=Ex_GetLocation(P,SizeOf(MyMLocation^),PCLoc,SearchPath,B_GetNext,LockStat);
  If (Sender = lo_Last) Then
    ExStat:=Ex_GetLocation(P,SizeOf(MyMLocation^),PCLoc,SearchPath,B_GetLast,LockStat);

  {* convert data to display *}
  DispLocation;

  {* dispose allocated buffer of PC *}
  StrDispose(PCLoc);

end;

{* ===== Convert data from Screen fields to Memory ===== *}

Function TForm1.Form2Location : Boolean;
Var
  Code, I : Integer;
Begin
  Result := True;

  {* if not Edit Status, fill blank in Stock memory buffer *}
  If (Not FEdit) Then
    FillChar(MyMLocation^, SizeOf (MyMLocation^), #0);

  With MyMLocation^ Do Begin
    loCode         := MloCode.Text;              {* Stock Code *}
    loName         := MLoName.Text;              {* Location Code *}
    loAddr[1]      := MloAddr1.Text;             {* Address Line 1 to 5 *}
    loAddr[2]      := MloAddr2.Text;
    loAddr[3]      := MloAddr3.Text;
    loAddr[4]      := MloAddr4.Text;
    loAddr[5]      := MloAddr5.Text;
    loContact      := MloContact.Text;           {* Contact *}
    loCurrency     := 1;                         {* Curency *}
    loTel          := MloTel.Text;               {* Tel. *}
    loFax          := MloFax.Text;               {* Fax *}
    {* General Ledger Codes for .. *}
    loNominal[1]   := StrToInt(MloNominal1.Text);     {* Sales *}
    loNominal[2]   := StrToInt(MloNominal2.Text);     {* Cost of Sales *}
    loNominal[3]   := StrToInt(MloNominal3.Text);     {* Profit & Loss *}
    loNominal[4]   := StrToInt(MloNominal4.Text);     {* Balance Sheet *}
    loNominal[5]   := StrToInt(MloNominal5.Text);     {* WIP *}

  End; { With }
End;


{* ===== Add/Save Button is chosen ===== *}

procedure TForm1.AddLoc(Sender: TObject);
Var
  SearchPath,
  ExStat, I : Integer;
  P         : Pointer;

begin

  SearchPath:=0;
  {* Add Button is chosen *}
  If (lo_Add.Caption = '&Add') Then Begin
    {* change Add & Edit as Save & Cancel *}
    lo_Add.Caption := '&Save';
    lo_Edit.Caption := '&Cancel';
    {* Edit Status is False *}
    FEdit := False;

    {* fill blank in Location memory buffer *}
    FillChar (MyMLocation^, SizeOf (MyMLocation^), #0);
    {* convert data from memory to screen fields *}
    DispLocation;

    If MloCode.CanFocus Then MloCode.SetFocus;
  End { If }
  Else
  {* Save Button is chosen *}
  Begin
    {* convert data from screen fields to memory *}
    If (Form2Location) then
    Begin
      {* assign memory address *}
      P:=MyMLocation;

      {* use DLL function to save Record *}
      If FEdit Then
        {* if Save from Edit *}
        ExStat:=Ex_StoreLocation (P, SizeOf (MyMLocation^), SearchPath, B_Update)
      Else
        {* if Save from Add *}
        ExStat:=Ex_StoreLocation (P, SizeOf (MyMLocation^), SearchPath, B_Insert);

      If (ExStat=0) then
      Begin {* Record is saved successfully *}
        {* change Save & Cancel Buttons as Add & Edit *}
        lo_Add.Caption := '&Add';
        lo_Edit.Caption := '&Edit';
      End
      Else
        ShowMessage ('Ex_StoreLocation Error Code : ' + IntToStr(ExStat));

    End { If }
    Else
      ShowMessage ('Validation Error !');
  End; { Else }

  {* change Enable Status for Find Button *}
  lo_First.Enabled := (lo_Add.Caption = '&Add');
  lo_Next.Enabled := (lo_Add.Caption = '&Add');
  lo_Previous.Enabled := (lo_Add.Caption = '&Add');
  lo_Find.Enabled := (lo_Add.Caption = '&Add');
  lo_Last.Enabled := (lo_Add.Caption = '&Add');

end;

{* ===== Edit/Cancel Button is chosen ===== *}

procedure TForm1.EditLoc(Sender: TObject);
begin
  {* Cancel Button is chosen *}
  If (lo_Edit.Caption = '&Cancel') Then
  Begin
    {* fill blank in memory buffer *}
    FillChar (MyMLocation^, SizeOf (MyMLocation^), #0);
    {* assign back Tmp.Location code into Screen Field *}
    MloCode.Text := TmpKey;
    {* Find record with assigned code *}
    BTrieveLoc(lo_Find);
    {* change Save & Cancel Buttons as Add & Edit *}
    lo_Add.Caption := '&Add';
    lo_Edit.Caption := '&Edit';
  End { If }
  Else
  {* Edit Button is chosen *}
  Begin
    {* change Add & Edit Buttons as Save & Cancel *}
    lo_Add.Caption := '&Save';
    lo_Edit.Caption := '&Cancel';
    {* Edit Status is True now *}
    FEdit := True;
    {* assign Location code into Tmp field *}
    TmpKey := MloCode.Text;
    {* wait at Location Code field *}
    If MloCode.CanFocus then MloCode.SetFocus;
  End; { Else }

  {* change enable status for Find Button *}
  lo_First.Enabled := (lo_Add.Caption = '&Add');
  lo_Previous.Enabled := (lo_Add.Caption = '&Add');
  lo_Next.Enabled := (lo_Add.Caption = '&Add');
  lo_Find.Enabled := (lo_Add.Caption = '&Add');
  lo_Last.Enabled := (lo_Add.Caption = '&Add');

end;


procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
Var
  BStat  :  Integer;
begin

  {* dispose allocated memory buffers *}
  FreeMem(MyAcc,      SizeOf (MyAcc^));       {* Customer/Supplier *}
  FreeMem(AccBal,     SizeOf (MyAcc^));       {* Account Balance *}
  FreeMem(MyInv,      SizeOf (MyInv^));       {* Transaction Header *}
  FreeMem(MyStk,      SizeOf (MyStk^));       {* Stock *}
  FreeMem(MyId,       SizeOf (MyId^));        {* Transaction Lines *}
  FreeMem(MyInvLines, SizeOf (MyInvLines^));  {* Transaction Lines *}
  FreeMem(MyGLAcc,    SizeOf (MyGLAcc^));     {* General Ledger Account *}
  FreeMem(MyBOMLines, SizeOf (MyBOMLines^));  {* Bill of Material *}
  FreeMem(MySRLines,  SizeOf (MySRLines^));   {* Serial Numbers *}
  FreeMem(MyJob,      SizeOf (MyJob^));       {* Job *}
  FreeMem(MyMLocStk,  SizeOf (MyMLocStk^));   {* Multi Location Stock *}
  FreeMem(MyMLocation, SizeOf (MyMLocation^));  {* Multi Location Stock *}
  FreeMem(MyMatch,     SizeOf (MyMatch^));
  FreeMem(MyNote,      SizeOf (MyNote^));
  FreeMem(MyCCDep,     SizeOf (MyCCDep^));
  FreeMem(MyPrice,     SizeOf (MyPrice^));
  FreeMem(MyVAT,       SizeOf(MyVAT^));

  {* close DLL functions *}
  BStat:=Ex_CLoseDLL;

  If (BStat<>0) then
    ShowMessage('Ex_CloseDLL Error Code : '+IntToStr(BStat));

end;

(*
procedure TForm1.Button6Click(Sender: TObject);
Var
  ExStat  :  Integer;
  PCLoc   :  PChar;
  P       :  Pointer;
  SearchPath : SmallInt;
begin
  SearchPath:=0;
  With MyMatch^ do
    DebitRef:='SIN000066';
  PCLoc := StrAlloc (255);
  StrPCopy(PCLoc, MyMatch^.DebitRef);
  P:=MyMatch;
  ExStat:=Ex_GetMatch(P,SizeOf(MyMatch^),PCLoc,SearchPath,B_GetEq,False);
  StrDispose(PCLoc);
end;
*)

(*
procedure TForm1.Button6Click(Sender: TObject);

Var
  ExStat  :  Integer;
  PC      :  PChar;
  P       :  Pointer;
  i       :  Integer;

begin

  PC := StrAlloc (255);
  StrPCopy(PC, 'BOM-1');

  P:=MyBOMLines;

  FillChar(MyBOMLines^,SizeOf(MyBomLines^),#0);

  MyBOMLines^[1].StockCode:='BOM-STK1';
  MyBOMLines^[2].StockCode:='BOM-STK2';
  MyBOMLines^[3].StockCode:='BOM-STK3';
  MyBOMLines^[4].StockCode:='BOM-STK4';
  MyBOMLines^[5].StockCode:='BOM-STK5';

  For i:=1 to 5 do
  begin
    MyBOMLines^[i].QtyUsed:=2;
    MyBOMLines^[i].QtyCost:=10.30;
  end;

  ExStat:=Ex_StoreStockBOM(P,SizeOf(MyBOMLines^),PC);

  If (ExStat<>0) then
    ShowMessage('Store BOM Error :' +IntToStr(ExStat))
  else
    ShowMessage('Store BOM OK!!');

  StrDispose (PC);
end;
*)



procedure TForm1.B_StkPriceClick(Sender: TObject);
{* Testing for Get Stock Price by Account *}
Var
  ExStat  :  Double;
  P       :  Pointer;

begin
  With MyPrice^ Do
  begin
    StockCode:='MRP';
    CustCode:=MyAcc^.CustCode;
    Currency:=1;
    Qty:=12;
  end;
  P:=MyPrice;
  ExStat:=Ex_CalcStockPrice(P,SizeOf(MyPrice^));

  If (ExStat<>0) then
    ShowMessage('Get Price Error :' +FloatToStr(ExStat))
  else
  begin
    With MyPrice^ do
    begin
      ShowMessage('Stock Code : ' + StockCode + #10#13+
                  'Customer   : ' + CustCode  + #10#13+
                  'Price      : ' + FloatToStrF(Price,ffNumber,15,3) + #10#13+
                  'Disc Amount: ' + FloatToStrF(DiscVal,ffNumber,15,2) + #10#13+
                  'Disc Char  : ' + DiscChar);
    end;
  end;

end;

(* Testing for Ex_GetVATRate ....
procedure TForm1.Button7Click(Sender: TObject);
var
  SResult  :  Smallint;
  P        :  Pointer;

begin
  P:=MyVAT;
  MyVAT^.VATCode:='S';

  SResult:=Ex_GetVATRate(P,SizeOf(MyVAT^));

  With MyVAT^ do
   ShowMessage(VatCode+' '+FloatToStrF(VATRAte,ffFixed,15,4));

end;
*)

{* Testing for Each BOM Line Import *}
procedure TForm1.Button7Click(Sender: TObject);

Var
  EachBOM  :  ^TBatchBOMImportRec;
  PStat    :  Integer;

begin
  GetMem(EachBOM, SizeOf(EachBOM^));
  FillChar(EachBOM^,SizeOf(EachBOM^),#0);
  With EachBOM^ do
  begin
    PStockCode:='1';
    MStockCode:='22';
    QtyUsed:=1;
    DeleteStat:=False;

    PStat:=Ex_StoreEachBOMLine(EachBOM,SizeOf(EachBOM^),B_Insert);

    ShowMessage('PStat  = '+IntToStr(PStat));

  end; {with..}

  FreeMem(EachBOM, SizeOf(EachBOM^));

end; {proc..}


procedure TForm1.Label16Click(Sender: TObject);
Var
  TransRef, StockCode  : PChar;
  Res     : SmallInt;
begin
  TransRef := StrAlloc (255);
  StrPCopy (TransRef, 'PDN000129');

  StockCode := StrAlloc (255);
  StrPCopy (StockCode, 'CAS/DESK/SLIM');

  Res := EX_UPDATEUPLIFT (TransRef, 1, StockCode, 45);

  ShowMessage ('EX_UPDATEUPLIFT: ' + IntToStr(Res));

  StrDispose (TransRef);
end;

procedure TForm1.Button8Click(Sender: TObject);
Var
  TSr  :  ^TBatchSerialRec;
  Mode,
  Stat :  SmallInt;

  {TpS   :  TBatchSerialRec;}
begin

  GetMem(TSr,SizeOf(TSr^));
  FillChar(TSr^,SizeOf(TSr^),#0);
  FillChar(TpS,SizeOf(TpS),#0);
  Stat:=999;
  {
  Stat:=Ex_GetSerialBatch(TSr,SizeOf(TSr^),B_GetGEq);

  If (Stat<>0) or (Stat<>999) then
    ShowMessage(Ex_GetLastErrorDesc);
  }
  With TSr^ do
  begin
    If (S_field1.Text<>'') then
    begin
      SerialNo:=S_Field1.Text;
      Stat:=Ex_GetSerialBatch(TSr,SizeOf(TSr^),B_GetEq);
      TpS:=TSr^;

    end
    else
      If (S_field2.Text<>'0') and (S_field2.Text<>'') then
      begin
        BatchNo:=S_Field2.Text;
        Stat:=Ex_GetSerialBatch(TSr,SizeOf(TSr^),B_GetGEq);
        TpS:=TSr^;
      end
      else
        If (ByStockCode.Text<>'') then
        begin
          Stockcode:=ByStockCode.Text;
          Stat:=Ex_GetSerialBatch(TSr,SizeOf(TSr^),B_GetGEq);
          TpS:=TSr^;
          Mode:=3;
        end;

    If (Stat=0) then
    begin
      If (Mode<>3) then
        Showmessage('Serial = '+SerialNo+#13#10+
                    'Batch = '+BatchNo+#13#10+
                    'Stock = '+StockCode+#13#10+
                    'In Doc = '+InDoc+#13#10+
                    'Out Doc = '+OutDoc)
      else
      begin
        While (Trim(ByStockCode.Text)=Trim(StockCode)) and (Stat=0) do
        begin
          Showmessage('Serial = '+SerialNo+#13#10+
                    'Batch = '+BatchNo+#13#10+
                    'Stock = '+StockCode+#13#10+
                    'In Doc = '+InDoc+#13#10+
                    'Out Doc = '+OutDoc);
          FillChar(TSr^,SizeOf(TSr^),#0);
          Stockcode:=ByStockCode.Text;
          Stat:=Ex_GetSerialBatch(TSr,SizeOf(TSr^),B_GetNext);
          If Stat<>0 then
            ShowMessage('Status = '+IntToStr(Stat));

        end;
      end;
    end
    else
      If (Stat=999) then
        ShowMessage('Which index? ')
      else
        ShowMessage('Status = '+IntToStr(Stat));

  end; {with..}

  FreeMem(TSr,SizeOf(TSr^));

end; {proc..}

procedure TForm1.Button9Click(Sender: TObject);

Var
  TSr  :  ^TBatchSerialRec;
  Stat :  SmallInt;
begin
  GetMem(TSr,SizeOf(TSr^));
  FillChar(TSr^,SizeOf(TSr^),#0);

  TSr^:=TpS;

  With TSr^ do
  begin
    SerialNo:='SR57';
    BatchNo:='BSSM3';
    BuyQty:=5;

    InDoc:='PIN000005';
    DateIn:='19980909';

    SerCost:=10;
    CurCost:=1;
    CurSell:=1;
    BuyABSLine:=1;

    {InMLoc:='LC1';}
    CORate:=1;
    DailyRate:=1;
    StockCode:='SPROD4';

    Stat:=Ex_StoreSerialBatch(TSr,SizeOf(TSr^),B_Insert);

    If (Stat=0) then
      Showmessage('Save Status  OK!')
    else
      Showmessage('Save Status  = '+IntToStr(Stat));
  end; {with..}

  FreeMem(TSr,SizeOf(TSr^));

end;

procedure TForm1.Button10Click(Sender: TObject);
{* For Use Serial No *}
Var
  TSr  :  ^TBatchSerialRec;
  Stat :  SmallInt;
begin
  GetMem(TSr,SizeOf(TSr^));
  FillChar(TSr^,SizeOf(TSr^),#0);

  {TSr^:=TpS;}

  With TSr^ do
  begin
    SerialNo:='203';
    {BatchNO:='BSSM2';}
    QtyUsed:=1;

    OutDoc:='SOR000397';
    SoldABSLine:=1;
    DateOut:='20000729';
    CurSell:=1;
    CORate:=1;
    DailyRate:=1;

    StockCode:='STK2';

    Stat:=Ex_UseSerialBatch(TSr,SizeOf(TSr^),B_Update);

    If (Stat=0) then
      Showmessage('Save Status  OK!')
    else
      Showmessage('Save Status  = '+IntToStr(Stat));
  end; {with..}

  FreeMem(TSr,SizeOf(TSr^));

end;




{* Employee Record *}
procedure TForm1.Button6Click(Sender: TObject);
Var
  MyEmp  :  ^TBatchEmplRec;
  PC     :  PChar;
  ExStat :  SmallInt;
  BCom   :  Integer;

begin
  GetMem(MyEmp,SizeOf(MyEmp^));
  FillChar(MyEmp^,SizeOf(MyEmp^),#0);

  PC:=StrAlloc(255);

  StrPCopy(PC,'empl13');

  ExStat:=0;
  BCom:=B_GetGEq;

  While (ExStat=0) do
  begin

    ExStat:=Ex_GetJobEmployee(MyEmp,SizeOf(MyEmp^),PC,0,BCom,LockStat);
    If (ExStat<>0) then
      ShowMessage('Error = '+IntToStr(ExStat))
    else
      With MyEmp^ do
        ShowMessage('Code      : '+EmpCode+#13#10+
                    'Name      : '+EmpName+#13#10+
                    'Supplier  : '+Supplier+#13#10+
                    'EmpType   : '+EmpType);

    BCom:=B_GetNext;

  end; {while..}

  FreeMem(MyEmp,SizeOf(MyEmp^));
  StrDispose(PC);

end; {proc..}

procedure TForm1.Button12Click(Sender: TObject);
Var
  MyJAnal:  ^TBatchJobAnalRec;
  PC     :  PChar;
  ExStat :  SmallInt;
  BCom   :  Integer;

begin
  GetMem(MyJAnal,SizeOf(MyJAnal^));
  FillChar(MyJAnal^,SizeOf(MyJAnal^),#0);

  PC:=StrAlloc(255);

  StrPCopy(PC,'');

  ExStat:=0;
  BCom:=B_GetFirst;

  While (ExStat=0) do
  begin

    ExStat:=Ex_GetJobAnalysis(MyJAnal,SizeOf(MyJAnal^),PC,0,BCom,LockStat);
    If (ExStat<>0) then
      ShowMessage('Error = '+IntToStr(ExStat))
    else
      With MyJAnal^ do
        ShowMessage('Code      : '+JAnalCode+#13#10+
                    'Name      : '+JAnalDesc+#13#10+
                    'Type      : '+JAnalType+#13#10+
                    'Category  : '+JAnalCatry+#13#10+
                    'WIP Nom   : '+IntToStr(WIPNomCode)+#13#10+
                    'P&L Nom   : '+IntToStr(PLNomCode)+#13#10+
                    'Line Type : '+LineType);

    BCom:=B_GetNext;

  end; {while..}

  FreeMem(MyJAnal,SizeOf(MyJAnal^));
  StrDispose(PC);

end; {proc..}


procedure TForm1.Button13Click(Sender: TObject);
Var
  MyJRate:  ^TBatchJobRateRec;
  PC     :  PChar;
  ExStat :  SmallInt;
  BCom   :  Integer;

begin
  GetMem(MyJRate,SizeOf(MyJRate^));
  FillChar(MyJRate^,SizeOf(MyJRate^),#0);

  PC:=StrAlloc(255);

  StrPCopy(PC,'');

  MyJRate^.JRateCode:='';
  MyJRate^.JEmpCode:='PAUL';
  MyJRate^.CostCurr:=1;


  ExStat:=0;
  BCom:=B_GetGEq;

  While (ExStat=0) do
  begin

    ExStat:=Ex_GetJobTimeRate(MyJRate,SizeOf(MyJRate^),0,BCom,LockStat);
    If (ExStat<>0) then
      ShowMessage('Error = '+IntToStr(ExStat))
    else
      With MyJRate^ do
        ShowMessage('Rate Code : '+JRateCode+#13#10+
                    'Desc      : '+JRateDesc+#13#10+
                    'Employee  : '+JEmpCode+#13#10+
                    'Analysis  : '+JAnalCode+#13#10+
                    'Cost      : '+FloatToStrF(Cost,fffixed,15,2)+#13#10+
                    'Charge    : '+FloatToStrF(ChargeRate,fffixed,15,2)+#13#10+
                    'PayRoll   : '+IntToStr(PayrollCode));

    BCom:=B_GetNext;

  end; {while..}

  FreeMem(MyJRate,SizeOf(MyJRate^));
  StrDispose(PC);

end; {proc..}


{* Store Discount *}



procedure TForm1.B_SizeClick(Sender: TObject);
Var
  MyDisc  :  ^TBatchDiscRec;
  ExStat  :  Integer;

begin
{$IFDEF WIN32}
  GetMem(MyDisc,SizeOf(MyDisc^));
  FillChar(MyDisc^,SizeOf(MyDisc^),#0);

  With MyDisc^ do
  begin
    CustCode:='ABAC01';
    StockCode:='AND2119';
    DiscType:='M';
    SalesBand:='A';
    SPCurrency:=1;
    SPrice:=32.20;
    DiscPer:=12.5;
    DiscAmt:=0;
    DiscMar:=22.50;
    QtyFr:=1;
    QtyTo:=10;
    QtyBreak:=False;
  end; {with..}

  ExStat:=Ex_StoreDiscMatrix(MyDisc,SizeOf(MyDisc^),B_Insert);

  ShowMessage('Store Result = '+IntToStr(ExStat));
  FreeMem(MyDisc,SizeOf(MyDisc^));
{$ENDIF}

end; {proc..}



procedure TForm1.radNomCodeClick(Sender: TObject);
begin
  { Index has changed - restore position }
  If radDescription.Checked Then
    GL_Code.Text := GL_Desc.Text;
  NomBtrieve(Find);
end;


procedure TForm1.GetAltStk(Sender: TObject);
Var
  MySKAlt  :  ^TBatchSKAltRec;
  Stat     :  Integer;

  PC       :  PChar;

begin
  GetMem(MySKAlt,SizeOf(MySKAlt^));
  FillChar(MySKAlt^,SizeOf(MySKAlt^),#0);

  PC := StrAlloc(255);
  StrPCopy(PC,St_Code.Text);

  MySKAlt^.AltCode:='';

  Stat:=Ex_GetSTKALT(MySKAlt,SizeOf(MySKAlt^),PC,1,B_GetGEq,LockStat);
  If (Stat=0) then
  With MySKAlt^ do
  begin
    ShowMessage('Code = '+AltCode+#13#10+
                'Desc = '+AltDesc+#13#10+
                'StockCode = '+StockCode);
  end
  else
    ShowMessage('Error Code = '+IntToStr(Stat));


  FreeMem(MySKAlt,SizeOf(MySKAlt^));

  StrDispose(PC);

end;

{* Store Stock Alternative codes *}
procedure TForm1.StoreAltCodes(Sender: TObject);
Var
  MySKAlt  :  ^TBatchSKAltRec;
  Stat     :  Integer;

  PC       :  PChar;

begin
  GetMem(MySKAlt,SizeOf(MySKAlt^));
  FillChar(MySKAlt^,SizeOf(MySKAlt^),#0);

  PC := StrAlloc(255);

  With MySKAlt^ do
  begin
    StockCode :='P1';
    AltCode   :='AP7';
    AltDesc   :='ALternative Code 7 of P2';
    Suppcode  :='SUPP03';
    ROCurr    :=1;
    ROPrice   :=10.78;
    UseROPrice:=True;

    Stat:=Ex_StoreStkAlt(MySKAlt,SizeOf(MySKAlt^),0,B_Insert);
    If (Stat=0) then
      ShowMessage('OK! ')
    else
      ShowMessage('Error = '+IntToStr(Stat));

  end; {with..}

  FreeMem(MySKAlt,SizeOf(MySKAlt^));

  StrDispose(PC);

end; {proc..}


procedure TForm1.Button28Click(Sender: TObject);
Var
  PC1,
  PC2   :  PChar;
  Stat  :  SmallInt;

begin

  PC1:=StrAlloc(255);
  PC2:=StrAlloc(255);

  StrPCopy(PC1,'miss');
  StrPCopy(PC2,'jones');

  {$IFDEF WIN32}

    Stat:=(EX_CheckPassWord(PC1,PC2));
    If (Stat=0) then
      Showmessage('ok!')
    else
      Showmessage('Error Code = '+IntToStr(Stat));

  {$ENDIF}

  StrDispose(PC1);
  StrDispose(PC2);

end;

{$IFDEF WIN32}

{ Find Customer Qty Break Info.}
Procedure TForm1.FindCustQtyDisc(TmpCustCode :  ShortString);
Var
  MyCuQtyDisc  :  ^TBatchDiscRec;

  B_Command,
  FindStat     :  Integer;
  TCustDisc    :  TBatchDiscRec;
  RecFound     :  Boolean;

begin

  GetMem(MyCuQtydisc, SizeOf(MyCuQtyDisc^));

  FindStat:=0;
  B_Command:=B_GetGEq;
  RecFound:=True;

  While (RecFound) do
  With MyCuQtyDisc^ do
  begin
    FillChar(MyCuQtyDisc^,SizeOf(MyCuQtyDisc^),#0);
    CustCode:=TmpCustCode;
    QtyBreak:=True;

    FindStat:=Ex_GetDiscMatrix(MyCuQtyDisc,SizeOf(MyCuQtyDisc^),0,B_Command,LockStat);
    RecFound:=(FindStat=0) and (CustCode=TmpCustcode);
    If (RecFound) then
      DisplayDiscInfo(MyCuQtyDisc^);
    B_Command:=B_GetNext;
  end; {while..}

  FreeMem(MyCuQtydisc, SizeOf(MyCuQtyDisc^));

end; {proc..}

{$ENDIF}

{$IFDEF WIN32}

{* Display Discount Matrix Infomation *}
procedure TForm1.DisplayDiscInfo(TDiscRec  :  TBatchDiscRec);
Const
  YN  :  Array[False..True] of Char = ('N','Y');

begin

  With TDiscRec do
  begin
    ShowMessage('CustCode     = '+CustCode+#13#10+
                'StockCode    = '+StockCode+#13#10+
                'DiscType     = '+DiscType+#13#10+
                'SalesBand    = '+SalesBand+#13#10+
                'SPCurrency   = '+IntToStr(SPCurrency)+#13#10+
                'SPrice       = '+FloatToStr(SPrice)+#13#10+
                'DiscPer      = '+FloatToStr(DiscPer)+#13#10+
                'DiscAmt      = '+FloatToStr(DiscAmt)+#13#10+
                'DiscMar      = '+FloatToStrF(DiscMar,ffFixed,10,2)+#13#10+
                'QtyBreak     = '+YN[QtyBreak]+#13#10+
                'QtyFr        = '+FloatToStr(QtyFr)+#13#10+
                'QtyTo        = '+FloatToStr(QtyTo));

  end; {with..}

end; {proc..}

{$ENDIF}


{$IFDEF WIN32}
{* Get discount records by specified customer code *}
procedure TForm1.GetCustDiscount(TCustCode  :  ShortString);
Var

  MyDisc   :  ^TBatchDiscRec;

  BCommand,
  ExStat   :  Integer;

  FoundOK  :  Boolean;

  TRecAddr :  LongInt;

begin

  GetMem(MyDisc, SizeOf(MyDisc^));

  FoundOK:=True;
  ExStat:=0;
  {* To get the first discount record of specified customer *}
  BCommand:=B_GetGEq;

  While (FoundOK) do
  With MyDisc^ do
  begin

    FillChar(MyDisc^,SizeOf(MyDisc^),#0);

    {* Assign Customer Code as the key to find the record *}
    CustCode:=TCustCode;

    ExStat:=Ex_GetDiscMatrix(MyDisc,SizeOf(MyDisc^),0,BCommand,LockStat);

    {* If found, check the customer code against specified customer code *}
    If (ExStat=0) then
      FoundOK:=(CustCode=TCustCode);

    FoundOK:=(ExStat=0) and (FoundOK);

    If (FoundOK) then
    begin

      {* Display Discount Details *}

      DisplayDiscInfo(MyDisc^);

      {* If Discount Type is Qty-Break *}
      If (DiscType='Q') then
      begin
        {* Get the current discount record address *}
        ExStat:=Ex_GetRecordAddress(9,TRecAddr);
        If (ExStat<>0) then
          Showmessage('Get Record Address Error = '+IntToStr(ExStat));

        {* To find the customer's Qty Break discount records.
           In this procedure, Ex_GetDiscMatrix function is used to find the
           Customer Quantity Discount records.
           Therefore, Ex_GetRecordAddress and Ex_GetRecWithAddress functions are
           used in this case. *}

        FindCustQtyDisc(TCustCode);

        If (ExStat=0) then
        begin
          {* Get the main Qty-Break record with the record address *}
          ExStat:=Ex_GetRecWithAddress(9,0,TRecAddr);
          If (ExStat<>0) then
            Showmessage('Get Record With Address Error = '+IntToStr(ExStat));
        end; {if..}

      end; {if..}

    end; {if FoundOK..}

    {* To get the next customer discount record *}
    BCommand:=B_GetNext;

  end; {while..}

  FreeMem(MyDisc,SizeOf(MyDisc^));

end; {proc..}

{$ENDIF}


{$IFDEF WIN32}

{* From Stock - EX_GetDiscount*}
procedure TForm1.GetStkDisc(TStkCode  :  ShortString);
Var

  MyDisc  :  ^TBatchDiscRec;

  BCommand,
  ExStat  :  Integer;

  FoundOK :  Boolean;

begin

  GetMem(MyDisc,SizeOf(MyDisc^));

  FoundOK:=True;

  ExStat:=0;
  BCommand:=B_GetGEq;

  While (ExStat=0) and (FoundOK) do
  With MyDisc^ do
  begin

    FillChar(MyDisc^,SizeOf(MyDisc^),#0);

    StockCode:=TStkCode;

    ExStat:=Ex_GetDiscMatrix(MyDisc,SizeOf(MyDisc^),0,BCommand,LockStat);
    BCommand:=B_GetNext;

    If (ExStat=0) then
      FoundOK:=(StockCode=TStkCode);

    FoundOK:=(ExStat=0) and (FoundOK);

    If (FoundOK) then
    begin
      DisplayDiscInfo(MyDisc^);  { Display Discount Details }

    end; {if FoundOK..}

  end; {while..}

end; {proc..}

{$ENDIF}

procedure TForm1.B_GetDiscClick(Sender: TObject);
begin

  {$IFDEF WIN32}
    GetCustDiscount(Cu_Code.Text);
  {$ENDIF}


end;


{For Stock Discount }
procedure TForm1.B_StkDiscClick(Sender: TObject);
begin
  {$IFDEF WIN32}
    GetStkDisc(St_Code.Text);
  {$ENDIF}
end; {proc..}


{* Get CC/Dept *}
procedure TForm1.B_GetCCDeptClick(Sender: TObject);
Var
  ExStat  :  Integer;
  PC      :  PChar;
  P       :  Pointer;

begin

  PC := StrAlloc (255);
  StrPCopy(PC, '');
  CurrKPath:=0;
  P:=MyCCDep;
  ExStat:=Ex_GetCCDep(P,SizeOf(MyCCDep^),PC,CurrKPath,B_GetFirst,0,LockStat);

  While (ExStat=0) do
  With MyCCDep^ Do
  begin
    If (ExStat<>0) then
      ShowMessage('Get CCDep Error : ' +IntToStr(ExStat))
    else
      ShowMessage('Get CCDep OK : ' +CCDepCode+' / '+CCDepDesc);

    ExStat:=Ex_GetCCDep(P,SizeOf(MyCCDep^),PC,CurrKPath,B_GetNext,0,LockStat);

  end; {while..}

  StrDispose (PC);

end; {proc..}



procedure TForm1.B_GetNoteClick(Sender: TObject);
Var
  ExStat  :  Integer;
  PC      :  PChar;
  P       :  Pointer;
begin
  With MyNote^ Do
  begin
    NoteSort:='DOC';
    NoteType:='2';
    NoteCode:='SDN000001';
  end;
  PC := StrAlloc (255);
  StrPCopy(PC, MyNote^.NoteCode);
  CurrKPath:=0;
  P:=MyNote;
  ExStat:=Ex_GetNotes(P,SizeOf(MyNote^),PC,CurrKPath,B_GetGEq,LockStat);
  If (ExStat<>0) then
    ShowMessage('Get Notes Error :' +IntToStr(ExStat))
  else
  begin
    Repeat
      ShowMessage(MyNote^.NoteLine);
      ExStat:=Ex_GetNotes(P,SizeOf(MyNote^),PC,CurrKPath,B_GetNext,LockStat);
    Until (ExStat<>0);
  end;
  StrDispose (PC);
end;

procedure TForm1.B_AutoBankClick(Sender: TObject);
Var
  MyBank  :  ^TBatchAutoBankRec;
  ExStat  :  SmallInt;

begin
  GetMem(MyBank,SizeOf(MyBank^));
  FillChar(MyBank^,SizeOf(MyBank^),#0);
  With MyBank^ do
  begin
    BankRef:='By DLL Import';
    BankValue:=100;
    BankNom:=20010;
    BankCr:=1;
    EntryOpo:='';
    EntryDate:='19990831';
    AccountCode:='';
    SortCode:='';

    {$IFDEF WIN32}
    ExStat:=Ex_StoreAutoBank(MyBank,SizeOf(MyBank^),B_Insert);
    {$ENDIF}
    If (ExStat<>0) then
      ShowMessage('Error '+IntToStr(ExStat))
    else
      ShowMessage('OK! ');

  end; {with..}

  FreeMem(MyBank,SizeOf(MyBank^));
end;

procedure TForm1.B_MatchClick(Sender: TObject);
Var
  MyMatch  :  ^TBatchMatchRec;
  ExStat   :  Integer;

begin

  GetMem(MyMatch,SizeOf(MyMatch^));
  Fillchar(MyMatch^,SizeOf(MyMatch^),#0);
  With MyMatch^ do
  begin
    DebitRef:='SIN000271';
    CreditRef:='SRC000007';
    DebitCr:=1;
    CreditCr:=1;
    DebitVal:=117.50;
    CreditVal:=117.50;
    BaseVal:=117.50;

    ExStat:=Ex_StoreMatch(MyMatch,SizeOf(MyMatch^),0,B_Insert);
    ShowMessage(IntToStr(ExStat));

  end; {with }

  FreeMem(MyMatch,SizeOf(MyMatch^));

end;

procedure TForm1.B_RoundTestClick(Sender: TObject);
Var
  BOB  :  Array[1..52] of Double;
  ExStat,
  i    :  Integer;
  Tot  :  Double;

begin
  FillChar(BOB,SizeOf(BOB),0);

  BOB[1] := 30690.47;    { Sample Data }
  BOB[2] := 0.00;         { Group 1 }
  BOB[3] := 0.00;
  BOB[4] := 0.00;

  BOB[5] := 0.00;
  BOB[6] := 0.00;         { Group 2 }
  BOB[7] := -30690.47; {-52.05;}
  BOB[8] := 0.00;

  BOB[9] := 15872.31;
  BOB[10] := -10231.38;    { Group 3 }
  BOB[11] := -46641.41;
  BOB[12] := 0.00;

  BOB[13] := 0.00;
  BOB[14] := -54.99;       { Group 4 }
  BOB[15] := 0.00;
  BOB[16] := 0.00;

  BOB[17] := 0.00;
  BOB[18] := -25478.98;    { Group 5 }
  BOB[19] := 0.00;
  BOB[20] := 0.00;

  BOB[21] := 43.94;
  BOB[22] := 0.00;        { Group 6 }
  BOB[23] := 0.00;
  BOB[24] := 0.00;

  BOB[25] := 0.00;
  BOB[26] := -1611.27;     { Group 7 }
  BOB[27] := 0.00;
  BOB[28] := 0.00;

  BOB[29] := 9359.97;
  BOB[30] := 0.00;        { Group 8 }
  BOB[31] := 0.00;
  BOB[32] := 0.00;

  BOB[33] := 0.00;
  BOB[34] := -198.48;     { Group 9 }
  BOB[35] := 0.00;
  BOB[36] := 0.00;

  BOB[37] := 0.00;
  BOB[38] := 0.00;       { Group 10 }
  BOB[39] := -26.69;
  BOB[40] := 0.00;

  BOB[41] := 28164.07;
  BOB[42] := 0.00;       { Group 11 }
  BOB[43] := 0.00;
  BOB[44] := 0.00;

  BOB[45] := 0.00;
  BOB[46] := -42.18;     { Group 12 }
  BOB[47] := 0.00;
  BOB[48] := 0.00;

  BOB[49] := 206.67;
  BOB[50] := 0.00;     { Group 13 }
  BOB[51] := 0.00;
  BOB[52] := 30638.42; {-0.00;}

  FillChar(MyInv^,        SizeOf (MyInv^),       #0);
  FillChar(MyInvLines^,   SizeOf (MyInvLines^),  #0);

  With MyInv^ Do Begin
    OurRef      := 'Import';
    TransDate   := '19990831';                      {* Transaction Date *}
    Currency    := 6;                    {* Currency 1=Sterling *}
    AcYr        := 99;                        { Accounting Year *}
    AcPr        := 08;                   {* Accounting Period *}
    CoRate      := 1.0;                      {* Company Exchange Rate *}
    VATRate     := 1.0;                                   {* VAT Rate *}
    LineCount   := 52;                      {* No. of Trans. Lines *}
    LongYrRef   := 'RoundTest';
    TransDocHed:='NOM';
  End; { With }


  For i:=1 to 52 do
  With MyInvLines^[i] Do
  Begin
    Payment     := true;
    TransRefNo  := MyInv^.OurRef;     {* Exchequer Reference Number *}
    LineNo      := i;                {* Transaction Line Number *}
    NomCode     := 990;                   {* Nominal Code *}
    Currency    := 6;                             {* Currency *}
    CoRate      := 1.0;                     {* Company Exchange Rate *}
    VATRate     := 1.0;                                   {* VAT Rate *}
    Qty         := 1;                                   {* Quantity *}
    NetValue    := Ex_RoundUp(BOB[i],2);{ Unit Price *}

    If (i=52) then
      Tot:=Tot;

    Tot:=Ex_RoundUp((Tot+NetValue),2);

    MyInv^.InvNetVal := Tot;

    VATCode     := 'Z';                  {* VAT Code Z = Zero Rated *}
    Desc        := IntToStr(i);         {* Line Description *}
    CC          := 'AAA';
    Dep         := 'AAA';

  End; { With }

  ExStat := Ex_StoreTrans(MyInv,MyInvLines,SizeOf(MyInv^),SizeOf(MyInvLines^),0,0);

  if ExStat = 0 then
    showmessage('Transaction Imported!')
  else
    showmessage('Error '+IntToStr(ExStat));


end; {B_RoundTest..}

procedure TForm1.B_GetCurrClick(Sender: TObject);

Var
  MyCurr  :  ^TBatchCurrRec;
  ExStat  :  Integer;

begin
  {* Get Currency *}
  GetMem(MyCurr, SizeOf(MyCurr^));
  FillChar(MyCurr^,SizeOf(MyCurr^),#0);

  ExStat:=Ex_GetCurrency(MyCurr,SizeOf(MyCurr^),MyInv^.Currency);
  If (ExStat=0) then
  With MyCurr^ do
  begin
    ShowMessage('Name        : '+Name+#13#10+
                'ScreenSymb  : '+ScreenSymb+#13#10+
                'PrinterSymb : '+PrinterSymb+#13#10+
                'DailyRate   : '+FloatToStr(DailyRate)+#13#10+
                'CompanyRate : '+FloatToStr(CompanyRate)+#13#10+
                'TriEuro     : '+IntToStr(TriEuro)+#13#10+
                'TriRates    : '+FloattoStr(TriRates));
  end
  else
    Showmessage('Error = '+IntToStr(ExStat));


  FreeMem(MyCurr, SizeOf(MyCurr^));

end; {proc..}


procedure TForm1.B_CanUpdateClick(Sender: TObject);
Var
  PC     :  PChar;
  ExStat :  Integer;
begin
  PC:=StrAlloc(255);
  StrPCopy(PC,MyInv^.OurRef);
  ExStat:=Ex_TranCanBeUpdated(PC);
  If (ExStat<>0) then
    ShowMessage(MyInv^.OurRef+' - Status = '+IntToStr(ExStat));

  StrDispose(PC);
end; {proc..}


procedure TForm1.AssignIntoRecords;
Var
  i : Byte;
begin
  MyInvLines^[1].Stockcode:=Stk1.Text;
  MyInvLines^[2].Stockcode:=Stk2.Text;
  MyInvLines^[3].Stockcode:=Stk3.Text;
  MyInvLines^[4].Stockcode:=Stk4.Text;
  MyInvLines^[5].Stockcode:=Stk5.Text;

  MyInvLines^[1].Qty:=StrToFloat(Qty1.Text);
  MyInvLines^[2].Qty:=StrToFloat(Qty2.Text);
  MyInvLines^[3].Qty:=StrToFloat(Qty3.Text);
  MyInvLines^[4].Qty:=StrToFloat(Qty4.Text);
  MyInvLines^[5].Qty:=StrToFloat(Qty5.Text);

  MyInvLines^[1].NetValue:=StrToFloat(Net1.Text);
  MyInvLines^[2].NetValue:=StrToFloat(Net2.Text);
  MyInvLines^[3].NetValue:=StrToFloat(Net3.Text);
  MyInvLines^[4].NetValue:=StrToFloat(Net4.Text);
  MyInvLines^[5].NetValue:=StrToFloat(Net5.Text);

  MyInvLines^[1].QtyPick:=StrToFloat(PQty1.Text);
  MyInvLines^[2].QtyPick:=StrToFloat(PQty2.Text);
  MyInvLines^[3].QtyPick:=StrToFloat(PQty3.Text);
  MyInvLines^[4].QtyPick:=StrToFloat(PQty4.Text);
  MyInvLines^[5].QtyPick:=StrToFloat(PQty5.Text);

  MyInvLines^[1].QtyPWOff:=StrToFloat(WQty1.Text);
  MyInvLines^[2].QtyPWOff:=StrToFloat(WQty2.Text);
  MyInvLines^[3].QtyPWOff:=StrToFloat(WQty3.Text);
  MyInvLines^[4].QtyPWOff:=StrToFloat(WQty4.Text);
  MyInvLines^[5].QtyPWOff:=StrToFloat(WQty5.Text);


  For i:=1 to 5 do
  With MyInvLines^[i] do
  begin
    LineNo:=i;
    Qty:=Ex_RoundUp(Qty,2);
    NetValue:=Ex_RoundUp(NetValue,2);

    If (NomCode=0) then
      NomCode:=510100;
    If (VATCode='') then
      VATCode:='S';

  end; {for}

end;

procedure TForm1.TransUpdateClick(Sender: TObject);
Var
  i,j,
  BCommand,
  ExStat    :  Integer;

  NewLines  :  ^TBatchLinesRec;

  LineNet,
  LineVat   :  Double;


begin
  GetMem(NewLines,SizeOf(NewLines^));
  Fillchar(NewLines^,SizeOf(NewLines^),#0);

  With MyInv^ do
  begin
    DocUser3:='Add 4 new lines ';
    DocUser4:='Change 2.stock=4.stk & Delete 3,4,5';

    AssignIntoRecords;

    LineCount:=0;
    InvNetVal:=0;
    InvVAT:=0;
    FillChar(InvVATAnal,SizeOf(InvVATAnal),0);

    j:=0;

    For i:=1 to 5 do
    begin
      If (Trim(MyInvLines^[i].StockCode)<>'DELETE') then
      begin
        Inc(j);
        NewLines[j]:=MyInvLines[i];

        LineNet:=Ex_Roundup((MyInvLines^[i].Qty * MyInvLines^[i].NetValue),2);
        LineVAT:=Ex_RoundUp((LineNet*0.175),2);

        NewLines^[j].VAT:=LineVAT;
        InvNetVal:=InvNetVal +LineNet;
        InvVAT:=InvVat+LineVAT;
        InvVATAnal[0]:=InvVATAnal[0]+LineVAT;

        Inc(LineCount);

      end; {if..}

      MyInvLines^[i].RtnErrCode:=0;
    end; {for..}
    InvNetVal:=Ex_RoundUp(InvNetVal,2);


  end; {with..}

  If (Sender=B_NewTran) then
    BCommand:=B_Insert
  else
    BCommand:=B_Update;

  ExStat:=Ex_StoreTrans(MyInv,NewLines,SizeOf(MyInv^),SizeOf(MyInvLines^),0,BCommand);

    ShowMessage ('Result: ' + IntToStr(ExStat)+#13#10+
               Ex_GetLastErrorDesc);


  If (ExStat=0) then
    Button10Click(Button10);

  If (ExStat<>0) then
  begin
    For i:=1 to 5 do
    With MyInvLines^[i] do
    begin
      If (RtnErrCode<>0) then
        ShowMessage(IntTostr(LineNo)+'. '+StockCode+' '+IntToStr(RtnErrCode));
    end; {for..}
  end; {if..}

  FreeMem(NewLines,SizeOf(NewLines^));

end;



procedure TForm1.Button15Click(Sender: TObject);
Var
  TotRec  :  LongInt;
  i       :  Integer;

begin
  For i:=1 to 6 do
  begin
    TotRec:=Ex_FileSize(i);
    ShowMessage(IntToStr(TotRec));
  end;
  TotRec:=Ex_FileSize(11);
  ShowMessage(IntToStr(TotRec));
end;

procedure TForm1.B_THTotalClick(Sender: TObject);
Var
  PC   :  PChar;
  ExStat    :  SmallInt;
  TotValue  :  Double;

begin
  PC:=StrAlloc(255);
  StrPCopy(PC,Tr_OurRef.Text);
  TotValue:=0;
  (*
  {$IFNDEF DLL}
    ExStat:=Ex_CalculateTransTotal(PC,True,True,TotValue);
  {$ELSE}
    ExStat:=Ex_CalculateTransTotal(PC,True,False,TotValue);
  {$ENDIF}
  *)
  If ExStat=0 then
    ShowMessage(' Total Value = '+FloatToStr(TotValue));

  StrDispose(PC);

end;

procedure TForm1.B_GetNextTransClick(Sender: TObject);
Var
  PC  :  PChar;
  ExStat : SmallInt;

begin
  PC := StrAlloc (255);
  StrPCopy(PC,'SOR');

  {ExStat:=Ex_GetNextTransNo(PC,PC,True);}

  If (ExStat=0) then
    ShowMessage(PC)
  else
    ShowMessage(IntToStr(ExStat));


  StrDispose(PC);

end;

procedure TForm1.B_StoreNoteClick(Sender: TObject);
Var
  ExStat  :  Integer;
  P       :  Pointer;
begin
  P:=MyNote;
  FillChar(MyNote^,SizeOf(MyNote^),#0);
  With MyNote^ do
  begin
    NoteSort:='ACC';
    NoteType:='2';
    NoteCode:='001';
    NoteDate:='20001013';
    AlarmSet:='Y';
    User:='User';
    LineNo:=5;
    NoteFor:='MISS';
    AlarmDate:='20001016';
    NoteLine:='Import for User Testing- note for MISS';
  end;
  ExStat:=Ex_StoreNotes(P,SizeOf(MyNote^),0,B_Insert);
  If (ExStat<>0) then
    ShowMessage('Store Notes Error :' +IntToStr(ExStat))
  else
    ShowMessage('Store Notes OK!!');
end;

procedure TForm1.B_UpDueClick(Sender: TObject);
Var
  RStatus   :  Smallint;
  TStr1,
  TStr2     :  PChar;

begin
  TStr1:=StrAlloc(255);
  TStr2:=StrAlloc(255);

  StrPCopy(TStr1,Tr_OurRef.Text);
  StrPCopy(TStr2,'20001316');

  RStatus:=Ex_UpdateDueDate(TStr1,TStr2);
  If (RStatus<>0) then
    ShowMessage(Ex_GetLastErrorDesc);

  StrDispose(TStr1);
  StrDispose(TStr2);

end; {proc..}

end. {* End of Test Program *}

(*
procedure TForm1.Store_Serial;
var
  ExStat : integer;
  P : pointer;
begin
  FillChar(MySerial^, SizeOf (MySerial^), #0);

  with MySerial^ do
  begin
    SerialNo := Trim(Edit3.text); { a
    serial number }
    StockCode := Trim(Edit4.Text); { a valid
    stock code }
    InDoc := Trim(Edit1.Text); { an
    existing POR }
    BuyABSLine := strtoint(Trim(Edit11.Text)); { the ABSline no. from
    POR }
    InMLoc := 'AAA';
    { a valid location }
    DateOut := formatdatetime('yyyymmdd',date);
    CurCost := 1;
    DailyRate := 1;
    CoRate := 1.0;
    QtyUsed := 1;
    DoNotUpdateTL := False;
  end; { with }

  P := MySerial;

  ExStat := EX_STORESERIALBATCH(P,Sizeof(MySerial^),B_GetGEq);

  if ExStat <> 0 then
    ShowMessage ('Ex_StoreSerialBatch Status : ' + IntToStr(ExStat) +
    #13 +
    EX_ERRORDESCRIPTION(96,ExStat))
  else
  begin
    ListBox1.Items.Add(MySerial^.SerialNo);
    showmessage(MySerial^.SerialNo + ' Stored');
    QtyPick := QtyPick + 1; { increment picked qty. counter }
    Update_Picked_Qty; { open POR, update the picked qty and
    store }
    Panel4.Visible := False;
  end;

end;
*)






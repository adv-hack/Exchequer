unit Testdu;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs,

  {$IFNDEF DLLU}
    UseDLLU,
  {$ELSE}
    InitDLLU,DLL01U,
    DLLTH01U,DLLSK01U,
  {$ENDIF}

  {$IFDEF WIN32}
    ComCtrls,
  {$ENDIF}

    StdCtrls, ExtCtrls, TabNotBk;

{$I ExchDll.Inc}
{$I ExDLLBt.Inc}

type
  TForm1 = class(TForm)
    TabbedNotebook1: TTabbedNotebook;
    List_TransLines: TListBox;
    Label19: TLabel;
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
    GroupBox7: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Su_Code: TEdit;
    Su_Comp: TEdit;
    GroupBox8: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Su_Addr1: TEdit;
    Su_Addr2: TEdit;
    Su_Addr3: TEdit;
    Su_Addr4: TEdit;
    Su_Addr5: TEdit;
    Su_Cont: TEdit;
    Su_Phone: TEdit;
    Su_Fax: TEdit;
    GroupBox9: TGroupBox;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    GroupBox10: TGroupBox;
    Su_Add: TButton;
    Su_Close: TButton;
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
    GroupBox17: TGroupBox;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    GroupBox18: TGroupBox;
    CheckBox1: TCheckBox;
    GroupBox19: TGroupBox;
    Label53: TLabel;
    Cu_Balance: TEdit;
    First: TButton;
    Previous: TButton;
    Find: TButton;
    Next: TButton;
    Last: TButton;
    Nom_Add: TButton;
    Nom_Edit: TButton;
    GroupBox20: TGroupBox;
    GroupBox21: TGroupBox;
    Label55: TLabel;
    Label56: TLabel;
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
    Label62: TLabel;
    Label63: TLabel;
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
    Label75: TLabel;
    Label76: TLabel;
    GL_Code: TEdit;
    GL_Desc: TEdit;
    GL_NomType: TEdit;
    GL_Cat: TEdit;
    GL_CarryF: TEdit;
    Cu_OutStd: TEdit;
    Label77: TLabel;
    JobCode: TEdit;
    JobDesc: TEdit;
    JobFolio: TEdit;
    CustCode: TEdit;
    JobCat: TEdit;
    JobAltCode: TEdit;
    Contact: TEdit;
    JobMan: TEdit;
    QuotePrice: TEdit;
    CurrPrice: TEdit;
    StartDate: TEdit;
    EndDate: TEdit;
    RevEDate: TEdit;
    JobStat: TEdit;
    JBox1: TGroupBox;
    Label78: TLabel;
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
    JobType: TEdit;
    Label92: TLabel;
    J_First: TButton;
    J_Previous: TButton;
    J_Find: TButton;
    J_Next: TButton;
    J_Last: TButton;
    JBox2: TGroupBox;
    JBox3: TGroupBox;
    J_Add: TButton;
    J_Edit: TButton;

    Function GetAccBal(ACCode     :  String;
                       Pr,Yr      :  String;
                       SearchMode :  Byte)  :  Double;

    procedure Form2Cust;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure TabbedNotebook1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure But_AddTransClick(Sender: TObject);
    procedure StockBtrieve(Sender: TObject);
    procedure TransBtrieve(Sender: TObject);
    procedure CustBtrieve(Sender: TObject);
    procedure Cu_CloseClick(Sender: TObject);
    procedure Cu_AddClick(Sender: TObject);
    procedure SuppBtrieve(Sender: TObject);
    procedure Su_AddClick(Sender: TObject);
    procedure Su_CloseClick(Sender: TObject);
    procedure ST_CloseClick(Sender: TObject);
    procedure ST_AddClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure NomBTrieve(Sender: TObject);
    procedure Nom_Data;
    procedure Nom_AddClick(Sender: TObject);
    procedure Nom_EditClick(Sender: TObject);
    procedure BOMBTrieve(Sender: TObject);
    procedure B_CancelClick(Sender: TObject);
    procedure B_ToggleClick(Sender: TObject);
    procedure S_ByTranClick(Sender: TObject);
    procedure S_BySerailClick(Sender: TObject);
    procedure S_CancelClick(Sender: TObject);
    procedure SRBTrieve(Sender: TObject);
    procedure BTrieveJob(Sender: TObject);
  private
    { Private declarations }

    MyAcc, MySupp  :  ^TBatchCURec;
    AccBal         :  ^THistoryBalRec;
    MyInv          :  ^TBatchTHRec;
    MyStk          :  ^TBatchSKRec;
    MyInvLines     :  ^TBatchLinesRec;
    MyGLAcc        :  ^TBatchNomRec;
    MyBOMLines     :  ^TBatchBOMLinesRec;
    MySRLines      :  ^TBatchSRLinesRec;
    MyJob          :  ^TBatchJHRec;

    TransMode,
    StockMode      :  Boolean;

    CurrKPath      :  Integer;

    FCust, FSupp,
    FStock,FTrans,
    FEdit, FNom,
    FBOM,FSRNo
    FJob           : Boolean;

    TmpKey         : String;

    SrNoChk        : Boolean;

    Procedure DispCust;
    Procedure DispTrans;

    Procedure DispSupp;
    procedure Form2Supp;

    Procedure DispStock;
    Function  Form2Stock : Boolean;

    Procedure DispNom;
    Procedure DispBOM;
    Procedure DispSR;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{$I Version.Inc}

Function TForm1.GetAccBal(ACCode     :  String;
                          Pr,Yr      :  String;
                          SearchMode :  Byte)  :  Double;
const
  YN : Array[False..True] of String[3] = ('No','Yes');

Var
  P           :  Pointer;
  PC          :  PChar;
  {KeyPC:  Array[0..254] of Char;}
  BStat       :  Integer;
  OutStat     :  WordBool;

Begin
  With AccBal^ do
  Begin
    FillChar(AccBal^,Sizeof(AccBal^),0);

    Period:=Pr;
    Year:=Yr;
    Currency:=0;

    PC := StrAlloc (255);
    StrPCopy(PC,AcCode);

    P:=AccBal;

    BStat:=Ex_GetAccountBalance(P,Sizeof(AccBal^),PC,SearchMode);
    If (BStat<>0) then
      Panel4.Caption:='Bal Status : '+IntToStr(BStat);

    OutStat:=Ex_HasOutStanding(PC);
    Cu_OutStd.Text:=YN[OutStat];

    Result:=AccBal^.Value;

    StrDispose (PC);
  end; {With..}

end; {Func..}





procedure TForm1.FormCreate(Sender: TObject);

Var
  P,PL :  Pointer;

  PC   :  PChar;
  {KeyPC:  Array[0..254] of Char;}

  B_Stat
       :  Integer;


begin
  Caption := Caption + ' (' + BitVer + ')';

  PC := StrAlloc (255);
  StrPCopy(PC,'A');

  GetMem(MyAcc,      SizeOf (MyAcc^));
  GetMem(MySupp,     SizeOf (MyAcc^));
  GetMem(AccBal,     SizeOf (MyAcc^));
  GetMem(MyInv,      SizeOf (MyInv^));
  GetMem(MyStk,      SizeOf (MyStk^));
  GetMem(MyInvLines, SizeOf (MyInvLines^));
  GetMem(MyGLAcc,    SizeOf (MyGLAcc^));
  GetMem(MyBOMLines, SizeOf (MyBOMLines^));
  GetMem(MySRLines,  SizeOf (MySRLines^));
  GetMem(MyJob,      SizeOf (MyJob^));

  FillChar(MyAcc^,      SizeOf (MyAcc^),      #0);
  FillChar(MySupp^,     SizeOf (MySupp^),     #0);
  FillChar(AccBal^,     SizeOf (MyAcc^),      #0);
  FillChar(MyInv^,      SizeOf (MyInv^),      #0);
  FillChar(MyStk^,      SizeOf (MyStk^),      #0);
  FillChar(MyInvLines^, SizeOf (MyInvLines^), #0);
  FillChar(MyGLAcc^,    SizeOf (MyGLAcc^),    #0);
  FillChar(MyBOMLines^, SizeOf (MyBOMLines^), #0);
  FillChar(MySRLines^,  SizeOf (MySRLines^),  #0);
  FillChar(MyJob^,      SizeOf (MyJob^),      #0);

  B_Stat:=Ex_InitDLL;
  If (B_Stat <> 0) Then Begin
    {ShowMessage ('Init Status : '+IntToStr(B_Stat));}
    Panel4.Caption := 'Init Status : '+IntToStr(B_Stat);
  End; { If }

  { Version Information }
  Ver_Test.Caption := FullVer;
  Ver_Dll.Caption  := Ex_Version;

  { Record Sizes }
  Label37.Caption := IntToStr(SizeOf(TBatchCURec));
  Label38.Caption := IntToStr(SizeOf(TBatchTHRec));
  Label43.Caption := IntToStr(SizeOf(TBatchTLRec));
  Label44.Caption := IntToStr(SizeOf(TBatchLinesRec));
  Label47.Caption := IntToStr(SizeOf(TSaleBandsRec));
  Label48.Caption := IntToStr(SizeOf(TSaleBandAry));
  Label51.Caption := IntToStr(SizeOf(TBatchSKRec));
  Label52.Caption := IntToStr(SizeOf(THistoryBalRec));
  Label56.Caption := IntToStr(SizeOf(TBatchNomRec));
  Label63.Caption := IntToStr(SizeOf(TBatchBOMLinesRec));
  Label76.Caption := IntToStr(SizeOf(TBatchSRLinesRec));

  FCust  := True;
  FSupp  := True;
  FStock := True;
  FTrans := True;
  FNom   := True;
  FBOM   := True;
  FSRNo  := True;
  FJob   := True;

  TmpKey := TabbedNoteBook1.ActivePage;
  TabbedNoteBook1.ActivePage := 'Customer';
  If (TmpKey = TabbedNoteBook1.ActivePage) Then
    TabbedNotebook1Change(Self, 0, FCust);

  StrDispose (PC);
end;

procedure TForm1.FormDestroy(Sender: TObject);
Var
  BStat  :  Integer;

begin
  FreeMem(MyAcc,      SizeOf (MyAcc^));
  FreeMem(MySupp,     SizeOf (MySupp^));
  FreeMem(AccBal,     SizeOf (MyAcc^));
  FreeMem(MyInv,      SizeOf (MyInv^));
  FreeMem(MyStk,      SizeOf (MyStk^));
  FreeMem(MyInvLines, SizeOf (MyInvLines^));
  FreeMem(MyGLAcc,    SizeOf (MyGLAcc^));
  FreeMem(MyBOMLines, SizeOf (MyBOMLines^));
  FreeMem(MySRLines,  SizeOf (MySRLines^));
  FreeMem(MyJob,      SizeOf (MyJob^));

  BStat:=Ex_CLoseDLL;
end;


procedure TForm1.TabbedNotebook1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  If (NewTab = 0) Then Begin
    Panel4.Caption:='';
    If FCust Then Begin
      FCust := False;
      CustBtrieve(Button23);
    End; { If }
    DispCust;
  End; { If }
  If (NewTab = 1) Then Begin
    Panel4.Caption:='';
    If FStock Then Begin
      FStock := False;
      StockBtrieve(Button17);
    End; { If }
    DispStock;
  End; { If }
  If (NewTab = 2) Then Begin
    Panel4.Caption:='';
    If FSupp Then Begin
      FSupp := False;
      SuppBtrieve(Button6);
    End; { If }
    DispSupp;
  End; { If }
  If (NewTab = 3) Then Begin
    Panel4.Caption:='';
    If FTrans Then Begin
      FTrans := False;
      Tr_OurRef.Text := 'SIN';
      TransBtrieve(Button3);
    End; { If }
    DispTrans;
  End; { If }
  If (NewTab = 4) Then Begin
    Panel4.Caption:='';
    If FNom Then Begin
      FNom := False;
      NomBtrieve(First);
    End; { If }
    DispNom;
  End; { If }
  If (NewTab = 5) Then Begin
    Panel4.Caption:='';
    If FBOM Then Begin
      FBOM := False;
      If B_StockCode.CanFocus then B_StockCode.SetFocus;
    End; { If }
  End; { If }
  If (NewTab = 6) Then Begin
    Panel4.Caption:='';
    If FSRNo Then Begin
      FSRNo := False;
      If S_ByTran.CanFocus then S_ByTran.SetFocus;
    End; { If }
  End; { If }
end;

(***************************************************************)
(* Customer Routines                                           *)
(***************************************************************)
Procedure TForm1.DispCust;
Begin
  With MyAcc^ Do Begin
    Cu_Code.Text  := CustCode;
    Cu_Comp.Text  := Company;
    Cu_Cont.Text  := Contact;
    Cu_Addr1.Text := Addr[1];
    Cu_Addr2.Text := Addr[2];
    Cu_Addr3.Text := Addr[3];
    Cu_Addr4.Text := Addr[4];
    Cu_Addr5.Text := Addr[5];
    Cu_Phone.Text := Phone;
    Cu_Fax.Text   := Fax;

    Cu_Balance.Text := FloatToStr((Trunc(Round(GetACCBal(CustCode,'YTD','',0)*100))/100));
    (*
    {* Balance *}
    Edit9.Text:=FloatToStr(GetACCBal(CustCode,'YTD','',0));
    {* Sales This Period/Year *}
    Edit10.Text:=FloatToStr(GetACCBal(CustCode,'','',4));
    {* Sales YTD *}
    Edit11.Text:=FloatToStr(GetACCBal(CustCode,'YTD','',4));
    {* Sales LYTD *}
    Edit12.Text:=FloatToStr(GetACCBal(CustCode,'YTD','-1',4));
    *)
  End; { With }
End;

procedure TForm1.Form2Cust;
Begin
  FillChar (MyAcc^, SizeOf (MyAcc^), #0);
  With MyAcc^ Do Begin
    CustCode := Cu_Code.Text;
    CustSupp := 'C';
    Company  := Cu_Comp.Text;
    Contact  := Cu_Cont.Text;
    Addr[1]  := Cu_Addr1.Text;
    Addr[2]  := Cu_Addr2.Text;
    Addr[3]  := Cu_Addr3.Text;
    Addr[4]  := Cu_Addr4.Text;
    Addr[5]  := Cu_Addr5.Text;
    Phone    := Cu_Phone.Text;
    Fax      := Cu_Fax.Text;
    PayType  := 'C';
    VATCode  := 'S';
    Currency := 1;
  End; { With }
end;

procedure TForm1.CustBtrieve(Sender: TObject);
Var
  ExStat  :  Integer;
  PC      :  PChar;
  P,PL    :  Pointer;


begin
  With MyAcc^ Do
    CustCode:=Cu_Code.Text;

  PC := StrAlloc (255);
  StrPCopy(PC, MyAcc^.CustCode);
  CurrKPath:=0;

  P:=MyAcc;

  If (Sender = Button23) Then ExStat:=Ex_GetAccount(P,SizeOf(MyAcc^),PC,CurrKPath,B_GetFirst,1,False);
  If (Sender = Button24) Then ExStat:=Ex_GetAccount(P,SizeOf(MyAcc^),PC,CurrKPath,B_GetPrev,1,False);
  If (Sender = Button25) Then ExStat:=Ex_GetAccount(P,SizeOf(MyAcc^),PC,CurrKPath,B_GetGEq,1,False);
  If (Sender = Button26) Then ExStat:=Ex_GetAccount(P,SizeOf(MyAcc^),PC,CurrKPath,B_GetNext,1,False);
  If (Sender = Button27) Then ExStat:=Ex_GetAccount(P,SizeOf(MyAcc^),PC,CurrKPath,B_GetLast,1,False);

  DispCust;

  StrDispose (PC);
end;

procedure TForm1.Cu_AddClick(Sender: TObject);
Var
  ExStat, I : Integer;
  P         : Pointer;
begin
  If (Cu_Add.Caption = '&Add') Then Begin
    { Add a Customer }
    Cu_Add.Caption := '&Save';
    Cu_Close.Caption := '&Cancel';

    FEdit := False;
    TmpKey := Cu_Code.Text;
    FillChar (MyAcc^, SizeOf (MyAcc^), #0);
    DispCust;
    If Cu_Code.CanFocus Then Cu_Code.SetFocus;
  End { If }
  Else Begin
    { Save the Customer }
    Form2Cust;

    P:=MyAcc;
    If FEdit Then
      ExStat:=Ex_StoreAccount (P, SizeOf (MyAcc^), 0, B_Update)
    Else
      ExStat:=Ex_StoreAccount (P, SizeOf (MyAcc^), 0, B_Insert);

    Case ExStat Of
      0     : Begin { AOK }
                Cu_Add.Caption := '&Add';
                Cu_Close.Caption := '&Edit';
              End;
      5     : Begin { Btrieve Error 5: Duplicates }
                If CU_Code.CanFocus Then Cu_Code.SetFocus;
                ShowMessage ('A Customer with this code already exists');
              End;
    Else
      ShowMessage ('Error: ' + IntToStr(ExStat));
    End; { Case }
  End; { Else }

  Button23.Enabled := (Cu_Add.Caption = '&Add');
  Button24.Enabled := (Cu_Add.Caption = '&Add');
  Button25.Enabled := (Cu_Add.Caption = '&Add');
  Button26.Enabled := (Cu_Add.Caption = '&Add');
  Button27.Enabled := (Cu_Add.Caption = '&Add');
end;

procedure TForm1.Cu_CloseClick(Sender: TObject);
begin
  If (Cu_Close.Caption = '&Cancel') Then Begin
    { Cancel the add }
    FillChar (MyAcc^, SizeOf (MyAcc^), #0);
    Cu_Code.Text := TmpKey;
    CustBtrieve(Button25);

    Cu_Add.Caption := '&Add';
    Cu_Close.Caption := '&Edit';
  End { If }
  Else Begin
    { Edit the Customer }
    Cu_Add.Caption := '&Save';
    Cu_Close.Caption := '&Cancel';

    FEdit := True;
    TmpKey := Cu_Code.Text;
    If Cu_Code.CanFocus Then Cu_Code.SetFocus;
  End; { Else }

  Button23.Enabled := (Cu_Add.Caption = '&Add');
  Button24.Enabled := (Cu_Add.Caption = '&Add');
  Button25.Enabled := (Cu_Add.Caption = '&Add');
  Button26.Enabled := (Cu_Add.Caption = '&Add');
  Button27.Enabled := (Cu_Add.Caption = '&Add');
end;


(***************************************************************)
(* Stock Routines                                              *)
(***************************************************************)
Procedure TForm1.DispStock;
Var
  I : Integer;
Begin
  With MyStk^ Do Begin
    ST_Code.Text   := StockCode;
    ST_Descr1.Text := Desc[1];
    ST_Descr2.Text := Desc[2];
    ST_Alt.Text    := AltCode;
    St_Group.Text  := StockCat;
    St_Type.Text   := StockType;
    ST_Cost.Text   := Format ('%10.2f', [CostPrice]);
    ST_Sales.Text  := Format ('%10.2f', [SaleBands[1].SalesPrice]);
    ST_Supp.Text   := Supplier;

    GL_Sales.Text := IntToStr(NomCodes[1]);
    GL_COS.Text   := IntToStr(NomCodes[2]);
    GL_PL.Text    := IntToStr(NomCodes[3]);
    GL_BalSh.Text := IntToStr(NomCodes[4]);
    GL_Wip.Text   := IntToStr(NomCodes[5]);
  End; { With }
End;

Function TForm1.Form2Stock : Boolean;
Var
  Code, I : Integer;
Begin
  Result := True;

  If (Not FEdit) Then
    FillChar(MyStk^, SizeOf (MyStk^), #0);

  With MyStk^ Do Begin
    StockCode := ST_Code.Text + '                ';
    Desc[1]   := ST_Descr1.Text;
    Desc[2]   := ST_Descr2.Text;
    AltCode   := ST_Alt.Text;
    StockCat  := St_Group.Text + '                ';
    StockType := St_Type.Text[1];
    Supplier  := ST_Supp.Text;

    Val (ST_Cost.Text, CostPrice, Code);
    If (Code > 0) Then Begin
      Result := False;
      If ST_Cost.CanFocus Then ST_Cost.SetFocus;
    End; { If }

    SaleBands[1].Currency := 1;
    Val (ST_Sales.Text, SaleBands[1].SalesPrice, Code);
    If (Code > 0) Then Begin
      Result := False;
      If ST_Sales.CanFocus Then ST_Sales.SetFocus;
    End; { If }

    Try
      NomCodes[1] := StrToInt(GL_Sales.Text);
    Except
      Result := False;
      If GL_Sales.CanFocus Then GL_Sales.SetFocus;
    End;
    Try
      NomCodes[2] := StrToInt(GL_COS.Text);
    Except
      Result := False;
      If GL_COS.CanFocus Then GL_COS.SetFocus;
    End;
    Try
      NomCodes[3] := StrToInt(GL_PL.Text);
    Except
      Result := False;
      If GL_PL.CanFocus Then GL_PL.SetFocus;
    End;
    Try
      NomCodes[4] := StrToInt(GL_BalSh.Text);
    Except
      Result := False;
      If GL_BalSh.CanFocus Then GL_BalSh.SetFocus;
    End;
    Try
      NomCodes[5] := StrToInt(GL_Wip.Text);
    Except
      Result := False;
      If GL_Wip.CanFocus Then GL_Wip.SetFocus;
    End;

    For I := Low (SaleBands) To High (SaleBands) Do SaleBands[I].Currency := 1;
    VATCode      := 'S';
    PCurrency    := 1;
    ROCurrency   := 1;
    StkValType   := 'C';
    SellUnit     := 1;
    BuyUnit      := 1;
  End; { With }
End;

procedure TForm1.StockBtrieve(Sender: TObject);
Var
  ExStat  :  Integer;
  PC      :  PChar;
  P       :  Pointer;
begin
  With MyStk^ Do
    StockCode := St_Code.Text;

  PC := StrAlloc (255);
  StrPCopy(PC, MyStk^.StockCode);
  CurrKPath:=0;

  P:=MyStk;

  If (Sender = Button17) Then ExStat:=Ex_GetStock(P,SizeOf(MyStk^),PC,CurrKPath,B_GetFirst,False);
  If (Sender = Button18) Then ExStat:=Ex_GetStock(P,SizeOf(MyStk^),PC,CurrKPath,B_GetPrev,False);
  If (Sender = Button19) Then ExStat:=Ex_GetStock(P,SizeOf(MyStk^),PC,CurrKPath,B_GetGEq,False);
  If (Sender = Button20) Then ExStat:=Ex_GetStock(P,SizeOf(MyStk^),PC,CurrKPath,B_GetNext,False);
  If (Sender = Button21) Then ExStat:=Ex_GetStock(P,SizeOf(MyStk^),PC,CurrKPath,B_GetLast,False);

  DispStock;

  StrDispose (PC);
end;

procedure TForm1.ST_AddClick(Sender: TObject);
Var
  ExStat, I : Integer;
  P         : Pointer;
begin
  If (ST_Add.Caption = '&Add') Then Begin
    { Add a Customer }
    ST_Add.Caption := '&Save';
    ST_Close.Caption := '&Cancel';

    FEdit := False;
    TmpKey := St_Code.Text;
    FillChar (MyStk^, SizeOf (MyStk^), #0);
    DispStock;
    St_Group.Text := 'CABLES';
    St_Type.Text := 'P';
    If ST_Code.CanFocus Then ST_Code.SetFocus;
  End { If }
  Else Begin
    { Save the Customer }
    If Form2Stock Then Begin
      P:=MyStk;
      If FEdit Then
        ExStat:=Ex_StoreStock (P, SizeOf (MyStk^), 0, B_Update)
      Else
        ExStat:=Ex_StoreStock (P, SizeOf (MyStk^), 0, B_Insert);

      Case ExStat Of
        0     : Begin { AOK }
                  St_Add.Caption := '&Add';
                  St_Close.Caption := '&Edit';
                End;
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
      Else
        ShowMessage ('Error: ' + IntToStr(ExStat));
      End; { Case }
    End { If }
    Else
      ShowMessage ('Validation Error');
  End; { Else }

  St_Group.Enabled := (St_Add.Caption = '&Save');
  Button17.Enabled := (St_Add.Caption = '&Add');
  Button18.Enabled := (St_Add.Caption = '&Add');
  Button19.Enabled := (St_Add.Caption = '&Add');
  Button20.Enabled := (St_Add.Caption = '&Add');
  Button21.Enabled := (St_Add.Caption = '&Add');
end;

procedure TForm1.ST_CloseClick(Sender: TObject);
begin
  If (St_Close.Caption = '&Cancel') Then Begin
    { Cancel the add }
    FillChar (MyStk^, SizeOf (MyStk^), #0);
    St_Code.Text := TmpKey;
    StockBtrieve(Button19);

    St_Add.Caption := '&Add';
    St_Close.Caption := '&Edit';
  End { If }
  Else Begin
    { Edit the Customer }
    St_Add.Caption := '&Save';
    St_Close.Caption := '&Cancel';

    FEdit := True;
    TmpKey := St_Code.Text;
    St_Group.Enabled := False;
    If St_Code.CanFocus Then St_Code.SetFocus;
  End; { Else }

  St_Group.Enabled := (St_Add.Caption = '&Save') And (Not FEdit);
  Button17.Enabled := (St_Add.Caption = '&Add');
  Button18.Enabled := (St_Add.Caption = '&Add');
  Button19.Enabled := (St_Add.Caption = '&Add');
  Button20.Enabled := (St_Add.Caption = '&Add');
  Button21.Enabled := (St_Add.Caption = '&Add');
end;



(***************************************************************)
(* Transaction Routines                                        *)
(***************************************************************)
Procedure TForm1.DispTrans;
Var
  LineStr, Tmp : String[100];
  I            : Integer;
Begin
  With MyInv^ do Begin
    If True Or (TabbedNoteBook1.ActivePage = 'Transaction') Then Begin
      { Trans fields }
      Tr_Code.Text          := CustCode;
      Tr_OurRef.Text        := OurRef;
      Tr_TransDate.Text     := TransDate + ' (' + IntToStr(AcYr) + '/' + IntToStr(AcPr) + ')';
      Tr_DueDate.Text       := DueDate;
      Tr_Period.Text        := IntToStr(AcPr) + '/' + IntToStr(AcYr);
      Tr_YourRef.Text       := YourRef;
      Tr_AltRef.Text        := LongYrRef;
      Lab_TotalCost.Caption := Format ('%10.2f', [InvNetVal]);

      { detail line fields }
      List_TransLines.Clear;
      If (LineCount > 0) Then
        For I := 1 To LineCount Do
          With MyInvLines^[I] Do Begin
            FillChar (LineStr, SizeOf(LineStr), #32);
            LineStr[0] := #100;

            If (Length (StockCode) > 0) Then Move (StockCode[1], LineStr[1], Length (StockCode));
            If (Qty > 0) Then Begin
              Tmp := Format ('%4.2f', [Qty]);
              Move (Tmp[1], LineStr[18], Length (Tmp));
            End; { If }
            If (Length(Desc) > 35) Then
              Move (Desc[1], LineStr[26], 35)
            Else
              Move (Desc[1], LineStr[26], Length (Desc));
            If (NetValue <> 0) Then Begin
              Tmp := Format ('%10.2f', [NetValue]);
              Move (Tmp[1], LineStr[65], Length (Tmp));
            End; { If }
            List_TransLines.Items.Add(LineStr);
          End; { With }
    End; { If }
  End; { With }
End;

procedure TForm1.But_AddTransClick(Sender: TObject);
Var
  ExStat  :  Integer;
  PC      :  PChar;
  P,PL    :  Pointer;
begin
  MyInv^.TransDocHed := 'SIN';

  PC := StrAlloc (255);
  StrPCopy(PC,MyInv^.TransDocHed);


  P:=MyInv;
  PL:=MyInvLines;

  ExStat:=Ex_GetNextTransNo(PC,PC,True);


  If (EXStat=0) then Begin
    FillChar (MyInv^, SizeOf (MyInv^), #0);
    With MyInv^ Do Begin
      OurRef      := StrPas(PC);
      CustCode    := 'ACCO01';
      TransDate   := '19950205';
      DueDate     := '19950707';
      Currency    := 1;
      AcYr        := 95;
      AcPr        := 1;
      CoRate      := 1.0;
      VATRate     := 0.175;
      YourRef     := 'Wibble';
      LongYrRef   := 'Long Wibble';
      LineCount   := 0;
      TransDocHed := 'SIN';
      InvNetVal   := 30.00;
      InvVat      := 0.0;
      TotalCost   := 1.57;
      LineCount   := 2;
    End; { With }

    With MyInvLines^[1] Do Begin
      TransRefNo  := MyInv^.OurRef;
      LineNo      := 1;
      NomCode     := 10010;
      Currency    := MyInv^.Currency;
      CoRate      := 1.0;
      VATRate     := 0.175;
      StockCode   := 'IFSPROCKET      ';
      Qty         := 2.0;
      QtyMul      := 1.0;
      NetValue    := 20.00;
      Discount    := 0.0;
      VATCode     := 'S';
      VAT         := 0.0;
      CostPrice   := MyInv^.TotalCost;
      CustCode    := MyInv^.CustCode;
      LineDate    := MyInv^.TransDate;
      Desc        := 'Inverse Flange Sprocket';
    End; { With }

    With MyInvLines^[2] Do Begin
      TransRefNo  := MyInv^.OurRef;
      LineNo      := 2;
      NomCode     := 10010;
      Currency    := MyInv^.Currency;
      CoRate      := 1.0;
      VATRate     := 0.175;
      StockCode   := 'IFSPROCKET      ';
      Qty         := 1.0;
      QtyMul      := 1.0;
      NetValue    := 10.00;
      Discount    := 0.0;
      VATCode     := 'S';
      VAT         := 0.0;
      CostPrice   := MyInv^.TotalCost;
      CustCode    := MyInv^.CustCode;
      LineDate    := MyInv^.TransDate;
      Desc        := 'Inverse Flange Sprocket';
    End; { With }

    With MyInv^ Do
      InvNetVal := (MyInvLines^[1].Qty * MyInvLines^[1].NetValue) +
                   (MyInvLines^[2].Qty * MyInvLines^[2].NetValue);

    ExStat:=Ex_StoreTrans(P,PL,SizeOf(MyInv^),0,0);
  end;

  { display result of store operation }
  ShowMessage ('Result: ' + IntToStr(ExStat));

  StrDispose (PC);
End;

procedure TForm1.TransBtrieve(Sender: TObject);
Var
  ExStat  :  Integer;
  PC      :  PChar;
  P,PL    :  Pointer;
begin
  With MyInv^ Do
    OurRef:=Tr_OurRef.Text;

  PC := StrAlloc (255);
  StrPCopy(PC, MyInv^.OurRef);
  CurrKPath:=0;

  P:=MyInv;
  PL:=MyInvLines;

  If (Sender = Button1) Then ExStat:=Ex_GetTrans(P,PL,SizeOf(MyInv^),PC,CurrKPath,B_GetFirst,False);
  If (Sender = Button2) Then ExStat:=Ex_GetTrans(P,PL,SizeOf(MyInv^),PC,CurrKPath,B_GetPrev,False);
  If (Sender = Button3) Then ExStat:=Ex_GetTrans(P,PL,SizeOf(MyInv^),PC,CurrKPath,B_GetGEq,False);
  If (Sender = Button4) Then ExStat:=Ex_GetTrans(P,PL,SizeOf(MyInv^),PC,CurrKPath,B_GetNext,False);
  If (Sender = Button5) Then ExStat:=Ex_GetTrans(P,PL,SizeOf(MyInv^),PC,CurrKPath,B_GetLast,False);

  DispTrans;

  StrDispose (PC);
end;


(***************************************************************)
(* Supplier Routines                                           *)
(***************************************************************)
Procedure TForm1.DispSupp;
Begin
  With MySupp^ Do Begin
    Su_Code.Text  := CustCode;
    Su_Comp.Text  := Company;
    Su_Cont.Text  := Contact;
    Su_Addr1.Text := Addr[1];
    Su_Addr2.Text := Addr[2];
    Su_Addr3.Text := Addr[3];
    Su_Addr4.Text := Addr[4];
    Su_Addr5.Text := Addr[5];
    Su_Phone.Text := Phone;
    Su_Fax.Text   := Fax;

    (*
    {* Balance *}
    Edit9.Text:=FloatToStr(GetACCBal(CustCode,'YTD','',0));
    {* Sales This Period/Year *}
    Edit10.Text:=FloatToStr(GetACCBal(CustCode,'','',4));
    {* Sales YTD *}
    Edit11.Text:=FloatToStr(GetACCBal(CustCode,'YTD','',4));
    {* Sales LYTD *}
    Edit12.Text:=FloatToStr(GetACCBal(CustCode,'YTD','-1',4));
    *)
  End; { With }
End;

procedure TForm1.Form2Supp;
Begin
  FillChar (MySupp^, SizeOf (MySupp^), #0);
  With MySupp^ Do Begin
    CustCode := Su_Code.Text;
    CustSupp := 'S';
    Company  := Su_Comp.Text;
    Contact  := Su_Cont.Text;
    Addr[1]  := Su_Addr1.Text;
    Addr[2]  := Su_Addr2.Text;
    Addr[3]  := Su_Addr3.Text;
    Addr[4]  := Su_Addr4.Text;
    Addr[5]  := Su_Addr5.Text;
    Phone    := Su_Phone.Text;
    Fax      := Su_Fax.Text;
    PayType  := 'C';
    VATCode  := 'S';
    Currency := 1;
  End; { With }
end;

procedure TForm1.SuppBtrieve(Sender: TObject);
Var
  ExStat  :  Integer;
  PC      :  PChar;
  P,PL    :  Pointer;
begin
  With MySupp^ Do
    CustCode:=Su_Code.Text;

  PC := StrAlloc (255);
  StrPCopy(PC, MySupp^.CustCode);
  CurrKPath:=0;

  P:=MySupp;

  If (Sender = Button6)  Then ExStat:=Ex_GetAccount(P,SizeOf(MySupp^),PC,CurrKPath,B_GetFirst,2,False);
  If (Sender = Button7)  Then ExStat:=Ex_GetAccount(P,SizeOf(MySupp^),PC,CurrKPath,B_GetPrev,2,False);
  If (Sender = Button8)  Then ExStat:=Ex_GetAccount(P,SizeOf(MySupp^),PC,CurrKPath,B_GetGEq,2,False);
  If (Sender = Button9)  Then ExStat:=Ex_GetAccount(P,SizeOf(MySupp^),PC,CurrKPath,B_GetNext,2,False);
  If (Sender = Button10) Then ExStat:=Ex_GetAccount(P,SizeOf(MySupp^),PC,CurrKPath,B_GetLast,2,False);

  DispSupp;

  StrDispose (PC);
end;

procedure TForm1.Su_AddClick(Sender: TObject);
Var
  ExStat, I : Integer;
  P         : Pointer;
begin
  If (Su_Add.Caption = '&Add') Then Begin
    { Add a Customer }
    Su_Add.Caption := '&Save';
    Su_Close.Caption := '&Cancel';

    FEdit := False;
    TmpKey := Su_Code.Text;
    FillChar (MySupp^, SizeOf (MySupp^), #0);
    DispSupp;
    If Su_Code.CanFocus Then Su_Code.SetFocus;
  End { If }
  Else Begin
    { Save the Customer }
    Form2Supp;

    P:=MySupp;
    If FEdit Then
      ExStat:=Ex_StoreAccount (P, SizeOf (MySupp^), 0, B_Update)
    Else
      ExStat:=Ex_StoreAccount (P, SizeOf (MySupp^), 0, B_Insert);

    Case ExStat Of
      0     : Begin { AOK }
                Su_Add.Caption := '&Add';
                Su_Close.Caption := '&Edit';
              End;
      5     : Begin { Btrieve Error 5: Duplicates }
                If SU_Code.CanFocus Then Su_Code.SetFocus;
                 ShowMessage ('A Supplier with this code already exists');
              End;
    Else
      ShowMessage ('Error: ' + IntToStr(ExStat));
    End; { Case }
  End; { Else }

  Button6.Enabled  := (Su_Add.Caption = '&Add');
  Button7.Enabled  := (Su_Add.Caption = '&Add');
  Button8.Enabled  := (Su_Add.Caption = '&Add');
  Button9.Enabled  := (Su_Add.Caption = '&Add');
  Button10.Enabled := (Su_Add.Caption = '&Add');
end;

procedure TForm1.Su_CloseClick(Sender: TObject);
begin
  If (Su_Close.Caption = '&Cancel') Then Begin
    { Cancel the add }
    FillChar (MySupp^, SizeOf (MySupp^), #0);
    Su_Code.Text := TmpKey;
    SuppBtrieve(Button8);

    Su_Add.Caption := '&Add';
    Su_Close.Caption := '&Edit';
  End { If }
  Else Begin
    { Edit the Customer }
    Su_Add.Caption := '&Save';
    Su_Close.Caption := '&Cancel';

    FEdit := True;
    TmpKey := Su_Code.Text;
    If Su_Code.CanFocus Then Su_Code.SetFocus;
  End; { Else }

  Button6.Enabled  := (Su_Add.Caption = '&Add');
  Button7.Enabled  := (Su_Add.Caption = '&Add');
  Button8.Enabled  := (Su_Add.Caption = '&Add');
  Button9.Enabled  := (Su_Add.Caption = '&Add');
  Button10.Enabled := (Su_Add.Caption = '&Add');
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  Ex_TestMode(CheckBox1.Checked);
end;


(***************************************************************)
(* Nominal Display Routine                                     *)
(***************************************************************)
Procedure TForm1.DispNom;
Begin
  With MyGLAcc^ Do Begin
    GL_Code.Text  := IntToStr(NomCode);
    GL_Desc.Text  := Desc;
    GL_NomType.Text := NomType;
    GL_Cat.Text     := IntToStr(Cat);
    GL_CarryF.Text  := IntToStr(CarryF); 
  End; { With }
End;


procedure TForm1.NomBtrieve(Sender: TObject);
Var
  ExStat  :  Integer;
  PC      :  PChar;
  P,PL    :  Pointer;


begin
  With MyGLAcc^ Do
    Desc:=GL_Desc.Text;

  PC := StrAlloc(255);
  StrPCopy(PC,GL_Code.Text);


  CurrKPath:=0;

  P:=MyGLAcc;

  If (Sender = First   ) Then ExStat:=Ex_GetGLAccount(P,SizeOf(MyGLAcc^),PC,CurrKPath,B_GetFirst,False);
  If (Sender = Previous) Then ExStat:=Ex_GetGLAccount(P,SizeOf(MyGLAcc^),PC,CurrKPath,B_GetPrev,False);
  If (Sender = Find    ) Then ExStat:=Ex_GetGLAccount(P,SizeOf(MyGLAcc^),PC,CurrKPath,B_GetGEq,False);
  If (Sender = Next    ) Then ExStat:=Ex_GetGLAccount(P,SizeOf(MyGLAcc^),PC,CurrKPath,B_GetNext,False);
  If (Sender = Last    ) Then ExStat:=Ex_GetGLAccount(P,SizeOf(MyGLAcc^),PC,CurrKPath,B_GetLast,False);

  If ExStat=0 then
    DispNom
  else
    ShowMessage('Error : '+IntToStr(ExStat));

  StrDispose (PC);
end;

Procedure TForm1.Nom_Data;
{ convert entry data to mem data }

Const
  EmptyStr : String = '';
Begin
  FillChar (MyGLAcc^, SizeOf (MyGLAcc^), #0);
  With MyGLAcc^ Do
  Begin
    NomCode := StrToInt(GL_Code.Text);
    Desc    := GL_Desc.Text;
    Cat     := StrToInt(GL_Cat.Text);
    CarryF  := StrToInt(GL_CarryF.Text);
    If (GL_NomType.Text<>EmptyStr) then
      NomType := GL_NomType.Text[1];

  End; { With }
end;


procedure TForm1.Nom_AddClick(Sender: TObject);
{Add New Nominal}
Var
  ExStat, I : Integer;
  P         : Pointer;
begin
  If (Nom_Add.Caption = '&Add') Then
  Begin
    { Add Nominal }
    Nom_Add.Caption := '&Save';
    Nom_Edit.Caption := '&Cancel';

    FEdit := False;
    TmpKey := GL_Code.Text;
    FillChar (MyGLAcc^, SizeOf (MyGLAcc^), #0);
    DispNom;
    If GL_Code.CanFocus Then GL_Code.SetFocus;

  End
  Else  { Save from Add }
  Begin
    { Convert from screen to mem and do validation of Nominal data }
    Nom_Data;

    P:=MyGLAcc;
    If FEdit Then
      ExStat:=Ex_StoreGLAccount (P, SizeOf (MyGLAcc^), 0, B_Update)
    Else
      ExStat:=Ex_StoreGLAccount (P, SizeOf (MyGLAcc^), 0, B_Insert);

    Case ExStat Of
      0     : Begin { AOK }
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

  First.Enabled    := (Nom_Add.Caption = '&Add');
  Previous.Enabled := (Nom_Add.Caption = '&Add');
  Find.Enabled     := (Nom_Add.Caption = '&Add');
  Next.Enabled     := (Nom_Add.Caption = '&Add');
  Last.Enabled     := (Nom_Add.Caption = '&Add');

end;

procedure TForm1.Nom_EditClick(Sender: TObject);
begin
  If (Nom_Edit.Caption = '&Cancel') Then Begin
    { Cancel the add }
    FillChar (MyGLAcc^, SizeOf (MyGLAcc^), #0);
    GL_Code.Text := TmpKey;
    NomBtrieve(Find);

    Nom_Add.Caption := '&Add';
    Nom_Edit.Caption := '&Edit';
  End { If }
  Else Begin
    { Edit the Customer }
    Nom_Add.Caption := '&Save';
    Nom_Edit.Caption := '&Cancel';

    FEdit := True;
    TmpKey := GL_Code.Text;
    If GL_Code.CanFocus Then GL_Code.SetFocus;
  End; { Else }

  First.Enabled    := (Cu_Add.Caption = '&Add');
  Previous.Enabled := (Cu_Add.Caption = '&Add');
  Find.Enabled     := (Cu_Add.Caption = '&Add');
  Next.Enabled     := (Cu_Add.Caption = '&Add');
  Last.Enabled     := (Cu_Add.Caption = '&Add');
end;

(***************************************************************)
(* Display BOM Lines Routines                                  *)
(***************************************************************)

Procedure TForm1.DispBOM;
Const
  MaxLines = 500;
Var
  LineStr, Tmp : String[100];
  I            : Integer;
Begin
    If True Or (TabbedNoteBook1.ActivePage = 'BOM') Then
    Begin
        { detail line fields }
        ListBOMLines.Clear;
        For I := 1 To MaxLines Do
          With MyBOMLines^[I] Do Begin
            FillChar (LineStr, SizeOf(LineStr), #32);
            LineStr[0] := #100;

            {StockCode}
            If (Length (StockCode) > 0) Then
              Move (StockCode[1], LineStr[11], 16);

            {QtyUsed}
            If (QtyUsed > 0) Then Begin
              Tmp := Format ('%10.2f', [QtyUsed]);
              Move (Tmp[1], LineStr[28], 10);
            End; { If }

            {QtyCost}
            If (QtyCost > 0) Then Begin
              Tmp := Format ('%10.2f', [QtyCost]);
              Move (Tmp[1], LineStr[40], 12);
            End; { If }

            ListBOMLines.Items.Add(LineStr);

          End; { With }
    end; {If True..}
End;

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

  {SearchKey}
  PC := StrAlloc (255);
  StrPCopy(PC, B_StockCode.Text);

  {SearchMode}
  If (B_Toggle.Caption=ToggleMsg[0]) then
    SMode:=ToggleKey[0]
  else
    SMode:=ToggleKey[1];

  P:=MyBOMLines;

  If (Sender = B_Find) Then
  begin
     ExStat:=Ex_GetStockBOM(P,SizeOf(MyBOMLines^),PC,SMode);
     {DispBOM;}

     If (ExStat=0) then
       DispBOM
     else
       ShowMessage('Error : '+IntToStr(ExStat));
     
  end;
  StrDispose (PC);
end;


procedure TForm1.B_CancelClick(Sender: TObject);

Const
  ToggleMsg : Array[0..1] of String[10] = ('Where Used','Components');

begin
     B_StockCode.Text:='';
     B_Toggle.Caption:=ToggleMsg[0];
     ListBOMLines.Clear;
     B_StockCode.SetFocus;
end;

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


procedure TForm1.S_ByTranClick(Sender: TObject);
begin
  SRNoChk:=True;
  S_Box.Clear;
  S_Label1.Caption:='Transaction No';
  S_Label2.Caption:='Line No ';
  S_Field1.Text:='';
  S_Field2.Text:='0';
  S_Field1.SetFocus;
end;

procedure TForm1.S_BySerailClick(Sender: TObject);
begin
  SRNoChk:=False;
  S_Box.Clear;
  S_Label1.Caption:='Serial Number ';
  S_Label2.Caption:='Batch No';
  S_Field1.Text:='';
  S_Field2.Text:='';
  S_Field1.SetFocus;
end;

procedure TForm1.S_CancelClick(Sender: TObject);
begin
  SRNoChk:=True;
  S_Box.Clear;
  S_Label1.Caption:='Transaction No';
  S_Label2.Caption:='Line No ';
  S_Field1.Text:='';
  S_Field2.Text:='0';
  S_ByTran.SetFocus;
  S_Field1.SetFocus;
end;


Procedure TForm1.DispSR;
Const
  MaxLines = 500;
Var
  LineStr, Tmp : String[100];
  I            : Integer;
Begin
    If True Or (TabbedNoteBook1.ActivePage = 'Serial No') Then
    Begin
        { detail line fields }
        S_Box.Clear;
        For I := 1 To MaxLines Do
          With MySRLines^[I] Do Begin
            FillChar (LineStr, SizeOf(LineStr), #32);
            LineStr[0] := #100;

            {SerialNo}
            If (Length (SerialNo) > 0) Then
              Move (SerialNo[1], LineStr[1], 20);

            {BatchNo}
            If (Length (BatchNo) > 0) Then Begin
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

              Tmp:='/';
              Move (Tmp[1], LineStr[11], 1);
              Tmp := Format ('%6.2f', [BuyQty]);
              Move (Tmp[1], LineStr[12], 6);

              Move (BatchNo[1], LineStr[21], 10);

            end;

            {DateOut}
            If (Length (DateOut) > 0) Then
              Move (DateOut[1], LineStr[32], 8);

            {InMLoc}
            If (Length(InMLoc)>0) then
              Move(InMLoc[1],LineStr[44],3);

            {OutMLoc}
            If (Length(OutMLoc)>0) then
              Move(OutMLoc[1],LineStr[48],3);

            {Currency & Cost}
            If (SerCost > 0) Then Begin
              {FillChar(Tmp,SizeOf(Tmp),#0);}
              Tmp := IntToStr(CurCost);
              Move (Tmp[1], LineStr[53], SizeOf(CurCost));

              Tmp := Format ('%8.2f', [SerCost]);
              Move (Tmp[1], LineStr[56], 8);
            End; { If }


            {Currency & Selling Price}
            If (SerSell > 0) Then Begin
              Tmp := IntToStr(CurSell);
              Move (Tmp[1], LineStr[67], SizeOf(CurSell));

              Tmp := Format ('%8.2f', [SerSell]);
              Move (Tmp[1], LineStr[70], 8);
            End; { If }


            S_Box.Items.Add(LineStr);

          End; { With }
    end; {If True..}
End;


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

  {SearchKey PC for by Tran. or By Serial No}
  PC := StrAlloc (255);
  StrPCopy(PC, S_Field1.Text);

  If (SRNoChk) then
  begin
    {SearchMode}
    SMode:=0;
    {SearchKey SKey}
    SKey:=StrToInt(S_Field2.Text);
  end
  else
  begin
    SMode:=1;
    SKey:=0;
    {If TranNo=Empty, SearchKey PC = By Batch No}
    If (S_Field1.Text=EmptyStr) then
      StrPCopy(PC, S_Field2.Text);
  end;

  P:=MySRLines;

  If (Sender = S_Find) Then
  begin

     ExStat:=Ex_GetLineSerialNos(P,SizeOf(MySRLines^),PC,SKey,SMode);
     If (ExStat=0) then
       DispSR
     else
       ShowMessage('Error : '+IntToStr(ExStat));

  end;
  StrDispose (PC);
end;

procedure TForm1.BTrieveJob(Sender: TObject);
Var
  ExStat  :  Integer;
  PC      :  PChar;
  P,PL    :  Pointer;


begin
  With MyJob^ Do
    JobCode:=JobCode.Text;

  PC := StrAlloc (255);
  StrPCopy(PC, MyJob^.JobCode);
  CurrKPath:=0;

  P:=MyJob;

  If (Sender = J_First)    Then ExStat:=Ex_GetJob(P,SizeOf(MyJob^),PC,CurrKPath,B_GetFirst,False);
  If (Sender = J_Previous) Then ExStat:=Ex_GetJob(P,SizeOf(MyJob^),PC,CurrKPath,B_GetPrev,False);
  If (Sender = J_Find)     Then ExStat:=Ex_GetJob(P,SizeOf(MyJob^),PC,CurrKPath,B_GetGEq,False);
  If (Sender = J_Next)     Then ExStat:=Ex_GetJob(P,SizeOf(MyJob^),PC,CurrKPath,B_GetNext,False);
  If (Sender = J_Last)     Then ExStat:=Ex_GetJob(P,SizeOf(MyJob^),PC,CurrKPath,B_GetLast,False);

  DispCust;

  StrDispose (PC);
end;


end.


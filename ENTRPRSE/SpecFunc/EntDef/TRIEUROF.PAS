unit TriEuroF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Genentu, StdCtrls, ANIMATE, ExtCtrls, SBSPanel, bkgroup, ComCtrls, UnTils,
  CheckLst, TEditVal, Mask;

type
  TTriEuroFrm = class(TTestCust)
    Label2: TLabel;
    LastTriNom: Text8Pt;
    Label3: TLabel;
    Label81: Label8;
    Label82: Label8;
    EuroCurrF: TSBSComboBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure LastTriNomExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }

    Function Valid_Trans(DocNo  :  String)  :  Boolean;

    Function Valid_Currency(EuroCr  :  Integer)  :  Boolean;

    Function Gen_Summary  :  String;

  public
    { Public declarations }
    MaxFolio  :  LongInt;
    MaxDate   :  String;


  end;

Var
  STDCurrList :  TStringList;


Function Get_Triangulation(Var  DocRef  :  LongInt;
                           Var  DocDate :  String;
                           Var  EuroNo  :  Byte)  :  Boolean;


implementation

Uses
  GlobVar,
  VarConst,
  VarRec2U,
  ETStrU,
  BtrvU2,
  ProgU,
  ReBuld2U,
  ReBuld1U;

{$R *.DFM}



{* Function to Return TList of Std Currency Items *}


Function TxLatePound(Const TS     :  Str255;
                     Const From   :  Boolean)  :  Str255;

Var
  P  :  Integer;

Begin
  Result:=TS;

  If (From) then
    P:=Pos(#156,Result)
  else
    P:=Pos('£',Result);

  While (p<>0) do
  Begin
    If (From) then
    Begin
      Result[p]:='£';

      P:=Pos(#156,Result);
    end
    else
    Begin
      Result[p]:=#156;

      P:=Pos('£',Result);
    end;
  end;
end;


Procedure Init_STDCurrList;

Var
  n,
  TotCurr  :  Integer;

  Ts :  Str10;

Begin
  STDCurrList:=TStringList.Create;

  try

    TotCurr:=CurrencyType;

    For n:=0 to TotCurr do
    With SyssCurr do
    Begin
      With Currencies[n] do
      Begin
        Ts:=SSymb;

        Ts:=TxLatePound(Ts,BOn);

        STDCurrList.Add(Ts+' - '+Desc);

      end;
    end;

  except
    STDCurrList.Free;

  end;


end;


Procedure Set_DefaultCurr(ThisSet  :  TStrings;
                          IncZero,
                          ShowFull,
                          ShowNone :  Boolean);


Var
  n  :  Byte;

Begin
  ThisSet.Assign(STDCurrList);

  If (Not IncZero) then
    ThisSet.Delete(0);

  If (ShowNone) then
    ThisSet.Insert(0,'The Euro has not been setup.');


  If (Not ShowFull) then
  Begin
    For n:=0 to Pred(ThisSet.Count) do
      ThisSet[n]:=ExtractWords(1,1,ThisSet[n]);

  end;
end;


procedure TTriEuroFrm.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  inherited;
  ClientHeight:=290;
  ClientWidth:=408;

  Init_STDCurrList;

  Set_DefaultCurr(EuroCurrF.Items,BOff,BOn,BOn);

  EuroCurrF.ItemIndex:=0;

  MaxFolio:=0;  MaxDate:='';

end;

Function TTriEuroFrm.Valid_Trans(DocNo  :  String)  :  Boolean;

Var
  KeyS  :  String;
Begin
  Result:=(DocNo='');

  If (Not Result) then
  Begin
    KeyS:=AutoSetInvKey(DocNo,0);

    Result:=(CheckRecExsists(UpCaseStr(KeyS),InvF,InvOurRefK));

    If (Result) then
    Begin
      MaxFolio:=Inv.FolioNum;
      MaxDate:=Inv.TransDate;
    end
    else
    Begin
      ShowMessage(Trim(DocNo)+' is not a valid transaction number');
      
      MaxFolio:=0;
      MaxDate:=MaxUntilDate;
    end;
  end;
end;


Function TTriEuroFrm.Valid_Currency(EuroCr  :  Integer)  :  Boolean;

Begin

  Result:=(EuroCr>=0) and (EuroCr<=CurrencyType);


  If (Not Result) then
    ShowMessage(IntToStr(EuroCr)+' is not a valid currency.');

end;


procedure TTriEuroFrm.LastTriNomExit(Sender: TObject);
begin
  inherited;

  If (ActiveControl<>ClsCP1Btn) then
  With LastTriNom do
  If (Trim(Text)<>'') then
  Begin
    Text:=AutoSetInvKey(Text,0);

    If (Not Valid_Trans(Text)) then
      SetFocus;

  end;
end;

procedure TTriEuroFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {inherited;}

  {Override without inheritance}

end;

procedure TTriEuroFrm.ClsCP1BtnClick(Sender: TObject);
begin
  {inherited;}
  ModalResult:=mrCancel;
end;


Function TTriEuroFrm.Gen_Summary  :  String;

Begin
  Result:='You have chosen:-'+#13;

  If (LastTriNom.Text='') then
    Result:=Result+'To set all transactions as pre triangulation'
  else
    Result:=Result+'To set all transactions up to and including '+LastTriNom.Text;

  Result:=Result+'. '+#13+'&&'+#13;

  If (EuroCurrF.ItemIndex<=0) then
    Result:=Result+'The Euro currency has not been setup yet.'
  else
    Result:=Result+'The Euro currency is '+EuroCurrF.Text;


end;

procedure TTriEuroFrm.OkCP1BtnClick(Sender: TObject);
begin
  If (Valid_Trans(LastTriNom.Text)) then
  Begin
    If (Valid_Currency(EuroCurrF.ITemIndex)) then
    Begin
      ModalResult:=MessageDlg(Gen_Summary,mtConfirmation,[mbOk,mbCancel],0);

    end;
  end;
end;


Function Get_Triangulation(Var  DocRef  :  LongInt;
                           Var  DocDate :  String;
                           Var  EuroNo  :  Byte)  :  Boolean;

Var
  EuroForm  :  TTriEuroFrm;
  SLocked   :  Boolean;

Begin
  Result:=BOff;  SLocked:=BOff;

  GetMultiSysCur(BOff,SLocked);

  EuroForm:=TTriEuroFrm.Create(Application.MainForm);

  Try
    EuroForm.ShowModal;

    Result:=(EuroForm.ModalResult=mrOK);

    If (Result) then
    With EuroForm do
    Begin
      DocRef:=MaxFolio;
      DocDate:=MaxDate;

      If (EuroCurrF.ItemIndex>-1) and (EuroCurrF.ITemIndex<256) then
        EuroNo:=EuroCurrF.ItemIndex;

    end
    else
    Begin
      Write_FixMsgFmt('Special Function 54 has been aborted.',4);


    end;

  Finally
    EuroForm.Free;

  end; {Try..}

end;



Initialization


Finalization

If (Assigned(STDCurrList)) then
  Begin
    STDCurrList.Free;
    STDCurrList:=Nil;
  end;




end.

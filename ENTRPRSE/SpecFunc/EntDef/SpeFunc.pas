unit SpeFunc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Genentu, StdCtrls, ANIMATE, ExtCtrls, SBSPanel, bkgroup, ComCtrls, UnTils,
  SpeF3U, TEditVal, BorBtns;

type
  TTestCust4 = class(TTestCust)
    Label2: TLabel;
    FuncsList: TListBox;
    SFNoF: TCurrencyEdit;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure FuncsListDblClick(Sender: TObject);
    procedure EnterSFChkClick(Sender: TObject);
  private
    { Private declarations }
    SFOrd  :  Array[0..TotSFFunc] of Byte;

    Procedure WMCustGetRec(Var Message  :  TMessage);  Message WM_CustGetRec;

    Function SFLookUp  :  SmallInt;

  public
    { Public declarations }

    procedure ShowBar(Waiting  :  Boolean);


  end;


implementation

Uses
  GlobVar,
  VarConst,
  BtrvU2,
  ProgU;

{$R *.DFM}

procedure TTestCust4.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  inherited;
  Animated1.Play:=False;
  Animated1.visible:=BOff;
  SBSPanel1.Visible:=BOff;

  ClientHeight:=338;
  ClientWidth:=521;

  FillChar(SFOrd,sizeof(SFOrd),0);

  For n:=1 to TotSFFunc do
  With FuncsList do
  Begin
    If (n In SFEntInclude) then
    Begin
      SFOrd[Items.Count]:=n;
      Items.Add('('+Format('%0d',[n])+'). '+Get_SFMode(n));


    end;
  end;


end;


Function TTestCust4.SFLookUp  :  SmallInt;

Var
  UseMe  :  SmallInt;

Begin
   UseMe:=0;

  If (Round(SFNoF.Value)>0) then
    UseMe:=Round(SFNoF.Value)
  else
    If (FuncsList.ItemIndex>-1) and (FuncsList.ItemIndex<=TotSFFunc) then
      UseMe:=SFOrd[FuncsList.ItemIndex];


  Result:=UseMe;
end;

Procedure TTestCust4.WMCustGetRec(Var Message  :  TMessage);

Begin
  With Message do
  Begin


    Case WParam of

//      10 :  Special_Function(SFLookUp,ProgBar);

      11 :  ;



      else  Inherited;

    end; {Case..}

  end; {With..}


end;



procedure TTestCust4.ShowBar(Waiting  :  Boolean);

Var
  n  :  Integer;

Begin
  Animated1.Play:=False;


{
  ProgBar:=TGenProg.Create(Self);

  try
    With ProgBar do
    Begin


      ShowModal;

    end;

  finally
    ProgBar.Free;

    SendMessage(Self.Handle,WM_Close,0,0);
  end;
}

end;


procedure TTestCust4.OkCP1BtnClick(Sender: TObject);
Var
  mbRet    :  Word;

begin

  If (SFLookUp>0) and (SFLookUp<=TotSFFunc) and (SFLookUp In SFEntInclude) then
  Begin
    mbRet:=MessageDlg('Please confirm you wish to start special function '+IntToStr(SFLookUp)+#13+
                      Get_SFMode(SFLookUp),mtConfirmation, [mbYes, mbNo], 0);

    If (mbRet=mrYes) then
      ShowBar(BOff);

  end
  else
    ShowMessage('You must select a valid Special function first.');


end;

procedure TTestCust4.ClsCP1BtnClick(Sender: TObject);
begin
  inherited;
  SendMessage(Self.Handle,WM_Close,0,0);
end;

procedure TTestCust4.FuncsListDblClick(Sender: TObject);
begin
  inherited;

  OKCP1BtnClick(Nil);

end;

procedure TTestCust4.EnterSFChkClick(Sender: TObject);
begin
  inherited;

  //SFNOF.Enabled:=EnterSFChk.Checked;
end;

end.

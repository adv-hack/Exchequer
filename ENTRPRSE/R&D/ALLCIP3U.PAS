unit AllCIP3U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, Animate, ExtCtrls, SBSPanel, StdCtrls, bkgroup, BTSupU1, Mask,
  TEditVal, VarConst, VarRec2U,BTSupU3;

type
  TAllocWAPLInp = class(TRepInpMsg)
    Label89: Label8;
    Label824: Label8;
    Label825: Label8;
    Label826: Label8;
    Label828: Label8;
    GLPay1F: Text8Pt;
    GLPay1NameF: Text8Pt;
    GLPayAmt1: TCurrencyEdit;
    GLPay2F: Text8Pt;
    GLPay2NameF: Text8Pt;
    GLPayAmt2: TCurrencyEdit;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure GLPay1FExit(Sender: TObject);
    procedure GLPayAmt1Enter(Sender: TObject);
    procedure GLPayAmt2Enter(Sender: TObject);
  private
    { Private declarations }



  public
    { Public declarations }

    AllocCtrlRec  :  MLocRec;

    procedure Link2Links;

    procedure OutPayItems;

    Function CheckAWCompleted(Edit  :  Boolean)  : Boolean;

  end;

procedure AllocAPLCtrl(BAllocCtrlRec  :  MLocRec;
                       AOwner         :  TComponent);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  SysU1,
  SysU2,
  CurrncyU,
  InvListU,
  AllocS1U,
  Event1U,
  BTSupU2;

{$R *.DFM}






procedure TAllocWAPLInp.FormCreate(Sender: TObject);

Var
  LPr,LYr  :  Byte;

begin
  inherited;
  ClientHeight:=166;
  ClientWidth:=467;

  Animated1.Visible:=BOff;

end;


procedure TAllocWAPLInp.Link2Links;

Var
  FoundLong  :  LongInt;
  FoundCode  :  Str20;

Begin
  If (GLPay1F.Text<>'') then
  Begin
    FoundCode:=GLPay1F.Text;

    If GetNom(Self,FoundCode,FoundLong,-1) then
      GLPay1NameF.Text:=Nom.Desc;
  end;

  If (GLPay2F.Text<>'') then
  Begin
    FoundCode:=GLPay2F.Text;

    If GetNom(Self,FoundCode,FoundLong,-1) then
      GLPay2NameF.Text:=Nom.Desc;
  end;

end;

procedure TAllocWAPLInp.OutPayItems;

Begin
  With AllocCtrlRec.AllocCRec do
  Begin
    GLPay1F.Text:=Form_BInt(arcCharge1GL,0);
    GLPay2F.Text:=Form_BInt(arcCharge2GL,0);

    GLPayAmt1.CurrencySymb:=PSymb(arcPayCurr);
    GLPayAmt2.CurrencySymb:=PSymb(arcPayCurr);

    GLPayAmt1.Value:=arcCharge1Amt;
    GLPayAmt2.Value:=arcCharge2Amt;

    Link2Links;
  end;
end;

procedure TAllocWAPLInp.GLPay1FExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  FailOk,
  AltMod,
  MDCFlg     :  Boolean;

  FoundLong  :  LongInt;


begin
  MDCFlg:=(Sender=GLPay2F);

  FoundOk:=BOff; FailOk:=BOff;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>ClsCP1Btn) and (FoundCode<>'') then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self,FoundCode,FoundLong,2));


      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=Form_Int(FoundLong,0);


        Link2Links;

      end
      else
      Begin
        FailOk:=BOn;
        SetFocus;
      end; {If not found..}
    end;


    If (Not FoundOk) and (AltMod) and (FoundCode='') then
    Begin
      If (MDCFlg) then
      Begin
        GLPay2NameF.Text:='';
        GLPayAmt2.Value:=0.0;
      end
      else
      Begin
        GLPay1NameF.Text:='';
        GLPayAmt1.Value:=0.0;
      end;
    end;
  end; {with..}

end;

procedure TAllocWAPLInp.GLPayAmt1Enter(Sender: TObject);
begin
  inherited;

  GLPayAmt1.ReadOnly:=(GLPay1F.Text='');

end;

procedure TAllocWAPLInp.GLPayAmt2Enter(Sender: TObject);
begin
  inherited;

  GLPayAmt2.ReadOnly:=(GLPay2F.Text='');

end;

Function TAllocWAPLInp.CheckAWCompleted(Edit  :  Boolean)  : Boolean;

  Const
    NofMsgs      =  3;

  Type
    PossMsgType  = Array[1..NofMsgs] of Str80;

  Var
    PossMsg  :  ^PossMsgType;

    Test     :  Byte;

    ShowMsg  :  Boolean;

    mbRet    :  Word;

    FoundCode2
             :  Str10;

    FoundCode:  Str20;

    FoundLong:  LongInt;



  Begin
    New(PossMsg);

    FillChar(PossMsg^,Sizeof(PossMsg^),0);

    PossMsg^[1]:='The value of split charges is greater than the total value.';
    PossMsg^[2]:='The G/L code for split charge 1 is not valid.';
    PossMsg^[3]:='The G/L code for split charge 2 is not valid.';




    Test:=1;

    Result:=BOn; 


    While (Test<=NofMsgs) and (Result) do
    With AllocCtrlRec,AllocCRec do
    Begin
      {$B-}

      ShowMsg:=BOn;

      Case Test of


        1  :  Begin
                {$B-}

                Result:=(arcAutoTotal) or (((arcCharge1Amt+arcCharge2Amt)<arcTransValue) and (arcTransValue>0))
                    or (((arcCharge1Amt+arcCharge2Amt)>arcTransValue) and (arcTransValue<0));

                {$B+}
              end;
        {$B-}
          2  :   Result:=(arcCharge1GL=0) or (GetNom(Self,Form_Int(arcCharge1GL,0),FoundLong,-1));

          3  :   Result:=(arcCharge2GL=0) or (GetNom(Self,Form_Int(arcCharge2GL,0),FoundLong,-1));

        {$B+}


      end;{Case..}

      {$B+}

      If (Result) then
        Inc(Test);

    end; {While..}

    If (Not Result) and (ShowMsg) then
      mbRet:=MessageDlg(PossMsg^[Test],mtWarning,[mbOk],0);

    Dispose(PossMsg);

  end; {Func..}


procedure TAllocWAPLInp.OkCP1BtnClick(Sender: TObject);

Var
  Ok2Print  :  Boolean;

begin
  Ok2Print:=BOff;

  If (Sender=OkCP1Btn) then
  Begin
    // MH 15/12/2010 v6.6 ABSEXCH-10548: Set focus to Next/Finish button to trigger OnExit validation
    If (ActiveControl <> OkCP1Btn) And OkCP1Btn.CanFocus Then
      // Move focus to OK button to force any OnExit validation to occur
      OkCP1Btn.SetFocus;

    With AllocCtrlRec.AllocCRec do
    Begin
      arcCharge1GL:=IntStr(GLPay1F.Text);
      arcCharge2GL:=IntStr(GLPay2F.Text);

      arcCharge1Amt:=GLPayAmt1.Value;
      arcCharge2Amt:=GLPayAmt2.Value;

      If CheckAWCompleted(BOn) then
      Begin

        OkCp1Btn.Enabled:=BOff;
        ClsCp1Btn.Enabled:=BOff;

        Alloc_CtrlPut(MLocF,MLK,AllocCtrlRec,nil,2);

        Enabled:=BOff;
        Ok2Print:=BOn;
      end
    end;
  End; // If (Sender=OkCP1Btn)
  

  If (Sender<>OkCP1Btn) or (Ok2Print) then
  Begin
    
    SendMessage(TForm(Owner).Handle,WM_CustGetRec,91+Ord(Ok2Print),0);

    inherited;
  end;


end;


procedure AllocAPLCtrl(BAllocCtrlRec  :  MLocRec;
                       AOwner         :  TComponent);

Var
  RepInpMsg1  :  TAllocWAPLInp;

Begin

  RepInpMsg1:=TAllocWAPLInp.Create(AOwner);

  try
    With RepInpMsg1 do
    Begin
      AllocCtrlRec:=BAllocCtrlRec;
      OutPayItems;
    end;
  except;
    RepInpMsg1.Free;
  end;

end;








end.


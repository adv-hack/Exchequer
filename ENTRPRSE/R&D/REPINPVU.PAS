unit RepInpVU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, ExtCtrls, bkgroup, BTSupU3, Mask, TEditVal, BorBtns,
  Animate, SBSPanel, GlobVar, VarRec2U;

type
  TRepInpMsgV = class(TRepInpMsg)
    Label85: Label8;
    Label81: Label8;
    Label82: Label8;
    Sum1: TBorCheck;
    I2PrYrF: TEditPeriod;
    Label83: Label8;
    I1PrYrF: TEditPeriod;
    T21F: Text8Pt;
    Label84: Label8;
    Label86: Label8;
    T22F: Text8Pt;
    Label87: Label8;
    T11F: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure I1PrYrFExit(Sender: TObject);
  private
    { Private declarations }
    RepMode    :  Byte;
    CRepParam  :  VATRepPtr;
    CRepParam2 :  ISVATRepPtr;
    IRVInp     :  IRVInpType;
    CompPr     :  String;


  public
    { Public declarations }
  end;

Var
  VMNo  :  Byte;


Function FullIRVFile(R,C      :  Char;
                     EMode    :  LongInt)  :  Str20;

Function Get_LastIRVVal(FileKey  :  Str255;
                    Var IRVRec   :  IRVInpType)  :  Boolean;

Procedure Put_LastIRVVal(ASubCode :  Char;
                         IRVRec   :  IRVInpType;
                         EMode    :  LongInt);



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,

  VarConst,
  BTKeys1U,
  InvListU,

  ReportKU,

  {$IFDEF PF_On}
    {$IFDEF STK}
       RepBSupU,
    {$ENDIF}
  {$ENDIF}


  SysU1,
  SysU2,
  BtrvU2,
  PWarnU,
  GenWarnU,
  BTSupU1,
  BTSupU2;

{$R *.DFM}




{ ======== Routines to manage the storage of default variables ======= }



Function FullIRVFile(R,C      :  Char;
                     EMode    :  LongInt)  :  Str20;




Begin

  FullIRVfile:=R+C+FullNomKey(Emode)+HelpKStop;

end; {Func..}



Function Get_LastIRVVal(FileKey  :  Str255;
                    Var IRVRec   :  IRVInpType)  :  Boolean;



Const
  Fnum     =  MiscF;

  KeyPAth  =  MIK;


Var
  FoundOk  :  Boolean;


Begin

  FoundOk:=BOff;

  Blank(IRVRec,Sizeof(IRVRec));

  Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,FileKey);


  FoundOk:=StatusOk;

  If (FoundOk) then
    IRVRec:=MiscRecs^.IrishVATRec.IRVInpRec;

  Get_LastIRVVal:=FoundOk;

end; {Func..}




Procedure Put_LastIRVVal(ASubCode :  Char;
                         IRVRec   :  IRVInpType;
                         EMode    :  LongInt);



Const
  Fnum     =  MiscF;

  KeyPAth  =  MIK;


Var
  FOk        :  Boolean;

  GAlloc     :  Real;

  TmpIRVRec  :  IRVInpType;


Begin

  With MiscRecs^ do
  With IrishVATRec do
  Begin

    FOK:=Get_LastIRVVal(FullIRVFile(AllocTCode,ASubCode,EMode),TmpIRVRec);


    If (Not FOk) then
    Begin

      ResetRec(Fnum);

      RecMFix:=AllocTCode;

      SubType:=ASubCode;

      IRVInpCode:=FullNomKey(Emode)+HelpKStop;

      IRVInpRec:=IRVRec;

      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    end
    else
    Begin

      IRVInpRec:=IRVRec;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    end;


    Report_BError(Fnum,Status);

  end; {With..}

end; {Proc..}





procedure TRepInpMsgV.FormCreate(Sender: TObject);


Var
  VSYr,VSPr
     :  Word;

  CVYr,CVPr,
  NYear,
  n  :  Integer;

begin
  inherited;

  ClientHeight:=230;
  ClientWidth:=301;

  RepMode:=VMNo;

  New(Self.CRepParam);
  New(Self.CRepParam2);

  Blank(IRVInp,Sizeof(IRVInp));

  try
    With Self.CRepParam^ do
    Begin
      FillChar(Self.CRepParam^,Sizeof(Self.CRepParam^),0);
      VATEndD:=SyssVat.VATRates.CurrPeriod;

      NYear:=Part_Date('Y',VATEndd);

      VPr:=Part_Date('M',VATEndd);

      CVYr:=NYear; CVPr:=VPr;

      VYr:=TxlateYrVal(NYear,BOn);

      I1PrYrF.InitPeriod(VPr,VYr,BOn,BOn);

      I1PrYrF.PeriodsInYear:=12;

      VISYr:=VYr; VISPr:=VPr;

      I2PrYrF.InitPeriod(VISPr,VISYr,BOn,BOn);

      I2PrYrF.PeriodsInYear:=12;

      CompPr:=I1PrYrF.Text;

      If (Get_LastIRVVal(FullIRVFile(AllocTCode,AllocSCode,2),IRVInp)) then
      With IRVatInp do
      Begin
        TCodes[1]:=IRVInp.T11Codes;
        TCodes[2]:=IRVInp.T21Codes;
        TCodes[3]:=IRVInp.T22Codes;

        T11F.Text:=TCodes[1];
        T21F.Text:=TCodes[2];
        T22F.Text:=TCodes[3];

      end;


    end;
  except
    Dispose(Self.CRepParam);
    Self.CRepParam:=nil;
  end;

  try
    With Self.CRepParam2^ do
    Begin
      FillChar(Self.CRepParam2^,Sizeof(Self.CRepParam2^),0);

    end;
  except
    Dispose(Self.CRepParam2);
    Self.CRepParam2:=nil;
  end;


  If (RepMode<>0) then
  Begin
    Sum1.Visible:=BOff;
  end
  else
    Sum1.Visible:=BoChkAllowed_In((RepMode=0),50);


  If (RepMode=0) then
    Caption:=CCVATName^+' '+Caption
  else
  Begin
    Caption:='Intra EC Trade Statistics';
    HelpContext:=708;
    I1PrYrF.HelpContext:=636;
  end;

  SetLastValues;

  If (RepMode=0) and (Sum1.Checked) then
  With CRepParam^ do
  Begin
    I1PrYrF.InitPeriod(VPr,VYr,BOn,BOn);

    I1PrYrF.PeriodsInYear:=12;

    I2PrYrF.InitPeriod(VPr,VYr,BOn,BOn);

    I2PrYrF.PeriodsInYear:=12;

    Sum1.Checked:=BOff;
  end;

end;


procedure TRepInpMsgV.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

  If (Assigned(CRepParam2)) then
    Dispose(CRepParam2);

end;


procedure TRepInpMsgV.I1PrYrFExit(Sender: TObject);
begin
  inherited;

  If (RepMode=0) and (Sum1.Visible) then
  Begin
    With CRepParam^ do
      Sum1.Enabled:=(CompPr=I1PrYrF.Text);

    If (Sum1.Checked) and (Not Sum1.Enabled) then
      Sum1.Checked:=BOff;
  end;

end;

procedure TRepInpMsgV.OkCP1BtnClick(Sender: TObject);

Var
  VSYr,VSPr,
  AVPr
     :  Word;

  CVYr,CVPr,
  NYear,
  n  :  Integer;

begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With Self.CRepParam^ do
      Begin
        I1PrYrFExit(Nil);

        If (Sum1.Checked) then {Warn about implications of closing the VAT period}
        Begin
          Sum1.Checked:=(CustomDlg(Application.MainForm,'Please Note!','The '+CCVATName^+' period is about to be closed',
                                   'Closing the '+CCVATName^+' period will prevent you from posting any future transactions to this '+
                                   CCVATName^+' period again.'+#13+
                                   'You should only close the current '+CCVATName^+' period once you have confirmed the report is '+
                                   'correct.'+#13+
                                   'You can also close the period via the '+CCVATName^+' setup screen (F5).'+#13+
                                   'Please confirm you wish to close the current '+CCVATName^+' period.',
                                   mtWarning,
                                   [mbYes,mbNo])=mrOK);



        end;


        OKCP1Btn.Enabled:=BOff;

        I2PrYrF.InitPeriod(VPr,VYr,BOff,BOff);

        I1PrYrF.InitPeriod(VISPr,VISYr,BOff,BOff);

        NYear:=ConvTxYrVal(VYr,BOff);

        VSYr:=VISYr; VSPr:=VISPr;

        VATStartD:=StrDate(ConvTxYrVal(VSYr,BOff),VsPr,01);

        If (VPr=2) then {* Compensate for period 2 *}
          AVPr:=Pred(Monthdays[VPr])
        else
          AVPr:=Monthdays[VPr];

        VATEndD:=StrDate(NYear,VPr,AVPr);

        {* Switch to 100 type format for y2k *}

        VISYr:=ConvTxYrVal(VSYr,BOff)-1900;

        AutoCloseVAT:=Sum1.Checked;

        With IRVatInp do
        Begin
          TCodes[1]:=UpCaseStr(T11F.Text);
          TCodes[2]:=UpCaseStr(T21F.Text);
          TCodes[3]:=UpCaseStr(T22F.Text);

          IRVInp.T11Codes:=TCodes[1];
          IRVInp.T21Codes:=TCodes[2];
          IRVInp.T22Codes:=TCodes[3];

          Put_LastIRVVal(AllocSCode,IRVInp,2);

        end;



        With CRepParam2^ do
        Begin
          VPr:=CRepParam^.VPr;
          VYr:=CRepParam^.VYr;
        end;

        Case RepMode of
          0  :  AddVATRRep22Thread(0,CRepParam,Owner);

          {$IFDEF PF_On}
            {$IFDEF STK}
               else  AddISVATRep3Thread(RepMode,CRepParam2,Owner);
            {$ENDIF}
          {$ENDIF}

        end; {Case..}

      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;



Initialization

  VMNo:=0;

end.

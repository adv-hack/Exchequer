unit CISInp1U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, ExtCtrls, bkgroup, BTSupU3, Mask, TEditVal, GlobVar,
  Animate, SBSPanel, VarRec2U,   BTSupU1, BorBtns;

type
  TCISVInp = class(TRepInpMsg)
    Label86: Label8;
    Label87: Label8;
    I1TransDateF: TEditDate;
    I2TransDateF: TEditDate;
    Label82: Label8;
    V23PF: Text8Pt;
    Label83: Label8;
    Label84: Label8;
    V25PF: Text8Pt;
    Label85: Label8;
    Label820: Label8;
    cbSortLF: TSBSComboBox;
    Label81: Label8;
    cbAggcb: TSBSComboBox;
    V23CF: Text8Pt;
    V25CF: Text8Pt;
    cbCloseP: TBorCheck;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure I2TransDateFExit(Sender: TObject);
    procedure V25PFExit(Sender: TObject);
    procedure cbSortLFChange(Sender: TObject);
  private
    { Private declarations }
    FormIMode  :  Byte;
    SendCancel :  Boolean;

    CRepParam  :  CVATRepPtr;

    Procedure Get_CISSuggest(Var StartDate,
                                 EndDate   :  LongDate);

    procedure Show_MyCISList;

    Procedure Show_Ledger;

    Procedure Finish_Thread;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

  public
    { Public declarations }
  end;


  Procedure SetFMode(FM  :  Byte);



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  VarConst,
  IntMU,
  SysU1,
  SysU2,
  SysU3,
  BTSupU2,
  InvListU,
  JChkUseU,
  CISSup1U,
  CISSup2U,
  GenWarnU,

  JobSup1U,

  CISVCH1U;

{$R *.DFM}

Var
  FMode  :  Byte;



Procedure SetFMode(FM  :  Byte);
Begin
  FMode:=FM;

end;

{ ========= Calculate next EC Suggested sales Range ========= }

Procedure TCISVInp.Get_CISSuggest(Var StartDate,
                                      EndDate   :  LongDate);



Var

  Ld,Lm,Ly  :  Word;



Begin

  With SyssCIS^.CISRates do
  Begin
    EndDate:=CurrPeriod;

    StartDate:=CalcDueDate(CISReturnDate,1);
  end;


end; {Proc..}


procedure TCISVInp.FormCreate(Sender: TObject);
Var
  Locked  :  Boolean;

begin
  inherited;
  ClientHeight:=233;
  ClientWidth:=368;
  FormIMode:=FMode;
  SendCancel:=BOn;

  New(Self.CRepParam);

  SetLastValues;

  try
    With Self.CRepParam^, SyssCIS^.CISRates do
    Begin
      FillChar(Self.CRepParam^,Sizeof(Self.CRepParam^),0);

      Locked:=BOn;


      If (GetMultiSys(BOff,Locked,CISR)) then
      Begin
        Get_CISSuggest(VATStartD,VATEndD);

        I1TransDateF.DateValue:=VATStartD;
        I2TransDateF.DateValue:=VATEndD;

        If (FormIMode=0) then
        Begin
          I1TransDateF.Visible:=BOff;
          Label87.Visible:=BOff;
          I2TransDateF.Left:=I1TransDateF.Left;

        end
        else
          Self.HelpContext:=2203;

        If (CIS340) then
          cbSortLF.Items.Add('Statement Ref.')
        else
          cbSortLF.Items.Add(GetIntMsg(4)+' No.');

        If (CurrentCountry=IECCode) or (FormIMode<>0) then
        Begin
          Label85.Visible:=(FormIMode=1);
          V25PF.Visible:=(FormIMode=1);
          V25CF.Visible:=BOff;

          If (FormIMode=6) then
            Label82.Caption:='CIS24 Voucher Start No.'
          else
          Begin
            Label82.Caption:='RCTDC Certificate Start No.';
            Label81.Caption:='Aggregate Certificates by ';;

          end;

          Label83.Visible:=(FormIMode<>1);
          Label84.Visible:=Label83.Visible;
          Label82.Visible:=Label83.Visible;
          V23PF.Visible:=Label83.Visible;
          V23CF.Visible:=Label83.Visible;
          Label81.Visible:=Label83.Visible;
          cbAggcb.Visible:=Label83.Visible;


          cbCloseP.Visible:=(FormIMode=0);

          If (FormIMode=1) then
          Begin
            cbSortLF.Top:=V23PF.Top;
            cbSortLF.TabOrder:=V23PF.TabOrder;
            Label820.Top:=Label82.Top;
            Label85.Caption:='Filter';

            V25PF.MaxLength:=0;

            If (Length(V25PF.Text)=1) then
              V25PF.Text:='';

          end;
        end
        else
        Begin
          Label83.Visible:=(Not CIS340);
          Label84.Visible:=Label83.Visible;
          Label82.Visible:=Label83.Visible;
          Label85.Visible:=Label83.Visible;
          V23PF.Visible:=Label83.Visible;
          V23CF.Visible:=Label83.Visible;
          V25PF.Visible:=Label83.Visible;
          V25CF.Visible:=Label83.Visible;
          Label81.Caption:='Aggregate Statements by ';;
          SBSPanel4.HelpContext:=2177;
          cbSortLF.HelpContext:=2179;


        end;

        With CISVouchers[5-Ord(CurrentCountry=IECCode)+Ord(FormIMode=6)] do
        Begin
          V23PF.Text:=Prefix;
          V23CF.Text:=IntToStr(Counter);

        end;

        If (FormIMode<>1) then
          With CISVouchers[4] do
          Begin
            V25PF.Text:=Prefix;
            V25CF.Text:=IntToStr(Counter);

          end;

        cbSortLF.ItemIndex:=CISSortMode;
        cbAggcb.ItemIndex:=CISAggMode;
      end
      else
      Begin
        OKCP1Btn.Enabled:=BOff;
        ShowMessage('Another user has locked the CIS Setup screen. Please try again later.');

        PostMessage(Self.Handle,WM_Close,0,0);

      end;
    end;
  except
    Dispose(Self.CRepParam);
    Self.CRepParam:=nil;
  end;

  Case FormIMode of
    1  :  Caption:='View '+CCCISName^+' Ledger';
    6  :  Caption:='CIS 6/CIS24 '+Caption;
    else  Caption:=CCCISName^+Caption;
  end; {case..}


end;


procedure TCISVInp.Show_MyCISList;


Begin
  Show_CISList(Self.Owner,CRepParam^);


end;

Procedure TCISVInp.Show_Ledger;
Begin
  Show_MyCISList;

  ShutDown;

end;

Procedure TCISVInp.Finish_Thread;

Begin
  If (CRepParam^.CloseCIS) then
  With SyssCIS.CISRates do
  Begin

    CISReturnDate:=CurrPeriod;

    CurrPeriod:=Calc_NewCISPeriod(CISReturnDate,CISInterval);

  end; {With..}

  PutMultiSys(CISR,BOn); {Unlock Control record}

  Show_MyCISList;

  ShutDown;
end;

Procedure TCISVInp.WMCustGetRec(Var Message  :  TMessage);

Begin
  With Message do
  Begin


    Case WParam of

      65
         :  Begin
              Finish_Thread;
            end;


    end; {Case..}

  end; {With..}

  Inherited;

end;



procedure TCISVInp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

  If (SendCancel) then
    PostMessage(TForm(Owner).Handle,WM_FormCloseMsg,66,0);


end;


procedure TCISVInp.I2TransDateFExit(Sender: TObject);
begin
  inherited;

  cbCloseP.Enabled:=(I2TransDateF.DateValue=SyssCIS.CISRates.CurrPeriod);

  If (Not cbCloseP.Enabled) then
    cbCloseP.Checked:=BOff;
end;

procedure TCISVInp.cbSortLFChange(Sender: TObject);
begin
  inherited;

  If (FormIMode=1) then
    V25PF.Text:='';
end;

procedure TCISVInp.V25PFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin
  If (Sender is Text8pt) and (FormIMode=1)  then
  With (Sender as Text8pt) do
  Begin
    AltMod:=(Modified);

    FoundCode:=Strip('B',[#32],Text);



    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      Case cbSortLF.ItemIndex of
        0  :  FoundOk:=(GetJobMisc(Self,FoundCode,FoundCode,3,11));
        1  :  FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOff,3));
        2  :  FoundOk:=BOn;
      end; {Case..}

      If (FoundOk) then
      Begin
        Text:=FoundCode;


      end;

      If (Not FoundOk) then
      Begin
        SetFocus;
      end;
    end;
  end; {With..}

end; {Proc..}


procedure TCISVInp.OkCP1BtnClick(Sender: TObject);

Var
  Locked  :  Boolean;

begin
  Locked:=BOn;

  If (Sender=OkCP1Btn) then
  With Self.CRepParam^ do
  Begin
    if OKCP1Btn.CanFocus then
      OKCP1Btn.SetFocus;
    if (ActiveControl = OKCP1Btn) then
    begin
      If (FormIMode<>1) then
      Begin
         If (ChkVouchers(I1TransDateF.DateValue,I2TransDateF.DateValue,FormIMode+(4*Ord(FormIMode=0)))) then
           Locked:=(CustomDlg(Self,'Warning!',GetIntMsg(4)+'s Detected!',
                       GetIntMsg(4)+'s for this period already exist.'+#13+
                       'Running this procedure over the same period may affect any existing '+GetIntMsg(4)+'s.'+#13+#13+
                       'Please confirm you wish to continue.',
                       mtConfirmation,
                       [mbOK,mbCancel])=mrOK);
      end;


      If (Locked) then
      Begin

        OKCP1Btn.Enabled:=BOff;

        If (FormIMode=1) then
          VATStartD:=I1TransDateF.DateValue
        else
          VATStartD:=VATEndD;

        VATEndD:=I2TransDateF.DateValue;

        AllowEditCIS:=(VATEndD=SyssCIS^.CISRates.CurrPeriod);

        CloseCIS:=cbCloseP.Checked;
        CISGMode:=FormIMode;

        If (FormIMode=1) then
          VSig:=V25PF.Text;

        Locked:=BOn;


        If (GetMultiSys(BOn,Locked,CISR)) then
        With SyssCIS^.CISRates do
        Begin
          If (cbSortLF.ItemIndex>=0) then
            CISSortMode:=cbSortLF.ItemIndex;

          CISSMode:=CISSOrtMode;

          If (cbAggcb.ItemIndex>=0) then
            CISAggMode:=cbAggcb.ItemIndex;

          If (FormIMode<>1) then
          Begin
            With CISVouchers[4] do
            Begin
              Prefix:=V25PF.Text;

              If (V25CF.Text<>'') then
                Counter:=StrToInt64(V25CF.Text)
              else
                Counter:=0;

            end;

            With CISVouchers[5-Ord(CurrentCountry=IECCode)+Ord(FormIMode=6)] do
            Begin
              Prefix:=V23PF.Text;

              If (V23CF.Text<>'') then
                Counter:=StrToInt64(V23CF.Text)
              else
                Counter:=0;

            end;
          end;

          HasCISNdx:=UseV501CISNdx;



          PutMultiSys(CISR,(FormIMode=1));

          SendCancel:=BOff;
        end;

        Case FormIMode of
          1  :  Show_Ledger;
          else  AddCISScan2Thread(Owner,CRepParam^,Self.Handle,0);
        end; {Case..}

        Self.Enabled:=BOff;
      end; {If..}
    end;
  end {With..}
  else
  Begin
    // The Sys record was locked when this form was launched, so we must make
    // sure that it is unlocked. (CJS: this is my guess as to the intention of
    // the following code).
    Locked:=BOn;
    If (GetMultiSys(BOn,Locked,CISR)) then
      PutMultiSys(CISR,BOn);
    inherited;
  end;



end;




Initialization
  FMode:=0;

end.

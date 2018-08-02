unit BACS3U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, Animate, ExtCtrls, SBSPanel, StdCtrls, bkgroup, BTSupU1, Mask,
  TEditVal, VarConst, BTSupU3;

type
  TBatchRunInp = class(TRepInpMsg)
    Label84: Label8;
    I1PrYrF: TEditPeriod;
    Label87: Label8;
    I1TransDateF: TEditDate;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure I1TransDateFExit(Sender: TObject);
    function I1PrYrFConvDate(Sender: TObject; const IDate: String;
      const Date2Pr: Boolean): String;
    function I1PrYrFShowPeriod(Sender: TObject; const EPr: Byte): String;
  private
    { Private declarations }
    FormRepPtr :  PFormRepPtr;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;


  public
    { Public declarations }

    BatchCtrl  :  PassWordRec;
    ReRun      :  Boolean;

  end;

procedure BACSCtrl(OReRun   :  Boolean;
                   BCtrl    :  PassWordRec;
                   AOwner   :  TComponent);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  // NF: 23/10/06
  {$IFDEF CU}
    CustWinU,
    ExWrap1U,
  {$ENDIF}
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  SysU1,
  SysU2,

  PrintFrm,
  BACS2U,
  BPyItemU,
  Event1U,
  BTSupU2;

{$R *.DFM}






procedure TBatchRunInp.FormCreate(Sender: TObject);

Var
  LPr,LYr  :  Byte;

begin
  inherited;
  ClientHeight:=144;
  ClientWidth:=299;


  New(FormRepPtr);

  FillChar(FormRepPtr^,Sizeof(FormRepPtr^),0);

  With FormRepPtr^,PParam do
  Begin
    PBatch:=BOn;
    RForm:=SyssForms.FormDefs.PrimaryForm[5];
  end;


  LPr:=GetLocalPr(0).CPr;
  LYr:=GetLocalPr(0).CYr;

  I1PrYrF.InitPeriod(LPr,LYr,BOn,BOn);

  I1TransDateF.DateValue:=Today;

  I1TransDateFExit(Nil);

  SetLastValues;
end;

procedure TBatchRunInp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  Dispose(FormRepPtr);
end;



Procedure TBatchRunInp.WMCustGetRec(Var Message  :  TMessage);

Begin
  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      55  :  Begin
               OKCp1Btn.Enabled:=BOn;

               SendMessage(TForm(Owner).Handle,WM_CustGetRec,56,0);

               ShutDown;
             end; {Start List}
    end; {Case..}
  end;
end;


procedure TBatchRunInp.I1TransDateFExit(Sender: TObject);
Var
  LPr,LYr  :  Byte;
  LocalDate:  LongDate;

begin
  LPr:=GetLocalPr(0).CPr;  LYr:=GetLocalPr(0).CYr;
  
  With I1TransDateF do
  {$B-}

    If (ActiveControl<>ClsCP1Btn) and (ValidDate(DateValue)) then

  {$B+}
    Begin
      LocalDate:=DateValue;

      If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
      With I1PrYrF do
      Begin
        Date2Pr(LocalDate,LPr,LYr,nil);

        InitPeriod(LPr,LYr,BOn,BOn);
      end;

    end;

end;


function TBatchRunInp.I1PrYrFConvDate(Sender: TObject; const IDate: String;
  const Date2Pr: Boolean): String;
begin
  inherited;
  Result:=RepInpConvInpPr(IDate,Date2Pr);
end;

function TBatchRunInp.I1PrYrFShowPeriod(Sender: TObject;
  const EPr: Byte): String;
begin
  inherited;
  Result:=RepInpPPr_Pr(EPr);
end;

procedure TBatchRunInp.OkCP1BtnClick(Sender: TObject);

  // NF: 23/10/06
  {$IFDEF CU}
    procedure HookProcessBatchSalesReceipts;
    var
      ExLocal : TdExLocal;
    begin{HookProcessBatchSalesReceipts}
      ExLocal.Create;
      Try
        GenHooks(wiBACS - EnterpriseBase, 176, ExLocal); // 102050.176
      finally
        ExLocal.Destroy;
      end;{try}
    end;{HookProcessBatchSalesReceipts}
 {$ENDIF}

Var
  Ok2Print  :  Boolean;

begin
  Ok2Print:=BOff;

  If (Sender=OkCP1Btn) then
  With BatchCtrl.BACSCRec do
  Begin

    I1PrYrF.InitPeriod(TagRunPr,TagRunYr,BOff,BOff);
    TagRunDate:=I1TransDateF.DateValue;

    With FormRepPtr^,PParam do
    Begin
      If SalesMode then
        RForm:=SyssForms.FormDefs.PrimaryForm[14]
      else
        RForm:=SyssForms.FormDefs.PrimaryForm[5];

        PDevRec.feBatch:=BOn;

        PDevRec.feTypes:=14; {* Hide Fax/Email/XML tabes in this mode *}


      Ok2Print:=pfSelectFormPrinter(PDevRec,BOn,RForm,UFont,Orient);
    end;

    If (Ok2Print) then
    Begin

      // NF: 23/10/06
      {$IFDEF CU}
        if BatchCtrl.BACSCRec.SalesMode
        then HookProcessBatchSalesReceipts;
      {$ENDIF}

      OkCp1Btn.Enabled:=BOff;
      ClsCp1Btn.Enabled:=BOff;

      BACS_CtrlPut(PWrdF,PWK,BatchCtrl,Nil,0);

      AddBACSPay2Thread(Self,BatchCtrl,ReRun,BatchCtrl.BACSCRec.SalesMode,FormRepPtr,Self.Handle);

      Enabled:=BOff;
    end
  end;

  If (Not Ok2Print) then
  Begin
    SendMessage(TForm(Owner).Handle,WM_CustGetRec,55,0);

    inherited;
  end;

end;


procedure BACSCtrl(OReRun   :  Boolean;
                   BCtrl    :  PassWordRec;
                   AOwner   :  TComponent);

Var
  RepInpMsg1  :  TBatchRunInp;

Begin

  RepInpMsg1:=TBatchRunInp.Create(AOwner);

  try
    With RepInpMsg1 do
    Begin
      BatchCtrl:=BCtrl;
      ReRun:=OReRun;
    end;
  except;
    RepInpMsg1.Free;
  end;

end;






end.


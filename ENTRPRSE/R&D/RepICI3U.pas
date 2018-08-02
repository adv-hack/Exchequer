unit RepICI3U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, ExtCtrls, BTSupU3, bkgroup, BorBtns, TEditVal, Mask,
  Animate, SBSPanel;

type
  TRepJCCISYInp = class(TRepInpMsg)
    Label83: Label8;
    SxSF: TSBSComboBox;
    Label86: Label8;
    I1TransDateF: TEditDate;
    Label87: Label8;
    I2TransDateF: TEditDate;
    V25PF: Text8Pt;
    Label85: Label8;
    Label81: Label8;
    cbDetail: TSBSComboBox;
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure V25PFExit(Sender: TObject);
  private
    { Private declarations }  private
    { Private declarations }
    RepMode    :  Byte;

    CRepParam  :  JobCRep1Ptr;

  public
    { Public declarations }
  end;


procedure SubCEOYList_Report(IDMode  :  Byte;
                             AOwner  :  TComponent);



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  VarConst,
  VarJCstU,
  BTKeys1U,
  RepJCE2U,

  RepJCE3U,

  JChkUseU,
  JobSup1U,
  IntMU,
  InvListU,
  SysU1,
  SysU2,
  BTSupU2;


{$R *.DFM}


Var
  EOYRNo     :  Byte;
  SetEOYLV   :  Boolean;


procedure TRepJCCISYInp.FormCreate(Sender: TObject);

Var
  n       :  Integer;

  SDate,
  EDate   :  LongDate;


begin
  inherited;

  ClientHeight:=175;
  ClientWidth:=343;


  RepMode:=EOYRNo;

  If (RepMode<>22) then
    Label83.Caption:=GetIntMsg(4)+Label83.Caption;

  Calc_CISEOYRange(SDate,EDate,(RepMode<>20));

  I1TransDateF.DateValue:=SDate;
  I2TransDateF.DateValue:=EDate;

  Case RepMode of
    20,21 ,22
       :  Begin
            If (CurrentCountry=IECCode) or (RepMode=22) then
            Begin
              With SxSF do
              Begin
                With Items do
                Begin
                  Clear;
                  Add('All');
                  Add(CISVTypeName(4));
                  Add(CISVTypeName(5));
                end;
              end; {With..}
            end; {If..}

          end;

  end; {Case..}


  SxSF.ItemIndex:=0;

  cbDetail.ItemIndex:=0;

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  If (SetEOYLV) then
    SetLastValues;

end;

procedure TRepJCCISYInp.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;


procedure TRepJCCISYInp.V25PFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin
  If (Sender is Text8pt)  then
  With (Sender as Text8pt) do
  Begin
    AltMod:=(Modified);

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOff,3));

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

procedure TRepJCCISYInp.OkCP1BtnClick(Sender: TObject);

Var
  RunCIS340  :  Boolean;

begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^ do
      Begin
        OKCP1Btn.Enabled:=BOff;

        RepSDate:=I1TransDateF.DateValue;
        RepEDate:=I2TransDateF.DateValue;

        RunCIS340:=(RepMode=22);

        If (cbDetail.ItemIndex>0) then
          SortOrd:=cbDetail.ItemIndex;

        If (CurrentCountry=IECCode) or (RepMode=22) then
          Case SxSF.ItemIndex of
            1  :  RepType:=4;
            2  :  RepType:=5;
            else  RepType:=99;
          end {Case..}
        else
          Case SxSF.ItemIndex of
            1  :  RepType:=5;
            2  :  RepType:=6;
            3  :  RepType:=4;
            else  RepType:=99;
          end; {Case..}

        ShowER:=(SortOrd=2);

        If (SortOrd>0) then
          RepMode:=25
          else
            If (RepMode=22) then
              RepMode:=20;

        JobFilt:=FullCustCode(V25PF.Text);

        If (RunCIS340) then
          AddCISListRep3Thread(RepMode,CRepParam,Owner)
        else
          AddCISListRep2Thread(RepMode,CRepParam,Owner);
      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;



procedure SubCEOYList_Report(IDMode  :  Byte;
                             AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepJCCISYInp;

  Begin
    SetEOYLV:=(EOYRNo=IDMode);

    EOYRNo:=IdMode;

    RepInpMsg1:=TRepJCCISYInp.Create(AOwner);

  end;




Initialization

  EOYRNo:=0;
  SetEOYLV:=BOff;

end.

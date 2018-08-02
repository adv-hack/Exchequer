unit PrgeAllU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Genentu, StdCtrls, ANIMATE, ExtCtrls, SBSPanel, bkgroup, ComCtrls, UnTils,
    SpeF3U, TEditVal, BorBtns, Mask;

type
  TPurgeDataI = class(TTestCust)
    Label2: TLabel;
    Label81: Label8;
    ShrinkF: TBorCheck;
    PrgYrF: TCurrencyEdit;
    RemCustF: TBorCheck;
    RemSuppF: TBorCheck;
    RemStkF: TBorCheck;
    RemLocF: TBorCheck;
    RemSnoF: TBorCheck;
    UpDown1: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure PrgYrFExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }

    procedure Form2PurgeO;
    procedure OutPurgeO;

    Function ValidPurgeYr(BackYr  :  Double)  :  Boolean;

    Procedure WMCustGetRec(Var Message  :  TMessage);  Message WM_CustGetRec;


  public
    { Public declarations }

    procedure ShowBar(Waiting  :  Boolean);


  end;


implementation

Uses
  GlobVar,
  VarConst,
  BtrvU2,
  ETStrU,
  ETMiscU,
  ETDateU,
  PurgeOU,
  Purge1U,
  ReBuildU,
  ReBuld1U,
  ReBuld2U,
  ProgU;

{$R *.DFM}

procedure TPurgeDataI.FormCreate(Sender: TObject);

Var
  n        :  Integer;
  SLocked  :  Boolean;

begin
  inherited;
  SLocked:=BOff;

  Animated1.Play:=False;
  Animated1.visible:=BOff;
  SBSPanel1.Visible:=BOff;

  ClientHeight:=240;
  ClientWidth:=395;

  FixFile[SysF].Rebuild:=BOn;

  Open_RepairFiles(SysF,SysF,BOn,BOff,ProgBar); {* Open all files and check for a Rebuild header *}

  GetMultiSys(BOn,SLocked,SysR);

  OutPurgeO;


end;



procedure TPurgeDataI.OutPurgeO;

Var SuggYear  :  Byte;

Begin
  With Purge_OrdRec^ do
  Begin
    SuggYear:=Syss.auditYr;

    If (SuggYear=0) then
      SuggYear:=AdjYr(Syss.CYr,BOff);

    PrgYrF.Value:=TxlateYrVal(SuggYear,BOff);
    UpDown1.Position:=Round(PrgYrF.Value);
    RemCustF.Checked:=DelCust;
    RemSuppF.Checked:=DelSupp;
    RemStkF.Checked:=DelStk;
    RemLocF.Checked:=DelML;
    RemSnoF.Checked:=DelSN;
    ShrinkF.Checked:=BOn;
  end; {With..}
end;


procedure TPurgeDataI.Form2PurgeO;

Begin
  With Purge_OrdRec^ do
  Begin
    PurgeYr:=TxlateYrVal(Round(PrgYrF.Value),BOn);
    DelCust:=RemCustF.Checked;
    DelSupp:=RemSuppF.Checked;
    DelStk:=RemStkF.Checked;
    DelML:=RemLocF.Checked;
    DelSN:=RemSnoF.Checked;

    RunRBuild:=ShrinkF.Checked;
  end; {With..}
end;


Procedure TPurgeDataI.WMCustGetRec(Var Message  :  TMessage);

Begin
  With Message do
  Begin


    Case WParam of

      10 :  Purge_Control(ProgBar);


      11 :  ;



      else  Inherited;

    end; {Case..}

  end; {With..}


end;



procedure TPurgeDataI.ShowBar(Waiting  :  Boolean);

Var
  n  :  Integer;

Begin
  Animated1.Play:=False;

  Form2PurgeO;
{
  ProgBar:=TGenProg.Create(Self);

  try
    With ProgBar do
    Begin


      ShowModal;

    end;

  finally
    ProgBar.Free;

  end;
}
    SendMessage(Self.Handle,WM_Close,0,0);

end;


procedure TPurgeDataI.OkCP1BtnClick(Sender: TObject);
Var
  mbRet    :  Word;

begin
  Form2PurgeO;

  If ValidPurgeYr(Purge_OrdRec^.PurgeYr) then
  Begin
    mbRet:=MessageDlg('WARNING!'+#13+'Purging data will destroy it.'+#13+'Please confirm you wish to Purge the Account Data',mtConfirmation, [mbYes, mbNo], 0);

    If (mbRet=mrYes) then
      ShowBar(BOff);
  end;


end;

procedure TPurgeDataI.ClsCP1BtnClick(Sender: TObject);
begin
  inherited;
  SendMessage(Self.Handle,WM_Close,0,0);
end;

Function TPurgeDataI.ValidPurgeYr(BackYr  :  Double)  :  Boolean;


Begin
  Result:=((BackYr>=Syss.AuditYr) and (BackYr<Syss.CYr));

  If (Not Result) then
    ShowMessage('The purge year must be after '+Form_Int(Syss.PrInYr,0)+'/'+FullYear(Syss.AuditYr)+
                              ' and before '+Form_Int(Syss.PrInYr,0)+'/'+FullYear(Syss.CYr));

end;

procedure TPurgeDataI.PrgYrFExit(Sender: TObject);
Var
  FoundCode  :  Str20;
  FoundValue :  Double;
  KeyS       :  Str255;
  FoundOk,
  AltMod     :  Boolean;


begin
  Inherited;

  If (Sender is TCurrencyEdit) and (ActiveControl<>ClsCP1Btn) then
  With (Sender as TCurrencyEdit) do
  Begin
    AltMod:=Modified;

    FoundValue:=TxlateYrVal(Round(Value),BOn);

    FoundOk:=ValidPurgeYr(FoundValue);

    If (Not FoundOk) then
    Begin
      SetFocus;
    end; {If not found..}

  end; {with..}
end;

procedure TPurgeDataI.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  Close_Files(BOn);

  FixFile[SysF].Rebuild:=BOff;


end;

end.

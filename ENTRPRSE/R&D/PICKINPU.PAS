unit PickInpU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, Animate, ExtCtrls, SBSPanel, StdCtrls, bkgroup, BTSupU3,
  BorBtns, Mask, TEditVal,
  GlobVar,VarConst;


type
  TPickInpMsg = class(TRepInpMsg)
    Label87: Label8;
    I1TransDateF: TEditDate;
    Sum2: TBorCheck;
    Sum3: TBorCheck;
    Sum4: TBorCheck;
    Sum5: TBorCheck;
    Label83: Label8;
    ACFF: Text8Pt;
    Sum6: TBorCheck;
    Sum1: TCurrencyEdit;
    Label81: Label8;
    Label82: Label8;
    IncAllBins: TBorCheck;
    ExcNPick1: TBorCheck;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
  private
    PrevHState :  Boolean;
    SOPInp   :  SOPInpRec;
    DocHed   :  DocTypes;
    CRepParam  :  PPickRepPtr;
    procedure SetHelpContextIDs; // NF: 11/05/06
  public
    { Public declarations }
  end;




procedure Start_PickRun(IDMode  :  DocTypes;
                        AOwner  :  TComponent);

Var
  RDocHed  :  DocTypes;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  RPDefine,
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,

  {$IFDEF FRM}
    PrintFrm,
    PickRunU,
  {$ENDIF}

  SOPCT2U,

  BTKeys1U,
  SysU2,
  BTSupU1,
  BTSupU2,
  ComnUnit,
  InvListU,
  Exthrd2U;



{$R *.DFM}







procedure TPickInpMsg.FormCreate(Sender: TObject);


begin
  inherited;

  ClientHeight:=229;
  ClientWidth:=299;

  PrevHState:=BOff;

  New(CRepParam);

  DocHed:=RDocHed;

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);

    With CRepParam^.PParam do
    Begin
      PBatch:=BOn;
      PDevRec.Preview:=BOn;
      PDevRec.NoCopies:=1;
      Orient:=poPortrait;
      UFont:=Nil;
      RepCaption:='Picking List';
    end;
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  If (Not Get_LastSOPVal(FullSOPFile(AllocTCode,AllocSCode,1),SOPInp)) then
  Begin

    Init_SOPInp(SOPInp);

  end;


  If (Not UseEMLocStk) then
  Begin
    AcFF.Visible:=BOff;
    Label83.Visible:=BOff;
  end;

  With SOPInp do
  Begin
    I1TransDateF.DateValue:=PickUDate;

    Sum1.Value:=PickTag;
    Sum2.Checked:=PickAuto;
    Sum3.Checked:=PickSing;
    Sum4.Checked:=PickCon;
    Sum5.Checked:=PickEBOM;
    Sum6.Checked:=PickExc;
    AcFF.Text:=SOPMLoc;
    IncAllBins.Checked:=ShowAllBins;

    ExcNPick1.Visible:=BOn;
    ExcNPick1.Checked:=ExcNonPick;
    Animated1.Play:=BOff;
    Animated1.Visible:=BOff;

  end; {With..}

  SetHelpContextIDs; // NF: 11/05/06 Fix for incorrect Context IDs

end;


procedure TPickInpMsg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

end;


procedure TPickInpMsg.ACFFExit(Sender: TObject);
Var
  FoundCode  :  Str10;

  FoundOk,
  AltMod     :  Boolean;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    FoundCode:=Name;

    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If (AltMod) and (ActiveControl<>ClsCP1Btn)  and (FoundCode<>'') then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetMLoc(Self.Owner,FoundCode,FoundCode,'',0));

      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=FoundCode;

      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;

procedure TPickInpMsg.OkCP1BtnClick(Sender: TObject);

Var
  TStr  :  Str10;

  {$IFDEF FRM}

    MsgForm  :  TPickRunFrm;

  {$ENDIF}

begin
  If (Sender=OkCP1Btn) then
  With CRepParam^,PParam,SopInp do
  Begin

    PickUDate:=I1TransDateF.DateValue;

    PickTag:=Round(Sum1.Value);
    PickAuto:=Sum2.Checked;
    PickSing:=Sum3.Checked;
    PickCon:=Sum4.Checked;
    PickEBOM:=Sum5.Checked;
    PickExc:=Sum6.Checked;
    ShowAllBins:=IncAllBins.Checked;

    ExcNonPick:=ExcNPick1.Checked;

    SOPMLoc:=AcFF.Text;

    PSopInp:=SopInp;

    {$IFDEF FRM}

      TStr:=SyssForms.FormDefs.PrimaryForm[17+Ord(Sum3.Checked)];


      If (pfSelectFormPrinter(PDevRec,BOn,TStr,UFont,Orient)) then
      Begin
        MsgForm:=TPickRunFrm.Create(Self);

        try
          With MsgForm do
          Begin
            PCRepParam:=CRepParam;
            PDocHed:=DocHed;
            PickFDForm:=TStr;

            SetAllowHotKey(BOff,PrevHState);

            Set_BackThreadMVisible(BOn);

            ShowModal;

            Set_BackThreadMVisible(BOff);

            SetAllowHotKey(BOn,PrevHState);

          end;

        Finally
          MsgForm.Free;
        end; {try..}
      end;
    {$ENDIF}

  end;

  inherited;

end;

// NF: 11/05/06 Fix for incorrect Context IDs
procedure TPickInpMsg.SetHelpContextIDs;
begin
  Sum1.HelpContext := 474;
end;

procedure Start_PickRun(IDMode  :  DocTypes;
                        AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TPickInpMsg;

  Begin
    RDocHed:=IDMode;

    RepInpMsg1:=TPickInpMsg.Create(AOwner);

  end;





end.

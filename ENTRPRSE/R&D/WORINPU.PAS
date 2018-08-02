unit WORInpU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, Animate, ExtCtrls, SBSPanel, StdCtrls, bkgroup, BTSupU3,
  BorBtns, Mask, TEditVal,
  GlobVar,VarConst;


type
  TWORIssMsg = class(TRepInpMsg)
    Sum3: TBorCheck;
    Sum4: TBorCheck;
    Label83: Label8;
    ACFF: Text8Pt;
    Sum6: TBorCheck;
    Sum1: TCurrencyEdit;
    Label81: Label8;
    Label82: Label8;
    Sum2: TBorCheck;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
  private
    { Private declarations }
    PrevHState
             :  Boolean;
    SOPInp   :  SOPInpRec;
    DocHed   :  DocTypes;

  private
    { Private declarations }
    CRepParam  :  PPickRepPtr;

  public
    { Public declarations }
  end;




procedure Start_WORPickRun(IDMode  :  DocTypes;
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
    WORPickU,
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







procedure TWORIssMsg.FormCreate(Sender: TObject);


begin
  inherited;

  ClientHeight:=191;
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
      RepCaption:='Works Order Pick List';
    end;
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  If (Not Get_LastSOPVal(FullSOPFile(AllocTCode,AllocSCode,80),SOPInp)) then
  Begin

    Init_SOPInp(SOPInp);

  end;


  {$IFDEF SOP}
    If (Not UseEMLocStk) then
  {$ENDIF}
    
  Begin
    AcFF.Visible:=BOff;
    Label83.Visible:=BOff;
  end;

  With SOPInp do
  Begin
    Sum1.Value:=PickTag;
    Sum2.Checked:=PickAuto;
    Sum3.Checked:=PickSing;
    Sum4.Checked:=PickCon;
    Sum6.Checked:=PickExc;
    AcFF.Text:=SOPMLoc;

  end; {With..}


end;


procedure TWORIssMsg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

end;


procedure TWORIssMsg.ACFFExit(Sender: TObject);
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

      {$IFDEF SOP}
        FoundOk:=(GetMLoc(Self.Owner,FoundCode,FoundCode,'',0));
      {$ENDIF}

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

procedure TWORIssMsg.OkCP1BtnClick(Sender: TObject);

Var
  TStr  :  Str10;

  {$IFDEF FRM}

    MsgForm  :  TWOPPickFrm;

  {$ENDIF}

begin
  If (Sender=OkCP1Btn) then
  With CRepParam^,PParam,SopInp do
  Begin

    PickTag:=Round(Sum1.Value);
    PickAuto:=Sum2.Checked;
    PickSing:=Sum3.Checked;
    PickCon:=Sum4.Checked;
    PickExc:=Sum6.Checked;

    SOPMLoc:=AcFF.Text;

    PSopInp:=SopInp;

    {$IFDEF FRM}
                                           
      TStr:=SyssForms.FormDefs.PrimaryForm[50+Ord(Sum3.Checked)];


      If (pfSelectFormPrinter(PDevRec,BOn,TStr,UFont,Orient)) then
      Begin
        MsgForm:=TWOPPickFrm.Create(Self);

        try
          With MsgForm do
          Begin
            PCRepParam:=CRepParam;
            PDocHed:=DocHed;

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


procedure Start_WORPickRun(IDMode  :  DocTypes;
                        AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TWORIssMsg;

  Begin
    RDocHed:=IDMode;

    RepInpMsg1:=TWORIssMsg.Create(AOwner);

  end;





end.

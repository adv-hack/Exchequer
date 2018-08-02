unit RepIJCIU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, BorBtns, StdCtrls, TEditVal, Mask, ExtCtrls, BTSupU3, bkgroup,
  Animate, SBSPanel;

type
  TRepJCIInp = class(TRepInpMsg)
    ACFF: Text8Pt;
    Label810: Label8;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
  private
    { Private declarations }

    CRepParam  :  JobCRep1Ptr;

  public
    { Public declarations }
    RepMode    :  Byte;

  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  VarConst,
  BTKeys1U,
  InvListU,
  RepJCB2U,
  SysU1,
  SysU2,
  BTSupU2;


{$R *.DFM}



procedure TRepJCIInp.FormCreate(Sender: TObject);



begin
  inherited;

  ClientHeight:=197;
  ClientWidth:=356;



  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  SetLastValues;
end;

procedure TRepJCIInp.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;


procedure TRepJCIInp.ACFFExit(Sender: TObject);

Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetJob(Self,FoundCode,FoundCode,99));


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




procedure TRepJCIInp.OkCP1BtnClick(Sender: TObject);
Begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^ do
      Begin
        OKCP1Btn.Enabled:=BOff;

        JobFilt:=AcFF.Text;

        StkDetl:=(Not EmptyKey(JobFilt,JobKeyLen)) and (JobRec^.JobType<>JobGrpCode);


        AddJBillRep2Thread(RepMode,CRepParam,Owner);
      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;


end.

unit JAPstIpU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, Animate, ExtCtrls, SBSPanel, StdCtrls, bkgroup, TEditVal,
  BorBtns,
  VarConst,
  JobSup2U,
  JobPAppU, ComCtrls, Mask;


type
  TJPostAppFilt = class(TRepInpMsg)
    PCOMChk: TBorCheck;
    PJDChk: TBorCheck;
    PTSChk: TBorCheck;
    Label86: Label8;
    Label81: Label8;
    Sum1: TCurrencyEdit;
    ACFF: Text8Pt;
    AccLab: Label8;
    EmpF: Text8Pt;
    Label82: Label8;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ACFFClick(Sender: TObject);
    procedure EmpFExit(Sender: TObject);
  private
    { Private declarations }
    JPostCtrl  :  tJAppWizRec;

  public
    { Public declarations }

  end;


procedure JAPPrePostInput(AOwner  :  TComponent;
                          PMode   :  DocTypes;
                          AGMode  :  Boolean);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,

  BTKeys1U,
  BTrvU2,
  BTSupU1,
  BTSupU2,
  InvListU,
  GenWarnU;

{$R *.DFM}



procedure TJPostAppFilt.FormCreate(Sender: TObject);
begin

  inherited;
  ClientHeight:=268;
  ClientWidth:=301;

  SBSPanel1.Visible:=BOff;
  Animated1.Play:=BOff;

  FillChar(JPostCtrl,Sizeof(JPostCtrl),0);


end;


procedure TJPostAppFilt.ACFFClick(Sender: TObject);
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

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,(JPostCtrl.awDT=JSA),99));


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


procedure TJPostAppFilt.EmpFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  mbRet      :  Word;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
    Begin

      FoundOk:=(GetJobMisc(Self,FoundCode,FoundCode,3,11));
      
      If (FoundOk) then
      Begin

        Text:=FoundCode;


      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;

procedure TJPostAppFilt.OkCP1BtnClick(Sender: TObject);

Var
  SMode  :  Byte;

begin
  If (Sender=OKCP1Btn) then
  Begin

    With JPostCtrl do
    Begin
      awConsolidate:=PCOmChk.Checked;
      awPrintInv:=PJDChk.Checked;
      awPrintCert:=PTSChk.Checked;
      awTagNo:=Trunc(Sum1.Value);
      awACode:=ACFF.Text;
      awECode:=EmpF.Text;
      SMode:=50+(4*Ord(awAggregate));

    end;

    AddJobPostApp2Thread(Self.Owner,SMode,JPostCtrl,TWinControl(Self.Owner).Handle);
  end;

  inherited;

end;


procedure JAPPrePostInput(AOwner  :  TComponent;
                          PMode   :  DocTypes;
                          AGMode  :  Boolean);

Var
  RepInpMsg1  :  TJPostAppFilt;

Begin

  RepInpMsg1:=TJPostAppFilt.Create(AOwner);

  Try
    With RepInpMsg1 do
    Begin
      JPostCtrl.awDT:=PMode;
      JPostCtrl.awAggregate:=AGMode;

      If (PMode=JSA) then
      Begin
        EmpF.Visible:=BOff;
        Label82.Visible:=BOff;

        
      end;

      If (AGMode) then
      Begin
        ACFF.Visible:=BOff;
        AccLab.Visible:=BOff;
        PComChk.Checked:=BOn;
        PComChk.Enabled:=BOff;
        PJDChk.Visible:=BOff;
        PTSChk.Visible:=BOff;
        Label82.Visible:=BOff;
        EmpF.Visible:=BOff;
        Caption:='Aggregate Tagged Applications';
        Label86.Caption:='Aggregate Applications';


      end;
    end;
  except

  end; {Try..}

end;




end.

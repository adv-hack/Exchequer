unit JCCstmWU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, Animate, ExtCtrls, SBSPanel, StdCtrls, bkgroup, TEditVal,
  BorBtns,
  GlobVar,
  VarConst,
  JobSup1U, ComCtrls, Mask;


type
  TJCustomTag = class(TRepInpMsg)
    PJDChk: TBorCheck;
    Label86: Label8;
    I1TransDateF: TEditDate;
    Label87: Label8;
    I2TransDateF: TEditDate;
    Label810: Label8;
    AgeInt: TCurrencyEdit;
    SubCF: Text8Pt;
    Label81: Label8;
    AccLab: Label8;
    ACFF: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure SubCFExit(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
  private
    { Private declarations }
    JPostCtrl  :  JInvHedRec;
    JobR       :  JobRecType;

  public
    { Public declarations }
    SMode  :  Byte;
  end;


procedure JCCustmTagInput(AOwner  :  TComponent;
                          PMode   :  Byte;
                          JR      :  JobRecType;
                          JCtrl   :  JInvHedRec);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BTKeys1U,
  BTrvU2,
  BTSupU1,
  BTSupU2,
  InvListU,

  JobPostU,

  GenWarnU;

{$R *.DFM}



procedure TJCustomTag.FormCreate(Sender: TObject);
begin

  inherited;
  ClientHeight:=208;
  ClientWidth:=301;

  SBSPanel1.Visible:=BOff;
  Animated1.Play:=BOff;

  FillChar(JPostCtrl,Sizeof(JPostCtrl),0);

  I1TransDateF.DateValue:='19900101';
  I2TransDateF.DateValue:=Today;

  SMode:=23;
end;


procedure TJCustomTag.SubCFExit(Sender: TObject);
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

      StillEdit:=BOn;

      FoundOk:=(GetJobMisc(Self,FoundCode,FoundCode,3,0));



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


procedure TJCustomTag.ACFFExit(Sender: TObject);
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

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOff,99));


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


procedure TJCustomTag.OkCP1BtnClick(Sender: TObject);


begin
  If (Sender=OKCP1Btn) then
  Begin

    With JPostCtrl do
    Begin
      WIPSDate:=I1TransDateF.DateValue;
      WIPEDate:=I2TransDateF.DateValue;
      WIPPTarget:=Round_up(AgeInt.Value,2);
      WIPEmpFilt:=SubCF.Text;
      WIPAccFilt:=AcFF.Text;

      WIPReset:=PJDChk.Checked;
    end;

    AddJobPost2Thread(Self.Owner,SMode,JobR.JobCode,@JPostCtrl,TWinControl(Self.Owner).Handle);
  end;

  inherited;

end;


procedure JCCustmTagInput(AOwner  :  TComponent;
                          PMode   :  Byte;
                          JR      :  JobRecType;
                          JCtrl   :  JInvHedRec);

Var
  RepInpMsg1  :  TJCustomTag;

Begin

  RepInpMsg1:=TJCustomTag.Create(AOwner);

  Try
    With RepInpMsg1 do
    Begin
      SMode:=PMode;
      JPostCtrl:=JCtrl;
      JobR:=Jr;

      With JobR do
        Caption:=Caption+' for '+dbFormatName(JobCode,JobDesc);
    end;
  except

  end; {Try..}

end;






end.

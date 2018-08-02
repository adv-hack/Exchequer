unit JAPValIU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, Animate, ExtCtrls, SBSPanel, StdCtrls, bkgroup, TEditVal,
  BorBtns,
  GlobVar,
  VarConst,
  JobSup2U,
  JobPAppU, ComCtrls, Mask;


type
  TJGenValFilt = class(TRepInpMsg)
    PCOMChk: TBorCheck;
    Label86: Label8;
    Label81: Label8;
    Roundcb: TSBSComboBox;
    Label82: Label8;
    PJDChk: TSBSComboBox;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
  private
    { Private declarations }
    JPostCtrl  :  tJAppWizRec;

  public
    { Public declarations }
    SMode  :  Byte;
  end;


procedure JAPGenValInput(AOwner  :  TComponent;
                         PMode   :  Byte;
                         JCode   :  Str10);

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
  GenWarnU;

{$R *.DFM}



procedure TJGenValFilt.FormCreate(Sender: TObject);
begin

  inherited;
  ClientHeight:=208;
  ClientWidth:=301;

  SBSPanel1.Visible:=BOff;
  Animated1.Play:=BOff;

  PJDChk.ItemIndex:=0;
  
  FillChar(JPostCtrl,Sizeof(JPostCtrl),0);

  SMode:=52;
end;


procedure TJGenValFilt.OkCP1BtnClick(Sender: TObject);


begin
  If (Sender=OKCP1Btn) then
  Begin

    With JPostCtrl do
    Begin
      awValAct:=PJDChk.ItemIndex;
      awIntReverse:=PComChk.Checked;
      awTagNo:=Roundcb.ItemIndex
    end;

    AddJobPostApp2Thread(Self.Owner,SMode,JPostCtrl,TWinControl(Self.Owner).Handle);
  end;

  inherited;

end;


procedure JAPGenValInput(AOwner  :  TComponent;
                         PMode   :  Byte;
                         JCode   :  Str10);

Var
  RepInpMsg1  :  TJGenValFilt;

Begin

  RepInpMsg1:=TJGenValFilt.Create(AOwner);

  Try
    With RepInpMsg1 do
    Begin
      SMode:=PMode;
      JPostCtrl.awJobCode:=JCode;

      If (SMode=52) then
      Begin
        PJDChk.Visible:=BOff;
        Label82.Visible:=BOff;
      end
      else
        Label86.Caption:='...from Expenditure';

    end;
  except

  end; {Try..}

end;




end.

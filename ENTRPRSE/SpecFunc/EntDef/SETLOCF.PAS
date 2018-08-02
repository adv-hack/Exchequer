unit SetLocF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Genentu, StdCtrls, ANIMATE, ExtCtrls, SBSPanel, bkgroup, ComCtrls, UnTils,
  CheckLst, TEditVal, Mask;

type
  TSetLocFrm = class(TTestCust)
    Label2: TLabel;
    LastTriNom: Text8Pt;
    Label81: Label8;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure LastTriNomExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }


    Function Valid_Location(LocNo  :  String)  :  Boolean;

    Function Gen_Summary  :  String;

  public
    { Public declarations }
    LocCode   :  String;


  end;



Function Get_Location(Var  LocRef  :  String)  :  Boolean;


implementation

Uses
  GlobVar,
  VarConst,
  VarRec2U,
  VarFPosU,
  ETStrU,
  BtrvU2,
  ProgU,
  ReBuld2U,
  ReBuld1U;

{$R *.DFM}




procedure TSetLocFrm.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  inherited;
  ClientHeight:=209;
  ClientWidth:=412;

  LocCode:='';

end;

Function TSetLocFrm.Valid_Location(LocNo  :  String)  :  Boolean;

Var
  KeyS  :  String;
Begin
  Result:=(Trim(LocNo)<>'');

  If (Result) then
  Begin
    KeyS:=CostCCode+CSubCode[BOn]+UpCaseStr(LJVar(LocNo,3));


    Result:=(CheckRecExsists(UpCaseStr(KeyS),MLocF,MLK));

    If (Result) then
    Begin
      LocCode:=LJVar(LocNo,3);
    end
    else
    Begin
      ShowMessage(Trim(LocNo)+' is not a valid Location.');

      LocCode:='';
    end;
  end
  else
  Begin
    ShowMessage('You must specify a valid Location.');

    LocCode:='';
  end;

end;



procedure TSetLocFrm.LastTriNomExit(Sender: TObject);
begin
  inherited;

  If (ActiveControl<>ClsCP1Btn) then
  With LastTriNom do
  If (Trim(Text)<>'') then
  Begin
    If (Not Valid_Location(Text)) then
      SetFocus;

  end;
end;


procedure TSetLocFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {inherited;}

  {Override inheritance}

end;


procedure TSetLocFrm.ClsCP1BtnClick(Sender: TObject);
begin
  {Inherited;}
  ModalResult:=mrCancel;
end;


Function TSetLocFrm.Gen_Summary  :  String;

Begin
  Result:='You have chosen:-'+#13;

  Result:=Result+'To set all blank transaction lines to location'+LastTriNom.Text;

end;

procedure TSetLocFrm.OkCP1BtnClick(Sender: TObject);
begin
  If (Valid_Location(LastTriNom.Text)) then
  Begin
    ModalResult:=MessageDlg(Gen_Summary,mtConfirmation,[mbOk,mbCancel],0);
  end;
end;


Function Get_Location(Var  LocRef  :  String)  :  Boolean;

Var
  LocForm   :  TSetLocFrm;
  SLocked   :  Boolean;

Begin
  Result:=BOff;  SLocked:=BOff;

  LocForm:=TSetLocFrm.Create(Application.MainForm);

  Try
    LocForm.ShowModal;

    Result:=(LocForm.ModalResult=mrOK);

    If (Result) then
    With LocForm do
    Begin
      LocRef:=LocCode;
    end
    else
    Begin
      Write_FixMsgFmt('Special Function 71 has been aborted.',4);


    end;

  Finally
    LocForm.Free;

  end; {Try..}

end;



Initialization


Finalization


end.

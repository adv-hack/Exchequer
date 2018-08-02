unit ELoginU;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, TEditVal, Mask, SBSPanel,  GlobVar, EnterToTab;


type
  TCheckUserProc = function (const ID, Pass : ShortString) : SmallInt of Object;

  TELogFrm = class(TForm)
    Image1: TImage;
    UserF: Text8Pt;
    UserLab: Label8;
    Label82: Label8;
    PWrdF: Text8Pt;
    CanI1Btn: TButton;
    VerF: Label8;
    OkI1Btn: TButton;
    Login256: TImage;
    EnterToTab1: TEnterToTab;
    procedure FormCreate(Sender: TObject);
    procedure PWrdFExit(Sender: TObject);
    procedure UserFExit(Sender: TObject);
  private
    { Private declarations }
    FCheckUser : TCheckUserProc;
  public
    { Public declarations }

    GotUser,
    GotSBSDoor,
    GotPWord  :  Boolean;

    TodayPW   :  Str20;
    procedure SetUserName;
    property CheckUser : TCheckUserProc read FCheckUser write FCheckUser;
  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
{  VarConst,}
  ETStrU,
{  About,
  SysU2,
  BTSupU1, }
 { BTSupU2,
  UseDLLU,}
  TKUtil,
  SchedVar,
  ApiUtil;


{$R *.DFM}

procedure TELogFrm.PWrdFExit(Sender: TObject);

begin
 if ActiveControl = OKI1Btn then
   OKI1Btn.Click;
end;


procedure TELogFrm.FormCreate(Sender: TObject);
Var
  Res          :  Integer;
  MainCoPath   :  String;

begin
  If (NoXLogo) then
  Begin
    Image1.Picture:=nil;
    Self.Height:=Self.Height-80;
    VerF.Top:=VerF.Top-80;
    VerF.Left:=5;
  end ;
{  else
  Begin
    Case GetMaxColors(Self.Canvas.Handle) Of
      0,// : Image1.Picture := Login16.Picture;
      1 : Image1.Picture := Login256.Picture;
      2 : Image1.Picture := Login16M.Picture;
    Else
          Image1.Picture := Login256.Picture;
    End;
  end;}


//  Image1.Picture := Login256.Picture;
//  Syss.TxlateCR:=BOn;  //Force CR through.
  VerF.Caption:='Version: '+SchedulerVersion;

  ClientHeight:=214;
  ClientWidth:=357;

end;



procedure TELogFrm.UserFExit(Sender: TObject);
var
  iStatus : SmallInt;
begin
  if ActiveControl <> CanI1Btn then
  if Assigned(FCheckUser) then
  begin
    if Trim(UserF.Text) = 'SYSTEM' then
      IStatus := 0
    else
      IStatus := FCheckUser(Trim(UserF.Text), Trim(PWrdF.Text));

    if (iStatus <> 0) and (iStatus <> 30002) then
    begin
      ActiveControl := UserF;
      UserF.SelectAll;
    end;
  end;
end;

procedure TELogFrm.SetUserName;
var
  WinLogin : String;
  iStatus : SmallInt;
begin
  WinLogIn:=UpCaseStr(WinGetUserName);
  if Assigned(FCheckUser) then
  begin
    IStatus := FCheckUser(Trim(WinLogIn), Trim(PWrdF.Text));

    if (iStatus = 0) or (iStatus = 30002) then
    begin
      UserF.Text := Trim(WinLogIn);
      UserF.SelectAll;
    end;
  end;
end;





end.

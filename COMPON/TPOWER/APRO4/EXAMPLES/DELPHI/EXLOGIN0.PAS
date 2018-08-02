{*********************************************************}
{*                    EXLOGIN0.PAS                       *}
{*      Copyright (c) TurboPower Software 1996-98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{*     Shows a login process using data triggers.        *}
{*********************************************************}

unit Exlogin0;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, AdPort, OoMisc, ADTrmEmu;

type
  TLoginState = (lName, lPassword, lOther);

  TForm1 = class(TForm)
    ApdComPort1: TApdComPort;
    Button1: TButton;
    Label1: TLabel;
    edtPhoneNumber: TEdit;
    AdTerminal1: TAdTerminal;
    procedure Button1Click(Sender: TObject);
    procedure ApdComPort1TriggerData(CP: TObject; TriggerHandle: Word);
  private
    { Private declarations }
    DataTrig : Word;
    LoginState : TLoginState;

  public
    { Public declarations }
  end;


var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  {Start the login process, dial...}
  ApdComPort1.Output := 'atm0dt' + edtPhoneNumber.Text + #13;
  LoginState := lName;

  {Setup next data trigger}
  DataTrig := ApdComPort1.AddDataTrigger('name?', true);
end;

procedure TForm1.ApdComPort1TriggerData(CP: TObject; TriggerHandle: Word);
begin
  {Got latest data trigger, send next}
  ApdComPort1.RemoveTrigger(DataTrig);
  case LoginState of
    lName :
      begin
        ApdComPort1.Output := 'joe blow'^M;
        DataTrig := ApdComPort1.AddDataTrigger('password?', true);
        LoginState := lPassword;
      end;

    lPassword :
      begin
        ApdComPort1.Output := '123'^M;
        DataTrig := ApdComPort1.AddDataTrigger('?', true);
        LoginState := lOther;
      end;

    lOther :
      ShowMessage('done');
  end;
end;

end.

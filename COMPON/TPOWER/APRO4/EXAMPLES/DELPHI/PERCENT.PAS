{*********************************************************}
{*                     PERCENT.PAS                       *}
{*      Copyright (c) TurboPower Software 1997,98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{********************DESCRIPTION**************************}
{*  Demonstrates how to custom display scaling faxes.    *}
{*       Note: Works with CVT2FAX.DPR                    *}
{*********************************************************}

unit Percent;

interface

uses
  WinTypes, WinProcs, SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TPercentForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    PercentEdit: TEdit;
    Bevel1: TBevel;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    procedure OkBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PercentForm: TPercentForm;

implementation

{$R *.DFM}

procedure TPercentForm.OkBtnClick(Sender: TObject);
var
  Tmp : Integer;

begin
  ModalResult := mrNone;

  try
    Tmp := StrToInt(PercentEdit.Text);
    if (Tmp < 25) or (Tmp > 400) then begin
      MessageDlg('You must enter a percentage between 25 and 400.', mtError, [mbOK], 0);
      PercentEdit.SetFocus;
      Exit;
    end;
  except
    MessageDlg('You must enter a number here.', mtError, [mbOK], 0);
    PercentEdit.SetFocus;
    Exit;
  end;

  ModalResult := mrOK;
end;

end.


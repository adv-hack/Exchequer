{**********************************************************}
{*                       WCOMP.PAS                        *}
{*    Copyright (c) TurboPower Software Company 1996-98   *}
{*                  All rights reserved                   *}
{**********************************************************}

unit Wcomp;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TWhitespaceCompForm = class(TForm)
    CompEnabledBox: TCheckBox;
    FromEdit: TEdit;
    Label1: TLabel;
    ToEdit: TEdit;
    Label2: TLabel;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Bevel1: TBevel;
    procedure CompEnabledBoxClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WhitespaceCompForm: TWhitespaceCompForm;

implementation

{$R *.DFM}

procedure TWhitespaceCompForm.CompEnabledBoxClick(Sender: TObject);
begin
  FromEdit.Enabled := CompEnabledBox.Checked;
  ToEdit.Enabled   := CompEnabledBox.Checked;
end;

procedure TWhitespaceCompForm.OkBtnClick(Sender: TObject);
begin
  ModalResult := mrNone;

  if CompEnabledBox.Checked then begin
    try
      StrToInt(FromEdit.Text);
    except
      MessageDlg('You must enter a number here.', mtError, [mbOK], 0);
      FromEdit.SetFocus;
      Exit;
    end;

    try
      StrToInt(ToEdit.Text);
    except
      MessageDlg('You must enter a number here.', mtError, [mbOK], 0);
      ToEdit.SetFocus;
      Exit;
    end;
  end;

  ModalResult := mrOK;
end;

end.


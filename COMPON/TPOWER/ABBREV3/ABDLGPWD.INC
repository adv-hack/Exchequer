{*********************************************************}
{* ABBREVIA: AbDlgPwd.inc 3.02                           *}
{* Copyright (c) TurboPower Software Co 1997, 2002       *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA: Dialog - Password (Source)                  *}
{*   See AbDlgPwd.pas for the VCL header                 *}
{*   See AbQDgPwd.pas for the CLX header                 *}
{*********************************************************}

{$I AbDefine.inc}
interface

uses
  SysUtils,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF LINUX}
  Libc,
{$ENDIF}
{$IFDEF UsingClx}
  QGraphics, QForms, QControls, QStdCtrls,
  QButtons, QExtCtrls,
{$ELSE}
  Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls,
{$ENDIF}
  Classes;

type
  TPassWordDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Edit1: TEdit;
{$IFDEF MSWINDOWS}
    Edit2: TEdit;
{$ENDIF}
    Label1: TLabel;
{$IFDEF MSWINDOWS}
    Label2: TLabel;
{$ENDIF}
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PassWordDlg: TPassWordDlg;

implementation
uses
  AbConst;

procedure TPassWordDlg.Edit1Change(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  Edit2.Text := '';
  OKBtn.Enabled := ( CompareStr( Edit1.Text, Edit2.Text ) = 0);
{$ENDIF}
{$IFDEF LINUX}
  OKBtn.Enabled := true;
{$ENDIF}
end;

procedure TPassWordDlg.Edit2Change(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  OKBtn.Enabled := ( CompareStr( Edit1.Text, Edit2.Text ) = 0);
{$ENDIF}
{$IFDEF LINUX}
  OKBtn.Enabled := true;
{$ENDIF}
end;

procedure TPassWordDlg.FormActivate(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  OKBtn.Enabled := ( CompareStr( Edit1.Text, Edit2.Text ) = 0);
{$ENDIF}
{$IFDEF LINUX}
  OKBtn.Enabled := true;
{$ENDIF}
end;

procedure TPassWordDlg.FormCreate(Sender: TObject);
begin
  Caption := AbStrRes(AbEnterPassword);
  OKBtn.Caption := AbStrRes(AbOK);
  CancelBtn.Caption := AbStrRes(AbCancel);
  Label1.Caption := AbStrRes(AbPassword);
{$IFDEF MSWINDOWS}
  Label2.Caption := AbStrRes(AbVerify);
{$ENDIF}
end;

end.

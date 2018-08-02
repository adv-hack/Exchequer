{*********************************************************}
{* ABBREVIA: AbPePass.inc 3.02                           *}
{* Copyright (c) TurboPower Software Co 1997, 2002       *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA: Password property editor                    *}
{*   See AbPePass.pas for the VCL header                 *}
{*   See AbQPePas.pas for the CLX header                 *}
{*********************************************************}

{$I AbDefine.inc}

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF UsingClx}
  QGraphics,
  QForms,
  QControls,
  QStdCtrls,
  QButtons,
  QExtCtrls,
{$ELSE}
  Graphics,
  Forms,
  Controls,
  StdCtrls,
  Buttons,
  ExtCtrls,
{$ENDIF}
{$IFDEF LINUX}
  DesignIntf,
  DesignEditors,
{$ELSE}
{$IFDEF VERSION6}
  DesignIntf,
  DesignEditors,
{$ELSE}
  DsgnIntf,
{$ENDIF VERSION6}
{$ENDIF LINUX}
  SysUtils,
  Classes;

type
  TAbPasswordProperty = class( TStringProperty )
  public
    function GetAttributes: TPropertyAttributes;
             override;
    procedure Edit;
              override;
  end;

implementation

uses
{$IFDEF UsingClx}
  AbQDgPwd;
{$ELSE}
  AbDlgPwd;
{$ENDIF}

function TAbPasswordProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TAbPasswordProperty.Edit;
var
  D : TPasswordDlg;
begin
  D := TPasswordDlg.Create( Application );
  try
    D.Edit1.Text := Value;
    D.ShowModal;
    if D.ModalResult = mrOK then
      Value := D.Edit1.Text;
  finally
    D.Free;
  end;
end;

end.

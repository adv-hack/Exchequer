{*********************************************************}
{* ABBREVIA: AbPeDir.inc 3.02                            *}
{* Copyright (c) TurboPower Software Co 1997, 2002       *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA: Property Editor - Directory (Source)        *}
{*   See AbPeDir.pas for the VCL header                  *}
{*   See AbQPeDir.pas for the CLX header                 *}
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
  TAbDirectoryProperty = class( TStringProperty )
  public
    function GetAttributes: TPropertyAttributes;
             override;
    procedure Edit;
              override;
  end;

implementation

uses
{$IFDEF UsingClx}
  AbQDgDir;
{$ELSE}
  AbDlgDir;
{$ENDIF}


function TAbDirectoryProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

{$IFDEF MSWINDOWS}
procedure TAbDirectoryProperty.Edit;
var
  D : TAbDirDlg;
begin
  D := TAbDirDlg.Create(Application);
  try
    D.Caption := 'Directory';
    D.AdditionalText := 'Select Directory';
    if D.Execute then
      Value := D.SelectedFolder;
  finally
    D.Free;
  end;
end;
{$ELSE}
procedure TAbDirectoryProperty.Edit;
var
  D : TDirDlg;
begin
  D := TDirDlg.Create(Application);
  try
{$IFDEF MSWINDOWS} 
    D.DirectoryListBox1.Directory := Value;
{$ENDIF}
    D.ShowModal;
    if D.ModalResult = mrOK then
      Value := D.SelectedFolder;
  finally
    D.Free;
  end;
end;
{$ENDIF}

end.

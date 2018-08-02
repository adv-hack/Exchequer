{*********************************************************}
{* ABBREVIA: AbPeFn.Inc 3.02                             *}
{* Copyright (c) TurboPower Software Co 1997, 2002       *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA: Property Editor - FileName (Source)         *}
{*   See AbPeFn.pas for the VCL header                   *}
{*   See AbQPeFn.pas for the CLX header                  *}
{*********************************************************}

{$I AbDefine.inc}

interface

uses
{$IFDEF UsingClx }
  QDialogs, QForms,
{$ELSE}
  Dialogs, Forms,
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
  SysUtils;


type
  TAbFileNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes;
      override;
    procedure Edit;
      override;
  end;

  TAbExeNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes;
      override;
    procedure Edit;
      override;
  end;

  TAbCabNameProperty = class( TStringProperty )
  public
    function GetAttributes: TPropertyAttributes;
      override;
    procedure Edit;
      override;
  end;

  TAbLogNameProperty = class( TStringProperty )
  public
    function GetAttributes: TPropertyAttributes;
      override;
    procedure Edit;
      override;
  end;

implementation

uses
  AbConst,
  AbArcTyp;

{ -------------------------------------------------------------------------- }
procedure AbGetFilename(Ext, Filter, Title : string;
  var aFilename : string);
var
  D : TOpenDialog;
begin
  D := TOpenDialog.Create( Application );
  try
    D.DefaultExt := Ext;
    D.Filter := Filter;
    D.FilterIndex := 0;
    D.Options := [];
    D.Title := Title;
    D.FileName := aFilename;
    if D.Execute then
      aFilename := D.FileName;
  finally
    D.Free;
  end;
end;

{ == for zip files ========================================================= }
function TAbFileNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;
{ -------------------------------------------------------------------------- }
procedure TAbFileNameProperty.Edit;
var
  FN : string;
begin
  FN := Value;
{$IFDEF WIN32}
  AbGetFilename(AbStrRes(AbDefaultExt), AbStrRes(AbFilter),
    AbStrRes(AbFileNameTitle), FN);
{$ENDIF}
{$IFDEF LINUX}
  AbGetFilename(AbStrRes(AbDefaultExt), AbStrRes(AbFilter),
    AbStrRes(AbFileNameTitle), FN);
{$ENDIF}
  Value := FN;
end;

{ == for exe files ========================================================= }
function TAbExeNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;
{ -------------------------------------------------------------------------- }
procedure TAbExeNameProperty.Edit;
var
  FN : string;
begin
  FN := Value;
{$IFDEF WIN32}
  AbGetFilename(AbStrRes(AbExeExt), AbStrRes(AbExeFilter),
    AbStrRes(AbFileNameTitle), FN);
{$ENDIF}
{$IFDEF LINUX}
  AbGetFilename(AbStrRes(AbExeExt), AbStrRes(AbExeFilter),
    AbStrRes(AbFileNameTitle), FN);
{$ENDIF}
  Value := FN;
end;

{ == for cab files ========================================================= }
function TAbCabNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;
{ -------------------------------------------------------------------------- }
procedure TAbCabNameProperty.Edit;
var
  FN : string;
begin
  FN := Value;
{$IFDEF WIN32}
  AbGetFilename(AbStrRes(AbCabExt), AbStrRes(AbCabFilter),
    AbStrRes(AbFileNameTitle), FN);
{$ENDIF}
{$IFDEF LINUX}
  AbGetFilename(AbStrRes(AbCabExt), AbStrRes(AbCabFilter),
    AbStrRes(AbFileNameTitle), FN);
{$ENDIF}
  Value := FN;
end;

{ == for log files ========================================================= }
function TAbLogNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;
{ -------------------------------------------------------------------------- }
procedure TAbLogNameProperty.Edit;
var
  FN : string;
begin
  FN := Value;
{$IFDEF WIN32}
  AbGetFilename(AbStrRes(AbLogExt), AbStrRes(AbLogFilter),
    AbStrRes(AbFileNameTitle), FN);
{$ENDIF}
{$IFDEF LINUX}
  AbGetFilename(AbStrRes(AbLogExt), AbStrRes(AbLogFilter),
    AbStrRes(AbFileNameTitle), FN);
{$ENDIF}
  Value := FN;
end;
{ -------------------------------------------------------------------------- }

end.



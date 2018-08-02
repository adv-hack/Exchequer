{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVPEDBAuth;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TformDBAuthEditor = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    editDatasource: TEdit;
    editUsername: TEdit;
    editPassword: TEdit;
    memoOptions: TMemo;
    butnCancel: TButton;
    butnOk: TButton;
  private
  public
  end;

// Procs
  procedure RaveRegister;

implementation
{$R *.DFM}

uses
  ILConfig,
  RVDatabase, RVData, RVDefine, RVUtil, RVClass, RVTool, RPDefine, RVSQLDataview;

type
  TRaveDBAuthPropertyEditor = class(TRavePropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    procedure Edit; override;
    function GetValue: string; override;
  end;

procedure RaveRegister;
begin
{TransOff}
  RegisterRavePropertyEditor(TypeInfo(TRaveDBAuth), TRaveDatabase, 'AuthDesign'
   , TRaveDBAuthPropertyEditor);
  RegisterRavePropertyEditor(TypeInfo(TRaveDBAuth), TRaveDatabase, 'AuthRun'
   , TRaveDBAuthPropertyEditor);
{TransOn}
end;

{ TRaveDBAuthPropertyEditor }

procedure TRaveDBAuthPropertyEditor.Edit;
var
  LDatasource: string;
  LOptions: string;
  LPassword: string;
  LUsername: string;
begin
  with TRaveDBAuth(GetOrdValue(0)) do begin
    LDatasource := Datasource;
    LOptions := Options;
    LPassword := Password;
    LUsername := Username;
    if TILConfig.Edit(TRaveDatabase(Instance[0]).LinkType, LDatasource, LOptions, LUsername
     , LPassword) then begin
      Datasource := LDatasource;
      Options := LOptions;
      Password := LPassword;
      Username := LUsername;
      Modified;
    end;
  end;
end;

function TRaveDBAuthPropertyEditor.GetOptions: TPropertyOptionsSet;
begin
  Result := [poReadOnly, poEditor];
end;

function TRaveDBAuthPropertyEditor.GetValue: string;
begin
  Result := '(' + Trans('Auth') + ')';
end;

initialization
  RegisterProc('RVCL', RaveRegister);
end.

{*********************************************************}
{*                   ADPEDITT.PAS 4.03                   *}
{*      Copyright (c) TurboPower Software 1996-2002      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+}

unit AdPEditT;

interface

uses
  WinTypes,
  WinProcs,
  SysUtils,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
{$IFDEF Delphi6}
  DesignIntf,
  DesignEditors,
{$ELSE}
  dsgnintf,
{$ENDIF}
  StdCtrls;

procedure Register;

type
  {TAPI devices property editor}
  TSelectedDeviceProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

implementation

uses
  AdTapi,
  AdTSel;

procedure Register;
begin
  {Register property editors}
  RegisterPropertyEditor(TypeInfo(String), TApdCustomTapiDevice,
                         'SelectedDevice', TSelectedDeviceProperty);
end;

{TSelectedDeviceProperty (editor)}

  procedure TSelectedDeviceProperty.Edit;
  begin
    with (GetComponent(0) as TApdCustomTapiDevice) do
      SelectDevice;
    Modified;
  end;

  function TSelectedDeviceProperty.GetAttributes: TPropertyAttributes;
  begin
    Result := [paDialog]
  end;

end.

{*********************************************************}
{* ABBREVIA: AbBase.pas 3.02                             *}
{* Copyright (c) TurboPower Software Co 1997, 2002       *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA: Base component class                        *}
{*********************************************************}

{$I AbDefine.inc}

unit AbBase;

interface

uses
  Classes,
  AbConst;

type
  TAbBaseComponent = class(TComponent)
  protected {methods}
    function  GetVersion : string;
    procedure SetVersion(const Value : string);

  protected {properties}
    property Version : string
      read  GetVersion
      write SetVersion
      stored False;
  end;

implementation

{ -------------------------------------------------------------------------- }
function TAbBaseComponent.GetVersion : string;
begin
  Result := AbVersion;
end;
{ -------------------------------------------------------------------------- }
procedure TAbBaseComponent.SetVersion(const Value : string);
begin
  {NOP}
end;

end.

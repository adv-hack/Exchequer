{*********************************************************}
{* ABBREVIA: AbBaseCLX.pas 3.02                          *}
{* Copyright (c) TurboPower Software Co 1997, 2002       *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA: Base component class (CLX)                  *}
{*********************************************************}

{$I AbDefine.inc}

unit AbBseCLX;

interface

uses
  Classes,
  {$IFNDEF BuildingStub}
  QControls,
  {$ENDIF BuildingStub}
  AbConst,
  AbBase;


{$IFNDEF BuildingStub}
type
  TAbBaseWinControl = class(TWidgetControl);
{$ENDIF BuildingStub}

implementation

end.

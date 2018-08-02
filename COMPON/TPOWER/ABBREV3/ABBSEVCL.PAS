{*********************************************************}
{* ABBREVIA: AbBaseVCL.pas 3.02                          *}
{* Copyright (c) TurboPower Software Co 1997, 2002       *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA: Base component class (VCL)                  *}
{*********************************************************}

{$I AbDefine.inc}

unit AbBseVCL;

interface

uses
  Classes,
  {$IFNDEF BuildingStub}
  Controls,
  {$ENDIF BuildingStub}
  AbConst,
  AbBase;


{$IFNDEF BuildingStub}
type
  TAbBaseWinControl = class(TWinControl);
{$ENDIF BuildingStub}

implementation

end.

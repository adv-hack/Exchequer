{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVLESys;

interface

uses
  Classes, SysUtils, Graphics, Dialogs, RPDefine, Controls, RVDefine, RVClass, RVData,
  RVProj, RVCsStd, RVCsData, RVCsRpt, RVCsBars, RVCsDraw, RPBars, RVDirectDataView,
  RVDataField;

  procedure RaveRegister;

implementation

uses
  WinProcs;

type
  TRaveFunction = procedure;
  TRaveFuncItem = record
    A: pointer;
    B: string;
    C: string;
  end; { TRaveFuncItem }

{$I RVLESys.inc }

  procedure RaveRegister;

  var
    I1: integer;

  begin { RaveRegister }
  // Register all Rave interface functions
    For I1 := 1 to RaveFuncItemCount do begin
      With RaveFuncItems[I1] do begin
        RegisterRaveFunc(A^,B,C);
      end; { with }
    end; { for }
  end;  { RaveRegister }

initialization
  RegisterProc('RVCL',RaveRegister);
end.
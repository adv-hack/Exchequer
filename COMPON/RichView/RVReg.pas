
{*******************************************************}
{                                                       }
{       RichView                                        }
{       Registering all non data-aware components of    }
{       RichView Package.                               }
{       This unit must not be used by applications      }
{       themselves.                                     }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVReg;

{$I RV_Defs.inc}

interface
uses Classes, RVStyle, RichView, RVEdit,  PtblRV, RVPP, CtrlImg, RVMisc, RVTable,
     {$IFNDEF RVDONOTUSERTFIMPORT}{$IFNDEF RVDONOTUSERTF}RVOfficeCnv,{$ENDIF}{$ENDIF}RVReport;

procedure Register;

implementation
uses RVStr;

procedure Register;
begin
  RegisterComponents(RVPalettePage,
    [TRVStyle,TRichView,TRichViewEdit,TRVPrint,TRVPrintPreview,
     {$IFNDEF RVDONOTUSERTFIMPORT}{$IFNDEF RVDONOTUSERTF}TRVOfficeConverter,{$ENDIF}{$ENDIF}TRVReportHelper]);
end;

end.

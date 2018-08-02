
{*******************************************************}
{                                                       }
{       RichView                                        }
{       Functions converting options of TFindDialog     }
{       to options of RichView.SearchText and           }
{       RichViewEdit.SearchText.                        }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVMisc;

interface
{$I RV_Defs.inc}

uses RVScroll, RichView,
     {$IFNDEF RVDONOTUSERVF}
     RVEdit,
     {$ENDIF}
     Dialogs;
function GetRVSearchOptions(fo: TFindOptions): TRVSearchOptions;
{$IFNDEF RVDONOTUSERVF}
function GetRVESearchOptions(fo: TFindOptions): TRVESearchOptions;
{$ENDIF}
{-----------------------------------------------------------------------}
implementation
{-----------------------------------------------------------------------}
function GetRVSearchOptions(fo: TFindOptions): TRVSearchOptions;
begin
  Result := [rvsroMultiItem];
  if frMatchCase in fo then
    Include(Result,rvsroMatchCase);
  if frDown in fo then
    Include(Result,rvsroDown);
  if frWholeWord in fo then
    Include(Result, rvsroWholeWord);
end;
{-----------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERVF}
function GetRVESearchOptions(fo: TFindOptions): TRVESearchOptions;
begin
  Result := [rvseoMultiItem];
  if frMatchCase in fo then
    Include(Result, rvseoMatchCase);
  if frDown in fo then
   Include(Result, rvseoDown);
  if frWholeWord in fo then
    Include(Result, rvseoWholeWord);
end;
{$ENDIF}

end.

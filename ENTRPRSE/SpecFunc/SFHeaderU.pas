unit SFHeaderU;
{
  This unit contains various type declarations and enumerations that are
  shared by the Special Functions Manager and the DLLs.
}
interface

uses SysUtils, Classes, TEditVal, Controls, ComCtrls;

type
  TOutputStyle = (osNormal, osHeader, osSubHeader, osCopyright, osInfo, osWarning, osList);

  TProgressCallBack = function(MaxTotal, Position: Integer): Boolean of object;
  TOutputCallback = procedure(OutputMsg: ShortString; Style: TOutputStyle) of object;

  TSFExpiryType = (etStd, etRunOnce, etExpiresOn);

  TSFParams = class
  public
    Mode: Integer;
    Aborted: Boolean;
    ProgressCallback: TProgressCallback;
    OutputCallback: TOutputCallback;
  end;

  TSFProgressBar = class(TObject)
  public
    ProgressBar1: TProgressBar;
    InfoLbl: Label8;
    ProgLab: Label8;
    Aborted: Boolean;
    Caption: string;
  end;

  TExecuteProcedure = procedure(Params: TSFParams) of object;
  TDLLExecuteFn = function(Mode: Integer; Callback: TProgressCallback; OutputCallback: TOutputCallback): Boolean;

  TDateFn = function: TDate;
  TStringFn = function: ShortString;
  TBooleanFn = function: Boolean;
  TIntegerFn = function: Integer;
  TByteFn = function: Byte;

  ESFManager = class(Exception)
  end;

implementation

end.

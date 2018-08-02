unit RWSentinel;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes, ExBtTh1u, SentU, ElVar, RepThrd1;

type
  TSentinelReport = Class(TSentinel)
  private
    FReportName : string;
  public
    constructor Create(ClientID : SmallInt); //PR: 21/09/2009 Memory Leak Change
    procedure Run(TestMode : Boolean = False; RepQuery : Boolean = False); override;

    property ReportName : string read FReportName write FReportName;
  end;





implementation

uses
  ExThrd2U, Forms, SysUtils, GlobVar, SentRepObjCU, SentRepObjNU, RwFuncs, RwOpenF, BtSupU1,
  VarConst, Windows, DebugLog, CtkUtil04;

const
  BOn  = True;
  BOff = False;


function ThreadDesc(Purpose : TSentinelPurpose) : String;
begin
  Case Purpose of
     spQuery, spReportQuery : Result := 'Running ';
     spConveyor,
     spReportConveyor,
     spCSVConveyor,
     spVisualReportConveyor : Result := 'Sending ';
     spEmailCheck : Result := 'Checking ';
  end;
end;


{ TSentinelReport }

constructor TSentinelReport.Create(ClientID: SmallInt);
begin
  inherited Create;
  FClientID := ClientID;  //PR: 21/09/2009 Memory Leak Change
  FPurpose := spReport;
end;

procedure TSentinelReport.Run(TestMode, RepQuery: Boolean);
Var
  EntTest   :  RepRunCtrlPtr;
  FoundCode : String;

  xInfo : TExtraRepInfoRec;
begin
  xInfo.xDataPath := FDataPath;
  xInfo.xRepName := FReportName;

  New (EntTest,Create(Application.MainForm, RepGenRecs^, xInfo));
  try
    With EntTest^ do Begin
      ReportMode:=1;
      FTQNo := 1;
      ElertName := Trim(FElertName);
      UserID := FUser;
      OnDoProgress := SendProgress;
      If (Start) then
      begin
        Process;
        Finish;
        if iResult = 0 then
        begin
          LogIt(spQuery, S_FINISHED);
          FRanOK := True;
        end
        else
          LogIt(spQuery, 'Unable to save record: ' + IntToStr(iResult));
      end
      else
        Raise Exception.Create('Unable to start report');
    end; {with..}

  Finally
    Dispose(EntTest,Destroy);
  End; {try..}
end;

end.

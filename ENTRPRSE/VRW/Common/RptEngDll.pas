unit RptEngDll;

interface

uses
  Forms,
  GlobalTypes,
  RepEngIF,
  RepTreeIF,
  VRWReportDataIF,
  VRWReportIF,
  VRWConverterIF;

const
  {$IFNDEF SENTREPENG}
  DLL_NAME = 'REPENGINE.DLL';
  {$ELSE}
  DLL_NAME = 'SENTREPENGINE.DLL';
  {$ENDIF}

type
  { Procedure type for call-backs from the report wizard to the report tree }
//  TReportDesignerEvent = procedure (Params: TReportWizardParams;
//                           ParentName, FileName: string;
//                           var FunctionResult: LongInt) of object;
  TReportDesignerPrintEvent = procedure(UserName: ShortString;
                                var FunctionResult: LongInt) of object;
  TValidateReportNameFn = procedure(const ReportName: ShortString;
    var IsValid: Boolean) of object;

  { This is a slightly amended copy of the data record used by the Report
    Engine DLL. The rtAllowEdit and rtFileExists fields have been added for
    use by the Report Tree. }
  TVRWReportDataRec = Record
    rtNodeType:    char;
    rtRepName:     String[50];   { Report Code }
    rtRepDesc:     String[255];  { Report Title }
    rtParentName:  String[50];	 { Link to parent record }
    rtFileName:    String[80];   { Report file name }
    rtLastRun:     TDateTime;
    rtLastRunUser: String[10];
    rtPositionNumber: LongInt;
    rtIndexFix:    char;
    rtAllowEdit:   Boolean;
    rtFileExists:  Boolean;
    rtSpace:       string[45];   { Pad record to 512 bytes }
  end;

function GetReportTree : IReportTree_Interface; external DLL_NAME;
function GetVRWReportData: IVRWReportData; external DLL_NAME
function GetVRWReport: IVRWReport; external DLL_NAME
//function GetReportEngine : IReport_Interface; external DLL_NAME
function GetVRWConverter: IVRWConverter; external DLL_NAME
Function RepEngineDllVer : ShortString; external DLL_NAME
procedure ClosePreviewWindows; external DLL_NAME
procedure InitPreview(App: TApplication; Scr: TScreen); external DLL_NAME

implementation

end.
 
 

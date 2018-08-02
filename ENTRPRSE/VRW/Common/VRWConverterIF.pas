unit VRWConverterIF;
{
  IVRWConverter
    Converts a report from the original Report Writer format into latest Visual
    Report Writer format.

    Requires:
      Report: IVRWReport            (report will be imported into here)
      SourceReport: IReportDetails  (original report)

      SourceReport can be obtained using rwrGetReportDetails in RWReader.dll.
}
interface

uses VRWReportIF, RWRIntf;

type
  IVRWConverter = interface

    { --- Property access methods -------------------------------------------- }
    function GetReport: IVRWReport;
    procedure SetReport(Value: IVRWReport);

    function GetSourceReport: IReportDetails;
    procedure SetSourceReport(Value: IReportDetails);

    { --- General methods ---------------------------------------------------- }

    { Main entry point. Report and SourceReport must be set before calling this
      method }
    function Execute: LongInt;

    { --- Properties --------------------------------------------------------- }

    { The report will imported into this IVRWReport interface (any existing
      details will be overwritten) }
    property Report: IVRWReport
      read GetReport
      write SetReport;

    { SourceReport holds an interface to the report which will be imported }
    property SourceReport: IReportDetails
      read GetSourceReport
      write SetSourceReport;
  end;

implementation

end.

unit RptWizardTypes;

interface

Uses Classes, SysUtils, GlobVar, VarConst, RWOpenF, VRWReportIF;

Type
  TWizardReportType = (wrtReport, wrtGroup);

  //------------------------------

  TRegionInfo = Class(TObject)
  Public
    RegionType : TRegionType;
    SectionNo  : Byte;
    RegionDesc : ShortString;
    RegionVisible : Boolean;
    Indent : Byte;

    Constructor Create (RegType : TRegionType; SectNo, Ind : Byte; Desc : ShortString);
  End; // TRegionInfo

  //------------------------------

  TDBFieldColumn = Class(TObject)
  Public
    DictRec : DataVarType;
    Caption : ShortString;
    Filter : ShortString;
    SubTotal : Boolean;
    SortIdx : Byte;
    SortAscending : Boolean;
    PageBreak : Boolean;

    Constructor Create;
  End; // TDBFieldColumn

  //------------------------------

  TReportWizardParams = class(TObject)
    wrReportName : ShortString;
    wrReportDesc : ShortString;
    wrType       : TWizardReportType;     // Type: wrtGroup or wrtReport
    //oPaperOrientation : TOrientation;

    wrMainFileName : ShortString;         // Description of Report File, e.g. Transaction Headers
    wrMainDbFile : SmallInt;              // Id number of report file
    wrIndex : SmallInt;                   // Is number of index for report file, 0 if N/A

    wrDBFieldList  : TList;               // List of TDBFieldColumn
    wrSortedFields : TList;               // List of duplicate references to wrDBFieldList TDBFieldColumn in sorted order
    wrSections     : TList;               // List of TRegionInfo

    wrWasPrinted: Boolean;                // True if the report was printed
                                          // while being designed (before it
                                          // was saved into the Report Tree).
                                          
    //BasicReportInfo : TBasicReportInfo;
    //MainReportFileInfo : TMainReportFileInfo;
    //DatabaseFields : TDatabaseFields;
//    SortPage : TSortPage;
//    FieldFilters : TFieldFilters;
//    ReportSections : TStringList;

    constructor Create;
    destructor Destroy; override;

    Procedure ClearSections;
  end;


implementation

//=========================================================================

Constructor TRegionInfo.Create (RegType : TRegionType; SectNo, Ind : Byte; Desc : ShortString);
Begin // Create
  Inherited Create;

  RegionType := RegType;
  SectionNo  := SectNo;
  RegionDesc := Desc;
  RegionVisible := True;
  Indent := Ind;
End; // Create

//=========================================================================

Constructor TDBFieldColumn.Create;
Begin // Create
  Inherited Create;

  FillChar(DictRec, SizeOf(DictRec), #0);
  Caption := '';
  Filter := '';
  //SubTotal : Boolean;
  SortIdx := 0;
  SortAscending := False;
  PageBreak := False;
End; // Create

//=========================================================================

constructor TReportWizardParams.Create;
begin
  inherited Create;

  wrReportName := '';
  wrReportDesc := '';
  wrType       := wrtReport;
  //oPaperOrientation := poPortrait;

  wrMainFileName := '';
  wrMainDbFile := 0;
  wrIndex := 0;

  wrDBFieldList := TList.Create;
  wrSortedFields := TList.Create;
  wrSections := TList.Create;

  //DatabaseFields dbFields := TStringList.Create;
//  SortPage.SortObjList := TStringList.Create;
//  FieldFilters.FilterList := TStringList.Create;
//  ReportSections := TStringList.Create;

end;

//------------------------------

destructor TReportWizardParams.Destroy;
Var
  oDBField : TDBFieldColumn;
begin
  While (wrDBFieldList.Count > 0) Do
  Begin
    oDBField := TDBFieldColumn(wrDBFieldList[0]);
    FreeAndNIL(oDBField);
    wrDBFieldList.Delete(0);
  End; // While (wrDBFields.Count > 0)
  FreeAndNIL(wrDBFieldList);

  // NOTE: As wrSortedFields contains duplicate references to the items in wrDBFieldList we
  // don't need to de-allocate the memory for the items, just destroy the control.
  FreeAndNIL(wrSortedFields);

  ClearSections;
  FreeAndNIL(wrSections);

  inherited Destroy;
end;

//-------------------------------------------------------------------------

Procedure TReportWizardParams.ClearSections;
Var
  oRegion : TRegionInfo;
Begin // ClearSections
  While (wrSections.Count > 0) Do
  Begin
    oRegion := TRegionInfo(wrSections[0]);
    FreeAndNIL(oRegion);
    wrSections.Delete(0);
  End; // While (wrSections.Count > 0)
End; // ClearSections

//=========================================================================


end.

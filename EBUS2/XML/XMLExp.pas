unit XMLExp;

{ prutherford440 09:52 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  XMLBase, EBusUtil, XMLOutpt, GlobVar, eBusCnst;

type
  TWriteXMLExport = class(TWriteXMLBase)
    private
      {fExportUpdatedLocations, }fIgnoreWebIncludeFlag : boolean;
      fExportMode : TRecExportMode;
      fExportLastRun : TDateTime;
      procedure SetIgnoreWeb(const Value: boolean);
//      procedure SetUpdateLoc(const Value: boolean);
      procedure SetExportMode(const Value: TRecExportMode);
      procedure SetExportLastRun(const Value: TDateTime);
    protected
      Root : TXmlDElement;
      function  OKToWriteRecord(const EditDate : longdate; const EditTime : string) : boolean;
    public
      procedure SaveToFile(const FileName: String; FormattedForPrint: Boolean = False);
      property IgnoreWebIncludeFlag : boolean read fIgnoreWebIncludeFlag write SetIgnoreWeb;
//      property ExportUpdatedLocations : boolean read fExportUpdatedLocations write SetUpdateLoc;
      property ExportMode : TRecExportMode read fExportMode write SetExportMode;
      property ExportLastRun : TDateTime read fExportLastRun write SetExportLastRun;
      procedure CreateXML; virtual; abstract;
   end;

implementation

uses
  XMLUtil, StrUtil, MathUtil;

//-----------------------------------------------------------------------------------

procedure TWriteXMLExport.SetIgnoreWeb(const Value: boolean);
begin
  fIgnoreWebIncludeFlag := Value;
end;

//-----------------------------------------------------------------------------------
{
procedure TWriteXMLExport.SetUpdateLoc(const Value: boolean);
begin
  fExportUpdatedLocations := Value;
end;
}
//-----------------------------------------------------------------------------------

procedure TWriteXMLExport.SetExportMode(const Value: TRecExportMode);
begin
  fExportMode := Value;
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLExport.SetExportLastRun(const Value: TDateTime);
begin
  fExportLastRun := Value;
end;

//-----------------------------------------------------------------------------------

procedure TWriteXMLExport.SaveToFile(const FileName: String; FormattedForPrint: Boolean = False);
begin
  Document.SaveToFile(FileName, FormattedForPrint);
end;

//-----------------------------------------------------------------------------------

function TWriteXMLExport.OKToWriteRecord(const EditDate : longdate; const EditTime : string) : boolean;
// Pre : EditDate = Date current record last edited, format yyyymmdd
//       EditTime = Time record current record last edited, format hhmmss
var
  EditDateTime : TDateTime;
begin
  Result := true;
  if ExportMode = expAll then
    exit;

  EditDateTime := ToDateTime(EditDate, EditTime);
  Result := ZeroFloat(EditDateTime) or (EditDateTime >= ExportLastRun);
end;

end.

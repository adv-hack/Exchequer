unit uDripfeedExportManager;
{
  This class handles the processing which is common to all the Exporter
  classes, and is used by each of the T...DataExporter classes (in the
  various oExporter.pas units).

  The main processing is done by the ancestor class (TBaseExportManager), and
  this class overrides the GetTableExporter method to return the appropriate
  table for the Dripfeed Export, and overrides the BeforeExport method to
  retrieve the System Settings required.
}
interface

uses SysUtils, Classes,
  // ICE units
  uExportBaseClass,
  uBaseExportManager
  ;

type
  TDripfeedExportManager = class(TBaseExportManager)
  private
    IsInitialised: Boolean;
  protected
    function BeforeExport(TableID: LongWord; Params: TExportParams): Boolean; override;
    function GetTableExporter(pReference: Longword): _ExportBase; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  // ICE units
  uConsts,
  uCommon,
  uHistoryExport,
  GlobVar,
  VarConst,
  BtrvU2,
  uDripfeedExport
  ;

// ===========================================================================
// TDripfeedExportManager
// ===========================================================================

function TDripfeedExportManager.BeforeExport(TableID: LongWord;
  Params: TExportParams): Boolean;
var
  Key: string[255];
  Res: LongInt;
begin
  Result := inherited BeforeExport(TableID, Params);
  if Result and not IsInitialised then
  begin
    SetDrive := Params.DataPath;
    { Open the System Settings table... }
    Res := Open_File(F[SysF], SetDrive + FileNames[SysF], 0);
    if (Res = 0) then
    begin
      { ...and find the main System Settings record. }
      Key := SysNames[SYSR];
      Res := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, 0, Key);
      if (Res <> 0) then
      begin
        DoLogMessage('TDripfeedExportManager.BeforeExport: Error locating System record.',
                     cCONNECTINGDBERROR,
                     'Error: ' + IntToStr(Res));
        Result := False;
      end;
    end
    else
    begin
      DoLogMessage('TDripfeedExportManager.BeforeExport: Error reading System file.',
                   cCONNECTINGDBERROR,
                   'Error: ' + IntToStr(Res));
      Result := False;
    end;
    IsInitialised := Result;
  end;
end;

// ---------------------------------------------------------------------------

constructor TDripfeedExportManager.Create;
begin
  inherited Create;
  IsInitialised := False;
  Title := 'Dripfeed export';
end;

// ---------------------------------------------------------------------------

destructor TDripfeedExportManager.Destroy;
var
  Res: LongInt;
begin
  if IsInitialised then
  begin
    Res := Close_File(F[SysF]);
    if ((Res <> 0) and (Res <> 3)) then
      DoLogMessage('TDripfeedExportManager.Destroy: Error closing System file.',
                   cCONNECTINGDBERROR,
                   'Error: ' + IntToStr(Res));
    IsInitialised := False;
  end;
  inherited;
end;

// ---------------------------------------------------------------------------

function TDripfeedExportManager.GetTableExporter(
  pReference: Longword): _ExportBase;
begin
{
  Result := nil;
  case pReference of
    cDripfeedTable: Result := TDripfeedExport.Create;
  end;
}
  Result := TDripfeedExport.Create;
end;

// ---------------------------------------------------------------------------

end.

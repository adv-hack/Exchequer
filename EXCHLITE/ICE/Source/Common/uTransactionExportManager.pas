unit uTransactionExportManager;
{
  This class handles the processing which is common to all the Exporter
  classes, and is used by each of the T...DataExporter classes (in the
  various oExporter.pas units).

  The main processing is done by the ancestor class (TBaseExportManager), and
  this class simply overrides the GetTableExporter method to return the
  appropriate table for the Transaction Export.
}
interface

uses SysUtils, Classes,
  // ICE units
  uExportBaseClass,
  uBaseExportManager
  ;

type
  TTransactionExportManager = class(TBaseExportManager)
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
  uTransactionExport,
  uOpeningBalanceExport,
  GlobVar,
  VarConst,
  BtrvU2
  ;

{ TTransactionExportManager }

function TTransactionExportManager.BeforeExport(TableID: LongWord;
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
        DoLogMessage('TTransactionExportManager.BeforeExport: Error locating System record.',
                     cCONNECTINGDBERROR,
                     'Error: ' + IntToStr(Res));
        Result := False;
      end;
    end
    else
    begin
      DoLogMessage('TTransactionExportManager.BeforeExport: Error reading System file.',
                   cCONNECTINGDBERROR,
                   'Error: ' + IntToStr(Res));
      Result := False;
    end;
    IsInitialised := Result;
  end;
end;

constructor TTransactionExportManager.Create;
begin
  inherited Create;
  IsInitialised := False;
end;

destructor TTransactionExportManager.Destroy;
var
  Res: LongInt;
begin
  if IsInitialised then
  begin
    Res := Close_File(F[SysF]);
    if ((Res <> 0) and (Res <> 3)) then
      DoLogMessage('TTransactionExportManager.Destroy: Error closing System file.',
                   cCONNECTINGDBERROR,
                   'Error: ' + IntToStr(Res));
    IsInitialised := False;
  end;
  inherited;
end;

function TTransactionExportManager.GetTableExporter(
  pReference: Longword): _ExportBase;
begin
  Result := nil;
  case pReference of
    cTransactionTable:
      begin
        Result := TTransactionExport.Create;
        Title  := 'Transaction export';
      end;
    cOpeningBalanceTable:
      begin
        Result := TOpeningBalanceExport.Create;
        Title  := 'Opening Balance export';
      end;
  end;
end;

end.

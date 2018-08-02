library BtrvSQL;

uses
  SysUtils,
  Classes,
  SQLCompany in 'SQLCompany.pas',
  BtrvSQLU in 'BtrvSQLU.pas',
  DebugLogU in 'DebugLogU.pas',
  Btrvu2 in 'X:\ExchSQL\BtrvSQL\TestVersion\BtrvU2.pas';

{$R *.res}

exports
  BTRCALL,
  BTRCALLID,
  WBTRVINIT,
  WBTRVSTOP,
  UsingSQL,
  OverrideUsingSQL,
  CreateDatabase,
  CreateCompany,
  AttachCompany,
  DetachCompany,
  DeleteCompany,
  GetConnectionString,
  OpenCompany,
  OpenCompanyByCode,
  GetCompanyCode,
  TableExists,
  DeleteTable,
  ValidCompany,
  ValidSystem,
  HasExclusiveAccess,
  ExportDataset,
  ImportDataset,
  GetErrorInformation,
  CopyTable,
  UpdateTable,
  GetDBColumnName,
  Initialise;

begin
end.

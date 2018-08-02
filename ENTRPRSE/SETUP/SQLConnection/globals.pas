unit globals;

interface

uses
  Classes;

const
  SQL_CONN_STRING_SUCCESS   = 0;
  SQL_CONN_STRING_FAILED    = 1;
  SQL_CONN_OPEN_FILE_FAILED = 2;
  
var
  // Input data
  xmlFile      : string;
  protocol     : string;
  overrideDefault : boolean;

  // Connection string
  encConnStr   : string;
  connStr      : string;
  expConnStr : TStringList; // separated into fields

  // Extracted data
  dataSource   : string;
  currProtocol : string;
  dataSourceIndex : integer;

  // Default
  defaultProtocol : string; // Must prevail unless override is set

implementation

end.

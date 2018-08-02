library BBM_ODBC;



{$R *.RES}

uses
  odbcu in 'odbcu.pas' {dm1: TDataModule};

exports
  DllInitialiseTable,
  DllGetString,
  DllSelectRecord;
end.
 
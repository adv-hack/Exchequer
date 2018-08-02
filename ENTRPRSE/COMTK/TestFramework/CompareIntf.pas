unit CompareIntf;

interface

type
  TProgressProc = procedure (const sMessage : string) of Object;

  ICompareTables = Interface
  ['{3F7CFF75-1222-4EB8-8294-FC8B8BFAAF6F}']
    function Get_ctPath1 : string;
    procedure Set_ctPath1(const Value : string);
    property ctPath1 : string read Get_ctPath1 write Set_ctPath1;

    function Get_ctPath2 : string;
    procedure Set_ctPath2(const Value : string);
    property ctPath2 : string read Get_ctPath2 write Set_ctPath2;

    function Get_ctTable : string;
    procedure Set_ctTable(const Value : string);
    property ctTable : string read Get_ctTable write Set_ctTable;

    function Get_ctResultFile : string;
    procedure Set_ctResultFile(const Value : string);
    property ctResultFile : string read Get_ctResultFile write Set_ctResultFile;

    function Execute : Boolean;
  end;

  ICompareDataBases = Interface
  ['{D4A140DE-1862-408A-AF91-D7165D1C8B42}']
    function Get_cdPath1 : string;
    procedure Set_cdPath1(const Value : string);
    property cdPath1 : string read Get_cdPath1 write Set_cdPath1;

    function Get_cdPath2 : string;
    procedure Set_cdPath2(const Value : string);
    property cdPath2 : string read Get_cdPath2 write Set_cdPath2;

    function Get_cdTestName : string;
    procedure Set_cdTestName(const Value : string);
    property cdTestName : string read Get_cdTestName write Set_cdTestName;

    function Get_cdResultsFolder : string;
    procedure Set_cdResultsFolder(const Value : string);
    property cdResultsFolder : string read Get_cdResultsFolder write Set_cdResultsFolder;

    function Get_OnProgress : TProgressProc;
    procedure Set_OnProgress(const Value : TProgressProc);
    property OnProgress : TProgressProc read Get_OnProgress write Set_OnProgress;

    function Execute : Boolean;
  end;


implementation

end.

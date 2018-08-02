unit oAnonymisationDiaryObjIntf;

// Interface Implemented in oAnonymisationDiaryObjIntf unit
// Generic interface for objects which implement a specific AnonymisationDiary Details

interface

uses Classes, GDPRConst, GlobVar, oAnonymisationDiaryBtrieveFile;

type
  IAnonymisationDiaryDetails = Interface['{E9B5F899-4333-41EF-8A80-BC1344DD4B59}']
    // --- Internal Methods to implement Public Properties ---
    function GetIndex: Integer;
    function GetEntityType: TAnonymisationDiaryEntity;
    procedure SetEntityType(AValue: TAnonymisationDiaryEntity);
    function GetEntityCode: String;
    procedure SetEntityCode(AValue: String);
    function GetAnonymisationDate: LongDate;
    procedure SetAnonymisationDate(AValue: LongDate);
    function GetEntityName: String;
    function GetIsPending: Boolean;
    function GetSelected: Boolean;
    procedure SetSelected(AValue: Boolean);
    {$IFDEF OLE}
      function GetOLESetDrive: String;
      procedure SetOLESetDrive(AValue: String);
    {$ENDIF}

    //------------------- Public Routines --------------------
    function AddEntity: Integer;
    function RemoveEntity(aEntityType: TAnonymisationDiaryEntity; aEntityCode: String): Integer;
    // ------------------ Public Properties ------------------
    //Accessing list through a index from InterfaceList object.
    property adIndex: Integer Read GetIndex;
    property adEntityType: TAnonymisationDiaryEntity Read GetEntityType Write SetEntityType;
    property adEntityCode: String Read GetEntityCode Write SetEntityCode;
    property adAnonymisationDate: LongDate Read GetAnonymisationDate Write SetAnonymisationDate;
    property adEntityName: String Read GetEntityName;
    property adIsPending: Boolean Read GetIsPending;
    property adSelected : Boolean Read GetSelected Write SetSelected;
    //HV 27/06/2018 2017R1.1 ABSEXCH-20793: provided support for entry in anonymisation control center if user changes Account Status to from OLE.
    {$IFDEF OLE}
      property adOLESetDrive: String Read GetOLESetDrive Write SetOLESetDrive;
    {$ENDIF}
  end; //IAnonymisationDiaryDetails

  // Generic interface for objects which implement a specific Anonymisation Diary Detail List
  IAnonymisationDiaryDetailList = Interface['{01FC6755-EF6B-45A6-998A-12188089DD71}']
    // --- Internal Methods to implement Public Properties ---
    function GetCount: Integer;
    function GetAnonymisationDiaryObj(aIndex: Integer): IAnonymisationDiaryDetails;
    procedure Refresh; // Reloads the cached AnonymisationDiary Data
    procedure Anonymise(const AOwner: TObject); // AnonymiseEntity 
    function FindAnonObjByEntityCode(AEntityCode: String): IAnonymisationDiaryDetails;

    // ------------------ Public Properties ------------------
    property Count: Integer Read GetCount;
    property AnonymisationDiaryObj[aIndex: Integer]: IAnonymisationDiaryDetails Read GetAnonymisationDiaryObj; default;
  end; //IAnonymisationDiaryDetailList

implementation

end.

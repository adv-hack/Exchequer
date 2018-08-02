unit PIIScannerIntf;

interface

uses
  Classes, PIIFieldNumbers, Windows, GlobVar, oPIIDataAccess;

type
  TPIIScanType = (pstTrader, pstEmployee);
  TItemType = (itItem, itHeader);

  IPIIInfoList = Interface;

  IPIIInfoItem = Interface
  ['{DDA8FFC8-4278-4DBE-B1A8-15BE528252CF}']
    function GetIndex : Integer;
    function GetParent : Integer;
    function GetDisplayText : string;
    procedure SetDisplayText(const Value : string);
    function GetFieldType : TPIIFieldNo;
    function GetItemType : TItemType;
    function GetXMLDescription : string;
    function GetText : string;
    function GetTable : Integer;
    function GetRecordAddress : Integer;

    function HasChildren : Boolean;
    function GetChildren : IPIIInfoList;

    property Index : Integer read GetIndex;
    property Parent : Integer read GetParent;
    property DisplayText : string read GetDisplayText write SetDisplayText;
    property Children : IPIIInfoList read GetChildren;
    property FieldType : TPIIFieldNo read GetFieldType;
    property ItemType : TItemType read GetItemType;
    property XMLDescription : string read GetXMLDescription;
    property Text : string read GetText;
    property Table : Integer read GetTable;
    property RecordAddress : Integer read GetRecordAddress;
  end;

  IPIIInfoHeader = Interface(IPIIInfoItem)
  ['{17D2210F-7F4F-44F6-B7E8-AD932A762C6E}']
    function GetKeystring : string;

    property KeyString : string read GetKeyString;
  end;

  TPIIInfoAddress = Record
    Address : AddrTyp;
    PostCode : string[20];
    Country : string[2];
  end;

  IPIIAddressItem = Interface(IPIIInfoItem)
  ['{192195C5-C909-42FD-9A73-845B62EB20F7}']
    function GetAddress : TPIIInfoAddress;

    property Address : TPIIInfoAddress read GetAddress;
  end;

  IPIIInfoList = Interface
  ['{7B2708B8-BD42-44D2-B8ED-325221DB4A22}']
    function GetCount : Integer;
    function GetItem(Index : Integer) : IPIIInfoItem;

    property Items[Index : Integer] : IPIIInfoItem read GetItem; default;
    property Count : Integer read GetCount;
  end;

  IPIIScanner = Interface
    function GetPIITree : IPIIInfoItem;
    function GetPIIList : IPIIInfoList;
    function ScanComplete : Boolean;


    function GetDataAccess : IPIIDataAccess;

    function Execute : Integer;

    procedure WriteToXML(const FileName : string; IncludeNotes : Boolean);

    property PIITree : IPIIInfoItem read GetPIITree;
    property PIIList : IPIIInfoList read GetPIIList;

    //Need to make Data Access object available to print routine
    property DataAccess : IPIIDataAccess read GetDataAccess;
  end;


implementation

end.

unit VRWPaperSizesIF;

interface

uses Classes;

type
  IVRWPaperSize = interface
    { --- Property access methods ------------------------------------------- }
    function GetPrCode: ShortString;
    procedure SetPrCode(const Value: ShortString);

    function GetPrMMHeight: SmallInt;
    procedure SetPrMMHeight(const Value: SmallInt);

    function GetPrMMWidth: SmallInt;
    procedure SetPrMMWidth(const Value: SmallInt);

    { --- Properties -------------------------------------------------------- }
    property prCode: ShortString
      read GetPrCode
      write SetPrCode;

    property prMMHeight: SmallInt
      read GetPrMMHeight
      write SetPrMMHeight;

    property prMMWidth: SmallInt
      read GetPrMMWidth
      write SetPrMMWidth;

  end;

  IVRWPaperSizes = interface
    { --- Property access methods ------------------------------------------- }
    function GetCount: Integer;

    function GetPsItem(Index: SmallInt): IVRWPaperSize;
    procedure SetPsItem(Index: SmallInt; const Value: IVRWPaperSize);

    function GetPsItemByCode(Index: ShortString): IVRWPaperSize;
    procedure SetPsItemByCode(Index: ShortString; const Value: IVRWPaperSize);

    { --- General methods --------------------------------------------------- }

    { Reads all the paper size entries into the internal list of IVRWPaperSize
      objects }
    procedure ReadAll;

    { Adds a new IVRWPaperSize object, using the supplied settings }
    function Add(Code: ShortString; MMWidth, MMHeight: SmallInt): IVRWPaperSize;

    { Returns the paper code from the supplied string. The string is assumed to be
      in the format created by FillCodeList below. }
    function ExtractPaperCode(FromStr: string): string;

    { Copies the paper codes into the supplied strings (any existing strings
      will be removed) }
    procedure FillCodeList(Strings: TStrings);

    { Returns the position in TStrings of the entry for the specified paper
      code }
    function IndexOf(Strings: TStrings; PaperCode: ShortString): Integer;

    { --- Properties -------------------------------------------------------- }
    property Count: Integer
      read GetCount;

    property psItems[Index: SmallInt]: IVRWPaperSize
      read GetPsItem
      write SetPsItem;

    property psItemsByCode[Index: ShortString]: IVRWPaperSize
      read GetPsItemByCode
      write SetPsItemByCode; default;
  end;

implementation

end.

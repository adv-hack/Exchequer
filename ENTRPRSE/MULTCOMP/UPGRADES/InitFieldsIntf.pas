unit InitFieldsIntf;

interface

type

  TInitFieldsType = (ifConsumers, ifPPDMode, ifPassword);

  IInitialiseFields = Interface
  ['{37F559E6-5F30-4A29-B3BF-E6F0B53AC4BB}']
    function GetFileNumber : Integer;
    procedure SetFileNumber(Value : Integer);
    property FileNumber : integer read GetFileNumber write SetFileNumber;

    function GetIndex : Integer;
    procedure SetIndex(Value : Integer);
    property Index : integer read GetIndex write SetIndex;

    function GetErrorString : string;
    property ErrorString : string read GetErrorString;

    function Execute : Boolean;
  end;

implementation

end.

unit AuthoriseeInterface;

interface

uses
  Classes;

type

  IRequest = Interface
  ['{F21B74A9-F52A-4FB2-8282-B7F756987757}']
    function GetOurRef : ShortString;
    function GetDate   : ShortString;
    function GetValue  : Double;
    property rqOurRef : ShortString read GetOurRef;
    property rqDate   : ShortString read GetDate;
    property rqValue  : Double read GetValue;
  end;

  IRequestList = Interface
  ['{462DA60C-71E1-450B-AD8D-202C1C023C0A}']
    function GetCount : Integer;
    function GetItem(Index : Integer) : IRequest;
    property rlCount : Integer read GetCount;
    property rlItems[Index : Integer] : IRequest read GetItem;
  end;

{$IFNDEF PASET}
  function GetRequests(CompanyCode,
                       AuthID,
                       AuthCode     : ShortString;
                       CutOffDays   : SmallInt) : IRequestList; StdCall; Export;

  function AuthoriseRequest(CompanyCode,
                            AuthID,
                            AuthCode,
                            OurRef  : ShortString;
                            Reject  : WordBool;
                            RejectReason : ShortString) : SmallInt; StdCall; Export;
{$ENDIF}

implementation

{$IFNDEF PASET}
const
  DllName = 'ExPaSet.dll';

  function GetRequests(CompanyCode,
                       AuthID,
                       AuthCode     : ShortString;
                       CutOffDays   : SmallInt) : IRequestList; External DllName;

  function AuthoriseRequest(CompanyCode,
                            AuthID,
                            AuthCode,
                            OurRef  : ShortString;
                            Reject  : WordBool;
                            RejectReason : ShortString) : SmallInt; External DllName;
{$ENDIF}


end.

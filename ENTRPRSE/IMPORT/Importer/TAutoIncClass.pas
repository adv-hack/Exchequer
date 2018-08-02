unit TAutoIncClass;

{******************************************************************************}
{ TAutoInc maintains an array of integers each of which constitute the         }
{ current value of the [AutoInc0] to [AutoInc9] counters. These can be used    }
{ in place of field values read from an import file, for example to generate   }
{ line numbers on Transaction Lines.                                           }
{ The [AutoIncReset] section from a map file states which record type causes   }
{ an AutoInc counter to be reset to zero.                                      }
{******************************************************************************}

interface

const
  MaxAutoIncs = 9;

type
  TAutoInc = class(TObject)
  private
{* internal fields *}
    FAutoInc: array[0..MaxAutoIncs] of integer; // contains the auto increment counters
    FSet: array[0..MaxAutoIncs] of integer;     // contains which array elements of FReset have been used
    FSetCounter: integer;                       // how many elements of FReset have been set
{* property fields *}
    FReset: array[0..MaxAutoIncs] of string; // contains the record types which reset the respective counter to zero
{* getters and setters *}
    function  GetAutoInc(IncIx: integer): integer;
    procedure SetSetReset(IncIx: integer; const Value: string);
    function  GetNextInc(IncIx: integer): integer;
    function  GetSysMsg: string;
    function  GetSysMsgSet: boolean;
    procedure SetSysMsg(const Value: string);
    function  GetSetReset(IncIx: integer): string;
    procedure SetAutoInc(IncIx: integer; const Value: integer);
  public
    constructor create;
    procedure Clear;
    function  Reset(RecordType: string): integer;
    property  AutoInc[IncIx: integer]: integer read GetAutoInc write SetAutoInc; default;
    property  NextInc[IncIx: integer]: integer read GetNextInc;
    property  SetReset[IncIx: integer]: string read GetSetReset write SetSetReset;
    property  SysMsg: string read GetSysMsg;
    property  SysMsgSet: boolean read GetSysMsgSet;
  end;

implementation

uses TErrors;

{ TAutoInc }

constructor TAutoInc.create;
begin
  Clear;
end;

{* Procedural Methods *}

function TAutoInc.Reset(RecordType: string): integer;
// We want to loop thru all 0-n elements of FReset. If we find a matching
// Record Type we set the respective 0-n counter to zero.
// We could have written:-
//       for i := 0 to MaxAutoIncs do
//         if FReset[i] := RecordType then
//           FAutoInc[i] := 0;
// However, this procedure could be called for every record read.
// If no AutoIncs are being used in the current import file, this procedure
// would do a lot of processing for nothing.
// Instead, we keep track of how many AutoIncReset record types have been registered
// and which ones. Then we only check those against the supplied Record Type;
var
  i: integer;
begin
  Result := 0;
  if FSetCounter = -1 then exit; // quickest get out available

  for i := 0 to MaxAutoIncs do begin
    if FSet[i] = -1 then exit;         // next quickest
    if FReset[FSet[i]] = RecordType then
      FAutoInc[FSet[i]] := 0; // don't "break" here because there may be more resets dependent on the same Record Type
  end;

end;

{* getters and setters *}

function TAutoInc.GetAutoInc(IncIx: integer): integer;
// get the value of the requested AutoInc counter
begin
  result := FAutoInc[IncIx];
end;

function TAutoInc.GetNextInc(IncIx: integer): integer;
// increment the requested AutoInc counter and return the new value
begin
  inc(FAutoInc[IncIx]);
  result := FAutoInc[IncIx];
end;

procedure TAutoInc.SetSetReset(IncIx: integer; const Value: string);
// Registers the record type in Value against the 0-n counter specified by IncIx.
// If the record type passed to Reset matches, FAutoInc[IncIx] will be set to zero.
begin
  FReset[IncIx] := value;

  inc(FSetCounter);             // register how many have been set
  FSet[FSetCounter] := IncIx;   // register which element has been set
end;

function TAutoInc.GetSysMsg: string;
begin
  result := TErrors.SysMsg;
end;

function TAutoInc.GetSysMsgSet: boolean;
begin
  result := TErrors.SysMsgSet;
end;

procedure TAutoInc.SetSysMsg(const Value: string);
begin
  TErrors.SetSysMsg(Value);
end;

function TAutoInc.GetSetReset(IncIx: integer): string;
begin
  result := FReset[IncIx];
end;

procedure TAutoInc.SetAutoInc(IncIx: integer; const Value: integer);
begin
  FAutoInc[IncIx] := Value;
end;

procedure TAutoInc.Clear;
begin
  FillChar(FSet, SizeOf(FSet), $FF); // set all elements to -1,  "not yet used"
  FSetCounter := -1;
  FillChar(FAutoInc, SizeOf(FAutoInc), $00);
end;

end.

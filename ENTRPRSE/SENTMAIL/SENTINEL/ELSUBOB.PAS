unit elsubob;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes, ElVar;

type
  TElertBaseObject = Class
  protected
    FCompany     : String[6];
    FRefNo       : String[12];
    FDataBuffer  : Array[1..MaxRecSize] of Char;
    FFileNo      : Word;
    FData        : Pointer;
    FFileNo      : Word;
    FDataSize    : Integer;
    FIndex       : Byte;
    function GetCompany : ShortString;
    procedure SetCompany(Value : ShortString);
    function GetRefNo : ShortString;
    procedure SetRefNo(Value : ShortString);
    function LJVar(const Value : String; len : integer) : String;
  public
    constructor Create;
    destructor Destroy; override;
    property Company : ShortString read GetCompany write SetCompany;
    property RefNo : ShortString read GetRefNo write SetRefNo;
    property Index : Byte read FIndex write FIndex;
  end;

  TElertObject = Class(TElertBaseObject)
  private
    FDataPointer : ^TElertRec;
  public
    constructor Create;
  end;

  TOutput = Class(TElertBaseObject);
  private
    FDataPointer : ^TElertOutputLine;
  public
    constructor Create;
  end;


  TAddress = Class(TElertBaseObject);
  private
    FDataPointer : ^TElertEmailAddressRec;
  public
    constructor Create;
  end;

  TSMS = Class(TElertBaseObject);
  private
    FDataPointer : ^TElertSMSRec;
  public
    constructor Create;
  end;

implementation

constructor TElertBaseObject.Create;
begin
  inherited Create;
  FillChar(DataBuffer, MaxRecSize, #0);
end;

destructor TElertBaseObject.Destroy;
begin
  inherited Destroy;
end;

function TElertBaseObject.GetCompany : ShortString;
begin
  Result := Trim(FCompany);
end;

procedure TElertBaseObject.SetCompany(Value : ShortString);
begin
  FCompany := LJVar(Value, 6);
end;

function TElertBaseObject.GetRefNo : ShortString;
begin
  Result := Trim(FRefNo);
end;

procedure TElertBaseObject.SetRefNo(Value : ShortString);
begin
  FRefNo := LJVar(Value, 12);
end;

function TElertBaseObject.LJVar(const Value : String; len : integer) : String;
begin
  Result := Value + StringOfChar(' ', len);
  Result := Copy(Result, 1, len);
end;

//------------------Elert object ------------------------

constructor TElertObject.Create;
begin
  inherited Create;
  FileNo := ElertF;
  FDataPointer := @FDataBuffer;
  FDataSize := SizeOf(ElertRec);
  FData := @ElertRec;
end;


//-----------------Output--------------------------------

constructor TOutput.Create;
begin
  inherited Create;
  FileNo := LineF;
  FDataPointer := @FDataBuffer;
  FDataSize := SizeOf(LineRec);
  FData := @LineRec;
end;

//------------------address

constructor TAddress.Create;
begin
  inherited Create;
  FileNo := AddressF;
  FData := @AddressRec;
  FDataSize := SizeOf(AddressRec);
  FDataPointer := @FDataBuffer;
end;

//--------------------SMS--------------

constructor TSMS.Create;
begin
  inherited Create;
  FileNo := SMSF;
  FData := @SMSRec;
  FDataSize := SizeOf(SMSRec);
  FDataPointer := @FDataBuffer;
end;

end.

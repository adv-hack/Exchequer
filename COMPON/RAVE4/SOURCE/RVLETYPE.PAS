{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVLEType;

interface

uses
  Classes, SysUtils, RVLEDef, RVLEUtil, RVUtil;

type
  TTypeHelper = class;
  TBaseTypeClass = class of TBaseType;
  TStructureType = class;

  TBaseType = class
  protected
    FTypeKind: TTypeKind;
    FTypeStruc: TTypeStruc;
    FSize: longint;
    FOwner: TObject; { TRCPUModule object that owns this type }
    FIndex: longint;
    function GetSize: longint; virtual;
    procedure SetOwner(Value: TObject);
  public
    constructor Create(ATypeKind: TTypeKind);
    constructor CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                       StreamHelper: TStreamHelper); virtual;
    procedure SaveToStreamHelper(TypeHelper: TTypeHelper;
                                 StreamHelper: TStreamHelper); virtual;

    function NeedFree: boolean; virtual;
    procedure FreeData(Data: pointer); virtual;

    property TypeStruc: TTypeStruc read FTypeStruc;
    property Size: longint read GetSize;
    property Index: longint read FIndex write FIndex;
    property Owner: TObject read FOwner write SetOwner;
    property TypeKind: TTypeKind read FTypeKind;
  end; { TBaseType }

  TSimpleType = class(TBaseType)
  protected
    FLow: longint;
    FHigh: longint;
    function GetSize: longint; override;
  public
    constructor Create(ATypeKind: TTypeKind;
                       ALow: longint;
                       AHigh: longint);
    constructor CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                       StreamHelper: TStreamHelper); override;
    procedure SaveToStreamHelper(TypeHelper: TTypeHelper;
                                 StreamHelper: TStreamHelper); override;
    property Low: longint read FLow;
    property High: longint read FHigh;
  end; { TSimpleType }

  TEnumeratedType = class(TBaseType)
  protected
    FHigh: byte;
    function GetSize: longint; override;
  public
    constructor Create;
    destructor Destroy; override;
    constructor CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                       StreamHelper: TStreamHelper); override;
    procedure SaveToStreamHelper(TypeHelper: TTypeHelper;
                                 StreamHelper: TStreamHelper); override;
    property High: byte read FHigh write FHigh;
  end; { TEnumeratedType }

  PRange = ^TRange;
  TRange = record
    Low: integer;
    High: integer;
    BaseType: TBaseType;
  end; { TRange }

  TArrayType = class(TBaseType)
  protected
    FElementType: TBaseType;
    FDim: TList;
    function GetDims: integer;
    function GetLow(Index: integer): integer;
    function GetHigh(Index: integer): integer;
    function GetCount(Index: integer): integer;
    function GetDimType(Index: integer): TBaseType;
    function GetDimSize(Index: integer): integer;
    function GetSize: longint; override;
  public
    constructor Create;
    destructor Destroy; override;
    constructor CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                       StreamHelper: TStreamHelper); override;
    procedure SaveToStreamHelper(TypeHelper: TTypeHelper;
                                 StreamHelper: TStreamHelper); override;
    procedure AddDim(Low: integer;
                     High: integer;
                     BaseType: TBaseType);
    function NeedFree: boolean; override;
    procedure FreeData(Data: pointer); override;

    property ElementType: TBaseType read FElementType write FElementType;
    property Dims: integer read GetDims;
    property Low[Index: integer]: integer read GetLow; { 0 based }
    property High[Index: integer]: integer read GetHigh; { 0 based }
    property Count[Index: integer]: integer read GetCount; { 0 based }
    property DimType[Index: integer]: TBaseType read GetDimType; { 0 based }
    property DimSize[Index: integer]: longint read GetDimSize; { 0 based }
  end; { TArrayType }

  TParamType = (ptValue,ptVar);
  PFuncParam = ^TFuncParam;
  TFuncParam = packed record
    ID: TIdentifier;
    BaseType: TBaseType;
    ParamType: TParamType;
    DefaultValue: longint; { Offset in code where constant value is stored }
    Offset: longint; { Address offset from BP }
  end; { TFuncParam }

  TFuncType = class(TBaseType)
  protected
    ParamList: TList;
    FResultType: TBaseType;

    function GetParam(Index: integer): PFuncParam;
    function GetParamAddr(Index: integer): TAddress;
    function GetParams: word;
  public
    constructor Create;
    destructor Destroy; override;
    constructor CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                       StreamHelper: TStreamHelper); override;
    procedure SaveToStreamHelper(TypeHelper: TTypeHelper;
                                 StreamHelper: TStreamHelper); override;
    function AddParam(AID: TIdentifier;
                      AParamType: TParamType): PFuncParam;
    function EqualTo(FuncType: TFuncType): boolean;

    property Param[Index: integer]: PFuncParam read GetParam;
    property ParamAddr[Index: integer]: TAddress read GetParamAddr;
    property Params: word read GetParams;
    property ResultType: TBaseType read FResultType write FResultType;
  end; { TFuncType }

  TMethodType = class(TFuncType)
  end; { TMethodType }

  TStructureMember = class
  protected
    FBaseType: TBaseType;
    FMemberType: TMemberType;
    FStructureType: TStructureType;
  public
    constructor CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                       StreamHelper: TStreamHelper;
                                       Structure: TStructureType); virtual;
    procedure SaveToStreamHelper(TypeHelper: TTypeHelper;
                                 StreamHelper: TStreamHelper); virtual;
    property BaseType: TBaseType read FBaseType write FBaseType;
    property MemberType: TMemberType read FMemberType write FMemberType;
    property StructureType: TStructureType read FStructureType write FStructureType;
  end; { TStructureMember }
  TStructureMemberClass = class of TStructureMember;

  TClassMember = class(TStructureMember)
  protected
    FScope: TScope;
  public
    constructor CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                       StreamHelper: TStreamHelper;
                                       Structure: TStructureType); override;
    procedure SaveToStreamHelper(TypeHelper: TTypeHelper;
                                 StreamHelper: TStreamHelper); override;
    property Scope: TScope read FScope write FScope;
  end; { TClassMember }

  TMethodOptions = (moVirtual,moOverride);
  TMethodOptionsSet = set of TMethodOptions;

  TMethodMember = class(TClassMember)
  protected
    FOptions: TMethodOptionsSet;
  public
    constructor CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                       StreamHelper: TStreamHelper;
                                       Structure: TStructureType); override;
    procedure SaveToStreamHelper(TypeHelper: TTypeHelper;
                                 StreamHelper: TStreamHelper); override;
    property Options: TMethodOptionsSet read FOptions write FOptions;
  end; { TMethodMember }

  TPropertyMember = class(TClassMember)
  protected
    FReadIndex: integer;
    FWriteIndex: integer;
  public
    constructor CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                       StreamHelper: TStreamHelper;
                                       Structure: TStructureType); override;
    procedure SaveToStreamHelper(TypeHelper: TTypeHelper;
                                 StreamHelper: TStreamHelper); override;
    property ReadIndex: integer read FReadIndex write FReadIndex;
    property WriteIndex: integer read FWriteIndex write FWriteIndex;
  end; { TPropertyMember }

  TStructureType = class(TBaseType)
  protected
    FTypeList: TStringList; { List of TStructureMember objects }
    BaseSize: longint; { Used for BaseClass data size }

    function GetSize: longint; override;
  public
    constructor Create;
    destructor Destroy; override;
    constructor CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                       StreamHelper: TStreamHelper); override;
    procedure SaveToStreamHelper(TypeHelper: TTypeHelper;
                                 StreamHelper: TStreamHelper); override;
    function AddElement(ID: TIdentifier;
                        BaseType: TBaseType): TStructureMember;
    function FindMember(    ID: TIdentifier;
                            ValidScopes: TScopeSet;
                        var Offset: longint;
                        var Member: TStructureMember;
                        var Index: integer): boolean; virtual;
    function IndexToMember(    Index: integer;
                           var ID: string): TStructureMember;
    function NeedFree: boolean; override;
    procedure FreeData(Data: pointer); override;

    property TypeList: TStringList read FTypeList;
  end; { TStructureType }

  TRecordType = class(TStructureType)
  public
    constructor Create;
  end; { TRecordType }

  TClassType = class(TStructureType)
  protected
    FRaveInstanceSize: longint;
    FRaveClassParent: TClassType;
    FRaveClassName: TIdentifier;

    function GetSize: longint; override;
    function GetRaveInstanceSize: longint;
  public
    constructor Create(AClassParent: TClassType;
                       AClassName: TIdentifier);
    constructor CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                       StreamHelper: TStreamHelper); override;
    procedure SaveToStreamHelper(TypeHelper: TTypeHelper;
                                 StreamHelper: TStreamHelper); override;
    function FindMember(    ID: TIdentifier;
                            ValidScopes: TScopeSet;
                        var Offset: longint;
                        var Member: TStructureMember;
                        var Index: integer): boolean; override;
    function AddField(ID: TIdentifier;
                      BaseType: TBaseType;
                      Scope: TScope): TClassMember;
    function AddMethod(ID: TIdentifier;
                       BaseType: TBaseType;
                       Scope: TScope;
                       Options: TMethodOptionsSet): TMethodMember;
    function AddProperty(ID: TIdentifier;
                         BaseType: TBaseType;
                         Scope: TScope;
                         ReadIndex: integer;
                         WriteIndex: integer): TPropertyMember;

    property RaveClassParent: TClassType read FRaveClassParent;
    property RaveClassName: TIdentifier read FRaveClassName;
    property RaveInstanceSize: longint read GetRaveInstanceSize;
  end; { TClassType }

  TTypeHelper = class
  public
    function IndexToType(ModuleIndex: longint;
                         TypeIndex: longint): TBaseType; virtual; abstract;
    procedure TypeToIndex(    BaseType: TBaseType;
                          var ModuleIndex: longint;
                          var TypeIndex: longint); virtual; abstract;
  end; { TTypeHelper }

  TTypeManager = class
  private
    TypeList: TList; { List of TBaseType }
    TypeHelper: TTypeHelper;
  protected
    FOwner: TObject;
  public
    constructor Create(AOwner: TObject;
                       ATypeHelper: TTypeHelper);
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromStreamHelper(StreamHelper: TStreamHelper);
    procedure SaveToStreamHelper(StreamHelper: TStreamHelper);
    function Add(BaseType: TBaseType): TBaseType;
    function Get(Index: longint): TBaseType;
  end; { TTypeManager }

const
  TypeTypes: array[TTypeStruc] of TBaseTypeClass = (
   TSimpleType,TEnumeratedType,TArrayType,TRecordType,
   TFuncType,TClassType);
  MemberTypes: array[TMemberType] of TStructureMemberClass = (
   TStructureMember,TClassMember,TMethodMember,TPropertyMember);

{ Global types used for quick access to common types }
{ Don't need to free since the TypeManager for SYSTEM will }
  BooleanType: TSimpleType = nil;
  IntegerType: TSimpleType = nil;
  ExtendedType: TSimpleType = nil;
  CurrencyType: TSimpleType = nil;
  CharType: TSimpleType = nil;
  StringType: TSimpleType = nil;
  OrdFunc: TFuncType = nil;

implementation

uses
  RPDefine;

(*****************************************************************************}
( class TBaseType
(*****************************************************************************)

  constructor TBaseType.Create(ATypeKind: TTypeKind);

  begin { Create }
    inherited Create;
    FTypeStruc := tsSimple;
    FSize := 0;
    FTypeKind := ATypeKind;
    FOwner := nil;
  end;  { Create }

  constructor TBaseType.CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                               StreamHelper: TStreamHelper);

  begin { CreateFromStreamHelper }
    inherited Create;
    StreamHelper.ReadBuf(FTypeStruc,SizeOf(FTypeStruc));
    StreamHelper.ReadBuf(FSize,SizeOf(FSize));
    StreamHelper.ReadBuf(FTypeKind,SizeOf(FTypeKind));
    FOwner := nil;
  end;  { CreateFromStreamHelper }

  procedure TBaseType.SaveToStreamHelper(TypeHelper: TTypeHelper;
                                         StreamHelper: TStreamHelper);

  begin { SaveToStreamHelper }
    StreamHelper.WriteBuf(FTypeStruc,SizeOf(FTypeStruc));
    StreamHelper.WriteBuf(FSize,SizeOf(FSize));
    StreamHelper.WriteBuf(FTypeKind,SizeOf(FTypeKind));
  end;  { SaveToStreamHelper }

  function TBaseType.GetSize: integer;

  begin { GetSize }
    Result := FSize;
  end;  { GetSize }

  procedure TBaseType.SetOwner(Value: TObject);

  begin { SetOwner }
    If FOwner = nil then begin
      FOwner := Value;
    end; { if }
  end;  { SetOwner }

  function TBaseType.NeedFree: boolean;

  begin { NeedFree }
    Result := (TypeKind = tkString);
  end;  { NeedFree }

  procedure TBaseType.FreeData(Data: pointer);

  begin { FreeData }
    If TypeKind = tkString then begin
      Finalize(string(longint(Data^)));
    end; { if }
  end;  { FreeData }

(*****************************************************************************}
( class TSimpleType
(*****************************************************************************)

  constructor TSimpleType.Create(ATypeKind: TTypeKind;
                                 ALow: longint;
                                 AHigh: longint);

  begin { Create }
    inherited Create(ATypeKind);
    FLow := ALow;
    FHigh := AHigh;
  end;  { Create }

  constructor TSimpleType.CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                                 StreamHelper: TStreamHelper);

  begin { CreateFromStreamHelper }
    inherited CreateFromStreamHelper(TypeHelper,StreamHelper);
    StreamHelper.ReadBuf(FLow,SizeOf(FLow));
    StreamHelper.ReadBuf(FHigh,SizeOf(FHigh));
  end;  { CreateFromStreamHelper }

  procedure TSimpleType.SaveToStreamHelper(TypeHelper: TTypeHelper;
                                           StreamHelper: TStreamHelper);

  begin { SaveToStreamHelper }
    inherited SaveToStreamHelper(TypeHelper,StreamHelper);
    StreamHelper.WriteBuf(FLow,SizeOf(FLow));
    StreamHelper.WriteBuf(FHigh,SizeOf(FHigh));
  end;  { SaveToStreamHelper }

  function TSimpleType.GetSize: integer;

  begin { GetSize }
    If FSize = 0 then begin
      FSize := TypeSize[FTypeKind];
    { UseWideChar and tkChar? }
    end; { if }
    Result := FSize;
  end;  { GetSize }

(*****************************************************************************}
( class TEnumeratedType
(*****************************************************************************)

  constructor TEnumeratedType.Create;

  begin { Create }
    inherited Create(tkByte);
    FTypeStruc := tsEnumerated;
    FHigh := 0;
  end;  { Create }

  destructor TEnumeratedType.Destroy;

  begin { Destroy }
    inherited Destroy;
  end;  { Destroy }

  constructor TEnumeratedType.CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                                     StreamHelper: TStreamHelper);

  begin { CreateFromStreamHelper }
    inherited CreateFromStreamHelper(TypeHelper,StreamHelper);
    StreamHelper.ReadBuf(FHigh,SizeOf(FHigh));
  end;  { CreateFromStreamHelper }

  procedure TEnumeratedType.SaveToStreamHelper(TypeHelper: TTypeHelper;
                                               StreamHelper: TStreamHelper);

  begin { SaveToStreamHelper }
    inherited SaveToStreamHelper(TypeHelper,StreamHelper);
    StreamHelper.WriteBuf(FHigh,SizeOf(FHigh));
  end;  { SaveToStreamHelper }

  function TEnumeratedType.GetSize: integer;

  begin { GetSize }
    FSize := 1;
    Result := 1;
  end;  { GetSize }

(*****************************************************************************}
( class TArrayType
(*****************************************************************************)

  constructor TArrayType.Create;

  begin { Create }
    inherited Create(tkComplex);
    FTypeStruc := tsArray;
    FElementType := nil;
    FDim := TList.Create;
  end;  { Create }

  destructor TArrayType.Destroy;

  begin { Destroy }
    While FDim.Count > 0 do begin
      Dispose(PRange(FDim[FDim.Count - 1]));
      FDim.Delete(FDim.Count - 1);
    end; { while }
    FreeAndNil(FDim);
    inherited Destroy;
  end;  { Destroy }

  constructor TArrayType.CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                                StreamHelper: TStreamHelper);

  var
    I1: longint;
    I2: longint;
    Range: PRange;
    ModuleIndex: longint;
    TypeIndex: longint;

  begin { CreateFromStreamHelper }
    inherited CreateFromStreamHelper(TypeHelper,StreamHelper);
    FDim := TList.Create;
    With StreamHelper do begin
      I2 := ReadIndex;
      For I1 := 1 to I2 do begin
        New(Range);
        Range.Low := ReadIndex;
        Range.High := ReadIndex;
        ModuleIndex := ReadIndex;
        TypeIndex := ReadIndex;
        Range.BaseType := TypeHelper.IndexToType(ModuleIndex,TypeIndex);
        FDim.Add(Range);
      end; { for }
      ModuleIndex := ReadIndex;
      TypeIndex := ReadIndex;
      FElementType := TypeHelper.IndexToType(ModuleIndex,TypeIndex);
    end; { with }
  end;  { CreateFromStreamHelper }

  procedure TArrayType.SaveToStreamHelper(TypeHelper: TTypeHelper;
                                          StreamHelper: TStreamHelper);

  var
    I1: integer;
    ModuleIndex: longint;
    TypeIndex: longint;

  begin { SaveToStreamHelper }
    inherited SaveToStreamHelper(TypeHelper,StreamHelper);
    With StreamHelper do begin
      WriteIndex(FDim.Count);
      For I1 := 0 to (FDim.Count - 1) do begin
        With PRange(FDim[I1])^ do begin
          WriteIndex(Low);
          WriteIndex(High);
          TypeHelper.TypeToIndex(BaseType,ModuleIndex,TypeIndex);
          WriteIndex(ModuleIndex);
          WriteIndex(TypeIndex);
        end; { with }
      end; { for }
      TypeHelper.TypeToIndex(FElementType,ModuleIndex,TypeIndex);
      WriteIndex(ModuleIndex);
      WriteIndex(TypeIndex);
    end; { with }
  end;  { SaveToStreamHelper }

  function TArrayType.GetLow(Index: integer): integer;

  begin { GetLow }
    If (Index < 0) or (Index >= Dims) then begin
      Result := 0;
    end else begin
      Result := PRange(FDim[Index]).Low;
    end; { else }
  end;  { GetLow }

  function TArrayType.GetHigh(Index: integer): integer;

  begin { GetHigh }
    If (Index < 0) or (Index >= Dims) then begin
      Result := 0;
    end else begin
      Result := PRange(FDim[Index]).High;
    end; { else }
  end;  { GetHigh }

  function TArrayType.GetCount(Index: integer): integer;

  begin { GetCount }
    Result := High[Index] - Low[Index] + 1;
  end;  { GetCount }

  function TArrayType.GetDimType(Index: integer): TBaseType;

  begin { GetDimType }
    If (Index < 0) or (Index >= Dims) then begin
      Result := nil;
    end else begin
      Result := PRange(FDim[Index]).BaseType;
    end; { else }
  end;  { GetDimType }

{ Pass in Index = -1 to get size of entire array }
  function TArrayType.GetDimSize(Index: integer): longint;

  begin { GetDimSize }
    If Index = (Dims - 1) then begin
      Result := ElementType.Size;
    end else begin
      Result := Count[Index + 1] * DimSize[Index + 1];
    end; { if }
  end;  { GetDimSize }

  procedure TArrayType.AddDim(Low: integer;
                              High: integer;
                              BaseType: TBaseType);

  var
    Range: PRange;

  begin { AddDim }
    New(Range);
    Range.Low := Low;
    Range.High := High;
    Range.BaseType := BaseType;
    FDim.Add(Range);
  end;  { AddDim }

  function TArrayType.GetDims: integer;

  begin { GetDims }
    Result := FDim.Count;
  end;  { GetDims }

  function TArrayType.GetSize: integer;

  begin { GetSize }
    If FSize = 0 then begin
      FSize := DimSize[-1];
    end; { if }
    Result := FSize;
  end;  { GetSize }

  function TArrayType.NeedFree: boolean;

  begin { NeedFree }
    Result := FElementType.NeedFree;
  end;  { NeedFree }

  procedure TArrayType.FreeData(Data: pointer);

  var
    I1: longint;
    I2: longint;
    I3: longint;

  begin { FreeData }
    If FElementType.NeedFree then begin
    { Get total number of elements }
      I2 := 1;
      For I1 := 0 to Dims - 1 do begin
        I2 := I2 * Count[I1];
      end; { for }

    { Free each element }
      I3 := FElementType.Size;
      For I1 := 1 to I2 do begin
        FElementType.FreeData(Data);
        Data := pointer(longint(Data) + I3);
      end; { for }
    end; { if }
  end;  { FreeData }

(*****************************************************************************}
( class TStructureMember
(*****************************************************************************)

  constructor TStructureMember.CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                                      StreamHelper: TStreamHelper;
                                                      Structure: TStructureType);

  var
    ModuleIndex: longint;
    TypeIndex: longint;

  begin { CreateFromStreamHelper }
    FMemberType := TMemberType(StreamHelper.ReadByte);
    ModuleIndex := StreamHelper.ReadIndex;
    TypeIndex := StreamHelper.ReadIndex;
    FBaseType := TypeHelper.IndexToType(ModuleIndex,TypeIndex);
    FStructureType := Structure;
  end;  { CreateFromStreamHelper }

  procedure TStructureMember.SaveToStreamHelper(TypeHelper: TTypeHelper;
                                                StreamHelper: TStreamHelper);

  var
    ModuleIndex: longint;
    TypeIndex: longint;

  begin { SaveToStreamHelper }
    StreamHelper.WriteByte(Ord(FMemberType));
    TypeHelper.TypeToIndex(FBaseType,ModuleIndex,TypeIndex);
    StreamHelper.WriteIndex(ModuleIndex);
    StreamHelper.WriteIndex(TypeIndex);
  end;  { SaveToStreamHelper }

(*****************************************************************************}
( class TClassMember
(*****************************************************************************)

  constructor TClassMember.CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                                  StreamHelper: TStreamHelper;
                                                  Structure: TStructureType);

  begin { CreateFromStreamHelper }
    inherited CreateFromStreamHelper(TypeHelper,StreamHelper,Structure);
    FScope := TScope(StreamHelper.ReadByte);
  end;  { CreateFromStreamHelper }

  procedure TClassMember.SaveToStreamHelper(TypeHelper: TTypeHelper;
                                            StreamHelper: TStreamHelper);

  begin { SaveToStreamHelper }
    inherited SaveToStreamHelper(TypeHelper,StreamHelper);
    StreamHelper.WriteByte(Ord(FScope));
  end;  { SaveToStreamHelper }

(*****************************************************************************}
( class TMethodMember
(*****************************************************************************)

  constructor TMethodMember.CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                                   StreamHelper: TStreamHelper;
                                                   Structure: TStructureType);

  begin { CreateFromStreamHelper }
    inherited CreateFromStreamHelper(TypeHelper,StreamHelper,Structure);
    StreamHelper.ReadBuf(FOptions,SizeOf(FOptions));
  end;  { CreateFromStreamHelper }

  procedure TMethodMember.SaveToStreamHelper(TypeHelper: TTypeHelper;
                                             StreamHelper: TStreamHelper);

  begin { SaveToStreamHelper }
    inherited SaveToStreamHelper(TypeHelper,StreamHelper);
    StreamHelper.WriteBuf(FOptions,SizeOf(FOptions));
  end;  { SaveToStreamHelper }

(*****************************************************************************}
( class TPropertyMember
(*****************************************************************************)

  constructor TPropertyMember.CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                                     StreamHelper: TStreamHelper;
                                                     Structure: TStructureType);

  begin { CreateFromStreamHelper }
    inherited CreateFromStreamHelper(TypeHelper,StreamHelper,Structure);
    FReadIndex := StreamHelper.ReadIndex;
    FWriteIndex := StreamHelper.ReadIndex;
  end;  { CreateFromStreamHelper }

  procedure TPropertyMember.SaveToStreamHelper(TypeHelper: TTypeHelper;
                                               StreamHelper: TStreamHelper);

  begin { SaveToStreamHelper }
    inherited SaveToStreamHelper(TypeHelper,StreamHelper);
    StreamHelper.WriteIndex(FReadIndex);
    StreamHelper.WriteIndex(FWriteIndex);
  end;  { SaveToStreamHelper }

(*****************************************************************************}
( class TStructureType
(*****************************************************************************)

  constructor TStructureType.Create;

  begin { Create }
    inherited Create(tkComplex);
    FTypeList := TStringList.Create;
  end;  { Create }

  destructor TStructureType.Destroy;

  begin { Destroy }
    ClearStringList(FTypeList);
    FreeAndNil(FTypeList);
    inherited Destroy;
  end;  { Destroy }

  constructor TStructureType.CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                                    StreamHelper: TStreamHelper);

  var
    I1: longint;
    I2: longint;
    ID: TIdentifier;
    MemberType: TMemberType;

  begin { CreateFromStreamHelper }
    inherited CreateFromStreamHelper(TypeHelper,StreamHelper);
    FTypeList := TStringList.Create;
    With StreamHelper do begin
      I2 := ReadIndex;
      For I1 := 1 to I2 do begin
        ID := ReadString;
        SavePos;
        ReadBuf(MemberType,SizeOf(MemberType));
        RestorePos;
        FTypeList.AddObject(ID,MemberTypes[MemberType].CreateFromStreamHelper(
         TypeHelper,StreamHelper,self));
      end; { for }
    end; { with }
  end;  { CreateFromStreamHelper }

  procedure TStructureType.SaveToStreamHelper(TypeHelper: TTypeHelper;
                                              StreamHelper: TStreamHelper);

  var
    I1: integer;

  begin { SaveToStreamHelper }
    inherited SaveToStreamHelper(TypeHelper,StreamHelper);
    With StreamHelper do begin
      WriteIndex(FTypeList.Count);
      For I1 := 0 to (FTypeList.Count - 1) do begin
        WriteString(FTypeList.Strings[I1]);
        TStructureMember(FTypeList.Objects[I1]).SaveToStreamHelper(TypeHelper,
         StreamHelper);
      end; { for }
    end; { with }
  end;  { SaveToStreamHelper }

  function TStructureType.AddElement(ID: TIdentifier;
                                     BaseType: TBaseType): TStructureMember;

  begin { AddElement }
    Result := TStructureMember.Create;
    Result.MemberType := mtElement;
    Result.BaseType := BaseType;
    Result.StructureType := self;
    FTypeList.AddObject(ID,Result);
  end;  { AddElement }

  function TStructureType.GetSize: integer;

  var
    I1: integer;

  begin { GetSize }
    If FSize = 0 then begin
      FSize := 0;
      For I1 := 0 to TypeList.Count - 1 do begin
        FSize := FSize + TStructureMember(FTypeList.Objects[I1]).BaseType.Size;
      end; { for }
    end; { if }
    Result := FSize;
  end;  { GetSize }

  function TStructureType.FindMember(    ID: TIdentifier;
                                         ValidScopes: TScopeSet;
                                     var Offset: longint;
                                     var Member: TStructureMember;
                                     var Index: integer): boolean;

  var
    I1: integer;

  begin { FindMember }
    Offset := BaseSize;
    For I1 := 0 to TypeList.Count - 1 do begin
      Member := TStructureMember(TypeList.Objects[I1]);
      If SameStr(ID,TypeList.Strings[I1]) then begin
        Result := true;
        Index := I1 + 1;
        Exit;
      end; { if }
      Inc(Offset,Member.BaseType.Size);
    end; { for }

  { Item not found }
    Offset := 0;
    Member := nil;
    Index := 0;
    Result := false;
  end;  { FindMember }

  function TStructureType.IndexToMember(    Index: integer;
                                        var ID: string): TStructureMember;

  begin { IndexToMember }
    If (Index <= 0) or (Index > TypeList.Count) then begin
      ID := '';
      Result := nil;
    end else begin
      ID := TypeList[Index - 1];
      Result := TStructureMember(TypeList.Objects[Index - 1]);
    end; { else }
  end;  { IndexToMember }

  function TStructureType.NeedFree: boolean;

  var
    I1: integer;

  begin { NeedFree }
    Result := false;
    For I1 := 0 to FTypeList.Count - 1 do begin
      Result := TStructureMember(FTypeList.Objects[I1]).BaseType.NeedFree;
      If Result then Break;
    end; { for }
  end;  { NeedFree }

  procedure TStructureType.FreeData(Data: pointer);

  var
    I1: integer;
    BaseType: TBaseType;

  begin { FreeData }
    For I1 := 0 to FTypeList.Count - 1 do begin
      BaseType := TBaseType(FTypeList.Objects[I1]);
      BaseType.FreeData(Data);
      Data := pointer(longint(Data) + BaseType.Size);
    end; { for }
  end;  { FreeData }

(*****************************************************************************}
( class TRecordType
(*****************************************************************************)

  constructor TRecordType.Create;

  begin { Create }
    inherited Create;
    FTypeStruc := tsRecord;
  end;  { Create }

(*****************************************************************************}
( class TClassType
(*****************************************************************************)

  constructor TClassType.Create(AClassParent: TClassType;
                                AClassName: TIdentifier);

  begin { Create }
    inherited Create;
    FRaveClassParent := AClassParent;
    FRaveClassName := AClassName;
    FRaveInstanceSize := -1;
    FTypeStruc := tsClass;
  end;  { Create }

  constructor TClassType.CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                                StreamHelper: TStreamHelper);

  var
    ModuleIndex: longint;
    TypeIndex: longint;

  begin { CreateFromStreamHelper }
    inherited CreateFromStreamHelper(TypeHelper,StreamHelper);
    FTypeStruc := tsClass;
    With StreamHelper do begin
      ModuleIndex := ReadIndex;
      TypeIndex := ReadIndex;
      FRaveClassName := ReadString;
      FRaveInstanceSize := ReadIndex;
      FRaveClassParent := TypeHelper.IndexToType(ModuleIndex,TypeIndex) as TClassType;
    end; { with }
  end;  { CreateFromStreamHelper }

  procedure TClassType.SaveToStreamHelper(TypeHelper: TTypeHelper;
                                          StreamHelper: TStreamHelper);

  var
    ModuleIndex: longint;
    TypeIndex: longint;

  begin { SaveToStreamHelper }
    inherited SaveToStreamHelper(TypeHelper,StreamHelper);
    With StreamHelper do begin
      If Assigned(RaveClassParent) then begin
        TypeHelper.TypeToIndex(RaveClassParent,ModuleIndex,TypeIndex);
        WriteIndex(ModuleIndex);
        WriteIndex(TypeIndex);
      end else begin
        WriteIndex(0);
        WriteIndex(0);
      end; { else }
      WriteString(FRaveClassName);
      WriteIndex(RaveInstanceSize);
    end; { with }
  end;  { SaveToStreamHelper }

  function TClassType.GetSize: integer;

  begin { GetSize }
    Result := 4;
  end;  { GetSize }

  function TClassType.GetRaveInstanceSize: integer;

  var
    I1: integer;

  begin { GetRaveInstanceSize }
    If FRaveInstanceSize = -1 then begin
      If Assigned(RaveClassParent) then begin
        FRaveInstanceSize := RaveClassParent.RaveInstanceSize;
      end else begin
        FRaveInstanceSize := 0;
      end; { else }
      For I1 := 0 to TypeList.Count - 1 do begin
        FRaveInstanceSize := FRaveInstanceSize +
         TStructureMember(FTypeList.Objects[I1]).BaseType.Size;
      end; { for }
    end; { if }
    Result := FRaveInstanceSize;
  end;  { GetRaveInstanceSize }

  function TClassType.FindMember(    ID: TIdentifier;
                                     ValidScopes: TScopeSet;
                                 var Offset: longint;
                                 var Member: TStructureMember;
                                 var Index: integer): boolean;

  begin { FindMember }
    Result := inherited FindMember(ID,ValidScopes,Offset,Member,Index);
    If not Result and Assigned(RaveClassParent) then begin
      Result := RaveClassParent.FindMember(ID,ValidScopes,Offset,Member,Index);
    end; { if }
  end;  { FindMember }

  function TClassType.AddField(ID: TIdentifier;
                               BaseType: TBaseType;
                               Scope: TScope): TClassMember;

  begin { AddField }
    Result := TClassMember.Create;
    Result.MemberType := mtField;
    Result.BaseType := BaseType;
    Result.Scope := Scope;
    Result.StructureType := self;
    FTypeList.AddObject(ID,Result);
  end;  { AddField }

  function TClassType.AddMethod(ID: TIdentifier;
                                BaseType: TBaseType;
                                Scope: TScope;
                                Options: TMethodOptionsSet): TMethodMember;

  begin { AddMethod }
    Result := TMethodMember.Create;
    Result.MemberType := mtMethod;
    Result.BaseType := BaseType;
    Result.Scope := Scope;
    Result.Options := Options;
    Result.StructureType := self;
    FTypeList.AddObject(ID,Result);
  end;  { AddMethod }

  function TClassType.AddProperty(ID: TIdentifier;
                                  BaseType: TBaseType;
                                  Scope: TScope;
                                  ReadIndex: integer;
                                  WriteIndex: integer): TPropertyMember;

  begin { AddProperty }
    Result := TPropertyMember.Create;
    Result.MemberType := mtProperty;
    Result.BaseType := BaseType;
    Result.Scope := Scope;
    Result.ReadIndex := ReadIndex;
    Result.WriteIndex := WriteIndex;
    Result.StructureType := self;
    FTypeList.AddObject(ID,Result);
  end;  { AddProperty }

(*****************************************************************************}
( class TFuncType
(*****************************************************************************)

  constructor TFuncType.Create;

  begin { Create }
    inherited Create(tkComplex);
    FTypeStruc := tsFunction;
    ParamList := TList.Create;
  end;  { Create }

  destructor TFuncType.Destroy;

  var
    I1: integer;

  begin { Destroy }
    For I1 := 0 to ParamList.Count - 1 do begin
      Dispose(PFuncParam(ParamList[I1]));
    end; { for }
    FreeAndNil(ParamList);
    inherited Destroy;
  end;  { Destroy }

  constructor TFuncType.CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                               StreamHelper: TStreamHelper);

  var
    I1: integer;
    I2: integer;
    ModuleIndex: longint;
    TypeIndex: longint;
    S1: TIdentifier;
    PT1: TParamType;

  begin { CreateFromStreamHelper }
    inherited CreateFromStreamHelper(TypeHelper,StreamHelper);
    FTypeStruc := tsFunction;
    ParamList := TList.Create;
    With StreamHelper do begin
      I2 := StreamHelper.ReadIndex;
      For I1 := 1 to I2 do begin
        S1 := ReadString;
        ReadBuf(PT1,SizeOf(PT1));
        With AddParam(S1,PT1)^ do begin
          ModuleIndex := ReadIndex;
          TypeIndex := ReadIndex;
          BaseType := TypeHelper.IndexToType(ModuleIndex,TypeIndex);
          DefaultValue := ReadIndex;
          Offset := ReadIndex;
        end; { with }
      end; { for }
      ModuleIndex := ReadIndex;
      TypeIndex := ReadIndex;
      ResultType := TypeHelper.IndexToType(ModuleIndex,TypeIndex);
    end; { with }
  end;  { CreateFromStreamHelper }

  procedure TFuncType.SaveToStreamHelper(TypeHelper: TTypeHelper;
                                         StreamHelper: TStreamHelper);

  var
    I1: integer;
    ModuleIndex: longint;
    TypeIndex: longint;

  begin { SaveToStreamHelper }
    inherited SaveToStreamHelper(TypeHelper,StreamHelper);
    With StreamHelper do begin
      WriteIndex(Params);
      For I1 := 0 to Params - 1 do begin
        With Param[I1]^ do begin
          WriteString(ID);
          WriteBuf(ParamType,SizeOf(ParamType));
          TypeHelper.TypeToIndex(BaseType,ModuleIndex,TypeIndex);
          WriteIndex(ModuleIndex);
          WriteIndex(TypeIndex);
          WriteIndex(DefaultValue);
          WriteIndex(Offset);
        end; { with }
      end; { for }
      If Assigned(ResultType) then begin
        TypeHelper.TypeToIndex(ResultType,ModuleIndex,TypeIndex);
        WriteIndex(ModuleIndex);
        WriteIndex(TypeIndex);
      end else begin
        WriteIndex(0);
        WriteIndex(0);
      end; { else }
    end; { with }
  end;  { SaveToStreamHelper }

  function TFuncType.AddParam(AID: TIdentifier;
                              AParamType: TParamType): PFuncParam;

  begin { AddParam }
    New(Result);
    With Result^ do begin
      ID := AID;
      BaseType := nil;
      ParamType := AParamType;
      DefaultValue := 0;
      Offset := 0;
    end; { with }
    ParamList.Add(Result);
  end;  { AddParam }

  function TFuncType.GetParam(Index: integer): PFuncParam;

  begin { GetParam }
    If (Index >= 0) and (Index < Params) then begin
      Result := PFuncParam(ParamList[Index]);
    end else begin
      Result := nil;
    end; { else }
  end;  { GetParam }

  function TFuncType.GetParamAddr(Index: integer): TAddress;

  begin { GetParamAddr }
    Result.Loc := alBP;
    Result.Module := 0;
    Result.Offset := 12;
    If (Index >= 0) and (Index < Params) then begin
      Result.Offset := Result.Offset + (Params - (Index + 1)) * 4;
    end else begin
      Result.Offset := Result.Offset + Params * 4;
    end; { if }
  end;  { GetParamAddr }

  function TFuncType.GetParams: word;

  begin { GetParams }
    Result := ParamList.Count;
  end;  { GetParams }

  function TFuncType.EqualTo(FuncType: TFuncType): boolean;

  var
    I1: integer;
    P1: PFuncParam;
    P2: PFuncParam;

  begin { EqualTo }
    Result := false;
    If (Params > 0) and (Params <> FuncType.Params) then Exit;
    For I1 := 0 to Params - 1 do begin
      P1 := Param[I1];
      P2 := FuncType.Param[I1];
      If not SameStr(P1.ID,P2.ID) or (P1.BaseType <> P2.BaseType) or
       (P1.ParamType <> P2.ParamType) or (P1.DefaultValue <> P2.DefaultValue) then begin
        Exit;
      end; { if }
    end; { for }
    If ResultType <> FuncType.ResultType then Exit;
    Result := true;
  end;  { EqualTo }

(*****************************************************************************}
( class TTypeManager
(*****************************************************************************)

  constructor TTypeManager.Create(AOwner: TObject;
                                  ATypeHelper: TTypeHelper);

  begin { Create }
    inherited Create;
    FOwner := AOwner;
    TypeList := TList.Create;
    TypeHelper := ATypeHelper;
  end;  { Create }

  destructor TTypeManager.Destroy;

  begin { Destroy }
    Clear;
    FreeAndNil(TypeList);
    inherited Destroy;
  end;  { Destroy }

  procedure TTypeManager.Clear;

  begin { Clear }
    With TypeList do begin
      While Count > 0 do begin
        TObject(Items[Count - 1]).Free;
        Delete(Count - 1);
      end; { while }
    end; { with }
  end;  { Clear }

  procedure TTypeManager.LoadFromStreamHelper(StreamHelper: TStreamHelper);

  var
    I1: integer;
    I2: integer;
    TypeStruc: TTypeStruc;

  begin { LoadFromStreamHelper }
    With StreamHelper do begin
      I2 := ReadIndex;
      For I1 := 1 to I2 do begin
        SavePos;
        ReadBuf(TypeStruc,SizeOf(TypeStruc));
        RestorePos;
        Add(TypeTypes[TypeStruc].CreateFromStreamHelper(TypeHelper,StreamHelper));
      end; { for }
    end; { with }
  end;  { LoadFromStreamHelper }

  procedure TTypeManager.SaveToStreamHelper(StreamHelper: TStreamHelper);

  var
    I1: integer;

  begin { SaveToStreamHelper }
  { Save out TypeList }
    StreamHelper.WriteIndex(TypeList.Count);
    For I1 := 0 to (TypeList.Count - 1) do begin
      TBaseType(TypeList[I1]).SaveToStreamHelper(TypeHelper,StreamHelper);
    end; { for }
  end;  { SaveToStreamHelper }

  function TTypeManager.Add(BaseType: TBaseType): TBaseType;

  begin { Add }
    BaseType.Owner := FOwner;
    BaseType.Index := TypeList.Count + 1;
    TypeList.Add(BaseType);
    Result := BaseType;
  end;  { Add }

  function TTypeManager.Get(Index: longint): TBaseType;

  begin { Get }
    Result := TBaseType(TypeList[Index]);
  end;  { Get }

end.

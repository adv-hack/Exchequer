{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVLEID;

interface

uses
  Classes, SysUtils, RVLEDef, RVLEUtil, RVLEType, RVUtil;

type
  TBaseIDClass = class of TBaseID;

  TBaseID = class
  protected
    FBaseType: TBaseType;
    FID: TIdentifier;
    FIDKind: TIDKind;
    FModule: longint;

    procedure SetModule(Value: longint); virtual;
  public
    constructor Create(AIDKind: TIDKind;
                       AID: TIdentifier;
                       ABaseType: TBaseType);
    constructor CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                       StreamHelper: TStreamHelper); virtual;
    procedure SaveToStreamHelper(TypeHelper: TTypeHelper;
                                 StreamHelper: TStreamHelper); virtual;

    property BaseType: TBaseType read FBaseType;
    property ID: TIdentifier read FID;
    property IDKind: TIDKind read FIDKind;
    property Module: longint read FModule write SetModule;
  end; { TBaseID }

  TTypeID = class(TBaseID)
  public
    constructor Create(AID: TIdentifier;
                       ABaseType: TBaseType);
  end; { TTypeID }

  TVarID = class(TBaseID)
  protected
    FAddress: TAddress;

    procedure SetModule(Value: longint); override;
  public
    constructor Create(AID: TIdentifier;
                       ABaseType: TBaseType;
                       AAddress: longint;
                       AAddressLoc: TAddressLoc);
    constructor CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                       StreamHelper: TStreamHelper); override;
    procedure SaveToStreamHelper(TypeHelper: TTypeHelper;
                                 StreamHelper: TStreamHelper); override;
    property Address: TAddress read FAddress write FAddress;
  end; { TVarID }

  TConstID = class(TBaseID)
    FData: pointer;
    FDataSize: longint;
  public
    constructor Create(    AID: TIdentifier;
                           ABaseType: TBaseType;
                       var AData;
                           ADataSize: longint);
    constructor CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                       StreamHelper: TStreamHelper); override;
    procedure SaveToStreamHelper(TypeHelper: TTypeHelper;
                                 StreamHelper: TStreamHelper); override;
    destructor Destroy; override;
    procedure GetData(var Buffer);
    property Data: pointer read FData;
    property DataSize: longint read FDataSize;
  end; { TConstID }

  TFuncID = class(TBaseID)
  protected
    FDefineLevel: byte; { 1=Defined 2=Implemented }
    FExecAddr: longint;
    FCodeLabel: TCodeLabel;
  public
    constructor Create(AID: TIdentifier;
                       ABaseType: TBaseType);
    constructor CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                       StreamHelper: TStreamHelper); override;
    procedure SaveToStreamHelper(TypeHelper: TTypeHelper;
                                 StreamHelper: TStreamHelper); override;
    property DefineLevel: byte read FDefineLevel write FDefineLevel;
    property ExecAddr: longint read FExecAddr write FExecAddr;
    property CodeLabel: TCodeLabel read FCodeLabel write FCodeLabel;
  end; { TFuncID }

  TMethodID = class(TFuncID)
  protected
  public
    constructor Create(AID: TIdentifier;
                       ABaseType: TBaseType);
    constructor CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                       StreamHelper: TStreamHelper); override;
    procedure SaveToStreamHelper(TypeHelper: TTypeHelper;
                                 StreamHelper: TStreamHelper); override;
  end; { TMethodID }

  TOpID = class(TBaseID)
  private
    FOpKind: TOpKind;
  public
    constructor Create(AID: TIdentifier;
                       AOpKind: TOpKind);
    constructor CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                       StreamHelper: TStreamHelper); override;
    procedure SaveToStreamHelper(TypeHelper: TTypeHelper;
                                 StreamHelper: TStreamHelper); override;
    property OpKind: TOpKind read FOpKind;
  end; { TOpID }

  TIDManager = class
  private
    IDList: TList;
    IDIdx: integer;
    TypeHelper: TTypeHelper;
  public
    constructor Create(ATypeHelper: TTypeHelper);
    destructor Destroy; override;
    procedure LoadFromStreamHelper(StreamHelper: TStreamHelper);
    procedure SaveToStreamHelper(StreamHelper: TStreamHelper);
    procedure Clear;
    function Add(IDObject: TBaseID): TBaseID;
    function Find(IDName: TIdentifier): TBaseID;
  end; { TIDManager }

const
  IDTypes: array[idkVar..idkOp] of TBaseIDClass = (
   TVarID,TTypeID,TConstID,TFuncID,TMethodID,TOpID);

implementation

uses
  RPDefine;

(*****************************************************************************}
( class TBaseID
(*****************************************************************************)

  constructor TBaseID.Create(AIDKind: TIDKind;
                             AID: TIdentifier;
                             ABaseType: TBaseType);

  begin { Create }
    inherited Create;
    FIDKind := AIDKind;
    FID := AID;
    FBaseType := ABaseType;
  end;  { Create }

  constructor TBaseID.CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                             StreamHelper: TStreamHelper);

  var
    ModuleIndex: longint;
    TypeIndex: longint;

  begin { CreateFromStreamHelper }
    inherited Create;
    StreamHelper.ReadBuf(FIDKind,SizeOf(FIDKind));
    FID := StreamHelper.ReadString;
    ModuleIndex := StreamHelper.ReadIndex;
    TypeIndex := StreamHelper.ReadIndex;
    FBaseType := TypeHelper.IndexToType(ModuleIndex,TypeIndex);
  end;  { CreateFromStreamHelper }

  procedure TBaseID.SaveToStreamHelper(TypeHelper: TTypeHelper;
                                       StreamHelper: TStreamHelper);

  var
    ModuleIndex: longint;
    TypeIndex: longint;

  begin { SaveToStreamHelper }
    StreamHelper.WriteBuf(FIDKind,SizeOf(FIDKind));
    StreamHelper.WriteString(FID);
    If not Assigned(BaseType) then begin
      ModuleIndex := 0;
      TypeIndex := 0;
    end else begin
      TypeHelper.TypeToIndex(BaseType,ModuleIndex,TypeIndex);
    end; { else }
    StreamHelper.WriteIndex(ModuleIndex);
    StreamHelper.WriteIndex(TypeIndex);
  end;  { SaveToStreamHelper }

  procedure TBaseID.SetModule(Value: longint);

  begin { SetModule }
    FModule := Value;
  end;  { SetModule }

(*****************************************************************************}
( class TTypeID
(*****************************************************************************)

  constructor TTypeID.Create(AID: TIdentifier;
                             ABaseType: TBaseType);

  begin { Create }
    inherited Create(idkType,AID,ABaseType);
  end;  { Create }

(*****************************************************************************}
( class TVarID
(*****************************************************************************)

  constructor TVarID.Create(AID: TIdentifier;
                            ABaseType: TBaseType;
                            AAddress: longint;
                            AAddressLoc: TAddressLoc);

  begin { Create }
    inherited Create(idkVar,AID,ABaseType);
    FAddress.Offset := AAddress;
    FAddress.Loc := AAddressLoc;
    FAddress.Module := 0;
  end;  { Create }

  constructor TVarID.CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                            StreamHelper: TStreamHelper);

  begin { CreateFromStreamHelper }
    inherited CreateFromStreamHelper(TypeHelper,StreamHelper);
    FAddress.Offset := StreamHelper.ReadIndex;
    StreamHelper.ReadBuf(FAddress.Loc,SizeOf(FAddress.Loc));
  end;  { CreateFromStreamHelper }

  procedure TVarID.SaveToStreamHelper(TypeHelper: TTypeHelper;
                                      StreamHelper: TStreamHelper);

  begin { SaveToStreamHelper }
    inherited SaveToStreamHelper(TypeHelper,StreamHelper);
    StreamHelper.WriteIndex(FAddress.Offset);
    StreamHelper.WriteBuf(FAddress.Loc,SizeOf(FAddress.Loc));
  end;  { SaveToStreamHelper }

  procedure TVarID.SetModule(Value: longint);

  begin { SetModule }
    inherited SetModule(Value);
    FAddress.Module := Value;
  end;  { SetModule }

(*****************************************************************************}
( class TConstID
(*****************************************************************************)

  constructor TConstID.Create(    AID: TIdentifier;
                                  ABaseType: TBaseType;
                              var AData;
                                  ADataSize: integer);

  begin { Create }
    inherited Create(idkConst,AID,ABaseType);
    FDataSize := ADataSize;
    GetMem(FData,DataSize);
    Move(AData,Data^,DataSize);
  end;  { Create }

  constructor TConstID.CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                              StreamHelper: TStreamHelper);

  begin { CreateFromStreamHelper }
    inherited CreateFromStreamHelper(TypeHelper,StreamHelper);
    FDataSize := StreamHelper.ReadIndex;
    GetMem(FData,DataSize);
    StreamHelper.ReadBuf(Data^,DataSize);
  end;  { CreateFromStreamHelper }

  procedure TConstID.SaveToStreamHelper(TypeHelper: TTypeHelper;
                                        StreamHelper: TStreamHelper);

  begin { SaveToStreamHelper }
    inherited SaveToStreamHelper(TypeHelper,StreamHelper);
    StreamHelper.WriteIndex(DataSize);
    StreamHelper.WriteBuf(Data^,DataSize);
  end;  { SaveToStreamHelper }

  destructor TConstID.Destroy;

  begin { Destroy }
    inherited Destroy;
    FreeMem(FData,DataSize);
  end;  { Destroy }

  procedure TConstID.GetData(var Buffer);

  begin { GetData }
    If BaseType.TypeKind = tkString then begin
      SetLength(string(Buffer),DataSize);
      If DataSize > 0 then begin
        Move(Data^,string(Buffer)[1],DataSize);
      end; { if }
    end else begin
      Move(Data^,Buffer,DataSize);
    end; { else }
  end;  { GetData }

(*****************************************************************************}
( class TFuncID
(*****************************************************************************)

  constructor TFuncID.Create(AID: TIdentifier;
                             ABaseType: TBaseType);

  begin { Create }
    inherited Create(idkFunc,AID,ABaseType);
    FDefineLevel := 0;
  end;  { Create }

  constructor TFuncID.CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                             StreamHelper: TStreamHelper);

  begin { CreateFromStreamHelper }
    inherited CreateFromStreamHelper(TypeHelper,StreamHelper);
    FCodeLabel.Offset := StreamHelper.ReadIndex;
    FExecAddr := StreamHelper.ReadIndex;
  end;  { CreateFromStreamHelper }

  procedure TFuncID.SaveToStreamHelper(TypeHelper: TTypeHelper;
                                       StreamHelper: TStreamHelper);

  begin { SaveToStreamHelper }
    inherited SaveToStreamHelper(TypeHelper,StreamHelper);
    StreamHelper.WriteIndex(FCodeLabel.Offset);
    StreamHelper.WriteIndex(FExecAddr);
  end;  { SaveToStreamHelper }

(*****************************************************************************}
( class TMethodID
(*****************************************************************************)

  constructor TMethodID.Create(AID: TIdentifier;
                               ABaseType: TBaseType);

  begin { Create }
    inherited Create(AID,ABaseType);
    FIDKind := idkMethod;
  end;  { Create }

  constructor TMethodID.CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                               StreamHelper: TStreamHelper);

  begin { CreateFromStreamHelper }
    inherited CreateFromStreamHelper(TypeHelper,StreamHelper);
  end;  { CreateFromStreamHelper }

  procedure TMethodID.SaveToStreamHelper(TypeHelper: TTypeHelper;
                                         StreamHelper: TStreamHelper);

  begin { SaveToStreamHelper }
    inherited SaveToStreamHelper(TypeHelper,StreamHelper);
  end;  { SaveToStreamHelper }

(*****************************************************************************}
( class TOpID
(*****************************************************************************)

  constructor TOpID.Create(AID: TIdentifier;
                                 AOpKind: TOpKind);

  begin { Create }
    inherited Create(idkOp,AID,nil);
    FOpKind := AOpKind;
  end;  { Create }

  constructor TOpID.CreateFromStreamHelper(TypeHelper: TTypeHelper;
                                           StreamHelper: TStreamHelper);

  begin { CreateFromStreamHelper }
    inherited CreateFromStreamHelper(TypeHelper,StreamHelper);
    StreamHelper.ReadBuf(FOpKind,SizeOf(FOpKind));
  end;  { CreateFromStreamHelper }

  procedure TOpID.SaveToStreamHelper(TypeHelper: TTypeHelper;
                                     StreamHelper: TStreamHelper);

  begin { SaveToStreamHelper }
    inherited SaveToStreamHelper(TypeHelper,StreamHelper);
    StreamHelper.WriteBuf(FOpKind,SizeOf(FOpKind));
  end;  { SaveToStreamHelper }

(*****************************************************************************}
( class TIDManager
(*****************************************************************************)

  constructor TIDManager.Create(ATypeHelper: TTypeHelper);

  begin { Create }
    inherited Create;
    IDList := TList.Create;
    TypeHelper := ATypeHelper;
  end;  { Create }

  destructor TIDManager.Destroy;

  begin { Destroy }
    Clear;
    FreeAndNil(IDList);
    inherited Destroy;
  end;  { Destroy }

  procedure TIDManager.LoadFromStreamHelper(StreamHelper: TStreamHelper);

  var
    I1: integer;
    I2: integer;
    IDKind: TIDKind;

  begin { LoadFromStreamHelper }
  { Read in all ID's }
    With StreamHelper do begin
      I2 := ReadIndex;
      For I1 := 1 to I2 do begin
        SavePos;
        ReadBuf(IDKind,SizeOf(IDKind));
        RestorePos;
        Add(IDTypes[IDKind].CreateFromStreamHelper(TypeHelper,StreamHelper));
      end; { for }
    end; { if }
  end;  { LoadFromStreamHelper }

  procedure TIDManager.SaveToStreamHelper(StreamHelper: TStreamHelper);

  var
    I1: integer;

  begin { SaveToStreamHelper }
  { Save out TypeList }
    StreamHelper.WriteIndex(IDList.Count);
    For I1 := 0 to (IDList.Count - 1) do begin
      TBaseID(IDList[I1]).SaveToStreamHelper(TypeHelper,StreamHelper);
    end; { for }
  end;  { SaveToStreamHelper }

  procedure TIDManager.Clear;

  begin { Clear }
    With IDList do begin
      While Count > 0 do begin
        TObject(Items[Count - 1]).Free;
        Delete(Count - 1);
      end; { while }
    end; { with }
  end;  { Clear }

  function TIDManager.Add(IDObject: TBaseID): TBaseID;

  var
    BaseID: TBaseID;

  begin { Add }
    BaseID := Find(IDObject.ID);
    If Assigned(BaseID) then begin
      Result := nil; { Error, Duplicate ID }
    end else begin
      Result := IDObject;
      IDList.Insert(IDIdx,IDObject);
    end; { else }
  end;  { Add }

  function TIDManager.Find(IDName: TIdentifier): TBaseID;

  var
    Low: integer;
    High: integer;
    SearchResult: integer;

  begin { Find }
  { Find ID that is equal or just greater than }
    With IDList do begin
      Low := 0;
      High := Count - 1;
      SearchResult := 0;
      While Low <= High do begin
        IDIdx := (Low + High) div 2;
        Result := TBaseID(IDList[IDIdx]);
        SearchResult := CompareText(IDName,Result.ID);
        If SearchResult = 0 then begin
          Exit;
        end else if SearchResult < 0 then begin { IDName < Result.ID }
          High := IDIdx - 1;
        end else begin  { IDName > Result.ID }
          Low := IDIdx + 1;
        end; { else }
      end; { while }
      If SearchResult > 0 then begin
        Inc(IDIdx);
      end; { if }
      Result := nil;
    end; { with }
  end;  { Find }

end.
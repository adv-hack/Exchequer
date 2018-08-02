{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVLEMod;

interface

{$DEFINE DOMAP}

uses
  TypInfo, WinTypes, WinProcs, Classes, SysUtils, RVClass, RVLEDef,
  RVLEID, RVLEType, RVDefine, RVUtil, RPDefine, Dialogs;

type
  TRCPUModule = class;
  TRaveCompiler = class;

  TScopeManager = class
  private
    DataIdx: longint;
  protected
    FOwner: TRCPUModule;
    FParent: TScopeManager;
    FTypeManager: TTypeManager;
    FIDManager: TIDManager;
  public
    constructor Create(AParent: TScopeManager;
                       AOwner: TRCPUModule);
    destructor Destroy; override;
    procedure LoadFromStreamHelper(StreamHelper: TStreamHelper);
    procedure SaveToStreamHelper(StreamHelper: TStreamHelper);
    function FindID(ID: TIdentifier): TBaseID;
    function AddType(ID: TIdentifier;
                     BaseType: TBaseType): TTypeID;
    function AddVar(ID: TIdentifier;
                    BaseType: TBaseType): TVarID;
    function AddOp(ID: TIdentifier;
                   OpKind: TOpKind): TOpID;
    function AddFunc(ID: TIdentifier;
                     BaseType: TBaseType): TFuncID;
    function AddConst(    ID: TIdentifier;
                          BaseType: TBaseType;
                      var Data): TConstID;
    procedure ClearData;

    property Owner: TRCPUModule read FOwner;
    property Parent: TScopeManager read FParent;
    property TypeManager: TTypeManager read FTypeManager;
    property IDManager: TIDManager read FIDManager;
    property DataSize: longint read DataIdx write DataIdx;
  end; { TScopeManager }

  TModuleTypeHelper = class(TTypeHelper)
    FModule: TRCPUModule;
  public
    constructor Create(AModule: TRCPUModule);

    function IndexToType(ModuleIndex: longint;
                         TypeIndex: longint): TBaseType; override;
    procedure TypeToIndex(    BaseType: TBaseType;
                          var ModuleIndex: longint;
                          var TypeIndex: longint); override;

    property Module: TRCPUModule read FModule;
  end; { TModuleTypeHelper }

  TRCPUModule = class(TRaveModule)
  protected
    UsedModules: TList; { List of other modules used by this module }
    ExternalList: TStringList; { List of external functions }
    ForwardRefList: TStringList; { List of ProjectItem modules to point to }

    FMajorVersion: word;
    FMinorVersion: word;
    FCompileDate: TDateTime;
    FScope: TScopeManager;
    FTypeHelper: TTypeHelper;

    FDataBuf: pointer;
    FDataSize: longint;
    FCodeBuf: pointer;
    FCodeSize: longint;
    FStartCO: longint; { Starting CO if this module can be executed }
    FCreateCO: longint; { CO to start at when creating }
    FDestroyCO: longint; { CO to start at when destroying }
    FStackSize: longint; { Starting stack size }
    FSourceStream: TMemoryStream; { Stream containing original source }
    FEventList: TStrings; { Links functions to owner events }
    FSourceRefList: TList; { Links events to source code positions }
    FProjectItem: TRaveProjectItem;
    FProjectManager: TRaveProjectItem;
    FCompiler: TRaveCompiler;
    FParentModule: TRCPUModule;

    function GetParentModule: TRCPUModule;
    function GetDataBuf: pointer;
    procedure SetDataSize(Value: longint);
    procedure PostLoad; override;
  public
    constructor Create;
    constructor CreateFromStream(Stream: TStream;
                                 aOwner: TRaveProjectItem;
                                 aProjectItem: TRaveProjectItem); override;
    constructor CreateFromFile(FileName: string;
                               AOwner: TRaveProjectItem); override;
    destructor Destroy; override;
    procedure SaveToStream(Stream: TStream); override;
    procedure SaveToFile(FileName: string);

    function AddType(ID: TIdentifier;
                     BaseType: TBaseType): TTypeID;
    function CreateType(BaseType: TBaseType): TBaseType;
    function AddVar(ID: TIdentifier;
                    BaseType: TBaseType): TVarID;
    function AddOp(ID: TIdentifier;
                   OpKind: TOpKind): TOpID;
    function AddFunc(ID: TIdentifier;
                     BaseType: TBaseType): TFuncID;
    function AddConst(    ID: TIdentifier;
                          BaseType: TBaseType;
                      var Data): TConstID;
    function AddModule(ModuleName: TIdentifier): TRCPUModule;
    procedure AddExternal(AID: TIdentifier;
                          AOffset: longint);

    function FindInternalID(ID: TIdentifier): TBaseID;
    function FindID(ID: TIdentifier): TBaseID;
    function FindType(ID: TIdentifier): TBaseType;
    function FindExternal(ID: TIdentifier): PExternalFunc;
    function IndexToModule(Index: longint): TRCPUModule;
    function ModuleToIndex(Module: TRCPUModule): longint;
    function IndexToType(Index: longint): TBaseType;
    function TypeToIndex(BaseType: TBaseType): longint;
    procedure CreateScopeLevel;
    procedure FreeScopeLevel;
    procedure Execute(Position: integer); override;
    procedure Init;
    procedure BuildSource;
    procedure Compile(Definition: boolean);
    procedure SetStringVar(Name: string;
                           Value: string); override;
    function GetStringVar(Name: string): string; override;
    procedure SetIntVar(Name: string;
                        Value: integer); override;
    function GetIntVar(Name: string): integer; override;
    procedure SetFloatVar(Name: string;
                          Value: extended); override;
    function GetFloatVar(Name: string): extended; override;
    function GetDataPtr(VarID: TVarID): pointer;

    property Scope: TScopeManager read FScope;
    property TypeHelper: TTypeHelper read FTypeHelper;
    property DataSeg: pointer read GetDataBuf;
    property DataSize: longint read FDataSize write SetDataSize;
    property CodeSeg: pointer read FCodeBuf write FCodeBuf;
    property CodeSize: longint read FCodeSize write FCodeSize;
    property StartCO: longint read FStartCO write FStartCO;
    property CreateCO: longint read FCreateCO write FCreateCO;
    property DestroyCO: longint read FDestroyCO write FDestroyCO;
    property StackSize: longint read FStackSize write FStackSize;
    property SourceStream: TMemoryStream read FSourceStream write FSourceStream;
    property SourceRefList: TList read FSourceRefList write FSourceRefList;
    property Compiler: TRaveCompiler read FCompiler write FCompiler;
    property EventList: TStrings read FEventList write FEventList;
    property ProjectItem: TRaveProjectItem read FProjectItem write FProjectItem;
    property ProjectManager: TRaveProjectItem read FProjectManager write FProjectManager;
    property ParentModule: TRCPUModule read GetParentModule write FParentModule;
  end; { TRCPUModule }

  TRaveCompiler = class
  public
    {$IFNDEF VER93}class{$ENDIF} function SyntaxName: string; virtual; abstract;
    constructor Create; virtual;
    procedure CompileStream(Stream: TStream;
                            FileName: string;
                            AModule: TRCPUModule;
                            Definition: boolean); virtual; abstract;
  end; { TRaveCompiler }
  TRaveCompilerClass = class of TRaveCompiler;

  procedure AddRaveCompiler(CompilerClass: TRaveCompilerClass);
  function CreateRaveCompiler(SyntaxName: string): TRaveCompiler;

var
  CompilerList: TList = nil;
  CurrentModule: TRCPUModule;

implementation

uses
{$IFDEF DOMAP}
  RVLEDBug,
{$ENDIF}
  RVLEUtil, RVLERun, RVProj, RVData;

var
  CRLFStr: string[2] = #13#10;

  procedure AddRaveCompiler(CompilerClass: TRaveCompilerClass);
  begin { AddRaveCompiler }
    If not Assigned(CompilerList) then begin
      CompilerList := TList.Create;
    end; { if }
    CompilerList.Add(CompilerClass);
  end;  { AddRaveCompiler }

  function CreateRCPUModule(Stream: TStream;
                            Owner: TRaveProjectItem;
                            ProjectItem: TRaveProjectItem): TRaveModule;
  begin { CreateRCPUModule }
    Result := TRCPUModule.CreateFromStream(Stream,Owner,ProjectItem);
  end;  { CreateRCPUModule }

var
  TestInstance: TRaveComponent;

  procedure PrepareRCPUModule(ProjectItem: TRaveProjectItem);

  var
    I1: integer;
    Instance: TRaveComponent;
    Module: TRCPUModule;

  begin { PrepareRCPUModule }
    Module := ProjectItem.Module as TRCPUModule;
    If Assigned(Module) then begin
    // Go through all components owned by ProjectItem and init data segment
      FillChar(Module.DataSeg^,Module.DataSize,0);
      For I1 := 0 to ProjectItem.ComponentCount - 1 do begin
        Instance := ProjectItem.Components[I1] as TRaveComponent;
        TestInstance := Instance;
        Module.SetIntVar(Instance.Name,integer(Instance));
      end; { for }
    end; { if }
  end;  { PrepareRCPUModule }

  function CreateRaveCompiler(SyntaxName: string): TRaveCompiler;

  var
    I1: integer;

  begin { CreateRaveCompiler }
    Result := nil;
    If Assigned(CompilerList) then begin
      For I1 := 0 to CompilerList.Count - 1 do begin
        If CompareText(TRaveCompilerClass(CompilerList[I1]).SyntaxName,
         SyntaxName) = 0 then begin
          Result := TRaveCompilerClass(CompilerList[I1]).Create;
          Exit;
        end; { if }
      end; { for }
    end; { if }
  end;  { CreateRaveCompiler }

  procedure RCPUEnumRaveCompilers(List: TStrings);

  var
    I1: integer;

  begin { RCPUEnumRaveCompilers }
    List.Clear;
    If Assigned(CompilerList) then begin
      For I1 := 0 to CompilerList.Count - 1 do begin
        List.Add(TRaveCompilerClass(CompilerList[I1]).SyntaxName);
      end; { for }
    end; { if }
  end;  { RCPUEnumRaveCompilers }

  procedure RCPUCompile(ProjectItem: TRaveProjectItem);

  var
    Module: TRCPUModule;
    RaveEvent: TRaveEvent;
    I1: integer;
    BaseID: TBaseID;
    Compiler: TRaveCompiler;

  begin { RCPUCompile }
    Compiler := CreateRaveCompiler({Trans-}'Delphi');
    With Compiler do try // Hard code as Delphi for now
    { Compile source stream }
      Module := TRCPUModule.Create;
      Module.ProjectItem := ProjectItem;
      Module.BuildSource;
      Module.Compile(false);

    { Point Rave events to function offsets }
      For I1 := 0 to Module.EventList.Count - 1 do begin
        RaveEvent := TRaveEvent(Module.EventList.Objects[I1]);
        BaseID := Module.FindID(Module.EventList[I1]);
        If BaseID is TFuncID then begin
          RaveEvent.Position := TFuncID(BaseID).CodeLabel.Offset;
        end; { if }
        RaveEvent.ModuleOwner := ProjectItem;
      end; { for }

    { Copy compiled stream to ProjectItem.Module }
      If Assigned(ProjectItem.Module) then begin
        ProjectItem.Module.Free;
      end; { if }
      ProjectItem.Module := Module;
    finally
      Free;
    end; { with }
  end;  { RCPUCompile }

(*****************************************************************************}
( class TScopeManager
(*****************************************************************************)

  constructor TScopeManager.Create(AParent: TScopeManager;
                                   AOwner: TRCPUModule);

  begin { Create }
    inherited Create;
    FOwner := AOwner;
    FParent := AParent;
    Owner.FScope := self;
    ClearData;
    FTypeManager := TTypeManager.Create(Owner,Owner.TypeHelper);
    FIDManager := TIDManager.Create(Owner.TypeHelper);
  end;  { Create }

  destructor TScopeManager.Destroy;

  begin { Destroy }
    FreeAndNil(FIDManager);
    FreeAndNil(FTypeManager);
    inherited Destroy;
  end;  { Destroy }

  procedure TScopeManager.LoadFromStreamHelper(StreamHelper: TStreamHelper);

  begin { LoadFromStreamHelper }
    FTypeManager.LoadFromStreamHelper(StreamHelper);
    FIDManager.LoadFromStreamHelper(StreamHelper);
  end;  { LoadFromStreamHelper }

  procedure TScopeManager.SaveToStreamHelper(StreamHelper: TStreamHelper);

  begin { SaveToStreamHelper }
    If Assigned(FParent) then begin
      RaiseError(Trans('Cannot save a nested module state.'));
    end; { if }
    FTypeManager.SaveToStreamHelper(StreamHelper);
    FIDManager.SaveToStreamHelper(StreamHelper);
  end;  { SaveToStreamHelper }

  function TScopeManager.FindID(ID: TIdentifier): TBaseID;

  begin { FindID }
    Result := IDManager.Find(ID);
    If not Assigned(Result) then begin
      If Assigned(Parent) then begin
        Result := Parent.FindID(ID);
      end else begin
        Result := nil;
      end; { else }
    end; { if }
  end;  { FindID }

  function TScopeManager.AddType(ID: TIdentifier;
                                 BaseType: TBaseType): TTypeID;

  var
    TypeID: TTypeID;

  begin { AddType }
  { Create ID }
    TypeID := TTypeID.Create(ID,BaseType);

  { Add to IDManager }
    Result := IDManager.Add(TypeID) as TTypeID;
    If not Assigned(Result) then begin
      TypeID.Free;
    end; { if }
  end;  { AddType }

  function TScopeManager.AddVar(ID: TIdentifier;
                                BaseType: TBaseType): TVarID;

  var
    VarID: TVarID;

  begin { AddVar }
    If Assigned(Parent) then begin { Stack segment variable }
      VarID := TVarID.Create(ID,BaseType,-(DataIdx + BaseType.Size),alBP);
    end else begin { Data segment variable }
      VarID := TVarID.Create(ID,BaseType,DataIdx,alDS);
    end; { else }

  { Add to IDManager }
    Result := IDManager.Add(VarID) as TVarID;
    If Assigned(Result) then begin
      Inc(DataIdx,BaseType.Size);
    end else begin
      VarID.Free;
    end; { if }
  end;  { AddVar }

  function TScopeManager.AddOp(ID: TIdentifier;
                               OpKind: TOpKind): TOpID;

  var
    OpID: TOpID;

  begin { AddOp }
    OpID := TOpID.Create(ID,OpKind);

  { Add to IDManager }
    Result := IDManager.Add(OpID) as TOpID;
    If not Assigned(Result) then begin
      OpID.Free;
    end; { if }
  end;  { AddOp }

  function TScopeManager.AddFunc(ID: TIdentifier;
                                 BaseType: TBaseType): TFuncID;

  var
    FuncID: TFuncID;

  begin { AddFunc }
    FuncID := TFuncID.Create(ID,BaseType);

  { Add to IDManager }
    Result := IDManager.Add(FuncID) as TFuncID;
    If not Assigned(Result) then begin
      FuncID.Free;
    end; { if }
  end;  { AddFunc }

  function TScopeManager.AddConst(    ID: TIdentifier;
                                      BaseType: TBaseType;
                                  var Data): TConstID;

  var
    ConstID: TConstID;

  begin { AddConst }
  { Create ID }
    If BaseType.TypeKind = tkString then begin
      If Length(string(Data)) = 0 then begin
        ConstID := TConstID.Create(ID,BaseType,string(Data),Length(string(Data)));
      end else begin
        ConstID := TConstID.Create(ID,BaseType,string(Data)[1],Length(string(Data)));
      end; { else }
    end else if BaseType.TypeKind <> tkComplex then begin
      ConstID := TConstID.Create(ID,BaseType,Data,BaseType.Size);
    end else begin
      RaiseError(Trans('Only simple constant types allowed'));
      ConstID := nil;
    end; { else }

  { Add to IDManager }
    Result := IDManager.Add(ConstID) as TConstID;
    If not Assigned(Result) then begin
      ConstID.Free;
    end; { if }
  end;  { AddConst }

  procedure TScopeManager.ClearData;

  begin { ClearData }
    DataIdx := 0;
  end;  { ClearData }

(*****************************************************************************}
( class TModuleTypeHelper
(*****************************************************************************)

  constructor TModuleTypeHelper.Create(AModule: TRCPUModule);

  begin { Create }
    inherited Create;
    FModule := AModule;
  end;  { Create }

  function TModuleTypeHelper.IndexToType(ModuleIndex: longint;
                                         TypeIndex: longint): TBaseType;

  var
    SearchModule: TRCPUModule;

  begin { IndexToType }
    If (ModuleIndex = 0) and (TypeIndex = 0) then begin
      Result := nil;
    end else begin
      If ModuleIndex = 0 then begin
        SearchModule := Module;
      end else begin { Find module }
        SearchModule := Module.IndexToModule(ModuleIndex);
      end; { else }
//!!! Fails here because SearchModule is nil
      Result := SearchModule.IndexToType(TypeIndex);
    end; { else }
  end;  { IndexToType }

  procedure TModuleTypeHelper.TypeToIndex(    BaseType: TBaseType;
                                          var ModuleIndex: longint;
                                          var TypeIndex: longint);

  var
    SearchModule: TRCPUModule;

  begin { TypeToIndex }
    SearchModule := BaseType.Owner as TRCPUModule;
    ModuleIndex := Module.ModuleToIndex(SearchModule);
    TypeIndex := SearchModule.TypeToIndex(BaseType);
  end;  { TypeToIndex }

(*****************************************************************************}
( class TRCPUModule
(*****************************************************************************)

  constructor TRCPUModule.Create;

  begin { Create }
    inherited Create;

    FTypeHelper := TModuleTypeHelper.Create(self);
    FMajorVersion := RaveMajorVersion;
    FMinorVersion := RaveMinorVersion;
    FCompileDate := Now;
    FModuleName := {Trans-}'Module1';
    UsedModules := TList.Create;
    FScope := TScopeManager.Create(nil,self);
    FDataSize := 0;
    FDataBuf := nil;
    FCodeSize := 0;
    FCodeBuf := nil;
    FStackSize := 16384;
    ExternalList := TStringList.Create;
    ExternalList.Sorted := true;
  end;  { Create }

  constructor TRCPUModule.CreateFromStream(Stream: TStream;
                                           aOwner: TRaveProjectItem;
                                           aProjectItem: TRaveProjectItem);

  var
    StreamHelper: TStreamHelper;
    I1: integer;
    I2: integer;
    ID: string;
    Offset: longint;

  begin { CreateFromStream }
    FProjectItem := aProjectItem;
    FProjectManager := aOwner.Project;
    FTypeHelper := TModuleTypeHelper.Create(self);
    ExternalList := TStringList.Create;
    ExternalList.Sorted := true;
    StreamHelper := TStreamHelper.Create(Stream);
  { Read in module data from stream }
    With StreamHelper do try
      FModuleName := ReadString;
      ReadByte;
      ReadBuf(FMajorVersion,SizeOf(FMajorVersion));
      ReadBuf(FMinorVersion,SizeOf(FMinorVersion));
      ReadBuf(FCompileDate,SizeOf(FCompileDate));
      UsedModules := TList.Create;
      ForwardRefList := TStringList.Create;
      I2 := ReadIndex;
      For I1 := 1 to I2 do begin
        ID := ReadString;
        If (ID <> '') and (ID[1] = '+') then begin
          ForwardRefList.AddObject(Copy(ID,2,Length(ID) - 1),TObject(UsedModules.Count));
          UsedModules.Add(nil);
        end else begin
          AddModule(ID);
        end; { else }
      end; { for }
      FScope := TScopeManager.Create(nil,self);
      FScope.LoadFromStreamHelper(StreamHelper);
      FDataSize := ReadIndex;
      FCodeSize := ReadIndex;
      GetMem(FCodeBuf,FCodeSize);
      ReadBuf(FCodeBuf^,FCodeSize);

      FStackSize := ReadIndex;
      FStartCO := ReadIndex;
      FCreateCO := ReadIndex;
      FDestroyCO := ReadIndex;
      I2 := ReadIndex;
      For I1 := 1 to I2 do begin
        ID := ReadString;
        Offset := ReadIndex;
        AddExternal(ID,Offset);
      end; { for }
    finally
      Free;
    end; { with }
  end;  { CreateFromStream }

  constructor TRCPUModule.CreateFromFile(FileName: string;
                                         AOwner: TRaveProjectItem);

  var
    Stream: TMemoryStream;

  begin { CreateFromFile }
    Stream := TMemoryStream.Create;
    try
      Stream.LoadFromFile(FileName + {Trans-}'.RVC');
      CreateFromStream(Stream,AOwner,nil);
    finally
      Stream.Free;
    end; { tryf }
  end;  { CreateFromFile }

  destructor TRCPUModule.Destroy;

  var
    I1: integer;

  begin { Destroy }
    If Assigned(FSourceStream) then begin
      FreeAndNil(FSourceStream);
    end; { if }
    FreeAndNil(FSourceRefList);
    FreeAndNil(FEventList);
    FreeAndNil(UsedModules);
    FreeAndNil(FScope);
    FreeAndNil(FTypeHelper);
    If Assigned(FDataBuf) then begin
      FreeMem(FDataBuf,FDataSize);
    end; { if }
    If Assigned(FCodeBuf) then begin
      FreeMem(FCodeBuf,FCodeSize);
    end; { if }
    For I1 := 0 to ExternalList.Count - 1 do begin
      Dispose(PExternalFunc(ExternalList.Objects[I1]));
    end; { for }
    FreeAndNil(ExternalList);
    inherited Destroy;
  end;  { Destroy }

  procedure TRCPUModule.PostLoad;

  var
    I1: integer;
    Module: TRCPUModule;

    function FindModule(aProjectItem: TRaveProjectItem;
                        aModuleName: string): TRCPUModule;

    var
      I1: integer;

    begin { FindModule }
      For I1 := 0 to aProjectItem.ComponentCount - 1 do begin
        If aProjectItem.Components[I1] is TRaveProjectItem then begin
          Result := TRCPUModule(TRaveProjectItem(aProjectItem.Components[I1]).Module);
          If Assigned(Result) and SameStr(Result.ModuleName,aModuleName) then begin
            Exit;
          end; { if }
        end; { if }
      end; { for }

      If aProjectItem.Owner is TRaveProjectItem then begin
        Result := FindModule(TRaveProjectItem(aProjectItem.Owner),aModuleName);
      end else begin
        Result := TRCPUModule(aProjectItem.Module);
        If Assigned(Result) and not SameStr(Result.ModuleName,aModuleName) then begin
          Result := nil;
        end; { if }
      end; { else }
    end;  { FindModule }

  begin { PostLoad }
    For I1 := 0 to ForwardRefList.Count - 1 do begin
      If (ProjectItem is TRaveProjectManager) or (ProjectItem is TRaveReport) then begin
        Module := FindModule(ProjectItem,ForwardRefList[I1]);
      end else begin
        Module := FindModule(TRaveProjectItem(ProjectItem.Owner),ForwardRefList[I1]);
      end; { else }
      UsedModules[integer(ForwardRefList.Objects[I1])] := Module;
    end; { for }
    FreeAndNil(ForwardRefList);
  end;  { PostLoad }

  function TRCPUModule.GetParentModule: TRCPUModule;

  begin { GetParentModule }
    If not Assigned(FParentModule) then begin
      If Assigned(ProjectItem) and not (ProjectItem is TRaveProjectManager) then begin
        FParentModule := TRCPUModule((ProjectItem.Owner as TRaveProjectItem).Module);
      end; { if }
    end; { if }
    Result := FParentModule;
  end;  { GetParentModule }

  function TRCPUModule.GetDataBuf: pointer;

  begin { GetDataBuf }
    If not Assigned(FDataBuf) then begin
      GetMem(FDataBuf,FDataSize);
      FillChar(FDataBuf^,FDataSize,0);
    end; { if }
    Result := FDataBuf;
  end;  { GetDataBuf }

  procedure TRCPUModule.SetDataSize(Value: longint);

  begin { SetDataSize }
    If (FDataSize <> Value) and Assigned(FDataBuf) then begin
      FreeMem(FDataBuf,FDataSize);
    end; { if }
    FDataSize := Value;
    GetMem(FDataBuf,FDataSize);
    FillChar(FDataBuf^,FDataSize,0);
  end;  { SetDataSize }

  procedure TRCPUModule.SaveToStream(Stream: TStream);

  var
    StreamHelper: TStreamHelper;
    I1: integer;

  begin { SaveToStream }
    StreamHelper := TStreamHelper.Create(Stream);
    With StreamHelper do try
    { Write out module header }
      WriteString(FModuleName);
      WriteByte(26);
      WriteBuf(FMajorVersion,SizeOf(FMajorVersion));
      WriteBuf(FMinorVersion,SizeOf(FMinorVersion));
      WriteBuf(FCompileDate,SizeOf(FCompileDate));
      WriteIndex(UsedModules.Count);
      For I1 := 0 to UsedModules.Count - 1 do begin
        If Assigned(TRCPUModule(UsedModules[I1]).ProjectItem) then begin
          WriteString('+' + TRCPUModule(UsedModules[I1]).ModuleName);
        end else begin
          WriteString(TRCPUModule(UsedModules[I1]).ModuleName);
        end; { else }
      end; { for }
      Scope.SaveToStreamHelper(StreamHelper);
      WriteIndex(FDataSize);
      WriteIndex(FCodeSize);
      WriteBuf(FCodeBuf^,FCodeSize);
      WriteIndex(StackSize);
      WriteIndex(StartCO);
      WriteIndex(CreateCO);
      WriteIndex(DestroyCO);
      WriteIndex(ExternalList.Count);
      For I1 := 0 to ExternalList.Count - 1 do begin
        WriteString(ExternalList.Strings[I1]);
        With PExternalFunc(ExternalList.Objects[I1])^ do begin
          WriteIndex(Offset);
        end; { with }
      end; { for }
    finally
      StreamHelper.Free;
    end; { tryf }
  end;  { SaveToStream }

  procedure TRCPUModule.SaveToFile(FileName: string);

  var
    Stream: TMemoryStream;

  begin { SaveToFile }
    Stream := TMemoryStream.Create;
    try
      SaveToStream(Stream);
      Stream.SaveToFile(FileName + {Trans-}'.RVC');
    finally
      Stream.Free;
    end; { tryf }
  end;  { SaveToFile }

  procedure TRCPUModule.Init;

  begin { Init }
    If not Assigned(FDataBuf) then begin
      GetMem(FDataBuf,FDataSize);
    end; { if }
    FillChar(FDataBuf^,FDataSize,0);
  end;  { Init }

  procedure TRCPUModule.BuildSource;

  var
    BodyList: TStringList;
    Instance: TComponent;
    PropCount: integer;
    PropList: PPropList;
    PropInfo: PPropInfo;
    I1: integer;
    I2: integer;
    I3: integer;
    RaveEvent: TRaveEvent;
    HasVars: boolean;
    ModuleList: TStringList;
    LineCount: integer;

    procedure AddLine(Value: string);

    begin { AddLine }
      If Value <> '' then begin
        SourceStream.Write(Value[1],Length(Value));
      end; { if }
      SourceStream.Write(CRLFStr[1],2);
      Inc(LineCount);
    end;  { AddLine }

    function GetSupportedClass(RaveClass: TClass): string;

    begin { GetSupportedClass }
      Result := FindRaveClassModule(RaveClass.ClassName);
      If Result = '' then begin
        Result := GetSupportedClass(RaveClass.ClassParent);
      end else begin
        Result := RaveClass.ClassName;
      end; { else }
    end;  { GetSupportedClass }

    procedure AddModules(aProjectItem: TRaveProjectItem;
                         aModuleList: TStringList);

    var
      I1: integer;

    begin { AddModules }
      For I1 := 0 to aProjectItem.ComponentCount - 1 do begin
        If (aProjectItem.Components[I1] is TRaveProjectItem) and
         (aProjectItem.Components[I1] <> self.ProjectItem) then begin
          aModuleList.Add(TRaveProjectItem(aProjectItem.Components[I1]).ModuleName);
        end; { if }
      end; { for }
      If aProjectItem.Owner is TRaveProjectItem then begin
        AddModules(TRaveProjectItem(aProjectItem.Owner),aModuleList);
      end else begin
        aModuleList.Add(aProjectItem.ModuleName); { Add ProjectManager reference }
      end; { if }
    end;  { AddModules }

  begin { BuildSource }
  { Create/Clear SourceStream and EventList }
    If Assigned(SourceStream) then begin
      SourceStream.Clear;
    end else begin
      SourceStream := TMemoryStream.Create;
    end; { else }
    If Assigned(EventList) then begin
      EventList.Clear;
    end else begin
      EventList := TStringList.Create;
    end; { else }
    If Assigned(SourceRefList) then begin
      SourceRefList.Clear;
    end else begin
      SourceRefList := TList.Create;
    end; { else }
    LineCount := 0;

  { Build source stream of all components and events on page }
    BodyList := TStringList.Create;
    try
    { Add module header }
      AddLine('module ' + ProjectItem.ModuleName + ';');
      AddLine('');
      AddLine('definition');

    { Add global page references }
      ModuleList := TStringList.Create;
      try
        ModuleList.Sorted := true;
        ModuleList.Duplicates := dupIgnore;

      { Add base modules }
        ModuleList.Add('SYSFUNC');
        ModuleList.Add('RVCLASS');
        ModuleList.Add('RVDATA');

      { Add modules for each component }
        For I1 := 0 to ProjectItem.ComponentCount - 1 do begin
          ModuleName := FindRaveClassModule(ProjectItem.Components[I1].ClassName);
          If ModuleName <> '' then begin
            ModuleList.Add(UpperCase(ModuleName));
          end; { if }
        end; { for }

      { Build module list }
        AddLine('');
        AddLine('import');
        For I1 := 0 to ModuleList.Count - 2 do begin
          AddLine('  ' + ModuleList[I1] + ',');
        end; { for }
        AddLine('  ' + ModuleList[ModuleList.Count - 1] + ';');
      finally
        FreeAndNil(ModuleList);
      end; { tryf }

    { Add vars for all components on page }
      HasVars := false;
      For I1 := 0 to ProjectItem.ComponentCount - 1 do begin
        Instance := ProjectItem.Components[I1];
        If Instance.Name = '' then Continue; // Don't add components with no name
        If not HasVars then begin
          HasVars := true;
          AddLine('');
          AddLine('var');
        end; { if }
        AddLine('  ' + Instance.Name + ': ' + GetSupportedClass(Instance.ClassType) + ';');
      end; { for }

    { Start implementation }
      AddLine('');
      AddLine('implementation');

    { Add import for parents and cross reference modules }
      ModuleList := TStringList.Create;
      try
        ModuleList.Sorted := true;
        ModuleList.Duplicates := dupIgnore;
        ModuleName := '';

        If (ProjectItem is TRaveProjectManager) or (ProjectItem is TRaveReport) then begin
          AddModules(ProjectItem,ModuleList);
        end else begin
          AddModules(TRaveProjectItem(ProjectItem.Owner),ModuleList);
        end; { else }

      { Build module list }
//        If ModuleList.Count > 0 then begin
//          ModuleName := ModuleList[0];
//          For I1 := 1 to ModuleList.Count - 1 do begin
//            ModuleName := ModuleName + ', ' + ModuleList[I1];
//          end; { for }
//        end else begin
//          ModuleName := '';
//        end; { else }

        If ModuleList.Count > 0 then begin
          AddLine('');
          AddLine('import');
          For I1 := 0 to ModuleList.Count - 2 do begin
            AddLine('  ' + ModuleList[I1] + ',');
          end; { for }
          AddLine('  ' + ModuleList[ModuleList.Count - 1] + ';');
        end; { if }
      finally
        FreeAndNil(ModuleList);
      end; { tryf }

      AddLine('');
      AddLine('var ParamString: string;');
      AddLine('    ParamFloat: extended;');

    { Include source for all events }
      For I1 := 0 to ProjectItem.ComponentCount - 1 do begin
        Instance := ProjectItem.Components[I1];
        If Instance.Name = '' then Continue; // Don't process components with no name

        PropCount := GetPropList(Instance.ClassInfo,tkProperties,nil);
        GetMem(PropList,PropCount * SizeOf(pointer));
        try
          GetPropList(Instance.ClassInfo,tkProperties,PropList);
          For I2 := 0 to PropCount - 1 do begin
            PropInfo := PropList^[I2];

          { Don't show non-event properties }
            If (PropInfo.PropType^.Kind <> tkClass) or not GetTypeData(
             PropInfo.PropType^).ClassType.InheritsFrom(TRaveEvent) then Continue;

            RaveEvent := TRaveEvent(GetOrdProp(Instance,PropInfo));
            If Assigned(RaveEvent) then begin
              SourceRefList.Add(RaveEvent);
              AddLine('');
              EventList.AddObject(Instance.Name + '_' + PropInfo.Name,RaveEvent);
              AddLine('function ' + Instance.Name + '_' + PropInfo.Name + ';');
              AddLine('var Self: ' + GetSupportedClass(Instance.ClassType) + ';');
              If RaveEvent is TRaveStringEvent then begin
                AddLine('    Value: string;');
              end else if RaveEvent is TRaveStringEvent then begin
                AddLine('    Value: extended;');
              end; { else }
              AddLine('begin');
              AddLine('  Self := ' + Instance.Name + ';');
              If RaveEvent is TRaveStringEvent then begin
                AddLine('  Value := ParamString;');
              end else if RaveEvent is TRaveFloatEvent then begin
                AddLine('  Value := ParamFloat;');
              end; { else }
              RaveEvent.SourceLine := LineCount + 1;
              BodyList.Text := RaveEvent.Body;
              For I3 := 0 to BodyList.Count - 1 do begin
                AddLine('  ' + BodyList[I3]);
              end; { for }
              If RaveEvent is TRaveStringEvent then begin
                AddLine('  ParamString := Value;');
              end else if RaveEvent is TRaveStringEvent then begin
                AddLine('  ParamFloat := Value;');
              end; { else }
              AddLine('end ' + Instance.Name + '_' + PropInfo.Name + ';');
            end; { if }
          end; { for }
        finally
          FreeMem(PropList,PropCount * SizeOf(pointer));
        end; { tryf }
      end; { for }

    { Finish module }
      AddLine('');
      AddLine('end ' + ProjectItem.ModuleName + ';');
SourceStream.SaveToFile(ProjectItem.ModuleName + '.RVS'); //!!! remove after beta
    finally
      FreeAndNil(BodyList);
    end; { with }
    SourceStream.Position := 0;
  end;  { BuildSource }

  procedure TRCPUModule.Compile(Definition: boolean);

  begin { Compile }
    If Definition then begin
      If Assigned(FCompiler) then begin
        FreeAndNil(FCompiler);
      end; { if }
      FCompiler := CreateRaveCompiler({Trans-}'Delphi');
    end; { if }
    Compiler.CompileStream(SourceStream,ProjectItem.ModuleName,self,Definition);
    If not Definition then begin
      FreeAndNil(FCompiler);
    end; { if }
    DataSize := Scope.DataIdx;
  end;  { Compile }

  procedure TRCPUModule.SetStringVar(Name: string;
                                     Value: string);

  var
    P1: pointer;

  begin { SetStringVar }
    P1 := GetDataPtr(FindID(Name) as TVarID);
    string(longint(P1^)) := Value;
  end;  { SetStringVar }

  function TRCPUModule.GetStringVar(Name: string): string;

  begin { GetStringVar }
    Result := string(longint(GetDataPtr(FindID(Name) as TVarID)^));
  end;  { GetStringVar }

  procedure TRCPUModule.SetIntVar(Name: string;
                                  Value: integer);

  var
    VarID: TVarID;

  begin { SetIntVar }
    VarID := FindID(Name) as TVarID;
    If Assigned(VarID) then begin
      integer(GetDataPtr(VarID)^) := Value;
    end; { if }
  end;  { SetIntVar }

  function TRCPUModule.GetIntVar(Name: string): integer;

  var
    VarID: TVarID;

  begin { GetIntVar }
    VarID := FindID(Name) as TVarID;
    If Assigned(VarID) then begin
      Result := integer(GetDataPtr(VarID)^);
    end else begin
      Result := 0;
    end; { if }
  end;  { GetIntVar }

  procedure TRCPUModule.SetFloatVar(Name: string;
                                    Value: extended);

  begin { SetFloatVar }
    extended(GetDataPtr(FindID(Name) as TVarID)^) := Value;
  end;  { SetFloatVar }

  function TRCPUModule.GetFloatVar(Name: string): extended;

  begin { GetFloatVar }
    Result := extended(GetDataPtr(FindID(Name) as TVarID)^);
  end;  { GetFloatVar }

  function TRCPUModule.GetDataPtr(VarID: TVarID): pointer;

  begin { GetDataPtr }
    Result := pointer(longint(DataSeg) + VarID.Address.Offset);
  end;  { GetDataPtr }

  function TRCPUModule.AddType(ID: TIdentifier;
                               BaseType: TBaseType): TTypeID;

  begin { AddType }
    Result := Scope.AddType(ID,BaseType);
  end;  { AddType }

  function TRCPUModule.CreateType(BaseType: TBaseType): TBaseType;

  begin { CreateType }
    Result := Scope.TypeManager.Add(BaseType);
  end;  { CreateType }

  function TRCPUModule.AddVar(ID: TIdentifier;
                              BaseType: TBaseType): TVarID;

  begin { AddVar }
    Result := Scope.AddVar(ID,BaseType);
  end;  { AddVar }

  function TRCPUModule.AddOp(ID: TIdentifier;
                             OpKind: TOpKind): TOpID;

  begin { AddOp }
    Result := Scope.AddOp(ID,OpKind);
  end;  { AddOp }

  function TRCPUModule.AddFunc(ID: TIdentifier;
                               BaseType: TBaseType): TFuncID;

  begin { AddFunc }
    Result := Scope.AddFunc(ID,BaseType);
  end;  { AddFunc }

  function TRCPUModule.AddConst(    ID: TIdentifier;
                                    BaseType: TBaseType;
                                var Data): TConstID;

  begin { AddConst }
    Result := Scope.AddConst(ID,BaseType,Data);
  end;  { AddConst }

  function TRCPUModule.AddModule(ModuleName: TIdentifier): TRCPUModule;

    function SeekModule(aProjectItem: TRaveProjectItem): TRCPUModule;

    var
      I1: integer;

    begin { SeekModule }
      For I1 := 0 to aProjectItem.ComponentCount - 1 do begin
        If aProjectItem.Components[I1] is TRaveProjectItem then begin
          Result := TRCPUModule(TRaveProjectItem(aProjectItem.Components[I1]).Module);
          If Assigned(Result) and SameStr(Result.ModuleName,ModuleName) then begin
            Exit;
          end; { if }
        end; { if }
      end; { for }
      If aProjectItem.Owner is TRaveProjectItem then begin
        Result := SeekModule(TRaveProjectItem(aProjectItem.Owner));
      end else begin
        Result := TRCPUModule(aProjectItem.Module);
        If Assigned(Result) and not SameStr(Result.ModuleName,ModuleName) then begin
          Result := nil;
        end; { if }
      end; { else }
    end;  { SeekModule }

  begin { AddModule }
  { Look for module locally }
    If Assigned(ProjectItem) then begin
      If (ProjectItem is TRaveProjectManager) or (ProjectItem is TRaveReport) then begin
        Result := SeekModule(ProjectItem);
      end else begin
        Result := SeekModule(TRaveProjectItem(ProjectItem.Owner));
      end; { else }
      If Assigned(Result) then begin
        UsedModules.Add(Result);
      end; { if }
    end else begin
      Result := nil;
    end; { else }

    If not Assigned(Result) then begin { Look for module in module manager }
      Result := TRaveProjectManager(ProjectManager).ModuleManager.GetModule(
       ModuleName) as TRCPUModule;
      If Assigned(Result) then begin
        UsedModules.Add(Result);
      {$IFDEF DOMAP}
        If Assigned(MapFile) then begin
          Map('Import ' + ModuleName + '(' + IntToStr(UsedModules.Count) + ')');
          MapLine;
        end; { if }
      {$ENDIF}
      end; { if }
    end; { if }
  end;  { AddModule }

  procedure TRCPUModule.AddExternal(AID: TIdentifier;
                                    AOffset: longint);

  var
    ExternalFunc: PExternalFunc;

  begin { AddExternal }
    New(ExternalFunc);
    With ExternalFunc^ do begin
      Offset := AOffset;
    end; { with }
    ExternalList.AddObject(UpperCase(AID),TObject(ExternalFunc));;
  end;  { AddExternal }

  function TRCPUModule.FindInternalID(ID: TIdentifier): TBaseID;

  begin { FindInternalID }
    Result := Scope.FindID(ID);
  end;  { FindInternalID }

  function TRCPUModule.FindID(ID: TIdentifier): TBaseID;

  var
    I1: integer;
    Module: integer;

(*
    function SearchModules(FindProjectItem: TRaveProjectItem): TBaseID;

    var
      I1: integer;
      FindComp: TRaveComponent;

    begin { SearchModules }
      For I1 := 0 to FindProjectItem.ComponentCount - 1 do begin
        FindComp := FindProjectItem.Components[I1];
        If (FindComp is TRaveProjectItem) and
         (FindComp <> ProjectItem) then begin
          Result := TRCPUModule(TRaveProjectItem(FindComp).Module).FindInternalID(ID);
          If Assigned(Result) then begin
            Break;
          end; { if }
        end; { if }
      end; { for }

      If aProjectItem.Owner is TRaveProjectItem then begin
        Result := SearchModules(TRaveProjectItem(FindProjectItem.Owner));
      end else begin
        Result := TRCPUModule(TRaveProjectItem(FindComp).Module).FindInternalID(ID);
        aModuleList.Add(FindProjectItem.ModuleName); { Add ProjectManager reference }
      end; { if }
    end;  { SearchModules }
*)

  begin { FindID }
    Result := FindInternalID(ID);
    Module := 0;

  // Search used modules
    If not Assigned(Result) then begin
      For I1 := 0 to (UsedModules.Count - 1) do begin
        Result := TRCPUModule(UsedModules[I1]).FindInternalID(ID);
        If Assigned(Result) then begin
          Module := I1 + 1;
          Break;
        end; { if }
      end; { for }
    end; { if }

(*
  // Search ProjectItem modules
    If not Assigned(Result) then begin
      If (ProjectItem is TRaveProjectManager) or (ProjectItem is TRaveReport) then begin
        FindProjectItem := ProjectItem;
      end else begin
        FindProjectItem := TRaveProjectItem(ProjectItem.Owner);
      end; { else }

      For I1 := 0 to FindProjectItem.ComponentCount - 1 do begin
        FindComp := FindProjectItem.Components[I1];
        If (FindComp is TRaveProjectItem) and (FindComp <> ProjectItem) then begin
          Result := TRCPUModule(TRaveProjectItem(FindComp).Module).FindInternalID(ID);
          If Assigned(Result) then begin
          end; { if }
        end; { if }
      end; { for }

      If aProjectItem.Owner is TRaveProjectItem then begin
        AddModules(TRaveProjectItem(aProjectItem.Owner),aModuleList);
      end else begin
        aModuleList.Add(aProjectItem.ModuleName); { Add ProjectManager reference }
      end; { if }
    end; { if }
*)

    If Assigned(Result) then begin { Create Addr }
      Result.Module := Module;
    end; { if }
  end;  { FindID }

  function TRCPUModule.FindType(ID: TIdentifier): TBaseType;

  var
    BaseID: TBaseID;

  begin { FindType }
    Result := IntegerType;
    BaseID := FindID(ID);
    If Assigned(BaseID) then begin
      If BaseID is TTypeID then begin
        Result := BaseID.BaseType;
      end else begin
        AddError(23,'');
      end; { else }
    end else begin
      AddError(22,'');
    end; { else }
  end;  { FindType }

  function TRCPUModule.FindExternal(ID: TIdentifier): PExternalFunc;

  var
    I1: integer;

  begin { FindExternal }
    If ExternalList.Find(ID,I1) then begin
      Result := PExternalFunc(ExternalList.Objects[I1]);
    end else begin
      Result := nil;
    end; { else }
  end;  { FindExternal }

  function TRCPUModule.IndexToModule(Index: longint): TRCPUModule;

  begin { IndexToModule }
    If Index = 0 then begin
      Result := self;
    end else begin
      Result := TRCPUModule(UsedModules[Index - 1]);
    end; { else }
  end;  { IndexToModule }

  function TRCPUModule.ModuleToIndex(Module: TRCPUModule): longint;

  begin { ModuleToIndex }
    If Module = self then begin
      Result := 0;
    end else begin
      Result := UsedModules.IndexOf(Module) + 1;
    end; { else }
  end;  { ModuleToIndex }

  function TRCPUModule.IndexToType(Index: longint): TBaseType;

  begin { IndexToType }
    Result := Scope.TypeManager.Get(Index - 1);
  end;  { IndexToType }

  function TRCPUModule.TypeToIndex(BaseType: TBaseType): longint;

  begin { TypeToIndex }
    Result := BaseType.Index;
  end;  { TypeToIndex }

  procedure TRCPUModule.CreateScopeLevel;

  begin { CreateScopeLevel }
    FScope := TScopeManager.Create(FScope,self);
  end;  { CreateScopeLevel }

  procedure TRCPUModule.FreeScopeLevel;

  var
    NewScope: TScopeManager;

  begin { FreeScopeLevel }
    NewScope := Scope.Parent;
    If Assigned(NewScope) then begin
      FScope.Free;
      FScope := NewScope;
    end; { if }
  end;  { FreeScopeLevel }

  procedure TRCPUModule.Execute(Position: integer);

  begin { Execute }
    StartCO := Position;
    With TRCPURunner.Create do try
      Execute(self);
    finally
      Free;
    end; { with }
  end;  { Execute }

(*****************************************************************************}
( class TRaveCompiler
(*****************************************************************************)

  constructor TRaveCompiler.Create;

  begin { Create }
    inherited Create;
  end;  { Create }

initialization
  EnumRaveCompilersProc := RCPUEnumRaveCompilers;
  RaveCompileProc := RCPUCompile;
  CreateRaveModuleProc := CreateRCPUModule;
  PrepareRaveModuleProc := PrepareRCPUModule;
finalization
  FreeAndNil(CompilerList);
end.
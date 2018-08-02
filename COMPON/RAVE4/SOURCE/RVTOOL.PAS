{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVTool;

interface

{$I RPVER.PAS}

{.$DEFINE WARNREGISTER}

uses
  Windows, Classes, SysUtils, Messages, Graphics, Controls, StdCtrls, ActnList,
  ExtCtrls, Forms, Dialogs, TypInfo, RVDefine, RVUtil, RVClass, RPDefine, ImgList,
  RVProj, RVData;

type
  TPropertyOptions = (
   poEditor, { This property has a dialog editor }
   poListing, { This property returns a listing of values }
   poNoSort, { The listing returned by this property should not be sorted }
   poMultiSelect, { This property can be edited across a multiple selection }
   poLiveUpdate, { This property is updated whenever any change is made }
   poReadOnly, { This property can only be edited through the list or editor }
   poRefreshAll, { When this property is changed, all windows will be refreshed }
   poPassword { Edit/Display this property with *'s }
  );

  TPropertyOptionsSet = set of TPropertyOptions;

  TRaveProjectEditor = class;

  TRavePropertyEditor = class
  private
    FInstPropList: TList;
    FInstCount: longint;
    function GetName: string;
    function GetPropInfo(Index: integer): PPropInfo;
    function GetInstance(Index: integer): TRaveComponent;
  protected
    function GetValue: string; virtual;
    procedure SetValue(Value: string); virtual;
    function GetOptions: TPropertyOptionsSet; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure AddInst(AInstance: TRaveComponent;
                      APropInfo: PPropInfo);
    procedure Modified;
    function GetOrdValue(Index: integer): integer;
    procedure SetOrdValue(Value: integer);
    function GetFloatValue(Index: integer): extended;
    procedure SetFloatValue(Value: extended);
    function GetStrValue(Index: integer): string;
    procedure SetStrValue(Value: string);
    function GetVariantValue(Index: integer): variant;
    procedure SetVariantValue(Value: variant);
    procedure GetValues(ValueList: TStrings); virtual;
    procedure Edit; virtual;
    function SameValue(TestComp: TRaveComponent;
                       TestValue: string): boolean;
    procedure PaintValue(Canvas: TCanvas;
                         Rect: TRect;
                         DefaultValue: string); virtual;

    property InstCount: longint read FInstCount;
    property Name: string read GetName;
    property Value: string read GetValue write SetValue;

    property PropInfo[Index: integer]: PPropInfo read GetPropInfo;
    property Instance[Index: integer]: TRaveComponent read GetInstance;
    property Options: TPropertyOptionsSet read GetOptions;
  end; { TRavePropertyEditor }
  TRavePropertyEditorClass = class of TRavePropertyEditor;

  TRaveIntegerPropertyEditor = class(TRavePropertyEditor)
  protected
    function GetValue: string; override;
    procedure SetValue(Value: string); override;
  end; { TRaveIntegerPropertyEditor }

  TRaveFloatPropertyEditor = class(TRavePropertyEditor)
  protected
    function GetValue: string; override;
    procedure SetValue(Value: string); override;
  end; { TRaveFloatPropertyEditor }

  TRaveStringPropertyEditor = class(TRavePropertyEditor)
  protected
    function GetValue: string; override;
    procedure SetValue(Value: string); override;
  end; { TRaveStringPropertyEditor }

  TRaveVariantPropertyEditor = class(TRavePropertyEditor)
  protected
    function GetValue: string; override;
    procedure SetValue(Value: string); override;
  end; { TRaveVariantPropertyEditor }

  TRaveEnumPropertyEditor = class(TRavePropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    function GetValue: string; override;
    procedure SetValue(Value: string); override;
  public
    procedure GetValues(ValueList: TStrings); override;
  end; { TRaveEnumPropertyEditor }

  TRaveComponentPropertyEditor = class(TRavePropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    function Include(Value: TComponent;
                     Data: longint): boolean; virtual;
    function GetValue: string; override;
    procedure SetValue(Value: string); override;
  public
    procedure GetValues(ValueList: TStrings); override;
  end; { TRaveComponentPropertyEditor }

  TAddMenuItemProc = procedure(ProjectEditor: TRaveProjectEditor;
                               Name: string;
                               ID: integer;
                               ParentID: integer) of object;

  TRaveComponentEditor = class
  private
    FInstance: TRaveComponent;
  public
    constructor Create(AInstance: TRaveComponent); virtual;
    procedure AddToMenu(AddMenuItem: TAddMenuItemProc); virtual; abstract;
    procedure RunFromMenu(ID: integer); virtual; abstract;
    property Instance: TRaveComponent read FInstance;
  end; { TRaveComponentEditor }
  TRaveComponentEditorClass = class of TRaveComponentEditor;

  TRaveProjectEditor = class(TInterfacedObject)
  public
    constructor Create; virtual;
  end; { TRaveProjectEditor }
  TRaveProjectEditorClass = class of TRaveProjectEditor;

  TRaveProjectDesigner = class(TRaveProjectEditor)
  protected
    FTitle: string;

    function GetTitle: string; virtual; abstract;
  public
    procedure SelectionChanged; virtual; abstract;
    procedure Modified; virtual; abstract;
    procedure Enter; virtual; abstract;
    procedure Exit; virtual; abstract;
    procedure Connect(Parent: TWinControl); virtual; abstract;
    procedure Disconnect; virtual; abstract;
    property Title: string read GetTitle;
  end; { TRaveProjectDesigner }
  TRaveProjectDesignerClass = class of TRaveProjectDesigner;

  TRaveDockLoc = (dlLeft,dlRight,dlTop,dlBottom);
  TRaveDockLocSet = set of TRaveDockLoc;

  TRaveProjectToolbar = class
  protected
    FItemList: TList;
    FName: string;
    FAllowFloating: boolean;
    FValidDockLocs: TRaveDockLocSet;
    FBitmap: TBitmap;

    function AddItem(Value: TControl): TControl;
    function AddButton(Action: TCustomAction;
                       ImageList: TCustomImageList = nil;
                       ImageIndex: integer = -2;
                       Tag: integer = -1;
                       AGroupIndex: Integer = 0): TControl;
    function AddSeparator(DrawLine: boolean): TControl;
    procedure SetBitmap(Value: TBitmap);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear;
    procedure BuildToolbar; virtual; abstract; // Override and call AddXxxx methods

    property AllowFloating: boolean read FAllowFloating write FAllowFloating;
    property ValidDockLocs: TRaveDockLocSet read FValidDockLocs write FValidDockLocs;
    property Name: string read FName write FName;
    property Bitmap: TBitmap read FBitmap write SetBitmap;
    property ItemList: TList read FItemList;
  end; { TRaveProjectToolbar }
  TRaveProjectToolbarClass = class of TRaveProjectToolbar;

  TRaveProjectToolWindow = class
  protected
    FName: string;
  public
    constructor Create; virtual;
    procedure SetParent(AParent: TWinControl); virtual; abstract;
    procedure DockChanged; virtual;
    property Name: string read FName write FName;
  end; { TRaveProjectToolWindow }
  TRaveProjectToolWindowClass = class of TRaveProjectToolWindow;

  TRaveEventHandler = class(TInterfacedObject)
  private
    FQuery: boolean;
    FSingle: boolean;
  protected
    FEditorList: TList;
    FProjectEditor: TRaveProjectEditor;
    FObj: TObject;
    FPtr: pointer;
    FBoolRes: boolean;

    procedure Process(Index: integer); virtual; abstract;

    function GetEventInterface: TGUID; virtual;
    procedure Broadcast(Index: integer);
    function BroadcastQuery(Index: integer): boolean;
    procedure BroadcastObj(Index: integer;
                           Obj: TObject);
    procedure BroadcastPtr(Index: integer;
                           Ptr: pointer);
    procedure BroadcastObjPtr(Index: integer;
                              Obj: TObject;
                              Ptr: pointer);

    property EditorList: TList read FEditorList;
    property ProjectEditor: TRaveProjectEditor read FProjectEditor write FProjectEditor;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function Supports(Item: TRaveProjectEditor): boolean; virtual;
    procedure AddEditor(Editor: TRaveProjectEditor);
    procedure ProcessSingle(Editor: TRaveProjectEditor);

    property EventInterface: TGUID read GetEventInterface;
  end; { TRaveEventHandler }
  TRaveEventHandlerClass = class of TRaveEventHandler;

  procedure RegisterRavePropertyEditor(PropType: PTypeInfo;
                                       ControlClass: TClass;
                                       PropName: string;
                                       EditorClass: TRavePropertyEditorClass);
  procedure RegisterRaveComponentEditor(ControlClass: TClass;
                                        EditorClass: TRaveComponentEditorClass);
  procedure RegisterRaveProjectEditor(EditorClass: TRaveProjectEditorClass);
  procedure RegisterRaveProjectDesigner(DesignerClass: TRaveProjectDesignerClass);
  procedure RegisterRaveProjectToolbar(ToolbarClass: TRaveProjectToolbarClass);
  procedure RegisterRaveProjectToolWindow(ToolWindowClass: TRaveProjectToolWindowClass);
  function RegisterRaveEventHandler(EventHandlerClass: TRaveEventHandlerClass):
   TRaveEventHandler;

(*****************************************************************************}
( These variables are used internally by RAVE and should not be modified
(*****************************************************************************)
(**)var AddMenuItemProc:procedure(ProjectEditor:TRaveProjectEditor;Name:string;ID:integer;ParentID:integer)=nil;
(**)RegisterRavePropertyEditorProc:procedure(PropType:PTypeInfo;ControlClass:
(**)TClass;PropName:string;EditorClass:TRavePropertyEditorClass)=nil;
(**)RegisterRaveComponentEditorProc:procedure(ControlClass:TClass;EditorClass:
(**)TRaveComponentEditorClass)=nil;RegisterRaveProjectEditorProc:procedure(
(**)EditorClass:TRaveProjectEditorClass)=nil;CreateToolbarButtonProc:function(
(**)Action:TCustomAction;ImageList:TCustomImageList;ImageIndex:integer;Tag:
(**)integer;AGroupIndex: Integer):TControl=nil;CreateToolbarSeparatorProc:function(DrawLine:boolean
(**)):TControl=nil;RegisterRaveProjectToolbarProc:procedure(ToolbarClass:
(**)TRaveProjectToolbarClass)=nil;RegisterRaveProjectToolWindowProc:procedure(
(**)ToolWindowClass:TRaveProjectToolWindowClass)=nil;
(**)RegisterRaveEventHandlerProc:function(EventHandlerClass:
(**)TRaveEventHandlerClass):TRaveEventHandler=nil;
(**)RegisterRaveProjectDesignerProc:procedure(DesignerClass:
(**)TRaveProjectDesignerClass)=nil;
(*****************************************************************************}
( These variables are used internally by RAVE and should not be modified
(*****************************************************************************)

implementation

procedure RegisterRavePropertyEditor(PropType: PTypeInfo;
                                     ControlClass: TClass;
                                     PropName: string;
                                     EditorClass: TRavePropertyEditorClass);

begin { RegisterRavePropertyEditor }
  If Assigned(RegisterRavePropertyEditorProc) then begin
    RegisterRavePropertyEditorProc(PropType,ControlClass,PropName,EditorClass);
  {$IFDEF WARNREGISTER}
  end else begin
    RaveError({Trans-}'RegisterRavePropertyEditor not yet initialized.');
  {$ENDIF}
  end; { else }
end;  { RegisterRavePropertyEditor }

procedure RegisterRaveComponentEditor(ControlClass: TClass;
                                      EditorClass: TRaveComponentEditorClass);

begin { RegisterRaveComponentEditor }
  If Assigned(RegisterRaveComponentEditorProc) then begin
    RegisterRaveComponentEditorProc(ControlClass,EditorClass);
  {$IFDEF WARNREGISTER}
  end else begin
    RaveError({Trans-}'RegisterRaveComponentEditor not yet initialized.');
  {$ENDIF}
  end; { else }
end;  { RegisterRaveComponentEditor }

function RegisterRaveEventHandler(EventHandlerClass: TRaveEventHandlerClass):
 TRaveEventHandler;

begin { RegisterRaveEventHandler }
  Result := nil;
  If Assigned(RegisterRaveEventHandlerProc) then begin
    Result := RegisterRaveEventHandlerProc(EventHandlerClass);
  {$IFDEF WARNREGISTER}
  end else begin
    RaveError({Trans-}'RegisterRaveEventHandler not yet initialized.');
  {$ENDIF}
  end; { else }
end;  { RegisterRaveEventHandler }

procedure RegisterRaveProjectEditor(EditorClass: TRaveProjectEditorClass);

begin { RegisterRaveProjectEditor }
  If Assigned(RegisterRaveProjectEditorProc) then begin
    RegisterRaveProjectEditorProc(EditorClass);
  {$IFDEF WARNREGISTER}
  end else begin
    RaveError({Trans-}'RegisterRaveProjectEditor not yet initialized.');
  {$ENDIF}
  end; { else }
end;  { RegisterRaveProjectEditor }

procedure RegisterRaveProjectDesigner(DesignerClass: TRaveProjectDesignerClass);

begin { RegisterRaveProjectDesigner }
  If Assigned(RegisterRaveProjectDesignerProc) then begin
    RegisterRaveProjectDesignerProc(DesignerClass);
  {$IFDEF WARNREGISTER}
  end else begin
    RaveError({Trans-}'RegisterRaveProjectDesigner not yet initialized.');
  {$ENDIF}
  end; { else }
end;  { RegisterRaveProjectDesigner }

procedure RegisterRaveProjectToolbar(ToolbarClass: TRaveProjectToolbarClass);

begin { RegisterRaveProjectToolbar }
  If Assigned(RegisterRaveProjectToolbarProc) then begin
    RegisterRaveProjectToolbarProc(ToolbarClass);
  {$IFDEF WARNREGISTER}
  end else begin
    RaveError({Trans-}'RegisterRaveProjectToolbar not yet initialized.');
  {$ENDIF}
  end; { else }
end;  { RegisterRaveProjectToolbar }

procedure RegisterRaveProjectToolWindow(ToolWindowClass: TRaveProjectToolWindowClass);

begin { RegisterRaveProjectToolWindow }
  If Assigned(RegisterRaveProjectToolWindowProc) then begin
    RegisterRaveProjectToolWindowProc(ToolWindowClass);
  {$IFDEF WARNREGISTER}
  end else begin
    RaveError({Trans-}'RegisterRaveProjectToolWindow not yet initialized.');
  {$ENDIF}
  end; { else }
end;  { RegisterRaveProjectToolWindow }

(*****************************************************************************}
( class TRavePropertyEditor
(*****************************************************************************)

type
PInstProp = ^TInstProp;
TInstProp = record
  Instance: TRaveComponent;
  PropInfo: PPropInfo;
end; { TInstProp }

constructor TRavePropertyEditor.Create;

begin { Create }
  inherited Create;
  FInstCount := 0;
  FInstPropList := TList.Create;
end;  { Create }

destructor TRavePropertyEditor.Destroy;

var
  I1: integer;

begin { Destroy }
  For I1 := 0 to InstCount - 1 do begin
    Dispose(PInstProp(FInstPropList[I1]));
  end; { for }
  FInstPropList.Free;
  inherited Destroy;
end;  { Destroy }

procedure TRavePropertyEditor.AddInst(AInstance: TRaveComponent;
                                      APropInfo: PPropInfo);

var
  InstProp: PInstProp;

begin { AddInst }
  New(InstProp);
  InstProp.Instance := AInstance;
  InstProp.PropInfo := APropInfo;
  FInstPropList.Add(InstProp);
  Inc(FInstCount);
end;  { AddInst }

function TRavePropertyEditor.GetName: string;

begin { GetName }
  Result := PropInfo[0]^.Name;
end;  { GetName }

function TRavePropertyEditor.GetValue: string;

begin { GetValue }
  Result := '(' + Trans('unknown') + ')';
end;  { GetValue }

procedure TRavePropertyEditor.SetValue(Value: string);

begin { SetValue }
end;  { SetValue }

function TRavePropertyEditor.GetPropInfo(Index: integer): PPropInfo;

begin { GetPropInfo }
  Result := PInstProp(FInstPropList[Index])^.PropInfo;
end;  { GetPropInfo }

function TRavePropertyEditor.GetInstance(Index: integer): TRaveComponent;

begin { GetInstance }
  Result := PInstProp(FInstPropList[Index])^.Instance;
end;  { GetInstance }

function TRavePropertyEditor.GetOptions: TPropertyOptionsSet;

begin { GetOptions }
  Result := [poMultiSelect];
end;  { GetOptions }

procedure TRavePropertyEditor.PaintValue(Canvas: TCanvas;
                                         Rect: TRect;
                                         DefaultValue: string);

begin { PaintValue }
  Canvas.TextRect(Rect,Rect.Left + 1,Rect.Top + 1,DefaultValue);
end;  { PaintValue }

procedure TRavePropertyEditor.GetValues(ValueList: TStrings);

begin { GetValues }
  ValueList.Clear;
end;  { GetValues }

procedure TRavePropertyEditor.Modified;

begin { Modified }
  ModifiedProc(poRefreshAll in Options);
end;  { Modified }

function TRavePropertyEditor.GetOrdValue(Index: integer): integer;

begin { GetOrdValue }
  Result := GetOrdProp(Instance[Index],PropInfo[Index]);
end;  { GetOrdValue }

procedure TRavePropertyEditor.SetOrdValue(Value: integer);

var
  I1: integer;
  Inst: TRaveComponent;

begin { SetOrdValue }
  For I1 := 0 to InstCount - 1 do begin
    Inst := Instance[I1];
    SetOrdProp(Inst,PropInfo[I1],Value);
    If Inst is TRaveControl then begin
      TRaveControl(Inst).Reflect;
    end; { if }
  end; { for }
  Modified;
end;  { SetOrdValue }

function TRavePropertyEditor.GetFloatValue(Index: integer): extended;

begin { GetFloatValue }
  Result := GetFloatProp(Instance[Index],PropInfo[Index]);
end;  { GetFloatValue }

procedure TRavePropertyEditor.SetFloatValue(Value: extended);

var
  I1: integer;
  Inst: TRaveComponent;

begin { SetFloatValue }
  For I1 := 0 to InstCount - 1 do begin
    Inst := Instance[I1];
    SetFloatProp(Inst,PropInfo[I1],Value);
    If Inst is TRaveControl then begin
      TRaveControl(Inst).Reflect;
    end; { if }
  end; { for }
  Modified;
end;  { SetFloatValue }

function TRavePropertyEditor.GetStrValue(Index: integer): string;

begin { GetStrValue }
  Result := GetStrProp(Instance[Index],PropInfo[Index]);
end;  { GetStrValue }

procedure TRavePropertyEditor.SetStrValue(Value: string);

var
  I1: integer;
  Inst: TRaveComponent;

begin { SetStrValue }
  For I1 := 0 to InstCount - 1 do begin
    Inst := Instance[I1];
    SetStrProp(Inst,PropInfo[I1],Value);
    If Inst is TRaveControl then begin
      TRaveControl(Inst).Reflect;
    end; { if }
  end; { for }
  Modified;
end;  { SetStrValue }

function TRavePropertyEditor.GetVariantValue(Index: integer): variant;

begin { GetVariantValue }
  Result := GetVariantProp(Instance[Index],PropInfo[Index]);
end;  { GetVariantValue }

procedure TRavePropertyEditor.SetVariantValue(Value: variant);

var
  I1: integer;
  Inst: TRaveComponent;

begin { SetVariantValue }
  For I1 := 0 to InstCount - 1 do begin
    Inst := Instance[I1];
    SetVariantProp(Inst,PropInfo[I1],Value);
    If Inst is TRaveControl then begin
      TRaveControl(Inst).Reflect;
    end; { if }
  end; { for }
  Modified;
end;  { SetVariantValue }

procedure TRavePropertyEditor.Edit;

begin { Edit }
end;  { Edit }

function TRavePropertyEditor.SameValue(TestComp: TRaveComponent;
                                       TestValue: string): boolean;

var
  SaveComp: TRaveComponent;

begin { SameValue }
  SaveComp := Instance[0];
  PInstProp(FInstPropList[0])^.Instance := TestComp;
  Result := (Value = TestValue);
  PInstProp(FInstPropList[0])^.Instance := SaveComp;
end;  { SameValue }

(*****************************************************************************}
( class TRaveIntegerPropertyEditor
(*****************************************************************************)

function TRaveIntegerPropertyEditor.GetValue: string;

var
  I1: integer;
  Value1: integer;
  Value2: integer;

begin { GetValue }
  Value1 := GetOrdValue(0);
  For I1 := 1 to InstCount - 1 do begin
    Value2 := GetOrdValue(I1);
    If Value1 <> Value2 then begin
      Result := '';
      Exit;
    end; { if }
  end; { for }
  Result := IntToStr(Value1);
end;  { GetValue }

procedure TRaveIntegerPropertyEditor.SetValue(Value: string);

var
  Value1: integer;
  ErrCode: integer;

begin { SetValue }
  Val(Value,Value1,ErrCode);
  If ErrCode = 0 then begin
    SetOrdValue(Value1);
  end else begin
    MessageDlg(Trans(Format({Trans+}'"%s" is not a valid integer.',[Value])),mtError,
     [mbOk],0);
  end; { else }
end;  { SetValue }

(*****************************************************************************}
( class TRaveFloatPropertyEditor
(*****************************************************************************)

function TRaveFloatPropertyEditor.GetValue: string;

var
  I1: integer;
  Value1: extended;
  Value2: extended;

begin { GetValue }
  Value1 := GetFloatValue(0);
  For I1 := 1 to InstCount - 1 do begin
    Value2 := GetFloatValue(I1);
    If Value1 <> Value2 then begin
      Result := '';
      Exit;
    end; { if }
  end; { for }
  Result := Flt2Str(Value1,FloatPropPrecision);
end;  { GetValue }

procedure TRaveFloatPropertyEditor.SetValue(Value: string);

var
  Value1: extended;

begin { SetValue }
  try
    Value1 := StrToFloat(Value);
    SetFloatValue(Value1);
  except
    MessageDlg(Trans(Format({Trans+}'"%s" is not a valid floating point.',[Value])),
     mtError,[mbOk],0);
  end; { tryx }
end;  { SetValue }

(*****************************************************************************}
( class TRaveStringPropertyEditor
(*****************************************************************************)

function TRaveStringPropertyEditor.GetValue: string;

var
  I1: integer;
  Value1: string;
  Value2: string;

begin { GetValue }
  Value1 := GetStrValue(0);
  For I1 := 1 to InstCount - 1 do begin
    Value2 := GetStrValue(I1);
    If Value1 <> Value2 then begin
      Result := '';
      Exit;
    end; { if }
  end; { for }
  Result := Value1;
end;  { GetValue }

procedure TRaveStringPropertyEditor.SetValue(Value: string);

begin { SetValue }
  SetStrValue(Value);
end;  { SetValue }

(*****************************************************************************}
( class TRaveVariantPropertyEditor
(*****************************************************************************)

function TRaveVariantPropertyEditor.GetValue: string;

var
  I1: integer;
  Value1: variant;
  Value2: variant;

begin { GetValue }
  Value1 := GetVariantValue(0);
  For I1 := 1 to InstCount - 1 do begin
    Value2 := GetVariantValue(I1);
    If Value1 <> Value2 then begin
      Result := '';
      Exit;
    end; { if }
  end; { for }
  Result := Value1;
end;  { GetValue }

procedure TRaveVariantPropertyEditor.SetValue(Value: string);

var
  Value1: variant;

begin { SetValue }
  Value1 := Value;
  SetVariantValue(Value1);
end;  { SetValue }

(*****************************************************************************}
( class TRaveEnumPropertyEditor
(*****************************************************************************)

function TRaveEnumPropertyEditor.GetOptions: TPropertyOptionsSet;

begin { GetOptions }
  Result := [poMultiSelect,poListing];
end;  { GetOptions }

procedure TRaveEnumPropertyEditor.GetValues(ValueList: TStrings);

var
  I1: integer;
  TypeInfo: PTypeInfo;
  TypeData: PTypeData;

begin { GetValues }
  ValueList.Clear;
  TypeInfo := PropInfo[0]^.PropType{$IFDEF LEVEL3}^{$ENDIF};
  TypeData := GetTypeData(TypeInfo);
  For I1 := 0 to TypeData^.MaxValue do begin
    ValueList.Add(GetEnumName(TypeInfo,I1));
  end; { for }
end;  { GetValues }

function TRaveEnumPropertyEditor.GetValue: string;

var
  I1: integer;
  Value: integer;

begin { GetValue }
  Value := GetOrdValue(0);
  For I1 := 1 to InstCount - 1 do begin
    If Value <> GetOrdValue(I1) then begin
      Result := '';
      Exit;
    end; { if }
  end; { for }
  Result := GetEnumName(PropInfo[0]^.PropType{$IFDEF LEVEL3}^{$ENDIF},Value);
end;  { GetValue }

procedure TRaveEnumPropertyEditor.SetValue(Value: string);

var
  Value1: integer;

begin { SetValue }
  Value1 := GetEnumValue(PropInfo[0]^.PropType{$IFDEF LEVEL3}^{$ENDIF},Value);
  If Value1 >= 0 then begin
    SetOrdValue(Value1);
  end else begin
    MessageDlg(Trans(Format({Trans+}'"%s" is not a valid entry.',[Value])),mtError,
     [mbOk],0);
  end; { else }
end;  { SetValue }

(*****************************************************************************}
( class TRaveComponentPropertyEditor
(*****************************************************************************)

function TRaveComponentPropertyEditor.GetOptions: TPropertyOptionsSet;

begin { GetOptions }
  Result := [poMultiSelect,poListing,poNoSort];
end;  { GetOptions }

function TRaveComponentPropertyEditor.Include(Value: TComponent;
                                              Data: longint): boolean;

begin { Include }
  Result := (Value is TClass(Data));
end;  { Include }

procedure TRaveComponentPropertyEditor.GetValues(ValueList: TStrings);

begin { GetValues }
  ValueList.Clear;
{ Get list of components on page compatible with PropInfo[0] }
  GetComponentNames(Include,Instance[0],
   longint(GetTypeData(PropInfo[0].PropType{$IFDEF LEVEL3}^{$ENDIF})^.ClassType),ValueList);
end;  { GetValues }

function TRaveComponentPropertyEditor.GetValue: string;

var
  I1: integer;
  Obj: TObject;
  O1: TRaveComponent;
  Value1: string;
  Value2: string;

begin { GetValue }
  If GetOrdValue(0) = 0 then begin
    Value1 := '';
  end else begin
    Obj := TObject(GetOrdValue(0));
    If Obj is TRaveComponent then begin
      O1 := TRaveComponent(Obj);
      If (O1.Owner <> Instance[0].Owner) and (O1.Owner <> O1.Project) then begin
        Value1 := O1.Owner.Name + '.' + O1.Name;
      end else begin
        Value1 := O1.Name;
      end; { else }
    end else begin
      Value1 := '(' + Trans('unknown') + ')';
    end; { else }
  end; { else }

  For I1 := 1 to InstCount - 1 do begin
    If GetOrdValue(I1) = 0 then begin
      Value2 := '';
    end else begin
      Obj := TObject(GetOrdValue(0));
      If Obj is TRaveComponent then begin
        O1 := TRaveComponent(Obj);
        If (O1.Owner <> Instance[I1].Owner) and (O1.Owner <> O1.Project) then begin
          Value2 := O1.Owner.Name + '.' + O1.Name;
        end else begin
          Value2 := O1.Name;
        end; { else }
      end else begin
        Value2 := '(' + Trans('unknown') + ')';
      end; { else }
    end; { else }
    If Value1 <> Value2 then begin
      Result := '';
      Exit;
    end; { if }
  end; { for }
  Result := Value1;
end;  { GetValue }

procedure TRaveComponentPropertyEditor.SetValue(Value: string);

var
  Value1: TRaveComponent;

begin { SetValue }
  If Value = '' then begin
    Value1 := nil;
  end else begin
    Value1 := TRaveProjectManager(Instance[0].Project).FindRaveComponent(
     Value,TRaveComponent(Instance[0].Owner));
    If not (Assigned(Value1) and Include(Value1,longint(GetTypeData(
     PropInfo[0].PropType{$IFDEF LEVEL3}^{$ENDIF})^.ClassType))) then begin
      MessageDlg(Trans(Format({Trans+}'"%s" is not a valid entry.',[Value])),mtError,[mbOk],0);
      Exit;
    end; { else }
  end; { else }
  SetOrdValue(longint(Value1));
end;  { SetValue }

(*****************************************************************************}
( class TRaveComponentEditor
(*****************************************************************************)

constructor TRaveComponentEditor.Create(AInstance: TRaveComponent);

begin { Create }
  inherited Create;
  FInstance := AInstance;
end;  { Create }

(*****************************************************************************}
( class TRaveProjectEditor
(*****************************************************************************)

constructor TRaveProjectEditor.Create;

begin { Create }
  inherited Create;
end;  { Create }

(*****************************************************************************}
( class TRaveProjectToolbar
(*****************************************************************************)

constructor TRaveProjectToolbar.Create;

begin { Create }
  inherited Create;
  FItemList := TList.Create;
  FValidDockLocs := [dlLeft,dlRight,dlTop,dlBottom];
  FAllowFloating := true;
  FBitmap := TBitmap.Create;
end;  { Create }

destructor TRaveProjectToolbar.Destroy;

begin { Destroy }
  Clear;
  FBitmap.Free;
  FItemList.Free;
  inherited Destroy;
end;  { Destroy }

procedure TRaveProjectToolbar.Clear;

begin { Clear }
  FItemList.Clear;
end;  { Clear }

function TRaveProjectToolbar.AddItem(Value: TControl): TControl;

begin { AddItem }
  Result := Value;
  FItemList.Add(Result);
end;  { AddItem }

function TRaveProjectToolbar.AddButton(Action: TCustomAction;
                                       ImageList: TCustomImageList = nil;
                                       ImageIndex: integer = -2;
                                       Tag: integer = -1;
                                       AGroupIndex: Integer = 0): TControl;

begin { AddButton }
  Result := nil;
  If Assigned(CreateToolbarButtonProc) then begin
    Result := CreateToolbarButtonProc(Action,ImageList,ImageIndex,Tag, AGroupIndex);
    FItemList.Add(Result);
  {$IFDEF WARNREGISTER}
  end else begin
    RaveError({Trans-}'CreateToolbarButtonProc not yet initialized.');
  {$ENDIF}
  end; { else }
end;  { AddButton }

function TRaveProjectToolbar.AddSeparator(DrawLine: boolean): TControl;

begin { AddSeparator }
  Result := nil;
  If Assigned(CreateToolbarSeparatorProc) then begin
    Result := CreateToolbarSeparatorProc(DrawLine);
    FItemList.Add(Result);
  {$IFDEF WARNREGISTER}
  end else begin
    RaveError({Trans-}'CreateToolbarSeparatorProc not yet initialized.');
  {$ENDIF}
  end; { else }
end;  { AddSeparator }

procedure TRaveProjectToolbar.SetBitmap(Value: TBitmap);

begin { SetBitmap }
  FBitmap.Assign(Value);
end;  { SetBitmap }

(*****************************************************************************}
( class TRaveProjectToolWindow
(*****************************************************************************)

constructor TRaveProjectToolWindow.Create;

begin { Create }
  inherited Create;
end;  { Create }

procedure TRaveProjectToolWindow.DockChanged;

begin { DockChanged }
end;  { DockChanged }

(*****************************************************************************}
( class TRaveEventHandler
(*****************************************************************************)

constructor TRaveEventHandler.Create;

begin { Create }
  inherited Create;
  FEditorList := TList.Create;
end;  { Create }

destructor TRaveEventHandler.Destroy;

begin { Destroy }
  FEditorList.Free;
  inherited Destroy;
end;  { Destroy }

procedure TRaveEventHandler.AddEditor(Editor: TRaveProjectEditor);
var
  I1: integer;
begin { AddEditor }
  For I1 := 0 to EditorList.Count - 1 do begin
    If EditorList[I1] = Editor then Exit;
  end; { for }
  EditorList.Add(Editor);
end;  { AddEditor }

procedure TRaveEventHandler.ProcessSingle(Editor: TRaveProjectEditor);

begin { ProcessSingle }
  FProjectEditor := Editor;
  FSingle := true;
end;  { ProcessSingle }

function TRaveEventHandler.Supports(Item: TRaveProjectEditor): boolean;

(*
var
  IItem: IUnknown;
  InterfaceTable: PInterfaceTable;
  I1: integer;
*)

begin { Supports }
  Result := Item.GetInterfaceEntry(EventInterface) <> nil;

//    Result := SysUtils.Supports(Item,EventInterface,IItem);

//    Item.QueryInterface(EventInterface,IItem);

(*
  Result := false;
  InterfaceTable := Item.GetInterfaceTable;
  For I1 := 0 to InterfaceTable.EntryCount - 1 do begin
    If EventInterface = InterfaceTable.Entries[I1].IID then begin
      Result := true;
      Exit;
    end; { if }
  end; { for }
*)

//  Result := Item.GetInterface(EventInterface,IItem);
end;  { Supports }

function TRaveEventHandler.GetEventInterface: TGUID;

var
  InterfaceTable: PInterfaceTable;

begin { GetEventInterface }
  InterfaceTable := GetInterfaceTable;
//!!! Check to make sure the last entry is the correct one
  Result := InterfaceTable.Entries[InterfaceTable.EntryCount - 1].IID;
end;  { GetEventInterface }

procedure TRaveEventHandler.Broadcast(Index: integer);

var
  I1: integer;
  LocalQuery: boolean;

begin { Broadcast }
  If FSingle then begin
    FSingle := false;
    Process(Index);
  end else begin
    LocalQuery := FQuery;
    For I1 := 0 to EditorList.Count - 1 do begin
      FProjectEditor := TRaveProjectEditor(EditorList[I1]);
      Process(Index);
      LocalQuery := LocalQuery and FBoolRes;
    end; { for }
    FQuery := LocalQuery;
  end; { else }
end;  { Broadcast }

function TRaveEventHandler.BroadcastQuery(Index: integer): boolean;

begin { BroadcastQuery }
  FQuery := true;
  Broadcast(Index);
  Result := FQuery;
end;  { BroadcastQuery }

procedure TRaveEventHandler.BroadcastObj(Index: integer;
                                         Obj: TObject);

begin { BroadcastObj }
  FObj := Obj;
  Broadcast(Index);
end;  { BroadcastObj }

procedure TRaveEventHandler.BroadcastPtr(Index: integer;
                                         Ptr: pointer);

begin { BroadcastPtr }
  FPtr := Ptr;
  Broadcast(Index);
end;  { BroadcastPtr }

procedure TRaveEventHandler.BroadcastObjPtr(Index: integer;
                                            Obj: TObject;
                                            Ptr: pointer);

begin { BroadcastObjPtr }
  FObj := Obj;
  FPtr := Ptr;
  Broadcast(Index);
end;  { BroadcastObjPtr }

end.
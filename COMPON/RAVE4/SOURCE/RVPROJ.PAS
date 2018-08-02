{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVProj;

interface

{$I RPVer.pas }

uses
  {$IFDEF Linux}
  QComCtrls, QControls, QForms, QDialogs, QGraphics,
  {$ELSE}
  WinProcs, WinTypes, Controls, ComCtrls, Forms, Dialogs, Graphics,
  {$ENDIF}
  SysUtils,  Classes, RVDefine, RVUtil, RVClass, RVData, RPDefine, RPBase, RPSystem,
  RPDevice, TypInfo, RVSecurity;

type
  TTagKind = (tkProject,tkExport,tkDataView,tkPage,tkReport,tkReportPage,tkDataObject);

  TImportConflictEvent = procedure(CurrentItem: TRaveProjectItem;
                                   var ImportName: string) of object;

  TRaveProjectManager = class;

  TRaveReport = class(TRaveProjectItem)
  protected
    FCategory: string;
    FLastActivePage: string;
    SaveOnPrint: TNotifyEvent;
    SaveBeforePrint: TNotifyEvent;
    SaveAfterPrint: TNotifyEvent;
    LoadedList: TList; { Loaded pages for this report }
    FixUpList: TStrings; { List of loaded modules that may not be ready until
                           after all report items are loaded }
    FFirstPage: TRavePage; { Page to begin execution for }
    FCopies: integer;
    FPageList: TRaveComponentList; { List of pages to print }
    FAlwaysGenerate: boolean;
    FCollate: TRavePrinterCollate;
    FDuplex: TRavePrinterDuplex;
    FPrinter: string;
    FResolution: TRavePrinterResolution;
    FMaxPages: integer; { Max number of pages to print }
    FSecurityControl: TRaveBaseSecurity;

    procedure SetPageList(Value: TRaveComponentList);
    function GetLoadedCount: integer;
    function GetLoaded(Index: integer): TRavePage;
    procedure RSPrint(Sender: TObject);
    procedure RSBeforePrint(Sender: TObject);
    procedure RSAfterPrint(Sender: TObject);
    procedure Changing(OldItem: TRaveComponent;
                       NewItem: TRaveComponent); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SaveToStreamHelper(StreamHelper: TStreamHelper); override;
    procedure LoadFromStreamHelper(StreamHelper: TStreamHelper); override;
    procedure Open; override;
    procedure Close; override;
    procedure Compile; override;
    function NewPage: TRavePage;
    procedure LoadPage(Page: TRavePage);
    procedure UnloadPage(Page: TRavePage);
    procedure ProcessLoaded;
    procedure Execute(Engine: TRPComponent);
    procedure InternalExecute(Engine: TRPComponent);

    property LoadedPageCount: integer read GetLoadedCount;
    property LoadedPage[Index: integer]: TRavePage read GetLoaded;
    property LastActivePage: string read FLastActivePage write FLastActivePage;
  published
    property AlwaysGenerate: boolean read FAlwaysGenerate write FAlwaysGenerate default false;
    property Category: string read FCategory write FCategory;
    property Copies: integer read FCopies write FCopies default 0;
    property FirstPage: TRavePage read FFirstPage write FFirstPage default nil;
    property PageList: TRaveComponentList read FPageList write SetPageList;
    property Collate: TRavePrinterCollate read FCollate write FCollate
     default pcDefault;
    property Duplex: TRavePrinterDuplex read FDuplex write FDuplex
     default pdDefault;
    property MaxPages: integer read FMaxPages write FMaxPages default 0;
    property Parameters;
    property PIVars;
    property Printer: string read FPrinter write FPrinter;
    property Resolution: TRavePrinterResolution read FResolution
     write FResolution default prDefault;
    property SecurityControl: TRaveBaseSecurity read FSecurityControl write
     FSecurityControl;
  end; { TRaveReport }

  TRaveModuleManager = class
  protected
    ModuleList: TList;
    FProjectManager: TRaveProjectManager;
    //
    function ModuleIndex(ModuleName: string): integer;
    function LoadModule(ModuleName: string): integer;
  public
    constructor Create(AProjectManager: TRaveProjectManager);
    destructor Destroy; override;
    function GetModule(ModuleName: string): TRaveModule;
    function FindModule(ModuleName: string): TRaveModule;
    procedure LoadModules(StreamHelper: TStreamHelper);
    procedure SaveModules(StreamHelper: TStreamHelper);
    //
    property ProjectManager: TRaveProjectManager read FProjectManager;
  end; { TRaveModuleManager }

  TRaveProjectManager = class(TRaveProjectItem)
  protected
    ForwardRefList: TStringList;
    RenameRefList: TStringList;
    LastActiveReport: string;
    FReportList: TList; { List of all reports }
    FGlobalPageList: TList; { List of all global pages }
    FDataObjectList: TList; { List of all data objects }
    FActiveReport: TRaveReport;
    FSaved: boolean; { Has this project ever been saved }
    FFileName: string; { Filename of this project }
    Signature: string;
    FDataChanged: boolean;
    FPrinting: boolean;
    ExportList: TList;
    Importing: boolean;
    ImportReplace: boolean;
    FOnImportConflict: TImportConflictEvent;
    FVersion: integer;
    FCategories: TStrings;
    Params: TStringList;
    FUnits: TPrintUnits; { Units type }
    FUnitsFactor: TRaveFloat; { Units factor }
    FStreamParamValues: boolean; { Put parameter values in save stream? }
    IsLoading: boolean;
    FMasterProject: TRaveProjectManager;
    FNoDesigner: boolean;
    FSecurityControl: TRaveBaseSecurity;
    FAdminPassword: string;
    FBaseReport: TBaseReport;
    FModuleManager: TRaveModuleManager;

    procedure SetDepth(Control: TRaveComponent;
                       Adjustment: integer); override;
    procedure SetCategories(Value: TStrings);
    procedure SetUnits(Value: TPrintUnits);
    procedure SetUnitsFactor(Value: double);
    procedure SetDataChanged(Value: boolean);
    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadParamValues(Reader: TReader);
    procedure WriteParamValues(Writer: TWriter);
    procedure Changing(OldItem: TRaveComponent;
                       NewItem: TRaveComponent); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReportToStream(AReport: TRaveReport;
                             AStream: TStream);
    function FindReport(const AName: string; const AIsFullName: boolean): TRaveReport;
    procedure AddForwardRef(AName: string; AOwner: TRaveComponent; AInstance: TPersistent;
     APropInfo: PPropInfo; AParam: longint);
    procedure AddRenameRef(OrigName: string; NewInstance: TRaveComponent);
    procedure FreeForwardRefs;
    procedure New;
    procedure RemoveForwardRefs(Target: TRaveComponent);
    procedure Save;
    procedure Load;
    procedure Unload;
    procedure Clear;
    procedure LoadFromStreamHelper(StreamHelper: TStreamHelper); override;
    procedure SaveToStreamHelper(StreamHelper: TStreamHelper); override;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    procedure ExportProject(ExportFileName: string;
                            Items: TList);
    function ImportProject(ImportFileName: string;
                           AutoReplace: boolean): boolean;
    procedure DeactivateReport;
    procedure ActivateReport(Report: TRaveReport);
    function FindRaveComponent(Name: string;
                               DefRoot: TRaveComponent): TRaveComponent;
    function GetUniqueName(BaseName: string;
                           NameOwner: TRaveComponent;
                           UseCurrent: boolean): string;

    function NewReport: TRaveReport;
    function NewGlobalPage: TRavePage;
//    function NewDataView: TRaveDataView;
    function NewDataObject(DataObjectClass: TRaveDataObjectClass): TRaveDataObject;
    procedure DeleteItem(Item: TRaveProjectItem;
                         Notify: boolean);
    procedure SetParam(Param: string;
                       Value: string);
    function GetParam(Param: string): string;
    procedure ClearParams;
    procedure ClearChanged;
    procedure Compile; override;

    property ReportList: TList read FReportList;
    property GlobalPageList: TList read FGlobalPageList;
    property DataObjectList: TList read FDataObjectList;

    property ActiveReport: TRaveReport read FActiveReport;
    property Saved: boolean read FSaved write FSaved;
  { DataChanged will only change value when set to true, to clear call ClearChanged }
    property DataChanged: boolean read FDataChanged write SetDataChanged;
    property Printing: boolean read FPrinting;
    property Version: integer read FVersion;
    property OnImportConflict: TImportConflictEvent read FOnImportConflict write
     FOnImportConflict;
    property StreamParamValues: boolean read FStreamParamValues write FStreamParamValues;
    property FileName: string read FFileName write FFileName stored false;
    property MasterProject: TRaveProjectManager read FMasterProject write FMasterProject;
    property NoDesigner: boolean read FNoDesigner write FNoDesigner;
    property BaseReport: TBaseReport read FBaseReport write FBaseReport;
    property ModuleManager: TRaveModuleManager read FModuleManager;
  published
    property AdminPassword: string read FAdminPassword write FAdminPassword;
    property Categories: TStrings read FCategories write SetCategories;
    property Parameters;
    property PIVars;
    property SecurityControl: TRaveBaseSecurity read FSecurityControl write
     FSecurityControl;
    property Units: TPrintUnits read FUnits write SetUnits stored false;
    property UnitsFactor: TRaveFloat read FUnitsFactor write SetUnitsFactor;
  end; { TRaveProjectManager }

// Procs
  procedure RaveRegister;

{$IFDEF DESIGNER}
var
  ProjectManager: TRaveProjectManager = nil;
{$ENDIF}

implementation

uses
  {$IFNDEF Server}RVDirectDataView,{$ENDIF} RVDataField;

{$IFDEF DESIGNER}
{$R *.RES}
{$ENDIF}

(*****************************************************************************}
( Forward References Handling
(*****************************************************************************)

type
  TRaveForwardRef = class
  protected
    FParam: longint;
    FInstance: TPersistent;
    FPropInfo: PPropInfo;
  public
    constructor Create(AInstance: TPersistent;
                       APropInfo: PPropInfo;
                       AParam: longint);
    property Param: longint read FParam;
    property Instance: TPersistent read FInstance;
    property PropInfo: PPropInfo read FPropInfo;
  end; { TRaveForwardRef }

constructor TRaveForwardRef.Create(AInstance: TPersistent; APropInfo: PPropInfo; AParam: longint);
begin { Create }
  FInstance := AInstance;
  FPropInfo := APropInfo;
  FParam := AParam;
end;  { Create }

procedure TRaveProjectManager.AddForwardRef(AName: string; AOwner: TRaveComponent; AInstance: TPersistent;
 APropInfo: PPropInfo; AParam: longint);
begin { AddForwardRef }
  If not Assigned(ForwardRefList) then begin
    ForwardRefList := TStringList.Create;
    ForwardRefList.Sorted := true;
    ForwardRefList.Duplicates := dupAccept;
  end; { if }
  If Pos('.',AName) = 0 then begin
    AName := AOwner.Name + '.' + AName;
  end; { if }
  ForwardRefList.AddObject(AName,TRaveForwardRef.Create(AInstance,APropInfo,AParam));
end;  { AddForwardRef }

procedure TRaveProjectManager.AddRenameRef(OrigName: string; NewInstance: TRaveComponent);
begin { AddRenameRef }
  If not Assigned(RenameRefList) then begin
    RenameRefList := TStringList.Create;
    RenameRefList.Sorted := true;
    RenameRefList.Duplicates := dupIgnore;
  end; { if }
  RenameRefList.AddObject(NewInstance.Owner.Name + '.' + OrigName,NewInstance);
end;  { AddRenameRef }

procedure TRaveProjectManager.RemoveForwardRefs(Target: TRaveComponent);
var
  TargetName: string;
  Index: integer;
begin { RemoveForwardRefs }
  TargetName := Target.Owner.Name + '.' + Target.Name;
  If Assigned(ForwardRefList) and ForwardRefList.Find(TargetName,Index) then begin
    Repeat
      With TRaveForwardRef(ForwardRefList.Objects[Index]) do begin
        If not Assigned(PropInfo) then begin
          TRaveComponentList(Instance).Items[Param] := Target;
        end else begin
          SetOrdProp(Instance,PropInfo,integer(Target));
        end; { else }
      end; { with }
      ForwardRefList.Objects[Index].Free;
      ForwardRefList.Delete(Index);
    until (Index >= ForwardRefList.Count) or
     (CompareText(ForwardRefList[Index],TargetName) <> 0);
  end; { if }
end;  { RemoveForwardRefs }

procedure RaveRegister;
begin { RaveRegister }
{TransOff}
  RegisterRaveComponents('',[TRaveReport,TRaveProjectManager]);
  RegisterRaveModuleClasses('RVProj',[TRaveReport,TRaveProjectManager]);

{$IFDEF DESIGNER}
  RegisterRaveProperties(TRaveReport,
   {Beginner}     'Copies;FirstPage;PageList;PaperSize',
   {Intermediate} 'AlwaysGenerate;Parameters;PIVars',
   {Developer}    '',
   {Hidden}       '');

  RegisterRaveProperties(TRaveProjectManager,
   {Beginner}     'Units',
   {Intermediate} 'Parameters;PIVars;UnitsFactor',
   {Developer}    'AdminPassword;Categories',
   {Hidden}       '');

  SetPropDesc(TRaveReport,'AlwaysGenerate',Trans('Determines whether the report will be ' +
   'generated before printing.  Set this property to true if the report uses the TotalPages ' +
   'report variable.'));
  SetPropDesc(TRaveReport,'Category',Trans('Defines the category that this report belongs to.  ' +
   'Categories are an effective way to organize your reports within the application.'));
  SetPropDesc(TRaveReport,'Copies',Trans('Defines the number of copies that this report will print.'));
  SetPropDesc(TRaveReport,'FirstPage',Trans('Defines the first page that will print when this report ' +
   'is executed.  If PageList is defined, this property will be ignored.'));
  SetPropDesc(TRaveReport,'PageList',Trans('Using the Page List Editor, defines a list of pages and ' +
   'the order to print them when this report is executed.  If this property is defined, FirstPage ' +
   'will be ignored.'));
  SetPropDesc(TRaveReport,'Collate',Trans('Defines whether multiple copies of the report will be ' +
   'collated.  This property will have no effect on printers that do not support collation.'));
  SetPropDesc(TRaveReport,'Duplex',Trans('Defines the duplex mode that the report will be printed ' +
   'in.  This property will have no effect on printers that do not support duplex printing.'));
  SetPropDesc(TRaveReport,'MaxPages',Trans('Defines the maximum number of pages that will ' +
   'be generated when this report is executed.  A value of 0 will cause all pages of the report ' +
   'to be printed.'));
  SetPropDesc(TRaveReport,'Parameters',Trans('Defines the project parameters for the report.  ' +
   'Values can be assigned to project parameters through calculation components and can be ' +
   'printed using DataText components.  Each parameter should be placed on a ' +
   'separate line in the editor.'));
  SetPropDesc(TRaveReport,'PIVars',Trans('Defines the PIVars (Post Initialize Variables) for ' +
   'the report.  Values can be assigned to PIVars through calculation components and can be ' +
   'printed using DataText components.  Each PIVar should be placed on a separate line in the editor.'));
  SetPropDesc(TRaveReport,'Printer',Trans('Defines the name of the printer to send the report to.  ' +
   'The name can be a sub-string such as "FAX" or "LASER".  A blank value will send the report to ' +
   'the default printer.'));
  SetPropDesc(TRaveReport,'Resolution',Trans('Defines the resolution (print quality) that ' +
   'the report will be printed in.'));
  SetPropDesc(TRaveReport,'SecurityControl',Trans('')); //!!!

  SetPropDesc(TRaveProjectManager,'Categories',Trans('Defines categories that reports can belong ' +
   'to for an effective way to organize your reports within the application.  Each category should ' +
   'be placed on a separate line in the editor.'));
  SetPropDesc(TRaveProjectManager,'Parameters',Trans('Defines the project parameters for the report ' +
   'project.  Values can be assigned to project parameters from the application or through calculation ' +
   'components and can be printed using DataText components.  Each parameter should be placed on a ' +
   'separate line in the editor.'));
  SetPropDesc(TRaveProjectManager,'PIVars',Trans('Defines the PIVars (Post Initialize Variables) for ' +
   'the report project.  Values can be assigned to PIVars through calculation components and can be ' +
   'printed using DataText components.  Each PIVar should be placed on a separate line in the editor.'));
  SetPropDesc(TRaveProjectManager,'SecurityControl',Trans('')); //!!!
  SetPropDesc(TRaveProjectManager,'Units',Trans('Defines the units that the report project will be ' +
   'edited in.  For custom unit modes, set the value of UnitsFactor directly.'));
  SetPropDesc(TRaveProjectManager,'UnitsFactor',Trans('Defines the units conversion factor.  This ' +
   'value represents the amount of units that equal one inch (e.g. 2.54 cm per inch).'));
{$ENDIF}
{TransOn}
end;  { RaveRegister }

type
  TRaveComponentAccess = class(TRaveComponent)
  end; { TRaveComponentAccess }

(*****************************************************************************}
( class TRaveReport
(*****************************************************************************)

constructor TRaveReport.Create(AOwner: TComponent);
begin { Create }
  inherited Create(AOwner);
  LoadedList := TList.Create;
  FCopies := 0;
  FResolution := prDefault;
  FCollate := pcDefault;
  FDuplex := pdDefault;
end;  { Create }

destructor TRaveReport.Destroy;
begin { Destroy }
  FreeAndNil(LoadedList);
  FreeAndNil(FPageList);
  inherited Destroy;
end;  { Destroy }

procedure TRaveReport.Changing(OldItem: TRaveComponent;
                               NewItem: TRaveComponent);

var
  I1: integer;

begin { Changing }
  inherited Changing(OldItem,NewItem);
  If Assigned(FirstPage) and (FirstPage = OldItem) then begin
    FirstPage := NewItem as TRavePage;
  end; { if }
  If Assigned(SecurityControl) and (OldItem = SecurityControl) then begin
    SecurityControl := NewItem as TRaveBaseSecurity;
  end; { if }
  If Assigned(PageList) then begin
    I1 := 0;
    While I1 < PageList.Count do begin
      If Assigned(PageList[I1]) and (PageList[I1] = OldItem) then begin
        If Assigned(NewItem) then begin
          PageList[I1] := NewItem; { Replace with NewItem }
        end else begin
          PageList.Delete(I1); { Remove OldItem from PageList }
          Dec(I1);
        end; { else }
      end; { if }
      Inc(I1);
    end; { while }
  end; { if }
end;  { Changing }

procedure TRaveReport.SaveToStreamHelper(StreamHelper: TStreamHelper);

var
  I1: integer;

begin { SaveToStreamHelper }
  With StreamHelper do begin
    WriteString(LastActivePage);

  { Write out list of owned editors }
    WriteIndex(ChildCount);
    For I1 := 0 to (ChildCount - 1) do begin
      WriteByte(0); { Marker for TRaveProjectItem type }
      WriteString(Child[I1].Name);
    end; { for }

  { Write out list of loaded editors }
    WriteIndex(LoadedList.Count);
    For I1 := 0 to (LoadedList.Count - 1) do begin
      WriteString(TRavePage(LoadedList[I1]).Name);
    end; { for }

  { Write out report properties }
    With TRaveWriter.Create(StreamHelper) do try
      WriteComponent(self,false);
    finally
      Free;
    end; { with }

  { Write out pages }
    For I1 := 0 to (ChildCount - 1) do begin
      StreamHelper.StartWriteBlock;
      TRavePage(Child[I1]).SaveToStreamHelper(StreamHelper);
      StreamHelper.FinishWriteBlock;
    end; { for }
  end; { with }
end;  { SaveToStreamHelper }

procedure TRaveReport.LoadFromStreamHelper(StreamHelper: TStreamHelper);
var
  I1: integer;
  I2: integer;
  NameFound: boolean;
  TestChild: TRaveComponent;
  Items: integer;
  Item: TRaveProjectItem;
begin { LoadFromStreamHelper }
  With StreamHelper do begin
    If TRaveProjectManager(Project).Version >= 30004 then begin {!!! Remove check before release }
      LastActivePage := ReadString;
    end; { if }

    FixUpList := TStringList.Create;
  { Read in list of owned pages }
    Items := ReadIndex;
    For I1 := 1 to Items do begin
      Case ReadByte of
        0: Item := TRavePage.Create(self);
        else Raise EClassNotFound.Create(Trans('TRaveProjectItem class not found'));
      end; { case }
      Item.Parent := self;
      Item.Name := ReadString;
    end; { for }

  { Read in list of loaded pages }
    Items := ReadIndex;
    For I1 := 1 to Items do begin
      FixupList.Add(ReadString);
    end; { for }

  { Add all owned pages if not already in FixupList to fix 3.0D bug }
    For I1 := 0 to ChildCount - 1 do begin
      TestChild := TRaveComponent(Child[I1]);
      NameFound := false;
      For I2 := 0 to FixupList.Count - 1 do begin
        If CompareText(TestChild.Name,FixupList[I2]) = 0 then begin
          NameFound := true;
          Break;
        end; { if }
      end; { for }
      If not NameFound then begin
        FixupList.Add(TestChild.Name);
      end; { if }
    end; { for }

  { Read in report properties }
    With TRaveReader.Create(StreamHelper) do try
      MasterProject := TRaveProjectManager(Project).MasterProject;
      ReadIntoComponent(self);
    finally
      Free;
    end; { with }

  { Read in pages }
    For I1 := 0 to (ChildCount - 1) do begin
      StreamHelper.StartReadBlock;
      TRavePage(Child[I1]).LoadFromStreamHelper(StreamHelper);
      StreamHelper.FinishReadBlock;
    end; { for }
  end; { with }
end;  { LoadFromStreamHelper }

procedure TRaveReport.ProcessLoaded;

var
  I1: integer;
  Item: TRaveComponent;

begin { ProcessLoaded }
  If not Assigned(FixUpList) then Exit;
  For I1 := 0 to FixUpList.Count - 1 do begin
    Item := TRaveProjectManager(Project).FindRaveComponent(FixUpList[I1],self);
    If Assigned(Item) and (Item is TRavePage) then begin
      LoadedList.Add(TRavePage(Item));
    end else begin
    //!!! Error, editor not found
    end; { else }
  end; { for }
  FixUpList.Free;
  FixUpList := nil;
end;  { ProcessLoaded }

function TRaveReport.GetLoadedCount: integer;

begin { GetLoadedCount }
  Result := LoadedList.Count;
end;  { GetLoadedCount }

function TRaveReport.GetLoaded(Index: integer): TRavePage;

begin { GetLoaded }
  If (Index >= 0) and (Index <= LoadedList.Count) then begin
    Result := LoadedList[Index];
  end else begin
    Result := nil;
  end; { else }
end;  { GetLoaded }

procedure TRaveReport.SetPageList(Value: TRaveComponentList);

begin { SetPageList }
  If Assigned(Value) and (Value.Count > 0) then begin
    If not Assigned(FPageList) then begin
      FPageList := TRaveComponentList.Create;
    end; { if }
    CopyList(Value,FPageList);
  end else begin
    If Assigned(FPageList) then begin
      FPageList.Free;
      FPageList := nil;
    end; { if }
  end; { else }
end;  { SetPageList }

procedure TRaveReport.LoadPage(Page: TRavePage);

begin { LoadPage }
  LoadedList.Add(Page);
  Page.Open;
  If SaveEnvOnly then begin
    TRaveProjectManager(Project).DataChanged := true;
  end; { if }
end;  { LoadPage }

procedure TRaveReport.UnloadPage(Page: TRavePage);

begin { UnloadPage }
  Page.Close;
  LoadedList.Remove(Page);
  If SaveEnvOnly then begin
    TRaveProjectManager(Project).DataChanged := true;
  end; { if }
end;  { UnloadPage }

procedure TRaveReport.Open;
var
  I1: integer;
  Page: TRavePage;
begin { Open }
  If not Active then begin
    inherited Open;
    For I1 := 0 to ChildCount - 1 do begin
      TRaveProjectItem(Child[I1]).Open;
    end; { for }
    For I1 := 0 to LoadedList.Count - 1 do begin
      Page := TRavePage(LoadedList[I1]);
      If Page.Global then begin
        Page.Open;
      end; { if }
    end; { for }
  end; { if }
  TRaveProjectManager(Project).FreeForwardRefs;
end;  { Open }

procedure TRaveReport.Close;

var
  I1: integer;

begin { Close }
  If not Active then Exit;
  inherited Close;
  For I1 := 0 to LoadedList.Count - 1 do begin
    TRaveProjectItem(LoadedList[I1]).Close;
  end; { for }
end;  { Close }

procedure TRaveReport.Compile;

var
  I1: integer;

begin { Compile }
  inherited Compile;
  For I1 := 0 to ChildCount - 1 do begin
    If Child[I1] is TRaveProjectItem then begin
      TRaveProjectItem(Child[I1]).Compile;
    end; { if }
  end; { for }
end;  { Compile }

function TRaveReport.NewPage: TRavePage;

begin { NewPage }
  Result := TRavePage.Create(self);
  Result.Parent := self;
  Result.Name := TRaveProjectManager(Project).GetUniqueName({Trans-}'Page',self,false);
  LoadPage(Result);
  TRaveProjectManager(Project).DataChanged := true;
end;  { NewPage }

procedure TRaveReport.RSPrint(Sender: TObject);

var
  CurrPage: TRavePage;
  Beginning: boolean;
  PageStack: TRaveStackList;
  PageIdx: integer;
  DonePrint: boolean;
  I1: integer;
  Pages: integer;

begin { RSPrint }
{ BaseReport is initialized to printing engine }
  (Sender as TBaseReport).NoBufferLine := true;

  Pages := MaxPages;
  PageIdx := 0;
  If Assigned(PageList) and (PageList.Count > 0) then begin
    CurrPage := nil;
  end else begin
    CurrPage := FirstPage;
  end; { else }
  Beginning := true;
  PageStack := TRaveStackList.Create;
  try
    Repeat
      If not Assigned(CurrPage) then begin { Get new page }
        If PageStack.Empty then begin
          Inc(PageIdx);
          If Assigned(PageList) and (PageList.Count >= PageIdx) then begin
            CurrPage := TRavePage(PageList[PageIdx - 1]);
          end else begin
            Break; { Done printing pages }
          end; { else }
        end else begin
          CurrPage := TRavePage(PageStack.Pop);
        end; { else }
      end; { if }

      If not Beginning then begin
      { Set up new page }
        If CurrPage.Orientation <> poDefault then begin
          (Sender as TBaseReport).Orientation := CurrPage.Orientation;
        end; { if }
        If CurrPage.BinCustom <> '' then begin
          (Sender as TBaseReport).SelectBin(CurrPage.BinCustom);
        end else if CurrPage.Bin <> -1 then begin
          If RPDev <> nil then begin
            For I1 := 0 to RPDev.Bins.Count - 1 do begin
              If longint(RPDev.Bins.Objects[I1]) = CurrPage.Bin then begin
                (Sender as TBaseReport).SelectBin(RPDev.Bins[I1]);
              end; { if }
            end; { for }
          end; { if }
        end; { else }
      { Go to new page }
        (Sender as TBaseReport).NewPage;
      end else begin
        Beginning := false;
      end; { else }
      CurrPage.PrintAll((Sender as TBaseReport));
      DonePrint := CurrPage.DonePrinting;
      Case CurrPage.GotoMode of
        gmGotoDone: begin
          If DonePrint then begin
            CurrPage := CurrPage.GotoPage;
          end; { if }
        end;
        gmGotoNotDone: begin
          If not DonePrint then begin
            CurrPage := CurrPage.GotoPage;
          end else begin
            CurrPage := nil;
          end; { else }
        end;
        gmCallEach: begin
          If Assigned(CurrPage.GotoPage) then begin
            If not DonePrint then begin
              PageStack.Push(CurrPage);
            end; { if }
            CurrPage := CurrPage.GotoPage;
          {!!! Init CurrPage }
          end else begin
            If DonePrint then begin
              CurrPage := nil;
            end; { if }
          end; { else }
        end;
      end; { case }
      If Pages > 0 then begin
        Dec(Pages);
        If Pages = 0 then Break;
      end; { if }
    until false;
  finally
    PageStack.Free;
  end; { tryf }
end;  { RSPrint }

procedure TRaveReport.RSBeforePrint(Sender: TObject);

var
  Page: TRavePage;
  I1: integer;

begin { RSBeforePrint }
  TRaveProjectManager(Project).BaseReport := (Sender as TBaseReport);

{ Configure BaseReport }
  If Printer <> '' then begin
    (Sender as TBaseReport).SelectPrinter(Printer);
  end; { if }
  If Collate <> pcDefault then begin
    (Sender as TBaseReport).Collate := boolean(Ord(Collate));
  end; { if }
  If Duplex <> pdDefault then begin
    (Sender as TBaseReport).Duplex := TDuplex(Ord(Duplex));
  end; { if }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  If (Resolution <> prDefault) and Assigned((Sender as TBaseReport).DevMode) then begin
    (Sender as TBaseReport).DevMode^.dmPrintQuality := RavePrinterResolution[Resolution];
  end; { if }
  {$ENDIF}
  If Copies > 0 then begin
    (Sender as TBaseReport).Copies := Copies;
  end; { if }

{ Get first page to be printed }
  If Assigned(PageList) and (PageList.Count > 0) then begin
    Page := TRavePage(PageList[0]);
  end else begin
    Page := FirstPage;
  end; { else }

  If Assigned(Page) then begin { Configure first page - PaperSize, Orientation, Bin }
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    If Page.PaperSize = DMPAPER_USER then begin
      (Sender as TBaseReport).SetPaperSize(0,Page.PageWidth,Page.PageHeight);
    end else if Page.PaperSize <> -1 then begin
      (Sender as TBaseReport).SetPaperSize(Page.PaperSize,0,0);
    end; { else }
    {$ENDIF}
    If Page.Orientation <> poDefault then begin
      (Sender as TBaseReport).Orientation := Page.Orientation;
    end; { if }

    If Page.BinCustom <> '' then begin
      (Sender as TBaseReport).SelectBin(Page.BinCustom);
    end else if Page.Bin <> -1 then begin
      If RPDev <> nil then begin
        For I1 := 0 to RPDev.Bins.Count - 1 do begin
          If longint(RPDev.Bins.Objects[I1]) = Page.Bin then begin
            (Sender as TBaseReport).SelectBin(RPDev.Bins[I1]);
          end; { if }
        end; { for }
      end; { if }
    end; { else }
  end; { if }

  If Assigned(SaveBeforePrint) then begin
    SaveBeforePrint(Sender);
  end; { if }
end;  { RSBeforePrint }

procedure TRaveReport.RSAfterPrint(Sender: TObject);

begin { RSAfterPrint }
  TRaveProjectManager(Project).BaseReport := GBaseReport;

  If Assigned(SaveAfterPrint) then begin
    SaveAfterPrint(Sender);
  end; { if }
end;  { RSAfterPrint }

procedure TRaveReport.InternalExecute(Engine: TRPComponent);
var
  I1: integer;
  LHaveControl: boolean;
  SavedUnitsFactor: TRaveFloat;
begin { InternalExecute }
  TRaveProjectManager(Project).PrepareModule;

{$IFDEF DESIGNER}
  If Assigned(CurrentDesigner) then begin
    CurrentDesigner.ClearSelection;
  end; { if }
{$ENDIF}

{ Save designed state for report and all global pages }
  SaveDesigned;
  For I1 := 0 to TRaveProjectManager(Project).GlobalPageList.Count - 1 do begin
    TRaveReport(TRaveProjectManager(Project).GlobalPageList[I1]).SaveDesigned;
  end; { for }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  if RaveDataSystem <> nil then begin
    RaveDataSystem.AutoUpdate := true;
  end;
  {$ENDIF}
  TRaveProjectManager(Project).BeforeReport; { Initialize all components }
  TRaveProjectManager(Project).FPrinting := true;

  LHaveControl := True;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  if RaveDataSystem <> nil then begin
    LHaveControl := RaveDataSystem.GainControl;
  end;
  {$ENDIF}
  If LHaveControl then try
    If Assigned(Engine) then begin
      If Engine is TReportSystem then begin
        With Engine as TReportSystem do begin
          SavedUnitsFactor := SystemPrinter.UnitsFactor;
          SystemPrinter.UnitsFactor := 1;
          If BaseReport <> nil then begin
            try
              TRaveProjectManager(Project).BaseReport := BaseReport;
              RSPrint(BaseReport);
            finally
              SystemPrinter.UnitsFactor := SavedUnitsFactor;
            end; { tryf }
          end else begin
            SaveOnPrint := OnPrint;
            OnPrint := RSPrint;
            SaveBeforePrint := OnBeforePrint;
            OnBeforePrint := RSBeforePrint;
            SaveAfterPrint := OnAfterPrint;
            OnAfterPrint := RSAfterPrint;
            If AlwaysGenerate then begin
              SystemOptions := SystemOptions + [soUseFiler];
            end; { if }
            try
              Execute;
            finally
              OnPrint := SaveOnPrint;
              OnBeforePrint := SaveBeforePrint;
              OnAfterPrint := SaveAfterPrint;
              SystemPrinter.UnitsFactor := SavedUnitsFactor;
            end; { tryf }
          end; { else }
        end; { with }
      end else begin { Not a TReportSystem, treat as TBaseReport }
        With Engine as TBaseReport do begin
          SavedUnitsFactor := UnitsFactor;
          UnitsFactor := 1;
          If Printing then begin
            try
              TRaveProjectManager(Project).BaseReport := Engine as TBaseReport;
              RSPrint(Engine as TBaseReport);
            finally
              UnitsFactor := SavedUnitsFactor;
            end; { tryf }
          end else begin { Not printing }
            SaveOnPrint := OnPrint;
            OnPrint := RSPrint;
            SaveBeforePrint := OnBeforePrint;
            OnBeforePrint := RSBeforePrint;
            SaveAfterPrint := OnAfterPrint;
            OnAfterPrint := RSAfterPrint;
            try
              Execute;
            finally
              OnPrint := SaveOnPrint;
              OnBeforePrint := SaveBeforePrint;
              OnAfterPrint := SaveAfterPrint;
              UnitsFactor := SavedUnitsFactor;
            end; { tryf }
          end; { else }
        end; { with }
      end; { else }
    end else begin { No Engine assigned, create TReportSystem component }
      With TReportSystem.Create(Application.MainForm) do try
        DefaultDest := PrintDestination;
        TitleSetup := Trans('Output Options');
        If AllowSetup then begin
          SystemSetups := SystemSetups + [ssAllowSetup];
        end else begin
          SystemSetups := SystemSetups - [ssAllowSetup];
        end; { else }
        SystemPreview.GridHoriz := PreviewGridHoriz;
        SystemPreview.GridVert := PreviewGridVert;
        SystemPreview.GridPen.Color := PreviewGridColor;
        SystemPreview.GridPen.Style := PreviewGridPenStyle;
        SystemPreview.RulerType := PreviewRulerType;
        SystemPreview.MarginPercent := 2.5;
        SystemPreview.ShadowDepth := PreviewShadowDepth;
        SystemPreview.ZoomInc := PreviewZoomInc;
        SystemPreview.ZoomFactor := PreviewZoomFactor;
        SystemPreview.FormState := PreviewWindowState;
        SystemPreview.Monochrome := PreviewMonochrome;
        SystemFiler.AccuracyMethod := amAppearance;
        If AlwaysGenerate then begin
          SystemOptions := SystemOptions + [soUseFiler];
        end; { if }
        SaveOnPrint := OnPrint;
        OnPrint := RSPrint;
        SaveBeforePrint := nil;
        OnBeforePrint := RSBeforePrint;
        SaveAfterPrint := nil;
        OnAfterPrint := RSAfterPrint;
        SystemFiler.StreamMode := smTempFile;
        try
          Execute;
        finally
          OnPrint := SaveOnPrint;
          OnBeforePrint := SaveBeforePrint;
          OnAfterPrint := SaveAfterPrint;
        end; { tryf }
      finally
        Free;
      end; { with }
    end; { else }
  finally
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    if RaveDataSystem <> nil then begin
      RaveDataSystem.ReleaseControl;
    end;
    {$ENDIF}
    TRaveProjectManager(Project).AfterReport;

  {$IFDEF DESIGNER}
    If Assigned(CurrentDesigner) then begin
      CurrentDesigner.Invalidate;
    end; { if }
  {$ENDIF}

  { Restore designed state for report and all global pages }
(*
    RestoreDesigned;
    For I1 := 0 to TRaveProjectManager(Project).GlobalPageList.Count - 1 do begin
      TRaveReport(TRaveProjectManager(Project).GlobalPageList[I1]).RestoreDesigned;
    end; { for }
*)
    TRaveProjectManager(Project).FPrinting := false;
  end; { if }
end;  { InternalExecute }

procedure TRaveReport.Execute(Engine: TRPComponent);
var
  LProject: TRaveProjectManager;
  LRaveContainer: TRaveContainerControl;
  LStream: TStream;
begin { Execute }
  HoldAddDeleteComponents := true;
  LStream := TMemoryStream.Create;
  try
    TRaveProjectManager(Project).ReportToStream(Self, LStream);
    LRaveContainer := TRaveContainerControl.Create(nil);
    try
      LProject := TRaveProjectManager.Create(LRaveContainer);
      try
        LProject.MasterProject := TRaveProjectManager(Project);
        try
          LStream.Position := 0;
          LProject.NoDesigner := true;
          LProject.LoadFromStream(LStream);
          LProject.Params.Assign(TRaveProjectManager(Project).Params);
        finally
          LProject.MasterProject := nil;
        end;
        LProject.FindReport(FullName,true).InternalExecute(Engine);
      finally
        FreeAndNil(LProject);
      end;
    finally
      FreeAndNil(LRaveContainer);
    end;
  finally
    HoldAddDeleteComponents := false;
    FreeAndNil(LStream);
  end;
end;  { Execute }

(*****************************************************************************}
( class TRaveModuleManager
(*****************************************************************************)

constructor TRaveModuleManager.Create(AProjectManager: TRaveProjectManager);
begin { Create }
  inherited Create;
  ModuleList := TList.Create;
  FProjectManager := AProjectManager;
end;  { Create }

destructor TRaveModuleManager.Destroy;
var
  I1: integer;
begin { Destroy }
  For I1 := 0 to ModuleList.Count - 1 do begin
    TRaveModule(ModuleList[I1]).Free;
  end; { for }
  FreeAndNil(ModuleList);
  inherited Destroy;
end;  { Destroy }

function TRaveModuleManager.ModuleIndex(ModuleName: string): integer;
var
  I1: integer;
begin { ModuleIndex }
  For I1 := 0 to ModuleList.Count - 1 do begin
    If SameStr(TRaveModule(ModuleList[I1]).ModuleName,ModuleName) then begin
      Result := I1;
      Exit;
    end; { if }
  end; { for }
  Result := -1;
end;  { ModuleIndex }

function TRaveModuleManager.LoadModule(ModuleName: string): integer;
var
  Module: TRaveModule;
  Stream: TMemoryStream;
begin { LoadModule }
  Stream := TMemoryStream.Create;
  try
    Stream.LoadFromFile(ModuleName + {Trans-}'.RVC');
    Module := CreateRaveModule(Stream,ProjectManager,nil);
  finally
    Stream.Free;
  end; { tryf }
  Result := ModuleList.Add(Module);
  RegisterRaveModule(Module);
end;  { LoadModule }

function TRaveModuleManager.GetModule(ModuleName: string): TRaveModule;
var
  I1: integer;
begin { GetModule }
  I1 := ModuleIndex(ModuleName);
  If I1 < 0 then begin { Try to load module }
    I1 := LoadModule(ModuleName);
    If I1 < 0 then begin
      RaiseError(Trans(Format({Trans+}'Could not load module [%s]',[ModuleName])));
    end; { if }
  end; { if }
  Result := TRaveModule(ModuleList[I1]);
end;  { GetModule }

function TRaveModuleManager.FindModule(ModuleName: string): TRaveModule;
var
  I1: integer;
begin { FindModule }
  I1 := ModuleIndex(ModuleName);
  If I1 < 0 then begin
    Result := nil;
  end else begin
    Result := TRaveModule(ModuleList[I1]);
  end; { else }
end;  { FindModule }

procedure TRaveModuleManager.LoadModules(StreamHelper: TStreamHelper);
var
  I1: integer;
  I2: integer;
  ModCount: integer;
  Module: TRaveModule;
  OldModule: TRaveModule;
begin { LoadModules }
  With StreamHelper do begin
    ModCount := ReadIndex;
    For I1 := 1 to ModCount do begin
      ReadString; // Module name

      StartReadBlock;
    // Load the module from the stream
      Module := CreateRaveModule(Stream,ProjectManager,nil);
    // Register the module
      I2 := ModuleIndex(Module.ModuleName);
      If I2 >= 0 then begin // Already registered, replace
        OldModule := ModuleList[I2];
        ModuleList[I2] := Module;
        OldModule.Free;
      end else begin // Add module
        ModuleList.Add(Module);
      end; { else }
      RegisterRaveModule(Module);
      FinishReadBlock;
    end; { for }
  end; { with }
end;  { LoadModules }

procedure TRaveModuleManager.SaveModules(StreamHelper: TStreamHelper);
var
  I1: integer;
begin { SaveModules }
  With StreamHelper do begin
    WriteIndex(ModuleList.Count);
    For I1 := 0 to ModuleList.Count - 1 do begin
      WriteString(TRaveModule(ModuleList[I1]).ModuleName);
      StartWriteBlock;
      TRaveModule(ModuleList[I1]).SaveToStream(StreamHelper.Stream);
      FinishWriteBlock;
    end; { for }
  end; { with }
end;  { SaveModules }

(*****************************************************************************}
( class TRaveProjectManager
(*****************************************************************************)

constructor TRaveProjectManager.Create(AOwner: TComponent);
begin { Create }
  inherited Create(AOwner);

  FReportList := TList.Create;
  FGlobalPageList := TList.Create;
  FDataObjectList := TList.Create;
  FCategories := TStringList.Create;
  Params := TStringList.Create;
  FBaseReport := GBaseReport;
  FModuleManager := TRaveModuleManager.Create(self);

  Signature := {Trans-}'RAV'#26;
  UnitsFactor := ProjectUnitsFactor;
end;  { Create }

destructor TRaveProjectManager.Destroy;
begin { Destroy }
  Clear;
  FreeAndNil(FModuleManager);
  FreeAndNil(Params);
  FreeAndNil(FCategories);
  FreeAndNil(FReportList);
  FreeAndNil(FGlobalPageList);
  FreeAndNil(FDataObjectList);

  inherited Destroy;
end;  { Destroy }

procedure TRaveProjectManager.ReportToStream(AReport: TRaveReport;
                                             AStream: TStream);

var
  StreamHelper: TStreamHelper;

  procedure ClearProjectItem(ProjectItem: TRaveProjectItem);
  var
    I1: integer;
  begin { ClearProjectItem }
    ProjectItem.Included := false;
    For I1 := 0 to ProjectItem.ComponentCount - 1 do begin
      If ProjectItem.Components[I1] is TRaveProjectItem then begin
        ClearProjectItem(TRaveProjectItem(ProjectItem.Components[I1]));
      end; { if }
    end; { for }
  end;  { ClearProjectItem }

  procedure ClearProjectItems(ProjectItemList: TList);
  var
    I1: integer;
  begin { ClearProjectItems }
    For I1 := 0 to ProjectItemList.Count - 1 do begin
      ClearProjectItem(TRaveProjectItem(ProjectItemList[I1]));
    end; { for }
  end;  { ClearProjectItems }

  procedure AddProjectItems(ProjectItemList: TList);
  var
    I1: integer;
  begin { AddProjectItems }
    For I1 := 0 to ProjectItemList.Count - 1 do begin
      If TRaveProjectItem(ProjectItemList[I1]).Included then begin
        ExportList.Add(ProjectItemList[I1]);
      end; { if }
    end; { for }
  end;  { AddProjectItems }

  procedure SetIncluded(Item: TPersistent;
                        DoOwned: boolean);

  var
    Count: integer;
    PropList: PPropList;
    PropInfo: PPropInfo;
    I1: integer;
    I2: integer;
    O1: TObject;

    procedure CheckComponent(C1: TComponent);

    begin { CheckComponent }
      If Assigned(C1) then begin
        If C1 is TRaveProjectItem then begin
          If not TRaveComponentAccess(C1).UseMaster and not TRaveProjectItem(C1).Included then begin
            TRaveProjectItem(C1).Included := true;
            SetIncluded(TRaveProjectItem(C1),true);
          end; { if }
        end; { if }
      end; { if }
    end;  { CheckComponent }

  begin { SetIncluded }
    If Assigned(Item) then begin
      Count := GetTypeData(Item.ClassInfo)^.PropCount;
      If Count > 0 then begin
        GetMem(PropList,Count * SizeOf(pointer));
        try
          GetPropInfos(Item.ClassInfo,PropList);
          For I1 := 0 to (Count - 1) do begin
            PropInfo := PropList^[I1];
            If PropInfo.PropType^.Kind = tkClass then begin
              O1 := TObject(GetOrdProp(Item,PropInfo));
              If Assigned(O1) then begin
                If O1 is TComponent then begin
                  CheckComponent(TComponent(O1).Owner);
                  CheckComponent(TComponent(O1));
                end else if O1 is TPersistent then begin
                  SetIncluded(TPersistent(O1),false);
                end else if O1 is TRaveComponentList then begin
                  For I2 := 0 to TRaveComponentList(O1).Count - 1 do begin
                    CheckComponent(TComponent(TRaveComponentList(O1)[I2]).Owner);
                    CheckComponent(TComponent(TRaveComponentList(O1)[I2]));
                  end; { for }
                end else if O1 is TRavePersistentList then begin
                  For I2 := 0 to TRavePersistentList(O1).Count - 1 do begin
                    SetIncluded(TPersistent(TRavePersistentList(O1)[I2]),false);
                  end; { for }
                end; { else }
              end; { if }
            end; { if }
          end; { for }
        finally
          FreeMem(PropList,Count * SizeOf(pointer));
        end; { tryf }
      end; { if }

      If DoOwned and (Item is TComponent) then begin
        For I1 := 0 to TComponent(Item).ComponentCount - 1 do begin
          SetIncluded(TComponent(Item).Components[I1],true);
        end; { for }
      end; { if }
    end; { if }
  end;  { SetIncluded }

begin { ReportToStream }
// Include all other project items that it references
  ClearProjectItems(ReportList);
  ClearProjectItems(GlobalPageList);
  ClearProjectItems(DataObjectList);
  Included := true;
  AReport.Included := true;
  SetIncluded(AReport,false);

// Create ExportList
  ExportList := TList.Create;
  ExportList.Add(AReport);
  AddProjectItems(GlobalPageList);
  AddProjectItems(DataObjectList);

// Write out items to stream
  StreamHelper := TStreamHelper.Create(AStream);
  With StreamHelper do try
    CompressMethod := NoCompression;
    SaveToStreamHelper(StreamHelper);
  finally
    Free;
  end; { with }
  FreeAndNil(ExportList);
end;  { ReportToStream }

procedure TRaveProjectManager.Clear;

begin { Clear }
  ClearObjectList(ReportList);
  ClearObjectList(GlobalPageList);
  ClearObjectList(DataObjectList);
end;  { Clear }

procedure TRaveProjectManager.DefineProperties(Filer: TFiler);
begin { DefineProperties }
  inherited DefineProperties(Filer);
  Filer.DefineProperty({Trans-}'Params', ReadParamValues, WriteParamValues,
   StreamParamValues and (Params.Count > 0));
end;  { DefineProperties }

procedure TRaveProjectManager.ReadParamValues(Reader: TReader);
var
  ParamBuf: string;
  ParamPtr: PChar;
  ParamName: string;
  ParamData: string;
begin { ReadParamValues }
  ParamBuf := Reader.ReadString;
  If ParamBuf <> '' then begin
    ParamPtr := @ParamBuf[1];
    While ParamPtr^ <> #0 do begin
      ParamName := AnsiExtractQuotedStr(ParamPtr,'"');
      Inc(ParamPtr); { Skip comma }
      ParamData := AnsiExtractQuotedStr(ParamPtr,'"');
      SetParam(ParamName, ParamData);
      Inc(ParamPtr); { Skip semicolon }
    end; { while }
  end; { else }
end;  { ReadParamValues }

procedure TRaveProjectManager.WriteParamValues(Writer: TWriter);
var
  ParamBuf: string;
  I1: integer;
begin { WriteParamValues }
  ParamBuf := '';
  For I1 := 0 to (Params.Count - 1) do begin
    ParamBuf := ParamBuf + AnsiQuotedStr(Params.Names[I1], '"') + ',' +
     AnsiQuotedStr(Params.Values[Params.Names[I1]] ,'"') + ';';
  end; { for }
  Writer.WriteString(ParamBuf);
end;  { WriteParamValues }

procedure TRaveProjectManager.LoadFromStreamHelper(StreamHelper: TStreamHelper);
var
  TagKind: TTagKind;
  Item: TRaveProjectItem;
  ItemName: string;
  I1: integer;
  RaveReport: TRaveReport;
  TestSig: string;
begin { LoadFromStreamHelper }
  With StreamHelper do begin
    SetLength(TestSig,4);
    Stream.Read(TestSig[1],4);
    If TestSig <> Signature then begin
      RaveError(Trans('Invalid Project Format'));
      Exit;
    end; { if }
    Stream.Read(FVersion,SizeOf(FVersion));

  { Read project header information }
    TagKind := TTagKind(ReadByte); { Should be tkProject }
    If TagKind <> tkProject then begin
      RaveError(Trans('Invalid Project Header Code'));
      Exit;
    end; { if }

  { Read in library modules }
    If Version >= 40005 then begin
      ModuleManager.LoadModules(StreamHelper);
    end; { if }

    If Importing then begin
    { Absorb and ignore project header }
      ReadString; { Absorb LastActivePage }
      With TRaveReader.Create(StreamHelper) do try
        MasterProject := self.FMasterProject;
        ReadComponent(self,self).Free;
      finally
        Free;
      end; { with }
    end else begin
    { Read in project header }
      LastActiveReport := ReadString;
      With TRaveReader.Create(StreamHelper) do try
        MasterProject := self.FMasterProject;
        ReadIntoComponent(self);
      finally
        Free;
      end; { with }
    end; { else }

  { Read in ProjectItem blocks }
    Repeat
      TagKind := TTagKind(ReadByte);
      ItemName := ReadString;
      If Importing then begin
        Item := FindRaveComponent(ItemName, TRaveProjectManager(Project)) as TRaveProjectItem;
        If Assigned(Item) then begin
          If Assigned(FOnImportConflict) then begin
            FOnImportConflict(Item,ItemName);
          end else begin
            If ImportReplace then begin { Delete and replace old item }
              DeleteItem(Item,false);
            //!!! Need to make it so that links to this item or components on
            //!!! this item are preserved.
            end else begin { Get new name }
              ItemName := GetUniqueName(ItemName, TRaveProjectManager(Project), false);
            end; { else }
          end; { else }
        end; { if }
      end; { if }

      Case TagKind of
        tkDataView: begin // Only used to load pre 4.0 projects
          {$IFDEF Linux}
          //!!PORT!!
          {$ELSE}
          Item := TRaveDataView.Create(self);
          DataObjectList.Add(Item);
          {$ENDIF}
        end;
        tkDataObject: begin
          Item := TRaveDataObjectClass(FindClass(ReadString)).Create(self);
          DataObjectList.Add(Item);
        end;
        tkPage: begin
          Item := TRavePage.Create(self);
          GlobalPageList.Add(Item);
        end;
        else begin { tkReport }
          Item := TRaveReport.Create(self);
          ReportList.Add(Item);
          FActiveReport := Item as TRaveReport;
        end;
      end; { case }
      Item.Parent := self;
      If ItemName <> '' then begin
        Item.Name := ItemName;
        AddComponent(Item);
      end; { if }
      StartReadBlock;
      Item.LoadFromStreamHelper(StreamHelper);
      FinishReadBlock;
      FActiveReport := nil;
      If ItemName = '' then begin
        Case TagKind of
          tkDataView,tkDataObject: DataObjectList.Remove(Item);
          tkPage: GlobalPageList.Remove(Item);
          else ReportList.Remove(Item);
        end; { case }
        Item.Free;
      end; { if }
    until Empty;
  end; { with }
  FreeForwardRefs;

{ Activate report }
  RaveReport := nil;
  For I1 := 0 to ReportList.Count - 1 do begin
    TRaveReport(ReportList[I1]).ProcessLoaded;
    If (LastActiveReport <> '') and
     (TRaveReport(ReportList[I1]).Name = LastActiveReport) then begin
      RaveReport := TRaveReport(ReportList[I1]);
    { Break; Don't break since we need to call ProcessLoaded for each report }
    end; { if }
  end; { for }

  If Assigned(RaveReport) then begin
    ActivateReport(RaveReport);
  end else begin
    If ReportList.Count > 0 then begin
      ActivateReport(TRaveReport(ReportList[0]));
    end; { if }
  end; { else }
  FreeForwardRefs;
  PostLoad;
  ClearChanged;
  Saved := true;
end;  { LoadFromStreamHelper }

procedure TRaveProjectManager.SaveToStreamHelper(StreamHelper: TStreamHelper);

  procedure WriteListNames(List: TList;
                           TagKind: TTagKind);

  var
    I1: longint;

  begin { WriteListNames }
    With StreamHelper do begin
      For I1 := 0 to (List.Count - 1) do begin
        If Assigned(ExportList) then begin { Look for item in list }
          If ExportList.IndexOf(List[I1]) < 0 then Continue; { Don't export item }
        end; { if }
        WriteByte(Ord(TagKind));
        WriteString(TRaveProjectItem(List[I1]).Name);
        If TagKind = tkDataObject then begin
          WriteString(TRaveDataObject(List[I1]).ClassName);
        end; { if }
        StartWriteBlock;
        TRaveProjectItem(List[I1]).SaveToStreamHelper(StreamHelper);
        FinishWriteBlock;
      end; { for }
    end; { with }
  end;  { WriteListNames }

begin { SaveToStreamHelper }
  StreamHelper.WriteBuf(Signature[1],4);
  FVersion := RaveVersion;
  StreamHelper.WriteBuf(FVersion,SizeOf(FVersion));

  StreamHelper.WriteByte(Ord(tkProject));
  ModuleManager.SaveModules(StreamHelper);
  StreamHelper.WriteString(LastActiveReport);
  With TRaveWriter.Create(StreamHelper) do try
    WriteComponent(self,false);
  finally
    Free;
  end; { with }
  WriteListNames(DataObjectList,tkDataObject);
  WriteListNames(GlobalPageList,tkPage);
  WriteListNames(ReportList,tkReport);
  If not Assigned(ExportList) then begin
    ClearChanged;
    Saved := true;
  end; { if }
end;  { SaveToStreamHelper }

procedure TRaveProjectManager.LoadFromStream(Stream: TStream);

var
  StreamHelper: TStreamHelper;

begin { LoadFromStream }
  StreamHelper := TStreamHelper.Create(Stream);
  With StreamHelper do try
    LoadFromStreamHelper(StreamHelper);
  finally
    Free;
  end; { with }
end;  { LoadFromStream }

procedure TRaveProjectManager.SaveToStream(Stream: TStream);

var
  StreamHelper: TStreamHelper;

begin { SaveToStream }
  StreamHelper := TStreamHelper.Create(Stream);
  With StreamHelper do try
    SaveToStreamHelper(StreamHelper);
  finally
    Free;
  end; { with }
end;  { SaveToStream }

procedure TRaveProjectManager.SetCategories(Value: TStrings);

begin { SetCategories }
  FCategories.Assign(Value);
end;  { SetCategories }

procedure TRaveProjectManager.Changing(OldItem: TRaveComponent;
                                       NewItem: TRaveComponent);

begin { Changing }
  inherited Changing(OldItem,NewItem);
  If Assigned(SecurityControl) and (OldItem = SecurityControl) then begin
    SecurityControl := NewItem as TRaveBaseSecurity;
  end; { if }
end;  { Changing }

procedure TRaveProjectManager.SetDepth(Control: TRaveComponent;
                                       Adjustment: integer);

var
  I1: integer;
  I2: integer;
  ChildList: TList;

begin { SetDepth }
  If Control is TRaveReport then begin
    ChildList := ReportList;
  end else if Control is TRavePage then begin
    ChildList := GlobalPageList;
  end else if Control is TRaveDataObject then begin
    ChildList := DataObjectList;
  end else begin
    Exit;
  end; { else }

  With ChildList do begin
    I1 := IndexOf(Control);
    Case Adjustment of
      1: I2 := 0;           { 1: Send to back }
      2: I2 := I1 - 1;      { 2: Move behind }
      3: I2 := I1 + 1;      { 3: Move forward }
      else I2 := Count - 1; { 4: Bring to front }
    end; { case }
    If (I1 >= 0) and (I2 >= 0) and (I2 < Count) and (I1 <> I2) then begin
      Delete(I1);
      Insert(I2,Control);
      If Control is TRaveControl then begin
        TRaveControl(Control).Invalidate;
      end; { if }
    end; { if }
  end; { with }
end;  { SetDepth }

function TRaveProjectManager.FindRaveComponent(Name: string;
                                               DefRoot: TRaveComponent): TRaveComponent;

var
  I1: integer;
  I2: integer;
  P1: TRavePage;
  Item: TRaveProjectItem;
  ObjectName: string;
  Root: TRaveComponent;

begin { FindRaveComponent }
//TODO: Add capability to process Owner.Owner.Component strings
  I1 := Pos('.',Name);
  If I1 > 0 then begin
  { Find owner }
    ObjectName := Copy(Name,1,I1 - 1); { Owner portion }

  { Look for owner in ActiveReport pages }
    Root := nil;
    If Assigned(ActiveReport) then begin
      With ActiveReport do begin
        For I2 := 0 to ChildCount - 1 do begin
          If Child[I2] is TRavePage then begin
            P1 := TRavePage(Child[I2]);
            If CompareText(P1.Name,ObjectName) = 0 then begin
              Root := P1;
              Break;
            end; { if }
          end; { if }
        end; { for }
      end; { with }
    end; { if }

  { Look for owner in ProjectItems (Reports/Global Pages/Data Views) }
    If not Assigned(Root) then begin
      For I2 := 0 to ChildCount - 1 do begin
        Item := TRaveProjectItem(Child[I2]);
        If CompareText(Item.Name,ObjectName) = 0 then begin
          Root := Item;
          Break;
        end; { if }
      end; { for }
    end; { if }

  { Second half is object's name on Root }
    If Assigned(Root) then begin
      ObjectName := Copy(Name,I1 + 1,Length(Name) - I1);
    end; { if }
  end else begin
    If Assigned(DefRoot) then begin
      Root := DefRoot;
    end else begin
      Root := TRaveProjectManager(Project);
    end; { else }
    ObjectName := Name;
  end; { else }

  If not Assigned(Root) then begin
    Result := nil;
  end else begin
    Result := TRaveComponent(Root.FindComponent(ObjectName));
    If not Assigned(Result) then begin
      Result := TRaveComponent(TRaveProjectManager(Project).FindComponent(ObjectName));
    end; { if }
  end; { else }
end;  { FindRaveComponent }

function TRaveProjectManager.GetUniqueName(BaseName: string;
                                           NameOwner: TRaveComponent;
                                           UseCurrent: boolean): string;

var
  I1: integer;
  OrigName: string;
  SepCh: char;

begin { GetUniqueName }
  If UseCurrent then begin { BaseName='OrigName|BaseName' }
  { Try to use OrigName first, then switch to BaseName }
    OrigName := CutWord(BaseName,SepCh,'|');
    Result := OrigName;
    If not Assigned(NameOwner.FindComponent(Result)) then Exit;
  end; { if }
  For I1 := 1 to 9999 do begin
    Result := BaseName + IntToStr(I1);
    If not Assigned(NameOwner.FindComponent(Result)) then Exit;
  end; { for }
end;  { GetUniqueName }

procedure TRaveProjectManager.DeactivateReport;

begin { DeactivateReport }
  If Assigned(FActiveReport) then begin
    ActiveReport.Close;
    FActiveReport := nil;
  {$IFDEF DESIGNER}
    CurrentDesigner := nil;
  {$ENDIF}
  end; { if }
end;  { DeactivateReport }

procedure TRaveProjectManager.ActivateReport(Report: TRaveReport);
begin { ActivateReport }
  DeactivateReport;
  FActiveReport := Report;
  ActiveReport.Open;
  LastActiveReport := ActiveReport.Name;
  If SaveEnvOnly then begin
    DataChanged := true;
  end; { if }
end;  { ActivateReport }

procedure TRaveProjectManager.ExportProject(ExportFileName: string;
                                            Items: TList);

var
  Stream: TStream;

begin { ExportProject }
  Stream := TFileStream.Create(ExportFileName,fmCreate);
  try
    ExportList := Items;
    SaveToStream(Stream);
    ExportList := nil;
  finally
    Stream.Free;
  end; { tryf }
end;  { ExportProject }

function TRaveProjectManager.ImportProject(ImportFileName: string;
                                           AutoReplace: boolean): boolean;

var
  Stream: TStream;

begin { ImportProject }
  Result := false;
  If FileExists(ImportFileName) then begin
    Stream := TFileStream.Create(ImportFileName,fmOpenRead);
    If Stream.Size > 0 then begin
      try
        Importing := true;
        ImportReplace := AutoReplace;
        LoadFromStream(Stream);
        Importing := false;
      finally
        Stream.Free;
      end; { tryf }
      DataChanged := true;
      Result := true;
    end; { if }
  end; { if }
end;  { ImportProject }

procedure TRaveProjectManager.Save;

var
  Stream: TStream;

begin { Save }
  Stream := TFileStream.Create(ChangeFileExt(FileName,{Trans-}'.$$$'),fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end; { tryf }

{ Rename file from FileName.$$$ to FileName.rav and save backup *.~ra }
  DeleteFile(ChangeFileExt(FileName,{Trans-}'.~ra'));
  RenameFile(FileName,ChangeFileExt(FileName,{Trans-}'.~ra'));
  RenameFile(ChangeFileExt(FileName,{Trans-}'.$$$'),FileName);
end;  { Save }

procedure TRaveProjectManager.Load;

var
  Stream: TStream;

begin { Load }
  IsLoading := true;
  try
    If FileExists(FileName) then begin
      Stream := TFileStream.Create(FileName,fmOpenRead);
      If Stream.Size > 0 then begin
        try
          LoadFromStream(Stream);
        finally
          Stream.Free;
        end; { tryf }
      end else begin
        Stream.Free;
        New;
      end; { else }
    end else begin
      New;
    end; { else }
  finally
    IsLoading := false;
  end; { tryf }
end;  { Load }

procedure TRaveProjectManager.New;

begin { New }
  try
    IsLoading := true;
    FileName := {Trans-}'Project1.rav';
    NewReport;
    ClearChanged;
    Saved := false;
  finally
    IsLoading := false;
  end; { tryf }
end;  { New }

procedure TRaveProjectManager.Unload;

begin { Unload }
  DeactivateReport;
  Clear;
end;  { Unload }

{ File methods }

function TRaveProjectManager.NewReport: TRaveReport;

begin { NewReport }
  Result := TRaveReport.Create(self);
  Result.Parent := self;
  Result.Name := GetUniqueName({Trans-}'Report', TRaveProjectManager(Project), false);
  AddComponent(Result);
  ReportList.Add(Result);
  ActivateReport(Result);
  Result.NewPage;
  Result.FirstPage := Result.Child[0] as TRavePage;
end;  { NewReport }

function TRaveProjectManager.NewGlobalPage: TRavePage;

begin { NewGlobalPage }
  Result := TRavePage.Create(self);
  Result.Parent := self;
  Result.Name := GetUniqueName({Trans-}'GlobalPage', TRaveProjectManager(Project), false);
  GlobalPageList.Add(Result);
  AddComponent(Result);
  ActiveReport.LoadPage(Result);
  DataChanged := true;
end;  { NewGlobalPage }

(*
function TRaveProjectManager.NewDataView: TRaveDataView;

begin { NewDataView }
  Result := TRaveDataView.Create(self);
  Result.Parent := self;
  Result.Name := TRaveProjectManager(Project).GetUniqueName({Trans-}'DataView'
   , TRaveProjectManager(Project), false);
  DataObjectList.Add(Result);
  AddComponent(Result);
end;  { NewDataView }
*)

function TRaveProjectManager.NewDataObject(DataObjectClass: TRaveDataObjectClass): TRaveDataObject;

var
  NewName: string;

begin { NewDataObject }
  Result := DataObjectClass.Create(self);
  Result.Parent := self;
  NewName := DataObjectClass.ClassName;
  If NewName[1] = 'T' then begin
    Delete(NewName,1,1);
  end; { if }
  If Pos({Trans-}'RAVE',UpperCase(NewName)) = 1 then begin
    Delete(NewName,1,4);
  end; { if }
  Result.Name := TRaveProjectManager(Project).GetUniqueName(NewName,Result.Owner as TRaveComponent,false);
  DataObjectList.Add(Result);
  AddComponent(Result);
end;  { NewDataObject }

procedure TRaveProjectManager.DeleteItem(Item: TRaveProjectItem;
                                         Notify: boolean);

var
  I1: integer;
  CheckReportPage: boolean;

begin { DeleteItem }
  CheckReportPage := false;
  If Item is TRaveReport then begin
    If ReportList.Count = 1 then begin
      NewReport;
    end else if ActiveReport = Item then begin
      I1 := ReportList.IndexOf(Item);
      If I1 = 0 then begin
        I1 := 1;
      end else begin
        Dec(I1);
      end; { else }
      ActivateReport(TRaveReport(ReportList[I1]));
    end; { else }
    ReportList.Remove(Item);
  end else if Item is TRavePage then begin
    ActiveReport.UnloadPage(TRavePage(Item));
    If TRavePage(Item).Global then begin
      GlobalPageList.Remove(Item);
    end else begin
      CheckReportPage := true;
    end; { else }
  end else if Item is TRaveDataObject then begin
    DataObjectList.Remove(Item);
  end; { else }
  DeleteComponent(Item);
  Item.Free;
  If CheckReportPage and (ActiveReport.ChildCount = 0) then begin
    ActiveReport.NewPage;
  end; { if }
end;  { DeleteItem }

procedure TRaveProjectManager.SetParam(Param: string; Value: string);
begin { SetParam }
  Params.Values[Param] := Value;
end;  { SetParam }

function TRaveProjectManager.GetParam(Param: string): string;
begin { GetParam }
  Result := Params.Values[Param];
end;  { GetParam }

procedure TRaveProjectManager.ClearParams;
begin { ClearParams }
  Params.Clear;
end;  { ClearParams }

procedure TRaveProjectManager.SetUnits(Value: TPrintUnits);

begin { SetUnits }
  FUnits := Value;
  Case FUnits of
    unInch: FUnitsFactor := 1.0;
    unMM: FUnitsFactor := 25.4;
    unCM: FUnitsFactor := 2.54;
    unPoint: FUnitsFactor := 72.0;
    unUser: begin
    { Don't change FUnitsFactor }
    end;
  end; { case }
{$IFDEF DESIGNER}
  If Assigned(CurrentDesigner) then begin
    CurrentDesigner.Modified;
  end; { if }
{$ENDIF}
end;  { SetUnits }

procedure TRaveProjectManager.SetUnitsFactor(Value: double);

begin { SetUnitsFactor }
  If Value > 0.0 then begin
    FUnitsFactor := Value;
    If FEQ(FUnitsFactor,1.0) then begin
      FUnits := unInch;
    end else if FEQ(FUnitsFactor,25.4) then begin
      FUnits := unMM;
    end else if FEQ(FUnitsFactor,2.54) then begin
      FUnits := unCM;
    end else if FEQ(FUnitsFactor,72.0) then begin
      FUnits := unPoint;
    end else begin
      FUnits := unUser;
    end; { else }
  end; { if }
{$IFDEF DESIGNER}
  If Assigned(CurrentDesigner) then begin
    CurrentDesigner.Modified;
  end; { if }
{$ENDIF}
end;  { SetUnitsFactor }

procedure TRaveProjectManager.SetDataChanged(Value: boolean);

var
  FileProps: integer;

begin { SetDataChanged }
{ DataChanged will only change value when set to true, to clear call ClearChanged }
  If Value then begin
    If not FDataChanged and not IsLoading and Saved then begin
      {$IFDEF Linux}
      //!!PORT!! - FileGetAttr
      {$ELSE}
      FileProps := FileGetAttr(FileName);
      {$ENDIF}
      If (FileProps >= 0) and ((FileProps and faReadOnly) = faReadOnly) then begin
        ShowMessage(Trans('The report project file you are modifying is marked read only.  ' +
         'You will be prompted for another file name when saving.'));
      end; { if }
    end; { if }
    FDataChanged := true;
  end; { if }
end;  { SetDataChanged }

procedure TRaveProjectManager.ClearChanged;

begin { ClearChanged }
  FDataChanged := false;
end;  { ClearChanged }

procedure TRaveProjectManager.Compile;

var
  I1: integer;
  I2: integer;

begin { Compile }
  DefineCompiles := true;
  For I2 := 1 to 2 do begin
    inherited Compile;
    For I1 := 0 to TRaveProjectManager(Project).DataObjectList.Count - 1 do begin
      TRaveDataObject(TRaveProjectManager(Project).DataObjectList[I1]).Compile;
    end; { for }
    For I1 := 0 to TRaveProjectManager(Project).GlobalPageList.Count - 1 do begin
      TRavePage(TRaveProjectManager(Project).GlobalPageList[I1]).Compile;
    end; { for }
    For I1 := 0 to TRaveProjectManager(Project).ReportList.Count - 1 do begin
      TRaveReport(TRaveProjectManager(Project).ReportList[I1]).Compile;
    end; { for }
    DefineCompiles := false;
  end; { for }
end;  { Compile }

function TRaveProjectManager.FindReport(const AName: string;
 const AIsFullName: boolean): TRaveReport;
var
  i: integer;
  LReport: TRaveReport;
begin
  Result := nil;
  for i := 0 to ReportList.Count - 1 do begin
    LReport := TRaveReport(ReportList.Items[i]);
    if (AIsFullName and (CompareText(LReport.FullName, AName) = 0))
     or (CompareText(LReport.Name, AName) = 0) then begin
      Result := LReport;
      Break;
    end;
  end;
end;

procedure TRaveProjectManager.FreeForwardRefs;
var
  I1: integer;
  Index: integer;
  Target: TRaveComponent;
begin { FreeForwardRefs }
  If Assigned(ForwardRefList) then begin
    For I1 := 0 to ForwardRefList.Count - 1 do begin
      With TRaveForwardRef(ForwardRefList.Objects[I1]) do begin
      { Figure out Target component }
        If Assigned(RenameRefList) and
         RenameRefList.Find(ForwardRefList[I1],Index) then begin
        { Target was renamed }
          Target := TRaveComponent(RenameRefList.Objects[Index]);
        end else begin
        { Target was not renamed }
          Target := FindRaveComponent(ForwardRefList[I1],
           TRaveComponent(TRaveForwardRef(ForwardRefList.Objects[I1]).
           Instance).Parent);
          If not Assigned(Target) then begin
            Continue; {!!! Unresolved forward reference }
          end; { if }
        end; { else }

      { Assign Target to forward reference }
        If not Assigned(PropInfo) then begin
          TRaveComponentList(Instance).Items[Param] := Target;
        end else begin
          SetOrdProp(Instance,PropInfo,integer(Target));
        end; { else }
      end; { with }
    end; { for }
    ClearStringList(ForwardRefList);
    ForwardRefList.Free;
    ForwardRefList := nil;
    RenameRefList.Free;
    RenameRefList := nil;
  end; { if }
end;

initialization
  RegisterProc('RVCL', RaveRegister);
end.

{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPRave;

interface

uses
  {$IFDEF Linux}
  QStdCtrls, QDialogs, QForms, QControls,
  {$ELSE}
  Windows, StdCtrls, Dialogs, Forms, Controls,
  {$ENDIF}
  Classes, SysUtils, RPDefine,
  RVDefine, RVClass, RVProj, RVUtil, RVCmHuff, RVData,
  {$IFNDEF Server}RVDirectDataView,{$ENDIF}
  RVCsStd, RVCsRpt, RVCsDraw, RVCsData, RVDatabase, RVSQLDataView, RVLEMod, RVLESys;

type
  TRaveProject = class(TRPComponent)
  protected
    FActive: boolean;
    FProjectFile: string;
    FEngine: TRPComponent;
    FDLLFile: string;
    FLoadDesigner: boolean;
    FStoreRAV: boolean;
    RaveBlob: TMemoryStream;
    FRaveBlobDateTime: TDateTime;
    FProjMan: TRaveProjectManager;
    ProjOwner: TRaveContainerControl;

    FOnCreate: TNotifyEvent;
    FOnDestroy: TNotifyEvent;
    FOnDesignerSave: TNotifyEvent;
    FOnDesignerSaveAs: TNotifyEvent;
    FOnDesignerNew: TNotifyEvent;
    FOnDesignerOpen: TNotifyEvent;
    FOnDesignerShow: TNotifyEvent;
    FOnBeforeOpen: TNotifyEvent;
    FOnAfterOpen: TNotifyEvent;
    FOnBeforeClose: TNotifyEvent;
    FOnAfterClose: TNotifyEvent;

    procedure CreateEvent; virtual;
    procedure DestroyEvent; virtual;
    procedure DesignerShowEvent; virtual;
    procedure BeforeOpenEvent; virtual;
    procedure AfterOpenEvent; virtual;
    procedure BeforeCloseEvent; virtual;
    procedure AfterCloseEvent; virtual;

    procedure Loaded; override;
    function GetReportDesc: string;
    function GetReportName: string;
    function GetReportFullName: string;
    procedure SetActive(Value: boolean);
    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
    procedure SetEngine(Value: TRPComponent);
    procedure ReadRaveBlob(Reader: TReader);
    procedure WriteRaveBlob(Writer: TWriter);
    procedure DefineProperties(Filer: TFiler); override;
    function GetProjMan: TRaveProjectManager;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure New;
    class procedure RegisterRaveUnits;
    procedure Open;
    procedure Close;
    procedure Save;
    procedure Execute;
    procedure ExecuteReport(ReportName: string);
    function Design: boolean;
    function DesignReport(ReportName: string): boolean;
    procedure GetReportList(ReportList: TStrings;
                            FullNames: boolean);
    procedure GetReportCategoryList(ReportList: TStrings;
                                    Categories: string;
                                    FullNames: boolean);
    function SelectReport(ReportName: string;
                          FullName: boolean): boolean;
    procedure ReportDescToMemo(Memo: TCustomMemo);
    procedure SetParam(Param: string;
                       Value: string);
    function GetParam(Param: string): string;
    procedure ClearParams;
    procedure LoadFromFile(FileName: string);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(FileName: string);
    procedure SaveToStream(Stream: TStream);
    procedure LoadRaveBlob(Stream: TStream);
    procedure SaveRaveBlob(Stream: TStream);
    procedure ClearRaveBlob;
    procedure SetProjectFile(Value: string);

    property Active: boolean read FActive write SetActive;
    property ProjMan: TRaveProjectManager read GetProjMan;
    property RaveBlobDateTime: TDateTime read FRaveBlobDateTime;
    property ReportDesc: string read GetReportDesc;
    property ReportName: string read GetReportName;
    property ReportFullName: string read GetReportFullName;
  published
    property DLLFile: string read FDLLFile write FDLLFile;
    property Engine: TRPComponent read FEngine write SetEngine default nil;
    property LoadDesigner: boolean read FLoadDesigner write FLoadDesigner default false;
    property ProjectFile: string read FProjectFile write SetProjectFile;
    property StoreRAV: boolean read FStoreRAV write FStoreRAV stored false;

    property OnCreate: TNotifyEvent read FOnCreate write FOnCreate;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
    property OnDesignerSave: TNotifyEvent read FOnDesignerSave write FOnDesignerSave;
    property OnDesignerSaveAs: TNotifyEvent read FOnDesignerSaveAs write FOnDesignerSaveAs;
    property OnDesignerShow: TNotifyEvent read FOnDesignerShow write FOnDesignerShow;
    property OnBeforeOpen: TNotifyEvent read FOnBeforeOpen write FOnBeforeOpen;
    property OnAfterOpen: TNotifyEvent read FOnAfterOpen write FOnAfterOpen;
    property OnBeforeClose: TNotifyEvent read FOnBeforeClose write FOnBeforeClose;
    property OnAfterClose: TNotifyEvent read FOnAfterClose write FOnAfterClose;
  end; { TRaveProject }

  TRaveCreateProc = procedure(RVInfo: pointer;
                              AppHandle: THandle); stdcall;
  TRaveProc = procedure;
  TRaveDesignerCreateProc = procedure(Data: pointer;
                                      SaveCallback: TRaveSaveCallbackProc;
                                      SaveAsCallback: TRaveSaveCallbackProc); stdcall;
  TRaveDesignerLoadProc = procedure(Buf: pointer;
                                    Size: longint); stdcall;
  TRaveDesignerSaveProc = function(var Buf: pointer;
                                   var Size: longint): boolean; stdcall;

var
  RaveCreate: TRaveCreateProc;
  DesignerCreate: TRaveDesignerCreateProc;
  DesignerLoad: TRaveDesignerLoadProc;
  DesignerShow: TRaveProc;
  DesignerSave: TRaveDesignerSaveProc;
  DesignerFree: TRaveProc;
  RaveFree: TRaveProc;

  function LoadRaveDLL(DLLName: string): THandle;
  procedure CloseRaveDLL;

implementation

{$IFDEF Linux}
//!!PORT!!
{$ELSE}
{$L rvinfo.dat}

// Procs
  procedure RVInfo; external;
{$ENDIF}

type
  TRaveMemoryStream = class(TCustomMemoryStream)
  public
    procedure SetBuf(Buf: pointer;
                     Size: longint);
    function Write(const Buffer;
                         Count: longint): longint; override;
  end; { TRaveMemoryStream }

var
  RaveModule: THandle = 0;

procedure RaveSaveCallback(Buf: pointer;
                           Size: longint;
                           Data: pointer); stdcall;

var
  Stream: TRaveMemoryStream;

begin { RaveSaveCallback }
  With TObject(Data) as TRaveProject do begin
    Stream := TRaveMemoryStream.Create;
    try
      Stream.SetBuf(Buf,Size);
      LoadFromStream(Stream);
    finally
      Stream.Free;
    end; { tryf }
    If Assigned(FOnDesignerSave) then begin
      FOnDesignerSave(TObject(Data));
    end; { if }
  end; { with }
end;  { RaveSaveCallback }

procedure RaveSaveAsCallback(Buf: pointer;
                             Size: longint;
                             Data: pointer); stdcall;

var
  Stream: TRaveMemoryStream;

begin { RaveSaveAsCallback }
  With TObject(Data) as TRaveProject do begin
    Stream := TRaveMemoryStream.Create;
    try
      Stream.SetBuf(Buf,Size);
      LoadFromStream(Stream);
    finally
      Stream.Free;
    end; { tryf }
    If Assigned(FOnDesignerSaveAs) then begin
      FOnDesignerSaveAs(TObject(Data));
    end; { if }
  end; { with }
end;  { RaveSaveAsCallback }

function LoadRaveDLL(DLLName: string): THandle;

var
  S1: string;

begin { LoadRaveDLL }
  If RaveModule = 0 then begin
    If DLLName = '' then begin
      S1 := 'RAVE.DLL';
    end else begin
      S1 := DLLName;
    end; { else }
    RaveModule := LoadLibrary(@S1[1]);
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    If RaveModule < HINSTANCE_ERROR then begin
      RaveModule := 0;
      RaiseError(Trans('Error loading') + ' ' + S1);
    end else begin
      @RaveCreate := GetProcAddress(RaveModule,'RaveCreate');
      @DesignerCreate := GetProcAddress(RaveModule,'DesignerCreate');
      @DesignerLoad := GetProcAddress(RaveModule,'DesignerLoad');
      @DesignerShow := GetProcAddress(RaveModule,'DesignerShow');
      @DesignerSave := GetProcAddress(RaveModule,'DesignerSave');
      @DesignerFree := GetProcAddress(RaveModule,'DesignerFree');
      @RaveFree := GetProcAddress(RaveModule,'RaveFree');
      RaveCreate(pointer(@RVInfo),Application.Handle); { Create Rave System }
    end; { else }
    {$ENDIF}
  end; { if }
  Result := RaveModule;
end;  { LoadRaveDLL }

procedure CloseRaveDLL;

begin { CloseRaveDLL }
  If RaveModule <> 0 then begin
    RaveFree; { Free Rave System }
    try
      FreeLibrary(RaveModule);
    finally
      RaveModule := 0;
    end; { tryf }
  end; { if }
end;  { CloseRaveDLL }

(*****************************************************************************}
( class TRaveMemoryStream
(*****************************************************************************)

procedure TRaveMemoryStream.SetBuf(Buf: pointer;
                                   Size: longint);

begin { SetBuf }
  SetPointer(Buf,Size);
  Position := 0;
end;  { SetBuf }

function TRaveMemoryStream.Write(const Buffer;
                                       Count: longint): longint;

begin { Write }
  Result := 0;
end;  { Write }

(*****************************************************************************}
( class TRaveProject
(*****************************************************************************)

constructor TRaveProject.Create(AOwner: TComponent);

begin { Create }
  inherited Create(AOwner);
  ProjOwner := TRaveContainerControl.Create(nil);
  FProjMan := TRaveProjectManager.Create(ProjOwner);
  FProjMan.Name := 'RaveProject';
  If not (csDesigning in ComponentState) and not RaveInitialized then begin
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    If not Assigned(RaveDataSystem) then begin
      RaveDataSystem := TRaveDataSystem.Create;
    end; { if }
    {$ENDIF}
    RegisterRaveUnits;
    RaveInitialized := true;
  end; { if }
end;  { Create }

destructor TRaveProject.Destroy;
begin { Destroy }
  Close;
  DestroyEvent;
  ClearRaveBlob;
  FProjMan.Free;
  ProjOwner.Free;
  inherited Destroy;
end;  { Destroy }

procedure TRaveProject.Loaded;

begin { Loaded }
  CreateEvent;
end;  { Loaded }

procedure TRaveProject.CreateEvent;

begin { CreateEvent }
  If Assigned(FOnCreate) then begin
    FOnCreate(self);
  end; { if }
end;  { CreateEvent }

procedure TRaveProject.DestroyEvent;

begin { DestroyEvent }
  If Assigned(FOnDestroy) then begin
    FOnDestroy(self);
  end; { if }
end;  { DestroyEvent }

procedure TRaveProject.DesignerShowEvent;

begin { DesignerShowEvent }
  If Assigned(FOnDesignerShow) then begin
    FOnDesignerShow(self);
  end; { if }
end;  { DesignerShowEvent }

procedure TRaveProject.BeforeOpenEvent;

begin { BeforeOpenEvent }
  If Assigned(FOnBeforeOpen) then begin
    FOnBeforeOpen(self);
  end; { if }
end;  { BeforeOpenEvent }

procedure TRaveProject.AfterOpenEvent;

begin { AfterOpenEvent }
  If Assigned(FOnAfterOpen) then begin
    FOnAfterOpen(self);
  end; { if }
end;  { AfterOpenEvent }

procedure TRaveProject.BeforeCloseEvent;

begin { BeforeCloseEvent }
  If Assigned(FOnBeforeClose) then begin
    FOnBeforeClose(self);
  end; { if }
end;  { BeforeCloseEvent }

procedure TRaveProject.AfterCloseEvent;

begin { AfterCloseEvent }
  If Assigned(FOnAfterClose) then begin
    FOnAfterClose(self);
  end; { if }
end;  { AfterCloseEvent }

procedure TRaveProject.Notification(AComponent: TComponent;
                                    Operation: TOperation);

begin { Notification }
  inherited Notification(AComponent,Operation);
  If (Operation = opRemove) and (AComponent = FEngine) then begin
    FEngine := nil;
  end; { if }
end;  { Notification }

procedure TRaveProject.SetEngine(Value: TRPComponent);

begin { SetEngine }
  FEngine := Value;
  If Assigned(Value) then begin
    Value.FreeNotification(self);
  end; { if }
end;  { SetEngine }

procedure TRaveProject.ReadRaveBlob(Reader: TReader);

var
  BlobSize: integer;

begin { ReadRaveBlob }
  If not Assigned(RaveBlob) then begin
    RaveBlob := TMemoryStream.Create;
  end; { if }
  BlobSize := Reader.ReadInteger;
  FRaveBlobDateTime := Reader.ReadFloat;
  RaveBlob.SetSize(BlobSize);
  Reader.Read(RaveBlob.Memory^,BlobSize);
end;  { ReadRaveBlob }

procedure TRaveProject.WriteRaveBlob(Writer: TWriter);

begin { WriteRaveBlob }
  Writer.WriteInteger(RaveBlob.Size);
  Writer.WriteFloat(FRaveBlobDateTime);
  Writer.Write(RaveBlob.Memory^,RaveBlob.Size);
end;  { WriteRaveBlob }

procedure TRaveProject.DefineProperties(Filer: TFiler);

begin { DefineProperties }
  inherited DefineProperties(Filer);
  Filer.DefineProperty('RaveBlob',ReadRaveBlob,WriteRaveBlob,Assigned(RaveBlob)); //!!! Convert to DefineBinaryProperty
end;  { DefineProperties }

procedure TRaveProject.LoadRaveBlob(Stream: TStream);

begin { LoadRaveBlob }
  If not Assigned(RaveBlob) then begin
    RaveBlob := TMemoryStream.Create;
  end; { if }
  RaveBlob.Clear;
  RaveBlob.CopyFrom(Stream,0);
  FRaveBlobDateTime := Now;
end;  { LoadRaveBlob }

procedure TRaveProject.SaveRaveBlob(Stream: TStream);

begin { SaveRaveBlob }
  If Assigned(RaveBlob) then begin
    Stream.CopyFrom(RaveBlob,0);
  end; { if }
end;  { SaveRaveBlob }

procedure TRaveProject.ClearRaveBlob;

begin { CreateRaveBlob }
  If Assigned(RaveBlob) then begin
    RaveBlob.Free;
    RaveBlob := nil;
    FRaveBlobDateTime := 0.0;
  end; { if }
end;  { CreateRaveBlob }

procedure TRaveProject.SetProjectFile(Value: string);

begin { SetProjectFile }
  If Pos('.',Value) = 0 { no file type specified } then begin
    FProjectFile := Value + '.rav';
  end else begin
    FProjectFile := Value;
  end; { else }
end;  { SetProjectFile }

procedure TRaveProject.SetActive(Value: boolean);

begin { SetActive }
  If Value = Active then Exit;
  GetProjMan;
  If Value then begin
    Open;
  end else begin
    Close;
  end; { else }
end;  { SetActive }

function TRaveProject.GetProjMan: TRaveProjectManager;
begin { GetProjMan }
  Result := FProjMan;
end;  { GetProjMan }

procedure TRaveProject.New;

begin { New }
  GetProjMan;
  If Active then begin
    ProjMan.Unload;
  end else begin
    BeforeOpenEvent;
  end; { else }
  ProjMan.New;
  If not Active then begin
    FActive := true;
    AfterOpenEvent;
  end; { if }
end;  { New }

procedure TRaveProject.Open;

var
  FileDate: TDateTime;
  LoadFile: boolean;
  DiskDate: integer;

begin { Open }
  If Active then Exit;
  BeforeOpenEvent;
  GetProjMan;

  DiskDate := FileAge(ProjectFile);
  If DiskDate >= 0 then begin
    FileDate := FileDateToDateTime(DiskDate);
  end else begin
    FileDate := 0;
  end; { else }
  LoadFile := not Assigned(RaveBlob);
  If not LoadFile and (FileDate > RaveBlobDateTime) then begin
    LoadFile := MessageDlg(
     'The report project stored in the executable is older than the disk file'#13 +
     '"' + ExpandFileName(ProjectFile) + '"'#13 + 'Do you want to use the file on disk?',
     mtWarning,[mbYes,mbNo],0) = mrYes;
  end; { if }
  If not LoadFile then begin
    RaveBlob.Position := 0;
    ProjMan.LoadFromStream(RaveBlob);
  end else if (ProjectFile <> '') and FileExists(ExpandFileName(ProjectFile)) then begin
    ProjMan.FileName := ExpandFileName(ProjectFile);
    ProjMan.Load;
  end else begin
    RaveError('The following reporting project does not exist:'#13 +
     '"' + ExpandFileName(ProjectFile) + '"');
  end; { else }
  FActive := true;
  AfterOpenEvent;
end;  { Open }

procedure TRaveProject.Close;

begin { Close }
  If not Active then Exit;
  BeforeCloseEvent;
  GetProjMan;
  ProjMan.Unload;
  FActive := false;
  AfterCloseEvent;
end;  { Close }

procedure TRaveProject.Save;

begin { Save }
  If not Active then Exit;
  GetProjMan;
  ProjMan.FileName := ProjectFile;
  ProjMan.Save;
end;  { Save }

procedure TRaveProject.Execute;
begin { Execute }
  Open;
  ProjMan.ActiveReport.Show;
  ProjMan.ActiveReport.Execute(Engine);
  ProjMan.ActiveReport.Hide;
end;  { Execute }

procedure TRaveProject.ExecuteReport(ReportName: string);

begin { ExecuteReport }
  Open;
  If SelectReport(ReportName,false) then begin
    ProjMan.ActiveReport.Show;
    ProjMan.ActiveReport.Execute(Engine);
    ProjMan.ActiveReport.Hide;
  end; { if }
end;  { ExecuteReport }

function TRaveProject.Design: boolean;

var
  StreamOut: TMemoryStream;
  StreamIn: TRaveMemoryStream;
  Buf: pointer;
  Size: longint;
  SaveProc: TRaveDesignerSaveProc;
  SaveAsProc: TRaveDesignerSaveProc;

begin { Design }
  LoadRaveDLL(DLLFile);
  try
    Open;
    If RaveModule = 0 then begin
      ShowMessage(Trans('The Rave System is not currently loaded'));
      Result := false;
      Exit;
    end; { if }

  { Create visual designer }
    If Assigned(FOnDesignerSave) then begin
      SaveProc := @RaveSaveCallback;
    end else begin
      SaveProc := nil;
    end; { else }
    If Assigned(FOnDesignerSaveAs) then begin
      SaveAsProc := @RaveSaveAsCallback;
    end else begin
      SaveAsProc := nil;
    end; { else }
    If Assigned(SaveProc) or Assigned(SaveAsProc) then begin
      DesignerCreate(self,@SaveProc,@SaveAsProc);
    end else begin
      DesignerCreate(nil,nil,nil);
    end; { else }

  { Stream project out to visual designer }
    StreamOut := TMemoryStream.Create;
    try
      ProjMan.StreamParamValues := true;
      ProjMan.SaveToStream(StreamOut);
      ProjMan.StreamParamValues := false;
      DesignerLoad(StreamOut.Memory,StreamOut.Size);
    finally
      StreamOut.Free;
    end; { tryf }

  { Show visual designer }
    DesignerShowEvent;
    DesignerShow;

  { Check if project was modified }
    Result := DesignerSave(Buf,Size);
    If Result then begin
    { Stream project into ProjMan }
      ProjMan.Unload;
      StreamIn := TRaveMemoryStream.Create;
      try
        StreamIn.SetBuf(Buf,Size);
        ProjMan.LoadFromStream(StreamIn);
      finally
        StreamIn.Free;
      end; { tryf }
    end; { if }

  { Free visual designer }
    DesignerFree;
  finally
    CloseRaveDLL;
  end;
end;  { Design }

function TRaveProject.DesignReport(ReportName: string): boolean;

begin { DesignReport }
  SelectReport(ReportName,false);
  Result := Design;
end;  { DesignReport }

procedure TRaveProject.LoadFromFile(FileName: string);

var
  Stream: TMemoryStream;

begin { LoadFromFile }
  Stream := TMemoryStream.Create;
  try
    Stream.LoadFromFile(FileName);
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end; { tryf }
end;  { LoadFromFile }

procedure TRaveProject.LoadFromStream(Stream: TStream);

begin { LoadFromStream }
  ProjMan.Unload;
  ProjMan.LoadFromStream(Stream);
end;  { LoadFromStream }

procedure TRaveProject.SaveToFile(FileName: string);

var
  Stream: TMemoryStream;

begin { SaveToFile }
  Stream := TMemoryStream.Create;
  try
    SaveToStream(Stream);
    Stream.SaveToFile(FileName);
  finally
    Stream.Free;
  end; { tryf }
end;  { SaveToFile }

procedure TRaveProject.SaveToStream(Stream: TStream);

begin { SaveToStream }
  ProjMan.SaveToStream(Stream);
end;  { SaveToStream }

procedure TRaveProject.GetReportList(ReportList: TStrings;
                                     FullNames: boolean);

var
  I1: integer;
  Report: TRaveReport;

begin { GetReportList }
  ReportList.Clear;
  With ProjMan.ReportList do begin
    For I1 := 0 to Count - 1 do begin
      Report := TRaveReport(Items[I1]);
      If FullNames then begin
        ReportList.AddObject(Report.FullName,Report);
      end else begin
        ReportList.AddObject(Report.Name,Report);
      end; { else }
    end; { for }
  end; { with }
end;  { GetReportList }

procedure TRaveProject.GetReportCategoryList(ReportList: TStrings;
                                             Categories: string;
                                             FullNames: boolean);

var
  I1: integer;
  ValidCats: string;
  Report: TRaveReport;

begin { GetReportCategoryList }
  ValidCats := UpperCase(';' + Categories + ';');
  ReportList.Clear;
  With ProjMan.ReportList do begin
    For I1 := 0 to Count - 1 do begin
      Report := TRaveReport(Items[I1]);
      If Pos(UpperCase(Report.Category),ValidCats) > 0 then begin
        If FullNames then begin
          ReportList.AddObject(Report.FullName,Report);
        end else begin
          ReportList.AddObject(Report.Name,Report);
        end; { else }
      end; { if }
    end; { for }
  end; { with }
end;  { GetReportCategoryList }

function TRaveProject.SelectReport(ReportName: string; FullName: boolean): boolean;
var
  LReport: TRaveReport;
begin
  Open;
  LReport := ProjMan.FindReport(ReportName, FullName);
  result := LReport <> nil;
  if result then begin
    ProjMan.ActivateReport(LReport);
  end;
end;

procedure TRaveProject.ReportDescToMemo(Memo: TCustomMemo);

begin { ReportDescToMemo }
  Memo.Text := ProjMan.ActiveReport.Description;
end;  { ReportDescToMemo }

function TRaveProject.GetReportDesc: string;

begin { GetReportDesc }
  Result := ProjMan.ActiveReport.Description;
end;  { GetReportDesc }

function TRaveProject.GetReportName: string;

begin { GetReportName }
  Result := ProjMan.ActiveReport.Name;
end;  { GetReportName }

function TRaveProject.GetReportFullName: string;

begin { GetReportFullName }
  Result := ProjMan.ActiveReport.FullName;
end;  { GetReportFullName }

procedure TRaveProject.SetParam(Param: string;
                                Value: string);

begin { SetParam }
  ProjMan.SetParam(Param,Value);
end;  { SetParam }

function TRaveProject.GetParam(Param: string): string;

begin { GetParam }
  Result := ProjMan.GetParam(Param);
end;  { GetParam }

procedure TRaveProject.ClearParams;

begin { ClearParams }
  ProjMan.ClearParams;
end;  { ClearParams }

class procedure TRaveProject.RegisterRaveUnits;
begin
  CallRegisters('*');
end;

end.

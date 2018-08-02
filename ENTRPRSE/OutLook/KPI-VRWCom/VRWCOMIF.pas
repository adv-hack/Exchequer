unit VRWCOMIF;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, SysUtils, ComObj, ActiveX, VRWCOM_TLB, StdVcl, VRWReportIF, VRWReportDataIF;

type
  TReport = class(TAutoIntfObject, IReport)
  private
    VRWReport: IVRWReport;
  protected
    function Get_Datapath: WideString; safecall;
    procedure Set_Datapath(const Value: WideString); safecall;
    procedure Print; safecall;
    procedure Read(const Filename: WideString); safecall;
    function Init: Integer; safecall;
  end;

  TReportData = class(TAutoIntfObject, IReportData)
  protected
    function Get_Datapath: WideString; safecall;
    procedure Set_Datapath(const Value: WideString); safecall;
    function Get_UserID: WideString; safecall;
    procedure Set_UserID(const Value: WideString); safecall;
    function Get_Index: Integer; safecall;
    procedure Set_Index(Value: Integer); safecall;
    function FindByName(const ReportName: WideString): LongInt; safecall;
  end;

  TReportTree = class(TAutoObject, IReportTree)
  private
    ReportI: IReport;
    ReportO: TReport;
    ReportDataI: IReportData;
    ReportDataO: TReportData;
    FDataPath: WideString;
  protected
    function Get_Datapath: WideString; safecall;
    procedure Set_Datapath(const Value: WideString); safecall;
    function Get_UserID: WideString; safecall;
    procedure Set_UserID(const Value: WideString); safecall;
    function GetFirstReport(var NodeType, NodeName, NodeDesc, NodeParent,
      NodeChild, Filename, LastRun: WideString;
      var AllowEdit: WordBool): Integer; safecall;
    function GetGEqual(const ParentID: WideString; var NodeType, NodeName,
      NodeDesc, NodeParent, NodeChild, Filename, LastRun: WideString;
      var AllowEdit: WordBool): Integer; safecall;
    function GetNext(var NodeType, NodeName, NodeDesc, NodeParent, NodeChild,
      Filename, LastRun: WideString; var AllowEdit: WordBool): Integer;
      safecall;
    function RestorePosition(iPos: Integer): Integer; safecall;
    function SavePosition(var iPos: Integer): Integer; safecall;
    function Get_Report: IReport; safecall;
    function Get_ReportData: IReportData; safecall;
    procedure NoPrintPreview; safecall;
    procedure Print; safecall;
  public
    destructor Destroy; override;
    procedure Initialize; override;
  end;

implementation

uses Forms, Dialogs, ComServ, RepTreeIF, MainFormU, ReportProgress;

function GetReportTree : IReportTree_Interface; external 'REPENGINE.DLL';
function GetVRWReportData: IVRWReportData; external 'REPENGINE.DLL';
function GetVRWReport: IVRWReport; external 'REPENGINE.DLL'
procedure InitPreview(App: TApplication; Scr: TScreen); external 'REPENGINE.DLL';

var
  oReportTree: IReportTree_Interface;
  oReportData: IVRWReportData;

function ReportTree: IReportTree_Interface;
begin
  if (oReportTree = nil) then
  begin
    oReportTree := GetReportTree;
  end;
  Result := oReportTree;
end;

function ReportData: IVRWReportData;
begin
  if (oReportData = nil) then
  begin
    oReportData := GetVRWReportData;
  end;
  Result := oReportData;
end;

destructor TReportTree.Destroy;
begin
  ReportI := nil;
  ReportO := nil;
  ReportDataI := nil;
  ReportDataO := nil;
  inherited;
end;

function TReportTree.Get_Datapath: WideString;
begin
  Result := FDataPath;
end;

procedure TReportTree.Set_Datapath(const Value: WideString);
begin
  FDataPath := Value;
  ReportTree.CompanyDataSetPath := Value;
  ReportO.Init;
  ReportO.Set_Datapath(FDataPath);
end;

function TReportTree.Get_UserID: WideString;
begin
  Result := ReportTree.ReportTreeSecurity;
end;

procedure TReportTree.Set_UserID(const Value: WideString);
begin
  ReportTree.ReportTreeSecurity := Value;
end;

function TReportTree.GetFirstReport(var NodeType, NodeName, NodeDesc,
  NodeParent, NodeChild, Filename, LastRun: WideString;
  var AllowEdit: WordBool): Integer;
var
  sNodeType: ShortString;
  sNodeName: ShortString;
  sNodeDesc: ShortString;
  sNodeParent: ShortString;
  sNodeChild: ShortString;
  sFilename: ShortString;
  sLastRun: ShortString;
  bAllowEdit: Boolean;
begin
  sNodeType := NodeType;
  sNodeName := NodeName;
  sNodeDesc := NodeDesc;
  sNodeParent := NodeParent;
  sNodeChild := NodeChild;
  sFilename := Filename;
  sLastRun := LastRun;
  bAllowEdit := AllowEdit;

  Result := ReportTree.GetFirstReport(sNodeType, sNodeName, sNodeDesc, sNodeParent,
                                      sNodeChild, sFilename, sLastRun, bAllowEdit);

  AllowEdit := bAllowEdit;
  LastRun := sLastRun;
  Filename := sFilename;
  NodeChild := sNodeChild;
  NodeParent := sNodeParent;
  NodeDesc := sNodeDesc;
  NodeName := sNodeName;
  NodeType := sNodeType;
end;

function TReportTree.GetGEqual(const ParentID: WideString;
  var NodeType, NodeName, NodeDesc, NodeParent, NodeChild, Filename,
  LastRun: WideString; var AllowEdit: WordBool): Integer;
var
  sParentID: ShortString;
  sNodeType: ShortString;
  sNodeName: ShortString;
  sNodeDesc: ShortString;
  sNodeParent: ShortString;
  sNodeChild: ShortString;
  sFilename: ShortString;
  sLastRun: ShortString;
  bAllowEdit: Boolean;
begin
  sParentID := ParentID;
  sNodeType := NodeType;
  sNodeName := NodeName;
  sNodeDesc := NodeDesc;
  sNodeParent := NodeParent;
  sNodeChild := NodeChild;
  sFilename := Filename;
  sLastRun := LastRun;
  bAllowEdit := AllowEdit;

  Result := ReportTree.GetGEqual(sParentID, sNodeType, sNodeName, sNodeDesc,
                                 sNodeParent, sNodeChild, sFilename, sLastRun,
                                 bAllowEdit);

  AllowEdit := bAllowEdit;
  LastRun := sLastRun;
  Filename := sFilename;
  NodeChild := sNodeChild;
  NodeParent := sNodeParent;
  NodeDesc := sNodeDesc;
  NodeName := sNodeName;
  NodeType := sNodeType;
end;

function TReportTree.GetNext(var NodeType, NodeName, NodeDesc,
  NodeParent, NodeChild, Filename, LastRun: WideString;
  var AllowEdit: WordBool): Integer;
var
  sNodeType: ShortString;
  sNodeName: ShortString;
  sNodeDesc: ShortString;
  sNodeParent: ShortString;
  sNodeChild: ShortString;
  sFilename: ShortString;
  sLastRun: ShortString;
  bAllowEdit: Boolean;
begin
  sNodeType := NodeType;
  sNodeName := NodeName;
  sNodeDesc := NodeDesc;
  sNodeParent := NodeParent;
  sNodeChild := NodeChild;
  sFilename := Filename;
  sLastRun := LastRun;
  bAllowEdit := AllowEdit;

  Result := ReportTree.GetNext(sNodeType, sNodeName, sNodeDesc, sNodeParent,
                               sNodeChild, sFilename, sLastRun, bAllowEdit);

  AllowEdit := bAllowEdit;
  LastRun := sLastRun;
  Filename := sFilename;
  NodeChild := sNodeChild;
  NodeParent := sNodeParent;
  NodeDesc := sNodeDesc;
  NodeName := sNodeName;
  NodeType := sNodeType;
end;

function TReportTree.RestorePosition(iPos: Integer): Integer;
begin
  Result := ReportTree.RestorePosition(iPos);
end;

function TReportTree.SavePosition(var iPos: Integer): Integer;
begin
  Result := ReportTree.SavePosition(iPos);
end;

procedure TReportTree.Initialize;
begin
  inherited;
  ReportO := TReport.Create(ComServer.TypeLib, IID_IREPORT);
  ReportI := ReportO;
  ReportDataO := TReportData.Create(ComServer.TypeLib, IID_IREPORTDATA);
  ReportDataI := ReportDataO;
end;

function TReportTree.Get_Report: IReport;
begin
  Result := ReportI;
end;

function TReportTree.Get_ReportData: IReportData;
begin
  Result := ReportDataI;
end;

procedure TReportTree.NoPrintPreview;
begin
  (Application.MainForm as TMainForm).ReportTree := nil;
end;

procedure TReportTree.Print;
begin
  (Application.MainForm as TMainForm).ReportTree := self;
  ReportO.Print;
end;

{ TReport }

function TReport.Get_Datapath: WideString;
begin

end;

procedure TReport.Print;
begin
  frmReportProgress := TfrmReportProgress.Create(nil);
  try
    VRWReport.vrOnPrintRecord := frmReportProgress.OnReportProgress;
    InitPreview(Application, Screen);
    VRWReport.Print('', False);
  finally
    FreeAndNil(frmReportProgress);
  end;
end;

procedure TReport.Set_Datapath(const Value: WideString);
begin
  VRWReport.vrDataPath := Value;
end;

procedure TReport.Read(const Filename: WideString);
begin
  VRWReport.Read(Filename);
end;

function TReport.Init: Integer;
begin
  VRWReport := GetVRWReport;
  Result := 0;
end;

{ TReportData }

function TReportData.FindByName(const ReportName: WideString): LongInt;
begin
  Result := ReportData.FindByName(ReportName);
end;

function TReportData.Get_Datapath: WideString;
begin
  Result := ReportData.Datapath;
end;

function TReportData.Get_Index: Integer;
begin
  Result := ReportData.Index;
end;

function TReportData.Get_UserID: WideString;
begin
  Result := ReportData.UserID;
end;

procedure TReportData.Set_Datapath(const Value: WideString);
begin
  ReportData.Datapath := Value;
end;

procedure TReportData.Set_Index(Value: Integer);
begin
  ReportData.Index := Value;
end;

procedure TReportData.Set_UserID(const Value: WideString);
begin
  ReportData.UserID := Value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TReportTree, Class_ReportTree,
    ciSingleInstance, tmApartment);

finalization
  oReportTree := nil;
  oReportData := nil;
end.

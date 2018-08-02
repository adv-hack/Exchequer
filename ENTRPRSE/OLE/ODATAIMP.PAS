unit oDataImp;

{ markd6 12:58 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

uses
  Classes, Dialogs, Forms, OleAuto, SysUtils, Variants{, Enterprise01_TLB};

Type
  { Enterprise OLE Server object }
  TDataImportServer = class(TAutoObject)
  private
    // Internal StringList for Results
    FDataCodes : TStringList;

    // Internal reference to COM Toolkit used for data access
    FCOMTK : Variant;

    // Import Mode - 1=Customer, 2=Supplier, 3=CC, 4=Dept, 5=job, 6=Stock, 7=GLCode, 8=Locations
    FMode : Byte;

    // Company Code of selected Company
    FCompanyCode : ShortString;

    // Starting Cell Id within Excel Spreadsheet
    FXLStartCol : Integer;
    FXLStartRow : Integer;
  protected
    // Property CompanyCode : String
    function GetCompanyCode: String;
    procedure SetCompanyCode(const Value: String);
    // Property COMTK : IToolkit
    function GetCOMTK: Variant;
    // Property DataCodeCount : Integer
    function GetDataCodeCount: Integer;
    // Property DataCodes [Index : Integer] : String
    function GetDataCodes(Index: Integer): String;
    // Property Mode : Byte
    function GetMode: Byte;
    procedure SetMode(const Value: Byte);
    // Property XLStartCol : Integer
    function GetXLStartCol: Integer;
    procedure SetXLStartCol(const Value: Integer);
    // Property XLStartRow : Integer
    function GetXLStartRow: Integer;
    procedure SetXLStartRow(const Value: Integer);
    // Property Version : String
    function GetVersion: String;
  public
    Constructor Create; OverRide;
    Destructor  Destroy; OverRide;

    // Internal Properties use within the OLE Server
    Property COMTK : Variant Read GetCOMTK;
  Automated
    // External Properties published from the OLE Server
    Property CompanyCode : String Read GetCompanyCode Write SetCompanyCode;
    Property DataCodeCount : Integer Read GetDataCodeCount;
    Property DataCodes [Index : Integer] : String Read GetDataCodes;
    Property Mode : Byte Read GetMode Write SetMode;
    Property XLStartCol : Integer Read GetXLStartCol Write SetXLStartCol;
    Property XLStartRow : Integer Read GetXLStartRow Write SetXLStartRow;
    Property Version : String Read GetVersion;

    function Execute: SmallInt;
  end;

implementation

Uses //COMObj,      // Delphi COM routines needed to create COM Toolkit using COM
     SecCodes,    // Security Unit for COMTK Backdoor
     ImportF1,    // Select Company dialog
     ImportF2,    // Filter Criterion dialog
     ImportF3;    // Misc Options dialog

//-----------------------------------------------------------------------------------------------

// RegisterOLEServer: Registers the OLE Class with windows.
procedure RegisterOLEServer;
const
  EntServerInfo : TAutoClassInfo = (AutoClass: TDataImportServer;
                                    ProgID: 'Enterprise.DataQuery';
                                    ClassID: '{B8DE0958-9B05-4ADD-9485-42CC5CF21DED}';
                                    Description: 'Exchequer Data Query Server';
                                    Instancing: acSingleInstance);
begin
  Automation.RegisterClass(EntServerInfo);
end;

//-----------------------------------------------------------------------------------------------

constructor TDataImportServer.Create;
begin
  inherited;

  // Create StringList to hold result sets
  FDataCodes := TStringList.Create;

  // Initialise COM Toolkit reference
  FCOMTK := UnAssigned;
end;

//-----------------------------------

destructor TDataImportServer.Destroy;
begin
  // Destroy COM Toolkit reference
  FCOMTK := UnAssigned;

  // Destroy StringList for Result Sets
  FreeAndNIL(FDataCodes);

  inherited;
end;

//-----------------------------------------------------------------------------------------------

function TDataImportServer.Execute: SmallInt;
Const
  dlgSelComp = 1;
  dlgFilter = 2;
  dlgOptions = 3;
Var
  AbortWiz, FinishedWiz : Boolean;
  WizNo                 : Byte;
begin { Execute }
  Result := -1;

  AbortWiz := False;
  FinishedWiz := False;
  WizNo := dlgSelComp;
  While (Not AbortWiz) And (Not FinishedWiz) Do Begin
    Case WizNo Of
      // Select Company
      dlgSelComp : Begin
                     With TfrmSelectCompany.Create (Application.MainForm) Do
                       Try
                         DIS := Self;

                         ShowModal;

                         Case ExitCode Of
                           'B'  : ; // N/A
                           'N'  : WizNo := dlgFilter;
                           'X'  : AbortWiz := True;
                         Else
                           ShowMessage (ExitCode);
                         End; { Case ExitCode }
                       Finally
                         Free;
                       End;
                   End;

      // Filter Criteria
     dlgFilter   : Begin
                     With TfrmFilterCritera.Create (Application.MainForm) Do
                       Try
                         DIS := Self;

                         ShowModal;

                         Case ExitCode Of
                           'B'  : WizNo := dlgSelComp;
                           'N'  : WizNo := dlgOptions;
                           'X'  : AbortWiz := True;
                         Else
                           ShowMessage (ExitCode);
                         End; { Case ExitCode }
                       Finally
                         Free;
                       End;
                   End;

      // Options
     dlgOptions  : Begin
                     With TfrmMiscOptions.Create (Application.MainForm) Do
                       Try
                         DIS := Self;

                         ShowModal;

                         Case ExitCode Of
                           'B'  : WizNo := dlgFilter;
                           'N'  : FinishedWiz := True;
                           'X'  : AbortWiz := True;
                         Else
                           ShowMessage (ExitCode);
                         End; { Case ExitCode }
                       Finally
                         Free;
                       End;
                   End;
    Else
      ShowMessage ('Unknown WizNo: ' + IntToStr(WizNo));
      AbortWiz := True;
    End; { Case WizNo }
  End; { While (Not AbortWiz) And (Not FinishedWiz) }

  If AbortWiz Then ShowMessage ('AbortWiz');
  If FinishedWiz Then ShowMessage ('FinishedWiz');
End; { Execute }

//-----------------------------------------------------------------------------------------------

function TDataImportServer.GetCompanyCode: String;
begin
  Result := FCompanyCode;
end;

procedure TDataImportServer.SetCompanyCode(const Value: String);
begin
  If (Value <> FCompanyCode) Then Begin
    FCompanyCode := Value;

  End; { If (Value <> FCompanyCode) }
end;

//-----------------------------------

function TDataImportServer.GetDataCodeCount: Integer;
begin
  Result := FDataCodes.Count;
end;

//-----------------------------------

function TDataImportServer.GetDataCodes(Index: Integer): String;
begin
  If (Index >= 0) And (Index < FDataCodes.Count) Then
    Result := FDataCodes[Index]
  Else
    Raise Exception.Create ('Invalid Index (' + IntToStr(Index) + ') accessing DataCodes');
end;

//-----------------------------------

function TDataImportServer.GetMode: Byte;
begin
  Result := FMode;
end;

procedure TDataImportServer.SetMode(const Value: Byte);
begin
  If (Value In [1..8]) Then
    FMode := Value
  Else
    Raise Exception.Create ('Invalid Data Mode: ' + IntToStr(Value));
end;

//-----------------------------------

function TDataImportServer.GetVersion: String;
begin
  Result := 'b501.001';
end;

//-----------------------------------

function TDataImportServer.GetXLStartCol: Integer;
begin
  Result := FXLStartCol;
end;

procedure TDataImportServer.SetXLStartCol(const Value: Integer);
begin
  FXLStartCol := Value;
end;

//-----------------------------------

function TDataImportServer.GetXLStartRow: Integer;
begin
  Result := FXLStartRow;
end;

procedure TDataImportServer.SetXLStartRow(const Value: Integer);
begin
  FXLStartRow := Value;
end;

//-----------------------------------------------------------------------------------------------

function TDataImportServer.GetCOMTK: Variant;
Var
  A, B, C : longint;
begin
ShowMessage ('GetCOMTK 1');
  If (FCOMTK = UnAssigned) Then Begin
ShowMessage ('GetCOMTK 2');
    // MH 08/09/2008: Switched to .EXE COM Toolkit
    FCOMTK := CreateOLEObject ('Enterprise04.Toolkit');
ShowMessage ('GetCOMTK 3');
    {With  Do} Begin
      // Setup Backdoor to avoid licencing
      EncodeOpCode(97, A, B, C);
ShowMessage ('GetCOMTK 4');
      FCOMTK.Configuration.SetDebugMode (A, B, C);
ShowMessage ('GetCOMTK 5');

      // Any other configuration details ?

    End; { With FCOMTK.Configuration }
  End; { If (Not Assigned(FCOMTK)) }

  Result := FCOMTK;
ShowMessage ('GetCOMTK Fini');
end;

//-----------------------------------------------------------------------------------------------

Initialization
  RegisterOLEServer;
end.

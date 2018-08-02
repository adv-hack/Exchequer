unit DupRpDev;

interface

Uses Classes, Dialogs, SysUtils, RpDefine, RpDevice;

Type
  TDuplicateRpDev = Class;

  TDuplicateRpDevStrList = Class(TObject)
  Private
    FParentRpDev : TDuplicateRpDev;
    FStrIdx      : TRpDevStrListEnum;

    function GetCount: LongInt;
    function GetStrings(Index: Integer): ShortString;
  Protected
  Public
    Property Count : LongInt Read GetCount;
    Property Strings [Index : LongInt] : ShortString Read GetStrings; default;

    Constructor Create (ParentRpDev : TDuplicateRpDev; Const StrIdx : TRpDevStrListEnum);
  End;

  //--------------------------------------------

  TDuplicateRpDev = Class(TObject)
  Private
    FBinsList     : TDuplicateRpDevStrList;
    FPapersList   : TDuplicateRpDevStrList;
    FPrintersList : TDuplicateRpDevStrList;

    function GetDeviceIndex: SmallInt;
    procedure SetDeviceIndex(const Value: SmallInt);
    function GetOrientation: TOrientation;
    procedure SetOrientation(const Value: TOrientation);
  Protected
  Public
    Property Bins : TDuplicateRpDevStrList Read FBinsList;
    Property DeviceIndex : SmallInt Read GetDeviceIndex Write SetDeviceIndex;
    Property Orientation : TOrientation Read GetOrientation Write SetOrientation;
    Property Papers : TDuplicateRpDevStrList Read FPapersList;
    Property Printers : TDuplicateRpDevStrList Read FPrintersList;

    Constructor Create (Const LibName : ShortString);
    Destructor Destroy; Override;

    Function GetStrListCount (Const StrListIdx : TRpDevStrListEnum) : LongInt;
    Function GetStrListString (Const StrListIdx : TRpDevStrListEnum; Const StringIdx : LongInt) : ShortString;

    // Standard RpDev methods
    function PrinterSetupDialog: boolean;

    // Additional ESL methods added to RpDev
    function SBSSetupInfo : TSBSPrintSetupInfo;
    procedure SetPrnSetup(PrnSetup : TSBSPrintSetupInfo);
    Function WalkList (Const ListNo : TRpDevStrListEnum; ReqNum : Integer) : ShortString;
    function SBSSetupInfo2(Const BaseInfo : TSBSPrintSetupInfo) : TSBSPrintSetupInfo;
  End;

implementation


Function EntPrint_GetDevIdx : SmallInt; StdCall;
begin
end;

Procedure EntPrint_SetDevIdx (Const DevIdx :  SmallInt); StdCall;
begin
end;

function EntPrint_GetOrientation: TOrientation; StdCall;
begin
end;

procedure EntPrint_SetOrientation(const Value: TOrientation); StdCall;
begin
end;

function EntPrint_PrinterSetupDialog : boolean; StdCall;
begin
end;

function EntPrint_SBSSetupInfo : TSBSPrintSetupInfo; StdCall;
begin
end;
function EntPrint_SBSSetupInfo2(Const BaseInfo : TSBSPrintSetupInfo) : TSBSPrintSetupInfo; StdCall;
begin
end;
procedure EntPrint_SetPrnSetup(PrnSetup : TSBSPrintSetupInfo); StdCall;
begin
end;

function EntPrint_WalkList(Const ListNo : TRpDevStrListEnum; ReqNum: Integer) : ShortString; StdCall;
begin
end;
function EntPrint_GetStrListCount(const ListNo: TRpDevStrListEnum) : LongInt; StdCall;
begin
end;
function EntPrint_GetStrListString(const ListNo: TRpDevStrListEnum; const StringIdx: Integer): ShortString; StdCall;
begin
end;

//-----------------------------------------------------------------------------

Constructor TDuplicateRpDevStrList.Create (ParentRpDev : TDuplicateRpDev; Const StrIdx : TRpDevStrListEnum);
Begin
  Inherited Create;

  FParentRpDev := ParentRpDev;
  FStrIdx := StrIdx;
End;

//------------------------------

function TDuplicateRpDevStrList.GetCount: LongInt;
begin
  Result := FParentRpDev.GetStrListCount (FStrIdx);
end;

//------------------------------

function TDuplicateRpDevStrList.GetStrings(Index: Integer): ShortString;
begin
  Result := FParentRpDev.GetStrListString (FStrIdx, Index);
end;

//-----------------------------------------------------------------------------

constructor TDuplicateRpDev.Create(const LibName: ShortString);
begin
  inherited Create;

  FBinsList := TDuplicateRpDevStrList.Create (Self, rpDevStrBins);
  FPapersList := TDuplicateRpDevStrList.Create (Self, rpDevStrPapers);
  FPrintersList := TDuplicateRpDevStrList.Create (Self, rpDevStrPrinters);
end;

destructor TDuplicateRpDev.Destroy;
begin
  FreeAndNIL(FBinsList);
  FreeAndNIL(FPapersList);
  FreeAndNIL(FPrintersList);

  inherited;
end;

//---------------------------------------

function TDuplicateRpDev.GetStrListCount(const StrListIdx: TRpDevStrListEnum): LongInt;
begin
  Result := EntPrint_GetStrListCount(StrListIdx);
end;

function TDuplicateRpDev.GetStrListString(const StrListIdx: TRpDevStrListEnum; const StringIdx: Integer): ShortString;
begin
  Result := EntPrint_GetStrListString(StrListIdx, StringIdx);
end;

//---------------------------------------

function TDuplicateRpDev.GetDeviceIndex: SmallInt;
begin
  Result := EntPrint_GetDevIdx;
end;

procedure TDuplicateRpDev.SetDeviceIndex(const Value: SmallInt);
begin
  EntPrint_SetDevIdx (Value);
end;

//---------------------------------------

function TDuplicateRpDev.GetOrientation: TOrientation;
begin
  Result := EntPrint_GetOrientation;
end;

procedure TDuplicateRpDev.SetOrientation(const Value: TOrientation);
begin
  EntPrint_SetOrientation(Value);
end;

//--------------------------------------------------------------

function TDuplicateRpDev.PrinterSetupDialog: boolean;
begin
  Result := EntPrint_PrinterSetupDialog;
end;

//---------------------------------------

function TDuplicateRpDev.SBSSetupInfo: TSBSPrintSetupInfo;
begin
  Result := EntPrint_SBSSetupInfo;
end;

function TDuplicateRpDev.SBSSetupInfo2(const BaseInfo: TSBSPrintSetupInfo): TSBSPrintSetupInfo;
begin
  Result := EntPrint_SBSSetupInfo2(BaseInfo);
end;

procedure TDuplicateRpDev.SetPrnSetup(PrnSetup: TSBSPrintSetupInfo);
begin
  EntPrint_SetPrnSetup(PrnSetup);
end;

//--------------------------------------------------------------

function TDuplicateRpDev.WalkList(Const ListNo : TRpDevStrListEnum; ReqNum: Integer): ShortString;
begin
  // needs redesign
  Result := EntPrint_WalkList(ListNo, ReqNum);
end;

//--------------------------------------------------------------

end.

library EntPrint;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  ShareMem,
  SysUtils,
  Classes,
  Windows,
//Dialogs,
  RpDefine,
  RpDevice;

{$R *.res}

// MH 30/05/2014 v7.0.10 ABSEXCH-15404: Added PE Flags to force entire component to be loaded into memory
{$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP or IMAGE_FILE_NET_RUN_FROM_SWAP}

//----------------------------------------------------------------------

Function EntPrint_GetDevIdx : SmallInt; StdCall;
Begin { EntPrint_GetRPDevice }
  Result := RpDev.DeviceIndex;
End; { EntPrint_GetRPDevice }

Procedure EntPrint_SetDevIdx (Const DevIdx :  SmallInt); StdCall;
Begin { EntPrint_SetDevIdx }
  RpDev.DeviceIndex := DevIdx;
End; { EntPrint_SetDevIdx }

//----------------------------------------------------------------------

function EntPrint_GetOrientation: TOrientation; StdCall;
begin
  Result := RpDev.Orientation;
end;

procedure EntPrint_SetOrientation(const Value: TOrientation); StdCall;
begin
  RpDev.Orientation := Value;
End;

//----------------------------------------------------------------------

function EntPrint_PrinterSetupDialog : boolean; StdCall;
Begin
  Result := RpDev.PrinterSetupDialog;
End;

//----------------------------------------------------------------------

function EntPrint_SBSSetupInfo : TSBSPrintSetupInfo; StdCall;
//Var
//  X : TObject;
Begin
//  Try
//X := RpDev;
//If Not Assigned(X) Then ShowMessage ('EntPrint_SBSSetupInfo: RpDev is NIL');
//
    Result := RpDev.SBSSetupInfo;
//  Except
//    On E:Exception Do
//      ShowMessage ('EntPrint_SBSSetupInfo: ' + E.Message);
//  End; //
end;

function EntPrint_SBSSetupInfo2(Const BaseInfo : TSBSPrintSetupInfo) : TSBSPrintSetupInfo; StdCall;
Begin
  Result := RpDev.SBSSetupInfo2(BaseInfo);
End;

procedure EntPrint_SetPrnSetup(PrnSetup : TSBSPrintSetupInfo); StdCall;
Begin
  RpDev.SetPrnSetup(PrnSetup);
End;

//----------------------------------------------------------------------

//Function WalkList (TheList : TDuplicateRpDevStrList; ReqNum : Integer) : String;
function EntPrint_WalkList(Const ListNo : TRpDevStrListEnum; ReqNum: Integer) : ShortString; StdCall;
Begin
  Case ListNo Of
    rpDevStrBins     : Result := RpDev.WalkList(RpDev.Bins, ReqNum);
    rpDevStrPapers   : Result := RpDev.WalkList(RpDev.Papers, ReqNum);
    rpDevStrPrinters : Result := RpDev.WalkList(RpDev.Printers, ReqNum);
  Else
    Raise Exception.Create (Format('EntPrint_WalkList - Invalid ListNo (%d)', [Ord(ListNo)]));
  End; { Case ListNo }
End;

function EntPrint_GetStrListCount(const ListNo: TRpDevStrListEnum) : LongInt; StdCall;
Begin
  Case ListNo Of
    rpDevStrBins     : Result := RpDev.Bins.Count;
    rpDevStrPapers   : Result := RpDev.Papers.Count;
    rpDevStrPrinters : Result := RpDev.Printers.Count;
  Else
    Raise Exception.Create (Format('EntPrint_GetStrListCount - Invalid ListNo (%d)', [Ord(ListNo)]));
  End; { Case ListNo }
End;

function EntPrint_GetStrListString(const ListNo: TRpDevStrListEnum; const StringIdx: Integer): ShortString; StdCall;
Begin
  Case ListNo Of
    rpDevStrBins     : Result := RpDev.Bins[StringIdx];
    rpDevStrPapers   : Result := RpDev.Papers[StringIdx];
    rpDevStrPrinters : Result := RpDev.Printers[StringIdx];
  Else
    Raise Exception.Create (Format('EntPrint_GetStrListCount - Invalid ListNo (%d)', [Ord(ListNo)]));
  End; { Case ListNo }
End;

//----------------------------------------------------------------------


Exports
  EntPrint_GetDevIdx,
  EntPrint_SetDevIdx,

  EntPrint_GetOrientation,
  EntPrint_SetOrientation,

  EntPrint_PrinterSetupDialog,

  EntPrint_SBSSetupInfo,
  EntPrint_SBSSetupInfo2,
  EntPrint_SetPrnSetup,

  EntPrint_WalkList,
  EntPrint_GetStrListCount,
  EntPrint_GetStrListString;
end.

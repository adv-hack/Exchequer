unit DLLProc;

{ nfrewer440 09:07 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  VarConst, StrUtil, UseDLLU, SysUtils, Dialogs, Crypto, BTrvU2, APIUtil;

type
  TDLL = Class
    public
      TKSysRec : TBatchSysRec;
      Opened : boolean;
      constructor Create;
      destructor Destroy;
      function GetNextDocNo(DocType : DocTypes; bIncrementNo : boolean): string10;
      function GetNextFolioNo(DocHed : DocTypes; bIncrementNo : boolean) : integer;
      procedure GetGlobalVATRate;
      function GetCustAccount(sCode : string): string;
    private
      function OpenDLL : boolean;
      procedure CloseDLL;
      procedure ShowToolKitError(sFuncName : string; iFuncNo, iStatus : smallint);
  end;{TDLL}

  Procedure CS_CHANGEDOCTXLATE (PREDOC, POSTDOC : PCHAR); STDCALL; EXTERNAL 'ENTDLL32.DLL';

var
  oDLL : TDLL;

implementation


{TDLL}

constructor TDLL.Create;
var
  iStatus : smallint;
begin
  inherited create;
  OpenDLL;
  iStatus := Ex_GetSysData(@TKSysRec, SizeOf(TKSysRec));
  ShowToolKitError('Ex_GetSysData : ', 91, iStatus);
end;

destructor TDLL.Destroy;
begin
  CloseDLL;
  inherited Destroy;
end;

function TDLL.OpenDLL : boolean;
var
  iStatus : smallint;
  pExPath, pCode : array[0..255] of char;
const
  Code = #206 + #139 + #164 + #167 + #188 + #175 + #42 + #114 + #59 + #172 + #149;
begin
  {Set DLL Path}
  if sgEntPathOverride = '' then StrPCopy(pExPath, Syss.ExPath)
  else StrPCopy(pExPath, sgEntPathOverride);

{  ShowToolKitError('Ex_InitDllPath (' + pExPath + ') :', 84, Ex_InitDllPath(pExPath, TRUE));}
  ShowToolKitError('Ex_InitDllPath (' + pExPath + ') :', 84, Ex_InitDllPath(pExPath, FALSE));

  {DLL BackDoor}
  ChangeCryptoKey(606010);
  StrPCopy(pCode, Decode(CODE));
  Ex_SetReleaseCode(pCode);

  {Open Toolkit}
  iStatus := Ex_InitDLL;
  ShowToolKitError('Ex_InitDLL', 1, iStatus);

  if iStatus = 0 then begin
    CS_ChangeDocTxLate ('SOR', 'SOA');
    CS_ChangeDocTxLate ('SRI', 'SIN');
    CS_ChangeDocTxLate ('SRF', 'SCR');
    CS_ChangeDocTxLate ('PPI', 'PIN');
    CS_ChangeDocTxLate ('PRF', 'PCR');
  end;{if}

  Opened := iStatus = 0;
end;

procedure TDLL.CloseDLL;
begin
  if Opened then ShowToolKitError('Ex_CloseDLL',2,Ex_CloseDLL);
end;

function TDLL.GetNextDocNo(DocType : DocTypes; bIncrementNo : boolean): string10;
var
  PC : PChar;
begin
  PC := StrAlloc(255);
  StrPCopy(PC,DocCodes[DocType]);
  ShowToolKitError('Ex_GetNextTransNo',22,Ex_GetNextTransNo(PC, PC, bIncrementNo));
  GetNextDocNo := PC;
  StrDispose(PC);
end;

function TDLL.GetNextFolioNo(DocHed : DocTypes; bIncrementNo : boolean) : integer;
var
  sDocNo : string10;
begin
  sDocNo := GetNextDocNo(DocHed, bIncrementNo);
  sDocNo := Copy(sDocNo,4,10);
  GetNextFolioNo := StrToInt(sDocNo);
end;

procedure TDLL.GetGlobalVATRate;
var
  BatchVatRec : ^TBatchVatRec;
begin
  if Opened then begin
    new(BatchVATRec);
    BatchVatRec^.VatCode := 'S';
    ShowToolKitError('Ex_GetVatRate',81,Ex_GetVatRate(BatchVATRec, SizeOf(BatchVATRec^)));
    igStdVATRate := BatchVatRec^.VatRate;
    dispose(BatchVATRec);
  end;{if}
end;

function TDLL.GetCustAccount(sCode : string): string;
Var
  AccountRec : ^TBatchCURec;
  SearchKey  : PChar;
  iStatus : smallint;
begin
  New (AccountRec);
  SearchKey := StrAlloc(255);
  StrPCopy(SearchKey, sCode);

  iStatus := EX_GETACCOUNT(AccountRec,            // P
                       SizeOf(AccountRec^),   // PSIZE
                       SearchKey,             // SEARCHKEY
                       0,                     // SEARCHPATH
                       B_GetEq,               // SEARCHMODE
                       1,                     // ACCTYPE - 1 = Customer
                       False);                // LOCK

  case iStatus of
    0 : Result := AccountRec^.Company;
    4 : Result := '##NOTFOUND##';
    else ShowToolKitError('Ex_GetAccount',3,iStatus);
  end;{case}

  StrDispose (SearchKey);
  Dispose (AccountRec);
end;

procedure TDLL.ShowToolKitError(sFuncName : string; iFuncNo, iStatus : smallint);
begin
  if iStatus <> 0 then begin
    MsgBox('Function : ' + sFuncName + #13 + 'Error Number : ' + IntToStr(iStatus) + #13
    + 'Error : ' + EX_ERRORDESCRIPTION(iFuncNo, iStatus),mtError,[mbOK],mbOK,'Toolkit DLL Error');
  end;{if}
end;



end.

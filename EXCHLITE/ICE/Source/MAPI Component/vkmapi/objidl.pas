unit objidl;

interface

uses Windows, Messages, SysUtils, Classes, ComObj;

resourcestring
  SFCreateError = 'Cannot create file %s';

const

  IID_ISequentialStream     : TGUID = '{0C733A30-2A1C-11CE-ADE5-00AA0044773D}';
  IID_IStream               : TGUID = '{0000000C-0000-0000-C000-000000000046}';
  IID_IStorage              : TGUID = '{0000000B-0000-0000-C000-000000000046}';
  IID_IEnumStatStg          : TGUID = '{0000000D-0000-0000-C000-000000000046}';

  //* Storage instantiation modes */
  STGM_DIRECT             = $00000000;
  STGM_TRANSACTED         = $00010000;
  STGM_SIMPLE             = $08000000;

  STGM_READ               = $00000000;
  STGM_WRITE              = $00000001;
  STGM_READWRITE          = $00000002;

  STGM_SHARE_DENY_NONE    = $00000040;
  STGM_SHARE_DENY_READ    = $00000030;
  STGM_SHARE_DENY_WRITE   = $00000020;
  STGM_SHARE_EXCLUSIVE    = $00000010;

  STGM_PRIORITY           = $00040000;
  STGM_DELETEONRELEASE    = $04000000;
  STGM_NOSCRATCH          = $00100000;

  STGM_CREATE             = $00001000;
  STGM_CONVERT            = $00020000;
  STGM_FAILIFTHERE        = $00000000;

  STGM_NOSNAPSHOT         = $00200000;

  STREAM_SEEK_SET = 0;
  STREAM_SEEK_CUR = 1;
  STREAM_SEEK_END = 2;

type

  LPBYTE = ^BYTE;
  LPPBYTE = ^LPBYTE;
  LPSMALLINT = ^SmallInt;
  LPSINGLE = ^Single;
  LPDOUBLE = ^double;
  LONG = LongInt;
  PLONG = ^LONG;
  DWORD = Cardinal;
  ULONG = Cardinal;
  PULONG = ^ULONG;
  LONGLONG = Int64;
  SCODE = LONG;
  LPUNKNOWN = ^IUnknown;
  LPPUNKNOWN = ^LPUNKNOWN;
  PPCHAR = ^pChar;
  PPPCHAR = ^PPCHAR;
  pPointer = ^Pointer;
  LPWSTR = pWideChar;
  LPOLESTR = LPWSTR;
  TSNB = ^LPOleStr;

  PIID = PGUID;
  TIID = TGUID;
  PCLSID = PGUID;
  TCLSID = TGUID;

  //LARGE_INTEGER = packed record
  //  QuadPart: LONGLONG;
  //end;
  LARGE_INTEGER = LONGLONG;
  PLARGE_INTEGER = ^LARGE_INTEGER;
  ULARGE_INTEGER = LARGE_INTEGER;
  PULARGE_INTEGER = ^ULARGE_INTEGER;

  STATSTG = packed record
    pwcsName: LPOLESTR;
    _type: DWORD;
    cbSize: ULARGE_INTEGER;
    mtime: FILETIME;
    ctime: FILETIME;
    atime: FILETIME;
    grfMode: DWORD;
    grfLocksSupported: DWORD;
    clsid: TGUID;
    grfStateBits: DWORD;
    reserved: DWORD;
  end;
  TStatStg = STATSTG;
  LPSTATSTG = ^STATSTG;

  {forward declarations}

  ISequentialStream = interface;
  LPSEQUENTIALSTREAM = ^ISequentialStream;
  LPPSEQUENTIALSTREAM = ^LPSEQUENTIALSTREAM;

  IStream = interface;
  LPSTREAM = ^IStream;
  LPPSTREAM = ^LPSTREAM;

  ISequentialStream = interface
    function Read(pv: Pointer; cb: ULONG; pcbRead: PULONG): HRESULT; stdcall;
    function Write(const pv: Pointer; cb: ULONG; pcbWritten: PULONG): HRESULT; stdcall;
  end;

  IStream = interface(ISequentialStream)
    function Seek(dlibMove: LARGE_INTEGER; dwOrigin: DWORD; plibNewPosition: PULARGE_INTEGER): HRESULT; stdcall;
    function SetSize(libNewSize: ULARGE_INTEGER): HRESULT; stdcall;
    function CopyTo(pstm: IStream; cb: ULARGE_INTEGER; pcbRead: PULARGE_INTEGER; pcbWritten: PULARGE_INTEGER): HRESULT; stdcall;
    function Commit(grfCommitFlags: DWORD): HRESULT; stdcall;
    function Revert: HRESULT; stdcall;
    function LockRegion(libOffset: ULARGE_INTEGER; cb: ULARGE_INTEGER; dwLockType: DWORD): HRESULT; stdcall;
    function UnlockRegion(libOffset: ULARGE_INTEGER; cb: ULARGE_INTEGER; dwLockType: DWORD): HRESULT; stdcall;
    function Stat(pstatstg: LPSTATSTG; grfStatFlag: DWORD): HRESULT; stdcall;
    function Clone(ppstm: LPSTREAM): HRESULT; stdcall;
  end;

  IEnumStatStg = interface(IUnknown)
    function Next(celt: Longint; out elt;
      pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out enm: IEnumStatStg): HResult; stdcall;
  end;

  IStorage = interface(IUnknown)
    function CreateStream(pwcsName: LPOleStr; grfMode: Longint; reserved1: Longint;
      reserved2: Longint; out stm: IStream): HResult; stdcall;
    function OpenStream(pwcsName: LPOleStr; reserved1: Pointer; grfMode: Longint;
      reserved2: Longint; out stm: IStream): HResult; stdcall;
    function CreateStorage(pwcsName: LPOleStr; grfMode: Longint;
      dwStgFmt: Longint; reserved2: Longint; out stg: IStorage): HResult;
      stdcall;
    function OpenStorage(pwcsName: LPOleStr; const stgPriority: IStorage;
      grfMode: Longint; snbExclude: TSNB; reserved: Longint;
      out stg: IStorage): HResult; stdcall;
    function CopyTo(ciidExclude: Longint; rgiidExclude: PIID;
      snbExclude: TSNB; const stgDest: IStorage): HResult; stdcall;
    function MoveElementTo(pwcsName: LPOleStr; const stgDest: IStorage;
      pwcsNewName: LPOleStr; grfFlags: Longint): HResult; stdcall;
    function Commit(grfCommitFlags: Longint): HResult; stdcall;
    function Revert: HResult; stdcall;
    function EnumElements(reserved1: Longint; reserved2: Pointer; reserved3: Longint;
      out enm: IEnumStatStg): HResult; stdcall;
    function DestroyElement(pwcsName: LPOleStr): HResult; stdcall;
    function RenameElement(pwcsOldName: LPOleStr;
      pwcsNewName: LPOleStr): HResult; stdcall;
    function SetElementTimes(pwcsName: LPOleStr; const ctime: TFileTime;
      const atime: TFileTime; const mtime: TFileTime): HResult;
      stdcall;
    function SetClass(const clsid: TCLSID): HResult; stdcall;
    function SetStateBits(grfStateBits: Longint; grfMask: Longint): HResult;
      stdcall;
    function Stat(out statstg: TStatStg; grfStatFlag: Longint): HResult;
      stdcall;
  end;

  {TIStream}
  TIStream = class(TStream)
  protected
    FStream: IStream;
    procedure SetSize(NewSize: Longint); override;
  public
    constructor Create(Stream: IStream);
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
    procedure SaveToFile(const FileName: string);
    procedure LoadFromFile(const FileName: string); 
    property IntStream: IStream read FStream;
  end;

function StgCreateDocfile(pwcsName: LPOleStr; grfMode: Longint;
  reserved: Longint; out stgOpen: IStorage): HResult; stdcall;

implementation

uses VKMAPI;

const
  ole32    = 'ole32.dll';
  oleaut32 = 'oleaut32.dll';
  olepro32 = 'olepro32.dll';

function StgCreateDocfile;              external ole32 name 'StgCreateDocfile';

{ TIStream }

constructor TIStream.Create(Stream: IStream);
begin
  FStream := Stream;
end;

destructor TIStream.Destroy;
begin
  FStream := nil;
  inherited Destroy;
end;

procedure TIStream.LoadFromFile(const FileName: string);
var
  pStrmSrc: IStream;
  StatInfo: STATSTG;
  hr: HRESULT;
begin
  pStrmSrc := nil;
  try
    pStrmSrc := nil;
    hr := OpenStreamOnFile( @MAPIAllocateBuffer,
                            @MAPIFreeBuffer,
                            0,
                            pChar(FileName),
                            nil,
                            @pStrmSrc);
    if not FAILED(hr) then
    begin
      pStrmSrc.Stat(@StatInfo, 1 {STATFLAG_NONAME});
      OleCheck(pStrmSrc.CopyTo( FStream,
                                StatInfo.cbSize,
                                nil,
                                nil));
      Seek(0, STREAM_SEEK_SET);
    end else
      OleCheck(hr);
  finally
    pStrmSrc := nil;
  end;
end;

function TIStream.Read(var Buffer; Count: Integer): Longint;
begin
  OleCheck(FStream.Read(@Buffer, Count, @Result));
end;

procedure TIStream.SaveToFile(const FileName: string);
var
  pStrmDest: IStream;
  //pStg : IStorage;
  StatInfo: STATSTG;
  Pos: Longint;
  hr: HRESULT;
  //qq: WideString;
  LI, li1, li2: ULARGE_INTEGER;
begin
  pStrmDest := nil;
  try

    {
    pStg := nil;
    qq := FileName;
    OleCheck(StgCreateDocfile(  LPOleStr(qq),
                                STGM_READWRITE or STGM_SHARE_EXCLUSIVE or STGM_DIRECT or STGM_CREATE,
                                0,
                                pStg));
    qq := ExtractFileName(FileName);
    hr := pStg.CreateStream(  LPOleStr(qq),
                              STGM_READWRITE or STGM_SHARE_EXCLUSIVE or STGM_DIRECT or STGM_CREATE,
                              0,
                              0,
                              pStrmDest);
    }
    hr := OpenStreamOnFile( @MAPIAllocateBuffer,
                            @MAPIFreeBuffer,
                            STGM_READWRITE or STGM_SHARE_EXCLUSIVE or STGM_DIRECT or STGM_CREATE,
                            pChar(FileName),
                            nil,
                            @pStrmDest);

    if not FAILED(hr) then
    begin
      Pos := Seek(0, STREAM_SEEK_CUR);
      Seek(0, STREAM_SEEK_SET);
      FStream.Stat(@StatInfo, 1 {STATFLAG_NONAME});
      pStrmDest.Seek(0, STREAM_SEEK_SET, @LI);
      OleCheck(FStream.CopyTo(  pStrmDest,
                                StatInfo.cbSize,
                                @li1,
                                @li2));
      Seek(Pos, STREAM_SEEK_SET);
    end else
      OleCheck(hr);
  finally
    pStrmDest := nil;
    //pStg := nil;
  end;
end;

function TIStream.Seek(Offset: Integer; Origin: Word): Longint;
var
  Pos: ULARGE_INTEGER;
begin
  OleCheck(FStream.Seek(Offset, Origin, @Pos));
  Result := Longint(Pos);
end;

procedure TIStream.SetSize(NewSize: Integer);
begin
  FStream.SetSize(NewSize);
end;

function TIStream.Write(const Buffer; Count: Integer): Longint;
begin
  OleCheck(FStream.Write(@Buffer, Count, @Result));
end;

end.

unit ILRegister;

interface

uses
  {$IFDEF Linux}
  {$ELSE}
  Windows,
  {$ENDIF}
  Classes,
  ILConfig,
  LinkIL;

type
  TILLinkRegistrationItem = class(TCollectionItem)
  public
    ConfigClass: TILConfigClass;
    LibraryHandle: HModule;
    LinkClass: TILLinkClass;
    LinkName: string;
    //
    procedure AssignTo(ADest: TPersistent); override;
    destructor Destroy; override;
  end;

  TILLinkRegistration = class(TCollection)
  protected
    class procedure CreateGlobal;
  public
    function Add: TILLinkRegistrationItem; reintroduce;
    function ByName(const ALinkName: string; const ARaiseExceptionIfNotFound: Boolean = True)
     : TILLinkRegistrationItem;
    constructor Create; reintroduce;
    procedure GetLinkNames(AStrings: TStrings);
    class procedure LoadAllLinks(ACheckExt: Boolean = True);
    class procedure LoadLink(const APathname: string);
    class procedure RegisterLink(const ALinkName: string; ALinkClass: TILLinkClass;
     AConfigClass: TILConfigClass);
  end;

var
  GILLinks: TILLinkRegistration = nil;

implementation

uses
  {$IFDEF Linux}
  QForms,
  Libc,
  Qt,
  {$ELSE}
  Forms,
  {$ENDIF}
  ILConfig_Default,
  SysUtils;

{ TILLinkRegistrationItem }

procedure TILLinkRegistrationItem.AssignTo(ADest: TPersistent);
var
  LDest: TILLinkRegistrationItem;
begin
  // Cannot use IS. This is called across the DLL boundary and thus is fails.
  if (CompareText(ADest.ClassName, 'TILLinkRegistrationItem') = 0) then begin
    LDest := TILLinkRegistrationItem(ADest);
    LDest.ConfigClass := ConfigClass;
    LDest.LibraryHandle := LibraryHandle;
    LDest.LinkClass := LinkClass;
    LDest.LinkName := LinkName;
  end else begin
    inherited;
  end;
end;

destructor TILLinkRegistrationItem.Destroy;
begin

  if LibraryHandle <> 0 then begin
    {$IFDEF Linux}
    if not FreeLibrary(LibraryHandle) then begin
      dlerror;
    end;
    {$ELSE}
    Win32Check(FreeLibrary(LibraryHandle));
    {$ENDIF}
  end;
  inherited;
end;

{ TILLinkRegistration }

class procedure TILLinkRegistration.LoadAllLinks(ACheckExt: Boolean = True);
var
  i: integer;
  s: string;
  LPath: string;
  LSearchRec: TSearchRec;
begin
  CreateGlobal;
  SetLength(s, MAX_PATH);
  i := GetModuleFileName(HInstance, PChar(s), Length(s));
  if i = 0 then begin
    {$IFDEF Linux}
    dlerror; // TODO Need to raise or just it does it
    {$ELSE}
    RaiseLastWin32Error;
    {$ENDIF}
  end;
  SetLength(s, i);
  // IsLibrary does not work here because this is called from initialization sections
  // and the DLL is dynamically loaded. Delphi bug.
  {$IFNDEF Linux}
  if (ACheckExt) and (CompareText(ExtractFileExt(s), '.exe') <> 0) then begin
    Exit;
  end;
  {$ENDIF}
  //TODO: Change this back to TCLFileSearch
  LPath := ExtractFilePath(ParamStr(0)) + 'DIBLLinks\'; // + PATHDELIM
  {$IFDEF Linux} // Linux doesn't support other extensions that are not .so
  i := FindFirst(LPath + '*.so', faAnyFile, LSearchRec); try
  {$ELSE}
  i := FindFirst(LPath + '*.RVD', faAnyFile, LSearchRec); try
  {$ENDIF}
    while i = 0 do begin
      LoadLink(LPath + LSearchRec.Name);
      i := FindNext(LSearchRec);
    end;
  finally SysUtils.FindClose(LSearchRec); end;
end;

constructor TILLinkRegistration.Create;
begin
  inherited Create(TILLinkRegistrationItem);
end;

class procedure TILLinkRegistration.CreateGlobal;
begin
  if GILLinks = nil then begin
    GILLinks := TILLinkRegistration.Create;
  end;
end;

class procedure TILLinkRegistration.RegisterLink(const ALinkName: string;
  ALinkClass: TILLinkClass; AConfigClass: TILConfigClass);
var
  LPreRegItem: TILLinkRegistrationItem;
begin
  // Must be here as this routine is called from other initialization sections
  CreateGlobal;
  // Check to see if a dynamnically loaded version already exists. Statics always supercede
  // dynamics. Dynamics will always be loaded first as they are loaded in the contructor
  // and do not call this method during their registration.
  // This merely disables the dynamically loaded one. Unloading the DLL causes Delphi to
  // flip out when Application.Initialize is called.
  LPreRegItem := GILLinks.ByName(ALinkName, False);
  If Assigned(LPreRegItem) then begin
    LPreRegItem.LinkName := '';
  end; { if }
  // Register Link
  with GILLinks.Add do begin
    LinkName := ALinkName;
    LinkClass := ALinkClass;
    ConfigClass := AConfigClass;
    if ConfigClass = nil then begin
      ConfigClass := TFormILConfigDefault;
    end;
    LibraryHandle := 0;
  end;
end;

function TILLinkRegistration.ByName(const ALinkName: string;
 const ARaiseExceptionIfNotFound: Boolean = True): TILLinkRegistrationItem;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do begin
    Result := TILLinkRegistrationItem(Items[i]);
    if (CompareText(Result.LinkName, ALinkName) = 0) then begin
      exit;
    end;
  end;
  if ARaiseExceptionIfNotFound then begin
    Raise Exception.Create('"' + ALinkName + '" not found.');
  end;
  Result := nil;
end;

function TILLinkRegistration.Add: TILLinkRegistrationItem;
begin
  Result := TILLinkRegistrationItem(inherited Add);
end;

procedure TILLinkRegistration.GetLinkNames(AStrings: TStrings);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do begin
    AStrings.Add(TILLinkRegistrationItem(Items[i]).LinkName);
  end;
end;

class procedure TILLinkRegistration.LoadLink(const APathname: string);
type
  TInitProc = procedure(AAppHandle: THandle; ARegItem: TILLinkRegistrationItem);
var
  LInitProc: TInitProc;
  LInstance: HModule;
  LRegItem: TILLinkRegistrationItem;
begin
  CreateGlobal;
  LInstance := LoadLibrary(PChar(APathname));
  if LInstance = 0 then begin
    {$IFDEF Linux}
    dlerror;
    {$ELSE}
    RaiseLastWin32Error;
    {$ENDIF}
  end;
  //
  LInitProc := GetProcAddress(LInstance, 'Init');
  if @LInitProc = nil then begin
    {$IFDEF Linux}
    dlerror;
    {$ELSE}
    RaiseLastWin32Error;
    {$ENDIF}
  end;
  LRegItem := GILLinks.Add;
  {$IFDEF Linux}
  LInitProc(Cardinal(Application.Handle), LRegItem);
  {$ELSE}
  LInitProc(Application.Handle, LRegItem);
  {$ENDIF}
  LRegItem.LibraryHandle := LInstance;
end;

initialization
finalization
  GILLinks.Free;
  GILLinks := nil;
end.
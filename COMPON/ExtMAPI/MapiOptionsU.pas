unit MapiOptionsU;

interface

{This class is designed to tell the Exchequer MAPI component whether to
 use 64-bit or 32-bit MAPI. We try to do this automatically by reading the
 name and path of the default MAPI dll from the registry, then reading the bitness
 from the dll's header.

 In case of problems we can't foresee, we allow an optional value to be added to
 the register to override the automatic detection:
 HKEY_LOCAL_MACHINE\SOFTWARE\Exchequer\Enterprise\MAPIBitness -
 permissible values are 'x32' or 'x64'

 By default, the MAPI component uses offline caching mode, so that emails are
 put into the Outlook outbox. However, there may be situations where this is
 not appropriate so look for an optional boolean value in the registry:
 HKEY_LOCAL_MACHINE\SOFTWARE\Exchequer\Enterprise\NoMAPIOfflineCache. If this is true, then
 the MAPI component will use online mode.}


type
  //Indicates whether a registry entry has been set under Exchequer key to
  //specify bitness of MAPI
  TExchequerMAPIBitness = (embNotSet, emb32Bit, emb64bit);

  //Class to implement the IMapiOptions interface
  TMapiOptions = Class
  private
    FDLLPath : string;
    FUse64BitMapi : Boolean;
    FNoCachedMode : Boolean;
    FExchequerMAPIBitness : TExchequerMAPIBitness;

    //Internal functions
    function ReadMAPIPathFromRegistry : Boolean;
    function ReadExchequerSettingsFromRegistry : Boolean;
    function IsMapi64Bit : Boolean;
    function ReadDLLBitness : Word;

    //property getters
    function GetUse64BitMapi : Boolean;
    function GetNoCachedMode : Boolean;


  public
    constructor Create;

    //If True, use the 64-bit MAPI COM object
    property moUse64BitMapi : Boolean read GetUse64BitMapi;
    //If True, don't use offline cache
    property moNoCachedMode : Boolean read GetNoCachedMode;
  end;


  function MapiOptions : TMapiOptions;

implementation

uses
  Classes, Registry, Windows, SysUtils, Dialogs, sx_MAPI;

const
  //Constants for CPU type in dll header
  I386  = $014C;
  IA64  = $0200;
  AMD64 = $8664;



var
  oMapiOptions : TMapiOptions;

  //Return singleton instance
  function MapiOptions : TMapiOptions;
  begin
    if not Assigned(oMapiOptions) then
      oMapiOptions := TMapiOptions.Create;

    Result := oMapiOptions;
  end;

{ TMapiOptions }

constructor TMapiOptions.Create;
begin
  inherited;

  //Read the optional Exchequer settings
  ReadExchequerSettingsFromRegistry;
  {$IFDEF WIN64}
  //Being compiled into the MAPI COM object
  FUse64BitMapi := False;
  {$ELSE}
  //Do we have an Exchequer setting in the registry to specify MAPI bitness?
  if FExchequerMAPIBitness = embNotSet then
  begin
    //No Exchequer setting - check whether MAPI installed on machine is 64-bit
    FUse64BitMapi := IsMapi64Bit;
  end
  else
  begin
    //Use Exchequer setting
    FUse64BitMapi := FExchequerMAPIBitness = emb64Bit;
  end;
  {$ENDIF WIN64}
end;

function TMapiOptions.IsMapi64Bit: Boolean;
var
  DllBitness : Word;
begin
  Result := False; //Default to 32-bit

  //Find the default MAPI dll from the registry then read the bitness from
  //its header
  if ReadMAPIPathFromRegistry then
  begin
    DllBitness := ReadDLLBitness;
    Result := (DLLBitness = IA64) or (DLLBitness = AMD64);
  end;
end;

//Look for override settings
function TMapiOptions.ReadExchequerSettingsFromRegistry: Boolean;
const
  S_EXCHEQUER_KEY = 'SOFTWARE\Exchequer\Enterprise';
  S_NO_CACHE = 'NoMAPIOfflineCache';
  S_EX_MAPI_BITNESS = 'MAPIBitness';
  S_X64 = 'x64';
var
  Reg : TRegistry;
  BitnessString : string;
begin
  Result := False;

  //Default to false
  FNoCachedMode := False;
  FExchequerMAPIBitness := embNotSet;

  //Open registry read-only
  Reg := TRegistry.Create(KEY_READ);
  Try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly(S_EXCHEQUER_KEY) then
    begin
      //Check that values exist before trying to read them
      if Reg.ValueExists(S_NO_CACHE) then
        FNoCachedMode :=  Reg.ReadBool(S_NO_CACHE);
      if Reg.ValueExists(S_EX_MAPI_BITNESS) then
      begin
        BitnessString := Reg.ReadString(S_EX_MAPI_BITNESS);
        if LowerCase(BitnessString) = S_X64 then
          FExchequerMAPIBitness := emb64bit
        else
          FExchequerMAPIBitness := emb32bit;
      end;
    end;
  Finally
    Reg.Free;
  End;
end;

function TMapiOptions.ReadMAPIPathFromRegistry: Boolean;
const
  S_MAPI_KEY = 'SOFTWARE\Clients\Mail';
  S_DLL_PATH = 'DLLPathEx';
  S_DEFAULT = '(Default)';
  S_OUTLOOK = 'Microsoft Outlook';
var
  Reg : TRegistry;
  DefaultMAPI : string;
begin
  Result := False;
  FDllPath := '';
  DefaultMAPI := '';

  //Open registry read-only
  Reg := TRegistry.Create(KEY_READ);
  Try
    Reg.RootKey := HKEY_LOCAL_MACHINE;

    //Try to open MAPI key
    if Reg.OpenKeyReadOnly(S_MAPI_KEY) then
    Try
      //Read default value
      DefaultMAPI := Reg.ReadString(S_DEFAULT);
    Finally
      Reg.CloseKey;
    End;

    //If no default then assume Outlook
    if Trim(DefaultMAPI) = '' then
    begin
      DefaultMAPI := S_OUTLOOK;
    end;

    //Try to open MAPI provider key
    if Reg.OpenKeyReadOnly(S_MAPI_KEY + '\' + DefaultMAPI) then
    begin
      //Read full path and filename of MAPI dll.
      FDLLPath := Reg.ReadString(S_DLL_PATH);
      Result := Trim(FDLLPath) <> '';
    end;
  Finally
    Reg.Free;
  End;
end;

{Function to read bitness of a dll from its header. Adapted from
http://stackoverflow.com/questions/1001404/check-if-unmanaged-dll-is-32-bit-or-64-bit/1002672#1002672}
function TMapiOptions.ReadDLLBitness: Word;
const
  OFFSET_ADDRESS = 60; //Position in file of offset to PE header
var
  fs : TFileStream;
  Offset : longint;
  CPUType : Word;
begin
  //Open dll in stream
  fs := TFileStream.Create(FDllPath, fmOpenRead);
  Try
    //Find position of PE header
    fs.Seek(OFFSET_ADDRESS, soFromBeginning);
    fs.Read(Offset, SizeOf(Offset));
    //Move to beginning of PE header
    fs.Seek(Offset, soFromBeginning);
    //Move past first 4 bytes
    fs.Read(Offset, SizeOf(Offset));
    //Now read CPU type
    fs.Read(CPUType, SizeOf(CPUType));

    Result := CPUType;
  Finally
    fs.Free;
  End;
end;

//Property Getters
function TMapiOptions.GetNoCachedMode: Boolean;
begin
  Result := FNoCachedMode;
end;

function TMapiOptions.GetUse64BitMapi: Boolean;
begin
  Result := FUse64BitMapi;
end;

Initialization
  oMapiOptions := nil;
Finalization
  FreeAndNil(oMapiOptions);
end.

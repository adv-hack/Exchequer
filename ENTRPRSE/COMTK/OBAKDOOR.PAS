unit oBakDoor;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }
{$WARN UNIT_DEPRECATED OFF}
//Back door object for debugging purposes
interface

uses
  OleAuto, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF};

type
  TBackDoor = class(TAutoObject)
  private
    FToolkit : TObject;
    function GetFileNo(const WhichFile : WideString) : integer;
  protected
  public
    constructor CreateWithToolkit(Toolkit : TObject);
    destructor Destroy; override;
  Automated
    procedure CloseDoor;
    //Destroys the object

    function RecordCount(const WhichFile : WideString) : integer;
    //Returns no of records in WhichFile which should be filename only - no path

    function FileVersion(const WhichFile : WideString) : integer;
    //Returns File version of WhichFile which should be filename only - no path

    function BtrieveVersion(const What : Byte) : WideString;
    //Returns Btrieve version as Version.Revision + Type

    function Version : WideString;
    //Backdoor version

    function ToolkitPath : WideString;
    //Returns path of Com Toolkit dll

    function ToolkitDate : TDateTime;
    //File date & time of dll

    function ToolkitSize : integer;
    //Size of dll

    function UserNames : WideString;

    function EmailAddress(const UserName : WideString) : WideString;
    function UserFullName(const UserName : WideString) : WideString;
    function CheckSecurity(const UserName : WideString; Area : Integer; var SecurityResult : Integer) : Integer;
    function UserPassword(const UserName : WideString) : WideString;

  end;

var
  BackDoor : TBackDoor;


implementation

uses
  Btrvu2, GlobVar, SysUtils, MiscFunc, Windows, Classes, BtSupU1, VarConst,
  VarCnst3, oToolkit, DllMiscU, Security;

//------------------------------------------------------------------------------------
//            Local methods
//------------------------------------------------------------------------------------


constructor TBackDoor.CreateWithToolkit(Toolkit : TObject);
begin
  inherited Create;

  FToolkit := Toolkit;
end;

destructor TBackDoor.Destroy;
begin
  FToolkit := nil;
  inherited Destroy;
end;

function TBackDoor.GetFileNo(const WhichFile : WideString) : integer;
var
  FNo : integer;
  s : string;
  Status : integer;
begin
  Result := -1;
  if (FToolkit As TToolkit).Status = tkOpen then
  begin
    s := WhichFile;
    if Pos('.', s) = 0 then
      s := s + '.DAT';

    s := UpperCase(s);

    for Fno := 1 to TotFiles do
      if s = UpperCase(ExtractFilename(Filenames[FNo])) then
      begin
        Result := FNo;
        Break;
      end;
  end;
end;


//------------------------------------------------------------------------------------
//            Automation methods
//------------------------------------------------------------------------------------

procedure TBackDoor.CloseDoor;
begin
  Free;
end;

function TBackDoor.RecordCount(const WhichFile : WideString) : integer;
var
  Status : integer;
  FNo : integer;
begin
  Result := -1;
  if (FToolkit As TToolkit).Status = tkOpen then
  begin
    FNo := GetFileNo(WhichFile);
    if FNo > -1 then
    begin
      Status := Open_File(F[Fno], ExSyss.ExPath + Filenames[Fno], -2);
      if Status = 0 then
      begin
        Result := Used_Recs(F[FNo], FNo);
        Close_File(F[FNo]);
      end;
    end;
  end
  else
   Raise EInvalidMethod.Create ('The Toolkit must be opened before the RecordCount method is available');

end;

function TBackDoor.FileVersion(const WhichFile : WideString) : integer;
var
  Status : integer;
  FNo : integer;
  FileVer : integer;
begin
  Result := -1;
  if (FToolkit As TToolkit).Status = tkOpen then
  begin
    FNo := GetFileNo(WhichFile);
    if FNo > -1 then
    begin
      Status := Open_File(F[Fno], ExSyss.ExPath + Filenames[Fno], -2);
      if Status = 0 then
      begin
        FileVer := File_VerCID(F[FNo], FNo, nil);
        //Version is in Hex - 60 for v6, 50 for v5, etc.
        Result := FileVer div 16;
        Close_File(F[FNo]);
      end;
    end;
  end
  else
   Raise EInvalidMethod.Create ('The Toolkit must be opened before the FileVersion method is available');
end;

function TBackDoor.BtrieveVersion(const What : Byte) : WideString;
{ What = 1  : MKDB
       = 2  : Requester
       = 3  : Server
}

Var
  Ver        :  integer;
  Rel        :  integer;
  Typ        :  Char;


Begin
  Result := '';

  if GetBtrvVer(F[15],Ver,Rel,Typ,What) then
    Result := IntToStr(Ver) + '.' + IntToStr(Rel) + Typ;

end;

function TBackDoor.Version : WideString;
begin
  Result := '1.01';
end;

function TBackDoor.ToolkitPath : WideString;
var
  LengthModuleName : Integer;
  ModuleNameBuffer : Array[0..255] of char;
begin
  Result := '';
  FillChar(ModuleNameBuffer, SizeOf(ModuleNameBuffer), #0);

  LengthModuleName := GetModuleFileName(HInstance, ModuleNameBuffer, SizeOf(ModuleNameBuffer));
  if LengthModuleName > 0 then
     Result := WideString(ModuleNameBuffer);

end;

function TBackDoor.ToolkitDate : TDateTime;
var
  s : string;
begin
  Result := 0;
  s := ToolkitPath;
  if s <> '' then
    Result := FileDateToDateTime(FileAge(s));
end;

function TBackDoor.ToolkitSize : integer;
var
  F : TFileStream;
  s : string;
begin
  Result := 0;
  s := ToolkitPath;
  if s <> '' then
  begin
    F := TFileStream.Create(s, fmOpenRead or fmShareDenyNone);
    Try
     Try
       Result := F.Size;
     Finally
       F.Free;
     End;
    Except
    End;
  end;
end;

function TBackDoor.UserNames : WideString;
begin
  Result := Ex_UserNames;
end;

function TBackDoor.EmailAddress(const UserName : WideString) : WideString;
begin
  Result := Ex_UserProfileString(UserName, 0);
end;

function TBackDoor.UserFullName(const UserName : WideString) : WideString;
begin
  Result := Ex_UserProfileString(UserName, 1);
end;
         
function TBackDoor.CheckSecurity(const UserName : WideString; Area : Integer;
                                 var SecurityResult : Integer) : Integer;
var
  SecResult : SmallInt;
  PUserName : AnsiString;
begin
  PUserName := UserName;
  SecResult := 0;
  Result := Ex_CheckSecurity(PChar(PUserName), Area, SecResult);
  SecurityResult := SecResult;

end;

function TBackDoor.UserPassword(const UserName : WideString) : WideString;
var
  s : string;
begin
  s := UserName;
  Result := EX_GETPASSWORD(s);
end;









end.

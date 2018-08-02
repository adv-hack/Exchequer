{Interfaces from Enterprise to FaxNow! version 3.x}

unit FaxNow;

{ nfrewer440 10:20 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  {VarConst, GlobVar,} APIUtil, Windows;

{$I FaxVar.Pas}  

function  OpenFaxFileWithPath(DisplayError : boolean; Path : shortstring) : boolean; stdcall;
procedure CloseFaxFile;
function  GetUniqueRef : shortstring;
function InsertFaxDetails(Details : PFaxDetails) : longint;

implementation

uses
  {BtrvU2, }Dialogs, Sysutils{, FaxUtils, VarFPosU};

//-----------------------------------------------------------------------

function OpenFaxFileWithPath(DisplayError : boolean; Path : shortstring) : boolean;
begin
  Result := TRUE;
end;

//-----------------------------------------------------------------------

procedure CloseFaxFile;
begin
  {Do nothing}
end;

//-----------------------------------------------------------------------

function InsertFaxDetails(Details : PFaxDetails) : longint;
var
  DLLPath : ANSIString;
  hFaxNow : THandle;
  _FNSetDestNumber : procedure(sDestNum : PChar); stdcall;
{  _FNSetDestName : procedure(sDestName : PChar); stdcall;}
  sErrorMessage : string;
  {pFaxName, }pFaxNumber : array [0..255] of Char;
begin
  DLLPath := 'isfapi32.dll'; {remember - the faxNow stuff must be in the path}
  hFaxNow := LoadLibrary(PChar(DLLPath));
  sErrorMessage := '';
  try
    if (hFaxNow > HInstance_Error) then
      begin
        {Set Fax Number}
        _FNSetDestNumber := GetProcAddress(hFaxNow, 'FNSetDestNumber');
        if Assigned(_FNSetDestNumber) then
          begin
            StrPCopy(pFaxNumber, Details^.FaxNumber);
            _FNSetDestNumber(pFaxNumber);
          end
        else sErrorMessage := 'Function : ''FNSetDestNumber'' could not be found.';
      end
    else begin
      sErrorMessage := 'The FaxNow! file ISFAPI32.DLL or one of it''s associates could not be found.'
      + CHR(13) + CHR(13) + 'The FaxNow! Dir. needs to be pathed to.';
    end;{if}

    if sErrorMessage = '' then Result := 0
    else begin
      MsgBox(sErrorMessage,mtError,[mbOK],mbOK,'ISFAPI32.DLL');
      Result := 1;
    end;{if}

  finally
    { Unload library }
    FreeLibrary(hFaxNow);
  end;{try}
end; // InsertFaxDetails

//-----------------------------------------------------------------------

function GetUniqueRef : shortstring;
begin
  Result := '';
end; // GetUniqueRef

//-----------------------------------------------------------------------

end.


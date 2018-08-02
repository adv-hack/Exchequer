{Interfaces from Enterprise to FaxNow! version 5 / 2000}

unit FaxNow;

{ nfrewer440 10:20 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  {VarConst, GlobVar, NeilProc, }Windows, ComObj;

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
  FaxNow: Variant;
begin
  Result := 0;
  try
    FaxNow := CreateOleObject('FaxNow!.API');
  except
    ShowMessage('Could not create a FaxNow! API object');
    Result := 1;
    Exit;
  end;{try}

  try
    FaxNow.DestNumber := Details^.FaxNumber;
    FaxNow.SetRedrockDefault;
  except
    ShowMessage('An error occured communicating with the FaxNow! API object');
    Result := 1;
  end;{try}
end; // InsertFaxDetails

//-----------------------------------------------------------------------

function GetUniqueRef : shortstring;
begin
  Result := '';
end; // GetUniqueRef

//-----------------------------------------------------------------------

end.


unit TIRISLicenceViewerClass;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ViewLicenceForm;

function ShowLicence(ALicenceFile: pchar): integer; stdcall;
function EncryptLicenceFile(AnInputFile: pchar; AnOutputFile: pchar): integer; stdcall;
function DecryptLicenceFile(AnInputFile: pchar; AnOutputFile: pchar): integer; stdcall;
function ReadAcceptanceData(AnInputFile: pchar): pchar; stdcall;
function WriteAcceptanceData(AnOutputFile: pchar; Data: pchar): integer; stdcall;

implementation

uses
  Encryption;


function ShowLicence(ALicenceFile: pchar): integer;
begin
  result := -1;

//  ShowMessage(ALicenceFile);

  with TheLicenceForm do begin
    EncryptedLicenceFile := ALicenceFile;
    ShowModal;
    result := UserResponse;
    FreeTheForm;
  end;

end;

function EncryptLicenceFile(AnInputFile: pchar; AnOutputFile: pchar): integer; stdcall;
begin
  result := -1;
  if not CopyFile(AnInputFile, AnOutputFile, false) then
    ShowMessage('Unable to create output file: ' + AnOutputFile)
  else begin
    EncryptFile(AnOutputFile);
    result := 0;
  end;
end;

function DecryptLicenceFile(AnInputFile: pchar; AnOutputFile: pchar): integer; stdcall;
var
  MSI: TMemoryStream;
begin
  result := -1;

  MSI := DecryptFile(AnInputFile, true);
  if MSI <> nil then begin
    MSI.SaveToFile(AnOutputFile);
    MSI.Free;
    result := 0;
  end;
end;

function ReadAcceptanceData(AnInputFile: pchar): pchar; stdcall;
var
  MSO: TMemoryStream;
begin
  MSO := DecryptFile(AnInputFile, True);
  if MSO <> nil then begin
    result := AllocMem(MSO.Size);
    MSO.ReadBuffer(result^, MSO.Size);
    MSO.Free;
  end;
end;

function WriteAcceptanceData(AnOutputFile: pchar; Data: pchar): integer; stdcall;
var
  MSO: TMemoryStream;
begin
  MSO := TMemoryStream.Create;
  try
    MSO.Write(Data^, length(Data));
//      MSO.SaveToFile(AnOutputFile); // for debugging only
    EncryptFile(AnOutputFile, true, MSO);
  finally
    MSO.free;
  end;
end;

end.

{Interfaces from Enterprise to WinFax version 9 / 10}

unit WinFax;

interface

uses
  VarConst, GlobVar,Windows, ComObj, Forms;

  function OpenFaxFileWithPath(DisplayError : boolean; Path : shortstring) : boolean; stdcall;
  procedure CloseFaxFile;
  function GetUniqueRef : shortstring;
  function InsertFaxDetails(Details : PFaxDetails) : longint;


implementation

uses
  Dialogs, Sysutils;

var
  oWinFax : Variant;
  bFail : boolean;

//-----------------------------------------------------------------------

function OpenFaxFileWithPath(DisplayError : boolean; Path : shortstring) : boolean;
begin
  Result := TRUE;
  bFail := FALSE;
end;

//-----------------------------------------------------------------------

procedure CloseFaxFile;
begin
  sleep(100);{need this to allow winfax to run Without this there will be times when winfax will ask for the fax number to call}

  {Wait for an ID from win fax
  while(oWinFax.IsEntryIDReady(0)=0) do;
  id := oWinFax.GetEntryID(0);}

  if not bFail then oWinFax.Done;
end;

//-----------------------------------------------------------------------

function InsertFaxDetails(Details : PFaxDetails) : longint;
var
  iError : integer;
begin
  Result := 0;
  try
    oWinFax := CreateOleObject('WinFax.SDKSend');
  except
    ShowMessage('Could not create a WinFax.SDKSend API object');
    Result := 1;
    bFail := TRUE;
    Exit;
  end;

  oWinFax.LeaveRunning;
  if oWinFax.AddAttachmentFile('') = 1 then ShowMessage('Could not add file');
  if oWinFax.SetPrintFromApp(1) = 1 then ShowMessage('Failed Set print');
  oWinFax.SetTo(Details^.FaxRecipientName);

  {Set the fax details in winfax}
  if oWinFax.SetNumber(Details^.FaxNumber) = 1 then ShowMessage('Could not set number');
  if oWinFax.SetAreaCode('') = 1 then ShowMessage('Could set area code');

  if oWinFax.AddRecipient = 1 then ShowMessage('Could not add fax recipient');
  if oWinFax.SetPreviewFax(0) = 1 then ShowMessage('Could not set preview');
  if oWinFax.SetUseCover(0) = 1 then ShowMessage('Could not set use cover');
  if oWinFax.SetResolution(0) = 1 then ShowMessage('Could not set resolution');
  iError := oWinFax.Send(0);

  if iError <> 0 then ShowMessage(IntToStr(iError));

  { Wait for the fax program to get ready }
  while oWinFax.IsReadyToPrint = 0 do ;
end;

(*
  Result := 0;
  try
    oWinFax := CreateOleObject('WinFax.SDKSend');
  except
    ShowMessage('Could not create a WinFax.SDKSend API object');
    Result := 1;
    Exit;
  end;{try}

  try
    oWinFax.SetCountryCode('');
    oWinFax.SetAreaCode('');
    oWinFax.SetNumber(Details^.FaxNumber);
    oWinFax.SetTo('');
    oWinFax.AddRecipient;

    oWinFax.SetSubject('Fax from Exchequer Enterprise');
    oWinFax.SetPreviewFax(0);
    oWinFax.SetUseCover(0);

    oWinFax.SetPrintFromApp(1);
    oWinFax.Send(0);
  except
    ShowMessage('An error occured communicating with the WinFax.SDKSend API object');
    Result := 1;
  end;{try}
end;*)

(*var
  oWinFax : TCSDKSend;
begin
  Result := 0;
  try
    oWinFax := TCSDKSend.Create(application);
{    CreateOleObject('WinFax.SDKSend');}
  except
    ShowMessage('Could not create a WinFax.SDKSend API object');
    Result := 1;
    Exit;
  end;{try}

  try
    oWinFax.SetNumber(Details^.FaxNumber);
    oWinFax.SetPrintFromApp(1);
    oWinFax.Send(0);
  except
    ShowMessage('An error occured communicating with the WinFax.SDKSend API object');
    Result := 1;
  end;{try}
end; // InsertFaxDetails*)

//-----------------------------------------------------------------------

function GetUniqueRef : shortstring;
begin
  Result := '';
end; // GetUniqueRef

//-----------------------------------------------------------------------

end.


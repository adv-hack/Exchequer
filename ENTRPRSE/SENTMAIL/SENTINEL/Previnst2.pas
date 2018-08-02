unit Previnst2;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

(*	Unit to determine the app is running.  If ActivateIt is set to
		true, the unit will attempt to find the existing app and activate it.
		Add this line just AFTER the Appliction.Title line
		in the project source:

 		if AppIsRunning(True) then exit;

    - Version 1.0 - 11/17/96
		- For Delphi 2.0
		- This is a combination of various tips, trick and source
		  found here and there.
		- This VCL is freeware.
		- William Florac - FITCO
*)

interface

uses SysUtils, Windows, Forms;

function AppIsRunning(ActivateIt: boolean) : Boolean;

implementation

var
  hSem : THandle;

function AppIsRunning(ActivateIt: boolean) : Boolean;
var
  hWndMe : HWnd;
  AppTitle: string;
begin
	// default result
  Result := False;

  // Save the current title
  AppTitle := Application.Title;

  // Create a Semaphore in memory - If the semaphore exist,
  // an error code is generated.  To make it unique, we will use the
  // application title!
  hSem := CreateSemaphore(nil, 0, 1, pChar(AppTitle));

  //Now, check to see if the semaphore exists
  if ((hSem <> 0) AND (GetLastError() = ERROR_ALREADY_EXISTS)) then begin
  //  CloseHandle(hSem); // The semaphore handle will be close with the app anyway!
		//set result
    Result := True;
  end;

  if Result and ActivateIt then begin
	  //Change our name so we don't find us
    Application.Title :=  'zzzzzzz';

  	//Find other instance and bring it to the top
	  hWndMe := FindWindow(nil, pChar(AppTitle));
  	if (hWndMe <> 0) then begin
  		if IsIconic(hWndMe) then
	    	ShowWindow(hWndMe, SW_SHOWNORMAL)
  	  else
    	  SetForegroundWindow(hWndMe);
	  end;
  end;
end;

Initialization

Finalization

  CloseHandle(hSem);

end.

unit CheckSec;

//
// HM 25/08/04: Deliberate Error
//
This module links to an obselete security system and any system
using it should be upgraded to the correct Plug-In security system
//
// HM 25/08/04: Deliberate Error
//



{Add hook numbers here as they are used:

(1000 - 1099 : Bacs hooks)

1000 - Bacs1
1001 - Allied Irish Bank
1002 - Bank of Ireland
1003 - DBS Ideal
1004 - HSBC Hexagon
1005 - Bacstel
1006 - Natwest Autopay
1007 - Bacs no contra
1008 - LloydsTSB PcPay Csv
1009 - LloydsTSB PcPay Ascii
1010 - Coutts
1011 - Barclays BusinessMaster
1012 - Natwest PayAway
1013 - AbnAmro
1014 - Bank of Scotland Hobs

1100 - Contacts hook
1101 - Purchase Authorisation Hook

}

interface

Uses Classes, Dialogs, SysUtils, Windows;


// Check for a valid Hook Security & Release Code,
// Returns True if the Hook is allowed to be used
Function CheckHookSecurity (Const ModuleName : ShortString;
                            Const HookNo     : LongInt;
                            Const ModuleDesc : ShortString) : Boolean;


//------------------------------------

implementation

//------------------------------------

// Check for a valid Hook Security & Release Code,
// Returns True if the Hook is allowed to be used
Function CheckHookSecurity (Const ModuleName : ShortString; Const HookNo : LongInt; Const ModuleDesc : ShortString) : Boolean;
Var
  _CheckHookSecurity : Function (Const ModuleName : ShortString;
                                 Const HookNo     : LongInt;
                                 Const ModuleDesc : ShortString) : Boolean; StdCall;
  DLLHandle          : THandle;
Begin { CheckHookSecurity }
  Result := False;

  // Check not previously done - Load EntHookS.Dll and do check
  DLLHandle := LoadLibrary ('EntComp');
  // Check dLL loaded OK
  If (DLLHandle > HInstance_Error) Then Begin
    Try
      // Get hande to checking function
      _CheckHookSecurity := GetProcAddress(DLLHandle, 'CheckHookSecurity');
      If Assigned(_CheckHookSecurity) Then
        // Got handle of function OK - do security check
        Result := _CheckHookSecurity(ModuleName, HookNo, ModuleDesc)
      Else
        Raise Exception.Create ('HookSec 1002: Unable to find function in EntComp.Dll');
    Finally
      // All Done - unload DLL to free memory
      FreeLibrary (DLLHandle);
    End;
  End { If (_MyGSRHandle > HInstance_Error) }
  Else
    Raise Exception.Create ('HookSec 1001: Unable to load EntComp.Dll');
End; { CheckHookSecurity }

//------------------------------------

end.


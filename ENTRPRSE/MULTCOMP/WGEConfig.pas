unit WGEConfig;

interface

Uses Classes, Dialogs, Forms, IniFiles, SysUtils,
     {$IFDEF COMP} DLLWise, {$ENDIF}
     Windows;

{$IFDEF COMP}
// Customise the Pervasive.SQL Workgroup Engine configuration
function iaoConfigureWorkgroupEngine(var DLLParams: ParamRec): LongBool; StdCall; export;
{$ENDIF} // COMP

// Customise the Pervasive.SQL Workgroup Engine configuration
function ConfigureWorkgroupEngine : LongInt;

implementation

Uses Registry;

//=========================================================================

// Customise the Pervasive.SQL Workgroup Engine configuration
//
//   0  AOK
function ConfigureWorkgroupEngine : LongInt;
Var
  oReg     : TRegistry;
  sMultiSZ : ANSIString;
  Res      : Integer;
Begin // ConfigureWorkgroupEngine
  Result := 0;

  oReg := TRegistry.Create;
  Try
    oReg.Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS Or KEY_WRITE;
    oReg.RootKey := HKEY_LOCAL_MACHINE;

    If oReg.OpenKey('SOFTWARE\Pervasive Software\Microkernel Router\Version 8\Settings', False) Then
    Begin
      // Cache Engine - turn off
      If oReg.ValueExists('Use Cache Engine') Then oReg.WriteString('Use Cache Engine', 'no');
      oReg.CloseKey;
    End; // If oReg.OpenKey('SOFTWARE\Pervasive Software\Microkernel Router\Version 8\Settings', False)

    If oReg.OpenKey('SOFTWARE\Pervasive Software\MicroKernel Workgroup Engine\Version 8\Settings', False) Then
    Begin
      // File Version - v6 Format Files
      If oReg.ValueExists('File Version') Then oReg.WriteString('File Version', '0600');

      // Minimal States -
      If oReg.ValueExists('Minimal States') Then oReg.WriteString('Minimal States', 'NO');

      // Page Server Allow Client Cache - ?
      If oReg.ValueExists('Page Server Allow Client Cache') Then oReg.WriteString('Page Server Allow Client Cache', 'NO');

      // Page Server Allow Client Cache - ?
      If oReg.ValueExists('Preallocate') Then oReg.WriteString('Preallocate', 'YES');

      // Supported Protocols - remove IPX/SPX
      If oReg.ValueExists('Supported Protocols') Then
      Begin
        // As this value is a REG_MULTI_SZ we need to piss around a bit setting it as it is basically
        // a unicode string (2 byte) containing a series of strings separated with #0.
        sMultiSZ := 'TCP/IP'#0'NETBIOS'#0;
        Res := RegSetValueEx(oReg.CurrentKey,        // handle of key to set value for
                             'Supported Protocols',  // address of value to set
                             0,                      // reserved
                             REG_MULTI_SZ,           // flag for value type
                             PChar(sMultiSZ),        // address of value data
                             Length(sMultiSZ) + 1);  // size of value data
      End; // If oReg.ValueExists('Supported Protocols')

      oReg.CloseKey;
    End; // If oReg.OpenKey('SOFTWARE\Pervasive Software\MicroKernel Workgroup Engine\Version 8\Settings', False)
  Finally
    oReg.Free;
  End; // Try..Finally
End; // ConfigureWorkgroupEngine

//-------------------------------------------------------------------------

{$IFDEF COMP}
// Customise the Pervasive.SQL Workgroup Engine configuration
function iaoConfigureWorkgroupEngine(var DLLParams: ParamRec): LongBool;
Begin // iaoConfigureWorkgroupEngine
  ConfigureWorkgroupEngine;

  Result := False; // WISE Function - False=AOK, True=Error
End; // iaoConfigureWorkgroupEngine
{$ENDIF} // COMP

//-------------------------------------------------------------------------


end.

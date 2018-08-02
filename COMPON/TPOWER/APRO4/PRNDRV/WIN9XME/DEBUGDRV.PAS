{$X+}

uses
  SysUtils,
  WinProcs,
  WinTypes;

const
  PrnDrvName  = 'APFFILE.DRV';

var
  h           : THandle;
  PrnDrvPath  : array[0..255] of Char;
  i           : Integer;

begin
  GetSystemDirectory(PrnDrvPath, sizeof(PrnDrvPath));
  StrCat(PrnDrvPath,'\');
  StrCat(PrnDrvPath, PrnDrvName);

  i := MessageBox(0, 'This program is designed to assist'#10#13+
                     'in debugging a Delphi printer driver.'#10#13+
                     'Compile both this program and the printer'#10#13+
                     'driver with debug information and run with'#10#13+
                     'Turbo Debugger for Windows (TDW DebugDrv)',
                     'INFO', mb_OKCancel);
  if i = IDOK then begin
    h := LoadLibrary(PrnDrvPath);
    if (h > 32) then begin
      { found printer driver }
      MessageBox(0, 'Printer driver successfully loaded.'#10#13+
                    #10#13+
                    'After clicking <OK>, load the print driver and open'#10#13+
                    'a source code window for it (see doc file for details).'#10#13+
                    'Set a breakpoint where desired.  Press F9 to continue'#10#13+
                    'after setting breakpoint(s).',
                    'STATUS', mb_OK);
      asm
        Int 03;     { embedded breakpoint to break into debugger }
      end;
      MessageBox(0, 'Now switch to another window and load the program which'#10#13+
                    'uses the printer driver.  Click <OK> when done debugging.',
                    'WAITING', mb_OK);
      FreeLibrary(h);
    end else
      MessageBox(0, 'Couldn''t load printer driver', 'ERROR', mb_OK);
  end;
end.

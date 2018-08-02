@echo off

rem
rem Path to Customisation Image directory on S:
rem
Set CustImg=s:\master\build\entrprse\custom\
Set CustBase=x:\entrprse\custom\

echo CustImg=%CustImg%
echo CustBase=%CustBase%

If x%1x=x/TIDYx goto TidyUp

Cls
Echo Exchequer Enterprise Customisation Update Batch File
Echo ====================================================
Echo 
Echo   Image Directory:   %CustImg%
Echo 
Echo   Source Directory:  %CustBase%
Echo     COM:          :  %CustBase%Com
Echo 
Echo 
Echo Press Enter to contine or Ctrl-Break to abort...
Pause > Nul


rem
rem Check that destination directory exists!
rem
If Not Exist %CustImg%ENTCUSTM.HLP Goto NoCustImg

rem
rem Check that Customisation directory exists!
rem
If Not Exist %CustBase%README.TXT Goto NoCustDir

Cls
Echo 1 of 6 - Update Delphi COM Client Components
Echo ============================================
Echo 
Echo   Delphi 3 - %CustImg%Com\Delphi3\Compon
Copy %CustBase%Com\Delphi3\EntComD3.dpl %CustImg%Com\Delphi3\Compon
Copy %CustBase%Com\Delphi3\EntCustom.dcu %CustImg%Com\Delphi3\Compon
Copy %CustBase%Com\Delphi3\EnterpriseEvents.dcu %CustImg%Com\Delphi3\Compon
Copy %CustBase%Com\Delphi3\Enterprise_TLB.dcu %CustImg%Com\Delphi3\Compon
Echo   Delphi 4 - %CustImg%Com\Delphi4\Compon
Copy %CustBase%Com\Delphi4\EntComD4.bpl %CustImg%Com\Delphi4\Compon
Copy %CustBase%Com\Delphi4\EntCustom.dcu %CustImg%Com\Delphi4\Compon
Copy %CustBase%Com\Delphi4\EnterpriseEvents.dcu %CustImg%Com\Delphi4\Compon
Copy %CustBase%Com\Delphi4\Enterprise_TLB.dcu %CustImg%Com\Delphi4\Compon
Echo   Delphi 5 - %CustImg%Com\Delphi5\Compon
Copy %CustBase%Com\Delphi5\EntComD5.bpl %CustImg%Com\Delphi5\Compon
Copy %CustBase%Com\Delphi5\EntCustom.dcu %CustImg%Com\Delphi5\Compon
Copy %CustBase%Com\Delphi5\EnterpriseEvents.dcu %CustImg%Com\Delphi5\Compon
Copy %CustBase%Com\Delphi5\Enterprise_TLB.dcu %CustImg%Com\Delphi5\Compon
Echo   Type Library - %CustImg%Com
Copy %CustBase%Com\Delphi5\Enterprise_TLB.pas %CustImg%Com
Echo 
Echo Press Ctrl-Break to abort or Enter to contine...
Pause > Nul

Cls
Echo 2 of 6 - Update Delphi 5.0 Customisation Source
Echo ===============================================
Echo 
Echo   BaseFile - %CustImg%Delphi\BaseFile
Del %CustImg%Delphi\BaseFile\*.Dcu > Nul
Del %CustImg%Delphi\BaseFile\*.~?? > Nul
Copy %CustBase%Standard\ChainU.pas %CustImg%Delphi\BaseFile
Copy x:\entrprse\r&d\custabsu.pas %CustImg%Delphi\BaseFile
Copy x:\entrprse\r&d\CustMenu.pas %CustImg%Delphi\BaseFile
Copy x:\entrprse\r&d\CustWinu.pas %CustImg%Delphi\BaseFile
Copy %CustBase%Dummy\EntMenuu.pas %CustImg%Delphi\BaseFile
Copy %CustBase%Dummy\Handleru.pas %CustImg%Delphi\BaseFile
Copy %CustBase%Dummy\Labelu.pas %CustImg%Delphi\BaseFile
Copy x:\sbslib\win\win32\TCustAbs.pas %CustImg%Delphi\BaseFile
Copy x:\sbslib\win\win32\WinMapU.pas %CustImg%Delphi\BaseFile
Echo 
Echo Press Ctrl-Break to abort or Enter to contine...
Pause > Nul


Cls
Echo 3 of 6 - Documentation
Echo ======================
Echo 
Echo   On-Line Help - %CustImg%
Copy %CustBase%Help\EntCustm.Cnt %CustImg%EntCustm.Cnt
Copy %CustBase%Help\EntCustm.Hlp %CustImg%EntCustm.Hlp
Echo 
Echo Press Ctrl-Break to abort or Enter to contine...
Pause > Nul

:TidyUp

Cls
Echo 4 of 6 - Tidy Up Image Directories
Echo ==================================
Echo 
Echo   %CustImg%Com\Delphi3
Del %CustImg%Com\Delphi3\*.~* > Nul
Del %CustImg%Com\Delphi3\*.Dcu > Nul
Del %CustImg%Com\Delphi3\*.Dsk > Nul
Echo   %CustImg%Com\Delphi4
Del %CustImg%Com\Delphi4\*.~* > Nul
Del %CustImg%Com\Delphi4\*.Dcu > Nul
Del %CustImg%Com\Delphi4\*.Dsk > Nul
Echo   %CustImg%Com\Delphi5
Del %CustImg%Com\Delphi5\*.~* > Nul
Del %CustImg%Com\Delphi5\*.Dcu > Nul
Del %CustImg%Com\Delphi5\*.Dsk > Nul
Echo 
Echo Press Ctrl-Break to abort or Enter to contine...
Pause > Nul

Cls
Echo 4 of 6 - Tidy Up Image Directories
Echo ==================================
Echo 
Echo   %CustImg%Delphi\BaseFile
Del %CustImg%Delphi\BaseFile\*.~* > Nul
Del %CustImg%Delphi\BaseFile\*.Dcu > Nul
Echo   %CustImg%Delphi\HookInfo
Del %CustImg%Delphi\HookInfo\*.~* > Nul
Del %CustImg%Delphi\HookInfo\*.Dcu > Nul
Del %CustImg%Delphi\HookInfo\*.Dcu > Nul
Echo   %CustImg%Delphi\Label
Del %CustImg%Delphi\Label\*.~* > Nul
Del %CustImg%Delphi\Label\*.Dcu > Nul
Del %CustImg%Delphi\Label\*.Dsk > Nul
Echo   %CustImg%Delphi\Template
Del %CustImg%Delphi\Template\*.~* > Nul
Del %CustImg%Delphi\Template\*.Dcu > Nul
Del %CustImg%Delphi\Template\*.Dcu > Nul
Echo   %CustImg%Delphi\ToolMenu
Del %CustImg%Delphi\ToolMenu\*.~* > Nul
Del %CustImg%Delphi\ToolMenu\*.Dcu > Nul
Del %CustImg%Delphi\ToolMenu\*.Dcu > Nul
Echo   %CustImg%Delphi\VATHook
Del %CustImg%Delphi\VATHook\*.~* > Nul
Del %CustImg%Delphi\VATHook\*.Dcu > Nul
Del %CustImg%Delphi\VATHook\*.Dcu > Nul

Echo 
Echo Press Ctrl-Break to abort or Enter to contine...
Pause > Nul

Cls
Echo 6 of 6 - Tidy Up Image Directories
Echo ==================================
Echo 
Echo   %CustImg%UserDefH
Del %CustImg%UserDefH\*.~* > Nul
Del %CustImg%UserDefH\*.Dcu > Nul
Del %CustImg%UserDefH\ComClnt\*.~* > Nul
Del %CustImg%UserDefH\ComClnt\*.Dcu > Nul
Del %CustImg%UserDefH\ComClnt\*.Dsk > Nul
Del %CustImg%UserDefH\Common\*.~* > Nul
Del %CustImg%UserDefH\Common\*.Dcu > Nul
Del %CustImg%UserDefH\D5Dll\*.~* > Nul
Del %CustImg%UserDefH\D5Dll\*.Dcu > Nul
Del %CustImg%UserDefH\D5Dll\*.Dsk > Nul
Echo 
Echo Press Ctrl-Break to abort or Enter to contine...
Pause > Nul



Goto End

:NoCustImg
  Echo 
  Echo Customisation Image directory is missing: %CustImg%
  Echo 
  Goto End

:NoCustDir
  Echo 
  Echo Customisation directory is missing: %CustBase%
  Echo 
  Goto End

:End

Gnostice RaveRender - WYSIWYG, Renders for Rave Reports

(C) Copyright 2000-2003 by

Gnostice Information Technologies Private Limited
#44/4, Floor II
4th main, 15th cross
Malleswaram
Bangalore - 560 055
INDIA

E-Mail: info@gnostice.com
Web: http://www.gnostice.com

--------------------------------------------------------------------------------

CONTENTS
========

1. Installation
2. Re-Compiling/Re-Installing Registered Edition (using batch files)
3. Re-Compiling/Re-Installing Registered Edition (manually)
4. Integrating Help Files into the IDE
5. Un-Installation
6. GIF & RTF Support
7. Pricing, Ordering & Delivery


+------------------------------------------------------------------------------+
|                                                                              |
|                                 1. Installation                              |
|                                                                              |
+------------------------------------------------------------------------------+

Trial Edition
=============

IMPORTANT - before you proceed with this installation:
- Make sure you have Rave installed (www.nevrona.com).
- Uninstall any older versions of Gnostice RaveRender, present on your computer.

Please make sure you have the appropriate Setup program for your version of
Delphi or C++Builder. All trial downloads are available on this page:
http://www.gnostice.com/raverender/rrr_dwn.htm

After you have downloaded the executable file,

· Invoke the Setup program. The Setup program copies all files to a folder of
  your choice and automatically registers Gnostice RaveRender into the 
  development environment of Delphi or C++Builder.


Registered Edition
==================

IMPORTANT - before you proceed with this installation:
- Make sure you have Rave installed (www.nevrona.com).
- Uninstall any older versions of Gnostice RaveRender, present on your computer.

After you have downloaded the executable file,

· Invoke the Setup program. The Setup program copies all files to a folder of
  your choice and automatically registers Gnostice RaveRender into the development
  environment of Delphi or C++Builder.

Note:
· Setup compiles the packages while installing. If the components fail to install,
  please refer to section "Re-compiling/Re-Installing - Registered Edition".


+------------------------------------------------------------------------------+
|                                                                              |
|     2. Re-Compiling/Re-Installing Registered Edition (using batch files)     |
|                                                                              |
+------------------------------------------------------------------------------+

In most cases, the installation program will completely install 
Gnostice RaveRender without any intervention.  If, however, the 
Gnostice RaveRender components do not show up on the component palette, follow 
the steps below to reinstall the package.

You may follow the same steps below to re-compile the Gnostice RaveRender 
package if necessary.

<InstallDir> Refers to the folder to which Gnostice Raverender was installed.

+-----------------+
|    Delphi 4     |
+-----------------+

IMPORTANT - before you proceed with this installation:
- Make sure you have Rave installed (www.nevrona.com).
- Make sure the Setup program has copied all files to a folder of your choice
  and included the <InstallDir>\Lib\D4 path under Library Path of
  Environment Options. Default path is
  C:\Program Files\Gnostice\RaveRender1.2\Lib\D4
- Gnostice RaveRender provides many useful additional features that needs to be
  enabled explicitly. Please open file 'gtRPDefines.inc' under
  <InstallDir>\Source to enable them.

Compiling:
----------

· Close Delphi.
> Open the <InstallDir>\Source folder and run the file 'COMPILED4.bat'.
· Run Delphi. 
If the 'Gnostice Rave Render' tab is not present on the component palette, follow
the installation instructions below.

Installing:
-----------

· Run Delphi.
· Choose File|Close All on the main menu.
· Make sure the Library path is updated with <InstallDir>\Lib\D4
· Choose Tools|Environment Options... on the main menu.
· Select the Library tab.
· Check under Library Path under Directories.
  Example:
    If the original Library Path was "$(DELPHI)\Lib" and you installed
    Gnostice RaveRender to
      "C:\Program Files\Gnostice\RaveRender1.2"
    you should see the new Library Path as
      "$(DELPHI)\Lib;C:\Program Files\Gnostice\RaveRender1.2\Lib\D4"
· Choose Component|Install Packages...
· Click Add... and Open DCLgtRPRD40.bpl for Rave 4.x or DclgtRv5D40.bpl for
  Rave 5.x from <InstallDir>\Lib\D4
· Click OK.

A new tab named 'Gnostice Rave Render' should now appear on the component palette!


+-----------------+
|    Delphi 5     |
+-----------------+

IMPORTANT - before you proceed with this installation:
- Make sure you have Rave installed (www.nevrona.com).
- Make sure the Setup program has copied all files to a folder of your choice
  and included the <InstallDir>\Lib\D5 path under Library Path of
  Environment Options. Default path is
  C:\Program Files\Gnostice\RaveRender1.2\Lib\D5
- Gnostice RaveRender provides many useful additional features that needs to be
  enabled explicitly. Please open file 'gtRPDefines.inc' under
  <InstallDir>\Source to enable them.

Compiling:
----------

· Close Delphi.
> Open the <InstallDir>\Source folder and run the file 'COMPILED5.bat'.
· Run Delphi. 
If the 'Gnostice Rave Render' tab is not present on the component palette, follow
the installation instructions below.

Installing:
-----------

· Run Delphi.
· Choose File|Close All on the main menu.
· Make sure the Library path is updated with <InstallDir>\Lib\D5
· Choose Tools|Environment Options... on the main menu.
· Select the Library tab.
· Check under Library Path under Directories.
  Example:
    If the original Library Path was "$(DELPHI)\Lib" and you installed
    Gnostice RaveRender to 
      "C:\Program Files\Gnostice\RaveRender1.2"

    you should see the new Library Path as
      "$(DELPHI)\Lib;C:\Program Files\Gnostice\RaveRender1.2\Lib\D5"
· Choose Component|Install Packages...
· Click Add... and Open DCLgtRPRD50.bpl for Rave 4.x or DclgtRv5D50.bpl for
  Rave 5.x from <InstallDir>\Lib\D5
· Click OK.

A new tab named 'Gnostice Rave Render' should now appear on the component palette!

+-----------------+
|    Delphi 6     |
+-----------------+

IMPORTANT - before you proceed with this installation:
- Make sure you have Rave installed (www.nevrona.com).
- Make sure the Setup program has copied all files to a folder of your choice
  and included the <InstallDir>\Lib\D6 path under Library Path of
  Environment Options. Default path is
  C:\Program Files\Gnostice\RaveRender1.2\Lib\D6
- Gnostice RaveRender provides many useful additional features that needs to be
  enabled explicitly. Please open file 'gtRPDefines.inc' under
  <InstallDir>\Source to enable them.

Compiling:
----------

· Close Delphi.
> Open the <InstallDir>\Source folder and run the file 'COMPILED6.bat'.
· Run Delphi. 
If the 'Gnostice Rave Render' tab is not present on the component palette, follow
the installation instructions below.

Installing:
-----------

· Run Delphi.
· Choose File|Close All on the main menu.
· Make sure the Library path is updated with <InstallDir>\Lib\D6
· Choose Tools|Environment Options... on the main menu.
· Select the Library tab.
· Check under Library Path under Directories.
  Example:
    If the original Library Path was "$(DELPHI)\Lib" and you installed
    Gnostice RaveRender to
      "C:\Program Files\Gnostice\RaveRender1.2"
    you should see the new Library Path as
      "$(DELPHI)\Lib;C:\Program Files\Gnostice\RaveRender1.2\Lib\D6"
· Choose Component|Install Packages...
· Click Add... and Open DCLgtRPRD60.bpl for Rave 4.x or DclgtRv5D60.bpl for
  Rave 5.x from <InstallDir>\Lib\D6
· Click OK.

A new tab named 'Gnostice Rave Render' should now appear on the component palette!

+-----------------+
|    Delphi 7     |
+-----------------+

IMPORTANT - before you proceed with this installation:
- Make sure you have Rave 5.x BE (Borland Edition) installed (www.nevrona.com).
- Make sure the Setup program has copied all files to a folder of your choice
  and included the <InstallDir>\Lib\D7 path under Library Path of
  Environment Options. Default path is
  C:\Program Files\Gnostice\RaveRender1.2\Lib\D7
- Gnostice RaveRender provides many useful additional features that needs to be
  enabled explicitly. Please open file 'gtRPDefines.inc' under
  <InstallDir>\Source to enable them.

Compiling:
----------

· Close Delphi.
> Open the <InstallDir>\Source folder and run the file 'COMPILED7BE.bat' for
  Rave BE 5.x or 'COMPILED7.bat' for Rave BEX 5.x.
· Run Delphi. 
If the 'Gnostice Rave Render' tab is not present on the component palette, follow
the installation instructions below.

Installing:
-----------

· Run Delphi.
· Choose File|Close All on the main menu.
· Make sure the Library path is updated with <InstallDir>\Lib\D7
· Choose Tools|Environment Options... on the main menu.
· Select the Library tab.
· Check under Library Path under Directories.
  Example:
    If the original Library Path was "$(DELPHI)\Lib" and you installed
    Gnostice RaveRender to
      "C:\Program Files\Gnostice\RaveRender1.2"
    you should see the new Library Path as
      "$(DELPHI)\Lib;C:\Program Files\Gnostice\RaveRender1.2\Lib\D7"
· Choose Component|Install Packages...
· Click Add... and Open DCLgtRv5BED70.bpl for Rave BE 4.x or DclgtRv5D70.bpl for
  Rave BEX 5.x from <InstallDir>\Lib\D7
· Click OK.

A new tab named 'Gnostice Rave Render' should now appear on the component palette!

+-----------------+
|   C++Builder 4  |
+-----------------+

IMPORTANT - before you proceed with this installation:
- Make sure you have Rave installed (www.nevrona.com).
- Make sure the Setup program has copied all files to a folder of your choice
  and included the <InstallDir>\Lib\C4 path under Library Path of
  Environment Options. Default path is
  C:\Program Files\Gnostice\RaveRender1.2\Lib\C4
- Gnostice RaveRender provides many useful additional features that needs to be
  enabled explicitly. Please open file 'gtRPDefines.inc' under
  <InstallDir>\Source to enable them.

Compiling:
----------

· Close C++Builder.
> Open the <InstallDir>\Source folder and run the file 'COMPILEC4.bat'.
· Run C++Builder. 
If the 'Gnostice Rave Render' tab is not present on the component palette, follow
the installation instructions below.

Installing:
-----------

· Run C++Builder.
· Choose File|Close All on the main menu.
· Make sure the Library path is updated with <InstallDir>\Lib\C4
· Choose Tools|Environment Options... on the main menu.
· Select the Library tab.
· Check under Library Path under Directories.
  Example:
    If the original Library Path was "$(BCB)\Lib" and you installed
    Gnostice RaveRender to
      "C:\Program Files\Gnostice\RaveRender1.2"
    you should see the new Library Path as
      "$(BCB)\Lib;C:\Program Files\Gnostice\RaveRender1.2\Lib\C4"
· Choose Component|Install Packages...
· Click Add... and Open DCLgtRPRC40.bpl for Rave BE 4.x or DclgtRv5C40.bpl for
  Rave BEX 5.x from <InstallDir>\Lib\C4
· Click OK.

A new tab named 'Gnostice Rave Render' should now appear on the component palette!

+-----------------+
|   C++Builder 5  |
+-----------------+

IMPORTANT - before you proceed with this installation:
- Make sure you have Rave installed (www.nevrona.com).
- Make sure the Setup program has copied all files to a folder of your choice
  and included the <InstallDir>\Lib\C5 path under Library Path of
  Environment Options. Default path is
  C:\Program Files\Gnostice\RaveRender1.2\Lib\C5
- Gnostice RaveRender provides many useful additional features that needs to be
  enabled explicitly. Please open file 'gtRPDefines.inc' under
  <InstallDir>\Source to enable them.

Compiling:
----------

· Close C++Builder.
> Open the <InstallDir>\Source folder and run the file 'COMPILEC5.bat'.
· Run C++Builder. 
If the 'Gnostice Rave Render' tab is not present on the component palette, follow
the installation instructions below.

Installing:
-----------

· Run C++Builder.
· Choose File|Close All on the main menu.
· Make sure the Library path is updated with <InstallDir>\Lib\C5
· Choose Tools|Environment Options... on the main menu.
· Select the Library tab.
· Check under Library Path under Directories.
  Example:
    If the original Library Path was "$(BCB)\Lib" and you installed
    Gnostice RaveRender to
      "C:\Program Files\Gnostice\RaveRender1.2"
    you should see the new Library Path as
      "$(BCB)\Lib;C:\Program Files\Gnostice\RaveRender1.2\Lib\C5"
· Choose Component|Install Packages...
· Click Add... and Open DCLgtRPRC50.bpl for Rave BE 4.x or DclgtRv5C50.bpl for
  Rave BEX 5.x from <InstallDir>\Lib\C5
· Click OK.

A new tab named 'Gnostice Rave Render' should now appear on the component palette!


+------------------------------------------------------------------------------+
|                                                                              |
|          3. Re-Compiling/Re-Installing Registered Edition (manually)         |
|                                                                              |
+------------------------------------------------------------------------------+

In most cases, the installation program will completely install Gnostice 
RaveRender without any intervention. If, however, the Gnostice RaveRender 
components do not show up on the component palette, follow the steps below to 
reinstall the package.

You may follow the same steps below to re-compile the Gnostice RaveRender 
package if necessary.

<InstallDir> Refers to the folder to which Gnostice Raverender was installed.

+-----------------+
|    Delphi 4     |
+-----------------+

IMPORTANT - before you proceed with this installation:
· Make sure you have Rave installed (www.nevrona.com).
· Make sure the Setup program has copied all files to a folder of your choice
  and included the <InstallDir>\Lib\D4 path under Library Path of Environment
  Options. Default path is
  C:\Program Files\Gnostice\RaveRender1.2\Lib\D4
· Gnostice RaveRender provides many useful additional features that needs to be
  enabled explicitly. Please open file 'gtRPDefines.inc' under 
  <InstallDir>\Source to enable them.

Compiling:
----------

. Run Delphi. 
.  Choose File|Close All on the main menu.
.  Make sure the Library path is updated with <InstallDir>\Lib\D4
.  Choose Tools|Environment Options... on the main menu.
.  Select the Library tab.
.  Check under Library Path under Directories.
   Example:
   If the original Library Path was "$(DELPHI)\Lib" and you installed
   Gnostice RaveRender to
   "C:\Program Files\Gnostice\RaveRender1.2”
   you should see the new Library Path as
   "$(DELPHI)\Lib;C:\Program Files\Gnostice\RaveRender1.2\Lib\D4"
.  Choose File|Open... on the main menu.
.  Open the <InstallDir>\Source folder
.  Select gtRPRD40.dpk for Rave 4.x or gtRv5D40.dpk for Rave 5.x and click Open
.  Click Compile on the package editor
.  Copy gtRPRD40.bpl for Rave 4.x or gtRv5D40.bpl for Rave 5.x from 
   <InstallDir>\Lib\D4 to Windows\System (or WinNT\System32 if you are
   on WindowsNT/2000)
.  Choose File|Open... on the main menu.
.  Select DCLgtRPRD40.dpk for Rave 4.x or DclgtRv5D40.dpk for Rave 5.x
   and click Open
.  Click Compile on the package editor
.  Choose File|Close All on the main menu.

Installing:
-----------

.  Choose Component|Install Packages...
.  Click Add... and Open DCLgtRPRD40.bpl for Rave 4.x or DclgtRv5D40.bpl for
   Rave 5.x from <InstallDir>\Lib\D4
.  Click OK.

A new tab named 'Gnostice Rave Render' should now appear on the component palette!

+-----------------+
|    Delphi 5     |
+-----------------+

IMPORTANT - before you proceed with this installation:
· Make sure you have Rave installed (www.nevrona.com).
· Make sure the Setup program has copied all files to a folder of your choice
  and included the <InstallDir>\Lib\D5 path under Library Path of
  Environment Options. Default path is
  C:\Program Files\Gnostice\RaveRender1.2\Lib\D5
· Gnostice RaveRender provides many useful additional features that needs to
  be enabled explicitly. Please open file 'gtRPDefines.inc' under
  <InstallDir>\Source to enable them.

Compiling:
----------

.  Run Delphi. 
.  Choose File|Close All on the main menu.
.  Make sure the Library path is updated with <InstallDir>\Lib\D5
.  Choose Tools|Environment Options... on the main menu.
.  Select the Library tab.
.  Check under Library Path under Directories.
   Example:
   If the original Library Path was "$(DELPHI)\Lib" and you installed
   Gnostice RaveRender to
   "C:\Program Files\Gnostice\RaveRender1.2”
   you should see the new Library Path as
   "$(DELPHI)\Lib;C:\Program Files\Gnostice\RaveRender1.2\Lib\D5"
.  Choose File|Open... on the main menu.
.  Open the <InstallDir>\Source folder
.  Select gtRPRD50.dpk for Rave 4.x or gtRv5D50.dpk for Rave 5.x and click Open
.  Click Compile on the package editor
.  Copy gtRPRD50.bpl for Rave 4.x or gtRv5D50.bpl for Rave 5.x from
   <InstallDir>\Source to Windows\System (or WinNT\System32 if you are
   on WindowsNT/2000)
.  Choose File|Open... on the main menu.
.  Select DCLgtRPRD50.dpk for Rave 4.x or DclgtRv5D50.dpk for Rave 5.x
   and click Open
.  Click Compile on the package editor
.  Choose File|Close All on the main menu.

Installing:
-----------

.  Choose Component|Install Packages...
.  Click Add... and Open DCLgtRPRD50.bpl for Rave 4.x or DclgtRv5D50.bpl
   for Rave 5.x from <InstallDir>\Lib\D5
.  Click OK.

A new tab named 'Gnostice Rave Render' should now appear on the component palette!

+-----------------+
|    Delphi 6     |
+-----------------+

IMPORTANT - before you proceed with this installation:
· Make sure you have Rave installed (www.nevrona.com).
· Make sure the Setup program has copied all files to a folder of your choice
  and included the <InstallDir>\Lib\D6 path under Library Path of
  Environment Options. Default path is
  C:\Program Files\Gnostice\RaveRender1.2\Lib\D6
· Gnostice RaveRender provides many useful additional features that needs to
  be enabled explicitly. Please open file 'gtRPDefines.inc' under
  <InstallDir>\Source to enable them.

Compiling:
----------

.  Run Delphi. 
.  Choose File|Close All on the main menu.
.  Make sure the Library path is updated with <InstallDir>\Lib\D6
.  Choose Tools|Environment Options... on the main menu.
.  Select the Library tab.
.  Check under Library Path under Directories.
   Example:
   If the original Library Path was "$(DELPHI)\Lib" and you installed
   Gnostice RaveRender to
   "C:\Program Files\Gnostice\RaveRender1.2”
   you should see the new Library Path as
   "$(DELPHI)\Lib;C:\Program Files\Gnostice\RaveRender1.2\Lib\D6"
.  Choose File|Open... on the main menu.
.  Open the <InstallDir>\Source folder
.  Select gtRPRD60.dpk for Rave 4.x or gtRv5D60.dpk for Rave 5.x and click Open
.  Click Compile on the package editor
.  Copy gtRPRD60.bpl for Rave 4.x or gtRv5D60.bpl for Rave 5.x from
   <InstallDir>\Source to Windows\System (or WinNT\System32 if you are
   on WindowsNT/2000)
.  Choose File|Open... on the main menu.
.  Select DCLgtRPRD60.dpk for Rave 4.x or DclgtRv5D60.dpk for Rave 5.x
   and click Open
.  Click Compile on the package editor
.  Choose File|Close All on the main menu.

Installing:
-----------

.  Choose Component|Install Packages...
.  Click Add... and Open DCLgtRPRD60.bpl for Rave 4.x or DclgtRv5D60.bpl for 
   Rave 5.x from <InstallDir>\Lib\D6
.  Click OK.

A new tab named 'Gnostice Rave Render' should now appear on the component palette!

+-----------------+
|    Delphi 7     |
+-----------------+

IMPORTANT - before you proceed with this installation:
· Make sure you have Rave 5.x BE (Borland Edition) installed (www.nevrona.com).
· Make sure the Setup program has copied all files to a folder of your choice
  and included the <InstallDir>\Lib\D7 path under Library Path of
  Environment Options. Default path is
  C:\Program Files\Gnostice\RaveRender1.2\Lib\D7
· Gnostice RaveRender provides many useful additional features that needs to
  be enabled explicitly. Please open file 'gtRPDefines.inc' under
  <InstallDir>\Source to enable them.

Compiling:
----------

.  Run Delphi. 
.  Choose File|Close All on the main menu.
.  Make sure the Library path is updated with <InstallDir>\Lib\D7
.  Choose Tools|Environment Options... on the main menu.
.  Select the Library tab.
.  Check under Library Path under Directories.
   Example:
   If the original Library Path was "$(DELPHI)\Lib" and you installed
   Gnostice RaveRender to
   "C:\Program Files\Gnostice\RaveRender1.2”
   you should see the new Library Path as
   "$(DELPHI)\Lib;C:\Program Files\Gnostice\RaveRender1.2\Lib\D7"
.  Choose File|Open... on the main menu.
.  Open the <InstallDir>\Source folder
.  Select gtRv5BED70.dpk for Rave 4.x or gtRv5D70.dpk for Rave 5.x and click Open
.  Click Compile on the package editor
.  Copy gtRv5BED60.bpl for Rave 4.x or gtRv5D70.bpl for Rave 5.x from
   <InstallDir>\Source to Windows\System (or WinNT\System32 if you are
   on WindowsNT/2000)
.  Choose File|Open... on the main menu.
.  Select DCLgtRv5BED70.dpk for Rave 4.x or DclgtRv5D70.dpk for Rave 5.x
   and click Open
.  Click Compile on the package editor
.  Choose File|Close All on the main menu.


Installing:
-----------

.  Choose Component|Install Packages...
.  Click Add... and Open DCLgtRv5BED70.bpl for Rave 4.x or DclgtRv5D70.bpl
   for Rave 5.x from <InstallDir>\Lib\D7
.  Click OK.

A new tab named 'Gnostice Rave Render' should now appear on the component palette!

+-----------------+
|   C++Builder 4  |
+-----------------+

IMPORTANT - before you proceed with this installation:
· Make sure you have Rave installed (www.nevrona.com).
· Make sure the Setup program has copied all files to a folder of your choice
  and included the <InstallDir>\Lib\C4 path under Library Path of
  Environment Options. Default path is
  C:\Program Files\Gnostice\RaveRender1.2\Lib\C4
· Gnostice RaveRender provides many useful additional features that needs to
  be enabled explicitly. Please open file 'gtRPDefines.inc' under
  <InstallDir>\Source to enable them.

Compiling:
----------

.  Run C++ Builder. 
.  Choose File|Close All on the main menu.
.  Make sure the Library path is updated with <InstallDir>\Lib\C4
.  Choose Tools|Environment Options... on the main menu.
.  Select the Library tab.
.  Check under Library Path under Directories.
   Example:
   If the original Library Path was "$(BCB)\Lib" and you installed
   Gnostice RaveRender to
   "C:\Program Files\Gnostice\RaveRender1.2”
   you should see the new Library Path as
   "$(BCB)\Lib;C:\Program Files\Gnostice\RaveRender1.2\Lib\C4"
.  Choose File|Open... on the main menu.
.  Open the <InstallDir>\Source folder
.  Select gtRPRC40.bpk for 4.x or gtRv5C40.bpk for 5.x and click Open
.  Click Options and switch to the Directories/Conditionals tab
.  Under the BPI/LIB output enter '..\Lib\C4' and click OK
.  Click Compile on the package editor
.  Copy gtRPRC40.bpl for 4.x or gtRv5C40.bpl for 5.x from
   <InstallDir>\Lib\C4 to Windows\System (or WinNT\System32 if you are
   on WindowsNT/2000)
.  Choose File|Open... on the main menu.
.  Select DCLgtRPRC40.bpk for 4.x or DCLgtRv5C40.bpk for 5.x and click Open
.  Click Options and switch to the Directories/Conditionals tab
.  Under the BPI/LIB output enter '..\Lib\C4' and click OK
.  Click Compile on the package editor
.  Move all .hpp files from <InstallDir>\Source to <InstallDir>\Lib\C4 folder
.  Choose File|Close All on the main menu.

Installing:
-----------

.  Choose Component|Install Packages...
.  Click Add... and Open DCLgtRPRC40.bpl for 4.x or DCLgtRv5C40.bpk
   for 5.x from <InstallDir>\Lib\C4
.  Click OK.

A new tab named 'Gnostice Rave Render' should now appear on the component palette!

+-----------------+
|   C++Builder 5  |
+-----------------+

IMPORTANT - before you proceed with this installation:
· Make sure you have Rave installed (www.nevrona.com).
· Make sure the Setup program has copied all files to a folder of your choice
  and included the <InstallDir>\Lib\C5 path under Library Path of
  Environment Options. Default path is
  C:\Program Files\Gnostice\RaveRender1.2\Lib\C5
· Gnostice RaveRender provides many useful additional features that needs to be
  enabled explicitly. Please open file 'gtRPDefines.inc' under
  <InstallDir>\Source to enable them.

Compiling:
----------

.  Run C++ Builder. 
.  Choose File|Close All on the main menu.
.  Make sure the Library path is updated with <InstallDir>\Lib\C5
.  Choose Tools|Environment Options... on the main menu.
.  Select the Library tab.
.  Check under Library Path under Directories.
   Example:
   If the original Library Path was "$(BCB)\Lib" and you installed
   Gnostice RaveRender to
   "C:\Program Files\Gnostice\RaveRender1.2”
   you should see the new Library Path as
   "$(BCB)\Lib;C:\Program Files\Gnostice\RaveRender1.2\Lib\C5"
.  Choose File|Open... on the main menu.
.  Open the <InstallDir>\Source folder
.  Select gtRPRC50.bpk for 4.x or gtRv5C50.bpk for 5.x and click Open
.  Click Options and switch to the Directories/Conditionals tab
.  Under the BPI/LIB output enter '..\Lib\C5' and click OK
.  Click Compile on the package editor
.  Copy gtRPRC50.bpl for 4.x or gtRv5C50.bpl for 5.x from
   <InstallDir>\Lib\C5 to Windows\System (or WinNT\System32 if you are
   on WindowsNT/2000)
.  Choose File|Open... on the main menu.
.  Select DCLgtRPRC50.bpk for 4.x or DCLgtRv5C50.bpk for 5.x and click Open
.  Click Options and switch to the Directories/Conditionals tab
.  Under the BPI/LIB output enter '..\Lib\C5' and click OK
.  Click Compile on the package editor
.  Move all .hpp files from <InstallDir>\Source to <InstallDir>\Lib\C5 folder
.  Choose File|Close All on the main menu.

Installing:
-----------

.  Choose Component|Install Packages...
.  Click Add... and Open DCLgtRPRC50.bpl from <InstallDir>\Lib\C5
.  Click OK.

A new tab named 'Gnostice Rave Render' should now appear on the component palette!


+------------------------------------------------------------------------------+
|                                                                              |
|                   4. Integrating Help Files into the IDE                     |
|                                                                              |
+------------------------------------------------------------------------------+

Gnostice RaveRender component suite is shipped along with corresponding Help
files to guide users at every step. You can configure these help files to work
seamlessly with your Delphi/C++Builder IDE. By doing this, you can get context
sensitive help for any Gnostice RaveRender' property, method or event, just by
placing the cursor on the keyword and pressing F1. Please follow the step below to
configure the Help System:

+-----------------+
|    Delphi 4     |
+-----------------+

- Make sure the setup program has copied RaveRender.hlp and RaveRender.cnt
  files into your Delphi ..\Help directory.
- Edit the DELPHI4.CFG and remove any reference to RaveRender.hlp
- Edit the DELPHI4.CNT and add two lines (at the end of Include section):
  :Include RaveRender.cnt
  :Link RaveRender.hlp
- Delete any existing GID file in the Delphi Help directory ( ...\Help\delphi4.GID).


+----------------+
| Delphi 5,6 & 7 |
+----------------+

- Make sure the setup program has copied RaveRender.hlp and RaveRender.cnt
  files into your Delphi ..\Help directory.
- Start Delphi.
- Select Help|Customize option ( OpenHelp utility )
- Select the "Index" tab
- Select Edit|Add Files
- Add RaveRender.hlp from Delphi ..\Help directory
- Close OpenHelp utility
- When prompted - "Save changes to project?", click "Yes".
- Delete any existing GID file in the Delphi Help directory ( ...\Help\delphi5.GID,
   \Help\delphi6.GID or \Help\d7.GID).


+------------------+
| C++Builder 4 & 5 |
+------------------+

- Make sure the setup program has copied RaveRender.hlp and RaveRender.cnt
  files into your C++Builder ..\Help directory.
- Start C++Builder.
- Select Help|Customize option ( OpenHelp utility )
- Select the "Index" tab.
- Select Edit|Add Files.
- Add RaveRender.hlp from C++Builder ..\Help directory.
- Close OpenHelp utility.
- When prompted - "Save changes to project?", click "Yes".
- Delete any existing GID file in the C++Builder Help directory
  ( ...\Help\bcb4.GID or \Help\bcb5.GID).

+------------------------------------------------------------------------------+
|                                                                              |
|                               5. Un-Installation                             |
|                                                                              |
+------------------------------------------------------------------------------+

1. Go to Start|Settings|Control Panel
2. Open 'Add/Remove Programs'
3. Remove 'Gnostice Rave Render' from the list
4. Un-install will complete

Note:
  To remove Library path and Browsing path information
    a. Open Delphi/C++Builder
    b. Choose Tools|Environment Options... on the main menu
    c. Select the Library tab
    d. Remove Gnostice RaveRender path information from Library Path
    e. Remove Gnostice RaveRender path information from Browsing Path

  The Un-install program may not remove newly created files or folders. Check
  and manually delete the folder where you installed Gnostice RaveRender if
  required.


+------------------------------------------------------------------------------+
|                                                                              |
|                              6. GIF & RTF Support                            |
|                                                                              |
+------------------------------------------------------------------------------+

GIF Support
===========

Due to the patent issues involved in packaging products that support the GIF
image format we have not supplied the conversion libraries. Gnostice RaveRender
if ready to generate GIF and has been tested for the capability. All you need
to do is enable it.
Please be advised on the patent issues involved with it.

NOTE: When GIF support is not enabled and when GIF is the requested image format,
created images are in JPEG format. The file extension for the generated image
file is retained as .gif even though it is a JPEG image.

What you need to do to get GIF support:
[This is only possible in the Registered version of Gnostice RaveRender]

1. Install either of the two Free GIF libraries Gnostice RaveRender has been
   tested with -
     a. RxLib (with the RxGIF units) - http://www.rxlib.com
     b. Anders Melander's GIFImage unit - http://www.melander.dk

2. Open the file 'gtRPDefines.inc' under <InstallDir>\Source and remove
   either one of the dots (.) prefixed to
     {.$DEFINE GIFByRx}
   or
     {.$DEFINE GIFByAM}
   and rebuild the package.


RTF Support
===========

Gnostice RaveRender generates enhanced RTF that views correctly in MS Word 95
or higher. Please make sure you view the RTF files in MS Word or another RTF
viewer/editor that supports enhanced RTF(RTF version 1.5 or higher).


+------------------------------------------------------------------------------+
|                                                                              |
|                          7. Pricing, Ordering & Delivery                     |
|                                                                              |
+------------------------------------------------------------------------------+

Pricing
=======
                                                       Unit Price
                                                       ----------
. Trial Edition -                                      FREE!
   Which saves a maximum of 2 pages,
   is only for evaluation of the software.

. Registered Edition -
   You get FULL SOURCE code of the components.
   You may develop Desktop & Server based
   applications and deploy them on any number
   of computers, ROYALTY-FREE.
   You require one license per developer seat.

   Quantity Slab
     1                                                 US$ 119.
     2 ~ 10                                            US$ 105.
     11 ~ 100                                          US$ 100.

For larger volumes please mail sales@gnostice.com with your requirement.


Ordering
========

You can order Gnostice RaveRender online over the Internet at
http://www.gnostice.com/raverender/rrr_order.htm

If you do not wish to order over the Internet, you have the option of doing it
via phone, fax or postal mail. Please open the file "OrderForm.txt" for
details.


Delivery
========

Delivery is INSTANT for credit card transactions. For Bank transfers and other
modes of payment, delivery is upon receipt of full payment.

As soon as your order is passed you should receive an E-Mail giving you the
download link to the registered version Setup program. Please follow the steps
listed in the E-Mail to download the registered version.

If you are having problems downloading or installing Gnostice RaveRender please
mail support@gnostice.com quoting your Order Number and Name of person the
product was registered to.

----------------------------------------END-------------------------------------
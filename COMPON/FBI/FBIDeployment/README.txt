FBI Components Deployment
=========================

There is a bug in Visual Studio (2008 onwards) that prevents Type Library files
from being registered 1) at build time, and 2) at installation time.
This bug manifests itself in Vista, Windows 7 and Windows 8 (and there are some
unconfirmed reports on the Internet of it happening in XP)

Microsoft eventually published a workaround for this after claiming for some time
that they could not duplicate the problem.
However, the workaround doesn't appear to work either, and a modified version of
the workaround is presented here.



Taken from 
http://msdn.microsoft.com/en-us/library/kz0ke5xt(VS.90).aspx
with modifications in [brackets].


Installer cannot register a .tlb file
-------------------------------------

If you are using Visual Studio and Windows Vista [or Windows 7 or Windows 8] on 
your development computer, building a Setup project to register a .tlb file may 
result in the following error:

  "Unable to create registration information for file that is named 'filename'. 

Also, the .tlb file is not registered on the end user computer after you run the
.msi installer. 


To work around this issue, follow these steps:

1) Open a Visual Studio Command prompt.
Add the location of regcap.exe to your path. Typically, it is the 
  %PROGRAMFILES%\Microsoft Visual Studio 9.0\Common7\Tools\Deployment 
folder.

2) Run the following command.  The file InternetFiling.tlb should be in 
   X:\Release:
   
 regcap /I /O InternetFiling.reg InternetFiling.tlb 

[
 The resulting .reg file may be empty (or contain no values against the keys)
 Omitting the /I switch appears to fix this:
 
 regcap /O InternetFiling.reg InternetFiling.tlb 
]

3) In Visual Studio, click the Setup project in Solution Explorer. 

4) On the View menu, point to Editor, and then click Registry.

5) In Registry Editor, right-click Registry on the Target Machine, and then 
   click Import. 

6) In the Import Registry File dialog box, browse to the InternetFiling.reg file 
   and then click Open.
   [
   Note that when I tried this it complained that the .reg file was invalid.
   I had to add this as the first line of the .reg file...
   
       Windows Registry Editor Version 5.00

   and remove lines that contained this key...
   
       [HKEY_CURRENT_CONFIG]
   ]

7) In Solution Explorer, open the Detected Dependencies folder [and select the 
   entry for InternetFiling.tlb].

8) In the Properties window, change the Register property to vsdrfDoNotRegister.


TEmail: MAPI component

----------------------------------------------------------------------------------
Installation instructions :
----------------------------------------------------------------------------------

1. Copy compon\*.* to your component directory

2. 

   Delphi 1:

      Install email16.pas into your component library
      and rebuild the component library.

      Add email.kwf to your help system using helpinst.exe 
      and copy email.hlp to the Delphi \BIN directory.


   Delphi 2 and C++ Builder 1.0:

      Install email32.pas into your component library
      and rebuild the component library.

      Add email.kwf to your help system using helpinst.exe 
      and copy email.hlp to the respective \BIN directory.


   Delphi 3:

      Either install email32.pas into one of your 
      user-defined packages, or 
      open ("File | Open") email3.dpk and press Install

      Copy email.hlp and email.cnt to your Delphi 3 \HELP 
      directory, open DELPHI3.CFG in \HELP with a text editor 
      and add to the end of this file the text: 

           ; TEmail Help 
           ;------------ 
           :Link email.hlp

      Finally delete DELPHI3.GID.


   C++ Builder 3.0:

      Either install email32.pas into one of your 
      user-defined packages, or 
      open ("File | Open") email3.bpk and press "Install"

      Copy email.hlp and email.cnt to your C++ Builder
      \HELP folder, then Help | Customize... your online
      help to include this help file.


   Delphi 4:
    
      Either install email32.pas into one of your 
      user-defined packages, or 
      open ("File | Open") email4.dpk and press "Install"

      Copy email.hlp and email.cnt to your Delphi 4
      \HELP folder, then Help | Customize... your online
      help to include this help file.


-----------------------------------------------------------------------------------

From this moment on you can play with the standard demo application 
PMAPI.DPR in the ENHDEMO directory. The demo is source code 
compatible with every version of Delphi. 

Some of the provided demonstration projects are for C++ Builder 3.0 
only compatible and merely allow you to compile the 
existing Object Pascal projects in C++ Builder; they
do not use the C++ language itself.

A native C++ Builder demonstration, both for C++ Builder 1.0 and
C++ Builder 3.0, can be found in the BcbDemo folders.

A nice QuickMail demonstration can be found in qm32demo. You can
only compile this application with a 32 bit compiler, as a number 
of Win32 GUI enhancements are used here.

You may want to have a look at the FAXDEMO directory, which contains 
another demonstration of how to use the component with MAPI Fax 
support.

Alternatively you can play with the "TEmail" component itself.

See the online help for available properties, methods, constants
and types.

-------------------------------------------------------------------------------
"If you have added features to this component feel free to send them
and they will probably be incorporated into future releases to the
benefit of everybody."
-------------------------------------------------------------------------------

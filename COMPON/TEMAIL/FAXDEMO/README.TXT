DEMO - FAX BROADCAST A LETTER USING MS EXCHANGE (WIN 95)
========================================================

Author....: Michael Wilcox
Email.....: mwilcox@economatics.co.uk
Date......: 5 June 1997
Note......: This demo is FREEWARE, use at your own risk.

Requires..: Delphi v2
            MS Exchange v4 for Windows '95
            temail2.zip - by Danny Heijl
            Fax/Modem that works with MS Exchange.

----------------------------------------------------------------------------------
Introduction:
----------------------------------------------------------------------------------

I wish to thank Danny Heijl and Stefan Hoffmeister for making this demonstration
possible. The TEmail component simplifies the MAPI functions offered by MS Exchange.

This demo allows you to amend a database of address details and fax a letter to
people automatically using MS Exchange. It only shows the method used to create your
own fax page without using the standard cover pages in Exchange. It is recommended 
that you disable the cover sheet option within MS Exchange otherwise you will receive
two pages instead of one.

I found this method by accident when I attached a rich text file before faxing and
noticed that MS Word opened the file, printed, and then closed. The challenge was
to find a way of simulating this method with my own merged document.

I created a Fax Printer program (see c:\faxdemo\faxptr\faxpage1.dpr) which uses
ParamStr() to pass file details and options. It is important to create an
associated file type so that if you select LETTER.FP1 from Windows Explorer, the 
file is opened. It is possible to create other actions instead of Open (e.g.: Print
and Preview) so that if you right click on a selected file, a pop-up menu will
appear with these actions. (See c:\faxdemo\help\faxprinters.txt - on how to set up
associated file types)

HELP PLEASE!!!!!

- MS Exchange has been known to crash for some reason in module 'mapisp32', but 
  starting the machine again will allow MS Exchange to continue. If you find 
  out why MS Exchange crashes I would very interested in your comments.
- Is it possible to create an .AWD fax document from Delphi and send that instead?
- Can you suggest other methods of cheaply sending 2000 faxes in a day without using 
  a lot of PCs?
- Telnet programs - protocols/methods in sending/receiving data via TCP/IP (Winsock).
  I have created a component called TMJWcrt which displays text like a DOS screen 
  if you are interested search www.delphi32.com

Please email me if you can help!

I hope you find this demo interesting and wish you success with your project.

Thank you.


----------------------------------------------------------------------------------
Installation instructions:
----------------------------------------------------------------------------------

Note: The source code contains absolute path names. If you
      install to a different directory, the programs will
      not work correctly.

1. Copy all files to c:\faxdemo including directories.

2. Compile projects:  c:\faxdemo\faxletter.dpr
                      c:\faxdemo\faxptr\faxpage1.dpr

3. See c:\faxdemo\help\faxprinters.txt to finish installation.
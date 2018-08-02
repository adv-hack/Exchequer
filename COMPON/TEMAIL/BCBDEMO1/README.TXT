
Send mail demonstration projects for 

  Borland C++ Builder 1.0   (BCB10 folder)
  Borland C++ Builder 3.0   (BCB30 folder)


This was done by Gerard Patel (G.Patel@Wanadoo.fr).
I am in no way an email or MAPI expert, but I will try
to correct my errors if you send me your good advice.


These little projects do nothing more than
send an email through TEmail.

To run it, you need to install Temail in C++ Builder.
I used the path D:\COMPON\TEMAIL to install the
component. If you use another path, change the
project's options accordingly.

To work correctly in the IDE, you may want to
change the environment option "Break on exception"
to false (else the IDE will catch the component's
exceptions). If compiled without any debugging
information and incremental linker, the executable
file is 286 KB (BCB 1.0) and 312 KB (BCB 3.0).

This was tested with BCB 1.0 and BCB 3.0 on 
Microsoft NT 4.0 Workstation SP3 with
the basic Windows MAPI mail services.

To install these services, run Control Panel and goto
Add/Remove software --> Windows NT installation; choose 
Windows Messaging and install Microsoft Mail and 
Windows Messaging. 

Installation for Windows 95 follows a similar route.

After the installation has completed, you may run 
Windows Messaging from the Start menu and connect to
an existing mail directory.

The profile is linked with a user name. To add/change a
profile in Microsoft Mail, you have to use Control Panel,
"Mail or Mail/Fax". When you double-click this icon, you
will have a panel displaying the current profile's properties
(the one used by default in Windows Messaging). In this
panel, click the button "Display profiles" to configure
any profiles to suit your needs.

Warning: when using Microsoft Mail, the pending mail is 
NOT sent immediately. To have an immediate update of the 
mails, you can choose "Tools" in the Windows Messaging menu.

Installing the New Fax Client and driver.

1. Firstly, in your FaxSrv folder, rename your old Faxclnt.exe to Faxclnt.old.
2. Now copy the new faxClnt.exe into the FaxSrv folder.
3. If you are running any version of Windows NT, 2000 or Windows terminal sever 
   you will also need to copy a new version of Apfaxcnv.dll into the System32 
   directory off of that Windows installation directory (e.g. c:\WinTS\system32).

   The problem here is that the file is in permanent use by the operating system,
   so to copy a new version you will have to do the following :

   i)   Boot into DOS mode
   ii)  Rename Apfaxcnv.dll to Apfaxcnv.old.
   iii) Copy the new Apfaxcnv.dll into your System32 directory
   iv)  Reboot back into Windows.

4. This completes the installation
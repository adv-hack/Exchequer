Unit History;

Interface

Const
  EntRegVerNo = '016';

(**************************************************************************************************

EntWRepl.Exe Version History
============================

Build 016   20/07/2015
----------------------------------------------------------------------------------------------
 MH        Made window wider so the copyright fitted with the long company name


v7.0.14.015   29/05/2015
----------------------------------------------------------------------------------------------
 MH        Updated for copyright and company name changes


v7.0.5.014 11/07/2013
----------------------------------------------------------------------------------------------
 CS        Removed references to 'Iris'


v7.0.013   11/09/2012
----------------------------------------------------------------------------------------------
 MH        Updated sidebar and icon for new v7.0 graphics


v6.00.012  13/09/07
----------------------------------------------------------------------------------------------
 MH        Updated sidebar and icon for new v6.00 graphics


v5.71.011  05/10/06
----------------------------------------------------------------------------------------------
 MH        Changed to new IRIS Enterprise style Exchequer icon


v5.70.010  22/08/2005
----------------------------------------------------------------------------------------------
 MH        Rebranded for IRIS Enterprise Software / Exchequer

 MH        Modified to use History.Pas for version instead of having the version hard-coded
           within the text of the listbox

 MH        Modified to use standard copyright notice from StrUtil instead of having the version
           hard-coded within the text of the listbox


v5.61.009  02/02/05  HM   Released

v5.60.009  14/05/04  HM   Released

v5.52.009  18/11/03  HM   Released

v5.51.009  27/06/03  HM   Released

v4.31.003  17/08/00  HM   Released

b431.002             HM   Mods
                          ~~~~
                          Removed debugging message

v4.31.001  26/05/00  HM   Mods
                          ~~~~
                          Added command line parameter /LST:xxxx to allow alternate .LST
                          files from the network directory to be processed.
 
                          If processing default EntWRepl.Lst then it will also check for
                          ReplFile.Lst which is a straight text file listing other .LST 
                          files which can be processed.

                          These mods are aimed at allowing dealers to use the replication
                          engine to keep duplicate DLL's in their toolkit apps in sync
                          with those in the Enterprise directory.  Additionally it can be
                          used to replicate customisation out to local program files
                          systems automatically.

v4.31      25/04/00  HM   Released

           xx/10/99  HM   Converted to Delphi 5 

b430a.500  xx/09/99  HM   Converted to Delphi 4

------------------------------------------------------------------------------------------

v4.30b     11/10/99  MH   Applied new logo.

v4.30a     24/05/99  MH   Released

                     MH   Modified the replication to ask if the user wants to copy the 
                          files. This is intended for slow WAN setups where it is quicker
                          to run the upgrade locally than to copy the files off the network.   

v4.30      04/01/99  MH   Released

**************************************************************************************************)

Implementation

End.

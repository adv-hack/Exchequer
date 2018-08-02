unit History;

interface

Const
  ExtendedSearchName = 'Extended Search for Exchequer MS SQL Edition';
  ExtendedSearchVer = '007';

implementation

(*********************************************************************************************

VERSION HISTORY
===============

23/04/2015   v7.0.14.007
--------------------------------------------------------------------------------
  MH    ABSEXCH-16383 - Extended Search listing Closed Customers and Suppliers 


21/07/2014
--------------------------------------------------------------------------------
  CS    v7.0.11.006 - ABSEXCH-15281 - WOR transactions should also use Suppliers

27/11/2013
--------------------------------------------------------------------------------
  CS    MRD1.1.47 - Amendments for Consumers (copied from MRD branch)

12/07/2013
--------------------------------------------------------------------------------
  CS    ABSEXCH-14438 - updated name (removed 'Iris') and version number

27/02/2012
--------------------------------------------------------------------------------
  CS    Corrected the handling of the ESC key for Customers/Suppliers.

11/07/2012
--------------------------------------------------------------------------------------------
  CA    Modified The way the Admin screen is displayed and added extra fields to the screen
        ABSEXCH-12236


29/03/2011
--------------------------------------------------------------------------------------------
  MH    Modified Customer/Supplier popup to check if the search text is a valid Customer/Supplier and
        to automatically return that code without displaying the popup window.


28/03/2011
--------------------------------------------------------------------------------------------
  MH    Corrected typo on Search List form - SepErate to SepArate


24/03/2011   v6.5.001
--------------------------------------------------------------------------------------------
  MH    Took the original code from Cooper Parry and modified it to use Company Code and
        Connection String properties of the Customisation.

        Fixed the Stock Append Description Lines code so that it appended all description lines

        Added admin module.

        Limited to run for SQL Edition only.

        Added Exchequer style help about text.

        Modified to compile in standard customisation units.

        Applied coding standard to areas I have changed.

****************************************************************************)

end.



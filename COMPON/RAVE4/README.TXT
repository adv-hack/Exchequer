-----------------
Table of Contents
-----------------

- Converting from ReportPrinter 1.1/2.0/3.0 to Rave 4.0
- Installaing Rave 4.0

-----------------------------------------------------
Converting from ReportPrinter 1.1/2.0/3.0 to Rave 4.0
-----------------------------------------------------
In addition to the notes found in the installation section of the
printed documentation the following items may cause problems when
upgrading to Rave 4.0:

From ReportPrinter 1.1
----------------------

- All types and constants have been moved to the unit RPDEFINE.
  Normally Delphi will include all necessary units when using
  components, however, if you only recompile your project you will
  get a compiler error on the first encounter of somthing like pjCenter
  or BOXLINEALL.  This can be solved by loading all forms containing
  ReportPrinter components, making a small change on each form (moving
  a component to a different spot and then back will work), then
  rebuild your project.

- If you have created a unit named PRINT.PAS in your project this will
  cause conflicts with the Delphi unit named PRINT.DCU and will result
  in a compiler error for RPDEVICE.  Please rename the unit PRINT.PAS
  in your project to some other name to remove the compiler error.

From ReportPrinter Pro 2.0
--------------------------

- A new property, TBaseReport.FrameMode, changes the way that borders
  are drawn for the Rectangle and Ellipse command.  This will only be a
  problem if you have rectangles or ellipses with borders drawn with a
  pen thicker than 1 pixel where positioning is critical.  If these
  factors apply to some of your reports, simply adding the line,

    FrameMode := fmSplit;

  at the beginning of your report will change the border drawing to the
  RPPro 2.0 method.  See the documentation on FrameMode for more
  information.

From ReportPrinter Pro 3.0
--------------------------

- A new DataView type has been created called TRaveSQLDataView.  This is the
only dataview type supported by the new Rave report server.

- TRaveDataView has been moved from the RVData unit to the RVDirectDataView
unit.

------------------- Installing Rave 4.0 -------------------

Installing the Rave component suite is an easy process.

After running SETUP.EXE, which only creates directories,
copies files and creates icons, you will need to
perform additional installation steps in order to fully
integrate ReportPrinter into your IDE environment.

Delphi 4.0, 5.0 & 6.0; C++Builder 4.0 & 5.0
-------------------------------------------
Normally the installation program will completely install Rave
without any further intervention required.  If, however, the Rave
components do not show up in the Report component tab, follow the steps
below to reinstall the package.

Load up Delphi or C++Builder and select "Component | Install Packages..."
from the menu.

Click the "Add" button to open the "Add Design Package" dialog box.

Select the full drive and directory name path to the ReportPrinter
Pro design package (e.g. "C:\RAVE4\D6\RPRTDT60.DPL") and click the Open
button.

Make sure the "Default" checkbox is selected and click OK to accept
the changes.  You should have a new page on your component bar called
"Report" that contains the new Rave components.
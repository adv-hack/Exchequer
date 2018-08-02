library enRender;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  ShareMem,
  SysUtils,
  Classes,
  Forms,
  gtRPRender_HTML,    // Gnostice Rave Renderer for HTML files
  gtRPRender_Excel;   // Gnostice Rave Renderer for Excel

  // eDocEngine Print to XLSX
  //gtXLSEng, gtRvXportIntf, gtCstDocEng;


{$R *.res}

//-------------------------------------------------------------------------

// MH 07/01/2016 2016-R1: Re-instated old version of Excel conversion for backward
// compatibility - report printing in Enter1 no longer uses this
Function enrConvertEDFToExcel (Const EDFPath : ShortString;
                               Const XLSPath : ShortString) : Longint; StdCall; Export;
Var
  NDRStream  : TFileStream;
Begin // enrConvertEDFToExcel
  Result := 0;

  // dynamically create the rendering component
  With TgtRPRenderExcel.Create(Application) Do
    Try
      ShowSetupDialog := False;
      ShowProgress := False;

      // Create a memory stream and load the EDF file
      NDRStream := TFileStream.Create (EDFPath, fmOpenRead Or fmShareDenyNone);
      Try
        //NDRStream.LoadFromFile (EDFPath);

        // Pass the stream containing the EDF File into the rendering component
        PrintRender(NDRStream, XLSPath);
      Finally
        NDRStream.Free;
      End;
    Finally
      Free;
    End;
End; // enrConvertEDFToExcel

(***  Gnostice eDocEngine version - not used as of 07/01/2016 due to performance issues
Function enrConvertEDFToExcel (Const EDFPath : ShortString;
                               Const XLSPath : ShortString) : Longint; StdCall; Export;
Var
  gtExcelEngine : TgtExcelEngine;
  gtRaveXport : TgtRaveXport;
  NDRStream  : TFileStream;
begin
  Result := 0;

  // dynamically create the Excel Rendering Engine
  gtExcelEngine := TgtExcelEngine.Create(NIL);
  Try
    // Configure the Excel Engine options

    // Should automatically create new pages for text that goes off the page - doesn't appear to
    // actually do anything when converting from RAVE EDF file - probably only works if you are
    // writing directly the file through the eDocEngine components
    gtExcelEngine.AutoPaginate := True;

    // Doesn't appear to affect our output
    //gtExcelEngine.Preferences.PageMargins := True;

    // RAVE Reports are in MM, so just in case
    gtExcelEngine.MeasurementUnit := muMM;

    // Removes additional blank lines inserted to match the exported details up to the page size
    gtExcelEngine.Preferences.ContinuousMode := True;

    // Stop it automatically opening the Excel files
    gtExcelEngine.Preferences.OpenAfterCreate := False;

    // Render 1 page at a time instead of waiting until the end - lower memory usage, possibly lower performance
    gtExcelEngine.Preferences.ProcessAfterEachPage := True;

    // Turn off built in Setup dialog
    gtExcelEngine.Preferences.ShowSetupDialog := False;

    // Allegedly controls whether Excel cells are formatted according to the data being output
    // or hard-coded as text - TRUE may causing issues with numeric Account Codes, etc... losing
    // leading zero's, etc... but FALSE will cause numbers to be formatted as text
    gtExcelEngine.Preferences.AutoFormatCells := True;

    // Remove any blank lines
    gtExcelEngine.Formatting.RowSpacing := 0;
    // Remove any blank columns
    //gtExcelEngine.Formatting.ColumnSpacing := 0;

    // Set the Output filename - not sure if this is used or the parameter going into PrintRender below
    gtExcelEngine.FileName := XLSPath;

    // Create the RAVE Reading Inteface
    gtRaveXport := TgtRaveXport.Create(NIL, gtExcelEngine);

    // Create a memory stream to reaed the EDF file
    NDRStream := TFileStream.Create (EDFPath, fmOpenRead Or fmShareDenyNone);

    // Pass the stream containing the EDF File into the rendering component
    gtRaveXport.PrintRender(NDRStream, gtExcelEngine.FileName);
  Finally
    FreeAndNIL(NDRStream);
    FreeAndNIL(gtRaveXport);
    FreeAndNIL(gtExcelEngine);
  End; // Try..finally
end;
***)

//-------------------------------------------------------------------------

Function enrConvertEDFToHTML (Const EDFPath  : ShortString;
                              Const HTMLPath : ShortString) : Longint; StdCall; Export;
Var
  NDRStream  : TFileStream;
Begin // enrConvertEDFToHTML
  Result := 0;

  // dynamically create the rendering component
  With TgtRPRenderHTML.Create(Application) Do
    Try
      { CJS - 2013-07-08 - ABSEXCH-14438 - update branding and copyright }
      Author := 'Advanced Enterprise Software Ltd';
      Creator := 'Exchequer';
      IncludeImages := False;
      OutputStylesToCSSFile := False;
      SeparateFilePerPage := False;
      ShowSetupDialog := False;
      ShowProgress := False;

      // Create a memory stream and load the EDF file
      NDRStream := TFileStream.Create (EDFPath, fmOpenRead Or fmShareDenyNone);
      Try
        // Pass the stream containing the EDF File into the rendering component
        PrintRender(NDRStream, HTMLPath);
      Finally
        NDRStream.Free;
      End;
    Finally
      Free;
    End;
End; // enrConvertEDFToHTML

//-------------------------------------------------------------------------

Exports
  enrConvertEDFToExcel,
  enrConvertEDFToHTML;
end.

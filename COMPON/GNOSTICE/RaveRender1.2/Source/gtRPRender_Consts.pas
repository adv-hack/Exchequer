{***************************************************************************}
{                                                                           }
{  Gnostice RaveRender                                                     }
{                                                                           }
{  Copyright © 2000-2003 Gnostice Information Technologies Private Limited  }
{  http://www.gnostice.com                                                  }
{                                                                           }
{***************************************************************************}

{$I gtDefines.Inc}
{$I gtRPDefines.Inc}

unit gtRPRender_Consts;

interface

uses
	Forms, Graphics;

var
	cPixelsPerInch: Integer;									// multiply by

const

{$IFNDEF Rave407Up}
  FontDPI = 1248;
{$ENDIF}

{ ---- General constants ------------------------------------------------------}
	CR = #13;
	LF = #10;
	CRLF = CR + LF;
	cVersion = '1.2';

{$IFNDEF Registered}
	cMaxPages = 2;
{$ENDIF}

	cBackgroundColor = clWhite;

{ ---- PDF constants ----------------------------------------------------------}
	cLastReservedObjNo = 5;
	cRootObjNo = 1;
	cPagesTreeObjNo = 2;
	cInfoObjNo = 3;
	cProcSetObjNo = 4;
	cResourcesObjNo = 5;
	cInchToPoint = 72;										// multiply by
	// Font Flag bit values
	cPDFFontFixedPitch: array[Boolean] of integer = (0, 1);
	cPDFFontSerif: array[Boolean] of integer = (0, 2);
	cPDFFontSymbolic: array[Boolean] of integer = (0, 4);
	cPDFFontScript: array[Boolean] of integer = (0, 8);
	cPDFFontNonSymbolic: array[Boolean] of integer = (0, 32);
	cPDFFontItalic: array[Boolean] of integer = (0, 64);

{ ---- HTML constants ---------------------------------------------------------}
	cLinkForeColor = $00FF0000;						// BGR
	cLinkBackColor = $00FFFFFF;						// BGR
	cLinkHoverForeColor = $00FFFFFF;			// BGR
	cLinkHoverBackColor = $00FF0000;			// BGR
	cPageEndLineWidth = 2;

{ ---- RTF constants ----------------------------------------------------------}
	cPointToTwip = 20;										//  multiply by
	sMarginLeft = 0.5;										// in inches
	sMarginRight = 0.5;										// in inches
	sTopMargin = 0.5;											// in inches
	sBottomMargin = 0.5;									// in inches

{ ---- Excel constants --------------------------------------------------------}
	cExcel_BOF = $0009;
	cExcel_BIFF5 = $0800;
	cExcel_BIFF5_BOF = cExcel_BOF or cExcel_BIFF5;
	cExcel_DocType = $0010;
	cExcel_Rec_Size_BOF = 6;
	cExcel_EOF = $000A;
	cExcel_Rec_Size_EOF = 0;
	cExcel_DIM = $0200;
	cExcel_Rec_Size_DIM = 10;
	cExcel_Cell_Int = 2;
	cExcel_Rec_Size_Cell_Int = 11;
	cExcel_Cell_Double = 3;
	cExcel_Rec_Size_Cell_Double = 15;
	cExcel_Cell_Label = 4;
	cExcel_Rec_Size_Cell_Label = 7;

	cExcel_StdCharsPerCell = 8.43;

	cPAGEBREAK = #12;

resourcestring

	sCreatorName = 'Rave Reports';

{ ---- HTML strings -----------------------------------------------------------}

{ ---- Link text }
	sLinkTextFirst = 'Ù';									// Wingdings
	sLinkTextPrev = '×';									// Wingdings
	sLinkTextNext = 'Ø';									// Wingdings
	sLinkTextLast = 'Ú';									// Wingdings

{ ---- Link Hint (only appears in IE) }
	sTitleTextFirst = 'First';
	sTitleTextPrev = 'Previous';
	sTitleTextNext = 'Next';
	sTitleTextLast = 'Last';

{ ---- Render descriptions with extentions that appear in save dialog ---------}

	sHTMLDesc = 'HTML Document (*.htm)';
	sHTMLExt = 'htm';

	sPDFDesc = 'Adobe Acrobat Document (*.pdf)';
	sPDFExt = 'pdf';

	sRTFDesc = 'RTF Document (*.rtf)';
	sRTFExt = 'rtf';

	sExcelDesc = 'Excel Document (*.xls)';
	sExcelExt = 'xls';

	sTextDesc = 'Text Document (*.txt)';
	sTextExt = 'txt';

	sBMPDesc = 'Bitmap File (*.bmp)';
	sBMPExt = 'bmp';

	sJPEGDesc = 'JPEG Image File (*.jpg)';
	sJPEGExt = 'jpg';

	sGIFDesc = 'GIF Image File (*.gif)';
	sGIFExt = 'gif';

	sEMFDesc = 'Enhanced Metafile (*.emf)';
	sEMFExt = 'emf';

	sWMFDesc = 'Windows Metafile (*.wmf)';
	sWMFExt = 'wmf';

{ ---- Error Messages ---------------------------------------------------------}

	sCreateFileError = 'File could not be created!' + CRLF + CRLF +
		'Possible cause: It could be in use by some other application.' +
		CRLF + CRLF +
		'Solution: Re-try the failed operation' +
		' after closing the other application or' +
		' specify another file name.';

	sCreateCSSFileError = 'CSS File could not be created!' + CRLF + CRLF +
		'Possible cause: It could be in use by some other application.' +
		CRLF + CRLF +
		'Solution: Re-try the failed operation' +
		' after closing the other application or' +
		' specify another file name.';

	SEMailError = 'Report could not be E-Mailed!' + CRLF + CRLF +
		'Possible cause: Internet/Mail server Connection' +
		' could not be established.' + CRLF + CRLF +
		'Solution: Check Mail server connection properties' +
		' and your Internet connection.';

	sPagesError = 'Pages should contain page numbers and/or page ranges' + CRLF +
		'separated by commas. For example, 1,3,5-12';

	sUnsupportedPDFImageFormat =
		'The PDF export supports only JPEG and BMP image formats';

	sUnsupportedRTFImageFormat =
		'The RTF export supports only JPEG and BMP image formats';

	sUnsupportedBackgroundDisplayType =
		'The RTF export does not support Tile display type';

{------------------------------------------------------------------------------}

implementation

initialization
	cPixelsPerInch := Screen.PixelsPerInch;

end.


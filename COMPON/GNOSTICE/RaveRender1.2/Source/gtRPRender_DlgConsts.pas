{***************************************************************************}
{                                                                           }
{  Gnostice RaveRender                                                      }
{                                                                           }
{  Copyright © 2000-2003 Gnostice Information Technologies Private Limited  }
{  http://www.gnostice.com                                                  }
{                                                                           }
{***************************************************************************}

unit gtRPRender_DlgConsts;

interface

uses
	Graphics;

const

	CMinWidth = 20;

{------------------------------------------------------------------------------}

	EditColor: array[Boolean] of TColor = (clInactiveBorder, clWindow);

{------------------------------------------------------------------------------}

resourcestring

{----Main Dialog---------------------------------------------------------------}

	StsMainCaption = 'Main';
	SgbPageRangeCaption = 'Page Range';
	SrbtnAllCaption = 'All Pages';
	SrbtnPagesCaption = 'Pages:';
	SlblPageExampleCaption = 'Enter page numbers and/or page ranges separated' +
		' by commas. For example, 1,3,5-12';
	SchkOpenAfterGenerateCaption = 'Open After Generate';
	SchkEmailAfterGenerateCaption = 'E-Mail After Generate';
	SbtnOKCaption = '&OK';
	SbtnCancelCaption = '&Cancel';

	StsBackgroundCaption = 'Background';
	SlblBackgroundColorCaption = 'Background Color';
	SlblBackgroundImageCaption = 'Background Image';
	SbtnClearCaption = 'C&lear';
	SbtnSelectImageCaption = '&Select Image';
	SlblBackgroundDisplayTypeCaption = 'Background Display Type';

	SBGDispTypTile = 'Tile';
	SBGDispTypTopLeft = 'TopLeft';
	SBGDispTypTopCenter = 'TopCenter';
	SBGDispTypTopRight = 'TopRight';
	SBGDispTypCenterLeft = 'CenterLeft';
	SBGDispTypCenter = 'Center';
	SBGDispTypCenterRight = 'CenterRight';
	SBGDispTypBottomLeft = 'BottomLeft';
	SBGDispTypBottomCenter = 'BottomCenter';
	SBGDispTypBottomRight = 'BottomRight';

	SColorBoxHintPrefix = 'Click to Select ';

	SPFDevice = 'Device';
	SPF1bit = '1 bit';
	SPF4bit = '4 bit';
	SPF8bit = '8 bit';
	SPF15bit = '15 bit';
	SPF16bit = '16 bit';
	SPF24bit = '24 bit';
	SPF32bit = '32 bit';
	SPFCustom = 'Custom';

{----Document Dialog-----------------------------------------------------------}

	StsContentCaption = 'Content';
	SchkIncludeLinesCaption = 'Include Lines';
	SchkIncludeNonRectShapesCaption = 'Include Non-Rectangular Shapes';
	SchkIncludeImagesCaption = 'Include Images';
	SlblExportImageFormatCaption = 'Export Image Format';
	SlblJPEGQualityCaption = 'JPEG Quality';
	SlblImageDPICaption = 'Image DPI';
	SlblImagePixelFormatCaption = 'Image Pixel Format';
	SlblTitleCaption = 'Title';
	SlblSubjectCaption = 'Subject';
	SlblAuthorCaption = 'Author';
	SlblKeywordsCaption = 'Keywords';

	SImageFormatGIF = 'GIF';
	SImageFormatBMP = 'BMP';
	SImageFormatJPEG = 'JPEG';

{----HTML Dialog---------------------------------------------------------------}

	SHTMLDialogCaption = 'HTML Render Setup';
	StsNavigatorOptionsCaption = 'File && Navigator Options';
	SchkSeparateFilePerPageCaption	= 'Separate File Per Page';
	SchkShowNavigatorCaption = 'Show Navigator';
	SlblHoverForeColorCaption = 'Navigator Hover Foreground Color';
	SlblHoverBackColorCaption = 'Navigator Hover Background Color';
	SlblNavigatorBackgroundCaption = 'Navigator Background Color';
	SrbtnUseTextLinksCaption = 'Use Text Links';
	SrbtnUseGraphicLinksCaption	= 'Use Graphic Links';
	SbtnSetFontCaption = 'Font';
	SlblFirstCaption = 'First';
	SlblPreviousCaption	= 'Previous';
	SlblNextCaption	= 'Next';
	SlblLastCaption	= 'Last';
	SlblLinkCaptionsCaption	= 'Link Captions';
	SlblImageFolderCaption = 'Image Folder';
	SlblImageSourceCaption = 'Image Source';

	StsOptimizationCaption = 'File Locations && Optimization';
	SchkOptimizeforIECaption = 'Optimize for Internet Explorer';
	SchkPageEndLinesCaption = 'Page End Lines';
	SchkOutputStylesToCSSFileCaption = 'Output Styles to CSS File';
	SlblCSSFileCaption = 'CSS File';
	SlblDefaultFontCaption = 'Default Report Font';
	SpnlDefaultFontCaption = 'AaBbYyZz';

	SlblNavigatorTypeCaption = 'Navigator Type';

	SNTFixedToScreen = 'FixedToScreen';
	SNTFixedToPage = 'FixedToPage';


{----PDF Dialog----------------------------------------------------------------}

	SPDFDialogCaption = 'PDF Render Setup';
	StsCompressionCaption = 'Compression';
	SchkCompressDocumentCaption = 'Compress Document';
	SlblCompressionlevelCaption = 'Compression Level';
	SlblFontEncodingCaption = 'Font Encoding';

	SCompressionMethodFastest = 'Fastest';
	SCompressionMethodNormal = 'Normal';
	SCompressionMethodMaximum = 'Maximum';

{----RTF Dialog----------------------------------------------------------------}

	SRTFDialogCaption = 'RTF Render Setup';
	SchkGraphicDataInBinaryCaption = 'Graphic Data In Binary';

{----Excel Dialog--------------------------------------------------------------}

	SExcelDialogCaption = 'Excel Render Setup';
	StsFormattingCaption = 'Formatting';
	SchkSetCellAttributesCaption = 'Set Cell Attributes';
	SlblLineSpacingCaption = 'Line Spacing';

	SLineSpacingActual = 'Actual';
	SLineSpacingNoBlank = 'No Blank';
	SLineSpacingOneBlank = 'One Blank';
	SLineSpacingTwoBlank = 'Two Blank';
	SLineSpacingThreeBlank = 'Three Blank';
	SLineSpacingFourBlank = 'Four Blank';
	SLineSpacingFiveBlank = 'Five Blank';

{----Text Dialog---------------------------------------------------------------}

	STextDialogCaption = 'Text Render Setup';
	StsTextFormattingCaption = 'File && Formatting';
	SchkPageBreaksCaption = 'Page Breaks';

{----JPEG Dialog---------------------------------------------------------------}

	SJPEGDialogCaption = 'JPEG Render Setup';
	StsQualityCaption = 'Quality && Scaling';
	SchkGrayScaleCaption = 'GrayScale';
	SchkProgressiveEncodingCaption = 'Progressive Encoding';
	SlblQualityCaption = 'Quality';
	SlblRangeCaption = '(1 = Max.Compression, 100 = Best Quality)';
	SlblScaleXCaption = 'Scale X';
	SlblScaleYCaption = 'Scale Y';

{----BMP Dialog----------------------------------------------------------------}

	SBMPDialogCaption = 'BMP Render Setup';
	SchkMonochromeCaption = 'Monochrome';

{----GIF Dialog----------------------------------------------------------------}

	SGIFDialogCaption = 'GIF Render Setup';

{----Metafile Dialog-----------------------------------------------------------}

	SMetaFileDialogCaption = 'Metafile Render Setup';
	StsMetafileScalingCaption = 'Scaling';

{----Progress Dialog-----------------------------------------------------------}

	SProgressDialogCaption = 'Generating Page...';
	SlblCurrentPageCaption = '%d of %d';
{------------------------------------------------------------------------------}

implementation

end.

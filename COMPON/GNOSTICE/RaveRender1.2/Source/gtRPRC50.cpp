//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("gtRPRC50.res");
USEPACKAGE("vcl50.bpi");
USEUNIT("gtRPRender_BMP.pas");
USEUNIT("gtRPRender_Consts.pas");
USEUNIT("gtRPRender_DlgConsts.pas");
USEUNIT("gtRPRender_Document.pas");
USEUNIT("gtRPRender_EMF.pas");
USEUNIT("gtRPRender_Excel.pas");
USEUNIT("gtRPRender_GIF.pas");
USEUNIT("gtRPRender_Graphic.pas");
USEUNIT("gtRPRender_HTML.pas");
USEUNIT("gtRPRender_JPEG.pas");
USEUNIT("gtRPRender_Main.pas");
USEUNIT("gtRPRender_PDF.pas");
USEUNIT("gtRPRender_RTF.pas");
USEUNIT("gtRPRender_Text.pas");
USEUNIT("gtRPRender_Utils.pas");
USEUNIT("gtRPRender_WMF.pas");
USEUNIT("gtRPRRoutines.pas");
USEFORMNS("gtRPRender_MainDlg.pas", Gtrprender_maindlg, gtRPRenderMainDlg);
USEFORMNS("gtRPRender_DocumentDlg.pas", Gtrprender_documentdlg, gtRPRenderDocumentDlg);
USEFORMNS("gtRPRender_TextDlg.pas", Gtrprender_textdlg, gtRPRenderTextDlg);
USEFORMNS("gtRPRender_ExcelDlg.pas", Gtrprender_exceldlg, gtRPRenderExcelDlg);
USEFORMNS("gtRPRender_GIFDlg.pas", Gtrprender_gifdlg, gtRPRenderGIFDlg);
USEFORMNS("gtRPRender_HTMLDlg.pas", Gtrprender_htmldlg, gtRPRenderHTMLDlg);
USEFORMNS("gtRPRender_JPEGDlg.pas", Gtrprender_jpegdlg, gtRPRenderJPEGDlg);
USEFORMNS("gtRPRender_MetafileDlg.pas", Gtrprender_metafiledlg, gtRPRenderMetafileDlg);
USEFORMNS("gtRPRender_PDFDlg.pas", Gtrprender_pdfdlg, gtRPRenderPDFDlg);
USEFORMNS("gtRPRender_ProgressDlg.pas", Gtrprender_progressdlg, gtRPRenderProgressDlg);
USEFORMNS("gtRPRender_RTFDlg.pas", Gtrprender_rtfdlg, gtRPRenderRTFDlg);
USEFORMNS("gtRPRender_BMPDlg.pas", Gtrprender_bmpdlg, gtRPRenderBMPDlg);
USEPACKAGE("RPRV40D5.bpi");
USEPACKAGE("VCLX50.bpi");
USEPACKAGE("VCLJPG50.bpi");
USEPACKAGE("RPRT40D5.bpi");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("gtRPRC40.res");
USEPACKAGE("vcl40.bpi");
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
USEFORMNS("gtRPRender_GIFDlg.pas", Gtrprender_gifdlg, gtRPRenderGIFDlg);
USEFORMNS("gtRPRender_ExcelDlg.pas", Gtrprender_exceldlg, gtRPRenderExcelDlg);
USEFORMNS("gtRPRender_BMPDlg.pas", Gtrprender_bmpdlg, gtRPRenderBMPDlg);
USEFORMNS("gtRPRender_HTMLDlg.pas", Gtrprender_htmldlg, gtRPRenderHTMLDlg);
USEFORMNS("gtRPRender_JPEGDlg.pas", Gtrprender_jpegdlg, gtRPRenderJPEGDlg);
USEFORMNS("gtRPRender_MetafileDlg.pas", Gtrprender_metafiledlg, gtRPRenderMetafileDlg);
USEFORMNS("gtRPRender_PDFDlg.pas", Gtrprender_pdfdlg, gtRPRenderPDFDlg);
USEFORMNS("gtRPRender_ProgressDlg.pas", Gtrprender_progressdlg, gtRPRenderProgressDlg);
USEFORMNS("gtRPRender_RTFDlg.pas", Gtrprender_rtfdlg, gtRPRenderRTFDlg);
USEFORMNS("gtRPRender_TextDlg.pas", Gtrprender_textdlg, gtRPRenderTextDlg);
USEPACKAGE("RPRV40D4.bpi");
USEPACKAGE("VCLX40.bpi");
USEPACKAGE("VCLJPG40.bpi");
USEPACKAGE("VCLDB40.bpi");
USEPACKAGE("bcbsmp40.bpi");
USEPACKAGE("RPRT40D4.bpi");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
//   Package source.
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
  return 1;
}
//---------------------------------------------------------------------------

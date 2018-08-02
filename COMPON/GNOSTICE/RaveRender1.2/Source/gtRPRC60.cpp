//---------------------------------------------------------------------------

#include <basepch.h>
#pragma hdrstop
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
 
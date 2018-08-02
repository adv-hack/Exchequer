//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("RVPkgCB5.res");
USEUNIT("RVStyle.pas");
USEUNIT("DLines.pas");
USEUNIT("PtblRV.pas");
USEUNIT("RVScroll.pas");
USEUNIT("RichView.pas");
USEUNIT("RVEdit.pas");
USEUNIT("CRVPP.pas");
USEUNIT("RVPP.pas");
USEUNIT("RVSEdit.pas");
USEUNIT("CRVData.pas");
USEUNIT("CRVFData.pas");
USEUNIT("PtRVData.pas");
USEUNIT("RVBack.pas");
USEUNIT("RVERVData.pas");
USEUNIT("RVFMisc.pas");
USEUNIT("RVFuncs.pas");
USEUNIT("RVItem.pas");
USEUNIT("RVReg.pas");
USERES("RVReg.dcr");
USEUNIT("RVRVData.pas");
USEUNIT("RVUndo.pas");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("vcljpg50.bpi");
USEUNIT("RVUni.pas");
USEUNIT("RVTable.pas");
USEUNIT("RVCodePages.pas");
USEUNIT("RVDataList.pas");
USEUNIT("RVClasses.pas");
USEUNIT("RVTInplace.pas");
USEUNIT("RVCtrlData.pas");
USEUNIT("RVStr.pas");
USEUNIT("RVRTFErr.pas");
USEUNIT("RVRTFProps.pas");
USEUNIT("RVRTF.pas");
USEUNIT("RVMapWht.pas");
USEUNIT("CtrlImg.pas");
USEUNIT("RVMisc.pas");
USEUNIT("RVReport.pas");
USEUNIT("RVSer.pas");
USEFORMNS("RVDsgn.pas", Rvdsgn, frmRVDesign);
USEUNIT("RVOfficeCnv.pas");
USEUNIT("RVMarker.pas");
USEUNIT("RVXPTheme.pas");
USEUNIT("RVResize.pas");
USEUNIT("RVDragDrop.pas");
USEUNIT("RVLinear.pas");
USEUNIT("RVGetText.pas");
USEUNIT("RVThread.pas");
USEUNIT("RVWordPaint.pas");
USEUNIT("RVAnimate.pas");
USEUNIT("RVGetTextW.pas");
USEUNIT("RVPopup.pas");
USEUNIT("RVSeqItem.pas");
USEUNIT("RVSubData.pas");
USEUNIT("RVLabelItem.pas");
USEUNIT("RVNote.pas");
USEUNIT("RVDocParams.pas");
USEUNIT("RVWinGrIn.pas");
USEUNIT("RVGrIn.pas");
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

//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("RVPkgCB3.res");
USEPACKAGE("vcl35.bpi");
USEUNIT("RVXPTheme.pas");
USEUNIT("CRVData.pas");
USEUNIT("CRVFData.pas");
USEUNIT("CRVPP.pas");
USEUNIT("CtrlImg.pas");
USEUNIT("DBRV.pas");
USERES("DBRV.dcr");
USEUNIT("DLines.pas");
USEUNIT("PtblRV.pas");
USEUNIT("PtRVData.pas");
USEUNIT("RichView.pas");
USEUNIT("RVAnimate.pas");
USEUNIT("RVBack.pas");
USEUNIT("RVClasses.pas");
USEUNIT("RVCodePages.pas");
USEUNIT("RVCtrlData.pas");
USEUNIT("RVDataList.pas");
USEUNIT("RVDocParams.pas");
USEUNIT("RVDragDrop.pas");
USEFORMNS("RVDsgn.pas", Rvdsgn, frmRVDesign);
USEUNIT("RVEdit.pas");
USEUNIT("RVERVData.pas");
USEUNIT("RVFMisc.pas");
USEUNIT("RVFuncs.pas");
USEUNIT("RVGetText.pas");
USEUNIT("RVGetTextW.pas");
USEUNIT("RVItem.pas");
USEUNIT("RVJvGifAnimate.pas");
USEUNIT("RVLabelItem.pas");
USEUNIT("RVLinear.pas");
USEUNIT("RVMapWht.pas");
USEUNIT("RVMarker.pas");
USEUNIT("RVMisc.pas");
USEUNIT("RVNote.pas");
USEUNIT("RVOfficeCnv.pas");
USEUNIT("RVPopup.pas");
USEUNIT("RVPP.pas");
USEUNIT("RVReg.pas");
USERES("RVReg.dcr");
USEUNIT("RVReport.pas");
USEUNIT("RVResize.pas");
USEUNIT("RVRTF.pas");
USEUNIT("RVRTFErr.pas");
USEUNIT("RVRTFProps.pas");
USEUNIT("RVRTFReg.pas");
USERES("RVRTFReg.dcr");
USEUNIT("RVRVData.pas");
USEUNIT("RVScroll.pas");
USEUNIT("RVSEdit.pas");
USEUNIT("RVSeqItem.pas");
USEUNIT("RVSer.pas");
USEUNIT("RVStr.pas");
USEUNIT("RVStyle.pas");
USEUNIT("RVSubData.pas");
USEUNIT("RVTable.pas");
USEUNIT("RVThread.pas");
USEUNIT("RVTInplace.pas");
USEUNIT("RVUndo.pas");
USEUNIT("RVUni.pas");
USEUNIT("RVWordPaint.pas");
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

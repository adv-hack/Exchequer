program ENTRW;

{$ALIGN 1}

{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  Forms,
  DDFuncs in '..\..\Common\DDFuncs.pas',
  Btrvu2 in '..\..\..\..\SBSLIB\WIN\WIN32\BTRVU2.PAS',
  GlobVar in '..\..\..\R&D\GLOBVAR.PAS',
  RptEngDll in '..\..\Common\RptEngDll.pas',
  RWOPENF in '..\..\Common\RWOPENF.PAS',
  RptTree in '..\RptTree.pas' {frmReportTree},
  frmVRWReportPropertiesU in '..\frmVRWReportPropertiesU.pas' {frmVRWReportProperties},
  RptTreeEdt in '..\RptTreeEdt.pas' {frmHeaderEdit},
  TreeSecurity in '..\TreeSecurity.pas' {frmSecurity},
  ConvertOldRepF in '..\ConvertOldRepF.pas' {frmConvertReport},
  VARFPOSU in '..\..\Common\VARFPOSU.PAS',
  History in '..\..\Common\History.pas',
  RepTreeIF in '..\..\Common\RepTreeIF.pas',
  RepEngIF in '..\..\Common\RepEngIF.pas',
  VarConst in '..\..\..\R&D\Varconst.pas',
  EntLicence in '..\..\..\DRILLDN\EntLicence.pas',
  FindReportF in '..\FindReportF.pas' {frmFindReport},
  VRWReportDataIF in '..\..\Common\VRWReportDataIF.pas',
  frmRptTreePropertiesU in '..\frmRptTreePropertiesU.pas' {frmRptTreeProperties},
  VRWReportIF in '..\..\Common\VRWReportIF.pas',
  RptDesignerF in '..\RptDesignerF.pas' {frmReportDesigner},
  SelectDBFieldF in '..\SelectDBFieldF.pas' {frmSelectDBField},
  GlobalTypes in '..\..\Common\GlobalTypes.pas',
  RptWizardTypes in '..\RptWizardTypes.pas',
  frmVRWRangeFiltersU in '..\..\Common\frmVRWRangeFiltersU.pas' {frmVRWRangeFilters},
  frmVRWRangeFilterDetailsU in '..\..\Common\frmVRWRangeFilterDetailsU.pas' {frmVRWRangeFilterDetails},
  VRWConverterIF in '..\..\Common\VRWConverterIF.pas',
  RegionMgr in '..\RegionMgr.pas',
  ctrlFormulaProperties in '..\ctrlFormulaProperties.pas' {frmFormulaProperties},
  DesignerUtil in '..\DesignerUtil.pas',
  ctrlBox in '..\ctrlBox.pas',
  ctrlBoxPropertiesF in '..\ctrlBoxPropertiesF.pas' {frmBoxProperties},
  ctrlDBField in '..\ctrlDBField.pas',
  ctrlDBFieldProperties in '..\ctrlDBFieldProperties.pas' {frmDBFieldProperties},
  ctrlDrag in '..\ctrlDrag.pas',
  ctrlFormula in '..\ctrlFormula.pas',
  ctrlImage in '..\ctrlImage.pas',
  ctrlImagePropertiesF in '..\ctrlImagePropertiesF.pas' {Form1},
  ctrlText in '..\ctrlText.pas',
  ctrlTextPropertiesF in '..\ctrlTextPropertiesF.pas' {frmTextProperties},
  Region in '..\Region.pas',
  RptDisp in '..\RptDisp.pas' {frmReportDispProps},
  CtrlPrms in '..\..\Common\CtrlPrms.pas',
  frmVRWAlignU in '..\frmVRWAlignU.pas' {frmVRWAlign},
  frmVRWSizeU in '..\frmVRWSizeU.pas' {frmVRWSize},
  RptWizardF in '..\RptWizardF.pas' {frmRepWizard},
  DesignerTypes in '..\DesignerTypes.pas',
  VRWPaperSizesIF in '..\..\Common\VRWPaperSizesIF.pas',
  ControlTreeF in '..\ControlTreeF.pas' {frmControlsTree},
  frmVRWDBFieldPropertiesU in '..\frmVRWDBFieldPropertiesU.pas' {frmVRWDBFieldProperties},
  RptCopy in '..\RptCopy.pas' {frmCopyReport},
  Brand in '..\..\..\FUNCS\Brand.pas',
  IntMU in '..\INTMU.PAS';

{$R *.res}
{$R EntRWBmp.res}

begin
  Application.Initialize;
  Application.Title := 'Visual Report Writer';
  Application.HelpFile := 'envrw.hlp';
  Application.CreateForm(TfrmReportTree, frmReportTree);
  Application.CreateForm(TfrmVRWDBFieldProperties, frmVRWDBFieldProperties);
  Application.Run;
end.

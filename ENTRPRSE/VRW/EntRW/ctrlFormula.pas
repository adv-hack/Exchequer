unit ctrlFormula;

interface

Uses Classes, Forms, Graphics, SysUtils, Windows,
     VRWReportIF,
     DesignerTypes,    // Common designer types and interfaces
     Region,
     ctrlDrag          // TBaseDragControl
     ;

Type
  TVRWFormulaControl = class(TBaseDragControl)
  Private
    FFormulaDets : IVRWFormulaControl;

    Function GetPrintOnReport : Boolean;
    Procedure SetPrintOnReport (Value : Boolean);
  Protected
    Function GetControlSummary : ShortString; override;
    Function GetPrintIf : Boolean; override;
    // Called to identify internally whether the field is sorted
    Function IsSorted : Boolean; override;
    procedure PaintControl; override;
    Procedure SetRegion (Value : TRegion); override;
  Public
    Property FormulaDets : IVRWFormulaControl Read FFormulaDets;
    Property fmlPrintOnReport : Boolean Read GetPrintOnReport Write SetPrintOnReport;

    Constructor Create (RegionManager: IRegionManager; FormulaDets : IVRWFormulaControl); Reintroduce;
    Destructor Destroy; Override;

    // Called when building a popup menu for the control, the set contains all
    // possible menu items and the control should remove those that don't apply
    Procedure DisableContextItems(Var MenuItemSet : TControlContextItemsSet); Override;
  End; // TVRWFormulaControl

implementation

Uses DesignerUtil;

Var
  CtrlCounter : TBits;

//=========================================================================

Constructor TVRWFormulaControl.Create (RegionManager: IRegionManager; FormulaDets : IVRWFormulaControl);
Var
  iCtrl : SmallInt;
Begin // Create
  Inherited Create(RegionManager, FormulaDets);

  FFormulaDets := FormulaDets;

  iCtrl := CtrlCounter.OpenBit;
  CtrlCounter.Bits[iCtrl] := True;
  Name := 'TVRWFormulaControl' + IntToStr(iCtrl+1);
End; // Create

//------------------------------

Destructor TVRWFormulaControl.Destroy;
Begin // Destroy
  FFormulaDets := NIL;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

procedure TVRWFormulaControl.PaintControl;
Var
  PaintRect  : TRect;
  PaintFlags : Word;
Begin // PaintControl
  With Canvas Do
  Begin
    Brush.Color := clBlue;
    Brush.Style := bsClear;

    { Calc Flags }
    Case FieldAlignment Of
      taLeftJustify  : PaintFlags := DT_LEFT;
      taRightJustify : PaintFlags := DT_RIGHT;
      taCenter       : PaintFlags := DT_CENTER;
    Else
      PaintFlags := DT_LEFT;
    End; { Case }
    PaintFlags := PaintFlags Or DT_VCENTER Or DT_EXPANDTABS Or DT_WORDBREAK Or DT_NOPREFIX;
    PaintRect := ClientRect;

    // Copy the font details in from the details and then scale the font
    CopyIFontToFont (FControlDets.vcFont, Font);
    FontToVisFont(Font, Canvas.Font);

    // Paint hidden controls in gray
    If (Not fmlPrintOnReport) Then Canvas.Font.Color := clGray;

//    CanvasDrawText (Canvas, FFormulaDets.vcFormulaDefinition, PaintRect, PaintFlags);
    CanvasDrawText (Canvas, FFormulaDets.vcFormulaName, PaintRect, PaintFlags);
  End; // With Canvas
End; // PaintControl

//-------------------------------------------------------------------------

Function TVRWFormulaControl.GetControlSummary : ShortString;
Begin // GetControlSummary
  Result := 'Formula: ' + FFormulaDets.vcFormulaDefinition;
End; // GetControlSummary

//------------------------------

Function TVRWFormulaControl.GetPrintIf : Boolean;
Begin // GetPrintIf
  Result := (Trim(FFormulaDets.vcPrintIf) <> '');
End; // GetPrintIf

//-------------------------------------------------------------------------

// Called when building a popup menu for the control, the set contains all
// possible menu items and the control should remove those that don't apply
Procedure TVRWFormulaControl.DisableContextItems(Var MenuItemSet : TControlContextItemsSet);
Begin // DisableContextItems
  MenuItemSet := MenuItemSet - [cciRangeFilter, cciSelectionCriteria];

  // Only show sorting options for fields within a Section Header region
  If (ParentRegion.reRegionDets.rgType <> rtSectionHdr) Then
    MenuItemSet := MenuItemSet - [cciSortingSubMenu];
End; // DisableContextItems

//-------------------------------------------------------------------------

Function TVRWFormulaControl.GetPrintOnReport : Boolean;
Begin // GetPrintOnReport
  Result := FFormulaDets.vcPrintField;
End; // GetPrintOnReport
Procedure TVRWFormulaControl.SetPrintOnReport (Value : Boolean);
Begin // SetPrintOnReport
  FFormulaDets.vcPrintField := Value;
  Invalidate;
End; // SetPrintOnReport

//-------------------------------------------------------------------------

Procedure TVRWFormulaControl.SetRegion (Value : TRegion);
Begin // SetRegion
  // If the DB Field control has been moved between regions and has sorting
  // defined then we need to rebuild the sorting information across the regions
  If Assigned(ParentRegion) And (ParentRegion <> Value) And (FFormulaDets.vcSortOrder <> '') Then
  Begin
    Inherited SetRegion (Value);

    // Check that the new region supports sorting
    If (ParentRegion.reRegionDets.rgType <> rtSectionHdr) Then
    Begin
      // Not a section header - remove the sorting and update the regions
      FFormulaDets.vcSortOrder := '';
    End; // If (ParentRegion.reRegionDets.rgType <> rtSectionHdr)

    FRegionManager.UpdateRegionSorts;
  End // If Assigned(ParentRegion) And (ParentRegion <> Value) And (FDBFieldDets.vcSortOrder <> '')
  Else
    Inherited SetRegion (Value);
End; // SetRegion

//-------------------------------------------------------------------------

// Called to identify internally whether the field is sorted
Function TVRWFormulaControl.IsSorted : Boolean;
Begin // IsSorted
  Result := FFormulaDets.vcSortOrder <> '';
End; // IsSorted

//-------------------------------------------------------------------------


Initialization
  CtrlCounter := TBits.Create;
Finalization
  FreeAndNIL(CtrlCounter);
end.

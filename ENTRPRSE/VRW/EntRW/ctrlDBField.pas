unit ctrlDBField;

interface

Uses Classes, Dialogs, Forms, Graphics, SysUtils, Windows,
     VRWReportIF,
     DesignerTypes,    // Common designer types and interfaces
     Region,
     ctrlDrag          // TBaseDragControl
     ;

Type
  TVRWDBFieldControl = class(TBaseDragControl)
  Private
    FDBFieldDets : IVRWFieldControl;

    Function GetPrintOnReport : Boolean;
    Procedure SetPrintOnReport (Value : Boolean);
  Protected
    Function GetControlSummary : ShortString; override;
    Function GetPrintIf : Boolean; override;
    Function GetRangeFilter : Boolean; override;
    Function GetSelectionCriteria : Boolean; override;
    // Called to identify internally whether the field is sorted
    Function IsSorted : Boolean; override;
    procedure PaintControl; override;
    Procedure SetRegion (Value : TRegion); override;
  Public
    Property DBFieldDets : IVRWFieldControl Read FDBFieldDets;
    Property dbfPrintOnReport : Boolean Read GetPrintOnReport Write SetPrintOnReport;

    Constructor Create (RegionManager: IRegionManager; DBFieldDets : IVRWFieldControl); Reintroduce;
    Destructor Destroy; Override;

    // Called when building a popup menu for the control, the set contains all
    // possible menu items and the control should remove those that don't apply
    Procedure DisableContextItems(Var MenuItemSet : TControlContextItemsSet); Override;
  End; // TVRWDBFieldControl

implementation

Uses StrUtils, DesignerUtil, frmVRWRangeFiltersU;

Var
  CtrlCounter : TBits;

//=========================================================================

Constructor TVRWDBFieldControl.Create (RegionManager: IRegionManager; DBFieldDets : IVRWFieldControl);
Var
  iCtrl : SmallInt;
Begin // Create
  Inherited Create(RegionManager, DBFieldDets);

  FDBFieldDets := DBFieldDets;

  iCtrl := CtrlCounter.OpenBit;
  CtrlCounter.Bits[iCtrl] := True;
  Name := 'TVRWDBFieldControl' + IntToStr(iCtrl+1);
End; // Create

//------------------------------

Destructor TVRWDBFieldControl.Destroy;
Begin // Destroy
  FDBFieldDets := NIL;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

procedure TVRWDBFieldControl.PaintControl;
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
    If (Not dbfPrintOnReport) Then Canvas.Font.Color := clGray;

    CanvasDrawText (Canvas, FDBFieldDets.VcFieldName, PaintRect, PaintFlags);
  End; // With Canvas
End; // PaintControl

//-------------------------------------------------------------------------

Function TVRWDBFieldControl.GetControlSummary : ShortString;
Begin // GetControlSummary
  Result := 'DBField: ' + FDBFieldDets.VcFieldName;
End; // GetControlSummary

//-------------------------------------------------------------------------

Function TVRWDBFieldControl.GetPrintIf : Boolean;
Begin // GetPrintIf
  Result := (Trim(FDBFieldDets.vcPrintIf) <> '');
End; // GetPrintIf

//------------------------------

Function TVRWDBFieldControl.GetRangeFilter : Boolean;
Begin // GetRangeFilter
  Result := RangeFilterSet(FDBFieldDets.vcRangeFilter);
End; // GetRangeFilter

//------------------------------

Function TVRWDBFieldControl.GetSelectionCriteria : Boolean;
Begin // GetSelectionCriteria
  Result := (Trim(FDBFieldDets.vcSelectCriteria) <> '');
End; // GetSelectionCriteria

//-------------------------------------------------------------------------

// Called to identify internally whether the field is sorted
Function TVRWDBFieldControl.IsSorted : Boolean;
Begin // IsSorted
  Result := FDBFieldDets.vcSortOrder <> '';
End; // IsSorted

//-------------------------------------------------------------------------

// Called when building a popup menu for the control, the set contains all
// possible menu items and the control should remove those that don't apply
Procedure TVRWDBFieldControl.DisableContextItems(Var MenuItemSet : TControlContextItemsSet);
Begin // DisableContextItems
  // Only show sorting options for fields within a Section Header region
  If (ParentRegion.reRegionDets.rgType <> rtSectionHdr) Then
    MenuItemSet := MenuItemSet - [cciSortingSubMenu];
End; // DisableContextItems

//-------------------------------------------------------------------------

Function TVRWDBFieldControl.GetPrintOnReport : Boolean;
Begin // GetPrintOnReport
  Result := FDBFieldDets.vcPrintField;
End; // GetPrintOnReport
Procedure TVRWDBFieldControl.SetPrintOnReport (Value : Boolean);
Begin // SetPrintOnReport
  FDBFieldDets.vcPrintField := Value;
  Invalidate;
End; // SetPrintOnReport

//-------------------------------------------------------------------------

Procedure TVRWDBFieldControl.SetRegion (Value : TRegion);
Begin // SetRegion
  // If the DB Field control has been moved between regions and has sorting
  // defined then we need to rebuild the sorting information across the regions
  If Assigned(ParentRegion) And (ParentRegion <> Value) And (FDBFieldDets.vcSortOrder <> '') Then
  Begin
    Inherited SetRegion (Value);

    // Check that the new region supports sorting
    If (ParentRegion.reRegionDets.rgType <> rtSectionHdr) Then
    Begin
      // Not a section header - remove the sorting and update the regions
      FDBFieldDets.vcSortOrder := '';
    End; // If (ParentRegion.reRegionDets.rgType <> rtSectionHdr)

    FRegionManager.UpdateRegionSorts;
  End // If Assigned(ParentRegion) And (ParentRegion <> Value) And (FDBFieldDets.vcSortOrder <> '')
  Else
    Inherited SetRegion (Value);
End; // SetRegion

//-------------------------------------------------------------------------

Initialization
  CtrlCounter := TBits.Create;
Finalization
  FreeAndNIL(CtrlCounter);
end.

unit ctrlLine;

interface

Uses Classes, Forms, Graphics, SysUtils, Windows,
     VRWReportIF,
     DesignerTypes,    // Common designer types and interfaces
     ctrlDrag          // TBaseDragControl
     ;

Type
  TVRWLineControl = class(TBaseDragControl)
  Private
    FLineDets : IVRWLineControl;
  Protected
    //procedure PaintControl; override;
  Public
    Constructor Create (RegionManager: IRegionManager; LineDets : IVRWLineControl); Reintroduce;
    Destructor Destroy; Override;

    // Called when building a popup menu for the control, the set contains all
    // possible menu items and the control should remove those that don't apply
    Procedure DisableContextItems(Var MenuItemSet : TControlContextItemsSet); Override;
  End; // TVRWLineControl

implementation

Uses DesignerUtil;

Var
  CtrlCounter : TBits;

//=========================================================================

Constructor TVRWLineControl.Create (RegionManager: IRegionManager; LineDets : IVRWLineControl);
Var
  iCtrl : SmallInt;
Begin // Create
  Inherited Create(RegionManager, LineDets);

  FLineDets := LineDets;

  iCtrl := CtrlCounter.OpenBit;
  CtrlCounter.Bits[iCtrl] := True;
  Name := 'TVRWLineControl' + IntToStr(iCtrl+1);
End; // Create

//------------------------------

Destructor TVRWLineControl.Destroy;
Begin // Destroy
  FLineDets := NIL;
  
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called when building a popup menu for the control, the set contains all
// possible menu items and the control should remove those that don't apply
Procedure TVRWLineControl.DisableContextItems(Var MenuItemSet : TControlContextItemsSet);
Begin // DisableContextItems
  MenuItemSet := MenuItemSet - [cciRangeFilter, cciSelectionCriteria, cciPrintIf, cciPrintOnReport, cciFont];
End; // DisableContextItems

//-------------------------------------------------------------------------

//procedure TVRWTextControl.PaintControl;
//Var
//  PaintRect  : TRect;
//  PaintFlags : Word;
//Begin // PaintControl
//  With Canvas Do
//  Begin
//    Pen.Color := clBlack;
//
//    Brush.Color := clBlue;
//    Brush.Style := bsClear;
//
//    { Calc Flags }
//    Case FTextAlign Of
//      taLeftJustify  : PaintFlags := DT_LEFT;
//      taRightJustify : PaintFlags := DT_RIGHT;
//      taCenter       : PaintFlags := DT_CENTER;
//    Else
//      PaintFlags := DT_LEFT;
//    End; { Case }
//    PaintFlags := PaintFlags Or DT_VCENTER Or DT_EXPANDTABS Or DT_WORDBREAK Or DT_NOPREFIX;
//    PaintRect := ClientRect;
//    FontToVisFont(FFont, Canvas.Font);
//    CanvasDrawText (Canvas, FText, PaintRect, PaintFlags);
//  End; // With Canvas
//End; // PaintControl


Initialization
  CtrlCounter := TBits.Create;
Finalization
  FreeAndNIL(CtrlCounter);
end.

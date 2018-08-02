unit ctrlText;

interface

Uses Classes, Forms, Graphics, SysUtils, Windows,
     VRWReportIF,
     DesignerTypes,    // Common designer types and interfaces
     ctrlDrag          // TBaseDragControl
     ;

Type
  TVRWTextControl = class(TBaseDragControl)
  Private
    FTextDets : IVRWTextControl;
  Protected
    Function GetControlSummary : ShortString; override;
    procedure PaintControl; override;
  Public
    Constructor Create (RegionManager: IRegionManager; TextDets : IVRWTextControl); Reintroduce;
    Destructor Destroy; Override;

    // Called when building a popup menu for the control, the set contains all
    // possible menu items and the control should remove those that don't apply
    Procedure DisableContextItems(Var MenuItemSet : TControlContextItemsSet); Override;
  End; // TVRWTextControl

implementation

Uses DesignerUtil;

Var
  CtrlCounter : TBits;

//=========================================================================

//Constructor TVRWTextControl.Create (RegionManager: IRegionManager);
Constructor TVRWTextControl.Create (RegionManager: IRegionManager; TextDets : IVRWTextControl);
Var
  iCtrl : SmallInt;
Begin // Create
  Inherited Create(RegionManager, TextDets);

  FTextDets := TextDets;

  iCtrl := CtrlCounter.OpenBit;
  CtrlCounter.Bits[iCtrl] := True;
  //Name := 'TVRWTextControl' + IntToStr(iCtrl+1);
  Name := ClassName + IntToStr(iCtrl+1);
End; // Create

//------------------------------

Destructor TVRWTextControl.Destroy;
Begin // Destroy
  FTextDets := NIL;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TVRWTextControl.GetControlSummary : ShortString;
Begin // GetControlSummary
  Result := 'Text: ' + FTextDets.vcCaption;
End; // GetControlSummary

//-------------------------------------------------------------------------

// Called when building a popup menu for the control, the set contains all
// possible menu items and the control should remove those that don't apply
Procedure TVRWTextControl.DisableContextItems(Var MenuItemSet : TControlContextItemsSet);
Begin // DisableContextItems
  MenuItemSet := MenuItemSet - [cciRangeFilter, cciSelectionCriteria, cciPrintIf, cciPrintOnReport, cciSortingSubMenu];
End; // DisableContextItems

//-------------------------------------------------------------------------

procedure TVRWTextControl.PaintControl;
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
    CopyIFontToFont (FTextDets.vcFont, Font);
    FontToVisFont(Font, Canvas.Font);

    CanvasDrawText (Canvas, FTextDets.vcCaption, PaintRect, PaintFlags);
  End; // With Canvas
End; // PaintControl

//-------------------------------------------------------------------------

Initialization
  CtrlCounter := TBits.Create;
Finalization
  FreeAndNIL(CtrlCounter);
end.

unit ctrlImage;

interface

Uses Classes, Forms, Graphics, SysUtils, Windows, ExtCtrls,
     VRWReportIF,
     DesignerTypes,    // Common designer types and interfaces
     ctrlDrag          // TBaseDragControl
     ;

Type
  TVRWImageControl = class(TBaseDragControl)
  Private
    FImage : TImage;
    FImageDets : IVRWImageControl;
  Protected
    Function GetControlSummary : ShortString; override;
    procedure PaintControl; override;
  Public
    Property ImageDets : IVRWImageControl Read FImageDets;

    Constructor Create (RegionManager: IRegionManager; ImageDets : IVRWImageControl); Reintroduce;
    Destructor Destroy; Override;

    // Autosize the control to the image size
    Procedure AutoSize;

    // Copies the image out of the object into the internal TImage for painting
    Procedure CopyImage;

    // Called when building a popup menu for the control, the set contains all
    // possible menu items and the control should remove those that don't apply
    Procedure DisableContextItems(Var MenuItemSet : TControlContextItemsSet); Override;
  End; // TVRWImageControl

implementation

Uses DesignerUtil;

Var
  CtrlCounter : TBits;

//=========================================================================

Constructor TVRWImageControl.Create (RegionManager: IRegionManager; ImageDets : IVRWImageControl);
Var
  iCtrl : SmallInt;
Begin // Create
  Inherited Create(RegionManager, ImageDets);

  FImage := TImage.Create(Self);

  FImageDets := ImageDets;

  iCtrl := CtrlCounter.OpenBit;
  CtrlCounter.Bits[iCtrl] := True;
  Name := 'TVRWImageControl' + IntToStr(iCtrl+1);

  // Load the image from the object
  CopyImage;
End; // Create

//------------------------------

Destructor TVRWImageControl.Destroy;
Begin // Destroy
  FImageDets := NIL;
  FreeandNIL(FImage);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TVRWImageControl.GetControlSummary : ShortString;
Begin // GetControlSummary
  Result := 'Image';
End; // GetControlSummary

//-------------------------------------------------------------------------

// Called when building a popup menu for the control, the set contains all
// possible menu items and the control should remove those that don't apply
Procedure TVRWImageControl.DisableContextItems(Var MenuItemSet : TControlContextItemsSet);
Begin // DisableContextItems
  MenuItemSet := MenuItemSet - [cciRangeFilter, cciSelectionCriteria, cciPrintIf, cciPrintOnReport, cciFont, cciSortingSubMenu];
End; // DisableContextItems

//-------------------------------------------------------------------------

procedure TVRWImageControl.PaintControl;
Begin // PaintControl
  Canvas.StretchDraw(ClientRect, {FImageDets.vc}FImage.Picture.Graphic);
End; // PaintControl

//-------------------------------------------------------------------------

// Autosize the control to the image size
Procedure TVRWImageControl.AutoSize;
Begin // AutoSize
//  Height := FImage.Picture.Bitmap.Height;
  Height := FImage.Picture.Height;
  If (Height < FRegionManager.rmGridSizeYPixels) Then Height := FRegionManager.rmGridSizeYPixels;

//  Width := FImage.Picture.Bitmap.Width;
  Width := FImage.Picture.Width;
  If (Width < FRegionManager.rmGridSizeXPixels) Then Width := FRegionManager.rmGridSizeXPixels;
End; // AutoSize

//-------------------------------------------------------------------------

// Copies the image out of the object into the internal TImage for painting
Procedure TVRWImageControl.CopyImage;
var
  BMPStream: TMemoryStream;
Begin // CopyImage
  BMPStream := TMemoryStream.Create;
  try
    BMPStream.WriteBuffer(FImageDets.vcBMPStore.pBMP^, FImageDets.vcBMPStore.iBMPSize);
    BMPStream.Position := 0;
    FImage.Picture.Bitmap.LoadFromStream(BMPStream)
  finally
    BMPStream.Free;
  end;
End; // CopyImage

//-------------------------------------------------------------------------

Initialization
  CtrlCounter := TBits.Create;
Finalization
  FreeAndNIL(CtrlCounter);
end.

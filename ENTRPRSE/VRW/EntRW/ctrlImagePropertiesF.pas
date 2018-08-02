unit ctrlImagePropertiesF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtDlgs,
  VRWReportIF,
  DesignerTypes,    // Common designer types and interfaces
  ctrlImage
  ;

type
  TForm1 = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

// Adds a Image control into the specified region at the specified region client co-ords
Function AddImageControl(Const Region : TWinControl; Const X, Y : Integer) : Boolean;

// Displays the properties dialog for the passed Image Control, returns TRUE
// if the user Saved the changes or FALSE if they cancelled the dialog
Function DisplayImageOptions (DesignerControl : TVRWImageControl) : Boolean;

implementation

{$R *.dfm}

Uses DesignerUtil, Region, GlobVar,
     // MH 06/02/2017 ABSEXCH-14925 2017-R1: Added support for extra image types
     ImageConversionFuncs;

//=========================================================================

// Adds a Image control into the specified region at the specified region client co-ords
Function AddImageControl(Const Region : TWinControl; Const X, Y : Integer) : Boolean;
Var
  NewImageCtrl : TVRWImageControl;
  NewImageIntf : IVRWImageControl;
  ScaleFactor  : Double;
  RegionClient : TRect;
Begin // AddImageControl
  Result := False;

  // Create new text object in RepEngine.Dll
  NewImageIntf := TRegion(Region).reRegionDets.rgControls.Add(TRegion(Region).reRegionDets.RgReport, ctImage) As IVRWImageControl;
  Try
    // Create a new hidden wrapper control for the designer - setup minimum basic info
    NewImageCtrl := TVRWImageControl.Create (TRegion(Region).reManager, NewImageIntf);
    NewImageCtrl.Visible := False;
    NewImageCtrl.ParentRegion := TRegion(Region);
    NewImageCtrl.SetBounds (X, Y, 90, 21); // LTWH

    If DisplayImageOptions (NewImageCtrl) Then
    Begin
      // Snap the image top-left to the grid
      NewImageCtrl.SnapToGrid;

      // Need to size intelligently and position according to the grid
//      NewImageCtrl.Height := NewImageCtrl.ImageDets.vcImage.Picture.Bitmap.Height;
//      NewImageCtrl.Width := NewImageCtrl.ImageDets.vcImage.Picture.Bitmap.Width;
      NewImageCtrl.AutoSize;

      // Check it fits within the Region
      RegionClient := TRegion(Region).RegionClientScrCoords;
      RegionClient.TopLeft := Region.ScreenToClient(RegionClient.TopLeft);
      RegionClient.BottomRight := Region.ScreenToClient(RegionClient.BottomRight);

      If (NewImageCtrl.Height > (RegionClient.Bottom - NewImageCtrl.Top)) Then
      Begin
//        ScaleFactor := (RegionClient.Bottom - NewImageCtrl.Top) / NewImageCtrl.ImageDets.vcImage.Picture.Bitmap.Height;
        ScaleFactor := (RegionClient.Bottom - NewImageCtrl.Top) / NewImageCtrl.ImageDets.vcImage.Picture.Height;
        NewImageCtrl.Height := (Trunc(NewImageCtrl.Height * ScaleFactor) Div TRegion(Region).reManager.rmGridSizeYPixels) * TRegion(Region).reManager.rmGridSizeYPixels;
        NewImageCtrl.Width := (Trunc(NewImageCtrl.Width * ScaleFactor) Div TRegion(Region).reManager.rmGridSizeXPixels) * TRegion(Region).reManager.rmGridSizeXPixels;
      End; // If (NewImageCtrl.Height > (RegionClient.Bottom - NewImageCtrl.Top))

      If (NewImageCtrl.Width > (RegionClient.Right - NewImageCtrl.Left)) Then
      Begin
//        ScaleFactor := (RegionClient.Right - NewImageCtrl.Left) / NewImageCtrl.ImageDets.vcImage.Picture.Bitmap.Width;
        ScaleFactor := (RegionClient.Right - NewImageCtrl.Left) / NewImageCtrl.ImageDets.vcImage.Picture.Width;
        NewImageCtrl.Height := (Trunc(NewImageCtrl.Height * ScaleFactor) Div TRegion(Region).reManager.rmGridSizeYPixels) * TRegion(Region).reManager.rmGridSizeYPixels;
        NewImageCtrl.Width := (Trunc(NewImageCtrl.Width * ScaleFactor) Div TRegion(Region).reManager.rmGridSizeXPixels) * TRegion(Region).reManager.rmGridSizeXPixels;
      End; // If (NewImageCtrl.Width > (RegionClient.Right - NewImageCtrl.Left))

      // Update the internal object which records the size and position
      NewImageCtrl.UpdateControlDets;

      // Select the control
      TRegion(Region).reManager.SelectControl(NewImageCtrl, False);

      // Finally, show the control
      NewImageCtrl.Visible := True;
    End // If DisplayImageOptions (DesignerControl : TVRWImageControl)
    Else
    Begin
      // Cancelled - remove control and destroy RepEngine object
      FreeAndNIL(NewImageCtrl);
      TRegion(Region).reRegionDets.rgControls.Delete(NewImageIntf.vcName);
    End; // Else
  Finally
    NewImageIntf := NIL;
  End; // Try..Finally
End; // AddImageControl

//-------------------------------------------------------------------------
function ValidateSize(FileName: string): Boolean;
var
  Stream: TFileStream;
begin
  Result := True;
  Stream := TFileStream.Create(FileName, fmShareDenyNone);
  try
    if (Stream.Size > 1024000) then
    begin
      Result := MessageDlg('This is a large image. Loading and saving the ' +
                           'report might take a long time if this image ' +
                           'is included. Are you sure you want to use this ' +
                           'image?',
                           mtWarning,
                           [mbYes, mbNo],
                           0) = mrYes;
    end;
  finally
    Stream.Free;
  end;
end;

//-------------------------------------------------------------------------

// Displays the properties dialog for the passed Image Control, returns TRUE
// if the user Saved the changes or FALSE if they cancelled the dialog
Function DisplayImageOptions (DesignerControl : TVRWImageControl) : Boolean;
var
  // MH 06/02/2017 ABSEXCH-14925 2017-R1: Added support for extra image types
  OpenDlg  : TOpenDialog;
Begin // DisplayImageOptions
  // MH 06/02/2017 ABSEXCH-14925 2017-R1: Added support for extra image types
  // Switched from TOpenPictureDialog to TOpenDialog as TOpenPictureDialog doesn't
  // support the new image types and crashes
  OpenDlg := TOpenDialog.Create(Application.MainForm);
  Try
    OpenDlg.Options := [ofHideReadOnly, ofDontAddToRecent, ofFileMustExist, ofPathMustExist];

    // MH 06/02/2017 ABSEXCH-14925 2017-R1: Added support for extra image types
    OpenDlg.Filter := OpenDialogFilter;
    OpenDlg.FilterIndex := 1;

    OpenDlg.InitialDir := ExtractFilePath(SetDrive) + 'Reports\';

    Result := OpenDlg.Execute;

    if Result then
    begin
      if ValidateSize(OpenDlg.FileName) then
      begin
        DesignerControl.ImageDets.LoadImage (OpenDlg.FileName);
        DesignerControl.CopyImage;
        DesignerControl.Invalidate;
      end
      else
        Result := False;
    end; // If Result
  Finally
    OpenDlg.Free;
  End; // Try..Finally
End; // DisplayImageOptions

//-------------------------------------------------------------------------



end.

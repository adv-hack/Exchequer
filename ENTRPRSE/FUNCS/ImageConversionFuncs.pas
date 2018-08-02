Unit ImageConversionFuncs;

Interface

Uses Classes, SysUtils, Graphics;

// MH 06/02/2017 ABSEXCH-14925 2017-R1: Added support for extra image types to FormDes/VRW

// Loads the specified image into the supplied TBitmap instance - at the time of writing
// the supported types are *.bmp;*.jpg;*.jpeg;*.gif;*.png;*.tif;*.tiff;*.ico - others may
// work (e.g. *.wmf) but aren't 'supported', others like *.jif;*.jpe are known to not work
Procedure LoadImageFromFile (Const ImagePath : ShortString; Const ImageControl : TBitmap);

// Returns a string containing the filter specification for the File|Open dialog in
// the Form Designer / VRW
Function OpenDialogFilter : ANSIString;

Implementation

Type
  // Class supports being pointed at an existing memory stream to allow the stream to be
  // read - in this case the stream is created in ImageConversion.Dll (Delphi 10) and
  // read here to extract the bitmap
  TCustomBitmapStream = Class(TCustomMemoryStream)
  public
    // Redirects the instances internal memory stream to an existing memory streams data so we can pirate it
    procedure LinkToMemStream(Ptr: Pointer; Size: Longint);
  End; // TCustomBitmapStream

// Loads the image file specified in SourceImage and converts it to a bitmap which it
// stores in a MemoryStream and returns the Pointer/Size so we can read it here.
// Note: ImageConversion.Dll is written in Delph 10 so we can't pass any non-standard types or classes
Function ConvertToBitmapStream (Const SourceImage : PANSIChar; Var StreamPtr : Pointer; Var StreamSize : Int64) : Integer; StdCall; External 'ImageConversion.Dll';

// Frees the MemoryStream storing the bitmap image returned by ConvertToBitmapStream, this
// should be called after a successful call to ConvertToBitmapStream
// Note: ImageConversion.Dll is written in Delph 10 so we can't pass any non-standard types or classes
Procedure CleardownBitmapStream; StdCall; External 'ImageConversion.Dll';

//=========================================================================

// Redirects the instances internal memory stream to an existing memory streams data so we can pirate it
procedure TCustomBitmapStream.LinkToMemStream(Ptr: Pointer; Size: Longint);
Begin // LinkToMemStream
  SetPointer(Ptr, Size);
End; // LinkToMemStream

//=========================================================================

// Loads the specified image into the supplied TBitmap instance - at the time of writing
// the supported types are *.bmp;*.jpg;*.jpeg;*.gif;*.png;*.tif;*.tiff;*.ico - others may
// work (e.g. *.wmf) but aren't 'supported', others like *.jif;*.jpe are known to not work
Procedure LoadImageFromFile (Const ImagePath : ShortString; Const ImageControl : TBitmap);
Var
  InFile : ANSIString;
  MemStream : TCustomBitmapStream;
  StreamPtr : Pointer;
  StreamSize : Int64;
Begin // LoadImageFromFile
  // Convert image to .bmp and use a memory stream to transfer it
  InFile := ImagePath;
  StreamPtr := NIL;
  StreamSize := 0;
  If (ConvertToBitmapStream (PCHAR(InFile), StreamPtr, StreamSize) = 0) Then
  Begin
    // Use a Custom Memory Stream so that we can point it at the address
    // returned from the .Dll to extract the bitmap
    MemStream := TCustomBitmapStream.Create;
    MemStream.SetPointer(StreamPtr, StreamSize);
    ImageControl.LoadFromStream(MemStream);
    MemStream.Free;

    // De-allocate the Memory Stream in ImageConversion.Dll which owns the StreamPtr memory
    CleardownBitmapStream;
  End // If (ConvertToBitmapStream (InFile, StreamPtr, StreamSize) = 0)
  Else
    // Revert to treating it as a standard bitmap
    ImageControl.LoadFromFile (ImagePath);
End; // LoadImageFromFile

//-------------------------------------------------------------------------

// Returns a string containing the filter specification for the File|Open dialog in
// the Form Designer / VRW
Function OpenDialogFilter : ANSIString;
Begin // OpenDialogFilter
  // Note: The first entry will be the default
  Result := 'All Picture Files|*.bmp;*.jpg;*.jpeg;*.gif;*.tif;*.tiff;*.png;*.ico' +
            '|Bitmap Files (*.bmp)|*.bmp' +
            '|JPEG (*.jpg,*.jpeg)|*.jpg;*.jpeg' +     // Note: .jif and .jpe crash the VRW
            '|GIF (*.gif)|*.gif' +
            '|TIFF (*.tif,*.tiff)|*.tif;*.tiff' +
            '|PNG (*.png)|*.png' +
            '|ICO (*.ico)|*.ico';

End; // OpenDialogFilter

//=========================================================================

End.

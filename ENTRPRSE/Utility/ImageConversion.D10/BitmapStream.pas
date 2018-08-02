unit BitmapStream;

interface

Uses
  SysUtils,
  Classes,
  Vcl.Graphics,
  Jpeg,         // Need to include this unit for TPicture to support Jpegs - no idea how that works!
  PngImage,     // Need to include this unit for TPicture to support PNG's - ditto
  GifImg;       // Need to include this unit for TPicture to support Jpegs - klop

// Convert the specified image (.bmp, .gif,. .jpg, .png, etc...) into a Bitmap
// and store it in a memory stream for the calling application to retrieve
//
// Result:-
//   0    AOK
//   1    Image Not Found
//
Function ConvertToBitmapStream (Const SourceImage : PANSIChar; Var StreamPtr : Pointer; Var StreamSize : Int64) : Integer; StdCall;

// Clears down the Memory Stream left in memory by a successful  call to
// ConvertToBitmapStrea
Procedure CleardownBitmapStream; StdCall;

implementation

Var
  UnitMemoryStream : TMemoryStream;

//=========================================================================

// Convert the specified image (.bmp, .gif,. .jpg, .png, etc...) into a Bitmap
// and store it in a memory stream for the calling application to retrieve
//
// Result:-
//   0    AOK
//   1    Image Not Found
//
Function ConvertToBitmapStream (Const SourceImage : PANSIChar; Var StreamPtr : Pointer; Var StreamSize : Int64) : Integer; StdCall;
Var
  Picture: TPicture;
  Bitmap: TBitmap;
  sImagePath: String;
Begin // ConvertToBitmapStream
  sImagePath := string(SourceImage);  // Explicitly typecast to remove warning
  If FileExists(sImagePath) Then
  Begin
    // Use a TPicture component to load the image
    Picture := TPicture.Create;
    Try
      Picture.LoadFromFile(sImagePath);

      // Copy the image into the TBitmap for saving
      Bitmap := TBitmap.Create;
      Try
        Bitmap.Width := Picture.Width;
        Bitmap.Height := Picture.Height;
        Bitmap.Canvas.Draw(0, 0, Picture.Graphic);

        // Use a Unit level Memory Stream to save the bitmap as we can then
        // pass the pointer to its memory back to the calling routine which
        // we couldn't do if it was a local variable within this routine
        // (unless we leaked the memory).

        // The calling routine should call CleardownBitmapStream after a
        // successful call to this routine to free the Memory Stream.

        // The memory stream shouldn't ever exist at this point unless a
        // naughty application hasn't called CleardownBitmapStream after
        // a prior ConvertToBitmapStream call
        if Not Assigned(UnitMemoryStream) then
          UnitMemoryStream := TMemoryStream.Create();

        Bitmap.SaveToStream(UnitMemoryStream);
        StreamPtr := UnitMemoryStream.Memory;
        StreamSize := UnitMemoryStream.Size;
      finally
        Bitmap.Free;
      end;

      Result := 0;  // AOK
    Finally
      Picture.Free;
    End; // Try..Finally
  End // If FileExists(SourceImage)
  Else
    Result := 1;  // Image not found
End; // ConvertToBitmapStrea

//-----------------------------------

// Clears down the Memory Stream left in memory by a successful  call to
// ConvertToBitmapStrea
Procedure CleardownBitmapStream; StdCall;
Begin // CleardownBitmapStream
  FreeAndNIL(UnitMemoryStream);
End; // CleardownBitmapStream

//=========================================================================

Initialization
  UnitMemoryStream := NIL;
Finalization
  CleardownBitmapStream;
end.

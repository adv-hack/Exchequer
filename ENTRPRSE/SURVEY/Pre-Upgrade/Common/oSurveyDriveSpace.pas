unit oSurveyDriveSpace;

interface

Uses Classes, SysUtils, Windows;

Type
  TSiteDriveInfo = Class(TObject)
  Private
    FDrive : ShortString;
    FDataFileSize : Int64;
    FFreeSpace : Int64;
  Public
    Property drDrive : ShortString Read FDrive;
    Property drDataFileSize : Int64 Read FDataFileSize Write FDataFileSize;
    Property drFreeSpace : Int64 Read FFreeSpace;

    Constructor Create(Const Drive : ShortString; Const DiskSpaceUsage : Int64);
  End; // TSiteDriveInfo

implementation

//=========================================================================

Constructor TSiteDriveInfo.Create(Const Drive : ShortString; Const DiskSpaceUsage : Int64);
Begin // Create
  Inherited Create;

  FDrive := Drive;
  FDataFileSize := DiskSpaceUsage;
  FFreeSpace := DiskFree(Ord(FDrive[1]) - Ord('A') + 1);  // A: = 1, etc...
End; // Create

//-------------------------------------------------------------------------

end.

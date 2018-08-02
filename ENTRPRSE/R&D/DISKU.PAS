unit DiskU;

interface

Uses SysUtils, Windows;

function sbsDiskFree(Drive: Byte) : Double;
function sbsDiskSize(Drive: Byte) : Double;

implementation


function sbsDiskFree(Drive: Byte) : Double;
var
  RootPath: array[0..4] of Char;
  RootPtr: PChar;
  SectorsPerCluster,
  BytesPerSector,
  FreeClusters,
  TotalClusters: DWord;
  SPC, BPS, FC : Double;
begin
  RootPtr := nil;
  if Drive > 0 then begin
    StrCopy(RootPath, 'A:\');
    RootPath[0] := Char(Drive + $40);
    RootPtr := RootPath;
  end;
  If GetDiskFreeSpace(RootPtr, SectorsPerCluster, BytesPerSector, FreeClusters, TotalClusters) Then Begin
    SPC := SectorsPerCluster;
    BPS := BytesPerSector;
    FC  := FreeClusters;

    Result := SPC * BPS * FC;
  End { If }
  Else
    { Call Failed }
    Result := -1;
end;

function sbsDiskSize(Drive: Byte) : Double;
var
  RootPath: array[0..4] of Char;
  RootPtr: PChar;
  SectorsPerCluster,
  BytesPerSector,
  FreeClusters,
  TotalClusters: DWord;
  SPC, BPS, TC : Double;
begin
  RootPtr := nil;
  if Drive > 0 then
  begin
    StrCopy(RootPath, 'A:\');
    RootPath[0] := Char(Drive + $40);
    RootPtr := RootPath;
  end;
  if GetDiskFreeSpace(RootPtr, SectorsPerCluster, BytesPerSector, FreeClusters, TotalClusters) then Begin
    SPC := SectorsPerCluster;
    BPS := BytesPerSector;
    TC  := TotalClusters;

    Result := SPC * BPS * TC;
  End { If }
  Else
    { Call failed }
    Result := -1;
end;

end.

unit ECBUtil;

////////////////////////////////////////////////////////////////////
//  UNIT of utilties concerned with Exchequer Compressed Bitmaps  //
////////////////////////////////////////////////////////////////////

interface
uses
  Classes, Windows, graphics, Forms;

type
  TWhichApplication = (waEnterprise, waSentimail, waReportWriter, waEbusAdmin, waImporter);

  procedure GetMaxClientArea(var iMaxClientHeight, iMaxClientWidth : integer; TheForm : TForm; iExtraHeight : integer);
  function GetECBFilename(WhichApplication : TWhichApplication; iBitmapNo : integer; TheForm : TForm; iExtraHeight : integer) : string;
  function GetBitmapFromECB(asECBFilename : ANSIstring) : TBitmap;
//  function GetStreamFromECB(asECBFilename : ANSIstring) : TMemoryStream;
  procedure GetCentreOfBitmap(TheBitmap : TBitmap; TheForm : TForm; iExtraHeight : integer);

const
  sZipPassword = 's£ygQr]19!0Wqa1f<e#tQp';
  iCryptoKey = 91626;

implementation
uses
  Crypto, Dialogs, SysUtils, gfxUtil, StrUtil, FileUtil, AbUnzper, MiscUtil;

procedure GetMaxClientArea(var iMaxClientHeight, iMaxClientWidth : integer; TheForm : TForm; iExtraHeight : integer);
begin
  iMaxClientHeight := Screen.WorkAreaHeight - (TheForm.Height - TheForm.ClientHeight + iExtraHeight);
  iMaxClientHeight := Round(iMaxClientHeight * 1.02);
  iMaxClientWidth := Screen.WorkAreaWidth - (TheForm.Width - TheForm.ClientWidth);
  iMaxClientWidth := Round(iMaxClientWidth * 1.01);
end;

function GetECBFilename(WhichApplication : TWhichApplication; iBitmapNo : integer; TheForm : TForm; iExtraHeight : integer) : string;
// iBitmapNo    : The ThemeNo (Set to 1 if themes are not applicable)
// iExtraHeight : The total extra height used in the client area by stuff like toolbars and status bars
Const
  WIDTH_BMP_A = 1000;
  WIDTH_BMP_B = 1400;
  HEIGHT_BMP_A = 713; // divide 1000 by 1.4 (aspect ratio of the ent bitmap area
  HEIGHT_BMP_B = 927;
var
  bUseWidth : boolean;
  iMaxClientHeight, iMaxClientWidth : integer;
  s16BitFilename, s256ColourFilename : string;
begin
{  case WhichApplication of
    waEnterprise : Result := 'A';
    waSentimail : Result := 'B';
    waReportWriter : Result := 'C';
    waEbusAdmin : Result := 'D';
  end;{case}

  s256ColourFilename := Char(Ord(WhichApplication) + 65);  // NF: 01/12/2005 - This should make it more futureproof
  s16BitFilename := '';

  // Calculate which size bitmap to load

  // work out aspect ratio
  if Screen.Width / Screen.Height <= 1.2 then
  begin
    // Tall thin screen (A4 or similar)
    bUseWidth := FALSE;
  end else
  begin
    if Screen.Width / Screen.Height >= 1.4 then
    begin
      // Wide screen
      bUseWidth := TRUE;
    end else begin
      // Normal Screen
      bUseWidth := TRUE;
    end;{if}
  end;{if}

  // work out max client height / width
  GetMaxClientArea(iMaxClientHeight,iMaxClientWidth, TheForm, iExtraHeight);
//  iMaxClientHeight := Screen.Height - (TheForm.Height - TheForm.ClientHeight);
//  iMaxClientWidth := Screen.Width - (TheForm.Width - TheForm.ClientWidth);

  // work out which bitmap
  if bUseWidth then
  begin
    // calculate which BMP from width
    if iMaxClientWidth < WIDTH_BMP_A then s256ColourFilename := s256ColourFilename + 'A'
    else begin
      if iMaxClientWidth < WIDTH_BMP_B then s256ColourFilename := s256ColourFilename + 'B'
      else s256ColourFilename := s256ColourFilename + 'C';
    end;{if}
  end else begin
    // calculate which BMP from Height
    if iMaxClientHeight < HEIGHT_BMP_A then s256ColourFilename := s256ColourFilename + 'A'
    else begin
      if iMaxClientHeight < HEIGHT_BMP_B then s256ColourFilename := s256ColourFilename + 'B'
      else s256ColourFilename := s256ColourFilename + 'C';
    end;{if}
  end;{if}

  // get correct colour depth bitmap
  case ColorMode(TheForm.Canvas) of
    cm64Bit, cm32Bit, cm24Bit, cm16Bit : begin
      s16BitFilename := s256ColourFilename + 'B' + PadString(psLeft,IntToStr(iBitmapNo),'0',4);
      s16BitFilename := GetEnterpriseDirectory + 'Lib\' + s16BitFilename;
    end;
//    cm256Colors, cm16Colors, cmMonochrome, cmUnknown : s256ColourFilename := s256ColourFilename + 'A';
  end;

  // Add Bitmap No & Exchequer Lib Dir onto filename
  // We will always Have a 256 Bitmap. Use this as backup if no 16-bit version exists
  s256ColourFilename := s256ColourFilename + 'A' + PadString(psLeft,IntToStr(iBitmapNo),'0',4);
  s256ColourFilename := GetEnterpriseDirectory + 'Lib\' + s256ColourFilename;

  // Check if 16Bit File Exists. Otherwise Default to 256 Colour Version
//  if (s16BitFilename <> '') and FileExists(s16BitFilename)
//  then Result := s16BitFilename
//  else Result := s256ColourFilename;

  // Enterprise can't deal with the 16-bit bitmaps at the moment so
  // always use the 256 colour version
  Result := s256ColourFilename;
end;

function GetBitmapFromECB(asECBFilename : ANSIstring) : TBitmap;
var
//  asZipFile : ANSIString;
  AbUnZipper : TAbUnZipper;
//  AbUnZipper : TAbZipKit;
  BitmapStream : TMemoryStream;
//  iPos : integer;
begin
  Result := nil;
  if not fileexists(asECBFilename) then exit;

  BitmapStream := TMemoryStream.Create;

  AbUnZipper := TAbUnZipper.Create(application);
  with AbUnZipper do begin
    Password := sZipPassword;
    BaseDirectory := ExtractFilePath(asECBFilename);
    FileName := asECBFilename;
    OpenArchive(asECBFilename);

    BitmapStream.Position := 0;
    AbUnZipper.ExtractToStream(ExtractFilename(asECBFilename + '.BMP'),  BitmapStream);
    CloseArchive;
  end;{with}
  AbUnZipper.Free;

  BitmapStream.Position := 0;

  Result := TBitmap.Create;
  Result.LoadFromStream(BitmapStream);
  BitmapStream.Free;
end;
(*
function GetStreamFromECB(asECBFilename : ANSIstring) : TMemoryStream;
var
  asZipFile : ANSIString;
  AbUnZipper : TAbUnZipper;
//  BitmapStream : TMemoryStream;
begin
  Result := TMemoryStream.Create;

  if not fileexists(asECBFilename) then exit;

  asZipFile := asECBFilename + '.zip';
  CopyFile(PChar(asECBFilename), PChar(asZipFile), TRUE);

  AbUnZipper := TAbUnZipper.Create(application);
  with AbUnZipper do begin
    Password := sZipPassword;
    BaseDirectory := ExtractFilePath(asECBFilename);
    FileName := asZipFile;
    AbUnZipper.ExtractToStream(ExtractFilename(asECBFilename + '.bmp'),  Result);
    AbUnZipper.ExtractToStream(ExtractFilename('*.*'),  Result);
//    AbUnZipper.ExtractFiles(ExtractFilename(asECBFilename + '.BMP'));
    CloseArchive;
  end;{with}

//  BitmapStream.Position := 0;
//  Result.LoadFromStream(BitmapStream);
//  Result.LoadFromFile(asECBFilename + '.BMP');
//  BitmapStream.Free;
end;
*)
procedure GetCentreOfBitmap(TheBitmap : TBitmap; TheForm : TForm; iExtraHeight : integer);
// iExtraHeight : The total extra height used in the client area by stuff like toolbars and status bars
var
  FullRect, CentreRect : TRect;
  iMaxClientHeight, iMaxClientWidth : integer;
  CentreBitmap : TBitmap;
begin
  If (Assigned(TheBitmap)) then
  Begin
    // work out max client height / width
    GetMaxClientArea(iMaxClientHeight,iMaxClientWidth, TheForm, iExtraHeight);

    CentreRect.Top := (TheBitmap.Height - iMaxClientHeight) DIV 2;
    CentreRect.Left := (TheBitmap.Width - iMaxClientWidth) DIV 2;
    CentreRect.Right := CentreRect.Left + iMaxClientWidth;
    CentreRect.Bottom := CentreRect.Top + iMaxClientHeight;

    CentreBitmap := TBitmap.Create;
    CentreBitmap.Width := iMaxClientWidth;
    CentreBitmap.Height := iMaxClientHeight;

    FullRect.Top := 0;
    FullRect.Left := 0;
    FullRect.Right := iMaxClientWidth;
    FullRect.Bottom := iMaxClientHeight;

    DeleteObject(CentreBitmap.Palette);
    CentreBitmap.Palette:=CopyPalette(TheBitmap.Palette);
    CentreBitmap.Canvas.CopyRect(FullRect,TheBitmap.Canvas,CentreRect);

    TheBitmap.Width := iMaxClientWidth;
    TheBitmap.Height := iMaxClientHeight;
    TheBitmap.Assign(CentreBitmap);

    CentreBitmap.Free;
  end;{if}
end;

end.

// Standard Resolutions
//
// 800 x 600                    1.333
                // 832 x 624 ?
// 1024 x 768                   1.333
                // 1033 x 837 ?
        // 1152 x 862           1.336
// 1152 x 864                   1.333
        // 1152 x 870           1.324
        // 1152 x 900           1.28
                // 1173 x 781 ?
// 1280 x 1024                  1.25
                // 1500 x 1000 ?
// 1500 x 1100                  1.363
        // 1500 x 1125          1.33
// 1600 x 1200                  1.33


unit Brand;

interface

Uses Classes, ExtCtrls, Forms, Windows, Graphics, Dialogs;

Const
  // Extension of exchequer branding files
  BrandingExt = '.EBF';

  // Relative path from .Exe dir of where the branding files will be
  BrandingSubDir = 'Lib\';

  // Password used to protect the compressed files
  BrandingPW = 'jT3*qQ91]!5A:u@KTB!#';

  // Name of Branding Data File for IProductBrandingData
  BrandingDataFile = 'Data.Txt';

  // Branding Files ----------------------------------------

  ebfCore = 'Core';
  // Core branding file:-
  //
  //   Data.Txt         - System
  //   System.Ico       - Application Icon
  //

  ebfAbout = 'About';
  // Help-About branding file:-
  //
  //   Logo.Bmp         - 143wx221h bmp for the image panel
  //

  ebfOLE = '17363';
  // OLE / Excel Add-Ins branding file:-
  //
  //   Login_16.bmp          - 16 colour Login background - *** Exchequer Only ***
  //   Login_256.bmp         - 256 colour Login background
  //   Login_16M.bmp         - 16 Million colour Login background - *** Exchequer Only ***
  //

  ebfSetup = 'Setup';
  // Installation branding file:-
  //
  //   Data.Txt         - Default Stock Categories
  //   TallWizd.Bmp     - Tall wizard bitmap used on all setup dialogs & many utility dialogs
  //

  ebfSplash = '83F2Q';
  // Splash Screen branding file:-
  //
  //   Data.Txt         - Contains product specific tweaking info for labels on splash screen
  //   Splash_16.bmp    - 16 colour splash screen
  //   Splash_256.bmp   - 256 colour splash screen
  //   Splash_16M.bmp   - 16M colour splash screen
  //

  ebfVRW = 'VRW';
  // VRW Wizard branding file:-
  //
  //   Wiz1_256.bmp
  //   Wiz2_256.bmp
  //   Wiz3_256.bmp
  //   Wiz4_256.bmp
  //   Wiz5_256.bmp
  //   Wiz6_256.bmp

  ebfEnterprise = 'EntSplash'; // NOTE: Used by Enter1 / OLE and not used by splash screen!
  //
  //   B2BAction_256.bmp
  //   b2bwiz_256.bmp
  //   MCM_256.bmp
  //   allowiz_256.bmp
  //

  // MH 05/09/2017 2017-R2 ABSEXCH-18855: Added branding file for Common Login Dialog
  ebfCommonLogin = 'Login';
  //
  //   CommonLogin.bmp
  //


Type
  TProductType = (ptExchequer, ptLITE);
Const
  ProductCodes : Array [TProductType] Of ShortString = ('EXCH', 'LITE');


Type
  // Provides access routines for the Data.Txt file within a branding
  // file, accessed via the pbfData property
  IProductBrandingData = Interface
    ['{9F8D6EE0-4E6E-4B92-8137-8F37F7C8AB42}']
    // --- Internal Methods to implement Public Properties ---

    // ------------------ Public Properties ------------------

    // ------------------- Public Methods --------------------

    // Returns a specified string value from the data, an optional Default can be
    // specified to be returned if the string is not present in Data.Txt.
    Function GetString(Const StrName : ShortString; Const Default : ShortString = '') : ShortString;

    // Returns a specified Integer value from the data, an optional Default can be
    // specified to be returned if the integer is not present in Data.Txt or is invalid
    Function GetInteger(Const IntName : ShortString; Const Default : Integer = 0) : Integer;
  End; // IProductBrandingData

  //------------------------------

  // Provides access functionality for a branding file, created using the
  // IProductBranding.BrandingFile method.
  IProductBrandingFile = Interface
    ['{9E9280BA-D206-435D-BFB5-DCCA1C71CE36}']
    // --- Internal Methods to implement Public Properties ---
    Function GetData : IProductBrandingData;

    // ------------------ Public Properties ------------------
    // Provides access to Data.Txt which stores misc data items for the component
    // represented by the branding file
    Property pbfData : IProductBrandingData Read GetData;

    // ------------------- Public Methods --------------------
    // Extracts a bitmap from the branding file and returns it as the
    // function result, the name should be specified as 'System' for
    // 'System.Bmp'
    Function ExtractBitmap (Const BmpName : ShortString) : TBitmap;

    // Extracts a bitmap from the branding file and returns it as the
    // function result, the bitmap returned depends on the colour depth
    // supported by the form.  The bitmaps should be stored in the branding
    // file as SYSTEM_16.BMP, SYSTEM_256.BMP and SYSTEM_16M.BMP for 16, 256
    // and 16M colours respectively.  When called the BmpName should be
    // specified as 'SYSTEM' and the function will automatically select
    // the correct bitmap from those available.
    Function ExtractBitmapCD (Const ParentForm : TForm; Const BmpName : ShortString) : TBitmap;

    // Extracts an icon from the branding file and returns it as the
    // function result, the name should be specified as 'System' for
    // 'System.Ico'
    Function ExtractIcon (Const IconName : ShortString) : TIcon;

    // Extracts a nominated bitmap from the branding file and copies it
    // into the passed TImage, see ExtractBitmap.
    Procedure ExtractImage (Const DestImage : TImage; Const BmpName : ShortString);

    // Extracts a nominated bitmap from the branding file and copies it
    // into the passed TImage, see ExtractBitmapForForm
    Procedure ExtractImageCD (Const DestImage : TImage; Const BmpName : ShortString);
  End; // IProductBrandingFile

  //------------------------------

  // Base Branding interface - provides global properties and access routines
  // for loading branding information for sub-components
  IProductBranding = Interface
    ['{49595590-430F-4010-B40F-06D2D01A711A}']
    // --- Internal Methods to implement Public Properties ---
    Function GetProduct : TProductType;
    Function GetProductName : ShortString;
    Function GetCompanyName : ShortString;
    Function GetProductIcon : TIcon;
    Function GetCopyright : ShortString;
    Function GetCoreData : IProductBrandingData;

    // ------------------ Public Properties ------------------
    Property pbProduct : TProductType Read GetProduct;
    Property pbProductName : ShortString Read GetProductName;
    Property pbProductIcon : TIcon Read GetProductIcon;
    Property pbCompanyName : ShortString Read GetCompanyName;
    Property pbCopyright : ShortString Read GetCopyright;
    Property pbCoreData : IProductBrandingData Read GetCoreData;

    // ------------------- Public Methods --------------------

    // Returns an IProductBrandingFile instance for the specified branding
    // file, branding files are always assumed to be .EBF files in the lib
    // directory off of the .EXE dir so the name should be specified without
    // path or extension
    Function BrandingFile (Const FileName : ShortString) : IProductBrandingFile;

    // Returns TRUE if the specified Branding File exissts
    Function BrandingFileExists (Const FileName : ShortString) : Boolean;
  End; // IProductBranding

// Redirects the branding directory to another location - branding files will be picked
// up from the LIB directory off of the specified directory.
Procedure InitBranding (Const BrandingDir : ShortString);

// Returns the singleton Branding object
Function Branding : IProductBranding;

implementation

Uses AbUnzper, StrUtil, SysUtils;

Type
  // Implements the IProductBrandingData interface
  TProductBrandingData = Class(TInterfacedObject, IProductBrandingData)
  Private
    FData : TStringList;
  Protected
    // IProductBrandingData -----------------------------------------
    Function GetString(Const StrName : ShortString; Const Default : ShortString = '') : ShortString;
    Function GetInteger(Const IntName : ShortString; Const Default : Integer = 0) : Integer;
  Public
    Constructor Create (Const DataStrings : TStringList);
    Destructor Destroy; Override;
  End; // TProductBrandingData

  //------------------------------

  // Implements the IProductBrandingFile interface
  TProductBrandingFile = Class(TInterfacedObject, IProductBrandingFile)
  Private
    FUnZipper : TAbUnZipper;

    // Common implementation function for ExtractBitmapCD/ExtractImageCD functions
    Function ExtractBitmapForHDC (Const Handle : HDC; Const BmpName : ShortString) : TBitmap;
  Protected
    // IProductBrandingFile -----------------------------------------
    Function GetData : IProductBrandingData;

    // Extracts a bitmap from the branding file and returns it as the
    // function result, the name should be specified as 'System' for
    // 'System.Bmp'
    Function ExtractBitmap (Const BmpName : ShortString) : TBitmap;

    // Extracts a bitmap from the branding file and returns it as the
    // function result, the bitmap returned depends on the colour depth
    // supported by the form.  The bitmaps should be stored in the branding
    // file as SYSTEM_16.BMP, SYSTEM_256.BMP and SYSTEM_16M.BMP for 16, 256
    // and 16M colours respectively.  When called the BmpName should be
    // specified as 'SYSTEM' and the function will automatically select
    // the correct bitmap from those available.
    Function ExtractBitmapCD (Const ParentForm : TForm; Const BmpName : ShortString) : TBitmap;

    // Extracts an icon from the branding file and returns it as the
    // function result, the name should be specified as 'System' for
    // 'System.Ico'
    Function ExtractIcon (Const IconName : ShortString) : TIcon;

    // Extracts a nominated bitmap from the branding file and copies it
    // into the passed TImage, see ExtractBitmap.
    Procedure ExtractImage (Const DestImage : TImage; Const BmpName : ShortString);

    // Extracts a nominated bitmap from the branding file and copies it
    // into the passed TImage, see ExtractBitmapForForm
    Procedure ExtractImageCD (Const DestImage : TImage; Const BmpName : ShortString);
  Public
    Constructor Create (Const FilePath : ShortString);
    Destructor Destroy; Override;
  End; // TProductBrandingFile

  //------------------------------

  // Implements the IProductBranding interface
  TProductBranding = Class(TInterfacedObject, IProductBranding)
  Private
     FBrandingPath : ShortString;
     FCoreIcon     : TIcon;
     FCoreData     : IProductBrandingData;
     FProductType  : TProductType;
  Protected
    // IProductBranding ---------------------------------------------
    Function GetProduct : TProductType;
    Function GetProductName : ShortString;
    Function GetCompanyName : ShortString;
    Function GetProductIcon : TIcon;
    Function GetCopyright : ShortString;
    Function GetCoreData : IProductBrandingData;

    // Returns an IProductBrandingFile instance for the specified branding
    // file, branding files are always assumed to be .EBF files in the lib
    // directory off of the .EXE dir so the name should be specified without
    // path or extension
    Function BrandingFile (Const FileName : ShortString) : IProductBrandingFile;

    // Returns TRUE if the specified Branding File exissts
    Function BrandingFileExists (Const FileName : ShortString) : Boolean;
  Public
    Constructor Create (Const ExePath : ShortString);
    Destructor Destroy; Override;
  End; // TProductBranding

Var
  lBrandingI : IProductBranding;
  lBrandingO : TProductBranding;

//=========================================================================

Procedure InitBranding (Const BrandingDir : ShortString);
Begin // InitBranding
  // Check whether the singleton has already been created, if not then create it
  If (Not Assigned(lBrandingI)) Then
  Begin
    lBrandingO := TProductBranding.Create(BrandingDir);
    lBrandingI := lBrandingO;
  End; // If (Not Assigned(lBrandingI))
End; // InitBranding

//-------------------------------------------------------------------------

Function Branding : IProductBranding;
Begin // Branding
  // If the branding object hasn't already been created by a call to InitBranding
  // then call it now making the assumption that the .Exe is running from the Main
  // Exchequer directory or the main directory of a Local Program Files directory.
  If (Not Assigned (lBrandingI)) Then
  Begin
    InitBranding (ExtractFilePath(Application.ExeName));
  End; // If (Not Assigned (lBrandingI))

  // return the reference to the singleton interface stored in the private local variable
  Result := lBrandingI;
End; // Branding

//=========================================================================

Constructor TProductBrandingData.Create (Const DataStrings : TStringList);
Begin // Create
  Inherited Create;
  FData := DataStrings;
End; // Create

//------------------------------

Destructor TProductBrandingData.Destroy;
Begin // Destroy
  FreeAndNIL(FData);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TProductBrandingData.GetString(Const StrName : ShortString; Const Default : ShortString = '') : ShortString;
Begin // GetString
  If (FData.IndexOfName(StrName) >= 0) Then
    Result := FData.Values[StrName]
  Else
    Result := Default;
End; // GetString

//-------------------------------------------------------------------------

Function TProductBrandingData.GetInteger(Const IntName : ShortString; Const Default : Integer = 0) : Integer;
Var
  sInt       : ShortString;
  iInt, iErr : Integer;
Begin // GetInteger
  If (FData.IndexOfName(IntName) >= 0) Then
  Begin
    sInt := FData.Values[IntName];
    Val(sInt, iInt, iErr);
    If (iErr = 0) Then
      Result := iInt
    Else
      Result := Default;
  End // If (FData.IndexOfName(IntName) >= 0)
  Else
    Result := Default;
End; // GetInteger

//=========================================================================

Constructor TProductBrandingFile.Create (Const FilePath : ShortString);
Var
  iName : SmallInt;
Begin // Create
  Inherited Create;

  FUnZipper := TAbUnZipper.Create(NIL);
  FUnZipper.Password := BrandingPW;
  FUnZipper.BaseDirectory := ExtractFilePath(FilePath);
  FUnZipper.FileName := FilePath;

  FUnZipper.OpenArchive(FUnZipper.FileName);

  If (FUnZipper.Count > 0) Then
  Begin
    For iName := 0 To (FUnZipper.Count - 1) Do
    Begin
      If (Not FUnzipper.Items[iName].IsEncrypted) Then
      Begin
        // File is not password protected - possible hack attempt
        Raise Exception.Create ('Encryption Error 41525345H in Unit ' + ChangeFileExt(ExtractFileName(FilePath), '') + ', Please notify your technical support');
      End; // If (Not AbUnzipper.Items[iName].IsEncrypted)
    End; // For iName
  End; // If (FUnZipper.Count > 0)
End; // Create

//------------------------------

Destructor TProductBrandingFile.Destroy;
Begin // Destroy
  If Assigned(FUnZipper) Then
  Begin
    FUnZipper.CloseArchive;
    FreeAndNIL(FUnZipper);
  End; // If Assigned(FUnZipper)

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Extracts a bitmap from the branding file and returns it as the
// function result, the name should be specified as 'System' for
// 'System.Bmp'
Function TProductBrandingFile.ExtractBitmap (Const BmpName : ShortString) : TBitmap;
Var
  ZipStream  : TMemoryStream;
Begin // ExtractBitmap
  // Always return a valid bitmap to ensure the system doesn't fail
  Result := TBitmap.Create;

  ZipStream := TMemoryStream.Create;
  Try
    FUnZipper.ExtractToStream(BmpName + '.Bmp',  ZipStream);

    If (ZipStream.Size > 0) Then
    Begin
      ZipStream.Position := 0;
      Result.LoadFromStream(ZipStream);
    End; // If (ZipStream.Size > 0)
  Finally
    FreeAndNIL(ZipStream);
  End; // Try..Finally
End; // ExtractBitmap

//------------------------------

// Extracts a nominated bitmap from the branding file and copies it
// into the passed TImage, see ExtractBitmap.
Procedure TProductBrandingFile.ExtractImage (Const DestImage : TImage; Const BmpName : ShortString);
Var
  TmpBmp : TBitmap;
Begin // ExtractImage
  TmpBmp := ExtractBitmap (BmpName);
  Try
    DestImage.Picture.Bitmap.Assign (TmpBmp);
  Finally
    FreeAndNIL(TmpBmp);
  End; // Try..Finally
End; // ExtractImage

//-------------------------------------------------------------------------

Function TProductBrandingFile.ExtractBitmapForHDC (Const Handle : HDC; Const BmpName : ShortString) : TBitmap;
Var
  ZipStream       : TMemoryStream;
  BmpNameArray    : Array [0..3] Of ShortString;
  BitsPerPixel    : Integer;
  iBmp, SearchIdx : Byte;
Begin // ExtractBitmapForHDC
  // Always return a valid bitmap to ensure the system doesn't fail
  Result := TBitmap.Create;

  // Setup an array of filenames to use when looking for the bitmap to load
  BmpNameArray[0] := BmpName + '.Bmp';
  BmpNameArray[1] := BmpName + '_16.Bmp';
  BmpNameArray[2] := BmpName + '_256.Bmp';
  BmpNameArray[3] := BmpName + '_16M.Bmp';

  ZipStream := TMemoryStream.Create;
  Try
    // Get the Bits Per Pixels setting for the form's canvas to determine where
    // to start looking for the bitmaps
    BitsPerPixel := GetDeviceCaps(Handle, BITSPIXEL);
    If (BitsPerPixel >= 16) Then
      SearchIdx := 3   // 65536+ colours
    Else If (BitsPerPixel > 4) Then
      SearchIdx := 2   // 256+ colours
    Else
      SearchIdx := 1;   // < 256 colours

    For iBmp := SearchIdx DownTo 0 Do
    Begin
      If (FUnZipper.FindFile(BmpNameArray[iBmp]) >= 0) Then
      Begin
        FUnZipper.ExtractToStream(BmpNameArray[iBmp],  ZipStream);

        If (ZipStream.Size > 0) Then
        Begin
          ZipStream.Position := 0;
          Result.LoadFromStream(ZipStream);
        End; // If (ZipStream.Size > 0)

        Break;
      End; // If (FUnZipper.FindFile(BmpNameArray[iBmp]) >= 0)
    End; // For iBmp
  Finally
    FreeAndNIL(ZipStream);
  End; // Try..Finally
End; // ExtractBitmapForHDC

//------------------------------

// Extracts a bitmap from the branding file and returns it as the
// function result, the bitmap returned depends on the colour depth
// supported by the form.  The bitmaps should be stored in the branding
// file as SYSTEM_16.BMP, SYSTEM_256.BMP and SYSTEM_16M.BMP for 16, 256
// and 16M colours respectively.  When called the BmpName should be
// specified as 'SYSTEM' and the function will automatically select
// the correct bitmap from those available.
Function TProductBrandingFile.ExtractBitmapCD (Const ParentForm : TForm; Const BmpName : ShortString) : TBitmap;
Begin // ExtractBitmapCD
  If Assigned(ParentForm) Then
  Begin
    Result := ExtractBitmapForHDC (ParentForm.Canvas.Handle, BmpName)
  End // If Assigned(ParentForm)
  Else
    Raise Exception.Create ('ExtractBitmapCD called with NIL Form');
End; // ExtractBitmapCD

//------------------------------

// Extracts a nominated bitmap from the branding file and copies it
// into the passed TImage, see ExtractBitmapCD
Procedure TProductBrandingFile.ExtractImageCD (Const DestImage : TImage; Const BmpName : ShortString);
Var
  TmpBmp : TBitmap;
Begin // ExtractImageCD
  If Assigned(DestImage) Then
  Begin
    TmpBmp := ExtractBitmapForHDC (DestImage.Picture.Bitmap.Canvas.Handle, BmpName);
    Try
      DestImage.Picture.Bitmap.Assign (TmpBmp);
    Finally
      FreeAndNIL(TmpBmp);
    End; // Try..Finally
  End // If Assigned(DestImage)
  Else
    Raise Exception.Create ('ExtractImageCD called with NIL Image');
End; // ExtractImageCD

//-------------------------------------------------------------------------

// Extracts an icon from the branding file and returns it as the
// function result, the name should be specified as 'System' for
// 'System.Ico'
Function TProductBrandingFile.ExtractIcon (Const IconName : ShortString) : TIcon;
Var
  ZipStream  : TMemoryStream;
Begin // ExtractIcon
  // Always return a valid icon to ensure the system doesn't fail
  Result := TIcon.Create;

  ZipStream := TMemoryStream.Create;
  Try
    FUnZipper.ExtractToStream(IconName + '.Ico',  ZipStream);

    If (ZipStream.Size > 0) Then
    Begin
      ZipStream.Position := 0;
      Result.LoadFromStream(ZipStream);
    End; // If (ZipStream.Size > 0)
  Finally
    FreeAndNIL(ZipStream);
  End; // Try..Finally
End; // ExtractIcon

//-------------------------------------------------------------------------

Function TProductBrandingFile.GetData : IProductBrandingData;
Var
  ZipStream : TMemoryStream;
  StrList   : TStringList;
Begin // GetData
  StrList := TStringList.Create;

  If (FUnZipper.FindFile(BrandingDataFile) >= 0) Then
  Begin
    ZipStream := TMemoryStream.Create;
    Try
      FUnZipper.ExtractToStream(BrandingDataFile,  ZipStream);

      If (ZipStream.Size > 0) Then
      Begin
        ZipStream.Position := 0;
        StrList.LoadFromStream(ZipStream);
      End; // If (ZipStream.Size > 0)
    Finally
      FreeAndNIL(ZipStream);
    End; // Try..Finally
  End; // If (FUnZipper.FindFile(BrandingDataFile) >= 0)

  // Always return a valid TStringList to ensure the system doesn't fail
  Result := TProductBrandingData.Create(StrList);
End; // GetData

//=========================================================================

Constructor TProductBranding.Create (Const ExePath : ShortString);
Var
  CoreBranding : IProductBrandingFile;
  sProduct     : ShortString;
  iProduct     : TProductType;
Begin // Create
  Inherited Create;

  FBrandingPath := ExtractFilePath(ExePath) + BrandingSubDir;

  // Automatically load the standard branding info
  If BrandingFileExists (ebfCore) Then
  Begin
    CoreBranding := TProductBrandingFile.Create (FBrandingPath + ebfCore + BrandingExt);
    Try
      // Keep reference to Core Data file containing standard text strings - company name, product name, etc...
      FCoreData := CoreBranding.pbfData;

      // Determine the Product
      sProduct := UpperCase(FCoreData.GetString('ProductType', ProductCodes[ptExchequer]));
      For iProduct := Low(TProductType) To High(TProductType) Do
      Begin
        If (sProduct = ProductCodes[iProduct]) Then
        Begin
          FProductType := iProduct;
          Break;
        End; // If (sProduct = ProductCodes[iProduct])
      End; // For iProduct

      // System Icon
      FCoreIcon := CoreBranding.ExtractIcon ('System');
    Finally
      CoreBranding := NIL;
    End; //
  End // If FileExists(FBrandingPath + ebfCore + BrandingExt)
  Else
  Begin
    // Fake it
    MessageDlg('Error 42: Core program files missing from ' + FBrandingPath + ', please contact your Technical Support', mtError, [mbOK], 0);
    FCoreData := NIL;
    FCoreIcon := NIL;
  End; // Else
End; // Create

//------------------------------

Destructor TProductBranding.Destroy;
Begin // Destroy
  FCoreData := NIL;
  FreeAndNIL(FCoreIcon);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Returns TRUE if the specified Branding File exissts
Function TProductBranding.BrandingFileExists (Const FileName : ShortString) : Boolean;
Begin // BrandingFileExists
  Result := FileExists(FBrandingPath + FileName + BrandingExt);
End; // BrandingFileExists

//-------------------------------------------------------------------------

// Returns an IProductBrandingFile instance for the specified branding
// file, branding files are always assumed to be .EBF files in the lib
// directory off of the .EXE dir so the name should be specified without
// path or extension
Function TProductBranding.BrandingFile (Const FileName : ShortString) : IProductBrandingFile;
Begin // BrandingFile
  Result := TProductBrandingFile.Create(FBrandingPath + FileName + BrandingExt);
End; // BrandingFile

//-------------------------------------------------------------------------

Function TProductBranding.GetProduct : TProductType;
Begin // GetProduct
  If Assigned(FCoreData) Then
    Result := FProductType
  Else
    Result := ptExchequer;
End; // GetProduct

//------------------------------

Function TProductBranding.GetProductName : ShortString;
Begin // GetProductName
  If Assigned(FCoreData) Then
    Result := FCoreData.GetString('Name', 'Exchequer')
  Else
    Result := 'Exchequer';
End; // GetProductName

//------------------------------

Function TProductBranding.GetCompanyName : ShortString;
Begin // GetCompanyName
  If Assigned(FCoreData) Then
    Result := FCoreData.GetString('Company', 'Advanced Enterprise Software Ltd')
  Else
    Result := 'Advanced Enterprise Software Ltd';
End; // GetCompanyName

//------------------------------

Function TProductBranding.GetCopyright : ShortString;
Begin // GetCopyright
  If Assigned(FCoreData) Then
    Result := FCoreData.GetString('Copyright', GetCopyrightMessage)
  Else
    Result := GetCopyrightMessage
End; // GetCopyright

//------------------------------

Function TProductBranding.GetProductIcon : TIcon;
Begin // GetProductIcon
  If Assigned(FCoreData) Then
    Result := FCoreIcon
  Else
    Result := Application.Icon;
End; // GetProductIcon

//------------------------------

Function TProductBranding.GetCoreData : IProductBrandingData;
Begin // GetCoreData
  Result := FCoreData;
End; // GetCoreData

//-------------------------------------------------------------------------

Initialization
  lBrandingO := NIL;
  lBrandingI := NIL;
Finalization
  lBrandingO := NIL;
  lBrandingI := NIL;
end.

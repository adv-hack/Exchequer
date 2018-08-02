unit MemoryMap;

interface

{$ALIGN 1}

Uses Classes, Dialogs, Forms, SysUtils, Windows, BlowFish;

Const
  MaxCompanyDetails = 1000;
  MaxLengthCompanyCode = 6;
  MaxLengthUserId = 12;
  MaxLengthPassword = 9;

Type
  TGlobalOLEServerData_CompanyDetails = Record
    cdCompanyCode : String[MaxLengthCompanyCode];    // NOT Encrypted
    cdUserId      : String[MaxLengthUserId + 10];    // Encrypted - Blowfish generates 22 chars
    cdPassword    : String[MaxLengthPassword + 13];  // Encrypted - Blowfish generates 22 chars
  End; // TGlobalOLEServerData_CompanyDetails

  //------------------------------

  pGlobalOLEServerData = ^TGlobalOLEServerData;
  TGlobalOLEServerData = Record  // 70000 bytes
    osdDefined         : Boolean;
    osdVersion         : Byte;

    // Number of defined elements in the osdCompanies array
    osdCompanyCount    : Integer;

    // Company Details
    osdCompanies       : Array [1..MaxCompanyDetails] of TGlobalOLEServerData_CompanyDetails;

    // For future expandibility - pads structure to 70,000 bytes
    osdSpare           : Array [1..16994] Of Byte;
  End; // TGlobalOLEServerData

  //------------------------------

  {$IFNDEF WRITEONLY} // Exclude Read and Decryption Code
  // Generic interface for objects which implement a specific import type
  IOLEServerMemoryMapCompanyDetails = Interface
    ['{9A75AA26-E229-4030-9A74-1549E90C7A7B}']
    // --- Internal Methods to implement Public Properties ---
    Function GetCompanyCode : ShortString;
    Function GetUserID : ShortString;
    Function GetPassword : ShortString;

    // ------------------ Public Properties ------------------
    Property cdCompanyCode : ShortString Read GetCompanyCode;
    Property cdUserID : ShortString Read GetUserID;
    Property cdPassword : ShortString Read GetPassword;

    // ------------------- Public Methods --------------------
  End; // IOLEServerMemoryMapCompanyDetails
  {$ENDIF}

  //------------------------------

  TOLEServerMemoryMap = Class(TObject)
  Private
    FGlobalData : pGlobalOLEServerData;
    FMapHandle  : THandle;
    FInitGlobalData : Boolean;
    FBlowfish : TBlowfish;

    Procedure SetVector;
    Function EncryptString (Const PlainText : String) : String;
    {$IFNDEF WRITEONLY} // Exclude Read and Decryption Code
    Function DecryptString (Const EncodedText : String) : String;
    {$ENDIF}

    Procedure InitMemMap(Const InitSettings : Boolean);

    Function GetDefined : Boolean;
    {$IFNDEF WRITEONLY} // Exclude Read and Decryption Code
    Function GetCompanyCount : LongInt;
    Function GetCompanies(Index: LongInt): IOLEServerMemoryMapCompanyDetails;
    {$ENDIF}
    Function GetVersion : Byte;
  Public
    Constructor Create (Const InitGlobalData : Boolean);
    Destructor Destroy; OverRide;

    Function AddCompany (Const CompanyCode, UserId, Password : String) : Integer;
    Procedure Clear;

    Property Defined : Boolean Read GetDefined;
    {$IFNDEF WRITEONLY} // Exclude Read and Decryption Code
    Property CompanyCount : LongInt Read GetCompanyCount;
    Property Companies [Index: LongInt] : IOLEServerMemoryMapCompanyDetails Read GetCompanies;
    {$ENDIF}
    Property Version : Byte Read GetVersion;

//    Function IndexOf (VariableName : ShortString) : LongInt;
  End; // TOLEServerMemoryMap

  //------------------------------

Var
  GlobalOLEMemoryMap : TOLEServerMemoryMap;

implementation

{$IFNDEF WRITEONLY} // Exclude Read and Decryption Code
Type
  TDecryptFunc = Function (Const EncodedText : String) : String of Object;

  //------------------------------

  TOLEServerMemoryMapCompanyDetails = Class(TInterfacedObject, IOLEServerMemoryMapCompanyDetails)
  Private
    FCompanyDetails : TGlobalOLEServerData_CompanyDetails;
    FDecryptFunc : TDecryptFunc;
  Protected
    Function GetCompanyCode : ShortString;
    Function GetUserID : ShortString;
    Function GetPassword : ShortString;
  Public
    Constructor Create (Const CompanyDetails : TGlobalOLEServerData_CompanyDetails; Const DecryptFunc : TDecryptFunc);
  End; { TOLEServerMemoryMapCompanyDetails }

//=========================================================================

Constructor TOLEServerMemoryMapCompanyDetails.Create (Const CompanyDetails : TGlobalOLEServerData_CompanyDetails; Const DecryptFunc : TDecryptFunc);
Begin // Create
  Inherited Create;
  FCompanyDetails := CompanyDetails;
  FDecryptFunc := DecryptFunc;
End; // Create

//-------------------------------------------------------------------------

Function TOLEServerMemoryMapCompanyDetails.GetCompanyCode : ShortString;
Begin // GetCompanyCode
  Result := FCompanyDetails.cdCompanyCode;
End; // GetCompanyCode

//------------------------------

Function TOLEServerMemoryMapCompanyDetails.GetUserID : ShortString;
Begin // GetUserID
  Result := FDecryptFunc(FCompanyDetails.cdUserId);
End; // GetUserID

//------------------------------

Function TOLEServerMemoryMapCompanyDetails.GetPassword : ShortString;
Begin // GetPassword
  Result := FDecryptFunc(FCompanyDetails.cdPassword);
End; // GetPassword
{$ENDIF}

//=========================================================================

Constructor TOLEServerMemoryMap.Create (Const InitGlobalData : Boolean);
const
  cMMFileName : PChar = 'ALFA705';
Var
  Size: Integer;
Begin // Create
  Inherited Create;

  FInitGlobalData := InitGlobalData;

  { Get the size of the data to be mapped. }
  Size := SizeOf(TGlobalOLEServerData);

  { Now get a memory-mapped file object. Note the first parameter passes
    the value $FFFFFFFF or DWord(-1) so that space is allocated from the system's
    paging file. This requires that a name for the memory-mapped
    object get passed as the last parameter. }

  FMapHandle := CreateFileMapping(DWord(-1), nil, PAGE_READWRITE, 0, Size, cMMFileName);

  If (FMapHandle <> 0) Then
  Begin
    { Now map the data to the calling process's address space and get a
      pointer to the beginning of this address }
    FGlobalData := MapViewOfFile(FMapHandle, FILE_MAP_ALL_ACCESS, 0, 0, Size);

    If (Not Assigned(FGlobalData)) Then
    Begin
      // Error
      CloseHandle(FMapHandle);
      RaiseLastOSError;
    End { If (Not Assigned(FGlobalData)) }
    Else
      // OK
      If FInitGlobalData Then InitMemMap(True);
  End { If (FMapHandle <> 0) }
  Else
    { CreateFileMapping generated an error }
    RaiseLastOSError;

  // Initialise Blowfish encryption component
  FBlowfish := TBlowfish.Create(nil);
  FBlowfish.CipherMode := CBC;        // CBC is more secure than ECB
  FBlowfish.StringMode := smEncode;   // let component handle nulls in encrypted string
  // Initialise the encryption - ** This strings must NOT be changed once the build has been released **
  FBlowfish.InitialiseString('ak_2hx23£$($sFas@#[xha8ASacm%3hS$QqQ\9');
End; // Create

//------------------------------

Destructor TOLEServerMemoryMap.Destroy;
Begin // Destroy
  If FInitGlobalData Then
    // Remove settings - overwrite memory
    InitMemMap(False);

  UnmapViewOfFile(FGlobalData);
  CloseHandle(FMapHandle);

  If Assigned(FBlowFish) Then
  Begin
    FBlowfish.Burn;
    FreeAndNIL(FBlowfish);
  End; // If Assigned(FBlowFish)

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TOLEServerMemoryMap.InitMemMap(Const InitSettings : Boolean);
Begin // InitMemMap
  FillChar (FGlobalData^, SizeOf(FGlobalData^), #0);
  If InitSettings Then
  Begin
    With FGlobalData^ Do
    Begin
      osdDefined := True;
      osdVersion := 1;

      osdCompanyCount := 0;
    End; // With FGlobalData^
  End; // If InitSettings
End; // InitMemMap

//-------------------------------------------------------------------------

Procedure TOLEServerMemoryMap.Clear;
Begin // Clear
  InitMemMap(True);
End; // Clear

//-------------------------------------------------------------------------

{$IFNDEF WRITEONLY} // Exclude Read and Decryption Code
Function TOLEServerMemoryMap.GetCompanyCount : LongInt;
Begin // GetCompanyCount
  Result := FGlobalData.osdCompanyCount;
End; // GetCompanyCount
{$ENDIF}

//------------------------------

{$IFNDEF WRITEONLY} // Exclude Read and Decryption Code
Function TOLEServerMemoryMap.GetCompanies(Index: LongInt): IOLEServerMemoryMapCompanyDetails;
Begin // GetCompanies
  With FGlobalData^ Do
    If (Index >= Low(osdCompanies)) And (Index <= High(osdCompanies)) Then
      Result := TOLEServerMemoryMapCompanyDetails.Create (FGlobalData.osdCompanies[Index], DecryptString)
    Else
      Raise SysUtils.Exception.Create('TOLEServerMemoryMap.GetCompanies: Invalid Index (' + IntToStr(Index) + ')');
End; // GetCompanies
{$ENDIF}

//-------------------------------------------------------------------------

Function TOLEServerMemoryMap.GetDefined : Boolean;
Begin // GetDefined
  Result := FGlobalData.osdDefined;
End; // GetDefined

//------------------------------

Function TOLEServerMemoryMap.GetVersion : Byte;
Begin // GetVersion
  Result := FGlobalData.osdVersion;
End; // GetVersion

//-------------------------------------------------------------------------

Procedure TOLEServerMemoryMap.SetVector;
Begin // SetVector
  // ** This strings must NOT be changed once the build has been released **
  FBlowfish.LoadIVString('Skj*£d_h23');
End; // SetVector

//------------------------------

Function TOLEServerMemoryMap.EncryptString (Const PlainText : String) : String;
Begin // EncryptString
  SetVector;
  FBlowfish.EncString(PlainText, Result);
End; // EncryptString

//------------------------------

{$IFNDEF WRITEONLY} // Exclude Read and Decryption Code
Function TOLEServerMemoryMap.DecryptString (Const EncodedText : String) : String;
Begin // DecryptString
  SetVector;
  FBlowfish.DecString(EncodedText, Result);
End; // DecryptString
{$ENDIF}

//-------------------------------------------------------------------------

// The following return values are expected:-
//
//   0   Success
//   2   Memory Map not created
//   3   Out of space - the memory map is full
//   4   Invalid Company Code
//   5   Invalid User Id
//   6   Invalid Password
//
Function TOLEServerMemoryMap.AddCompany (Const CompanyCode, UserId, Password : String) : Integer;
Begin // AddCompany
  With FGlobalData^ Do
  Begin
    // Check for space to add another login
    If osdDefined Then
    Begin
      If (osdCompanyCount < High(osdCompanies)) Then
      Begin
        // Validate the Company Code - must be set
        If (CompanyCode <> '') And (Length(CompanyCode) <= MaxLengthCompanyCode) Then
        Begin
          // Validate the User Id - must be set
          If (UserId <> '') And (Length(UserId) <= MaxLengthUserId) Then
          Begin
            // Validate the Password - can be left blank but must be less than max length
            If (Length(Password) <= MaxLengthPassword) Then
            Begin
              // Setup the next free element in the array
              Inc (osdCompanyCount);
              FillChar(osdCompanies[osdCompanyCount], SizeOf(osdCompanies[osdCompanyCount]), #0);
              With osdCompanies[osdCompanyCount] Do
              Begin
                cdCompanyCode := Trim(UpperCase(CompanyCode));
                cdUserId      := EncryptString (Trim(UpperCase(UserId)));
                cdPassword    := EncryptString (Trim(UpperCase(Password)));
              End; // With osdCompanies[osdCompanyCount]

              Result := 0;
            End // If (Length(Password) <= MaxLengthPassword)
            Else
              Result := 6; // Invalid Password
          End // If (UserId <> '') And (Length(UserId) <= MaxLengthUserId)
          Else
            Result := 5; // Invalid User Id
        End // If (CompanyCode <> '') And (Length(CompanyCode) <= MaxLengthCompanyCode)
        Else
          Result := 4; // Invalid Company Code
      End // If (osdCompanyCount < High(osdCompanies))
      Else
        Result := 3; // Out of space - the memory map is full
    End // If osdDefined
    Else
      Result := 2;  // Memory Map not created
  End; // With FGlobalData^
End; // AddCompany

//=========================================================================

Initialization
  GlobalOLEMemoryMap := NIL;

  // Ensure the size never changes - 70,000 bytes
  If (SizeOf(TGlobalOLEServerData) <> 70000) Then
    ShowMessage ('MemoryMap.Pas - Incorrect TGlobalOLEServerData Size (' + IntToStr(SizeOf(TGlobalOLEServerData)) + ')');
Finalization
  If Assigned(GlobalOLEMemoryMap) Then
    FreeAndNil(GlobalOLEMemoryMap);
end.

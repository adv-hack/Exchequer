Unit oIni;

Interface

Uses Classes, Forms, IniFiles, SysUtils, Windows;

Type
  TPPDSettingIni = Class(TObject)
  Private
    FIniFile : TIniFile;
    FCompanyCode : String;

    FError : Boolean;
    FUDefMode : Integer;
    FLocationCode : String;
    FCostCentreCode : String;
    FDepartmentCode : String;

    Function GetValid : Boolean;
    Procedure ReadCompanySettings;
  Public
    Property CostCentre : String Read FCostCentreCode;
    Property Department : String Read FDepartmentCode;
    Property LocationCode : String Read FLocationCode;
    Property UserDefinedFieldNo : Integer Read FUDefMode;
    Property Valid : Boolean Read GetValid;

    Constructor Create (Const CompanyCode : String);
    Destructor Destroy; Override;
  End; // TPPDSettingIni

Implementation

//=========================================================================

Constructor TPPDSettingIni.Create (Const CompanyCode : String);
Var
  Buffer : array[0..255] of Char;
  IniName : ShortString;
  Len    : SmallInt;
Begin // Create
  Inherited Create;

  FError := False;
  FUDefMode := 0;
  FLocationCode := '';
  FCostCentreCode := '';
  FDepartmentCode := '';

  FCompanyCode := CompanyCode;

  // Calculate name of .INI file
  Len := GetModuleFileName(HInstance, Buffer, SizeOf(Buffer));
  If (Len > 0) Then
  Begin
    FIniFile := TIniFile.Create (ChangeFileExt(Buffer, '.Ini'));
    ReadCompanySettings;
  End; // If (Len > 0)
End; // Create

//------------------------------

Destructor TPPDSettingIni.Destroy;
Begin // TPPDSettingIni
  FIniFile.Free;
  Inherited Destroy;
End; // TPPDSettingIni

//-------------------------------------------------------------------------

Function TPPDSettingIni.GetValid : Boolean;
Begin // GetValid
  Result := Assigned(FIniFile) And (Not FError) And (FUDefMode <> 0);
End; // GetValid

//-------------------------------------------------------------------------

Procedure TPPDSettingIni.ReadCompanySettings;
Begin // ReadCompanySettings
  If Assigned(FIniFile) Then
  Begin
    FError := Not FIniFile.SectionExists(FCompanyCode);

    FUDefMode :=  FIniFile.ReadInteger(FCompanyCode, 'TakenUDef', 0);
    FLocationCode := FIniFile.ReadString(FCompanyCode, 'Location', '');
    FCostCentreCode := FIniFile.ReadString(FCompanyCode, 'CostCentre', '');
    FDepartmentCode := FIniFile.ReadString(FCompanyCode, 'Department', '');
  End; // If Assigned(FIniFile)
End; // ReadCompanySettings

//-------------------------------------------------------------------------

End.
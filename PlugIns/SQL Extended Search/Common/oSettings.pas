unit oSettings;

interface

Uses Classes, SysUtils, IniFiles, StrUtils;

Type
  //
  TExtendedSearchSettings = Class(TObject)
  Private
    FIniPath : ShortString;

    FCULinkActive : Boolean;
    FSTLinkActive : Boolean;
    FJCLinkActive : Boolean;

    FCUCode : Boolean;
    FCUCompany : Boolean;
    FCUAddress1 : Boolean;
    FCUAddress2 : Boolean;
    FCUAddress3 : Boolean;
    FCUAddress4 : Boolean;
    FCUAddress5 : Boolean;
    FCUPostCode : Boolean;
    FCUDelAddress1 : Boolean;
    FCUDelAddress2 : Boolean;
    FCUDelAddress3 : Boolean;
    FCUDelAddress4 : Boolean;
    FCUDelAddress5 : Boolean;
    FCUContact : Boolean;
    FCUPhone1 : Boolean;
    FCUPhone2 : Boolean;
    FCUPhone3 : Boolean;
    FCUEMailID : Boolean;
    FCUTheirAccount : Boolean;
    FCUInvoiceTo : Boolean;
    FCUAccType : Boolean;
    FCUUser1 : Boolean;
    FCUUser2 : Boolean;
    FCUUser3 : Boolean;
    FCUUser4 : Boolean;
    FCUUser5 : Boolean;
    FCUUser6 : Boolean;
    FCUUser7 : Boolean;
    FCUUser8 : Boolean;
    FCUUser9 : Boolean;
    FCUUser10 : Boolean;
    FCUVATNo : Boolean;
    FCUArea : Boolean;

    FSTCode : Boolean;
    FSTDesc1 : Boolean;
    FSTDesc2 : Boolean;
    FSTDesc3 : Boolean;
    FSTDesc4 : Boolean;
    FSTDesc5 : Boolean;
    FSTDesc6 : Boolean;
    FSTPrefSupp : Boolean;
    FSTAltCode : Boolean;
    FSTLocation : Boolean;
    FSTBarCode : Boolean;
    FSTBinCode : Boolean;
    FSTUnitStock : Boolean;
    FSTUnitPurchase : Boolean;
    FSTUnitSale : Boolean;
    FSTUser1 : Boolean;
    FSTUser2 : Boolean;
    FSTUser3 : Boolean;
    FSTUser4 : Boolean;
    FSTUser5 : Boolean;
    FSTUser6 : Boolean;
    FSTUser7 : Boolean;
    FSTUser8 : Boolean;
    FSTUser9 : Boolean;
    FSTUser10 : Boolean;
    FSTAppendDesc : Boolean;

    FJCCode : Boolean;
    FJCDesc1 : Boolean;
    FJCJobContact : Boolean;
    FJCJobManager : Boolean;
    FJCCustCode : Boolean;
    FJCAltCode : Boolean;
    FJCJobType : Boolean;
    FJCSORRef : Boolean;
    FJCUser1 : Boolean;
    FJCUser2 : Boolean;
    FJCUser3 : Boolean;
    FJCUser4 : Boolean;
    FJCUser5 : Boolean;
    FJCUser6 : Boolean;
    FJCUser7 : Boolean;
    FJCUser8 : Boolean;
    FJCUser9 : Boolean;
    FJCUser10 : Boolean;

    FMaxRowsReturned : Integer;
    FConnectionTimeout : Integer;
    FCommandTimeout : Integer;

    FGLSalesColourRed : ShortString;
    FGLSalesColourBlue : ShortString;

    Procedure SetCULinkActive (Value : Boolean);
    Procedure SetSTLinkActive (Value : Boolean);
    Procedure SetJCLinkActive (Value : Boolean);

    Procedure SetCUCode (Value : Boolean);
    Procedure SetCUCompany (Value : Boolean);
    Procedure SetCUAddress1 (Value : Boolean);
    Procedure SetCUAddress2 (Value : Boolean);
    Procedure SetCUAddress3 (Value : Boolean);
    Procedure SetCUAddress4 (Value : Boolean);
    Procedure SetCUAddress5 (Value : Boolean);
    Procedure SetCUPostCode (Value : Boolean);
    Procedure SetCUDelAddress1 (Value : Boolean);
    Procedure SetCUDelAddress2 (Value : Boolean);
    Procedure SetCUDelAddress3 (Value : Boolean);
    Procedure SetCUDelAddress4 (Value : Boolean);
    Procedure SetCUDelAddress5 (Value : Boolean);
    Procedure SetCUContact (Value : Boolean);
    Procedure SetCUPhone1 (Value : Boolean);
    Procedure SetCUPhone2 (Value : Boolean);
    Procedure SetCUPhone3 (Value : Boolean);
    Procedure SetCUEMailID (Value : Boolean);
    Procedure SetCUTheirAccount (Value : Boolean);
    Procedure SetCUInvoiceTo (Value : Boolean);
    Procedure SetCUAccType (Value : Boolean);
    Procedure SetCUUser1 (Value : Boolean);
    Procedure SetCUUser2 (Value : Boolean);
    Procedure SetCUUser3 (Value : Boolean);
    Procedure SetCUUser4 (Value : Boolean);
    Procedure SetCUUser5 (Value : Boolean);
    Procedure SetCUUser6 (Value : Boolean);
    Procedure SetCUUser7 (Value : Boolean);
    Procedure SetCUUser8 (Value : Boolean);
    Procedure SetCUUser9 (Value : Boolean);
    Procedure SetCUUser10 (Value : Boolean);
    Procedure SetCUVATNo (Value : Boolean);
    Procedure SetCUArea (Value : Boolean);

    Procedure SetSTCode (Value : Boolean);
    Procedure SetSTDesc1 (Value : Boolean);
    Procedure SetSTDesc2 (Value : Boolean);
    Procedure SetSTDesc3 (Value : Boolean);
    Procedure SetSTDesc4 (Value : Boolean);
    Procedure SetSTDesc5 (Value : Boolean);
    Procedure SetSTDesc6 (Value : Boolean);
    Procedure SetSTPrefSupp (Value : Boolean);
    Procedure SetSTAltCode (Value : Boolean);
    Procedure SetSTLocation (Value : Boolean);
    Procedure SetSTBarCode (Value : Boolean);
    Procedure SetSTBinCode (Value : Boolean);
    Procedure SetSTUnitStock (Value : Boolean);
    Procedure SetSTUnitPurchase (Value : Boolean);
    Procedure SetSTUnitSale (Value : Boolean);
    Procedure SetSTUser1 (Value : Boolean);
    Procedure SetSTUser2 (Value : Boolean);
    Procedure SetSTUser3 (Value : Boolean);
    Procedure SetSTUser4 (Value : Boolean);
    Procedure SetSTUser5 (Value : Boolean);
    Procedure SetSTUser6 (Value : Boolean);
    Procedure SetSTUser7 (Value : Boolean);
    Procedure SetSTUser8 (Value : Boolean);
    Procedure SetSTUser9 (Value : Boolean);
    Procedure SetSTUser10 (Value : Boolean);

    Procedure SetJCCode (Value : Boolean);
    Procedure SetJCDesc1 (Value : Boolean);
    Procedure SetJCJobContact (Value : Boolean);
    Procedure SetJCJobManager (Value : Boolean);
    Procedure SetJCCustCode (Value : Boolean);
    Procedure SetJCAltCode (Value : Boolean);
    Procedure SetJCJobType (Value : Boolean);
    Procedure SetJCSORRef (Value : Boolean);
    Procedure SetJCUser1 (Value : Boolean);
    Procedure SetJCUser2 (Value : Boolean);
    Procedure SetJCUser3 (Value : Boolean);
    Procedure SetJCUser4 (Value : Boolean);
    Procedure SetJCUser5 (Value : Boolean);
    Procedure SetJCUser6 (Value : Boolean);
    Procedure SetJCUser7 (Value : Boolean);
    Procedure SetJCUser8 (Value : Boolean);
    Procedure SetJCUser9 (Value : Boolean);
    Procedure SetJCUser10 (Value : Boolean);
  Public
    Property CULinkActive : Boolean Read FCULinkActive Write SetCULinkActive;
    Property STLinkActive : Boolean Read FSTLinkActive Write SetSTLinkActive;
    Property JCLinkActive : Boolean Read FJCLinkActive Write SetJCLinkActive;

    Property CUCode : Boolean Read FCUCode Write SetCUCode;
    Property CUCompany : Boolean Read FCUCompany Write SetCUCompany;
    Property CUAddress1 : Boolean Read FCUAddress1 Write SetCUAddress1;
    Property CUAddress2 : Boolean Read FCUAddress2 Write SetCUAddress2;
    Property CUAddress3 : Boolean Read FCUAddress3 Write SetCUAddress3;
    Property CUAddress4 : Boolean Read FCUAddress4 Write SetCUAddress4;
    Property CUAddress5 : Boolean Read FCUAddress5 Write SetCUAddress5;
    Property CUPostCode : Boolean Read FCUPostCode Write SetCUPostCode;
    Property CUDelAddress1 : Boolean Read FCUDelAddress1 Write SetCUDelAddress1;
    Property CUDelAddress2 : Boolean Read FCUDelAddress2 Write SetCUDelAddress2;
    Property CUDelAddress3 : Boolean Read FCUDelAddress3 Write SetCUDelAddress3;
    Property CUDelAddress4 : Boolean Read FCUDelAddress4 Write SetCUDelAddress4;
    Property CUDelAddress5 : Boolean Read FCUDelAddress5 Write SetCUDelAddress5;
    Property CUContact : Boolean Read FCUContact Write SetCUContact;
    Property CUPhone1 : Boolean Read FCUPhone1 Write SetCUPhone1;
    Property CUPhone2 : Boolean Read FCUPhone2 Write SetCUPhone2;
    Property CUPhone3 : Boolean Read FCUPhone3 Write SetCUPhone3;
    Property CUEMailID : Boolean Read FCUEMailID Write SetCUEMailID;
    Property CUTheirAccount : Boolean Read FCUTheirAccount Write SetCUTheirAccount;
    Property CUInvoiceTo : Boolean Read FCUInvoiceTo Write SetCUInvoiceTo;
    Property CUAccType : Boolean Read FCUAccType Write SetCUAccType;
    Property CUUser1    : Boolean Read FCUUser1 Write SetCUUser1;
    Property CUUser2    : Boolean Read FCUUser2 Write SetCUUser2;
    Property CUUser3    : Boolean Read FCUUser3 Write SetCUUser3;
    Property CUUser4    : Boolean Read FCUUser4 Write SetCUUser4;
    Property CUUser5    : Boolean Read FCUUser5 Write SetCUUser5;
    Property CUUser6    : Boolean Read FCUUser6 Write SetCUUser6;
    Property CUUser7    : Boolean Read FCUUser7 Write SetCUUser7;
    Property CUUser8    : Boolean Read FCUUser8 Write SetCUUser8;
    Property CUUser9    : Boolean Read FCUUser9 Write SetCUUser9;
    Property CUUser10   : Boolean Read FCUUser10 Write SetCUUser10;
    Property CUVATNo : Boolean Read FCUVATNo Write SetCUVATNo;
    Property CUArea : Boolean Read FCUArea Write SetCUArea;

    Property STCode : Boolean Read FSTCode Write SetSTCode;
    Property STDesc1 : Boolean Read FSTDesc1 Write SetSTDesc1;
    Property STDesc2 : Boolean Read FSTDesc2 Write SetSTDesc2;
    Property STDesc3 : Boolean Read FSTDesc3 Write SetSTDesc3;
    Property STDesc4 : Boolean Read FSTDesc4 Write SetSTDesc4;
    Property STDesc5 : Boolean Read FSTDesc5 Write SetSTDesc5;
    Property STDesc6 : Boolean Read FSTDesc6 Write SetSTDesc6;
    Property STPrefSupp : Boolean Read FSTPrefSupp Write SetSTPrefSupp;
    Property STAltCode : Boolean Read FSTAltCode Write SetSTAltCode;
    Property STLocation : Boolean Read FSTLocation Write SetSTLocation;
    Property STBarCode : Boolean Read FSTBarCode Write SetSTBarCode;
    Property STBinCode : Boolean Read FSTBinCode Write SetSTBinCode;
    Property STUnitStock : Boolean Read FSTUnitStock Write SetSTUnitStock;
    Property STUnitPurchase : Boolean Read FSTUnitPurchase Write SetSTUnitPurchase;
    Property STUnitSale : Boolean Read FSTUnitSale Write SetSTUnitSale;
    Property STUser1 : Boolean Read FSTUser1 Write SetSTUser1;
    Property STUser2 : Boolean Read FSTUser2 Write SetSTUser2;
    Property STUser3 : Boolean Read FSTUser3 Write SetSTUser3;
    Property STUser4 : Boolean Read FSTUser4 Write SetSTUser4;
    Property STUser5 : Boolean Read FSTUser5 Write SetSTUser5;
    Property STUser6 : Boolean Read FSTUser6 Write SetSTUser6;
    Property STUser7 : Boolean Read FSTUser7 Write SetSTUser7;
    Property STUser8 : Boolean Read FSTUser8 Write SetSTUser8;
    Property STUser9 : Boolean Read FSTUser9 Write SetSTUser9;
    Property STUser10 : Boolean Read FSTUser10 Write SetSTUser10;
    Property STAppendDesc : Boolean Read FSTAppendDesc Write FSTAppendDesc;

    Property JCCode : Boolean Read FJCCode Write SetJCCode;
    Property JCDesc1 : Boolean Read FJCDesc1 Write SetJCDesc1;
    Property JCJobContact : Boolean Read FJCJobContact Write SetJCJobContact;
    Property JCJobManager : Boolean Read FJCJobManager Write SetJCJobManager;
    Property JCCustCode : Boolean Read FJCCustCode Write SetJCCustCode;
    Property JCAltCode : Boolean Read FJCAltCode Write SetJCAltCode;
    Property JCJobType : Boolean Read FJCJobType Write SetJCJobType;
    Property JCSORRef : Boolean Read FJCSORRef Write SetJCSORRef;
    Property JCUser1 : Boolean Read FJCUser1 Write SetJCUser1;
    Property JCUser2 : Boolean Read FJCUser2 Write SetJCUser2;
    Property JCUser3 : Boolean Read FJCUser3 Write SetJCUser3;
    Property JCUser4 : Boolean Read FJCUser4 Write SetJCUser4;
    Property JCUser5 : Boolean Read FJCUser5 Write SetJCUser5;
    Property JCUser6 : Boolean Read FJCUser6 Write SetJCUser6;
    Property JCUser7 : Boolean Read FJCUser7 Write SetJCUser7;
    Property JCUser8 : Boolean Read FJCUser8 Write SetJCUser8;
    Property JCUser9 : Boolean Read FJCUser9 Write SetJCUser9;
    Property JCUser10 : Boolean Read FJCUser10 Write SetJCUser10;

    Property MaxRowsReturned : Integer Read FMaxRowsReturned Write FMaxRowsReturned;
    Property ConnectionTimeout : Integer Read FConnectionTimeout Write FConnectionTimeout;
    Property CommandTimeout : Integer Read FCommandTimeout Write FCommandTimeout;

    Property GLSalesColourRed : ShortString Read FGLSalesColourRed Write FGLSalesColourRed;
    Property GLSalesColourBlue : ShortString Read FGLSalesColourBlue Write FGLSalesColourBlue;

    Constructor Create (Const IniPath : ShortString);

    Procedure LoadSettings;
    Procedure SaveSettings;
  End; // TExtendedSearchSettings


Function Settings : TExtendedSearchSettings;

implementation

Uses Forms;

Var
  lSettings : TExtendedSearchSettings;

//=========================================================================

Function Settings : TExtendedSearchSettings;
Begin // Settings
  If Not Assigned(lSettings) Then
    lSettings := TExtendedSearchSettings.Create (ExtractFilePath(Application.Exename) + 'ExtSrch.Ini');
  Result := lSettings;
End; // Settings

//=========================================================================

Constructor TExtendedSearchSettings.Create (Const IniPath : ShortString);
Begin // Create
  Inherited Create;
  FIniPath := IniPath;
  LoadSettings;
End; // Create

//-------------------------------------------------------------------------

Procedure TExtendedSearchSettings.LoadSettings;
Var
  OIni : TIniFile;
Begin // LoadSettings
  OIni := TIniFile.Create(FIniPath);
  Try
    FCULinkActive := (UpperCase(oIni.ReadString('SYSTEM', 'CULinkActive', 'YES')) = 'YES');
    FSTLinkActive := (UpperCase(oIni.ReadString('SYSTEM', 'STLinkActive', 'YES')) = 'YES');
    FJCLinkActive := (UpperCase(oIni.ReadString('SYSTEM', 'JCLinkActive', 'YES')) = 'YES');

    FCUCode := (UpperCase(oIni.ReadString('SYSTEM', 'CUCode', 'YES')) = 'YES');
    FCUCompany := (UpperCase(oIni.ReadString('SYSTEM', 'CUCompany', 'YES')) = 'YES');
    FCUAddress1 := (UpperCase(oIni.ReadString('SYSTEM', 'CUAddress1', 'YES')) = 'YES');
    FCUAddress2 := (UpperCase(oIni.ReadString('SYSTEM', 'CUAddress2', 'YES')) = 'YES');
    FCUAddress3 := (UpperCase(oIni.ReadString('SYSTEM', 'CUAddress3', 'YES')) = 'YES');
    FCUAddress4 := (UpperCase(oIni.ReadString('SYSTEM', 'CUAddress4', 'YES')) = 'YES');
    FCUAddress5 := (UpperCase(oIni.ReadString('SYSTEM', 'CUAddress5', 'YES')) = 'YES');
    FCUPostCode := (UpperCase(oIni.ReadString('SYSTEM', 'CUPostCode', 'YES')) = 'YES');
    FCUDelAddress1 := (UpperCase(oIni.ReadString('SYSTEM', 'CUDelAddress1', 'YES')) = 'YES');
    FCUDelAddress2 := (UpperCase(oIni.ReadString('SYSTEM', 'CUDelAddress2', 'YES')) = 'YES');
    FCUDelAddress3 := (UpperCase(oIni.ReadString('SYSTEM', 'CUDelAddress3', 'YES')) = 'YES');
    FCUDelAddress4 := (UpperCase(oIni.ReadString('SYSTEM', 'CUDelAddress4', 'YES')) = 'YES');
    FCUDelAddress5 := (UpperCase(oIni.ReadString('SYSTEM', 'CUDelAddress5', 'YES')) = 'YES');
    FCUContact := (UpperCase(oIni.ReadString('SYSTEM', 'CUContact', 'YES')) = 'YES');
    FCUPhone1 := (UpperCase(oIni.ReadString('SYSTEM', 'CUPhone1', 'YES')) = 'YES');
    FCUPhone2 := (UpperCase(oIni.ReadString('SYSTEM', 'CUPhone2', 'YES')) = 'YES');
    FCUPhone3 := (UpperCase(oIni.ReadString('SYSTEM', 'CUPhone3', 'YES')) = 'YES');
    FCUEMailID := (UpperCase(oIni.ReadString('SYSTEM', 'CUEMailID', 'YES')) = 'YES');
    FCUTheirAccount := (UpperCase(oIni.ReadString('SYSTEM', 'CUTheirAccount', 'YES')) = 'YES');
    FCUInvoiceTo := (UpperCase(oIni.ReadString('SYSTEM', 'CUInvoiceTo', 'YES')) = 'YES');
    FCUAccType := (UpperCase(oIni.ReadString('SYSTEM', 'CUAccType', 'YES')) = 'YES');
    FCUUser1 := (UpperCase(oIni.ReadString('SYSTEM', 'CUUser1', 'YES')) = 'YES');
    FCUUser2 := (UpperCase(oIni.ReadString('SYSTEM', 'CUUser2', 'YES')) = 'YES');
    FCUUser3 := (UpperCase(oIni.ReadString('SYSTEM', 'CUUser3', 'YES')) = 'YES');
    FCUUser4 := (UpperCase(oIni.ReadString('SYSTEM', 'CUUser4', 'YES')) = 'YES');

    // CA  09/06/2012   v7.0  ABSEXCH-12236: - Extend Search adding 18 UserDef Fields
    FCUUser5 := (UpperCase(oIni.ReadString('SYSTEM', 'CUUser5', 'YES')) = 'YES');
    FCUUser6 := (UpperCase(oIni.ReadString('SYSTEM', 'CUUser6', 'YES')) = 'YES');
    FCUUser7 := (UpperCase(oIni.ReadString('SYSTEM', 'CUUser7', 'YES')) = 'YES');
    FCUUser8 := (UpperCase(oIni.ReadString('SYSTEM', 'CUUser8', 'YES')) = 'YES');
    FCUUser9 := (UpperCase(oIni.ReadString('SYSTEM', 'CUUser9', 'YES')) = 'YES');
    FCUUser10 := (UpperCase(oIni.ReadString('SYSTEM', 'CUUser10', 'YES')) = 'YES');

    FCUVATNo := (UpperCase(oIni.ReadString('SYSTEM', 'CUVATNo', 'YES')) = 'YES');
    FCUArea := (UpperCase(oIni.ReadString('SYSTEM', 'CUArea', 'YES')) = 'YES');

    FSTCode := (UpperCase(oIni.ReadString('SYSTEM', 'STCode', 'YES')) = 'YES');
    FSTDesc1 := (UpperCase(oIni.ReadString('SYSTEM', 'STDesc1', 'YES')) = 'YES');
    FSTDesc2 := (UpperCase(oIni.ReadString('SYSTEM', 'STDesc2', 'YES')) = 'YES');
    FSTDesc3 := (UpperCase(oIni.ReadString('SYSTEM', 'STDesc3', 'YES')) = 'YES');
    FSTDesc4 := (UpperCase(oIni.ReadString('SYSTEM', 'STDesc4', 'YES')) = 'YES');
    FSTDesc5 := (UpperCase(oIni.ReadString('SYSTEM', 'STDesc5', 'YES')) = 'YES');
    FSTDesc6 := (UpperCase(oIni.ReadString('SYSTEM', 'STDesc6', 'YES')) = 'YES');
    FSTPrefSupp := (UpperCase(oIni.ReadString('SYSTEM', 'STPrefSupp', 'YES')) = 'YES');
    FSTAltCode := (UpperCase(oIni.ReadString('SYSTEM', 'STAltCode', 'YES')) = 'YES');
    FSTLocation := (UpperCase(oIni.ReadString('SYSTEM', 'STLocation', 'YES')) = 'YES');
    FSTBarCode := (UpperCase(oIni.ReadString('SYSTEM', 'STBarCode', 'YES')) = 'YES');
    FSTBinCode := (UpperCase(oIni.ReadString('SYSTEM', 'STBinCode', 'YES')) = 'YES');
    FSTUnitStock := (UpperCase(oIni.ReadString('SYSTEM', 'STUnitStock', 'YES')) = 'YES');
    FSTUnitPurchase := (UpperCase(oIni.ReadString('SYSTEM', 'STUnitPurchase', 'YES')) = 'YES');
    FSTUnitSale := (UpperCase(oIni.ReadString('SYSTEM', 'STUnitSale', 'YES')) = 'YES');
    FSTUser1 := (UpperCase(oIni.ReadString('SYSTEM', 'STUser1', 'YES')) = 'YES');
    FSTUser2 := (UpperCase(oIni.ReadString('SYSTEM', 'STUser2', 'YES')) = 'YES');
    FSTUser3 := (UpperCase(oIni.ReadString('SYSTEM', 'STUser3', 'YES')) = 'YES');
    FSTUser4 := (UpperCase(oIni.ReadString('SYSTEM', 'STUser4', 'YES')) = 'YES');

    // CA  09/06/2012   v7.0  ABSEXCH-12236: - Extend Search adding 18 UserDef Fields
    FSTUser5 := (UpperCase(oIni.ReadString('SYSTEM', 'STUser5', 'YES')) = 'YES');
    FSTUser6 := (UpperCase(oIni.ReadString('SYSTEM', 'STUser6', 'YES')) = 'YES');
    FSTUser7 := (UpperCase(oIni.ReadString('SYSTEM', 'STUser7', 'YES')) = 'YES');
    FSTUser8 := (UpperCase(oIni.ReadString('SYSTEM', 'STUser8', 'YES')) = 'YES');
    FSTUser9 := (UpperCase(oIni.ReadString('SYSTEM', 'STUser9', 'YES')) = 'YES');
    FSTUser10 := (UpperCase(oIni.ReadString('SYSTEM', 'STUser10', 'YES')) = 'YES');
    FSTAppendDesc := (UpperCase(oIni.ReadString('SYSTEM', 'STAppendDesc', 'NO')) = 'YES');

    FJCCode := (UpperCase(oIni.ReadString('SYSTEM', 'JCCode', 'YES')) = 'YES');
    FJCDesc1 := (UpperCase(oIni.ReadString('SYSTEM', 'JCDesc1', 'YES')) = 'YES');
    FJCJobContact := (UpperCase(oIni.ReadString('SYSTEM', 'JCJobContact', 'YES')) = 'YES');
    FJCJobManager := (UpperCase(oIni.ReadString('SYSTEM', 'JCJobManager', 'YES')) = 'YES');
    FJCCustCode := (UpperCase(oIni.ReadString('SYSTEM', 'JCCustCode', 'YES')) = 'YES');
    FJCAltCode := (UpperCase(oIni.ReadString('SYSTEM', 'JCAltCode', 'YES')) = 'YES');
    FJCJobType := (UpperCase(oIni.ReadString('SYSTEM', 'JCJobType', 'YES')) = 'YES');
    FJCSORRef := (UpperCase(oIni.ReadString('SYSTEM', 'JCSORRef', 'YES')) = 'YES');
    FJCUser1 := (UpperCase(oIni.ReadString('SYSTEM', 'JCUser1', 'YES')) = 'YES');
    FJCUser2 := (UpperCase(oIni.ReadString('SYSTEM', 'JCUser2', 'YES')) = 'YES');
    FJCUser3 := (UpperCase(oIni.ReadString('SYSTEM', 'JCUser3', 'YES')) = 'YES');
    FJCUser4 := (UpperCase(oIni.ReadString('SYSTEM', 'JCUser4', 'YES')) = 'YES');

    // CA  09/06/2012   v7.0  ABSEXCH-12236: - Extend Search adding 18 UserDef Fields
    FJCUser5 := (UpperCase(oIni.ReadString('SYSTEM', 'JCUser5', 'YES')) = 'YES');
    FJCUser6 := (UpperCase(oIni.ReadString('SYSTEM', 'JCUser6', 'YES')) = 'YES');
    FJCUser7 := (UpperCase(oIni.ReadString('SYSTEM', 'JCUser7', 'YES')) = 'YES');
    FJCUser8 := (UpperCase(oIni.ReadString('SYSTEM', 'JCUser8', 'YES')) = 'YES');
    FJCUser9 := (UpperCase(oIni.ReadString('SYSTEM', 'JCUser9', 'YES')) = 'YES');
    FJCUser10 := (UpperCase(oIni.ReadString('SYSTEM', 'JCUser10', 'YES')) = 'YES');

    FMaxRowsReturned := oIni.ReadInteger('SYSTEM', 'MaxRowsReturned', 200);
    FConnectionTimeout := oIni.ReadInteger('SYSTEM', 'ConnectionTimeout', 30);
    FCommandTimeout := oIni.ReadInteger('SYSTEM', 'CommandTimeout', 120);

    FGLSalesColourRed := oIni.ReadString('GLSalesColour', 'Red', '');
    FGLSalesColourBlue := oIni.ReadString('GLSalesColour', 'Blue', '');
  Finally
    OIni.Free;
  End; // Try..Finally
End; // LoadSettings

//------------------------------

Procedure TExtendedSearchSettings.SaveSettings;
Var
  OIni : TIniFile;
Begin // SaveSettings
  OIni := TIniFile.Create(FIniPath);
  Try
    oIni.WriteString('SYSTEM', 'CULinkActive', IfThen(CULinkActive, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STLinkActive', IfThen(STLinkActive, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'JCLinkActive', IfThen(JCLinkActive, 'YES', 'NO'));

    oIni.WriteString('SYSTEM', 'CUCode', IfThen(CUCode, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUCompany', IfThen(CUCompany, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUAddress1', IfThen(CUAddress1, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUAddress2', IfThen(CUAddress2, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUAddress3', IfThen(CUAddress3, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUAddress4', IfThen(CUAddress4, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUAddress5', IfThen(CUAddress5, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUPostCode', IfThen(CUPostCode, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUDelAddress1', IfThen(CUDelAddress1, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUDelAddress2', IfThen(CUDelAddress2, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUDelAddress3', IfThen(CUDelAddress3, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUDelAddress4', IfThen(CUDelAddress4, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUDelAddress5', IfThen(CUDelAddress5, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUContact', IfThen(CUContact, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUPhone1', IfThen(CUPhone1, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUPhone2', IfThen(CUPhone2, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUPhone3', IfThen(CUPhone3, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUEMailID', IfThen(CUEMailID, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUTheirAccount', IfThen(CUTheirAccount, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUInvoiceTo', IfThen(CUInvoiceTo, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUAccType', IfThen(CUAccType, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUUser1', IfThen(CUUser1, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUUser2', IfThen(CUUser2, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUUser3', IfThen(CUUser3, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUUser4', IfThen(CUUser4, 'YES', 'NO'));

    // CA  09/06/2012   v7.0  ABSEXCH-12236: - Extend Search adding 18 UserDef Fields
    oIni.WriteString('SYSTEM', 'CUUser5', IfThen(CUUser5, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUUser6', IfThen(CUUser6, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUUser7', IfThen(CUUser7, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUUser8', IfThen(CUUser8, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUUser9', IfThen(CUUser9, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUUser10', IfThen(CUUser10, 'YES', 'NO'));

    oIni.WriteString('SYSTEM', 'CUVATNo', IfThen(CUVATNo, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'CUArea', IfThen(CUArea, 'YES', 'NO'));

    oIni.WriteString('SYSTEM', 'STCode', IfThen(STCode, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STDesc1', IfThen(STDesc1, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STDesc2', IfThen(STDesc2, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STDesc3', IfThen(STDesc3, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STDesc4', IfThen(STDesc4, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STDesc5', IfThen(STDesc5, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STDesc6', IfThen(STDesc6, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STPrefSupp', IfThen(STPrefSupp, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STAltCode', IfThen(STAltCode, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STLocation', IfThen(STLocation, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STBarCode', IfThen(STBarCode, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STBinCode', IfThen(STBinCode, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STUnitStock', IfThen(STUnitStock, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STUnitPurchase', IfThen(STUnitPurchase, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STUnitSale', IfThen(STUnitSale, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STUser1', IfThen(STUser1, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STUser2', IfThen(STUser2, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STUser3', IfThen(STUser3, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STUser4', IfThen(STUser4, 'YES', 'NO'));

    // CA  09/06/2012   v7.0  ABSEXCH-12236: - Extend Search adding 18 UserDef Fields
    oIni.WriteString('SYSTEM', 'STUser5', IfThen(STUser5, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STUser6', IfThen(STUser6, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STUser7', IfThen(STUser7, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STUser8', IfThen(STUser8, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STUser9', IfThen(STUser9, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'STUser10', IfThen(STUser10, 'YES', 'NO'));

    oIni.WriteString('SYSTEM', 'STAppendDesc', IfThen(FSTAppendDesc, 'YES', 'NO'));

    oIni.WriteString('SYSTEM', 'JCCode', IfThen(JCCode, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'JCDesc1', IfThen(JCDesc1, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'JCJobContact', IfThen(JCJobContact, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'JCJobManager', IfThen(JCJobManager, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'JCCustCode', IfThen(JCCustCode, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'JCAltCode', IfThen(JCAltCode, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'JCJobType', IfThen(JCJobType, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'JCSORRef', IfThen(JCSORRef, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'JCUser1', IfThen(JCUser1, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'JCUser2', IfThen(JCUser2, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'JCUser3', IfThen(JCUser3, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'JCUser4', IfThen(JCUser4, 'YES', 'NO'));

    // CA  09/06/2012   v7.0  ABSEXCH-12236: - Extend Search adding 18 UserDef Fields
    oIni.WriteString('SYSTEM', 'JCUser5', IfThen(JCUser5, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'JCUser6', IfThen(JCUser6, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'JCUser7', IfThen(JCUser7, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'JCUser8', IfThen(JCUser8, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'JCUser9', IfThen(JCUser9, 'YES', 'NO'));
    oIni.WriteString('SYSTEM', 'JCUser10', IfThen(JCUser10, 'YES', 'NO'));

    oIni.WriteInteger('SYSTEM', 'MaxRowsReturned', FMaxRowsReturned);
    oIni.WriteInteger('SYSTEM', 'ConnectionTimeout', FConnectionTimeout);
    oIni.WriteInteger('SYSTEM', 'CommandTimeout', FCommandTimeout);

    //oIni.WriteString('GLSalesColour', 'Red', FGLSalesColourRed);
    //oIni.WriteString('GLSalesColour', 'Blue', FGLSalesColourBlue);
  Finally
    OIni.Free;
  End; // Try..Finally
End; // SaveSettings

//-------------------------------------------------------------------------

Procedure TExtendedSearchSettings.SetCULinkActive (Value : Boolean);
Begin // SetCULinkActive
  FCULinkActive := Value
End; // SetCULinkActive

//------------------------------

Procedure TExtendedSearchSettings.SetSTLinkActive (Value : Boolean);
Begin // SetSTLinkActive
  FSTLinkActive := Value
End; // SetSTLinkActive

//------------------------------

Procedure TExtendedSearchSettings.SetJCLinkActive (Value : Boolean);
Begin // SetJCLinkActive
  FJCLinkActive := Value
End; // SetJCLinkActive

//------------------------------

Procedure TExtendedSearchSettings.SetCUCode (Value : Boolean);
Begin // SetCUCode
  FCUCode := Value
End; // SetCUCode

//------------------------------

Procedure TExtendedSearchSettings.SetCUCompany (Value : Boolean);
Begin // SetCUCompany
  FCUCompany := Value
End; // SetCUCompany

//------------------------------

Procedure TExtendedSearchSettings.SetCUAddress1 (Value : Boolean);
Begin // SetCUAddress1
  FCUAddress1 := Value
End; // SetCUAddress1

//------------------------------

Procedure TExtendedSearchSettings.SetCUAddress2 (Value : Boolean);
Begin // SetCUAddress2
  FCUAddress2 := Value
End; // SetCUAddress2

//------------------------------

Procedure TExtendedSearchSettings.SetCUAddress3 (Value : Boolean);
Begin // SetCUAddress3
  FCUAddress3 := Value
End; // SetCUAddress3

//------------------------------

Procedure TExtendedSearchSettings.SetCUAddress4 (Value : Boolean);
Begin // SetCUAddress4
  FCUAddress4 := Value
End; // SetCUAddress4

//------------------------------

Procedure TExtendedSearchSettings.SetCUAddress5 (Value : Boolean);
Begin // SetCUAddress5
  FCUAddress5 := Value
End; // SetCUAddress5

//------------------------------

Procedure TExtendedSearchSettings.SetCUPostCode (Value : Boolean);
Begin // SetCUPostCode
  FCUPostCode := Value
End; // SetCUPostCode

//------------------------------

Procedure TExtendedSearchSettings.SetCUDelAddress1 (Value : Boolean);
Begin // SetCUDelAddress1
  FCUDelAddress1 := Value
End; // SetCUDelAddress1

//------------------------------

Procedure TExtendedSearchSettings.SetCUDelAddress2 (Value : Boolean);
Begin // SetCUDelAddress2
  FCUDelAddress2 := Value
End; // SetCUDelAddress2

//------------------------------

Procedure TExtendedSearchSettings.SetCUDelAddress3 (Value : Boolean);
Begin // SetCUDelAddress3
  FCUDelAddress3 := Value
End; // SetCUDelAddress3

//------------------------------

Procedure TExtendedSearchSettings.SetCUDelAddress4 (Value : Boolean);
Begin // SetCUDelAddress4
  FCUDelAddress4 := Value
End; // SetCUDelAddress4

//------------------------------

Procedure TExtendedSearchSettings.SetCUDelAddress5 (Value : Boolean);
Begin // SetCUDelAddress5
  FCUDelAddress5 := Value
End; // SetCUDelAddress5

//------------------------------

Procedure TExtendedSearchSettings.SetCUContact (Value : Boolean);
Begin // SetCUContact
  FCUContact := Value
End; // SetCUContact

//------------------------------

Procedure TExtendedSearchSettings.SetCUPhone1 (Value : Boolean);
Begin // SetCUPhone1
  FCUPhone1 := Value
End; // SetCUPhone1

//------------------------------

Procedure TExtendedSearchSettings.SetCUPhone2 (Value : Boolean);
Begin // SetCUPhone2
  FCUPhone2 := Value
End; // SetCUPhone2

//------------------------------

Procedure TExtendedSearchSettings.SetCUPhone3 (Value : Boolean);
Begin // SetCUPhone3
  FCUPhone3 := Value
End; // SetCUPhone3

//------------------------------

Procedure TExtendedSearchSettings.SetCUEMailID (Value : Boolean);
Begin // SetCUEMailID
  FCUEMailID := Value
End; // SetCUEMailID

//------------------------------

Procedure TExtendedSearchSettings.SetCUTheirAccount (Value : Boolean);
Begin // SetCUTheirAccount
  FCUTheirAccount := Value
End; // SetCUTheirAccount

//------------------------------

Procedure TExtendedSearchSettings.SetCUInvoiceTo (Value : Boolean);
Begin // SetCUInvoiceTo
  FCUInvoiceTo := Value
End; // SetCUInvoiceTo

//------------------------------

Procedure TExtendedSearchSettings.SetCUAccType (Value : Boolean);
Begin // SetCUAccType
  FCUAccType := Value
End; // SetCUAccType

//------------------------------

Procedure TExtendedSearchSettings.SetCUUser1 (Value : Boolean);
Begin // SetCUUser1
  FCUUser1 := Value
End; // SetCUUser1

//------------------------------

Procedure TExtendedSearchSettings.SetCUUser2 (Value : Boolean);
Begin // SetCUUser2
  FCUUser2 := Value
End; // SetCUUser2

//------------------------------

Procedure TExtendedSearchSettings.SetCUUser3 (Value : Boolean);
Begin // SetCUUser3
  FCUUser3 := Value
End; // SetCUUser3

//------------------------------

Procedure TExtendedSearchSettings.SetCUUser4 (Value : Boolean);
Begin // SetCUUser4
  FCUUser4 := Value
End; // SetCUUser4

//------------------------------

// CA  09/06/2012   v7.0  ABSEXCH-12236: - Extend Search adding 18 UserDef Fields

Procedure TExtendedSearchSettings.SetCUUser5 (Value : Boolean);
Begin // SetCUUser5
  FCUUser5 := Value
End; // SetCUUser5

//------------------------------

Procedure TExtendedSearchSettings.SetCUUser6 (Value : Boolean);
Begin // SetCUUser6
  FCUUser6 := Value
End; // SetCUUser6

//------------------------------

Procedure TExtendedSearchSettings.SetCUUser7 (Value : Boolean);
Begin // SetCUUser7
  FCUUser7 := Value
End; // SetCUUser7

//------------------------------

Procedure TExtendedSearchSettings.SetCUUser8 (Value : Boolean);
Begin // SetCUUser8
  FCUUser8 := Value
End; // SetCUUser8

//------------------------------

Procedure TExtendedSearchSettings.SetCUUser9 (Value : Boolean);
Begin // SetCUUser9
  FCUUser9 := Value
End; // SetCUUser9

//------------------------------

Procedure TExtendedSearchSettings.SetCUUser10 (Value : Boolean);
Begin // SetCUUser10
  FCUUser10 := Value
End; // SetCUUser10

//------------------------------

Procedure TExtendedSearchSettings.SetCUVATNo (Value : Boolean);
Begin // SetCUVATNo
  FCUVATNo := Value
End; // SetCUVATNo

//------------------------------

Procedure TExtendedSearchSettings.SetCUArea (Value : Boolean);
Begin // SetCUArea
  FCUArea := Value
End; // SetCUArea

//------------------------------

Procedure TExtendedSearchSettings.SetSTCode (Value : Boolean);
Begin // SetSTCode
  FSTCode := Value
End; // SetSTCode

//------------------------------

Procedure TExtendedSearchSettings.SetSTDesc1 (Value : Boolean);
Begin // SetSTDesc1
  FSTDesc1 := Value
End; // SetSTDesc1

//------------------------------

Procedure TExtendedSearchSettings.SetSTDesc2 (Value : Boolean);
Begin // SetSTDesc2
  FSTDesc2 := Value
End; // SetSTDesc2

//------------------------------

Procedure TExtendedSearchSettings.SetSTDesc3 (Value : Boolean);
Begin // SetSTDesc3
  FSTDesc3 := Value
End; // SetSTDesc3

//------------------------------

Procedure TExtendedSearchSettings.SetSTDesc4 (Value : Boolean);
Begin // SetSTDesc4
  FSTDesc4 := Value
End; // SetSTDesc4

//------------------------------

Procedure TExtendedSearchSettings.SetSTDesc5 (Value : Boolean);
Begin // SetSTDesc5
  FSTDesc5 := Value
End; // SetSTDesc5

//------------------------------

Procedure TExtendedSearchSettings.SetSTDesc6 (Value : Boolean);
Begin // SetSTDesc6
  FSTDesc6 := Value
End; // SetSTDesc6

//------------------------------

Procedure TExtendedSearchSettings.SetSTPrefSupp (Value : Boolean);
Begin // SetSTPrefSupp
  FSTPrefSupp := Value
End; // SetSTPrefSupp

//------------------------------

Procedure TExtendedSearchSettings.SetSTAltCode (Value : Boolean);
Begin // SetSTAltCode
  FSTAltCode := Value
End; // SetSTAltCode

//------------------------------

Procedure TExtendedSearchSettings.SetSTLocation (Value : Boolean);
Begin // SetSTLocation
  FSTLocation := Value
End; // SetSTLocation

//------------------------------

Procedure TExtendedSearchSettings.SetSTBarCode (Value : Boolean);
Begin // SetSTBarCode
  FSTBarCode := Value
End; // SetSTBarCode

//------------------------------

Procedure TExtendedSearchSettings.SetSTBinCode (Value : Boolean);
Begin // SetSTBinCode
  FSTBinCode := Value
End; // SetSTBinCode

//------------------------------

Procedure TExtendedSearchSettings.SetSTUnitStock (Value : Boolean);
Begin // SetSTUnitStock
  FSTUnitStock := Value
End; // SetSTUnitStock

//------------------------------

Procedure TExtendedSearchSettings.SetSTUnitPurchase (Value : Boolean);
Begin // SetSTUnitPurchase
  FSTUnitPurchase := Value
End; // SetSTUnitPurchase

//------------------------------

Procedure TExtendedSearchSettings.SetSTUnitSale (Value : Boolean);
Begin // SetSTUnitSale
  FSTUnitSale := Value
End; // SetSTUnitSale

//------------------------------

Procedure TExtendedSearchSettings.SetSTUser1 (Value : Boolean);
Begin // SetSTUser1
  FSTUser1 := Value
End; // SetSTUser1

//------------------------------

Procedure TExtendedSearchSettings.SetSTUser2 (Value : Boolean);
Begin // SetSTUser2
  FSTUser2 := Value
End; // SetSTUser2

//------------------------------

Procedure TExtendedSearchSettings.SetSTUser3 (Value : Boolean);
Begin // SetSTUser3
  FSTUser3 := Value
End; // SetSTUser3

//------------------------------

Procedure TExtendedSearchSettings.SetSTUser4 (Value : Boolean);
Begin // SetSTUser4
  FSTUser4 := Value
End; // SetSTUser4

//------------------------------

// CA  09/06/2012   v7.0  ABSEXCH-12236: - Extend Search adding 18 UserDef Fields

Procedure TExtendedSearchSettings.SetSTUser5 (Value : Boolean);
Begin // SetSTUser5
  FSTUser5 := Value
End; // SetSTUser5

//------------------------------

Procedure TExtendedSearchSettings.SetSTUser6 (Value : Boolean);
Begin // SetSTUser6
  FSTUser6 := Value
End; // SetSTUser6

//------------------------------

Procedure TExtendedSearchSettings.SetSTUser7 (Value : Boolean);
Begin // SetSTUser7
  FSTUser7 := Value
End; // SetSTUser7

//------------------------------

Procedure TExtendedSearchSettings.SetSTUser8 (Value : Boolean);
Begin // SetSTUser8
  FSTUser8 := Value
End; // SetSTUser8

//------------------------------

Procedure TExtendedSearchSettings.SetSTUser9 (Value : Boolean);
Begin // SetSTUser9
  FSTUser9 := Value
End; // SetSTUser9

//------------------------------

Procedure TExtendedSearchSettings.SetSTUser10 (Value : Boolean);
Begin // SetSTUser10
  FSTUser10 := Value
End; // SetSTUser10


//------------------------------

Procedure TExtendedSearchSettings.SetJCCode (Value : Boolean);
Begin // SetJCCode
  FJCCode := Value
End; // SetJCCode

//------------------------------

Procedure TExtendedSearchSettings.SetJCDesc1 (Value : Boolean);
Begin // SetJCDesc1
  FJCDesc1 := Value
End; // SetJCDesc1

//------------------------------

Procedure TExtendedSearchSettings.SetJCJobContact (Value : Boolean);
Begin // SetJCJobContact
  FJCJobContact := Value
End; // SetJCJobContact

//------------------------------

Procedure TExtendedSearchSettings.SetJCJobManager (Value : Boolean);
Begin // SetJCJobManager
  FJCJobManager := Value
End; // SetJCJobManager

//------------------------------

Procedure TExtendedSearchSettings.SetJCCustCode (Value : Boolean);
Begin // SetJCCustCode
  FJCCustCode := Value
End; // SetJCCustCode

//------------------------------

Procedure TExtendedSearchSettings.SetJCAltCode (Value : Boolean);
Begin // SetJCAltCode
  FJCAltCode := Value
End; // SetJCAltCode

//------------------------------

Procedure TExtendedSearchSettings.SetJCJobType (Value : Boolean);
Begin // SetJCJobType
  FJCJobType := Value
End; // SetJCJobType

//------------------------------

Procedure TExtendedSearchSettings.SetJCSORRef (Value : Boolean);
Begin // SetJCSORRef
  FJCSORRef := Value
End; // SetJCSORRef

//------------------------------

Procedure TExtendedSearchSettings.SetJCUser1 (Value : Boolean);
Begin // SetJCUser1
  FJCUser1 := Value
End; // SetJCUser1

//------------------------------

Procedure TExtendedSearchSettings.SetJCUser2 (Value : Boolean);
Begin // SetJCUser2
  FJCUser2 := Value
End; // SetJCUser2

//------------------------------

Procedure TExtendedSearchSettings.SetJCUser3 (Value : Boolean);
Begin // SetJCUser3
  FJCUser3 := Value
End; // SetJCUser3

//------------------------------

Procedure TExtendedSearchSettings.SetJCUser4 (Value : Boolean);
Begin // SetJCUser4
  FJCUser4 := Value
End; // SetJCUser4

//------------------------------

// CA  09/06/2012   v7.0  ABSEXCH-12236: - Extend Search adding 18 UserDef Fields

Procedure TExtendedSearchSettings.SetJCUser5 (Value : Boolean);
Begin // SetJCUser5
  FJCUser5 := Value
End; // SetJCUser5

//------------------------------

Procedure TExtendedSearchSettings.SetJCUser6 (Value : Boolean);
Begin // SetJCUser6
  FJCUser6 := Value
End; // SetJCUser6

//------------------------------

Procedure TExtendedSearchSettings.SetJCUser7 (Value : Boolean);
Begin // SetJCUser7
  FJCUser7 := Value
End; // SetJCUser7

//------------------------------

Procedure TExtendedSearchSettings.SetJCUser8 (Value : Boolean);
Begin // SetJCUser8
  FJCUser8 := Value
End; // SetJCUser8

//------------------------------

Procedure TExtendedSearchSettings.SetJCUser9 (Value : Boolean);
Begin // SetJCUser9
  FJCUser9 := Value
End; // SetJCUser9

//------------------------------

Procedure TExtendedSearchSettings.SetJCUser10 (Value : Boolean);
Begin // SetJCUser10
  FJCUser10 := Value
End; // SetJCUser10


//-------------------------------------------------------------------------

Initialization
  lSettings := NIL;
Finalization
  If Assigned(lSettings) Then
    FreeAndNIL(lSettings);
end.

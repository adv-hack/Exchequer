program SQLHelpr;

{$ALIGN 1}

uses
  Forms,
  Dialogs,
  SysUtils,
  SQLH_MemMap in 'SQLH_MemMap.Pas',
  uSQLFuncs in 'X:\Entrprse\SETUP\uSQLFuncs.pas',
  uSQLClass in 'X:\Entrprse\SETUP\uSQLClass.pas',
  WiseUtil in 'WiseUtil.Pas',
  CompUtil in '..\COMPUTIL.PAS',
  GlobVar in 'X:\Entrprse\R&D\GLOBVAR.PAS',
  VarConst in '..\VARCONST.PAS',
  Btrvu2 in 'X:\SBSLIB\WIN\WIN32\BTRVU2.PAS',
  SQLDataReplication in '..\SQLDataReplication.pas',
  EntReplU in '..\ENTREPLU.PAS',
  InitImporterJobs in 'InitImporterJobs.Pas',
  ConvData in '..\ConvData.pas',
  ModRels in '..\MODRELS.PAS',
  CommsInt in 'X:\Entrprse\ENTCOMMS\COMMSINT.PAS',
  ERC in 'X:\Entrprse\LICENCE\ERC.PAS',
  Base34 in 'X:\Entrprse\BASE36\BASE34.PAS',
  WLicFile in 'X:\Entrprse\CD\WLICFILE.PAS',
  EntLicence in 'X:\Entrprse\DRILLDN\EntLicence.pas',
  LicDets in 'X:\EXCHLITE\CD\LicDets.pas',
  oIRISLicence in 'X:\EXCHLITE\IRIS Licencing\oIRISLicence.pas',
  ELITE_COM_TLB in 'X:\EXCHLITE\IRIS Licencing\ELITE_COM_TLB.pas',
  mscorlib_TLB in 'X:\EXCHLITE\IRIS Licencing\mscorlib_TLB.pas',
  CompSec in '..\CompSec.pas',
  DLLWISE2 in 'DLLWISE2.PAS',
  rpcommon in 'X:\Entrprse\FORMDES2\RPCOMMON.PAS',
  ReplSysF in '..\ReplSysF.pas',
  CompanyExists in 'CompanyExists.pas',
  BtrDel in '..\BtrDel.pas' {frmDeleteBetrieve},
  GetConnStr in 'GetConnStr.pas',
  PWGELocF in '..\PWGELOCF.PAS',
  EntDataU in '..\Entdatau.pas',
  CopyOptF in '..\CopyOptF.Pas',
  MultiBuyVar in '..\..\R&D\MultiBuyVar.pas',
  uUpdatePaths in '..\..\IMPORT\Importer\uUpdatePaths.pas',
  // Intrastat ----------------------
  IntrastatXML in '\Entrprse\R&D\Intrastat\IntrastatXML.pas',
  // Intrastat ----------------------
  CreateAuditTrail in 'CreateAuditTrail.pas',
  CreateVAT100Dirs in 'CreateVAT100Dirs.Pas',

  // GDPR ----------------------------
  GDPRConst in '\Entrprse\R&D\GDPR\GDPRConst.pas',

  // MH 08/01/2018 2017-R1 ABSEXCH-19316: Initialise SQL Posting Flags
  SQLRep_Config in '\Entrprse\R&D\SQLRep_Config.pas',
  InitSQLPostingFlags in '\Entrprse\MultComp\SQLHelper\InitSQLPostingFlags.pas',

  // MH 16/04/2018 2018-R1 ABSEXCH-20406: Initialise SystemSetup DataVersionNo for New MSSQL Installations
  AddSystemSetupFields in '\Entrprse\MultComp\Upgrades\AddSystemSetupFields.pas';

{$R *.res}

begin
  // Check command line security parameter
  If FindCmdLineSwitch('SQLBODGE', ['-', '/', '\'], True) Then
  Begin
    If GlobalSetupMap.Defined Then
    Begin
      Try
        DummyParams.szParam := PCHAR(GlobalSetupMap.Params);

        Case GlobalSetupMap.FunctionId Of
          fnCreateSQLDatabase   : Begin
                                    GlobalSetupMap.Result := SCD_CreateSQLDatabase(DummyParams);
                                  End; // fnCreateSQLDatabase
          fnCreateSQLCompany    : Begin
                                    GlobalSetupMap.Result := SCD_CreateSQLCompany(DummyParams);
                                  End; // fnCreateSQLCompany
          fnSQLDataImport       : Begin
                                    GlobalSetupMap.Result := SCD_SQLDataImport(DummyParams);
                                  End; // fnSQLDataImport
          fnSQLImportCompData   : Begin
                                    GlobalSetupMap.Result := SCD_ImportCompData(DummyParams);
                                  End; // fnSQLImportCompData
          fnReplicateFiles      : Begin
                                    GlobalSetupMap.Result := SCD_ReplicateFiles(DummyParams);
                                  End; // fnReplicateFiles
          fnConvertData         : Begin
                                    GlobalSetupMap.Result := SCD_ConvertData(DummyParams);
                                  End; // fnConvertData
          fnSetupLicence        : Begin
                                    GlobalSetupMap.Result := SCD_SetupLicence(DummyParams);
                                  End; // fnSetupLicence
          fnSetupCompanyCount   : Begin
                                    GlobalSetupMap.Result := SCD_SetupCompanyCount(DummyParams);
                                  End; // fnSetupCompanyCount
          fnEntCompanyWizard    : Begin
                                    GlobalSetupMap.Result := SCD_EntCompanyWizard(DummyParams);
                                  End; // fnEntCompanyWizard
          fnReplicateLicence    : Begin
                                    GlobalSetupMap.Result := SCD_ReplicateLicence(DummyParams);
                                  End; // fnReplicateLicence
          fnDataCopyWizard      : Begin
                                    GlobalSetupMap.Result := SCD_EntDataCopy(DummyParams);
                                  End; // fnDataCopyWizard
          fnCopyMainSecurity    : Begin
                                    GlobalSetupMap.Result := SCD_EntCopyMainSecurity(DummyParams);
                                  End; // fnCopyMainSecurity
          fnCheckCompanyCount   : Begin
                                    GlobalSetupMap.Result := Setup_CheckCompCountW(DummyParams);
                                  End; // fnCheckCompanyCount
          fnCompanyExists       : Begin
                                    GlobalSetupMap.Result := Setup_CompanyExists(DummyParams);
                                  End; // fnCompanyExists
          fnArchiveFiles        : Begin
                                    GlobalSetupMap.Result := SCD_DeleteOldBtrieveFiles(DummyParams);
                                  End; // fnArchiveFiles
          fnImportCommonData    : Begin
                                    GlobalSetupMap.Result := SCD_SQLCommonDataImport(DummyParams);
                                  End; // fnImportCommonData
          fnGetConnectionInfo   : Begin
                                    GlobalSetupMap.Result := GetConnectionInfo(DummyParams);
                                  End; // fnGetConnectionInfo
          fnGenRootLocFiles     : Begin
                                    GlobalSetupMap.Result := SCD_GenRootLocFiles(DummyParams);
                                  End; // fnGenRootLocFiles
          fnGenLocFiles         : Begin
                                    GlobalSetupMap.Result := SCD_GenLocFiles(DummyParams);
                                  End; // fnGenLocFiles
          fnInitImporterJobs    : Begin
                                    GlobalSetupMap.Result := SCD_InitialiseImporterJobs(DummyParams);
                                  End; // fnGenLocFiles
          fnCreateAuditTrail    : Begin
                                    GlobalSetupMap.Result := SCD_CreateAuditTrail(DummyParams);
                                  End; // fnGenLocFiles
          fnCreateVAT100Dirs    : Begin
                                    //GlobalSetupMap.Result := SCD_CreateAuditTrail(DummyParams);
                                    GlobalSetupMap.Result := SCD_CreateVAT100Dirs(DummyParams);
                                  End; // fnCreateVAT100Dirs
          // MH 07/04/2017 2017-R1 ABSEXCH-18512: Example VRW Reports
          fnReplicateFilesInDir : Begin
                                    GlobalSetupMap.Result := SCD_ReplicateFilesInDir(DummyParams);
                                  End; // fnCreateVAT100Dirs
          // MH 08/01/2018 2017-R1 ABSEXCH-19316: Initialise SQL Posting Flags
          fnInitialiseSQLPostingFlags : Begin
                                          GlobalSetupMap.Result := SCD_InitialiseSQLPostingFlags(DummyParams);
                                        End; // fnInitialiseSQLPostingFlags
        End; // Case GlobalSetupMap.FunctionId
      Except
        On E:Exception Do
          MessageDlg ('SQLHelpr.Exe, the following error occurred whilst performing function ' +
                      IntToStr(Ord(GlobalSetupMap.FunctionId)) + ':-'#13#13 + E.Message,
                      mtError, [mbOK], 0);
      End; // Try..Except
    End; // If GlobalSetupMap.Defined
  End; // If FindCmdLineSwitch('SQLBODGE', ['-', '/', '\'], True)
end.

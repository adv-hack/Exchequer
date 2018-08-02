library EnBureau;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

uses
  ShareMem,
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  ControlsAtomFix in '\Entrprse\Funcs\ControlsAtomFix.pas',
  Dialogs,
  SysUtils,
  Classes,
  Btrvu2 in '..\..\SBSLIB\WIN\WIN32\BTRVU2.PAS',
  VarConst in 'VARCONST.PAS',
  GroupCompFile in 'GroupCompFile.pas',
  GroupsFile in 'GroupsFile.pas',
  GroupUsersFile in 'GroupUsersFile.pas',
  GlobVar in '..\R&D\GLOBVAR.PAS',
  VarRec2U in '..\..\SBSLIB\WIN\EXCOMMON\VARREC2U.PAS',
  BtKeys1U in '..\R&d\BTKeys1U.pas',
  VarFPOSU in '..\R&D\VARFPOSU.PAS',
  BureauSecurity in 'BureauSecurity.pas',
  Crypto in 'CRYPTO.PAS',
  enBureauIntF in '..\R&D\enBureauIntF.pas',
  oBureauData in 'oBureauData.pas',
  ConvData in 'CONVDATA.PAS',
  EntLicence in '..\DRILLDN\EntLicence.pas',
  FileUtil in '..\FUNCS\FILEUTIL.PAS',
  VAOUtil in '..\FUNCS\VAOUtil.pas',
  EnterpriseBeta_TLB in 'X:\ENTRPRSE\COMTK\EnterpriseBeta_TLB.pas';

{$R *.res}

//-------------------------------------------------------------------------

// Initialises the Bureau and opens all the data files ready for the
// Data Object
//
// Return Values:-
//
//   0       AOK
//   1000    Unknown Error
//   1001    Invalid User Code
Function StartupBureau (Const UserCode : ShortString) : LongInt; StdCall;
Begin // StartupBureau
  Result := 1000;
  Try
    // HM 10/08/04: Updated for VAO support
    // Check for Local Program files
    //SetDrive := GetEnterpriseDirectory;
    SetDrive := VAOInfo.vaoCompanyDir;

    // Open data files
    Open_System(CompF, CompF);
    Open_System(GroupF, GroupF);
    Open_System(GroupCompXRefF, GroupCompXRefF);
    Open_System(GroupUsersF, GroupUsersF);

    // load MCM options
    LoadCompanyOpt;

    // Check whether to use the standard MCM or the Bureau MCM
    If SyssCompany^.CompOpt.OptBureauModule Then
    Begin
      // Bureau - Start up Bureau Security, validate the User Id and
      // load their security Settings
      If Not SecurityManager.ValidLoginId(UserCode) Then
      Begin
        Result := 1001;
      End; // If Not SecurityManager.ValidLoginId(UserCode)
    End // If SyssCompany^.CompOpt.OptBureauModule
    Else
    Begin
      // Standard MCM
    End;

    Result := 0;
  Except
    On E:Exception Do
    Begin
      MessageDlg ('The following error occurred whilst starting up the Bureau Module:- ' + #13#13 +
                  E.Message + #13#13 + 'Please notify your technical support', mtError, [mbOk], 0);
    End; // On E:Exception
  End; // Try..Except
End; // StartupBureau

//-------------------------------------------------------------------------

Function GetBureauDataObject : IBureauDataObject; StdCall;
Begin // GetBureauDataObject
  // Check whether to display the standard MCM or the Bureau MCM
  If SyssCompany^.CompOpt.OptBureauModule Then
  Begin
    // Bureau MCM - show companies within group
    Result := TBureauDataObject.Create (NIL, GroupCompXRefF, FullGroupCodeKey(SecurityManager.smGroupCode));
  End // If SyssCompany^.CompOpt.OptBureauModule
  Else
  Begin
    // Standard MCM - show all company details
    Result := TBureauDataObject.Create (NIL, CompF, cmCompDet);
  End; // Else
End; // GetBureauDataObject

//-------------------------------------------------------------------------

// Shuts down all the data files, etc...
Function CloseDownBureau : LongInt; StdCall;
Begin // CloseDownBureau
  Result := 0;

  // Close data files
  Close_File(F[CompF]);
  Close_File(F[GroupF]);
  Close_File(F[GroupCompXRefF]);
  Close_File(F[GroupUsersF]);
End; // CloseDownBureau

//-------------------------------------------------------------------------

Exports
  StartupBureau,
  GetBureauDataObject,
  CloseDownBureau;
end.

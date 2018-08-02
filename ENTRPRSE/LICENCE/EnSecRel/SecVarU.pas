unit SecVarU;

interface
  Uses
    VarRec2U;

Const
  SRVerNo  =  'b111.052';


// MH 12/06/2018 - b111.052
// -------------------------------------------------
// * Added ENSECREL compiler def to stop SQLUtils.Pas trying to initialise BtrvSQL which prevents it loading
//   on earlier versions of Exchequer due to changes in the API during 2018-R1.
//
//
// MH 06/06/2018
// -------------------------------------------------
// * Added Priyanka and Komal into the Trustees List so they can access all the Security Passwords.
//
//
// MH 11/05/2018
// -------------------------------------------------
// * Add support for following users:-
//
//     FIONNUALA.MUNRO
//
//
// MH 10/04/2018
// -------------------------------------------------
// * ABSEXCH-20364 - Add support for following users:-
//
//     MEET.PATHAK
//     ASHLEY.GRAY
//     AMARPREET.SAHOTA
//
//
// MH - MH 19/03/2018  - b111.048
// -------------------------------------------------
// * ABSEXCH-19887 - Add support for following users:-
//
//     PRADEEP.NARAYANASWAM
//     DINESHKUMAR.SELVARAJ
//     LAKSHMI.NARASIMHAN
//
//
// MH - 05/03/2018 - b111.047
// -------------------------------------------------
// * Updated network credentials for David
// * Removed Ex-Staff - PRUTHERFORD440, LOUISE.WINTER, JMARSH
// * Removed loading of SQL Emulator/WBtrv32 for SecRel as new API functions were causing errors when an older Exchequer was registered 
//
//
// MH - 21/02/2018 - b110.046
// -------------------------------------------------
// * Updated network credentials for Nick and Ande
//
//
// MH - 16/11/2017 - b110.045
// -------------------------------------------------
// ABSEXCH-19452 - Licencing Changes for GDPR
//  * Added support for GDPR and Pervasive FFile Encryption module release codes
//
//
// MH - 16/05/2017 - b101.044
// -------------------------------------------------
// * ABSEXCH-18951: Added SHRUTHI.MURALIDHARA
// * Removed Conrad Herring and Anthony Cronin
//
// MH - 16/05/2017 - b101.043
// -------------------------------------------------
// * ABSEXCH-18709: Addednew users
//
//
// MH - 04/05/2017 - b101.042
// -------------------------------------------------
// * Removed Chris Sandow and Hassan Abdala
// * ABSEXCH-18668: Added Komal, Priyanka and Saroj
//
//
// MH - 20/07/2016 - b93.041
// -------------------------------------------------
// * Removed ROGER.EVANS, NEIL.ENDERSBY, DALE.MASON, PHILIP.ROGERS
//
// * Removed Eduardo's backdoor
//
//
// MH - 23/06/2016 - b92.040
// -------------------------------------------------
// * Added ANTHONY.CRONIN
//
// * Removed JAMES.PELHAM
//
// MH - 21/04/2016 - b91.039
// -------------------------------------------------
// * Added PHILIP.ROGERS, CONRAD.HERRING and HASSAN.ABDALLA
//
// MH - 05/05/2015
// -------------------------------------------------
// * Added JAMES.PELHAM
//
// MH - 11/09/2014 - b71.037
// -------------------------------------------------
// * Added Dale Mason and Ande Pearson into authorised users
//
//
// MH - 12/07/13 - b705.035
// -------------------------------------------------
// * Recompiled for Advanced branding changes
// * Removed Neil Frewer and added Loiuse Winter to authorised users  
//
//
// MH - 19/11/12 - b70.034
// -------------------------------------------------
// Modified to run from \\BMTDEVVMH2\LICENSING\
// Added theming support and corrected default font to make it LESS ugly
//
//
// MH - 05/04/11 - b67.033
// -------------------------------------------------
// Changed WebRel server URL
//
//
// MH - 23/03/11 - b67.032
// -------------------------------------------------
// Added Tansey Roberts
//
//
// MH - 23/03/11 - b67.031
// -------------------------------------------------
// Removed Ian Ross and added Jo Marsh
//
//
// MH - 15/03/11 - b67.030
// -------------------------------------------------
// Modified the security checks due to a server move
//
//
// MH - 04/08/09 - b600.029
// -------------------------------------------------
// Modified to allow access to Mark Roke
//
//
// MH - 22/07/09 - b600.028
// -------------------------------------------------
// Modified to allow Neil/Ian access to Plug-In pages
//
//
// MH - 29/10/07 - b600.027
// -------------------------------------------------
// Modified security check to run off Ronnie\Apps\
//
//
// MH - 26/10/06 - b571.025
// ---------------------------
// Added eBanking module
//
//
// MH - 21/07/05 - b570.024
// ---------------------------
// Rebranded
//
//
// MH - 21/07/05 - b570.023
// ---------------------------
// Added Goods Returns module
//

Type
  {$IFDEF EN561}
  RelCodeType = (rctFullCode=0, rct30Day=1, rct1Year=2);
  {$ENDIF}
  
  tLicense  = Record
                ESN        :  ISNArrayType;
                EntSecCode,
                EntUsrCode,
                EntModCode,
                EntModUCode,
                EntPICode,
                EntPIUCode,
                VectronCode,
                EntVer     :  String[20];
                {$IFDEF EN561}
                  Ent30Day   :  RelCodeType;
                {$ELSE}
                  Ent30Day   :  Boolean;
                {$ENDIF}
                UserCount,
                ModUserCount,
                ModuleNo,
                UsrModNo,
                PIUserCount
                          :  SmallInt;

                PISerial  :  LongInt;
              end;

Var
  SecRelLic  :  tLicense;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Initialization
  FillChar(SecRelLic,Sizeof(SecRelLic),#0);

end.

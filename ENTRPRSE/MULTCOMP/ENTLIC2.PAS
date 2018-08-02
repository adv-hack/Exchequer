unit ENTLIC2;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$IFDEF WIN32}
  {$ALIGN 1}  { Variable Alignment Disabled }
{$ENDIF}


interface

Uses

{$IFDEF WIN32}
  { Windows }
  Classes, Dialogs, Forms, SysUtils, Windows,
   {$IFDEF COMP}
     { Multi-Company Manager }
     GlobVar, VarConst,
   {$ENDIF}
{$ELSE}
  { DOS }
  OPDOS,
  ETPrompt,
{$ENDIF}

   LicRec,
   EntLic;


{ HM 21/06/01: Moved from EntLic to make EntLic standalone }
Procedure UpdateEntLic(IsMCFlg  :  Boolean);

implementation

Uses
  {$IFNDEF WIN32}
    { Exchequer }
    GlobVar,
    HelpSupU,

    VarConst,
    VarFPosU,
  {$ELSE}
    { Enterprise }

    {$IFDEF PF_On}
      HelpSupU,
      SecSup2U,

      {$IFNDEF COMP}
      VarConst,
      {$ENDIF}
      VarFPosU,
    {$ENDIF}
  {$ENDIF}

  Crypto;


{* Mark this probably will not compile for you, so you will need to place an empty version of UpdateEntLic for
   yourself and use compiler switches at this point to expose the dummy or correct version as desired *}

  Procedure UpdateEntLic(IsMCFlg  :  Boolean);
  {$IFNDEF TRADE}
  {$IFNDEF SETD}
  {$IFNDEF EBEX}  { eBusiness Export }
  {$IFNDEF HKSEC} { Hook Security DLL }
  Const
    { NOTE: This array cross-references the ExcchQss.Dat release code array }
    {       with the equivalent array in the Enterprise Licence File.       }
    // NOTE 2: Although dimensioned based on the licencing modules the array actually maps
    // onto the release code array in SyssMod and the array elements contain the index number
    // of that module within the licence record array.  The comments are the exch module desc
    RelTxLate  :  Array[1..ModLast] of Integer =
             { HM 20/09/01: Extended for new v5.00 modules }
             (0,                     { Multi-Currency }
              modJobCost,            { Job Costing }
              modRepWrt,             { Report Writer }
              modToolDLLR,           { Toolkit DLL }
              modTeleSale,           { Telesales }
              modAccStk,             { Account Stock Analysis }
              modEBus,               { E-Business }
              modPaperless,          { Paperless }
              modOLESave,            { OLE Save }
              modCommit,             { Commitment Accounting }
              modTrade,              { Trade Counter }
              modStdWOP,             { Standard WOP }
              modProWOP,             { Professional WOP }
              modElerts,             { Sentimail }
              modEnhSec,             { Enhanced Security }
              modCISRCT,             { Job Costing CIS/RCT }
              modAppVal,             { 17: Job Costing Applications & Valuations }
              modFullStock,          { 18: Full Stock Control }
              modVisualRW,           { 19: v5.61 Visual Report Writer }
              modGoodsRet,           { 20: Goods Returns (v5.70) }
              modEBanking,           { 21: eBanking (v5.71) }
              modOutlookDD,          { 22: Outloook Dynamic Dashboard (v5.71) }
              modImpMod,             { 23: Importer (v6.00) }
              // MH 15/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
              modGDPR,               { 24: 2018-R1 - GDPR }
              modPervEncrypt,        { 25: 2018-R1 - Pervasive File Encryption }
              0);

  Var
    LicRec  :  EntLicenceRecType;
    n,Idx   :  Integer;


  {* Status flags opposite way around than mod rel, function copies them around. *}

  Function  SetLicMod(Idx  :  Integer)  :  Integer;

  Begin
    Case Idx of

      1    :  SetLicMod:=3-Idx;
      else    SetLicMod:=0;

    end; {Case..}

  end;


  Begin

    If Not (ReadEntLic (EntLicFName,LicRec)) then
      FillChar (LicRec, SizeOf(LicRec), #0);

    With LicRec do
    Begin
      {$IFNDEF COMP}
        {$IFDEF MC_On}
           LicEntCVer:=1+(1*Ord(ModRelMode(1)<>0));
        {$ELSE}
           {$IFDEF SCUD1}
             If (IsMCFlg) then
               LicEntCVer:=1+(1*Ord(ModRelMode(1)<>0))
             else
               LicEntCVer:=0;

           {$ELSE}
             LicEntCVer:=0;

          {$ENDIF}
        {$ENDIF}
      {$ELSE}
        { Multi-Company Manager - if multi-currency then recalculate currency version }
        If (LicEntCVer > 0) Then
          LicEntCVer:=1+(1*Ord(ModRelMode(1)<>0));
      {$ENDIF}

      With Syss do
        LicUserCnt:=DeCode_Usrs(ExUsrSec,ExUsrRel);

      For n:=2 to ModLast do
      If (n<=High(RelTxLate)) then
      Begin
        Idx:=ModRelMode(n);

        If (RelTxLate[n]<>0) then
        Begin
          {$IFDEF WIN32}
            If (Not Check_RelDateExp(n,False)) then
          {$ELSE}
            If (Not Check_RelDateExp(n)) then
          {$ENDIF}

            LicModules[RelTxlate[n]]:=1
          else
            LicModules[RelTxlate[n]]:=SetLicMod(Idx);

        end;
      end;

      If (Not WriteEntLic (EntLicFName,LicRec)) then {* Display a suitable message *}
      Begin
        {$IFDEF WIN32}
          ShowMessage('It was not possible to update the Licence File.');
        {$ELSE}
          PopAnyKey(3,PopGenW,'It was not possible to update the Exchequer Licence File.');
        {$ENDIF}
      end;
    end;

  {$ELSE}
  begin
  {$ENDIF}
  {$ELSE}
  begin
  {$ENDIF}
  {$ELSE}
  begin
  {$ENDIF}
  {$ELSE}
  begin
  {$ENDIF}
  end;

end.

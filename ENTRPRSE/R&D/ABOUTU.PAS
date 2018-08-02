unit AboutU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, TEditVal, SBSPanel, IniFiles,PIMisc,APIUtil;

type
  TROStringList = Class(TStringList)
  Public
    procedure LoadFromFile(const FileName: string); override;
  End; // TROStringList

  TAboutFrm= class(TForm)
    Memo1: TMemo;
    VerF: Label8;
    OkI1Btn: TButton;
    DLLVer: Label8;
    SBSPanel1: TSBSPanel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    JustCreated  :   Boolean;
  public
    { Public declarations }
  end;

Var
  AbMode  :  Byte;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  GlobVar,
  VarConst,
  BTrvU2,
  BTSupU1,
  {$IFDEF ENTER1}      //Added SOP/ENTER1 comp def to handle lCCPluginInstalled only for Enter1
    {$IFDEF SOP}
    oCreditCardGateway,
    {$ENDIF}
  {$ENDIF}
  PWarnU,
  UA_Const,
  {$IFDEF EDLL}
    GlobType,
  {$ELSE}
    {$IFNDEF RW}
      {$IFNDEF XO}
      {$IFNDEF WCA}
        {$IFNDEF ENDV}  { Customisation Development Program }
           {HelpSupU,}
           SecSup2U,
           ETStrU,
        {$ENDIF}
      {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  {$IFNDEF RW}         { Cannot include in Report Writer as completely toasts it }
    {$IFNDEF XO}
      {$IFNDEF COMP}     { Don't want for multi-company manager }
        {$IFNDEF EDLL}
          {$IFNDEF ENDV}  { Customisation Development Program }
          {$IFNDEF WCA}
          {$IFNDEF EBAD}
            {$IFDEF FRM}
              DllInt,
            {$ENDIF}
          {$ENDIF}
          {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  {$IFDEF CU}
    CustIntU,
  {$ENDIF}

  {$IFDEF COMP}
    UserSec,       { Global User Count Security }
    History,
  {$ENDIF}
  {$IFDEF EDLL}
    History,
  {$ENDIF}
  {$IFDEF IMPv6}
    GlobalConsts,
    TIniClass,
  {$ENDIF}

  // NOTE: Can't do IFDEF LTE as this unit is used by many of the standard components
  // which need to be able to dynamically switch between Exchequer and IAO branding
  Brand,
  EntLicence,
  VAOUtil,

  LicRec,
  LicFuncU,

  BTSupU2;

{$R *.DFM}


//=========================================================================

procedure TROStringList.LoadFromFile(const FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

//=========================================================================

procedure TAboutFrm.FormCreate(Sender: TObject);

Type
  VerRec   =  Record
                Ver,Rel  :  Integer;
                Typ      :  Char;

              end;
Var
  Locked  :  Boolean;

  n       :  Byte;

  ConRec  :  Array[1..3] of VerRec;

  ServeMake
          :  Str20;

  sPrefix, ESNStr  :  String;

  {$IFDEF COMP}
    TotalLic,
    CurrUsed  : SmallInt;
    Res       : LongInt;
  {$ENDIF}

  oBranding : IProductBrandingFile;
  iLines, iText : SmallInt;

  lCCPluginInstalled : Boolean;
  lCCPluginVersion,lPortalVersion : String;

  Function GetWorkgroupServer : ShortString;
  Var
    LocatorFile : TROStringList;
  Begin // GetWorkgroupServer
    Result := 'Unknown';

    If FileExists(VAOInfo.vaoCompanyDir + '~PVSW~.LOC') Then
    Begin
      LocatorFile := TROStringList.Create;
      Try
        LocatorFile.LoadFromFile(VAOInfo.vaoCompanyDir + '~PVSW~.LOC');
        If (LocatorFile.Count > 0) Then
          Result := LocatorFile.Strings[0];
      Finally
        LocatorFile.Free;
      End; // Try..Finally
    End; // If FileExists(VAOInfo.vaoCompanyDir + '~PVSW~.LOC')
  End; // GetWorkgroupServer

begin
  // NOTE: Can't do IFDEF's as this unit is used by many of the standard components
  // which need to be able to dynamically switch between Exchequer and IAO branding

  // MH 30/03/06: Rebranding for IAO/Exchequer support
  Caption := 'About ' + Branding.pbProductName;

  // Check for the existence of the branding file for the about dialog
  If Branding.BrandingFileExists (ebfAbout) Then
  Begin
    oBranding := Branding.BrandingFile(ebfAbout);
    Try
      oBranding.ExtractImage (Image1, 'Logo');

      // MH 11/07/2013 v7.0.5: Modified text to come from branding file for all product variants
      If (EnterpriseLicence.elExchequerEdition = exSmallBusiness) Then
        sPrefix := 'SBELine'
      Else
        sPrefix := 'Line';

      Memo1.Lines.Clear;

      iLines := oBranding.pbfData.GetInteger(sPrefix+'s', 0);
      For iText := 1 To iLines Do
      Begin
        Memo1.Lines.Add(oBranding.pbfData.GetString(sPrefix + IntToStr(iText)));
      End; // With Memo1.Lines
    Finally
      oBranding := NIL;
    End; // Try..Finally
  End; // If Branding.BrandingFileExists (ebfAbout)

  {$IFDEF IMPv6}
    //PR: 15/07/2013 ABSEXCH-14438 Rebranding - added form caption + ini version
    Self.Caption := 'About Exchequer Importer';
    VerF.Caption := 'Importer Version: ' + APPVERSION;
    DLLVer.Caption := 'Dat Version: ' + IniFile.Version;
  {$ELSE}
    {$IFNDEF WCA}
      {$IFNDEF RW}
        {$IFNDEF XO}
          {$IFNDEF COMP}
            {$IFNDEF EBAD}
              ServeMake:='';
              ESNStr:='';

              {$IFNDEF EDLL}
                {$IFDEF LTE}
                  VerF.Caption:='Version: ' + EnterpriseLicence.elLongVersionDesc + ' ' + CurrVersion;
                {$ELSE}
                  VerF.Caption:=Trim('Version: '+Ver);
                {$ENDIF}

                {Hide bitmap on TS switch}
                Image1.Visible:=Not NoXLogo;
              {$ELSE}
                Self.Caption := 'About Form Designer';
                VerF.Caption:='Version: '+SystemInfo.FormDesVer;
              {$ENDIF}

              {$IFNDEF EDLL}
                {$IFNDEF ENDV}
                  {$IFDEF FRM}
                    DLLVer.Caption:='Forms Version: ' + sbsForm_GetDllVer;
                  {$ENDIF}
                {$ENDIF}
              {$ELSE}
                // HM 12/08/03: Moved SbsForm version to local History.Pas
                DLLVer.Caption:='Dll Version: ' + SbsFormVer;
              {$ENDIF}
            {$ELSE}
              //Caption := 'About...Exchequer';
              VerF.Caption:='';
              DLLVer.Caption:='Version: ???';
            {$ENDIF}
          {$ELSE}
            // Multi-Company Manager
            //Caption := 'About...Exchequer';
            VerF.Caption:='';
            DLLVer.Caption:='MCM Version: '+CurrVersion_Comp;
          {$ENDIF}
        {$ELSE}
          Caption := 'About...XO';
          VerF.Caption:='';
          DLLVer.Caption:='Version: '+CurrVersion_XO;
        {$ENDIF}
      {$ELSE}
        // Insert RW desc at top of memo
        Memo1.Lines.Insert (0, 'Exchequer Report Writer');
        Memo1.Lines.Insert (1, '');
        
        Caption := 'About...Report Writer';
        VerF.Caption:='';
        DLLVer.Caption:='Version: '+CurrVersion_RW;
      {$ENDIF}
    {$ELSE}
      Caption := 'About...Exchequer Card System';
      VerF.Caption:='';
      DLLVer.Caption:='Version: '+CurrVersion_WCA;
    {$ENDIF}
  {$ENDIF} // IFDEF IMPv6

 {$IFNDEF EDLL}
   {$IFNDEF RW}
     {$IFNDEF XO}
       {$IFNDEF ENDV}
          If (ABMode=1) then
            With Memo1,Lines do
            Begin
              Clear;
              Alignment:=taCenter;

              // MH 30/03/06: Rebrandded
              //Caption:='Exchequer. Current Session Information';
              Caption:=Branding.pbProductName + ' - Current Session Information';

              Font.Style:=[fsBold];

              Add('');

              Add('Total users logged in:-');
              Add('~~~~~~~~~~~~~~~');

              {$IFNDEF COMP}
                // Enterprise, etc...

                Locked:=BOff;

                GetMultiSys(BOff,Locked,SysR);

                With Syss do
                  Add(InttoStr(Syss.EntULogCount)+'/'+
                      InttoStr(DeCode_Usrs(ExUsrSec,ExUsrRel)));
              {$ELSE}
                // Multi-Company Manager - display Global User Count Info
                Res := GetCurrentUserCounts (cmUserCount, TotalLic, CurrUsed);
                If (Res = 0) Then
                  Add (Format ('Accounts:  %d/%d', [CurrUsed, TotalLic]));

                If (Branding.pbProduct <> ptLITE) Then
                Begin
                  Res := GetCurrentUserCounts (cmTKUserCount, TotalLic, CurrUsed);
                  If (Res = 0) Then
                    Add (Format ('Toolkit:  %d/%d', [CurrUsed, TotalLic]));

                  Res := GetCurrentUserCounts (cmTradeUserCount, TotalLic, CurrUsed);
                  If (Res = 0) Then
                    Add (Format ('Trade Counter:  %d/%d', [CurrUsed, TotalLic]));
                End; // If (Branding.pbProduct <> ptLITE)
              {$ENDIF}

              Add('');

              // MH 10/07/07: Modified to suppress Btrieve version information under MS SQL Server as it is all hard-coded
              If (Not EnterpriseLicence.IsSQL) Then
              Begin
                {$IFNDEF COMP}
                  // NOT Multi-Company Manager
                  If (BTFileVer>=6) then
                    Add('v'+IntToStr(BTFileVer)+' Format data files.')
                  else
                    Add('v5 Data files. - Protected Mode disabled.');

                  Add('~~~~~~~~~~~~~~~~~~~~');

                  For n:=1 to 3 do
                    With ConRec[n] do
                      GetBtrvVer(F[SysF],Ver,Rel,Typ,n);
                {$ELSE}
                  // Multi-Company Manager
                  For n:=1 to 3 do
                    With ConRec[n] do
                      GetBtrvVer(F[CompF],Ver,Rel,Typ,n);
                {$ENDIF}

                With ConRec[3] do
                  If (Typ=BCSType) or (Typ=BNTCSType) then
                  Begin
                    If (Typ=BCSType) then
                      ServeMake:='Novell'
                    else
                      If (Typ=BNTCSType) then
                        ServeMake:='Windows NT';

                    Add('Client Server connection on '+ServeMake);
                  end
                  else
                    // HM 13/10/03: Added support for Workgroup
                    If (Typ='9') Or ((Typ = #0) And (ConRec[2].Typ = '9')) Then
                    Begin
                      Add('Workgroup on ' + GetWorkgroupServer);
                    end
                    else
                      Add('Local connection');

                Add('');

                Add('Btrieve Engine versions:-');
                Add('~~~~~~~~~~~~~~~~~');

                With ConRec[2] do
                  Add('MKDB  :  '+IntToStr(Ver)+'.'+IntToStr(Rel)+Typ);

                {$IFDEF BCS}
                  // NOTE: Duplicated below for MCM - keep both in sync
                  With ConRec[1] do
                    Add('Requester  :  '+IntToStr(Ver)+'.'+IntToStr(Rel)+Typ);

                  With ConRec[3] do
                    Add('Server  :  '+IntToStr(Ver)+'.'+IntToStr(Rel)+Typ);
                {$ELSE}
                  {$IFDEF COMP}
                    // NOTE: Duplicated above for Enterprise - keep both in sync
                    With ConRec[1] do
                      Add('Requester  :  '+IntToStr(Ver)+'.'+IntToStr(Rel)+Typ);

                    With ConRec[3] do
                    Begin

                      Add('Server  :  '+IntToStr(Ver)+'.'+IntToStr(Rel)+Typ);

                    end;
                  {$ENDIF}
                {$ENDIF}
              End; // If (Not EnterpriseLicence.IsSQL
            End // With Memo1,Lines
          else
            If (ABMode=0) then
              // HM 29/05/02: Updated ESN display as was previously displaying old format 6-segment ESN
              With Memo1.Lines Do Begin
                {$IFNDEF IMPv6}
                Add('');
                Add ('ESN: ' + licESN7Str (ESNByteArrayType(Syss.ExISN), Ord(Syss.ExDemoVer)));
                {$ENDIF}
              End; { With Memo1.Lines }
            (****
            With Memo1,Lines do
            Begin
              For n := 1 To 6 Do
              Begin
                ESNStr := ESNStr+ SetPadNo(IntToStr (Syss.ExISN[N]),3);

                If (N < 6) Then
                  ESNSTR := ESNStr + '-';
              End; { For I }

              Add('');
              Add('Exchequer Site No. '+ESNStr);

            end;
            ****)
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  {$IFDEF CU}
    // MH 30/03/06: Suppress customisation section for lite
    {$IFNDEF LTE}
      If (ABMode = 0) Then Begin
        { Normal About Box - Add Any Customisation Messages }
        AddCustomAbout(Memo1);
      End; { If }
    {$ENDIF}
  {$ENDIF}

  {$IFDEF ENTER1}    //Added SOP/ENTER1 comp def to handle lCCPluginInstalled only for Enter1
    {$IFDEF SOP}
  {SS:29/09/2016 :ABSEXCH-16786:CC Plugin to be listed in Help > About.}
  lCCPluginInstalled := CreditCardPaymentGateway.ccpgInstalled And
                          CreditCardPaymentGateway.ccpgLicenced and
                          ChkAllowed_In(uaAccessToCCPaymentGateway);
  if lCCPluginInstalled then
  begin
    lCCPluginVersion := 'Credit Card Plug-In '+GetFileVersion('ExchequerPaymentGateway.dll');

    lPortalVersion   := 'Exchequer Payment Portal version '+ GetFileVersion('Exchequer.Payments.Portal.COM.Client.dll');

    lCCPluginVersion := lCCPluginVersion +#13#10 +'               '+ lPortalVersion;
    PIMakeAboutText('Credit Card Plug-In ',lCCPluginVersion,Memo1.Lines);

  end;
    {$ENDIF}
  {$ENDIF} // ENDIF {$IFNDEF Enter1}

  {$IFDEF COMP}
    If (ABMode = 2) Then
    Begin
      Memo1.Lines.Add('');
      Memo1.Lines.Add ('ESN: ' + licESN7Str (ESNByteArrayType(Syss.ExISN), Ord(Syss.ExDemoVer)));
      Memo1.Lines.Add ('');
      Memo1.Lines.Add ('Main Dir: ' + LowerCase(ExtractFilePath(Application.ExeName)));
    End; { If allowDir }
  {$ENDIF}

  JustCreated:=BOn;
end;

procedure TAboutFrm.FormActivate(Sender: TObject);
begin
  If (JustCreated) then
  Begin
    {$IFNDEF EDLL}
      MDI_ForceParentBKGnd(BOn);
    {$ENDIF}

    JustCreated:=BOff;
  end;
end;


Initialization

ABMode:=0;

end.

unit AboutU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, TEditVal, SBSPanel, IniFiles;

const
  {$IFDEF EX600}
  RW_CurrVersion = 'v6.9.068';
  {$ELSE}
  RW_CurrVersion = 'v5.71.060';
  {$ENDIF}

type
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

  LicRec,
  LicFuncU,

  BTSupU2;

{$R *.DFM}


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

  ESNStr  :  String;

  {$IFDEF COMP}
    TotalLic,
    CurrUsed  : SmallInt;
    Res       : LongInt;
  {$ENDIF}

begin
  {$IFNDEF WCA}
    {$IFNDEF RW}
      {$IFNDEF XO}
        {$IFNDEF COMP}
        {$IFNDEF EBAD}
          ServeMake:='';
          ESNStr:='';

          {$IFNDEF EDLL}
          VerF.Caption:='Version: '+Ver;

          {Hide bitmap on TS switch}
          Image1.Visible:=Not NoXLogo;

          {$ELSE}
          VerF.Caption:='Version: '+SystemInfo.FormDesVer;
          {$ENDIF}

          {$IFNDEF EDLL}
            {$IFNDEF ENDV}
              {$IFDEF FRM}
                DLLVer.Caption:='Dll Version: ' + sbsForm_GetDllVer;
              {$ENDIF}
            {$ENDIF}
          {$ELSE}
            // HM 12/08/03: Moved SbsForm version to local History.Pas
            DLLVer.Caption:='Dll Version: ' + SbsFormVer;
          {$ENDIF}
        {$ELSE}
          Caption := 'About...Exchequer Enterprise';
          VerF.Caption:='';
          DLLVer.Caption:='Version: ???';
        {$ENDIF}
        {$ELSE}
          Caption := 'About...Exchequer Enterprise';
          VerF.Caption:='';
          DLLVer.Caption:='MCM Version: '+CurrVersion_Comp;
        {$ENDIF}
      {$ELSE}
        Caption := 'About...Exchequer Enterprise XO';
        VerF.Caption:='';
        DLLVer.Caption:='Version: '+CurrVersion_XO;
      {$ENDIF}
    {$ELSE}
      Caption := 'About...Exchequer Report Writer';
      VerF.Caption:='';
      DLLVer.Caption:='Version: '+RW_CurrVersion;
    {$ENDIF}
  {$ELSE}
    Caption := 'About...Exchequer Enterprise Card System';
    VerF.Caption:='';
    DLLVer.Caption:='Version: '+CurrVersion_WCA;
  {$ENDIF}

 {$IFNDEF EDLL}
   {$IFNDEF RW}
     {$IFNDEF XO}
       {$IFNDEF ENDV}
          If (ABMode=1) then
          With Memo1,Lines do
          Begin
            Clear;
            Alignment:=taCenter;

            Caption:='Exchequer. Current Session Information';

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
                Add (Format ('Exchequer:  %d/%d', [CurrUsed, TotalLic]));

              Res := GetCurrentUserCounts (cmTKUserCount, TotalLic, CurrUsed);
              If (Res = 0) Then
                Add (Format ('Toolkit:  %d/%d', [CurrUsed, TotalLic]));

              Res := GetCurrentUserCounts (cmTradeUserCount, TotalLic, CurrUsed);
              If (Res = 0) Then
                Add (Format ('Trade Counter:  %d/%d', [CurrUsed, TotalLic]));
            {$ENDIF}

            Add('');

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
                If (Typ='9') then
                Begin
                  With TIniFile.Create (ExtractFilePath(Application.ExeName)+'WSTATION\SETUP.USR') Do
                  Begin
                    Try
                      Add('Workgroup on ' + ReadString('Workgroup', 'ServerPC', 'unknown'));
                    Finally
                      Free;
                    End;
                  End; // With TIniFile.Create (...
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
              Begin

                Add('Server  :  '+IntToStr(Ver)+'.'+IntToStr(Rel)+Typ);

              end;
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

          end
          else
            If (ABMode=0) then
              // HM 29/05/02: Updated ESN display as was previously displaying old format 6-segment ESN
              With Memo1.Lines Do Begin
                Add('');
                Add ('ESN: ' + licESN7Str (ESNByteArrayType(Syss.ExISN), Ord(Syss.ExDemoVer)));
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
    If (ABMode = 0) Then Begin
      { Normal About Box - Add Any Customisation Messages }
      AddCustomAbout(Memo1);
    End; { If }
  {$ENDIF}

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

unit SetModU;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, BorBtns, ExtCtrls, ClipBrd, StrUtils,
  GlobVar,VarConst,BTSupU1, SBSPanel, SecureU, RPDefine, RPBase, RPFiler,
  RPCanvas, RPrinter, ComCtrls, LicRec, BtrvU2, SecFrame, VarRec2U, SecSup2U;

Const
  NoModules = 25;

type
  TSetModRec = class(TForm)
    PageControl1: TPageControl;
    tabshModules: TTabSheet;
    tabshUsers: TTabSheet;
    Label82: Label8;
    Label83: Label8;
    Label85: Label8;
    Label86: Label8;
    ScrollBox1: TScrollBox;
    Label81: Label8;
    Label87: Label8;
    Label88: Label8;
    Label89: Label8;
    Label814: Label8;
    Label815: Label8;
    Label816: Label8;
    Label817: Label8;
    Label818: Label8;
    Label819: Label8;
    Label820: Label8;
    Label821: Label8;
    Label822: Label8;
    Label823: Label8;
    Label824: Label8;
    Label825: Label8;
    Label833: Label8;
    Label834: Label8;
    Label835: Label8;
    Label836: Label8;
    Label837: Label8;
    Label838: Label8;
    Label839: Label8;
    Label840: Label8;
    Label841: Label8;
    CDesc1: Text8Pt;
    CSS1: Text8Pt;
    RS1: Text8Pt;
    ST1: Text8Pt;
    CDesc2: Text8Pt;
    RS2: Text8Pt;
    ST2: Text8Pt;
    CDesc3: Text8Pt;
    CSS3: Text8Pt;
    RS3: Text8Pt;
    ST3: Text8Pt;
    CSS2: Text8Pt;
    Cdesc4: Text8Pt;
    CSS4: Text8Pt;
    RS4: Text8Pt;
    ST4: Text8Pt;
    Cdesc5: Text8Pt;
    CSS5: Text8Pt;
    RS5: Text8Pt;
    ST5: Text8Pt;
    CDesc6: Text8Pt;
    CSS6: Text8Pt;
    RS6: Text8Pt;
    ST6: Text8Pt;
    CDesc7: Text8Pt;
    CSS7: Text8Pt;
    RS7: Text8Pt;
    ST7: Text8Pt;
    CDesc8: Text8Pt;
    CSS8: Text8Pt;
    RS8: Text8Pt;
    ST8: Text8Pt;
    CDesc9: Text8Pt;
    CSS9: Text8Pt;
    RS9: Text8Pt;
    ST9: Text8Pt;
    CDesc10: Text8Pt;
    CSS10: Text8Pt;
    RS10: Text8Pt;
    ST10: Text8Pt;
    CDesc11: Text8Pt;
    CSS11: Text8Pt;
    RS11: Text8Pt;
    ST11: Text8Pt;
    CDesc12: Text8Pt;
    CSS12: Text8Pt;
    RS12: Text8Pt;
    ST12: Text8Pt;
    Cdesc13: Text8Pt;
    CSS13: Text8Pt;
    RS13: Text8Pt;
    ST13: Text8Pt;
    Cdesc14: Text8Pt;
    CSS14: Text8Pt;
    RS14: Text8Pt;
    ST14: Text8Pt;
    Label84: Label8;
    Label810: Label8;
    Label811: Label8;
    Label812: Label8;
    ScrollBox2: TScrollBox;
    Label813: Label8;
    Label826: Label8;
    Label827: Label8;
    Label828: Label8;
    Label829: Label8;
    UCDesc1: Text8Pt;
    UCSS1: Text8Pt;
    URS1: Text8Pt;
    UST1: Text8Pt;
    UCDesc2: Text8Pt;
    URS2: Text8Pt;
    UST2: Text8Pt;
    UCDesc3: Text8Pt;
    UCSS3: Text8Pt;
    URS3: Text8Pt;
    UST3: Text8Pt;
    UCSS2: Text8Pt;
    UCDesc4: Text8Pt;
    UCSS4: Text8Pt;
    URS4: Text8Pt;
    UST4: Text8Pt;
    UCDesc5: Text8Pt;
    UCSS5: Text8Pt;
    URS5: Text8Pt;
    UST5: Text8Pt;
    Cdesc15: Text8Pt;
    CSS15: Text8Pt;
    RS15: Text8Pt;
    ST15: Text8Pt;
    tabshPlugIn: TTabSheet;
    scrlPlugIns: TScrollBox;
    Label830: Label8;
    lblESN: Label8;
    Cdesc16: Text8Pt;
    CSS16: Text8Pt;
    RS16: Text8Pt;
    ST16: Text8Pt;
    Cdesc17: Text8Pt;
    CSS17: Text8Pt;
    RS17: Text8Pt;
    ST17: Text8Pt;
    Cdesc18: Text8Pt;
    CSS18: Text8Pt;
    RS18: Text8Pt;
    ST18: Text8Pt;
    Cdesc19: Text8Pt;
    CSS19: Text8Pt;
    RS19: Text8Pt;
    ST19: Text8Pt;
    CDesc20: Text8Pt;
    CSS20: Text8Pt;
    RS20: Text8Pt;
    ST20: Text8Pt;
    Label831: Label8;
    CDesc21: Text8Pt;
    CSS21: Text8Pt;
    RS21: Text8Pt;
    ST21: Text8Pt;
    RBtn1: TButton;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Label832: Label8;
    CDesc22: Text8Pt;
    CSS22: Text8Pt;
    RS22: Text8Pt;
    ST22: Text8Pt;
    Label842: Label8;
    CDesc23: Text8Pt;
    CSS23: Text8Pt;
    RS23: Text8Pt;
    ST23: Text8Pt;
    CDesc24: Text8Pt;
    CSS24: Text8Pt;
    RS24: Text8Pt;
    ST24: Text8Pt;
    CDesc25: Text8Pt;
    CSS25: Text8Pt;
    RS25: Text8Pt;
    ST25: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure RS1Exit(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure RBtn1Click(Sender: TObject);
    procedure DispPhoneticSecCode(Sender: TObject);
    procedure DispPhoneticRelCode(Sender: TObject);
    procedure URS1Exit(Sender: TObject);
    procedure lblESNDblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }

    BeenStored
             :  Boolean;

    DescAry  :  Array[1..NoModules] of Text8Pt;
    SSymbAry :  Array[1..NoModules] of Text8Pt;
    RSymbAry :  Array[1..NoModules] of Text8Pt;
    StatAry  :  Array[1..NoModules] of Text8Pt;

    UserDescAry  : Array[1..ucLast] of Text8Pt;
    UserSSymbAry : Array[1..ucLast] of Text8Pt;
    UserRSymbAry : Array[1..ucLast] of Text8Pt;
    UserStatAry  : Array[1..ucLast] of Text8Pt;

    TheReport : TBaseReport;

    // Plug-In Security
    FrameAry   : Array Of TPlugInSecFrame;
    TmpSysESN  : ISNArrayType;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    procedure OutEq;
    Procedure InitUCounts (Const SetupArray : Boolean = True);
    Procedure SetUCount(Const UCIDx : Byte);
    function CalcUserModuleNo (Const ModNo : SmallInt) : SmallInt;

    Procedure Generate_Lic(GetRec  :  Boolean);

    Function ThisLine(Const Sender  :  TObject;
                      Const TMode   :  Byte)  :  Integer;

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure SetSyssStore(EnabFlag,
                           VOMode  :  Boolean);


    procedure StoreSyss;

    procedure ShutDown;

    procedure LoadPlugIns;
  public
    { Public declarations }
    procedure ProcessSyss;

  end;

  TModuleMode = (mmAll, mmPlugIns);


Var
  ModuleMode : TModuleMode = mmPlugIns;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETDateU,
  EtStrU,
  ETMiscU,
  ComnUnit,
  ComnU2,
  HelpSupU,

  {$IFDEF Frm}
    {PrintFrm,}
  {$ENDIF}

  {$IFDEF Rp}
    {RPDefine,
    RPDevice,
    ReportHU,}
  {$ENDIF}

  RpDevice,

  Phonetic,
  UserSec,
  EntLic,
  LicFuncU,

  // MH 10/01/2017 2017R1 ABSEXCH-17996: Added support for Information Table
  SQLUtils, oInformationTable, InformationTableFuncs,

  SysU3,
  BTSupU2;


{$R *.DFM}


Procedure TSetModRec.WMFormCloseMsg(Var Message  :  TMessage);

Begin
  With Message do
  Begin

    Case WParam of

      8  :  ShutDown;

    end; {Case..}

  end; {With..}
end;


procedure TSetModRec.OutEq;
Var
  n  :  Integer;
  RM :  Byte;
begin
  RM:=0;

  // Module Arrays
  FillChar(DescAry,Sizeof(DescAry),0);
  FillChar(SSymbAry,Sizeof(SSymbAry),0);
  FillChar(RSymbAry,Sizeof(RSymbAry),0);
  FillChar(StatAry,Sizeof(StatAry),0);
  DescAry[1] :=CDesc1;  SSymbAry[1] :=CSS1;  RSymbAry[1] :=RS1;  StatAry[1] :=ST1;
  DescAry[2] :=CDesc2;  SSymbAry[2] :=CSS2;  RSymbAry[2] :=RS2;  StatAry[2] :=ST2;
  DescAry[3] :=CDesc3;  SSymbAry[3] :=CSS3;  RSymbAry[3] :=RS3;  StatAry[3] :=ST3;
  DescAry[4] :=CDesc4;  SSymbAry[4] :=CSS4;  RSymbAry[4] :=RS4;  StatAry[4] :=ST4;
  DescAry[5] :=CDesc5;  SSymbAry[5] :=CSS5;  RSymbAry[5] :=RS5;  StatAry[5] :=ST5;
  DescAry[6] :=CDesc6;  SSymbAry[6] :=CSS6;  RSymbAry[6] :=RS6;  StatAry[6] :=ST6;
  DescAry[7] :=CDesc7;  SSymbAry[7] :=CSS7;  RSymbAry[7] :=RS7;  StatAry[7] :=ST7;
  DescAry[8] :=CDesc8;  SSymbAry[8] :=CSS8;  RSymbAry[8] :=RS8;  StatAry[8] :=ST8;
  DescAry[9] :=CDesc9;  SSymbAry[9] :=CSS9;  RSymbAry[9] :=RS9;  StatAry[9] :=ST9;
  DescAry[10]:=CDesc10; SSymbAry[10]:=CSS10; RSymbAry[10]:=RS10; StatAry[10]:=ST10;
  DescAry[11]:=CDesc11; SSymbAry[11]:=CSS11; RSymbAry[11]:=RS11; StatAry[11]:=ST11;
  DescAry[12]:=CDesc12; SSymbAry[12]:=CSS12; RSymbAry[12]:=RS12; StatAry[12]:=ST12;
  DescAry[13]:=CDesc13; SSymbAry[13]:=CSS13; RSymbAry[13]:=RS13; StatAry[13]:=ST13;
  DescAry[14]:=CDesc14; SSymbAry[14]:=CSS14; RSymbAry[14]:=RS14; StatAry[14]:=ST14;
  DescAry[15]:=CDesc15; SSymbAry[15]:=CSS15; RSymbAry[15]:=RS15; StatAry[15]:=ST15;
  DescAry[16]:=CDesc16; SSymbAry[16]:=CSS16; RSymbAry[16]:=RS16; StatAry[16]:=ST16;
  DescAry[17]:=CDesc17; SSymbAry[17]:=CSS17; RSymbAry[17]:=RS17; StatAry[17]:=ST17;
  DescAry[18]:=CDesc18; SSymbAry[18]:=CSS18; RSymbAry[18]:=RS18; StatAry[18]:=ST18;
  DescAry[19]:=CDesc19; SSymbAry[19]:=CSS19; RSymbAry[19]:=RS19; StatAry[19]:=ST19;
  DescAry[20]:=CDesc20; SSymbAry[20]:=CSS20; RSymbAry[20]:=RS20; StatAry[20]:=ST20;
  DescAry[21]:=CDesc21; SSymbAry[21]:=CSS21; RSymbAry[21]:=RS21; StatAry[21]:=ST21;
  DescAry[22]:=CDesc22; SSymbAry[22]:=CSS22; RSymbAry[22]:=RS22; StatAry[22]:=ST22;
  DescAry[23]:=CDesc23; SSymbAry[23]:=CSS23; RSymbAry[23]:=RS23; StatAry[23]:=ST23;

  // MH 16/11/2018 ABSEXCH-19452 2018-R1: New GDPR Modules
  { 2018-R1 - GDPR }
  DescAry[24]:=CDesc24; SSymbAry[24]:=CSS24; RSymbAry[24]:=RS24; StatAry[24]:=ST24;
  { 2018-R1 - Pervasive File Encryption }
  DescAry[25]:=CDesc25; SSymbAry[25]:=CSS25; RSymbAry[25]:=RS25; StatAry[25]:=ST25;

  // Set Module Release Codes
  With SyssMod^ Do
  Begin
    For N := Low(DescAry) To High(DescAry) Do
    Begin
      If Assigned(DescAry[n]) Then
      Begin
        With ModuleRel Do
        Begin
          SSymbAry[n].Text:=ModuleSec[n,BOff];
          RSymbAry[n].Text:=ModuleSec[n,BOn];

          RM:=ModRelMode(n);

          If (Not RBtn1.Enabled) then
            RBtn1.Enabled:=(RM=0);

          With StatAry[n] Do
          Begin
            If (Not Check_RelDateExp(n,BOff)) then
              Text:='30 Day'
            Else
              Case RM of
                1  :  Text:='Enabled';
              Else
                Text:='Disabled';
              End; { Case }
          End; // With StatAry[n]
        End; // With ModuleRel
      End; // If Assigned(DescAry[n])
    End; // For N
  End; // With SyssMod^
End;

//-----------------------------------------------------------------------------

Procedure TSetModRec.InitUCounts (Const SetupArray : Boolean = True);
Var
  n  :  Integer;
Begin { InitUCounts }
  If SetupArray Then Begin
    // Module Arrays
    FillChar(UserDescAry,  Sizeof(UserDescAry),  #0);
    FillChar(UserSSymbAry, Sizeof(UserSSymbAry), #0);
    FillChar(UserRSymbAry, Sizeof(UserRSymbAry), #0);
    FillChar(UserStatAry,  Sizeof(UserStatAry),  #0);
    UserDescAry[1]:=UCDesc1;  UserSSymbAry[1]:=UCSS1;  UserRSymbAry[1]:= URS1;  UserStatAry[1]:=UST1;
    UserDescAry[2]:=UCDesc2;  UserSSymbAry[2]:=UCSS2;  UserRSymbAry[2]:= URS2;  UserStatAry[2]:=UST2;
    UserDescAry[3]:=UCDesc3;  UserSSymbAry[3]:=UCSS3;  UserRSymbAry[3]:= URS3;  UserStatAry[3]:=UST3;
    UserDescAry[4]:=UCDesc4;  UserSSymbAry[4]:=UCSS4;  UserRSymbAry[4]:= URS4;  UserStatAry[4]:=UST4;
    UserDescAry[5]:=UCDesc5;  UserSSymbAry[5]:=UCSS5;  UserRSymbAry[5]:= URS5;  UserStatAry[5]:=UST5;
  End; { If SetupArray }

  // Set Module User Count Release Codes
  With SyssCompany^.CompOpt Do
    For N := Low(UserDescAry) To High(UserDescAry) Do
      If (Assigned(UserDescAry[N])) then
        SetUCount(N);
End; { InitUCounts }

//-----------------------------------------------------------------------------

// Displays a single user count security line
Procedure TSetModRec.SetUCount(Const UCIDx : Byte);
Var
  Rd,Rm,Ry   :  Word;
Begin { SetUCount }
  If (UcIdx In [Low(UserDescAry)..High(UserDescAry)]) Then
    With SyssCompany^.CompOpt.OptSecurity[UCIdx] Do Begin
      UserSSymbAry[UCIDx].Text := rcSecurity;
      UserRSymbAry[UCIDx].Text := '';

      If (UcIdx In uc30DaySet) Then Begin
        // Check 30-Day Expiry Date
        If Not CheckUCountExpiry (UCIdx, False) Then
          // AOK
          UserStatAry[UCIDx].Text := IntToStr(rcUserCount)
        Else
          // Expired
          UserStatAry[UCIDx].Text := 'Expired';
      End { If (UcIdx In uc30DaySet) }
      Else
        // Full User Count
        UserStatAry[UCIDx].Text := IntToStr(rcUserCount);
    End; { With ModuleRel }
End; { SetUCount }

//-----------------------------------------------------------------------------

Procedure TSetModRec.Generate_Lic(GetRec  :  Boolean);

Var
  n      :  Byte;
  GotOk,
  RecChanged,
  Locked :  Boolean;


Begin
  Locked:=BOn;
  RecChanged:=BOff;

  If (GetRec) then
    GotOk:=GetMultiSys(BOn,Locked,ModRR)
  else
    GotOk:=BOn;

  If GotOk and Locked Then
  Begin
    With SyssMod^.ModuleRel do
    Begin
      For N := Low(DescAry) to High(DescAry) Do
      Begin
        If (ModuleSec[n,BOff]='') then
        Begin
          Delay(100,BOn);
          // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
          //ModuleSec[n,BOff]:=Get_ModuleSecurity(n,BOn);
          ModuleSec[n,BOff] := Generate_ESN_BaseSecurity (TmpSysESN, N, 0, 0);
          RecChanged:=BOn;
        end;
      End; // For N

      If (RecChanged) and (GetRec) then
      Begin
        {* Update duplicate record *}
        TrackSecUpdates(BOn);
      end;

      If (GetRec) then
        PutMultiSys(ModRR,BOn);
    End; // With SyssMod^.ModuleRel
  End; // If GotOk and Locked
end;


procedure TSetModRec.FormCreate(Sender: TObject);
Var
  LicRec : EntLicenceRecType;
Begin
  ClientHeight := 480;
  ClientWidth := 487;

  Constraints.MinWidth := Width;
  Constraints.MaxWidth := Width;
  Constraints.MinHeight := 200;

  BeenStored:=BOff;

  // Configure Scroll-Box Scroll Bar - doesn't work if you set them at Design-Time!
  With ScrollBox1.VertScrollBar Do
  Begin
    Position := 0;
    Tracking := True;
  End; { With ScrollBox1.VertScrollBar }

  {$IFNDEF EN561}
  // Hide the Full Stock Control release code until v5.61
  Label842.Visible := False;
  Cdesc18.Visible := False;
  CSS18.Visible := False;
  RS18.Visible := False;
  ST18.Visible := False;
  {$ENDIF}

  {MDI_SetFormCoord(TForm(Self));}

  // HM 24/01/02: Extended to only show Plug-Ins for Third-Party Security Password
  tabshModules.TabVisible := (ModuleMode = mmAll);
  tabshUsers.TabVisible := (ModuleMode = mmAll);
  tabshPlugIn.TabVisible := (ModuleMode In [mmAll, mmPlugIns]);

  If ReadEntLic (EntLicFName, LicRec) Then Begin
    lblESN.Caption := licESN7Str (LicRec.licISN, LicRec.licLicType);
    TmpSysESN := ISNArrayType(LicRec.licISN);
  End; { If ReadEntLic }

  Generate_Lic(BOn);


  OutEq;
  InitUCounts;

  // NOTE: Uses TmpSysESN set above
  LoadPlugIns;
end;


{ == Procedure to Send Message to Get Record == }

Procedure TSetModRec.Send_UpdateList(Mode   :  Integer);
(*
Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;
*)
Begin
  (*
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_FormCloseMsg;
    WParam:=Mode;
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);
  *)
end; {Proc..}


procedure TSetModRec.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  {Send_UpdateList(54);}
end;

procedure TSetModRec.FormClose(Sender: TObject; var Action: TCloseAction);
Var
  LStatus  :  Integer;
begin

  Action:=caFree;

  (*
  If (Not BeenStored) then
  Begin
    LStatus:=UnlockMultiSing(F[SysF],SysF,SysAddr[ModRR]);
  end;
  *)
end;


{ ======== Function to Return line no currently on ========= }


Function TSetModRec.ThisLine(Const Sender  :  TObject;
                             Const TMode   :  Byte)  :  Integer;

Var
  n  :  Integer;

  FoundOk
     :  Boolean;

Begin
  FoundOk:=BOff;

  For n:= Low(DescAry) To High(DescAry) Do
  Begin
    Case TMode of
      0  :  FoundOk:=(Sender=RSymbAry[n]);
    end;

    If FoundOk then
      Break;
  End; // For N

  If (FoundOk) then
    Result:=n
  else
    Result:=-1;
end;



procedure TSetModRec.SetSyssStore(EnabFlag,
                                   VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  OkCP1Btn.Enabled:=Not VOMode;

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is Text8Pt) then
    Begin
      If ((Text8Pt(Components[Loop]).Tag Div 1000)=1) then
        Text8Pt(Components[Loop]).ReadOnly:= VOMode;
    end
      else
        If (Components[Loop] is TEditDate) then
        Begin
          If (TEditDate(Components[Loop]).Tag=1) then
            TEditDate(Components[Loop]).ReadOnly:= VOMode;
        end
        else
          If (Components[Loop] is TEditPeriod) then
          Begin
            If (TEditPeriod(Components[Loop]).Tag=1) then
              TEditPeriod(Components[Loop]).ReadOnly:= VOMode;
          end
          else
            If (Components[Loop] is TCurrencyEdit) then
            Begin
              If (TCurrencyEdit(Components[Loop]).Tag=1) then
                TCurrencyEdit(Components[Loop]).ReadOnly:= VOMode;
            end
            else
              If (Components[Loop] is TBorCheck) then
              Begin
                If (TBorCheck(Components[Loop]).Tag=1) then
                  TBorCheck(Components[Loop]).Enabled:= Not VOMode;
              end
              else
                If (Components[Loop] is TSBSComboBox) then
                Begin
                  If (TSBSComboBox(Components[Loop]).Tag=1) then
                    TSBSComboBox(Components[Loop]).ReadOnly:= VOMode;
              end;
  end; {Loop..}

end;



procedure TSetModRec.ProcessSyss;

Var
  Locked  :  Boolean;

Begin
  Locked:=BOn;

  If (GetMultiSys(BOff,Locked,ModRR)) and (Locked) then
    SetSyssStore(BOn,BOff);
end;




procedure TSetModRec.StoreSyss;

Var
  n  :  Integer;

Begin
  // Copy module release codes from the form back into MODRR
  With SyssMod^ Do
    For n := Low(DescAry) to High(DescAry) do
      If Assigned(DescAry[n]) then
        With ModuleRel do Begin
          ModuleSec[n,BOff]:=SSymbAry[n].Text;
          ModuleSec[n,BOn]:=RSymbAry[n].Text;
        End; { With ModuleRel }

  // Copy User release codes from the form
  With SyssCompany^.CompOpt Do
    For n:=Low(UserDescAry) To High(UserDescAry) do
      If Assigned(UserDescAry[n]) then
        With OptSecurity[N] do Begin
          rcSecurity := UserSSymbAry[n].Text;
          //rcRelease  := UserRSymbAry[n].Text;
        End; { With OptSecurity[N]  }
end;


procedure TSetModRec.OkCP1BtnClick(Sender: TObject);
Var
  LicRec  : EntLicenceRecType;
  I       : SmallInt;
  Res     : Integer;
begin
  If (Sender is TButton) then
    With (Sender as TButton) do Begin
      If (ModalResult=mrOk) or (Sender=OKCp1Btn) then
        // OK - update SysMod and SyssCompany from form
        StoreSyss
      Else
        If (OKCp1Btn.Enabled) then Begin
          // cancel - reread original module licence dets
          GlobLocked:=BOn;

          GetMultiSys(BOff,GlobLocked,ModRR); {* Restore values *}

          // Load and lock the MCM Company Options record
          LoadnLockCompanyOpt;
        end;

      If (OkCP1Btn.Enabled) then begin
        // Update MODRR
        PutMultiSys(ModRR,BOn);

        {* Update duplicate record *}
        TrackSecUpdates(BOn);

        // Update SysCompany
        PutCompanyOpt(True);

        // MH 10/01/2017 2017R1 ABSEXCH-17996: Added support for Information Table
        If SQLUtils.UsingSQL Then
        Begin
          // Update the Information Table from the Global SyssMod^ record that could have been changed above
          InformationTableFuncs.CheckModuleReleaseCodes (True);
        End; // If SQLUtils.UsingSQL

        // Update Enterprise Licence file
        If ReadEntLic (EntLicFName, LicRec) Then Begin
          With LicRec, SyssCompany^.CompOpt Do Begin
            licUserCounts [ucCompanies] := OptSecurity[ucCompanies].rcUserCount;       { Company Count for MCM }
            licUserCounts [ucToolkit30] := OptSecurity[ucToolkit30].rcUserCount;       { Toolkit DLL - 30-day User Count }
            licUserCounts [ucToolkitFull] := OptSecurity[ucToolkitFull].rcUserCount;   { Toolkit DLL - Full User Count }
            licUserCounts [ucTradeCounter] := OptSecurity[ucTradeCounter].rcUserCount; { Trade Counter User Count }
            licUserCounts [ucElerts] := OptSecurity[ucElerts].rcUserCount;             { Available Elerts }
          End; { With LicRec, SyssCompany^.CompOpt }

          WriteEntLic (EntLicFName, LicRec);

          // MH 10/01/2017 2017R1 ABSEXCH-17996: Added support for Information Table
          If SQLUtils.UsingSQL Then
          Begin
            // Update the Information Table from the Exchequer Licence File
            InformationTableFuncs.CheckLicenceOnlyComponents (LicRec, True);
          End; // If SQLUtils.UsingSQL
        End; { If ReadEntLic }

        // Save any Plug-In Security changes (if there aare any Plug-In's)
        If (Length(FrameAry) > 0) Then
          For I := 0 To Pred(Length(FrameAry)) Do
            // Security Changed save details for this Plug-In
            If FrameAry[I].Changed Then
              FrameAry[I].SaveChanges;

        BeenStored:=BOn;
      End; { If }

      // HM: Not necessary as buttons have ModalResult set
      //Close;
    end; {With..}
end;



procedure TSetModRec.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TSetModRec.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;



procedure TSetModRec.ShutDown;

Begin
  PostMessage(Self.Handle,WM_Close,0,0);
end;




procedure TSetModRec.RS1Exit(Sender: TObject);
Var
  RMode,
  Idx     :  Byte;
begin
  Idx:=ThisLine(Sender,0);

  If (Idx In [1..NoModules]) then
    With SyssMod^.ModuleRel do
      ModuleSec[Idx,BOn]:=RSymbAry[Idx].Text;

  RMode:=ModRelMode(Idx);

  If ((RMode=2) and (Check_RelDateExp(Idx,BOff))) or  (RMode=1) then
  Begin
    Set_RelDate(Idx,(RMode<>1),BOff);

  end;

  If (Idx = 12) Or (Idx = 13) Then Begin
    // Std WOP / Prof WOP
    If (Not Check_RelDateExp(Idx,BOff)) Or (RMode = 1) Then Begin
      // Release Code set - blank out other release code
      If (Idx = 12) Then Begin
        // Std set - remove Pro
        SyssMod^.ModuleRel.ModuleSec[13,BOn] := '';
        SyssMod^.ModuleRel.RelDates[13] := 0;
      End { If (Idx = 12) }
      Else Begin
        // Pro set - remove Std
        SyssMod^.ModuleRel.ModuleSec[12,BOn] := '';
        SyssMod^.ModuleRel.RelDates[12] := 0;
      End; { Else }
    End; { If (Not Check_RelDateExp(Idx,BOff)) Or (RMode = 1) }
  End; { If (Idx = 12) Or (Idx = 13) }

  If (Sender is Text8pt) then
    If Text8Pt(Sender).Modified then
      OutEq;
end;


procedure TSetModRec.RBtn1Click(Sender: TObject);
Var
  N         : Integer;
  CurSecy   : LongInt;
Begin
  If (PageControl1.ActivePage = tabshModules) Then Begin
    // Enterprise Module Security
    With SyssMod^ Do
      For N := 1 to NoModules do
        With ModuleRel do
          If (ModRelMode(n) = 0) then Begin
            ModuleSec[n,BOff] := '';
            ModuleSec[n,BOn] := '';
          end; {Loop..}

    // Set default rel codes
    Generate_Lic(BOff);

    // Update screen
    OutEq;
  End { If (PageControl1.ActivePage = tabshModules) }
  Else
    If (PageControl1.ActivePage = tabshUsers) Then Begin
      // User Count Security - Always generate new codes as matching release code not stored
      For N := Low(UserDescAry) To High(UserDescAry) Do
        If Assigned(UserDescAry[N]) Then
          With SyssCompany^.CompOpt.OptSecurity[N] Do Begin
            // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
            Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
            //CurSecy := Set_Security;
            //rcSecurity := Calc_SecStr(CurSecy, False);
            rcSecurity := Generate_ESN_BaseSecurity (TmpSysESN, CalcUserModuleNo (N), 0, 1);
          End; { With SyssCompany^... }

      InitUCounts (False);
    End { If (PageControl1.ActivePage = tabshUsers) }
    Else
      If (PageControl1.ActivePage = tabshPlugIn) Then Begin
        // Plug-In Security
        If (Length(FrameAry) > 0) Then
          For N := 0 To Pred(Length(FrameAry)) Do
            // Security Changed save details for this Plug-In
            FrameAry[N].ResetSecurityCode;
      End; { If (PageControl1.ActivePage = tabshUsers) }
end;

procedure TSetModRec.DispPhoneticSecCode(Sender: TObject);
Var
  ModDesc : ShortString;
  ModNo   : LongInt;
begin
  If Sender Is Text8pt Then
    With Sender As Text8Pt Do Begin
      ModNo := (Tag Mod 1000);

      // Determine Module Desc
      If (ModNo > 100) Then
        ModDesc := UserDescAry[ModNo - 100].Text + ' count'
      Else
        ModDesc := DescAry[ModNo].Text + ' module';

      // Display Msg with phonetic version of Security Code
      MessageDlg('The phonetic Security Code for the ' + ModDesc + ' is ' +
                 QuotedStr(StringToPhonetic (Text)),
                 mtInformation, [mbOK], 0);
    End; { With Sender As Text8Pt }
end;

procedure TSetModRec.DispPhoneticRelCode(Sender: TObject);
Var
  ModDesc : ShortString;
  ModNo   : LongInt;
begin
  If Sender Is Text8pt Then
    With Sender As Text8Pt Do Begin
      ModNo := (Tag Mod 1000);

      // Determine Module Desc
      If (ModNo > 100) Then
        ModDesc := UserDescAry[ModNo - 100].Text + ' count'
      Else
        ModDesc := DescAry[ModNo].Text + ' module';

      // Display Msg with phonetic version of Release Code
      MessageDlg('The phonetic Release Code for the ' + ModDesc + ' is ' +
                 QuotedStr(StringToPhonetic (Text)),
                 mtInformation, [mbOK], 0);
    End; { With Sender As Text8Pt }
end;

// Calculates the Security Module No - 30-Day User counts have a 1000 offset
function TSetModRec.CalcUserModuleNo (Const ModNo : SmallInt) : SmallInt;
Begin
  Case ModNo Of
    ucCompanies    : Result := 253;
    ucToolkit30    : Result := 1004;
    ucToolkitFull  : Result := 4;
    ucTradeCounter : Result := 11;
    ucElerts       : Result := 14;
  Else
    Raise Exception.Create ('SetModU.CalcUserModuleNo - Invalid Module Number ' + IntToStr(ModNo));
  End; { Case ModNo }
End;

procedure TSetModRec.URS1Exit(Sender: TObject);
Var
  RMode, Idx  : Byte;
  UC          : SmallInt;
  CurSecy     : LongInt;
begin
  With Sender As Text8Pt Do
    Idx := Tag Mod 100;

  If (Idx In [Low(UserDescAry)..High(UserDescAry)]) then
    If (Trim(UserRSymbAry[Idx].Text) <> '') Then
      With SyssCompany^.CompOpt.OptSecurity[Idx] Do Begin
        // Validate Security Code
        UC := DeCode_Usrs(rcSecurity,Trim(UserRSymbAry[Idx].Text));

        If (UC > 0) Then Begin
          // Valid Release Code entered - generate new code and record details
          // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
          Delay (100, BOn);    // Delay to allow system clock to change to force diff relcodes
          //CurSecy := Set_Security;
          //rcSecurity := Calc_SecStr(CurSecy, False);
          rcSecurity := Generate_ESN_BaseSecurity (TmpSysESN, CalcUserModuleNo (Idx), 0, 1);
          rcUserCount := UC;

          If (Idx In uc30DaySet) Then
            // Set 30-Day expiry
            rcExpiry := CalcNewRelDate (30);

          // update screen with new details
          SetUCount(Idx);
        End { If (UC > 0) }
        Else
          UserStatAry[Idx].Text := '';
      End; { With }
end;

procedure TSetModRec.LoadPlugIns;
Var
  KeyS : Str255;
  LStatus : SmallInt;
  PlugInCount : SmallInt;
  NextTop     : LongInt;
begin
  PlugInCount := 0;
  NextTop := 1;

  KeyS := cmPlugInSecurity;
  LStatus := Find_Rec(B_GetGEq, F[CompF], CompF, RecPtr[CompF]^, CompPathK, KeyS);
  While (LStatus = 0) And (Company^.RecPFix = cmPlugInSecurity) Do Begin
    With Company^.PlugInSec Do Begin
      Inc (PlugInCount);

      // Create a Frame for the Plug-In Security stuff
      SetLength (FrameAry, PlugInCount);
      FrameAry[Pred(PlugInCount)] := TPlugInSecFrame.Create (Self);
      With FrameAry[Pred(PlugInCount)] Do Begin
        Name := Name + IntToStr(PlugInCount);
        Parent := scrlPlugIns;
        Top := NextTop;
        Left := 1;

        SysESN := TmpSysESN;
        SetDets (Company^.PlugInSec, True);
        SetTags (PlugInCount);

        // Update position for next frame
        NextTop := NextTop + Height;
      End; { With FrameAry[Pred(PlugInCount)] }
    End; { With Company^.PlugInSec }


    LStatus := Find_Rec(B_GetNext, F[CompF], CompF, RecPtr[CompF]^, CompPathK, KeyS);
  End; { While }
end;

procedure TSetModRec.lblESNDblClick(Sender: TObject);
begin
  Clipboard.AsText := lblESN.Caption;
end;

procedure TSetModRec.FormResize(Sender: TObject);
begin
  // Anchors don't work for this form under Vista - so manually resize
  PageControl1.Width := ClientWidth - (2 * PageControl1.Left);
  PageControl1.Height := ClientHeight - PageControl1.Top - PageControl1.Left;



end;

end.

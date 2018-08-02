unit MainFrmU;

{ markd6 17:09 06/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, TEditVal, Mask, ExtCtrls, SBSPanel,
  GlobVar;


type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    Button2: TButton;
    SBSPanel1: TSBSPanel;
    TabSheet1: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    meESN1: TMaskEdit;
    TabSheet2: TTabSheet;
    CBEntVer: TSBSComboBox;
    Label1: TLabel;
    Label3: TLabel;
    ecRelCode: Text8Pt;
    Label6: TLabel;
    ecSecCode: Text8Pt;
    Label7: TLabel;
    ecDailyPW: Text8Pt;
    Label81: Label8;
    CBRelType: TSBSComboBox;
    Label2: TLabel;
    Label8: TLabel;
    ecSecCode2: Text8Pt;
    Label9: TLabel;
    ecRelCode2: Text8Pt;
    Label10: TLabel;
    Button1: TButton;
    evNoUsers: TCurrencyEdit;
    TabSheet3: TTabSheet;
    Label11: TLabel;
    ecSecCode3: Text8Pt;
    ecRelCode3: Text8Pt;
    Label12: TLabel;
    CBModNo: TSBSComboBox;
    Label13: TLabel;
    TabSheet4: TTabSheet;
    Label14: TLabel;
    evNoUsers2: TCurrencyEdit;
    ecSecCode4: Text8Pt;
    Label15: TLabel;
    Label16: TLabel;
    ecRelCode4: Text8Pt;
    Label17: TLabel;
    CBModNo2: TSBSComboBox;
    TabSheet5: TTabSheet;
    Label83: Label8;
    TabSheet6: TTabSheet;
    Label18: TLabel;
    ecSecCode5: Text8Pt;
    ecRelCode5: Text8Pt;
    Label19: TLabel;
    Label20: TLabel;
    evPISNo: TCurrencyEdit;
    TabSheet7: TTabSheet;
    Label21: TLabel;
    evNoUsers3: TCurrencyEdit;
    ecSecCode6: Text8Pt;
    Label22: TLabel;
    Label23: TLabel;
    ecRelCode6: Text8Pt;
    Label84: Label8;
    Label85: Label8;
    lblInstVer: TLabel;
    Label24: TLabel;
    ecPlugInPW: Text8Pt;
    TabShSecPw: TTabSheet;
    GroupBox1: TGroupBox;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    edtResyncComps: Text8Pt;
    edtResetUser: Text8Pt;
    edtResetPlugInUser: Text8Pt;
    Label29: TLabel;
    edtResyncComps009: Text8Pt;
    Label30: TLabel;
    edtResyncComps011: Text8Pt;
    lblv5PwordExpiry: TLabel;
    lstTrustees: TListBox;
    Label31: TLabel;
    ecDailyPW2: Text8Pt;
    lstReception: TListBox;
    TabShVectron: TTabSheet;
    Label32: TLabel;
    ecSecCode8: Text8Pt;
    Label33: TLabel;
    ecRelCode8: Text8Pt;
    lstPlugInCrew: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure meESN1Exit(Sender: TObject);
    procedure CBEntVerExit(Sender: TObject);
    procedure CBRelTypeExit(Sender: TObject);
    procedure ecSecCodeExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ecSecCode2Exit(Sender: TObject);
    procedure evNoUsersExit(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CBModNoChange(Sender: TObject);
    procedure ecSecCode3Exit(Sender: TObject);
    procedure evNoUsers2Exit(Sender: TObject);
    procedure CBModNo2Change(Sender: TObject);
    procedure ecSecCode4Exit(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure evPISNoExit(Sender: TObject);
    procedure ecSecCode5Exit(Sender: TObject);
    procedure evNoUsers3Exit(Sender: TObject);
    procedure ecSecCode6Exit(Sender: TObject);
    procedure PhoneticSecCode(Sender: TObject);
    procedure PhoneticPword(Sender: TObject);
    procedure PhoneticSecPwords(Sender: TObject);
    procedure ecSecCode8Exit(Sender: TObject);
  private
    { Private declarations }
    TodayPW,
    MCMDPW,
    PlugInPW,
    VectronDP,
    TPWLasts  :  Str20;

    Function Check_CheckSum(SecNo   :  Str20;
                            ChkSum,
                            ModuleNo,
                            RevOR   :  SmallInt)  :  Boolean;

    Function Calc_CheckSum(PModuleNo,
                           PIChkSum  :  SmallInt)  :  SmallInt;

    procedure OutMainPage;

    procedure OutPage2;

    procedure OutPage3;

    procedure OutPage4;

    procedure OutPage5;

    procedure OutPage6;

    procedure OutAllPages;

    procedure OutSecPage;

    procedure OutPage8;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  VarRec2U,
  LicRec,
  LicFuncU,
  ETStrU,
  ETMiscU,
  ETDateU,
  ESNImpU,
  Phonetic,
  RSyncU,
  SecVarU,
  SecSup2U,
  SecUtilU,
  ShellAPI,
  APIUtil;

{$R *.DFM}


Const
  MCMPage   =  4;
  PIMPage   =  5;
  PIUCPage  =  6;
  SecPage   =  7;
  cbv5      =  3;
  VecPage   =  8;


(* 
// Mock function to allow it to be tested under other User Id's
Function WinGetUserName : ShortString;
Begin // WinGetUserName
  //Result := 'NFREWER440';
  Result := 'PRIYANKA.PATEL';
End; // WinGetUserName
(* *)

//-------------------------------------------------------------------------

procedure TForm1.FormCreate(Sender: TObject);
begin
  If (RunValidLocation) then
  Begin
    Caption := Application.Title + ' (' + SRVerNo + ')';

    // HM 06/02/02: Have to set format at runtime as control resets to default
    //              on creation
    evPISNo.DisplayFormat := '0';

    PageControl1.ActivePage:=TabSheet1;
    PageControl1Change(PageControl1);

    // HM 16/05/02: Modified to make Reset Ent User count code available to all staff
    //TabShSecPw.TabVisible := (lstTrustees.Items.IndexOf(UpperCase(Trim(WinGetUserName))) > -1);

    ecDailyPW2.Visible := TabShSecPw.TabVisible And (Uppercase(Copy(Trim(WinGetUserName), 1, 3)) = 'EAL');
    Label31.Visible := ecDailyPW2.Visible;

    If (lstReception.Items.IndexOf(UpperCase(Trim(WinGetUserName))) > -1) Then Begin
      // Reception
      TabSheet1.TabVisible := False;          // Ent System
      TabSheet2.TabVisible := False;          // Ent User Count
      TabSheet3.TabVisible := False;          // Ent Modules System
      TabSheet4.TabVisible := False;          // ent Module User Count
      TabSheet6.TabVisible := False;          // Plug-In System
      TabSheet7.TabVisible := False;          // Plug-In User Count
    End; { If }

    // HM 16/05/02: Modified to make Reset Ent User count code available to all staff, but only that code
    If (lstTrustees.Items.IndexOf(UpperCase(Trim(WinGetUserName))) = -1) Then Begin
      // Security
      TabShSecPw.TabVisible := True;
      edtResyncComps.Visible := False;
      edtResyncComps009.Visible := False;
      edtResyncComps011.Visible := False;
      edtResetPlugInUser.Visible := False;
      Label29.Visible := False;
      Label30.Visible := False;
    End; { If }

    // MH 22/07/2009: Extended to allow plug-in people access to plug-in pages
    If (lstPlugInCrew.Items.IndexOf(UpperCase(Trim(WinGetUserName))) > -1) Then
    Begin
      // Plug-In Crew
      TabSheet1.TabVisible := False;          // Ent System
      TabSheet2.TabVisible := False;          // Ent User Count
      TabSheet3.TabVisible := False;          // Ent Modules System
      TabSheet4.TabVisible := False;          // ent Module User Count
      TabShSecPw.TabVisible := False;         // Security Passwords
      TabShVectron.TabVisible := False;       // Vectron
    End; // If (lstPlugInCrew.Items.IndexOf(UpperCase(Trim(WinGetUserName))) > -1)

    TodayPW:=Generate_ESN_BaseSecurity(SecRelLic.ESN,251,0,0);
    MCMDPW:=Generate_ESN_BaseSecurity(SecRelLic.ESN,245,0,0);
    PlugInPW:=Generate_ESN_BaseSecurity(SecRelLic.ESN,248,0,0);
    VectronDP:=Generate_ESN_BaseSecurity(SecRelLic.ESN,243,0,0);
    
    TPWLasts:=Calc_TodaySecurityLasts;

    CBEntVerExit(nil); {Establish version straight away}
    CBRelTypeExit(nil);{Establish type straight away}
    CBModNoChange(nil);
    CBModNo2Change(nil);

    OutMainPage;
  End
  Else
  Begin
  //  ShowMessage('This system is not authorised to run. Contact IRIS Enterprise Software for more details');
    //ShellExecute (0, 'open', 'https://www.exchequer-secure.com/wrscripts/webrel.dll/webrel', '', '', SW_SHOWMAXIMIZED);
    //ShellExecute (0, 'open', 'http://10.1.1.2/wrscripts/webrel.dll/webrel', '', '', SW_SHOWMAXIMIZED);
    ShellExecute (0, 'open', 'http://webrel/wrscripts/webrel.dll/webrel', '', '', SW_SHOWMAXIMIZED);
    PostMessage(Self.Handle,WM_Close,0,0);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Button1Click(Nil);

  SendMessage(Self.Handle,WM_Close,0,0);

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ecRelCode2.Text:='';
  ecRelCode.Text:='';
  ecRelCode3.Text:='';
  ecRelCode4.Text:='';
  ecRelCode5.Text:='';
  ecRelCode8.Text:='';
end;


procedure TForm1.PageControl1Change(Sender: TObject);
Var
  I : Byte;
begin
  OutMainPage;

  {$IFDEF EN561}
  // HM 23/08/04: Added support for 12 Month Enterprise system release codes
  With CBRelType, Items Do
  Begin
    Clear;
    AddObject ('30 Days', Pointer(LongInt(rct30Day)));
    If (PageControl1.ActivePage = TabSheet1) Then
    Begin
      AddObject ('1 Year', Pointer(LongInt(rct1Year)));
    End; // If (PageControl1.ActivePage = TabSheet1)
    AddObject ('Full', Pointer(LongInt(rctFullCode)));

    For I := 0 To Pred(Count) Do
    Begin
      If (LongInt(Objects[I]) = Ord (SecRelLic.Ent30Day)) Then
      Begin
        ItemIndex := I;
        Break;
      End; // SecRelLic.Ent30Day
    End; // For I

    If (ItemIndex = -1) Then ItemIndex := 0;

    CBRelTypeExit(CBRelType);
  End; // With CBRelType.Items
  {$ENDIF}
end;

procedure TForm1.meESN1Exit(Sender: TObject);

Var
  LicESN   :  ESNByteArrayType;
  DemoFlag : Byte;
begin
  If ProcessESN7Str(LicESN,DemoFlag,meESN1) Then Begin
    SecRelLic.ESN:=ISNArrayType(LicESN);

    // Validate the DemoFlag byte
    If licDecodeDemoFlag (licESN, DemoFlag) Then
      lblInstVer.Caption := '(' + licLicTypeToStr (DemoFlag, True) + ')'
    Else Begin
      // Byte7 is invalid
      lblInstVer.Caption := 'INVALID';
      SysUtils.Beep;
    End; { Else }

    OutSecPage;
  End; { If ProcessESN7Str (... }
end;

procedure TForm1.CBEntVerExit(Sender: TObject);
begin
  SecRelLic.EntVer:=Strip('A',['A'..'Z',#32],UpCaseStr(CBEntVer.Text));

  OutAllPages;
end;

procedure TForm1.CBRelTypeExit(Sender: TObject);
begin
  // HM 23/08/04: Added support for 12 Month Enterprise system release codes
  {$IFDEF EN561}
  If (CBRelType.ItemIndex >= 0) Then
    SecRelLic.Ent30Day:=RelCodeType(LongInt(CBRelType.Items.Objects[CBRelType.ItemIndex]))
  Else
    SecRelLic.Ent30Day:=rct30Day;
  {$ELSE}
  SecRelLic.Ent30Day:=(CBRelType.ItemIndex<>1);
  {$ENDIF}

  CBModNo2Change(Nil);
  
  OutAllPages;

end;

Function TForm1.Check_CheckSum(SecNo   :  Str20;
                               ChkSum,
                               ModuleNo,
                               RevOR   :  SmallInt)  :  Boolean;

Var
  ModuleRelMode
         :  Boolean;

  CSLen  :  Byte;
  CS     :  Integer;

  Secy   :  LongInt;
  CSStr,
  SecyStr:  Str20;

  GenStr :  Str255;


Begin

  CS:=ChkSum;
  CSStr:=Form_Int(CS,0);

  CSLen:=Length(CSStr);

  ModuleRelMode:=(((ModuleNo>=1) and (ModuleNo<=99)) or ((ModuleNo>=1001) and (ModuleNo<=1099))) and (RevOR=0);

  Secy:=Calc_Security(SecNo,ModuleRelMode);

  SecyStr:=Form_Int(Secy,0);

  Result:=(CS=IntStr(Copy(SecyStr,Length(SecyStr)-Pred(CSLen),CSLen))) or (CS=0);

  If (Not Result)  then
  Begin
    If (ModuleRelMode) then
      GenStr:='The ESN, Security Code or module do not match.'
    else
      GenStr:='The ESN and Security Code do not match.';

    ShowMessage(GenStr);
  end;

end;


Function TForm1.Calc_CheckSum(PModuleNo,
                              PIChkSum  :  SmallInt)  :  SmallInt;

Var
  CSESN  :  ISNArrayType;

Begin
  With SecRelLic do
  Begin
    FillChar(CSESN,Sizeof(CSESN),0);

    {On older versions, if module release leave ESN out of calculation}

    If (((PModuleNo>=1) and (PModuleNo<=99)) or (PModuleNo=254)) and  (EntVer<ExNewVer) then
      FillChar(CSESN,Sizeof(CSESN),0)
    else
      CSESN:=ESN;

    Result:=Calc_ESN_CheckSum(CSESN,PModuleNo,PIChkSum);

  end; {With..}
end;


procedure TForm1.ecSecCodeExit(Sender: TObject);
begin
  If (Check_CheckSum(ecSecCode.Text,Calc_CheckSum(0,0),0,0)) then
  Begin
    SecRelLic.EntSecCode:=ecSecCode.Text;
  end
  else
    SecRelLic.EntSecCode:='';

  OutMainPage;
end;

procedure TForm1.OutMainPage;

Var
  RelCode  :  LongInt;
Begin
  With SecRelLic do
  Begin
    // MH 22/07.2009: Modified so that Plug-In Crew can see Daily Password on Plug-In Tabs
    If (PageControl1.ActivePage.PageIndex<>MCMPage) and (PageControl1.ActivePage.PageIndex<>VecPage) And
       (TabSheet1.TabVisible Or (lstPlugInCrew.Items.IndexOf(UpperCase(Trim(WinGetUserName))) > -1)) then
    Begin
      ecDailyPW.Text:=TodayPW;
      Label7.Caption:='Daily PW';
    end
    else
    If (PageControl1.ActivePage.PageIndex<>VecPage) then
    Begin
      ecDailyPW.Text:=MCMDPW;
      Label7.Caption:='MCM PW';
      ecPlugInPW.Text:=PlugInPW;
    end
    else
      Begin
        ecDailyPW.Text:=VectronDP;
        Label7.Caption:='Vec Daily';
      end;

    evPISNo.Visible:=(PageControl1.ActivePage.PageIndex>=PIMPage) And (PageControl1.ActivePage.PageIndex<SecPage);
    Label20.Visible:=evPISNo.Visible;


    cbRelType.Visible:=(PageControl1.ActivePage.PageIndex<>PIUCPage) And (PageControl1.ActivePage.PageIndex<>SecPage);
    Label2.Visible:=cbRelType.Visible;

    CBEntVer.Visible:=(PageControl1.ActivePage.PageIndex<>VecPage);
    Label1.Visible:=CBEntVer.Visible;


    Label81.Caption:='Expires '+POutDate(TPWLasts);

    RelCode:=Calc_Security(EntSecCode,BOff);

    If (EntVer='') then {Always assume latest if all else fails}
      EntVer:=ExNewVer;

    If (RelCode<>0) then
    Begin
      ecRelCode.Text:=Generate_ESN_BaseRelease(EntSecCode,0,0,Ord(Ent30Day),EntVer);

    end
    else
      ecRelCode.Text:='';


  end;


end;



procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TForm1.ecSecCode2Exit(Sender: TObject);
Var
  ModMode  :  SmallInt;
begin
  ModMode:=254-(7*Ord(SecRelLic.Ent30Day));

  If (Check_CheckSum(ecSecCode2.Text,Calc_CheckSum(ModMode,0),ModMode,0)) then
  Begin
    SecRelLic.EntUsrCode:=ecSecCode2.Text;
  end
  else
    SecRelLic.EntUsrCode:='';

  OutPage2;

end;

procedure TForm1.evNoUsersExit(Sender: TObject);
begin
  SecRelLic.UserCount:=Round(evNoUsers.Value);
  If (SecRelLic.UserCount < 0) Then Begin
    SecRelLic.UserCount := Abs(SecRelLic.UserCount);
    evNoUsers.Value := SecRelLic.UserCount;
  End; { If }

  OutPage2;
end;


procedure TForm1.OutPage2;

Var
  RelCode  :  LongInt;
Begin
  With SecRelLic do
  Begin

    RelCode:=Calc_Security(EntUsrCode,BOff);

    If (EntVer='') then {Always assume latest if all else fails}
      EntVer:=ExNewVer;

    If (RelCode<>0) then
    Begin
      ecRelCode2.Text:=Gen_UsrRelCode(EntUsrCode,UserCount);
      Label85.Caption:='Users : '+Form_Int(DeCode_Usrs(EntUsrCode,ecRelCode2.Text),0);
    end
    else
    Begin
      ecRelCode2.Text:='';
      Label85.Caption:='';
    end;


  end;
end;



procedure TForm1.CBModNoChange(Sender: TObject);
begin
  SecRelLic.ModuleNo:=Succ(CBModNo.ItemIndex);

  OutPage3;
end;



procedure TForm1.ecSecCode3Exit(Sender: TObject);

Var
  Mode  :  Integer;
begin

  If (Check_CheckSum(ecSecCode3.Text,Calc_CheckSum(SecRelLic.ModuleNo,0),SecRelLic.ModuleNo,0)) then
  Begin
    SecRelLic.EntModCode:=ecSecCode3.Text;
  end
  else
    SecRelLic.EntModCode:='';

  OutPage3;

end;


procedure TForm1.OutPage3;

Var
  RelCode  :  LongInt;
Begin
  With SecRelLic do
  Begin

    RelCode:=Calc_Security(EntModCode,BOn);

    If (EntVer='') then {Always assume latest if all else fails}
      EntVer:=ExNewVer;

    If (RelCode<>0) then
    Begin
      ecRelCode3.Text:=Generate_ESN_BaseRelease(EntModCode,ModuleNo,0,Ord(Ent30Day),EntVer);

    end
    else
      ecRelCode3.Text:='';

  end;
end;


procedure TForm1.evNoUsers2Exit(Sender: TObject);
begin
  SecRelLic.ModUserCount:=Round(evNoUsers2.Value);
  If (SecRelLic.ModUserCount < 0) Then Begin
    SecRelLic.ModUserCount := Abs(SecRelLic.ModUserCount);
    evNoUsers2.Value := SecRelLic.ModUserCount;
  End; { If }

  OutPage4;
end;



procedure TForm1.CBModNo2Change(Sender: TObject);
Const
  ComboLU  :  Array[0..3] of Byte = (253,4,11,14);
begin
  SecRelLic.UsrModNo:=ComboLU[CBModNo2.ItemIndex];

  If (SecRelLic.UsrModNo<>4) and (SecRelLic.Ent30Day = rct30Day) then begin
    CBRelType.ItemIndex:=1;

    // HM 05/02/01: Modified to call OnChange method as getting out of sync after auto-change
    CBRelTypeExit(Sender);
  End; { If }

  SecRelLic.UsrModNo:=SecRelLic.UsrModNo+(1000*Ord(SecRelLic.Ent30Day));

  If (Sender<>nil) then
    OutPage4;

end;

procedure TForm1.ecSecCode4Exit(Sender: TObject);
begin

  If (Check_CheckSum(ecSecCode4.Text,Calc_CheckSum(SecRelLic.UsrModNo,0),SecRelLic.UsrModNo,1)) then
  Begin
    SecRelLic.EntModUCode:=ecSecCode4.Text;
  end
  else
    SecRelLic.EntModUCode:='';

  OutPage4;

end;

procedure TForm1.OutPage4;

Var
  RelCode  :  LongInt;
Begin
  With SecRelLic do
  Begin

    RelCode:=Calc_Security(EntModUCode,BOff);


    If (EntVer='') then {Always assume latest if all else fails}
      EntVer:=ExNewVer;

    If (RelCode<>0) then
    Begin
      If (UsrModNo<>4) and (UsrModNo<>1004) and (Ent30Day = rct30Day) then
        ShowMessage('30 Day codes are not currently supported for '+CBModNo2.Text);

      ecRelCode4.Text:=Gen_UsrRelCode(EntModUCode,ModUserCount);

      Label83.Caption:='Users : '+Form_Int(DeCode_Usrs(EntModUCode,ecRelCode4.Text),0);

    end
    else
    Begin
      ecRelCode4.Text:='';
      Label83.Caption:='';
    end;

  end;
end;




procedure TForm1.evPISNoExit(Sender: TObject);


begin
  // HM 06/02/02: Modified as .Value isn't updated properly, meaning that PISerial
  //              was keeping the previous Plug-In Serial number under certain
  //              conditions
  //SecRelLic.PISerial:=PI_CheckSum(Round(evPISNo.Value));
  SecRelLic.PISerial:=PI_CheckSum(StrToInt(Trim(evPISNo.Text)));
end;



procedure TForm1.ecSecCode5Exit(Sender: TObject);
begin
  With SecRelLic do
    If (Check_CheckSum(ecSecCode5.Text,Calc_CheckSum(252,PISerial),252,0)) then
    Begin
      SecRelLic.EntPICode:=ecSecCode5.Text;
    end
    else
      SecRelLic.EntPICode:='';

  OutPage5;
end;

procedure TForm1.OutPage5;

Var
  RelCode  :  LongInt;
Begin
  With SecRelLic do
  Begin

    RelCode:=Calc_Security(EntPICode,BOff);

    // HM 05/02/02: This breaks the system as the internal ver flag is ALWAYS set to v5.00
    //EntVer:=ExNewVer; {Hard code to latest}

    If (EntVer='') then {Always assume latest if all else fails}
      EntVer:=ExNewVer;

    If (RelCode<>0) then
    Begin
      ecRelCode5.Text:=Generate_ESN_BaseRelease(EntPICode,252,PISerial,Ord(Ent30Day),EntVer);

    end
    else
    Begin
      ecRelCode5.Text:='';
    end;

  end;
end;



procedure TForm1.evNoUsers3Exit(Sender: TObject);
begin
  SecRelLic.PIUserCount:=Round(evNoUsers3.Value);
  If (SecRelLic.PIUserCount < 0) Then Begin
    SecRelLic.PIUserCount := Abs(SecRelLic.PIUserCount);
    evNoUsers3.Value := SecRelLic.PIUserCount;
  End; { If }

  OutPage6;
end;


procedure TForm1.ecSecCode6Exit(Sender: TObject);
begin
  With SecRelLic do
    If (Check_CheckSum(ecSecCode6.Text,Calc_CheckSum(250,PISerial),250,0)) then
    Begin
      SecRelLic.EntPIUCode:=ecSecCode6.Text;
    end
    else
      SecRelLic.EntPIUCode:='';

  OutPage6;
end;

procedure TForm1.OutPage6;
Var
  RelCode  :  LongInt;
  
begin
  With SecRelLic do
  Begin

    RelCode:=Calc_Security(EntPIUCode,BOff);


    If (EntVer='') then {Always assume latest if all else fails}
      EntVer:=ExNewVer;

    If (RelCode<>0) then
    Begin

      ecRelCode6.Text:=Gen_UsrRelCode(EntPIUCode,PIUserCount);

      Label84.Caption:='Users : '+Form_Int(DeCode_Usrs(EntPIUCode,ecRelCode6.Text),0);

    end
    else
    Begin
      ecRelCode6.Text:='';
      Label84.Caption:='';
    end;

  end;
end;


procedure TForm1.ecSecCode8Exit(Sender: TObject);
begin
  If (Check_CheckSum(ecSecCode8.Text,Calc_CheckSum(0,0),0,0)) then
  Begin
    SecRelLic.VectronCode:=ecSecCode8.Text;
  end
  else
    SecRelLic.VectronCode:='';

  OutPage8;
end;

procedure TForm1.OutPage8;
Var
  RelCode  :  LongInt;

begin
  With SecRelLic do
  Begin

    RelCode:=Calc_Security(VectronCode,BOff);


    If (EntVer='') then {Always assume latest if all else fails}
      EntVer:=ExNewVer;

    If (RelCode<>0) then
    Begin
      ecRelCode8.Text:=Generate_ESN_BaseRelease(VectronCode,241+Ord(Ent30Day),0,0,EntVer);

    end
    else
      ecRelCode8.Text:='';


  end;

end;



procedure TForm1.OutAllPages;

Begin
  OutMainPage;
  OutPage2;
  OutPage3;
  OutPage4;
  OutPage5;
  OutPage6;
  OutPage8;

  OutSecPage;
end;

//-------------------------------------------------

procedure TForm1.PhoneticSecCode(Sender: TObject);
Var
  CodeType, ModDesc : String[50];
begin
  If Sender Is Text8Pt Then
    With Sender As Text8Pt Do Begin
      // Determine Security/Release Type from Tag
      If (Tag > 100) Then
        CodeType := 'Release'
      Else
        CodeType := 'Security';

      Case (Tag Mod 100) Of
        1 : ModDesc := 'Exchequer System';
        2 : ModDesc := 'Exchequer User Count';
        3 : ModDesc := QuotedStr(CBModNo.Text) + ' Module';
        4 : ModDesc := QuotedStr(CBModNo2.Text) + ' Module User Count';
        5 : ModDesc := 'Plug-In';
        6 : ModDesc := 'Plug-In User Count';
        8 : ModDesc := 'Vectron Card System';
      End; { Case (Tag Mod 100) }

      // Display Msg with phonetic version of Security/Release Code
      MessageDlg('The v' + SecRelLic.EntVer + ' phonetic ' + CodeType + ' Code for the ' + ModDesc + ' is ' +
                 QuotedStr(StringToPhonetic (Text)), mtInformation, [mbOK], 0);
    End; { With Sender As Text8Pt }
end;

//-------------------------------------------------

procedure TForm1.PhoneticPword(Sender: TObject);
Var
  CodeType : String[50];
begin
  If Sender Is Text8Pt Then
    With Sender As Text8Pt Do Begin
      // Determine Security/Release Type from Tag
      Case Tag Of
        1  : If (PageControl1.ActivePage.PageIndex <> MCMPage) Then
               CodeType := 'Daily'
             Else
               CodeType := 'MCM';
        2  : CodeType := 'Plug-In';
      End; { Case Tag }

      // Display Msg with phonetic version of Password
      MessageDlg('The v' + SecRelLic.EntVer + ' phonetic ' + CodeType + ' Password is ' +
                 QuotedStr(StringToPhonetic (Text)), mtInformation, [mbOK], 0);
    End; { With Sender As Text8Pt }
end;

//-------------------------------------------------

procedure TForm1.OutSecPage;
Var
  Msg, Capt           : ANSIString;
  sCheck, sCheck2     : ShortString;
  Y, M, D, YInc, WInc : Word;
  YearStart           : TDateTime;
begin
  With SecRelLic Do Begin
    // v5.00 Passwords
    edtResetUser.Text := CalcRSysnc (2, Now, ESN[1], ESN[2], ESN[3], ESN[4], ESN[5], ESN[6]);
    edtResyncComps.Text := CalcRSysnc (3, Now, ESN[1], ESN[2], ESN[3], ESN[4], ESN[5], ESN[6]);
    edtResetPlugInUser.Text := CalcRSysnc (4, Now, ESN[1], ESN[2], ESN[3], ESN[4], ESN[5], ESN[6]);

    // v4.32 Re-sync Passwords
    edtResyncComps009.Text := Chr(Ord('A') + (ESN[1] Mod 12)) + Chr(Ord('A') + (ESN[2] Mod 12)) +
                              Chr(Ord('A') + (ESN[3] Mod 12)) + Chr(Ord('A') + (ESN[4] Mod 12)) +
                              Chr(Ord('A') + (ESN[5] Mod 12)) + Chr(Ord('A') + (ESN[6] Mod 12));

    // Date Driven calculation used from b431.010 - 17/07/00
    edtResyncComps011.Text := CalcRSysnc432 (Now, ESN[1], ESN[2], ESN[3], ESN[4], ESN[5], ESN[6]);

    lblv5PwordExpiry.Caption := 'v5.00 Pwords valid ' + FormatDateTime('DD/MM', FindLastWeekDay(Now, -1)) + ' - ' + FormatDateTime('DD/MM', FindLastWeekDay(Now, 1));

    ecDailyPW2.Text:=Generate_ESN_BaseSecurity(ESN,244,0,0);

  End; { With SecRelLic }
end;

//-------------------------------------------------


procedure TForm1.PhoneticSecPwords(Sender: TObject);
Var
  CodeType : String[50];
begin
  If Sender Is Text8Pt Then
    With Sender As Text8Pt Do Begin
      // Determine Security/Release Type from Tag
      Case Tag Of
        1  : CodeType := 'Resynchronise Companies (v5.00)';
        2  : CodeType := 'Reset Exchequer User Counts';
        3  : CodeType := 'Reset Plug-In Counts';
        4  : CodeType := 'Resynchronise Companies (v4.31)';
        5  : CodeType := 'Resynchronise Companies (v4.31)';
      End; { Case Tag }

      // Display Msg with phonetic version of Password
      MessageDlg('The phonetic password for ' + CodeType + ' is ' +
                 QuotedStr(StringToPhonetic (Text)), mtInformation, [mbOK], 0);
    End; { With Sender As Text8Pt }
end;


end.

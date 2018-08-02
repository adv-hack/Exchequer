unit lwType;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmLicWiz1 = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    lstCDType: TListBox;
    Bevel2: TBevel;
    btnNext: TButton;
    lstLicType: TListBox;
    lstCDCountry: TListBox;
    lstExchequerEdition: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    WizMod : SmallInt;
  end;


Procedure LicWiz_InstType (Var   WizForm           : TfrmLicWiz1;
                           Var   WizNo, LastWiz    : Byte;
                           Const WizPrev, WizNext  : Byte;
                           Var   Done, Aborted     : Boolean);

implementation

{$R *.DFM}

Uses LicVar, LicRec;

Var
  // MH 19/09/2016 2016-R3 ABSEXCH-17720: Protect Auto-Upgrade licences using a command-line switch
  SupportAutoUpgrade : Boolean;


Procedure LicWiz_InstType (Var   WizForm           : TfrmLicWiz1;
                           Var   WizNo, LastWiz    : Byte;
                           Const WizPrev, WizNext  : Byte;
                           Var   Done, Aborted     : Boolean);
Begin { LicWiz_InstType }
  { Create Form as and when necessary }
  If Not Assigned(WizForm) Then Begin
    WizForm := TfrmLicWiz1.Create(Application.MainForm);
  End; { If Not Assigned(frmWiz10)  }

  { Re-Initialise forms return value }
  WizForm.WizMod := Wiz_Abort;

  { Display Form }
  WizForm.ShowModal;

  { Process return value }
  Case WizForm.WizMod Of
    Wiz_Abort  : Aborted := True;

    Wiz_Prev   : WizNo := WizPrev;

    Wiz_Next   : WizNo := WizNext;
  End; { Case }

  LastWiz := Wiz_Type;
End; { LicWiz_InstType }

{----------------------------------------------------------------------------}

procedure TfrmLicWiz1.FormCreate(Sender: TObject);

  Procedure AddCountry (CntName : ShortString; CntIdx : LongInt);
  Begin { AddCountry }
    lstCDCountry.Items.AddObject (CntName, Pointer(CntIdx));
  End; { AddCountry }

begin
  {$IFDEF SALEUTIL}
    Button1.Visible := False;
  {$ENDIF}

  licInitWin (Self, Wiz_Type);

  { Init local variables }
  WizMod := Wiz_Abort;

  { Load Country List }
  AddCountry ('Australia', 4);
  AddCountry ('Ireland', 5);
  AddCountry ('New Zealand', 2);
  AddCountry ('Singapore', 3);
  AddCountry ('South Africa', 6);
  AddCountry ('United Kingdom', 1);

  { Initialise screen values }
  lstExchequerEdition.ItemIndex := Ord(LicenceInfo.licExchequerEdition);
  lstLicType.ItemIndex := LicenceInfo.licLicType;

  //lstCDCountry.ItemIndex := LicenceInfo.licCountry;
  Case LicenceInfo.licCountry Of
    1 : lstCDCountry.ItemIndex := 5;  // UK
    2 : lstCDCountry.ItemIndex := 2;  // NZ
    3 : lstCDCountry.ItemIndex := 3;  // Sing
    4 : lstCDCountry.ItemIndex := 0;  // Aus
    5 : lstCDCountry.ItemIndex := 1;  // EIRE
    6 : lstCDCountry.ItemIndex := 4;  // RS
  End; // Case LicenceInfo.licCountry

  // MH 19/09/2016 2016-R3 ABSEXCH-17720: Protect Auto-Upgrade licences using a command-line switch
  lstCDType.Items.Add ('Installation');
  lstCDType.Items.Add ('Upgrade');
  If SupportAutoUpgrade Then
  Begin
    lstCDType.Items.Add ('Auto-Upgrade (Pervasive.SQL)');
    lstCDType.Items.Add ('Auto-Upgrade (MS SQL Server)');

    If (LicenceInfo.licType = 2) Then
    Begin
      If (LicenceInfo.licEntDB = 1) Then
        lstCDType.ItemIndex := 3 // MS SQL
      Else
        lstCDType.ItemIndex := 2; // P.SQL
    End // If (LicenceInfo.licType = 2)
    Else
      lstCDType.ItemIndex := LicenceInfo.licType;
  End // If FindCmdLineSwitch('AutoUpgrade', ['/', '-'], True)
  Else
    lstCDType.ItemIndex := LicenceInfo.licType;
end;

procedure TfrmLicWiz1.btnNextClick(Sender: TObject);
begin
  { Check a Type has been selected }
  If (lstExchequerEdition.ItemIndex > -1) And (lstLicType.ItemIndex > -1) And (lstCDType.ItemIndex > -1) And (lstCDCountry.ItemIndex > -1) Then Begin
    // MH 19/11/2012 v7.0: Added support for Small Business Edition
    LicenceInfo.licExchequerEdition := TExchequerEdition(lstExchequerEdition.ItemIndex);
    If (LicenceInfo.licExchequerEdition = eeSmallBusiness) Then
    Begin
      // Set defaults - 3 User / 5 Company / 3 Runtime / Pervasive Workgroup
      LicenceInfo.licUserCnt := 3;
      LicenceInfo.licUserCounts[ucCompanies] := 5;
      LicenceInfo.licEntDB := DBBtrieve;
      LicenceInfo.licEntClSvr := 0;

      LicenceInfo.licModules[modToolDLLR] := 2;
      LicenceInfo.licUserCounts[ucToolkitFull] := 3;
    End; // If (LicenceInfo.licExchequerEdition = eeSmallBusiness)

    LicenceInfo.licLicType := lstLicType.ItemIndex;
    LicenceInfo.licCountry := LongInt(lstCDCountry.Items.Objects[lstCDCountry.ItemIndex]);

    //LicenceInfo.licEntDB := 0;
    Case lstCDType.ItemIndex Of
      0 : LicenceInfo.licType := 0;   // Install
      1 : LicenceInfo.licType := 1;   // Upgrade
      2 : Begin // 2 Auto-Upgrade (Pervasive.SQL)
            LicenceInfo.licType := 2;   // Auto-Upgrade
            LicenceInfo.licEntDB := 0;
          End; // 2 Auto-Upgrade (Pervasive.SQL)
      3 : Begin // 3 - Auto-Upgrade (MS SQL Server)
            LicenceInfo.licType := 2;   // Auto-Upgrade
            LicenceInfo.licEntDB := 1;
          End; // 3 - Auto-Upgrade (MS SQL Server)
    Else
      Raise Exception.Create('TfrmLicWiz1.btnNextClick: Unknown CD Type (' + IntToStr(lstCDType.ItemIndex) + ')');
    End; // Case lstCDType.ItemIndex

    WizMod := Wiz_Next;
    Close;
  End; { If }
end;

procedure TfrmLicWiz1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Save positions into ini file }
  licSaveCoords (Self);
end;

Initialization
  // MH 19/09/2016 2016-R3 ABSEXCH-17720: Protect Auto-Upgrade licences using a command-line switch
  SupportAutoUpgrade := FindCmdLineSwitch('SupportAutoUpgrade', ['/', '-'], True);
end.

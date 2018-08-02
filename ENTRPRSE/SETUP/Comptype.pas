unit CompType;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, WiseUtil;

type
  TfrmCompanyType = class(TSetupTemplate)
    radNew: TRadioButton;
    radDemo: TRadioButton;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    procedure Label1Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    { Private declarations }
    FPerformIAOCompanyCheck : Boolean;
    FIAOMainDir : ShortString;
    Function CheckCompCount : WordBool;
    Function  ValidOk(VCode : Char) : Boolean; Override;
  public
    { Public declarations }
    Property IAOMainDir : ShortString Read FIAOMainDir Write FIAOMainDir;
    Property PerformIAOCompanyCheck : Boolean Read FPerformIAOCompanyCheck Write FPerformIAOCompanyCheck;
  end;


function iaoGetCompanyType(var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.DFM}

Uses Brand, StrUtils;

//=========================================================================

{ Gets the method to create a company}
Function iaoGetCompanyType(var DLLParams: ParamRec): LongBool;
Var
  frmCompanyType  : TfrmCompanyType;
  DlgPN, ChkState : String;
Begin // iaoGetCompanyType
  // Get path of help file
  GetVariable(DLLParams, 'INST', DlgPN);
  Application.HelpFile := IncludeTrailingPathDelimiter(DlgPN) + 'SETUP.HLP';

  frmCompanyType := TfrmCompanyType.Create(Application);
  Try
    // If the user selects a blank/new company when adding a company then check the company count licence
    GetVariable(DLLParams,'V_INSTTYPE',DlgPN);
    frmCompanyType.PerformIAOCompanyCheck := (DlgPN[1] = 'C');
    If frmCompanyType.PerformIAOCompanyCheck Then
    Begin
      // Get IAO main dir path to do the check against
      GetVariable(DLLParams,'V_MAINDIR',DlgPN);
      frmCompanyType.IAOMainDir := IncludeTrailingPathDelimiter(DlgPN);
    End; // If frmCompanyType.PerformIAOCompanyCheck

    // Get current Data type value
    GetVariable(DLLParams, 'V_DEMODATA', ChkState);
    If (ChkState[1] = 'N') Then
      frmCompanyType.radNew.Checked := True
    Else
      frmCompanyType.radDemo.Checked := True;

    { HM 27/04/99: Modified to support new Setup with 3-digit dialog id's }
    GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);

    { Display dialog }
    frmCompanyType.ShowModal;
    Case frmCompanyType.ExitCode Of
      'B' : Begin { Back }
              SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3));
            End;
      'N' : Begin { Next }
              SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));
              SetVariable(DLLParams, 'V_DEMODATA', IfThen(frmCompanyType.radNew.Checked, 'N', 'Y'));
            End;
      'X' : Begin { Exit Installation }
              SetVariable(DLLParams,'DIALOG','999')
            End;
    End; // Case frmCompanyType.ExitCode
  Finally
    FreeAndNIL(frmCompanyType);
  End;

  Result := False;
End; // iaoGetCompanyType

//=========================================================================

procedure TfrmCompanyType.FormCreate(Sender: TObject);
begin
  inherited;
  FPerformIAOCompanyCheck := False;
end;

//-------------------------------------------------------------------------

procedure TfrmCompanyType.Label1Click(Sender: TObject);
begin
  inherited;

  radNew.Checked := True;
end;

procedure TfrmCompanyType.Label3Click(Sender: TObject);
begin
  inherited;

  radDemo.Checked := True;
end;

//-------------------------------------------------------------------------

Function TfrmCompanyType.CheckCompCount : WordBool;
Var
  _CheckCompCount : Function (Const CompPath : ShortString) : WordBool; StdCall;
  _DLLHandle      : THandle;
  LibPath         : ANSIString;
Begin // CheckCompCount
  Result := False;

  // Load ENTCOMP.DLL dynamically
  LibPath := FIAOMainDir + 'EntComp2.Dll';
  _DLLHandle := LoadLibrary(PCHAR(LibPath));

  Try
    If (_DLLHandle > HInstance_Error) Then Begin
      _CheckCompCount := GetProcAddress(_DLLHandle, 'Setup_CheckCompCount');

      If Assigned(_CheckCompCount) Then
        Result := _CheckCompCount(FIAOMainDir);

      { Unload library }
      FreeLibrary(_DLLHandle);
      _DLLHandle:=0;
    End; { If }
  Except
    FreeLibrary(_DLLHandle);
    _DLLHandle:=0;
    _CheckCompCount := Nil;
  End;
End; // CheckCompCount

//------------------------------

Function TfrmCompanyType.ValidOk(VCode : Char) : Boolean;
Begin // ValidOk
  // MH 30/11/06: For IAO Blank Dataset installations check the number of companies licenced
  If PerformIAOCompanyCheck And radNew.Checked Then
  Begin
    // Check the Company Count to ensure free slots in the licence }
    Result := CheckCompCount;
    If (Not Result) Then
      MessageDlg ('This System has already reached the licenced number of companies, ' +
                  'please contact your Dealer or Distributor to get details on increasing ' +
                  'your Company Licence Count.', mtWarning, [mbOk], 0);
  End // If PerformIAOCompanyCheck And radNew.Checked
  Else
    Result := True;
End; // ValidOk

//-------------------------------------------------------------------------


end.

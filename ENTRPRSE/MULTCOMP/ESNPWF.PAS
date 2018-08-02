unit ESNPWF;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ExtCtrls, LicRec;

type
  TfrmESNPassword = class(TForm)
    TitleLbl: TLabel;
    InstrLbl: TLabel;
    IconImage: TImage;
    Label4: TLabel;
    Label1: TLabel;
    edtESN: TMaskEdit;
    edtPWord: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FLicence : EntLicenceRecType;
    procedure SetLicence(const Value: EntLicenceRecType);
  public
    { Public declarations }
    ModuleNo : Byte;
    Property Licence : EntLicenceRecType Read FLicence Write SetLicence;
  end;

// Challenges the user to enter an ESN Password to continue
Function GetESNPword (Const ModNo  : Byte;
                      Const Title  : ShortString) : Boolean;


implementation

{$R *.DFM}

Uses RSyncU, EntLic, LicFuncU;

Function GetESNPword (Const ModNo  : Byte;
                      Const Title  : ShortString) : Boolean;
Var
  LicR   : EntLicenceRecType;
  sInstr : ShortString;
Begin { GetESNPword }
  Result := False;

  With TfrmESNPassword.Create(Application.MainForm) Do
    Try
      { Add title into on-screen text }
      TitleLbl.Caption := Title;
      sInstr := InstrLbl.Caption;
      Insert (Title, sInstr, 6);
      InstrLbl.Caption := sInstr;

      ReadEntLic (EntLicFName, LicR);
      { Set ESN & Module No for calculating the PW }
      //ESN := SysESN;
      Licence := LicR;
      ModuleNo := ModNo;

      Result := (ShowModal = mrOK);
    Finally
      Free;
    End;
End; { GetESNPword }

//---------------

procedure TfrmESNPassword.btnOKClick(Sender: TObject);
Var
  OK : Boolean;
  PW : ShortString;
begin
  PW := UpperCase(Trim(edtPWord.Text));

  // Check not blank
  OK := (PW <> '');

  // Check Pword is correct
  With FLicence Do
    OK := (PW = CalcRSysnc (ModuleNo, Now, LicISN[1], LicISN[2], LicISN[3], LicISN[4], LicISN[5], LicISN[6]));

  If OK Then
    // AOK
    ModalResult := mrOk
  Else Begin
    If edtPWord.CanFocus Then edtPWord.SetFocus;
    Beep;
  End; { Else }
end;

//---------------

procedure TfrmESNPassword.SetLicence(const Value: EntLicenceRecType);
begin
  FLicence := Value;

  edtESN.Text := licESN7Str (FLicence.licISN, FLicence.licLicType);
end;

//---------------


end.

unit ESNPW;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, LicRec, ExtCtrls, Buttons, ComCtrls;

type
  TfrmESNPasswords = class(TForm)
    Label4: TLabel;
    meESN1: TMaskEdit;
    Label2: TLabel;
    Label5: TLabel;
    Bevel2: TBevel;
    btnClose: TButton;
    Bevel1: TBevel;
    Label3: TLabel;
    edtResetUser: TEdit;
    Label6: TLabel;
    edtResyncComps: TEdit;
    Label7: TLabel;
    edtCurrentDate: TEdit;
    Label1: TLabel;
    edtResetPlugInUser: TEdit;
    UpDown1: TUpDown;
    lblESNVer: TLabel;
    procedure meESN1Exit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtResetUserDblClick(Sender: TObject);
    procedure UpDown1ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
  private
    { Private declarations }
    pwESN : ESNByteArrayType;

    ThisWeekNo         : LongInt;
    StartDate, EndDate : Double;
    procedure DisplayWeek;
    Function FindLastWeekDay (Const BaseDate : Double; Const ChangeBy : SmallInt) : Double;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

Uses RSyncU, ESNImpU, Phonetic, LicFuncU;

//---------------------------------------------------------

procedure TfrmESNPasswords.FormCreate(Sender: TObject);
begin
  FillChar (pwESN, SizeOf(pwESN), #0);

  StartDate := FindLastWeekDay(Now, -1);
  EndDate   := FindLastWeekDay(Now, 1);
  DisplayWeek;
End;


//---------------------------------------------------------

procedure TfrmESNPasswords.DisplayWeek;
Begin
  edtCurrentDate.Text := FormatDateTime('DD/MM/YY', StartDate) + ' - ' + FormatDateTime ('DD/MM/YY', EndDate);
End;

//---------------------------------------------------------

Function TfrmESNPasswords.FindLastWeekDay (Const BaseDate : Double; Const ChangeBy : SmallInt) : Double;
Var
  YearStart, TestDate : Double;
  WeekNo, DD, MM, YY  : Word;
begin { DisplayWeek }
  // split date into constituent parts
  DecodeDate (BaseDate, YY, MM, DD);

  // Determine start of year for date - allows cross year operation
  YearStart := EncodeDate (YY, 1, 1);

  // Determine week within calendar year of date
  WeekNo := Trunc(BaseDate - YearStart) Div 7;

  // Run through dates to determine end of 'week'
  TestDate := BaseDate;
  While True Do Begin
    // split date into constituent parts
    DecodeDate (TestDate, YY, MM, DD);

    // Determine start of year for date - allows cross year operation
    YearStart := EncodeDate (YY, 1, 1);

    // Determine week within calendar year of date
    If ((Trunc(TestDate - YearStart) Div 7) <> WeekNo) Then Begin
      // Week number changed - yesterday was end of week
      Result := TestDate - ChangeBy;
      Break;
    End; { If }

    TestDate := TestDate + ChangeBy;
  End; { While True }
end; { DisplayWeek }

//---------------------------------------------------------

procedure TfrmESNPasswords.meESN1Exit(Sender: TObject);
Var
  DemoFlag : Byte;
begin
  // HM 06/02/02: Extended for 7 segment ESN's
  //If ProcessESNStr (pwESN, meESN1) Then Begin
  If ProcessESN7Str (pwESN, DemoFlag, meESN1) Then Begin
    // ESN OK - generate passwords }
    edtResetUser.Text := CalcRSysnc (2, StartDate, pwESN[1], pwESN[2], pwESN[3], pwESN[4], pwESN[5], pwESN[6]);
    edtResyncComps.Text := CalcRSysnc (3, StartDate, pwESN[1], pwESN[2], pwESN[3], pwESN[4], pwESN[5], pwESN[6]);
    edtResetPlugInUser.Text := CalcRSysnc (4, StartDate, pwESN[1], pwESN[2], pwESN[3], pwESN[4], pwESN[5], pwESN[6]);

    // Validate the DemoFlag byte
    If licDecodeDemoFlag (pwESN, DemoFlag) Then
      lblESNVer.Caption := '(' + licLicTypeToStr (DemoFlag, True) + ')'
    Else Begin
      // Byte7 is invalid
      lblESNVer.Caption := 'INVALID';
      SysUtils.Beep;
    End; { Else }
  End; { If ProcessESNStr... }
end;

//---------------------------------------------------------

procedure TfrmESNPasswords.edtResetUserDblClick(Sender: TObject);
begin
  With Sender As TEdit Do
    ShowMessage (StringToPhonetic (Text));
end;

procedure TfrmESNPasswords.UpDown1ChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  If (Direction = updUp) Then Begin
    // Up = Later
    StartDate := EndDate + 1;
    EndDate   := FindLastWeekDay(StartDate, 1);
  End { If }
  Else Begin
    // Down = Earlier
    EndDate   := StartDate - 1;
    StartDate := FindLastWeekDay(EndDate, -1);
  End; { Else }
  DisplayWeek;

  meESN1Exit(Self);
end;

end.

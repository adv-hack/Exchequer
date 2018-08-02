unit LicenceF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, oDistLic;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    cbLicencee: TComboBox;
    Label2: TLabel;
    edtPword: TEdit;
    Label3: TLabel;
    btnWritelic: TButton;
    mskLicExpiry: TMaskEdit;
    procedure btnWritelicClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    oLicence : TDistributorLicence;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

//----------------------------------------------------------------------------

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;

  oLicence := TDistributorLicence.Create;
  With oLicence Do Begin
    // Set Default details
    cbLicencee.Text := dlLicencee;
    edtPword.Text := dlPassword;
    mskLicExpiry.Text := FormatDateTime('DD/MM/YYYY', dlLicenceExpiry);
  End; { With oLicence }
end;

//----------------------------------------------------------------------------

procedure TForm1.btnWritelicClick(Sender: TObject);
Var
  OK   : Boolean;
begin
  With oLicence Do Begin
    // Re-Initialise the Licence Object
    InitLicencing;

    // Validate the Licencee
    OK := (Trim(cbLicencee.Text) <> '');
    If OK Then
      dlLicencee := Trim(cbLicencee.Text)
    Else Begin
      MessageDlg ('The Licencee must be set', mtError, [mbOk], 0);
      If cbLicencee.CanFocus Then cbLicencee.SetFocus;
    End; { Else }

    // Validate the Password
    If OK Then Begin
      OK := (Length(Trim(edtPword.Text)) >= 6);
      If OK Then
        dlPassword := Trim(edtPword.Text)
      Else Begin
        MessageDlg ('The Password must be at least 6 characters long', mtError, [mbOk], 0);
        If edtPword.CanFocus Then edtPword.SetFocus;
      End; { Else }
    End; { If OK }

    // Validate the Licence Expiry Date
    If OK Then Begin
      // Check Expiry Date is valid
      dlLicenceExpiry := StrToDate (mskLicExpiry.Text);
      If (dlLicenceExpiry < Now) Then Begin
        MessageDlg ('The Licence Expiry Date has already passed', mtError, [mbOk], 0);
        If mskLicExpiry.CanFocus Then mskLicExpiry.SetFocus;
        OK := False;
      End { If (dlLicenceExpiry < Now) }
      Else
        // Confirm if it expires too far into the future - lic runs for 1 year + allow 2 weeks advance for renewal
        If (dlLicenceExpiry > (Now + DefaultLicenceDays + 14)) Then Begin
          OK := (MessageDlg ('Please confirm the Licence Expiry Date of ' +
                             QuotedStr(FormatDateTime('DD/MM/YYYY', dlLicenceExpiry)),
                             mtConfirmation, [mbYes, mbNo], 0) = mrYes);
          If (Not OK) And mskLicExpiry.CanFocus Then mskLicExpiry.SetFocus;
        End; { If (piExpiry > (Now + 365 + 14)) }
    End; { If OK }

    If OK Then
      // Display confirmation message to check the user wanted to write the licence
      OK := (MessageDlg('Are you sure you want to write a Distributor Release Code Utility Licence for ' +
                        dlLicencee + '?', mtConfirmation, [mbYes,mbNo], 0) = mrYes);

    If OK Then Begin
      // Write the Licence to the current directory
      Save (IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)));
    End; { If OK }
  End; { With oLicence }
end;

//----------------------------------------------------------------------------

end.

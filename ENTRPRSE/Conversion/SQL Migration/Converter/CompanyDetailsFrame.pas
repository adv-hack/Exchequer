unit CompanyDetailsFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, oConvertOptions, ConvSQLFuncs;

type
  TframCompanyDetails = class(TFrame)
    lblCompNo: TLabel;
    lblCompCode: TLabel;
    lblCompName: TLabel;
    edtRepUserId: TEdit;
    edtRepUserPwd: TEdit;
    lblRootCompany: TLabel;
  private
    { Private declarations }
    FIndex : LongInt;
    FCompanyDetails : TConversionCompany;

    Function GetIndex : LongInt;
    Procedure SetIndex (Value : LongInt);

    Function GetCompanyDets : TConversionCompany;
    Procedure SetCompanyDets (Value : TConversionCompany);
  public
    { Public declarations }
    Property Index : LongInt Read GetIndex Write SetIndex;
    Property CompanyDets : TConversionCompany Read GetCompanyDets Write SetCompanyDets;

    Function ValidateReportingUser (Var PreviousUsers : TStringList) : Boolean;
  end;

implementation

{$R *.dfm}

//-------------------------------------------------------------------------

Function TframCompanyDetails.GetIndex : LongInt;
Begin // GetIndex
  Result := FIndex;
End; // GetIndex
Procedure TframCompanyDetails.SetIndex (Value : LongInt);
Begin // SetIndex
  FIndex := Value;
  lblCompNo.Caption := IntToStr(FIndex);
End; // SetIndex

//------------------------------

Function TframCompanyDetails.GetCompanyDets : TConversionCompany;
Begin // GetCompanyDets
  Result := FCompanyDetails;
End; // GetCompanyDets
Procedure TframCompanyDetails.SetCompanyDets (Value : TConversionCompany);
Begin // SetCompanyDets
  FCompanyDetails := Value;
  lblCompCode.Caption := Trim(FCompanyDetails.ccCompanyCode);
  lblCompName.Caption := Trim(FCompanyDetails.ccCompanyName);
  edtRepUserId.Text := Trim(FCompanyDetails.ccReportingUserId);
  edtRepUserPwd.Text := Trim(FCompanyDetails.ccReportingUserPwd);
  lblRootCompany.Visible := FCompanyDetails.ccRootCompany;
End; // SetCompanyDets

//-------------------------------------------------------------------------

Function TframCompanyDetails.ValidateReportingUser (Var PreviousUsers : TStringList) : Boolean;
Var
  sUID, sPwd : ShortString;

  //------------------------------

  Function ValidUserId : Boolean;
  Const
    ValidChars = ['a'..'z', 'A'..'Z', '0'..'9'];
  Var
    I: SmallInt;
  Begin // ValidUserId
    Result := (sUId <> '') And (Not (sUId[1] In ['0'..'9']));
    If Result Then
    Begin
      For I := 1 To Length(sUId) Do
      Begin
        If Not (sUId[I] In ValidChars) Then
        Begin
          Result := False;
          Break;
        End; { If }
      End; { For }
    End; { If }
  End; // ValidUserId

  //------------------------------

Begin // ValidateReportingUser
  // Reporting User Id - must be set and must not already exist in the SQL Database Engine
  sUID := Trim(edtRepUserId.Text);
  Result := ValidUserId;
  If Result Then
  Begin
    // Check hasn't been used for a previous company
    Result := (PreviousUsers.IndexOf(UpperCase(Trim(sUID))) = -1);
    If Result Then
    Begin
      // Check doesn't exist in Database already
      Result := Not DatabaseUserExists(sUID);
      If (Not Result) Then
      Begin
        If edtRepUserId.CanFocus Then edtRepUserId.SetFocus;
        MessageDlg ('The Reporting User for Company ' + lblCompCode.Caption + ' already exists in the Database Engine', mtError, [mbOK], 0);
      End; // If (Not Result)
    End // If Result
    Else
    Begin
      If edtRepUserId.CanFocus Then edtRepUserId.SetFocus;
      MessageDlg ('The Reporting User for Company ' + lblCompCode.Caption + ' has already been used for a previous company', mtError, [mbOK], 0);
    End; // Else
  End // If Result
  Else
  Begin
    If edtRepUserId.CanFocus Then edtRepUserId.SetFocus;
    MessageDlg ('The Reporting User for Company ' + lblCompCode.Caption + ' cannot be left blank, ' +
                'can only include characters ''a'' to ''z'', ''A'' to ''Z'' and ''0'' to ''9'' ' +
                'and cannot start with a number', mtError, [mbOK], 0);
  End; // Else

  If Result Then
  Begin
    sPwd := Trim(edtRepUserPwd.Text);
    Result := (sPwd <> '');
    If (Not Result) Then
    Begin
      If edtRepUserPwd.CanFocus Then edtRepUserPwd.SetFocus;
      MessageDlg ('The Reporting User Password for Company ' + lblCompCode.Caption + ' cannot be left blank', mtError, [mbOK], 0);
    End; // If (Not Result)
  End; // If Result

  If Result Then
  Begin
    FCompanyDetails.ccReportingUserId := sUId;
    FCompanyDetails.ccReportingUserPwd := sPwd;

    PreviousUsers.Add (UpperCase(Trim(SUID)));
  End; // If Result
End; // ValidateReportingUser

//-------------------------------------------------------------------------

end.

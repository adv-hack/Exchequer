unit ImportF1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls,
  oDataQ,              // Base Data Query Server Object
  Enterprise_TLB,      // Data Query Server Type Library
  {$IFDEF EXEVER}
    Enterprise01_TLB;    // COM Toolkit Type Library // DLL Version for .EXE EntDataQ
  {$ELSE}
    Enterprise04_TLB;    // COM Toolkit Type Library // MH 08/09/2008: Switched to .EXE COM Toolkit
  {$ENDIF}

Type
  TfrmSelectCompany = class(TForm)
    Bevel1: TBevel;
    TitleLbl: TLabel;
    lblInstructions: TLabel;
    imgSide: TImage;
    btnHelp: TButton;
    Panel1: TPanel;
    Image1: TImage;
    btnClose: TButton;
    btnBack: TButton;
    btnNext: TButton;
    lvCompanies: TListView;
    procedure btnNextClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
    FDataQuery    : TDataQuery;

    // CA 12/03/2013 v7.0.2 : ABSEXCH-13290 : New variables required
    UserPermCode  : Integer;
    UserPermName  : AnsiString;

    Procedure DoBitmapStuff;
    Procedure SetUpUserPermission;
    Procedure CMDialogKey(Var Msg:TWMKey); message CM_DIALOGKEY;
  public
    { Public declarations }
    ExitCode : Char;

    Constructor Create(AOwner: TComponent; Const DataQuery : TDataQuery); ReIntroduce;
  end;

var
  frmSelectCompany: TfrmSelectCompany;

implementation

{$R *.dfm}

Uses Brand, LoginF, PasswordComplexityConst;

//-----------------------------------------------------------------------------------------

Procedure TfrmSelectCompany.CMDialogKey(Var Msg:TWMKey);
Begin
  If NOT (ActiveControl Is TButton) Then
    If Msg.Charcode = 13 Then
      Msg.Charcode := 9;

  inherited;
End;

//-----------------------------------------------------------------------------------------

Constructor TfrmSelectCompany.Create(AOwner: TComponent; Const DataQuery : TDataQuery);
Var
  I : LongInt;
begin
  Inherited Create (AOwner);

  FDataQuery := DataQuery;

  ExitCode := 'X';

  // Setting up the appropriate User Permission chosen by user
  SetUpUserPermission;

  // Need to set the size of the bmp otherwise we can't paint into it
  Image1.Picture.Bitmap.Height := Image1.Height;
  Image1.Picture.Bitmap.Width := Image1.Width;

  Icon := Branding.pbProductIcon;
  Branding.BrandingFile(ebfSetup).ExtractImage (imgSide, 'TallWizd');

  // Paint bitmap
  DoBitmapStuff;

  // Customise text to be topical
  Caption := Branding.pbProductName + ' Data Query Wizard - ' + FDataQuery.TypeDesc[tsdDataPlural];
  lblInstructions.Caption := lblInstructions.Caption + FDataQuery.TypeDesc[tsdDataPlural] + ' from:-';

  // Load Company Details into ListView
  With FDataQuery.COMTK Do Begin
   With Company Do
    If (cmcount > 0) Then Begin
      For I := 1 To cmCount Do
        With cmCompany[I] Do
          // MH 13/02/2008: Modified for SQL Compatibility
          //If FileExists(IncludeTrailingPathDelimiter(Trim(coPath)) + 'ExchQss.Dat') Then
          If FileExists(IncludeTrailingPathDelimiter(Trim(coPath)) + 'Company.Sys') Then
            With lvCompanies.Items.Add Do Begin
              Caption := Trim(coCode);
              SubItems.Add (Trim(coName));
              Data := Pointer(I);
            End; { With lvCompanies.Items.Add }

      If (FDataQuery.CompanyIdx >= 1) And (FDataQuery.CompanyIdx <= cmCount) Then Begin
        lvCompanies.ItemIndex := FDataQuery.CompanyIdx - 1;
        lvCompanies.Selected.MakeVisible(False);
      End; { If (FDataQuery.CompanyIdx >= 1) And (FDataQuery.CompanyIdx <= cmCount) }
    End; { If (cmcount > 0) }
  End; { With FDataQuery.COMTK }
end;

//-----------------------------------------------------------------------------------------

Procedure TfrmSelectCompany.DoBitmapStuff;
Var
  FromRect, ToRect : TRect;
begin
  Image1.Picture.Bitmap.Height := Image1.Height;
  Image1.Picture.Bitmap.Width := Image1.Width;

  FromRect := Rect (0, imgSide.Picture.Height - Image1.Height, imgSide.Picture.Width, imgSide.Picture.Height);
  ToRect   := Rect (0, 0, Image1.Width, Image1.Height);

  DeleteObject(Image1.Picture.Bitmap.Palette);
  Image1.Picture.Bitmap.Palette:=CopyPalette(imgSide.Picture.Bitmap.Palette);
  Image1.Picture.Bitmap.Canvas.CopyRect(ToRect, imgSide.Picture.Bitmap.Canvas, FromRect);
end;

//-----------------------------------------------------------------------------------------

procedure TfrmSelectCompany.btnNextClick(Sender: TObject);
Var
  FuncRes : LongInt;
  lOK      : Boolean;
  // CA 12/03/2013 v7.0.2 : ABSEXCH-13290 : New fields created
  AccessAllowed   : Boolean;
  SelCompanyName  : AnsiString;
begin
  // Check a company has been selected
  If (lvCompanies.ItemIndex >= 0) Then Begin
    // Check the COM Toolkit is up and running
    If Assigned(FDataQuery.COMTK) Then
      With FDataQuery.COMTK Do Begin
        // Close COM Toolkit if Open
        If (Status = tkOpen) Then
          CloseToolkit;

        // Extract Companies Data Path for selected company data set
        With Company.cmCompany[LongInt(lvCompanies.Selected.Data)] Do
        Begin
          Configuration.DataDirectory := coPath;
          SelCompanyName              := coName;
        End;

        with TfrmLogin.Create(Self) Do
        Try
           CompNamePath :=  Configuration.DataDirectory;
           CompName     :=  SelCompanyName;
           AreaCode     :=  UserPermCode;
           AreaCodeName :=  UserPermName;

           LoginDialog  :=  ldOLEDataQuery;
           InitDefaults;
           ShowModal;
           AccessAllowed := ModalResult = mrOk;
           // MH 28/11/2013 v7.0.8 ABSEXCH-14797: Added Consumer Support - store username for later permission checks
           if AccessAllowed Then
             FDataQuery.UserName := Trim(UpperCase(txtUserName.Text));
        Finally
          Free;
        End;

        // CA 12/03/2013 v7.0.2 : ABSEXCH-13290 : Only proceed if everything came back OK from login screen
        If AccessAllowed then
        Begin
           // Open the Toolkit
          FuncRes := OpenToolkit;
          If (FuncRes = 0) Then Begin
            // Check any company specific rights/settings
            Case FDataQuery.DataType Of
              dqmCostCentre,
              dqmDepartment    : Begin
                                   // Check CostCentre's/Departments are in use
                                   lOK := SystemSetup.ssUseCCDept;
                                   If (Not lOK) Then
                                     MessageDlg ('This Company Data Set is not configured to use Cost Centres or Departments, please select another data set',
                                                 mtInformation, [mbOk], 0);
                                 End;

              dqmLocation      : Begin
                                   // Check Locations are in use
                                   lOK := SystemSetup.ssUseLocations;
                                   If (Not lOK) Then
                                     MessageDlg ('This Company Data Set is not configured to use Locations, please select another data set',
                                                 mtInformation, [mbOk], 0);
                                 End;
            Else
              lOK := True;
            End; { Case FDataQuery.DataType }

            If lOK Then Begin
              // Close this dialog and move to the next one
              ExitCode := 'N';
              Close;
            End; { If lOK }
          End { If (FuncRes = 0) }
          Else
            MessageDlg ('The following error occurred whilst opening the COM Toolkit:-'#13#13 +
                        Format('Error %d: %s', [FuncRes, QuotedStr(LastErrorString)]),
                        mtError, [mbOk], 0);
        End; { With FDataQuery.COMTK }
    End;
  End { If (lvCompanies.ItemIndex >= 0) }
  Else
    MessageDlg ('A Company Data Set must be selected before you can proceed', mtError, [mbOk], 0);
end;

//-----------------------------------------------------------------------------------------

// CA 12/03/2013 v7.0.2 : ABSEXCH-13290 : New procedure to setup appropriate code
Procedure TfrmSelectCompany.SetUpUserPermission;
Begin
  Case FDataQuery.DataType Of
    dqmCostCentre :  Begin
                        UserPermCode := 485;
                        UserPermName := 'Cost Centre';
                     End;

    dqmCustomer   :  Begin
                        UserPermCode := 475;
                        UserPermName := 'Customer';
                     End;

    dqmDepartment :  Begin
                        UserPermCode := 486;
                        UserPermName := 'Department';
                     End;

    dqmGLCode     :  Begin
                        UserPermCode := 487;
                        UserPermName := 'GLCode';
                     End;

    dqmJob        :  Begin
                        UserPermCode := 514;
                        UserPermName := 'Job';
                     End;

    dqmLocation   :  Begin
                        UserPermCode := 489;
                        UserPermName := 'Location';
                     End;

    dqmStock      :  Begin
                        UserPermCode := 489;
                        UserPermName := 'Stock';
                     End;

    dqmSupplier   :  Begin
                        UserPermCode := 480;
                        UserPermName := 'Supplier';
                     End;
  End;
End;

//-----------------------------------------------------------------------------------------

procedure TfrmSelectCompany.btnCloseClick(Sender: TObject);
begin
  ExitCode := 'X';
  Close;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmSelectCompany.btnHelpClick(Sender: TObject);
begin
  If (HelpContext <> 0) Then Begin
    If IsLibrary Then
      Application.HelpFile := 'EnterOle.Chm';
    Application.HelpContext (HelpContext);
  End; { If (HelpContext <> 0) }
end;

//-----------------------------------------------------------------------------------------

end.

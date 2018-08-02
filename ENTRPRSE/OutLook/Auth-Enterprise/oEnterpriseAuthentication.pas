unit oEnterpriseAuthentication;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, IRISEnterpriseKPI_TLB, StdVcl, IKPIHost_TLB, oAuthenticationState;

type
  TEnterpriseAuthentication = class(TAutoObject, IAuthenticationPlugIn)
  private
    oState : TEnterpriseAuthenticationState;
  protected
    // IAuthenticationPlugIn
    function Get_apAuthenticationId: WideString; safecall;
    procedure CheckIAPFile(const IAPPath: WideString); safecall;
    function Login(var AuthData: WideString; HostHandle: Integer): WordBool; safecall;
    function Get_apAuthenticationState: WideString; safecall;
    procedure Set_apAuthenticationState(const Value: WideString); safecall;

    // Checks the Authentication State to see if user has already logged in
    function CheckLogin(var AuthData: WideString): WordBool; safecall;

  public
    procedure Initialize; override;
    Destructor Destroy; override;
  end;

implementation

uses ComServ, Controls, Dialogs, SysUtils, GmXML, LoginF, Enterprise01_TLB, CTKUtil;

//=========================================================================

procedure TEnterpriseAuthentication.Initialize;
Begin // Initialize
  inherited Initialize;

  oState := TEnterpriseAuthenticationState.Create;
End; // Initialize

//------------------------------

Destructor TEnterpriseAuthentication.Destroy;
Begin // Destroy
  oState.Free;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

procedure TEnterpriseAuthentication.CheckIAPFile(const IAPPath: WideString);
begin
//  With TIniFile.Create(IAPPath) Do
//  Begin
//    Try
//
//      No action required
//
//    Finally
//      Free;
//    End; // Try..Finally
//  End; // With TIniFile.Create(IAPPath)
end;

//-------------------------------------------------------------------------

// Get/Set methods for apAuthenticationState property which contains the plug-in defined
// string containing the prior history of logins through this plug-in during the lifetime
// of the host instance.
//
// Because this plug-in is stateless this is stored by the host and is set everytime an
// instance of this plug-in is created.
//
// The format is up to the writer of the authentication plug-in, the host does not read
// it, only stores it in memory and provides it to the plug-in each time it is created
//
//
function TEnterpriseAuthentication.Get_apAuthenticationState: WideString;
Begin // Get_apAuthenticationState
  Result := oState.State;
End; // Get_apAuthenticationState
procedure TEnterpriseAuthentication.Set_apAuthenticationState(const Value: WideString);
Begin // Set_apAuthenticationState
  oState.State := Value;
End; // Set_apAuthenticationState

//------------------------------

function TEnterpriseAuthentication.Get_apAuthenticationId: WideString;
begin
  Result := 'IRISEnterprise';
end;

//-------------------------------------------------------------------------

function TEnterpriseAuthentication.CheckLogin(var AuthData: WideString): WordBool;
Var
  oAuthReq : TEnterpriseAuthenticationRequirements;
Begin // CheckLogin
  Result := False;

  // Break down the supplied authentication requirements for processing
  oAuthReq := TEnterpriseAuthenticationRequirements.Create(AuthData);
  Try
    If (oAuthReq.Company <> '') Then
    Begin
      // Lookup Company in Authentication State
      AuthData := oState.AuthenticationData[oAuthReq.Company];
      Result := (AuthData <> '');
    End; // If (oAuthReq.Company <> '')
  Finally
    oAuthReq.Free;
  End; // Try..Finally
End; // CheckLogin

//-------------------------------------------------------------------------

function TEnterpriseAuthentication.Login(var AuthData: WideString; HostHandle: Integer): WordBool;
Var
  oAuthReq : TEnterpriseAuthenticationRequirements;
  frmEnterpriseLogin : TfrmEnterpriseLogin;
  oToolkit : IToolkit;
  CompanyPath : ShortString;
  Res : LongInt;
Begin // Login
  Result := False;

  // Break down the supplied authentication requirements for processing
  oAuthReq := TEnterpriseAuthenticationRequirements.Create(AuthData);
  Try
    If (oAuthReq.Company <> '') Then
    Begin
      oToolkit := CreateToolkitWithBackdoor;
      Try
        // Validate Company Code and open the COM Toolkit to validate the Login
        CompanyPath := CompanyPathFromCode(oToolkit, oAuthReq.Company);
        If DirectoryExists(CompanyPath) Then
        Begin
          oToolkit.Configuration.DataDirectory := CompanyPath;
          Res := oToolkit.OpenToolkit;
          If (Res = 0) Then
          Begin
            frmEnterpriseLogin := TfrmEnterpriseLogin.Create(NIL);
            Try
              frmEnterpriseLogin.Caption := frmEnterpriseLogin.Caption + ' [' + oAuthReq.Company + ']';
              frmEnterpriseLogin.Host := HostHandle;
              frmEnterpriseLogin.Toolkit := oToolkit As IToolkit2;
              Result := (frmEnterpriseLogin.ShowModal = mrOK);
              If Result Then
              Begin
                // Add into Authentication State and return Authentication details to caller
                oState.AddAuthentication(oAuthReq.Company, frmEnterpriseLogin.UserId);
                AuthData := oState.AuthenticationData[oAuthReq.Company];
                Result := True;
              End; // If Result
            Finally
              frmEnterpriseLogin.Free;
            End; // Try..Finally
          End // If (Res = 0)
          Else
            MessageDlg('Error ' + IntToStr(Res) + ' opening The Company Dataset for Company ' + oAuthReq.Company + ', please notify your Technical Support', mtError, [mbOK], 0);
        End // If DirectoryExists(CompanyPath)
        Else
          MessageDlg('The Company Dataset for Company ' + oAuthReq.Company + ' cannot be found, please notify your Technical Support', mtError, [mbOK], 0);
      Finally
        oToolkit := NIL;
      End; // Try..Finally
    End; // If (oAuthReq.Company <> '')
  Finally
    oAuthReq.Free;
  End; // Try..Finally
End; // Login

//=========================================================================

initialization
  TAutoObjectFactory.Create(ComServer, TEnterpriseAuthentication, Class_EnterpriseAuthentication,
    ciMultiInstance, tmApartment);
end.

unit MenuProc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , StdCtrls, ShellAPI, Menus, IniFiles, APIUtil, StrUtil, COMObj
  , SecSup2U, FileUtil, IncludeCustMenu, Enterprise01_TLB;

Type
  TCompanyRec = Record
    Name : string[45];
    Code : string[6];
    Path : string[100];
  end;

  TCompanyInfo = Class
    CompanyRec : TCompanyRec;
  end;{with}

  TEntMenuObj = Class(TObject)
  Private
    Constructor Create;
    Destructor  Destroy; Override;
  Public
    hNewMenu   : NewMenuFunc;
    miUtilities, miRunAdmin, miSystemSetupMenu : TMenuItem;
    procedure CreateRunAdminOption;
    procedure MenuOpt_RunAdminClick(Sender: TObject);
  End; { EntMenuObj }

  procedure InitToolkit(sPath : string);

Var
  slCompanies : TStringList;
  oToolkit : IToolkit;
  CurrentCompanyRec : TCompanyRec;
  EnterpriseMenu : TMainMenu;
  gEntInfo : EntCustomInfo;
  EntMenuObj  : TEntMenuObj;
  OldApp      : TApplication;
  OldScr      : TScreen;

implementation
Uses
  UDPeriodAdmin, SecCodes, ChainU;

Constructor TEntMenuObj.Create;
Begin
  Inherited Create;
End;

Destructor TEntMenuObj.Destroy;
Begin
  Inherited Destroy;
End;

{ Create tools menu, and insert before the Help menu }
procedure TEntMenuObj.CreateRunAdminOption;
var
  sComponentName : string;
  bAlreadyExists : boolean;
const
  sUDPCaption = '&User Defined Periods';
Begin
  miRunAdmin := nil;

  miUtilities := EnterpriseMenu.Items.Find('&Utilities');
  miSystemSetupMenu := miUtilities.Find('System Setup');
  sComponentName := DLLChain.ModuleName + '_Menu_Run_User_Defined_Periods_Admin';

  miRunAdmin := miSystemSetupMenu.Find(sUDPCaption);
  bAlreadyExists := (miRunAdmin <> nil) and (miRunAdmin.name = sComponentName);

  if ((miSystemSetupMenu = nil) or (miSystemSetupMenu.name <> sComponentName))
  and (not bAlreadyExists) then
  begin
    { Add DLL Module Name to start of control name to provide unique control name }
    miRunAdmin := hNewMenu(sUDPCaption, sComponentName);
    miRunAdmin.AutoHotKeys := maManual;
    miRunAdmin.GroupIndex := 95;
//    miRunAdmin.HelpContext := ?;
    miRunAdmin.Hint := 'Configure the User Defined Periods';
    miRunAdmin.OnClick := EntMenuObj.MenuOpt_RunAdminClick;
    miSystemSetupMenu.Insert(miSystemSetupMenu.Count - 1, miRunAdmin);
  end;{if}
End;
{ Click Event handler for the Tools options menu option }
procedure TEntMenuObj.MenuOpt_RunAdminClick(Sender: TObject);
{Var
  hFaxAdminWin : HWnd;
  bContinue : boolean;}
begin
{  if bContinue then
  begin}
    frmPeriodList := TfrmPeriodList.Create(Application.MainForm);
    With frmPeriodList Do
    begin
      ShowModal;
      Release;
    end;{with}
{  end;{if}
end;

procedure InitToolkit(sPath : string);
var
  a, b, c : LongInt;
  iStatus, iPos : integer;
  CompanyInfo : TCompanyInfo;

begin{InitToolkit}
//  slUsers := TStringList.Create;
  slCompanies := TStringList.Create;

  // Create COM Toolkit object
  oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

  // Check it created OK
  If Assigned(oToolkit) Then Begin

    EncodeOpCode(97, a, b, c);
    oToolkit.Configuration.SetDebugMode(a, b, c);

    oToolkit.Configuration.AutoSetTransCurrencyRates := TRUE;
    For iPos := 1 to oToolkit.Company.cmCount do begin
      CompanyInfo := TCompanyInfo.Create;
      CompanyInfo.CompanyRec.Path := Trim(oToolkit.Company.cmCompany[iPos].coPath);
      CompanyInfo.CompanyRec.Name := Trim(oToolkit.Company.cmCompany[iPos].coName);
      CompanyInfo.CompanyRec.Code := Trim(oToolkit.Company.cmCompany[iPos].coCode);
      slCompanies.AddObject(oToolkit.Company.cmCompany[iPos].coName, CompanyInfo);
    end;{for}

    oToolkit.Configuration.DataDirectory := sPath;
    iStatus := oToolkit.OpenToolkit;
    if iStatus = 0 then
    begin
//      GetAllUsersFromTK;

//      GetAllUsers;
(*      with (oToolkit as IToolkit2).UserProfile do
      begin
        Index := usIdxLogin;
        iStatus := GetFirst;
        while (iStatus = 0) do
        begin
          slUsers.Add(upUserID);
          iStatus := GetNext;
        end;{while}
      end;{with}*)
    end else
    begin
      ShowMessage('oToolkit.OpenToolkit failed with the result : ' + IntToStr(iStatus));
    end;{if}
  End { If Assigned(oToolkit) }
  Else
    // Failed to create COM Object
    ShowMessage('Cannot create COM Toolkit instance');
end;{InitToolkit}

end.


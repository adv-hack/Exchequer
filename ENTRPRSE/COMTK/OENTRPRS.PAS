unit oEntrprs;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


Interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, LicRec,
     ExceptIntf;

type
  TEnterprise = class(TAutoIntfObjectEx, IEnterprise)
  private
  //PR 06/03/06 - FToolkit was specified as IToolkit, causing TEnterprise to hold a reference to
  //the toolkit and not allowing it to be destroyed. Changed to TObject.
    FToolkit : TObject;
    FLicence : EntLicenceRecType;
  protected
    // IEnterprise
    function Get_enRunning: WordBool; safecall;
    function Get_enEnterpriseVersion: WideString; safecall;
    function Get_enAppPath: WideString; safecall;
    function Get_enCompanyPath: WideString; safecall;
    function Get_enUserName: WideString; safecall;
    function Get_enCurrencyVersion: TEnterpriseCurrencyVersion; safecall;
    function Get_enModuleVersion: TEnterpriseModuleVersion; safecall;
    function Get_enClientServer: WordBool; safecall;

    // Local Methods
    procedure InitObjs;
  public
    Constructor Create (Const Toolkit : TObject);
    Destructor Destroy; override;

    Procedure LoadEntLicence;
  End; { TEnterprise }

implementation

uses ComServ, MemMap, VarCnst3, EntLic;

{-------------------------------------------------------------------------------------------------}

Constructor TEnterprise.Create (Const Toolkit : TObject);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IEnterprise);

  InitObjs;
  FillChar(FLicence, SizeOf(FLicence), #0);

  FToolkit := Toolkit;

  // Attempt to load the licence details
  LoadEntLicence;
End; { Create }

{-----------------------------------------}

Destructor TEnterprise.Destroy;
Begin { Destroy }
  InitObjs;

  inherited Destroy;
End; { Destroy }

{-----------------------------------------}

procedure TEnterprise.InitObjs;
begin
  FToolkit := Nil;
end;

{-----------------------------------------}

function TEnterprise.Get_enAppPath: WideString;
begin
  Result := GlobalEntMap.ApplicationPath;
end;

function TEnterprise.Get_enCompanyPath: WideString;
begin
  Result := GlobalEntMap.CompanyDataPath;
end;

function TEnterprise.Get_enCurrencyVersion: TEnterpriseCurrencyVersion;
begin
  // HM 03/03/01: Switched to use licence information where available
  //Result := Ord(GlobalEntMap.CurrencyVersion);
  Result := FLicence.licEntCVer;
end;

function TEnterprise.Get_enEnterpriseVersion: WideString;
begin
  Result := GlobalEntMap.EnterpriseVersion;
end;

function TEnterprise.Get_enRunning: WordBool;
begin
  Result := GlobalEntMap.Defined;
end;

function TEnterprise.Get_enUserName: WideString;
begin
  Result := GlobalEntMap.UserName;
end;

function TEnterprise.Get_enModuleVersion: TEnterpriseModuleVersion;
begin
  Result := FLicence.licEntModVer;
end;

function TEnterprise.Get_enClientServer: WordBool;
begin
  Result := (FLicence.licEntClSvr = 1);
end;

{-----------------------------------------}

// Loads the licence details from the Enterprise directory if available
Procedure TEnterprise.LoadEntLicence;
Begin { LoadEntLicence }
  // Re-initialise licence as can be called multiple times
  FillChar(FLicence, SizeOf(FLicence), #0);

  // Check for licence in Enterprise directory
  If FileExists (ExSyss.BatchPath + EntLicFName) Then
    // load licence
    ReadEntLic (ExSyss.BatchPath + EntLicFName, FLicence);
End; { LoadEntLicence }

{-----------------------------------------}

end.

unit oConfig;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     EnterpriseForms_TLB;

type
  TEFConfiguration = class(TAutoIntfObject, IEFConfiguration)
  private
    FPrintToolkit : TObject;
  protected
    // IConfiguration
    function Get_cfDataDirectory: WideString; safecall;
    procedure Set_cfDataDirectory(const Value: WideString); safecall;
    function Get_cfEnterpriseDirectory: WideString; safecall;
    procedure Set_cfEnterpriseDirectory(const Value: WideString); safecall;
    function Get_cfDeleteTempFiles: WordBool; safecall;
    procedure Set_cfDeleteTempFiles(Value: WordBool); safecall;

    // Local methods
    Procedure Bang(Const BangName : String);
    procedure InitObjs;
  public
    Constructor Create (Const PrintToolkit : TObject);
    Destructor Destroy; override;
  End; { TEFConfiguration }

implementation

uses ComServ,
     oMain,        // Base FormTK object
     Miscfunc,     // Misc FormTK types and routines
     GlobType,     // Form Designer global Types and Var's
     DelTemp,      // Temp File Deletion Routines
     LogUtil;

//-----------------------------------------------------------------------------

Constructor TEFConfiguration.Create (Const PrintToolkit : TObject);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IEFConfiguration);

  InitObjs;

  FPrintToolkit := PrintToolkit;
End; { Create }

//----------------------------------------

Destructor TEFConfiguration.Destroy;
Begin { Destroy }
  InitObjs;

  inherited Destroy;
End; { Destroy }

//-----------------------------------------------------------------------------

procedure TEFConfiguration.InitObjs;
begin
  FPrintToolkit := Nil;
end;

//-----------------------------------------------------------------------------

Procedure TEFConfiguration.Bang(Const BangName : String);
Begin { Bang }
  If ((FPrintToolkit As TEFPrintingToolkit).Status <> tkClosed) Then
    Raise Exception.Create ('PrintToolkit.Configuration.' + BangName + ' cannot be changed whilst the Toolkit is Open');
End; { Bang }

//-----------------------------------------------------------------------------

function TEFConfiguration.Get_cfDataDirectory: WideString;
begin
  Result := SystemInfo.ExDataPath;
end;

procedure TEFConfiguration.Set_cfDataDirectory(const Value: WideString);
Var
  Path, ErrStr : ShortString;
begin
  Bang ('DataDirectory');
  OutputDebug('TEFConfiguration.Set_cfDataDirectory ' + Value);

  // Check the directory
  Path := Value;
  If ValidateDataDirectory (Path, ErrStr) Then
    // Hooray
    SystemInfo.ExDataPath := Path
  Else
    // Whoops
    Raise EValidation.Create (ErrStr);

end;

//----------------------------------------

function TEFConfiguration.Get_cfEnterpriseDirectory: WideString;
begin
  Result := SystemInfo.EnterprisePath;
end;

procedure TEFConfiguration.Set_cfEnterpriseDirectory(const Value: WideString);
Var
  Path, ErrStr : ShortString;
begin
  Bang ('EnterpriseDirectory');

  // Check the directory
  Path := Value;
  If ValidateEnterpriseDirectory (Path, ErrStr) Then
    // Hooray
    SystemInfo.EnterprisePath := Path
  Else
    // Whoops
    Raise EValidation.Create (ErrStr);
end;

//----------------------------------------

function TEFConfiguration.Get_cfDeleteTempFiles: WordBool;
begin
  Result := DelTemp.DeleteOnDestroy;
end;

procedure TEFConfiguration.Set_cfDeleteTempFiles(Value: WordBool);
begin
  DelTemp.DeleteOnDestroy := Value;
end;

//-----------------------------------------------------------------------------

end.

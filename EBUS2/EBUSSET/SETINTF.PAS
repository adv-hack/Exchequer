unit Setintf;

{ prutherford440 09:49 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  Forms;

procedure ShowSetupScreen{(NewApp : TApplication; NewScreen : TScreen)}; stdcall export;

//PR: 11/06/2009 Added new function to allow EntXml.dll to check whether to use BASDA eBIS-XML 3.09 schema 
function UseBasda309 : Boolean; stdcall export;

implementation

uses
  SysSetup, Windows, Classes, Dialogs, SysUtils, Enterprise04_TLB, CtkUtil04, TkUtil, eBusBtrv;

procedure ShowSetupScreen{(NewApp : TApplication; NewScreen : TScreen)};
{  DLLApp : TApplication;
  DLLScreen : TScreen;}
begin
{  DLLApp := Application;
  DLLScreen := Screen;
  Application := NewApp;
  Screen := NewScreen;
  frmSystemSetup := TfrmSystemSetup.Create(Application);
  frmSystemSetup := TfrmSystemSetup.Create(Application.mainform);}

  frmSystemSetup := TfrmSystemSetup.Create(nil);
  with frmSystemSetup do begin
    try
    {$IFDEF EBPWORDS}
      if DoPasswordCheck then
    {$ENDIF}
        ShowModal;
    finally
      Release;
    end;
  end;{with}
{  Application := DLLApp;
  Screen := DLLScreen;}
end;

function UseBasda309 : Boolean;
var
  oToolkit : IToolkit;
  sCompCode : string;

  function GetCompanyPathFromParams : string;
  Var
    n  :  Integer;
  Begin
    Result := '';

    For n:=0 to Pred(ParamCount) do
    Begin
      If UpperCase(ParamStr(n)) = ebRemoteDirSw then
      Begin
        Result:=IncludeTrailingBackslash(ParamStr(n+1));
        Break;
      end;
    end;
  end;

begin
  oToolkit := CreateToolkitWithBackDoor;
  Try
    sCompCode := CompanyCodeFromPath(oToolkit, GetCompanyPathFromParams);
    if sCompCode <> '' then
    with TEBusBtrieveCompany.Create(TRUE) do
    Try
      Openfile;
      CompanyCode := sCompCode;
      if FindRecord = 0 then
      with CompanySettings do
        Result := CompUseBasda309;
      CloseFile;
    Finally
      Free;
    End;
  Finally
    oToolkit := nil;
  End;
end;

end.

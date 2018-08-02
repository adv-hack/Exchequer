unit TESTTK04;

{ prutherford440 09:55 04/12/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Enterprise04_TLB, EnterpriseForms_TLB, Classes, ComObj, ComCtrls, TestLog;

const
  RecordsToRead = 20;
  MaxLicences = 10;


type
  TLicenceArray = Array[1..MaxLicences] of TReleaseCodeStatus;

  TTestExeToolkit = Class
   private
    FToolkit : IToolkit;
    FPrintingToolkitI : IEFPrintingToolkit;
    FReport   : TRichLog;
    FStart, FTime : Cardinal;
    FValidateData : Boolean;
    FDataPath : string;
    FLicenceTest : TLicenceArray;
    function GetTKVersion : string;
   public
    constructor Create;
    destructor Destroy; override;
    property ToolkitVersion : string read GetTKVersion;
  end;

implementation

uses
  SysUtils, Forms, Windows, ActiveX, TestCons, Dialogs, CodeList, SecCodes, Variants, CtkUtil04;


constructor TTestExeToolkit.Create;
var
  a, b, c : longint;
begin
  inherited Create;
  FReport := nil;
  FToolkit := CreateToolkitWithBackDoor as IToolkit2;
  FValidateData := True;
end;

destructor TTestExeToolkit.Destroy;
begin
  FToolkit := nil;
  inherited Destroy;
end;


function TTestExeToolkit.GetTKVersion: string;
begin
  if Assigned(FToolkit) then
    Result := FToolkit.Version
  else
    Result := '';
end;

end.

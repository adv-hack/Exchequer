unit EmailSet;

interface

uses
  Enterprise04_TLB, ComObj, CtkUtil04, classes, SysUtils, activeX;

type

   TEmailSettings = Class
   private
     FToolkit : IToolkit;
     function GetString(const Index: Integer): string;
     function GetDataPath: string;
     procedure SetDataPath(const Value: string);
    function GetUseMapi: Boolean;
    function GetAttachmentType: Byte;
    function GetAttachmentExt : string;
   public
     constructor Create;
     destructor Destroy; override;
     property esSender    : string Index 1 read GetString;
     property esSenderName: string Index 2 read GetString;
     property esSMTPServer: string Index 3 read GetString;
     property esDataPath  : string read GetDataPath write SetDataPath;
     property esUseMapi     : Boolean read GetUseMapi;
     property esAttachmentType : Byte read GetAttachmentType;
     property esAttachmentExt : string read GetAttachmentExt;
   end;


implementation

var
  LEmailSettings : TEmailSettings;

{ TEmailSettings }

constructor TEmailSettings.Create;
begin
  inherited;
  CoInitialize(nil);
  FToolkit := CreateToolkitWithBackDoor;
end;

destructor TEmailSettings.Destroy;
begin
  FToolkit := nil;
  CoUninitialize;
  inherited;
end;

function TEmailSettings.GetAttachmentExt: string;
begin
  if FToolkit.SystemSetup.ssPaperless.ssAttachMethod = 0 then
    Result := '.edf'
  else
    Result := '.pdf';
end;

function TEmailSettings.GetAttachmentType: Byte;
begin
  Result := FToolkit.SystemSetup.ssPaperless.ssAttachMethod;
end;

function TEmailSettings.GetDataPath: string;
begin
  Result := FToolkit.Configuration.DataDirectory;
end;

function TEmailSettings.GetString(const Index: Integer): string;
begin
  Case Index of
    1 : Result := FToolkit.SystemSetup.ssPaperless.ssYourEmailName;
    2 : Result := FToolkit.SystemSetup.ssPaperless.ssYourEmailAddress;
    3 : Result := FToolkit.SystemSetup.ssPaperless.ssSMTPServer;
  end;
end;

function TEmailSettings.GetUseMapi: Boolean;
begin
  Result := FToolkit.SystemSetup.ssPaperless.ssEmailUseMAPI;
end;

procedure TEmailSettings.SetDataPath(const Value: string);
var
  Res : Integer;
begin
  if FToolkit.Status = tkOpen then
    FToolkit.CloseToolkit;
  FToolkit.Configuration.DataDirectory := Value;
  Res := FToolkit.OpenToolkit;
  if Res <> 0 then
    raise Exception.Create('Unable to open toolkit. Error'#10#10 +
                            QuotedStr(FToolkit.LastErrorString));
end;

end.

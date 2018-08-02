unit KPIIniFileClass;

interface

uses IniFiles, SysUtils, Graphics, Windows;

type
  TKPIIniFile = class(TObject)
  private
    FKPIIniFile: TIniFile;
    function  KPIIniFileName: ShortString;
    function  GetDirectValue(ValueName: string; BooleanDefault: boolean = false): string;
    procedure PutDirectValue(ValueName, ValueData: string);
    function  SettingsSection: string;
    function  GetIRISBannerOnTop: boolean;
    procedure SetIRISBannerOnTop(const Value: boolean);
    function  YesOrNo(ABoolean: boolean): string;
    function  GetImageFileName(ImageNo: integer): shortstring;
    procedure SetImageFileName(ImageNo: integer; const Value: shortstring);
    function  GetImageValue(ImageNo: integer; ValueName: string): string;
    function  ImageValuePrefix(ImageNo: integer): string;
    procedure PutImageValue(ImageNo: integer; ValueName,ValueData: string);
    function  GetAllowOverlap: boolean;
    function  GetBackgroundColor: TColor;
    function  GetImageAutoSize(ImageNo: integer): boolean;
    function  GetImageCenter(ImageNo: integer): boolean;
    function  GetImageStretch(ImageNo: integer): boolean;
    function  GetImageTransparent(ImageNo: integer): boolean;
    procedure SetAllowOverlap(const Value: boolean);
    procedure SetBackgroundColor(const Value: TColor);
    procedure SetImageAutoSize(ImageNo: integer; const Value: boolean);
    procedure SetImageCenter(ImageNo: integer; const Value: boolean);
    procedure SetImageStretch(ImageNo: integer; const Value: boolean);
    procedure SetImageTransparent(ImageNo: integer; const Value: boolean);
    function  GetShowCustomBanner: boolean;
    procedure SetShowCustomBanner(const Value: boolean);
    function  GetShowImage(ImageNo: integer): boolean;
    procedure SetShowImage(ImageNo: integer; const Value: boolean);
    function  GetReplicateLeft: boolean;
    function  GetReplicateLeftIntoCenter: boolean;
    function  GetReplicateLeftIntoRight: boolean;
    function  GetReplicateRightmostPixels: integer;
    procedure SetReplicateLeft(const Value: boolean);
    procedure SetReplicateLeftIntoCenter(const Value: boolean);
    procedure SetReplicateLeftIntoRight(const Value: boolean);
    procedure SetReplicateRightmostPixels(const Value: integer);
  public
    constructor Create;
    destructor  Destroy; override;
    procedure UpdateFile;
    property  IRISBannerOnTop:                    boolean     read GetIRISBannerOnTop  write SetIRISBannerOnTop;
    property  AllowOverlap:                       boolean     read GetAllowOverlap     write SetAllowOverlap;
    property  BackgroundColor:                    TColor      read GetBackgroundColor  write SetBackgroundColor;
    property  ShowCustomBanner:                   boolean     read GetShowCustomBanner write SetShowCustomBanner;
    property  ImageFileName[ImageNo: integer]:    shortstring read GetImageFileName    write SetImageFileName;
    property  ImageStretch[ImageNo: integer]:     boolean     read GetImageStretch     write SetImageStretch;
    property  ImageAutoSize[ImageNo: integer]:    boolean     read GetImageAutoSize    write SetImageAutoSize;
    property  ImageTransparent[ImageNo: integer]: boolean     read GetImageTransparent write SetImageTransparent;
    property  ImageCenter[ImageNo: integer]:      boolean     read GetImageCenter      write SetImageCenter;
    property  ShowImage[ImageNo: integer]:        boolean     read GetShowImage        write SetShowImage;
    property  ReplicateLeft:                      boolean     read GetReplicateLeft    write SetReplicateLeft;
    property  ReplicateLeftIntoCenter:            boolean     read GetReplicateLeftIntoCenter      write SetReplicateLeftIntoCenter;
    property  ReplicateLeftIntoRight:             boolean     read GetReplicateLeftIntoRight       write SetReplicateLeftIntoRight;
    property  ReplicateRightmostPixels:           integer     read GetReplicateRightmostPixels     write SetReplicateRightmostPixels;
  end;

implementation

uses VAOUtil, dialogs;

{ TKPIIniFile }

constructor TKPIIniFile.Create;
begin
  inherited Create;
  FKPIIniFile := TIniFile.Create(KPIIniFileName);
//  ShowMessage('KPI INI: ' + KPIIniFileName); // *** TEST ONLY ***
end;

destructor TKPIIniFile.Destroy;
begin
  if assigned(FKPIIniFile) then FKPIIniFile.Free;
  inherited Destroy;
end;

function TKPIIniFile.KPIIniFileName: ShortString;
begin
  result := IncludeTrailingPathDelimiter(VAOInfo.vaoAppsDir) + 'KPI\KPI.ini';
end;

function TKPIIniFile.SettingsSection: string;
begin
  result := 'CustomBanner';
end;

function TKPIIniFile.GetDirectValue(ValueName: string; BooleanDefault: boolean = false): string;
begin
  result := FKPIIniFile.ReadString(SettingsSection, ValueName, '');
  if BooleanDefault and (result = '') then
    result := 'Yes';
end;

procedure TKPIIniFile.PutDirectValue(ValueName: string; ValueData: string);
begin
  FKPIIniFile.WriteString(SettingsSection, ValueName, ValueData);
end;

function TKPIIniFile.ImageValuePrefix(ImageNo: integer): string;
begin
  result := 'Image' + IntToStr(ImageNo);
end;

function TKPIIniFile.GetImageValue(ImageNo: integer; ValueName: string): string;
begin
  result := FKPIIniFile.ReadString(SettingsSection, ImageValuePrefix(ImageNo) + ValueName, '');
end;

procedure TKPIIniFile.PutImageValue(ImageNo: integer; ValueName: string; ValueData: string);
begin
  FKPIIniFile.WriteString(SettingsSection, ImageValuePrefix(ImageNo) + ValueName, ValueData);
end;

function TKPIIniFile.YesOrNo(ABoolean: boolean): string;
const
  YesNo: array[false..true] of string = ('No', 'Yes');
begin
  result := YesNo[ABoolean];
end;

function TKPIIniFile.GetIRISBannerOnTop: boolean;
begin
  result := GetDirectValue('IRISBannerOnTop', true) = YesOrNo(true);
end;

procedure TKPIIniFile.SetIRISBannerOnTop(const Value: boolean);
begin
  PutDirectValue('IRISBannerOnTop', YesOrNo(Value));
end;

function TKPIIniFile.GetImageFileName(ImageNo: integer): shortstring;
begin
  result := GetImageValue(ImageNo, 'Filename');
end;

procedure TKPIIniFile.SetImageFileName(ImageNo: integer; const Value: shortstring);
begin
  PutImageValue(ImageNo, 'Filename', Value);
end;

function TKPIIniFile.GetAllowOverlap: boolean;
begin
  result := GetDirectValue('AllowOverlap') = YesOrNo(true);
end;

function TKPIIniFile.GetBackgroundColor: TColor;
var
//  LColor: Longint;
  sColor: string;
begin
{  if IdentToColor(GetDirectValue('BackgroundColor'), LColor) then
    result := TColor(LColor)
  else begin
    IdentToColor('clSilver', LColor);
    result := TColor(LColor);
  end;}
  sColor := GetDirectValue('BackgroundColor');
  if sColor = '' then sColor := 'C0C0C0'; // clSilver
  Result := RGB(StrToInt('$'+Copy(sColor, 1, 2)), StrToInt('$'+Copy(sColor, 3, 2)), StrToInt('$'+Copy(sColor, 5, 2)) ) ;
end;

function TKPIIniFile.GetImageAutoSize(ImageNo: integer): boolean;
begin
  result := GetImageValue(ImageNo, 'AutoSize') = YesOrNo(true);
end;

function TKPIIniFile.GetImageCenter(ImageNo: integer): boolean;
begin
  result := GetImageValue(ImageNo, 'Center') = YesOrNo(true);
end;

function TKPIIniFile.GetImageStretch(ImageNo: integer): boolean;
begin
  result := GetImageValue(ImageNo, 'Stretch') = YesOrNo(true);
end;

function TKPIIniFile.GetImageTransparent(ImageNo: integer): boolean;
begin
  result := GetImageValue(ImageNo, 'Transparent') = YesOrNo(true);
end;

procedure TKPIIniFile.SetAllowOverlap(const Value: boolean);
begin
  PutDirectValue('AllowOverlap', YesOrNo(Value));
end;

procedure TKPIIniFile.SetBackgroundColor(const Value: TColor);
//var
//  LIdent: string;
begin
//  ColorToIdent(integer(Value), LIdent);
//  PutDirectValue('BackgroundColor', LIdent);
  PutDirectValue('BackgroundColor', IntToHex(GetRValue(Value), 2) + IntToHex(GetGValue(Value), 2) + IntToHex(GetBValue(Value), 2));
end;

procedure TKPIIniFile.SetImageAutoSize(ImageNo: integer; const Value: boolean);
begin
  PutImageValue(ImageNo, 'AutoSize', YesOrNo(Value));
end;

procedure TKPIIniFile.SetImageCenter(ImageNo: integer; const Value: boolean);
begin
  PutImageValue(ImageNo, 'Center', YesOrNo(Value));
end;

procedure TKPIIniFile.SetImageStretch(ImageNo: integer; const Value: boolean);
begin
  PutImageValue(ImageNo, 'Stretch', YesOrNo(Value));
end;

procedure TKPIIniFile.SetImageTransparent(ImageNo: integer; const Value: boolean);
begin
  PutImageValue(ImageNo, 'Transparent', YesOrNo(Value));
end;

function TKPIIniFile.GetShowCustomBanner: boolean;
begin
  result := GetDirectValue('ShowCustomBanner') = YesOrNo(true);
end;

procedure TKPIIniFile.SetShowCustomBanner(const Value: boolean);
begin
  PutDirectValue('ShowCustomBanner', YesOrNo(Value));
end;

function TKPIIniFile.GetShowImage(ImageNo: integer): boolean;
begin
  result := GetImageValue(ImageNo, 'Show') = YesOrNo(true);
end;

procedure TKPIIniFile.SetShowImage(ImageNo: integer; const Value: boolean);
begin
  PutImageValue(ImageNo, 'Show', YesOrNo(Value));
end;

procedure TKPIIniFile.UpdateFile;
begin
  FKPIIniFile.UpdateFile;
end;

function TKPIIniFile.GetReplicateLeft: boolean;
begin
  result := GetDirectValue('ReplicateLeft') = YesOrNo(true);
end;

function TKPIIniFile.GetReplicateLeftIntoCenter: boolean;
begin
  result := GetDirectValue('ReplicateLeftIntoCenter', True) = YesOrNo(true);
end;

function TKPIIniFile.GetReplicateLeftIntoRight: boolean;
begin
  result := GetDirectValue('ReplicateLeftIntoRight') = YesOrNo(true);
end;

function TKPIIniFile.GetReplicateRightmostPixels: integer;
begin
  result := StrToIntDef(GetDirectValue('ReplicateRightmostPixels'), 1);
end;

procedure TKPIIniFile.SetReplicateLeft(const Value: boolean);
begin
  PutDirectValue('ReplicateLeft', YesOrNo(Value));
end;

procedure TKPIIniFile.SetReplicateLeftIntoCenter(const Value: boolean);
begin
  PutDirectValue('ReplicateLeftIntoCenter', YesOrNo(Value));
end;

procedure TKPIIniFile.SetReplicateLeftIntoRight(const Value: boolean);
begin
  PutDirectValue('ReplicateLeftIntoRight', YesOrNo(Value));
end;

procedure TKPIIniFile.SetReplicateRightmostPixels(const Value: integer);
begin
  PutDirectValue('ReplicateRightmostPixels', IntToStr(Value));
end;

end.

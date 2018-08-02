{*********************************************************}
{*                   ADPROPED.PAS 4.03                   *}
{*      Copyright (c) TurboPower Software 1996-2002      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,F+}

unit Adproped;
  {Property/Component Editors}

interface

uses
  Classes,
  Controls,
{$IFDEF Delphi6}
  DesignIntf,
  DesignEditors,
{$ELSE}
  DsgnIntf,
{$ENDIF}
  Forms,
  ooMisc,
  AdAbout;

procedure Register;

type
  TApdPacketStringProperty = class(TStringProperty)
  public
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;

  TApdPacketEditor = class(TDefaultEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TApdVoipAudioVideoEditor = class (TDefaultEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TApdVersionProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

 TApdValidEnumProperty = class(TEnumProperty)
  public
    function  GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TApdStateEditor = class(TDefaultEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TApdGenericFileNameProperty = class(TStringProperty)
  protected
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TApdAPFFileNameProperty = class(TApdGenericFileNameProperty)
  end;
  TApdConverterNameProperty = class(TApdGenericFileNameProperty)
  end;
  TApdLogNameProperty = class(TApdGenericFileNameProperty)
  end;
  TApdTraceNameProperty = class(TApdGenericFileNameProperty)
  end;
  TApdHistoryNameProperty = class(TApdGenericFileNameProperty)
  end;
  TApdCaptureNameProperty = class(TApdGenericFileNameProperty)
  end;
  TApdAPJNameProperty = class(TApdGenericFileNameProperty)
  end;
  TApdFaxCoverNameProperty = class(TApdGenericFileNameProperty)
  end;

  TApdDirectoryProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  { Voip Properties }
  TApdVoipAudioVideoProperty = class (TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

implementation

uses
  SysUtils,
  WinTypes,
  WinProcs,
  Dialogs,
  TypInfo,
  FileCtrl,
  AdFax,
  AdFaxCtl,
  AdFaxCvt,
  AdFaxPrn,
  AdFaxSrv,
  AdFtp,
  AdFView,
  AdMdm,
  AdPort,
  AdPEdit0,
  AdPacket,
  AdPackEd,
  AdPager,
  AdProtcl,
  AdScript,
  AdStatLt,
  AdStMach,
  AdStatEd,
  AdTapi,
  AdTrmEmu,
  AdVoip,
  AdVoipEd;

procedure Register;
begin
  { register our Version property editors }
  RegisterPropertyEditor(TypeInfo(string), TApdBaseComponent,
            'Version', TApdVersionProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdBaseWinControl,
            'Version', TApdVersionProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdBaseOleControl,
            'Version', TApdVersionProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdBaseGraphicControl,
            'Version', TApdVersionProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdBaseScrollingWinControl,
            'Version', TApdVersionProperty);

  { property editors for the TApdCustomComPort }
  RegisterPropertyEditor(TypeInfo(TBaudRate), TApdCustomComPort,
                         'Baud', TBaudRateProperty);
  RegisterPropertyEditor(TypeInfo(TDeviceLayer), TApdCustomComPort,
                         'DeviceLayer', TApdValidEnumProperty);

  { property editors for the TApdDataPacket and TApdCustomState }
  RegisterPropertyEditor(TypeInfo(string), TApdDataPacket,
                         'StartString', TApdPacketStringProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdDataPacket,
                         'EndString', TApdPacketStringProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdCustomState,
                         'OutputOnActivate', TApdPacketStringProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdCustomModemPager,         {!!.01}
                         'ModemHangup', TApdPacketStringProperty);       {!!.01}
  RegisterPropertyEditor(TypeInfo(string), TApdCustomModemPager,         {!!.01}
                         'ModemInit', TApdPacketStringProperty);         {!!.01}

  { Property editors for the TApdVoip }
  RegisterPropertyEditor (TypeInfo (string), TApdCustomVoip,
                          'AudioInDevice', TApdVoipAudioVideoProperty);
  RegisterPropertyEditor (TypeInfo (string), TApdCustomVoip,
                          'AudioOutDevice', TApdVoipAudioVideoProperty);
  RegisterPropertyEditor (TypeInfo (string), TApdCustomVoip,
                          'VideoInDevice', TApdVoipAudioVideoProperty);
  RegisterPropertyEditor (TypeInfo (string), TApdCustomVoip,
                          'VideoOutDevice', TApdVoipAudioVideoProperty);

  { property editors for file properties }
  RegisterPropertyEditor(TypeInfo(ShortString), TApdCustomComPort,
                         'LogName', TApdLogNameProperty);
  RegisterPropertyEditor(TypeInfo(ShortString), TApdCustomComPort,
                         'TraceName', TApdTraceNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdFTPLog,
                         'FTPHistoryName', TApdGenericFileNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdCustomScript,
                         'ScriptFile', TApdGenericFileNameProperty);
  RegisterPropertyEditor(TypeInfo(TFileName), TApdCustomProtocol,
                         'FileMask', TApdGenericFileNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdCustomProtocol,
                         'FileName', TApdGenericFileNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdProtocolLog,
                         'HistoryName', TApdHistoryNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdPagerLog,
                         'HistoryName', TApdHistoryNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TAdCustomTerminal,
                         'CaptureFile', TApdCaptureNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdTapiLog,
                         'TapiHistoryName', TApdHistoryNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdCustomFaxConverter,
                         'DocumentFile', TApdConverterNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdCustomFaxConverter,
                         'OutFileName', TApdAPFFileNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdCustomFaxUnpacker,
                         'InFileName', TApdAPFFileNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdCustomFaxUnpacker,
                         'OutFileName', TApdGenericFileNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdCustomFaxViewer,
                         'FileName', TApdAPFFileNameProperty);
  RegisterPropertyEditor(TypeInfo(ShortString), TApdCustomAbstractFax,
                         'FaxFile', TApdAPFFileNameProperty);
  RegisterPropertyEditor(TypeInfo(ShortString), TApdCustomSendFax,
                         'CoverFile', TApdFaxCoverNameProperty);
  RegisterPropertyEditor(TypeInfo(ShortString), TApdFaxLog,
                         'FaxHistoryName', TApdHistoryNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdCustomFaxPrinter,
                         'FileName', TApdAPFFileNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdCustomFaxPrinterLog,
                         'LogFileName', TApdHistoryNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdFaxDriverInterface,
                         'FileName', TApdAPFFileNameProperty);
  RegisterPropertyEditor(TypeInfo(ShortString), TApdFaxClient,
                         'CoverFileName', TApdGenericFileNameProperty);
  RegisterPropertyEditor(TypeInfo(ShortString), TApdFaxClient,
                         'FaxFileName', TApdAPFFileNameProperty);
  RegisterPropertyEditor(TypeInfo(ShortString), TApdFaxClient,
                         'JobFileName', TApdAPJNameProperty);

  { property editors for directory properties }
  RegisterPropertyEditor(TypeInfo(string), TAdCustomModem,
                         'ModemCapFolder', TApdDirectoryProperty);
  RegisterPropertyEditor(TypeInfo(string), TApdCustomProtocol,
                         'DestinationDirectory', TApdDirectoryProperty);
  RegisterPropertyEditor(TypeInfo(ShortString), TApdCustomReceiveFax,
                         'DestinationDir', TApdDirectoryProperty);
  RegisterPropertyEditor(TypeInfo(ShortString), TApdCustomFaxServer,
                         'DestinationDir', TApdDirectoryProperty);
  RegisterPropertyEditor(TypeInfo(ShortString), TApdFaxServerManager,
                         'MonitorDir', TApdDirectoryProperty);

  { component editors }
  RegisterComponentEditor(TApdDataPacket, TApdPacketEditor);
  RegisterComponentEditor(TApdCustomState, TApdStateEditor);
  RegisterComponentEditor(TApdCustomVoip, TapdVoipAudioVideoEditor); 
end;

function TApdValidEnumProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList];
end;

procedure TApdValidEnumProperty.GetValues(Proc: TGetStrProc);
var
  I : Integer;
  EnumType : PTypeInfo;
  SaveValue : string;
begin
  EnumType := GetPropType;
  SaveValue := Value;
  with GetTypeData(EnumType)^ do begin
    for I := MinValue to MaxValue do begin
      Value := GetEnumName(EnumType, I);
      if GetEnumValue(EnumType, Value) = I then Proc(Value);
    end;
  end;
  Value := SaveValue;
end;

function TApdPacketStringProperty.GetValue: string;
begin
  Result := StrToCtrlStr(inherited GetValue);
end;

procedure TApdPacketStringProperty.SetValue(const Value: string);
begin
  inherited SetValue(CtrlStrToStr(Value));
end;

{*** TApdPacketEditor ***}

procedure TApdPacketEditor.ExecuteVerb(Index: Integer);
begin
  if EditPacket(Component as TApdDataPacket,Component.Name) then
    Designer.Modified;
end;

function TApdPacketEditor.GetVerb(Index: Integer): string;
begin
  Result := 'Edit properties...';
end;

function TApdPacketEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

{*** TApdVersionProperty ***}

function TApdVersionProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

procedure TApdVersionProperty.Edit;
begin
  with TApdAboutForm.Create(Application) do begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

{*** TApdStateEditor ***}

procedure TApdStateEditor.ExecuteVerb(Index: Integer);
begin
  if EditState(Component as TApdCustomState,Component.Name) then
    Designer.Modified;
end;

function TApdStateEditor.GetVerb(Index: Integer): string;
begin
  Result := 'Edit conditions...';
end;

function TApdStateEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

{*** TApdGenericFileNameProperty ***}

function TApdGenericFileNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TApdGenericFileNameProperty.Edit;
const
  ApdRegAPFFilter = 'Fax files (*.APF)|*.APF';
  ApdRegConverterFilter = 'Bitmap files (*.BMP)|*.BMP|TIFF Files (*.TIF)|*.TIF|'
                    + 'PCX files (*.PCX)|*.PCX|Text files (*.TXT)|*.TXT)';
  ApdRegLogFilter = 'Log files (*.LOG)|*.LOG';
  ApdRegTraceFilter = 'Trace files (*.TRC)|*.TRC';
  ApdRegHistoryFilter = 'History files (*.HIS)|*.HIS';
  ApdRegCaptureFilter = 'Capture files (*.CAP)|*.CAP';
  ApdRegAPJFilter = 'Fax job files (*.APJ)|*.APJ';
  ApdRegFaxCoverFilter = ApdRegAPFFilter + '|Text files (*.TXT)|*.TXT';
  ApdRegDefFilter = 'All files (*.*)|*.*';
var
  Dlg : TOpenDialog;
  Filter : string;
begin
  Filter := '';
  if Self is TApdAPFFileNameProperty then
    Filter := ApdRegAPFFilter
  else if Self is TApdConverterNameProperty then
    Filter := ApdRegConverterFilter
  else if Self is TApdLogNameProperty then
    Filter := ApdRegLogFilter
  else if Self is TApdTraceNameProperty then
    Filter := ApdRegTraceFilter
  else if Self is TApdHistoryNameProperty then
    Filter := ApdRegHistoryFilter
  else if Self is TApdCaptureNameProperty then
    Filter := ApdRegCaptureFilter
  else if Self is TApdAPJNameProperty then
    Filter := ApdRegAPJFilter
  else if Self is TApdFaxCoverNameProperty then
    Filter := ApdRegFaxCoverFilter;

  if Filter = '' then
    Filter := ApdRegDefFilter
  else
    Filter := Filter + '|' + ApdRegDefFilter;

  Dlg := TOpenDialog.Create(Application);
  try
    Dlg.DefaultExt := '*.*';
    Dlg.Filter := Filter;
    Dlg.FilterIndex := 0;
    Dlg.Options := [ofHideReadOnly];
    Dlg.FileName := Value;
    if Dlg.Execute then
      Value := Dlg.FileName;
  finally
    Dlg.Free;
  end;
end;

{ TApdDirectoryProperty }
function TApdDirectoryProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TApdDirectoryProperty.Edit;
var
  Dir : string;
begin
  Dir := Value;
  if SelectDirectory(Dir, [sdAllowCreate], 0) then
    Value := Dir;
end;

procedure TApdVoipAudioVideoEditor.ExecuteVerb(Index: Integer);
begin
  if EditVoipAudioVideo (Component as TApdVoip, Component.Name) then
    Designer.Modified;
end;

function TApdVoipAudioVideoEditor.GetVerb(Index: Integer): string;
begin
  Result := 'Edit properties...';
end;

function TApdVoipAudioVideoEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

function TApdVoipAudioVideoProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TApdVoipAudioVideoProperty.Edit;
var
  VoipComponent : TApdVoip;
  CompName : string;
begin
  VoipComponent := GetComponent (0) as TApdVoip;
  CompName := VoipComponent.Name;
  if PropCount > 1 then
    CompName := CompName + '...';
  if EditVoipAudioVideo (VoipComponent, CompName) then begin
//    Modified;
  end;
end;

end.

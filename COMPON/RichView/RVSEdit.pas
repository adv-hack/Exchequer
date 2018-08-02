
{*******************************************************}
{                                                       }
{       RichView                                        }
{       Design-time support.                            }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVSEdit;

interface
{$I RV_Defs.inc}
uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  {$IFDEF RICHVIEWDEF6}
  DesignIntf, DesignEditors, ColnEdit, VCLEditors,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
  {$IFNDEF RVDONOTUSEDOCPARAMS}
  RVDocParams,
  {$ENDIF}
  TypInfo, ShellApi, Graphics,
  RVStyle, RichView, RVEdit, RVCodePages, RVReport, Dialogs;
{$IFDEF RICHVIEWCBDEF3}
type
{$IFDEF RICHVIEWDEF6}
  TRVComponentEditor = TDefaultEditor;
{$ELSE}
  TRVComponentEditor = TComponentEditor;
{$ENDIF}
  {----------------------------------------------------------}
  TRVSEditor = class(TRVComponentEditor)
  private
    {$IFNDEF RVDONOTUSEINI}
    procedure LoadStylesFromINIFile;
    procedure SaveStylesToINIFile;
    {$ENDIF}
  protected
    {$IFDEF RICHVIEWDEF6}
    VerbIndex: Integer;
    procedure EditProperty(const PropertyEditor: IProperty;
      var Continue: Boolean);override;
  private
    {$ELSE}
    FContinue : Boolean;
    procedure CheckEditF(PropertyEditor: TPropertyEditor);
    procedure CheckEditP(PropertyEditor: TPropertyEditor);
    procedure CheckEditL(PropertyEditor: TPropertyEditor);
    {$IFNDEF RVDONOTUSESTYLETEMPLATES}
    procedure CheckEditS(PropertyEditor: TPropertyEditor);
    {$ENDIF}
    {$ENDIF}
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TRVEEditor = class(TRVComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TRVCodePageProperty = class(TIntegerProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

  {$IFDEF RICHVIEWDEF5}
  TRVGetUnitNameFunc = function (Obj: TPersistent): String;

  TRVStyleLengthProperty = class(TIntegerProperty
    {$IFDEF RICHVIEWDEF6}, ICustomPropertyDrawing{$ENDIF})
  protected
    function GetUnits: String;
    function GetUnitName(Obj: TPersistent): String; dynamic;
  public
    {$IFDEF RICHVIEWDEF6}
    procedure PropDrawName(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean);
    {$ENDIF}
    procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean); {$IFNDEF RICHVIEWDEF6}override;{$ENDIF}
  end;

  TRVLineSpacingValueProperty = class (TRVStyleLengthProperty)
  protected
    function GetUnitName(Obj: TPersistent): String; override;
  end;

  {$IFNDEF RVDONOTUSEDOCPARAMS}
  TRVLengthProperty = class(TFloatProperty
    {$IFDEF RICHVIEWDEF6}, ICustomPropertyDrawing{$ENDIF})
  protected
    function GetUnits: String;
    function GetUnitName(Obj: TPersistent): String; dynamic;
  public
    {$IFDEF RICHVIEWDEF6}
    procedure PropDrawName(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean);
    {$ENDIF}
    procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean); {$IFNDEF RICHVIEWDEF6}override;{$ENDIF}
  end;
  {$ENDIF}
  {$ENDIF}

  {$IFNDEF RVDONOTUSESTYLETEMPLATES}
  TRVStyleTemplateIdProperty = class(TIntegerProperty)
  private
    function GetCollection: TRVStyleTemplateCollection;
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: string); override;
  end;

  {$IFDEF RICHVIEWDEF6}
  TRVStyleTemplateCollectionProperty = class(TCollectionProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
  end;
  {$ENDIF}

  TRVStyleTemplateNameProperty = class (TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;
  {$ENDIF}

  procedure Register;

  {$IFDEF RICHVIEWDEF5}
  var
  RVGetUnitNameFunc: TRVGetUnitNameFunc = nil;
  {$IFNDEF RVDONOTUSEDOCPARAMS}
  RVGetRVUnitNameFunc: TRVGetUnitNameFunc = nil;
  function GetRVUnitsName(Units: TRVUnits): String;
  {$ENDIF}
  {$ENDIF}

{$ENDIF}
implementation
uses RVDsgn;
{$IFDEF RICHVIEWCBDEF3}
const
  CMD_TEXTSTYLES = 0;
  CMD_PARASTYLES = 1;
  CMD_LISTSTYLES = 2;
  CMD_SEPAFTERSTYLES = 3;
  CMD_CONVERT = 4;
  CMD_SEPAFTERCONVERT = 5;
  {$IFNDEF RVDONOTUSEINI}
   CMD_SAVEINI = 6;
   CMD_LOADINI = 7;
   CMD_SEPAFTERINI = 8;
   {$IFNDEF RVDONOTUSESTYLETEMPLATES}
    CMD_STYLETEMPLATES = 9;
    CMD_SEPAFTERTEMPL  = 10;
    CMD_WEB = 11;
   {$ELSE}
    CMD_WEB = 9;
   {$ENDIF}
  {$ELSE}
   {$IFNDEF RVDONOTUSESTYLETEMPLATES}
    CMD_STYLETEMPLATES = 6;
    CMD_SEPAFTERTEMPL  = 7;
    CMD_WEB = 8;
   {$ELSE}
   CMD_WEB = 6;
   {$ENDIF}
  {$ENDIF}
{-----------------------------------------------------------------------}
function TRVSEditor.GetVerbCount: Integer;
begin
  Result := CMD_WEB+1;
end;
{-----------------------------------------------------------------------}
function TRVSEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    CMD_TEXTSTYLES:
      Result := 'Edit Text Styles';
    CMD_PARASTYLES:
      Result := 'Edit Paragraph Styles';
    CMD_LISTSTYLES:
      Result := 'Edit List Styles';
    CMD_SEPAFTERSTYLES, CMD_SEPAFTERCONVERT:
      Result := '-';
    CMD_CONVERT:
      if TRVStyle(Component).Units=rvstuPixels then
        Result := 'Convert Lengths to Twips'
      else
        Result := 'Convert Lengths to Pixels';
    {$IFNDEF RVDONOTUSEINI}
    CMD_SAVEINI:
      Result := 'Save Styles to INI File...';
    CMD_LOADINI:
      Result := 'Load Styles from INI File...';
    CMD_SEPAFTERINI:
      Result := '-';
    {$ENDIF}
    {$IFNDEF RVDONOTUSESTYLETEMPLATES}
    CMD_STYLETEMPLATES:
      Result := 'Edit Style Templates';
    CMD_SEPAFTERTEMPL:
      Result := '-';
    {$ENDIF}
    CMD_WEB:
      {$IFDEF RVDEBUG}
      Result := 'Register TRichView Online';
      {$ELSE}
      Result := 'TRichView Homepage';
      {$ENDIF}
    else
      Result := '';
  end;
end;
{-----------------------------------------------------------------------}
procedure TRVSEditor.ExecuteVerb(Index: Integer);
{$IFNDEF RICHVIEWDEF6}
var
{$IFDEF RICHVIEWDEF5}
  Components: TDesignerSelectionList;
{$ELSE}
  Components: TComponentList;
{$ENDIF}
{$ENDIF}
begin
  if Index>CMD_WEB then
    exit;
  case Index of
    {$IFNDEF RVDONOTUSEINI}
    CMD_SAVEINI:
      begin
        SaveStylesToINIFile;
        exit;
      end;
    CMD_LOADINI:
      begin
        LoadStylesFromINIFile;
        exit;
      end;
    {$ENDIF}
    CMD_CONVERT:
      begin
        if TRVStyle(Component).Units=rvstuPixels then
          TRVStyle(Component).ConvertToTwips
        else
          TRVStyle(Component).ConvertToPixels;
        Designer.Modified;
      end;
    CMD_WEB:
      begin
        {$IFDEF RVDEBUG}
        ShellExecute(0, 'open', 'http://www.trichview.com/order/', nil, nil, SW_NORMAL);
        {$ELSE}
        ShellExecute(0, 'open', 'http://www.trichview.com', nil, nil, SW_NORMAL);
        {$ENDIF}
        exit;
      end;
  end;
  {$IFDEF RICHVIEWDEF6}
  VerbIndex := Index;
  Edit;
  {$ELSE}
  {$IFDEF RICHVIEWDEF5}
  Components := TDesignerSelectionList.Create;
  {$ELSE}
  Components := TComponentList.Create;
  {$ENDIF}
  try
    FContinue := True;
    Components.Add(Component);
    case Index of
     CMD_TEXTSTYLES:
      GetComponentProperties(Components, tkAny, Designer, CheckEditF);
     CMD_PARASTYLES:
      GetComponentProperties(Components, tkAny, Designer, CheckEditP);
     CMD_LISTSTYLES:
      GetComponentProperties(Components, tkAny, Designer, CheckEditL);
     {$IFNDEF RVDONOTUSESTYLETEMPLATES}
     CMD_STYLETEMPLATES:
      GetComponentProperties(Components, tkAny, Designer, CheckEditS);
     {$ENDIF}
    end;
  finally
    Components.Free;
  end;
  {$ENDIF}
end;
{-----------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
procedure TRVSEditor.LoadStylesFromINIFile;
var
  odStylesINI: TOpenDialog;
begin
  odStylesINI := TOpenDialog.Create(TRVStyle(Component));
  try
    odStylesINI.DefaultExt := '.ini';
    odStylesINI.Options := odStylesINI.Options+[ofFileMustExist];
    odStylesINI.Filter := 'INI Files (*.ini)|*.ini|All Files (*.*)|*.*';
    if odStylesINI.Execute then
      TRVStyle(Component).LoadINI(odStylesINI.FileName,'Style');
  finally
    OdStylesINI.Free;
  end;
end;
{-----------------------------------------------------------------------}
procedure TRVSEditor.SaveStylesToINIFile;
var
  sdStylesINI: TSaveDialog;
begin
  sdStylesINI := TSaveDialog.Create(TRVStyle(Component));
  try
    sdStylesINI.DefaultExt := '.ini';
    sdStylesINI.Options := sdStylesINI.Options+[ofOverwritePrompt];
    sdStylesINI.Filter := 'INI files (*.ini)|*.ini|All files (*.*)|*.*';
    if sdStylesINI.Execute then
      TRVStyle(Component).SaveINI(sdStylesINI.FileName,'Style');
  finally
    sdStylesINI.Free;
  end;
end;
{$ENDIF}
{-----------------------------------------------------------------------}
{$IFDEF RICHVIEWDEF6}
procedure TRVSEditor.EditProperty(const PropertyEditor: IProperty;
                      var Continue: Boolean);
var
  PropName: string;
begin
  PropName := PropertyEditor.GetName;
  if ((VerbIndex=CMD_TEXTSTYLES) and (CompareText(PropertyEditor.GetName, 'TextStyles')=0)) or
     ((VerbIndex=CMD_PARASTYLES) and (CompareText(PropertyEditor.GetName, 'ParaStyles')=0)) or
     ((VerbIndex=CMD_LISTSTYLES) and (CompareText(PropertyEditor.GetName, 'ListStyles')=0))
     {$IFNDEF RVDONOTUSESTYLETEMPLATES}
     or
     ((VerbIndex=CMD_STYLETEMPLATES) and (CompareText(PropertyEditor.GetName, 'StyleTemplates')=0))
     {$ENDIF}
     then
  begin
    PropertyEditor.Edit;
    Continue := False;
    VerbIndex := 0;
  end;
end;
{-----------------------------------------------------------------------}
{$ELSE}
procedure TRVSEditor.CheckEditF(PropertyEditor: TPropertyEditor);
begin
  try
    if FContinue and (CompareText(PropertyEditor.GetName, 'TextStyles') = 0) then
    begin
      PropertyEditor.Edit;
      FContinue := False;
    end;
  finally
    PropertyEditor.Free;
  end;
end;
{-----------------------------------------------------------------------}
procedure TRVSEditor.CheckEditP(PropertyEditor: TPropertyEditor);
begin
  try
    if FContinue and (CompareText(PropertyEditor.GetName, 'ParaStyles') = 0) then
    begin
      PropertyEditor.Edit;
      FContinue := False;
    end;
  finally
    PropertyEditor.Free;
  end;
end;
{-----------------------------------------------------------------------}
procedure TRVSEditor.CheckEditL(PropertyEditor: TPropertyEditor);
begin
  try
    if FContinue and (CompareText(PropertyEditor.GetName, 'ListStyles') = 0) then
    begin
      PropertyEditor.Edit;
      FContinue := False;
    end;
  finally
    PropertyEditor.Free;
  end;
end;
{-----------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESTYLETEMPLATES}
procedure TRVSEditor.CheckEditS(PropertyEditor: TPropertyEditor);
begin
  try
    if FContinue and (CompareText(PropertyEditor.GetName, 'StyleTemplates') = 0) then
    begin
      PropertyEditor.Edit;
      FContinue := False;
    end;
  finally
    PropertyEditor.Free;
  end;
end;
{$ENDIF}
{$ENDIF}
{============================== TRVEEditor ====================================}
procedure TRVEEditor.ExecuteVerb(Index: Integer);
var frm:TfrmRVDesign;
begin
  case Index of
   0:
     begin
       frm := TfrmRVDesign.Create(Application);
       try
         frm.SetRichView(Component as TCustomRichView);
         if frm.ShowModal=mrOk then begin
           Designer.Modified;
         end;
       finally
         frm.Free;
       end;
     end;
   1:
     begin
       {$IFDEF RVDEBUG}
       ShellExecute(0, 'open', 'http://www.trichview.com/order/', nil, nil, SW_NORMAL);
       {$ELSE}
       ShellExecute(0, 'open', 'http://www.trichview.com', nil, nil, SW_NORMAL);
       {$ENDIF}
     end;
  end;
end;
{------------------------------------------------------------------------------}
function TRVEEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0:
      Result := 'Settings...';
    1:
      {$IFDEF RVDEBUG}
      Result := 'Register TRichView Online';
      {$ELSE}
      Result := 'TRichView Homepage';
      {$ENDIF}
    else
      Result := '';
  end;
end;
{------------------------------------------------------------------------------}
function TRVEEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;
{=========================== TRVStyleTemplateNameProperty =====================}
{$IFNDEF RVDONOTUSESTYLETEMPLATES}
function TRVStyleTemplateNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := (inherited GetAttributes)+[paValueList]-[paMultiSelect, paRevertable];
end;
{------------------------------------------------------------------------------}
procedure TRVStyleTemplateNameProperty.GetValues(Proc: TGetStrProc);
var i: Integer;
begin
  Proc('Normal');
  for i := 1 to 9 do
    Proc(Format('heading %d', [i]));
  Proc('List Bullet');
  for i := 2 to 5 do
    Proc(Format('List Bullet %d', [i]));
  Proc('List Number');
  for i := 2 to 5 do
    Proc(Format('List Number %d', [i]));
  Proc('List');
  for i := 2 to 5 do
    Proc(Format('List %d', [i]));
  Proc('Block Text');
  Proc('Body Text');
  Proc('Body Text First Indent');
  Proc('Body Text Indent');
  Proc('Hyperlink');
  Proc('Plain Text');
  Proc('Title');
  Proc('HTML Code');
end;
{$ENDIF}
{=============================== TRVCodePageProperty ==========================}
function TRVCodePageProperty.GetAttributes: TPropertyAttributes;
begin
 Result := [paMultiSelect, paValueList, paRevertable];
end;
{------------------------------------------------------------------------------}
function TRVCodePageProperty.GetValue: string;
begin
  Result := CodePageToIdent(GetOrdValue);
end;
{------------------------------------------------------------------------------}
procedure TRVCodePageProperty.GetValues(Proc: TGetStrProc);
begin
  GetCodePageValues(Proc);
end;
{------------------------------------------------------------------------------}
procedure TRVCodePageProperty.SetValue(const Value: string);
var NewValue: TRVCodePage;
begin
  if IdentToCodePage(Value,NewValue) then
    SetOrdValue(NewValue)
  else
    inherited SetValue(Value);
end;
{========================== TRVStyleLengthProperty ============================}
{$IFDEF RICHVIEWDEF5}
function TRVStyleLengthProperty.GetUnitName(Obj: TPersistent): String;
var Collection: TCollection;
begin
  Result := '';
  if Obj=nil then
    exit;
  if Assigned(RVGetUnitNameFunc) then begin
    Result := RVGetUnitNameFunc(Obj);
    if Result<>'' then
      exit;
  end;
  if Obj is TRVStyle then begin
    if TRVStyle(Obj).Units=rvstuPixels then
      Result := 'px'
    else
      Result := 'tw';
    end
  else if Obj is TCustomRichView then
    Result := GetUnitName(TCustomRichView(Obj).Style)
  else if Obj is TCustomRVInfo then
    Result := GetUnitName(TCustomRVInfo(Obj).GetRVStyle)
  else if Obj is TRVListLevel then begin
    Collection := TRVListLevel(Obj).Collection;
    if (Collection=nil) or not (Collection is TRVListLevelCollection) then
      exit;
    Result := GetUnitName(TRVListLevelCollection(Collection).GetOwner);
    end
  {$IFNDEF RVDONOTUSETABS}
  else if Obj is TRVTabInfo then begin
    Collection := TRVTabInfo(Obj).Collection;
    if (Collection=nil) or not (Collection is TRVTabInfos) then
      exit;
    Result := GetUnitName(TRVTabInfos(Collection).GetOwner);
    end
  {$ENDIF}
  else if Obj is TRVBorder then
    Result := GetUnitName(TRVBorder(Obj).Owner)
  else if Obj is TRVBackgroundRect then
    Result := GetUnitName(TRVBackgroundRect(Obj).Owner)
  else if Obj is TRVRect then
    Result := GetUnitName(TRVRect(Obj).Owner)
end;
{------------------------------------------------------------------------------}
function TRVStyleLengthProperty.GetUnits: String;
var i: Integer;
    s: String;
begin
  Result := '';
  for i := 0 to PropCount-1 do begin
    s := GetUnitName(GetComponent(i));
    if (s='') or ((Result<>'') and (Result<>s)) then begin
      Result := '';
      exit;
    end;
    if Result='' then
      Result := s;
  end;
end;
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWDEF6}
procedure TRVStyleLengthProperty.PropDrawName(ACanvas: TCanvas;
  const ARect: TRect; ASelected: Boolean);
begin
  DefaultPropertyDrawName(Self, ACanvas, ARect);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TRVStyleLengthProperty.PropDrawValue(ACanvas: TCanvas;
  const ARect: TRect; ASelected: Boolean);
var Value, Units: String;
begin
  Value := GetVisualValue;
  Units := GetUnits;
  if (Value<>'') and (Units<>'') then
    ACanvas.TextRect(ARect, ARect.Left + 1, ARect.Top + 1, Value+' '+Units)
  else
    {$IFDEF RICHVIEWDEF6}
    DefaultPropertyDrawValue(Self, ACanvas, ARect);
    {$ELSE}
    inherited PropDrawValue(ACanvas, ARect, ASelected);
    {$ENDIF}
end;
{========================== TRVLineSpacingValueProperty =======================}
function TRVLineSpacingValueProperty.GetUnitName(Obj: TPersistent): String;
begin
  if (Obj is TCustomRVParaInfo) and (TCustomRVParaInfo(Obj).LineSpacingType=rvlsPercent) then
    Result := '%'
  else
    Result := inherited GetUnitName(Obj);
end;
{============================= TRVLengthProperty ==============================}
{$IFNDEF RVDONOTUSEDOCPARAMS}
function TRVLengthProperty.GetUnitName(Obj: TPersistent): String;
begin
  Result := '';
  if Assigned(RVGetRVUnitNameFunc) then begin
    Result := RVGetRVUnitNameFunc(Obj);
    if Result<>'' then
      exit;
  end;
  if Obj is TRVDocParameters then
    Result := GetRVUnitsName(TRVDocParameters(Obj).Units);
end;
{------------------------------------------------------------------------------}
function TRVLengthProperty.GetUnits: String;
var i: Integer;
begin
  Result := '';
  for i := 0 to PropCount-1 do begin
    if (Result<>'') and (Result<>GetUnitName(GetComponent(i))) then begin
      Result := '';
      exit;
    end;
    if Result='' then
      Result := GetUnitName(GetComponent(i))
  end;
end;
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWDEF6}
procedure TRVLengthProperty.PropDrawName(ACanvas: TCanvas;
  const ARect: TRect; ASelected: Boolean);
begin
  DefaultPropertyDrawName(Self, ACanvas, ARect);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TRVLengthProperty.PropDrawValue(ACanvas: TCanvas;
  const ARect: TRect; ASelected: Boolean);
var Value, Units: String;
begin
  Value := GetVisualValue;
  Units := GetUnits;
  if (Value<>'') and (Units<>'') then
    ACanvas.TextRect(ARect, ARect.Left + 1, ARect.Top + 1, Value+Units)
  else
    {$IFDEF RICHVIEWDEF6}
    DefaultPropertyDrawValue(Self, ACanvas, ARect);
    {$ELSE}
    inherited PropDrawValue(ACanvas, ARect, ASelected);
    {$ENDIF}
end;

function GetRVUnitsName(Units: TRVUnits): String;
begin
  case Units of
    rvuInches: Result := '''';
    rvuCentimeters: Result := ' cm';
    rvuMillimeters: Result := ' mm';
    rvuPicas: Result := ' pc';
    rvuPixels: Result := ' px';
    rvuPoints: Result := ' pt';
    else Result := '';
  end;
end;
{$ENDIF}
{$ENDIF}
{============================= TRVStyleTemplateIdProperty =====================}
{$IFNDEF RVDONOTUSESTYLETEMPLATES}
function TRVStyleTemplateIdProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;
{------------------------------------------------------------------------------}
function TRVStyleTemplateIdProperty.GetCollection: TRVStyleTemplateCollection;
var Cmp: TPersistent;
begin
  Cmp := GetComponent(0);
  if Cmp is TRVStyleTemplate then
    Result := (Cmp as TRVStyleTemplate).Collection as TRVStyleTemplateCollection
  else if Cmp is TCustomRVInfo then
    Result := (((Cmp as TCustomRVInfo).Collection as TCustomRVInfos).GetOwner as TRVStyle).StyleTemplates
  else
    Result := nil;
end;
{------------------------------------------------------------------------------}
function TRVStyleTemplateIdProperty.GetValue: string;
var Coll: TRVStyleTemplateCollection;
    Val, i: Integer;
begin
  Val := GetOrdValue;
  if Val<=0 then begin
    Result := '(none)';
    exit;
  end;
  if PropCount=0 then begin
    Result := '(error)';
    exit;
  end;
  Coll := GetCollection;
  for i := 0 to Coll.Count-1 do
    if Coll[i].Id=Val then begin
      Result := Format('%s (id=%d)', [Coll[i].Name, Coll[i].Id]);
      exit;
    end;
  Result := '(unknown)';
end;
{------------------------------------------------------------------------------}
procedure TRVStyleTemplateIdProperty.GetValues(Proc: TGetStrProc);
var Coll: TRVStyleTemplateCollection;
    i: Integer;
    StyleTemplate: TRVStyleTemplate;
begin
  if PropCount=0 then
    exit;
  Proc('(none)');
  Coll := GetCollection;
  if GetComponent(0) is TRVStyleTemplate then begin
    StyleTemplate := TRVStyleTemplate(GetComponent(0));
    for i := 0 to Coll.Count-1 do
      if not StyleTemplate.IsAncestorFor(Coll[i]) then
        Proc(Format('%s (id=%d)', [Coll[i].Name, Coll[i].Id]));
    end
  else
    for i := 0 to Coll.Count-1 do
      Proc(Format('%s (id=%d)', [Coll[i].Name, Coll[i].Id]));
end;
{------------------------------------------------------------------------------}
procedure TRVStyleTemplateIdProperty.SetValue(const Value: string);
var s: String;
    i : Integer;
    found: Boolean;
begin
  if (Value='(none)') or (Value='(error)') or (Value='(unknown)') or
     (Value='') then begin
    SetOrdValue(-1);
    exit;
  end;
  s := '';
  if Value[Length(Value)]=')' then begin
    found := False;
    for i := Length(Value)-1 downto 1 do
      if (Value[i]>='0') and (Value[i]<='9') then
        s := Value[i]+s
      else if Value[i]='=' then begin
        found := True;
        break;
        end
      else
        break;
    if not found then begin
      inherited SetValue(Value);
      exit;
    end;
    inherited SetValue(s);
    exit;
  end;
  inherited SetValue(Value);
end;
{======================= TRVStyleTemplateCollectionProperty=================== }
{$IFDEF RICHVIEWDEF6}
function TRVStyleTemplateCollectionProperty.GetAttributes: TPropertyAttributes;
begin
  Result := (inherited GetAttributes)+[paSubProperties];
end;
{$ENDIF}
{$ENDIF}
{==============================================================================}
{$IFDEF RICHVIEWDEF6}
const TRVIOCategory = 'Import/Export';
      TRVRVFCategory = 'RVF';
      TRVCPCategory ='Checkpoints';
      TRVHypertextCategory = 'Hypertext';
      TRVStyleNameCategory = 'Style Name';
{$ELSE}
{$IFDEF RICHVIEWDEF5}
type
 TRVStyleNameCategory = class(TPropertyCategory)
  public
    class function Name: string; override;
    class function Description: string; override;
  end;
 TRVHypertextCategory = class(TPropertyCategory)
  public
    class function Name: string; override;
    class function Description: string; override;
  end;
 TRVCPCategory = class(TPropertyCategory)
  public
    class function Name: string; override;
    class function Description: string; override;
  end;
 TRVRVFCategory = class(TPropertyCategory)
  public
    class function Name: string; override;
    class function Description: string; override;
  end;
 TRVIOCategory = class(TPropertyCategory)
  public
    class function Name: string; override;
    class function Description: string; override;
  end;

class function TRVStyleNameCategory.Description: string;
begin
  Result := 'Style Name';
end;
class function TRVStyleNameCategory.Name: string;
begin
  Result := 'Style Name';
end;

class function TRVHypertextCategory.Description: string;
begin
  Result := 'Hypertext related properties';
end;
class function TRVHypertextCategory.Name: string;
begin
  Result := 'Hypertext';
end;

class function TRVCPCategory.Description: string;
begin
  Result := 'Checkpoint related properties';
end;
class function TRVCPCategory.Name: string;
begin
  Result := 'Checkpoints';
end;

class function TRVRVFCategory.Description: string;
begin
  Result := 'RichView Format related properties'
end;
class function TRVRVFCategory.Name: string;
begin
  Result := 'RVF'
end;

class function TRVIOCategory.Description: string;
begin
  Result := 'Import/Export';
end;
class function TRVIOCategory.Name: string;
begin
  Result := 'Import/Export';
end;

{$ENDIF}
{$ENDIF}
{-----------------------------------------------------------------------}
procedure Register;
{$IFDEF RICHVIEWDEF6}
const
  TLocalizableCategory: String = sLocalizableCategoryName;
  TInputCategory:       String = sInputCategoryName;
  TVisualCategory:      String = sVisualCategoryName;
  TLegacyCategory:      String = sLegacyCategoryName;
{$ENDIF}
begin
  RegisterComponentEditor(TRVStyle, TRVSEditor);
  RegisterComponentEditor(TCustomRichView, TRVEEditor);
  RegisterPropertyEditor(TypeInfo(TRVCodePage), nil,'',  TRVCodePageProperty);
  {$IFDEF RICHVIEWDEF5}
  RegisterPropertyEditor(TypeInfo(TRVStyleLength), nil,'',  TRVStyleLengthProperty);
  RegisterPropertyEditor(TypeInfo(TRVLineSpacingValue), TCustomRVParaInfo, '',  TRVLineSpacingValueProperty);
  {$IFNDEF RVDONOTUSEDOCPARAMS}
  RegisterPropertyEditor(TypeInfo(TRVLength), TRVDocParameters, '',  TRVLengthProperty);
  {$ENDIF}
  {$ENDIF}  
  {$IFNDEF RVDONOTUSESTYLETEMPLATES}
  RegisterPropertyEditor(TypeInfo(TRVStyleTemplateName), nil, '',
    TRVStyleTemplateNameProperty);
  {$IFDEF RICHVIEWDEF6}
  RegisterPropertyEditor(TypeInfo(TRVStyleTemplateCollection), nil,'',
    TRVStyleTemplateCollectionProperty);
  {$ENDIF}
  RegisterPropertyEditor(TypeInfo(TRVStyleTemplateId), TRVStyleTemplate,
    'ParentId',  TRVStyleTemplateIdProperty);
  RegisterPropertyEditor(TypeInfo(TRVStyleTemplateId), TCustomRVInfo,
    'StyleTemplateId',  TRVStyleTemplateIdProperty);
  {$ENDIF}
  {$IFDEF RICHVIEWDEF5}
  RegisterPropertiesInCategory(TLocalizableCategory, TFontInfo,
    ['StyleName','Charset','FontName','Size', 'Unicode']);
  RegisterPropertiesInCategory(TInputCategory, TFontInfo,
    ['NextStyleNo', 'Protection']);
  RegisterPropertiesInCategory(TVisualCategory, TFontInfo,
    ['Charset','FontName','Size','Style','StyleEx','VShift','Unicode',
     'CharScale', 'CharSpacing']);
  RegisterPropertiesInCategory(TRVStyleNameCategory, TFontInfo,
    ['StyleName']);
  RegisterPropertiesInCategory(TRVHypertextCategory, TFontInfo,
    ['Jump', 'JumpCursor', 'HoverColor', 'HoverBackColor']);
  RegisterPropertiesInCategory(TRVStyleNameCategory, TFontInfo,
    ['StyleName']);

  RegisterPropertiesInCategory(TLocalizableCategory, TParaInfo,
    ['StyleName','FirstIndent','LeftIndent','RightIndent', 'Alignment',
     'SpaceAfter', 'SpaceBefore']);
  RegisterPropertiesInCategory(TVisualCategory, TParaInfo,
    ['FirstIndent','LeftIndent','RightIndent', 'Alignment',
    'SpaceAfter', 'SpaceBefore', 'Border', 'Background',
    'LineSpacing', 'LineSpacingType']);
  RegisterPropertiesInCategory(TRVStyleNameCategory, TParaInfo,
    ['StyleName']);
  RegisterPropertiesInCategory(TInputCategory, TParaInfo,
    ['NextParaNo']);

  RegisterPropertiesInCategory(TRVStyleNameCategory, TRVListInfo,
    ['StyleName']);
  RegisterPropertiesInCategory(TVisualCategory, TRVListInfo,
    ['OneLevelPreview']);

  RegisterPropertiesInCategory(TVisualCategory, TRVListLevel,
    ['ImageIndex', 'ImageList', 'Picture', 'FirstIndent',
     'FormatString', 'FormatStringW', 'LeftIndent', 'ListType',
     'MarkerAlignment', 'MarkerIndent']);

  RegisterPropertiesInCategory(TLocalizableCategory, TRVStyle,
    ['DefCodePage']);
  RegisterPropertiesInCategory(TRVHypertextCategory, TRVStyle,
    ['JumpCursor', 'HoverColor']);
  RegisterPropertiesInCategory(TRVCPCategory, TRVStyle,
    ['CheckpointColor', 'CheckpointEvColor']);
  RegisterPropertiesInCategory(TVisualCategory, TRVStyle,
    ['SelectionStyle', 'SelectionMode']);

  RegisterPropertiesInCategory(TLocalizableCategory, TCustomRichView,
    ['Delimiters']);
  RegisterPropertiesInCategory(TInputCategory, TCustomRichView,
    ['OnRVDblClick','OnRVMouseDown', 'OnRVMouseUp','OnRVRightClick',
     'WheelStep']);
  RegisterPropertiesInCategory(TRVRVFCategory, TCustomRichView,
    ['RVFOptions', 'RVFTextStylesReadMode', 'RVFParaStylesReadMode',
     'OnRVFControlNeeded','OnRVFImageListNeeded', 'OnRVFPictureNeeded']);
  RegisterPropertiesInCategory(TVisualCategory, TCustomRichView,
    ['BackgroundStyle',
      'LeftMargin','RightMargin','TopMargin','BottomMargin',
      'MinTextWidth','MaxTextWidth',
      'Tracking', 'VScrollVisible', 'HScrollVisible',
      'DoInPaletteMode', 'UseXPThemes']);
  RegisterPropertiesInCategory(TRVCPCategory, TCustomRichView,
    ['CPEventKind','OnCheckpointVisible']);
  RegisterPropertiesInCategory(TRVHypertextCategory, TCustomRichView,
    ['FirstJumpNo','OnJump','OnRVMouseMove', 'OnURLNeeded', 'OnReadHyperlink',
     'OnWriteHyperlink']);
  RegisterPropertiesInCategory(TLegacyCategory, TCustomRichView,
    ['AllowSelection', 'SingleClick', 'OnURLNeeded']);
  RegisterPropertiesInCategory(TRVIOCategory, TCustomRichView,
    ['RTFOptions', 'RTFReadProperties', 'OnSaveComponentToFile', 'OnURLNeeded',
     'OnReadHyperlink', 'OnWriteHyperlink',
     'OnHTMLSaveImage', 'OnSaveImage2', 'OnImportPicture',
     'OnSaveRTFExtra', 'OnSaveHTMLExtra']);

  RegisterPropertiesInCategory(TInputCategory, TCustomRichViewEdit,
    ['EditorOptions', 'UndoLimit', 'OnCaretGetOut', 'OnCaretMove',
     'OnChange', 'OnChanging', 'OnStyleConversion', 'OnParaStyleConversion']);
  {$ENDIF}
end;
{$ENDIF}

end.

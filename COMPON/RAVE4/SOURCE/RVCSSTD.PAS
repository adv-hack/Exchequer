{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVCsStd;

interface

uses
  {$IFDEF Linux}
  QControls, QGraphics, QDialogs, Types,
  {$ELSE}
  Messages, WinProcs, WinTypes, Controls, Graphics, Dialogs,
  {$ENDIF}
  Classes, SysUtils, RVDefine, RVUtil, RVClass, RVData, RPDefine, RPBase, RPMemo, RVDataField;

type
  TRaveFontMaster = class(TRaveComponent)
  protected
    FFont: TRaveFont;
    procedure SetFont(Value: TRaveFont);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Font: TRaveFont read FFont write SetFont;
  end; { TRaveFontMaster }

  TRavePageNumInit = class(TRaveComponent)
  protected
    FInitValue: integer;
    FInitDataView: TRaveBaseDataView;
    FInitDataField: TRaveFieldName;

    procedure Changing(OldItem: TRaveComponent;
                       NewItem: TRaveComponent); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Print(AReport: TBaseReport); override;
  published
    property InitValue: integer read FInitValue write FInitValue default 1;
    property InitDataView: TRaveBaseDataView read FInitDataView write FInitDataView default nil;
    property InitDataField: TRaveFieldName read FInitDataField write FInitDataField;
  end; { TRavePageNumInit }

  TRaveCustomText = class(TRaveControl)
  protected
    FFont: TRaveFont;
    FFontJustify: TPrintJustify;
    FText: string;
    FFontMirror: TRaveFontMaster;
    FOnGetText: TRaveStringEvent;
  {$IFDEF DESIGNER}
    BracketText: boolean;
  {$ENDIF}

  {$IFDEF DESIGNER}
    function MakeFont: HFont;
    procedure PaintText(    Handle: THandle;
                            Text: string;
                            PaintLeft: TRaveUnits;
                            PaintRight: TRaveUnits;
                        var PaintTop: TRaveUnits;
                            Truncate: boolean = false);
    procedure SetFontAttr(Index: TFontAttribute;
                          Value: TRaveFont); override;
    function GetFontAttr(Index: TFontAttribute): TRaveFont; override;
  {$ENDIF}
    procedure SetText(Value: string); override;
    function GetText: string; override;
    procedure SetFont(Value: TRaveFont);
    procedure SetFontJustify(Value: TPrintJustify); override;
    function GetFontJustify: TPrintJustify; override;
    procedure SetForeColor(Value: TColor); override;
    function GetForeColor: TColor; override;
    procedure SetFontMirror(Value: TRaveFontMaster);
    procedure Changing(OldItem: TRaveComponent;
                       NewItem: TRaveComponent); override;
    procedure DoGetText(var Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property FontMirror: TRaveFontMaster read FFontMirror write SetFontMirror;
    property Color: TColor read GetForeColor write SetForeColor default clBlack;
    property Font: TRaveFont read FFont write SetFont;
  end; { TRaveCustomText }

  TRaveText = class(TRaveCustomText)
  protected
    FTruncate: boolean;
    FRotation: integer;
    function GetHeight: TRaveUnits; override;
  public
    constructor Create(AOwner: TComponent); override;
  {$IFDEF DESIGNER}
    procedure CreatePips; override;
    procedure UpdatePips; override;
    procedure Paint(Canvas: TCanvas); override;
  {$ENDIF}
    procedure Print(Report: TBaseReport); override;
  published
    property Color;
    property Font;
    property FontJustify;
    property FontMirror;
    property Left;
    property Rotation: integer read FRotation write FRotation default 0;
    property Text;
    property Top;
    property Truncate: boolean read FTruncate write FTruncate default false;
    property Width;
    property OnGetText: TRaveStringEvent read FOnGetText write FOnGetText;
  end; { TRaveText }

  TRaveSection = class(TRaveContainerControl)
  protected
    FWasteFit: boolean;
  public
    constructor Create(AOwner: TComponent); override;
    procedure PrintAll(Report: TBaseReport); override;
  {$IFDEF DESIGNER}
    procedure Paint(Canvas: TCanvas); override;
  {$ENDIF}
  published
    property Height;
    property Left;
    property Top;
    property WasteFit: boolean read FWasteFit write FWasteFit default false;
    property Width;
  end; { TRaveSection }

  TMatchSide = (msWidth,msHeight,msBoth,msInside);

  TRaveBaseImage = class(TRaveControl)
  protected
    FMatchSide: TMatchSide;
    FMatchHeight: boolean;
    FFileLink: TFileName;
    FDataField: TRaveFieldName;
    FDataView: TRaveBaseDataView;

    procedure SetFileLink(Value: TFileName);
    procedure SetDataField(Value: TRaveFieldName);
    procedure SetMatchSide(Value: TMatchSide);
    procedure LoadFromFile(FileName: string);
    procedure Changing(OldItem: TRaveComponent;
                       NewItem: TRaveComponent); override;
    procedure LoadFromStream(Stream: TStream); virtual; abstract;
    function ImageValid: boolean; virtual; abstract;
    procedure UnloadAltImage; virtual; abstract;
    function ImageWidth: integer; virtual; abstract;
    function ImageHeight: integer; virtual; abstract;
  {$IFDEF DESIGNER}
    procedure PaintImage(Canvas: TCanvas;
                        Dest: TRect); virtual; abstract;
  {$ENDIF}
    procedure PrintImage(Report: TBaseReport;
                        X1,Y1,X2,Y2: TRaveUnits); virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  {$IFDEF DESIGNER}
    procedure Paint(Canvas: TCanvas); override;
  {$ENDIF}
    procedure Print(Report: TBaseReport); override;
    function ImageName: string; virtual;
    function ImageFilter: string; virtual;
  published
    property Height;
    property Left;
    property Top;
    property Width;
    property MatchSide: TMatchSide read FMatchSide write SetMatchSide default msWidth;
    property FileLink: TFileName read FFileLink write SetFileLink;
    property DataField: TRaveFieldName read FDataField write SetDataField;
    property DataView: TRaveBaseDataView read FDataView write FDataView default nil;
  end; { TRaveBaseImage }

  TRaveGraphicImage = class(TRaveBaseImage)
  protected
    FImage: TGraphic;
    FAltImage: TGraphic;

    function CreateGraphic: TGraphic; virtual; abstract;
    procedure SetImage(Value: TGraphic);
    function ActiveImage: TGraphic;
    procedure LoadFromStream(Stream: TStream); override;
    procedure UnloadAltImage; override;
    function ImageWidth: integer; override;
    function ImageHeight: integer; override;
  {$IFDEF DESIGNER}
    procedure PaintImage(Canvas: TCanvas;
                        Dest: TRect); override;
  {$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Image: TGraphic read FImage write SetImage;
  end; { TRaveGraphicImage }

  TRaveBitmap = class(TRaveGraphicImage)
  protected
    function CreateGraphic: TGraphic; override;
    function ImageValid: boolean; override;
    procedure PrintImage(Report: TBaseReport;
                        X1,Y1,X2,Y2: TRaveUnits); override;
  public
    function ImageName: string; override;
    function ImageFilter: string; override;
  end; { TRaveBitmap }

  TRaveMetaFile = class(TRaveGraphicImage)
  protected
    function CreateGraphic: TGraphic; override;
    function ImageValid: boolean; override;
    procedure PrintImage(Report: TBaseReport;
                        X1,Y1,X2,Y2: TRaveUnits); override;
  public
    function ImageName: string; override;
    function ImageFilter: string; override;
  end; { TRaveMetaFile }

  TRaveMailMergeItem = class(TPersistent)
  protected
    FSearchToken: string;
    FReplaceString: string;
    FCaseMatters: boolean;
  published
    property CaseMatters: boolean read FCaseMatters write FCaseMatters
     default false;
    property ReplaceString: string read FReplaceString write FReplaceString;
    property SearchToken: string read FSearchToken write FSearchToken;
  end; { TRaveMailMergeItem }

  TRaveMemo = class(TRaveCustomText)
  protected
    SaveAnchor: TRaveAnchor;
    FExpandParent: boolean;
    FTruncate: boolean;
    Prepared: boolean;
    MemoBuf: TMemoBuf;
  {$IFDEF DESIGNER}
    LineList: TStrings;
  {$ENDIF}
    FMailMergeItems: TRavePersistentList;
    FContainsRTF: boolean;
    procedure SetMailMergeItems(Value: TRavePersistentList);
    procedure InitMemoBuf;
    procedure FreeMemoBuf;
    procedure SetMemoText(Value: TRaveMemoString);
    function GetMemoText: TRaveMemoString;
    procedure InitData; override;
    function GetDonePrinting: boolean; override;
    procedure BeforeReport; override;
    procedure AfterReport; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  {$IFDEF DESIGNER}
    procedure Paint(Canvas: TCanvas); override;
    procedure Resize; override;
    procedure SetText(Value: string); override;
  {$ENDIF}
    procedure Print(Report: TBaseReport); override;
    function HeightToPrint: TRaveUnits; override;
    property ContainsRTF: boolean read FContainsRTF write FContainsRTF default false;
  published
    property Color;
    property ExpandParent: boolean read FExpandParent write FExpandParent default true;
    property Font;
    property FontJustify;
    property FontMirror;
    property Left;
    property Height;
    property MailMergeItems: TRavePersistentList read FMailMergeItems write
     SetMailMergeItems;
    property Text: TRaveMemoString read GetMemoText write SetMemoText;
    property Top;
    property Truncate: boolean read FTruncate write FTruncate default false;
    property Width;
  end; { TRaveMemo }

  procedure RaveRegister;

implementation

uses
  RVProj;

{$IFDEF DESIGNER}
{$R *.RES}
{$ENDIF}

function CreateTextControl(AOwner: TComponent;
                           DataField: TRaveDataField): TRaveControl;

begin { CreateTextControl }
  Result := TRaveText.Create(AOwner);
  TRaveText(Result).Text := DataField.FullName;
end;  { CreateTextControl }

procedure RaveRegister;

begin { RaveRegister }
{TransOff}
  CreateTextControlProc := CreateTextControl;
  RegisterRaveGroup('Standard',Trans('Standard'));
  RegisterRaveComponents('Standard',[TRaveText,TRaveMemo,TRaveSection,TRaveBitmap,
   TRaveMetaFile,TRaveFontMaster,TRavePageNumInit]);
  RegisterRaveModuleClasses('RVCsStd',[TRaveText,TRaveMemo,TRaveSection,
   TRaveBitmap,TRaveMetaFile,TRaveFontMaster,TRavePageNumInit]);

{$IFDEF DESIGNER}
  RegisterRaveProperties(TRaveFontMaster,
   {Beginner}     'Font',
   {Intermediate} '',
   {Developer}    '',
   {Hidden}       '');

  RegisterRaveProperties(TRavePageNumInit,
   {Beginner}     'InitValue',
   {Intermediate} 'InitDataField;InitDataView',
   {Developer}    '',
   {Hidden}       '');

  RegisterRaveProperties(TRaveCustomText,
   {Beginner}     'Color;Font;FontJustify;Text',
   {Intermediate} 'FontMirror',
   {Developer}    '',
   {Hidden}       '');

  RegisterRaveProperties(TRaveText,
   {Beginner}     '',
   {Intermediate} 'Truncate',
   {Developer}    '',
   {Hidden}       '');

  RegisterRaveProperties(TRaveSection,
   {Beginner}     '',
   {Intermediate} '',
   {Developer}    '',
   {Hidden}       '');

  RegisterRaveProperties(TRaveBitmap,
   {Beginner}     'Image',
   {Intermediate} 'DataField;DataView;MatchSide',
   {Developer}    '',
   {Hidden}       '');

  RegisterRaveProperties(TRaveMetaFile,
   {Beginner}     'Image',
   {Intermediate} 'DataField;DataView;MatchSide',
   {Developer}    '',
   {Hidden}       '');

  RegisterRaveProperties(TRaveMemo,
   {Beginner}     '',
   {Intermediate} 'ExpandParent;MailMergeItems',
   {Developer}    '',
   {Hidden}       '');

  SetPropDesc(TRaveFontMaster,'Font',Trans('Defines the font name, style and ' +
   'size of any text components that have this component defined in their ' +
   'FontMirror property.'));

  SetPropDesc(TRavePageNumInit,'InitValue',Trans('Defines the value that the ' +
   'relative page number will start from when this component is printed. Only ' +
   'the RelativePage report variable (not CurrentPage) will reflect the new ' +
   'page number.'));
  SetPropDesc(TRavePageNumInit,'InitDataView',Trans('Defines the default dataview ' +
   'for the InitDataField property.'));
  SetPropDesc(TRavePageNumInit,'InitDataField',Trans('Defines the value that the ' +
   'relative page number will start from when this component is printed. If the ' +
   'text cannot be converted to a valid integer, a default value of 1 will be used.'));

  SetPropDesc(TRaveCustomText,'FontJustify',Trans('Defines the justification ' +
   'of the text within the designed area. This property can also be modified with ' +
   'the Font Editor toolbar.'));
  SetPropDesc(TRaveCustomText,'FontMirror',Trans('Defines the FontMaster component ' +
   'that will control the font attributes of this component. When a FontMirror is ' +
   'assigned, the Font Editor toolbar will not be active.'));
  SetPropDesc(TRaveCustomText,'Color',Trans('Defines the color of the text to be ' +
   'printed. This property can also be modified with the Color Palette toolbar.'));
  SetPropDesc(TRaveCustomText,'Font',Trans('Defines the font name, style and size ' +
   'of the text to be printed. This property can also be modified with the Font ' +
   'Editor toolbar.'));
  SetPropDesc(TRaveCustomText,'OnGetText',Trans('The OnGetText event allows you to ' +
   'change the text that is going to be printed.  Initially, the Value parameter will ' +
   'contain the default text that will be printed.  You can assign a new value if ' +
   'necessary (note: do not modify Self.Text).|Value: string - The text value that ' +
   'will be printed.'));

  SetPropDesc(TRaveText,'Rotation',Trans('Defines the rotation, in degrees, of ' +
   'the text to be printed.  Valid valid are whole numbers between 0 and 359.'));
  SetPropDesc(TRaveText,'Text',Trans('The text that will be printed.'));
  SetPropDesc(TRaveText,'Truncate',Trans('Determines whether the text is ' +
   'truncated or printed completely, regardless of the designed width.'));

  SetPropDesc(TRaveSection,'WasteFit',Trans('Determines whether the section will ' +
   'adjust it''s size so that it fits within the waste area of the destination ' +
   'printer.  A value of true will resize the section so that it completely fits ' +
   'on the current page.  Set the Anchor property for child controls so that ' +
   'they will adjust to changes in the size of the section.'));

  SetPropDesc(TRaveBaseImage,'MatchSide',Trans('Defines how the image is sized. ' +
   'msWidth or msHeight will match the designed width or height and adjust the ' +
   'opposite side to keep the image proportional.  msBoth will match the designed ' +
   'width and height and is normally non-proportional.  msInside will size the ' +
   'image proportionally within the designed width and height.'));
  SetPropDesc(TRaveBaseImage,'FileLink',Trans('Defines a filename that will be ' +
   'used to load the image from. This can be useful for keeping large images ' +
   'outside the report project or allowing easy replacement of images such as ' +
   'company logos.'));
  SetPropDesc(TRaveBaseImage,'DataField',Trans('Defines the field where the ' +
   'image data is stored. If the field contains string information, it will be ' +
   'assumed to be a filename reference similar to the FileLink property.'));
  SetPropDesc(TRaveBaseImage,'DataView',Trans('Defines the default dataview for ' +
   'the DataField property.'));

  SetPropDesc(TRaveBitmap,'Image',Trans('Stores a bitmap to print. Other options for ' +
   'printing bitmaps are available in the FileLink and DataField properties.'));

  SetPropDesc(TRaveMetaFile,'Image',Trans('Stores a metafile to print. Other options for ' +
   'printing bitmaps are available in the FileLink and DataField properties.'));

  SetPropDesc(TRaveMemo,'ExpandParent',Trans('Determines whether the memo will ' +
   'expand the parent height to allow enough room to print the entire memo contents.'));
  SetPropDesc(TRaveMemo,'MailMergeItems',Trans('Through the Mail Merge Editor, defines ' +
   'search tokens and replacement text that will be used to modify the memo each time ' +
   'it is printed.  Useful for inserting data fields or project parameters inside memos ' +
   'at user defined positions.'));
  SetPropDesc(TRaveMemo,'Text',Trans('Defines the memo text that will be printed.'));
  SetPropDesc(TRaveMemo,'Truncate',Trans('Determines whether the memo will be ' +
   'truncated or continue on the next page if it does not completly print the ' +
   'first time.'));
{$ENDIF}
{TransOn}
end;  { RaveRegister }

(*****************************************************************************}
( class TRaveFontMaster
(*****************************************************************************)

constructor TRaveFontMaster.Create(AOwner: TComponent);

begin { Create }
  inherited Create(AOwner);
  FFont := TRaveFont.Create;
  FFont.Name := {Trans-}'Arial';
  FFont.Size := 10;
  FFont.Style := [];
  FFont.Color := clBlack;
end;  { Create }

destructor TRaveFontMaster.Destroy;

begin { Destroy }
  FFont.Free;
  inherited Destroy;
end;  { Destroy }

procedure TRaveFontMaster.SetFont(Value: TRaveFont);

begin { SetFont }
  FFont.Assign(Value);
  Invalidate;
end;  { SetFont }

(*****************************************************************************}
( class TRavePageNumInit
(*****************************************************************************)

constructor TRavePageNumInit.Create(AOwner: TComponent);

begin { Create }
  inherited Create(AOwner);
  FInitValue := 1;
end;  { Create }

procedure TRavePageNumInit.Changing(OldItem: TRaveComponent;
                                    NewItem: TRaveComponent);

begin { Changing }
  inherited Changing(OldItem,NewItem);
  If Assigned(InitDataView) and (InitDataView = OldItem) then begin
    InitDataView := NewItem as TRaveBaseDataView;
  end; { if }
end;  { Changing }

procedure TRavePageNumInit.Print(AReport: TBaseReport);
var
  Value: integer;
begin { Print }
  If Length(InitDataField) > 0 then begin
    Value := Trunc(StrToFloatDef(StripFloatStr(ProcessDataStr(self,InitDataView,
     InitDataField)), 1.0));
  end else begin
    Value := InitValue;
  end; { else }
  AReport.PageNumOffset := Value - AReport.CurrentPage;
end;  { Print }

(*****************************************************************************}
( class TRaveCustomText
(*****************************************************************************)

constructor TRaveCustomText.Create(AOwner: TComponent);

begin { Create }
  inherited Create(AOwner);
  FFont := TRaveFont.Create;
  FFont.Name := {Trans-}'Arial';
  FFont.Size := 10;
  FFont.Style := [];
  FFont.Color := clBlack;
  FFontJustify := pjLeft;
end;  { Create }

destructor TRaveCustomText.Destroy;

begin { Destroy }
  FFont.Free;
  inherited Destroy;
end;  { Destroy }

procedure TRaveCustomText.Changing(OldItem: TRaveComponent;
                                   NewItem: TRaveComponent);

begin { Changing }
  inherited Changing(OldItem,NewItem);
  If Assigned(FontMirror) and (FontMirror = OldItem) then begin
    FontMirror := NewItem as TRaveFontMaster;
  end; { if }
end;  { Changing }

procedure TRaveCustomText.DoGetText(var Value: string);

begin { DoGetText }
  If Assigned(FOnGetText) then begin
    FOnGetText.ParamValue := Value;
    FOnGetText.Execute;
    Value := FOnGetText.ParamValue;
  end; { if }
end;  { DoGetText }

{$IFDEF DESIGNER}
function TRaveCustomText.MakeFont: HFont;

var
  LogFont: TLogFont;
  BaseFont: TRaveFont;

begin { MakeFont }
  If Assigned(FFontMirror) then begin
    BaseFont := FFontMirror.Font;
  end else begin
    BaseFont := FFont;
  end; { else }
  With LogFont do begin
    lfHeight := -YI2P(Abs(BaseFont.Size / 72.0));
    lfWidth := 0;
    lfEscapement := 0; {BaseFont.Rotation * 10;}
    lfOrientation := 0;
    If fsBold in BaseFont.Style then begin
      lfWeight := FW_BOLD;
    end else begin
      lfWeight := FW_NORMAL;
    end; { else }
    lfItalic := byte(fsItalic in BaseFont.Style);
    lfUnderline := byte(fsUnderline in BaseFont.Style);
    lfStrikeOut := byte(fsStrikeout in BaseFont.Style);
  {$IFDEF VER80}
    lfCharset := DEFAULT_CHARSET;
  {$ELSE}
    {$IFDEF VER90}
      lfCharset := DEFAULT_CHARSET;
    {$ELSE}
      lfCharset := BaseFont.Charset;
    {$ENDIF}
  {$ENDIF}
    StrPCopy(lfFaceName,BaseFont.Name);
    lfQuality := DEFAULT_QUALITY;
    lfOutPrecision := OUT_DEFAULT_PRECIS;
    lfClipPrecision := CLIP_DEFAULT_PRECIS;
    Case BaseFont.Pitch of
      fpVariable: begin
        lfPitchAndFamily := VARIABLE_PITCH;
      end;
      fpFixed: begin
        lfPitchAndFamily := FIXED_PITCH;
      end;
      else begin
        lfPitchAndFamily := DEFAULT_PITCH;
      end;
    end; { case }
  end; { with }
  Result := CreateFontIndirect(LogFont);
end;  { MakeFont }

procedure TRaveCustomText.PaintText(    Handle: THandle;
                                        Text: string;
                                        PaintLeft: TRaveUnits;
                                        PaintRight: TRaveUnits;
                                    var PaintTop: TRaveUnits;
                                        Truncate: boolean = false);

const
  Justify: array[TPrintJustify] of integer = (TA_CENTER,TA_LEFT,TA_RIGHT,TA_LEFT);

var
  TempFont: HFont;
  XL,XC,XR: integer;
  Y1: integer;
  TextMetric: TTextMetric;
  SaveTA: integer;
  SaveColor: TColor;
  S1: string;

begin { PaintText }
  TempFont := MakeFont;
  TempFont := SelectObject(Handle,TempFont);
  If Assigned(FFontMirror) then begin
    SaveColor := SetTextColor(Handle,ColorToRGB(ModColor(FFontMirror.Font.Color)));
    PaintTop := PaintTop + Abs(FFontMirror.Font.Size) / 60.0;
  end else begin
    SaveColor := SetTextColor(Handle,ColorToRGB(ModColor(FFont.Color)));
    PaintTop := PaintTop + Abs(FFont.Size) / 60.0;
  end; { else }
  GetTextMetrics(Handle,TextMetric);
  Y1 := YI2D(PaintTop) - TextMetric.tmDescent;
  If Text <> '' then begin
    SetBKMode(Handle,TRANSPARENT);
    SaveTA := SetTextAlign(Handle,Justify[FontJustify] or TA_BASELINE or
     TA_NOUPDATECP);
    If BracketText then begin
      XL := XI2D(PaintLeft);
      XR := XI2D(PaintRight);
      Case FontJustify of
        pjCenter: begin
          XC := XI2D((PaintLeft + PaintRight) / 2.0);
          S1 := Text;
          TextOut(Handle,XC,Y1,@S1[1],Length(S1));
          SetTextAlign(Handle,TA_LEFT or TA_BASELINE or TA_NOUPDATECP);
          S1 := '[';
          TextOut(Handle,XL,Y1,@S1[1],Length(S1));
          SetTextAlign(Handle,TA_RIGHT or TA_BASELINE or TA_NOUPDATECP);
          S1 := ']';
          TextOut(Handle,XR,Y1,@S1[1],Length(S1));
        end;
        pjRight: begin
          S1 := Text + ']';
          TextOut(Handle,XR,Y1,@S1[1],Length(S1));
          SetTextAlign(Handle,TA_LEFT or TA_BASELINE or TA_NOUPDATECP);
          S1 := '[';
          TextOut(Handle,XL,Y1,@S1[1],Length(S1));
        end
        else begin
          S1 := '[' + Text;
          TextOut(Handle,XL,Y1,@S1[1],Length(S1));
          SetTextAlign(Handle,TA_RIGHT or TA_BASELINE or TA_NOUPDATECP);
          S1 := ']';
          TextOut(Handle,XR,Y1,@S1[1],Length(S1));
        end;
      end; { case }
    end else begin
      Case FontJustify of
        pjCenter: XL := XI2D((PaintLeft + PaintRight) / 2.0);
        pjRight: XL := XI2D(PaintRight);
        else XL := XI2D(PaintLeft);
      end; { case }
      TextOut(Handle,XL,Y1,@Text[1],Length(Text));
    end; { else }
    SetTextAlign(Handle,SaveTA);
    SetTextColor(Handle,SaveColor);
  end; { if }
  TempFont := SelectObject(Handle,TempFont);
  DeleteObject(TempFont);
end;  { PaintText }

procedure TRaveCustomText.SetFontAttr(Index: TFontAttribute;
                                      Value: TRaveFont);

begin { SetFontAttr }
  If Index in [faAll,faName] then begin
    FFont.Name := Value.Name;
  end; { if }
  If Index in [faAll,faSize] then begin
    FFont.Size := Value.Size;
  end; { if }
  If Index in [faAll,faBold] then begin
    If fsBold in Value.Style then begin
      FFont.Style := FFont.Style + [fsBold];
    end else begin
      FFont.Style := FFont.Style - [fsBold];
    end; { else }
  end; { if }
  If Index in [faAll,faItalic] then begin
    If fsItalic in Value.Style then begin
      FFont.Style := FFont.Style + [fsItalic];
    end else begin
      FFont.Style := FFont.Style - [fsItalic];
    end; { else }
  end; { if }
  If Index in [faAll,faUnderline] then begin
    If fsUnderline in Value.Style then begin
      FFont.Style := FFont.Style + [fsUnderline];
    end else begin
      FFont.Style := FFont.Style - [fsUnderline];
    end; { else }
  end; { if }
  Resize;
end;  { SetFontAttr }

function TRaveCustomText.GetFontAttr(Index: TFontAttribute): TRaveFont;

begin { GetFontAttr }
  If Assigned(FontMirror) then begin
    Result := nil;
  end else begin
    Result := FFont;
  end; { if }
end;  { GetFontAttr }
{$ENDIF}

procedure TRaveCustomText.SetText(Value: string);

begin { SetText }
  If FText <> Value then begin
    FText := Value;
    Invalidate;
  end; { if }
end;  { SetText }

function TRaveCustomText.GetText: string;

begin { GetText }
  Result := FText;
end;  { GetText }

procedure TRaveCustomText.SetForeColor(Value: TColor);

begin { SetForeColor }
  FFont.Color := Value;
  Invalidate;
end;  { SetForeColor }

function TRaveCustomText.GetForeColor: TColor;

begin { GetForeColor }
  If Assigned(FontMirror) then begin
    Result := clNone;
  end else begin
    Result := FFont.Color;
  end; { else }
end;  { GetForeColor }

procedure TRaveCustomText.SetFontMirror(Value: TRaveFontMaster);

begin { SetFontMirror }
  FFontMirror := Value;
  Invalidate;
end;  { SetFontMirror }

procedure TRaveCustomText.SetFont(Value: TRaveFont);

begin { SetFont }
  FFont.Assign(Value);
  Invalidate;
// {$IFDEF DESIGNER}
// comment out because it fixes the stack overflow bug
// when trying to load projects with mirrors set
//    If Assigned(Page.Designer) then begin
//      Page.Designer.Modified;
//    end; { if }
// {$ENDIF}
end;  { SetFont }

procedure TRaveCustomText.SetFontJustify(Value: TPrintJustify);

begin { SetFontJustify }
  If FFontJustify <> Value then begin
    FFontJustify := Value;
    Invalidate;
  end; { if }
end;  { SetFontJustify }

function TRaveCustomText.GetFontJustify: TPrintJustify;

begin { GetFontJustify }
  Result := FFontJustify;
end;  { GetFontJustify }

(*****************************************************************************}
( class TRaveText
(*****************************************************************************)

constructor TRaveText.Create(AOwner: TComponent);

begin { Create }
  inherited Create(AOwner);
  FTruncate := false;
{$IFDEF DESIGNER}
  Width := 1.0;
{$ENDIF}
end;  { Create }

function TRaveText.GetHeight: TRaveUnits;

begin { GetHeight }
  If Assigned(FFontMirror) then begin
    Result := Abs(FFontMirror.FFont.Size) / 60.0;
  end else begin
    Result := Abs(FFont.Size) / 60.0;
  end; { else }
end;  { GetHeight }

{$IFDEF DESIGNER}
procedure TRaveText.CreatePips;

var
  X1: TRaveUnits;
  Y1: TRaveUnits;

begin { CreatePips }
  X1 := PageLeft;
  Y1 := PageTop;
  Page.AddPip(3,self,crSizeWE,X1,Y1 + Height / 2.0);
  Page.AddPip(4,self,crSizeWE,X1 + Width,Y1 + Height / 2.0);
end;  { CreatePips }

procedure TRaveText.UpdatePips;

var
  X1: TRaveUnits;
  Y1: TRaveUnits;

begin { UpdatePips }
  X1 := PageLeft;
  Y1 := PageTop;
  Page.UpdatePip(3,self,X1,Y1 + Height / 2.0);
  Page.UpdatePip(4,self,X1 + Width,Y1 + Height / 2.0);
end;  { UpdatePips }

procedure TRaveText.Paint(Canvas: TCanvas);

var
  Y1: TRaveUnits;
  SaveRgn: HRgn;

begin { Paint }
  Y1 := PageTop;
  SaveRgn := SetClipped(Canvas);
  If CurrentDesigner.IsSelected(self) then begin
    With Canvas do begin
      Pen.Color := ModColor(clSilver);
      Pen.Style := psSolid;
      Pen.Mode := pmCopy;
      Pen.Width := 1;
      Brush.Color := ModColor(clBlack);
      Brush.Style := bsClear;
      Rectangle(XI2D(PageLeft),YI2D(PageTop),XI2D(PageRight) + 1,YI2D(PageBottom) + 1);
    end; { with }
  end; { if }
  PaintText(Canvas.Handle,Text,PageLeft,PageRight,Y1,Truncate);
  SetUnclipped(Canvas,SaveRgn);
end;  { Paint }
{$ENDIF}

procedure TRaveText.Print(Report: TBaseReport);

var
  S1: string;

begin { Print }
  If not AllowPrint then Exit;
  With Report do begin
    S1 := Text;
    DoGetText(S1);
    If Assigned(FontMirror) then begin
      AssignFont(FontMirror.Font);
    end else begin
      AssignFont(Font);
    end; { else }
    FontRotation := Rotation;
    LineTop := PageTop;
    If Truncate then begin { Truncate text }
      S1 := TruncateText(S1,Width);
    end; { if }
    TextFieldWidth := Width;
    PrintJustify(S1,PageLeft,FontJustify,0.0,Width);
  end; { with }
end;  { Print }

(*****************************************************************************}
( class TRaveSection
(*****************************************************************************)

constructor TRaveSection.Create(AOwner: TComponent);

begin { Create }
  inherited Create(AOwner);
  FControlStyle := FControlStyle + [rcsContainer];
{$IFDEF DESIGNER}
  Height := 3.0;
  Width := 3.0;
{$ENDIF}
end;  { Create }

procedure TRaveSection.PrintAll(Report: TBaseReport);

var
  WX1,WY1: TRaveUnits;
  WX2,WY2: TRaveUnits;

begin { PrintAll }
  If not AllowPrint then Exit;

{ Make sure section fits within waste area }
  If WasteFit then begin
    WX1 := Report.LeftWaste + 0.01;
    WY1 := Report.TopWaste + 0.01;
    WX2 := Report.PageWidth - (Report.RightWaste + 0.01);
    WY2 := Report.PageHeight - (Report.BottomWaste + 0.01);
    If FLT(Left,WX1) or FLT(Top,WY1) or FGT(Right,WX2) or FGT(Bottom,WY2) then begin
      SetBoundsRect(RaveRect(MaxF(Left,WX1),MaxF(Top,WY1),
       MinF(Right,WX2),MinF(Bottom,WY2)));
    end; { if }
  end; { if }

  inherited PrintAll(Report);
end;  { PrintAll }

{$IFDEF DESIGNER}
procedure TRaveSection.Paint(Canvas: TCanvas);

begin { Paint }
  With Canvas do begin
    Pen.Color := ModColor(clGray);
    Pen.Style := psDot;
    Pen.Mode := pmCopy;
    Pen.Width := 1;
    Brush.Color := ModColor(clWhite);
    Brush.Style := bsClear;
    Rectangle(XI2D(PageLeft),YI2D(PageTop),XI2D(PageRight) + 1,YI2D(PageBottom) + 1);
  end; { with }
end;  { Paint }
{$ENDIF}

(*****************************************************************************}
( class TRaveBaseImage
(*****************************************************************************)

constructor TRaveBaseImage.Create(AOwner: TComponent);

begin { Create }
  inherited Create(AOwner);
{$IFDEF DESIGNER}
  Height := 3.0;
  Width := 3.0;
{$ENDIF}
end;  { Create }

destructor TRaveBaseImage.Destroy;

begin { Destroy }
  UnloadAltImage;
  inherited Destroy;
end;  { Destroy }

procedure TRaveBaseImage.LoadFromFile(FileName: string);

var
  Stream: TStream;

begin { LoadFromFile }
  If (FileName <> '') and FileExists(FileName) then begin
    Stream := TFileStream.Create(FileName,fmOpenRead);
    try
      LoadFromStream(Stream);
    finally
      Stream.Free;
    end; { tryf }
  end; { if }
end;  { LoadFromFile }

procedure TRaveBaseImage.Changing(OldItem: TRaveComponent;
                                  NewItem: TRaveComponent);

begin { Changing }
  inherited Changing(OldItem,NewItem);
  If Assigned(DataView) and (DataView = OldItem) then begin
    DataView := NewItem as TRaveBaseDataView;
  end; { if }
end;  { Changing }

procedure TRaveBaseImage.SetDataField(Value: TRaveFieldName);

begin { SetDataField }
  FDataField := Value;
  Invalidate;
end;  { SetDataField }

procedure TRaveBaseImage.SetFileLink(Value: TFileName);

begin { SetFileLink }
  Value := Trim(Value);
  If FFileLink <> Value then begin
    FFileLink := Value;
    Invalidate;
  end; { if }
end;  { SetFileLink }

procedure TRaveBaseImage.SetMatchSide(Value: TMatchSide);

begin { SetMatchSide }
  FMatchSide := Value;
  Invalidate;
end;  { SetMatchSide }

{$IFDEF DESIGNER}
procedure TRaveBaseImage.Paint(Canvas: TCanvas);

var
  Dest: TRect;
  W1,H1: integer;
  X1,Y1,X2,Y2: integer;

begin { Paint }
  With Canvas do begin
    Pen.Color := ModColor(clSilver);
    Pen.Mode := pmCopy;
    Pen.Width := 1;
    Brush.Color := ModColor(clBlack);
    Brush.Style := bsClear;
    try
      LoadFromFile(FileLink);
      X1 := XI2D(PageLeft);
      Y1 := YI2D(PageTop);
      X2 := XI2D(PageRight);
      Y2 := YI2D(PageBottom);
      If ImageValid then begin
        W1 := XI2D(Width) - XI2D(0);
        H1 := YI2D(Height) - YI2D(0);
        If CurrentDesigner.IsSelected(self) then begin
          With Canvas do begin
            Pen.Style := psSolid;
            Rectangle(X1,Y1,X2 + 1,Y2 + 1);
          end; { with }
        end; { if }
        Dest := Rect(X1,Y1,X2 + 1,Y2 + 1);
        Case MatchSide of
          msWidth: Dest.Bottom := Dest.Top + ((W1 * ImageHeight) div ImageWidth);
          msHeight: Dest.Right := Dest.Left + ((ImageWidth * H1) div ImageHeight);
          msInside: begin
            If ((ImageWidth * Height) /
             (ImageHeight * Width)) > 1.0 then begin { Adjust height }
              Dest.Bottom := Dest.Top + ((W1 * ImageHeight) div ImageWidth);
            end else begin { Adjust width }
              Dest.Right := Dest.Left + ((ImageWidth * H1) div ImageHeight);
            end; { else }
          end;
        end; { case }
        PaintImage(Canvas,Dest);
      end else begin
        Pen.Style := psDash;
        Rectangle(X1,Y1,X2 + 1,Y2 + 1);
        Pen.Style := psSolid;
        MoveTo(X1,Y1);
        LineTo(X2,Y2);
        MoveTo(X1,Y2);
        LineTo(X2,Y1);
      end; { else }
    finally
      UnloadAltImage;
    end; { tryf }
  end; { with }
end;  { Paint }
{$ENDIF}

procedure TRaveBaseImage.Print(Report: TBaseReport);

var
  X1,Y1,X2,Y2: TRaveUnits;
  Stream: TMemoryStream;
  Field: TRaveDataField;
  ImageFileName: string;

begin { Print }
  If not AllowPrint then Exit;
  try
    If Assigned(DataView) and (DataField <> '') then begin
      Field := DataView.FieldByName(DataField);
      If Field.IsNull then Exit;
      If Field.DataType = dtString then begin
        ImageFileName := ExpandFileName(Field.AsString);
        LoadFromFile(ImageFileName);
      end else begin
        Stream := TMemoryStream.Create;
        try
          Stream.Write(Field.AsBlob^,Field.DataSize);
          Stream.Position := 0;
          LoadFromStream(Stream);
        finally
          Stream.Free;
        end; { tryf }
      end; { else }
    end else begin
      LoadFromFile(FileLink);
    end; { else }
    X1 := PageLeft;
    Y1 := PageTop;
    X2 := PageRight;
    Y2 := PageBottom;
    With Report do begin
      If ImageValid then begin
        Case MatchSide of
          msWidth: Y2 := Y1 + (ImageHeight * Width / ImageWidth);
          msHeight: X2 := X1 + (ImageWidth * Height / ImageHeight);
          msInside: begin
            If ((ImageWidth * (Y2 - Y1)) /
             (ImageHeight * (X2 - X1))) > 1.0 then begin { Adjust height }
              Y2 := Y1 + (ImageHeight * Width / ImageWidth);
            end else begin { Adjust width }
              X2 := X1 + (ImageWidth * Height / ImageHeight);
            end; { else }
          end;
        end; { case }
        PrintImage(Report,X1,Y1,X2,Y2);
      end else begin
        SetPen(clGray,psSolid,1,pmCopy);
        SetBrush(clBlack,bsClear,nil);
        Rectangle(X1,Y1,X2,Y2);
        MoveTo(X1,Y1);
        LineTo(X2,Y2);
        MoveTo(X1,Y2);
        LineTo(X2,Y1);
      end; { else }
    end; { with }
  finally
    UnloadAltImage;
  end; { tryf }
end;  { Print }

function TRaveBaseImage.ImageName: string;

begin { ImageName }
  Result := Trans('Image');
end;  { ImageName }

function TRaveBaseImage.ImageFilter: string;

begin { ImageFilter }
  Result := Trans('All Files') + {Trans-}' (*.*)|*.*';
end;  { ImageFilter }

(*****************************************************************************}
( class TRaveGraphicImage
(*****************************************************************************)

constructor TRaveGraphicImage.Create(AOwner: TComponent);

begin { Create }
  inherited Create(AOwner);
  FImage := CreateGraphic;
end;  { Create }

destructor TRaveGraphicImage.Destroy;

begin { Destroy }
  FImage.Free;
  inherited Destroy;
end;  { Destroy }

procedure TRaveGraphicImage.UnloadAltImage;

begin { UnloadAltImage }
  If Assigned(FAltImage) then begin
    FAltImage.Free;
    FAltImage := nil;
  end; { if }
end;  { UnloadAltImage }

procedure TRaveGraphicImage.LoadFromStream(Stream: TStream);

begin { LoadFromStream }
  UnloadAltImage;
  FAltImage := CreateGraphic;
  FAltImage.LoadFromStream(Stream);
  If not ImageValid then begin { Invalid image format }
    UnloadAltImage;
  end; { if }
end;  { LoadFromStream }

function TRaveGraphicImage.ActiveImage: TGraphic;

begin { ActiveImage }
  If Assigned(FAltImage) then begin
    Result := FAltImage;
  end else begin
    Result := FImage;
  end; { else }
end;  { ActiveImage }

function TRaveGraphicImage.ImageWidth: integer;

begin { ImageWidth }
  Result := ActiveImage.Width;
end;  { ImageWidth }

function TRaveGraphicImage.ImageHeight: integer;

begin { ImageHeight }
  Result := ActiveImage.Height;
end;  { ImageHeight }

{$IFDEF DESIGNER}
procedure TRaveGraphicImage.PaintImage(Canvas: TCanvas;
                                       Dest: TRect);

begin { PaintImage }
  Canvas.StretchDraw(Dest,ActiveImage);
end;  { PaintImage }
{$ENDIF}

procedure TRaveGraphicImage.SetImage(Value: TGraphic);

begin { SetImage }
  FImage.Free;
  FImage := CreateGraphic;
  FImage.Assign(Value);
end;  { SetImage }

(*****************************************************************************}
( class TRaveBitmap
(*****************************************************************************)

function TRaveBitmap.CreateGraphic: TGraphic;

begin { TRaveGraphicImage }
  Result := TBitmap.Create;
end;  { TRaveGraphicImage }

function TRaveBitmap.ImageValid: boolean;

begin { ImageValid }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Result := (ActiveImage <> nil) and ((ActiveImage as TBitmap).Handle <> 0);
  {$ENDIF}
end;  { ImageValid }

procedure TRaveBitmap.PrintImage(Report: TBaseReport;
                                 X1,Y1,X2,Y2: TRaveUnits);

begin { PrintImage }
  Report.PrintBitmapRect(X1,Y1,X2,Y2,ActiveImage as TBitmap);
end;  { PrintImage }

function TRaveBitmap.ImageName: string;

begin { ImageName }
  Result := Trans('Bitmap');
end;  { ImageName }

function TRaveBitmap.ImageFilter: string;

begin { ImageFilter }
  Result := Trans('Bitmap Files') + {Trans-}' (*.bmp)|*.bmp';
end;  { ImageFilter }

(*****************************************************************************}
( class TRaveMetaFile
(*****************************************************************************)

function TRaveMetaFile.CreateGraphic: TGraphic;

begin { TRaveGraphicImage }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Result := TMetaFile.Create;
  {$ENDIF}
end;  { TRaveGraphicImage }

function TRaveMetaFile.ImageValid: boolean;

begin { ImageValid }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Result := (ActiveImage <> nil) and ((ActiveImage as TMetaFile).Handle <> 0);
  {$ENDIF}
end;  { ImageValid }

procedure TRaveMetaFile.PrintImage(Report: TBaseReport;
                                   X1,Y1,X2,Y2: TRaveUnits);

var
  Rect: TRect;

begin { PrintImage }
  Rect := Report.CreateRect(X1,Y1,X2,Y2);
  Report.StretchDraw(Rect,ActiveImage);
end;  { PrintImage }

function TRaveMetaFile.ImageName: string;

begin { ImageName }
  Result := Trans('MetaFile');
end;  { ImageName }

function TRaveMetaFile.ImageFilter: string;

begin { ImageFilter }
  Result := Trans('MetaFile Files') + {Trans-}'(*.emf;*.wmf)|*.emf;*.wmf';
end;  { ImageFilter }

(*****************************************************************************}
( class TRaveMailMergeList
(*****************************************************************************)

type
TRaveMailMergeList = class(TRavePersistentList)
public
  function CreateItem(ItemClass: string;
                      RootOwner: TComponent): TPersistent; override;
end; { TRaveMailMergeList }

function TRaveMailMergeList.CreateItem(ItemClass: string;
                                       RootOwner: TComponent): TPersistent;

begin { CreateItem }
  Result := TRaveMailMergeItem.Create;
end;  { CreateItem }

(*****************************************************************************}
( class TRaveMemo
(*****************************************************************************)

constructor TRaveMemo.Create(AOwner: TComponent);

begin { Create }
  inherited Create(AOwner);
  Height := 2.0;
  Width := 3.0;
  FMailMergeItems := TRaveMailMergeList.Create;
  FExpandParent := true;
end;  { Create }

destructor TRaveMemo.Destroy;

begin { Destroy }
  FreeMemoBuf;
  ClearObjectList(FMailMergeItems);
  FMailMergeItems.Free;
{$IFDEF DESIGNER}
  If Assigned(LineList) then begin
    LineList.Free;
    LineList := nil;
  end; { if }
{$ENDIF}
  inherited Destroy;
end;  { Destroy }

procedure TRaveMemo.SetMailMergeItems(Value: TRavePersistentList);

var
  I1: integer;
  MM1: TRaveMailMergeItem;
  MM2: TRaveMailMergeItem;

begin { SetMailMergeItems }
  ClearObjectList(FMailMergeItems);
  For I1 := 0 to Value.Count - 1 do begin
    MM1 := TRaveMailMergeItem(Value[I1]);
    MM2 := TRaveMailMergeItem.Create;
    MM2.SearchToken := MM1.SearchToken;
    MM2.ReplaceString := MM1.ReplaceString;
    MM2.CaseMatters := MM1.CaseMatters;
    FMailMergeItems.Add(MM2);
  end; { for }
end;  { SetMailMergeItems }

{$IFDEF DESIGNER}
procedure TRaveMemo.Resize;

begin { Resize }
  If Assigned(LineList) then begin
    LineList.Free;
    LineList := nil;
  end; { if }
  inherited Resize;
end;  { Resize }

procedure TRaveMemo.SetText(Value: string);

begin { SetText }
  If Assigned(LineList) then begin
    LineList.Free;
    LineList := nil;
  end; { if }
  inherited SetText(Value);
end;  { SetText }

procedure TRaveMemo.Paint(Canvas: TCanvas);

var
  EOL: boolean;
  I1: integer;
  X1,X2,Y1: TRaveUnits;
  SaveRgn: HRgn;
  LastPos: integer;

begin { Paint }
  If not Assigned(LineList) then begin
    LineList := TStringList.Create;
    MemoBuf := TMemoBuf.Create;
    try
      If Assigned(FontMirror) then begin
        TRaveProjectManager(Project).BaseReport.AssignFont(FontMirror.Font);
      end else begin
        TRaveProjectManager(Project).BaseReport.AssignFont(Font);
      end; { else }
      MemoBuf.BaseReport := TRaveProjectManager(Project).BaseReport;
      MemoBuf.PrintStart := 0.0;
      MemoBuf.PrintEnd := Width;
      MemoBuf.Text := Text;
      With MemoBuf do begin
        LastPos := -1;
        While (Pos < Size) and (Pos <> LastPos) do begin
          LastPos := Pos;
          LineList.Add(GetNextLine(EOL));
        end; { while }
      end; { with }
    finally
      MemoBuf.Free;
      MemoBuf := nil;
    end; { tryf }
  end; { if }

{ Paint LineList }
  X1 := PageLeft;
  X2 := PageRight;
  Y1 := PageTop;
  SaveRgn := SetClipped(Canvas);
  If CurrentDesigner.IsSelected(self) then begin
    With Canvas do begin
      Pen.Color := ModColor(clSilver);
      Pen.Style := psSolid;
      Pen.Mode := pmCopy;
      Pen.Width := 1;
      Brush.Color := ModColor(clBlack);
      Brush.Style := bsClear;
      Rectangle(XI2D(X1),YI2D(Y1),XI2D(X2) + 1,YI2D(PageBottom) + 1);
    end; { with }
  end; { if }
  For I1 := 0 to LineList.Count - 1 do begin
    PaintText(Canvas.Handle,LineList[I1],X1,X2,Y1);
  end; { for }
  SetUnclipped(Canvas,SaveRgn);
end;  { Paint }
{$ENDIF}

procedure TRaveMemo.InitMemoBuf;
var
  I1: integer;
  MMItem: TRaveMailMergeItem;
begin { InitMemoBuf }
  If not Prepared then begin
    MemoBuf := TMemoBuf.Create;
    MemoBuf.BaseReport := TRaveProjectManager(Project).BaseReport;
    MemoBuf.PrintStart := PageLeft;
    MemoBuf.PrintEnd := PageRight;
    MemoBuf.Justify := FontJustify;
    If ContainsRTF then begin
      MemoBuf.RTFText := Text;
    end else begin
      MemoBuf.Text := Text;
    end; { else }
    For I1 := 0 to MailMergeItems.Count - 1 do begin { Do mail merge }
      MMItem :=TRaveMailMergeItem(MailMergeItems[I1]);
      MemoBuf.ReplaceAll(MMItem.SearchToken,ProcessDataStr(self,nil,
       MMItem.ReplaceString),MMItem.CaseMatters);
    end; { for }
    Prepared := true;
  end; { if }
end;  { InitMemoBuf }

procedure TRaveMemo.FreeMemoBuf;

begin { FreeMemoBuf }
  If Prepared then begin
    MemoBuf.Free;
    MemoBuf := nil;
    Prepared := false;
  end; { if }
end;  { FreeMemoBuf }

function TRaveMemo.GetDonePrinting: boolean;

begin { GetDonePrinting }
  Result := not Assigned(MemoBuf) or MemoBuf.Empty;
end;  { GetDonePrinting }

procedure TRaveMemo.BeforeReport;

begin { BeforeReport }
  Prepared := false;
  SaveAnchor := Anchor;
  If ExpandParent then begin
    Anchor := TRaveAnchor(Ord(anvStretch) * 16 + Ord(GetHAnchor));
  end; { if }
  inherited BeforeReport;
end;  { BeforeReport }

procedure TRaveMemo.AfterReport;

begin { AfterReport }
  Anchor := SaveAnchor;
  inherited AfterReport;
end;  { AfterReport }

procedure TRaveMemo.SetMemoText(Value: TRaveMemoString);

begin { SetMemoText }
  SetText(Value);
end;  { SetMemoText }

function TRaveMemo.GetMemoText: TRaveMemoString;

begin { GetMemoText }
  Result := GetText;
end;  { GetMemoText }

procedure TRaveMemo.Print(Report: TBaseReport);

begin { Print }
  If not AllowPrint then Exit;
  With Report do begin
    InitMemoBuf;
    If Assigned(FontMirror) then begin
      AssignFont(FontMirror.Font);
    end else begin
      AssignFont(Font);
    end; { else }
    LineTop := PageTop;
    MemoBuf.PrintStart := PageLeft;
    MemoBuf.PrintEnd := PageRight;
    MemoBuf.PrintHeight(Height,false);
    If MemoBuf.Empty or Truncate then begin
      FreeMemoBuf;
    end; { if }
  end; { with }
end;  { Print }

procedure TRaveMemo.InitData;

begin { InitData }
  InitMemoBuf;
end;  { InitData }

function TRaveMemo.HeightToPrint: TRaveUnits;

begin { HeightToPrint }
  If not Assigned(MemoBuf) then begin
    Result := 0.0;
  end else begin
    With TRaveProjectManager(Project).BaseReport do begin
      If Assigned(FontMirror) then begin
        AssignFont(FontMirror.Font);
      end else begin
        AssignFont(Font);
      end; { else }
      ResetLineHeight;
      If ExpandParent then begin
        Result := MemoBuf.MemoHeightLeft;
      end else begin
        Result := AdjHeight;
      end; { else }
    end; { with }
  end; { else }
end;  { HeightToPrint }

initialization
  RegisterProc('RVCL',RaveRegister);
end.
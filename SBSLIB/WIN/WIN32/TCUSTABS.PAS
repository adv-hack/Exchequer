unit TCustAbs;

interface

uses
  Graphics;

type
  { Abstract Object Interface used for Label customisation }
  { Must be kept in sync with Component Definition in TCustom.Pas }
  TAbsCustomText = Class(TObject)
  Protected
    Function  GetCaption : ShortString; Virtual; Abstract;
    Procedure SetCaption(Value : ShortString); Virtual; Abstract;
    Function  GetColor : TColor; Virtual; Abstract;
    Procedure SetColor(Value : TColor); Virtual; Abstract;
    Function  GetName : TFontName; Virtual; Abstract;
    Procedure SetName(Value : TFontName); Virtual; Abstract;
    Function  GetSize : Integer; Virtual; Abstract;
    Procedure SetSize(Value : Integer); Virtual; Abstract;
    Function  GetStyle : TFontStyles; Virtual; Abstract;
    Procedure SetStyle(Value : TFontStyles); Virtual; Abstract;
    Function  GetTextId : LongInt; Virtual; Abstract;
    Function  GetWindowId : LongInt; Virtual; Abstract;
  Published
    property Caption: ShortString read GetCaption Write SetCaption;
    property Color: TColor read GetColor write SetColor;
    property Name: TFontName read GetName write SetName;
    property Size: Integer read GetSize write SetSize;
    property Style: TFontStyles read GetStyle write SetStyle;
    property TextId : LongInt Read GetTextId;
    property WindowId : LongInt Read GetWindowId;
  End; { TAbsCustomText }

implementation

end.

unit WinGReg ;

interface

uses Classes, DsgnIntf, Dialogs ;

type
  TPaletteSourceProperty = class( TComponentProperty )
    function GetValue : string ; override ;
    procedure GetValues( Proc : TGetStrProc ) ; override ;
    procedure SetValue( const Value : string ) ; override ;
  end ;

  { TDIBProperty }

  TDIBProperty = class(TClassProperty)
  public
    procedure Edit ; override ;
    function GetAttributes : TPropertyAttributes ; override ;
    function GetValue : string ; override ;
    procedure SetValue( const Value : string ) ; override ;
  end ;

  { TRealProperty }
  TRealProperty = class( TFloatProperty )
    function GetValue : string ; override ;
  end ;

  { TSpriteEditor }
  TSpriteEditor = class( TComponentEditor )
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  { TSpriteSurfaceEditor }
  TSpriteSurfaceEditor = class( TComponentEditor )
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;


procedure Register ;

implementation

uses SysUtils, Graphics, Controls, PicEdit, Forms, WinG, DIBBrwse, LibConst ;

{$IFDEF Win32}
{$R WinG32.res}
{$ELSE}
{$R WinG.res}
{$ENDIF}

function TPaletteSourceProperty.GetValue : string ;

begin
  if GetOrdValue = 0 then Result := '(Background)' else
    Result := inherited GetValue ;
end ;


procedure TPaletteSourceProperty.GetValues( Proc : TGetStrProc ) ;

begin
  Proc( '(Background)' ) ;
  inherited GetValues( Proc ) ;
end ;


procedure TPaletteSourceProperty.SetValue( const Value : string ) ;

begin
  if UpperCase( Value ) = '(BACKGROUND)' then SetOrdValue( 0 ) else
    inherited SetValue( Value ) ;
end ;

{ TDIBProperty }

procedure TDIBProperty.Edit ;
begin
  with TDIBBrowserForm.Create( NIL ) do try
    DIB := TDIB( GetOrdValue ) ;
    if ShowModal = mrOK then SetOrdValue( longint( DIB ) ) ;
  finally
    Release ;
  end ;
end ;

function TDIBProperty.GetAttributes: TPropertyAttributes ;
begin
  Result := [paDialog] ;
end ;

function TDIBProperty.GetValue: string ;
var DIB : TDIB ;
begin
  DIB := TDIB( GetOrdValue ) ;
  if ( DIB = nil ) or DIB.Empty then
    Result := LoadStr( srNone ) else
    Result := '(' + DIB.ClassName + ')' ;
end ;

procedure TDIBProperty.SetValue( const Value: string ) ;
begin
  if Value = '' then SetOrdValue( 0 ) ;
end ;

{ TRealProperty }

function TRealProperty.GetValue : string ;

begin
  Result := FormatFloat( '0.####', Round( GetFloatValue * 10000 ) / 10000 ) ;
end ;


{ TSpriteEditor }

procedure TSpriteEditor.ExecuteVerb(Index: Integer);
begin
  with TDIBBrowserForm.Create( NIL ) do try
    DIB.Assign( ( Component as TSprite ).Image ) ;
    if ShowModal = mrOK then TSprite( Component ).Image := DIB ;
  finally
    Release ;
  end ;
end;


function TSpriteEditor.GetVerb(Index: Integer): string;
begin
  Result := 'Edit Image...' ;
end;

function TSpriteEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;


{ TSpriteSurfaceEditor }

procedure TSpriteSurfaceEditor.ExecuteVerb(Index: Integer);
begin
  with TDIBBrowserForm.Create( NIL ) do try
    DIB.Assign( ( Component as TSpriteSurface ).Background ) ;
    if ShowModal = mrOK then TSpriteSurface( Component ).Background := DIB ;
  finally
    Release ;
  end ;
end;


function TSpriteSurfaceEditor.GetVerb(Index: Integer): string;
begin
  Result := 'Edit Background...' ;
end;


function TSpriteSurfaceEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;


{ IDE Register procedure }

procedure Register ;

begin
  RegisterComponents( 'WinG', [ TWinGSurface, TSpriteSurface, TSprite ] ) ;
  RegisterPropertyEditor( TypeInfo( TSpriteAbs ), TSpriteSurface,
                          'PaletteSource', TPaletteSourceProperty ) ;
  RegisterPropertyEditor( TypeInfo( TDIB ), NIL, '', TDIBProperty ) ;
  RegisterPropertyEditor( TypeInfo( TGraphic ), TSpriteSurface, 'Background', TDIBProperty ) ;
  RegisterPropertyEditor( TypeInfo( TGraphic ), TSprite, 'Image', TDIBProperty ) ;
  RegisterPropertyEditor( TypeInfo( Double ), TSprite, '', TRealProperty ) ;
  RegisterPropertyEditor( TypeInfo( Single ), TSprite, '', TRealProperty ) ;
  RegisterComponentEditor( TSprite, TSpriteEditor ) ;
  RegisterComponentEditor( TSpriteSurface, TSpriteSurfaceEditor ) ;
  TPicture.RegisterFileFormat( 'dib', 'Device-Independant Bitmap', TDIB ) ;
  Application.OnIdle := NIL ;
  Application.OnMessage := NIL ;
end ;

end.

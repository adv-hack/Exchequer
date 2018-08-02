unit DIBBrwse ;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, FileCtrl, WinG ;

type
  TDIBBrowserForm = class(TForm)
    FileListBox1: TFileListBox ;
    DirectoryListBox1: TDirectoryListBox ;
    DriveComboBox1: TDriveComboBox ;
    OkBtn: TBitBtn;
    BitBtn2: TBitBtn ;
    FilenameLbl: TLabel;
    Bevel1: TBevel ;
    Shape1: TShape ;
    SaveBtn: TBitBtn;
    ClearBtn: TBitBtn;
    SaveDialog: TSaveDialog;
    procedure FileListBox1Click(Sender: TObject) ;
    procedure FormPaint(Sender: TObject) ;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
  private
    { Private declarations }
    FDIB : TDIB ;
    Msg  : string ;
    procedure SetDIB( Value : TDIB ) ;
    procedure wmQueryNewPalette( var Msg : TMessage ) ; message wm_QueryNewPalette ;
    procedure wmPaletteChanged( var Msg : TMessage ) ; message wm_PaletteChanged ;
  public
    { Public declarations }
    property DIB : TDIB read FDIB write SetDIB ;
  end ;

var
  DIBBrowserForm: TDIBBrowserForm ;

implementation

{$R *.DFM}

uses LibConst ;

procedure TDIBBrowserForm.SetDIB( Value : TDIB ) ;

begin
  if FDIB <> Value then begin
    if Value = NIL then begin
      Msg := LoadStr( srNone ) ;
      FileListBox1.ItemIndex := -1 ;
      FilenameLbl.Caption := '' ;
    end ;
    FDIB.Assign( Value ) ;
    SaveBtn.Enabled := not FDIB.Empty ;
    ClearBtn.Enabled := SaveBtn.Enabled ;
    Shape1.Invalidate ;
  end ;
end ;

procedure TDIBBrowserForm.wmQueryNewPalette( var Msg : TMessage ) ;
var OldPalette : HPalette ;
begin
  Msg.Result := 0 ;
  if not FDIB.Empty then begin
    OldPalette := SelectPalette( Canvas.Handle, FDIB.Palette, false ) ;
    try
      Msg.Result := RealizePalette( Canvas.Handle ) ;
      if Msg.Result > 0 then Shape1.Invalidate ;
    finally
      SelectPalette( Canvas.Handle, OldPalette, true ) ;
    end ;
  end ;
end ;

procedure TDIBBrowserForm.wmPaletteChanged( var Msg : TMessage ) ;

begin
  if Msg.wParam <> Handle then wmQueryNewPalette( Msg ) ;
end ;

procedure TDIBBrowserForm.FileListBox1Click(Sender: TObject) ;

begin
  FilenameLbl.Caption := FileListBox1.FileName ;
  try
    try
      FDIB.LoadFromFile( FileListBox1.FileName ) ;
    except
      on E: EWinGError do begin
        DIB := NIL ;
        Msg := Format( '(%s)', [ E.Message ] ) ;
        Msg[ 2 ] := UpCase( Msg[ 2 ] ) ;
      end ;
    end ;
  finally
    Shape1.Invalidate ;
    SaveBtn.Enabled := not FDIB.Empty ;
    ClearBtn.Enabled := SaveBtn.Enabled ;
  end ;
end ;

procedure TDIBBrowserForm.FormPaint(Sender: TObject) ;
var
  DrawRect: TRect ;
  SNone: string ;
  OldPalette : HPalette ;
begin
  Canvas.Brush.Color := Color ;
  with Shape1 do
    DrawRect := Rect( Left, Top, Left + Width, Top + Height ) ;
  if FDIB.Width > 0 then
  begin
    OldPalette := SelectPalette( Canvas.Handle, FDIB.Palette, false ) ;
    try
      RealizePalette( Canvas.Handle ) ;
      with DrawRect do
        if ( DIB.Width > Right - Left ) or ( FDIB.Height > Bottom - Top ) then
        begin
          if FDIB.Width > FDIB.Height then
            Bottom := Top + MulDiv( FDIB.Height, Right - Left, FDIB.Width )
          else
            Right := Left + MulDiv( FDIB.Width, Bottom - Top, FDIB.Height ) ;
          Canvas.StretchDraw( DrawRect, FDIB )  ;
        end
        else
          with DrawRect do
            Canvas.Draw( Left + ( Right - Left - FDIB.Width ) div 2,
                         Top + ( Bottom - Top - FDIB.Height ) div 2, FDIB ) ;
    finally
      SelectPalette( Canvas.Handle, OldPalette, true ) ;
    end ;
  end
  else
    with DrawRect, Canvas do
      TextOut( Left + ( Right - Left - TextWidth( Msg ) ) div 2,
               Top + ( Bottom - Top - TextHeight( Msg ) ) div 2, Msg ) ;
end ;

procedure TDIBBrowserForm.FormCreate(Sender: TObject);
begin
  FDIB := TDIB.Create ;
  DIB := NIL ;
  if ( Left + Width > Screen.Width ) then Left := Screen.Width - Width - 4 ;
  if ( Top + Height > Screen.Height ) then Top := Screen.Height - Height - 4 ;
end;

procedure TDIBBrowserForm.FormDestroy(Sender: TObject);
begin
  FDIB.Free ;
end;

procedure TDIBBrowserForm.SaveBtnClick(Sender: TObject);
begin
  if not FDIB.Empty and SaveDialog.Execute then begin
    FDIB.SaveToFile( SaveDialog.Filename ) ;
    FileListBox1.Update ;
  end ;
end;

procedure TDIBBrowserForm.ClearBtnClick(Sender: TObject);
begin
  DIB := NIL ;
end;

end.

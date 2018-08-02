unit FontDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, StrUtil;

type
  TfrmFontDlg = class(TForm)
    lstFont: TListBox;
    lstStyle: TListBox;
    lstSize: TListBox;
    edFont: TEdit;
    edStyle: TEdit;
    edSize: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    Bevel1: TBevel;
    cbStrikeout: TCheckBox;
    Label1: TLabel;
    cbUnderLine: TCheckBox;
    Label2: TLabel;
    colFont: TColorBox;
    Bevel2: TBevel;
    panSample: TPanel;
    Label3: TLabel;
    lName: TLabel;
    lStyle: TLabel;
    lSize: TLabel;
    procedure cbStrikeoutClick(Sender: TObject);
    procedure cbUnderLineClick(Sender: TObject);
    procedure lstFontClick(Sender: TObject);
    procedure lstStyleClick(Sender: TObject);
    procedure lstSizeClick(Sender: TObject);
    procedure colFontChange(Sender: TObject);
    procedure edFontChange(Sender: TObject);
    procedure edStyleChange(Sender: TObject);
    procedure edSizeChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TMyFontDialog = class
  private
    fFont: TFont;
    fBackground : TColor;
    fChangeStyle : boolean;
    frmFontDlg: TfrmFontDlg;
    fChangeName: boolean;
    fChangeSize: boolean;
    procedure SetFont(const TheFont: TFont);
    procedure SetBackground(const Value: TColor);
    procedure SetChangeStyle(const Value: boolean);
    procedure SetChangeName(const Value: boolean);
    procedure SetChangeSize(const Value: boolean);
  public
    constructor Create;
    destructor Destroy; override;
    function Execute : boolean;
    property Font : TFont read fFont write SetFont;
    property Background : TColor read fBackground write SetBackground;
    property ChangeStyle : boolean read fChangeStyle write SetChangeStyle;
    property ChangeName : boolean read fChangeName write SetChangeName;
    property ChangeSize : boolean read fChangeSize write SetChangeSize;
  end;

  Function oFontDialog : TMyFontDialog;

implementation

{$R *.dfm}

uses
  FontProc;

Var
  oLFontDialog : TMyFontDialog;

// PS 25/05/2016 2016-R2 ABSEXCH-14518: Added Function to get Fonts List from system API
Function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
var
  S: TStrings;
  Temp: string;
begin
  S := TStrings(Data);
  Temp := LogFont.lfFaceName;
  if (S.Count = 0) or (AnsiCompareText(S[S.Count-1], Temp) <> 0) then
    S.Add(Temp);
  Result := 1;
end;

procedure CollectFonts(FontList: TStringList);
var
  DC: HDC;
  LFont: TLogFont;
begin
  DC := GetDC(0);
  FillChar(LFont, sizeof(LFont), 0);
  LFont.lfCharset := DEFAULT_CHARSET;
  EnumFontFamiliesEx(DC, LFont, @EnumFontsProc, Windows.LPARAM(FontList), 0);
  ReleaseDC(0, DC);
end;

Function oFontDialog : TMyFontDialog;
// Function Called to create Object
Begin{oFontDialog}
  if (not Assigned(oLFontDialog)) then begin
    oLFontDialog := TMyFontDialog.Create;
  end;{if}
  Result := oLFontDialog;
End;{oFontDialog}

{ TMyFontDialog }

constructor TMyFontDialog.Create;
begin
 //
 fFont := TFont.Create;
 fFont.Name := 'Arial';
 fFont.Size := 8;
 fFont.Style := [];
 fFont.Color := clBlack;

 fBackground := clBtnFace;

 fChangeStyle := TRUE;
 fChangeName := TRUE;
 fChangeSize := TRUE;
end;

destructor TMyFontDialog.Destroy;
begin
  fFont.Free;
  inherited;
end;

function TMyFontDialog.Execute: boolean;
var
  FSysFontList: TStringList;
begin
  FSysFontList := TStringList.Create;
  CollectFonts(FSysFontList);
  FSysFontList.Sorted := True;

  frmFontDlg := TfrmFontDlg.Create(application);
  try
    with frmFontDlg do begin

      //GS 21/10/2011 ABSEXCH-11614
      //For some reason.. when windows font sizes are set to "medium - 125%"
      //fFont.Size returns 7; a value that is not present in the font size cbo box
      //(min val is 8), code attempts to find '7' and returns an index of -1

      //this inebitably results in an index out of bounds error

      //CAUSE: setting the font size to "medium - 125%" will modify the .font property of the "panFields" control
      //changing its font size from 8 to 7; the font object of this control is then copied so the user can
      //customise a font object using the option dialog. when the option form initialises, it sets the values of the controls
      //to the values currently being used by the font object - this is where it attempts to set the 'size' cbo box
      //to the value of '7'

      //to prevent this error from occuring (as we cannot stop windows from modifying the property values of our form controls!!)
      //we will make sure the font property is equal or above a minimum value of 8
      if fFont.Size < 8 then
      begin
        fFont.Size := 8;
      end;

      panSample.Font.Assign(fFont);
      panSample.Color := fBackground;

      // PS 25/05/2016 2016-R2 ABSEXCH-14518: Added Font list from Widnows API
      lstFont.Items := FSysFontList;
      lstFont.Items.Delete(lstFont.Items.IndexOf('Default'));
      lstFont.ItemIndex := lstFont.Items.IndexOf(fFont.Name);
      lstFontClick(lstFont);

      BuildFontSizeList(TStringList(lstSize.Items), fFont.Name);
      lstSize.ItemIndex := lstSize.Items.IndexOf(IntToStr(fFont.Size));
      lstSizeClick(lstSize);

      lstStyle.ItemIndex := GetFontStyleIndexFrom(fFont);
      lstStyleClick(lstStyle);

      cbStrikeout.Checked := fsStrikeout in fFont.Style;
      cbUnderline.Checked := fsUnderline in fFont.Style;

      colFont.Selected := fFont.color;

      // disable parts
      lName.enabled := fChangeName;
      edFont.enabled := fChangeName;
      lstFont.enabled := fChangeName;

      lStyle.enabled := fChangeStyle;
      edStyle.enabled := fChangeStyle;
      lstStyle.enabled := fChangeStyle;
      cbUnderline.enabled := fChangeStyle;
      cbStrikeout.enabled := fChangeStyle;

      lSize.enabled := fChangeSize;
      edSize.enabled := fChangeSize;
      lstSize.enabled := fChangeSize;


//      edFont.Text := fFont.Name;
//      edSize.Text := IntToStr(fFont.Size);
      Result := ShowModal = mrOK;
      if Result then fFont.Assign(panSample.Font);
    end;{with}
  finally
    FreeAndNil(FSysFontList);
    frmFontDlg.Release;
    fChangeStyle := TRUE;
    fChangeName := TRUE;
    fChangeSize := TRUE;
  end;{try}
end;

procedure TMyFontDialog.SetBackground(const Value: TColor);
begin
  fBackground := Value;
end;

procedure TMyFontDialog.SetChangeName(const Value: boolean);
begin
  fChangeName := Value;
end;

procedure TMyFontDialog.SetChangeSize(const Value: boolean);
begin
  fChangeSize := Value;
end;

procedure TMyFontDialog.SetChangeStyle(const Value: boolean);
begin
  fChangeStyle := Value;
end;

procedure TMyFontDialog.SetFont(const TheFont: TFont);
begin
  fFont.Assign(TheFont);
end;

procedure TfrmFontDlg.cbStrikeoutClick(Sender: TObject);
begin
  if cbStrikeout.Checked then panSample.Font.style := panSample.Font.style + [fsStrikeOut]
  else panSample.Font.style := panSample.Font.style - [fsStrikeOut];
end;

procedure TfrmFontDlg.cbUnderLineClick(Sender: TObject);
begin
  if cbUnderline.Checked then panSample.Font.style := panSample.Font.style + [fsUnderline]
  else panSample.Font.style := panSample.Font.style - [fsUnderline];
end;

procedure TfrmFontDlg.lstFontClick(Sender: TObject);
begin
  edFont.Text := lstFont.Items[lstFont.itemindex];
  panSample.Font.Name := edFont.Text;
  lstSize.ItemIndex := BuildFontSizeList(TStringList(lstSize.Items), edFont.Text);
  lstSizeClick(lstSize);
end;

procedure TfrmFontDlg.lstStyleClick(Sender: TObject);
begin
  edStyle.Text := lstStyle.Items[lstStyle.itemindex];
  panSample.Font.Style := GetFontStyleFromIndex(lstStyle.itemindex);
  cbStrikeoutClick(cbStrikeout);
  cbUnderLineClick(cbUnderLine);
end;

procedure TfrmFontDlg.lstSizeClick(Sender: TObject);
begin
  if lstSize.Items.Count = 0 then edSize.Text := ''
  else begin
    edSize.Text := lstSize.Items[lstSize.itemindex];
    panSample.Font.Size := StrToIntDef(edSize.Text,8);
  end;{if}
end;

procedure TfrmFontDlg.colFontChange(Sender: TObject);
begin
  panSample.Font.Color := colFont.Selected;
end;

procedure TfrmFontDlg.edFontChange(Sender: TObject);
var
  iIndex : integer;
begin
  iIndex := FindCloseMatch(edFont.Text, lstFont.Items);
  if iIndex >= 0 then begin
    lstFont.ItemIndex := iIndex;
    panSample.Font.Name := lstFont.Items[lstFont.ItemIndex];
  end;{if}
end;

procedure TfrmFontDlg.edStyleChange(Sender: TObject);
var
  iIndex : integer;
begin
  iIndex := FindCloseMatch(edStyle.Text, lstStyle.Items);
  if iIndex >= 0 then begin
    lstStyle.ItemIndex := iIndex;
    panSample.Font.Style := GetFontStyleFromIndex(lstStyle.itemindex);
    cbStrikeoutClick(cbStrikeout);
    cbUnderLineClick(cbUnderLine);
  end;{if}
end;

procedure TfrmFontDlg.edSizeChange(Sender: TObject);
var
  iIndex : integer;
begin
  iIndex := FindCloseMatch(edSize.Text, lstSize.Items);
  if iIndex >= 0 then begin
    lstSize.ItemIndex := iIndex;
    panSample.Font.Size := StrToIntDef(lstSize.Items[lstSize.ItemIndex],8);
  end;
end;

Initialization
  oLFontDialog := NIL;

Finalization
  FreeAndNIL(oLFontDialog);


end.

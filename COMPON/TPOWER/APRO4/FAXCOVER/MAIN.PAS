unit Main;

{$I AWDEFINE.INC}

interface

uses
  {$IFDEF Win32} Windows, {$ELSE} WinTypes, WinProcs, {$ENDIF}
  SysUtils, Classes, Graphics, Forms, Controls, Menus, StdCtrls,
  AdMeter, FDUtils, FDConvrt, FaxField, FDOption, FDRepTag,
  AdAbout, Dialogs, Buttons, Messages, ExtCtrls, PageForm, AdFaxCvt, OoMisc;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    miFileNew: TMenuItem;
    miFileOpen: TMenuItem;
    miFileClose: TMenuItem;
    Window1: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    miFileExit: TMenuItem;
    miWindowCascade: TMenuItem;
    miWindowTile: TMenuItem;
    miWindowArrangeIcons: TMenuItem;
    miHelpAbout: TMenuItem;
    OpenDialog: TOpenDialog;
    miFileSave: TMenuItem;
    miFileSaveAs: TMenuItem;
    miWindowMinimize: TMenuItem;
    SpeedPanel: TPanel;
    OpenBtn: TSpeedButton;
    SaveBtn: TSpeedButton;
    ExitBtn: TSpeedButton;
    NewBtn: TSpeedButton;
    StatusPanel: TPanel;
    SaveDialog: TSaveDialog;
    Panel1: TPanel;
    PositionLbl: TLabel;
    Panel2: TPanel;
    Label1: TLabel;
    SaveStatusImage: TImage;
    DesignModeBtn: TSpeedButton;
    EditModeBtn: TSpeedButton;
    miCreateAPF: TMenuItem;
    N3: TMenuItem;
    FaxConverter: TApdFaxConverter;
    ProgressPanel: TPanel;
    N4: TMenuItem;
    miConvertFCPtoAPF: TMenuItem;
    Options1: TMenuItem;
    miPageLayout: TMenuItem;
    miReplacementTags: TMenuItem;
    N2: TMenuItem;
    miDesignMode: TMenuItem;
    miEditMode: TMenuItem;
    Help2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure miFileNewClick(Sender: TObject);
    procedure miWindowCascadeClick(Sender: TObject);
    procedure UpdateMenuItems(Sender: TObject);
    procedure miWindowTileClick(Sender: TObject);
    procedure miWindowArrangeIconsClick(Sender: TObject);
    procedure miFileCloseClick(Sender: TObject);
    procedure miFileOpenClick(Sender: TObject);
    procedure miFileExitClick(Sender: TObject);
    procedure miFileSaveClick(Sender: TObject);
    procedure miFileSaveAsClick(Sender: TObject);
    procedure miWindowMinimizeClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miHelpAboutClick(Sender: TObject);
    procedure DesignModeBtnClick(Sender: TObject);
    procedure EditModeBtnClick(Sender: TObject);
    procedure miCreateAPFClick(Sender: TObject);
    procedure miPageLayoutClick(Sender: TObject);
    procedure miReplacementTagsClick(Sender: TObject);
    procedure Help2Click(Sender: TObject);
    procedure miConvertFCPtoAPFClick(Sender: TObject);

    { If additional methods are added, the IDE won't be able to find
      the methods.  This is due to a compiler/IDE bug that doesn't
      handle IFDEFs well in the method declarations.  If you must
      add more methods, move them above this comment and move the
      methods themselves to above the FaxConverterStatus method }
    {$IFDEF DELPHI3}
    procedure FaxConverterStatus(F: TObject; Starting, Ending: Boolean;
      PagesConverted, LinesConverted, BytesConverted,
      BytesToConvert: Integer; var Abort: Boolean);
    {$ELSE}
    procedure FaxConverterStatus(F: TObject; Starting, Ending: Boolean;
      PagesConverted, LinesConverted: Integer; BytesConverted,
      BytesToConvert: Longint; var Abort: Boolean);
    {$ENDIF}

  private
    ProgressBar : TApdMeter;
    function CreateMDIChild(const Name: string) : TCoverPageForm;
    procedure SaveCoverPage(const FileName : string; PageForm : TCoverPageForm);
  public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

function TMainForm.CreateMDIChild(const Name: string) : TCoverPageForm;
begin
  {create a new MDI child window}
  Result := TCoverPageForm.Create(Application);
  Result .PathName := Name;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Screen.OnActiveFormChange := UpdateMenuItems;
end;

procedure TMainForm.miFileCloseClick(Sender: TObject);
begin
  if ActiveMDIChild is TCoverPageForm then
    ActiveMDIChild.Close;
end;

procedure TMainForm.miFileOpenClick(Sender: TObject);
var
  PageForm : TCoverPageForm;
  Stream   : TFileStream;
begin
  if OpenDialog.Execute then begin
    PageForm := CreateMDIChild(OpenDialog.FileName);
    Stream := TFileStream.Create(OpenDialog.FileName, fmOpenRead or fmShareExclusive);
    try
      PageForm.FaxDesigner.Read(Stream);
    finally
      Stream.Free;
    end;
  end;
end;

procedure TMainForm.miFileNewClick(Sender: TObject);
begin
  CreateMDIChild('Untitled' + IntToStr(MDIChildCount + 1));
end;

procedure TMainForm.SaveCoverPage(const FileName : string; PageForm : TCoverPageForm);
var
  SaveCursor : TCursor;
  Stream     : TFileStream;
begin
  SaveCursor    := Screen.Cursor;
  Screen.Cursor := crHourglass;
  SaveStatusImage.Visible := True;
  Application.ProcessMessages;  {Make sure SaveStatusImage actually becomes visible}

  Stream := TFileStream.Create(FileName, fmCreate or fmShareExclusive);
  try
    PageForm.FaxDesigner.Write(Stream);
  finally
    Stream.Free;
    SaveStatusImage.Visible := False;
    Screen.Cursor := SaveCursor;
  end;
end;  

procedure TMainForm.miFileSaveClick(Sender: TObject);
begin
  {save current file (ActiveMDIChild points to the window)}
  if ActiveMDIChild is TCoverPageForm then begin
    {If this is a new cover page that has never been given a real name, call
     "Save As" instead of "Save"}
    if (ActiveMDIChild as TCoverPageForm).FaxDesigner.IsNew then
      miFileSaveAsClick(Sender)
    else
      SaveCoverPage((ActiveMDIChild as TCoverPageForm).PathName,
                    ActiveMDIChild as TCoverPageForm);
  end;
end;

procedure TMainForm.miFileSaveAsClick(Sender: TObject);
begin
  {save current file under new name}
  if ActiveMDIChild is TCoverPageForm then begin
    {$IFDEF Win32}
    SaveDialog.FileName := (ActiveMDIChild as TCoverPageForm).PathName;
    {$ENDIF}
    if SaveDialog.Execute then begin
      SaveCoverPage(SaveDialog.FileName, ActiveMDIChild as TCoverPageForm);
      (ActiveMDIChild as TCoverPageForm).PathName := SaveDialog.FileName;
    end;
  end;
end;

procedure TMainForm.miFileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.miWindowCascadeClick(Sender: TObject);
begin
  Cascade;
end;

procedure TMainForm.miWindowTileClick(Sender: TObject);
begin
  Tile;
end;

procedure TMainForm.miWindowArrangeIconsClick(Sender: TObject);
begin
  ArrangeIcons;
end;

procedure TMainForm.miWindowMinimizeClick(Sender: TObject);
var
  I: Integer;
begin
  {must be done backwards through the MDIChildren array}
  for I := MDIChildCount - 1 downto 0 do
    MDIChildren[I].WindowState := wsMinimized;
end;

procedure TMainForm.UpdateMenuItems(Sender: TObject);
begin
  miFileClose.Enabled          := MDIChildCount > 0;
  miFileSave.Enabled           := MDIChildCount > 0;
  miFileSaveAs.Enabled         := MDIChildCount > 0;
  miCreateAPF.Enabled          := MDIChildCount > 0;
  miPageLayout.Enabled         := MDIChildCount > 0;
  miReplacementTags.Enabled    := MDIChildCount > 0;
  miWindowCascade.Enabled      := MDIChildCount > 0;
  miWindowTile.Enabled         := MDIChildCount > 0;
  miWindowArrangeIcons.Enabled := MDIChildCount > 0;
  miWindowMinimize.Enabled     := MDIChildCount > 0;
  miDesignMode.Enabled         := MDIChildCount > 0;
  miEditMode.Enabled           := MDIChildCount > 0;
  SaveBtn.Enabled              := MDIChildCount > 0;
  DesignModeBtn.Enabled        := MDIChildCount > 0;
  EditModeBtn.Enabled          := MDIChildCount > 0;

  if ActiveMDIChild <> nil then begin
    miDesignMode.Checked :=
      not (ActiveMDIChild as TCoverPageForm).FaxDesigner.FaxPanel.EditMode;
    miEditMode.Checked :=
      (ActiveMDIChild as TCoverPageForm).FaxDesigner.FaxPanel.EditMode;
  end;
  if ActiveMDIChild is TCoverPageForm then begin
    if (ActiveMDIChild as TCoverPageForm).FaxDesigner.FaxPanel.EditMode then
      EditModeBtn.Down := True
    else
      DesignModeBtn.Down := True;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Screen.OnActiveFormChange := nil;
end;

procedure TMainForm.miHelpAboutClick(Sender: TObject);
begin
  Application.CreateForm(TApdAboutForm, ApdAboutForm);
  try
    ApdAboutForm.Caption := ApdAboutForm.Caption + ' - ' + Caption;  
    ApdAboutForm.ShowModal;
  finally
    ApdAboutForm.Free;
    ApdAboutForm := nil;
  end;
end;

procedure TMainForm.DesignModeBtnClick(Sender: TObject);
begin
  (ActiveMDIChild as TCoverPageForm).EditMode := False;
  UpdateMenuItems(Sender);
end;

procedure TMainForm.EditModeBtnClick(Sender: TObject);
begin
  (ActiveMDIChild as TCoverPageForm).EditMode := True;
  UpdateMenuItems(Sender);
end;

procedure TMainForm.miCreateAPFClick(Sender: TObject);
var
  Bitmap       : Graphics.TBitmap;
  Posn         : Integer;
  SaveCursor   : TCursor;
  BaseFileName : string;
begin
  SaveCursor    := Screen.Cursor;
  Screen.Cursor := crHourglass;
  SaveStatusImage.Visible := True;
  {make sure SaveStatusImage actually becomes visible}
  Application.ProcessMessages;

  ProgressBar := TApdMeter.Create(nil);
  Bitmap      := Graphics.TBitmap.Create;
  try
    ProgressBar.Parent   := ProgressPanel;
    ProgressBar.Align    := alClient;
    ProgressBar.Min      := 0;
    ProgressBar.Max      := 1;
    ProgressBar.Position := 0;
    with (ActiveMDIChild as TCoverPageForm), FaxDesigner do begin
      BaseFileName := PathName;
      Posn := Pos('.', BaseFileName);
      if Posn > 0 then
        Delete(BaseFileName, Posn, Length(BaseFileName) - Posn + 1);

      Bitmap.Width  := FaxPanel.DrawWidth;
      Bitmap.Height := FaxPanel.DrawHeight;
      FaxPanel.Draw(Bitmap.Canvas);

      FaxConverter.OutFileName := BaseFileName + '.APF';
      FaxConverter.ConvertBitmapToFile(Bitmap);
      MessageBeep(0);
    end;
  finally
    Bitmap.Free;
    ProgressBar.Free;
    ProgressBar := nil;
    SaveStatusImage.Visible := False;
    Screen.Cursor := SaveCursor;
  end;
end;

procedure TMainForm.miPageLayoutClick(Sender: TObject);
var
  OptionsForm : TPageOptionsForm;
  UData       : TUserDataArray;
begin
  if ActiveMDIChild is TCoverPageForm then begin
    Application.CreateForm(TPageOptionsForm, OptionsForm);
    with (ActiveMDIChild as TCoverPageForm), OptionsForm do begin
      HorzGridSpacingEdit.Text   := IntToStr(FaxDesigner.FaxPanel.GridSpacingX);
      VertGridSpacingEdit.Text   := IntToStr(FaxDesigner.FaxPanel.GridSpacingY);
      SnapToGridCheckBox.Checked := FaxDesigner.FaxPanel.SnapToGrid;
      ShowGridCheckBox.Checked   := FaxDesigner.FaxPanel.ShowGrid;
      IsMetric                   := FaxDesigner.IsMetric;
      {PageSize is stored as 1st byte in FaxDesigner.UserData}
      PageSize                   := FaxDesigner.UserData[0];
      if OptionsForm.ShowModal = mrOK then begin
        FaxDesigner.FaxPanel.GridSpacingX := StrToInt(Trim(HorzGridSpacingEdit.Text));
        FaxDesigner.FaxPanel.GridSpacingY := StrToInt(Trim(VertGridSpacingEdit.Text));
        FaxDesigner.FaxPanel.SnapToGrid   := SnapToGridCheckBox.Checked;
        FaxDesigner.FaxPanel.ShowGrid     := ShowGridCheckBox.Checked;
        FaxDesigner.IsMetric              := IsMetric;
        UData                             := FaxDesigner.UserData;
        UData[0]                          := PageSize;
        FaxDesigner.UserData              := UData;
        FaxDesigner.PageWidthInches       := PageWidthInches;
        FaxDesigner.PageHeightInches      := PageHeightInches;
      end;
    end;
  end;
end;

procedure TMainForm.miReplacementTagsClick(Sender: TObject);
var
  ReplacementTagsForm : TReplacementTagsForm;
begin
  if ActiveMDIChild is TCoverPageForm then begin
    Application.CreateForm(TReplacementTagsForm, ReplacementTagsForm);
    with (ActiveMDIChild as TCoverPageForm), ReplacementTagsForm, FaxDesigner do begin
      SenderEdit.Text     := FaxPanel.Sender;
      RecipientEdit.Text  := FaxPanel.Recipient;
      PageNumberEdit.Text := IntToStr(FaxPanel.PageNumber);
      PageCountEdit.Text  := IntToStr(FaxPanel.PageCount);
      PageTitleEdit.Text  := FaxPanel.PageTitle;
      StationIDEdit.Text  := FaxPanel.StationID;
      if ReplacementTagsForm.ShowModal = mrOK then begin
        FaxPanel.Sender     := SenderEdit.Text;
        FaxPanel.Recipient  := RecipientEdit.Text;
        FaxPanel.PageNumber := StrToInt(Trim(PageNumberEdit.Text));
        FaxPanel.PageCount  := StrToInt(Trim(PageCountEdit.Text));
        FaxPanel.PageTitle  := PageTitleEdit.Text;
        FaxPanel.StationID  := StationIDEdit.Text;
      end;
    end;
  end;
end;

procedure TMainForm.Help2Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTENTS, 0);
end;

procedure TMainForm.miConvertFCPtoAPFClick(Sender: TObject);
var
  SaveCursor : TCursor;
begin
  if OpenDialog.Execute then begin
    SaveCursor    := Screen.Cursor;
    Screen.Cursor := crHourglass;
    SaveStatusImage.Visible := True;
    {Make sure SaveStatusImage actually becomes visible}
    Application.ProcessMessages;
    ProgressBar := TApdMeter.Create(nil);
    try
      ProgressBar.Parent   := ProgressPanel;
      ProgressBar.Align    := alClient;
      ProgressBar.Min      := 0;
      ProgressBar.Max      := 1;
      ProgressBar.Position := 0;

      ConvertFCPToAPF(OpenDialog.FileName, 0, 0, '', '', '', '', FaxConverterStatus);
      MessageBeep(0);
    finally
      ProgressBar.Free;
      ProgressBar := nil;
      SaveStatusImage.Visible := False;
      Screen.Cursor := SaveCursor;
    end;
  end;
end;

{$IFDEF DELPHI3}
procedure TMainForm.FaxConverterStatus(F: TObject; Starting,
  Ending: Boolean; PagesConverted, LinesConverted, BytesConverted,
  BytesToConvert: Integer; var Abort: Boolean);
{$ELSE}
procedure TMainForm.FaxConverterStatus(F: TObject; Starting,
  Ending: Boolean; PagesConverted, LinesConverted: Integer; BytesConverted,
  BytesToConvert: Longint; var Abort: Boolean);
{$ENDIF}
begin
  if ProgressBar.Max <= 1 then
    ProgressBar.Max := BytesToConvert;
  if ProgressBar.Max > 1 then
    ProgressBar.Position := BytesConverted;
end;

end.

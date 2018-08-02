unit KPISelectPluginsDlgU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  KPIAvailablePluginsU,
  KPIManagerU, hintlist, AdvGlowButton, ExtCtrls, AdvPanel, Menus;

type
  TKPISelectPluginsDlg = class(TForm)
    advPanel: TAdvPanel;
    OkBtn: TAdvGlowButton;
    CancelBtn: TAdvGlowButton;
    AvailablePluginsLbl: TLabel;
    PluginList: THintList;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    Panel1: TPanel;
    PopupMenu: TPopupMenu;
    miRename: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miRenameClick(Sender: TObject);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PluginListClick(Sender: TObject);
    procedure PluginListDblClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
  private
    FSelectedPlugins: TList;
    // Callback method used by PopulateList to add the next plug-in to
    // the list.
    procedure AddPlugin(PluginInfo: TKPIPluginInfo);
    // Fills the list box with the names of the available plug-ins.
    procedure PopulateList;
  public
    property SelectedPlugins: TList read FSelectedPlugins;
  end;

var
  KPISelectPluginsDlg: TKPISelectPluginsDlg;

implementation

{$R *.dfm}

uses Brand, VAOUtil, KPIUtils, IniFiles;

// =============================================================================
// TKPISelectPluginsDlg
// =============================================================================
procedure TKPISelectPluginsDlg.AddPlugin(PluginInfo: TKPIPluginInfo);
var
  CharPos: Integer;
  PluginCaption: string;
begin
  if PluginList.Items.IndexOf(PluginInfo.dpCaption) = -1 then
  begin
    if PluginInfo.dpIsAvailable then
    begin
      PluginCaption := PluginInfo.dpCaption;
      CharPos := Pos('[', PluginCaption);
      if (CharPos <> 0) then
        PluginCaption := Trim(Copy(PluginCaption, 1, CharPos - 1));
      PluginList.AddItem(PluginCaption, PluginInfo);
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPISelectPluginsDlg.FormCreate(Sender: TObject);
begin
  // Centre - can't use poScreenCentre because of Host property not working
  Self.Top := (Screen.Height div 2) - (Self.Height Div 2);
  Self.Left := (Screen.Width - Self.Width) Div 2;

  // Branding
  InitBranding (IncludeTrailingPathDelimiter(VAOInfo.vaoAppsDir));
  self.Icon.Assign(Branding.pbProductIcon);

  MakeRounded(self);
  MakeRounded(pnlInfo);
  MakeRounded(advPanel);

  OkBtn.Enabled := False;
  
  Application.ProcessMessages;

  FSelectedPlugins := TList.Create;
  PopulateList;
end;

// -----------------------------------------------------------------------------

procedure TKPISelectPluginsDlg.FormDestroy(Sender: TObject);
begin
  FSelectedPlugins.Free;
end;

procedure TKPISelectPluginsDlg.miRenameClick(Sender: TObject); // v10
var
  NewCaption: WideString;
  PluginInfo: TKPIPluginInfo;
begin
  NewCaption := InputBox('Rename the control', 'Edit the caption for this control', PluginList.Items[PluginList.ItemIndex]);
  PluginInfo := TKPIPluginInfo(PluginList.items.Objects[PluginList.ItemIndex]);
  PluginInfo.dpCaption := NewCaption;
  with TIniFile.Create(PluginInfo.dpInfoFile) do begin
    try
      WriteString('Config', 'Label', NewCaption);
    finally
      Free;
    end;
  end;

  PluginList.Items[PluginList.ItemIndex] := PluginInfo.dpCaption;
end;

// -----------------------------------------------------------------------------

procedure TKPISelectPluginsDlg.OkBtnClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to PluginList.Items.Count - 1 do
  begin
    if PluginList.Selected[i] then
      FSelectedPlugins.Add(PluginList.Items.Objects[i]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPISelectPluginsDlg.PluginListClick(Sender: TObject);
begin
  if (PluginList.ItemIndex <> -1) then
    OkBtn.Enabled := True;
end;

procedure TKPISelectPluginsDlg.PluginListDblClick(Sender: TObject);
begin
  OkBtnClick(nil);
  ModalResult := mrOK;
end;

// -----------------------------------------------------------------------------

procedure TKPISelectPluginsDlg.pnlInfoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

// -----------------------------------------------------------------------------

procedure TKPISelectPluginsDlg.PopulateList;
begin
  KPIManager.ForEachPlugin(AddPlugin);
end;

procedure TKPISelectPluginsDlg.PopupMenuPopup(Sender: TObject); // v10
begin
  miRename.Enabled := PluginList.ItemIndex <> -1;
end;

// -----------------------------------------------------------------------------

end.

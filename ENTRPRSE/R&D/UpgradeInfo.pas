unit UpgradeInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, BorBtns, OleCtrls, SHDocVw, ETStrU, APIUTIL,
  FileUtil, Inifiles, Menus, ComCtrls, EntWindowSettings;

type
  TUpgradeForm = class(TForm)
    PopupMenu1: TPopupMenu;
    StoreCoordFlg: TMenuItem;
    db1SBox: TScrollBox;
    HTMLPNL1: TPanel;
    WebBrowser1: TWebBrowser;
    ButtonPNL1: TPanel;
    Button_Ok: TButton;
    ShowInfoAgainCBX1: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button_OkClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    { Private declarations }
    WINLogIn     : String;
    Path         : String;
    CloseForm    : Boolean;
    ShowInfo     : Boolean;
    StoreCoord   : Boolean;
    fNeedCUpdate : Boolean;
    fDoingClose  : Boolean;

    StartSize,
    OrigSize,
    InitSize     : TPoint;

    ReadFormPos  : Boolean;
    GotCoord     : Boolean;
    LastCoord    : Boolean;
    SetDefault   : Boolean;

    FormBitMap   : TBitMap;

    PagePoint    : Array[0..4] of TPoint;

    FSettings    : IWindowSettings;

    // CA 10/09/2012  ABSEXCH-13372 : Minimum window size set on the new Upgrade Notes window
    // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MinSizeX : LongInt;
    MinSizeY : LongInt;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    Procedure SetNeedCUpdate(B  :  Boolean);

    procedure Find_FormCoord;

    Property  NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

  public
    { Public declarations }
    procedure ShouldCheckBoxBeDisplayed;
    procedure ShouldIniFileBeUpdated;
  end;

var
  UpgradeForm: TUpgradeForm;

implementation

Uses
  GlobVar;

{$R *.DFM}

{ CA  03/06/2012   v7.0  ABSEXCH-12302:    Startup Upgrade Info Window }

procedure TUpgradeForm.Find_FormCoord;
Begin
  //Read in window and first list settings.
  if Assigned(FSettings) and not FSettings.UseDefaults then
    FSettings.SettingsToWindow(Self);

  StartSize.X:=Width; StartSize.Y:=Height;

  //Needed by FormResize method
  GotCoord := True;
end;

Procedure TUpgradeForm.SetNeedCUpdate(B  :  Boolean);
Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TUpgradeForm.FormShow(Sender: TObject);
var
  filename : String;
begin
  CloseForm := False;
  ShowInfo  := False;
  WinLogIn  := '';
  WinLogIn  := UpCaseStr(WinGetUserName);

  // This will get us the appropriate path to find the HTML File and the Ini file
  Path      := GetEnterpriseDirectory;
  filename  := 'DocMastr\UpgradeInfo\UpgradeInfo.HTM';

  // Bringing up the HTM file in the webbrowser coponent
  WebBrowser1.Navigate('file://' +Path + filename);

  ShouldCheckBoxBeDisplayed;

  // Unless these lines are here the webbrowser will not resize correctly when
  // you first go into the screen.
  WebBrowser1.Width   := HTMLPNL1.Width - 5;
  WebBrowser1.Height  := HTMLPNL1.Height - 10;

end;

// CA 10/09/2012  ABSEXCH-13372 : Minimum window size set on the new Upgrade Notes window
Procedure TUpgradeForm.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);
Begin // WMGetMinMaxInfo
  With Message.MinMaxInfo^ Do
  Begin
    ptMinTrackSize.X:=MinSizeX;
    ptMinTrackSize.Y:=MinSizeY;
  End; // With Message.MinMaxInfo^

  Message.Result:=0;

  Inherited;
End; // WMGetMinMaxInfo


procedure TUpgradeForm.ShouldCheckBoxBeDisplayed;
Var
  Ini       : TIniFile;
  IniOption : String;
Begin
  Ini := TIniFile.Create(Path+ '\MISC\UpgradeInfo.INI');
  If FileExists (Path+ '\MISC\UpgradeInfo.INI') Then
  Begin
     With TIniFile.Create (Path+ '\MISC\UpgradeInfo.INI') Do
     Try
        { We determine here if the option exists and this will determine if the checkbox will be displayed}
        IniOption := ReadString('UpgradeWindow', WinLogIn, '');
        if (IniOption = '1') Or
           (IniOption = '') then  // False
           ShowInfo := True
        else
          if (IniOption = '0') then  // False
            ShowInfo := False;

        ShowInfoAgainCBX1.Visible :=  ShowInfo;
     Finally
     End; // Try..Finally
  End
  Else
    Begin
      ShowInfoAgainCBX1.Visible := True;
      ShowInfo := True;
    End;
End;

procedure TUpgradeForm.ShouldIniFileBeUpdated;
Var
  Ini    : TIniFile;
Begin
  Ini := TIniFile.Create(Path+ '\MISC\UpgradeInfo.INI');
  If FileExists (Path+ '\MISC\UpgradeInfo.INI') Then
  Begin
     With TIniFile.Create (Path+ '\MISC\UpgradeInfo.INI') Do
     if (ShowInfo) Then
     Begin
       if (ShowInfoAgainCBX1.Checked = True) Then // User does not want this window to come up again
          Ini.WriteBool( 'UpgradeWindow', WinLogIn, false )
       else
          Ini.WriteBool( 'UpgradeWindow', WinLogIn, True );
     End;
  End
  Else
    Begin
       With TIniFile.Create (Path+ '\MISC\UpgradeInfo.INI') Do
       if (ShowInfo) Then
       Begin
         if (ShowInfoAgainCBX1.Checked = True) Then // User does not want this window to come up again
            Ini.WriteBool( 'UpgradeWindow', WinLogIn, false )
         else
            Ini.WriteBool( 'UpgradeWindow', WinLogIn, True );
       End;
    End

End;

procedure TUpgradeForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  CloseForm := True;
  ShouldIniFileBeUpdated;
  Action := caFree;

  if Assigned(FSettings) and NeedCUpdate then
  begin
    FSettings.WindowToSettings(Self);
    FSettings.SaveSettings(StoreCoord);
    FSettings := nil;
  end;

end;

procedure TUpgradeForm.Button_OkClick(Sender: TObject);
begin
  Close;
end;

procedure TUpgradeForm.FormResize(Sender: TObject);
var
 i_panelwidth : Integer;
 i_left       : Integer;
begin
  If (GotCoord) and (Not fDoingClose) then
  Begin

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    WebBrowser1.Width   := HTMLPNL1.Width - 5;
    WebBrowser1.Height  := HTMLPNL1.Height - 10;

    i_panelwidth        := ButtonPNL1.Width - 40;
    i_left              := Trunc(i_panelwidth / 2);
    Button_OK.Left      := i_left;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));
  end;
end;

procedure TUpgradeForm.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;

procedure TUpgradeForm.FormCreate(Sender: TObject);
begin
  LastCoord     := BOff;

  GotCoord      := BOff;
  NeedCUpdate   := BOff;
  fDoingClose   := BOff;

  db1SBox.HorzScrollBar.Position:=0;
  db1SBox.VertScrollBar.Position:=0;

  FSettings := GetWindowSettings(Self.ClassName);
  if Assigned(FSettings) then
    FSettings.LoadSettings;

  InitSize.Y  := 645;
  InitSize.X  := 903;

  Self.ClientHeight := InitSize.Y;
  Self.ClientWidth  := InitSize.X;

  // CA 10/09/2012  ABSEXCH-13372 : Minimum window size set on the new Upgrade Notes window
  ClientHeight:=615;
  ClientWidth:=887;

  // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
  MinSizeX := 602;  // Set to a third as requested Width;
  MinSizeY := 435;  // Set to a third as requested Height;

  // To ensure the screen size is saved if required the following function must be run after
  // the screen settings above
  Find_FormCoord;

  FormReSize(Self);
end;

procedure TUpgradeForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  If (CanClose) then
  Begin
    db1SBox.HorzScrollBar.Position:=0;
    db1SBox.VertScrollBar.Position:=0;
  End;
end;

procedure TUpgradeForm.PopupMenu1Popup(Sender: TObject);
begin
  StoreCoordFlg.Checked:=StoreCoord;
end;

end.

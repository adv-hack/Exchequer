unit ImpTray;

{ prutherford440 09:49 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ShellAPI, StdCtrls, ExtCtrls, ImgList, EbusUtil, XMLImp;


type
  TfrmeBisImport = class(TForm)
    mnuPopUp: TPopupMenu;
    mniClose: TMenuItem;
    imgImport: TImage;
    About1: TMenuItem;
    ImageList1: TImageList;
    Help1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    mniSetup: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mniCloseClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure mniSetupClick(Sender: TObject);
 private
    nid : TNotifyIconData;
    Closing, bOKToShowMenu : boolean;
    XMLImport : TXmlImport;
    procedure StartXMLParsing;
 public
    procedure IconTray(var Msg : TMessage); message wm_IconMessage;
    procedure IconClose(var Msg : TMessage); message wm_IconClose;
 end;

var
  frmeBisImport: TfrmeBisImport;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


{$R *.DFM}

uses
  About, BtrvU2, UseDLLU,TKUtil, EbusLic, FileUtil;

//-----------------------------------------------------------------------

procedure TfrmeBisImport.IconTray(var Msg : TMessage);
{This dictates what happens when a mouse event happens on the tray icon}
var
  Pt : TPoint;
begin
  if bOKToShowMenu then begin
    case Msg.lParam of
      {Right Button Click}
      WM_RBUTTONDOWN : begin
        SetForegroundWindow(Handle);
        GetCursorPos(Pt);
        mnuPopup.Popup(Pt.x, Pt.y);
        PostMessage(Handle, WM_NULL, 0, 0);
      end;

      {Double Click Click}
      WM_LBUTTONDBLCLK : begin
        SetForegroundWindow(Handle);
        // ExportManager1Click(nil);
        PostMessage(Handle, WM_NULL, 0, 0);
      end;
    end;{case}
  end;{if}
end;


procedure TfrmeBisImport.IconClose(var Msg : TMessage);
{This Will force a close upon start up}
begin
  mniCloseClick(Nil);
end;


//-----------------------------------------------------------------------

procedure TfrmeBisImport.FormCreate(Sender: TObject);
var
  ebLic : SmallInt;
begin

  ebLic := GetEbusLicence;

  if ebLic = eblLicenced then
  begin
    bOKToShowMenu := FALSE;
    Closing := false;

    with nid do begin
      cbSize := sizeof(nid);
      wnd := Handle;
      uID := 1;
      uCallBackMessage := wm_IconMessage;
      hIcon := imgImport.Picture.Icon.Handle;
      szTip := 'Exchequer eBusiness Import Module';
      uFlags := nif_Message or nif_Icon or nif_Tip;
    end;{with}
    Shell_NotifyIcon(NIM_ADD, @nid);

    if not Check4BtrvOK then
      ShowTKError('Unable to load database.',1, 20);


    bOKToShowMenu := TRUE;

    StartXMLParsing;
  end //if licenced
  else
  begin
    if ebLic = eblNotLicenced then
      ShowEbusNotLicencedMessage
    else
      ShowEbusLicenceErrorMessage;
    Closing := True;
    Application.Terminate;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmeBisImport.FormDestroy(Sender: TObject);
begin
  nid.uFlags := 0;
  Shell_NotifyIcon(NIM_DELETE, @nid);
  Application.ProcessMessages;

  If (Assigned(XMLImport)) then
    XMLImport.Free;

  Ex_CloseDLL;
end;

//-----------------------------------------------------------------------

procedure TfrmeBisImport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not Closing then
  begin
    Action := caNone;
    ShowWindow(Handle, sw_Hide);
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmeBisImport.mniCloseClick(Sender: TObject);
begin
  If (Not BusyInProcess) then
  Begin
    Closing := true;
    WantToClose:=False;
    Close;
  end
  else
  Begin                                                         
    ShowMessage('The eBusiness import module is currently busy processing.'+#13+
                'Closing is not possible at this time.'+#13+
                'The import module will close as soon as it has finished.');
    WantToClose:=True;
    //mniClose.Enabled:=False;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmeBisImport.About1Click(Sender: TObject);
begin
  // Need to turn off parsing when changing settings ?
  with TfrmAbout.Create(Self) do
    try
      ShowModal;
    finally
      Release;
    end;
end;

//-----------------------------------------------------------------------

procedure TfrmeBisImport.Help1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_Finder,0);
end;

//-----------------------------------------------------------------------

procedure TfrmeBisImport.mniSetupClick(Sender: TObject);
var
  Status : SmallInt;
  pPath : PChar;
  sPath : String;
begin
  pPath := StrAlloc(255);
  Try
    FillChar(pPath^, 255, #0);
    Status := EX_GETDATAPATH(pPath);
    if Status = 0 then
      sPath := pPath
    else
      sPath := GetEnterpriseDirectory;

    XMLImport.Pause;
    EX_CLOSEDATA;
    ShowEBusSetup;

    //Reopen the toolkit
    Status:=SetToolkitPath(sPath);
    ShowTKError('Setting Toolkit Path to '+ebSetDrive,84, Status);
    Status := Ex_InitDLL;
    ShowTKError('Call to Ex_InitDLL',1, Status);


    if Closing then
      Close
    else
      XMLImport.Restart;
  Finally
    StrDispose(pPath);
  End;
end;

//-----------------------------------------------------------------------

procedure TfrmeBisImport.StartXMLParsing;
var
  Status   : integer;
  UnloadMe : Boolean;
  PC : PChar;

begin
  // Open the DLL - will be assigned to appropriate company elsewhere
  // Override with command line path if set.

  UnLoadMe:=False;

  If (ebSetDrive<>'') then
  Begin
    Status:=SetToolkitPath(ebSetDrive);

    ShowTKError('Setting Toolkit Path to '+ebSetDrive,84, Status);

  end
  else
    ToolkitOK;

  Status := Ex_InitDLL;

  ShowTKError('Call to Ex_InitDLL',1, Status);

  If (Status=0) then
  Begin
    XMLImport := TXMLImport.Create;
    if not XMLImport.Initialise then
    begin // XML processing not available
      XMLImport.Free;
      XMLImport := nil;
      UnLoadMe:=True;
    end;
  end
  else
    UnLoadMe:=True;


  If (UnLoadMe) then
    PostMessage(Self.Handle,WM_IconClose,0,0);
end;

end.

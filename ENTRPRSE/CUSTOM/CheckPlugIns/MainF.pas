unit MainF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CheckForPlugIns, StdCtrls, ExtCtrls, PlugInFrame;

Const
  AppVersion = 'Build 005';

//
// v6.00.004  20/02/2008  MH  Rebuilt with EXSQL support as I kept getting VAOInfo errors 
//
// v6.00.003  01/11/2007  MH  Added a tick display so users can see which installers have been run
//
// v6.00.002  01/11/2007  MH  Modified to allow multi-line descriptions
//
// v6.00.001  16/10/2007  MH  Initial development
//

type
  TForm1 = class(TForm)
    shBanner: TShape;
    lblBanner: TLabel;
    scrlPlugIns: TScrollBox;
    Label1: TLabel;
    lblExchequerDir: TLabel;
    Label2: TLabel;
    lblVersion: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }

    // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MinSizeX : LongInt;
    MinSizeY : LongInt;

    oCheckForPlugIns : TCheckForPlugIns;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Uses VAOUtil;

//=========================================================================

procedure TForm1.FormCreate(Sender: TObject);
Var
  oPlugInFrame : TSinglePlugInFrame;
  I, NextTop : Integer;
begin
  Caption := Application.Title;

  lblVersion.Caption := AppVersion;

  // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
  MinSizeX := (Width - ClientWidth) + 702;        // take border sizing &
  MinSizeY := (Height - ClientHeight) + 200;      // captions into account

  If FileExists(VAOInfo.vaoCompanyDir + 'Excheqr.Sys') Then
  Begin
    oCheckForPlugIns := TCheckForPlugIns.Create;
    oCheckForPlugIns.cpExchequerDirectory := VAOInfo.vaoCompanyDir;

    lblExchequerDir.Caption := VAOInfo.vaoCompanyDir;

    If (oCheckForPlugIns.cpPlugInCount > 0) Then
    Begin
      // Load the
      NextTop := 1;
      For I := 0 To oCheckForPlugIns.cpPlugInCount-1 Do
      Begin
        oPlugInFrame := TSinglePlugInFrame.Create(Self);
        With oPlugInFrame Do
        Begin
          Name := Name + IntToStr(I);
          Parent := scrlPlugIns;
          Top := NextTop;
          Left := 1;

          With oCheckForPlugIns.cpPlugIn[I] Do
          Begin
            pifFilename := pdFilename;
            pifName := pdName;
            pifDescription := pdDescription;
            pifInstallerPath := pdInstallerPath;
          End; // With oCheckForPlugIns.cpPlugIn[I]

          // Update position for next frame
          NextTop := NextTop + Height;
        End; // With oPlugInFrame
      End; // For I

      // Guestimate at auto-sizing
      If (NextTop > scrlPlugIns.Height) Then
      Begin
        I := NextTop - scrlPlugIns.Height;  // # of additional pixels needed
        If ((Self.Height + I) < Screen.Height) Then
          Self.Height := Self.Height + I
        Else
          Self.Height := Screen.Height;

        If ((Self.Top + Self.Height) > Screen.Height) Then
          Self.Top := (Screen.Height - Self.Height) Div 2;
      End; // If (NextTop > scrlPlugIns.Height)
    End // If (oCheckForPlugIns.cpPlugInCount > 0)
    Else
    Begin
      MessageDlg ('No Plug-ins are installed for Exchequer or the Trade Counter', mtInformation, [mbOK], 0);
      Self.Visible := False;
      PostMessage(Self.Handle, WM_CLOSE, 0, 0);
    End; // Else
  End // If FileExists(VAOInfo.vaoCompanyDir + 'Excheqr.Sys')
  Else
  Begin
    MessageDlg ('The registered version of Exchequer on this workstation is not a valid Exchequer v6.00 installation', mtInformation, [mbOK], 0);
    PostMessage(Self.Handle, WM_CLOSE, 0, 0);
  End; // Else
end;

//------------------------------

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNIL(oCheckForPlugIns);
end;

//-------------------------------------------------------------------------

procedure TForm1.FormResize(Sender: TObject);
begin
  scrlPlugIns.Height := ClientHeight - scrlPlugIns.Top - 10;
  scrlPlugIns.Width := ClientWidth - scrlPlugIns.Left - 10;
end;

//-------------------------------------------------------------------------

Procedure TForm1.WMGetMinMaxInfo(Var Message : TWMGetMinMaxInfo);
Begin // WMGetMinMaxInfo
  If (MinSizeX > 0) Then
  Begin
    With Message.MinMaxInfo^ Do
    Begin
      ptMinTrackSize.X:=MinSizeX;
      ptMinTrackSize.Y:=MinSizeY;

      ptMaxTrackSize.X:=MinSizeX;
      ptMaxTrackSize.Y:=Screen.Height;
    End; // With Message.MinMaxInfo^

    Message.Result:=0;
  End; // If (FMinSizeX > 0)

  Inherited;
End; // WMGetMinMaxInfo

//=========================================================================

end.

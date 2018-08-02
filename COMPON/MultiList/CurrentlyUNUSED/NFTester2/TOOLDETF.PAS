unit ToolDetF;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, Buttons, Registry, ComCtrls, TEditVal, ExtCtrls;

type
  TToolDetails = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label81: Label8;
    lblTargType: Label8;
    edtTitle: TEdit;
    edtPath: TEdit;
    edtParams: TEdit;
    edtStart: TEdit;
    btnTargetBrowse: TButton;
    btnStartBrowse: TButton;
    Bevel15: TBevel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure BtnBrowse2Click(Sender: TObject);
    procedure edtPathExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    OK : Boolean;
  end;

var
  ToolDetails: TToolDetails;

implementation
uses
  VarConst;

{$R *.DFM}

procedure TToolDetails.FormCreate(Sender: TObject);
begin
  OK := False;
end;

{ OK }
procedure TToolDetails.btnOkClick(Sender: TObject);
begin
  { Title cannot be blank }
  OK := (Trim(edtTitle.Text) <> '');

  If OK Then Begin
    { Don't validate if doing a separator bar }
    If (Trim(edtTitle.Text) <> '-') Then Begin
      { Title OK - Check Target is set correctly }
      OK := (Trim(edtPath.Text) <> '');
      If OK Then Begin
        OK := FileExists(edtPath.Text);
      End; { If (Trim(edtPath.Text) <> '') }

      If (Not OK) Then Begin
        MessageDlg ('The Target must be set correctly', mtWarning, [mbOk], 0);
        If edtPath.CanFocus Then edtPath.SetFocus;
      End; { If (Not OK) }

      { Target OK - check startup directory }
      If OK Then Begin
        If (Trim(edtStart.Text) <> '') Then Begin
          OK := DirectoryExists(edtStart.Text);

          If (Not OK) Then Begin
            MessageDlg ('The Startup Directory must be set to a valid directory or left blank', mtWarning, [mbOk], 0);
            If edtStart.CanFocus Then edtStart.SetFocus;
          End; { If (Not OK) }
        End; { If (Trim(edtStart.Text) <> '') }
      End; { If }
    End; { If (Trim(edtTitle.Text) <> '-')  }
  End { If OK }
  Else Begin
    { Invalid Title }
    MessageDlg ('The Title cannot be left blank', mtWarning, [mbOk], 0);
    If edtTitle.CanFocus Then edtTitle.SetFocus;
  End; { Else }

  If OK Then Begin
    { Save Details }
    Close;
  End; { If OK }
end;

{ Cancel }
procedure TToolDetails.btnCancelClick(Sender: TObject);
begin
  OK := False;
  Close;
end;

procedure TToolDetails.btnBrowseClick(Sender: TObject);
Var
  CurrPath : ShortString;
begin
  { Save current path }
  CurrPath := GetCurrentDir;

  Try
    If (Trim(edtPath.Text) <> '') Then Begin
      { Set to existing path }
      OpenDialog1.FileName := ExtractFileName(Trim(edtPath.Text));
      OpenDialog1.InitialDir := ExtractFilePath(Trim(edtPath.Text));
    End { If }
    Else Begin
      { Default to application directory }
      OpenDialog1.FileName := ExtractFileName(Application.ExeName);
      OpenDialog1.InitialDir := sEXEDir;
    End; { Else }

    If OpenDialog1.Execute Then Begin
      { Have got a file }
      edtPath.Text := OpenDialog1.FileName;

      { Default Startup directory if not set already }
      If (Trim(edtStart.Text) = '') Then Begin
        edtStart.Text := ExtractFilePath(Trim(edtPath.Text));
      End; { If (Trim(edtStartup) = '') }
    End; { If }
  Except
    On Exception Do ;
  End;

  { restore current path }
  SetCurrentDir(CurrPath);

  edtPathExit(Sender);
end;

procedure TToolDetails.BtnBrowse2Click(Sender: TObject);
Var
  CurrPath : ShortString;
begin
  { Save current path }
  CurrPath := GetCurrentDir;

  Try
    If (Trim(edtPath.Text) <> '') Then Begin
      { Set to existing path }
      OpenDialog1.FileName := ExtractFileName(Trim(edtStart.Text));
      OpenDialog1.InitialDir := ExtractFilePath(Trim(edtStart.Text));
    End { If }
    Else Begin
      { Default to application directory }
      OpenDialog1.FileName := ExtractFileName(Application.ExeName);
      OpenDialog1.InitialDir := sEXEDir;
    End; { Else }

    If OpenDialog1.Execute Then Begin
      { Have got a file }
      edtStart.Text := ExtractFilePath(OpenDialog1.FileName);
    End; { If }
  Except
    On Exception Do ;
  End;

  { restore current path }
  SetCurrentDir(CurrPath);
end;

procedure TToolDetails.edtPathExit(Sender: TObject);
Var
  RegO   : TRegistry;
  TmpStr : ShortString;
begin
  If FileExists (edtPath.Text) Then Begin
    RegO := TRegistry.Create;
    Try
      RegO.RootKey := HKEY_CLASSES_ROOT;

      { Open association details for extension }
      If RegO.OpenKey(ExtractFileExt(edtPath.Text), False) Then Begin
        { defaults are stored as null strings }
        If RegO.KeyExists('') Then Begin
          { Get redirection string and check it exists in the classes }
          TmpStr := RegO.ReadString('');

          { Close initial entry and open redirection entry }
          RegO.CloseKey;
          If RegO.KeyExists(TmpStr) Then Begin
            If RegO.OpenKey(TmpStr, False) Then Begin
              lblTargType.Caption := RegO.ReadString('');
            End { If }
            Else Begin
              lblTargType.Caption := TmpStr;
            End; { Else }
          End { If RegO.KeyExists(RegO.ReadString('')) }
          Else Begin
            lblTargType.Caption := TmpStr;
          End; { Else }
        End { If RegO.KeyExists(ExtractFileExt(edtPath.Text)) }
        Else Begin
          lblTargType.Caption := 'Unknown';
        End; { Else }
      End { If RegObj.OpenKey(ExtractFileExt(edtPath.Text)) }
      Else Begin
        lblTargType.Caption := 'Unknown';
      End; { Else }

      RegO.CloseKey;
    Finally
      RegO.Destroy;
    End;
  End { If FileExists (edtPath.Text) }
  Else Begin
    { No valid file specified }
    lblTargType.Caption := '';
  End; { Else }
end;

end.

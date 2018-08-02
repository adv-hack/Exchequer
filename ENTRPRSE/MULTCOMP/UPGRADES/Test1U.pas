unit Test1U;

{ markd6 17:09 06/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    v432Pwbtn: TButton;
    Edit1: TEdit;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    Label2: TLabel;
    edtUpgradeVersion: TEdit;
    Button5: TButton;
    Button6: TButton;
    procedure v432PwbtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }

    Function ProperDIR(DirS  :  String )  :  String;

    Procedure Run_V432Passwords;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  FileCtrl,
{$IFDEF EXSQL}
  SQLUtils,
{$ENDIF}
  DLLLinkU;

{$R *.DFM}

procedure TForm1.Run_V432Passwords;

Var
  Result  :  Integer;
  ErrStr  :  String;

Begin
  //Result:=ControlUpgrade('V5.00',ProperDir(Edit1.Text),ErrStr,True);
  Result:=ControlUpgrade(edtUpgradeVersion.Text,ProperDir(Edit1.Text),ErrStr,True);

  If (Result<>0) then
    ShowMessage('It was not possible to complete '+ErrStr+#13+
                'Report error '+IntToStr(Result));

end;


Function TForm1.ProperDIR(DirS  :  String )  :  String;

Begin
  Result:=DirS;

  If (DirS<>'') and (DirS[Length(DirS)]<>'\') then
    Result:=Result+'\';

end;

procedure TForm1.v432PwbtnClick(Sender: TObject);
begin
{$IFDEF EXSQL}
  if SQLUtils.ValidCompany(ProperDir(Edit1.Text)) then
{$ELSE}
  If FileExists(ProperDir(Edit1.Text)+'EXCHQSS.DAT') then
{$ENDIF}
    Run_V432Passwords
  else
    ShowMessage(Edit1.Text+' is not a valid directory.');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Edit1.Text:=ParamStr(1);
  If (Edit1.Text = '') Then
    Edit1.Text := ExtractFilePath(Application.ExeName);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  If DirectoryExists(Edit1.Text) then
    OpenDialog1.InitialDir:=Edit1.Text;

   if OpenDialog1.Execute then
   with OpenDialog1.Files do
   Begin
     Edit1.Text:=ExtractFileDir(Strings[0]);

   end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  SendMessage(Self.Handle,WM_Close,0,0);
end;

procedure TForm1.Button3Click(Sender: TObject);
Var
  Result  :  Integer;
  ErrStr  :  String;
begin
{$IFDEF EXSQL}
  if SQLUtils.ValidCompany(ProperDir(Edit1.Text)) then
{$ELSE}
  If FileExists(ProperDir(Edit1.Text)+'EXCHQSS.DAT') then
{$ENDIF}
  begin
    Result := AddNewIndex('v6.2',ProperDir(Edit1.Text), ErrStr);

    if Result = 0 then
      ShowMessage('Success')
    else
      ShowMessage('Error ' + IntToStr(Result) + ': ' + QuotedStr(ErrStr));
  end
  else
    ShowMessage(Edit1.Text+' is not a valid directory.');
end;

procedure TForm1.Button4Click(Sender: TObject);
Var
  Result  :  Integer;
  ErrStr  :  String;
begin
{$IFDEF EXSQL}
  if SQLUtils.ValidCompany(ProperDir(Edit1.Text)) then
{$ELSE}
  If FileExists(ProperDir(Edit1.Text)+'EXCHQSS.DAT') then
{$ENDIF}
  begin
    SetCompanyDir(ProperDir(Edit1.Text));

    Result := AddJobAppsCustomFields(ErrStr);

    if Result = 0 then
      ShowMessage('Success')
    else
      ShowMessage('Error ' + IntToStr(Result) + ': ' + QuotedStr(ErrStr));
  end
  else
    ShowMessage(Edit1.Text+' is not a valid directory.');
end;

procedure TForm1.Button5Click(Sender: TObject);
Var
  Res  :  Integer;
  ErrStr  :  String;
begin
  Res := ExpirePlugIn(edtUpgradeVersion.Text,ProperDir(Edit1.Text),'EXCHAUTHWF000002', ErrStr);
  if Res = 0 then
    ShowMessage('Success')
  else
    ShowMessage('Error ' + IntToStr(Res) + ': ' + QuotedStr(ErrStr));

end;

procedure TForm1.Button6Click(Sender: TObject);
Var
  Result  :  Integer;
  ErrStr  :  String;
begin
{$IFDEF EXSQL}
  if SQLUtils.ValidCompany(ProperDir(Edit1.Text)) then
{$ELSE}
  If FileExists(ProperDir(Edit1.Text)+'EXCHQSS.DAT') then
{$ENDIF}
  begin
    SetCompanyDir(ProperDir(Edit1.Text));

    Result := UpdateBankReconcile(ErrStr);

    if Result = 0 then
      ShowMessage('Success')
    else
      ShowMessage('Error ' + IntToStr(Result) + ': ' + QuotedStr(ErrStr));
  end
  else
    ShowMessage(Edit1.Text+' is not a valid directory.');
end;

end.

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
    procedure v432PwbtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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
  DLLLinkU;

{$R *.DFM}

procedure TForm1.Run_V432Passwords;

Var
  Result  :  Integer;
  ErrStr  :  String;

Begin
  Result:=ControlUpgrade('V5.00',ProperDir(Edit1.Text),ErrStr,True);

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
  If FileExists(ProperDir(Edit1.Text)+'EXCHQSS.DAT') then
    Run_V432Passwords
  else
    ShowMessage(Edit1.Text+' is not a valid directory.');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Edit1.Text:=ParamStr(1);
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

end.

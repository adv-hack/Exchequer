unit AdminF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Uses piMisc;

//---------------------------------------------------------------------------

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;

end;

//------------------------------------

procedure TForm1.FormDestroy(Sender: TObject);
begin
  // ?
end;

//---------------------------------------------------------------------------

procedure TForm1.About1Click(Sender: TObject);
Var
  slAboutText : TStringList;
  iPos        : Byte;
  sText       : ANSIString;
begin
  slAboutText := TStringList.Create;
  Try
    PIMakeAboutText (Application.Title,
                     'v5.70.202 (DLL)',
                     slAboutText);

    For iPos := 0 To 4 Do
      sText := sText + slAboutText[IPos] + #13;
    Delete (sText, Length(sText), 1);
  Finally
    FreeAndNIL (slAboutText);
  End;

  Application.MessageBox (PCHAR(sText), 'About...', 0);
end;

//---------------------------------------------------------------------------

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

//---------------------------------------------------------------------------

end.

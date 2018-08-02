unit EditMenu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    PopupMenu1: TPopupMenu;
    File1: TMenuItem;
    System1: TMenuItem;
    File11: TMenuItem;
    File21: TMenuItem;
    System11: TMenuItem;
    System21: TMenuItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.

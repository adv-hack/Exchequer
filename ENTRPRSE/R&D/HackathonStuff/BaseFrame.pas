unit BaseFrame;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ActnList;

type
  TfrBase = class(TFrame)
    alMain: TActionList;
    pmMain: TPopupMenu;
    aExpand: TAction;
    aCollapse: TAction;
    CollapseAll1: TMenuItem;
    CollapseAll2: TMenuItem;
    aBestFit: TAction;
    ApplyBestFit1: TMenuItem;
    N1: TMenuItem;
    procedure aExpandExecute(Sender: TObject);
    procedure aCollapseExecute(Sender: TObject);
    procedure aBestFitExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Init(); virtual;
    procedure ExpandAll(); virtual; abstract;
    procedure CollapseAll(); virtual; abstract;
    procedure ApplyBestFit(); virtual; abstract;
  end;

implementation

{$R *.dfm}

{ TfrBase }



procedure TfrBase.Init;
begin
//
end;

procedure TfrBase.aExpandExecute(Sender: TObject);
begin
   ExpandAll;
end;

procedure TfrBase.aCollapseExecute(Sender: TObject);
begin
CollapseAll

end;

procedure TfrBase.aBestFitExecute(Sender: TObject);
begin
  ApplyBestFit;
end;

end.

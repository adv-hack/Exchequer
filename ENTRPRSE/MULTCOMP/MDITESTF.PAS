unit mditestf;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, ComCtrls, Buttons;

Const
  WM_SBSFDMsg      =  WM_User+$100;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    ExitBtn: TSpeedButton;
    MultiCompanyManager1: TMenuItem;
    Help1: TMenuItem;
    AsMDIChild1: TMenuItem;
    AsDialog1: TMenuItem;
    SpeedButton1: TSpeedButton;
    DirChecks1: TMenuItem;
    N1: TMenuItem;
    Window: TMenuItem;
    Tile1: TMenuItem;
    procedure Exit1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure AsDialog1Click(Sender: TObject);
    procedure AsMDIChild1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DirChecks1Click(Sender: TObject);
    procedure Tile1Click(Sender: TObject);
  private
    { Private declarations }
    Procedure WMSBSFDMsg(Var Message  :  TMessage); Message WM_SBSFDMsg;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

Uses DllComp, TestF2;

{ IFDEF MH
  Procedure ShowCompMan (SplashHandle : hWnd); External 'EntComp.Dll';
  Procedure InitCompMan (NewApp : TApplication); External 'EntComp.Dll';
  Procedure InitCompDll (NewApp  : TApplication); External 'EntComp.Dll';
  Procedure TermCompDll; External 'EntComp.Dll';
  Procedure MDICompMan  (NotifyHandle : hWnd); External 'EntComp.Dll';
{ ENDIF}

procedure TForm2.FormCreate(Sender: TObject);
begin
  { Get DLL working as part of this program, and open files }
  InitCompDll (Application);
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Close files and restore DLL as separate program }
  TermCompDll;
end;

procedure TForm2.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm2.Help1Click(Sender: TObject);
begin
  ShowMessage ('What do you think this is?' + #10#13#10#13 + 'A real program?');
end;

procedure TForm2.AsDialog1Click(Sender: TObject);
begin
  { Display company manager as normal window }
  InitCompMan (Application);

  ShowCompMan (Self.Handle, '');
end;

{ Display company manager as MDI Child }
procedure TForm2.AsMDIChild1Click(Sender: TObject);
begin
  MDICompMan (Self.Handle);
end;

Procedure TForm2.WMSBSFDMsg(Var Message  :  TMessage);
Begin
  {With Message Do
    Case WParam of
      0  : TermCompDll;

    End; { Case }

  Inherited;
End;

procedure TForm2.DirChecks1Click(Sender: TObject);
Var
  Form3 : TForm3;
begin
  Form3 := TForm3.Create(Self);
end;

procedure TForm2.Tile1Click(Sender: TObject);
begin
  Self.Tile;
end;

end.

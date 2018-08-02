{*********************************************************}
{* ABBREVIA: UBASEDLG.PAS                                *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

unit ubasedlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl;

type
  TBaseDirDlg = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    DriveComboBox1: TDriveComboBox;
    DLB: TDirectoryListBox;
    DirLabel: TLabel;
    ActionLabel: TLabel;
    CheckBox2: TCheckBox;
    CheckBox1: TCheckBox;
    Button3: TButton;
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BaseDirDlg: TBaseDirDlg;

implementation

{$R *.DFM}

uses
  AbUtils,
  uDemoDlg;

procedure TBaseDirDlg.Button3Click(Sender: TObject);
begin
  DemoDlg := TDemoDlg.Create( Self );
  try
    DemoDlg.Caption := 'Create Subdirectory';
    DemoDlg.Edit1.Text := '';
    DemoDlg.ShowModal;
    if ( DemoDlg.ModalResult = mrOK ) and ( DemoDlg.Edit1.Text <> '' ) then
      AbCreateDirectory( DLB.Directory + '\' + DemoDlg.Edit1.Text );
    DLB.Update;
  finally
    DemoDlg.Free;
  end;
end;

end.

{*********************************************************}
{* ABBREVIA: UDEMODLG.PAS                                *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

unit udemodlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TDemoDlg = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DemoDlg: TDemoDlg;

implementation

{$R *.DFM}

end.

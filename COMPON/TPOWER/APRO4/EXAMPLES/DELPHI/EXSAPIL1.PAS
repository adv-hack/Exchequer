{*********************************************************}
{*                     ExSapiL1.PAS                      *}
{*      Copyright (c) TurboPower Software 1997,98        *}
{*                 All rights reserved.                  *}
{*********************************************************}

{**********************Description************************}
{* Lists all installed SAPI voice recognition and speech *}
{* synthesis engines.  Provides a large amount of detail *}
{* on each engine.                                       *}
{*********************************************************}
unit ExSapiL1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls;

type
  TfrmLoading = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ProgressBar1: TProgressBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLoading: TfrmLoading;

implementation

{$R *.DFM}

end.

{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVPEMemo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RVDefine, RVUtil, RVClass, RVTool, RPDefine, ExtCtrls;

type
  TMemoEditor = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
  private
    procedure SetMemoText(Value: string);
    function GetMemoText: string;
  public
    property MemoText: string read GetMemoText write SetMemoText;
  end;

// Procs
  procedure RaveRegister;

implementation
{$R *.DFM}

type
  TRaveMemoPropertyEditor = class(TRavePropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    procedure Edit; override;
    function GetValue: string; override;
  end; { TRaveMemoPropertyEditor }

procedure RaveRegister;
begin { RaveRegister }
{TransOff}
  RegisterRavePropertyEditor(TypeInfo(TRaveMemoString), nil, '', TRaveMemoPropertyEditor);
{TransOn}
end;  { RaveRegister }

(*****************************************************************************}
( class TRaveMemoPropertyEditor
(*****************************************************************************)

function TRaveMemoPropertyEditor.GetOptions: TPropertyOptionsSet;
begin { GetOptions }
  Result := [poReadOnly,poEditor,poMultiSelect];
end;  { GetOptions }

function TRaveMemoPropertyEditor.GetValue: string;
begin { GetValue }
  If GetStrValue(0) = '' then begin
    Result := '';
  end else begin
    Result := '(' + Trans('Memo') + ')';
  end; { else }
end;  { GetValue }

procedure TRaveMemoPropertyEditor.Edit;
begin { Edit }
  With TMemoEditor.Create(Application) do try
    MemoText := GetStrValue(0);
    If ShowModal = mrOK then begin
      SetStrValue(MemoText);
    end; { if }
  finally
    Free;
  end; { with }
end;  { Edit }

(*****************************************************************************}
( class TMemoEditor
(*****************************************************************************)

procedure TMemoEditor.FormCreate(Sender: TObject);
begin
  FormTrans(self);
  PrepareToolWin(self);
end;

procedure TMemoEditor.FormDestroy(Sender: TObject);
begin
  SaveToolWin(self);
end;

procedure TMemoEditor.FormShow(Sender: TObject);
begin
  RestoreToolWin(self);
end;

procedure TMemoEditor.SetMemoText(Value: string);
begin { SetMemoText }
  Memo1.Text := Value;
end;  { SetMemoText }

function TMemoEditor.GetMemoText: string;
begin { GetMemoText }
  Result := Memo1.Text;
end;  { GetMemoText }

procedure TMemoEditor.Memo1KeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #27 then begin { Escape }
    ModalResult := mrCancel;
  end; { if }
end;

initialization
  RegisterProc('RVCL',RaveRegister);
end.


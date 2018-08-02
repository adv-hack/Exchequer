{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVPEStrL;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, RVClass, RVUtil, RVTool, RPDefine;

type
  TStringsDialog = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel4: TPanel;
    StatusLine: TPanel;
    Panel6: TPanel;
    Memo1: TMemo;
    procedure Memo1Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure RaveRegister;

var
  StringsDialog: TStringsDialog;

implementation

{$R *.DFM}

type
  TRaveStringsPropertyEditor = class(TRavePropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    function GetValue: string; override;
  public
    procedure Edit; override;
  end; { TRaveStringsPropertyEditor }

  procedure RaveRegister;

  begin { RaveRegister }
  {TransOff}
    RegisterRavePropertyEditor(TypeInfo(TStrings),nil,'',TRaveStringsPropertyEditor);
  {TransOn}
  end;  { RaveRegister }

(*****************************************************************************}
( class TRaveStringsPropertyEditor
(*****************************************************************************)

  function TRaveStringsPropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := [poReadOnly,poEditor,poMultiSelect];
  end;  { GetOptions }

  function TRaveStringsPropertyEditor.GetValue: string;

  begin { GetValue }
    If TStrings(GetOrdValue(0)).Count = 0 then begin
      Result := '';
    end else begin
      Result := '(' + Trans('Strings') + ')';
    end; { else }
  end;  { GetValue }

  procedure TRaveStringsPropertyEditor.Edit;

  var
    StringsDlg: TStringsDialog;

  begin { Edit }
    StringsDlg := TStringsDialog.Create(nil);
    StringsDlg.Memo1.Lines.Assign(TStrings(GetOrdValue(0)));
    If StringsDlg.ShowModal = mrOk then begin
      SetOrdValue(integer(StringsDlg.Memo1.Lines));
    end; { if }
    StringsDlg.Free;
  end;  { Edit }

(*****************************************************************************}
( class TStringsDialog
(*****************************************************************************)

  procedure TStringsDialog.Memo1Change(Sender: TObject);

  begin { Memo1Change }
    StatusLine.Caption := Trans(Format({Trans+}'%s lines',[IntToStr(Memo1.Lines.Count)]));
  end;  { Memo1Change }

  procedure TStringsDialog.FormDestroy(Sender: TObject);

  begin { FormDestroy }
    SaveToolWin(self);
  end;  { FormDestroy }

  procedure TStringsDialog.FormCreate(Sender: TObject);

  begin { FormCreate }
    FormTrans(self);
    PrepareToolWin(self);
    StatusLine.Caption := Trans(Format({Trans+}'%s lines', [IntToStr(Memo1.Lines.Count)]));
  end;  { FormCreate }

  procedure TStringsDialog.FormShow(Sender: TObject);

  begin { FormShow }
    RestoreToolWin(self);
  end;  { FormShow }

procedure TStringsDialog.FormKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #27 then begin { Escape }
    ModalResult := mrCancel;
  end; { if }
end;

initialization
  RegisterProc('RVCL',RaveRegister);
end.

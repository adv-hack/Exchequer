unit ProcFunc;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, CardProc, ETDateU
  , StdCtrls, ExtCtrls, ComCtrls, GlobVar, EXWrap1U, VarConst, ETStrU, BtrvU2, BTSupU1, ExchLink
  , NeilProc;

type

  TFuncFormMode = (fmPrint, fmProcess);

  TFrmProcessFunction = class(TForm)
    Bevel1: TBevel;
    lText: TLabel;
    Label1: TLabel;
    btnCancel: TButton;
    btnDoIt: TButton;
    cbCategory: TComboBox;
    procedure btnDoItClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    FuncFormMode : TFuncFormMode
    { Public declarations }
  end;

{var
  FrmProcessFunction: TFrmProcessFunction;}

implementation

uses Reports;

{$R *.DFM}

procedure TFrmProcessFunction.btnDoItClick(Sender: TObject);
begin
  if FuncFormMode = fmProcess then ModReports.PrintFunctionBook(cbCategory.ItemIndex - 1, pmFunction)
  else ModReports.PrintFunctionBook(cbCategory.ItemIndex - 1, pmNone);
end;

procedure TFrmProcessFunction.FormCreate(Sender: TObject);
var
  iCat : byte;
begin
  cbCategory.Items.Add('(All Functions)');
  For iCat := 0 to (NoOfFuncCats - 1) do cbCategory.Items.Add('Function ' + CHR(65 + iCat));
  cbCategory.ItemIndex := 0;
end;

procedure TFrmProcessFunction.FormShow(Sender: TObject);
begin
  case FuncFormMode of
    fmPrint : begin
      Caption := 'Print Functions';
      btnDoIt.Caption := '&Print';
      lText.Caption := 'Please pick the functions you wish to print';
      HelpContext := 27;
    end;

    fmProcess : begin
      Caption := 'Process Functions';
      btnDoIt.Caption := '&Process';
      lText.Caption := 'Please pick the functions you wish to process';
      HelpContext := 28;
    end;
  end;{case}
end;

end.

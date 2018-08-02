unit OpenTab;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ANIMATE, ExtCtrls, Inifiles;

type
  TfrmOpenTablesRep = class(TForm)
    Bevel1: TBevel;
    lText: TLabel;
    lStart: TLabel;
    lEnd: TLabel;
    GolfBall: TAnimated;
    edStart: TCurrencyEdit;
    edEnd: TCurrencyEdit;
    btnOK: TButton;
    btnCancel: TButton;
    Bevel2: TBevel;
    cbHideZeros: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    TheIniFile : TIniFile;
  public
    iStart, iEnd : integer;
  end;

var
  frmOpenTablesRep: TfrmOpenTablesRep;

implementation

uses
  Reports, APIUtil, VarConst;

{$R *.DFM}

procedure TfrmOpenTablesRep.FormShow(Sender: TObject);
begin
  edStart.displayformat := '###0'; {cos this gets reset @ run-time - nice}
  edEnd.displayformat := '###0'; {cos this gets reset @ run-time - nice}

  TheIniFile := TIniFile.Create(sEXEDir + 'FUNCBOOK.INI');
  with TheIniFile do begin
    edStart.Text := ReadString('OpenTablesReport','StartNo','1');
    edEnd.Text := ReadString('OpenTablesReport','EndNo','50');
    cbHideZeros.Checked := ReadString('OpenTablesReport','HideZeros','TRUE') = 'TRUE';
  end;{with}
  GolfBall.Play := TRUE;
end;

procedure TfrmOpenTablesRep.btnOKClick(Sender: TObject);
begin
  iStart := StrToInt(edStart.Text);
  iEnd := StrToInt(edEnd.Text);
  if iStart > iEnd then
    begin
      MsgBox('Please input a valid range', mtError,[mbOK],mbOK,'Invalid Range');
      ModalResult := mrNone;
    end
  else begin

    {store defaults in inifile}
    with TheIniFile do begin
      WriteString('OpenTablesReport','StartNo',edStart.Text);
      WriteString('OpenTablesReport','EndNo',edEnd.Text);
      if cbHideZeros.Checked then WriteString('OpenTablesReport','HideZeros','TRUE')
      else WriteString('OpenTablesReport','HideZeros','FALSE');
    end;{with}

    ModalResult := mrOK;
  end;{if}
end;

procedure TfrmOpenTablesRep.FormDestroy(Sender: TObject);
begin
  TheIniFile.Free;
end;

end.

unit PrinterCodes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EPrntDef, StdCtrls, CodeFrame, APIUtil, EnterToTab, TEditVal;

const
  NoOfCodes = 29;

  asCodeDescs : array[1..NoOfCodes] of string = ('Elite', 'Pica', 'Condensed On'
  , 'Condensed Off', 'Enlarged On', 'Enlarged Off', 'Verticly E On', 'Verticly E Off'
  , 'Emphasized On', 'Emphasized Off', 'Double Strike On', 'Double Strike Off'
  , 'Underlined On', 'Underlined Off', 'Italics On', 'Italics Off', 'Quality On'
  , 'Quality Off', 'Std Page Length', 'Reset Printer', 'Special 1', 'Special 2'
  , 'Special 3', 'Special 4', 'Special 5', 'Special 6', 'Special 7', 'Special 8'
  , 'Special 9');

type
  TFrmPrinterCodes = class(TForm)
    Label1: TLabel;
    edName: TEdit;
    Label2: TLabel;
    edPoundChar: TEdit;
    sbCodes: TScrollBox;
    btnOK: TButton;
    btnCancel: TButton;
    EnterToTab1: TEnterToTab;
    edPort: TCurrencyEdit;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    aCodeFrames : Array[1..NoOfCodes] of TfCode;
  public
    PrinterCodes : Printer_DefType;
  end;

{var
  FrmPrinterCodes: TFrmPrinterCodes;}

implementation

{$R *.dfm}

procedure TFrmPrinterCodes.FormShow(Sender: TObject);
var
  fCodeFrame : TfCode;
  iPos :integer;
begin
  For iPos := 1 to NoOfCodes do
  begin
    // Add frame with codes
    fCodeFrame := TfCode.Create(sbCodes);
    fCodeFrame.Name := 'fCode' + IntToStr(iPos);
    fCodeFrame.Parent := sbCodes;
    fCodeFrame.Top := fCodeFrame.Height * (iPos -1);
    fCodeFrame.lName.Caption := asCodeDescs[iPos];

    case iPos of
      1 : fCodeFrame.FillCodes(PrinterCodes.Elite);
      2 : fCodeFrame.FillCodes(PrinterCodes.Pica);
      3 : fCodeFrame.FillCodes(PrinterCodes.Condon);
      4 : fCodeFrame.FillCodes(PrinterCodes.CondOf);
      5 : fCodeFrame.FillCodes(PrinterCodes.EnlrgOn);
      6 : fCodeFrame.FillCodes(PrinterCodes.EnlrgOf);
      7 : fCodeFrame.FillCodes(PrinterCodes.VEnlrgOn);
      8 : fCodeFrame.FillCodes(PrinterCodes.VEnlrgOf);
      9 : fCodeFrame.FillCodes(PrinterCodes.EmphOn);
      10 : fCodeFrame.FillCodes(PrinterCodes.EmphOf);
      11 : fCodeFrame.FillCodes(PrinterCodes.Dson);
      12 : fCodeFrame.FillCodes(PrinterCodes.Dsof);
      13 : fCodeFrame.FillCodes(PrinterCodes.UndyOn);
      14 : fCodeFrame.FillCodes(PrinterCodes.UndyOf);
      15 : fCodeFrame.FillCodes(PrinterCodes.ItalOn);
      16 : fCodeFrame.FillCodes(PrinterCodes.ItalOff);
      17 : fCodeFrame.FillCodes(PrinterCodes.Qon);
      18 : fCodeFrame.FillCodes(PrinterCodes.QOf);
      19 : fCodeFrame.FillCodes(PrinterCodes.Plen66);
      20 : fCodeFrame.FillCodes(PrinterCodes.ResetP);
      21..29 : fCodeFrame.FillCodes(PrinterCodes.PXtra[iPos - 20]);
    end;{case}

    // save reference to frames
    aCodeFrames[iPos] := fCodeFrame;
  end;{for}

  edName.Text := PrinterCodes.Name;
  edPoundChar.Text := PrinterCodes.PoundTx;
  edPort.Value := PrinterCodes.Port;
end;

procedure TFrmPrinterCodes.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmPrinterCodes.btnOKClick(Sender: TObject);
var
  fCodeFrame : TfCode;
  iPos :integer;
begin
  // validate name
  if Trim(edName.Text) = '' then
  begin
    MsgBox('You must enter a name for the printer, in order to save these details.', mtError
    , [mbOK], mbOK, 'Printer Name');
  end else
  begin
    // Update Local Record from Form
    PrinterCodes.Name := edName.Text;
    if length(edPoundChar.Text) = 1 then PrinterCodes.PoundTx := edPoundChar.Text[1];
    PrinterCodes.Port := StrToIntDef(edPort.Text, 1);

    For iPos := 1 to NoOfCodes do
    begin
      fCodeFrame := aCodeFrames[iPos];
      case iPos of
        1 : fCodeFrame.GetCodes(PrinterCodes.Elite);
        2 : fCodeFrame.GetCodes(PrinterCodes.Pica);
        3 : fCodeFrame.GetCodes(PrinterCodes.Condon);
        4 : fCodeFrame.GetCodes(PrinterCodes.CondOf);
        5 : fCodeFrame.GetCodes(PrinterCodes.EnlrgOn);
        6 : fCodeFrame.GetCodes(PrinterCodes.EnlrgOf);
        7 : fCodeFrame.GetCodes(PrinterCodes.VEnlrgOn);
        8 : fCodeFrame.GetCodes(PrinterCodes.VEnlrgOf);
        9 : fCodeFrame.GetCodes(PrinterCodes.EmphOn);
        10 : fCodeFrame.GetCodes(PrinterCodes.EmphOf);
        11 : fCodeFrame.GetCodes(PrinterCodes.Dson);
        12 : fCodeFrame.GetCodes(PrinterCodes.Dsof);
        13 : fCodeFrame.GetCodes(PrinterCodes.UndyOn);
        14 : fCodeFrame.GetCodes(PrinterCodes.UndyOf);
        15 : fCodeFrame.GetCodes(PrinterCodes.ItalOn);
        16 : fCodeFrame.GetCodes(PrinterCodes.ItalOff);
        17 : fCodeFrame.GetCodes(PrinterCodes.Qon);
        18 : fCodeFrame.GetCodes(PrinterCodes.QOf);
        19 : fCodeFrame.GetCodes(PrinterCodes.Plen66);
        20 : fCodeFrame.GetCodes(PrinterCodes.ResetP);
        21..29 : fCodeFrame.GetCodes(PrinterCodes.PXtra[iPos - 20]);
      end;{case}
    end;

    ModalResult := mrOK;
  end;
end;

procedure TFrmPrinterCodes.FormCreate(Sender: TObject);
begin
  edPort.DisplayFormat := '#';
end;

end.

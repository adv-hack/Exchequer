unit progtill;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Forms, Dialogs, Controls, StdCtrls, 
  Buttons, ExtCtrls, CheckLst, VarConst, MiscUtil, Progress, CardProc;

type
  TwizReprogTills = class(TForm)
    WizardPages: TNotebook;
    lIntro: TLabel;
    Bevel2: TBevel;
    Bevel1: TBevel;
    Label1: TLabel;
    lTillName: TLabel;
    rbLedgerBal: TRadioButton;
    rbTill: TRadioButton;
    cmbTill: TComboBox;
    Bevel3: TBevel;
    Label3: TLabel;
    lbTills: TCheckListBox;
    Bevel4: TBevel;
    Label5: TLabel;
    btnPg2Next: TButton;
    btnPg2Prev: TButton;
    btnPg1Next: TButton;
    btnPg3Prev: TButton;
    btnPg3Next: TButton;
    lOutro: TLabel;
    Bevel5: TBevel;
    btnPg4Prev: TButton;
    btnReprogram: TButton;
    btnCancel: TButton;
    procedure btnPg1NextClick(Sender: TObject);
    procedure ChangePage(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EnableNextBut(Sender: TObject);
    procedure lbTillsClickCheck(Sender: TObject);
    procedure WizardPagesPageChanged(Sender: TObject);
    procedure btnPg3PrevClick(Sender: TObject);
    procedure btnReprogramClick(Sender: TObject);
  private
    sToDo, sSelect : string;
    bFillList : boolean;
    { Private declarations }
  public
    { Public declarations }
    bDoDetails, bDoBalances : boolean;
    aiTillsToSendTo : array of byte;
    iProgTillNo : byte;
  end;

var
  wizReprogTills: TwizReprogTills;

implementation

{$R *.DFM}

procedure TwizReprogTills.btnPg1NextClick(Sender: TObject);
begin
  if bDoBalances then WizardPages.PageIndex := 1
  else WizardPages.PageIndex := 2;
end;

procedure TwizReprogTills.ChangePage(Sender: TObject);
begin
  WizardPages.PageIndex := TWinControl(Sender).Tag;
end;

procedure TwizReprogTills.FormCreate(Sender: TObject);
begin
  WizardPages.PageIndex := 0;
end;

procedure TwizReprogTills.FormShow(Sender: TObject);
var
  iTill : integer;
begin
  {set intro caption}
  if bDoDetails then
    begin
      if bDoBalances then
        begin
          sToDo := 'Card Details and Balances';
          sSelect := 'where to get the new balances from, and the tills to reprogram';
        end
      else begin
        sToDo := 'Card Details';
        sSelect := 'which tills to reprogram';
      end;{if}
    end
  else begin
    sToDo := 'Card Balances';
    sSelect := 'where to get the new balances from';
  end;{if}
  lIntro.Caption := 'You are about to reprogram selected tills with ' + sToDo
  + '. ' + CHR(13) + CHR(13) + 'You will need to select ' + sSelect
  + '. ' + CHR(13) + CHR(13) + 'At the end of the wizard click on ''Reprogram'' to program the selected tills.';


  {fill Combo Box}
  with Syss do begin
    for iTill := 1 to NoTills do cmbTill.Items.Add(IntToStr(iTill) + ' - ' + Syss.Till[iTill].Name);
  end;{with}
  cmbTill.ItemIndex := 0;
  bFillList := TRUE;
end;

procedure TwizReprogTills.EnableNextBut(Sender: TObject);
begin
  btnPg2Next.Enabled := rbLedgerBal.Checked or (cmbTill.ItemIndex <> -1);
  cmbTill.Enabled := rbTill.Checked;
  lTillName.Enabled := rbTill.Checked;
  bFillList := TRUE;
end;

procedure TwizReprogTills.lbTillsClickCheck(Sender: TObject);
var
  bChecked : boolean;
  iPos : byte;
begin
  bChecked := FALSE;
  For iPos := 0 to lbTills.Items.Count - 1 do if lbTills.checked[iPos] then bChecked := TRUE;
  btnPg3Next.Enabled := bChecked;
end;

procedure TwizReprogTills.WizardPagesPageChanged(Sender: TObject);
var
  iTillsToSend, iTill : byte;
  iPos : integer;
  sCaption : string;
begin
  case WizardPages.PageIndex of
    2 : begin
      if bFillList then begin
        ClearList(lbTills.Items);
        {fill Combo and List Box}
        with Syss do begin
          for iTill := 1 to NoTills do begin
            if rbLedgerBal.Checked or (bDoDetails and (not bDoBalances))
            or (cmbTill.ItemIndex <> (iTill - 1))
            then lbTills.Items.Add(IntToStr(iTill) + ' - ' + Syss.Till[iTill].Name);
          end;{for}
        end;{with}
        bFillList := FALSE;
        btnPg3Next.Enabled := FALSE;
      end;{if}
    end;

    3 : begin
      sCaption := 'You are about to reprogram selected tills with ' + sToDo + '.' + CHR(13) + CHR(13);
      if bDoBalances then begin
        sCaption := sCaption + 'You have selected to get the balances from ';
        if rbLedgerBal.Checked then sCaption := sCaption + 'the ledger balance on the card details.'
        else sCaption := sCaption + 'Till ' + cmbTill.Items[cmbTill.ItemIndex] + '.';
        sCaption := sCaption + CHR(13) + CHR(13);
      end;{if}

      sCaption := sCaption + 'The tills you have selected are : ';

      setlength(aiTillsToSendTo, lbTills.Items.Count);
      iTillsToSend := 0;
      For iPos := 0 to lbTills.Items.Count - 1 do begin
        if lbTills.checked[iPos] then begin
          sCaption := sCaption + copy(lbTills.Items[iPos],5,255) + ', ';

          {fill array of tills to send}
          aiTillsToSendTo[iTillsToSend] := StrToInt(lbTills.Items[iPos][1]);
          inc(iTillsToSend);
        end;{if}
      end;{for}
      setlength(aiTillsToSendTo, iTillsToSend);

      sCaption := copy(sCaption, 1, Length(sCaption) - 2) + CHR(13) + CHR(13)
      + 'Click on ''Reprogram'' to reprogram the tills.';
      lOutro.Caption := sCaption;
    end;
  end;{case}
end;

procedure TwizReprogTills.btnPg3PrevClick(Sender: TObject);
begin
  if bDoBalances then WizardPages.PageIndex := 1
  else WizardPages.PageIndex := 0;
end;

procedure TwizReprogTills.btnReprogramClick(Sender: TObject);
begin
  if rbLedgerBal.Checked then iProgTillNo := 0
  else iProgTillNo := cmbTill.ItemIndex + 1;
end;

end.

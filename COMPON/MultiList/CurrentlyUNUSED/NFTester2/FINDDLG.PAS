unit FindDlg;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, ExtCtrls, TCustom, APIUtil ;

type
  TFindMode = (fmCardNumber, fmMemberName, fmClubCode, fmChangeNumber, fmChangeIssueNumber);

  TFrmFindDlg = class(TForm)
    edValue: Text8Pt;
    lFind: TLabel;
    SBSButton1: TSBSButton;
    SBSButton2: TSBSButton;
    Bevel1: TBevel;
    procedure FormShow(Sender: TObject);
    procedure SBSButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    FindMode : TFindMode;
  end;

var
  FrmFindDlg: TFrmFindDlg;

implementation

{$R *.DFM}

procedure TFrmFindDlg.FormShow(Sender: TObject);
begin
  case FindMode of
    fmCardNumber, fmMemberName, fmClubCode : begin
      case FindMode of
        fmCardNumber : lFind.Caption := 'Card Number :';
        fmMemberName : lFind.Caption := 'Member Name :';
        fmClubCode : lFind.Caption := 'Club Code :';
      end;{case}
      Caption := 'Find - by ' + LowerCase(lFind.Caption);
      HelpContext := 5;
    end;

    fmChangeNumber : begin
      lFind.Caption := 'New Number :';
      Caption := 'Change Card Number';
      HelpContext := 7;
    end;

    fmChangeIssueNumber : begin
      lFind.Caption := 'New Issue No :';
      Caption := 'Change Issue Number';
      HelpContext := 7;
    end;
  end;{case}
end;

procedure TFrmFindDlg.SBSButton2Click(Sender: TObject);
begin
  if FindMode = fmChangeNumber then begin
    if StrToIntDef(edValue.Text,0) <= 0 then begin
      MsgBox('You have entered an invalid card number.',mtError,[mbOK],mbOK,'Invalid Card Number');
      ModalResult := mrNone;
      ActiveControl := edValue;
    end;{if}
  end;{if}

  if FindMode = fmChangeIssueNumber then begin
    if (StrToIntDef(edValue.Text,0) <= 0) or (StrToIntDef(edValue.Text,0) > 99) then begin
      MsgBox('You have entered an invalid issue number.',mtError,[mbOK],mbOK,'Invalid Issue Number');
      ModalResult := mrNone;
      ActiveControl := edValue;
    end;{if}
  end;{if}
end;

end.

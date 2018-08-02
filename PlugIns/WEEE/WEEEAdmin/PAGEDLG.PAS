unit PageDlg;

{ nfrewer440 12:19 22/02/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface          

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, bkgroup, BorBtns, TEditVal;

type
  TPageSetupDlg = class(TForm)
    SBSBackGroup1: TSBSBackGroup;
    Btn_Print: TButton;
    Btn_Cancel: TButton;
    BorRadio1: TBorRadio;
    BorRadio2: TBorRadio;
    BorRadio3: TBorRadio;
    Ccy_FPage: TCurrencyEdit;
    Ccy_LPage: TCurrencyEdit;
    Label81: Label8;
    SBSBackGroup2: TSBSBackGroup;
    Ccy_Copies: TCurrencyEdit;
    Label82: Label8;
    procedure Btn_PrintClick(Sender: TObject);
    procedure Btn_CancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BorRadio1Click(Sender: TObject);
    procedure BorRadio3Click(Sender: TObject);
    procedure BorRadio2Click(Sender: TObject);
  private
    { Private declarations }
    FNoPages, FCurrPage, FCopies : LongInt;

    Procedure SetCopies(Value : LongInt);
    Procedure SetNoPages(Value : LongInt);
    Procedure SetCurrPage(Value : LongInt);
  public
    { Public declarations }
    Ok             : Boolean;
    FPage, LPage   : LongInt;
    Function  Execute : Boolean;
    Procedure HideCopies;

    Property Copies : LongInt Read FCopies Write SetCopies;
    Property NoPages : LongInt Read FNoPages Write SetNoPages;
    Property CurrPage : LongInt Read FCurrPage Write SetCurrPage;
  end;


implementation

{$R *.DFM}

procedure TPageSetupDlg.FormCreate(Sender: TObject);
begin
  Ok      := False;
  NoPages := 0;
  FPage   := 0;
  LPage   := 0;
end;

Procedure TPageSetupDlg.SetCopies(Value : LongInt);
Begin
  If (Value < 1) Then Value := 1;
  If (Value > 99) Then Value := 99;

  FCopies := Value;
  Ccy_Copies.Value := FCopies;
End;

Procedure TPageSetupDlg.SetNoPages(Value : LongInt);
Begin
  FNoPages := Value;
  Ccy_FPage.Value := 1;
  Ccy_LPage.Value := FNoPages;

  BorRadio1Click(Self);
End;

Procedure TPageSetupDlg.SetCurrPage(Value : LongInt);
Begin
  FCurrPage := Value;
End;

procedure TPageSetupDlg.Btn_PrintClick(Sender: TObject);
Var
  Valid : Boolean;
begin
  Valid := True;
  If BorRadio2.Checked Then Begin
    { HM-05/11/97: have to move focus away from currency edit controls to get them to convert text properly }
    Btn_Print.SetFocus;

    { Check we have a valid page range }
    Valid := (Trunc(Ccy_FPage.Value) >= 1) And (Trunc(Ccy_FPage.Value) <= NoPages);
    If Valid Then
      FPage := Trunc(Ccy_FPage.Value)
    Else
      MessageDlg ('The first page in the range is invalid', mtError, [mbOk], 0);

    If Valid Then Begin
      Valid := (Trunc(Ccy_LPage.Value) >= FPage) And (Trunc(Ccy_LPage.Value) <= NoPages);
      If Valid Then
        LPage := Trunc(Ccy_LPage.Value)
      Else
        MessageDlg ('The last page in the range is invalid', mtError, [mbOk], 0);
    End; { If }
  End; { If }

  If (Trunc(Ccy_Copies.Value) >= 1) And (Trunc(Ccy_Copies.Value) <= 99) Then
    Copies := Trunc(Ccy_Copies.Value)
  Else Begin
    Valid := False;
    MessageDlg ('Invalid number of copies, must be in the range 1-99', mtError, [mbOk], 0);
  End; { If }

  If Valid Then Begin
    If BorRadio1.Checked Or BorRadio2.Checked Or BorRadio3.Checked Then Begin
      Ok := True;
      Close;
    End { If }
    Else
      MessageDlg ('A Page Range must be selected', mtWarning, [mbOk], 0);
  End; { If }
end;

procedure TPageSetupDlg.Btn_CancelClick(Sender: TObject);
begin
  Ok := False;
  Close;
end;

Function TPageSetupDlg.Execute : Boolean;
begin
  ShowModal;

  Result := Ok;
end;

procedure TPageSetupDlg.BorRadio1Click(Sender: TObject);
begin
  { All Pages }
  FPage := 1;
  LPage := NoPages;

  Ccy_FPage.Enabled := False;
  Ccy_LPage.Enabled := False;
end;

procedure TPageSetupDlg.BorRadio3Click(Sender: TObject);
begin
  { Current Page }
  FPage := CurrPage;
  LPage := CurrPage;

  Ccy_FPage.Enabled := False;
  Ccy_LPage.Enabled := False;
end;

procedure TPageSetupDlg.BorRadio2Click(Sender: TObject);
begin
  { Page Range }
  Ccy_FPage.Enabled := True;
  Ccy_LPage.Enabled := True;
end;

Procedure TPageSetupDlg.HideCopies;
Begin
  FCopies := 1;
  Ccy_Copies.Value := FCopies;

  { Hide Controls }
  SBSBackGroup2.Visible := False;
  Label82.Visible := False;
  Ccy_Copies.Enabled := False;
  Ccy_Copies.Visible := False;
  ClientHeight := 108;
End;

end.

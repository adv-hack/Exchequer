unit Compwiz4;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SetupBas, ExtCtrls, StdCtrls, BorBtns, TEditVal, Mask;

type
  TCompDetail4 = class(TSetupTemplate)
    Label89: Label8;
    Label84: Label8;
    cpLastRet: TEditDate;
    cpVATMonth: TCurrencyEdit;
    cpVatIntra: TBorCheck;
    cpVATNo: Text8Pt;
    lstVATScheme: TComboBox;
    Label81: Label8;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Function ValidOk(VCode : Char) : Boolean; OverRide;
  public
    { Public declarations }
  end;

var
  CompDetail4: TCompDetail4;

implementation

{$R *.DFM}

Uses Brand;

procedure TCompDetail4.FormCreate(Sender: TObject);
begin
  inherited;

  If (Branding.pbProduct = ptLITE) Then
    lstVATScheme.ItemIndex := -1
  Else
    lstVATScheme.ItemIndex := 1;
end;

{ Returns True if all entry fields are ok }
Function TCompDetail4.ValidOk(VCode : Char) : Boolean;
Begin
  If (VCode = 'N') Then Begin
    { Check VAT Months in 1..12 }
    Result := (Round(cpVATMonth.Value) In [1..12]);
    If (Not Result) Then Begin
      If cpVATMonth.CanFocus Then cpVATMonth.SetFocus;
      MessageDlg ('The monthly interval between VAT Returns must be in the range 1 to 12', mtWarning, [mbOk], 0);
    End; { If }

    If Result Then
    Begin
      Result := (lstVATScheme.ItemIndex <> -1);
      If (Not Result) Then Begin
        If lstVATScheme.CanFocus Then lstVATScheme.SetFocus;
        MessageDlg ('The VAT Scheme must be specified', mtWarning, [mbOk], 0);
      End; { If }
    End; // If Result
  End { If }
  Else
    Result := True;
End;

end.

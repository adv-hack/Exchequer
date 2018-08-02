unit CompWiz5;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SetupBas, ExtCtrls, StdCtrls, TEditVal, Mask;

type
  TCompDetail5 = class(TSetupTemplate)
    Label86: Label8;
    cpYearStart: TEditDate;
    cpPeriods: TCurrencyEdit;
  private
    { Private declarations }
    Function ValidOk(VCode : Char) : Boolean; OverRide;
  public
    { Public declarations }
  end;

var
  CompDetail5: TCompDetail5;

implementation

{$R *.DFM}

{ Returns True if all entry fields are ok }
Function TCompDetail5.ValidOk(VCode : Char) : Boolean;
Begin
  If (VCode = 'N') Then Begin
    { Check Periods / Year in 1..99 }
    Result := (Round(cpPeriods.Value) In [1..99]);
    If (Not Result) Then Begin
      If cpPeriods.CanFocus Then cpPeriods.SetFocus;
      MessageDlg ('The number of periods per financial year must be in the range 1 to 99', mtWarning, [mbOk], 0);
    End; { If }
  End { If }
  Else
    Result := True;
End;

end.

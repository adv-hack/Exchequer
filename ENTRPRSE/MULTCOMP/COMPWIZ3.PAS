unit CompWiz3;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SetupBas, ExtCtrls, StdCtrls, TEditVal, Mask;

type
  TCompDetail3 = class(TSetupTemplate)
    Label88: Label8;
    Label83: Label8;
    cpPhone: Text8Pt;
    cpFax: Text8Pt;
    cpCountry: TSBSComboBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Function ValidOk(VCode : Char) : Boolean; OverRide;
  public
    { Public declarations }
    Procedure AddOz;
    Procedure AddNZ;
    Procedure AddSing;
    Procedure AddRSA;
    Procedure AddUK;
    Procedure AddEIRE;
  end;

var
  CompDetail3: TCompDetail3;

implementation

{$R *.DFM}

{ Returns True if all entry fields are ok }
Function TCompDetail3.ValidOk(VCode : Char) : Boolean;
Begin
  If (VCode = 'N') Then Begin
    Result := cpCountry.ItemIndex <> -1;

    If (Not Result) Then
      MessageDlg ('The Country must be set', mtWarning, [mbOk], 0);
  End { If }
  Else
    Result := True;
End;

procedure TCompDetail3.FormCreate(Sender: TObject);
begin
  inherited;

  { Add entries for country code }
  cpCountry.Items.Clear;
  AddOz;
  AddNZ;
  AddSing;
  AddRSA;
  AddUK;
end;

Procedure TCompDetail3.AddOz;
Var
  Idx : LongInt;
Begin { AddOz }
  Idx := 0;
  cpCountry.Items.AddObject ('Australia', Pointer(Idx));
End; { AddOz }

Procedure TCompDetail3.AddNZ;
Var
  Idx : LongInt;
Begin { AddNZ }
  Idx := 1;
  cpCountry.Items.AddObject ('New Zealand', Pointer(Idx));
End; { AddNZ }

Procedure TCompDetail3.AddSing;
Var
  Idx : LongInt;
Begin { AddSing }
  Idx := 2;
  cpCountry.Items.AddObject ('Singapore', Pointer(Idx));
End; { AddSing }

Procedure TCompDetail3.AddRSA;
Var
  Idx : LongInt;
Begin { AddRSA }
  Idx := 3;
  cpCountry.Items.AddObject ('South Africa', Pointer(Idx));
End; { AddRSA }

Procedure TCompDetail3.AddUK;
Var
  Idx : LongInt;
Begin { AddUK }
  Idx := 4;
  cpCountry.Items.AddObject ('United Kingdom', Pointer(Idx));
End; { AddUK }

Procedure TCompDetail3.AddEire;
Var
  Idx : LongInt;
Begin { AddEire }
  Idx := 5;
  cpCountry.Items.AddObject ('Ireland', Pointer(Idx));
End; { AddEire }

end.


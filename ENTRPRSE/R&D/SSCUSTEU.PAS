unit SSCustEU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, bkgroup,
  GlobVar, VarConst, BorBtns, Mask;


type
  TEditCustCaption = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    SBSBackGroup1: TSBSBackGroup;
    PALab: Label8;
    BorCheck1: TBorCheck;
    fCaption: Text8Pt;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    private
      PrevHState  :  Boolean;

      Procedure OutIS;

      Procedure Form2IS;

    public
      { Public declarations }
      PAValue    : String;
      SetBuild   : Boolean;

      Function InitIS(tCaption  :  String;
                      SuggBuild,
                      ShowHode  :  Boolean)  :  Word;

  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  SBSComp2,
  CurrncyU,
  BTSupU1,
  BTSupU2;

{$R *.DFM}



{ ==== Procedure to Display Address ==== }

Procedure TEditCustCaption.OutIS;


Begin
  fCaption.Text:=PAValue;
  BorCheck1.Checked:=SetBuild;
end;



Procedure TEditCustCaption.Form2IS;

Begin
  PAValue:=fCaption.Text;
  SetBuild:=BorCheck1.Checked;

end;


Function TEditCustCaption.InitIS(tCaption  :  String;
                                 SuggBuild,
                                 ShowHode  :  Boolean)  :  Word;


Begin
  PAValue:=tCaption;
  SetBuild:=SuggBuild;

  BorCheck1.Visible:=ShowHode;

  OutIS;

  SetAllowHotKey(BOff,PrevHState);

  Result:=ShowModal;

  SetAllowHotKey(BOn,PrevHState);

  If (Result=mrOk) then
  Begin

    Form2IS;
  end;
end;



procedure TEditCustCaption.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TEditCustCaption.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;


procedure TEditCustCaption.FormCreate(Sender: TObject);
begin
  ClientHeight:=139;
  ClientWidth:=180;
end;

end.

unit NmlCDIU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, bkgroup,
  GlobVar, VarConst, BorBtns, Mask;


type
  TEditCCDep = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    SBSBackGroup1: TSBSBackGroup;
    Label83: Label8;
    Id3CCF: Text8Pt;
    Id3DepF: Text8Pt;
    Label81: Label8;
    Label82: Label8;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure Id3CCFExit(Sender: TObject);
    private
      PrevHState  :  Boolean;

      Procedure OutIS;

      Procedure Form2IS;

    public
      { Public declarations }
      PAValue    : String;
      CCDMode    : Boolean;

      Function InitIS(tCaption  :  String;
                      tCCDMode  :  Boolean)  :  word;

  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  SBSComp2,
  VarRec2U,
  CurrncyU,
  InvListU,
  BTKeys1U,
  BTSupU1,
  BTSupU2;

{$R *.DFM}



{ ==== Procedure to Display Address ==== }

Procedure TEditCCDep.OutIS;


Begin
  With Syss do
  If (UseCCDep and Not PostCCDCombo) then
  Begin
    If CCDMode then
      Id3DepF.Enabled:=BOff
    else
      Id3CCF.Enabled:=BOff;

    Id3DepF.TabStop:=Id3DepF.Enabled;
    Id3CCF.TabStop:=Id3CCF.Enabled;

  end;

  If (Length(PAValue)>ccKeyLen) then
  Begin
    If CCDMode then
    Begin
      Id3CCF.Text:=Copy(PAValue,1,ccKeyLen);
      Id3DepF.Text:=Copy(PAValue,5,ccKeyLen);
    end
    else
    Begin
      Id3CCF.Text:=Copy(PAValue,5,ccKeyLen);
      Id3DepF.Text:=Copy(PAValue,1,ccKeyLen);
    end;
  end
  else
  Begin
    If CCDMode then
      Id3CCF.Text:=PAValue
    else
      Id3DepF.Text:=PAValue;

  end;
end;



Procedure TEditCCDep.Form2IS;
Var
  BCCDep  :  CCDepType;
Begin
  BCCDep[BOff]:=Id3DepF.Text;
  BCCDep[BOn]:=Id3CCF.Text;

  If (Not EmptyKey(Id3CCF.Text,ccKeyLen)) and  (Not EmptyKey(Id3DepF.Text,ccKeyLen)) then
  Begin
    PAValue:=CalcCCDepKey(CCDMode,BCCDep);
  end
  else
    PAValue:=BCCDep[CCDMode];

end;


Function TEditCCDep.InitIS(tCaption  :  String;
                                 tCCDMode  :  Boolean)  :  word;


Begin
  PAValue:=tCaption;
  CCDMode:=tCCDMode;


  OutIS;

  SetAllowHotKey(BOff,PrevHState);

  Result:=ShowModal;

  SetAllowHotKey(BOn,PrevHState);

  If (Result=mrOk) then
  Begin

    Form2IS;
  end;
end;



procedure TEditCCDep.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TEditCCDep.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;


procedure TEditCCDep.FormCreate(Sender: TObject);
begin
  ClientHeight:=126;
  ClientWidth:=180;
end;

procedure TEditCCDep.Id3CCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  IsCC       :  Boolean;


begin
  Inherited;

  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      FoundCode:=Name;

      IsCC:=Match_Glob(Sizeof(FoundCode),'CC',FoundCode,FoundOk);

      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If (AltMod) and (ActiveControl<>CanCP1Btn) and
          (Syss.UseCCDep)  and (FoundCode<>'') then
      Begin

        StillEdit:=BOn;

        //TG 15-05-2017 2017 R2 18699 - Access Violation message - creating Job Record using inactive CC/Dept
        //Mode 2 has to sent instead of 0
        FoundOk:=(GetCCDep(Self.Owner,FoundCode,FoundCode,IsCC,2));

        If (FoundOk) then
        Begin

          StillEdit:=BOff;

          Text:=FoundCode;

        end
        else
        Begin

          SetFocus;
        end; {If not found..}
      end;

    end; {with..}
  {$ENDIF}
end;

end.

unit MCRVCCIU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, bkgroup,
  GlobVar, VarConst, VarRec2U, BorBtns, Mask;


type
  TMCRVCCDep = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    SBSBackGroup1: TSBSBackGroup;
    Label83: Label8;
    Id3CCF: Text8Pt;
    Id3DepF: Text8Pt;
    Label81: Label8;
    Label82: Label8;
    RestRVAChk: TCheckBox;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure Id3CCFExit(Sender: TObject);
    //TG-01-06-2017- ABSEXCH-18682- implementing validation for CC and Dep
    function CheckCompleted :Boolean ;
    procedure OkCP1BtnClick(Sender: TObject);
    private
      PrevHState  :  Boolean;

      Procedure OutIS;

      Procedure Form2IS;

    public
      { Public declarations }
      BCCDep  :  CCDepType;
      BRevert :  Boolean;


      Function InitIS :  word;

  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  SBSComp2,
  CurrncyU,
  InvListU,
  BTKeys1U,
  BTSupU1,
  BTSupU2;

{$R *.DFM}



{ ==== Procedure to Display Address ==== }

Procedure TMCRVCCDep.OutIS;


Begin
  With Syss do
  If (Not UseCCDep) then
  Begin
    Id3CCF.Visible:=BOff; Id3DepF.Visible:=BOff;
    Label83.Visible:=BOff;
    Label81.Visible:=BOff;
    Label82.Visible:=BOff;

  end;

  {$IFDEF LTE}
    RestRVAChk.Visible:=BOff;
  {$ENDIF}

end;



Procedure TMCRVCCDep.Form2IS;
Begin
  BCCDep[BOff]:=Id3DepF.Text;
  BCCDep[BOn]:=Id3CCF.Text;

  BRevert:=RestRVAChk.Checked;
end;


Function TMCRVCCDep.InitIS  :  word;


Begin

  OutIS;

  Repeat
    SetAllowHotKey(BOff,PrevHState);

    Result:=ShowModal;

    SetAllowHotKey(BOn,PrevHState);

  Until ((Id3CCF.Text<>'')  and (Id3DepF.Text<>'')) or (Result<>mrOk) or (Not Syss.UseCCDep);
  If (Result=mrOk) then
  Begin

    Form2IS;

    LastValueObj.UpdateAllLastValues(Self);
  end;
end;



procedure TMCRVCCDep.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TMCRVCCDep.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;


procedure TMCRVCCDep.FormCreate(Sender: TObject);
  Const
    RateType     :  Array[BOff..BOn] of Str15 = ('Company Rate','Daily Rate');

begin
  //AP : 12/05/2017 : ABSEXCH-18598 : UI Changes - Revaluation Defaults screen
  ClientWidth:=509;
  if (Syss.UseCCDep) then
  begin
    ClientHeight:=191;
  end
  else
  begin
    SBSBackGroup1.Height:=70;
    RestRVAChk.Top:=30;
    OkCP1Btn.Top:=80;
    CanCP1Btn.Top:=80;
    ClientHeight:=110;
  end;

  //AP-13-06-2017- ABSEXCH-17121- Removed the type name of rate used in system setup from caption
  //RestRVAChk.Caption:=RestRVAChk.Caption+RateType[UseCoDayRate];

  LastValueObj.GetAllLastValuesFull(Self);
  //TG-01-06-2017- ABSEXCH-18682- implementing validation for CC and Dep
  if syss.UseCCDep then
  	CheckCompleted;
end;

procedure TMCRVCCDep.Id3CCFExit(Sender: TObject);
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

      If ((AltMod) or (Foundcode='')) and (ActiveControl<>CanCP1Btn) and (Syss.UseCCDep)  then
      Begin

        StillEdit:=BOn;

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

//TG-01-06-2017- ABSEXCH-18682- implementing validation for CC and Dep
function TMCRVCCDep.CheckCompleted: Boolean;
var
	FoundCode:  Str20;
  mbRet    : Byte;
begin
	  FoundCode := EmptyStr;
  		if Id3CCF.Text <> '' then
      	Result := GetCCDep(Self,Id3CCF.Text, FoundCode,true,-1);
        if not result then
          Id3CCF.Text := '';
      if Id3DepF.Text <> '' then
      	Result :=  GetCCDep(Self.Owner,Id3DepF.Text, FoundCode,false,-1);
        if not result then
          Id3DepF.Text := '';
end;

procedure TMCRVCCDep.OkCP1BtnClick(Sender: TObject);
begin
	//TG-01-06-2017- ABSEXCH-18682- implementing validation for CC and Dep
  if syss.UseCCDep then
  	CheckCompleted;
 OkCP1Btn.modalResult := MrCancel;
end;

end.

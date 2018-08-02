unit PrgeOrdU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Genentu, StdCtrls, ANIMATE, ExtCtrls, SBSPanel, bkgroup, ComCtrls, UnTils,
    SpeF3U, TEditVal, BorBtns, Mask;

type
  TPurgeOrderI = class(TTestCust)
    Label2: TLabel;
    PrgPrYr: TEditPeriod;
    Label81: Label8;
    IncACF: Text8Pt;
    Label82: Label8;
    Label83: Label8;
    ExcACF: Text8Pt;
    Label84: Label8;
    IncAcTyp: Text8Pt;
    Label85: Label8;
    ExcAcTyp: Text8Pt;
    ShrinkF: TBorCheck;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure IncACFExit(Sender: TObject);
  private
    { Private declarations }

    procedure Form2PurgeO;
    procedure OutPurgeO;

    Procedure WMCustGetRec(Var Message  :  TMessage);  Message WM_CustGetRec;


  public
    { Public declarations }

    procedure ShowBar(Waiting  :  Boolean);


  end;


implementation

Uses
  GlobVar,
  VarConst,
  BtrvU2,
  PurgeOU,
  Purge1U,
  ReBuildU,
  ReBuld1U,
  ProgU;

{$R *.DFM}

procedure TPurgeOrderI.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  inherited;
  Animated1.Play:=False;
  Animated1.visible:=BOff;
  SBSPanel1.Visible:=BOff;

  ClientHeight:=240;
  ClientWidth:=395;
  OutPurgeO;

end;



procedure TPurgeOrderI.OutPurgeO;

Begin
  With Purge_OrdRec^ do
  Begin
    PrgPrYr.InitPeriod(PurgePr,PurgeYr,BOn,BOn);
    IncACF.Text:=IncCust;
    ExcACF.Text:=ExcCust;
    IncACTyp.Text:=IncType;
    ExcACTyp.Text:=ExcType;
    ShrinkF.Checked:=BOn;
    OrderMode:=BOn;
  end; {With..}
end;


procedure TPurgeOrderI.Form2PurgeO;

Begin
  With Purge_OrdRec^ do
  Begin
    PrgPrYr.InitPeriod(PurgePr,PurgeYr,BOff,BOff);
    If (Trim(IncACF.Text)<>'') then
      IncCust:=FullCustCode(IncACF.Text)
    else
      IncCust:='';

    If (Trim(ExcACF.Text)<>'') then
      ExcCust:=FullCustCode(ExcACF.Text)
    else
      ExcCust:='';

    IncType:=IncACTyp.Text;
    ExcType:=ExcACTyp.Text;
    RunRBuild:=ShrinkF.Checked;
  end; {With..}
end;


Procedure TPurgeOrderI.WMCustGetRec(Var Message  :  TMessage);

Begin
  With Message do
  Begin


    Case WParam of

      10 :  Purge_Control(ProgBar);


      11 :  ;



      else  Inherited;

    end; {Case..}

  end; {With..}


end;



procedure TPurgeOrderI.ShowBar(Waiting  :  Boolean);

Var
  n  :  Integer;

Begin
  Animated1.Play:=False;

  Form2PurgeO;
{
  ProgBar:=TGenProg.Create(Self);

  try
    With ProgBar do
    Begin


      ShowModal;

    end;

  finally

    ProgBar.Free;
  end;
}

    SendMessage(Self.Handle,WM_Close,0,0);


end;


procedure TPurgeOrderI.OkCP1BtnClick(Sender: TObject);
Var
  mbRet    :  Word;

begin

  mbRet:=MessageDlg('Please confirm you wish to Purge Orders',mtConfirmation, [mbYes, mbNo], 0);

  If (mbRet=mrYes) then
    ShowBar(BOff);


end;

procedure TPurgeOrderI.ClsCP1BtnClick(Sender: TObject);
begin
  inherited;
  SendMessage(Self.Handle,WM_Close,0,0);
end;

procedure TPurgeOrderI.IncACFExit(Sender: TObject);
Var
  FoundCode  :  Str20;
  KeyS       :  Str255;
  FoundOk,
  AltMod     :  Boolean;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    FoundCode:=Name;

    AltMod:=Modified;

    FoundCode:=Trim(Text);

    If (AltMod) and (ActiveControl<>ClsCP1Btn)  and (FoundCode<>'') then
    Begin

      FixFile[CustF].Rebuild:=BOn;

      Open_RepairFiles(CustF,CustF,BOn,BOff,ProgBar); {* Open all files and check for a Rebuild header *}

      StillEdit:=BOn;

      KeyS:=UpperCase(FullCustCode(FoundCode));

      Status:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,0,KeyS);

      FoundOk:=StatusOk;

      Close_Files(BOn);

      FixFile[CustF].Rebuild:=BOff;

      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=Cust.CustCode;

      end
      else
      Begin
        ShowMessage(FoundCode+' is not a valid account code. Please re-enter the complete code.');
        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;

end.

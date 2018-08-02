unit SetAcF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Genentu, StdCtrls, ANIMATE, ExtCtrls, SBSPanel, bkgroup, ComCtrls, UnTils,
  CheckLst, TEditVal, Mask;

type
  TSetAcFrm = class(TTestCust)
    Label2: TLabel;
    LastTriNom: Text8Pt;
    Label81: Label8;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure LastTriNomExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }


    Function Valid_Location(LocNo  :  String)  :  Boolean;

    Function Gen_Summary  :  String;

  public
    { Public declarations }
    LocCode   :  String;


  end;



Function Get_Account(Var  LocRef  :  String)  :  Boolean;


implementation

Uses
  GlobVar,
  VarConst,
  VarRec2U,
  VarFPosU,
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  ProgU,
  ReBuld2U,
  ReBuld1U;

{$R *.DFM}




procedure TSetAcFrm.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  inherited;
  ClientHeight:=209;
  ClientWidth:=412;

  LocCode:='';

end;

Function TSetAcFrm.Valid_Location(LocNo  :  String)  :  Boolean;

Var
  KeyS  :  String;
  Cleared,
  ThisPr,
  ThisYTD,
  LastYTD,
  Budget1,
  Budget2,
  Commit     :   Double;

  BV1,BV2,
  BV3        :   Real;

Begin
  Result:=Syss.AuditYr<>0;

  If (Result) then
  Begin

    Result:=(Trim(LocNo)<>'');

    If (Result) then
    Begin
      KeyS:=FullCustCode(LocNo);


      Result:=(CheckRecExsists(UpCaseStr(KeyS),CustF,CustCodeK));

      If (Result) then
      Begin
        ThisYTD:=Profit_to_Date(CustHistCde,KeyS,0,Syss.AuditYr,99,BV1,BV2,BV3,BOn);

        Result:=(Round_Up(ThisYTD,2)=0.0);

        If (Result) then
          LocCode:=FullCustCode(LocNo)
        else
          ShowMessage('The balance as at '+FullYear(Syss.AuditYr)+' for account '+Trim(LocNo)+' is '+Form_Real(ThisYTD,0,2)+'.'+#13+
                      'Only accounts with a zero balance at the time of the purged year may be reset.');

      end
      else
      Begin
        ShowMessage(Trim(LocNo)+' is not a valid account.');

        LocCode:='';
      end;
    end
    else
    Begin
      ShowMessage('You must specify a valid account.');

      LocCode:='';
    end;
  end
  else
  Begin
    ShowMessage('A purge has not been run against this data.');

    LocCode:='';
  end;
end;



procedure TSetAcFrm.LastTriNomExit(Sender: TObject);
begin
  inherited;

  If (ActiveControl<>ClsCP1Btn) then
  With LastTriNom do
  If (Trim(Text)<>'') then
  Begin
    If (Not Valid_Location(Text)) then
      SetFocus;

  end;
end;


procedure TSetAcFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {inherited;}

  {Override inheritance}

end;


procedure TSetAcFrm.ClsCP1BtnClick(Sender: TObject);
begin
  {Inherited;}
  ModalResult:=mrCancel;
end;


Function TSetAcFrm.Gen_Summary  :  String;

Begin
  Result:='You have chosen:-'+#13;

  Result:=Result+'To reset pre-purge year history records to zero for account '+LastTriNom.Text;

end;

procedure TSetAcFrm.OkCP1BtnClick(Sender: TObject);
begin
  If (Valid_Location(LastTriNom.Text)) then
  Begin
    ModalResult:=MessageDlg(Gen_Summary,mtConfirmation,[mbOk,mbCancel],0);
  end;
end;


Function Get_Account(Var  LocRef  :  String)  :  Boolean;

Var
  LocForm   :  TSetAcFrm;
  SLocked   :  Boolean;

Begin
  Result:=BOff;  SLocked:=BOff;

  LocForm:=TSetAcFrm.Create(Application.MainForm);

  Try
    LocForm.ShowModal;

    Result:=(LocForm.ModalResult=mrOK);

    If (Result) then
    With LocForm do
    Begin
      LocRef:=LocCode;
    end
    else
    Begin
      Write_FixMsgFmt('Special Function 90 has been aborted.',4);


    end;

  Finally
    LocForm.Free;

  end; {Try..}

end;



Initialization


Finalization


end.

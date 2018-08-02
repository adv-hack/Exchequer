unit JClsJIU;

interface

{$I DEFOVR.Inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, Animate, ExtCtrls, SBSPanel, StdCtrls, bkgroup, Mask, TEditVal,
  GlobVar;


type
  TJobClsInp = class(TRepInpMsg)
    Label81: Label8;
    Label82: Label8;
    ACFF: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    JCode  :  Str10;

  end;


procedure Close_Job(AOwner  :  TComponent;
                    TJCode  :  Str10);

                    
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  VarConst,
  SysU1,
  InvListU,

  {$IFDEF POST}
    JobPostU,
    JobSup1U,
  {$ENDIF}

  BTKeys1U,
  BTSupU2;

{$R *.DFM}





procedure TJobClsInp.FormCreate(Sender: TObject);
begin
  inherited;

  ClientHeight:=212;
  ClientWidth:=299;

  SetLastValues;

  Label81.Caption:='In order to transfer the remaining work in progress for this job, '+
                   'a work in progress analysis code must be provided so that the value of '+
                   'work in progress transferred can also be reversed out from the work in '+
                   'progress category totals.';


end;



procedure TJobClsInp.ACFFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  AMode      :  Byte;

begin
  {$IFDEF SOP}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AMode:=8;

      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) or (FoundCode=''))  and (ActiveControl<>ClsCP1Btn)  then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJobMisc(Self,FoundCode,FoundCode,2,AMode));

        If (FoundOk) then {* Credit Check *}
        Begin

          Text:=FoundCode;

          {FieldNextFix(Self.Handle,ActiveControl,Sender);}

        end
        else
        Begin
          {StopPageChange:=BOn;}

          SetFocus;
        end; {If not found..}
      end;

    end;
  {$ENDIF}

end;

procedure TJobClsInp.OkCP1BtnClick(Sender: TObject);

{$IFDEF POST}

Var
  JInvHed      :  JInvHedRec;
  FoundCode    :  Str20;

begin
  If (Sender=OkCP1Btn) then
  Begin


    FillChar(JInvHed,Sizeof(JInvHed),0);

    With JInvHed do
    Begin
      FinalInv:=BOn;
      WJACode:=FullJACode(ACFF.Text);
      UseWIP:=BOn;
    end;

    If GetJobMisc(Self,JInvHed.WJACode,FoundCode,2,-1) then
    Begin

      OKCP1Btn.Enabled:=BOff;

      {$IFDEF Post}
        AddJobPost2Thread(Self,21,JCode,@JInvHed,Self.Handle);
      {$ENDIF}
    end
    else
      ShowMessage('That analysis code is not valid');

  end;

{$ELSE}
begin

{$ENDIF}
  inherited;
end;


procedure Close_Job(AOwner  :  TComponent;
                    TJCode  :  Str10);



Var
  RepInpMsg1  :  TJobClsInp;

Begin
  RepInpMsg1:=TJobClsInp.Create(AOwner);

  RepInpMsg1.JCode:=FullJobCode(TJCode);


end;




end.

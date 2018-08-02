unit AllcWrnU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Genwarnu, StdCtrls, ExtCtrls, TEditVal, SBSPanel, BorBtns,
  GlobVar,
  VarConst;

type
  TGenWarnFrm1 = class(TGenWarnFrm)
    cbVar: TBorRadio;
    cbSetD: TBorRadio;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    TakeasSet  :  Boolean;
  end;

// CJS 2015-02-26 - ABSEXCH-15298 - T1-009 - Allocation Wizard - remove settlement discount option for transactions > 01/04/2015
// Added optional InvR parameter
Function AllocCustomDlg(Sender  :  TWinControl; const Cap,Sub,Msg: AnsiString; AType: TMsgDlgType;
                        Buttons :  TMsgDlgButtons;
                        IncVar  :  Boolean;
                    Var TakeSet :  Boolean;
                        SetBtn2Focus  :  Boolean = False;
                        CanTakeDiscount: Boolean = True)  :  TModalResult;

Function CustomDlgNew(Sender  :  TWinControl; const Cap,Sub,Msg: AnsiString; AType: TMsgDlgType;
                   Buttons: TMsgDlgButtons;
                   NewCapMode  :  Byte = 0)  :  TModalResult;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  BTSupU1,
  BTSupU2,
  ExThrd2U;


{$R *.dfm}


procedure TGenWarnFrm1.FormCreate(Sender: TObject);
begin
  inherited;

  {$IFNDEF MC_On}
    cbVar.Visible:=BOff; cbSetD.Visible:=BOff;

  {$ENDIF}

  ClientHeight:=286;
  ClientWidth:=275;


end;



{ ========== Return Modal Result =========== }

Function AllocCustomDlg(Sender  :  TWinControl; const Cap,Sub,Msg: AnsiString; AType: TMsgDlgType;
                        Buttons :  TMsgDlgButtons;
                        IncVar  :  Boolean;
                    Var TakeSet :  Boolean;
                        SetBtn2Focus  :  Boolean = False;
                        CanTakeDiscount: Boolean = True)  :  TModalResult;
Var
  GenFrm  :  TGenWarnFrm1;
  PrevHState
          :  Boolean;
Begin
  GenFrm:=TGenWarnFrm1.Create(Sender);

  try

   With GenFrm do
   Begin
     DisplayWarning(Cap,Sub,Msg,AType,Buttons);

     SetAllowHotKey(BOff,PrevHState);
     Set_BackThreadMVisible(BOn);

     If (SetBtn2Focus) and (CanCP1Btn.CanFocus) then
       ActiveControl:=CanCP1Btn;

     // CJS 2015-02-26 - ABSEXCH-15298 - T1-009 - Allocation Wizard - remove settlement discount option for transactions > 01/04/2015
     if not CanTakeDiscount then
     begin
       cbSetD.Checked := False;
       cbSetD.Visible := False;
       // If we can't take a discount, the only option is to take a variance,
       // so the Variance option is redundant, but should be checked.
       cbVar.Visible := False;
       cbVar.Checked := True;
     end
     else
     begin
       {$IFDEF MC_On}
         If (IncVar) then
           cbSetD.Checked := TakeSet
         else
         Begin
           cbVar.Visible := BOff;
           // If we can't take a variance, the only option is to take a
           // settlement discount, so the settlement discount option is
           // redundant, but should be checked.
           cbSetD.Visible := BOff;
           cbSetD.Checked := BOn;
         end;
       {$ELSE}
         cbSetD.Checked := BOn;
       {$ENDIF}
     end;

     Result:=ShowModal;

     if (cbSetD.Visible) then
       TakeSet := cbSetD.Checked
     else if CanTakeDiscount then
       TakeSet := (Result = mrOK)
     else
       TakeSet := False;

   end;

  finally

   GenFrm.Free;

   Set_BackThreadMVisible(BOff);

   SetAllowHotKey(BOn,PrevHState);
  end;
end;


{ ========== Return Modal Result =========== }

Function CustomDlgNew(Sender  :  TWinControl; const Cap,Sub,Msg: AnsiString; AType: TMsgDlgType;
                   Buttons: TMsgDlgButtons;
                   NewCapMode  :  Byte = 0)  :  TModalResult;

Var
  GenFrm  :  TGenWarnFrm;
  PrevHState
          :  Boolean;


Begin
  GenFrm:=TGenWarnFrm.Create(Sender);

  try

   With GenFrm do
   Begin
     DisplayWarning(Cap,Sub,Msg,AType,Buttons);

     SetAllowHotKey(BOff,PrevHState);
     Set_BackThreadMVisible(BOn);

     Case NewCapMode of
       1  :  OkCP1Btn.Caption:='&New';
       2  :  CanCP1Btn.Caption:='&New';
     end;  {case..}

     Result:=ShowModal;


   end;

  finally

   GenFrm.Free;

   Set_BackThreadMVisible(BOff);

   SetAllowHotKey(BOn,PrevHState);
  end;
end;



end.

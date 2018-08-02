unit CommonU;

{ markd6 17:09 06/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses
  GlobVar,
  VarConst;

Const
  // 1    v4.32
  // 2    v4.40
  // 3    v5.50
  // 4    v5.52
  // 5    v5.60
  // 6    v5.70
  // 7    IAO
  // 8    v6.4 (seems to include v6.01 as well)
  // 9    v6.7
  // 10   v6.9
  // 11   v7.0.2
  // 12   v7.0.5
  // 13   v7.0.8
  //
  // New items should be added into NeedToUpgradePermissions in PwUpgrade.Pas
  //
  // PKR. 07/01/2016. ABSEXCH-17082. v2016.R1. Intrastat
  // CJS. 05/02/2016. ABSEXCH-17262. v2016.R1. Amendments to Intrastat field defaults
  //PR: 02/05/2017 v2017R1 ABSEXCH-18635 Changes to report tree require new permissions
  //RB 06/12/2017 2018-R1 ABSEXCH-19478: 5.2.2 User Permissions - Insert into DB in GEUpgrde + Update User Profile Tree
  NoUpgrades  = 18;


Type
  rUpgrade  =  Record
                 RunIt  :  Boolean;
                 ErrStr :  String;
               end;

  rCtrlUpgrade = Record
                   VerNo  :  String;
                 end;

Var
  TotalProgress,
  TotalCount     :  LongInt;

  UpgradeList    :  Array[1..NoUpgrades] of rUpgrade;

  CtrlUpgrade    :  rCtrlUpgrade;


Procedure Report_BError(Fnum,
                        ErrNo  :  Integer);

Procedure SetCompanyDir(SD  :  String); STDCall;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  BtrvU2,
  Dialogs,
  ETStrU;


{ == Override set drive for multi company compatibility == }

Procedure SetCompanyDir(SD  :  String);

Begin
  If (SetDrive<>SD) then
    SetDrive:=SD;

  If (SetDrive<>'') and (SetDrive[Length(SetDrive)]<>'\') then
    SetDrive:=SetDrive+'\';

end;


{ ============= Function to Report Btrieve Error ============= }

Procedure Report_MTBError(Fnum,
                          ErrNo    :  Integer;
                          ClientId :  Pointer);
Var
  ErrStr    :  AnsiString;
  mbRet     :  Word;
  ThStr     :  AnsiString;
  ClientIdR :  ClientIdType;

Begin
  ThStr:='';

  If (ErrNo<>0) then
  Begin
    ErrStr:=Set_StatMes(ErrNo);

    If (Assigned(ClientId)) then
      ThStr:=#13+#13+'In thread '+Form_Int(ClientIdType(ClientId^).TaskId,0);

    mbRet:=MessageDlg('Error in file : '+FileNAmes[Fnum]+#13+'Error '+Form_Int(ErrNo,0)+', '+#13+ErrStr+ThStr,
           mtError,[mbOk],0);


  end;
end; {Proc..}

Procedure Report_BError(Fnum,
                        ErrNo  :  Integer);

Begin


  Report_MTBError(Fnum,ErrNo,nil);

end; {Proc..}


Begin
  TotalProgress:=0;  TotalCount:=0;
  
  FillChar(UpgradeList,Sizeof(UpgradeList),#0);

  FillChar(CtrlUpgrade,Sizeof(CtrlUpgrade),#0);

end.

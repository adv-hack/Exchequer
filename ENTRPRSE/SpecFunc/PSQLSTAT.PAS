unit PSQLStat;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Genentu, StdCtrls, ANIMATE, ExtCtrls, SBSPanel, bkgroup, ComCtrls, UnTils,
  CheckLst;

Procedure Calc_FileStats;

implementation

Uses
  GlobVar,
  VarConst,
  BtrvU2,
  ProgU,
  ReBuld1U;


Procedure Calc_FileStats;

Var
  n,fv       :  SmallInt;
  ThisVer    :  Integer;

Function Txlate_FVer  :  Byte;

Begin
  Case ThisVer of
    $50..$59  :  Result:=5;
    $60..$69  :  Result:=6;
    $70..$79  :  Result:=7;
    $80..$89  :  Result:=8;
    $90..$99  :  Result:=9;
    else         Result:=0;
  end; {Case..}
end;

Begin
  Open_RepairFiles(1,TotFiles,BOff,BOn,Nil);

  Try
    For n:=1 to TotFiles do
    Begin
      ThisVer:=File_VerCId(F[n],n,Nil);

      fv:=TxlateFVer;
      If (fv>0) then
        Write_FixMsgFmt(Filenames[n]+' v'+IntToStr(fv),4)
      else
        Write_FixMsgFmt(Filenames[n]+' Unkown version',5);


    end;
  finally;

   Close_Files(BOn);

  end; {Try..Fin}
  
end;




end.

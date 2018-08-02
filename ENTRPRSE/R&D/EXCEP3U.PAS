unit Excep3U;

//PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Turn off platform warnings
{$WARN UNIT_PLATFORM OFF}

interface

uses
   SysUtils, GlobVar;


Const
  SwapDirN :  String =  'SWAP\';


Function CheckIOError(ChkIO  :  Integer;
                      Msg1   :  String)  :  Boolean;

Function GetSwapDir :  Str255;




{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  FileCtrl;

Function CheckIOError(ChkIO  :  Integer;
                      Msg1   :  String)  :  Boolean;
Var
  E  :  EInOutError;

Begin
  If (ChkIO<>0) then
  Begin
    Result:=BOff;

    E:=EInOutError.Create('Error '+IntToStr(ChkIO)+' '+Msg1);

    E.ErrorCode:=ChkIO;

    Raise E;
  end
  else
    Result:=BOn;
end;



{ ============= Function to Return Next Available Swap File Name, For MultiUser reasons =============== }

Function GetSwapDir :  Str255;


Var
  Ok2Cont     :  Boolean;

  IOChk       :  Integer;

  TDirN       :  Str255;

Begin
  {$I-}

  Ok2Cont:=BOn;

  TDirN:=SwapDirN;

  If (SwapDirN<>'') then
  Begin
    TDirN:=Copy(SwapDirN,1,Pred(Length(SwapDirN)));

    If (Not DirectoryExists(SetDrive+TDirN)) then
    Begin
      MkDir(SetDrive+TDirN);

      IOChk:=IOResult;

      Ok2Cont:=CheckIOError(IOChk,'Unable to create directory '+SetDrive+SwapDirN+'. When attempting to generate a swap file.');

      If (Ok2Cont) then
        TDirN:=SwapDirN
      else
      Begin
        TDirN:='';

      end;
      {SetFAttr(TDirN,Hidden); *Do not attempt to hide these logs }

    end
    else
      TDirN:=SwapDirN;
  end;


  {$I+}

  Result:=TDirN;
end; {Func..}



end.

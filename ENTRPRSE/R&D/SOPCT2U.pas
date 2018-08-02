Unit SOPCT2U;


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 09/09/96                      }
{                 SOP Process Control Unit II                  }
{                                                              }
{                                                              }
{               Copyright (C) 1996 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses
  Forms,
  GlobVar,
  VarConst;

Function FullSOPFile(R,C      :  Char;
                     EMode    :  LongInt)  :  Str20;

Function Get_LastSOPVal(FileKey  :  Str255;
                    Var SOPRec   :  SOPInpRec)  :  Boolean;

Procedure Put_LastSOPVal(ASubCode :  Char;
                         SOPRec   :  SOPInpRec;
                         EMode    :  LongInt);

Procedure Init_SOPInp(Var SOPInp  :  SOPInpRec);

Function FullAllocFile(R,C      :  Char;
                       EMode    :  LongInt)  :  Str20;

Function Get_LastAlloc(FileKey  :  Str255;
                   Var FoundOk  :  Boolean;
                       Presv    :  Boolean)  :  Real;

Procedure Put_LastAlloc(FoundOk  :  Boolean;
                        AllocVal :  Real;
                        ASubCode :  Char;
                        EMode    :  LongInt);

Procedure Reset_Alloc(ASubCode  :  Char;
                      Disp      :  Boolean);

Procedure Abort_AutoPick(Const PickRNo  :  LongInt;
                         Const Fnum,
                               Keypath  :  Integer;
                         Const KeyChk   :  Str255);



 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Printers,
   Dialogs,
   ETMiscU,
   ETDateU,
   BtrvU2,
   ComnUnit,
   ComnU2,
   ETStrU,
   InvListU,
   {InvLst2U,}
   MiscU,
   InvCTSUU,
   SCRTCH1U,
   InvFSu2U,
   SysU1,
   SysU2,
   BTSupU1,
   BTKeys1U,
   Warn1U,
   SOPCT3U,

   StkBinU,

   Exthrd2U;


   {RepSupCU;} {* Needs linking back in EX32 for put/get alloc *}








{ ======== Routines to manage the storage of default variables ======= }



Function FullSOPFile(R,C      :  Char;
                     EMode    :  LongInt)  :  Str20;




Begin

  FullSOPfile:=R+C+FullNomKey(Emode)+HelpKStop;

end; {Func..}



Function Get_LastSOPVal(FileKey  :  Str255;
                    Var SOPRec   :  SOPInpRec)  :  Boolean;



Const
  Fnum     =  MiscF;

  KeyPAth  =  MIK;


Var
  FoundOk  :  Boolean;


Begin

  FoundOk:=BOff;

  Blank(SOPRec,Sizeof(SOPRec));

  Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,FileKey);


  FoundOk:=StatusOk;

  If (FoundOk) then
    SOPRec:=MiscRecs^.SOPInpDefRec.SOPInpVal;

  Get_LastSOPVal:=FoundOk;

end; {Func..}




Procedure Put_LastSOPVal(ASubCode :  Char;
                         SOPRec   :  SOPInpRec;
                         EMode    :  LongInt);



Const
  Fnum     =  MiscF;

  KeyPAth  =  MIK;


Var
  FOk        :  Boolean;

  GAlloc     :  Real;

  TmpSOPRec  :  SOPInpRec;


Begin

  With MiscRecs^ do
  With SOPInpDefRec do
  Begin

    FOK:=Get_LastSOPVal(FullSOPFile(AllocTCode,ASubCode,EMode),TmpSOPRec);


    If (Not FOk) then
    Begin

      ResetRec(Fnum);

      RecMFix:=AllocTCode;

      SubType:=ASubCode;

      SOPInpCode:=FullNomKey(Emode)+HelpKStop;

      SOPInpVal:=SOPRec;

      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    end
    else
    Begin

      SOPInpVal:=SOPRec;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    end;


    Report_BError(Fnum,Status);

  end; {With..}

end; {Proc..}



{ ======== Proc to initialise SOPInp Defaults ======== }

Procedure Init_SOPInp(Var SOPInp  :  SOPInpRec);

Var
  n  :  Byte;

Begin

  With SOPInp do
  Begin

    FillChar(SOPInp,Sizeof(SOPInp),0);

    DelTag:=0;

    DelCons:=BOff;

    FillChar(DelPrn,Sizeof(DelPrn),1);

    FillChar(DocPrn,Sizeof(DocPrn),1);

    If (Printer.PrinterIndex>=0) then
    With Printer do
    Begin
      For n:=1 to 4 do
        WPrnName[n]:=Copy(Printers[PrinterIndex],1,20);
    end;

    InvTag:=0;

    InvCons:=BOff;

    PickAuto:=BOn;
    PickTag:=0;
    PickCon:=BOff;
    PickSing:=BOn;
    PickEBOM:=BOff;
    PickUDate:=Today;
    PapChange:=BOn;
    
  end; {with..}

end; {Proc..}



{ ======== Temp Allocation Storage manipulation ========= }



Function FullAllocFile(R,C      :  Char;
                       EMode    :  LongInt)  :  Str20;




Begin

  FullAllocfile:=R+C+FullNomKey(Emode)+HelpKStop;

end; {Func..}


{Replicated in StkWarnU}

Function Get_LastAlloc(FileKey  :  Str255;
                   Var FoundOk  :  Boolean;
                       Presv    :  Boolean)  :  Real;



Const
  Fnum     =  PWrdF;

  KeyPAth  =  PWK;

Var
  TmpKPath,
  TmpStat  :  Integer;

  TmpRecAddr
           :  LongInt;

  TmpPWrd  :  PassWordRec;



Begin


  TmpKPath:=GetPosKey;

  TmpPWrd:=PassWord;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);


  Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,FileKey);


  FoundOk:=StatusOk;

  If (FoundOk) then
    Get_LastAlloc:=Password.AllocFileRec.AllocSF
  else
    Get_LastAlloc:=0;


  If (Presv) then
  Begin
    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);
    PassWord:=TmpPWrd;
  end;

end; {Func..}



Procedure Put_LastAlloc(FoundOk  :  Boolean;
                        AllocVal :  Real;
                        ASubCode :  Char;
                        EMode    :  LongInt);



Const
  Fnum     =  PWrdF;

  KeyPAth  =  PWK;


Var
  FOk      :  Boolean;

  GAlloc   :  Real;

  TmpKPath,
  TmpStat  :  Integer;

  TmpRecAddr
           :  LongInt;

  TmpPWrd  :  PassWordRec;


Begin

  TmpPWrd:=PassWord;

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

  With Password do
  With AllocFileRec do
  Begin

    GAlloc:=Get_LastAlloc(FullAllocFile(AllocTCode,ASubCode,EMode),FOk,BOff);


    If (Not FOk) then
    Begin

      ResetRec(Fnum);

      RecPFix:=AllocTCode;

      SubType:=ASubCode;

      AllocCode:=FullNomKey(Emode)+HelpKStop;

      AllocSF:=AllocVal;

      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    end
    else
    Begin

      AllocSF:=AllocSF+AllocVal;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    end;


    Report_BError(Fnum,Status);

  end; {With..}

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

  PassWord:=TmpPwrd;

end; {Proc..}



{ ============= Procedure to Clear Allocation =========== }


Procedure Reset_Alloc(ASubCode  :  Char;
                      Disp      :  Boolean);


Const
  Fnum     =  PwrdF;

  Keypath  =  PWK;



Var
  KeyChk,
  KeyS     :  Str255;
  MsgForm  :  TForm;




Begin
  MsgForm := nil;
  KeyCHk:=AllocTCode+ASubCode;

  KeyS:=KeyChk;

  If (Disp) then
  Begin
    Set_BackThreadMVisible(BOn);

    MsgForm:=CreateMessageDialog('Please Wait... Re-setting Allocation values...',mtInformation,[]);
    MsgForm.Show;
    MsgForm.Update;

  end;


  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
  Begin

    Application.ProcessMessages;

    Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

    Report_Berror(Fnum,Status);

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {Loop..}

  If (Disp) then
  Begin
    MsgForm.Free;

    Set_BackThreadMVisible(BOff);
  end;

end; {Proc..}








   { == Procedure to reverse semi completed pick, when Hold all stock active == }

Procedure Abort_AutoPick(Const PickRNo  :  LongInt;
                         Const Fnum,
                               Keypath  :  Integer;
                         Const KeyChk   :  Str255);


Var
  KeyS       :  Str255;
  LStatus    :  Integer;


Begin

  KeyS:=KeyChk;

  LStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  While (LStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With Id do
  Begin
    If (SOPLineNo=PickRNo) and (QtyPick<>0) then
    Begin
      If (Is_FullStkCode(StockCode)) then {* Update Picked Qty Status *}
      Begin
        Stock_Deduct(Id,Inv,BOff,BOn,3);

        {Bring any bins in line}
        Auto_PickBin(Id,Inv,Id.QtyPick,Id.BinQty,1);

        {If (Stock.StockCode=StockCode) and (Stock.StockType In StkProdSet) then
        Begin
          Put_LastAlloc(BOff,QtyPick*DocNotCnst,AllocPCode,Stock.StockFolio);
        end;}
      end;

      QtyPick:=0;
      SOPLineNo:=0;

      LStatus:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      Report_BError(Fnum,LStatus);
    end; {If Match..}

    LStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {while..}

end;





end.
unit StkChkU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, Gauges,  BTSupU1,
  BTSupU3,SBSComp2,GlobVar;

type

  TStkChkFrm = class(TForm)
    SBSPanel3: TSBSPanel;
    Label1: Label8;
    CanCP1Btn: TButton;
    Label2: TLabel;
    procedure CanCP1BtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);

    private

      Running,
      KeepRun    :  Boolean;
      fSFnum,
      fSKeypath  :  SmallInt;

      KeyV       :  TModalResult;

      Procedure Send_UpdateList(Mode   :  Integer);

      Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

      procedure ShutDown;

      {$IFDEF SOP}
        Procedure Stk_CheckLocHist(StkCode        :  Str20;
                                   StkType        :  Char;
                                   StkFolio       :  LongInt;
                               Var SetOBal        :  Boolean);

        Procedure Loc_FIFOTidy(StkCode        :  Str20);



      {$ENDIF}

      Procedure Re_CalcStockLevels(SFnum,
                                   SKeypath   :  SmallInt);

      Procedure Check_AllStock;
      Procedure ShowStockCodeOnForm;
    public
      { Public declarations }
      SingleMode  :  Boolean;

      procedure AdjustWidth(LabNo       :  Integer;
                            AbortMode   :  Byte;
                            Fnum,
                            Keypath     :  SmallInt);


  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  VarConst,
  BtrvU2,
  BTKeys1U,
  VARRec2U,
  ComnUnit,
  SysU2,
  BTSupU2,
  InvCTSuU,
  {$IFNDEF SOPDLL}
  FIFOL2U,
  {$ELSE}
  FIFOLU,
  {$ENDIF}

  {$IFDEF NP}
    NoteSupU,
  {$ENDIF}

  {$IFDEF EXSQL}
  SQLUtils,
  SQLFuncs,
  // CJS: 27/06/2011 - ABSEXCH-11541
  PSAPI,
  {$ENDIF}
  PostingU,
  Warn1U;

{$R *.DFM}

procedure TStkChkFrm.CanCP1BtnClick(Sender: TObject);
begin
  KeyV:=mrAbort;

  Loop_CheckKey(KeepRun,KeyV);

  If (Not KeepRun) then
    CanCp1Btn.Enabled:=BOff;
end;


Procedure TStkChkFrm.WMCustGetRec(Var Message  :  TMessage);

Begin
  With Message do
  Begin


    Case WParam of

      8
         :  Begin

            end;


    end; {Case..}

  end; {With..}

  Inherited;

end;



Procedure TStkChkFrm.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_CustGetRec;
    WParam:=Mode;
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}

procedure TStkChkFrm.ShutDown;

Begin
  PostMessage(Self.Handle,WM_Close,0,0);
end;


procedure TStkChkFrm.AdjustWidth(LabNo       :  Integer;
                                 AbortMode   :  Byte;
                                 Fnum,
                                 Keypath     :  SmallInt);


Begin

  fSFnum:=Fnum;
  fSKeypath:=KeyPath;

  SingleMode:=(AbortMode=0);

  If (Not SingleMode) then
  With CanCP1Btn do
  Begin
    Visible:=BOn;
    Enabled:=BOn;
    Left:=((Self.Width div 2) - (Width div 2));
  end;


  Left := (Screen.Width div 2) - (Width div 2);
  Top := (Screen.Height div 2) - (Height div 2);

end;


{$IFDEF SOP}
  Procedure TStkChkFrm.Stk_CheckLocHist(StkCode        :  Str20;
                                        StkType        :  Char;
                                        StkFolio       :  LongInt;
                                    Var SetOBal        :  Boolean);


  Const
    Fnum2     =  MLocF;
    Keypath2  =  MLK;

  Var
    KeyChk,KeyS,
    KeyS2,KeyChk2  :  Str255;

    Purch,Rnum,
    Sales,Cleared  :  Double;

    LOk,Locked     :  Boolean;

    IdR            :  IDetail;


    LAddr, Res     :  LongInt;

  Begin
    {$IFDEF EXSQL}
      // Can't use SP if purge has been performed - NOTE: Due to AuditYr being set to 6 in the demo
      // data I have had to bodge the check
//      If SQLUtils.UsingSQLAlternateFuncs And (Not BeenPurge(0)) Then
      If SQLUtils.UsingSQLAlternateFuncs And (Syss.AuditYr < 20) Then
      Begin
        Res := CheckAllStock(SetDrive, StkCode, StkType, StkFolio);
        If (Res < 0) Then
          MessageDlg ('TStkChkFrm.Stk_CheckLocHist: CheckAllStock failed for ' + Trim(StkCode) + ' with an error ' + SQLUtils.LastSQLError,
                      mtError, [mbOK], 0);
      End // If SQLUtils.UsingSQLAlternateFuncs
      Else
    {$ENDIF}
      Begin
        SetOBal:=BOff; Rnum:=0;

        KeyChk2:=PartCCKey(CostCCode,CSubCode[BOff])+StkCode;

        KeyS2:=KeyChk2;

        Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyS2);

        While (StatusOk) and (CheckKey(KeyChk2,KeyS2,Length(KeyChk2),BOff)) do
        With MLocCtrl^,MStkLoc do
        Begin
          KeyChk:=Calc_AltStkHCode(StkType)+CalcKeyHist(StkFolio,lsLocCode);

          {* Remove posted history *}

          {*EN420}

          DeleteAuditHist(KeyChk,Length(KeyChk),BOff);

          {DeleteLinks(KeyChk,NHistF,Length(KeyChk),NHK,BOff);}

          LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS2,KeyPath2,Fnum2,BOn,Locked,LAddr);

          {* Reset Location values *}

          If (LOk) and (Locked) then
          Begin
            If (BeenPurge(0)) then {*EN420} {Set o/bal}
            Begin
              Rnum:=Profit_To_Date(Calc_AltStkHCode(StkType),
                                   CalcKeyHist(StkFolio,lsLocCode),
                                   0,Syss.AuditYr,Pred(YTDNCF),
                                   Purch,Sales,Cleared,BOn);
              lsQtyInStock:=Cleared;
            end
            else
              lsQtyInStock:=0;


            lsQtyAlloc:=0;

            lsQtyOnOrder:=0;

            lsQtyPicked:=0;

            lsQtyAllocWOR:=0.0;
            lsQtyIssueWOR:=0.0;
            lsQtyPickWOR:=0.0;

            lsQtyReturn:=0.0;
            lsQtyPReturn:=0.0;

            Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2);

            Report_BError(Fnum2,Status);

            Status:=UnLockMultiSing(F[Fnum2],Fnum2,LAddr);

            If (BeenPurge(0)) and (lsQtyInStock<>0) and (FIFO_Mode(Stock.StkValType) In [2,3]) then
            With Stock do
            Begin
              SetOBal:=BOn;
              MakeObFIFOId(IdR,lsCostPrice,lsPCurrency,lsLocCode);

              FIFO_Add(IdR,lsQtyInStock,lsCostPrice,StkFolio,'O/Bal',BOn,BOff,MiscF,MIK,0);
            end;

          end;

          Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyS2);
        end;
      End;
  end;

  { == Tidy all location FIFO's == }

  Procedure TStkChkFrm.Loc_FIFOTidy(StkCode        :  Str20);


  Const
    Fnum2     =  MLocF;
    Keypath2  =  MLK;

  Var
    KeyChk2,KeyS2    :  Str255;


  Begin

    If (Syss.UseMLoc) then
    Begin
      KeyChk2:=PartCCKey(CostCCode,CSubCode[BOn]);

      KeyS2:=KeyChk2;

      Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyS2);

      While (StatusOk) and (CheckKey(KeyChk2,KeyS2,Length(KeyChk2),BOff)) do
      With MLocCtrl^,MLocLoc do
      Begin
        FIFO_Tidy(StkCode,loCode);

        Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyS2);
      end;
    end
    else
      FIFO_Tidy(StkCode,'');
  end;



{$ENDIF}

 Procedure TStkChkFrm.Re_CalcStockLevels(SFnum,
                                         SKeypath   :  SmallInt);


Const
  Fnum      =  IDetailF;
  Keypath   =  IDStkK;
  Fnum2     =  InvF;
  Keypath2  =  InvFolioK;
  MinFormWidth = 250;


Var
  KeyS,
  KeyChk,
  KeyI      :  Str255;

  SetLocOb,
  Locked    :  Boolean;

  Rnum,
  Purch,
  Sales,
  Cleared   :  Double;

  IdR       :  IDetail;

  LAddr     :  LongInt;

  LCheck_Stk
            :  ^TCheckStk;

  TmpStock  :  StockRec;

  StartMemSize: Cardinal;

  {$IFDEF EXSQL}
  // CJS: 27/06/2011 - ABSEXCH-11541 - periodically release memory as the stock
  // items are checked, to prevent memory being continuously allocated.

  // Current memory size of the current process in bytes
  function CurrentMemoryUsage: Cardinal;
  var
   pmc: TProcessMemoryCounters;
  begin
   Result := 0;
   pmc.cb := SizeOf(pmc) ;
   if GetProcessMemoryInfo(GetCurrentProcess, @pmc, SizeOf(pmc)) then
     Result := pmc.WorkingSetSize
   else
     RaiseLastOSError;
  end;

  // Release the memory by discarding the SQL Emulator cache
  procedure TrimAppMemorySize;
  const
    MemLimit = 5000000; // 5 MB
  var
    MemSize: Cardinal;
  begin
    try
      MemSize := CurrentMemoryUsage;
      if (MemSize > StartMemSize + MemLimit) then
      begin
        // The DOCUMENT table appears to be the culprit
        DiscardCachedData('TRANS\DOCUMENT.DAT');
        StartMemSize := CurrentMemoryUsage;
      end;
    except

    end;
    Application.ProcessMessages;
  end;
  {$ENDIF}

  {$IFDEF EXSQL}
  // KeyChk:=FullQDKey(MFIFOCode,MFIFOSub,FullNomKey(StockFolio));
  // DeleteLinks(KeyChk,MiscF,Length(KeyChk),MIK,BOff);
  Procedure SQLDeleteLinks (Const RecMFix, SubType : Char; Const StockFolio : Integer);
  Var
    sCompany : ShortString;
    sWhere : ANSIString;
  Begin // SQLDeleteLinks
    sCompany := GetCompanyCode(SetDrive);
    sWhere := '(FIFOStkFolio = ' + IntToStr(StockFolio) + ')';
    DeleteRows(sCompany, 'FIFO.Dat', sWhere);
  End; // SQLDeleteLinks
  {$ENDIF}


Begin

  KeyS:=Stock.StockCode;  LCheck_Stk:=Nil;

  Locked:=BOff; SetLocOb:=BOff;

  Rnum:=0;

  // MH 19/08/2008: Modified to force refresh of controls as on a new dataset under SQL the form wasn't painting
  Label1.Caption:='Recalculate Stock Levels.'+#13+#13+'Processing : '+dbFormatName(Stock.StockCode,Stock.Desc[1]);

  //GS 31/05/2011 ABSEXCH-11363: added code so that the form resizes itself to accomodate labels regaurdless
  //of their size; corrects the problem of large stock code + description combos producing
  //label captions so large they run off the sides of the form

  //remove any trailing or leading spaces from the label caption
  Label1.Caption := Trim(Label1.Caption);
  //if the labels width is more than the width of the form that is displaying it, then expand the
  //form to accomodate the labels size
  if (Label1.Width >= (self.Width - 30)) then
  begin;
    self.Width := (Label1.Width + 30);
    //adjust the position of the 'Abort' button so its in the center of the newly sized form
    self.CanCP1Btn.Left := (Round(self.Width / 2)) - (Round(self.CanCP1Btn.Width / 2));
  end;
  //stretch the label to the boundry of the form (minus offset); causing the 'center'
  //text allignment to have the desired visual effect
  Label1.Width := self.Width - 30;

  Label1.Refresh;
  CanCP1Btn.Refresh;
  Application.ProcessMessages;

  CanCP1Btn.Enabled := false;
  Ok := GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,SKeyPath,SFnum,BOff,Locked,LAddr);
  CanCP1Btn.Enabled := true;


  If (Ok) and (Locked) then
  With Stock do
  Begin
    TmpStock:=Stock;

    {*En420}

    If (BeenPurge(0)) then
    Begin
      Rnum:=Profit_To_Date(Calc_AltStkHCode(StockType),
                           CalcKeyHist(StockFolio,''),
                           0,Syss.AuditYr,Pred(YTDNCF),
                           Purch,Sales,Cleared,BOn);
      QtyInStock:=Cleared;
    end
    else
      QtyInStock:=0;

    QtyAllocated:=0;

    QtyOnOrder:=0;

    QtyPicked:=0;
    QtyAllocWOR:=0.0;
    QtyPickWOR:=0.0;
    QtyIssueWOR:=0.0;

    QtyReturn:=0.0;
    QtyPReturn:=0.0;

    {$IFDEF PF_On}


      {* Delete FIFO Records *}

      KeyChk:=FullQDKey(MFIFOCode,MFIFOSub,FullNomKey(StockFolio));

      {$IFDEF EXSQL}
      // MH 04/06/08: Added direct DELETE call to DB Engine to improve performance
      If SQLUtils.UsingSQLAlternateFuncs Then
        SQLDeleteLinks(MFIFOCode,MFIFOSub,StockFolio)
      Else
      {$ENDIF}
        DeleteLinks(KeyChk,MiscF,Length(KeyChk),MIK,BOff);


    {$ENDIF}

    {* Delete posted stock levels *}

    KeyChk:=Calc_AltStkHCode(StockType)+FullNomKey(StockFolio);

    {*EN420} {Only reset so far back }

    DeleteAuditHist(KeyChk,Length(KeyChk),BOff);

    {DeleteLinks(KeyChk,NHistF,Length(KeyChk),NHK,BOff);}

    {* Delete location History and current Levels *}
    {$IFDEF SOP}
      Stk_CheckLocHist(StockCode,StockType,StockFolio,SetLocOb);
    {$ENDIF}


    {*EN420}

    {$IFDEF PF_On}
      If (Not SetLocOB and BeenPurge(0) and (QtyInStock<>0)) and (FIFO_Mode(StkValType) In [2,3]) then
      Begin
        MakeObFIFOId(IdR,CostPrice,PCurrency,'');

        FIFO_Add(IdR,QtyInStock,CostPrice,StockFolio,'O/Bal',BOn,BOff,MiscF,MIK,0);
      end;
    {$ENDIF}

    KeyChk:=FullStockCode(StockCode);

    KeyS:=KeyChk;


    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


    // CJS: 27/06/2011 - ABSEXCH-11541
    {$IFDEF EXSQL}
    if SQLUtils.UsingSQL then
      StartMemSize := CurrentMemoryUsage;
    {$ENDIF}
    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
    Begin

      // CJS: 27/06/2011 - ABSEXCH-11541
      {$IFDEF EXSQL}
      if SQLUtils.UsingSQL then
        TrimAppMemorySize
      else
      {$ENDIF}
      Application.ProcessMessages;

      If ((Not KeepRun) and (Not SingleMode)) then
        Label2.Caption:='Please Wait, finishing current record.';

      If (Inv.FolioNum<>Id.FolioRef) then
      Begin
        KeyI:=FullNomKey(Id.FolioRef);
        Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyI);
      end;

      Stock_Deduct(Id,Inv,BOn,BOff,2);

      If (Id.DeductQty<>0) then
      Begin
        If (Inv.FolioNum<>Id.FolioRef) then
        Begin
          KeyI:=FullNomKey(Id.FolioRef);
          Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyI);
        end
        else
          Status:=0;


        {* Ex32 link to thread *}
        //If (StatusOk) and ((Inv.RunNo>0) or (Inv.RunNo=StkAdjRunNo)) and (AfterPurge(Id.PYr,0)) then
          //AddCheckStk2Thread(Application.MainForm,Inv,Stock,Id);

        {* Use of thread repelaced with direct call in v4.31 in an attempt to speed the process up *}
        If (StatusOk) and ((Inv.RunNo>0) or (Inv.RunNo=StkAdjRunNo) or (Inv.RunNo=PRNPRunNo)) and (AfterPurge(Id.PYr,0)) then
        Begin
          If (Not Assigned(LCheck_Stk)) then
          Begin
            New(LCheck_Stk,Create(Application.MainForm));

            Try
              If (Not LCheck_Stk^.Start(Stock,Id,Inv)) then
              Begin
                Dispose(LCheck_Stk,Destroy);
                LCheck_Stk:=nil;
              end;

            except
              Dispose(LCheck_Stk,Destroy);
              LCheck_Stk:=nil;
            end; {Try..}

          end;

          If (Assigned(LCheck_Stk)) then
          Begin
            Try
              LCheck_Stk^.ProcessFromCheck(Stock,Id,Inv);
            except
              Dispose(LCheck_Stk,Destroy);
              LCheck_Stk:=nil;
            end; {Try..}
          end;
        end;
      end;

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

    {$IFDEF NP}   {* v5.52 Re-calculate next Note No. in case of corruption *}
      // MH 22/07/08: Moved before the Put-Rec so the Next Note Line No actually gets updated
      Stock.NLineCount:=Check_NoteNo(NoteSCode,FullNCode(FullNomKey(Stock.StockFolio)));
    {$ENDIF}

    Status:=Put_Rec(F[SFnum],SFnum,RecPtr[SFnum]^,SKeyPath);

    Report_BError(SFnum,Status);

    If (StatusOk) and (Round_Up(QtyInStock,Syss.NoQtyDec)=0.0) then {* Delete any stray FIFO Records, as If 0 then there should be none in theory *}
    Begin
      KeyChk:=FullQDKey(MFIFOCode,MFIFOSub,FullNomKey(StockFolio));

      DeleteLinks(KeyChk,MiscF,Length(KeyChk),MIK,BOff);
    end
    else
      If (Round_Up(QtyInStock,Syss.NoQtyDec)>0.0) then
      Begin
        {Attempt to move any negative entries to the top of the fifo tree so Tidy can deal}
          FIFO_MoveNegs(TmpStock,MiscF,MIK);

      {$IFDEF SOP}
        Loc_FIFOTidy(TmpStock.StockCode);
      {$ELSE}
        FIFO_TIdy(TmpStock.StockCode,'');
      {$ENDIF}
      end;

    Status:=UnLockMultiSing(F[SFnum],SFnum,LAddr);

    If (Assigned(LCheck_Stk)) then
    Begin
      Dispose(LCheck_Stk,Destroy);
      LCheck_Stk:=nil;
    end;

    {*Ex32 update line values *}

  end; {With.}

  // CJS: 27/06/2011 - ABSEXCH-11541
  {$IFDEF EXSQL}
  if SQLUtils.UsingSQL then
    DiscardCachedData('TRANS\DOCUMENT.DAT');
  {$ENDIF}

end; {Proc..}



{ ================ Procedure to Scan all Stock and Re-Calc/check Levels ============== }

Procedure TStkChkFrm.Check_AllStock;
Const
  Fnum    =  StockF;
  KeyPAth =  StkCodeK;
Var
  KeyS     :  Str255;
  Ok2Cont  :  Boolean;
Begin
  KeyS:='';

  KeepRun:=BOn;

  Status:=Find_Rec(B_GetFirst,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  While (StatusOk) and (KeepRun) do
  Begin
    Re_CalcStockLevels(Fnum,KeyPath);
    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
  end;
end; {Proc..}


procedure TStkChkFrm.FormCreate(Sender: TObject);
begin
  ClientHeight:=129;
  ClientWidth:=299;

  SingleMode:=BOn;

  KeepRun:=Boff;

  Running:=BOff;
end;

procedure TStkChkFrm.FormActivate(Sender: TObject);
begin
  If (Not Running) then
  Begin
    Running:=BOn;

    If (SingleMode) then
      Re_CalcStockLevels(fSFnum,fSKeypath)
    else
      Check_AllStock;

    ShutDown;
  end;
end;

Procedure TStkChkFrm.ShowStockCodeOnForm ;
begin
  Label1.Caption:='Recalculate Stock Levels.'+#13+#13+'Processing : '+dbFormatName(Stock.StockCode,Stock.Desc[1]);

  //remove any trailing or leading spaces from the label caption
  Label1.Caption := Trim(Label1.Caption);
  //if the labels width is more than the width of the form that is displaying it, then expand the
  //form to accomodate the labels size
  if (Label1.Width >= (self.Width - 30)) then
  begin;
    self.Width := (Label1.Width + 30);
    //adjust the position of the 'Abort' button so its in the center of the newly sized form
    self.CanCP1Btn.Left := (Round(self.Width / 2)) - (Round(self.CanCP1Btn.Width / 2));
  end;
  //stretch the label to the boundry of the form (minus offset); causing the 'center'
  //text allignment to have the desired visual effect
  Label1.Width := self.Width - 30;

  Label1.Refresh;
  CanCP1Btn.Refresh;
  Application.ProcessMessages;
end;
end.

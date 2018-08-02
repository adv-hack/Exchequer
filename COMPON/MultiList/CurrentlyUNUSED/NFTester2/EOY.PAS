unit EOY;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , ETDateU, Dialogs, StdCtrls, ComCtrls, StrUtil, VarConst, Globvar, Progress
  , BTKeys1U, BtrvU2, CardProc, BTSupU1, APIUtil;

type
  TfrmEOY = class(TForm)
    btnCancel: TButton;
    btnOK: TButton;
    Label1: TLabel;
    Label2: TLabel;
    edDate: TDateTimePicker;
    Label3: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    Procedure DoEOY;
  public
    { Public declarations }
  end;

var
  frmEOY: TfrmEOY;

implementation

{$R *.dfm}


Procedure TfrmEOY.DoEOY;
Const
  Fnum     =  CustF;
  Keypath  =  CustCodeK;
  Fnum2    =  InvF;
  Keypath2 =  InvCustK;
Var
  bOK, Abort, First :  Boolean;
  iStatus,
  iStatus2,
  NRunNo,
  PurgeCount,
  PurgeTotal :  LongInt;
  KeyS,
  KeyI,
  KeyChk   :  Str255;
  CustInv  : InvRec;
  Debits, Incentive, Credits, Balance : Real;
  ArchDate, DueDate : string8{LDate};
  FrmProgress : TFrmProgress;

  { Gets the Archive Date }
  Procedure GetArchDate (Var TheDate : String8);
  Var
    Tc      :  Char;
    L,LS,LE :  Byte;
    TBo     :  Boolean;

    Procedure DispWindow;
{    Var
      n  :  Byte;}
    Begin { DispWindow }

      { Create window
      FrmProgress.lStatus.caption := 'Converting Card Balance';

      PopShadw(StaW);

      WriteCtrPop(1,StaW,' - End Of Period - ');

      WriteCtrPop(3,StaW,);

      SetAtt(SetOColorSet(StaW[5]));
      With FPos [DFrNo] Do Begin
        Gotoxy (Fx, Y);
        Write  ('Archive data before:');
      End;

      SetColorAtt(LogoCol);}
    End;  { DispWindow }

  Begin { GetArchDate }
//    L:=DFrNo;
    LS:=L;
//    LE:=DFrNo;

{    if MsgBox('This utility will delete any invoices dated before the date show below.'
    + 'Also any expired members still on the system will be removed if possible.' + #13#13
    + 'Click on OK to Continue.',mtConfirmation,[mbYes,mbNo],mbNo,'End Of Period') = mr Yes then begin}


    { Display fields passed in }
    TheDate := CalcDueDate(Today, -365);  {* No need to change *}

{    ProcessOutPut(TheDate, fpos[DFrNo]);

    Repeat
      Case L of
        DFrNo  : ProcessInput(TheDate, fpos[L], StdInputSet, Tc);
      End; {Case..}

{      L:=Inp_Loop(L,Ls,Le,Tc);

    Until (Tc In [Esc,F9]);}


//    RmWin;

//    GetArchDate := (Tc<>Esc);
  End;  { GetArchDate }


  { Removes any unattached invoices for the period and also any EOD Total invoices }
  Procedure RemoveDodgyInv;
  Const
    FuncBook   = #250 + #250 + #250 + #250 + #250 + #250;
    BS_Debit   = #251 + #251 + #251 + #251 + #251 + #251;
    BS_Credit  = #252 + #252 + #252 + #252 + #252 + #252;

    Fnum    =  InvF;
    Keypath =  InvInvDteK;
//    ProgW : Windx  =  (10,17,60,3,Ord(LogoCol),0,1);
  Var
    KeyS, cKeyS : Str255;
    I           : Integer;
    Del         : Boolean;
  Begin
//    PopUp(ProgW);
//    WriteAt(ProgW[1] + 9,ProgW[2] + 1,White,Blue,'Please Wait, Checking Invoice History...');
//    WriteAt(ProgW[1] + 50,ProgW[2] + 1,White,Blue,'Ý');

    FrmProgress.lStatus.Caption := 'Checking Invoice History...';
    FrmProgress.lStatus.Refresh;

    { Got through customers archiving old invoices and posting a carry forward invoice }
    FillChar(KeyS,SizeOf(KeyS),#0);
    iStatus:=Find_Rec(B_GetFirst,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    I := 1;

    While (iStatus = 0) and (Not Abort) And (Inv.TransDate < ArchDate) Do Begin
      Del := False;

      If (Inv.CustCode <> FuncBook) And
         (Inv.CustCode <> BS_Credit) And
         (Inv.CustCode <> BS_Debit) And
         (Inv.CustCode <> EODInvCust) Then Begin
        { An ordinary invoice }
        cKeyS  := FullCustCode (Inv.CustCode);
        iStatus := Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,cKeyS);

        If (iStatus <> 0) Then Begin
          { Delete Sales Details }
          DeleteLinks (FullNomKey (Inv.FolioNum), SalesDetF, 4, sdFolioK);

          { Delete invoice }
          iStatus:=Delete_Rec(F[Fnum],Fnum,Keypath);
          Report_Berror(FNum, iStatus);

          Del := True;
        End; { If }
      End; { If }

      If (Inv.CustCode = EODInvCust) Then Begin
        { EOD Invoice - Delete }
        iStatus:=Delete_Rec(F[Fnum],Fnum,Keypath);
        Report_Berror(FNum, iStatus);

        Del := True;
      End; { If }

      If Del Then
        iStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS)
      Else
        iStatus:=Find_Rec(B_GetGretr,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);
      Inc (I);

{      If ((I Mod 30) = 0) Then Begin
        Case ((I Div 30) Mod 4) Of
          0 : WriteAt(ProgW[1] + 50,ProgW[2] + 1,White,Blue,'/');
          1 : WriteAt(ProgW[1] + 50,ProgW[2] + 1,White,Blue,'-');
          2 : WriteAt(ProgW[1] + 50,ProgW[2] + 1,White,Blue,'\');
          3 : WriteAt(ProgW[1] + 50,ProgW[2] + 1,White,Blue,'Ý');
        End; { Case }
{      End; { If }

      FrmProgress.lName.Caption := Inv.OurRef;
      FrmProgress.lName.Refresh;
//      WriteAt(ProgW[1] + 9,ProgW[2] + 1,White,Blue,Inv.OurRef);
    End; { With }
//    RmWin;
  End;

Begin
  Abort := FALSE;

  screen.cursor := crHourglass;

  FrmProgress := TFrmProgress.Create(application);
  FrmProgress.ProgressBar1.Max := FrmProgress.ProgressBar1.Max + Used_Recs(F[CustF], CustF);
  FrmProgress.ProgressBar1.Position := 1;
  with FrmProgress do begin
    Caption := 'Purging Data...';
    Show;
  end;{with}

  ArchDate := DateToStr8(edDate.Date);
  DueDate := DateToStr8(edDate.Date - 1);
  PurgeTotal:=Used_Recs(F[Fnum],Fnum);
  PurgeCount:=0;
//  PopShadw(StaW);
//  WriteCtrPop(1,StaW,' - End of Period Archive - ');
//  WriteCtrPop(3,StaW,'Removing Expired Members & old Transactions');
//  WriteCtrPop(4,StaW,'% Complete');
  NRunNo := Set_RunNo(FALSE);
//  Draw_Scale(PBarW);
  TechSuppLog('End Of Period - ' + POutDate(ArchDate));

  { Got through customers archiving old invoices and posting a carry forward invoice }
  FillChar(KeyS,SizeOf(KeyS),#0);
  iStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (iStatus = 0) and (Not Abort) do begin
    With Cust do Begin

      FrmProgress.lName.Caption := CardFullName(Cust, True, True);
      FrmProgress.lName.Refresh;

      bOK := GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyPAth,Fnum,TRUE,GlobLocked);

      If bOK and GlobLocked then Begin
        KeyI:=FullCustCode(CustCode);
        KeyChk:=KeyI;
        iStatus2 := Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyI);
        First := True;

        {TmpDate:=SDateToLDate(ArchDate);}

        While (iStatus2 = 0) and (CheckKey(KeyChk,KeyI,Length(KeyChk),FALSE)) do Begin
          {* Delete >1yr old or all if member fully expired *}

          {If ((Inv.TransDate<CalcDueDate(Today,-365)) and (Inv.RunNo>0)) or ((TillNo=0) and (Hold=2)) then Begin}
          If ((Inv.TransDate<ArchDate) and (Inv.RunNo>0)) or ((TillNo=0) and (Hold=2)) then Begin
            If First Then Begin
              { Initialise the year end invoice }
              FillChar (CustInv, SizeOf (CustInv), #0);

              CustInv.InvDocHed  := NMT;
              {$IFDEF Ex_On}
                SetNextDocNos(CustInv, TRUE);
              {$ELSE}
                CustInv.FolioNum:=Syss.Dummyfolio;
                Inc(Syss.DummyFolio);
                PutMultiSys;
              {$ENDIF}
              CustInv.RunNo      := NRunNo;
              CustInv.PayType    := PayTypes[1];

              CustInv.CustCode   := Inv.CustCode;
              {
              CustInv.TransDate  := SDatetoLDate(DueDate);
              CustInv.DueDate    := SDateToLDate(DueDate);
              }
              CustInv.TransDate  := DueDate;
              CustInv.DueDate    := DueDate;

              {CustInv.InvNetVal  := Inv.InvNetVal;}
              CustInv.InvVat     := Inv.InvVat;
              {CustInv.DiscAmount := Inv.DiscAmount;}
              {CustInv.PrevBal    := Inv.PrevBal;}
              {CustInv.DiscSpent  := Inv.DiscSpent;}
              CustInv.TransDesc  := InvDescEOP;

              CalcInvoiceCredits (Inv, Debits, Incentive, Credits, Balance);
              CustInv.InvNetVal  := ABS(Credits) - ABS(Debits) + ABS(Incentive);

              First := False;
            End { If }
            Else Begin
              { Add current invoice into year end invoice }
              {CustInv.InvNetVal  := CustInv.InvNetVal  + Inv.InvNetVal;
              CustInv.InvVat     := CustInv.InvVat     + Inv.InvVat;
              CustInv.DiscAmount := CustInv.DiscAmount + Inv.DiscAmount;
              CustInv.DiscSpent  := CustInv.DiscSpent  + Inv.DiscSpent;}

              CalcInvoiceCredits (Inv, Debits, Incentive, Credits, Balance);
              CustInv.InvNetVal  := CustInv.InvNetVal + ABS(Credits) - ABS(Debits) + ABS(Incentive);
            End; { Else }

            { Delete Sales Details }
            DeleteLinks (FullNomKey (Inv.FolioNum), SalesDetF, 4, sdFolioK);

            { Delete invoice }
            iStatus2 := Delete_Rec(F[Fnum2],Fnum2,Keypath2);
            Report_Berror(FNum2, iStatus2);
          End; { If }

          iStatus2 := Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyI);
        End; { While }
      End; { If }

       If (TillNo=0) and (Hold=2) then Begin
        { Card Expired - Delete }
        iStatus:=Delete_Rec(F[Fnum],Fnum,Keypath);
        Report_Berror(FNum, iStatus);
      End { If }
      Else Begin
        { Reinitialise year totals }
        CSpent   := 0; { Re-Set Spent todate }
        CPaid    := 0; { Re-Set Paid todate }
        BBallBal := 0; { Re-Set Driving Range Count }
        GuestBal := 0; { Re-Set Guest Balance }

        If (Not First) Then Begin
          { Add year end invoice }
          Inv := CustInv;
          iStatus:=Add_Rec(F[InvF],InvF,RecPtr[InvF]^,InvCustK);
          Report_BError(Fnum, iStatus);
        End; { If }

        { update customer }
        iStatus:=Put_Rec(F[CustF],CustF,RecPtr[CustF]^,Keypath);
        Report_BError(Fnum, iStatus);
      End; { Else }

      Inc(PurgeCount);
//      Show_Bar(Round((PurgeCount/PurgeTotal)*100),PBarW);
      FrmProgress.ProgressBar1.StepIt;

      iStatus := Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);
    End; { With }
  end;{while}

  If (Not Abort) Then RemoveDodgyInv;

  // Hide Progress form
  with FrmProgress do begin
    Release;
  end;{with}

  screen.cursor := crDefault;
  MsgBox('End of year routine completed successfully.',mtInformation,[mbOK],mbOK,'End of Year');
//  SendMessage(FrmMain.Handle,WM_FormCloseMsg,121,1);

end; {Proc..}


procedure TfrmEOY.btnOKClick(Sender: TObject);
begin
  if MsgBox('Are you sure you wish to run this routine.'#13#13
  + 'All data from before ' + Str8ToScreenDate(DateToStr8(edDate.Date)) + ' Will be deleted.'
  , mtWarning, [mbYes,mbNo], mbYes, 'End of Year') = mrYes then begin
    DoEOY;
    Close;
  end;
end;

procedure TfrmEOY.FormCreate(Sender: TObject);
begin
  edDate.Date := SysUtils.Date - 365;
end;

end.

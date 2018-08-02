unit Tranl1u;

{$I DEFOVR.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Globvar,VarConst,

  ExWrap1U,
  
{$IFDEF Inv}

  SaleTx2U,
  RecepU,

  NomTfr2U,
  
  BatchEnU,

  {$IFDEF STK}
     StkAdjU,

     {$IFDEF WOP}
       WORDoc2U,

     {$ENDIF}

     {$IFDEF RET}
       RetDoc1U,
     {$ENDIF}

  {$ENDIF}

  {$IFDEF JC}
    JobTS1U,

    {$IFDEF JAP}
      JCAppD2U,
    {$ENDIF}
  {$ENDIF}

{$ENDIF}

  BTSupU1;


type
  // MH 03/06/2015 2015-R1 ABSEXCH-16482: Added support for display options to allow calling routines
  // to modify the display behaviour as required
  enumTransactionDisplayOptions = (
                                     // Order Payments: For SOR's being edited this will cause the Save process to offer to take a payment,
                                     //                 added for Telesales
                                     OrderPayments_OfferPayment=1,
                                     //PR: 20/11/2017 ABSEXCH-19451 Allow editing of posted transactions
                                     GDPR_AllowPostedEdit = 2
                                  );
  TransactionDisplayOptionsSet  =  Set Of enumTransactionDisplayOptions;

  //------------------------------

  TFInvDisplay = class(TForm)
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    DayBkPtr   :  Pointer;

    // MH 03/06/2015 2015-R1 ABSEXCH-16482: Added support for display options to allow calling routines
    // to modify the display behaviour as required
    procedure Display_Inv(Mode  :  Byte;
                          CPage :  Integer;
                          SFocus:  Boolean;
                          Const DisplayOptions : TransactionDisplayOptionsSet);

    procedure Display_Recep(Mode  :  Byte;
                            CPage :  Integer;
                            SFocus:  Boolean;
                          Const DisplayOptions : TransactionDisplayOptionsSet);


    procedure Display_NTxfr(Mode  :  Byte;
                            CPage :  Integer;
                            SFocus:  Boolean;
                          Const DisplayOptions : TransactionDisplayOptionsSet);

    procedure Display_SAdj(Mode  :  Byte;
                           CPage :  Integer;
                           SFocus:  Boolean);


    procedure Display_WOR(Mode  :  Byte;
                          CPage :  Integer;
                          SFocus:  Boolean;
                          Const DisplayOptions : TransactionDisplayOptionsSet);

    procedure Display_RET(Mode  :  Byte;
                          CPage :  Integer;
                          SFocus:  Boolean;
                          Const DisplayOptions : TransactionDisplayOptionsSet);

    procedure Display_TSht(Mode  :  Byte;
                           CPage :  Integer;
                           SFocus:  Boolean;
                          Const DisplayOptions : TransactionDisplayOptionsSet);

    procedure Display_JAP(Mode  :  Byte;
                          CPage :  Integer;
                          SFocus:  Boolean;
                          Const DisplayOptions : TransactionDisplayOptionsSet);

    procedure Display_Batch(Mode  :  Byte;
                            CPage :  Integer;
                            SFocus:  Boolean);

  public
    { Public declarations }

    DocHistRunNo :  LongInt;
    LastActive   :  Integer;

    LastDocHed   :  DocTypes;

    DocHistCommPurch,
    ForcePrint,
    fBatchEdit   :  Boolean;

    DocRunRef    :  Str10;

    {$IFDEF Inv}

      TransForm  :  Array[0..6] of TSalesTBody;

      RecepForm  :  TRecepForm;
      NTxfrForm  :  TNTxfrForm;
      BatchForm  :  TBatchEntry;

      {$IFDEF STK}
        SAdjForm :  TStkAdj;

        {$IFDEF WOP}
          WORForm :  TWOR;

        {$ENDIF}

        {$IFDEF RET}
          RETForm :  TRETDoc;

        {$ENDIF}


      {$ENDIF}

      {$IFDEF JC}
        TShtForm :  TTSheetForm;

        {$IFDEF JAP}
           JAPForm  :  TJCApp;
        {$ENDIF}
      {$ENDIF}

    {$ENDIF}

    TransActive  :  Array[0..9] of Boolean;

    LastFolio    :  LongInt;


    {$IFDEF DBk_On}
      procedure Display_RunTrans;
    {$ENDIF}

    // MH 03/06/2015 2015-R1 ABSEXCH-16482: Added support for display options to allow calling routines
    // to modify the display behaviour as required
    procedure Display_Trans(Mode  :  Byte;
                            FRef  :  LongInt;
                            GetxF,
                            SFocus:  Boolean;
                            Const DisplayOptions : TransactionDisplayOptionsSet = []);

    procedure PrintDoc(LExLocal  :  TdExLocal);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure Send_UpdateList(Mode,
                              SetLP   :  Integer);

  end;





{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  EtMiscU,
  BtrvU2,
  BtKeys1U,
  SavePos,
  {$IFDEF Frm}
    DefProcU,
  {$ENDIF}

  {$IFDEF DBk_On}
    DayBk2,
  {$ENDIF}

  {$IFDEF RET}
    RetWiz1U,
  {$ENDIF}

  BTSupU2;


{$R *.DFM}



procedure TFInvDisplay.FormCreate(Sender: TObject);
begin
  LastActive:=0;
  fBatchEdit:=BOff;
  Blank(DocRunRef,Sizeof(DocRunRef));
  DocHistRunNo:=0;
  DocHistCommPurch:=BOff;
  DayBkPtr:=nil;
  ForcePrint:=BOff;
end;


Procedure TFInvDisplay.FormDestroy(Sender  :  TObject);

Var
  n  :  Byte;

Begin
  {$IFDEF Inv}

    For n:=0 to High(TransForm) do
      If (TransForm[n]<>nil) then
      Begin
        TransForm[n].Free;
        TransActive[n]:=BOff;
      end;

    If (RecepForm<>nil) then
    Begin
      RecepForm.Free;
      TransActive[1]:=BOff;
    end;

    If (NTxfrForm<>nil) then
    Begin
      NTxfrForm.Free;
      TransActive[2]:=BOff;
    end;

    {$IFDEF STK}

      If (SAdjForm<>nil) then
      Begin
        SAdjForm.Free;
        TransActive[3]:=BOff;
      end;

      {$IFDEF WOP}
        If (WORForm<>nil) then
        Begin
          WORForm.Free;
          TransActive[7]:=BOff;
        end;
      {$ENDIF}


      {$IFDEF RET}
        If (RETForm<>nil) then
        Begin
          RETForm.Free;
          TransActive[9]:=BOff;
        end;
      {$ENDIF}

    {$ENDIF}

    {$IFDEF JC}

      If (TShtForm<>nil) then
      Begin
        TShtForm.Free;
        TransActive[6]:=BOff;
      end;

      {$IFDEF JAP}
        If (JAPForm<>nil) then
        Begin
          JAPForm.Free;
          TransActive[8]:=BOff;
        end;
      {$ENDIF}
    {$ENDIF}

    If (BatchForm<>nil) then
    Begin
      BatchForm.Free;
      TransActive[4]:=BOff;
    end;

  {$ENDIF}

end; {Proc..}


procedure TFInvDisplay.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);


begin
  GenCanClose(Self,Sender,CanClose,BOn);

  If (CanClose) then
    Send_UpdateList(200,0);

 end;


// MH 03/06/2015 2015-R1 ABSEXCH-16482: Added support for display options to allow calling routines
// to modify the display behaviour as required
procedure TFInvDisplay.Display_Inv(Mode  :  Byte;
                                   CPage :  Integer;
                                   SFocus:  Boolean;
                                   Const DisplayOptions : TransactionDisplayOptionsSet);
var
  InvSavePos : TBtrieveSavePosition;
Begin

  {$IFDEF Inv}

    {If (SFocus) or (TransForm[0]<>nil) then}
    Begin
      If (TransForm[0]=nil) then
      Begin
        // HV - 25-11-2015, Fixed issue for Jira ABSEXCH-13611,
        //When double-clicking a transaction at the bottom of a maximized Trader Ledger screen it's open with incorrect transaction
        InvSavePos := TBtrieveSavePosition.Create;
        try
          InvSavePos.SaveFilePosition (InvF, GetPosKey);
          InvSavePos.SaveDataBlock (@Inv, SizeOf(Inv));
          LastActive:=0;
          Set_TransFormMode(LastDocHed,CPage);  {*Ex 32 needs changing *}
          TransForm[0]:=TSalesTBody.Create(Self);
        finally
          InvSavePos.RestoreDataBlock (@Inv);
          InvSavePos.RestoreSavedPosition;
          InvSavePos.Free;
        end
      end;

      Try

       TransActive[0]:=BOn;

       With TransForm[0] do
       Begin

         //PR: 12/12/2017 ABSEXCH-19451
         if GDPR_AllowPostedEdit in DisplayOptions then
           EnableEditPostedFields;

         fInBatchEdit:=fBatchEdit;

         WindowState:=wsNormal;

         If (SFocus) then
           Show;



         If (Mode In [1..3,7,9]) and (Not ExLocal.InAddEdit) then
         Begin
           ChangePage(0+(2*Ord(Mode=9))+(6*Ord(Mode=7)));

           Case Mode of

             1,2,7,9                                    {Set auto for auto edit via ledger, but exlude batch items which also have nomauto false}
                :   EditAccount((Mode<>1),(CPage=2) or ((Not Inv.NomAuto) and (Mode>1) and (Copy(Inv.BatchLink,2,2)<>'BT')),BOff,(Mode=9));

           end; {Case..}

           // MH 03/06/2015 2015-R1 ABSEXCH-16482: Pass flag through to Edit SOR window to add
           // offer of taking a payment for an order added from Telesales
           TransForm[0].OrderPaymentsAutoPayment := (OrderPayments_OfferPayment In DisplayOptions);
         end
         else
           If (Not ExLocal.InAddEdit) then
             ShowLink(BOn,BOn);


         {If (Mode=5) then
           ChangePage(2);}

       end; {With..}


      except

       TransActive[0]:=BOff;

       TransForm[0].Free;

      end;
    end;

  {$ENDIF}

end;


procedure TFInvDisplay.Display_Recep(Mode  :  Byte;
                                     CPage :  Integer;
                                     SFocus:  Boolean;
                          Const DisplayOptions : TransactionDisplayOptionsSet);
var
  RecepSavePos : TBtrieveSavePosition;
Begin

  {$IFDEF Inv}

    {If (SFocus) or (RecepForm<>nil) then}
    Begin

      If (RecepForm=nil) then
      Begin
        // HV - 25-11-2015, Fixed issue for Jira ABSEXCH-13611,
        //When double-clicking a transaction at the bottom of a maximized Trader Ledger screen it's open with incorrect transaction
        RecepSavePos := TBtrieveSavePosition.Create;
        try
          RecepSavePos.SaveFilePosition (InvF, GetPosKey);
          RecepSavePos.SaveDataBlock (@Inv, SizeOf(Inv));
          LastActive:=1;
          Set_RecepFormMode(LastDocHed,1);  {*Ex 32 needs changing *}
          RecepForm:=TRecepForm.Create(Self);
        finally
          RecepSavePos.RestoreDataBlock (@Inv);
          RecepSavePos.RestoreSavedPosition;
          RecepSavePos.Free;
        end
      end;

      Try

       TransActive[1]:=BOn;

       With RecepForm do
       Begin

         //PR: 14/12/2017 ABSEXCH-19451
         if GDPR_AllowPostedEdit in DisplayOptions then
           EnableEditPostedFields;

         WindowState:=wsNormal;

         If (SFocus) then
           Show;



         If (Mode In [1..2,7]) and (Not ExLocal.InAddEdit) then
         Begin
           ChangePage(0+(1*Ord(Mode=7)));

           Case Mode of

             1,2,7
                :   EditAccount((Mode<>1),(CPage=2) or ((Not Inv.NomAuto) and (Mode>1)),BOff);

           end; {Case..}

         end
         else
           If (Not ExLocal.InAddEdit) then
           begin
             if GDPR_AllowPostedEdit in DisplayOptions then
               EditAccount((Mode<>1),(CPage=2) or ((Not Inv.NomAuto) and (Mode>1)),True)
             else
               ShowLink(BOn,BOn);
          end;



       end; {With..}


      except

       TransActive[1]:=BOff;

       RecepForm.Free;

      end;
    end;

  {$ENDIF}

end;


procedure TFInvDisplay.Display_NTxfr(Mode  :  Byte;
                                     CPage :  Integer;
                                     SFocus:  Boolean;
                                   Const DisplayOptions : TransactionDisplayOptionsSet);

Begin

  {$IFDEF Inv}

    {If (SFocus) or (NTxfrForm<>nil) then}
    Begin
      If (NTxfrForm=nil) then
      Begin
        LastActive:=2;


        Set_NTxfrFormMode(LastDocHed,2);  {*Ex 32 needs changing *}

        NTxfrForm:=TNTxfrForm.Create(Self);

      end;

      Try

       TransActive[2]:=BOn;

       With NTxfrForm do
       Begin
         //PR: 14/12/2017 ABSEXCH-19451
         if GDPR_AllowPostedEdit in DisplayOptions then
           EnableEditPostedFields;

         WindowState:=wsNormal;

         If (SFocus) then
           Show;



         If (Mode In [1..2,7]) and (Not ExLocal.InAddEdit) then
         Begin
           ChangePage(0+(2*Ord(Mode=7)));

           Case Mode of

             1,2,7
                :   EditAccount((Mode<>1),(CPage=2),BOff);

           end; {Case..}

         end
         else
           If (Not ExLocal.InAddEdit) then
             ShowLink(BOn,BOn);



       end; {With..}


      except

       TransActive[2]:=BOff;

       NTxfrForm.Free;

      end;
    end;

  {$ENDIF}

end;

procedure TFInvDisplay.Display_SAdj(Mode  :  Byte;
                                    CPage :  Integer;
                                    SFocus:  Boolean);


Begin

  {$IFDEF Inv}

    {$IFDEF STK}

     If (SAdjForm=nil) then
     Begin

       Set_SAdjFormMode(LastDocHed,3);

       SAdjForm:=TStkAdj.Create(Self);

     end;

     Try

      TransActive[3]:=BOn;

      With SAdjForm do
      Begin

        WindowState:=wsNormal;

        If (SFocus) then
          Show;


        If (Mode In [1..2,7]) and (Not ExLocal.InAddEdit) then
        Begin
          ChangePage(0+(1*Ord(Mode=7)));

          Case Mode of

            1,2,7
               :   EditAccount((Mode<>1),(CPage=2),BOff);

          end; {Case..}

        end
        else
          If (Not ExLocal.InAddEdit) then
            ShowLink(BOn,BOn);



      end; {With..}


     except

      TransActive[3]:=BOff;

      SAdjForm.Free;

     end;

    {$ENDIF}
  {$ENDIF}

end;



procedure TFInvDisplay.Display_WOR(Mode  :  Byte;
                                   CPage :  Integer;
                                   SFocus:  Boolean;
                                   Const DisplayOptions : TransactionDisplayOptionsSet);

Begin

  {$IFDEF Inv}

    {$IFDEF STK}
      {$IFDEF WOP}

       If (WORForm=nil) then
       Begin

         Set_WORFormMode(LastDocHed,7);

         WORForm:=TWOR.Create(Self);

       end;

       Try

        TransActive[7]:=BOn;

        With WORForm do
        Begin
         //PR: 14/12/2017 ABSEXCH-19451
         if GDPR_AllowPostedEdit in DisplayOptions then
           EnableEditPostedFields;

          WindowState:=wsNormal;

          If (SFocus) then
            Show;


          If (Mode In [1..2,7]) and (Not ExLocal.InAddEdit) then
          Begin
            ChangePage(0+(1*Ord(Mode=7)));

            Case Mode of

              1,2,7
                 :   EditAccount((Mode<>1),(CPage=2),BOff);

            end; {Case..}

          end
          else
            If (Not ExLocal.InAddEdit) then
              ShowLink(BOn,BOn);



        end; {With..}


       except

        TransActive[7]:=BOff;

        WORForm.Free;

       end;
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

end;


procedure TFInvDisplay.Display_RET(Mode  :  Byte;
                                   CPage :  Integer;
                                   SFocus:  Boolean;
                                   Const DisplayOptions : TransactionDisplayOptionsSet);

Begin

  {$IFDEF Inv}

    {$IFDEF STK}
      {$IFDEF RET}

       If (RETForm=nil) then
       Begin

         Set_RETFormMode(LastDocHed,9);

         RETForm:=TRETDoc.Create(Self);

       end;

       Try

        TransActive[9]:=BOn;

        With RETForm do
        Begin
         //PR: 14/12/2017 ABSEXCH-19451
         if GDPR_AllowPostedEdit in DisplayOptions then
           EnableEditPostedFields;

          WindowState:=wsNormal;

          If (SFocus) then
            Show;


          If (Mode In [1..2,7]) and (Not ExLocal.InAddEdit) then
          Begin
            ChangePage(0+(1*Ord(Mode=7)));

            Case Mode of

              1,2,7
                 :   EditAccount((Mode<>1),(CPage=2),BOff);

            end; {Case..}

          end
          else
            If (Not ExLocal.InAddEdit) then
              ShowLink(BOn,BOn);



        end; {With..}


       except

        TransActive[9]:=BOff;

        RETForm.Free;

       end;
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

end;



procedure TFInvDisplay.Display_JAP(Mode  :  Byte;
                                   CPage :  Integer;
                                   SFocus:  Boolean;
                                   Const DisplayOptions : TransactionDisplayOptionsSet);


Begin

  {$IFDEF Inv}

    {$IFDEF JC}
      {$IFDEF JAP}

       If (JAPForm=nil) then
       Begin

         Set_JAPFormMode(LastDocHed,8);

         JAPForm:=TJCAPP.Create(Self);

       end;

       Try

        TransActive[8]:=BOn;

        With JAPForm do
        Begin
         //PR: 14/12/2017 ABSEXCH-19451
         if GDPR_AllowPostedEdit in DisplayOptions then
           EnableEditPostedFields;

          WindowState:=wsNormal;

          If (SFocus) then
            Show;


          If (Mode In [1..2,7,8]) and (Not ExLocal.InAddEdit) then
          Begin
            ChangePage(0+(5*Ord(Mode=7)));

            Case Mode of

              1,2,7,8
                 :   Begin
                       EditAccount((Mode<>1),(CPage=2),BOff);

                       If (Mode=8) then {* Force store *}
                         ForceStore:=BOn;
                     end;

            end; {Case..}

          end
          else
            If (Not ExLocal.InAddEdit) then
              ShowLink(BOn,BOn);



        end; {With..}


       except

        TransActive[8]:=BOff;

        JAPForm.Free;

       end;
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

end;


procedure TFInvDisplay.Display_TSht(Mode  :  Byte;
                                    CPage :  Integer;
                                    SFocus:  Boolean;
                          Const DisplayOptions : TransactionDisplayOptionsSet);


Begin

  {$IFDEF Inv}

    {$IFDEF JC}

     If (TShtForm=nil) then
     Begin
       LastActive:=6;

       Set_TSheetFormMode(LastDocHed,6);

       TShtForm:=TTSheetForm.Create(Self);

     end;

     Try

      TransActive[6]:=BOn;

      if GDPR_AllowPostedEdit in DisplayOptions then
        TShtForm.EnableEditPostedFields;

      With TShtForm do
      Begin

        WindowState:=wsNormal;

        If (SFocus) then
          Show;


        If (Mode In [1..2,7]) and (Not ExLocal.InAddEdit) then
        Begin
          ChangePage(0+(1*Ord(Mode=7)));

          Case Mode of

            1,2,7
               :   EditAccount((Mode<>1),(CPage=2),BOff);

          end; {Case..}

        end
        else
          If (Not ExLocal.InAddEdit) then
            ShowLink(BOn,BOn);



      end; {With..}


     except

      TransActive[6]:=BOff;

      TShtForm.Free;
      TShtForm:=nil;

     end;

    {$ENDIF}
  {$ENDIF}

end;


procedure TFInvDisplay.Display_Batch(Mode  :  Byte;
                                     CPage :  Integer;
                                     SFocus:  Boolean);

Begin

  {$IFDEF Inv}

    {If (SFocus) or (NTxfrForm<>nil) then}
    Begin
      If (BatchForm=nil) then
      Begin
        LastActive:=4;


        Set_BatchFormMode(LastDocHed,4);  {*Ex 32 needs changing *}

        BatchForm:=TBatchEntry.Create(Self);

      end;

      Try

       TransActive[4]:=BOn;

       With BatchForm do
       Begin

         WindowState:=wsNormal;

         If (SFocus) then
           Show;



         If (Mode In [1..2,7]) and (Not ExLocal.InAddEdit) then
         Begin
           ChangePage(0+(2*Ord(Mode=7)));

           Case Mode of

             1,2,7
                :   EditAccount((Mode<>1),(CPage=2),BOff);

           end; {Case..}

         end
         else
           If (Not ExLocal.InAddEdit) then
             ShowLink(BOn,BOn);



       end; {With..}


      except

       TransActive[4]:=BOff;

       BatchForm.Free;

      end;
    end;

  {$ENDIF}

end;


{$IFDEF DBk_On}

  procedure TFInvDisplay.Display_RunTrans;

  Var
    RunDayBk  :  TDayBk1;

  Begin
    RunDayBk := nil;
    Set_DayBkHistMode(DocHistRunNo,DocHistCommPurch);

    Try
      If (Not Assigned(DayBkPtr)) then
      Begin
        RunDayBk:=TDayBk1.Create(Self);
        DayBkPtr:=RunDayBk;
      end
      else
      Begin
        RunDayBk:=DayBkPtr;

        RunDayBk.HistModeScan(DocHistRunNo,DocHistCommPurch);
      end;

    except
      RunDayBk.Free;
    end; {try..}


  end;

{$ENDIF}


// MH 03/06/2015 2015-R1 ABSEXCH-16482: Added support for display options to allow calling routines
// to modify the display behaviour as required
procedure TFInvDisplay.Display_Trans(Mode  :  Byte;
                                     FRef  :  LongInt;
                                     GetxF,
                                     SFocus:  Boolean;
                                     Const DisplayOptions : TransactionDisplayOptionsSet = []);

Const
  Fnum    =  InvF;

Var
  KeyS     :  Str255;

  KeyPath  :  SmallInt;
  CPage    :  Integer;




Begin
  KeyPath:=  InvFolioK;

  LastFolio:=FRef;

  If (GetxF) then
  Begin
    If (LastDocHed=RUN) then
    Begin
      If (DocRunRef<>'') then
      Begin
        KeyS:=DocRunRef;
        KeyPath:=InvOurRefK;
      end
      {$IFDEF DBk_On}
        else
          If (DocHistRunNo<>0) then
          Begin
            Display_RunTrans;
            Status:=4;
          end;
      {$ENDIF}
    end
    else
      KeyS:=FullNomKey(LastFolio);

    If (Mode<>1) then
      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (LastDocHed=RUN) then
      LastDocHed:=Inv.InvDocHed;
  end;

  If (StatusOk) or (Not GetxF) or (Mode=1) then
  Begin

    {$IFDEF Inv}

      CPage:=0;

      If (LastDocHed In RecieptSet) then
        Display_Recep(Mode,CPage,SFocus, DisplayOptions)
      else
        If (LastDocHed In NomSplit) then
          Display_NTxfr(Mode,CPage,SFocus, DisplayOptions)
        else
          If (LastDocHed In StkAdjSplit) then
            Display_SAdj(Mode,CPage,SFocus)
          else
            If (LastDocHed In BatchSet) then
              Display_Batch(Mode,CPage,SFocus)
            else
              If (LastDocHed In TSTSplit ) then
                Display_TSht(Mode,CPage,SFocus, DisplayOptions)
              else
                If (LastDocHed In WOPSplit ) then
                  Display_WOR(Mode,CPage,SFocus, DisplayOptions)
                else
                  If (LastDocHed In StkRETSplit ) then
                    Display_RET(Mode,CPage,SFocus, DisplayOptions)
                  else
                    If (LastDocHed In JAPSplit ) then
                      Display_JAP(Mode,CPage,SFocus, DisplayOptions)
                    else
                      // MH 03/06/2015 2015-R1 ABSEXCH-16482: Added support for display options to allow calling routines
                      // to modify the display behaviour as required
                      Display_Inv(Mode,CPage,SFocus, DisplayOptions);

    {$ENDIF}

  end;

end;



procedure TFInvDisplay.PrintDoc(LExLocal  :  TdExLocal);

{$IFDEF Frm}

  begin

    With LExLocal,LInv do
      Control_DefProcess(DEFDEFMode[InvDocHed],
                         IdetailF,IdFolioK,
                         FullNomKey(FolioNum),LExLocal,BOn);
{$ELSE}
  Begin
{$ENDIF}
end;



Procedure TFInvDisplay.WMCustGetRec(Var Message  :  TMessage);

Var
  n  :  SmallInt;

  LExLocal
     :  TdExLocal;

Begin

  With Message do
  Begin


    Case WParam of

         1  :  ;

       100..109
         :  Begin
              {$IFDEF Inv}

                Case WParam of

                  101  :  LExLocal:=RecepForm.ExLocal;
                  102  :  LExLocal:=NTxfrForm.ExLocal;

                  {$IFDEF STK}
                    103:  LExLocal:=SAdjForm.ExLocal;

                    {$IFDEF WOP}
                      107:  LExLocal:=WORForm.ExLocal;
                    {$ENDIF}

                    {$IFDEF RET}
                      109:  LExLocal:=RETForm.ExLocal;
                    {$ENDIF}
                  {$ENDIF}

                  104  :  LExLocal:=BatchForm.ExLocal;

                  {$IFDEF JC}
                    106:  Begin
                            LExLocal:=TShtForm.ExLocal;
                            Send_UpDateList(WParam,LParam);
                          end;

                    {$IFDEF JAP}
                      108:  Begin
                              LExLocal:=JAPForm.ExLocal;
                              Send_UpDateList(WParam,LParam);
                            end;
                    {$ENDIF}
                  {$ENDIF}

                  else    LExLocal:=TransForm[0].ExLocal;
                end; {Case..}


              If (LParam=0)  or (ForcePrint) then
              With LExLocal do
                If (LInv.InvDocHed In AutoPrnSet)  or (ForcePrint) then {* Auto print *}
                  PrintDoc(LExLocal);

              Send_UpDateList(18,1); {* Force refresh *}

              {$ENDIF}
            end;

       110  :  Send_UpDateList(WParam,0);

       200..209
            :
             Begin
              {$IFDEF Inv}

                Case WParam of

                  200  :  TransForm[0]:=nil;
                  201  :  RecepForm:=nil;
                  202  :  NTxfrForm:=nil;

                  {$IFDEF STK}
                    203:  SAdjForm:=nil;

                    {$IFDEF WOP}
                      207:  WORForm:=nil;

                    {$ENDIF}

                    {$IFDEF RET}
                      209:  RETForm:=nil;

                    {$ENDIF}
                  {$ENDIF}

                  204  :  BatchForm:=nil;

                  {$IFDEF JC}
                    206:  TShtForm:=nil;

                    {$IFDEF JAP}
                      208:  JAPForm:=nil;
                    {$ENDIF}
                  {$ENDIF}

                end; {Case..}

              {$ENDIF}

              TransActive[WParam-200]:=BOff;


              For n:=Low(TransActive) to High(TransActive) do
                If (TransActive[n]) then
                  Exit;


              Send_UpDateList(18,0);
            end;


    end; {Case..}

  end;
  Inherited;
end;



Procedure TFInvDisplay.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
  Begin


    Case WParam of

         14  :  DayBkPtr:=nil;

         {$IFDEF RET}
           100,101
             :  Begin
                  Begin
                   Set_RetWiz(Inv,Id,Inv.InvDocHed,'',1,0);

                   with TRetWizard.Create(Self) do
                   Begin
                     Show;

                     If (WParam=100) then
                     Begin
                       A1PActionCB.ItemIndex:=2;
                       A1PActionCB.OnChange(nil);
                     end;
                   end;
                 end;

                end;

         {$ENDIF}


    end; {Case..}

  end;
  Inherited;
end;

{ == Procedure to Send Message to Get Record == }

Procedure TFInvDisplay.Send_UpdateList(Mode,
                                       SetLP   :  Integer);


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
    LParam:=SetLP;

    If (Owner is TForm) then
      MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);
  end;

end; {Proc..}




{-----------------------}




end.

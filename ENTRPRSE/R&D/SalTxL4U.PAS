unit SalTxl4U;


{$I DEFOVR.INC}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Dialogs, StdCtrls, ExtCtrls,Forms,TEditVal,
  Globvar,VarConst,
  BTSupU1,
  ExWrap1U,
  Tranl1U,

  {$IFDEF Nom}
    Nominl1U,
  {$ENDIF}

  {$IFDEF STK}
    SalTxl2U,
    StkTreeU,

    {$IFDEF STK}
       {*EN431MB2B*}
       ExBtTh1U,
       SCRTCH2U,
       BTSupU3,
    {$ENDIF}
  {$ENDIF}

  {$IFDEF Frm}
    GlobType,
  {$ENDIF}

  {$IFDEF JC}
    SalTxl3U,
    JobTreeU,
  {$ENDIF}

  SalTxl1U;

type
  TFRepDisplay = class(TForm)
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    Procedure ShutDown;


  public
    { Public declarations }

    AutoShutDown :  Boolean;

    ExLocal      :  TdExLocal;

    DispTrans    :  TFInvDisplay;
    DispCust     :  TFCustDisplay;

    {$IFDEF Nom}
      DispNom    :  TNomView;
    {$ENDIF}
    {$IFDEF Stk}
      DispStk    :  TFStkDisplay;
      DispStkTree:  TStkView;

    {$ENDIF}

    {$IFDEF JC}
      DispJob    :  TFJobDisplay;
      DispJobTree:  TJobView;

      DispVch    :  TFJobDisplay;

      DispEmp    :  TFJobDisplay;
    {$ENDIF}


    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    procedure Display_Trans(Mode  :  Byte);

    procedure Display_Account(Mode  :  Byte);

    procedure Display_Nominal(Mode  :  Byte;
                              CCode :  Str10;
                              CCMode:  Boolean);

    {$IFDEF STK}

      procedure Display_Stock(Mode  :  Byte);

      procedure Display_StkTree(Mode  :  Byte;
                                CCode :  Str10);

    {$ENDIF}

    procedure Display_Job(Mode  :  Byte);

    procedure Display_Vch(Mode  :  Byte);

    procedure Display_Emp(Mode  :  Byte);

    procedure Display_JobTree(Mode  :  Byte;
                              CCode :  Str10);


    {$IFDEF FRM}
      Procedure  LinkDDToDisplay(RepDataRec : EntCopyDataRecType);
    {$ENDIF}
  end;



{ ----------------------}

{$IFDEF FRM}
  Procedure Display_ReportDrillDown(RepDataRec : EntCopyDataRecType;
                                    AOwner     : TComponent);

{$ENDIF}

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  EtMiscU,
  SBSPanel,
  BtrvU2,
  BtKeys1U,
  VARRec2U,
  BTSupU2,
  PWarnU;


{$R *.DFM}



procedure TFRepDisplay.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ExLocal.Destroy;

  Action:=caFree;
end;

procedure TFRepDisplay.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  GenCanClose(Self,Sender,CanClose,BOn);
end;

procedure TFRepDisplay.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  DispTrans:=nil;
  DispCust:=nil;

  {$IFDEF Nom}
    DispNom:=nil;
  {$ENDIF}

  {$IFDEF Stk}
    DispStk:=nil;
  {$ENDIF}

  {$IFDEF JC}
    DispJob:=nil;
    DispJobTree:=nil;

    DispVch:=nil;
    DispEmp:=nil;
  {$ENDIF}

  AutoShutDown:=BOff;
end;


{ == Procedure to Send Message to Get Record == }

Procedure TFRepDisplay.Send_UpdateList(Edit   :  Boolean;
                                        Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    If (Owner=Application.MainForm) then
      MSg:=WM_FormCloseMsg
    else
      MSg:=WM_CustGetRec;

    WParam:=Mode;
    LParam:=Ord(Edit);
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}

Procedure TFRepDisplay.ShutDown;

Begin
  If (AutoShutDown) then
  Begin
    Send_UpDateList(BOff,67);

    PostMessage(Self.Handle,WM_FormCloseMsg,0,0);
  end;
end;

Procedure TFRepDisplay.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of

      0 :  ;

      {$IFDEF Nom}

        40  :  DispNom:=nil;

      {$ENDIF}


      {$IFDEF STK}

        46  :  {$IFDEF SOP}
                  If (LParam=-1) then
                    DispStkTree:=nil
                 else
               {$ENDIF}
                 DispStk:=nil;

      {$ENDIF}

      {$IFDEF JC}

        55  :  DispJobTree:=nil;

      {$ENDIF}

    end; {Case..}

    If (WParam In [40,46,55]) then
      ShutDown;

  end;


  Inherited;
end;

Procedure TFRepDisplay.WMCustGetRec(Var Message  :  TMessage);
Begin


  With Message do
  Begin


    Case WParam of
      {$IFDEF SOP}
         19  :  SerStkRec:=nil;
      {$ENDIF}

      {$IFDEF JC}

          36  :  DispJob:=nil;

          37  :  DispVch:=nil;

          38  :  DispEmp:=nil;

      {$ENDIF}


        200
             :  DispTrans:=nil;


    end; {Case..}

    If (WParam In [19,36,37,38,200]) then {Auto shut down}
      ShutDown;

  end;


  Inherited;
end;


{ ======= Link to Trans display ======== }

procedure TFRepDisplay.Display_Trans(Mode  :  Byte);

Begin

  ExLocal.LastInv:=ExLocal.LInv;

  ExLocal.AssignFromGlobal(InvF);

  If (DispTrans=nil) then
    DispTrans:=TFInvDisplay.Create(Self);

    try

      With ExLocal,DispTrans do
      Begin
        LastDocHed:=LInv.InvDocHed;

        Display_Trans(Mode,0,BOff,BOn);

      end; {with..}

    except

      DispTrans.Free;

    end;

  ExLocal.LInv:=ExLocal.LastInv;
end;


{ ======= Link to Account display ======== }

procedure TFRepDisplay.Display_Account(Mode  :  Byte);

Begin
  ExLocal.AssignFromGlobal(CustF);

  If (DispCust=nil) then
    DispCust:=TFCustDisplay.Create(Self);

  try


    With DispCust do
      Display_Account(IsACust(ExLocal.LCust.CustSupp),0,ExLocal.LInv);

  except

    DispCust.Free;

  end; {try..}
end;


{ ======= Link to Nominal display ======== }

procedure TFRepDisplay.Display_Nominal(Mode  :  Byte;
                                       CCode :  Str10;
                                       CCMode:  Boolean);


Begin

  {$IFDEF Nom}

    ExLocal.AssignFromGlobal(NomF);

    If (DispNom=nil) then
      DispNom:=TNomView.Create(Self);

    try

      With DispNom do
      Begin
        Show;
        PlaceNomCode(ExLocal.LNom.NomCode);

        If (Syss.PostCCNom) and (CCode<>CCNomFilt[CCMode]) then
        Begin
          CCNomMode:=CCMode;

          CCNomFilt[CCNomMode]:=CCode;

          CurrencyClick(Self);
        end;
      end;

    except

      DispNom.Free;

    end; {try..}

  {$ENDIF}
end;

{ ======= Link to Stock display ======== }

{$IFDEF Stk}

  procedure TFRepDisplay.Display_Stock(Mode  :  Byte);

  Begin


    ExLocal.AssignFromGlobal(StockF);

    If (DispStk=nil) then
      DispStk:=TFStkDisplay.Create(Self);

    try

      With DispStk do
      Begin
        Display_Account(1);
      end;
    except

      DispStk.Free;

    end; {try..}


  end;



  { ======= Link to Nominal display ======== }

  procedure TFRepDisplay.Display_StkTree(Mode  :  Byte;
                                         CCode :  Str10);


  Begin

      ExLocal.AssignFromGlobal(StockF);

      If (DispStkTree=nil) then
        DispStkTree:=TStkView.Create(Self);

      try

        With DispStkTree do
        Begin
          Show;

          ExLocal.AssignToGlobal(StockF);

          PlaceNomCode(ExLocal.LStock.StockFolio);

          If (Syss.UseMLoc) and (CCode<>StkLocFilt) then
          Begin
            StkLocFilt:=CCode;

            CurrencyClick(Self);
          end;
        end;

      except

        DispStkTree.Free;

      end; {try..}
  end;




{$ENDIF}



{ ======= Link to Job display ======== }

procedure TFRepDisplay.Display_Job(Mode  :  Byte);

Begin

  {$IFDEF JC}

    ExLocal.AssignFromGlobal(JobF);

    If (DispJob=nil) then
      DispJob:=TFJobDisplay.Create(Self);

    try

      With DispJob do
      Begin
        Display_Account(1,ExLocal.LJobRec^.JobCode,'',0,0,BOff,nil);
      end;
    except

      DispJob.Free;

    end; {try..}

  {$ENDIF}
end;


{ ======= Link to Voucher display ======== }

procedure TFRepDisplay.Display_Vch(Mode  :  Byte);

Begin

  {$IFDEF JC}

    ExLocal.AssignFromGlobal(JDetlF);

    If (DispVch=nil) then
      DispVch:=TFJobDisplay.Create(Self);

    try

      With DispVch do
      Begin
        Display_Voucher(2,BOn);
      end;
    except

      DispVch.Free;

    end; {try..}

  {$ENDIF}
end;

{ ======= Link to Employee display ======== }

procedure TFRepDisplay.Display_Emp(Mode  :  Byte);

Begin

  {$IFDEF JC}

    ExLocal.AssignFromGlobal(JMiscF);

    If (DispEmp=nil) then
      DispEmp:=TFJobDisplay.Create(Self);

    try

      With DispEmp do
      Begin
        Display_Employee(2,BOn);
      end;
    except

      DispEmp.Free;

    end; {try..}

  {$ENDIF}
end;


{ ======= Link to Job  display ======== }

procedure TFRepDisplay.Display_JobTree(Mode  :  Byte;
                                       CCode :  Str10);


Begin
    {$IFDEF JC}

      ExLocal.AssignFromGlobal(JobF);

      If (DispJobTree=nil) then
        DispJobTree:=TJobView.Create(Self);

      try

        With DispJobTree do
        Begin
          Show;

          ExLocal.AssignToGlobal(JobF);

          PlaceNomCode(ExLocal.LJobRec^.JobFolio);

          ReconBtnClick(nil);

        end;

      except

        DispJobTree.Free;

      end; {try..}
    {$ENDIF}
end;


{ === Proc to resolve DD message into a display == }

{$IFDEF FRM}
  Procedure  TFRepDisplay.LinkDDToDisplay(RepDataRec : EntCopyDataRecType);

  Begin
    With RepDataRec do
    Begin
      Status:=Find_Rec(B_GetEq,F[ddFileNo],ddFileNo,RecPtr[ddFileNo]^,ddIndexNo,ddKeyString);

      If (StatusOk) then
      Begin
        Case ddFileNo of
          CustF :  If (Allowed_In(IsACust(Cust.CustSupp),34)) or (Allowed_In(Not IsACust(Cust.CustSupp),44)) then
                     Display_Account(0);

          InvF  :  With Inv do
                       If (Allowed_In(InvDocHed In (SalesSplit-OrderSet),05)) or
                        (Allowed_In(InvDocHed In (PurchSplit-OrderSet),14)) or
                        (Allowed_In(InvDocHed In NomSplit,26)) or
                        (Allowed_In(InvDocHed In (OrderSet-PurchSplit),158)) or
                        (Allowed_In(InvDocHed In (OrderSet-SalesSplit),168)) or
                        (Allowed_In(InvDocHed In (TSTSplit),217)) or
                        (Allowed_In(InvDocHed In (WOPSplit),378)) or
                        (Allowed_In(InvDocHed In (JAPSalesSplit),446)) or
                        (Allowed_In(InvDocHed In (JAPPurchSplit),437)) or
                        (Allowed_In(InvDocHed In (StkRetSalesSplit),580)) or
                        (Allowed_In(InvDocHed In (StkRetPurchSplit),534)) or 
                        (Allowed_In(InvDocHed In (StkAdjSplit),118)) then
                        
                           Display_Trans(99);

          {$IFDEF Nom}
            NomF  :  If (Allowed_In(BOn,26)) then
                       Display_Nominal(0,'',BOff);

            PWrdF :  With PassWord,CostCtrRec do
                     Begin
                       {* Get Nominal *}
                       {Status:=Find_Rec(B_GetEq,F[NLFnum],NLFnum,RecPtr[NLFnum]^,NLKeyPath,NLKey);}

                       If (Allowed_In(BOn,26)) then
                         Display_Nominal(0,PCostC,(SubType=CSubCode[BOn]));
                     end;
          {$ENDIF}

          {$IFDEF Stk}
            StockF  :  Case DDMode of
                         0  :  If (Allowed_In(BOn,469)) then
                                 Display_Stock(0);

                         1  :  If (Allowed_In(BOn,469)) then
                                 Display_StkTree(0,'')

                       end; {Case..}

            {$IFDEF SOP}
              MLocF : With MLocCtrl^.MLocLoc do
                      Begin
                       {* Get Stock*}
                       {Status:=Find_Rec(B_GetEq,F[NLFnum],NLFnum,RecPtr[NLFnum]^,NLKeyPath,NLKey);}

                       If (Allowed_In(BOn,111)) then
                         Display_StkTree(0,loCode)
                     end;


            {$ENDIF}
          {$ENDIF}


          {$IFDEF JC}
            JobF    :  If (Allowed_In(BOn,205)) then
                         Display_Job(0);

            JMiscF  :  Case ddMode of
                         0    :  Begin {Employee}
                                   Display_Emp(0);
                                 end;

                         1    :  Begin
                                   {* Get Job*}
                                   {Status:=Find_Rec(B_GetEq,F[NLFnum],NLFnum,RecPtr[NLFnum]^,NLKeyPath,NLKey);}

                                   If (Allowed_In(BOn,205)) then
                                     Display_JobTree(0,JobMisc^.JobAnalRec.JAnalCode);
                                 end;
                        end; {Case..}

            JDetlF    :  Case ddMode of
                           3  :  Display_Vch(0);
                         end; {Case..}


          {$ENDIF}

        end; {Case..}
      end;

    end; {With..}
  end;

{$ENDIF}


{ === Proc to display Report Drill down == }

{$IFDEF FRM}
  Procedure Display_ReportDrillDown(RepDataRec : EntCopyDataRecType;
                                    AOwner     : TComponent);

  Begin
    With TFRepDisplay.Create(AOwner) do
    try
      AutoShutDown:=BOn;
      LinkDDToDisplay(RepDataRec);
    except
      Free;
    end; {Try..}

  end;

{$ENDIF}

end.

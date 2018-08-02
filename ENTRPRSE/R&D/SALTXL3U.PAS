unit SalTxl3U;


{$I DEFOVR.INC}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Dialogs, StdCtrls, ExtCtrls,Forms,TEditVal,
  Globvar,VarConst,

  {$IFDEF JC}

    JobMn2U,

    CISVch2U,

    JCEmpR3U,
  {$ENDIF}


  SBSComp2,
  BTSupU1;

type
  TFJobDisplay = class(TForm)
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    TFJobACode,
    TFJobCCode :  Str20;

    EmpActive,
    VchActive,
    JobActive  :  Boolean;

    {$IFDEF JC}

      JobRecForm :  TJobRec;

    {$ENDIF}

    VchRecForm  :  TCISVoucher;
    ShowEmpRec  :  TJEmpRec;


    procedure Display_Account(Mode    :  Byte;
                              TJC     :  Str10;
                              TJA     :  Str20;
                              TCr,
                              TxCr    :  Byte;
                              CMode   :  Boolean;
                              ThisLink:  Pointer);

    procedure Display_Voucher(VMode   :  Byte;
                              VOMode  :  Boolean);

    procedure Display_Employee(VMode       :  Byte;
                               VOMode      :  Boolean);


    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;



  end;



{ ----------------------}



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




procedure TFJobDisplay.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  GenCanClose(Self,Sender,CanClose,BOn);
end;

procedure TFJobDisplay.FormDestroy(Sender: TObject);
begin
  If (JobRecForm<>Nil) then  {Free list here as if this form is closed by JATreeu, JobMain.FormClose never gets called}
    JobRecForm.ListFree;

end;

{ == Procedure to Send Message to Get Record == }

Procedure TFJobDisplay.Send_UpdateList(Edit   :  Boolean;
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


Procedure TFJobDisplay.WMCustGetRec(Var Message  :  TMessage);
Begin


  With Message do
  Begin


    Case WParam of

         1  :  ;

       232  :  Begin
                 JobActive:=Boff;

                 {$IFDEF JC}
                   JobRecForm:=nil;
                 {$ENDIF}

                 Send_UpDateList(BOff,36);
               end;

     200  :  Begin

               EmpActive:=Boff;

               {$IFDEF JC}
                 ShowEmpRec:=nil;
               {$ENDIF}

               Send_UpDateList(BOff,38);
             end;
     300  :  Begin

               VchActive:=Boff;

               {$IFDEF JC}
                 VchRecForm:=nil;
               {$ENDIF}

               Send_UpDateList(BOff,37);
             end;


    end; {Case..}

  end;
  Inherited;
end;


procedure TFJobDisplay.Display_Account(Mode    :  Byte;
                                       TJC     :  Str10;
                                       TJA     :  Str20;
                                       TCr,
                                       TxCr    :  Byte;
                                       CMode   :  Boolean;
                                       ThisLink:  Pointer);

Var
  FKey  :  Str255;

Begin
  {$IFDEF JC}

    TFJobACode:=TJA;
    TFJobCCode:=TJC;

    If (JobRecForm=nil) then
    Begin


      JobRecForm:=TJobRec.Create(Self);

    end
    else
      With JobRecForm do
      Begin

      end;

    Try


     JobActive:=BOn;

     With JobRecForm do
     Begin



       WindowState:=wsNormal;

       If (Mode<>50) then
         Show;

       If (Mode In [5,6,7,13..20]) then
       Begin
         DDMode:=Mode;
         Level_JACode:=TJA;
         Level_Cr:=TCr;
         Level_TxCr:=TxCr;
         Level_Commit:=CMode;
       end;

       If (Not ExLocal.InAddEdit) then
       Begin
         {* Re-establish file position *}

         FKey:=FullJobCode(JobRec^.JobCode);

         ExLocal.LGetMainRecPos(JobF,FKey);
         //SSK 15/12/2017 2018R1 ABSEXCH-19497: added to handle anonymisation behaviour for Job
         AnonymisationON := GDPROn and (Mode <> 50) and (JobRec^.jrAnonymised);
         ShowLink;
       end;


       If (Mode In [1..3]) and (Not ExLocal.InAddEdit) then
       Begin
         ChangePage(0);
       end
       else
         If (Mode In [5,6,7,13..20]) then
         Begin

           ChangePage(2);

         end
           else
             If (Mode In [11]) then
             Begin

             end;
     end; {With..}


    except

     JobActive:=BOff;

     JobRecForm.Free;

    end;

  {$ENDIF}
end;


procedure TFJobDisplay.Display_Voucher(VMode       :  Byte;
                                       VOMode      :  Boolean);
Var
  WasNew  :  Boolean;

Begin
  Begin
    If (VchRecForm=nil) then
    Begin
      SetCTMode:=JobDetl^.JobCISV.CISCType;

      VchRecForm:=TCISVoucher.Create(Self);

      WasNew:=BOn;
    end
    else
      WasNew:=BOff;

      try

      With VchRecForm do
      Begin
        ExLocal.AssignFromGlobal(JDetlF);

        VchActive:=BOn;

        If (WasNew) or (VOMode) then
        Case VMode of
          2,4:  EditLine((VMode In [2,4]),VOMode,JDLedgerK);
        end {Case..}
        else
          Show;
      end; {with..}

      except
        FreeandNil(VchRecForm);

      end;
  end;
end;


procedure TFJobDisplay.Display_Employee(VMode       :  Byte;
                                        VOMode      :  Boolean);
Var
  WasNew  :  Boolean;
Begin
  If (ShowEmpRec=nil) then
  Begin
    GlobPRateMode:=0;
    ShowEmpRec:=TJEmpRec.Create(Self);
    WasNew:=BOn;
  end
  else
  begin
    WasNew:=BOff;
    ShowEmpRec.ListScanningOn := True;
  end;

  try
    With ShowEmpRec do
    begin
      EmpActive:=BOn;
      WindowState:=wsNormal;
      CanDelete:=BOff;

      //SSK 22/02/2018 2018 R1 ABSEXCH-19778: Anonymisation
      ExLocal.AssignFromGlobal(JMiscF);
      AnonymisationON := GDPROn and (ExLocal.LJobMisc^.EmplRec.emAnonymisationStatus in [asPending, asAnonymised]);

      If (VMode=1) then
      begin
        With ExLocal do
        begin
          EditAccount(BOff);
          AssignFromGlobal(CustF);

          EMAccF.Text:=LCust.CustCode;
          EMTypF.ItemIndex:=1;
          LinkCF.Text:=LCust.CustCode;
          SupAcF.Text:=LCust.Company;
          LJobMisc^.EmplRec.Supplier:=LCust.CustCode;
          EAd1F.Text:=LCust.Addr[1];
          EAd2F.Text:=LCust.Addr[2];
          EAd3F.Text:=LCust.Addr[3];
          EAd4F.Text:=LCust.Addr[4];
          EAd5F.Text:=LCust.Addr[5];
          ETelF.Text:=LCust.Phone;
          EFaxF.Text:=LCust.Fax;
          EMobF.Text:=LCust.Phone2;
        end {With ExLocal..}
      end
      else
        ShowLink;
    end; {With ShowEmpRec..}
  except
    FreeandNil(ShowEmpRec);
  end;
end;



end.

unit CISVch2U;

{$I DEFOVr.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mask, TEditVal, bkgroup, BTSupU1,
  SalTxl1U, GlobVar,VarConst,ExWrap1U, SBSPanel;

Type

  TCISVoucher = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    SBSPanel1: TSBSPanel;
    Label81: Label8;
    Label86: Label8;
    Label82: Label8;
    Label85: Label8;
    Label87: Label8;
    Label88: Label8;
    Label89: Label8;
    EAD1F: Text8Pt;
    EAd2F: Text8Pt;
    EAD3F: Text8Pt;
    EAD4F: Text8Pt;
    EAD5F: Text8Pt;
    SNameF: Text8Pt;
    Label810: Label8;
    Card1F: Text8Pt;
    Card2F: Text8Pt;
    Label811: Label8;
    NIF: Text8Pt;
    BehalfF: Text8Pt;
    VNOF: Text8Pt;
    PayDF: TEditDate;
    Label812: Label8;
    GrossF: TCurrencyEdit;
    Label814: Label8;
    MatF: TCurrencyEdit;
    Label815: Label8;
    Label813: Label8;
    DedF: TCurrencyEdit;
    Label816: Label8;
    TaxF: TCurrencyEdit;
    ConRefF: Text8Pt;
    Label817: Label8;
    Label83: Label8;
    VerF: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure VNOFExit(Sender: TObject);

  private
    InOutId,
    IdStored,
    StopPageChange,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    Procedure OutId;

    procedure Form2Id;

    procedure SetCaption;

    procedure BuildDesign;

    Function ChkDupliCertNo(CISChk  :  Str255;
                            LKeypath:  Integer;
                            ChkMode :  Byte)  :  Boolean;

    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);

  public
    { Public declarations }

    ExLocal    :  TdExLocal;
    JTMode     :  Byte;

    procedure SetKeyFields(PayDate  :  LongDate);

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Field  :  TSBSPanel) ;


    procedure EditLine(Edit        :  Boolean;
                       ViewOnly    :  Boolean;
                       Keypath     :  Integer);


    procedure DeleteBOMLine(Fnum,
                            KeyPath  :  Integer);

  end;

Var
  SetCTMode  :  Byte;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  BorBtns,
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BtKeys1U,
  IntMU,
  BTSupU2,
  SBSComp2,
  CmpCtrlU,
  CurrncyU,
  ComnUnit,
  ComnU2,
  SysU2,
  ColCtrlU,
  CISSup1U,

  {$IFDEF Ltr}
    Letters,
  {$ENDIF}

  {$IFDEF FRM}
     DefProcU,
  {$ENDIF}

  InvListU,
  JobSup1U,
  JChkUseU;





{$R *.DFM}







procedure TCISVoucher.SetCaption;

Begin
  If (CurrentCountry=IECCode) then
    Caption:=CISVTypeName(JTMode)+' '+GetIntMsg(4)
  else
  Begin
    Caption:='CIS Statement';
  end;

end;

procedure TCISVoucher.BuildDesign;

Var
  n  :  Byte;

Begin
  Label810.Caption:=CISVTypeName(JTMode);


  If (CurrentCountry<>IECCode) then
  Begin
    Label86.Caption:='CRN';
    Label81.Caption:='Statement Ref.';
    Label87.Caption:='Tax Payment Statement';
    Label817.Caption:='Contractors Employers Ref. No.';

    Card2F.Visible:=Not CIS340;

    If (CIS340) then
    Begin
      //AP 11/01/2018 ABSEXCH-19630
      Card1F.Width:= NIF.Width;
      Label811.Caption:='UTR';
    end;  

    Label89.Visible:=(JTMode=6);
    Label88.Visible:=Label89.Visible;
    Label83.Visible:=CIS340;
    VerF.Visible:=CIS340;

    Case JTMode of
      5  :  Begin
              Label87.Caption:='Gross Tax Payment Statement';

            end;

      6  :  Begin
              Label87.Caption:='Subcontractor''s Gross Payment Voucher';
              Label87.Font.Size:=9;

              BehalfF.Top:=GrossF.Top;
              SNameF.Top:=NIF.Top;
              Label89.Caption:='certify that I am the holder of a Gross Payment Certificate which I have produced to';
              Label89.Height:=Label89.Height+12;

              With ConRefF do
              Begin
                Color:=clWindow;
                TabStop:=BOn;
                Tag:=1;
              end;
            end;
    end; {Case..}



    MatF.Visible:=(JTMode=4);

    Label811.Visible:=(JTMode<>5) or CIS340;
    NIF.Visible:=Label811.Visible;

    Label815.Visible:=MatF.Visible;
    Label813.Visible:=MatF.Visible;
    Label816.Visible:=MatF.Visible;
    DedF.Visible:=MatF.Visible;
    TaxF.Visible:=MatF.Visible;



  end
  else
  Begin
    Label82.Visible:=BOff;

    Label85.Caption:='Relevant Contract Tax';

    Case JTMode of
      5  :  Begin
              Label87.Caption:='Gross Payment Record';

              Label816.Visible:=BOff;
              TaxF.Visible:=BOff;
              Label86.Caption:='Sub-Contractor C2 No.';
            end;

      else  Begin
              Label87.Caption:='Deduction Certificate';
              Label89.Caption:='certify that the following deductions have been made with respect to';
              Label86.Visible:=BOff;
              Card1F.Visible:=BOff;
              Card2F.Visible:=BOff;
              Label811.Top:=Label86.Top;
              NIF.Top:=Card1F.Top;
              Label816.Top:=Label815.Top;
              TaxF.Top:=MatF.Top;
            end;
    end; {Case..}

    Label81.Caption:='Certificate No.';
    Label811.Caption:='RSI Tax / Ref No.';


    Label815.Visible:=BOff;
    Label813.Visible:=BOff;

    MatF.Visible:=BOff;
    DedF.Visible:=BOff;


  end;


  GrossF.CurrencySymb:=SSymb(Syss.VatCurr);
  MatF.CurrencySymb:=SSymb(Syss.VatCurr);
  DedF.CurrencySymb:=SSymb(Syss.VatCurr);
  TaxF.CurrencySymb:=SSymb(Syss.VatCurr);

end;



procedure TCISVoucher.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  ClientHeight:=395;
  ClientWidth:=573;

  InOutId:=BOff;

  JTMode:=SetCTMode;

  If (TForm(Owner).Name='CISVList') then
  With TForm(Owner) do
    Self.Left:=Left+2;


  SetCaption;
  
  BuildDesign;

end;




procedure TCISVoucher.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,200);

end;

procedure TCISVoucher.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TCISVoucher.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TCISVoucher.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TCISVoucher.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Procedure TCISVoucher.WMCustGetRec(Var Message  :  TMessage);



Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

     {$IFDEF FRM}
       170  :  With ExLocal.LJobDetl.JobCISV do
               Begin
                 Control_DefProcess(30,
                                     JDetlF,JDSTKK,
                                     CISCertKey(CISCertNo),
                                     ExLocal,
                                     BOn);
               end;

     {$ENDIF}

     171 :  Begin  {* Link for ObjectDrill *}
              ExLocal.AssignToGlobal(InvF);
            end;


    end; {Case..}

  end;
  Inherited;
end;



{ == Procedure to Send Message to Get Record == }

Procedure TCISVoucher.Send_UpdateList(Edit   :  Boolean;
                                  Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_CustGetRec;
    WParam:=Mode+100;
    LParam:=Ord(Edit);
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}



Function TCISVoucher.CheckNeedStore  :  Boolean;

Var
  Loop  :  Integer;

Begin
  Result:=BOff;
  Loop:=0;

  While (Loop<=Pred(ComponentCount)) and (Not Result) do
  Begin
    If (Components[Loop] is TMaskEdit) then
    With (Components[Loop] as TMaskEdit) do
    Begin
      Result:=((Tag=1) and (Modified));

      If (Result) then
        Modified:=BOff;
    end
    else
      If (Components[Loop] is TCurrencyEdit) then
      With (Components[Loop] as TCurrencyEdit) do
      Begin
        Result:=((Tag=1) and (FloatModified));

        If (Result) then
          FloatModified:=BOff;
      end
      else
        If (Components[Loop] is TBorCheck) then
        With (Components[Loop] as TBorCheck) do
        Begin
          Result:=((Tag=1) and (Modified));

          If (Result) then
            Modified:=BOff;
        end
        else
          If (Components[Loop] is TSBSComboBox) then
          With (Components[Loop] as TSBSComboBox) do
          Begin
            Result:=((Tag=1) and (Modified));

            If (Result) then
              Modified:=BOff;
          end;

    Inc(Loop);
  end; {While..}
end;


Procedure TCISVoucher.SetFieldFocus;

Begin
  VNoF.SetFocus;

end; {Proc..}





Function TCISVoucher.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin

  TmpBo:=BOff;

  If (ExLocal.InAddEdit) and (CheckNeedStore) and (Not ExLocal.LViewOnly) and (Not IdStored) then
  Begin

    mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes  :  Begin
                StoreId(JDetlF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(JDetlF,LastRecAddr[JDetlF]);

                TmpBo:=BOn;
              end;

    mrCancel
           :  Begin
                TmpBo:=BOff;
                SetfieldFocus;
              end;
  end; {Case..}


  ConfirmQuit:=TmpBo;
end; {Func..}




{ ============== Display Id Record ============ }

Procedure TCISVoucher.OutId;


Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

  n         :  Byte;

  KeyS      :  Str255;


Begin
  InOutId:=BOn;


  With ExLocal,LJobDetl^,JobCISV do
  Begin
    
    VNoF.Text:=Trim(CISCertNo);
    BehalfF.Text:=Syss.UserName;
    SNameF.Text:=CISBehalf;
    EAD1F.Text:=CISAddr[1];
    EAD2F.Text:=CISAddr[2];
    EAD3F.Text:=CISAddr[3];
    EAD4F.Text:=CISAddr[4];
    EAD5F.Text:=CISAddr[5];

    Card1F.Text:=Copy(CISVCert,1,5);
    Card2F.Text:=Copy(CISVCert,6,Length(CISVCert)-5);
    NIF.Text:=CISVNINo;

    VerF.Text:=CISVerNo;

    If (CIS340) then
    Begin
      If (CISHTax=1) then
        Label810.Caption:='High Tax'
      else
        Label810.Caption:='';

      Card1F.Text:=CISVCert;
      Card2F.Text:='';
    end;

    PayDf.DateValue:=Copy(CISVCode2,1,LDateKeyLen);
    GrossF.Value:=TruncGross(CISvGrossTotal);

    // CJS 2014-02-20 - ABSEXCH-11760 - CIS Return - Cost Of Materials rounding
    MatF.Value := TruncGross(CalcCISJDMaterial(LJobDetl^));

    DedF.Value:=TruncGross(CISTaxableTotal);
    TaxF.Value:=CISvTaxDue;

    If (JTMode<>6) then
      ConRefF.Text:=SyssCIS^.CISRates.CISTaxRef
    else
      ConRefF.Text:=CISAddr[5];
  end;

  InOutId:=BOff;

end;


procedure TCISVoucher.Form2Id;


Begin

  With ExLocal,LJobDetl^,JobCISV do
  Begin
    CISCertNo:=FullStockCode(VNoF.Text);
    CISBehalf:=SNameF.Text;

    CISAddr[1]:=EAD1F.Text;
    CISAddr[2]:=EAD2F.Text;
    CISAddr[3]:=EAD3F.Text;
    CISAddr[4]:=EAD4F.Text;

    If (JTMode<>6) then
      CISAddr[5]:=EAD5F.Text
    else
      CISAddr[5]:=ConRefF.Text;

    CISVCert:=Card1F.Text+Card2F.Text;
    CISVNINo:=NIF.Text;

    CISVerNo:=VerF.Text;

    CISvGrossTotal:=GrossF.Value;
    CISTaxableTotal:=DedF.Value;
    CISvTaxDue:=TaxF.Value;
  end; {with..}

end; {Proc..}


procedure TCISVoucher.SetIdStore(EnabFlag,
                                 VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  ExLocal.InAddEdit:=Not VOMode;

  OkCP1Btn.Enabled:=Not VOMode;

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is Text8Pt) then
    Begin
      If (Text8Pt(Components[Loop]).Tag=1) then
        Text8Pt(Components[Loop]).ReadOnly:= VOMode;
    end
      else
        If (Components[Loop] is TEditDate) then
        Begin
          If (TEditDate(Components[Loop]).Tag=1) then
            TEditDate(Components[Loop]).ReadOnly:= VOMode;
        end
        else
          If (Components[Loop] is TEditPeriod) then
          Begin
            If (TEditPeriod(Components[Loop]).Tag=1) then
              TEditPeriod(Components[Loop]).ReadOnly:= VOMode;
          end
          else
            If (Components[Loop] is TCurrencyEdit) then
            Begin
              If (TCurrencyEdit(Components[Loop]).Tag=1) then
                TCurrencyEdit(Components[Loop]).ReadOnly:= VOMode;
            end
            else
              If (Components[Loop] is TBorCheck) then
              Begin
                If (TBorCheck(Components[Loop]).Tag=1) then
                  TBorCheck(Components[Loop]).Enabled:= Not VOMode;
              end
              else
                If (Components[Loop] is TSBSComboBox) then
                Begin
                  If (TSBSComboBox(Components[Loop]).Tag=1) then
                    TSBSComboBox(Components[Loop]).ReadOnly:= VOMode;
              end;
  end; {Loop..}

end;




procedure TCISVoucher.VNOFExit(Sender: TObject);
Var
  COk   :  Boolean;
  CCode :  Str20;


begin

  If (Sender is TMaskEdit) and (ActiveControl<>CanCP1Btn) then
  With ExLocal,LJobMisc^,JobAnalRec,(Sender as TMaskEdit) do
  Begin
    Text:=UpcaseStr(Text);

    CCode:=FullStockCode(Text);

    COK:=BOn;


    If ((Not LastEdit) or (LastJobDetl^.JobCISV.CISCertNo<>CCode)) and (InAddEdit) then
    Begin

      If (COk) then
        COk:=(Not Check4DupliGen(CISCertKey(CCode),JDetlF,JdStkK,GetIntMsg(4)+' Number'));

      If (Not COk) then
      Begin

        SetFocus;
      end;

    end;
  end;
end;



{ == Set Key fields == }

procedure TCISVoucher.SetKeyFields(PayDate  :  LongDate);

Begin
  With ExLocal,LJobDetl^,JobCISV do
  begin
    With LJobMisc^.EmplRec, LCust do
    Begin
      CISVDateS:=PayDate+FullCustCode(CustCode)+ECISType2Key(CISCType);
      CISVSDate:=FullCustCode(CustCode)+PayDate;
      CISVCode1:=FullEmpKey(EmpCode)+PayDate;
      CISVCode2:=PayDate+FullEmpKey(EmpCode)+ECISType2Key(CISCType);
    end; {With..}
  end;

end;

(*  Add is used to add Notes *)

procedure TCISVoucher.ProcessId(Fnum,
                                Keypath     :  Integer;
                                Edit        :  Boolean);

Var
  KeyS     :  Str255;
  UseNext  :  LongInt;

  InvR     :  InvRec;


Begin

  Addch:=ResetKey;

  KeyS:='';

  ExLocal.InAddEdit:=BOn;

  ExLocal.LastEdit:=Edit;

  SKeypath:=Keypath;

  Blank(InvR,Sizeof(InvR));

  If (Edit) then
  Begin
    OutId;

    With ExLocal do
    Begin
      LGetRecAddr(Fnum);

      If (Not LViewOnly) then
        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked)
      else
        Ok:=BOn;


    end;

    If (Not Ok) or (Not GlobLocked) then
      AddCh:=Esc;
  end;


  If (Addch<>Esc) then
  With ExLocal,LJobDetl^,JobCISV do
  begin

    If (Not Edit) then
    Begin

      Prime_CISVoucher(LJobDetl^,LCust,LJobMisc^,InvR);

      SetKeyFields(SyssCIS^.CISRates.CurrPeriod);

        With SyssCIS^.CISRates.CISVouchers[CISCType] do
          CISCertNo:=FullStockCode(Prefix+IntToStr(Counter));
    end;

    LastJobDetl^:=LJobDetl^;

    OutId;

    SetIdStore(BOn,ExLocal.LViewOnly);


  end {If Abort..}
  else
    Close;

end; {Proc..}






{ == Check for duplicate Cert & Folio No. == }

Function TCISVoucher.ChkDupliCertNo(CISChk  :  Str255;
                                    LKeypath:  Integer;
                                    ChkMode :  Byte)  :  Boolean;

Const
  Fnum  =  JDetlF;

Var
  Keypath,
  TmpStat,
  TmpKPath : Integer;
  TmpRecAddr
           : LongInt;

  LJD      :  JobDetlRec;

  KeyChk,
  KeyS     :  Str255;

Begin
  Result:=BOff;

  With ExLocal do
  Begin
    LJD:=LJobDetl^;

    Case ChkMode of
      0  :  Keypath:=JDStkK;
      1  :  Keypath:=JDPostedK;
      else
        raise Exception.Create('Invalid ChkMode in TCISVoucher.ChkDupliCertNo: ' + IntToStr(ChkMode));
    end; {Case..}

    TmpKPath:=LKeypath;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    KeyChk:=CISPrefix+CISChk;
    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    Result:=(StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn));


    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

    LJobDetl^:=LJD;
  end;

end;


procedure TCISVoucher.StoreId(Fnum,
                          Keypath  :  Integer);

Var
  COk,
  ChkRN
       :  Boolean;

  TmpMLoc
       :  JobDetlRec;

  KeyN,OldCode:  Str255;

  KeyS :  Str255;

  mbRet:  Word;




Begin
  KeyS:='';

  Form2Id;


  ChkRN:=BOff;

  With ExLocal,LJobDetl^,JobCISV do
  Begin
    ChkRN:=(LastJobDetl^.JobCISV.CISCertNo<>CISCertNo);


    If (ChkRN) then
    Begin
      KeyS:=CISCertKey(CISCertNo);

      COk:=(Not Check4DupliGen(KeyS,Fnum,JDStkK,GetIntMsg(4)+' Number'));


    end
    else
      COk:=BOn;



    If (COk) or (Not LastEdit) then
    Begin


      If (LastEdit) then
      Begin

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpMLoc:=LJobDetl^;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LJobDetl^:=TmpMLoc;

        end;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end
      else
      Begin
        ChkRN:=BOn;

        If (GetMultiSys(BOn,ChkRN,CISR)) then
        With SyssCIS^.CISRates do
        Begin
          SetKeyFields(PayDF.DateValue);


          If (Not COK) then
          With CISVouchers[CISCType] do
          Begin
            Repeat
              CISCertNo:=FullStockCode(Prefix+IntToStr(Counter));

              Inc(Counter);

            Until (Not ChkDupliCertNo(CISCertNo,Keypath,0));
          end; {With..}

          Repeat
            CISFolio:=FullNomKey(CISVFolio)+HelpKStop;

            Inc(CISVFolio);
          Until (Not ChkDupliCertNo(CISFolio,KeyPath,1));

          PutMultiSys(CISR,BOn);

        end;

        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end;

      Report_BError(Fnum,Status);


      Cursor:=CrDefault;

      InAddEdit:=BOff;

      If (LastEdit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      IdStored:=BOn;

      Send_UpdateList(LastEdit,201);

      LastValueObj.UpdateAllLastValues(Self);

      Close;
    end
    else
      SetFieldFocus;

  end; {With..}


end;


procedure TCISVoucher.SetFieldProperties(Field  :  TSBSPanel) ;

Var
  n  : Integer;


Begin
  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TComboBox)
     or (Components[n] is TCurrencyEdit) then
    With TGlobControl(Components[n]) do
      If (Tag>0) then
      Begin
        Font.Assign(Field.Font);
        Color:=Field.Color;
      end;


  end; {Loop..}


end;


procedure TCISVoucher.EditLine(Edit,
                               ViewOnly    :  Boolean;
                               Keypath     :  Integer);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;
    LViewOnly:=ViewOnly;

    {If (Not Edit) then
    With PayDF do
    Begin
      Color:=clWindow;
      TabStop:=BOn;
      Tag:=1;
    end; Do not allow edit of date, must match current period, or Add PIN will not find transactions}

    ProcessId(JDetlF,Keypath,LastEdit);
  end;
end;


procedure TCISVoucher.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
      if OkCP1Btn.CanFocus then
        OkCP1Btn.SetFocus;
      if (ActiveControl = OkCP1Btn) then
        StoreId(JDetlF,SKeypath);
    end
    else
      If (ModalResult=mrCancel) then
      Begin

        Begin
          Close;
          Exit;
        end;
      end;
  end; {With..}

end;


procedure TCISVoucher.DeleteBOMLine(Fnum,
                                  KeyPath  :  Integer);

Var
  MbRet  :  Word;
  GotRec :  Integer;
  KeyS   :  Str255;

Begin
  With ExLocal do
  Begin
    AssignFromGlobal(Fnum);
    LGetRecAddr(Fnum);
    OutId;
    OKCP1Btn.Enabled:=BOff;
    CanCP1Btn.Enabled:=BOff;

    MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this record',
                       mtConfirmation,[mbYes,mbNo],0);

    If (MbRet=MrYes) then
    Begin
      Status:=LGetDirectRec(Fnum,KeyPath);

      If (StatusOk) then
      Begin

        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,GlobLocked);

        If (Ok) and (GlobLocked) then
        Begin

          Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

          Report_BError(Fnum,Status);
        end;


        If (StatusOk) then
        With LJobDetl^.JobCISV do
        Begin
          {* Delete Notes and links and matching? *}

          {$IFDEF Ltr}
            { Delete any letters/Links }
            DeleteLetters (LetterCISCode, CISFolio);
          {$ENDIF}

          Send_UpdateList(BOff,203);


        end;
      end; {If line is valid for deletion..}
    end
    else
      Report_BError(Fnum,Status);
  end; {With..}

  Close;
end; {PRoc..}






Initialization

  SetCTMode:=4;

end.

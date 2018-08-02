unit StkSNRRU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, Gauges,  BTSupU1, GlobVar, VarConst,
  BTSupU3,SBSComp2,ExWrap1U;

type

  TSNRRunFrm = class(TForm)
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



      KeyV       :  TModalResult;

      Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

      procedure ShutDown;

      Function Build_SRKey(NextNo    :  LongInt)  :  Str255;

      Procedure Add_SNRange;

    public
      { Public declarations }
        SMode,
        SPS,SPE        :  Byte;
        SNRange,
        SNAdded,
        SNCount,
        SFolio,
        SNS,SNE        :  LongInt;

        SNStart,SNEnd  :  Str20;

        SerialReq      :  ^Double;
        DocCostP       :  Double;
        UseMode        :  Boolean;

        ExLocal        :  TdExLocal;


  end;

  Function SNRTit(Mode  :  Byte)  :  Str30;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  BtrvU2,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU2,
  BTSupU2,
  StkSerNU,
  GenWarnU,
  Warn1U,
  SysU1;




{$R *.DFM}



Function SNRTit(Mode  :  Byte)  :  Str30;
Begin
  If (Mode=1) then
    Result:='Batch'
  else
    Result:='Serial';
end;


procedure TSNRRunFrm.CanCP1BtnClick(Sender: TObject);
begin
  KeyV:=mrAbort;

  Loop_CheckKey(KeepRun,KeyV);

  If (Not KeepRun) then
    CanCp1Btn.Enabled:=BOff;
end;


Procedure TSNRRunFrm.WMCustGetRec(Var Message  :  TMessage);

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




procedure TSNRRunFrm.ShutDown;

Begin
  PostMessage(Self.Handle,WM_Close,0,0);
end;



Function TSNRRunFrm.Build_SRKey(NextNo    :  LongInt)  :  Str255;


Begin
  Result:=UpCaseStr(Copy(SNStart,1,Pred(SPS))+SetPadNo(Form_Int(NextNo,0),Succ(SPE-SPS))+Copy(SNStart,Succ(SPE),Length(SNStart)-SPE));
end;


{ ======= Procedure to run the picking list ====== }

Procedure TSNRRunFrm.Add_SNRange;

Const
  SKLen  :  Array[0..1] of byte = (SNoKeyLen,BNoKeyLen);

Var
  NewKey         :  Str255;


  Loop,
  Ok2Store       :  Boolean;


Begin

  Loop:=(SMode=1);

  Label1.Caption:=#13+'Please Wait. Generating '+SNRTit(SMode)+' records';

  Repeat

    SNCount:=0; SNAdded:=0; KeepRun:=BOn;

    
    While (KeepRun) and (SNCount<SNRange) do
    With MiscRecs^,SerialRec do
    Begin

      Loop_CheckKey(KeepRun,KeyV);


      NewKey:=LJVar(Build_SRKey(SNS+SNCount),SKLen[SMode]);

      Inc(SNCount);

      If (SMode=0) then {* Check in advance for duplicates *}
      Begin
        Ok2Store:=Not CheckSNoExsists(MFIFOCode,MSERNSub,SFolio,NewKey);
      end
      else
        Ok2Store:=BOn;

      If (Ok2Store) then {* Add new record *}
      Begin
        If (Loop) then
        Begin
          ResetRec(MiscF);

          Subtype:=MSERNSub;

          RecMfix:=MFIFOCode;

          StkFolio:=SFolio;

          If (UseMode) then
          With ExLocal do
          Begin
            SERN_SetLink(LInv,LId,InDoc,InOrdDoc,BuyLine,InOrdLine,InMLoc);

            CurCost:=LInv.Currency;

            SerCost:=DocCostP;

            InBinCode:=LStock.BinLoc;

            SerCRates:=LInv.CXRate;
            SerTriR:=LInv.CurrTriR;

            If (SerCRates[BOff]=0.0) then
            Begin
              SerCRates[BOff]:=SyssCurr^.Currencies[CurCost].CRates[BOff];
              SetTriRec(CurCost,SUseORate,SerTriR);
            end;

            With LId do
            If (Not EmptyKey(JobCode,JobKeyLen)) and (Not EmptyKey(AnalCode,AnalKeyLen)) and (Not (IdDocHed In StkAdjSplit)) then {Force serial to be out as well}
            Begin
              OutDoc:=InDoc; OutOrdDoc:=InOrdDoc;
              OutOrdLine:=InOrdLine;
              SoldLine:=BuyLine;

              DateOut:=LId.PDate;

              CurSell:=CurCost;
              SerSell:=SerCost;


              OutMLoc:=InMLoc;

            end;

          end;


          If (SMode=0) then
            SerialNo:=NewKey
          else
          Begin
            BatchNo:=NewKey;
            BuyQty:=1.0;
            SerialNo:=LJVar('',SNoKeyLen);
            BatchRec:=BOn;
          end;

          

          SerialCode:=MakeSNKey(StkFolio,Sold,SerialNo);

          Sold:=(((Not EmptyKey(OutDoc,DocKeyLen)) and (Not BatchRec)) or
                ((BuyQty-QtyUsed<=0) and (BatchRec))) ;


          Status:=Add_Rec(F[MiscF],MiscF,RecPtr[MiscF]^,0);

          Report_Berror(MiscF,Status);
        end;

        Inc(SNAdded);

      end;


    end;

    Loop:=Not Loop;

    If (Loop) and (SNCount<>SNAdded) then {* Prompt if we should continue *}
    Begin
      If (SNAdded>0) then
      Begin
        KeepRun:=(CustomDlg(Application.MainForm,'Confirmation','Duplicate records.',Form_Int(SNCount-SNAdded,0)+' '+SNRTit(SMode)+
                        ' record(s) are duplicate.'+#13+#13+
                        'Do you wish to continue adding the rest?',
                         mtConfirmation,
                         [mbYes,mbNo])=mrOk);
      end
      else
      Begin
        ShowMessage('That entire range is duplicated. No new records will be added.');
        KeepRun:=BOff;
      end;

      If (Not KeepRun) then
      Begin
        Loop:=BOff; SNCount:=0; SNAdded:=0;

      end;
    end;

  Until (Not Loop) or (Not KeepRun);

  If (UseMode) then
    SerialReq^:=SerialReq^-SNAdded;
end; {Proc..}




procedure TSNRRunFrm.FormCreate(Sender: TObject);
begin
  ClientHeight:=129;
  ClientWidth:=299;

  Left:=Round((Screen.Width/2)-(Width/2));
  Top:=Round((Screen.Height/2)-(Height/2));

  KeepRun:=BOn;

  Running:=BOff;

  SNAdded:=0;
end;





procedure TSNRRunFrm.FormActivate(Sender: TObject);
begin
  If (Not Running) then
  Begin
    Running:=BOn;

    Add_SNRange;

    ShutDown;
  end;


end;

end.

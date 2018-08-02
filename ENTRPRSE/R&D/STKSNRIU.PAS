unit StkSNRIU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, Animate, ExtCtrls, SBSPanel, StdCtrls, bkgroup, BTSupU3,
  BorBtns, Mask, TEditVal,
  GlobVar,VarConst,ExWrap1U;


type
  TSerRangeFrm = class(TRepInpMsg)
    Label83: Label8;
    ACFF: Text8Pt;
    ACTF: Text8Pt;
    Label81: Label8;
    BorRadio1: TBorRadio;
    BorRadio2: TBorRadio;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
  private
    { Private declarations }
    PrevHState
             :  Boolean;

    Function Calc_Range(SStart,SEnd  :  Str20;
                    Var SRS,SRE      :  LongInt;
                    Var SPS,SPE      :  Byte)  :  LongInt;


  public
    { Public declarations }
    SMode     :   Byte;
    InUSeMode :   Boolean;
    StkFolio  :   LongInt;
    SerReqPtr :   Pointer;
    DocPCost  :   Double;

    ExLocal   :  TdExLocal;

  end;



procedure Start_SNRange(DMode   :  Byte;
                        SFolio  :  LongInt;
                        DocCost :  Double;
                        UseMode :  Boolean;
                        SExLocal:  TdExLocal;
                        PSerReq :  Pointer;
                        AOwner  :  TComponent);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  RPDefine,
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BTKeys1U,
  SysU2,
  BTSupU1,
  BTSupU2,
  ComnUnit,
  GenWarnU,
  StkSNRRU,
  Exthrd2U;



{$R *.DFM}







procedure TSerRangeFrm.FormCreate(Sender: TObject);


begin
  inherited;

  ClientHeight:=183;
  ClientWidth:=299;

  PrevHState:=BOff;

  
end;



{ ======== Devine how the serial number is made up =======}

Function TSerRangeFrm.Calc_Range(SStart,SEnd  :  Str20;
                             Var SRS,SRE      :  LongInt;
                             Var SPS,SPE      :  Byte)  :  LongInt;

Var
  n,nl   :  Byte;

  GetS   :  Boolean;


Begin
  Result:=0;

  nl:=Length(SStart);

  SPS:=0; SPE:=0; GetS:=BOn; SRS:=0; SRE:=0;


  If (nl=Length(SEnd)) then
  Begin

    For n:=1 to nl do
    Begin
      If (GetS) and (SStart[n] In ['0'..'9']) and (SStart[n]<>SEnd[n]) then
      Begin
        GetS:=BOff;
        SPS:=n;

      end
      else
        If (Not GetS) and (Not (SStart[n] In ['0'..'9'])) and (SStart[n]=SEnd[n]) then
        Begin
          SPE:=Pred(n);
          Break;
        end;

    end; {Loop..}

    If (SPS=0) then
      SPS:=1;

    If (SPE=0) then
      SPE:=nl;

    SRS:=IntStr(Copy(SStart,SPS,Succ(SPE-SPS)));
    SRE:=IntStr(Copy(SEnd,SPS,Succ(SPE-SPS)));

    Result:=Succ(SRE-SRS);
  end;

end;




procedure TSerRangeFrm.ACFFExit(Sender: TObject);
begin
  inherited;

  If (Sender is Text8Pt) then
    With Sender as Text8pt do
    Begin
      Text:=UpcaseStr(Text);

    end;
end;


procedure TSerRangeFrm.OkCP1BtnClick(Sender: TObject);

Var
  RSPS,RSPE      :  Byte;
  RSNRange,
  RSNS,RSNE      :  LongInt;

  mbRet          :  Word;

  MsgForm        :  TSNRRunFrm;

begin
  If (Sender=OkCP1Btn) then
  Begin
    ACFF.Text:=UpCaseStr(ACFF.Text);
    ACTF.Text:=UpCaseStr(ACTF.Text);

    If (Length(ACFF.Text)<>Length(ACTF.Text)) and (IntStr(ACFF.Text)>0) and (IntStr(ACTF.Text)>0) then
    Begin
      If (Length(ACFF.Text)>Length(ACTF.Text)) then
        ACTF.Text:=SetPadNo(ACTF.Text,Length(ACFF.Text))
      else
        ACFF.Text:=SetPadNo(ACFF.Text,Length(ACTF.Text));
    end;

    SMode:=Ord(BorRadio2.Checked);

    RSNRange:=Calc_Range(ACFF.Text,ACTF.Text,RSNS,RSNE,RSPS,RSPE);

    If (RSNRange>0) then
    Begin

      Set_BackThreadMVisible(BOn);

      mbRet:=CustomDlg(Application.MainForm,'Confirmation','Add a range of '+SNRTit(SMode)+' records.',
                 'Please confirm you wish to generate '+Form_Int(RSNRange,0)+' '+SNRTit(SMode)+' records'+
                 ' ('+ACFF.Text+' to '+ACTF.Text+')'+
                 #13+#13+
                 'If duplicate records exist within this range, they will not be added.',
                 mtConfirmation,
                 [mbYes,mbNo]);

      Set_BackThreadMVisible(BOff);

      If (mbRet=mrOk) then
      Begin
        MsgForm:=TSNRRunFrm.Create(Self);

        try
          With MsgForm do
          Begin
            SPS:=RSPS; SPE:=RSPE;
            SNRange:=RSNRange;
            SNS:=RSNS; SNE:=RSNE;

            SMode:=Self.SMode;
            
            SNStart:=ACFF.Text; SNEnd:=ACTF.Text;
            SFolio:=Self.StkFolio;
            DocCostP:=Self.DocPCost;
            UseMode:=InUseMode;
            Caption:=Self.Caption;
            ExLocal:=Self.ExLocal;

            SerialReq:=SerReqPtr;

            SetAllowHotKey(BOff,PrevHState);

            Set_BackThreadMVisible(BOn);

            ShowModal;

            Set_BackThreadMVisible(BOff);

            SetAllowHotKey(BOn,PrevHState);

            {* Refresh Qty required & Update lost *}

            Send_UpdateList(119);

            If (SNAdded<>SNCount) then
            Begin
              Set_BackThreadMVisible(BOn);

              CustomDlg(Application.MainForm,'Warning!','Add a range of '+SNRTit(SMode)+' records.',
                         Form_Int(SNAdded,0)+' '+SNRTit(SMode)+' record(s) were added.'+
                         #13+#13+
                         'The rest were duplicate records.',
                         mtWarning,
                         [mbOK]);

              Set_BackThreadMVisible(BOff);


            end;

          end;

        Finally



          MsgForm.Free;
        end; {try..}

        inherited;

      end;
    end
    else
    Begin
      Set_BackThreadMVisible(BOn);

      ShowMessage('That range is not valid.');

      Set_BackThreadMVisible(BOff);
    end;
  end
  else
    inherited;

end;


procedure Start_SNRange(DMode   :  Byte;
                        SFolio  :  LongInt;
                        DocCost :  Double;
                        UseMode :  Boolean;
                        SExLocal:  TdExLocal;
                        PSerReq :  Pointer;
                        AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TSerRangeFrm;

  Begin
    RepInpMsg1:=TSerRangeFrm.Create(AOwner);

    try
      With RepInpMsg1 do
      Begin
        SMode:=0;
        StkFolio:=SFolio;
        DocPCost:=DocCost;
        InUseMode:=UseMode;
        SerReqPtr:=PSerReq;
        ExLocal:=SExLocal;

        Caption:='Generate range of Serial/Batch records.';
      end;

    except
      RepInpMsg1.Free;

    end; {try..}

  end;




end.

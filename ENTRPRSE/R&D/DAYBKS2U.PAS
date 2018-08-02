unit Daybks2u;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mask,ExtCtrls, StdCtrls, TEditVal,SBSPanel,
  GlobVar,VarConst,ExWrap1U,BTSupU1;

type


  TDTotThread = class(TThread)
  private
    fKeyChk  :  Str255;
    fKeyLen,
    fCurrency,
    fMode,
    fTHMode  :  Byte;

    Display  :  Array[1..4] of TCurrencyEdit;

    TotAged  :  Totals;

    ExLocal  :  TdMTExLocalPtr;

    procedure SetTotals;

    procedure OutTotals;

  protected

    procedure Execute; override;

  public

    constructor Create(KeyChk  :  Str255;
                       KeyLen,
                       Mode,
                       THMode,
                       Currency
                               :  Byte;
                       TC1,TC2,TC3,TC4
                               :  TCurrencyEdit);

    Destructor Destroy; override;

    procedure CleanUp;

    procedure Set_Currency(NC  :  Byte);

    Function WaitforTerminate  :  Boolean;


  private

    ExecuteOff  :  Boolean;

    Procedure DayBook_Scan;

  end;


  TDBkTotals = class(TForm)
    Tot1F: TCurrencyEdit;
    Tot3F: TCurrencyEdit;
    Tot2F: TCurrencyEdit;
    Tot4F: TCurrencyEdit;
    CurrFLab: Label8;
    CurrF: TSBSComboBox;
    CanCP1Btn: TButton;
    Tot1Lab: Label8;
    Tot2Lab: Label8;
    Tot3Lab: Label8;
    Tot4Lab: Label8;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;


    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CurrFChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }

    InReset     :  Boolean;

    fLastCurr   :  Integer;

    fKeyChk     :  Str255;
    fKeyLen,
    fTHMode,
    fMode       :  Byte;

    ShowTotals  :  TDTotThread;


    procedure FormDesign;

    procedure SetFieldProperties(Panel  :  TSBSPanel);

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure ResetTotals;

  public
    { Public declarations }


    procedure SetKey(KeyChk  :  Str255;
                     KeyLen  :  Byte);

    procedure CalcTotals;

  end;

Var
  DTMode  :  Byte;
  DTType  :  DocTypes;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BtKeys1U,

  
  BTSupU2,
  CurrncyU,
  ComnUnit,
  ComnU2,
  CmpCtrlU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  DayBk2;

{$R *.DFM}



{ TDTotThread }

constructor TDTotThread.Create(KeyChk  :  Str255;
                               KeyLen,
                               Mode,
                               THMode,
                               Currency
                                       :  Byte;
                               TC1,TC2,TC3,TC4
                                       :  TCurrencyEdit);

begin
  

  FreeOnTerminate := BOff;
  fKeyChk:=KeyChk;
  fKeyLen:=KeyLen;
  fMode:=Mode;
  fTHMode:=THMode;
  fCurrency:=Currency;

  Display[1]:=TC1;
  Display[2]:=TC2;
  Display[3]:=TC3;
  Display[4]:=TC4;

  ExecuteOff:=BOff;

  FillChar(Totaged,Sizeof(TotAged),0);

  New(ExLocal,Create(02+fTHMode+(3*Pred(fMode))));

  try
    With ExLocal^ do
    Begin
      {Create(02+fTHMode+(3*Pred(fMode)));}

      Open_System(InvF,InvF);

    end;
  except
    ShowMessage('Unable to create Daybook Totals Btrieve thread');

  end;

  inherited Create(True);

  Priority:=tpNormal;

  Resume;
end;

Destructor TDTotThread.Destroy;

Begin
  {ExLocal.Destroy;}

  Inherited Destroy;
end;


procedure TDTotThread.CleanUp;

Begin
  Dispose(ExLocal,Destroy);

  {ExLocal.Destroy;}
end;


procedure TDTotThread.Set_Currency(NC  :  Byte);

Begin
  If (NC<>fCurrency) then
    fCurrency:=NC;
end;

Function TDTotThread.WaitforTerminate  :  Boolean;

Var
  n       :  Integer;

  TmpBo   :  Boolean;

Begin
  n:=0;

  Repeat

    Inc(n);

    Application.ProcessMessages;

    TmpBo:=((Terminated) and (ExecuteOff));

  Until (TmpBo) or (n>99999);

  Result:=TmpBo;
end;


procedure TDTotThread.SetTotals;
Var
  n  :  Byte;
begin
  For n:=1 to 4 do
    Display[n].Value:=TotAged[n];

end;

procedure TDTotThread.OutTotals;
begin
  Synchronize(SetTotals);
end;

{ The Execute method is called when the thread starts }

procedure TDTotThread.Execute;
begin
  ExecuteOff:=BOff;

  try
    DayBook_Scan;
  finally
    ExecuteOff:=BOn;
  end;
  
end;


Procedure TDTotThread.DayBook_Scan;


Const
  Fnum     =  InvF;
  Keypath  =  InvRNoK;


Var
  UOR     :  Byte;
  KeyS    :  Str255;

  NoStop  :  Boolean;

  RecAddr :  LongInt;

  TKeyPath:  Integer;


  OrdToday,
  NetTot,
  VATTot  :  Real;


Begin

  OrdToday:=0.0; UOR:=0;

  Blank(TotAged,Sizeof(Totaged));

  NoStop:=Not Terminated;

  KeyS:=fKeyChk;

  With ExLocal^ do
  Begin
    LStatus:=Find_RecCId(B_GetGEq,LocalF^[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS,ExClientId);

    While (LStatusOk) and (CheckKey(fKeyChk,KeyS,fKeyLen,BOn)) and (NoStop) and (Not Terminated) do
    With LInv do
    Begin
      {* Keep position *}
      LGetRecAddr(Fnum);

      NoStop:=Not Terminated;

      If ((Currency=fCurrency) or (fCurrency=0)) and (NoStop) then
      Begin

        If (fCurrency<>0) then
        Begin
          If (Not (InvDocHed In OrderSet)) then
          Begin
            NetTot:=(ITotal(LInv)-InvVAT);
            VATTot:=InvVAT;
          end
          else
          Begin
            NetTot:=TotOrdOS;
            OrdToday:=(ITotal(LInv)-InvVAT);
            VATTot:=0;
          end;
        end
        else
        Begin

          If (Not (InvDocHed In OrderSet)) then
          Begin
            NetTot:=ConvCurrINet(LInv,BOff,BOn);

            UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

            VATTot:=Conv_TCurr(InvVAT,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);
          end
          else
          Begin
            UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

            NetTot:=Conv_TCurr(TotOrdOS,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff);

            OrdToday:=Conv_TCurr(ITotal(LInv)-InvVAT,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff);

            VATTot:=0;
          end;

        end;

        If (Not (InvDocHed In PSOPSet)) then
        Begin

          NetTot:=NetTot*DocCnst[InvDocHed]*DocNotCnst;

          VATTot:=VATTot*DocCnst[InvDocHed]*DocNotCnst;

        end;


        If (InvDocHed In RecieptSet) then
          TotAged[1]:=TotAged[1]+NetTot
        else
          If (InvDocHed In DirectSet) then
          Begin

            TotAged[1]:=TotAged[1]+(NetTot+VATTot)*DocNotCnst;
            TotAged[2]:=TotAged[2]+NetTot;
            TotAged[3]:=TotAged[3]+VATTot;

          end
          else
            If (InvDocHed In DeliverSet) then
            Begin
              TotAged[1]:=TotAged[1]+NetTot;

              If (TransDate=Today) then
                TotAged[4]:=TotAged[4]+NetTot;
            end
            else
              If (InvDocHed In OrderSet) then
              Begin
                TotAged[2]:=TotAged[2]+NetTot;

                If (TransDate=Today) then
                  TotAged[3]:=TotAged[3]+OrdToday;
              end
              else
                If (Not (InvDocHed In QuotesSet)) then
                Begin

                  TotAged[2]:=TotAged[2]+NetTot;
                  TotAged[3]:=TotAged[3]+VATTot;

                end;

      end; {If Right Currency}

      If (fMode=1) then
        Totaged[4]:=Totaged[2]+Totaged[3];

      OutTotals;

      {* Restore position *}

      TKeyPath:=KeyPath;

      LStatus:=LPresrv_BTPos(Fnum,TKeypath,F[Fnum],LastRecAddr[Fnum],BOn,BOff);

      LStatus:=Find_RecCId(B_GetNext,LocalF^[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS,ExClientId);

    end;

  end; {With..}


end; {Proc..}


{ ======================================================================================= }



procedure TDBkTotals.FormDesign;

Begin
  {$IFNDEF MC_On}

    CurrFLab.Visible:=BOff;
    CurrF.Visible:=BOff;
    CurrF.ItemIndex:=0;

  {$ELSE}

    Set_DefaultCurr(CurrF.Items,BOn,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOn,BOn);

  {$ENDIF}

  If (Owner is TDayBk1) then
    With TDayBk1(Owner) do
    Begin
      SetFieldProperties(db1ORefPanel);
      Self.Left:=((Left+Width)-Self.Width)-10;
      Self.Top:=((Top+Height)-Self.Height)-10;
    end;

  If (fMode=2) then
  Begin
    Tot1Lab.Caption:='Delivery Notes';
    Tot2Lab.Caption:='O/S Order Value';
    Tot3Lab.Caption:='Ordered Today';
    Tot4Lab.Caption:='Delivered Today';
  end
  else
    Tot3Lab.Caption:=CCVATName^+Tot3Lab.Caption;

end;


procedure TDBkTotals.FormCreate(Sender: TObject);
begin
  ClientHeight:=89;
  ClientWidth:=433;

  fMode:=DTMode;
  fTHMode:=GetDocGroup(DTType);

  FormDesign;
  CurrF.ItemIndex:=0;

  fLastCurr:=0;

  InReset:=BOff;
  
  ShowTotals:=nil;

  If (fMode=2) then
    Caption:='Order '+Caption;

  Caption:=DocGroup[fTHMode]+' '+Caption;

  Tot1F.Value:=0.0;
  Tot2F.Value:=0.0;
  Tot3F.Value:=0.0;
  Tot4F.Value:=0.0;


end;

procedure TDBkTotals.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  Send_UpdateList(46);
end;

procedure TDBkTotals.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=CaFree;

  If (ShowTotals<>nil) then
  With ShowTotals do
  Begin
    Terminate;

    WaitForTerminate;

    If (Not ExecuteOff) then
      Suspend;

    ShowTotals.CleanUp;
    Freeandnil(ShowTotals);

  end;
end;



procedure TDBkTotals.SetFieldProperties(Panel  :  TSBSPanel);

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
        Font.Assign(Panel.Font);
        Color:=Panel.Color;
      end;

  end; {Loop..}


end;


procedure TDBkTotals.SetKey(KeyChk  :  Str255;
                            KeyLen  :  Byte);


Begin
  fKeyChk:=KeyChk;
  fKeyLen:=KeyLen;
end;


procedure TDBkTotals.CalcTotals;

Var
  UseCurr  :  Integer;

Begin
  {$IFDEF MC_On}

    UseCurr:=CurrF.ItemIndex;

  {$ELSE}

    UseCurr:=0;


  {$ENDIF}

  If (ShowTotals=nil) then
    ShowTotals:=TDTotThread.Create(fKeyChk,fKeyLen,fMode,fTHMode,UseCurr,Tot1F,Tot2F,Tot3F,Tot4F);

end;



procedure TDBkTotals.ResetTotals;

Var
  n  :  Integer;

Begin
  InReset:=BOn;

  If (ShowTotals<>nil) and (fLastCurr<>CurrF.ItemIndex) then
  With ShowTotals do
  Begin
    Terminate;

    If (WaitForTerminate) then
    Begin
      If (Not ExecuteOff) then
        ShowTotals.Suspend;
        
      ShowTotals.CleanUp;
      ShowTotals.Free;
      ShowTotals:=nil;
      CalcTotals;
      fLastCurr:=CurrF.ItemIndex;
    end
    else
      If (Debug) then
        ShowMessage('Not aborted correctly')
      else
        MessageBeep(0);
  end;

  InReset:=BOff;

end;



procedure TDBkTotals.CanCP1BtnClick(Sender: TObject);
begin
  Close;
end;

{ == Procedure to Send Message to Get Record == }

Procedure TDBkTotals.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_FormCloseMsg;
    WParam:=Mode;
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}



procedure TDBkTotals.CurrFChange(Sender: TObject);
begin
  If (Not InReset) then
    ResetTotals;
end;



procedure TDBkTotals.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TDBkTotals.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


end.

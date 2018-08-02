unit RepInp1U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, Gauges,  BTSupU1, Mask,
  BTSupU3,SBSComp2, bkgroup, Animate, ComCtrls;

{* Parent form from which all other report input boxes descend *}
{List
  RepInp2U     Payments Due Report
  RepInp3U     Aging Report
  RepInp4U     Statement run
  RepInp5U     Debt Chase Letters
  RepInp6U     Posting Report
  RepInp7U     Daybook Report
  RepInp8U     Bank Rec
  RepInp9U     G/L History
  RepInpAU     G/L Based, TB, P&L etc
  RepInpBU     CC/Dep analysis
  RepInpCU     Sales Analysis Report
  RepInpDU     Price List
  RepInpEU     UK VAT Return
  RepInpFU     EC Sales List
  RepInpGU     Stock Sales by Product
  RepInpHU     Stock Reconciliation/Valuation Report
  RepInpJU     Stock Take Report
  RepInpKU     Stock Valuation & Aging routine
  RepInpLU     Stock History Report
  RepInpMU     Trial Kitting Report
  RepInpNU     Sales Back Order Report
  RepInpOU     Stock Shortages Report
  RepInpPU     Print a Range of Documents
  RepInpQU     Batch Payment Report
  RepInpRU     Stock Bin Report
  RepInpTU     Print Stock Labels
  RepInpVU     Irish VAT Return
  RepInpWU     NZ VAT Return
  RepInpXU     Works Order Main Reports
  RepInpYU     Works Order WIP Report.
  RepIRT1U     Returns Report
  ReportRV     Revaluation report


  JC
  RepIJCAU     Job Detailed analysis Report
  RepIJCBU     Job Budget analysis
  RepIJCEU     Employee List
  RepIJCHU     Job History Report
  RepIJCIU     Job Billing Report
  RepIJCWU     Job WIP Report
  RepIJCXU     Customer Exposure Report
  RepICI1U     Sub contract list & Continuous employment report
  RepICI2U     CIS Vouchers, single or run
  RepICI3U     CIS EOY
  RepIJCPU     Applications analysis and due report

}

type

  TRepInpMsg = class(TForm)
    OkCP1Btn: TButton;
    ClsCP1Btn: TButton;
    SBSPanel4: TSBSBackGroup;
    SBSPanel1: TSBSPanel;
    Animated1: TAnimated;
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);

  private
    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;
  protected
    Function AutoExitValidation : Boolean;
  public
    { Public declarations }
    KeyR        :  TModalResult;

    Procedure Send_UpdateList(Mode   :  Integer);
    procedure SetLastValues;
    procedure ShutDown;
  end;

  Function RepInpConvInpPr(Const IDate  :  String; Const Date2Pr  :  Boolean)  : String;

  Function RepInpPPr_Pr(Const EPr  :  Byte)  : String;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  GlobVar,
  VarConst,
  ComnU2,
  Event1U,
  BTSupU2;

{$R *.DFM}

Function TRepInpMsg.AutoExitValidation : Boolean;
Var
  oControl : TControl;
  iControl : SmallInt;
Begin // AutoExitValidation
  // MH 01/11/2010 v6.5 ABSEXCH-10434: Have to check visible state as EL creates DelvInpU.Pas and clicks the OK button from the FormCreate
  If Visible Then
  Begin
    If (ActiveControl <> OKCP1Btn) Then
    Begin
      // Move focus to OK button to force any OnExit validation to occur
      OKCP1Btn.SetFocus;
    End; // If (ActiveControl <> OKCP1Btn)

    Result := (ActiveControl = OKCP1Btn);

    // Check we are still on the OK button - validation failure will have changed the focus
    If Result Then
    Begin
      // Run through controls on the form forcing validation
      For iControl := 0 To ControlCount - 1 Do
      Begin
        oControl := Controls[iControl];

        If oControl.Visible and oControl.Enabled And
           (oControl Is TEdit) Or
           (oControl Is TMaskEdit) Or
           (oControl Is TCurrencyEdit) Or
           (oControl Is TEditDate) Or
           (oControl Is Text8Pt) Or
           (oControl Is TSBSComboBox) Or
           (oControl Is TEditPeriod) Then
        Begin
          // Set Focus to control
          If TWinControl(oControl).CanFocus Then TWinControl(oControl).SetFocus;

          // Move focus to OK button to trigger any OnExit validation
          OKCP1Btn.SetFocus;

          // If focus is still on the OK button then it validated OK
          Result := (ActiveControl = OKCP1Btn);
          If (Not Result) Then
            Break;
        End; // If oControl.Visible and oControl.Enabled And ...
      End; // For iControl
    End; // If Result
  End // If Visible
  Else
    Result := True;
End; // AutoExitValidation


procedure TRepInpMsg.OkCP1BtnClick(Sender: TObject);

Var
  mbRet  :  Word;

begin
  OKCP1Btn.Enabled:=BOff;
  
  LastValueObj.UpdateAllLastValuesFull(Self);


  ShutDown;
end;


Procedure TRepInpMsg.WMCustGetRec(Var Message  :  TMessage);

Begin
  With Message do
  Begin


    Case WParam of

      0
         :  Begin

            end;


    end; {Case..}

  end; {With..}

  Inherited;

end;



Procedure TRepInpMsg.Send_UpdateList(Mode   :  Integer);

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

procedure TRepInpMsg.ShutDown;

Begin
  LastValueObj.UpdateAllLastValues(Self);
  PostMessage(Self.Handle,WM_Close,0,0);
end;


procedure TRepInpMsg.FormCreate(Sender: TObject);

Var
  BMap1       :  TBitMap;

  RectD       :  TRect;

begin

  {BMap1:=TBitMap.Create;

  try

    BMap1.Handle:=LoadBitMap(HInstance,'ENTLOG_1');

    With BMap1 do
      RectD:=Rect(0,0,Width,Height);


    With Image1.Picture.Bitmap do
    Begin
      Width:=BMap1.Width;
      Height:=BMap1.Height;                    data

      Canvas.Brush.Color:=clBtnFace;
      Canvas.BrushCopy(RectD,BMap1,RectD,clWhite);
    end;
  finally
    BMap1.Free;

  end; {try..}

  {With Image1 do
  Begin
    Top:=(SBSPanel4.Top+SBSPanel4.Height)-(Height+5);
    Left:=(SBSPanel4.Left+SBSPanel4.Width)-(Width+5);
  end;}

  With SBSPanel1 do
  Begin
    Top:=(SBSPanel4.Top+SBSPanel4.Height)-(Height+2);
    Left:=(SBSPanel4.Left+SBSPanel4.Width)-(Width+2);
  end;

  With Animated1 do
  Begin
    Visible:=BOff; Play:=BOff;
  end;

  MDI_SetFormCoord(TForm(Self));

  SetLastValues;

end;


procedure TRepInpMsg.SetLastValues;

Begin
  LastValueObj.GetAllLastValuesFull(Self);
end;

procedure TRepInpMsg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;


procedure TRepInpMsg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TRepInpMsg.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Func to Convert period to date == }

Function RepInpConvInpPr(Const IDate  :  String; Const Date2Pr  :  Boolean)  : String;

Begin
  Result:=ConvInpPr(IDate,Date2Pr,Nil);
end;


{ == Func to Convert period to month == }

Function RepInpPPr_Pr(Const EPr  :  Byte)  : String;

Begin
  Result:=PPr_Pr(EPr);
end;

end.

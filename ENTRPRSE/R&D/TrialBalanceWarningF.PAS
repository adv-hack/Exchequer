unit TrialBalanceWarningF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, Buttons, BorBtns;


Const
  TrialBalanceWarningHelpContext = 40160;

type
  TfrmTrialBalanceWarning = class(TForm)
    SBSPanel1: TSBSPanel;
    OkCP1Btn: TButton;
    Label81: Label8;
    Label82: Label8;
    SBSPanel2: TSBSPanel;
    CLMsgL: Label8;
    Label86: Label8;
    Image1: TImage;
    Label83: Label8;
    CanCP1Btn: TButton;
    SBSPanel3: TSBSPanel;
    Label84: Label8;
    cb1: TBorCheckEx;
    Label85: Label8;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure cb1Click(Sender: TObject);
  private
    { Private declarations }
    Focus2    :  Boolean;
  public
    { Public declarations }
  end;


// Returns TRUE if the Trial Balance should be reported as out of balance
Function IsTrialBalanceBorked (Const TrialBalanceAmount : Double) : Boolean;

// Calculates the Trial Balance value for a GL Code
Function CalcGLTrialBalanceAmount (Const GLCode : LongInt;
                                   Const GLType : Char;
                                   Const TheCurrency : Byte = 0;
                                   Const ThePeriod : Byte = 99;
                                   Const TheYear : Byte = 150) : Double;

// Performs a basic check on the GL History and returns TRUE if it balances
Function IsTrialBalanceOK (Var TBErrorAmount : Double) : Boolean;

// Displays the Trial Balance warning dialog and returns TRUE if the user elects to continue
Function DisplayTrialBalanceWarning (Const ParentForm : TForm; Const TrialBalanceAmount : Double) : Boolean;

Implementation


Uses
  GlobVar,
  VarConst,
  BtrvU2,
  BTSupU1,
  BTSupU2,
  ExThrd2U,
  ETMiscU,
  BTKeys1U,
  SalTxl1U,
  SavePos;

{$R *.DFM}


//=========================================================================

// Returns TRUE if the Trial Balance should be reported as out of balance
Function IsTrialBalanceBorked (Const TrialBalanceAmount : Double) : Boolean;
Begin // IsTrialBalanceBorked
  Result := (ABS(TrialBalanceAmount) >= 1.0);
End; // IsTrialBalanceBorked

//-------------------------------------------------------------------------

// Calculates the Trial Balance value for a GL Code
Function CalcGLTrialBalanceAmount (Const GLCode : LongInt;
                                   Const GLType : Char;
                                   Const TheCurrency : Byte = 0;
                                   Const ThePeriod : Byte = 99;
                                   Const TheYear : Byte = 150) : Double;
Var
  Purch, Sales, Cleared : Double;
Begin // CalcGLTrialBalanceAmount
  Purch := 0.0;
  Sales := 0.0;
  Cleared := 0.0;
  Result := Round_Up (Profit_To_Date (GLType, FullNomKey(GLCode), TheCurrency, TheYear, ThePeriod, Purch, Sales, Cleared, BOn), 2);

//If (GLCode = 40) Then Result := -94;
End; // CalcGLTrialBalanceAmount

//-------------------------------------------------------------------------

// Performs a basic check on the GL History and returns TRUE if it balances
Function IsTrialBalanceOK (Var TBErrorAmount : Double) : Boolean;
Var
  KeyS : Str255;
  iStatus : SmallInt;
Begin // IsTrialBalanceOK
  TBErrorAmount := 0.0;

  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the file for the current key
      SaveFilePosition (NomF, GetPosKey);
      SaveDataBlock (@Nom, SizeOf(Nom));

      //------------------------------

      // Run through the root GL Codes - sum should be 0
      KeyS := FullNomKey(0);
      iStatus := Find_Rec(B_GetGEq, F[NomF], NomF, RecPtr[NomF]^, NomCatK, KeyS);
      While (iStatus = 0) And (Nom.Cat = 0) Do
      Begin
        TBErrorAmount := Round_Up(TBErrorAmount + CalcGLTrialBalanceAmount (Nom.NomCode, Nom.NomType), 2);

        iStatus := Find_Rec(B_GetNext, F[NomF], NomF, RecPtr[NomF]^, NomCatK, KeyS);
      End; // While (iStatus = 0) And (Nom.Cat = 0)

      //------------------------------

      // Restore position in file
      RestoreDataBlock (@Nom);
      RestoreSavedPosition;
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create

  Result := Not IsTrialBalanceBorked(TBErrorAmount);
End; // IsTrialBalanceOK

//=========================================================================

// Displays the Trial Balance warning dialog and returns TRUE if the user elects to continue
Function DisplayTrialBalanceWarning (Const ParentForm : TForm; Const TrialBalanceAmount : Double) : Boolean;
Begin // DisplayTrialBalanceWarning
  With TfrmTrialBalanceWarning.Create(ParentForm) Do
  Begin
    Try
      HelpContext := TrialBalanceWarningHelpContext;

      Label83.Caption := 'The Trial Balance has a difference of ' + FormatCurFloat(GenRealMask, TrialBalanceAmount, BOff, 0) + #13#13 +

                         'It is strongly recommended that the difference be corrected as a matter of urgency.' + #13#13 +

                         'Press F1 for more details on how to correct this position.' + #13#13 +

                         'Alternatively, please contact your Exchequer support provider for further assistance';

      Result := (ShowModal = mrOK);
    Finally
      Free;
    End; // Try..Finally
  End; // With TfrmTrialBalanceWarning.Create(ParentForm)
End; // DisplayTrialBalanceWarning

//=========================================================================

Procedure TfrmTrialBalanceWarning.FormCreate(Sender: TObject);
Const
  ExClamName  :  Array[TMsgDlgType] of PChar = ('EXCLAM_2','EXCLAM_3','INFO_1','EXQMARK_1','EXQMARK_2');
Var
  BMap1       :  TBitMap;
  RectD       :  TRect;
begin
  ClientHeight:=419;
  ClientWidth:=275;

  If Not NoXLogo then
  Begin
    BMap1:=TBitMap.Create;
    Try
      BMap1.Handle:=LoadBitMap(HInstance,ExClamName[mtWarning]);

      RectD := Rect(0, 0, BMap1.Width, BMap1.Height);

      With Image1.Picture.Bitmap do
      Begin
        Width := BMap1.Width;
        Height := BMap1.Height;

        Canvas.Brush.Color := clBtnFace;
        Canvas.BrushCopy(RectD,BMap1,RectD,clSilver);
      end;
    Finally
      BMap1.Free;
    End; // Try..Finally
  end;{If..}
end;

procedure TfrmTrialBalanceWarning.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TfrmTrialBalanceWarning.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TfrmTrialBalanceWarning.cb1Click(Sender: TObject);
begin
  OkCP1Btn.Enabled:=cb1.Checked;
end;

end.

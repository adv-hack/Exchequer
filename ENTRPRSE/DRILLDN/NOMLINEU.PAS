unit NomLineU;

{$ALIGN 1}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, SBSPanel,

  GlobVar,VarConst,ExWrap1U, ExtCtrls, bkgroup;


type
  TNTLine = class(TForm)
    Label87: Label8;
    Label81: Label8;
    CCLab: Label8;
    DepLab: Label8;
    JCLab: Label8;
    JALab: Label8;
    UDF1L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    UDF3L: Label8;
    CurrLab: Label8;
    I1ExLab: Label8;
    SBSBackGroup1: TSBSBackGroup;
    Label83: Label8;
    Label82: Label8;
    VATLab: Label8;
    VATCLab: Label8;
    Label88: Label8;
    Bevel1: TBevel;
    NTLDF: Text8Pt;
    NTNAF: Text8Pt;
    NTNDF: Text8Pt;
    NTCCF: Text8Pt;
    NTDepF: Text8Pt;
    Candb1Btn: TButton;
    NTJCF: Text8Pt;
    NTJAF: Text8Pt;
    THUD1F: Text8Pt;
    THUD2F: Text8Pt;
    THUD4F: Text8Pt;
    THUD3F: Text8Pt;
    NTCurrF: TSBSComboBox;
    NTExRF: TCurrencyEdit;
    NTJDF: Text8Pt;
    NTDAmtF: TCurrencyEdit;
    NTCAmtF: TCurrencyEdit;
    NTIOCB: TSBSComboBox;
    NTVATCF: TSBSComboBox;
    NTVATF: TCurrencyEdit;
    THUD5F: Text8Pt;
    UDF5L: Label8;
    UDF6L: Label8;
    UDF7L: Label8;
    UDF8L: Label8;
    UDF9L: Label8;
    UDF10L: Label8;
    THUD9F: Text8Pt;
    THUD10F: Text8Pt;
    THUD8F: Text8Pt;
    THUD7F: Text8Pt;
    THUD6F: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Candb1BtnClick(Sender: TObject);
  private
    { Private declarations }
    procedure FormDesign;

    procedure SetIdStore(VOMode  :  Boolean);

    Procedure OutId;


    Function NTRight(Amount  :  Real)  :  TCurrencyEdit;

    procedure WMWindowPosChanged(var Msg : TMessage); Message WM_WindowPosChanged;


  public
    { Public declarations }
    LInv       : InvRec;
    LId        : IDetail;
    LDescLines : Array[2..6] Of String[60];
    LNom       : NominalRec;
    LJobRec    : JobRecType;

    procedure SetFieldProperties(Panel  :  TSBSPanel;
                                 Field  :  Text8Pt) ;

    procedure DisplayNomId (Const TheInv : InvRec; Const TheId : IDetail);
  end;




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
  BTSupU1,
  BTSupU2,
  CurrncyU,
  SBSComp2,
  VarRec2U,
  ComnUnit,
  ComnU2,
  EntLicence,     // Global Exchequer Licence object
  EntData,        // Global Exchequer Data object
  ColCtrlU,
  CmpCtrlU,
  SysU3,
  MiscU,

  NomtfrU,
  CustomFieldsIntF;


{$R *.DFM}


//=========================================================================

procedure TNTLine.FormCreate(Sender: TObject);
begin
  ClientHeight:=356;
  ClientWidth:=614;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TNTxfrForm) then
    With TNTxfrForm(Owner) do
      Self.SetFieldProperties(N1DPanel,N1YRefF);

  FormDesign;
end;

//------------------------------

procedure TNTLine.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

//------------------------------

procedure TNTLine.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

//------------------------------

procedure TNTLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;

  SendMessage ((Owner As TForm).Handle, WM_CustGetRec, 100, 1);
end;

//-------------------------------------------------------------------------

{ ========== Build runtime view ======== }
procedure TNTLine.FormDesign;
Var
  HideCC  :  Boolean;
  VisibleFieldCount: Integer;
begin

  {* Set Version Specific Info *}

  If (EnterpriseLicence.elCurrencyVersion = cvPro) Then Begin
    // IFNDEF MC_On
    CurrLab.Visible:=BOff;
    NTCurrF.Visible:=BOff;
    NTExRF.Visible:=BOff;
    I1ExLab.Visible:=BOff;
  End { If }
  Else Begin
    Set_DefaultCurr(NTCurrF.Items,BOff,BOff);
    Set_DefaultCurr(NTCurrF.ItemsL,BOff,BOn);
  End; { Else }

  NTIOCB.ItemsL.Assign(NTIOCB.Items);

  HideCC:=Not Syss.UseCCDep;
  NTCCF.Visible:=Not HideCC;
  NTDepF.Visible:=Not HideCC;

  CCLab.Visible:=NTCCF.Visible;
  DepLab.Visible:=NTCCF.Visible;

  Build_DefaultCVAT(NTVATCF.Items,BOn,BOn,BOff,BOff);
  Build_DefaultCVAT(NTVATCF.ItemsL,BOn,BOn,BOff,BOn);
  VATCLab.Caption:=CCVATName^+VATCLab.Caption;
  VATLab.Caption:=CCVATName^;
  Label88.Caption:=CCVATName^+Label88.Caption;

  If (Not JBCostOn) then
  Begin
    NTJCF.Visible:=BOff;
    NTJAF.Visible:=BOff;
    JCLab.Visible:=BOff;
    JALab.Visible:=BOff;
  end;

  If (Not UseCoDayRate) then
  With NTExRF do
  Begin
    Tag:=0;
    Color:=clWindow;
    TabStop:=BOff;
    Enabled:=BOff;

  end;

  //GS 17/11/2011 ABSEXCH-12037: modifed UDF settings code to use the new "CustomFieldsIntF" unit
  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F], cfNOMLine, True);

  VisibleFieldCount := NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]);
  ResizeUDFParentContainer(VisibleFieldCount, 5, self, 40);
  ResizeUDFParentContainer(VisibleFieldCount, 5, Candb1Btn, 40);

  NTLDF.MaxLength:=DocDesLen;
end;


procedure TNTLine.Candb1BtnClick(Sender: TObject);
begin
  Close;
end;


procedure TNTLine.SetIdStore(VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin
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


{ ============== Display Id Record ============ }

Procedure TNTLine.OutId;
Begin
  With LId do
  Begin
    NTLDF.Text:=Desc;
    NTNAF.Text:=Form_BInt(NomCode,0);

    NTCCF.Text:=CCDep[BOn];
    NTDepF.Text:=CCDep[BOff];

    If (EnterpriseLicence.elCurrencyVersion In [cvEuro, cvGlobal]) Then Begin
      // IFDEF MC_On
      If (Currency>0) then
        NTCurrF.ItemIndex:=Pred(Currency);

      NTExRF.Value:=CXRate[UseCoDayRate];
    End; { If (EnterpriseLicence.elCurrencyVersion In [cvEuro, cvGlobal]) }

    NTRight(NetValue).Value:=ABS(NetValue);


    NTJCF.Text:=Strip('R',[#32],JobCode);
    NTJAF.Text:=Strip('R',[#32],AnalCode);

    {$B-}
      If (NTJCF.Text<>'') Then
        NTJDF.Text:=LJobRec.JobDesc
      else
        NTJDF.Text:='';
    {$B+}

    //FoundOk:=GetNom(Self,NTNAF.Text,FoundLong,-1);

    NTNDF.Text:=LNom.Desc;

    THUd1F.Text:=LineUser1;
    THUd2F.Text:=LineUser2;
    THUd3F.Text:=LineUser3;
    THUd4F.Text:=LineUser4;
    //GS 17/11/2011 ABSEXCH-12037: put customisation values into text boxes
    THUd5F.Text:=LineUser5;
    THUd6F.Text:=LineUser6;
    THUd7F.Text:=LineUser7;
    THUd8F.Text:=LineUser8;
    THUd9F.Text:=LineUser9;
    THUd10F.Text:=LineUser10;

    If (VATCode In VATSet) then
      NTVATCF.ItemIndex:=GetVATIndex(VATCode)
    else
      NTVATCF.ItemIndex:=-1;

    NTVATF.Value:=VAT;

    NTIOCB.ItemIndex:=NOMIOFlg;
  end;

end;


procedure TNTLine.SetFieldProperties(Panel  :  TSBSPanel;
                                     Field  :  Text8Pt) ;
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

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do
      Begin
        CheckColor:=Field.Color;
        Color:=Panel.Color;
      end;

  end; {Loop..}


end;



{ ================= Function Return if input should be a debit / Credit ========= }

Function TNTLine.NTRight(Amount  :  Real)  :  TCurrencyEdit;

Begin
  If (Amount<0) then
    NTRight:=NTCAMTF
  else
    NTRight:=NTDAmtF;
end;


//-------------------------------------------------------------------------

procedure TNTLine.DisplayNomId (Const TheInv : InvRec; Const TheId : IDetail);
Var
  lStatus : SmallInt;
  KeyS    : Str255;
Begin { DisplayNomId }
  LInv := TheInv;
  LID := TheId;

  // Get any additional description lines
  FillChar (LDescLines, SizeOf (LDescLines), #0);

  // Get nominal record
  KeyS := FullNomKey(LID.NomCode);
  LStatus := Find_Rec (B_GetEq, F[NomF], NomF, RecPtr[NomF]^, NomCodeK, KeyS);
  If (LStatus = 0) Then
    LNom := Nom
  Else
    FillChar(LNom, SizeOf(LNom), #0);

  // Get job record
  KeyS := FullJobCode(LID.JobCode);
  LStatus := Find_Rec (B_GetEq, F[JobF], JobF, RecPtr[JobF]^, JobCodeK, KeyS);
  If (LStatus = 0) Then
    LJobRec := JobRec^
  Else
    FillChar(LJobRec, SizeOf(LJobRec), #0);

  // Set Descriptive Caption
  Caption := EnterpriseData.edCompanyCode + ', ' + LInv.OurRef + ' Transaction Line';

  // Set all fields to read-only
  SetIdStore (True);

  // Display Fields
  OutId;

  // Show the form
  Show;
End; { DisplayNomId }

//-------------------------------------------------------------------------

// IMPORTANT NOTE: This message handler is required to ensure the form stays
// on top, as it has a habit of losing its Stay-On-Top'ness at runtime.
procedure TNTLine.WMWindowPosChanged(var Msg : TMessage);
Var
  TopWindow : TWinControl;
Begin
  // Do standard message processing
  Inherited;

  // HM 22/10/03: Added Visible check as it hangs under win 98 otherwise
  If Self.Visible Then
  Begin
    // Check to see if the TopMost window is a Drill-Down window
    TopWindow := FindControl(PWindowPos(Msg.LParam).hwndInsertAfter);
    If Not Assigned(TopWindow) Then
      // Restore TopMost back to window
      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE);
  End; // If Self.Visible
End;

//-------------------------------------------------------------------------



end.

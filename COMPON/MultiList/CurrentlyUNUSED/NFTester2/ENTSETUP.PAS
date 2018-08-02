unit EntSetup;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UseDLLU, StdCtrls, ExtCtrls, BtrvU2, VarConst, APIUtil, DLLProc;

{$I EXCHDLL.INC}

type
  TfrmEnterpriseSetup = class(TForm)
    edCardNom: TEdit;
    Label4: TLabel;
    lCardNomDesc: TLabel;
    Label1: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label2: TLabel;
    edCashNom: TEdit;
    lCashNomDesc: TLabel;
    Label5: TLabel;
    edCorrectionNom: TEdit;
    lCorrectionNomDesc: TLabel;
    Label7: TLabel;
    edForfeitNom: TEdit;
    lForfeitNomDesc: TLabel;
    Label9: TLabel;
    edDiscountNom: TEdit;
    lDiscountNomDesc: TLabel;
    Label11: TLabel;
    edTillDepositNom: TEdit;
    lTillDepositNomDesc: TLabel;
    lCCDept: TLabel;
    lCostCentre: TLabel;
    edCostCentre: TEdit;
    lDepartment: TLabel;
    edDepartment: TEdit;
    btnOK: TButton;
    Label3: TLabel;
    edSalesNom: TEdit;
    lSalesNomDesc: TLabel;
    lCC: TLabel;
    lDept: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure NominalExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CCDeptExit(Sender: TObject);
  private
    bShowMessages : boolean;
  public
    { Public declarations }
  end;
{
var
  frmEnterpriseSetup: TfrmEnterpriseSetup;}

implementation

{$R *.DFM}

procedure TfrmEnterpriseSetup.btnOKClick(Sender: TObject);
begin
  close;
end;

procedure TfrmEnterpriseSetup.NominalExit(Sender: TObject);
var
  sGLDesc, sNom : string;
  iCode, iNom : integer;

  function GetGLDesc(iNom : integer) : string;
  var
    GLCodeRec : TBatchNomRec;
    pKey : PChar;
    iStatus : SmallInt;
  begin
    pKey := StrAlloc(255);
    StrPCopy(pKey, IntToStr(iNom));
    iStatus := EX_GETGLACCOUNT(@GLCodeRec, SizeOf(GLCodeRec),pKey,0,B_GetEq,FALSE);
    if iStatus = 0 then Result := GLCodeRec.Desc
    else Result := '';
{      if (iStatus <> 4) then ShowTKError('EX_GETGLACCOUNT', 44, iStatus);}
{    end;{if}
    StrDispose(pKey);
  end;{GetGLDesc}

begin
  sNom := TEdit(Sender).Text;
  Val(TEdit(Sender).Text, iNom, iCode);
{  if DoGetNom(Self, sCurrCompPath, sNom, iNom, [nomProfitAndLoss, nomBalanceSheet], vmShowList, TRUE)
  then TEdit(Sender).Text := IntToStr(iNom)
  else ActiveControl := TWinControl(Sender);}

  sGLDesc := GetGLDesc(iNom);
  if (Trim(sGLDesc) = '') then TEdit(Sender).Text := '';

  if (Trim(sGLDesc) = '') and (ActiveControl <> btnOK) and bShowMessages then begin
    MsgBox('You have entered an invalid GL Code.',mtWarning,[mbOK],mbOK,'Invalid GL Code');
    ActiveControl := TWinControl(Sender);
  end;

  case TWinControl(Sender).Tag of
    NOM_CARD : lCardNomDesc.Caption := sGLDesc;
    NOM_CASH : lCashNomDesc.Caption := sGLDesc;
    NOM_CORRECTION : lCorrectionNomDesc.Caption := sGLDesc;
    NOM_FORFEIT : lForfeitNomDesc.Caption := sGLDesc;
    NOM_DISCOUNT : lDiscountNomDesc.Caption := sGLDesc;
    NOM_TILL_DEPOSIT : lTillDepositNomDesc.Caption := sGLDesc;
    NOM_SALES : lSalesNomDesc.Caption := sGLDesc;
  end;{case}
end;

procedure TfrmEnterpriseSetup.FormShow(Sender: TObject);
begin
  bShowMessages := FALSE;
  NominalExit(edCardNom);
  NominalExit(edCashNom);
  NominalExit(edCorrectionNom);
  NominalExit(edForfeitNom);
  NominalExit(edDiscountNom);
  NominalExit(edTillDepositNom);
  NominalExit(edSalesNom);
  CCDeptExit(edCostCentre);
  CCDeptExit(edDepartment);
  bShowMessages := TRUE;

  lCCDept.Enabled := oDll.TKSysRec.CCDepts;
  lCC.Enabled := oDll.TKSysRec.CCDepts;
  lDept.Enabled := oDll.TKSysRec.CCDepts;
  lCostCentre.Enabled := oDll.TKSysRec.CCDepts;
  lDepartment.Enabled := oDll.TKSysRec.CCDepts;
  edCostCentre.Enabled := oDll.TKSysRec.CCDepts;
  edDepartment.Enabled := oDll.TKSysRec.CCDepts;
end;

procedure TfrmEnterpriseSetup.CCDeptExit(Sender: TObject);
Var
  ExStat  :  Integer;
  pCode      :  PChar;
  sDesc, sCCDept : string;
  MyCCDep        :  TBatchCCDEpRec;

begin
  pCode := StrAlloc (255);
  StrPCopy(pCode, TEdit(Sender).Text);
  ExStat := Ex_GetCCDep(@MyCCDep,SizeOf(MyCCDep),pCode,0,B_GetEq,TEdit(Sender).Tag - 1,False);

  case TEdit(Sender).Tag of
    1 : sCCDept := 'Cost Centre';
    2 : sCCDept := 'Department';
  end;{case}

  with MyCCDep do begin
    If (ExStat = 0) then sDesc := CCDepDesc
    else begin
      if bShowMessages and (ActiveControl <> btnOK) then begin
        MsgBox('You have entered an invalid ' + sCCDept + '.',mtWarning,[mbOK],mbOK,'Invalid ' + sCCDept);
        ActiveControl := TWinControl(Sender);
      end;{if}
    end;{if}
  end;{with}

  case TEdit(Sender).Tag of
    1 : lCC.Caption := sDesc;
    2 : lDept.Caption := sDesc;
  end;{case}

  StrDispose (pCode);

end; {proc..}

end.

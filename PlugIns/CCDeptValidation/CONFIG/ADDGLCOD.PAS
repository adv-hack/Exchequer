unit AddGLCod;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , TKPickList, Enterprise01_TLB, StdCtrls, ExtCtrls, BTFile, uExDatasets;

type
  TFrmAddGLCode = class(TForm)
    Label3: TLabel;
    edGLCode: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    btnCCWC: TButton;
    Shape1: TShape;
    btnFindGLCode: TButton;
    lGLName: TLabel;
    procedure btnCCWCClick(Sender: TObject);
    procedure edGLCodeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnFindGLCodeClick(Sender: TObject);
  private
    bGLOK : boolean;
    procedure EnableDisable;
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

procedure TFrmAddGLCode.btnCCWCClick(Sender: TObject);
begin
  edGLCode.Text := sGL_WILDCARD;
end;

procedure TFrmAddGLCode.edGLCodeChange(Sender: TObject);
begin
  with oToolkit.GeneralLedger do begin
    Index := glIdxCode;
    if (GetEqual(BuildCodeIndex(StrToIntDef(edGLCode.text, 0))) = 0)
    and (glType in [glTypeProfitLoss, glTypeBalanceSheet]) then
    begin
      lGLName.Caption := glName;
      bGLOK := TRUE;
    end else
    begin
      lGLName.Caption := '';
      bGLOK := FALSE;
    end;
    EnableDisable;
  end;{with}
end;

procedure TFrmAddGLCode.FormCreate(Sender: TObject);
begin
  bGLOK := FALSE;
end;

procedure TFrmAddGLCode.btnFindGLCodeClick(Sender: TObject);
var
  oGLCode : IGeneralLedger;
  iGLCode : integer;
begin
  with TfrmTKPickList.CreateWith(self, oToolkit) do begin
    mlList.Columns[0].DataType := dtInteger;
    plType := plGLCode;
    iGLCode := StrToIntDef(edGLCode.Text,0);

    if (iGLCode = 0) and (edGLCode.Text <> '0') then
      begin
        sFind := edGLCode.Text;
        iSearchCol := 1;
      end
    else begin
      sFind := mlList.FullNomKey(iGLCode);
      iSearchCol := 0;
    end;{if}
    mlList.Columns[1].IndexNo := 1;

//    sFind := edGLCode.Text;
    if showmodal = mrOK then begin
      oGLCode := ctkDataSet.GetRecord as IGeneralLedger;
      edGLCode.Text := IntToStr(oGLCode.glCode);
    end;
    release;
  end;{with}
end;

procedure TFrmAddGLCode.EnableDisable;
begin
  btnOk.enabled := bGLOK or (edGLCode.Text = sGL_WILDCARD);
end;

end.

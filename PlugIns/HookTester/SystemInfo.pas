unit SystemInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CustAbsU, StdCtrls, ExtCtrls, Grids, ValEdit, StrUtil, Menus;

type
  TfrmSystem = class(TForm)
    vlProperties: TValueListEditor;
    Panel1: TPanel;
    btnClose: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    procedure FillProperties;
  public
    LSystem : TAbsEnterpriseSystem04;
  end;

var
  frmSystem: TfrmSystem;

implementation
uses
  MathUtil;
{$R *.dfm}


procedure TfrmSystem.FillProperties;
begin
  with LSystem do begin
    vlProperties.Values['AcStkAnalOn'] := BooleanToStr(AcStkAnalOn);
    vlProperties.Values['BoResult'] := BooleanToStr(BoResult);
    vlProperties.Values['ClassVersion'] := ClassVersion;
    vlProperties.Values['CurrencyVer'] := IntToStr(CurrencyVer);
    vlProperties.Values['DblResult'] := FloatToStr(DblResult);
    vlProperties.Values['EBusinessOn'] := BooleanToStr(EBusinessOn);
    vlProperties.Values['HandlerId'] := IntToStr(HandlerId);
    vlProperties.Values['InEditMode'] := BooleanToStr(InEditMode);
    vlProperties.Values['IntResult'] := IntToStr(IntResult);
    vlProperties.Values['JobCostOn'] := BooleanToStr(JobCostOn);
    vlProperties.Values['PaperlessOn'] := BooleanToStr(PaperlessOn);
//vlProperties.Values['RepWrtOn'] := BooleanToStr(RepWrtOn);
    vlProperties.Values['TelesalesOn'] := BooleanToStr(TelesalesOn);
    vlProperties.Values['UserName'] := UserName;
    vlProperties.Values['ValidStatus'] := BooleanToStr(ValidStatus);
    vlProperties.Values['VarResult'] := VarResult;
    vlProperties.Values['WinId'] := IntToStr(WinId);
  end;{with}
end;

procedure TfrmSystem.FormShow(Sender: TObject);
begin
  FillProperties;
end;

procedure TfrmSystem.btnCloseClick(Sender: TObject);
begin
  close;
end;

end.

unit frmRptTreePropertiesU;
{
  Displays the details of a Report Tree node.
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RptEngDLL, StdCtrls, Mask, TEditVal, TCustom;

type
  TfrmRptTreeProperties = class(TForm)
    lblRepName: Label8;
    edtRepName: Text8Pt;
    lblRepDesc: Label8;
    lblParentName: Label8;
    edtParentName: Text8Pt;
    edtFileName: Text8Pt;
    lblFileName: Label8;
    memRepDesc: TMemo;
    btnOk: TSBSButton;
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Init(VRWRec: TVRWReportDataRec; FontColour, BackColour: TColor);
  end;

var
  frmRptTreeProperties: TfrmRptTreeProperties;

implementation

{$R *.dfm}

{ TfrmRptTreeProperties }

procedure TfrmRptTreeProperties.Init(VRWRec: TVRWReportDataRec;
  FontColour, BackColour: TColor);
begin
  edtRepName.Color := BackColour;
  edtRepName.Font.Color := FontColour;
  memRepDesc.Color := BackColour;
  memRepDesc.Font.Color := FontColour;
  edtParentName.Color := BackColour;
  edtParentName.Font.Color := FontColour;
  edtFileName.Color := BackColour;
  edtFileName.Font.Color := FontColour;
  case VRWRec.rtNodeType of
    'H':  // Folder/group heading
      begin
        edtRepName.Text       := VRWRec.rtRepName;
        memRepDesc.Lines.Text := VRWRec.rtRepDesc;
        if (Trim(VRWRec.rtParentName) = '') then
          edtParentName.Text  := 'REPORTS'
        else
          edtParentName.Text  := VRWRec.rtParentName;
        edtFileName.Text      := '';
        edtFileName.Color     := clBtnFace;
      end;
    'R':  // Report
      begin
        edtRepName.Text       := VRWRec.rtRepName;
        memRepDesc.Lines.Text := VRWRec.rtRepDesc;
        if (Trim(VRWRec.rtParentName) = '') then
          edtParentName.Text  := 'REPORTS'
        else
          edtParentName.Text  := VRWRec.rtParentName;
        edtFileName.Text      := VRWRec.rtFileName;
        if not VRWRec.rtFileExists then
          edtFileName.Text := Trim(edtFileName.Text) + ' (* File not found *)';
      end;
  else
    { Should never happen }
    raise Exception.Create('Invalid record passed to Properties dialog');
  end;
end;

procedure TfrmRptTreeProperties.btnOkClick(Sender: TObject);
begin
  Close;
end;

end.

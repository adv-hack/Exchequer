unit NewLine2F;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, BorBtns, TEditVal, StdCtrls, SBSPanel, Mask, ExtCtrls,
  ComCtrls;

type
  TForm6 = class(TForm)
    PageControl1: TPageControl;
    DE1Page: TTabSheet;
    Id1Panel: TSBSPanel;
    Id1ItemLab: Label8;
    Id1UPLab: Label8;
    Id1DiscLab: Label8;
    Id1LTotLab: Label8;
    Id1QtyLab: Label8;
    Id1ItemF: Text8Pt;
    Id1QtyF: TCurrencyEdit;
    Id1SBox: TScrollBox;
    Id1Desc1F: Text8Pt;
    Id1Desc2F: Text8Pt;
    Id1Desc3F: Text8Pt;
    Id1Desc4F: Text8Pt;
    Id1Desc5F: Text8Pt;
    Id1Desc6F: Text8Pt;
    Id1UPriceF: TCurrencyEdit;
    Id1LTotF: TCurrencyEdit;
    Id1DiscF: Text8Pt;
    De2Page: TTabSheet;
    DE3Page: TTabSheet;
    Id3Panel: TSBSPanel;
    Id3SCodeLab: Label8;
    id3LocLab: Label8;
    Id3SCodeF: Text8Pt;
    Id3SBox: TScrollBox;
    Id3Desc1F: Text8Pt;
    Id3Desc2F: Text8Pt;
    Id3Desc3F: Text8Pt;
    Id3Desc4F: Text8Pt;
    Id3Desc5F: Text8Pt;
    Id3Desc6F: Text8Pt;
    Id3LocF: Text8Pt;
    Id3Panel3: TSBSPanel;
    UDF1L: Label8;
    UDF3L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    LineExtF1: TSBSExtendedForm;
    Label85: Label8;
    VATCCLab3: Label8;
    DelDateLab: Label8;
    Label83: Label8;
    Id3CostLab: Label8;
    Label84: Label8;
    Label86: Label8;
    Label81: Label8;
    Label82: Label8;
    Id3VATF: TSBSComboBox;
    Id3DepF: Text8Pt;
    Id3DelF: TEditDate;
    Id3LTF: TSBSComboBox;
    Id3CostF: TCurrencyEdit;
    UseISCB: TBorCheck;
    IntBtn: TBitBtn;
    Id5JCodeF: Text8Pt;
    Id5JAnalF: Text8Pt;
    GLDescF: Text8Pt;
    Id3CCF: Text8Pt;
    Id3NomF: Text8Pt;
    LUD1F: Text8Pt;
    LUD3F: Text8Pt;
    LUD4F: Text8Pt;
    LUD2F: Text8Pt;
    DE4Page: TTabSheet;
    SBSPanel7: TSBSPanel;
    Label831: Label8;
    Label833: Label8;
    Label834: Label8;
    Label835: Label8;
    SBSPanel8: TSBSPanel;
    Label836: Label8;
    PickLab: Label8;
    Id4QOF: TCurrencyEdit;
    Id4QDF: TCurrencyEdit;
    Id4QWF: TCurrencyEdit;
    Id4QOSF: TCurrencyEdit;
    ID4QPTF: TCurrencyEdit;
    Id4QWTF: TCurrencyEdit;
    SBSPanel1: TSBSPanel;
    Label5: TLabel;
    ScrollBox1: TScrollBox;
    Label3: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label1: TLabel;
    Label7: TLabel;
    EditValue1: TEditValue;
    UpDown1: TUpDown;
    EditValue2: TEditValue;
    UpDown2: TUpDown;
    Id3PQtyF: TCurrencyEdit;
    Id3QtyF: TCurrencyEdit;
    Id3UPriceF: TCurrencyEdit;
    Id3DiscF: Text8Pt;
    Id3LTotF: TCurrencyEdit;
    Id3PQLab: Label8;
    Id3QtyLab: Label8;
    Id3UPLab: Label8;
    Id3DiscLab: Label8;
    Id3LTotLab: Label8;
    Label87: Label8;
    Label88: Label8;
    Bevel1: TBevel;
    Label89: Label8;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    CurrencyEdit1: TCurrencyEdit;
    CurrencyEdit2: TCurrencyEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

end.

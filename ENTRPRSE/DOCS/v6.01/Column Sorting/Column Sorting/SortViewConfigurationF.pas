unit SortViewConfigurationF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    edtSortViewDescr: TEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label6: TLabel;
    lstPrimarySortOrder: TComboBox;
    chkSecondarySort: TCheckBox;
    lstSecondarySortOrder: TComboBox;
    lstPrimarySortField: TComboBox;
    lstSecondarySortField: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    chkFilter1: TCheckBox;
    lstFilter1Field: TComboBox;
    lstFilter1CompareType: TComboBox;
    lstFilter1CompareValue: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    chkFilter2: TCheckBox;
    lstFilter2Field: TComboBox;
    lstFilter2CompareType: TComboBox;
    lstFilter2CompareValue: TEdit;
    chkFilter3: TCheckBox;
    lstFilter3Field: TComboBox;
    lstFilter3CompareType: TComboBox;
    lstFilter3CompareValue: TEdit;
    chkFilter4: TCheckBox;
    lstFilter4Field: TComboBox;
    lstFilter4CompareType: TComboBox;
    lstFilter4CompareValue: TEdit;
    lstSaveOptions: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure DoCheckyChecky(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
  DoCheckyChecky(Nil);
end;

procedure TForm2.DoCheckyChecky(Sender: TObject);
Begin // DoCheckyChecky
  lstSecondarySortField.Enabled := chkSecondarySort.Checked;
  lstSecondarySortOrder.Enabled := chkSecondarySort.Checked;

  lstFilter1Field.Enabled := chkFilter1.Checked;
  lstFilter1CompareType.Enabled := chkFilter1.Checked;
  lstFilter1CompareValue.Enabled := chkFilter1.Checked;

  lstFilter2Field.Enabled := chkFilter2.Checked;
  lstFilter2CompareType.Enabled := chkFilter2.Checked;
  lstFilter2CompareValue.Enabled := chkFilter2.Checked;

  lstFilter3Field.Enabled := chkFilter3.Checked;
  lstFilter3CompareType.Enabled := chkFilter3.Checked;
  lstFilter3CompareValue.Enabled := chkFilter3.Checked;

  lstFilter4Field.Enabled := chkFilter4.Checked;
  lstFilter4CompareType.Enabled := chkFilter4.Checked;
  lstFilter4CompareValue.Enabled := chkFilter4.Checked;
End; // DoCheckyChecky

end.
TDateTime

01267.034
91255.321

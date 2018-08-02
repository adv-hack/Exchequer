unit BOMDetF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComObj, Enterprise01_Tlb;

type
  TComponentDlgMode = (cdAdd, cdEdit, cdInsert);

  TfrmBOMDetails = class(TForm)
    GroupBox1: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    edtQtyUsed: TEdit;
    edtStockCode: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtStockCodeExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    OK : Boolean;
  end;

implementation

{$R *.DFM}

Uses StkListF, StkSelct;

//--------------------------------------

procedure TfrmBOMDetails.FormCreate(Sender: TObject);
begin
  OK := False;
end;

//--------------------------------------

procedure TfrmBOMDetails.btnOKClick(Sender: TObject);
Var
  QtyUsed      : Double;
  Res, PrevPos : LongInt;
begin
  // Perform some basic validation

  // Stock Code - must be valid and not a group
  With oToolkit.Stock Do Begin
    // Save current position in stock object
    PrevPos := Position;
    SavePosition;

    // check to see if stock exists
    Res := GetEqual (BuildCodeIndex(edtStockCode.Text));
    OK := (Res = 0) And (Not (stType In [stTypeGroup, stTypeDiscontinued]));

    // restore original position in stock object
    RestorePosition;
    Position := PrevPos;

    If (Not OK) Then Begin
      ShowMessage ('Invalid Stock Code');
      If edtStockCode.CanFocus Then edtStockCode.SetFocus;
    End; { If }
  End; { With oToolkit.Stock }

  // Quantity Used - > 0
  QtyUsed := StrToFloat(edtQtyUsed.Text);
  OK := (QtyUsed > 0.0);
  If (Not OK) Then Begin
    ShowMessage ('The Quantity Used must be greater than zero');
    If edtQtyUsed.CanFocus Then edtQtyUsed.SetFocus;
  End; { If }

  If OK Then Close;
end;

//--------------------------------------

procedure TfrmBOMDetails.btnCancelClick(Sender: TObject);
begin
  OK := False;
  Close;
end;

//--------------------------------------

procedure TfrmBOMDetails.edtStockCodeExit(Sender: TObject);
Var
  oStock : IStock;
  StkCode : ShortString;
begin
  StkCode := edtStockCode.Text;
  oStock := SelectStock (oToolkit, 2, StkCode);
  If Assigned(oStock) Then Begin
    edtStockCode.Text := oStock.stCode;
    oStock := NIL;
  End; { If Assigned(oStock) }
end;

//--------------------------------------

end.

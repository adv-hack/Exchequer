unit Halcn6id;

interface

uses
   SysHalc, Classes,
  {$IFDEF WIN32}
  Messages, Graphics, Controls, Forms, Dialogs, Buttons, StdCtrls, ExtCtrls,
  {$ENDIF}
  {$IFDEF LINUX}
  Types, QGraphics, QControls, QForms, QDialogs, QStdCtrls, QExtCtrls, QButtons,
  {$ENDIF}
  DB, Halcn6DB;

type
  TIndexDescDef = class(TForm)
    ListBox1: TListBox;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    CheckBox1: TCheckBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DataSet: THalcyonDataset;
  end;

var
  IndexDescDef: TIndexDescDef;

implementation

{$R *.dfm}

procedure TIndexDescDef.BitBtn1Click(Sender: TObject);
begin
   Close;
end;

procedure TIndexDescDef.FormActivate(Sender: TObject);
var
   I: integer;
   J: Integer;
begin
   ListBox1.Clear;
   if Dataset.Active then
   begin
      DataSet.IndexDefs.Update;
      J := DataSet.IndexDefs.Count - 1;
      for I := 0 to J do
      begin
         ListBox1.Items.Add(DataSet.IndexDefs[I].Name);
      end;
   end;   
end;

procedure TIndexDescDef.ListBox1Click(Sender: TObject);
begin
   if not Dataset.Active then exit; 
   if ListBox1.ItemIndex < 0 then exit;
   Edit1.Text := DataSet.IndexDefs[ListBox1.ItemIndex].Name;
   Edit2.Text := DataSet.IndexDefs[ListBox1.ItemIndex].Fields;
   if ixExpression in DataSet.IndexDefs[ListBox1.ItemIndex].Options then
   begin
   Edit2.Text := DataSet.IndexDefs[ListBox1.ItemIndex].Expression;
      CheckBox1.Checked := true;
   end
   else
   begin
   Edit2.Text := DataSet.IndexDefs[ListBox1.ItemIndex].Fields;
      CheckBox1.Checked := false;
   end;
end;

end.

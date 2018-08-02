{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RpAddFrm;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, DB, RPDefine;

type
  TAddColumnForm = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  public
    DataSet: TDataSet;
    FieldList: TStringList;
    AddFields: boolean;
  end;

var
  AddColumnForm: TAddColumnForm;

implementation

{$R *.DFM}

  procedure TAddColumnForm.BitBtn2Click(Sender: TObject);

  var
    ColumnName: string;

  begin
  { Ask for name of column to add }
    ColumnName := '';
    If InputQuery(Trans('Add Column'),Trans('Enter a description for this column'),
    ColumnName) then begin
      FieldList.Add(ColumnName);
      ModalResult := mrOK;
    end; { if }
  end;

  procedure TAddColumnForm.BitBtn1Click(Sender: TObject);
  var
    I1: integer;
  begin
  { Copy all selected items to FieldList }
    For I1 := 1 to ListBox1.Items.Count do begin
      If ListBox1.Selected[I1 - 1] then begin
        FieldList.Add(ListBox1.Items[I1 - 1]);
      end; { if }
      AddFields := true;
    end; { for }
  end;

  procedure TAddColumnForm.FormCreate(Sender: TObject);
  begin
    FieldList := TStringList.Create;
    AddFields := false;
  end;

  procedure TAddColumnForm.FormShow(Sender: TObject);
  begin
    If DataSet <> nil then begin
      DataSet.GetFieldNames(ListBox1.Items);
    end; { if }
  end;

  procedure TAddColumnForm.FormDestroy(Sender: TObject);
  begin
    FieldList.Free;
  end;

end.
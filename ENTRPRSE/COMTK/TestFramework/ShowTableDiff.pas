unit ShowTableDiff;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TfrmShowTableDifferences = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    lvDiffs: TListView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure ShowTableDifferences(const TableName : string;
                                 const CompCode1 : string;
                                 const CompCode2 : string;
                                 const AList     : TStringList);

var
  frmShowTableDifferences: TfrmShowTableDifferences;

implementation

{$R *.dfm}
procedure ShowTableDifferences(const TableName : string;
                               const CompCode1 : string;
                               const CompCode2 : string;
                               const AList     : TStringList);
var
  i : integer;
  DiffList : TStringList;

begin
  if AList.Count > 0 then
  begin

    DiffList := TStringList.Create;
    Try
      frmShowTableDifferences := TfrmShowTableDifferences.Create(nil);
      with frmShowTableDifferences do
      Try
        Caption := 'Differences in ' + TableName;
        with lvDiffs do
        begin
          Columns[1].Caption := CompCode1;
          Columns[2].Caption := CompCode2;

          //Each line of AList is in format FieldName,Value1,Value2
          for i := 0 to AList.Count - 1 do
          begin
            DiffList.CommaText := AList[i];
            with Items.Add do
            begin
              Caption := DiffList[0];
              SubItems.Add(DiffList[1]);
              SubItems.Add(DiffList[2]);
            end;
          end;
        end;

        ShowModal;
      Finally
        Free;
      End;
    Finally
      DiffList.Free;
    End;
  end;
end;

end.

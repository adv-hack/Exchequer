unit mlinelst;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uMultiList, StdCtrls;

type
  TMatchOptions = Record
    UseAC, UseStock, UseDate : Boolean;
    StartAC, EndAC : string[10];
    StartStock, EndStock : string[16];
    StartDate, EndDate : string[8];
  end;

  TLineDetails = Class
    ldAbsLineNo : longint;
    ldSupplier  : string[6];
    ldOurRef    : string[10];
    ldStockCode : string[16];
    ldDesc      : string[60];
    ldDate      : string[8];
    ldValue     : Double;
    ldQty       : Double;
  end;

  TItemNo = Class
    INo : longint;
    AbsLineNo : longint;
    OurRef : string[10];
  end;


  TListProc = procedure (ItemNo : integer; AList : TStrings; Opts : TMatchOptions) of Object;

  TfrmLineList = class(TForm)
    mlLines: TMultiList;
    Panel1: TPanel;
    Button1: TButton;
    Button3: TButton;
    Button2: TButton;
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    fGetList : TListProc;
    fList : TStringList;
    fItem : integer;
  public
    { Public declarations }
    DefSupplier, DefStockCode : string;
    property Item : integer write fItem;
    property List : TStringList write fList;
    property GetList : TListProc write fGetList;
  end;

var
  frmLineList: TfrmLineList;
  MatchOptions : TMatchOptions;

implementation

{$R *.dfm}
uses
  MatchOpt, EtDateU;


procedure TfrmLineList.Button3Click(Sender: TObject);
var
  i : integer;
  OldCursor : TCursor;
  ItemO : TItemNo;
begin
  with TfrmMatchOptions.Create(nil) do
  Try
    chkAc.Checked := MatchOptions.UseAC;
    chkStock.Checked := MatchOptions.UseStock;
    chkDate.Checked := MatchOptions.UseDate;
    edtAcCode1.Text := MatchOptions.StartAC;
    edtAcCode2.Text := MatchOptions.EndAC;
    edtStockCode1.Text := MatchOptions.StartStock;
    edtStockCode2.Text := MatchOptions.EndStock;
    dtpDate1.Date := StrToDate(POutDate(MatchOptions.StartDate));
    dtpDate2.Date := StrToDate(POutDate(MatchOptions.EndDate));
    ShowModal;

    if ModalResult = mrOK then
    begin
      Refresh;
      Application.ProcessMessages;
      OldCursor := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      MatchOptions.UseAC := chkAc.Checked;
      MatchOptions.UseStock := chkStock.Checked;
      MatchOptions.UseDate := chkDate.Checked;
      MatchOptions.StartAC := edtAcCode1.Text;
      MatchOptions.EndAC := edtAcCode2.Text;
      MatchOptions.StartStock := edtStockCode1.Text;
      MatchOptions.EndStock := edtStockCode2.Text;
      MatchOptions.StartDate := FormatDateTime('yyyymmdd', dtpDate1.Date);
      MatchOptions.EndDate := FormatDateTime('yyyymmdd', dtpDate2.Date);

      if Assigned(fGetList) then
        fGetList(fItem, fList, MatchOptions);

      for i := 0 to mlLines.Columns.Count - 1 do
        mlLines.DesignColumns[i].Items.Clear;

      for i := 0 to fList.Count - 1 do
        with fList.Objects[i] as TLineDetails do
        begin
          ItemO := TItemNo.Create;
          ItemO.INo := i;
          ItemO.AbsLineNo := ldAbsLineNo;
          ItemO.OurRef := ldOurRef;
          mlLines.DesignColumns[0].Items.AddObject(ldOurRef, ItemO);
          mlLines.DesignColumns[1].Items.Add(ldStockCode);
          mlLines.DesignColumns[2].Items.Add(ldDesc);
          mlLines.DesignColumns[3].Items.Add(POutDate(ldDate));
          mlLines.DesignColumns[4].Items.Add(Format('%11.2f', [ldQty]));
          mlLines.DesignColumns[5].Items.Add(Format('%11.2f', [ldValue]));
          mlLines.DesignColumns[6].Items.Add(ldSupplier);
        end;
       Screen.Cursor := OldCursor;
    end;
  Finally
    Free;
  End;
end;

end.

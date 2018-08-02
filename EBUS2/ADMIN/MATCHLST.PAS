unit matchlst;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, EbusVar, ExtCtrls, MLineLst, uMultiList;

type


  TMatchProc = procedure (InvLine, OrderAbsLineNo : integer; const OrderRef : string) of Object;
  TLoadListProc = procedure (AList : TStrings) of Object;

  TfrmEbusMatchList = class(TForm)
    Label1: TLabel;
    mlUD: TMultiList;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mlUDRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    fGetLineList : TListProc;
    fDoMatch  : TMatchProc;
    fGetUDList : TLoadListProc;
    fUdList, fLineList : TStringList;
    procedure DoGetUDList;
    function DoLineList(ItemNo : integer) : integer;
    procedure ShowMatches;
  public
    { Public declarations }
    DefSupp : string;
    procedure Start;
    property GetUDList : TLoadListProc write fGetUDList;
    property GetLineList : TListProc write fGetLineList;
    property DoMatch : TMatchProc write fDoMatch;
  end;

var
  frmEbusMatchList: TfrmEbusMatchList;

implementation

{$R *.dfm}
uses
   EtDateU;

procedure TfrmEbusMatchList.Start;
begin
  DoGetUDList;

  ShowModal;
end;

procedure TfrmEbusMatchList.FormCreate(Sender: TObject);
begin
  fLineList := TStringList.Create;
  fUDList := TStringList.Create;
end;

procedure TfrmEbusMatchList.FormDestroy(Sender: TObject);
begin
  fUDList.Free;
  fLineList.Free;
end;

procedure TfrmEbusMatchList.DoGetUDList;
var
  i : integer;
begin
  if Assigned(fGetUDList) then
    fGetUDList(fUDList);

  for i := 0 to 3 do
    mlUD.DesignColumns[i].Items.Clear;
    
  for i := 0 to fUDList.Count - 1 do
  begin
    with fUDList.Objects[i] as TPreserveLineObject do
    begin
      mlUD.DesignColumns[0].Items.Add(Fields.IdStockCode);
      mlUD.DesignColumns[1].Items.Add(Fields.IdDescription);
      mlUD.DesignColumns[2].Items.Add(Format('%11.2f', [Fields.IdQty]));
      mlUD.DesignColumns[3].Items.Add(Format('%11.2f', [Fields.IdValue]));
    end;
  end;
end;

function TfrmEbusMatchList.DoLineList(ItemNo : integer) : Integer;
var
  i : integer;
  d : TDate;
  OldCursor : TCursor;
  ItemO : TItemNo;
begin
  Result := -1;
  if Assigned(fGetLineList) then
  begin
    OldCursor := Screen.Cursor;
    Screen.Cursor := crHourGlass;

    //Set default matching options
    FillChar(MatchOptions, SizeOf(MatchOptions), 0);
    MatchOptions.UseAC := True;
    MatchOptions.UseStock := True;
    MatchOptions.StartAC  := DefSupp;
    MatchOptions.EndAC  := DefSupp;
    MatchOptions.StartStock := mlUD.DesignColumns[0].Items[mlUD.Selected];
    MatchOptions.EndStock := mlUD.DesignColumns[0].Items[mlUD.Selected];

    d := Date;
    MatchOptions.EndDate := FormatDateTime('yyyymmdd', d);
    d := IncMonth(d, -2);
    MatchOptions.StartDate := FormatDateTime('yyyymmdd', d);


    fGetLineList(ItemNo, fLineList, MatchOptions);

    with TfrmLineList.Create(nil) do
    Try
      for i := 0 to fLineList.Count - 1 do
        with fLineList.Objects[i] as TLineDetails do
        begin
          ItemO := TItemNo.Create;
          ItemO.Ino := i;
          ItemO.AbsLineNo := ldAbsLineNo;
          mlLines.DesignColumns[0].Items.AddObject(ldOurRef, ItemO);
          mlLines.DesignColumns[1].Items.Add(ldStockCode);
          mlLines.DesignColumns[2].Items.Add(ldDesc);
          mlLines.DesignColumns[3].Items.Add(POutDate(ldDate));
          mlLines.DesignColumns[4].Items.Add(Format('%11.2f', [ldQty]) + ' ');
          mlLines.DesignColumns[5].Items.Add(Format('%11.2f', [ldValue]) + ' ');
          mlLines.DesignColumns[6].Items.Add(ldSupplier);
        end;
      GetList := fGetLineList;
      List := fLineList;
      Item := ItemNo;
      ShowModal;
      if ModalResult = mrOK then
      begin
        if mlLines.Selected >= 0 then
        begin
          ItemO := mlLines.DesignColumns[0].Items.Objects[mlLines.Selected] as TItemNo;
          Result := ItemO.INo;
          with fUDList.Objects[ItemNo] as TPreserveLineObject do
          begin
            if Fields.IdOrderLineNo <> ItemO.AbsLineNo then
              Fields.IdOrderLineNo := ItemO.AbsLineNo;
            if Fields.IdBuyersOrder <> ItemO.OurRef then
              Fields.IdBuyersOrder := ItemO.OurRef;
          end;
        end
        else
          Result := -1;
      end;
    Finally
      Free;
    End;
    Screen.Cursor := OldCursor;
  end;
end;

procedure TfrmEbusMatchList.mlUDRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  ShowMatches;
end;

procedure TfrmEbusMatchList.Button1Click(Sender: TObject);
begin
  ShowMatches;
end;

procedure TfrmEbusMatchList.ShowMatches;
var
  i : integer;
begin
  if mlUD.Selected >= 0 then
    i := DoLineList(mlUD.Selected)
  else
    i := -1;

  if i >= 0 then
  begin
    if Assigned(fDoMatch) then
      with fLineList.Objects[i] as TLineDetails do
        fDoMatch(mlUD.Selected, ldAbsLineNo, ldOurRef);

{    if Assigned(fGetUDList) then
      fGetUDList(fUDList);}
    DoGetUDList;

    if fUDList.Count = 0 then
      Close;
  end;
end;


end.

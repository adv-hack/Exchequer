unit vcombo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, Grids, ExtCtrls, StdCtrls;

type

  TDataWanted = (dwFirst, dwNext, dwPrev, dwLast, dwNextPage, dwPrevPage, dwShow);

  TGetDataFunc = Function(Sender : TObject; var DataString : string) : boolean of Object;

  TGetPageFunc = Function(Sender : TObject; AList : TStrings; DCount : integer) : boolean of Object;
  TFindFunc = Function(Sender : TObject; AList : TStrings;
                       DCount : integer; const FindString : string) : Boolean of Object;

  TfrmList = class(TForm)
    Panel1: TPanel;
    Grid: TStringGrid;
    pnlScroll: TPanel;
    btnFirst: TSpeedButton;
    btnPrev: TSpeedButton;
    btnLast: TSpeedButton;
    btnNext: TSpeedButton;
    Timer1: TTimer;
    procedure FormDeactivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure GridClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pnlScrollMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure GridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure pnlScrollMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FOwner : TComponent;
    FCurrenttext : string;
    FCount : integer;
    FEdit : TEdit;
    FromButton : Boolean;
    FOnGetNext, FOnGetPrev : TGetDataFunc;
    FOnGetFirst, FOnGetLast, FOnGetPrevPage, FOnGetNextPage : TGetPageFunc;
    FOnShow : TFindFunc;
    AList : TStringList;
    FromKey : Boolean;
    procedure GetData(WhichData : TDataWanted);
  protected
    procedure SetCurrentText(const Value : string);
    procedure SetCount(Value : integer);
  public
    { Public declarations }
    OK2Show : Boolean;
    procedure LoadList(AList : TStrings);
    procedure SetGridRow(Value : integer);
    procedure SetGridRowByText;
    property Edit : TEdit read FEdit write FEdit;
    property CurrentText : string read FCurrentText write SetCurrentText;

    property OnGetFirst : TGetPageFunc read FOnGetFirst write FOnGetFirst;
    property OnGetNext : TGetDataFunc read FOnGetNext write FOnGetNext;
    property OnGetPrev : TGetDataFunc read FOnGetPrev write FOnGetPrev;
    property OnGetLast : TGetPageFunc read FOnGetLast write FOnGetLast;
    property OnGetPrevPage : TGetPageFunc read FOnGetPrevPage write FOnGetPrevPage;
    property OnGetNextPage : TGetPageFunc read FOnGetNextPage write FOnGetNextPage;
    property OnShow : TFindFunc read FOnShow write FOnShow;
    property Count : integer read FCount write SetCount;
  end;

  TVirtualComboBox = Class(TPanel)
  private
    FEdit  :  TEdit;
    FBtn   :  TSpeedButton;
    FPanel : TPanel;
    FListForm : TfrmList;
    FOnChange : TNotifyEvent;
  protected
    function GetPage(Index : integer) : TGetPageFunc;
    procedure SetPage(Index : integer; Value : TGetPageFunc);
    function GetLine(Index : integer) : TGetDataFunc;
    procedure SetLine(Index : integer; Value : TGetDataFunc);
    function GetFind(Index : integer) : TFindFunc;
    procedure SetFind(Index : integer; Value : TFindFunc);
    function GetFlat : Boolean;
    procedure SetFlat(Value : Boolean);
    function GetText : string;
    procedure SetText(const Value : string);
    procedure EditChange(Sender : TObject);
    procedure ButtonClick(Sender : TObject);

    procedure DoEnter; Override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
  published
    property OnGetFirst : TGetPageFunc Index 0 read GetPage write SetPage;
    property OnGetLast : TGetPageFunc Index 1 read GetPage write SetPage;
    property OnGetPrevPage : TGetPageFunc Index 2 read GetPage write SetPage;
    property OnGetNextPage : TGetPageFunc Index 3 read GetPage write SetPage;

    property OnGetNext : TGetDataFunc Index 0 read GetLine write SetLine;
    property OnGetPrev : TGetDataFunc Index 1 read GetLine write SetLine;
    property OnShow : TFindFunc index 0 read GetFind write SetFind;
    property OnChange : TNotifyEvent read FOnChange write FOnChange;
    property FlatButton : Boolean read GetFlat write SetFlat;
    property Text : string read GetText write SetText;
  end;

  procedure Register;


implementation

{$R *.dfm}

procedure Register;
begin
  RegisterComponents('Samples', [TVirtualComboBox]);
end;

//------------------------------------------------------------------------------
//                            TfrmList methods
//------------------------------------------------------------------------------


procedure TfrmList.FormDeactivate(Sender: TObject);
begin
  Timer1.Enabled := True;
  Hide;
end;

procedure TfrmList.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  Ok2Show := True;
end;

procedure TfrmList.btnPrevClick(Sender: TObject);
var
  s : string;
begin
  FromButton := True;
  if Grid.Row > 0 then
  begin
    s := 'X'; //no data wanted
    if not FromKey then
      Grid.Row := Grid.Row - 1;
    if Assigned(FOnGetPrev) then
      FOnGetPrev(Self, s);
  end
  else
    GetData(dwPrev);
end;

procedure TfrmList.FormCreate(Sender: TObject);
var
  i : integer;
begin
  Count := 8;
  Grid.RowCount := 8;
  Grid.Row := 0;
  FromButton := False;
  FOnGetFirst := nil;
  FOnGetNext := nil;
  FOnGetPrev := nil;
  FOnGetLast := nil;
  FOnGetPrevPage := nil;
  FOnGetNextPage := nil;
  FOnShow := nil;
  AList := TStringList.Create;
  OK2Show := True;
  FromKey := False;
  btnLast.Top := pnlScroll.Height - btnLast.Height;
  btnNext.Top := btnLast.Top - btnNext.Height;
end;

procedure TfrmList.btnNextClick(Sender: TObject);
var
  s : string;
begin
  FromButton := True;
  if Grid.Row < Grid.RowCount - 1 then
  begin
    s := 'X';
    if not FromKey then
      Grid.Row := Grid.Row + 1;
    if Assigned(FOnGetNext) then
      FOnGetNext(Self, s);
  end
  else
    GetData(dwNext);
  FromKey := False;
end;

procedure TfrmList.SetCurrentText(const Value : string);
begin
  FCurrentText := Value;
end;

procedure TfrmList.GridClick(Sender: TObject);
begin
  if not FromButton then
  begin
    FEdit.Text := Grid.Cells[0, Grid.Row];
    FEdit.Modified := True;
  end;
  FromButton := False;
end;

procedure TfrmList.GetData(WhichData : TDataWanted);
var
  i : integer;
  s : string;
  TempBool : Boolean;
begin
  AList.Clear;
  s := '';
  Case  WhichData of
    dwNext  :  if Assigned(FOnGetNext) then
                    TempBool := FOnGetNext(Self, s);
    dwPrev  :  if Assigned(FOnGetPrev) then
                    TempBool := FOnGetPrev(Self, s);
    dwFirst :  if Assigned(FOnGetFirst) then
                    TempBool := FOnGetFirst(Self, AList, FCount);
    dwLast :  if Assigned(FOnGetLast) then
                    TempBool := FOnGetLast(Self, AList, FCount);
    dwPrevPage
           :  if Assigned(FOnGetPrevPage) then
              begin
                TempBool := FOnGetPrevPage(Self, AList, FCount);
                if AList.Count < FCount then //we need to fill in the full count
                begin
                  if AList.Count > 0 then
                  begin
                    s := AList[0];
                    AList.Clear;
                    TempBool := FOnShow(Self, AList, FCount, s);
                  end;
                end;
              end;
    dwNextPage
           :  if Assigned(FOnGetNextPage) then
              begin
                TempBool := FOnGetNextPage(Self, AList, FCount);
                if AList.Count < FCount then //we need to fill in the full count
                begin
                  if AList.Count > 0 then
                  begin
                    s := AList[0];
                    AList.Clear;
                    TempBool := FOnShow(Self, AList, FCount, s);
                  end;
                end;
              end;
    dwShow :  if Assigned(FOnShow) then
                    TempBool := FOnShow(Self, AList, FCount, FEdit.Text);
    else
      TempBool := False;
  end;

  if TempBool then
  begin
    Case WhichData of
      dwNext  : begin
                  for i := 0 to Grid.RowCount - 2 do
                    Grid.Cells[0, i] := Grid.Cells[0, i + 1];
                  Grid.Cells[0, Grid.RowCount - 1] := s;
                end;
      dwPrev  : begin
                  for i := Grid.RowCount - 1 downto 1 do
                    Grid.Cells[0, i] := Grid.Cells[0, i - 1];
                  Grid.Cells[0, 0] := s;
                end;
      dwFirst,
      dwShow,
      dwPrevPage : begin
                    LoadList(AList);
                    if WhichData <> dwShow then
                      Grid.Row := 0;
                   end;
      dwLast,
      dwNextPage  : begin
                      LoadList(AList);
                      Grid.Row := FCount - 1;
                    end;
    end;
    Grid.Repaint;
//    SetActiveWindow(Grid.Handle);
    Application.ProcessMessages;
  end;
end;

procedure TfrmList.LoadList(AList : TStrings);
var
  i : integer;
begin
  for i := 0 to FCount - 1 do
    if i < AList.Count  then
      Grid.Cells[0, i] := AList[i]
    else
      Grid.Cells[0, i] := '';
end;

procedure TfrmList.SetCount(Value : integer);
begin
  FCount := Value;
  ClientHeight := (Value * Grid.DefaultRowHeight) - 8;
  Grid.RowCount := Value;
end;

procedure TfrmList.FormResize(Sender: TObject);
begin
  Grid.DefaultColWidth := Grid.Width;
end;

procedure TfrmList.btnFirstClick(Sender: TObject);
begin
  FromButton := True;
  GetData(dwFirst);
end;

procedure TfrmList.btnLastClick(Sender: TObject);
begin
  FromButton := True;
  GetData(dwLast);
end;

procedure TfrmList.FormDestroy(Sender: TObject);
begin
  AList.Free;
end;

procedure TfrmList.pnlScrollMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  pnlScroll.Color := clBtnShadow;
  FromButton := True;
  if Y < (pnlScroll.Height div 2) then
    GetData(dwPrevPage)
  else
    GetData(dwNextPage);
end;

procedure TfrmList.SetGridRow(Value : integer);
begin
  FromButton := True;
  Grid.Row := Value;
end;

procedure TfrmList.FormShow(Sender: TObject);
begin
  ActiveControl := Grid;
  GetData(dwShow);
end;

procedure TfrmList.SetGridRowByText;
var
  i : integer;
  Found : Boolean;
begin
  Found := False;
  i := 0;
  while i < Grid.RowCount do
  begin
    if Grid.Cells[0, i] = FEdit.Text then
    begin
      Grid.Row := i;
      Found := True;
    end;
    inc(i);
  end;

  if not Found then
    Grid.Row := 0;

  Grid.Repaint;
  Application.ProcessMessages;
end;

procedure TfrmList.GridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if X < pnlScroll.Left then
    FromButton := False;

end;

procedure TfrmList.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  s  : string;
begin
  FromKey := True;
  Case Key of
    VK_DOWN      :  btnNextClick(Self);
    VK_UP        :  btnPrevClick(Self);
    VK_HOME      :  GetData(dwFirst);
    VK_END       :  GetData(dwLast);
    VK_PRIOR     :  GetData(dwPrevPage);
    VK_NEXT      :  GetData(dwNextPage);
  end;
  FromButton := True;
  FromKey := False;
  Sleep(10);
end;

procedure TfrmList.GridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    FromButton := False;
    GridClick(Self);
  end
  else
  if Key = VK_ESCAPE then
    SetActiveWindow(FEdit.ParentWindow);
end;

procedure TfrmList.pnlScrollMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  pnlScroll.Color := clBtnFace;
end;

//------------------------------------------------------------------------------
//                         TVirtualComboBox methods
//------------------------------------------------------------------------------

constructor TVirtualComboBox.Create(AOwner : TComponent);
begin
  Inherited Create(AOwner);
  Height := 18;
  Width := 141;
  Enabled := True;

  Constraints.MaxHeight := 18;
  Constraints.MinHeight := 18;

  BevelOuter := bvLowered;

  FPanel := TPanel.Create(Self);
  FPanel.Parent := Self;
  FPanel.Width := 19;
  FPanel.BevelOuter := bvLowered;
  FPanel.BorderStyle := bsSingle;
  FPanel.Align := alRight;

  FBtn := TSpeedButton.Create(Self);
  FBtn.Parent := FPanel;
  FBtn.Height := 18;
  FBtn.Width := 18;
{  FBtn.Left := 122;
  FBtn.Top := 2;
  FBtn.Anchors := [akRight, akTop];}
  FBtn.Align := alClient;
  FBtn.OnClick := ButtonClick;
  FBtn.Enabled := True;

  FEdit := TEdit.Create(Self);
  FEdit.Parent := Self;
  FEdit.Left := 1;
  FEdit.Top := 1;
  FEdit.Height := 18;
  FEdit.OnChange := EditChange;
{  FEdit.Width := 121;
  FEdit.Anchors := [akLeft, akTop];}
  FEdit.Align := alClient;
  FEdit.ReadOnly := True;

  FListForm := TfrmList.Create(Self);

  FListForm.Edit := FEdit;
  if not (csDesigning in ComponentState) then
    FBtn.Glyph.Assign(FListForm.btnNext.Glyph)
  else
    FEdit.Text := Caption;

end;

destructor TVirtualComboBox.Destroy;
begin
  FBtn.Free;
  FEdit.Free;
  FListForm.Free;

  inherited Destroy;
end;

procedure TVirtualComboBox.ButtonClick(Sender : TObject);
var
  P : TPoint;
begin
  DoEnter;
  if FListForm.OK2Show then
  begin
    P := Point({FEdit.Left, FEdit.top}Self.Left, Self.Top);
    FListForm.Left := Parent.ClientToScreen(P).X;
    FListForm.top := Parent.ClientToScreen(P).Y + {FEdit.Height}Self.Height + 1;
    FListForm.Width := {FEdit.Width + FPanel.Width}Self.Width;
    FListForm.OK2Show := False;
    FListForm.Show;
    FListForm.SetGridRowByText;
  end;
end;

function TVirtualComboBox.GetPage(Index : integer) : TGetPageFunc;
begin
  Case Index of
    0  : Result := FListForm.OnGetFirst;
    1  : Result := FListForm.OnGetLast;
    2  : Result := FListForm.OnGetPrevPage;
    3  : Result := FListForm.OnGetNextPage;
  end;
end;

procedure TVirtualComboBox.SetPage(Index : integer; Value : TGetPageFunc);
begin
  Case Index of
    0  : FListForm.OnGetFirst := Value;
    1  : FListForm.OnGetLast := Value;
    2  : FListForm.OnGetPrevPage := Value;
    3  : FListForm.OnGetNextPage := Value;
  end;
end;

function TVirtualComboBox.GetLine(Index : integer) : TGetDataFunc;
begin
  Case Index of
    0  : Result := FListForm.OnGetNext;
    1  : Result := FListForm.OnGetPrev;
  end;
end;

procedure TVirtualComboBox.SetLine(Index : integer; Value : TGetDataFunc);
begin
  Case Index of
    0  : FListForm.OnGetNext := Value;
    1  : FListForm.OnGetPrev := Value;
  end;
end;

function TVirtualComboBox.GetFind(Index : integer) : TFindFunc;
begin
  Case Index of
    0  : Result := FListForm.OnShow;
  end;
end;

procedure TVirtualComboBox.SetFind(Index : integer; Value : TFindFunc);
begin
  Case Index of
    0  : FListForm.OnShow := Value;
  end;
end;

function TVirtualComboBox.GetFlat : Boolean;
begin
  Result := FBtn.Flat;
end;

procedure TVirtualComboBox.SetFlat(Value : Boolean);
begin
  FBtn.Flat := Value;
end;


procedure TVirtualComboBox.EditChange(Sender : TObject);
begin
  FListform.currentText := FEdit.Text;
  if Trim(FEdit.Text) <> '' then
  begin
    if Assigned(FOnChange) then
      FOnChange(Self);
    FListForm.Hide;
  end;
end;

function TVirtualComboBox.GetText : string;
begin
  Result := FEdit.Text;
end;

procedure TVirtualComboBox.SetText(const Value : string);
begin
  FEdit.Text := Value;
end;

procedure TVirtualComboBox.DoEnter;
begin
  inherited;
//  FEdit.SetFocus;
end;




end.

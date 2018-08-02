{ Form Template - Source and Destination Choices Lists }
unit Halcn6pr;

interface

uses
   Classes,
  {$IFDEF WIN32}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, Buttons, StdCtrls, ExtCtrls,
  {$ENDIF}
  {$IFDEF LINUX}
  Types, QGraphics, QControls, QForms, QDialogs, QStdCtrls, QExtCtrls, QButtons,
  {$ENDIF}
   SysHalc;

type
  TIndexForm = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    SrcList: TListBox;
    DstList: TListBox;
    SrcLabel: TLabel;
    DstLabel: TLabel;
    IncludeBtn: TSpeedButton;
    IncAllBtn: TSpeedButton;
    ExcludeBtn: TSpeedButton;
    ExAllBtn: TSpeedButton;
    procedure IncludeBtnClick(Sender: TObject);
    procedure ExcludeBtnClick(Sender: TObject);
    procedure IncAllBtnClick(Sender: TObject);
    procedure ExcAllBtnClick(Sender: TObject);
    procedure MoveSelected(List: TCustomListBox; Items: TStrings);
    procedure SetItem(List: TListBox; Index: Integer);
    function GetFirstSelection(List: TCustomListBox): Integer;
    procedure SetButtons;
    procedure CancelBtnClick(Sender: TObject);
    procedure DstListClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IndexForm: TIndexForm;

implementation

{$R *.dfm}

procedure TIndexForm.IncludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := GetFirstSelection(SrcList);
  MoveSelected(SrcList, DstList.Items);
  SetItem(SrcList, Index);
end;

procedure TIndexForm.ExcludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := GetFirstSelection(DstList);
  MoveSelected(DstList, SrcList.Items);
  SetItem(DstList, Index);
end;

procedure TIndexForm.IncAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to SrcList.Items.Count - 1 do
    DstList.Items.AddObject(SrcList.Items[I],
      SrcList.Items.Objects[I]);
  SrcList.Items.Clear;
  SetItem(SrcList, 0);
end;

procedure TIndexForm.ExcAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to DstList.Items.Count - 1 do
    SrcList.Items.AddObject(DstList.Items[I], DstList.Items.Objects[I]);
  DstList.Items.Clear;
  SetItem(DstList, 0);
end;

procedure TIndexForm.MoveSelected(List: TCustomListBox; Items: TStrings);
var
  I: Integer;
begin
  for I := List.Items.Count - 1 downto 0 do
    if List.Selected[I] then
    begin
      Items.AddObject(List.Items[I], List.Items.Objects[I]);
      List.Items.Delete(I);
    end;
end;

procedure TIndexForm.SetButtons;
var
  SrcEmpty, DstEmpty: Boolean;
begin
  SrcEmpty := SrcList.Items.Count = 0;
  DstEmpty := DstList.Items.Count = 0;
  IncludeBtn.Enabled := not SrcEmpty;
  IncAllBtn.Enabled := not SrcEmpty;
  ExcludeBtn.Enabled := not DstEmpty;
  ExAllBtn.Enabled := not DstEmpty;
end;

function TIndexForm.GetFirstSelection(List: TCustomListBox): Integer;
begin
  for Result := 0 to List.Items.Count - 1 do
    if List.Selected[Result] then Exit;
  Result := -1;
end;

procedure TIndexForm.SetItem(List: TListBox; Index: Integer);
var
  MaxIndex: Integer;
begin
  with List do
  begin
    SetFocus;
    MaxIndex := List.Items.Count - 1;
    if Index = -1 then Index := 0
    else if Index > MaxIndex then Index := MaxIndex;
    Selected[Index] := True;
  end;
  SetButtons;
end;

procedure TIndexForm.CancelBtnClick(Sender: TObject);
begin
   Close;
end;

procedure TIndexForm.DstListClick(Sender: TObject);
begin
   SetButtons;
end;


procedure TIndexForm.FormActivate(Sender: TObject);
var
   i: integer;
   j: integer;
begin
   if DstList.Items.Count > 0 then
      for i := 0 to pred(DstList.Items.Count) do
      begin
         if SrcList.Items.Count > 0 then
         begin
            j := 0;
            while j < SrcList.Items.Count do
            begin
               if SrcList.Items[j] = DstList.Items[i] then
               begin
                  SrcList.Items.Delete(j);
                  j:= SrcList.Items.Count;
               end;
               inc(j);
            end;
         end;
      end;
   SetButtons;
end;
 end.

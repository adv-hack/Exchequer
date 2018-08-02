unit Zorder2;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TForm_ZOrder = class(TForm)
    Panel_Buttons: TPanel;
    Panel_List: TPanel;
    ListView1: TListView;
    Button_Options: TButton;
    Button_Close: TButton;
    Button_If: TButton;
    Button_MoveUp: TButton;
    Button_MoveDown: TButton;
    Button_Delete: TButton;
    Button_Find: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure Button_OptionsClick(Sender: TObject);
    procedure Button_MoveUpClick(Sender: TObject);
    procedure Button_CloseClick(Sender: TObject);
    procedure Button_IfClick(Sender: TObject);
    procedure Button_DeleteClick(Sender: TObject);
    procedure Button_FindClick(Sender: TObject);
  private
    { Private declarations }
    Procedure SetListItem (ListObj  : TControl;
                           ListItem : TListItem);
  public
    { Public declarations }
  end;

var
  Form_ZOrder: TForm_ZOrder;

implementation

{$R *.DFM}

Uses FormDesn, SBSDrag;

procedure TForm_ZOrder.FormCreate(Sender: TObject);
Var
  I : SmallInt;
begin
  With Form_Designer.FormController Do
    If (ControlList.Count > 0) Then
      For I := 0 To (ControlList.Count - 1) Do
        SetListItem (TSBSDragControl(ControlList.Items[I]), ListView1.Items.Add);
end;


Procedure TForm_ZOrder.SetListItem (ListObj  : TControl;
                                    ListItem : TListItem);
begin
  With TSBSDragControl(ListObj), ListItem Do Begin
    Data := ListObj;

    Caption := ControlId;

    SubItems.Clear;
    SubItems.Add (GetFieldInfo);
    SubItems.Add (GetIf.fiIf);
    SubItems.Add (GetPosStr);
  End; { With }
end;

procedure TForm_ZOrder.ListView1Click(Sender: TObject);
Var
  CurPos : TPoint;
  Tmp    : TListItem;
begin
  If (Not Assigned(ListView1.Selected)) And (ListView1.ViewStyle = vsReport) Then Begin
    { Try to highlight a match }
    GetCursorPos (CurPos);
    CurPos := ListView1.ScreenToClient(CurPos);
    CurPos.X := 10;
    Tmp := ListView1.GetItemAt(CurPos.X, CurPos.Y);
    If Assigned (Tmp) Then Begin
      ListView1.Selected := Tmp;
      ListView1.ItemFocused := Tmp;
    End; { If }
  End; { If }
end;

procedure TForm_ZOrder.Button_OptionsClick(Sender: TObject);
Var
  ListObj : TSBSDragControl;
begin
  { Get object from list }
  If Assigned (ListView1.Selected) Then Begin
    ListObj := TSBSDragControl(ListView1.Selected.Data);

    If ListObj.OptionsDialog Then
      SetListItem (ListObj, ListView1.Selected);
  End; { If }
end;


procedure TForm_ZOrder.Button_MoveUpClick(Sender: TObject);
Var
  ListObj1, ListObj2                   : TControl;
  TopIndex, BotIndex, Index, MoveIndex : Integer;
begin
  { Get object from list }
  If Assigned (ListView1.Selected) Then Begin
    Index := ListView1.Items.IndexOf (ListView1.Selected);

    TopIndex := -1;
    BotIndex := -1;
    If (Sender = Button_MoveUp) Then Begin
      { Move current column up 1 }
      If (Index > 0) Then Begin
        TopIndex  := Index - 1;
        BotIndex  := Index;
        MoveIndex := TopIndex;
      End { If }
    End { If }
    Else
      { Move Current column down 1 }
      If (Index < (ListView1.Items.Count - 1)) Then Begin
        TopIndex := Index;
        BotIndex := Index + 1;
        MoveIndex := BotIndex;
      End; { If }

    If (TopIndex >= 0) And (BotIndex >= 0) Then Begin
      With ListView1.Items Do Begin
        { Take copy of current }
        ListObj1 := Item[TopIndex].Data;
        ListObj2 := Item[BotIndex].Data;

        SetListItem (ListObj2, Item[TopIndex]);
        SetListItem (ListObj1, Item[BotIndex]);
      End; { With }

      { reposition on original row (now moved) }
      ListView1.Selected := ListView1.Items.Item[MoveIndex];
      ListView1.ItemFocused := ListView1.Items.Item[MoveIndex];

      Form_Designer.FormController.ControlList.Move (TopIndex, BotIndex);
    End; { If }
  End; { If }
end;

procedure TForm_ZOrder.Button_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_ZOrder.Button_IfClick(Sender: TObject);
Var
  ListObj : TSBSDragControl;
begin
  { Get object from list }
  If Assigned (ListView1.Selected) Then Begin
    { get copy of control }
    ListObj := TSBSDragControl(ListView1.Selected.Data);

    { tell the controller to use this control }
    Form_Designer.FormController.SetCurrControl (ListObj);

    { tell the controller to display the if dialog }
    Form_Designer.FormController.EditIf;

    { update the listview }
    SetListItem (ListObj, ListView1.Selected);
  End; { If }
end;

procedure TForm_ZOrder.Button_DeleteClick(Sender: TObject);
Var
  ListObj : TSBSDragControl;
begin
  { Get object from list }
  If Assigned (ListView1.Selected) Then Begin
    { get copy of control }
    ListObj := TSBSDragControl(ListView1.Selected.Data);

    If (MessageDlg ('Are you sure you want to delete ' + ListObj.ControlId + '?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then Begin
      { tell the controller to delete this control }
      Form_Designer.FormController.DeleteControl (ListObj);

      { remove from the listview }
      ListView1.Selected.Delete;
    End; { If }
  End; { If }
end;

procedure TForm_ZOrder.Button_FindClick(Sender: TObject);
Var
  ListObj : TSBSDragControl;
begin
  { Get object from list }
  If Assigned (ListView1.Selected) Then Begin
    { get copy of control }
    ListObj := TSBSDragControl(ListView1.Selected.Data);

    { tell the controller to delete this control }
    Form_Designer.SBSPage1.ScrollInView(ListObj);
  End; { If }
end;

end.

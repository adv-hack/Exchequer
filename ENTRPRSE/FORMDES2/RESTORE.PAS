unit restore;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TForm_Restore = class(TForm)
    Panel_Button: TPanel;
    Panel_List: TPanel;
    ListView1: TListView;
    Button_Restore: TButton;
    Button_Close: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure Button_RestoreClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Restore: TForm_Restore;

implementation

{$R *.DFM}

Uses FormDesn, SBSDrag;

procedure TForm_Restore.FormCreate(Sender: TObject);
Var
  I : SmallInt;
begin
  With Form_Designer.FormController Do
    If (HistoryList.Count > 0) Then
      For I := (HistoryList.Count - 1) DownTo 0 Do
        With ListView1.Items.Add, TSBSDragControl(HistoryList.Items[I]) Do Begin
          Data := HistoryList.Items[I];
          Caption := TimeToStr(DelTime);
          SubItems.Clear;
          SubItems.Add (ControlId);
          SubItems.Add (GetFieldInfo);
          SubItems.Add (GetPosStr);
        End; { With }
end;

procedure TForm_Restore.ListView1Click(Sender: TObject);
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

procedure TForm_Restore.Button_RestoreClick(Sender: TObject);
Var
  ListObj : TSBSDragControl;
  Index   : SmallInt;
begin
  { Get object from list }
  If Assigned (ListView1.Selected) Then Begin
    With Form_Designer.FormController Do Begin
      ListObj := TSBSDragControl(ListView1.Selected.Data);

      Index := HistoryList.IndexOf(ListObj);
      If (Index > -1) Then
        { check they want to restore it }
        If (MessageDlg ('Are you sure you want to restore ' + Trim(ListObj.ControlId) + ', deleted at ' + TimeToStr(ListObj.DelTime),
                        mtConfirmation,
                        [mbYes, mbNo],
                        0) = mrYes) Then Begin
          { remove from history list }
          HistoryList.Delete (Index);

          { restore item }
          ListObj.DelTime := 0;
          ControlList.Add (ListObj);
          ListObj.Show;

          { remove from listview }
          ListView1.Selected.Delete;
        End; { If }
    End; { With }

    If (ListView1.Items.Count = 0) Then Close;
  End; { If }
end;

end.

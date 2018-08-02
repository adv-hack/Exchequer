unit Sbscombo;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,Buttons,ExtCtrls,TEditVal;

Type
  TSBSCombo = class;

  TDropCount = 1..100;
  TSBSComboStyle = (sbsDropDown, sbsDropDownList);

  TSBSComboBtn = Class(TSpeedButton)
  Protected
    constructor Create (AOwner: TComponent); OverRide;
  End;

  TSBSComboEdit = Class(Text8Pt)
  Private
    FParent : TSBSCombo;
  Protected
    constructor Create(AOwner: TComponent); Override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); Override;
  Public
  Published
  End;

  TSBSCombo = class(TCustomPanel)
  private
    { Private declarations }
    EditControl : TSBSComboEdit;
    ListBtn     : TSBSComboBtn;
    ListForm    : TForm;
    ListBox     : TListBox;
    ListFormTag : LongInt;

    FDropCount    : TDropCount;
    FExtendList   : Boolean;
    FItemIndex    : Integer;
    FItems        : TStringList;
    FItemsL       : TStringList;
    FMaxListWidth : Integer;
    FReadOnly     : Boolean;
    FSorted       : Boolean;
    FStyle        : TSBSComboStyle;

    ButtClose     : Boolean;
    InMouseDown   : Boolean;

    Function  GetColor : TColor;
    Procedure SetColor(Value : TColor);

    Function  GetEnabled : Boolean;
    Procedure SetEnabled(Value : Boolean);

    Procedure SetExtList(FVal  :  Boolean);

    Function GetFont : TFont;
    Procedure SetFont(Value : TFont);

    Procedure SetItemIndex(Value : Integer);

    Procedure SetItems(Value : TStringList);
    Procedure SetItemsL(Value : TStringList);

    Function GetMaxLength : Integer;
    Procedure SetMaxLength (Value : Integer);

    Function  GetReadOnly : Boolean;
    Procedure SetReadOnly(Value : Boolean);

    Procedure SetStyle(Value : TSBSComboStyle);

    Function GetText : String;
    Procedure SetText (Value : String);

    Function  GetOnChange : TNotifyEvent;
    Procedure SetOnChange (Value : TNotifyEvent);

    Function  GetOnEnter : TNotifyEvent;
    Procedure SetOnEnter (Value : TNotifyEvent);

    Function  GetOnExit : TNotifyEvent;
    Procedure SetOnExit (Value : TNotifyEvent);

    Function  GetOnKeyPress : TKeyPressEvent;
    Procedure SetOnKeyPress(Value : TKeyPressEvent);

    Function  GetOnKeyUp : TKeyEvent;
    Procedure SetOnKeyUp(Value : TKeyEvent);

    Procedure EditControl_Exit(Sender: TObject);
    procedure EditControl_KeyDown(Sender: TObject; var Key: Word;
              Shift: TShiftState);
    procedure ListBtn_Click(Sender: TObject);
    procedure ListBtn_MouseDown(Sender: TObject;
              Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure ListForm_Deactivate(Sender: TObject);
    procedure ListForm_Close(Sender: TObject; var Action: TCloseAction);

    procedure ListBox_Click(Sender: TObject);
    procedure ListBox_KeyDown(Sender: TObject; var Key: Word;
              Shift: TShiftState);
    procedure ListBox_MouseDown(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState; X, Y: Integer);
    procedure ListBox_MouseUp(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState; X, Y: Integer);

    Procedure DispListItem;
  protected
    { Protected declarations }
    Procedure Resize; Override;
  public
    constructor Create(AOwner: TComponent); Override;
    destructor Destroy; Override;
    Procedure Loaded; Override;

    property ItemIndex: Integer read FItemIndex write SetItemIndex;
  published
    { Published declarations }
    Property Color : TColor read GetColor write SetColor;
    Property DropDownCount : TDropCount read FDropCount write FDropCount;
    Property Enabled : Boolean read GetEnabled write SetEnabled;
    property ExtendedList : Boolean read FExtendList  write SetExtList default false;
    Property Font : TFont read GetFont write SetFont;
    property Items: TStringList read FItems write SetItems;
    property ItemsL: TStringList read FItemsL write SetItemsL;
    Property MaxLength : Integer read GetMaxLength write SetMaxLength;
    Property MaxListWidth : Integer read FMaxListWidth write FMaxListWidth;
    property Sorted : Boolean read FSorted write FSorted Default False;
    Property ReadOnly : Boolean read FReadOnly write SetReadOnly;
    Property Style : TSBSComboStyle read FStyle write SetStyle;
    Property TabOrder;
    Property TabStop;
    Property Text : String read GetText write SetText;

    Property OnChange   : TNotifyEvent read GetOnChange write SetOnChange;
    Property OnEnter    : TNotifyEvent read GetOnEnter write SetOnEnter;
    Property OnExit     : TNotifyEvent read GetOnExit write SetOnExit;
    Property OnKeyDown;
    Property OnKeyPress : TKeyPressEvent read GetOnKeyPress write SetOnKeyPress;
    Property OnKeyUp    : TKeyEvent read GetOnKeyUp write SetOnKeyUp;
  end;

procedure Register;

implementation

Var
  IsNT : Boolean;

{****************************************************************************}
{* TSBSComboBtn: A special button for the TSBSCombo control                 *}
{****************************************************************************}
constructor TSBSComboBtn.Create (AOwner: TComponent);
Begin
  Inherited Create (AOwner);

  { Create a bitmap for the arrow }
  With Glyph Do Begin
    Height := 3;
    Width := 5;

    With Canvas Do Begin
      Pen.Color := clBlack;
      Pen.Style := psSolid;
      Pen.Mode  := pmCopy;

      Brush.Color := clBtnFace;
      Brush.Style := bsSolid;
      FillRect (Rect(0,0,Width,Height));

      MoveTo (0, 0); LineTo (5, 0);
      MoveTo (1, 1); LineTo (4, 1);
      Pixels[2, 2] := Pen.Color;
    End; { With }
  End; { With }
End;


{****************************************************************************}
{* TSBSComboEdit: A special edit control based on Text8pt. Needed to detect *}
{*                certain key combinations                                  *}
{****************************************************************************}
constructor TSBSComboEdit.Create(AOwner: TComponent);
Begin
  Inherited Create (AOwner);

  FParent := TSBSCombo(AOwner);
End;

procedure TSBSComboEdit.KeyDown(var Key: Word; Shift: TShiftState);

  Procedure ProcessIndex (Const NewIdx : Integer);
  Begin
    With FParent Do Begin
      ItemIndex := NewIdx;

      If (ItemIndex < 0) Then ItemIndex := 0;
      If (ItemIndex > (Items.Count - 1)) Then ItemIndex := (Items.Count - 1);

      DispListItem;

      Key := 0;
    End; { With }
  End;

Begin
  With FParent Do Begin
    If (Shift = []) Then Begin
      Case Key Of
        VK_PRIOR : ProcessIndex(ItemIndex - (DropDownCount - 1));
        VK_NEXT  : ProcessIndex(ItemIndex + (DropDownCount - 1));
        VK_END   : ProcessIndex(Items.Count - 1);
        VK_HOME  : ProcessIndex(0);
        VK_UP    : ProcessIndex(ItemIndex - 1);
        VK_DOWN  : ProcessIndex(ItemIndex + 1);
        VK_F4    : Begin
                     { display list }
                     ListBtn_Click(Self);
                     Key := 0;
                   End;

      End; { Case }
    End { If }
    Else Begin
      If (Key In [VK_UP, VK_DOWN]) And (ssAlt In Shift) Then Begin
        { display list }
        ListBtn_Click(Self);
        Key := 0;
      End; { If }

      If (Key In [VK_UP, VK_DOWN]) And (ssCtrl In Shift) Then Begin
        { display list }
        Case Key Of
          VK_UP    : ProcessIndex(ItemIndex - 1);
          VK_DOWN  : ProcessIndex(ItemIndex + 1);
        End; { Case }
      End; { If }
    End; { Else }
  End; { With }

  Inherited KeyDown (Key, Shift);
end;


{****************************************************************************}
{* TSBSCombo: A Combo Box built from existing controls with the aim of      *}
{*            reducing resource usage and giving us more control over how   *}
{*            it works (I'm really a meglomaniac at heart!)                 *}
{*                                                                          *}
{*            It is based on a TCustomPanel as the main container with a    *}
{*            TSBSComboEdit for the edit section of the control and a       *}
{*            TSBSComboBtn for the button. The list is actually a TForm     *}
{*            which has a TListBox aligned to its client area.              *}
{****************************************************************************}
constructor TSBSCombo.Create (AOwner: TComponent);
begin { TSBSCombo.Create }
  Inherited Create (AOwner);

  Height := 22;
  Width  := 145;

  { Reset inherited properties }
  BevelInner    := bvNone;
  If IsNT Then
    BevelOuter  := bvLowered
  Else
    BevelOuter  := bvNone;
  BorderStyle   := bsSingle;
  Caption       := '';
  Ctl3d         := True;
  ParentCtl3D   := False;

  { make sure all control handles are NIL }
  EditControl := Nil;
  ListBtn  := Nil;
  ListForm := Nil;
  ListBox  := Nil;

  { create properties }
  FItems  := TStringList.Create;
  FItemsL := TStringList.Create;

  { create and setup the button }
  ListBtn := TSBSComboBtn.Create(Self);
  Try
    With ListBtn Do Begin
      Parent := Self;

      Width  := GetSystemMetrics (SM_CXVSCROLL);
      Left   := Self.Width - ListBtn.Width - 4;
      Top    := 0;
      Height := Self.Height - 4;

      {OnClick     := ListBtn_Click;}
      OnMouseDown := ListBtn_MouseDown;
    End; { With }
  Except
    ListBtn.Free;
  End; {try..}

  { Create and setup the edit control }
  EditControl := TSBSComboEdit.Create(Self);
  Try
    With EditControl Do Begin
      Parent := Self;

      BorderStyle := bsNone;
      Ctl3D       := False;
      ParentCtl3D := False;

      Left   := 0;
      Width  := ListBtn.Left - 1;
      If IsNT Then Begin
        Top    := 0;
        Height := 10{Self.Height - 3}
      End { If }
      Else Begin
        Top    := 0;
        Height := Self.Height - 3;
      End; { Else }

      Text   := '';

      OnExit    := EditControl_Exit;
      OnKeyDown := EditControl_KeyDown;
    End; { With }
  Except
    EditControl.Free;
  End; { Try }

  { Initialise new properties }
  DropDownCount := 8;
  ExtendedList  := False;
  MaxListWidth  := 0;
  ReadOnly      := False;
  Style         := sbsDropDown;

  ListFormTag   := 0;

  ButtClose := False;

  { Call resize to position the controls correctly }
  Resize;
End;  { TSBSCombo.Create }

Destructor TSBSCombo.Destroy;
Begin
  { free properties }
  FItems.Free;
  FItemsL.Free;

  Inherited;
End;

Procedure TSBSCombo.Loaded;
Begin
  Inherited Loaded;

  { Just make sure its blank }
  Caption := '';

  { Have to do this as resize is not being called for some reason }
  { if the width has been changed at design-time                  }
  Resize;
End;

Procedure TSBSCombo.Resize;
Begin
  Inherited;

  { resize/position list button }
  ListBtn.Left   := Width  - ListBtn.Width - 4;
  ListBtn.Height := Height - 4;

  { resize/position edit control }
  EditControl.Width  := ListBtn.Left - 1;
  {EditControl.Height := Height - 3;}
  If IsNT Then
    EditControl.Height := 10{Self.Height - 3}
  Else
    EditControl.Height := Self.Height - 3;

  { call resize event }
  If (Assigned(OnResize)) then
    OnReSize(Self);
end;

Function TSBSCombo.GetColor : TColor;
Begin
  Result := EditControl.Color;
End;

Procedure TSBSCombo.SetColor(Value : TColor);
Begin
  EditControl.Color := Value;
End;

Function TSBSCombo.GetEnabled : Boolean;
Begin
  Result := EditControl.Enabled;
End;

Procedure TSBSCombo.SetEnabled(Value : Boolean);
Begin
  EditControl.Enabled := Value;
  ListBtn.Enabled := (Not FReadOnly) And EditControl.Enabled;
End;

Function TSBSCombo.GetFont : TFont;
Begin
  Result := EditControl.Font;
End;

Procedure TSBSCombo.SetFont(Value : TFont);
Begin
  EditControl.Font := Value;
End;

Procedure TSBSCombo.SetItemIndex(Value : Integer);
Begin
  If (Value <> FItemIndex) Then Begin
    FItemIndex := Value;

    { update list? if currently displayed }
  End; { If }
End;

Procedure TSBSCombo.SetItems(Value : TStringList);
begin
  FItems.Assign(Value);
end;

Procedure TSBSCombo.SetItemsL(Value : TStringList);
begin
  FItemsL.Assign(Value);
end;

Procedure TSBSCombo.SetExtList(FVal : Boolean);
Begin
  If (FExtendList <> FVal) then
    FExtendList := FVal;
end;

Function TSBSCombo.GetMaxLength : Integer;
Begin
  Result := EditControl.MaxLength;
End;

Procedure TSBSCombo.SetMaxLength (Value : Integer);
Begin
  EditControl.MaxLength := Value;
End;

Function TSBSCombo.GetReadOnly : Boolean;
Begin
  Result := FReadOnly;
End;

Procedure TSBSCombo.SetReadOnly(Value : Boolean);
Begin
  FReadOnly := Value;
  EditControl.ReadOnly := Value Or (Style = sbsDropDownList);
  ListBtn.Enabled := (Not FReadOnly) And EditControl.Enabled;
End;

Procedure TSBSCombo.SetStyle(Value : TSBSComboStyle);
Begin
  FStyle := Value;
  EditControl.ReadOnly := FReadOnly Or (Style = sbsDropDownList);
End;

Function TSBSCombo.GetText : String;
Begin
  Result := EditControl.Text;
End;

Procedure TSBSCombo.SetText (Value : String);
Begin
  EditControl.Text := Value;
End;

Function  TSBSCombo.GetOnChange : TNotifyEvent;
Begin
  Result := EditControl.OnChange;
End;

Procedure TSBSCombo.SetOnChange (Value : TNotifyEvent);
Begin
  EditControl.OnChange := Value;
End;

Function  TSBSCombo.GetOnEnter : TNotifyEvent;
Begin
  Result := EditControl.OnEnter;
End;

Procedure TSBSCombo.SetOnEnter (Value : TNotifyEvent);
Begin
  EditControl.OnEnter := Value;
End;

Function  TSBSCombo.GetOnExit : TNotifyEvent;
Begin
  Result := EditControl.OnExit;
End;

Procedure TSBSCombo.SetOnExit (Value : TNotifyEvent);
Begin
  EditControl.OnExit := Value;
End;

Function  TSBSCombo.GetOnKeyPress : TKeyPressEvent;
Begin
  Result := EditControl.OnKeyPress;
End;

Procedure TSBSCombo.SetOnKeyPress(Value : TKeyPressEvent);
Begin
  EditControl.OnKeyPress := Value;
End;

Function  TSBSCombo.GetOnKeyUp : TKeyEvent;
Begin
  Result := EditControl.OnKeyUp;
End;

Procedure TSBSCombo.SetOnKeyUp(Value : TKeyEvent);
Begin
  EditControl.OnKeyUp := Value;
End;


{****************************************************************************}
{* Event Handlers for EditControl                                           *}
{****************************************************************************}
Procedure TSBSCombo.EditControl_Exit(Sender: TObject);
Begin
  If Assigned(ListForm) Then
    If (Screen.ActiveControl <> ListForm) Then
      ListForm.Close;
End;

procedure TSBSCombo.EditControl_KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Begin
  If Assigned(OnKeyDown) Then
    OnKeyDown (Sender, Key, Shift);
End;

Procedure TSBSCombo.DispListItem;
Begin
  EditControl.Text := Items.Strings[ItemIndex];
  EditControl.SelStart := 0;
  EditControl.SelLength := Length(EditControl.Text);
End;


{****************************************************************************}
{* Event Handlers for ListBtn                                               *}
{****************************************************************************}
procedure TSBSCombo.ListBtn_Click(Sender: TObject);
Var
  LText   : ShortString;
  I       : Integer;
  FoundOK : Boolean;
Begin
  If Not Assigned (ListForm) Then Begin
    ListFormTag := 0;

    ListForm := TForm.Create (Self);
    Try
      { Initialise the Form }
      With ListForm Do Begin
        BorderIcons := [];
        BorderStyle := bsNone;
        Caption     := 'sdfsdf';
        Font.Assign (EditControl.Font);
        FormStyle   := fsStayOnTop;
        Height      := 100;
        HelpContext := EditControl.HelpContext;
        Hint        := EditControl.Hint;
        KeyPreview  := True;
        Left        := Self.Parent.ClientToScreen(Point(Self.Left,1)).X{ + 1};
        Top         := Self.Parent.ClientToScreen(Point(1, Self.Top)).Y + Self.Height;
        If ExtendedList And (MaxListWidth > (Self.Width - 2)) Then Begin
          { Extra wide megamix version }
          Width := MaxListWidth;

          If (Width > Screen.Width) Then
            Width := Screen.Width - 2;
        End { If }
        Else
          { boring bog-standard version }
          Width := Self.Width;

        OnClose      := ListForm_Close;
        OnDeactivate := ListForm_Deactivate;
      End; { With }

      { create list and stick it in ListForm }
      ListBox := TListBox.Create(ListForm);
      With ListBox Do Begin
        Parent      := ListForm;

        Align       := alClient;
        Color       := EditControl.Color;
        Ctl3D       := False;
        Font.Assign (EditControl.Font);
        Case ExtendedList Of
          False : Items.Assign (Self.Items);
          True  : Items.Assign (Self.ItemsL);
        End; { Case }
        ItemIndex   := Self.ItemIndex;
        Sorted      := FSorted;

        OnClick     := ListBox_Click;
        OnKeyDown   := ListBox_KeyDown;
        OnMouseDown := ListBox_MouseDown;
        OnMouseUp   := ListBox_MouseUp;
      End; { With }

      ListForm.Height := (DropDownCount * ListBox.ItemHeight) + 2;
      If (ListForm.Height > Screen.Height) Then Begin
        ListForm.Top := 1;
        ListForm.Height := Screen.Height - 2;
      End; { If }

      { Check its in an ok position }
      If ((ListForm.Top + ListForm.Height) > Screen.Height) Then Begin
        { goes off bottom of screen - display upwards from top of combo }
        ListForm.Top := Self.Parent.ClientToScreen(Point(1, Self.Top)).Y - ListForm.Height;
      End; { If }

      If ((ListForm.Left + ListForm.Width) > Screen.Width) Then Begin
        { goes off side of screen - display ? }
        ListForm.Left := Screen.Width - ListForm.Width;
      End; { If }

      { Try to find a match with what the user has typed in }
      If (Style = sbsDropDown) Then Begin
        LText:=UpperCase(TrimRight(Text));

        With Items Do
          For I := 0 To Pred(Count) Do Begin
            FoundOk := (CompareText(LText,UpperCase(Copy(Strings[I],1,Length(LText))))=0);

            If (Not FoundOk) then
              FoundOk := (CompareText(LText,UpperCase(Copy(ItemsL.Strings[I],1,Length(LText))))=0);

            If (FoundOk) Then Begin
              ListBox.ItemIndex := I;
              Break;
            End; { If }
          End; { For }
      End; { If }

      InMouseDown := False;

      { Display the list }
      ListForm.Show;
    Except
      ListForm.Free;
    End; { Try }
  End; { If }
End;

procedure TSBSCombo.ListBtn_MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  If (Not ButtClose) Then
    ListBtn_Click(Sender)
  Else
    ButtClose := False;
End;


{****************************************************************************}
{* Event Handlers for ListForm                                              *}
{****************************************************************************}
procedure TSBSCombo.ListForm_Deactivate(Sender: TObject);
Var
  CurPos   : TPoint;
  ButtRect : TRect;
begin
  { Generated when focus has been lost to another control }

  { need to see whether focus has been lost because of the button }
  { can do this by checking the mouse position                    }
  GetCursorPos(CurPos);

  { convert button position to screen coords }
  ButtRect.TopLeft := ClientToScreen(ListBtn.BoundsRect.TopLeft);
  ButtRect.BottomRight := ClientToScreen(ListBtn.BoundsRect.BottomRight);

  ButtClose := (CurPos.X >= ButtRect.Left) And
               (CurPos.X <= ButtRect.Right) And
               (CurPos.Y >= ButtRect.Top) And
               (CurPos.Y <= ButtRect.Bottom);

  { close form - removes the popup list }
  ListForm.Close;
end;

procedure TSBSCombo.ListForm_Close(Sender: TObject; var Action: TCloseAction);
begin
  { Deallocate memory for form }
  ListForm := Nil;
  Action := caFree;
end;


{****************************************************************************}
{* Event Handlers for ListBox                                               *}
{****************************************************************************}
procedure TSBSCombo.ListBox_Click(Sender: TObject);
Begin
  If (ListBox.ItemIndex > -1) Then Begin
    Self.ItemIndex := ListBox.ItemIndex;
    DispListItem;
  End; { If }

  If InMouseDown Then EditControl.SetFocus;
End;

procedure TSBSCombo.ListBox_KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Begin
  If (Key = VK_RETURN) Or
     ((Key In [VK_F4, VK_ESCAPE]) And (Shift = [])) Or
     ((Key In [VK_UP, VK_DOWN]) And ((ssCtrl In Shift) Or (ssAlt In Shift))) Then
    EditControl.SetFocus;
End;

procedure TSBSCombo.ListBox_MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  InMouseDown := True;
end;

procedure TSBSCombo.ListBox_MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  InMouseDown := False;
end;

procedure Register;
begin
  RegisterComponents('SBS', [TSBSCombo]);
end;

Begin
  IsNT := True;
end.



unit Tcustdlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, TEditVal, BorBtns, BkGroup, SBSPanel, Menus;

type
  TComponentType = (ctUnknown, { Anything not listed below }
                    ctLabel8,  { Label8 }
                    ctText8,   { Text8Pt }
                    ctBackGrp, { TSBSBackGroup }
                    ctCheck,   { TBorCheck }
                    ctRadio,   { TBorRadio }
                    ctCcyEdit, { TCurrencyEdit }
                    ctGroup,   { TSBSGroup - NOTE: Derived from TSBSPanel }
                    ctPanel,   { TSBSPanel }
                    ctButton   { TSBSBUTTON }
                    );

  TComponentParser = Class(TObject)
  Private
    FComponent : TComponent;
    FCompType : TComponentType;
    FFilterOpts : Array [TComponentType] Of Boolean;

    Constructor Create;

    Function  GetCaption : ShortString;
    Procedure SetCaption(Value : ShortString);
    Procedure SetComponent(Value : TComponent);
    Function  GetGotCustomControl : Boolean;
    Function  GetName : ShortString;
    Function  GetTextId : LongInt;
    Procedure SetTextId(Value : LongInt);
    Function  GetFilterOpts(Index : TComponentType) : Boolean;
    Procedure SetFilterOpts(Index : TComponentType; Value : Boolean);
  Public
    Property Caption : ShortString Read GetCaption Write SetCaption;
    Property Component : TComponent Read FComponent Write SetComponent;
    Property GotCustomControl : Boolean Read GetGotCustomControl;
    Property FilterOpts[Index:TComponentType] : Boolean Read GetFilterOpts Write SetFilterOpts;
    Property Name : ShortString Read GetName;
    Property TextId : LongInt Read GetTextId Write SetTextId;

    Function Font : TFont;
    Function RCString(Const RCBase : LongInt) : String;
    Function WantComponent : Boolean;
  End; { TComponentParser }

  TCustomisationDlg = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ListView1: TListView;
    Panel3: TPanel;
    Label2: TLabel;
    ListView2: TListView;
    Panel4: TPanel;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    mnu_File: TMenuItem;
    mnuo_Exit: TMenuItem;
    Filter1: TMenuItem;
    mnuo_compLabel: TMenuItem;
    Bevel1: TBevel;
    mnuo_CompText8Pt: TMenuItem;
    mnuo_CompTSBSBackGroup: TMenuItem;
    mnuo_CompTBorCheck: TMenuItem;
    mnuo_CompTBorRadio: TMenuItem;
    mnuo_CompTCurrencyEdit: TMenuItem;
    mnuo_CompTSBSPanel: TMenuItem;
    mnuo_CompTSBSGroup: TMenuItem;
    Export1: TMenuItem;
    mnuo_ToRC: TMenuItem;
    mnuo_CompTSBSButton: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure ListView2Click(Sender: TObject);
    procedure ListView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListView2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListView2DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListView2DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure mnuo_ExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Filter1Click(Sender: TObject);
    procedure mnuo_compxxxClick(Sender: TObject);
    procedure mnuo_ToRCClick(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
  private
    { Private declarations }
    FCustomControl : TComponent;
    FForm          : TForm;
    CompPars       : TComponentParser;

    Procedure ExportText(Const ExpMode : Byte);
    Procedure LoadCustomised;
    Procedure LoadNonCustomised;
    Procedure AddToCustList(TheComponent:TComponent;TheItem:TListItem;TextId:LongInt);
    Procedure AddToNonCust(TheComponent:TComponent;TheItem:TListItem);
    Procedure SetCustomControl(Value : TComponent);
    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
    Property CustomControl : TComponent Read FCustomControl Write SetCustomControl;
  end;


implementation

{$R *.DFM}

Uses TCustom, WinMapU;


{==============================================================================}


{ Initialises an instance of the Component Parser }
Constructor TComponentParser.Create;
Var
  I : TComponentType;
Begin
  Inherited Create;

  { Turn off all controls except Labels }
  For I := Low(FFilterOpts) To High (FFilterOpts) Do
    FFilterOpts[I] := False;
  FFilterOpts[ctLabel8] := True;
End;


{ Returns the Caption/Text of the control }
Function TComponentParser.GetCaption : ShortString;
Begin
  Case FCompType Of
    ctLabel8  : Result := Label8(FComponent).Caption;
    ctText8   : Result := Text8Pt(FComponent).Text;
    ctBackGrp : Result := TSBSBackGroup(FComponent).Caption;
    ctCheck   : Result := TBorCheck(FComponent).Caption;
    ctRadio   : Result := TBorRadio(FComponent).Caption;
    ctCcyEdit : Result := TCurrencyEdit(FComponent).Text;
    ctGroup   : Result := TSBSGroup(FComponent).Caption;
    ctPanel   : Result := TSBSPanel(FComponent).Caption;
    ctButton  : Result := TSBSButton(FComponent).Caption;
  Else
    { Serious problems if it drops in here }
    Result := '';
  End; { Case }
End;


{ Sets the Controls Caption }
Procedure TComponentParser.SetCaption(Value : ShortString);
Begin
  Case FCompType Of
    ctLabel8  : Label8(FComponent).Caption := Value;
    ctText8   : Text8Pt(FComponent).Text := Value;
    ctBackGrp : TSBSBackGroup(FComponent).Caption := Value;
    ctCheck   : TBorCheck(FComponent).Caption := Value;
    ctRadio   : TBorRadio(FComponent).Caption := Value;
    ctCcyEdit : TCurrencyEdit(FComponent).Text := Value;
    ctGroup   : TSBSGroup(FComponent).Caption := Value;
    ctPanel   : TSBSPanel(FComponent).Caption := Value;
    ctButton  : TSBSButton(FComponent).Caption := Value;
  Else
    { Serious problems if it drops in here }
  End; { Case }
End;


{ Sets the component into the local variable and analyses it }
Procedure TComponentParser.SetComponent(Value : TComponent);
Begin
  If (Value <> FComponent) Then Begin
    FComponent := Value;

    { Id Type of component }
    FCompType := ctUnknown;
    If (FComponent Is Label8) Then
      FCompType := ctLabel8
    Else
      If (FComponent Is Text8Pt) Then
        FCompType := ctText8
      Else
        If (FComponent Is TSBSBackGroup) Then
          FCompType := ctBackGrp
        Else
          If (FComponent Is TBorCheck) Then
            FCompType := ctCheck
          Else
            If (FComponent Is TBorRadio) Then
              FCompType := ctRadio
            Else
              If (FComponent Is TCurrencyEdit) Then
                FCompType := ctCcyEdit
              Else
                If (FComponent Is TSBSGroup) Then
                  FCompType := ctGroup
                Else
                  If (FComponent Is TSBSPanel) Then
                    FCompType := ctPanel
                  Else
                    If (FComponent Is TSBSButton) Then
                      FCompType := ctButton;
  End; { If }
End;


{ Returns True if the Component is Customisable }
Function TComponentParser.GetGotCustomControl : Boolean;
Begin
  Result := (FCompType <> ctUnknown);
End;


{ Returns the name of the control }
Function TComponentParser.GetName : ShortString;
Begin
  Case FCompType Of
    ctLabel8  : Result := Label8(FComponent).Name;
    ctText8   : Result := Text8Pt(FComponent).Name;
    ctBackGrp : Result := TSBSBackGroup(FComponent).Name;
    ctCheck   : Result := TBorCheck(FComponent).Name;
    ctRadio   : Result := TBorRadio(FComponent).Name;
    ctCcyEdit : Result := TCurrencyEdit(FComponent).Name;
    ctGroup   : Result := TSBSGroup(FComponent).Name;
    ctPanel   : Result := TSBSPanel(FComponent).Name;
    ctButton  : Result := TSBSButton(FComponent).Name;
  Else
    { Serious problems if it drops in here }
    Result := 'Unknown';
  End; { Case }
End;


{ Returns the TextId from the component }
Function TComponentParser.GetTextId : LongInt;
Begin
  Case FCompType Of
    ctLabel8  : Result := Label8(FComponent).TextId;
    ctText8   : Result := Text8Pt(FComponent).TextId;
    ctBackGrp : Result := TSBSBackGroup(FComponent).TextId;
    ctCheck   : Result := TBorCheck(FComponent).TextId;
    ctRadio   : Result := TBorRadio(FComponent).TextId;
    ctCcyEdit : Result := TCurrencyEdit(FComponent).TextId;
    ctGroup   : Result := TSBSGroup(FComponent).TextId;
    ctPanel   : Result := TSBSPanel(FComponent).TextId;
    ctButton  : Result := TSBSButton(FComponent).TextId;
  Else
    { Serious problems if it drops in here }
    Result := -1; //PR: 22/03/2016 v2016 R2 ABSEXCH-17390

  End; { Case }
End;


{ Sets the TextId of the component }
Procedure TComponentParser.SetTextId(Value : LongInt);
Begin
  Case FCompType Of
    ctLabel8  : Label8(FComponent).TextId := Value;
    ctText8   : Text8Pt(FComponent).TextId := Value;
    ctBackGrp : TSBSBackGroup(FComponent).TextId := Value;
    ctCheck   : TBorCheck(FComponent).TextId := Value;
    ctRadio   : TBorRadio(FComponent).TextId := Value;
    ctCcyEdit : TCurrencyEdit(FComponent).TextId := Value;
    ctGroup   : TSBSGroup(FComponent).TextId := Value;
    ctPanel   : TSBSPanel(FComponent).TextId := Value;
    ctButton  : TSBSButton(FComponent).TextId := Value;
  Else
    { Serious problems if it drops in here }
  End; { Case }
End;


{ Returns the Filter Flag for a specified Component Type }
Function TComponentParser.GetFilterOpts(Index : TComponentType) : Boolean;
Begin
  Result := FFilterOpts[Index];
End;


{ Sets the filter flag }
Procedure TComponentParser.SetFilterOpts(Index : TComponentType; Value : Boolean);
Begin
  FFilterOpts[Index] := Value;
End;


{ Returns True if the component type is selecter in the filtering options }
Function TComponentParser.WantComponent : Boolean;
Begin
  Result := FFilterOpts[FCompType];
End;


{ Returns the Font of the current component }
Function TComponentParser.Font : TFont;
Begin
  Result := Nil;

  Case FCompType Of
    ctLabel8  : Result := Label8(FComponent).Font;
    ctText8   : Result := Text8Pt(FComponent).Font;
    ctBackGrp : Result := TSBSBackGroup(FComponent).Font;
    ctCheck   : Result := TBorCheck(FComponent).Font;
    ctRadio   : Result := TBorRadio(FComponent).Font;
    ctCcyEdit : Result := TCurrencyEdit(FComponent).Font;
    ctGroup   : Result := TSBSGroup(FComponent).Font;
    ctPanel   : Result := TSBSPanel(FComponent).Font;
    ctButton  : Result := TSBSButton(FComponent).Font;
  End; { Case }
End;


{ Returns a String for a .RC file }
Function TComponentParser.RCString(Const RCBase : LongInt) : String;
Var
  OutStr   : String;
  StyleStr : String[4];
  TmpFont  : TFont;
Begin
  { Get Font }
  OutStr := '';
  TmpFont := Font;
  If Assigned(TmpFont) Then Begin
    { Format style into string }
    StyleStr := 'bius';
    If (fsBold In TmpFont.Style) Then StyleStr[1] := 'B';
    If (fsItalic In TmpFont.Style) Then StyleStr[2] := 'I';
    If (fsUnderline In TmpFont.Style) Then StyleStr[3] := 'U';
    If (fsStrikeout In TmpFont.Style) Then StyleStr[4] := 'S';

    { Build CSV String }
    OutStr := '  ' +
              IntToStr(RCBase + TextId) +
              ', "T,' +
              Caption + ',' +
              TmpFont.Name + ',' +
              IntToStr(TmpFont.Size) + ',' +
              StyleStr + ',' +
              IntToStr(Ord(TmpFont.Color)) + '"';
  End; { If }

  Result := OutStr;
End;


{==============================================================================}


procedure TCustomisationDlg.FormCreate(Sender: TObject);
begin
  FCustomControl := Nil;
  FForm := Nil;

  { Create a Component Parser which can be used to identify and manipulate the components }
  CompPars := TComponentParser.Create;
end;

procedure TCustomisationDlg.FormDestroy(Sender: TObject);
begin
  { Free the Component Parser }
  CompPars.Free;
end;

Procedure TCustomisationDlg.WMGetMinMaxInfo(Var Message : TWMGetMinMaxInfo);
Begin
  With Message.MinMaxInfo^ do Begin
    ptMinTrackSize.X:=440;
    ptMinTrackSize.Y:=100;

    ptMaxTrackSize.X:=900;
    ptMaxTrackSize.Y:=900;
  end;

  Message.Result:=0;

  Inherited;
end;


{ Initialises the passed TListItem for the non-customised list }
Procedure TCustomisationDlg.AddToNonCust(TheComponent:TComponent;TheItem:TListItem);
Begin
  CompPars.Component := TheComponent;

  With TheItem Do Begin
    Data := TheComponent;

    Caption := CompPars.Name;
    SubItems.Clear;
    SubItems.Add (CompPars.Caption);
  End { With }
End;


{ Initialises the passed TListItem for the non-customised list }
Procedure TCustomisationDlg.AddToCustList(TheComponent:TComponent;TheItem:TListItem;TextId:LongInt);
Var
  CapStr : String[3];
  I      : Byte;
Begin
  CompPars.Component := TheComponent;
  If (TextId <> -1) Then
    CompPars.TextId := TextId;

  { Format TextId into rightnjustify - padded with spaces }
  CapStr := IntToStr(CompPars.TextId);
  If (Length(CapStr) < 3) Then
    For I := Succ(Length(CapStr)) To 3 Do
      CapStr := ' ' + CapStr;

  With TheItem Do Begin
    Data := TheComponent;

    Caption := CapStr;
    SubItems.Clear;
    SubItems.Add (CompPars.Caption);
    SubItems.Add (CompPars.Name);
  End { With }
End;


{ Loads the Non-Customised Controls List }
Procedure TCustomisationDlg.LoadNonCustomised;
Var
  I : SmallInt;
Begin
  { Clear any existing components }
  ListView1.Items.Clear;

  { Check their are some components }
  If (FForm.ComponentCount > 0) Then Begin
    { Step through list of components }
    For I := 0 To Pred(FForm.ComponentCount) Do Begin
      CompPars.Component := FForm.Components[I];

      { And see if they are customisable }
      If CompPars.GotCustomControl And
         CompPars.WantComponent And
         (CompPars.TextId = 0) Then
        AddToNonCust(CompPars.Component, ListView1.Items.Add);
    End; { For }
  End; { If }
End;

{ Loads the Customised Controls List }
Procedure TCustomisationDlg.LoadCustomised;
Var
  I : SmallInt;
Begin
  { Clear any existing components }
  ListView2.Items.Clear;

  { Check their are some components }
  If (FForm.ComponentCount > 0) Then Begin
    { Step through list of components }
    For I := 0 To Pred(FForm.ComponentCount) Do Begin
      CompPars.Component := FForm.Components[I];

      { And see if they are customisable }
      If CompPars.GotCustomControl And
         (CompPars.TextId <> 0) Then
        AddToCustList(CompPars.Component, ListView2.Items.Add,-1);
    End; { For }

    { Sort into ascending TextId order }
    ListView2.SortType := stText;
    ListView2.SortType := stNone;
  End; { If }
End;


Procedure TCustomisationDlg.SetCustomControl(Value : TComponent);
Var
  I     : SmallInt;
  TmpLV : TListView;
Begin
  FCustomControl := Value;
  FForm := TForm(FCustomControl.Owner);
  Caption := FForm.Name + '.' + FCustomControl.Name + ' - TextId Editor';

  LoadNonCustomised;
  LoadCustomised;
End;


procedure TCustomisationDlg.Button1Click(Sender: TObject);
begin
  Close;
end;


procedure TCustomisationDlg.ListView1Click(Sender: TObject);
Var
  CurPos  : TPoint;
  Tmp     : TListItem;
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

procedure TCustomisationDlg.ListView2Click(Sender: TObject);
Var
  CurPos  : TPoint;
  Tmp     : TListItem;
begin
  If (Not Assigned(ListView2.Selected)) And (ListView2.ViewStyle = vsReport) Then Begin
    { Try to highlight a match }
    GetCursorPos (CurPos);
    CurPos := ListView2.ScreenToClient(CurPos);
    CurPos.X := 10;
    Tmp := ListView2.GetItemAt(CurPos.X, CurPos.Y);
    If Assigned (Tmp) Then Begin
      ListView2.Selected := Tmp;
      ListView2.ItemFocused := Tmp;
    End; { If }
  End; { If }
end;

procedure TCustomisationDlg.ListView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  TmpItem : TListItem;
begin
  { only drag if left button pressed }
  if Button = mbLeft then
    with Sender as TListView do begin
      TmpItem := GetItemAt(10, Y);
      If Assigned(TmpItem) Then Begin
        ListView1.Selected := TmpItem;
        BeginDrag(False);
      End; { If }
    end;
end;

procedure TCustomisationDlg.ListView2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  TmpItem : TListItem;
begin
  { only drag if left button pressed }
  if Button = mbLeft then
    with Sender as TListView do begin
      TmpItem := GetItemAt(10, Y);
      If Assigned(TmpItem) Then Begin
        ListView2.Selected := TmpItem;
        BeginDrag(False);
      End; { If }
    end;
end;

procedure TCustomisationDlg.ListView1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := False;
  If Source Is TListView Then
    Accept := True;
end;

procedure TCustomisationDlg.ListView2DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := False;
  If Source Is TListView Then
    Accept := True;
end;

procedure TCustomisationDlg.ListView2DragDrop(Sender, Source: TObject; X,
  Y: Integer);
Var
  TmpList          : TListItem;
  I, Id, NextId, J : SmallInt;
begin
  If Source is TListView then
    If (Source = ListView1) And Assigned(ListView1.Selected) Then Begin
      { Have dragged non-customised to customised }
      TmpList := ListView2.GetItemAt(10, Y);
      If Assigned(TmpList) Then
        I := Succ(TmpList.Index)
      Else
        I := 0;
      If (I > 0) Then Begin
        { Find Text Id of control that is being overwritten }
        CompPars.Component := TmpList.Data;
        Id := Succ(CompPars.TextId);

        { Insert new item at position }
        TmpList := ListView2.Items.Insert(I);

        { Renumber from that point down }
        If (TmpList.Index < Pred(ListView2.Items.Count)) Then Begin
          { Calculate next number }
          NextId := Id;

          { Go through controls increasing as necessary }
          For J := Succ(TmpList.Index) To Pred(ListView2.Items.Count) Do Begin
            CompPars.Component := ListView2.Items[J].Data;
            If (CompPars.TextId <= NextId) Then Begin
              NextId := Succ(CompPars.TextId);

              CompPars.TextId := Succ(CompPars.TextId);
              AddToCustList(CompPars.Component, ListView2.Items[J], -1);
            End { If }
            Else
              { Found a spare }
              Break;
          End; { For }
        End; { If }
      End { If }
      Else Begin
        { Find Text Id of last control }
        CompPars.Component := ListView2.Items[Pred(ListView2.Items.Count)].Data;
        Id := Succ(CompPars.TextId);

        { Add new item at end of list }
        TmpList := ListView2.Items.Add;
      End; { Else }

      AddToCustList(ListView1.Selected.Data, TmpList, Id);

      { Delete item at original position }
      ListView1.Selected.Delete;

      { Select new item }
      ListView2.SetFocus;
      ListView2.Selected := TmpList;
      ListView2.ItemFocused := TmpList;
    End { If }
    Else
      If (Source = ListView2) Then Begin
        { Dragged within ListView2 }
        TmpList := ListView2.GetItemAt(10, Y);
        If Assigned(TmpList) Then
          I := Succ(TmpList.Index)
        Else
          I := 0;
        If (I > 0) Then Begin
          { Calc new TextId }
          CompPars.Component := TmpList.Data;
          Id := Succ(CompPars.TextId);

          { Insert new item at position }
          TmpList := ListView2.Items.Insert(I);
          AddToCustList(ListView2.Selected.Data, TmpList, Id);

          { Delete item at original position }
          ListView2.Selected.Delete;

          { Select new item }
          ListView2.Selected := TmpList;
          ListView2.ItemFocused := TmpList;

          { Renumber from that point down }
          If (TmpList.Index < Pred(ListView2.Items.Count)) Then Begin
            { Calculate next number }
            NextId := Id;

            { Go through controls increasing as necessary }
            For J := Succ(TmpList.Index) To Pred(ListView2.Items.Count) Do Begin
              CompPars.Component := ListView2.Items[J].Data;
              If (CompPars.TextId <= NextId) Then Begin
                NextId := Succ(CompPars.TextId);

                CompPars.TextId := Succ(CompPars.TextId);
                AddToCustList(CompPars.Component, ListView2.Items[J], -1);
              End { If }
              Else
                { Found a spare }
                Break;
            End; { For }
          End; { If }
        End; { If }
      End; { If }
end;

procedure TCustomisationDlg.ListView1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
Var
  TmpList : TListItem;
  I       : SmallInt;
begin
  If Source is TListView then
    If (Source = ListView2) And Assigned(ListView2.Selected) Then Begin
      { Have dragged from Customised List to Non-Customised }
      CompPars.Component := ListView2.Selected.Data;
      CompPars.TextId := 0;
      If CompPars.WantComponent Then Begin
        I := Succ(ListView1.Items.IndexOf(ListView1.GetItemAt(10, Y)));
        If (I > 0) Then
          { Insert new item at position }
          TmpList := ListView1.Items.Insert(I)
        Else
          { Add new item at end of list }
          TmpList := ListView1.Items.Add;

        AddToNonCust(ListView2.Selected.Data,TmpList);

        { Delete item at original position }
        ListView2.Selected.Delete;

        { Select new item }
        ListView1.SetFocus;
        ListView1.Selected := TmpList;
        ListView1.ItemFocused := TmpList;
      End { If }
      Else
        { Component didn't make it past the filter }
        ListView2.Selected.Delete;
    End { If }
    Else
      If (Source = ListView1) Then Begin
        I := Succ(ListView1.Items.IndexOf(ListView1.GetItemAt(10, Y)));
        If (I > 0) Then Begin
          { Insert new item at position }
          TmpList := ListView1.Items.Insert(I);
          AddToNonCust(ListView1.Selected.Data,TmpList);

          { Delete item at original position }
          ListView1.Selected.Delete;

          { Select new item }
          ListView1.Selected := TmpList;
          ListView1.ItemFocused := TmpList;
        End; { If }
      End; { If }
end;

procedure TCustomisationDlg.mnuo_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TCustomisationDlg.Filter1Click(Sender: TObject);
begin
  mnuo_compLabel.Checked := CompPars.FFilterOpts[ctLabel8];
  mnuo_CompText8Pt.Checked := CompPars.FFilterOpts[ctText8];
  mnuo_CompTSBSBackGroup.Checked := CompPars.FFilterOpts[ctBackGrp];
  mnuo_CompTBorCheck.Checked := CompPars.FFilterOpts[ctCheck];
  mnuo_CompTBorRadio.Checked := CompPars.FFilterOpts[ctRadio];
  mnuo_CompTCurrencyEdit.Checked := CompPars.FFilterOpts[ctCcyEdit];
  mnuo_CompTSBSPanel.Checked := CompPars.FFilterOpts[ctPanel];
  mnuo_CompTSBSGroup.Checked := CompPars.FFilterOpts[ctGroup];
  mnuo_CompTSBSButton.Checked := CompPars.FFilterOpts[ctButton];
end;

procedure TCustomisationDlg.mnuo_compxxxClick(Sender: TObject);
begin
  { Toggle checked flag }
  With Sender as TMenuItem Do
    Checked := Not Checked;

  { Update filter flags }
  CompPars.FFilterOpts[ctLabel8]  := mnuo_compLabel.Checked;
  CompPars.FFilterOpts[ctText8]   := mnuo_CompText8Pt.Checked;
  CompPars.FFilterOpts[ctBackGrp] := mnuo_CompTSBSBackGroup.Checked;
  CompPars.FFilterOpts[ctCheck]   := mnuo_CompTBorCheck.Checked;
  CompPars.FFilterOpts[ctRadio]   := mnuo_CompTBorRadio.Checked;
  CompPars.FFilterOpts[ctCcyEdit] := mnuo_CompTCurrencyEdit.Checked;
  CompPars.FFilterOpts[ctPanel]   := mnuo_CompTSBSPanel.Checked;
  CompPars.FFilterOpts[ctGroup]   := mnuo_CompTSBSGroup.Checked;
  CompPars.FFilterOpts[ctButton]  := mnuo_CompTSBSButton.Checked;

  { Reload lists }
  SetCustomControl(CustomControl);
end;


{ Exports the Text strings in a specified format to a specified file }
Procedure TCustomisationDlg.ExportText(Const ExpMode : Byte);
Var
  CustControl : TCustomisation;
  SaveDialog  : TSaveDialog;
  OutStr      : String;
  RCBase      : LongInt;
  OutF        : TextFile;
  I           : SmallInt;
Begin
  { Get path to save .RC into }
  SaveDialog := TSaveDialog.Create(Application);
  Try
    { Get local handle of Customisation Component }
    CustControl := TCustomisation(CustomControl);

    { Initialise Customisation Dialog }
    With SaveDialog Do Begin
      DefaultExt := '*.RC';
      FileName := ExtractFileName(CustControl.ExportPath);
      Filter := 'Resource Scripts (*.RC)|*.RC|Text Files (*.TXT)|*.TXT|All Files (*.*)|*.*';
      FilterIndex := 0;
      InitialDir := ExtractFilePath(CustControl.ExportPath);
      Options := [ofOverwritePrompt,ofPathMustExist,ofNoLongNames];
    End; { With }

    If SaveDialog.Execute Then Begin
      CustControl.ExportPath := SaveDialog.FileName;

      RCBase := GetStringIndex(CustControl.WindowId);
      If (RCBase > 0) Then Begin
        AssignFile (OutF, SaveDialog.FileName);
        Rewrite (OutF);

        Writeln (OutF, 'STRINGTABLE');
        Writeln (OutF, 'BEGIN');
        OutStr := 'W,OFF,' + FForm.Caption + ',';

        Writeln (OutF, '  ',
                       IntToStr(RCBase) + ', "',
                       OutStr,
                       '"');

        If (ListView2.Items.Count > 0) Then
          For I := 0 to Pred(ListView2.Items.Count) Do Begin
            CompPars.Component := ListView2.Items[I].Data;

            Writeln (OutF, CompPars.RCString(RCBase));
          End; { For }

        Writeln (OutF, 'END');

        CloseFile (OutF);
      End; { If }
    End; { If }
  Finally
    SaveDialog.Free;
  End; { Try }
End;


procedure TCustomisationDlg.mnuo_ToRCClick(Sender: TObject);
begin
  ExportText(1);
end;

procedure TCustomisationDlg.ListView1DblClick(Sender: TObject);
Var
  TmpList : TListItem;
  Id      : SmallInt;
begin
  If Assigned(ListView1.Selected) And (ListView1.ViewStyle = vsReport) Then Begin
    { Find Text Id of last control }
    CompPars.Component := ListView2.Items[Pred(ListView2.Items.Count)].Data;
    Id := Succ(CompPars.TextId);

    { Add to end of Customised controls list }
    TmpList := ListView2.Items.Add;
    AddToCustList(ListView1.Selected.Data, TmpList, Id);

    { Delete item at original position }
    ListView1.Selected.Delete;

    { Select new item }
    ListView2.SetFocus;
    ListView2.Selected := TmpList;
    ListView2.ItemFocused := TmpList;
  End; { If }
end;

end.

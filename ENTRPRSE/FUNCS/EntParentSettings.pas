unit EntParentSettings;

//PR: 21/03/2016 v2016 R2 ABSEXCH-17390 Removed warning about deprecated Outline unit
{$WARN UNIT_DEPRECATED OFF}
interface

uses
  EntSettings, Graphics, uMultiList, Controls;

const
  //Constants for SettingsToFont, FontToSettings funcs - indicate which font on a MultiList is being passed
  wfFont        = 0;
  wfHeader      = 1;
  wfHighlight   = 2;
  wfMultiSelect = 3;

type

  TParentSettings = Class
  private
    FSettings : TParentSettingsRec;
    FIsDirty : Boolean;
    function GetBackGroundColor: TColor;
    function GetFontColor: TColor;
    function GetFontName: string;
    function GetFontSize: LongInt;
    function GetFontStyle: TFontStyles;
    function GetHeaderFontColor: TColor;
    function GetHeaderFontName: string;
    function GetHeaderFontSize: LongInt;
    function GetHeaderFontStyle: TFontStyles;
    function GetHeaderBackgroundColor: TColor;
    function GetHighlightBackgroundColor: TColor;
    function GetHighlightFontColor: TColor;
    function GetHighlightFontStyle: TFontStyles;
    function GetMultiSelectBackgroundColor: TColor;
    function GetMultiSelectFontColor: TColor;
    function GetMultiSelectFontStyle: TFontStyles;
    procedure SetBackGroundColor(const Value: TColor);
    procedure SetFontColor(const Value: TColor);
    procedure SetFontName(const Value: string);
    procedure SetFontSize(const Value: LongInt);
    procedure SetFontStyle(const Value: TFontStyles);
    procedure SetHeaderFontColor(const Value: TColor);
    procedure SetHeaderFontName(const Value: string);
    procedure SetHeaderFontSize(const Value: LongInt);
    procedure SetHeaderFontStyle(const Value: TFontStyles);
    procedure SetHeaderBackgroundColor(const Value: TColor);
    procedure SetHighlightBackgroundColor(const Value: TColor);
    procedure SetHighlightFontColor(const Value: TColor);
    procedure SetHighlightFontStyle(const Value: TFontStyles);
    procedure SetMultiSelectBackgroundColor(const Value: TColor);
    procedure SetMultiSelectFontColor(const Value: TColor);
    procedure SetMultiSelectFontStyle(const Value: TFontStyles);


    function GetName : string;
    procedure SetName(const Value : string);

    procedure FontToSettings(const AFont : TFont; WhichFont : Byte = wfFont);
    procedure SettingsToFont(const AFont : TFont; WhichFont : Byte = wfFont);

    function IsContainer(const AControl : TControl) : Boolean;
  public
    constructor Create(const sExeName    : string;
                       const sUserID     : string;
                       const sWindowName : string);

    function ByteToStyle(Value : Byte) : TFontStyles;
    function StyleToByte(Value : TFontStyles) : Byte;

    procedure ControlToSettings(const AControl : TWinControl);
    procedure SettingsToControl(const AControl : TWinControl);

    property psBackGroundColor : TColor read GetBackGroundColor write SetBackGroundColor;
    property psFontName : string read GetFontName write SetFontName;
    property psFontSize : LongInt read GetFontSize write SetFontSize;
    property psFontColor : TColor read GetFontColor write SetFontColor;
    property psFontStyle : TFontStyles read GetFontStyle write SeTFontStyle;

    property psHeaderBackGroundColor : TColor read GetHeaderBackGroundColor write SetHeaderBackGroundColor;
    property psHeaderFontName : string read GetHeaderFontName write SetHeaderFontName;
    property psHeaderFontSize : LongInt read GetHeaderFontSize write SetHeaderFontSize;
    property psHeaderFontColor : TColor read GetHeaderFontColor write SetHeaderFontColor;
    property psHeaderFontStyle : TFontStyles read GetHeaderFontStyle write SetHeaderFontStyle;

    property psHighlightBackgroundColor : TColor read GetHighlightBackgroundColor write SetHighlightBackgroundColor;
    property psHighlightFontColor : TColor read GetHighlightFontColor write SetHighlightFontColor;
    property psHighlightFontStyle : TFontStyles read GetHighlightFontStyle write SetHighlightFontStyle;

    property psMultiSelectBackgroundColor : TColor read GetMultiSelectBackgroundColor write SetMultiSelectBackgroundColor;
    property psMultiSelectFontColor : TColor read GetMultiSelectFontColor write SetMultiSelectFontColor;
    property psMultiSelectFontStyle : TFontStyles read GetMultiSelectFontStyle write SetMultiSelectFontStyle;

    property psName : string read GetName write SetName;

    property IsDirty : Boolean read FIsDirty write FIsDirty;
    property SettingsRec : TParentSettingsRec read FSettings write FSettings;

  end;


implementation

uses
  StdCtrls, ComCtrls, Outline, Mask, ExtCtrls, {$IFNDEF NoBtrieveLists}SBSComp, {$ENDIF NoBtrieveLists} EtStrU, Forms, Grids,
  AdvToolBar, {$IFDEF ENTER1} VirtualTrees, {$ENDIF} SBSOutl;

{ TParentSettings }

function TParentSettings.ByteToStyle(Value: Byte): TFontStyles;
begin
  Result := [];
  if (Value and 1) = 1 then
    Result := Result + [fsBold];
  if (Value and 2) = 2 then
    Result := Result + [fsUnderline];
  if (Value and 4) = 4 then
    Result := Result + [fsItalic];
  if (Value and 8) = 8 then
    Result := Result + [fsStrikeOut];
end;

constructor TParentSettings.Create(const sExeName    : string;
                                   const sUserID     : string;
                                   const sWindowName : string);
begin
  inherited Create;
  FIsDirty := False;
  FillChar(FSettings, SizeOf(FSettings), 0);
  FSettings.psExeName := sExeName;
  FSettings.psUserName := sUserID;
  FSettings.psWindowName := sWindowName;
end;

function TParentSettings.GetBackGroundColor: TColor;
begin
  Result := FSettings.psBackGroundColor;
end;

function TParentSettings.GetFontColor: TColor;
begin
  Result := FSettings.psFontColor;
end;

function TParentSettings.GetFontName: string;
begin
  Result := FSettings.psFontName;
end;

function TParentSettings.GetFontSize: LongInt;
begin
  Result := FSettings.psFontSize;
end;

function TParentSettings.GetFontStyle: TFontStyles;
begin
  Result := ByteToStyle(FSettings.psFontStyle);
end;

function TParentSettings.GetHeaderFontColor: TColor;
begin
  Result := FSettings.psHeaderFontColor;
end;

function TParentSettings.GetHeaderFontName: string;
begin
  Result := FSettings.psHeaderFontName;
end;

function TParentSettings.GetHeaderFontSize: LongInt;
begin
  Result := FSettings.psHeaderFontSize;
end;

function TParentSettings.GetHeaderFontStyle: TFontStyles;
begin
  Result := ByteToStyle(FSettings.psHeaderFontStyle);
end;

function TParentSettings.GetHighlightBackgroundColor: TColor;
begin
  Result := FSettings.psHighlightBackgroundColor;
end;

function TParentSettings.GetHighlightFontColor: TColor;
begin
  Result := FSettings.psHighlightFontColor;
end;

function TParentSettings.GetHighlightFontStyle: TFontStyles;
begin
  Result := ByteToStyle(FSettings.psHighlighTFontStyle);
end;

function TParentSettings.GetMultiSelectBackgroundColor: TColor;
begin
  Result := FSettings.psMultiSelectBackgroundColor;
end;

function TParentSettings.GetMultiSelectFontColor: TColor;
begin
  Result := FSettings.psMultiSelectFontColor;
end;

function TParentSettings.GetMultiSelectFontStyle: TFontStyles;
begin
  Result := ByteToStyle(FSettings.psMultiSelectFontStyle);
end;

function TParentSettings.GetName: string;
begin
  Result := FSettings.psName;
end;

procedure TParentSettings.SetName(const Value : string);
begin
  FSettings.psName := LJVar(Value, COMP_NAME_LENGTH);
  FIsDirty := True;
end;

procedure TParentSettings.SetBackGroundColor(const Value: TColor);
begin
  if FSettings.psBackGroundColor <> Value then
  begin
    FSettings.psBackGroundColor := Value;
    FIsDirty := True;
  end;
end;

procedure TParentSettings.SetFontColor(const Value: TColor);
begin
  if FSettings.psFontColor <> Value then
  begin
    FSettings.psFontColor := Value;
    FIsDirty := True;
  end;
end;

procedure TParentSettings.SetFontName(const Value: string);
begin
  if FSettings.psFontName <> Value then
  begin
    FSettings.psFontName := Value;
    FIsDirty := True;
  end;
end;

procedure TParentSettings.SetFontSize(const Value: LongInt);
begin
  if FSettings.psFontSize <> Value then
  begin
    FSettings.psFontSize := Value;
    FIsDirty := True;
  end;
end;

procedure TParentSettings.SetFontStyle(const Value: TFontStyles);
begin
  if psFontStyle <> Value then
  begin
    FSettings.psFontStyle := StyleToByte(Value);
    FIsDirty := True;
  end;
end;

procedure TParentSettings.SetHeaderFontColor(const Value: TColor);
begin
  if FSettings.psHeaderFontColor <> Value then
  begin
    FSettings.psHeaderFontColor := Value;
    FIsDirty := True;
  end;
end;

procedure TParentSettings.SetHeaderFontName(const Value: string);
begin
  if FSettings.psHeaderFontName <> Value then
  begin
    FSettings.psHeaderFontName := Value;
    FIsDirty := True;
  end;
end;

procedure TParentSettings.SetHeaderFontSize(const Value: LongInt);
begin
  if FSettings.psHeaderFontSize <> Value then
  begin
    FSettings.psHeaderFontSize := Value;
    FIsDirty := True;
  end;
end;

procedure TParentSettings.SetHeaderFontStyle(const Value: TFontStyles);
begin
  if psHeaderFontStyle <> Value then
  begin
    FSettings.psHeaderFontStyle := StyleToByte(Value);
    FIsDirty := True;
  end;
end;

procedure TParentSettings.SetHighlightBackgroundColor(const Value: TColor);
begin
  if FSettings.psHighlightBackgroundColor <> Value then
  begin
    FSettings.psHighlightBackgroundColor := Value;
    FIsDirty := True;
  end;
end;

procedure TParentSettings.SetHighlightFontColor(const Value: TColor);
begin
  if FSettings.psHighlightFontColor <> Value then
  begin
    FSettings.psHighlightFontColor := Value;
    FIsDirty := True;
  end;
end;

procedure TParentSettings.SetHighlightFontStyle(const Value: TFontStyles);
begin
  if psHighlightFontStyle <> Value then
  begin
    FSettings.psHighlightFontStyle := StyleToByte(Value);
    FIsDirty := True;
  end;
end;

procedure TParentSettings.SetMultiSelectBackgroundColor(
  const Value: TColor);
begin
  if FSettings.psMultiSelectBackgroundColor <> Value then
  begin
    FSettings.psMultiSelectBackgroundColor := Value;
    FIsDirty := True;
  end;
end;

procedure TParentSettings.SetMultiSelectFontColor(const Value: TColor);
begin
  if FSettings.psMultiSelectFontColor <> Value then
  begin
    FSettings.psMultiSelectFontColor := Value;
    FIsDirty := True;
  end;
end;

procedure TParentSettings.SetMultiSelectFontStyle(const Value: TFontStyles);
begin
  if psMultiSelectFontStyle <> Value then
  begin
    FSettings.psMultiSelectFontStyle := StyleToByte(Value);
    FIsDirty := True;
  end;
end;

function TParentSettings.StyleToByte(Value: TFontStyles): Byte;
begin
  Result := 0;
  if fsBold in Value then
    Result := Result or 1;
  if fsUnderline in Value then
    Result := Result or 2;
  if fsItalic in Value then
    Result := Result or 4;
  if fsStrikeOut in Value then
    Result := Result or 8;
end;

procedure TParentSettings.ControlToSettings(const AControl: TWinControl);
begin
  if Assigned(AControl) then
  begin
    if (AControl is TEdit) then
    begin
      // TEdit
      psBackgroundColor := TEdit(AControl).Color;
      FontToSettings(TEdit(AControl).Font);
    end
    else
    if (AControl is TComboBox) then
    begin
      // TComboBox
      psBackgroundColor := TComboBox(AControl).Color;
      FontToSettings(TComboBox(AControl).Font);
    end
    else
    if (AControl is TMemo) then
    begin
      // TMemo
      psBackgroundColor := TMemo(AControl).Color;
      FontToSettings(TMemo(AControl).Font);
    end
    else
    if (AControl is TRichEdit) then
    begin
      // TRichEdit
      psBackgroundColor := TRichEdit(AControl).Color;
      FontToSettings(TRichEdit(AControl).Font);
    end
    else
    if (AControl is TMaskEdit) then
    begin
      // TMaskEdit
      psBackgroundColor := TMaskEdit(AControl).Color;
      FontToSettings(TMaskEdit(AControl).Font);
    end
    else
    if (AControl is TDateTimePicker) then
    begin
    // TDateTimePicker
      psBackgroundColor := TDateTimePicker(AControl).Color;
      FontToSettings(TDateTimePicker(AControl).Font);
    end
    else
    if (AControl is TListBox) then
    begin
      // TListBox
      psBackgroundColor := TListBox(AControl).Color;
      FontToSettings(TListBox(AControl).Font);
    end
    else
    if (AControl is TListView) then
    begin
      // TListView
      psBackgroundColor := TListView(AControl).Color;
      FontToSettings(TListView(AControl).Font);
    end
    else
    if (AControl is TOutLine) then
    begin
      // TOutLine
      psBackgroundColor := TOutLine(AControl).Color;
      FontToSettings(TOutLine(AControl).Font);
    end
    else
    if (AControl is TSBSOutlineB) then //EL's SBSOutline
    begin
      // TSBSOutLineB - TSBSOutlineC descends from this
      psBackgroundColor := TSBSOutlineB(AControl).Color;
      FontToSettings(TSBSOutlineB(AControl).Font);
    end
    else
    if (AControl is TTreeView) then
    begin
      // TTreeView
      psBackgroundColor := TTreeView(AControl).Color;
      FontToSettings(TTreeView(AControl).Font);
    end
    else
    {$IFDEF ENTER1}
    //PR: 16/02/2018 ABSEXCH-19773 Add virtual string tree - not descended from TStringTree
    if (AControl is TVirtualStringTree) then
    begin
      psBackgroundColor := TVirtualStringTree(AControl).Color;
      FontToSettings(TVirtualStringTree(AControl).Font);
    end
    else
    {$ENDIF}
    if (AControl is TMultiList) then
    with AControl as TMultiList do
    begin
      // TMultiList
      psBackgroundColor := DesignColumns[0].Color;
      psHighlightBackgroundColor := Colours.Selection;
      psMultiSelectBackgroundColor := Colours.MultiSelection;

      FontToSettings(Font);
      FontToSettings(HeaderFont, wfHeader);
      FontToSettings(HighlightFont, wfHighlight);
      FontToSettings(MultiSelectFont, wfMultiSelect);
    end
   {$IFNDEF NoBtrieveList}
    else
    if AControl is TMULCtrl then
    with AControl as TMULCtrl do
    begin
      //TMULCtrl - EL's Btrieve List
      VisiList.VisiRec := VisiList.List[0];
      psBackGroundColor := (VisiList.VisiRec.PanelObj as TPanel).Color;
      FontToSettings((VisiList.VisiRec.PanelObj as TPanel).Font);

      psHighlightBackGroundColor := ColAppear[0].HBkColor;
      psHighlightFontColor := ColAppear[0].HTextColor;

      FontToSettings((VisiList.VisiRec.LabelObj as TPanel).Font, wfHeader);
      psHeaderBackGroundColor := (VisiList.VisiRec.LabelObj as TPanel).Color;
    end
   {$ENDIF NoBtrieveList}
    ;{if}
  end; //if Assigned;
end;

procedure TParentSettings.FontToSettings(const AFont: TFont; WhichFont : Byte = wfFont);
begin
  if Assigned(AFont) then
  begin
    Case WhichFont of
      wfFont : begin
                 psFontColor := AFont.Color;
                 psFontName  := AFont.Name;
                 psFontSize  := AFont.Size;
                 psFontStyle := AFont.Style;
               end;
      wfHeader
             : begin
                 psHeaderFontColor := AFont.Color;
                 psHeaderFontName  := AFont.Name;
                 psHeaderFontSize  := AFont.Size;
                 psHeaderFontStyle := AFont.Style;
               end;
      wfHighlight
             : begin
                 psHighlightFontColor := AFont.Color;
                 psHighlightFontStyle := AFont.Style;
               end;
      wfMultiSelect
             : begin
                 psMultiSelectFontColor := AFont.Color;
                 psMultiSelectFontStyle := AFont.Style;
               end;
      end; //case
  end;
end;

procedure TParentSettings.SettingsToFont(const AFont: TFont; WhichFont : Byte = wfFont);
begin
  if Assigned(AFont) then
  begin
    Case WhichFont of
      wfFont : begin
                  AFont.Color := psFontColor;
                  AFont.Name := psFontName;
                  AFont.Size := psFontSize;
                  AFont.Style := psFontStyle;
               end;
      wfHeader
             : begin
                  AFont.Color := psHeaderFontColor;
                  AFont.Name := psHeaderFontName;
                  AFont.Size := psHeaderFontSize;
                  AFont.Style := psHeaderFontStyle;
               end;
      wfHighlight
             : begin
                  AFont.Color := psHighlightFontColor;
                  AFont.Style := psHighlightFontStyle;
               end;
      wfMultiSelect
             : begin
                  AFont.Color := psMultiSelectFontColor;
                  AFont.Style := psMultiSelectFontStyle;
               end;
      end; //case
  end;
end;

procedure TParentSettings.SettingsToControl(const AControl: TWinControl);
var
  i : Integer;
  AFont : TFont;
begin
  if Assigned(AControl) then
  begin
    if (AControl is TMultiList) then
    with AControl as TMultiList do
    begin
      // TMultiList
      for i := 0 to Columns.Count - 1 do
        Columns[i].Color := psBackgroundColor;

      Colours.Selection := psHighlightBackgroundColor;
      Colours.MultiSelection := psMultiSelectBackgroundColor;

      SettingsToFont(Font);
      SettingsToFont(HeaderFont, wfHeader);
      SettingsToFont(HighlightFont, wfHighlight);
      SettingsToFont(MultiSelectFont, wfMultiSelect);
    end
   {$IFNDEF NoBtrieveList}
    else
    if AControl is TMULCtrl then
    with AControl as TMULCtrl do
    begin
      //TMULCtrl - EL's Btrieve List
      Color := psBackgroundColor;
      SettingsToFont(Font);
      with VisiList do
      begin
        VisiRec := List[0];
        AFont := (VisiRec^.PanelObj as TPanel).Font;
        SettingsToFont(AFont);
        ReColorCol(AFont, psBackgroundColor, False);

        { CJS 2012-06-22: ABSEXCH-11527 - Btrieve list font size }
        { CJS 2012-08-08: ABSEXCH-13263 - Code rendered unnecessary by subsequent changes }
        {
        if Assigned(MUListBox1) then
        begin
          if Assigned(AFont) then
            MUListBox1.Font := AFont;
          RefreshAllCols;
        end;
        }
        
        For i:=0 to MUTotCols do
        With ColAppear^[i] do
        Begin
          HBkColor:=psHighlightBackgroundColor;
          HTextColor:=psHighlightFontColor;
        end;

        AFont := (VisiRec^.LabelObj as TPanel).Font;
        SettingsToFont(AFont, wfHeader);
        ReColorCol(AFont, psHeaderBackgroundColor, True);
        Repaint_Row;
      end;
    end
   {$ENDIF NoBtrieveList}
    else if (AControl is TListView) then
    begin
      // TListView
      TListView(AControl).Color := psBackgroundColor;
      SettingsToFont(TListView(AControl).Font);
    end
    else
    {$IFDEF ENTER1}
    //PR: 16/02/2018 ABSEXCH-19773 Add virtual string tree - not descended from TStringTree
    if (AControl is TVirtualStringTree) then
    begin
      TVirtualStringTree(AControl).Color := psBackgroundColor;
      SettingsToFont(TVirtualStringTree(AControl).Font);
    end
    else
    {$ENDIF}
      for i := 0 to AControl.ControlCount - 1 do
      begin
        if IsContainer(AControl.Controls[i]) then
          SettingsToControl(AControl.Controls[i] as TWinControl)
        else
        if (AControl.Controls[i] is TEdit) then
        begin
          // TEdit
          TEdit(AControl.Controls[i]).Color := psBackgroundColor;
          SettingsToFont(TEdit(AControl.Controls[i]).Font);
        end
        else
        if (AControl.Controls[i] is TComboBox) then
        begin
          // TComboBox
          TComboBox(AControl.Controls[i]).Color := psBackgroundColor;
          SettingsToFont(TComboBox(AControl.Controls[i]).Font);
        end
        else
        if (AControl.Controls[i] is TMemo) then
        begin
          // TMemo
          TMemo(AControl.Controls[i]).Color := psBackgroundColor;
          SettingsToFont(TMemo(AControl.Controls[i]).Font);
        end
        else
        if (AControl.Controls[i] is TRichEdit) then
        begin
          // TRichEdit
          TRichEdit(AControl.Controls[i]).Color := psBackgroundColor;
          SettingsToFont(TRichEdit(AControl.Controls[i]).Font);
        end
        else
        if (AControl.Controls[i] is TMaskEdit) then
        begin
          // TMaskEdit
          TMaskEdit(AControl.Controls[i]).Color := psBackgroundColor;
          SettingsToFont(TMaskEdit(AControl.Controls[i]).Font);
        end
        else
        if (AControl.Controls[i] is TDateTimePicker) then
        begin
          // TDateTimePicker
          TDateTimePicker(AControl.Controls[i]).Color := psBackgroundColor;
          SettingsToFont(TDateTimePicker(AControl.Controls[i]).Font);
        end
        else
        if (AControl.Controls[i] is TListBox) then
        begin
          // TListBox
          TListBox(AControl.Controls[i]).Color := psBackgroundColor;
          SettingsToFont(TListBox(AControl.Controls[i]).Font);
        end
        else
        if (AControl.Controls[i] is TListView) then
        begin
          // TListView
          TListView(AControl.Controls[i]).Color := psBackgroundColor;
          SettingsToFont(TListView(AControl.Controls[i]).Font);
        end
        else
        if (AControl.Controls[i] is TOutLine) then
        begin
          // TOutLine
          TOutLine(AControl.Controls[i]).Color := psBackgroundColor;
          SettingsToFont(TOutLine(AControl.Controls[i]).Font);
        end
        else
        if (AControl.Controls[i] is TSBSOutlineB) then  //EL's SBSOutline
        begin
          // TSBSOutLineB - TSBSOutlineC descends from this
          TSBSOutlineB(AControl.Controls[i]).Color := psBackgroundColor;
          SettingsToFont(TSBSOutlineB(AControl.Controls[i]).Font);
        end
        else
        if (AControl.Controls[i] is TTreeView) then
        begin
          // TTreeView
          TTreeView(AControl.Controls[i]).Color := psBackgroundColor;
          SettingsToFont(TTreeView(AControl.Controls[i]).Font);
        end;
      end; //for i


  end; //if Assigned;
end;

function TParentSettings.GetHeaderBackgroundColor: TColor;
begin
  Result := FSettings.psHeaderBackgroundColor;
end;

procedure TParentSettings.SetHeaderBackgroundColor(const Value: TColor);
begin
  if FSettings.psHeaderBackgroundColor <> Value then
  begin
    FSettings.psHeaderBackgroundColor := Value;
    FIsDirty := True;
  end;
end;

function TParentSettings.IsContainer(const AControl: TControl): Boolean;
begin
  {$IFNDEF NoBtrieveLists}
  Result := (AControl is TPanel) and not (AControl is TMulCtrl);
  {$ELSE}
  Result := (AControl is TPanel);
  {$ENDIF NoBtrieveLists}

  Result := Result or (AControl is TGroupBox) or (AControl is TScrollBox) or (AControl is TTabSheet) or
                      (AControl is TForm) or (AControl is TPageControl) or (AControl is TAdvCustomToolBar)
                      or (AControl is TAdvDockPanel)
                      // PKR 21/01/2014.  ABSEXCH-14974 Added for Ledger Multi-contacts
                      or (AControl is TFrame)
                      // MH 23/02/2015 v7.0.14: Added TNoteBook for Prompt Payment Discounts
                      or (Acontrol is TNotebook) or (Acontrol is TPage);
end;

end.

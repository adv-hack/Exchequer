{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVPESys;

interface

uses
  Windows, Classes, SysUtils, Messages, Graphics, Controls, StdCtrls,
  ExtCtrls, Forms, Dialogs, TypInfo, RVDefine, RVUtil, RVClass, RVTool, RVProj,
  RPDefine;

type
  TRaveCursorPropertyEditor = class(TRavePropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    function GetValue: string; override;
    procedure SetValue(Value: string); override;
  public
    procedure GetValues(ValueList: TStrings); override;
  end; { TRaveCursorPropertyEditor }

  TRaveColorPropertyEditor = class(TRavePropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    function GetValue: string; override;
    procedure SetValue(Value: string); override;
  public
    procedure GetValues(ValueList: TStrings); override;
    procedure PaintValue(Canvas: TCanvas;
                         Rect: TRect;
                         DefaultValue: string); override;
  end; { TRaveColorPropertyEditor }

  TRavePenStylePropertyEditor = class(TRaveEnumPropertyEditor)
  public
    procedure PaintValue(Canvas: TCanvas;
                         Rect: TRect;
                         DefaultValue: string); override;
  end; { TRavePenStylePropertyEditor }

  TRaveFillStylePropertyEditor = class(TRaveEnumPropertyEditor)
  public
    procedure PaintValue(Canvas: TCanvas;
                         Rect: TRect;
                         DefaultValue: string); override;
  end; { TRaveFillStylePropertyEditor }

  TRaveNamePropertyEditor = class(TRaveStringPropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    procedure SetValue(Value: string); override;
  end; { TRaveNamePropertyEditor }

  TRaveFontPropertyEditor = class(TRavePropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    function GetFontDesc(Font: TFont): string;
    function GetValue: string; override;
  public
    procedure Edit; override;
  end; { TRaveFontPropertyEditor }

  TRaveMirrorPropertyEditor = class(TRaveComponentPropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    function Include(Value: TComponent;
                     Data: longint): boolean; override;
  end; { TRaveMirrorPropertyEditor }

  TRaveGotoPagePropertyEditor = class(TRaveComponentPropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    function Include(Value: TComponent;
                     Data: longint): boolean; override;
  end; { TRaveGotoPagePropertyEditor }

  TRaveLockedPropertyEditor = class(TRaveEnumPropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    function GetValue: string; override;
  end; { TRaveLockedPropertyEditor }

  TRaveUnitsPropertyEditor = class(TRavePropertyEditor)
    function GetValue: string; override;
    procedure SetValue(Value: string); override;
  end; { TRaveUnitsPropertyEditor }

  TRavePasswordPropertyEditor = class(TRaveStringPropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
  end; { TRavePasswordPropertyEditor }

  procedure RaveRegister;

implementation

  procedure RaveRegister;

  begin { RaveRegister }
  {TransOff}
    RegisterRavePropertyEditor(TypeInfo(TCursor),nil,'',TRaveCursorPropertyEditor);
    RegisterRavePropertyEditor(TypeInfo(TColor),nil,'',TRaveColorPropertyEditor);
    RegisterRavePropertyEditor(TypeInfo(TPenStyle),nil,'',TRavePenStylePropertyEditor);
    RegisterRavePropertyEditor(TypeInfo(TRaveFillStyle),nil,'',TRaveFillStylePropertyEditor);
    RegisterRavePropertyEditor(TypeInfo(TComponentName),TRaveComponent,'Name',
     TRaveNamePropertyEditor);
    RegisterRavePropertyEditor(TypeInfo(TFont),nil,'',TRaveFontPropertyEditor);
    RegisterRavePropertyEditor(TypeInfo(TRaveControl),nil,'Mirror',
     TRaveMirrorPropertyEditor);
    RegisterRavePropertyEditor(TypeInfo(TRavePage),TRavePage,'GotoPage',
     TRaveGotoPagePropertyEditor);
    RegisterRavePropertyEditor(TypeInfo(boolean),nil,'Locked',
     TRaveLockedPropertyEditor);
    RegisterRavePropertyEditor(TypeInfo(boolean),nil,'DevLocked',
     TRaveLockedPropertyEditor);
    RegisterRavePropertyEditor(TypeInfo(TRaveUnits),nil,'',TRaveUnitsPropertyEditor);
  {TransOn}
  end;  { RaveRegister }

(*****************************************************************************}
( class TRaveCursorPropertyEditor
(*****************************************************************************)

const
{TransOff}
  CursorName: array[-21..0] of string = ('crHandPoint','crHelp','crAppStart',
   'crNo','crSQLWait','crMultiDrag','crVSplit','crHSplit','crNoDrop','crDrag',
   'crHourGlass','crUpArrow','crSizeWE','crSizeNWSE','crSizeNS','crSizeNESW',
   'crSize','crIBeam','crCross','crArrow','crNone','crDefault');
{TransOn}

  function TRaveCursorPropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := [poMultiSelect,poListing];
  end;  { GetOptions }

  procedure TRaveCursorPropertyEditor.GetValues(ValueList: TStrings);

  var
    I1: integer;

  begin { GetValues }
    ValueList.Clear;
    For I1 := -21 to 0 do begin
      If I1 <> -5 then begin
        ValueList.Add(CursorName[I1]);
      end; { if }
    end; { for }
  end;  { GetValues }

  function TRaveCursorPropertyEditor.GetValue: string;

  var
    I1: integer;
    Value1: integer;
    Value2: integer;

  begin { GetValue }
    Value1 := GetOrdValue(0);
    For I1 := 1 to InstCount - 1 do begin
      Value2 := GetOrdValue(I1);
      If Value1 <> Value2 then begin
        Result := '';
        Exit;
      end; { if }
    end; { for }
    Result := CursorName[Value1];
  end;  { GetValue }

  procedure TRaveCursorPropertyEditor.SetValue(Value: string);

  var
    I1: integer;
    ErrCode: integer;

  begin { SetValue }
    Val(Value,I1,ErrCode);
    If (ErrCode = 0) and (I1 >= -21) and (I1 <= 0) then begin
      SetOrdValue(I1);
      Exit;
    end else begin { Search for Value in CursorName }
      For I1 := 0 downto -21 do begin
        If UpperCase(Value) = UpperCase(CursorName[I1]) then begin
          SetOrdValue(I1);
          Exit;
        end; { if }
      end; { for }
    end; { else }
    MessageDlg(Trans(Format({Trans+}'"%s" is not a valid entry.',[Value])),mtError,
     [mbOk],0);
  end;  { SetValue }

(*****************************************************************************}
( class TRaveColorPropertyEditor
(*****************************************************************************)

type
  TColorName = record
    Name: string;
    Color: TColor;
  end; { TColorName }

const
{TransOff}
  Colors = 74;
  SimpleColors = 47;
  ColorName: array[1..Colors] of TColorName = (
   (Name:'Black'; Color:TColor($000000)),
   (Name:'Maroon'; Color:TColor($000080)),
   (Name:'Green'; Color:TColor($008000)),
   (Name:'Olive'; Color:TColor($008080)),
   (Name:'Navy'; Color:TColor($800000)),
   (Name:'Purple'; Color:TColor($800080)),
   (Name:'Teal'; Color:TColor($808000)),
   (Name:'Gray'; Color:TColor($808080)),
   (Name:'Silver'; Color:TColor($C0C0C0)),
   (Name:'Red'; Color:TColor($0000FF)),
   (Name:'Lime'; Color:TColor($00FF00)),
   (Name:'Yellow'; Color:TColor($00FFFF)),
   (Name:'Blue'; Color:TColor($FF0000)),
   (Name:'Fuchsia'; Color:TColor($FF00FF)),
   (Name:'Aqua'; Color:TColor($FFFF00)),
   (Name:'White'; Color:TColor($FFFFFF)),
   (Name:'Pink'; Color: TColor($8080FF)),
   (Name:'RedClay'; Color: TColor($404080)),
   (Name:'NightRed'; Color: TColor($000040)),
   (Name:'Lemon'; Color: TColor($80FFFF)),
   (Name:'Peach'; Color: TColor($4080FF)),
   (Name:'Orange'; Color: TColor($0080FF)),
   (Name:'Brown'; Color: TColor($004080)),
   (Name:'MistGreen'; Color: TColor($80FF80)),
   (Name:'YellowGreen'; Color: TColor($00FF80)),
   (Name:'NightGreen'; Color: TColor($004000)),
   (Name:'Gold'; Color: TColor($408080)),
   (Name:'SeaGreen'; Color: TColor($80FF00)),
   (Name:'GreenApple'; Color: TColor($40FF00)),
   (Name:'BlueGreen'; Color: TColor($408000)),
   (Name:'ForestGreen'; Color: TColor($404000)),
   (Name:'SkyBlue'; Color: TColor($FFFF80)),
   (Name:'DeepBlue'; Color: TColor($804000)),
   (Name:'TealGray'; Color: TColor($808040)),
   (Name:'GreenBlue'; Color: TColor($FF8000)),
   (Name:'TealBlue'; Color: TColor($C08000)),
   (Name:'Lavender'; Color: TColor($FF8080)),
   (Name:'RoyalBlue'; Color: TColor($A00000)),
   (Name:'NightBlue'; Color: TColor($400000)),
   (Name:'BubbleGum'; Color: TColor($C080FF)),
   (Name:'Periwinkle'; Color: TColor($C08080)),
   (Name:'Plum'; Color: TColor($400080)),
   (Name:'BlackCherry'; Color: TColor($400040)),
   (Name:'PinkCarnation'; Color: TColor($FF80FF)),
   (Name:'VioletRed'; Color: TColor($8000FF)),
   (Name:'LightPurple'; Color: TColor($FF0080)),
   (Name:'DarkPurple'; Color: TColor($800040)),
   (Name:'clNone'; Color:TColor($1FFFFFFF)),
   (Name:'clDefault'; Color:TColor($20000000)),
   (Name:'clScrollBar'; Color:TColor(COLOR_SCROLLBAR or $80000000)),
   (Name:'clBackground'; Color:TColor(COLOR_BACKGROUND or $80000000)),
   (Name:'clActiveCaption'; Color:TColor(COLOR_ACTIVECAPTION or $80000000)),
   (Name:'clInactiveCaption'; Color:TColor(COLOR_INACTIVECAPTION or $80000000)),
   (Name:'clMenu'; Color:TColor(COLOR_MENU or $80000000)),
   (Name:'clWindow'; Color:TColor(COLOR_WINDOW or $80000000)),
   (Name:'clWindowFrame'; Color:TColor(COLOR_WINDOWFRAME or $80000000)),
   (Name:'clMenuText'; Color:TColor(COLOR_MENUTEXT or $80000000)),
   (Name:'clWindowText'; Color:TColor(COLOR_WINDOWTEXT or $80000000)),
   (Name:'clCaptionText'; Color:TColor(COLOR_CAPTIONTEXT or $80000000)),
   (Name:'clActiveBorder'; Color:TColor(COLOR_ACTIVEBORDER or $80000000)),
   (Name:'clInactiveBorder'; Color:TColor(COLOR_INACTIVEBORDER or $80000000)),
   (Name:'clAppWorkSpace'; Color:TColor(COLOR_APPWORKSPACE or $80000000)),
   (Name:'clHighlight'; Color:TColor(COLOR_HIGHLIGHT or $80000000)),
   (Name:'clHighlightText'; Color:TColor(COLOR_HIGHLIGHTTEXT or $80000000)),
   (Name:'clBtnFace'; Color:TColor(COLOR_BTNFACE or $80000000)),
   (Name:'clBtnShadow'; Color:TColor(COLOR_BTNSHADOW or $80000000)),
   (Name:'clGrayText'; Color:TColor(COLOR_GRAYTEXT or $80000000)),
   (Name:'clBtnText'; Color:TColor(COLOR_BTNTEXT or $80000000)),
   (Name:'clInactiveCaptionText'; Color:TColor(COLOR_INACTIVECAPTIONTEXT or $80000000)),
   (Name:'clBtnHighlight'; Color:TColor(COLOR_BTNHIGHLIGHT or $80000000)),
   (Name:'cl3DDkShadow'; Color:TColor(COLOR_3DDKSHADOW or $80000000)),
   (Name:'cl3DLight'; Color:TColor(COLOR_3DLIGHT or $80000000)),
   (Name:'clInfoText'; Color:TColor(COLOR_INFOTEXT or $80000000)),
   (Name:'clInfoBk'; Color:TColor(COLOR_INFOBK or $80000000)));
{TransOn}

  function TRaveColorPropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := [poMultiSelect,poListing,poNoSort];
  end;  { GetOptions }

  procedure TRaveColorPropertyEditor.GetValues(ValueList: TStrings);

  var
    I1: integer;
    I2: integer;

  begin { GetValues }
    ValueList.Clear;
    If UserLevel = ulAdvanced then begin
      I2 := Colors;
    end else begin
      I2 := SimpleColors;
    end; { else }
    For I1 := 1 to I2 do begin
      ValueList.Add(ColorName[I1].Name);
    end; { for }
  end;  { GetValues }

  procedure TRaveColorPropertyEditor.PaintValue(Canvas: TCanvas;
                                                Rect: TRect;
                                                DefaultValue: string);

  begin { PaintValue }
    If DefaultValue <> '' then begin
    { Draw color name first }
      Canvas.TextRect(Rect,Rect.Left + 44,Rect.Top + 1,DefaultValue);

    { Draw color block }
      Canvas.Pen.Color := clBlack;
      Canvas.Brush.Color := TColor(GetOrdValue(0));
      Canvas.Rectangle(Rect.Left + 1,Rect.Top + 1,Rect.Left + 41,Rect.Bottom - 1);
    end; { if }
  end;  { PaintValue }

  function TRaveColorPropertyEditor.GetValue: string;

  var
    I1: integer;
    Value1: integer;
    Value2: integer;

  begin { GetValue }
    Value1 := GetOrdValue(0);
    For I1 := 1 to InstCount - 1 do begin
      Value2 := GetOrdValue(I1);
      If Value1 <> Value2 then begin
        Result := '';
        Exit;
      end; { if }
    end; { for }
    For I1 := 1 to Colors do begin
      If Value1 = ColorName[I1].Color then begin
        Result := ColorName[I1].Name;
        Exit;
      end; { if }
    end; { for }
    Result := '$' + IntToHex(Value1,8);
  end;  { GetValue }

  procedure TRaveColorPropertyEditor.SetValue(Value: string);

  var
    I1: integer;
    I2: integer;
    ErrCode: integer;
    S1: string;
    Value1: integer;

  begin { SetValue }
    Val(Value,Value1,ErrCode);
    If ErrCode = 0 then begin
      SetOrdValue(Value1);
      Exit;
    end else begin { Search for Value in CursorName }
      S1 := Trim(Value);
      If (Length(S1) > 0) and (S1[1] = '$') then begin
        Value1 := 0;
        For I1 := 2 to Length(S1) do begin
          I2 := Pos(UpCase(S1[I1]),HexDigits);
          If I2 > 0 then begin
            Value1 := Value1 * 16 + I2 - 1;
            If I1 = Length(S1) then begin
              SetOrdValue(Value1);
              Exit;
            end; { if }
          end else begin
            Break;
          end; { else }
        end; { for }
      end else begin
        For I1 := 1 to Colors do begin
          If UpperCase(Value) = UpperCase(ColorName[I1].Name) then begin
            SetOrdValue(ColorName[I1].Color);
            Exit;
          end; { if }
        end; { for }
      end; { else }
    end; { else }
    MessageDlg(Trans(Format({Trans+}'"%s" is not a valid entry.',[Value])),mtError,
     [mbOk],0);
  end;  { SetValue }

(*****************************************************************************}
( class TRavePenStylePropertyEditor
(*****************************************************************************)

  procedure TRavePenStylePropertyEditor.PaintValue(Canvas: TCanvas;
                                                   Rect: TRect;
                                                   DefaultValue: string);

  begin { PaintValue }
    If DefaultValue <> '' then begin
      With Canvas do begin
      { Draw pen style name first }
        TextRect(Rect,Rect.Left + 44,Rect.Top + 1,DefaultValue);

      { Draw blank box }
        Pen.Color := clBlack;
        Brush.Color := clWhite;
        Rectangle(Rect.Left + 1,Rect.Top + 1,Rect.Left + 41,Rect.Bottom - 1);

      { Draw pen style line }
        Pen.Style := TPenStyle(GetOrdValue(0));
        MoveTo(Rect.Left + 1,(Rect.Top + Rect.Bottom) div 2);
        LineTo(Rect.Left + 40,(Rect.Top + Rect.Bottom) div 2);
      end; { with }
    end; { if }
  end;  { PaintValue }

(*****************************************************************************}
( class TRaveFillStylePropertyEditor
(*****************************************************************************)

  procedure TRaveFillStylePropertyEditor.PaintValue(Canvas: TCanvas;
                                                    Rect: TRect;
                                                    DefaultValue: string);

  begin { PaintValue }
    If DefaultValue <> '' then begin
      With Canvas do begin
      { Draw fill style name first }
        TextRect(Rect,Rect.Left + 44,Rect.Top + 1,DefaultValue);

      { Draw blank box }
        Pen.Color := clBlack;
        Brush.Color := clWhite;
        Rectangle(Rect.Left + 1,Rect.Top + 1,Rect.Left + 41,Rect.Bottom - 1);

      { Draw fill style pattern }
        Brush.Color := clBlack;
        Brush.Style := TBrushStyle(GetOrdValue(0));
        Rectangle(Rect.Left + 1,Rect.Top + 1,Rect.Left + 41,Rect.Bottom - 1);
      end; { with }
    end; { if }
  end;  { PaintValue }

(*****************************************************************************}
( class TRaveNamePropertyEditor
(*****************************************************************************)

  function TRaveNamePropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := [poRefreshAll];
  end;  { GetOptions }

  procedure TRaveNamePropertyEditor.SetValue(Value: string);

  begin { SetValue }
    inherited SetValue(Value);

  end;  { SetValue }

(*****************************************************************************}
( class TRaveFontPropertyEditor
(*****************************************************************************)

  function TRaveFontPropertyEditor.GetFontDesc(Font: TFont): string;

  const
  {TransOff}
    StyleNames: array[TFontStyle] of string = ('Bold','Italic','Underline','Strikeout');
  {TransOn}

  var
    I1: integer;

  begin { GetFontDesc }
    Result := Font.Name + ',' + IntToStr(Font.Size);
    For I1 := 0 to Ord(High(TFontStyle)) do begin
      If TFontStyle(I1) in Font.Style then begin
        Result := Result + ',' + StyleNames[TFontStyle(I1)];
      end; { if }
    end; { for }
  end;  { GetFontDesc }

  function TRaveFontPropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := [poReadOnly,poEditor,poMultiSelect];
  end;  { GetOptions }

  function TRaveFontPropertyEditor.GetValue: string;

  var
    I1: integer;
    Value1: string;
    Value2: string;

  begin { GetValue }
    If GetOrdValue(0) = 0 then begin
      Value1 := '';
    end else begin
      Value1 := GetFontDesc(TFont(GetOrdValue(0)));
    end; { else }
    For I1 := 1 to InstCount - 1 do begin
      If GetOrdValue(I1) = 0 then begin
        Value2 := '';
      end else begin
        Value2 := GetFontDesc(TFont(GetOrdValue(I1)));
      end; { else }
      If Value1 <> Value2 then begin
        Result := '';
        Exit;
      end; { if }
    end; { for }
    Result := Value1;
  end;  { GetValue }

  procedure TRaveFontPropertyEditor.Edit;

  var
    FontDlg: TFontDialog;

  begin { Edit }
    FontDlg := TFontDialog.Create(nil);
    FontDlg.Font.Assign(TFont(GetOrdValue(0)));
    If FontDlg.Execute then begin
      SetOrdValue(integer(FontDlg.Font));
    end; { if }
    FontDlg.Free;
  end;  { Edit }

(*****************************************************************************}
( class TRaveMirrorPropertyEditor
(*****************************************************************************)

  function TRaveMirrorPropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := [poListing,poNoSort,poRefreshAll];
  end;  { GetOptions }

  function TRaveMirrorPropertyEditor.Include(Value: TComponent;
                                             Data: longint): boolean;

    function IsValueParentOf(Component: TRaveComponent): boolean;

    begin { IsValueParentOf }
      If Component.Parent = Value then begin
        Result := true;
      end else if Component.Parent is TRaveProjectItem then begin
        Result := false;
      end else begin
        Result := IsValueParentOf(Component.Parent);
      end; { else }
    end;  { IsValueParentOf }

    function IsMirrorAllowed(Mirror: TRaveControl): boolean;

    begin { IsMirrorAllowed }
      Result := (Mirror <> Instance[0]) and // Allowed if not circular reference
       not IsValueParentOf(Mirror) and // Allowed if Value not parent
       (not Assigned(Mirror.Mirror) or // Continue through mirror chain
        IsMirrorAllowed(Mirror.Mirror));
    end;  { IsMirrorAllowed }

  begin { Include }
    Result := (Value <> Instance[0]) and // Can't mirror self
     ((Value is Instance[0].ClassType) or // Only mirror same class types
      ((Instance[0] is Value.ClassType) and (UserLevel = ulAdvanced))) and
     not IsValueParentOf(Instance[0]) and // Don't allow Value as a parent of Instance[0]
     (not (Value is TRaveControl) or // Check the mirror chain for mirror loops
      not Assigned(TRaveControl(Value).Mirror) or
      IsMirrorAllowed(TRaveControl(Value).Mirror));
  end;  { Include }

(*****************************************************************************}
( class TRaveGotoPagePropertyEditor
(*****************************************************************************)

  function TRaveGotoPagePropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := [poListing,poNoSort];
  end;  { GetOptions }

  function TRaveGotoPagePropertyEditor.Include(Value: TComponent;
                                               Data: longint): boolean;

    function IsCircular(Page: TRavePage): boolean;

    begin { IsCircular }
      If Page.GotoMode = gmGotoNotDone then begin
        Result := false;
      end else begin
        Result := (Page = Instance[0]);
        If not Result and Assigned(Page.GotoPage) then begin
          Result := IsCircular(Page.GotoPage);
        end; { if }
      end; { else }
    end;  { IsCircular }

  begin { Include }
    Result := (Value <> Instance[0]) and (Value is TRavePage) and
     (not TRavePage(Instance[0]).Global or TRavePage(Value).Global) and
     not IsCircular(TRavePage(Value));
  end;  { Include }

(*****************************************************************************}
( class TRaveLockedPropertyEditor
(*****************************************************************************)

  function TRaveLockedPropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := [poMultiSelect,poListing,poRefreshAll];
  end;  { GetOptions }

  function TRaveLockedPropertyEditor.GetValue: string;

  var
    I1: integer;
    Value: string;
    Inst: TRaveComponent;
    Locker: TRaveComponent;
    LockerName: string;

  begin { GetValue }
    Inst := Instance[0];
    If Inst.IsLocked then begin
      Locker := Inst.GetLocker;
      If Locker = Inst then begin
        If Name = {Trans-}'DevLocked' then begin
          If Inst.DevLocked then begin
            Value := Trans('True');
          end else begin
            Value := Trans('False');
          end; { else }
        end else begin
          If Inst.Locked then begin
            Value := Trans('True');
          end else begin
            Value := Trans('False');
          end; { else }
        end; { else }
        LockerName := '';
      end else begin
        Value := Trans('True');
        LockerName := Locker.Name;
      end; { else }
    end else begin
      Value := Trans('False');
      LockerName := '';
    end; { else }
    For I1 := 1 to InstCount - 1 do begin
      Inst := Instance[I1];
      If Inst.IsLocked then begin
        If Value <> Trans('True') then begin
          Result := '';
          Exit;
        end; { if }
        Locker := Inst.GetLocker;
        If ((Locker = Inst) and (LockerName <> '')) or
         ((Locker <> Inst) and (LockerName <> Locker.Name)) then begin
          LockerName := '*';
        end; { if }
      end else begin
        If Value <> Trans('False') then begin
          Result := '';
          Exit;
        end; { if }
      end; { else }
    end; { for }

    If LockerName = '' then begin
      Result := Trans(Value);
    end else begin
      If LockerName = '*' then begin
        Result := Trans('True (multiple)');
      end else begin
        Result := Trans(Format({Trans+}'True (by %s)',[LockerName]));
      end; { else }
    end; { else }
  end;  { GetValue }

(*****************************************************************************}
( class TRaveUnitsPropertyEditor
(*****************************************************************************)

  function TRaveUnitsPropertyEditor.GetValue: string;

  var
    I1: integer;
    Value1: extended;
    Value2: extended;

  begin { GetValue }
    Value1 := GetFloatValue(0);
    For I1 := 1 to InstCount - 1 do begin
      Value2 := GetFloatValue(I1);
      If Value1 <> Value2 then begin
        Result := '';
        Exit;
      end; { if }
    end; { for }
    Value1 := Value1 * ProjectManager.UnitsFactor;
    Result := Flt2Str(Value1,FloatPropPrecision);
  end;  { GetValue }

  procedure TRaveUnitsPropertyEditor.SetValue(Value: string);

  var
    Value1: extended;

  begin { SetValue }
    try
      Value1 := StrToFloat(Value) / ProjectManager.UnitsFactor;
      SetFloatValue(Value1);
    except
      MessageDlg(Trans(Format({Trans+}'"%s" is not a valid floating point.',[Value])),
       mtError,[mbOk],0);
    end; { tryx }
  end;  { SetValue }

(*****************************************************************************}
( class TRavePasswordPropertyEditor
(*****************************************************************************)

  function TRavePasswordPropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := inherited GetOptions + [poPassword];
  end;  { GetOptions }

initialization
  RegisterProc('RVCL',RaveRegister);
end.

{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVUtil;

interface

uses
  {$IFDEF Linux}
  QForms, QGraphics, QMenus, QImgList, QControls,
  {$ELSE}
  Windows, Registry, Forms, Graphics, Menus, ImgList, Controls,
  {$ENDIF}
  Classes, SysUtils, RVDefine, RPDefine;

const
  NoCompression = 0;
  CompressMethod1 = 1; { No longer supported }
  CompressMethod2 = 2; { Default in RVCmHuff.pas }

var
  DefaultCompressMethod: integer = CompressMethod2;

type
  ERaveException = class(Exception);

  TRaveStackList = class(TList)
  protected
    function GetEmpty: boolean;
    function GetTop: pointer;
  public
    procedure Push(Item: pointer);
    function Pop: pointer;
    function Peek(Down: integer): pointer;

    property Empty: boolean read GetEmpty;
    property Top: pointer read GetTop;
  end; { TRaveStackList }

  TStreamHelper = class
  protected
    FStream: TStream;
    FCompressMethod: byte;
    LastPos: longint;
    StreamStack: TRaveStackList;

    function CreateMarker: longint;
    procedure UpdateMarker(Marker: longint);
  public
    constructor Create(AStream: TStream);
    destructor Destroy; override;
    function PopStream: TStream;
    procedure PushStream(AStream: TStream);

    procedure SavePos;
    procedure RestorePos;
    procedure WriteByte(Value: byte);
    procedure WriteString(Value: string);
    procedure WriteIndex(Value: longint);
    procedure WriteBuf(var Buf;
                           Len: longint);
    procedure StartWriteBlock;
    procedure FinishWriteBlock;
    procedure StartReadBlock;
    procedure FinishReadBlock;
    procedure SaveBlock(Source: TStream);
    procedure LoadBlock(Dest: TStream);
    procedure SkipBlock;
    function Empty: boolean;

    function ReadByte: byte;
    function ReadString: string;
    function ReadIndex: longint;
    procedure ReadBuf(var Buf;
                          Len: integer);

    property Stream: TStream read FStream;
    property CompressMethod: byte read FCompressMethod write FCompressMethod;
  end; { TStreamHelper }

  procedure CloneObject(Source: TPersistent;
                        Dest: TPersistent);
{$IFDEF DESIGNER}
  procedure MergeMainMenu(MainMenu: TMenu;
                          SubMenu: TMenu);
{$ENDIF}
  function ModColor(Color: TColor): TColor;
  function ShowOptionalDialog(AOwner: TComponent;
                              FormCaption: String;
                              Msg: string;
                              Key: string) : boolean;

  function ValidID(Value: string): string;
  procedure CopyList(FromList: TList;
                     ToList: TList);
  procedure AbortReport(Component: TComponent);
  function ExtractQuotedString(var Value: string;
                                   Quote: char): string;
  function CutWord(var Value: string;
                   var SepCh: char;
                       SepStr: string): string;
  function StripJoinChars(Value: string): string;
  function AddJoinChars(Value: string): string;
  procedure RaveError(ErrorMessage: string);
  procedure SaveToolWin(ToolWin: TForm);
  procedure PrepareToolWin(ToolWin: TForm);
  procedure RestoreToolWin(ToolWin: TForm);
  procedure SetControlsEnabled(State: boolean;
                               Controls: array of TControl);
  function OffsetToIndex(Offset: longint): longint;
  function IndexToOffset(Index: longint): longint;
  procedure ClearObjectList(List: TList);
  procedure ClearStringList(List: TStrings);
  function FindString(InStr: string;
                      SearchString: string): integer;
  function SameStr(S1: string;
                   S2: string): boolean;
  function MinI(I1,I2: integer): integer;
  function MaxI(I1,I2: integer): integer;
  procedure MinMaxI(var Out1,Out2: integer;
                        In1,In2: integer);
  function MinF(F1,F2: TRaveFloat): TRaveFloat;
  function MaxF(F1,F2: TRaveFloat): TRaveFloat;
  procedure MinMaxF(var Out1,Out2: TRaveFloat;
                        In1,In2: TRaveFloat);
  function Flt2Str(Value: TRaveFloat;
                   Digits: byte): string;
  function FEQ(F1,F2: TRaveFloat): boolean;
  function FGT(F1,F2: TRaveFloat): boolean;
  function FLT(F1,F2: TRaveFloat): boolean;
  function FNE(F1,F2: TRaveFloat): boolean;
  function FLE(F1,F2: TRaveFloat): boolean;
  function FGE(F1,F2: TRaveFloat): boolean;
  function RaveRect(Left: TRaveUnits;
                    Top: TRaveUnits;
                    Right: TRaveUnits;
                    Bottom: TRaveUnits): TRaveRect;
  function RavePoint(X: TRaveUnits;
                     Y: TRaveUnits): TRavePoint;
  function PtInRaveRect(Rect: TRaveRect;
                        Point: TRavePoint): boolean;
  function IntersectRaveRect(var SharedRect: TRaveRect;
                                 Rect1: TRaveRect;
                                 Rect2: TRaveRect): boolean;
  function StripFloatStr(Value: string): string;
  function StrToFloatDef(Value: string;
                         Def: double): double;
  function StrToCurrDef(Value: string;
                        Def: currency): currency;
  function StrToDateTimeDef(Value: string;
                            Def: TDateTime): TDateTime;


var
  CompressStreamProc: procedure(CompressMethod: byte;
                                InStream: TStream;
                                OutStream: TStream) = nil;
  UncompressStreamProc: procedure(CompressMethod: byte;
                                  InStream: TStream;
                                  OutStream: TStream) = nil;

implementation

uses
  {$IFDEF Linux}
  QButtons, QStdCtrls, QExtCtrls,
  {$ELSE}
  Buttons, StdCtrls, ExtCtrls, TypInfo,
  {$ENDIf}
  RVCmHuff, RVClass, RVProj;

// !!! Move out of RVUtil and remove reliance on Menus unit

procedure CloneObject(Source: TPersistent;
                      Dest: TPersistent);

var
  Count: integer;
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  PropList: PPropList;
  PropInfo: PPropInfo;
  {$ENDIF}
  I1: integer;
  Driver: TPersistent;

begin { CloneObject }
  If Dest is Source.ClassType then begin { Source is driver }
    Driver := Source;
  end else if Source is Dest.ClassType then begin { Dest is driver }
    Driver := Dest;
  end else begin { Invalid }
    RaveError('Invalid CloneObject()');
    Exit;
  end; { else }
  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  Count := GetTypeData(Driver.ClassInfo)^.PropCount;
  If Count > 0 then begin
    GetMem(PropList,Count * SizeOf(pointer));
    try
      GetPropInfos(Driver.ClassInfo,PropList);
      For I1 := 0 to (Count - 1) do begin
        PropInfo := PropList^[I1];

      {TransOff}
        If (CompareText(PropInfo.Name,'Name') = 0) or
         (CompareText(PropInfo.Name,'DevLocked') = 0) or
         (CompareText(PropInfo.Name,'Locked') = 0) or
         (CompareText(PropInfo.Name,'Mirror') = 0) or
         (CompareText(PropInfo.Name,'Top') = 0) or
         (CompareText(PropInfo.Name,'Left') = 0) then Continue;
      {TransOn}

      //!!! Do we need to set TPersistent properties individually?
        Case PropInfo.PropType^.Kind of
          tkInteger,tkChar,tkEnumeration: SetOrdProp(Dest,PropInfo,
           GetOrdProp(Source,PropInfo));
          tkFloat: SetFloatProp(Dest,PropInfo,GetFloatProp(Source,PropInfo));
          tkString: SetStrProp(Dest,PropInfo,GetStrProp(Source,PropInfo));
          tkSet,tkClass: SetOrdProp(Dest,PropInfo,GetOrdProp(Source,PropInfo));
          tkMethod: SetMethodProp(Dest,PropInfo,GetMethodProp(Source,PropInfo));
          tkWChar: SetOrdProp(Dest,PropInfo,GetOrdProp(Source,PropInfo));
          tkLString,tkWString: SetStrProp(Dest,PropInfo,GetStrProp(Source,PropInfo));
          tkVariant: SetVariantProp(Dest,PropInfo,GetVariantProp(Source,PropInfo));
        { Types not supported as properties: tkArray,tkRecord,tkInterface }
        end; { case }
      end; { for }
    finally
      FreeMem(PropList,Count * SizeOf(pointer));
    end; { tryf }
  end; { if }
  {$ENDIF}
end;  { CloneObject }

{$IFDEF DESIGNER}
  procedure MergeSubMenu(MainItems: TMenuItem;
                         SubItems: TMenuItem);

  var
    I1: integer;
    SubItem: TMenuItem;
  //  NewItem: TMenuItem;

  begin { MergeSubMenu }
    While SubItems.Count > 0 do begin
      SubItem := SubItems[0];
      SubItems.Remove(SubItem);
      If SubItem.GroupIndex = 0 then begin // Append
      //  NewItem := TMenuItem.Create(MainItems.Owner);
      //  CloneObject(SubItem,NewItem);
        MainItems.Add(SubItem);
      end else begin // Find place to merge
        For I1 := 0 to MainItems.Count - 1 do begin
          If MainItems[I1].GroupIndex > SubItem.GroupIndex then begin
          //  NewItem := TMenuItem.Create(MainItems.Owner);
          //  CloneObject(SubItem,NewItem);
            MainItems.Insert(I1,SubItem);
            Break;
          end else if MainItems[I1].GroupIndex = SubItem.GroupIndex then begin
            If (MainItems[I1].Caption = SubItem.Caption) then begin
            // Merge sub items with current MainItem
              MergeSubMenu(MainItems[I1],SubItem);
              Break;
            end else if (MainItems[I1].Caption > SubItem.Caption) then begin
            // Insert sub item
            //  NewItem := TMenuItem.Create(MainItems.Owner);
            //  CloneObject(SubItem,NewItem);
              MainItems.Insert(I1,SubItem);
              Break;
            end; { else }
          end; { if }
        end; { for }
      end; { else }
    end; { while }
  end;  { MergeSubMenu }

  procedure UpdateImages(MenuItem: TMenuItem;
                         ImageList: TCustomImageList);

  var
    I1: integer;

  begin { UpdateImages }
    If not Assigned(MenuItem.SubMenuImages) then begin
      MenuItem.SubMenuImages := ImageList;
    end; { if }
    For I1 := 0 to MenuItem.Count - 1 do begin
      UpdateImages(MenuItem[I1],ImageList);
    end; { for }
  end;  { UpdateImages }

  procedure MergeMainMenu(MainMenu: TMenu;
                          SubMenu: TMenu);

  begin { MergeMainMenu }
    If Assigned(SubMenu.Images) then begin // Merge ImageLists
      UpdateImages(SubMenu.Items,SubMenu.Images);
    end; { if }
    MergeSubMenu(MainMenu.Items,SubMenu.Items);
  end;  { MergeMainMenu }
{$ENDIF}

  function ModColor(Color: TColor): TColor;

  begin { ModColor }
//    If (Color >= 0) and (Color <= $FFFFFF) then begin
//      Result := TColor($FFFFFF - integer(Color));
//    end else begin
      Result := Color;
//    end; { else }
  end;  { ModColor }

  function ShowOptionalDialog(AOwner: TComponent;
                              FormCaption: String;
                              Msg: string;
                              Key: string) : boolean;

  var
    OptionalDialog: TForm;
    BasePanel: TPanel;
    LabelPanel: TPanel;
    BtnPanel: TPanel;
    MsgLabel: TLabel;
    BtnOkay: TBitBtn;
    CheckBox: TCheckBox;
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    Registry: TRegistry;
    {$ENDIF}
    MaxMsg: string;
    TmpMsg: string;
    MaxMsgWidth: double;
    CurrLineWidth: integer;
    MsgLines: double;
    NumCRs: integer;
    NumLFs: integer;
    I1: integer;
    D1: integer;

    function ReadDef(Name: string;
                     Def: string): string;

    begin { ReadDef }
      {$IFDEF Linux}
      //!!PORT!!
      {$ELSE}
      If Registry.ValueExists(Name) then begin
        Result := Registry.ReadString(Name);
      end else begin
        Result := Def;
        Registry.WriteString(Name,Def); { Write the default value out }
      end; { else }
      {$ENDIF}
    end;  { ReadDef }

  begin
    OptionalDialog := TForm.Create(AOwner);
    With OptionalDialog do try
      SetBounds(341, 179, 336, 121);
      Caption := Trans('Message Dialog');
      Font.Color := clWindowText;
      Font.Height := -11;
      Font.Name := {Trans-}'Arial';
      Font.Style := [];
      Scaled := False;
      PixelsPerInch := 96;
      {$IFDEF Linux}
      //!!PORT!!
      {$ELSE}
      BorderStyle := bsDialog;
      {$ENDIF}
      Position := poScreenCenter;
      BasePanel := TPanel.Create(OptionalDialog);
      With BasePanel do begin
        Parent := OptionalDialog;
        SetBounds(0,0, 328, 94);
        Align := alClient;
        Caption := '';
        TabOrder := 0;
        LabelPanel := TPanel.Create(OptionalDialog);
        With LabelPanel do begin
          Parent := OptionalDialog;
          BevelOuter := bvNone;
          SetBounds(10, 10, Parent.Width - 22, Parent.Height - 22);
        { BorderWidth := 10; Causes problems with Delphi 4.00 and 4.01 }
          Caption := '';
          TabOrder := 0;
          MsgLabel := TLabel.Create(OptionalDialog);
          With MsgLabel do begin
            Parent := LabelPanel;
            SetBounds(11, 11, 306, 31);
            Align := alClient;
            AutoSize := false;
          end; { with }
          BtnPanel := TPanel.Create(OptionalDialog);
          With BtnPanel do begin
            Parent := LabelPanel;
            SetBounds(11, 42, 306, 35);
            Align := alBottom;
            BevelOuter := bvNone;
            TabOrder := 0;
            CheckBox := TCheckBox.Create(OptionalDialog);
            With CheckBox do begin
              Parent := BtnPanel;
              SetBounds(1, 10, 184, 15);
              Caption := Trans('Show this Message Next Time');
              State := cbChecked;
              TabOrder := 1;
            end; { with }
            BtnOkay := TBitBtn.Create(OptionalDialog);
            With BtnOkay do begin
              Parent := BtnPanel;
              SetBounds(Parent.Width - 75 - LabelPanel.BorderWidth, 5, 75, 25);
              Caption := Trans('&OK');
              ModalResult := mrOk;
              TabOrder := 0;
            end; { with }
          end; { with }
        end; { with }
      end; { with }
      {$IFDEF Linux}
      //!!PORT!!
      {$ELSE}
      Registry := TRegistry.Create;
      With Registry do try
        If OpenKey(RegRoot + {Trans-}'Dialogs\',true) then begin
          Checkbox.Checked := ReadDef(Key,'1') = '1';
        end else begin
          Checkbox.Checked := false;
        end; { else }
      finally
        Free;
      end; { with }
      {$ENDIF}
      Result := Checkbox.Checked;

      If not Result then begin
        Exit;
      end; { if }

      I1 := 1;
      While (I1 + 80 < Length(Msg)) and (Length(Msg) > 80) do begin
        I1 := I1 + 80;
        While (I1 < Length(Msg)) and (I1 > 1) and (Msg[I1] <> ' ') do begin
          Dec(I1);
        end; { while }
        If Msg[I1] = ' ' then begin
          Msg[I1] := #13;
        end; { if }
      end; { for }
      MsgLabel.Caption := Msg;

      NumCRs := 0;
      NumLFs := 0;
      CurrLineWidth := 0;
      MaxMsg := '';
      MaxMsgWidth := 0;
      TmpMsg := '';
      MsgLines := 1;
      For I1 := 1 to Length(Msg) do begin
        If Msg[I1] = #13 then begin
          NumCRs := NumCRs + 1;
          CurrLineWidth := 0;
          TmpMsg := '';
          If I1 = Length(Msg) then begin
            MsgLines := MsgLines + MaxI(NumLFs,NumCRs);
          end; { if }
        end else if Msg[I1] = #10 then begin
          NumLFs := NumLFs + 1;
          CurrLineWidth := 0;
          TmpMsg := '';
          If I1 = Length(Msg) then begin
            MsgLines := MsgLines + MaxI(NumLFs,NumCRs);
          end; { if }
        end else begin
          If (I1 > 1) and ((Msg[I1-1] = #13) or (Msg[I1-1] = #10)) then begin
            MsgLines := MsgLines + MaxI(NumLFs,NumCRs);
            NumLFs := 0;
            NumCRs := 0;
          end; { if }
          TmpMsg := TmpMsg + Msg[I1];
          CurrLineWidth := CurrLineWidth + 1;
          If CurrLineWidth > MaxMsgWidth then begin
            MaxMsg := TmpMsg;
            MaxMsgWidth := CurrLineWidth;
          end; { if }
        end; { else }
      end; { for }

      D1 := OptionalDialog.Canvas.TextWidth(MaxMsg) - MsgLabel.Width;
      OptionalDialog.Width := Trunc(MaxI(OptionalDialog.Width + Trunc(D1),OptionalDialog.Width));
      D1 := (OptionalDialog.Canvas.TextHeight(MaxMsg) * Trunc(MsgLines)) - MsgLabel.Height;
      OptionalDialog.Height := Trunc(MaxI(OptionalDialog.Height + D1,OptionalDialog.Height));

      BtnOkay.Left := OptionalDialog.Width - 105;
      LabelPanel.Height := BasePanel.Height - 20;
      LabelPanel.Width := BasePanel.Width - 20;

      ShowModal;

      If Checkbox.Checked <> Result then begin
        Result := Checkbox.Checked;
        {$IFDEF Linux}
        //!!PORT!!
        {$ELSE}
        Registry := TRegistry.Create;
        With Registry do try
          If OpenKey(RegRoot + {Trans-}'Dialogs\',true) then begin
            If Result then begin
              WriteString(Key,'1');
            end else begin
              WriteString(Key,'0');
            end; { else }
          end; { else }
        finally
          Free;
        end; { with }
        {$ENDIF}
      end; { if }

    finally
      free;
    end; { with }
  end;

  function ValidID(Value: string): string;

  var
    I1: integer;
    LastValid: boolean;

  begin { ValidID }
    Result := '';
    LastValid := true;
    For I1 := 1 to Length(Value) do begin
      If Value[I1] in ['0'..'9','a'..'z','A'..'Z','_'] then begin
        Result := Result + Value[I1];
        LastValid := true;
      end else begin
        If LastValid then begin
          LastValid := false;
          Result := Result + '_';
        end; { if }
      end; { if }
    end; { for }
  end;  { ValidID }

  procedure CopyList(FromList: TList;
                     ToList: TList);

  begin { CopyList }
    ToList.Count := FromList.Count;
    Move(FromList.List^,ToList.List^,ToList.Count * SizeOf(pointer));
  end;  { CopyList }

  procedure AbortReport(Component: TComponent);

  begin { AbortReport }
    If (Component is TRaveComponent) and Assigned(TRaveProjectManager(
     TRaveComponent(Component).Project).BaseReport) then begin
      TRaveProjectManager(TRaveComponent(Component).Project).BaseReport.Abort;
      Abort;
    end; { if }
  end;  { AbortReport }

  function CutWord(var Value: string;
                   var SepCh: char;
                       SepStr: string): string;

  var
    I1: integer;
    CutLen: integer;
    NoSep: boolean;

  begin { CutWord }
  { Find first occurrence of SepStr characters }
    CutLen := -1;
    SepCh := #0;
    I1 := 0;
    NoSep := false;
    While I1 < Length(Value) do begin
      Inc(I1);
      If Value[I1] = '<' then begin
        NoSep := true;
      end else if Value[I1] = '>' then begin
        NoSep := false;
      end else if not NoSep then begin
        If Pos(Value[I1],SepStr) > 0 then begin { Found separator }
          SepCh := Value[I1];
          CutLen := I1 - 1;
          Break;
        end; { if }
      end; { else }
    end; { while }

    If CutLen >= 0 then begin
      If CutLen = 0 then begin
        Result := '';
      end else begin
        Result := Trim(Copy(Value,1,CutLen));
      end; { else }
      Delete(Value,1,CutLen + 1);
      Value := Trim(Value);
    end else begin
      Result := Trim(Value);
      Value := '';
    end; { else }
  end;  { CutWord }

  function StripJoinChars(Value: string): string;

  var
    I1: integer;
    InJoin: boolean;

  begin { StripJoinChars }
    Result := '';
    InJoin := false;
    For I1 := 1 to Length(Value) do begin
      If Value[I1] = '<' then begin
        InJoin := true;
      end else if InJoin and (Value[I1] = '>') then begin
        InJoin := false;
      end else begin
        Result := Result + Value[I1];
      end; { else }
    end; { for }
  end;  { StripJoinChars }

  function AddJoinChars(Value: string): string;

  var
    I1: integer;
    NeedJoin: boolean;

  begin { AddJoinChars }
    If (Length(Value) > 0) and (Value[1] = '<') then begin
      Result := Value;
      Exit;
    end; { if }
    NeedJoin := false;
    For I1 := 1 to Length(Value) do begin
      If not (Value[I1] in ['0'..'9','A'..'Z','_','a'..'z']) then begin
        NeedJoin := true;
        Break;
      end; { if }
    end; { for }
    If NeedJoin then begin
      Result := '<' + Value + '>';
    end else begin
      Result := Value;
    end; { else }
  end;  { AddJoinChars }

  function ExtractQuotedString(var Value: string;
                                   Quote: char): string;

  var
    I1: integer;

  begin { ExtractQuotedString }
    Result := '';
    If (Length(Value) = 0) or (Value[1] <> Quote) then Exit;
    I1 := 1;
    While I1 < Length(Value) do begin
      Inc(I1);
      If (Value[I1] = Quote) then begin
        Inc(I1);
        If (I1 > Length(Value)) or (Value[I1] <> Quote) then Break;
      end; { if }
      Result := Result + Value[I1];
    end; { while }
    Delete(Value,1,I1 - 1);
    Value := Trim(Value);
  end;  { ExtractQuotedString }

  procedure RaveError(ErrorMessage: string);

  begin { RaveError }
    Raise ERaveException.Create(ErrorMessage);
  end;  { RaveError }

{ Call this proc in a form's OnDestroy event to save the current state }

  procedure SaveToolWin(ToolWin: TForm);

  begin { SaveToolWin }
  {TransOff}
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    With TRegistry.Create do try
      OpenKey(RegRoot + 'Dialogs\' + ToolWin.Name,true);
      WriteString('Left',IntToStr(ToolWin.Left));
      WriteString('Top',IntToStr(ToolWin.Top));
      If (ToolWin.BorderStyle = bsSizeToolWin) or (ToolWin.BorderStyle = bsSizeable) then begin
        WriteString('Height',IntToStr(ToolWin.Height));
        WriteString('Width',IntToStr(ToolWin.Width));
      end; { if }
    finally
      Free;
    end; { with }
    {$ENDIF}
  {TransOn}
  end;  { SaveToolWin }

{ Call this proc in a form's OnCreate event to prepare the Position property }

  procedure PrepareToolWin(ToolWin: TForm);

  begin { PrepareToolWin }
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    With TRegistry.Create do try
      If OpenKey(RegRoot + {Trans-}'Dialogs\' + ToolWin.Name,false) then begin
        ToolWin.Position := poDesigned;
      end else begin
        ToolWin.Position := poScreenCenter;
      end; { else }
    finally
      Free;
    end; { with }
    {$ENDIF}
  end;  { PrepareToolWin }

{ Call this proc in a form's OnShow event to restore the forms state }

  procedure RestoreToolWin(ToolWin: TForm);

  begin { RestoreToolWin }
  {TransOff}
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    With TRegistry.Create do try
      If OpenKey(RegRoot + 'Dialogs\' + ToolWin.Name,false) then begin
        If ValueExists('Left') then begin
          ToolWin.Left := MinI(StrToInt(ReadString('Left')),Screen.Width - 32);
        end; { if }
        If ValueExists('Top') then begin
          ToolWin.Top := MinI(StrToInt(ReadString('Top')),Screen.Height - 32);
        end; { if }
        If (ToolWin.BorderStyle = bsSizeToolWin) or (ToolWin.BorderStyle = bsSizeable) then begin
          If ValueExists('Width') then begin
            ToolWin.Width := StrToInt(ReadString('Width'));
          end; { if }
          If ValueExists('Height') then begin
            ToolWin.Height := StrToInt(ReadString('Height'));
          end; { if }
        end; { if }
      end; { if }
    finally
      Free;
    end; { with }
    {$ENDIF}
  {TransOn}
  end;  { RestoreToolWin }

  procedure SetControlsEnabled(State: boolean;
                               Controls: array of TControl);

  var
    I1: integer;
    I2: integer;
    Item: TControl;

  begin { SetControlsEnabled }
    For I1 := Low(Controls) to High(Controls) do begin
      Item := Controls[I1];
      Item.Enabled := State;
      If Item is TWinControl then begin
        For I2 := 0 to TWinControl(Item).ControlCount - 1 do begin
          SetControlsEnabled(State,[TWinControl(Item).Controls[I2]]);
        end; { for }
      end; { if }
    end; { for }
  end;  { SetControlsEnabled }

  function OffsetToIndex(Offset: longint): longint;

  begin { OffsetToIndex }
    Result := Offset * 2;
    If Offset < 0 then begin
      Result := -(Result + 1);
    end; { if }
  end;  { OffsetToIndex }

  function IndexToOffset(Index: longint): longint;

  begin { IndexToOffset }
    Result := Index div 2;
    If Odd(Index) then begin
      Result := -(Result + 1);
    end; { else }
  end;  { IndexToOffset }

  procedure ClearObjectList(List: TList);

  var
    I1: integer;

  begin { ClearObjectList }
    If not Assigned(List) then Exit;
    For I1 := 0 to (List.Count - 1) do begin
      If Assigned(List[I1]) then begin
        TObject(List[I1]).Free;
      end; { if }
    end; { for }
    List.Clear;
  end;  { ClearObjectList }

  procedure ClearStringList(List: TStrings);

  var
    I1: integer;

  begin { ClearStringList }
    If not Assigned(List) then Exit;
    For I1 := 0 to (List.Count - 1) do begin
      If List.Objects[I1] <> nil then begin
        List.Objects[I1].Free;
      end; { if }
    end; { for }
    List.Clear;
  end;  { ClearStringList }

  function FindString(InStr: string;
                      SearchString: string): integer;

  var
    FoundPos: integer;
    I1: integer;

  begin { FindString }
    FoundPos := Pos('`' + InStr + '`',SearchString + '`');
    Result := 0;
    For I1 := 1 to FoundPos do begin
      If SearchString[I1] = '`' then begin
        Inc(Result);
      end; { if }
    end; { for }
  end;  { FindString }

  function SameStr(S1: string;
                   S2: string): boolean;

  begin { SameStr }
    If (S1 = '') or (S2 = '') then begin
      Result := (S1 = S2);
    end else begin
      {$IFDEF Linux}
      //!!PORT!!
      {$ELSE}
      Result := CompareString(LOCALE_USER_DEFAULT,NORM_IGNORECASE,
       @S1[1],Length(S1),@S2[1],Length(S2)) = 2;
      {$ENDIF}
    end; { else }
  end;  { SameStr }

  function Flt2Str(Value: TRaveFloat;
                   Digits: byte): string;

  begin { Flt2Str }
    Result := FloatToStrF(Value,ffFixed,15,Digits);
    If Pos('.',Result) > 0 then begin
      While Result[Length(Result)] = '0' do begin
        Delete(Result,Length(Result),1);
      end; { while }
      If Result[Length(Result)] = '.' then begin
        Delete(Result,Length(Result),1);
      end; { if }
    end; { if }
  end;  { Flt2Str }

  function MinI(I1,I2: integer): integer;

  begin { MinI }
    If I1 <= I2 then begin
      Result := I1;
    end else begin
      Result := I2;
    end; { else }
  end;  { MinI }

  function MaxI(I1,I2: integer): integer;

  begin { MaxI }
    If I1 >= I2 then begin
      Result := I1;
    end else begin
      Result := I2;
    end; { else }
  end;  { MaxI }

  procedure MinMaxI(var Out1,Out2: integer;
                        In1,In2: integer);

  begin { MinMaxI }
    If In1 < In2 then begin
      Out1 := In1;
      Out2 := In2;
    end else begin
      Out1 := In2;
      Out2 := In1;
    end; { else }
  end;  { MinMaxI }

  function MinF(F1,F2: TRaveFloat): TRaveFloat;

  begin { MinF }
    If F1 <= F2 then begin
      Result := F1;
    end else begin
      Result := F2;
    end; { else }
  end;  { MinF }

  function MaxF(F1,F2: TRaveFloat): TRaveFloat;

  begin { MaxF }
    If F1 >= F2 then begin
      Result := F1;
    end else begin
      Result := F2;
    end; { else }
  end;  { MaxF }

  procedure MinMaxF(var Out1,Out2: TRaveFloat;
                        In1,In2: TRaveFloat);

  begin { MinMaxF }
    If In1 < In2 then begin
      Out1 := In1;
      Out2 := In2;
    end else begin
      Out1 := In2;
      Out2 := In1;
    end; { else }
  end;  { MinMaxF }

  function FEQ(F1,F2: TRaveFloat): boolean;

  begin { FEQ }
    Result := Abs(F1 - F2) <= RaveDelta;
  end;  { FEQ }

  function FGT(F1,F2: TRaveFloat): boolean;

  begin { FGT }
    Result := (F1 - F2) >= RaveDelta;
  end;  { FGT }

  function FLT(F1,F2: TRaveFloat): boolean;

  begin { FLT }
    Result := (F2 - F1) >= RaveDelta;
  end;  { FLT }

  function FNE(F1,F2: TRaveFloat): boolean;

  begin { FNE }
    Result := not FEQ(F1,F2);
  end;  { FNE }

  function FLE(F1,F2: TRaveFloat): boolean;

  begin { FLE }
    Result := not FGT(F1,F2);
  end;  { FLE }

  function FGE(F1,F2: TRaveFloat): boolean;

  begin { FGE }
    Result := not FLT(F1,F2);
  end;  { FGE }

  function RaveRect(Left: TRaveUnits;
                    Top: TRaveUnits;
                    Right: TRaveUnits;
                    Bottom: TRaveUnits): TRaveRect;

  begin { RaveRect }
    Result.Left := Left;
    Result.Top := Top;
    Result.Right := Right;
    Result.Bottom := Bottom;
  end;  { RaveRect }

  function RavePoint(X: TRaveUnits;
                     Y: TRaveUnits): TRavePoint;

  begin { RavePoint }
    Result.X := X;
    Result.Y := Y;
  end;  { RavePoint }

  function PtInRaveRect(Rect: TRaveRect;
                        Point: TRavePoint): boolean;

  begin { PtInRaveRect }
    With Rect do begin
      Result := FGE(Point.X,Left) and FLE(Point.X,Right) and FGE(Point.Y,Top) and FLE(Point.Y,Bottom);
    end; { with }
  end;  { PtInRaveRect }

  function IntersectRaveRect(var SharedRect: TRaveRect;
                                 Rect1: TRaveRect;
                                 Rect2: TRaveRect): boolean;

  begin { IntersectRaveRect }
    With SharedRect do begin
      Left := MaxF(Rect1.Left,Rect2.Left);
      Right := MinF(Rect1.Right,Rect2.Right);
      Top := MaxF(Rect1.Top,Rect2.Top);
      Bottom := MinF(Rect1.Bottom,Rect2.Bottom);
      Result := FLE(Left,Right) and FLE(Top,Bottom);
    end; { with }
  end;  { IntersectRaveRect }

  function StripFloatStr(Value: string): string;

  var
    I1: integer;
    Decimal: boolean;

  begin { StripFloatStr }
    Result := '';
    Decimal := false;
    For I1 := 1 to Length(Value) do begin
      If Value[I1] = '-' then begin
        If Length(Result) = 0 then begin
          Result := '-';
        end; { if }
      end else if Value[I1] in ['0'..'9'] then begin
        Result := Result + Value[I1];
      end else if (Value[I1] = DecimalSeparator) and not Decimal then begin
        Decimal := true;
        Result := Result + DecimalSeparator;
      end; { else }
    end; { for }
  end;  { StripFloatStr }

  function StrToFloatDef(Value: string;
                         Def: double): double;
  var
    ErrCode: integer;

  begin { StrToFloatDef }
    If DecimalSeparator <> '.' then begin
      ErrCode := Pos(DecimalSeparator,Value);
      If ErrCode > 0 then begin
        Value[ErrCode] := '.';
      end; { if }
    end; { if }
    Val(Value,Result,ErrCode);
    If ErrCode > 0 then begin
      Result := Def;
    end; { if }
  end;  { StrToFloatDef }

  function StrToCurrDef(Value: string;
                        Def: currency): currency;

  begin { StrToCurrDef }
    try
      Result := StrToCurr(Value);
    except
      Result := Def;
    end; { tryx }
  end;  { StrToCurrDef }

  function StrToDateTimeDef(Value: string;
                            Def: TDateTime): TDateTime;

  begin { StrToDateTimeDef }
    try
      Result := StrToDateTime(Value);
    except
      Result := Def;
    end; { tryx }
  end;  { StrToDateTimeDef }

(*****************************************************************************}
( class TRaveStackList
(*****************************************************************************)

  function TRaveStackList.GetEmpty: boolean;

  begin { GetEmpty }
    Result := (Count = 0);
  end;  { GetEmpty }

  function TRaveStackList.GetTop: pointer;

  begin { GetTop }
    If Count = 0 then begin
      Result := nil;
    end else begin
      Result := Items[Count - 1];
    end; { else }
  end;  { GetTop }

  procedure TRaveStackList.Push(Item: pointer);

  begin { Push }
    Add(Item);
  end;  { Push }

  function TRaveStackList.Pop: pointer;

  begin { Pop }
    Result := Top;
    If Count > 0 then begin
      Delete(Count - 1);
    end; { if }
  end;  { Pop }

  function TRaveStackList.Peek(Down: integer): pointer;

  begin { Peek }
    If Down >= Count then begin
      Result := nil;
    end else begin
      Result := Items[Count - (Down + 1)];
    end; { else }
  end;  { Peek }

(*****************************************************************************}
( class TStreamHelper
(*****************************************************************************)

  constructor TStreamHelper.Create(AStream: TStream);

  begin { Create }
    inherited Create;
    FStream := AStream;
    LastPos := -1;
    StreamStack := TRaveStackList.Create;
    CompressMethod := DefaultCompressMethod;
    PushStream(AStream);
  end;  { Create }

  destructor TStreamHelper.Destroy;

  begin { Destroy }
    While StreamStack.Count > 1 do begin { Delete all but last stream }
      PopStream.Free;
    end; { with }
    StreamStack.Free;
    inherited Destroy;
  end;  { Destroy }

  function TStreamHelper.PopStream: TStream;

  begin { PopStream }
    Result := TStream(StreamStack.Pop);
    FStream := TStream(StreamStack.Top);
  end;  { PopStream }

  procedure TStreamHelper.PushStream(AStream: TStream);

  begin { PushStream }
    StreamStack.Push(AStream);
    FStream := AStream;
  end;  { PushStream }

  procedure TStreamHelper.SavePos;

  begin { SavePos }
    LastPos := Stream.Position;
  end;  { SavePos }

  procedure TStreamHelper.RestorePos;

  begin { RestorePos }
    Stream.Position := LastPos;
  end;  { RestorePos }

  procedure TStreamHelper.WriteByte(Value: byte);

  begin { WriteByte }
    WriteBuf(Value,SizeOf(Value));
  end;  { WriteByte }

  procedure TStreamHelper.WriteString(Value: string);

  begin { WriteString }
    WriteIndex(Length(Value));
    If Length(Value) > 0 then begin
      WriteBuf(Value[1],Length(Value));
    end; { if }
  end;  { WriteString }

  procedure TStreamHelper.WriteIndex(Value: longint);

  begin { WriteIndex }
    If (Value < $00000080) then begin
      WriteByte(Value);
    end else if (Value < $00004000) then begin
      WriteByte(Hi(Value) + $80);
      WriteByte(Lo(Value));
    end else if (Value < $00200000) then begin
      {$IFDEF Linux}
      //!!PORT!!
      {$ELSE}
      WriteByte(Lo(HiWord(Value)) + $C0);
      WriteByte(Hi(LoWord(Value)));
      WriteByte(Lo(LoWord(Value)));
      {$ENDIF}
    end else begin
      {$IFDEF Linux}
      //!!PORT!!
      {$ELSE}
      WriteByte(Hi(HiWord(Value)) + $E0);
      WriteByte(Lo(HiWord(Value)));
      WriteByte(Hi(LoWord(Value)));
      WriteByte(Lo(LoWord(Value)));
      {$ENDIF}
    end; { else }
  end;  { WriteIndex }

  procedure TStreamHelper.WriteBuf(var Buf;
                                       Len: longint);

  begin { WriteBuf }
    Stream.WriteBuffer(Buf,Len);
  end;  { WriteBuf }

  function TStreamHelper.ReadByte: byte;

  begin { ReadByte }
    ReadBuf(Result,SizeOf(Result));
  end;  { ReadByte }

  function TStreamHelper.ReadString: string;

  var
    Len: longint;

  begin { ReadString }
    Len := ReadIndex;
    SetLength(Result,Len);
    If Len > 0 then begin
      ReadBuf(Result[1],Len);
    end; { if }
  end;  { ReadString }

  function TStreamHelper.ReadIndex: longint;

  var
    B1: byte;
    B2: byte;
    B3: byte;

  begin { ReadIndex }
    B1 := ReadByte;
    If (B1 < $80) then begin
      Result := B1;
    end else if (B1 < $C0) then begin
      Result := (longint(B1 - $80) * $0100) + ReadByte;
    end else if (B1 < $E0) then begin
      B2 := ReadByte;
      Result := (((longint(B1 - $C0) * $0100) + B2) * $0100) + ReadByte;
    end else begin
      B2 := ReadByte;
      B3 := ReadByte;
      Result := (((((longint(B1 - $E0) * $0100) + B2) * $0100) + B3) * $0100) +
       ReadByte;
    end; { else }
  end;  { ReadIndex }

  procedure TStreamHelper.ReadBuf(var Buf;
                                      Len: integer);

  begin { ReadBuf }
    Stream.ReadBuffer(Buf,Len);
  end;  { ReadBuf }

  function TStreamHelper.CreateMarker: longint;

  var
    Size: longint;

  begin { CreateMarker }
    Result := Stream.Position;
    Size := 0;
    Stream.WriteBuffer(Size,SizeOf(Size));
  end;  { CreateMarker }

  procedure TStreamHelper.UpdateMarker(Marker: longint);

  var
    Size: longint;
    Marker2: longint;

  begin { UpdateMarker }
    Marker2 := Stream.Position;
    Size := Marker2 - (Marker + SizeOf(Marker));
    Stream.Position := Marker;
    Stream.WriteBuffer(Size,SizeOf(Size));
    Stream.Position := Marker2;
  end;  { UpdateMarker }

  procedure TStreamHelper.StartWriteBlock;

  begin { StartWriteBlock }
    PushStream(TMemoryStream.Create);
  end;  { StartWriteBlock }

  procedure TStreamHelper.FinishWriteBlock;

  var
    Marker: longint;
    BlockStream: TStream;

  begin { FinishWriteBlock }
  { Compress block and add to main stream }
    BlockStream := PopStream;
    WriteByte(CompressMethod);
    Marker := CreateMarker;
    BlockStream.Position := 0;
    CompressStreamProc(CompressMethod,BlockStream,Stream);
    BlockStream.Free;
    UpdateMarker(Marker);
  end;  { FinishWriteBlock }

  procedure TStreamHelper.StartReadBlock;

  var
    ThisCompressMethod: byte;
    ThisSize: longint;
    ThisStream: TStream;

  begin { StartReadBlock }
  { Create memory stream and uncompress into it, set block mode }
    ThisCompressMethod := ReadByte;
    Stream.ReadBuffer(ThisSize,SizeOf(ThisSize));
    ThisStream := TMemoryStream.Create;
    ThisStream.CopyFrom(Stream,ThisSize); { Grab block of compress data }

    If ThisCompressMethod = NoCompression then begin
      PushStream(ThisStream);
    end else begin
      PushStream(TMemoryStream.Create);
      ThisStream.Position := 0;
      UncompressStreamProc(ThisCompressMethod,ThisStream,Stream);
      ThisStream.Free;
    end; { else }
    Stream.Position := 0;
  end;  { StartReadBlock }

  procedure TStreamHelper.FinishReadBlock;

  var
    BlockStream: TStream;

  begin { FinishReadBlock }
    BlockStream := PopStream;
    BlockStream.Free;
  end;  { FinishReadBlock }

  procedure TStreamHelper.SaveBlock(Source: TStream);

  begin { SaveBlock }
    Stream.CopyFrom(Source,0);
  end;  { SaveBlock }

  procedure TStreamHelper.LoadBlock(Dest: TStream);

  var
    ThisCompressMethod: byte;
    ThisSize: longint;

  begin { LoadBlock }
    ThisCompressMethod := ReadByte;
    Stream.ReadBuffer(ThisSize,SizeOf(ThisSize));
  { Write block including header info }
    Dest.WriteBuffer(ThisCompressMethod,SizeOf(ThisCompressMethod));
    Dest.WriteBuffer(ThisSize,SizeOf(ThisSize));
    Dest.CopyFrom(Stream,ThisSize); { Grab block of compress data }
  end;  { LoadBlock }

  procedure TStreamHelper.SkipBlock;

  var
    ThisSize: longint;

  begin { SkipBlock }
    ReadIndex; { CompressionMethod }
    Stream.ReadBuffer(ThisSize,SizeOf(ThisSize));
    Stream.Position := Stream.Position + ThisSize;
  end;  { SkipBlock }

  function TStreamHelper.Empty: boolean;

  begin { Empty }
    Result := (Stream.Position >= Stream.Size);
  end;  { Empty }

(*****************************************************************************}
( Compression functions
(*****************************************************************************)

var
  IStream: TStream;
  OStream: TStream;

  function ReadBuf(var Buffer;
                       Amount: word): word;

  begin { ReadBuf }
    Result := IStream.Read(Buffer,Amount);
  end;  { ReadBuf }

  function WriteBuf(var Buffer;
                        Amount: word): word;

  begin { WriteBuf }
    Result := OStream.Write(Buffer,Amount);
  end;  { WriteBuf }

  procedure RaveCompressStream(CompressMethod: byte;
                               InStream: TStream;
                               OutStream: TStream);

  begin { RaveCompressStream }
    Case CompressMethod of
      0: begin { No compression - Move InStream to OutStream }
        OutStream.CopyFrom(InStream,InStream.Size - InStream.Position);
      end;
      2: begin
        IStream := InStream;
        OStream := OutStream;
        Compress(8,13,ReadBuf,WriteBuf);
      end;
      else begin
        RaveError(Trans(Format({Trans+}'Unknown compression method %s',[CompressMethod])));
      end;
    end; { case }
  end;  { RaveCompressStream }

  procedure RaveUncompressStream(CompressMethod: byte;
                                 InStream: TStream;
                                 OutStream: TStream);

  begin { RaveUncompressStream }
    Case CompressMethod of
      0: begin { No compression - Move InStream to OutStream }
        OutStream.CopyFrom(InStream,InStream.Size - InStream.Position);
      end;
      2: begin
        IStream := InStream;
        OStream := OutStream;
        Decompress(8,13,ReadBuf,WriteBuf);
      end;
      else begin
        RaveError(Trans(Format({Trans+}'Unknown compression method %s',[CompressMethod])));
      end;
    end; { case }
  end;  { RaveUncompressStream }

initialization
  CompressStreamProc := RaveCompressStream;
  UncompressStreamProc := RaveUncompressStream;
end.

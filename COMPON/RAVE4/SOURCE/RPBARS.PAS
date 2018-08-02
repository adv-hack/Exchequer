{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPBars;

interface

uses
  RPBase, RPDefine, Graphics;

type
  TCodePage128 = (cpCodeA, cpCodeB, cpCodeC);
  TBarCodeRotation = (Rot0, Rot90, Rot180, Rot270);
  TOverrideBar = procedure(X1,Y1,X2,Y2: double) of object;
  TOverrideText = procedure(Text: string) of object;

  TRPBarsBase = class
  protected
    FWideFactor: double;
    FBarWidth: double;
    FBarHeight: double;
    FPosition: double;
    FTop: double;
    FBaseReport: TBaseReport;
    FText: string;
    CurrX: double;
    CurrY: double;
    SaveBrush: TBrush;
    SavePen: TPen;
    FUseChecksum: boolean;
    FModulas: integer;
    FPrintReadable: boolean;
    FPrintChecksum: boolean;
    FPrintTop: boolean; { Print Readable text on top of the bar }
    FTextJustify: TPrintJustify;
    FBarCodeJustify: TPrintJustify;
    FBarCodeRotation: TBarCodeRotation;
    FOverrideBar: TOverrideBar;
    FOverrideText: TOverrideText;
    FIsOverride: boolean;
    procedure SetText(Value: string); virtual;
    procedure PrintReadableText; virtual;
    property Modulas: integer read FModulas write FModulas;
    function GetWidth: double;  virtual;
    function GetHeight: double;
    function GetLeft: double;
    procedure SetLeft(Value: double);
    function GetBottom: double;
    procedure SetBottom(Value: double);
    function GetRight: double;
    procedure SetRight(Value: double);
    function GetCenter: double;
    procedure SetCenter(Value: double);
    function GetBarTop: double;
    procedure SetBarTop(Value: double);
    function GetBarBottom: double;
    procedure SetBarBottom(Value: double);
    function GetReadableHeight: double;
    procedure SetUseChecksum(Value: boolean); virtual;

    function GetBarMask(ch: char): string; virtual; abstract;
    function GetChecksum: string; virtual;
    procedure ModifyBar(    BarCh: char;
                        var Width: double;
                        var Height: double;
                        var Top: double); virtual; abstract;
    procedure PrintBarPattern(BarMask: string; BarFirst: boolean; AddSpace: boolean);
    function GetBarcodeText: string; virtual; { Gets Text which will be printed }
    procedure SetPrintReadable(Value: boolean); virtual;
    procedure DrawRect(X1,Y1,X2,Y2: double);
    function IsOverride(Refresh: boolean): boolean;
    procedure SetupCanvas;
    procedure RestoreCanvas;
    procedure CheckForValidCanvas;
  public
    constructor Create(BaseRpt: TBaseReport); virtual;
    procedure Print; virtual; abstract;
    procedure PrintXY(X,Y: double);
    function IsValidChar(Ch: char): boolean; virtual;
    property BaseReport: TBaseReport read FBaseReport write FBaseReport;
    property BarCodeJustify: TPrintJustify read FBarCodeJustify write FBarCodeJustify;
    property BarWidth: double read FBarWidth write FBarWidth;
    property BarHeight: double read FBarHeight write FBarHeight;
    property BarTop: double read GetBarTop write SetBarTop;
    property BarBottom: double read GetBarBottom write SetBarBottom;
    property Center: double read GetCenter write SetCenter;
    property Checksum: string read GetChecksum;
    property Left: double read GetLeft write SetLeft;
    property Height: double read GetHeight;
    property Position: double read FPosition write FPosition;
    property Right: double read GetRight write SetRight;
    property Text: string read FText write SetText;
    property TextJustify: TPrintJustify read FTextJustify write FTextJustify;
    property Top: double read FTop write FTop;
    property Bottom: double read GetBottom write SetBottom;
    property UseChecksum: boolean read FUseChecksum write SetUseChecksum;
    property WideFactor: double read FWideFactor write FWideFactor;
    property Width: double read GetWidth;
    property PrintReadable: boolean read FPrintReadable write FPrintReadable;
    property PrintChecksum: boolean read FPrintChecksum write FPrintChecksum;
    property PrintTop: boolean read FPrintTop write FPrintTop;
    property BarCodeRotation: TBarCodeRotation read FBarCodeRotation write FBarCodeRotation;
    property ReadableHeight: double read GetReadableHeight;
    property OverrideBar: TOverrideBar read FOverrideBar write FOverrideBar;
    property OverrideText: TOverrideText read FOverrideText write FOverrideText;
  end; { TRPBarsBase }

  TRPBarsPostNet = class(TRPBarsBase)
  protected
    function GetBarMask(ch: char): string; override;
    function GetChecksum: string; override;
    procedure ModifyBar(    BarCh: char;
                        var Width: double;
                        var Height: double;
                        var Top: double); override;
    function GetWidth: double; override;
    function GetBarcodeText: string; override; { Gets Text which will be printed }
    procedure SetText(Value: string); override;
  public
    constructor Create(BaseRpt: TBaseReport); override;
    function IsValidChar(Ch: char): boolean; override;
    procedure Print; override;
    procedure PrintFimA(x,y: double);
    procedure PrintFimB(x,y: double);
    procedure PrintFimC(x,y: double);
  end;

  TRPBars2of5 = class(TRPBarsBase)
  protected
    function GetBarMask(ch: char): string; override;
    function GetChecksum: string; override;
    procedure ModifyBar(    BarCh: char;
                        var Width: double;
                        var Height: double;
                        var Top: double); override;
    function GetWidth: double; override;
    function GetBarcodeText: string; override; { Gets Text which will be printed }
  public
    constructor Create(BaseRpt: TBaseReport); override;
    function IsValidChar(Ch: char): boolean; override;
    procedure Print; override;
  end;

  TRPBarsCode39 = class(TRPBarsBase)
  protected
    FExtended: boolean;
    function GetBarMask(ch: char): string; override;
    function GetChecksum: string; override;
    procedure ModifyBar(    BarCh: char;
                        var Width: double;
                        var Height: double;
                        var Top: double); override;
    function GetWidth: double; override;
    function GetExtendedText: string;
    function GetBarcodeText: string; override; { Gets Text which will be printed }
  public
    constructor Create(BaseRpt: TBaseReport); override;
    function IsValidChar(Ch: char): boolean; override;
    procedure Print; override;
    property Extended: boolean read FExtended write FExtended;
    property ExtendedText: string read GetExtendedText;
  end;

  TRPBarsCode128 = class(TRPBarsBase)
  protected
    FCodePage: TCodePage128;
    FCodePageUsed: TCodePage128;
    FUseCodePage: TCodePage128;
    FOptimize: boolean;
    function GetBarMask(Ch: char): string; override;
    function GetChecksum: string; override;
    procedure ModifyBar(    BarCh: char;
                        var Width: double;
                        var Height: double;
                        var Top: double); override;
    function GetWidth: double; override;
    function GetBarcodeText: string; override; { Gets Text which will be printed }
    function CalcOutputStr(MaxLen: byte): string;
    function GetOutputStr: string;
    function CalcChecksum(OutputStr: string): char;
    property UseCodePage: TCodePage128 read FUseCodePage write FUseCodePage;
  public
    constructor Create(BaseRpt: TBaseReport); override;
    function IsValidChar(Ch: char): boolean; override;
    procedure Print; override;
    property CodePage: TCodePage128 read FCodePage write FCodePage;
    property Optimize: boolean read FOptimize write FOptimize;
    property CodePageUsed: TCodePage128 read FCodePageUsed write FCodePageUsed;
  end;

  TRPBarsUPC = class(TRPBarsBase)
  protected
    FPrintingGuard: boolean;
    ValidLen: integer;
    function GetBarMask(ch: char): string; override;
    function GetChecksum: string; override;
    procedure ModifyBar(    BarCh: char;
                        var Width: double;
                        var Height: double;
                        var Top: double); override;
    function GetWidth: double; override;
    function GetBarcodeText: string; override; { Gets Text which will be printed }
    procedure PrintReadableText; override;
    function GetFontSize: double; virtual;
    function GetBottom: double;
    procedure SetBottom(Value: double);
    function GetReadableHeight: double;
    procedure SetUseChecksum(Value: boolean); override;
    procedure SetText(Value: string); override;
  public
    constructor Create(BaseRpt: TBaseReport); override;
    function IsValidChar(Ch: char): boolean; override;
    procedure Print; override;
  end;

  TRPBarsEAN = class(TRPBarsUPC)
  public
    constructor Create(BaseRpt: TBaseReport); override;
    procedure PrintReadableText; override;
    function GetFontSize: double; override;
  end;

implementation

uses
  SysUtils;

{TransOff}
const
  AddSpaceNo: boolean = false;
  AddSpaceYes: boolean = true;
  BarFirstNo: boolean = false;
  BarFirstYes: boolean = true;
  Intrl2of5StartChar: longint = 1111;
  Intrl2of5StopChar: longint = 211;
  Intrl2of5Chars: string[10] = '1234567890';
  Intrl2of5Bars: array[1..10] of longint = (21112,12112,22111,11212,21211,
                                             12211,11122,21121,12121,11221);
  PostNetStart = '20';
  PostNetStop = '2';
  PostNetChars: string[10] = '1234567890';
  PostNetBars: array[1..10] of longint = (1010102020,1010201020,1010202010,
                                          1020101020,1020102010,1020201010,
                                          2010101020,2010102010,2010201010,
                                          2020101010);
  Code39StartStopChar: longint = 121121211; { Char = '*' }
  Code39Chars: string[43] = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%';
  Code39Bars: array[1..43] of longint = (111221211,211211112,112211112,
                                         212211111,111221112,211221111,
                                         112221111,111211212,211211211,
                                         112211211,211112112,112112112,
                                         212112111,111122112,211122111,
                                         112122111,111112212,211112211,
                                         112112211,111122211,211111122,
                                         112111122,212111121,111121122,
                                         211121121,112121121,111111222,
                                         211111221,112111221,111121221,
                                         221111112,122111112,222111111,
                                         121121112,221121111,122121111,
                                         121111212,221111211,122111211,
                                         121212111,121211121,121112121,
                                         111212121);
  Code39CharsExt: string[128] = #0#1#2#3#4#5#6#7#8#9#10#11#12#13#14#15#16#17 +
                                 #18#19#20#21#22#23#24#25#26#27#28#29#30#31 +
                                 ' !"#$%&' + #39 + '()*+,-./0123456789:;<=>?@' +
                                 'ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`' +
                                 'abcdefghijklmnopqrstuvwxyz{|}~' + #127;
  Code39CharsExt2: array[1..128] of string[2] = (('%U'),('$A'),('$B'),('$C'),
                                                 ('$D'),('$E'),('$F'),('$G'),
                                                 ('$H'),('$I'),('$J'),('$K'),
                                                 ('$L'),('$M'),('$N'),('$O'),
                                                 ('$P'),('$Q'),('$R'),('$S'),
                                                 ('$T'),('$U'),('$V'),('$W'),
                                                 ('$X'),('$Y'),('$Z'),('%A'),
                                                 ('%B'),('%C'),('%D'),('%E'),
                                                 (' '),('/A'),('/B'),('/C'),
                                                 ('/D'),('/E'),('/F'),('/G'),
                                                 ('/H'),('/I'),('/J'),('/K'),
                                                 ('/L'),('-'),('.'),('/O'),
                                                 ('0'),('1'),('2'),('3'),('4'),
                                                 ('5'),('6'),('7'),('8'),('9'),
                                                 ('/Z'),('%F'),('%G'),('%H'),
                                                 ('%I'),('%J'),('%V'),('A'),
                                                 ('B'),('C'),('D'),('E'),('F'),
                                                 ('G'),('H'),('I'),('J'),('K'),
                                                 ('L'),('M'),('N'),('O'),('P'),
                                                 ('Q'),('R'),('S'),('T'),('U'),
                                                 ('V'),('W'),('X'),('Y'),('Z'),
                                                 ('%K'),('%L'),('%M'),('%N'),
                                                 ('%O'),('%W'),('+A'),('+B'),
                                                 ('+C'),('+D'),('+E'),('+F'),
                                                 ('+G'),('+H'),('+I'),('+J'),
                                                 ('+K'),('+L'),('+M'),('+N'),
                                                 ('+O'),('+P'),('+Q'),('+R'),
                                                 ('+S'),('+T'),('+U'),('+V'),
                                                 ('+W'),('+X'),('+Y'),('+Z'),
                                                 ('%P'),('%Q'),('%R'),('%S'),
                                                 ('%T')
                                                );
  Code128StartCharA: longint = 211412;
  Code128StartCharB: longint = 211214;
  Code128StartCharC: longint = 211232;
  Code128StopChar: longint = 2331112;
  Code128FNC1       = #241;
  Code128FNC2       = #242;
  Code128FNC3       = #243;
  Code128FNC4       = #244;
  Code128CodeA      = #245;
  Code128CodeB      = #246;
  Code128CodeC      = #247;
  Code128Shift      = #248;
  Code128CharsA: string[103] = ' !"#$%&'#39'()*+,-./' +
                               '0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
                               '[\]^_'#0#1#2#3#4#5#6#7#8#9#10#11#12#13#14#15 +
                               #16#17#18#19#20#21#22#23#24#25#26#27#28#29#30#31 +
                               #243#242#248#247#246#244#241;
  Code128CharsB: string[103] = ' !"#$%&'#39'()*+,-./' +
                               '0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
                               '[\]^_'#96'abcdefghijklmnopqrstuvwxyz{|}~'#127 +
                               #243#242#248#247#244#245#241;
  Code128Bars: array[1..103] of longint = (212222,222122,222221,121223,121322, {0-4}
                                           131222,122213,122312,132212,221213, {5-9}
                                           221312,231212,112232,122132,122231, {10-14}
                                           113222,123122,123221,223211,221132, {15-19}
                                           221231,213212,223112,312131,311222, {20-24}
                                           321122,321221,312212,322112,322211, {25-29}
                                           212123,212321,232121,111323,131123, {30-34}
                                           131321,112313,132113,132311,211313, {35-39}
                                           231113,231311,112133,112331,132131, {40-44}
                                           113123,113321,133121,313121,211331, {45-49}
                                           231131,213113,213311,213131,311123, {50-54}
                                           311321,331121,312113,312311,332111, {55-59}
                                           314111,221411,431111,111224,111422, {60-64}
                                           121124,121421,141122,141221,112214, {65-69}
                                           112412,122114,122411,142112,142211, {70-74}
                                           241211,221114,413111,241112,134111, {75-79}
                                           111242,121142,121241,114212,124112, {80-84}
                                           124211,411212,421112,421211,212141, {85-89}
                                           214121,412121,111143,111341,131141, {90-94}
                                           114113,114311,411113,411311,113141, {95-99}
                                           114131,311141,411131);

  UPCRightLeftGuard: longint = 111;
  UPCCenterGuard: longint = 11111;
  UPCChars: string[10] = '0123456789';
  UPCBars: array[1..10] of longint = (3211,2221,2122,1411,1132,1231,1114,
                                      1312,1213,3112);
{TransOn}

(*****************************************************************************}
( class TRPBarsBase
(*****************************************************************************)

  constructor TRPBarsBase.Create(BaseRpt: TBaseReport);

  begin { Create }
    FBaseReport := BaseRpt;
    FPrintReadable := True;
    FTextJustify := pjCenter;
    FBarCodeJustify := pjLeft;
    FBarCodeRotation := Rot0;
    If BaseReport <> nil then begin
      Top := BaseReport.YPos;
      Left := BaseReport.XPos;
    end; { if }
    BarHeight := 0.5;
    BarWidth := 0.01;
    OverrideBar := nil;
    OverrideText := nil;
  end;  { Create }

  function TRPBarsBase.IsValidChar(Ch: char): boolean;

  begin { IsValidChar }
    Result := true; { intended to be overridden in child class }
  end;  { IsValidChar }

  function TRPBarsBase.GetWidth: double;

  begin { GetWidth }
    Result := 0.0; { intended to be overridden by child class }
  end;  { GetWidth }

  function TRPBarsBase.GetHeight: double;

  begin { GetHeight }
    Result := BarHeight + ReadableHeight;
  end;  { GetHeight }

  function TRPBarsBase.GetReadableHeight: double;

  begin { GetReadableHeight }
    If (BaseReport <> nil) and PrintReadable then begin
      BaseReport.ResetLineHeight;
      Result := BaseReport.LineHeight;
    end else begin
      Result := 0;
    end; { else }
  end;  { GetReadableHeight }

  function TRPBarsBase.GetLeft: double;

  begin { GetLeft }
    Case BarCodeRotation of
      Rot90, Rot180: begin
        Case BarCodeJustify of
          pjLeft, pjBlock: Result := Position;
          pjRight: Result := Position + Width;
          else Result := Position + (Width / 2.0); { pjCenter }
        end; { case }
      end;
      else begin { Rot0, Rot270 }
        Case BarCodeJustify of
          pjLeft, pjBlock: Result := Position;
          pjRight: Result := Position - Width;
          else Result := Position - (Width / 2.0); { pjCenter }
        end; { case }
      end; { else }
    end;
  end;  { GetLeft }

  procedure TRPBarsBase.SetLeft(Value: double);

  begin { SetLeft }
    FPosition := Value;
    BarCodeJustify := pjLeft;
  end;  { SetLeft }

  function TRPBarsBase.GetRight: double;

  begin { GetRight }
    Case BarCodeRotation of
      Rot90, Rot180: begin
        Case BarCodeJustify of
          pjLeft, pjBlock: Result := Position - Width;
          pjRight: Result := Position;
          else Result := Position - (Width / 2.0); { pjCenter }
        end;
      end; { case }
      else begin { Rot0, Rot270 }
        Case BarCodeJustify of
          pjLeft, pjBlock: Result := Position + Width;
          pjRight: Result := Position;
          else Result := Position + (Width / 2.0); { pjCenter }
        end; { case }
      end; { case }
    end; { case }
  end;  { GetRight }

  procedure TRPBarsBase.SetRight(Value: double);

  begin { SetRight }
    FPosition := Value;
    BarCodeJustify := pjRight;
  end;  { SetRight }

  function TRPBarsBase.GetCenter: double;

  begin { GetCenter }
    Case BarCodeRotation of
      Rot90, Rot180: begin
        Case BarCodeJustify of
          pjLeft, pjBlock: Result := FPosition - (Width / 2.0);
          pjRight: Result := Position + (Width / 2.0);
          else Result := Position; { pjCenter }
        end; { case }
      end else begin
        Case BarCodeJustify of
          pjLeft, pjBlock: Result := FPosition + (Width / 2.0);
          pjRight: Result := Position - (Width / 2.0);
          else Result := Position; { pjCenter }
        end; { case }
      end; { else }
    end; { case }
  end;  { GetCenter }

  procedure TRPBarsBase.SetCenter(Value: double);

  begin { SetCenter }
    FPosition := Value;
    BarCodeJustify := pjCenter;
  end;  { SetCenter }

  function TRPBarsBase.GetBottom: double;

  begin { GetBottom }
    Case BarCodeRotation of
      Rot180, Rot270: begin
        Result := Top - BarHeight - ReadableHeight;
      end else begin
        Result := Top + BarHeight + ReadableHeight;
      end; { else }
    end; { case }
  end;  { GetBottom }

  procedure TRPBarsBase.SetBottom(Value: double);

  begin { SetBottom }
    Top := Value - BarHeight - ReadableHeight;
  end;  { SetBottom }

  function TRPBarsBase.GetBarTop: double;

  begin { GetBarTop }
    If PrintTop then begin
      Case BarCodeRotation of
        Rot180, Rot270: begin
          Result := Top - ReadableHeight;
        end else begin
          Result := Top + ReadableHeight;
        end; { else }
      end; { case }
    end else begin
      Result := Top;
    end; { if }
  end;  { GetBarTop }

  procedure TRPBarsBase.SetBarTop(Value: double);

  begin { SetBarTop }
    If PrintTop then begin
      Top := Value - ReadableHeight;
    end else begin
      Top := Value;
    end; { else }
  end;  { SetBarTop }

  function TRPBarsBase.GetBarBottom: double;

  begin { GetBarBottom }
    Case BarCodeRotation of
      Rot180, Rot270: begin
        If PrintTop then begin
          Result := Top - ReadableHeight - FBarHeight;
        end else begin
          Result := Top - FBarHeight;
        end; { else }
      end else begin
        If PrintTop then begin
          Result := Top + ReadableHeight + FBarHeight;
        end else begin
          Result := Top + FBarHeight;
        end; { else }
      end; { else }
    end; { case }
  end;  { GetBarBottom }

  procedure TRPBarsBase.SetBarBottom(Value: double);

  begin { SetBarBottom }
    If PrintTop then begin
      Top := Value - FBarHeight - ReadableHeight;
    end else begin
      Top := Value - FBarHeight;
    end; { else }
  end;  { SetBarBottom }

  procedure TRPBarsBase.SetText(Value: string);

  var
    I1: integer;

  begin { SetText }
    FText := '';
    For I1 := 1 to Length(Value) do begin
      If IsValidChar(Value[I1]) then begin
        FText := FText + Value[I1];
      end; { if }
    end; { for }
  end;  { SetText }

  procedure TRPBarsBase.SetUseChecksum(Value: boolean);

  begin { SetUseChecksum }
    FUseChecksum := Value;
  end;  { SetUseChecksum }

  function TRPBarsBase.GetChecksum: string;

  begin { GetChecksum }
    Result := '';
  end;  { GetChecksum }

  function TRPBarsBase.GetBarCodeText: string;

  begin { GetBarCodeText }
    Result := Text;
  end;  { GetBarCodeText }

  procedure TRPBarsBase.PrintReadableText;

  var
    S1: string;
    I1: integer;
    OrigRotation: integer;

  begin { PrintReadableText }
    If IsOverride(false) then begin
    end else begin
      With BaseReport do begin
        OrigRotation := FontRotation;
        If PrintReadable then begin
          If PrintTop then begin
            LineBottom := BarTop;
          end else begin
            LineTop := BarBottom;
          end; { else }

          S1 := Text;
          If PrintChecksum then begin
            S1 := S1 + Checksum;
          end; { if }
          For I1 := Length(S1) downto 1 do begin
            If ord(S1[I1]) > 200 then begin { take out FNC,Code and Shift characters }
              Delete(S1,I1, 1);
            end; { if }
          end; { for }
          Case BarCodeRotation of
            Rot0: begin
              FontRotation := 0;
              Case TextJustify of
                pjLeft, pjBlock: PrintLeft(S1,Left);
                pjRight: PrintRight(S1,Right);
                pjCenter: PrintCenter(S1,Center);
              end; { case }
            end;
            Rot90: begin
              FontRotation := 90;
              If PrintTop then begin
                XPos := Top + LineHeight - DescentHeight;
              end else begin
                XPos := Top + BarHeight + LineHeight - DescentHeight;
              end; { if }
              Case TextJustify of
                pjLeft, pjBlock: YPos := Left;
                pjRight: YPos := Right + TextWidth(S1);
                pjCenter: YPos := Center + (TextWidth(S1) / 2) ;
              end; { case }
              Print(S1);
            end; { Rot90 }
            Rot180: begin
              FontRotation := 180;
              If PrintTop then begin
                YPos := BarTop + DescentHeight;
              end else begin
                YPos := Bottom + DescentHeight;
              end; { else }
              Case TextJustify of
                pjLeft, pjBlock: XPos := Left;
                pjRight: XPos := Right + TextWidth(S1);
                pjCenter: XPos := Center + (TextWidth(S1) / 2) ;
              end; { case }
              Print(S1);
            end; { Rot180 }
            Rot270: begin
              FontRotation := 270;
              If PrintTop then begin
                XPos := Top - LineHeight + DescentHeight;
              end else begin
                XPos := Top - BarHeight - LineHeight + DescentHeight;
              end; { else }
              Case TextJustify of
                pjLeft, pjBlock: YPos := Left;
                pjRight: YPos := Right - TextWidth(S1);
                pjCenter: YPos := Center - (TextWidth(S1) / 2) ;
              end; { case }
              Print(S1);
            end; { Rot270 }
          end;
        end; { If }
        FontRotation := OrigRotation;
      end; { With }
    end; { else }
  end;  { PrintReadableText }

  function TRPBarsBase.IsOverride(Refresh: boolean): boolean;

  begin { IsOverride }
    If Refresh then begin
      FIsOverride := Assigned(FOverrideBar) or Assigned(FOverrideText);
    end;
    Result := FIsOverride;
  end;  { IsOverride }

  procedure TRPBarsBase.SetupCanvas;

  begin { SetupCanvas }
    If not IsOverride(false) then begin
      SaveBrush := TBrush.Create;
      SaveBrush.Assign(BaseReport.Canvas.Brush);
      BaseReport.SetBrush(clBlack,bsSolid,nil);

      SavePen := TPen.Create;
      SavePen.Assign(BaseReport.Canvas.Pen);
      BaseReport.SetPen(clBlack,psInsideFrame,1,pmCopy)
    end; { if }
  end;  { SetupCanvas }

  procedure TRPBarsBase.RestoreCanvas;

  begin { RestoreCanvas }
    If not IsOverride(false) then begin
      If Assigned(SavePen) then begin
        BaseReport.Canvas.Pen.Assign(SavePen);
        SavePen.Free;
        SavePen := nil;
      end; { if }
      If Assigned(SaveBrush) then begin
        BaseReport.Canvas.Brush.Assign(SaveBrush);
        SaveBrush.Free;
        SaveBrush := nil;
      end; { if }
    end; { if }
  end;  { RestoreCanvas }

  procedure TRPBarsBase.CheckForValidCanvas;

  begin { CheckForValidCanvas }
    If not IsOverride(true) and (BaseReport = nil) then begin
      RaiseError(Trans('TBaseReport object not defined.  Printing Aborted.'));
    end; { if }
  end;  { CheckForValidCanvas }

  procedure TRPBarsBase.DrawRect(X1,Y1,X2,Y2: double);

  begin { DrawRect }
    If IsOverride(false) then begin
      OverrideBar(X1,Y1,X2,Y2);
    end else begin
      BaseReport.Rectangle(X1,Y1,X2 - (1.0 / BaseReport.XDPI),Y2);
    end; { else }
  end;  { DrawRect }

  procedure TRPBarsBase.PrintXY(X,Y: double);

  begin { PrintXY }
    Case BarCodeJustify of
      pjLeft, pjBlock: Left := X;
      pjRight: Right := X;
      pjCenter: Center := X;
    end; { case }
    Top := Y;
    Print;
  end;  { PrintXY }

  procedure TRPBarsBase.PrintBarPattern(BarMask: string;
                                        BarFirst: boolean;
                                        AddSpace: boolean);

  var
    I1: integer;
    CurBarWidth: double;
    CurBarHeight: double;
    CurBarTop: double;

  begin { PrintBarPattern }
    CurBarHeight := BarHeight;
    CurBarWidth := BarWidth;
    CurBarTop := CurrY;

    For I1 := 1 to Length(BarMask) do begin { print character }
      ModifyBar(BarMask[I1], CurBarWidth, CurBarHeight, CurBarTop);
      If (Odd(I1) and BarFirst) or
       ((not Odd(I1)) and (not BarFirst)) then begin
        Case BarCodeRotation of
          Rot90: DrawRect(CurBarTop, CurrX, CurBarTop + CurBarHeight, CurrX - CurBarWidth);
          Rot180: DrawRect(CurrX, CurBarTop, CurrX - CurBarWidth, CurBarTop - CurBarHeight);
          Rot270: DrawRect(CurBarTop, CurrX, CurBarTop - CurBarHeight, CurrX + CurBarWidth);
          else begin
            DrawRect(CurrX, CurBarTop, CurrX + CurBarWidth, CurBarTop + CurBarHeight);
          end; { else }
        end; { case }
      end; { if }
      Case BarCodeRotation of
        Rot0: CurrX := CurrX + CurBarWidth;
        Rot90: CurrX := CurrX - CurBarWidth;
        Rot180: CurrX := CurrX - CurBarWidth;
        Rot270: CurrX := CurrX + CurBarWidth;
      end; { case }
    end; { for }

    If AddSpace then begin
      Case BarCodeRotation of
        Rot0: CurrX := CurrX + BarWidth;
        Rot90: CurrX := CurrX - BarWidth;
        Rot180: CurrX := CurrX - BarWidth;
        Rot270: CurrX := CurrX + BarWidth;
      end; { case }
    end; { if }
  end;  { PrintBarPattern }

  procedure TRPBarsBase.SetPrintReadable(Value: boolean);

  begin { SetPrintReadable }
    FPrintReadable := Value;
  end;  { SetPrintReadable }

(*****************************************************************************}
( class TRPBars2of5
(*****************************************************************************)

  constructor TRPBars2of5.Create(BaseRpt: TBaseReport);

  begin { Create }
    inherited Create(BaseRpt);
    FWideFactor := 3.0;
    Modulas := 10;
    UseChecksum := false;
  end;  { Create }

  function TRPBars2of5.IsValidChar(Ch: char): boolean;

  begin { IsValidChar }
    result := Pos(Ch, Intrl2of5Chars) > 0;
  end;  { IsValidChar }

  function TRPBars2of5.GetWidth: double;

  var
    I1: integer;

  begin { GetWidth }
    I1 := Length(FText);
    If UseChecksum then begin
      Inc(I1);
    end; { if }
    I1 := ((I1 + 1) div 2) * 2; { Number of characters in barcode }
    Result := (I1 * ((2 * WideFactor) + 3) + 6 + WideFactor) * BarWidth;
  end;  { GetWidth }

  function TRPBars2of5.GetBarCodeText: string;

  var
    S1: string;

  begin { GetBarCodeText }
    S1 := Text;
    If UseChecksum then begin { calculate checksum and add it to the bar string }
      S1 := S1 + Checksum;
    end; { if }
    If Odd(Length(S1)) then begin
      S1 := '0' + S1;
    end; { if }
    Result := S1;
  end;  { GetBarCodeText }

  procedure TRPBars2of5.ModifyBar(    BarCh: char;
                                  var Width: double;
                                  var Height: double;
                                  var Top: double);
  begin { ModifyBar }
    Case BarCh of
      '1': Width := BarWidth;
      '2': Width := BarWidth * FWideFactor;
    end; { case }
  end;  { ModifyBar }

  function TRPBars2of5.GetBarMask(Ch: char): string;

  begin { GetBarMask }
    If IsValidChar(Ch) then begin
      Result := IntToStr(Intrl2of5Bars[Pos(Ch, Intrl2of5Chars)]);
    end else begin
      Result := '';
    end; { else }
  end;  { GetBarMask }

  function TRPBars2of5.GetChecksum: string;

  var
    I1: integer;
    EvenSum: integer;
    OddSum: integer;
    EvenOddSum: integer;

  begin { GetChecksum }
    EvenSum := 0;
    I1 := Length(Text);
    While I1 >= 1 do begin { get even sums }
      EvenSum := EvenSum + StrToInt(Text[I1]);
      Dec(I1,2);
    end;
    OddSum := 0;
    I1 := Length(Text) - 1;
    While I1 >=1 do begin { get odd sums }
      OddSum := OddSum + StrToInt(Text[I1]);
      Dec(I1,2);
    end; { while }
    EvenOddSum := (EvenSum * 3) + OddSum;
    Result := IntToStr(10 - (EvenOddSum mod Modulas));
  end;  { GetChecksum }

  procedure TRPBars2of5.Print;

  var
    I1: integer;
    I2: integer;
    S1: string;
    BarMask: string[5];
    SpaceMask: string[5];
    PrintMask: string[10];

  begin { Print }
    CheckForValidCanvas;
    try
      SetupCanvas;
      S1 := GetBarCodeText;
      CurrX := Left;
      CurrY := BarTop;
      PrintBarPattern(IntToStr(Intrl2of5StartChar),BarFirstYes,AddSpaceNo);
      I1 := 1;
      While I1 < Length(S1) do begin { loop through Text characters }
        BarMask := GetBarmask(S1[I1]);
        SpaceMask := GetBarmask(S1[I1 + 1]);
        PrintMask := '';
        For I2 := 1 to Length(BarMask) do begin
          PrintMask := PrintMask + BarMask[I2] + SpaceMask[I2];
        end; { for }
        PrintBarPattern(PrintMask,BarFirstYes,AddSpaceNo);
        Inc(I1,2);
      end; { while }
      PrintBarPattern(IntToStr(Intrl2of5StopChar),BarFirstYes,AddSpaceNo);
      PrintReadableText;
    finally
      RestoreCanvas;
    end; { tryf }
  end;  { Print }

(*****************************************************************************}
( class TRPBarsCode39
(*****************************************************************************)

  constructor TRPBarsCode39.Create(BaseRpt: TBaseReport);

  begin { Create }
    inherited Create(BaseRpt);
    FWideFactor := 3.0;
    Modulas := 43;
    UseChecksum := false;
  end;  { Create }

  function TRPBarsCode39.IsValidChar(Ch: char): boolean;

  begin
    If Extended then begin
      Result := Pos(Ch, Code39CharsExt) > 0;
    end else begin
      Result := Pos(Ch, Code39Chars) > 0;
    end; { else }
  end;

  function TRPBarsCode39.GetWidth: double;

  var
    I1: integer;
    S1: string;

  begin { GetWidth }
    If Extended then begin
      S1 := ExtendedText;
    end else begin
      S1 := Text;
    end; { else }
    I1 := Length(S1);
    If UseChecksum then begin
      Inc(I1,Length(Checksum));
    end; { if }
    Result := (I1 + 2) * ((3 * WideFactor) + 6) * BarWidth + (I1 + 1) * BarWidth;
  end;  { GetWidth }

  function TRPBarsCode39.GetBarCodeText: string;

  var
    S1: string;

  begin { GetBarCodeText }
    If Extended then begin
      S1 := ExtendedText;
    end else begin
      S1 := Text;
    end; { else }
    If UseChecksum then begin
      S1 := S1 + Checksum;
    end; { if }
    Result := S1;
  end;  { GetBarCodeText }

  procedure TRPBarsCode39.ModifyBar(     BarCh: char;
                                    var Width: double;
                                    var Height: double;
                                    var Top: double);

  begin { ModifyBar }
    Case BarCh of
      '1': Width := BarWidth;
      '2': Width := BarWidth * FWideFactor;
    end; { case }
  end;  { ModifyBar }

  function TRPBarsCode39.GetBarMask(Ch: char): string;

  begin { GetBarMask }
    Result := '';
    If IsValidChar(Ch) then begin
      Result := IntToStr(Code39Bars[Pos(Ch, Code39Chars)]);
    end; { if }
  end;  { GetBarMask }

  function TRPBarsCode39.GetChecksum: string;

  var
    I1: integer;
    Calc: integer;

  begin { GetChecksum }
    Calc := 0;
    For I1 := 1 to Length(Text) do begin
      Calc := Calc + (Pos(Text[I1], Code39Chars) - 1);
    end; { For }
    Calc := Calc mod Modulas;
    If Extended then begin
      Result := Code39CharsExt2[Calc + 1];
    end else begin
      Result := Code39Chars[Calc + 1];
    end; { if }
  end;  { GetChecksum }

  procedure TRPBarsCode39.Print;

  var
    I1: integer;
    S1: string;

  begin { Print }
    CheckForValidCanvas;
    try
      SetupCanvas;
      S1 := GetBarCodeText;
      CurrX := Left;
      CurrY := BarTop;
      PrintBarPattern(IntToStr(Code39StartStopChar),BarFirstYes,AddSpaceYes);
      For I1 := 1 to Length(S1) do begin { loop through characters }
        PrintBarPattern(GetBarMask(S1[I1]),BarFirstYes,AddSpaceYes);
      end; { for }
      PrintBarPattern(IntToStr(Code39StartStopChar),BarFirstYes,AddSpaceYes);
      PrintReadableText;
    finally
      RestoreCanvas;
    end; { tryf }
  end;  { Print }

  function TRPBarsCode39.GetExtendedText: string;

  var
    I1: integer;

  begin { GetExtendedText }
    Result := '';
    For I1 := 1 to Length(Text) do begin
      Result := Result + Code39CharsExt2[Pos(Text[I1],Code39CharsExt)];
    end;
  end;  { GetExtendedText }

(*****************************************************************************}
( class TRPBarsPostNet
(*****************************************************************************)

  constructor TRPBarsPostNet.Create(BaseRpt: TBaseReport);

  begin { Create }
    inherited Create(BaseRpt);
    BarHeight := 0.125;
    BarWidth := 0.020;
    Modulas := 10;
    UseChecksum := true;
  end;  { Create }

  function TRPBarsPostNet.IsValidChar(Ch: char): boolean;

  begin
    Result := Pos(Ch, PostNetChars) > 0;
  end;

  function TRPBarsPostNet.GetWidth: double;

  begin { GetWidth }
    Result := ((Length(Text) * 10) * BarWidth) + (BarWidth*3);
    If UseChecksum then begin
      Result := Result + (BarWidth * 10);
    end; { if }
  end;  { GetWidth }

  function TRPBarsPostNet.GetBarCodeText: string;

  begin { GetBarCodeText }
    Result := Text;
    If UseChecksum then begin
      Result := Result + Checksum;
    end; { if }
  end;  { GetBarCodeText }

  procedure TRPBarsPostNet.ModifyBar(     BarCh: char;
                                      var Width: double;
                                      var Height: double;
                                      var Top: double);
  begin { ModifyBar }
    Case BarCh of
      '0': begin
        Width := 0.0254;
      end;
      '1': begin
        Width := BarWidth;
        Height := BarHeight * 0.4;
        Case BarCodeRotation of
          Rot180, Rot270: Top := CurrY - Height;
          else Top := CurrY + BarHeight - Height;
        end; { case }
      end;
      '2': begin
        Width := BarWidth;
        Height := BarHeight;
        Top := CurrY;
      end;
      '3': begin { Fim A }
        Width  := 0.03125;
        Height := 0.625;
      end;
      '4': begin { Fim B }
        Width  := 0.09375;
        Height := 0.625;
      end;
      '5': begin { Fim C }
        Width  := 0.15625;
        Height := 0.625;
      end;
    end; { case }
  end;  { ModifyBar }

  function TRPBarsPostNet.GetBarMask(ch: char): string;

  begin { GetBarMask }
    Result := '';
    If IsValidChar(ch) then begin
      Result := IntToStr(PostNetBars[Pos(ch, PostNetChars)]);
    end; { if }
  end;  { GetBarMask }

  function TRPBarsPostNet.GetChecksum: string;

  var
    I1: integer;
    Calc: integer;

  begin { GetChecksum }
    Calc := 0;
    For I1 := 1 to Length(Text) do begin
      Calc := Calc + StrToInt(Text[I1]);
    end; { for }
    Calc := (10 - (Calc mod Modulas)) mod Modulas;
    Result := IntToStr(Calc);
  end;  { GetChecksum }

  procedure TRPBarsPostNet.Print;

  var
    I1: integer;
    S1: string;

  begin { Print }
    CheckForValidCanvas;
    try
      SetupCanvas;
      S1 := GetBarCodeText;
      CurrX := Left;
      CurrY := BarTop;
      PrintBarPattern(PostNetStart,BarFirstYes,AddSpaceNo);
      For I1 := 1 to Length(S1) do begin { loop through characters }
        PrintBarPattern(GetBarMask(S1[I1]),BarFirstYes,AddSpaceNo);
      end; { for }
      PrintBarPattern(PostNetStop,BarFirstYes,AddSpaceNo);
      PrintReadableText;
    finally
      RestoreCanvas;
    end; { tryf }
  end;  { Print }

  procedure TRPBarsPostNet.PrintFimA(X,Y: double);

  const
    FimAMask = {Trans-}'333535333';

  begin { PrintFimA }
    CheckForValidCanvas;
    try
      SetupCanvas;
      CurrX := X;
      CurrY := Y;
      PrintBarPattern(FimAMask,BarFirstYes,AddSpaceNo);
    finally
      RestoreCanvas;
    end; { tryf }
  end;  { PrintFimA }

  procedure TRPBarsPostNet.PrintFimB(X,Y: double);

  const
    FimBMask = {Trans-}'34333433343';

  begin { PrintFimB }
    CheckForValidCanvas;
    try
      SetupCanvas;
      CurrX := X;
      CurrY := Y;
      PrintBarPattern(FimBMask,BarFirstYes,AddSpaceNo);
    finally
      RestoreCanvas;
    end; { tryf }
  end;  { PrintFimB }

  procedure TRPBarsPostNet.PrintFimC(X,Y: double);

  const
    FimCMask = {Trans-}'33343434333';

  begin { PrintFimC }
    CheckForValidCanvas;
    try
      SetupCanvas;
      CurrX := X;
      CurrY := Y;
      PrintBarPattern(FimCMask,BarFirstYes,AddSpaceNo);
    finally
      RestoreCanvas;
    end; { tryf }
  end;  { PrintFimC }

  procedure TRPBarsPostNet.SetText(Value: string);

  begin { SetText }
    inherited SetText(Value);
    If Length(FText) > 11 { valid chars without checksum } then begin
      FText := Copy(FText, 1, 11);
    end else if Length(FText) < 5 then begin
      FText := StringOfChar('0', 5 - Length(FText)) + FText;
    end; { if }
  end;  { SetText }

(*****************************************************************************}
( class TRPBarsCode128
(*****************************************************************************)

  constructor TRPBarsCode128.Create(BaseRpt: TBaseReport);
  begin { Create }
    inherited Create(BaseRpt);
    Modulas := 103;
    UseChecksum := true;
    Optimize := true;
  end;  { Create }

  function TRPBarsCode128.IsValidChar(Ch: char): boolean;

  begin { IsValidChar }
    Result := (Pos(Ch, Code128CharsA) > 0) or (Pos(Ch, Code128CharsB) > 0) or
     (Ch in ['0'..'9',#241,#245,#246]);
  end;  { IsValidChar }

  function TRPBarsCode128.GetWidth: double;

  begin { GetWidth }
    Result := ((11 * Length(GetOutputStr)) + 35) * BarWidth;
  end;  { GetWidth }

  function TRPBarsCode128.GetBarCodeText: string;

  begin { GetBarCodeText }
    Result := Text;
  end;  { GetBarCodeText }

  function TRPBarsCode128.CalcOutputStr(MaxLen: byte): string;

  var
    I1: integer;
    I2: integer;
    S1: string;
    CurrCodePage: TCodePage128;

    function CheckDigitsAhead(Count: byte): boolean;

    var
      Cnt: byte;

    begin { CheckDigitsAhead }
      Result := false;
      If (I1 + Count) > Length(S1) then Exit;
      For Cnt := 1 to Count do begin
        If not (S1[I1 + Cnt] in ['0'..'9']) then Exit;
      end; { for }
      Result := true;
    end;  { CheckDigitsAhead }

    function CountDigits: integer;

    var
      Cnt: byte;

    begin { CountDigits }
    { Calculate how many sequential digit chars are from current position }
      Result := 0;
      For Cnt := I1 to Length(S1) do begin
        If not (S1[Cnt] in ['0'..'9']) then Exit;
        Inc(Result);
      end; { for }
    end;  { CountDigits }

  begin { CalcOutputStr }
    CurrCodePage := UseCodePage;
    S1 := Text;
    I1 := 0;
    Result := '';
    While I1 < Length(S1) do begin
      If (MaxLen > 0) and (Length(Result) >= MaxLen) then Exit;
      Inc(I1);
      If Optimize and (S1[I1] in [#245..#248]) then Continue; { Skip forced code changes }

    { Check for switch to CodeC if many digits ahead }
      If Optimize and (CurrCodePage <> cpCodeC) then begin
        I2 := CountDigits;
        If (I2 >= 6) and not Odd(I2) then begin { Switch to CodeC }
          Result := Result + #99;
          CurrCodePage := cpCodeC;
        end; { if }
      end; { if }

      Case CurrCodePage of
        cpCodeA: begin
          If S1[I1] = #245 then Continue; { Ignore CodeA switch }
          I2 := Pos(S1[I1],Code128CharsA);
          If I2 > 0 then begin
            Result := Result + Chr(I2 - 1);
            Case (I2 - 1) of
              98: CurrCodePage := cpCodeB;
              99: CurrCodePage := cpCodeC;
              100: CurrCodePage := cpCodeB;
            end; { case }
          end else begin
            I2 := Pos(S1[I1],Code128CharsB);
            If I2 > 0 then begin { Switch to CodeB }
              Result := Result + #100 + Chr(I2 - 1);
              CurrCodePage := cpCodeB;
            end; { if }
          end; { else }
        end;
        cpCodeB: begin
          If S1[I1] = #246 then Continue; { Ignore CodeB switch }
          I2 := Pos(S1[I1],Code128CharsB);
          If I2 > 0 then begin
            Result := Result + Chr(I2 - 1);
            Case (I2 - 1) of
              98: CurrCodePage := cpCodeA;
              99: CurrCodePage := cpCodeC;
              101: CurrCodePage := cpCodeB;
            end; { case }
          end else begin
            I2 := Pos(S1[I1],Code128CharsA);
            If I2 > 0 then begin { Switch to CodeA }
              Result := Result + #101 + Chr(I2 - 1);
              CurrCodePage := cpCodeA;
            end; { if }
          end; { if }
        end;
        else begin { cpCodeC }
          If S1[I1] = #247 then Continue; { Ignore CodeC switch }
          If (S1[I1] in ['0'..'9']) and CheckDigitsAhead(1) then begin
            Result := Result + Chr((Ord(S1[I1]) - Ord('0')) * 10 + (Ord(S1[I1 + 1]) - Ord('0')));
            Inc(I1);
          end else if S1[I1] in [#241,#245,#246] then begin
            Case S1[I1] of
              #241: Result := Result + #102;
              #245: begin
                Result := Result + #101;
                CurrCodePage := cpCodeA;
              end;
              #246: begin
                Result := Result + #100;
                CurrCodePage := cpCodeB;
              end;
            end; { case }
          end else begin { Convert to CodeA or CodeB to encode character }
            I2 := Pos(S1[I1],Code128CharsB);
            If I2 > 0 then begin
              Result := Result + #100 + Chr(I2 - 1);
              If CheckDigitsAhead(4) then begin
                Result := Result + #99;
              end else begin
                CurrCodePage := cpCodeB;
              end; { else }
            end else begin
              I2 := Pos(S1[I1],Code128CharsA);
              If I2 > 0 then begin { Switch to CodeA }
                Result := Result + #101 + Chr(I2 - 1);
                If CheckDigitsAhead(4) then begin
                  Result := Result + #99;
                end else begin
                  CurrCodePage := cpCodeA;
                end; { else }
              end; { if }
            end; { else }
          end; { else }
        end; { else }
      end; { case }
    end; { while }
  end;  { CalcOutputStr }

  function TRPBarsCode128.GetOutputStr: string;

  var
    S1: string;

  begin { GetOutputStr }
    If Optimize then begin
      UseCodePage := cpCodeA;
      Result := CalcOutputStr(0);;
      CodePageUsed := cpCodeA;

      UseCodePage := cpCodeB;
      S1 := CalcOutputStr(Length(Result));
      If Length(S1) < Length(Result) then begin
        CodePageUsed := cpCodeB;
        Result := S1;
      end; { if }

      UseCodePage := cpCodeC;
      S1 := CalcOutputStr(Length(Result));
      If Length(S1) < Length(Result) then begin
        CodePageUsed := cpCodeC;
        Result := S1;
      end; { if }
    end else begin
      CodePageUsed := CodePage;
      Result := CalcOutputStr(0);
    end; { else }
  end;  { GetOutputStr }

  procedure TRPBarsCode128.ModifyBar(    BarCh: char;
                                    var Width: double;
                                    var Height: double;
                                    var Top: double);
  begin { ModifyBar }
    Width := StrToInt(BarCh) * BarWidth;
  end;  { ModifyBar }

  function TRPBarsCode128.GetBarMask(Ch: char): string;

  begin { GetBarMask }
    Result := IntToStr(Code128Bars[Ord(Ch) + 1]);
  end;  { GetBarMask }

  function TRPBarsCode128.CalcChecksum(OutputStr: string): char;

  var
    I1: integer;
    Calc: integer;

  begin { CalcChecksum }
    Case CodePageUsed of { assign check value For start code }
      cpCodeA: Calc := 103;
      cpCodeB: Calc := 104;
      else Calc := 105; { CodeC }
    end; { case }
    For I1 := 1 to Length(OutputStr) do begin
      Calc := Calc + (I1 * Ord(OutputStr[I1]));
    end; { for }
    Calc := Calc mod Modulas;
    Result := Chr(Calc);
  end;  { CalcChecksum }

  function TRPBarsCode128.GetChecksum: string;

  begin { GetChecksum }
    Result := CalcChecksum(GetOutputStr);
  end;  { GetChecksum }

  procedure TRPBarsCode128.Print;

  var
    I1: integer;
    S1: string;

  begin { Print }
    CheckForValidCanvas;
    try
      SetupCanvas;
      CurrX := Left;
      CurrY := BarTop;
      S1 := GetOutputStr;
      Case CodePageUsed of
        cpCodeA: PrintBarPattern(IntToStr(Code128StartCharA),BarFirstYes,AddSpaceNo);
        cpCodeB: PrintBarPattern(IntToStr(Code128StartCharB),BarFirstYes,AddSpaceNo);
        cpCodeC: PrintBarPattern(IntToStr(Code128StartCharC),BarFirstYes,AddSpaceNo);
      end; { case }
      For I1 := 1 to Length(S1) do begin
        PrintBarPattern(GetBarMask(S1[I1]),BarFirstYes,AddSpaceNo);
      end; { for }
      PrintBarPattern(GetBarMask(CalcChecksum(S1)),BarFirstYes,AddSpaceNo);
      PrintBarPattern(IntToStr(Code128StopChar),BarFirstYes,AddSpaceNo);
      PrintReadableText;
    finally
      RestoreCanvas;
    end; { tryf }
  end;  { Print }

(*****************************************************************************}
( class TRPBarsUPC
(*****************************************************************************)

  constructor TRPBarsUPC.Create(BaseRpt: TBaseReport);

  begin { Create }
    inherited Create(BaseRpt);
    Modulas := 10;
    UseChecksum := true;
    ValidLen := 11;
  end;  { Create }

  function TRPBarsUPC.IsValidChar(Ch: char): boolean;

  begin
    Result := Pos(Ch,UPCChars) > 0;
  end;

  function TRPBarsUPC.GetWidth: double;

  begin { GetWidth }
    Result := (BarWidth * 11) + (BarWidth * 7 * 12);
  end;  { GetWidth }

  function TRPBarsUPC.GetBarCodeText: string;

  begin { GetBarCodeText }
    Result := Text;
    If UseChecksum then begin
      Result := Result + Checksum;
    end; { if }
  end;  { GetBarCodeText }

  procedure TRPBarsUPC.ModifyBar(    BarCh: char;
                                var Width: double;
                                var Height: double;
                                var Top: double);

  begin { ModifyBar }
    Width := StrToInt(BarCh) * BarWidth;
    If FPrintingGuard or (not PrintReadable) then begin
      Height := BarHeight;
    end else begin
      Height := BarHeight - (ReadableHeight / 2);
    end; { else }
  end;  { ModifyBar }

  function TRPBarsUPC.GetBarMask(Ch: char): string;

  begin { GetBarMask }
    Result := '';
    If IsValidChar(ch) then begin
      Result := IntToStr(UPCBars[Pos(Ch,UPCChars)]);
    end; { if }
  end;  { GetBarMask }

  function TRPBarsUPC.GetFontSize: double;

  var
    SaveFontSize: double;

  begin { GetFontSize }
    With BaseReport do begin
      SaveFontSize := FontSize;
      Result := SaveFontSize;
      While TextWidth({Trans-}'0000000000') > (Width - (BarWidth * 11)) do begin
        Result := Result - 0.1;
        FontSize := Result;
        If Result <= 0 then begin
          Result := SaveFontSize;
          Break;
        end; { if }
      end; { while }
      Result := Result * 0.9;
      FontSize := SaveFontSize;
    end; { with }
  end;  { GetFontSize }

  function TRPBarsUPC.GetChecksum: string;

  var
    I1: integer;
    Calc: integer;
    SumOdd, SumEven: integer;
    FirstFlag: byte;
    S1: string;

  begin { GetChecksum }
    SumOdd := 0;
    SumEven := 0;
    S1 := Text;
    If ValidLen = 12 then begin
      FirstFlag := StrToIntDef(S1[1],0);
      Delete(S1,1,1);
    end else begin
      FirstFlag := 0;
    end; { else }
    For I1 := 1 to Length(S1) do begin
      If Odd(I1) then begin
        SumOdd := SumOdd + StrToInt(S1[I1]);
      end else begin
        SumEven := SumEven + StrToInt(S1[I1]);
      end; { else }
    end; { for }
    SumOdd := SumOdd * 3;
    Calc := SumOdd + SumEven + FirstFlag;
    Calc := (Modulas - (Calc mod Modulas)) mod Modulas;
    Result := IntToStr(Calc);
  end;  { GetChecksum }

  procedure TRPBarsUPC.PrintReadableText;

  var
    S1, S2: string;
    OrigRotation: integer;
    FontAdjust: double;

  begin { PrintReadableText }
    If IsOverride(false) then begin
    end else begin
      With BaseReport do begin
        OrigRotation := FontRotation;
        FontAdjust := FontSize / 3;

        S1 := Text;
        If ValidLen = 12 then begin
          Delete(S1,1,1);
        end; { if }
        Case BarCodeRotation of
          Rot0: begin
            LineTop := BarBottom - (LineHeight / 2);
            FontRotation := 0;
            FontSize := FontSize - FontAdjust;
            S2 := Copy(S1,1,1);
            PrintRight(S2, Left - (BarWidth * 2)); { Print System Char }
            FontSize := FontSize + FontAdjust;
            S2 := Copy(S1,2,(Length(S1)-1) div 2);
            PrintCenter(S2,Left + (BarWidth * 24));  { Print Manufacturor Code }
            S2 := Copy(S1,2+((Length(S1)-1) div 2), (Length(S1)-1) div 2);
            PrintCenter(S2, Left + (BarWidth * 71)); { Print Product Code }
            S2 := Checksum;
            FontSize := FontSize - FontAdjust;
            PrintLeft(S2, Right + (BarWidth * 2)); { Print Check Digit }
            FontSize := FontSize + FontAdjust;
          end;
          Rot90: begin
            FontRotation := 90;
            FontSize := FontSize - FontAdjust;
            S2 := Copy(S1,1,1);
            XPos := Bottom - (LineHeight / 2);
            YPos := Left + (BarWidth * 2) + TextWidth('0');
            Print(S2); { Print System Char }
            FontSize := FontSize + FontAdjust;
            S2 := Copy(S1,2,(Length(S1)-1) div 2);
            YPos := Left - (BarWidth * 3) - (BarWidth * 3) - (((BarWidth * 42) - TextWidth({Trans-}'00000')) / 2);
            Print(S2);  { Print Manufacturor Code }
            S2 := Copy(S1,2+((Length(S1)-1) div 2), (Length(S1)-1) div 2);
            YPos := Left - (BarWidth * 50) - (((BarWidth * 42) - TextWidth({Trans-}'00000')) / 2);
            Print(S2); { Print Product Code }
            S2 := Checksum;
            FontSize := FontSize - FontAdjust;
            YPos := Right - (BarWidth * 2);
            Print(S2); { Print Check Digit }
            FontSize := FontSize + FontAdjust;
          end; { Rot90 }
          Rot180: begin
            FontRotation := 180;
            FontSize := FontSize - FontAdjust;
            S2 := Copy(S1,1,1);
            XPos := Left + TextWidth('0');
            YPos := Bottom + (LineHeight / 2);
            Print(S2); { Print System Char }
            FontSize := FontSize + FontAdjust;
            S2 := Copy(S1,2,(Length(S1)-1) div 2);
            XPos := Left - (BarWidth * 3) - (((BarWidth * 42) - TextWidth({Trans-}'00000')) / 2);
            Print(S2);  { Print Manufacturor Code }
            S2 := Copy(S1,2+((Length(S1)-1) div 2), (Length(S1)-1) div 2);
            XPos := Left - (BarWidth * 50) - (((BarWidth * 42) - TextWidth({Trans-}'00000')) / 2);
            Print(S2); { Print Product Code }
            S2 := Checksum;
            FontSize := FontSize - FontAdjust;
            XPos := Right - (BarWidth * 2);
            Print(S2); { Print Check Digit }
            FontSize := FontSize + FontAdjust;
          end; { Rot180 }
          Rot270: begin
            FontRotation := 270;
            FontSize := FontSize - FontAdjust;
            S2 := Copy(S1,1,1);
            XPos := Bottom + (LineHeight / 2);
            YPos := Left - (BarWidth * 2) - TextWidth('0');
            Print(S2); { Print System Char }
            FontSize := FontSize + FontAdjust;
            S2 := Copy(S1,2,(Length(S1)-1) div 2);
            YPos := Left + (BarWidth * 4) + (((BarWidth * 42) - TextWidth({Trans-}'00000')) / 2);
            Print(S2);  { Print Manufacturor Code }
            S2 := Copy(S1,2+((Length(S1)-1) div 2), (Length(S1)-1) div 2);
            YPos := Left + (BarWidth * 50) + (((BarWidth * 42) - TextWidth({Trans-}'00000')) / 2);
            Print(S2); { Print Product Code }
            S2 := Checksum;
            FontSize := FontSize - FontAdjust;
            YPos := Right + (BarWidth * 2);
            Print(S2); { Print Check Digit }
            FontSize := FontSize + FontAdjust;
          end; { Rot270 }
        end;
        FontRotation := OrigRotation;
      end; { With }
    end; { else }
  end;  { PrintReadableText }

  procedure TRPBarsUPC.Print;

  var
    I1: integer;
    S1: string;
    OrigFontSize: double;
    FirstFlag: byte;
    Mask: string;

    function Flip(Value: string;
                  DoIt: boolean): string;

    var
      I1: integer;

    begin { Flip }
      If DoIt then begin
        Result := '';
        For I1 := Length(Value) downto 1 do begin
          Result := Result + Value[I1];
        end; { for }
      end else begin
        Result := Value;
      end; { else }
    end;  { Flip }

  begin { Print }
    CheckForValidCanvas;
    try
      SetupCanvas;
      S1 := GetBarCodeText;
      If ValidLen = 12 then begin
        FirstFlag := StrToIntDef(S1[1],0);
        Delete(S1,1,1);
      end else begin
        FirstFlag := 0;
      end; { else }
      OrigFontSize := 0;
      If not IsOverride(false) then begin
        OrigFontSize := BaseReport.FontSize;
        BaseReport.FontSize := GetFontSize;
      end; { if }
      CurrX := Left;
      CurrY := BarTop;
      FPrintingGuard := true;
      PrintBarPattern(IntToStr(UPCRightLeftGuard),BarFirstYes,AddSpaceNo);
      For I1 := 1 to Length(S1) do begin { loop through characters }
        Case I1 of
          1..6: begin
            FPrintingGuard := false;
            Mask := GetBarMask(S1[I1]);
            Case I1 of
              2: Mask := Flip(Mask,FirstFlag in [4,5,6,7,8,9]);
              3: Mask := Flip(Mask,FirstFlag in [1,2,3,5,6,9]);
              4: Mask := Flip(Mask,FirstFlag in [2,3,6,7,8]);
              5: Mask := Flip(Mask,FirstFlag in [1,3,4,8,9]);
              6: Mask := Flip(Mask,FirstFlag in [1,2,4,5,7]);
            end; { case }
            PrintBarPattern(Mask,BarFirstNo,AddSpaceNo);
            If I1 = 6 then begin
              FPrintingGuard := true;
              PrintBarPattern(IntToStr(UPCCenterGuard),BarFirstNo,AddSpaceNo);
            end; { if }
          end;
          else begin
            FPrintingGuard := false;
            PrintBarPattern(GetBarMask(S1[I1]),BarFirstYes,AddSpaceNo);
          end;
        end; { case }
      end; { for }
      FPrintingGuard := true;
      PrintBarPattern(IntToStr(UPCRightLeftGuard),BarFirstYes,AddSpaceNo);
      If PrintReadable then begin
        PrintReadableText;
      end; { if }
      If not IsOverride(false) then begin
        BaseReport.FontSize := OrigFontSize;
      end; { if }
    finally
      RestoreCanvas;
    end; { tryf }
  end;  { Print }

  function TRPBarsUPC.GetBottom: double;

  begin { GetBottom }
    Case BarCodeRotation of
      Rot180, Rot270: begin
        Result := Top - BarHeight - (ReadableHeight / 2);
      end else begin
        Result := Top + BarHeight + (ReadableHeight / 2);
      end; { else }
    end; { case }
  end;  { GetBottom }

  function TRPBarsUPC.GetReadableHeight: double;

  begin { GetReadableHeight }
    If BaseReport <> nil then begin
      Result := BaseReport.LineHeight / 2;
    end else begin
      Result := 0;
    end; { else }
  end;  { GetReadableHeight }

  procedure TRPBarsUPC.SetBottom(Value: double);

  begin { SetBottom }
    Top := Value - BarHeight - (ReadableHeight / 2);
  end;  { SetBottom }

  procedure TRPBarsUPC.SetUseChecksum(Value: boolean);

  begin { SetUseChecksum }
    FUseChecksum := true;
  end;  { SetUseChecksum }

  procedure TRPBarsUPC.SetText(Value: string);

  begin { SetText }
    inherited SetText(Value);
    If Length(FText) > ValidLen { valid chars without checksum } then begin
      FText := Copy(FText,1,ValidLen);
    end else if Length(FText) < ValidLen then begin
      FText := StringOfChar('0',ValidLen - Length(FText)) + FText;
    end; { if }
  end;  { SetText }

(*****************************************************************************}
( class TRPBarsEAN
(*****************************************************************************)

  constructor TRPBarsEAN.Create(BaseRpt: TBaseReport);

  begin { Create }
    inherited Create(BaseRpt);
    ValidLen := 12;
  end;  { Create }

  function TRPBarsEAN.GetFontSize: double;

  var
    SaveFontSize: double;

  begin { GetFontSize }
    With BaseReport do begin
      SaveFontSize := FontSize;
      Result := SaveFontSize;
      While TextWidth({Trans-}'000000000000') > (Width - (BarWidth * 11)) do begin
        Result := Result - 0.1;
        FontSize := Result;
        If Result <= 0 then begin
          Result := SaveFontSize;
          Break;
        end; { if }
      end; { while }
      Result := Result * 0.9;
      FontSize := SaveFontSize;
    end; { with }
  end;  { GetFontSize }

  procedure TRPBarsEAN.PrintReadableText;

  var
    S1, S2: string;
    OrigRotation: integer;

  begin { PrintReadableText }
    If IsOverride(false) then begin
    end else begin
      With BaseReport do begin
        OrigRotation := FontRotation;

        S1 := Text + Checksum;
        Case BarCodeRotation of
          Rot0: begin
            LineTop := BarBottom - (LineHeight / 2);
            FontRotation := 0;
            S2 := Copy(S1,1,1);
            { Print 1st digit of Country Code }
            PrintRight(S2, Left - (BarWidth * 2));
            S2 := Copy(S1,2,Length(S1) div 2);
            { Print remaining Country Code + Company Code }
            PrintCenter(S2,Left + (BarWidth * 24));
            S2 := Copy(S1,2+(Length(S1) div 2), Length(S1) div 2);
            { Print Product Code + Checksum}
            PrintCenter(S2, Left + (BarWidth * 71));
          end;
          Rot90: begin
            FontRotation := 90;
            S2 := Copy(S1,1,1);
            XPos := Bottom - (LineHeight / 3) * 2;
            YPos := Left + (BarWidth * 2) + TextWidth('0');
            Print(S2); { Print 1st digit of Country Code }
            S2 := Copy(S1,2,Length(S1) div 2);
            YPos := Left - (BarWidth * 3) - (BarWidth * 3) - (((BarWidth * 42) - TextWidth({Trans-}'000000')) / 2);
            Print(S2);  { Print remaining Country Code + Company Code }
            S2 := Copy(S1,2+(Length(S1) div 2), Length(S1) div 2);
            YPos := Left - (BarWidth * 50) - (((BarWidth * 42) - TextWidth({Trans-}'000000')) / 2);
            Print(S2); { Print Product Code + Checksum}
          end; { Rot90 }
          Rot180: begin
            FontRotation := 180;
            S2 := Copy(S1,1,1);
            XPos := Left + TextWidth('0');
            YPos := Bottom + (LineHeight / 3) * 2;
            Print(S2); { Print 1st digit of Country Code }
            S2 := Copy(S1,2,Length(S1) div 2);
            XPos := Left - (BarWidth * 3) - (((BarWidth * 42) - TextWidth({Trans-}'000000')) / 2);
            Print(S2);  { Print remaining Country Code + Company Code }
            S2 := Copy(S1,2+(Length(S1) div 2), Length(S1) div 2);
            XPos := Left - (BarWidth * 50) - (((BarWidth * 42) - TextWidth({Trans-}'000000')) / 2);
            Print(S2); { Print Product Code + Checksum}
          end; { Rot180 }
          Rot270: begin
            FontRotation := 270;
            S2 := Copy(S1,1,1);
            XPos := Bottom + (LineHeight / 3) * 2;
            YPos := Left - (BarWidth * 2) - TextWidth('0');
            Print(S2); { Print 1st digit of Country Code }
            S2 := Copy(S1,2,Length(S1) div 2);
            YPos := Left + (BarWidth * 4) + (((BarWidth * 42) - TextWidth({Trans-}'000000')) / 2);
            Print(S2);  { Print remaining Country Code + Company Code }
            S2 := Copy(S1,2+(Length(S1) div 2), Length(S1) div 2);
            YPos := Left + (BarWidth * 50) + (((BarWidth * 42) - TextWidth({Trans-}'000000')) / 2);
            Print(S2); { Print Product Code + Checksum}
          end; { Rot270 }
        end;
        FontRotation := OrigRotation;
      end; { With }
    end; { else }
  end;  { PrintReadableText }

end.
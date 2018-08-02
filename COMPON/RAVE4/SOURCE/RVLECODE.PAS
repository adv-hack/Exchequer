{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVLECode;

interface

{$DEFINE DOMAP}
{TransOff}

uses
  WinTypes, WinProcs, Classes, SysUtils, RVLEDef, RVLEUtil, RVLEType,
  RVLEID, RVLEMod, RVUtil;

type
  TCodeManager = class
  protected
    FSizeInc: longint;
    FModule: TRCPUModule;
    FMaxSize: longint;
    FCodeSize: longint;
    FCodeSeg: pointer;

    procedure SetCodeSeg(Value: pointer);
    procedure SetMaxSize(Value: longint);
  public
    constructor Create(InitSize: longint;
                       AModule: TRCPUModule);
    destructor Destroy; override;
    procedure FinishBuf;

  { Output methods }
    procedure Write(var Data;
                        DataLen: longint;
                        DataPos: longint);
    procedure WriteByte(    Data: byte;
                        var DataPos: longint);
    function WriteIndex(Data: longint;
                        DataPos: longint): integer;
    procedure Append(var Data;
                         DataLen: longint);
    procedure AppendByte(Data: byte);
    procedure AppendCode(Data: byte);
    procedure AppendIndex(Data: longint);
    procedure AppendLength(Length: longint);
    procedure AppendPos(Pos: longint);
    procedure AppendOffset(Offset: longint);
    procedure AppendAddr(Addr: TAddress);

  { Label methods }
    function GetLabel: TCodeLabel;
    function CreateLabel: TCodeLabel;
    procedure FixLabel(var CodeLabel: TCodeLabel);
    function GetLabelOfs(CodeLabel: TCodeLabel): longint;
    function GetLabelAbs(CodeLabel: TCodeLabel): longint;

  { RAVE_STACK Commands }
    procedure PushAddr(Addr: TAddress);
    procedure PushMethodAddr(Addr: TAddress);
    procedure PushVar(Addr: TAddress);
    procedure PushData(Addr: TAddress;
                       Length: longint);
    procedure PushConst(var Data;
                            Length: longint);
    procedure PushStr(S1: string;
                      Addr: TAddress);
    procedure PushMethodStr(S1: string;
                            Addr: TAddress);
    procedure PushDefault;
    procedure Pop(Length: longint);

  { RAVE_CALL Commands }
    function Enter: longint;
    procedure UpdateEnter(Length: longint;
                          EnterPos: longint);
    procedure CopyParamData(Addr: TAddress;
                            Addr2: TAddress;
                            Length: longint);
    procedure CopyParamStr(Addr: TAddress;
                           Addr2: TAddress);
    procedure CopyParamDataDef(Addr: TAddress;
                               Addr2: TAddress;
                               Length: longint;
                               DefaultValue: longint);
    procedure CopyParamStrDef(Addr: TAddress;
                              Addr2: TAddress;
                              DefaultValue: longint);
    procedure FreeStr(Addr: TAddress);
    procedure FreeRec(Addr: TAddress;
                      ModuleIndex: longint;
                      TypeIndex: longint);
    procedure LoadVar(Addr: TAddress);
    procedure LoadData(Addr: TAddress;
                       Length: longint);
    procedure Return(Length: longint;
                     IsResult: boolean);
    procedure Call(CodeLabel: TCodeLabel);
    function CallExternalFunc(TypeKind: TTypeKind;
                              Addr: TAddress): longint;
    function CallExternalProc: longint;
    procedure LongCall(Module: longint;
                       Offset: longint);

  { RAVE_JUMP Commands }
    procedure JumpEQ(CodeLabel: TCodeLabel);
    procedure JumpNE(CodeLabel: TCodeLabel);
    procedure JumpLT(CodeLabel: TCodeLabel);
    procedure JumpLE(CodeLabel: TCodeLabel);
    procedure JumpGT(CodeLabel: TCodeLabel);
    procedure JumpGE(CodeLabel: TCodeLabel);
    procedure Jump(CodeLabel: TCodeLabel);
    procedure LongJump(Module: longint;
                       Offset: longint);

    procedure RaveMath(Command: byte;
                       Addr: TAddress);
    function ConvType(TK1: TTypeKind;
                      TK2: TTypeKind;
                      Addr: TAddress): boolean;

  { RAVE_MISC Commands }
    procedure Assign(Command: byte;
                     Size: longint);
    procedure StrAssign(Command: byte);
    procedure MathAssign(Command: byte);
    procedure NOP;
    procedure Terminate;
    procedure BeginForTo(CodeLabel: TCodeLabel);
    procedure BeginForDownTo(CodeLabel: TCodeLabel);
    procedure EndFor(CodeLabel: TCodeLabel);
    procedure LoopTest(CodeLabel: TCodeLabel);
    procedure IfTest(CodeLabel: TCodeLabel);

    property Module: TRCPUModule read FModule;
    property SizeInc: longint read FSizeInc write FSizeInc;
    property CodeSeg: pointer read FCodeSeg write SetCodeSeg;
    property MaxSize: longint read FMaxSize write SetMaxSize;
    property CodeSize: longint read FCodeSize;
  end; { TCodeManager }

implementation

uses
{$IFDEF DOMAP}
  RVLEDbug,
{$ENDIF}
  RPDefine;

(*****************************************************************************}
( class TCodeManager
(*****************************************************************************)

  constructor TCodeManager.Create(InitSize: longint;
                                  AModule: TRCPUModule);

  var
    CodeBuf: pointer;

  begin { Create }
    inherited Create;
    FModule := AModule;
    SizeInc := 4096;
    FCodeSize := 0;
    FMaxSize := InitSize;
    If MaxSize > 0 then begin
      GetMem(CodeBuf,MaxSize);
    end else begin
      CodeBuf := nil;
    end; { else }
    CodeSeg := CodeBuf;
  end;  { Create }

  destructor TCodeManager.Destroy;

  begin { Destroy }
  { Don't free FCodeSeg since Module owns it }
    inherited Destroy;
  end;  { Destroy }

  procedure TCodeManager.SetCodeSeg(Value: pointer);

  begin { SetCodeSeg }
    FCodeSeg := Value;
    Module.CodeSeg := Value;
    Module.CodeSize := MaxSize;
  end;  { SetCodeSeg }

  procedure TCodeManager.SetMaxSize(Value: longint);

  var
    NewBuf: pointer;
    NewBufSize: longint;

  begin { SetMaxSize }
    If Value > MaxSize then begin
    { Allocate new buffer in increments of SizeInc }
      NewBufSize := ((Value - 1) div SizeInc + 1) * SizeInc;
      GetMem(NewBuf,NewBufSize);

    { Copy data over }
      Move(CodeSeg^,NewBuf^,CodeSize);

    { Free old buffer and use new buffer }
      FreeMem(CodeSeg,MaxSize);
      CodeSeg := NewBuf;
      FMaxSize := NewBufSize;
    end; { if }
  end;  { SetMaxSize }

  procedure TCodeManager.FinishBuf;

  var
    NewBuf: pointer;

  begin { FinishBuf }
  { Remove any extra bytes from end of code buffer }
    If CodeSize <> MaxSize then begin
      GetMem(NewBuf,CodeSize);
      Move(CodeSeg^,NewBuf^,CodeSize);
      FreeMem(CodeSeg,MaxSize);
      FMaxSize := CodeSize;
      CodeSeg := NewBuf;
    end; { if }
  end;  { FinishBuf }

  procedure TCodeManager.Write(var Data;
                                   DataLen: longint;
                                   DataPos: longint);

  begin { Write }
    Move(Data,pointer(longint(CodeSeg) + DataPos)^,DataLen);
  end;  { Write }

  procedure TCodeManager.WriteByte(    Data: byte;
                                   var DataPos: longint);

  begin { WriteByte }
    byte(pointer(longint(CodeSeg) + DataPos)^) := Data;
    Inc(DataPos);
  end;  { WriteByte }

  function TCodeManager.WriteIndex(Data: longint;
                                   DataPos: longint): integer;

  {$IFNDEF NOINDEX}
  var
    I1: longint;
  {$ENDIF}

  begin { WriteIndex }
  {$IFDEF NOINDEX}
    Write(Data,SizeOf(Data),DataPos);
    Result := SizeOf(Data);
  {$ELSE}
    If (Data < longint($00000080)) then begin
      Result := 1;
      WriteByte(Data,DataPos);
    end else if (Data < longint($00004000)) then begin
      Result := 2;
      I1 := Data + longint($00008000);
      WriteByte(Hi(I1),DataPos);
      WriteByte(Lo(I1),DataPos);
    end else if (Data < longint($00200000)) then begin
      Result := 3;
      I1 := Data + longint($00C00000);
      WriteByte(Lo(HiWord(I1)),DataPos);
      WriteByte(Hi(LoWord(I1)),DataPos);
      WriteByte(Lo(LoWord(I1)),DataPos);
    end else begin
      Result := 4;
      I1 := Data + longint($E0000000);
      WriteByte(Hi(HiWord(I1)),DataPos);
      WriteByte(Lo(HiWord(I1)),DataPos);
      WriteByte(Hi(LoWord(I1)),DataPos);
      WriteByte(Lo(LoWord(I1)),DataPos);
    end; { else }
  {$ENDIF}
  end;  { WriteIndex }

  procedure TCodeManager.Append(var Data;
                                    DataLen: longint);

  var
    NewCodeSize: longint;

  begin { Append }
    NewCodeSize := CodeSize + DataLen;
    If NewCodeSize > MaxSize then begin { Grow buffer }
      MaxSize := NewCodeSize;
    end; { if }
    Write(Data,DataLen,CodeSize);
    FCodeSize := NewCodeSize;
  end;  { Append }

  procedure TCodeManager.AppendByte(Data: byte);

  begin { AppendByte }
    Append(Data,SizeOf(Data));
  end;  { AppendByte }

  procedure TCodeManager.AppendCode(Data: byte);

  begin { AppendCode }
    {$IFDEF DOMAP}MapCode(Data);{$ENDIF}
    Append(Data,SizeOf(Data));
  end;  { AppendCode }

  procedure TCodeManager.AppendIndex(Data: longint);

  {$IFNDEF NOINDEX}
  var
    I1: cardinal;
  {$ENDIF}

  begin { AppendIndex }
  {$IFDEF NOINDEX}
    Append(Data,SizeOf(Data));
  {$ELSE}
    I1 := cardinal(Data);
    If (I1 < cardinal($00000080)) then begin
      AppendByte(I1);
    end else if (I1 < cardinal($00004000)) then begin
      I1 := I1 + cardinal($00008000);
      AppendByte(Hi(I1));
      AppendByte(Lo(I1));
    end else if (I1 < cardinal($00200000)) then begin
      I1 := I1 + cardinal($00C00000);
      AppendByte(Lo(HiWord(I1)));
      AppendByte(Hi(LoWord(I1)));
      AppendByte(Lo(LoWord(I1)));
    end else begin
      I1 := I1 + cardinal($E0000000);
      AppendByte(Hi(HiWord(I1)));
      AppendByte(Lo(HiWord(I1)));
      AppendByte(Hi(LoWord(I1)));
      AppendByte(Lo(LoWord(I1)));
    end; { else }
  {$ENDIF}
  end;  { AppendIndex }

  procedure TCodeManager.AppendLength(Length: longint);

  begin { AppendLength }
    AppendIndex(Length);
    {$IFDEF DOMAP}MapLen(Length);{$ENDIF}
  end;  { AppendLength }

  procedure TCodeManager.AppendPos(Pos: longint);

  begin { AppendPos }
    AppendIndex(Pos);
    {$IFDEF DOMAP}MapPos(Pos);{$ENDIF}
  end;  { AppendPos }

  procedure TCodeManager.AppendOffset(Offset: longint);

  begin { AppendOffset }
    AppendIndex(OffsetToIndex(Offset));
  end;  { AppendOffset }

  procedure TCodeManager.AppendAddr(Addr: TAddress);

  var
    B1: byte;
    AddrAdd: byte;
    Offset: longint;

  begin { AppendAddr }
    If Addr.Loc <= alSP then begin { Convert offset }
      Offset := OffsetToIndex(Addr.Offset);
      AddrAdd := Ord(Addr.Loc) shl 6; { alBP=$00, alSP=$40 }
    end else if Addr.Module = 0 then begin { Local DS }
      Offset := Addr.Offset;
      AddrAdd := $80;
    end else begin { Global DS }
      Offset := Addr.Module;
      AddrAdd := $C0;
    end; { else }

    If Offset <= 62 then begin
      B1 := AddrAdd + Offset;
      AppendByte(B1);
    end else begin
      B1 := AddrAdd + $3F;
      AppendByte(B1);
      AppendIndex(Offset);
    end; { else }
    If Addr.Module > 0 then begin
      AppendIndex(Addr.Offset);
    end; { else }

    {$IFDEF DOMAP}MapAddr(Addr);{$ENDIF}
  end;  { AppendAddr }

{ Label methods }

  function TCodeManager.GetLabel: TCodeLabel;

  begin { SetLabel }
  { Creates a label and set the value to the current position in code. }
    Result.Offset := CodeSize;
    Result.AssignList := nil;
    {$IFDEF DOMAP}Result.Index := LabelIdx;{$ENDIF}
    {$IFDEF DOMAP}Inc(LabelIdx);{$ENDIF}
    {$IFDEF DOMAP}MapLine;{$ENDIF}
    {$IFDEF DOMAP}Map('Label #' + IntToStr(Result.Index));{$ENDIF}
  end;  { SetLabel }

  function TCodeManager.CreateLabel: TCodeLabel;

  begin { CreateLabel }
  { Creates a place holder for a label so that further commands can reference
    it and the code can be updated later using AssignLabel }
    Result.Offset := -1;
    Result.AssignList := TList.Create;
    {$IFDEF DOMAP}Result.Index := LabelIdx;{$ENDIF}
    {$IFDEF DOMAP}Inc(LabelIdx);{$ENDIF}
  end;  { CreateLabel }

  procedure TCodeManager.FixLabel(var CodeLabel: TCodeLabel);

  var
    I1: integer;
    I2: integer;
    Addr: longint;
    Len: integer;

  begin { FixLabel }
  { Goes through all references to the label and sets their value to the
    current position in code }
    CodeLabel.Offset := CodeSize;
    For I1 := 0 to (CodeLabel.AssignList.Count - 1) do begin
      Addr := longint(CodeLabel.AssignList[I1]);
      If Addr < 0 then begin { Offset lookup }
        Addr := -Addr;
        Len := WriteIndex(OffsetToIndex(CodeSize - Addr),Addr);
      end else begin { Absolute lookup }
        Len := WriteIndex(CodeSize,Addr);
      end; { else }
    { Write NOPs in remaining positions }
      Addr := Addr + Len;
      For I2 := Len to 3 do begin
        WriteByte(RAVENOP,Addr);
      end; { for }
    end; { for }
    FreeAndNil(CodeLabel.AssignList);
    {$IFDEF DOMAP}MapLine;{$ENDIF}
    {$IFDEF DOMAP}Map('Label #' + IntToStr(CodeLabel.Index));{$ENDIF}
  end;  { FixLabel }

  function TCodeManager.GetLabelOfs(CodeLabel: TCodeLabel): longint;

  begin { GetLabelOfs }
    If CodeLabel.Offset = -1 then begin { Label not yet fixed }
    { Register current code position with this CodeLabel as an offset }
      CodeLabel.AssignList.Add(pointer(-CodeSize));
      Result := $00100000; { Force 4 bytes to be written }
      {$IFDEF DOMAP}Map('Label=' + IntToStr(CodeLabel.Index) + ' Pos=(fwd)');{$ENDIF}
    end else begin { Label has been fixed }
      Result := CodeLabel.Offset - CodeSize;
      {$IFDEF DOMAP}Map('Label=' + IntToStr(CodeLabel.Index) + ' Pos=' +
       IntToStr(CodeLabel.Offset));{$ENDIF}
    end; { else }
  end;  { GetLabelOfs }

  function TCodeManager.GetLabelAbs(CodeLabel: TCodeLabel): longint;

  begin { GetLabelAbs }
    If CodeLabel.Offset = -1 then begin { Label not yet fixed }
    { Register current code position with this CodeLabel as an absolute }
      CodeLabel.AssignList.Add(pointer(CodeSize));
      Result := $00200000; { Force 4 bytes to be written }
      {$IFDEF DOMAP}Map('Label=' + IntToStr(CodeLabel.Index) + ' Pos=(fwd)');{$ENDIF}
    end else begin { Label has been fixed }
      Result := CodeLabel.Offset;
      {$IFDEF DOMAP}Map('Label=' + IntToStr(CodeLabel.Index) + ' Pos=' + IntToStr(Result));{$ENDIF}
    end; { else }
  end;  { GetLabelAbs }

{ RAVE_STACK Commands }

  procedure TCodeManager.PushAddr(Addr: TAddress);

  begin { PushAddr }
    AppendCode(RAVEPUSHADDR);
    AppendAddr(Addr);
  end;  { PushAddr }

  procedure TCodeManager.PushMethodAddr(Addr: TAddress);

  begin { PushMethodAddr }
    AppendCode(RAVEPUSHMETHODADDR);
    AppendAddr(Addr);
  end;  { PushMethodAddr }

  procedure TCodeManager.PushVar(Addr: TAddress);

  begin { PushVar }
    AppendCode(RAVEPUSHVAR);
    AppendAddr(Addr);
  end;  { PushVar }

  procedure TCodeManager.PushData(Addr: TAddress;
                                  Length: longint);

  begin { PushData }
    AppendCode(RAVEPUSHDATA);
    AppendLength(Length);
    AppendAddr(Addr);
  end;  { PushData }

  procedure TCodeManager.PushConst(var Data;
                                       Length: longint);

  begin { PushConst }
    AppendCode(RAVEPUSHCONST);
    AppendLength(Length);
    Append(Data,Length);
    {$IFDEF DOMAP}try
      Case Length of
        1: Map('SHT:' + IntToStr(shortint(Data)) + ' or BYT:' +
         IntToStr(byte(Data)) + ' ');
        2: Map('SML:' + IntToStr(smallint(Data)) + ' or WRD:' +
         IntToStr(word(Data)) + ' ');
        4: Map('INT:' + IntToStr(integer(Data)) + ' or SNG:' +
         FloatToStr(single(Data)) + ' ');
        8: Map('DBL:' + FloatToStr(double(Data)) + ' or CUR:' +
         CurrToStr(currency(Data)) + ' ');
        10: Map(FloatToStr(extended(Data)) + ' ');
      end; { case }
    except
    end;{$ENDIF}
  end;  { PushConst }

  procedure TCodeManager.PushStr(S1: string;
                                 Addr: TAddress);

  var
    Len: integer;

  begin { PushStr }
    AppendCode(RAVEPUSHSTR);
    Len := Length(S1) + 1;
    AppendLength(Len);
    AppendAddr(Addr);
    If Len > 1 then begin
      Append(S1[1],Len - 1);
    end; { if }
    {$IFDEF DOMAP}Map('''' + S1 + ''' ');{$ENDIF}
    AppendByte(0);
  end;  { PushStr }

  procedure TCodeManager.PushMethodStr(S1: string;
                                       Addr: TAddress);

  var
    Len: integer;

  begin { PushMethodStr }
    AppendCode(RAVEPUSHMETHODSTR);
    Len := Length(S1) + 1;
    AppendLength(Len);
    AppendAddr(Addr);
    If Len > 1 then begin
      Append(S1[1],Len - 1);
    end; { if }
    {$IFDEF DOMAP}Map('''' + S1 + ''' ');{$ENDIF}
    AppendByte(0);
  end;  { PushMethodStr }

  procedure TCodeManager.PushDefault;

  begin { PushDefault }
    AppendCode(RAVEPUSHDEFAULT);
  end;  { PushDefault }

  procedure TCodeManager.Pop(Length: longint);

  begin { Pop }
    AppendCode(RAVEPOP);
    AppendLength(Length);
  end;  { Pop }

{ RAVE_CALL Commands }

  function TCodeManager.Enter: longint;

  begin { Enter }
    AppendCode(RAVEENTER);
    Result := CodeSize;
    AppendByte(0); { Write space for stack reserved space }
    AppendByte(0);
    AppendByte(0);
    AppendByte(0);
  end;  { Enter }

  procedure TCodeManager.UpdateEnter(Length: longint;
                                     EnterPos: longint);

  var
    Len: byte;
    I1: integer;

  begin { UpdateEnter }
    {$IFDEF DOMAP}MapLine;
    Map('UpdateEnter ');
    MapPos(EnterPos);
    MapLen(Length);{$ENDIF}

    Len := WriteIndex(Length,EnterPos);
    EnterPos := EnterPos + Len;
    For I1 := Len to 3 do begin { Write NOPs in remaining positions }
      WriteByte(RAVENOP,EnterPos);
    end; { for }
  end;  { UpdateEnter }

  procedure TCodeManager.CopyParamData(Addr: TAddress;
                                       Addr2: TAddress;
                                       Length: longint);

  begin { CopyParamData }
    AppendCode(RAVECOPYPARAMDATA);
    AppendLength(Length);
    AppendAddr(Addr);
    AppendAddr(Addr2);
  end;  { CopyParamData }

  procedure TCodeManager.CopyParamStr(Addr: TAddress;
                                      Addr2: TAddress);

  begin { CopyParamStr }
    AppendCode(RAVECOPYPARAMSTR);
    AppendAddr(Addr);
    AppendAddr(Addr2);
  end;  { CopyParamStr }

  procedure TCodeManager.CopyParamDataDef(Addr: TAddress;
                                          Addr2: TAddress;
                                          Length: longint;
                                          DefaultValue: longint);

  begin { CopyParamDataDef }
    AppendCode(RAVECOPYPARAMDATADEF);
    AppendLength(Length);
    AppendAddr(Addr);
    AppendAddr(Addr2);
    AppendPos(DefaultValue);
  end;  { CopyParamData }

  procedure TCodeManager.CopyParamStrDef(Addr: TAddress;
                                         Addr2: TAddress;
                                         DefaultValue: longint);

  begin { CopyParamStrDef }
    AppendCode(RAVECOPYPARAMSTRDEF);
    AppendAddr(Addr);
    AppendAddr(Addr2);
    AppendPos(DefaultValue);
  end;  { CopyParamStrDef }

  procedure TCodeManager.FreeStr(Addr: TAddress);

  begin { FreeStr }
    AppendCode(RAVEFREESTR);
    AppendAddr(Addr);
  end;  { FreeStr }

  procedure TCodeManager.FreeRec(Addr: TAddress;
                                 ModuleIndex: longint;
                                 TypeIndex: longint);

  begin { FreeRec }
    AppendCode(RAVEFREEREC);
    AppendAddr(Addr);
    AppendPos(ModuleIndex);
    AppendPos(TypeIndex);
  end;  { FreeRec }

  procedure TCodeManager.LoadVar(Addr: TAddress);

  begin { LoadVar }
    AppendCode(RAVELOADVAR);
    AppendAddr(Addr);
  end;  { LoadVar }

  procedure TCodeManager.LoadData(Addr: TAddress;
                                  Length: longint);

  begin { LoadData }
    AppendCode(RAVELOADDATA);
    AppendAddr(Addr);
    AppendLength(Length);
  end;  { LoadData }

  procedure TCodeManager.Return(Length: longint;
                                IsResult: boolean);

  var
    Command: byte;

  begin { Return }
    If IsResult then begin
      Command := RAVERETURNRES;
    end else begin
      Command := RAVERETURN;
    end; { else }
    AppendCode(Command);
    AppendLength(Length);
  end;  { Return }

  procedure TCodeManager.Call(CodeLabel: TCodeLabel);

  begin { Call }
    AppendCode(RAVECALL);
    AppendIndex(GetLabelAbs(CodeLabel));
  end;  { Call }

  function TCodeManager.CallExternalFunc(TypeKind: TTypeKind;
                                         Addr: TAddress): longint;

  begin { CallExternalFunc }
    AppendCode(RAVECALLEXTERNALFUNC);
    AppendByte(Ord(TypeKind));
    {$IFDEF DOMAP}Map('Returns (' + TypeKindStr(TypeKind) + ') to ');{$ENDIF}
    AppendAddr(Addr);
    Result := CodeSize;
    AppendByte(0);
    AppendByte(0);
    AppendByte(0);
    AppendByte(0);
  end;  { CallExternalFunc }

  function TCodeManager.CallExternalProc: longint;

  begin { CallExternalProc }
    AppendCode(RAVECALLEXTERNALPROC);
    Result := CodeSize;
    AppendByte(0);
    AppendByte(0);
    AppendByte(0);
    AppendByte(0);
  end;  { CallExternalProc }

  procedure TCodeManager.LongCall(Module: longint;
                                  Offset: longint);

  begin { LongCall }
    AppendCode(RAVELONGCALL);
    AppendIndex(Module);
    {$IFDEF DOMAP}Map('Module=' + IntToStr(Module) + ' ');{$ENDIF}
    AppendPos(Offset);
  end;  { LongCall }

{ RAVE_JUMP Commands }

  procedure TCodeManager.JumpEQ(CodeLabel: TCodeLabel);

  begin { JumpEQ }
    AppendCode(RAVEJUMPEQ);
    AppendOffset(GetLabelOfs(CodeLabel));
  end;  { JumpEQ }

  procedure TCodeManager.JumpNE(CodeLabel: TCodeLabel);

  begin { JumpNE }
    AppendCode(RAVEJUMPNE);
    AppendOffset(GetLabelOfs(CodeLabel));
  end;  { JumpNE }

  procedure TCodeManager.JumpLT(CodeLabel: TCodeLabel);

  begin { JumpLT }
    AppendCode(RAVEJUMPLT);
    AppendOffset(GetLabelOfs(CodeLabel));
  end;  { JumpLT }

  procedure TCodeManager.JumpLE(CodeLabel: TCodeLabel);

  begin { JumpLE }
    AppendCode(RAVEJUMPLE);
    AppendOffset(GetLabelOfs(CodeLabel));
  end;  { JumpLE }

  procedure TCodeManager.JumpGT(CodeLabel: TCodeLabel);

  begin { JumpGT }
    AppendCode(RAVEJUMPGT);
    AppendOffset(GetLabelOfs(CodeLabel));
  end;  { JumpGT }

  procedure TCodeManager.JumpGE(CodeLabel: TCodeLabel);

  begin { JumpGE }
    AppendCode(RAVEJUMPGE);
    AppendOffset(GetLabelOfs(CodeLabel));
  end;  { JumpGE }

  procedure TCodeManager.Jump(CodeLabel: TCodeLabel);

  begin { Jump }
    AppendCode(RAVEJUMP);
    AppendOffset(GetLabelOfs(CodeLabel));
  end;  { Jump }

  procedure TCodeManager.LongJump(Module: longint;
                                  Offset: longint);

  begin { LongJump }
    AppendCode(RAVELONGJUMP);
    AppendIndex(Module);
    {$IFDEF DOMAP}Map('Module=' + IntToStr(Module) + ' ');{$ENDIF}
    AppendPos(Offset);
  end;  { LongJump }

  procedure TCodeManager.RaveMath(Command: byte;
                                  Addr: TAddress);

  begin { RaveMath }
    AppendCode(Command);
    AppendAddr(Addr);
  end;  { RaveMath }

  function TCodeManager.ConvType(TK1: TTypeKind;
                                 TK2: TTypeKind;
                                 Addr: TAddress): boolean;

  var
    Func1: integer;
    Func2: integer;

  begin { ConvType }
    Result := true;
    If (TK1 in MathTypes) and (TK2 in MathTypes) then begin
      Func1 := TypeConv1[TK1,TK2];
      Func2 := TypeConv2[TK1,TK2];
    end else begin
      Func1 := RAVEINVALID;
      Func2 := RAVEDEFAULT;
      Case TK1 of
        tkChar: begin
          If TK2 = tkString then begin
            Func1 := RAVECHR2STR;
          end; { if }
        end;
      end; { case }
    end; { else }
    If Func1 = RAVEDEFAULT then Exit; { no code needed }
    If Func1 = RAVEINVALID then begin
      Result := false;
      Exit;
    end; { if }
    If Func2 = RAVEDEFAULT then begin { Single conversion }
      AppendCode(Func1);
      AppendAddr(Addr);
    end else begin { Double conversion }
      AppendCode(RAVEDOUBLECONV);
      AppendByte(Func1);
      {$IFDEF DOMAP}Map(CommandStr(Func1) + ' ');{$ENDIF}
      AppendByte(Func2);
      {$IFDEF DOMAP}Map(CommandStr(Func2) + ' ');{$ENDIF}
      AppendAddr(Addr);
    end; { else }
  end;  { ConvType }

{ RAVE_MISC Commands }

  procedure TCodeManager.Assign(Command: byte;
                                Size: longint);

  begin { Assign }
    AppendCode(Command);
    AppendLength(Size);
  end;  { Assign }

  procedure TCodeManager.StrAssign(Command: byte);

  begin { StrAssign }
    AppendCode(Command);
  end;  { StrAssign }

  procedure TCodeManager.MathAssign(Command: byte);

  begin { MathAssign }
    AppendCode(Command);
  end;  { MathAssign }

  procedure TCodeManager.NOP;

  begin { NOP }
    AppendCode(RAVENOP);
  end;  { NOP }

  procedure TCodeManager.Terminate;

  begin { Terminate }
    AppendCode(RAVETERMINATE);
  end;  { Terminate }

  procedure TCodeManager.BeginForTo(CodeLabel: TCodeLabel);

  begin { BeginForTo }
    AppendCode(RAVEBEGINFORTO);
    AppendOffset(GetLabelOfs(CodeLabel));
  end;  { BeginForTo }

  procedure TCodeManager.BeginForDownTo(CodeLabel: TCodeLabel);

  begin { BeginForDownTo }
    AppendCode(RAVEBEGINFORDOWNTO);
    AppendOffset(GetLabelOfs(CodeLabel));
  end;  { BeginForDownTo }

  procedure TCodeManager.EndFor(CodeLabel: TCodeLabel);

  begin { EndFor }
    AppendCode(RAVEENDFOR);
    AppendOffset(GetLabelOfs(CodeLabel));
  end;  { EndFor }

  procedure TCodeManager.LoopTest(CodeLabel: TCodeLabel);

  begin { LoopTest }
    AppendCode(RAVELOOPTEST);
    AppendOffset(GetLabelOfs(CodeLabel));
  end;  { LoopTest }

  procedure TCodeManager.IfTest(CodeLabel: TCodeLabel);

  begin { IfTest }
    AppendCode(RAVEIFTEST);
    AppendOffset(GetLabelOfs(CodeLabel));
  end;  { IfTest }

end.

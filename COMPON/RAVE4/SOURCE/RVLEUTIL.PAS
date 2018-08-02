{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVLEUtil;

interface

uses
  WinTypes, WinProcs, Classes, SysUtils, ComCtrls, CommCtrl, Dialogs,
  RVLEDef, RVClass, RVUtil, RPDefine;

type
  TTKStr = string[255];

  TRaveParser = class
  protected
    Buf: PChar; { Buffer for RAVE source }
    BufPtr: PChar; { Pointer to current position in Buf }
    FTokenType: TTokenType;
    FTokenName: TTKStr;
    FTokenUpper: string;
    FKeepToken: boolean;
    FCurrCol: integer;
    FCurrLine: integer;
    FTokenCol: integer;
    FTokenLine: integer;
    FTokenInt: integer;
    FTokenExt: extended;
    FTokenCurr: currency;

    procedure SetText(Value: string);
  public
    destructor Destroy; override;
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromFile(FileName: string);
    procedure GetToken;
    function GetID: string;
    function ValidToken(ValidTypes: TTokenTypeSet): boolean;
    function MatchID(ID: string): boolean;
    function MatchSymbol(Symbol: string): boolean;
    procedure ReadUntil(ID: string);

    property Text: string write SetText;
    property TokenType: TTokenType read FTokenType write FTokenType;
    property TokenName: TTKStr read FTokenName write FTokenName;
    property TokenUpper: string read FTokenUpper write FTokenUpper;
    property KeepToken: boolean read FKeepToken write FKeepToken;
    property CurrCol: integer read FCurrCol write FCurrCol;
    property CurrLine: integer read FCurrLine write FCurrLine;
    property TokenCol: integer read FTokenCol write FTokenCol;
    property TokenLine: integer read FTokenLine write FTokenLine;
    property TokenInt: integer read FTokenInt write FTokenInt;
    property TokenExt: extended read FTokenExt write FTokenExt;
    property TokenCurr: currency read FTokenCurr write FTokenCurr;
  end; { TRaveParser }

  TBolCaller = function(    Proc: longint;
                        var StackData;
                            StackItems: integer): boolean;
  TShtCaller = function(    Proc: longint;
                        var StackData;
                            StackItems: integer): shortint;
  TBytCaller = function(    Proc: longint;
                        var StackData;
                            StackItems: integer): byte;
  TSmlCaller = function(    Proc: longint;
                        var StackData;
                            StackItems: integer): smallint;
  TWrdCaller = function(    Proc: longint;
                        var StackData;
                            StackItems: integer): word;
  TIntCaller = function(    Proc: longint;
                        var StackData;
                            StackItems: integer): integer;
  TSngCaller = function(    Proc: longint;
                        var StackData;
                            StackItems: integer): single;
  TDblCaller = function(    Proc: longint;
                        var StackData;
                            StackItems: integer): double;
  TExtCaller = function(    Proc: longint;
                        var StackData;
                            StackItems: integer): extended;
  TCurCaller = function(    Proc: longint;
                        var StackData;
                            StackItems: integer): currency;
  TChrCaller = function(    Proc: longint;
                        var StackData;
                            StackItems: integer): char;
  TPtrCaller = function(    Proc: longint;
                        var StackData;
                            StackItems: integer): pointer;
  TClassCaller = function(    Proc: longint;
                          var StackData;
                              StackItems: integer): TObject;

  procedure AddError(Num: integer;
                     Msg: string);
  procedure RaiseError(ErrorMessage: string);
  procedure FuncCaller;
  procedure RecCaller(    Proc: longint;
                      var StackData;
                          StackItems: integer;
                      var RecordData);

var
  ErrorLine: longint;
  ErrorCol: longint;
  ErrorEvent: TRaveEvent;
  IncludeErrPos: boolean = false; // Include error position in error message

implementation

uses
  RVLEMod;

  procedure RaiseError(ErrorMessage: string);

  begin { RaiseError }
    Raise ERaveCompiler.Create(ErrorMessage);
  end;  { RaiseError }

  procedure FuncCaller;

  asm  { FuncCaller }
  // eax=Proc, ecx=StackItems, edx=StackData
    test ecx,ecx
    jz   @2
  @1:
    mov  ebx,[edx]
    push ebx
    add  edx,4
    loop @1
  @2:
    call eax
  end; { FuncCaller }

  procedure RecCaller(    Proc: longint;
                      var StackData;
                          StackItems: integer;
                      var RecordData);

  asm  { RecCaller }
  // eax=Proc, ecx=StackItems, edx=StackData, [bp-8]=RecordData
    test ecx,ecx
    jz   @2
  @1: { Push parameters }
    mov  ebx,[edx]
    push ebx
    add  edx,4
    loop @1
  @2: { Load up pointer to RecordData }
    push RecordData
    call eax
  end; { RecCaller }

  function ErrorMsg(Num: integer;
                    Msg: string): string;

  var
    Err: string;

  begin { ErrorMsg }
    Case Num of
      1: Err := {Trans+}'Identifier expected.';
      2: Err := {Trans+}'[%s] expected.';
      3: Err := {Trans+}'[IMPLEMENTATION] expected.';
      4: Err := {Trans+}'Invalid identifier [%s].';
      5: Err := {Trans+}'Constant value expected.';
      6: Err := {Trans+}'Type mismatch.';
      7: Err := {Trans+}'[}] encountered without matching [{].';
      8: Err := {Trans+}'Numeric constant expected.';
      9: Err := {Trans+}'Invalid constant type.';
      10: Err := {Trans+}'Invalid constant defintion.';
      11: Err := {Trans+}'Unknown operator [%s]';
      12: Err := {Trans+}'String constant exceeds end of line.';
      13: Err := {Trans+}'Comment exceeds end of file.';
      14: Err := {Trans+}'Invalid type definition.';
      15: Err := {Trans+}'Duplicate identifier [%s]';
      16: Err := {Trans+}'Low index type does not match high index type.';
      17: Err := {Trans+}'Enumerated types are limited to 256 items.';
      18: Err := {Trans+}'Invalid operand.';
      19: Err := {Trans+}'Ordinal constant expected.';
      20: Err := {Trans+}'High index less than low index.';
      21: Err := {Trans+}'Size of type too big (> 2GB).';
      22: Err := {Trans+}'Unknown identifier [%s].';
      23: Err := {Trans+}'Type identifier expected.';
      24: Err := {Trans+}'Type mismatch.';
      25: Err := {Trans+}'Invalid type for this operator.';
      26: Err := {Trans+}'Cannot assign to this type.';
      27: Err := {Trans+}'Ordinal expression expected.';
      28: Err := {Trans+}'Invalid use of assignement operator.';
      29: Err := {Trans+}'Duplicate identifier [%s].';
      30: Err := {Trans+}'Default values only allowed on value parameters.';
      31: Err := {Trans+}'Only var parameters can be untyped.';
      32: Err := {Trans+}'Invalid location for CREATION.';
      33: Err := {Trans+}'Invalid location for DESTRUCTION.';
      34: Err := {Trans+}'Invalid location for IMPLEMENTATION.';
      35: Err := {Trans+}'[END MODULENAME;] expected.';
      36: Err := Msg;
      37: Err := {Trans+}'Structured type expected.';
      38: Err := {Trans+}'Integer variable expected.';
      39: Err := {Trans+}'Integer expression expected.';
      40: Err := {Trans+}'Boolean expression expected.';
      41: Err := {Trans+}'ELSEIF invalid after ELSE.';
      42: Err := {Trans+}'ELSE invalid after ELSE.';
      43: Err := {Trans+}'Class Identifier expected.';
      44: Err := {Trans+}'Function differs from previous definition.';
      45: Err := {Trans+}'Internal Error [%s].'; { 101-101 }
      46: Err := {Trans+}'Read value already set.';
      47: Err := {Trans+}'Write value already set.';
      48: Err := {Trans+}'Read function result must be of same type as property.';
      49: Err := {Trans+}'Too many parameters for read function.';
      50: Err := {Trans+}'Write function parameter must be of same type as property.';
      51: Err := {Trans+}'Too many parameters for write function.';
      52: Err := {Trans+}'Write function must not return a result';
    end; { case }
    Err := Trans(Format(Err,[Msg]));
    If IncludeErrPos then begin
      Result := Trans(Format({Trans+}'Error #%d - %s (line %d col %d)',[Num,Err,ErrorLine,ErrorCol]));
    end else begin
      Result := Trans(Format({Trans+}'Error #%d - %s',[Num,Err]));
    end; { else }
  end;  { ErrorMsg }

  procedure AddError(Num: integer;
                     Msg: string);

  var
    RaveEvent: TRaveEvent;
    I1: integer;

  begin { AddError }
  // Find TRaveEvent that error occured in
    ErrorEvent := nil;
    If Assigned(CurrentModule) and Assigned(CurrentModule.SourceRefList) then begin
      For I1 := 0 to CurrentModule.SourceRefList.Count - 1 do begin
        RaveEvent := TRaveEvent(CurrentModule.SourceRefList[I1]);
        If RaveEvent.SourceLine <= ErrorLine then begin
          ErrorEvent := RaveEvent;
        end else begin
          Break;
        end; { else }
      end; { for }
    end; { if }

  // Generate exception to abort compile
    Raise ERaveCompiler.Create(ErrorMsg(Num,Msg));
  end;  { AddError }

(*****************************************************************************}
( class TRaveParser
(*****************************************************************************)

  destructor TRaveParser.Destroy;

  begin { Destroy }
    StrDispose(Buf);
    inherited Destroy;
  end;  { Destroy }

  procedure TRaveParser.LoadFromStream(Stream: TStream);

  var
    BufSize: longint;

  begin { LoadFromStream }
    BufSize := Stream.Size - Stream.Position;
    Buf := StrAlloc(BufSize + 1);
    BufPtr := Buf;
    CurrLine := 1;
    CurrCol := 0;
    Stream.ReadBuffer(Buf^,BufSize);
    (Buf + BufSize)^ := #0; { Put null character on end of buffer }
  end;  { LoadFromStream }

  procedure TRaveParser.LoadFromFile(FileName: string);

  var
    Stream: TStream;

  begin { LoadFromFile }
    Stream := TFileStream.Create(FileName,fmOpenRead);
    try
      LoadFromStream(Stream);
    finally
      Stream.Free;
    end; { with }
  end;  { LoadFromFile }

  procedure TRaveParser.SetText(Value: string);

  begin { SetText }
    Buf := StrAlloc(Length(Value) + 1);
    BufPtr := Buf;
    CurrLine := 1;
    CurrCol := 0;
    If Length(Value) = 0 then begin
      Buf^ := #0;
    end else begin
      Move(Value[1],Buf^,Length(Value) + 1);
    end; { else }
  end;  { SetText }

  procedure TRaveParser.GetToken;

  const
    HexDigits = '0123456789ABCDEF';

  var
    I1: integer;
    IgnoreLevel: byte;
    Finished: boolean;
    TokenStart: PChar;
    TokenEnd: PChar;
    DestPtr: PChar;
    SrcPtr: PChar;
    HexVal: integer;

    procedure Next;

    begin { Next }
      Inc(BufPtr);
      Inc(FCurrCol);
    end;  { Next }

    procedure Prev;

    begin { Prev }
      Dec(BufPtr);
      Dec(FCurrCol);
    end;  { Prev }

  begin { GetToken }
    If KeepToken then begin
      KeepToken := false;
      Exit;
    end; { if }
    Repeat
    { Skip whitespace }
      While true do begin
        Case BufPtr^ of
          #0: Break;
          #10: begin
            Inc(FCurrLine);
            CurrCol := 0;
          end;
          #33..#255: Break;
        end; { case }
        Next;
      end; { while }

      TokenLine := CurrLine;
      TokenCol := CurrCol;
      TokenStart := BufPtr;
      TokenEnd := TokenStart;
      Finished := true;
      TokenType := ttOperator;
      HexVal := 0;
      Case BufPtr^ of
        #0: begin
          TokenType := ttEOF;
        end;
        'A'..'Z','a'..'z','_': begin { ID }
          Repeat
            Next;
          until not (BufPtr^ in ['0'..'9','A'..'Z','a'..'z','_']);
          TokenType := ttID;
        end;
        '\','''': begin { String }
          TokenEnd := BufPtr;
          TokenType := ttString;
          While true do begin
            Case BufPtr^ of
              '\': begin
                Next;
                I1 := 0;
                While BufPtr^ in ['0'..'9'] do begin
                  I1 := I1 * 10 + (Ord(BufPtr^) - Ord('0'));
                  Next;
                end; { while }
                TokenEnd^ := Chr(I1);
                Inc(TokenEnd);
              end;
              '''': begin
                Next;
                While true do begin
                  Case BufPtr^ of
                    #0,#10,#13: AddError(12,'');
                    '''': begin
                      Next;
                      If BufPtr^ <> '''' then Break;
                    end;
                  end; { case }
                  TokenEnd^ := BufPtr^;
                  Inc(TokenEnd);
                  Next;
                end;
              end;
              else Break;
            end; { case }
          end; { while }
        end;
        '#': begin { Hex }
          Next;
          HexVal := 0;
          While BufPtr^ in ['0'..'9','A'..'F','a'..'f'] do begin
            HexVal := HexVal * 16 + (Pos(UpCase(BufPtr^),HexDigits) - 1);
            Next;
          end; { while }
          TokenType := ttInteger;
        end;
        '$': begin { Currency }
          Next;
          TokenStart := BufPtr; { Skip over $ }
          If not (BufPtr^ in ['0'..'9']) then begin
            AddError(8,'');
            Finished := false;
          end else begin
            While BufPtr^ in ['0'..'9'] do begin
              Next;
            end; { while }
            If BufPtr^ = '.' then begin
              Next;
              While BufPtr^ in ['0'..'9'] do begin
                Next;
              end; { while }
            end; { if }
            TokenType := ttCurrency;
          end; { else }
        end;
        '!','+',':','*': begin { !, !=, +, +=, :, :=, *, *=, =, == }
          Next;
          If BufPtr^ = '=' then begin
            Next;
          end; { if }
        end;
        '/': begin { /, /=, // }
          Next;
          If BufPtr^ = '=' then begin
            Next;
          end else if BufPtr^ = '/' then begin { Ignore to end of line }
            Repeat
              Next;
            until BufPtr^ in [#0,#10];
            Finished := false;
          end; { else }
        end;
        '-': begin { -, -= or -> }
          Next;
          If BufPtr^ in ['='{,'>'}] then begin
            Next;
          end; { if }
        end;
        '.': begin { . or .. }
          Next;
          If BufPtr^ = '.' then begin
            Next;
          end; { if }
        end;
        '0'..'9': begin { Number }
          Repeat
            Next;
          until not (BufPtr^ in ['0'..'9']);
          TokenType := ttInteger;
          If BufPtr^ = '.' then begin
            Next;
            If BufPtr^ = '.' then begin { .. - return int token first }
              Prev;
            end else begin { Floating point }
              TokenType := ttFloat;
              While BufPtr^ in ['0'..'9'] do begin
                Next;
              end; { while }
              If BufPtr^ in ['E','e'] then begin
                Next;
                If BufPtr^ in ['+','-'] then begin
                  Next;
                end; { if }
                While BufPtr^ in ['0'..'9'] do begin
                  Next;
                end; { while }
              end; { if }
            end; { else }
          end; { if }
        end;
        '{': begin { Process comment }
          IgnoreLevel := 1;
          Repeat
            Next;
            If BufPtr^ = '{' then begin
              Inc(IgnoreLevel);
            end else if BufPtr^ = '}' then begin
              Dec(IgnoreLevel);
            end else if BufPtr^ = #10 then begin
              Inc(FCurrLine);
              CurrCol := 0;
            end; { else }
          until (IgnoreLevel = 0) or (BufPtr^ = #0);
          If BufPtr^ = #0 then begin
            AddError(13,'');
            TokenType := ttEOF;
          end else begin
            Next;
          end; { else }
          Finished := false;
        end;
        '}': begin
          AddError(7,'');
          Finished := false;
        end;
        '<': begin { <, <>, <=, <-, << }
          Next;
          If BufPtr^ in [{'-',}'<','=','>'] then begin
            Next;
          end; { if }
        end; { if }
        '>': begin { >, >=, >> }
          Next;
          If BufPtr^ in ['=','>'] then begin
            Next;
          end; { if }
        end;
        else begin { Return single character }
          Next;
        end;
      end; { case }
    until Finished or (TokenType = ttEOF);
    ErrorLine := TokenLine;
    ErrorCol := TokenCol;

  { Assign token to TokenName }
    If TokenType <> ttString then begin
      TokenEnd := BufPtr;
    end; { if }
    If TokenType <> ttEOF then begin
      If TokenEnd = TokenStart then begin
        FTokenName := '';
      end else begin
      //  SetLength(FTokenName,TokenEnd - TokenStart);
        FTokenName[0] := Chr(TokenEnd - TokenStart);
        SrcPtr := TokenStart;
        DestPtr := @FTokenName[1];
        While SrcPtr <> TokenEnd do begin
          DestPtr^ := SrcPtr^;
          Inc(DestPtr);
          Inc(SrcPtr);
        end; { while }
      end; { else }
    //SetString(FTokenName,TokenStart,TokenEnd - TokenStart);
    end; { if }

    Case TokenType of
      ttID: begin
        TokenUpper := UpperCase(TokenName);
      end;
      ttInteger: begin
        If TokenName[1] = '#' then begin
          TokenInt := HexVal;
        end else begin
          TokenInt := StrToInt(TokenName);
        end; { else }
      end;
      ttFloat: begin
        TokenExt := StrToFloat(TokenName);
      end;
      ttCurrency: begin
        TokenCurr := StrToCurr(TokenName);
      end;
      ttEOF: begin
        TokenName := '';
      end;
    end; { case }
  end;  { GetToken }

  function TRaveParser.GetID: string;

  begin { GetID }
    GetToken;
    If TokenType = ttID then begin
      Result := TokenName;
    end else begin
      AddError(1,'');
      Result := {Trans-}'INVALID';
    end; { else }
  end;  { GetID }

  function TRaveParser.ValidToken(ValidTypes: TTokenTypeSet): boolean;

  begin { ValidToken }
    Result := TokenType in ValidTypes;
    If not Result then begin
      AddError(4,TokenName);
    end; { if }
  end;  { ValidToken }

  function TRaveParser.MatchID(ID: string): boolean;

  var
    S1: string;

  begin { MatchID }
    GetToken;
    S1 := TokenName;
    If Pos('.',ID) > 0 then begin
      GetToken;
      If TokenName = '.' then begin
        GetToken;
        S1 := S1 + '.' + TokenName;
      end else begin
        KeepToken := true;
      end; { else }
    end; { if }

    Result := SameStr(S1,ID);
    If not Result then begin
      AddError(2,ID);
    end; { if }
  end;  { MatchID }

  function TRaveParser.MatchSymbol(Symbol: string): boolean;

  begin { MatchSymbol }
    GetToken;
    Result := (TokenType = ttOperator) and (TokenName = Symbol);
    If not Result then begin
      AddError(2,Symbol);
    end; { if }
  end;  { MatchSymbol }

  procedure TRaveParser.ReadUntil(ID: string);

  begin { ReadUntil }
    Repeat
      GetToken;
    until (TokenType = ttEOF) or (TokenName = ID);
  end;  { ReadUntil }

end.

{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVLEDbug;

interface

{$DEFINE DOMAP}

uses
  WinTypes, WinProcs, Classes, SysUtils, Dialogs, RVLEDef, RVLEUtil,
  RVLEType, RVLEID, RVLEMod, RVLECode, RVLEExpr, RVUtil;

{$IFDEF DOMAP}
  function TypeKindStr(TypeKind: TTypeKind): string;
  function OpKindStr(OpKind: TOpKind): string;
  function CommandStr(Command: byte): string;

  procedure MapConstant(CodeListItem: PCodeListItem);
  procedure MapCodeList(Name: string;
                        CodeList: TRaveStackList);
  procedure MapOpStack(OpStack: TRaveStackList);
  procedure MapArray(ArrayType: TArrayType);
  procedure Map(Value: string);
  procedure MapLine;
  procedure MapCode(Command: byte);
  procedure MapAddr(Addr: TAddress);
  procedure MapLen(Len: integer);
  procedure MapPos(Pos: integer);
  procedure MapFunc(ID: string);

type
  PText = ^Text;

var
  MapFile: TStrings;
  MapCM: TCodeManager;
  LabelIdx: longint;
{$ENDIF}

implementation

{$IFDEF DOMAP}

var
  MapStr: string = '';

  procedure Map(Value: string);

  begin { Map }
    MapStr := MapStr + Value;
  end;  { Map }

  procedure MapLine;

  begin { MapLine }
    MapFile.Add(MapStr);
    MapStr := '';
  end;  { MapLine }

{TransOff}
  function TypeKindStr(TypeKind: TTypeKind): string;

  begin { TypeKindStr }
    Case TypeKind of
      tkBoolean: Result := 'bol';
      tkShortint: Result := 'sht';
      tkByte: Result := 'byt';
      tkSmallint: Result := 'sml';
      tkWord: Result := 'wrd';
      tkInteger: Result := 'int';
      tkSingle: Result := 'sng';
      tkDouble: Result := 'dbl';
      tkExtended: Result := 'ext';
      tkCurrency: Result := 'cur';
      tkChar: Result := 'chr';
      tkString: Result := 'str';
      tkPointer: Result := 'ptr';
      tkComplex: Result := 'cpx';
    end; { case }
  end;  { TypeKindStr }

  function OpKindStr(OpKind: TOpKind): string;

  begin { OpKindStr }
    Case OpKind of
      okTerm: Result := ';';
      okAssign: Result := ':=';
      okAddAssign: Result := '+=';
      okSubAssign: Result := '-=';
      okMulAssign: Result := '*=';
      okDivAssign: Result := '/=';
      okEQ: Result := '=';
      okNE: Result := '<>';
      okLT: Result := '<';
      okGT: Result := '>';
      okLE: Result := '<=';
      okGE: Result := '>=';
      okIS: Result := 'is';
      okAdd: Result := '+';
      okSub: Result := '-';
      okOR: Result := 'or';
      okXOR: Result := 'xor';
      okMul: Result := '*';
      okDiv: Result := '/';
      okIDiv: Result := 'div';
      okMod: Result := 'mod';
      okAND: Result := 'and';
      okSHL: Result := 'shl';
      okSHR: Result := 'shr';
      okAs: Result := 'as';
      okPos: Result := 'u+';
      okNeg: Result := 'u-';
      okNOT: Result := 'not';
      okLeftAssign: Result := '<-';
      okRightAssign: Result := '->';
      okFunction: Result := 'func';
      okMethod: Result := 'meth';
    end; { case }
  end;  { OpKindStr }

  function CommandStr(Command: byte): string;

  begin { CommandStr }
    Case Command of
      RAVEPUSHADDR: Result := 'RAVEPUSHADDR';
      RAVEPUSHMETHODADDR: Result := 'RAVEPUSHMETHODADDR';
      RAVEPUSHVAR: Result := 'RAVEPUSHVAR';
      RAVEPUSHDATA: Result := 'RAVEPUSHDATA';
      RAVEPUSHCONST: Result := 'RAVEPUSHCONST';
      RAVEPUSHSTR: Result := 'RAVEPUSHSTR';
      RAVEPUSHMETHODSTR: Result := 'RAVEPUSHMETHODSTR';
      RAVEPUSHDEFAULT: Result := 'RAVEPUSHDEFAULT';
      RAVEPOP: Result := 'RAVEPOP';
      RAVEENTER: Result := 'RAVEENTER';
      RAVECOPYPARAMDATA: Result := 'RAVECOPYPARAMDATA';
      RAVECOPYPARAMSTR: Result := 'RAVECOPYPARAMSTR';
      RAVECOPYPARAMDATADEF: Result := 'RAVECOPYPARAMDATADEF';
      RAVECOPYPARAMSTRDEF: Result := 'RAVECOPYPARAMSTRDEF';
      RAVEFREESTR: Result := 'RAVEFREESTR';
      RAVEFREEREC: Result := 'RAVEFREEREC';
      RAVELOADVAR: Result := 'RAVELOADVAR';
      RAVELOADDATA: Result := 'RAVELOADDATA';
      RAVERETURN: Result := 'RAVERETURN';
      RAVERETURNRES: Result := 'RAVERETURNRES';
      RAVECALL: Result := 'RAVECALL';
      RAVECALLEXTERNALFUNC: Result := 'RAVECALLEXTERNALFUNC';
      RAVECALLEXTERNALPROC: Result := 'RAVECALLEXTERNALPROC';
      RAVELONGCALL: Result := 'RAVELONGCALL';
      RAVEJUMPEQ: Result := 'RAVEJUMPEQ';
      RAVEJUMPNE: Result := 'RAVEJUMPNE';
      RAVEJUMPLT: Result := 'RAVEJUMPLT';
      RAVEJUMPLE: Result := 'RAVEJUMPLE';
      RAVEJUMPGT: Result := 'RAVEJUMPGT';
      RAVEJUMPGE: Result := 'RAVEJUMPGE';
      RAVEJUMP: Result := 'RAVEJUMP';
      RAVELONGJUMP: Result := 'RAVELONGJUMP';
      RAVEEQBOL: Result := 'RAVEEQBOL';
      RAVENEBOL: Result := 'RAVENEBOL';
      RAVELTBOL: Result := 'RAVELTBOL';
      RAVEGTBOL: Result := 'RAVEGTBOL';
      RAVELEBOL: Result := 'RAVELEBOL';
      RAVEGEBOL: Result := 'RAVEGEBOL';
      RAVEEQINT: Result := 'RAVEEQINT';
      RAVENEINT: Result := 'RAVENEINT';
      RAVELTINT: Result := 'RAVELTINT';
      RAVEGTINT: Result := 'RAVEGTINT';
      RAVELEINT: Result := 'RAVELEINT';
      RAVEGEINT: Result := 'RAVEGEINT';
      RAVEEQEXT: Result := 'RAVEEQEXT';
      RAVENEEXT: Result := 'RAVENEEXT';
      RAVELTEXT: Result := 'RAVELTEXT';
      RAVEGTEXT: Result := 'RAVEGTEXT';
      RAVELEEXT: Result := 'RAVELEEXT';
      RAVEGEEXT: Result := 'RAVEGEEXT';
      RAVEEQCUR: Result := 'RAVEEQCUR';
      RAVENECUR: Result := 'RAVENECUR';
      RAVELTCUR: Result := 'RAVELTCUR';
      RAVEGTCUR: Result := 'RAVEGTCUR';
      RAVELECUR: Result := 'RAVELECUR';
      RAVEGECUR: Result := 'RAVEGECUR';
      RAVEEQCHR: Result := 'RAVEEQCHR';
      RAVENECHR: Result := 'RAVENECHR';
      RAVELTCHR: Result := 'RAVELTCHR';
      RAVEGTCHR: Result := 'RAVEGTCHR';
      RAVELECHR: Result := 'RAVELECHR';
      RAVEGECHR: Result := 'RAVEGECHR';
      RAVEEQSTR: Result := 'RAVEEQSTR';
      RAVENESTR: Result := 'RAVENESTR';
      RAVELTSTR: Result := 'RAVELTSTR';
      RAVEGTSTR: Result := 'RAVEGTSTR';
      RAVELESTR: Result := 'RAVELESTR';
      RAVEGESTR: Result := 'RAVEGESTR';
      RAVEORBOL: Result := 'RAVEORBOL';
      RAVEXORBOL: Result := 'RAVEXORBOL';
      RAVEANDBOL: Result := 'RAVEANDBOL';
      RAVEADDINT: Result := 'RAVEADDINT';
      RAVESUBINT: Result := 'RAVESUBINT';
      RAVEMULINT: Result := 'RAVEMULINT';
      RAVEDIVINT: Result := 'RAVEDIVINT';
      RAVEMODINT: Result := 'RAVEMODINT';
      RAVEORINT: Result := 'RAVEORINT';
      RAVEXORINT: Result := 'RAVEXORINT';
      RAVEANDINT: Result := 'RAVEANDINT';
      RAVESHLINT: Result := 'RAVESHLINT';
      RAVESHRINT: Result := 'RAVESHRINT';
      RAVEADDEXT: Result := 'RAVEADDEXT';
      RAVESUBEXT: Result := 'RAVESUBEXT';
      RAVEMULEXT: Result := 'RAVEMULEXT';
      RAVEDIVEXT: Result := 'RAVEDIVEXT';
      RAVEADDCUR: Result := 'RAVEADDCUR';
      RAVESUBCUR: Result := 'RAVESUBCUR';
      RAVEMULCUR: Result := 'RAVEMULCUR';
      RAVEDIVCUR: Result := 'RAVEDIVCUR';
      RAVENOTBOL: Result := 'RAVENOTBOL';
      RAVENOTINT: Result := 'RAVENOTINT';
      RAVENEGINT: Result := 'RAVENEGINT';
      RAVENEGEXT: Result := 'RAVENEGEXT';
      RAVENEGCUR: Result := 'RAVENEGCUR';
      RAVESHT2INT: Result := 'RAVESHT2INT';
      RAVEBYT2INT: Result := 'RAVEBYT2INT';
      RAVESML2INT: Result := 'RAVESML2INT';
      RAVEWRD2INT: Result := 'RAVEWRD2INT';
      RAVEINT2SHT: Result := 'RAVEINT2SHT';
      RAVEINT2BYT: Result := 'RAVEINT2BYT';
      RAVEINT2SML: Result := 'RAVEINT2SML';
      RAVEINT2WRD: Result := 'RAVEINT2WRD';
      RAVEINT2SNG: Result := 'RAVEINT2SNG';
      RAVEINT2DBL: Result := 'RAVEINT2DBL';
      RAVEINT2EXT: Result := 'RAVEINT2EXT';
      RAVEINT2CUR: Result := 'RAVEINT2CUR';
      RAVESHT2EXT: Result := 'RAVESHT2EXT';
      RAVEBYT2EXT: Result := 'RAVEBYT2EXT';
      RAVESML2EXT: Result := 'RAVESML2EXT';
      RAVEWRD2EXT: Result := 'RAVEWRD2EXT';
      RAVESNG2EXT: Result := 'RAVESNG2EXT';
      RAVEDBL2EXT: Result := 'RAVEDBL2EXT';
      RAVECUR2EXT: Result := 'RAVECUR2EXT';
      RAVEEXT2SNG: Result := 'RAVEEXT2SNG';
      RAVEEXT2DBL: Result := 'RAVEEXT2DBL';
      RAVEEXT2CUR: Result := 'RAVEEXT2CUR';
      RAVECHR2STR: Result := 'RAVECHR2STR';
      RAVEDOUBLECONV: Result := 'RAVEDOUBLECONV';
      RAVEASSIGN: Result := 'RAVEASSIGN';
      RAVELEFTASSIGN: Result := 'RAVELEFTASSIGN';
      RAVERIGHTASSIGN: Result := 'RAVERIGHTASSIGN';
      RAVEASSIGNSTR: Result := 'RAVEASSIGNSTR';
      RAVELEFTASSIGNSTR: Result := 'RAVELEFTASSIGNSTR';
      RAVERIGHTASSIGNSTR: Result := 'RAVERIGHTASSIGNSTR';
      RAVEADDINTASSIGN: Result := 'RAVEADDINTASSIGN';
      RAVESUBINTASSIGN: Result := 'RAVESUBINTASSIGN';
      RAVEMULINTASSIGN: Result := 'RAVEMULINTASSIGN';
      RAVEADDEXTASSIGN: Result := 'RAVEADDEXTASSIGN';
      RAVESUBEXTASSIGN: Result := 'RAVESUBEXTASSIGN';
      RAVEMULEXTASSIGN: Result := 'RAVEMULEXTASSIGN';
      RAVEDIVEXTASSIGN: Result := 'RAVEDIVEXTASSIGN';
      RAVEADDCURASSIGN: Result := 'RAVEADDCURASSIGN';
      RAVESUBCURASSIGN: Result := 'RAVESUBCURASSIGN';
      RAVEMULCURASSIGN: Result := 'RAVEMULCURASSIGN';
      RAVEDIVCURASSIGN: Result := 'RAVEDIVCURASSIGN';
      RAVEBEGINFORTO: Result := 'RAVEBEGINFORTO';
      RAVEBEGINFORDOWNTO: Result := 'RAVEBEGINFORDOWNTO';
      RAVEENDFOR: Result := 'RAVEENDFOR';
      RAVELOOPTEST: Result := 'RAVELOOPTEST';
      RAVEIFTEST: Result := 'RAVEIFTEST';
      RAVENOP: Result := 'RAVENOP';
      RAVETERMINATE: Result := 'RAVETERMINATE';
      RAVEADDSTR: Result := 'RAVEADDSTR';
      RAVEBREAKPOINT: Result := 'RAVEBREAKPOINT';
      else Result := 'UNKNOWN(' + IntToStr(Command) + ')';
    end; { case }
  end;  { CommandStr }

const
  BoolStr: array[false..true] of string = ('false','true');

  procedure MapConstant(CodeListItem: PCodeListItem);

  begin { MapConstant }
    With CodeListItem^ do begin
      If ToType is TEnumeratedType then begin
        Map('enum[' + IntToStr(byte(Data^)) + ']');
      end else begin
        Case FromType.TypeKind of
          tkBoolean: Map(BoolStr[boolean(Data^)]);
          tkInteger: Map(IntToStr(integer(Data^)));
          tkExtended: Map(FloatToStr(extended(Data^)));
          tkCurrency: Map('$' + CurrToStr(currency(Data^)));
          tkChar: Map('''' + char(Data^) + '''');
          tkString: Map('''' + StringData + '''');
        end; { case }
      end; { else }
    end; { with }
  end;  { MapConstant }

  procedure MapCodeList(Name: string;
                        CodeList: TRaveStackList);

  var
    I1: integer;
    I2: integer;
    S1: string;

  begin { MapCodeList }
  { Debug - Output code list }
    MapLine;
    Map(Name + '-----------------');
    For I1 := 0 to CodeList.Count - 1 do begin
      MapLine;
      Map('  ' + IntToStr(I1 + 1) + ':');
      With PCodeListItem(CodeList[I1])^ do begin
        Case Kind of
          idkVar: begin
            If DefaultParam then begin
              Map('  DefParam ');
              MapAddr((VarID as TVarID).Address);
            end else if FuncResult then begin
              Map('  V(FuncResult) ');
            end else begin
              Map('  V(' + VarID.ID + ') ');
              MapAddr((VarID as TVarID).Address);
            end; { else }
          end;
          idkFunc: begin
            Map('  Func - Oplist: ');
            For I2 := 0 to OpList.Count - 1 do begin
              Map(IntToStr(CodeList.IndexOf(OpList[I2]) + 1) + ' ');
            end; { for }
          end;
          idkMethod: begin
            Map('  Method - Oplist: ');
            For I2 := 0 to OpList.Count - 1 do begin
              Map(IntToStr(CodeList.IndexOf(OpList[I2]) + 1) + ' ');
            end; { for }
          end;
          idkOp: begin
            Map('  O(' + OpKindStr(OpKind) + ') Oplist: ');
            For I2 := 0 to OpList.Count - 1 do begin
              Map(IntToStr(CodeList.IndexOf(OpList[I2]) + 1) + ' ');
            end; { for }
          end;
          idkConst: begin
            Map('  C(');
            MapConstant(PCodeListItem(CodeList[I1]));
            Map(') ');
          end;
        end; { case }
        If Assigned(FromType) then begin
          S1 := TypeKindStr(FromType.TypeKind);
        end else begin
          S1 := 'non';
        end; { else }
        Map(' Type(' + S1 + ':');
        If Assigned(ToType) then begin
          S1 := TypeKindStr(ToType.TypeKind);
        end else begin
          S1 := 'non';
        end; { else }
        Map(S1 + ') ');
        Map('Temp(' + IntToStr(TempSize) + ') ');
        Map(' Loc(' + IntToStr(Line) + ':' + IntToStr(Col) + ')');
      end; { with }
    end; { for }
    MapLine;
  end;  { MapCodeList }

  procedure MapOpStack(OpStack: TRaveStackList);

  var
    I1: integer;

  begin { MapOpStack }
  { Debug - Output code list }
    MapLine;
    Map('Op Stack Begin-----------------');
    For I1 := 0 to OpStack.Count - 1 do begin
      MapLine;
      Map('  ' + IntToStr(I1 + 1) + ':');
      With POpStackItem(OpStack[I1])^ do begin
        Map(' Lvl:' + IntToStr(Level) + ' ' + OpKindStr(Kind) + ' Pre:' + IntToStr(Order) +
         ' Loc(' + IntToStr(OpLine) + ':' + IntToStr(OpCol) + ') ' + OpToken);
      end; { with }
    end; { for }
    Map('Op Stack End-------------------');
  end;  { MapOpStack }

  procedure MapArray(ArrayType: TArrayType);

  var
    I1: integer;
    ArraySize: longint;

  begin { MapArray }
    ArraySize := ArrayType.ElementType.Size;
    MapLine;
    Map('New Array [');
    For I1 := 0 to (ArrayType.Dims - 1) do begin
      ArraySize := ArraySize * (ArrayType.High[I1] - ArrayType.Low[I1] + 1);
      If I1 > 0 then begin
        Map(',');
      end; { if }
      Map(IntToStr(ArrayType.Low[I1]) + '..' + IntToStr(ArrayType.High[I1]));
    end; { for }
    Map('] (' + IntToStr(ArraySize) + ' bytes)');
  end;  { MapArray }

  procedure MapCode(Command: byte);

  begin { MapCode }
    MapLine;
    Map('  ' + IntToStr(MapCM.CodeSize) + ': ' + CommandStr(Command) + ' ');
  end;  { MapCode }

  procedure MapAddr(Addr: TAddress);

  begin { MapAddr }
    Case Addr.Loc of
      alBP: Map('BP[');
      alSP: Map('SP[');
      alDS: Map('DS[' + IntToStr(Addr.Module) + ':');
    end; { case }

    Map(IntToStr(Addr.Offset) + '] ');
  end;  { MapAddr }

  procedure MapLen(Len: integer);

  begin { MapLen }
    Map('Len=' + IntToStr(Len) + ' ');
  end;  { MapLen }

  procedure MapPos(Pos: integer);

  begin { MapPos }
    Map('Pos=' + IntToStr(Pos) + ' ');
  end;  { MapPos }

  procedure MapFunc(ID: string);

  begin { MapFunc }
    MapLine;
    Map('------------------------------------------------------------');
    MapLine;
    Map('Function ' + ID);
    MapLine;
    Map('------------------------------------------------------------');
  end;  { MapFunc }

initialization
  LabelIdx := 0;
{$ENDIF}
end.

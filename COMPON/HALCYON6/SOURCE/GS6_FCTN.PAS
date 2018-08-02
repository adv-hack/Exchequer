unit gs6_fctn;
interface
uses
  {$IFDEF LINUX}
  Variants,
  {$ELSE}
     {$IFDEF VER140}
     Variants,
     {$ENDIF}
  {$ENDIF}
SysHalc, SysUtils, Math, gs6_glbl, gs6_cnst, gs6_date, gs6_sql;

implementation

const
   DefStrLen   = 10;
   EmptyDate   = 1E100;
   DateDescendMax = 5231808;

{===========================================================================}
{                         Halcyon xBase Functions                           }
{===========================================================================}

type



   TgsUDFDate = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFDescend = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFDOW = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFDTOC = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFDegToRad = class(TgsUserDefFunction)
      function FunctionName: string; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFDTOS = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFEmpty = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFFloor = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

type
   TgsUDFFutureValue = class(TgsUserDefFunction)
      function FunctionName: string; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFIIF = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFInlist = class(TgsUserDefFunction)
      function FunctionName: string; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFInt = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFLeft = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFLen = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFLower = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFLTrim = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFMax = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFMin = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFMod = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFPadMain = class(TgsUserDefFunction)
      PadChar: gsUTFChar;
      PadSize: integer;
      PadText: gsUTFString;
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

         TgsUDFPadC = class(TgsUDFPadMain)
            function FunctionName: gsUTFString; override;
            procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                                    var ExpResult: TgsExpResultType); override;
         end;

         TgsUDFPadL = class(TgsUDFPadMain)
            function FunctionName: gsUTFString; override;
            procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                                    var ExpResult: TgsExpResultType); override;
         end;

         TgsUDFPadR = class(TgsUDFPadMain)
            function FunctionName: gsUTFString; override;
            procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                                    var ExpResult: TgsExpResultType); override;
         end;

   TgsUDFPi = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFProper = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFRight = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFRadToDeg = class(TgsUserDefFunction)
      function FunctionName: string; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFSin = class(TgsUserDefFunction)
      function FunctionName: string; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFSoundex = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFSpace = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFStr = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

         TgsUDFStrZero = class(TgsUDFStr)
            function FunctionName: gsUTFString; override;
            procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                            var ExpResult: TgsExpResultType); override;
         end;

   TgsUDFStrTran = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFSubStr = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFTan = class(TgsUserDefFunction)
      function FunctionName: string; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsUDFTrim = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

         TgsUDFRTrim = class(TgsUDFTrim)
            function FunctionName: gsUTFString; override;
         end;

    TgsUDFUpper = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

    TgsUDFVal = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;


{---------------------------------------------------------------------------
                          Globally Defined Variables
----------------------------------------------------------------------------}
type
   TgsSDVTrue = class(TgsUserDefFieldVar)
   public
      procedure FieldVarResult(var Buffer: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsSDVFalse = class(TgsUserDefFieldVar)
   public
      procedure FieldVarResult(var Buffer: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgsSDVPi = class(TgsUserDefFieldVar)
   public
      procedure FieldVarResult(var Buffer: variant;
                      var ExpResult: TgsExpResultType); override;
   end;


procedure TgsSDVTrue.FieldVarResult(var Buffer: variant; var ExpResult: TgsExpResultType);
begin
   ExpResult := rtBoolean;
   Buffer := true;
end;

procedure TgsSDVFalse.FieldVarResult(var Buffer: variant; var ExpResult: TgsExpResultType);
begin
   ExpResult := rtBoolean;
   Buffer := false;
end;

procedure TgsSDVPi.FieldVarResult(var Buffer: variant; var ExpResult: TgsExpResultType);
begin
   ExpResult := rtFloat;
   Buffer := Pi;
end;




{---------------------------------------------------------------------------
                             Absolute() Function
----------------------------------------------------------------------------}
type
   TgsUDFAbsolute = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

function TgsUDFAbsolute.FunctionName: gsUTFString;
begin
   FunctionName := 'ABS';
end;

procedure TgsUDFAbsolute.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
  r: TgsExpResultType;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   BufVar := abs(BufVar);
end;

{---------------------------------------------------------------------------
                             AllTrim() Function
----------------------------------------------------------------------------}
type
   TgsUDFAllTrim = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

function TgsUDFAllTrim.FunctionName: string;
begin
   FunctionName := 'ALLTRIM';
end;

procedure TgsUDFAllTrim.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   s: string;
   r: TgsExpResultType;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   s := BufVar;
   BufVar := Trim(s);
end;

{---------------------------------------------------------------------------
                             ArcCos() Function
----------------------------------------------------------------------------}
type
   TgsUDFArcCos = class(TgsUserDefFunction)
      function FunctionName: string; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

function TgsUDFArcCos.FunctionName: string;
begin
   FunctionName := 'ACOS';
end;

procedure TgsUDFArcCos.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   if abs(BufVar) > 1 then
     raise EHalcyonExpression.CreateFmt(gsErrArgRange,['ACOS','-1 to +1']);
   BufVar := ArcCos(BufVar);
end;

{---------------------------------------------------------------------------
                             ArcSin() Function
----------------------------------------------------------------------------}
type
   TgsUDFArcSin = class(TgsUserDefFunction)
      function FunctionName: string; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

function TgsUDFArcSin.FunctionName: string;
begin
   FunctionName := 'ASIN';
end;

procedure TgsUDFArcSin.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   if abs(BufVar) > 1 then
     raise EHalcyonExpression.CreateFmt(gsErrArgRange,['ASIN','-1 to +1']);
   BufVar := ArcSin(BufVar);
end;

{---------------------------------------------------------------------------
                             ArcTan() Function
----------------------------------------------------------------------------}
type
   TgsUDFArcTan = class(TgsUserDefFunction)
      function FunctionName: string; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

function TgsUDFArcTan.FunctionName: string;
begin
   FunctionName := 'ATAN';
end;

procedure TgsUDFArcTan.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   BufVar := ArcTan(BufVar);
end;

{---------------------------------------------------------------------------
                             ArcTan2() Function
----------------------------------------------------------------------------}
type
   TgsUDFArcTan2 = class(TgsUserDefFunction)
      function FunctionName: string; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

function TgsUDFArcTan2.FunctionName: string;
begin
   FunctionName := 'ATN2';
end;

procedure TgsUDFArcTan2.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   x: Extended;
   y: extended;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   x := BufVar;
   Caller.FetchArg(1, BufVar, r, rtFloat);
   y := BufVar;
   BufVar := ArcTan2(x,y);
end;

{---------------------------------------------------------------------------
                              ASC() Function
----------------------------------------------------------------------------}
type
   TgsUDFAsc = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

function TgsUDFAsc.FunctionName: gsUTFString;
begin
   FunctionName := 'ASC';
end;

procedure TgsUDFAsc.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   s: gsUTFString;
   r: TgsExpResultType;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtText);
   if length(s) = 0 then s := #0;
   BufVar := ord(s[1]);
end;

{---------------------------------------------------------------------------
                             At() Function
----------------------------------------------------------------------------}
type
   TgsUDFAt = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

function TgsUDFAt.FunctionName: gsUTFString;
begin
   FunctionName := 'AT';
end;

procedure TgsUDFAt.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   d: integer;
   p: integer;
   t: integer;
   w: floatnum;
   s1: gsUTFString;
   s2: gsUTFString;
begin
   ExpResult := rtFloat;
   d := 1;
   t := 0;
   Caller.FetchArg(0, BufVar, r, rtText);
   s1 := BufVar;
   Caller.FetchArg(1, BufVar, r, rtText);
   s2 := BufVar;
   Caller.FetchArg(2, BufVar, r, rtAny);
   if r = rtFloat then
   begin
      w := BufVar;
      d := trunc(w);
   end;
   while d > 0 do
   begin
      p := Pos(s1,s2);
      if p > 0 then
      begin
         t := t + p;
         s2 := copy(s2,p+1,length(s2));
         dec(d);
      end
      else
      begin
         d := 0;
      end;
   end;
   BufVar := t;
end;

{---------------------------------------------------------------------------
                             AtC() Function
----------------------------------------------------------------------------}
type
   TgsUDFAtC = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

function TgsUDFAtC.FunctionName: gsUTFString;
begin
   FunctionName := 'ATC';
end;

procedure TgsUDFAtC.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   d: integer;
   p: integer;
   t: integer;
   w: floatnum;
   s1: gsUTFString;
   s2: gsUTFString;
begin
   ExpResult := rtFloat;
   d := 1;
   t := 0;
   Caller.FetchArg(0, BufVar, r, rtText);
   s1 := BufVar;
   s1 := UpperCase(s1);
   Caller.FetchArg(1, BufVar, r, rtText);
   s2 := BufVar;
   s2 := UpperCase(s2);
   Caller.FetchArg(2, BufVar, r, rtAny);
   if r = rtFloat then
   begin
      w := BufVar;
      d := trunc(w);
   end;
   while d > 0 do
   begin
      p := Pos(s1,s2);
      if p > 0 then
      begin
         t := t + p;
         s2 := copy(s2,p+1,length(s2));
         dec(d);
      end
      else
      begin
         d := 0;
      end;
   end;
   BufVar := t;
end;

{---------------------------------------------------------------------------
                             Between() Function
----------------------------------------------------------------------------}
type
   TgsUDFBetween = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

function TgsUDFBetween.FunctionName: gsUTFString;
begin
   FunctionName := 'BETWEEN';
end;

procedure TgsUDFBetween.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   x: TgsExpResultType;
   v1: variant;
   v2: variant;
   v3: variant;
   b: boolean;
begin
   ExpResult := rtBoolean;
   Caller.FetchArg(0, BufVar, x, rtAny);
   v1 := BufVar;
   Caller.FetchArg(1, BufVar, r, x);
   v2 := BufVar;
   Caller.FetchArg(2, BufVar, r, x);
   v3 := BufVar;
   b := (v1 >= v2) and (v1 <= v3);
   BufVar := b;
end;

{---------------------------------------------------------------------------
                             Ceiling() Function
----------------------------------------------------------------------------}
type
   TgsUDFCeiling = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

function TgsUDFCeiling.FunctionName: gsUTFString;
begin
   FunctionName := 'CEILING';
end;

procedure TgsUDFCeiling.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   f: FloatNum;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   f := BufVar;
   f := ceil(f);
   BufVar := f;
end;

{---------------------------------------------------------------------------
                             Chr() Function
----------------------------------------------------------------------------}
type
   TgsUDFChr = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

function TgsUDFChr.FunctionName: gsUTFString;
begin
   FunctionName := 'CHR';
end;

procedure TgsUDFChr.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   d: integer;
   c: gsUTFChar;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   d := BufVar;
   if (d < 0) or (d > 255) then
      raise EHalcyonExpression.CreateFMT(gsErrArgInvalid,['Byte']);
   c := chr(d);
   BufVar := c;
end;

{---------------------------------------------------------------------------
                               Cos() Function
----------------------------------------------------------------------------}
type
   TgsUDFCosine = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

function TgsUDFCosine.FunctionName: string;
begin
   FunctionName := 'COS';
end;

procedure TgsUDFCosine.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   BufVar := Cos(BufVar);
end;

{---------------------------------------------------------------------------
                             CTOD() Function
----------------------------------------------------------------------------}
type
   TgsUDFCTOD = class(TgsUserDefFunction)
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

function TgsUDFCTOD.FunctionName: gsUTFString;
begin
   FunctionName := 'CTOD';
end;

procedure TgsUDFCTOD.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   f: FloatNum;
   r: TgsExpResultType;
   j: longint;
   rtneeded: TgsExpResultType;
   s: gsUTFString;
begin
   ExpResult := rtDate;
   rtneeded := rtText;
   Caller.FetchArg(0, BufVar, r, rtneeded);
   s := BufVar;
   if length(s) = 0 then
      f := EmptyDate
   else
   begin
      j := DBFDate.CTOD(s);
      f := j;
   end;
   BufVar := f;
end;

{---------------------------------------------------------------------------
                             Date() Function
----------------------------------------------------------------------------}

function TgsUDFDate.FunctionName: gsUTFString;
begin
   FunctionName := 'DATE';
end;

procedure TgsUDFDate.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   d: longint;
begin
   ExpResult := rtDate;
   d := DBFDate.Date;
   BufVar := d;
end;

{---------------------------------------------------------------------------
                             Descend() Function
----------------------------------------------------------------------------}

function TgsUDFDescend.FunctionName: gsUTFString;
begin
   FunctionName := 'DESCEND';
end;

procedure TgsUDFDescend.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   s: gsUTFString;
   i: integer;
   b: boolean;
begin
   Caller.FetchArg(0, BufVar, r, rtAny);
   ExpResult := r;
   if r in [rtDate..rtDateTime] then
   begin
      if BufVar <> EmptyDate then
         BufVar := DateDescendMax-BufVar;
   end
   else
      if r in [rtFloat..rtInteger] then
      begin
         if BufVar <> 0.0 then
            BufVar := -BufVar;
      end
      else
         if r = rtText then
         begin
            s := BufVar;
            for i := 1 to length(s) do
            begin
               s[i] := chr(-ord(s[i]));
            end;
         end
         else
            if r = rtBoolean then
            begin
               b := BufVar;
               b := not b;
               BufVar := b;
            end
            else
               BufVar := false;
end;

{---------------------------------------------------------------------------
                              DOW() Function
----------------------------------------------------------------------------}

function TgsUDFDOW.FunctionName: gsUTFString;
begin
   FunctionName := 'DOW';
end;

procedure TgsUDFDOW.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   f: FloatNum;
   r: TgsExpResultType;
   j: longint;
   rtneeded: TgsExpResultType;
   d: FloatNum;
   i: integer;
begin
   ExpResult := rtFloat;
   rtneeded := rtDate;
   Caller.FetchArg(0, BufVar, r, rtneeded);
   f := BufVar;
   if f <> EmptyDate then
   begin
      j := trunc(f);
      i := DBFDate.DOW(j);
      d := i;
   end
   else
      d := 0;
   BufVar := d;
end;

{---------------------------------------------------------------------------
                             DTOC() Function
----------------------------------------------------------------------------}

function TgsUDFDTOC.FunctionName: gsUTFString;
begin
   FunctionName := 'DTOC';
end;

procedure TgsUDFDTOC.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   f: FloatNum;
   r: TgsExpResultType;
   j: longint;
   rtneeded: TgsExpResultType;
   s: gsUTFString;
   l: integer;
begin
   ExpResult := rtText;
   rtneeded := rtDate;
   Caller.FetchArg(0, BufVar, r, rtneeded);
   f := BufVar;
   if f <> EmptyDate then
   begin
      j := trunc(f);
      Caller.FetchArg(1, BufVar, r, rtAny);
      if r = rtFloat then
      begin
         l := BufVar;
      end
      else
      begin
         l := 0;
      end;
      if l = 1 then
         s := DBFDate.DTOS(j)
      else
         s := DBFDate.DTOC(j);
   end
   else
      s := DBFDate.DTOC(0);
   BufVar := s;
end;

{---------------------------------------------------------------------------
                             DegToRad() Function
----------------------------------------------------------------------------}

function TgsUDFDegToRad.FunctionName: string;
begin
   FunctionName := 'DTOR';
end;

procedure TgsUDFDegToRad.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   BufVar := DegToRad(BufVar);
end;

{---------------------------------------------------------------------------
                             DTOS() Function
----------------------------------------------------------------------------}

function TgsUDFDTOS.FunctionName: gsUTFString;
begin
   FunctionName := 'DTOS';
end;

procedure TgsUDFDTOS.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   f: FloatNum;
   r: TgsExpResultType;
   j: longint;
   rtneeded: TgsExpResultType;
   s: gsUTFString;
begin
   ExpResult := rtText;
   rtneeded := rtDate;
   Caller.FetchArg(0, BufVar, r, rtneeded);
   f := BufVar;
   if f <> EmptyDate then
   begin
      j := trunc(f);
      s := DBFDate.DTOS(j);
   end
   else
      s := '        ';
   BufVar := s;
end;

{---------------------------------------------------------------------------
                             Empty() Function
----------------------------------------------------------------------------}

function TgsUDFEmpty.FunctionName: gsUTFString;
begin
   FunctionName := 'EMPTY';
end;

procedure TgsUDFEmpty.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   s: gsUTFString;
   i: integer;
   rtneeded: TgsExpResultType;
begin
   ExpResult := rtBoolean;
   rtneeded := rtAny;
   Caller.FetchArg(0, BufVar, r, rtneeded);
   if r in [rtDate..rtDateTime] then
   begin
      if (BufVar = EmptyDate) or (BufVar = 0) then
         BufVar := true
      else
         BufVar := false;
   end
   else
      if r in [rtFloat..rtInteger] then
      begin
         if (BufVar = 0.0) then
            BufVar := true
         else
            BufVar := false;
      end
      else
         if r = rtText then
         begin
            s := BufVar;
            i := length(s);
            while (i > 0) and (s[i] = ' ') do dec(i);
            if i = 0 then
               BufVar := true
            else
               BufVar := false;
         end
         else
            if r = rtBoolean then
            begin
               BufVar := not BufVar;
            end
            else
               BufVar := false;
end;

{---------------------------------------------------------------------------
                             Floor() Function
----------------------------------------------------------------------------}

function TgsUDFFloor.FunctionName: gsUTFString;
begin
   FunctionName := 'FLOOR';
end;

procedure TgsUDFFloor.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   f: FloatNum;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   f := floor(BufVar);
   BufVar := f;
end;

{---------------------------------------------------------------------------
                             FutureValue() Function
----------------------------------------------------------------------------}

function TgsUDFFutureValue.FunctionName: string;
begin
   FunctionName := 'FV';
end;

procedure TgsUDFFutureValue.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   rt: extended;
   pv: extended;
   py: extended;
   n: integer;
   t: integer;
begin
   ExpResult := rtFloat;
   pv := 0;
   t := 0;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   py := BufVar;
   Caller.FetchArg(1, BufVar, r, rtFloat);
   rt := BufVar;
   Caller.FetchArg(2, BufVar, r, rtFloat);
   n := trunc(BufVar);
   Caller.FetchArg(3, BufVar, r, rtAny);
   if r <> rtEmpty then
   begin
      pv := BufVar;
      Caller.FetchArg(4, BufVar, r, rtAny);
      if r <> rtEmpty then
      begin
         t := trunc(BufVar);
         if abs(t) > 1 then
            raise EHalcyonExpression.CreateFmt(gsErrArgRange,['FV PaymentTime','0 or 1']);
      end;
   end;
   BufVar := abs(FutureValue(rt,n,py,pv,TPaymentTime(t)));
end;

{---------------------------------------------------------------------------
                             IIF() Function
----------------------------------------------------------------------------}

function TgsUDFIIF.FunctionName: gsUTFString;
begin
   FunctionName := 'IIF';
end;

procedure TgsUDFIIF.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
begin
   ExpResult := rtEmpty;
   Caller.FetchArg(0, BufVar, r, rtBoolean);
   if BufVar then
      Caller.FetchArg(1,BufVar, ExpResult, rtAny)
   else
      Caller.FetchArg(2,BufVar, ExpResult, rtAny);
end;

{---------------------------------------------------------------------------
                             Inlist() Function
----------------------------------------------------------------------------}

function TgsUDFInlist.FunctionName: string;
begin
   FunctionName := 'INLIST';
end;

procedure TgsUDFInlist.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   v1: variant;
   v2: variant;
   i: integer;
   mtch: boolean;
   fini: boolean;
begin
   ExpResult := rtBoolean;                     {Returns text in Buffer}
   Caller.FetchArg(0, BufVar, r, rtAny);   {Get first argument in function}
   if r = rtEmpty then
   begin
      BufVar := false;
      exit;
   end;
   v1 := BufVar;
   if VarType(v1) = varString then v1 := TrimRight(v1);
   mtch := false;
   i := 1;
   repeat
      Caller.FetchArg(i, BufVar, r, rtAny);  {Get next argument in function}
      fini := r = rtEmpty;
      if not fini then
      begin
         v2 := BufVar;
         mtch := v1 = v2;
         fini := mtch;
         inc(i);
      end;
   until fini;
   BufVar := mtch;
end;

{---------------------------------------------------------------------------
                             Int() Function
----------------------------------------------------------------------------}

function TgsUDFInt.FunctionName: gsUTFString;
begin
   FunctionName := 'INT';
end;

procedure TgsUDFInt.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   f: FloatNum;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   f := BufVar;
   f := int(f);
   BufVar := f;
end;

{---------------------------------------------------------------------------
                             Left() Function
----------------------------------------------------------------------------}

function TgsUDFLeft.FunctionName: gsUTFString;
begin
   FunctionName := 'LEFT';
end;

procedure TgsUDFLeft.FunctionResult(Caller: TgsExpFunction;
           var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   d: Cardinal;
   s: gsUTFString;
   w: floatnum;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   s := BufVar;
   Caller.FetchArg(1, BufVar, r, rtFloat);
   w := BufVar;
   if w <= 0.01 then
      d := 0
   else
      d := trunc(w);
   BufVar := Copy(s,1,d);
end;

{---------------------------------------------------------------------------
                             Len() Function
----------------------------------------------------------------------------}

function TgsUDFLen.FunctionName: gsUTFString;
begin
   FunctionName := 'LEN';
end;

procedure TgsUDFLen.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   i: integer;
   r: TgsExpResultType;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtText);
   i := Length(BufVar);
   BufVar := i;
end;

{---------------------------------------------------------------------------
                             Log10() Function
----------------------------------------------------------------------------}
type
   TgsUDFLog = class(TgsUserDefFunction)
      function FunctionName: string; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

function TgsUDFLog.FunctionName: string;
begin
   FunctionName := 'LOG';
end;

procedure TgsUDFLog.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   if BufVar <=0 then
     raise EHalcyonExpression.CreateFmt(gsErrArgRange,['LOG10','> 0']);
   BufVar := Ln(BufVar);
end;

{---------------------------------------------------------------------------
                             Log10() Function
----------------------------------------------------------------------------}
type
   TgsUDFLog10 = class(TgsUserDefFunction)
      function FunctionName: string; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

function TgsUDFLog10.FunctionName: string;
begin
   FunctionName := 'LOG10';
end;

procedure TgsUDFLog10.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   if BufVar <=0 then
     raise EHalcyonExpression.CreateFmt(gsErrArgRange,['LOG10','> 0']);

   BufVar := Log10(BufVar);
end;

{---------------------------------------------------------------------------
                             Lower() Function
----------------------------------------------------------------------------}

function TgsUDFLower.FunctionName: gsUTFString;
begin
   FunctionName := 'LOWER';
end;

procedure TgsUDFLower.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   BufVar := gsStrLowerCase(BufVar);
end;

{---------------------------------------------------------------------------
                             LTrim() Function
----------------------------------------------------------------------------}

function TgsUDFLTrim.FunctionName: gsUTFString;
begin
   FunctionName := 'LTRIM';
end;

procedure TgsUDFLTrim.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   s: gsUTFString;
   r: TgsExpResultType;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   s := BufVar;
   BufVar := TrimLeft(s);
end;

{---------------------------------------------------------------------------
                                Max() Function
----------------------------------------------------------------------------
}

function TgsUDFMax.FunctionName: string;
begin
   FunctionName := 'MAX';
end;

procedure TgsUDFMax.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   rtneeded: TgsExpResultType;
   v1, v2: variant;
   i: integer;
begin
   rtneeded := rtAny;
   Caller.FetchArg(0, BufVar, r, rtneeded);
   if (r = rtEmpty) then
      raise EHalcyonExpression.CreateFMT(gsErrArgEmpty,['Max()']);
   rtneeded := r;
   v1 := BufVar;
   i := 1;
   repeat
      Caller.FetchArg(i, BufVar, r, rtAny);
      inc(i);
      if r <> rtEmpty then
      begin
         if (r <> rtneeded) then
            raise EHalcyonExpression.CreateFMT(gsErrArgNotSame,['Max()']);
         v2 := BufVar;
         if v2 > v1 then v1 := v2;
      end;
   until r = rtEmpty;
   BufVar := v1;
   ExpResult := rtneeded;
end;

{---------------------------------------------------------------------------
                                Min() Function
----------------------------------------------------------------------------
}

function TgsUDFMin.FunctionName: string;
begin
   FunctionName := 'MIN';
end;

procedure TgsUDFMin.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   rtneeded: TgsExpResultType;
   v1, v2: variant;
   i: integer;
begin
   rtneeded := rtAny;
   Caller.FetchArg(0, BufVar, r, rtneeded);
   if (r = rtEmpty) then
      raise EHalcyonExpression.CreateFMT(gsErrArgEmpty,['Min()']);
   rtneeded := r;
   v1 := BufVar;
   i := 1;
   repeat
      Caller.FetchArg(i, BufVar, r, rtAny);
      inc(i);
      if r <> rtEmpty then
      begin
         if (r <> rtneeded) then
            raise EHalcyonExpression.CreateFMT(gsErrArgNotSame,['Min()']);
         v2 := BufVar;
         if v2 < v1 then v1 := v2;
      end;
   until r = rtEmpty;
   BufVar := v1;
   ExpResult := rtneeded;
end;

{---------------------------------------------------------------------------
                                Mod() Function
----------------------------------------------------------------------------}

function TgsUDFMod.FunctionName: gsUTFString;
begin
   FunctionName := 'MOD';
end;

procedure TgsUDFMOD.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   x: FloatNum;
   y: Floatnum;
   z: Floatnum;
   i: integer;
   j: integer;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   x := BufVar;
   Caller.FetchArg(1, BufVar, r, rtFloat);
   y := BufVar;
   i := trunc(x);
   j := trunc(y);
   z := i mod j;
   BufVar := z;
end;

{---------------------------------------------------------------------------
                             PadMain() Function
----------------------------------------------------------------------------}

function TgsUDFPadMain.FunctionName: gsUTFString;
begin
   FunctionName := '';
end;

procedure TgsUDFPadMain.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   isvalid: boolean;
begin
   ExpResult := rtText;
   Caller.FetchArg(2, BufVar, r, rtAny);
   case r of
      rtEmpty : begin
                   PadChar := ' ';
                   isvalid := true;
                end;
      rtText  : begin
                   PadText := BufVar;
                   if Length(PadText) = 1 then
                   begin
                      PadChar := PadText[1];
                      isvalid := true;
                   end
                      else isvalid := false;
                end;
      else      isvalid := false;
   end;
   if not isvalid then
      raise EHalcyonExpression.CreateFMT(gsErrArgInvalid,['Char']);
   Caller.FetchArg(0, BufVar, r, rtAny);
   if r = rtEmpty then
      raise EHalcyonExpression.CreateFmt(gsErrArgValueNeeded,['Value',1,'Pad']);
   PadText := BufVar;
   Caller.FetchArg(1, BufVar, r, rtFloat);
   PadSize := BufVar;
end;

{---------------------------------------------------------------------------
                             PadC() Function
----------------------------------------------------------------------------}

function TgsUDFPadC.FunctionName: gsUTFString;
begin
   FunctionName := 'PADC';
end;

procedure TgsUDFPadC.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   i: integer;
   v: integer;
   p: PChar;
begin
   inherited FunctionResult(Caller, BufVar, ExpResult);
   i := Length(PadText);
   if i < PadSize then
   begin
      p := AllocMem(PadSize+1);
      FillChar(p[0],PadSize,PadChar);
      v := (PadSize - i) div 2;
      Move(PadText[1],p[v], i);
      BufVar := StrPas(p);
      FreeMem(p);
   end
   else
      BufVar := PadText;
end;

{---------------------------------------------------------------------------
                             PadL() Function
----------------------------------------------------------------------------}

function TgsUDFPadL.FunctionName: gsUTFString;
begin
   FunctionName := 'PADL';
end;

procedure TgsUDFPadL.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   i: integer;
   v: integer;
   p: PChar;
begin
   inherited FunctionResult(Caller, BufVar, ExpResult);
   i := Length(PadText);
   if i < PadSize then
   begin
      p := AllocMem(PadSize+1);
      FillChar(p[0],PadSize,PadChar);
      v := (PadSize - i);
      if i > 0 then Move(PadText[1],p[v], i);
      BufVar := StrPas(p);
      FreeMem(p);
   end
   else
      BufVar := PadText;
end;

{---------------------------------------------------------------------------
                             PadR() Function
----------------------------------------------------------------------------}

function TgsUDFPadR.FunctionName: gsUTFString;
begin
   FunctionName := 'PADR';
end;

procedure TgsUDFPadR.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   i: integer;
   p: PChar;
begin
   inherited FunctionResult(Caller, BufVar, ExpResult);
   i := Length(PadText);
   if i < PadSize then
   begin
      p := AllocMem(PadSize+1);
      FillChar(p[0],PadSize,PadChar);
      if i > 0 then Move(PadText[1],p[0], i);
      BufVar := StrPas(p);
      FreeMem(p);
   end
   else
      BufVar := PadText;
end;

{---------------------------------------------------------------------------
                               Pi() Function
----------------------------------------------------------------------------}

function TgsUDFPi.FunctionName: gsUTFString;
begin
   FunctionName := 'PI';
end;

procedure TgsUDFPi.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType); 
begin
   ExpResult := rtFloat;
   BufVar := Pi;
end;

{---------------------------------------------------------------------------
                             PresentValue() Function
----------------------------------------------------------------------------}
type
   TgsUDFPresentValue = class(TgsUserDefFunction)
      function FunctionName: string; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

function TgsUDFPresentValue.FunctionName: string;
begin
   FunctionName := 'PV';
end;

procedure TgsUDFPresentValue.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   rt: extended;
   pv: extended;
   py: extended;
   n: integer;
   t: integer;
begin
   ExpResult := rtFloat;
   pv := 0;
   t := 0;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   py := BufVar;
   Caller.FetchArg(1, BufVar, r, rtFloat);
   rt := BufVar;
   Caller.FetchArg(2, BufVar, r, rtFloat);
   n := trunc(BufVar);
   Caller.FetchArg(3, BufVar, r, rtAny);
   if r <> rtEmpty then
   begin
      pv := BufVar;
      Caller.FetchArg(4, BufVar, r, rtAny);
      if r <> rtEmpty then
      begin
         t := trunc(BufVar);
         if abs(t) > 1 then
            raise EHalcyonExpression.CreateFmt(gsErrArgRange,['FV PaymentTime','0 or 1']);
      end;
   end;
   BufVar := abs(PresentValue(rt,n,py,pv,TPaymentTime(t)));
end;

{---------------------------------------------------------------------------
                             Proper() Function
----------------------------------------------------------------------------}

function TgsUDFProper.FunctionName: gsUTFString;
begin
   FunctionName := 'PROPER';
end;

procedure TgsUDFProper.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   s: gsUTFString;
   su: gsUTFString;
   sl: gsUTFString;
   sp: gsUTFString;
   i: integer;
   chl: gsUTFChar;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   s := BufVar;
   su := gsStrUpperCase(s);
   sl := gsStrLowerCase(s);
   sp := '';
   chl := #0;
   for i := 1 to Length(s) do
   begin
      if chl in [#0,#$20..#$26,#$28..#$2F,#$3A..#$40,#$5B..#$5F,#$7B..#$7F] then
         sp := sp + su[i]
      else
         sp := sp + sl[i];
      chl := sp[i];
   end;
   BufVar := sp;
end;

{---------------------------------------------------------------------------
                             Right() Function
----------------------------------------------------------------------------}

function TgsUDFRight.FunctionName: gsUTFString;
begin
   FunctionName := 'RIGHT';
end;

procedure TgsUDFRight.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType); 
var
   r: TgsExpResultType;
   d: integer;
   l: integer;
   v: integer;
   s: gsUTFString;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   s := BufVar;
   Caller.FetchArg(1, BufVar, r, rtFloat);
   d := trunc(BufVar);
   v := Length(s);
   if d < v then
   begin
      if d < 0 then
         d := 0;
      if d > 0 then
      begin
         l := v-d;
         s := copy(s,l+1,d);
      end;
   end;
   BufVar := s;
end;

{---------------------------------------------------------------------------
                             RadToDeg() Function
----------------------------------------------------------------------------}

function TgsUDFRadToDeg.FunctionName: string;
begin
   FunctionName := 'RTOD';
end;

procedure TgsUDFRadToDeg.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType); 
var
   r: TgsExpResultType;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   BufVar := RadToDeg(BufVar);
end;

{---------------------------------------------------------------------------
                             RTrim() Function
----------------------------------------------------------------------------}

function TgsUDFRTrim.FunctionName: gsUTFString;
begin
   FunctionName := 'RTRIM';
end;

{---------------------------------------------------------------------------
                             Sin() Function
----------------------------------------------------------------------------}

function TgsUDFSin.FunctionName: string;
begin
   FunctionName := 'SIN';
end;

procedure TgsUDFSin.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType); 
var
   r: TgsExpResultType;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   BufVar := Sin(BufVar);
end;

{---------------------------------------------------------------------------
                             Soundex() Function
----------------------------------------------------------------------------}

function TgsUDFSoundex.FunctionName: gsUTFString;
begin
   FunctionName := 'SOUNDEX';
end;

procedure TgsUDFSoundex.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType); 
var
   r: TgsExpResultType;
   len: integer;
   C1: integer;
   s: gsUTFString;
   s1: gsUTFString;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   s := BufVar;
   len := Length(s);
   if len > 0 then
   begin
      s := UpperCase(s);
      if len > 1 then
      begin
         s1 := s[1];
         for C1 := 2 to len do
         begin
            {Assign a numeric value to each letter, except the first}
            case s[C1] of
               'B','F','P','V'                : s1 := s1 + '1';
               'C','G','J','K','Q','S','X','Z': s1 := s1 + '2';
               'D','T'                        : s1 := s1 + '3';
               'L'                            : s1 := s1 + '4';
               'M','N'                        : s1 := s1 + '5';
               'R'                            : s1 := s1 + '6';
               {All other letters, punctuation and numbers are ignored}
            end;
         end;
         {Go through the result, and remove any consecutive numeric values
          that are duplicates}
         s := s1[1];
         for C1 := 2 to len do
         begin
            if (s1[C1] <> s1[C1-1]) then
               s := s + s1[C1];
         end;
      end;
      {Maximum Soundex Length is 4, pad if less, then truncate}
   end;
   s := s + '0000';
   s := Copy(s,1,4);
   BufVar := s;
end;

{---------------------------------------------------------------------------
                             Space() Function
----------------------------------------------------------------------------}

function TgsUDFSpace.FunctionName: gsUTFString;
begin
   FunctionName := 'SPACE';
end;

procedure TgsUDFSPACE.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType); 
var
   r: TgsExpResultType;
   f: FloatNum;
   l: integer;
   s: gsUTFString;
begin
   ExpResult := rtText;          {27 Jul 99}
   Caller.FetchArg(0, BufVar, r, rtFloat);
   f := BufVar;
   l := trunc(f);
   SetLength(s,l);
   FillChar(s[1],l,' ');
   BufVar := s;
end;

{---------------------------------------------------------------------------
                             Str() Function
----------------------------------------------------------------------------}

function TgsUDFStr.FunctionName: gsUTFString;
begin
   FunctionName := 'STR';
end;

procedure TgsUDFStr.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType); 
var
   f: FloatNum;
   r: TgsExpResultType;
   l: integer;
   d: integer;
   h: integer;
   s: gsUTFString;
   t: TgsExpUserLink;
begin
   ExpResult := rtText;
   d := 0;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   f := BufVar;
   Caller.FetchArg(1, BufVar, r, rtAny);
   if r = rtFloat then
   begin
      l := BufVar;
      Caller.FetchArg(2, BufVar, r, rtAny);
      if r = rtFloat then
      begin
         d := BufVar;
      end;
   end
   else
   begin
      l := DefStrLen;
      t := Caller.FetchUser;
      if t <> nil then
      begin
         h := t.DefaultStrSize;
         if h > 0 then
            l := h;
      end;
   end;
   str(f:l:d,s);
   if Length(s) > l then
   begin
      s := '';
      while length(s) < l do s := s + '*';
   end;
   BufVar := s;
end;

{---------------------------------------------------------------------------
                             StrTran() Function
----------------------------------------------------------------------------}

function TgsUDFStrTran.FunctionName: gsUTFString;
begin
   FunctionName := 'STRTRAN';
end;

procedure TgsUDFStrTran.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType); 
var
   r: TgsExpResultType;
   d: integer;
   v: integer;
   p: integer;
   src: gsUTFString;
   ptn: gsUTFString;
   rpl: gsUTFString;
   rsl: gsUTFString;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   src := BufVar;
   if src = '' then
   begin
      BufVar := '';
      exit;
   end;
   Caller.FetchArg(1, BufVar, r, rtText);
   ptn := BufVar;
   if ptn = '' then
   begin
      BufVar := src;
      exit;
   end;
   Caller.FetchArg(2, BufVar, r, rtAny);
   if r = rtText then
      rpl := BufVar
   else
      rpl := '';
   Caller.FetchArg(3, BufVar, r, rtAny);
   if r = rtFloat then
      v := trunc(BufVar)
   else
      v := 1;
   Caller.FetchArg(4, BufVar, r, rtAny);
   if r = rtFloat then
      d := trunc(BufVar)
   else
      d := MaxInt;
   rsl := '';
   p := 1;
   while (p <> 0) and (d > 0) do
   begin
      p := AnsiPos(ptn, src);
      if p > 0 then
      begin
         dec(v);
         if v < 1 then
         begin
            dec(d);
            rsl := rsl + copy(src,1,p-1);
            rsl := rsl + rpl;
         end
         else
         begin
            rsl := rsl + copy(src,1,p+Length(ptn)-1);
         end;
         src := copy(src,p+Length(ptn),MaxInt);
      end;
   end;
   rsl := rsl + src;
   BufVar := rsl;
end;

{---------------------------------------------------------------------------
                             StrZero() Function
----------------------------------------------------------------------------}

function TgsUDFStrZero.FunctionName: gsUTFString;
begin
   FunctionName := 'STRZERO';
end;

procedure TgsUDFStrZero.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   i: integer;
   s: gsUTFString;
begin
   inherited FunctionResult(Caller, BufVar, ExpResult);
   i := 1;
   s := BufVar;

   while (i <= length(s)) and (s[i] = ' ') do
   begin
      s[i] := '0';
      inc(i);
   end;
   BufVar := s;
end;

{---------------------------------------------------------------------------
                             SubStr() Function
----------------------------------------------------------------------------}

function TgsUDFSubStr.FunctionName: gsUTFString;
begin
   FunctionName := 'SUBSTR';
end;

procedure TgsUDFSubStr.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   l: integer;
   d: integer;
   v: integer;
   s: gsUTFString;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   s := BufVar;
   Caller.FetchArg(1, BufVar, r, rtFloat);
   l := trunc(BufVar);
   v := length(s);
   if (l > v) or (l = 0) then
   begin
      s := '';
   end
   else
   begin
      Caller.FetchArg(2, BufVar, r, rtAny);
      if r = rtFloat then
         d := trunc(BufVar)
      else
         d := v;
      v := (v-l) + 1;
      if d > v then d := v;
      if d = 0 then
         s := ''
      else
         s := copy(s,l,d);
   end;
   BufVar := s;
end;

{---------------------------------------------------------------------------
                             Tan() Function
----------------------------------------------------------------------------}

function TgsUDFTan.FunctionName: string;
begin
   FunctionName := 'TAN';
end;

procedure TgsUDFTan.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType); 
var
   r: TgsExpResultType;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtFloat);
   BufVar := Tan(BufVar);
end;

{---------------------------------------------------------------------------
                             Trim() Function
----------------------------------------------------------------------------}

function TgsUDFTrim.FunctionName: gsUTFString;
begin
   FunctionName := 'TRIM';
end;

procedure TgsUDFTrim.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType); 
var
   s: gsUTFString;
   r: TgsExpResultType;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   s := BufVar;
   s := TrimRight(s);
   BufVar := s;
end;

{---------------------------------------------------------------------------
                             Upper() Function
----------------------------------------------------------------------------}

function TgsUDFUpper.FunctionName: gsUTFString;
begin
   FunctionName := 'UPPER';
end;

procedure TgsUDFUpper.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   BufVar := gsStrUpperCase(BufVar);
end;

{---------------------------------------------------------------------------
                             Val() Function
----------------------------------------------------------------------------}

function TgsUDFVal.FunctionName: gsUTFString;
begin
   FunctionName := 'VAL';
end;

procedure TgsUDFVal.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   f: FloatNum;
   s: gsUTFString;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtText);
   s := BufVar;
   if length(BufVar) > 0 then
      try
         f := StrToFloat(s);
      except
         f := 0;
      end
   else
      f := 0;
   BufVar := f;
end;


{------------------------------------------------------------------------------
                           Setup and Exit Routines
------------------------------------------------------------------------------}

initialization
   GSVariableRegistry := TgsFieldVarReg.Create;
   GSFunctionRegistry := TgsFunctionReg.Create;

   GSVariableRegistry.RegisterFieldVar(TgsSDVTrue.Create('TRUE'));
   GSVariableRegistry.RegisterFieldVar(TgsSDVFalse.Create('FALSE'));
   GSVariableRegistry.RegisterFieldVar(TgsSDVPi.Create('PI'));

   GSFunctionRegistry.RegisterFunction(TgsUDFAbsolute.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFAllTrim.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFArcCos.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFArcSin.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFArcTan.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFArcTan2.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFAsc.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFAt.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFAtC.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFBetween.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFCeiling.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFChr.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFCosine.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFCTOD.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFDate.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFDescend.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFDOW.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFDTOC.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFDegToRad.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFDTOS.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFEmpty.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFFloor.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFFutureValue.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFIIF.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFInlist.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFInt.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFLeft.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFLen.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFLog.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFLog10.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFLower.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFLTrim.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFMax.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFMin.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFMod.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFPadC.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFPadL.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFPadR.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFPi.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFPresentValue.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFProper.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFRight.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFRTrim.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFRadToDeg.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFSin.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFSoundex.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFSpace.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFStr.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFStrTran.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFStrZero.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFSubStr.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFTan.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFTrim.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFUpper.Create);
   GSFunctionRegistry.RegisterFunction(TgsUDFVal.Create);

   Randomize;

finalization
   GSFunctionRegistry.Free;
   GSVariableRegistry.Free;

end.

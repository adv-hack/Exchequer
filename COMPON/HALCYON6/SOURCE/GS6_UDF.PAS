unit gs6_udf;
{-----------------------------------------------------------------------------
                          User-Defined Functions

       gs6_udf Copyright (c) 1999 Griffin Solutions, Inc.

       Date
          15 September 1999

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit handles the user-defined functions for expressions in gs6_sql.
       Place this unit name in the Uses clause of your project to implement.
       However, you will not be able to use the index in DesignTime, since
       your UDF will not be in the DesignTime library.

       To be able to use your UDFs at DesignTime, go into the package editor
       and add the unit, then compile and install.

       You will want to create your own unit name so that it will not be
       overwritten by gs6_udf.pas in future installs.  Any unit name is ok as
       long as you use it consistently in your projects and in the package
       editor.

       The example function in this unit in ByLen().

              ByLen(fieldstring,len)

       This function will return a string with the first 4 characters
       representing the length of fieldstring. Len determines how many
       characters are returned in addition to the four length bytes.  For
       example, "ByLen('Hello World',3)" would return "0011Hel".

       This example is for demonstration only, and is not the most effective
       way to write the routine.

       The UDF calls return the result in a variant that is passed as one of the
       arguments in the call. 

       Examine the functions in gs6_sql.pas for more examples of how to
       handle function calls.

   Changes:
------------------------------------------------------------------------------}
interface
uses SysUtils, gs6_sql;

implementation

type
   TgsUDFByLen = class(TgsUserDefFunction)
      function FunctionName: string; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

{---------------------------------------------------------------------------
                             ByLen() Function
----------------------------------------------------------------------------}

function TgsUDFByLen.FunctionName: string;
begin
   FunctionName := 'BYLEN';
end;

procedure TgsUDFByLen.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   su: string;
   st: string;
   sl: integer;
   v: integer;
   f: double;
begin
   ExpResult := rtText;                     {Returns text in Buffer}
   Caller.FetchArg(0, BufVar, r, rtText);   {Get first argument in function
                                             (string to convert), type is text}
   su := BufVar;             {Save to string}
   su := TrimRight(su);                     {and trim trailing spaces}
   Caller.FetchArg(1, BufVar, r, rtFloat);  {Get second argument in function
                                            (output size), type is float}
   f := BufVar;                             {copy Buffer to type double var}
   v := trunc(f);                           {convert to integer}
   if v < 0 then v := 0;                    {ensure length is not negative}
   sl := length(su);
   st := IntToStr(sl);
   while length(st) < 4 do st := '0'+st;
   if length(su) > v then                   {control max output length}
      su := copy(su,1,v)
   else
      while length(su) < v do su := su + ' ';
   su := st+su;                             {store length as first 4 bytes}
   BufVar := su;                            {Store string for specified length}
end;

initialization
   GSFunctionRegistry.RegisterFunction(TgsUDFByLen.Create);
end.

unit gs6_sql;
{-----------------------------------------------------------------------------
                          Basic Expression Resolver

       gs6_sql Copyright (c) 1998 Griffin Solutions, Inc.

       Date
          4 Mar 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit evaluates expressions and returns the result.

   Changes:

------------------------------------------------------------------------------}
interface
uses
  {$IFDEF LINUX}
   Variants,
  {$ELSE}
     {$IFDEF VER140}
     Variants,
     {$ENDIF}
  {$ENDIF}
   SysHalc,
   SysUtils,
   Classes,
   Math,
   gs6_cnst,
   gs6_tool,
   gs6_date,
   gs6_glbl;

type
   TgsExpressionType  = (etUnknown, etAbsorbed, etContainer, etOperator,
                           etFunction, etFieldVar, etTextLit, etNumLit,
                           etDateLit, etBlnLit, etVariable);

   TgsExpResultType   = (rtUnknown, rtEmpty, rtAny, rtText, rtFloat, rtInteger,
                           rtDate, rtDateTime, rtBoolean, rtMemo, rtPointer);

   TgsExpHandler = class;
   TgsExpFunction = class;

   TgsUserDefFunction = class(TObject)
   (*An object of TgsUserDefFunction is created for each function registered in
     the expression handler.  This class provides the actual code to handle the
     specific function calculation.*)
   public
      function FunctionName: gsUTFString; virtual;
      (*Returns the function name of the owner of this object.  The result string
        is typically used in the search for the name of a function assigned in an
        expression.*)

      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                              var ExpResult: TgsExpResultType); virtual;
      (*This method is used to return the results expected for this specific
        function.  The function return value is placed in Buffer.  The resut
        type is returned in ExpResult.  A result of true is returned upon the
        successful completion of the calculation.*)
   end;

   TgsUserDefFieldVar = class(TObject)
   (*An object of TgsUserDefFieldVar is created for each variable registered in
     the expression handler.  This class provides the actual code to return the
     variable value to the expression handler.*)
   private
      FName: gsUTFString;
      FVarLen: integer;
      FDescendents: boolean;
      FReference: integer;
   public
      constructor Create(const AName: gsUTFString);
      (*Creates an instance of the class TgsUserDefFieldVar for the variable AName.*)

      destructor Destroy; override;
      (*Releases memory allocated for the variable name string and frees the class.*)

      function FieldVarList: gsUTFString; virtual;
      (*Returns the complete variable list of the owner of this object.  The result
        string will contain all references separated by a';'.  The variable list
        will have all names used to identify the variable.  Typically this is
        useful for a database field that can be identified by fieldname or by
        table.fieldname.*)

      function FieldVarName: gsUTFString; virtual;
      (*Returns the variable name of the owner of this object.  The result string
        is typically used in the search for the name of a variable assigned in an
        expression.*)

      function FieldVarType: integer; virtual;
      (*Returns the variable type of the owner of this object.  The result integer
        default is 0.  Descendants will pass their own type for use in enumerating
        a list of specific variable types (for example, for database fields) of a
        variable assigned in an expression.*)

      procedure FieldVarResult(var BufVar: variant;
                              var ExpResult: TgsExpResultType); virtual;
      (*This method is used to return the results expected for this specific
        variable.  The variable return value is placed in Buffer.  The resut
        type is returned in ExpResult.  A result of true is returned upon the
        successful retrieval of the variable.*)

      property VarLength: integer read FVarLen write FVarLen;
      (*Property returns the fixed length for a numeric field.  This is needed
        when several numeric fields are combined to determine the size of a result
        string of the value.  Used internally for numeric fields*)
      property Descendents: boolean read FDescendents write FDescendents;
      property Reference: integer read FReference write FReference;
   end;

   TgsFunctionReg = class(TStringList)
   (*Container class for TgsUserDefFunction objects.  Used to access each of
     the objects by reference to its Index value.*)
   public
      constructor Create;
      destructor Destroy; override;
      (*Frees all TgsUserDefFunction objects contained in the list.*)

      function RegisterFunction(AFunction: TgsUserDefFunction): boolean;
      (*Adds the TgsUserDefFunction object to the end of the list.  Returns
        true if successful.*)

      function FunctionName(Index: integer): gsUTFString;
      (*Returns the name of the TgsUserDefFunction object stored at Index in the
        list.  Returns an empty string if the Index is not valid.*)

      function FunctionLink(Index: integer): TgsUserDefFunction;
      (*Returns The pointer to the TgsUserDefFunction object stored at Index in
        the list.  Returns nil if the index is not valid.*)
   end;

   TgsFieldVarReg = class(TStringList)
   (*Container class for TgsUserDefFieldVar objects.  Used to access each of
     the objects by reference to its Index value.*)
   public
      constructor Create;
      destructor Destroy; override;
      (*Frees all TgsUserDefFieldVar objects contained in the list.*)

      function RegisterFieldVar(AFieldVar: TgsUserDefFieldVar): boolean;
      (*Adds the TgsUserDefFieldVar object to the end of the list.  Returns
        true if successful.*)

      function FieldVarName(Index: integer): gsUTFString;
      (*Returns the name of the TgsUserDefFieldVar object stored at Index in the
        list.  Returns an empty string if the Index is not valid.*)

      function FieldVarType(Index: integer): integer;
      (*Returns the variable type of the TgsUserDefFieldVar object stored at
        Index in the list.  Returns zero if the Index is not valid.*)

      function FieldVarLink(Index: integer): TgsUserDefFieldVar;
      (*Returns The pointer to the TgsUserDefFieldVar object stored at Index in
        the list.  Returns nil if the index is not valid.*)
   end;

   TgsExpUserLink = class(TObject)
   (*Handler class to manage user-registered functions and variables.*)
   private
      UserFunctionRegistry: TgsFunctionReg;
      UserFieldVarRegistry: TgsFieldVarReg;
      FStrSize: integer;
   public
      constructor Create;
      (*Creates a TgsExpUserLink instance and allocates TgsFunctionReg and
        TgsFieldVar containers to hold function and variable objects.*)

      destructor Destroy; override;
      (*Frees the TgsFunctionReg and TgsFieldVar containers that were used to
        hold function and variable objects.*)

      function FindFunction(const AFunction: gsUTFString): TgsUserDefFunction; virtual;
      (*Searches the TgsFunctionRef container to find a function name to match
        AFunction.  Returns the pointer to the function if found, otherwise it
        returns nil.*)

      function FindFieldVar(const AFieldVar: gsUTFString): TgsUserDefFieldVar; virtual;
      (*Searches the TgsFieldVarReg container to find a variable name to match
        AFieldVar.  Returns the pointer to the variable function if found,
        otherwise it returns nil.*)

      function RegisterFunction(AFunction: TgsUserDefFunction): boolean;
      (*Registers a user function in the TgsFunctionRef container.  Returns true
        if successful.*)

      function RegisterFieldVar(AFieldVar: TgsUserDefFieldVar): boolean;
      (*Registers a user variable in the TgsFieldVarRef container.  Returns true
        if successful.*)

      function OnNoFunction(const AFunction: gsUTFString): TgsUserDefFunction; virtual;

      property DefaultStrSize: integer read FStrSize write FStrSize;
      (*Returns the default string length used for Str functions when the
        length argument is not provided.  The internal default is 10 characters.*)
   end;

   TgsExpBaseObject = class(TObject)
   (*Base object class for all espression process classes.  Expression process
     classes are those such as TgsExpFunction that handles processing functions,
     TgsExpOperator that handle operator actions (+,-,*,/,and,or,not), and
     literal classes such as TgsTextLit, TgsDateLit,TgsBlnLit, and TgsNumLit
     that hold constant values.*)
   private
      FExpType     : TgsExpressionType;
      FResultType  : TgsExpResultType;
      FExpChg      : Boolean;
      FExpLen      : integer;
      FExpDec      : integer;
      FArgLeft     : TgsExpBaseObject;
      FArgRight    : TgsExpBaseObject;
   public
      constructor  Create;
                   (*Initializes internal values.*)

      destructor   Destroy; override;
      (*Frees expression process classes this object owns.*)

      function     ExpObjectContains: gsUTFString; virtual;
      (*Returns the function/variable name, literal, or operator assigned to
        this object.*)

      function     ExpObjectType: integer; virtual;
      (*Returns the type of the object linked to this object.  Can be used to
        determine the kind of link (database, local, etc)*)

      function     ExpRebuildExpression: gsUTFString; virtual;
      (*Reconstructs the expression by calling ExpObjectContains for all the
        FArgLeft and FArgRight expression processes and properly formating
        those strings with its own ExpObjectContains string.*)

      function     ExpEnumTypes(AType: integer): gsUTFString; virtual;

      procedure    ExpParse(var BufVar: variant;
                            var ExpResult: TgsExpResultType); virtual;
     (*Retrieves the calculated values for all subordinate expression processes
       and places the final calculated result in Buffer.  The Result Type is
       placed in ExpResult.  If successful, address of Buffer is returned as the
       result, otherwise nil is returned.*)
   end;

   TgsExpContainer = Class(TgsExpBaseObject)
   (*Holder class that contains a grouped collection of expression elements
     that were enclosed in parentheses.  This object is then passed as the
     left or right argument of an operator.*)
   public
      constructor   Create(AOwner: TgsExpHandler; const AValue: gsUTFString);
      (*Creates a holder object that contains the expression elements in AValue.
        This class is allocated as the original expression is generated and part
        of the expression is contained in parends.  For example, if the
        expression 1+2*(3+4)-5 was assigned to the expression handler, it would
        send the (3+4) to a TgsExpContainer object, where it would be processed.
        Then, the expression handler would deal only with this object when it
        needed to calculate the result: 1+2*object-5.  Note that when Avalue is
        processed, it may generate TgsExpContainer or TgsExpFunction objects
        owned by this object if there are parend groups or functions inside AValue.*)

      function      ExpRebuildExpression: gsUTFString; override;
      (*Reconstructs the expression by calling ExpObjectContains for the
        FArgLeft and FArgRight expression processes and properly formating those
        strings with its own ExpObjectContains string.  This string is enclosed
        in parends and returned.*)

      function     ExpEnumTypes(AType: integer): gsUTFString; override;

      procedure    ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType); override;
      (*Retrieves the calculated values for all subordinate expression processes
        and places the final calculated result in Buffer.  The Result Type is
        placed in ExpResult.  If successful, address of Buffer is returned as
        the result, otherwise nil is returned.*)
   end;

   TgsExpFunction = Class(TgsExpBaseObject)
   (*Holder class for a function.  This class will link to the correct function
     and handle assembling the function argument list.*)
   private
      FOwner        : TgsExpHandler;
      FUDF          : TgsUserDefFunction;
      FArgList      : TList;
   protected
   public
      constructor   Create(AOwner: TgsExpHandler; const AValue: gsUTFString);
      (*Creates a holder object that contains the function expression in AValue.
        This class is allocated as the original expression is generated and part
        of the expression is identified as a function.  An argument list is
        allocated to hold the expression processes that constitute the arguments
        for the function.  For example, if the expression PadR('Hello',9)+'World'
        was assigned to the expression handler, it would send the PadR('Hello',9)
        to a TgsExpFunction object, where it would be processed. The function
        for PadR (a descendant of TgsUserDefFunction) would be located and saved
        in this object.  First, the system functions would be searched for a
        match with AValue. If this is unsuccessful, the UserLink of the owner
        expression handler in AOwner is searched. If the function is not found,
        an exception is raised.  The expression processes for 'Hello" and 9
        would be stored in the object's argument list. Then, the expression
        handler would deal only with this object when it needed to calculate the
        result: object+'World'.  Note that when Avalue is processed, it may
        generate TgsExpContainer or TgsExpFunction objects owned by this object
        if there are parend groups or functions inside AValue.*)

      destructor    Destroy; override;
      (*Frees the argument list created for this function.*)

      function      ExpObjectContains: gsUTFString; override;
      (*Returns the name of the function linked to this object.*)

      function      ExpRebuildExpression: gsUTFString; override;
      (*Reconstructs the expression by calling ExpObjectContains for each of the
        argument list expression processes and properly formating those strings
        with its own ExpObjectContains string to construct the complete function
        string.*)

      function     ExpEnumTypes(AType: integer): gsUTFString; override;

      procedure    ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType); override;
      (*Calls the TgsUserDefFunction.ExpParse method of the function linked to
        this object. The final calculated result is returned in Buffer.  The
        Result Type is returned in ExpResult. If successful, address of Buffer
        is returned as the result, otherwise nil is returned.*)

     procedure      FetchArg(Index: integer; var BufVar: variant;
                       var ExpResult: TgsExpResultType;
                       ExpResultNeeded: TgsExpResultType);
     (*Method that is called by the TgsUserDefFunction.ExpParse method of the
       function linked to this object to retrieve the argument located at Index.
       If Index is valid, the ExpParse method of the expression process in the
       argument list is called.  If the returned ExpResult result is not equal
       to ExpResultNeeded or rtAny, an exception is raised.  If successful, the
       result is returned in Buffer and the result type is returned in ExpResult.*)
       
      function      FetchUser: TgsExpUserLink;
   end;

   TgsExpFieldvar = Class(TgsExpBaseObject)
   (*Holder class for a variable.  A variable can be any value generated by the
     user application.  Database fields are considered variables and can be
     retrieved through this object type.*)
   private
      FOwner        : TgsExpHandler;
      FUDF          : TgsUserDefFieldVar;
   protected
      function      FetchUser: TgsExpUserLink;
   public
      constructor   Create(AOwner: TgsExpHandler; const AValue: gsUTFString);
      (*Creates a holder object that contains the variable expression in AValue.
        This class is allocated as the original expression is generated and part
        of the expression is identified as a variable.  The variable expression
        process (a descendant of TgsUserDefFieldVar) would be located and saved
        in this object by searching the UserLink of the owner expression handler
        in AOwner.  If the variable is not found, an exception is raised.*)

      function      ExpObjectContains: gsUTFString; override;
      (*Returns the name of the variable linked to this object.*)

      function      ExpObjectType: integer; override;
      (*Returns the type of the variable linked to this object.  Can be used to
        determine the kind of link (database, local, etc)*)

      procedure    ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType); override;
      (*Calls the TgsUserDefFieldVar.ExpParse method of the variable linked to
        this object. The result is returned in Buffer. The Result Type is
        returned in ExpResult.*)
   end;

   TgsExpOperator = Class(TgsExpBaseObject)
   (*Holder class for an operator.  The operator can be for numeric, relational,
     or string concatenation operations*)
   private
      FOperator     : gsUTFChar;
      FPrecedence   : gsUTFChar;
      FInsensitive  : boolean;
      FWildCards    : boolean;
      FWildCharAll  : gsUTFChar;
      FWildCharOne  : gsUTFChar;
   protected
      function StrWCComp(vStr1, vStr2 : variant): Integer;
   public
      constructor   Create(AOperator, APrecedence: char);
      (*Creates the holder class for the operator identified in AOperator.
        The precedence of the operator is saved using the value of APrecedence.
        This determines the order in which operations are sequenced.*)

      function      ExpObjectContains: gsUTFString; override;
      (*Returns the symbol of the operator linked to this object.*)

      procedure    ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType); override;
      (*Calls ExpParse for the FArgLeft and FArgRight expression processes and
      then acts based on the operator and places the final calculated result in
      Buffer.  The Result Type is placed in ExpResult.  If the operation cannot
      be done on the two arguments, an exception is raised*)
   end;

   TgsExpTextLit = Class(TgsExpBaseObject)
   (*Holder class for a text literal.*)
   private
      FExpValue     : gsUTFString;
   public
      constructor   Create(const AValue: gsUTFString);
      (*Creates a holder object that contains the literal text value in AValue.
        This class is allocated as the original expression is generated and part
        of the expression is identified as a text literal.*)

      destructor    Destroy; override;
      (*Frees the memory allocated to hold the text literal value.*)

      function      ExpObjectContains: gsUTFString; override;
     (*Returns the text literal.*)

      procedure    ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType); override;
     (*Returns the text literal in Buffer.  Returns rtText in ExpResult.*)
   end;

   TgsExpNumLit = Class(TgsExpBaseObject)
   (*Holder class for a numeric literal.*)
   private
      FExpFloat     : FloatNum;
   public
      constructor   Create(const AValue: gsUTFString);
      (*Creates a holder object that contains the literal numeric value stored
        in AValue. This class is allocated as the original expression is
        generated and part of the expression is identified as a numeric literal.*)

      function      ExpObjectContains: gsUTFString; override;
      (*Returns the numeric literal as a string.*)

      procedure    ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType); override;
    (*Returns the numeric literal as a FloatNum type in Buffer.  Returns rtFloat
      in ExpResult.*)
   end;

   TgsExpDateLit = Class(TgsExpBaseObject)
   (*Holder class for a date literal.*)
   private
      FExpDate     : FloatNum;
   public
      constructor   Create(const AValue: gsUTFString);
      (*Creates a holder object that contains the literal date value stored
        in AValue. This class is allocated as the original expression is
        generated and part of the expression is identified as a date literal.*)

      function      ExpObjectContains: gsUTFString; override;
      (*Returns the date literal as a Julian Date string.*)

      procedure    ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType); override;
    (*Returns the numeric literal as a FloatNum type in Buffer.  Returns rtDate
      in ExpResult.*)
   end;

   TgsExpBlnLit = Class(TgsExpBaseObject)
   (*Holder class for a boolean literal.*)
   private
      FExpLogic     : boolean;
   public
      constructor   Create(const AValue: gsUTFString);
      (*Creates a holder object that contains the literal boolean value stored
        in AValue. This class is allocated as the original expression is
        generated and part of the expression is identified as a boolean literal.*)

      function      ExpObjectContains: gsUTFString; override;
      (*Returns the boolean literal as '.T.' or '.F.'.*)

      procedure    ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType); override;
    (*Returns the boolean literal as a boolean type in Buffer.  Returns rtBoolean
      in ExpResult.*)
   end;

   TgsExpHandler = Class(TObject)
   (*An Expression Handler class compiles and evaluates an expression that is
     assigned to it.  The expression can be any type commonly used in dBase
     index key and filter expressions.   Additionally, SQL Select..Where style
     expressions can be processed.*)
   private
      FUserLink   : TgsExpUserLink;
      FResultType  : TgsExpResultType;
      FExpChg      : Boolean;
      FExpLen      : integer;
      FExpDec      : integer;
      FParseObj    : TgsExpBaseObject;
      FArgCount    : integer;
      FInsensitive : boolean;
      FWildCards   : boolean;
      FWildCharAll : gsUTFChar;
      FWildCharOne : gsUTFChar;
      function CompressExpression(const Value: gsUTFString): gsUTFString;
      function GenerateObjects(const Value: gsUTFString): TgsExpBaseObject;
      function     GetExpression: gsUTFString; virtual;
      procedure    SetExpression(const AExpression: gsUTFString);
      function ScanFunctionGroup(const workStr: gsUTFString; ElemStart: integer;
                                 UseComma: boolean): integer;
      function CheckForOperator(var workStr, resultStr: gsUTFString): boolean;
      function CheckForGroup(var workStr, resultStr: gsUTFString): boolean;
      function CheckForEntity(var workStr, resultStr: gsUTFString): boolean;
      function CheckForLiteral(var workStr, resultStr: gsUTFString): boolean;
      function CheckForNumber(var workStr, resultStr: gsUTFString): boolean;
      function CheckForTrueFalse(var workStr, resultStr: gsUTFString): boolean;
      function CheckForLogical(var workStr, resultStr: gsUTFString): boolean;
      function CheckForNegation(var workStr, resultStr: gsUTFString): boolean;
   public
      constructor  Create(AUser: TgsExpUserLink; const AExpression: gsUTFString; IsSQL: boolean);
      (*Initializes the expression handler parameters.  Argument AUser is the
        TgsExpUserLink object that allows external variables and functions to be
        included in the expression compilation and evaluation.  AExpression is the
        expression to be compiled.  It can be nil, and the Expression passed in the
        Expression property later.  IsSQL is a boolean identifying whether dBase
        or SQL wildcard tokens will be used.*)

      destructor   Destroy; override;
      (*Frees resources allocated for the object.*)

      procedure ExpressionResult(var BufVar: variant); virtual;
      (*Requests the Expression be evaluated and the results returned in Buffer.
        The requestor will need to get the type through a call to ResultType to
        determine the type of value returned.  If successful, Result returns
        Buffer; otherwise it returns nil.*)

      procedure     ExpressionAsVariant(var AVar: TgsVariant); virtual;
      (*Requests the Expression be evaluated and the results returned in AVar as
        a TgsVariant.*)

      function     ResultType: TgsExpResultType;
      (*Returns the type of value (rtText, rtDate, rtBoolean, rtFloat, etc.) to
        which the expression evaluates.*)

      function     EnumerateType(AType: integer): gsUTFString;

      property     UserLink: TgsExpUserLink read FUserLink write FUserLink;
      (*Returns the pointer to the user link attached to this object.*)

      property     Expression: gsUTFString read GetExpression write SetExpression;
      (*This property sets the expression or returns the expression string.  If
        assigning a new expression, the expression processes assigned to the
        old expression are released and new ones created as the new expression is
        compiled.*)
      property     ArgCount: integer read FArgCount;
      (*Returns the number of expression processes allocated for the expression.*)

      property     DecimalCount: integer read FExpDec;
      (*Used to return the number of decimals to be used when a number (rtFloat)
        is converted to a string.  This is needed for dBase fields returned as
        variables since they specify the number of decimal places, but are handled
        as floating point numbers.*)

      property     NumberLength: integer read FExpLen;
      (*Used to return the number of digits (including decimal point) to be used
        when a number (rtFloat) is converted to a string.  This is needed for
        dBase fields returned as variables since they specify the field length,
        but are handled as floating point numbers.*)

      property     CaseInsensitive: boolean read FInsensitive write FInsensitive;
      (*Flag determines if a text comparison is case insensitive.*)

      property     UseWildCards: boolean read FWildCards write FWildCards;
      (*Flag determines if wild cards can be used in a text comparison.*)

      property     WildCardAll: char read FWildCharAll write FWildCharAll;
      (*Assigns the wild card character that is used to designate any number
        of characters is valid.  The default is '*'.  (e.g. 'SM*' would match
        any string that started with SM, for example, SMITH and SMYTHE).  If the
        expression handler was created with IsSQL true, then the '%' character
        is automatically assigned.*)

      property     WildCardOne: char read FWildCharOne write FWildCharOne;
      (*Assigns the wildcard character used to designate a single place
        wildcard.  The default is '?'.  (e.g., GRIFF?N would match GRIFFIN and
        GRIFFEN). If the expression handler was created with IsSQL true, then
        the '_' character is automatically assigned.*)
   end;

   EHalcyonExpression = class(Exception);

var
   GSVariableRegistry: TgsFieldVarReg;
   GSFunctionRegistry: TgsFunctionReg;

implementation
uses gs6_fctn;

const
   DefStrLen   = 10;
   WildCardChar1 = '*';
   WildCardChar2 = '%';
   WildCardChar3 = '?';
   WildCardChar4 = '_';

   ExpElementEnd = #01;
   opTypeUnary = #$02;   {unary operators}
   opTypeMult  = #$03;   {multiplying operators}
   opTypeAdd   = #$04;   {adding operators}
   opTypeRelat = #$05;   {relational operators}
   opTypeRelNot= #$06;   {relational NOT}
   opTypeRelAnd= #$07;   {relational AND}
   opTypeRelOr = #$08;   {relational OR}

   opElemEQ        = #$81;   {=}
   opElemNE        = #$82;   {<>,!=,#}
   opElemGT        = #$83;   {>}
   opElemLT        = #$84;   {<}
   opElemGE        = #$85;   {>=,=>}
   opElemLE        = #$86;   {<=,=<}
   opElemPOS       = #$87;   { $}
   opElemExactEQ   = #$88;   {==}
   opElemPlus      = #$89;   {+}
   opElemMinus     = #$8A;   {-}
   opElemMultiply  = #$8B;   {*}
   opElemDivide    = #$8C;   {/}
   opElemExponent  = #$8D;   {**,^}
   opElemAND       = #$90;   {AND}
   opElemOR        = #$91;   {OR}
   opElemNOT       = #$92;   {NOT}
   opElemLike      = #$93;   {LIKE}
   opElemFunction  = #$98;   {Function}
   opElemVariable  = #$99;   {Variable}
   opElemGroup     = #$9A;   {(..)}
   opElemText      = #$9B;   {Text Literal}
   opElemDate      = #$9C;   {Date Literal}
   opElemNumber    = #$9D;   {Number Literal}
   opElemBoolean   = #$9E;   {Boolean Literal}
   opElemUnary     = #$9F;   {Unary Operator}

   LogicValueCount = 8;
   OperatorValueCount = 18;
   ParserValueCount = LogicValueCount + OperatorValueCount;
   ParserValueArray : array[0..ParserValueCount-1] of gsUTFString =
                           ('AND','OR','EQ','NE','GE','LE','LT','GT',
                            '=','+','-','*','/','**','^',
                            '<>','!=','#','>','<','>=','=>',
                            '<=','=<','$','==');

   ParserActionArray : array[0..ParserValueCount-1] of gsUTFChar =
                            (opElemAND,opElemOR,opElemEQ,opElemNE,
                             opElemGE,opElemLE,opElemLT,opElemGT,
                             opElemEQ,opElemPlus,opElemMinus,opElemMultiply,
                             opElemDivide,opElemExponent,opElemExponent,
                             opElemNE,opElemNE,opElemNE,opElemGT,opElemLT,
                             opElemGE,opElemGE,opElemLE,opElemLE,opElemPos,
                             opElemExactEQ);

   SingleQuote = '''';
   DoubleQuote = '"';


{---------------------------------------------------------------------------
                             StrNumDec  (Decimal Places in Numeric String)
----------------------------------------------------------------------------}

function StrNumDec(const Str1: gsUTFString): integer;
var
   DecPos: integer;
begin
   Result := 0;
   if Length(Str1) <> 0 then
   begin
      DecPos := Pos('.',Str1);
      if DecPos > 0 then
      begin
         Result := Length(Str1)-DecPos;
      end;
   end;
end;

{---------------------------------------------------------------------------
                          TgsExpUserLink
----------------------------------------------------------------------------}

constructor TgsExpUserLink.Create;
begin
   inherited Create;
   UserFunctionRegistry := TgsFunctionReg.Create;
   UserFieldVarRegistry := TgsFieldVarReg.Create;
   FStrSize := DefStrLen;
end;

destructor TgsExpUserLink.Destroy;
begin
   UserFunctionRegistry.Free;
   UserFieldVarRegistry.Free;
   inherited Destroy;
end;

function TgsExpUserLink.FindFunction(const AFunction: gsUTFString): TgsUserDefFunction;
var
   i: integer;
begin
   i := UserFunctionRegistry.IndexOf(AFunction);
   if i <> -1 then
      Result := UserFunctionRegistry.FunctionLink(i)
   else
      Result := nil;
end;

function TgsExpUserLink.FindFieldVar(const AFieldVar: gsUTFString): TgsUserDefFieldVar;
var
   i: integer;
begin
   i := UserFieldVarRegistry.IndexOf(AFieldVar);
   if i <> -1 then
      Result := UserFieldVarRegistry.FieldVarLink(i)
   else
      Result := nil;
end;

function TgsExpUserLink.RegisterFunction(AFunction: TgsUserDefFunction): boolean;
begin
   Result := UserFunctionRegistry.RegisterFunction(AFunction);
end;

function TgsExpUserLink.OnNoFunction(const AFunction: gsUTFString): TgsUserDefFunction;
begin
   raise EHalcyonExpression.CreateFMT(gsErrNoSuchFunction,[AFunction]);
end;


function TgsExpUserLink.RegisterFieldVar(AFieldVar: TgsUserDefFieldVar): boolean;
begin
   Result := UserFieldVarRegistry.RegisterFieldVar(AFieldVar);
end;

{---------------------------------------------------------------------------
                        TgsFunctionReg
----------------------------------------------------------------------------}

constructor TgsFunctionReg.Create;
begin
   Inherited Create;
   Sorted := true;
   Duplicates := dupError;
end;

destructor TgsFunctionReg.Destroy;
var
   i: integer;
begin
   for i := 0 to Count-1 do
   begin
      TgsUserDefFunction(Objects[i]).Free;
   end;
   inherited Destroy;
end;

function TgsFunctionReg.RegisterFunction(AFunction: TgsUserDefFunction): boolean;
begin
   Result := true;
   if AFunction = nil then exit;
   try
      AddObject(AnsiUpperCase(AFunction.FunctionName),AFunction);
   except
      Result := false;
   end;
end;

function TgsFunctionReg.FunctionName(Index: integer): gsUTFString;
begin
   if (Index >= 0) and (Index < Count) then
      Result := Strings[Index]
   else
      Result := '';
end;

function TgsFunctionReg.FunctionLink(Index: integer): TgsUserDefFunction;
begin
   if (Index >= 0) and (Index < Count) then
      Result := TgsUserDefFunction(Objects[Index])
   else
      Result := nil;
end;



{---------------------------------------------------------------------------
                        TgsFieldVarReg
----------------------------------------------------------------------------}

constructor TgsFieldVarReg.Create;
begin
   Inherited Create;
   Sorted := true;
   Duplicates := dupError;
end;

destructor TgsFieldVarReg.Destroy;
var
   i: integer;
begin
   for i := 0 to Count-1 do
   begin
      TgsUserDefFieldVar(Objects[i]).Reference := TgsUserDefFieldVar(Objects[i]).Reference-1;
      if TgsUserDefFieldVar(Objects[i]).Reference <= 0 then
         TgsUserDefFieldVar(Objects[i]).Free;
   end;
   inherited Destroy;
end;

function TgsFieldVarReg.RegisterFieldVar(AFieldVar: TgsUserDefFieldVar): boolean;
var
   i: integer;
   s: gsUTFString;
begin
   Result := true;
   s := AnsiUpperCase(AFieldVar.FieldVarList);
   while Length(s) > 0 do
   begin
      i := pos(';',s);
      if i = 0 then i := Length(s)+1;
      try
         AddObject(copy(s,1,i-1),AFieldVar);
         system.delete(s,1,i);
         AFieldVar.Reference := AFieldVar.Reference+1;
      except
         Result := false;
      end;
   end;
end;

function TgsFieldVarReg.FieldVarName(Index: integer): gsUTFString;
begin
   if (Index >= 0) and (Index < Count) then
      Result := Strings[Index]
   else
      Result := '';
end;

function TgsFieldVarReg.FieldVarType(Index: integer): integer;
begin
   if (Index >= 0) and (Index < Count) then
      Result := TgsUserDefFieldVar(Objects[Index]).FieldVarType
   else
      Result := 0;
end;

function TgsFieldVarReg.FieldVarLink(Index: integer): TgsUserDefFieldVar;
begin
   if (Index >= 0) and (Index < Count) then
      Result := TgsUserDefFieldVar(Objects[Index])
   else
      Result := nil;
end;


{---------------------------------------------------------------------------
                      Abstract TgsUserDefFunction
----------------------------------------------------------------------------}

function TgsUserDefFunction.FunctionName: gsUTFString;
begin
   FunctionName := '';
end;

procedure TgsUserDefFunction.FunctionResult(Caller: TgsExpFunction;
          var BufVar: variant; var ExpResult: TgsExpResultType);
begin
   BufVar := null;
   ExpResult := rtEmpty;
end;

{---------------------------------------------------------------------------
                            TgsUserFieldVar
----------------------------------------------------------------------------}

constructor TgsUserDefFieldVar.Create(const AName: gsUTFString);
begin
   Inherited Create;
   FVarLen := 0;
   FDescendents := false;
   FReference := 0;
   FName := gsStrUpperCase(AName);
end;

destructor TgsUserDefFieldVar.Destroy;
begin
   inherited Destroy;
end;

function TgsUserDefFieldVar.FieldVarList: gsUTFString;
begin
   Result := FName;
end;

function TgsUserDefFieldVar.FieldVarName: gsUTFString;
var
   i: integer;
   s: string;
begin
   s := FName;
   i := pos(';',s);
   if i > 0 then
      s := copy(s,1,i-1);
   FieldVarName := s;
end;

function TgsUserDefFieldVar.FieldVarType: integer;
begin
   Result := gsSQLTypeVarStd;
end;

procedure TgsUserDefFieldVar.FieldVarResult(var BufVar: variant;
                            var ExpResult: TgsExpResultType);
begin
   BufVar := null;
   ExpResult := rtEmpty;
end;

{---------------------------------------------------------------------------
                            TgsExpBaseObject
----------------------------------------------------------------------------}

constructor TgsExpBaseObject.Create;
begin
   Inherited Create;
   FResultType := rtUnknown;
   FExpType := etUnknown;
   FExpChg := false;
   FExpLen := 0;
   FExpDec := 0;
   FArgLeft := nil;
   FArgRight := nil;
end;

destructor TgsExpBaseObject.Destroy;
begin
   if FArgLeft <> nil then FArgLeft.Free;
   if FArgRight <> nil then FArgRight.Free;
   inherited Destroy;
end;

function TgsExpBaseObject.ExpObjectContains: gsUTFString;
begin
   ExpObjectContains := '';
end;

function TgsExpBaseObject.ExpObjectType: integer;
begin
   Result := gsSQLTypeNA;
end;

function TgsExpBaseObject.ExpRebuildExpression: gsUTFString;
var
   s: gsUTFString;
begin
   s := '';
   if FArgLeft <> nil then
      s := FArgLeft.ExpRebuildExpression;
   s := s + ExpObjectContains;
   if FArgRight <> nil then
      s := s + FArgRight.ExpRebuildExpression;
   Result := s;
end;

function TgsExpBaseObject.ExpEnumTypes(AType: integer): gsUTFString;
var
   s: gsUTFString;
begin
   s := '';
   if FArgLeft <> nil then
      s := FArgLeft.ExpEnumTypes(AType);
   if ExpObjectType = AType then
      s := s + ExpObjectContains+';';
   if FArgRight <> nil then
      s := s + FArgRight.ExpEnumTypes(AType);
   Result := s;
end;


procedure TgsExpBaseObject.ExpParse(var BufVar: variant;
                                  var ExpResult: TgsExpResultType);
begin
   ExpResult := rtUnknown;
end;

{---------------------------------------------------------------------------
                            TgsExpContainer
----------------------------------------------------------------------------}

constructor TgsExpContainer.Create(AOwner: TgsExpHandler; const AValue: gsUTFString);
var
   ResultStr: gsUTFString;
begin
   Inherited Create;
   ResultStr := AOwner.CompressExpression(AValue);
   FArgRight := AOwner.GenerateObjects(ResultStr);
end;

function TgsExpContainer.ExpRebuildExpression: gsUTFString;
var
   s: gsUTFString;
begin
   s := '(';
   if FArgRight <> nil then
      s := s + FArgRight.ExpRebuildExpression;
   s := s + ')';
   Result := s;
end;

function TgsExpContainer.ExpEnumTypes(AType: integer): gsUTFString;
var
   s: gsUTFString;
begin
   s := '';
   if FArgRight <> nil then
      s := s + FArgRight.ExpEnumTypes(AType);
   Result := s;
end;

procedure TgsExpContainer.ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType);
begin
   if FArgRight <> nil then
      FArgRight.ExpParse(BufVar, ExpResult)
   else
      ExpResult := rtEmpty;
end;

{---------------------------------------------------------------------------
                            TgsExpFunction
----------------------------------------------------------------------------}

constructor TgsExpFunction.Create(AOwner: TgsExpHandler; const AValue: gsUTFString);
var
   ExpStr: gsUTFString;
   ElemStr: gsUTFString;
   ResultStr: gsUTFString;
   ixLength: integer;
   ixPosGroup: integer;
   ixPosElemStart: integer;
   ixPosElemEnd: integer;
   i: integer;
begin
   Inherited Create;
   FOwner := AOwner;
   FExpType := etFunction;
   FArgList := TList.Create;
   FUDF := nil;
   ixLength := Length(AValue);
   if ixLength = 0 then exit;
   ixPosGroup := Pos('(',AValue);
   if ixPosGroup = 0 then exit;
   ExpStr := AnsiUpperCase(copy(AValue,1,ixPosGroup-1));
   i := 0;
   while (i < GSFunctionRegistry.Count) and
         (GSFunctionRegistry.FunctionName(i) <> ExpStr) do
      inc(i);
   if i < GSFunctionRegistry.Count then
      FUDF := GSFunctionRegistry.FunctionLink(i);
   if FUDF = nil then
   begin
      if FOwner.UserLink <> nil then
      begin
         FUDF := FOwner.UserLink.FindFunction(ExpStr);
      end;
   end;
   if FUDF = nil then
   begin
      if FOwner.UserLink <> nil then
         FUDF := FOwner.UserLink.OnNoFunction(ExpStr)
      else
         raise EHalcyonExpression.CreateFMT(gsErrNoSuchFunction,[ExpStr]);
   end;
   ixPosElemStart := ixPosGroup;
   ixPosElemEnd := ixPosElemStart+1;
   while ixPosElemEnd < ixLength do
   begin
      ixPosElemEnd := AOwner.ScanFunctionGroup(AValue,ixPosElemStart,true);
      ElemStr := Copy(AValue,ixPosElemStart+1,ixPosElemEnd-ixPosElemStart-1);
      if Length(ElemStr) <> 0 then
      begin
         ResultStr := AOwner.CompressExpression(ElemStr);
         FArgList.Add(AOwner.GenerateObjects(ResultStr));
      end;
      ixPosElemStart := ixPosElemEnd;
      ixPosElemEnd := ixPosElemStart+1;
   end;
end;

destructor TgsExpFunction.Destroy;
var
   i: integer;
begin
   for i := 0 to FArgList.Count-1 do
   begin
     TgsExpBaseObject(FArgList.Items[i]).Free;
   end;
   FArgList.Free;
   inherited Destroy;
end;

function TgsExpFunction.ExpObjectContains: gsUTFString;
begin
   ExpObjectContains := FUDF.FunctionName;
end;

function TgsExpFunction.ExpRebuildExpression: gsUTFString;
var
   s: gsUTFString;
   i: integer;
begin
   s := ExpObjectContains + '(';
   for i := 0 to FArgList.Count-1 do
   begin
      s := s + TgsExpBaseObject(FArgList.Items[i]).ExpRebuildExpression;
      if i < FArgList.Count - 1 then
         s := s + ',';
   end;
   s := s + ')';
   Result := s;
end;

function TgsExpFunction.ExpEnumTypes(AType: integer): gsUTFString;
var
   s: gsUTFString;
   i: integer;
begin
   s := '';
   for i := 0 to FArgList.Count-1 do
   begin
      s := s + TgsExpBaseObject(FArgList.Items[i]).ExpENumTypes(AType);
   end;
   Result := s;
end;

procedure TgsExpFunction.ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType);
begin
   FUDF.FunctionResult(Self,BufVar,ExpResult);
end;

procedure TgsExpFunction.FetchArg(Index: integer; var BufVar: variant;
                       var ExpResult: TgsExpResultType;
                       ExpResultNeeded: TgsExpResultType);
var
   s: gsUTFString;
begin
   ExpResult := rtUnknown;
   if Index < FArgList.Count then
   begin
      TgsExpBaseObject(FArgList.Items[Index]).ExpParse(BufVar, ExpResult);
   end
   else
   begin
      ExpResult := rtEmpty;
   end;
   if ((ExpResultNeeded <> rtAny) and (ExpResult <> ExpResultNeeded)) then
   begin
      if (not ((ExpResultNeeded in [rtFloat..rtDateTime]) and
              (ExpResult in [rtFloat..rtDateTime]))) then
      begin
         case ExpResultNeeded of
            rtDate    : s := 'Date';
            rtFloat   : s := 'Number';
            rtText    : s := 'Text';
            rtBoolean : s := 'Boolean';
            rtUnknown : s := 'Unknown';
            rtEmpty   : s := 'Empty';
            rtAny     : s := 'Any';
            rtInteger : s := 'Integer';
            rtDateTime : s := 'DateTime';
            rtMemo    : s := 'Memo';
            rtPointer : s := 'Pointer';
            else        s := 'Invalid Value';
         end;
         raise EHalcyonExpression.CreateFmt
                 (gsErrArgValueNeeded,[s,Index+1,FUDF.FunctionName]);
      end;
   end;
end;

function TgsExpFunction.FetchUser: TgsExpUserLink;
begin
   Result := FOwner.UserLink;
end;

{---------------------------------------------------------------------------
                            TgsExpFieldVar
----------------------------------------------------------------------------}

constructor TgsExpFieldVar.Create(AOwner: TgsExpHandler; const AValue: gsUTFString);
var
   i: integer;
   av: gsUTFString;
begin
   Inherited Create;
   FOwner := AOwner;
   FExpType := etFieldVar;
   FUDF := nil;
   if Length(AValue) <> 0 then
   begin
      av := AnsiUpperCase(AValue);
      i := GSVariableRegistry.IndexOf(AValue);
      if i > -1 then
         FUDF := TgsUserDefFieldVar(GSVariableRegistry.Objects[i]);
      if (FUDF = nil) and (FOwner.UserLink <> nil) then
         FUDF := FOwner.UserLink.FindFieldVar(av);
   end;
   if FUDF = nil then
   begin
      raise EHalcyonExpression.CreateFMT(gsErrNoSuchFunction,[AValue]);
   end;
   FExpLen := FUDF.FVarLen;
end;

function TgsExpFieldVar.ExpObjectContains: gsUTFString;
begin
   ExpObjectContains := FUDF.FieldVarName;
end;

function TgsExpFieldVar.ExpObjectType: integer;
begin
   Result := FUDF.FieldVarType;
end;

procedure TgsExpFieldVar.ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType);
begin
   FUDF.FieldVarResult(BufVar,ExpResult);
end;

function TgsExpFieldVar.FetchUser: TgsExpUserLink;
begin
   Result := FOwner.UserLink;
end;


{---------------------------------------------------------------------------
                            TgsExpOperator
----------------------------------------------------------------------------}

constructor TgsExpOperator.Create(AOperator, APrecedence: char);
begin
   Inherited Create;
   FExpType := etOperator;
   FOperator := AOperator;
   FPrecedence := APrecedence;
   FInsensitive := false;
   FWildCards := true;
   FWildCharAll := WildCardChar1;
   FWildCharOne := WildCardChar3;
end;

function TgsExpOperator.StrWCComp(vStr1, vStr2 : variant): Integer;
var
   Str1: gsUTFString;
   Str2: gsUTFString;
   v: integer;
begin
   v := 0;
   if (vStr1 = null) or (vStr1 = '') then v := 1;
   if (vStr2 = null) or (vStr2 = '') then v := v+2;
   if v > 0 then
   begin
      case v of
         1: Result := -1;
         2: Result := 1;
         else Result := 0;
      end;
      exit;
   end;
   Str1 := TrimRight(vStr1);
   Str2 := TrimRight(vStr2);
   if FInsensitive then
   begin
      Str1 := gsStrUpperCase(Str1);
      Str2 := gsStrUpperCase(Str2);
   end;
   if FWildCards and (Length(Str2) > 0) and
      ((Str2[1] = FWildCharAll) or (Str2[Length(Str2)] = FWildCharAll)) then
   begin
      v := gsStrPosWild(Str2,Str1);
      if v = 0 then
         Result := -1
       else
          Result := 0;
   end
   else
      Result := gsStrCompare(Str1,Str2);
end;

function TgsExpOperator.ExpObjectContains: gsUTFString;
begin
   case FOperator of
      opElemEQ        :  ExpObjectContains := '=';
      opElemNE        :  ExpObjectContains := '#';
      opElemGT        :  ExpObjectContains := '>';
      opElemLT        :  ExpObjectContains := '<';
      opElemGE        :  ExpObjectContains := '>=';
      opElemLE        :  ExpObjectContains := '<=';
      opElemPOS       :  ExpObjectContains := 'in string';
      opElemExactEQ   :  ExpObjectContains := 'exactly equal';
      opElemPlus      :  ExpObjectContains := '+';
      opElemMinus     :  ExpObjectContains := '-';
      opElemMultiply  :  ExpObjectContains := '*';
      opElemDivide    :  ExpObjectContains := '/';
      opElemExponent  :  ExpObjectContains := '^';
      opElemAND       :  ExpObjectContains := '.AND.';
      opElemOR        :  ExpObjectContains := '.OR.';
      opElemNOT       :  ExpObjectContains := '.NOT.';
   end;
end;

procedure TgsExpOperator.ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType);
var
   Buf1: variant;
   Buf2: variant;
   ResultTypeLeft: TgsExpResultType;
   ResultTypeRight: TgsExpResultType;
   ExpCnt: longint;
   FloatWork: FloatNum;
   FloatAlso: FloatNum;
   bc: integer;
   s: gsUTFString;
begin
   if ((FArgLeft = nil) and (FOperator <> opElemNOT)) or (FArgRight = nil) then
      raise EHalcyonExpression.CreateFmt(gsErrMissingSide,[ExpObjectContains]);
   try
      ResultTypeLeft := rtEmpty;
      ResultTypeRight := rtEmpty;
      if FArgRight <> nil then
         FArgRight.ExpParse(Buf2, ResultTypeRight);
      ResultTypeLeft := ResultTypeRight;
      if FArgLeft <> nil then
         FArgLeft.ExpParse(Buf1, ResultTypeLeft);

      FResultType := ResultTypeRight;
      if (ResultTypeLeft <> ResultTypeRight) then
      begin
         if not ((ResultTypeLeft in [rtFloat..rtDateTime]) and
                 (ResultTypeRight in [rtFloat..rtDateTime])) then
         begin
            if FOperator <> opElemNOT then
              raise EHalcyonExpression.Create(gsErrOpConflict);
            if ResultTypeRight <> rtBoolean then
               raise EHalcyonExpression.CreateFmt(gsErrArgInvalid,['boolean']);
         end;
      end;
      if FResultType = rtBoolean  then
      begin
         case FOperator of
            opElemEQ  :  BufVar := Buf1 = Buf2;
            opElemNE  :  BufVar := Buf1 <> Buf2;
            opElemAND :  BufVar := Buf1 and Buf2;
            opElemOR  :  BufVar := Buf1 or Buf2;
            opElemNOT :  BufVar := not Buf2;
            opElemPlus,
            opElemMinus,
            opElemMultiply,
            opElemDivide,
            opElemExponent : raise EHalcyonExpression.CreateFmt(gsErrArgInvalid,['number']);
            else
                raise EHalcyonExpression.CreateFmt(gsErrArgInvalid,['assigned']);
         end;
      end
      else
      if FResultType in [rtFloat..rtDateTime] then
      begin
         FloatWork := Buf1 - Buf2;
         case FOperator of
            opElemEQ  :  BufVar := FloatWork = 0.0;
            opElemNE  :  BufVar := FloatWork <> 0.0;
            opElemLE  :  BufVar := FloatWork <= 0.0;
            opElemGT  :  BufVar := FloatWork > 0.0;
            opElemLT  :  BufVar := FloatWork < 0.0;
            opElemGE  :  BufVar := FloatWork >= 0.0;
            opElemPlus : BufVar := Buf1 + Buf2;
            opElemMinus: BufVar := Buf1 - Buf2;
            opElemMultiply  :  BufVar := Buf1 * Buf2;
            opElemDivide    :  BufVar := Buf1 / Buf2;
            opElemExponent  :  begin
                              FloatAlso := Buf1;
                              FloatWork := Buf1;
                              ExpCnt := trunc(Buf2);
                              while ExpCnt > 1 do
                              begin
                                 dec(ExpCnt);
                                 FloatAlso := FloatAlso * FloatWork;
                              end;
                              BufVar := FloatAlso;
                           end;
            else
                raise EHalcyonExpression.CreateFmt(gsErrArgInvalid,['assigned']);
         end;
      end
      else
      if FResultType = rtText  then
      begin
         case FOperator of
            opElemEQ,
            opElemNE,
            opElemLE,
            opElemGT,
            opElemLT,
            opElemGE    :  begin
                              bc := StrWCComp(Buf1,Buf2);
                              case FOperator of
                                 opElemEQ  :  BufVar := bc = 0;
                                 opElemNE  :  BufVar := bc <> 0;
                                 opElemLE  :  BufVar := bc <= 0;
                                 opElemGT  :  BufVar := bc > 0;
                                 opElemLT  :  BufVar := bc < 0;
                                 opElemGE  :  BufVar := bc >= 0;
                              end;
                           end;
            opElemPos:     begin
                              BufVar := pos(Buf1,Buf2) > 0;
                           end;
            opElemPlus:    begin
                              s := '';
                              if (Buf1 <> null) and (Buf1 <> '') then
                              begin
                                 s := Buf1;
                              end;
                              if (Buf2 <> null) and (Buf2 <> '') then
                              begin
                                 s := s + Buf2;
                              end;
                              BufVar := s;
                           end;
            opElemMinus:   begin
                              bc := 0;
                              s := '';
                              if (Buf1 <> null) and (Buf1 <> '') then
                              begin
                                 bc := length(Buf1);
                                 s := TrimRight(Buf1);
                              end;
                              if (Buf2 <> null) and (Buf2 <> '') then
                              begin
                                 bc := bc + length(Buf2);
                                 s := s + Buf2;
                              end;
                              while length(s) < bc do s := s + ' ';
                              BufVar := s;
                           end;

            else raise EHalcyonExpression.CreateFmt(gsErrArgInvalid,['assigned']);
         end;
      end;
   finally
      case FOperator of
         opElemEQ,
         opElemNE,
         opElemGT,
         opElemLT,
         opElemGE,
         opElemLE,
         opElemPOS,
         opElemExactEQ,
         opElemAND ,
         opElemOR,
         opElemNOT      : FResultType := rtBoolean;
      end;
      ExpResult := FResultType;
   end;
end;


{---------------------------------------------------------------------------
                            TgsExpTextLit
----------------------------------------------------------------------------}

constructor TgsExpTextLit.Create(const AValue: gsUTFString);
begin
   Inherited Create;
   FResultType := rtText;
   FExpType := etTextLit;
   FExpValue := AValue;
   FExpLen := Length(AValue);
end;

destructor TgsExpTextLit.Destroy;
begin
   inherited Destroy;
end;

function TgsExpTextLit.ExpObjectContains: gsUTFString;
begin
      ExpObjectContains := '"'+FExpValue+'"';
end;

Procedure TgsExpTextLit.ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType);
begin
   ExpResult := FResultType;
   BufVar := FExpValue;
end;


{---------------------------------------------------------------------------
                            TgsExpNumLit
----------------------------------------------------------------------------}

constructor TgsExpNumLit.Create(const AValue: gsUTFString);
var
   r: integer;
begin
   Inherited Create;
   FResultType := rtFloat;
   FExpType := etNumLit;
   FExpFloat := 0.0;
   FExpLen := Length(AValue);
   if FExpLen <> 0 then
   begin
      val(AValue, FExpFloat, r);
      if r <> 0 then
         FExpFloat := 0.0;
      FExpDec := StrNumDec(AValue);
   end;
end;

function TgsExpNumLit.ExpObjectContains: gsUTFString;
var
   s: gsUTFString;
begin
   str(FExpFloat:20:FExpDec,s);
   while s[1] = ' ' do delete(s,1,1);
   ExpObjectContains := s;
end;

procedure TgsExpNumLit.ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType);
begin
   ExpResult := FResultType;
   BufVar := FExpFloat;
end;

{---------------------------------------------------------------------------
                            TgsExpDateLit
----------------------------------------------------------------------------}

constructor TgsExpDateLit.Create(const AValue: gsUTFString);
begin
   Inherited Create;
   FResultType := rtDate;
   FExpType := etDateLit;
   FExpDate := DBFDate.CTOD(AValue);
end;

function TgsExpDateLit.ExpObjectContains: gsUTFString;
var
   l: longint;
begin
   l := trunc(FExpDate);
   ExpObjectContains := '{'+DBFDate.DTOC(l)+'}';
end;

procedure TgsExpDateLit.ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType);
begin
   ExpResult := FResultType;
   BufVar := FExpDate;
end;

{---------------------------------------------------------------------------
                            TgsExpBlnLit
----------------------------------------------------------------------------}

constructor TgsExpBlnLit.Create(const AValue: gsUTFString);
begin
   Inherited Create;
   FResultType := rtBoolean;
   FExpType := etBlnLit;
   if AValue = '.T.' then
      FExpLogic := true
   else
      FExpLogic := false;
end;

function TgsExpBlnLit.ExpObjectContains: gsUTFString;
begin
   if FExpLogic then
      ExpObjectContains := '.T.'
   else
      ExpObjectContains := '.F.';
end;

procedure TgsExpBlnLit.ExpParse(var BufVar: variant; var ExpResult: TgsExpResultType);
begin
   ExpResult := FResultType;
   BufVar := FExpLogic;
end;

{---------------------------------------------------------------------------
                            TgsExpHandler
----------------------------------------------------------------------------}

constructor TgsExpHandler.Create(AUser: TgsExpUserLink; const AExpression: gsUTFString; IsSQL: boolean);
var
   ExpString: gsUTFString;
begin
   Inherited Create;
   FExpLen := 0;
   FExpDec := 0;
   FArgCount := 0;
   FInsensitive := false;
   FWildCards := true;
   if IsSQL then
   begin
      FWildCharAll := WildCardChar2;
      FWildCharOne := WildCardChar4;
   end
   else
   begin
      FWildCharAll := WildCardChar1;
      FWildCharOne := WildCardChar3;
   end;
   FUserLink := AUser;
   FExpChg := false;
   if Length(AExpression) = 0 then
   begin
      FParseObj := nil;
      FResultType := rtUnknown;
   end
   else
   begin
      ExpString := CompressExpression(AExpression);
      FParseObj := GenerateObjects(ExpString);
   end;
end;

destructor TgsExpHandler.Destroy;
begin
   if FParseObj <> nil then
      FParseObj.Free;
   inherited Destroy;
end;

function TgsExpHandler.EnumerateType(AType: integer): gsUTFString;
begin
   if FParseObj <> nil then
      Result := FParseObj.ExpEnumTypes(AType)
   else
      Result := '';
end;

function TgsExpHandler.GetExpression: gsUTFString;
begin
   if FParseObj <> nil then
      Result := FParseObj.ExpRebuildExpression
   else
      Result := '';
end;

procedure TgsExpHandler.SetExpression(const AExpression: gsUTFString);
var
   ExpString: gsUTFString;
begin
   if FParseObj <> nil then
      FParseObj.Free;
   FParseObj := nil;
   FExpLen := 0;
   FExpDec := 0;
   FArgCount := 0;
   FResultType := rtUnknown;
   if Length(AExpression) <> 0 then
   begin
      ExpString := CompressExpression(AExpression);
      FParseObj := GenerateObjects(ExpString);
   end;
end;

procedure TgsExpHandler.ExpressionResult(var BufVar: variant);
begin
   FExpChg := false;
   if FParseObj <> nil then
   begin
      FParseObj.ExpParse(BufVar, FResultType);
   end
   else
      FResultType := rtUnknown;
end;

procedure TgsExpHandler.ExpressionAsVariant(var AVar: TgsVariant);
var
   BufVar: variant;
   j: longint;
begin
   FExpChg := false;
   if FParseObj <> nil then
   begin
      FParseObj.ExpParse(BufVar, FResultType);
      if BufVar <> null then
      begin
         case FResultType of
            rtText    : begin
                           AVar.PutString(BufVar);
                         end;
            rtDate    :  begin
                            j := trunc(BufVar);
                            AVar.PutDate(j);
                         end;
            rtFloat,
            rtDateTime:  begin
                            AVar.PutFloat(BufVar);
                         end;
            rtBoolean :  begin
                            AVar.PutBoolean(BufVar);
                         end;
            else         begin
                            FResultType := rtUnknown;
                         end;
         end;
      end;
   end
   else
   begin
      AVar.PutString('');
      FResultType := rtUnknown;
   end;
end;


function TgsExpHandler.ResultType: TgsExpResultType;
begin
   Result := FResultType;
end;













function TgsExpHandler.ScanFunctionGroup(const workStr: gsUTFString; ElemStart: integer;
                                         UseComma: boolean): integer;
var
   ixPosElemEnd: integer;
   ctGroup: integer;
   atEnd: boolean;
   cQuote: gsUTFChar;
begin
   ixPosElemEnd := ElemStart+1;
   ctGroup := 0;
   cQuote := #0;
   atEnd := false;
   repeat
      case workStr[ixPosElemEnd] of
         ',' : if UseComma and (cQuote = #0) then
                  AtEnd := ctGroup = 0;
          '(' : begin
                  if cQuote = #0 then
                      inc(ctGroup);
                end;
         ')' : begin
                  if cQuote = #0 then
                  begin
                     AtEnd := ctGroup = 0;
                     if not AtEnd then dec(ctGroup);
                  end;
               end;
         '''',
         '"' : begin
                  if cQuote = #0 then
                  begin
                     cQuote := workStr[ixPosElemEnd];
                     inc(ctGroup);
                  end
                  else
                  begin
                     if cQuote = workStr[ixPosElemEnd] then
                     begin
                        dec(ctGroup);
                        cQuote := #0;
                     end;
                  end;
               end;
         '[' : begin
                  if cQuote = #0 then
                  begin
                     cQuote := ']';
                     inc(ctGroup);
                  end;
               end;
         ']' : begin
                  if cQuote = ']' then
                  begin
                     dec(ctGroup);
                     cQuote := #0;
                  end;
               end;
         '{' : begin
                  if cQuote = #0 then
                  begin
                     cQuote := '}';
                     inc(ctGroup);
                  end;
               end;
         '}' : begin
                  if cQuote = '}' then
                  begin
                     dec(ctGroup);
                     cQuote := #0;
                  end;
               end;
      end;
      if not AtEnd then
         inc(ixPosElemEnd);
   until AtEnd;
   Result := ixPosElemEnd;
end;


      {Check for operator}
function TgsExpHandler.CheckForOperator(var workStr, resultStr: gsUTFString): boolean;
var
   ixOut: integer;
   elemStr: gsUTFString;
   cWork: gsUTFChar;
   cAction: gsUTFChar;
   ixFind: integer;
   bAction: boolean;
begin
   Result := false;
   if Length(workStr) = 0 then exit;
   cWork := workStr[1];
   if cWork in ['*','/','=','+','-','<','>','!','#','^','$'] then
   begin
      ixOut := 2;
      while (ixOut <= Length(workStr)) and (workStr[ixOut] in ['*','=','<','>']) do inc(ixOut);
      if (ixOut <= Length(workStr)) then
      begin
         elemStr := copy(workStr,1,ixOut-1);
         ixFind := LogicValueCount;
         repeat
            bAction :=  ParserValueArray[ixFind] = elemStr;
            if bAction then
            begin
               cAction := ParserActionArray[ixFind];
               case cAction of
                  opElemEQ,
                  opElemNE,
                  opElemGT,
                  opElemLT,
                  opElemGE,
                  opElemLE,
                  opElemPOS,
                  opElemExactEQ     : begin
                                         cWork := opTypeRelat;
                                      end;
                  opElemPlus,
                  opElemMinus       : begin
                                         cWork := opTypeAdd;
                                      end;
                  opElemMultiply,
                  opElemDivide      : begin
                                         cWork := opTypeMult;
                                      end;
                  opElemNOT         : begin
                                         cWork := opTypeRelNot;
                                      end;
                  opElemAND         : begin
                                         cWork := opTypeRelAnd;
                                      end;
                  opElemOR         : begin
                                         cWork := opTypeRelOr;
                                      end;
                  opElemExponent    : begin
                                         cWork := opTypeUnary;
                                      end;
                  else                cWork := opTypeAdd;
               end;
               Delete(workStr,1,ixOut-1);
               resultStr := resultStr + cAction + cWork + ExpElementEnd;
               Result := true;
            end
            else
               inc(ixFind);
         until (bAction) or (ixFind=ParserValueCount);
      end;
   end;
end;


      {Check for group}
function TgsExpHandler.CheckForGroup(var workStr, resultStr: gsUTFString): boolean;
var
   ixOut: integer;
   ixParend: integer;
   elemStr: gsUTFString;
   cWork: gsUTFChar;

begin
   Result := false;
   if Length(workStr) = 0 then exit;
   cWork := workStr[1];
   if cWork = '(' then
   begin
      ixOut := 2;
      ixParend := 1;
      while (ixOut <= Length(workStr)) and (ixParend > 0) do
      begin
         if (workStr[ixOut] = '(') then inc(ixParend)
         else
            if (workStr[ixOut] = ')') then dec(ixParend);
         if ixParend > 0 then inc(ixOut);
      end;
      if (ixOut <= Length(workStr)) then
      begin
         elemStr := copy(workStr,2,ixOut-2);
         resultStr := resultStr + opElemGroup + elemStr + ExpElementEnd;
         Delete(workStr,1,ixOut);
         Result := true;
      end
      else
      begin
         raise EHalcyonExpression.Create(gsErrNoEndParend);
      end;
   end;
end;

      {Check for entity}
function TgsExpHandler.CheckForEntity(var workStr, resultStr: gsUTFString): boolean;
var
   ixOut: integer;
   elemStr: gsUTFString;
   initialStr: gsUTFString;
   av: gsUTFString;
   pUDF: TgsUserDefFieldVar;
   i: integer;
   cWork: gsUTFChar;
   bComplete: boolean;
begin
   Result := false;
   if Length(workStr) = 0 then exit;
   cWork := workStr[1];
   if cWork in ['A'..'Z','a'..'z','_'] then
   begin
      ixOut := 2;
      while (ixOut <= Length(workStr)) and
            (workStr[ixOut] in ['A'..'Z','a'..'z','0'..'9','_']) do inc(ixOut);
      elemStr := copy(workStr,1,ixOut-1);
      Delete(workStr,1,ixOut-1);
      initialStr := elemStr;
      repeat
         if (Length(workStr) > 0) and (workStr[1] = '(') then
         begin
            ixOut := ScanFunctionGroup(workStr,1,false);
            if (ixOut <= Length(workStr)) then
            begin
               elemStr := elemstr+copy(workStr,1,ixOut);
               resultStr := resultStr + opElemFunction + elemStr + ExpElementEnd;
               Delete(workStr,1,ixOut);
               bComplete := true;
               Result := true;
            end
            else
            begin
               raise EHalcyonExpression.Create(gsErrNoEndParend);
            end;
         end
         else
         begin
            pUDF := nil;
            av := AnsiUpperCase(elemStr);
            i := GSVariableRegistry.IndexOf(av);
            if i > -1 then
               pUDF := TgsUserDefFieldVar(GSVariableRegistry.Objects[i]);
            if (pUDF = nil) and (UserLink <> nil) then
               pUDF := UserLink.FindFieldVar(av);
            if (pUDF = nil) and (pos('->',workStr)=1) then
            begin
               Delete(workStr,1,1);
               workStr[1] := '.';
            end;
            if (pUDF = nil) or (pUDF.Descendents and ((Length(workStr) > 0) and (workStr[1]='.'))) then
            begin
               bComplete := (Length(workStr) = 0) or (workStr[1] <> '.');
               if not bComplete then
               begin
                  ixOut := 2;
                  while (ixOut <= Length(workStr)) and
                        (workStr[ixOut] in ['A'..'Z','a'..'z','0'..'9','_']) do inc(ixOut);
                  elemStr := elemStr+Copy(workStr,1,ixOut-1);
                  Delete(workStr,1,ixOut-1);
               end
               else
                  raise EHalcyonExpression.CreateFMT(gsErrNoSuchFunction,[initialStr]);
            end
            else
            begin
               resultStr := resultStr + opElemVariable + elemStr + ExpElementEnd;
               bComplete := true;
               Result := true;
            end;
         end;
      until bComplete;
   end;
end;

      {Check for text or date literal}
function TgsExpHandler.CheckForLiteral(var workStr, resultStr: gsUTFString): boolean;
var
   ixOut: integer;
   elemStr: gsUTFString;
   operChar: gsUTFChar;
   cFind   : gsUTFChar;
   cWork: gsUTFChar;
begin
   Result := false;
   if Length(workStr) = 0 then exit;
   cWork := workStr[1];
   if cWork in [SingleQuote,DoubleQuote,'[','{'] then
   begin
      operChar := opElemText;
      case cWork of
         '{' : begin
                  cFind := '}';
                  operChar := opElemDate;
               end;
         '[' : begin
                  cFind := ']';
               end;
         else  cFind := cWork;
      end;
      ixOut := 2;
      while (ixOut <= Length(workStr)) and (workStr[ixOut] <> cFind) do inc(ixOut);
      if (ixOut <= Length(workStr)) then
      begin
         elemStr := copy(workStr,2,ixOut-2);
         resultStr := resultStr + operChar + elemStr + ExpElementEnd;
         Delete(workStr,1,ixOut);
         Result := true;
      end
      else
      begin
         raise EHalcyonExpression.CreateFmt(gsErrNoEndQuote,[cWork]);
      end;
   end;
end;

      {Check for numeric literal}
function TgsExpHandler.CheckForNumber(var workStr, resultStr: gsUTFString): boolean;
var
   ixOut: integer;
   elemStr: gsUTFString;
   cWork: gsUTFChar;
begin
   Result := false;
   if Length(workStr) = 0 then exit;
   cWork := workStr[1];
   if cWork in ['0'..'9','+','-'] then
   begin
      ixOut := 2;
      while (ixOut <= Length(workStr)) and
            (workStr[ixOut] in ['0'..'9','.']) do inc(ixOut);
      elemStr := copy(workStr,1,ixOut-1);
      resultStr := resultStr + opElemNumber + elemStr + ExpElementEnd;
      Delete(workStr,1,ixOut-1);
      Result := true;
   end;
end;

      {Check for logical literals .T. and .F.}
function TgsExpHandler.CheckForTrueFalse(var workStr, resultStr: gsUTFString): boolean;
var
   ixOut: integer;
   elemStr: gsUTFString;
   cWork: gsUTFChar;
begin
   Result := false;
   if Length(workStr) = 0 then exit;
   cWork := workStr[1];
   if cWork = '.' then
   begin
      ixOut := 2;
      while (ixOut <= Length(workStr)) and (workStr[ixOut] <> '.') do inc(ixOut);
      if (ixOut <= Length(workStr)) then
      begin
         elemStr := AnsiUpperCase(copy(workStr,1,ixOut));
         if (elemStr = '.T.') or (elemStr = '.F.') then
         begin
            resultStr := resultStr + opElemBoolean + elemStr + ExpElementEnd;
            Delete(workStr,1,ixOut);
            Result := true;
         end
         else
         begin
            raise EHalcyonExpression.Create(gsErrNoTrueFalse);
         end;
      end
      else
      begin
         raise EHalcyonExpression.Create(gsErrNoEndPeriod);
      end;
   end;
end;

      {Check for logical operators}
function TgsExpHandler.CheckForLogical(var workStr, resultStr: gsUTFString): boolean;
var
   ixOut: integer;
   ixFind: integer;
   elemStr: gsUTFString;
   cWork: gsUTFChar;
   cAction: gsUTFChar;
   bAction: boolean;
begin
   Result := false;
   if Length(workStr) = 0 then exit;
   cWork := workStr[1];
   if cWork in ['A'..'Z','a'..'z','.'] then
   begin
      ixOut := 2;
      while (ixOut <= Length(workStr)) and
            (workStr[ixOut] in ['A'..'Z','a'..'z']) do inc(ixOut);
      if (ixOut <= Length(workStr)) then
      begin
         if workStr[ixOut] = '.' then inc(ixOut);
         elemStr := AnsiUpperCase(copy(workStr,1,ixOut-1));
         if cWork = '.' then elemStr := copy(elemStr,2,ixOut-3);
         ixFind := 0;
         repeat
            bAction :=  ParserValueArray[ixFind] = elemStr;
            if bAction then
            begin
               cAction := ParserActionArray[ixFind];
               case cAction of
                  opElemEQ,
                  opElemNE,
                  opElemGT,
                  opElemLT,
                  opElemGE,
                  opElemLE,
                  opElemPOS,
                  opElemExactEQ     : begin
                                         cWork := opTypeRelat;
                                      end;
                  opElemPlus,
                  opElemMinus       : begin
                                         cWork := opTypeAdd;
                                      end;
                  opElemMultiply,
                  opElemDivide      : begin
                                         cWork := opTypeMult;
                                      end;
                  opElemNOT         : begin
                                         cWork := opTypeRelNot;
                                      end;
                  opElemAND         : begin
                                         cWork := opTypeRelAnd;
                                      end;
                  opElemOR         : begin
                                         cWork := opTypeRelOr;
                                      end;
                  opElemExponent    : begin
                                         cWork := opTypeUnary;
                                      end;
                  else                cWork := opTypeAdd;
               end;
               Delete(workStr,1,ixOut-1);
               resultStr := resultStr + cAction + cWork + ExpElementEnd;
               Result := true;
            end
            else
               inc(ixFind);
         until (bAction) or (ixFind=LogicValueCount);
      end;
   end;
end;

function TgsExpHandler.CheckForNegation(var workStr, resultStr: gsUTFString): boolean;
var
   ixOut: integer;
   elemStr: gsUTFString;
   cWork: gsUTFChar;
begin
   Result := false;
   if Length(workStr) = 0 then exit;
   cWork := workStr[1];
   if cWork in ['A'..'Z','a'..'z','.','!'] then
   begin
      if cWork <> '!' then
      begin
         ixOut := 2;
         while (ixOut <= Length(workStr)) and
               (workStr[ixOut] in ['A'..'Z','a'..'z']) do inc(ixOut);
      end
      else
         ixOut := 1;
      if (ixOut <= Length(workStr)) then
      begin
         if (workStr[ixOut] = '.') or (cWork = '!') then inc(ixOut);
         elemStr := AnsiUpperCase(copy(workStr,1,ixOut-1));
         if cWork = '.' then elemStr := copy(elemStr,2,ixOut-3);
         if (elemStr = 'NOT') or (elemStr = '!') then
         begin
            if length(resultStr) = 0 then
            begin
               Delete(workStr,1,ixOut-1);
               resultStr := resultStr + opElemNot + opTypeRelNot + ExpElementEnd;
               Result := true;
            end
            else
            begin
               workStr := '('+workStr+')';
            end;
         end;
      end;
   end;
end;

function TgsExpHandler.CompressExpression(const Value: gsUTFString): gsUTFString;
var
   workStr: gsUTFString;
   goodResult: boolean;
   needActor: boolean;
begin
   Result := '';
   workStr := Trim(Value);
   if Length(workStr) = 0 then exit;
   needActor := true;
   while Length(workStr) > 0 do
   begin
      if needActor then
      begin
         if CheckForNegation(workStr, Result) then workStr := TrimLeft(workStr);
         goodResult := (CheckForGroup(workStr,Result) or
                        CheckForTrueFalse(workStr,Result) or
                        CheckForEntity(workStr,Result) or
                        CheckForLiteral(workStr,Result) or
                        CheckForNumber(workStr,Result));
         needActor := not goodResult;
      end
      else
      begin
         goodResult := (CheckForOperator(workStr,Result) or
                        CheckForLogical(workStr,Result));
         needActor := goodResult;
      end;
      if not goodResult then
      begin
         raise EHalcyonExpression.CreateFmt(gsErrSyntax,[Value]);
      end;
      workStr := TrimLeft(workStr);
   end;
end;

function TgsExpHandler.GenerateObjects(const Value: gsUTFString): TgsExpBaseObject;
var
   NuString: gsUTFString;
   WkString: gsUTFString;
   NuType: gsUTFChar;
   NuOperator: gsUTFChar;
   ixPos: integer;
   ExpObject: TgsExpBaseObject;
   ExpResult: TgsExpBaseObject;
   SQLList: TList;
   i: integer;
   j: integer;
   t: gsUTFChar;
begin
   Result := nil;
   if Length(Value) = 0 then exit;
   WkString := Value;
   SQLList := TList.Create;
 try
   while (Length(WkString) > 0) do
   begin
      ixPos := Pos(ExpElementEnd,WkString);
      if ixPos = 0 then ixPos := Length(WkString)+1;
      NuString := copy(WkString,2,ixPos-2);
      NuType := WkString[1];
      Delete(WkString,1,ixPos);
      case NuType of
         opElemGroup          : begin     {grouped characters}
                                   ExpObject := TgsExpContainer.Create(Self,NuString);
                                   SQLList.Add(ExpObject);
                                end;
         opElemUnary,            {unary operators}
         opElemEQ..opElemLike : begin
                                   NuOperator := NuString[1];
                                   ExpObject := TgsExpOperator.Create(NuType,NuOperator);
                                   TgsExpOperator(ExpObject).FInsensitive := FInsensitive;
                                   TgsExpOperator(ExpObject).FWildCards := FWildCards;
                                   TgsExpOperator(ExpObject).FWildCharAll := FWildCharAll;
                                   TgsExpOperator(ExpObject).FWildCharOne := FWildCharOne;
                                   SQLList.Add(ExpObject);
                                end;
         opElemText           : begin     {literal/constant}
                                   ExpObject := TgsExpTextLit.Create(NuString);
                                   SQLList.Add(ExpObject);
                                   inc(FArgCount);
                                 end;
         opElemDate            : begin     {literal/constant}
                                    ExpObject := TgsExpDateLit.Create(NuString);
                                    SQLList.Add(ExpObject);
                                    inc(FArgCount);
                                 end;
         opElemFunction        : begin     {function}
                                    ExpObject := TgsExpFunction.Create(Self,NuString);
                                    SQLList.Add(ExpObject);
                                    inc(FArgCount);
                                 end;
         opElemVariable        : begin     {variable/field}
                                    if FUserLink = nil then
                                       ExpObject := nil
                                    else
                                    begin
                                       ExpObject := TgsExpFieldVar.Create(Self,AnsiUpperCase(NuString));
                                    end;
                                    if ExpObject <> nil then
                                       SQLList.Add(ExpObject)
                                    else
                                       raise EHalcyonExpression.CreateFMT
                                                (gsErrFieldInvalid,[NuString]);
                                    inc(FArgCount);
                                    if ExpObject.FExpLen > FExpLen then
                                       FExpLen := ExpObject.FExpLen;
                                    if ExpObject.FExpDec > FExpDec then
                                       FExpDec := ExpObject.FExpDec;
                                 end;
         opElemNumber          : begin     {numeric literal}
                                    ExpObject := TgsExpNumLit.Create(NuString);
                                    SQLList.Add(ExpObject);
                                    inc(FArgCount);
                                    if ExpObject.FExpLen > FExpLen then
                                       FExpLen := ExpObject.FExpLen;
                                    if ExpObject.FExpDec > FExpDec then
                                       FExpDec := ExpObject.FExpDec;
                                 end;
         opElemBoolean         : begin     {Boolean literal}
                                    ExpObject := TgsExpBlnLit.Create(NuString);
                                    SQLList.Add(ExpObject);
                                    inc(FArgCount);
                                 end;
      end;
   end;
   t := opTypeUnary;
   while (t <= opTypeRelOr) do
   begin
      ExpResult := nil;
      i := 0;
      while (ExpResult = nil) and (i < SQLList.Count) and
            (SQLList.Count > 1) do
      begin
         ExpObject := SQLList.Items[i];
         if ExpObject <> nil then
         begin
            if ExpObject.FExpType = etOperator then
            begin
               if TgsExpOperator(ExpObject).FPrecedence = t then
               begin
                  ExpResult := ExpObject;
                  j := i+1;
                  if j < SQLList.Count then
                  begin
                     ExpResult.FArgRight := SQLList.Items[j];
                     SQLList.Delete(j);
                  end;
                  if t <> opTypeRelNot then
                  begin
                     j := i-1;
                     if j >= 0 then
                     begin
                        ExpResult.FArgLeft := SQLList.Items[j];
                        SQLList.Delete(j);
                     end;
                  end;
                  ExpResult.FExpType := etContainer;
               end;
            end;
         end;
         inc(i);
      end;
      if ExpResult = nil then inc(t);
   end;
   if SQLList.Count = 1 then
      ExpResult := SQLList.Items[0]
   else
      raise EHalcyonExpression.Create(gsErrConstructBad);
   Result := ExpResult;
 except
   for i := 0 to SQLList.Count-1 do
      TObject(SQLList.Items[i]).Free;
   SQLList.Free;
   raise;
 end;
   SQLList.Free;
end;

{------------------------------------------------------------------------------
                           Setup and Exit Routines
------------------------------------------------------------------------------}

end.




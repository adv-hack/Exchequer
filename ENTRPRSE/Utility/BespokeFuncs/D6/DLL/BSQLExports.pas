unit BSQLExports;

interface
uses
  Windows, DataModule, ADOSQLUtil, Enterprise04_TLB, ComObj, ActiveX
  , BespokeBlowfish, BespokeXML, SpecialPassword, Variants, SQLUtils, Dialogs
  , SecCodes, Forms;

  // Useless function names used to export the functions, so that extrenally, no-one knows what the functions are!
  function A(var A : pChar; var AA : pChar) : LongInt; stdCall; // SQLGetExchequerDatabaseProperties 1
  function B(B : PChar; BB : WordBool; BBB : PChar) : LongInt; stdCall; //SQLSetUsername 2
  function C(C : PChar; CC : WordBool; CCC : PChar) : LongInt; stdCall; //SQLSetUserPassword 3
  function D(var D : PChar; DD : WordBool; DDD : PChar) : LongInt; stdCall; //SQLGetUsername 4
  function E(var E : PChar; EE : WordBool; EEE : PChar) : LongInt; stdCall; //SQLGetUserPassword 5
  function F(F : PChar; var FF : PChar) : LongInt; stdCall; //SQLGetBespokeDatabaseNameForCode 6
  function G(G : PChar; GG : wordbool; var GGG : PChar; GGGG : PChar) : LongInt; stdCall;//SQLBuildBespokeConnectionString 7
  function H(H : WordBool; HH, HHH, HHHH : PChar; var HHHHH : PChar) : LongInt; stdCall; //SQLBuildAdminConnectionString 8
  function I(I : wordbool; var II : PChar; III  : PChar) : LongInt; stdCall; //SQLBuildStandardConnectionString 9
  function J(J : WordBool; JJ : PChar) : LongInt; stdCall;//SQLAddDefaultUser 10
  function K(K : PChar; var KK : WordBool) : LongInt; stdCall;//SQLDatabaseExists 11
  function L(L, LL : PChar; var LLL : WordBool) : LongInt; stdCall;//SQLTableExists 12
  function M(M : WordBool; MM, MMM, MMMM : PChar; MMMMM  : PChar) : LongInt; stdCall;//SQLDatabaseDelete 13
  function N(N : WordBool; NN, NNN, NNNN : PChar; NNNNN  : PChar) : LongInt; stdCall;//SQLDatabaseCreate 14
  function O(O : PChar; var OO : WordBool) : LongInt; stdCall;//SQLLoginExists 15
  function P(P, PP : PChar; var PPP : WordBool) : LongInt; stdCall;//SQLUserExistsForDatabase 16
  function Q(Q : WordBool; QQ, QQQ, QQQQ, QQQQQ, QQQQQQ  : PChar) : LongInt; stdCall;//SQLLoginCreate 17
  function R(R : WordBool; RR, RRR, RRRR, RRRRR : PChar; RRRRRR : WordBool; RRRRRRR : PChar) : LongInt; stdCall;//SQLAddDatabaseUser 18
  function S(S : WordBool; SS, SSS, SSSS, SSSSS : PChar; SSSSSS : WordBool; SSSSSSS : PChar) : LongInt; stdCall;//SQLExecute 19
  procedure T(var T : PChar); stdCall;//SQLGetServerNamePervasive 20
  function U : WordBool; stdCall;//SQLExchVersionSQL 21
  procedure V(var a : LongInt; var b : LongInt; var c : LongInt; pSpecialPassword : PChar); stdCall;//Calls EncodeOpCode for COMTK Backdoor 22

  function SQLGetExchequerDatabaseProperties(var pDatabaseName : pChar; var pServerName : pChar) : LongInt;//A 1
  function SQLSetUsername(pUserName : PChar; bReadOnly : WordBool; pSpecialPassword : PChar) : LongInt;//B 2
  function SQLSetUserPassword(pUserPassword : PChar; bReadOnly : WordBool; pSpecialPassword : PChar) : LongInt;//C 3
  function SQLGetUsername(var pUserName : PChar; bReadOnly : WordBool; pSpecialPassword : PChar) : LongInt;//D 4
  function SQLGetUserPassword(var pUserPassword : PChar; bReadOnly : WordBool; pSpecialPassword : PChar) : LongInt;//E 5
  function SQLGetBespokeDatabaseNameForCode(pCode : PChar; var pDatabase : PChar) : LongInt;//F 6
  function SQLBuildBespokeConnectionString(pPlugInCode : PChar; bReadOnly : wordbool; var pConnectionString : PChar; pSpecialPassword : PChar) : LongInt;//G 7
  function SQLBuildAdminConnectionString(bWindowsAuth : WordBool; pUserName, pPassword, pDatabaseName : PChar; var pConnectionString : PChar) : LongInt;//H 8
  function SQLBuildStandardConnectionString(bReadOnly : wordbool; var pConnectionString : PChar; pSpecialPassword  : PChar) : LongInt;//I 9
  function SQLAddDefaultUser(bReadOnly : WordBool; pSpecialPassword : PChar) : LongInt;//J 10
  function SQLDatabaseExists(pDatabaseName : PChar; var bExists : WordBool) : LongInt;//K 11
  function SQLTableExists(pPlugInCode, pTableName : PChar; var bExists : WordBool) : LongInt;//L 12
  function SQLDatabaseDelete(bWindowsAuth : WordBool; pUserName, pPassword, pDatabaseName : PChar; pSpecialPassword  : PChar) : LongInt;//M 13
  function SQLDatabaseCreate(bWindowsAuth : WordBool; pUserName, pPassword, pDatabaseName : PChar; pSpecialPassword  : PChar) : LongInt;//N 14
  function SQLLoginExists(pLogin : PChar; var bExists : WordBool) : LongInt;//O 15
  function SQLUserExistsForDatabase(pUser, pDatabaseName : PChar; var bExists : WordBool) : LongInt;//P 16
  function SQLLoginCreate(bWindowsAuth : WordBool; pUserName, pPassword, pLoginName, pLoginPassword, pSpecialPassword  : PChar) : LongInt;//Q 17
  function SQLAddDatabaseUser(bWindowsAuth : WordBool; pSQLUserName, pSQLPassword, pUser, pDatabaseName : PChar; bReadOnly : WordBool; pSpecialPassword : PChar) : LongInt;//R 18
  function SQLExecute(bWindowsAuth : WordBool; pSQLUserName, pSQLPassword, pDatabaseName, pSQL : PChar; bShowErrors : WordBool; pSpecialPassword : PChar) : LongInt;//S 19
  procedure SQLGetServerNamePervasive(var pServerName : PChar);//T 20
  function SQLExchVersionSQL : WordBool;//U 21
//  procedure SQLEncodeOpCode(var a : LongInt; var b : LongInt; var c : LongInt);//V 22

implementation
uses
  SysUtils;

const
  iKey = 26;
  DEFAULT_READONLY_USERNAME = 'ExchBespokeUser_RO';
  DEFAULT_READWRITE_USERNAME = 'ExchBespokeUser_RW';
  DEFAULT_READONLY_PASSWORD = 'ExchBespoke_RO';


function A(var A : pChar; var AA : pChar) : LongInt; stdCall;
begin
  result := SQLGetExchequerDatabaseProperties(A, AA);
end;

function B(B : PChar; BB : WordBool; BBB : PChar) : LongInt; stdCall;
begin
  result := SQLSetUsername(B, BB, BBB);
end;

function C(C : PChar; CC : WordBool; CCC : PChar) : LongInt; stdCall;
begin
  result := SQLSetUserPassword(C, CC, CCC);
end;

function D(var D : PChar; DD : WordBool; DDD : PChar) : LongInt; stdCall;
begin
  result := SQLGetUsername(D, DD, DDD);
end;

function E(var E : PChar; EE : WordBool; EEE : PChar) : LongInt; stdCall;
begin
  result := SQLGetUserPassword(E, EE, EEE);
end;

function F(F : PChar; var FF : PChar) : LongInt; stdCall;
begin
  result := SQLGetBespokeDatabaseNameForCode(F, FF);
end;

function G(G : PChar; GG : wordbool; var GGG : PChar; GGGG : PChar) : LongInt; stdCall;
begin
  result := SQLBuildBespokeConnectionString(G, GG, GGG, GGGG);
end;

function H(H : WordBool; HH, HHH, HHHH : PChar; var HHHHH : PChar) : LongInt; stdCall;
begin
  result := SQLBuildAdminConnectionString(H, HH, HHH, HHHH, HHHHH);
end;

function I(I : wordbool; var II : PChar; III : PChar) : LongInt; stdCall;
begin
  result := SQLBuildStandardConnectionString(I, II, III);
end;

function J(J : WordBool; JJ : PChar) : LongInt; stdCall;
begin
  result := SQLAddDefaultUser(J, JJ);
end;

function K(K : PChar; var KK : WordBool) : LongInt; stdCall;
begin
  result := SQLDatabaseExists(K, KK);
end;

function L(L, LL : PChar; var LLL : WordBool) : LongInt; stdCall;
begin
  result := SQLTableExists(L, LL, LLL);
end;

function M(M : WordBool; MM, MMM, MMMM : PChar; MMMMM  : PChar) : LongInt; stdCall;
begin
  result := SQLDatabaseDelete(M, MM, MMM, MMMM, MMMMM);
end;

function N(N : WordBool; NN, NNN, NNNN : PChar; NNNNN : PChar) : LongInt; stdCall;
begin
  result := SQLDatabaseCreate(N, NN, NNN, NNNN, NNNNN);
end;

function O(O : PChar; var OO : WordBool) : LongInt; stdCall;
begin
  result := SQLLoginExists(O, OO);
end;

function P(P, PP : PChar; var PPP : WordBool) : LongInt; stdCall;
begin
  result := SQLUserExistsForDatabase(P, PP, PPP);
end;

function Q(Q : WordBool; QQ, QQQ, QQQQ, QQQQQ, QQQQQQ  : PChar) : LongInt; stdCall;
begin
  result := SQLLoginCreate(Q, QQ, QQQ, QQQQ, QQQQQ, QQQQQQ);
end;

function R(R : WordBool; RR, RRR, RRRR, RRRRR : PChar; RRRRRR : WordBool; RRRRRRR : PChar) : LongInt; stdCall;
begin
  result := SQLAddDatabaseUser(R, RR, RRR, RRRR, RRRRR, RRRRRR, RRRRRRR);
end;

function S(S : WordBool; SS, SSS, SSSS, SSSSS : PChar; SSSSSS : WordBool; SSSSSSS : PChar) : LongInt; stdCall;
begin
  result := SQLExecute(S, SS, SSS, SSSS, SSSSS, SSSSSS, SSSSSSS);
end;

procedure T(var T : PChar); stdCall;
begin
  SQLGetServerNamePervasive(T);
end;

function U : WordBool; stdCall;
begin
  result := SQLExchVersionSQL;
end;

procedure V(var a : LongInt; var b : LongInt; var c : LongInt; pSpecialPassword : PChar);
Var
  lpText, lpCaption : ANSIString;
  asSpecialPassword : ANSIString;
  bError : boolean;
begin
  bError := TRUE;
  try
    asSpecialPassword := pSpecialPassword;
    if (Trim(asSpecialPassword) <> '')  // check password blank
    and CheckPassword(asSpecialPassword) // check password correct
    and ((a = 232394) and (b = 902811231) and (c = -1298759273)) then // Check some hardocded numbers
    Begin
      a := 0;
      b := 0;
      c := 0;
     // NF: 18/06/2010
     // Changed to  97 - so it can create the standard Com TK backdoor
     // Not sure why it was set to 95......
      EncodeOpCode(97, a, b, c);
  //  EncodeOpCode(95, a, b, c);

      bError := FALSE;
    end;{if}
  except
    //
  end;{try}

  if bError then
  begin
    // Unlicenced use - do something nasty, hee, hee, hee!!!!
    Randomize;
    lpCaption := 'Error';
    lpText := Format ('%s caused an Access violation at address %8.8x in module KERNEL32.DLL'
    , [ExtractFileName(Application.Exename), Random(2147000000)]);
    MessageBox(0, PCHAR(lpText), PCHAR(lpCaption), MB_OK Or MB_ICONERROR Or MB_TASKMODAL);
  end;{if}
end;


function SQLGetExchequerDatabaseProperties(var pDatabaseName : pChar; var pServerName : pChar) : LongInt;

  function GetCSParameter(sParamName, sConnectionString : string) : ANSIstring;
  var
    iPos, iStartPos, iLength : integer;
  begin{GetCSParameter}
    iPos := Pos(sParamName, sConnectionString);
    if iPos < 0 then
    begin
      Result := ''
    end
    else
    begin
      iStartPos := iPos + Length(sParamName) + 1;
      iPos := Pos(';', Copy(sConnectionString, iStartPos, 255));
      if iPos < 0 then
      begin
        Result := '';
      end
      else
      begin
        iLength := iPos-1;
      end;{if}
      Result := Copy(sConnectionString, iStartPos, iLength);
    end;{if}
  end;{GetCSParameter}

var
  oToolkit : IToolkit;
  asServerName, asDatabaseName, asConnectionString : ANSIString;
begin
  Coinitialize(nil);
  oToolkit := CreateOLEObject('Enterprise04.Toolkit') as IToolkit;
  if Assigned(oToolkit) then
  begin
    if oToolkit.Company.cmCount > 0 then
    begin
      asConnectionString := (oToolkit.Company.cmCompany[1] as ICompanyDetail2).coConnect;
      if Trim(asConnectionString) <> '' then
      begin
        asServerName := GetCSParameter('Data Source', asConnectionString);
        if asServerName <> '' then
        begin
          asDatabaseName := GetCSParameter('Initial Catalog', asConnectionString);
          if asDatabaseName <> '' then
          begin
            StrPCopy(pServerName, asServerName);
            StrPCopy(pDatabaseName, asDatabaseName);
            Result := 0;
          end
          else
          begin
            Result := -5;
          end;{if}
        end
        else
        begin
          Result := -4;
        end;{if}
      end
      else
      begin
        Result := -3;
      end;{if}
    end
    else
    begin
      Result := -2;
    end;{if}

    // clear up
    oToolkit := nil;
  end
  else
  begin
    Result := -1;
  end;{if}
end;

function SQLSetUsername(pUserName : PChar; bReadOnly : WordBool; pSpecialPassword : PChar) : LongInt;
var
  asUserName, asSpecialPassword : ANSIString;
begin
  try
    asSpecialPassword := pSpecialPassword;
    if Trim(asSpecialPassword) = '' then
    begin
      Result := -2;
    end
    else
    begin
      if CheckPassword({iKey, }asSpecialPassword) then
      begin
        asUserName := pUserName;

{        if Trim(asUserName) = '' then
        begin
          Result := -4;
        end
        else
        begin}
          Result := SetXMLUserInfo(TRUE, bReadOnly, asUserName);
{        end;{if}
      end
      else
      begin
        Result := -3;
      end;{if}
    end;{if}
  except
    Result := -1;
  end;
end;

function SQLSetUserPassword(pUserPassword : PChar; bReadOnly : WordBool; pSpecialPassword : PChar) : LongInt;
var
  asSpecialPassword, asUserPassword : ANSIString;
begin
  try
    asSpecialPassword := pSpecialPassword;
    if Trim(asSpecialPassword) = '' then
    begin
      Result := -2;
    end
    else
    begin
      if CheckPassword({iKey, }asSpecialPassword) then
      begin
        asUserPassword := pUserPassword;
{        if Trim(asUserPassword) = '' then
        begin
          Result := -4;
        end
        else
        begin}
          Result := SetXMLUserInfo(FALSE, bReadOnly, asUserPassword);
//        end;{if}
      end
      else
      begin
        Result := -3;
      end;{if}
    end;{if}
  except
    Result := -1;
  end;
end;

function SQLGetUsername(var pUserName : PChar; bReadOnly : WordBool; pSpecialPassword : PChar) : LongInt; 
var
  asUserName, asSpecialPassword : ANSIString;
begin
  try
    asSpecialPassword := pSpecialPassword;
    if Trim(asSpecialPassword) = '' then
    begin
      Result := -2;
    end
    else
    begin
      if CheckPassword({iKey, }asSpecialPassword) then
      begin
        Result := GetXMLUserInfo(TRUE, bReadOnly, asUserName);
        if Result = 0 then
        begin
          if Trim(asUserName) = '' then
          begin
            Result := -4;
          end
          else
          begin
            StrPCopy(pUserName, asUserName);
          end;{if}
        end
      end
      else
      begin
        Result := -3;
      end;{if}
    end;{if}
  except
    Result := -1;
  end;{try}
end;

function SQLGetUserPassword(var pUserPassword : PChar; bReadOnly : WordBool; pSpecialPassword : PChar) : LongInt; 
var
  asUserPassword, asSpecialPassword : ANSIString;
begin
  try
    asSpecialPassword := pSpecialPassword;
    if Trim(asSpecialPassword) = '' then
    begin
      Result := -2;
    end
    else
    begin
      if CheckPassword({iKey, }asSpecialPassword) then
      begin
        Result := GetXMLUserInfo(FALSE, bReadOnly, asUserPassword);
        if Result = 0 then
        begin
          if Trim(asUserPassword) = '' then
          begin
            Result := -4;
          end
          else
          begin
            StrPCopy(pUserPassword, asUserPassword);
            Result := 0;
          end;{if}
        end;{if}
      end
      else
      begin
        Result := -3;
      end;{if}
    end;{if}
  except
    Result := -1;
  end;{try}
end;

function SQLGetBespokeDatabaseNameForCode(pCode : PChar; var pDatabase : PChar) : LongInt; 
var
  DatabaseInfo : TDatabaseInfo;
begin
  try
    DatabaseInfo := TDatabaseInfo.create;
    DatabaseInfo.Code := pCode;
    Result := DatabaseInfo.PopulateFromCode;
    if Result = 0 then StrPCopy(pDatabase, DatabaseInfo.Database);
    DatabaseInfo.Free;
  except
    Result := -1;
  end;
end;

function SQLBuildBespokeConnectionString(pPlugInCode : PChar; bReadOnly : wordbool; var pConnectionString : PChar; pSpecialPassword  : PChar) : LongInt; 
var
  pUserPassword, pUserName, pServerName, pExchDatabaseName, pDatabase : PChar;
  asConnectionString : ANSIString;
begin
  // initialise
  pDatabase := StrAlloc(255);
  pExchDatabaseName := StrAlloc(255);
  pServerName := StrAlloc(255);
  pUserName := StrAlloc(255);
  pUserPassword := StrAlloc(255);

  // Get Database Name for Code
  Result := SQLGetBespokeDatabaseNameForCode(pPlugInCode, pDatabase);
  if Result = 0 then
  begin
    // Exchequer MS-SQL ?
    if UsingSQL then
    begin
      // Get Exchequer Database Name and Server
      Result := SQLGetExchequerDatabaseProperties(pExchDatabaseName, pServerName);
      if Result <> 0 then
      begin
        Result := Result - 2000;
      end;{if}
    end
    else
    begin
      SQLGetServerNamePervasive(pServerName);
    end;{if}

    if Result = 0 then
    begin
      // Get User Name
      Result := SQLGetUsername(pUserName, bReadOnly, pSpecialPassword);
      if Result = 0 then
      begin
        // Get User Password
        Result := SQLGetUserPassword(pUserPassword, bReadOnly, pSpecialPassword);
        if Result = 0 then
        begin
          asConnectionString := 'Data Source=' + pServerName + ';Initial Catalog='
          + pDatabase + ';User Id=' + pUserName + ';Password=' + pUserPassword + ';';
          StrPCopy(pConnectionString, asConnectionString);
        end
        else
        begin
          Result := Result - 4000;
        end;{if}
      end
      else
      begin
        Result := Result - 3000;
      end;{if}
    end
    else
    begin
      Result := Result - 2000;
    end;{if}
  end
  else
  begin
    Result := Result - 1000;
  end;{if}

  // clear up
  StrDispose(pDatabase);
  StrDispose(pExchDatabaseName);
  StrDispose(pServerName);
  StrDispose(pUserName);
  StrDispose(pUserPassword);
end;

function SQLBuildAdminConnectionString(bWindowsAuth : WordBool; pUserName, pPassword, pDatabaseName : PChar; var pConnectionString : PChar) : LongInt; 
var
  pServerName, pExchDatabaseName : PChar;
  asConnectionString : ANSIString;
begin
  // initialise
  pExchDatabaseName := StrAlloc(255);
  pServerName := StrAlloc(255);
  Result := 0;

  if UsingSQL then
  begin
    // Get Exchequer Database Name and Server
    Result := SQLGetExchequerDatabaseProperties(pExchDatabaseName, pServerName);
    if Result <> 0 then
    begin
      Result := Result - 2000;
    end;{if}
  end
  else
  begin
    SQLGetServerNamePervasive(pServerName);
//    pExchDatabaseName := 'Master';
  end;{if}

  if (Result= 0) then // Continue
  begin
    if bWindowsAuth then
    begin
      asConnectionString := 'Data Source=' + pServerName + ';Initial Catalog='
      + pDatabaseName + ';Integrated Security=SSPI;';
      StrPCopy(pConnectionString, asConnectionString);
    end
    else
    begin
      asConnectionString := 'Data Source=' + pServerName + ';Initial Catalog='
      + pDatabaseName + ';User Id=' + pUserName + ';Password=' + pPassword + ';';
      StrPCopy(pConnectionString, asConnectionString);
    end;{if}
  end;{if}

  // clear up
  StrDispose(pExchDatabaseName);
  StrDispose(pServerName);
end;

function SQLBuildStandardConnectionString(bReadOnly : wordbool; var pConnectionString : PChar; pSpecialPassword  : PChar) : LongInt; 
var
  pUserPassword, pUserName, pServerName, pExchDatabaseName, pDatabase : PChar;
  asConnectionString : ANSIString;
begin
  // initialise
  pDatabase := StrAlloc(255);
  pExchDatabaseName := StrAlloc(255);
  pServerName := StrAlloc(255);
  pUserName := StrAlloc(255);
  pUserPassword := StrAlloc(255);
  Result := 0;

  if UsingSQL then
  begin
    // Get Exchequer Database Name and Server
    Result := SQLGetExchequerDatabaseProperties(pExchDatabaseName, pServerName);
    if Result <> 0 then
    begin
      Result := Result - 2000;
    end;{if}
  end
  else
  begin
    SQLGetServerNamePervasive(pServerName);
    StrPCopy(pExchDatabaseName, 'MASTER');
  end;{if}

  if Result = 0 then
  begin
    // Get User Name
    Result := SQLGetUsername(pUserName, bReadOnly, pSpecialPassword);
    if Result = 0 then
    begin
      // Get User Password
      Result := SQLGetUserPassword(pUserPassword, bReadOnly, pSpecialPassword);
      if Result = 0 then
      begin
        asConnectionString := 'Data Source=' + pServerName + ';Initial Catalog='
        + pExchDatabaseName + ';User Id=' + pUserName + ';Password=' + pUserPassword + ';';
        StrPCopy(pConnectionString, asConnectionString);
      end
      else
      begin
        Result := Result - 4000;
      end;{if}
    end
    else
    begin
      Result := Result - 3000;
    end;{if}
  end
  else
  begin
    Result := Result - 2000;
  end;{if}

  // clear up
  StrDispose(pDatabase);
  StrDispose(pExchDatabaseName);
  StrDispose(pServerName);
  StrDispose(pUserName);
  StrDispose(pUserPassword);
end;

function SQLAddDefaultUser(bReadOnly : WordBool; pSpecialPassword : PChar) : LongInt; 

  function GenerateRandomPassword : string;
  var
    iRandom : Byte;
  begin{GenerateRandomPassword}
    Result := '';
    Randomize;
    Repeat
      iRandom := Random(122);
      if (iRandom in [48..57, 65..90, 97..122])
      then Result := Result + Char(iRandom);
    Until Length(Result) = 16;
  end;{GenerateRandomPassword}

var
  asUserName, asSpecialPassword : ANSIString;
begin
  try
    asSpecialPassword := pSpecialPassword;
    if Trim(asSpecialPassword) = '' then
    begin
      Result := -2;
    end
    else
    begin
      if CheckPassword({iKey, }asSpecialPassword) then
      begin
        // Get User Name
        Result := GetXMLUserInfo(TRUE, bReadOnly, asUserName);
        if Result = 0 then
        begin
          if Trim(asUserName) = '' then
          begin
            if bReadOnly then
            begin
              Result := SetXMLUserInfo(TRUE, bReadOnly, DEFAULT_READONLY_USERNAME);
              if Result = 0 then
              begin
                Result := SetXMLUserInfo(FALSE, bReadOnly, DEFAULT_READONLY_PASSWORD);
                if Result <> 0 then
                begin
                  Result := Result -3000;
                end;{if}
              end
              else
              begin
                Result := Result -2000;
              end;{if}
            end
            else
            begin
              Result := SetXMLUserInfo(TRUE, bReadOnly, DEFAULT_READWRITE_USERNAME);
              if Result = 0 then
              begin
                Result := SetXMLUserInfo(FALSE, bReadOnly, GenerateRandomPassword);
                if Result <> 0 then
                begin
                  Result := Result -5000;
                end;{if}
              end
              else
              begin
                Result := Result -4000;
              end;{if}
            end;{if}
          end
          else
          begin
            Result := -4;
          end;{if}
        end
        else
        begin
          Result := Result -1000;
        end;{if}
      end
      else
      begin
        Result := -3;
      end;{if}
    end;{if}
  except
    Result := -1;
  end;{try}
end;

function SQLDatabaseExists(pDatabaseName : PChar; var bExists : WordBool) : LongInt; 
var
  pSpecialPassword, pConnectionString : PChar;
  asDatabaseName, asConnectionString : ANSIString;
  SQLDataModule : TSQLDataModule;
begin
  SQLDataModule := TSQLDataModule.Create(nil);
  try
    // initialise
    Result := -1;
    bExists := FALSE;
    asDatabaseName := pDatabaseName;
    pConnectionString := StrAlloc(255);
    pSpecialPassword := StrAlloc(255);

    StrPCopy(pSpecialPassword, GetPassword{(iKey)});

    if SQLDataModule.ADOConnectionStandard.ConnectionString = '' then
    begin
      Result := SQLBuildStandardConnectionString(TRUE, pConnectionString, pSpecialPassword);
      if Result = 0 then
      begin
        asConnectionString := pConnectionString;
        SQLDataModule.ADOConnectionStandard.ConnectionString := asConnectionString;
      end
      else
      begin
        Result := Result - 1000;
      end;{if}
    end;{if}

    if Result = 0 then
    begin
      SQLDataModule.qDatabaseExists.Parameters.ParamByName('DatabaseName').Value := asDatabaseName;
      if ExecuteSQL(SQLDataModule.qDatabaseExists, TRUE, TRUE) then
      begin
        bExists := SQLDataModule.qDatabaseExists.Fields[0].Value = 1;
        SQLDataModule.qDatabaseExists.Active := FALSE;
      end
      else
      begin
        Result := -2;
      end;{if}
    end;{if}

    // clear up
    StrDispose(pConnectionString);
    StrDispose(pSpecialPassword);
  finally
    SQLDataModule.Free;
  end;{try}
end;

function SQLTableExists(pPlugInCode, pTableName : PChar; var bExists : WordBool) : LongInt; 
var
  pDatabaseName, pSpecialPassword, pConnectionString : PChar;
  asTableName, asConnectionString : ANSIString;
  SQLDataModule : TSQLDataModule;
begin
  SQLDataModule := TSQLDataModule.Create(nil);
  try
    // initialise
    bExists := FALSE;
    pConnectionString := StrAlloc(255);
    pSpecialPassword := StrAlloc(255);
    pDatabaseName := StrAlloc(255);
    StrPCopy(pSpecialPassword, GetPassword{(iKey)});
    asTableName := pTableName;

    Result := SQLGetBespokeDatabaseNameForCode(pPlugInCode, pDatabaseName);
    if Result = 0 then
    begin
      Result := SQLDatabaseExists(pDatabaseName, bExists);
      if Result = 0 then
      begin
        if bExists then
        begin
          Result := SQLBuildBespokeConnectionString(pPlugInCode, TRUE, pConnectionString, pSpecialPassword);
          if Result = 0 then
          begin
            asConnectionString := pConnectionString;
            SQLDataModule.ADOConnectionBespoke.ConnectionString := asConnectionString;

//            SQLDataModule.qTableExists.Parameters.ParamByName('TableName').Value := QuotedStr('dbo.' + asTableName);

            SQLDataModule.qTableExists.SQL.Text := 'SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(''dbo.' + asTableName + ''') AND type in (N''U'')';

            if ExecuteSQL(SQLDataModule.qTableExists, TRUE, TRUE) then
            begin
//              bExists := SQLDataModule.qTableExists.Fields[0].Value = 1;
//              SQLDataModule.qTableExists.Active := FALSE;

//              bExists := not VarIsNull(SQLDataModule.qTableExists.Fields[0].Value);
              bExists := SQLDataModule.qTableExists.RecordCount > 0;
              SQLDataModule.qTableExists.Active := FALSE;
            end
            else
            begin
              Result := -1;
            end;{if}
          end
          else
          begin
            Result := Result - 3000;
          end;{if}
        end;{if}
      end
      else
      begin
        Result := Result - 2000;
      end;{if}
    end
    else
    begin
      Result := Result - 1000;
    end;{if}

    // clear up
    StrDispose(pConnectionString);
    StrDispose(pSpecialPassword);
    StrDispose(pDatabaseName);
  finally
    SQLDataModule.Free;
  end;{try}
end;

function SQLDatabaseDelete(bWindowsAuth : WordBool; pUserName, pPassword, pDatabaseName : PChar; pSpecialPassword  : PChar) : LongInt; 
var
  asDatabaseName, asConnectionString, asSpecialPassword : ANSIString;
  pServerName, pExchDatabaseName, pConnectionString : PChar;
  SQLDataModule : TSQLDataModule;
begin
  SQLDataModule := TSQLDataModule.Create(nil);
  try
    try
      // Get Exchequer Database Name and Server
      pExchDatabaseName := StrAlloc(255);
      pServerName := StrAlloc(255);
      Result := SQLGetExchequerDatabaseProperties(pExchDatabaseName, pServerName);
      if Result = 0 then
      begin
        pConnectionString := StrAlloc(255);
        asSpecialPassword := pSpecialPassword;
        asDatabaseName := pDatabaseName;
        if Trim(asSpecialPassword) = '' then
        begin
          Result := -2;
        end
        else
        begin
          if CheckPassword({iKey, }asSpecialPassword) then
          begin
            Result := SQLBuildAdminConnectionString(bWindowsAuth, pUserName, pPassword, pExchDatabaseName, pConnectionString);
            if Result = 0 then
            begin
              asConnectionString := pConnectionString;
              SQLDataModule.ADOConnectionAdmin.ConnectionString := asConnectionString;

  //            SQLDataModule.qDeleteDatabase.Parameters.ParamByName('DatabaseName').Value := asDatabaseName;
              SQLDataModule.qDeleteDatabase.SQL.Text := 'DROP DATABASE "' + asDatabaseName + '"';

              if not ExecuteSQL(SQLDataModule.qDeleteDatabase, FALSE, TRUE) then
              begin
                Result := -10;
              end;{if}
            end
            else
            begin
              Result := Result - 1000;
            end;{if}
          end
          else
          begin
            Result := -3;
          end;{if}
        end;{if}
        StrDispose(pConnectionString);
      end
      else
      begin
        Result := Result - 2000;
      end;{if}

      StrDispose(pExchDatabaseName);
      StrDispose(pServerName);
    except
      Result := -1;
    end;{try}
  finally
    SQLDataModule.Free;
  end;{try}
end;


function SQLDatabaseCreate(bWindowsAuth : WordBool; pUserName, pPassword, pDatabaseName : PChar; pSpecialPassword  : PChar) : LongInt; 
var
  asDatabaseName, asConnectionString, asSpecialPassword : ANSIString;
  pExchDatabaseName, pServerName, pConnectionString : PChar;
  SQLDataModule : TSQLDataModule;
begin
  SQLDataModule := TSQLDataModule.Create(nil);
  try
    try
      // Get Exchequer Database Name and Server
      pExchDatabaseName := StrAlloc(255);
      pServerName := StrAlloc(255);
      Result := SQLGetExchequerDatabaseProperties(pExchDatabaseName, pServerName);
      if Result = 0 then
      begin
        pConnectionString := StrAlloc(255);
        asSpecialPassword := pSpecialPassword;
        asDatabaseName := pDatabaseName;
        if Trim(asSpecialPassword) = '' then
        begin
          Result := -2;
        end
        else
        begin
          if CheckPassword({iKey, }asSpecialPassword) then
          begin
            Result := SQLBuildAdminConnectionString(bWindowsAuth, pUserName, pPassword, pExchDatabaseName, pConnectionString);
            if Result = 0 then
            begin
              asConnectionString := pConnectionString;
              SQLDataModule.ADOConnectionAdmin.ConnectionString := asConnectionString;

  //            SQLDataModule.qCreateDatabase.Parameters.ParamByName('DatabaseName').Value := asDatabaseName;
              SQLDataModule.qCreateDatabase.SQL.Text := 'CREATE DATABASE "' + asDatabaseName + '"';

              if not ExecuteSQL(SQLDataModule.qCreateDatabase, FALSE, TRUE) then
              begin
                Result := -10;
              end;{if}
            end
            else
            begin
              Result := Result - 1000;
            end;{if}
          end
          else
          begin
            Result := -3;
          end;{if}
        end;{if}
        StrDispose(pConnectionString);
      end
      else
      begin
        Result := Result - 2000;
      end;{if}
      StrDispose(pExchDatabaseName);
      StrDispose(pServerName);
    except
      Result := -1;
    end;{try}
  finally
    SQLDataModule.Free;
  end;{try}
end;

function SQLLoginExists(pLogin : PChar; var bExists : WordBool) : LongInt; 
var
  pSpecialPassword, pConnectionString : PChar;
  asLogin, asConnectionString : ANSIString;
  SQLDataModule : TSQLDataModule;
begin
  SQLDataModule := TSQLDataModule.Create(nil);
  try
    // initialise
    Result := -1;
    bExists := FALSE;
    asLogin := pLogin;
    pConnectionString := StrAlloc(255);
    pSpecialPassword := StrAlloc(255);

    StrPCopy(pSpecialPassword, GetPassword{(iKey)});

    if SQLDataModule.ADOConnectionStandard.ConnectionString = '' then
    begin
      Result := SQLBuildStandardConnectionString(TRUE, pConnectionString, pSpecialPassword);
      if Result = 0 then
      begin
        asConnectionString := pConnectionString;
        SQLDataModule.ADOConnectionStandard.ConnectionString := asConnectionString;
      end
      else
      begin
        Result := Result - 1000;
      end;{if}
    end;{if}

    if Result = 0 then
    begin
      SQLDataModule.qLoginExists.Parameters.ParamByName('Login').Value := asLogin;
      if ExecuteSQL(SQLDataModule.qLoginExists, TRUE, TRUE) then
      begin
        bExists := not VarIsNull(SQLDataModule.qLoginExists.Fields[0].Value);
        SQLDataModule.qLoginExists.Active := FALSE;
      end
      else
      begin
        Result := -2;
      end;{if}
    end;{if}

    // clear up
    StrDispose(pConnectionString);
    StrDispose(pSpecialPassword);
  finally
    SQLDataModule.Free;
  end;{try}
end;

function SQLUserExistsForDatabase(pUser, pDatabaseName : PChar; var bExists : WordBool) : LongInt; 

  function SQLBuildConnectionStringforDatabase(pDatabase : PChar; bReadOnly : wordbool; var pConnectionString : PChar; pSpecialPassword  : PChar) : LongInt;
  var
    pUserPassword, pUserName, pServerName, pExchDatabaseName : PChar;
    asConnectionString : ANSIString;
  begin{SQLBuildConnectionStringforDatabase}
    // initialise
    pExchDatabaseName := StrAlloc(255);
    pServerName := StrAlloc(255);
    pUserName := StrAlloc(255);
    pUserPassword := StrAlloc(255);
    Result := 0;

    if UsingSQL then
    begin
      // Get Exchequer Database Name and Server
      Result := SQLGetExchequerDatabaseProperties(pExchDatabaseName, pServerName);
      if Result <> 0 then
      begin
        Result := Result - 2000;
      end;{if}
    end
    else
    begin
      SQLGetServerNamePervasive(pServerName);
    end;{if}

    if Result = 0 then
    begin
      // Get User Name
      Result := SQLGetUsername(pUserName, bReadOnly, pSpecialPassword);
      if Result = 0 then
      begin
        // Get User Password
        Result := SQLGetUserPassword(pUserPassword, bReadOnly, pSpecialPassword);
        if Result = 0 then
        begin
          asConnectionString := 'Data Source=' + pServerName + ';Initial Catalog='
          + pDatabase + ';User Id=' + pUserName + ';Password=' + pUserPassword + ';';
          StrPCopy(pConnectionString, asConnectionString);
        end
        else
        begin
          Result := Result - 4000;
        end;{if}
      end
      else
      begin
        Result := Result - 3000;
      end;{if}
    end
    else
    begin
      Result := Result - 2000;
    end;{if}

    // clear up
    StrDispose(pExchDatabaseName);
    StrDispose(pServerName);
    StrDispose(pUserName);
    StrDispose(pUserPassword);
  end;{SQLBuildConnectionStringforDatabase}

var
  pSpecialPassword, pConnectionString : PChar;
  asUser, asConnectionString : ANSIString;
  SQLDataModule : TSQLDataModule;
begin
  SQLDataModule := TSQLDataModule.Create(nil);
  try
    // initialise
    Result := -1;
    bExists := FALSE;
    asUser := pUser;
    pConnectionString := StrAlloc(255);
    pSpecialPassword := StrAlloc(255);

    StrPCopy(pSpecialPassword, GetPassword{(iKey)});

    Result := SQLBuildConnectionStringforDatabase(pDatabaseName, TRUE, pConnectionString, pSpecialPassword);
    if Result = 0 then
    begin
      asConnectionString := pConnectionString;
      SQLDataModule.ADOConnectionBespoke.ConnectionString := asConnectionString;
    end
    else
    begin
      Result := Result - 1000;
    end;{if}

    if Result = 0 then
    begin
      SQLDataModule.qUserExists.Parameters.ParamByName('User').Value := asUser;
      if ExecuteSQL(SQLDataModule.qUserExists, TRUE, FALSE) then
      begin
        bExists := not VarIsNull(SQLDataModule.qUserExists.Fields[0].Value);
        SQLDataModule.qUserExists.Active := FALSE;
      end
      else
      begin
        Result := -2;
      end;{if}
    end;{if}

    // clear up
    StrDispose(pConnectionString);
    StrDispose(pSpecialPassword);
  finally
    SQLDataModule.Free;
  end;{try}
end;

function SQLLoginCreate(bWindowsAuth : WordBool; pUserName, pPassword, pLoginName, pLoginPassword, pSpecialPassword  : PChar) : LongInt; 
var
  asLoginPassword, asLogin, asConnectionString, asSpecialPassword : ANSIString;
  {pExchDatabaseName, pServerName,} pConnectionString : PChar;
  SQLDataModule : TSQLDataModule;
begin
  SQLDataModule := TSQLDataModule.Create(nil);
  try
    try
      // Get Exchequer Database Name and Server
//      pExchDatabaseName := StrAlloc(255);
//      pServerName := StrAlloc(255);
//      Result := SQLGetExchequerDatabaseProperties(pExchDatabaseName, pServerName);
//      if Result = 0 then
//      begin
        pConnectionString := StrAlloc(255);
        asSpecialPassword := pSpecialPassword;
        asLogin := pLoginName;
        asLoginPassword := pLoginPassword;
        if Trim(asSpecialPassword) = '' then
        begin
          Result := -2;
        end
        else
        begin
          if CheckPassword({iKey, }asSpecialPassword) then
          begin
            Result := SQLBuildAdminConnectionString(bWindowsAuth, pUserName, pPassword, 'MASTER', pConnectionString);
            if Result = 0 then
            begin
              asConnectionString := pConnectionString;
              SQLDataModule.ADOConnectionAdmin.ConnectionString := asConnectionString;

//              SQLDataModule.qCreateLogin.Parameters.ParamByName('Login').Value := asLogin;
//              SQLDataModule.qCreateLogin.Parameters.ParamByName('Password').Value := asLoginPassword;

              SQLDataModule.qCreateLogin.SQL.Text := 'CREATE LOGIN [' + asLogin + ']'
              + ' WITH PASSWORD=''' + asLoginPassword  +
              ''' , DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF';

              if not ExecuteSQL(SQLDataModule.qCreateLogin, FALSE, TRUE) then
              begin
                Result := -10;
              end;{if}
            end
            else
            begin
              Result := Result - 1000;
            end;{if}
          end
          else
          begin
            Result := -3;
          end;{if}
        end;{if}
        StrDispose(pConnectionString);
{      end
      else
      begin
        Result := Result -2000;
      end;{if}

//      StrDispose(pExchDatabaseName);
//      StrDispose(pServerName);
    except
      Result := -1;
    end;{try}
  finally
    SQLDataModule.Free;
  end;{try}
end;

function SQLAddDatabaseUser(bWindowsAuth : WordBool; pSQLUserName, pSQLPassword, pUser, pDatabaseName : PChar; bReadOnly : WordBool; pSpecialPassword : PChar) : LongInt; 
var
  asRole, asDatabaseName, asUser, asConnectionString, asSpecialPassword : ANSIString;
  pConnectionString : PChar;
  SQLDataModule : TSQLDataModule;
begin
  SQLDataModule := TSQLDataModule.Create(nil);
  try
    try
      // Get Exchequer Database Name and Server
//      pDatabaseName := StrAlloc(255);
//      pServerName := StrAlloc(255);
//      Result := SQLGetExchequerDatabaseProperties(pDatabaseName, pServerName);
//      if Result = 0 then
//      begin
        pConnectionString := StrAlloc(255);
        asSpecialPassword := pSpecialPassword;
        asUser := pUser;
        asDatabaseName := pDatabaseName;
        if Trim(asSpecialPassword) = '' then
        begin
          Result := -2;
        end
        else
        begin
          if CheckPassword({iKey, }asSpecialPassword) then
          begin
            Result := SQLBuildAdminConnectionString(bWindowsAuth, pSQLUserName, pSQLPassword, pDatabaseName, pConnectionString);
            if Result = 0 then
            begin
              asConnectionString := pConnectionString;
              SQLDataModule.ADOConnectionAdmin.ConnectionString := asConnectionString;

//              SQLDataModule.qCreateLogin.Parameters.ParamByName('Login').Value := asLogin;
//              SQLDataModule.qCreateLogin.Parameters.ParamByName('Password').Value := asLoginPassword;

              // Create User
              SQLDataModule.qCreateUserDatabase.SQL.Text := 'CREATE USER [' + asUser + '] FOR LOGIN ['+ asUser +'] WITH DEFAULT_SCHEMA=[dbo]';
              if ExecuteSQL(SQLDataModule.qCreateUserDatabase, FALSE, TRUE) then
              begin
                SQLDataModule.qCreateUserDatabase.Active := FALSE;

                if bReadOnly then asRole := 'db_datareader'
                else asRole := 'db_owner';

                // Add Role Member (basically the User Rights)
                SQLDataModule.qCreateUserDatabase.SQL.Text := 'DECLARE @Result int '
                + 'EXEC @Result = sp_addrolemember ''' + asRole + ''', ''' + asUser + ''''
                + 'SELECT @Result';

                if ExecuteSQL(SQLDataModule.qCreateUserDatabase, TRUE, TRUE) then
                begin
                  // Read Return Value of sp_addrolemember
                  if SQLDataModule.qCreateUserDatabase.Fields[0].Value = 0  //Success
                  then Result := 0
                  else Result := -12;

                  SQLDataModule.qCreateUserDatabase.Active := FALSE;
                end
                else
                begin
                  SQLDataModule.qCreateUserDatabase.Active := FALSE;
                  Result := -11;
                end;{if}

              end
              else
              begin
                Result := -10;
              end;{if}
            end
            else
            begin
              Result := Result - 1000;
            end;{if}
          end
          else
          begin
            Result := -3;
          end;{if}
        end;{if}
        StrDispose(pConnectionString);
//      end
//      else
//      begin
//        Result := Result -1000;
//      end;{if}

//      StrDispose(pDatabaseName);
//      StrDispose(pServerName);
    except
      Result := -1;
    end;{try}
  finally
    SQLDataModule.Free;
  end;{try}
end;

function SQLExecute(bWindowsAuth : WordBool; pSQLUserName, pSQLPassword, pDatabaseName, pSQL : PChar; bShowErrors : WordBool; pSpecialPassword : PChar) : LongInt; 
var
  asSQL, asDatabaseName, asConnectionString, asSpecialPassword : ANSIString;
  pConnectionString : PChar;
  SQLDataModule : TSQLDataModule;
begin
  SQLDataModule := TSQLDataModule.Create(nil);
  try
    try
      // Get Exchequer Database Name and Server
//      pDatabaseName := StrAlloc(255);
//      pServerName := StrAlloc(255);
//      Result := SQLGetExchequerDatabaseProperties(pDatabaseName, pServerName);
//      if Result = 0 then
//      begin
        pConnectionString := StrAlloc(255);
        asSpecialPassword := pSpecialPassword;
        asSQL := pSQL;
        asDatabaseName := pDatabaseName;
        if Trim(asSpecialPassword) = '' then
        begin
          Result := -2;
        end
        else
        begin
          if CheckPassword({iKey, }asSpecialPassword) then
          begin
            Result := SQLBuildAdminConnectionString(bWindowsAuth, pSQLUserName, pSQLPassword, pDatabaseName, pConnectionString);
            if Result = 0 then
            begin
              asConnectionString := pConnectionString;
              SQLDataModule.ADOConnectionAdmin.ConnectionString := asConnectionString;
              SQLDataModule.qSQL.SQL.Text := asSQL;

              if not ExecuteSQL(SQLDataModule.qSQL, FALSE, bShowErrors) then
              begin
                Result := -10;
              end;{if}
            end
            else
            begin
              Result := Result - 1000;
            end;{if}
          end
          else
          begin
            Result := -3;
          end;{if}
        end;{if}
        StrDispose(pConnectionString);
//      end
//      else
//      begin
//        Result := Result -1000;
//      end;{if}

//      StrDispose(pDatabaseName);
//      StrDispose(pServerName);
    except
      Result := -1;
    end;{try}
  finally
    SQLDataModule.Free;
  end;{try}
end;

procedure SQLGetServerNamePervasive(var pServerName : PChar);
var
  asServerName : ANSIString;
const
  sDefaultServerName = '<computer_name>\IRISSOFTWARE';
begin
  asServerName := GetServerNamePervasive;
  if asServerName = '' then
  begin
    // Ask for servername
    asServerName := InputBox('Please enter your MS-SQL Server Name', 'MS-SQL Server Name', sDefaultServerName);
    if asServerName <> sDefaultServerName then
    begin
      // Write servername to XML file
      StrPCopy(pServerName, asServerName);
      SetServerNamePervasive(pServerName);
    end;{if}
  end
  else
  begin
    // Return Servername found
    StrPCopy(pServerName, asServerName);
  end;{if}
end;

function SQLExchVersionSQL : WordBool;
begin
  Result := UsingSQL;
end;

end.

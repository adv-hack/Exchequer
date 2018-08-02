unit BespokeXML;

interface
uses
  MiscUtil, SysUtils, Dialogs, Classes, GMXML, BespokeBlowfish
  , SQLLogin, APIUtil, SpecialPassword, BespokeFuncsInterface;

//  procedure ReadScript(nParentNode : TGMXMLNode; sNodeDesc : string; slScript : TStringList);
  function GetScriptsNode(nParent : TGMXMLNode; bCreate : boolean) : TGMXMLNode;
  function SetXMLUserInfo(bSetUserName, bReadOnly : boolean; asValue : ANSIString) : integer;
  function GetXMLUserInfo(bGetUserName, bReadOnly : boolean; var asValue : ANSIString) : integer;
  function GetAllBespokeDatabaseInfo(Databases : TStrings; asMasterDatabase : ANSIString) : integer;
  function RunSQLScript(asScript, asDatabaseName : ANSIString; SQLLoginDetails : TSQLLoginDetails) : integer;
  function GetServerNamePervasive : ANSIString;
  procedure SetServerNamePervasive(asServerName : ANSIString);
//  function AddBespokeDatabase(asCode, asDescription, asDatabase : ANSIString; slDBCreate : TStringList) : LongInt;
//  function AddBespokeDatabase(asCode, asDescription, asDatabase : ANSIString; slDBCreate : TStringList) : LongInt;
//  function EditBespokeDatabase(pOrigCode, pNewCode, pDescription, pDatabase : PChar) : LongInt;
//  function DeleteBespokeDatabase(pCode : PChar) : LongInt;

const
   iKey = 26;

type
  TScriptInfo = class
    Name : ANSIString;
    ParentDatabase : ANSIString;
    ParentTable : ANSIString;
    ParentCode : ANSIString;
    Script : TStringList;
    Order : integer;
    RunOK, CreateDatabase : boolean;
    StatusLine : string;
    procedure CopyFrom(ScriptInfo : TScriptInfo);
    procedure ReadScript(nScript : TGMXMLNode);
    constructor create;
    destructor destroy;
    function Add : integer;
    function Update(sNewName : string; slNewScript : TStringList; bCreateDatabase : boolean) : integer;
    function Delete : integer;
//    procedure RunScript(SQLLoginDetails : TSQLLoginDetails);
    function RunScript(SQLLoginDetails : TSQLLoginDetails; bShowMessage : boolean) : boolean;
  end;

  TTableInfo = class
    Name : ANSIString;
    Status : LongInt;
    ParentCode : ANSIString;
    ParentDatabase : ANSIString;
    Scripts : TStringList;
    procedure CopyFrom(TableInfo : TTableInfo);
    constructor create;
    destructor destroy;
    function Add : integer;
    function Update(sNewName : string{; slNewCreationScript : TStringList}) : integer;
    function Delete : integer;
    procedure GetStatus(bShowErrors : boolean = TRUE);
    function RunScripts(SQLLoginDetails: TSQLLoginDetails; bShowErrors : boolean) : boolean;
  end;

  TDatabaseInfo = class
    Code : ANSIString;
    MasterDatabase : ANSIString;
    Database : ANSIString;
    Status : LongInt;
    Description : ANSIString;
//    CreationScript : TStringList;
    Tables : TList;
    Scripts : TStringList;
    constructor create;
    destructor destroy;
    function Add : integer;
    function Update(asOrigCode : ANSIString) : integer;
    function Delete : integer;
    function PopulateFromCode : integer;
    procedure GetStatus(bShowMessages : boolean = TRUE);
    function SQLDelete(SQLLoginDetails : TSQLLoginDetails) : integer;
    function SQLCreate(SQLLoginDetails : TSQLLoginDetails) : integer;
    function RunScripts(SQLLoginDetails: TSQLLoginDetails; bShowMessages : boolean) : boolean;
  end;

const
  SQL_ERROR = -1;
  SQL_NOT_CREATED = 0;
  SQL_CREATED = 1;
  SQLStatusDescs : array [SQL_ERROR..SQL_CREATED] of string = ('ERROR!','*** Not Found ***','Created');
  
implementation

const
  BESPOKE_XML_FILENAME = 'ExchBespoke.XML';

function GetScriptsNode(nParent : TGMXMLNode; bCreate : boolean) : TGMXMLNode;
var
  iNode : integer;
  nNode : TGMXMLNode;
begin{GetScriptsNode}
  // Correct Table found, so Add

//  Result := nParent.Children.NodeByName['Scripts'];
  For iNode := 0 to nParent.Children.Count-1 do
  begin
    nNode := nParent.Children[iNode];
    if (nNode.Name = 'Scripts') and  (nNode.Parent.Name = nParent.Name) then // Only find an immediate child node
    begin
      Result := nNode;
      break;
    end;{if}
  end;

//  if Result.Parent.Name <> nParent.Name then Result := nil; // Only find an immediate child node

  // Add <Scripts> node
  if not Assigned(Result) and bCreate then
  begin
    Result := nParent.Children.AddOpenTag('Scripts');
    nParent.Children.AddCloseTag;
  end;{if}
end;{GetScriptsNode}

procedure SaveScript(nParentNode : TGMXMLNode; sNodeDesc : string; slScript : TStringList);
var
  nLine, nScript : TGMXMLNode;
  iLine : integer;
begin
  nScript := nParentNode.Children.AddOpenTag(sNodeDesc);

    For iLine := 0 to slScript.count -1 do
    begin
      nLine := nScript.Children.AddLeaf('Line' + IntToStr(iLine+1));
      nLine.AsString := slScript[iLine];
    end;{for}

  nParentNode.Children.AddCloseTag;
end;

function SetXMLUserInfo(bSetUserName, bReadOnly : boolean; asValue : ANSIString) : integer;
var
  oXML : TGMXML;
  nIDPW, nRORW, nUsers, nSQL : TGmXmlNode;
  {sDecodedValue,} sEncodedValue, sIDPW, sRORW : string;
begin
  oXML := TGMXML.Create(nil);
  try
    if FileExists(BESPOKE_XML_FILENAME) then
    begin
      oXML.LoadFromFile(BESPOKE_XML_FILENAME);

      nSQL := oXML.Nodes.NodeByName['SQL'];
      if assigned(nSQL) then
      begin
        nUsers := nSQL.Children.NodeByName['Users'];
        if assigned(nUsers) then
        begin
          if bReadOnly then sRORW := 'ReadOnly'
          else sRORW := 'ReadWrite';
          nRORW := nUsers.Children.NodeByName[sRORW];
          if assigned(nRORW) then
          begin
            if bSetUserName then sIDPW := 'ID'
            else sIDPW := 'Password';
            nIDPW := nRORW.Children.NodeByName[sIDPW];
            if assigned(nIDPW) then
            begin
              sEncodedValue := BlowFishEncrypt(asValue);
              if sEncodedValue <> BLOWFISH_ERROR then
              begin
                nIDPW.AsString := sEncodedValue;
                oXML.SaveToFile(BESPOKE_XML_FILENAME);
                Result := 0;
              end
              else
              begin
                Result := -18;
              end;{if}
            end
            else
            begin
              Result := -17;
            end;{if}
          end
          else
          begin
            Result := -16;
          end;{if}
        end
        else
        begin
          Result := -15;
        end;{if}
      end
      else
      begin
        Result := -14;
      end;{if}
    end
    else
    begin
      Result := -13;
    end;{if}
  finally
    oXML.Free
  end;{try}
end;

function GetXMLUserInfo(bGetUserName, bReadOnly : boolean; var asValue : ANSIString) : integer;
var
  oXML : TGMXML;
  nIDPW, nRORW, nUsers, nSQL : TGmXmlNode;
  sDecodedValue, sEncodedValue, sIDPW, sRORW : string;
begin
  oXML := TGMXML.Create(nil);
  try
    if FileExists(BESPOKE_XML_FILENAME) then
    begin
      oXML.LoadFromFile(BESPOKE_XML_FILENAME);
      nSQL := oXML.Nodes.NodeByName['SQL'];
      if assigned(nSQL) then
      begin
        nUsers := nSQL.Children.NodeByName['Users'];
        if assigned(nUsers) then
        begin
          if bReadOnly then sRORW := 'ReadOnly'
          else sRORW := 'ReadWrite';
          nRORW := nUsers.Children.NodeByName[sRORW];
          if assigned(nRORW) then
          begin
            if bGetUserName then sIDPW := 'ID'
            else sIDPW := 'Password';
            nIDPW := nRORW.Children.NodeByName[sIDPW];
            if assigned(nIDPW) then
            begin
              sEncodedValue := nIDPW.AsDisplayString;
              sDecodedValue := BlowFishDecrypt(sEncodedValue);
              if sDecodedValue <> BLOWFISH_ERROR then
              begin
                asValue := sDecodedValue;
                Result := 0;
              end
              else
              begin
                Result := -18;
              end;{if}
            end
            else
            begin
              Result := -17;
            end;{if}
          end
          else
          begin
            Result := -16;
          end;{if}
        end
        else
        begin
          Result := -15;
        end;{if}
      end
      else
      begin
        Result := -14;
      end;{if}
    end
    else
    begin
      Result := -13;
    end;{if}
  finally
    oXML.Free
  end;{try}
end;

function GetAllBespokeDatabaseInfo(Databases : TStrings; asMasterDatabase : ANSIString) : integer;
var
  oXML : TGMXML;
  {nDescription, nDatabase, }nCode, nPlugIn, nPlugIns : TGmXmlNode;
  iNode : integer;
  DatabaseInfo : TDatabaseInfo;
begin
  Result := -13;
  oXML := TGMXML.Create(nil);
  try
    if FileExists(BESPOKE_XML_FILENAME) then
    begin
      oXML.LoadFromFile(BESPOKE_XML_FILENAME);
      nPlugIns := oXML.Nodes.NodeByName['PlugIns'];
      if assigned(nPlugIns) then
      begin
        For iNode := 0 to nPlugIns.Children.Count-1 do
        begin
          if nPlugIns.Children.Node[iNode].Name = 'PlugIn' then
          begin
            DatabaseInfo := TDatabaseInfo.Create;
            nPlugIn := nPlugIns.Children[iNode];

            nCode := nPlugIn.Children.NodeByName['Code'];
            if Assigned(nCode) then
            begin
              DatabaseInfo.Code := nCode.AsDisplayString;
              DatabaseInfo.MasterDatabase := asMasterDatabase;
              DatabaseInfo.PopulateFromCode;
              Databases.AddObject(DatabaseInfo.Code, DatabaseInfo);
            end
            else
            begin
              DatabaseInfo.Free;
            end;{if}
          end;{if}
        end;{for}
        Result := 0;
      end
      else
      begin
        Result := -14;
      end;{if}
    end
    else
    begin
      Result := -13;
    end;{if}
  finally
    oXML.Free
  end;{try}
end;

{
function AddBespokeDatabase(asCode, asDescription, asDatabase : ANSIString) : LongInt;
var
  DatabaseInfo : TDatabaseInfo;
begin
  try
    DatabaseInfo := TDatabaseInfo.create;
    DatabaseInfo.Code := asCode;
    DatabaseInfo.Description := asDescription;
    DatabaseInfo.Database := asDatabase;
    Result := DatabaseInfo.Add;
    DatabaseInfo.Free;
  except
    Result := -1;
  end;
end;

function EditBespokeDatabase(pOrigCode, pNewCode, pDescription, pDatabase : PChar) : LongInt;
var
  DatabaseInfo : TDatabaseInfo;
begin
  try
    DatabaseInfo := TDatabaseInfo.create;
    DatabaseInfo.Code := pNewCode;
    DatabaseInfo.Description := pDescription;
    DatabaseInfo.Database := pDatabase;
    Result := DatabaseInfo.Update(pOrigCode);
    DatabaseInfo.Free;
  except
    Result := -1;
  end;
end;

function DeleteBespokeDatabase(pCode : PChar) : LongInt;
var
  DatabaseInfo : TDatabaseInfo;
begin
  try
    DatabaseInfo := TDatabaseInfo.create;
    DatabaseInfo.Code := pCode;
    Result := DatabaseInfo.Delete;
    DatabaseInfo.Free;
  except
    Result := -1;
  end;
end;
}
{ TDatabaseInfo }

function TDatabaseInfo.Add : integer;
var
  oXML : TGMXML;
  nName, nDescription, nDatabase, nCode, nPlugIn, nPlugIns : TGmXmlNode;
//  iLine : integer;
begin
  oXML := TGMXML.Create(nil);
  try
    if FileExists(BESPOKE_XML_FILENAME) then
    begin
      oXML.LoadFromFile(BESPOKE_XML_FILENAME);
      nPlugIns := oXML.Nodes.NodeByName['PlugIns'];
      if assigned(nPlugIns) then
      begin
        nPlugIn := nPlugIns.Children.AddOpenTag('PlugIn');

          nCode := nPlugIn.Children.AddLeaf('Code');
          nCode.AsString := Code;

          nDescription := nPlugIn.Children.AddLeaf('Description');
          nDescription.AsString := Description;

          nDatabase := nPlugIn.Children.AddOpenTag('SQLDatabase');

            nName := nDatabase.Children.AddLeaf('Name');
            nName.AsString := Database;

            nDatabase.Children.AddLeaf('Scripts');

          nPlugIn.Children.AddCloseTag; // </SQLDatabase>

        nPlugIns.Children.AddCloseTag; // </PlugIn>

        oXML.SaveToFile(BESPOKE_XML_FILENAME);

        Result := 0;
      end
      else
      begin
        Result := -14;
      end;{if}
    end
    else
    begin
      Result := -13;
    end;{if}
  finally
    oXML.Free
  end;{try}
end;

constructor TDatabaseInfo.create;
begin
  Code := '';
  Database := '';
  Description := '';
  MasterDatabase := '';
  Status := 0;
  Tables := TList.Create;
  Scripts := TStringList.Create;
end;

function TDatabaseInfo.Update(asOrigCode: ANSIString): integer;
var
  oXML : TGMXML;
  nName, nDescription, nDatabase, nCode, nPlugIn, nPlugIns : TGmXmlNode;
  iNode : integer;
begin
  Result := -13;
  oXML := TGMXML.Create(nil);
  try
    if FileExists(BESPOKE_XML_FILENAME) then
    begin
      oXML.LoadFromFile(BESPOKE_XML_FILENAME);
      nPlugIns := oXML.Nodes.NodeByName['PlugIns'];
      if assigned(nPlugIns) then
      begin
        For iNode := 0 to nPlugIns.Children.Count-1 do
        begin
          if nPlugIns.Children.Node[iNode].Name = 'PlugIn' then
          begin
            nPlugIn := nPlugIns.Children[iNode];

            nCode := nPlugIn.Children.NodeByName['Code'];
            if Assigned(nCode) then
            begin
              if nCode.AsString = asOrigCode then
              begin
                nCode.AsString := Code;

                nDatabase := nPlugIn.Children.NodeByName['SQLDatabase'];
                if Assigned(nDatabase) then
                begin
                  nName := nDatabase.Children.NodeByName['Name'];
                  if Assigned(nName) then nName.AsString := Database;
                end;{if}

                nDescription := nPlugIn.Children.NodeByName['Description'];
                if Assigned(nDescription) then nDescription.AsString := Description;

                oXML.SaveToFile(BESPOKE_XML_FILENAME);
              
                Result := 0;
                Break;
              end;{if}
            end;{if}
          end;{if}
        end;{for}
      end
      else
      begin
        Result := -14;
      end;{if}
    end
    else
    begin
      Result := -13;
    end;{if}
  finally
    oXML.Free
  end;{try}
end;

function TDatabaseInfo.Delete : integer;
var
  oXML : TGMXML;
  {nDescription, nDatabase, }nCode, nPlugIn, nPlugIns : TGmXmlNode;
  iNode : integer;
begin
  Result := -13;
  oXML := TGMXML.Create(nil);
  try
    if FileExists(BESPOKE_XML_FILENAME) then
    begin
      oXML.LoadFromFile(BESPOKE_XML_FILENAME);
      nPlugIns := oXML.Nodes.NodeByName['PlugIns'];
      if assigned(nPlugIns) then
      begin
        For iNode := 0 to nPlugIns.Children.Count-1 do
        begin
          if nPlugIns.Children.Node[iNode].Name = 'PlugIn' then
          begin
            nPlugIn := nPlugIns.Children[iNode];

            nCode := nPlugIn.Children.NodeByName['Code'];
            if Assigned(nCode) then
            begin
              if nCode.AsString = Code then
              begin
                nPlugIn.Children.Clear; //Delete Node and all it's childrem

                // Can't seem to remove the actual node using TGMXML, so I will just leave it there

  //              nPlugIns.Children.Node[iNode].Free;
  //              nPlugIns.Children.Node[iNode] := nil;

                oXML.SaveToFile(BESPOKE_XML_FILENAME);

                Result := 0;
                Break;
              end;{if}
            end;{if}
          end;{if}
        end;{for}
      end
      else
      begin
        Result := -14;
      end;{if}
    end
    else
    begin
      Result := -13;
    end;{if}
  finally
    oXML.Free
  end;{try}
end;

function TDatabaseInfo.PopulateFromCode : integer;

  procedure ReadScripts(nScripts : TGMXMLNode; slScripts : TStringList; asParentDatabase, asExchDatabase, asParentCode, asParentTable : ANSIString);
  var
    nName, nScript : TGMXMLNode;
    ScriptInfo : TScriptInfo;
    iScript : integer;
  begin{ReadScripts}
    For iScript := 0 to nScripts.Children.Count-1 do
    begin
      if nScripts.Children.Node[iScript].Name = 'Script' then
      begin
        nScript := nScripts.Children[iScript];
        if Assigned(nScript) then
        begin

          if nScript.Children.Count > 0 then
          begin
            ScriptInfo := TScriptInfo.Create;
            ScriptInfo.ParentCode := asParentCode;
            ScriptInfo.ParentTable := asParentTable;
            ScriptInfo.Order := StrToIntDef(nScript.Attributes.ElementByName['Order'].Value, 0);
            ScriptInfo.CreateDatabase := Trim(nScript.Attributes.ElementByName['CreateDatabase'].Value) = '1';

            if ScriptInfo.CreateDatabase
            then ScriptInfo.ParentDatabase := asExchDatabase  // Cannot use Bespoke Database to Create Bespoke Database !
            else ScriptInfo.ParentDatabase := asParentDatabase;

            nName := nScript.Children.NodeByName['Name'];
            if Assigned(nName) then ScriptInfo.Name := nName.AsDisplayString;

            ScriptInfo.ReadScript(nScript);

            slScripts.AddObject(IntToStr(ScriptInfo.Order), ScriptInfo);
          end;{if}
        end;{if}
      end;{if}
    end;{for}
    slScripts.Sort;
  end;{ReadScripts}

var
  oXML : TGMXML;
  nScripts, nName, nTable, nTables, nDatabaseName, nDescription, nDatabase, nCode, nPlugIn, nPlugIns : TGmXmlNode;
  iTable, iNode : integer;
  TableInfo : TTableInfo;

begin
  Result := -12;
//  CreationScript.Clear;
  ClearList(Tables);

  oXML := TGMXML.Create(nil);
  try
    if FileExists(BESPOKE_XML_FILENAME) then
    begin
      oXML.LoadFromFile(BESPOKE_XML_FILENAME);
      nPlugIns := oXML.Nodes.NodeByName['PlugIns'];
      if assigned(nPlugIns) then
      begin
        if nPlugIns.Children.Count = 0 then
        begin
          Result := -15;  // no Plug-Ins Listed
        end
        else
        begin
          For iNode := 0 to nPlugIns.Children.Count-1 do
          begin
            if nPlugIns.Children.Node[iNode].Name = 'PlugIn' then
            begin
              nPlugIn := nPlugIns.Children[iNode];

              nCode := nPlugIn.Children.NodeByName['Code'];
              if Assigned(nCode) then
              begin
                if nCode.AsString = Code then
                begin
                  nDescription := nPlugIn.Children.NodeByName['Description'];
                  if Assigned(nDescription) then
                  begin
                    Description := nDescription.AsDisplayString;

                    nDatabase := nPlugIn.Children.NodeByName['SQLDatabase'];
                    if Assigned(nDatabase) then
                    begin

                      nDatabaseName := nDatabase.Children.NodeByName['Name'];
                      if Assigned(nDatabaseName) then
                      begin
                        Database := nDatabaseName.AsDisplayString;

                        // Read Database Scripts
//                        nScripts := nDatabase.Children.NodeByName['Scripts'];
                        nScripts := GetScriptsNode(nDatabase, FALSE);
                        if Assigned(nScripts) then
                        begin
                          if Assigned(nScripts.Parent)
                          and (nScripts.Parent.Name = 'SQLDatabase')
                          then ReadScripts(nScripts, Scripts, Database, MasterDatabase, Code, '');
                        end;{if}

                        Result := 0;  // You don;t HAVE to have tables setup to read the database info

                        // Read Tables
                        nTables := nDatabase.Children.NodeByName['Tables'];
                        if Assigned(nTables) then
                        begin
                          if nTables.Children.Count <= 0 then
                          begin
                            Result := -21;
                          end
                          else
                          begin
                            For iTable := 0 to nTables.Children.Count-1 do
                            begin
                              if nTables.Children.Node[iTable].Name = 'Table' then
                              begin
                                nTable := nTables.Children[iTable];

                                if Assigned(nTable) and (nTable.Children.count > 0) then
                                begin
                                  // add table to list of tables
                                  TableInfo := TTableInfo.Create;
                                  Tables.Add(TableInfo);

                                  nName := nTable.Children.NodeByName['Name'];
                                  if Assigned(nName) then
                                  begin
                                    TableInfo.Name := nName.AsDisplayString;
                                    TableInfo.ParentDatabase := Database;
                                    TableInfo.ParentCode := Code;

                                    // Read Table Scripts
                                    nScripts := GetScriptsNode(nTable, FALSE);
//                                    nScripts := nTable.Children.NodeByName['Scripts'];
                                    if Assigned(nScripts) then
                                    begin
                                      if Assigned(nScripts.Parent)
                                      and (nScripts.Parent.Name = 'Table')
                                      then ReadScripts(nScripts, TableInfo.Scripts, TableInfo.ParentDatabase, MasterDatabase, TableInfo.ParentCode, TableInfo.Name);

{                                      For iScript := 0 to nScripts.Children.Count-1 do
                                      begin
                                        if nScripts.Children.Node[iScript].Name = 'Script' then
                                        begin
                                          nScript := nScripts.Children[iScript];
                                          if Assigned(nScript) then
                                          begin

                                            if nScript.Children.Count > 0 then
                                            begin
                                              ScriptInfo := TScriptInfo.Create;
                                              ScriptInfo.ParentDatabase := TableInfo.ParentDatabase;
                                              ScriptInfo.ParentCode := TableInfo.ParentCode;
                                              ScriptInfo.ParentTable := TableInfo.Name;

                                              nName := nScript.Children.NodeByName['Name'];
                                              if Assigned(nName) then ScriptInfo.Name := nName.AsString;

                                              ScriptInfo.ReadScript(nScript);

                                              TableInfo.Scripts.Add(ScriptInfo);
                                            end;{if}
//                                          end;{if}
//                                        end;{if}
//                                      end;{for}
                                    end;{if}
                                  end;{if}
                                end;{if}
                              end;{if}
                            end;
//                            Result := 0;
                          end;{if}
                        end
                        else
                        begin
  //                        Result := -20; // no "Tables" Node
                        end;{if}
                      end
                      else
                      begin
                        Result := -19; // no "Name" node
                        break;
                      end;{if}
                    end
                    else
                    begin
                      Result := -18; // no "SQLDatabase" node
                      break;
                    end;{if}

                    // Found Matching Code, so break out of for loop
                    Break;
                  end
                  else
                  begin
                    Result := -17; // No "Description" Node
                  end;{if}
                end;{if}
//              end
//              else
//              begin
//                Result := -16; // no "Code" Node
              end;{if}
            end;{if}
          end;{for}
        end;{if}
      end
      else
      begin
        Result := -14; // no "PlugIns" Node
      end;{if}
    end
    else
    begin
      Result := -13;
    end;{if}
  finally
    oXML.Free
  end;{try}
end;

destructor TDatabaseInfo.destroy;
begin
  ClearList(Tables);
  Tables.Free;

  ClearList(Scripts);
  Scripts.Free;
end;

procedure TDatabaseInfo.GetStatus(bShowMessages : boolean = TRUE);
var
  pDatabaseName : PChar;
//  asConnectionString : ANSIString;
  iResult : LongInt;
  bExists : WordBool;
begin
  // initialise
  pDatabaseName := StrAlloc(255);
  StrPCopy(pDatabaseName, Database);

  iResult := SQLDatabaseExists(pDatabaseName, bExists); // call dll function
  if iResult = 0 then
  begin
    if bExists then Status := 1
    else Status := 0;
  end
  else
  begin
    if bShowMessages then
    begin
      MsgBox('An error occurred when calling SQLDatabaseExists :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLDatabaseExists Error');
    end;{if}
    Status := -1;
  end;{if}

  // clear up
  StrDispose(pDatabaseName);
end;

function TDatabaseInfo.SQLDelete(SQLLoginDetails : TSQLLoginDetails) : integer;
var
  pUserName, pPassword, pSpecialPassword, pDatabaseName : PChar;
//  asConnectionString : ANSIString;
//  bExists : WordBool;
begin
  // initialise
  pDatabaseName := StrAlloc(255);
  StrPCopy(pDatabaseName, Database);
  pSpecialPassword := StrAlloc(255);
  StrPCopy(pSpecialPassword, GetPassword{(iKey)});
  pUserName := StrAlloc(255);
  StrPCopy(pUserName, SQLLoginDetails.asUsername);
  pPassword := StrAlloc(255);
  StrPCopy(pPassword, SQLLoginDetails.asPassword);

  Result := SQLDatabaseDelete(SQLLoginDetails.bWindowsAuth, pUserName, pPassword
  , pDatabaseName, pSpecialPassword); // call dll function
  if Result <> 0 then
  begin
    MsgBox('An error occurred when calling SQLDatabaseDelete :'#13#13'Error : '
    + IntToStr(Result), mtError, [mbOK], mbOK, 'SQLDatabaseDelete Error');
    Status := -1;
  end;{if}

  // clear up
  StrDispose(pDatabaseName);
  StrDispose(pSpecialPassword);
  StrDispose(pPassword);
  StrDispose(pUserName);
end;

function TDatabaseInfo.SQLCreate(SQLLoginDetails : TSQLLoginDetails) : integer;
var
  pUserName, pPassword, pSpecialPassword, pDatabaseName : PChar;
//  asConnectionString : ANSIString;
//  bExists : WordBool;
begin
  // initialise
  pDatabaseName := StrAlloc(255);
  StrPCopy(pDatabaseName, Database);
  pSpecialPassword := StrAlloc(255);
  StrPCopy(pSpecialPassword, GetPassword{(iKey)});
  pUserName := StrAlloc(255);
  StrPCopy(pUserName, SQLLoginDetails.asUsername);
  pPassword := StrAlloc(255);
  StrPCopy(pPassword, SQLLoginDetails.asPassword);

  Result := SQLDatabaseCreate(SQLLoginDetails.bWindowsAuth,pUserName, pPassword
  , pDatabaseName, pSpecialPassword); // call dll function
  if Result <> 0 then
  begin
    MsgBox('An error occurred when calling SQLDatabaseCreate :'#13#13'Error : '
    + IntToStr(Result), mtError, [mbOK], mbOK, 'SQLDatabaseCreate Error');
    Status := -1;
  end;{if}

  // clear up
  StrDispose(pDatabaseName);
  StrDispose(pSpecialPassword);
  StrDispose(pPassword);
  StrDispose(pUserName);
end;

function TDatabaseInfo.RunScripts(SQLLoginDetails: TSQLLoginDetails; bShowMessages : boolean) : boolean;
var
  iScript : integer;
  bOK : boolean;
  ScriptInfo : TScriptInfo;
begin
  Result := TRUE;
  For iScript := 0 to Scripts.Count-1 do
  begin
    ScriptInfo := TScriptInfo(Scripts.Objects[iScript]);
    bOK := ScriptInfo.RunScript(SQLLoginDetails, bShowMessages);
    if not bOK then Result := FALSE;
  end;{for}
end;

{ TTableInfo }

function TTableInfo.Add: integer;
var
  oXML : TGMXML;
  nScripts,{ nScript, nLine, }nTable, nTables, nName, nDatabase, nCode, nPlugIn, nPlugIns : TGmXmlNode;
  iScript, {iLine, }iNode : integer;
  bCloseTables : boolean;
//  ScriptInfo : TScriptInfo;
begin
  Result := -13;
  bCloseTables := FALSE;

  oXML := TGMXML.Create(nil);
  try
    if FileExists(BESPOKE_XML_FILENAME) then
    begin
      oXML.LoadFromFile(BESPOKE_XML_FILENAME);
      nPlugIns := oXML.Nodes.NodeByName['PlugIns'];
      if assigned(nPlugIns) then
      begin
        if nPlugIns.Children.Count = 0 then
        begin
          Result := -15;  // no Plug-Ins Listed
        end
        else
        begin
          For iNode := 0 to nPlugIns.Children.Count-1 do
          begin
            if nPlugIns.Children.Node[iNode].Name = 'PlugIn' then
            begin
              nPlugIn := nPlugIns.Children[iNode];

              if nPlugIn.Children.Count > 0 then
              begin
                nCode := nPlugIn.Children.NodeByName['Code'];
                if Assigned(nCode) then
                begin
                  if nCode.AsString = ParentCode then
                  begin
                    nDatabase := nPlugIn.Children.NodeByName['SQLDatabase'];
                    if Assigned(nDatabase) then
                    begin
                      nTables := nDatabase.Children.NodeByName['Tables'];
                      if not Assigned(nTables) then
                      begin
                        // Add Tables Node
                        nTables := nDatabase.Children.AddOpenTag('Tables');
                        bCloseTables := TRUE;
                      end;

                      // Add Table Node
                      nTable := nTables.Children.AddOpenTag('Table');

                        // Add Name Node
                        nName := nTable.Children.AddLeaf('Name');
                        nName.AsString := Name;

                        // Add Scripts Node
                        nScripts := nTable.Children.AddOpenTag('Scripts');
                        nTable.Children.AddCloseTag;
                (*
                        nScripts := nTable.Children.AddOpenTag('Scripts');

                        // Add all scripts
                        For iScript := 0 to Scripts.Count-1 do
                        begin
                          nScript := nScripts.Children.AddOpenTag('Script');

                          // Add all Lines for the script
                          ScriptInfo := TScriptInfo(Scripts[iScript]);
                          For iLine := 0 to ScriptInfo.Script.Count-1 do
                          begin
                            nLine := nScript.Children.AddLeaf('Line');
                            nLine.AsString := ScriptInfo.Script[iLine];
                          end;{for}

                          nScripts.Children.addCloseTag; // </Script>
                        end;{for}



                        nTable.Children.addCloseTag; // </Scripts>
                      *)
                      nTables.Children.AddCloseTag;// </Table>

                      // Add close tables node
                      if bCloseTables then nDatabase.Children.AddCloseTag;

                      oXML.SaveToFile(BESPOKE_XML_FILENAME);
                      Result := 0;

                      For iScript := 0 to Scripts.Count-1 do
                      begin
                        Result := TScriptInfo(Scripts.Objects[iScript]).Add;
                        if Result < 0 then
                        begin
                          Result := Result -1000;
                          break;
                        end;{if}
                      end;{for}
                    end
                    else
                    begin
                      Result := -18; // no "SQLDatabase" node
                    end;{if}

                    // Found Matching Code, so break out of for loop
                    Break;
                  end;{if}
//                end
//                else
//                begin
//                  Result := -16; // no "Code" Node
                end;{if}
              end;{if}
            end;{if}
          end;{for}
        end;{if}
      end
      else
      begin
        Result := -14; // no "PlugIns" Node
      end;{if}
    end
    else
    begin
      Result := -13;
    end;{if}
  finally
    oXML.Free
  end;{try}
end;

procedure TTableInfo.CopyFrom(TableInfo : TTableInfo);
var
  iScript : integer;
  ScriptInfo : TScriptInfo;
begin
  Name := TableInfo.Name;
  ParentCode := TableInfo.ParentCode;
  ParentDatabase := TableInfo.ParentDatabase;
//  CreationScript.Assign(TableInfo.CreationScript);
  For iScript := 0 to TableInfo.Scripts.Count-1 do
  begin

    ScriptInfo := TScriptInfo.Create;

    ScriptInfo.CopyFrom(TScriptInfo(TableInfo.Scripts.Objects[iScript]));
{    ScriptInfo.Name := TScriptInfo(TableInfo.Scripts.Objects[iScript]).Name;
    ScriptInfo.Order := TScriptInfo(TableInfo.Scripts.Objects[iScript]).Order;
    ScriptInfo.CreateDatabase := TScriptInfo(TableInfo.Scripts.Objects[iScript]).CreateDatabase;
    ScriptInfo.ParentDatabase := TScriptInfo(TableInfo.Scripts.Objects[iScript]).ParentDatabase;
    ScriptInfo.ParentCode := TScriptInfo(TableInfo.Scripts.Objects[iScript]).ParentCode;
    ScriptInfo.ParentTable := TScriptInfo(TableInfo.Scripts.Objects[iScript]).ParentTable;
    ScriptInfo.Script.Assign(TScriptInfo(TableInfo.Scripts.Objects[iScript]).Script);}
    
    Scripts.AddObject(IntToStr(ScriptInfo.Order), ScriptInfo)
  end;
end;

constructor TTableInfo.create;
begin
  Name := '';
  ParentCode := '';
  ParentDatabase := '';
  Status := 0;
  Scripts := TStringList.Create;
end;

function TTableInfo.Delete: integer;
var
  oXML : TGMXML;
  nTable, nTables, nName, {nDescription, }nDatabase, nCode, nPlugIn, nPlugIns : TGmXmlNode;
  iTable, {iLine, }iNode : integer;
begin
  Result := -13;

  oXML := TGMXML.Create(nil);
  try
    if FileExists(BESPOKE_XML_FILENAME) then
    begin
      oXML.LoadFromFile(BESPOKE_XML_FILENAME);
      nPlugIns := oXML.Nodes.NodeByName['PlugIns'];
      if assigned(nPlugIns) then
      begin
        if nPlugIns.Children.Count = 0 then
        begin
          Result := -15;  // no Plug-Ins Listed
        end
        else
        begin
          For iNode := 0 to nPlugIns.Children.Count-1 do
          begin
            if nPlugIns.Children.Node[iNode].Name = 'PlugIn' then
            begin
              nPlugIn := nPlugIns.Children[iNode];

              if nPlugIn.Children.Count> 0 then
              begin
                nCode := nPlugIn.Children.NodeByName['Code'];
                if Assigned(nCode) then
                begin
                  if nCode.AsString = ParentCode then
                  begin
                    nDatabase := nPlugIn.Children.NodeByName['SQLDatabase'];
                    if Assigned(nDatabase) then
                    begin
                      nTables := nDatabase.Children.NodeByName['Tables'];
                      if Assigned(nTables) then
                      begin
                        For iTable := 0 to nTables.Children.Count-1 do
                        begin
                          if nTables.Children.Node[iTable].Name = 'Table' then
                          begin
                            nTable := nTables.Children[iTable];
                            nName := nTable.Children.NodeByName['Name'];
                            if Assigned(nName) then
                            begin
                              if nName.AsString = Name then
                              begin
                                nTable.Children.Clear; //Delete Node and all it's childrem
                                oXML.SaveToFile(BESPOKE_XML_FILENAME);
                                Result := 0;
                                Break;
                              end;{if}
                            end;{if}
                          end;{if}
                        end;{for}
                      end
                      else
                      begin
                        Result := -20; // no "Tables" Node
                      end;{if}
                    end
                    else
                    begin
                      Result := -18; // no "SQLDatabase" node
                    end;{if}

                    // Found Matching Code, so break out of for loop
                    Break;
                  end;{if}
//                end
//                else
//                begin
//                  Result := -16; // no "Code" Node
                end;{if}
              end;{if}
            end;{if}
          end;{for}
        end;{if}
      end
      else
      begin
        Result := -14; // no "PlugIns" Node
      end;{if}
    end
    else
    begin
      Result := -13;
    end;{if}
  finally
    oXML.Free
  end;{try}
end;

destructor TTableInfo.destroy;
begin
  ClearList(Scripts);
  Scripts.Free;
end;

procedure TTableInfo.GetStatus(bShowErrors : boolean = TRUE);
var
  pDatabaseName, pUsername, pPlugInCode, pTableName : PChar;
  asUserName : ANSIString;
  bExists : WordBool;
  iResult : integer;
begin
  // initialise
  pPlugInCode := StrAlloc(255);
  pTableName := StrAlloc(255);
  pDatabaseName := StrAlloc(255);
  pUsername := StrAlloc(255);
  StrPCopy(pPlugInCode, ParentCode);
  StrPCopy(pTableName, Name);
  StrPCopy(pDatabaseName, ParentDatabase);
//  StrPCopy(pUsername, asUserName);

  iResult := GetXMLUserInfo(TRUE, TRUE, asUserName);
  if iResult = 0 then
  begin
    StrPCopy(pUsername, asUserName);

    iResult := SQLUserExistsForDatabase(pUsername, pDatabaseName , bExists);
    if (iResult = 0) or (iResult = -2) {not allowed to access} then
    begin
      if bExists then
      begin

        iResult := SQLTableExists(pPlugInCode, pTableName, bExists); // call dll function
        if iResult = 0 then
        begin
          if bExists then Status := 1
          else Status := 0;
        end
        else
        begin
          MsgBox('An error occurred when calling SQLTableExists :'#13#13'Error : '
          + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLTableExists Error');
          Status := -1;
        end;{if}

      end;{if}
    end
    else
    begin
      MsgBox('An error occurred when calling SQLUserExistsForDatabase :'#13#13'Error : '
      + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLUserExistsForDatabase Error');
    end;{if}
  end
  else
  begin
    MsgBox('An error occurred when calling SQLUserExistsForDatabase :'#13#13'Error : '
    + IntToStr(iResult), mtError, [mbOK], mbOK, 'SQLUserExistsForDatabase Error');
  end;{if}

  // clear up
  StrDispose(pPlugInCode);
  StrDispose(pTableName);
  StrDispose(pDatabaseName);
  StrDispose(pUsername);
(*
  // initialise
  pConnectionString := StrAlloc(255);
  pSpecialPassword := StrAlloc(255);
  pPlugInCode := StrAlloc(255);

  StrPCopy(pSpecialPassword, GetPassword{(iKey)});
  StrPCopy(pPlugInCode, ParentCode);

  iResult := SQLBuildBespokeConnectionString(pPlugInCode, TRUE, pConnectionString, pSpecialPassword);
  if iResult = 0 then
  begin
    asConnectionString := pConnectionString;
    SQLDataModule.ADOConnectionBespoke.ConnectionString := asConnectionString;

    SQLDataModule.qTableExists.Parameters.ParamByName('TableName').Value := 'dbo.' + Name;
    if ExecuteSQL(SQLDataModule.qTableExists, TRUE, TRUE) then
    begin
      Status := SQLDataModule.qTableExists.Fields[0].Value;
      SQLDataModule.qTableExists.Active := FALSE;
    end;{if}
  end;{if}

  // clear up
  StrDispose(pConnectionString);
  StrDispose(pSpecialPassword);
  StrDispose(pPlugInCode);
  *)
end;

function TTableInfo.RunScripts(SQLLoginDetails: TSQLLoginDetails; bShowErrors : boolean) : boolean;
var
  iScript : integer;
  ScriptInfo : TScriptInfo;
  bOK : boolean;
begin
  Result := TRUE;
  For iScript := 0 to Scripts.Count-1 do
  begin
    ScriptInfo := TScriptInfo(Scripts.Objects[iScript]);
    bOK := ScriptInfo.RunScript(SQLLoginDetails, bShowErrors);
    if not bOK then Result := FALSE;
  end;{for}
end;

function TTableInfo.Update(sNewName : string{; slNewCreationScript : TStringList}) : integer;
begin
  Result := Delete;
  if Result < 0 then
  begin
    Result := Result -1000;
  end
  else
  begin
    Name := sNewName;
//    CreationScript.Assign(slNewCreationScript);

    Result := Add;
    if Result < 0 then
    begin
      Result := Result -2000;
    end;{if}
  end;{if}
end;

function RunSQLScript(asScript, asDatabaseName : ANSIString; SQLLoginDetails : TSQLLoginDetails) : integer;
var
//  iPos : integer;
  {pSQL, pSQLUserName, pSQLPassword, pSpecialPassword, }pDatabaseName : PChar;
  bExists : WordBool;
begin
  // initialise
{  pSpecialPassword := StrAlloc(255);
  StrPCopy(pSpecialPassword, GetPassword(iKey));
  pSQLUserName := StrAlloc(255);
  StrPCopy(pSQLUserName, SQLLoginDetails.asUsername);
  pSQLPassword := StrAlloc(255);
  StrPCopy(pSQLPassword, SQLLoginDetails.asPassword);}
  pDatabaseName := StrAlloc(255);
//  StrPCopy(pDatabaseName, TableInfo.ParentDatabase);
  StrPCopy(pDatabaseName, asDatabaseName);
{  pSQL := StrAlloc(1000);
  StrPCopy(pSQL, asScript);}

  Result := SQLDatabaseExists(pDatabaseName, bExists); // call dll function
  if Result = 0 then
  begin
    if bExists then
    begin
      Result := SQLExecuteD6(SQLLoginDetails.bWindowsAuth, SQLLoginDetails.asUsername
      , SQLLoginDetails.asPassword, asDatabaseName, asScript, TRUE);
    end
    else
    begin
      MsgBox('Could not create new table.'#13#13'Database (' + pDatabaseName + ') does not exist.'
      , mtError, [mbOK], mbOK, 'ExecuteSQL Error');
    end;{if}
  end
  else
  begin
    MsgBox('An error occurred when calling SQLDatabaseExists :'#13#13'Error : '
    + IntToStr(Result), mtError, [mbOK], mbOK, 'SQLDatabaseExists Error');
  end;{if}

  // clear up
//  StrDispose(pSQL);
  StrDispose(pDatabaseName);
//  StrDispose(pSpecialPassword);
//  StrDispose(pSQLUserName);
//  StrDispose(pSQLPassword);
end;

{ TScriptInfo }

function TScriptInfo.Add: integer;

  Procedure AddScriptTo(nScripts : TGMXMLNode);
  var
    iLine : integer;
    nLine, nName, nScript : TGMXMLNode;
  begin{AddScriptTo}
    // add Script Node
    nScript := nScripts.Children.AddOpenTag('Script');

      // Add Attributes
      nScript.Attributes.AddAttribute('Order', IntToStr(Order));
      if CreateDatabase
      then nScript.Attributes.AddAttribute('CreateDatabase', '1')
      else nScript.Attributes.AddAttribute('CreateDatabase', '0');

      nName := nScript.Children.AddLeaf('Name');
      nName.AsString := Name;

      // Add all Lines for the script
      For iLine := 0 to Script.Count-1 do
      begin
        nLine := nScript.Children.AddLeaf('Line');
        nLine.AsString := Script[iLine];
      end;{for}

    nScripts.Children.addCloseTag; // </Script>
  end;{AddScriptTo}

var
  oXML : TGMXML;
  nScripts, {nLine, }nTable, nTables, nName, nDatabase, nCode, nPlugIn, nPlugIns : TGmXmlNode;
  iTable, {iScript, }iNode : integer;
//  bCloseTables : boolean;
begin
  Result := -13;

  oXML := TGMXML.Create(nil);
  try
    if FileExists(BESPOKE_XML_FILENAME) then
    begin
      oXML.LoadFromFile(BESPOKE_XML_FILENAME);
      nPlugIns := oXML.Nodes.NodeByName['PlugIns'];
      if assigned(nPlugIns) then
      begin
        if nPlugIns.Children.Count = 0 then
        begin
          Result := -15;  // no Plug-Ins Listed
        end
        else
        begin
          For iNode := 0 to nPlugIns.Children.Count-1 do
          begin
            if nPlugIns.Children.Node[iNode].Name = 'PlugIn' then
            begin
              nPlugIn := nPlugIns.Children[iNode];

              if nPlugIn.Children.Count > 0 then
              begin
                nCode := nPlugIn.Children.NodeByName['Code'];
                if Assigned(nCode) then
                begin
                  if nCode.AsString = ParentCode then
                  begin
                    nDatabase := nPlugIn.Children.NodeByName['SQLDatabase'];
                    if Assigned(nDatabase) then
                    begin

                      if Trim(ParentTable) = '' then
                      begin
                        // Database Script
                        nScripts := GetScriptsNode(nDatabase, TRUE);
                        if Assigned(nScripts) then
                        begin
                          AddScriptTo(nScripts);
                          oXML.SaveToFile(BESPOKE_XML_FILENAME);
                          Result := 0;
                        end
                        else
                        begin
                          Result := -19;
                        end;{if}
                      end
                      else
                      begin
                        // Table Script
                        nTables := nDatabase.Children.NodeByName['Tables'];

                        For iTable := 0 to nTables.Children.Count-1 do
                        begin
                          nTable := nTables.Children[iTable];
                          nName := nTable.Children.NodeByName['Name'];

                          if Assigned(nName) and
                          (nName.AsString = ParentTable) then
                          begin
                            nScripts := GetScriptsNode(nTable, TRUE);
                            AddScriptTo(nScripts);

                            // Correct Table found, so Add
{                            nScripts := nTable.Children.NodeByName['Scripts'];

                            // Add <Scripts>
                            if not Assigned(nScripts) then
                            begin
                              nScripts := nTable.Children.AddOpenTag('Scripts');
                              nTable.Children.AddCloseTag;
                            end;{if}

                            // Add script
{                            nScript := nScripts.Children.AddOpenTag('Script');

                              nName := nScript.Children.AddLeaf('Name');
                              nName.AsString := Name;

                              // Add all Lines for the script
                              For iLine := 0 to Script.Count-1 do
                              begin
                                nLine := nScript.Children.AddLeaf('Line');
                                nLine.AsString := Script[iLine];
                              end;{for}

//                            nScripts.Children.addCloseTag; // </Script>

                            oXML.SaveToFile(BESPOKE_XML_FILENAME);
                            Result := 0;

                            break; // out of for loop
                          end;{if}
                        end;{for}
                      end;{if}
                    end
                    else
                    begin
                      Result := -18; // no "SQLDatabase" node
                    end;{if}

                    // Found Matching Code, so break out of for loop
                    Break;
                  end;{if}
//                end
//                else
//                begin
//                  Result := -16; // no "Code" Node
                end;{if}
              end;{if}
            end;{if}
          end;{for}
        end;{if}
      end
      else
      begin
        Result := -14; // no "PlugIns" Node
      end;{if}
    end
    else
    begin
      Result := -13;
    end;{if}
  finally
    oXML.Free
  end;{try}
end;

procedure TScriptInfo.CopyFrom(ScriptInfo: TScriptInfo);
begin
  Name := ScriptInfo.Name;
  ParentDatabase := ScriptInfo.ParentDatabase;
  ParentTable := ScriptInfo.ParentTable;
  ParentCode := ScriptInfo.ParentCode;
  StatusLine := ScriptInfo.StatusLine;
  RunOK := ScriptInfo.RunOK;
  CreateDatabase := ScriptInfo.CreateDatabase;
  Order := ScriptInfo.Order;
  Script.Assign(ScriptInfo.Script);
end;

constructor TScriptInfo.create;
begin
  Name := '';
  ParentDatabase := '';
  ParentTable := '';
  ParentCode := '';
  StatusLine := '';
  RunOK := FALSE;
  CreateDatabase := FALSE;
  Order := 0;
  Script := TStringList.Create;
end;

function TScriptInfo.Delete: integer;
var
  oXML : TGMXML;

  procedure RemoveScriptFrom(nScripts : TGMXMLNode);
  var
    nScript, nName : TGMXMLNode;
    iScript : integer;
  begin{RemoveScriptFrom}
    if Assigned(nScripts) then
    begin
      For iScript := 0 to nScripts.Children.Count-1 do
      begin
        nScript := nScripts.Children[iScript];
        if nScript.Name = 'Script' then
        begin
          nName := nScript.Children.NodeByName['Name'];
          if Assigned(nName) and (nName.AsString = Name) then
          begin
            nScript.Children.Clear;
            nScript.Attributes.Clear;
            oXML.SaveToFile(BESPOKE_XML_FILENAME);
            Result := 0;
            Break;
          end;{if}
        end;{if}
      end;{for}
    end;{if}
  end;{RemoveScriptFrom}

var
  nScripts, nTable, nTables, nName, {nDescription, }nDatabase, nCode, nPlugIn, nPlugIns : TGmXmlNode;
  iTable, {iLine, }iNode : integer;
begin
  Result := -13;

  oXML := TGMXML.Create(nil);
  try
    if FileExists(BESPOKE_XML_FILENAME) then
    begin
      oXML.LoadFromFile(BESPOKE_XML_FILENAME);
      nPlugIns := oXML.Nodes.NodeByName['PlugIns'];
      if assigned(nPlugIns) then
      begin
        if nPlugIns.Children.Count = 0 then
        begin
          Result := -15;  // no Plug-Ins Listed
        end
        else
        begin
          For iNode := 0 to nPlugIns.Children.Count-1 do
          begin
            if nPlugIns.Children.Node[iNode].Name = 'PlugIn' then
            begin
              nPlugIn := nPlugIns.Children[iNode];

              if nPlugIn.Children.Count> 0 then
              begin
                nCode := nPlugIn.Children.NodeByName['Code'];
                if Assigned(nCode) then
                begin
                  if nCode.AsString = ParentCode then
                  begin
                    nDatabase := nPlugIn.Children.NodeByName['SQLDatabase'];
                    if Assigned(nDatabase) then
                    begin

                      if Trim(ParentTable) = '' then
                      begin
                        // Database Script
                        nScripts := GetScriptsNode(nDatabase, FALSE);
                        if Assigned(nScripts) then
                        begin
                          RemoveScriptFrom(nScripts);
                        end;
                      end
                      else
                      begin
                        // Table Script
                        nTables := nDatabase.Children.NodeByName['Tables'];
                        if Assigned(nTables) then
                        begin
                          For iTable := 0 to nTables.Children.Count-1 do
                          begin
                            if nTables.Children.Node[iTable].Name = 'Table' then
                            begin
                              nTable := nTables.Children[iTable];
                              nName := nTable.Children.NodeByName['Name'];

                              if Assigned(nName) and
                              (nName.AsString = ParentTable) then
                              begin
                                // Correct Table found, so continue....

                                nScripts := GetScriptsNode(nTable, FALSE);
//                                nScripts := nTable.Children.NodeByName['Scripts'];
                                if Assigned(nScripts) then
                                begin
                                  RemoveScriptFrom(nScripts);

{                                  For iScript := 0 to nScripts.Children.Count-1 do
                                  begin
                                    nScript := nScripts.Children[iScript];
                                    if nScript.Name = 'Script' then
                                    begin
                                      nName := nScript.Children.NodeByName['Name'];
                                      if Assigned(nName) and (nName.AsString = Name) then
                                      begin
                                        nScript.Children.Clear;
                                        oXML.SaveToFile(BESPOKE_XML_FILENAME);
                                        Result := 0;
                                        Break;
                                      end;{if}
{                                    end;{if}
{                                  end;{for}

                                end;{if}
                              end;{if}
                            end;{if}
                          end;{for}
                        end
                        else
                        begin
                          Result := -20; // no "Tables" Node
                        end;{if}
                      end;{if}
                    end
                    else
                    begin
                      Result := -18; // no "SQLDatabase" node
                    end;{if}

                    // Found Matching Code, so break out of for loop
                    Break;
                  end;{if}
//                end
//                else
//                begin
//                  Result := -16; // no "Code" Node
                end;{if}
              end;{if}
            end;{if}
          end;{for}
        end;{if}
      end
      else
      begin
        Result := -14; // no "PlugIns" Node
      end;{if}
    end
    else
    begin
      Result := -13;
    end;{if}
  finally
    oXML.Free
  end;{try}
end;

destructor TScriptInfo.destroy;
begin
  Script.Free;
end;

procedure TScriptInfo.ReadScript(nScript: TGMXMLNode);
var
  nLine : TGMXMLNode;
  iLine : integer;
begin
  Script.Clear;
//  nScript := nParentNode.Children.NodeByName[sNodeDesc];
  if Assigned(nScript) then
  begin
    For iLine := 0 to nScript.Children.Count-1 do
    begin
      nLine := nScript.Children[iLine];
      if Assigned(nLine) and (nLine.Name = 'Line')
      then Script.Add(nLine.AsDisplayString);
    end;{while}
  end;{if}
end;

function TScriptInfo.RunScript(SQLLoginDetails : TSQLLoginDetails; bShowMessage : boolean) : boolean;
var
  iResult : integer;
begin
  RunOK := RunSQLScript(Script.Text, ParentDatabase, SQLLoginDetails) = 0;
  if (RunOK) then
  begin
    StatusLine := Name + ' - SQL Script executed successfully';
    if bShowMessage then MsgBox(Name + ' - SQL Script Executed Successfully', mtInformation, [mbOK], mbOK, 'RunScript : ' + Name);
  end
  else
  begin
    StatusLine := Name + ' - Error occurred executing SQL Script';
  end;{if}
  Result := RunOK;
end;

function TScriptInfo.Update(sNewName: string; slNewScript: TStringList; bCreateDatabase : boolean): integer;
//var
//  iOriginalOrder : integer;
begin
//  iOriginalOrder := Order;
  Result := Delete;
  if Result < 0 then
  begin
    Result := Result -1000;
  end
  else
  begin
//    Order := iOriginalOrder;
    CreateDatabase := bCreateDatabase;
    Name := sNewName;
    Script.Assign(slNewScript);

    Result := Add;
    if Result < 0 then
    begin
      Result := Result -2000;
    end;{if}
  end;{if}
end;

function GetServerNamePervasive : ANSIString;
var
  oXML : TGMXML;
  nPervasive, nServerName : TGmXmlNode;
  iNode : integer;
  DatabaseInfo : TDatabaseInfo;
begin
  Result := '';
  oXML := TGMXML.Create(nil);
  try
    if FileExists(BESPOKE_XML_FILENAME) then
    begin
      oXML.LoadFromFile(BESPOKE_XML_FILENAME);
      nPervasive := oXML.Nodes.NodeByName['Pervasive'];
      if assigned(nPervasive) then
      begin
        For iNode := 0 to nPervasive.Children.Count-1 do
        begin
          if nPervasive.Children.Node[iNode].Name = 'ServerName' then
          begin
            nServerName := nPervasive.Children[iNode];
            Result := nServerName.AsDisplayString;
            break;
          end;{if}
        end;{for}
      end;{if}
    end;{if}
  finally
    oXML.Free
  end;{try}
end;

procedure SetServerNamePervasive(asServerName : ANSIString);
var
  oXML : TGMXML;
  nPervasive, nServerName : TGmXmlNode;
  iNode : integer;
  DatabaseInfo : TDatabaseInfo;
begin
  oXML := TGMXML.Create(nil);
  try
    if FileExists(BESPOKE_XML_FILENAME) then
    begin
      oXML.LoadFromFile(BESPOKE_XML_FILENAME);
      nPervasive := oXML.Nodes.NodeByName['Pervasive'];
      if assigned(nPervasive) then
      begin
        For iNode := 0 to nPervasive.Children.Count-1 do
        begin
          if nPervasive.Children.Node[iNode].Name = 'ServerName' then
          begin
            nServerName := nPervasive.Children[iNode];
            nServerName.AsString := asServerName;
            oXML.SaveToFile(BESPOKE_XML_FILENAME);
            break;
          end;{if}
        end;{for}
      end;{if}
    end;{if}
  finally
    oXML.Free
  end;{try}
end;

end.

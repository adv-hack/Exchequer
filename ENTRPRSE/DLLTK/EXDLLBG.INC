{ ExDLLBG.INC - Exchequer Enterprise DLL Btrieve Generic definitions }

TBtrieveFindRec =
  record
    FILENUM    : SMALLINT;
    SEARCHKEY  : STRING[255];
    SEARCHPATH : SMALLINT;
    SEARCHMODE : SMALLINT;
    RECORDINFO : ARRAY[1..4096] OF CHAR;
  end;




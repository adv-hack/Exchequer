unit ExtObj;

interface

uses
  BtrvU2, GlobVar, VarConst;

{Extended tests are currently only done on docs, details & stock, checking for a folio number}

type
  TExtFilterRec = Record
    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    longint;
    ExtendTail       :    ExtendRepeatType;
  end;

  TExtFindRec =  Record
    Case Integer of
      1  :  (Filter  :  TExtFilterRec);
      2  :  (ExtRec  :  ResultRecType);
  end; {Rec..}


  PClientIdType = ^ClientIdType;

  TExtendedTestObject = Class
  protected
    FFileNo : Integer;
    FExtRec : TExtFindRec;
    FCID : PClientIdType;
    FOffset : SmallInt;
    FCompare : longint;
  public
    constructor Create;
    function FindRec(BFunc, Index : Integer; KeyS : Str255) : Integer;
    property FileNo : Integer read FFileNo write FFileNo;
    property CID : PClientIdType read FCID write FCID;
  end;

  TExtendedDocTest = Class(TExtendedTestObject)
    constructor Create;
  end;

  TExtendedDetailTest = Class(TExtendedTestObject)
    constructor Create;
  end;

  TExtendedStockTest = Class(TExtendedTestObject)
    constructor Create;
  end;

implementation

{ TExtendedTestObject }

constructor TExtendedTestObject.Create;
begin
  FCID := nil;
  FCompare := 100;
end;

function TExtendedTestObject.FindRec(BFunc, Index: Integer; KeyS : Str255): Integer;
begin
  with FExtRec.Filter do
  begin
    Prime_Filter(ExtendHead, ExtendTail, FFileNo, SizeOf(FExtRec.Filter));

      With Term1 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare1);

        FieldOffset:= Pred(FOffset);

        CompareCode:=1; {* Compare= *}

        LogicExpres:=0;

        Compare1 := FCompare;

      end;
   end;

   Result := Find_VarRec(BFunc,F[FFileNo],FFileNo,SizeOf(FExtRec),FExtRec,Index,KeyS,FCID);
end;

{ TExtendedDocTest }

constructor TExtendedDocTest.Create;
begin
  inherited;
  FOffset := BtKeyPos(@Inv.FolioNum, @Inv);
end;

{ TExtendedDetailTest }

constructor TExtendedDetailTest.Create;
begin
  inherited;
  FOffset := BTKeyPos(@ID.FolioRef, @ID);
end;

{ TExtendedStockTest }

constructor TExtendedStockTest.Create;
begin
  inherited;
  FOffset := BtKeyPos(@Stock.StockFolio, @Stock);
end;

end.

unit SaleItem;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  VarConst, GlobVar, BtKeys1U, BtrvU2, ETStrU, BTSupU1, SysUtils, MPComms, Comms,
  StrUtil;

const
  MinGroup        = 1;
  MaxGroup        = 16;

  siType_Dept         = 'D';
  siType_PLU          = 'P';
  siType_DeptVoid     = '8';
  siType_PLUVoid      = 'X';
  siType_HalfPLUVoid  = ':';
  siType_Discount     = '%';

  RowMode_Groups = 0;
  RowMode_Items  = 1;

  DLStatus_Added   = 0;
  DLStatus_Updated = 1;
  DLStatus_Skipped = 2;

  function GetGroupRec(const ArrayNo : LongInt) : Boolean;
  function DownLoadGroup(GroupNo  : LongInt; var DLStatus : Byte) : string;
  function DownLoadDept(DeptNo : LongInt; var DLStatus : Byte) : string;
  function GetDeptRec(const ArrayNo : LongInt) : Boolean;
  function GetPLURec(const ArrayNo : LongInt) : Boolean;
  function DownLoadPLU(PLUNo : LongInt; var DLStatus : Byte) : string;

implementation

function GetGroupRec(const ArrayNo : LongInt) : Boolean;
const
  Fnum = GroupF;
var
  GenStr : Str255;
  DStatus : Byte;
begin { GetGroupRec }
  if ArrayNo < 1 then ResetRec(GroupF) {trap for group zero problem}
  else begin
    GenStr := FullNomKey(ArrayNo);
    If (Find_Rec(B_GetEq, F [Fnum], Fnum, RecPtr [Fnum]^, GrArrayK, GenStr) <> 0)
    Then DownLoadGroup(ArrayNo, DStatus);{ Group not found - download from till }
    GetGroupRec := True;
  end;{if}
end;  { GetGroupRec }

function DownLoadGroup(GroupNo : LongInt; var DLStatus : Byte) : string;
const
  FileNum = GroupF;
  KeyNo   = grArrayK;
var
  iStatus : smallint;
  Update, Locked : Boolean;
  NewGroup : GroupRecType;
  GenStr : Str255;
  RetGroupRec : TGroupRec;
begin { DownLoadGroup }
  Result := '';
  with GroupRec do begin
    { Default to insert }
    Update := False;

    { Initialise Record }
    NewGroup.grArrayNo  := GroupNo;
    NewGroup.grName     := 'Group: ' + SetPadNo(IntToStr(GroupNo), 2);
    NewGroup.grNumber   := GroupNo;
    NewGroup.grDiscount := Syss.Markup;

    if FrmComms.WaitForGroupInfo(100, GroupNo, RetGroupRec) then {iStatus := ECRO.GetGroup(SetPadNo(Form_Int(GroupNo, 0), 2));}
      begin
        Result := RetGroupRec.Name;

        { Build key for required Group }
        GenStr := FullNomKey (GroupNo);

        { try to get any existing record for this Group }
        iStatus := Find_Rec (B_GetEq, F [FileNum], FileNum, RecPtr [FileNum]^, KeyNo, GenStr);
        if (iStatus = 0) then
          begin
            { Retrieved an existing group from file }
            Update := True;

            { Better lock it }
            GenStr := siType_Dept + FullNomKey (GroupNo);
            If GetMultiRec(B_GetDirect, B_SingLock, GenStr, KeyNo, FileNum, FALSE, Locked) Then ;
          end { If }
        else GroupRec := NewGroup; { no existing group }

        { copy till group details into record }
        grName := RetGroupRec.Name;{grName   := ECRO.GroupTitleStr.Title;}
        grNumber := StrToInt(RetGroupRec.GroupNo);{grNumber := ECRO.GroupTitleStr.GroupNumber;}

        if (grNumber = 0) then grNumber := GroupNo;
      end { If }
    else GroupRec := NewGroup;

    if Update then
      begin
        { Update }
        iStatus := Put_Rec(F[FileNum], FileNum, RecPtr[FileNum]^, KeyNo);
        DLStatus := DLStatus_Updated;
      end { If }
    else begin
      { Insert new group }
      iStatus := Add_Rec(F[FileNum], FileNum, RecPtr[FileNum]^, KeyNo);
      DLStatus := DLStatus_Added;
    end; { Else }

    { Report any Btrieve problems }
    Report_BError(FileNum, iStatus);
  end; { With }
end;  { DownLoadGroup }

function GetDeptRec(const ArrayNo : LongInt) : Boolean;
const
  Fnum = ItemF;
var
  GenStr : Str255;
  DStatus : Byte;
begin { GetDeptRec }
  { build index string }
  GenStr := siType_Dept + FullNomKey (ArrayNo);

  if (Find_Rec (B_GetEq, F [Fnum], Fnum, RecPtr [Fnum]^, siTypeK, GenStr) <> 0) then DownLoadDept (ArrayNo, DStatus);{Dept not found - download from till}
  GetDeptRec := True;
end;  { GetDeptRec }


function DownLoadDept (DeptNo   : LongInt; var DLStatus : Byte) : string;
const
  FileNum = ItemF;
  KeyNo = siTypeK;
var
  iStatus : smallint;
  Update, Locked, Want : Boolean;
  NewItem : ItemRecType;
  GenStr : Str255;
  DeptRec: TDeptRec;
begin { DownLoadDept }
  Result := '';
  with ItemRec do begin
    { Default to insert }
    Update := False;

    { Initialise Record }
    FillChar(NewItem,SizeOf(NewItem),#0);
    NewItem.siType := siType_Dept;
    NewItem.siNumber := DeptNo;
//    NewItem.siGroup := 0;
//    NewItem.siName := '';
//    NewItem.siOverride := False;
//    NewItem.siDiscount := 0.0;

    { Default to wanting to insert record }
    Want := True;

    { Get PLU from till }
    {iStatus := ECRO.GetDept (DeptNo);
    If (iStatus = 0) Then Begin}

    if FrmComms.WaitForDeptInfo(100, DeptNo, DeptRec) then
      begin
        Result := DeptRec.Name;

        { Build key for required PLU }
        GenStr := siType_Dept + FullNomKey (DeptNo);

        { try to get any existing record for this dept }
        iStatus := Find_Rec (B_GetEq, F [FileNum], FileNum, RecPtr [FileNum]^, KeyNo, GenStr);
        if (iStatus = 0) then Update := True{ Retrieved an existing Dept from file }
        else ItemRec := NewItem;{ no existing group - add a new one }


        {Want := ((SiGroup <> ECRO.DeptRecStr.GroupNum) Or (SiName  <> ECRO.DeptRecStr.Name)) And (ECRO.DeptRecStr.Name <> '') And ((ECRO.DeptRecStr.GroupNum >= MinGroup) And (ECRO.DeptRecStr.GroupNum <= MaxGroup));}
        Want := ((SiGroup <> StrToInt(DeptRec.GroupNo)) or (SiName  <> DeptRec.Name))
        and (DeptRec.Name <> '') and ((StrToInt(DeptRec.GroupNo) >= MinGroup)
        and (StrToInt(DeptRec.GroupNo) <= MaxGroup));

        if Want then begin
          if Update then begin
            { lock record for update }
            if GetMultiRec(B_GetDirect, B_SingLock, GenStr, KeyNo, FileNum, FALSE, Locked) then ;
          end;{if}

          { copy till group details into record }
          siGroup := StrToInt(DeptRec.GroupNo);
          siName := DeptRec.Name;
        end; { If }
      end { If }
    else ItemRec := NewItem;{ Failed to get PLU from till }


    if Want then
      begin
        if Update then
          begin
            { Update }
            iStatus := Put_Rec(F[FileNum], FileNum, RecPtr[FileNum]^, KeyNo);
            DLStatus := DLStatus_Updated;
          end { If }
        else begin
          { Insert new group }
          iStatus := Add_Rec(F[FileNum], FileNum, RecPtr[FileNum]^, KeyNo);
          DLStatus := DLStatus_Added;
        end; { Else }

        { Report any Btrieve problems }
        Report_BError(FileNum, iStatus);
      end { If }
    else DLStatus := DLStatus_Skipped;{ unlock record }

  end; { With }
end;  { DownLoadDept }

function GetPLURec (const ArrayNo : LongInt) : Boolean;
const
  Fnum = ItemF;
var
  GenStr  : Str255;
  DStatus : Byte;
begin { GetPLURec }
  { build index string }
  GenStr := siType_PLU + FullNomKey (ArrayNo);

  if (Find_Rec (B_GetEq, F [Fnum], Fnum, RecPtr [Fnum]^, siTypeK, GenStr) <> 0) then DownLoadPLU(ArrayNo, DStatus);{ PLU not found - download from till }
  GetPLURec := True;
end;  { GetPLURec }

function DownLoadPLU (PLUNo : LongInt; var DLStatus : Byte) : string;
const
  FileNum = ItemF;
  KeyNo   = siTypeK;
var
  iGroup : Integer;
  iStatus : smallint;
  Update, Locked, Want : Boolean;
  NewItem : ItemRecType;
  GenStr : Str255;
  ProductRec : TProductRec;
begin { DownLoadPLU }
  Result := '';
  with ItemRec do begin
    { Default to insert }
    Update := False;

    { Initialise Record }
    FillChar(NewItem,SizeOf(NewItem),#0);
    NewItem.siType     := siType_PLU;
    NewItem.siNumber   := PLUNo;
//    NewItem.siGroup    := 0;
//    NewItem.siName     := '';
//    NewItem.siOverride := False;
//    NewItem.siDiscount := 0.0;

    { Default to wanting to insert record }
    Want := True;

    { Get PLU from till }
    {iStatus := ECRO.GetPLU (PLUNo);}
{    If (iStatus = 0) Then}

    if FrmComms.WaitForProductInfo(100, PLUNo, ProductRec) then
      begin
        Result := ProductRec.Name;

        { Build key for required PLU }
        GenStr := siType_PLU + FullNomKey (PLUNo);

        { try to get any existing record for this dept }
        iStatus := Find_Rec (B_GetEq, F [FileNum], FileNum, RecPtr [FileNum]^, KeyNo, GenStr);
        if (iStatus = 0) then Update := True{ Retrieved an existing PLU from file }
        else ItemRec := NewItem;{ no existing group - add a new one }

        {Want := ((SiGroup <> ECRO.PLURecStr.Group) Or (SiName  <> ECRO.PLURecStr.Name)) And ((ECRO.PLURecStr.Group >= MinGroup) And (ECRO.PLURecStr.Group <= MaxGroup));}

        iGroup := StrToInt(ProductRec.Group);
{        Want := ((SiGroup <> iGroup) or (SiName  <> ProductRec.Name))
        and ((iGroup >= MinGroup) and (iGroup <= MaxGroup));}

        Want := TRUE;

        if Want then begin
          if Update then begin
            { lock record for update }
            if GetMultiRec(B_GetDirect, B_SingLock, GenStr, KeyNo, FileNum, FALSE, Locked) then ;
          end;{if}

          { copy till PLU details into record }
          siGroup := iGroup;
          siName := ProductRec.Name;
          siPrice := StrToFloatDef(ProductRec.Price,0);
        end; { If }
      end { If }
    else ItemRec := NewItem;{ Failed to get PLU from till }

    if Want then
      begin
        if Length(TrimString(psRight,ItemRec.siName,' ')) <> 0 then begin
          if Update then
            begin
              { Update }
              iStatus := Put_Rec(F[FileNum], FileNum, RecPtr[FileNum]^, KeyNo);
              DLStatus := DLStatus_Updated;
            end { If }
          else begin
            { Insert new group }
            iStatus := Add_Rec(F[FileNum], FileNum, RecPtr[FileNum]^, KeyNo);
            DLStatus := DLStatus_Added;
          end; { Else }
          Report_BError(FileNum, iStatus);{ Report any Btrieve problems }
        end;{if}
      end { If }
    else DLStatus := DLStatus_Skipped;{ unlock record }
  end; { With }
end;  { DownLoadPLU }

end.

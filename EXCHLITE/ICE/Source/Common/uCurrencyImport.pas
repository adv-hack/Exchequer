unit uCurrencyImport;

interface

uses
  SysUtils,

  // Exchequer units
  GlobVar,
  VarConst,
  BtrvU2,

  // ICE units
  MSXML2_TLB,
  uBaseClass,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uImportBaseClass;

{$I ice.inc}

type
  TCurrencyImport = class(_ImportBase)
  protected
    isFileOpen: Boolean;
    procedure AddRecord(pNode: IXMLDOMNode); override;
    function ReadCurrencyDetails: Boolean;
    function WriteCurrencyDetails(PageNode: IXMLDOMNode): Boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
    function SaveListToDB: Boolean; override;
  end;

implementation

uses
  BtSupU1;

// ===========================================================================
// TCurrencyImport
// ===========================================================================

procedure TCurrencyImport.AddRecord(pNode: IXMLDOMNode);
{ Called by the Extract method in the _ImportBase class. }
var
  FuncRes: LongInt;
  ErrorCode: Integer;
begin
  ErrorCode := 0;
  FuncRes   := 0;

  if not isFileOpen then
  begin
    SetDrive := DataPath;
    Clear;
    { Open the System Settings table and retrieve the Currency details. }
    FuncRes := Open_File(F[SysF], SetDrive + FileNames[SysF], 0);
    if (FuncRes = 0) and ReadCurrencyDetails then
      isFileOpen := True
    else
      ErrorCode := cCONNECTINGDBERROR;
  end;

  if (ErrorCode = 0) then
    { Write the currency details from the XML file to the currency arrays. }
    WriteCurrencyDetails(pNode);

  { Log any errors. }
  if (ErrorCode <> 0) then
  begin
    if (FuncRes <> 0) then
      DoLogMessage('TCurrencyImport.AddRecord', ErrorCode,
                   'Error: ' + IntToStr(FuncRes))
    else
      DoLogMessage('TCurrencyImport.AddRecord', ErrorCode);
  end;
end;

// ---------------------------------------------------------------------------

constructor TCurrencyImport.Create;
begin
  inherited;
  isFileOpen := False;
end;

// ---------------------------------------------------------------------------

destructor TCurrencyImport.Destroy;
var
  FuncRes: LongInt;
begin
  if isFileOpen then
  begin
    FuncRes := Close_File(F[SysF]);
    isFileOpen := False;
    if ((FuncRes <> 0) and (FuncRes <> 3)) then
      DoLogMessage('TCurrencyImport.Destroy: ' +
                   'error closing file',
                   cCONNECTINGDBERROR,
                   'Error: ' + IntToStr(FuncRes));
  end;
  inherited;
end;

function TCurrencyImport.ReadCurrencyDetails: Boolean;
{ Read the current currency details into the System Settings record
  structure. }
var
  TempSys  :  Sysrec;
  Key2F    :  Str255;
  FuncRes  :  SmallInt;
  SysMode :  SysRecTypes;
  ModeNo: Integer;
const
  // There are six records of Currency details.
  Modes: array[0..5] of SysRecTypes =
    (
      CurR,
      CuR2,
      CuR3,
      GCuR,
      GCU2,
      GCU3
    );
begin
  TempSys := Syss;
  Result := True;
  try
    for ModeNo := Low(Modes) to High(Modes) do
    begin

      {
        ----------------------------------------------------------------------
        Much of the following code has been copied from
        x:\entrprse\r&r\btsupu1.pas, GetMultiSys().
        ----------------------------------------------------------------------
      }

      SysMode := Modes[ModeNo];
      Key2F   := SysNames[SysMode];
      FuncRes := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, 0, Key2F);

      if (FuncRes = 0) then
      begin
        FuncRes := GetPos(F[SysF], SysF, SysAddr[SysMode]);
        if (FuncRes = 0) then
        begin
          case SysMode of
            CurR, CuR2, CuR3:
              begin
                Move(Syss, SyssCurr1P^, Sizeof(SyssCurr1P^));
                SetCurrPage(Succ(Ord(SysMode)-Ord(CurR)),
                            SyssCurr1P^,
                            SyssCurr^,
                            BOn);
              end;
            GCuR, GCU2, GCU3:
              begin
                Move(Syss, SyssGCur1P^, Sizeof(SyssGCur1P^));
                SetGCurPage(Succ(Ord(SysMode)-Ord(GCuR)),
                            SyssGCuR1P^,
                            SyssGCuR^,
                            BOn);
              end;
          end; { case SysMode of... }
        end { if (FuncRes = 0)... }
        else
        begin
          DoLogMessage('TCurrencyImport.ReadCurrencyDetails',
                       cDBNORECORDFOUND,
                       'Error: ' + IntToStr(FuncRes));
          Result := False;
        end;
      end { if (FuncRes = 0)... }
      else
      begin
        DoLogMessage('TCurrencyImport.ReadCurrencyDetails',
                     cDBNORECORDFOUND,
                     'Error: ' + IntToStr(FuncRes));
        Result := False;
      end;
    end; { for ModeNo := Low(Modes)... }
  except
    on Exception do
    begin
      Result := False;
    end;
  end;
  Syss := TempSys;
end;

// ---------------------------------------------------------------------------

function TCurrencyImport.SaveListToDB: Boolean;
var
  TempSys:  Sysrec;
  FuncRes:  SmallInt;
  SysMode:  SysRecTypes;
  ModeNo: Integer;
const
  // There are six records of Currency details.
  Modes: array[0..5] of SysRecTypes =
    (
      CurR,
      CuR2,
      CuR3,
      GCuR,
      GCU2,
      GCU3
    );
begin
  TempSys := Syss;
  Result := True;
  try
    for ModeNo := Low(Modes) to High(Modes) do
    begin

      {
        ----------------------------------------------------------------------
        Much of the following code has been copied from
        x:\entrprse\r&r\btsupu1.pas, PutMultiSys().
        ----------------------------------------------------------------------
      }

      SysMode := Modes[ModeNo];
      ResetRec(SysF);
      SetDataRecOfs(SysF, SysAddr[SysMode]);
      FuncRes:=GetDirect(F[SysF], SysF, RecPtr[SysF]^, 0, 0);

      if (FuncRes = 0) then
      begin

        FuncRes := GetPos(F[SysF], SysF, SysAddr[SysMode]);

        if (FuncRes = 0) then
        begin
          case SysMode of
            CurR, CuR2, CuR3:
              begin
                 SyssCurr1P^.IDCode := SysNames[SysMode];

                 SetCurrPage(Succ(Ord(SysMode) - Ord(CurR)),
                             SyssCurr1P^,
                             SyssCurr^,
                             BOff);

                 Move(SyssCurr1P^, Syss, Sizeof(SyssCurr1P^));
              end;
            GCuR, GCU2, GCU3:
              begin
                 SyssGCuR1P^.IDCode := SysNames[SysMode];

                 SetGCurPage(Succ(Ord(SysMode) - Ord(GCuR)),
                             SyssGCuR1P^,
                             SyssGCuR^,
                             BOff);

                 Move(SyssGCur1P^, Syss, Sizeof(SyssGCur1P^));
              end;
          end; { case SysMode of... }

          FuncRes := Put_Rec(F[SysF], SysF, RecPtr[SysF]^, 0);
          if (FuncRes <> 0) then
          begin
            DoLogMessage('TCurrencyExport.SaveListToDB',
                         cUPDATINGDBERROR,
                         'Error: ' + IntToStr(FuncRes));
            Result := False;
          end;

        end; { if (FuncRes = 0)... }
      end; { if (FuncRes = 0)... }
    end; { for ModeNo := Low(Modes)... }
  except
    on Exception do
    begin
      Result := False;
    end;
  end;
  Syss := TempSys;
end;

// ---------------------------------------------------------------------------

function TCurrencyImport.WriteCurrencyDetails(PageNode: IXMLDOMNode): Boolean;
{ The Extract method of the base class will call this method once for each
  'currpage' XML node. Each of these nodes has multiple child entries, one
  for each currency entry. }
var
  PageNumber, PageOffset: Integer;
  EntryCount, EntryIndex: Integer;
  Idx: Integer;
  Node: IXMLDOMNode;
const
  PageOffsets: array[0..2] of Integer = (0, 31, 61);
begin
  Result := True;
  PageNumber := _GetNodeValue(PageNode, 'pageno');
  PageOffset := PageOffsets[PageNumber];
  { Find and process all the currency records in the current 'page'. }
  EntryCount := PageNode.childNodes.length;
  { The first child node (0) will be the page number, so start from node 1. } 
  for EntryIndex := 1 to EntryCount - 1 do
  begin
    Node := PageNode.childNodes[EntryIndex];
    if (Node.nodeName = 'currrec') then
    begin
      Idx := PageOffset + EntryIndex - 1;
      if (Idx <= High(SyssCurr^.Currencies)) then
      begin
        SyssCurr^.Currencies[Idx].SSymb := _GetNodeValue(Node, 'scsymbol');
        SyssCurr^.Currencies[Idx].Desc  := _GetNodeValue(Node, 'scdesc');
        SyssCurr^.Currencies[Idx].PSymb := _GetNodeValue(Node, 'scprintsymb');

        SyssCurr^.Currencies[Idx].CRates[True]  := _GetNodeValue(Node, 'scdailyrate');
        SyssCurr^.Currencies[Idx].CRates[False] := _GetNodeValue(Node, 'sccompanyrate');

        SyssGCur^.GhostRates.TriEuro[Idx]   := _GetNodeValue(Node, 'sctrieuroccy');
        SyssGCur^.GhostRates.TriRates[Idx]  := _GetNodeValue(Node, 'sctrirate');
        SyssGCur^.GhostRates.TriInvert[Idx] := _GetNodeValue(Node, 'sctriinvert');
        SyssGCur^.GhostRates.TriFloat[Idx]  := _GetNodeValue(Node, 'sctrifloating');
      end
      else
      begin
        DoLogMessage('TCurrencyImport.WriteCurrencyDetails', cXMLDATAMISMATCH);
        Result := False;
      end;
    end;
  end;
end;

// ---------------------------------------------------------------------------

end.

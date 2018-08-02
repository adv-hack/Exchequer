unit PIITreePrint;

interface

uses
  PIIScannerIntf, PIIFieldNumbers, ReportU;

type
  TPIITreePrinter = Object(TGenReport)
  private
    oScanner : IPIIScanner;
    FIncludeNotes : Boolean;

  public
    procedure PrintItems(const ItemList : IPIIInfoList; Level : Integer);
    procedure SetStyle(const ThisItem : IPIIInfoItem);
    procedure PrintThisLine(const AText : string);
    procedure PrintNotes(const Item : IPIIInfoHeader; Level : Integer);

    procedure RepSetTabs; Virtual;
    function GetReportInput : Boolean; virtual;
    procedure RepPrint(Sender  :  TObject); Virtual;
    procedure PrintReportLine; Virtual;
    Procedure RepPrintHeader(Sender  :  TObject); Virtual;

    property Scanner : IPIIScanner read oScanner write oScanner;
    property IncludeNotes : Boolean read FIncludeNotes write FIncludeNotes;
  end;

  procedure AddPIIPrintToQueue(AOwner : TObject;
                              const AScanner : IPIIScanner;
                              WantNotes : Boolean;
                              Title : string);

implementation

uses
  RPBase,RpDefine,RpDevice, RpFiler, Graphics, SysUtils, VarConst, GlobVar,
  ExThrd2U, oPIIDataAccess, BtrvU2, StrUtils, EtDateU;

procedure AddPIIPrintToQueue(AOwner : TObject;
                             const AScanner : IPIIScanner;
                             WantNotes : Boolean;
                              Title : string);
var
  PIIPrint : ^TPIITreePrinter;
begin
  if (Create_BackThread) then
  begin
    New(PIIPrint, Create(AOwner));
    With PIIPrint^ do
    Try
      Scanner := AScanner;
      IncludeNotes := WantNotes;
      RepTitle := 'PII Report for ' + Title;
      PageTitle := 'PII Report for ' + Title;
      
      If (Start) and (Create_BackThread) then
      Begin

        With BackThread do
          AddTask(PIIPrint,ThTitle);
      end
      else
      Begin
        Set_BackThreadFlip(BOff);
        Dispose(PIIPrint,Destroy);
      end;
    Except
      Dispose(PIIPrint,Destroy);
    End; {try..}


  end;
end;

{ TPIITreePrinter }

function TPIITreePrinter.GetReportInput: Boolean;
begin
  Result := True;
end;

//Main procedure called recursively to print tree
procedure TPIITreePrinter.PrintItems(const ItemList: IPIIInfoList; Level : Integer);
var
  ThisItem : IPIIInfoItem;
  i : Integer;
begin
  for i := 0 to ItemList.Count - 1 do
  begin
    ThisItem := ItemList[i];
    if IncludeInTree(ThisItem.FieldType) then
    begin
      SetStyle(ThisItem);
      PrintThisLine(StringOfChar(' ', (4 * Level)) + ThisItem.DisplayText);
      if ThisItem.HasChildren then
      begin
        PrintItems(ThisItem.Children, Level + 1);
      end;

      if FIncludeNotes and (ThisItem.FieldType = PIINote) then
        PrintNotes(ThisItem as IPIIInfoHeader, Level + 1);
    end;
  end;
end;

procedure TPIITreePrinter.PrintNotes(const Item: IPIIInfoHeader; Level : Integer);
var
  OwnerType : TPIIOwnerType;
  RecAddress : Integer;
  bRes : Boolean;
begin
  DefFont(0, []);

  //Separate owner type and keystring
  KeyS := Copy(Item.KeyString, 3, Length(Item.KeyString));
  OwnerType := GetNoteOwnerType(Item.KeyString[2]);
  with oScanner do
  begin
    bRes := DataAccess.FindFirst(dtNote, OwnerType, KeyS, RecAddress);
    while bRes do
    begin
      with DataAccess.ExLocal.LPassWord.NotesRec do
      begin
        //Don't include audit notes as no PII info
        if NType <> '3' then
        begin
          PrintThisLine(StringOfChar(' ', (4 * Level)) + Trim(NoteLine) +
              IfThen(NType = '1', '', ' (' + POutDate(NoteDate) + ')'));
        end; //not audit note

        bRes := DataAccess.FindNext(dtNote, OwnerType, KeyS, RecAddress);
      end;
    end;
  end;
end;

procedure TPIITreePrinter.PrintReportLine;
begin
  //No need to do anything here but needs to be declared
  //to prevent ancester being called
end;


procedure TPIITreePrinter.PrintThisLine(const AText: string);
begin
  with RepFiler1 do
  begin
    If (LinesLeft<=5) then
      ThrowNewPage(5);
    SendLine(#9 + AText);
  end;
end;

procedure TPIITreePrinter.RepPrint(Sender: TObject);
begin
  //Print first line - code and name
  PrintThisLine(oScanner.PIITree.DisplayText);

  //Call procdure to print tree
  PrintItems(oScanner.PIITree.Children, 0);
end;

procedure TPIITreePrinter.RepPrintHeader(Sender: TObject);
Begin
  If (RepFiler1.CurrentPage = 1) Or (RDevRec.fePrintMethod <> 5) Or ((RDevRec.fePrintMethod = 5) And RDevRec.feMiscOptions[2]) Then
  Begin
    With RepFiler1 do
    Begin

      If (CurrentPage=1) then
      Begin
        RepSetTabs;

        SendTabsToXLSX(False {UpdateExistingTabs});
      end;

      PrintHedTit;

      PrintStdPage;


    end;
  end;
end;

procedure TPIITreePrinter.RepSetTabs;
begin
  with RepFiler1 do
  begin
    SetTab (MarginLeft, pjLeft, 600, 4, 0, 0);
  end;
end;

procedure TPIITreePrinter.SetStyle(const ThisItem: IPIIInfoItem);
begin
  if ThisItem.ItemType = itHeader then
    DefFont(0, [fsBold])
  else
    DefFont(0, []);
end;

end.

unit LeagueTableF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uMultiList, StdCtrls;

type
  TfrmLeagueTable = class(TForm)
    mulLeagueTable: TMultiList;
    btnClose: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Function GetAutoSelect : ShortString;
    Procedure SetAutoSelect (Value : ShortString);
  public
    { Public declarations }
    Property AutoSelect : ShortString Read GetAutoSelect Write SetAutoSelect;
  end;

procedure DisplayLeagueTable (Const ParentForm : TForm; Const AutoSelect : ShortString);
procedure UpdateLeagueTable (Const ComputerDesc : ShortString; Const TestTime : Int64);

implementation

{$R *.dfm}

Uses math;

Var
  LeagueFileName : ShortString;

//=========================================================================

procedure DisplayLeagueTable (Const ParentForm : TForm; Const AutoSelect : ShortString);
var
  frmLeagueTable: TfrmLeagueTable;
Begin // DisplayLeagueTable
  If FileExists(LeagueFileName) Then
  Begin
    frmLeagueTable := TfrmLeagueTable.Create(ParentForm);
    Try
      frmLeagueTable.AutoSelect := AutoSelect;
      frmLeagueTable.ShowModal;
    Finally
      FreeAndNIL(frmLeagueTable);
    End; // Try..Finally
  End; // If FileExists(LeagueFileName)
End; // DisplayLeagueTable

//-------------------------------------------------------------------------

procedure UpdateLeagueTable (Const ComputerDesc : ShortString; Const TestTime : Int64);
Var
  LeagueFile : TStringList;
  sEntryName : String[30];
Begin // UpdateLeagueTable
  Try
    LeagueFile := TStringList.Create;
    Try
      If FileExists(LeagueFileName) Then
        LeagueFile.LoadFromFile(LeagueFileName);

      sEntryName := Trim(ComputerDesc) + StringOfChar(' ', SizeOf(sEntryName)-1);
      LeagueFile.Add (sEntryName + ': ' + IntToStr(TestTime));

      LeagueFile.SavetoFile(LeagueFileName);
    Finally
      FreeAndNIL(LeagueFile);
    End; // Try..Finally
  Except
    // Bury errors as we aren't interested
    On Exception Do
      ;
  End; // Try..Except
End; // UpdateLeagueTable

//=========================================================================

procedure TfrmLeagueTable.FormCreate(Sender: TObject);
Var
  LeagueFile : TStringList;
  sEntryName, sEntrytime : String[30];
  iEntryTime : Int64;
  I : SmallInt;
begin
  ClientHeight := 346;
  ClientWidth := 386;

  // Load League Table
  LeagueFile := TStringList.Create;
  Try
    LeagueFile.LoadFromFile(LeagueFileName);

    For I := 0 To (LeagueFile.Count - 1) Do
    Begin
      sEntryName := Trim(Copy(LeagueFile.Strings[I], 1, 30));

      sEntryTime := Trim(Copy(LeagueFile.Strings[I], 32, Length(LeagueFile.Strings[I])));
      iEntryTime := StrToIntDef(sEntryTime,-1);

      mulLeagueTable.DesignColumns[0].Items.Add(sEntryName);
      mulLeagueTable.DesignColumns[1].Items.Add(Format('%0.3f', [RoundTo(iEntryTime / 1000,-3)]));
      mulLeagueTable.DesignColumns[2].Items.Add(Format('%10.10d', [iEntryTime]));

      mulLeagueTable.SortColumn(2,True);
    End; // For I
  Finally
    FreeAndNIL(LeagueFile);
  End; // Try..Finally
end;

//-------------------------------------------------------------------------

Function TfrmLeagueTable.GetAutoSelect : ShortString;
Begin // GetAutoSelect
  Result := mulLeagueTable.DesignColumns[0].Items[mulLeagueTable.Selected];
End; // GetAutoSelect

Procedure TfrmLeagueTable.SetAutoSelect (Value : ShortString);
Begin // SetAutoSelect
  mulLeagueTable.Selected := mulLeagueTable.DesignColumns[0].Items.IndexOf(Trim(Value));
End; // SetAutoSelect

//-------------------------------------------------------------------------

Initialization
  LeagueFileName := ChangeFileExt(Application.ExeName, '.Dat');
end.

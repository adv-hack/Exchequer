unit EntUtil;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

// Notes: Wrapper code around Enterprise utility routines

interface

uses
  ExWrap1U, StdCtrls, Forms, Classes;

type
  TExLocalEBus = object(TdMTExLocal)
    ShowErrors : boolean;
    function  OpenOneFile(FileID : integer; CompPath, FileName : string) : integer;
    procedure CloseSelFiles(FileIDs : array of integer);
    constructor Create(ClientId : smallInt);
  end;

  TButtonInfo = record
    Button : TButton;
    Top    : integer;
  end;
  pButtonInfo = ^TButtonInfo;

  // Enterprise uses vertical rows of buttons in scroll boxes.
  // Sometimes these button are disabled so it's nice to shuffle them to the
  // top of the scroll box.  Set the button's enabled property to false, pass
  // a reference to the parent scroll box into the constructor and then call
  // Shuffle Buttons. Disable buttons are made invisible
  TShuffleButtons = class
    private
      fScrollBox  : TScrollBox;
      fButtonList : TList;
      fButtonGap  : integer;
      fButtonHeight: integer;
      procedure SetInteger(const Index, Value: integer);
    protected
      procedure SortButtons;
    public
      procedure ShuffleButtons;
      // Gap between buttons in pixels
      property  ButtonGap : integer index 1 read fButtonGap write SetInteger;
      // Height of buttons in pixels (assumes all same height)
      property  ButtonHeight : integer index 2 read fButtonHeight write SetInteger;
      constructor Create(ScrollBox : TScrollBox);
      destructor  Destroy; override;
  end;


implementation

uses
  GlobVar, Dialogs, SysUtils, EBusUtil, BtrvU2, Debugger, StrUtil; 

//=======================================================================

constructor TExLocalEBus.Create(ClientId : smallInt);
begin
  inherited Create(ClientId);
  ShowErrors := false;
end;

//-----------------------------------------------------------------------

function TExLocalEBus.OpenOneFile(FileID : integer; CompPath, FileName : string) : integer;
var
  SetAccel : integer;
  FilePath : string;
begin
  SetAccel := -1*Ord(AccelMode);

  {$IFDEF EXTERNALIMPORT}
    FilePath := CompPath + Filename;
  {$ELSE}
    FilePath := GetEBusSubDir(CompPath, FileName);
  {$ENDIF}

  LStatus := Open_FileCId(LocalF^[FileID], FilePath, SetAccel, ExClientId);
  Debug.Show('TExLocalEBus.OpenOneFile' + CRLF + 'FilePath = ' + FilePath);
  if ShowErrors and (LStatus <> 0) then
    MessageDlg(Format('Could not open %s, status = %d' + CRLF + '%s',
      [FilePath, LStatus, Set_StatMes(LStatus)]), mtError, [mbOK], 0);
  Result := LStatus;
end;

//-----------------------------------------------------------------------

procedure TExLocalEBus.CloseSelFiles(FileIDs : array of integer);
var
  i : integer;
  FSpec   : FileSpec;


begin
  for i := 0 to Length(FileIDs) -1 do
  Begin
    If (GetFileSpecCId(LocalF^[FileIDs[i]],FileIDs[i],FSpec,ExClientId)=0) then {Check file already open}
      Close_FileCId(LocalF^[FileIDs[i]], ExClientID);
  end;
end;

//=======================================================================

constructor TShuffleButtons.Create(ScrollBox: TScrollBox);
begin
  inherited Create;
  fScrollBox := ScrollBox;
  fButtonList := TList.Create;
  // Enterprise buttons are 80 x 21 as standard
  ButtonGap := 2;
  ButtonHeight := 21;
end;

//-----------------------------------------------------------------------

destructor TShuffleButtons.Destroy;
var
  i : integer;
begin
  for i := 0 to fButtonList.Count - 1 do
    dispose(fButtonList[i]);
  fButtonList.Free;
  inherited Destroy;
end;

//-----------------------------------------------------------------------

procedure TShuffleButtons.SetInteger(const Index, Value: integer);
begin
  case Index of
    1 : fButtonGap := Value;
    2 : fButtonHeight := Value;
  end;
end;

//-----------------------------------------------------------------------

function SortByTopCoord(Item1, Item2: Pointer): Integer;
var
  Top1, Top2 : integer;
begin
  Top1 := pButtonInfo(Item1)^.Top;
  Top2 := pButtonInfo(Item2)^.Top;
  if Top1 < Top2 then
    Result := -1
  else
    if Top1 > Top2 then
      Result := +1
    else
      Result := 0;
end;

//-----------------------------------------------------------------------

procedure TShuffleButtons.SortButtons;
var
  ButtonInfo : pButtonInfo;
  i : integer;
begin
  for i := 0 to fScrollBox.ControlCount -1 do
    if fScrollBox.Controls[i] is TButton then
      begin
        new(ButtonInfo);
        ButtonInfo^.Button := fScrollBox.Controls[i] as TButton;
        ButtonInfo^.Top := (fScrollBox.Controls[i] as TButton).Top;
        fButtonList.Add(ButtonInfo);
      end;

   fButtonList.Sort(SortByTopCoord);
end;

//-----------------------------------------------------------------------

procedure TShuffleButtons.ShuffleButtons;
var
  i,
  Posn : integer;
begin
  SortButtons;
  Posn := ButtonGap;
  for i := 0 to fButtonList.Count -1 do
    with pButtonInfo(fButtonList[i])^.Button do
    begin
      if Enabled then
      begin
        Top := Posn;
        inc(Posn, ButtonGap + ButtonHeight);
      end
      else
        Visible := false;
    end;
end;


end.



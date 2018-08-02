unit testini;

{ prutherford440 09:55 04/12/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes, TestCons;

type

  TConfigRec = Record
    Name     : String[25];
    Value    : String[50];
    ValType  : Byte; //0 = switch, 1 = integer, 2 = string, 3 = path, 4 = date, 5 = split
    Parent   : Byte;
    HelpStr  : String[100];
  end;

  TDllIni = Class
    private
      FList : TStringList;
      Items : Array[1..MaxConfigItems] of TConfigRec;
      FFileName : string; //including full path
      FChanged : Boolean;
      function GetValue(const ALine : string) : string;
    protected
      procedure SetFileName(const FName : string);
      function GetItem(i : integer) : TConfigRec;
    public
      constructor Create;
      destructor Destroy; override;
      function Load : Boolean;
      function ReadIniValue(const AName : string) : string;
      procedure WriteIniValue(const AName, AValue : string);
      function Save : Boolean;
      function GetText : TStrings;
      procedure UpdateConfigItem(const AName, AValue1, AValue2 : string);
      function NameExists(const AName : string) : Boolean;
      property FileName : string read FFileName write SetFileName;
      property ConfigItems[Index : integer] : TConfigRec read GetItem;
      property Changed : Boolean read FChanged write FChanged;
    end;

implementation

uses
  SysUtils;

constructor TDllIni.Create;
begin
  inherited Create;
  FList := TStringList.Create;
end;

destructor TDllIni.Destroy;
begin
  if Assigned(FList) then
    FList.Free;
end;

function TDllIni.Load : Boolean;
var
  i : integer;
begin
  Result := True;
  Try
    for i := 1 to MaxConfigItems do
      FillChar(Items[i], SizeOf(Items[i]), #0);

    if Assigned(FList) then
      FList.LoadFromFile(FFileName);

    //v550 added new switch
    if not NameExists('No_Trans_To_Closed_Jobs') and not NameExists('No_Trans_To_Closed_Job') then
      FList.Add('No_Trans_To_Closed_Jobs     OFF');

    for i := 1 to MaxConfigItems do
    begin
      with Items[i] do
      begin
        Name := ConfigNames[i];
        ValType := ConfigTypes[i];
        Value := ReadIniValue(Name);
        if ValType in  [0, 5] then
          Parent := 1
        else
        if ValType = 3 then
          Parent := 0
        else
          Parent := 2;

      //Load help string here
        HelpStr := HelpString(i);
      end;
    end;


  Except
    Result := False;
  End;
end;


function TDllIni.ReadIniValue(const AName : string) : string;
var
  i : integer;
begin
  Result := '';
  if Assigned(FList) then
   for i := 0 to FList.Count - 1 do
   begin
     if Pos(AName, FList[i]) = 1 then
     begin
       Result := GetValue(FList[i]);
       if AName = 'Multi_Currency' then
       begin
         if Result = 'ON' then
           Result := 'ON  (Euro/Global)'
         else
         if Result = 'OFF' then
           Result := 'ON  (Euro/Global)';
       end;
       Break;
     end;
   end;
end;


procedure TDllIni.WriteIniValue(const AName, AValue : string);
var
  i : integer;
begin
  if Assigned(FList) then
   for i := 0 to FList.Count - 1 do
   begin
     if Pos(AName, FList[i]) = 1 then
     begin
        if AName = 'Multi_Currency' then
          FList[i] := Format('%-25s   %-14s',[AName, Trim(Copy(AValue, 1, 3))])
        else
          FList[i] := Format('%-25s   %-14s',[AName, AValue]);
       Break;
     end;
   end;
end;


function TDllIni.Save : Boolean;
begin
  Result := True;
  Try
    if Assigned(FList) then
      FList.SaveToFile(FFileName);
  Except
    Result := False;
  End;
end;

procedure TDllIni.SetFileName(const FName : string);
begin
  FFileName := FName;
end;

function TDllIni.GetValue(const ALine : string) : string;
var
  i : integer;
begin
  i := Pos(' ',ALine);
  if i > 0 then
    Result := Trim(Copy(ALine, i, Length(ALine)))
  else
    Result := '';
end;

function TDllIni.GetItem(i : integer) : TConfigRec;
begin
  Result := Items[i];
end;

procedure TDllIni.UpdateConfigItem(const AName, AValue1, AValue2 : string);
var
  i : integer;
begin
  for i := 1 to MaxConfigItems do
  begin
    if AName = Items[i].Name then
    begin
      Items[i].Value := AValue1;
      if AValue2 <> '' then
        Items[i].Value := Items[i].Value + ' ' + AValue2;
      WriteIniValue(Items[i].Name, Items[i].Value);
      Break;
    end;
  end;
end;

function TDllIni.GetText : TStrings;
begin
  Result := FList;
end;

function TDllIni.NameExists(const AName : string) : Boolean;
var
  i : integer;
begin
  Result := False;
  if Assigned(FList) then
   for i := 0 to FList.Count - 1 do
   begin
     if Pos(AName, FList[i]) = 1 then
     begin
       Result := True;
       Break;
     end;
   end;

end;




end.

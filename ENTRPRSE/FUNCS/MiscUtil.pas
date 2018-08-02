unit MiscUtil;

{ nfrewer440 16:35 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  CheckLst;

type
  TFormMode = (fmView, fmEdit, fmAdd);

  procedure ClearList(TheList: TObject);
  function GetCLBCheckCount(CheckListBox : TCheckListBox) : integer;
  function CLBCheckedToString(CheckListBox : TCheckListBox) : string;

implementation
uses
  Classes, comctrls, APIUtil, Dialogs;

procedure ClearList(TheList: TObject);
var
  iPos: integer;
begin
  if TheList is TList then
    begin
      {TList}
      for iPos := 0 to (TList(TheList).Count - 1) do TObject(TList(TheList)[iPos]).Free;
      TList(TheList).Clear;
    end
  else begin
    if TheList is TTreeView then
      begin
        {TTreeView}
        TTreeView(TheList).FullCollapse;
        for iPos := 0 to TTreeView(TheList).Items.Count - 1 do TObject(TTreeView(TheList).Items[iPos].Data).Free;
        TTreeView(TheList).Items.Clear;
      end
    else begin
      {TStringList / TStrings}
      if (TheList is TStrings) or (TheList is TStringList) then
        begin
          for iPos := 0 to (TStrings(TheList).Count - 1) do begin
            try
              TStrings(TheList).Objects[iPos].Free;
            except
              {Do nothing}
            end;{try}
          end;{for}
          TStrings(TheList).Clear;
        end
      else begin
        if TheList is TListView then
          begin
            {TTreeView}
            for iPos := 0 to TListView(TheList).Items.Count - 1 do TObject(TListView(TheList).Items[iPos].Data).Free;
            TListView(TheList).Items.Clear;
          end
        else msgbox('The object to be cleared is invalid', mtError, [mbOK], mbOK
        , 'Invalid object - ClearList()');
      end;{if}
    end;{if}
  end;{if}
end;

function GetCLBCheckCount(CheckListBox : TCheckListBox) : integer;
var
  iPos : integer;
begin{GetCheckCount}
  Result := 0;
  for iPos := 0 to CheckListBox.count -1 do begin
    if CheckListBox.checked[iPos] then Result := Result + 1;
  end;{for}
end;{GetCheckCount}

function CLBCheckedToString(CheckListBox : TCheckListBox) : string;
var
  iPos : integer;
begin{GetCheckCount}
  Result := '';
  for iPos := 0 to CheckListBox.count -1 do begin
    if CheckListBox.checked[iPos] then
    begin
      if Result = '' then Result := Result + CheckListBox.Items[iPos]
      else Result := Result + ', ' + CheckListBox.Items[iPos];
    end;
  end;{for}
end;{GetCheckCount}


end.

unit Select;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, DataModule, ADODB;

type
  TfrmAllocSelect = class(TForm)
    SBSButton1: TSBSButton;
    SBSButton2: TSBSButton;
    gbAlloc: TGroupBox;
    lbAlloc: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CurrentCo : string;

  function SelectAllocation(AGLCode : longint; const UDF : string) : string;
  Function FullNomKey(ncode  :  Longint)  :  ShortString;

implementation

{$R *.dfm}

uses
  AllcBase, AllocVar, Enterprise01_TLB;

Function FullNomKey(ncode  :  Longint)  :  ShortString;


Var
  TmpStr  :  ShortString;

Begin
  FillChar(TmpStr,Sizeof(TmpStr),0);

  Move(ncode,TmpStr[1],Sizeof(ncode));

  TmpStr[0]:=Chr(Sizeof(ncode));

  FullNomKey:=TmpStr;
end;

function ExtractName(s : string) : string;
begin
  Result := Copy(s, 1, Pos(',',s) - 1);
end;


function SelectAllocation(AGLCode : longint; const UDF : string) : string;

  function SQLSelectAllocation : string;
  var
    s : ShortString;
    Res  : integer;
    Trigger : Boolean;
    qRecords : TADOQuery;
  begin{SQLSelectAllocation}

    Result := '';
    Trigger := UDF = '';

    if not Trigger then
    begin
      qRecords := SQLDataModule.GetAllRecordsFor(CurrentCo, AGLCode, UDF);
      qRecords.First;
      Trigger := (qRecords.RecordCount = 0);
    end;{if}

    if Trigger then
    begin
      with oToolkit.GeneralLedger do
      begin
        Index := glIdxCode;
        Res := GetEqual(BuildCodeIndex(AGLCode));

        if Res = 0 then
        begin
          s := IntToStr(glCode) + ', ' + glName
        end;{if}
      end;{with}

      with TfrmAllocSelect.Create(nil) do
      Try
        gbAlloc.Caption := s;

        qRecords := SQLDataModule.GetAllRecordsFor(CurrentCo, AGLCode);
        qRecords.First;

        while (not qRecords.Eof) do
        begin
          s := Trim(qRecords.FieldByName('Name').AsString) + ', ' + Trim(qRecords.FieldByName('Description').AsString);
          if lbAlloc.Items.IndexOf(s) = -1 then
            lbAlloc.Items.Add(s);

          qRecords.Next;
        end;{while}

        if lbAlloc.Items.Count > 0 then
        begin
          lbAlloc.ItemIndex := 0;
          ShowModal;

          if ModalResult = mrOK then
            Result := ExtractName(lbAlloc.Items[lbAlloc.ItemIndex]);
        end;{if}
      finally
        Free;
      End;{try}
    end; //If Trigger
  end;{SQLSelectAllocation}

  function PervasiveSelectAllocation : string;
  var
    KeyS, KeyChk, s : ShortString;
    Res  : integer;
    Trigger : Boolean;
  begin{PervasiveSelectAllocation}
    Result := '';

    Trigger := UDF = '';

    if not Trigger then
    begin
      KeyS := CurrentCo + FullNomKey(AGLCode) + UDF;
      Res := FindRec(KeyS, B_GetGEq);

      Trigger := (Res <> 0) or (Trim(AllocRec.AllocName) <> UDF);
    end;

    if Trigger then
    begin
      with oToolkit.GeneralLedger do
      begin
        Index := glIdxCode;
        Res := GetEqual(BuildCodeIndex(AGLCode));

        if Res = 0 then
          s := IntToStr(glCode) + ', ' + glName
      end;

      with TfrmAllocSelect.Create(nil) do
      Try
        gbAlloc.Caption := s;
        KeyS := CurrentCo + FullNomKey(AGLCode);
        KeyChk := KeyS;

        Res := FindRec(KeyS, B_GetGEq);

        while (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk) do
        begin
          s := Trim(AllocRec.AllocName) + ', ' + Trim(AllocRec.AllocDesc);
          if lbAlloc.Items.IndexOf(s) = -1 then
            lbAlloc.Items.Add(s);

          Res := FindRec(KeyS, B_GetNext);
        end;

        if lbAlloc.Items.Count > 0 then
        begin
          lbAlloc.ItemIndex := 0;
          ShowModal;

          if ModalResult = mrOK then
            Result := ExtractName(lbAlloc.Items[lbAlloc.ItemIndex]);
        end;
      finally
        Free;
      End;
    end; //If Trigger
  end;{PervasiveSelectAllocation}

begin
  if bSQL then
  begin
    // MS-SQL
    Result := SQLSelectAllocation;
  end
  else
  begin
    // Pervasive
    Result := PervasiveSelectAllocation;
  end;{if}
end;

end.

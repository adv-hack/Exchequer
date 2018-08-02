unit codelist;

{ prutherford440 09:55 04/12/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Enterprise01_TLB;

type
  TfrmCodeList = class(TForm)
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    lvCodes: TListView;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure lvCodesDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetCCDep(const CCDep : ICCDept; const FKey : string; Atype : Byte) : string;
    function GetGLCode(const GL : IGeneralLedger; FKey : string) : string;
    function GetCurrency(const SS : ISystemSetup; Curr : integer) : string;
  end;

var
  frmCodeList: TfrmCodeList;

implementation

{$R *.DFM}

function TfrmCodeList.GetCCDep(const CCDep : ICCDept; const FKey : string; Atype : Byte) : string;
var
  Res : longint;
  ThisKey : WideString;
  AKey, TestStr : string;
begin
  if (Length(FKey) > 0) and (FKey[1] = '/') then
  begin
    AKey := Copy(UpperCase(FKey), 2, Length(FKey));
    ThisKey := CCDep.BuildNameIndex(AKey);
    CCDep.Index := cdIdxName;
  end
  else
  begin
    CCDep.Index := cdIdxCode;
    ThisKey := CCDep.BuildCodeIndex(FKey);
    AKey := UpperCase(FKey);
  end;
  if (Trim(FKey) = '') or (CCDep.GetEqual(ThisKey) = 0) then
    Result := ThisKey
  else
  begin
    with lvCodes, CCDep do
    begin
      Res := GetGreaterThanOrEqual(Trim(ThisKey));
      if Index = cdIdxCode then
        TestStr := cdCode
      else
        TestStr := cdName;
      while (Res = 0) and ((Pos(Trim(UpperCase(AKey)),UpperCase(TestStr)) = 1) or
                           (Trim(ThisKey) = '')) do
      begin
        with Items.Add do
        begin
          Caption := cdCode;
          SubItems.Add(cdName);
        end;

        Res := GetNext;
        if Index = cdIdxCode then
          TestStr := cdCode
        else
          TestStr := cdName;
      end;
    end; {with}
    if AType = 0 then
      Caption := 'Select Cost Centre'
    else
      Caption := 'Select Department';
    ShowModal;
    if ModalResult = mrOK then
      Result := lvCodes.Selected.Caption
    else
      Result := '';
  end;
end;

function TfrmCodeList.GetCurrency(const SS : ISystemSetup; Curr : integer) : string;
var
  i : integer;
  ValidCurrency : Boolean;
begin
  if Assigned(SS) then
  begin
    if (Curr > 0) and (Curr < 90) and (Length(SS.ssCurrency[Curr].scDesc) > 0) then
      Result := IntToStr(Curr)
    else
    with SS do
    begin
      i := 1;
      ValidCurrency := True;
      while (i < 90) and ValidCurrency do
      begin
        ValidCurrency := Length(ssCurrency[i].scDesc) > 0;
        if ValidCurrency then
        with lvCodes.Items.Add do
        begin
          Caption := IntToStr(i);
          SubItems.Add(ssCurrency[i].scDesc);
        end;
        inc(i);
      end;

      Caption := 'Select Currency';
      ShowModal;
      if ModalResult = mrOK then
      begin
        Result := lvCodes.Selected.Caption;
      end
      else
        Result := IntToStr(Curr);
    end;
  end
  else
  begin
    if (Curr < 1) or (Curr > 90) then
      Curr := 1;
    Result := IntToStr(Curr);
  end;
end;

function TfrmCodeList.GetGLCode(const GL : IGeneralLedger; FKey : string) : string;
var
  Res, IntKey : longint;
  ThisKey : WideString;
  AKey : WideString;
  TestStr : string;
begin
  Try
    if FKey[1] <> '/' then
      IntKey := StrToInt(FKey);
  Except
    if Trim(FKey) = '' then
      IntKey := 0
    else
      IntKey := -1;
    FKey := '0';
  End;

  if FKey[1] = '/' then
  begin
     ThisKey := GL.BuildNameIndex(Copy(FKey, 2, Length(FKey)));
     AKey := Copy(FKey, 2, Length(FKey));
     GL.Index := glIdxName;
     IntKey := -1;
  end
  else
  begin
    ThisKey := GL.BuildCodeIndex(IntKey);
    GL.Index := glIdxCode;
    AKey := FKey;
  end;


  AKey := UpperCase(AKey);
  if (IntKey = 0) or (GL.GetEqual(ThisKey) = 0) then
    Result := FKey
  else
  begin
    with lvCodes, GL do
    begin
      Res := GetFirst;
      while (Res = 0) do
      begin
        if Index = glIdxCode then
          TestStr := UpperCase(IntToStr(glCode))
        else
          TestStr := UpperCase(glName);
        if ((Pos(Trim(AKey),TestStr) = 1) or
                           (Trim(AKey) = '') or (IntKey = 0)) then
        begin
          with Items.Add do
          begin
            Caption := IntToStr(glCode);
            SubItems.Add(glName);
          end;
        end;

        Res := GetNext;
      end;
    end; {with}
    Caption := 'Select Nominal Code';
    ShowModal;
    if ModalResult <> mrCancel then
      Result := lvCodes.Selected.Caption
    else
      Result := '';
  end;
end;

procedure TfrmCodeList.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult = mrOk then
  begin
    if Assigned(lvCodes.Selected) then
    begin
      CanClose := True;
    end
    else
    begin
      CanClose := False;
      ShowMessage('Please select a code');
    end;
  end;
end;

procedure TfrmCodeList.FormActivate(Sender: TObject);
begin
  if lvCodes.Items.Count = 0 then
    ShowMessage('No matches found');
end;

procedure TfrmCodeList.lvCodesDblClick(Sender: TObject);
begin
  btnOK.Click;
end;

end.

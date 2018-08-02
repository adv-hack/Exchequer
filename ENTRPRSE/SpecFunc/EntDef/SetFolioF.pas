unit SetFolioF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Mask, bkgroup, ExtCtrls,
  VarConst,
  GlobVar, Buttons;

type
  TSetFolioFrm = class(TForm)
    TitlePnl: TPanel;
    Label1: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    SBSPanel4: TSBSBackGroup;
    Label2: TLabel;
    lblNewFolioNumber: TLabel;
    edtFolioNumber: TMaskEdit;
    OkCP1Btn: TButton;
    ClsCP1Btn: TButton;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    lblExistingFolioNumber: TLabel;
    txtExistingFolioNumber: TStaticText;
    IncBtn: TSpeedButton;
    DecBtn: TSpeedButton;
    lblError: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure IncBtnClick(Sender: TObject);
    procedure DecBtnClick(Sender: TObject);
    procedure edtFolioNumberExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure edtFolioNumberChange(Sender: TObject);
  private
    { Private declarations }
    FFolio: LongInt;
    FExistingFolio: LongInt;
    procedure SetFolio(Value: LongInt);
    function GetExistingFolio:  LongInt;
    function SetNewFolio(Folio: LongInt): Boolean;
    function ValidFolio: Boolean;
  public
    { Public declarations }
    property Folio: LongInt read FFolio write SetFolio;
  end;

function SetFolioNumber: Boolean;

implementation

{$R *.dfm}

uses
  BtrvU2,
  ProgU;

// -----------------------------------------------------------------------------

function SetFolioNumber: Boolean;
var
  Dlg: TSetFolioFrm;
begin
  Result := False;
  Dlg := TSetFolioFrm.Create(nil);
  try
    Dlg.ShowModal;
    if (Dlg.ModalResult = mrCancel) then
      Write_FixMsgFmt('Special Function 125 (Set Folio Number) has been aborted.', 4)
    else
      Result := True;
  finally
    Dlg.Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure TSetFolioFrm.DecBtnClick(Sender: TObject);
var
  CurrentFolio: LongInt;
begin
  CurrentFolio := StrToIntDef(edtFolioNumber.Text, FExistingFolio);
//  if (FFolio > (FExistingFolio + 1)) then
  if (FFolio > (FirstAddrD + 1)) then
    SetFolio(FFolio - 1);
end;

// -----------------------------------------------------------------------------

procedure TSetFolioFrm.edtFolioNumberChange(Sender: TObject);
begin
  lblError.Caption := '';
end;

// -----------------------------------------------------------------------------

procedure TSetFolioFrm.FormCreate(Sender: TObject);
begin
  FExistingFolio := GetExistingFolio;
  txtExistingFolioNumber.Caption := IntToStr(FExistingFolio);
  SetFolio(FExistingFolio + 1);
end;

// -----------------------------------------------------------------------------

function TSetFolioFrm.GetExistingFolio:  LongInt;
var
  Key  :  Str255;
  Folio: LongInt;
begin
  Key := DocCodes[AFL];

  Status := Find_Rec(B_GetEq, F[IncF], IncF, RecPtr[IncF]^, IncK, Key);
  if (Status = 0) then
    Move(Count.NextCount[1], Folio, Sizeof(Folio));

  Result := Folio;
end;

// -----------------------------------------------------------------------------

procedure TSetFolioFrm.IncBtnClick(Sender: TObject);
var
  CurrentFolio: LongInt;
begin
  CurrentFolio := StrToIntDef(edtFolioNumber.Text, FExistingFolio);
  if (CurrentFolio < -1) then
    SetFolio(CurrentFolio + 1);
end;

// -----------------------------------------------------------------------------

procedure TSetFolioFrm.OkCP1BtnClick(Sender: TObject);
begin
  if ValidFolio then
    SetNewFolio(FFolio)
  else
    ModalResult := mrNone;
end;

// -----------------------------------------------------------------------------

procedure TSetFolioFrm.SetFolio(Value: Integer);
begin
  FFolio := Value;
  edtFolioNumber.Text := IntToStr(Value);
end;

// -----------------------------------------------------------------------------

function TSetFolioFrm.SetNewFolio(Folio: Integer): Boolean;
var
  Key :  Str255;
  Locked   :  Boolean;
  TmpStatus:  Integer;
begin
  Result := False;

  Key := DocCodes[AFL];

  Status := Find_Rec(B_GetEq + B_SingNWLock, F[IncF], IncF, RecPtr[IncF]^, IncK, Key);
  Locked := (Status = 0);

  if (Locked) then
  with Count do
  begin
    Move(Folio, Count.NextCount[1], Sizeof(Folio));

    TmpStatus := Put_Rec(F[IncF], IncF, RecPtr[IncF]^, IncK);
    Result := (TmpStatus = 0);

    if not Result then
      Write_FixMsgFmt('Special Function 125 (Set Folio Number) failed. Error ' +
                      IntToStr(TmpStatus), 4);
  end;
end;

// -----------------------------------------------------------------------------

procedure TSetFolioFrm.edtFolioNumberExit(Sender: TObject);
begin
  if not ClsCP1Btn.Focused then
    ValidFolio;
end;

// -----------------------------------------------------------------------------

function TSetFolioFrm.ValidFolio: Boolean;
var
  CurrentFolio: LongInt;
begin
  CurrentFolio := StrToIntDef(edtFolioNumber.Text, FExistingFolio);
  if (CurrentFolio <= FirstAddrD) or (CurrentFolio > -1) then
  begin
    SetFolio(FExistingFolio + 1);
    if edtFolioNumber.CanFocus then
      edtFolioNumber.SetFocus;
    lblError.Caption := 'Invalid folio number';
    Result := False;
  end
  else
  begin
    FFolio := CurrentFolio;
    Result := True;
  end;
end;

// -----------------------------------------------------------------------------

end.

unit SetDecF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Mask, bkgroup, ExtCtrls;

type
  TSetDecFrm = class(TForm)
    TitlePnl: TPanel;
    Label1: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    SBSPanel4: TSBSBackGroup;
    Label2: TLabel;
    StartBtn: TButton;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    lblQtyDecPlaces: TLabel;
    edtQtyDecPlaces: TMaskEdit;
    spinQtyDecPlaces: TUpDown;
    OkCP1Btn: TButton;
    ClsCP1Btn: TButton;
    procedure FormCreate(Sender: TObject);
  private
    function GetDecPlaces: Integer;
    { Private declarations }
  public
    { Public declarations }
    property DecPlaces: Integer read GetDecPlaces;
  end;

var
  SetDecFrm: TSetDecFrm;

function Get_DecPlaces(var DecPlaces: Integer): Boolean;
  
implementation

{$R *.dfm}

uses
  ProgU,
  VarConst;

function Get_DecPlaces(var DecPlaces: Integer): Boolean;
var
  DecPlacesFrm: TSetDecFrm;
begin
  Result := False;
  DecPlacesFrm := TSetDecFrm.Create(Application.MainForm);

  try
    DecPlacesFrm.ShowModal;

    Result := (DecPlacesFrm.ModalResult = mrOK);

    If (Result) then
      DecPlaces := DecPlacesFrm.DecPlaces
    else
      Write_FixMsgFmt('Special Function 115 has been aborted.', 4);

  finally
    DecPlacesFrm.Free;
  end;
end;

procedure TSetDecFrm.FormCreate(Sender: TObject);
begin
  ClientHeight := 209;
  ClientWidth  := 412;
  spinQtyDecPlaces.Position := Syss.NoQtyDec;
end;

function TSetDecFrm.GetDecPlaces: Integer;
begin
  Result := spinQtyDecPlaces.Position;
end;

end.

unit DrillDownForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Enterprise_TLB, ComObj, ActiveX, MemMap;

type
  TfrmDrillDown = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    FDrillDown: IDrillDown;
  public
    procedure DrillDown(DrillDownCmd: WideString);
    destructor Destroy; override;
  end;

procedure DoDrillDown(DrillDownCmd: WideString; CompanyCode: ShortString; UserId: ShortString);


implementation

{$R *.dfm}

var
  frmDrillDown: TfrmDrillDown;

procedure DoDrillDown(DrillDownCmd: WideString; CompanyCode: ShortString; UserId: ShortString);
begin
  if not assigned(frmDrillDown) then
    frmDrillDown := TfrmDrillDown.Create(application);

  GlobalOLEMap.AddLogin(CompanyCode, UserId);
  
  with frmDrillDown do begin
    DrillDown(DrillDownCmd);
  end;
end;

destructor TfrmDrillDown.Destroy;
begin
  FDrillDown   := nil;
//  CoUninitialize;  prevents Outlook from closing so don't
  inherited;
end;

procedure TfrmDrillDown.DrillDown(DrillDownCmd: WideString);
begin
  FDrillDown.DrillDown(DrillDownCmd);
end;

procedure TfrmDrillDown.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action       := caFree;
  frmDrillDown := nil;
end;

procedure TfrmDrillDown.FormCreate(Sender: TObject);
begin
//  CoInitialize(nil); prevents Outlook from closing so don't
  FDrillDown := CreateOLEObject('Enterprise.DrillDown') as IDrillDown;

  if not assigned(FDrillDown) then
    ShowMessage('KPIDrill: no DrillDown object');
end;

initialization
  frmDrillDown := nil;

end.

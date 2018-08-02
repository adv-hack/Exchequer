unit PrintersSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uMultiList, EPrntDef, APIUtil;

type
  TPrinterInfo = Class
    ArrayPos : Byte;
    Details : Printer_DefType;
  end;

  TFrmPrintersSetup = class(TForm)
    mlPrinters: TMultiList;
    btnEdit: TButton;
    btnDelete: TButton;
    btnClose: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnEditClick(Sender: TObject);
    procedure mlPrintersRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnDeleteClick(Sender: TObject);
  private
    procedure LoadPrinterSetup;
    procedure SavePrinterSetup;
    { Private declarations }
  public
    { Public declarations }
  end;

{var
  FrmPrintersSetup: TFrmPrintersSetup;}

  procedure RunPrintersSetup;

implementation

uses PrinterCodes;

{$R *.dfm}

procedure RunPrintersSetup;
var
  FrmPrintersSetup: TFrmPrintersSetup;
begin
  FrmPrintersSetup := TFrmPrintersSetup.Create(application);
  FrmPrintersSetup.ShowModal;
  FrmPrintersSetup.Release;
end;

procedure TFrmPrintersSetup.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmPrintersSetup.FormShow(Sender: TObject);
var
  iPos : integer;
  PrinterInfo : TPrinterInfo;
begin
  // Get Printer Setup Info
  LoadPrinterSetup;

  // Fill List
  For iPos := 1 to PDefNo do
  begin
    PrinterInfo := TPrinterInfo.Create;
    PrinterInfo.ArrayPos := iPos;

    if Printer_defFile[iPos].Name = '' then
    begin
      // unused printers
      FillChar(PrinterInfo.Details, SizeOf(PrinterInfo.Details), #0);
      mlPrinters.DesignColumns[0].Items.AddObject('(unused)', PrinterInfo);
    end else
    begin
      // printers that have been setup
      PrinterInfo.Details := Printer_defFile[iPos];
      mlPrinters.DesignColumns[0].Items.AddObject(Printer_defFile[iPos].Name, PrinterInfo);
    end;
  end;{for}
  if mlPrinters.ItemsCount > 0 then mlPrinters.Selected := 0;
end;

procedure TFrmPrintersSetup.FormClose(Sender: TObject; var Action: TCloseAction);
var
  iPos : integer;
begin
  For iPos := 0 to mlPrinters.ItemsCount -1 do
  begin
    mlPrinters.DesignColumns[0].Items.Objects[iPos].Free;
  end;{for}
end;

procedure TFrmPrintersSetup.btnEditClick(Sender: TObject);
var
  FrmPrinterCodes : TFrmPrinterCodes;
begin
  FrmPrinterCodes := TFrmPrinterCodes.Create(self);
  FrmPrinterCodes.PrinterCodes
  := TPrinterInfo(mlPrinters.DesignColumns[0].Items.Objects[mlPrinters.Selected]).Details;
  if FrmPrinterCodes.ShowModal = mrOK then
  begin
//    FrmPrinterCodes.PrinterCodes.Port := 1;
    TPrinterInfo(mlPrinters.DesignColumns[0].Items.Objects[mlPrinters.Selected]).Details
    := FrmPrinterCodes.PrinterCodes;
    mlPrinters.DesignColumns[0].Items[mlPrinters.Selected]
    := FrmPrinterCodes.PrinterCodes.Name;
    Printer_defFile[TPrinterInfo(mlPrinters.DesignColumns[0].Items.Objects
    [mlPrinters.Selected]).ArrayPos] := FrmPrinterCodes.PrinterCodes;
    SavePrinterSetup;
  end;{if}
end;

procedure TFrmPrintersSetup.LoadPrinterSetup;
begin
  GetPDef;
end;

procedure TFrmPrintersSetup.SavePrinterSetup;
begin
  SavePrinterDefinitions;
end;

procedure TFrmPrintersSetup.mlPrintersRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnEditClick(btnEdit);
end;

procedure TFrmPrintersSetup.btnDeleteClick(Sender: TObject);
begin
  if MsgBox('Are you sure you want to delete this printer setup ?', mtConfirmation
  , [mbYes, mbNo], mbNo, 'Delete Printer') = mrYes then
  begin
    FillChar(TPrinterInfo(mlPrinters.DesignColumns[0].Items.Objects[mlPrinters.Selected]).Details
    , SizeOf(Printer_DefType), #0);
    mlPrinters.DesignColumns[0].Items[mlPrinters.Selected] := '(unused)';

    Printer_defFile[TPrinterInfo(mlPrinters.DesignColumns[0].Items.Objects[mlPrinters.Selected]).ArrayPos]
    := TPrinterInfo(mlPrinters.DesignColumns[0].Items.Objects[mlPrinters.Selected]).Details;

    SavePrinterSetup;
  end;
end;

end.

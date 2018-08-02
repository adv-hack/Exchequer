unit PrntDlgF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Enterprise01_TLB, ComCtrls, StdCtrls;

type
  TfrmPrintDlg = class(TForm)
    PageControl1: TPageControl;
    tabshPrinter: TTabSheet;
    tabshEmail: TTabSheet;
    tabshFax: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    lstPrinters: TComboBox;
    Label2: TLabel;
    edtCopies: TEdit;
    Label3: TLabel;
    Edit1: TEdit;
    tabshPrinterInfo: TTabSheet;
    Label4: TLabel;
    lstPIPrinters: TListBox;
    Label5: TLabel;
    lstPIBins: TListBox;
    Label6: TLabel;
    lstPIPapers: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lstPIPrintersClick(Sender: TObject);
  private
    { Private declarations }
    oToolkit  : IToolkit;
    oPrintJob : IPrintJob;

    procedure SetupForm;
  public
    { Public declarations }
  end;

var
  frmPrintDlg: TfrmPrintDlg;

implementation

{$R *.dfm}

Uses COMObj;

//-----------------------------------------------------------------------------

procedure TfrmPrintDlg.FormCreate(Sender: TObject);
Var
  Res : LongInt;
begin
  oToolkit := CreateOLEObject ('Enterprise01.Toolkit') As IToolkit;
  With oToolkit Do Begin
    // Set window caption with CTK Version info
    Caption := Application.Title + ' (' + oToolkit.Version + ')';

    Res := OpenToolkit;
    If (Res = 0) Then Begin
      // Find first Sales Invoice
      Res := Transaction.GetGreaterThanOrEqual(Transaction.BuildOurRefIndex('SIN'));
      If (Res <> 0) Then ShowMessage ('Error ' + IntToStr(Res) + ' loading SIN');

      // Create Print Job object
      oPrintJob := (Transaction As ITransaction2).Print;

      // Setup dialog
      SetupForm;
    End { If (Res = 0) }
    Else Begin
      ShowMessage ('OpenToolkit: ' + IntToStr(Res));
      Close;
    End; { If (Res <> 0) }
  End; { With oToolkit }
end;

//---------------------------------------

procedure TfrmPrintDlg.FormDestroy(Sender: TObject);
begin
  oPrintJob := NIL;
  oToolkit.CloseToolkit;
  oToolkit := NIL;
end;

//-----------------------------------------------------------------------------

procedure TfrmPrintDlg.SetupForm;
Var
  I : SmallInt;
begin
  With oPrintJob Do Begin
    // Disable additional tabs where applicable
    tabshFax.Tabvisible := False;   // Check pjEmailInfo.??Available;
    tabshEmail.Tabvisible := False;   // Check pjEmailInfo.??Available;

    // Printer -------------------------------------------
    With pjPrinterInfo Do Begin
      // Load List of Printers (NOTE: Printers Array is 1 based)
      If (Printers.Count > 0) Then Begin
        For I := 1 To Printers.Count Do
          lstPrinters.Items.Add (Printers[I]);
        lstPrinters.ItemIndex := PrinterIndex - 1;
      End; { If }
    End; { With pjPrinterInfo }


    // Fax -----------------------------------------------
    If tabshFax.Tabvisible Then Begin

    End; { If tabshFax.Tabvisible }

    // Email ---------------------------------------------
    If tabshEmail.Tabvisible Then Begin
    End; { If tabshEmail.Tabvisible }

    // Printer Info
    With pjPrinterInfo Do Begin
      // Load List of Printers (NOTE: Printers Array is 1 based)
      If (Printers.Count > 0) Then Begin
        For I := 1 To Printers.Count Do
          lstPIPrinters.Items.Add (Printers[I]);
        lstPIPrinters.ItemIndex := PrinterIndex - 1;
        lstPIPrintersClick(Self);
      End; { If }
    End; { With pjPrinterInfo }
  End; { oPrintJob }
end;

//-----------------------------------------------------------------------------

procedure TfrmPrintDlg.lstPIPrintersClick(Sender: TObject);
Var
  I : SmallInt;
begin
  // Typecast the Transaction object to access the descendant
  With oPrintJob.pjPrinterInfo Do Begin
    // Set Printer Index
    PrinterIndex := lstPIPrinters.ItemIndex + 1;     // NOTE: Printers are 1 based

    // Load List of Bins (NOTE: Printers Array is 1 based)
    lstPIBins.Clear;
    If (Bins.Count > 0) Then Begin
      For I := 1 To Bins.Count Do
        lstPIBins.Items.Add (Bins[I]);
    End; { If }

    // Load Papers
    lstPIPapers.Clear;
    If (Papers.Count > 0) Then Begin
      For I := 1 To Papers.Count Do
        lstPIPapers.Items.Add (Papers[I]);
    End; { If }
  End; { With }
end;

end.

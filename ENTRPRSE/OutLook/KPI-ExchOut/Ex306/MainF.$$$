unit MainF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComObj, Enterprise01_TLB, StdCtrls;

type
  TfrmOurRef = class(TForm)
    edtOurRef: TEdit;
    btnPrint: TButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    oToolkit  : IToolkit;
  end;

var
  frmOurRef: TfrmOurRef;

implementation

{$R *.DFM}

Uses PrntDlgF;

procedure TfrmOurRef.FormCreate(Sender: TObject);
Var
  Res  : LongInt;
begin
  // Create COM Toolkit
  oToolkit := CreateOLEObject ('Enterprise01.Toolkit') As IToolkit;

  If Assigned (oToolkit) Then
    With oToolkit Do Begin
      // Open Toolkit
      Res := OpenToolkit;

      If (Res <> 0) Then Begin
        // Disable Print Button and show error message
        btnPrint.Enabled := False;
        ShowMessage ('The following error occured opening the Toolkit:- ' +
                     #13#13 + QuotedStr(LastErrorString));
      End; // If (Res& <> 0)  
    End // With oToolkit
  Else
    ShowMessage ('Unable to create COM Toolkit');
end;

procedure TfrmOurRef.FormDestroy(Sender: TObject);
begin
  // Close Company Dataset and remove reference to COM Toolkit
  If Assigned(oToolkit) Then oToolkit.CloseToolkit;
  oToolkit := NIL;
end;

procedure TfrmOurRef.btnPrintClick(Sender: TObject);
Var
  oPrintJob : IPrintJob;
  Res       : LongInt;
begin
  With oToolkit, Transaction Do Begin
    // Find specified Transaction
    Index := thIdxOurRef;
    Res := GetEqual(BuildOurRefIndex(edtOurRef.Text));
    If (Res = 0) Then Begin
      // Got Transaction - Setup reference to descendant object and
      // Use the print method to print it directly to printer using
      // the default settings
      oPrintJob := (Transaction As ITransaction2).Print(thpmDefault);
      Try
        // Import the default settings for this Print Job
        oPrintJob.ImportDefaults;

        // Create the Print To Dialog and
        With TfrmPrintDlg.Create(Self) Do
          Try
            // Pass the PrintJob object into the dialog
            SetPrinterObject (oPrintJob, 'Print ' + thOurRef);

            // Display the Print To dialog
            ShowModal;
          Finally
            Free;
          End; // Try
      Finally
        oPrintJob := NIL;
      End // Try
    End // If (Res = 0) 
    Else
      ShowMessage ('Error ' + IntToStr(Res) + ' was returned attempting to find the specified transaction');
  End; // With oToolkit.Transaction
end;

end.

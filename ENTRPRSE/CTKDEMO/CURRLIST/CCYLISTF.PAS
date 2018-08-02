unit CcyListF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ComObj, Enterprise01_TLB;

type
  TfrmCurrencyList = class(TForm)
    lvCurrency: TListView;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    oToolkit    : IToolkit;

    procedure LoadList;
  public
    { Public declarations }
  end;

var
  frmCurrencyList: TfrmCurrencyList;

implementation

{$R *.DFM}

procedure TfrmCurrencyList.FormCreate(Sender: TObject);
Var
  FuncRes : LongInt;
begin
  // Create as OLE Object
  oToolkit := CreateOleObject ('Enterprise01.Toolkit') As IToolkit;
  If Assigned(oToolkit) Then Begin
    //oToolkit.Configuration.DataDirectory := 'g:\431dec13\';
    FuncRes := oToolkit.OpenToolkit;

    If (FuncRes = 0) Then
      LoadList
    Else
      ShowMessage ('OpenToolkit: ' + IntToStr(FuncRes));
  End; { If Assigned(oToolkit) }
end;

{----------------------------------------}

// Load List view with the Currency Table
procedure TfrmCurrencyList.LoadList;
Var
  FuncRes : LongInt;
  I       : SmallInt;
begin { LoadList }
  If Assigned(oToolkit) Then
    With oToolkit.SystemSetup, lvCurrency Do Begin
      // Clear out any previous data
      Items.Clear;

      If (ssMaxCurrency > 0) Then
        // Euro/Global - Load listview with Currency information
        For I := 0 To ssMaxCurrency Do
          With Items.Add, ssCurrency[I] Do Begin
            Caption := IntToStr(I);
            SubItems.Add (scDesc);
            SubItems.Add (scSymbol);
            SubItems.Add (scPrintSymb);
            SubItems.Add (Format('%0.6n', [scDailyRate]));
            SubItems.Add (Format('%0.6n', [scCompanyRate]));
            If scTriInvert Then SubItems.Add ('Y') Else SubItems.Add ('N');
            If scTriFloating Then SubItems.Add ('Y') Else SubItems.Add ('N');
            SubItems.Add (IntToStr(scTriEuroCcy));
            SubItems.Add (Format('%0.6n', [scTriRate]));
          End { With Items.Add }
      Else
        // Professional
        MessageDlg ('The current Company Data is a professional system and does not support multiple currencies', mtInformation, [mbOk], 0);
    End; { With oToolkit.SystemSetup, lvCurrency }
end; { LoadList }

end.

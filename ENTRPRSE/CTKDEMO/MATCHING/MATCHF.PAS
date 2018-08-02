unit MatchF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComObj, Enterprise01_TLB;

type
  TfrmMatchDemo = class(TForm)
    lstSIN: TListBox;
    Label1: TLabel;
    btnLoad: TButton;
    lstSRC: TListBox;
    Label2: TLabel;
    btnMatch: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLoadClick(Sender: TObject);
    procedure btnMatchClick(Sender: TObject);
  private
    { Private declarations }
    oToolkit    : IToolkit;
  public
    { Public declarations }
  end;

var
  frmMatchDemo: TfrmMatchDemo;

implementation

{$R *.DFM}

procedure TfrmMatchDemo.FormCreate(Sender: TObject);
Var
  FuncRes : LongInt;
begin
  // Create as OLE Object
  oToolkit := CreateOleObject ('Enterprise01.Toolkit') As IToolkit;

  // Check it created OK
  If Assigned(oToolkit) Then Begin
    // Open Toolkit
    FuncRes := oToolkit.OpenToolkit;

    If (FuncRes <> 0) Then Begin
      // Error opening Toolkit - display error and shutdown app normally
      MessageDlg ('The following error occured opening the Toolkit:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                  mtError, [mbOk], 0);
      Application.Terminate;
    End; { If (FuncRes <> 0) }
  End; { If Assigned(oToolkit) }
end;

{-----------------------------------------}

procedure TfrmMatchDemo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Explicitly remove reference to COM Object
  oToolkit := NIL;
end;

{-----------------------------------------}

procedure TfrmMatchDemo.btnLoadClick(Sender: TObject);
Var
  NewLine  : ShortString;
  Res      : LongInt;
begin
  With oToolkit, Transaction Do Begin
    // Clear out any pre-existing items in lists
    lstSIN.Clear;
    lstSRC.Clear;

    Index := thIdxOutStanding;
    Res := GetFirst;
    While (Res = 0) Do Begin
      If (thDocType In [dtSIN, dtSRC]) And (thAmountSettled = 0.0) Then Begin
        // Outstanding SIN or SRC
        NewLine := thOurRef + '  ' +
                   Format ('(%2.2d) %12.2f', [thCurrency, thTotals[TransTotInCcy]]) + '  ' +
                   thAcCode;

        If (thDocType = dtSIN) Then
          lstSIN.Items.Add (NewLine)
        Else
          lstSRC.Items.Add (NewLine);
      End; { If (thDocType In [dtSIN, dtSRC]) And (thSettledAmount = 0.0) }

      Res := GetNext;
    End; { While (Res = 0) }
  End; { With oToolkit, Transaction }
end;

{-----------------------------------------}

procedure TfrmMatchDemo.btnMatchClick(Sender: TObject);
Var
  oSIN   : ITransaction;
  Res    : LongInt;
begin
  If (lstSin.ItemIndex > -1) And (lstSRC.ItemIndex > -1) Then
    With oToolkit, Transaction Do Begin
      // load SIN details
      Index := thIdxOurRef;
      Res := GetEqual (BuildOurRefIndex(Copy (lstSIN.Items[lstSIN.ItemIndex], 1, 9)));
      If (Res = 0) Then Begin
        // Take local copy of SIN for later reference
        oSIN := Clone;

        // load SRC details
        Res := GetEqual (BuildOurRefIndex(Copy (lstSRC.Items[lstSRC.ItemIndex], 1, 9)));
        If (Res = 0) Then Begin
          // Got SRC - match the SIN with the SRC
          With thMatching.Add Do Begin
            // Copy details in from SIN
            maDocRef := oSIN.thOurRef;
            maDocCurrency := oSIN.thCurrency;
            maDocValue := oSIN.thTotals[TransTotInCcy];

            // Copy details in from SRC
            maPayRef := thOurRef;
            maPayCurrency := thCurrency;
            maPayValue := thTotals[TransTotInCcy];

            // generate Base Equivalent of matched amount
            maBaseValue := Functions.entConvertAmount(maDocValue, maDocCurrency, 0, 0);

            Res := Save;
            If (Res = 0) Then
              ShowMessage (oSIN.thOurRef + ' and ' + thOurRef + ' have been matched')
            Else
              ShowMessage ('Error matching SIN->SRC - ' + LastErrorString);
          End; { With thMatching.Add }
        End { If (Res = 0) }
        Else
          ShowMessage ('Error loading SRC Details - ' + LastErrorString);

        // Explicitly remove reference to object
        oSIN := NIL;
      End { If (Res = 0) }
      Else
        ShowMessage ('Error loading SIN Details - ' + LastErrorString);
    End { With oToolkit, Transaction }
  Else
    ShowMessage ('A SIN and SRC both need to be selected before matching can be done');
end;

{-----------------------------------------}

end.

unit acDiscF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ComObj, ListF, Enterprise01_TLB;

type
  TfrmAccountDiscounts = class(TForm)
    lvDiscounts: TListView;
    Panel1: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnView: TButton;
    btnClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
  private
    { Private declarations }
    FDiscountsI  : IAccountDiscount;
    FToolkitI    : IToolkit;

    procedure DisplayDiscDetail (DlgMode : TDialogMode);
    procedure LoadDiscounts;
  protected
    Procedure SetObjects (Const ToolkitI : IToolkit; Const IAccountDiscount : IAccountDiscount);
  public
    { Public declarations }
  end;

Procedure DisplayDiscounts (Const SourceCaption : ShortString;
                            Const iToolkit      : IToolkit;
                            Const iDiscounts    : IAccountDiscount);

implementation

{$R *.DFM}

Uses DiscDetF;

Procedure DisplayDiscounts (Const SourceCaption : ShortString;
                            Const iToolkit      : IToolkit;
                            Const iDiscounts    : IAccountDiscount);
Begin { DisplayNotes }
  With TfrmAccountDiscounts.Create (Application.MainForm) Do
    Try
      Caption := SourceCaption;
      SetObjects (iToolkit, iDiscounts);

      ShowModal;


    Finally
      Free;
    End;
End; { DisplayNotes }

{-------------------------------------------------------------------------------------------------}

procedure TfrmAccountDiscounts.FormCreate(Sender: TObject);
begin
  FDiscountsI := NIL;
  FToolkitI := NIL;
end;

{----------------------------------------}

procedure TfrmAccountDiscounts.FormDestroy(Sender: TObject);
begin
  FDiscountsI := NIL;
  FToolkitI := NIL;
end;

{----------------------------------------}

procedure TfrmAccountDiscounts.SetObjects (Const ToolkitI : IToolkit; Const IAccountDiscount : IAccountDiscount);
begin
  FToolkitI := ToolkitI;
  FDiscountsI := IAccountDiscount;

  If Assigned(FToolkitI) And Assigned(FDiscountsI) Then
    // Load Discounts
    LoadDiscounts;
end;

{----------------------------------------}

procedure TfrmAccountDiscounts.LoadDiscounts;
Var
  Res : LongInt;
Begin { LoadDiscounts }
  With FToolkitI, FDiscountsI, lvDiscounts Do Begin
    // Clear out any pre-existing note lines
    Items.Clear;

    // Get First discount
    Res := GetFirst;
    While (Res = 0) Do Begin
      With lvDiscounts.Items.Add Do Begin
        // NOTE: To make editing easier we are going to store the address
        // of each record in the list view.  This gets around the problem
        // where you can have multiple records for a stock code and
        // currency, giving you no unique key value.
        SavePosition;
        Data := Pointer(FDiscountsI.Position);

        Caption := Trim(adStockCode);
        SubItems.Add (IntToStr(adCurrency));

        Case adType Of
          DiscSpecialPrice : Begin
                               SubItems.Add ('Price');
                               SubItems.Add (Format ('%8.2n', [adPrice]));
                             End;
          DiscBandPrice    : Begin
                               SubItems.Add ('Band');
                               SubItems.Add ('');
                               SubItems.Add (adPriceBand);
                               If (adDiscPercent <> 0) Then
                                 SubItems.Add (Format ('%8.2n%s', [adDiscPercent, '%']))
                               Else Begin
                                 SubItems.Add ('');
                                 SubItems.Add (Format ('%8.2n', [adDiscValue]));
                               End; { Else }
                             End;
          DiscMargin,
          DiscMarkup       : Begin
                               If (adType = DiscMarkup) Then
                                 SubItems.Add ('Mark Up')
                               Else
                                 SubItems.Add ('Margin');

                               SubItems.Add ('');
                               SubItems.Add ('');
                               SubItems.Add ('');
                               SubItems.Add ('');
                               SubItems.Add (Format ('%8.2n%s', [adMarkupMarginPercent, '%']));
                             End;
          DiscQtyBreak     : Begin
                               SubItems.Add ('QtyBrk');
                             End;
        End; { Case adType  }
      End; { With }

      Res := GetNext;
    End; { While (Res = 0) }
  End; { With FToolkitI, FDiscountsI, lvDiscounts }
End; { LoadDiscounts }

{----------------------------------------}

procedure TfrmAccountDiscounts.btnCloseClick(Sender: TObject);
begin
  Close;
end;

{----------------------------------------}

procedure TfrmAccountDiscounts.DisplayDiscDetail (DlgMode : TDialogMode);
var
  FuncRes : LongInt;
begin
  With lvDiscounts, oToolkit, FDiscountsI Do
    // Check 1 item is selected for editing
    If (DlgMode = mdAdd) Or (SelCount = 1) Then Begin
      If (DlgMode <> mdAdd) Then Begin
        // Retrieve selected Discount Details for View/Edit using the position
        // previously stored in the list view item
        FDiscountsI.Position := LongInt(Selected.Data);
        FuncRes := RestorePosition;

        //FuncRes := GetEqual(BuildIndex(Selected.Caption, StrToInt(Selected.SubItems[0])));
        If (FuncRes <> 0) Then
          MessageDlg ('The following error occured getting the Discount Details:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                      mtError, [mbOk], 0);
      End { If (DlgMode <> mdAdd) }
      Else
        // Adding - no need to do anything
        FuncRes := 0;

      If (FuncRes = 0) Then Begin
        // AOK - create Location Detail window
        With TfrmAcDiscDetlF.Create(Self) Do
          Try
            // Position form nicely
            Left := Self.Left + 35;
            Top := Self.Top + 35;

            // Set window mode
            Mode := DlgMode;

            // Set Transaction Interface on detail window
            Case DlgMode Of
              mdAdd  : DiscDetail := FDiscountsI.Add;
              mdEdit : DiscDetail := FDiscountsI.Update;
              mdView : DiscDetail := FDiscountsI.Clone;
            End; { Case }

            // Check we got a valid interface
            If Assigned (DiscDetail) Then Begin
              // Display dialog
              ShowModal;

              // Reload list if changes were made
              If NeedRefresh Then LoadDiscounts;
            End { If Assigned (DiscDetail) }
            Else
              ShowMessage ('The Discount Detail is not available - someone else may be editing it');
          Finally
            Free;
          End;
      End; { If (FuncRes = 0) }
    End; { If (DlgMode = mdAdd) Or (SelCount = 1) }
end;

{----------------------------------------}

procedure TfrmAccountDiscounts.btnAddClick(Sender: TObject);
begin
  DisplayDiscDetail (mdAdd);
end;

{----------------------------------------}

procedure TfrmAccountDiscounts.btnEditClick(Sender: TObject);
begin
  DisplayDiscDetail (mdEdit);
end;

{----------------------------------------}

procedure TfrmAccountDiscounts.btnViewClick(Sender: TObject);
begin
  DisplayDiscDetail (mdView);
end;

{----------------------------------------}

end.

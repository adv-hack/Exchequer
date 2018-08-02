
unit TestF;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, COMObj, Enterprise01_Tlb, ComCtrls, Buttons, Math, ExtCtrls;

// Import Btrieve Constants
{$I ExDllBt.Inc}

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    lstCustomer: TListBox;
    btnGetFirstCust: TButton;
    btnGetNextCust: TButton;
    lstCustomerIdx: TComboBox;
    btnGetPreviousCust: TButton;
    btnGetLastCust: TButton;
    StatusBar1: TStatusBar;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtEntDir: TEdit;
    edtDataDir: TEdit;
    Label2: TLabel;
    btnOpenToolkit: TButton;
    GroupBox2: TGroupBox;
    btnCloseToolkit: TButton;
    GroupBox3: TGroupBox;
    btnGetTKStatus: TButton;
    lblToolkitStatus: TLabel;
    GroupBox4: TGroupBox;
    Label3: TLabel;
    edtSearchKey: TEdit;
    lstSearchOp: TComboBox;
    btnSearchCommand: TButton;
    Label4: TLabel;
    tabshTransaction: TTabSheet;
    lstTrans: TListBox;
    btnGetFirstTH: TButton;
    btnGetNextTH: TButton;
    lstTransIdx: TComboBox;
    btnGetPrevTH: TButton;
    btnGetLastTH: TButton;
    btnStepFirstTH: TButton;
    btnStepNextTH: TButton;
    btnStepPrevTH: TButton;
    btnStepLastTH: TButton;
    GroupBox5: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    edtSearchTHKey: TEdit;
    lstSearchTHOp: TComboBox;
    btnSearchTH: TButton;
    btnBrowwseTrans: TButton;
    ts_CreateTrans: TTabSheet;
    grpTransHeader: TGroupBox;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    edtOurRef: TEdit;
    edtYourRef: TEdit;
    edtAltRef: TEdit;
    edtTransDate: TEdit;
    edtPeriodYear: TEdit;
    edtAcctCode: TEdit;
    grpTransDet: TGroupBox;
    lbl10: TLabel;
    lbl11: TLabel;
    lbl12: TLabel;
    lbl13: TLabel;
    lbl14: TLabel;
    lbl15: TLabel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    edtQty: TEdit;
    edtStock: TEdit;
    edtGL: TEdit;
    edtDep: TEdit;
    edtCC: TEdit;
    edtStkPrice: TEdit;
    edtAnalCode: TEdit;
    edtJobcode: TEdit;
    edtAmt: TEdit;
    grpTrans: TGroupBox;
    btnCreate: TButton;
    cboTrans: TComboBox;
    btnSaveTrans: TButton;
    btnCancelTrans: TButton;
    TabSheet3: TTabSheet;
    GroupBox6: TGroupBox;
    edtUserID: TEdit;
    edtPwd: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    cboAccess: TComboBox;
    btnChkLogin: TButton;
    btnChkAccess: TButton;
    Label9: TLabel;
    tabEmpl: TTabSheet;
    lst1: TListBox;
    GroupBox7: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    edtEmpCode: TEdit;
    edEmpStatus: TEdit;
    Save: TButton;
    GroupBox8: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    edtTraderCode: TEdit;
    edtTraderStatus: TEdit;
    SaveTrader: TButton;
    TraderType: TComboBox;
    Label14: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnGetFirstCustClick(Sender: TObject);
    procedure btnGetPreviousCustClick(Sender: TObject);
    procedure btnGetNextCustClick(Sender: TObject);
    procedure btnGetLastCustClick(Sender: TObject);
    procedure lstCustomerIdxClick(Sender: TObject);
    procedure lstCustomerDblClick(Sender: TObject);
    procedure btnOpenToolkitClick(Sender: TObject);
    procedure btnCloseToolkitClick(Sender: TObject);
    procedure btnGetTKStatusClick(Sender: TObject);
    procedure btnSearchCommandClick(Sender: TObject);
    procedure btnGetFirstTHClick(Sender: TObject);
    procedure btnGetPrevTHClick(Sender: TObject);
    procedure btnGetNextTHClick(Sender: TObject);
    procedure btnGetLastTHClick(Sender: TObject);
    procedure btnStepFirstTHClick(Sender: TObject);
    procedure btnStepPrevTHClick(Sender: TObject);
    procedure btnStepNextTHClick(Sender: TObject);
    procedure btnStepLastTHClick(Sender: TObject);
    procedure btnSearchTHClick(Sender: TObject);
    procedure lstTransIdxClick(Sender: TObject);
    procedure btnBrowwseTransClick(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure btnSaveTransClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtStockExit(Sender: TObject);
    procedure edtQtyExit(Sender: TObject);
    procedure edtAcctCodeExit(Sender: TObject);
    procedure btnCancelTransClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnChkLoginClick(Sender: TObject);
    procedure btnChkAccessClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure SaveTraderClick(Sender: TObject);

  private
    { Private declarations }

    procedure BtrOp(Const BtrOp : SmallInt; Const SearchKey : String = '');
    procedure TransBtrOp(Const BtrOp : SmallInt; Const SearchKey : String = '');

    procedure FillTransactionList;
    procedure FillAccessSettingsList;

    procedure InitCommonHeader(const TransO : ITransaction);
    procedure DisplayTransInfo(const TransO : ITransaction);
    procedure InitTransDetails;
////////////////////
    function CheckStockExists(stkCode: string): boolean;

    procedure AddSPOPTrans;
    procedure AddPaymentTrans;

    procedure AddNOMTrans;
    procedure AddADJTrans;
    procedure AddWORTrans;

    function GetTransType: TDocTypes;
    procedure ClearEditFields;
  public
    { Public declarations }
  end;

var
  Form1      : TForm1;
  oToolkit   : IToolkit;  // Global so not optimised by compiler
  FTransO    : ITransaction;
  FStock     : IStock;
  FTransDesc : string;
  FTransType : TDocTypes;
  FIsTransSaved : boolean;

  Emp: IEmployee;
  Emp1: IEmployee8;

  Cust: IAccount;
  Cust1: IAccount12;

implementation

{$R *.DFM}

Uses SecCodes;

procedure TForm1.FormCreate(Sender: TObject);
begin

  // Create as OLE Object
  oToolkit := CreateOleObject ('Enterprise01.Toolkit') As IToolkit;

  With oToolkit.Configuration Do Begin
    // Extract default pathing info
    edtEntDir.Text := EnterpriseDirectory;
    edtDataDir.Text := DataDirectory;
  End; { With oToolkit.Configuration }

  // Add version into form footer
  StatusBar1.SimpleText := 'Enterprise COM Toolkit ' +  oToolkit.Version;

  // Select default indexes
  lstCustomerIdx.ItemIndex := 0;
  lstCustomerIdxClick(Sender);

  // fill the transaction combo list
  FillTransactionList;
  FIsTransSaved := false;

  //fill the Acces Setting Combo list
  FillAccessSettingsList;
  self.Caption := 'COMTK Testing App';

end;

procedure TForm1.BtrOp(Const BtrOp : SmallInt; Const SearchKey : String = '');
Var
  Res : LongInt;
begin
  If Assigned(oToolkit) And (oToolkit.Status = tkOpen) Then
    With oToolkit.Customer Do Begin
      Case BtrOp Of
        // Btrieve Index Navigation
        B_GetFirst  : Res := GetFirst;
        B_GetPrev   : Res := GetPrevious;
        B_GetNext   : Res := GetNext;
        B_GetLast   : Res := GetLast;

        // Btrieve File Navigation
        {B_StepFirst : Res := StepFirst;
        B_StepPrev  : Res := StepPrevious;
        B_StepNext  : Res := StepNext;
        B_StepLast  : Res := StepLast;}

        // Btrieve Index Searching
        B_GetLess   : Res := GetLessThan(SearchKey);
        B_GetLessEq : Res := GetLessThanOrEqual(SearchKey);
        B_GetEq     : Res := GetEqual(SearchKey);
        B_GetGretr  : Res := GetGreaterThan(SearchKey);
        B_GetGEq    : Res := GetGreaterThanOrEqual(SearchKey);
      Else
        Res := -1;
      End; { case }

      If (Res = 0) Then Begin
        lstCustomer.Items.Add (acCode + ' - ' + acCompany);
        lstCustomer.ItemIndex := Pred(lstCustomer.Items.Count);
      End { If (Res = 0) }
      Else
        ShowMessage ('Status ' + IntToStr(Res));
    End { With }
  Else
    ShowMessage ('The Toolkit must be opened before use!');
end;

procedure TForm1.TransBtrOp(Const BtrOp : SmallInt; Const SearchKey : String = '');
Var
  Res : LongInt;

  Function UpdMemStat : ShortString;
  var
    MemStat : MemoryStatus;
  Begin
    MemStat.dwLength := SizeOf(MemStat);
    GlobalMemoryStatus(MemStat);
    Result := IntToStr((MemStat.dwAvailPhys + MemStat.dwAvailPageFile) div 1024) + '/' +
              IntToStr(MemStat.dwMemoryLoad) + '%';
  End;

begin
  If Assigned(oToolkit) And (oToolkit.Status = tkOpen) Then
    With oToolkit.Transaction Do Begin
      Case BtrOp Of
        // Btrieve Index Navigation
        B_GetFirst  : Res := GetFirst;
        B_GetPrev   : Res := GetPrevious;
        B_GetNext   : Res := GetNext;
        B_GetLast   : Res := GetLast;

        // Btrieve File Navigation
        B_StepFirst : Res := StepFirst;
        B_StepPrev  : Res := StepPrevious;
        B_StepNext  : Res := StepNext;
        B_StepLast  : Res := StepLast;

        // Btrieve Index Searching
        B_GetLess   : Res := GetLessThan(SearchKey);
        B_GetLessEq : Res := GetLessThanOrEqual(SearchKey);
        B_GetEq     : Res := GetEqual(SearchKey);
        B_GetGretr  : Res := GetGreaterThan(SearchKey);
        B_GetGEq    : Res := GetGreaterThanOrEqual(SearchKey);
      Else
        Res := -1;
      End; { case }

      If (Res = 0) Then Begin
        lstTrans.Items.Add (thOurRef + ' - ' + thAcCode + ' - ' + IntToStr(thLines.thLineCount) + ' lines (' + UpdMeMStat + ')');
        lstTrans.ItemIndex := Pred(lstTrans.Items.Count);
      End { If (Res = 0) }
      Else
        ShowMessage ('Status ' + IntToStr(Res));
    End { With }
  Else
    ShowMessage ('The Toolkit must be opened before use!');
end;

procedure TForm1.btnGetFirstCustClick(Sender: TObject);
begin
  BtrOp(B_GetFirst);
end;

procedure TForm1.btnGetPreviousCustClick(Sender: TObject);
begin
  BtrOp(B_GetPrev);
end;

procedure TForm1.btnGetNextCustClick(Sender: TObject);
begin
  BtrOp(B_GetNext);
end;

procedure TForm1.btnGetLastCustClick(Sender: TObject);
begin
  BtrOp(B_GetLast);
end;

procedure TForm1.lstCustomerIdxClick(Sender: TObject);
begin
  If Assigned(oToolkit) and (oToolkit.Status = tkOpen) Then
    If Assigned(oToolkit.Customer) Then
      oToolkit.Customer.Index := lstCustomerIdx.ItemIndex;
end;

procedure TForm1.lstCustomerDblClick(Sender: TObject);
begin
  lstCustomer.Clear;
end;

procedure TForm1.btnOpenToolkitClick(Sender: TObject);
Var
  Res : LongInt;
begin
  If Assigned(oToolkit) Then
    With oToolkit, Configuration Do Begin
      If (Trim(edtEntDir.Text) <> '') Then EnterpriseDirectory := edtEntDir.Text;
      DataDirectory := edtDataDir.Text;
      Res := OpenToolkit;
      If (Res <> 0) Then
        ShowMessage ('OpenToolkit: ' + IntToStr(Res));
    End; { With oToolkit }
end;

procedure TForm1.btnCloseToolkitClick(Sender: TObject);
Var
  Res : LongInt;
begin
  If Assigned(oToolkit) Then
    With oToolkit Do Begin
      Res := oToolkit.CloseToolkit;
      If (Res <> 0) Then
        ShowMessage ('CloseToolkit: ' + IntToStr(Res));
    End; { With oToolkit }
end;

procedure TForm1.btnGetTKStatusClick(Sender: TObject);
begin
  lblToolkitStatus.Caption := 'Status: ';

  If Assigned(oToolkit) Then
    Case oToolkit.Status Of
      tkClosed : lblToolkitStatus.Caption := lblToolkitStatus.Caption + 'Closed';
      tkOpen   : lblToolkitStatus.Caption := lblToolkitStatus.Caption + 'Open';
    Else
      lblToolkitStatus.Caption := lblToolkitStatus.Caption + 'Unknown';
    End { Case oToolkit.Status }
  Else
    lblToolkitStatus.Caption := 'Toolkit Not Available';
end;

procedure TForm1.btnSearchCommandClick(Sender: TObject);
begin
  //edtSearchKey

  If Assigned(oToolkit) And (oToolkit.Status = tkOpen) Then
    With oToolkit.Customer Do Begin
      Case lstSearchOp.ItemIndex Of
        { Get Less }
        0 : BtrOp(B_GetLess, edtSearchKey.Text);
        { Get Less Than or Equal }
        1 : BtrOp(B_GetLessEq, edtSearchKey.Text);
        { Get Equal }
        2 : BtrOp(B_GetEq, edtSearchKey.Text);
        { Get Greater Than or Equal }
        3 : BtrOp(B_GetGEq, edtSearchKey.Text);
        { Get Greater }
        4 : BtrOp(B_GetGretr, edtSearchKey.Text);
      End; { Case lstSearchOp.ItemIndex }

      edtSearchKey.Text := KeyString;
    End; { With }
end;

procedure TForm1.btnGetFirstTHClick(Sender: TObject);
begin
  TransBtrOp (B_GetFirst);
end;

procedure TForm1.btnGetPrevTHClick(Sender: TObject);
begin
  TransBtrOp (B_GetPrev);
end;

procedure TForm1.btnGetNextTHClick(Sender: TObject);
begin
  TransBtrOp (B_GetNext);
end;

procedure TForm1.btnGetLastTHClick(Sender: TObject);
begin
  TransBtrOp (B_GetLast);
end;

procedure TForm1.btnStepFirstTHClick(Sender: TObject);
begin
  TransBtrOp (B_StepFirst);
end;

procedure TForm1.btnStepPrevTHClick(Sender: TObject);
begin
  TransBtrOp (B_StepPrev);
end;

procedure TForm1.btnStepNextTHClick(Sender: TObject);
begin
  TransBtrOp (B_StepNext);
end;

procedure TForm1.btnStepLastTHClick(Sender: TObject);
begin
  TransBtrOp (B_StepLast);
end;

procedure TForm1.btnSearchTHClick(Sender: TObject);
begin
  If Assigned(oToolkit) And (oToolkit.Status = tkOpen) Then Begin
    Case lstSearchTHOp.ItemIndex Of
      { Get Less }
      0 : TransBtrOp (B_GetLess, edtSearchTHKey.Text);
      { Get Less Than or Equal }
      1 : TransBtrOp (B_GetLessEq, edtSearchTHKey.Text);
      { Get Equal }
      2 : TransBtrOp (B_GetEq, edtSearchTHKey.Text);
      { Get Greater Than or Equal }
      3 : TransBtrOp (B_GetGEq, edtSearchTHKey.Text);
      { Get Greater }
      4 : TransBtrOp (B_GetGretr, edtSearchTHKey.Text);
    End; { Case lstSearchOp.ItemIndex }

    edtSearchTHKey.Text := oToolkit.Transaction.KeyString;
  End; { If Assigned(oToolkit) And (oToolkit.Status = tkOpen) }
end;

procedure TForm1.lstTransIdxClick(Sender: TObject);
begin
  If Assigned(oToolkit) And Assigned(oToolkit.Transaction) Then
    oToolkit.Transaction.Index := lstTransIdx.ItemIndex;
end;

procedure TForm1.btnBrowwseTransClick(Sender: TObject);
begin
  If Assigned(oToolkit) And Assigned(oToolkit.Transaction) Then
    oToolkit.Functions.entBrowseObject (oToolkit, True);
end;


procedure TForm1.FillTransactionList();
var
  aList: TStrings;
begin
  aList := TStringList.create;

  aList.Add('Sales Invoice = [SIN]');
  aList.Add('Purchase Invoice = [PIN]');
  aList.Add('Sales Order = [SOR]');
  aList.Add('Purchase Order = [POR]');
  aList.Add('Sales Receipt = [SRC]');
  aList.Add('Purchase Payment = [PPY]');
  aList.Add('Nominal Transfer = [NOM]');
  aList.Add('Stock Adjustment = [ADJ]');
  aList.Add('Works Order = [WOR]');

  cboTrans.Items.AddStrings(aList);
  cboTrans.ItemIndex := 0;

  aList.Free;
end;

procedure TForm1.btnCreateClick(Sender: TObject);
begin
  If Assigned(oToolkit) And (oToolkit.Status = tkOpen) Then
  Begin
    ClearEditFields;
    edtYourRef.Text := 'COMTK';
    grpTransHeader.Enabled := true;

    // determine the transaction description and transaction type
    FTransDesc := trim(cboTrans.Items.Names[cboTrans.ItemIndex]);
    FTransType := GetTransType();

    // Create an Add Transaction object for the SPOP Transaction
    FTransO := oToolkit.Transaction.Add(FTransType);
    InitCommonHeader(FTransO);

    FTransO.ImportDefaults;
    DisplayTransInfo(FTransO);

    FIsTransSaved := false;
    btnCreate.Enabled := false;

    if edtAcctCode.CanFocus then edtAcctCode.SetFocus;
    edtAcctCodeExit(edtAcctCode);
  end
  else
    ShowMessage ('The Toolkit must be opened before use!');;

end;

//-------------------------------------------------------------------------

procedure TForm1.AddSPOPTrans();
var
  Res, i : SmallInt;

begin

  With FTransO Do Begin
    // Copy in the standard header fields for this exercise
    InitCommonHeader(FTransO);

    // re-assign these 2 fields as it may be changed
    thYourRef := edtYourRef.Text;
    thAcCode := edtAcctCode.Text;

    // delete all lines to make sure each time we have fresh trans lines
    if (thLines.thLineCount>0) then
    begin
       for i := 1 to thlines.thLineCount do
         thLines.Delete(i);
    end;

    With thLines.Add Do Begin

      // Stock Item
      tlStockCode := trim(edtStock.Text); //'STK-1';

      //tlDescr := FTransDesc;

      If (thDocType In [dtPOR, dtPIN]) then
        // Purchase Order/Invoice - Set optional unit uplift for delivery charges, etc...
        tlCost := StrToFloat(edtStkPrice.Text);      // Total Uplift = 12 x 0.15 = 1.80

      // Bring in defaults:- Descr, Location, GL, CC, Dept, Cost, VAT, etc...
      ImportDefaults;

      // Qty
      tlQty := StrToInt(edtQty.text);

      tlNetValue := StrToFloat(edtAmt.Text);
      tlGLCode :=  StrToInt(edtGL.text);

      // Cost Center, Department
      tlCostCentre := trim(edtCC.Text);
      tlDepartment := trim(edtDep.Text);

      // Job Code, Analysis Code
      tlJobCode := trim(edtJobcode.Text);
      tlAnalysisCode := trim(edtAnalCode.Text);

      // Save Line into Transaction
      Save;
    End; // With thLines.Add

    // Save the Transaction - True = auto calculate totals
    Res := Save(True);

    If (Res = 0) Then
    begin
      // Transaction Saved - Update form fields
      DisplayTransInfo(FTransO);
      FIsTransSaved := true;
      ShowMessage('The transaction is saved successfully');
    end
    else
      // Error
      ShowMessage('The following error occurred saving the ' + FTransDesc + ':-' +
                  #13#13 + QuotedStr(oToolkit.LastErrorString));
  End; // With TransO

end;


procedure TForm1.InitCommonHeader(const TransO: ITransaction);
begin
  With TransO Do Begin
    // Set the YourRef to that specified on the form
    thYourRef := edtYourRef.Text;

    // Set the AltRef to distinguish between transactions
    thLongYourRef := 'COMTK ' + FormatDateTime('HH:MM.SS', Time) + ' ' + FormatDateTime('DD/MM', Date);

    // User Name
    thOperator := 'EXTERN';

    // Customer/Supplier Account Code
    If (FTransType In [dtPOR, dtPIN, dtPPY]) then
      // Supplier Code for Purchase Transactions
      thAcCode :=  'MISC01'
    Else
      // Customer Code for Sales Transactions
      thAcCode :=  'CASH01';

  End; { With TransO }

end;

procedure TForm1.DisplayTransInfo(const TransO: ITransaction);

begin
  With TransO Do Begin
    edtOurRef.Text := thOurRef;
    edtYourRef.Text := thYourRef;
    edtAltRef.Text := thLongYourRef;

    edtAcctCode.Text := thAcCode;
    edtTransDate.Text := oToolkit.Functions.entFormatDate(thTransDate, 'DD/MM/YYYY');
    edtPeriodYear.Text := oToolkit.Functions.entFormatPeriodYear(thPeriod, thYear);

  End; // With TransO

end;

procedure TForm1.AddNomTrans;
var
  Res, i    : SmallInt;
begin

  With FTransO Do Begin
    // Copy in the standard header fields for this exercise
    InitCommonHeader(FTransO);

    // re-assign these 2 fields as it may be changed
    thYourRef := edtYourRef.Text;
    thAcCode := edtAcctCode.Text;

    // delete all lines to make sure each time we have fresh trans lines
    if (thLines.thLineCount>0) then
    begin
       for i := 1 to thlines.thLineCount do
         thLines.Delete(i);
    end;


    // Line 1 - Debit Line
    With thLines.Add Do Begin
      // Description
      tlDescr := 'Debit';

      // GL Code
      tlGLCode := StrToInt(edtGL.Text);    //11010;

      // NZ Dollars - default rate := 2.9
      tlCurrency := 1;

      // Amount - Debit := +ve, Credit := -ve
      tlNetValue := StrToFloat(edtAmt.Text);      //650;       // = GBP 224.14 @ 2.9

      // Cost Center, Department
      tlCostCentre := trim(edtCC.Text); // 'AAA';
      tlDepartment := trim(edtDep.Text); // 'AAA';

      // Job Code, Analysis Code
      tlJobCode := trim(edtJobcode.Text);
      tlAnalysisCode := trim(edtAnalCode.Text);

      // Save Line into Transaction
      Save;
    End; // With thLines.Add

    // Line 2 - Credit Line
    With thLines.Add Do Begin
      // Description
      tlDescr := 'Credit';

      // GL Code
      tlGLCode := 34010;

      // Aus Dollars - default rate - 2.5
      tlCurrency := 2;

      // Amount - Debit := +ve, Credit := -ve
      tlNetValue := -(StrToFloat(edtAmt.Text) * 1.42); //-560.35;   // = GBP 224.14 @ 2.5

      // Miscellaneous
      tlCostCentre := trim(edtCC.Text); // 'AAA';
      tlDepartment := trim(edtDep.Text); // 'AAA';

      // Job Code, Analysis Code
      tlJobCode := trim(edtJobcode.Text);
      tlAnalysisCode := trim(edtAnalCode.Text);

      // Save Line into Transaction
      Save;
    End; // With thLines.Add

    // Save the Transaction - True = auto calculate totals
    Res := Save(True);
    If (Res = 0) Then
    begin
      // Transaction Saved - Update form fields
      DisplayTransInfo(FTransO);
      FIsTransSaved := true;
      ShowMessage('The transaction is saved successfully');
    end
    else
      // Error
      ShowMessage('The following error occurred saving the Nominal Transfer:-' +
                  #13#13 + QuotedStr(oToolkit.LastErrorString));
  End; // With TransO


end;

procedure TForm1.AddAdjTrans;
var
  Res, i    : SmallInt;
begin

  With FTransO Do Begin

    // Copy in the standard header fields for this exercise
    InitCommonHeader(FTransO);

    // re-assign these 2 fields as it may be changed
    thYourRef := edtYourRef.Text;
    thAcCode := edtAcctCode.Text;

    // delete all lines to make sure each time we have fresh trans lines
    if (thLines.thLineCount>0) then
    begin
       for i := 1 to thlines.thLineCount do
         thLines.Delete(i);
    end;


    With thLines.Add Do Begin
      // Stock Item
      tlStockCode := trim(edtStock.Text);

      // Qty
      tlQty := StrToInt(edtQty.text);

      // Bring in any ADJ defaults - Line Desc, GL Code, Cost, Loc, CC, Dept, etc...
      //ImportDefaults;
      // General Ledger Code
      tlGLCode := StrToInt(edtGL.Text);

      // Payment Value
      tlNetValue := StrToInt(edtAmt.Text);

      // CostCenter, Department
      tlCostCentre := trim(edtCC.Text);
      tlDepartment := trim(edtDep.Text);

      // Job Code, Analysis Code
      tlJobCode := trim(edtJobcode.Text);
      tlAnalysisCode := trim(edtAnalCode.Text);

      // Save Line into Transaction
      Save;
    End; // With thLines.Add

    // Save the Transaction - True = auto calculate totals
    Res := Save(True);
    If (Res = 0) Then
    begin
        // Transaction Saved - Update form fields
      DisplayTransInfo(FTransO);
      FIsTransSaved := true;
      ShowMessage('The transaction is saved successfully');
    end
    else
      // Error
      ShowMessage('The following error occurred saving the Stock Adjustment:-' +
                  #13#13 + QuotedStr(oToolkit.LastErrorString));
  End; // With TransO

end;

procedure TForm1.AddPaymentTrans;
var
  Res, i    : SmallInt;
begin

  With FTransO Do Begin

    // Copy in the standard header fields for this exercise
    InitCommonHeader(FTransO);

    // re-assign these 2 fields as it may be changed
    thYourRef := edtYourRef.Text;
    thAcCode := edtAcctCode.Text;

    // delete all lines to make sure each time we have fresh trans lines
    if (thLines.thLineCount>0) then
    begin
       for i := 1 to thlines.thLineCount do
         thLines.Delete(i);
    end;

    With thLines.Add Do Begin
      // Payment Item
      tlStockCode := trim(edtStock.Text);

      // Cheque Number
      tlDescr := '101234';

      // Qty
      tlQty := StrToInt(edtQty.Text);

      // General Ledger Code
      tlGLCode := StrToInt(edtGL.Text);

      // Payment Value
      tlNetValue := StrToInt(edtAmt.Text);

      tlVATCode := 'S';
      // Mark as Payment
      tlPayment := true;

      // Cost Center, Department
      tlCostCentre := trim(edtCC.Text);
      tlDepartment := trim(edtDep.Text);

      // Job Code, Analysis Code
      tlJobCode := trim(edtJobcode.Text);
      tlAnalysisCode := trim(edtAnalCode.Text);

      // Save Line into Transaction
      Save;
    End; // With thLines.Add

    // Save the Transaction - True = auto calculate totals
    Res := Save(True);
    If (Res = 0) Then
    begin
      // Transaction Saved - Update form fields
      DisplayTransInfo(FTransO);
      FIsTransSaved := true;
      ShowMessage('The transaction is saved successfully');
    end
    Else
      // Error
      ShowMessage('The following error occurred saving the Sales Receipt:-' +
                  #13#13 + QuotedStr(oToolkit.LastErrorString));
  End; // With TransO

end;

procedure TForm1.btnSaveTransClick(Sender: TObject);
begin
    case FTransType of

      dtSIN, dtPIN, dtSOR, dtPOR     // SIN, PIN, SOR, POR
      : if (trim(edtStock.Text)<>'') and (trim(edtQty.Text)<>'') then
          AddSPOPTrans
        else
          ShowMessage('StockCode or Qty is required');
      dtSRC, dtPPY            // SRC, PPY
      : AddPaymentTrans;
      dtNMT                   // NOM
      : AddNOMTrans;
      dtADJ                   // ADJ
      : AddADJTrans;
      dtWOR
      : AddWORTrans;
    end;

    if FIsTransSaved then begin
      btnCreate.Enabled := true;
      btnSaveTrans.Enabled := false;
      if FTransO<> nil then FTransO := nil;
      grpTransHeader.Enabled := false;
      grpTransDet.Enabled := false;
    end;
end;
(*
procedure TForm1.FetchTransHeaderDefaults;
var
 I : Integer;
begin
  if Assigned(otoolkit) then
  begin
    TransO := oToolkit.Transaction;
    with TransO do
    begin
      I := GetFirst;
      if (I=0) then
        I := GetEqual(edtOurRef.Text);
    end;
    if (I=0) then
    begin
      result := True;
      edtAcCode.Text := TransO.thAcCode;
      edtTransDate.Text := TransO.thTransDate;
      edtAltRef.Text := TransO.thYourRef;
      edtRef.Text := TransO.thOurRef;
    end;
  end;

end;
*)

function TForm1.GetTransType(): TDocTypes;
begin
  //case cbo (aDesc, ['Sales Invoice', 'Purchase Invoice', 'Sales Order'] of
  case cboTrans.itemindex of

    0 : result := dtSIN;
    1 : result := dtPIN;
    2 : result := dtSOR;
    3 : result := dtPOR;
    4 : result := dtSRC;
    5 : result := dtPPY;
    6 : result := dtNMT;
    7 : result := dtADJ;
    8 : result := dtWOR;

  end;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Remove reference to Transaction Object to destroy it
  if FTransO <> nil then FTransO := nil;

  If Assigned(oToolkit) Then Begin
    // Close COM Toolkit and remove reference
    oToolkit.CloseToolkit;
    oToolkit := NIL;
  End; { If Assigned(oToolkit) }

end;

function TForm1.CheckStockExists(stkCode: string): boolean;
var
  StkKey: string;
  FuncRes: integer;
begin

  Result := false;

  With oToolkit.Stock Do Begin

    index := stIdxDesc;

    // No specifier - use default Stock Code index
    Index := stIdxCode;

    // Build proper index search key for exact match checking
    StkKey := BuildCodeIndex(stkCode);

    If (Trim(StkKey) <> '') Then Begin
        // Check for exact match
        FuncRes := GetEqual(StkKey);
        // Check result and also check we want any found stock item
        If (FuncRes = 0) (*And CheckFilter*) Then
          // Got match - return exact code and a clone interface
          Result := true;

    end;

  end;
end;

procedure TForm1.edtStockExit(Sender: TObject);
begin
  if CheckStockExists(edtStock.Text) then
  begin
    FStock := oToolkit.Stock.Clone;
    with FStock do begin
      edtStock.Text := stCode;
      If (FTransType In [dtPOR, dtPIN]) then        // Purchase Trans
      begin
        edtgl.Text := inttostr(stSalesGL);
        edtStkPrice.Text := FloatToStr(stCostPrice);
        edtStkPrice.Enabled := false;
      end                                           // Sales Trans
      else begin
        edtgl.Text := IntToStr(stCOSGL);
        edtStkPrice.Text := FloatToStr(stCostPrice);    //FloatToStr(stSalesBands[0].stPrice);
        edtStkPrice.Enabled := true;
        edtStkPrice.Refresh;
      end;

      if (trim(stCostCentre) <> '') then
        edtCC.Text := stCostCentre;
      if (trim(stDepartment) <> '') then
        edtDep.Text := stDepartment;

      If not (FTransType In [dtPOR, dtPIN]) then
        edtgl.Text := inttostr(stSalesGL);

      edtQty.Text := '1';
      edtQty.SetFocus;
    end;
  end
  else
  begin
    showmessage('Stock record does not exist...');
    edtStock.SetFocus;
  end;

end;

procedure TForm1.edtQtyExit(Sender: TObject);
var
  Cost: double;
  Qty: integer;
begin
  Cost := strtofloat(edtStkPrice.Text);
  Qty := strtoint(edtQty.Text);

  edtAmt.Text := FloatToStr(Roundto((Cost * Qty), -2));
  //showmessage(edtAmt.Text);
end;

procedure TForm1.ClearEditFields;
var
  i: integer;
  comp: TComponent;
begin
  try
    for i := 0 to (ComponentCount - 1) do
      if (TControl(Components[i]).Parent.Name = 'grpTransHeader') or (TControl(Components[i]).Parent.Name = 'grpTransDet') then
      begin
        if (TControl(Components[i]) is TEdit) then
          TEdit(Components[i]).Text := '';
      end;
  finally

  end;

end;

procedure TForm1.InitTransDetails;
begin

  btnSaveTrans.Enabled := true;
  btnCancelTrans.Enabled := true;

  if (FTransType In [dtSRC, dtPPY, dtNmt]) then
  begin
    grpTransDet.Enabled := true;

    edtStock.Text := 'Payment';
    edtStock.Enabled := false;

    edtQty.Text := '1';
    edtQty.Enabled := false;

    edtStkPrice.Enabled := false;

    edtAmt.Color := clBtnFace;
    edtAmt.Enabled := true;

    edtGL.Text := '11010';

    if edtAmt.CanFocus then edtamt.SetFocus;
  end
  else if (FTransType In [dtSIN, dtPIN, dtSOR, dtPOR, dtADJ, dtWOR]) then
  begin
    grpTransDet.Enabled := true;
    edtStock.Enabled := true;

    edtQty.Enabled := true;
    edtStkPrice.Enabled := true;

    if edtStock.CanFocus then edtStock.SetFocus;

  end;

end;

procedure TForm1.edtAcctCodeExit(Sender: TObject);
begin
  InitTransDetails;
end;


procedure TForm1.AddWORTrans;
var
  res, i  : smallint;
  tlAsWOR : ITransactionLineAsWOR;
begin
  try
    With FTransO do
    begin
      // Copy in the standard header fields for this exercise
      InitCommonHeader(FTransO);

      // re-assign these 2 fields as it may be changed
      thYourRef := edtYourRef.Text;
      thAcCode := edtAcctCode.Text;

      // delete all lines to make sure each time we have fresh trans lines
      if (thLines.thLineCount>0) then
      begin
         for i := 1 to thlines.thLineCount do
           thLines.Delete(i);
      end;

      tlAsWOR  := thLines.Add as ITransactionLineAsWOR;

      With tlAsWOR Do Begin

        // Stock Item
        tlwStockCode := trim(edtStock.Text); // BOM Stock required;

        //tlDescr := FTransDesc;

        // Bring in defaults:- Descr, Location, GL, CC, Dept, Cost, VAT, etc...
        ImportDefaults;

        // Cost Center, Department
        tlwCostCentre := trim(edtCC.Text);
        tlwDepartment := trim(edtDep.Text);

        // Qty
        tlwQtyRequired := StrToInt(edtQty.text);

        // Save Line into Transaction
        Save(true);

        ExplodeBOM;
      End; // With thLines.Add

      // Save the Transaction - True = auto calculate totals
      Res := Save(True);

      If (Res = 0) Then
      begin
        // Transaction Saved - Update form fields
        DisplayTransInfo(FTransO);
        FIsTransSaved := true;
        ShowMessage('The transaction is saved successfully');
      end
      else
        // Error
        ShowMessage('The following error occurred saving the ' + FTransDesc + ':-' +
                    #13#13 + QuotedStr(oToolkit.LastErrorString));
    end; // With TransO
  Except
    on E : Exception do
      ShowMessage(E.message);
  end

end;

procedure TForm1.btnCancelTransClick(Sender: TObject);
begin
  ClearEditFields;

  if FTransO<> nil then FTransO := nil;

  btnCreate.Enabled := true;
  btnSaveTrans.Enabled := false;
  btnCancelTrans.Enabled := false;

  grpTransHeader.Enabled := false;
  grpTransDet.Enabled := false;
  btnCreate.SetFocus;

end;

procedure TForm1.FormShow(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet2;
  if btnOpenToolkit.CanFocus then btnOpenToolkit.SetFocus;
end;

procedure TForm1.FillAccessSettingsList;
var
  aList: TStrings;
begin
  aList := TStringList.create;

  aList.Add('Access Settings');
  aList.Add('Sales - Ability to create Invoice(SIN) = [355]');
  aList.Add('Purchase - Ability to create Invoice(PIN) = [364]');
  aList.Add('Stock Records - Add = [110]');

  cboAccess.Items.AddStrings(aList);
  cboAccess.ItemIndex := 0;

  aList.Free;

end;

procedure TForm1.btnChkLoginClick(Sender: TObject);
var
  FuncRes: integer;
begin
  if (trim(edtUserID.Text) = EmptyStr) or (trim(edtPwd.Text) = EmptyStr) then
  begin
    showmessage('Username and Password field can not be left blank.');
    exit;
  end
  else
    edtUserID.Text := UpperCase(edtUserID.Text);

  If Assigned(oToolkit) And (oToolkit.Status = tkOpen) Then
  begin
    FuncRes := oToolkit.Functions.entCheckPassword(edtUserID.Text, edtPwd.Text);

    if FuncRes = 0 then
      Showmessage('Welcome to Exchequer...')
    else
      Showmessage('Invalid Login Credentials...');

  end;
end;

procedure TForm1.btnChkAccessClick(Sender: TObject);
var
  FuncRes: integer;
  lAreaCode,lStart: integer;
begin
  if (trim(edtUserID.Text) = EmptyStr) then
  begin
    showmessage('Username field can not be left blank.');
    exit;
  end
  else
    edtUserID.Text := UpperCase(edtUserID.Text);


  If Assigned(oToolkit) And (oToolkit.Status = tkOpen) Then
  begin
    if (cboAccess.ItemIndex > 0) then
    begin
      lStart := pos('[', cboAccess.Text);
      lAreaCode := StrToInt(copy(cboAccess.Text, lStart+1, 3));
      FuncRes := oToolkit.Functions.entCheckSecurity(edtUserID.Text, lAreaCode);

      if FuncRes = 0 then
        Showmessage('Access Setting Passed...')
      else
        Showmessage('Access Setting Failed...');
    end;
  end;
end;


procedure TForm1.SaveClick(Sender: TObject);
var
  LEmp: IEmployee;
  LEmp1: IEmployee8;
  lStatus,i : Integer;
  lStrList: TStringList;
begin
  lst1.Clear;
  If Assigned(oToolkit) Then
  begin
    Emp := oToolkit.JobCosting.Employee;
    Emp1 :=  Emp as IEmployee8;  

    lStatus := Emp1.GetFirst;
    if lStatus = 0 then
      lStatus := Emp1.GetEqual(Emp1.BuildCodeIndex(edtEmpCode.Text));

    if lStatus = 0 then
    begin
      LEmp := Emp1.Update;
      LEmp1 := LEmp as IEmployee8;
      LEmp1.emStatus := StrToInt(edEmpStatus.Text);
      lStatus := LEmp1.Save;
    end;

    if lStatus=0 then
    begin
      lStrList := TStringList.Create;
      try
        lStatus := Emp1.GetEqual(Emp1.BuildCodeIndex(edtEmpCode.Text));
        lStrList.add('Employee Status : '+IntToStr(LEmp1.emStatus));
        lStrList.add('Employee Anonymisation Status : '+IntToStr(Emp1.emAnonymisationStatus));
        lStrList.add('Employee Anonymisation Date : '+ Emp1.emAnonymisedDate);
        lStrList.add('Employee Anonymisation Time : '+ Emp1.emAnonymisedTime);
        for i:=0 to lStrList.Count-1 do
          lst1.Items.Add(lStrList[i]);
      finally
        FreeAndNil(lStrList);
      end;
    end
    else
      ShowMessage('The error occurred editing the account' + ':-' +
                  #13#13 + QuotedStr(oToolkit.LastErrorString));
    end;
end;

procedure TForm1.SaveTraderClick(Sender: TObject);
var
  LCust: IAccount;
  LCust1: IAccount12;
  lStatus,i : Integer;
  lStrList: TStringList;
begin
  lst1.Clear;
  If Assigned(oToolkit) Then
  begin
    if  (TraderType.ItemIndex = 0) then
      Cust := oToolkit.Supplier
    else
      Cust := oToolkit.Customer;

    Cust1 :=  Cust as IAccount12;

    lStatus := Cust1.GetFirst;
    if lStatus = 0 then
      lStatus := Cust1.GetEqual(Cust1.BuildCodeIndex(edtTraderCode.Text));

    if lStatus = 0 then
    begin
      LCust := Cust1.Update;
      LCust1 := LCust as IAccount12;
      LCust1.acAccStatus := TAccountStatus(StrToInt(edtTraderStatus.Text));
      lStatus := LCust1.Save;
    end;

    if lStatus=0 then
    begin
      lStrList := TStringList.Create;
      try
        lStatus := Cust1.GetEqual(Cust1.BuildCodeIndex(edtTraderCode.Text));
        lStrList.add('Account Status : '+IntToStr(Cust1.acAccStatus));
        lStrList.add('Anonymisation Status : '+IntToStr(Cust1.acAnonymisationStatus));
        lStrList.add('Anonymisation Date : '+ Cust1.acAnonymisedDate);
        lStrList.add('Anonymisation Time : '+ Cust1.acAnonymisedTime);
        for i:=0 to lStrList.Count-1 do
          lst1.Items.Add(lStrList[i]);
      finally
        FreeAndNil(lStrList);
      end;
    end
    else
      ShowMessage('The error occurred editing the account' + ':-' +
                  #13#13 + QuotedStr(oToolkit.LastErrorString));
    end;
end;

end.

unit VatInfoW;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, CustAbsU, ExtCtrls, IniFiles;

type
  TfrmVATInfo = class(TForm)
    lblQty: TLabel;
    ccyQty: TCurrencyEdit;
    lblUPrice: TLabel;
    ccyUnitPrice: TCurrencyEdit;
    lblTotal: TLabel;
    ccyTotal: TCurrencyEdit;
    lblTitle: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    WinName : ShortString;
    IniF    : TIniFile;
  public
    { Public declarations }
    Procedure UpdateInfo(Const EventData : TAbsEnterpriseSystem);
  end;

var
  frmVATInfo: TfrmVATInfo;

implementation

{$R *.DFM}


procedure TfrmVATInfo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  IniF.WriteInteger('WindowPos', WinName + '.X', Self.Left);
  IniF.WriteInteger('WindowPos', WinName + '.Y', Self.Top);
  IniF.Free;

  Action := caFree;
end;

procedure TfrmVATInfo.FormDestroy(Sender: TObject);
begin
  frmVATInfo := NIL;
end;

procedure TfrmVATInfo.FormCreate(Sender: TObject);
Var
  pSysInfo  : PChar;
  StrLength : DWord;
  OrigLeft  : LongInt;
begin
  ClientHeight := 94;
  ClientWidth  := 146;

  { Get Windows User Id }
  StrLength := 100;
  pSysInfo := StrAlloc (StrLength);
  GetUserName (pSysInfo, StrLength);
  WinName := pSysInfo;
  StrDispose (pSysInfo);

  { set default position - bottom-left corner of MDI parent }
  With Application Do Begin
    Self.Left := MainForm.ClientWidth - Self.Width - 15;
    OrigLeft := Self.Left;
    Self.Top  := 0;
  End; { With }

  { Read .ini file settings }
  IniF := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'COMPVATW.INI');
  Self.Left := IniF.ReadInteger('WindowPos', WinName + '.X', Self.Left);
  Self.Top := IniF.ReadInteger('WindowPos', WinName + '.Y', Self.Top);

  { make sure windows is within view }
  If ((Self.Left + Self.Width) > Application.MainForm.ClientWidth) Then Begin
    Self.Left := OrigLeft;
  End; { If }

  If ((Self.Top + Self.Height) > (Application.MainForm.ClientHeight - 50)) Then Begin
    Self.Top := Application.MainForm.ClientHeight - 50 - Self.Height;
  End; { If }
end;

Procedure TfrmVATInfo.UpdateInfo(Const EventData : TAbsEnterpriseSystem);
Var
  LineTot, UnPrice : Double;
Begin { UpdateInfo }
  With EventData, Transaction, Setup Do Begin
    Caption := thOurRef;

    lblTitle.Enabled := Assigned(thLines.thCurrentLine);
    lblQty.Enabled := Assigned(thLines.thCurrentLine);
    lblUPrice.Enabled := Assigned(thLines.thCurrentLine);
    lblTotal.Enabled := Assigned(thLines.thCurrentLine);

    If Assigned(thLines.thCurrentLine) Then Begin
      If (thLines.thCurrentLine.AccessRights <> NotAvailable) Then Begin
        { Get Vat Details }
        With thLines.thCurrentLine{, ssVatRates[entGetTaxNo(tlVatCode)]} Do Begin
          { Calculate Invoice total }
          (* HM 05/09/00: Modified to work with Inclusive VAT
          RNum := entRound(entInvLTotal(True, 0) * (1 + svRate), 2);

          ccyQty.Value       := tlQty;
          ccyTotal.Value     := RNum;
          ccyUnitPrice.Value := entRound(RNum/tlQty,2);
          *)

          // Add Line Total to VAT to get gross line total
          LineTot := entRound(entInvLTotal(True, 0) + tlVATAmount, 2);

          // divide by Qty to get actual unit price including VAT
          UnPrice := entRound(LineTot / tlQty, 2);

          ccyQty.Value       := tlQty;
          ccyUnitPrice.Value := UnPrice;
          ccyTotal.Value     := LineTot;
        End; { With }
      End; { With }
    End; { If }
  End; { With }
End; { UpdateInfo }

end.

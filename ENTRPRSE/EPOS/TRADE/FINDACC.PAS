unit FindAcc;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IAeverButton, ExtCtrls;

type
  TFrmFindAccount = class(TForm)
    Panel7: TPanel;
    Shape8: TShape;
    edPhoneNo: TEdit;
    Panel2: TPanel;
    Shape2: TShape;
    edAccountName: TEdit;
    Panel3: TPanel;
    Shape3: TShape;
    edAltCode: TEdit;
    Panel4: TPanel;
    Shape4: TShape;
    edTaxCode: TEdit;
    Panel5: TPanel;
    Shape6: TShape;
    edPostCode: TEdit;
    Panel6: TPanel;
    Shape7: TShape;
    edTheirCode: TEdit;
    Panel1: TPanel;
    Shape5: TShape;
    edAccountCode: TEdit;
    btnAccountCode: TIAeverButton;
    btnAccountName: TIAeverButton;
    btnAltCode: TIAeverButton;
    btnTaxCode: TIAeverButton;
    btnPostCode: TIAeverButton;
    btnTheirCode: TIAeverButton;
    btnPhoneNo: TIAeverButton;
    btnCancel: TIAeverButton;
    btnFind: TIAeverButton;
    Panel8: TPanel;
    Shape1: TShape;
    edInvoiceTo: TEdit;
    btnInvoiceTo: TIAeverButton;
    Panel9: TPanel;
    Shape9: TShape;
    edEmailAddress: TEdit;
    btnEmailAddress: TIAeverButton;
    Panel10: TPanel;
    Shape10: TShape;
    edAnyField: TEdit;
    btnAnyField: TIAeverButton;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnAccountCodeClick(Sender: TObject);
    procedure btnAccountNameClick(Sender: TObject);
    procedure btnAltCodeClick(Sender: TObject);
    procedure btnTaxCodeClick(Sender: TObject);
    procedure btnPhoneNoClick(Sender: TObject);
    procedure btnPostCodeClick(Sender: TObject);
    procedure btnTheirCodeClick(Sender: TObject);
    procedure btnInvoiceToClick(Sender: TObject);
    procedure btnEmailAddressClick(Sender: TObject);
    procedure btnAnyFieldClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure edChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    bEditChanging : boolean;
  public
    { Public declarations }
  end;

var
  FrmFindAccount: TFrmFindAccount;

implementation
uses
  EPOSKey, StrUtil, EntLkUp, EPOSProc, EPOSCnst, GfxUtil, BackGrnd;

{$R *.DFM}

procedure TFrmFindAccount.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TFrmFindAccount.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LocalKey : Word;
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
  LocalKey := Key;
  Key := 0;

  {trap function Keys}
  If (LocalKey In [VK_F1..VK_F12]) and (Not (ssAlt In Shift)) then
    begin
      case LocalKey of
//        VK_F1 : Application.HelpCommand(HELP_Finder,0);
        VK_F2 : btnAccountCodeClick(nil);
        VK_F3 : btnAccountNameClick(nil);
        VK_F4 : btnAltCodeClick(nil);
        VK_F5 : btnTaxCodeClick(nil);
        VK_F6 : btnPhoneNoClick(nil);
        VK_F7 : btnPostCodeClick(nil);
        VK_F8 : btnTheirCodeClick(nil);
        VK_F9 : btnInvoiceToClick(nil);
        VK_F10 : btnEmailAddressClick(nil);
        VK_F11 : btnAnyFieldClick(nil);
        VK_F12 : btnFindClick(nil);
        else Key := LocalKey;
      end;{case}
    end
  else Key := LocalKey;
end;

procedure TFrmFindAccount.btnAccountCodeClick(Sender: TObject);
begin
  ActiveControl := edAccountCode;
end;

procedure TFrmFindAccount.btnAccountNameClick(Sender: TObject);
begin
  ActiveControl := edAccountName;
end;

procedure TFrmFindAccount.btnAltCodeClick(Sender: TObject);
begin
  ActiveControl := edAltCode;
end;

procedure TFrmFindAccount.btnTaxCodeClick(Sender: TObject);
begin
  ActiveControl := edTaxCode;
end;

procedure TFrmFindAccount.btnPhoneNoClick(Sender: TObject);
begin
  ActiveControl := edPhoneNo;
end;

procedure TFrmFindAccount.btnPostCodeClick(Sender: TObject);
begin
  ActiveControl := edPostCode;
end;

procedure TFrmFindAccount.btnTheirCodeClick(Sender: TObject);
begin
  ActiveControl := edTheirCode;
end;

procedure TFrmFindAccount.btnInvoiceToClick(Sender: TObject);
begin
  ActiveControl := edInvoiceTo;
end;

procedure TFrmFindAccount.btnEmailAddressClick(Sender: TObject);
begin
  ActiveControl := edEmailAddress;
end;

procedure TFrmFindAccount.btnAnyFieldClick(Sender: TObject);
begin
  ActiveControl := edAnyField;
end;

procedure TFrmFindAccount.btnFindClick(Sender: TObject);
var
  sFindCode : string20;
  iIndexNo, iCont, iPanCont : integer;
begin
  if btnFind.Enabled then begin
    {Find the edit box with the text in}
    sFindCode := '';
    for iCont := 0 to ControlCount - 1 do begin
      if Controls[iCont] is TPanel then begin
        for iPanCont := 0 to TPanel(Controls[iCont]).ControlCount - 1 do begin
          if (TPanel(Controls[iCont]).Controls[iPanCont] is TEdit)
          and (TEdit(TPanel(Controls[iCont]).Controls[iPanCont]).Text <> '')
          then begin
            {The edit control with the text in, has been found}
            with TEdit(TPanel(Controls[iCont]).Controls[iPanCont]) do begin
              sFindCode := Text;
              if Name = 'edAnyField' then sfindcode := '*' + sfindcode;
              iIndexNo := Tag;
              SelectAll;
            end;{with}
          end;{if}
        end;{for}
      end;{if}
    end;{for}
    if DoGetCust(Self, sCurrCompPath, sFindCode, sFindCode, trdCustomer, vmShowList, TRUE, TCustIndex(iIndexNo))
    then ModalResult := mrOK;
  end;{if}
end;

procedure TFrmFindAccount.edChange(Sender: TObject);
var
  iCont, iPanCont : integer;
begin
  {Blanks all edit controls, other than the one you have just typed in}
  if not bEditChanging then begin
    btnFind.Enabled := FALSE;
    bEditChanging := TRUE;
    for iCont := 0 to ControlCount - 1 do begin
      if Controls[iCont] is TPanel then begin
        for iPanCont := 0 to TPanel(Controls[iCont]).ControlCount - 1 do begin

          {blank any other edit cells}
          if (TPanel(Controls[iCont]).Controls[iPanCont] is TEdit)
          and (TEdit(TPanel(Controls[iCont]).Controls[iPanCont]).name <> TEdit(Sender).name)
          then TEdit(TPanel(Controls[iCont]).Controls[iPanCont]).Text := '';

          {enable find button if applicable}
          if (TPanel(Controls[iCont]).Controls[iPanCont] is TEdit)
          and (TEdit(TPanel(Controls[iCont]).Controls[iPanCont]).Text <> '')
          then btnFind.Enabled := TRUE;

        end;{for}
      end;{if}
    end;{for}
    bEditChanging := FALSE;
  end;{if}
end;

procedure TFrmFindAccount.FormCreate(Sender: TObject);
begin
  if SysColorMode in ValidColorSet then DrawFormBackground(self, bitFormBackground);
  bEditChanging := FALSE;
end;

end.

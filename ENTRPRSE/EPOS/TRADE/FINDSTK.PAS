unit FindStk;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IAeverButton, ExtCtrls;

type
  TFrmFindStock = class(TForm)
    Panel1: TPanel;
    Shape5: TShape;
    edStockCode: TEdit;
    btnStockCode: TIAeverButton;
    btnDescription: TIAeverButton;
    btnPrefSupp: TIAeverButton;
    btnAltCode: TIAeverButton;
    btnBarCode: TIAeverButton;
    btnAnyField: TIAeverButton;
    Panel2: TPanel;
    Shape2: TShape;
    edStockDesc: TEdit;
    Panel3: TPanel;
    Shape3: TShape;
    edPrefSuppCode: TEdit;
    Panel4: TPanel;
    Shape4: TShape;
    edAltCode: TEdit;
    Panel5: TPanel;
    Shape6: TShape;
    edBarcode: TEdit;
    Panel6: TPanel;
    Shape7: TShape;
    edAnyField: TEdit;
    btnAltSupp: TIAeverButton;
    Panel7: TPanel;
    Shape8: TShape;
    edSuppAltCode: TEdit;
    btnCancel: TIAeverButton;
    btnFind: TIAeverButton;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFindClick(Sender: TObject);
    procedure btnStockCodeClick(Sender: TObject);
    procedure btnDescriptionClick(Sender: TObject);
    procedure btnPrefSuppClick(Sender: TObject);
    procedure btnAltCodeClick(Sender: TObject);
    procedure btnAltSuppClick(Sender: TObject);
    procedure btnBarCodeClick(Sender: TObject);
    procedure btnAnyFieldClick(Sender: TObject);
    procedure edChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    bEditChanging : boolean;
  public
    { Public declarations }
  end;

var
  FrmFindStock: TFrmFindStock;

implementation
uses
  EPOSKey, StrUtil, EntLkUp, EPOSProc, EPOSCnst, GfxUtil;

{$R *.DFM}

procedure TFrmFindStock.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TFrmFindStock.FormKeyDown(Sender: TObject; var Key: Word;
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
        VK_F2 : btnStockCodeClick(nil);
        VK_F3 : btnDescriptionClick(nil);
        VK_F4 : btnPrefSuppClick(nil);
        VK_F5 : btnAltCodeClick(nil);
        VK_F6 : btnAltSuppClick(nil);
        VK_F7 : btnBarCodeClick(nil);
        VK_F8 : btnAnyFieldClick(nil);
        VK_F12 : btnFindClick(nil);
        else Key := LocalKey;
      end;{case}
    end
  else Key := LocalKey;
end;

procedure TFrmFindStock.btnFindClick(Sender: TObject);
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
            with TEdit(TPanel(Controls[iCont]).Controls[iPanCont]) do begin
              {The edit control with the text in, has been found}
              sFindCode := Text;
              if Name = 'edAnyField' then sfindcode := '**' + sfindcode;
              iIndexNo := Tag;
              SelectAll;
            end;{with}
          end;{if}
        end;{for}
      end;{if}
    end;{for}
    if DoGetStock(self, sCurrCompPath, sFindCode, sFindCode, [stkProduct, stkBOM]
    , vmShowList, TRUE, TStockIndex(iIndexNo)) then ModalResult := mrOK;
  end;{if}
end;

procedure TFrmFindStock.btnStockCodeClick(Sender: TObject);
begin
  ActiveControl := edStockCode;
end;

procedure TFrmFindStock.btnDescriptionClick(Sender: TObject);
begin
  ActiveControl := edStockDesc;
end;

procedure TFrmFindStock.btnPrefSuppClick(Sender: TObject);
begin
  ActiveControl := edPrefSuppCode;
end;

procedure TFrmFindStock.btnAltCodeClick(Sender: TObject);
begin
  ActiveControl := edAltCode;
end;

procedure TFrmFindStock.btnAltSuppClick(Sender: TObject);
begin
  ActiveControl := edSuppAltCode;
end;

procedure TFrmFindStock.btnBarCodeClick(Sender: TObject);
begin
  ActiveControl := edBarcode;
end;

procedure TFrmFindStock.btnAnyFieldClick(Sender: TObject);
begin
  ActiveControl := edAnyField;
end;

procedure TFrmFindStock.edChange(Sender: TObject);
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

procedure TFrmFindStock.FormCreate(Sender: TObject);
begin
  if SysColorMode in ValidColorSet then DrawFormBackground(self, bitFormBackground);
end;

end.

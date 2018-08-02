unit NomLine;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , AddNomProc, StdCtrls, TEditVal, Mask, ExtCtrls, NumEdit;

const
  TAG_VAT_CODE = 5;
  TAG_NET_AMOUNT = 6;
  TAG_VAT_AMOUNT = 7;
  NO_OF_FIELDS_TO_VALIDATE = 7;
  
type
  TfNomLine = class(TFrame)
    edDesc: TEdit;
    edGLCode: TEdit;
    edCC: TEdit;
    edDept: TEdit;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    lGrossAmount: TLabel;
    cmbVATCode: TComboBox;
    edNetAmount: TNumEdit;
    edVATAmount: TNumEdit;
    procedure EditEnter(Sender: TObject);
    procedure AmountExit(Sender: TObject);
    procedure edGLCodeExit(Sender: TObject);
    procedure edCCExit(Sender: TObject);
    procedure edDeptExit(Sender: TObject);
  private
    iNoOfDecs : integer;
    PreviousControl : TWinControl;
    OwnerForm : TForm;
  public
    Tabbed : boolean;
    OnAddNewLine, OnRecalcTotals : TNotifyEvent;
    aValidation : array [1..NO_OF_FIELDS_TO_VALIDATE] of ValidationRec;
    procedure Initialise;
    procedure CursorRight;
    procedure CursorLeft;
    procedure FocusControlWithTag(iTag : integer);
  end;

implementation
uses
  StrUtil, uExDatasets, Enterprise01_TLB, TKPickList;
  
{$R *.dfm}

{ TfNomLine }

procedure TfNomLine.CursorRight;
var
  CurrActiveControl : TWinControl;
  bPostMessage : boolean;
begin
  CurrActiveControl := OwnerForm.ActiveControl;
  if CurrActiveControl <> edVATAmount then
  begin
    bPostMessage := FALSE;

    if (CurrActiveControl is TCustomEdit) then
    begin
      if ((CurrActiveControl as TCustomEdit).SelStart
      + (CurrActiveControl as TCustomEdit).SelLength)
      = length((CurrActiveControl as TCustomEdit).text)
      then bPostMessage := TRUE;
    end else
    begin
      if (CurrActiveControl is TComboBox)
      then bPostMessage := FALSE
      else  bPostMessage := TRUE;
    end;{if}

    if bPostMessage then PostMessage(OwnerForm.Handle,wm_NextDlgCtl,0,0);
  end;{if}

{  if (Self.Owner as TForm).ActiveControl <> edVATAmount then
  begin
    with ((Self.Owner as TForm).ActiveControl as TCustomEdit) do
    begin
//      showmessage(IntToStr(SelStart));
//      showmessage(IntToStr(SelLength));
//      showmessage(IntToStr(length(text)));
      if (SelStart + SelLength) = length(text)
      then PostMessage((Self.Owner as TForm).Handle,wm_NextDlgCtl,0,0);
    end;{with}
{  end;{if}
end;

procedure TfNomLine.CursorLeft;
var
  CurrActiveControl : TWinControl;
  bPostMessage : boolean;
begin
  CurrActiveControl := OwnerForm.ActiveControl;

  if CurrActiveControl <> edDesc then
  begin
    bPostMessage := FALSE;

    if (CurrActiveControl is TCustomEdit) then
    begin
      if ((CurrActiveControl as TCustomEdit).SelStart = 0)
      then bPostMessage := TRUE;
    end else
    begin
      if (CurrActiveControl is TComboBox)
      then bPostMessage := FALSE
      else  bPostMessage := TRUE;
    end;{if}

    if bPostMessage then PostMessage(OwnerForm.Handle,wm_NextDlgCtl,1,0);
  end;{if}
end;

procedure TfNomLine.EditEnter(Sender: TObject);
begin
  if not Tabbed then
  begin
    if (Sender is TCustomEdit) then
    begin
      if TWinControl(Sender).TabOrder > PreviousControl.TabOrder then
      begin
        // Previous control is BEFORE the active control
        // put cursor at begining of edit box
        (Sender as TCustomEdit).SelStart := 0;
      end else
      begin
        // Previous control is AFTER the active control
        // put cursor at the end of edit box
        (Sender as TCustomEdit).SelStart := Length((Sender as TCustomEdit).text);
      end;
      (Sender as TCustomEdit).SelLength := 0;    // don't select any text
    end;{if}
  end;{if}

  PreviousControl := TWinControl(Sender); // keep track of previous control
  Tabbed := FALSE;  // Reset Tabbed property

end;

procedure TfNomLine.Initialise;
// Alway call this after creating a frame - there is no OnCreate event
var
  iPos : integer;
begin
  iNoOfDecs := 2;  // values on noms are always to 2 deimal places.....allegedly

  PreviousControl := edDesc;
  Tabbed := TRUE;
  edNetAmount.Value := 0;
  edVATAmount.Value := 0;
  lGrossAmount.Caption := MoneyToStr(0, iNoOfDecs);

  OwnerForm := (Self.Owner as TForm);

  For iPos := 1 to NO_OF_FIELDS_TO_VALIDATE
  do aValidation[iPos].FieldOK := FALSE;
end;

procedure TfNomLine.FocusControlWithTag(iTag: integer);
var
  iPos : integer;
begin
  For iPos := 0 to ControlCount -1 do
  begin
    if iTag = TWinControl(Controls[iPos]).Tag
    then OwnerForm.ActiveControl := TWinControl(Controls[iPos]);
  end;{for}
end;

procedure TfNomLine.AmountExit(Sender: TObject);
begin
  if TWinControl(Sender).Tag in [TAG_NET_AMOUNT, TAG_VAT_CODE] then
  begin
    edVATAmount.Value := edNetAmount.Value
    * TVATInfo(cmbVatCode.Items.Objects[cmbVatCode.Itemindex]).rRate;

    lGrossAmount.Caption := MoneyToStr(edNetAmount.Value + edVatAmount.Value, iNoOfDecs);
  end;{if}

//  if TWinControl(Sender).Tag in [TAG_VAT_AMOUNT] then
//  begin
    lGrossAmount.Caption := MoneyToStr(edNetAmount.Value + edVatAmount.Value, iNoOfDecs);
//  end;{if}

  OnRecalcTotals(self);

  if TWinControl(Sender).Tag = TAG_NET_AMOUNT then
  begin
    if Tabbed then
    begin
      if OwnerForm.ActiveControl <> cmbVATCode
  //    then Showmessage('AddLine');
      then OnAddNewLine(self);
    end;{if}
  end;{if}
end;

procedure TfNomLine.edGLCodeExit(Sender: TObject);
var
  oGL : IGeneralLedger;
  iGLCode : integer;
begin
//  OwnerForm.OnDeactivate(OwnerForm);

  oGL := ValidateGLCode(TEdit(Sender));
  if oGL = nil then
  begin
    if TWinControl(OwnerForm.ActiveControl).Tag >= 0 then
    begin
      with TfrmTKPickList.CreateWith(self, oToolkit) do begin

        mlList.Columns[0].DataType := dtInteger;
        plType := plGLCode;
        iGLCode := StrToIntDef(edGLCode.Text,0);

        if (iGLCode = 0) and (edGLCode.Text <> '0') then
          begin
            sFind := edGLCode.Text;
            iSearchCol := 1;
          end
        else begin
          sFind := mlList.FullNomKey(iGLCode);
          iSearchCol := 0;
        end;{if}
        mlList.Columns[1].IndexNo := 1;

    //    sFind := edGLCode.Text;
        if showmodal = mrOK then begin
          oGL := ctkDataSet.GetRecord as IGeneralLedger;
          edGLCode.Text := IntToStr(oGL.glCode);
        end;
        release;

        oGL := ValidateGLCode(TEdit(Sender));

      end;{with}
    end;{if}
  end;{if}

  aValidation[TWincontrol(Sender).Tag].FieldOK := oGL <> nil;
end;

procedure TfNomLine.edCCExit(Sender: TObject);
var
  oCC : ICCDept;
begin
  oCC := ValidateCostCentre(TEdit(Sender));
  if oCC = nil then
  begin
    if TWinControl(OwnerForm.ActiveControl).Tag >= 0 then
    begin
      with TfrmTKPickList.CreateWith(self, oToolkit) do begin
        plType := plCC;
        sFind := edCC.Text;
        iSearchCol := 0;
        mlList.Columns[1].IndexNo := 1;
        if showmodal = mrOK then
        begin
          oCC := ctkDataSet.GetRecord as ICCDept;
          edCC.Text := oCC.cdCode;
        end else
        begin
//          lCC.Caption := '';
        end;{if}
        release;

        oCC := ValidateCostCentre(TEdit(Sender));

      end;{with}
    end;{if}
  end;{if}

  aValidation[TWincontrol(Sender).Tag].FieldOK := oCC <> nil;
end;

procedure TfNomLine.edDeptExit(Sender: TObject);
var
  oDept : ICCDept;
begin
  oDept := ValidateDepartment(TEdit(Sender));
  if oDept = nil then
  begin
    if TWinControl(OwnerForm.ActiveControl).Tag >= 0 then
    begin
      with TfrmTKPickList.CreateWith(self, oToolkit) do begin
        plType := plDept;
        sFind := edDept.Text;
        iSearchCol := 0;
        mlList.Columns[1].IndexNo := 1;
        if showmodal = mrOK then
        begin
          oDept := ctkDataSet.GetRecord as ICCDept;
          edDept.Text := oDept.cdCode;
//          lDept.Caption := oDept.cdName;
        end else
        begin
//          lDept.Caption := '';
        end;{if}
        release;

        oDept := ValidateDepartment(TEdit(Sender));
      end;{with}
    end;{if}
  end;{if}

  aValidation[TWincontrol(Sender).Tag].FieldOK := oDept <> nil;
end;

end.

unit NomLine;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, NumEdit;

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
    edVATAmount: TNumEdit;
    edNetAmount: TNumEdit;
    Label2: TLabel;
    cmbVATCode: TComboBox;
    procedure EditEnter(Sender: TObject);
    procedure edNetAmountExit(Sender: TObject);
    procedure edGLCodeExit(Sender: TObject);
  private
    PreviousControl : TWinControl;
    OwnerForm : TForm;
  public
    Tabbed : boolean;
    OnAddNewLine : TNotifyEvent;
    procedure Initialise;
    procedure CursorRight;
    procedure CursorLeft;
    procedure FocusControlWithTag(iTag : integer);
  end;

implementation
uses
  uExDatasets, Enterprise01_TLB, AddNomProc, TKPickList;
  
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
      bPostMessage := TRUE;
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
      bPostMessage := TRUE;
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
begin
  PreviousControl := edDesc;
  Tabbed := TRUE;
  edNetAmount.Value := 0;
  edVATAmount.Value := 0;
  OwnerForm := (Self.Owner as TForm);
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

procedure TfNomLine.edNetAmountExit(Sender: TObject);
begin
  if Tabbed then
  begin
    if OwnerForm.ActiveControl <> cmbVATCode
//    then Showmessage('AddLine');
    then OnAddNewLine(self);
  end;{if}
end;

procedure TfNomLine.edGLCodeExit(Sender: TObject);
var
  oGL : IGeneralLedger;
  iGLCode : integer;
begin
//  OwnerForm.OnDeactivate(OwnerForm);

  if OwnerForm.ActiveControl = edCC then
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

    end;{with}
  end;{if}

//  SetForegroundWindow(OwnerForm.Handle);
//  OwnerForm.OnActivate(OwnerForm);
end;

end.

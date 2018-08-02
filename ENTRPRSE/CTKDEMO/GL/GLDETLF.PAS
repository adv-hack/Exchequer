unit GLDetlF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GLTreeF, Enterprise01_TLB, StdCtrls;

type
  TfrmGLDetail = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtGLCode: TEdit;
    Label2: TLabel;
    edtAltCode: TEdit;
    Label3: TLabel;
    edtGLName: TEdit;
    Label4: TLabel;
    lstGLType: TComboBox;
    btnSave: TButton;
    btnCancel: TButton;
    Label5: TLabel;
    edtParent: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FGLDetail    : IGeneralLedger;
    FMode        : TDialogMode;
    FNeedRefresh : Boolean;
  protected
    procedure SetGLDetail(const Value: IGeneralLedger);
    Procedure SetMode (Value : TDialogMode);
  public
    { Public declarations }
    Property GLDetail : IGeneralLedger Read FGLDetail Write SetGLDetail;
    Property Mode : TDialogMode Read FMode Write SetMode;
    Property NeedRefresh : Boolean Read FNeedRefresh Write FNeedRefresh;
  end;

implementation

{$R *.DFM}

procedure TfrmGLDetail.FormCreate(Sender: TObject);
begin
  // Initialise local variables
  FGLDetail    := Nil;
  fMode        := mdAdd;
  FNeedRefresh := False;
end;

{----------------------------------------}

procedure TfrmGLDetail.FormDestroy(Sender: TObject);
begin
  // Explicitly release reference to interface
  FGLDetail := Nil;
end;

{----------------------------------------}

procedure TfrmGLDetail.SetGLDetail(const Value: IGeneralLedger);
Var
  ParentI : IGeneralLedger;
begin
  If (FGLDetail <> Value) Then Begin
    FGLDetail := Value;

    With FGLDetail Do Begin
      // Set window title
      If (FMode = mdAdd) Then
        Caption := 'Add New GL Code'
      Else
        Caption := 'GL Code Record - ' + IntToStr(glCode) + ', ' + Trim(glName);

      // Display Fields
      ParentI := glParentI;
      If Assigned(ParentI) Then
        edtParent.Text := IntToStr(ParentI.glCode) + ' - ' + ParentI.glName;
      edtGLCode.Text := IntToStr(glCode);
      edtAltCode.Text := Trim(glAltCode);
      edtGLName.Text := Trim(glName);
      lstGLType.ItemIndex := Ord(glType);
    End; { With FGLDetail }
  End; { If (FGLDetail <> Value) }
end;

{----------------------------------------}

procedure TfrmGLDetail.SetMode(Value: TDialogMode);
begin
  FMode := Value;

  // Enable/Disable fields according to dialog purpose
  edtGLCode.ReadOnly := (FMode <> mdAdd);
  lstGLType.Enabled := Not edtGLCode.ReadOnly;

  edtAltCode.ReadOnly := Not (FMode In [mdAdd, mdEdit]);
  edtGLName.ReadOnly := edtAltCode.ReadOnly;

  btnSave.Enabled := (FMode In [mdAdd, mdEdit]);
  If btnSave.Enabled Then btnCancel.Caption := '&Cancel' Else btnCancel.Caption := '&Close';
end;

{----------------------------------------}

procedure TfrmGLDetail.btnSaveClick(Sender: TObject);
Var
  FuncRes : LongInt;
begin
  With FGLDetail Do Begin
    // Copy detail into GLDetail Interface
    glCode := StrToInt(edtGlCode.Text);
    glAltCode := Trim(edtAltCode.Text);
    glName := Trim(edtGLName.Text);
    glType := lstGLType.ItemIndex;

    // Save Account
    FuncRes := FGLDetail.Save;
    If (FuncRes = 0) Then Begin
      // Close dialog
      FNeedRefresh := True;
      Close;
    End { If (FuncRes = 0) }
    Else
      // Error saving account details
      MessageDlg ('The following error occured saving the GL Code:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                  mtError, [mbOk], 0);
  End; { With FGLDetail }
end;

{----------------------------------------}

procedure TfrmGLDetail.btnCancelClick(Sender: TObject);
begin
  Case FMode Of
    mdAdd  : ; { No Action Required }
    mdEdit : FGLDetail.Cancel;
    mdView : ; { No Action Required }
  Else
    ShowMessage ('Unknown Mode');
  End;

  FNeedRefresh := False;
  Close;
end;

{----------------------------------------}

end.

unit FDRepTag;

interface

uses
  {$IFDEF Win32} Windows, {$ELSE} WinTypes, WinProcs, {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, Buttons, ExtCtrls;

type
  TReplacementTagsForm = class(TForm)
    MiscellaneousGroupBox: TGroupBox;
    AddressingGroupBox: TGroupBox;
    SenderEdit: TEdit;
    RecipientEdit: TEdit;
    PageTitleEdit: TEdit;
    StationIDEdit: TEdit;
    PageNumberingGroupBox: TGroupBox;
    PageNumberEdit: TMaskEdit;
    PageCountEdit: TMaskEdit;
    Label1: TLabel;
    OKBtn: TButton;
    procedure FieldChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    rfDataChanged     : Boolean;
    function Validate : Boolean;
  public
  end;


implementation

uses
  FDUtils;

{$R *.DFM}

procedure TReplacementTagsForm.FormShow(Sender: TObject);
begin
  rfDataChanged := False;
end;

procedure TReplacementTagsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TReplacementTagsForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := not rfDataChanged or
              (MessageDlg('Are you sure you want to abandon your changes?',
                          mtConfirmation, [mbYes, mbNo], 0) = mrYes);
end;

procedure TReplacementTagsForm.FieldChange(Sender: TObject);
begin
  rfDataChanged := True;
end;

function TReplacementTagsForm.Validate : Boolean;

  procedure ShowError(Edit : TCustomEdit; const ErrMsg : string);
  begin
    MessageDlg(ErrMsg, mtError, [mbOK], 0);
    with Edit do begin
      SetFocus;
      SelStart  := 0;
      SelLength := 255;
    end;
  end;

var
  I : Integer;
begin
  Result := True;

  I := 0;  {Just to get rid of a spurious compiler warning}
  try
    I := StrToInt(Trim(PageNumberEdit.EditText));
  except
    on EConvertError do
      Result := False;
  end;
  if not Result or (I <= 0) then begin
    ShowError(PageNumberEdit, 'Invalid page number entered.');
    Exit;
  end;

  try
    I := StrToInt(Trim(PageCountEdit.EditText));
  except
    on EConvertError do
      Result := False;
  end;
  if not Result or (I <= 0) then
    ShowError(PageCountEdit, 'Invalid page count entered.');
end;

procedure TReplacementTagsForm.OKBtnClick(Sender: TObject);

begin
  if Validate then begin
    rfDataChanged := False;
    ModalResult   := mrOK;
  end else
    ModalResult := mrNone;
end;

end.

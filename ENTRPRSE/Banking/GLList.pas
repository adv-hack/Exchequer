unit GLList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Enterprise04_TLB, StdCtrls, TCustom, uExDatasets, uComTKDataset,
  ExtCtrls, uMultiList, uDBMultiList, uSettings, Menus;

type
  TfrmGLList = class(TForm)
    ctkGL: TComTKDataset;
    dmlGLCodes: TDBMultiList;
    pnlButtons: TPanel;
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    PopupMenu1: TPopupMenu;
    Properties1: TMenuItem;
    N1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    procedure ctkGLGetFieldValue(Sender: TObject; ID: IDispatch;
      FieldName: String; var FieldValue: String);
    procedure FormCreate(Sender: TObject);
    procedure dmlGLCodesRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Properties1Click(Sender: TObject);
    procedure ctkGLFilterRecord(Sender: TObject; ID: IDispatch;
      var Include: Boolean);
  private
    { Private declarations }
    bRestore : Boolean;
    InitSize : TPoint;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
  public
    { Public declarations }
    BankAcsOnly : Boolean;
    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;
  end;

var
  frmGLList: TfrmGLList;

implementation

{$R *.dfm}


procedure TfrmGLList.ctkGLGetFieldValue(Sender: TObject; ID: IDispatch;
  FieldName: String; var FieldValue: String);
begin
  with ID as IGeneralLedger do
  begin
    Case FieldName[1] of
      'C'  : FieldValue := IntToStr(glCode);
      'D'  : FieldValue := Trim(glName);
    end; //Case
  end;
end;

procedure TfrmGLList.FormCreate(Sender: TObject);
begin
  Width := 308;
  Height := 273;
  bRestore := False;
  LoadAllSettings;
  InitSize.X := Width;
  InitSize.Y := Height;
end;

procedure TfrmGLList.dmlGLCodesRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnOK.Click;
end;

procedure TfrmGLList.FormResize(Sender: TObject);
begin
  pnlButtons.Top := ClientHeight - pnlButtons.Height - 1;
  pnlButtons.Left := (ClientWidth div 2) - (pnlButtons.Width div 2);

  dmlGLCodes.Width := ClientWidth;
  dmlGLCodes.Height := pnlButtons.Top - 2;
end;

procedure TfrmGLList.WMSysCommand(var Message: TMessage);
begin
  With Message do
    Case WParam of

      SC_Maximize  :  Begin
                        Self.Height:=InitSize.Y;
                        Self.Width:=InitSize.X;

                       { Self.ClientHeight:=InitSize.Y;
                        Self.ClientWidth:=InitSize.X;}

                        WParam:=0;
                      end;

    end; {Case..}

  Inherited;
end;

procedure TfrmGLList.LoadAllSettings;
begin
  oSettings.LoadForm(Self);
  oSettings.LoadList(dmlGLCodes, Self.Name);
end;

procedure TfrmGLList.SaveAllSettings;
begin
  oSettings.SaveList(dmlGLCodes, Self.Name);
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
end;

procedure TfrmGLList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
end;

procedure TfrmGLList.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(dmlGLCodes, Self.Name, nil) of
{    mrOK : oSettings.ColorFieldsFrom(cmbCompany, Self);}
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      oSettings.RestoreListDefaults(dmlGLCodes, Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TfrmGLList.ctkGLFilterRecord(Sender: TObject; ID: IDispatch;
  var Include: Boolean);
begin
  with ID as IGeneralLedger2 do
  begin
    Include := glType in [glTypeProfitLoss, glTypeBalanceSheet];
    if BankAcsOnly then
      Include := Include and (glClass = glcBankAccount);
  end;
end;

end.

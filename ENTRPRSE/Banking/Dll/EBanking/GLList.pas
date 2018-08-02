unit GLList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Enterprise01_TLB, StdCtrls, TCustom, uExDatasets, uComTKDataset,
  ExtCtrls, uMultiList, uDBMultiList;

type
  TfrmGLList = class(TForm)
    ctkGL: TComTKDataset;
    dmlGLCodes: TDBMultiList;
    pnlButtons: TPanel;
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    procedure ctkGLGetFieldValue(Sender: TObject; ID: IDispatch;
      FieldName: String; var FieldValue: String);
    procedure FormCreate(Sender: TObject);
    procedure dmlGLCodesRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
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
                        {Self.Height:=InitSize.Y;
                        Self.Width:=InitSize.X;}

                       { Self.ClientHeight:=InitSize.Y;
                        Self.ClientWidth:=InitSize.X;}

                        WParam:=0;
                      end;

    end; {Case..}

  Inherited;
end;

end.

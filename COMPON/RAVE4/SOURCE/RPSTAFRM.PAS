{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPStaFrm;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, RPSystem, RPDefine;

type
  TRPStatusForm = class(TForm)
    CancelButton: TButton;
    StatusLabel: TLabel;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
    ReportSystem: TReportSystem;
    FormClosed: boolean;
  end;

var
  RPStatusForm: TRPStatusForm;

implementation
{$R *.DFM}

procedure TRPStatusForm.CancelButtonClick(Sender: TObject);
begin
  With Sender as TButton do begin
    If ModalResult = mrCancel then begin
      ReportSystem.BaseReport.Abort;
    end else begin
      FormClosed := true;
    end; { if }
  end; { with }
end;

procedure TRPStatusForm.FormCreate(Sender: TObject);
begin
{$IFDEF DESIGNER}
  FormTrans(self);
{$ENDIF}
end;

end.
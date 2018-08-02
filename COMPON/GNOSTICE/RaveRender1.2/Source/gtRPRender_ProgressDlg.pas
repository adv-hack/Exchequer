{***************************************************************************}
{                                                                           }
{  Gnostice RaveRender                                                      }
{                                                                           }
{  Copyright © 2000-2003 Gnostice Information Technologies Private Limited  }
{  http://www.gnostice.com                                                  }
{                                                                           }
{***************************************************************************}

{$I gtDefines.Inc}
{$I gtRPDefines.Inc}

unit gtRPRender_ProgressDlg;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls, ComCtrls, Buttons, gtRPRender_Main;

type

{ TgtRPRenderProgressDlg class }

	TgtRPRenderProgressDlg = class(TForm)
		ProgressBar: TProgressBar;
		lblCurrentPage: TLabel;
    btnCancel: TBitBtn;
		procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
	private
		FPageCount,
		FCurrentPageNo: Integer;
		FRenderObject: TgtRPRender;
		procedure SetPageCount(Value: Integer);
		procedure SetCurrentPageNo(Value: Integer);
		procedure UpdateProgressLabel;

	protected
		procedure Localize;

	public
		property CurrentPageNo: Integer read FCurrentPageNo write SetCurrentPageNo;
		property Pagecount: Integer read FPageCount write SetPageCount;
		property RenderObject: TgtRPRender read FRenderObject write FRenderObject;

	end;

var
	gtRPRenderProgressDlg: TgtRPRenderProgressDlg;

implementation

uses gtRPRender_DlgConsts;

{$R *.DFM}
{------------------------------------------------------------------------------}
{ TgtRPRenderProgressDlg }
{------------------------------------------------------------------------------}

procedure TgtRPRenderProgressDlg.Localize;
begin
	Caption := sProgressDialogCaption;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderProgressDlg.SetCurrentPageNo(Value: Integer);
begin
	FCurrentPageNo := Value;
	UpdateProgressLabel;
	ProgressBar.Position := Value;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderProgressDlg.SetPageCount(Value: Integer);
begin
	FPageCount := Value;
	UpdateProgressLabel;
	ProgressBar.Max := Value;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderProgressDlg.FormCreate(Sender: TObject);
begin
	Localize;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderProgressDlg.UpdateProgressLabel;
begin
	lblCurrentPage.Caption := Format(slblCurrentPageCaption,
		[FCurrentPageNo, FPageCount]);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderProgressDlg.btnCancelClick(Sender: TObject);
begin
	RenderObject.CancelExport;
end;

{------------------------------------------------------------------------------}

end.

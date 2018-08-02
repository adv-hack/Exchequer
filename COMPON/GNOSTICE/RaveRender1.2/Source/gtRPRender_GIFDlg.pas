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

unit gtRPRender_GIFDlg;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	gtRPRender_MainDlg, ExtDlgs, StdCtrls, ExtCtrls, Buttons, ComCtrls,
	gtRPRender_Main, gtRPRender_GIF, gtRPRender_Utils;

type

{ TgtRPRenderGIFDlg class }

	TgtRPRenderGIFDlg = class(TgtRPRenderMainDlg)
		tsGIFQuality: TTabSheet;
		gbGIFOptions: TGroupBox;
		chkMonochrome: TCheckBox;
		lblScaleX: TLabel;
		edScaleX: TEdit;
		lblScaleY: TLabel;
		edScaleY: TEdit;

		procedure FormCreate(Sender: TObject);
		procedure FormShow(Sender: TObject);
		procedure btnOKClick(Sender: TObject);

	protected
		procedure Localize; override;

	end;

implementation

uses gtRPRender_DlgConsts, gtRPRender_Consts;

{$R *.DFM}

{------------------------------------------------------------------------------}
{ TgtRPRenderGIFDlg }
{------------------------------------------------------------------------------}

procedure TgtRPRenderGIFDlg.FormCreate(Sender: TObject);
begin
	inherited FormCreate(Sender);
	Localize;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderGIFDlg.FormShow(Sender: TObject);
begin
	with RenderObject as TgtRPRenderGIF do
	begin
		chkMonochrome.Checked := Monochrome;
		edScaleX.Text := FloatToStr(ScaleX);
		edScaleY.Text := FloatToStr(ScaleY);
	end;
	inherited FormShow(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderGIFDlg.btnOKClick(Sender: TObject);
begin
	with RenderObject as TgtRPRenderGIF do
	begin
		Monochrome := chkMonochrome.Checked;
		ScaleX := StrToFloat(edScaleX.Text);
		ScaleY := StrToFloat(edScaleY.Text);
	end;
	inherited btnOKClick(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderGIFDlg.Localize;
begin
	inherited Localize;
	Caption := SGIFDialogCaption;
	tsGIFQuality.Caption := StsQualityCaption;
	chkMonochrome.Caption := SchkMonochromeCaption;
	lblScaleX.Caption := SlblScaleXCaption;
	lblScaleY.Caption := SlblScaleYCaption;

	// Set control width after setting text
	chkMonochrome.Width := (GetTextSize(Font,
		SchkMonochromeCaption).cx + CMinWidth);
end;

{------------------------------------------------------------------------------}

end.

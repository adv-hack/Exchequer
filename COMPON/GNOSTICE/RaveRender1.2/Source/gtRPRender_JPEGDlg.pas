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

unit gtRPRender_JPEGDlg;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	gtRPRender_MainDlg, ExtDlgs, StdCtrls, ExtCtrls, Buttons, ComCtrls,
	gtRPRender_Main, gtRPRender_JPEG;

type

{ TgtRPRenderJPEGDlg class }

	TgtRPRenderJPEGDlg = class(TgtRPRenderMainDlg)
		tsQuality: TTabSheet;
		gbJPEG: TGroupBox;
		lblQuality: TLabel;
		lblRange: TLabel;
		lblScaleX: TLabel;
		lblScaleY: TLabel;
		chkGrayscale: TCheckBox;
		chkProgressiveEncoding: TCheckBox;
		edScaleX: TEdit;
		edScaleY: TEdit;
		edQuality: TEdit;

		procedure FormCreate(Sender: TObject);
		procedure FormShow(Sender: TObject);
		procedure btnOKClick(Sender: TObject);
		procedure edQualityKeyPress(Sender: TObject; var Key: Char);

	protected
		procedure Localize; override;

	end;

implementation

uses gtRPRender_Consts, gtRPRender_Utils, gtRPRender_DlgConsts;

{$R *.DFM}

{------------------------------------------------------------------------------}
{ TgtRPRenderJPEGDlg }
{------------------------------------------------------------------------------}

procedure TgtRPRenderJPEGDlg.FormCreate(Sender: TObject);
begin
	inherited;
	Localize;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderJPEGDlg.FormShow(Sender: TObject);
begin
	with RenderObject as TgtRPRenderJPEG do
	begin
		chkGrayscale.Checked := Grayscale;
		chkProgressiveEncoding.Checked := ProgressiveEncoding;
		edQuality.Text := IntToStr(Quality);
		edScaleX.Text := FloatToStr(ScaleX);
		edScaleY.Text := FloatToStr(ScaleY);
	end;
	inherited FormShow(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderJPEGDlg.btnOKClick(Sender: TObject);
begin
	with RenderObject as TgtRPRenderJPEG do
	begin
		Grayscale := chkGrayscale.Checked;
		ProgressiveEncoding := chkProgressiveEncoding.Checked;
		Quality := StrToInt(edQuality.Text);
		ScaleX :=  StrToFloat(edScaleX.Text);
		ScaleY :=  StrToFloat(edScaleY.Text);
	end;
	inherited btnOKClick(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderJPEGDlg.edQualityKeyPress(Sender: TObject;	var Key: Char);
begin
	if not(Key in ['0'..'9', #8]) then
		Key := #0;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderJPEGDlg.Localize;
begin
	inherited Localize;
	Caption := SJPEGDialogCaption;
	tsQuality.Caption := StsQualityCaption;
	chkGrayscale.Caption := SchkGrayScaleCaption;
	chkProgressiveEncoding.Caption := SchkProgressiveEncodingCaption;
	lblQuality.Caption := SlblQualityCaption;
	lblRange.Caption := SlblRangeCaption;
	lblScaleX.Caption := SlblScaleXCaption;
	lblScaleY.Caption := SlblScaleYCaption;

	// Set control width after setting text
	chkGrayscale.Width := (GetTextSize(Font,
		SchkGrayScaleCaption).cx + CMinWidth);
	chkProgressiveEncoding.Width := (GetTextSize(Font,
		SchkProgressiveEncodingCaption).cx + CMinWidth);
end;

{------------------------------------------------------------------------------}

end.

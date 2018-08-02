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

unit gtRPRender_BMPDlg;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	gtRPRender_MainDlg, ExtDlgs, StdCtrls, ExtCtrls, Buttons, ComCtrls,
	gtRPRender_Main, gtRPRender_BMP;

type

{ TgtRPRenderBMPDlg class }

	TgtRPRenderBMPDlg = class(TgtRPRenderMainDlg)
    tsBMPQuality: TTabSheet;
    gbBMPOptions: TGroupBox;
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

uses gtRPRender_DlgConsts;

{$R *.DFM}

{------------------------------------------------------------------------------}
{ TgtRPRenderBMPDlg }
{------------------------------------------------------------------------------}

procedure TgtRPRenderBMPDlg.FormCreate(Sender: TObject);
begin
	inherited FormCreate(Sender);
	Localize;
	btnClear.Enabled := False;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderBMPDlg.FormShow(Sender: TObject);
begin
	with RenderObject as TgtRPRenderBMP do
	begin
		chkMonochrome.Checked := Monochrome;
		edScaleX.Text := FloatToStr(ScaleX);
		edScaleY.Text := FloatToStr(ScaleY);
	end;
	inherited FormShow(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderBMPDlg.btnOKClick(Sender: TObject);
begin
	with RenderObject as TgtRPRenderBMP do
	begin
		Monochrome := chkMonochrome.Checked;
		ScaleX := StrToFloat(edScaleX.Text);
		ScaleY := StrToFloat(edScaleY.Text);
	end;
	inherited btnOKClick(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderBMPDlg.Localize;
begin
	inherited Localize;
	Caption := SBMPDialogCaption;
	tsBMPQuality.Caption := StsQualityCaption;
	chkMonochrome.Caption := SchkMonochromeCaption;
	lblScaleX.Caption := SlblScaleXCaption;
	lblScaleY.Caption := SlblScaleYCaption;
end;

{------------------------------------------------------------------------------}

end.

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

unit gtRPRender_MetafileDlg;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	gtRPRender_MainDlg, ExtDlgs, StdCtrls, ExtCtrls, Buttons, ComCtrls,
	gtRPRender_Main, gtRPRender_Graphic, gtRPRender_EMF, gtRPRender_WMF;

type

{ TgtRPRenderMetafileDlg class }

	TgtRPRenderMetafileDlg = class(TgtRPRenderMainDlg)
		tsMetafileScaling: TTabSheet;
		gbMetafileOptions: TGroupBox;
		lblScaleX: TLabel;
		lblScaleY: TLabel;
		edScaleX: TEdit;
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
{ TgtRPRenderMetafileDlg }
{------------------------------------------------------------------------------}

procedure TgtRPRenderMetafileDlg.FormCreate(Sender: TObject);
begin
	inherited FormCreate(Sender);
	Localize;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderMetafileDlg.FormShow(Sender: TObject);
begin
	with RenderObject as TgtRPRenderGraphic do
	begin
		edScaleX.Text := FloatToStr(ScaleX);
		edScaleY.Text := FloatToStr(ScaleY);
	end;
	inherited FormShow(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderMetafileDlg.btnOKClick(Sender: TObject);
begin
	with RenderObject as TgtRPRenderGraphic do
	begin
		ScaleX := StrToFloat(edScaleX.Text);
		ScaleY := StrToFloat(edScaleY.Text);
	end;
	inherited btnOKClick(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderMetafileDlg.Localize;
begin
	inherited Localize;
	Caption := SMetaFileDialogCaption;
	tsMetafileScaling.Caption := StsMetafileScalingCaption;
	lblScaleX.Caption := SlblScaleXCaption;
	lblScaleY.Caption := SlblScaleYCaption;
end;

{------------------------------------------------------------------------------}

end.

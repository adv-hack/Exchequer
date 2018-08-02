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

unit gtRPRender_HTMLDlg;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	gtRPRender_MainDlg, gtRPRender_DocumentDlg, ExtDlgs, StdCtrls, ExtCtrls,
	Buttons, ComCtrls, FileCtrl, gtRPRender_Main;

type

{ TgtRPRenderHTMLDlg class }

	TgtRPRenderHTMLDlg = class(TgtRPRenderDocumentDlg)
    tsNavigatorOptions: TTabSheet;
		gbShowNavigator: TGroupBox;
    chkShowNavigator: TCheckBox;
		lblNavigatorBackgroundColor: TLabel;
		lblHoverForeColor: TLabel;
    lblHoverBackColor: TLabel;
    shpNavigatorBackgroundColor: TShape;
		shpHoverForeColor: TShape;
		shpHoverBackColor: TShape;
		gbUseLinks: TGroupBox;
		pcShowNavigator: TPageControl;
		tsUseTextLinks: TTabSheet;
		lblFirst: TLabel;
		lblLast: TLabel;
		lblNext: TLabel;
		lblPrevious: TLabel;
		lblLinkCaptions: TLabel;
		btnSetFont: TButton;
		edFirst: TEdit;
		edPrevious: TEdit;
		edNext: TEdit;
		edLast: TEdit;
		tsUseGraphicLinks: TTabSheet;
		lblUseGraphicLinksFirst: TLabel;
		lblUseGraphicLinksPrevious: TLabel;
		lblUseGraphicLinksNext: TLabel;
		lblUseGraphicLinksLast: TLabel;
		btnFirst: TSpeedButton;
		btnPrevious: TSpeedButton;
		btnNext: TSpeedButton;
		btnLast: TSpeedButton;
		lblImageSource: TLabel;
		edUseGraphicLinksFirst: TEdit;
		edUseGraphicLinksPrevious: TEdit;
		edUseGraphicLinksLast: TEdit;
		edUseGraphicLinksNext: TEdit;
		rbtnUseTextLinks: TRadioButton;
		rbtnUseGraphicLinks: TRadioButton;
    FontDialog: TFontDialog;
    tsOptimization: TTabSheet;
		gbOthers: TGroupBox;
    chkOptimizeforIE: TCheckBox;
		gbExtCSSFile: TGroupBox;
		chkOutputStylestoCSSFile: TCheckBox;
		lblCSSFile: TLabel;
		edCSSFile: TEdit;
		btnCSSFileName: TSpeedButton;
		OpenDialog: TOpenDialog;
		chkPageEndLines: TCheckBox;
		lblDefaultFont: TLabel;
		btnSetDefaultFont: TSpeedButton;
		lblImageFolder: TLabel;
		edImageDirectory: TEdit;
		btnImages: TSpeedButton;
		chkSeparateFilePerPage: TCheckBox;
		pnlDefaultFont: TPanel;
		lblNavigatorType: TLabel;
		cbNavigatorType: TComboBox;

		procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
		procedure FormShow(Sender: TObject);
		procedure btnOKClick(Sender: TObject);
		procedure chkOptimizeforIEClick(Sender: TObject);
		procedure chkOutputStylestoCSSFileClick(Sender: TObject);
		procedure btnCSSFileNameClick(Sender: TObject);
		procedure btnImagesClick(Sender: TObject);
		procedure btnSetDefaultFontClick(Sender: TObject);
		procedure chkSeparateFilePerPageClick(Sender: TObject);
		procedure chkShowNavigatorClick(Sender: TObject);
		procedure rbtnUseTextLinksClick(Sender: TObject);
		procedure btnSetFontClick(Sender: TObject);
		procedure btnImageSourceClick(Sender: TObject);

	private
		ALinkFont: TFont;

	protected
		procedure Localize; override;

	end;

implementation

uses gtRPRender_Utils, gtRPRender_HTML, gtRPRender_DlgConsts;

const

	NavigatorTypes: array[TgtRPNavigatorType] of string = (
		SNTFixedToScreen, SNTFixedToPage);

{$R *.DFM}

{------------------------------------------------------------------------------}
{ TgtRPRenderHTMLDlg }
{------------------------------------------------------------------------------}

procedure TgtRPRenderHTMLDlg.FormCreate(Sender: TObject);
var
	I: TgtRPNavigatorType;
begin
	inherited FormCreate(Sender);
	Localize;
	ALinkFont := TFont.Create;
	pcShowNavigator.ActivePage := tsUseTextLinks;
	cbExportImageFormatChange(Sender);
	for I := Low(TgtRPNavigatorType) to High(TgtRPNavigatorType) do
		cbNavigatorType.Items.AddObject(NavigatorTypes[I], TObject(I));
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTMLDlg.FormDestroy(Sender: TObject);
begin
	ALinkFont.Free;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTMLDlg.FormShow(Sender: TObject);
begin
	with RenderObject as TgtRPRenderHTML do
	begin
		chkSeparateFilePerPage.Checked := SeparateFilePerPage;
		chkShowNavigator.Checked := ShowNavigator;

		shpHoverForeColor.Brush.Color := LinkHoverForeColor;
		shpHoverBackColor.Brush.Color := LinkHoverBackColor;
		shpNavigatorBackgroundColor.Brush.Color := LinkBackColor;

		rbtnUseTextLinks.Checked := UseTextLinks;
		rbtnUseGraphicLinks.Checked := not UseTextLinks;

		edFirst.Text := LinkTextFirst;
		edPrevious.Text := LinkTextPrev;
		edNext.Text := LinkTextNext;
		edLast.Text := LinkTextLast;

		edUseGraphicLinksFirst.Text := LinkImgSRCFirst;
		edUseGraphicLinksPrevious.Text := LinkImgSRCPrev;
		edUseGraphicLinksNext.Text := LinkImgSRCNext;
		edUseGraphicLinksLast.Text := LinkImgSRCLast;

		ALinkFont.Assign(LinkFont);

		edFirst.Font.Name := ALinkFont.Name;
		edFirst.Font.Color := ALinkFont.Color;
		edPrevious.Font.Name := ALinkFont.Name;
		edPrevious.Font.Color := ALinkFont.Color;
		edNext.Font.Name := ALinkFont.Name;
		edNext.Font.Color := ALinkFont.Color;
		edLast.Font.Name := ALinkFont.Name;
		edLast.Font.Color := ALinkFont.Color;

		edImageDirectory.Text := ImageFolder;

		edCSSFile.Text := CSSFileName;
		chkOptimizeforIE.Checked := OptimizeForIE;
		chkPageEndLines.Checked := PageEndLines;
		pnlDefaultFont.Font := DefaultFont;
		cbNavigatorType.ItemIndex := cbNavigatorType.Items.IndexOfObject(
			TObject(Ord(NavigatorType)));
	end;
	chkIncludeImagesClick(Sender);
	chkSeparateFilePerPageClick(Sender);
	inherited FormShow(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTMLDlg.btnOKClick(Sender: TObject);
begin
	with RenderObject as TgtRPRenderHTML do
	begin
		SeparateFilePerPage := chkSeparateFilePerPage.Checked;
		ShowNavigator := chkShowNavigator.Checked;

		LinkHoverForeColor := shpHoverForeColor.Brush.Color;
		LinkHoverBackColor := shpHoverBackColor.Brush.Color;
		LinkBackColor := shpNavigatorBackgroundColor.Brush.Color;

		LinkTextFirst := edFirst.Text;
		LinkTextPrev := edPrevious.Text;
		LinkTextNext := edNext.Text;
		LinkTextLast := edLast.Text;

		UseTextLinks := rbtnUseTextLinks.Checked;
		LinkImgSRCFirst := edUseGraphicLinksFirst.Text;
		LinkImgSRCPrev := edUseGraphicLinksPrevious.Text;
		LinkImgSRCNext := edUseGraphicLinksNext.Text;
		LinkImgSRCLast := edUseGraphicLinksLast.Text;

		LinkFont.Assign(ALinkFont);

		ImageFolder := edImageDirectory.Text;

		OptimizeForIE := chkOptimizeforIE.Checked;
		PageEndLines := chkPageEndLines.Checked;
		OutputStylesToCSSFile := chkOutputStylestoCSSFile.Checked;
		CSSFileName := edCSSFile.Text;
		DefaultFont.Assign(pnlDefaultFont.Font);

		NavigatorType := TgtRPNavigatorType
			(cbNavigatorType.Items.Objects[cbNavigatorType.ItemIndex]);
	end;
	inherited btnOKClick(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTMLDlg.chkOptimizeforIEClick(Sender: TObject);
begin
	chkOutputStylestoCSSFile.Enabled := chkOptimizeforIE.Checked;
	chkOutputStylestoCSSFileClick(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTMLDlg.chkOutputStylestoCSSFileClick(Sender: TObject);
begin
	SetControlsEnabled(gbExtCSSFile, ((chkOutputStylestoCSSFile.Enabled)and
		(chkOutputStylestoCSSFile.Checked)));
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTMLDlg.btnCSSFileNameClick(Sender: TObject);
begin
	if OpenDialog.Execute then
		edCSSFile.Text := OpenDialog.FileName;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTMLDlg.btnImagesClick(Sender: TObject);
var
	S: string;
begin
	if SelectDirectory('', S, S) then
		edImageDirectory.Text := S;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTMLDlg.btnSetDefaultFontClick(Sender: TObject);
begin
	with FontDialog do
	begin
		Font := pnlDefaultFont.Font;
		if Execute then
			pnlDefaultFont.Font.Assign(FontDialog.Font);
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTMLDlg.chkSeparateFilePerPageClick(Sender: TObject);
begin
	chkShowNavigator.Enabled := chkSeparateFilePerPage.Checked;
	chkPageEndLines.Enabled := not chkSeparateFilePerPage.Checked;
	chkShowNavigatorClick(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTMLDlg.chkShowNavigatorClick(Sender: TObject);
begin
	SetControlsEnabled(gbShowNavigator, (chkShowNavigator.Checked and
		chkShowNavigator.Enabled));
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTMLDlg.rbtnUseTextLinksClick(Sender: TObject);
begin
	pcShowNavigator.ActivePage := pcShowNavigator.Pages[
		(Sender as TRadioButton).Tag];
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTMLDlg.btnSetFontClick(Sender: TObject);
begin
	FontDialog.Font.Assign(ALinkFont);
	if FontDialog.Execute then
	begin
		edFirst.Font.Name := FontDialog.Font.Name;
		edFirst.Font.Color := FontDialog.Font.Color;
		edFirst.Font.Style := FontDialog.Font.Style;
		edPrevious.Font.Name := FontDialog.Font.Name;
		edPrevious.Font.Color := FontDialog.Font.Color;
		edPrevious.Font.Style := FontDialog.Font.Style;
		edNext.Font.Name := FontDialog.Font.Name;
		edNext.Font.Color := FontDialog.Font.Color;
		edNext.Font.Style := FontDialog.Font.Style;
		edLast.Font.Name := FontDialog.Font.Name;
		edLast.Font.Color := FontDialog.Font.Color;
		edLast.Font.Style := FontDialog.Font.Style;
		ALinkFont.Assign(FontDialog.Font);
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTMLDlg.btnImageSourceClick(Sender: TObject);
begin
	if OpenPictureDialog.Execute then
	begin
		if (Sender = btnFirst) then
			edUseGraphicLinksFirst.Text := OpenPictureDialog.FileName
		else if (Sender = btnPrevious) then
			edUseGraphicLinksPrevious.Text := OpenPictureDialog.FileName
		else if (Sender = btnNext) then
			edUseGraphicLinksNext.Text := OpenPictureDialog.FileName
		else if (Sender = btnLast) then
			edUseGraphicLinksLast.Text := OpenPictureDialog.FileName;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderHTMLDlg.Localize;
begin
	inherited Localize;
	Caption := SHTMLDialogCaption;
	tsOptimization.Caption := StsOptimizationCaption;
	chkOptimizeforIE.Caption := SchkOptimizeforIECaption;
	chkPageEndLines.Caption	:= SchkPageEndLinesCaption;
	chkOutputStylesToCSSFile.Caption := SchkOutputStylesToCSSFileCaption;
	lblCSSFile.Caption := SlblCSSFileCaption;
	lblImageFolder.Caption := SlblImageFolderCaption;
	lblDefaultFont.Caption := SlblDefaultFontCaption;

	tsNavigatorOptions.Caption := 	StsNavigatorOptionsCaption;
	chkSeparateFilePerPage.Caption := SchkSeparateFilePerPageCaption;
	chkShowNavigator.Caption := 	SchkShowNavigatorCaption;
	lblHoverForeColor.Caption := SlblHoverForeColorCaption;
	lblHoverBackColor.Caption	:= SlblHoverBackColorCaption;
	lblNavigatorBackgroundColor.Caption := SlblNavigatorBackgroundCaption;
	rbtnUseTextLinks.Caption := SrbtnUseTextLinksCaption;
	rbtnUseGraphicLinks.Caption := SrbtnUseGraphicLinksCaption;
	btnSetFont.Caption :=	SbtnSetFontCaption;
	lblFirst.Caption := SlblFirstCaption;
	lblPrevious.Caption := SlblPreviousCaption;
	lblNext.Caption := SlblNextCaption;
	lblLast.Caption := SlblLastCaption;
	lblImageSource.Caption := SlblImageSourceCaption;
	lblLinkCaptions.Caption := SlblLinkCaptionsCaption;
	pnlDefaultFont.Caption := SpnlDefaultFontCaption;
	lblNavigatorType.Caption := SlblNavigatorTypeCaption;

	shpNavigatorBackgroundColor.Hint := SColorBoxHintPrefix +
		lblNavigatorBackgroundColor.Caption;
	shpHoverBackColor.Hint := SColorBoxHintPrefix +
		lblHoverBackColor.Caption;
	shpHoverForeColor.Hint := SColorBoxHintPrefix +
		lblHoverForeColor.Caption;

	// Set control width after setting text.
	chkSeparateFilePerPage.Width := (GetTextSize(Font,
		SchkSeparateFilePerPageCaption).cx + CMinWidth);
	chkPageEndLines.Width := (GetTextSize(Font,
		SchkPageEndLinesCaption).cx + CMinWidth);
	chkOptimizeforIE.Width := (GetTextSize(Font,
		SchkOptimizeforIECaption).cx + CMinWidth);
	chkOutputStylestoCSSFile.Width := (GetTextSize(Font,
		SchkOutputStylesToCSSFileCaption).cx + CMinWidth);
	chkShowNavigator.Width := (GetTextSize(Font,
		SchkShowNavigatorCaption).cx + CMinWidth);
	rbtnUseTextLinks.Width := (GetTextSize(Font,
		SrbtnUseTextLinksCaption).cx + CMinWidth);
	rbtnUseGraphicLinks.Width := (GetTextSize(Font,
		SrbtnUseGraphicLinksCaption).cx + CMinWidth);
end;

{------------------------------------------------------------------------------}

end.

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

unit gtRPRender_DocumentDlg;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	ExtDlgs, StdCtrls, ExtCtrls, Buttons, ComCtrls, gtRPRender_Main,
	gtRPRender_Utils, gtRPRender_Document, gtRPRender_MainDlg;

type

{ TgtRPRenderDocumentDlg class }

	TgtRPRenderDocumentDlg = class(TgtRPRenderMainDlg)
    tsContent: TTabSheet;
		gbOptions: TGroupBox;
		chkIncludeLines: TCheckBox;
		chkIncludeNonRectShapes: TCheckBox;
		gbIncludeImages: TGroupBox;
		lblExportImageFormat: TLabel;
		cbExportImageFormat: TComboBox;
		chkIncludeImages: TCheckBox;
		lblJPEGQuality: TLabel;
		edJPEGQuality: TEdit;
		lblAuthor: TLabel;
		edAuthor: TEdit;
		edKeyWord: TEdit;
		lblKeywords: TLabel;
    lblImageDPI: TLabel;
    edImageDPI: TEdit;
    lblTitle: TLabel;
    lblSubject: TLabel;
    edSubject: TEdit;
    edTitle: TEdit;
    lblImagePixelFormat: TLabel;
    cbImagePixelFormat: TComboBox;
		procedure FormCreate(Sender: TObject);
		procedure FormShow(Sender: TObject);
		procedure btnOKClick(Sender: TObject);
		procedure chkIncludeImagesClick(Sender: TObject);
		procedure cbExportImageFormatChange(Sender: TObject);
		procedure edJPEGQualityKeyPress(Sender: TObject; var Key: Char);

	protected
		procedure Localize; override;

	end;

	THackgtRPRenderDocument = class(TgtRPRenderDocument);

implementation

uses gtRPRender_DlgConsts, gtRPRender_Consts;

const

	ImageFormats: array[TgtRPImageFormat] of string = (sImageFormatGIF,
		sImageFormatJPEG, sImageFormatBMP);


{$R *.DFM}

{------------------------------------------------------------------------------}
{ TgtRPRenderDocumentDlg }
{------------------------------------------------------------------------------}

procedure TgtRPRenderDocumentDlg.FormCreate(Sender: TObject);
var
	I: TgtRPImageFormat;
	J: TPixelFormat;
begin
	inherited FormCreate(Sender);
	Localize;
	cbExportImageFormat.Items.Clear;

	for I := Low(TgtRPImageFormat) to High(TgtRPImageFormat) do
		cbExportImageFormat.Items.AddObject(Imageformats[I], TObject(I));

	for J := Low(TPixelFormat) to High(TPixelFormat) do
		cbImagePixelFormat.Items.AddObject(PixelFormats[J], TObject(J));
	cbExportImageFormatChange(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocumentDlg.FormShow(Sender: TObject);
var
	AUserName: array [0..255] of char;
	Size: DWord;
begin
	with THackgtRPRenderDocument(RenderObject)  do
	begin
		chkIncludeLines.Checked := IncludeLines;
		chkIncludeImages.Checked := IncludeImages;
		chkIncludeNonRectShapes.Checked := IncludeNonRectShapes;

		cbExportImageFormat.ItemIndex := cbExportImageFormat.Items.IndexOfObject(
			TObject(Ord(ExportImageFormat)));
		edJPEGQuality.Text := IntToStr(JPEGQuality);
		edImageDPI.Text := IntToStr(ImageDPI);
		cbImagePixelFormat.ItemIndex := cbImagePixelFormat.Items.
			IndexOfObject(TObject(Ord(ImagePixelFormat)));

		edTitle.Text := Title;
		edSubject.Text := Subject;
		if Author = '' then
		begin
			Size := Sizeof(AUserName);
			GetUserName(AUserName, Size);
			edAuthor.Text := AUserName;
		end
		else
			edAuthor.Text := Author;

		edKeyWord.Text := Keywords;
	end;
	chkIncludeImagesClick(Sender);
	inherited FormShow(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocumentDlg.btnOKClick(Sender: TObject);
begin
	with THackgtRPRenderDocument(RenderObject)  do
	begin
		IncludeLines := chkIncludeLines.Checked;
		IncludeImages := chkIncludeImages.Checked;
		IncludeNonRectShapes := chkIncludeNonRectShapes.Checked;
		ExportImageFormat := TgtRPImageFormat
			(cbExportImageFormat.Items.Objects[cbExportImageFormat.ItemIndex]);
		JPEGQuality := StrToInt(edJPEGQuality.Text);
		ImageDPI := StrToInt(edImageDPI.Text);
		ImagePixelFormat := TPixelFormat(cbImagePixelFormat.Items.
			Objects[cbImagePixelFormat.ItemIndex]);

		Title := edTitle.Text;
		Subject := edSubject.Text;
		Author := edAuthor.Text;
		Keywords := edKeyWord.Text;
	end;
	inherited btnOKClick(Sender)
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocumentDlg.chkIncludeImagesClick(Sender: TObject);
begin
	SetControlsEnabled(gbIncludeImages, chkIncludeImages.Checked);
	cbExportImageFormatChange(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocumentDlg.cbExportImageFormatChange(Sender: TObject);
begin
	lblJPEGQuality.Enabled := (chkIncludeImages.Checked and
		(cbExportImageFormat.Text = ImageFormats[ifJPG]));
	edJPEGQuality.Enabled := lblJPEGQuality.Enabled;
	edJPEGQuality.Color := EditColor[edJPEGQuality.Enabled];
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocumentDlg.edJPEGQualityKeyPress(Sender: TObject;
	var Key: Char);
begin
	if not(Key in ['0'..'9', #8, '.']) then
		Key := #0;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderDocumentDlg.Localize;
begin
	inherited Localize;
	tsContent.Caption := StsContentCaption;
	chkIncludeLines.Caption := SchkIncludeLinesCaption;
	chkIncludeNonRectShapes.Caption := SchkIncludeNonRectShapesCaption;
	chkIncludeImages.Caption := SchkIncludeImagesCaption;
	lblExportImageFormat.Caption := SlblExportImageFormatCaption;
	lblJPEGQuality.Caption := SlblJPEGQualityCaption;
	lblImageDPI.Caption := SlblImageDPICaption;
	lblTitle.Caption := SlblTitleCaption;
	lblSubject.Caption := SlblSubjectCaption;
	lblImagePixelFormat.Caption := SlblImagePixelFormatCaption;
	lblAuthor.Caption := SlblAuthorCaption;
	lblKeywords.Caption := SlblKeywordsCaption;

	// Set control width after setting text
	chkIncludeLines.Width := (GetTextSize(Font, SchkIncludeLinesCaption).cx +
		CMinWidth);
	chkIncludeNonRectShapes.Width := (GetTextSize(Font,
		SchkIncludeNonRectShapesCaption).cx + CMinWidth);
	chkIncludeImages.Width := (GetTextSize(Font, SchkIncludeImagesCaption).cx +
		CMinWidth);
end;

{------------------------------------------------------------------------------}

end.

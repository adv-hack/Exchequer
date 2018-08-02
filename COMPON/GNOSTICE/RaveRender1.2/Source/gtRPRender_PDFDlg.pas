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

unit gtRPRender_PDFDlg;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	ExtDlgs, StdCtrls, ExtCtrls, Buttons, ComCtrls, gtRPRender_Main,
	gtRPRender_MainDlg, gtRPRender_DocumentDlg, gtRPRender_PDF, gtRPRender_Utils;

type

{ TgtRPRenderPDFDlg class }

	TgtRPRenderPDFDlg = class(TgtRPRenderDocumentDlg)
		tsCompression: TTabSheet;
		gbPDFOptions: TGroupBox;
		gbUseCompression: TGroupBox;
		chkCompressDocument: TCheckBox;
		lblCompressionLevel: TLabel;
		cbCompressionLevel: TComboBox;
		lblFontEncoding: TLabel;
		cbEncoding: TComboBox;

		procedure FormCreate(Sender: TObject);
		procedure FormShow(Sender: TObject);
		procedure btnOKClick(Sender: TObject);
		procedure chkCompressDocumentClick(Sender: TObject);

	protected
		procedure Localize; override;

	end;

implementation

uses gtRPRender_DlgConsts;

const

	CompressionMethods: array[TPDFCompressionMethod] of string = (
		SCompressionMethodFastest, SCompressionMethodNormal,
			SCompressionMethodMaximum);

{$R *.DFM}

{------------------------------------------------------------------------------}
{ TgtRPRenderPDFDlg }
{------------------------------------------------------------------------------}

procedure TgtRPRenderPDFDlg.FormCreate(Sender: TObject);
var
	I: TPDFCompressionMethod;
	J: TPDFFontEncoding;
begin
	inherited FormCreate(Sender);
	Localize;
	cbExportImageFormat.Items.Delete(
		cbExportImageFormat.Items.IndexOfObject(TObject(Ord(ifGIF))));

	for I := Low(TPDFCompressionMethod) to High(TPDFCompressionMethod) do
		cbCompressionLevel.Items.AddObject(CompressionMethods[I], TObject(I));

	for J := Low(TPDFFontEncoding) to High(TPDFFontEncoding) do
		cbEncoding.Items.AddObject(PDFFontEncodeStrings[J], TObject(J));
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDFDlg.FormShow(Sender: TObject);
begin
	with RenderObject as TgtRPRenderPDF do
	begin
		chkCompressDocument.Checked := UseCompression;
		cbCompressionLevel.ItemIndex := cbCompressionLevel.Items.IndexOfObject(
			TObject(Ord(CompressionMethod)));

		cbEncoding.ItemIndex := cbEncoding.Items.IndexOfObject(
			TObject(Ord(Encoding)));
	end;
	chkIncludeImagesClick(Sender);
	chkCompressDocumentClick(Sender);
	inherited FormShow(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDFDlg.btnOKClick(Sender: TObject);
begin
	with RenderObject as TgtRPRenderPDF do
	begin
		UseCompression := chkCompressDocument.Checked;
		CompressionMethod := TPDFCompressionMethod(
			cbCompressionLevel.Items.Objects[cbCompressionlevel.ItemIndex]);

		Encoding := TPDFFontEncoding(cbEncoding.Items.
			Objects[cbEncoding.ItemIndex]);
	end;
	inherited btnOKClick(Sender);
end;
{------------------------------------------------------------------------------}

procedure TgtRPRenderPDFDlg.chkCompressDocumentClick(Sender: TObject);
begin
	SetControlsEnabled(gbUseCompression, chkCompressDocument.Checked);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderPDFDlg.Localize;
begin
	inherited Localize;
	Caption := SPDFDialogCaption;
	tsCompression.Caption := StsCompressionCaption;
	chkCompressDocument.Caption := SchkCompressDocumentCaption;
	lblCompressionLevel.Caption := SlblCompressionlevelCaption;
	lblFontEncoding.Caption := SlblFontEncodingCaption;

	// Set control width after setting text
	chkCompressDocument.Width := (GetTextSize(Font,
		SchkCompressDocumentCaption).cx + CMinWidth);
end;

{------------------------------------------------------------------------------}

end.

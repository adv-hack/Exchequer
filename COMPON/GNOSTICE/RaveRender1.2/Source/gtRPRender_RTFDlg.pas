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

unit gtRPRender_RTFDlg;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	ExtDlgs, StdCtrls, ExtCtrls, Buttons, ComCtrls,	gtRPRender_Main,
	gtRPRender_RTF, gtRPRender_DocumentDlg, gtRPRender_Utils, gtRPRender_MainDlg;

type

{ TgtRPRenderRTFDlg class }

	TgtRPRenderRTFDlg = class(TgtRPRenderDocumentDlg)
		chkGraphicDataInBinary: TCheckBox;
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
{ TgtRPRenderRTFDlg }
{------------------------------------------------------------------------------}

procedure TgtRPRenderRTFDlg.FormCreate(Sender: TObject);
begin
	inherited FormCreate(Sender);
	cbExportImageFormat.Items.Delete(
		cbExportImageFormat.Items.IndexOfObject(TObject(Ord(ifGIF))));
	cbBackgroundDisplayType.Items.Delete(
		cbBackgroundDisplayType.Items.IndexOfObject(TObject(Ord(dtTile))));
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTFDlg.FormShow(Sender: TObject);
begin
	with RenderObject as TgtRPRenderRTF do
		chkGraphicDataInBinary.Checked := GraphicDataInBinary;
	chkIncludeImagesClick(Sender);
	inherited FormShow(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTFDlg.btnOKClick(Sender: TObject);
begin
	with RenderObject as TgtRPRenderRTF do
	begin
		BackgroundImage.Assign(imgBackgroundImage.Picture);
		BackgroundImageDisplayType := TgtRPBackgroundDisplayType
			(cbBackgroundDisplayType.Items.Objects[
		cbBackgroundDisplayType.ItemIndex]);

		IncludeLines := chkIncludeLines.Checked;
		IncludeImages := chkIncludeImages.Checked;
		IncludeNonRectShapes := chkIncludeNonRectShapes.Checked;
		ExportImageFormat := TgtRPImageFormat
			(cbExportImageFormat.Items.Objects[cbExportImageFormat.ItemIndex]);
		JPEGQuality := StrToInt(edJPEGQuality.Text);
		ImageDPI := StrToInt(edImageDPI.Text);
		GraphicDataInBinary := chkGraphicDataInBinary.Checked;

		Author := edAuthor.Text;
		Keywords := edKeyWord.Text;
	end;
	inherited btnOKClick(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderRTFDlg.Localize;
begin
	inherited Localize;
	Caption := sRTFDialogCaption;
	chkGraphicDataInBinary.Caption := schkGraphicDataInBinaryCaption;

	// Set control width after setting text.
	chkGraphicDataInBinary.Width :=  (GetTextSize(Font,
		schkGraphicDataInBinaryCaption).cx + cMinWidth);
end;

{------------------------------------------------------------------------------}

end.

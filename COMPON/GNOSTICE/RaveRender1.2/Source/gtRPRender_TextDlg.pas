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

unit gtRPRender_TextDlg;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	ExtDlgs, StdCtrls, ExtCtrls, Buttons, ComCtrls, gtRPRender_Main,
	gtRPRender_MainDlg, gtRPRender_DocumentDlg, gtRPRender_Text,
	gtRPRender_Utils;

type

{ TgtRPRenderTextDlg class }

	TgtRPRenderTextDlg = class(TgtRPRenderDocumentDlg)
    tsFormatting: TTabSheet;
    gbTextOptions: TGroupBox;
    chkSeparateFilePerPage: TCheckBox;
		chkPageBreaks: TCheckBox;
		lblLineSpacing: TLabel;
		cbLineSpacing: TComboBox;
		chkPageEndLines: TCheckBox;

		procedure btnOKClick(Sender: TObject);
		procedure FormCreate(Sender: TObject);
		procedure FormShow(Sender: TObject);

	protected
		procedure Localize; override;

	end;

implementation

uses gtRPRender_DlgConsts;

const

	LineSpacing: array[TTextlineSpacing] of string = (SLineSpacingActual,
		SLineSpacingNoBlank, SLineSpacingOneBlank, SLineSpacingTwoBlank,
			SLineSpacingThreeBlank, SLineSpacingFourBlank, SLineSpacingFiveBlank);

{$R *.DFM}

{------------------------------------------------------------------------------}
{ TgtRPRenderTextDialog }
{------------------------------------------------------------------------------}

procedure TgtRPRenderTextDlg.btnOKClick(Sender: TObject);
begin
	with RenderObject as TgtRPRenderText do
	begin
		SeparateFilePerPage := chkSeparateFilePerPage.Checked;
		PageBreaks := chkPageBreaks.Checked;
		PageEndLines := chkPageEndLines.Checked;
		LineSpacing := TTextLineSpacing(cbLineSpacing.
			Items.Objects[cbLineSpacing.ItemIndex]);
	end;
	inherited btnOKClick(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderTextDlg.FormCreate(Sender: TObject);
var
	I: TTextLineSpacing;
begin
	inherited FormCreate(Sender);
	Localize;
	cbLineSpacing.Items.Clear;
	for I := Low(TTextLineSpacing) to High(TTextLineSpacing) do
		cbLineSpacing.Items.AddObject(Linespacing[I], TObject(I));
	tsBackground.TabVisible := False;
	pcgtRPRender.ActivePage := tsMain;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderTextDlg.FormShow(Sender: TObject);
begin
	with RenderObject as TgtRPRenderText do
	begin
		chkSeparateFilePerPage.Checked := SeparateFilePerPage;
		chkPageBreaks.Checked := PageBreaks;
		chkPageEndLines.Checked := PageEndLines;
		cbLineSpacing.ItemIndex := cbLineSpacing.Items.IndexOfObject(
			TObject(Ord(LineSpacing)));
	end;
	inherited FormShow(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderTextDlg.Localize;
begin
	inherited Localize;
	Caption := STextDialogCaption;
	tsFormatting.Caption := StsTextFormattingCaption;
	chkSeparateFilePerPage.Caption := SchkSeparateFilePerPageCaption;
	chkPageBreaks.Caption := SchkPageBreaksCaption;
	chkPageEndLines.Caption := SchkPageEndLinesCaption;
	lblLineSpacing.Caption := SlblLineSpacingCaption;

	// Set control width after setting text.
	chkSeparateFilePerPage.Width := (GetTextSize(Font,
		SchkSeparateFilePerPageCaption).cx + CMinWidth);
	chkPageBreaks.Width := (GetTextSize(Font,
		SchkPageBreaksCaption).cx + CMinWidth);
	chkPageEndLines.Width := (GetTextSize(Font,
		SchkPageEndLinesCaption).cx + CMinWidth);
end;

{------------------------------------------------------------------------------}

end.

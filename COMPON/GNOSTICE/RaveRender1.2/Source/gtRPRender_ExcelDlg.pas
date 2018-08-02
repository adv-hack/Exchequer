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

unit gtRPRender_ExcelDlg;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	Buttons, ComCtrls, ExtDlgs, StdCtrls, ExtCtrls,	gtRPRender_MainDlg,
	gtRPRender_DocumentDlg, gtRPRender_Main, gtRPRender_Excel,
	gtRPRender_Utils;

type

{ TgtRPRenderExcelDlg class }

	TgtRPRenderExcelDlg = class(TgtRPRenderDocumentDlg)
    tsFormatting: TTabSheet;
		gbExcelOptions: TGroupBox;
		lblLineSpacing: TLabel;
		chkSetCellAttributes: TCheckBox;
		cbLineSpacing: TComboBox;

		procedure FormCreate(Sender: TObject);
		procedure FormShow(Sender: TObject);
		procedure btnOKClick(Sender: TObject);

	protected
		procedure Localize; override;

	end;

implementation

uses gtRPRender_DlgConsts, gtRPRender_Consts;

const

	LineSpacing: array[TTextlineSpacing] of string = (SLineSpacingActual,
		SLineSpacingNoBlank, SLineSpacingOneBlank, SLineSpacingTwoBlank,
		SLineSpacingThreeBlank, SLineSpacingFourBlank, SLineSpacingFiveBlank);

{$R *.DFM}

{------------------------------------------------------------------------------}
{ TgtRPRenderExcelDlg }
{------------------------------------------------------------------------------}

procedure TgtRPRenderExcelDlg.FormCreate(Sender: TObject);
var
	I: TTextLineSpacing;
begin
	inherited FormCreate(Sender);
	Localize;
	cbLineSpacing.Items.Clear;
	for I := Low(TTextLineSpacing) to High(TTextLineSpacing) do
		cbLineSpacing.Items.AddObject(Linespacing[I], TObject(I));
	pcgtRPRender.ActivePage := tsMain;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcelDlg.FormShow(Sender: TObject);
begin
	with RenderObject as TgtRPRenderExcel do
	begin
		chkSetCellAttributes.Checked := SetCellAttributes;
		cbLineSpacing.ItemIndex := cbLineSpacing.Items.IndexOfObject(
			TObject(Ord(LineSpacing)));
	end;
	inherited FormShow(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcelDlg.btnOKClick(Sender: TObject);
begin
	with RenderObject as TgtRPRenderExcel do
	begin
		SetCellAttributes := chkSetCellAttributes.Checked;
		LineSpacing := TTextLineSpacing(cbLineSpacing.
			Items.Objects[cbLineSpacing.ItemIndex]);
	end;
	inherited btnOKClick(Sender);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderExcelDlg.Localize;
begin
	inherited Localize;
	Caption := SExcelDialogCaption;
	tsFormatting.Caption := StsFormattingCaption;
	chkSetCellAttributes.Caption := SchkSetCellAttributesCaption;
	lblLineSpacing.Caption := SlblLineSpacingCaption;

	// Set control width after setting text
	chkSetCellAttributes.Width := (GetTextSize(Font,
		SchkSetCellAttributesCaption).cx + CMinWidth);
end;

{------------------------------------------------------------------------------}

end.

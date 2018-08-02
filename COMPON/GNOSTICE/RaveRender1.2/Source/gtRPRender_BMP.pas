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

unit gtRPRender_BMP;

interface

uses
	SysUtils, Windows, Messages, Classes, Graphics, Forms, Dialogs, StdCtrls,
	Controls, gtRPRender_Graphic, gtRPRender_Consts, gtRPRender_Utils, RPRender;

type

{ TgtRPRenderBMP class }

	TgtRPRenderBMP = class(TgtRPRenderGraphic)
	private
		FMonochrome: Boolean;

	public
		constructor Create(AOwner: TComponent); override;

		function ShowSetupModal: Word; override;
		procedure PageEnd; override;
  {$IFDEF Rave50Up}
    procedure RenderPage(PageNum: Integer); override;
  {$ELSE}
		procedure PrintRender(NDRStream: TStream;
			OutputFileName: TFileName); override;
  {$ENDIF}

	published
		property Monochrome: Boolean read FMonochrome
			write FMonochrome default False;

	end;


implementation

uses gtRPRender_MainDlg, gtRPRender_BMPDlg;

{------------------------------------------------------------------------------}
{ TgtRPRenderBMP }
{------------------------------------------------------------------------------}

constructor TgtRPRenderBMP.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
	DisplayName := sBMPDesc;
	FileExtension := '*.' + sBMPExt;
	FMonochrome := False;
end;

{------------------------------------------------------------------------------}

// Creates and shows setup dialog
function TgtRPRenderBMP.ShowSetupModal: Word;
begin
	with TgtRPRenderBMPDlg.Create(nil) do
	try
		RenderObject := Self;
		Application.ProcessMessages;
		Result := ShowModal;
	finally
		Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRenderBMP.PageEnd;
var
	SaveFileName: string;
	BMP: Graphics.TBitmap;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	SaveFileName := FOutputFileName;
	if FCurrentPageNo > 1 then
	begin
		SaveFileName := (ExtractFilePath(FOutputFileName) +
			MakeFileName(FOutputFileName, GetFileExtension, FCurrentPageNo));

		if Assigned(OnMakeReportFileName) then
			OnMakeReportFileName(Self, SaveFileName, Converter.PageNo);
		ReportFileNames.Add(SaveFileName);

		FOwnedStream := TFileStream.Create(ReportFileNames[FCurrentPageNo - 1],
			fmCreate);
	end;

	BMP := StorePage(FBitmap);
	try
		BMP.Monochrome := FMonochrome;
		BMP.SaveToStream(FOwnedStream);
	finally
		BMP.Free;
	end;
	inherited PageEnd;
end;

{------------------------------------------------------------------------------}

{$IFDEF Rave50Up}

procedure TgtRPRenderBMP.RenderPage(PageNum: integer);
begin
	inherited Renderpage(PageNum);
	if not FExportCanceled then
	begin
		try
			InitFileStream(ReportFileNames.Strings[0]);
		except
			CancelExport;
			DoErrorMessage(sCreateFileError);
			Exit;
		end;
		with TRPConverter.Create(NDRStream, Self) do
			try
				Generate;
			finally
				Free;
			end;
	end;
end;

{$ELSE}

// Create FileStream and begin render
procedure TgtRPRenderBMP.PrintRender(NDRStream: TStream;
	OutputFileName: TFileName);
begin
	inherited PrintRender(NDRStream, OutputFileName);

	if not FExportCanceled then
	begin
		try
			InitFileStream(ReportFileNames.Strings[0]);
		except
			CancelExport;
			DoErrorMessage(sCreateFileError);
			Exit;
		end;
		with TRPConverter.Create(NDRStream, Self) do
			try
				Generate;
			finally
				Free;
			end;
	end;
end;

{$ENDIF}
{------------------------------------------------------------------------------}

end.

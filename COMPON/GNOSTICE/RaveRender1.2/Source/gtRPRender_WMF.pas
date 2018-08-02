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

unit gtRPRender_WMF;

interface

uses
	SysUtils, Windows, Messages, Classes, Graphics, Forms, Dialogs, StdCtrls,
	Controls, gtRPRender_Graphic, gtRPRender_Consts, gtRPRender_Utils, RPRender;

type

{ TgtRPRenderWMF class }

	TgtRPRenderWMF = class(TgtRPRenderGraphic)
	public
		constructor Create(AOwner: TComponent); override;

		function ShowSetupModal: Word; override;
		procedure PageEnd; override;
  {$IFDEF Rave50Up}
    procedure RenderPage(PageNum: integer); override;
  {$ELSE}
		procedure PrintRender(NDRStream: TStream;
			OutputFileName: TFileName); override;
  {$ENDIF}

	end;

implementation

uses gtRPRender_MainDlg, gtRPRender_MetafileDlg;

{------------------------------------------------------------------------------}
{ TgtRPRenderWMF }
{------------------------------------------------------------------------------}

constructor TgtRPRenderWMF.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
	DisplayName := SWMFDesc;
	FileExtension := '*.' + sWMFExt;
end;

{------------------------------------------------------------------------------}

// Creates and shows setup dialog
function TgtRPRenderWMF.ShowSetupModal: Word;
begin
	with TgtRPRenderMetafileDlg.Create(nil) do
	try
		RenderObject := Self;
		Application.ProcessMessages;
		Result := ShowModal;
	finally
		Free;
	end;
end;

{------------------------------------------------------------------------------}

// Renders WMF image to stream
procedure TgtRPRenderWMF.PageEnd;
var
	SaveFileName: string;
	EMF: TMetafile;
	BMP: TBitmap;
	EMFCanvas: TMetafileCanvas;
	R: TRect;
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

	EMF := TMetafile.Create;
	BMP := StorePage(FBitmap);
	try
		EMF.Enhanced := False;
		EMF.Transparent := False;
		EMF.Width := BMP.Width;
		EMF.Height := BMP.Height;
		EMFCanvas := TMetafileCanvas.Create(EMF, 0);

		EMFCanvas.Brush.Color := clWhite;
		EMFCanvas.Brush.Style := bsSolid;
		EMFCanvas.FillRect(R);

		EMFCanvas.Draw(0, 0, BMP);
		EMFCanvas.Free;
		EMF.SaveToStream(FOwnedStream);
	finally
		BMP.Free;
		EMF.Free;
	end;
	inherited PageEnd;
end;

{------------------------------------------------------------------------------}

// Create FileStream and begin render
{$IFDEF Rave50Up}
procedure TgtRPRenderWMF.RenderPage(PageNum: integer);
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

procedure TgtRPRenderWMF.PrintRender(NDRStream: TStream;
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

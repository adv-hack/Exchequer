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

unit gtRPRender_Main;

interface              

uses
	SysUtils, Windows, Messages, Classes, Graphics, Forms, Dialogs, StdCtrls,
	Math, Controls, RPRender, gtRPRender_Consts, gtRPRender_Utils,
	RPDefine, ShellAPI
	{$IFDEF EMailWithFastNet}
		, Psock, NMsmtp
	{$ENDIF}
	{$IFDEF EMailWithIndy}
		, IdComponent, IdTCPConnection, IdTCPClient, IdMessageClient, IdSMTP,
		IdBaseComponent, IdMessage
	{$ENDIF};

type

	// List of Image Formats
	TgtRPImageFormat = (ifGIF, ifJPG, ifBMP);

	// List of Background Display Types
	TgtRPBackgroundDisplayType = (dtTile, dtTopLeft, dtTopCenter, dtTopRight,
		dtCenterLeft, dtCenter, dtCenterRight, dtBottomLeft, dtBottomCenter,
		dtBottomRight);

	// Alignment Type
	TgtRPTextProperty = (tpAlignLeft, tpAlignRight, tpAlignCenter,
		tpAlignJustify);

	// Font Attrib
	TgtRPFontAttrib = record
		Charset: TFontCharset;
		Name: TFontName;
		Pitch: TFontPitch;
		Size: Integer;
		Color: TColor;
		Style: TFontStyles;
	end;

{ TgtRPEMailInfo class }

	// Class for storing EMail information obtained from OnEMail Event
	TgtRPEMailInfo = class(TObject)
	public
		Host: string;
		UserID: string;
		Password: string;
		Attachments: TStringList;
		Body: TStringList;
		Date: TDateTime;
		FromAddress: string;
		FromName: string;
		ReplyTo: string;
		Subject: string;
		RecipientList: TStringList;
		CCList: TStringList;
		BCCList: TStringList;

		constructor Create;
		destructor Destroy; override;
		
	end;

{ Event Types }

	TgtRPNotifyEvent = procedure(Render: TRPRender) of object;

	TMakeReportFileNameEvent = procedure(Render: TRPRender; var FileName: string;
		PageNo: Integer) of object;

	TMakeImageFileNameEvent = procedure(Render: TRPRender;
		var FileName, AltText: string; PageNo: Integer) of object;

	TDecodeImageEvent = procedure(Render: TRPRender; ImageStream: TStream;
		ImageType: string; Bitmap: TBitmap) of object;

	TgtRPEMailEvent = procedure(Render: TRPRender; EMailInfo: TgtRPEMailInfo;
		var Continue: Boolean) of object;

{$IFDEF EMailWithIndy}
	TgtEMailErrorEvent = procedure(Render: TRPRender; const ErrMsg: string)
		of object;
{$ENDIF}

{ TgtRPRender class }

	// Main gtRPRender class. All gtRPRender classes derive from TgtRPRender
	TgtRPRender = class(TRPRenderStream)
	private
		FBackgroundColor: TColor;
		FBackgroundImage: TPicture;
		FBackgroundDisplayType: TgtRPBackgroundDisplayType;
		FEMailAfterGenerate: Boolean;
		FOpenAfterGenerate: Boolean;
		FPages: string;
		FReportFileNames: TStringList;
		FShowProgress: Boolean;
		FShowSetupDialog: Boolean;
		FVersion: string;

		FOnDecodeImage: TDecodeImageEvent;
		FOnDocBegin: TgtRPNotifyEvent;
		FOnDocEnd: TgtRPNotifyEvent;
		FOnEMail: TgtRPEMailEvent;
		FOnMakeReportFileName: TMakeReportFileNameEvent;
		FOnPageBegin: TgtRPNotifyEvent;
		FOnPageEnd: TgtRPNotifyEvent;
	{$IFDEF EMailWithFastNet}
		FOnConnectionFailed: TNotifyEvent;
		FOnEMailFailure: TNotifyEvent;
		FOnInvalidHost: THandlerEvent;
	{$ENDIF}
	{$IFDEF EMailWithIndy}
		FOnEMailError: TgtEMailErrorEvent;
	{$ENDIF}

		function GetReportFileCount: Integer;

		procedure SetBackgroundImage(const Value: TPicture);
		procedure SetPages(const Value: string);
		procedure SetVersion(const Value: string);

	protected
		FOutputFileName: string;
		FCurrentX: Double;
		FCurrentY: Double;
		FExportCanceled: Boolean;
		FProcessingText: Boolean;
		FCurrentPageNo: Integer;
		FTotalPages: Integer;
		FEMailInfo: TgtRPEMailInfo;

		function GetRotatedTextBmp(const AText: string; AFontRotation: Integer;
			var AX, AY: Integer; ATextWidth, ATextHeight: Double;
			ATextAlign: TgtRPTextProperty; AFont: TgtRPFontAttrib): TBitmap;
		function GetFileExtension: string;
		function IsPageInRange(APageNo: Integer): Boolean;
		function ShowSetupModal: Word; virtual;

		procedure CreateEMailInfoObj; virtual;
		procedure DocBegin; override;
		procedure DocEnd; override;
		procedure DoErrorMessage(const ErrMsg: string); virtual;
		procedure MoveTo(const pfX1, pfY1: Double); override;
		procedure PageBegin; override;
		procedure PageEnd; override;
		procedure PrintImageRect(X1, Y1, X2, Y2: Double; ImageStream: TStream;
			ImageType: string); override;
		procedure	WriteToOwnedStream(const AText: string);

		property BackgroundColor: TColor read FBackgroundColor
			write FBackgroundColor default cBackgroundColor;
		property BackgroundImage: TPicture read FBackgroundImage
			write SetBackgroundImage;
		property BackgroundImageDisplayType: TgtRPBackgroundDisplayType
			read FBackgroundDisplayType	write FBackgroundDisplayType default dtCenter;

	public
		constructor Create(AOwner: TComponent); override;
		destructor Destroy; override;

		procedure CancelExport; virtual;
  {$IFDEF Rave50Up}
    procedure RenderPage(PageNum: integer); override;
  {$ELSE}
		procedure PrintRender(NDRStream: TStream;
			OutputFileName: TFileName); override;
  {$ENDIF}
		property ReportFileCount: Integer read GetReportFileCount;
		property ReportFileNames: TStringList read FReportFileNames;

	published
		property EMailAfterGenerate: Boolean read FEmailAfterGenerate
			write FEMailAfterGenerate default False;
		property OpenAfterGenerate: Boolean read FOpenAfterGenerate
			write FOpenAfterGenerate default False;
		property Pages: string read FPages write SetPages;
		property ShowProgress: Boolean read FShowProgress write FShowProgress
			default {$IFDEF SilentMode} False {$ELSE} True {$ENDIF};
		property ShowSetupDialog: Boolean read FShowSetupDialog
			write FShowSetupDialog
			default {$IFDEF SilentMode} False {$ELSE} True {$ENDIF};
		property Version: string read FVersion write SetVersion stored False;

		property OnDocBegin: TgtRPNotifyEvent read FOnDocBegin write FOnDocBegin;
		property OnDocEnd: TgtRPNotifyEvent read FOnDocEnd write FOnDocEnd;
		property OnEMail: TgtRPEMailEvent read FOnEMail write FOnEMail;
		property OnMakeReportFileName: TMakeReportFileNameEvent
			read FOnMakeReportFileName write FOnMakeReportFileName;
		property OnPageBegin: TgtRPNotifyEvent read FOnPageBegin write FOnPageBegin;
		property OnPageEnd: TgtRPNotifyEvent read FOnPageEnd write FOnPageEnd;
		property OnDecodeImage: TDecodeImageEvent read FOnDecodeImage
			write FOnDecodeImage;

	{$IFDEF EMailWithFastNet}
		property OnConnectionFailed: TNotifyEvent read FOnConnectionFailed
			write FOnConnectionFailed;
		property OnEMailFailure: TNotifyEvent read FOnEMailFailure
			write FOnEMailFailure;
		property OnInvalidHost: THandlerEvent read FOnInvalidHost
			write FOnInvalidHost;
	{$ENDIF}
	{$IFDEF EMailWithIndy}
		property OnEMailError: TgtEMailErrorEvent read FOnEMailError
			write FOnEMailError;
	{$ENDIF}
	end;

implementation

uses gtRPRender_ProgressDlg;

{------------------------------------------------------------------------------}
{ TgtRPEMailInfo }
{------------------------------------------------------------------------------}

constructor TgtRPEMailInfo.Create;
begin
	inherited Create;
	Date := Now;
	Attachments := TStringList.Create;
	Body := TStringList.Create;
	RecipientList := TStringList.Create;
	CCList := TStringList.Create;
	BCCList := TStringList.Create;
end;

{------------------------------------------------------------------------------}

destructor TgtRPEMailInfo.Destroy;
begin
	Attachments.Free;
	Body.Free;
	RecipientList.Free;
	CCList.Free;
	BCCList.Free;
	inherited Destroy;
end;

{------------------------------------------------------------------------------}
{ TgtRPRender }
{------------------------------------------------------------------------------}

constructor TgtRPRender.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
	FVersion := cVersion + ' ['+ RPVersion + ']';
	EMailAfterGenerate := False;
	OpenAfterGenerate := False;
	ShowProgress := {$IFDEF SilentMode} False {$ELSE} True {$ENDIF};
	ShowSetupDialog := {$IFDEF SilentMode} False {$ELSE} True {$ENDIF};
	FBackgroundImage := TPicture.Create;
	BackgroundColor := cBackgroundColor;
	BackgroundImageDisplayType := dtCenter;

	FReportFileNames := TStringList.Create;
end;

{------------------------------------------------------------------------------}

destructor TgtRPRender.Destroy;
begin
	FBackgroundImage.Free;
	FReportFileNames.Free;
	inherited Destroy;
end;

{------------------------------------------------------------------------------}

function TgtRPRender.GetReportFileCount: Integer;
begin
	Result := FReportFileNames.Count;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRender.SetBackgroundImage(const Value: TPicture);
begin
	FBackgroundImage.Assign(Value);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRender.SetPages(const Value: string);
var
	I: Integer;
	APageRange: string;
	PagesInvalid: Boolean;
begin
{	Check for validity of Value. Value can contain only ['0'..'9', '-', ','].
	If first char is ',' then Value is invalid. If ',' is not preceded by number
	then Value is invalid.
}
	PagesInvalid := False;
	APageRange := Trim(Value);
	if APageRange <> '' then
		if (APageRange = '-') or (APageRange[1] = ',') then
			PagesInvalid := True
		else
			for I := 1 to Length(APageRange) do
				if (not (APageRange[I] in ['0'..'9', '-', ','])) or
					((APageRange[I] = ',') and (not (APageRange[I - 1] in ['0'..'9']))) then
				begin
					PagesInvalid := True;
					Break;
				end;
	if PagesInvalid then
		DoErrorMessage(sPagesError)
	else
		FPages := APageRange;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRender.SetVersion(const Value: string);
begin
	//
end;

{------------------------------------------------------------------------------}

function TgtRPRender.GetRotatedTextBmp(const AText: string;
	AFontRotation: Integer; var AX, AY: Integer; ATextWidth, ATextHeight: Double;
	ATextAlign: TgtRPTextProperty; AFont: TgtRPFontAttrib): TBitmap;
var
	TextFont: TFont;
	CosA, SinA, AR: Extended;
begin
	TextFont := TFont.Create;
	try
		with TextFont do
		begin
			Name := AFont.Name;
			Charset := AFont.Charset;
			Pitch := AFont.Pitch;
			Size := AFont.Size;
			Color := AFont.Color;
			Style := AFont.Style;
		end;
		Result := TBitmap.Create;
		Result.Width := Round(ATextWidth);
		Result.Height := Round(ATextHeight);
		Result.Transparent := True;
		Result.Canvas.Font.Assign(TextFont);
		gtAngleText(AText, AFontRotation, Result, AX, AY);

    // For Right or Center aligned text. 
		CosA := Cos(DegToRad(AFontRotation));
		SinA := Sin(DegToRad(AFontRotation));
		if ATextAlign = tpAlignRight then
			AR := ATextWidth
		else if ATextAlign = tpAlignCenter then
			AR := ATextWidth / 2.0
		else
			AR := 0;
		AY := Round(AY - ATextHeight + (AR * SinA) + (ATextHeight * (1 - CosA)));
		AX := Round(AX + (AR * (1 - CosA)) - (ATextHeight * (SinA)));
	finally
		TextFont.Free;
	end;
end;

{------------------------------------------------------------------------------}

function TgtRPRender.GetFileExtension: string;
begin
	Result := ExtractFileExt(FOutputFileName);
	if (Result = '') or (Result = '.') then
	begin
		Result := Copy(FileExtension,
			Pos('.', FFileExtension), Length(FFileExtension));
		if Pos(';', Result) <> 0 then
			Result := Copy(Result, 0, Pos(';', Result) - 1);
	end;
end;

{------------------------------------------------------------------------------}

function TgtRPRender.IsPageInRange(APageNo: Integer): Boolean;
var
	I: Integer;
	InRange: Boolean;
	AStartPage, AEndPage: string;

	function GetResult:Boolean;
	begin
		Result := False;
		if InRange then
		begin
			if AStartPage = '' then
				AStartPage := '1';
			if AEndPage = '' then
				AEndPage := IntToStr(Converter.PageCount);
			if APageNo in [StrToInt(AStartPage)..StrToInt(AEndPage)] then
				Result := True;
			AEndPage := '';
			InRange := False;
		end
		else if APageNo = StrToInt(AStartPage) then
			Result := True;
		AStartPage := '';
	end;

begin
{	If Pages is '' then render all pages
	else check for current page in Pages, if included in Pages then
	render current page.
}
	Result := False;
	if FExportCanceled then
	begin
		Result := False;
		Exit;
	end;

{$IFNDEF Registered}
	if APageNo in [1, 2] then
		Result := True;
	Exit;
{$ENDIF}

	if Pages = '' then
		Result := True
	else
	begin
		AStartPage := '';
		AEndPage := '';
		InRange := False;
		for I := 1 to Length(FPages) do
		begin
			if FPages[I] = ',' then	// End of current range
				Result := GetResult
			else if FPages[I] = '-' then // '-' is used to specify range
				InRange := True
			else if FPages[I] in ['0'..'9'] then
			begin
				if InRange then
					AEndPage := AEndPage + FPages[I]
				else
					AStartPage := AStartPage + FPages[I];
			end;
			if Result then Exit;
		end;
		Result := GetResult;
	end;
end;

{------------------------------------------------------------------------------}

function TgtRPRender.ShowSetupModal: Word;
begin
	Result := mrOK;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRender.CreateEMailInfoObj;
begin
{	Create EMailInfo object. Add all ReportFiles as Attachments. }
	FEMailInfo := TgtRPEMailInfo.Create;
	with FEMailInfo do
		Attachments.Assign(FReportFileNames);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRender.DocBegin;
var
	I: Integer;
begin
	if FExportCanceled then Exit;

	if Assigned(FOnDocBegin) then
		FOnDocBegin(Self);

	FProcessingText := False;
	FCurrentPageNo := 0;
	FTotalPages := 0;
	for I := 1 to Converter.PageCount do
	begin
		Application.ProcessMessages;
		if IsPageInRange(I) then
			Inc(FTotalPages);
	end;
	if ShowProgress then
	begin
		gtRPRenderProgressDlg := TgtRPRenderProgressDlg.Create(Self);
		with gtRPRenderProgressDlg do
		begin
      RenderObject := Self;
			Pagecount := FTotalPages;
			CurrentPageNo := FCurrentPageNo;
			ProgressBar.Min := 0;
			Show;
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRender.DocEnd;
var
	Continue: Boolean;
	{$IFDEF EMailWithIndy}
		IdMessage: TIdMessage;
		IdSMTP: TIdSMTP;
		I: Integer;

		function GetAddressString(AText: string): string;
		begin
			Result := Trim(AText);
			Result := StringReplace(Result, CRLF, ';', [rfReplaceAll]);
			if Result[Length(Result)] = ';' then
				System.Delete(Result, Length(Result), 1);
		end;
	{$ENDIF}

begin
	Application.ProcessMessages;
	if ShowProgress then
		if gtRPRenderProgressDlg <> nil then
			gtRPRenderProgressDlg.Free;

	if FExportCanceled then Exit;
	if Assigned(FOnDocEnd) then
		FOnDocEnd(Self);

	if EMailAfterGenerate then
	begin
		CreateEMailInfoObj;
		Continue := False;
		repeat
			if Assigned(FOnEmail) then
				FOnEmail(Self, FEMailInfo, Continue);

			{$IFDEF EMailWithFastNet}
				with TNMSMTP.Create(Self) do
				try
					if Assigned(FOnConnectionFailed) then
						OnConnectionFailed := FOnConnectionFailed;
					if Assigned(FOnEMailFailure) then
						OnFailure := FOnEMailFailure;
					if Assigned(FOnInvalidHost) then
						OnInvalidHost := FOnInvalidHost;

					Host := FEMailInfo.Host;
					UserID := FEMailInfo.UserID;
					PostMessage.Attachments.Assign(FEMailInfo.Attachments);
					PostMessage.Body.Assign(FEMailInfo.Body);
					PostMessage.Date := DateToStr(FEMailInfo.Date);
					PostMessage.FromName := FEMailInfo.FromName;
					PostMessage.FromAddress := FEMailInfo.FromAddress;
					PostMessage.ReplyTo := FEMailInfo.ReplyTo;
					PostMessage.Subject := FEMailInfo.Subject;
					PostMessage.ToAddress.Assign(FEMailInfo.RecipientList);
					PostMessage.ToCarbonCopy.Assign(FEMailInfo.CCList);
					PostMessage.ToBlindCarbonCopy.Assign(FEMailInfo.BCCList);
					try
						Connect;
						SendMail;
					except
						DoErrorMessage(sEMailError);
						Continue := False;
					end;
				finally
					Disconnect;
					Free;
				end;
			{$ELSE}
			{$IFDEF EMailWithIndy}
				IdMessage := TIdMessage.Create(Self);
				IdSMTP := TIdSMTP.Create(Self);
				with IdMessage do
				try
					IdSMTP.Host := FEMailInfo.Host;
    			{$IFDEF Indy900Up}
		  			IdSMTP.UserName := FEMailInfo.UserID;
	    		{$ELSE}
   					IdSMTP.UserID := FEMailInfo.UserID;
    			{$ENDIF}
					IdSMTP.Password := FEMailInfo.Password;
					IdSMTP.AuthenticationType := atNone;
					for I := 0 to FEMailInfo.Attachments.Count - 1 do
						TIDAttachment.Create(MessageParts, FEMailInfo.Attachments[I]);
					Body.Assign(FEMailInfo.Body);
					Date := FEMailInfo.Date;
					From.Name := FEMailInfo.FromName;
					From.Text := FEMailInfo.FromAddress;
					ReplyTo.EMailAddresses := FEMailInfo.ReplyTo;
					Subject := FEMailInfo.Subject;

					Recipients.EMailAddresses := GetAddressString(
						FEMailInfo.RecipientList.Text);
					CCList.EMailAddresses := GetAddressString(
						FEMailInfo.CCList.Text);
					BCCList.EMailAddresses := GetAddressString(
						FEMailInfo.BCCList.Text);
					try
						IdSMTP.Connect;
						IdSMTP.Send(IdMessage);
					except
						on E: Exception do
						begin
							if Assigned(FOnEMailError) then
								FOnEMailError(Self, E.Message)
							else
								DoErrorMessage(E.Message);
							Continue := False;
						end;
					end;
				finally
					IdSMTP.DisConnect;
					IdSMTP.Free;
					Free;
				end;
			{$ENDIF}
			{$ENDIF}
		until not Continue;
	end;

	if OpenAfterGenerate then
		ShellExecute(Application.Handle, 'Open', PChar(FReportFileNames[0]),
			nil, nil, SW_SHOWNORMAL);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRender.DoErrorMessage(const ErrMsg: string);
begin
	MessageDlg(ErrMsg, mtError, [mbOK], 0);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRender.MoveTo(const pfX1, pfY1: Double);
begin
	FCurrentX := pfX1;
	FCurrentY := pfY1;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRender.PageBegin;
begin
	if not IsPageInRange(Converter.PageNo) then Exit;

	Inc(FCurrentPageNo);
	if Assigned(FOnPageBegin) then
		FOnPageBegin(Self);

	if ShowProgress then
		with gtRPRenderProgressDlg do
		begin
			Pagecount := FTotalPages;
			CurrentPageNo := FCurrentPageNo;
			ProgressBar.Max := FTotalPages;
			ProgressBar.Position := FCurrentPageNo;
		end;
	Application.ProcessMessages;
end;

{------------------------------------------------------------------------------}

procedure TgtRPRender.PageEnd;
begin
	Application.ProcessMessages;
	if not IsPageInRange(Converter.PageNo) then Exit;

	if Assigned(FOnPageEnd) then
		FOnPageEnd(Self);
end;

{------------------------------------------------------------------------------}

procedure TgtRPRender.PrintImageRect(X1, Y1, X2, Y2: Double;
	ImageStream: TStream; ImageType: string);
var
	Bmp: TBitmap;
begin
	If Assigned(FOnDecodeImage) then
	begin
		Bmp := TBitmap.Create;
		try
			FOnDecodeImage(Self, ImageStream, ImageType, Bmp);
			PrintBitmapRect(X1, Y1, X2, Y2, Bmp);
		finally
			Bmp.Free;
		end;
	end;
end;

{------------------------------------------------------------------------------}

procedure	TgtRPRender.WriteToOwnedStream(const AText: string);
begin
	FOwnedStream.Write(Pointer(AText)^, Length(AText));
end;

{------------------------------------------------------------------------------}

procedure TgtRPRender.CancelExport;
var
	I: Integer;
begin
	FExportCanceled := True;
	FOwnedStream.Free;
	FOwnedStream := nil;
	for I := 0 to ReportFileCount - 1 do
		CheckAndDeleteFile(ReportFileNames.Strings[I]);
end;

{------------------------------------------------------------------------------}

{$IFDEF Rave50Up}

procedure TgtRPRender.RenderPage(PageNum: integer);
var
	AFileName: string;
begin
	FReportFileNames.Clear;
	if ShowSetupDialog then
		FExportCanceled := (ShowSetupModal = mrCancel)
	else
		FExportCanceled := False;

	if not FExportCanceled then
	begin
		FOutputFileName := OutputFileName;
		AFileName := ExtractFilePath(FOutputFileName) +
			MakeFileName(FOutputFileName, GetFileExtension, -1);
		if Assigned(FOnMakeReportFileName) then
			FOnMakeReportFileName(Self, AFileName, 1);
		FReportFileNames.Add(AFileName);
	end;
end;

{------------------------------------------------------------------------------}

{$ELSE}

procedure TgtRPRender.PrintRender(NDRStream: TStream;
	OutputFileName: TFileName);
var
	AFileName: string;
begin
	FReportFileNames.Clear;

	if ShowSetupDialog then
		FExportCanceled := (ShowSetupModal = mrCancel)
	else
		FExportCanceled := False;

	if not FExportCanceled then
	begin
		FOutputFileName := OutputFileName;
		AFileName := ExtractFilePath(FOutputFileName) +
			MakeFileName(FOutputFileName, GetFileExtension, -1);
		if Assigned(FOnMakeReportFileName) then
			FOnMakeReportFileName(Self, AFileName, 1);
		FReportFileNames.Add(AFileName);
	end;
end;

{$ENDIF}
{------------------------------------------------------------------------------}

end.

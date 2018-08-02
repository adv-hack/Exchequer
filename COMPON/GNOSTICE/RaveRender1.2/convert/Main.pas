
{***************************************************************************}
{  Convert => Gnostice Rave                                                 }
{  Conversion utility                                                       }
{                                                                           }
{  Copyright © 1998-2002 Gnostice Information Technologies Private Limited  }
{                                                                           }
{***************************************************************************}

{!!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!}
{                                                           }
{ COMPILE THIS PROJECT IN THE SAME VERSION OF DELPHI/       }
{ C++ BUIDLER AS THE PROJECTS, WHICH WILL BE CONVERTED,     }
{ WERE DEVELOPED IN.                                        }
{                                                           }
{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}

unit Main;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls, Buttons, FileCtrl, ExtCtrls, ShellAPI, ComCtrls;

type
	TfrmMain = class(TForm)
		btnStart: TBitBtn;
		gbSingleFile: TGroupBox;
		gbMultiFile: TGroupBox;
		rbSingleFile: TRadioButton;
		rbFolderFiles: TRadioButton;
		edSingleFile: TEdit;
		btnSelectFile: TSpeedButton;
		edMultiFile: TEdit;
		btnSelectDir: TSpeedButton;
		gbFileType: TGroupBox;
		edFileExt: TEdit;
		btnAdd: TSpeedButton;
		lbFileExts: TListBox;
		btnRemove: TSpeedButton;
		Bevel1: TBevel;
		lblFilesDone: TLabel;
		Image1: TImage;
		lblCurrentFile: TLabel;
		Image2: TImage;
    progFiles: TProgressBar;
		Bevel4: TBevel;
		progLines: TProgressBar;
		Bevel5: TBevel;
		OpenDialog: TOpenDialog;
		lblLinesLeft: TLabel;
		chbBackup: TCheckBox;
		edBackupDir: TEdit;
		procedure btnStartClick(Sender: TObject);
		procedure btnAddClick(Sender: TObject);
		procedure edFileExtChange(Sender: TObject);
		procedure btnRemoveClick(Sender: TObject);
		procedure btnSelectDirClick(Sender: TObject);
		procedure rbSingleFileClick(Sender: TObject);
		procedure rbFolderFilesClick(Sender: TObject);
		procedure btnSelectFileClick(Sender: TObject);
		procedure edPathChange(Sender: TObject);
		procedure FormCreate(Sender: TObject);
	private
		FFileCount: Integer;
		FCurrPathEdit: TEdit;

		procedure UpdateListCtrls(I: Integer);
		procedure UpdateStartBtn;
	public
	end;

var
	frmMain: TfrmMain;

implementation

{$R *.DFM}

type

	THackWinControl = class(TWinControl);

const
	ClassNames: array[0..9] of string = ('RPRenderPDF', 'RPRenderHTML',
    'RPRenderRTF', 'RPRenderExcel', 'RPRenderText', 'RPRenderGIF',
    'RPRenderJPEG', 'RPRenderBMP', 'RPRenderEMF', 'RPRenderWMF');

  UnitNames: array[0..13] of string = ('RPRender_Main', 'RPRender_Document',
    'RPRender_Graphic','RPRender_PDF', 'RPRender_HTML', 'RPRender_RTF',
    'RPRender_Excel', 'RPRender_Text', 'RPRender_GIF', 'RPRender_JPEG',
    'RPRender_BMP', 'RPRender_EMF', 'RPRender_WMF', 'gtRPRRoutines');

{------------------------------------------------------------------------------}

{-Conversion & file routines --------------------------------------------------}

function AppendTrailingBackslash(const S: string): string;
begin
	Result := S;
	if not IsPathDelimiter(Result, Length(Result)) then Result := Result + '\';
end;

{------------------------------------------------------------------------------}

function GetFilesInDirectory(const DirName, FileTypes: string;
	Attrib: Integer): TStringList;

	procedure AddFileNamesToList(const ADir, AFileExt: string; AAttrib: Integer;
		AList: TStrings);
	var
		SRec: TSearchRec;
		S: string;
	begin
		S := AppendTrailingBackslash(ADir) + '*.' + AFileExt;
		if FindFirst(S, AAttrib, SRec) = 0 then
			with AList do
			begin
				repeat
					if (SRec.Attr and AAttrib) = SRec.Attr then
						Add(SRec.Name);
				until FindNext(SRec) <> 0;
				FindClose(SRec);
			end;
	end;

var
	I: Integer;
begin
	Result := nil;
	if DirectoryExists(DirName) then
	begin
		Result := TStringList.Create;
		with TStringList.Create do
			try
				CommaText := FileTypes;
				for I := 0 to Count - 1 do
					AddFileNamesToList(DirName, Strings[I], Attrib, Result);
			finally
				Free;
			end;
	end;
end;

{------------------------------------------------------------------------------}

function IsDFMBinary(FileName: string): Boolean;
var
	F: TFileStream;
	B: Byte;
begin
	B := 0;
	F := TFileStream.Create(FileName, fmOpenRead);
	try
		F.Read(B, 1);
		Result := B = $FF;
	finally
		F.Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure DFM2TXT(Src, Dest: string);
var
	SrcS, DestS: TFileStream;
begin
	SrcS := TFileStream.Create(Src, fmOpenRead);
	DestS := TFileStream.Create(Dest, fmCreate);
	try
		ObjectResourceToText(SrcS, DestS);
	finally
		SrcS.Free;
		DestS.Free;
	end;
end;

{------------------------------------------------------------------------------}

function ReplaceString(const S, OldPattern, NewPattern: string;
	var NumFound: Integer): string;

	function IsWholeMatch(const S, Patt: string; StartPos: Integer): Boolean;
	begin
		Result := ((StartPos = 1) or not(S[StartPos - 1] in ['A'..'Z', '0'..'9']))
			and	((StartPos + Length(Patt) >= Length(S)) or
				not(S[StartPos + Length(Patt)] in ['A'..'Z', '0'..'9']));
	end;

var
	I: Integer;
	SearchStr, Str, OldPat: string;
begin
	SearchStr := AnsiUpperCase(S);
	OldPat := AnsiUpperCase(OldPattern);
	Str := S;
	NumFound := 0;
	Result := '';
	while SearchStr <> '' do
	begin
		I := AnsiPos(OldPat, SearchStr);
		if I = 0 then
		begin
			Result := Result + Str;
			Break;
		end;
		// ------ Match whole words only ------
		if IsWholeMatch(SearchStr, OldPat, I) then
		begin
			Inc(NumFound);
			Result := Result + Copy(Str, 1, I - 1) + NewPattern;
		end
		else
			Result := Result + Copy(Str, 1, I + Length(OldPat) - 1);
		Str := Copy(Str, I + Length(OldPattern), MaxInt);
		SearchStr := Copy(SearchStr, I + Length(OldPat), MaxInt);
	end;
end;

{------------------------------------------------------------------------------}

procedure TXT2DFM(Src, Dest: string);
var
	SrcS, DestS: TFileStream;
begin
	SrcS := TFileStream.Create(Src, fmOpenRead);
	DestS := TFileStream.Create(Dest, fmCreate);
	try
		ObjectTextToResource(SrcS, DestS);
	finally
		SrcS.Free;
		DestS.Free;
	end;
end;

{------------------------------------------------------------------------------}

procedure ChangeToPs(SrcFile, DestFile: string; AProgressBar: TProgressBar;
	AProgressLabel: TLabel; var ChangeCount: array of Integer;
	var ChangeSum: Integer);

	procedure UpdateLineStatus(I: Integer);
	begin
		AProgressBar.Position := I;
		AProgressBar.Update;
		AProgressLabel.Caption := Format('%d of %d', [I,  AProgressBar.Max]);
		AProgressLabel.Update;
	end;

var
	I, Count: Integer;
//	C: TQRCtrlClass;
  C: Integer;
	S: string;
	Lines: TStringList;
begin
	Lines := TStringList.Create;
	try
		Lines.LoadFromFile(SrcFile);
		AProgressBar.Max := Lines.Count - 1;

		for I := Lines.Count - 1 downto 0 do
		begin
		 	UpdateLineStatus(I);
			S := Lines[I];
{$IFDEF GPQR}
			if (Pos('EXPORTASJPEG = ', UpperCase(S)) <> 0) or
				(Pos('EXPORTJPEGQUALITY = ', UpperCase(S)) <> 0) or
				(Pos('EXPORTUSINGSINGLEIMAGE = ', UpperCase(S)) <> 0) or
				(Pos('HTMLALTTEXT = ', UpperCase(S)) <> 0) or
				(Pos('ONCREATEIMAGE = ', UpperCase(S)) <> 0) then
			begin
				Lines.Delete(I);
				Continue;
			end;
{$ENDIF}
			for C := Low(UnitNames) to High(UnitNames) do
				S := ReplaceString(S, 'Ps' + UnitNames[C], 'gt' + UnitNames[C],
          Count);

			for C := Low(ClassNames) to High(ClassNames) do
			begin
				S := ReplaceString(S, 'TPs' + ClassNames[C], 'Tgt' + ClassNames[C],
          Count);
				if Count <> 0 then
				begin
					Inc(ChangeSum, Count);
				end;
			end;
      Count := 0;
      S := ReplaceString(S, 'RenderUsinggtRenderObject','RenderUsingRenderObject'
        ,Count);
			Lines[I] := S;
			Application.ProcessMessages;
		end;
	finally
		Lines.SaveToFile(DestFile);
		Lines.Free;
	end;
end;

{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
	FCurrPathEdit := edMultiFile;
end;

{-Convert-method selection ----------------------------------------------------}

procedure EnableGroupBox(AGroupBox: TGroupBox);
var
	I: Integer;
begin
	with AGroupBox do
	begin
		Enabled := True;
		for I := 0 to ControlCount - 1 do
			if (Controls[I] is TWinControl) and
					(THackWinControl(Controls[I]).Color = clInactiveBorder) then
				THackWinControl(Controls[I]).Color := clWindow;
	end;
end;

{------------------------------------------------------------------------------}

procedure DisableGroupBox(AGroupBox: TGroupBox);
var
	I: Integer;
begin
	with AGroupBox do
	begin
		Enabled := False;
		for I := 0 to ControlCount - 1 do
			if (Controls[I] is TWinControl) and
					(THackWinControl(Controls[I]).Color = clWindow) then
				THackWinControl(Controls[I]).Color := clInactiveBorder;
	end;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.rbSingleFileClick(Sender: TObject);
begin
	DisableGroupBox(gbFileType);
	DisableGroupBox(gbMultiFile);
	EnableGroupBox(gbSingleFile);
	FCurrPathEdit := edSingleFile;
	UpdateStartBtn;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.rbFolderFilesClick(Sender: TObject);
begin
	DisableGroupBox(gbSingleFile);
	EnableGroupBox(gbMultiFile);
	EnableGroupBox(gbFileType);
	FCurrPathEdit := edMultiFile;
	UpdateStartBtn;
end;

{-File/Folder dialog invoke ---------------------------------------------------}

procedure TfrmMain.btnSelectFileClick(Sender: TObject);
begin
	if OpenDialog.Execute then
		edSingleFile.Text := OpenDialog.FileName;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.btnSelectDirClick(Sender: TObject);
var
	S: string;
begin
{$IFDEF VER100}
	S := '\';
	if SelectDirectory(S, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then
{$ELSE}
	if SelectDirectory('Select folder to find files in', '\', S) then
{$ENDIF}
		edMultiFile.Text := S;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.edPathChange(Sender: TObject);
begin
	UpdateStartBtn;
end;

procedure TfrmMain.UpdateStartBtn;
begin
	btnStart.Enabled := FCurrPathEdit.Text <> '';
end;

{-File-types list management --------------------------------------------------}

procedure TfrmMain.edFileExtChange(Sender: TObject);
begin
	btnAdd.Enabled := edFileExt.Text <> '';
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.btnAddClick(Sender: TObject);
var
	S: string;
begin
	S := UpperCase(edFileExt.Text);
	if lbFileExts.Items.IndexOf(S) = -1 then
		UpdateListCtrls(lbFileExts.Items.Add(S));
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.btnRemoveClick(Sender: TObject);
var
	I: Integer;
begin
	I := lbFileExts.ItemIndex;
	if I = -1 then
		lbFileExts.ItemIndex := 0
	else
	begin
		lbFileExts.Items.Delete(I);
		UpdateListCtrls(I);
	end;
end;

{------------------------------------------------------------------------------}

procedure TfrmMain.UpdateListCtrls(I: Integer);
begin
	btnRemove.Enabled := lbFileExts.Items.Count <> -1;
	if lbFileExts.Items.Count = I then
		I := lbFileExts.Items.Count - 1;
	lbFileExts.ItemIndex := I;
end;

{-Get file-List and start conversion ------------------------------------------}

procedure TfrmMain.btnStartClick(Sender: TObject);

var
	FileList: TStrings;
	I, ChangeSum: Integer;
	TempFile, FileName, PathName, FileExt: string;
	ChangeCount: array of Integer;

	function CopyFiles(AFileList: TStrings; const SrcPath,
		DestPath: string): Boolean;
	var
		Fo: TSHFileOpStruct;
		Buff: array[0..1024 * 32] of Char;
		P: PChar;
		I: Integer;
		SPath: string;

		procedure InitBuff;
		begin
			FillChar(Buff, SizeOf(Buff), #0);
			P := @Buff;
		end;

		procedure DoCopyFiles;
		begin
			FillChar(Fo, SizeOf(Fo), #0);
			Fo.Wnd := Handle;
			Fo.wFunc := FO_COPY;
			Fo.pFrom := @Buff;
			Fo.pTo := PChar(AppendTrailingBackslash(DestPath));
			Fo.fFlags := 0;
			Fo.lpszProgressTitle := 'Copying files to Backup folder...';
			Result := (SHFileOperation(Fo) = 0) and (
				Fo.fAnyOperationsAborted = False);
			InitBuff;
		end;

	begin
		Result := True;
		InitBuff;
		SPath := AppendTrailingBackslash(SrcPath);
		for I := 0 to AFileList.Count - 1 do
		begin
			//**** Copy in batches if there are too many files ****
			if (P - @Buff) + Length(SPath + AFileList[I]) + 2 > SizeOf(Buff) then
				DoCopyFiles;
			if not Result then Break;
			P := StrECopy(P, PChar(SPath + AFileList[I])) + 1;
		end;
		if Result then DoCopyFiles;
	end;

	procedure UpdateFileStatus(I: Integer; CurrFile: string);
	begin
		progFiles.Position := I + 1;
		progFiles.Update;
		lblFilesDone.Caption := Format('%d of %d', [I + 1, FFileCount]);
		lblFilesDone.Update;
		lblCurrentFile.Caption := CurrFile;
		lblCurrentFile.Update;
	end;

begin
	FileList := nil;
	Screen.Cursor := crHourGlass;
	btnStart.Enabled := False;
	try
		if rbSingleFile.Checked then
		begin
			FileList := TStringList.Create;
			if FileExists(edSingleFile.Text) then
			begin
				FileList.Add(ExtractFileName(edSingleFile.Text));
				PathName := AppendTrailingBackslash(ExtractFilePath(edSingleFile.Text));
			end;
		end
		else
		begin
			PathName := AppendTrailingBackslash(edMultiFile.Text);
			if DirectoryExists(PathName) then
				Filelist := GetFilesInDirectory(PathName,
					lbFileExts.Items.CommaText, faArchive);
		end;
		if (FileList = nil) or (FileList.Count = 0) then
		begin
			MessageDlg('No files to convert!'#13#10#13#10 +
				'Make sure the file/folder specified is correct', mtError, [mbOK], 0);
			Exit;
		end;

		//------------- Backup files before conversion -------------------
		if chbBackup.Checked then
		begin
			ForceDirectories(PathName + edBackupDir.Text);
			if not CopyFiles(FileList, PathName, PathName + edBackupDir.Text) then
				if MessageDlg('Backup operation did not complete successfully!' +
					'#13#10#13#10 Continue anyway?', mtConfirmation, [mbYes, mbNO], 0) =
						mrNo then
					Exit;
		end;

		//------------- Supply file name and get it converted ------------
		//InitCountVars;
		FFileCount := FileList.Count;
		progFiles.Max := FFileCount;
		for I := 0 to FFileCount - 1 do
		begin
			//UpdateFileStatus(I, FileList[I]);
			FileName := PathName + FileList[I];
			TempFile := ChangeFileExt(FileName, '.$$$');
			if FileExists(TempFile) then
				DeleteFile(TempFile);


			if IsDFMBinary(FileName) then
			begin
				DFM2TXT(FileName, TempFile);
				ChangeToPs(TempFile, TempFile, progLines, lblLinesLeft,
					ChangeCount, ChangeSum);
				TXT2DFM(TempFile, FileName);
			end
			else
			begin
				RenameFile(FileName, TempFile);
				ChangeToPs(TempFile, FileName, progLines, lblLinesLeft,
					ChangeCount, ChangeSum);
			end;
			FileExt := ExtractFileExt(FileName);
			if (Fileext = '.pas') or (FileExt = '.cpp') or
          (FileExt = '.h') or (FileExt = '.dfm') then
  			DeleteFile(TempFile);
		end;

		MessageDlg('Converted to Gnostice Rave Renders!'#13#10#13#10 +
			'Enjoy Gnostice Rave Rendering!', mtInformation, [mbOK], 0);
	finally
		FileList.Free;
		Screen.Cursor := crDefault;
		btnStart.Enabled := True;
	end;
end;

{------------------------------------------------------------------------------}

end.

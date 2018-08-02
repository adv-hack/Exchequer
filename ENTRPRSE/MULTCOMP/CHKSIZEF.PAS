unit ChkSizeF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SETUPBAS, ExtCtrls, StdCtrls, IniFiles;

type
  TfrmCheckFileSize = class(TSetupTemplate)
    lstFilenames: TListBox;
    lblCompany: TLabel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Procedure TestFile (Const CompPath, FilePath : ShortString; Const ShowDebug : Boolean = True); 
  public
    { Public declarations }
    Procedure CheckDataFiles (Const CompPath : ShortString; Const TestAll : Boolean);
  end;

//Procedure ChkFileSizes (Const CompCode, CompName, CompPath : ShortString; Const CheckDaily, TestAll : Boolean);

implementation

Uses APIUtil,
     History;      // MCM Version No

Const
  WarnSize : Cardinal = 3800000000;      // 3.8Gb

  {$I FilePath.Inc}

  {$I VerModu.Pas}

{$R *.dfm}

//=========================================================================
(*

// HM and VM 12/04/2007 removed checkfiles section for v6.00 and SQL


Procedure ChkFileSizes (Const CompCode, CompName, CompPath : ShortString; Const CheckDaily, TestAll : Boolean);
Var
  LogName : ShortString;
  I       : SmallInt;

  //------------------------------

  // check the .INI file to see if we need to check the INI file for this user
  Function WantDailyCheck (Const CompCode : ShortString) : Boolean;
  Var
    LastDate, UName : ShortString;
//LastError : DWord;
//sSection, sIdent, sValue, sFileName : ANSIString;
  Begin { WantDailyCheck }
    // Check .INI to see if we need to check the files
    With TIniFile.Create (ExtractFilePath(Application.ExeName) + 'FILESIZE.INI') Do
      Try
        // Get windows user Id for Check
        UName := WinGetUserName;

        // Read Last Check Date for this User and Company
        LastDate := ReadString (CompCode, UName, '');

        If (LastDate <> '') Then
          // Examine Date to see if its been
          Result := (LastDate <> FormatDateTime('YYYYMMDD', Now))
        Else
          // No check logged against User and Company
          Result := True;

        If Result Then
//Try
          // Update Last Checked date
          WriteString (CompCode, UName, FormatDateTime('YYYYMMDD', Now));
//Except
//  sSection := CompCode;
//  sIdent := UName;
//  sValue := FormatDateTime('YYYYMMDD', Now);
//  sFileName := ExtractFilePath(Application.ExeName) + 'FILESIZE.INI';
//  WritePrivateProfileString(PChar(sSection), PChar(sIdent), PChar(sValue), PChar(sFileName));
//  LastError := GetLastError;
//  ShowMessage ('Error ' + IntToStr(LastError) + ' writing to FileSize.Ini');
//End;

        // Get Threshold from INI - mainly used for testing - use ReadFloat as
        // numbers too large for ReadInteger to handle.
        WarnSize := Round(ReadFloat('System', 'Threshold', WarnSize));
      Finally
        Free;
      End;
  End; { WantDailyCheck }

  //------------------------------

Begin { ChkFileSizes }
  If (Not CheckDaily) Or WantDailyCheck (Trim(CompCode)) Then Begin
    With TfrmCheckFileSize.Create(Application.MainForm) Do
      Try
        // Check the size of the data files
        CheckDataFiles (CompPath, TestAll);

        // Check to see if any warnings were generated
        If (lstFilenames.Count > 0) Then Begin
          // Update display info with Company Details
          lblCompany.Caption := lblCompany.Caption + CompCode + ' - ' + CompName;

          // Generate Error Log in Data Set so users can't deny being informed :-)
          If DirectoryExists(CompPath + 'LOGS') Then
            With TStringList.Create Do
              Try
                // Write Log Message
                Add ('Multi-Company Manager ' + History.CurrVersion_Comp);
                Add ('');
                Add (FormatDateTime ('DD/MM/YY - HH:MM:SS', Now) +
                     '    Computer: ' +  WinGetComputerName +
                     '    User: ' +  WinGetUserName);
                Add ('---------------------------------------------------------------');
                Add ('Log Type : Maximum Data File Size Warning');
                Add ('');
                Add ('The Data Files listed below are nearing their maximum size:-');
                Add ('');
                For I := 0 To Pred(lstFilenames.Count) Do
                  Add ('  ' + lstFilenames.Items[I]);

                // Identify Filename and save
                For I := 1 To 9999 Do Begin
                  LogName := CompPath + 'LOGS\E' + IntToStr(I) + '.Log';

                  If (Not FileExists(LogName)) Then Begin
                    SaveToFile (LogName);
                    Break;
                  End; { If (Not FileExists(LogName)) }
                End; { For I }
              Finally
                Free;
              End;

          // Display Warning
          ShowModal;
        End; { If (lstFilenames.Items.Count > 0) }

        // Update
      Finally
        Free;
      End;
  End; { If WantDailyCheck }
End; { ChkFileSizes }

*)

//=========================================================================

procedure TfrmCheckFileSize.FormCreate(Sender: TObject);
begin
  inherited;

  Caption := 'Maximum Data Size Warning';
  ExitMsg := 255;
end;

//-------------------------------------------------------------------------

Procedure TfrmCheckFileSize.CheckDataFiles (Const CompPath : ShortString; Const TestAll : Boolean);
Begin { CheckDataFiles }
  // Remove any pre-existing messages
  lstFilenames.Clear;

  If DirectoryExists(CompPath) Then Begin
//TestFile ('T:\SUPPORT\CLIENT_D\Dl\enwwil01\ACCOUNTS\EXCH\', 'TRANS\DETAILS.DAT');

    // Cust\CustSupp.Dat
    If TestAll And FileExists (CompPath + Path1 + CustName) Then
      TestFile (CompPath, Path1 + CustName);

    // HM 28/07/03: Added support for E-Business module
    If TestAll And DirectoryExists (CompPath + PathEBus) Then
    Begin
      // Ebus\EBUSDETL.DAT
      If FileExists (CompPath + PathEBus + 'EBUSDETL.DAT') Then
        TestFile (CompPath, PathEBus + 'EBUSDETL.DAT');

      // Ebus\EBUSDOC.DAT
      If FileExists (CompPath + PathEBus + 'EBUSDOC.DAT') Then
        TestFile (CompPath, PathEBus + 'EBUSDOC.DAT');

      // Ebus\EBUSLKUP.DAT
      If FileExists (CompPath + PathEBus + 'EBUSLKUP.DAT') Then
        TestFile (CompPath, PathEBus + 'EBUSLKUP.DAT');

      // Ebus\EBUSNOTE.DAT
      If FileExists (CompPath + PathEBus + 'EBUSNOTE.DAT') Then
        TestFile (CompPath, PathEBus + 'EBUSNOTE.DAT', True);
    End; { If TestAll And DirectoryExists (CompPath + PathEBus) }

    // HM 28/07/03: Jobs\JOBCTRL.DAT
    If TestAll And FileExists (CompPath + Path6 + JobCtrlNam) Then
      TestFile (CompPath, Path6 + JobCtrlNam);

    // HM 28/07/03: Jobs\JOBDET.DAT
    If TestAll And FileExists (CompPath + Path6 + JobDetNam) Then
      TestFile (CompPath, Path6 + JobDetNam);

    // HM 28/07/03: Jobs\JOBHEAD.DAT
    If TestAll And FileExists (CompPath + Path6 + JobRecNam) Then
      TestFile (CompPath, Path6 + JobRecNam);

    // HM 28/07/03: Jobs\JOBMISC.DAT
    If TestAll And FileExists (CompPath + Path6 + JobMiscNam) Then
      TestFile (CompPath, Path6 + JobMiscNam);

    // Misc\ExChqChk
    If TestAll And FileExists (CompPath + Path3 + PassNam) Then
      TestFile (CompPath, Path3 + PassNam);

    // HM 28/07/03: Misc\EXSTKCHK.DAT
    If TestAll And FileExists (CompPath + Path3 + MiscNam) Then
      TestFile (CompPath, Path3 + MiscNam);

    // Stock\MLocStk.Dat
    If TestAll And FileExists (CompPath + Path4 + MLocName) Then
      TestFile (CompPath, Path4 + MLocName);

    // Stock\Stock.Dat
    If TestAll And FileExists (CompPath + Path4 + StockNam) Then
      TestFile (CompPath, Path4 + StockNam);

    // Trans\Details.Dat
    If FileExists (CompPath + Path2 + DetailName) Then
      TestFile (CompPath, Path2 + DetailName);

    // Trans\Document.Dat
    If FileExists (CompPath + Path2 + DocName) Then
      TestFile (CompPath, Path2 + DocName);

    // Trans\History.Dat
    If FileExists (CompPath + Path2 + HistName) Then
      TestFile (CompPath, Path2 + HistName);

    // HM 28/07/03: Trans\Nominal.Dat
    If TestAll And FileExists (CompPath + Path2 + NomNam) Then
      TestFile (CompPath, Path2 + NomNam);
  End; { If DirectoryExists(CheckDir) }
End; { CheckDataFiles }

//-------------------------------------------------------------------------

Procedure TfrmCheckFileSize.TestFile (Const CompPath, FilePath : ShortString; Const ShowDebug : Boolean = True);
Var
  AddWarning : Boolean;
Begin { TestFile }
  // HM 28/07/03: Added CompPath into FileExists check as didn't work from Setup program - was OK from MCM
  If FileExists(CompPath + FilePath) Then
    With TFileStream.Create(CompPath + FilePath, fmOpenRead or fmShareDenyNone) Do
      Try
        // Store result in local variable so that the file is opened for the minimum time
        If (Size > WarnSize) Then
          lstFilenames.Items.Add(FilePath + #9 + FormatFloat('###,##0 Mb', Round(Size / 1000000)));
      Finally
        free;
      End;
End; { TestFile }

//=========================================================================

end.

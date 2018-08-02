unit MainU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RpDevice, RPDefine, RPBase, RPFiler, StdCtrls, Menus, ExtCtrls, RPFPrint,
  RPCanvas, RPrinter, Printers, RPRender, RPRender_PDF;

type
  ENoUnique = Class (Exception);

  TForm1 = class(TForm)
    ReportFiler1: TReportFiler;
    Label1: TLabel;
    List_Printers: TListBox;
    Label4: TLabel;
    List_Bins: TListBox;
    Label5: TLabel;
    List_Papers: TListBox;
    MainMenu1: TMainMenu;
    Mnu_File: TMenuItem;
    MnuOpt_Exit: TMenuItem;
    Mnu_Options: TMenuItem;
    Mnu_Help: TMenuItem;
    MnuOpt_About: TMenuItem;
    MnuOpt_Update: TMenuItem;
    Bevel1: TBevel;
    MnuOpt_PrnSetup: TMenuItem;
    MnuSep1: TMenuItem;
    Print1: TMenuItem;
    MnuOpt_PrnFile: TMenuItem;
    MnuOpt_PrnPrinter: TMenuItem;
    ReportPrinter1: TReportPrinter;
    FilePrinter1: TFilePrinter;
    Image1: TImage;
    MnuOpt_Preview: TMenuItem;
    PrinterSetupDialog1: TPrinterSetupDialog;
    RenderPDF: TRPRenderPDF;
    procedure FormCreate(Sender: TObject);
    procedure List_PrintersClick(Sender: TObject);
    procedure MnuOpt_ExitClick(Sender: TObject);
    procedure MnuOpt_AboutClick(Sender: TObject);
    procedure MnuOpt_UpdateClick(Sender: TObject);
    procedure List_BinsClick(Sender: TObject);
    procedure MnuOpt_PrnSetupClick(Sender: TObject);
    procedure List_PapersClick(Sender: TObject);
    procedure MnuOpt_PrnPrinterClick(Sender: TObject);
    procedure MnuOpt_PrnFileClick(Sender: TObject);
    procedure ReportPrint(Sender: TObject);
    procedure MnuOpt_PreviewClick(Sender: TObject);
  private
    { Private declarations }
    TheReport : TBaseReport;
    TypeStr   : ShortString;
    Function GetUniqueName : String;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses PreviewU, StrUtil;

{$R *.DFM}

Const
  VerStr = 'b500.002';

procedure TForm1.FormCreate(Sender: TObject);
begin
  MnuOpt_UpdateClick(Sender);
end;


{ File|Exit }
procedure TForm1.MnuOpt_ExitClick(Sender: TObject);
begin
  Close;
end;


{ Print|Print Direct to Printer - Print Test Page to selected Printer }
procedure TForm1.MnuOpt_PrnPrinterClick(Sender: TObject);
begin
  Try
    TypeStr := 'Print Direct to Printer';
    TheReport := ReportPrinter1;
    TheReport.Execute;
  Except
    On Ex:Exception Do
      MessageDlg ('The following error occured printing to the printer:' +
                  #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                  'Please notify Technical Support', mtError, [mbOk], 0);
  End;
end;

{ Print|Print To Preview Window - Print Test Page to the Print Preview window }
procedure TForm1.MnuOpt_PreviewClick(Sender: TObject);
Var
  RepFName  : String;
  Section   : Byte;
  Res       : Boolean;
begin
  Try
    { Setup Filename }
    Section := 1;
    RepFName := GetUniqueName;
    ReportFiler1.FileName := RepFName;

    { Print to File }
    Section := 2;
    TypeStr := 'Print Via File';
    TheReport := ReportFiler1;
    TheReport.Execute;

    { Create Preview Window }
    Section := 3;
    Form2 := TForm2.Create(Self);
    Try
      Form2.FilePreview1.FileName := ReportFiler1.FileName;
      Form2.FilePrinter1.FileName := ReportFiler1.FileName;

      Form2.StartPreview;

      Form2.ShowModal;
    Finally
      Form2.Free;
    End;

    { Delete File }
    Section := 4;
    If FileExists (RepFName) Then Begin
      Res := DeleteFile (RepFName);
    End; { If }
  Except
    On Ex:Exception Do
      Case Section Of
        1 : MessageDlg ('The following error occured generating a filename:' +
                        #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                        'Please notify Technical Support', mtError, [mbOk], 0);
        2 : MessageDlg ('The following error occured printing to the file:' +
                        #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                        'Please notify Technical Support', mtError, [mbOk], 0);
        3 : MessageDlg ('The following error occured printing to the preview window:' +
                        #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                        'Please notify Technical Support', mtError, [mbOk], 0);
        4 : MessageDlg ('The following error occured deleting the temporary file:' +
                        #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                        'Please notify Technical Support', mtError, [mbOk], 0);
    End; { Case }
  End;
end;


{ Print|Print Via File - Print Test Page to File and Print File }
procedure TForm1.MnuOpt_PrnFileClick(Sender: TObject);
Var
  RepFName  : String;
  Section   : Byte;
  Res       : Boolean;
NDRStream : TMemoryStream;
begin
  Try
    { Setup Filename }
    Section := 1;
    RepFName := GetUniqueName;
    ReportFiler1.FileName := RepFName;
    FilePrinter1.FileName := ReportFiler1.FileName;

    { Print to File }
    Section := 2;
    TypeStr := 'Print Via File';
    TheReport := ReportFiler1;
    TheReport.Execute;

    { Print File To Printer }
    Section := 3;
    FilePrinter1.Execute;

(*****
    { Print to PDF }
    NDRStream := TMemoryStream.Create;
    Try
      RenderPDF.InitFileStream(changeFileExt(ReportFiler1.FileName, '.PDF'));
      NDRStream.LoadFromFile (ReportFiler1.FileName);
      With TRPConverter.Create (NDRStream, RenderPDF) Do
        Try
          Generate;
        Finally
          Free;
        End;
    Finally
      NDRStream.Free;
    End;
*****)

    { Delete File }
    Section := 4;
    If FileExists (RepFName) Then Begin
      Res := DeleteFile (RepFName);
    End; { If }
  Except
    On Ex:Exception Do
      Case Section Of
        1 : MessageDlg ('The following error occured generating a filename:' +
                        #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                        'Please notify Technical Support', mtError, [mbOk], 0);
        2 : MessageDlg ('The following error occured printing to the file:' +
                        #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                        'Please notify Technical Support', mtError, [mbOk], 0);
        3 : MessageDlg ('The following error occured printing the file to the printer:' +
                        #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                        'Please notify Technical Support', mtError, [mbOk], 0);
        4 : MessageDlg ('The following error occured deleting the temporary file:' +
                        #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                        'Please notify Technical Support', mtError, [mbOk], 0);
      End; { Case }
  End;
end;


{ Print|Setup - Display Setup dialog for current printer }
procedure TForm1.MnuOpt_PrnSetupClick(Sender: TObject);
begin
  Try
    RpDev.PrinterSetupDialog;

    MnuOpt_UpdateClick(Sender);
  Except
    On Ex:Exception Do
      MessageDlg ('The following error occured running the printer setup:' +
                  #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                  'Please notify Technical Support', mtError, [mbOk], 0);
  End;
end;


{ Options|Update - Loads and Displays the Printer Information }
procedure TForm1.MnuOpt_UpdateClick(Sender: TObject);
Var
  I : SmallInt;
begin
  Try
    { Load Printers }
    List_Printers.Clear;
    If (RpDev.Printers.Count > 0) Then Begin
      For I := 0 To Pred(RpDev.Printers.Count) Do
        List_Printers.Items.Add (IntToStr(I) + #9 + RpDev.Printers[I]);
    End { If }
    Else
      List_Printers.Items.Add ('No Printers Defined');

    { Display Active Printer }
    If (RpDev.DeviceIndex <= Pred(List_Printers.Items.Count)) Then
      List_Printers.ItemIndex := RpDev.DeviceIndex
    Else
      MessageDlg ('Active printer doesn''t exist', mtError, [mbOk], 0);
  Except
    On Ex:Exception Do
      MessageDlg ('The following error occured loading the list with printers:' +
                  #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                  'Please notify Technical Support', mtError, [mbOk], 0);
  End;

  { Load Bins and Forms }
  List_PrintersClick(Sender);
end;


{ Help|About - Display Version and Copyright information }
procedure TForm1.MnuOpt_AboutClick(Sender: TObject);
begin
  { CJS - 2013-07-08 - ABSEXCH-14438 - update branding and copyright }
  MessageDlg ('Exchequer Printer Test Utility v' + VerStr +
              #10#13#10#13 +
              'Report Printer v' + ReportPrinter1.Version +
              #10#13#10#13 +
              StrUtil.GetCopyrightMessage,
              mtInformation, [mbOk], 0);
end;


procedure TForm1.List_PrintersClick(Sender: TObject);
Var
  I       : SmallInt;
  Section : Byte;
  BinNo   : Integer;       { Windows Bin Id }
  BinName : String;        { Windows Bin Description }
begin
  { Printer Selected - Load Bins and Forms }
  If (List_Printers.ItemIndex >= 0) Then Begin
    Try
      { Set Active Printer }
      Section := 1;
      RpDev.DeviceIndex := List_Printers.ItemIndex;

      { Load Bins }
      Section := 2;
      List_Bins.Clear;
      If (RpDev.Bins.Count > 0) Then Begin
        For I := 0 To Pred(RpDev.Bins.Count) Do Begin
          List_Bins.Items.AddObject (IntToStr(LongInt(RpDev.Bins.Objects[I])) + #9 + RpDev.Bins[I], RpDev.Bins.Objects[I]);

          { Select Current Bin }
          If (LongInt(RpDev.Bins.Objects[I]) = RpDev.DevMode.dmDefaultSource) Then
            List_Bins.ItemIndex := I;
        End; { If }
      End { If }
      Else
        List_Bins.Items.Add ('No Bins Defined');

      { Load Forms }
      Section := 3;
      List_Papers.Clear;
      If (RpDev.Papers.Count > 0) Then Begin
        For I := 0 To Pred(RpDev.Papers.Count) Do Begin
          List_Papers.Items.AddObject (IntToStr(LongInt(RpDev.Papers.Objects[I])) + #9 + RpDev.Papers[I], RpDev.Papers.Objects[I]);

          { Select Current Paper }
          If (LongInt(RpDev.Papers.Objects[I]) = RpDev.DevMode.dmPaperSize) Then
            List_Papers.ItemIndex := I;
        End; { For }
      End { If }
      Else
        List_Papers.Items.Add ('No Bins Defined');
    Except
      On Ex:Exception Do
        Case Section Of
          1 : MessageDlg ('The following error occured setting the active printer:' +
                          #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                          'Please notify Technical Support', mtError, [mbOk], 0);
          2 : MessageDlg ('The following error occured loading the bins list:' +
                          #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                          'Please notify Technical Support', mtError, [mbOk], 0);
          3 : MessageDlg ('The following error occured loading the forms list:' +
                          #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                          'Please notify Technical Support', mtError, [mbOk], 0);
        End; { Case }
    End;

  End; { If }
end;


procedure TForm1.List_BinsClick(Sender: TObject);
Var
  Section : Byte;
begin
  If (List_Bins.ItemIndex >= 0) Then
    Try
      { Set Default Bin }
      Section := 1;
      RPDev.DevMode.dmDefaultSource := LongInt(List_Bins.Items.Objects[List_Bins.ItemIndex]);
    Except
      On Ex:Exception Do
        Case Section Of
          1 : MessageDlg ('The following error occured setting the default bin:' +
                          #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                          'Please notify Technical Support', mtError, [mbOk], 0);
        End; { Case }
    End;
end;


procedure TForm1.List_PapersClick(Sender: TObject);
begin
  If (List_Papers.ItemIndex >= 0) Then
    Try
      { Set Default Paper }
      RPDev.DevMode.dmPaperSize := LongInt(List_Papers.Items.Objects[List_Papers.ItemIndex]);
    Except
      On Ex:Exception Do
        MessageDlg ('The following error occured setting the default bin:' +
                    #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                    'Please notify Technical Support', mtError, [mbOk], 0);
    End;
end;


{ Prints the Test Page }
procedure TForm1.ReportPrint(Sender: TObject);
Var
  pTop, pLeft, pRight, pBottom : Double;
  I                            : Byte;
begin
  With TheReport Do Begin
    pTop    := TopWaste + 1;
    pLeft   := LeftWaste + 1;
    pBottom := PageHeight - BottomWaste - 1;
    pRight  := PageWidth - RightWaste - 1;

    SetPen (clBlack, psSolid, -1, pmCopy);

    { Draw Border around page }
    MoveTo (pLeft,  pTop);
    LineTo (pRight, pTop);
    LineTo (pRight, pBottom);
    LineTo (pLeft,  pBottom);
    LineTo (pLeft,  pTop);

    SetFont ('Arial', 14); Bold := True;
    YPos := PageHeight * 0.3;
    PrintCenter (Application.Title, PageWidth / 2);

    For I := 1 To 2 Do CRLF;
    PrintCenter ('Version ' + VerStr, PageWidth / 2);

    SetFont ('Arial', 12); Bold := False;
    For I := 1 To 3 Do CRLF;
    PrintCenter (TypeStr, PageWidth / 2);

    For I := 1 To 5 Do CRLF;
    SetFont ('Arial', 10);
    PrintCenter ('A complete border should be visible on this page', PageWidth / 2);
    For I := 1 To 2 Do CRLF;
    PrintCenter ('A bitmap of a graph should be shown below', PageWidth / 2);

    { Print Bitmap of Graph }
    PrintBitmapRect((PageWidth * 0.1), (PageHeight * 0.6), (PageWidth * 0.9), (PageHeight * 0.9), Image1.Picture.BitMap);
  End; { With }
end;


{ Generate Unique Filename }
Function TForm1.GetUniqueName : String;
Var
  RepFName, SetDrive : String;
  FVar               : SmallInt;

  { Converts Long path to Short DOS 8.3 format path }
  Function PathToShort (Const FPath : ShortString) : ShortString;
  Var
    Temp1, Temp2 : PChar;
    PLen         : SmallInt;
  Begin
    Result := FPath;

    If (Trim(FPath) <> '') Then Begin
      Temp1 := StrAlloc (250);
      Temp2 := StrAlloc (250);

      StrPCopy (Temp1, Trim(FPath));
      PLen := GetShortPathName (Temp1, Temp2, StrBufSize (Temp2));
      If (PLen > 0) Then
        Result := Trim(StrPas(Temp2));

      StrDispose (Temp1);
      StrDispose (Temp2);
    End; { If }
  End;

Begin
  Result := '';
  SetDrive := PathToShort(ExtractFilePath (Application.ExeName));

  FVar := 0;
  Repeat
    RepFName := SetDrive + '!REP' + IntToStr(FVar) + '.SWP';
    Inc (FVar);
  Until (Not FileExists (RepFName)) Or (FVar > 9999);
  If (FVar > 9999) Then
    Raise ENoUnique.Create('Cannot Find Unique Filename');

  Result := RepFName;
End;

end.

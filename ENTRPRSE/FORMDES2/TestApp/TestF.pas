unit TestF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DLLInt, GlobVar, GlobType, StdCtrls, BorBtns, Mask, TEditVal,
  bkgroup, RpDefine, RpDevice, Enterprise01_TLB, ExtCtrls;

type
  TForm1 = class(TForm)
    Label4: TLabel;
    btnInitSbsForm: TButton;
    lstCompanyPath: TComboBox;
    Label5: TLabel;
    Panel1: TPanel;
    OpenDialog: TOpenDialog;
    Label1: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    edtOurRef: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label3: TLabel;
    edtForm: TEdit;
    FNBtn: TButton;
    Label9: TLabel;
    Label10: TLabel;
    Label81: Label8;
    Combo_Printers: TSBSComboBox;
    btnSetupPrinter: TButton;
    Radio_Printer: TBorRadio;
    Radio_Preview: TBorRadio;
    btnPrint: TButton;
    Label11: TLabel;
    Label12: TLabel;
    lblCopyright: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnInitSbsFormClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSetupPrinterClick(Sender: TObject);
    procedure FNBtnClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
  private
    { Private declarations }
    PrintHwnd     : HWnd;
    Inited : Boolean;
    PrnInfo   : TSBSPrintSetupInfo;
    ThisOrient : TOrientation;
    oToolkit : IToolkit;

    { Copies form printer setup info into the printer setup info }
    procedure FormPrnInfo(fmInfo : FormInfoType;Var PrnInfo : TSBSPrintSetupInfo);

    procedure PrintProgress(var Msg: TMessage); message WM_PrintProgress;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Uses StrUtil, StrUtils, CTKUtil, FormUtil;

procedure TForm1.FormCreate(Sender: TObject);
Var
  I : SmallInt;
begin
  PrintHwnd := 0;
  Inited := False;

  FillChar (PrnInfo, SizeOf(PrnInfo), #0);

  Caption := 'SbsForm Test Utililty (Build 002, SbsForm=' + sbsForm_GetDllVer + ')';
  Application.Title := Caption;

  lblCopyright.Caption := GetCopyrightMessage;

  oToolkit := CreateToolkitWithBackdoor;
  lstCompanyPath.Items.Clear;
  With oToolkit.Company Do
    For I := 1 To cmCount Do
      lstCompanyPath.Items.Add (IncludeTrailingPathDelimiter(Trim(cmCompany[I].CoPath)));
  I := lstCompanyPath.Items.IndexOf(ExtractFilePath(Application.ExeName));
  If (I >= 0) Then lstCompanyPath.ItemIndex := I;

  ThisOrient := poPortrait;

  With RpDev Do
  Begin
    If (Printers.Count > 0) Then
    Begin
      For I := 0 To Pred(Printers.Count) Do
        Combo_Printers.Items.Add (Printers[I]);

      If (RpDev.DeviceIndex <= Pred(Combo_Printers.Items.Count)) Then
        Combo_Printers.ItemIndex := RpDev.DeviceIndex
      Else
        Combo_Printers.ItemIndex := 0;
    End; { If }
  End; { With }

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If Inited Then sbsForm_DeInitialise;
  oToolkit := NIL;
end;

procedure TForm1.PrintProgress(var Msg: TMessage);
Begin // PrintProgress
  With Msg Do Begin
    { Mode passes in WParam }
    Case WParam Of
      { Set HWnd }
      2 : PrintHwnd := LParam;

      { Set InPrint Flag }
      3 : InPrint := (LParam = 1);

      { Check InPrint Flag }
      4 : SendMessage(LParam,WM_InPrint,Ord(InPrint),0);
   End; { Case }
  End; { With }
End; // PrintProgress


procedure TForm1.btnInitSbsFormClick(Sender: TObject);
Var
  CRTab : Boolean;
  sDataPath : ShortString;
  lRes : LongInt;
begin
  sDataPath := IncludeTrailingPathDelimiter(lstCompanyPath.Text);
  If DirectoryExists(sDataPath) And FileExists(sDataPAth + 'ExchqSS.Dat') Then
  Begin
    If Not Inited Then
    Begin
      lRes := oToolkit.OpenToolkit;
      If (lRes = 0) Then
      Begin
        With SystemInfo Do Begin
          ExVersionNo      := 11;
          MainForm         := Self;
          AppHandle        := Application;
          ExDataPath       := SetDrive;
          ControllerHandle := Nil;
          DefaultFont      := Nil;
          DebugOpen        := False;
        End; { With }

        CRTab := False;
        Inited := sbsForm_Initialise(SystemInfo, CRTab);
        ShowMessage (IfThen (Inited, 'SbsForm.Dll Initialised', 'Failed to initialise SBSForm.Dll'));

        Panel1.Enabled := Inited;
        btnPrint.Enabled := Inited;
        btnSetupPrinter.Enabled := Inited;
        FNBtn.Enabled := Inited;
      End // If (lRes = 0)
      Else
        ShowMessage ('Error ' + IntToStr(lRes) + ' opening the COM Toolkit');
    End;
  End; // If DirectoryExists(sDataPath) And FileExists(sDataPAth + 'ExchqSS.Dat')
end;


procedure TForm1.btnSetupPrinterClick(Sender: TObject);
Var
  oPrnInfo : TSBSPrintSetupInfo;
  oOrient  : TOrientation;
begin
  { save current print setup }
  oPrnInfo := RpDev.SBSSetupInfo;
  oOrient  := RpDev.Orientation;

  { Load PrnInfo with printer setup info }
  RpDev.SetPrnSetup(PrnInfo);
  RpDev.Orientation := ThisOrient;
  If RpDev.PrinterSetUpDialog Then Begin
    // Extract changes from local RpDev object
    PrnInfo := RpDev.SBSSetupInfo;

    // Update form with changes using Sender to identify what to change
    If (Sender = btnSetupPrinter) Then
      // Printer
      Combo_Printers.ItemIndex := RpDev.DeviceIndex
    Else
      Raise Exception.Create ('Error in TPrintDlg.SetupPrinter - "Unhandled Sender" - Please notify your Technical Support');

    ThisOrient:=RpDev.Orientation;
  End; { If }

  { restore previous print setup }
  RpDev.SetPrnSetup(oPrnInfo);
  RpDev.Orientation := oOrient;
end;

procedure TForm1.FNBtnClick(Sender: TObject);
Var
  FileInfo  :  SplitFNameType;
  SFile     :  ShortString;
  CurDirStr :  String;
  fmInfo    :  FormInfoType;
begin
  CurDirStr := GetCurrentDir;

  OpenDialog.FileName  := edtForm.Text;
  OpenDialog.InitialDir := SystemInfo.ExDataPath+FormsPath;

  Radio_Preview.Enabled:=BOff;
  Radio_Printer.Enabled:=BOff;

  If (OpenDialog.Execute) then
  Begin
    SetCurrentDir(CurDirStr);

    SFile:=Trim(PathtoShort(OpenDialog.FileName));

    If (SFile<>'') then
    Begin
      FileInfo:=SplitFileName(SFile);

      If (FileInfo.Extension='') then
        FileInfo.Extension:=DefExtension;

      If (ValidFormDef(FileInfo,True)) then
      Begin
        edtForm.Text:=FileInfo.Name;

        { reload printer info from form def }
        fmInfo:=GetFormInfo(FileInfo.Name);
        FormPrnInfo(fmInfo, PrnInfo);

//        If (PrnInfo.DevIdx=-1) then
//          PrnInfo.DevIdx:=DefSuggPrinter;

        If (PrnInfo.DevIdx>-1) and (PrnInfo.DevIdx <= Pred(Combo_Printers.Items.Count)) then
          Combo_Printers.ItemIndex := PrnInfo.DevIdx;
      end;
    end; {If Not empty file name }
  end
  else
    SetCurrentDir(CurDirStr);

  Radio_Preview.Enabled:=BOn;
  Radio_Printer.Enabled:=BOn;
End;

procedure TForm1.btnPrintClick(Sender: TObject);
Var
  PrBatch : PrintBatchRecType;
  lRes : LongInt;
begin
  If (Combo_Printers.ItemIndex >= 0)  Then
  Begin
    With oToolkit.Transaction Do
    Begin
      Index := thIdxOurRef;
      lRes := GetEqual(BuildOurRefIndex(edtOurRef.Text));
      If (lRes = 0) Then
      Begin
        PrnInfo := RpDev.SBSSetupInfo;

        PrnInfo.Preview := Radio_Preview.Checked;
        PrnInfo.NoCopies := 1;

        PrnInfo.fePrintMethod := 0;

        //PrnInfo.DevIdx := Combo_Printers.ItemIndex

        If PrintBatch_ClearBatch Then
        Begin
          FillChar(PrBatch, SizeOf(PrBatch), #0);
          With PrBatch Do
          Begin
            pbDefMode   := fmAllDocs;

            pbEFDName   := edtForm.Text;

            pbMainFNum  := 2; // InvF
            pbMainKPath := 2; // OurRef
            pbMainKRef  := thOurRef;

            pbTablFNum  := 3; // IDetailF
            pbTablKPath := 0; // IDFolioK
            pbTablKRef  := '1234';
            lRes := thFolioNum;
            Move (lRes, pbTablKRef[1], 4);

            pbDescr     := Self.Caption;
          End; // With PrBatch

          If PrintBatch_AddJob (PrBatch) Then
          Begin
            If PrintBatch_Print (Self.Caption, PrnInfo) Then
              ShowMessage ('Printed OK')
            Else
              ShowMessage ('Printing Failed');
          End // If PrintBatch_AddJob (PrBatch)
          Else
            ShowMessage ('PrintBatch_AddJob Failed');
        End // If PrintBatch_ClearBatch
        Else
          ShowMessage ('PrintBatch_ClearBatch Failed');
      End // If (lRes = 0)
      Else
        ShowMessage ('Error ' + IntToStr(lRes) + ' loading Transaction');
    End; // With oToolkit.Transaction
  End // If (Combo_Printers.ItemIndex >= 0)
  Else
    ShowMessage ('Please select a printer');
end;

{ Copies form printer setup info into the printer setup info }
procedure TForm1.FormPrnInfo(fmInfo : FormInfoType;Var PrnInfo : TSBSPrintSetupInfo);
Var
  oPrnInfo  : TSBSPrintSetupInfo;
  oOrient   : TOrientation;
Begin
  { save current print setup }
  oPrnInfo := RpDev.SBSSetupInfo;
  oOrient  := RpDev.Orientation;

  { Load lPrnInfo with printer setup info }
  RpDev.DeviceIndex := fmInfo.PrinterNo;
  With PrnInfo Do Begin
    DevIdx   := fmInfo.PrinterNo;
    FormNo   := fmInfo.PaperNo;
    FormName := RpDev.WalkList(RpDev.Papers, FormNo);
    BinNo    := fmInfo.BinNo;
    BinName  := RpDev.WalkList(RpDev.Bins, BinNo);
  End; { With }

  { restore previous print setup }
  RpDev.SetPrnSetup(oPrnInfo);
  RpDev.Orientation := oOrient;
End;


end.

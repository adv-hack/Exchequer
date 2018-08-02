unit Prntdlg2;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, BorBtns, Mask, Menus, sbsprint, RpDefine, RpDevice,
  GlobType, ComCtrls, bkgroup, VarConst, BTSupU1, EmlDetsF, ExtCtrls,
  SBSPanel, TCustom, FileCtrl, ExWrap1U;

type
  TPrintDlg = class(TForm)
    OpenDialog: TOpenDialog;
    FontDialog1: TFontDialog;
    PageControl1: TPageControl;
    tabshPrinter: TTabSheet;
    tabshFax: TTabSheet;
    tabshEmail: TTabSheet;
    Label81: Label8;
    Radio_Printer: TBorRadio;
    Radio_Preview: TBorRadio;
    Combo_Printers: TSBSComboBox;
    Button_Setup: TButton;
    Button_OK: TButton;
    Button_Cancel: TButton;
    CopiesF: Text8Pt;
    Label84: Label8;
    lstFaxPrinter: TSBSComboBox;
    btnFaxSetupPrinter: TButton;
    btnFaxOK: TButton;
    btnFaxCancel: TButton;
    SBSBackGroup1: TSBSBackGroup;
    SBSBackGroup2: TSBSBackGroup;
    Label88: Label8;
    edtFaxFromName: Text8Pt;
    edtFaxToName: Text8Pt;
    Label89: Label8;
    edtFaxFromNo: Text8Pt;
    Label810: Label8;
    edtFaxToNo: Text8Pt;
    Label811: Label8;
    Label812: Label8;
    memFaxMessage: TMemo;
    SBSBackGroup3: TSBSBackGroup;
    SBSBackGroup4: TSBSBackGroup;
    btnEmlOK: TButton;
    btnEmlCancel: TButton;
    SBSBackGroup5: TSBSBackGroup;
    chkEmlReader: TCheckBox;
    SBSBackGroup9: TSBSBackGroup;
    radFaxPrinter: TBorRadio;
    radFaxPreview: TBorRadio;
    raadEmlPrinter: TBorRadio;
    radEmlPreview: TBorRadio;
    Popup_Forms: TPopupMenu;
    Popup_Forms_Clear: TMenuItem;
    Popup_Forms_SepBar1: TMenuItem;
    Popup_Forms_Browse: TMenuItem;
    Popup_Forms_SepBar2: TMenuItem;
    Popup_Forms_1: TMenuItem;
    Popup_Forms_2: TMenuItem;
    Popup_Forms_3: TMenuItem;
    Popup_Forms_4: TMenuItem;
    Popup_Forms_6: TMenuItem;
    Popup_Forms_7: TMenuItem;
    Popup_Forms_8: TMenuItem;
    Popup_Forms_9: TMenuItem;
    Popup_Forms_10: TMenuItem;
    Popup_Forms_5: TMenuItem;
    Label85: Label8;
    lstFaxPriority: TSBSComboBox;
    grpEmailDets: TSBSGroup;
    Label816: Label8;
    Label817: Label8;
    Label818: Label8;
    Label819: Label8;
    Label820: Label8;
    Label82: Label8;
    edtEmlSendName: Text8Pt;
    edtEmlSubject: Text8Pt;
    edtEmlSendAddr: Text8Pt;
    memEmlMessage: TMemo;
    lvRecips: TListView;
    lstEmlPriority: TSBSComboBox;
    btnEmlAdd: TButton;
    btnEmlEdit: TButton;
    btnEmlDelete: TButton;
    Label814: Label8;
    edtEmlAttach: Text8Pt;
    btnAttachList: TButton;
    SBSBackGroup6: TSBSBackGroup;
    SBSBackGroup7: TSBSBackGroup;
    SBSBackGroup8: TSBSBackGroup;
    chkFaxCover: TBorCheck;
    lstEmlCompress: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Button_OKClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure Button_SetupClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure CopiesFChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Combo_PrintersClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure btnFaxOKClick(Sender: TObject);
    procedure btnEmlOKClick(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure lvRecipsEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure lvRecipsClick(Sender: TObject);
    procedure btnEmlEditClick(Sender: TObject);
    procedure btnEmlAddClick(Sender: TObject);
    procedure btnEmlDeleteClick(Sender: TObject);
    procedure Popup_Forms_ClearClick(Sender: TObject);
    procedure Popup_Forms_CacheClick(Sender: TObject);
    procedure btnAttachListClick(Sender: TObject);
    procedure edtFaxToNameDblClick(Sender: TObject);
    procedure lstFaxPrinterClick(Sender: TObject);
    procedure btnFaxSetupPrinterClick(Sender: TObject);
    procedure Label819DblClick(Sender: TObject);
  private
    { Private declarations }
    OkPressed  : Boolean;
    lPrnInfo   : TSBSPrintSetupInfo;

    procedure CheckForMAPI;
    Procedure SetListItem (ListObj  : TEmailDetsObjType;
                           ListItem : TListItem);

    Function Current_Page  :  Integer;

    Procedure ChangePage(NewPage  :  Integer);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure OutPrnInfoDetails;

  public
    { Public declarations }
    DefSuggPrinter{,
    SuggestPrinter}   : Integer;
    ShowForm         : Boolean;
    UseAutoMode      : Boolean;
    Automode         : Byte;
    NeedLabel        : Boolean;
    //UseForm          : ShortString;
    ThisFont         : TFont;
    ThisOrient       : TOrientation;
    PrnSetup         : TSBSPrintSetupInfo;

    Function  Execute(FormName : ShortString;Var PrnInfo : TSBSPrintSetupInfo) : Boolean;
    procedure FormPrnInfo(fmInfo : FormInfoType;Var PrnInfo : TSBSPrintSetupInfo);
  end;

  PHWND = ^HWND;

var
  PrintDlg: TPrintDlg;
  PrintToQueue,
  PrintToPrinter: Boolean;
  PrintShowForm : Boolean;




Procedure SetEcommsFromCust(Const LCust    :  CustRec;
                            Var   PrnInfo  :  TSBSPrintSetupInfo;
                                  ExLocal  :  TdMTExLocalPtr;
                                  Update   :  Boolean);

function EnumWndProc_FaxClnt (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;

Function SelectPrinter(Var PrnInfo : TSBSPrintSetupInfo) : Boolean;
Function SelectCDFFile (Var LastPath : ShortString) : Boolean;
Function SelectDBFFile (Var LastPath : ShortString) : Boolean;

Procedure InitEmailText (Var PrnInfo : TSBSPrintSetupInfo);

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{$R *.DFM}

Uses
     ETStrU,
     BTSupU2,
     BtrvU2,
     {$IFDEF FRM}
       DLLInt,
     {$ENDIF}

     GlobVar,

     CmpCtrlU,
     CommsInt,

     FormUtil,
     InvListU,
     CompUtil,
     EmlAttch,
     PWarnU,
     ExThrd2U,

     BTSFrmU1,
     PrintFrm;

Const
  {$I FilePath.Inc}

Var
  GotMAPI, TestedMAPI, GlobFaxCover : Boolean;

{---------------------------------------------------------------------------}

{ Callback function to identify the form designer window }
function EnumWndProc_FaxClnt (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;
var
  ClassName : string;
  Tag       : THandle;
Begin { EnumWndProc_FaxClnt }
  Result := True;
  SetLength (ClassName, 100);
  GetClassName (Hwnd, PChar (ClassName), Length (ClassName));
  ClassName := PChar (UpperCase(Trim(ClassName)));

  If (AnsiCompareText (ClassName, 'TFRMFAXCLIENT') = 0) then begin
    Tag := GetWindowLong (Hwnd, GWL_USERDATA);
    If (Tag = 1010) Then Begin
      FoundWnd^ := Hwnd;
      Result := False;
    End; { If }
  End; { If }
End; { EnumWndProc_FaxClnt }

{---------------------------------------------------------------------------}

Function GetReaderText : ANSIString;
Var
  SigFile : TStrings;
  FName   : ShortString;
Begin { GetReaderText }
  Result := '';

  FName := IncludeTrailingBackSlash(SetDrive) + PathMaster + 'reader.txt';
  If FileExists (FName) Then Begin
    // Load File into stringlist
    SigFile := TStringList.Create;
    Try
      SigFile.LoadFromFile(FName);

      Result := SigFile.Text;
    Finally
      SigFile.Destroy;
    End;
  End; { If GotFile }
End; { GetReaderText;

{-----------------------------------------------------------------------------}

Procedure InitEmailText (Var PrnInfo : TSBSPrintSetupInfo);
Var
  SigFile : TStrings;
  GotFile : Boolean;
  FName   : ShortString;
Begin { InitEmailText }
  // Initialise the message
  //PrnInfo.feEmailMsg := ''; Not necessary as otherewise any auto messages will be lost

  // Check the 'Send Reader' flag
  If PrnInfo.feEmailReader Then
    PrnInfo.feEmailMsg := GetReaderText + PrnInfo.feEmailMsg;

  // Check for logged in user's email signature file
  FName := IncludeTrailingBackSlash(SetDrive) + PathMaster + Trim(Copy(EntryRec^.Login, 1, 8)) + '.txt';
  GotFile := FileExists (FName);

  If (Not GotFile) Then Begin
    // Check for generic Company email signature
    FName := IncludeTrailingBackSlash(SetDrive) + PathMaster + 'company.txt';
    GotFile := FileExists (FName);
  End; { If (Not GotFile) }

  If GotFile Then Begin
    // Load File into stringlist
    SigFile := TStringList.Create;
    Try
      SigFile.LoadFromFile(FName);

      PrnInfo.feEmailMsg := PrnInfo.feEmailMsg + SigFile.Text;

    Finally
      SigFile.Destroy;
    End;
  End; { If GotFile }

  // Check for logged in user's fax signature file
  FName := IncludeTrailingBackSlash(SetDrive) + PathMaster + Trim(Copy(EntryRec^.Login, 1, 8)) + '.tx2';
  GotFile := FileExists (FName);

  If (Not GotFile) Then Begin
    // Check for generic Company fax signature
    FName := IncludeTrailingBackSlash(SetDrive) + PathMaster + 'company.tx2';
    GotFile := FileExists (FName);
  End; { If (Not GotFile) }

  If GotFile Then Begin
    // Load File into stringlist
    SigFile := TStringList.Create;
    Try
      SigFile.LoadFromFile(FName);

      PrnInfo.feFaxMsg := PrnInfo.feFaxMsg + SigFile.Text;
    Finally
      SigFile.Destroy;
    End;
  End; { If GotFile }
End; { InitEmailText }

{-----------------------------------------------------------------------------}

{ Public version }
Procedure SetEcommsFromCust(Const LCust    :  CustRec;
                            Var   PrnInfo  :  TSBSPrintSetupInfo;
                                  ExLocal  :  TdMTExLocalPtr;
                                  Update   :  Boolean);
Begin
end;

{ internal version }
Procedure SetEcommsFromCust2(Const LCust    :  CustRec;
                             Var   PrnInfo  :  TSBSPrintSetupInfo);
Begin
  With PrnInfo, LCust Do Begin
    feFaxTo:=Trim(Company);

    If (Trim(Contact)<>'') then
      feFaxTo:=feFaxTo+', '+Trim(Contact);

    feEmailTo:=feFaxTo;
    feFaxToNo:=Fax;

    feEmailToAddr:=EmailAddr;

    feEmailReader:=EmlSndRdr;
    feEmailZip:=Ord(EmlZipAtc);
  End; { With }
end;

{---------------------------------------------------------------------------}

Function SelectPrinter(Var PrnInfo : TSBSPrintSetupInfo) : Boolean;
Var
  PrnSel  : TPrintDlg;
Begin
  Result := False;

  Set_BackThreadMVisible(BOn);
  Set_BackThreadSuspend (BOn);

  PrnSel := TPrintDlg.Create(Application.MainForm);
  With PrnInfo Do
    Try
      InitEmailText (PrnInfo);

      PrnSel.PrnSetup := PrnInfo;
      PrnSel.CopiesF.Text := IntToStr(NoCopies);

      If PrnSel.Execute('',PrnInfo) Then Begin
        //PrnInfo := PrnSel.PrnSetup;
        Result := True;
      End;
    Finally
      PrnSel.Free;
    End;

  Set_BackThreadSuspend (BOff);
  Set_BackThreadMVisible(BOff);
End;

{---------------------------------------------------------------------------}

Function SelectCDFFile (Var LastPath : ShortString) : Boolean;
Var
  SaveDialog1: TSaveDialog;
Begin
  Set_BackThreadMVisible(BOn);
  Set_BackThreadSuspend (BOn);

  SaveDialog1 := TSaveDialog.Create(Application.MainForm);
  Try
    With SaveDialog1 Do Begin
      DefaultExt := 'CSV';
      FileName := LastPath;
      Filter := 'CSV Files|*.CSV|All Files|*.*';
      FilterIndex := 1;
      Options := [ofOverwritePrompt, ofPathMustExist];
      Title := 'Print CSV report to';
    End; { With }

    Result := SaveDialog1.Execute;

    If Result Then Begin
      { filename & path selected }
      LastPath := SaveDialog1.FileName;
    End; { If }
  Finally
    SaveDialog1.Free;
  End;

  Set_BackThreadSuspend (BOff);
  Set_BackThreadMVisible(BOff);
End;

{---------------------------------------------------------------------------}

Function SelectDBFFile (Var LastPath : ShortString) : Boolean;
Var
  SaveDialog1: TSaveDialog;
Begin
  Set_BackThreadMVisible(BOn);
  Set_BackThreadSuspend (BOn);

  SaveDialog1 := TSaveDialog.Create(Application.MainForm);
  Try
    With SaveDialog1 Do Begin
      DefaultExt := 'DBF';
      FileName := LastPath;
      Filter := 'DBF Files|*.DBF|All Files|*.*';
      FilterIndex := 1;
      Options := [ofOverwritePrompt, ofPathMustExist];
      Title := 'Save DBF File to';
    End; { With }

    Result := SaveDialog1.Execute;

    If Result Then Begin
      { filename & path selected }
      LastPath := SaveDialog1.FileName;
    End; { If }
  Finally
    SaveDialog1.Free;
  End;

  Set_BackThreadSuspend (BOff);
  Set_BackThreadMVisible(BOff);
End;

{---------------------------------------------------------------------------}

procedure TPrintDlg.FormCreate(Sender: TObject);
Var
  OldHWnd : HWnd;
  I       : Integer;
begin
  { Default To Printer tab and resize form }
  PageControl1.ActivePage := tabshPrinter;
  PageControl1Change(Sender);

  { Init local variables }
  OkPressed := False;
  NeedLabel:=False;

  ShowForm:=PrintShowForm;

  { Check to see if MAPI is available }
  {GotMapi := MAPIAvailable;}

  {FNF.Visible:=ShowForm;
  FNLab.Visible:=FNF.Visible;}

  With lvRecips,Columns do {* Set Column widths and captions here *}
  Begin
    Items[0].Width:=22;
    Items[1].Width:=108;
    Items[2].Width:=200;
    Items[1].Caption:='Name';
    Items[2].Caption:='Email address';
  end;

  {* Create dummy font *}

  ThisFont:=TFont.Create;
  try
    ThisFont.Assign(Self.Font);
  except
    ThisFont.Free;
    ThisFont:=nil;
  end;

  ThisOrient:=RpDev.Orientation;

  { load printers }
  With RpDev Do Begin
    If (Printers.Count > 0) Then Begin
      For I := 0 To Pred(Printers.Count) Do Begin
        Combo_Printers.Items.Add (Printers[I]);
      End; { For }

      If (RpDev.DeviceIndex <= Pred(Combo_Printers.Items.Count)) Then
        Combo_Printers.ItemIndex := RpDev.DeviceIndex
      Else
        Combo_Printers.ItemIndex := 0;

      lstFaxPrinter.Items.Assign(Combo_Printers.Items);
      lstFaxPrinter.ItemIndex := Combo_Printers.ItemIndex;
    End; { If }
  End; { With }

  DefSuggPrinter:=-1;

  { Default to global flag }
  If PrintToPrinter Then
    ActiveControl:=Radio_Printer
  Else
    ActiveControl:=Radio_Preview;

  If eCommsModule then
  Begin
    tabshFax.TabVisible := PChkAllowed_In(267);
    tabshEmail.TabVisible :=PChkAllowed_In(266);
  end;

  { If Faxing by Enterprise - check the client is running }
  If eCommsModule And (SyssEDI2^.EDI2Value.FxUseMAPI=0) Then
  Begin
    OldHwnd := 0;

    EnumWindows (@EnumWndProc_FaxClnt, Longint(@OldHwnd));

    If (OldHwnd = 0) or (Not PChkAllowed_In(267)) Then
    Begin
      { Wot No Fax Client - Disable Fax tab }
      tabshFax.TabVisible := False;
    End; { If }
  End; { If }
end;

{ == Procedure to set from prninfo record outputs == }

Procedure TPrintDlg.OutPrnInfoDetails;

Var
  {NewItem  : TlistItem;}
  ListObj  : TEmailDetsObjType;
Begin
  edtFaxToName.Text:=lPrnInfo.feFaxTo;
  edtFaxToNo.Text:=lPrnInfo.feFaxToNo;

  If (lPrnInfo.feEmailToAddr<>'') then
  Begin
    lvRecips.Items.Clear;

    ListObj := TEmailDetsObjType.Create;
    Try
      With ListObj Do Begin
        edType     := 0;
        edName     := lPrnInfo.feEmailTo;
        edAddress  := lPrnInfo.feEmailToAddr;
      End; { With ListObj }

      { Details specified - add to list }
      SetListItem (ListObj, lvRecips.Items.Add);
    Except
      ListObj.Destroy;
    End;
  End; { If }

  lstEmlCompress.ItemIndex := lPrnInfo.feEmailZip;
  ChkEmlReader.Checked:=lPrnInfo.feEmailReader;
end;

Function TPrintDlg.Current_Page  :  Integer;


Begin


  Result:=pcLivePage(PAgeControl1);

end;


Procedure TPrintDlg.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  If (Pages[NewPage].TabVisible) then
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}

Procedure TPrintDlg.WMCustGetRec(Var Message  :  TMessage);



Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);
              {ChangePage(GetNewTabIdx(PageControl1,LParam));}

    end;
  end; {With..}
end; {Proc..}


Function TPrintDlg.Execute(    FormName : ShortString;
                           Var PrnInfo  : TSBSPrintSetupInfo) : Boolean;

Var
  {NewItem  : TlistItem;}
  ListObj  : TEmailDetsObjType;
Begin
  {If (PrnInfo.DevIdx>-1) and (PrnInfo.DevIdx <= Pred(Combo_Printers.Items.Count)) then
    Combo_Printers.ItemIndex := PrnInfo.DevIdx;}
  Combo_Printers.ItemIndex := pfFind_DefaultPrinter(SyssVAT.VATRates.ReportPrnN);

  {If (PrnInfo.DevIdx>-1) and (PrnInfo.DevIdx <= Pred(Combo_Printers.Items.Count)) then
    lstFaxPrinter.ItemIndex := PrnInfo.DevIdx;}
  lstFaxPrinter.ItemIndex := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.FaxPrnN);

  lPrnInfo := PrnInfo;
  Combo_PrintersClick(Self);        { load lPrnInfo with current printer details }

  If (Not eCommsModule) then {* If module not enabled, then hide extra tabs *}
  Begin
    tabshFax.TabVisible := False;
    tabshEmail.TabVisible := False;
  end
  else
  Begin
    // HM 08/03/00: Done in FormCreate with checks on client - this just breaks it!
    //tabshFax.TabVisible := PChkAllowed_In(267);
    tabshEmail.TabVisible :=PChkAllowed_In(266);

    {* Check feTypes to hide extra tabs on specific modes *}
    With PrnInfo do
    Begin
      If ((feTypes AND 2) =2) then
        tabshFax.TabVisible := FALSE;

      If ((feTypes AND 4) =4) then
        tabshEmail.TabVisible := FALSE;
    end;
  end;

  { Setup Fax dialog }
  If (SyssEDI2^.EDI2Value.FxUseMAPI=1) Then
  Begin
    If TestedMAPI And (Not GotMAPI) Then
    Begin
      { MAPI not available - disable faxing }
      tabshFax.TabVisible := False;
    End; { If }

    { HM 10/05/00: Select MAPI Print Driver as default }
    //lstFaxPrinter.ItemIndex := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.FaxPrnN);

    { Priority only available for Enterprise faxing }
    lstFaxPriority.Enabled := False;
  End { If }
  Else Begin
    If (SyssEDI2^.EDI2Value.FxUseMAPI=2) Then Begin
      { 3rd party faxing software }
      //lstFaxPrinter.ItemIndex := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.FaxPrnN);
      lstFaxPrinter.Enabled := False;
    End { If }
    Else Begin
      { non-MAPI faxing - always using Async driver }
      //lstFaxPrinter.ItemIndex := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.FaxPrnN);
      lstFaxPrinter.Enabled := False;
      btnFaxSetupPrinter.Enabled:=BOff;
    End; { Else }
  End; { Else }

  edtFaxFromName.Text := Syss.UserName;
  edtFaxFromNo.Text := Syss.DetailFax;
  lstFaxPriority.ItemIndex := 1;  // Normal
  chkFaxCover.Checked := GlobFaxCover;

  { Setup Email dialog }
  If SyssEDI2^.EDI2Value.EmUseMAPI And TestedMAPI And (Not GotMAPI) Then
  Begin
    { MAPI not available - disable emailing }
    tabshEmail.TabVisible := False;
  End; { If }

  //edtEmlForm.Text := UseForm;
  //edtEmlCover.Text := SyssForms^.FormDefs.PrimaryForm[43];
  edtEmlSendName.Text := SyssEDI2^.EDI2Value.EmName;
  edtEmlSendAddr.Text := SyssEDI2^.EDI2Value.EmAddress;
  lstEmlPriority.ItemIndex := SyssEDI2^.EDI2Value.EmPriority;

  OutPrnInfoDetails;

  edtEmlSubject.Text := PrnInfo.feEmailSubj;
  memEmlMessage.Text := PrnInfo.feEmailMsg;
  memFaxMessage.Text := PrnInfo.feFaxMsg;

  { Display Form }
  ShowModal;
  PrnInfo := lPrnInfo;

  Result := OkPressed;

  If Result Then
  Begin
    { Copy details from form back into record }
    With PrnInfo Do
    Begin
      Case fePrintMethod Of
        0 : Begin { Printer }
              feCoverSheet := '';
              Preview := Radio_Preview.Checked;
              NoCopies := StrToInt(Trim(CopiesF.Text));
            End;
        1 : Begin { Fax }
              Preview := radFaxPreview.Checked;
              NoCopies := 1;

              GlobFaxCover := chkFaxCover.Checked;
              If GlobFaxCover Then
                feCoverSheet := 'AAAAAAAA'
              Else
                feCoverSheet := '';

              //UseForm := edtFaxForm.Text;

              If (SyssEDI2^.EDI2Value.FxUseMAPI<>1) Then
              Begin
                { Set printer to Async Pro Fax Driver }
                DevIdx := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.FaxPrnN);
                FormNo := 0;
                FormName := '';
                BinNo := 0;
                BinName := '';
              End; { If }
            End;
        2 : Begin { Email }
              Preview := radEmlPreview.Checked;
              NoCopies := 1;

              //UseForm := edtEmlForm.Text;

              { Set printer to Adobe PDF Writer }
              DevIdx := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.EmailPrnN);
              FormNo := 0;
              FormName := '';
              BinNo := 0;
              BinName := '';
            End;
      End; { Case }

      feFaxMethod     := SyssEDI2^.EDI2Value.FxUseMAPI;
      feFaxFrom       := edtFaxFromName.Text;
      feFaxFromNo     := edtFaxFromNo.Text;
      feFaxTo         := edtFaxToName.Text;
      feFaxToNo       := edtFaxToNo.Text;
      feFaxMsg        := memFaxMessage.Text;
      feFaxPriority   := lstFaxPriority.ItemIndex;

      feEmailMAPI     := SyssEDI2^.EDI2Value.EmUseMAPI;
      feEmailFrom     := edtEmlSendName.Text;
      feEmailFromAd   := edtEmlSendAddr.Text;
      feEmailSubj     := edtEmlSubject.Text;
      feEmailMsg      := memEmlMessage.Text;
      feEmailAttach   := edtEmlAttach.Text;    { Not available in this version }
      feEmailPriority := lstEmlPriority.ItemIndex;
      feEmailReader   := chkEmlReader.Checked;
      feEmailZIP      := lstEmlCompress.ItemIndex;
      feEmailAtType   := SyssEDI2^.EDI2Value.emAttchMode;

      feEmailTo       := '';
      feEmailCc       := '';
      feEmailBcc      := '';    { Not available in this version, but coded anyway! }

      { De-allocate objects in email recipients list whilst building recipient list }
      While (lvRecips.Items.Count > 0) Do Begin
        ListObj := lvRecips.Items.Item[0].Data;

        lvRecips.Items.Delete(0);

        If (fePrintMethod In [2, 3]) Then {*en431 XML}
          ListObj.UpdateEmStrings(feEmailTo, feEmailCc, feEmailBcc);

        ListObj.Free;
      End; { If }
    End; { With }
  End; { If }
End;

procedure TPrintDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Set global default flag }
  PrintToPrinter:= Radio_Printer.Checked;
end;


procedure TPrintDlg.FormDestroy(Sender: TObject);
begin
  If (Assigned(ThisFont)) then
    ThisFont.Free;
end;

procedure TPrintDlg.Button_OKClick(Sender: TObject);
Var
  Device, Driver, Port : Array [0..79] Of Char;
  DeviceMode           : THandle;
begin
  lPrnInfo.fePrintMethod := 0;

  If (Combo_Printers.ItemIndex >= 0)  Then
  Begin
    { Set printer }
    {If (ShowForm) then
      RpDev.DeviceIndex := Combo_Printers.ItemIndex;}
    {With Printer Do
    Begin
      PrinterIndex := Combo_Printers.ItemIndex;
      GetPrinter (Device, Driver, Port, DeviceMode);
      SetPrinter (Device, Driver, Port, DeviceMode);
    End; { With }

    OkPressed := True;
    ModalResult:=mrOk;
  End; { If }
end;

procedure TPrintDlg.Button_CancelClick(Sender: TObject);
begin
  OkPressed := False;
  ModalResult:=mrCancel;
end;

procedure TPrintDlg.Button_SetupClick(Sender: TObject);
Var
  oPrnInfo : TSBSPrintSetupInfo;
  oOrient  : TOrientation;
begin
  { save current print setup }
  oPrnInfo := RpDev.SBSSetupInfo;
  oOrient  := RpDev.Orientation;

  { Load PrnInfo with printer setup info }
  RpDev.SetPrnSetup(lPrnInfo);
  RpDev.Orientation := ThisOrient;
  If RpDev.PrinterSetUpDialog Then Begin
    lPrnInfo := RpDev.SBSSetupInfo;
    Combo_Printers.ItemIndex := RpDev.DeviceIndex;
    //lstFaxPrinter.ItemIndex := RpDev.DeviceIndex;

    ThisOrient:=RpDev.Orientation;
  End; { If }

  { restore previous print setup }
  RpDev.SetPrnSetup(oPrnInfo);
  RpDev.Orientation := oOrient;
end;

{ Copies form printer setup info into the printer setup info }
procedure TPrintDlg.FormPrnInfo(fmInfo : FormInfoType;Var PrnInfo : TSBSPrintSetupInfo);
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

procedure TPrintDlg.CopiesFChange(Sender: TObject);
begin
  With CopiesF do
  If (ActiveControl<>Button_Cancel) then
  Begin
    If (Not (StrToInt(Trim(Text)) In [1..99])) then
    Begin
      ShowMessage('The number of copies must be between 1-99');
      Text:='1';
      SetFocus;
    end;
  end;
end;

procedure TPrintDlg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  BTSupU2.GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TPrintDlg.FormKeyPress(Sender: TObject; var Key: Char);
begin
  BTSupU2.GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TPrintDlg.Combo_PrintersClick(Sender: TObject);
Var
  oPrnInfo : TSBSPrintSetupInfo;
  oOrient  : TOrientation;
begin
  { save current print setup }
  oPrnInfo := RpDev.SBSSetupInfo;
  oOrient  := RpDev.Orientation;

  RpDev.SetPrnSetup(lPrnInfo);

  { Load PrnInfo with printer setup info }
  RpDev.DeviceIndex := Combo_Printers.ItemIndex;
  //lPrnInfo := RpDev.SBSSetupInfo;           {*en431 XML}
  {ThisOrient := RpDev.Orientation;}
  lPrnInfo := RpDev.SBSSetupInfo2(lPrnInfo);  {*en431 XML}

  { restore previous print setup }
  RpDev.SetPrnSetup(oPrnInfo);
  RpDev.Orientation := oOrient;
end;

procedure TPrintDlg.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  If (AllowChange) then
  Begin
    Release_PageHandle(Sender);
    LockWindowUpDate(Handle);
  end;
end;


procedure TPrintDlg.PageControl1Change(Sender: TObject);
Var
  TmpIdx : LongInt;
begin
  { reformat screen }
  If (PageControl1.ActivePage = tabshPrinter) Then Begin
    { Print To Printer/Preview }
    Caption := 'Print Setup - Printer';

    Self.ClientHeight := 170;
    Self.ClientWidth := 407;
    PageControl1.Height := 161;
    PageControl1.Width := 397;

    { Setup printer details for selected printer }
    Combo_PrintersClick(Sender);
  End { If }
  Else Begin
    If (PageControl1.ActivePage = tabshFax) Then Begin
      { Print To Fax }
      Caption := 'Print Setup - Fax';

      Self.ClientHeight := 346;
      Self.ClientWidth := 407;
      PageControl1.Height := 337;
      PageControl1.Width := 397;

      { Setup printer details for selected printer }
      lstFaxPrinterClick(Sender);

      If (Not TestedMAPI) And (SyssEDI2^.EDI2Value.FxUseMAPI=1) Then
        CheckForMAPI;
    End { If }
    Else Begin
      { Print To Email }
      Caption := 'Print Setup - Email';

      Self.ClientHeight := 383;
      Self.ClientWidth := 489;
      PageControl1.Height := 374;
      PageControl1.Width := 479;

      { Move Email Details to Email page } {*en431 XML}
      If (grpEmailDets.Parent <> tabshEmail) Then Begin
        TmpIdx := lstEmlPriority.ItemIndex;
        grpEmailDets.Parent := tabshEmail;
        grpEmailDets.Top := 77;
        grpEmailDets.Left := 3;
        grpEmailDets.Visible := True;
        grpEmailDets.TabOrder := btnEmlOK.TabOrder;
        lstEmlPriority.ItemIndex := TmpIdx;
      End; { If }

      If (Not TestedMAPI) And (SyssEDI2^.EDI2Value.EmUseMAPI) Then
        CheckForMAPI;
    End; { Else }
  End; { Else }

  LockWindowUpDate(0);
end;

procedure TPrintDlg.btnFaxOKClick(Sender: TObject);
Const
  NumSet = [' ', '0'..'9'];
Var
  TmpStr : ShortString;
  I : Byte;
  OK : Boolean;
  fmInfo, fmInfo2 : FormInfoType;
begin
  btnFaxOK.SetFocus;

  lPrnInfo.fePrintMethod := 1;

  { Check a printer is specified }
  If (lstFaxPrinter.ItemIndex >= 0) Then Begin
    { Check To details are set }
    If (Trim(edtFaxToName.Text) <> '') And (Trim(edtFaxToNo.Text) <> '') Then Begin
      { Check number consists of valid characters }
      OK := True;
      TmpStr := edtFaxToNo.Text;
      For I := 1 To Length(TmpStr) Do Begin
        If Not (TmpStr[I] In NumSet) Then Begin
          { Invalid character }
          MessageDlg ('The To Number is invalid', mtWarning, [mbOk], 0);
          OK := False;
          Break;
        End; { If }
      End; { For }

      If OK Then Begin
        { AOK - Send fax }
        OkPressed := True;
        ModalResult:=mrOk;
      End; { If }
    End { If }
    Else Begin
      { Either To Name or To Number is invalid }
      MessageDlg ('The To Name and Number must be specified', mtWarning, [mbOk], 0);
    End; { If }
  End { If }
  Else Begin
    { Printer not selected }
    MessageDlg ('A printer must be selected', mtWarning, [mbOk], 0);
  End; { Else }
end;

procedure TPrintDlg.btnEmlOKClick(Sender: TObject);
Var
  OK : Boolean;
begin
  lPrnInfo.fePrintMethod := 2;

  { Validation ??? }
  If (lvRecips.Items.Count > 0) Then Begin
    { AOK - Send Email }
    OkPressed := True;
    ModalResult:=mrOk;
  End { If }
  Else Begin
    { no recipients specified }
    MessageDlg ('At least one recipient must be specified', mtWarning, [mbOk], 0);
    If btnEmlAdd.CanFocus Then btnEmlAdd.SetFocus;
  End; { Else }
end;

procedure TPrintDlg.CheckForMAPI;
Begin { CheckForMAPI }
  { Check to see if MAPI is available }
  GotMapi := MAPIAvailable;
  TestedMAPI := True;

  If (Not GotMAPI) Then Begin
    ShowMessage ('Fax and Email services through MAPI are not available');
    btnFaxOK.Enabled := False;
    btnEmlOK.Enabled := False;
  End; { If }
End; { CheckForMAPI }

procedure TPrintDlg.lvRecipsEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  AllowEdit := False;
end;

procedure TPrintDlg.lvRecipsClick(Sender: TObject);
Var
  CurPos  : TPoint;
  Tmp     : TListItem;
begin
  If (Not Assigned(lvRecips.Selected)) And (lvRecips.ViewStyle = vsReport) Then Begin
    { Try to highlight a match }
    GetCursorPos (CurPos);
    CurPos := lvRecips.ScreenToClient(CurPos);
    CurPos.X := 10;
    Tmp := lvRecips.GetItemAt(CurPos.X, CurPos.Y);
    If Assigned (Tmp) Then Begin
      lvRecips.Selected := Tmp;
      lvRecips.ItemFocused := Tmp;
    End; { If }
  End; { If }
end;


Procedure TPrintDlg.SetListItem (ListObj  : TEmailDetsObjType;
                                 ListItem : TListItem);
begin { SetListItem }
  With ListItem Do Begin
    Caption := ListObj.ToStr;
    SubItems.Clear;
    SubItems.Add(ListObj.edName);
    SubItems.Add(ListObj.edAddress);

    Data := ListObj;
  End; { With }
end; { SetListItem }


procedure TPrintDlg.btnEmlAddClick(Sender: TObject);
Var
  ListObj : TEmailDetsObjType;
begin
  ListObj := TEmailDetsObjType.Create;
  Try
    If EditEmailDets (ListObj, Self) Then Begin
      { Details specified - add to list }
      SetListItem (ListObj, lvRecips.Items.Add);
    End { If }
    Else Begin
      { Add cancelled - destroy object }
      ListObj.Destroy;
    End; { Else }
  Except
    ListObj.Destroy;
  End;
end;

procedure TPrintDlg.btnEmlEditClick(Sender: TObject);
Var
  ListObj : TEmailDetsObjType;
begin
  { Get object from list }
  If Not Assigned (lvRecips.Selected) Then Begin
    { This causes the line to be selected if they click in a column other than the first }
    lvRecipsClick(Sender);
  End; { If }

  If Assigned (lvRecips.Selected) Then Begin
    ListObj := lvRecips.Selected.Data;

    If EditEmailDets (ListObj, Self) Then Begin
      { Details specified - add to list }
      SetListItem (ListObj, lvRecips.Selected);
    End; { If }
  End; { If }
end;

procedure TPrintDlg.btnEmlDeleteClick(Sender: TObject);
Var
  ListObj : TEmailDetsObjType;
begin
  { Get object from list }
  If Assigned (lvRecips.Selected) Then Begin
    { Delete from list and ifoptions list }
    ListObj := lvRecips.Selected.Data;
    ListObj.Free;
    lvRecips.Selected.Delete;
  End; { If }
end;


procedure TPrintDlg.Popup_Forms_ClearClick(Sender: TObject);
begin
  With Popup_Forms Do Begin
    If PopupComponent Is Text8Pt Then
      With PopupComponent As Text8Pt Do Begin
        Text := '';
      End; { With PopupComponent As Text8Pt }
  End; { With Popup_Forms }
end;

procedure TPrintDlg.Popup_Forms_CacheClick(Sender: TObject);
begin
  With Popup_Forms Do Begin
    If Sender Is TMenuItem Then
      With Sender As TMenuItem Do Begin
        If PopupComponent Is Text8Pt Then
          With PopupComponent As Text8Pt Do Begin
            Text := Caption;
          End; { With PopupComponent As Text8Pt }
      End; { With Sender As TMenuItem }
  End; { With Popup_Forms }
end;

procedure TPrintDlg.btnAttachListClick(Sender: TObject);
Var
  frmEmailAttachs : TfrmEmailAttachs;
  CurDir          : String;
begin
  CurDir := GetCurrentDir;

  frmEmailAttachs := TfrmEmailAttachs.Create(Self);
  Try
    With frmEmailAttachs Do Begin
      BuildAttachList(edtEmlAttach.Text);

      ShowModal;

      If OK Then Begin
        edtEmlAttach.Text := GetAttachList;
      End; { If }
    End; { With frmEmailAttachs }
  Finally
    frmEmailAttachs.Free;
  End;

  SetCurrentDir (CurDir);
end;


procedure TPrintDlg.edtFaxToNameDblClick(Sender: TObject);
Var
  FoundCode           :  Str20;
  FoundOk, AltMod     :  Boolean;
begin
  If (Sender is Text8pt) then
    With (Sender as Text8pt) Do Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If (ActiveControl<>BtnFaxCancel) then Begin
        With Cust Do Begin
          If (CheckKey(Trim(Company),Text,Length(Trim(Company)),BOff)) then
            FoundCode:=Cust.CustCode;

          FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOn,99));

          If FoundOk Then Begin
            SetEcommsFromCust2(Cust,lprnInfo);

            OutPrnInfoDetails;
          End
          Else
            SetFocus;
        End; { With }
      End; { If }
    End; {with..}
end;

procedure TPrintDlg.lstFaxPrinterClick(Sender: TObject);
Var
  oPrnInfo : TSBSPrintSetupInfo;
  oOrient  : TOrientation;
begin
  { save current print setup }
  oPrnInfo := RpDev.SBSSetupInfo;
  oOrient  := RpDev.Orientation;

  RpDev.SetPrnSetup(lPrnInfo);

  { Load PrnInfo with printer setup info }
  RpDev.DeviceIndex := lstFaxPrinter.ItemIndex;
  //lPrnInfo := RpDev.SBSSetupInfo;           {*en431 XML}
  {ThisOrient := RpDev.Orientation;}
  lPrnInfo := RpDev.SBSSetupInfo2(lPrnInfo);  {*en431 XML}

  { restore previous print setup }
  RpDev.SetPrnSetup(oPrnInfo);
  RpDev.Orientation := oOrient;
end;

procedure TPrintDlg.btnFaxSetupPrinterClick(Sender: TObject);
Var
  oPrnInfo : TSBSPrintSetupInfo;
  oOrient  : TOrientation;
begin
  { save current print setup }
  oPrnInfo := RpDev.SBSSetupInfo;
  oOrient  := RpDev.Orientation;

  { Load PrnInfo with printer setup info }
  RpDev.SetPrnSetup(lPrnInfo);
  RpDev.Orientation := ThisOrient;
  If RpDev.PrinterSetUpDialog Then Begin
    lPrnInfo := RpDev.SBSSetupInfo;
    //Combo_Printers.ItemIndex := RpDev.DeviceIndex;
    lstFaxPrinter.ItemIndex := RpDev.DeviceIndex;

    ThisOrient:=RpDev.Orientation;
  End; { If }

  { restore previous print setup }
  RpDev.SetPrnSetup(oPrnInfo);
  RpDev.Orientation := oOrient;
end;

procedure TPrintDlg.Label819DblClick(Sender: TObject);
Var
  ListObj : TEmailDetsObjType;
begin
  ListObj := TEmailDetsObjType.Create;
  Try
    With ListObj Do Begin
      edType    := 0;
      edName    := edtEmlSendName.Text;
      edAddress := edtEmlSendAddr.Text;
    End; { With ListObj }

    SetListItem (ListObj, lvRecips.Items.Add);
  Except
    ListObj.Destroy;
  End;
end;



Initialization
  PrintToPrinter := True;
  PrintToQueue:=False;

  GotMAPI := False;
  TestedMAPI := False;

  GlobFaxCover := False;
end.

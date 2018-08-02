unit DlrListF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, IniFiles, StdCtrls, ExtCtrls, DlrDB, PlugInDB,
  oPlugLic;

type
  TfrmDealerList = class(TForm)
    lvDealers: TListView;
    MainMenu1: TMainMenu;
    Menu_File: TMenuItem;
    Menu_File_Exit: TMenuItem;
    Menu_Help: TMenuItem;
    Menu_Help_About: TMenuItem;
    btnAddDlr: TButton;
    btnEditDlr: TButton;
    btnDeleteDlr: TButton;
    btnWriteLic: TButton;
    SaveDialog1: TSaveDialog;
    procedure Menu_File_ExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Menu_Help_AboutClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddDlrClick(Sender: TObject);
    procedure btnEditDlrClick(Sender: TObject);
    procedure btnDeleteDlrClick(Sender: TObject);
    procedure btnWriteLicClick(Sender: TObject);
  private
    { Private declarations }
    oLicence : TPlugInUtilityLicenceType;

    Procedure AddDealerRow (Const DealerRec : DealerRecType);
    Procedure AddPlugInLicence (Const PlugInRec : PlugInRecType);
    Procedure LoadDealerList;
  public
    { Public declarations }
  end;

var
  frmDealerList: TfrmDealerList;

implementation

{$R *.dfm}

Uses DlrDetF;

//---------------------------------------------------------------------------

procedure TfrmDealerList.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;

  LoadDealerList;
end;

//-------------------------------------------------

procedure TfrmDealerList.FormDestroy(Sender: TObject);
begin
end;

//-------------------------------------------------

procedure TfrmDealerList.Menu_File_ExitClick(Sender: TObject);
begin
  Close;
end;

//-------------------------------------------------

procedure TfrmDealerList.Menu_Help_AboutClick(Sender: TObject);
begin
  Application.MessageBox('Licence Generator for Plug-In CD Release Code Utility' + #13 +
                         'Version 5.00.002' + #13#13 +
                         'Copyright 1986, 2002 Exchequer Software Ltd',
                         'About Plug-In Utility Licence Generator');
end;

//-------------------------------------------------

Procedure TfrmDealerList.AddDealerRow (Const DealerRec : DealerRecType);
Begin { AddDealerRow }
  With DealerRec, lvDealers.Items.Add Do Begin
    // Code
    Caption := dlrCode;

    // Company Name
    SubItems.Add (dlrCompany);

    // Expires
    SubItems.Add (FormatDateTime('DD/MM/YYYY', dlrExpiry));
  End; { With lvDealers.Items.Add }
End; { AddDealerRow }

//-------------------------------------------------

Procedure TfrmDealerList.LoadDealerList;
Begin { LoadDealerList }
  // Initialse the ListView
  lvDealers.Clear;

  // Load the list of Dealer Codes
  EnumDealers (AddDealerRow);
End; { LoadDealerList }

//-------------------------------------------------

procedure TfrmDealerList.btnAddDlrClick(Sender: TObject);
begin
  If DisplayDealerDetail ('', mdAdd) Then
    LoadDealerList;
end;

//-------------------------------------------------

procedure TfrmDealerList.btnEditDlrClick(Sender: TObject);
begin
  If (lvDealers.SelCount = 1) Then
    If DisplayDealerDetail (lvDealers.Selected.Caption, mdEdit) Then
      LoadDealerList;
end;

//-------------------------------------------------

procedure TfrmDealerList.btnDeleteDlrClick(Sender: TObject);
begin
  If (lvDealers.SelCount = 1) Then
    If DisplayDealerDetail (lvDealers.Selected.Caption, mdDelete) Then
      LoadDealerList;
end;

//---------------------------------------------------------------------------

Procedure TfrmDealerList.AddPlugInLicence (Const PlugInRec : PlugInRecType);
Begin { AddPlugInLicence }
  If Assigned(oLicence) Then
    With PlugInRec Do
      oLicence.AddPlugIn (piCode, piName, piExpiry);
End; { AddPlugInLicence }

//-------------------------------------------------

procedure TfrmDealerList.btnWriteLicClick(Sender: TObject);
Var
  DealerRec : DealerRecType;
  Res       : LongInt;
begin
  // Check a dealer is selected
  If (lvDealers.SelCount = 1) Then Begin
    // create a licencing object
    oLicence := TPlugInUtilityLicenceType.Create;
    With oLicence Do
      Try
        // get the Dealer details and copy them into the licencing object
        DealerRec := LoadDealer (lvDealers.Selected.Caption);
        oLicence.Licencee := DealerRec.dlrCompany;
        oLicence.Expiry := DealerRec.dlrExpiry;

        // Get the Plug-Ins for the Dealer
        EnumDealerPlugIns (DealerRec.dlrCode, AddPlugInLicence);

        // Check there are some Plug-Ins to Licence
        If (oLicence.PlugInCount > 0) Then
          With SaveDialog1 Do Begin
            // Look in .INI for optional default directory
            With TIniFile.Create (ChangeFileExt(Application.ExeName, '.DAT')) Do
              Try
                InitialDir := ReadString ('Options', 'DefLicPath', ExtractFilePath(Application.ExeName));
              Finally
                Free;
              End;

            If Execute Then Begin
              // Create Licence in specified directory
              Res := oLicence.Save (ExtractFilePath(FileName) + 'ENPLUGIN.PIL');

              If (Res = 0) Then Begin
                If FileExists (ExtractFilePath(FileName + 'ENPLUGIN.EXE')) Then Begin
                  // Run test version of Plug-Ins Licencing system to test the new licence


                End; { If FileExists (... }
              End { If (Res = 0) }
              Else
                ShowMessage ('Error ' + IntToStr(Res) + ' saving the licence');
            End; { If Execute }
          End; { With SaveDialog1 }
      Finally
        FreeAndNIL (oLicence);
      End;
  End; { If (lvDealers.SelCount = 1) }
end;

//---------------------------------------------------------------------------

end.

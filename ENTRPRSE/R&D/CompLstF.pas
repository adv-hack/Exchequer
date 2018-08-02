unit CompLstF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, enBureauIntF, ExtCtrls, uMultiList, uDBMultiList, StdCtrls,
  uExDatasets, uComTKDataset, Menus, ShellAPI, EntWindowSettings;

type
  TfrmCompanyList = class(TForm)
    mulCompanyList: TDBMultiList;
    panButtons: TPanel;
    CloseBtn: TButton;
    ScrollBox1: TScrollBox;
    btnOpenEnterprise: TButton;
    btnOpenEBusiness: TButton;
    btnOpenSentimail: TButton;
    bdsCompanyList: TComTKDataset;
    PopupMenu1: TPopupMenu;
    popOpenEnterprise: TMenuItem;
    N1: TMenuItem;
    popOpenEBusiness: TMenuItem;
    popOpenSentimail: TMenuItem;
    PopupOpt_SepBar2: TMenuItem;
    popFormProperties: TMenuItem;
    N3: TMenuItem;
    popSavePosition: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bdsCompanyListGetFieldValue(Sender: TObject; ID: IDispatch;
      FieldName: String; var FieldValue: String);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mulCompanyListCellPaint(Sender: TObject; ColumnIndex,
      RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
      var TextBrush: TBrush; var TextAlign: TAlignment);
    procedure CloseBtnClick(Sender: TObject);
    procedure btnOpenEnterpriseClick(Sender: TObject);
    procedure btnOpenEBusinessClick(Sender: TObject);
    procedure btnOpenSentimailClick(Sender: TObject);
    procedure popFormPropertiesClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure mulCompanyListRowDblClick(Sender: TObject;
      RowIndex: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    // Variable to store the handles to the dynamically loaded EnBureau.Dll
    _EnBureauDLL         : THandle;
    _StartupBureau       : Function (Const UserCode : ShortString) : LongInt; StdCall;
    _GetBureauDataObject : Function : IBureauDataObject; StdCall;
    _CloseDownBureau     : Function : LongInt; StdCall;

    // Flag indicates whether the user has restored the original colours/positions
    DoneRestore : Boolean;

    // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MinSizeX : LongInt;
    MinSizeY : LongInt;

    FSettings : IWindowSettings;

    Function GetcoDirSwitch : ShortString;
    Function GetUserParam : ShortString;

    // Controls the loading/saving of the colours and positions
    //
    // Mode   0=Load Details, 1=Save Details, 2=Delete Details
    procedure SetColoursUndPositions (Const Mode : Byte);

    // Update the buttons panel based on the buttons visible status
    procedure UpdateButtonsPositions;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
  end;

var
  frmCompanyList: TfrmCompanyList;

implementation

{$R *.dfm}

Uses GlobVar, BTSupU1,
     APIUtil,
     uSettings;        // Colour/Position editing and saving routines

//-------------------------------------------------------------------------

procedure TfrmCompanyList.FormCreate(Sender: TObject);
Var
  iBureauData : IBureauDataObject;
  lStatus     : LongInt;
begin
  //PR: 10/11/2010
  FSettings := GetWindowSettings(Self.Name);
  if Assigned(FSettings) then
    FSettings.LoadSettings;

  ClientHeight := 194;
  ClientWidth := 470;

  // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
  MinSizeX := (Width - ClientWidth) + 420;        // take border sizing &
  MinSizeY := (Height - ClientHeight) + 140;      // captions into account

  // Load colours/positions/sizes/etc...
  DoneRestore := False;
  SetColoursUndPositions (0);
  oSettings.Free;

  If FileExists (ExtractFilePath(Application.ExeName) + 'ENBUREAU.DLL') Then
  Begin
    // Load EnBureau.DLL, start it up and get the Data Access Object
    _StartupBureau       := NIL;
    _GetBureauDataObject := NIL;
    _CloseDownBureau     := NIL;

    // Dynamically load the EnBureau.Dll
    _EnBureauDLL := LoadLibrary('ENBUREAU.DLL');
    Try
      If (_EnBureauDLL > HInstance_Error) Then
      Begin
        // Get handle of functions in EnBureau.Dll
        _StartupBureau := GetProcAddress(_EnBureauDLL, 'StartupBureau');
        _GetBureauDataObject := GetProcAddress(_EnBureauDLL, 'GetBureauDataObject');
        _CloseDownBureau := GetProcAddress(_EnBureauDLL, 'CloseDownBureau');

        If Assigned(_StartupBureau) And Assigned(_GetBureauDataObject) And Assigned(_CloseDownBureau) Then
        Begin
          // AOK - Startup the Bureau DLL and get the data object for the list
          lStatus := _StartupBureau (GetUserParam);
          If (lStatus = 0) Then
          Begin
            // Get the data access object, setup the security and activate the list
            iBureauData := _GetBureauDataObject;
            Try
              // Setup the security on the buttons
              btnOpenEnterprise.Visible := iBureauData.bdoAllowEnterprise;
              btnOpenEBusiness.Visible := iBureauData.bdoAllowEBusiness;
              btnOpenSentimail.Visible := iBureauData.bdoAllowSentimail;
              UpdateButtonsPositions;

              bdsCompanyList.ToolkitObject := iBureauData;
              mulCompanyList.Active := True;
            Finally
              iBureauData := NIL;
            End; // Try,..Finally
          End // If (lStatus = 0)
          Else
          Begin
            Case lStatus Of
              1000 : Raise Exception.Create ('Unknown Error opening the Bureau Module');
              1001 : Raise Exception.Create ('The Bureau Module was opened with an Invalid User Code - Permission Denied');
            End; // Case lStatus
          End; // Else
        End // If Assigned(_StartupBureau) ...
        Else
        Begin
          // Error getting handles to functions - unload library
          FreeLibrary(_EnBureauDLL);
          _EnBureauDLL         := 0;
          _StartupBureau       := Nil;
          _GetBureauDataObject := Nil;
          _CloseDownBureau     := Nil;

          Raise Exception.Create ('The functions within the EnBureau.Dll component could not be loaded, please notify your technical support');
        End; // If (Not Assigned(...
      End // If (_EnBureauDLL > HInstance_Error)
      Else
      Begin
        // Failed to load EnBureau.Dll
        _EnBureauDLL := 0;
        Raise Exception.Create ('The EnBureau.Dll component could not be loaded, please notify your technical support');
      End;
    Except
      On E:Exception Do
      Begin
        ShowMessage (E.Message);
        FreeLibrary(_EnBureauDLL);
        _EnBureauDLL := 0;
        _StartupBureau       := Nil;
        _GetBureauDataObject := Nil;
        _CloseDownBureau     := Nil;
      End; // On E:Exception 
    End; { Try }
  End // If FileExists (...
  Else
  Begin
    Raise Exception.Create ('The EnBureau.Dll component could not be found, please notify your technical support');
  End;
end;

//------------------------------

procedure TfrmCompanyList.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := True;

  If mulCompanyList.Active Then
  Begin
    // Save colours/positions/sizes/etc...
    SetColoursUndPositions (1);
    oSettings.Free;

    // Shutdown the list and remove the reference to the object
    mulCompanyList.Active := False;
    bdsCompanyList.ToolkitObject := NIL;
    PostMessage (Self.Handle, WM_CLOSE, 0, 0);
  End; // If mulCompanyList.Active
end;

procedure TfrmCompanyList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If mulCompanyList.Active Then
  Begin
    // Save colours/positions/sizes/etc...
    SetColoursUndPositions (1);
    oSettings.Free;

    // Shutdown the list and remove the reference to the object
    mulCompanyList.Active := False;
    bdsCompanyList.ToolkitObject := NIL;
  End; // If mulCompanyList.Active

  // Automatically destroy the form
  Action := caFree;
end;

//------------------------------

procedure TfrmCompanyList.FormDestroy(Sender: TObject);
begin
  // Unload EnBureau.Dll
  If (_EnBureauDLL <> 0) Then
  Begin
    // Call CloseDownBureau to close Btrieve files, etc...
    If Assigned(_CloseDownBureau) Then
    Begin
      _CloseDownBureau;
    End; // If Assigned(_CloseDownBureau)

    FreeLibrary(_EnBureauDLL);
    _EnBureauDLL := 0;
  End; // If (_EnBureauDLL <> 0)
  FSettings := nil;
end;

//-------------------------------------------------------------------------

procedure TfrmCompanyList.FormResize(Sender: TObject);
begin
  LockWindowUpdate (Handle);

  // Resize/reposition the button containing the panels
  panButtons.Left := ClientWidth - panButtons.Width - 4;
  panButtons.Height := ClientHeight - 7;

  // Resize list component
  mulCompanyList.Height := panButtons.Height;
  mulCompanyList.Width := panButtons.Left - 7;

  LockWindowUpdate (0);
end;

//-------------------------------------------------------------------------

Procedure TfrmCompanyList.WMGetMinMaxInfo(Var Message : TWMGetMinMaxInfo);
Begin
  With Message.MinMaxInfo^ Do
  Begin
    ptMinTrackSize.X:=MinSizeX;
    ptMinTrackSize.Y:=MinSizeY;
  End; // With Message.MinMaxInfo^

  Message.Result:=0;

  Inherited;
end;

//-------------------------------------------------------------------------

procedure TfrmCompanyList.bdsCompanyListGetFieldValue(Sender: TObject;
  ID: IDispatch; FieldName: String; var FieldValue: String);
Var
  iCompany : IBureauDataObject;
begin
  iCompany := Id As IBureauDataObject;

  Case FieldName[1] Of
    '0'  : FieldValue := Trim(iCompany.bdoCompanyCode);
    '1'  : Begin
             If (iCompany.bdoErrorStatus = 1) Then
             Begin
               // OK - Check whether the Company Path should be shown
               FieldValue := Trim(iCompany.bdoCompanyName);
             End // If (iCompany.bdoErrorStatus = 1)
             Else
             Begin
               // Error - display error message
               FieldValue := iCompany.bdoErrorString;
             End; // Else
           End;
  End; // Case FieldName[1]

  iCompany := NIL;
end;

//-------------------------------------------------------------------------

procedure TfrmCompanyList.mulCompanyListCellPaint(Sender: TObject;
  ColumnIndex, RowIndex: Integer; var OwnerText: String;
  var TextFont: TFont; var TextBrush: TBrush; var TextAlign: TAlignment);
Var
  iBureau : IBureauDataObject;
begin
  // Get a reference to the data source object
  iBureau := bdsCompanyList.ToolkitObject As IBureauDataObject;

  If iBureau.CompanyStatus (mulCompanyList.DesignColumns[0].Items[RowIndex]) Then
  Begin
    // Problem - highlight row in bold
    TextFont.Style := TextFont.Style + [fsBold];
  End; // If (CompInfoCache.CompanyCodeDetailsByCode [CompCode].CompAnal > 1)

  // Remove the reference to the data source object
  iBureau := NIL;
end;

//-------------------------------------------------------------------------

// Update the buttons panel based on the buttons visible status
procedure TfrmCompanyList.UpdateButtonsPositions;
Var
  NextBtnTop : SmallInt;
Begin // UpdateButtonsPositions
  LockWindowUpdate (Handle);

  NextBtnTop := 1;
  If btnOpenEnterprise.Visible Then
  Begin
    btnOpenEnterprise.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnOpenEnterprise.Height + 3;
  End; // If btnOpenEnterprise.Visible
  If btnOpenEBusiness.Visible Then
  Begin
    btnOpenEBusiness.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnOpenEBusiness.Height + 3;
  End; // If btnOpenEBusiness.Visible
  If btnOpenSentimail.Visible Then
  Begin
    btnOpenSentimail.Top := NextBtnTop;
    NextBtnTop := NextBtnTop + btnOpenSentimail.Height + 3;
  End; // If btnOpenSentimail.Visible

  LockWindowUpdate (0);
End; // UpdateButtonsPositions

//-------------------------------------------------------------------------

procedure TfrmCompanyList.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

//------------------------------

procedure TfrmCompanyList.btnOpenEnterpriseClick(Sender: TObject);
Type
  {$H-}
  CompInfoType = Record
    CompPath   : Str100;
  End; { CompInfoType }
  {$H+}
Var
  CompInfo        : ^CompInfoType;
  iBureau         : IBureauDataObject;
begin
  If (mulCompanyList.Selected > -1) And btnOpenEnterprise.Visible Then
  Begin
    iBureau := bdsCompanyList.GetRecord As IBureauDataObject;
    Try
      // Build the packet of info to be sent to EParentU
      GetMem (CompInfo, SizeOf (CompInfo^));
      FillChar (CompInfo^, SizeOf(CompInfo^), #0);
      CompInfo^.CompPath := Trim(iBureau.bdoCompanyPath);

      PostMessage (Self.Handle, WM_CLOSE, 0, 0);
      PostMessage ((Owner As TForm).Handle, WM_ChangeComp, 1, LongInt(CompInfo));
    Finally
      iBureau := NIL;
    End; // Try..Finally
  End; // If (mulCompanyList.Selected > -1) And btnOpenEnterprise.Visible
end;

//------------------------------

procedure TfrmCompanyList.mulCompanyListRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  btnOpenEnterpriseClick(Sender);
end;

//------------------------------

procedure TfrmCompanyList.btnOpenEBusinessClick(Sender: TObject);
Var
  cmdFile, cmdPath, cmdParams : ANSIString;
  iBureau : IBureauDataObject;
begin
  If (mulCompanyList.Selected > -1) And btnOpenEBusiness.Visible Then
  Begin
    iBureau := bdsCompanyList.GetRecord As IBureauDataObject;
    Try
      If (iBureau.bdoErrorStatus = 1) Or iBureau.bdoDemoSystem Then
      Begin
        cmdPath := ExtractFilePath(Application.ExeName);
        cmdFile := 'EBusAdmn.Exe';
        cmdParams := '/EXCHQ: ' + ExtractFilePath(Application.ExeName) +
                     ' /CODIR: ' + GetCoDirSwitch +
                     ' /DIR: ' + Trim(iBureau.bdoCompanyPath);

        If (ShellExecute (0, NIL, PCHAR(cmdFile), PCHAR(cmdParams), PCHAR(cmdPath), SW_SHOW) > 32) Then
        Begin
          Close;
        End; // If (ShellExecute (...
      End; // If (iBureau.bdoErrorStatus = 0) Or iBureau.bdoDemoSystem
    Finally
      iBureau := NIL;
    End; // Try..Finally
  End; // If (mulCompanyList.Selected > -1) And btnOpenEBusiness.Visible
end;

//------------------------------

procedure TfrmCompanyList.btnOpenSentimailClick(Sender: TObject);
Var
  cmdFile, cmdPath, cmdParams : ANSIString;
  iBureau : IBureauDataObject;
begin
  If (mulCompanyList.Selected > -1) And btnOpenSentimail.Visible Then
  Begin
    iBureau := bdsCompanyList.GetRecord As IBureauDataObject;
    Try
      If (iBureau.bdoErrorStatus = 1) Or iBureau.bdoDemoSystem Then
      Begin
        cmdPath := ExtractFilePath(Application.ExeName);
        cmdFile := 'ELMANAGE.Exe';
        cmdParams := '/CODIR: ' + GetcoDirSwitch +
                     ' /DIR: ' + Trim(iBureau.bdoCompanyPath);

        If (ShellExecute (0, NIL, PCHAR(cmdFile), PCHAR(cmdParams), PCHAR(cmdPath), SW_SHOW) > 32) Then
        Begin
          Close;
        End; // If (ShellExecute (...
      End; // If (iBureau.bdoErrorStatus = 0) Or iBureau.bdoDemoSystem
    Finally
      iBureau := NIL;
    End; // Try..Finally
  End; // If (mulCompanyList.Selected > -1) And btnOpenSentimail.Visible
end;

//-------------------------------------------------------------------------

// Controls the loading/saving of the colours and positions
//
// Mode   0=Load Details, 1=Save Details, 2=Delete Details
procedure TfrmCompanyList.SetColoursUndPositions (Const Mode : Byte);
Var
  WantAutoSave : Boolean;
Begin // SetColoursUndPositions
  Case Mode Of
    0 : Begin
          if Assigned(FSettings) and not FSettings.UseDefaults then
          begin
            FSettings.SettingsToWindow(Self);
            FSettings.SettingsToParent(mulCompanyList);
          end;
        End;
    1 : If (Not DoneRestore) Then
        Begin
          if Assigned(FSettings) then
          begin
            FSettings.ParentToSettings(mulCompanyList, mulCompanyList);
            FSettings.WindowToSettings(Self);
            FSettings.SaveSettings(popSavePosition.Checked);
          end;
        End; // If (Not DoneRestore)
    2 : Begin
          DoneRestore := True;
          popSavePosition.Checked := False;
        End;
  Else
    Raise Exception.Create ('TfrmMaintainCompanies.SetColoursUndPositions - Unknown Mode (' + IntToStr(Ord(Mode)) + ')');
  End; // Case Mode
End; // SetColoursUndPositions
(*
procedure TfrmCompanyList.SetColoursUndPositions (Const Mode : Byte);
Var
  WantAutoSave : Boolean;
Begin // SetColoursUndPositions
  sMiscdirLocation := SetDrive;
  Case Mode Of
    0 : Begin
          oSettings.LoadForm (Self, WantAutoSave);
          popSavePosition.Checked := WantAutoSave;
          oSettings.LoadList (mulCompanyList, Self.Name);
        End;
    1 : If (Not DoneRestore) Then
        Begin
          // Only save the details if the user didn't select Restore Defaults
          oSettings.SaveForm (Self, popSavePosition.Checked);
          oSettings.SaveList (mulCompanyList, Self.Name);
        End; // If (Not DoneRestore)
    2 : Begin
          DoneRestore := True;
          oSettings.RestoreFormDefaults (Self.Name);
          oSettings.RestoreListDefaults (mulCompanyList, Self.Name);
          popSavePosition.Checked := False;
        End;
  Else
    Raise Exception.Create ('TfrmMaintainCompanies.SetColoursUndPositions - Unknown Mode (' + IntToStr(Ord(Mode)) + ')');
  End; // Case Mode
End; // SetColoursUndPositions
*)

//-------------------------------------------------------------------------

procedure TfrmCompanyList.popFormPropertiesClick(Sender: TObject);
begin
  // Call the colours dialog
  Case oSettings.Edit(mulCompanyList, Self.Name, NIL) Of
    mrOK              : ; // no other controls to colour
    mrRestoreDefaults : SetColoursUndPositions (2);
  End; // Case oSettings.Edit(...
  oSettings.Free;
end;

//-------------------------------------------------------------------------

Function TfrmCompanyList.GetcoDirSwitch : ShortString;
Var
  I : SmallInt;
Begin // GetcoDirSwitch
  // Default to application path
  Result := ExtractFilePath(Application.ExeName);

  If (ParamCount > 0) Then
  Begin
    For I := 1 To ParamCount Do
    Begin
      If (ParamStr(I) = CoDirSwitch) And (I < ParamCount) Then
      Begin
        Result := ParamStr(I + 1);
        Break;
      End; // If (ParamStr(I) = CoDirSwitch) And (I < ParamCount)
    End; // for I
  End; // If (ParamCount > 0)
End; // GetcoDirSwitch

//-------------------------------------------------------------------------

Function TfrmCompanyList.GetUserParam : ShortString;
Var
  sUser : ShortString;
  I     : SmallInt;
Begin // GetUserParam
  // Default to application path
  Result := '';

  If (ParamCount > 0) Then
  Begin
    For I := 1 To ParamCount Do
    Begin
      sUser := ParamStr(I);
      If (Copy(sUser, 1, 6) = '/BUSR:') Then
      Begin
        system.Delete (sUser, 1, 6);
        Result := sUser;
        Break;
      End; // If (ParamStr(I) = CoDirSwitch) And (I < ParamCount)
    End; // for I
  End; // If (ParamCount > 0)
End; // GetUserParam

//-------------------------------------------------------------------------

end.

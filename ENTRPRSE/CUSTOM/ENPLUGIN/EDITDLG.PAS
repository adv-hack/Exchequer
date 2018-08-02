unit EditDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StrUtil, Setupbas, ExtCtrls, StdCtrls, INIFiles, ComCtrls, APIUtil;

Const
  IniSect      = 'HookChain';
  EntCustmName = 'ENTCUSTM';
  IniName      = EntCustmName + '.INI';
  { CJS - 2013-07-08 - ABSEXCH-14438 - update branding and copyright }
  EnPlugInVer  = 'v7.0.5.010';
  CustAbStr    = 'Exchequer Customisation Setup ' + #10#13 + EnPlugInVer;

type
  TDLLSetupPtr = ^TDLLSetupType;
  TDLLSetupType = Record
    suMode   : Byte;                   { Mode. 1=Setup Button, 2=Installing, 3=Removing }
    suEntDir : String[255];            { Enterprise Directory }

    suSpare  : Array [1..767] Of Char; { For Future use }
  End; { TDLLSetupType }

  TCopyStructurePtr = ^TCopyStructure;
  TCopyStructure = Record
    SourcePath : ShortString;                 { Source Path of files }
    DestPath   : ShortString;                 { Destination Path - Ent. Dir }
    CurrFile   : Byte;                        { No. of next file to copy }
    NumFiles   : Byte;                        { total number of files to copy }
    Files      : Array [1..250] Of String[12];
    LastDLL    : String[8];                   { Name of last DLL in DLL Chain }
    RegDLL     : String[8];                   { Name of DLL to Register in INI file }
  End; { TCopyStructure }

  TCustomControl = class(TSetupTemplate)
    btnInstall: TButton;
    btnRemove: TButton;
    btnMoveUp: TButton;
    btnMoveDown: TButton;
    OpenDialog1: TOpenDialog;
    lbCustomDLLs: TListView;
    lvCOMPlugs: TListView;
    Label1: TLabel;
    Label2: TLabel;
    bnCOMInstall: TButton;
    bnCOMRemove: TButton;
    bnCOMUp: TButton;
    bnCOMDown: TButton;
    lVersion: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnInstallClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure MoveDLL(Sender: TObject);
    procedure bnCOMInstallClick(Sender: TObject);
    procedure bnCOMRemoveClick(Sender: TObject);
    procedure bnCOMUpClick(Sender: TObject);
    procedure bnCOMDownClick(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    IniF     : TIniFile;
    WorkDir  : ShortString;
    UnList   : TStringList;       { List for storing DLL's name to check for recursion }
    bChanged : boolean;

    Function UniqueName(DLLName : ShortString) : Boolean;
//    Function ValidOk(VCode : Char) : Boolean; OverRide;
    Procedure ProcessLSTFile(Const LSTName : ShortString; sCopy : TCopyStructurePtr);
    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;
    function GetFileBase(FilePath: string): string;
    procedure UpdateCOMIni;
    procedure SetChanged(bSetTo : boolean);
  public
    { Public declarations }
    CopyPtrNo : ShortString;
    Procedure LoadINIFile (Const INIPath : ShortString);
  end;

  var
  CustomControl: TCustomControl;

implementation

{$R *.DFM}

Const
  CM_DispAbout = $F1;

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


{ Returns True if the DLL is a valid customisation DLL }
Function DLLOK (Const MainDir, DllName : ShortString) : Boolean;
Const
  ResNames : Array[1..7] of PChar = ('InitCustomHandler',
                                     'TermCustomHandler',
                                     'ExecCustomHandler',
                                     'CustomMenus',
                                     'CloseCustomMenus',
                                     'EntDoCustomText',
                                     'EntGetCustomText');
Var
  DLLAddr      : TFarProc;
  FName        : Array [0..255] Of Char;
  I            : Byte;
  _MyGSRHandle : THandle;
  MissFunc     : ShortString;
Begin
  Result := False;

  { Check the DLL Exists in the Enterprise directory }
  If FileExists (MainDir + DLLName + '.DLL') Then
  Begin
    Try
      { Load Library }
      StrPCopy (FName, MainDir + DLLName + '.DLL');
      //_MyGSRHandle := LoadLibrary(FName);
      _MyGSRHandle := safeloadlibrary(FName, MaxLongInt);

      If (_MyGSRHandle > HInstance_Error) Then
      Begin
        { DLL has loaded }
        Result := True;

        Try
          { Get handles for procedures }
          MissFunc := '';
          For I := 1 To High(ResNames) Do Begin
            DLLAddr := GetProcAddress(_MyGSRHandle, ResNames[I]);

            If Not Assigned(DLLAddr) Then Begin
              { Accumulate list of missing functions }
              If (MissFunc = '') Then
                MissFunc := ResNames[I]
              Else
                MissFunc := MissFunc + ', ' + ResNames[I];

              Result := False;
              {Break;}
            End; { If }
          End; { For }

          If Not Result Then
            MessageDlg(DLLName + '.DLL is not a valid Customisation DLL, the following functions are missing' +
                        #10#13#10#13 + MissFunc, mtError, [mbOk], 0);
        Finally
          FreeLibrary(_MyGSRHandle);
        End; { Try }
      End { If }
      Else
        { Error loading the DLL }
        MessageDlg(DLLName + '.DLL could not be loaded', mtError, [mbOk], 0);
    Except
      On E:Exception Do
        MessageDlg ('The following error occurred whilst loading the DLL:'#13#13+E.Message, mtError, [mbOK], 0);
    End; // Except
  End { If }
  Else
    { DLL Doesn't exists }
    MessageDlg(DLLName + '.DLL could not be found in the Exchequer directory',
                mtError, [mbOk], 0);
End;

Function GetRegDLL (Var LstFName : ShortString) : Boolean;
Var
  LstF   : TextFile;
  Infile : ShortString;
Begin
  Result := False;

  AssignFile (LstF, LstFName);
  Reset (LstF);

  While Not EOF(LstF) Do Begin
    { Read a line in from the file }
    ReadLn (LstF, InFile);

    InFile := Trim(UpperCase(InFile));

    If (Copy (InFile, 1, 9) = 'REGISTER ') Then Begin
      { Get name portion of DLL }
      Delete (InFile, 1, 9);
      If (Pos('.', InFile) > 0) Then Delete (InFile, Pos('.', InFile), Length(InFile));

      { Check it exists }
      Result := FileExists (ExtractFilePath(LstFName) + InFile + '.DLL');

      { Return it }
      If Result Then Begin
        LstFName := InFile;
        Break;
      End; { If }
    End; { If }
  End; { While }

  CloseFile (LstF);
End;


Procedure TCustomControl.WMSysCommand(Var Message : TMessage);
Var
  sAbout : ANSIString;
Begin
  With Message do
    Case WParam of
      CM_DispAbout : Begin
                       sAbout := CustAbStr + #10#13 + GetCopyrightMessage;
                       Application.MessageBox(PCHAR(sAbout), 'About', MB_OK Or MB_ICONINFORMATION);
                     End;  
    End; { CAse }

  Inherited;
End;


procedure TCustomControl.FormCreate(Sender: TObject);
Var
  SysMenuH         : HWnd;
begin
  inherited;

  SetChanged(FALSE);

  { Add 'About' to System Menu }
  SysMenuH:=GetSystemMenu(Handle,False);
  AppendMenu(SysMenuH,MF_SEPARATOR,0,'');
  AppendMenu(SysMenuH,MF_String,CM_DispAbout,'&About');

  lVersion.Caption := EnPlugInVer;

  Caption := 'Exchequer Customisation Setup';
  UnList := TStringList.Create;
  IniF := Nil;
  WorkDir := '';
  ExitMsg:= 255;

  LoadInifile(ExtractFilePath(ParamStr(0)));
end;


procedure TCustomControl.FormDestroy(Sender: TObject);
begin
  inherited;

  UnList.Destroy;

  If Assigned(IniF) Then
    IniF.Free;
end;

procedure TCustomControl.LoadINIFile (const INIPath: ShortString);
var
  DLLName, COMStr: ShortString;
  IsEntCustm: Boolean;
  DllDesc, ThisInt: string;
begin
  { Create INI object }
  IniF := TIniFile.Create(INIPath + IniName);
  IniF.UpdateFile;
  WorkDir := UpperCase(Trim(PathToShort (IniPath)));

  UnList.Clear;
  DLLName := EntCustmName;
  While (Trim(DllName) <> '') Do Begin
    DLLName := Trim(UpperCase(DLLName));

    { Check name is valid }
    If UniqueName(DllName) Then Begin
      IsEntCustm := (Trim(UpperCase(DLLName)) = EntCustmName);

      { Check DLL is AOK }
      If DLLOK (WorkDir, DllName) Or IsEntCustm Then Begin
        { Don't put EntCustm.DLL into List }
        if (not IsEntCustm) then begin
          { Add into list }
          DllDesc:= IniF.ReadString('PlugInDesc', DllName, '');
          with lbCustomDLLs.Items.Add do
          begin
            Caption:= DLLName;
            SubItems.Add(DllDesc);
          end;
        end;

        { Always add valid DLL's into unique list }
        UnList.Add(DLLName);
      End; { If }

      { get next name }
      DLLName := IniF.ReadString(IniSect, DLLName, '');
    End { If }
    Else
      { Gone recursive - finish loop }
      DLLName := '';
  End; { While }

  ThisInt:= '1';
  COMStr:= IniF.ReadString('ComClients', ThisInt, '');
  while COMStr <> '' do
  begin
    with lvCOMPlugs.Items.Add do
    begin
      Caption:= GetFileBase(COMStr);
      SubItems.Add(IniF.ReadString('PlugInDesc', Caption, ''));
      SubItems.Add(COMStr);
    end;
    ThisInt:= IntToStr(StrToInt(ThisInt) + 1);
    COMStr:= IniF.ReadString('ComClients', ThisInt, '');
  end;
End;


{ Checks to see if a DLL already exists in the list }
Function TCustomControl.UniqueName(DLLName : ShortString) : Boolean;
Var
  I : Byte;
Begin
  Result := True;

  DLLName := UpperCase(Trim(DLLName));

  If (UnList.Count > 0) Then
    For I := 0 To Pred(UnList.Count) Do
      If (UpperCase(Trim(UnList.Strings[I])) = DLLName) Then Begin
        Result := False;
        Break;
      End; { If }
End;


{ Processes a .LST file, placing the copy/register info into the memory structure }
Procedure TCustomControl.ProcessLSTFile(Const LSTName : ShortString; sCopy : TCopyStructurePtr);
Var
  LstF   : TextFile;
  Infile : ShortString;
Begin
  { open file }
  AssignFile (LstF, LstName);
  Reset (LstF);

  While Not EOF(LstF) Do Begin
    { Read a line in from the file }
    ReadLn (LstF, InFile);

    InFile := Trim(UpperCase(InFile));

    If (InFile <> '') Then Begin
      If (Copy (InFile, 1, 9) = 'REGISTER ') Then Begin
        { Get name portion of DLL }
        Delete (InFile, 1, 9);
        If (Pos('.', InFile) > 0) Then Delete (InFile, Pos('.', InFile), Length(InFile));

        sCopy^.RegDLL := InFile;
      End { If }
      Else
        With sCopy^ Do
          { copy file instruction }
          If (NumFiles < High(Files)) Then Begin
            Inc (NumFiles);

            Files[NumFiles] := InFile;
          End; { If }
    End; { If }
  End; { While }

  CloseFile (LstF);
End;


procedure TCustomControl.btnInstallClick(Sender: TObject);
Var
  DLLDir, WorkStr : ShortString;
  DllName         : String[8];
  DLLExt          : String[4];
  hGlobMem        : THandle;
  sCopy           : TCopyStructurePtr;
begin
  inherited;

  OpenDialog1.Filter:= 'Customisation DLL (*.DLL)|*.DLL|Installation List (*.LST)|*.LST|All Files (*.*)|*.*';
  OpenDialog1.InitialDir := WorkDir;
  If OpenDialog1.Execute Then Begin
    { Get Path to see if it is in the Ent. directory }
    DLLDir := UpperCase(PathToShort (ExtractFilePath(OpenDialog1.FileName)));

    { Get name }
    DLLName := Trim(UpperCase(ExtractFileName(OpenDialog1.FileName)));
    If (Pos('.', DLLName) > 0) Then Delete (DLLName, Pos('.', DLLName), Length(DLLName));

    { Get Extension to find out what type it is }
    DLLExt := Trim(UpperCase(ExtractFileExt(OpenDialog1.FileName)));
    If (DLLExt[1] = '.') Then Delete (DLLExt, 1, 1);

    If (DLLExt = 'DLL') Or (DLLExt = 'LST') Then Begin
      If (ExtractFilePath(DLLDir) <> ExtractFilePath(WorkDir)) Then
      Begin
        CopyFile(PChar(OpenDialog1.FileName), PChar(WorkDir + ExtractFileName(OpenDialog1.FileName)), false);
        DLLDir := UpperCase(PathToShort (WorkDir + ExtractFileName(OpenDialog1.FileName)));
      End; { If }

      { In Enterprise directory already - only need to register the dll }
      If (DLLExt = 'LST') Then Begin
        { .LST file - Files already in dir - just get DLL name and let DLL stuff register it }
        WorkStr := DLLDir + DLLName + '.' + DLLExt;
        If GetRegDLL (WorkStr) Then Begin
          DLLExt := 'DLL';
          DLLName := WorkStr;
        End; { If }
      End; { Else }

      If (DLLExt = 'DLL') Then Begin
        { .DLL - check it doesn't already exist in list }
        If UniqueName(DllName) Then Begin
          { Check DLL has all the required functions }
          If DLLOK (WorkDir, DllName) Then Begin
            { Add into list }
            with lbCustomDLLs.Items.Add do
            begin
              Caption:= DLLName;
              IniF.UpdateFile;
              if IniF.ReadString('PlugInDesc', DLLName, '') <> '' then SubItems.Add(IniF.ReadString('PlugInDesc', DLLName, ''))
              else SubItems.Add(InputBox('Plug-In Description', 'Please enter a description for this plug-in:', ''));
            end;
            UnList.Add(DLLName);
            lbCustomDLLs.ItemIndex := Pred(lbCustomDLLs.Items.Count);
            SetChanged(TRUE);
          End; { If }
        End { If }
        Else
          { Already exists }
          MessageDlg ('A DLL with this name already exists in the list', mtWarning, [mbOk], 0);
      End; { If }
    End { If }
    Else
      { Unknown file type }
      MessageDlg ('Unknown File Type - Operation Aborted', mtWarning, [mbOk], 0);
  End; { If }
end;


{ Saves the changes to the DLL Chain }
(*
Function TCustomControl.ValidOk(VCode : Char) : Boolean;
Var
  DLL1, DLL2 : String[8];
  I          : Byte;
Begin
  Result := True;

  If (VCode In ['N', 'I']) Then Begin
    { Delete Section }
    IniF.EraseSection(IniSect);
    IniF.UpdateFile;

    { Write details back to INI file }
    If (lbCustomDLLs.Items.Count > 0) Then Begin
      DLL1 := EntCustmName;
      For I := 0 To Pred(lbCustomDLLs.Items.Count) Do Begin
        DLL2 := lbCustomDLLs.Items[I].Caption;
        If (UpperCase(Trim(DLL2)) <> EntCustmName) Then
        begin
          IniF.WriteString (IniSect, DLL1, DLL2);
          IniF.WriteString ('PlugInDesc', DLL2, lbCustomDLLs.Items[I].SubItems[0]);
          IniF.UpdateFile;
        end;
        DLL1 := DLL2;
      End; { For }
    End; { If }
  End; { If }
end;*)


procedure TCustomControl.btnRemoveClick(Sender: TObject);
Var
  I : Byte;
begin
  inherited;

  If (lbCustomDLLs.ItemIndex > -1) Then Begin
    If (MessageDlg ('Are you sure you want to remove ' + UpperCase(lbCustomDLLs.Items[lbCustomDLLs.ItemIndex].Caption) +
                    '.DLL from the DLL Chain?', mtConfirmation, [mbOK, mbCancel], 0) = mrOK) Then Begin

      { remove from unique list }
      If (UnList.Count > 0) Then
        For I := 0 To Pred(UnList.Count) Do
          If (UnList[I] = lbCustomDLLs.Items[lbCustomDLLs.ItemIndex].Caption) Then Begin
            UnList.Delete(I);
            Break;
          End; { If }

      { Remove from list }
      I := lbCustomDLLs.ItemIndex;
      lbCustomDLLs.Items.Delete(lbCustomDLLs.ItemIndex);
      SetChanged(TRUE);

      If (lbCustomDLLs.Items.Count > 0) Then Begin
        If (I > -1) And (I < lbCustomDLLs.Items.Count) Then
          lbCustomDLLs.ItemIndex := I
        Else
          lbCustomDLLs.ItemIndex := Pred(lbCustomDLLs.Items.Count);
      End; { If }
    End; { If }
  End { If }
  Else
    If (lbCustomDLLs.ItemIndex = 0) Then
      MessageDlg ('EntCustm.DLL cannot be removed', mtWarning, [mbOk], 0);
end;

procedure TCustomControl.MoveDLL(Sender: TObject);
Var
  TmpSwapStr1, TmpSwapStr2     : ShortString;
  IdxFrom, IdxTo : SmallInt;
begin
  inherited;

  { Check we have an item selected and its not the top item }
  If (lbCustomDLLs.ItemIndex > -1) Then Begin
    If (Sender = btnMoveUp) Then Begin
      { Move Up }
      IdxFrom := lbCustomDLLs.ItemIndex;
      IdxTo   := Pred(IdxFrom);
    End { If }
    Else Begin
      { Move Down }
      IdxFrom := lbCustomDLLs.ItemIndex;
      IdxTo   := Succ(IdxFrom);
    End; { Else }

    { Check we have a valid range }
    If (IdxFrom In [0..Pred(lbCustomDLLs.Items.Count)]) And
       (IdxTo   In [0..Pred(lbCustomDLLs.Items.Count)]) Then Begin
      TmpSwapStr1:= lbCustomDLLs.Items[IdxFrom].Caption;
      TmpSwapStr2:= lbCustomDLLs.Items[IdxFrom].SubItems[0];
      lbCustomDLLs.Items[IdxFrom]:= lbCustomDLLs.Items[IdxTo];
      lbCustomDLLs.Items[IdxTo].Caption:= TmpSwapStr1;
      lbCustomDLLs.Items[IdxTo].SubItems[0]:= TmpSwapStr2;
      lbCustomDLLs.ItemIndex := IdxTo;
      SetChanged(TRUE);
    End; { If }
  End; { If }
end;

procedure TCustomControl.bnCOMInstallClick(Sender: TObject);
var
  ThisInt, TempStr, COMDesc: string;
  Registered: boolean;
begin
  OpenDialog1.Filter:= 'COM Clients (*.exe)|*.exe';
  OpenDialog1.InitialDir:= WorkDir;
  if OpenDialog1.Execute then with IniF, OpenDialog1 do
  begin
    UpdateFile;
    Registered:= false;
    ThisInt:= '1';

    while ReadString('ComClients', ThisInt, '') <> '' do
    begin
      if ReadString('ComClients', ThisInt, '') = FileName then
      begin
        Registered:= true;
        MessageDlg ('A COM Client with this name already exists in the list', mtWarning, [mbOk], 0);
      end;
      ThisInt:= IntToStr(StrToInt(ThisInt) + 1);
    end;

{    if not Registered then
    begin
      WriteString('ComClients', ThisInt, FileName);
      TempStr:= GetFileBase(FileName);

      if ReadString('PlugInDesc', TempStr, '') = '' then
      begin
        COMDesc:= '';
        if InputQuery('COM Client Description', 'Please enter a description for this plug-in:', COMDesc) then WriteString('PlugInDesc', TempStr, COMDesc)
        else COMDesc:= '';
      end
      else COMDesc:= ReadString('PlugInDesc', TempStr, '');

      with lvCOMPlugs.Items.Add do
      begin
        Caption:= TempStr;
        SubItems.Add(COMDesc);
        SubItems.Add(FileName);
      end;
      UpdateFile;
      SetChanged(TRUE);
    end;{if}

    if not Registered then
    begin
//      WriteString('ComClients', ThisInt, FileName);
      TempStr:= GetFileBase(FileName);

      if ReadString('PlugInDesc', TempStr, '') = '' then
      begin
        COMDesc:= '';
        if InputQuery('COM Client Description', 'Please enter a description for this plug-in:', COMDesc)
        then //WriteString('PlugInDesc', TempStr, COMDesc)
        else COMDesc:= '';
      end
      else COMDesc:= ReadString('PlugInDesc', TempStr, '');

      with lvCOMPlugs.Items.Add do
      begin
        Caption:= TempStr;
        SubItems.Add(COMDesc);
        SubItems.Add(FileName);
      end;
      UpdateFile;
      SetChanged(TRUE);
    end;{if}

  end;
end;

procedure TCustomControl.bnCOMRemoveClick(Sender: TObject);
var
  ClientIndex: integer;
  ThisInt: string;
begin
  with lvCOMPlugs do
  begin
    if ItemIndex < 0 then Exit;
    DeleteSelected;
    SetChanged(TRUE);
//    UpdateCOMIni;
  end;
end;

function TCustomControl.GetFileBase(FilePath: string): string;
var
  TempStr: string;
begin
  TempStr:= Copy(ExtractFileName(FilePath), 1, Pos(ExtractFileExt(FilePath), ExtractFileName(FilePath)));
  if (Length(TempStr) > 0) and (TempStr[Length(TempStr)] = '.') then Delete(TempStr, Length(TempStr), 1);
  Result:= TempStr;
end;

procedure TCustomControl.bnCOMUpClick(Sender: TObject);
var
  HoldItem: TListItem;
begin
  with lvCOMPlugs do
  begin
    if ItemIndex > 0 then
    begin
      HoldItem:= TListItem.Create(Items);
      try
        HoldItem.Assign(Selected);
        Selected.Assign(Items[ItemIndex - 1]);
        Items[ItemIndex - 1].Assign(HoldItem);
        SetChanged(TRUE);
      finally
        FreeAndNil(HoldItem);
      end;
      ItemIndex:= ItemIndex - 1;
    end;
  end;
//  UpdateCOMIni;
end;

procedure TCustomControl.bnCOMDownClick(Sender: TObject);
var
  HoldItem: TListItem;
begin
  with lvCOMPlugs do
  begin
    if ItemIndex < Items.Count - 1 then
    begin
      HoldItem:= TListItem.Create(Items);
      try
        HoldItem.Assign(Selected);
        Selected.Assign(Items[ItemIndex + 1]);
        Items[ItemIndex + 1].Assign(HoldItem);
        SetChanged(TRUE);
      finally
        FreeAndNil(HoldItem);
      end;
      ItemIndex:= ItemIndex + 1;
    end;
  end;
//  UpdateCOMIni;
end;

procedure TCustomControl.UpdateCOMIni;
var
  ClientIndex: integer;
  ThisInt: string;
begin
  with IniF do
  begin
    EraseSection('ComClients');
    for ClientIndex:= 0 to lvCOMPlugs.Items.Count - 1 do
    begin
      ThisInt:= IntToStr(ClientIndex + 1);
      WriteString('ComClients', ThisInt, lvCOMPlugs.Items[ClientIndex].SubItems[1]);
      WriteString('PlugInDesc', JustFileName(lvCOMPlugs.Items[ClientIndex].SubItems[1]), lvCOMPlugs.Items[ClientIndex].SubItems[0])
    end;
    UpdateFile;
  end;
end;

procedure TCustomControl.BackBtnClick(Sender: TObject);
Var
  DLL1, DLL2 : String[8];
  I          : Byte;
Begin
  { Delete Section }
  IniF.EraseSection(IniSect);
  IniF.UpdateFile;

  { Write details back to INI file }
  If (lbCustomDLLs.Items.Count > 0) Then Begin
    DLL1 := EntCustmName;
    For I := 0 To Pred(lbCustomDLLs.Items.Count) Do Begin
      DLL2 := lbCustomDLLs.Items[I].Caption;
      If (UpperCase(Trim(DLL2)) <> EntCustmName) Then
      begin
        IniF.WriteString (IniSect, DLL1, DLL2);
        IniF.WriteString ('PlugInDesc', DLL2, lbCustomDLLs.Items[I].SubItems[0]);
        IniF.UpdateFile;
      end;
      DLL1 := DLL2;
    End; { For }
  End; { If }

  UpdateCOMIni;

  SetChanged(FALSE);
end;

procedure TCustomControl.NextBtnClick(Sender: TObject);
Begin
  Close;
end;

procedure TCustomControl.SetChanged(bSetTo : boolean);
Begin
  bChanged := bSetTo;
  BackBtn.Enabled := bChanged
end;



procedure TCustomControl.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//  inherited;
  if bChanged then begin
    if MsgBox('You have made changes to the customisation configuration.' + #13#13
    + 'Do you want to save these changes now ?',mtConfirmation,[mbYes,mbNo],mbYes
    ,'Save Changes ?') = mrYes then BackBtnClick(nil);
  end;{if}
end;

end.



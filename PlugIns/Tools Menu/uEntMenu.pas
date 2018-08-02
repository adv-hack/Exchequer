unit uEntMenu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , StdCtrls, ShellAPI, Menus, IniFiles, APIUtil, StrUtil, ToolBTFiles
  , BTConst, BTUtil, Login, uSettingsSQL, SecSup2U, VarRec2U, FileUtil, ADODB
  , IncludeCustMenu, DataModule;

Type
  {-$I CustMenu.Pas}

  TEntMenuObj = Class(TObject)
  Private
    Constructor Create;
    Destructor  Destroy; Override;
  Public
    hNewMenu   : NewMenuFunc;
    ToolsMenu  : TMenuItem;
    SysSetupMenu : TMenuItem;
    procedure CreateToolsMenu;
    procedure AddToolsOptions;
    Procedure AddUserTools;
    Function GetDefualtParent : TMenuItem;

    { menu event handlers }
    procedure MenuOpt_Tools_UserClick(Sender: TObject);
    procedure MenuOpt_Tools_OptionsClick(Sender: TObject);
    procedure UpdateToolsMenu(Sender: TObject);
  End; { EntMenuObj }

Var
  gEntInfo : EntCustomInfo;
  EntMenuObj  : TEntMenuObj;
  OldApp      : TApplication;
  OldScr      : TScreen;

implementation
Uses
  MenuDesigner, ToolProc, ChainU;

Constructor TEntMenuObj.Create;
Begin
  Inherited Create;
End;

Destructor TEntMenuObj.Destroy;
Begin
  Inherited Destroy;
End;

{ Create tools menu, and insert before the Help menu }
procedure TEntMenuObj.CreateToolsMenu;
Var
  HelpMenu  : TMenuItem;
Begin
  ToolsMenu := EnterpriseMenu.Items.Find('Too&ls');
  if (ToolsMenu = nil) or (ToolsMenu.name <> DLLChain.ModuleName + '_Menu_Tools') then
  begin
    { Add DLL Module Name to start of control name to provide unique control name }
    ToolsMenu := hNewMenu('Too&ls', DLLChain.ModuleName + '_Menu_Tools');
    ToolsMenu.AutoHotKeys := maManual;
    ToolsMenu.GroupIndex := 95;
    ToolsMenu.HelpContext := 550;
    ToolsMenu.Hint := 'User Definable Tools';

    HelpMenu := EnterpriseMenu.Items.Find('&Help');
    If Assigned(HelpMenu) Then
      EnterpriseMenu.Items.Insert (HelpMenu.MenuIndex, ToolsMenu)
    Else
      EnterpriseMenu.Items.Insert (EnterpriseMenu.Items.Count - 1, ToolsMenu);
  end;{if}
End;

{ Adds the options to the tools menu }
procedure TEntMenuObj.AddToolsOptions;
Var
  TmpItem : TMenuItem;
Begin
  TmpItem :=  ToolsMenu.Find('&Options');
  if ((TmpItem = nil) or (TmpItem.name <> DLLChain.ModuleName + '_MenuOpt_Tools_Options')) then
  begin
    { Add a '&Options' menu item to the Tools menu }
    TmpItem := hNewMenu('&Options', DLLChain.ModuleName + '_MenuOpt_Tools_Options');
    TmpItem.HelpContext := 550;
    TmpItem.Hint := 'Allows the modification of the Tools menu';
    TmpItem.OnClick := EntMenuObj.MenuOpt_Tools_OptionsClick;
    ToolsMenu.Add (TmpItem);

    { Add a '----' menu item to the Tools menu }
    TmpItem := hNewMenu('-', DLLChain.ModuleName + '_MenuOpt_Tools_SepBar');
    TmpItem.HelpContext := 550;
    ToolsMenu.Add (TmpItem);
  end;
End;

{ PL 19/04/2017 2017-R1 ABSEXCH-18497 Report Menu :
 Function Returns the Parent Custom Reports for Custom items created by user
  when we delete it's parent at design time }
Function TEntMenuObj.GetDefualtParent : TMenuItem;
var
  CustomReport : TmenuItem;
begin

  CustomReport := EnterpriseMenu.Items.Find('Reports');
  Result := CustomReport.find('Custom Reports');
  if Assigned(Result) then
      Result.Visible := True ;

end;

Procedure TEntMenuObj.AddUserTools;
Var
  NumItems, I          : LongInt;
  TitleStr, Str1, Str2 : ShortString;
  TmpItem              : TMenuItem;

  procedure ConvertIniFile;
  var
    ENTTOOLSDAT : TInifile;
    iResult, iPos, iNoOfTools : integer;
    ToolRec : TToolRec;
    sKey : string;
    asFilename : ANSIString;
  begin
    asFilename:= asAppDir + 'ENTTOOLS.DAT';

    if FileExists(asFilename) then
    begin
      ENTTOOLSDAT := TInifile.Create(asFilename);
      iNoOfTools := ENTTOOLSDAT.ReadInteger('ToolsMenu', 'Options', 0);

      For iPos := 1 to iNoOfTools do begin
        sKey := 'Opt' + IntToStr(iPos);
        FillChar(ToolRec,SizeOf(ToolRec),#0);
        ToolRec.RecordType := RT_MenuItem;
        with ToolRec.MenuItem do
        begin
          miAllCompanies := TRUE;
          miAvailability := AV_AllCompanies;
          miDescription := ENTTOOLSDAT.ReadString('ToolsTitles', sKey, '');
          miComponentName := GetComponentNameFrom(miDescription, IT_MenuItem);
          miParentComponentName := PadString(psRight, TOOLS_MENU_COMPONENT_NAME, ' ', 50);
          miFilename := ENTTOOLSDAT.ReadString('ToolsCmds', sKey, '');
          miFolioNo := GetNextFolioNo;
          miItemType := IT_MenuItem;
          miParameters := ENTTOOLSDAT.ReadString('ToolsParams', sKey, '');
          miPosition := iPos + 2;
          miStartDir := ENTTOOLSDAT.ReadString('ToolsStartup', sKey, '');
          SetMenuItemIndexes(ToolRec);
        end;{with}

        // Add Record
        iResult := BTAddRecord(FileVar[ToolF], ToolRec, BufferSize[ToolF], miIdxByFolio);
        BTShowError(iResult, 'BTAddRecord', asAppDir + aFileNames[ToolF]);

      end;{for}

      ENTTOOLSDAT.Free;
      DeleteFile(asFilename + '.old');
      MoveFile(PChar(asFilename), PChar(asFilename + '.old'));
    end;{if}
  end;

  procedure AddUserOptions;

    procedure RemoveUserOptionsFrom(MenuItem : TMenuItem);
    var
      iPos : integer;
      CurrentItem : TMenuItem;
    begin{RemoveUserOptionsFrom}
      iPos := 0;
      while iPos < MenuItem.Count do
      begin
        // recurse into submenu
        if MenuItem.Items[iPos].Count > 0 then RemoveUserOptionsFrom(MenuItem.Items[iPos]);

        if UserDefinedItem(MenuItem.items[iPos].Name) then
        begin
          CurrentItem := MenuItem.items[iPos];
          MenuItem.Delete(iPos);
          CurrentItem.Free;
        end else
        begin
          inc(iPos);
        end;{if}
      end;{while}
    end;{RemoveUserOptionsFrom}
(*
    function AddNewItem(sName : string) : boolean;
    var
      iStatus : integer;
      KeyS : TStr255;
      NewItem : TMenuItem;
      ParentMenu : TMenuItem;
      LToolRec : TToolRec;

      procedure CreateItem;

        function ShowItem : boolean;
        var
          AToolRec : TToolRec;
          BTRec : TBTRec;
        begin{ShowItem}
          case LToolRec.MenuItem.miAvailability of
            AV_AllCompanies : begin
              // Available to all companies
              if LToolRec.MenuItem.miAllCompanies then
              begin
                // visible to all companies
                Result := TRUE;
              end else
              begin
                // only visible to specific companies
                BTRec.KeyS := RT_CompanyXRef + BuildA10Index(BTFullNomKey(LToolRec.MenuItem.miFolioNo)
                + CurrentCompanyRec.Code);
                BTRec.Status := BTFindRecord(BT_GetEqual, FileVar[ToolF], AToolRec, BufferSize[ToolF]
                , cxIdxByFolioCode, BTRec.KeyS);
                Result := (BTRec.Status = 0)
              end;{if}
            end;

            AV_SpecificCompany : begin
              Result := (LToolRec.MenuItem.miCompany = CurrentCompanyRec.Code);
              if Result then
              begin
                if not LToolRec.MenuItem.miAllUsers then
                begin
                  // only visible to specific users in this company
                  BTRec.KeyS := RT_UserXRef + BuildB50Index(BTFullNomKey(LToolRec.MenuItem.miFolioNo)
                  + sCurrentUserName);
                  BTRec.Status := BTFindRecord(BT_GetEqual, FileVar[ToolF], AToolRec, BufferSize[ToolF]
                  , uxIdxByFolioName, BTRec.KeyS);
                  Result := (BTRec.Status = 0)
                end;{if}
              end;{if}
            end;
          end;{case}
        end;{ShowItem}

      begin{CreateItem}
        NewItem := hNewMenu(LToolRec.MenuItem.miDescription, Trim(LToolRec.MenuItem.miComponentName));
        NewItem.Hint := LToolRec.MenuItem.miHelpText;
        NewItem.OnClick := EntMenuObj.MenuOpt_Tools_UserClick;
        NewItem.Visible := ShowItem;
        if ParentMenu.Count < LToolRec.MenuItem.miPosition -1
        then ParentMenu.Add(NewItem)
        else ParentMenu.Insert(LToolRec.MenuItem.miPosition -1, NewItem);
        Result := TRUE;
      end;{CreateItem}

    begin{AddNewItem}

      Result := FALSE;

      Application.ProcessMessages; // I am hoping that this helps the redraw of the toolbar in exchequer

      // find record
      KeyS := RT_MenuItem + BuildB50Index(sName);
      iStatus := BTFindRecord(BT_GetEqual, FileVar[ToolF], LToolRec, BufferSize[ToolF]
      , miIdxByComponentName, KeyS);
      BTShowError(iStatus, 'BTFindRecord', asAppDir + aFileNames[ToolF]);
      if iStatus = 0 then
      begin
        if LToolRec.MenuItem.miParentComponentName = '' then
        begin
          // root item
          ParentMenu := EnterpriseMenu.Items;
          CreateItem;
        end else
        begin
          // not a root item
          ParentMenu := GetMenuItemInMenu(EnterpriseMenu.items, LToolRec.MenuItem.miParentComponentName);
          if ParentMenu = nil then
          begin
            // Parent Menu Not Found, let's add it
            AddNewItem(LToolRec.MenuItem.miParentComponentName);
            ParentMenu := GetMenuItemInMenu(EnterpriseMenu.items, LToolRec.MenuItem.miParentComponentName);

            // could not find the parent menu for an item
            if ParentMenu = nil then
            begin
              MsgBox('Could not find the SubMenu "' + LToolRec.MenuItem.miParentComponentName
              + '" that the option "' + LToolRec.MenuItem.miComponentName + '" resides within.'
              ,mtError, [mbOK], mbOK, 'SubMenu Not Found');
            end;{if}
          end;{if}

          if ParentMenu <> nil then
          begin
            // Add New Item
            CreateItem;
          end;{if}
        end;{if}
      end;{if}
    end;{AddNewItem}
*)
    function AddNewItem(LToolRec : TToolRec) : boolean;
    var
      iStatus : integer;
      KeyS : TStr255;
      NewItem : TMenuItem;
      ParentMenu : TMenuItem;
//      LToolRec : TToolRec;
      ParentToolRec : TToolRec;

      procedure CreateItem;

        function ShowItem : boolean;
        var
          AToolRec : TToolRec;
          BTRec : TBTRec;
        begin{ShowItem}
          case LToolRec.MenuItem.miAvailability of
            AV_AllCompanies : begin
              // Available to all companies
              if LToolRec.MenuItem.miAllCompanies then
              begin
                // visible to all companies
                Result := TRUE;
              end else
              begin
                // only visible to specific companies
                // is it visible for the current company ?
                if bSQL then
                begin
                  // SQL Improvements
                  // v6.30.142
//                  Result := SQLDataModule.SQLMenuItemInCompany(LToolRec.MenuItem.miFolioNo
//                  , CurrentCompanyRec.Code);
                  Result := SQLDataModule.SQLMenuItemInCompany(LToolRec.MenuItem.miFolioNo
                  , asCompanyCode);
                end
                else
                begin
                  // Pervasive
                  // v6.30.142
//                  BTRec.KeyS := RT_CompanyXRef + BuildA10Index(BTFullNomKey(LToolRec.MenuItem.miFolioNo)
//                  + CurrentCompanyRec.Code);
                  BTRec.KeyS := RT_CompanyXRef + BuildA10Index(BTFullNomKey(LToolRec.MenuItem.miFolioNo)
                  + asCompanyCode);
                  BTRec.Status := BTFindRecord(BT_GetEqual, FileVar[ToolF], AToolRec, BufferSize[ToolF]
                  , cxIdxByFolioCode, BTRec.KeyS);
                  Result := (BTRec.Status = 0);
                end;{if}
              end;{if}
            end;

            AV_SpecificCompany : begin

              // v6.30.142
//              Result := (LToolRec.MenuItem.miCompany = CurrentCompanyRec.Code);
              Result := (LToolRec.MenuItem.miCompany = asCompanyCode);

              if Result then
              begin
                if not LToolRec.MenuItem.miAllUsers then
                begin
                  // only visible to specific users in this company

                  // Is it visible to the current user ?
                  if bSQL then
                  begin
                    // SQL Improvements
                    Result := SQLDataModule.SQLMenuItemForUser(LToolRec.MenuItem.miFolioNo
                    , sCurrentUserName);
                  end
                  else
                  begin
                    // Pervasive
                    BTRec.KeyS := RT_UserXRef + BuildB50Index(BTFullNomKey(LToolRec.MenuItem.miFolioNo)
                    + sCurrentUserName);
                    BTRec.Status := BTFindRecord(BT_GetEqual, FileVar[ToolF], AToolRec, BufferSize[ToolF]
                    , uxIdxByFolioName, BTRec.KeyS);
                    Result := (BTRec.Status = 0);
                  end;{if}
                end;{if}
              end;{if}
            end;
          end;{case}
        end;{ShowItem}

      begin{CreateItem}
        NewItem := hNewMenu(LToolRec.MenuItem.miDescription, Trim(LToolRec.MenuItem.miComponentName));
        NewItem.Hint := LToolRec.MenuItem.miHelpText;
        NewItem.OnClick := EntMenuObj.MenuOpt_Tools_UserClick;
        NewItem.Visible := ShowItem;
        if ParentMenu.Count < LToolRec.MenuItem.miPosition -1
        then ParentMenu.Add(NewItem)
        else
        begin
          //SSK 24/10/2016 2017-R1 ABSEXCH-14637: changes made to eliminate List index out of bounds(-1) and related errors
          if LToolRec.MenuItem.miPosition>0 then
            ParentMenu.Insert(LToolRec.MenuItem.miPosition -1, NewItem)
          else
            ParentMenu.Insert(LToolRec.MenuItem.miPosition, NewItem);
        end;

        Result := TRUE;
      end;{CreateItem}

    begin{AddNewItem}

      Result := FALSE;

//Application.ProcessMessages; // I am hoping that this helps the redraw of the toolbar in exchequer

      // find record
{      KeyS := RT_MenuItem + BuildB50Index(sName);
      iStatus := BTFindRecord(BT_GetEqual, FileVar[ToolF], LToolRec, BufferSize[ToolF]
      , miIdxByComponentName, KeyS);
      BTShowError(iStatus, 'BTFindRecord', asAppDir + aFileNames[ToolF]);
      if iStatus = 0 then}
      begin
        if LToolRec.MenuItem.miParentComponentName = '' then
        begin
          // root item
          ParentMenu := EnterpriseMenu.Items;
          CreateItem;
        end else
        begin
          // not a root item
          ParentMenu := GetMenuItemInMenu(EnterpriseMenu.items, LToolRec.MenuItem.miParentComponentName);

          //PL 19/04/2017 2017-R1 ABSEXCH-18497 Report Menu : assigning custom parent menuitem.
          if ParentMenu = nil then
            ParentMenu := GetDefualtParent; 

          if ParentMenu = nil then
          begin
            // Parent Menu Not Found, let's add it

            // Get Parent component
            if bSQL then
            begin
              // SQL Improvements
              iStatus := SQLDataModule.SQLGetMenuItemFromName(LToolRec.MenuItem.miParentComponentName
              , ParentToolRec);
            end
            else
            begin
              // Pervasive
              KeyS := RT_MenuItem + BuildB50Index(LToolRec.MenuItem.miParentComponentName);
              iStatus := BTFindRecord(BT_GetEqual, FileVar[ToolF], ParentToolRec, BufferSize[ToolF]
              , miIdxByComponentName, KeyS);
              BTShowError(iStatus, 'BTFindRecord', asAppDir + aFileNames[ToolF]);
            end;{if}

            if iStatus = 0 then
            begin
              AddNewItem(ParentToolRec);
              ParentMenu := GetMenuItemInMenu(EnterpriseMenu.items, LToolRec.MenuItem.miParentComponentName);

              // could not find the parent menu for an item
              if ParentMenu = nil then
              begin
                MsgBox('Could not find the SubMenu "' + LToolRec.MenuItem.miParentComponentName
                + '" that the option "' + LToolRec.MenuItem.miComponentName + '" resides within.'
                ,mtError, [mbOK], mbOK, 'SubMenu Not Found');
              end;{if}
            end;{if}
          end;{if}

          if ParentMenu <> nil then
          begin
            // Add New Item
            CreateItem;
          end;{if}
        end;{if}
      end;{if}
    end;{AddNewItem}

  var
    iRecPos, iStatus : integer;
    KeyS : TStr255;
    ToolRec : TToolRec;
    qMenuItems : TADOQuery;

  begin{AddUserOptions}

    RemoveUserOptionsFrom(EnterpriseMenu.Items);

    if bSQL then
    begin
      // SQL Improvements
      qMenuItems := SQLDataModule.SQLGetMenuItems;
      qMenuItems.First;
      while (not qMenuItems.EOF) do
      begin
        SQLDataModule.QueryToMenuItem(qMenuItems, ToolRec);

        if GetMenuItemInMenu(EnterpriseMenu.items, ToolRec.MenuItem.miComponentName) = nil
        then AddNewItem(ToolRec);

        qMenuItems.Next;
      end;{while}
      qMenuItems.Close;
    end
    else
    begin
      // Pervasive
      KeyS := RT_MenuItem;
      iStatus := BTFindRecord(BT_GetGreaterOrEqual, FileVar[ToolF], ToolRec, BufferSize[ToolF]
      , miIdxAddOrder, KeyS);
      while (iStatus = 0) and (ToolRec.RecordType = RT_MenuItem) do
      begin
        // get record position
        iStatus := BTGetPos(FileVar[ToolF], ToolF, BufferSize[ToolF], iRecPos);

//        if GetMenuItemInMenu(EnterpriseMenu.items, ToolRec.MenuItem.miComponentName) = nil
//        then AddNewItem(ToolRec.MenuItem.miComponentName);
        if GetMenuItemInMenu(EnterpriseMenu.items, ToolRec.MenuItem.miComponentName) = nil
        then AddNewItem(ToolRec);

        // Return To Original Record position
        move(iRecPos,ToolRec,sizeof(iRecPos));
        BTShowError(BTGetDirect(FileVar[ToolF], ToolF, ToolRec, BufferSize[ToolF]
        , miIdxAddOrder, 0), 'BTGetDirect', asAppDir + aFileNames[ToolF]);

        iStatus := BTFindRecord(BT_GetNext, FileVar[ToolF], ToolRec, BufferSize[ToolF]
        , miIdxAddOrder, KeyS);
      end;{while}
    end;{if}
  end;{AddUserOptions}

Begin
  if OpenFiles(FALSE) then
  begin
    ConvertIniFile;
    AddUserOptions;
  end;{if}
end;

{ Click Event handler for the user defined Tools menu options }
procedure TEntMenuObj.MenuOpt_Tools_UserClick(Sender: TObject);
var
  FPath                 : ShortString;
  cmdFile, cmdPath, cmdParams : PChar;
  Flags                       : SmallInt;
  iStatus : integer;
  KeyS : TStr255;
  ToolRec : TToolRec;
Begin
  RunUserOption(TMenuItem(Sender).Name);
End;

{ Click Event handler for the Tools options menu option }
procedure TEntMenuObj.MenuOpt_Tools_OptionsClick(Sender: TObject);
Var
  hFaxAdminWin : HWnd;
  BTRec : TBTRec;
  bContinue : boolean;
  LToolRec : TToolRec;
  frmMenuDesigner : TfrmMenuDesigner;

  function ToolsLogin(sPassword : string) : boolean;
  Var
    ESN : ISNArrayType;
  begin{ToolsLogin}
    Result := FALSE;
    with TFrmLogin.Create(application) do
    begin
      oSettings.LoadParentToControl('frmMenuDesigner', 'frmMenuDesigner', edPassword);

      if Showmodal = mrOK then begin
        if (Uppercase(edPassword.Text) = sPassword)
        or (Uppercase(edPassword.Text) = Generate_ESN_BaseSecurity(ESN, 251, 0, 0))
        then Result := TRUE
        else begin
          MsgBox('The password you entered was incorrect.',mtError,[mbOK], mbOK, 'Login Error');
        end;
      end;{if}
      Release;
    end;{with}
  end;{ToolsLogin}

begin
  { NOTE: Is MDI child so it is automatically displayed }
  OpenFiles(TRUE);

  { CJS 2013-04-02 - ABSEXCH-14153 - path error on local drive in SQL edition }
  // sMiscDirLocation := GetEnterpriseDirectory;

  oSettings.EXEName := 'EntCustm.dll';

  // Get System Setup Record
  BTRec.KeyS := RT_SystemSetup + BuildA10Index('');
  BTRec.Status := BTFindRecord(BT_GetEqual, FileVar[ToolF], LToolRec, BufferSize[ToolF]
  , ssIdx, BTRec.KeyS);
  case BTRec.Status of
    0 : begin
      bContinue := (not LToolRec.SysSetup.ssUsePassword) or ToolsLogin(UnScramble(LToolRec.SysSetup.ssPassword));
    end;

    4,9 : begin
      bContinue := TRUE;
    end;

    else begin
      bContinue := FALSE;
      BTShowError(BTRec.Status, 'BTFindRecord', asAppDir + aFileNames[ToolF]);
    end;
  end;{case}

  if bContinue then
  begin
    frmMenuDesigner := TfrmMenuDesigner.Create(Application.MainForm);
    EnterpriseMenu := EnterpriseMenu;
    With frmMenuDesigner Do
    begin
      OnUpdateTools := UpdateToolsMenu;
      InitialiseForm;
      ShowModal;
      Release;
    end;{with}
  end;{if}
end;

procedure TEntMenuObj.UpdateToolsMenu(Sender: TObject);
Var
  TempMenu : TMenuItem;
  I        : SmallInt;
Begin
  { add on current tools }
  AddUserTools;
end;

end.


unit DetailF;

{ nfrewer440 09:40 03/09/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , StdCtrls, ComCtrls, UDefProc, APIUtil, uExDatasets, uBtrieveDataset, StrUtil
  , ExtCtrls, uMultiList, uDBMultiList, VarConst, BTProc, Globvar, BTrvU2
  , DataModule, Menus, uSettingsSQL, uSQLDatasets, ADOSQLUtil, DB;

type
  TfrmDetails = class(TForm)
    btnOK: TButton;
    PageControl1: TPageControl;
    tabshType: TTabSheet;
    tabshList: TTabSheet;
    radDisabled: TRadioButton;
    radOptional: TRadioButton;
    radMandatory: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    btnAdd: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    btnEdit: TButton;
    btnDelete: TButton;
    tabShWindow: TTabSheet;
    btnMoveUp: TButton;
    btnMoveDown: TButton;
    btnInsert: TButton;
    Label6: TLabel;
    edtWindowCapt: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    radValidation: TRadioButton;
    lValidation: TLabel;
    radManDate: TRadioButton;
    lManDate: TLabel;
    radOptDate: TRadioButton;
    lOptDate: TLabel;
    tsBinList: TTabSheet;
    Label12: TLabel;
    btnBinAdd: TButton;
    btnBinEdit: TButton;
    btnBinDelete: TButton;
    mlBins: TDBMultiList;
    lstValues: TMultiList;
    pmMain: TPopupMenu;
    Properties1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    pmListTab: TPopupMenu;
    Properties2: TMenuItem;
    SaveCoordinates2: TMenuItem;
    pmBins: TPopupMenu;
    Properties3: TMenuItem;
    SaveCoordinates3: TMenuItem;
    sdsUDItem: TSQLDatasets;
    pdsUDItem: TBtrieveDataset;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure RadioButtonCheck(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure lstValuesStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure lstValuesDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lstValuesDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure btnInsertClick(Sender: TObject);
    procedure btnMoveDownClick(Sender: TObject);
    procedure btnMoveUpClick(Sender: TObject);
    procedure lValidationClick(Sender: TObject);
    procedure lManDateClick(Sender: TObject);
    procedure lOptDateClick(Sender: TObject);
    procedure lstValuesRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure FormShow(Sender: TObject);
    procedure btnBinAddClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure bdsUDItemGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure Button1Click(Sender: TObject);
    procedure btnBinEditClick(Sender: TObject);
    procedure mlBinsRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnBinDeleteClick(Sender: TObject);
    procedure Properties2Click(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure SaveCoordinatesClick(Sender: TObject);
    procedure Properties3Click(Sender: TObject);
    procedure pmMainPopup(Sender: TObject);
    procedure sdsUDItemGetFieldValue(Sender: TObject; Dataset: TDataSet;
      FieldName: String; var FieldValue: Variant);
    procedure pdsUDItemGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
  private
    { Private declarations }
    SelectedItemIndex : integer;
    bRestore, bBinCode : boolean;
    procedure CheckyChecky;
//    procedure MoveWithinList(NewItemIndex : integer);
    procedure SelectItem(Const ItmIdx : SmallInt);
    procedure AddAllListItemsToDBase;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
  public
    { Public declarations }
    OK : Boolean;
    SQLDataModule : TSQLDataModule;
    iFieldFolio : integer;
    Procedure DisplayNodeData(EditNode : TTreeNode; SQLDataModule : TSQLDataModule);
  end;

var
  frmDetails: TfrmDetails;

implementation

{$R *.DFM}

Uses
  MainF;

{-----------------------------------------------------------------------}

Procedure TfrmDetails.DisplayNodeData(EditNode : TTreeNode; SQLDataModule : TSQLDataModule);
Var
  NodeData : TNodeData;
  DetF     : TfrmDetails;
//  I        : SmallInt;

  function GetModeFromRadioButtons : integer;
  var
    iComp : integer;
  begin{GetModeFromRadioButtons}
    with DetF do begin
      For iComp := 0 to (ComponentCount - 1) do begin
        if (Components[iComp] is TRadioButton) then begin
          with TRadioButton(Components[iComp]) do begin
            if Checked then Result := Tag;
          end;{with}
        end;{if}
      end;{for}
    end;{with}
  end;{GetModeFromRadioButtons}

Begin { DisplayNodeData }
  Try
    Screen.cursor := crHourglass;
    DetF := TfrmDetails.Create(Application.MainForm);
    Try
      NodeData := TNodeData(EditNode.Data);
      DetF.SQLDataModule := SQLDataModule;

      With DetF, NodeData Do Begin

        bBinCode := (ndNodeName = 'Codes');

        radManDate.Enabled := not bBinCode;
        lManDate.Enabled := radManDate.Enabled;
        radOptDate.Enabled := radManDate.Enabled;
        lOptDate.Enabled := radManDate.Enabled;
        radValidation.Enabled := radManDate.Enabled;
        lValidation.Enabled := radManDate.Enabled;

        Caption := ndNode.Parent.Text + ' ' + ndNodeName + ' Properties';

        Case ndMode of
          PM_DISABLED : begin
            radDisabled.Checked := True;
            PageControl1.ActivePage := tabShType;
          end;

          PM_MANDATORY_LIST : begin
            radMandatory.Checked := True;
            if bBinCode then PageControl1.ActivePage := tsBinList
            else PageControl1.ActivePage := tabShList;
          end;

          PM_OPTIONAL_LIST : begin
            radOptional.Checked := True;
            if bBinCode then PageControl1.ActivePage := tsBinList
            else PageControl1.ActivePage := tabShList;
          end;

          PM_VALIDATION_ONLY : begin
            radValidation.Checked := True;
            PageControl1.ActivePage := tabShType;
          end;

          PM_MANDATORY_DATE : begin
            radManDate.Checked := True;
            PageControl1.ActivePage := tabShType;
          end;

          PM_OPTIONAL_DATE : begin
            radOptDate.Checked := True;
            PageControl1.ActivePage := tabShType;
          end;
        end;{case}

        if bBinCode then
        begin
        end else
        begin
          FillSLWithListItems(ndFieldFolio, lstValues.DesignColumns[0].items, SQLDataModule);
        end;


{          If (ndStrings.Count > 0) Then
            For I := 0 To Pred(ndStrings.Count) Do
  //            If (lstValues.DesignColumns[0].Items.IndexOf(ndStrings[I]) = -1) Then
                lstValues.DesignColumns[0].Items.Add(ndStrings[I]);
        end;{if}

        If (lstValues.DesignColumns[0].Items.Count > 0)
        then lstValues.selected := 0;

        edtWindowCapt.Text := ndCaption;
        CheckyChecky;
        iFieldFolio := ndFieldFolio;
        Screen.cursor := crDEfault;
        ShowModal;

        If OK Then Begin
          { Update Node }
          ndCaption := edtWindowCapt.Text;
          ndMode := GetModeFromRadioButtons;
//          if not bBinCode then ndStrings.Assign(lstValues.DesignColumns[0].Items);

          { Update Btreive file from Node }
          StoreSettings(SQLDataModule);
        End; { If }
      End; { With DetF }
    Finally
      DetF.Free;
    End;
  Except
    On Ex:Exception Do
      MessageDlg ('The following error occurred:- ' + Ex.Message, mtError, [mbOk], 0);
  End;
End; { DisplayNodeData }

{-----------------------------------------------------------------------}

procedure TfrmDetails.CheckyChecky;
begin
  tabShList.TabVisible := (radMandatory.Checked or radOptional.Checked) and radManDate.Enabled;
  tabShWindow.TabVisible := tabShList.TabVisible and radManDate.Enabled;
  tsBinList.TabVisible := (radMandatory.Checked or radOptional.Checked) and (not radManDate.Enabled);
end;

{-----------------------------------}

procedure TfrmDetails.FormCreate(Sender: TObject);
begin
  LoadAllSettings;
  OK := False;
  SelectedItemIndex := -1;
end;

{-----------------------------------}

procedure TfrmDetails.btnOKClick(Sender: TObject);
begin
  Close;
end;

{-----------------------------------}

procedure TfrmDetails.btnCancelClick(Sender: TObject);
begin
  OK := False;
  Close;
end;

{-----------------------------------}

procedure TfrmDetails.Label3Click(Sender: TObject);
begin
  radDisabled.Checked := True;
end;

{-----------------------------------}

procedure TfrmDetails.Label1Click(Sender: TObject);
begin
  radMandatory.Checked := True;
end;

{-----------------------------------}

procedure TfrmDetails.Label4Click(Sender: TObject);
begin
  radOptional.Checked := True;
end;

procedure TfrmDetails.RadioButtonCheck(Sender: TObject);
begin
  CheckyChecky;
end;

procedure TfrmDetails.btnAddClick(Sender: TObject);
Var
  NewStr : ShortString;
begin
  NewStr := InputBox('Add New Field', 'New field : ', '');

  if Length(NewStr) > 30 then
    begin
      // Too long
      MsgBox('You have entered a item with a length of more than 30 characters.'#13#13
      + 'Your item will not be added.',mtInformation,[mbOK],mbOK,'Length Error');
    end
  else begin
    if lstValues.DesignColumns[0].Items.IndexOf(NewStr) >= 0  then
      begin
        // Duplicate Item
        MsgBox('You have entered a duplicate item description.'#13#13
        + 'Your item will not be added.',mtInformation,[mbOK],mbOK,'Duplicate Item');
      end
    else begin
      if Trim(NewStr) <> '' then begin
        // add item
//        lstValues.DesignColumns[0].Items.Add (NewStr);
//        SelectItem(Pred(lstValues.DesignColumns[0].Items.Count));
        AddListItem(NewStr, iFieldFolio, lstValues.ItemsCount + 1, TRUE, SQLDataModule);
        FillSLWithListItems(iFieldFolio, lstValues.DesignColumns[0].items, SQLDataModule);
        lstValues.Selected := lstValues.DesignColumns[0].Items.IndexOf(NewStr);
      end;{if}
    end;{if}
  end;{if}
end;

procedure TfrmDetails.btnEditClick(Sender: TObject);
Var
  NewStr : String;
  iIndex : integer;
begin
  If (lstValues.Selected > -1) Then Begin
    NewStr := lstValues.DesignColumns[0].Items[lstValues.selected];
    If InputQuery('Edit Field', 'field : ', NewStr) Then Begin
      if Length(NewStr) > 30 then
        begin
          // Too long
          MsgBox('You have entered a item with a length of more than 30 characters.'#13#13
          + 'Your item will not be saved.',mtInformation,[mbOK],mbOK,'Length Error');
        end
      else begin

        iIndex := lstValues.DesignColumns[0].Items.IndexOf(NewStr);
        if (iIndex >= 0) and (iIndex <> lstValues.selected) then
          begin
            // Duplicate Item
            MsgBox('You have entered a duplicate item description.'#13#13
            + 'Your item will not be added.',mtInformation,[mbOK],mbOK,'Duplicate Item');
          end
        else begin
          // add item
          lstValues.DesignColumns[0].Items[lstValues.selected] := NewStr;

          // Delete All Items in DBase
          DeleteAllitemsForField(iFieldFolio, SQLDataModule);

          // Add All list items to DBase
          AddAllListItemsToDBase;

        end;{if}

      end;{if}
    end; { If InputBox }

    SelectItem(lstValues.selected);
  End; { If }
end;

procedure TfrmDetails.btnDeleteClick(Sender: TObject);
Var
  iPos, LstPos : LongInt;
begin
  If (lstValues.selected > -1) Then
    { Check they do want to delete the item }
    If (MessageDlg ('Are you sure you want to delete '''
    + lstValues.DesignColumns[0].Items[lstValues.selected] + '''?',
                    mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then Begin
      // delete item from list
      LstPos := lstValues.selected;
      lstValues.DeleteRow(lstValues.selected);
      If (LstPos < lstValues.DesignColumns[0].Items.Count)
      Then lstValues.selected := LstPos
      Else lstValues.selected := Pred(lstValues.DesignColumns[0].Items.Count);

      // Delete All Items in DBase
      DeleteAllitemsForField(iFieldFolio, SQLDataModule);

      // Add All list items to DBase
      AddAllListItemsToDBase;

{      FillChar(KeyS,Sizeof(KeyS),#0);
      KeyS := FullNomKey(iFieldFolio) + 00
      iStatus := Find_Rec(B_GetGEq, F[ListItemF], ListItemF, ListItemRec, liFieldLineDescIdx, KeyS);
      if (iStatus = 0) and (ListItemRec.liFieldFolio = iFieldFolio)
      and (ListItemRec.liLineNo = lstValues.selected + 1) then begin
        iStatus := Delete_Rec(F[ListItemF], ListItemF, liFieldLineDescIdx);
        if iStatus <> 0 then ShowBTError(iStatus, 'Delete_Rec', FileNames[ListItemF]);
      end;{if}

    End; { If }
end;

procedure TfrmDetails.lstValuesStartDrag(Sender: TObject;
  var DragObject: TDragObject);
{var
  I : Integer;}
begin
{  With Sender As TListBox Do
    If (SelCount > 1) Then
      DragCursor := crMultiDrag
    Else Begin
      DragCursor := crDrag;

      If (Sender = lstValues) Then
        For I := 0 to lstValues.DesignColumns[0].Items.Count -1 Do
         If lstValues.DesignColumns[0].Items[I] Then
           SelectedItemIndex := i;
    End; { Else }
end;

procedure TfrmDetails.lstValuesDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Source is TListBox;
end;

procedure TfrmDetails.lstValuesDragDrop(Sender, Source: TObject; X,
  Y: Integer);
{var
  XYPos : TPoint;
  NewItemIndex : integer;}
begin
{  if (Sender = lstValues) and (Source = lstValues) and (lstValues.SelCount = 1) then begin
    XYPos.X := X;
    XYPos.Y := Y;
    NewItemIndex := lstValues.ItemAtPos(XYPos, false);
    MoveWithinList(NewItemIndex);
  end;}
end;
{
procedure TfrmDetails.MoveWithinList(NewItemIndex : integer);
begin
  if SelectedItemIndex <> -1 then
    with lstValues.DesignColumns[0].Items do
    begin
      if abs(SelectedItemIndex - NewItemIndex) = 1 then
        Exchange(SelectedItemIndex, NewItemIndex)
      else
        if SelectedItemIndex <> NewItemIndex then
        begin
         if NewItemIndex = lstValues.DesignColumns[0].Items.Count then
           lstValues.DesignColumns[0].Items.AddObject(lstValues.DesignColumns[0].Items[SelectedItemIndex],
             lstValues.DesignColumns[0].Items.Objects[SelectedItemIndex]) else
           lstValues.DesignColumns[0].Items.InsertObject(NewItemIndex, lstValues.DesignColumns[0].Items[SelectedItemIndex],
             lstValues.DesignColumns[0].Items.Objects[SelectedItemIndex]);

          if NewItemIndex > SelectedItemIndex then
            lstValues.DeleteRow(SelectedItemIndex)
          else
            lstValues.DeleteRow(SelectedItemIndex+1)
        end;
    end;
  SelectedItemIndex := -1;
end;
}
procedure TfrmDetails.btnInsertClick(Sender: TObject);
Var
  NewStr : ShortString;
begin
  If (lstValues.selected > -1) Then
    Begin
      NewStr := InputBox('Insert New Field', 'New field:-', '');

      if Trim(NewStr) <> '' then begin
        lstValues.DesignColumns[0].Items.Insert (lstValues.selected, NewStr);
        SelectItem(lstValues.selected);

        // Delete All Items in DBase
        DeleteAllitemsForField(iFieldFolio, SQLDataModule);

        // Add All list items to DBase
        AddAllListItemsToDBase;

      end;{if}
    End { If }
  Else btnAddClick(Sender);
end;

procedure TfrmDetails.btnMoveUpClick(Sender: TObject);
begin
  If (lstValues.selected > 0) Then Begin
//    lstValues.DesignColumns[0].Items.Exchange (lstValues.selected, Pred(lstValues.selected));
    lstValues.MoveRow(lstValues.selected, Pred(lstValues.selected));
    lstValues.selected := Pred(lstValues.selected);

    // Delete All Items in DBase
    DeleteAllitemsForField(iFieldFolio, SQLDataModule);

    // Add All list items to DBase
    AddAllListItemsToDBase;

//    SelectItem(lstValues.selected);
  End; { If }
end;

procedure TfrmDetails.btnMoveDownClick(Sender: TObject);
begin
  If (lstValues.selected < Pred(lstValues.DesignColumns[0].Items.Count)) Then Begin
//    lstValues.DesignColumns[0].Items.Exchange (lstValues.selected, Succ(lstValues.selected));
    lstValues.MoveRow(lstValues.selected, Succ(lstValues.selected));
    lstValues.selected := Succ(lstValues.selected);
//    SelectItem(lstValues.selected);

    // Delete All Items in DBase
    DeleteAllitemsForField(iFieldFolio, SQLDataModule);

    // Add All list items to DBase
    AddAllListItemsToDBase;

  End; { If }
end;

procedure TfrmDetails.SelectItem(Const ItmIdx : SmallInt);
{Var
  I : SmallInt;}
Begin { SelectItem }
  If (lstValues.DesignColumns[0].Items.Count > 0) Then Begin
    { Unselect all existing options - except final option }
    {For I := 0 To Pred(lstValues.DesignColumns[0].Items.Count) Do
      If (I <> ItmIdx) Then
        lstValues.Selected[I] := False;}

    If (ItmIdx < lstValues.DesignColumns[0].Items.Count) Then Begin
      lstValues.selected := ItmIdx;
      //lstValues.Selected[ItmIdx] := True;
    End; { If }
  End; { If }
End; { SelectItem }

procedure TfrmDetails.lValidationClick(Sender: TObject);
begin
  radValidation.Checked := True;
end;

procedure TfrmDetails.lManDateClick(Sender: TObject);
begin
  radManDate.Checked := True;
end;

procedure TfrmDetails.lOptDateClick(Sender: TObject);
begin
  radOptDate.Checked := True;
end;

procedure TfrmDetails.lstValuesRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnEditClick(btnEdit);
end;

procedure TfrmDetails.FormShow(Sender: TObject);
begin
  if Assigned(SQLDataModule) then
  begin
    // SQL
    sdsUDItem.ServerAlias := GetServerFromConnectionString(SQLDataModule.ADOConnection_Company.ConnectionString);
    sdsUDItem.Database := GetDatabaseFromConnectionString(SQLDataModule.ADOConnection_Company.ConnectionString);
    sdsUDItem.TableName := asCompanyCode + '.UDITEM';

   // NF: 24/06/2011 v6.60.057 / v6.70.058
   // Fix for https://jira.iris.co.uk/browse/ABSEXGENERIC-233
   // Removed, as this is no longer needed under the latest version of the SQL Multilist
   // PrimaryKey should now never be set to anything
//    sdsUDItem.PrimaryKey := 'liDescription';

    sdsUDItem.Filter := 'liFieldFolio = ' + IntToStr(iFieldFolio);
    mlBins.Dataset := sdsUDItem;
  end
  else
  begin
    //Pervasive
    pdsUDItem.FileName := FileNames[ListItemF];
    pdsUDItem.SearchKey := FullNomKey(iFieldFolio) + FullNomKey(0);
    mlBins.Dataset := pdsUDItem;
  end;

  mlBins.Active := TRUE;
  bRestore := FALSE;
end;

procedure TfrmDetails.btnBinAddClick(Sender: TObject);
Var
  NewStr : ShortString;
begin
  NewStr := UpperCase(InputBox('Add New Bin Code', 'Bin Code : ', ''));

  if Length(NewStr) > MAX_BIN_CODE_LENGTH then
    begin
      // Too long
      MsgBox('You have entered a item with a length of more than '
      + IntToStr(MAX_BIN_CODE_LENGTH) +'  characters.'#13#13
      + 'Your item will not be added.',mtInformation,[mbOK],mbOK,'Length Error');
    end
  else begin
    if lstValues.DesignColumns[0].Items.IndexOf(NewStr) >= 0  then
      begin
        // Duplicate Item
        MsgBox('You have entered a duplicate item description.'#13#13
        + 'Your item will not be added.',mtInformation,[mbOK],mbOK,'Duplicate Item');
      end
    else begin
      if Trim(NewStr) <> '' then begin
        // add item
        AddListItem(NewStr, iFieldFolio, 0, TRUE, SQLDataModule);
        mlBins.RefreshDB;
        mlBins.SearchColumn(0, TRUE, NewStr);
      end;{if}
    end;{if}
  end;{if}
end;

procedure TfrmDetails.AddAllListItemsToDBase;
var
  iPos : integer;
begin
  For iPos := 0 To Pred(lstValues.ItemsCount)
  do AddListItem(lstValues.DesignColumns[0].Items[iPos], iFieldFolio, iPos + 1, TRUE, SQLDataModule);
end;

procedure TfrmDetails.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := FALSE;
  if bBinCode then
  begin
    if (mlBins.DesignColumns[0].Items.Count = 0) and (radMandatory.Checked or radOptional.Checked) then
      begin
        MsgBox('You must add some Bin Codes to the list, to save your settings.',mtInformation,[mbOK],mbOK,'No Bin Codes');
      end
    else begin
      OK := True;
      CanClose := TRUE;
    end;{if}
  end
  else begin
    if (lstValues.DesignColumns[0].Items.Count = 0) and (radMandatory.Checked or radOptional.Checked) then
      begin
        MsgBox('You must add some items to the list, to save your settings.',mtInformation,[mbOK],mbOK,'List Items');
      end
    else begin
      OK := True;
      CanClose := TRUE;
    end;{if}
  end;{if}
  if CanClose and (not bRestore) then SaveAllSettings;
end;

procedure TfrmDetails.bdsUDItemGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
begin
  with TListItemRec(PData^) do begin
    FieldValue := liDescription;
{    case FieldName[1] of
      'B' : FieldValue := liDescription;
    end}
  end;{with}
end;

procedure TfrmDetails.Button1Click(Sender: TObject);
begin
  if mlBins.DesignColumns[0].Sortable then ShowMessage('TRUE')
  else ShowMessage('FALSE');
end;

procedure TfrmDetails.btnBinEditClick(Sender: TObject);
Var
  NewStr : String;
  iIndex : integer;

  procedure UpdateListItem;
  var
    iStatus : integer;
    Keys : str255;
    ListItemRec : TListItemRec;
  begin {UpdateListItem}
    if Assigned(SQLDataModule) then
    begin
      // SQL
      SQLDataModule.SQLUpdateListItem(iFieldFolio, mlBins.DesignColumns[0].Items[mlBins.selected], NewStr);
    end
    else
    begin
      // Pervasive

      // find ListItem Rec
      FillChar(Keys,Sizeof(KeyS),#0);
      KeyS := FullNomKey(iFieldFolio) + FullNomKey(0)
      + TListItemRec(pdsUDItem.GetRecord^).liDescription;
      iStatus := Find_Rec(B_GetEq, F[ListItemF], ListItemF, ListItemRec, liFieldLineDescIdx, KeyS);
      if iStatus = 0 then
      begin
        // update ListItem rec
        ListItemRec.liDescription := PadString(psRight, NewStr, #0, length(ListItemRec.liDescription));
        iStatus := Put_Rec(F[ListItemF], ListItemF, ListItemRec, liFieldLineDescIdx);
        ShowBTError(iStatus, 'Put_Rec', FileNames[ListItemF]);
      end;{if}
    end;{if}
  end;{UpdateListItem}

  function ListItemExists : boolean;
  var
    iStatus : integer;
    Keys : str255;
    ListItemRec : TListItemRec;
  begin {ListItemExists}
    if Assigned(SQLDataModule) then
    begin
      // SQL
      Result := SQLDataModule.SQLListItemExists(iFieldFolio, NewStr);
    end
    else
    begin
      // Pervasive
      
      // find ListItem Rec
      FillChar(Keys,Sizeof(KeyS),#0);
      KeyS := FullNomKey(iFieldFolio) + FullNomKey(0)
      + PadString(psRight,NewStr,#0,length(ListItemRec.liDescription));
      iStatus := Find_Rec(B_GetEq, F[ListItemF], ListItemF, ListItemRec, liFieldLineDescIdx, KeyS);
      ListItemExists := iStatus = 0
    end;{if}
  end;{ListItemExists}

begin{btnBinEditClick}
  If (mlBins.Selected > -1) Then Begin

    if Assigned(SQLDataModule) then
    begin
      // SQL
      NewStr := Trim(mlBins.DesignColumns[0].Items[mlBins.selected]);
    end
    else
    begin
      // Pervasive
      NewStr := Trim(TListItemRec(pdsUDItem.GetRecord^).liDescription);
    end;

    If InputQuery('Edit Field', 'field : ', NewStr) Then Begin

      NewStr := UpperCase(NewStr);

      // It's the same, so don't bother updating
//      if Trim(NewStr) = Trim(TListItemRec(bdsUDItem.GetRecord^).liDescription) then exit;

      if Length(NewStr) > 10 then
        begin
          // Too long
          MsgBox('You have entered a Bin Code with a length of more than 10 characters.'#13#13
          + 'Your item will not be saved.',mtInformation,[mbOK],mbOK,'Length Error');
        end
      else begin

        if ListItemExists then
          begin
            // Duplicate Item
            MsgBox('You have entered a duplicate Bin Code description.'#13#13
            + 'Your item will not be added.',mtInformation,[mbOK],mbOK,'Duplicate Item');
          end
        else begin
          // edit item in list
          UpdateListItem;
          mlBins.RefreshDB;
          mlBins.SearchColumn(0, TRUE, NewStr);
        end;{if}

      end;{if}
    end; { If InputBox }

//    SelectItem(mlBins.selected);
  End; { If }
end;{btnBinEditClick}

procedure TfrmDetails.mlBinsRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnBinEditClick(btnBinEdit);
end;

procedure TfrmDetails.btnBinDeleteClick(Sender: TObject);

  procedure DeleteListItem;
  var
    iStatus : integer;
    Keys : str255;
    ListItemRec : TListItemRec;
  begin {DeleteListItem}
    if Assigned(SQLDataModule) then
    begin
      // SQL
      SQLDataModule.SQLDeleteListItem(iFieldFolio, Trim(mlBins.DesignColumns[0].Items[mlBins.selected]));
    end
    else
    begin
      // Pervasive

      // find ListItem Rec
      FillChar(Keys,Sizeof(KeyS),#0);
      KeyS := FullNomKey(iFieldFolio) + FullNomKey(0)
      + TListItemRec(pdsUDItem.GetRecord^).liDescription;
      iStatus := Find_Rec(B_GetEq, F[ListItemF], ListItemF, ListItemRec, liFieldLineDescIdx, KeyS);
      if iStatus = 0 then
      begin
        // delete ListItem rec
        iStatus := Delete_Rec(F[ListItemF], ListItemF, liFieldLineDescIdx);
        ShowBTError(iStatus, 'Delete_Rec', FileNames[ListItemF]);
      end;{if}
    end;{if}
  end;{DeleteListItem}

var
  sDesc : string;

begin
  if (mlBins.selected > -1) Then begin
    { Check they do want to delete the item }

    if Assigned(SQLDataModule) then
    begin
      // SQL
      sDesc := mlBins.DesignColumns[0].Items[mlBins.selected];
    end
    else
    begin
      // Pervasive
      sDesc := TListItemRec(pdsUDItem.GetRecord^).liDescription;
    end;{if}

    if (MessageDlg ('Are you sure you want to delete ''' + sDesc + '''?'
    , mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
    Begin
      // delete item from list
      DeleteListItem;
      mlBins.RefreshDB;
      mlBins.SearchColumn(0, TRUE, sDesc);
    end;{If}
  end;{If}
end;

procedure TfrmDetails.SaveAllSettings;
begin
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
  oSettings.SaveParentFromControl(edtWindowCapt, Self.Name);
  oSettings.SaveList(lstValues, Self.Name);
  oSettings.SaveList(mlBins, Self.Name);
end;

procedure TfrmDetails.LoadAllSettings;
begin
  oSettings.LoadForm(Self);
  oSettings.LoadParentToControl(Self.Name, Self.Name, edtWindowCapt);
  oSettings.ColorFieldsFrom(edtWindowCapt, Self);
  oSettings.LoadList(lstValues, Self.Name);
  oSettings.LoadList(mlBins, Self.Name);
end;

procedure TfrmDetails.Properties2Click(Sender: TObject);
begin
  case oSettings.Edit(lstValues, Self.Name, nil) of
    mrOK : ;
    mrRestoreDefaults : begin
      oSettings.RestoreListDefaults(lstValues, Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TfrmDetails.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(nil, Self.Name, edtWindowCapt) of
    mrOK : oSettings.ColorFieldsFrom(edtWindowCapt, Self);
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TfrmDetails.SaveCoordinatesClick(Sender: TObject);
begin
  SaveCoordinates1.checked := not SaveCoordinates1.checked;
  SaveCoordinates2.checked := not SaveCoordinates2.checked;
  SaveCoordinates3.checked := not SaveCoordinates3.checked;
end;

procedure TfrmDetails.Properties3Click(Sender: TObject);
begin
  if oSettings.Edit(mlBins, Self.Name, nil) = mrRestoreDefaults then
  begin
    oSettings.RestoreListDefaults(mlBins, Self.Name);
    bRestore := TRUE;
  end;{if}
end;

procedure TfrmDetails.pmMainPopup(Sender: TObject);
begin
  Properties1.Enabled := tabShWindow.TabVisible;
end;

procedure TfrmDetails.sdsUDItemGetFieldValue(Sender: TObject;
  Dataset: TDataSet; FieldName: String; var FieldValue: Variant);
begin
  FieldValue := Dataset.FieldByName(FieldName).AsVariant;
end;

procedure TfrmDetails.pdsUDItemGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
begin
  with TListItemRec(PData^) do begin
    FieldValue := liDescription;
{    case FieldName[1] of
      'B' : FieldValue := liDescription;
    end}
  end;{with}
end;

end.

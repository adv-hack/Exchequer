unit LayList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GlobVar, BtrvU2, VarConst, BTKeys1U, ComCtrls, StdCtrls, {NeilProc,}
  IAeverButton, EPOSCnst, GfxUtil, EPOSProc, StrUtil;

type
  TfrmLayaways = class(TForm)
    lvLayaways: TListView;
    btnOK: TIAeverButton;
    btnCancel: TIAeverButton;
    btnDelete: TIAeverButton;
    btnAllUsers: TIAeverButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure lvLayawaysChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnAllUsersClick(Sender: TObject);
  private
    bShowAllUsers : boolean;
    procedure EnableDisable;
    procedure FillList;
  public
    procedure DeleteLayaway(iFolioNo : integer);
  end;

var
  frmLayaways: TfrmLayaways;

implementation
uses
  EPOSKey;

{$R *.dfm}

procedure TfrmLayaways.FormCreate(Sender: TObject);
var
  iStatus : integer;
  sOldSetDrive : string;
begin
  if SysColorMode in ValidColorSet then DrawFormBackground(self, bitFormBackground);
  bShowAllUsers := FALSE;

  FillList;
end;

procedure TfrmLayaways.FillList;
var
  iPos, iLine, iHeadStatus, iLineStatus : integer;
  sKey : Str255;
  NewItem : TListItem;
begin
  lvLayaways.Clear;

  // Get First Header
  FillChar(sKey,SizeOf(sKey),#0);
  iHeadStatus := Find_Rec(B_GetFirst, F[LayHeadF], LayHeadF, RecPtr[LayHeadF]^, LayHeadFolioK, sKey);

  While iHeadStatus = 0 do begin

    with LayHead do begin
      if (Uppercase(lhUserName) = Uppercase(sUsername)) or bShowAllUsers then begin
        NewItem := lvLayaways.Items.Add;

        NewItem.Caption := DateToStr(Str8ToDate(lhDate));
        NewItem.SubItems.Add(lhUserName);
        NewItem.SubItems.Add(lhAccountCode);
        NewItem.SubItems.Add(lhAccountName);
        NewItem.SubItems.Add(lhCustomerName);
        NewItem.SubItems.Add(lhOrderNo);
        NewItem.SubItems.Add(MoneyToStr(lhValue));
        NewItem.SubItems.Add(layhead.lhItemsDesc);

        NewItem.Data := TItemInfo.Create;
        TItemInfo(NewItem.Data).ID := lhFolioNo;
      end;{if}
    end;{with}

    // Get Next Header
    iHeadStatus := Find_Rec(B_GetNext, F[LayHeadF], LayHeadF, RecPtr[LayHeadF]^, LayHeadFolioK, sKey);
  end;{while}

  if lvLayaways.Items.count > 0 then begin
    lvLayaways.Selected := lvLayaways.Items[0];
    lvLayaways.ItemFocused := lvLayaways.Items[0];
  end;{if}

  EnableDisable;
end;

procedure TfrmLayaways.btnOKClick(Sender: TObject);
begin
{$IFNDEF TRADESETUP}
  if lvLayaways.Selected <> nil then ModalResult := mrOK;
{$ENDIF}
end;

procedure TfrmLayaways.EnableDisable;
begin
  btnOK.Enabled := (lvLayaways.selected <> nil);
  btnDelete.Enabled := (lvLayaways.selected <> nil) and aAllowedTo[atDeleteLayaways];
  btnAllUsers.Enabled := aAllowedTo[atSeeAllLayaways];

{$IFDEF TRADESETUP}
  btnOK.Enabled := FALSE;
{$ENDIF}

end;

procedure TfrmLayaways.DeleteLayaway(iFolioNo : integer);
var
  iStatus : integer;
  sKey : Str255;
begin
  // Find Header
  sKey := FullNomKey(iFolioNo) + IDX_DUMMY_CHAR;
  iStatus := Find_Rec(B_GetEq, F[LayHeadF], LayHeadF, RecPtr[LayHeadF]^, LayHeadFolioK, sKey);
  if iStatus = 0 then begin

    // Delete header
    iStatus := Delete_Rec(F[LayHeadF], LayHeadF, LayHeadFolioK);

    if iStatus = 0 then begin

      // Delete Lines

      // Get First TX Line Record
      sKey := FullNomKey(iFolioNo);
      iStatus := Find_Rec(B_GetGEq, F[LayLineF], LayLineF, RecPtr[LayLineF]^, LayLineK, sKey);

      while (iStatus = 0) and (LayLine.llHeaderNo = iFolioNo) do begin

        // delete line Record
        iStatus := Delete_Rec(F[LayLineF], LayLineF, LayLineK);

        if iStatus = 0 then begin
          // Delete Serial Number Records for the TX Line

          // Get First Record
          sKey := FullNomKey(iFolioNo) + FullNomKey(LayLine.llLineNo) + IDX_DUMMY_CHAR;
          iStatus := Find_Rec(B_GetEq, F[LaySerialF], LaySerialF, RecPtr[LaySerialF]^, lsFindSerialK, sKey);

          while (iStatus = 0) and (LaySerial.lsHeaderNo = iFolioNo)
          and (LaySerial.lsLineNo = LayLine.llLineNo) do begin

            // delete serial Record
            Delete_Rec(F[LaySerialF], LaySerialF, lsFindSerialK);

            // Get Next Serial Record
            sKey := FullNomKey(iFolioNo) + FullNomKey(LayLine.llLineNo) + IDX_DUMMY_CHAR;
            iStatus := Find_Rec(B_GetEq, F[LaySerialF], LaySerialF, RecPtr[LaySerialF]^, lsFindSerialK, sKey);
          end;{while}


          // Delete Bin Number Records for the TX Line

          // Get First Record
          sKey := FullNomKey(iFolioNo) + FullNomKey(LayLine.llLineNo) + IDX_DUMMY_CHAR;
          iStatus := Find_Rec(B_GetEq, F[LayBinF], LayBinF, RecPtr[LayBinF]^, lbFindBinK, sKey);

          while (iStatus = 0) and (LayBin.lbHeaderNo = iFolioNo)
          and (LayBin.lbLineNo = LayLine.llLineNo) do begin

            // delete Bin Record
            Delete_Rec(F[LayBinF], LayBinF, lbFindBinK);

            // Get Next Bin Record
            sKey := FullNomKey(iFolioNo) + FullNomKey(LayLine.llLineNo) + IDX_DUMMY_CHAR;
            iStatus := Find_Rec(B_GetEq, F[LayBinF], LayBinF, RecPtr[LayBinF]^, lbFindBinK, sKey);
          end;{while}

        end;{if}

        // Get Next TX Line Record
        sKey := FullNomKey(iFolioNo);
        iStatus := Find_Rec(B_GetGEq, F[LayLineF], LayLineF, RecPtr[LayLineF]^, LayLineK, sKey);
      end;{while}
    end;{if}
  end;{if}
end;


procedure TfrmLayaways.btnDeleteClick(Sender: TObject);
begin
  if (lvLayaways.Selected <> nil) and aAllowedTo[atDeleteLayaways] then begin
    if MyMsgBox('Are you sure you want to delete this Layaway ?',mtConfirmation
    ,[mbYes, mbNo],mbNo,'Delete Layaway') = mrYes then begin
      DeleteLayaway(TItemInfo(lvLayaways.Selected.Data).ID);
      FillList;
    end;{if}
  end;{if}
end;

procedure TfrmLayaways.lvLayawaysChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  EnableDisable
end;

procedure TfrmLayaways.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LocalKey : Word;
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
  LocalKey := Key;
  Key := 0;

  {trap function Keys}
  If (LocalKey In [VK_F1..VK_F12, VK_DELETE]) and (Not (ssAlt In Shift)) then
    begin
      case LocalKey of
//        VK_F1 : Application.HelpCommand(HELP_Finder,0);
        VK_F4 : btnAllUsersClick(btnAllUsers);
        VK_F9 : btnOKClick(btnOK);
        VK_DELETE : btnDeleteClick(btnDelete);
        else Key := LocalKey;
      end;{case}
    end
  else Key := LocalKey;
end;

procedure TfrmLayaways.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TfrmLayaways.btnAllUsersClick(Sender: TObject);
begin
  if bShowAllUsers then btnAllUsers.Caption := 'Show All Users'
  else btnAllUsers.Caption := 'Show Mine';
  bShowAllUsers := not bShowAllUsers;
  FillList;
end;

end.

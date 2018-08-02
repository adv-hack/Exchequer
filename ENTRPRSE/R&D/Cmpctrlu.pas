unit CmpCtrlU;

interface

uses
  SysUtils, Windows, Classes, Graphics, Controls,Forms,StdCtrls,ExtCtrls,ComCtrls,
  Menus,SBSPanel,GlobVar,VarConst,BtrvU2,BTsupU1,BtKeys1U;


{$H-}

type

  {* Attempt at regenerating basic Tcontrol with access to properties *}

  TGlobControl  =  Class(TControl)

  Public

    Property Color;
    Property Font;

  end;

TGlobCompRec =  ^GlobCompRec;

GlobCompRec  =  Object
                  GlobName  :  String[80];
                  GlobColor :  TColor;
                  GlobFont  :  TFont;
                  ColOrd    :  Integer;
                  HLite,
                  HTLite    :  TColor;

                  GlobLeft,
                  GlobTop,
                  GlobWidth,
                  GlobHeight:  Integer;

                  SaveCoord,
                  HasCoord,
                  GetValues,
                  GenFont    :  Boolean;

                  PrimeKey   :  Str5;

                  Constructor Create(CreateFont  :  Boolean);

                  Destructor Destroy;

                  Function Getbtcsm(UpValues    :  Boolean)  :  Boolean;

                  Function Check4Change :  Boolean;

                  Procedure Storebtcsm(UpMode    :  Boolean);

                  Procedure SetPosition(StoreComp  :  TObject);

                  Function FixOnName(Name  :  Str255)  :  Str255;

                  Function GetbtControlcsm(StoreComp    :  TObject)  :  Boolean;

                  Procedure StorebtControlcsm(StoreComp    :  TObject);

                end;



Procedure Delete_PosRecs;

Function pcLivePage(PCtrl  :  TObject)  :  Integer;

Procedure Check_TabAfterPW(PCTrl  :  TPageControl;
                           PForm  :  TForm;
                           WMH    :  THandle);

Procedure Release_PageHandleEx(PCtrl,TSCtrl  :  TObject);

Procedure Release_PageHandle(PCtrl  :  TObject);

Procedure FieldNextFix(MHandle  :  THandle;
                       NewCtrl,
                       OldCtrl  :  TObject);

procedure DeleteIdxSubMenu(Var Source   :  TMenuItem;
                               RefCount :  LongInt);

procedure DeleteSubMenu(Var Source  :  TMenuItem);

procedure CreateSubMenu(Const Source  :  TPopUpMenu;
                        Var   Dest    :  TMenuItem);

procedure CreateSubMenuSuffix(Const Source  :  TPopUpMenu;
                              Var   Dest    :  TMenuItem;
                                    Suffix  :  Char;
                                    MatchVis:  Boolean);

procedure CreateIdxSubMenu(Const Source  :  TPopUpMenu;
                                 RefCountM:  LongInt;
                           Var   Dest    :  TMenuItem;
                                 Suffix  :  Char;
                                 MatchVis:  Boolean);

procedure UpdateSubMenu(Const Source  :  TPopUpMenu;
                              RefCount:  LongInt;
                        Var   Dest    :  TMenuItem;
                              Extended: Boolean = False);

//PL 07/02/2017 2017-R1 ABSEXCH-13159 :  added ability to post Single Transaction on Daybook posting 
procedure UpdateSubMenuItemCaption(Const Source  :  TPopUpMenu;
                                         RefCount:  LongInt;
                                   Var   Dest    :  TMenuItem;
                                         Extended: Boolean = False);


procedure SetCheckedMenuItems(Const Source  :  TMenuItem;
                                    RefCount:  Integer;
                                    BTagNo  :  Integer);

procedure SetCheckedPopUpMenu(Const Source  :  TPopUpMenu;
                                    RefCount:  Integer;
                                    BTagNo  :  Integer);

Function CanShowPMenu(Const Source  :  TMenuItem)  :  Boolean;


Function CheckFormNeedStoreChk(F  :  TForm;
                               ResetOn
                                   : Boolean)  :  Boolean;

Function CheckFormNeedStore(F  :  TForm)  :  Boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Messages,
  Dialogs,
  Mask,
  BorBtns,
  {$IFDEF EXSQL}
  SQLUtils,
  SQLFuncs,
  {$ENDIF}
  {$IFDEF Enter1}
  EntWindowSettings,
  {$ENDIF}
  TEditVal;


Constructor GlobCompRec.Create(CreateFont  :  Boolean);

Begin
  GenFont:=CreateFont;

  If (GenFont) then
    GlobFont:=TFont.Create;

  GlobName:='';
  GlobColor:=0;
  ColOrd:=0;
  HLite:=0;
  HTLite:=0;
  GlobLeft:=0;
  GlobTop:=0;
  GlobWidth:=0;
  GlobHeight:=0;

  FillChar(PrimeKey,Sizeof(PrimeKey),0);

  HasCoord:=BOff;
  SaveCoord:=BOff;
  GetValues:=BOff;
end;

Destructor GlobCompRec.Destroy;

Begin

  If (GenFont) then
    GlobFont.Free;

end;


Function GlobCompRec.Getbtcsm(UpValues    :  Boolean)  :  Boolean;


Const
  Fnum       =  MiscF;
  Keypath    =  MIK     ;

Var
  KeyS    :  Str255;


Begin

  KeyS:=btCustTCode+BtCustSCode+FullCompoKey(GlobName,EntryRec^.Login);

  Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  Result:=StatusOk;

  If (Result) and (UpValues) then
  With MiscRecs^.btCustomRec do
  Begin
    GlobColor:=BkgColor;

    With GlobFont do
    Begin
      Name:=FontName;
      Size:=FontSize;
      Color:=FontColor;
      Style:=FontStyle;
      Pitch:=FontPitch;
      Height:=FontHeight;
    end;

    ColOrd:=LastColOrder;

    GlobLeft:=Position.Left;
    GlobTop:=Position.Top;
    GlobWidth:=Position.Right;
    GlobHeight:=Position.Bottom;

    HLite:=HighLight;
    HTLite:=HighText;
  end; {If found & Update..}
end; {Proc..}


Function GlobCompRec.Check4Change :  Boolean;

Begin
  Result:=BOff;

  With MiscRecs^.btCustomRec do
  Begin
    Result:=(GlobColor<>BkgColor);

    If (Not Result) then
      With GlobFont do
        Result:=((Name<>FontName) or (Size<>FontSize) or (Color<>FontColor) or (Style<>FontStyle) or (Pitch<>FontPitch) or
                 (Height<>FontHeight));

    If (Not Result) then
      Result:=((ColOrd<>LastColOrder) or (GlobLeft<>Position.Left) or (GlobTop<>Position.Top)
               or (GlobWidth<>Position.Right) or (GlobHeight<>Position.Bottom));

    If (Not Result) then
      Result:=((HLite<>HighLight) or (HTLite<>HighText));

  end; {With..}

end;

Procedure GlobCompRec.Storebtcsm(UpMode    :  Boolean);


Const
  Fnum       =  MiscF;
  Keypath    =  MIK;

Var
  NeedUpdate,
  Locked,
  NewRec  :  Boolean;

  KeyS    :  Str255;

  LAddr   :  LongInt;


Begin
  Locked:=BOff;

  

  NewRec:=Not GetbtCsm(BOff);

  NeedUpdate:=NewRec;

  If (NewRec) then
  With MiscRecs^ do
  Begin
    ResetRec(Fnum);

    RecMFix:=btCustTCode;
    SubType:=btCustSCode;

    Ok:=UpMode;
    Locked:=UpMode;
  end
  else
    Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,Keypath,Fnum,BOn,Locked,LAddr);

  If (Ok) and (Locked) then
  With MiscRecs^.btCustomRec do
  Begin
    If (Not NewRec) and (UpMode) then
      NeedUpDate:=Check4Change;

    If (NeedUpDate) or (Not UpMode) then
    Begin
      If (UpMode) then
      Begin

        BkgColor:=GlobColor;

        With GlobFont do
        Begin
          FontName:=Name;
          FontSize:=Size;
          FontColor:=Color;
          FontStyle:=Style;
          FontPitch:=Pitch;
          FontHeight:=Height;
        end;

        LastColOrder:=ColOrd;

        If (SaveCoord) then
        Begin

          Position:=Rect(GlobLeft,GlobTop,GlobWidth,GlobHeight);
        end;

        CompName:=GlobName;
        UserName:=EntryRec^.Login;
        HighLight:=HLite;
        HighText:=HTLite;

        CustomKey:=FullCompoKey(CompName,UserName);

        UserKey:=FullCompoKey(UserName,CompName);


        If (NewRec) then
          Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath)
        else
        Begin
          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          If (StatusOk) then
            Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
        end;
      end
      else
        Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);
    end
    else
      Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

    Report_BError(Fnum,Status);

  end; {If Found/Locked..}

end; {Proc..}

Procedure GlobCompRec.SetPosition(StoreComp  :  TObject);

Begin
  With TGlobControl(StoreComp) do
  Begin
    Left:=GlobLeft;
    Top:=GlobTop;
    Width:=GlobWidth;
    Height:=GlobHeight;
  end;
end;


Function GlobCompRec.FixOnName(Name  :  Str255)  :  Str255;

Var
  UPos  :  Byte;

Begin
  Result:=Name;

  UPos:=Pos('_',Name);

  If (UPos<>0) and (UPos>=(Length(Name)-3)) then
  Begin
    Result:=Copy(Name,1,Pred(UPos));
  end;
end;


Function GlobCompRec.GetbtControlcsm(StoreComp    :  TObject)  :  Boolean;
Begin

  With TGlobControl(StoreComp) do
    GlobName:=PrimeKey+FixOnName(Name);

  Result:=GetbtCsm(GetValues);

  If (Result) and (GetValues) then
  With TGlobControl(StoreComp) do
  Begin
    If (Not (StoreComp is TButton)) then
      Color:=GlobColor;

    Font:=GlobFont;

    If (HasCoord) and (GlobWidth>0) and (GlobHeight>0) then
      SetPosition(StoreComp);

  end;

end; {Func..}


Procedure GlobCompRec.StorebtControlcsm(StoreComp    :  TObject);



Begin

  With TGLobControl(StoreComp) do
  Begin
    GlobName:=PrimeKey+FixOnName(Name);
    GlobFont:=Font;

    If (Not (StoreComp is TButton)) then
      GlobColor:=Color;

    GlobLeft:=Left;
    GlobTop:=Top;
    GlobWidth:=Width;
    GlobHeight:=Height;

  end;

  StorebtCsm(GetValues);

end; {Proc..}


{ ======== Procedure to clear all position records ========= }

Procedure Delete_PosRecs;

Const
  Fnum     =  MiscF;
  Keypath  =  MIK;

Var
  Mbret  :  Word;

  KeyS,
  KeyChk :  Str255;

  B_Func :  Integer;

  OnlyThisU
         :  Boolean;

  LAddr  :  LongInt;
  {$IFDEF Enter1}
  oSettings : IWindowSettings;
  {$ENDIF}
Begin

  OnlyThisU:=BOff;

  If (SBSIn) then
    mbRet:=MessageDlg('Delete ALL position records?',mtConfirmation,[mbYes,mbNo],0)
  else
    mbRet:=mrNo;

  if (mbRet=mrNo) then
  Begin
    mbRet:=MessageDlg('Delete this user position records?',mtConfirmation,[mbYes,mbNo],0);
    OnlyThisU:=BOn;
  end;

  If (mbRet=mrYes) then
  Begin
    {$IFDEF Enter1}
      oSettings := GetWindowSettings('');
      if Assigned(oSettings) then
      Try
        if OnlyThisU then
          oSettings.DeleteAllSettingsForUser
        else
          oSettings.DeleteAllSettings;
      Finally
        oSettings := nil;
      End;
    {$ENDIF}
{$IFDEF EXSQL}
    if SQLUtils.UsingSQLAlternateFuncs then
    begin
      if OnlyThisU then
        Status := SQLFuncs.ResetCustomSettings(SetDrive, EntryRec^.Login)
      else
        Status := SQLFuncs.ResetCustomSettings(SetDrive, '');
      if (Status = 0) then
        MessageDlg('Custom settings deleted', mtInformation, [mbOk], 0)
      else
        MessageDlg('Failed to delete custom settings, error #' + IntToStr(Status),
                   mtError, [mbOk], 0);
    end
    else
{$ENDIF}
    begin
      KeyChk:=PartCCKey(btCustTCode,btCustSCode);

      If (OnlyThisU) then
        KeyChk:=KeyChk+EntryRec^.Login;
      
      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      Begin

        Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,GlobLocked,LAddr);

        If (Ok) and (GlobLocked) then
        Begin

          Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

          Report_BError(Fnum,Status);

          If (StatusOk) then
            B_Func:=B_GetGEq
          else
            B_Func:=B_GetNext;

        end
        else
          B_Func:=B_GetNext;

        Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end; {While..}
    end;
  end; {If confirmed..}

end;


{ ======== Function to Return Current Live Page for PageControl ======= }

Function pcLivePage(PCtrl  :  TObject)  :  Integer;

Begin
  Result := 0;
  If (Assigned(PCtrl)) then
  Begin
      If (PCtrl is TPageControl) then
        With (PCtrl as TPageControl) do
        Begin
          If (Assigned(ActivePage)) then
            Result:=(ActivePage as TTabSheet).PageIndex
          else
            Result:=0;
        end
        else
          Result:=0;
  end;
end; {Func..}

Procedure Check_TabAfterPW(PCTrl  :  TPageControl;
                           PForm  :  TForm;
                           WMH    :  THandle);

Var
  TmpPage    :  TTabSheet;
  CloseForm  :  Boolean;

Begin
  TmpPage:=nil;

  Closeform:=BOff;

  With PCtrl do
  If Assigned(ActivePage) then
  Begin
    If (Not ActivePage.TabVisible) then
    Begin
      TmpPage:=FindNextPage(ActivePage,BOn,BOn);

      If (Assigned(TmpPage)) then
        SendMessage(PForm.Handle,WMH,175,0)
      else
        CloseForm:=BOn;
    end;

  end
  else
    CloseForm:=BOn;

  If (CloseForm) then
    SendMessage(PForm.Handle,WM_Close,0,0);
end;


{== Procedure to preserve/restore Combobox indexs during a handle release == }
Procedure PopCombo(Pctrl  :  TObject;
                   PushOn :  Boolean);

Var
  n  :  Integer;


Begin
  If (PCtrl is TWInControl) then
    With TWinControl(PCtrl) do
    Begin
      For n:=0 to Pred(ControlCount) do
        If (Controls[n] is TSBSComboBox) then
        Begin
          With TSBSComboBox(Controls[n]) do
          Begin
            If (PushOn) then
              OldIndex:=ItemIndex
            else
              ItemIndex:=OldIndex;
          end;
        end
        else
          If (Controls[n] is TWinControl) then
            If (TWinControl(Controls[n]).ControlCount>0) then
              PopCombo(Controls[n],PushOn);
    end; {With..}
end;

{ ====== Procedure to release window handles between page changes ==== }

Procedure Release_PageHandleEx(PCtrl,TSCtrl  :  TObject);

Var
  n         :  Integer;
  aPage     :  TWinControl;


Begin
  If (PCtrl is TPageControl)  and (TSCtrl is TTabSheet) then
    With TPageControl(PCtrl) do
    Begin
      PopCombo(TTabSheet(TSCtrl),BOn);

      aPage:=TWinControl(TTabSheet(TSCtrl));

      LockWindowUpdate(Handle);

      THintWindow(aPage).ReleaseHandle;

      For n:=0 to Pred(PageCount) do
        TWinControl(Pages[n]).HandleNeeded;

      LockWindowUpdate(0);

      PopCombo(TTabSheet(TSCtrl),BOff);

    end;{With..}
end;{Proc..}


Procedure Release_PageHandle(PCtrl  :  TObject);


Begin
  If (PCtrl is TPageControl)  then
  With TPageControl(PCtrl) do
    Begin
      Release_PageHandleEx(PCtrl,ActivePage);
    end;{With..}
end;{Proc..}



Procedure FieldNextFix(MHandle  :  THandle;
                       NewCtrl,
                       OldCtrl  :  TObject);
Var
  Direc    :  Boolean;

Begin
  Direc:=BOff;

  If (NewCtrl is TWinControl) and (OldCtrl is TWinControl) then
  Begin
    Direc:=(TWinControl(NewCtrl).TabOrder<TWinControl(OldCtrl).TabOrder);
    PostMessage(TWinControl(NewCtrl).Handle,CM_Enter,0,0);
  end;

  PostMessage(MHandle,wm_NextDlgCtl,Ord(Direc),0);
  PostMessage(MHandle,wm_NextDlgCtl,Ord(Not Direc),0);

end;


{ ======= Proc to Delete a submenu from a popupMenu ====== }

procedure DeleteIdxSubMenu(Var Source   :  TMenuItem;
                               RefCount :  LongInt);


Var
  n        :  LongInt;

Begin
  //GS: 09/05/11 ABSEXCH-10801: modified the 'Find menu count' code to use the Delphi API
  //instead of using Windows API calls (GetMenuItemCount)
  //also modified the logic; IF statement was getting the 'source' popup menu item count twice,
  //could not see any reason for it so removed the WinAPI call
  //Old IF statement: If (Pred(GetMenuItemCount(Handle))>=0) or (Count>0) then
  With Source do
  //If the menu object argument has sub-menu options..
  if Count > 0 then
  Begin
    //turn all sub-menu options invisible..
    For n:=0 to RefCount do
      Items[n].Visible:=BOn;
    //then delete the sub-menu
    DeleteSubMenu(Source);
  end;
end;

{ ======= Proc to Delete a submenu from a popupMenu ====== }

procedure DeleteSubMenu(Var Source  :  TMenuItem);


Var
  n        :  LongInt;

Begin
  //GS: 09/05/11 ABSEXCH-10801: modified the 'Find menu count' code to use the Delphi API
  //instead of using Windows API calls (GetMenuItemCount)
  With Source do
  Begin
    //get the number of sub-menu items belonging to the given menu item
    n:=Pred(Count);
    //while the menu item has sub-menu items..
    //delete the first item and recount the remaining items, repeat until no items are left
    While n>=0 do
    Begin
      Items[0].Free;
      n:=Pred(Count);
    end;
  end;
end;




{ ======= Proc to Create a submenu from a popupMenu ====== }

procedure CreateIdxSubMenu(Const Source  :  TPopUpMenu;
                                 RefCountM:  LongInt;
                           Var   Dest    :  TMenuItem;
                                 Suffix  :  Char;
                                 MatchVis:  Boolean);


Var
  n        :  Integer;
  MICount  :  LongInt;
  NewItem  :  TMenuItem;

Begin
  MICount:=RefCountM;

  With Source do
    For n:=0 to MICount do
    Begin
      NewItem:=TMenuItem.Create(Owner);
      NewItem.Caption:=Items[n].Caption;
      NewItem.OnClick:=Items[n].OnClick;
      NewItem.Name:=Items[n].Name+Suffix;
      NewItem.Tag:=Items[n].Tag;
      NewItem.Hint:=Items[n].Hint;
      NewItem.Checked:=Items[n].Checked;
      NewItem.HelpContext:=Items[n].HelpContext;

      If (MatchVis) then
        NewItem.Visible:=Items[n].Visible;


      Dest.Add(NewItem);
    end;
end;


{ ======= Proc to Create a submenu from a popupMenu ====== }

procedure CreateSubMenuSuffix(Const Source  :  TPopUpMenu;
                              Var   Dest    :  TMenuItem;
                                    Suffix  :  Char;
                                    MatchVis:  Boolean);



Begin
  With Source do
    //GS: 09/05/11 ABSEXCH-10801: modified the 'Find menu count' code to use the Delphi API
    //instead of using Windows API calls (GetMenuItemCount)
    CreateIdxSubMenu(Source,Pred(Source.Items.Count),Dest,Suffix,MatchVis);
end;

{ ======= Proc to Create a submenu from a popupMenu ====== }

procedure CreateSubMenu(Const Source  :  TPopUpMenu;
                        Var   Dest    :  TMenuItem);



Begin
  CreateSubMenuSuffix(Source,Dest,'X',BOff);
end;



{ ======= Proc to Create a submenu from a popupMenu ====== }

procedure UpdateSubMenu(Const Source  :  TPopUpMenu;
                              RefCount:  LongInt;
                        Var   Dest    :  TMenuItem;
                              Extended: Boolean);


Var
  n        :  Integer;

Begin

  For n:=0 to RefCount do
  Begin
    Dest.Items[n].Hint:=Source.Items[n].Hint;
    Dest.Items[n].HelpContext:=Source.Items[n].HelpContext;
    Dest.Items[n].Visible:=Source.Items[n].Visible;
    if Extended then
    begin
      Dest.Items[n].Checked := Source.Items[n].Checked;
      Dest.Items[n].Enabled := Source.Items[n].Enabled;
    end;
  end;
end;

procedure UpdateSubMenuItemCaption(Const Source  :  TPopUpMenu;
                                         RefCount:  LongInt;
                                   Var   Dest    :  TMenuItem;
                                         Extended: Boolean = False);
Var
  n        :  Integer;
begin
  For n:=0 to RefCount do
  Begin
    if (Dest.Items[n].Name) = 'mniPTO1X' then
    begin
      Dest.Items[n].Caption := 'Post '+ Inv.OurRef+' only';
    end
    else
    if (Dest.Items[n].Name) = 'mniPTWPR1X' then
    begin
      Dest.Items[n].Caption := 'Post '+ Inv.OurRef+' with Posting Report';
    end;

  end;
end;






{ ======= Proc to Create a submenu from a popupMenu ====== }

procedure SetCheckedMenuItems(Const Source  :  TMenuItem;
                                    RefCount:  Integer;
                                    BTagNo  :  Integer);


Var
  n,Loop        :  Integer;

Begin
  //if a reference count has been supplied, store it in the loop var
  //otherwise determine the loop var val by getting a count of the popup menu items
  If (RefCount<>-1) then
    Loop:=RefCount
  else
    //GS: 09/05/11 ABSEXCH-10801: modified the 'Find menu count' code to use the Delphi API
    //instead of using Windows API calls (GetMenuItemCount)
    Loop:=(Source.Count)-1;

  //loop through each item in the popup menu..
  For n:=0 to Loop do
  With Source do
  Begin
    //modify the curent items checked status by the value in the items Tag field
    Source.Items[n].Checked:=(Source.Items[n].Tag=BTagNo);
  end;
end;

{ ======= Proc to Create a submenu from a popupMenu ====== }

procedure SetCheckedPopUpMenu(Const Source  :  TPopUpMenu;
                                    RefCount:  Integer;
                                    BTagNo  :  Integer);


Var
  n,Loop        :  Integer;

Begin
  //if a reference count has been supplied, store it in the loop var
  //otherwise determine the loop var val by getting a count of the popup menu items
  If (RefCount<>-1) then
    Loop:=RefCount
  else
    //GS: 09/05/11 ABSEXCH-10801: modified the 'Find menu count' code to use the Delphi API
    //instead of using Windows API calls (GetMenuItemCount)
    Loop:=(Source.Items.Count)-1;

  //loop through each item in the popup menu..
  For n:=0 to Loop  do
  With Source do
  Begin
    //modify the curent items checked status by the value in the items Tag field
    Source.Items[n].Checked:=(Source.Items[n].Tag=BTagNo);
  end;
end;




{ ======= Proc to Create a submenu from a popupMenu ====== }

Function CanShowPMenu(Const Source  :  TMenuItem)  :  Boolean;


Var
  n        :  Integer;

Begin
  With Source do
  Begin
    Result:=Visible;

    If (Result) then
      For n:=0 to Pred(Count) do
      Begin
        Result:=Items[n].Visible;

        If (Result) then
          Exit;
      end;
  end; {with..}
end;



Function CheckFormNeedStoreChk(F  :  TForm;
                               ResetOn
                                   : Boolean)  :  Boolean;

Var
  Loop    :  Integer;
  FoundOk :  Boolean;

Begin
  Result:=BOff;
  FoundOk:=BOff;
  Loop:=0;

  With F do
  While (Loop<=Pred(ComponentCount)) do
  Begin
    If (Components[Loop] is Text8pt) then
    With (Components[Loop] as Text8pt) do
    Begin
      Result:=((Tag=1) and (Modified or AltMod));

      If (Result) and (ResetOn) then
      Begin
        Modified:=BOff; AltMod:=BOff;
      end;
    end
    else
      If (Components[Loop] is TMaskEdit) then
      With (Components[Loop] as TMaskEdit) do
      Begin
        Result:=((Tag=1) and (Modified));

        If (Result) and (ResetOn) then
        Begin
          Modified:=BOff; 
        end;
      end
      else
        If (Components[Loop] is TCurrencyEdit) then
        With (Components[Loop] as TCurrencyEdit) do
        Begin
          Result:=(Tag=1) and (FloatModified);

          If (Result) and (ResetOn) then
            FloatModified:=BOff;
        end
        else
          If (Components[Loop] is TBorCheck) then
          With (Components[Loop] as TBorCheck) do
          Begin
            Result:=((Tag=1) and (Modified));

            If (Result) and (ResetOn) then
              Modified:=BOff;
          end
          else
            If (Components[Loop] is TSBSComboBox) then
            With (Components[Loop] as TSBSComboBox) do
            Begin
              Result:=((Tag=1) and (Modified));

              If (Result) and (ResetOn) then
                Modified:=BOff;
            end;

    Inc(Loop);

    If (Result) and (Not FoundOk) then
      FoundOk:=BOn;
  end; {While..}

  Result:=FoundOk;
end;



Function CheckFormNeedStore(F  :  TForm)  :  Boolean;


Begin
  Result:=CheckFormNeedStoreChk(F,BOn);

end;




{$H+}

end.

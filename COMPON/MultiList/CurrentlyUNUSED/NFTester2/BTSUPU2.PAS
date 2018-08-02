unit BtSupu2;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }



interface

Uses
  GlobVar,
  VarConst,
  WinTypes,
  Messages,
  Classes,
  Controls,
  StdCtrls,
  ComCtrls,
  Forms,
  BtrvU2;


Type
  tObjectSERec  =  Record
                     OSCode  :  Str20;
                     OLCode,
                     OCCode  :  Str10;
                     OCurr,
                     OTCurr  :  SmallInt;
                   end;


{Var
  STDStkTList,
  STDValList,
  STDVATList,
  STDDocTList,
  STDQtyBList,
  STDNomTList,
  STDCurrList :  TStringList;}


Function TxLatePound(Const TS     :  Str255;
                     Const From   :  Boolean)  :  Str255;

procedure GlobFormKeyPress(Sender: TObject;
                       var Key   : Char;
                           ActiveControl
                                 :  TWinControl;
                           Handle:  THandle);

function GetNewTabIdx(PC  :  TPageControl;
                      KC  :  Word)  :  Integer;

procedure GlobFormKeyDown(Sender : TObject;
                      var Key    : Word;
                          Shift  : TShiftState;
                          ActiveControl
                                 :  TWinControl;
                          Handle :  THandle);

Procedure MDI_SetFormCoord(Var F  :  TForm);

Procedure MDI_UpdateParentStat;

Procedure MDI_ForceParentBkGnd(WholeScreen  :  Boolean);

Procedure MDI_UpdateParentBkGnd(WholeScreen  :  Boolean);

Function GetMaxColors(Handle  :  HDC)  :  Integer;

Procedure GenCanClose(PForm    :  TForm;
                      Sender   :  TObject;
                  Var CanClose :  Boolean;
                      UseShow  :  Boolean);

Procedure GenForceClose(PForm    :  TForm;
                        Sender   :  TObject;
                    Var CanClose :  Boolean);

Procedure Get_NonClientInfo;

procedure SetNextLine(FP,TC,LC,PC
                                 :  TObject;
                      Var Key    :  Char);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  Dialogs,
  Registry,
  SysUtils,
  Grids,
  SBSOutL,
  //VarRec2U,
  TEditVal,
  BorBtns,
  BTSupU1,
  //ComnU2,
  SBSComp2;



Function TxLatePound(Const TS     :  Str255;
                     Const From   :  Boolean)  :  Str255;

Var
  P  :  Integer;

Begin
  Result:=TS;

  If (From) then
    P:=Pos(#156,Result)
  else
    P:=Pos('£',Result);

  While (p<>0) do
  Begin
    If (From) then
    Begin
      Result[p]:='£';

      P:=Pos(#156,Result);
    end
    else
    Begin
      Result[p]:=#156;

      P:=Pos('£',Result);
    end;
  end;
end;

{ Global Key handling routines }
procedure GlobFormKeyPress(Sender: TObject;
                       var Key   : Char;
                           ActiveControl
                                 :  TWinControl;
                           Handle:  THandle);

Var
  IrqKey  :  Boolean;

begin
  IrqKey:=True; {((Syss.TxlateCR) );}

  If (ActiveControl is TSBSComboBox) then
    With (ActiveControl as TSBSComboBox) do
    Begin

      IrqKey:=(IrqKey and (Not InDropDown));

    end
    else
      If (ActiveControl is TStringGrid) or
         (ActiveControl is TUpDown) or
         (ActiveControl is TSBSOutLineB) then {* switched off so it does not interfere with a list *}
        IrqKey:=BOff;

  If ((Key=#13)  or (Key=#10)) and (IrqKey) then
  Begin

    Key:=#0;

  end;
end;

function GetNewTabIdx(PC  :  TPageControl;
                      KC  :  Word)  :  Integer;

{* Could not use, as VK_Home&End seem to be intercepted by list boxes *}
Begin

  Case KC of
    VK_Prior,
    VK_Next   :  With PC do
                   Result:=FindNextPage(ActivePage,(KC=VK_Next),BOn).PageIndex;

    VK_Home   :  Result:=0;
    VK_End    :  Result:=Pred(Pc.PageCount);
    else         Result:=PC.ActivePage.PageIndex;

  end;
end;


procedure ClickOk(Sender  :  TObject;
              Var VKey    :  Word);

Var
{  FForm  :  TForm;}
  n      :  Integer;

Begin
  If (Sender is TForm) then
    With TForm(Sender) do
    Begin
      For n:=0 to Pred(ComponentCount) do
        If (Components[n] is TButton) then
          With TButton(Components[n]) do
            If ((Caption='&OK') or (ModalResult=mrOk)) and (Enabled) and (Visible) and (CanFocus) then
            Begin
              VKey:=0;
              Click;
              Exit
            end;


    end;

end;


procedure GlobFormKeyDown(Sender : TObject;
                      var Key    : Word;
                          Shift  : TShiftState;
                          ActiveControl
                                 :  TWinControl;
                          Handle :  THandle);

Var
  IrqKey  :  Boolean;
  TComp   :  TComponent;

begin

  IrqKey:=((Not (ssCtrl In Shift)) and (Not (ssAlt In Shift)) and (Not (ssShift In Shift)));

  If (ActiveControl is TSBSComboBox) then
    With (ActiveControl as TSBSComboBox) do
  Begin

    IrqKey:=(IrqKey and (Not InDropDown));

  end
  else
    If (ActiveControl is TStringGrid) or
       (ActiveControl is TUpDown) or
       (ActiveControl is TSBSOutLineB) then {* Could combine with a switch, as there maybe cases where a
                                                                                 a string grid is used without the list... *}
      IrqKey:=BOff;


  If (IrqKey) then
  Case Key of


    VK_Up  :  Begin
                PostMessage(Handle,wm_NextDlgCtl,1,0);
                Key:=0;
              end;
    VK_Return,
    VK_Down
           :  Begin
                {If (Key=VK_Return) and (Not Syss.TxLateCr) then
                  Exit;}


                If ((Not (ActiveControl is TBorCheck)) and (Not(ActiveControl is TBorRadio))) or (Key=VK_Return) then
                Begin
                  PostMessage(Handle,wm_NextDlgCtl,0,0);
                  Key:=0;
                end
                else
                  Key:=Vk_Tab;

              end;

  end;

  If (Key In [VK_F2..VK_F12]) and (Not (ssAlt In Shift)) and (AllowHotKey) then
  Begin
    If (Key=VK_F9) then
    Begin
      If (ActiveControl is TComponent) then
      Begin
        TComp:=TComponent(ActiveControl);
        LastValueObj.GetValue(TComp);
        PostMessage(Handle,wm_NextDlgCtl,0,0);
      end;
    end
    else
      PostMessage(Application.MainForm.Handle,wm_KeyDown,Key,Ord((ssShift In Shift)));
  end;

  If (Key In [VK_Prior,VK_Next]) and (ssCtrl In Shift) and (AllowHotKey) then {* Select Next/Prev page of tabbed notebook *}
    PostMessage(Handle,wm_CustGetRec,175,Ord(Key=VK_Prior));

  If (Key In [VK_Home,VK_End]) and (ssAlt In Shift) and (AllowHotKey) then {* Jump straight to list body *}
    PostMessage(Handle,wm_CustGetRec,176,Ord(Key=VK_Home));

  If ((Key=VK_Return) and (ssCtrl In Shift)) then
    ClickOK(Sender,Key);

end;


{ ========= Procedure Set Coordinates of next MDI Child ======= }
Procedure MDI_SetFormCoord(Var F  :  TForm);

Var
  MDIForm  :  TForm;

Begin
  MDIForm:=Application.MainForm.ActiveMDIChild;

  If (MDIForm<>nil)  then
  With MDIForm do
  Begin
    If (Not CheckKey('ObjectThread',Caption,12,BOff))
      and (Not CheckKey('ObjectPrice',Caption,11,BOff))
      and (Not CheckKey('ObjectCredit',Caption,12,BOff))
      and (Not CheckKey('ObjectStock',Caption,11,BOff))
      and (WindowState=wsNormal) then
    Begin
      F.Left:=Left+20;
      F.Top:=Top+20;
    end
    else
    Begin
      F.Left:=1;
      F.Top:=1;
    end;
  end
  else
  Begin
    F.Left:=1;
    F.Top:=1;
  end;
end;


{ ========= Procedure to Tell Parent to update Staus display ======= }

Procedure MDI_UpdateParentStat;

Begin
  If (Assigned(Application.MainForm)) then
    PostMessage(Application.MainForm.Handle,WM_FormCloseMsg,0,0);

end;

{ ========= Procedure to Tell Parent to update background ======= }

Procedure MDI_UpdateParentBkGnd(WholeScreen  :  Boolean);
{Var
  MForm  :  TForm;}

Begin
  {$IFDEF XEX32}
  {* Not used anymore, as realize pallete works better in EParent U *}

  If (GetMaxColors(Application.MainForm.Canvas.Handle) <2) then
  Begin
    MForm:=TForm.Create(Application.MainForm);
    try
      With MForm do
      Begin
        If (WholeScreen) then
        Begin
          {FormStyle:=fsMDIChild;}
          Top:=1;
          Left:=1;
          Height:=Application.MainForm.ClientHeight+75;
          Width:=Application.MainForm.ClientWidth;
        end
        else
        Begin
          Top:=Application.MainForm.ClientHeight-10;
          Height:=1;
          Width:=1;
        end;

        BorderStyle:=bsNone;
        BorderIcons:=[];
        Show;
      end;
    finally
      Mform.Free;
    end;
  end;

  {$ENDIF}

end;

Procedure MDI_ForceParentBkGnd(WholeScreen  :  Boolean);
Var
  MForm  :  TForm;

Begin

  {$B-}

  If (Assigned(Application.MainForm)) and (GetMaxColors(Application.MainForm.Canvas.Handle) <2) then

  {$B+}

  Begin
    MForm:=TForm.Create(Application.MainForm);
    try
      With MForm do
      Begin
        If (WholeScreen) then
        Begin
          {FormStyle:=fsMDIChild;}
          Top:=1;
          Left:=1;
          Height:=Application.MainForm.ClientHeight+75;
          Width:=Application.MainForm.ClientWidth;
        end
        else
        Begin
          Top:=Application.MainForm.ClientHeight-10;
          Height:=1;
          Width:=1;
        end;

        BorderStyle:=bsNone;
        BorderIcons:=[];
        Show;
      end;
    finally
      Mform.Free;
    end;
  end;

end;

Function GetMaxColors(Handle  :  HDC)  :  Integer;

Var
  TInt  :  Integer;

Begin

  TInt:=GetDeviceCaps(Handle,BITSPIXEL);

  Case TInt of

    4  :  Result:=0;
    8  :  Result:=1;
    16..256
       :  Result:=2;
    else  Result:=0;

  end;

end;


Procedure GenCanClose(PForm    :  TForm;
                      Sender   :  TObject;
                  Var CanClose :  Boolean;
                      UseShow  :  Boolean);

Var
  n  :  Integer;


Begin

  If (CanClose) then
  With PForm do
    For n:=0 to Pred(ComponentCount) do
      If (Components[n] is TForm) then
        With TForm(Components[n]) do
        Begin
          If (Assigned(OnCloseQuery)) then
            OnCloseQuery(Sender,CanClose);

          If (Not CanClose) then
          Begin
            If (UseShow) then
              Show;
            Break;
          end;
        end;

end;


Procedure GenForceClose(PForm    :  TForm;
                        Sender   :  TObject;
                    Var CanClose :  Boolean);

Var
  n  :  Integer;


Begin

  If (CanClose) then
  With PForm do
    For n:=0 to Pred(ComponentCount) do
      If (Components[n] is TForm) then
        With TForm(Components[n]) do
        Begin
          If (Assigned(OnCloseQuery)) then
            OnCloseQuery(Sender,CanClose);

          If (CanClose) then
          Begin
            Close;
          end;
        end;

end;


Function NextTCtrl(PC  :  TObject;
                   TN  :  Integer)  :  TWinControl;

Var
  n  :  Integer;

Begin
  Result:=nil;

  If (PC is TWinControl) then
  With TWinControl(PC) do
  Begin
    For n:=0 to Pred(ControlCount) do
    Begin
      If (Controls[n] is TWinControl) then
      Begin
        If (TWinControl(Controls[n]).TabOrder=TN) then
        Begin
          Result:=TWinControl(Controls[n]);
          break;
        end;
      end;
    end;
  end;
end;


procedure SetNextLine(FP,TC,LC,PC
                                 :  TObject;
                      Var Key    :  Char);

Var
  wp,
  wc  :  Integer;
  lw  :  Str255;

  TmpT:  String;


  NC  :  TWinControl;
  TxC :  Text8pt;

Begin
  If (Key In [#32..#126]) then
  Begin
    If (TC<>LC) and (TC is Text8Pt) and (Key<>#32) then
    With Text8Pt(TC) do
    Begin
      wc:=WordCnt(Text);
      lw:=ExtractWords(wc,1,Text);

      wp:=PosWord(wc,Text);

      TmpT:=Text;

      Delete(TmpT,wp,Succ(Length(Text)-wp));

      Text:=TmpT;

      NC:=NextTCtrl(PC,Succ(TabOrder));

      If (Assigned(NC)) and (NC is Text8Pt) then
      Begin
        TxC:=Text8pt(NC);

        TxC.Text:=lw+Key;

        If (TxC.CanFocus) then
          TxC.SetFocus;

        TxC.SelStart:=Succ(Length(TxC.Text));
        TxC.SelLength:=1;

        Key:=#0;
      end
      else
        PostMessage(TWinControl(FP).Handle,wm_NextDlgCtl,0,0);
    end
    else
      PostMessage(TWinControl(FP).Handle,wm_NextDlgCtl,0,0);

  end;
end;


{ ==== Function to determine if Winnt(3) <4 is running ==== }

Function IS_WinNT  :  Boolean;


Var
  OSVerIRec
        :  TOSVersionInfo;


Begin
  Result:=BOff;

  FillChar(OSVerIRec,Sizeof(OSVerIRec),0);

  OSVerIRec.dwOSVersionInfoSize:=Sizeof(OSVerIRec);

  If (GetVersionEx(OSVerIRec)) then
  Begin
    Result:=(OSVerIRec.dwPlatformId=VER_PLATFORM_WIN32_NT) And
            (OSVerIRec.dwMajorVersion<4);

    {* Could check whick version ie NT 4.0 maynot have these problems *}
  end;
end;


{ ==== Function to determine if Winnt is running ==== }

Function IS_WinNT4  :  Boolean;


Var
  OSVerIRec
        :  TOSVersionInfo;


Begin
  Result:=BOff;

  FillChar(OSVerIRec,Sizeof(OSVerIRec),0);

  OSVerIRec.dwOSVersionInfoSize:=Sizeof(OSVerIRec);

  If (GetVersionEx(OSVerIRec)) then
  Begin
    Result:=(OSVerIRec.dwPlatformId=VER_PLATFORM_WIN32_NT) And
            (OSVerIRec.dwMajorVersion=4);

  end;
end;

{ ==== Function to determine if Winnt is running ====

Function IS_WinNT  :  Boolean;


Var
  CReg  :  TRegistry;


Begin
  Result:=BOff;

  CReg:=TRegistry.Create;

  try
    With CReg do
    Begin
      RootKey:=HKEY_LOCAL_MACHINE;

      Result:=KeyExists('SOFTWARE\Microsoft\Windows NT');

    end;

  finally
    CReg.Free;

  end;

end;}

Procedure Get_NonClientInfo;

Var
  NCMetrics  :  PNonClientMetrics;
  SBW,SBH    :  Integer;


Begin
  New(NCMetrics);

  FillChar(NCMetrics^,Sizeof(NCMetrics^),0);

  NCMetrics^.cbSize:=Sizeof(NCMetrics^);

  If (SystemParametersInfo(SPI_GETNONCLIENTMETRICS,0,NCMETRICS,0)) then
  Begin
    Move(NCMetrics^.iScrollWidth,SBW,Sizeof(SBW));
    Move(NCMetrics^.iScrollHeight,SBH,Sizeof(SBH));

    SBW:=16;
    SBH:=16;

    Move(SBW,NCMetrics^.iScrollWidth,Sizeof(SBW));
    Move(SBH,NCMetrics^.iScrollHeight,Sizeof(SBH));

    If (SystemParametersInfo(SPI_SETNONCLIENTMETRICS,0,NCMETRICS,{SPIF_SENDWININICHANGE}0)) then
      MessageBeep(0);
  end;

  Dispose(NCMetrics);

end;


Initialization
  ISWINNT:=IS_WinNT;
  ISWINNT4:=IS_WinNT4;
end.

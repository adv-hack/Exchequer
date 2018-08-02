unit SecUtilU;

interface
Uses
  WinTypes,
  Messages,
  Classes,
  Controls,
  StdCtrls,
  ComCtrls,
  DiskUtil,
  Forms;

procedure GlobFormKeyDown(Sender : TObject;
                      var Key    : Word;
                          Shift  : TShiftState;
                          ActiveControl
                                 :  TWinControl;
                          Handle :  THandle);

procedure GlobFormKeyPress(Sender: TObject;
                       var Key   : Char;
                           ActiveControl
                                 :  TWinControl;
                           Handle:  THandle);

Function RunValidLocation  :  Boolean;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  GlobVar,
  ETStrU,
  ETMiscU,
  ETDateU,
  Dialogs,
  Registry,
  SysUtils,
  Grids,
  BorBtns,
  SBSOutL,
  SButton,
  APIUtil,
  TEditVal;

{ ================ Global Key handling routines =============== }

procedure GlobFormKeyPress(Sender: TObject;
                       var Key   : Char;
                           ActiveControl
                                 :  TWinControl;
                           Handle:  THandle);

Var
  IrqKey  :  Boolean;

begin
  IrqKey:=True;

  If (ActiveControl is TSBSComboBox) then
    With (ActiveControl as TSBSComboBox) do
    Begin

      IrqKey:=(IrqKey and (Not InDropDown));

    end
    else
      If (ActiveControl is TStringGrid) or
         (ActiveControl is TUpDown) or
         { HM 09/11/99: Was interfering with Memo control on print dialog }
         ((ActiveControl is TMemo) and (Not (ActiveControl is TCurrencyEdit))) or
         (ActiveControl is TSBSOutLineB) then {* switched off so it does not interfere with a list *}
        IrqKey:=BOff;

  If ((Key=#13)  or (Key=#10)) and (IrqKey) then
  Begin

    Key:=#0;

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
       (ActiveControl is TScrollButton) or

         { HM 09/11/99: Was interfering with Memo control on print dialog }
       ((ActiveControl is TMemo) and (Not (ActiveControl is TCurrencyEdit))) or
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
                If (Key=VK_Return) and (Not True) then
                  Exit;


                If ((Not (ActiveControl is TBorCheck)) and (Not(ActiveControl is TBorRadio))) or (Key=VK_Return) then
                Begin
                  PostMessage(Handle,wm_NextDlgCtl,0,0);
                  Key:=0;
                end
                else
                  Key:=Vk_Tab;

              end;

  end;


  If (ActiveControl is TScrollButton) then {Don't go any further}
    Exit;


end;


{ == Function to resctrict loading from anywhere other than a known drive == }
Function RunValidLocation  :  Boolean;
Var
  DriveInfo           : DriveInfoType;
  UName, CName        : ShortString;
  DebugOn, OK         : Boolean;
  StrLength           : DWord;
  pSysInfo            : PChar;
  sNetworkPath        : ShortString;
Begin
//  GetDir(0,CurrDir);
//  Result:=(UpperCase(CurrDir)='H:\ADMIN\SBSIS') or (ParamStr(1) = 'FRTXZ');

  DebugOn := FindCmdLineSwitch('DogsB', ['-', '/'], True);

  // Get info about drive the app is running from
  DriveInfo.drDrive := Application.ExeName[1];
  Result := GetDriveInfo(DriveInfo);
  If Result Then
  Begin
    // Check its a network drive
    Result := (Uppercase(DriveTypeStr(DriveInfo.drDriveType)) = 'NETWORK');
    If Result Then
    Begin
      // MH 29/10/07: Moved off main server onto Ronnie (win2000)
      sNetworkPath := ExpandUNCFilename(Application.ExeName[1]);
      // MH 15/03/2011: Moved servers
      //Result := Pos('\\RONNIE\APPS\', UpperCase(sNetworkPath)) = 1;
      Result := Pos('\\BMTDEVVMH2\LICENSING\', UpperCase(sNetworkPath)) = 1;

      // Check it is a netware volume - can be reported as NWCOMPA or NWFS
      //Result := (Pos ('NWCOMPA', Uppercase(DriveInfo.drFileSystem)) > 0) Or
      //          (Pos ('NWFS', Uppercase(DriveInfo.drFileSystem)) > 0);

      If Result Then
      Begin
        // Check Windows User ID is authorised
        StrLength := 100;
        pSysInfo := StrAlloc (StrLength);
        GetUserName (pSysInfo, StrLength);
        UName := UpperCase(pSysInfo);
        StrDispose (pSysInfo);
        Result := (UName = 'MARKD6') Or
                  (UName = 'DAVID.RUSTELL') Or
                  (UName = 'JWAYGOOD') Or
                  (UName = 'NICK.MCKEOWN') Or
                  (UName = 'ANDREW.PEARSON') Or
                  (UName = 'KOMAL.PARIKH') Or
                  (UName = 'PRIYANKA.PATEL') Or
                  (UName = 'SAROJ.SAHU') Or
                  (UName = 'INETA.JANKEVICIUTE') Or
                  (UName = 'CLARA.WHALLEY') Or
                  (UName = 'SHRUTHI.MURALIDHARA') Or
                  // MH 19/03/2018 ABSEXCH-19887
                  (UName = 'PRADEEP.NARAYANASWAM') Or
                  (UName = 'DINESHKUMAR.SELVARAJ') Or
                  (UName = 'LAKSHMI.NARASIMHAN') Or
                  // MH 10/04/2018 ABSEXCH-20364
                  (UName = 'MEET.PATHAK') Or
                  (UName = 'ASHLEY.GRAY') Or
                  (UName = 'AMARPREET.SAHOTA') Or
                  // MH 11/05/2018:
                  (UName = 'FIONNUALA.MUNRO');

        If (Not Result) And DebugOn Then
        Begin
          ShowMessage ('UserID = ' + UName);
        End; // If (Not Result) And DebugOn
      End // If Result
      Else
      Begin
        If DebugOn Then
        Begin
          //ShowMessage ('FS = ' + DriveInfo.drFileSystem);
          ShowMessage ('NetPath = ' + sNetworkPath);
        End; // If DebugOn
      End; // If Result
    End // If Result
    Else
    Begin
      If DebugOn Then
      Begin
        ShowMessage ('DT = ' + DriveTypeStr(DriveInfo.drDriveType));
      End; // If DebugOn
    End; // Else
  End // If Result
  Else
  Begin
    If DebugOn Then
    Begin
      ShowMessage ('DriveInfo Failed');
    End; // If DebugOn
  End;
end;



end.

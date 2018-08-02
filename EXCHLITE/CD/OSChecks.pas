unit OSChecks;

interface

Uses Dialogs, StrUtils, SysUtils, APIUtil;

Type
  // Performs OS Checks to determine whether LITE can be used on this workstation
  //
  //   Supported OS's:-
  //
  //     Windows 2000 Service Pack 4
  //     Windows XP Service Pack 2
  //     Windows Server 2003 Service Pack 1
  //
  // Running under Terminal Services is not supported
  //
  TOSChecks = Class(TObject)
  Private
    FSupportedOS : Boolean;
    FNeedsServicePack : Boolean;
    FTSSession : Boolean;

    FWindowsVersion : TWindowsVersion;
    FServicePack : Integer;
  Public
    // True if the OS/Service Pack combo is supported
    Property ocSupportedOS : Boolean Read FSupportedOS;
    Property ocNeedsServicePack : Boolean Read FNeedsServicePack;
    Property ocTSSession : Boolean Read FTSSession;

    // The Service Pack number
    Property ocServicePack : Integer Read FServicePack;
    // The Windows Version
    Property ocWindowsVersion : TWindowsVersion Read FWindowsVersion;

    Constructor Create;
  End; // TOSChecks

implementation

Uses TermServ;

Var
  AllowTerminalServices : Boolean;

//=========================================================================

Constructor TOSChecks.Create;
Begin // Create
  Inherited Create;

  FSupportedOS := False;
  FNeedsServicePack := False;
  FTSSession := False;

  // Get the current version of Windows on this workstation
  FWindowsVersion := GetWindowsVersion(FServicePack);

//Case FWindowsVersion Of
//  wv95 : ShowMessage ('wv95 SP' + IntToStr(FServicePack));
//  wv98 : ShowMessage ('wv98 SP' + IntToStr(FServicePack));
//  wvME : ShowMessage ('wvME SP' + IntToStr(FServicePack));
//  wvNT3 : ShowMessage ('wvNT3 SP' + IntToStr(FServicePack));
//  wvNT4 : ShowMessage ('wvNT4 SP' + IntToStr(FServicePack));
//  wvNT4TerminalServer : ShowMessage ('wvNT4TerminalServer SP' + IntToStr(FServicePack));
//  wv2000 : ShowMessage ('wv2000 SP' + IntToStr(FServicePack));
//  wv2000TerminalServer : ShowMessage ('wv2000TerminalServer SP' + IntToStr(FServicePack));
//  wvXP : ShowMessage ('wvXP SP' + IntToStr(FServicePack));
//  wvXPTerminalServer : ShowMessage ('wvXPTerminalServer SP' + IntToStr(FServicePack));
//  wvNTOther : ShowMessage ('wvNTOther SP' + IntToStr(FServicePack));
//  wvUnknown : ShowMessage ('wvUnknown SP' + IntToStr(FServicePack));
//  wv2003Server : ShowMessage ('wv2003Server SP' + IntToStr(FServicePack));
//  wv2003TerminalServer : ShowMessage ('wv2003TerminalServer SP' + IntToStr(FServicePack));
//  wvVista : ShowMessage ('wvVista');
//End; // Case FWindowsVersion
//ShowMessage (IfThen(AllowTerminalServices, 'Terminal Services Support Enabled', 'Terminal Services Support Disabled'));
//ShowMessage (IfThen(TerminalServices.IsTerminalServerSession, 'Running In Session', 'Straight OS'));

  If (Not AllowTerminalServices) And TerminalServices.IsTerminalServerSession Then
  Begin
    // Running in Terminal Server Session and Terminal Server Session Support is disabled
    FTSSession := True;
    //ShowMessage ('OS Not Supported - Terminal Services Support Disabled')
  End // If (Not AllowTerminalServices) And TerminalServices.IsTerminalServerSession
  Else
  Begin
    Case FWindowsVersion Of                               
      wv2000, wv2000TerminalServer       : Begin
                                             FNeedsServicePack := (FServicePack < 4);
                                             FSupportedOS := (Not FNeedsServicePack);
                                           End; // wv2000, wv2000TerminalServer
      wvXP, wvXPTerminalServer           : Begin
                                             FNeedsServicePack := (FServicePack < 2);
                                             FSupportedOS := (Not FNeedsServicePack);
                                           End; // wvXP, wvXPTerminalServer
      wv2003Server, wv2003TerminalServer : Begin
                                             FNeedsServicePack := (FServicePack < 1);
                                             FSupportedOS := (Not FNeedsServicePack);
                                           End; // wv2000, wv2000TerminalServer
//      // MH 13/06/2013 v7.0.4 ABSEXCH-14364: Added support for Windows 7 onwards
//      wvVista..wvWindowsServer2012       : Begin
//                                             FNeedsServicePack := False;
//                                             FSupportedOS := (Not FNeedsServicePack);
//                                           End; // wv2000, wv2000TerminalServer
    Else
      // MH 11/11/2016 2017 R1 ABSEXCH-17812: Recoded so it works on Windows 8.1/10/etc...
      If (FWindowsVersion >= wvVista) Then
      Begin
        FNeedsServicePack := False;
        FSupportedOS := (Not FNeedsServicePack);
      End; // If (FWindowsVersion >= wvVista)
    End; // Case FWindowsVersion

//    If (Not FSupportedOS) Then
//      ShowMessage ('OS Not Supported')
//    Else
//      ShowMessage ('OS Supported - Have a nice day!')
  End; // Else
End; // Create

Initialization
  // Check for /TS+ which disables the prevention of LITE usage under Terminal Services
  AllowTerminalServices := FindCmdLineSwitch('TS+', SwitchChars, True);
End.

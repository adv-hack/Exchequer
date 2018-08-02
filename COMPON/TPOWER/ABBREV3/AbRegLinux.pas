{*********************************************************}
{* ABBREVIA: AbRegLinux.pas 3.02                         *}
{* Copyright (c) TurboPower Software Co 1997, 2002       *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA: Registrations                               *}
{*********************************************************}

{$I AbDefine.inc}
unit AbRegLinux;

{$R AbReg.res}

interface

{$IFDEF MSWINDOWS}
  !! Error, this unit is for CLX on Linux, use AbRegClx.pas for Windows
{$ENDIF}

uses
  Classes,
  AbQZpOut, AbQView, AbQZView, AbQMeter;

procedure Register;

implementation

uses
  AbUtils,
  AbQPeDir,
  AbQPeFn,
  AbQPePas,
  AbQPeVer,
  AbQPeCol,
  AbZBrows,
  AbZipper,
  AbUnzper,
  AbZipKit,
  AbSelfEx,
  DesignIntf,
  DesignEditors;

procedure Register;
begin
  RegisterPropertyEditor( TypeInfo( string ), TAbZipBrowser, 'FileName',
                          TAbFileNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipper, 'FileName',
                          TAbFileNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbUnZipper, 'FileName',
                          TAbFileNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipKit, 'FileName',
                          TAbFileNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipOutline, 'FileName',
                          TAbFileNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipBrowser, 'LogFile',
                          TAbLogNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipper, 'LogFile',
                          TAbLogNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbUnZipper, 'LogFile',
                          TAbLogNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipKit, 'LogFile',
                          TAbLogNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipOutline, 'LogFile',
                          TAbLogNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbMakeSelfExe, 'SelfExe',
                          TAbExeNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbMakeSelfExe, 'StubExe',
                          TAbExeNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbMakeSelfExe, 'ZipFile',
                          TAbFileNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipBrowser, 'BaseDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipper, 'BaseDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbUnZipper, 'BaseDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipKit, 'BaseDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipOutline, 'BaseDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipBrowser, 'TempDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipper, 'TempDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbUnZipper, 'TempDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipKit, 'TempDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipOutline, 'TempDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipBrowser, 'Version',
                          TAbVersionProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipper, 'Version',
                          TAbVersionProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbUnZipper, 'Version',
                          TAbVersionProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipKit, 'Version',
                          TAbVersionProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipOutline, 'Version',
                          TAbVersionProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipView, 'Version',
                          TAbVersionProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbMeter, 'Version',
                          TAbVersionProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbMakeSelfExe, 'Version',
                          TAbVersionProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipBrowser, 'Password',
                          TAbPasswordProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipper, 'Password',
                          TAbPasswordProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbUnZipper, 'Password',
                          TAbPasswordProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipKit, 'Password',
                          TAbPasswordProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipOutline, 'Password',
                          TAbPasswordProperty );
  RegisterPropertyEditor( TypeInfo( TAbColHeadings ), TAbZipView, 'Headings',
                          TAbColHeadingsProperty );
  RegisterComponents( 'Abbrevia',
                      [TAbCLXMeterLink,
                        TAbZipBrowser,
                        TAbUnzipper,
                        TAbZipper,
                        TAbZipKit,
                        TAbZipOutline,
                        TAbZipView,
                        TAbMeter,
                        TAbMakeSelfExe]);
end;

end.

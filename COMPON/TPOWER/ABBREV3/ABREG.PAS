{*********************************************************}
{* ABBREVIA: AbReg.pas 3.02                              *}
{* Copyright (c) TurboPower Software Co 1997, 2002       *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA: Registrations (VCL)                         *}
{*********************************************************}

{$I AbDefine.inc}
{$UNDEF UsingClx }

unit AbReg;

{$R AbReg.res}

interface

uses
  Classes,
  AbCBrows, AbCabExt, AbCabMak, AbCabKit,
  AbZBrows, AbUnzper, AbZipper, AbZipKit,
  AbSelfEx, AbZipExt, AbZlTyp;

procedure Register;

implementation

uses
  AbUtils,
  AbPeDir,
  AbPeFn,
  AbPePass,
  AbPeVer,
  AbPeCol,
{$IFDEF VERSION6}
  DesignIntf,
  DesignEditors,
{$ELSE}
  DsgnIntf,
{$ENDIF}
  SysUtils;

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
  RegisterPropertyEditor( TypeInfo( string ), TAbZipBrowser, 'LogFile',
                          TAbLogNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipper, 'LogFile',
                          TAbLogNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbUnZipper, 'LogFile',
                          TAbLogNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipKit, 'LogFile',
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
  RegisterPropertyEditor( TypeInfo( string ), TAbZipBrowser, 'TempDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipper, 'TempDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbUnZipper, 'TempDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipKit, 'TempDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipBrowser, 'Version',
                          TAbVersionProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipper, 'Version',
                          TAbVersionProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbUnZipper, 'Version',
                          TAbVersionProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbZipKit, 'Version',
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
  RegisterPropertyEditor( TypeInfo( string ), TAbCabBrowser, 'FileName',
                          TAbCabNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbMakeCab, 'FileName',
                          TAbCabNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbCabExtractor, 'FileName',
                          TAbCabNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbCabKit, 'FileName',
                          TAbCabNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbCabBrowser, 'BaseDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbMakeCab, 'BaseDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbCabExtractor, 'BaseDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbCabKit, 'BaseDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbCabBrowser, 'LogFile',
                          TAbLogNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbMakeCab, 'LogFile',
                          TAbLogNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbCabExtractor, 'LogFile',
                          TAbLogNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbCabKit, 'LogFile',
                          TAbLogNameProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbCabBrowser, 'TempDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbMakeCab, 'TempDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbCabExtractor, 'TempDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbCabKit, 'TempDirectory',
                          TAbDirectoryProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbCabBrowser, 'Version',
                          TAbVersionProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbMakeCab, 'Version',
                          TAbVersionProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbCabExtractor, 'Version',
                          TAbVersionProperty );
  RegisterPropertyEditor( TypeInfo( string ), TAbCabKit, 'Version',
                          TAbVersionProperty );

  RegisterComponents( 'Abbrevia',
                      [ TAbZipBrowser,
                        TAbUnzipper,
                        TAbZipper,
                        TAbZipKit,
                        TAbCabBrowser,
                        TAbCabExtractor,
                        TAbMakeCab,
                        TAbCabKit,
                        TAbMakeSelfExe ]);
end;

end.

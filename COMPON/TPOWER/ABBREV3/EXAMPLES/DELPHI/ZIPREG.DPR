{*********************************************************}
{* ABBREVIA: ZIPREG.DPR                                  *}
{* Copyright (c) TurboPower Software Co 1997             *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA Example program file                         *}
{*********************************************************}

program ZipReg;

uses
  Forms,
  ZipReg1 in 'ZipReg1.pas' {ExZipAssociation};

begin
  Application.CreateForm(TExZipAssociation, ExZipAssociation);
  Application.Run;
end.

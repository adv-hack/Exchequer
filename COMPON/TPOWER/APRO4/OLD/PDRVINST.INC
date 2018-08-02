{*********************************************************}
{*                   PDRVINST.INC 4.01                   *}
{*      Copyright (c) TurboPower Software 1996-2001      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{ This file is included by PDRVINST.PAS and by printer driver RC files }

const
  idDriverName      = 1;      {printer description - must be '1' for UniDrv}
  idPortName        = 15000;  {port name for printer driver}
  idComment         = 15001;  {brief description of print driver}
  idSepFile         = 15002;  {file used to create separator pages}
  idServerName      = 15003;  {'' = local printer}
  idPrintProcessor  = 15004;  {typically 'WinPrint'}
  idDataType        = 15005;  {typically 'RAW'}


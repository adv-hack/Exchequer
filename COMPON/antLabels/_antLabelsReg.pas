{******************************************************************************}
{**                                                                          **}
{**  antLabels components set registration routines.                         **}
{**                                                                          **}
{**  Author:    KARPOLAN                                                     **}
{**  E-Mail:    karpolan@yahoo.com , karpolan@utilmind.com                   **}
{**  Home Page: http://karpolan.i.am, http://www.utilmind.com                **}
{**  Copyright © 1996-99 by KARPOLAN.                                        **}
{**  Copyright © 1999, UtilMind Solutions.                                   **}
{**                                                                          **}
{******************************************************************************}
{**  History:                                                                **}
{**                                                                          **}
{**  31 aug 1999 - Last modified... Prepared for public release.             **}
{******************************************************************************}
Unit _antLabelsReg;

{$Include antLabels.Inc - contains compiler derectives}

Interface

Procedure Register;

{##############################################################################}
{******************************************************************************}
{##############################################################################}
Implementation
{##############################################################################}
{******************************************************************************}
{##############################################################################}
{ R AntLabels.res}
Uses
  Classes,
  antLabel, antAngleLabel;

Procedure Register;
Begin
{** antLabel unit **}
  RegisterClass(TantCustomLabel);
  RegisterComponents('AntLabels', [TantLabel]);
{** antAngleLabel unit **}
  RegisterClass(TantCustomAngleLabel);
  RegisterComponents('AntLabels', [TantAngleLabel]);
End;{Procedure Register}

END{Unit _antLabelsReg}.

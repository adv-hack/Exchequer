Unit EPrntDef;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$O+,F+}

{**************************************************************}
{                                                              }
{          ====----> Printer Definition Module <----===        }
{                                                              }
{              -SBS- Consultants General Module                }
{                      Created : 25/07/89                      }
{                                                              }
{                  +  Common Overlaid Unit +                   }
{                                                              }
{                  Copyright (C) 1989 by EAL & RGS             }
{           Acknowledgement given to Borland International     }
{                Novell Inc., Rought & Hoops, Corvus.          }
{                                                              }
{**************************************************************}



{****************************************************************}
{                                                                }
{ Installation Notes                                             }
{ ~~~~~~~~~~~~~~~~~~                                             }
{                                                                }
{ This Unit is designed to be self contained. It only refers to  }
{ the WinSBS & Tools Units, for basic routines such as popup etc }
{                                                                }
{ To use..                                                       }
{ Include in main unit definiton, & in SysU1 definition.         }
{ Assign a Variable called Syss.LastPno, used to record no of    }
{ Default Printer No.                                            }
{                                                                }
{ Remove include file Printer.Inc, adjust sysfilename.inc to     }
{ hold name of file, this is generally PDefilename.              }
{                                                                }
{ Assign a "With PrintDef do" to all occurences of print effects }
{ Modify all GetPrinterNo's to GetMultiprinterNo                 }
{ Modyfy inputsys to respond to SF6, allowing entry into the def }
{ Files.                                                         }
{                          _____________                         }
{                                                                }
{ Basicly if you still can't figure it out then consider the     }
{ following:-                                                    }
{          1. Resign                                             }
{          2. Employ someone else to do it for you               }
{          3. Look up Grafotec...                                }
{                                                      EAL'89    }
{****************************************************************}


Interface


Uses Classes, Dialogs, Forms, SysUtils, Windows, GlobVar;



Const

   PDefNo      =    10;   {* No. of Definitions Within the File *}




Type

   Printer_DefType = Record
                       Name     :   String[8];
                       Port     :   Byte;
                       Elite    :   String[8];
                       Pica     :   String[8];
                       Condon   :   String[8];
                       CondOf   :   String[8];
                       EnlrgOn  :   String[8];
                       EnlrgOf  :   String[8];
                       VEnlrgOn :   String[8];
                       VEnlrgOf :   String[8];
                       EmphOn   :   String[8];
                       EmphOf   :   String[8];
                       Dson     :   String[8];
                       Dsof     :   String[8];
                       UndyOn   :   String[8];
                       UndyOf   :   String[8];
                       ItalOn   :   String[8];
                       ItalOff  :   String[8];
                       Qon      :   String[8];
                       QOf      :   String[8];
                       Plen66   :   String[8];
                       ResetP   :   String[8];
                       PXtra    :   Array[1..9] of
                                    String[8];
                       PoundTx  :   Char;
                       Spare    :   Array[1..8] of Byte;
                     end;



     Printer_DefFileType = Array[1..PDefNo] of Printer_DefType;



  Var
     Printer_Def     : Printer_DefType;
     Printer_defFile : Printer_DefFileType;




  procedure getPDef;
  procedure SavePrinterDefinitions;
  Procedure Assign_PrintDef(Pno  :  Byte);



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{Uses
  EWinSBS,
  ETPrompt,
  MPMenuU;}



{$I SysFileN.Inc}



{ ========== Procedures to Get & Store Printer Definitions ========== }


procedure getPDef;
Var
  Sysfile : File Of Printer_DefFileType;
  TmpIO   : Integer;
Begin
{$I-}

  FillChar(Printer_DefFile,Sizeof(Printer_DefFile),0);

  AssignFile(Sysfile,SetDrive+PDeFileName);

  reset(Sysfile);

  TmpIO:=IOResult;

  If (TmpIO=0) then
  Begin
    read(sysfile,Printer_DefFile);

    TmpIO:=IOResult;

    CloseFile(Sysfile);

    TmpIO:=IOResult;

  end;

  If (TmpIO <> 0) Then
    MessageDlg ('IO Error reading in Printer Definitions', mtError, [mbok], 0);

{$I+}
end;

procedure SavePrinterDefinitions;
// NF: 09/11/2005 Added for Lite
var
  FileStream : TFileStream;
begin
  FileStream := TFileStream.Create(SetDrive + PDeFileName, fmOpenWrite);
  FileStream.Position := 0;
  FileStream.Write(Printer_defFile,SizeOf(Printer_DefFileType));
  FileStream.Free;
end;


{ ============ Procedure to Assign a Given Definition to the system Print Def ========= }
Procedure Assign_PrintDef(Pno  :  Byte);

Begin
  Printer_Def:=Printer_DefFile[Pno];
  Default_Printer:=Printer_def.Port;
end;


end. {Unit}

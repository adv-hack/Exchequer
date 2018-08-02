{Version 8.03}

{$i htmlcons.inc}
{$ifdef HtmlUseDLL}

{Copyright 1994, 1995, 1996 by Jan Dekkers, 72130,353
ALL RIGHTS RESERVED.

No part of this Unit may be copied in any way without a written permission.}


Unit DLLIntA;
{$X+,I-,R-,F+,T-}   {<<<<  This is a switch. Don't delete it}
{$C PRELOAD}

interface
{------------------------------------------------------------------------}

uses
{$IFDEF Win32}
  Windows,
{$ELSE}
  WinTypes,
  WinProcs,
{$ENDIF}
  Graphics,
  SYSUtils,
  Classes;

const
 ShowErrorInDll: SmallInt = 0; {1 is show messagebox in dll 0 is in this unit}
{------------------------------------------------------------------------}
var
 {Incase this palette is <> 0 then reading images will use this palette
 This can be handy when 2 images need to be displayed on one form}
 GlobalPalette : HPalette;

{------------------------------------------------------------------------}
type
 TCallBackFunction = function (I : Integer) : Integer cdecl;

{------------------------------------------------------------------------}

Type
  HGlobal           =  THandle;
{$IFDEF Win32}
  MHandle           =  HMODULE;
{$ELSE}
  MHandle           =  THandle;
{$ENDIF}

{------------------------------------------------------------------------}

{ --- Utility Procedures --- }
Function GetDeviceRes(DC : HDC) : Integer;

{------------------------------------------------------------------------}

{interface call}
Function pngfile(Filename          : String;
                 Resolution        : Integer;
                 Dither            : Integer;
            var  Bitmap            : TBitmap;
         CallBackFunction          : TCallBackFunction) : Boolean;
{------------------------------------------------------------------------}

{interface call}
Function pngstream(Stream          : TMemoryStream;
                   Resolution      : Integer;
                   Dither          : Integer;
              var  Bitmap          : TBitmap;
           CallBackFunction        : TCallBackFunction) : Boolean;
{------------------------------------------------------------------------}

{interface call}
Function jpgfile(Filename          : String;
                 Resolution        : Integer;
                 Dither            : Integer;
            var  Bitmap            : TBitmap;
           CallBackFunction        : TCallBackFunction) : Boolean;

{------------------------------------------------------------------------}

{interface call}
Function jpgstream(Stream          : TMemoryStream;
                   Resolution      : Integer;
                   Dither          : Integer;
              var  Bitmap          : TBitmap;
           CallBackFunction        : TCallBackFunction) : Boolean;
{------------------------------------------------------------------------}

{interface call}
Function bmpfile(Filename          : String;
                 Resolution        : Integer;
                 Dither            : Integer;
            var  Bitmap            : TBitmap;
         CallBackFunction          : TCallBackFunction) : Boolean;

{------------------------------------------------------------------------}

{interface call}
Function bmpstream(Stream          : TMemoryStream;
                   Resolution      : Integer;
                   Dither          : Integer;
              var  Bitmap          : TBitmap;
           CallBackFunction        : TCallBackFunction) : Boolean;
{------------------------------------------------------------------------}
{DLL call}
Function rpng(Filename      : pChar;
              Resolution    : SmallInt;
              Dither        : SmallInt;
          var hBMP          : HBitmap;
          var HPAL          : HPalette;
          CallBackFunction  : TCallBackFunction;
            ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF Win32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function rjpg(Filename      : pChar;
              Resolution    : SmallInt;
              Dither        : SmallInt;
          var hBMP          : HBitmap;
          var HPAL          : HPalette;
          CallBackFunction  : TCallBackFunction;
            ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF Win32}
                                                           StdCall;
                                                         {$ELSE}
                                                           Far;
                                                         {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function rbmp(Filename      : pChar;
              Resolution    : SmallInt;
              Dither        : SmallInt;
          var hBMP          : HBitmap;
          var HPAL          : HPalette;
          CallBackFunction  : TCallBackFunction;
            ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF Win32}
                                                       StdCall;
                                                    {$ELSE}
                                                       Far;
                                                    {$ENDIF}
{------------------------------------------------------------------------}
{DLL call}
Function rpngstream(FilePoint     : Pointer;
                    Size          : LongInt;
                    Resolution    : SmallInt;
                    Dither        : SmallInt;
                var hBMP          : HBitmap;
                var HPAL          : HPalette;
                CallBackFunction  : TCallBackFunction;
                  ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF Win32}
                                                                  StdCall;
                                                           {$ELSE}
                                                                  Far;
                                                           {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function rjpgstream(FilePoint     : Pointer;
                    Size          : LongInt;
                    Resolution    : SmallInt;
                    Scale         : SmallInt;
                    Dither        : SmallInt;
                var hBMP          : HBitmap;
                var HPAL          : HPalette;
                CallBackFunction  : TCallBackFunction;
                  ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF Win32}
                                                               StdCall;
                                                           {$ELSE}
                                                               Far;
                                                           {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function rbmpstream(FilePoint     : Pointer;
                    Size          : LongInt;
                    Resolution    : SmallInt;
                    Dither        : SmallInt;
                var hBMP          : HBitmap;
                var HPAL          : HPalette;
                CallBackFunction  : TCallBackFunction;
                  ShowDllErrorMsg : SmallInt) : SmallInt; {$IFDEF Win32}
                                                               StdCall;
                                                          {$ELSE}
                                                                Far;
                                                          {$ENDIF}
{------------------------------------------------------------------------}

{DLL call}
Function DLLINIT(HWind : HWnd;
              Password : PChar) : SmallInt; {$IFDEF Win32}
                                             StdCall;
                                           {$ELSE}
                                             Far;
                                           {$ENDIF}
{------------------------------------------------------------------------}

Function GetLibHandle : MHandle;

{------------------------------------------------------------------------}

Implementation

{------------------------------------------------------------------------}
type
  EMyException = class(Exception);

{------------------------------------------------------------------------}


{Dll name}

const
{$IFDEF Win32}
           ImageLibDLL = 'ILDA32.DLL';
{$ELSE}
           ImageLibDLL = 'ILDA16';
{$ENDIF}
{------------------------------------------------------------------------}

{ --- Utility Procedures --- }
Function GetDeviceRes(DC : HDC) : Integer;
var
 Noc:Integer;
begin
 Result:=8;
 Noc:=GetDeviceCaps(DC, BITSPIXEL);
 if Noc <= 4 then Result:=4 else
 if Noc  = 8 then Result:=8 else
 if Noc >= 16 then Result:=24;
end;
{------------------------------------------------------------------------}


{ --- Utility Procedures --- }
Function GetLibHandle : MHandle;
begin
{$IFDEF Win32}
  Result:=GetModuleHandle(ImageLibDLL);
{$ELSE}
  Result:=GetModuleHandle(ImageLibDLL+'.DLL');
{$ENDIF}
end;
{------------------------------------------------------------------------}

{ --- Error Procedure --- }
Procedure DllErrorProc(ErrCode : SmallInt);
(*Var
   ErrStr : Array[0..255] of Char;  *)
begin (*
   If ShowErrorInDll = 1 then exit;
   LoadString(GetLibHandle, Word(ErrCode), ErrStr, SizeOf(ErrStr));
   MessageDLG(StrPas(ErrStr), mtError, [mbOk], 0);    *)
end;
{------------------------------------------------------------------------}

{Interface call}
Function jpgfile(Filename          : String;
                 Resolution        : Integer;
                 Dither            : Integer;
            var  Bitmap            : TBitmap;
           CallBackFunction        : TCallBackFunction) : Boolean;

var
 Fn   : Array[0..255] of Char;
 HPAL : HPalette;
 hBMP : HBitmap;
 Res  : SmallInt;
begin
  hPal:=GlobalPalette;
  hBmp := 0;  {LDB -- if stack has valid bitmap handle and error occurs then the
               valid bitmap from a previous call gets wiped out when the bitmap
               gets freed}
  StrPCopy(Fn, Filename);
  Res:=rjpg(Fn,
            SmallInt(Resolution),
            SmallInt(Dither),
            hBMP,
            HPAL,
            CallBackFunction,
            ShowErrorInDll);

 If Res < 1 then begin
   DllErrorProc(Res);
   Result:=False
 end else
   begin
   Result:=True;
   Bitmap.Handle := hBMP;
   Bitmap.Palette := HPAL;
   end;
end;
{------------------------------------------------------------------------}

Function CheckStream(Stream : TMemoryStream) : Boolean;
begin
   Result := False;
   if Not Assigned(Stream) then begin
      exit;
   end;
   if (Stream.Memory = Nil) or (Stream.Size <1) then begin    
      exit;
   end;
   Result := True;
end;
{------------------------------------------------------------------------}

{interface call}
Function jpgstream(Stream          : TMemoryStream;
                   Resolution      : Integer;
                   Dither          : Integer;
              var  Bitmap          : TBitmap;
           CallBackFunction        : TCallBackFunction) : Boolean;
var
 HPAL : HPalette;
 hBMP : HBitmap;
 Res  : SmallInt;
begin
  Result := False;
  if CheckStream(Stream) then begin
     hPal:=GlobalPalette;
     hBmp := 0;  {LDB -- if stack has valid bitmap handle and error occurs then the
                  valid bitmap from a previous call gets wiped out when the bitmap
                  gets freed}
     Res:=rjpgstream(Stream.Memory,
                     Stream.Size,
                     SmallInt(Resolution),
                     1,
                     SmallInt(Dither),
                     hBMP,
                     HPAL,
                     CallBackFunction,
                     ShowErrorInDll);
     If Res < 1 then begin
      DllErrorProc(Res);
      Result:=False
     end else
       begin
       Result:=True;
       Bitmap.Handle := hBMP;
       Bitmap.Palette := HPAL;
       end;
  end;
end;
{------------------------------------------------------------------------}

{interface call}
Function bmpfile(Filename          : String;
                 Resolution        : Integer;
                 Dither            : Integer;
            var  Bitmap            : TBitmap;
         CallBackFunction          : TCallBackFunction) : Boolean;
var
 Fn   : Array[0..255] of Char;
 HPAL : HPalette;
 hBMP : HBitmap;
 Res  : SmallInt;
begin
  hPal:=GlobalPalette;
  hBmp := 0;  {LDB -- if stack has valid bitmap handle and error occurs then the
               valid bitmap from a previous call gets wiped out when the bitmap
               gets freed}
  StrPCopy(Fn, Filename);
  Res:=rbmp(Fn,
            SmallInt(Resolution),
            SmallInt(Dither),
            hBMP,
            HPAL,
            CallBackFunction,
            ShowErrorInDll);
  If Res < 1 then begin
   DllErrorProc(Res);
   Result:=False
  end else
   begin
   Result:=True;
   Bitmap.Handle := hBMP;
   Bitmap.Palette := HPAL;
   end;
end;
{------------------------------------------------------------------------}


{interface call}
Function bmpstream(Stream          : TMemoryStream;
                   Resolution      : Integer;
                   Dither          : Integer;
              var  Bitmap          : TBitmap;
           CallBackFunction        : TCallBackFunction) : Boolean;
var
 HPAL : HPalette;
 hBMP : HBitmap;
 Res  : SmallInt;
begin
  Result := False;
  if CheckStream(Stream) then begin
     hPal:=GlobalPalette;
     hBmp := 0;  {LDB -- if stack has valid bitmap handle and error occurs then the
                  valid bitmap from a previous call gets wiped out when the bitmap
                  gets freed}
     Res:=rbmpstream(Stream.Memory,
                     Stream.Size,
                     SmallInt(Resolution),
                     SmallInt(Dither),
                     hBMP,
                     HPAL,
                     CallBackFunction,
                     ShowErrorInDll);
     If Res < 1 then begin
      DllErrorProc(Res);
      Result:=False
     end else
       begin
       Result:=True;
       Bitmap.Handle := hBMP;
       Bitmap.Palette := HPAL;
       end;
  end;
end;
{------------------------------------------------------------------------}

{interface call}
Function pngfile(Filename          : String;
                 Resolution        : Integer;
                 Dither            : Integer;
            var  Bitmap            : TBitmap;
         CallBackFunction          : TCallBackFunction) : Boolean;

var
 Fn   : Array[0..255] of Char;
 HPAL : HPalette;
 hBMP : HBitmap;
 Res  : SmallInt;
begin
  hPal:=GlobalPalette;
  hBmp := 0;  {LDB -- if stack has valid bitmap handle and error occurs then the
               valid bitmap from a previous call gets wiped out when the bitmap
               gets freed}
  StrPCopy(Fn, Filename);
  Res:=rpng(Fn,
            SmallInt(Resolution),
            SmallInt(Dither),
            hBMP,
            HPAL,
            CallBackFunction,
            ShowErrorInDll);

  If Res < 1 then begin
   DllErrorProc(Res);
   Result:=False
  end else
   begin
   Result:=True;
   Bitmap.Handle := hBMP;
   Bitmap.Palette := HPAL;
   end;
end;
{------------------------------------------------------------------------}


{interface call}
Function pngstream(Stream          : TMemoryStream;
                   Resolution      : Integer;
                   Dither          : Integer;
              var  Bitmap          : TBitmap;
           CallBackFunction        : TCallBackFunction) : Boolean;
var
 HPAL : HPalette;
 hBMP : HBitmap;
 Res  : SmallInt;
begin
  Result := False;
  if CheckStream(Stream) then begin
     hPal:=GlobalPalette;
     hBmp := 0;  {LDB -- if stack has valid bitmap handle and error occurs then the
                  valid bitmap from a previous call gets wiped out when the bitmap
                  gets freed}
     Res:=rpngstream(Stream.Memory,
                     Stream.Size,
                     SmallInt(Resolution),
                     SmallInt(Dither),
                     hBMP,
                     HPAL,
                     CallBackFunction,
                     ShowErrorInDll);
     If Res < 1 then begin
      DllErrorProc(Res);
      Result:=False
     end else
       begin
       Result:=True;
       Bitmap.Handle := hBMP;
       Bitmap.Palette := HPAL;
       end;
  end;
end;
{------------------------------------------------------------------------}

{interface call}
procedure InitializeDll(PW : PChar);
begin
  DLLINIT(GetActiveWindow, PW);
end;
{------------------------------------------------------------------------}


Function rjpg;            external ImageLibDLL name 'rjpg';
Function rbmp;            external ImageLibDLL name 'rbmp';
Function rpng;            external ImageLibDLL name 'rpng';
Function rjpgstream;      external ImageLibDLL name 'rjpgstream';
Function rbmpstream;      external ImageLibDLL name 'rbmpstream';
Function rpngstream;      external ImageLibDLL name 'rpngstream';

Function DLLINIT;   external ImageLibDLL name 'DllInit';

{------------------------------------------------------------------------}
var
  Dap : Array[0..4] of char;
  Dbp : Array[0..4] of char;
  Dcp : Array[0..4] of char;
  Ddp : Array[0..4] of char;
  Dep : Array[0..4] of char;
  DAcc: Array[0..6] of char;

initialization
        StrCopy(dap, '@p3d');StrCopy(dbp, 'r@jk');StrCopy(dcp, '+riÿ');StrCopy(ddp, '3ne0');
        StrCopy(dep, 't8x!');DAcc[0]:=dap[1];DAcc[1]:=dbp[0];DAcc[2]:=dcp[2];DAcc[3]:=ddp[1];
        DAcc[4]:=dep[0];DAcc[5]:=#0;InitializeDll(DAcc);
  GlobalPalette:=0;

{$else}  {UseDLL not defined, empty unit}

Unit DllInta;
Interface

Implementation
{$endif}
end.


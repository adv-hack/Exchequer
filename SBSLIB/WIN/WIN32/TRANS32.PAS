unit Trans32;

{ 32-bit transparent bitblt code for WinG SpriteKit }

interface

uses Windows ;

function  TransparentDIBits( DestInfo         : PBitmapInfo ;
                             DestBits         : pointer ;
                             nXOriginDest     : SmallInt ;
                             nYOriginDest     : SmallInt ;
                             SourceInfo       : PBitmapInfo ;
                             SourceBits       : pointer ;
                             nXOriginSrc      : SmallInt ;
                             nYOriginSrc      : SmallInt ;
                             iUsage           : SmallInt ;
                             TransparentColor : byte ) : WordBool ;

implementation

uses Classes ;

procedure TransCopyDIBBits( DestBits   : pointer ;
                            SourceBits : pointer ;
                            dwWidth    : integer ;
                            dwHeight   : integer ;
                            dwScanD    : integer ;
                            dwScanS    : integer ;
                            bTranClr   : byte ) ; Pascal ;

begin
  asm
      push ds
      push esi
      push edi

      mov ecx, dwWidth
      or ecx,ecx
      jz @tcdb_nomore         { test for silly case }

      mov edx, dwHeight       { EDX is line counter }
      mov ah, bTranClr        { AH has transparency color }

      mov esi, SourceBits     { [ESI] point to source }
      mov edi, DestBits       { [edi] point to dest }

      sub dwScanD,ecx         { bias these }
      sub dwScanS,ecx

      mov ebx,ecx             { save this for later }

      {align 4}

    @tcdb_morelines:
      mov ecx, ebx            { ECX is pixel counter }
      shr ecx,2
      jz  @tcdb_nextscan

    { The idea here is to not branch very often so we unroll the loop by four  }
    { and try to not branch when a whole run of pixels is either transparent   }
    { or not transparent.                                                      }
    {                                                                          }
    { There are two loops. One loop is for a run of pixels equal to the        }
    { transparent color, the other is for runs of pixels we need to store.     }
    {                                                                          }
    { When we detect a "bad" pixel we jump to the same position in the         }
    { other loop.                                                              }
    {                                                                          }
    { Here is the loop we will stay in as long as we encounter a "transparent" }
    { pixel in the source.                                                     }

      {align 4}

    @tcdb_same:
      mov al, [esi]
      cmp al, ah
      jne @tcdb_diff0

    @tcdb_same0:
      mov al, [esi+1]
      cmp al, ah
      jne @tcdb_diff1

    @tcdb_same1:
      mov al, [esi+2]
      cmp al, ah
      jne @tcdb_diff2

    @tcdb_same2:
      mov al, [esi+3]
      cmp al, ah
      jne @tcdb_diff3

    @tcdb_same3:
      add edi,4
      add esi,4
      dec ecx
      jnz @tcdb_same
      jz  @tcdb_nextscan

    { Here is the loop we will stay in as long as                              }
    { we encounter a "non transparent" pixel in the source.                    }

      {align 4}

    @tcdb_diff:
      mov al, [esi]
      cmp al, ah
      je @tcdb_same0

    @tcdb_diff0:
      mov [edi],al
      mov al, [esi+1]
      cmp al, ah
      je @tcdb_same1

    @tcdb_diff1:
      mov [edi+1],al
      mov al, [esi+2]
      cmp al, ah
      je @tcdb_same2

    @tcdb_diff2:
      mov [edi+2],al
      mov al, [esi+3]
      cmp al, ah
      je @tcdb_same3

    @tcdb_diff3:
      mov [edi+3],al

      add edi,4
      add esi,4
      dec ecx
      jnz @tcdb_diff
      jz  @tcdb_nextscan

    { We are at the end of a scan, check for odd leftover pixels to do         }
    { and go to the next scan.                                                 }

      {align 4}

    @tcdb_nextscan:
      mov ecx,ebx
      and ecx,11b
      jnz @tcdb_oddstuff
      { move on to the start of the next line }

    @tcdb_nextscan1:
      add esi, dwScanS
      add edi, dwScanD

      dec edx                 { line counter }
      jnz @tcdb_morelines
      jz  @tcdb_nomore

    { If the width is not a multiple of 4 we will come here to clean up }
    { the last few pixels                                               }

    @tcdb_oddstuff:
      inc ecx
    @tcdb_oddloop:
      dec ecx
      jz  @tcdb_nextscan1
      mov al, [esi]
      inc esi
      inc edi
      cmp al, ah
      je  @tcdb_oddloop
      mov [edi-1],al
      jmp @tcdb_oddloop

    @tcdb_nomore:
      pop edi
      pop esi
      pop ds
  end ;
end ;


function  DIBWidthBytes( BitmapInfo : PBitmapInfo ) : integer ;

begin
  with BitmapInfo^.bmiHeader do
    Result := ( ( ( biWidth * biBitCount ) + 31 ) div 32 ) * 4 ;
end ;


function  TransparentDIBits( DestInfo         : PBitmapInfo ;
                             DestBits         : pointer ;
                             nXOriginDest     : SmallInt ;
                             nYOriginDest     : SmallInt ;
                             SourceInfo       : PBitmapInfo ;
                             SourceBits       : pointer ;
                             nXOriginSrc      : SmallInt ;
                             nYOriginSrc      : SmallInt ;
                             iUsage           : SmallInt ;
                             TransparentColor : byte ) : WordBool ;

var SourceHeight, DestHeight : integer ;
    SourceRect, DestRect     : TRect ;
    ClippingRect             : TRect ;
    TopDown                  : boolean ;
    SourceTopDown            : boolean ;
    DestWidthBytes           : integer ;
    SourceWidthBytes         : integer ;
    SrcYInc                  : integer ;

begin
  { calculate source and destination rectangles }
  with SourceInfo^.bmiHeader do begin
    SourceHeight := biHeight ;
    SourceTopDown := SourceHeight < 0 ;
    if SourceTopDown then SourceHeight := -SourceHeight ;
    SourceRect := Bounds( nXOriginDest, nYOriginDest, biWidth, SourceHeight ) ;
  end ;
  TopDown := false ;
  with DestInfo^.bmiHeader do begin
    DestHeight := biHeight ;
    if DestHeight < 0 then begin
      TopDown := true ;
      DestHeight := -DestHeight ;
    end ;
    DestRect := Rect( 0, 0, biWidth, DestHeight ) ;
  end ;

  { intersect the rectangles to get the clipping rect }
  if IntersectRect( ClippingRect, SourceRect, DestRect ) then begin
    { calc pointer into dest bitmap }
    DestWidthBytes := DIBWidthBytes( DestInfo ) ;
    if TopDown then
      inc( longint( DestBits ),
           ClippingRect.Top * DestWidthBytes + ClippingRect.Left )
    else begin
      inc( longint( DestBits ),
           ( DestHeight - ClippingRect.Top - 1 ) * DestWidthBytes +
             ClippingRect.Left ) ;
      DestWidthBytes := -DestWidthBytes ;
    end ;
    SourceWidthBytes := DIBWidthBytes( SourceInfo ) ;
    if not SourceTopDown then begin
      SrcYInc := SourceHeight - 1 ;
      if nYOriginDest < 0 then inc( SrcYInc, nYOriginDest ) ;
      if SrcYInc <> 0 then
        inc( longint( SourceBits ), SrcYInc * SourceWidthBytes ) ;
      SourceWidthBytes := -SourceWidthBytes ;
    end else begin
      if nYOriginDest < 0 then
        inc( longint( SourceBits ), -nYOriginDest * SourceWidthBytes ) ;
    end ;
    if nXOriginDest < 0 then dec( longint( SourceBits ), nXOriginDest ) ;
    with ClippingRect do
      TransCopyDIBBits( DestBits, SourceBits, Right - Left, Bottom - Top,
                        DestWidthBytes, SourceWidthBytes,
                        TransparentColor ) ;
  end ;
end ;


end.

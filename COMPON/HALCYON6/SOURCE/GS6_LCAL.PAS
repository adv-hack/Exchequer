unit gs6_lcal;
{-----------------------------------------------------------------------------
                          International Character Sets

       GS6_LCAL Copyright 2000 (c) Griffin Solutions, Inc.

       22 January 2000

          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl                    web: www.grifsolu.com
          Warner Robins, GA  31088

      -------------------------------------------------------------
      This unit handles character conversion for international character
      sets.  It works with the standard ASCII character set of MS-DOS.
      For Windows programming, it may be necessary to use the WinAPI calls
      ANSIToOEM and OEMToANSI to ensure the correct character string is
      used.

   Description

      This unit initializes country-specific character sets used in languages
      other than English.  It is designed to allow the developer to determine
      the character set for the program by setting the four 256-byte tables--
      UpperCase, LowerCase, UniqueWeight, and Dictionary character sets.

      The character tables are described below:
      -----------------------------------------

      UpperCase  -  This is a 256-byte table that is used to translate an
         ASCII character to its uppercase equivalent.  For example, the
         table below is the UpperCase table from C001P437.NLS.  If the
         character 'a' used this translation table, it would retrieve the
         value at $61 (ASCII value for 'a'), which is $41 (ASCII value for
         'A').  This table is also valid for characters stored above the
         first 128 bytes.  These characters are often alphabetical codes
         containing umlauts.  Look at the character at $A0 (a lowercase 'a'
         with an accent mark).  This character also translates to an
         uppercase 'A' ($41).  There are also many lowercase characters in
         this region whose uppercase equivalent is also in the upper 128
         bytes.  The character at location $81 is a lowercase 'u' with two
         dots above the character.  This translates to $9A, which is an
         uppercase 'U' with two dots above the character.

              0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
         0   $00 $01 $02 $03 $04 $05 $06 $07 $08 $09 $0A $0B $0C $0D $0E $0F
         1   $10 $11 $12 $13 $14 $15 $16 $17 $18 $19 $1A $1B $1C $1D $1E $1F
         2   $20 $21 $22 $23 $24 $25 $26 $27 $28 $29 $2A $2B $2C $2D $2E $2F
         3   $30 $31 $32 $33 $34 $35 $36 $37 $38 $39 $3A $3B $3C $3D $3E $3F
         4   $40 $41 $42 $43 $44 $45 $46 $47 $48 $49 $4A $4B $4C $4D $4E $4F
         5   $50 $51 $52 $53 $54 $55 $56 $57 $58 $59 $5A $5B $5C $5D $5E $5F
         6   $60 $41 $42 $43 $44 $45 $46 $47 $48 $49 $4A $4B $4C $4D $4E $4F
         7   $50 $51 $52 $53 $54 $55 $56 $57 $58 $59 $5A $7B $7C $7D $7E $7F
         8   $80 $9A $45 $41 $8E $41 $8F $80 $45 $45 $45 $49 $49 $49 $8E $8F
         9   $90 $92 $92 $4F $99 $4F $55 $55 $59 $99 $9A $9B $9C $9D $9E $9F
         A   $41 $49 $4F $55 $A5 $A5 $A6 $A7 $A8 $A9 $AA $AB $AC $AD $AE $AF
         B   $B0 $B1 $B2 $B3 $B4 $B5 $B6 $B7 $B8 $B9 $BA $BB $BC $BD $BE $BF
         C   $C0 $C1 $C2 $C3 $C4 $C5 $C6 $C7 $C8 $C9 $CA $CB $CC $CD $CE $CF
         D   $D0 $D1 $D2 $D3 $D4 $D5 $D6 $D7 $D8 $D9 $DA $DB $DC $DD $DE $DF
         E   $E0 $E1 $E2 $E3 $E4 $E5 $E6 $E7 $E8 $E9 $EA $EB $EC $ED $EE $EF
         F   $F0 $F1 $F2 $F3 $F4 $F5 $F6 $F7 $F8 $F9 $FA $FB $FC $FD $FE $FF

      LowerCase  - This is a 256-byte table used to translate an uppercase
         character to its lowercase equivalent.  The translation technique
         is the same as for the UpperCase description above.

      UniqueWeight - This 256-byte table provides a translation based on the
         collation sequence of the character set.  The values in the table
         are assigned a relative positional value for the sorted sequence of
         the ASCII value that indexes to that location. This allows sorting
         of two characters by getting their character weights from the table,
         and ordering based on the lowest weight first.

         The character weight is assigned to give the ASCII its own position
         in the sorted order.  For the letter 'a', if you wished that
         it were the lowest possible weight, then the weight $00 would be
         set at index $61. Then 'A' could be assigned the weight $01, so
         that all lowercase 'a' values were sorted before uppercase'A'.  Any
         of the high-bit umlaut characters can be ordered properly by just
         assigning a weighted value in sequence with the low-bit ASCII
         characters.  The character weight simply reflects the relative
         ranking of the character at the indexed position in the table.

              0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
         0   $00 $01 $02 $03 $04 $05 $06 $07 $08 $09 $0A $0B $0C $0D $0E $0F
         1   $10 $11 $12 $13 $14 $15 $16 $17 $18 $19 $1A $1B $1C $1D $1E $1F
         2   $20 $21 $22 $23 $24 $25 $26 $27 $28 $29 $2A $2B $2C $2D $2E $2F
         3   $30 $31 $32 $33 $34 $35 $36 $37 $38 $39 $3A $3B $3C $3D $3E $3F
         4   $40 $41 $42 $43 $44 $45 $46 $47 $48 $49 $4A $4B $4C $4D $4E $4F
         5   $50 $51 $52 $53 $54 $55 $56 $57 $58 $59 $5A $5B $5C $5D $5E $5F
         6   $60 $41 $42 $43 $44 $45 $46 $47 $48 $49 $4A $4B $4C $4D $4E $4F
         7   $50 $51 $52 $53 $54 $55 $56 $57 $58 $59 $5A $7B $7C $7D $7E $7F
         8   $43 $55 $45 $41 $41 $41 $41 $43 $45 $45 $45 $49 $49 $49 $41 $41
         9   $45 $41 $41 $4F $4F $4F $55 $55 $59 $4F $55 $24 $24 $24 $24 $24
         A   $41 $49 $4F $55 $4E $4E $A6 $A7 $3F $A9 $AA $AB $AC $21 $22 $22
         B   $B0 $B1 $B2 $B3 $B4 $B5 $B6 $B7 $B8 $B9 $BA $BB $BC $BD $BE $BF
         C   $C0 $C1 $C2 $C3 $C4 $C5 $C6 $C7 $C8 $C9 $CA $CB $CC $CD $CE $CF
         D   $D0 $D1 $D2 $D3 $D4 $D5 $D6 $D7 $D8 $D9 $DA $DB $DC $DD $DE $DF
         E   $E0 $53 $E2 $E3 $E4 $E5 $E6 $E7 $E8 $E9 $EA $EB $EC $ED $EE $EF
         F   $F0 $F1 $F2 $F3 $F4 $F5 $F6 $F7 $F8 $F9 $FA $FB $FC $FD $FE $FF

      Dictionary - This 256-byte table provides a case-insensitive translation
         based on the collation sequence of the character set.  This is the
         same asperforming an 'UpperCase' conversion then a 'UniqueWeight'
         compare.


      Usage
      -----

         During initialization, the array addresses are assigned to
         pointers pUpperTable, pLowerTable, pDictionaryTable, and pCollateTable.
         In Halcyon, string functions use these arrays for comparison
         and translation.

         The programmer can change the code page tables, or add their own.
         Just assign the new table in the initialization section. The default
         assignment is nil, to default to Windows conversions.


   Changes:

------------------------------------------------------------------------------}
interface
uses SysUtils, gs6_glbl;
var
   pDictionaryTable : PByteArray;
   pCollateTable    : PByteArray;
   pUpperTable      : PByteArray;
   pLowerTable      : PByteArray;

implementation

const

{Code Page = 437}

   UpperCase437 : array[0..255] of byte =
       {     0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F   }
       {0} ($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F,
       {1}  $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F,
       {2}  $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2D,$2E,$2F,
       {3}  $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B,$3C,$3D,$3E,$3F,
       {4}  $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4A,$4B,$4C,$4D,$4E,$4F,
       {5}  $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5A,$5B,$5C,$5D,$5E,$5F,
       {6}  $60,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4A,$4B,$4C,$4D,$4E,$4F,
       {7}  $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5A,$7B,$7C,$7D,$7E,$7F,
       {8}  $80,$9A,$45,$41,$8E,$41,$8F,$80,$45,$45,$45,$49,$49,$49,$8E,$8F,
       {9}  $90,$92,$92,$4F,$99,$4F,$55,$55,$59,$99,$9A,$9B,$9C,$9D,$9E,$9F,
       {A}  $41,$49,$4F,$55,$A5,$A5,$A6,$A7,$A8,$A9,$AA,$AB,$AC,$AD,$AE,$AF,
       {B}  $B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,
       {C}  $C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7,$C8,$C9,$CA,$CB,$CC,$CD,$CE,$CF,
       {D}  $D0,$D1,$D2,$D3,$D4,$D5,$D6,$D7,$D8,$D9,$DA,$DB,$DC,$DD,$DE,$DF,
       {E}  $E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7,$E8,$E9,$EA,$EB,$EC,$ED,$EE,$EF,
       {F}  $F0,$F1,$F2,$F3,$F4,$F5,$F6,$F7,$F8,$F9,$FA,$FB,$FC,$FD,$FE,$FF);

   LowerCase437 : array[0..255] of byte =
       {     0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F   }
       {0} ($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F,
       {1}  $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F,
       {2}  $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2D,$2E,$2F,
       {3}  $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B,$3C,$3D,$3E,$3F,
       {4}  $40,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6A,$6B,$6C,$6D,$6E,$6F,
       {5}  $70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7A,$5B,$5C,$5D,$5E,$5F,
       {6}  $60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6A,$6B,$6C,$6D,$6E,$6F,
       {7}  $70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7A,$7B,$7C,$7D,$7E,$7F,
       {8}  $87,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8A,$8B,$8C,$8D,$84,$86,
       {9}  $90,$91,$91,$93,$94,$95,$96,$97,$98,$94,$81,$9B,$9C,$9D,$9E,$9F,
       {A}  $A0,$A1,$A2,$A3,$A4,$A4,$A6,$A7,$A8,$A9,$AA,$AB,$AC,$AD,$AE,$AF,
       {B}  $B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,
       {C}  $C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7,$C8,$C9,$CA,$CB,$CC,$CD,$CE,$CF,
       {D}  $D0,$D1,$D2,$D3,$D4,$D5,$D6,$D7,$D8,$D9,$DA,$DB,$DC,$DD,$DE,$DF,
       {E}  $E0,$E1,$E2,$E3,$E4,$E5,$E6,$E7,$E8,$E9,$EA,$EB,$EC,$ED,$EE,$EF,
       {F}  $F0,$F1,$F2,$F3,$F4,$F5,$F6,$F7,$F8,$F9,$FA,$FB,$FC,$FD,$FE,$FF);

   Dictionary437 : array[0..255] of byte =
       {     0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F   }
       {0} ($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F,
       {1}  $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F,
       {2}  $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2D,$2E,$2F,
       {3}  $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B,$3C,$3D,$3E,$3F,
       {4}  $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4A,$4B,$4C,$4D,$4E,$4F,
       {5}  $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5A,$5B,$5C,$5D,$5E,$5F,
       {6}  $60,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4A,$4B,$4C,$4D,$4E,$4F,
       {7}  $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5A,$7B,$7C,$7D,$7E,$7F,
       {8}  $43,$55,$45,$41,$41,$41,$41,$43,$45,$45,$45,$49,$49,$49,$41,$41,
       {9}  $45,$41,$41,$4F,$4F,$4F,$55,$55,$59,$4F,$55,$24,$24,$24,$24,$24,
       {A}  $41,$49,$4F,$55,$4E,$4E,$A6,$A7,$3F,$A9,$AA,$AB,$AC,$21,$22,$22,
       {B}  $B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,
       {C}  $C0,$C1,$C2,$C3,$C4,$C5,$C6,$C7,$C8,$C9,$CA,$CB,$CC,$CD,$CE,$CF,
       {D}  $D0,$D1,$D2,$D3,$D4,$D5,$D6,$D7,$D8,$D9,$DA,$DB,$DC,$DD,$DE,$DF,
       {E}  $E0,$53,$E2,$E3,$E4,$E5,$E6,$E7,$E8,$E9,$EA,$EB,$EC,$ED,$EE,$EF,
       {F}  $F0,$F1,$F2,$F3,$F4,$F5,$F6,$F7,$F8,$F9,$FA,$FB,$FC,$FD,$FE,$FF);


initialization
   pDictionaryTable := nil;
   pCollateTable := nil;
   pUpperTable := nil;
   pLowerTable := nil;
end.

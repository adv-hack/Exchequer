
{*******************************************************}
{                                                       }
{       RichView                                        }
{       Error codes for RTF parser (TRVRTFReader).      }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVRTFErr;

interface

  {----------------------------- error codes --------------------------}

type
  TRVRTFErrorCode = (
    rtf_ec_OK,                   // No error
    rtf_ec_StackUnderflow,       // Unmatched '}'
    rtf_ec_StackOverflow,        // Too many '{' -- memory exhausted
    rtf_ec_UnmatchedBrace,       // RTF ended during an open group.
    rtf_ec_InvalidHex,           // Invalid hex character found in data
    rtf_ec_BadTable,             // RTF table (sym or prop) invalid
    rtf_ec_Assertion,            // Assertion failure
    rtf_ec_EndOfFile,            // End of file reached while reading RTF
    rtf_ec_FileOpenError,        // Parser cannot open input file
    rtf_ec_Exception,            // Exception
    rtf_ec_InvalidPicture,       // Invalid picture or object in RTF
    rtf_ec_Aborted
    );


implementation

end.

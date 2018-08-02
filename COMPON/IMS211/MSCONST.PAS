(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit msconst;

interface

const

  MSWSSHIFT = 40000;

  agSBase = 57000;
  msSSenderRequired = agSBase+100; {The address of sender is required}
  msSRecipientRequired = msSSenderRequired+1; {At least one Recipient, CC or BCC must be entered}
  msSMailMessageRequired = msSRecipientRequired+1; {MailMessage property must be assigned}
  msSUserNameRequired = msSMailMessageRequired+1; {UserName property is required}
  msSPasswordRequired = msSUserNameRequired+1; {Password property is required}
  msSIDsDiffer = msSPasswordRequired+1; {IDs are different}

  msSMIMEExplanation = msSIDsDiffer+1; {This is a multipart message in MIME format}

  msSUnableToRetrieveHeaders = msSMIMEExplanation+1; {Unable to retrieve headers}
  msSMissingContentType = msSUnableToRetrieveHeaders+1; {Missing required field: Content-Type}
  msSMissingClosingBoundary = msSMissingContentType+1; {Cannot find closing boundary}
  msSMissingBoundary = msSMissingClosingBoundary+1; {Cannot find boundary}
  msSErrorDecoding = msSMissingBoundary+1; {Error Decoding Attachment}

  msSFileNameBlank = msSErrorDecoding + 1;
  msSShellExecFailed = msSFileNameBlank + 1;
  msSArticleRequired = msSShellExecFailed+1; {Article property must be assigned}
  msSNewsGroupRequired = msSArticleRequired+1; {Newsgroup header is required}
  msSSubjectRequired = msSNewsGroupRequired+1; {Subject header is required}
  msSNewsGroupNotSelected = msSSubjectRequired+1; {Newsgroup has not been selected}
  msSBadArticleNumber = msSNewsGroupNotSelected+1; {Article number is not in valid range}

  msSProxyPortRequried = msSBadArticleNumber+1;  {Proxy port required}

implementation

end.

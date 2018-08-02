unit test;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

{$I EXCHDLL.INC}


procedure DoIt;




implementation

uses
  UseDLLU, sysUtils, dialogs;


procedure DoIt;
var
  Res : Smallint;
  Path : PChar;
  PTrans, PForm : PChar;

  ToRecip     : PChar;
  CCRecip     : Pchar;
  BCCRecip    : PChar;
  Att         : PChar;
  MsgText     : PChar;
  DataDir : ShortString;
  Recipients : ShortString;

  EMailInfo : TEmailPrintInfoType;

Begin


      Path := StrAlloc(255);
      PTrans := StrAlloc(255);
      PForm := StrAlloc(255);
      StrPCopy(Path, 'd:\aaa431\');
      Res := EX_INITDLLPATH(Path, True);
      Try
        StrPCopy(PTrans, 'POR000275');
        StrPCopy(PForm, 'NEWPOR');
        Res := EX_INITDLL;
        ShowMessage('Dll initialized: ' + IntToStr(Res));
        Res := EX_INITPRINTFORM(Path);
        ShowMessage('Printform initialized: ' + IntToStr(Res));
        Res := EX_ADDTRANSFORM(PTrans, PForm);
        ShowMessage('Form addded ' + IntToStr(Res));

                         ToRecip := StrAlloc(255);
                         CCRecip := StrAlloc(255);
                         BCCRecip := StrAlloc(255);
                         MsgText := StrAlloc(10000);
                         Att := StrAlloc(255);

                         Recipients := 'redbaron;redbaron@exchequer.com;';
                         StrPCopy(ToRecip, Recipients);
                         StrPCopy(BCCRecip,'');
                         StrPCopy(CCRecip, '');
                         StrPCopy(Att, '');


                         StrCopy(MsgText, 'eeeeeeeeek');

                         with EMailInfo do
                         begin
                           emPreview := False;
                           emCoverSheet := '';
                           emSenderName := 'Paul';
                           emSenderAddr := 'prutherford@exchequer.com';
                           emSubject := 'COM again';
                           emPriority := 2;{???}
                           emSendReader := 0;
                           emCompress := False;
                         end;
                           Res := EX_PRINTTOEMAIL(@EMailInfo, SizeOf(EMailInfo), ToRecip, CCRecip,
                                                  BCCRecip, MsgText, Att);


        ShowMessage('printform done ' + IntToStr(Res));
        EX_ENDPRINTFORM;
        ShowMessage('End print form: ' + IntToStr(Res));
      Finally
        EX_CLOSEDATA;
        StrDispose(PForm);
        StrDispose(PTrans);
        StrDispose(Path);
                 StrDispose(MsgText);
                 StrDispose(ToRecip);
                 StrDispose(CCRecip);
                 StrDispose(BCCRecip);
                 StrDispose(Att);

      End;

end;


end.

unit PrintFrm;

{$I DefOvr.Inc}

interface

Uses {$IFNDEF SOPDLL} ShareMem, {$ENDIF}
     Classes, Graphics, Forms, GlobVar, Dialogs, BTSupU3,TEditVal,
     VarConst, RpDevice, RpDefine;





Const
  pfProcessErr = True;

{*************************************************************************}
{* Explanation Of Parameters (For Non-Genius Types):                     *}
{*                                                                       *}
{*   PrinterNo  : Integer;      The printer number to print to.          *}
{*   Preview    : Boolean;      Print to preview window.                 *}
{*   DefMode    : Integer;      Form Mode. See GlobType.Pas for the list.*}
{*   FormName   : ShortString;  Name of form file without extension.     *}
{*   MFN        : Integer;      FNum of primary record file.             *}
{*   MKP        : Integer;      KeyPath of primary record file.          *}
{*   MKeyRef    : Str255;       Key string to retrieve primary record.   *}
{*   TFN        : Integer;      FNum of Table file.                      *}
{*   TKP        : Integer;      KeyPath of Table file.                   *}
{*   TKeyRef    : Str255;       Key string to match for items in table.  *}
{*   Descr      : ShortString;  Description printed if error occurs.     *}
{*   WinTitle   : ShortString;  String added to caption of Preview Window*}
{*   ProcessErr : Boolean;      Should the pfXXX function display an     *}
{*                              error message.                           *}
{*                                                                       *}
{* Notes:                                                                *}
{*                                                                       *}
{*   In a batch the first items printer and preview properties are used  *}
{*   for all items within the batch.                                     *}
{*                                                                       *}
{*   Primary Record: This is the record that is causing the form to be   *}
{*   printed. eg. An invoice just added.                                 *}
{*************************************************************************}



Function pfPrintFormSta (Var   PrnInfo    : TSBSPrintSetupInfo;
                         Const DefMode    : Integer;
                         Const FormName   : ShortString;
                         Const MFN, MKP   : Integer;
                         Const MKeyRef    : Str255;
                         Const TFN, TKP   : Integer;
                         Const TKeyRef    : Str255;
                         Const Descr      : ShortString;
                         Const WinTitle   : ShortString;
                         Const AddBatchInfo
                                          : StaCtrlRec;
                         Const ProcessErr : Boolean) : Boolean;

Function pfPrintForm (Var   PrnInfo   : TSBSPrintSetupInfo;
                      Const DefMode    : Integer;
                      Const FormName   : ShortString;
                      Const MFN, MKP   : Integer;
                      Const MKeyRef    : Str255;
                      Const TFN, TKP   : Integer;
                      Const TKeyRef    : Str255;
                      Const Descr      : ShortString;
                      Const WinTitle   : ShortString;
                      Const ProcessErr : Boolean) : Boolean;

Function pfInitNewBatch (Const ProcessErr : Boolean;
                         Const IgnoreInP  : Boolean) : Boolean;

Function pfAddBatchForm (Var   PrnInfo    : TSBSPrintSetupInfo;
                         Const DefMode    : Integer;
                         Const FormName   : ShortString;
                         Const MFN, MKP   : Integer;
                         Const MKeyRef    : Str255;
                         Const TFN, TKP   : Integer;
                         Const TKeyRef    : Str255;
                         Const Descr      : ShortString;
                         Const AddBatchInfo
                                          : StaCtrlRec;
                         Const ProcessErr : Boolean) : Boolean;

Function pfPrintBatch (Const WinTitle   : ShortString;
                       Const Copies     : Integer;
                       Const ProcessErr : Boolean;
                       Const JobTitle   : ShortString) : Boolean;


// PKR. 25/11/2015. ABSEXCH-15333. Email PORs to relevant suppliers.
// Added UseEmailList parameter.  This has a default value so that it doesn't break
// other code.  Setting it to false disables the email list controls on the Print Dialog.
// PKR. 11/02/2016. ABSEXCH-17279. Re-introduce print-to-screen option ofr Re-order list when sending to printer only.
// Added AllowPrintPreview parameter with default value.
Function pfSelectFormPrinter (Var PrnInfo   : TSBSPrintSetupInfo;
                                  ChangeFrm : Boolean;
                              Var FormName  : Str10;
                              Var PFont     : TFont;
                              Var POrient   : TOrientation;
                                  UseEmailList : Boolean = true;
                                  AllowPrintPreview : Boolean = true) : Boolean;

Function pfSelectPrinter (Var PrnInfo   : TSBSPrintSetupInfo;
                          Var PFont     : TFont;
                          Var POrient   : TOrientation) : Boolean;

Function pf_Check4Printers  :  Boolean;

Procedure pfSet_NDPDefaultPrinter(ThisSet  :  TSBSComboBox;
                                  DefName  :  Str255;
                                  pfsMode  :  Byte);

Procedure pfSet_DefaultPrinter(ThisSet  :  TSBSComboBox;
                               DefName  :  Str255);


Function pfFind_DefaultPrinter(DefName  :  Str255)  :  Integer;

Function pfGetMultiFrmDefs(PageNo  :  Integer)  :  FormDefsRecType;

Function pfGetMultiFrmDesc(PageNo  :  Integer)  :  Str255;

Procedure pfDeleteSwapFile(Const PrintFile : String);


Var
  Local_PrnInfo  :  ^TSBSPrintSetupInfo;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses SysUtils,
     Windows,
     ETStrU,
     BTrvU2,
     PassWR2U,
     BTSupU1
     
{$IFDEF Frm}
     ,
     GlobType,
     PrntDlg2,
     LabelDlg,
     DllInt
{$ENDIF}
     ;




{Function pfSelectFormPrinter (Var PrinterNo : Integer;
                              Var ToPrinter : Boolean;
                                  ChangeFrm : Boolean;
                              Var FormName  : Str10;
                              Var PFont     : TFont;
                              Var POrient   : TPrinterOrientation;
                              Var PCopies   : Integer) : Boolean;}
// PKR. 11/-2/2016. ABSEXCH-17279. Re-introduce print preview for Stock Re-order Print only.
// Added optional parameter, AllowPrintPreview, which is used to determine whether the
// print to screen option is displayed or not in the print dialog.
Function pfSelectFormPrinter (Var PrnInfo   : TSBSPrintSetupInfo;
                                  ChangeFrm : Boolean;
                              Var FormName  : Str10;
                              Var PFont     : TFont;
                              Var POrient   : TOrientation;
                                  UseEmailList : Boolean = true;
                                  AllowPrintPreview : Boolean = true) : Boolean;
  Var
{$IFDEF Frm}
    fmInfo  :  FormInfoType;
{$ENDIF}
    fmNeedLabel  :  Boolean;

Begin
  fmNeedLabel:=PrnInfo.LabelMode;

  {$IFDEF Frm}

     If (InBuildPP) then {* Abort here, as flag means Print preview is still being created *}
     Begin
       Result:=False;
       Exit;
     end;


    If (RpDev.Printers.Count > 0) Then
    Begin

      PrnInfo.DevIdx := -1;

      PrintShowForm:=ChangeFrm;
      PrintDlg := TPrintDlg.Create(Application.MainForm);

      // PKR. 25/11/2015. ABSEXCH-15333. Email PORs to relevant suppliers.
      // Enable or disable the email list controls on the print dialog.
      PrintDlg.UseEmailList := UseEmailList;
      // PKR. 11/-2/2016. ABSEXCH-17279. Re-introduce print preview for Stock Re-order Print only.
      // Pass the AllowPrintPreview value on to the print dialog.
      PrintDlg.AllowPrintPreview := AllowPrintPreview;
      Try
        InModalDialog:=BOn;

        If Assigned(PFont) then
          // HM 31/07/03: Modified Report Font handling
          //PrintDlg.ThisFont.Assign(PFont);
          PrintDlg.ReportFont := PFont;

        PrintDlg.ThisOrient:=POrient;

        PrintDlg.edtEmlSubject.Text:=PrnInfo.feEmailSubj;
        // HM 07/08/00: Insert subject at START of message leaving signature intact.
        //PrintDlg.MemFaxMessage.Text:=PrnInfo.feEmailSubj;
        PrnInfo.feFaxMsg := PrnInfo.feEmailSubj + #13#10 + PrnInfo.feFaxMsg;

        If (Not ChangeFrm) then
        Begin
          PrintDlg.CopiesF.Text:=Form_Int(PrnInfo.NoCopies,0);
          PrnInfo.DevIdx:=pfFind_DefaultPrinter(GetProfilePrinter(BOff));
        end
        else
        Begin
          If (FormName<>'') then
          Begin
            fmInfo:=GetFormInfo(FormName);
            PrintDlg.FormPrnInfo(fmInfo, PrnInfo);

            PrintDlg.CopiesF.Text:=Form_Int(fmInfo.Copies,0);
          end;

          PrintDlg.DefSuggPrinter:=pfFind_DefaultPrinter(GetProfilePrinter(BOn));


        
          If (PrnInfo.DevIdx=-1) then
            PrnInfo.DevIdx:=PrintDlg.DefSuggPrinter;

          PrintDlg.NeedLabel:=fmNeedLabel;
        end;

        Result := PrintDlg.Execute(FormName, PrnInfo);

        If Result Then
        Begin
          { User selected ok on the dialog }

          { Printer info setup in dialog }


          {*}

          PrnInfo.TestMode:=PrintDlg.Radio_Test.Checked;


          If (ChangeFrm) then
            FormName:=PrintDlg.UseForm;

          // HM 31/07/03: Modified Report Font handling
          //If (Assigned(PrintDlg.ThisFont)) and Assigned(PFont) then
          //  PFont.Assign(PrintDlg.ThisFont);
          If Assigned(PFont) then
            PFont.Assign(PrintDlg.ReportFont);


          POrient:=PrintDlg.ThisOrient;


          If (ChangeFrm) Then Begin
            { Display label setup dialog (if required!) }
            fmInfo:=GetFormInfo(FormName);
            If (fmInfo.FormHeader.fhFormType = ftLabel) Then
              Result := ShowLabelDlg(fmInfo.FormHeader, PrnInfo.pbLabel1);
          End; { If }
        End; { If }
      Finally
        PrintDlg.Free;
        InModalDiaLog:=BOff;

      End;
    End { If }
    Else Begin
      Result := False;
      MessageDlg ('A printer must be defined before anything can be printed!', mtWarning, [mbOk], 0);
    End; { Else }
  {$ENDIF}
End;


{Function pfSelectPrinter (Var PrinterNo : Integer;
                          Var ToPrinter : Boolean;
                          Var PFont     : TFont;
                          Var POrient   : TPrinterOrientation;
                          Var PCopies   : Integer) : Boolean;}
Function pfSelectPrinter (Var PrnInfo   : TSBSPrintSetupInfo;
                          Var PFont     : TFont;
                          Var POrient   : TOrientation) : Boolean;

Var
  S  :  Str10;

Begin
  S:='';
  Result:=pfSelectFormPrinter(PrnInfo, BOff,S,PFont,POrient);
End;

{Function pfPrintForm (Const PrinterNo  : Integer;
                      Const Preview    : Boolean;
                      Const DefMode    : Integer;
                      Const FormName   : ShortString;
                      Const Copies     : Integer;
                      Const MFN, MKP   : Integer;
                      Const MKeyRef    : Str255;
                      Const TFN, TKP   : Integer;
                      Const TKeyRef    : Str255;
                      Const Descr      : ShortString;
                      Const WinTitle   : ShortString;
                      Const ProcessErr : Boolean) : Boolean;}

Function pfPrintFormSta (Var   PrnInfo    : TSBSPrintSetupInfo;
                         Const DefMode    : Integer;
                         Const FormName   : ShortString;
                         Const MFN, MKP   : Integer;
                         Const MKeyRef    : Str255;
                         Const TFN, TKP   : Integer;
                         Const TKeyRef    : Str255;
                         Const Descr      : ShortString;
                         Const WinTitle   : ShortString;
                         Const AddBatchInfo
                                          : StaCtrlRec;
                         Const ProcessErr : Boolean) : Boolean;
{$IFDEF Frm}

Var
  pbStaInfo   : StaCtrlRec;
  
Begin
  If (Assigned(AddBatchInfo)) then
    pbStaInfo:=AddBatchInfo
  else
    pbStaInfo:=Nil;

  { Clear out any batch records }
  Result := pfInitNewBatch (ProcessErr,BOff);

  { Check the batch was started ok }


  If Result Then Begin
    { Setup the batch record }
    Result := pfAddBatchForm (PrnInfo,DefMode, FormName, MFN, MKP,
                              MKeyRef, TFN, TKP, TKeyRef,
                              Descr, pbStaInfo, ProcessErr);

    { Check the form was added to the batch ok }
    If Result Then Begin
      { Print the batch }
      Result := pfPrintBatch ( WinTitle, PrnInfo.NoCopies, ProcessErr, PrnInfo.feJobtitle);
    End; { If }
  End; { If }
{$ELSE}
Begin
  Result := True;
{$ENDIF}
End;



Function pfPrintForm (Var   PrnInfo    : TSBSPrintSetupInfo;
                      Const DefMode    : Integer;
                      Const FormName   : ShortString;
                      Const MFN, MKP   : Integer;
                      Const MKeyRef    : Str255;
                      Const TFN, TKP   : Integer;
                      Const TKeyRef    : Str255;
                      Const Descr      : ShortString;
                      Const WinTitle   : ShortString;
                      Const ProcessErr : Boolean) : Boolean;
{$IFDEF Frm}
Begin
  Result:=pfPrintFormSta (PrnInfo,DefMode,FormName,MFN, MKP,MKeyRef,TFN, TKP,TKeyRef,Descr,WinTitle,Nil,ProcessErr);

{$ELSE}
Begin
  Result := True;
{$ENDIF}
End;



{ Initialises a New Batch }
Function pfInitNewBatch (Const ProcessErr : Boolean;
                         Const IgnoreInP  : Boolean) : Boolean;
Begin
  {$IFDEF Frm}
    Result := (Not InPrint) or (IgnoreInP);

    If Result Then
    Begin
      Result := PrintBatch_ClearBatch;

      If (Not Result) And ProcessErr Then
        MessageDlg ('An error occured initialising the Print Batch',
                    mtInformation, [mbOk], 0);

      If (Not IgnoreInP) then
        InPrint := Result;
    End { If }
    Else
      If ProcessErr Then
        MessageDlg ('Something else is already printing',
                    mtInformation, [mbOk], 0);
  {$ELSE}
    Result := True;
  {$ENDIF}
End;



{ Add a Form to the current batch }
Function pfAddBatchForm (Var   PrnInfo    : TSBSPrintSetupInfo;
                         Const DefMode    : Integer;
                         Const FormName   : ShortString;
                         Const MFN, MKP   : Integer;
                         Const MKeyRef    : Str255;
                         Const TFN, TKP   : Integer;
                         Const TKeyRef    : Str255;
                         Const Descr      : ShortString;
                         Const AddBatchInfo
                                          : StaCtrlRec;
                         Const ProcessErr : Boolean) : Boolean;
{$IFDEF Frm}
Var
  BatchRec : PrintBatchRecType;
Begin
  Local_PrnInfo^:=PrnInfo;

  FillChar(BatchRec,Sizeof(BatchRec),0);

  With BatchRec Do
  Begin
    {pbPrinterNo := PrinterNo;
    pbPreview   := Preview;}
    pbDefMode   := DefMode;
    pbEFDName   := FormName;
    pbMainFNum  := MFN;
    pbMainKPath := MKP;
    pbMainKRef  := MKeyRef;
    pbTablFNum  := TFN;
    pbTablKPath := TKP;
    pbTablKRef  := TKeyRef;
    pbDescr     := Descr;
    pbLabel1    :=PrnInfo.pbLabel1;
    pbTestMode  :=PrnInfo.TestMode;
    pblbCopies  :=PrnInfo.NoCopies;

    If (Assigned(AddBatchInfo)) then
      pbRepInfo:=AddBatchInfo^;
  End; { With }
  Result := PrintBatch_AddJob (BatchRec);

  If (Not Result) And ProcessErr Then
    MessageDlg ('An error occured adding to the Print Batch',
                mtInformation, [mbOk], 0);
{$ELSE}
Begin
  Result := True;
{$ENDIF}
End;


{ Prints The Current Batch }
Function pfPrintBatch (Const WinTitle   : ShortString;
                       Const Copies     : Integer;
                       Const ProcessErr : Boolean;
                       Const JobTitle   : ShortString) : Boolean;

Begin
  {$IFDEF Frm}
    { Print The Current Batch }
    Local_PrnInfo^.NoCopies:=Copies;
    Local_PrnInfo^.feJobtitle := JobTitle;
    Local_PrnInfo^.feUserId:=EntryRec^.Login; {Assign currently logged in user to print job}

    Result := PrintBatch_Print (WinTitle, Local_PrnInfo^);

    { Print any error messages reqired }
    If (Not Result) And ProcessErr Then
      MessageDlg ('An error occured printing the batch',
                  mtInformation, [mbOk], 0);

    InPrint := False;
  {$ELSE}
    Result := True;
  {$ENDIF}
End;


Function StripOnP(S  :  Str255)  :  Str255;
Var
  FoundOk   :  Boolean;
  wc,n      :  Byte;


Begin
  wc:=WordCnt(S);

  FoundOk:=BOff;

  For n:=1 to wc do
  Begin
    FoundOk:=(UpCaseStr(ExtractWords(n,1,S))='ON');

    If (FoundOk) then
      Break;
  end;

  If (FoundOk) then
    Result:=Copy(S,1,Pred(PosWord(n,S)))
  else
    Result:=S;

end;



Function pfFind_DefaultPrinter(DefName  :  Str255)  :  Integer;

Var
  n         :  Integer;
  FoundOk   :  Boolean;

Begin
  FoundOk:=BOff;

  For n:=0 to Pred(RpDev.Printers.Count) do
  Begin
    FoundOk:=(CheckKey(DefName,RpDev.Printers[n],Length(DefName),BOff)) and (DefName<>'');

    If (FoundOk) then
      Break;
  end;

  If (FoundOk) then
    Result:=n
  else
    If (RpDev.Printers.Count>0) then
      Result:=RpDev.DeviceIndex
    else
      Result:=-1;

end;


Function pfFind_ComboPrinter(ThisSet  :  TSBSComboBox;
                             DefName  :  Str255)  :  Integer;

Var
  n         :  Integer;
  FoundOk   :  Boolean;

Begin
  FoundOk:=BOff;

  For n:=0 to Pred(ThisSet.Items.Count) do
  Begin
    FoundOk:=(CheckKey(DefName,ThisSet.Items[n],Length(DefName),BOff)) and (DefName<>'');

    If (FoundOk) then
      Break;
  end;

  If (FoundOk) then
    Result:=n
  else
    If (ThisSet.Items.Count>=0) then
      Result:=0
    else
      Result:=-1;

end;



Function pf_Check4Printers  :  Boolean;

Begin

  Result:=(RpDev.Printers.Count > 0);

end;


{EL: v4.40. This routine split to add in the use windows default message.  pfFind_Combo routine also added so we
            are searching for the item within the actual list rather than the global list of printers }

Procedure pfSet_NDPDefaultPrinter(ThisSet  :  TSBSComboBox;
                                  DefName  :  Str255;
                                  pfsMode  :  Byte);

Const
  NoDefaultStr  = 'Use Windows Default';
  EntDefaultStr = 'Use System Setup Default';

Var
  n  :  Integer;

Begin
  ThisSet.Items.Assign(RpDev.Printers);

  For n:=0 to Pred(ThisSet.Items.Count) do
    ThisSet.Items[n]:=StripOnP(ThisSet.Items[n]);

  ThisSet.ItemsL.Assign(RpDev.Printers);

  If (pfsMode In [1,2]) then {Insert a no default printer in as first item}
  Begin
    ThisSet.Items.Insert(0,NoDefaultStr);
    ThisSet.ItemsL.Insert(0,NoDefaultStr);
  end;

  If (pfsMode In [2]) then {Insert a no default printer in as first item}
  Begin
    ThisSet.Items.Insert(0,EntDefaultStr);
    ThisSet.ItemsL.Insert(0,EntDefaultStr);
  end;



  {$IFDEF FRM}
    Case pfsMode of
      1,2
         :  ThisSet.ItemIndex:=pfFind_ComboPrinter(ThisSet,DefName);

      else  ThisSet.ItemIndex:=pfFind_DefaultPrinter(DefName);
    end; {Case..}

    If (ThisSet.ItemIndex>=0) then
      ThisSet.Text:=ThisSet.Items[ThisSet.ItemIndex];
  {$ELSE}
    ThisSet.ItemIndex:=RpDev.DeviceIndex;
  {$ENDIF}

end;


Procedure pfSet_DefaultPrinter(ThisSet  :  TSBSComboBox;
                               DefName  :  Str255);


Begin
  pfSet_NDPDefaultPrinter(ThisSet,DefName,0);

end;


 { =========== Get MultiUser System File =========== }


 Function pfGetMultiFrmDefs(PageNo  :  Integer)  :  FormDefsRecType;

 Var
   TempSys  :  Sysrec;
   Key2F    :  Str255;
   LStatus  :  SmallInt;


 Begin

   TempSys:=Syss;

   If (PageNo<=0) then
     Result:=SyssForms^
   else
   Begin
     Key2F:=Copy(SysNames[FormR],1,2)+Chr(PageNo+100);

     LStatus:=Find_Rec(B_GetEq,F[SysF],SysF,RecPtr[SysF]^,0,Key2F);

     If (LStatus=0) then
       Move(Syss,Result,Sizeof(Result))
     else
       Result:=SyssForms^;

   end; {If Ok..}

   Syss:=TempSys;
 end;


  { =========== Get MultiUser System File =========== }


 Function pfGetMultiFrmDesc(PageNo  :  Integer)  :  Str255;

 Var
   TempSys  :  Sysrec;
   Key2F    :  Str255;
   LStatus  :  SmallInt;


 Begin

   TempSys:=Syss;

   Result:='Global Default Forms';
   If (PageNo>0) then
   Begin
     Key2F:=Copy(SysNames[FormR],1,2)+Chr(PageNo+100);

     LStatus:=Find_Rec(B_GetEq,F[SysF],SysF,RecPtr[SysF]^,0,Key2F);

     If (LStatus=0) then
       Result:=Syss.FormDefs.Descr;

   end; {If Ok..}

   Syss:=TempSys;
 end;

 Procedure pfDeleteSwapFile(Const PrintFile : String);

 Begin
   {$IFDEF FRM}
     DeletePrintFile(PrintFile);
   {$ENDIF}
 end;

Initialization

  New(Local_PrnInfo);

  FillChar(Local_PrnInfo^,Sizeof(Local_PrnInfo^),0);

Finalization

  Dispose(Local_PrnInfo);
end.

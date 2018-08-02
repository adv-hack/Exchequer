unit madListForms;

interface

// module list of the current process
function GetFormList : string;

implementation

uses Windows, madExcept, Forms, SysUtils, ComCtrls;

//=========================================================================

Function GetFormList : String;
Var
  I : Integer;

  //------------------------------

  Function ReportActiveTab (Const TheForm : TForm; Const TabControlName : ShortString) : String;
  Var
    oPageControl : TPageControl;
  Begin // ReportActiveTab
    Result := '';

    // Try to retrieve the TPageControl
    oPageControl := TPageControl(TheForm.FindChildControl(TabControlName));
    If Assigned(oPageControl) Then
    Begin
      If Assigned(oPageControl.ActivePage) Then
      Begin
        Result := ', Tab=' + QuotedStr(oPageControl.ActivePage.Caption);
      End; // If Assigned(oPageControl.ActivePage)
    End; // If Assigned(oPageControl)
  End; // ReportActiveTab

  //------------------------------

Begin // GetFormList
  Result := '';

  Try
    If Assigned(Screen) Then
    Begin
      If Assigned(Screen.ActiveForm) Then
      Begin
        Result := Result + 'ActiveForm: ' + Screen.ActiveForm.ClassName + '  (Caption=' + QuotedStr(Screen.ActiveForm.Caption) + ')'#$D#$A;
      End; // If Assigned(Screen.ActiveForm)

      If Assigned(Screen.ActiveControl) Then
      Begin
        Result := Result + 'ActiveControl: ' + Screen.ActiveControl.ClassName + '  (Name=' + Screen.ActiveControl.Name + ')'#$D#$A;
      End; // If Assigned(Screen.ActiveControl) 

      If (Screen.FormCount > 0) Then
      Begin
        For I := 0 To (Screen.FormCount - 1) Do
        Begin
          Result := Result + 'Form' + IntToStr(I) + ': ';
          Try
            // Report Form Type and Caption - Caption will help where we have multiple instances of the
            // same form, e.g. Daybooks and Transaction windows
            Result := Result + Screen.Forms[I].ClassName + '  (Caption=' + QuotedStr(Screen.Forms[I].Caption);

            // Additional Data
            Try
              If Assigned(Screen.Forms[I].ActiveControl) Then
              Begin
                Result := Result + ', ActiveControl=' + Screen.Forms[I].ActiveControl.ClassName + '/' + Screen.Forms[I].ActiveControl.Name;
              End; // If Assigned(Screen.Forms[I].ActiveForm)
            Except
              On Exception Do
                Result := Result + ', ActiveControl=Error';
            End; // Try..Except

            Try
              // Generic Daybook ----------------------------------
              If (Screen.Forms[I].ClassName = 'TDaybk1') Then
              Begin
                Result := Result + ReportActiveTab (Screen.Forms[I], 'DPageCtrl1');
              End // If (Screen.Forms[I].ClassName = 'TDaybk1')
              // Job Daybook --------------------------------------
              Else If (Screen.Forms[I].ClassName = 'TJobDaybk') Then
              Begin
                Result := Result + ReportActiveTab (Screen.Forms[I], 'DPageCtrl1');
              End // If (Screen.Forms[I].ClassName = 'TJobDaybk')

              // SOR/SIN/POR/PIN Transaction window --------------
              Else If (Screen.Forms[I].ClassName = 'TSalesTBody') Then
              Begin
                Result := Result + ReportActiveTab (Screen.Forms[I], 'PageControl1');
              End // If (Screen.Forms[I].ClassName = 'TSalesTBody')
              // SRC/PPY Transaction window ----------------------
              Else If (Screen.Forms[I].ClassName = 'TRecepForm') Then
              Begin
                Result := Result + ReportActiveTab (Screen.Forms[I], 'PageControl1');
              End // If (Screen.Forms[I].ClassName = 'TRecepForm')
              // NOM Transaction Window --------------------------
              Else If (Screen.Forms[I].ClassName = 'TNTxfrForm') Then
              Begin
                Result := Result + ReportActiveTab (Screen.Forms[I], 'PageControl1');
              End // If (Screen.Forms[I].ClassName = 'TNTxfrForm')
              // TSH Transaction Window --------------------------
              Else If (Screen.Forms[I].ClassName = 'TTSheetForm') Then
              Begin
                Result := Result + ReportActiveTab (Screen.Forms[I], 'PageControl1');
              End // If (Screen.Forms[I].ClassName = 'TTSheetForm')
              // ADJ Transaction Window --------------------------
              Else If (Screen.Forms[I].ClassName = 'TStkAdj') Then
              Begin
                Result := Result + ReportActiveTab (Screen.Forms[I], 'PageControl1');
              End // If (Screen.Forms[I].ClassName = 'TStkAdj')
              // Application / Contract Transaction Window -------
              Else If (Screen.Forms[I].ClassName = 'TJCAPP') Then
              Begin
                Result := Result + ReportActiveTab (Screen.Forms[I], 'PageControl1');
              End // If (Screen.Forms[I].ClassName = 'TJCAPP')
              // SBT/PBT Transaction window ----------------------
              Else If (Screen.Forms[I].ClassName = 'TBatchEntry') Then
              Begin
                Result := Result + ReportActiveTab (Screen.Forms[I], 'PageControl1');
              End // If (Screen.Forms[I].ClassName = 'TBatchEntry')
              // Telesales Wizard --------------------------------
              Else If (Screen.Forms[I].ClassName = 'TTeleSFrm') Then
              Begin
                Result := Result + ReportActiveTab (Screen.Forms[I], 'PageControl1');
              End // If (Screen.Forms[I].ClassName = 'TTeleSFrm')

              // Trader List --------------------------------------
              Else If (Screen.Forms[I].ClassName = 'TTradList') Then
              Begin
                Result := Result + ReportActiveTab (Screen.Forms[I], 'PageControl1');
              End // If (Screen.Forms[I].ClassName = 'TTradList')
              // Trader Record ------------------------------------
              Else If (Screen.Forms[I].ClassName = 'TCustRec3') Then
              Begin
                Result := Result + ReportActiveTab (Screen.Forms[I], 'PageControl1');
              End // If (Screen.Forms[I].ClassName = 'TCustRec3')

              // Stock List ---------------------------------------
              Else If (Screen.Forms[I].ClassName = 'TStkList') Then
              Begin
                Result := Result + ReportActiveTab (Screen.Forms[I], 'pcStockList');
              End // If (Screen.Forms[I].ClassName = 'TStkList')
              // Stock Record -------------------------------------
              Else If (Screen.Forms[I].ClassName = 'TStockRec') Then
              Begin
                Result := Result + ReportActiveTab (Screen.Forms[I], 'PageControl1');
              End // If (Screen.Forms[I].ClassName = 'TStockRec')

              // Job Record ---------------------------------------
              Else If (Screen.Forms[I].ClassName = 'TJobRec') Then
              Begin
                Result := Result + ReportActiveTab (Screen.Forms[I], 'PageControl1');
              End // If (Screen.Forms[I].ClassName = 'TJobRec')

              // ObjectFind ---------------------------------------
              Else If (Screen.Forms[I].ClassName = 'TFindRec') Then
              Begin
                Result := Result + ReportActiveTab (Screen.Forms[I], 'PageControl1');
              End // If (Screen.Forms[I].ClassName = 'TFindRec')
            Except
              On Exception Do
                ;
            End; // Try..ExceptTryex
          Except
            On E:Exception Do
              Result := Result + E.Message;
          End; // Try..ExceptTryex

          Result := Result + ')'#$D#$A;
        End; // For I
      End; // If (Screen.FormCount > 0)
    End // If Assigned(Screen.Screen)
    Else
      Result := 'Information Not Available';
  Except
    On E:Exception Do
      Result := E.Message;
  End; // Try..ExceptTryex
End; // GetFormList

//=========================================================================

initialization
  RegisterBugReportPlugin('forms', 'list of forms', GetFormList);
finalization
  UnregisterBugReportPlugin('forms');
end.

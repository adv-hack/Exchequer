madListForms.pas / madListForms.mep
===================================

madListForms.pas is a plug-in for MadExcept which details the ActiveForm/ActiveControl 
and the forms in the Screen.Forms array.

This is intended to provide additional information in the exception logs so we can try
and identify where things are crashing:-

    forms:
    ActiveForm: TMessageForm  (Caption='Error')
    ActiveControl: TButton  (Name=OK)
    Form0: TMessageForm  (Caption='Error', ActiveControl=TButton/OK)
    Form1: TfrmCompanyList  (Caption='Change Company', ActiveControl=TMLCaptureEdit/)
    Form2: TDaybk1  (Caption='Sales Transactions', ActiveControl=TStringGridEx/, Tab='History')
    Form3: TMainForm  (Caption='Exchequer Global - Internal Test - markd6')
    Form4: TDiaryFrm  (Caption='Workflow Diary', ActiveControl=TMLCaptureEdit/)


Rename the .pas file (or copy it using UpdateMEP.bat) to madListForms.mep.

To install it into Delphi (requires MadExcept!) double-click on the .mep file. You may also
need to got into the MadExccept Settings and in the "bug report settings" section tick the
"list of forms" option in order for it to execute.

Note: Once it is installed you can just update the .mep file and it will automatically 
compile the latest version into the application's .EXE.



Development & Testing
=====================
During development I have included the .pas file in EParentU.pas to ensure that it 
compiles.  It doesn't actually work like that, you still need to rename/copy it to the 
.mep and build/run the system to test it.


Build Machine
=============
The build machine uses W:\Entrprse\MultComp\EntComp.Mes for the MadExcept settings, it is
suggested that a Enter1.Mes be setup which includes the "list of forms" option enabled in
order to limit the changes to the Enter1's.

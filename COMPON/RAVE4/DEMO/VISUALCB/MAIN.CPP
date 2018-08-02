//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Main.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "RPBase"
#pragma link "RPDefine"
#pragma link "RPRave"
#pragma link "RPSystem"
#pragma link "RVCsBars"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  Rvcsbars::RaveRegister();  
  RaveProject->Open();
  RaveProject->GetReportList(ReportLB->Items,true);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormDestroy(TObject *Sender)
{
  RaveProject->Close();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormShow(TObject *Sender)
{
  ReportLB->ItemIndex = 0;
  ReportLBClick(NULL);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ReportLBClick(TObject *Sender)
{
  RaveProject->SelectReport(ReportLB->Items->Strings[ReportLB->ItemIndex],true);
  RaveProject->ReportDescToMemo(DescMemo);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  RaveProject->Execute();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button2Click(TObject *Sender)
{
  RaveProject->Design();
  RaveProject->GetReportList(ReportLB->Items,true);
}
//---------------------------------------------------------------------------

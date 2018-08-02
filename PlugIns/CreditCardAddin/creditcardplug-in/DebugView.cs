using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;

namespace PaymentGatewayAddin
  {
  public partial class DebugView : Form
    {
    bool isSaved = true;

    public DebugView()
      {
      InitializeComponent();
      }

    public void Log(string message)
      {
      string ts = string.Empty;
      if (chkTimestamp.Checked)
        {
        DateTime timenow = DateTime.Now;
        ts = string.Format("{0:HH:mm:ss dd/MM/yyyy} ", timenow);
        }

      textDebug.AppendText(string.Format("{0}{1}\r\n", ts, message));
      isSaved = false;
      textDebug.Refresh();
      }

    private void btnClear_Click(object sender, EventArgs e)
      {
      textDebug.Text = "";
      isSaved = true;
      }

    private void btnSave_Click(object sender, EventArgs e)
      {
      if (saveFileDialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
        {
        // create a writer and open the file
        TextWriter tw = new StreamWriter(saveFileDialog.FileName);
        // write a line of text to the file
        tw.WriteLine(textDebug.Text);
        // close the stream
        tw.Close();
        isSaved = true;
        }
      }

    private void DebugView_FormClosing(object sender, FormClosingEventArgs e)
      {
      if (!isSaved)
        {
        DialogResult dlgRes = MessageBox.Show("Do you want to save the log?", "DebugView", MessageBoxButtons.YesNoCancel);
        switch (dlgRes)
          {
          case System.Windows.Forms.DialogResult.Yes:
            btnSave_Click(sender, e);
            e.Cancel = false;
            break;
          case System.Windows.Forms.DialogResult.No:
            e.Cancel = false;
            break;
          case System.Windows.Forms.DialogResult.Cancel:
            e.Cancel = true;
            break;
          }
        }
      else
        {
        e.Cancel = false;
        }
      }

    private void DebugView_Load(object sender, EventArgs e)
      {
      chkOnTop.Checked = false;
      this.TopMost = chkOnTop.Checked;
      }

    private void chkOnTop_CheckedChanged(object sender, EventArgs e)
      {
      this.TopMost = chkOnTop.Checked;
      }

    private void selectAllToolStripMenuItem_Click(object sender, EventArgs e)
      {
      textDebug.SelectAll();
      }

    private void copyToolStripMenuItem_Click(object sender, EventArgs e)
      {
      textDebug.Copy();
      }

    private void saveToolStripMenuItem_Click(object sender, EventArgs e)
      {
      btnSave_Click(sender, e);
      }
    }
  }

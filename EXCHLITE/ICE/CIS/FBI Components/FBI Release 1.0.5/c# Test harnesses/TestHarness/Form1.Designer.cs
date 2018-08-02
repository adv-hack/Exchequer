namespace TestHarness
{
   partial class frmTestHarness
   {
      /// <summary>
      /// Required designer variable.
      /// </summary>
      private System.ComponentModel.IContainer components = null;

      /// <summary>
      /// Clean up any resources being used.
      /// </summary>
      /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
      protected override void Dispose(bool disposing)
      {
         if (disposing && (components != null)) {
            components.Dispose();
         }
         base.Dispose(disposing);
      }

      #region Windows Form Designer generated code

      /// <summary>
      /// Required method for Designer support - do not modify
      /// the contents of this method with the code editor.
      /// </summary>
      private void InitializeComponent()
      {
          this.pnlCommands = new System.Windows.Forms.Panel();
          this.cmdDelete = new System.Windows.Forms.Button();
          this.cmdRedirect = new System.Windows.Forms.Button();
          this.cmdPoll = new System.Windows.Forms.Button();
          this.cmdPost = new System.Windows.Forms.Button();
          this.cmdIRMark = new System.Windows.Forms.Button();
          this.txtXML = new System.Windows.Forms.TextBox();
          this.txtResults = new System.Windows.Forms.TextBox();
          this.pnlCommands.SuspendLayout();
          this.SuspendLayout();
          // 
          // pnlCommands
          // 
          this.pnlCommands.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                      | System.Windows.Forms.AnchorStyles.Left)));
          this.pnlCommands.Controls.Add(this.cmdDelete);
          this.pnlCommands.Controls.Add(this.cmdRedirect);
          this.pnlCommands.Controls.Add(this.cmdPoll);
          this.pnlCommands.Controls.Add(this.cmdPost);
          this.pnlCommands.Controls.Add(this.cmdIRMark);
          this.pnlCommands.Location = new System.Drawing.Point(-3, 0);
          this.pnlCommands.Name = "pnlCommands";
          this.pnlCommands.Size = new System.Drawing.Size(122, 473);
          this.pnlCommands.TabIndex = 0;
          // 
          // cmdDelete
          // 
          this.cmdDelete.Location = new System.Drawing.Point(8, 136);
          this.cmdDelete.Name = "cmdDelete";
          this.cmdDelete.Size = new System.Drawing.Size(103, 23);
          this.cmdDelete.TabIndex = 4;
          this.cmdDelete.Text = "Delete";
          this.cmdDelete.UseVisualStyleBackColor = true;
          this.cmdDelete.Click += new System.EventHandler(this.cmdDelete_Click);
          // 
          // cmdRedirect
          // 
          this.cmdRedirect.Location = new System.Drawing.Point(8, 107);
          this.cmdRedirect.Name = "cmdRedirect";
          this.cmdRedirect.Size = new System.Drawing.Size(103, 23);
          this.cmdRedirect.TabIndex = 3;
          this.cmdRedirect.Text = "Reassign URL";
          this.cmdRedirect.UseVisualStyleBackColor = true;
          this.cmdRedirect.Click += new System.EventHandler(this.cmdRedirect_Click);
          // 
          // cmdPoll
          // 
          this.cmdPoll.Location = new System.Drawing.Point(8, 78);
          this.cmdPoll.Name = "cmdPoll";
          this.cmdPoll.Size = new System.Drawing.Size(103, 23);
          this.cmdPoll.TabIndex = 2;
          this.cmdPoll.Text = "Begin polling";
          this.cmdPoll.UseVisualStyleBackColor = true;
          this.cmdPoll.Click += new System.EventHandler(this.cmdPoll_Click);
          // 
          // cmdPost
          // 
          this.cmdPost.Location = new System.Drawing.Point(8, 49);
          this.cmdPost.Name = "cmdPost";
          this.cmdPost.Size = new System.Drawing.Size(103, 23);
          this.cmdPost.TabIndex = 1;
          this.cmdPost.Text = "Post document";
          this.cmdPost.UseVisualStyleBackColor = true;
          this.cmdPost.Click += new System.EventHandler(this.cmdPost_Click);
          // 
          // cmdIRMark
          // 
          this.cmdIRMark.Location = new System.Drawing.Point(8, 18);
          this.cmdIRMark.Name = "cmdIRMark";
          this.cmdIRMark.Size = new System.Drawing.Size(103, 25);
          this.cmdIRMark.TabIndex = 0;
          this.cmdIRMark.Text = "Add IR Mark";
          this.cmdIRMark.UseVisualStyleBackColor = true;
          this.cmdIRMark.Click += new System.EventHandler(this.cmdIRMark_Click);
          // 
          // txtXML
          // 
          this.txtXML.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                      | System.Windows.Forms.AnchorStyles.Right)));
          this.txtXML.Location = new System.Drawing.Point(125, 1);
          this.txtXML.Multiline = true;
          this.txtXML.Name = "txtXML";
          this.txtXML.Size = new System.Drawing.Size(404, 446);
          this.txtXML.TabIndex = 1;
          this.txtXML.TextChanged += new System.EventHandler(this.txtXML_TextChanged);
          // 
          // txtResults
          // 
          this.txtResults.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
          this.txtResults.Location = new System.Drawing.Point(125, 453);
          this.txtResults.Name = "txtResults";
          this.txtResults.Size = new System.Drawing.Size(404, 20);
          this.txtResults.TabIndex = 2;
          // 
          // frmTestHarness
          // 
          this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
          this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
          this.ClientSize = new System.Drawing.Size(529, 473);
          this.Controls.Add(this.txtResults);
          this.Controls.Add(this.txtXML);
          this.Controls.Add(this.pnlCommands);
          this.Name = "frmTestHarness";
          this.Text = "Internet Filing Test Harness";
          this.pnlCommands.ResumeLayout(false);
          this.ResumeLayout(false);
          this.PerformLayout();

      }

      #endregion

      private System.Windows.Forms.Panel pnlCommands;
      private System.Windows.Forms.TextBox txtXML;
      private System.Windows.Forms.TextBox txtResults;
      private System.Windows.Forms.Button cmdIRMark;
      private System.Windows.Forms.Button cmdPost;
      private System.Windows.Forms.Button cmdPoll;
      private System.Windows.Forms.Button cmdRedirect;
		private System.Windows.Forms.Button cmdDelete;
   }
}


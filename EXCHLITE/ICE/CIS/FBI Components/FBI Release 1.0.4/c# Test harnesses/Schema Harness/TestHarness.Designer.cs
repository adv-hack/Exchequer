namespace Schema_Harness
{
    partial class ct600Harness
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
            if (disposing && (components != null))
            {
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
            this.irMarkTextBox = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.endPollingButton = new System.Windows.Forms.Button();
            this.correlationIDTextBox = new System.Windows.Forms.TextBox();
            this.CorrelationID = new System.Windows.Forms.Label();
            this.generateIRMarkButton = new System.Windows.Forms.Button();
            this.rawXMLInput = new System.Windows.Forms.TextBox();
            this.inputFilenameLabel = new System.Windows.Forms.Label();
            this.outputFilenameLabel = new System.Windows.Forms.Label();
            this.HMRCoutputXML = new System.Windows.Forms.TextBox();
            this.sendPollingMessageButton = new System.Windows.Forms.Button();
            this.outputTextBox = new System.Windows.Forms.TextBox();
            this.submitButton = new System.Windows.Forms.Button();
            this.transformButton = new System.Windows.Forms.Button();
            this.label3 = new System.Windows.Forms.Label();
            this.IRmarkedOutput = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.HMRCXMLinput = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.submitInput = new System.Windows.Forms.TextBox();
            this.xslFilename = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.guidBox = new System.Windows.Forms.TextBox();
            this.harnessRadio = new System.Windows.Forms.RadioButton();
            this.xmlformerRadio = new System.Windows.Forms.RadioButton();
            this.transmissionRadio = new System.Windows.Forms.RadioButton();
            this.deleteButton = new System.Windows.Forms.Button();
            this.label7 = new System.Windows.Forms.Label();
            this.deleteGUIDbox = new System.Windows.Forms.TextBox();
            this.resetDataButton = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // irMarkTextBox
            // 
            this.irMarkTextBox.Location = new System.Drawing.Point(119, 202);
            this.irMarkTextBox.Name = "irMarkTextBox";
            this.irMarkTextBox.Size = new System.Drawing.Size(453, 20);
            this.irMarkTextBox.TabIndex = 0;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(28, 205);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(45, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "IR Mark";
            // 
            // endPollingButton
            // 
            this.endPollingButton.Location = new System.Drawing.Point(606, 350);
            this.endPollingButton.Name = "endPollingButton";
            this.endPollingButton.Size = new System.Drawing.Size(162, 35);
            this.endPollingButton.TabIndex = 2;
            this.endPollingButton.Text = "End Polling";
            this.endPollingButton.UseVisualStyleBackColor = true;
            this.endPollingButton.Click += new System.EventHandler(this.endPolling_Click);
            // 
            // correlationIDTextBox
            // 
            this.correlationIDTextBox.Location = new System.Drawing.Point(119, 300);
            this.correlationIDTextBox.Name = "correlationIDTextBox";
            this.correlationIDTextBox.Size = new System.Drawing.Size(453, 20);
            this.correlationIDTextBox.TabIndex = 3;
            // 
            // CorrelationID
            // 
            this.CorrelationID.AutoSize = true;
            this.CorrelationID.Location = new System.Drawing.Point(28, 303);
            this.CorrelationID.Name = "CorrelationID";
            this.CorrelationID.Size = new System.Drawing.Size(68, 13);
            this.CorrelationID.TabIndex = 4;
            this.CorrelationID.Text = "CorrelationID";
            // 
            // generateIRMarkButton
            // 
            this.generateIRMarkButton.Location = new System.Drawing.Point(606, 168);
            this.generateIRMarkButton.Name = "generateIRMarkButton";
            this.generateIRMarkButton.Size = new System.Drawing.Size(162, 35);
            this.generateIRMarkButton.TabIndex = 5;
            this.generateIRMarkButton.Text = "Generate IRMark";
            this.generateIRMarkButton.UseVisualStyleBackColor = true;
            this.generateIRMarkButton.Click += new System.EventHandler(this.generateIRMark_Click);
            // 
            // rawXMLInput
            // 
            this.rawXMLInput.Location = new System.Drawing.Point(119, 52);
            this.rawXMLInput.Name = "rawXMLInput";
            this.rawXMLInput.Size = new System.Drawing.Size(453, 20);
            this.rawXMLInput.TabIndex = 6;
            // 
            // inputFilenameLabel
            // 
            this.inputFilenameLabel.AutoSize = true;
            this.inputFilenameLabel.Location = new System.Drawing.Point(28, 55);
            this.inputFilenameLabel.Name = "inputFilenameLabel";
            this.inputFilenameLabel.Size = new System.Drawing.Size(76, 13);
            this.inputFilenameLabel.TabIndex = 7;
            this.inputFilenameLabel.Text = "Input Filename";
            // 
            // outputFilenameLabel
            // 
            this.outputFilenameLabel.AutoSize = true;
            this.outputFilenameLabel.Location = new System.Drawing.Point(28, 107);
            this.outputFilenameLabel.Name = "outputFilenameLabel";
            this.outputFilenameLabel.Size = new System.Drawing.Size(84, 13);
            this.outputFilenameLabel.TabIndex = 9;
            this.outputFilenameLabel.Text = "Output Filename";
            // 
            // HMRCoutputXML
            // 
            this.HMRCoutputXML.Location = new System.Drawing.Point(119, 104);
            this.HMRCoutputXML.Name = "HMRCoutputXML";
            this.HMRCoutputXML.Size = new System.Drawing.Size(453, 20);
            this.HMRCoutputXML.TabIndex = 8;
            // 
            // sendPollingMessageButton
            // 
            this.sendPollingMessageButton.Location = new System.Drawing.Point(606, 308);
            this.sendPollingMessageButton.Name = "sendPollingMessageButton";
            this.sendPollingMessageButton.Size = new System.Drawing.Size(162, 35);
            this.sendPollingMessageButton.TabIndex = 10;
            this.sendPollingMessageButton.Text = "Send Polling Message";
            this.sendPollingMessageButton.UseVisualStyleBackColor = true;
            this.sendPollingMessageButton.Click += new System.EventHandler(this.sendPollingMessageButton_Click);
            // 
            // outputTextBox
            // 
            this.outputTextBox.Location = new System.Drawing.Point(26, 498);
            this.outputTextBox.Name = "outputTextBox";
            this.outputTextBox.Size = new System.Drawing.Size(742, 20);
            this.outputTextBox.TabIndex = 11;
            // 
            // submitButton
            // 
            this.submitButton.Location = new System.Drawing.Point(606, 266);
            this.submitButton.Name = "submitButton";
            this.submitButton.Size = new System.Drawing.Size(162, 35);
            this.submitButton.TabIndex = 12;
            this.submitButton.Text = "Submit Return";
            this.submitButton.UseVisualStyleBackColor = true;
            this.submitButton.Click += new System.EventHandler(this.submitButton_Click);
            // 
            // transformButton
            // 
            this.transformButton.Location = new System.Drawing.Point(606, 70);
            this.transformButton.Name = "transformButton";
            this.transformButton.Size = new System.Drawing.Size(162, 35);
            this.transformButton.TabIndex = 13;
            this.transformButton.Text = "Transform XML";
            this.transformButton.UseVisualStyleBackColor = true;
            this.transformButton.Click += new System.EventHandler(this.transformButton_Click);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(28, 179);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(84, 13);
            this.label3.TabIndex = 17;
            this.label3.Text = "Output Filename";
            // 
            // IRmarkedOutput
            // 
            this.IRmarkedOutput.Location = new System.Drawing.Point(119, 176);
            this.IRmarkedOutput.Name = "IRmarkedOutput";
            this.IRmarkedOutput.Size = new System.Drawing.Size(453, 20);
            this.IRmarkedOutput.TabIndex = 16;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(27, 153);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(76, 13);
            this.label4.TabIndex = 15;
            this.label4.Text = "Input Filename";
            // 
            // HMRCXMLinput
            // 
            this.HMRCXMLinput.Location = new System.Drawing.Point(119, 150);
            this.HMRCXMLinput.Name = "HMRCXMLinput";
            this.HMRCXMLinput.Size = new System.Drawing.Size(453, 20);
            this.HMRCXMLinput.TabIndex = 14;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(27, 277);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(76, 13);
            this.label5.TabIndex = 19;
            this.label5.Text = "Input Filename";
            // 
            // submitInput
            // 
            this.submitInput.Location = new System.Drawing.Point(119, 274);
            this.submitInput.Name = "submitInput";
            this.submitInput.Size = new System.Drawing.Size(453, 20);
            this.submitInput.TabIndex = 18;
            // 
            // xslFilename
            // 
            this.xslFilename.Location = new System.Drawing.Point(119, 78);
            this.xslFilename.Name = "xslFilename";
            this.xslFilename.Size = new System.Drawing.Size(453, 20);
            this.xslFilename.TabIndex = 20;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(28, 81);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(72, 13);
            this.label6.TabIndex = 21;
            this.label6.Text = "XSL Filename";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(28, 329);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(34, 13);
            this.label2.TabIndex = 23;
            this.label2.Text = "GUID";
            // 
            // guidBox
            // 
            this.guidBox.Location = new System.Drawing.Point(119, 326);
            this.guidBox.Name = "guidBox";
            this.guidBox.Size = new System.Drawing.Size(453, 20);
            this.guidBox.TabIndex = 22;
            // 
            // harnessRadio
            // 
            this.harnessRadio.AutoSize = true;
            this.harnessRadio.Checked = true;
            this.harnessRadio.Location = new System.Drawing.Point(264, 12);
            this.harnessRadio.Name = "harnessRadio";
            this.harnessRadio.Size = new System.Drawing.Size(64, 17);
            this.harnessRadio.TabIndex = 24;
            this.harnessRadio.TabStop = true;
            this.harnessRadio.Text = "Harness";
            this.harnessRadio.UseVisualStyleBackColor = true;
            // 
            // xmlformerRadio
            // 
            this.xmlformerRadio.AutoSize = true;
            this.xmlformerRadio.Location = new System.Drawing.Point(445, 12);
            this.xmlformerRadio.Name = "xmlformerRadio";
            this.xmlformerRadio.Size = new System.Drawing.Size(79, 17);
            this.xmlformerRadio.TabIndex = 25;
            this.xmlformerRadio.TabStop = true;
            this.xmlformerRadio.Text = "XMLFormer";
            this.xmlformerRadio.UseVisualStyleBackColor = true;
            // 
            // transmissionRadio
            // 
            this.transmissionRadio.AutoSize = true;
            this.transmissionRadio.Location = new System.Drawing.Point(334, 12);
            this.transmissionRadio.Name = "transmissionRadio";
            this.transmissionRadio.Size = new System.Drawing.Size(108, 17);
            this.transmissionRadio.TabIndex = 26;
            this.transmissionRadio.TabStop = true;
            this.transmissionRadio.Text = "XMLTransmission";
            this.transmissionRadio.UseVisualStyleBackColor = true;
            // 
            // deleteButton
            // 
            this.deleteButton.Location = new System.Drawing.Point(606, 425);
            this.deleteButton.Name = "deleteButton";
            this.deleteButton.Size = new System.Drawing.Size(162, 35);
            this.deleteButton.TabIndex = 27;
            this.deleteButton.Text = "Delete Return";
            this.deleteButton.UseVisualStyleBackColor = true;
            this.deleteButton.Click += new System.EventHandler(this.deleteButton_Click);
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(28, 436);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(34, 13);
            this.label7.TabIndex = 29;
            this.label7.Text = "GUID";
            // 
            // deleteGUIDbox
            // 
            this.deleteGUIDbox.Location = new System.Drawing.Point(119, 433);
            this.deleteGUIDbox.Name = "deleteGUIDbox";
            this.deleteGUIDbox.Size = new System.Drawing.Size(453, 20);
            this.deleteGUIDbox.TabIndex = 28;
            // 
            // resetDataButton
            // 
            this.resetDataButton.Location = new System.Drawing.Point(606, 12);
            this.resetDataButton.Name = "resetDataButton";
            this.resetDataButton.Size = new System.Drawing.Size(162, 26);
            this.resetDataButton.TabIndex = 30;
            this.resetDataButton.Text = "Reset Data";
            this.resetDataButton.UseVisualStyleBackColor = true;
            this.resetDataButton.Click += new System.EventHandler(this.resetDataButton_Click);
            // 
            // ct600Harness
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(781, 537);
            this.Controls.Add(this.resetDataButton);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.deleteGUIDbox);
            this.Controls.Add(this.deleteButton);
            this.Controls.Add(this.transmissionRadio);
            this.Controls.Add(this.xmlformerRadio);
            this.Controls.Add(this.harnessRadio);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.guidBox);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.xslFilename);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.submitInput);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.IRmarkedOutput);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.HMRCXMLinput);
            this.Controls.Add(this.transformButton);
            this.Controls.Add(this.submitButton);
            this.Controls.Add(this.outputTextBox);
            this.Controls.Add(this.sendPollingMessageButton);
            this.Controls.Add(this.outputFilenameLabel);
            this.Controls.Add(this.HMRCoutputXML);
            this.Controls.Add(this.inputFilenameLabel);
            this.Controls.Add(this.rawXMLInput);
            this.Controls.Add(this.generateIRMarkButton);
            this.Controls.Add(this.CorrelationID);
            this.Controls.Add(this.correlationIDTextBox);
            this.Controls.Add(this.endPollingButton);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.irMarkTextBox);
            this.Name = "ct600Harness";
            this.Text = "CT600 Submission Test Harness";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox irMarkTextBox;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button endPollingButton;
        private System.Windows.Forms.TextBox correlationIDTextBox;
        private System.Windows.Forms.Label CorrelationID;
        private System.Windows.Forms.Button generateIRMarkButton;
        private System.Windows.Forms.TextBox rawXMLInput;
        private System.Windows.Forms.Label inputFilenameLabel;
        private System.Windows.Forms.Label outputFilenameLabel;
        private System.Windows.Forms.TextBox HMRCoutputXML;
        private System.Windows.Forms.Button sendPollingMessageButton;
        private System.Windows.Forms.TextBox outputTextBox;
        private System.Windows.Forms.Button submitButton;
        private System.Windows.Forms.Button transformButton;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox IRmarkedOutput;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox HMRCXMLinput;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox submitInput;
        private System.Windows.Forms.TextBox xslFilename;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox guidBox;
        private System.Windows.Forms.RadioButton harnessRadio;
        private System.Windows.Forms.RadioButton xmlformerRadio;
        private System.Windows.Forms.RadioButton transmissionRadio;
        private System.Windows.Forms.Button deleteButton;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox deleteGUIDbox;
        private System.Windows.Forms.Button resetDataButton;
    }
}


using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Diagnostics;

namespace Complier
{
    public partial class Form1 : Form
    {

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void richTextBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void richTextBox3_TextChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            richTextBox2.Clear();
            richTextBox3.Clear();
            TextWriter txt = new StreamWriter("F:\\Pictures\\Faculty Of Engineering\\Senior\\CMPN403 - Languages and Compilers\\Project\\Phase 2\\input.txt");
            txt.Write(richTextBox1.Text);
            txt.Close();

            System.Diagnostics.Process.Start("CMD.EXE", "/C F: & cd F:\\Pictures\\Faculty Of Engineering\\Senior\\CMPN403 - Languages and Compilers\\Project\\Phase 2 & project ");
        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {
            richTextBox2.Text = File.ReadAllText("F:\\Pictures\\Faculty Of Engineering\\Senior\\CMPN403 - Languages and Compilers\\Project\\Phase 2\\output.txt");
            richTextBox3.Text = File.ReadAllText("F:\\Pictures\\Faculty Of Engineering\\Senior\\CMPN403 - Languages and Compilers\\Project\\Phase 2\\symbol.txt");
        }
    }
}

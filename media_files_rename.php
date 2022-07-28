<?php
error_reporting(E_ALL ^ E_NOTICE);

/* Fix file extension ("filename mkv = filename.mkv")
$files = scandir('.');
foreach($files as $file) {
        if(!strstr($file, "mkv")) continue;
        $extension = end(explode(" ", $file));
        $newFile = trim(explode($extension, $file)[0]).".".$extension;
        rename($file, $newFile);
        echo $file." == $newFile\n";

}*/

/* Move year from beginning of files to end ("2004 - The Movie.avi = The Movie (2004).avi)"
$files = scandir('.');
foreach($files as $file) {
        if(!strstr($file, "avi") && !strstr($file, "mkv") & !strstr($file, "bif") && !strstr($file, "nfo") && !strstr($file, "jpg") && !strstr($file, "mpg") && !strstr($file, "mp4")) continue;
        if(strstr($file, "Kick") || strstr($file, "Wall")) continue; //special exception for kickass & wall-e
        $year = trim(explode("-", $file)[0]);
        if(strlen($year) != 4) continue;
        //$newFile = trim(explode($extension, $file)[0]).".".$extension;
        //rename($file, $newFile);
        $extension = end(explode(".", $file));
        if(!isset(explode("-", $file)[1])) continue;
        $newFile = str_replace(".".$extension, "", trim(str_replace($year." - ", "", $file)))." (".$year.")".".".$extension;
        rename($file, $newFile);
        echo $file." == $newFile\n";
}*/


/* Move year from beginning of folder name to end ("2004 The Movie = The Movie (2004)")
$files = scandir('.');
foreach($files as $file) {
        if(!is_dir($file)) continue;
        $year = trim(explode(" ", $file)[0]);
        if($year == "2012") continue; //special case for movie called "2012"
        if(strlen($year) != 4 || !intval($year)) continue;
        //if(!isset(explode(".", $file)[1])) continue;
        $newFile = trim(str_replace($year, "", $file))." (".$year.")";
        rename($file, $newFile);
        echo $file." == $newFile\n";
}*/


/* Rename files & folders that have periods instead of spaces (The.Movie.Is.Best(.avi) = The Movie Is Best(.avi))
$files = scandir('.');
foreach($files as $file) {
        $extension = end(explode(".", $file));
        if(count(explode(".", $file)) < 3) continue;
         if(is_dir($file)) $newFile =  trim(str_replace(".", " ", $file));
                else $newFile = trim(str_replace(".", " ", $file).".".$extension);

//        rename($file, $newFile);
        echo $file." == $newFile\n";
}*/

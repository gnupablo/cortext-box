<?php
// Décodage des lignes de log du Worker

//error_reporting(0);
error_reporting(E_ALL);

// Codes couleurs
$fond_vert = "\033[42m";
$fond_rouge = "\033[41m";
$texte_blanc = "\033[37m";
$texte_rouge = "\033[31m";
$texte_bleu = "\033[1;36m";
$texte_bleu_fonce="\033[00;34m";
$texte_vert = "\033[32m";
$texte_orange = "\033[33m";
$texte_vert_clair = "\033[92m";
$underline = "\033[4m";
$reset_color = "\033[0m";
$tab = "\t";

if ( $argc > 1 && is_numeric( $argv[1] ) ) {
      $filterJobId = (int)$argv[1];
      echo "Filtering Job Id $filterJobId";
    } else {
      $filterJobId = null;
}


function isHTML( $string ) {
    return ( $string != strip_tags( $string ) );
}

function outputJSON( $tableau, $dec = "" ) {
    global $tab, $fond_vert, $texte_blanc, $texte_rouge, $texte_vert, $texte_orange, $underline, $reset_color;
    $dec = $tab.$dec;
    //echo PHP_EOL;
    foreach( $tableau as $key => $val ) {
        if ( gettype( $val ) !== "array" ) {
            switch($key) {
            case ("msg"):
            case ("content"):
                if ( $myjob = json_decode( $val, true ) ) {
                    // Message contenant du JSON
                    echo $tab.$texte_orange.$key.":".$reset_color.PHP_EOL;
                    outputJSON( $myjob ); //attention recursion :)
                } else {
                    // Message standard
                    if ( strlen( $val ) && substr_compare( $val, "------------ ", 0, 13 ) == 0 )
                        echo $tab.$texte_orange.$key.":".$reset_color." ".substr( strip_tags($val), 13 ).$tab;
                    else
                        echo $tab.$texte_orange.$key.":".$reset_color." ".strip_tags(@print_r($val,true)).$tab;
                }
                //print_r($job);
                break;
            case ("running"):
            case ("signaled"):
            case ("stopped") :
                echo $dec.$texte_orange.$key.": ".$reset_color.($val?"true":"false").$tab;
                break;
            case ("watchpoint"):
                $val = explode("/", $val);
                if(is_array($val)){
                    $val = array_reverse($val);
                    $val = $val[0]; //si le watchpoint est un chemin on prend uniquement le nom du fichier
                }
                    
                echo $dec.$texte_orange.$key.": ".$reset_color.$val.$tab;
                break;
            case ("tag"):
                echo "";
                break;
            case ("pid"):
            case ("job_id"):
            default:
                echo $dec.$texte_orange.$key.": ".$reset_color.$val.$tab;
            }
        } else {
            switch($key) {
            case ("msg"):
            case ("headers"):
            case ("result"):
            case ("status"):
                if ( is_array( $val ) ) {
                    echo $dec.$texte_orange.$key.": ".$reset_color.$tab;
                    foreach( $val as $k => $v ) {
                        if ( is_array( $v ) ) {
                            echo $dec.$tab."[".$k."] => ".print_r($v,true).$tab;
                        } else if ( is_bool( $v ) ) {
                            echo $dec.$tab."[".$k."] => ".($v?"true":"false").$tab;
                        } else {
                            echo $dec.$tab."[".$k."] => ".$v.$tab;
                        }
                    }
                } else {
                    echo $dec.$texte_orange.$key.": ".$reset_color.$val.$tab;
                }
                break;
            default:
                echo $dec.$texte_orange.$key.": ".$reset_color.@print_r($val,true).$tab;
            }  
        }
    }
    echo PHP_EOL;
}

while($f = fgets(STDIN)){
    echo $reset_color;
    //detection du nom de fichier de tail -f
    $pattern = '/^==>(.*)<==$/';

    //détection du mot error, passage en rouge de la date
    if(strpos($f, "error") or strpos("Error", $f) or strpos($f, "CRITICAL") or strpos($f, "WARNING") ){
        $fond_date = $fond_rouge.$texte_blanc;
    }else {
        $fond_date = $texte_vert_clair;
    }
    if(preg_match($pattern, $f, $result)){
            echo PHP_EOL.$texte_bleu.$result[1].$reset_color.PHP_EOL.PHP_EOL;
            continue;
        }

    // Si un jobId est passé en paramètre, on n'affiche que les lignes concernées
    if ( $filterJobId === null ||
          preg_match('/(MCP|INK|JOB|WORKER|DEBUG).*job( #?' 
            . $filterJobId 
            . ' |.?id.?\": ?.?\"' 
            . $filterJobId 
            . '.?\")/i', $f, $filter) 
        ){

        if($filterJobId)
        {
            echo PHP_EOL."-- filtering Job Id : ".$filterJobId."--".PHP_EOL;
        }
   
        //pattern log standard Cortext
        $pattern = '/^(\[[0-9 :-]+\]) ([^. ]+)\.([^: ]+): (.*) (\[.*\]).*$/';
        if ( preg_match( $pattern, $f, $result ) ) {
            // Horodatage
            echo PHP_EOL.$fond_date.$result[1].$reset_color.$tab
                . $texte_vert.$result[2].$texte_bleu." [".$result[3]."]".$reset_color;

            $msg = json_decode( $result[4], true );

            if ( $msg === null ) {
                // Pas du JSON alors on sort le message reformaté
                echo " - ".strip_tags($result[4]).$reset_color;

            } else {
                // On a du JSON, alors on décode
                outputJSON( $msg, " | " );
            }
        } else {
            // Essai de parsing de la date seule
            $pattern = '/^(\[[^\]]+\]) (.*)$/';
            if(preg_match($pattern, $f, $result)){
                echo PHP_EOL.$fond_date.$result[1].$reset_color.$tab.$result[2].$reset_color;
            }else{ 
                //trying apache
                $pattern = '/^(\S+) (\S+) (\S+) \[([^:]+):(\d+:\d+:\d+) ([^\]]+)\] (.*)$/';
                if(preg_match($pattern, $f, $result)){
                    echo PHP_EOL.$fond_date."[".$result[4]." ".$result[5]. " ".$result[6]."] - ".$reset_color.$tab.$result[7].$reset_color;
                }else{
                    //trying meteor
                    $pattern = '/I(\d{4})(\d{2})(\d{2})-([^\.]+)\.([^\?]*)\?(.*)/';
                    if(preg_match($pattern, $f, $result)){
                        //echo "match ".print_r($result, true);
                        echo PHP_EOL.$fond_date."[".$result[1]."-".$result[2]."-".$result[3]." ".$result[4]."]".$tab.$reset_color.$texte_bleu_fonce ." PROJECTS -".$result[6].$reset_color;
                    }else{
                        // La ligne ne correspond pas au format, on la sort normalement si le message n'est pas vide
                        if(trim($f)!=""){
                            echo PHP_EOL.$fond_date.date("[Y-m-d H:i:s] (?) ").$reset_color.$tab."--".$f."--".$reset_color;
                        }
                    }
                }
                
            }
        } 
    }//fin if jobId
    
}

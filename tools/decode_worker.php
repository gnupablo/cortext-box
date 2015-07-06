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
$texte_vert = "\033[32m";
$texte_orange = "\033[33m";
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
                        echo $tab.$texte_orange.$key.":".$reset_color." ".substr( strip_tags($val), 13 ).PHP_EOL;
                    else
                        echo $tab.$texte_orange.$key.":".$reset_color." ".strip_tags(@print_r($val,true)).PHP_EOL;
                }
                //print_r($job);
                break;
            case ("running"):
            case ("signaled"):
            case ("stopped") :
                echo $dec.$texte_orange.$key.": ".$reset_color.($val?"true":"false").PHP_EOL;
                break;
            case ("watchpoint"):
            case ("tag"):
            case ("pid"):
            default:
                echo $dec.$texte_orange.$key.": ".$reset_color.$val.PHP_EOL;
            }
        } else {
            switch($key) {
            case ("msg"):
            case ("headers"):
            case ("result"):
            case ("status"):
                if ( is_array( $val ) ) {
                    echo $dec.$texte_orange.$key.": ".$reset_color.PHP_EOL;
                    foreach( $val as $k => $v ) {
                        if ( is_array( $v ) ) {
                            echo $dec.$tab."[".$k."] => ".print_r($v,true).PHP_EOL;
                        } else if ( is_bool( $v ) ) {
                            echo $dec.$tab."[".$k."] => ".($v?"true":"false").PHP_EOL;
                        } else {
                            echo $dec.$tab."[".$k."] => ".$v.PHP_EOL;
                        }
                    }
                } else {
                    echo $dec.$texte_orange.$key.": ".$reset_color.$val.PHP_EOL;
                }
                break;
            default:
                echo $dec.$texte_orange.$key.": ".$reset_color.@print_r($val,true).PHP_EOL;
            }
        }
    }
}

while($f = fgets(STDIN)){
    echo $reset_color;
    //detection du nom de fichier de tail -f
    $pattern = '/^==>(.*)<==$/';

    //détection du mot error, passage en rouge de la date
    if(strpos($f, "error") or strpos("Error", $f) or strpos($f, "CRITICAL") ){
        $fond_date = $fond_rouge;
    }else {
        $fond_date = $fond_vert;
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
        echo PHP_EOL.$fond_date.$texte_blanc.$result[1].$reset_color.$tab.$texte_vert.$underline. $result[2].$texte_bleu." [".$result[3]."]".$reset_color.PHP_EOL;

            $msg = json_decode( $result[4], true );

            if ( $msg === null ) {
                // Pas du JSON alors on sort le message reformaté
                echo PHP_EOL.$tab."MSG: ".strip_tags($result[4]).$reset_color.PHP_EOL;

            } else {
                // On a du JSON, alors on décode
                outputJSON( $msg, "\t" );
            }
        } else {
            // Essai de parsing de la date seule
            $pattern = '/^(\[[^\]]+\]) (.*)$/';
            if(preg_match($pattern, $f, $result)){
                echo $fond_date.$texte_blanc.$result[1].$reset_color.$tab.$result[2].$reset_color.PHP_EOL;
            }else{
                // La ligne ne correspond pas au format, on la sort normalement
                echo $fond_date.$texte_blanc."[?:?]".$reset_color.$tab.$f.$reset_color;    
            }
            
        } 
    }//fin if jobId
    
}

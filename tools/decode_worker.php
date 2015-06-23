<?php
// Décodage des lignes de log du Worker

//error_reporting(0);
error_reporting(E_ALL);

// Codes couleurs
$fond_vert = "\033[42m";
$texte_blanc = "\033[37m";
$texte_rouge = "\033[31m";
$texte_vert = "\033[32m";
$underline = "\033[4m";
$reset_color = "\033[0m";
$tab = "\t";
 
function isHTML( $string ) {
    return ( $string != strip_tags( $string ) );
}

function outputJSON( $tableau, $dec = "" ) {
    global $tab, $fond_vert, $texte_blanc, $texte_rouge, $texte_vert, $underline, $reset_color;
    $dec = $tab.$dec;
    foreach( $tableau as $key => $val ) {
        if ( gettype( $val ) !== "array" ) {
            switch($key) {
            case ("msg"):
            case ("content"):
                if ( $myjob = json_decode( $val, true ) ) {
                    // Message contenant du JSON
                    echo $tab.$texte_rouge.$key.":".$reset_color.PHP_EOL;
                    outputJSON( $myjob );
                } else {
                    // Message standard
                    if ( strlen( $val ) && substr_compare( $val, "------------ ", 0, 13 ) == 0 )
                        echo $tab.$texte_rouge.$key.":".$reset_color." ".substr( strip_tags($val), 13 ).PHP_EOL;
                    else
                        echo $tab.$texte_rouge.$key.":".$reset_color." ".strip_tags($val).PHP_EOL;
                }
                //print_r($job);
                break;
            case ("running"):
            case ("signaled"):
            case ("stopped") :
                echo $dec.$texte_rouge.$key.": ".$reset_color.($val?"true":"false").PHP_EOL;
                break;
            case ("watchpoint"):
            case ("tag"):
            case ("pid"):
                break;
            default:
                echo $dec.$texte_rouge.$key.": ".$reset_color.$val.PHP_EOL;
            }
        } else {
            switch($key) {
            case ("msg"):
            case ("headers"):
            case ("result"):
            case ("status"):
                if ( is_array( $val ) ) {
                    echo $dec.$texte_rouge.$key.": ".$reset_color.PHP_EOL;
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
                    echo $dec.$texte_rouge.$key.": ".$reset_color.$val.PHP_EOL;
                }
                break;
            default:
                echo $dec.$texte_rouge.$key.": ".$reset_color.$val.PHP_EOL;
            }
        }
    }
}

while($f = fgets(STDIN)){
    $pattern = '/^(\[[0-9 :-]+\]) ([^: ]+): \[([^\]]*)\] (.*) (\[.*\]).*(\[.*\]).*$/';
    if ( preg_match( $pattern, $f, $result ) ) {
        // Horodatage
	echo $fond_vert.$texte_blanc.$result[1].$reset_color.$tab.$texte_vert.$underline.$result[3].$reset_color.PHP_EOL;

        $msg = json_decode( $result[4], true );

        if ( $msg === null ) {
            // Pas du JSON alors on sort le message reformaté
            echo $tab."MSG: ".strip_tags($result[4]);

        } else {
            // On a du JSON, alors on décode
            outputJSON( $msg, "\t" );
        }
    } else {
        // La ligne ne correspond pas au format, on la sort normalement
        echo $f;
    } 
}

<?

  $cmd = "echo 'argv <- \"ex_2.r\"; source(argv);' | " .
#         "/usr/local/bin/R --vanilla --slave";
         "/home/special/chenwc/Html/R/bin/R --vanilla --slave";

  $handle = popen($cmd, "r");
  $ret = "";
  do{
    $data = fread($handle, 8192);
    if(strlen($data) == 0){
      break;
    }
    $ret .= $data;
  }
  while(true);
  pclose($handle);

  header("Content-type:image/png");
  echo $ret;

?>

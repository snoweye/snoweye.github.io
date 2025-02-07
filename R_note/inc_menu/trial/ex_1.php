<?

  $cmd = "echo 'argv <- \"ex_1.r\"; source(argv)' | " .
#         "/usr/local/bin/R --vanilla --slave";
         "/home/special/chenwc/Html/R/bin/R --vanilla --slave";
  $ret = system($cmd);
  echo $ret;

?>

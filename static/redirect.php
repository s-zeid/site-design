<?php

$request_uri = $_SERVER["REQUEST_URI"];
function redirect($to) {
 header("Location: $to");
}

$redirects_text = file_get_contents("_redirects");
$redirects_text = preg_replace('/\s+[-=]>\s+/', ' => ', $redirects_text);
$redirects_text = str_replace("\r", "\n", str_replace("\r\n", "\n", $redirects_text));
$redirect_lines = explode("\n", $redirects_text);

$redirects = array();
foreach ($redirect_lines as $line) {
 if (strpos($line, "#") !== 0) {
  $parts = explode(" => ", $line, 2);
  if (!empty($parts[0]) && !empty($parts[1]))
   $redirects[rtrim($parts[0], "/")] = $parts[1];
 }
}

foreach ($redirects as $old => $new) {
 if (strlen($old) >= 2 && substr($old, strlen($old) - 2) === "/*" &&
     (strpos($request_uri, substr($old, 0, strlen($old) - 1)) === 0 ||
      $request_uri == substr($old, 0, strlen($old) - 2))) {
  redirect(rtrim($new, "/") . substr($request_uri, strlen($old) - 2));
  exit();
 }
 if ($request_uri == $old ||
     $request_uri == $old."/") {
  redirect($new);
  exit();
 }
}

if ($request_uri != $_SERVER["SCRIPT_NAME"]) {
 header("HTTP/1.0 404 Not Found");
 if (file_exists("404.html"))
  readfile("404.html");
 else
  echo "<h1>404 Not Found</h1>";
} else {
 highlight_file(__FILE__);
 exit();
}

?>

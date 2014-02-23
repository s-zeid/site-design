<?php

$redirects = array(
 "/about" => "/",
 "/appbackup" => "/projects/appbackup/",
 "/calculators" => "/projects/",
 "/calculators/rain" => "/projects/rain/",
 "/feed" => "/blog/feed/",
 "/iphone" => "/projects/",
 "/iphone/appbackup" => "/projects/appbackup/",
 "/iphone/appdir" => "/projects/old/appdir/",
 "/iphone/cydia-repository" => "/other/cydia-repository/",
 "/iphone/itango" => "/projects/old/itango/",
 "/scripts" => "/projects/old/",
 "/scripts/deb-process" => "/projects/old/deb-process/",
 "/scripts/set-wallpapers-dualhead" => "/projects/old/set-wallpapers-dualhead/",
 "/blog/2011/08/address-already-in-use-error-when-openvpn-is-not-running"
  => "/blog/2011/08/31/address-already-in-use-error-when-openvpn-is-not-running/",
 "/blog/2011/08/openvpn-2-2-1-ipv6-payload-patch-for-cyanogenmod-7-1-rc1"
  => "/blog/2011/08/29/openvpn-2-2-1-ipv6-payload-patch-for-cyanogenmod-7-1-rc1/",
 "/blog/2011/07/google-plus-tango-icon"
  => "/blog/2011/07/16/google-plus-tango-icon/",
 "/blog/2011/05/appbackup-2-0-2-released"
  => "/blog/2011/05/31/appbackup-2-0-2-released/",
 "/blog/2011/05/appbackup-2-0-1-released"
  => "/blog/2011/05/27/appbackup-2-0-1-released/",
 "/blog/2011/05/appbackup-2-0-is-finally-finished"
  => "/blog/2011/05/26/appbackup-2-0-is-finally-finished/",
 "/blog/2011/05/appbackup-1-0-14-is-released"
  => "/blog/2011/05/05/appbackup-1-0-14-is-released/",
 "/blog/2011/04/eric-whitacres-virtual-choir-2-0-premiere-is-tomorrow"
  => "/blog/2011/04/06/eric-whitacres-virtual-choir-2-0-premiere-is-tomorrow/",
 "/blog/2011/03/forcing-dd-wrt-to-use-desired-dns-server"
  => "/blog/2011/03/16/forcing-dd-wrt-to-use-desired-dns-server/",
 "/blog/2011/01/appbackup-1-0-13-released"
  => "/blog/2011/01/13/appbackup-1-0-13-released/",
 "/blog/2011/01/welcome-to-my-new-site"
  => "/blog/2011/01/10/welcome-to-my-new-site/"
);

foreach ($redirects as $old => $new) {
 if ($_SERVER["REQUEST_URI"] == $old ||
     $_SERVER["REQUEST_URI"] == $old."/") {
  header("Location: $new");
  exit();
 }
}

if ($_SERVER["REQUEST_URI"] != $_SERVER["SCRIPT_NAME"]) {
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

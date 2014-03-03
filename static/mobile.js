/* Mobile fixes */

// Chrome on Android does not have the bug where non-bold navigation bar text is
// 1 pixel lower than bold text, so this adds a CSS class to the root element
// that disables the CSS rule that fixes that bug in other WebKit browsers.
if (navigator.userAgent.match(/Chrome/) && navigator.userAgent.match(/Android/))
 $("html").addClass("no-text-bug");

// Stop navigation when a tablet user touches a menu item with an associated
// dropdown, but allow navigation when the item is touched again while the
// menu is still open.
$(document).on("touchstart.open", "header nav li.has-children > a",
 function(touchE) {
  // * Menu items are `display: inline-block` when the screen width is less than
  //   480 pixels, and dropdowns are disabled in that case, so we allow navigation.
  // * Also allow navigation if the menu item is open.
  if ($(this).css("display") !== "inline-block" && !this.open) {
   this.open = true;   // Keep track of whether the menu's open
   // click is the event that triggers navigation, not touchstart.
   $(this).on("click.open", function(e) {
    e.preventDefault(); e.stopPropagation();
    $(this).off("click.open");
    // If the user touches outside the dropdown, the dropdown will close
    // automatically, but this lets us know that it's closed.
    $(document).on("click.close", function(d) {
     e.currentTarget.open = false;
     $(document).off("click.close");
    });
   });
  }
 }
);

#!/usr/bin/bash

# $ shift
# ^ control
# ~ alt/option
# @ command
# # numpad
# more http://superuser.com/questions/670584
# more http://osxnotes.net/keybindings.html

defaults write -g NSUserKeyEquivalents '{
  "Start Speaking" = "~@s";
}'

defaults write -app Terminal NSUserKeyEquivalents '{
  "Return to Default Size" = "@0";
}'
defaults write -app Safari NSUserKeyEquivalents '{
  "Disable Styles" = "^~@i";
  "Disable JavaScript" = "^~@o";
  "Show Next Tab" = "~@\Uf703";
  "Show Previous Tab" = "~@\Uf702";
  "Messages" = "~@p";
}'
defaults write -app 'Google Chrome' NSUserKeyEquivalents '{
  "Pin Tab" = "^~@p";
}'
defaults write -app Preview NSUserKeyEquivalents '{
  "Adjust Size…" = "~@i";
}'
defaults write -app Sketch NSUserKeyEquivalents '{
  "Top"    = "^@\Uf700";
  "Bottom" = "^@\Uf701";
  "Left"   = "^@\Uf702";
  "Right"  = "^@\Uf703";
  "Vertically"   = "^@[";
  "Horizontally" = "^@]";
  "Flatten Selection to Bitmap"   = "~@o";
  "Round to Nearest Pixel Edge"   = "^@r";
  "Collapse Artboards and Groups" = "^@c";
  "Mask with Selected Shape"      = "^$@m";
}'

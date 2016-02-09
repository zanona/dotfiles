# $ shift
# ^ control
# ~ alt/option
# @ command
# # numpad
# more http://superuser.com/questions/670584
# more http://osxnotes.net/keybindings.html

defaults write -app Safari NSUserKeyEquivalents '{
  "Disable Styles" = "^~@i";
  "Disable JavaScript" = "^~@o";
  "Show Next Tab" = "~@\Uf703";
  "Show Previous Tab" = "~@\Uf702";
  "Messages" = "~@s";
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

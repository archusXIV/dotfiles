#
# Defines keymap for sxhkd
#

# WM {{{

# Focus
super + {Up,down,Left,Right}
  { \
  i3-msg focus up, \
  i3-msg focus down, \
  i3-msg focus left || i3-msg focus output left, \
  i3-msg focus right || i3-msg focus output right \
  }

# Swap
super + shift + {Up,down,Left,Right}
  {\
  i3-msg move up, \
  i3-msg move down, \
  i3-msg move left, \
  i3-msg move right \
  }

## Actions on windows

# Toggle fullscreen/floating state
super + f
  i3-msg fullscreen

super + space
  i3-msg floating toggle

# Close/kill current window
super + {_,shift + }q
  {\
  xdo close, \
  i3-msg kill window \
  }

# Set splitting area
super + {v,h}
  i3-msg split{v,h}

# Cycle between windows
super + {_,shift + }n
  i3-msg focus{up,down}

## Actions on workspaces

# Cycle non-empty between workspaces and outputs
super + alt + {left,right}
  i3-msg {workspace,output} {prev,next}_on_output

# Cycle between all workspaces and outputs
super + shift + {_,ctrl + }w{left,right}
  i3-msg {workspace,output} {prev,next}

# Move workspace
super + y
  i3-msg move workspace to output up

# Move cursor
super + ctrl + m : {_,shift + ,shift + super + }{h,j,k,l}
  m={20,100,200} {x=-1 y=0,x=0 y=1,x=0 y=-1,x=1 y=0}; \
  xdotool mousemove_relative -- $(( m*x )) $(( m*y ))

# Move cursor to monitor corners
super + ctrl + m : super + {h,j,k,l}
  xdotool mousemove {$x $y,$x $dy,$dx $y,$dx $dy}

# Simulate mouse button click
super + ctrl + m : {_,shift + ,ctrl + }space
  xdotool click {1,3,2}

# vim:ft=sxhkdrc

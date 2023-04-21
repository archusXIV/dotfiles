[**@x70b1**](https://github.com/x70b1) has started to maintain a repository for scripts contributed by the community: [polybar-scripts](https://github.com/polybar/polybar-scripts).

This means that everything written in Shell, Python or Perl is collected there. Look over there!

See also [Awesome Polybar](https://github.com/TiagoDanin/Awesome-Polybar) for further links to cool scripts.


## Other languages

### workspaces-xmonad (Haskell)

This plugin contains two modules, one for displaying workspaces and one for displaying title of current window.
The communication between XMonad and polybar is done by named pipes to achieve speed and memory efficiency.
You may adjust `eventLogHook` according to your preferences.


```ini
[module/workspaces-xmonad]
type = custom/script
exec = tail -F /tmp/.xmonad-workspace-log
exec-if = [ -p /tmp/.xmonad-workspace-log ]
tail = true
```

```ini
[module/title-xmonad]
type = custom/script
exec = tail -F /tmp/.xmonad-title-log
exec-if = [ -p /tmp/.xmonad-title-log ]
tail = true
```

```haskell
import Data.List (sortBy)
import Data.Function (on)
import Control.Monad (forM_, join)
import XMonad.Util.Run (safeSpawn)
import XMonad.Util.NamedWindows (getName)
import qualified XMonad.StackSet as W

main = do
  forM_ [".xmonad-workspace-log", ".xmonad-title-log"] $ \file -> do
    safeSpawn "mkfifo" ["/tmp/" ++ file]

  let myConf = def
        { ...
        , logHook         = eventLogHook
        , ...
        }

eventLogHook = do
  winset <- gets windowset
  title <- maybe (return "") (fmap show . getName) . W.peek $ winset
  let currWs = W.currentTag winset
  let wss = map W.tag $ W.workspaces winset
  let wsStr = join $ map (fmt currWs) $ sort' wss

  io $ appendFile "/tmp/.xmonad-title-log" (title ++ "\n")
  io $ appendFile "/tmp/.xmonad-workspace-log" (wsStr ++ "\n")

  where fmt currWs ws
          | currWs == ws = "[" ++ ws ++ "]"
          | otherwise    = " " ++ ws ++ " "
        sort' = sortBy (compare `on` (!! 0))
```

Another approach for XMonad users is that want to use polybar as panel is to use a dbus aproach. One of the ways of doing that is using a wrapper program and dumping XMonad's info into the session bus just like in [xmonad-log](https://github.com/xintron/xmonad-log). It should be noted that dbus should be started at session or user level.

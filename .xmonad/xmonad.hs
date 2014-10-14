import XMonad
import qualified Data.Map as M
import XMonad.Hooks.DynamicLog
import Graphics.X11.ExtraTypes.XF86
import XMonad.Util.EZConfig
import XMonad.Actions.CycleWS
import XMonad.Layout.Fullscreen
import XMonad.Layout.ResizableTile
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as W
import XMonad.Actions.SpawnOn
import XMonad.Util.Themes
import XMonad.Layout.SubLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowNavigation
import XMonad.Layout.BoringWindows
import XMonad.Layout.Simplest

main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

myBar = "xmobar"

myPP = xmobarPP {ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

myConfig = defaultConfig
    { terminal        = myTerminal,
      modMask         = myModMask,
      borderWidth     = myBorderWidth,
      logHook         = dynamicLogWithPP myPP,
      handleEventHook = myHandleEventHook,
      manageHook      = myManageHook,
      layoutHook      = myLayouts,
      workspaces      = myWorkspaces,
      startupHook     = myStartupHook,
      keys            = newKeys
    }
    `additionalKeysP`
    [("<XF86MonBrightnessUp>", spawn "xbacklight +20")
    ,("<XF86MonBrightnessDown>", spawn "xbacklight -20")
    ,("<XF86AudioRaiseVolume>", spawn "amixer -c0 set Master 5+ unmute")
    ,("<XF86AudioLowerVolume>", spawn "amixer -c0 set Master 5- unmute")
    ,("<XF86AudioMute>", spawn "amixer -c0 set Master toggle")
    ]

myTerminal        = "urxvt"
myModMask         = mod4Mask
myBorderWidth     = 3
myHandleEventHook = fullscreenEventHook
myManageHook      = fullscreenManageHook <+> manageDocks <+> ( isFullscreen --> doFullFloat ) <+>  manageHook defaultConfig
myLayouts         = enableTabs $fullscreenFull $ windowNavigation $ boringWindows $ smartBorders . avoidStruts $ (tiled ||| Mirror (tiled) ||| Full)
                     where
                       tiled = ResizableTall 1 (3/100) (1/2) []
                       enableTabs x = addTabs shrinkText myTabTheme $ subLayout [] Simplest x
myTabTheme = (theme wfarrTheme)
    { activeColor         = "#4c4c4c"
    }
myStartupHook     :: X ()
myStartupHook     = do spawnOn "1:www" "chromium"
myWorkspaces      = ["www", "irc", "VMs", "4", "5", "6", "7", "8", "9"]
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
           [ ((modMask,               xK_a), sendMessage MirrorExpand)
           , ((modMask,               xK_z), sendMessage MirrorShrink)
           , ((modMask .|. controlMask, xK_h), sendMessage $ pullGroup L)
           , ((modMask .|. controlMask, xK_l), sendMessage $ pullGroup R)
           , ((modMask .|. controlMask, xK_k), sendMessage $ pullGroup U)
           , ((modMask .|. controlMask, xK_j), sendMessage $ pullGroup D)
           , ((modMask .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
           , ((modMask .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))
           , ((modMask .|. controlMask, xK_period), onGroup W.focusUp')
           , ((modMask .|. controlMask, xK_comma), onGroup W.focusDown')
           , ((modMask, xK_j), focusDown)
           , ((modMask, xK_k), focusUp)
           ]
newKeys x = myKeys x `M.union` keys defaultConfig x


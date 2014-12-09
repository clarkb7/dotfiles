-- XMonad imports
import XMonad
import XMonad.Prompt
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import Graphics.X11.ExtraTypes.XF86
import XMonad.Util.EZConfig
import XMonad.Util.Themes
import XMonad.Actions.CycleWS
import XMonad.Actions.SpawnOn
import XMonad.Actions.WorkspaceNames
import XMonad.Actions.DynamicWorkspaces as DW
-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
-- Layouts
import XMonad.Layout.Fullscreen
import XMonad.Layout.ResizableTile
import XMonad.Layout.NoBorders
import XMonad.Layout.SubLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowNavigation
import XMonad.Layout.BoringWindows
import XMonad.Layout.Simplest
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.WorkspaceDir

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
myManageHook      = composeAll [ className =? "feh" --> doCenterFloat ] <+>
                    fullscreenManageHook <+> manageDocks <+> ( isFullscreen --> doFullFloat ) <+>
                    manageHook defaultConfig
myLayouts         = mkToggle (NOBORDERS ?? EOT) $ enableTabs $ fullscreenFull $
                    windowNavigation $ boringWindows $ smartBorders . avoidStruts $
                    workspaceDir "~" (tiled ||| Mirror (tiled) ||| Full)
                     where
                       tiled = ResizableTall 1 (3/100) (1/2) []
                       enableTabs x = addTabs shrinkText myTabTheme $ subLayout [] Simplest x
myTabTheme = (theme wfarrTheme)
    { activeColor         = "#4c4c4c"
    }
myWorkspaces      = ["www", "irc", "VMs", "4", "5", "6", "7", "8", "9"]
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
           [
           -- Resizable Tiles
             ((modMask,               xK_a), sendMessage MirrorExpand)
           , ((modMask,               xK_z), sendMessage MirrorShrink)
           -- Tabbed tiles
           , ((modMask .|. controlMask, xK_h), sendMessage $ pullGroup L)
           , ((modMask .|. controlMask, xK_l), sendMessage $ pullGroup R)
           , ((modMask .|. controlMask, xK_k), sendMessage $ pullGroup U)
           , ((modMask .|. controlMask, xK_j), sendMessage $ pullGroup D)
           , ((modMask .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
           , ((modMask .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))
           , ((modMask .|. controlMask, xK_comma), onGroup W.focusUp')
           , ((modMask .|. controlMask, xK_period), onGroup W.focusDown')
           , ((modMask, xK_j), focusDown)
           , ((modMask, xK_k), focusUp)
           -- Workspace controls
           , ((modMask .|. controlMask, xK_r), DW.renameWorkspace defaultXPConfig)
           , ((modMask .|. controlMask, xK_c), DW.addWorkspacePrompt defaultXPConfig)
           , ((modMask .|. controlMask, xK_x), DW.removeWorkspace)
           , ((modMask .|. controlMask, xK_p), swapTo Prev)
           , ((modMask .|. controlMask, xK_n), swapTo Next)
           , ((modMask .|. shiftMask, xK_b), sendMessage $ Toggle NOBORDERS)
           , ((modMask .|. controlMask, xK_w), changeDir defaultXPConfig)
           -- Shortcuts
           , ((modMask .|. shiftMask, xK_h),
              spawn "feh --scale ~/Pictures/KB_United_States_Dvorak.svg.png")
           , ((modMask .|. shiftMask, xK_slash),
              spawn "feh -B white --scale ~/Pictures/Xmbindings.png")
           , ((modMask .|. shiftMask, xK_l), spawn "xscreensaver-command --lock")
           ]
newKeys x = myKeys x `M.union` keys defaultConfig x

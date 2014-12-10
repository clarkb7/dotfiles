-- XMonad imports
import XMonad
import XMonad.Prompt
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Util.Themes
import XMonad.Util.WorkspaceCompare
import XMonad.Util.Run
import XMonad.Actions.CycleWS
import XMonad.Actions.WorkspaceNames as WN
import XMonad.Actions.DynamicWorkspaces as DW
import XMonad.Actions.CycleWS
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
-- Utilities
import qualified Data.Map as M
import Graphics.X11.ExtraTypes.XF86
import Data.Monoid
import Data.Function

main = do
    myStatusBar <- spawnPipe "xmobar ~/.xmobarrc"
    let oPP = myPP { ppOutput = hPutStrLn myStatusBar }
    xmonad $ myConfig { logHook = workspaceNamesPP oPP >>= dynamicLogWithPP}

myPP = xmobarPP {ppCurrent = xmobarColor "#429942" "", ppVisible = wrap "<" ">",
                 ppSort =  mkWsSort getWsCompareLast}

myConfig = defaultConfig
    { terminal        = myTerminal,
      modMask         = myModMask,
      borderWidth     = myBorderWidth,
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
myWorkspaces      = map show [1..9]
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
           , ((modMask .|. controlMask, xK_r), WN.renameWorkspace defaultXPConfig)
           , ((modMask .|. controlMask, xK_c), DW.addWorkspacePrompt defaultXPConfig)
           , ((modMask .|. controlMask, xK_x), DW.removeWorkspace)
           , ((modMask .|. controlMask, xK_p), prevWS)
           , ((modMask .|. controlMask, xK_n), nextWS)
           , ((modMask .|. shiftMask .|. controlMask, xK_p), swapTo Prev)
           , ((modMask .|. shiftMask .|. controlMask, xK_n), swapTo Next)
           , ((modMask .|. shiftMask, xK_b), sendMessage $ Toggle NOBORDERS)
           , ((modMask .|. controlMask, xK_w), changeDir defaultXPConfig)
           -- Shortcuts
           , ((modMask .|. shiftMask, xK_h),
              spawn "feh --scale ~/Pictures/KB_United_States_Dvorak.svg.png")
           , ((modMask .|. shiftMask, xK_slash),
              spawn "feh -B white --scale ~/Pictures/Xmbindings.png")
           , ((modMask .|. shiftMask, xK_l), spawn "xscreensaver-command --lock")
           , ((modMask, xK_b), sendMessage ToggleStruts)
           ]
newKeys x = myKeys x `M.union` keys defaultConfig x

-- Custom functions and utils
----
-- http://marc.info/?l=xmonad&m=134139011504682
-- | Compare Maybe's differently, so Nothing (i.e. workspaces without indexes)
--   come last in the order
indexCompare :: Maybe Int -> Maybe Int -> Ordering
indexCompare Nothing Nothing = EQ
indexCompare Nothing (Just _) = GT
indexCompare (Just _) Nothing = LT
indexCompare a b = compare a b

-- | A comparison function for WorkspaceId, based on the index of the
--   tags in the user's config.
getWsCompareLast :: X WorkspaceCompare
getWsCompareLast = do
    wsIndex <- getWsIndex
    return $ mconcat [indexCompare `on` wsIndex, compare]
----

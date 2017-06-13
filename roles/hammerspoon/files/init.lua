-- adapted from various hammerspoon configs including cmsj, asmagill, trishume, zzamboni, etc.

hs.shutdownCallback = function()  hs.settings.set('history', hs.console.getHistory()) end
hs.console.setHistory(hs.settings.get('history'))

-- load a more minimal config if running from xcode
if hs.processInfo.bundlePath:match("/Users/tansy/Library/Developer/Xcode/DerivedData/") then
  require "xcodebuild"
  return
end

-- initial setup
hyper = {'cmd', 'alt', 'ctrl'}

hs.window.animationDuration = 0
hs.hotkey.setLogLevel("warning") --suppress excessive keybind printing in console
hs.window.filter.setLogLevel("error")
i = hs.inspect -- shortcut for inspecting tables
clear = hs.console.clearConsole

require "spotify"
require "utils"
require "window"
require "imgur"
require "pasteboard"
icons = require "asciicons"
amphetamine = require "amphetamine"
require "redshift"

hs.hotkey.bind(hyper, "h", hs.toggleConsole) -- toggle hammerspoon console
hs.hotkey.bind(hyper, '.', hs.hints.windowHints) -- show window hints
hs.ipc.cliInstall()

-- for playing with ASCIImage, etc
function imagePreview(image, size)
  size = size or 100
  local pos = hs.mouse.getAbsolutePosition()
  local imageRect = hs.drawing.image(hs.geometry(pos, {w = size, h = size}), image):show()
  imageRectTimer = hs.timer.doAfter(3, function() imageRect:delete() end)
end

ip = imagePreview

-- bind application hotkeys
hs.fnutils.each({
    { key = "t", app = "Spotify" },
    { key = "i", app = "iTerm" },
    { key = "s", app = "Sublime Text" },
    { key = "j", app = "IntelliJ IDEA CE" },
    { key = "e", app = "Slack" },
    { key = "c", app = "Google Chrome" },
  }, function(item)

    local appActivation = function()
      hs.application.launchOrFocus(item.app)

      local app = hs.appfinder.appFromName(item.app)
      if app then
        app:activate()
        app:unhide()
      end
    end

    hs.hotkey.bind(hyper, item.key, appActivation)
  end)

-- open config dir for editing
hs.hotkey.bind(hyper, ",", function()
    hs.urlevent.openURLWithBundle("file://"..hs.configdir, "com.sublimetext.3")
  end)

-- auto reload config
configFileWatcher = hs.pathwatcher.new(hs.configdir, hs.reload):start()
hs.alert.show("Config loaded 👍")

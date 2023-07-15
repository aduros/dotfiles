local editor = require("editor")
local modes = require("modes")
local settings = require("settings")
local webview = require("webview")
local select = require("select")
local follow = require("follow")

settings.window.search_engines = {
    default = "https://startpage.com/sp/search?query=%s",
    ddg = "https://duckduckgo.com/?q=%s",
    wp = "https://en.wikipedia.org/wiki/Special:Search?search=%s",
    gh = "https://github.com/search?q=%s",
    yt = "https://www.youtube.com/results?search_query=%s",
    mdn = "https://developer.mozilla.org/en-US/search?q=%s",
    aw = "https://wiki.archlinux.org/index.php?search=%s",
    tw = "https://twitter.com/search?q=%s",
    -- gs = "https://google.com/search?q=%s",
    -- imdb = "http://www.imdb.com/find?s=all&q=%s",
}

editor.editor_cmd = "i3-tabbed x-terminal-emulator -e nvim {file} +{line}"

local redirects = {
    { "^https://www.reddit.com/", "https://libreddit.silkky.cloud/" },
    -- { "^https://www.youtube.com/", "https://piped.silkky.cloud/" },
    { "^https://www.youtube.com/", "https://yewtu.be/" },
    { "^https://twitter.com/", "https://nitter.silkky.cloud/" },

    -- Spammy scraper sites
    { "^https://awesomeopensource.com/project/", "https://github.com/" },
    { "^https://githubmemory.com/repo/", "https://github.com/" },
}

webview.add_signal("init", function (view)
    view:add_signal("navigation-request", function (view, uri)
        for k, v in pairs(redirects) do
            local new_uri, match = uri:gsub(v[1], v[2])
            if match == 1 then
                view.uri = new_uri
                break
            end
        end
    end)
end)

-- Use home row hint labels
select.label_maker = function ()
    return trim(sort(reverse(charset("aoeuidhtns"))))
end

-- Match hint labels, not element text
follow.pattern_maker = follow.pattern_styles.match_label

modes.remap_binds("normal", {
    { "l", "n", true},
    { "L", "N", true},
    { "<control-o>", "O", true },
    { "O", "t", true},

    { ".", "gT", true },
    { "p", "gt", true },
    { "<shift-p>", ">", true },
    { ">", "<", true },

    { "y", "Y", true },
    { "gp", "PP", true }, -- next tab
    -- { "gw", ":tabdetach" }, -- next tab
})

local scroll = 40

modes.add_binds("normal", {
    { "h", "Go back in the browser history.", function (w, m) w:back(m.count) end },
    { "s", "Go forward in the browser history.", function (w, m) w:forward(m.count) end },

    { "t", "Scroll down.", function (w, m) w:scroll{ yrel = scroll * (m.count or 1) } end },
    { "n", "Scroll up.", function (w, m) w:scroll{ yrel = -scroll * (m.count or 1) } end },
    { "<shift-t>", "Scroll DOWN.", function (w, m) w:scroll{ yrel = 10 * scroll * (m.count or 1) } end },
    { "<shift-n>", "Scroll UP.", function (w, m) w:scroll{ yrel = -10 * scroll * (m.count or 1) } end },

    { ";", "Enter `command` mode.", function (w) w:set_mode("command") end },

    { "D", "Close current tab (or `[count]` tabs).", function (w, m)
        for _=1,m.count do w:close_tab() end
        w:prev_tab()
    end, {count=1} },
})

modes.add_binds("completion", {
    { "<control-t>", function (w) w.menu:move_down() end },
    { "<control-n>", function (w) w.menu:move_up() end },
})

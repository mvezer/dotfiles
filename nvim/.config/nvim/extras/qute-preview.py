# qutebrowser profile for live-preview.nvim (see after/plugin/live-preview.lua)
config.load_autoconfig(False)

c.tabs.show = "never"
c.statusbar.show = "in-mode"
c.window.title_format = "preview: {current_title}"
c.colors.webpage.preferred_color_scheme = "dark"
c.content.notifications.enabled = False
c.auto_save.session = False
c.session.lazy_restore = False

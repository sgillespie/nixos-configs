require("config.neovide")
require("config.font")
require("config.options")
require("config.lazy")

vim.cmd(":call serverstart('/tmp/nvimsocket')")

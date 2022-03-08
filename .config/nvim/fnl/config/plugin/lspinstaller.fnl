(module config.plugin.lspinstaller
  {autoload {lsp-inst nvim-lsp-installer}})

(lsp-inst.settings {:ui {:icons {:server_installed   "✓"
                                 :server_pending     "➜"
                                 :server_uninstalled "✗"}}})

(module config.plugin.lspconfig
  {autoload {nvim aniseed.nvim
             lsp lspconfig
             cmplsp cmp_nvim_lsp}})

;symbols to show for lsp diagnostics
(defn define-signs
  [prefix]
  (let [error (.. prefix "SignError")
        warn  (.. prefix "SignWarn")
        info  (.. prefix "SignInfo")
        hint  (.. prefix "SignHint")]
  (vim.fn.sign_define error {:text "x" :texthl error})
  (vim.fn.sign_define warn  {:text "!" :texthl warn})
  (vim.fn.sign_define info  {:text "i" :texthl info})
  (vim.fn.sign_define hint  {:text "?" :texthl hint})))

(if (= (nvim.fn.has "nvim-0.6") 1)
  (define-signs "Diagnostic")
  (define-signs "LspDiagnostics"))

;server features
(let [handlers {"textDocument/publishDiagnostics"
                (vim.lsp.with
                  vim.lsp.diagnostic.on_publish_diagnostics
                  {:severity_sort true
                   :update_in_insert false
                   :underline true
                   :virtual_text false})
                "textDocument/hover"
                (vim.lsp.with
                  vim.lsp.handlers.hover
                  {:border "single"})
                "textDocument/signatureHelp"
                (vim.lsp.with
                  vim.lsp.handlers.signature_help
                  {:border "single"})}
      capabilities (cmplsp.update_capabilities (vim.lsp.protocol.make_client_capabilities))
      on_attach    (fn [client bufnr]
                     (do
                       (nvim.buf_set_keymap bufnr :n :gd "<Cmd>lua vim.lsp.buf.definition()<CR>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :n :K "<Cmd>lua vim.lsp.buf.hover()<CR>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :n :<leader>ld "<Cmd>lua vim.lsp.buf.declaration()<CR>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :n :<leader>lt "<cmd>lua vim.lsp.buf.type_definition()<CR>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :n :<leader>lh "<cmd>lua vim.lsp.buf.signature_help()<CR>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :n :<leader>ln "<cmd>lua vim.lsp.buf.rename()<CR>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :n :<leader>le "<cmd>lua vim.diagnostic.open_float()<CR>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :n :<leader>lq "<cmd>lua vim.diagnostic.setloclist()<CR>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :n :<leader>lf "<cmd>lua vim.lsp.buf.formatting()<CR>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :n :<leader>lj "<cmd>lua vim.diagnostic.goto_next()<CR>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :n :<leader>lk "<cmd>lua vim.diagnostic.goto_prev()<CR>" {:noremap true})

                       (nvim.buf_set_keymap bufnr :n :crcc "<cmd>lua vim.lsp.buf.execute_command({command = 'cycle-coll', arguments = {'file://' ..vim.fn.expand('%:p'), vim.fn.line('.') - 1, vim.fn.col('.') - 1}})<CR>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :n :crth "<cmd>lua vim.lsp.buf.execute_command({command = 'thread-first', arguments = {'file://' ..vim.fn.expand('%:p'), vim.fn.line('.') - 1, vim.fn.col('.') - 1}})<CR>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :n :crtt "<cmd>lua vim.lsp.buf.execute_command({command = 'thread-last', arguments = {'file://' ..vim.fn.expand('%:p'), vim.fn.line('.') - 1, vim.fn.col('.') - 1}})<CR>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :n :crtf "<cmd>lua vim.lsp.buf.execute_command({command = 'thread-first-all', arguments = {'file://' ..vim.fn.expand('%:p'), vim.fn.line('.') - 1, vim.fn.col('.') - 1}})<CR>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :n :crtl "<cmd>lua vim.lsp.buf.execute_command({command = 'thread-last-all', arguments = {'file://' ..vim.fn.expand('%:p'), vim.fn.line('.') - 1, vim.fn.col('.') - 1}})<CR>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :n :cruw "<cmd>lua vim.lsp.buf.execute_command({command = 'unwind-thread', arguments = {'file://' ..vim.fn.expand('%:p'), vim.fn.line('.') - 1, vim.fn.col('.') - 1}})<CR>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :n :crua "<cmd>lua vim.lsp.buf.execute_command({command = 'unwind-all', arguments = {'file://' ..vim.fn.expand('%:p'), vim.fn.line('.') - 1, vim.fn.col('.') - 1}})<CR>" {:noremap true})
                       ;telescope
                       (nvim.buf_set_keymap bufnr :n :<leader>la ":lua require('telescope.builtin').lsp_code_actions(require('telescope.themes').get_cursor())<cr>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :v :<leader>la ":'<,'>:Telescope lsp_range_code_actions theme=cursor<cr>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :n :<leader>lw ":lua require('telescope.builtin').lsp_workspace_diagnostics()<cr>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :n :gr ":lua require('telescope.builtin').lsp_references()<cr>" {:noremap true})
                       (nvim.buf_set_keymap bufnr :n :<leader>li ":lua require('telescope.builtin').lsp_implementations()<cr>" {:noremap true})))]

  ; nnoremap <silent> crcc :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'cycle-coll', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
  ; nnoremap <silent> crth :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-first', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
  ; nnoremap <silent> crtt :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-last', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
  ; nnoremap <silent> crtf :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-first-all', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
  ; nnoremap <silent> crtl :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'thread-last-all', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
  ; nnoremap <silent> cruw :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'unwind-thread', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
  ; nnoremap <silent> crua :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'unwind-all', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
  ; nnoremap <silent> crml :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'move-to-let', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1, input('Binding name: ')]})<CR>
  ; nnoremap <silent> cril :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'introduce-let', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1, input('Binding name: ')]})<CR>
  ; nnoremap <silent> crel :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'expand-let', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
  ; nnoremap <silent> cram :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'add-missing-libspec', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
  ; nnoremap <silent> crcn :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'clean-ns', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
  ; nnoremap <silent> crcp :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'cycle-privacy', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
  ; nnoremap <silent> cris :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'inline-symbol', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>
  ; nnoremap <silent> cref :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'extract-function', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1, input('Function name: ')]})<CR>

  ;; Clojure
  (lsp.clojure_lsp.setup {:on_attach on_attach
                          :handlers handlers
                          :capabilities capabilities})

  ;; Vue volar 
  (lsp.volar.setup {:filetypes    ["typescript" "javascript" "javascriptreact" "typescriptreact" "vue" "json"]
                    :capabilities capabilities
                    :on_attach    on_attach
                    :handlers     handlers})

  (lsp.bashls.setup {})
  
  (lsp.cssmodules_ls.setup {})

  (lsp.tsserver.setup {})

  (lsp.bashls.setup {})

  (lsp.dockerls.setup {})
  
  (lsp.tailwindcss.setup {})
  
  (lsp.emmet_ls.setup {})
  
  (lsp.html.setup {:capabilities (set capabilities.textDocument.completion.completionItem.snippetSupport true)}))

(module config.init
  {autoload {core aniseed.core
             nvim aniseed.nvim
             util config.util
             str aniseed.string}
   require-macros [config.macros]})

;generic mapping leaders configuration
(nvim.set_keymap :n :<space> :<nop> {:noremap true})
(set nvim.g.mapleader " ")
(set nvim.g.maplocalleader ",")

;; Spacemacs style leader mappings.
(nvim.set_keymap :n :<leader>wm ":tab sp<cr>" {:noremap true})
;; new buffer
(nvim.set_keymap :n :<leader>bn ":bn" {:noremap true})
(nvim.set_keymap :n :<leader>ba ":saveas" {:noremap true})

; Toggle file explorer
(nvim.set_keymap :n :<leader>n ":NvimTreeToggle<CR>" {:noremap true})
(nvim.set_keymap :n :<leader>tr ":NvimTreeRefresh<CR>" {:noremap true})

; Shortcutting split navigation, saving a keypress:
(nvim.set_keymap :n :<C-h> "<C-w><C-h>" {:noremap false})
(nvim.set_keymap :n :<C-j> "<C-w><C-j>" {:noremap false})
(nvim.set_keymap :n :<C-k> "<C-w><C-k>" {:noremap false})
(nvim.set_keymap :n :<C-l> "<C-w><C-l>" {:noremap false})

; Terminal normal mode on Esc
(nvim.set_keymap :t :<Esc><Esc> :<C-\><C-n> {:noremap false})

; Replace all is aliased to S.
(nvim.set_keymap :n :S ":%s//g<Left><Left>" {:noremap true})

; Save file as sudo on files that require root permission
(nvim.set_keymap :c :w!! "execute 'silent! write !sudo tee % >/dev/null' <bar> edit!" {:noremap true})

; don't wrap lines
(nvim.ex.set :nowrap)

; file explorer window size
(set nvim.g.netrw_winsize 25)

(set nvim.g.nvim_tree_indent_markers 1)
(set nvim.g.nvim_tree_highlight_opened_files 1)
(set nvim.g.nvim_tree_special_files {"README.md" 0
                                     "Makefile"  0
                                     "MAKEFILE"  0})

(augroup yank-highlight
         (nvim.ex.autocmd :TextYankPost "*" :silent! "lua vim.highlight.on_yank()"))

(when (= (nvim.fn.has "wsl") 1)
  ; WSL system clipboard integration.
  ; Uses this helper: https://github.com/equalsraf/win32yank/releases
  (set nvim.g.clipboard {"name" "win32yank"
                         "copy" {"+" "win32yank -i --crlf"
                                 "*" "win32yank -i --crlf"}
                         "paste" {"+" "win32yank -o --lf"
                                  "*" "win32yank -o --lf"}
                         "cache_enabled" 1}))

(augroup indent
         (nvim.ex.autocmd "BufNewFile,BufRead"
                          "*.html,*.js,*.json,*.tf,*.tfvars,*.vue,*.scss,*.css"
                          :setlocal "shiftwidth=2")
         (nvim.ex.autocmd :BufWritePre :* :%s/\s\+$//e))

(augroup save
         (nvim.ex.autocmd :FocusLost :* "silent!" :wa)
         (nvim.ex.autocmd :BufReadPost :* "if line(\"'\"\") > 1 && line(\"'\"\") <= line(\"$\") | exe \"normal! g'\"\" | endif"))

; au FocusLost * silent! wa " save on blur

; au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif " save file position

;sets nvim global options
(let [options
      {;settings needed for compe autocompletion
       :completeopt "menuone,noselect"
       ;case insensitive search
       :ignorecase true
       ;smart search case
       :smartcase true
       ;shared clipboard with linux
       :clipboard "unnamedplus"
       ; Reload unedited, externally changed files.
       :autoread true
       ; expand tabs into spaces
       :expandtab true
       :shiftwidth 4
       :tabstop 4
       :number true
       :relativenumber true
       :history 10000
       ; highlight search results
       :incsearch true
       :jumpoptions "stack"
       :mouse "a"
       :scrolloff 8
       :shell "zsh"
       :signcolumn "yes"
       :smartindent true
       :smarttab true
       :splitbelow true
       ; :colorscheme "doom-one"
       :splitright true}]
  (each [option value (pairs options)]
    (core.assoc nvim.o option value)))

;import plugin.fnl
(require :config.plugin)

(module config.plugin
  {autoload {nvim aniseed.nvim
             a aniseed.core
             util config.util
             packer packer}})

(defn- safe-require-plugin-config [name]
  (let [(ok? val-or-err) (pcall require (.. :config.plugin. name))]
    (when (not ok?)
      (print (.. "config error: " val-or-err)))))

(defn- use [...]
  "Iterates through the arguments as pairs and calls packer's use function for
  each of them. Works around Fennel not liking mixed associative and sequential
  tables as well."
  (let [pkgs [...]]
    (packer.startup
      (fn [use]
        (for [i 1 (a.count pkgs) 2]
          (let [name (. pkgs i)
                opts (. pkgs (+ i 1))]
            (-?> (. opts :mod) (safe-require-plugin-config))
            (use (a.assoc opts 1 name)))))))
  nil)

;;; plugins managed by packer
;;; :mod specifies namespace under plugin directory

(use
  ;; plugin Manager
  :wbthomason/packer.nvim {}
  ;; nvim config and plugins in Fennel
  :Olical/aniseed {:branch :develop}

  ;; theme
  ;:projekt0n/github-nvim-theme {:mod :theme}
  ; :NTBBloodbath/doom-one.nvim {:mod :theme}
  :folke/tokyonight.nvim {:mod :theme}
  :kyazdani42/nvim-web-devicons {}
  ;:romgrk/doom-one.vim {:mod :theme}
  ;:folke/tokyonight.nvim {}

  ;; status line
  :nvim-lualine/lualine.nvim {:requires [:kyazdani42/nvim-web-devicons]
                              :mod      :lualine}

  ;; file searching
  :nvim-telescope/telescope.nvim {:requires [:nvim-telescope/telescope-ui-select.nvim
                                             :nvim-lua/popup.nvim
                                             :nvim-lua/plenary.nvim]
                                  :mod      :telescope}

  ;; file explorer 
  :kyazdani42/nvim-tree.lua {:requires [:kyazdani42/nvim-web-devicons]
                             :mod      :filetree}

  ;; repl tools
  :Olical/conjure {:branch :master :mod :conjure}

  ;; sexp
  :guns/vim-sexp {:mod :sexp}
  :tpope/vim-sexp-mappings-for-regular-people {}
  :tpope/vim-surround {}
  :tpope/vim-repeat {}

  :tpope/vim-fugitive {}
  :tpope/vim-commentary {}
  :tpope/vim-rhubarb {}
  :andymass/vim-matchup {}

  :TimUntersberger/neogit {:requires [:nvim-lua/plenary.nvim]}

  :jiangmiao/auto-pairs {}
  :luochen1990/rainbow {}
  :yuttie/comfortable-motion.vim {}
  :haya14busa/incsearch.vim {}

  :folke/zen-mode.nvim {:requires [:folke/twilight.nvim]}

  ;; parsing system
  :nvim-treesitter/nvim-treesitter {:requires [:JoosepAlviste/nvim-ts-context-commentstring
                                               :windwp/nvim-ts-autotag
                                               :nvim-treesitter/nvim-treesitter-refactor]
                                    :run ":TSUpdate"
                                    :mod :treesitter}

  ;; lsp
  :neovim/nvim-lspconfig {:mod :lspconfig}

  ; snippets
  :L3MON4D3/LuaSnip {:requires [:saadparwaiz1/cmp_luasnip]}

  ;; autocomplete
  :hrsh7th/nvim-cmp {:requires [:hrsh7th/cmp-buffer
                                :hrsh7th/cmp-nvim-lsp
                                :hrsh7th/cmp-vsnip
                                :PaterJason/cmp-conjure]
                     :mod :cmp})

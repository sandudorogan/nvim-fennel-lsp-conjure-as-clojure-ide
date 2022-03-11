(module config.plugin.treesitter
  {autoload {treesitter nvim-treesitter.configs}})

(treesitter.setup {:highlight {:enable true}
                   :autotag   {:enable true}
                   :indent    {:enable true}
                   :ensure_installed ["clojure" "html" "http" "vue" "vim"
                                      "javascript" "typescript" "tsx" "scss" "python"
                                      "comment" "css" "dockerfile" "bash" "fennel"
                                      "json" "make" "markdown"]})

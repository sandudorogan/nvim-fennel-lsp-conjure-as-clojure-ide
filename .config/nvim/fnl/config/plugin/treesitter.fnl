(module config.plugin.treesitter
  {autoload {treesitter nvim-treesitter.configs}})

(treesitter.setup {:highlight {:enable true}
                   :refactor {:highlight_definitions {:enable true}
                              :highlight_current_scope {:enable true}
                              :smart_rename {:enable true
                                             :keymaps {:smart_rename "grr"}}
                              :navigation {:enable true
                                           :keymaps {:goto_definition  "gnd"
                                                     :list_definitions "gnD"
                                                     :list_definitions_toc "gO"
                                                     :goto_next_usage "<a-*>"
                                                     :goto_previous_usage "<a-#>"}}}
                   :matchup   {:enable true}
                   :autotag   {:enable true}
                   :indent    {:enable true}
                   :context_commentstring {:enable true}
                   :ensure_installed ["clojure" "html" "http" "vue" "vim"
                                      "javascript" "typescript" "tsx" "scss" "python"
                                      "comment" "css" "dockerfile" "bash" "fennel"
                                      "json" "make" "markdown"]})

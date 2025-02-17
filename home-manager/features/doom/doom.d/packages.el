(package! direnv)
(package! envrc)
(package! eglot)
(package! protobuf-mode
  :recipe (:host github :repo "protocolbuffers/protobuf"
           :files ("editors/protobuf-mode.el")))
(package! alert)
(package! prisma-mode :recipe (:host github :repo "pimeys/emacs-prisma-mode" :branch "main"))

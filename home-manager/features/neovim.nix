{ pkgs, inputs, ... }:

let
    key = k: a: {
      key = k;
      action = "<cmd>${a}<CR>";
      mode = [ "n" "v" ];
    };
    keyI = k: a: {
      key = k;
      action = "<cmd>${a}<CR>";
      mode = [ "i" ];
    };
in
{

  imports = [ inputs.nixvim.homeManagerModules.nixvim ];
  programs.nixvim = {
    enable = true;
    colorschemes.gruvbox.enable = true;
    globals = {
      mapleader = " ";
    };
    keymaps = [
      (key "<leader>ff" "Telescope frecency workspace=CWD")
      (key "<leader>fp" "Telescope projects")
      (key "<leader>ot" "ToggleTerm")
      (key "<leader>w" "<C-w>")
      (key "<leader>gg" "Neogit")
      (key "<C-s>" "w")
      (keyI "<C-s>" "w") 
    ];
    plugins = {
      lualine.enable = true;
      comment-nvim = {
	enable = true;
      };
      which-key = {
        enable = true;
        icons = {
            separator = "";
            group = "";
          };
      };
      neogit = {
        enable = true;
      };
      harpoon = {
        enable = true;
        enableTelescope = true;
      };
      dashboard = {
        enable = true;
      };
      toggleterm.enable = true;
      none-ls.enable = true;
      helm.enable = true;
      nix.enable = true;
      direnv.enable = true;
      gitsigns.enable = true;
      nvim-autopairs.enable = true;
      treesitter.enable = true;
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true; 
          gopls.enable = true;
          yamlls.enable = true;
          tsserver.enable = true;
          gleam.enable = true;
        };
      };
      cmp = {
        enable = true;
        autoEnableSources = true;
      };
      telescope = {
        enable = true;
	 extensions = {
	    frecency.enable = true;
	    fzf-native.enable = true;
	 };
          defaults = {
            mappings = {
              i = {
                "<esc>" = {
                  __raw = ''
                    function(...)
                      return require("telescope.actions").close(...)
                    end
                  '';
                };
              };
            };
          };
      };
    };
  };
}

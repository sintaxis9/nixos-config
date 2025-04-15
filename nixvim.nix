#NIXVIM
{pkgs, ...}:
{
  programs.nixvim = {
    enable = true;
    colorschemes.tokyonight.enable = true;

    #  K E Y M A P S
    keymaps = [
      {
        key = "<C-t>";
        action = "<Cmd>bn<CR>";
        mode = "n";
        options = {
          noremap = true;
          silent = false;
        };
      }
      {
        key = "<C-b>";
        action = "<Cmd>Neotree toggle<CR>";
        mode = "n";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        key = "<C-w>";
        action = "<Cmd>BufferClose<CR>";
        mode = "n";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        key = "C-l";
        action = "<Cmd>ToggleTerm<CR>";
        options = {
          noremap = true;
          silent = true;
        };
      }
    ];

    #PLUGINS NIXVIM
    plugins = {
      nix = {
        enable = true;
	package = pkgs.vimPlugins.vim-nix;
      };
      #AUTOCLOSE
      autoclose = {
        enable = true;
	package = pkgs.vimPlugins.autoclose-nvim;
	keys = null;
      };
      #SUDA
      vim-suda = {
        enable = true;
	package = pkgs.vimPlugins.vim-suda;
      };
      #SURROUND
      nvim-surround = {
        enable = true;
	package = pkgs.vimPlugins.nvim-surround;
      };
      #BARBAR
      barbar = {
        enable = true;
	package = pkgs.vimPlugins.barbar-nvim;
	settings = {
	  animation = true;
	  auto_hide = 1;
	  clickeble = true;
	  focus_on_close = "right";
	  sidebar_filetypes = {
	    "neo-tree" = {
	      event = "BufWinEnter";
	    };
	  };
	};
	keymaps ={
	  next = {
	    key = "<C-Tab>";
	    action = "<Cmd>BufferNext<CR>";
	    options = {

	    };
	  };
	};
      };
      #RCP
      presence-nvim = {
        enable = true;
	enableLineNumber = true;
	package = pkgs.vimPlugins.presence-nvim;
	autoUpdate = true;
	debounceTimeout = 5;
	fileExplorerText = "buscando una wea en %s";
	mainImage = "file";
	showTime = true;
	editingText = "manoseando a %s";
	neovimImageText = "wea pa mala XD";
	readingText = "toi leyendo esta wa: %s";
	workspaceText = "laburando en %s";
	lineNumberText = "en %s de %s";
	pluginManagerText = "weando con los plugins";
      };
      #LUALINE
      lualine = {
        enable = true;
	package = pkgs.vimPlugins.lualine-nvim;
	gitPackage = pkgs.git;
	settings = {
	  icons_enabled = true;
	  options = {
	    theme = "palenight";
	    globalstatus = true;
	    component_separators = {
	      left = "";
	      right = "";
	    };
	    section_separators = {
	      left = "";
	      right = "";
	    };
	  };
	};
      };
      #TELESCOPE
      telescope = {
        enable = true;
        package = pkgs.vimPlugins.telescope-nvim;
        keymaps = {
          "<C-p>" = {
            action = "find_files";
          };
        };
      };
      #ICONS
      web-devicons = {
        enable = true;
	settings = {
          color_icons = true;
	  strict = true;
	};
      };
      #NEOTREE
      neo-tree = {
        enable = true;
	enableDiagnostics = true;
	enableGitStatus = true;
	enableModifiedMarkers = true;
	popupBorderStyle = "rounded";
      };
      #LSP
      lsp = {
        enable = true;
	inlayHints = false;
	package = pkgs.vimPlugins.nvim-lspconfig;
	servers = {
	  #LSP->PYTHON
          basedpyright = {
	    enable = true;
	    package = pkgs.basedpyright;
	    cmd = ["/run/current-system/sw/bin/basedpyright"];
	    filetypes = ["python"];
	    autostart = true;
	    rootDir = ''function(fname) return "/Documents/study/pyy" end'';
	  };
	  #LSP->NIXD
	  nixd = {
	    enable = true;
	    package = pkgs.nixd;
	    autostart = true;
	    cmd = ["/run/current-system/sw/bin/nixd"];
	    filetypes = ["nix"];
	    rootDir = null;
	  };
	  #LSP->C++
	  clangd = {
	    enable = true;
	    package = pkgs.clang-tools;
	    autostart = true;
	    cmd = ["/run/current-system/sw/bin/clangd"];
	    rootDir = ''function(fname) return "/Documents/study/cncpp" end'';
	  };
	  #LSP->JAVA
	  jdtls = {
	    enable = true;
	    package = pkgs.jdt-language-server;
	    autostart = true;
	    cmd = [
	      "${pkgs.jdt-language-server}/bin/jdtls"
	    ];
	    rootDir = ''function(fname) return "/Documents/study/iaba" end'';
	    filetypes = ["java"];
          };
          eslint = {
            enable = true;
            package = pkgs.vscode-langservers-extracted;
            cmd = ["/run/current-system/sw/bin/eslint"];
          };
	};
      };
      lsp-format = {
        enable = true;
	package = pkgs.vimPlugins.lsp-format-nvim;
	lspServersToEnable = "all";
      };
      #CMP
      cmp = {
        enable = true;
	package = pkgs.vimPlugins.nvim-cmp;
	autoEnableSources = true;
	settings.sources = [
	  {name = "nvim_lsp";}
	  {name = "path";}
	  {name = "buffer";}
	];
	settings = {
	  mapping = {
	    "<C-Space>" = "cmp.mapping.complete()";
	    "<C-d>" = "cmp.mapping.scroll_docs(-4)";
	    "<C-e>" = "cmp.mapping.close()";
	    "<C-f>" = "cmp.mapping.scroll_docs(4)";
	    "<CR>" = "cmp.mapping.confirm({select = true})";
	    "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
	    "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
	  };
	};
      };
      #CMP-NVIM-LSP
      cmp-nvim-lsp = {
        enable = true;
	package = pkgs.vimPlugins.cmp-nvim-lsp;
      };
      #TOGGLETERM
      toggleterm = {
        enable = true;
	package = pkgs.vimPlugins.toggleterm-nvim;
	settings = {
	  auto_scroll = true;
	  autochdir = true;
	  close_on_exit = true;
	};
      };
    };
  };
}

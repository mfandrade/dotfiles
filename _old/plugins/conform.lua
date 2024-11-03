return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      xml = { "tidy", "xmllint" },
      javascript = { "standardjs" },
      java = { "google-java-format", "uncrustify" },
    },
    formatters = {
      tidy = {
        command = "tidy",
        args = {
          "-xml",
          "-i",
          "-q",
          "--indent-spaces",
          "4",
          "--wrap",
          "0",
          "--indent-attributes",
          "yes",
          "--literal-attributes",
          "yes",
          "--show-body-only",
          "yes",
          "--show-errors",
          "0",
          "--tidy-mark",
          "no",
          "-",
        },
        stdin = true,
      },
      xmllint = {
        command = "xmllint",
        env = { XMLLINT_INDENT = "    " },
      },
      uncrustify = {
        command = "uncrustify",
        args = {
          "-c",
          vim.fn.expand("~/.uncrustifyrc"),
          "-q",
          "-l",
          "JAVA", -- or whatever language you're using
        },
        stdin = true,
      },
    },
    -- format_on_save = {
    --   timeout_ms = 5000, -- Increase this value (in milliseconds)
    --   lsp_fallback = true,
    -- },
  },
}

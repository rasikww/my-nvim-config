return {
  'Sebastian-Nielsen/better-type-hover',
  ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'tailwindcss', 'svelte' },
  config = function()
    require('better-type-hover').setup {
      openTypeDocKeymap = '<C-k>',
    }
  end,
}

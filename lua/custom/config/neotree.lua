require('neo-tree').setup {
  window = {
    mappings = {
      ['h'] = 'close_node',
      ['l'] = 'open',
    },
  },
  close_if_last_window = true,
}

return {
  "sphamba/smear-cursor.nvim",
  opts = {
    -- Disable if running inside Neovide, otherwise enable
    enabled = not vim.g.neovide, 
    
    -- stiffness = 0.8,
    -- trailing_stiffness = 0.5,
    -- distance_stop_animating = 0.3
  },
}

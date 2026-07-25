return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  opts = {
    -- Basic settings
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
    legacy_computing_symbols = false,
    smear_to_cmd = true,

    -- Optional animation tweaking
    -- stiffness = 0.8,         -- 0.0 to 1.0 (Higher = snappier, Lower = smoother)
    -- trailing_stiffness = 0.5, -- 0.0 to 1.0 (Lower = longer trail)
  },
}

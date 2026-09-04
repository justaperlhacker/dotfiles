settings {
    logfile    = os.getenv("HOME") .. "/.config/lsyncd/lsyncd.log",
    statusFile = os.getenv("HOME") .. "/.config/lsyncd/lsyncd.status",
    nodaemon   = true,
}

-- Backup: laptop -> drive (one-way)
sync {
    default.rsync,
    source = os.getenv("HOME") .. "/Projects",
    target = os.getenv("HOME") .. "/shared/Projects",
    delay  = 2,
    rsync  = {
        archive  = true,
        compress = false,
        acls     = true,
        xattrs   = true,
    }
--    exclude = {
--        ".git/",
--       "node_modules/",
--        "venv/",
--        "__pycache__/",
--        "*.pyc",
--        "*.swp",
--        "*.swo",
--        "*~",
--        ".DS_Store",
--        "Thumbs.db",
--    },
}


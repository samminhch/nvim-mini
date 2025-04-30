local env = {
    sysname = vim.loop.os_uname().sysname,
    xdg_cache_home = os.getenv("XDG_CACHE_HOME"),
    nvim = {
        mason_data = vim.fn.stdpath("data") .. "/mason/share",
    },
}

local cache_dir = env.cache_home and env.cache_home or vim.fn.expand("~/.cache")

local jdtls_exec = env.sysname == "Linux" and "/usr/bin/jdtls" or "jdtls"
local jdtls_dir = env.sysname == "LINUX" and "/usr/share/java/jdtls" or env.nvim.mason_data .. "jdtls"
local jdtls_config_dir = jdtls_dir .. (env.sysname == "Linux" and "config_linux/" or "config/")
local jdtls_workspace_dir = cache_dir .. "/workspace"

return {
    cmd = {
        jdtls_exec,
        "-configuration",
        jdtls_config_dir,
        "-data",
        jdtls_workspace_dir,
    },
    filetypes = { "java" },
    root_markers = {
        "build.xml", -- Ant
        "pom.xml", -- Maven
        "settings.gradle", -- Gradle
        "settings.gradle.kts", -- Gradle
    },
    init_options = {
        workspace = jdtls_workspace_dir,
        jvm_args = {},
        os_config = nil,
    },
}

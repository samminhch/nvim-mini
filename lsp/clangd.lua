return {
    cmd = { "clangd", "--background-index" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    root_markers = {
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac",
        ".git",
    },
    flags = {
        debounce_text_changes = 20,
        exit_timeout = false,
    },
    capabilities = {
        textDocument = {
            completion = { editsNearCursor = true },
            offsetEncoding = { "utf-8", "utf-16" },
        },
    },
}

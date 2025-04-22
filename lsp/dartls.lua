return {
    cmd = { 'dart', 'language-server', '--protocol=lsp' },
    filetypes = { 'dart' },
    root_dir = function()
        return vim.fn.getcwd()
    end,
    init_options = {
        onlyAnalyzeProjectsWithOpenFiles = true,
        suggestFromUnimportedLibraries = true,
        closingLabels = true,
        outline = true,
        flutterOutline = true,
    },
    settings = {
        dart = {
            completeFunctionCalls = true,
            showTodos = true,
        },
    },
}

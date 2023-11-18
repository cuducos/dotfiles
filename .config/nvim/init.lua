require("editor")
require("plugins")

CloseBufferIfItHasNoPendingLspDiagnostic = function()
	local buf = vim.api.nvim_get_current_buf()
	local diagnostics = vim.diagnostic.get(buf)

	for _, diagnostic in ipairs(diagnostics) do
		if diagnostic.severity ~= vim.lsp.protocol.DiagnosticSeverity.Hint then
			vim.api.nvim_buf_delete(buf, { force = true, unload = true })
			return
		end
	end
end

vim.cmd("command! -nargs=0 CloseBufferIfItHasNoPendingLspDiagnostic lua CloseBufferIfItHasNoPendingLspDiagnostic()")

require("other-nvim").setup({
	mappings = {
		"rails",
		{ pattern = "/(.*).go$", target = "/%1_test.go" },
		{ pattern = "/(.*)/(.*).go$", target = "/%0/%1_test.go" },
	},
})

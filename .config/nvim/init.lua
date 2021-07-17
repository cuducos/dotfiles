-- modules
require("plugins")
require("editor")

-- helpers
PrettyPrint = function(tbl)
  for key, value in pairs(tbl) do
    print(key, value)
  end
end

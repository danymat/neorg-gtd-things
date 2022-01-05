require("neorg.modules.base")

local module = neorg.modules.create("external.integrations.gtd-things")

module.setup = function()
	return {
		success = true,
		requires = {
			"core.gtd.base",
		},
	}
end

---@class external.integrations.gtd-things
module.public = {
	version = "0.0.9",
}

module.load = function() end

return module

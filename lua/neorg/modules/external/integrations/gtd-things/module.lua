require("neorg.modules.base")
local log = require("neorg.external.log")

local module = neorg.modules.create("external.integrations.gtd-things")

module.setup = function()
	return {
		success = true,
		requires = {
			"core.gtd.base",
		},
	}
end

module.config.public = {
	things_db_path = "",
	waiting_for_tag = "",
}

---@class external.integrations.gtd-things
module.public = {
	version = "0.0.9",

	get_tasks = function()
		local tasks = module.private.execute_command("todos")
		tasks = vim.fn.json_decode(tasks)
		tasks = module.private.reformat_data(tasks)
		return tasks
	end,

	get_projects = function()
		local projects = module.private.execute_command("projects")
		projects = vim.fn.json_decode(projects)
		projects = module.private.reformat_data(projects)
		return projects
	end,
}

module.load = function()
	if vim.fn.executable("things-cli") == 0 then
		log.error(
			"things-cli program is not in your path. Please install it from here: https://github.com/thingsapi/things-cli"
		)
		return
	end

	if module.config.public.things_db_path == "" then
		log.error("You must add the path of your Things 3 database")
		return
	end

	module.required["core.gtd.base"].callbacks["get_data"] = function()
		return module.public.get_tasks(), module.public.get_projects()
	end

	module.required["core.gtd.base"].callbacks["gtd.edit"] = function()
		log.warn("Disabled")
	end
	module.required["core.gtd.base"].callbacks["gtd.capture"] = function()
		log.warn("Disabled")
	end
end

module.private = {
	execute_command = function(command)
		command = "things-cli --json --database '" .. module.config.public.things_db_path .. "' " .. command
		local handle = io.popen(command)
		local res = handle:read("*a")
		handle:close()

		return res
	end,

	reformat_data = function(data)
		return vim.tbl_map(function(x)
			return {
				uuid = x.uuid,
				content = x.title,
				state = neorg.lib.match({
					x.status,
					incomplete = "undone",
				}),
				area_of_focus = x.area_title,
				contexts = (function()
					local res = vim.deepcopy(x.tags) or {}

					if x.start == "Someday" then
						table.insert(res, "someday")
					end

					if x.start_date ~= vim.NIL then
						table.insert(res, "today")
					end

					local i = neorg.lib.find(res, module.config.public.waiting_for_tag)
					if i then
						-- Remove waiting_for tag to not show in contexts view
						table.remove(res, i)
					end

					return res
				end)(),
				["waiting.for"] = (function()
					local res = vim.deepcopy(x.tags) or {}

					local i = neorg.lib.find(res, module.config.public.waiting_for_tag)
					if i then
						-- Remove the waiting_for tag
						table.remove(res, i)

						-- If we have a waiting for but no other tag
						if #res == 0 then
							table.insert(res, "No waiting_for")
						end
						return res
					end
				end)(),
				["time.start"] = neorg.lib.when(vim.NIL == x.start_date, nil, { x.start_date }),
				["time.due"] = neorg.lib.when(vim.NIL == x.deadline, nil, { x.deadline }),
                project_uuid = x.project
			}
		end, data)
	end,
}

return module

local M = {}

local api = vim.api
local cmd = api.nvim_create_user_command

local function replace_diagram(input, output, id, startpos, endpos, type)
	-- Define a regular expression to match the diagram block
	local output_pattern_start = "<!%-%- " .. string.format("%s_output_%s", type, id)
	local output_pattern_end = "%-%->"

	-- Find the start and end positions of the existing diagram block
	local output_start = string.find(input, output_pattern_start)

	-- If an existing diagram block was found, replace it with the new diagram
	if output_start then
		local _, output_end = string.find(input, output_pattern_end, output_start + 1)
		local diagram = string.format("<!-- %s_output_%s\n%s-->", type, id, output)

		local new_content = string.sub(input, 1, output_start - 1) .. diagram .. string.sub(input, output_end + 1)

		return new_content, output_start, output_start + #diagram - 1
	else
		-- If an existing diagram block was not found, append the new diagram to the end of the input
		local diagram = string.format("<!-- %s_output_%s\n%s-->", type, id, output)

		local new_content = string.sub(input, 1, endpos) .. "\n" .. diagram .. "\n" .. string.sub(input, endpos + 1)

		return new_content
	end
end

function M.generate_diagram(type, pattern)
	-- Get the contents of the current buffer
	local bufnr = api.nvim_get_current_buf()
	local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)

	-- Join the lines into a single string
	local input = table.concat(lines, "\n")

	-- Extract the sequence notation from the input string
	local i = 1
	for startpos, optionalId, sequence, endpos in string.gmatch(input, pattern) do
		-- If the sequence notation was found, generate a diagram using `diagon`
		if sequence then
			local j = 1
			for newstartpos, newOptionalId, newsequence, newendpos in string.gmatch(input, pattern) do
				if j == i then
					startpos = newstartpos
					endpos = newendpos
					sequence = newsequence
					optionalId = newOptionalId
					break
				end
				j = j + 1
			end

			-- Define the command to generate the diagram
			local command = string.format('echo "%s" | diagon %s', sequence, type)

			-- Execute the command and capture the output
			local output = vim.fn.systemlist(command)
			output = table.concat(output, "\n")

			-- if optionalId is an empty string use i
			local id = (optionalId ~= "" and optionalId) or i

			-- Replace the existing or create a new output block for the diagram
			local new_content = replace_diagram(input, output, id, startpos, endpos, string.lower(type))

			input = new_content
		end
		i = i + 1
	end
	api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(input, "\n"))
end

function M.run()
	M.generate_diagram("Sequence", "()```sequence%s*([%a]*)%s*\n(.-)\n?```()")
	M.generate_diagram("Math", "()```math%s*([%a]*)%s*\n(.-)\n?```()")
end

cmd("Diagon", function()
	M.run()
end, {})

return M

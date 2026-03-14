local maj = {}

MARK_AND_JUMP_MAX_KEYS = 8

maj.default_config = {
	keymap_config = {
		jump_keys = "luy'h,./",
		mark_keys = "luy'h,./",
		jump_lhs_format = "<A-%s>",
		mark_lhs_format = "<A-S-%s>",
	},
}
maj.config = {}
maj.buffers = {}

function maj.setup_keymaps(keymap_config)
	if keymap_config.mark_keys == nil then
		keymap_config.mark_keys = keymap_config.jump_keys
	end
	for i = 1, string.len(keymap_config.jump_keys) do
		local jump_key = keymap_config.jump_keys:sub(i, i)
		local mark_key = keymap_config.mark_keys:sub(i, i)
		vim.keymap.set("n", string.format(keymap_config.jump_lhs_format, jump_key), function()
			maj.jump(i)
		end, { noremap = true, silent = true })
		vim.keymap.set("n", string.format(keymap_config.mark_lhs_format, mark_key), function()
			maj.mark(i)
		end, { noremap = true, silent = true })
	end
end

function maj.find_buffer_index(buffer_number)
	for i, saved_buffer_number in pairs(maj.buffers) do
		if saved_buffer_number == buffer_number then
			return i
		end
	end
	return nil
end

function maj.setup_autocmds()
	vim.api.nvim_create_autocmd("BufDelete", {
		group = vim.api.nvim_create_augroup("MarkAndJump", {}),
		callback = function()
			local buffer_index = maj.find_buffer_index(vim.api.nvim_get_current_buf())
			if buffer_index == nil then
				return
			end
			maj.nuke(buffer_index)
		end,
	})
end

function maj.setup(user_config)
	user_config = user_config or {}
	for k, v in pairs(maj.default_config) do
		maj.config[k] = user_config[k] or v
	end
	for _ = 1, MARK_AND_JUMP_MAX_KEYS do
		table.insert(maj.buffers, -1)
	end
	if maj.config.keymap_config ~= nil and maj.config.keymap_config ~= {} then
		maj.setup_keymaps(maj.config.keymap_config)
	end
	maj.setup_autocmds()
end

function maj.mark(buffer_index)
	-- if buffer_index < 1 or buffer_index > string.len(maj.config.keymap_config.mark_keys) then
	-- 	return
	-- end
	local existing_buffer_index = maj.find_buffer_index(vim.api.nvim_get_current_buf())
	if existing_buffer_index ~= nil then
		maj.nuke(existing_buffer_index)
	end
	maj.buffers[buffer_index] = vim.api.nvim_get_current_buf()
	local mark_key = string.format(
		maj.config.keymap_config.mark_lhs_format,
		maj.config.keymap_config.mark_keys:sub(buffer_index, buffer_index)
	)
	print(string.format("buffer marked with [%s]", mark_key))
end

function maj.jump(buffer_index)
	if buffer_index < 1 or buffer_index > string.len(maj.config.keymap_config.jump_keys) then
		return
	end

	local buffer_number = maj.buffers[buffer_index]
	if buffer_number == -1 then
		return
	end
	vim.api.nvim_set_current_buf(buffer_number)
end

function maj.nuke(buffer_index)
	if buffer_index == nil or buffer_index < 1 or buffer_index > string.len(maj.config.keymap_config.jump_keys) then
		return
	end
	maj.buffers[buffer_index] = -1
end

function maj.jump_1()
	maj.jump(1)
end
function maj.jump_2()
	maj.jump(2)
end
function maj.jump_3()
	maj.jump(3)
end
function maj.jump_4()
	maj.jump(4)
end
function maj.jump_5()
	maj.jump(5)
end
function maj.jump_6()
	maj.jump(6)
end
function maj.jump_7()
	maj.jump(7)
end
function maj.jump_8()
	maj.jump(8)
end

function maj.mark_1()
	maj.mark(1)
end
function maj.mark_2()
	maj.mark(2)
end
function maj.mark_3()
	maj.mark(3)
end
function maj.mark_4()
	maj.mark(4)
end
function maj.mark_5()
	maj.mark(5)
end
function maj.mark_6()
	maj.mark(6)
end
function maj.mark_7()
	maj.mark(7)
end
function maj.mark_8()
	maj.mark(8)
end

return maj

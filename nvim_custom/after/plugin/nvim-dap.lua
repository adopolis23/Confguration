local dap = require("dap")
local dapui = require("dapui")

-- Setup dap-ui
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        { id = "repl", size = 0.5 },
        { id = "console", size = 0.5 },
      },
      size = 10,
      position = "bottom",
    },
  },
  floating = {
    max_height = 0.9,
    max_width = 0.5,
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
})

-- Setup nvim-dap-virtual-text
require("nvim-dap-virtual-text").setup({
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = true,
  show_stop_reason = true,
  commented = false,
  only_first_definition = true,
  all_references = false,
  filter_references_pattern = "<module",
})

-- C/C++ debugger configuration (gdb)
dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "-i", "dap" },
}

dap.adapters.lldb = {
  type = "executable",
  command = "lldb-vscode", -- or lldb-dap depending on your version
  name = "lldb",
}

-- C debug configuration
dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
    args = function()
      local args_str = vim.fn.input("Arguments: ")
      return vim.split(args_str, " +")
    end,
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "enable pretty printing",
        ignoreFailures = false,
      },
    },
  },
  {
    name = "Launch with args",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
    args = function()
      local args_str = vim.fn.input("Arguments: ")
      return vim.split(args_str, " +")
    end,
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "enable pretty printing",
        ignoreFailures = false,
      },
    },
  },
  {
    name = "Attach to process",
    type = "gdb",
    request = "attach",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    pid = function()
      local pid = vim.fn.input("PID: ")
      return tonumber(pid)
    end,
    cwd = "${workspaceFolder}",
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "enable pretty printing",
        ignoreFailures = false,
      },
    },
  },
}

-- Also configure for cpp
dap.configurations.cpp = dap.configurations.c

-- Key mappings
vim.keymap.set("n", "<F5>", function()
  dap.continue()
end, { desc = "Debug: Start/Continue" })

vim.keymap.set("n", "<F6>", function()
  dapui.toggle()
end, { desc = "Debug: Toggle UI" })

vim.keymap.set("n", "<F10>", function()
  dap.step_over()
end, { desc = "Debug: Step Over" })

vim.keymap.set("n", "<F11>", function()
  dap.step_into()
end, { desc = "Debug: Step Into" })

vim.keymap.set("n", "<F12>", function()
  dap.step_out()
end, { desc = "Debug: Step Out" })

vim.keymap.set("n", "<Leader>b", function()
  dap.toggle_breakpoint()
end, { desc = "Debug: Toggle Breakpoint" })

vim.keymap.set("n", "<Leader>B", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Set Conditional Breakpoint" })

vim.keymap.set("n", "<Leader>lp", function()
  dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "Debug: Set Log Point" })

vim.keymap.set("n", "<Leader>dr", function()
  dap.repl.open()
end, { desc = "Debug: Open REPL" })

vim.keymap.set("n", "<Leader>dl", function()
  dap.run_last()
end, { desc = "Debug: Run Last" })



-- Add variable under cursor to watch
vim.keymap.set("n", "<Leader>wa", function()
  local word = vim.fn.expand("<cword>")
  require("dapui").eval(word, { enter = true })
end, { desc = "Debug: Add Watch" })



-- Eval var under cursor
vim.keymap.set("n", "<leader>?", function()
require("dapui").eval(nil, { enter = true })
end)


-- Automatically open/close dap-ui
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Debug console hover
vim.keymap.set("n", "<Leader>dh", function()
  local variables = dap.session().variables
  if variables then
    local word = vim.fn.expand("<cword>")
    local value = variables[word]
    if value then
      vim.notify(word .. " = " .. value)
    end
  end
end, { desc = "Debug: Hover variable" })

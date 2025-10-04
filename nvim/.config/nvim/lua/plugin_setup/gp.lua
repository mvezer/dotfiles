return function()
  require("gp").setup({
    providers = {
      anthropic = {
        endpoint = "https://api.anthropic.com/v1/messages",
        secret = os.getenv("ANTHROPIC_API_KEY"),
      },
    },
    agents = {
      {
        provider = "anthropic",
        name = "ChatClaude-4.5-Sonnet",
        chat = true,
        command = true,
        -- string with model name or table with model name and parameters
        model = { model = "claude-sonnet-4-5-20250929" },
        -- system prompt (use this to specify the persona/role of the AI)
        system_prompt = require("gp.defaults").chat_system_prompt,
      },
    },
    default_command_agent = "ChatClaude-4.5-Sonnet",
    default_chat_agent = "ChatClaude-4.5-Sonnet",
  })
end

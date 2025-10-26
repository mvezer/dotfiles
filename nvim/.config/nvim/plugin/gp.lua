require("core").plugins.add("https://github.com/Robitx/gp.nvim", "gp", {
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
      model = { model = "claude-sonnet-4-5-20250929" },
      system_prompt = [[
You are a general AI assistant.

The user provided the additional info about how they would like you to respond:

- If you're unsure don't guess and say you don't know instead.
- Ask question if you need clarification to provide better answer.
- Think deeply and carefully from first principles step by step.
- Zoom out first to see the big picture and then zoom in to details.
- Use Socratic method to improve your thinking and coding skills.
- Don't elide any code from your output if the answer requires coding.
- Take a deep breath; You've got this!
]],
    },
  },
  default_command_agent = "ChatClaude-4.5-Sonnet",
  default_chat_agent = "ChatClaude-4.5-Sonnet",
})

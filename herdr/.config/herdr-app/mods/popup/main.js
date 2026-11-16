// ctrl-space g / d ("popup.lazygit" / "popup.lazydocker"): the program in a popup over the window,
// in the focused pane's folder; the same key again closes it (the TUI's prefix+g). Quitting the
// program closes it too. Lives invisibly in the mine layout (commands only reach shown mods), so
// no trigger overlay steals the keyboard back. The same mod is the popup's title bar
// (props.terminal); closing the popup kills the program.
import { View, div } from "gpui-kit";
import { checking, closeOverlay, focused, hc, home, nextCommand, notify, openOverlay, props, run, terminals, theme } from "herdr";

const PROGRAMS = ["lazygit", "lazydocker"];

export default class Popup extends View {
  init(_props, cx) {
    const p = props() ?? {};
    if (p.terminal) { Object.assign(this, p); return; } // the title bar: terminal, program, cwd
    if (checking()) return;
    cx.spawn(async () => {
      for (;;) {
        const program = await nextCommand();
        if (PROGRAMS.includes(program)) await this.toggle(program);
      }
    });
  }

  async toggle(program) {
    const open = this.open;
    if (open && terminals().some((t) => t.address === open.terminal)) {
      closeOverlay(open.overlay);
      this.open = null;
      if (open.program === program) return; // the other key swaps popups
    }
    // shortcut: always runs on this computer, a space on another machine would need `--on`
    const cwd = focused()?.cwd || home();
    try {
      const r = await hc(["run", "--json", "--bg", "--rm", "--no-parent", "--cwd", cwd, "--", program]);
      if (r.code !== 0) throw new Error(r.stderr.trim() || `hc run exited ${r.code}`);
      const terminal = JSON.parse(r.stdout).address;
      const overlay = openOverlay({
        kind: "dialog", width: 0.96, height: 0.96,
        layout: { type: "column", children: [
          { type: "block", size: { px: 24 }, content: { mod: "popup", props: { terminal, program, cwd } } },
          { type: "block", content: { terminal } },
        ] },
      });
      this.open = { overlay, terminal, program }; // the dialog takes the keyboard itself
    } catch (e) {
      notify({ title: program, body: String(e?.message ?? e), level: "error" });
    }
  }

  async close() {
    if (this.terminal) run("terminal.kill", { terminal: this.terminal }); // already gone when the program quit itself
  }

  render() {
    if (!this.terminal) return div();
    const t = theme();
    const where = this.cwd.startsWith(home()) ? "~" + this.cwd.slice(home().length) : this.cwd;
    return div().size_full().flex().items_center().px(10).bg(t.chrome).text_size(12).text_color(t.muted)
      .child(`${this.program}  ${where}`);
  }
}

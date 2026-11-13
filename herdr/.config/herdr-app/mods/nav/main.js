// ctrl+arrows (keys.json "nav.left" ...): move between panes, or let nvim handle them so it can
// move between its own splits (it runs `herdr-app do pane.go:<dir>` at its edge). The GUI version
// of ~/.config/herdr/nav.sh. Lives invisibly in the mine layout: commands only reach shown mods.
import { View, div } from "gpui-kit";
import { exec, focused, panes, run, nextCommand, notify } from "herdr";

export default class Nav extends View {
  init(_props, cx) {
    cx.spawn(async (cx) => {
      for (;;) {
        const dir = await nextCommand(); // "left" | "right" | "up" | "down"
        const f = focused();
        const pane = panes().find((p) => p.pane === f?.pane);
        if (pane?.program?.key === "nvim" && f.terminal) {
          const r = await exec("hc", ["keys", f.terminal, `ctrl+${dir}`]);
          if (r.code !== 0) notify({ title: "nav failed", body: r.stderr, level: "error" });
        } else {
          run("pane.go", { direction: dir });
        }
        cx.notify(); // touching cx ends this loop when the mod reloads
      }
    });
  }
  render() { return div(); }
}

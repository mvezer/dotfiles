// ctrl+arrows (keys.json "nav.left" ...): move between panes, or let nvim handle them so it can
// move between its own splits (at its edge it runs `herdr-app do nav.edge-<dir>`, which skips the
// nvim check). With no pane further left/right, go to the previous/next tab instead.
// The GUI version of ~/.config/herdr/nav.sh. Lives invisibly in the mine layout: commands only
// reach shown mods.
import { View, div } from "gpui-kit";
import { exec, focused, panes, run, nextCommand, notify } from "herdr";

const TAB_AT_EDGE = { left: "tab.prev", right: "tab.next" };

export default class Nav extends View {
  init(_props, cx) {
    cx.spawn(async (cx) => {
      for (;;) {
        const cmd = await nextCommand(); // "left" ... | "edge-left" ... (from nvim at its edge)
        const fromNvim = cmd.startsWith("edge-");
        const dir = fromNvim ? cmd.slice("edge-".length) : cmd;
        const f = focused();
        const pane = panes().find((p) => p.pane === f?.pane);
        if (!fromNvim && pane?.program?.key === "nvim" && f.terminal) {
          const r = await exec("hc", ["keys", f.terminal, `ctrl+${dir}`]);
          if (r.code !== 0) notify({ title: "nav failed", body: r.stderr, level: "error" });
        } else {
          run("pane.go", { direction: dir });
          await cx.sleep(0); // let the focus change land before checking it
          if (TAB_AT_EDGE[dir] && focused()?.pane === f?.pane) run(TAB_AT_EDGE[dir]);
        }
        cx.notify(); // touching cx ends this loop when the mod reloads
      }
    });
  }
  render() { return div(); }
}

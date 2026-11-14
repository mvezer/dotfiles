// Claude plan usage: 5h / 7d meters with reset countdowns. Data comes from
// ~/.config/herdr-app/claude-statusline.sh, Claude Code's statusLine, as
// ~/.cache/claude-usage.json. Each session's context is in the agents list (square-agents).

import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { theme, home, readTextFile, layout } from "herdr";

const REFRESH_MS = 30000;

function find(node, id) {
  if (node?.id === id) return node;
  for (const child of node?.children ?? []) {
    const found = find(child, id);
    if (found) return found;
  }
  return null;
}
const narrow = () => (find(layout(), "sidebar")?.size?.px ?? Infinity) < 160;

function until(unix) {
  const m = Math.max(0, Math.round((unix * 1000 - Date.now()) / 60000));
  if (m < 60) return `${m}m`;
  const h = Math.floor(m / 60);
  if (h < 24) return `${h}h${String(m % 60).padStart(2, "0")}m`;
  return `${Math.floor(h / 24)}d${h % 24}h`;
}

async function readJson(path) {
  try { return JSON.parse((await readTextFile(path)) ?? "null"); } catch { return null; }
}

export default class ClaudeUsage extends View {
  init(_props, cx) {
    this.plan = null;
    this.refresh(cx);
    cx.timer.every(REFRESH_MS, (cx) => this.refresh(cx));
  }

  refresh(cx) {
    cx.spawn(async (cx) => {
      this.plan = await readJson(`${home()}/.cache/claude-usage.json`);
      cx.notify();
    });
  }

  severity(used) {
    const t = theme();
    return used >= 85 ? t.ansi1 : used >= 60 ? t.ansi3 : t.ansi2;
  }

  bar(used, height = 4) {
    const t = theme();
    const pct = Math.max(0, Math.min(100, used));
    return div().flex_1().min_w(0).h(height).rounded(height / 2).bg(t.raised)
      .child(div().h_full().rounded(height / 2).w(`${pct}%`).bg(this.severity(pct)));
  }

  windowRow(label, w) {
    const t = theme();
    const expired = !w || w.resets_at * 1000 < Date.now();
    const used = expired ? 0 : w.used_percentage;
    return h_flex().gap(8).items_center().text_size(12)
      .child(div().w(20).flex_none().text_color(t.muted).child(label))
      .child(this.bar(used))
      .child(div().w(34).flex_none().text_color(t.foreground).child(w ? `${Math.round(used)}%` : "–"))
      .child(div().w(46).flex_none().text_color(t.dim).child(!w ? "" : expired ? "reset" : until(w.resets_at)));
  }

  render() {
    const t = theme();
    const p = this.plan;
    if (narrow()) {
      const pct = (w) => !w || w.resets_at * 1000 < Date.now() ? 0 : Math.round(w.used_percentage);
      return v_flex().size_full().items_center().gap(2).py(6).text_size(10).text_color(t.muted)
        .child(div().child(`5h ${pct(p?.five_hour)}`))
        .child(div().child(`7d ${pct(p?.seven_day)}`));
    }
    return v_flex().size_full().min_h(0).py(6)
      .child(div().px(12).pb(4).text_size(11).font_semibold().text_color(t.muted).child("CLAUDE USAGE"))
      .child(v_flex().px(12).gap(4)
        .child(this.windowRow("5h", p?.five_hour))
        .child(this.windowRow("7d", p?.seven_day)));
  }
}

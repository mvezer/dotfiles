// A markdown file rendered in a pane, re-rendered when the file changes on disk.
// Opened from nvim (<leader>M): pane.split {direction: "right", mod: "md-preview", props: {file}}.
import { View, div } from "gpui-kit";
import { v_flex, TextView } from "gpui-base";
import { props, readTextFile, theme, watchFolder } from "herdr";

export default class MdPreview extends View {
  init(_props, cx) {
    this.file = props()?.file ?? null;
    this.text = null;
    if (!this.file) return;
    const dir = this.file.slice(0, this.file.lastIndexOf("/")) || "/";
    this.load(cx);
    cx.spawn(async (cx) => {
      for (;;) {
        const changed = await watchFolder(dir);
        // a batch holding the folder itself means "refresh everything"
        if (changed.includes(this.file) || changed.includes(dir)) this.load(cx);
        else cx.notify(); // touching cx ends this loop when the pane or mod goes
      }
    });
  }

  load(cx) {
    cx.spawn(async (cx) => {
      try { this.text = await readTextFile(this.file); } catch { this.text = null; }
      cx.notify();
    });
  }

  render() {
    const t = theme();
    const body = !this.file ? "No file given."
      : this.text === null ? `Can't read \`${this.file}\`.`
      : this.text;
    return v_flex().size_full().min_h(0).px(20).py(14).bg(t.background).text_color(t.foreground).text_size(14)
      .child(TextView.markdown(`md-preview-${this.file}`, body).scrollable(true).selectable(true));
  }
}

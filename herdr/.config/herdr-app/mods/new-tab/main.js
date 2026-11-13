// alt-w ("mod.open:new-tab"): a new tab, then the rename dialog for it
// (the TUI's prompt_new_tab_name = true).
import { View, div } from "gpui-kit";
import { closeOverlay, props, run } from "herdr";

export default class NewTab extends View {
  init() {
    const self = props()?.overlay;
    if (!self) return; // `herdr-app check` loads it without being opened
    closeOverlay(self);
    run("tab.new");
    run("tab.rename"); // no name: Herdr asks for one, for the tab just made and shown
  }
  render() { return div(); }
}

// alt-q ("mod.open:new-space"): a new space, then the rename dialog for it
// (the TUI's prompt_new_workspace_name = true).
import { View, div } from "gpui-kit";
import { closeOverlay, props, run } from "herdr";

export default class NewSpace extends View {
  init() {
    const self = props()?.overlay;
    if (!self) return; // `herdr-app check` loads it without being opened
    closeOverlay(self);
    run("space.new");
    run("space.rename"); // no name: Herdr asks for one, for the space just made and shown
  }
  render() { return div(); }
}

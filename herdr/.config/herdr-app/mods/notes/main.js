// ctrl-space n ("mod.open:notes"): jump to (or create) the "notes" space; from inside it, jump
// back to whichever space was shown before (the TUI's prefix+n script).
import { View, div } from "gpui-kit";
import { closeOverlay, home, props, run, setShared, shared, spaces } from "herdr";

export default class Notes extends View {
  init() {
    const self = props()?.overlay;
    if (!self) return; // `herdr-app check` loads it without being opened
    closeOverlay(self);
    const all = spaces();
    const current = all.find((s) => s.active);
    if (current?.name === "notes") {
      const back = shared("notes.last-space");
      if (all.some((s) => s.id === back)) run("space.select", { id: back });
      return;
    }
    setShared("notes.last-space", current?.id ?? null);
    const notes = all.find((s) => s.name === "notes");
    if (notes) run("space.select", { id: notes.id });
    else run("space.new", { name: "notes", folder: home() });
  }
  render() { return div(); }
}

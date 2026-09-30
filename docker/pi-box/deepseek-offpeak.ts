import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const KEY = "ds-offpeak";

// Mon-Fri UTC; Chinese holidays not modeled
export function isPeak(d: Date): boolean {
  const day = d.getUTCDay();
  const h = d.getUTCHours();
  return day >= 1 && day <= 5 && ((h >= 1 && h < 4) || (h >= 6 && h < 10));
}

export function label(now: Date): string {
  const peak = isPeak(now);
  const t = new Date(Math.floor(now.getTime() / 60000) * 60000);
  let mins = 0;
  while (isPeak(t) === peak && mins < 8 * 1440) {
    t.setUTCMinutes(t.getUTCMinutes() + 1);
    mins++;
  }
  const span = `${Math.floor(mins / 60)}h${String(mins % 60).padStart(2, "0")}m`;
  return peak ? `DS peak, off-peak in ${span}` : `DS off-peak, peak in ${span}`;
}

export default function (pi: ExtensionAPI) {
  let timer: ReturnType<typeof setInterval> | undefined;

  pi.on("session_start", async (_e, ctx) => {
    const tick = () => ctx.ui.setStatus(KEY, label(new Date()));
    tick();
    timer = setInterval(tick, 60_000);
    timer.unref();
  });

  pi.on("session_shutdown", async () => {
    if (timer) clearInterval(timer);
  });
}

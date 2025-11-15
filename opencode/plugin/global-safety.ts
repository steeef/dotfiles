import type { Plugin } from "@opencode-ai/plugin";
import { promises as fs } from "node:fs";
import path from "node:path";
import { once } from "node:events";

// Global safety plugin: bash safeguards, file-size guard,
// CLAUDE.md protection, grep enforcement, and auto-formatting.

export const GlobalSafety: Plugin = async ({ $, directory }) => {
  const shell = $.cwd(directory);

  const flagPath = (name: string) => path.join(directory, `.${name}`);

  const isBinaryPath = (filePath: string) =>
    /\.(png|jpe?g|gif|pdf|zip|tar|gz|tgz|bz2)$/i.test(filePath);

  const isClaudeMD = (filePath: string | undefined): boolean =>
    !!filePath &&
    (filePath.endsWith("CLAUDE.md") || filePath.includes("/CLAUDE.md"));

  const fileExists = async (p: string): Promise<boolean> =>
    fs
      .access(p)
      .then(() => true)
      .catch(() => false);

  const countLinesStreaming = async (
    fullPath: string,
    limit: number,
  ): Promise<number> => {
    const fh = await fs.open(fullPath, "r");
    const stream = fh.createReadStream();
    let lines = 0;

    stream.on("data", (chunk: Buffer) => {
      for (let i = 0; i < chunk.length; i++) {
        if (chunk[i] === 0x0a) {
          lines++;
          if (lines > limit) {
            stream.destroy();
            break;
          }
        }
      }
    });

    await once(stream, "close");
    await fh.close();
    return lines;
  };

  const enforceFileSize = async (args: any) => {
    const filePath: string | undefined =
      args?.filePath ?? args?.file_path ?? args?.path;

    if (!filePath) return;
    if (isBinaryPath(filePath)) return;

    const fullPath = path.isAbsolute(filePath)
      ? filePath
      : path.join(directory, filePath);

    if (!(await fileExists(fullPath))) return;

    const inSubtask = await fileExists(
      flagPath("opencode_in_subtask.flag"),
    );
    const limit = inSubtask ? 10_000 : 500;

    const lines = await countLinesStreaming(fullPath, limit + 1);

    if (lines > limit) {
      throw new Error(
        [
          `File too large: ${lines} lines (limit: ${limit})`,
          "Use the Task tool with a sub-agent for large-file analysis instead.",
          `File: ${filePath}`,
        ].join("\n"),
      );
    }
  };

  const collectTouchedFiles = (args: any): string[] => {
    const candidates = new Set<string>();

    const add = (p: unknown) => {
      if (typeof p === "string" && p.length > 0) {
        candidates.add(p);
      }
    };

    add(args?.filePath);
    add(args?.file_path);

    if (Array.isArray(args?.files)) {
      for (const f of args.files) {
        add(f);
      }
    }

    return [...candidates];
  };

  const formatFiles = async (files: string[]) => {
    if (files.length === 0) return;

    const encoder = new TextEncoder();

    for (const file of files) {
      const fullPath = path.isAbsolute(file)
        ? file
        : path.join(directory, file);

      const payload = JSON.stringify({
        tool_input: {
          file_path: fullPath,
        },
      });

      try {
        const proc = shell`~/.bin/format.sh`.quiet().nothrow();
        const writer = proc.stdin.getWriter();
        await writer.write(encoder.encode(payload));
        await writer.close();
        await proc;
      } catch (error) {
        // Formatting is best-effort; do not block tool execution.
        console.error("[global-safety] format.sh failed", error);
      }
    }
  };

  const checkBashCommand = (command: string): string[] => {
    const messages: string[] = [];

    if (/\brm\s/.test(command)) {
      messages.push(
        [
          "Blocked: 'rm' is not allowed in this environment.",
          "Move files into a TRASH/ directory and record them in TRASH-FILES.md instead.",
        ].join("\n"),
      );
    }

    if (/git\s+add\s+(\.|-A|--all)\b/.test(command)) {
      messages.push(
        [
          "Blocked: dangerous 'git add' pattern.",
          "Use 'git add <specific-files>' or 'git add -u' instead.",
        ].join("\n"),
      );
    }

    if (/git\s+checkout\b/.test(command)) {
      messages.push(
        [
          "Blocked: 'git checkout' may discard local changes.",
          "Stash or commit manually, then rerun the command yourself if desired.",
        ].join("\n"),
      );
    }

    if (/kubectl\s+(delete|destroy)\b/.test(command)) {
      messages.push(
        [
          "Blocked: destructive kubectl operation.",
          "Run kubectl commands manually in a separate terminal if you are sure.",
        ].join("\n"),
      );
    }

    if (/terraform\s+(apply|destroy)\b/.test(command)) {
      messages.push(
        [
          "Blocked: destructive terraform operation.",
          "Run terraform manually with explicit approval.",
        ].join("\n"),
      );
    }

    if (/\.env\b/.test(command)) {
      messages.push(
        [
          "Blocked: .env file access.",
          "Secrets should not be listed, printed, or copied via automated tools.",
        ].join("\n"),
      );
    }

    if (/\bgrep\s/.test(command) && !/\brg\s/.test(command)) {
      messages.push(
        [
          "Blocked: 'grep' is disabled.",
          "Use 'rg' (ripgrep) instead; it is faster and respects .gitignore.",
        ].join("\n"),
      );
    }

    return messages;
  };

  // Track tool arguments by callID so the after-hook can see them.
  const callArgs = new Map<string, any>();

  return {
    "tool.execute.before": async (input, output) => {
      const tool = input.tool.toLowerCase();

      // Save args for use in tool.execute.after
      callArgs.set(input.callID, output.args);

      if (tool === "bash") {
        const commandArg = output.args?.command;
        const command = typeof commandArg === "string" ? commandArg : "";
        const blockers = checkBashCommand(command);

        if (blockers.length > 0) {
          throw new Error(blockers.join("\n\n"));
        }
      }

      if (tool === "read") {
        await enforceFileSize(output.args ?? {});
      }

      if (tool === "write" || tool === "edit") {
        const args = output.args ?? {};
        const filePath: string | undefined =
          args.filePath ?? args.file_path ?? args.path;

        if (isClaudeMD(filePath)) {
          throw new Error(
            [
              "Blocked: do not write to CLAUDE.md directly.",
              "Edit AGENTS.md instead and symlink CLAUDE.md to AGENTS.md.",
            ].join("\n"),
          );
        }
      }
    },

    "tool.execute.after": async (input, output) => {
      const tool = input.tool.toLowerCase();

      try {
        if (tool === "write" || tool === "edit") {
          const args = callArgs.get(input.callID);
          callArgs.delete(input.callID);

          if (!args) return;

          const files = collectTouchedFiles(args);
          await formatFiles(files);
        }
      } catch (error) {
        console.error("[global-safety] post-tool formatting failed", error);
      } finally {
        // Ensure we do not leak memory even if tool type does not match.
        callArgs.delete(input.callID);
      }
    },
  };
};

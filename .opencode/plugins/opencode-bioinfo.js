/**
 * opencode-bioinfo — Unified OpenCode Plugin
 *
 * Registers ALL skill directories (power-pack + ClawBio) so OpenCode
 * discovers all ~75 skills via its native skill tool.
 *
 * This is a self-contained plugin: no external repos required at install
 * time. Everything lives in the opencode-BioInfo repo.
 *
 * Skills are registered by pushing absolute paths to config.skills.paths.
 * OpenCode scans each path for SKILL.md files and makes them available.
 *
 * ──── Attribution ────────────────────────────────────────────────────────
 * Plugin loader pattern adapted from Jesse Vincent's superpowers plugin:
 * https://github.com/obra/superpowers
 *
 * Power-pack skills ported from Anthropic's Claude Code skills.
 * ClawBio skills (Manuel Corpas et al.): https://github.com/ClawBio/ClawBio
 * ─────────────────────────────────────────────────────────────────────────
 */

import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// Resolve the repo root (two levels up from .opencode/plugins/)
const repoRoot = path.resolve(__dirname, '../..');

// Absolute paths to each skill collection
const powerPackSkillsDir = path.resolve(repoRoot, 'skills/power-pack');
const clawbioSkillsDir = path.resolve(repoRoot, 'skills/clawbio');

export const OpencodeBioinfo = async () => {
  return {
    config: async (config) => {
      config.skills = config.skills || {};
      config.skills.paths = config.skills.paths || [];

      for (const skillsDir of [powerPackSkillsDir, clawbioSkillsDir]) {
        if (!config.skills.paths.includes(skillsDir)) {
          config.skills.paths.push(skillsDir);
        }
      }
    },
  };
};

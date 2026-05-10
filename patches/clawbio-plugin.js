/**
 * clawbio — OpenCode Plugin Shim
 *
 * Registers ClawBio's skills/ directory so OpenCode discovers all 63
 * bioinformatics-native skills via its native skill tool.
 *
 * Skills are the original work of the ClawBio team (Manuel Corpas et al.)
 * under MIT license: https://github.com/ClawBio/ClawBio
 */

import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const skillsDir = path.resolve(__dirname, '../../skills');

export const ClawBio = async () => {
  return {
    config: async (config) => {
      config.skills = config.skills || {};
      config.skills.paths = config.skills.paths || [];
      if (!config.skills.paths.includes(skillsDir)) {
        config.skills.paths.push(skillsDir);
      }
    },
  };
};

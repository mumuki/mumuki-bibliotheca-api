export { Guide, Exercise, Expectation, FileSystem } from './types';
export { LocalFileSystem, GithubFileSystem } from './filesystem';
export { GuideReader } from './reader';

import * as path from 'path';
import { Guide } from './types';
import { LocalFileSystem, GithubFileSystem } from './filesystem';
import { GuideReader } from './reader';

/**
 * Read a guide from a local directory.
 *
 * @param dirPath  Absolute or relative path to the guide repository root
 * @param slug     The guide slug in `organization/repository` format
 * @returns        The guide JSON representation
 *
 * @example
 * const guide = await readGuideFromDir('./my-guide', 'myorg/my-guide');
 */
export async function readGuideFromDir(dirPath: string, slug: string): Promise<Guide> {
  const absoluteDir = path.resolve(dirPath);
  const fs = new LocalFileSystem();
  const reader = new GuideReader(fs, absoluteDir, slug);
  return reader.readGuide();
}

/**
 * Read a guide from a GitHub repository.
 *
 * @param slug   The guide slug in `organization/repository` format
 * @param options.ref    Git ref (branch, tag, or commit SHA). Defaults to 'HEAD'.
 * @param options.token  GitHub personal access token for private repositories.
 * @returns              The guide JSON representation
 *
 * @example
 * const guide = await readGuideFromGithub('myorg/my-guide');
 * const privateGuide = await readGuideFromGithub('myorg/private-guide', { token: 'ghp_...' });
 */
export async function readGuideFromGithub(
  slug: string,
  options: { ref?: string; token?: string } = {},
): Promise<Guide> {
  const [owner, repo] = slug.split('/');
  if (!owner || !repo) {
    throw new Error(`Invalid slug format: expected "organization/repository", got "${slug}"`);
  }

  const fs = new GithubFileSystem({ owner, repo, ref: options.ref, token: options.token });
  const reader = new GuideReader(fs, '', slug);
  return reader.readGuide();
}

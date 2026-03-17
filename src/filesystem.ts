import * as fs from 'fs';
import * as path from 'path';
import { FileSystem } from './types';

/**
 * Reads files from the local filesystem.
 */
export class LocalFileSystem implements FileSystem {
  async readFile(filePath: string): Promise<string | null> {
    try {
      return fs.readFileSync(filePath, 'utf-8');
    } catch {
      return null;
    }
  }

  async listDir(dirPath: string): Promise<string[]> {
    try {
      return fs.readdirSync(dirPath);
    } catch {
      return [];
    }
  }

  async findByStem(dir: string, stem: string): Promise<string[]> {
    const entries = await this.listDir(dir);
    return entries
      .filter((entry) => {
        const ext = path.extname(entry);
        const base = ext ? entry.slice(0, -ext.length) : entry;
        return base === stem;
      })
      .map((entry) => path.join(dir, entry));
  }
}

interface GithubContentItem {
  name: string;
  type: 'file' | 'dir' | string;
  path: string;
  download_url: string | null;
}

/**
 * Reads files from a GitHub repository using the GitHub Contents API.
 * Works with public repositories without authentication.
 * Pass a personal access token for private repositories.
 */
export class GithubFileSystem implements FileSystem {
  private readonly owner: string;
  private readonly repo: string;
  private readonly ref: string;
  private readonly token?: string;
  private readonly dirCache = new Map<string, GithubContentItem[]>();

  constructor(options: {
    owner: string;
    repo: string;
    ref?: string;
    token?: string;
  }) {
    this.owner = options.owner;
    this.repo = options.repo;
    this.ref = options.ref ?? 'HEAD';
    this.token = options.token;
  }

  private headers(): Record<string, string> {
    const h: Record<string, string> = { Accept: 'application/vnd.github+json' };
    if (this.token) h['Authorization'] = `Bearer ${this.token}`;
    return h;
  }

  private async fetchDirContents(dirPath: string): Promise<GithubContentItem[]> {
    const cached = this.dirCache.get(dirPath);
    if (cached) return cached;

    const apiPath = dirPath === '' || dirPath === '.' ? '' : `/${dirPath}`;
    const url = `https://api.github.com/repos/${this.owner}/${this.repo}/contents${apiPath}?ref=${encodeURIComponent(this.ref)}`;
    const res = await fetch(url, { headers: this.headers() });
    if (!res.ok) return [];

    const data = (await res.json()) as GithubContentItem[];
    this.dirCache.set(dirPath, data);
    return data;
  }

  async readFile(filePath: string): Promise<string | null> {
    const dir = filePath.includes('/') ? filePath.substring(0, filePath.lastIndexOf('/')) : '';
    const name = filePath.includes('/') ? filePath.substring(filePath.lastIndexOf('/') + 1) : filePath;

    const items = await this.fetchDirContents(dir);
    const item = items.find((i) => i.name === name && i.type === 'file');
    if (!item?.download_url) return null;

    const res = await fetch(item.download_url, { headers: this.headers() });
    if (!res.ok) return null;
    return res.text();
  }

  async listDir(dirPath: string): Promise<string[]> {
    const items = await this.fetchDirContents(dirPath);
    return items.map((i) => i.name);
  }

  async findByStem(dir: string, stem: string): Promise<string[]> {
    const items = await this.fetchDirContents(dir);
    return items
      .filter((item) => {
        if (item.type !== 'file') return false;
        const dotIdx = item.name.lastIndexOf('.');
        const base = dotIdx >= 0 ? item.name.slice(0, dotIdx) : item.name;
        return base === stem;
      })
      .map((item) => (dir ? `${dir}/${item.name}` : item.name));
  }
}

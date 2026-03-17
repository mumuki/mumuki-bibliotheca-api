import * as path from 'path';
import { readGuideFromDir } from '../src/index';
import { Guide, Exercise } from '../src/types';

const FIXTURES_DIR = path.join(__dirname, '../mumukit-sync/spec/data');
const SLUG = 'mumuki/functional-haskell-guide-1';

function fixture(name: string): string {
  return path.join(FIXTURES_DIR, name);
}

function findExercise(guide: Guide, id: number): Exercise | undefined {
  return guide.exercises.find((e) => e.id === id);
}

// ─── simple-guide ────────────────────────────────────────────────────────────

describe('simple-guide', () => {
  let guide: Guide;

  beforeAll(async () => {
    guide = await readGuideFromDir(fixture('simple-guide'), SLUG);
  });

  it('reads the slug', () => {
    expect(guide.slug).toBe(SLUG);
  });

  it('reads the language', () => {
    expect(guide.language).toBe('haskell');
  });

  it('reads the locale', () => {
    expect(guide.locale).toBe('en');
  });

  it('reads the description', () => {
    expect(guide.description).toBe('Awesome guide\n');
  });

  it('reads 7 exercises', () => {
    // simple-guide has directories 1,3,4,5,6,7,8 (no directory 2)
    expect(guide.exercises.length).toBe(7);
  });

  it('has no exercise with id 2', () => {
    expect(findExercise(guide, 2)).toBeUndefined();
  });

  it('reads sources', () => {
    expect(guide.sources).toBeDefined();
  });

  // ── exercise 1 ──
  describe('exercise 1 (sample_title)', () => {
    let ex: Exercise;
    beforeAll(() => { ex = findExercise(guide, 1)!; });

    it('exists', () => expect(ex).toBeDefined());
    it('has name from folder', () => expect(ex.name).toBe('sample_title'));
    it('has description', () => expect(ex.description.trim()).toBe('##Sample Description'));
    it('has test', () => expect(ex.test.trim()).toBe('pending'));
    it('has extra', () => expect(ex.extra?.trim()).toBe('extra'));
    it('has no hint', () => expect(ex.hint).toBeUndefined());
    it('has no corollary', () => expect(ex.corollary).toBeUndefined());
    it('has 2 expectations', () => expect(ex.expectations).toHaveLength(2));
    it('has expected tags', () => expect(ex.tag_list).toEqual(expect.arrayContaining(['foo', 'bar', 'baz'])));
    it('has no layout', () => expect(ex.layout).toBeUndefined());
    it('has no language override', () => expect(ex.language).toBeUndefined());
    it('has extra_visible from meta', () => expect(ex.extra_visible).toBe(true));
    it('has locale from meta', () => expect(ex.locale).toBe('en'));
    it('has default_content', () => expect(ex.default_content).toBeDefined());
  });

  // ── exercise 3 – name override, hint, corollary ──
  describe('exercise 3 (hint and corollary)', () => {
    let ex: Exercise;
    beforeAll(() => { ex = findExercise(guide, 3)!; });

    it('exists', () => expect(ex).toBeDefined());
    it('has name overridden from meta', () => expect(ex.name).toBe('custom_name'));
    it('has hint', () => expect(ex.hint).toBeDefined());
    it('has corollary', () => expect(ex.corollary).toBeDefined());
  });

  // ── exercise 4 – layout ──
  describe('exercise 4 (with layout)', () => {
    let ex: Exercise;
    beforeAll(() => { ex = findExercise(guide, 4)!; });

    it('exists', () => expect(ex).toBeDefined());
    it('has layout', () => expect(ex.layout).toBe('input_bottom'));
  });

  // ── exercise 5 – playground ──
  describe('exercise 5 (playground)', () => {
    let ex: Exercise;
    beforeAll(() => { ex = findExercise(guide, 5)!; });

    it('exists', () => expect(ex).toBeDefined());
    it('has type playground', () => expect(ex.type).toBe('playground'));
    it('has name from folder', () => expect(ex.name).toBe('playground'));
  });

  // ── exercise 6 – reading ──
  describe('exercise 6 (reading)', () => {
    let ex: Exercise;
    beforeAll(() => { ex = findExercise(guide, 6)!; });

    it('exists', () => expect(ex).toBeDefined());
    it('has type reading', () => expect(ex.type).toBe('reading'));
    it('has name from folder', () => expect(ex.name).toBe('reading'));
    it('has description', () => expect(ex.description.trim()).toBe('Now read the following text'));
    it('has empty test', () => expect(ex.test).toBe(''));
    it('has empty expectations', () => expect(ex.expectations).toHaveLength(0));
  });

  // ── exercise 7 – free_form ──
  describe('exercise 7 (free_form)', () => {
    let ex: Exercise;
    beforeAll(() => { ex = findExercise(guide, 7)!; });

    it('exists', () => expect(ex).toBeDefined());
    it('has free_form_editor_source', () => expect(ex.free_form_editor_source).toBeDefined());
  });

  // ── exercise 8 – language override ──
  describe('exercise 8 (language override)', () => {
    let ex: Exercise;
    beforeAll(() => { ex = findExercise(guide, 8)!; });

    it('exists', () => expect(ex).toBeDefined());
    it('has language override', () => expect(ex.language).toBe('sqlite'));
  });
});

// ─── full-guide ───────────────────────────────────────────────────────────────

describe('full-guide', () => {
  let guide: Guide;

  beforeAll(async () => {
    guide = await readGuideFromDir(fixture('full-guide'), SLUG);
  });

  it('reads the name', () => expect(guide.name).toBe('Introduction'));
  it('reads authors', () => expect(guide.authors).toBe('Foo Bar\n'));
  it('reads collaborators', () => expect(guide.collaborators).toBe('Jhon Doe\n'));
  it('reads 1 exercise', () => expect(guide.exercises).toHaveLength(1));
  it('reads id_format', () => expect(guide.id_format).toBe('%05d'));
  it('reads beta flag', () => expect(guide.beta).toBe(true));
  it('reads type learning', () => expect(guide.type).toBe('learning'));
});

// ─── legacy-guide ─────────────────────────────────────────────────────────────

describe('legacy-guide', () => {
  let guide: Guide;

  beforeAll(async () => {
    guide = await readGuideFromDir(fixture('legacy-guide'), SLUG);
  });

  it('reads the name', () => expect(guide.name).toBe('Introduction'));
  it('reads 1 exercise', () => expect(guide.exercises).toHaveLength(1));
  it('maps original_id_format to id_format', () => expect(guide.id_format).toBe('%03d'));
  it('maps learning:true to type learning', () => expect(guide.type).toBe('learning'));
  it('reads beta flag', () => expect(guide.beta).toBe(true));
});

// ─── error cases ──────────────────────────────────────────────────────────────

describe('error cases', () => {
  it('throws when guide description is missing', async () => {
    await expect(
      readGuideFromDir(fixture('broken-guide-missing-description'), SLUG),
    ).rejects.toThrow(/Missing guide description file/);
  });

  it('throws when guide meta.yml is missing', async () => {
    await expect(
      readGuideFromDir(fixture('broken-guide-missing-meta'), SLUG),
    ).rejects.toThrow(/Missing guide meta.yml/);
  });

  it('throws when guide meta.yml has a syntax error', async () => {
    await expect(
      readGuideFromDir(fixture('broken-guide-syntax-error'), SLUG),
    ).rejects.toThrow(/Bad guide metadata syntax/);
  });

  it('throws when guide language is missing', async () => {
    await expect(
      readGuideFromDir(fixture('broken-guide-missing-language'), SLUG),
    ).rejects.toThrow(/Missing guide language/);
  });

  it('throws when an exercise description is missing', async () => {
    await expect(
      readGuideFromDir(fixture('broken-guide'), SLUG),
    ).rejects.toThrow(/Missing exercise sample_broken description file/);
  });
});

import * as yaml from 'js-yaml';
import {
  FileSystem,
  Guide,
  Exercise,
  Expectation,
  GuideMetaYaml,
  ExerciseMetaYaml,
  ExpectationsYaml,
} from './types';

const EXERCISE_DIR_PATTERN = /^(\d+)_(.+)$/;

export class GuideReader {
  constructor(
    private readonly fs: FileSystem,
    private readonly rootDir: string,
    private readonly slug: string,
  ) {}

  async readGuide(): Promise<Guide> {
    const meta = await this.readGuideMeta();
    const language = meta.language;
    if (!language) {
      throw new Error('Missing guide language');
    }

    const description = await this.readRequiredFile(this.rootDir, 'description', 'guide description');
    const expectations = await this.readExpectations(this.rootDir);
    const authors = await this.readFirstByStem(this.rootDir, 'AUTHORS');
    const collaborators = await this.readFirstByStem(this.rootDir, 'COLLABORATORS');
    const corollary = await this.readFirstByStem(this.rootDir, 'corollary');
    const extra = await this.readFirstByStem(this.rootDir, 'extra');
    const sources = await this.readFirstByStem(this.rootDir, 'sources');

    // Resolve exercise order from meta, default to numeric sort by id
    const order = meta.order ?? [];

    const exercises = await this.readExercises(order);

    const guide: Guide = {
      slug: this.slug,
      description,
      language,
      type: resolveGuideType(meta),
      beta: meta.beta ?? false,
      private: meta.private ?? false,
      expectations,
      settings: meta.settings ?? {},
      teacher_info: meta.teacher_info ?? '',
      custom_expectations: meta.custom_expectations ?? '',
      exercises,
    };

    if (meta.name !== undefined) guide.name = meta.name;
    if (meta.locale !== undefined) guide.locale = meta.locale;
    if (meta.id_format !== undefined) guide.id_format = meta.id_format;
    if (authors !== null) guide.authors = authors;
    if (collaborators !== null) guide.collaborators = collaborators;
    if (corollary !== null) guide.corollary = corollary;
    if (extra !== null) guide.extra = extra;
    if (sources !== null) guide.sources = sources;

    return guide;
  }

  private async readGuideMeta(): Promise<GuideMetaYaml> {
    const metaPath = joinPath(this.rootDir, 'meta.yml');
    const content = await this.fs.readFile(metaPath);
    if (!content) {
      throw new Error('Missing guide meta.yml');
    }

    let parsed: GuideMetaYaml;
    try {
      parsed = yaml.load(content) as GuideMetaYaml;
    } catch {
      throw new Error('Bad guide metadata syntax');
    }

    if (!parsed || typeof parsed !== 'object') {
      throw new Error('Bad guide metadata syntax');
    }

    // Legacy field support
    if (!parsed.id_format && parsed.original_id_format) {
      parsed.id_format = parsed.original_id_format as string;
    }

    return parsed;
  }

  private async readExercises(order: number[]): Promise<Exercise[]> {
    const entries = await this.fs.listDir(this.rootDir);
    const exerciseDirs = entries
      .map((entry) => {
        const match = EXERCISE_DIR_PATTERN.exec(entry);
        if (!match) return null;
        return { entry, id: parseInt(match[1], 10), namePart: match[2] };
      })
      .filter((x): x is NonNullable<typeof x> => x !== null)
      .sort((a, b) => a.id - b.id);

    const exercises: Exercise[] = [];
    for (const { entry, id, namePart } of exerciseDirs) {
      const exerciseDir = joinPath(this.rootDir, entry);
      const exercise = await this.readExercise(exerciseDir, id, namePart);
      exercises.push(exercise);
    }

    return sortExercises(exercises, order);
  }

  private async readExercise(
    exerciseDir: string,
    id: number,
    folderName: string,
  ): Promise<Exercise> {
    const metaPath = joinPath(exerciseDir, 'meta.yml');
    const metaContent = await this.fs.readFile(metaPath);
    if (!metaContent) {
      throw new Error(`Missing exercise ${folderName} meta.yml`);
    }

    let meta: ExerciseMetaYaml;
    try {
      meta = yaml.load(metaContent) as ExerciseMetaYaml;
    } catch {
      throw new Error(`Bad exercise ${folderName} metadata syntax`);
    }

    if (!meta || typeof meta !== 'object') {
      throw new Error(`Bad exercise ${folderName} metadata syntax`);
    }

    const description = await this.readRequiredFile(
      exerciseDir,
      'description',
      `exercise ${folderName} description`,
    );

    const test = (await this.readFirstByStem(exerciseDir, 'test')) ?? '';
    const extra = await this.readFirstByStem(exerciseDir, 'extra');
    const defaultContent = (await this.readFirstByStem(exerciseDir, 'default')) ?? '';
    const hint = await this.readFirstByStem(exerciseDir, 'hint');
    const corollary = await this.readFirstByStem(exerciseDir, 'corollary');
    const freeFormSource = await this.readFirstByStem(exerciseDir, 'free_form_editor_source');
    const expectations = await this.readExpectations(exerciseDir);

    const exercise: Exercise = {
      id,
      name: meta.name ?? folderName,
      type: meta.type ?? 'problem',
      locale: meta.locale,
      layout: meta.layout,
      editor: meta.editor ?? 0,
      tag_list: meta.tags ?? [],
      extra_visible: meta.extra_visible ?? false,
      manual_evaluation: meta.manual_evaluation ?? false,
      assistance_rules: meta.assistance_rules ?? [],
      randomizations: meta.randomizations ?? {},
      teacher_info: meta.teacher_info ?? '',
      choices: meta.choices ?? [],
      progressive_expectations: meta.progressive_expectations ?? false,
      settings: meta.settings ?? {},
      default_content: defaultContent,
      description,
      test,
      expectations,
    };

    if (extra !== null) exercise.extra = extra;
    if (hint !== null) exercise.hint = hint;
    if (corollary !== null) exercise.corollary = corollary;
    if (freeFormSource !== null) exercise.free_form_editor_source = freeFormSource;
    if (meta.language !== undefined) exercise.language = meta.language;

    return exercise;
  }

  private async readExpectations(dir: string): Promise<Expectation[]> {
    const files = await this.fs.findByStem(dir, 'expectations');
    if (files.length === 0) return [];

    const content = await this.fs.readFile(files[0]);
    if (!content) return [];

    const parsed = yaml.load(content) as ExpectationsYaml | null;
    return parsed?.expectations ?? [];
  }

  private async readRequiredFile(dir: string, stem: string, label: string): Promise<string> {
    const files = await this.fs.findByStem(dir, stem);
    if (files.length === 0) {
      throw new Error(`Missing ${label} file`);
    }
    const content = await this.fs.readFile(files[0]);
    if (content === null) {
      throw new Error(`Missing ${label} file`);
    }
    return content;
  }

  private async readFirstByStem(dir: string, stem: string): Promise<string | null> {
    const files = await this.fs.findByStem(dir, stem);
    if (files.length === 0) return null;
    return this.fs.readFile(files[0]);
  }
}

function resolveGuideType(meta: GuideMetaYaml): string {
  if (meta.type) return meta.type;
  if (meta.learning) return 'learning';
  return 'practice';
}

function sortExercises(exercises: Exercise[], order: number[]): Exercise[] {
  if (order.length === 0) return exercises;

  return [...exercises].sort((a, b) => {
    const posA = order.indexOf(a.id);
    const posB = order.indexOf(b.id);
    // Exercises not in the order list go at the end, maintaining relative order
    if (posA === -1 && posB === -1) return 0;
    if (posA === -1) return 1;
    if (posB === -1) return -1;
    return posA - posB;
  });
}

/** Join path segments, handling the case where rootDir may end with '/' */
function joinPath(base: string, segment: string): string {
  if (!base || base === '.') return segment;
  return base.replace(/\/+$/, '') + '/' + segment;
}

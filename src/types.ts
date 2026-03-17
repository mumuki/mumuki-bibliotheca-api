export interface Expectation {
  binding: string;
  inspection: string;
}

export interface Exercise {
  id: number;
  name: string;
  type: string;
  locale?: string;
  layout?: string;
  editor?: string | number;
  tag_list: string[];
  extra_visible: boolean;
  manual_evaluation: boolean;
  assistance_rules: Record<string, unknown>[];
  randomizations: Record<string, unknown>;
  teacher_info: string;
  choices: Record<string, unknown>[];
  progressive_expectations: boolean;
  settings: Record<string, unknown>;
  default_content: string;
  description: string;
  test: string;
  expectations: Expectation[];
  extra?: string;
  hint?: string;
  corollary?: string;
  free_form_editor_source?: string;
  language?: string;
}

export interface Guide {
  slug: string;
  name?: string;
  description: string;
  locale?: string;
  language: string;
  type: string;
  beta: boolean;
  private: boolean;
  id_format?: string;
  expectations: Expectation[];
  settings: Record<string, unknown>;
  extra?: string;
  corollary?: string;
  authors?: string;
  collaborators?: string;
  teacher_info: string;
  sources?: string;
  custom_expectations: string;
  exercises: Exercise[];
}

/** Raw YAML structure of a guide's meta.yml */
export interface GuideMetaYaml {
  name?: string;
  language?: string;
  locale?: string;
  type?: string;
  /** Legacy field: if true, type becomes 'learning' */
  learning?: boolean;
  beta?: boolean;
  private?: boolean;
  id_format?: string;
  /** Legacy field: used as id_format if id_format is absent */
  original_id_format?: string;
  teacher_info?: string;
  settings?: Record<string, unknown>;
  custom_expectations?: string;
  order?: number[];
  [key: string]: unknown;
}

/** Raw YAML structure of an exercise's meta.yml */
export interface ExerciseMetaYaml {
  name?: string;
  type?: string;
  locale?: string;
  layout?: string;
  editor?: string | number;
  language?: string;
  tags?: string[];
  extra_visible?: boolean;
  manual_evaluation?: boolean;
  teacher_info?: string;
  assistance_rules?: Record<string, unknown>[];
  randomizations?: Record<string, unknown>;
  choices?: Record<string, unknown>[];
  progressive_expectations?: boolean;
  settings?: Record<string, unknown>;
  [key: string]: unknown;
}

/** Raw YAML structure of an expectations.yml file */
export interface ExpectationsYaml {
  expectations?: Expectation[];
}

/**
 * Abstraction over a file system, allowing local and GitHub-based reading.
 */
export interface FileSystem {
  /**
   * Read the contents of a file. Returns null if the file does not exist.
   */
  readFile(path: string): Promise<string | null>;

  /**
   * List entries (files and directories) in a directory.
   * Returns base names only (not full paths).
   */
  listDir(path: string): Promise<string[]>;

  /**
   * Find files in a directory whose base name (without extension) matches `stem`.
   * Returns full paths of matching files.
   */
  findByStem(dir: string, stem: string): Promise<string[]>;
}

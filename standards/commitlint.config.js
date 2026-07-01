// Conventional Commits — ver docs/standards/git-and-ci.md
module.exports = {
  extends: ["@commitlint/config-conventional"],
  rules: {
    "type-enum": [
      2,
      "always",
      ["feat", "fix", "docs", "refactor", "test", "chore", "ci", "build", "perf"],
    ],
  },
};

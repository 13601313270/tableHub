// https://eslint.org/docs/user-guide/configuring

module.exports = {
  root: true,
  parser: 'babel-eslint',
  parserOptions: {
    sourceType: 'module'
  },
  env: {
    browser: true,
  },
  // https://github.com/standard/standard/blob/master/docs/RULES-en.md
  extends: 'standard',
  // required to lint *.vue files
  plugins: [
    'html'
  ],
  // add your custom rules here
  'rules': {
    // allow paren-less arrow functions
    'arrow-parens': 0,
    "camelcase": 0,
    // allow async-await
    'generator-star-spacing': 0,
    "indent": [2, 4, {
      "SwitchCase": 1
    }],
    // allow debugger during development
    'no-debugger': process.env.NODE_ENV === 'production' ? 2 : 0,
    "no-inner-declarations": [2, "functions"],
    "semi": [2, "always"],
    "space-before-function-paren": [0, "always"],
    // 强制在注释中 // 或 /* 使用一致的空格
    "spaced-comment": [2, "always", {
      "markers": ["global", "globals", "eslint", "eslint-disable", "*package", "!"]
    }],
  }
}

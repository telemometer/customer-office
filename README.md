# customer-office

## Setup

- install [NVM](https://github.com/nvm-sh/nvm)
- [configure NVM to use .nvmrc file](https://github.com/nvm-sh/nvm?tab=readme-ov-file#calling-nvm-use-automatically-in-a-directory-with-a-nvmrc-file)

## Adding Another Application

1. Run
```shell
npx nx g @nx/angular:app shell --directory=apps/shell/shell
```
2. Delete `.prettierrc` file
3. Create scripts in `package.json` and run `lintfix`

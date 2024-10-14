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
3. Create scripts in `package.json` and run all of them to check if everything is working
4. Add `package.json` to the app folder
5. Add app `package.json` to the angular assets in `project.json`, example:

```json
{
  "glob": "package.json",
  "input": "apps/shell/shell"
}
```

TODO:

- https://nx.dev/recipes/nx-release/publish-in-ci-cd
- Закончил на том что неправильно определяется версия и ченжлог всегда полностью пишет
- И надо при апдейте версии ПРа удалять старые версии
- CD
- почисти теги и релищыэ

- Проверить что пререлиз только для измененных проектов а не для всех
- Correct version is copied in dist folder

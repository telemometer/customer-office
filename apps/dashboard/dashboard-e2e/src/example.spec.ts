import { test, expect, PlaywrightTestArgs } from '@playwright/test';

test('has title', async ({ page }: PlaywrightTestArgs): Promise<void> => {
  await page.goto('/');

  expect(await page.locator('h1').textContent()).toContain('Welcome');
});

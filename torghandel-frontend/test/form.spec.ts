import { test, expect } from '@playwright/test';

function sleep(ms: number) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

test.beforeEach(async ({ page }) => {
  await page.goto('http://localhost:5173/');
});

test.afterEach(async () => {
  await sleep(1000); // 💤 Wait 3 seconds after each test
});

test('Har Torghandel titel', async ({ page }) => {
  await page.goto('http://localhost:5173/')
  await sleep(1000);

  await expect(page).toHaveTitle(/Torghandel/);
})

test('Klicka på Logga in, testa att Logga in finns på sidan', async ({ page }) => {
  const loginLink = page.getByRole('link', { name: 'Logga in' });
  await expect(loginLink).toBeVisible();
  await loginLink.click();
  await expect(page).toHaveURL(/.*\/login/);
});

test('borde navigera från frontend till Logga in sida, sen till registrera sidan för att fylla i formulär och trycka registrera', async ({ page }) => {

  await page.goto('http://localhost:5173/');

  // 1. Tryck på Logga in länken
  const loginLink = page.getByRole('link', { name: 'Logga in' });
  await expect(loginLink).toBeVisible();
  await loginLink.click();

  await expect(page).toHaveURL(/.*\/login/);

  // 2. Klicka på registrera länken i Logga in sidan
  const registerLink = page.getByRole('link', { name: 'Registrera dig här!' });
  await expect(registerLink).toBeVisible();
  await registerLink.click();

  await expect(page).toHaveURL(/.*\/register/);

  const username = `användare`;
  const password = 'hemligt123';

  // 3. Fyll i formuläret på registrera sidan
  await page.getByPlaceholder('Username').fill(username);
  await page.getByPlaceholder('Password').fill(password);
  await page.getByRole('button', { name: 'Registrera' }).click();

  await expect(page).toHaveURL(/.*\/login/);

  console.log(`Registered user: ${username} with password: ${password}`);
});

test('Ska navigera till login sidan igen och fylla i logga in formuläret för att sedan trycka på logga in knappen', async ({ page }) => {
  await page.goto('http://localhost:5173/login');

  const username = 'användare';
  const password = 'hemligt123';

  await page.getByPlaceholder('Username').fill(username);
  await page.getByPlaceholder('Password').fill(password);
  
  await page.getByRole('button', { name: 'Logga in' }).click();
});


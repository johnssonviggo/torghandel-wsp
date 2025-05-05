import { test, expect } from '@playwright/test';

const $username = `user-${Date.now()}`;
const $password = 'hemligt123';

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


  // 3. Fyll i formuläret på registrera sidan
  await page.getByPlaceholder('Username').fill($username);
  await page.getByPlaceholder('Password').fill($password);
  await page.getByRole('button', { name: 'Registrera' }).click();

  await expect(page).toHaveURL(/.*\/login/);

  console.log(`Registered user: ${$username} with password: ${$password}`);

  await page.goto('http://localhost:5173/login');

  await page.getByPlaceholder('Username').fill($username);
  await page.getByPlaceholder('Password').fill($password);
  
  await page.getByRole('button', { name: 'Logga in' }).click();

  console.log(`Inloggad som: ${$username} / ${$password}`);

  const element = page.getByText(`Hej, ${$username}!`);
  console.log(element)
  await expect(element).toBeVisible();

  const deleteLink = page.getByRole('link', { name: 'Delete Account' });
  await expect(deleteLink).toBeVisible();
  await deleteLink.click();

  await page.reload();

  await expect(loginLink).toBeVisible();
});



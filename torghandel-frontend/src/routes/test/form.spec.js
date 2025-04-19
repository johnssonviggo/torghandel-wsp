import { test, expect } from '@playwright/test';

test('User can submit listing form', async ({ page }) => {
  await page.goto('http://localhost:5173'); // Or your SvelteKit dev URL

  // Fill out form
  await page.fill('input[placeholder="Namn"]', 'Test Listing');
  await page.fill('input[placeholder="Beskrivning"]', 'Test description');
  await page.fill('input[type="number"]', '123');

  // Upload an image
  await page.setInputFiles('input[type="file"]', 'tests/assets/test-image.jpg');

  // Click on a tag (if present)
  const tagButton = await page.locator('button', { hasText: 'mat' }).first();
  if (await tagButton.isVisible()) {
    await tagButton.click();
  }

  // Submit
  await page.click('button:text("Lägg till")');

  // Check redirect or confirmation
    await expect(page).toHaveURL('/');
    
    await expect(page.locator('img')).toBeVisible();
});
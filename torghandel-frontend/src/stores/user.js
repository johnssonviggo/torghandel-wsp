//@ts-nocheck
import { writable } from "svelte/store";
import { browser } from "$app/environment";

const storedUser = browser ? localStorage.getItem("user") : null;
const storedAdmin = browser ? localStorage.getItem("admin") : null;

export const user = writable(storedUser ? JSON.parse(storedUser) : null);
export const admin = writable(storedAdmin ? JSON.parse(storedAdmin) : null);


user.subscribe((value) => {
  if (browser) {
    if (value) {
      localStorage.setItem("user", JSON.stringify(value));
    } else {
      localStorage.removeItem("user");
    }
  }
});

admin.subscribe((value) => {
  if (browser) {
    if (value) {
      localStorage.setItem("admin", JSON.stringify(value));
    } else {
      localStorage.removeItem("admin");
    }
  }
});

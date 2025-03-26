//@ts-nocheck
import { writable } from "svelte/store";

// Check if a user is already logged in (from localStorage)
const storedUser = localStorage.getItem("user");
export const user = writable(storedUser ? JSON.parse(storedUser) : null);

// Function to log in
export function loginUser(userData) {
    user.set(userData);
    localStorage.setItem("user", JSON.stringify(userData));
}

// Function to log out
export function logoutUser() {
    user.set(null);
    localStorage.removeItem("user");
}
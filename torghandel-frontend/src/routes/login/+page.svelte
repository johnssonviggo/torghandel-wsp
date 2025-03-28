<script>
  //@ts-nocheck
  import { onMount } from "svelte";
  import { goto } from "$app/navigation";

    let username = "";
    let password = "";
    let message = "";
    let isAdmin = false;

    async function login(event) {
      event.preventDefault(); // Prevents form from reloading the page

      console.log("Admin login:", isAdmin);
      console.log("Sending request with username:", username);

      const body = isAdmin
      ? { admin_name, admin_password}
      : { username, password }; // Ensure admin login sends the right field

      const endpoint = isAdmin
      ? "http://localhost:9292/api/admin/login"
      : "http://localhost:9292/api/login";        
      
      const response = await fetch(endpoint, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
    },
            body: JSON.stringify({ username, password })
        });

        const data = await response.json();

        console.log(data);

    if (response.ok) {
      if (isAdmin) {
        localStorage.setItem("admin", JSON.stringify(data.admin));
      } else {
        localStorage.setItem("user", JSON.stringify(data.user));
      }
      
      message = "Login successful!";
      await goto("/");
    } else {
      message = data.message;
      alert("doo doo, no access");
    }
  }
</script>

<form on:submit={login}
  class=" bg-[var(--clr-card)] ml-5 mt-10 me-5 rounded-lg shadow-md text-lg max-w-3xl p-6
  sm:me-0 sm:mt-20"
>
  <div class=" flex flex-col text-[var(--gr-txt)] font-medium">
    <label class="">
      Namn:
      <input
        class=" border border-[var(--clr-border)] rounded-lg p-2 w-full mt-1 focus:outline-none focus:ring-2 focus:ring-[#222831]"
        bind:value={username}
        placeholder="Username"
        />
    </label>

    <label>
      Lösenord:
      <input type="password"
        bind:value={password}
        class=" border border-[var(--clr-border)] rounded-lg p-2 w-full mt-1 focus:outline-none focus:ring-2 focus:ring-[#222831]"
        placeholder="Password"
      />
    </label>

    <label class="mt-3 flex items-center">
      <input type="checkbox" bind:checked={isAdmin} class="mr-2" />
      Logga in som admin
    </label>

    <div class=" flex space-x-4 mt-4">
      <button type="submit"
        class=" bg-[#00ADB5] text-white p-3 rounded-lg font-semibold transition hover:bg-[#007A80]"
      >
        Logga in</button
      >
    </div>
  </div>
  <div class=" mt-10">
    <span>Har du inget konto? </span>
    <a href="/register" class="text-[#00ADB5] p-2 rounded-lg font-semibold transition hover:text-[#007A80] ms-3">Registrera dig här!</a>
  </div>
</form>

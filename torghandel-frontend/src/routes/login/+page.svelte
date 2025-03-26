<script>
  //@ts-nocheck
  import { onMount } from "svelte";
  import { goto } from "$app/navigation";

    let username = "";
    let password = "";
    let message = "";

    async function login(event) {
      console.log("password", password)
      event.preventDefault(); // Prevents form from reloading the page
        const response = await fetch("http://localhost:9292/api/login", {
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
            localStorage.setItem("user", JSON.stringify(data.user));
            message = "Login successful!";
            await goto("/")
          } else {
            message = data.message;
            alert("doo doo, no access")
        }
    }
</script>

<form on:submit={login}
  class=" bg-[#EEEEEE] ml-5 mt-10 me-5 rounded-lg shadow-md text-lg max-w-3xl p-6
  sm:me-0 sm:mt-20"
>
  <div class=" flex flex-col text-[#393E46] font-medium">
    <label class="">
      Namn:
      <input
        class=" border border-[#CCCCCC] rounded-lg p-2 w-full mt-1 focus:outline-none focus:ring-2 focus:ring-[#222831]"
        bind:value={username}
        placeholder="Username"
        />
    </label>

    <label>
      Lösenord:
      <input type="password"
        bind:value={password}
        class=" border border-[#CCCCCC] rounded-lg p-2 w-full mt-1 focus:outline-none focus:ring-2 focus:ring-[#222831]"
        placeholder="Password"
      />
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

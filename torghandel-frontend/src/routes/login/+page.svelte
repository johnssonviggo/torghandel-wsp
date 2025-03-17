<script>
  import { onMount } from "svelte";
    let username = "";
    let password = "";
    let message = "";

    async function login() {
      console.log("password", password)
        const response = await fetch("http://localhost:9292/api/login", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ username, password })
        });

        const data = await response.json();

        console.log(data);

        if (response.ok) {
            localStorage.setItem("user", JSON.stringify(data.user));
            message = "Login successful!";
            window.location.href = "/"; // Redirect to another page
        } else {
            message = data.message;
            alert("doo doo, no access")
        }
    }
</script>

<form
  class=" bg-[#EEEEEE] ml-5 mt-20 rounded-lg shadow-md text-lg max-w-3xl p-6"
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
        class=" border border-[#CCCCCC] rounded-lg p-2 w-full mt-1 focus:outline-none focus:ring-2 focus:ring-[#222831]"
        bind:value={password}
        placeholder="Password"
      />
    </label>

    <div class=" flex space-x-4 mt-4">
      <button
        class=" bg-[#00ADB5] text-white p-3 rounded-lg font-semibold transition hover:bg-[#007A80]"
        on:click={login}
      >
        Logga in</button
      >
    </div>
  </div>
</form>

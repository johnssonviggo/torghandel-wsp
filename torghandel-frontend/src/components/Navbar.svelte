<script>
  //@ts-nocheck
  import { onMount } from "svelte";

  let user = null;
  let admin = null;
  let mounted = false;

  onMount(() => {
    const storedUser = localStorage.getItem("user");
    const storedAdmin = localStorage.getItem("admin");

    if (storedUser) {
      user = JSON.parse(storedUser);
    } else if (storedAdmin) {
      admin = JSON.parse(storedAdmin);
    }

    mounted = true;
  });

  function logout() {
    localStorage.removeItem("user");
    localStorage.removeItem("admin");
    user = null;
    admin = null;
    location.reload();
  }
</script>

<nav class="flex justify-between bg-[#222831] h-30">
  <div class="grid flex-1 ms-5 self-center text-md font-semibold underline text-[#EEEEEE]
  sm:text-2xl sm:space-x-10 sm:flex">
    <a href="/">Hem</a>

    {#if mounted && !user && !admin}
      <a href="/login">Logga in</a>
    {/if}

    {#if mounted && (user || admin)}
      <a href="/posts">Ladda upp</a>
      <!-- svelte-ignore a11y_invalid_attribute -->
      <a href="#" on:click={logout} class=" text-[#EEEEEE] hover:text-2xl">
        Logga ut
      </a>
    {/if}
  </div>

  <div class="flex-1 text-center text-[#EEEEEE] self-center text-lg sm:text-2xl">
    {#if mounted && user}
      <span>Hej, {user.username}!</span>
    {/if}
    {#if mounted && admin}
      <span>Hej, {admin.username}!</span>
    {/if}
  </div>

  <div class="flex-1 text-end me-5 self-center text-[#EEEEEE] text-xl font-bold sm:text-4xl">
    Torghandel
  </div>
</nav>

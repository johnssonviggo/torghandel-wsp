<!-- <script>
</script>

<nav class=" flex justify-between bg-[#222831] h-30">
  <div class=" grid flex-1 ms-5 self-center text-md font-semibold underline text-[#EEEEEE]
  sm:text-2xl sm:space-x-10 sm:flex">
    <a href="/">Hem</a>
    <a href="/login">Logga in</a>
    <a href="/register">Registrera</a>
    <a href="/posts">Ladda upp</a>
  </div>
  <div class=" flex-1 text-center text-[#EEEEEE] self-center text-lg
  sm:text-2xl">
    hej
  </div>
  <div class=" flex-1 text-end me-5 self-center text-[#EEEEEE] text-xl font-bold
  sm:text-4xl">
  Torghandel
  </div>
</nav>


 -->

 <script>
  //@ts-nocheck
  import { onMount } from "svelte";

  let user = null;

  // Check if the user is logged in
  onMount(() => {
    const storedUser = localStorage.getItem("user");
    if (storedUser) {
      user = JSON.parse(storedUser);
    }
  });

  function logout() {
    localStorage.removeItem("user");
    user = null;
    location.reload(); // Refresh page to update navbar
  }
</script>

<nav class="flex justify-between bg-[#222831] h-30">
  <div class="grid flex-1 ms-5 self-center text-md font-semibold underline text-[#EEEEEE]
  sm:text-2xl sm:space-x-10 sm:flex">
    <a href="/">Hem</a>
    
    {#if !user}  <!-- Hide when logged in -->
      <a href="/login">Logga in</a>
      <a href="/register">Registrera</a>
    {/if}

    <a href="/posts">Ladda upp</a>
    
    {#if user}  <!-- Show logout button only when logged in -->
      <!-- svelte-ignore a11y_invalid_attribute -->
      <a href="#" on:click={logout} class=" text-[#EEEEEE] hover:text-2xl">
        Logga ut
      </a>
    {/if}
  </div>


  <div class="flex-1 text-center text-[#EEEEEE] self-center text-lg sm:text-2xl">
    {#if user}
      <span>Hej, {user.username}!</span>
    {/if}
  </div>

  <div class="flex-1 text-end me-5 self-center text-[#EEEEEE] text-xl font-bold sm:text-4xl">
    Torghandel
  </div>

</nav>

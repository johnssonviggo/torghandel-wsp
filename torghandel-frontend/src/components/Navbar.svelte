<script>
  //@ts-nocheck
  import { onMount } from "svelte";
  import { goto } from "$app/navigation";
  import { admin, user } from "../stores/user.js";

  
  let mounted = false;
  onMount(() => {
    mounted = true;
  });

  console.log($user)
  console.log($admin)

  function logout() {
    console.log("p");
    user.set(null);
    admin.set(null);
    window.location.href = "/";
  }

  const deleteUser = async () => {
    if (!$user) {
      console.error("No user to delete.");
      return;
    }

    try {
      const response = await fetch(
        `http://localhost:9292/api/users/${$user.id}/delete`,
        {
          method: "POST",
          credentials: "include", // This is important to send cookies/session info
          headers: { "Content-Type": "application/json" },
        }
      );

      const result = await response.json();
      if (response.ok) {
        console.log("User deleted successfully");
        logout();
        localStorage.removeItem("user");
      } else {
        console.error(result.message || "Error deleting user");
      }
    } catch (error) {
      console.error("Error occurred while deleting user:", error);
    }
  };
</script>

<nav class="flex justify-between bg-[#222831] h-30">
  <div
    class="grid flex-1 ms-5 self-center text-md font-semibold underline text-[#EEEEEE]
  sm:text-2xl sm:space-x-10 sm:flex"
  >
    <a href="/">Hem</a>

    {#if !$user && !$admin}
      <a href="/login">Logga in</a>
    {/if}

    {#if mounted && ($user || $admin)}
      <a href="/posts">Ladda upp</a>
      <!-- svelte-ignore a11y_invalid_attribute -->
      <a href="#" on:click={logout} class=" text-[#EEEEEE] hover:text-2xl">
        Logga ut
      </a>
      <!-- svelte-ignore a11y_invalid_attribute -->
      <a href="#" on:click={deleteUser} class=" text-[#EEEEEE] hover:text-2xl"
        >Delete</a
      >
    {/if}
  </div>

  <div
    class="flex-1 text-center text-[#EEEEEE] self-center text-lg sm:text-2xl"
  >
    {#if $user}
      <span>Hej, {$user.username}!</span>
    {/if}
    {#if $admin}
      <span>Hej, {$admin.username}!</span>
    {/if}
  </div>

  <div
    class="flex-1 text-end me-5 self-center text-[#EEEEEE] text-xl font-bold sm:text-4xl"
  >
    Torghandel
  </div>
</nav>

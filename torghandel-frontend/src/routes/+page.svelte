<script>
  // @ts-nocheck

  import Navbar from "../components/Navbar.svelte";
  import { onMount } from "svelte";

  let message = "Loading...";

  let name = "";
  let description = "";
  let cost = "";

  onMount(async () => {
    try {
      const res = await fetch("http://localhost:9292/api/listings");
      const data = await res.json();
      message = data.content;
    } catch (error) {
      message = "Failed to fetch data";
      console.error("Error fetching data:", error);
    }
  });

  console.log("Hello world!");
</script>

<main>
  {#each message as item}
    <div class=" mt-10 ms-5 p-5">
      <div class=" font-semibold text-lg bg-amber-50">
        {item.name}
      </div>
      <div class=" bg-pink-400">
        {item.description}
        {item.cost} Kronor
      </div>
      <!-- svelte-ignore a11y_missing_attribute -->
      <img src={item.image_url} />
    </div>
  {/each}
</main>

<style>
  @reference "tailwindcss/theme";
  /* .my-title {
    font-size: 10rem;
  } */
</style>

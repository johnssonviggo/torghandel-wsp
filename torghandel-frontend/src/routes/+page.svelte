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
    <div class="">
      {item.name}
      {item.description}
      {item.cost}
      {item.image}
    </div>
  {/each}
</main>

<style>
  @reference "tailwindcss/theme";
  /* .my-title {
    font-size: 10rem;
  } */
</style>

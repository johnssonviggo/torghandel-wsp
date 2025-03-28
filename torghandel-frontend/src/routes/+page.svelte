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

  // Delete function
  const deleteListing = async (id) => {
    try {
      const res = await fetch(`http://localhost:9292/api/listings/${id}/delete`, {
        method: 'POST',  // You might use DELETE here too depending on your backend
      });
      const data = await res.json();
      if (data.message === "Listing deleted") {
        // Filter out the deleted item from the `message` array
        message = message.filter(item => item.id !== id);
      } else {
        console.error("Failed to delete listing");
      }
    } catch (error) {
      console.error("Error deleting listing:", error);
    }
  };

  const editListing = (item) => {
  window.location.href = `/edit/${item.id}`;
};

  console.log("Hello world!");
</script>

<main class=" flex flex-col items-center">
  {#each message as item}
  <div class=" flex flex-col mt-15 p-5 bg-[var(--clr-card)] w-full max-w-[90vw] rounded-lg shadow-md items-center
  sm:flex-row sm:max-w-5xl">
    
    
    <!-- svelte-ignore a11y_img_redundant_alt -->
    <div class="flex-shrink-0">
      <img class=" h-100 w-100 object-cover rounded-lg" src={item.image_url} alt="Item Image" />
    </div>

    <div class="flex flex-col ml-5 mt-4
    sm:mt-0">
      <div class="font-semibold text-[var(--gr-txt)] text-2xl mb-3">
        {item.name}
      </div>

      <div class="text-md text-[var(--gr-txt)] mb-2">
        {item.description}
      </div>

      <div class="text-lg text[var(--gr-txt)] font-bold">
        {item.cost} Kronor
      </div>

      <div class="mt-4 text-lg space-x-4 font-semibold">
        <button 
          on:click={() => deleteListing(item.id)} 
          class="p-3 bg-[var(--blu-btn)] rounded-lg text-white transition hover:bg-[#007A80]"
        >
          Ta bort
        </button>

        <button
          on:click={() => editListing(item)}
          class="bg-[#CCCCCC] text-[var(--gr-txt)] p-3 rounded-lg transition hover:bg-[#AAAAAA]"
        >
          Ändra
        </button> 
      </div>
    </div>

  </div>
  {/each}
</main>

<style>
  @reference "tailwindcss/theme";
  /* .my-title {
    font-size: 10rem;
  } */
</style>

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
  <div class="flex mt-15 p-5 bg-[#EEEEEE] w-full max-w-5xl rounded-lg shadow-md items-center">
    
    
    <!-- svelte-ignore a11y_img_redundant_alt -->
    <div class="flex-shrink-0">
      <img class="h-100 w-100 object-cover rounded-lg" src={item.image_url} alt="Item Image" />
    </div>

    <div class="flex flex-col ml-5">
      <div class="font-semibold text-[#393E46] text-2xl mb-5">
        {item.name}
      </div>

      <div class="text-md text-[#393E46] mb-2">
        {item.description}
      </div>

      <div class="text-lg text-[#393E46] font-bold">
        {item.cost} Kronor
      </div>

      <div class="mt-4 space-x-4">
        <button 
          on:click={() => deleteListing(item.id)} 
          class="p-2 bg-red-500 text-white rounded font-bold"
        >
          Ta bort
        </button>

        <button
          on:click={() => editListing(item)}
          class="p-2 bg-yellow-500 text-white rounded font-bold"
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

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

<main>
  {#each message as item}
  <!-- svelte-ignore a11y_missing_attribute -->
  <div class=" flex mt-10 ms-5 p-5 bg-[#CDCDCD]">
      <div class=" flex-1 max-w-100">
       <img class=" max-h-140 max-w-140" src={item.image_url} />
     </div>

      <div class=" flex-1 font-semibold text-2xl mb-4">
        {item.name}
      </div>

      <div class=" flex-1 text-md">
        {item.description}
        {item.cost} Kronor
      </div>


      <div class=" flex-1 space-x-10">
        <button 
          on:click={() => deleteListing(item.id)} 
          class="mt-4 p-2 bg-red-500 text-white rounded font-bold"
          >
          Ta bort
        </button>

        <button
        on:click={() => editListing(item)}
        class="mt-4 p-2 bg-yellow-500 text-white rounded font-bold">
          Ändra
        </button> 
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

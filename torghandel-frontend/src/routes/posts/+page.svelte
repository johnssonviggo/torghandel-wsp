<script>
  //@ts-nocheck
  import { onMount } from "svelte";
  import { goto } from "$app/navigation"; // Import navigation helper


  // let formData = { name: "", description: "", cost: "", image: null };

  let name = "";
  let description = "";
  let cost = "";
  let imageFile = null; // Store selected image file
  let showImage= false;
  let imgSrc = "";

  /** @param {SubmitEvent} event */

  async function handleSubmit(event) {
    event.preventDefault();

    // Create FormData to send the file
    const formData = new FormData();
    formData.append("name", name);
    formData.append("description", description);
    formData.append("cost", cost);
    if (imageFile) {
      formData.append("image", imageFile);
    }

    try {
      const response = await fetch("http://localhost:9292/api/listings", {
        method: "POST",
        body: formData, // No need for headers, fetch sets them automatically for FormData
      });

      const data = await response.json();
      console.log("Server Response:", data);
      goto("/")
    } catch (error) {
      console.error("Error submitting form:", error);
    }
  }
  
  function handleFileChange(event) {
  const file = event.target.files[0]; // Get the selected file
  if (file) {
      imageFile = file;
      showImage = true;

      const reader = new FileReader();
      reader.onload = () => {
        imgSrc = reader.result; // Update the preview source
        showImage = true;
      };
      reader.readAsDataURL(file);
    } else {
      showImage = false;
      imgSrc = "";
      
    }
}

function handleCancel() {
name = "";
  description = "";
  cost = "";
  imageFile = null;
  imgSrc = "";
  showImage = false
}
</script>
<div class=" flex flex-col
sm:flex-row">
  <form 
    on:submit={handleSubmit} 
    enctype="multipart/form-data" 
    class="grid items-center bg-[#EEEEEE] mx-5 mt-10 rounded-lg shadow-md text-lg max-w-xl p-6
    sm:me-0 sm:mt-20"
  >
    <div class="flex flex-col space-y-4">

      <label class="text-[#393E46] font-medium">
        Namn:
        <input class="border border-[#CCCCCC] rounded-lg p-2 w-full mt-1 focus:outline-none focus:ring-2 focus:ring-[#222831]" 
          bind:value={name} required />
      </label>

      <label class="text-[#393E46] font-medium">
        Beskrivning:
        <input class="border border-[#CCCCCC] rounded-lg p-2 w-full mt-1 focus:outline-none focus:ring-2 focus:ring-[#222831]" 
          bind:value={description} required />
      </label>

      <label class="text-[#393E46] font-medium">
        Kostnad:
        <input type="number" class="border border-[#CCCCCC] rounded-lg p-2 w-full mt-1 focus:outline-none focus:ring-2 focus:ring-[#222831]" 
          bind:value={cost} required />
      </label>

      <label class="text-[#393E46] font-medium">
        Ladda upp bild:
        <input type="file" on:change={handleFileChange}  accept="image/"
          class="border border-[#CCCCCC] rounded-lg p-2 w-full mt-1 focus:outline-none focus:ring-2 focus:ring-[#222831]" />
      </label>

      <div class="flex space-x-4 mt-4">
        <button type="submit" class="bg-[#00ADB5] text-white p-3 rounded-lg font-semibold transition hover:bg-[#007A80]">
          Lägg till
        </button>

        <button type="button" on:click={handleCancel} 
          class="bg-[#CCCCCC] text-[#393E46] p-3 rounded-lg font-semibold transition hover:bg-[#AAAAAA]">
          Avbryt
        </button>
      </div>

    </div>

  </form>
  <div class="grid bg-[#EEEEEE] mx-5 my-5 rounded-lg shadow-md text-lg max-w-3xl p-6 items-center
  sm:mx-20 sm:mt-20 sm:mb-0">
    {#if showImage}
      <img src={imgSrc} alt="Preview" class="max-w-full rounded-lg shadow-md
      sm:max-w-xl" />
    {:else}
      <span>Image Preview</span>
    {/if}
  </div>
</div>


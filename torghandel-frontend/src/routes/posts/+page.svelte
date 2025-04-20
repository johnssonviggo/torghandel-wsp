<script>
  //@ts-nocheck
  import { onMount } from "svelte";
  import { goto } from "$app/navigation"; // Import navigation helper



  let name = "";
  let description = "";
  let cost = "";
  let imageFile = null;
  let showImage= false;
  let imgSrc = "";
  let availableTags = ["bil", "skräp", "mat", "möbler", "random", "elektronik", "kläder"];
  let selectedTags = [];

  /** @param {SubmitEvent} event */

  async function handleSubmit(event) {
    event.preventDefault();

    const formData = new FormData();
    formData.append("name", name);
    formData.append("description", description);
    formData.append("cost", cost);
    if (imageFile) {
      formData.append("image", imageFile);
    }

    formData.append("tags", selectedTags.join(","));

    try {
      const response = await fetch("http://localhost:9292/api/listings", {
        method: "POST",
        body: formData,
        credentials: "include"
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

function toggleTag(tag) {
    if (selectedTags.includes(tag)) {
      selectedTags = selectedTags.filter(t => t !== tag);
    } else {
      selectedTags = [...selectedTags, tag];
    }
  }
</script>
<div class=" flex flex-col
sm:flex-row">
  <form 
    on:submit={handleSubmit} 
    enctype="multipart/form-data" 
    class="grid items-center bg-[var(--clr-card)] mx-5 mt-10 rounded-lg shadow-md text-lg max-w-xl p-6
    sm:me-0 sm:mt-20"
  >
    <div class="flex flex-col space-y-4">

      <label class="text-[var(--gr-txt)] font-medium">
        Namn:
        <input class="border border-[var(--clr-border)] rounded-lg p-2 w-full mt-1 focus:outline-none focus:ring-2 focus:ring-[#222831]" 
          bind:value={name} required />
      </label>

      <label class="text-[var(--gr-txt)] font-medium">
        Beskrivning:
        <input class="border border-[var(--clr-border)] rounded-lg p-2 w-full mt-1 focus:outline-none focus:ring-2 focus:ring-[#222831]" 
          bind:value={description} required />
      </label>

      <label class="text-[var(--gr-txt)] font-medium">
        Kostnad:
        <input type="number" class="border border-[var(--clr-border)] rounded-lg p-2 w-full mt-1 focus:outline-none focus:ring-2 focus:ring-[#222831]" 
          bind:value={cost} required />
      </label>

      <label class="text-[var(--gr-txt)] font-medium">
        Ladda upp bild:
        <input type="file" on:change={handleFileChange}  accept="image/"
          class="border border-[var(--clr-border)] rounded-lg p-2 w-full mt-1 focus:outline-none focus:ring-2 focus:ring-[#222831]" />
      </label>

      <div class="flex space-x-4 mt-4">
        <button type="submit" class="bg-[var(--blu-btn)] text-white p-3 rounded-lg font-semibold transition hover:bg-[#007A80]">
          Lägg till
        </button>

        <button type="button" on:click={handleCancel} 
          class="bg-[var(--clr-border)] text-[var(--gr-txt)] p-3 rounded-lg font-semibold transition hover:bg-[#AAAAAA]">
          Avbryt
        </button>
      </div>

    </div>

  </form>
  <div class="grid bg-[var(--clr-card)] mx-5 my-5 rounded-lg shadow-md text-lg max-w-3xl p-6 items-center text-[var(--gr-txt)]
  sm:mx-20 sm:mt-20 sm:mb-0">
    {#if showImage}
      <img src={imgSrc} alt="Preview" class="max-w-full rounded-lg shadow-md
      sm:max-w-xl" />
    {:else}
      <span>Image Preview</span>
    {/if}
  </div>
  <label class="ms-5 text-[var(--gr-txt)] font-medium">
    <div class="mx-5 my-5 max-w-3xl rounded-lg bg-[var(--clr-card)] p-6 text-lg text-[var(--gr-txt)] shadow-md flex flex-wrap items-center 
                sm:mx-20 sm:mt-20 sm:mb-0">
      {#each availableTags as tag}
      <button
  type="button"
  class={` inline-flex m-2 px-3 py-2 rounded-md font-medium transition-colors
          ${selectedTags.includes(tag)
            ? 'bg-[#00ADB5] text-white'
            : 'text-[var(--gr-txt)] hover:bg-[#ccc]'
}`}
  on:click={() => toggleTag(tag)}
>
  {tag}
</button>
      {/each}
    </div>
  </label>
</div>


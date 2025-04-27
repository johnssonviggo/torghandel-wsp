<script>
  //@ts-nocheck
  import { onMount } from "svelte";
  import { page } from "$app/stores";
  import { goto } from "$app/navigation";

  let id = "";
  let name = "";
  let description = "";
  let cost = "";
  let image = null;
  let image_url = "";
  let imageFile = null;

  // Extract the listing ID from the URL params
  //$: id = $page.params.id;
  //$: id = $page.params.slug;
  $: slug = $page.params.slug;

  console.log(slug);

  //     export function load({ params }) {
  //     const slug = params.slug; // This gives you the slug (e.g., "1" if the route is /blog/1)
  //     return { slug };
  // }
  //     export let data;

  //     id = data.slug
  //     console.log(id)

  // Fetch the listing details
  onMount(async () => {
    try {
      const res = await fetch(`http://localhost:9292/api/listings/${slug}`);
      const data = await res.json();

      name = data.name;
      description = data.description;
      cost = data.cost;
      image_url = data.image_url;
    } catch (error) {
      console.error("Error fetching listing:", error);
    }
  });

  function handleFileChange(event) {
    imageFile = event.target.files[0]; // Get selected file
  }

  function handleCancel() {
  goto("/");
}

  const updateListing = async () => {
    console.log("Updating listing with slug:", slug); // ✅ Debugging

    const formData = new FormData();
    formData.append("id", slug); // ✅ Ensure ID is sent
    formData.append("name", name);
    formData.append("description", description);
    formData.append("cost", cost);
    if (imageFile) {
      formData.append("image", imageFile);
    }

    try {
      const res = await fetch(
        `http://localhost:9292/api/listings/${slug}/update`,
        {
          method: "POST",
          body: formData,
        }
      );

      const data = await res.json();
      console.log("Updated successfully:", data);
      goto("/");
    } catch (error) {
      console.error("Error updating listing:", error);
    }
  };


</script>

<svelte:head>
  <title>Ändra dina annonser</title>
  <meta name="description" content="Ändra dina annonser på denna sidan">
</svelte:head>

<form
  on:submit={updateListing}
  class="bg-[#EEEEEE] max-w-3xl p-6 rounded-lg shadow-md mx-5 mt-20"
>
  <div class="flex flex-col space-y-4">
    <label class="text-[#393E46] font-medium">
      Namn:
      <input
        class="border border-[#CCCCCC] rounded-lg p-2 w-full mt-1 focus:outline-none focus:ring-2 focus:ring-[#222831]"
        bind:value={name}
        required
      />
    </label>

    <label class="text-[#393E46] font-medium">
      Beskrivning:
      <input
        class="border border-[#CCCCCC] rounded-lg p-2 w-full mt-1 focus:outline-none focus:ring-2 focus:ring-[#222831]"
        bind:value={description}
        required
      />
    </label>

    <label class="text-[#393E46] font-medium">
      Kostnad:
      <input
        type="number"
        class="border border-[#CCCCCC] rounded-lg p-2 w-full mt-1 focus:outline-none focus:ring-2 focus:ring-[#222831]"
        bind:value={cost}
        required
      />
    </label>

    <label class="text-[#393E46] font-medium">
      Ladda upp bild:
      <input
        type="file"
        class="border border-[#CCCCCC] rounded-lg p-2 w-full mt-1 focus:outline-none focus:ring-2 focus:ring-[#222831]"
        on:change={handleFileChange}
      />
    </label>

    <div class="flex space-x-4 mt-4">
      <button
        type="submit"
        class="bg-[#00ADB5] text-white p-3 rounded-lg font-semibold transition hover:bg-[#007A80]"
      >
        Spara
      </button>

      <button
        type="button"
        on:click={handleCancel}
        class="bg-[#CCCCCC] text-[#393E46] p-3 rounded-lg font-semibold transition hover:bg-[#AAAAAA]"
      >
        Avbryt
      </button>
    </div>
  </div>
</form>

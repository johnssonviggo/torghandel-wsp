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

  console.log(slug)

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
    //   alert("Listing updated!");
      goto('/')
    } catch (error) {
      console.error("Error updating listing:", error);
    }
  };
</script>

<form on:submit={updateListing}>
  <div class="flex flex-row bg-blue-400 ml-5 mt-5 text-xl">
    Namn: <input class="border border-black ml-3" bind:value={name} required />
  </div>

  <div class="mt-5 ml-5 bg-amber-400 text-xl">
    Beskrivning: <input
      class="border border-black ml-3"
      bind:value={description}
      required
    />
  </div>

  <div class="ml-5 mt-5 bg-pink-400 text-xl">
    Kostnad: <input
      type="number"
      class="border border-black ml-3"
      bind:value={cost}
      required
    />
  </div>

  <div class="ml-5 mt-5 bg-purple-400">
    <input
      type="file"
      class="border border-black"
      on:change={handleFileChange}
    />
  </div>

  <button
    type="submit"
    class="bg-black p-3 ml-5 mt-5 rounded-xl text-xl text-white"
  >
    Spara
  </button>

  <button type="button" class="bg-gray-400 p-3 ml-5 mt-5 rounded-xl text-xl">
    Avbryt
  </button>
</form>

<script>
  import { onMount } from "svelte";

  let anothermessage = "Loading...";

  let formData = { name: "", description: "", cost: "", image: null };

  /** @param {SubmitEvent} event */
  async function handleSubmit(event) {
    event.preventDefault();
    console.log(JSON.stringify(formData));

    try {
      const response = await fetch("http://localhost:9292/api/listings", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(formData), // Convert form data to JSON
      });

      const data = await response.json();
      console.log("Server Response:", data);
    } catch (error) {
      console.error("Error submitting form:", error);
    }
  }

  function handleCancel() {
    formData = { name: "", description: "", cost: "", image: null };
  }
</script>

<form on:submit={handleSubmit} enctype="multipart/form-data">
  <div class=" flex flex-row bg-blue-400 ml-5 mt-5 text-xl">
    Namn: <input
      class="border border-black ml-3"
      bind:value={formData.name}
      required
    />
  </div>
  <div class="mt-5 ml-5 bg-amber-400 text-xl">
    Beskrivning: <input
      class="border border-black ml-3"
      bind:value={formData.description}
      required
    />
  </div>
  <div class="ml-5 mt-5 bg-pink-400 text-xl">
    Kostnad: <input
      type="number"
      class="border border-black ml-3"
      bind:value={formData.cost}
      required
    />
  </div>
<div class="ml-5 mt-5 bg-purple-400">
  <input type="file"
  bind:value={formData.image}
   class="border border-black">
</div>
  <button type="submit" class=" bg-lime-400 p-3 ml-5 mt-5 rounded-xl text-xl"
    >Lägg till</button
  >
  <button
    type="button"
    on:click={handleCancel}
    class=" bg-gray-400 p-3 ml-5 mt-5 rounded-xl text-xl">Avbryt</button
  >
</form>
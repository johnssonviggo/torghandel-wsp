<script>
  import { onMount } from "svelte";

  let anothermessage = "Loading...";

  onMount(async () => {
    try {
      const res = await fetch("http://localhost:9292/api/anothermessage");
      const data = await res.json();
      anothermessage = data.message;
    } catch (error) {
      anothermessage = "Failed to fetch data";
      console.error("Error fetching data:", error);
    }
  });
</script>


<p> "Detta meddelande kommer från backend: {anothermessage}"</p>
HÄR SKA MAN KUNNA LÄGGA UP GREJER

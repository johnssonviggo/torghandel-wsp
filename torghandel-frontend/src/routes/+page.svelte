<script>
  import Navbar from "../components/Navbar.svelte";
  import {onMount} from "svelte";

  let message = "Loading...";
  

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

  // let myAge = 18;
  // let elias_message = "Elias är " + myAge + " år";

  // function increaseAge() {
  //   myAge += 1;

  //   if (myAge >= 100) {
  //     elias_message = "Elias är död";
  //   } else {
  //     elias_message = "Elias är " + myAge + " år";
  //   }
  // }
</script>

<!-- <h1 class="my-title">{elias_message}</h1>
<button on:click={increaseAge}>Öka ålder</button> -->

{message.length}

<style>
  /* .my-title {
    font-size: 10rem;
  } */
</style>

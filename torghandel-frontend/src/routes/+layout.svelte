<script>
  let { children } = $props();
  import Navbar from "../components/Navbar.svelte";
  import "../app.css";
  import { onMount } from "svelte";
</script>

<Navbar />

{@render children()}

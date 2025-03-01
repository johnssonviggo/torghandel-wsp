<script>
   let { children } = $props();
  import Navbar from "../components/Navbar.svelte";
  import "../app.css";
</script>

<Navbar />

{@render children()}
<script>
    //@ts-nocheck
    import { goto } from "$app/navigation";

    let username = ""
    let password = ""
    async function handleRegister(event) {
        event.preventDefault();

        try {
            const response = await fetch("http://localhost:9292/api/register", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "Accept": "application/json",

                },
                body: JSON.stringify({ username, password }),
            });

            if (!response.ok) {
                const errorData = await response.json();
                console.error("Error:", errorData.message);
                return;
            }

            const data = await response.json();
            console.log("User registered:", data);
            goto("/login");
        } catch (error) {
            console.error("Network error:", error);
        }
    }


    function handleCancel(event) {
        event.preventDefault();
        console.log("hejsan")
        goto("/")
    }

    console.log(username)
</script>

<form on:submit={handleRegister}
  class=" bg-[var(--clr-card)] ml-5 mt-10 me-5 rounded-lg shadow-md text-lg max-w-3xl p-6
  sm:me-0 sm:mt-20"
>
  <div class=" flex flex-col text-[var(--gr-txt)] font-medium">
    <label class="">
      Namn:
      <input bind:value={username}
        class=" border border-[var(--clr-border)] rounded-lg p-2 w-full mt-1 focus:outline-none focus:ring-2 focus:ring-[#222831]"
        placeholder="Username"
        />
    </label>

    <label>
      Lösenord:
      <input type="password" bind:value={password}
        class=" border border-[var(--clr-border)] rounded-lg p-2 w-full mt-1 focus:outline-none focus:ring-2 focus:ring-[#222831]"
        placeholder="Password"
      />
    </label>

    <div class=" flex space-x-4 mt-4">
    <div>
      <button type="submit"
        class=" bg-[#00ADB5] text-white p-3 rounded-lg font-semibold transition hover:bg-[#007A80]"
      >
        Registrera</button
      >
    </div>
    <div>
        <button  on:click={handleCancel}
          class=" bg-[var(--clr-border)] text-[var(--gr-txt)] p-3 rounded-lg font-semibold transition hover:bg-[#AAAAAA]"
        >
          Avbryt</button
        >
      </div>
    </div>
  </div>
</form>
<form action="POST">
  <div class="logga-in">
    <div>
      <span>Namn:</span>
      <input class="namn" name="Username" required />
    </div>

    <div>
      <span>Lösenord:</span>
      <input name="Password" required />
    </div>
    <button type="submit">Logga in</button>
  </div>
</form>

<style>
  .logga-in {
    margin-left: 50px;
    margin-top: 30px;
    width: max-content;
  }
  
  .logga-in div {
    margin-bottom: 25px;
    font-size: 25px;
    width: 100%;
    display: flex;
    justify-content: space-between;
  }
  input {
    font-size: 20px;
    margin-left: 35px;
  }
  
  button {
    padding: 5px;
    font-size: 20px;
    background-color: lightgreen;
    border-radius: 5px;
    width: 95%;
}
</style>

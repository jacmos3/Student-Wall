<script>
  import { useWallet, useBalance } from "@connect2ic/svelte";
  import Fa from 'svelte-fa/src/fa.svelte';
  import { faLocationArrow } from '@fortawesome/free-solid-svg-icons';
  import { useCanister } from "@connect2ic/svelte";
  import {onMount} from "svelte";

  let myHandle;
  let newHandle;
  const [wallet] = useWallet();
  const [assets] = useBalance();
  
  const [studentwall] = useCanister("studentwall");
  onMount( async () => {
    let w = $wallet.principal;
      myHandle = await getHandle(w);
      console.log("Component mounted, myHandle: ", myHandle);
  });
  
  const getHandle = async () => {
    return await $studentwall.getHandle($wallet.principal);
  };

  const setHandle = async () => {
        console.log("setHandle: ", newHandle);
        let result = await $studentwall.setHandle(newHandle);
        if (result && !result.err){
          result = await getHandle();
          console.log("comparation: ", result, newHandle);
          myHandle = newHandle;
          newHandle = "";
          alert("Handle correctly created");
        }
        else{
          console.log("error happened");
        }
        
        console.log(result);
  };
</script>
<div class="example">
  {#if $wallet}
    <p>my handle : {myHandle}</p>
    <input type="text" bind:value = {newHandle} placeholder = "Select your handle" />
    <button disabled= {!newHandle} on:click = {setHandle} >
        <Fa icon={faLocationArrow} />
    </button>

    <p>Wallet address: <span style="font-size: 0.7em">{$wallet.principal}</span></p>
    <table>
      <tbody>
      {#if $assets}
        {#each $assets as asset}
          <tr>
            <td>
              {asset.name}
            </td>
            <td>
              {asset.amount}
            </td>
          </tr>
        {/each}
      {/if}
      </tbody>
    </table>
  {:else}
  <div></div>
  {/if}
</div>

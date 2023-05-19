<script>
  import { useWallet, useBalance } from "@connect2ic/svelte";
  import Fa from 'svelte-fa/src/fa.svelte';
  import { faRotateRight, faPenToSquare} from '@fortawesome/free-solid-svg-icons';
  import { useCanister } from "@connect2ic/svelte";
  import {onMount} from "svelte";

  let myHandle = "";
  let newHandle = "";
  let editing = false;
  let myBalance = 0;
  const [wallet] = useWallet();
  const [assets] = useBalance();
  
  const [studentwall] = useCanister("studentwall");
  const [wallcoin] = useCanister("wallcoin");
  onMount( async () => {
    myHandle = await getHandle();
    console.log("Component mounted, myHandle: ", myHandle);
    myBalance = await $wallcoin.myBalance();
  });

  const getHandle = async () => {
    if (!!$wallet){
      let result = await $studentwall.getHandleT(String($wallet.principal));
      if (result.length > 0){
        return "@" + result;
      };
    };

    return "";
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

  const onEdit = async () => {
        editing = !editing;
        console.log("onEdit: ", newHandle, editing);
    };
</script>
<div class="example">
  {#if $wallet}
    <p>{myHandle}</p>
    {#if editing && myHandle.length ==  0 }
        <input type="text" bind:value = {newHandle} placeholder = "@yourhandle" />
        <button disabled= {!newHandle} on:click = {setHandle} >
            <Fa icon={faRotateRight} />
        </button>
    {:else}
        <div >
          
        </div>
    {/if}
    {#if !myHandle}
  
    <div class="buttons">
      Set your handle to claim your first 1000 WALL coins!

      <button on:click={onEdit}>
          <Fa icon="{faPenToSquare}" />
      </button>
  </div>
  {/if}
    <p>Wallet address: <span style="font-size: 0.7em">{$wallet.principal}</span></p>
    <table>
      <tbody>
      {#if $assets}
      <tr>
        <td>
          WALL
        </td>
        <td>
          {myBalance}
        </td>
      </tr>
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

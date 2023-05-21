<script>
  import { useWallet, useBalance } from "@connect2ic/svelte";
  import Fa from 'svelte-fa/src/fa.svelte';
  import { faPaperPlane, faPenToSquare} from '@fortawesome/free-solid-svg-icons';
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
      alert("ERROR: " + result.err);
      console.log("error happened");
    }
    
    console.log(result);
  };

  const onEdit = async () => {
        editing = !editing;
        console.log("onEdit: ", newHandle, editing);
    };
</script>
<div class="box">
  {#if $wallet}
    {#if !myHandle}
    
    <div class="label">
      Set your handle to claim your first 1000 WALL coins!

      <button on:click={onEdit}>
          <Fa icon="{faPenToSquare}" />
      </button>
    </div>
  {/if}
    <p>{myHandle}</p>
    {#if editing && myHandle.length ==  0 }
      <div class="container">
          <input type="text" bind:value = {newHandle} placeholder = "@yourhandle" />
          <button disabled= {!newHandle} on:click = {setHandle} >
              <Fa icon={faPaperPlane} />
          </button>
      </div>
    {:else}
        <div >
          
        </div>
    {/if}

    
    <table>
      {#if $assets}
        <p class= "box-meta">Your wallet: {$wallet.principal}</p>
        <tbody>
          <tr class="bold">
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
        </tbody>
      {/if}
    </table>
  {:else}
    <div></div>
  {/if}
</div>

<style>
	.container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    
  }

	.container input {
		margin-right: 2px;
    width: 100%;
	}
  .bold td{
    font-weight: 900;
  }

  .box {
        border: 1px solid #62676d22;
        display: flex;
        flex-direction: column;
        padding: 10px 20px;
        
        background-color: #F0FFFF;
        box-shadow: 0px -10px 50px #1d2025;
        
        margin: 30px 20% 60px 20%;
    }

    .box .label{
      text-align: center;
    }

    .box-meta {
        display: flex;
        justify-content: space-between;
        padding: 10px 0px;
        margin: 0px;
        font-size: small;
        border-top: 1px solid #dce4ec22;
        padding-bottom: 0px;
        align-self:end;
    }
</style>
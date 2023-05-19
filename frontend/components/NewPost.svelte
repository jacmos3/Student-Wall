
<script>
    import { useCanister } from "@connect2ic/svelte";
    import Fa from 'svelte-fa/src/fa.svelte'
    import { faLocationArrow } from '@fortawesome/free-solid-svg-icons'
    import { createEventDispatcher } from "svelte";
  
  const dispatch = createEventDispatcher();
  
    function refreshCallback() {
        dispatch("callback");
    }

    const [studentwall] = useCanister("studentwall");

    let newPostValue;

    const writeTextMessage = async () => {
        console.log("writeTextMessage: ", newPostValue);
        let result = await $studentwall.writeTextMessage(newPostValue);
        newPostValue = "";
        alert("message created with ID: " + result);
        console.log(result);
        refreshCallback();
    };

</script>

<div class="post-entry">
    <textarea bind:value = {newPostValue} placeholder = "Free your soul, describe which project you are working on; Which is the issue making you crazy? Write your vent if you finally solved it... or not!" />
    <button disabled= {!newPostValue} on:click = {writeTextMessage} >
        <Fa icon={faLocationArrow} />
    </button>
    
</div>

<style>
    .post-entry {
        border: 1px solid #0F0F0F;
        display: flex;
        flex-direction: row;
        padding: 10px 20px;
        font-weight: lighter;
        background-color: #FFFFF0;
        box-shadow: 0px 0px 20px #0F0F0F;
        margin-top: 30px;
        justify-content: space-between;
        align-items: center;
    }
    
    .post-entry textarea {
        display: block;
        flex-basis: 90%;
        background-color: #FFFFF0;
        color: #0F0F0F;
        font-size:large;
        padding: 10px;
        border: 1px solid #0F0F0F;
    }

</style>